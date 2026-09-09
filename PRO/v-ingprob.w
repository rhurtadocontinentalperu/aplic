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

/* Shared Variable Definitions ---                                       */

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHAR.
DEFINE SHARED VARIABLE S-CODMOV   AS INTEGER. 
DEFINE SHARED VARIABLE S-NROSER  AS INTEGER.

DEFINE SHARED TEMP-TABLE ITEM LIKE AlmDMov.
DEFINE TEMP-TABLE ITEM2 LIKE AlmDMov.


/* Local Variable Definitions ---                                       */

DEFINE VARIABLE C-NROFAC       AS CHAR    NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER NO-UNDO.
DEFINE VARIABLE I-NRODOC       AS INTEGER NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHAR    NO-UNDO.
DEFINE VARIABLE R-ROWID        AS ROWID   NO-UNDO. 
DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.

DEFINE BUFFER CMOV FOR AlmCMov.
DEFINE BUFFER DMOV FOR AlmDMov.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE VARIABLE SW-LOG1 AS LOGICAL.
DEFINE VARIABLE X-FACTOR AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-FACTOR AS DECIMAL   NO-UNDO.

DEFINE VARIABLE X-ALMDES AS CHARACTER.

FIND PR-CFGPRO WHERE PR-CFGPRO.Codcia = S-CODCIA 
                     NO-LOCK NO-ERROR.

IF NOT AVAILABLE PR-CFGPRO THEN DO:
   MESSAGE "Registro de Configuracion de Produccion no existe"
           VIEW-AS ALERT-BOX ERROR.
           RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES Almcmov
&Scoped-define FIRST-EXTERNAL-TABLE Almcmov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almcmov.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Almcmov.Observ 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}Observ ~{&FP2}Observ ~{&FP3}
&Scoped-define ENABLED-TABLES Almcmov
&Scoped-define FIRST-ENABLED-TABLE Almcmov
&Scoped-Define ENABLED-OBJECTS RECT-20 
&Scoped-Define DISPLAYED-FIELDS Almcmov.NroRef Almcmov.NroRf3 ~
Almcmov.usuario Almcmov.CodRef Almcmov.Observ Almcmov.NroDoc Almcmov.FchDoc 

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
DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.29 BY 3.85.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Almcmov.NroRef AT ROW 2.54 COL 69.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .69
     Almcmov.NroRf3 AT ROW 3.54 COL 11 COLON-ALIGNED
          LABEL "Salida Material" FORMAT "x(10)"
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .69
          BGCOLOR 15 FGCOLOR 9 
     Almcmov.usuario AT ROW 3.46 COL 69.86 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .69
     Almcmov.CodRef AT ROW 2.54 COL 63.72 NO-LABEL
          VIEW-AS COMBO-BOX INNER-LINES 1
          LIST-ITEMS "OP" 
          SIZE 7.86 BY 1
     Almcmov.Observ AT ROW 2.73 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 49.29 BY .69
     Almcmov.NroDoc AT ROW 1.92 COL 11 COLON-ALIGNED
          LABEL "No. Ingreso"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
          FONT 0
     Almcmov.FchDoc AT ROW 1.23 COL 70.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     RECT-20 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.Almcmov
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
         HEIGHT             = 3.85
         WIDTH              = 85.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX Almcmov.CodRef IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN Almcmov.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN Almcmov.NroRef IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroRf3 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN Almcmov.usuario IN FRAME F-Main
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Orden V-table-Win 
PROCEDURE Actualiza-Orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER FACTOR AS INTEGER.

DEFINE VARIABLE F-Des AS DECIMAL INIT 0 NO-UNDO.
DEFINE VARIABLE F-Dev AS DECIMAL INIT 0 NO-UNDO.
DEFINE VARIABLE C-SIT AS CHARACTER INIT "" NO-UNDO.
DO ON ERROR UNDO, RETURN "ADM-ERROR":
  FOR EACH Almdmov NO-LOCK WHERE Almdmov.CodCia = Almcmov.CodCia 
                            AND  Almdmov.CodAlm = Almcmov.CodAlm 
                            AND  Almdmov.TipMov = Almcmov.TipMov 
                            AND  Almdmov.CodMov = Almcmov.CodMov 
                            AND  Almdmov.NroSer = Almcmov.NroSer 
                            AND  Almdmov.NroDoc = Almcmov.NroDoc
                           ON ERROR UNDO, RETURN "ADM-ERROR":
      FIND PR-ODPCX WHERE PR-ODPCX.CodCia = Almdmov.CodCia AND 
                          PR-ODPCX.NumOrd = TRIM(Almcmov.NroRef) AND 
                          PR-ODPCX.CodArt = Almdmov.CodMat
                          EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE PR-ODPCX THEN
         ASSIGN PR-ODPCX.CanAte = PR-ODPCX.CanAte + (FACTOR * Almdmov.CanDes).
      RELEASE PR-ODPCX.

      FIND PR-ODPC WHERE PR-ODPC.CodCia = Almdmov.CodCia AND 
                         PR-ODPC.NumOrd = TRIM(Almcmov.NroRef) 
                         EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE PR-ODPC THEN
         ASSIGN PR-ODPC.CanAte = PR-ODPC.CanAte + (FACTOR * Almdmov.CanDes).
      RELEASE PR-ODPC.

  END.
