&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDocu FOR CcbCDocu.



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
DEFINE SHARED VARIABLE cl-codcia  AS INT.
DEFINE SHARED VARIABLE s-codalm   AS CHAR.
DEFINE SHARED TEMP-TABLE DETA LIKE CcbDDocu.
DEFINE SHARED VARIABLE S-NROSER   AS INT.

DEFINE SHARED VARIABLE S-PORDTO AS DEC.
DEFINE SHARED VARIABLE S-PORIGV AS DEC.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NRODOC       AS INTEGER   NO-UNDO.
DEFINE VARIABLE R-NRODEV       AS ROWID     NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE S-CODCLI       AS CHARACTER NO-UNDO. 
DEFINE VARIABLE R-ROWID        AS ROWID     NO-UNDO. 


FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV AND
     FacCorre.CodAlm = s-CodAlm AND 
     FacCorre.FlgEst = YES NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN I-NroSer = FacCorre.NroSer.

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
&Scoped-define EXTERNAL-TABLES CcbCDocu
&Scoped-define FIRST-EXTERNAL-TABLE CcbCDocu


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCDocu.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCDocu.Glosa 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define ENABLED-OBJECTS RECT-19 RECT-29 
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.CodCli CcbCDocu.TpoCmb CcbCDocu.Glosa CcbCDocu.CodRef ~
CcbCDocu.NroRef CcbCDocu.NroOrd CcbCDocu.CodMon 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_NomCli FILL-IN_RucCli ~
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
     LABEL "Dirección" 
     VIEW-AS FILL-IN 
     SIZE 44.72 BY .69.

DEFINE VARIABLE FILL-IN_NomCli AS CHARACTER FORMAT "x(50)" 
     VIEW-AS FILL-IN 
     SIZE 33 BY .69.

DEFINE VARIABLE FILL-IN_RucCli AS CHARACTER FORMAT "x(11)" 
     LABEL "Ruc" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80.43 BY 4.04.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 18.43 BY .92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.NroDoc AT ROW 1.12 COL 12 COLON-ALIGNED
          LABEL "Número" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 13.43 BY .69
          FONT 0
     CcbCDocu.FchDoc AT ROW 1.19 COL 68 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbCDocu.CodCli AT ROW 1.77 COL 12 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     FILL-IN_NomCli AT ROW 1.77 COL 23.72 COLON-ALIGNED NO-LABEL
     FILL-IN_RucCli AT ROW 1.96 COL 68 COLON-ALIGNED
     FILL-IN_DirCli AT ROW 2.46 COL 12 COLON-ALIGNED
     CcbCDocu.TpoCmb AT ROW 2.81 COL 69.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .69
     CcbCDocu.Glosa AT ROW 3.15 COL 12 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44.72 BY .69
     CcbCDocu.CodRef AT ROW 3.85 COL 6.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.29 BY .69
     CcbCDocu.NroRef AT ROW 3.85 COL 12 COLON-ALIGNED NO-LABEL FORMAT "x(12)"
          VIEW-AS FILL-IN 
          SIZE 13.29 BY .69
          FONT 0
     CcbCDocu.NroOrd AT ROW 3.85 COL 44.72 COLON-ALIGNED
          LABEL "No.Devolución" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     CcbCDocu.CodMon AT ROW 4.23 COL 62.43 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dólares", 2
          SIZE 16.86 BY .69
     " Moneda" VIEW-AS TEXT
          SIZE 6.72 BY .5 AT ROW 3.73 COL 67.29
     RECT-19 AT ROW 1 COL 1
     RECT-29 AT ROW 4.04 COL 61.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.CcbCDocu
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CDocu B "?" ? INTEGRAL CcbCDocu
   END-TABLES.
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
         HEIGHT             = 4.04
         WIDTH              = 80.43.
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

