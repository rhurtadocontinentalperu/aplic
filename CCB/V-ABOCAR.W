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
DEFINE SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE cl-codcia  AS INT.
DEFINE SHARED TEMP-TABLE DETA LIKE CcbDDocu.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NRODOC       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE S-CODCLI       AS CHARACTER NO-UNDO. 
DEFINE VARIABLE R-ROWID        AS ROWID     NO-UNDO. 

DEFINE BUFFER B-CDOCU FOR CcbCDocu.

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV NO-LOCK NO-ERROR.
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
&Scoped-Define ENABLED-FIELDS CcbCDocu.CodCli CcbCDocu.FchDoc ~
CcbCDocu.TpoCmb CcbCDocu.Glosa CcbCDocu.CodRef CcbCDocu.NroRef ~
CcbCDocu.CodMon 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define ENABLED-OBJECTS RECT-19 RECT-29 
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.CodCli ~
CcbCDocu.FchDoc CcbCDocu.TpoCmb CcbCDocu.Glosa CcbCDocu.CodRef ~
CcbCDocu.NroRef CcbCDocu.CodMon 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_NomCli FILL-IN_DirCli ~
FILL-IN_RucCli 

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
     SIZE 80 BY 4.27.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 18.43 BY .92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.NroDoc AT ROW 1.23 COL 11.14 COLON-ALIGNED FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12.72 BY .69
          FONT 1
     CcbCDocu.CodCli AT ROW 1.96 COL 11.14 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     FILL-IN_NomCli AT ROW 1.96 COL 23 COLON-ALIGNED NO-LABEL
     CcbCDocu.FchDoc AT ROW 1.96 COL 68 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     FILL-IN_DirCli AT ROW 2.73 COL 11.14 COLON-ALIGNED
     CcbCDocu.TpoCmb AT ROW 2.73 COL 70.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .69
     CcbCDocu.Glosa AT ROW 3.5 COL 11.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44.72 BY .69
     CcbCDocu.CodRef AT ROW 4.27 COL 11.14 COLON-ALIGNED
          LABEL "Referencia"
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .69
          FONT 1
     CcbCDocu.NroRef AT ROW 4.27 COL 18 COLON-ALIGNED NO-LABEL FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .69
          FONT 1
     FILL-IN_RucCli AT ROW 4.27 COL 47.29 COLON-ALIGNED
     CcbCDocu.CodMon AT ROW 4.31 COL 62.72 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dólares", 2
          SIZE 16.86 BY .69
     " Moneda" VIEW-AS TEXT
          SIZE 6.72 BY .5 AT ROW 3.85 COL 67.72
     RECT-19 AT ROW 1 COL 1
     RECT-29 AT ROW 4.19 COL 62
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
         HEIGHT             = 4.27
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
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.CodRef IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DirCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_RucCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NroRef IN FRAME F-Main
   EXP-FORMAT                                                           */
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


&Scoped-define SELF-NAME CcbCDocu.NroRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.NroRef V-table-Win
ON LEAVE OF CcbCDocu.NroRef IN FRAME F-Main /* Numero */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    FIND FIRST B-CDOCU WHERE B-CDOCU.CodCia = s-codcia AND 
         B-CDOCU.CodDoc = CcbCDocu.CodRef:SCREEN-VALUE AND
         B-CDOCU.NroDoc = SUBSTRING(SELF:SCREEN-VALUE,1,3) + SUBSTRING(SELF:SCREEN-VALUE,5,6) NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CDOCU THEN DO:
       MESSAGE 'Documento de referencia no existe' VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    IF B-CDOCU.CodCli <> CcbCDocu.CodCli:SCREEN-VALUE THEN DO:
       MESSAGE 'Documento no corresponde al cliente' VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    DISPLAY 
       CcbCDocu.Codmon.
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
        AND CcbDDocu.CodDoc = CcbCDocu.CodDoc 
        AND CcbDDocu.NroDoc = CcbCDocu.NroDoc NO-LOCK:
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
        AND CcbDDocu.CodDoc = CcbCDocu.CodDoc 
        AND CcbDDocu.NroDoc = CcbCDocu.NroDoc:
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
   RUN Borra-Documento. 
   FOR EACH DETA:
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
              CcbDDocu.UndVta = DETA.UndVta.
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
FIND B-CDOCU WHERE B-CDOCU.codcia = CcbCDocu.codcia AND
     B-CDOCU.Coddoc = CcbCdocu.coddoc AND
     B-CDOCU.NroDoc = CcbCdocu.nrodoc EXCLUSIVE-LOCK NO-ERROR.
     
