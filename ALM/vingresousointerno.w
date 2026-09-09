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
DEFINE SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR pv-codcia AS INT.
DEFINE SHARED VAR cl-codcia AS INT.
DEFINE SHARED VAR S-USER-ID AS CHAR. 
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-NROSER  AS INTEGER.

DEFINE        VAR I-CODMON AS INTEGER NO-UNDO.
DEFINE        VAR R-ROWID  AS ROWID   NO-UNDO.
DEFINE        VAR L-CREA   AS LOGICAL NO-UNDO.

DEFINE BUFFER TDOCM FOR Almtdocm.
DEFINE BUFFER CMOV  FOR Almcmov.
DEFINE BUFFER DMOV  FOR Almdmov.
DEFINE SHARED TEMP-TABLE ITEM LIKE almdmov.

DEFINE SHARED VARIABLE ORDTRB    AS CHAR.

DEFINE SHARED VAR s-status-almacen AS LOG.

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
&Scoped-define EXTERNAL-TABLES Almcmov Almtdocm
&Scoped-define FIRST-EXTERNAL-TABLE Almcmov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almcmov, Almtdocm.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Almcmov.CodRef Almcmov.NroRef Almcmov.CodMon ~
Almcmov.Observ Almcmov.TpoCmb Almcmov.NroRf1 Almcmov.NroRf2 
&Scoped-define ENABLED-TABLES Almcmov
&Scoped-define FIRST-ENABLED-TABLE Almcmov
&Scoped-Define DISPLAYED-FIELDS Almcmov.NroDoc Almcmov.usuario ~
Almcmov.FchDoc Almcmov.CodRef Almcmov.NroRef Almcmov.CodMon Almcmov.Observ ~
Almcmov.TpoCmb Almcmov.NroRf1 Almcmov.NroRf2 
&Scoped-define DISPLAYED-TABLES Almcmov
&Scoped-define FIRST-DISPLAYED-TABLE Almcmov
&Scoped-Define DISPLAYED-OBJECTS F-Estado 

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
DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 16.72 BY .81
     FONT 6 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Almcmov.NroDoc AT ROW 1.19 COL 12 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .81
          FONT 0
     F-Estado AT ROW 1.19 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     Almcmov.usuario AT ROW 1.19 COL 48 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     Almcmov.FchDoc AT ROW 1.19 COL 72 COLON-ALIGNED FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .81
     Almcmov.CodRef AT ROW 1.96 COL 12 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
          BGCOLOR 11 FGCOLOR 0 
     Almcmov.NroRef AT ROW 1.96 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 FGCOLOR 0 
     Almcmov.CodMon AT ROW 1.96 COL 74 NO-LABEL WIDGET-ID 10
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12 BY .81
     Almcmov.Observ AT ROW 2.73 COL 12 COLON-ALIGNED FORMAT "X(100)"
          VIEW-AS FILL-IN 
          SIZE 47 BY .81
          BGCOLOR 11 FGCOLOR 0 FONT 7
     Almcmov.TpoCmb AT ROW 2.92 COL 73 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     Almcmov.NroRf1 AT ROW 3.5 COL 12 COLON-ALIGNED
          LABEL "Referencia 1"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 FGCOLOR 0 
     Almcmov.NroRf2 AT ROW 4.27 COL 12 COLON-ALIGNED
          LABEL "Referencia 2"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 FGCOLOR 0 
     "Moneda :" VIEW-AS TEXT
          SIZE 6.57 BY .69 AT ROW 1.96 COL 67 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.Almcmov,integral.Almtdocm
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
         HEIGHT             = 4.85
         WIDTH              = 89.43.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.FchDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almcmov.NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroRf1 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroRf2 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almcmov.Observ IN FRAME F-Main
   EXP-FORMAT                                                           */
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Almcmov.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.CodMon V-table-Win
ON ENTRY OF Almcmov.CodMon IN FRAME F-Main /* Cod!mon */
DO:
  IF I-CODMON <> 3 THEN DO:
/*     ASSIGN Almcmov.CodMon:SCREEN-VALUE= STRING(I-CODMON,'9').*/
/*   ASSIGN Almcmov.CodMon.*/
     APPLY "ENTRY" TO Almcmov.TpoCmb.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.FchDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.FchDoc V-table-Win