/* SETTINGS FOR FILL-IN CcbCDocu.CodCli IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR RADIO-SET CcbCDocu.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.CodRef IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DirCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_RucCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.NroOrd IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.NroRef IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.TpoCmb IN FRAME F-Main
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

&Scoped-define SELF-NAME CcbCDocu.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodCli V-table-Win
ON LEAVE OF CcbCDocu.CodCli IN FRAME F-Main /* Cliente */
DO:
  FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND 
       gn-clie.CodCli = CcbCDocu.CodCli:SCREEN-VALUE 
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN DO:
     MESSAGE 'Codigo de Cliente no existe' VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY gn-clie.NomCli @ FILL-IN_NomCli
             gn-clie.DirCli @ FILL-IN_DirCli
             gn-clie.Ruc @ FILL-IN_RucCli.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Deta V-table-Win 
PROCEDURE Actualiza-Deta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH DETA:
    DELETE DETA.
END.
IF NOT L-CREA THEN DO:
   FOR EACH CcbDDocu WHERE CcbDDocu.CodCia = CcbCDocu.CodCia
                      AND  CcbDDocu.CodDoc = CcbCDocu.CodDoc
                      AND  CcbDDocu.NroDoc = CcbCDocu.NroDoc
                     NO-LOCK:
       CREATE DETA.
       ASSIGN DETA.CodCia = CcbDDocu.CodCia
              DETA.codmat = CcbDDocu.codmat 
              DETA.PreUni = CcbDDocu.PreUni 
              DETA.CanDes = CcbDDocu.CanDes 
              DETA.Factor = CcbDDocu.Factor 
              DETA.ImpIsc = CcbDDocu.ImpIsc
              DETA.ImpIgv = CcbDDocu.ImpIgv 
              DETA.ImpLin = CcbDDocu.ImpLin
              DETA.PorDto = CcbDDocu.PorDto 
              DETA.PreBas = CcbDDocu.PreBas 
              DETA.ImpDto = CcbDDocu.ImpDto
              DETA.AftIgv = CcbDDocu.AftIgv
              DETA.AftIsc = CcbDDocu.AftIsc
              DETA.UndVta = CcbDDocu.UndVta.
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
  {src/adm/template/row-list.i "CcbCDocu"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbCDocu"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Documento V-table-Win 
PROCEDURE Borra-Documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH CcbDDocu WHERE CcbDDocu.CodCia = CcbCDocu.CodCia
    AND  CcbDDocu.CodDoc = CcbCDocu.CodDoc 
    AND  CcbDDocu.NroDoc = CcbCDocu.NroDoc:
    DELETE CcbDDocu.
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
DO ON ERROR UNDO, RETURN "ADM-ERROR":
   RUN Borra-Documento. 
   FOR EACH DETA ON ERROR UNDO, RETURN "ADM-ERROR":
       CREATE CcbDDocu.
       ASSIGN CcbDDocu.CodCia = CcbCDocu.CodCia 
              CcbDDocu.Coddiv = CcbCDocu.Coddiv 
              CcbDDocu.CodDoc = CcbCDocu.CodDoc 
              CcbDDocu.NroDoc = CcbCDocu.NroDoc
              CcbDDocu.codmat = DETA.codmat 
              CcbDDocu.PreUni = DETA.PreUni 
              CcbDDocu.CanDes = DETA.CanDes 
              CcbDDocu.Factor = DETA.Factor 
              CcbDDocu.ImpIsc = DETA.ImpIsc
              CcbDDocu.ImpIgv = DETA.ImpIgv 
              CcbDDocu.ImpLin = DETA.ImpLin
              CcbDDocu.PorDto = DETA.PorDto 
              CcbDDocu.PreBas = DETA.PreBas 
              CcbDDocu.ImpDto = DETA.ImpDto
              CcbDDocu.AftIgv = DETA.AftIgv
              CcbDDocu.AftIsc = DETA.AftIsc
              CcbDDocu.UndVta = DETA.UndVta
              CcbDDocu.Por_Dsctos[1] = DETA.Por_Dsctos[1]
              CcbDDocu.Por_Dsctos[2] = DETA.Por_Dsctos[2]
              CcbDDocu.Por_Dsctos[3] = DETA.Por_Dsctos[3]
              CcbDDocu.Flg_factor = DETA.Flg_factor
              CcbDDocu.ImpCto     = DETA.ImpCto.
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

{vta/graba-totales-abono.i}

/* BLOQUEADO 13.08.10
FIND B-CDOCU WHERE B-CDOCU.codcia = CcbCDocu.codcia 
              AND  B-CDOCU.Coddoc = CcbCdocu.coddoc 
              AND  B-CDOCU.NroDoc = CcbCdocu.nrodoc 
             EXCLUSIVE-LOCK NO-ERROR.
     
IF AVAILABLE B-CDOCU THEN DO ON ERROR UNDO, RETURN "ADM-ERROR":
   ASSIGN 
      B-CDOCU.ImpBrt = 0
      B-CDOCU.ImpDto = 0
      B-CDOCU.ImpIgv = 0
      B-CDOCU.ImpTot = 0
      B-CDOCU.ImpVta = 0.
   FOR EACH DETA:
       ASSIGN
          B-CDOCU.ImpExo = B-CDOCU.ImpExo + IF DETA.AftIgv = No  THEN (DETA.PreUni * DETA.CanDes) ELSE 0
          B-CDOCU.ImpDto = B-CDOCU.ImpDto + DETA.ImpDto
          B-CDOCU.ImpIgv = B-CDOCU.ImpIgv + DETA.ImpIgv
          B-CDOCU.ImpTot = B-CDOCU.ImpTot + DETA.ImpLin.
          B-CDOCU.ImpCto = B-CDOCU.ImpCto + DETA.ImpCto.
       IF DETA.AftIgv = Yes THEN 
          ASSIGN
             B-CDOCU.ImpBrt = B-CDOCU.ImpBrt + (DETA.PreUni * DETA.CanDes)
             B-CDOCU.ImpVta = B-CDOCU.ImpVta + ((DETA.PreUni * DETA.CanDes) - (DETA.ImpIgv + DETA.ImpDto)).

   END.
   FIND FIRST FacCfgGn NO-LOCK NO-ERROR.
   ASSIGN
      B-CDOCU.SdoAct = B-CDOCU.ImpTot
      B-CDOCU.ImpTot2= B-CDOCU.ImpTot
      B-CDOCU.ImpIgv = B-CDOCU.ImpTot - (B-CDOCU.ImpTot / (1 + (FacCfgGn.PorIgv / 100)))
      B-CDOCU.ImpBrt = B-CDOCU.ImpTot - (B-CDOCU.ImpIgv  ) + B-CDOCU.ImpDto
      B-CDOCU.ImpVta = B-CDOCU.ImpBrt - B-CDOCU.ImpDto.

    /****   Add by C.Q. 04/02/2000  ****/
    IF B-CDOCU.PorDto > 0 THEN DO:
       B-CDOCU.ImpDto = B-CDOCU.ImpDto + ROUND(B-CDOCU.ImpTot * B-CDOCU.PorDto / 100,2).
       B-CDOCU.ImpTot = ROUND(B-CDOCU.ImpTot * (1 - B-CDOCU.PorDto / 100),2).
       B-CDOCU.ImpVta = ROUND(B-CDOCU.ImpTot / (1 + B-CDOCU.PorIgv / 100),2).
       B-CDOCU.ImpIgv = B-CDOCU.ImpTot - B-CDOCU.ImpVta.
       B-CDOCU.ImpBrt = B-CDOCU.ImpTot - B-CDOCU.ImpIgv - B-CDOCU.ImpIsc + 
                  B-CDOCU.ImpDto - B-CDOCU.ImpExo.
       B-CDOCU.SdoAct = B-CDOCU.ImpTot.
       B-CDOCU.ImpTot2= B-CDOCU.ImpTot.
    END.
    /***********************************/

END.
RELEASE B-CDOCU.
*************************************************** */
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
 FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
     AND FacCorre.CodDoc = S-CODDOC 
     AND FacCorre.NroSer = s-NroSer
     NO-LOCK NO-ERROR.
 IF FacCorre.FlgEst = NO THEN DO:
     MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
     RETURN 'ADM-ERROR'.
  END.
  
 /*RUN lkup\C-DevPen.r("Devoluciones Pendientes").*/
 RUN lkup\C-DevoPendientes.r("Devoluciones Pendientes").
 IF output-var-1 = ? THEN RETURN "ADM-ERROR".

 ASSIGN
     s-PorIgv = FacCfgGn.PorIgv
     s-PorDto = 0
     i-nroser = s-nroser.
  
 /* Dispatch standard ADM method.                             */
 RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  
 /* Code placed here will execute AFTER standard behavior.    */
 L-CREA = YES.
 RUN Actualiza-Deta.
 RUN Numero-de-Documento(NO).
 DO WITH FRAME {&FRAME-NAME}:
     FIND Almcmov WHERE ROWID(Almcmov) = output-var-1 NO-LOCK NO-ERROR.
     R-NRODEV = ROWID(Almcmov).
     CcbCDocu.CodMon:SCREEN-VALUE = STRING(Almcmov.CodMon).
     DISPLAY 
         TODAY @ CcbCDocu.FchDoc
         Almcmov.CodCli @ CcbCDocu.CodCli
         FacCfgGn.Tpocmb[1] @ CcbCDocu.TpoCmb
         Almcmov.CodRef @ CcbCDocu.CodRef
         Almcmov.NroRf1 @ CcbCDocu.NroRef
         Almcmov.NroRf2 @ CcbCDocu.NroOrd
         STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999") @ CcbCDocu.NroDoc.
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
                   AND  gn-clie.CodCli = Almcmov.CodCli 
                  NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie 
     THEN DISPLAY gn-clie.NomCli @ FILL-IN_NomCli 
                gn-clie.Ruc    @ FILL-IN_RucCli  
                gn-clie.DirCli @ FILL-IN_DirCli.
     FIND B-CDOCU WHERE B-CDOCU.codcia = s-codcia 
         AND  B-CDOCU.CodDoc = Almcmov.CodRef 
         AND  B-CDOCU.NroDoc = Almcmov.NroRf1 
         NO-LOCK NO-ERROR.
     IF AVAILABLE B-CDOCU THEN DO:
         DISPLAY 
             B-CDOCU.NomCli @ FILL-IN_NomCli 
             B-CDOCU.RucCli @ FILL-IN_RucCli  
             B-CDOCU.DirCli @ FILL-IN_DirCli.
         ASSIGN
             S-PORDTO = B-CDOCU.PorDto
             S-PORIGV = B-CDOCU.PorIgv.
    END.
        
    FOR EACH Almdmov NO-LOCK WHERE Almdmov.CodCia = Almcmov.CodCia 
                               AND  Almdmov.CodAlm = Almcmov.CodAlm 
                               AND  Almdmov.TipMov = Almcmov.TipMov 
                               AND  Almdmov.CodMov = Almcmov.CodMov 
                               AND  Almdmov.NroDoc = Almcmov.NroDoc:
         CREATE DETA.
         ASSIGN DETA.CodCia = AlmDMov.CodCia
                DETA.codmat = AlmDMov.codmat
                DETA.PreUni = AlmDMov.PreUni
                DETA.CanDes = AlmDMov.CanDes
                DETA.Factor = AlmDMov.Factor
                DETA.ImpIsc = AlmDMov.ImpIsc
                DETA.ImpIgv = AlmDMov.ImpIgv
                DETA.ImpLin = AlmDMov.ImpLin
                DETA.PorDto = AlmDMov.PorDto
                DETA.PreBas = AlmDMov.PreBas
                DETA.ImpDto = AlmDMov.ImpDto
                DETA.AftIgv = AlmDMov.AftIgv
                DETA.AftIsc = AlmDMov.AftIsc
                DETA.UndVta = AlmDMov.CodUnd
                DETA.Por_Dsctos[1] = Almdmov.Por_Dsctos[1]
                DETA.Por_Dsctos[2] = Almdmov.Por_Dsctos[2]
                DETA.Por_Dsctos[3] = Almdmov.Por_Dsctos[3]
                DETA.Flg_factor = Almdmov.Flg_factor.
        /*************Grabando Costos ********************/
        FIND CcbDDocu WHERE CcbDDocu.codcia = s-codcia 
                       AND  CcbDDocu.CodDiv = S-CODDIV
                       AND  CcbDDocu.CodDoc = Almcmov.CodRef 
                       AND  CcbDDocu.NroDoc = Almcmov.NroRf1 
                       AND  CcbDDocu.CodMat = Almdmov.codMat
                       USE-INDEX LLAVE04 NO-LOCK NO-ERROR.
        IF AVAILABLE CcbDDocu THEN DO: 
           DETA.ImpCto = CcbDDocu.ImpCto * ( ( DETA.Candes * DETA.Factor ) / (CcbDDocu.Candes * CcbDDocu.Factor) ). 
        END.
     END.
 END.
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
     ASSIGN CcbCDocu.CodCia = S-CODCIA
            CcbCDocu.FchDoc = TODAY
            CcbCDocu.FchVto = TODAY
            CcbCDocu.FlgEst = "P"
            CcbCDocu.PorIgv = s-PorIgv      /* FacCfgGn.PorIgv*/
            CcbCDocu.PorDto = S-PORDTO
            CcbCDocu.CodDoc = S-CODDOC
            CcbCDocu.NroDoc = STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999")
            CcbCDocu.CodDiv = S-CODDIV
            CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
            CcbCDocu.CndCre = 'D'
            CcbCDocu.Tipo   = "OFICINA"
            CcbCDocu.usuario = S-USER-ID
            CcbCDocu.SdoAct = CcbCDocu.Imptot
            CcbCDocu.NomCli = FILL-IN_NomCli:SCREEN-VALUE
            CcbCDocu.DirCli = FILL-IN_DirCli:SCREEN-VALUE
            CcbCDocu.RucCli = FILL-IN_RucCli:SCREEN-VALUE.
              
     FIND Almcmov WHERE ROWID(Almcmov) = R-NRODEV  NO-ERROR.
     ASSIGN CcbCDocu.CodCli = Almcmov.CodCli 
            CcbCDocu.CodMon = Almcmov.CodMon
            CcbCDocu.CodAlm = Almcmov.CodAlm
            CcbCDocu.CodMov = Almcmov.CodMov
            CcbCDocu.CodVen = Almcmov.CodVen
            CcbCDocu.CodRef = Almcmov.CodRef
            /*CcbCDocu.NroPed = STRING(Almcmov.NroDoc,"999999")*/
            CcbCDocu.NroPed = STRING(Almcmov.NroDoc)
            CcbCDocu.NroOrd = Almcmov.NroRf2.
            CcbCDocu.NroRef = Almcmov.NroRf1.
     IF CcbCDocu.Codcli = FacCfgGn.CliVar THEN 
        ASSIGN
            CcbCDocu.RucCli = FILL-IN_RucCli:SCREEN-VALUE
            CcbCDocu.DirCli = FILL-IN_DirCli:SCREEN-VALUE.

     DISPLAY CcbCDocu.NroDoc.
     ASSIGN Almcmov.FlgEst = "C".
     RELEASE Almcmov.

    /* ACTUALIZAR EL CENTRO DE COSTO 22.07.04 CY */
    FIND B-CDOCU WHERE B-CDOCU.codcia = s-codcia
        AND B-CDOCU.coddoc = ccbcdocu.codref
        AND B-CDOCU.nrodoc = ccbcdocu.nroref NO-LOCK NO-ERROR.
    IF AVAILABLE B-CDOCU THEN DO:
        FIND GN-VEN WHERE gn-ven.codcia = s-codcia
            AND gn-ven.codven = B-CDOCU.codven
            NO-LOCK NO-ERROR.
        IF AVAILABLE GN-VEN THEN ccbcdocu.cco = gn-ven.cco.
    END.
  END.
   
  RUN Genera-Detalle.   

  RUN vta2/actualiza-cot-por-devolucion (ROWID(Ccbcdocu), -1).
  IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
  
  RUN Graba-Totales.

  /* GENERACION DE CONTROL DE PERCEPCIONES */
  RUN vta2/control-percepcion-abonos (ROWID(Ccbcdocu)) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
  /* ************************************* */

  /* RHC 02-07-2012 ASIENTO DE TRANSFERENCIA PARA SPEED */
  RUN aplic/sypsa/registroventas (INPUT ROWID(ccbcdocu), INPUT "I", YES).
  /* ************************************************** */
  
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
  IF CcbCDocu.FlgEst = "A" THEN DO:
      MESSAGE 'El documento se encuentra anulado...' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
  END.
  IF CcbCDocu.SdoAct < CcbCDocu.ImpTot  THEN DO:
      MESSAGE 'El documento registra amortizaciones...' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
  END.
  IF CcbCDocu.CndCre <> 'D' THEN DO:
      MESSAGE 'El documento no corresponde a devolucion de mercaderia' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
  END.
  /* documento con canje de letras pendiente de aprobar */
  IF Ccbcdocu.flgsit = 'X' THEN DO:
      MESSAGE 'Documento con canje por letra pendiente de aprobar' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  /* consistencia de la fecha del cierre del sistema */
  IF s-user-id <> "ADMIN" THEN DO:
      DEF VAR dFchCie AS DATE.
      RUN gn/fecha-de-cierre (OUTPUT dFchCie).
      IF ccbcdocu.fchdoc <= dFchCie THEN DO:
          MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
              VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.
      /* RHC CONSISTENCIA SOLO PARA TIENDAS UTILEX */
      IF LOOKUP(s-coddiv, '00023,00027,00501,00502,00503,00504,00505,00506,00507,00508') > 0 
           AND Ccbcdocu.fchdoc < TODAY
           THEN DO:
           MESSAGE 'Solo se pueden anular documentos del día'
               VIEW-AS ALERT-BOX ERROR.
           RETURN 'ADM-ERROR'.
      END.
      /* fin de consistencia */
      {adm/i-DocPssw.i ccbcdocu.CodCia ccbcdocu.CodDoc ""DEL""}
  END.

  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
       /* Motivo de anulacion */
       DEF VAR cReturnValue AS CHAR NO-UNDO.
       RUN ccb/d-motanu (ccbcdocu.codcia, ccbcdocu.coddoc, ccbcdocu.nrodoc, s-user-id, OUTPUT cReturnValue).
       IF cReturnValue = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
       /* ******************* */

       RUN vta2/actualiza-cot-por-devolucion (ROWID(Ccbcdocu), +1).
       IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".

       /* EXTORNA CONTROL DE PERCEPCIONES POR ABONOS */
       FOR EACH B-CDOCU WHERE B-CDOCU.codcia = Ccbcdocu.codcia
           AND B-CDOCU.coddiv = Ccbcdocu.coddiv
           AND B-CDOCU.coddoc = "PRA"
           AND B-CDOCU.codref = Ccbcdocu.coddoc
           AND B-CDOCU.nroref = Ccbcdocu.nrodoc:
           DELETE B-CDOCU.
       END.
       /* ****************************************** */
       
       RUN Borra-Documento.   

       FIND B-CDOCU WHERE ROWID(B-CDOCU) = ROWID(CcbCDocu) NO-ERROR.
       IF AVAILABLE B-CDOCU THEN 
           ASSIGN 
           CcbCDocu.FlgEst = "A"
           CcbCDocu.SdoAct = 0 
           CcbCDocu.Glosa  = '**** Documento Anulado ****'
           CcbCDocu.UsuAnu = S-USER-ID.
       FIND Almcmov WHERE Almcmov.CodCia = CcbCDocu.CodCia
           AND  Almcmov.CodAlm = CcbCDocu.CodAlm 
           AND  Almcmov.TipMov = "I"
           AND  Almcmov.CodMov = CcbCDocu.CodMov 
           AND  Almcmov.NroDoc = INTEGER(CcbCDocu.NroPed)
           NO-ERROR.
       ASSIGN Almcmov.FlgEst = "P".
       /* *************** ANULAMOS LA N/C EN EL SPEED **************** */
       RUN sypsa/anular-comprobante (ROWID(Ccbcdocu)).
       IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
       /* ************************************************************ */
       RELEASE B-CDOCU.
       RELEASE Almcmov.
  END.
  RUN Procesa-Handle IN lh_Handle ('Browse').
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FILL-IN_DirCli:SENSITIVE = NO.
  END.

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
  IF AVAILABLE CcbCDocu THEN DO WITH FRAME {&FRAME-NAME}:
      DISPLAY CcbCDocu.NomCli @ FILL-IN_NomCli 
              CcbCDocu.Ruc    @ FILL-IN_RucCli  
              CcbCDocu.DirCli @ FILL-IN_DirCli.
/*      FIND gn-clie WHERE gn-clie.CodCia = cl-codcia       */
/*                    AND  gn-clie.CodCli = CcbCDocu.CodCli */
/*                   NO-LOCK NO-ERROR.                      */
/*      IF AVAILABLE gn-clie  THEN                          */
/*         DISPLAY gn-clie.NomCli @ FILL-IN_NomCli          */
/*                 gn-clie.Ruc    @ FILL-IN_RucCli          */
/*                 gn-clie.DirCli @ FILL-IN_DirCli.         */
/*      IF CcbCDocu.Codcli = FacCfgGn.CliVar THEN           */
/*         DISPLAY CcbCDocu.NomCli @ FILL-IN_NomCli         */
/*                 CcbCDocu.Ruc    @ FILL-IN_RucCli         */
/*                 CcbCDocu.DirCli @ FILL-IN_DirCli.        */
  END.
  /* Code placed here will execute AFTER standard behavior.    */

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
      FILL-IN_DirCli:SENSITIVE = YES.
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
  IF CCBCDOCU.FLGEST <> "A" THEN DO:
      CASE Ccbcdocu.coddiv:
          WHEN '00005' THEN RUN ccb/r-notcre00005 (ROWID(CCBCDOCU)).
          OTHERWISE RUN CCB\R-NOTCRE3 (ROWID(CCBCDOCU)).
      END CASE.
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
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
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
     FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                    AND  FacCorre.CodDoc = S-CODDOC 
                    AND  FacCorre.CodDiv = S-CODDIV 
                    AND  FacCorre.NroSer = s-NroSer
                   EXCLUSIVE-LOCK NO-ERROR.
  ELSE
     FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                    AND  FacCorre.CodDoc = S-CODDOC 
                    AND  FacCorre.CodDiv = S-CODDIV 
                    AND  FacCorre.NroSer = s-NroSer
                   NO-LOCK NO-ERROR.
  IF AVAILABLE FacCorre THEN DO:      
     ASSIGN I-NroDoc = FacCorre.Correlativo.
     IF L-INCREMENTA THEN ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
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
  {src/adm/template/snd-list.i "CcbCDocu"}

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
     RUN Actualiza-Deta.
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
IF NOT AVAILABLE CcbCDocu THEN RETURN "ADM-ERROR".
RETURN 'ADM-ERROR'. /* No se puede realizar modificaciones */
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

