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

/* Shared Variable Definitions ---                                       */

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE cl-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHAR.
DEFINE SHARED VARIABLE S-CODMOV   AS INTEGER. 

DEFINE SHARED TEMP-TABLE DMOV LIKE AlmDMov.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE C-NroDoc       AS CHAR    NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER NO-UNDO.
DEFINE VARIABLE I-NRODOC       AS INTEGER NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHAR    NO-UNDO.
DEFINE VARIABLE R-ROWID        AS ROWID   NO-UNDO. 

DEFINE BUFFER CMOV FOR AlmCMov.

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV NO-LOCK NO-ERROR.
     
IF AVAILABLE FacCorre THEN ASSIGN I-NroSer = FacCorre.NroSer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

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
&Scoped-define EXTERNAL-TABLES Almcmov
&Scoped-define FIRST-EXTERNAL-TABLE Almcmov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almcmov.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Almcmov.CodCli Almcmov.Observ 
&Scoped-define ENABLED-TABLES Almcmov
&Scoped-define FIRST-ENABLED-TABLE Almcmov
&Scoped-Define ENABLED-OBJECTS RECT-21 RECT-20 
&Scoped-Define DISPLAYED-FIELDS Almcmov.NroRf2 Almcmov.FchDoc ~
Almcmov.NroDoc Almcmov.CodCli Almcmov.NroRf1 Almcmov.CodMon Almcmov.Observ 
&Scoped-define DISPLAYED-TABLES Almcmov
&Scoped-define FIRST-DISPLAYED-TABLE Almcmov
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_RucCli FILL-IN_NomCli ~
FILL-IN_DirCli 

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
DEFINE VARIABLE FILL-IN_DirCli AS CHARACTER FORMAT "x(60)" 
     LABEL "Direccion" 
     VIEW-AS FILL-IN 
     SIZE 49.29 BY .69.

DEFINE VARIABLE FILL-IN_NomCli AS CHARACTER FORMAT "x(50)" 
     VIEW-AS FILL-IN 
     SIZE 37.29 BY .69.

DEFINE VARIABLE FILL-IN_RucCli AS CHARACTER FORMAT "x(10)" 
     LABEL "Ruc" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82.43 BY 3.92.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 12.57 BY .85.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Almcmov.NroRf2 AT ROW 1.23 COL 11 COLON-ALIGNED
          LABEL "Devolucion No" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .69
          FONT 1
     Almcmov.FchDoc AT ROW 1.23 COL 68 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Almcmov.NroDoc AT ROW 1.92 COL 11 COLON-ALIGNED
          LABEL "No.Ingreso"
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .69
          FONT 1
     FILL-IN_RucCli AT ROW 1.92 COL 68 COLON-ALIGNED
     Almcmov.CodCli AT ROW 2.62 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .69
     FILL-IN_NomCli AT ROW 2.62 COL 23 COLON-ALIGNED NO-LABEL
     Almcmov.NroRf1 AT ROW 2.62 COL 68 COLON-ALIGNED
          LABEL "Guia" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     FILL-IN_DirCli AT ROW 3.31 COL 11 COLON-ALIGNED
     Almcmov.CodMon AT ROW 3.46 COL 70.43 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.43 BY .5
     Almcmov.Observ AT ROW 4 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 49.29 BY .69
     "Moneda" VIEW-AS TEXT
          SIZE 6.14 BY .5 AT ROW 3.42 COL 63.43
     RECT-21 AT ROW 3.31 COL 69.86
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 4
         WIDTH              = 82.43.
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