END. 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Temporal V-table-Win 
PROCEDURE Actualiza-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH ITEM:
    DELETE ITEM.
END.
IF NOT L-CREA THEN DO:
   FOR EACH Almdmov OF Almcmov NO-LOCK:
       CREATE ITEM.
       RAW-TRANSFER Almdmov TO ITEM.
   END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  {src/adm/template/row-list.i "Almcmov"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almcmov"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Documento V-table-Win 
PROCEDURE Asigna-Documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
   input-var-1 = "A,C,B".
   RUN LKUP\C-OPPEN ("Ordenes de Produccion Pendientes").
   IF output-var-1 = ? THEN RETURN.
   FOR EACH ITEM :
       DELETE ITEM.
   END.
   FIND PR-ODPC WHERE ROWID(PR-ODPC) = output-var-1 NO-LOCK NO-ERROR.
   IF AVAILABLE PR-ODPC THEN DO :
      FOR EACH PR-ODPCX OF PR-ODPC:
        FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                            Almmmatg.Codmat = PR-ODPCX.CodArt NO-LOCK NO-ERROR.
  
        FIND Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                            Almmmate.Codalm = S-CODALM AND
                            Almmmate.Codmat = PR-ODPCX.CodArt NO-LOCK NO-ERROR.
        
        IF NOT AVAILABLE Almmmate THEN DO:
           MESSAGE "Codigo : " + PR-ODPCX.CodArt + " No Asignado al Almacen, Verifique " 
           VIEW-AS ALERT-BOX.
           RETURN.
        END.
        
        CREATE ITEM.
        ASSIGN
           ITEM.Codcia = S-CODCIA 
           ITEM.CodAlm = S-CODALM
           ITEM.Candes = 1
           ITEM.CodMat = PR-ODPCX.CodArt
           ITEM.Factor = 1
           ITEM.Codant = PR-ODPCX.Codfor           
           ITEM.CodUnd = PR-ODPCX.Codund.
        RELEASE ITEM.
               
      END.

      DISPLAY PR-ODPC.NumOrd @ Almcmov.NroRef.
   
   END.

END.

RUN Procesa-Handle IN lh_Handle ('Browse').

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
  FOR EACH Almdmov EXCLUSIVE-LOCK WHERE Almdmov.CodCia = Almcmov.CodCia 
                                   AND  Almdmov.CodAlm = Almcmov.CodAlm 
                                   AND  Almdmov.TipMov = Almcmov.TipMov 
                                   AND  Almdmov.CodMov = Almcmov.CodMov 
                                   AND  Almdmov.NroSer = Almcmov.NroSer 
                                   AND  Almdmov.NroDoc = Almcmov.NroDoc
                                  ON ERROR UNDO, RETURN "ADM-ERROR":
           ASSIGN R-ROWID = ROWID(Almdmov).
           RUN ALM\ALMDCSTK (R-ROWID). /* Descarga del Almacen */
      DELETE Almdmov.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Salida V-table-Win 
PROCEDURE Borra-Salida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND CMOV WHERE CMOV.Codcia = S-CODCIA AND
                  CMOV.CodALm = S-CODALM AND
                  CMOV.TipMov = PR-CFGPRO.TipMov[1] AND
                  CMOV.CodMov = PR-CFGPRO.CodMov[1] AND
                  CMOV.NroDoc = INTEGER(Almcmov.Nrorf3)
                  NO-LOCK NO-ERROR.
  IF AVAILABLE CMOV THEN DO:
                  
    FOR EACH Almdmov EXCLUSIVE-LOCK WHERE Almdmov.CodCia = CMOV.CodCia 
                                     AND  Almdmov.CodAlm = CMOV.CodAlm 
                                     AND  Almdmov.TipMov = CMOV.TipMov 
                                     AND  Almdmov.CodMov = CMOV.CodMov 
                                     AND  Almdmov.NroSer = CMOV.NroSer 
                                     AND  Almdmov.NroDoc = CMOV.NroDoc
                                    ON ERROR UNDO, RETURN "ADM-ERROR":
             ASSIGN R-ROWID = ROWID(Almdmov).
             RUN ALM\ALMDCSTK (R-ROWID). /* Descarga del Almacen */
        DELETE Almdmov.
    END.
    ASSIGN CMOV.FlgEst = 'A'
           CMOV.Observ = "      A   N   U   L   A   D   O       ".
    RELEASE CMOV.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle V-table-Win 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   RUN Borra-Detalle.
   DEF VAR X AS INTEGER.
   FOR EACH ITEM NO-LOCK ON ERROR UNDO, RETURN "ADM-ERROR":
       CREATE almdmov.
       ASSIGN Almdmov.CodCia = Almcmov.CodCia 
              Almdmov.CodAlm = Almcmov.CodAlm 
              Almdmov.TipMov = Almcmov.TipMov 
              Almdmov.Codmov = Almcmov.Codmov               
              Almdmov.NroSer = Almcmov.NroSer
              Almdmov.NroDoc = Almcmov.NroDoc 
              Almdmov.CodMon = Almcmov.CodMon 
              Almdmov.FchDoc = Almcmov.FchDoc 
              Almdmov.TpoCmb = Almcmov.TpoCmb 
              Almdmov.codmat = ITEM.codmat
              Almdmov.CanDes = ITEM.CanDes
              Almdmov.CodUnd = ITEM.CodUnd
              Almdmov.Factor = ITEM.Factor
              Almdmov.CodAjt = '' 
              Almdmov.Flg_factor = ITEM.Flg_factor
              Almdmov.HraDoc     = Almcmov.HorRcp
                     R-ROWID = ROWID(Almdmov).
       RUN ALM\ALMACSTK (R-ROWID).
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
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ).
  /* Code placed here will execute AFTER standard behavior.    */
  L-CREA = YES.
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY @ Almcmov.FchDoc.
    Almcmov.CodRef:SCREEN-VALUE = "OP".
  END.
 
  RUN Actualiza-Temporal.
 
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('Browse').

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
  RUN Numero-Mvto-Almacen.
  ASSIGN Almcmov.CodCia = S-CodCia 
         Almcmov.CodAlm = S-CodAlm 
         Almcmov.TipMov = PR-CFGPRO.TipMov[2]
         Almcmov.CodMov = PR-CFGPRO.CodMov[2] /*S-CodMov */
         Almcmov.NroSer = 000
         Almcmov.NroDoc = I-NRODOC
         Almcmov.FchDoc = TODAY
         Almcmov.CodRef = Almcmov.CodRef:SCREEN-VALUE IN FRAME {&FRAME-NAME}
         Almcmov.NroRef = Almcmov.NroRef:SCREEN-VALUE IN FRAME {&FRAME-NAME}
         Almcmov.NroRf1 = TRIM(Almcmov.CodRef) + TRIM(Almcmov.NroRef)
         Almcmov.TpoCmb = FacCfgGn.Tpocmb[1]
         Almcmov.FlgEst = "P"
         Almcmov.HorRcp = STRING(TIME,"HH:MM:SS")
         Almcmov.usuario = S-USER-ID.

  RUN Genera-Detalle. 
  
  RUN Actualiza-Orden(1).

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
  RUN Procesa-Handle IN lh_Handle ('Pagina1').
  RUN Procesa-Handle IN lh_Handle ('Browse').

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
   DEFINE VAR RPTA AS CHAR.
   
   IF Almcmov.FlgEst <> 'P' THEN DO:
      MESSAGE "Documento no puede ser anulada" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
   END.

    RUN alm/p-ciealm-01 (Almcmov.FchDoc, s-CodAlm).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN "ADM-ERROR".

   DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
      RUN Actualiza-Orden(-1).
      RUN Borra-Detalle.
      /* Solo marcamos el FlgEst como Anulado */
      FIND CMOV WHERE CMOV.CodCia = Almcmov.CodCia 
                 AND  CMOV.CodAlm = Almcmov.CodAlm 
                 AND  CMOV.TipMov = Almcmov.TipMov 
                 AND  CMOV.CodMov = Almcmov.CodMov 
                 AND  CMOV.NroSer = Almcmov.NroSer 
                 AND  CMOV.NroDoc = Almcmov.NroDoc 
                EXCLUSIVE-LOCK NO-ERROR.
      ASSIGN CMOV.FlgEst = 'A'
             CMOV.Observ = "      A   N   U   L   A   D   O       ".
      RELEASE CMOV.
      IF Almcmov.Nrorf3 <> "" THEN DO:
         RUN Borra-Salida. 
      END.
      
   END.
   
   RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
   RUN Procesa-Handle IN lh_Handle ('Browse').
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  IF Almcmov.FlgEst = "A" THEN RETURN.
   
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'Imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  IF AVAILABLE Almcmov THEN RUN ALM\R-IMPFMT.R(ROWID(almcmov)).

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
  
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse'). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Numero-Mvto-Almacen V-table-Win 
PROCEDURE Numero-Mvto-Almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
                AND  Almacen.CodAlm = S-CODALM 
               EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE Almacen THEN DO:
     ASSIGN I-NroDoc = Almacen.CorrIng.
     ASSIGN Almacen.CorrIng = Almacen.CorrIng + 1.
  END.
  RELEASE Almacen.
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
  {src/adm/template/snd-list.i "Almcmov"}

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
     L-CREA = NO.
     RUN Actualiza-Temporal.   
     RUN Procesa-Handle IN lh_Handle ('Pagina2').
     RUN Procesa-Handle IN lh_Handle ('browse').
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

   DEF VAR X AS INTEGER.
   X = 0.
   FOR EACH ITEM NO-LOCK ON ERROR UNDO, RETURN "ADM-ERROR":
    X = X + 1.
   END.
   IF X = 0 THEN DO:
      MESSAGE "Debe de asignar al menos un Item" 
      VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcmov.Observ.
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
RETURN "ADM-ERROR".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


