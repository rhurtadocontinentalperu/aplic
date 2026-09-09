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
DEFINE SHARED VARIABLE CL-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-NROSER  AS INTEGER.
DEFINE SHARED VARIABLE S-CODCLI  AS CHAR.

DEFINE VARIABLE S-PORDTO  AS DECIMAL.

DEFINE SHARED TEMP-TABLE LIQU LIKE FacDLiqu.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE I              AS INTEGER   NO-UNDO.
DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE C-NRODOC       AS CHAR      NO-UNDO.
DEFINE VARIABLE C-NROPED       AS CHAR      NO-UNDO.
DEFINE VARIABLE C-NROGUI       AS CHAR      NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NRODOC       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-ListPr       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE S-CODALM       AS CHAR      NO-UNDO.
DEFINE VARIABLE S-CODMOV       AS INTEGER   NO-UNDO. 
DEFINE VARIABLE I-CODMON       AS INTEGER   NO-UNDO. 
DEFINE VARIABLE R-ROWID        AS ROWID     NO-UNDO. 
DEFINE VARIABLE C-CODVEN       AS CHAR      NO-UNDO.
DEFINE VARIABLE D-FCHVTO       AS DATE      NO-UNDO.
DEFINE VARIABLE C-ALMCSG       AS CHAR      NO-UNDO.

DEFINE VARIABLE X-TIPREF       AS CHAR      NO-UNDO.
DEFINE VARIABLE S-NROREF       AS CHAR      NO-UNDO.

DEFINE BUFFER B-CLIQU FOR FacCLiqu.

FIND FacDocum WHERE 
     FacDocum.CodCia = S-CODCIA AND
     FacDocum.CodDoc = S-CODDOC NO-LOCK NO-ERROR.
IF AVAILABLE FacDocum THEN S-CODMOV = FacDocum.CodMov.

FIND FIRST FacCorre WHERE 
           FacCorre.CodCia = S-CODCIA AND
           FacCorre.CodDoc = S-CODDOC AND
           FacCorre.CodDiv = S-CODDIV AND
           FacCorre.NroSer = S-NROSER NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN S-CodAlm = FacCorre.CodAlm 
          I-NroSer = FacCorre.NroSer.

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
&Scoped-define EXTERNAL-TABLES FacCLiqu
&Scoped-define FIRST-EXTERNAL-TABLE FacCLiqu


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR FacCLiqu.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS FacCLiqu.CodCli FacCLiqu.NomCli ~
FacCLiqu.DirCli FacCLiqu.RucCli FacCLiqu.FchDoc FacCLiqu.CodVen ~
FacCLiqu.FchVto FacCLiqu.FmaPgo FacCLiqu.NroOrd FacCLiqu.Glosa 
&Scoped-define ENABLED-TABLES FacCLiqu
&Scoped-define FIRST-ENABLED-TABLE FacCLiqu
&Scoped-Define ENABLED-OBJECTS RECT-19 
&Scoped-Define DISPLAYED-FIELDS FacCLiqu.NroDoc FacCLiqu.NroPed ~
FacCLiqu.CodCli FacCLiqu.NomCli FacCLiqu.TpoCmb FacCLiqu.DirCli ~
FacCLiqu.RucCli FacCLiqu.FchDoc FacCLiqu.CodVen FacCLiqu.FchVto ~
FacCLiqu.FmaPgo FacCLiqu.NroOrd FacCLiqu.NroRef FacCLiqu.CodCob ~
FacCLiqu.Glosa FacCLiqu.CodMon 
&Scoped-define DISPLAYED-TABLES FacCLiqu
&Scoped-define FIRST-DISPLAYED-TABLE FacCLiqu
&Scoped-Define DISPLAYED-OBJECTS F-Estado F-NomVen F-CndVta 

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
DEFINE VARIABLE F-CndVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .69 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .69
     FONT 0 NO-UNDO.