ON LEAVE OF Almcmov.FchDoc IN FRAME F-Main /* Fecha */
DO:
  FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= INPUT Almcmov.FchDoc NO-LOCK NO-ERROR.
  IF AVAILABLE gn-tcmb THEN DISPLAY gn-tcmb.compra @ Almcmov.TpoCmb WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.NroRf1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.NroRf1 V-table-Win
ON LEFT-MOUSE-DBLCLICK OF Almcmov.NroRf1 IN FRAME F-Main /* Referencia 1 */
DO:
  IF NOT (almtdocm.codmov = 10) THEN RETURN NO-APPLY.
  ASSIGN
    input-var-1 = s-codalm
    input-var-2 = 'S'
    input-var-3 = '10'
    output-var-1 = ?
    output-var-2 = ''
    output-var-3 = ''.
  RUN lkup/c-movalm ('Salidas de Muestras Retornables').
  IF output-var-1 <> ?
  THEN DO:
    FIND CMOV WHERE ROWID(CMOV) = output-var-1 NO-LOCK NO-ERROR.
    SELF:SCREEN-VALUE = STRING(CMOV.nroser, '999') + STRING(CMOV.nrodoc, '999999').
    RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.TpoCmb V-table-Win
ON ENTRY OF Almcmov.TpoCmb IN FRAME F-Main /* Tipo de cambio */
DO:
  Almcmov.TpoCmb:SENSITIVE = NO.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-ITEM V-table-Win 
PROCEDURE Actualiza-ITEM :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE ITEM.
IF NOT L-CREA THEN DO:
    FOR EACH Almdmov OF Almcmov NO-LOCK:
       CREATE ITEM.
       BUFFER-COPY Almdmov TO ITEM.
   END.