ASSIGN
    B-CDOCU.ImpBrt = 0
    B-CDOCU.ImpExo = 0
    B-CDOCU.ImpDto = 0
    B-CDOCU.ImpIgv = 0
    B-CDOCU.ImpTot = 0.
     
IF AVAILABLE B-CDOCU THEN 
   FOR EACH DETA:
       ASSIGN
          B-CDOCU.ImpBrt = B-CDOCU.ImpBrt + (IF DETA.AftIgv = Yes THEN DETA.PreUni * DETA.CanDes ELSE 0)
          B-CDOCU.ImpExo = B-CDOCU.ImpExo + (IF DETA.AftIgv = No  THEN DETA.PreUni * DETA.CanDes ELSE 0)
          B-CDOCU.ImpDto = B-CDOCU.ImpDto + DETA.ImpDto
          B-CDOCU.ImpIgv = B-CDOCU.ImpIgv + DETA.ImpIgv
          B-CDOCU.ImpTot = B-CDOCU.ImpTot + DETA.ImpLin.
   END.
   ASSIGN 
      B-CDOCU.ImpVta = B-CDOCU.ImpBrt - B-CDOCU.ImpIgv
      B-CDOCU.ImpBrt = B-CDOCU.ImpBrt - B-CDOCU.ImpIgv + B-CDOCU.ImpDto
      B-CDOCU.SdoAct = B-CDOCU.ImpTot.
      
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
  RUN Numero-de-Documento(NO).
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY @ CcbCDocu.FchDoc
             S-CODCLI @ CcbCDocu.CodCli
             FacCfgGn.Tpocmb[1] @ CcbCDocu.TpoCmb
             STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999") @ CcbCDocu.NroDoc.
  END.
  RUN Actualiza-Deta.
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
/*            CcbCDocu.FchDoc = TODAY*/
            CcbCDocu.FchVto = CcbCDocu.FchDoc /*TODAY*/
            CcbCDocu.FlgEst = "P"
            CcbCDocu.PorIgv = FacCfgGn.PorIgv
            CcbCDocu.CodDoc = S-CODDOC
            CcbCDocu.NroDoc = STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999")
            CcbCDocu.CodDiv = S-CODDIV
            CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
            CcbCDocu.CndCre = 'N'
            CcbCDocu.usuario = S-USER-ID
            CcbCDocu.SdoAct = CcbCDocu.Imptot.
     FIND FIRST B-CDOCU WHERE B-CDOCU.CodCia = s-codcia AND 
          B-CDOCU.CodDoc = CcbCDocu.CodRef AND
          B-CDOCU.NroDoc = CcbCDocu.NroRef NO-LOCK NO-ERROR.   
     IF AVAILABLE B-CDOCU THEN DO:
         ASSIGN CcbCDocu.CodVen = B-CDOCU.CodVen
                CcbCDocu.NomCli = B-CDOCU.NomCli
                CcbCDocu.DirCli = B-CDOCU.DirCli
                CcbCDocu.RucCli = B-CDOCU.RucCli
                CcbCDocu.CodCli = B-CDOCU.CodCli.
     END.
    IF Ccbcdocu.nomcli = '' THEN Ccbcdocu.nomcli = FILL-IN_NomCli:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
    IF Ccbcdocu.dircli = '' THEN Ccbcdocu.dircli = FILL-IN_DirCli:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
     DISPLAY CcbCDocu.NroDoc.
     /* ACTUALIZAR EL CENTRO DE COSTO 22.07.04 CY */
     FIND GN-VEN WHERE gn-ven.codcia = s-codcia
        AND gn-ven.codven = ccbcdocu.codven
        NO-LOCK NO-ERROR.
     IF AVAILABLE GN-VEN THEN ccbcdocu.cco = gn-ven.cco.
  END.

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
   FIND B-CDOCU WHERE ROWID(B-CDOCU) = ROWID(CcbCDocu) NO-ERROR.
   IF CcbCDocu.FlgEst = "A" THEN DO:
      MESSAGE 'El documento se enuentra anulado...' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
   END.
   IF CcbCDocu.SdoAct < CcbCDocu.ImpTot  THEN DO:
      MESSAGE 'El documento registra amortizaciones...' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
   END.
   IF CcbCDocu.CndCre <> 'N' THEN DO:
      MESSAGE 'El documento corresponde a devolucion de mercaderia' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
   END.
   DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
       RUN Borra-Documento.   
       DEF VAR cReturnValue AS CHAR NO-UNDO.
       RUN ccb/d-motanu (ccbcdocu.codcia, ccbcdocu.coddoc, ccbcdocu.nrodoc, s-user-id, OUTPUT cReturnValue).
       IF cReturnValue = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
       FIND B-CDOCU WHERE ROWID(B-CDOCU) = ROWID(CcbCDocu) EXCLUSIVE-LOCK NO-ERROR.
       IF AVAILABLE B-CDOCU THEN 
          ASSIGN B-CDOCU.FlgEst = "A"
                 B-CDOCU.SdoAct = 0 
                 B-CDOCU.Glosa  = '**** Documento Anulado ****'
                 B-CDOCU.UsuAnu = S-USER-ID.
       RELEASE B-CDOCU.
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
  IF AVAILABLE CcbCDocu THEN DO WITH FRAME {&FRAME-NAME}:
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
          gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK NO-ERROR.
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
/*  IF CCBCDOCU.FLGEST <> "A" THEN RUN CCB\R-IMPNOT3 (ROWID(CCBCDOCU)).*/
  IF CCBCDOCU.FLGEST <> "A" THEN RUN ccb/R-IMPNOT3-2 (ROWID(CCBCDOCU)).

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

  RUN Genera-Detalle.   
  RUN Graba-Totales.
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
        WHEN "CodRef" THEN ASSIGN input-var-1 = 'CARGO'.
        WHEN "NroRef" THEN ASSIGN input-var-1 = CcbCDocu.CodRef:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                                  input-var-2 = CcbCDocu.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                                  input-var-3 = ''.
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
/*
   FIND FacDocum WHERE FacDocum.CodCia = s-codcia AND 
        FacDocum.CodDoc = CcbCDocu.CodRef:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE FacDocum THEN DO:
      MESSAGE "Codigo de Referencia no Existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO CcbCDocu.CodRef.
      RETURN "ADM-ERROR".   
   END.

   FIND B-CDocu WHERE B-CDocu.CodCia = s-codcia AND
        B-CDocu.CodCli = CcbCDocu.CodCli:SCREEN-VALUE AND
        B-CDocu.CodDoc = CcbCDocu.CodRef:SCREEN-VALUE AND
        B-CDocu.NroDoc = SUBSTRING(CcbCDocu.NroRef:SCREEN-VALUE,1,3) + SUBSTRING(CcbCDocu.NroRef:SCREEN-VALUE,5,6) NO-LOCK NO-ERROR.
   IF NOT AVAILABLE B-CDocu THEN DO:
      MESSAGE "Numero de referencia no Existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO CcbCDocu.NroRef.
      RETURN "ADM-ERROR".   
   END.
*/   
   /* Verifica que el importe sea menor o igual al importe del 
      documento de referencia */
   DEFINE VAR X-Imptot AS DECIMAL NO-UNDO.
   X-Imptot = 0.
   FOR EACH DETA:
      X-Imptot = X-Imptot + DETA.ImpLin.
   END.   
   IF X-Imptot > B-CDocu.Imptot THEN DO:
      MESSAGE 'El importe del documento no debe ser mayor a ' + STRING(B-CDocu.Imptot) VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
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
IF NOT AVAILABLE CcbCDocu THEN RETURN "ADM-ERROR".
RETURN 'ADM-ERROR'.   /* No se puede realizar modificaciones */
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