DEFINE VARIABLE F-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.14 BY 5.27.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCLiqu.NroDoc AT ROW 1.12 COL 8.14 COLON-ALIGNED FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .69
          FONT 1
     FacCLiqu.NroPed AT ROW 1.12 COL 46.29 COLON-ALIGNED FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
          FONT 6
     F-Estado AT ROW 1.12 COL 69.29 COLON-ALIGNED NO-LABEL
     FacCLiqu.CodCli AT ROW 1.81 COL 8.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .69
     FacCLiqu.NomCli AT ROW 1.81 COL 17.43 COLON-ALIGNED NO-LABEL FORMAT "x(70)"
          VIEW-AS FILL-IN 
          SIZE 39.57 BY .69
     FacCLiqu.TpoCmb AT ROW 1.81 COL 69.29 COLON-ALIGNED
          LABEL "T/ Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     FacCLiqu.DirCli AT ROW 2.5 COL 8.14 COLON-ALIGNED FORMAT "x(70)"
          VIEW-AS FILL-IN 
          SIZE 34 BY .69
     FacCLiqu.RucCli AT ROW 2.5 COL 47 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     FacCLiqu.FchDoc AT ROW 2.5 COL 69.29 COLON-ALIGNED
          LABEL "F/ Emision"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     FacCLiqu.CodVen AT ROW 3.19 COL 8.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .69
     F-NomVen AT ROW 3.19 COL 15 COLON-ALIGNED NO-LABEL
     FacCLiqu.FchVto AT ROW 3.19 COL 69.29 COLON-ALIGNED
          LABEL "Vencimient"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     FacCLiqu.FmaPgo AT ROW 3.88 COL 8.14 COLON-ALIGNED
          LABEL "Cond.Vta"
          VIEW-AS FILL-IN 
          SIZE 6 BY .69
     F-CndVta AT ROW 3.88 COL 15 COLON-ALIGNED NO-LABEL
     FacCLiqu.NroOrd AT ROW 3.88 COL 69.29 COLON-ALIGNED
          LABEL "O/ Compra" FORMAT "x(15)"
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .69
     FacCLiqu.NroRef AT ROW 4.58 COL 8.29 COLON-ALIGNED
          LABEL "Guias" FORMAT "X(45)"
          VIEW-AS FILL-IN 
          SIZE 48.72 BY .69
          FONT 6
     FacCLiqu.CodCob AT ROW 4.58 COL 62.86
          LABEL "Alm.Consg."
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .69
     FacCLiqu.Glosa AT ROW 5.27 COL 8.14 COLON-ALIGNED
          LABEL "Glosa"
          VIEW-AS FILL-IN 
          SIZE 48.86 BY .69
     FacCLiqu.CodMon AT ROW 5.27 COL 71.43 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 10.72 BY .69
     "Moneda" VIEW-AS TEXT
          SIZE 6.29 BY .69 AT ROW 5.27 COL 64.43
     RECT-19 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.FacCLiqu
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
         HEIGHT             = 5.31
         WIDTH              = 86.14.
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

/* SETTINGS FOR FILL-IN FacCLiqu.CodCob IN FRAME F-Main
   NO-ENABLE ALIGN-L EXP-LABEL                                          */
/* SETTINGS FOR RADIO-SET FacCLiqu.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCLiqu.DirCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCLiqu.FchDoc IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCLiqu.FchVto IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCLiqu.FmaPgo IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCLiqu.Glosa IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCLiqu.NomCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN FacCLiqu.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCLiqu.NroOrd IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCLiqu.NroPed IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCLiqu.NroRef IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCLiqu.TpoCmb IN FRAME F-Main
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

&Scoped-define SELF-NAME FacCLiqu.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCLiqu.CodCli V-table-Win
ON LEAVE OF FacCLiqu.CodCli IN FRAME F-Main /* Cliente */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
                 AND  gn-clie.CodCli = FacCLiqu.CodCli:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-clie  THEN DO:
      MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
           
   DISPLAY gn-clie.NomCli @ FacCLiqu.NomCli 
           gn-clie.Ruc    @ FacCLiqu.RucCli 
           gn-clie.DirCli @ FacCLiqu.DirCli 
           WITH FRAME {&FRAME-NAME}. 
   S-CODCLI = SELF:SCREEN-VALUE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Cabecera-de-Guias-Consignacion V-table-Win 