END.

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
  {src/adm/template/row-list.i "Almcmov"}
  {src/adm/template/row-list.i "Almtdocm"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almcmov"}
  {src/adm/template/row-find.i "Almtdocm"}

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
  FOR EACH Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia 
      AND  Almdmov.CodAlm = Almcmov.CodAlm 
      AND  Almdmov.TipMov = Almcmov.TipMov 
      AND  Almdmov.CodMov = Almcmov.CodMov 
      AND  Almdmov.NroSer = Almcmov.NroSer 
      AND  Almdmov.NroDoc = Almcmov.NroDoc
      ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
    ASSIGN R-ROWID = ROWID(Almdmov).
    RUN ALM\ALMDCSTK (R-ROWID).      /* Descarga del Almacen */
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    RUN ALM\ALMACPR1 (R-ROWID,"D").        
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.     
    /* RHC 03.04.04 BLOQUEADO, SE ACTUALIZA EN LA NOCHE 
    RUN ALM\ALMACPR2 (R-ROWID,"D").
    *************************************************** */
    DELETE Almdmov.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Control-Paginas V-table-Win 
PROCEDURE Control-Paginas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER TpoEvt AS INTEGER.
  FIND FIRST Almtmovm WHERE Almtmovm.CodCia = Almtdocm.CodCia 
                       AND  Almtmovm.Tipmov = Almtdocm.TipMov 
                       AND  Almtmovm.Codmov = Almtdocm.CodMov 
                      NO-LOCK NO-ERROR.
  IF TpoEvt = 1 THEN DO:
     IF AVAILABLE Almtmovm AND Almtmovm.PidPCo THEN 
          RUN Procesa-Handle IN lh_Handle ('Pagina2').
     ELSE RUN Procesa-Handle IN lh_Handle ('Pagina4').
    /* RHC 26.10.04 */
    IF AVAILABLE Almtmovm
        AND Almtmovm.TipMov = 'I'
        AND Almtmovm.CodMov = 10
    THEN RUN Procesa-Handle IN lh_Handle ('Pagina5').
  END.
  ELSE DO:
     IF AVAILABLE Almtmovm AND Almtmovm.PidPCo THEN 
          RUN Procesa-Handle IN lh_Handle ('Pagina1').
     ELSE RUN Procesa-Handle IN lh_Handle ('Pagina3').
  END.
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
  DEFINE VAR F-PesUnd AS DECIMAL NO-UNDO.
   
  FOR EACH ITEM WHERE ITEM.codmat <> "" ON ERROR UNDO, RETURN "ADM-ERROR":
       CREATE almdmov.
       ASSIGN Almdmov.CodCia = Almcmov.CodCia 
              Almdmov.CodAlm = Almcmov.CodAlm 
              Almdmov.TipMov = Almcmov.TipMov 
              Almdmov.CodMov = Almcmov.CodMov 
              Almdmov.NroSer = Almcmov.NroSer 
              Almdmov.NroDoc = Almcmov.NroDoc 
              Almdmov.CodMon = Almcmov.CodMon 
              Almdmov.FchDoc = Almcmov.FchDoc 
              Almdmov.TpoCmb = Almcmov.TpoCmb
              Almdmov.codmat = ITEM.codmat
              Almdmov.CanDes = ITEM.CanDes
              Almdmov.CodUnd = ITEM.CodUnd
              Almdmov.Factor = ITEM.Factor
              Almdmov.ImpCto = ITEM.ImpCto
              Almdmov.PreUni = ITEM.PreUni
              Almdmov.Pesmat = ITEM.Pesmat
              Almdmov.CodAjt = ''
              Almdmov.HraDoc = Almcmov.HorRcp
                     R-ROWID = ROWID(Almdmov).
       FIND FIRST Almtmovm WHERE Almtmovm.CodCia = Almcmov.CodCia 
                            AND  Almtmovm.Tipmov = Almcmov.TipMov 
                            AND  Almtmovm.Codmov = Almcmov.CodMov 
                           NO-LOCK NO-ERROR.
       IF AVAILABLE Almtmovm AND Almtmovm.PidPCo 
       THEN ASSIGN Almdmov.CodAjt = "A".
       ELSE ASSIGN Almdmov.CodAjt = ''.
       RUN ALM\ALMACSTK (R-ROWID).
       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
       RUN ALM\ALMACPR1 (R-ROWID,"U").
       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. 
       /* RHC 03.04.04 BLOQUEADO, SE ACTUALIZA EN LA NOCHE
       RUN ALM\ALMACPR2 (R-ROWID,"U").
       *************************************************** */
       /* Actualiza el Peso del Material  */
       FIND Almmmatg WHERE Almmmatg.codcia = s-codcia 
                      AND  Almmmatg.codmat = ITEM.Codmat 
                     NO-LOCK NO-ERROR.
       IF AVAILABLE Almmmatg AND Almmmatg.Pesmat > 0 
       THEN DO:
          FIND CURRENT Almmmatg EXCLUSIVE-LOCK NO-ERROR.
          IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
          F-PesUnd = ROUND(ITEM.Pesmat / (ITEM.Candes * ITEM.Factor) * 1000, 3).
          IF ABS((F-PesUnd * 100 / Almmmatg.Pesmat) - 100) <= 4 
          THEN ASSIGN Almmmatg.Pesmat = F-PesUnd.
          RELEASE Almmmatg.
       END.
  END.
  RUN Procesa-Handle IN lh_Handle ('browse').
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-i10 V-table-Win 
PROCEDURE Graba-i10 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF NOT (Almtdocm.tipmov = 'I' AND Almtdocm.codmov = 10) THEN RETURN.
  
  FIND CMOV WHERE CMOV.codcia = almcmov.codcia
    AND CMOV.codalm = almcmov.codalm
    AND CMOV.tipmov = 'S'
    AND CMOV.codmov = 10
    AND CMOV.nroser = INTEGER(SUBSTRING(almcmov.nrorf1,1,3))
    AND CMOV.nrodoc = INTEGER(SUBSTRING(almcmov.nrorf1,4,6))
    EXCLUSIVE-LOCK NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN 'ADM-ERROR'.
  FOR EACH Almdmov OF Almcmov NO-LOCK:
    FIND DMOV OF CMOV WHERE DMOV.codmat = almdmov.codmat
        EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE DMOV
    THEN DMOV.candev = DMOV.candev + Almdmov.candes.
    RELEASE DMOV.
  END.
  ASSIGN
    CMOV.FlgSit = 'R'.
  FOR EACH DMOV OF CMOV NO-LOCK:
    IF DMOV.CanDes > DMOV.CanDev THEN CMOV.FlgEst = ''.
  END.
  RELEASE CMOV.
  
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
  IF s-status-almacen = NO THEN DO:
      MESSAGE 'Almacén INACTIVO' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  /* CONTROL DE SERIES */
  FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
        AND Almacen.CodAlm = Almtdocm.CodAlm 
        NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almacen THEN DO:
        MESSAGE 'Error en la serie' s-NroSer
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  L-CREA = YES.
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY @ Almcmov.FchDoc Almacen.CorrIng @ Almcmov.NroDoc.
     FIND LAST gn-tcmb NO-LOCK NO-ERROR.
     IF AVAILABLE gn-tcmb THEN DISPLAY gn-tcmb.compra @ Almcmov.TpoCmb.
     RUN Actualiza-ITEM.
     RUN Control-Paginas (1).
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
  IF L-CREA THEN DO :
    ASSIGN Almcmov.CodCia  = Almtdocm.CodCia 
           Almcmov.CodAlm  = Almtdocm.CodAlm 
           Almcmov.TipMov  = Almtdocm.TipMov
           Almcmov.CodMov  = Almtdocm.CodMov
           Almcmov.NroSer  = 000
           Almcmov.HorRcp  = STRING(TIME,"HH:MM:SS").
    /* RHC 30.03.2011 Control de VB del Administrador */
    FIND FIRST Almtmovm WHERE Almtmovm.CodCia = Almcmov.CodCia 
        AND  Almtmovm.Tipmov = Almcmov.TipMov 
        AND  Almtmovm.Codmov = Almcmov.CodMov 
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtmovm AND Almtmovm.Indicador[2] = YES THEN Almcmov.FlgEst = "X".
    /* ******************************** */
    FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
        AND  Almacen.CodAlm = Almtdocm.CodAlm 
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN 
        Almcmov.NroDoc = Almacen.CorrIng
        Almacen.CorrIng = Almacen.CorrIng + 1.
    RELEASE Almacen.
    DISPLAY Almcmov.NroDoc @ Almcmov.NroDoc WITH FRAME {&FRAME-NAME}.
  END.
  ASSIGN Almcmov.usuario = S-USER-ID.
  
  /* ELIMINAMOS EL DETALLE ANTERIOR */
  RUN Borra-Detalle.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  
  /* GENERAMOS NUEVO DETALLE */
  RUN Genera-Detalle.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  
  RUN Control-Paginas (2).
  
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

  RUN Control-Paginas (2).

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
  RUN valida-update.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
    
  /* consistencia de la fecha del cierre del sistema */
  DEF VAR dFchCie AS DATE.

  IF s-user-id <> "ADMIN" THEN DO:
      RUN gn/fecha-de-cierre (OUTPUT dFchCie).
      IF almcmov.fchdoc <= dFchCie THEN DO:
          MESSAGE 'NO se puede anular ningun documento antes del' (dFchCie + 1)
              VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.
  END.
  /* fin de consistencia */
  
  /* Solo marcamos el FlgEst como Anulado */
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
    /* INGRESO DE MUESTRAS RETORNABLES */
    RUN Extorna-i10.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    /* ******************************* */

    FIND CMOV WHERE CMOV.CodCia = Almcmov.CodCia 
               AND  CMOV.CodAlm = Almcmov.CodAlm 
               AND  CMOV.TipMov = Almcmov.TipMov 
               AND  CMOV.CodMov = Almcmov.CodMov 
               AND  CMOV.NroSer = Almcmov.NroSer 
               AND  CMOV.NroDoc = Almcmov.NroDoc 
              EXCLUSIVE-LOCK NO-ERROR.
   IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
     
   /* Eliminamos el detalle */
    RUN Borra-Detalle.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    ASSIGN CMOV.FlgEst = 'A'
            CMOV.Observ = "      A   N   U   L   A   D   O       "
            CMOV.Usuario = S-USER-ID.
    RELEASE CMOV.
    IF AVAILABLE(almdmov) THEN RELEASE almdmov.
    IF AVAILABLE(almmmate) THEN RELEASE almmmate.
  END.
  /* refrescamos los datos del viewer */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  /* refrescamos los datos del browse */
  RUN Procesa-Handle IN lh_Handle ('browse').

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
  /* Buscamos en la tabla de movimientos y pedimos datos segun lo configurado*/
  FIND FIRST Almtmovm WHERE Almtmovm.CodCia = Almtdocm.CodCia 
      AND  Almtmovm.Tipmov = Almtdocm.TipMov 
      AND  Almtmovm.Codmov = Almtdocm.CodMov 
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almtmovm THEN DO WITH FRAME {&FRAME-NAME}:
      ASSIGN 
          Almcmov.NroRf1:VISIBLE = Almtmovm.PidRef1
          Almcmov.NroRf2:VISIBLE = Almtmovm.PidRef2
          I-CODMON = Almtmovm.CodMon.
      IF Almtmovm.CodMon <> 3 THEN DO:
          ASSIGN Almcmov.CodMon:SCREEN-VALUE = STRING(Almtmovm.CodMon,'9').
      END.
      IF Almtmovm.PidRef1 THEN ASSIGN Almcmov.NroRf1:LABEL = Almtmovm.GloRf1.
      IF Almtmovm.PidRef2 THEN ASSIGN Almcmov.NroRf2:LABEL = Almtmovm.GloRf2.
      IF Almtdocm.TipMov = "S" THEN DO:
          ASSIGN 
              Almcmov.TpoCmb:VISIBLE = NO
              Almcmov.CodMon:SCREEN-VALUE = '1'.
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Almcmov THEN DO WITH FRAME {&FRAME-NAME}:
     F-Estado:SCREEN-VALUE = "".
     CASE Almcmov.FlgEst:
         WHEN "A" THEN F-Estado:SCREEN-VALUE = "ANULADO".
         WHEN "X" THEN F-Estado:SCREEN-VALUE = "FALTA VºBº".
         WHEN "C" THEN F-Estado:SCREEN-VALUE = "CON VºBº".
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
      ASSIGN
          Almcmov.CodRef:SENSITIVE = NO
          Almcmov.NroRef:SENSITIVE = NO.
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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  IF AVAILABLE Almcmov THEN RUN ALM\R-IMPFMT-1.R(ROWID(almcmov)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
  
  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ).

  /* Code placed here will execute AFTER standard behavior.    */
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
  
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
  {src/adm/template/snd-list.i "Almcmov"}
  {src/adm/template/snd-list.i "Almtdocm"}

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

  IF p-state = 'update-begin':U THEN RUN valida-update.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN ERROR.
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  IF p-state = 'update-begin':U THEN DO:
     L-CREA = NO.
     RUN Actualiza-ITEM.
     RUN Control-Paginas (1).
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
DEFINE VARIABLE N-ITEM AS DECIMAL NO-UNDO INIT 0.
DO WITH FRAME {&FRAME-NAME} :
   FOR EACH ITEM NO-LOCK:
       N-ITEM = N-ITEM + ITEM.CanDes.
   END.
   IF N-ITEM = 0 THEN DO:
      MESSAGE "No existen ITEMS a generar" VIEW-AS ALERT-BOX ERROR.
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
  Purpose:     
  Parameters:  <none>
  Notes:      
------------------------------------------------------------------------------*/

  IF s-status-almacen = NO THEN DO:
      MESSAGE 'Almacén INACTIVO' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.

  DEFINE VAR RPTA AS CHAR.

  IF NOT AVAILABLE Almcmov THEN  RETURN "ADM-ERROR".
  IF Almcmov.FlgEst = 'A' THEN DO:
      MESSAGE "Documento Anulado" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  IF s-user-id <> "ADMIN" THEN DO:
      RUN alm/p-ciealm-01 (Almcmov.FchDoc, s-CodAlm).
      IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN "ADM-ERROR".
      FIND Almacen WHERE 
          Almacen.CodCia = S-CODCIA AND  
          Almacen.CodAlm = S-CODALM 
          NO-LOCK NO-ERROR.
      RUN ALM/D-CLAVE.R(Almacen.Clave,OUTPUT RPTA).
      IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
      /* consistencia de la fecha del cierre del sistema */
      DEF VAR dFchCie AS DATE.
      RUN gn/fecha-de-cierre (OUTPUT dFchCie).
      IF almcmov.fchdoc <= dFchCie THEN DO:
          MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
              VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.
  END.
  /* fin de consistencia */
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