/* SETTINGS FOR RADIO-SET Almcmov.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DirCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_RucCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN Almcmov.NroRf1 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN Almcmov.NroRf2 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
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

&Scoped-define SELF-NAME Almcmov.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.CodCli V-table-Win
ON LEAVE OF Almcmov.CodCli IN FRAME F-Main /* Cliente */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
        gn-clie.CodCli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-clie  THEN DO:
      MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   DISPLAY gn-clie.NomCli @ FILL-IN_NomCli 
           gn-clie.Ruc    @ FILL-IN_RucCli  
           gn-clie.DirCli @ FILL-IN_DirCli WITH FRAME {&FRAME-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Guia V-table-Win 
PROCEDURE Actualiza-Guia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER I-PAR AS INTEGER.
  DEFINE BUFFER B-DMOV FOR AlmDMov. 
  DEFINE VARIABLE F-IMPORT AS DECIMAL INIT 0 NO-UNDO.
  FIND CcbCDocu WHERE CcbCDocu.CodCia = S-CODCIA AND
       CcbCDocu.CodDoc = "G/R" AND
       CcbCDocu.NroDoc = Almcmov.NroRf1 EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE CcbCDocu THEN DO ON ERROR UNDO, RETURN "ADM-ERROR":
     FOR EACH B-DMOV NO-LOCK WHERE 
              B-DMOV.CodCia = Almcmov.CodCia AND
              B-DMOV.CodAlm = Almcmov.CodAlm AND
              B-DMOV.TipMov = Almcmov.TipMov AND
              B-DMOV.CodMov = Almcmov.CodMov AND
              B-DMOV.NroSer = Almcmov.NroSer AND
              B-DMOV.NroDoc = Almcmov.NroDoc
              ON ERROR UNDO, RETURN "ADM-ERROR":
         F-IMPORT = F-IMPORT + DMOV.ImpLin.
         FIND Almdmov WHERE 
              Almdmov.CodCia = CcbCDocu.CodCia AND
              Almdmov.CodAlm = CcbCDocu.CodAlm AND
              Almdmov.TipMov = "S"             AND
              Almdmov.CodMov = CcbCDocu.CodMov AND
              Almdmov.NroSer = INTEGER(SUBSTRING(CcbCDocu.NroDoc,1,3)) AND
              Almdmov.NroDoc = INTEGER(SUBSTRING(CcbCDocu.NroDoc,4,6)) AND
              Almdmov.CodMat = B-DMOV.CodMat 
              EXCLUSIVE-LOCK NO-ERROR.
         IF AVAILABLE Almdmov THEN ASSIGN Almdmov.CanDev = Almdmov.CanDev + (I-PAR * B-DMOV.CanDes).
         RELEASE Almdmov.
     END.
     ASSIGN CcbCDocu.SdoAct = CcbCDocu.SdoAct - (I-PAR * F-IMPORT).
  END.
  RELEASE CcbCDocu.
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
FOR EACH DMOV:
    DELETE DMOV.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Detalle V-table-Win 
PROCEDURE Borra-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH Almdmov EXCLUSIVE-LOCK WHERE 
           Almdmov.CodCia = Almcmov.CodCia AND
           Almdmov.CodAlm = Almcmov.CodAlm AND
           Almdmov.TipMov = Almcmov.TipMov AND
           Almdmov.CodMov = Almcmov.CodMov AND
           Almdmov.NroSer = Almcmov.NroSer AND
           Almdmov.NroDoc = Almcmov.NroDoc
           ON ERROR UNDO, RETURN "ADM-ERROR":
           ASSIGN R-ROWID = ROWID(Almdmov).
           RUN ALM\ALMDCSTK (R-ROWID). /* Descarga del Almacen */
           /*
           RUN ALM\ALMACPR1 (R-ROWID,"D").
           RUN ALM\ALMACPR2 (R-ROWID,"D").
           */
      DELETE Almdmov.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle V-table-Win 
PROCEDURE Carga-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
   IF Almcmov.CodCli:SCREEN-VALUE = "" THEN DO:
     MESSAGE "Debe registrar al cliente" VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
   END.
   IF NOT Almcmov.CodCli:SENSITIVE THEN DO:
      MESSAGE "Solo puede asignar una vez" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
   END.
   C-NRODOC = "".
   input-var-1 = "G/R".
   input-var-2 = Almcmov.CodCli:SCREEN-VALUE.
   input-var-3 = "P".
   RUN LKUP\C-docgen.r ("Guias de Remision Pendientes").
   IF output-var-1 <> ? THEN DO:
      FIND CcbCDocu WHERE ROWID(CcbCDocu) = output-var-1 NO-LOCK NO-ERROR.
      C-NRODOC = CcbCDocu.NroDoc.
      FOR EACH Almdmov WHERE 
               Almdmov.CodCia = CcbCDocu.CodCia
           AND Almdmov.CodAlm = CcbCDocu.CodAlm
           AND Almdmov.TipMov = "S"
           AND Almdmov.CodMov = CcbCDocu.CodMov
           AND Almdmov.NroSer = INTEGER(SUBSTRING(CcbCDocu.NroDoc,1,3)) 
           AND Almdmov.NroDoc = INTEGER(SUBSTRING(CcbCDocu.NroDoc,4,6)) 
           NO-LOCK:
          IF (Almdmov.CanDes - Almdmov.CanDev) > 0 THEN DO:
             CREATE DMOV.
             ASSIGN DMOV.CodCia = Almdmov.CodCia 
                    DMOV.CodAlm = Almdmov.CodAlm 
                    DMOV.codmat = Almdmov.codmat 
                    DMOV.PreUni = Almdmov.PreUni 
                    DMOV.CanDes = Almdmov.CanDes - Almdmov.CanDev
                    DMOV.CanDev = Almdmov.CanDes - Almdmov.CanDev
                    DMOV.Factor = Almdmov.Factor 
                    DMOV.CodUnd = Almdmov.CodUnd 
                    DMOV.PreBas = Almdmov.PreBas 
                    DMOV.PorDto = Almdmov.PorDto 
                    DMOV.ImpLin = Almdmov.ImpLin 
                    DMOV.ImpIsc = Almdmov.ImpIsc 
                    DMOV.ImpIgv = Almdmov.ImpIgv 
                    DMOV.ImpDto = Almdmov.ImpDto 
                    DMOV.AftIsc = Almdmov.AftIsc 
                    DMOV.AftIgv = Almdmov.AftIgv.
          END.
      END.
   END.
   Almcmov.CodCli:SENSITIVE = NO.
   RUN Procesa-Handle IN lh_Handle ('browse'). 
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
   RUN Borra-Detalle.
   FOR EACH DMOV NO-LOCK ON ERROR UNDO, RETURN "ADM-ERROR":
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
              Almdmov.codmat = DMOV.codmat
              Almdmov.CanDes = DMOV.CanDes
              Almdmov.CodUnd = DMOV.CodUnd
              Almdmov.Factor = DMOV.Factor
              Almdmov.ImpCto = DMOV.ImpCto
              Almdmov.PreUni = DMOV.PreUni
              Almdmov.CodAjt = '' 
              Almdmov.PreBas = DMOV.PreBas 
              Almdmov.PorDto = DMOV.PorDto 
              Almdmov.ImpLin = DMOV.ImpLin 
              Almdmov.ImpIsc = DMOV.ImpIsc 
              Almdmov.ImpIgv = DMOV.ImpIgv 
              Almdmov.ImpDto = DMOV.ImpDto 
              Almdmov.AftIsc = DMOV.AftIsc 
              Almdmov.AftIgv = DMOV.AftIgv 
                     R-ROWID = ROWID(Almdmov).
       RUN ALM\ALMACSTK (R-ROWID).
       /*
       RUN ALM\ALMACPR1 (R-ROWID,"U").
       RUN ALM\ALMACPR2 (R-ROWID,"U").
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
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  RUN Numero-de-Documento(NO).
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY @ Almcmov.FchDoc
             STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999") @ Almcmov.NroRf2. 
  END.
  C-NRODOC = "".
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
         Almcmov.TipMov = "I"
         Almcmov.CodMov = S-CodMov 
         Almcmov.NroSer = 000
         Almcmov.NroDoc = I-NRODOC
         Almcmov.FchDoc = TODAY
         Almcmov.CodRef = "G/R"
         Almcmov.NroRf1 = C-NroDoc
         Almcmov.TpoCmb = FacCfgGn.Tpocmb[1]
         Almcmov.usuario = S-USER-ID.
  RUN Numero-de-Documento(YES).
  ASSIGN Almcmov.NroRf2 = STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999").
  FIND CcbCDocu WHERE CcbCDocu.CodCia = S-CODCIA AND
       CcbCDocu.CodDoc = "G/R" AND
       CcbCDocu.NroDoc = Almcmov.NroRf1 NO-LOCK NO-ERROR.
  IF AVAILABLE CcbCDocu THEN DO:
     ASSIGN Almcmov.CodCli = CcbCDocu.CodCli
            Almcmov.CodMon = CcbCDocu.CodMon
            Almcmov.CodVen = CcbCDocu.CodVen.
  END.       

  RUN Genera-Detalle.  /* Detalle de la Guia */ 

  RUN Actualiza-Guia(1).

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
   IF Almcmov.FlgEst <> 'P' THEN DO:
      MESSAGE "Devolucion no puede ser anulada" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
   END.

    RUN alm/p-ciealm-01 (Almcmov.FchDoc, Almcmov.CodAlm).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
   
   DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
      RUN Actualiza-Guia(-1).
      RUN Borra-Detalle.
      /* Solo marcamos el FlgEst como Anulado */
      FIND CMOV WHERE CMOV.CodCia = Almcmov.CodCia AND
           CMOV.CodAlm = Almcmov.CodAlm AND
           CMOV.TipMov = Almcmov.TipMov AND
           CMOV.CodMov = Almcmov.CodMov AND
           CMOV.NroSer = Almcmov.NroSer AND
           CMOV.NroDoc = Almcmov.NroDoc EXCLUSIVE-LOCK NO-ERROR.
      ASSIGN CMOV.FlgEst = 'A'
             CMOV.Observ = "      A   N   U   L   A   D   O       ".
      RELEASE CMOV.
   END.
   RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
   RUN Procesa-Handle IN lh_Handle ('Browse').

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
  IF AVAILABLE Almcmov THEN DO WITH FRAME {&FRAME-NAME}:
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
          gn-clie.CodCli = Almcmov.CodCli NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie  THEN 
        DISPLAY gn-clie.NomCli @ FILL-IN_NomCli 
                gn-clie.Ruc    @ FILL-IN_RucCli 
                gn-clie.DirCli @ FILL-IN_DirCli.
  END.
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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

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
  
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse'). 
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Numero-de-Documento V-table-Win 
PROCEDURE Numero-de-Documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER L-INCREMENTA AS LOGICAL.
  IF L-INCREMENTA THEN 
     FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = S-CODDOC AND
          FacCorre.CodDiv = S-CODDIV EXCLUSIVE-LOCK NO-ERROR.
  ELSE
     FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = S-CODDOC AND
          FacCorre.CodDiv = S-CODDIV NO-LOCK NO-ERROR.
  
  IF AVAILABLE FacCorre THEN DO:
     ASSIGN I-NroDoc = FacCorre.Correlativo.
     IF L-INCREMENTA THEN ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
  END.
  RELEASE FacCorre.
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
  FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
       Almacen.CodAlm = S-CODALM EXCLUSIVE-LOCK NO-ERROR.
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
   IF Almcmov.CodCli:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcmov.CodCli.
      RETURN "ADM-ERROR".   
   END.
   IF C-NRODOC = "" THEN DO:
      MESSAGE "No asigno ninguna  guia de remision" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcmov.CodCli.
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