PROCEDURE Actualiza-Cabecera-de-Guias-Consignacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE L-Atendido AS LOGICAL INIT YES.
  IF FacCLiqu.NroRef <> "" THEN DO ON ERROR UNDO, RETURN "ADM-ERROR":
     DO I = 1 TO NUM-ENTRIES(FacCLiqu.NroRef):
        C-NRODOC = ENTRY(I,FacCLiqu.NroRef).
        L-Atendido = YES.
        FIND CcbCDocu WHERE 
             CcbCDocu.CodCia = FacCLiqu.CodCia AND 
             CcbCDocu.CodDoc = FacCLiqu.CodRef AND 
             CcbCDocu.NroDoc = C-NroDoc 
             EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE CcbCDocu THEN DO :
           FOR EACH CcbDDocu OF CcbCDocu NO-LOCK:
               IF CcbDDocu.CanDes > CcbDDocu.CanDev THEN DO:
                  L-Atendido = NO.
                  LEAVE.
               END.
           END.
           IF L-Atendido THEN 
              ASSIGN CcbCDocu.FlgEst = "F"
                     CcbCDocu.CodRef = FacCLiqu.CodDoc
                     CcbCDocu.NroRef = FacCLiqu.NroDoc
                     CcbCDocu.FchCan = FacCLiqu.FchDoc
                     CcbCDocu.SdoAct = 0.
           ELSE
              ASSIGN CcbCDocu.FlgEst = "P"
                     CcbCDocu.CodRef = ""
                     CcbCDocu.NroRef = ""
                     CcbCDocu.FchCan = ?
                     CcbCDocu.FchAct = TODAY.
        END.
        RELEASE CcbCDocu.
     END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Detalle-de-Guias-Consignacion V-table-Win 
PROCEDURE Actualiza-Detalle-de-Guias-Consignacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH FacDLiqu OF FacCLiqu NO-LOCK 
           ON ERROR UNDO, RETURN "ADM-ERROR":
      FIND FIRST CcbDDocu WHERE 
                 CcbDDocu.CodCia = FacDLiqu.CodCia AND
                 CcbDDocu.CodDoc = FacDLiqu.CodRef AND
                 CcbDDocu.NroDoc = FacDLiqu.NroRef AND
                 CcbDDocu.CodMat = FacDLiqu.CodMat
                 EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE CcbDDocu THEN DO:
         ASSIGN CcbDDocu.CanDev = CcbDDocu.CanDev + FacDLiqu.CanDes. 
         FIND CcbCDocu OF CcbDDocu EXCLUSIVE-LOCK NO-ERROR.
         IF AVAILABLE CcbCDocu THEN DO:
            ASSIGN CcbCDocu.SdoAct = CcbCDocu.SdoAct - FacDLiqu.ImpLin.
            IF CcbCDocu.SdoAct < 0 THEN CcbCDocu.SdoAct = 0.
         END. 
         RELEASE CcbCDocu.
      END.
      RELEASE CcbDDocu.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-LIQU V-table-Win 
PROCEDURE Actualiza-LIQU :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       POR AHORA NO SE PUEDE MODIFICAR, SOLO CREAR
------------------------------------------------------------------------------*/
FOR EACH LIQU:
    DELETE LIQU.
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
  {src/adm/template/row-list.i "FacCLiqu"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "FacCLiqu"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Guias V-table-Win 
PROCEDURE Asigna-Guias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DO WITH FRAME {&FRAME-NAME}:
    IF FacCLiqu.CodCli:SCREEN-VALUE = "" THEN DO:
       MESSAGE "Debe registrar al cliente" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    IF NOT FacCLiqu.CodCli:SENSITIVE THEN DO:
       MESSAGE "Solo puede asignar una vez" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    
    RUN Actualiza-LIQU.
    
    input-var-1 = FacCLiqu.CodCli:SCREEN-VALUE.
    C-NROGUI = "".
    output-var-2 = "".
    
    RUN lkup\C-GuiCsg.r("Guias Pendientes x Liquidar").
    
    IF output-var-2 <> ? THEN DO:
       C-NROGUI = output-var-2.
       D-FCHVTO = ?.
       X-TIPREF = "G".
       DO I = 1 TO NUM-ENTRIES(output-var-2):
          C-NRODOC = ENTRY(I,output-var-2).
          FIND CcbCDocu WHERE 
               CcbCDocu.CodCia = S-CODCIA AND  
               CcbCDocu.CodDoc = "G/R"    AND  
               CcbCDocu.NroDoc = C-NroDoc 
               NO-LOCK NO-ERROR.
          C-NROPED = CcbCDocu.NroPed.
          I-CODMON = CcbCDocu.CodMon.
          C-CODVEN = CcbCDocu.CodVen.
          S-PORDTO = CcbCDocu.Pordto.
          S-NROREF = CcbCDocu.NroRef.
          C-ALMCSG = CcbCDocu.CodCob.
          S-CODCLI = CcbCDocu.CodCli.
       END.   
       F-NomVen = "".
       F-CndVta = "".
       DISPLAY CcbCDocu.NroOrd @ FacCLiqu.NroOrd
               CcbCDocu.FmaPgo @ FacCLiqu.FmaPgo
               CcbCDocu.DirCli @ FacCLiqu.DirCli 
               CcbCDocu.NomCli @ FacCLiqu.NomCli 
               CcbCDocu.RucCli @ FacCLiqu.RucCli.
               
       FIND gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
       IF AVAILABLE gn-convt THEN F-CndVta = gn-convt.Nombr.
       
       FIND gn-ven WHERE 
            gn-ven.CodCia = S-CODCIA AND  
            gn-ven.CodVen = C-CODVEN 
            NO-LOCK NO-ERROR.
       IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
       
       FacCLiqu.CodCli:SENSITIVE = NO.
       FacCLiqu.CodMon:SCREEN-VALUE = STRING(I-CodMon).
       DISPLAY C-NROPED @ FacCLiqu.NroPed
               C-CODVEN @ FacCLiqu.CodVen
               D-FCHVTO @ FacCLiqu.FchVto 
               C-ALMCSG @ FacCLiqu.CodCob
               S-NROREF @ FacCLiqu.NroDoc.
          
       FOR EACH LIQU :
           ASSIGN LIQU.ImpDto = ROUND( LIQU.PreUni * (LIQU.PorDto / 100) * LIQU.CanDes , 2 )
                  LIQU.ImpLin = ROUND( LIQU.PreUni * LIQU.CanDes , 2 ) .
           IF LIQU.AftIgv THEN 
              LIQU.ImpIgv = LIQU.ImpLin - ROUND(LIQU.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
           FIND Almmmatg WHERE 
                Almmmatg.CodCia = S-CODCIA AND  
                Almmmatg.codmat = LIQU.codmat 
                NO-LOCK NO-ERROR.
           IF AVAILABLE Almmmatg THEN DO:
              IF LIQU.AftIsc THEN 
                 LIQU.ImpIsc = ROUND(LIQU.PreBas * LIQU.CanDes * (Almmmatg.PorIsc / 100),4).
          END.
       END.
       
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
FOR EACH FacDLiqu  WHERE 
         FacDLiqu.CodCia = FacCLiqu.CodCia AND  
         FacDLiqu.CodDoc = FacCLiqu.CodDoc AND  
         FacDLiqu.NroDoc = FacCLiqu.NroDoc
         ON ERROR UNDO, RETURN "ADM-ERROR" :
    FIND FIRST CcbDDocu WHERE 
               CcbDDocu.CodCia = FacDLiqu.CodCia AND
               CcbDDocu.CodDoc = FacDLiqu.CodRef AND
               CcbDDocu.NroDoc = FacDLiqu.NroRef AND
               CcbDDocu.CodMat = FacDLiqu.CodMat
               EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE CcbDDocu THEN DO:
       ASSIGN CcbDDocu.CanDev = CcbDDocu.CanDev - FacDLiqu.CanDes. 
       IF CcbDDocu.CanDev < 0 THEN CcbDDocu.CanDev = 0.
       FIND CcbCDocu OF CcbDDocu EXCLUSIVE-LOCK NO-ERROR.
       IF AVAILABLE CcbCDocu THEN DO:
          ASSIGN CcbCDocu.SdoAct = CcbCDocu.SdoAct + FacDLiqu.ImpLin.
          IF CcbCDocu.SdoAct > CcbCDocu.ImpTot THEN CcbCDocu.SdoAct = CcbCDocu.ImpTot.
       END. 
       RELEASE CcbCDocu.
    END.
    RELEASE CcbDDocu.
    DELETE FacDLiqu.
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
FOR EACH LIQU NO-LOCK 
         ON ERROR UNDO, RETURN "ADM-ERROR": 
    IF LIQU.CanDes > 0 THEN DO: 
       CREATE FacDLiqu. 
       RAW-TRANSFER LIQU TO FacDLiqu. 
       ASSIGN FacDLiqu.CodCia = FacCLiqu.CodCia 
              FacDLiqu.CodDoc = FacCLiqu.CodDoc 
              FacDLiqu.NroDoc = FacCLiqu.NroDoc 
              FacDLiqu.CodCli = FacCLiqu.CodCli 
              FacDLiqu.FchDoc = FacCLiqu.FchDoc 
              FacDLiqu.codmat = LIQU.codmat 
              FacDLiqu.PreUni = LIQU.PreUni 
              FacDLiqu.CanDes = LIQU.CanDes 
              FacDLiqu.Factor = LIQU.Factor 
              FacDLiqu.ImpIsc = LIQU.ImpIsc 
              FacDLiqu.ImpIgv = LIQU.ImpIgv 
              FacDLiqu.ImpLin = LIQU.ImpLin 
              FacDLiqu.PorDto = LIQU.PorDto 
              FacDLiqu.PreBas = LIQU.PreBas 
              FacDLiqu.ImpDto = LIQU.ImpDto 
              FacDLiqu.AftIgv = LIQU.AftIgv 
              FacDLiqu.AftIsc = LIQU.AftIsc 
              FacDLiqu.UndVta = LIQU.UndVta 
              FacDLiqu.CodRef = LIQU.CodRef 
              FacDLiqu.NroRef = LIQU.NroRef.
    END.
END.
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
DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.
DO ON ERROR UNDO, RETURN "ADM-ERROR":
   FIND B-CLIQU WHERE ROWID(B-CLIQU) = ROWID(FacCLiqu) EXCLUSIVE-LOCK NO-ERROR.
   B-CLIQU.ImpDto = 0.
   B-CLIQU.ImpIgv = 0.
   B-CLIQU.ImpIsc = 0.
   B-CLIQU.ImpTot = 0.
   B-CLIQU.ImpExo = 0.
   B-CLIQU.ImpFle = 0.
   FOR EACH LIQU NO-LOCK: 
       B-CLIQU.ImpDto = B-CLIQU.ImpDto + LIQU.ImpDto.
       F-Igv = F-Igv + LIQU.ImpIgv.
       F-Isc = F-Isc + LIQU.ImpIsc.
       B-CLIQU.ImpTot = B-CLIQU.ImpTot + LIQU.ImpLin.
       IF NOT LIQU.AftIgv THEN B-CLIQU.ImpExo = B-CLIQU.ImpExo + LIQU.ImpLin.
   END.
   B-CLIQU.ImpIgv = ROUND(F-IGV,2).
   B-CLIQU.ImpIsc = ROUND(F-ISC,2).
   B-CLIQU.ImpBrt = B-CLIQU.ImpTot - B-CLIQU.ImpIgv - B-CLIQU.ImpIsc + 
                    B-CLIQU.ImpDto - B-CLIQU.ImpExo.
   B-CLIQU.ImpVta = B-CLIQU.ImpBrt - B-CLIQU.ImpDto.
   IF B-CLIQU.ImpFle > 0  THEN DO:
      B-CLIQU.ImpIgv = B-CLIQU.Impigv + ROUND(B-CLIQU.ImpFle * (FacCfgGn.PorIgv / 100),2).
      B-CLIQU.Imptot = B-CLIQU.Imptot + B-CLIQU.Impfle + ROUND(B-CLIQU.ImpFle * (FacCfgGn.PorIgv / 100),2).
   END.
   B-CLIQU.SdoAct = B-CLIQU.ImpTot.
   RELEASE B-CLIQU.
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
  L-CREA = YES.
  S-PORDTO = 0.
  RUN Numero-de-Documento(NO).
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY @ FacCLiqu.FchDoc
             TODAY @ FacCLiqu.FchVto
             FacCfgGn.CliVar @ FacCLiqu.CodCli
             FacCfgGn.Tpocmb[1] @ FacCLiqu.TpoCmb
             STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999") @ FacCLiqu.NroDoc.
     FacCLiqu.CodVen:SENSITIVE = NO.
     FacCLiqu.FmaPgo:SENSITIVE = NO. 
     FacCLiqu.NroOrd:SENSITIVE = NO.
     FacCLiqu.DirCli:SENSITIVE = NO. 
     FacCLiqu.NomCli:SENSITIVE = NO. 
     FacCLiqu.RucCli:SENSITIVE = NO.
  END.
  RUN Actualiza-LIQU.
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
  
  IF L-CREA THEN DO WITH FRAME {&FRAME-NAME}:
      
     RUN Numero-de-Documento(YES).
     
     ASSIGN FacCLiqu.CodCia = S-CODCIA
            FacCLiqu.CodAlm = S-CODALM
            FacCLiqu.FlgEst = "P"
            FacCLiqu.CodDoc = S-CODDOC
            FacCLiqu.CodMov = S-CODMOV 
            FacCLiqu.CodDiv = S-CODDIV
            FacCLiqu.NroDoc = (STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999")) 
            FacCLiqu.CodPed = "PED"
            FacCLiqu.NroPed = C-NROPED
            FacCLiqu.CodRef = "G/R"
            FacCLiqu.NroRef = C-NROGUI
            FacCLiqu.TipVta = "2"
            FacCLiqu.FchVto = D-FCHVTO
            FacCLiqu.CodCob = C-ALMCSG
            FacCLiqu.TpoCmb = FacCfgGn.TpoCmb[1]
            FacCLiqu.PorIgv = FacCfgGn.PorIgv
            FacCLiqu.CodMon = I-CodMon
            FacCLiqu.CodVen = C-CodVen
            FacCLiqu.PorDto = S-PORDTO
            FacCLiqu.usuario = S-USER-ID.
     DISPLAY FacCLiqu.NroDoc.
     FIND gn-clie WHERE 
          gn-clie.CodCia = cl-codcia AND  
          gn-clie.CodCli = FacCLiqu.CodCli 
          NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie  THEN DO:
        ASSIGN FacCLiqu.CodDpto = gn-clie.CodDept 
               FacCLiqu.CodProv = gn-clie.CodProv 
               FacCLiqu.CodDist = gn-clie.CodDist.
     END.
  END.
  
  RUN Genera-Detalle. /* Detalle de la Liquidaciones */ 
  RUN Graba-Totales.
  RUN Actualiza-Detalle-de-Guias-Consignacion.
  RUN Actualiza-Cabecera-de-Guias-Consignacion.
  
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
   IF FacCLiqu.FlgEst = "A" THEN DO:
      MESSAGE 'El documento se enuentra Anulado...' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
   END.
   IF FacCLiqu.FlgEst = "C" THEN DO:
      MESSAGE 'El documento se enuentra Facturado...' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
   END.
   IF FacCLiqu.SdoAct < FacCLiqu.ImpTot  THEN DO:
      MESSAGE 'El documento registra amortizaciones...' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
   END.

   DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
      RUN Borra-Detalle.
      RUN Actualiza-Cabecera-de-Guias-Consignacion.
      FIND B-CLIQU WHERE ROWID(B-CLIQU) = ROWID(FacCLiqu) EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE B-CLIQU THEN 
         ASSIGN B-CLIQU.FlgEst = "A"
                B-CLIQU.SdoAct = 0
                B-CLIQU.UsuAnu = S-USER-ID
                B-CLIQU.FchAnu = TODAY
                B-CLIQU.Glosa  = "A N U L A D O".
      RELEASE B-CLIQU.
  END.
  RUN Procesa-Handle IN lh_Handle ('Browse').
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
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
  
  IF AVAILABLE FacCLiqu THEN DO WITH FRAME {&FRAME-NAME}:
     S-PORDTO = FacCLiqu.PorDto.   
     IF FacCLiqu.FlgEst = "P" THEN F-Estado:SCREEN-VALUE = "PENDIENTE".
     IF FacCLiqu.FlgEst = "A" THEN F-Estado:SCREEN-VALUE = "ANULADO".
     IF FacCLiqu.FlgEst = "C" THEN F-Estado:SCREEN-VALUE = "CANCELADO".
     
     F-NomVen:screen-value = "".
     FIND gn-ven WHERE 
          gn-ven.CodCia = S-CODCIA AND  
          gn-ven.CodVen = FacCLiqu.CodVen 
          NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
     
     F-CndVta:SCREEN-VALUE = "".
     FIND gn-convt WHERE gn-convt.Codig = FacCLiqu.FmaPgo NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
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
     
  IF FacCLiqu.FlgEst = "A" THEN RUN VTA\R-IMPLIQ.R(ROWID(FacCLiqu)).
     
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
  IF L-INCREMENTA  THEN
     FIND FacCorre WHERE 
          FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = S-CODDOC AND
          FacCorre.CodDiv = S-CODDIV AND
          FacCorre.NroSer = S-NROSER EXCLUSIVE-LOCK NO-ERROR.
  ELSE
     FIND FacCorre WHERE 
          FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = S-CODDOC AND
          FacCorre.CodDiv = S-CODDIV AND
          FacCorre.NroSer = S-NROSER NO-LOCK NO-ERROR.
  
  IF AVAILABLE FacCorre THEN DO:
     ASSIGN I-NroDoc = FacCorre.Correlativo.
     IF L-INCREMENTA THEN ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
     I-NroSer = FacCorre.NroSer.
     S-CodAlm = FacCorre.CodAlm.
  END.
  RELEASE FacCorre.
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
  {src/adm/template/snd-list.i "FacCLiqu"}

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
DEFINE VARIABLE X-ITMS AS DECIMAL NO-UNDO.
DO WITH FRAME {&FRAME-NAME} :
   IF FacCLiqu.CodCli:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCLiqu.CodCli.
      RETURN "ADM-ERROR".   
   END.
   FOR EACH LIQU:
       X-ITMS = X-ITMS + LIQU.CanDes.
   END.
   IF X-ITMS = 0 THEN DO:
      MESSAGE "No existen items a generar" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCLiqu.Glosa.
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
/* LAS FACTURAS Y BOLETAS NO SE PUEDEN MODIFICAR */
RETURN "ADM-ERROR".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

