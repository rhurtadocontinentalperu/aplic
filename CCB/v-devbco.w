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
DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".

/* Shared Variable Definitions ---                                       */

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE SHARED VARIABLE S-FCHDOC   AS DATE.
DEFINE SHARED TEMP-TABLE MVTO LIKE CcbDMvto.
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER.
DEFINE SHARED VARIABLE S-TPOCMB   AS DECIMAL.
DEFINE SHARED VARIABLE S-FLGUBI   AS CHAR.
DEFINE SHARED VARIABLE S-FLGSIT   AS CHAR.
DEFINE SHARED VARIABLE S-PORGAS   AS DECIMAL.
DEFINE SHARED VARIABLE S-TIPO     AS CHAR.
DEFINE SHARED VARIABLE cb-codcia  AS INT.

S-CODMON = 1.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NRODOC       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE R-ROWID        AS ROWID     NO-UNDO. 
DEFINE VARIABLE S-CODBCO       AS CHAR      NO-UNDO.
DEFINE VAR X-CTA AS CHAR.
DEFINE BUFFER B-CMvto FOR CcbCMvto.

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
&Scoped-define EXTERNAL-TABLES CcbCMvto
&Scoped-define FIRST-EXTERNAL-TABLE CcbCMvto


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCMvto.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCMvto.CodCta CcbCMvto.CodAge ~
CcbCMvto.Glosa CcbCMvto.TpoCmb CcbCMvto.CodDpto CcbCMvto.CodMon 
&Scoped-define ENABLED-TABLES CcbCMvto
&Scoped-define FIRST-ENABLED-TABLE CcbCMvto
&Scoped-Define ENABLED-OBJECTS RECT-19 
&Scoped-Define DISPLAYED-FIELDS CcbCMvto.NroDoc CcbCMvto.FchDoc ~
CcbCMvto.CodCta CcbCMvto.CodAge CcbCMvto.Glosa CcbCMvto.TpoCmb ~
CcbCMvto.CodDpto CcbCMvto.CodMon 
&Scoped-define DISPLAYED-TABLES CcbCMvto
&Scoped-define FIRST-DISPLAYED-TABLE CcbCMvto
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_Banco FILL-IN-Agencia 

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
DEFINE VARIABLE FILL-IN-Agencia AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29.43 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_Banco AS CHARACTER FORMAT "x(50)" 
     VIEW-AS FILL-IN 
     SIZE 27.86 BY .69.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 3.19.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCMvto.NroDoc AT ROW 1.12 COL 11.43 COLON-ALIGNED
          LABEL "Numero"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbCMvto.FchDoc AT ROW 1.19 COL 66.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbCMvto.CodCta AT ROW 1.85 COL 11.43 COLON-ALIGNED
          LABEL "Banco"
          VIEW-AS FILL-IN 
          SIZE 10.86 BY .69
     CcbCMvto.CodAge AT ROW 2.54 COL 11.43 COLON-ALIGNED
          LABEL "Agencia"
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .69
     CcbCMvto.Glosa AT ROW 3.27 COL 11.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44.72 BY .69
     FILL-IN_Banco AT ROW 1.85 COL 22.86 COLON-ALIGNED NO-LABEL
     FILL-IN-Agencia AT ROW 2.58 COL 21.14 COLON-ALIGNED NO-LABEL
     CcbCMvto.TpoCmb AT ROW 1.96 COL 66.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbCMvto.CodDpto AT ROW 2.69 COL 66.72 COLON-ALIGNED
          LABEL "Plaza"
          VIEW-AS FILL-IN 
          SIZE 6.14 BY .69
     CcbCMvto.CodMon AT ROW 3.42 COL 68.72 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.14 BY .58
     "Moneda" VIEW-AS TEXT
          SIZE 6.72 BY .5 AT ROW 3.5 COL 61.29
     RECT-19 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.CcbCMvto
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
         HEIGHT             = 3.19
         WIDTH              = 80.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN CcbCMvto.CodAge IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCMvto.CodCta IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCMvto.CodDpto IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCMvto.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Agencia IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Banco IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCMvto.NroDoc IN FRAME F-Main
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

&Scoped-define SELF-NAME CcbCMvto.CodAge
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.CodAge V-table-Win
ON LEAVE OF CcbCMvto.CodAge IN FRAME F-Main /* Agencia */
DO:
  FIND gn-agbco WHERE 
       gn-agbco.codcia = s-codcia AND 
       gn-agbco.codbco = s-codbco AND 
       gn-agbco.codage = CcbCMvto.CodAge:SCREEN-VALUE 
       IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.
  IF AVAILABLE gn-agbco THEN 
     ASSIGN
        FILL-IN-Agencia:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gn-agbco.nomage.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCMvto.CodCta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.CodCta V-table-Win
ON LEAVE OF CcbCMvto.CodCta IN FRAME F-Main /* Banco */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
       cb-ctas.Codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE cb-ctas THEN DO:
     MESSAGE 'Cuenta contable no existe' VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY cb-ctas.Nomcta @ FILL-IN_Banco.
  END.
  s-fchdoc = CcbCMvto.FchDoc.
  s-codmon = cb-ctas.codmon.
  s-codbco = cb-ctas.codbco.
  CcbCMvto.CodMon:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(cb-ctas.codmon, '9').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCMvto.CodDpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.CodDpto V-table-Win
ON LEAVE OF CcbCMvto.CodDpto IN FRAME F-Main /* Plaza */
DO:
  S-TIPO = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCMvto.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.CodMon V-table-Win
ON VALUE-CHANGED OF CcbCMvto.CodMon IN FRAME F-Main /* Moneda */
DO:
  s-codmon = INTEGER(CcbCMvto.CodMon:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCMvto.TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.TpoCmb V-table-Win
ON LEAVE OF CcbCMvto.TpoCmb IN FRAME F-Main /* Tipo de cambio */
DO:
  ASSIGN CcbCMvto.TpoCmb.
  S-TPOCMB = CcbCMvto.TpoCmb.
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
FOR EACH MVTO:
    DELETE MVTO.
END.
IF NOT L-CREA THEN DO:
   FOR EACH CcbDMvto WHERE CcbDMvto.CodCia = CcbCMvto.CodCia
        AND CcbDMvto.CodDoc = CcbCMvto.CodDoc 
        AND CcbDMvto.NroDoc = CcbCMvto.NroDoc NO-LOCK:
       CREATE MVTO.
       ASSIGN MVTO.CodCia = CcbDMvto.CodCia
              MVTO.CodDoc = CcbDMvto.CodDoc
              MVTO.TpoRef = CcbDMvto.TpoRef
              MVTO.CodRef = CcbDMvto.CodRef
              MVTO.NroRef = CcbDMvto.NroRef
              MVTO.FchEmi = CcbDMvto.FchEmi
              MVTO.FchVto = CcbDMvto.FchVto
              MVTO.ImpTot = CcbDMvto.ImpTot.
   END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Flag V-table-Win 
PROCEDURE Actualiza-Flag :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH MVTO:
    FIND CcbCDocu WHERE CcbCDocu.codcia = MVTO.codcia AND
         CcbCDocu.CodDoc = MVTO.codref AND
         CcbCDocu.NroDoc = MVTO.Nroref EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE CcbCDocu THEN DO:
       ASSIGN
          x-cta = CcbCMvto.CodCta  
          CcbCDocu.FlgUbiA = CcbCDocu.FlgUbi
          CcbCDocu.FchUbiA = CcbCDocu.FchUbi 
          CcbCDocu.FlgSitA = CcbCDocu.FlgSit
          CcbCDocu.FchUbi  = TODAY 
          /*CcbCDocu.FlgSit  = S-FLGSIT*/
          CcbCDocu.FlgUbi  = 'C'    /* Cartera */
          CcbCDocu.CodCta  = ""
          /*
          CcbCDocu.CodCta  = CcbCMvto.CodCta
          CcbCDocu.CodAge  = CcbCMvto.CodAge
          */
          CcbCDocu.NroSal  = MVTO.NroDep.
    END.
    RELEASE CcbCDocu.
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
  {src/adm/template/row-list.i "CcbCMvto"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbCMvto"}

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
FOR EACH CcbDMvto WHERE CcbDMvto.CodCia = CcbCMvto.CodCia AND
    CcbDMvto.CodDoc = CcbCMvto.CodDoc AND
    CcbDMvto.NroDoc = CcbCMvto.NroDoc:
    DELETE CcbDMvto.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Flag V-table-Win 
PROCEDURE Borra-Flag :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH CcbDMvto WHERE CcbDMvto.CodCia = CcbCMvto.CodCia AND
    CcbDMvto.CodDoc = CcbCMvto.CodDoc AND
    CcbDMvto.NroDoc = CcbCMvto.NroDoc:
    FIND CcbCDocu WHERE CcbCDocu.codcia = CcbDMvto.codcia AND
         CcbCDocu.CodDoc = CcbDMvto.codref AND
         CcbCDocu.NroDoc = CcbDMvto.Nroref NO-ERROR.
    IF AVAILABLE CcbCDocu THEN DO:
       ASSIGN
          CcbCDocu.FlgUbi  = CcbCDocu.FlgUbiA
          CcbCDocu.FchUbi  = CcbCDocu.FchUbiA
          CcbCDocu.FlgSit  = CcbCDocu.FlgSitA
          CcbCDocu.FlgSitA = ''  
          CcbCDocu.FchUbiA = ?
          CcbCDocu.FlgUbiA = ''
          CcbCDocu.CodCta  = ''
          CcbCDocu.CodAge  = ''. 
    END.
    RELEASE CcbCDocu.
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
   

   FOR EACH MVTO:
       CREATE CcbDMvto.
       ASSIGN CcbDMvto.CodCia = CcbCMvto.CodCia 
              CcbDMvto.CodDoc = CcbCMvto.CodDoc 
              CcbDMvto.NroDoc = CcbCMvto.NroDoc
              CcbDMvto.TpoRef = MVTO.TpoRef
              CcbDMvto.CodRef = MVTO.CodRef
              CcbDMvto.NroRef = MVTO.NroRef
              CcbDMvto.FchEmi = MVTO.FchEmi
              CcbDMvto.FchVto = MVTO.FchVto
              CcbDMvto.ImpDoc = MVTO.ImpTot
              CcbDMvto.ImpTot = MVTO.ImpTot
              CcbDMvto.NroDep = MVTO.NroDep.
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
DEFINE VAR s-canlet AS INTEGER NO-UNDO INITIAL 0.

FIND B-CMVTO WHERE B-CMVTO.codcia = CcbCMvto.codcia AND
     B-CMVTO.Coddoc = CcbCMvto.coddoc AND
     B-CMVTO.NroDoc = CcbCMvto.nrodoc NO-ERROR.
     
IF AVAILABLE B-CMVTO THEN DO:
   ASSIGN
       B-CMVTO.ImpDoc = 0
       B-CMVTO.ImpTot = 0.
   FOR EACH MVTO:
       s-canlet = s-canlet + 1.
       ASSIGN
            B-CMVTO.ImpDoc = B-CMVTO.ImpDoc + MVTO.ImpDoc
            B-CMVTO.ImpTot = B-CMVTO.ImpTot + MVTO.ImpTot.
   END.
END.

ASSIGN
   B-CMVTO.NroLet = s-canlet      
   B-CMvto.PorInt = s-porgas
   B-CMvto.ImpInt = ROUND(B-CMVTO.ImpTot * (s-porgas / 100), 2).
   
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
  FOR EACH MVTO:
     DELETE MVTO.
  END.
  L-CREA = YES.
  s-tpocmb = CcbCMvto.TpoCmb.
  RUN Numero-de-Documento(NO).
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY @ CcbCMvto.FchDoc
             FacCfgGn.Tpocmb[1] @ CcbCMvto.TpoCmb
             STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999") @ CcbCMvto.NroDoc.
     S-TIPO = "".
  END.
  RUN Actualiza-Deta.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('Browse2').

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
     ASSIGN CcbCMvto.CodCia = S-CODCIA
            CcbCMvto.FlgEst = "E"
            CcbCMvto.CodDoc = S-CODDOC
            CcbCMvto.NroDoc = STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999")
            CcbCMvto.CodDiv = S-CODDIV
            CcbCMvto.usuario = S-USER-ID.
     DISPLAY CcbCMvto.NroDoc.
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
   FIND B-CMVTO WHERE ROWID(B-CMVTO) = ROWID(CcbCMvto) NO-ERROR.
   IF CcbCMvto.FlgEst = "A" THEN DO:
      MESSAGE 'El documento se enuentra anulado...' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
   END.
   
   RUN Verifica-Anulacion.
   IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".   
   
  /* consistencia de la fecha del cierre del sistema */
  DEF VAR dFchCie AS DATE.
  RUN gn/fecha-de-cierre (OUTPUT dFchCie).
  IF ccbcmvto.fchdoc <= dFchCie THEN DO:
      MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
          VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  /* fin de consistencia */

   DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
       RUN Borra-Flag.
       RUN Borra-Documento.   
       FIND B-CMVTO WHERE ROWID(B-CMVTO) = ROWID(CcbCMvto) NO-ERROR.
       IF AVAILABLE B-CMVTO THEN 
          ASSIGN CcbCMvto.FlgEst = "A"
                 CcbCMvto.Glosa  = '**** Documento Anulado ****'
                 CcbCMvto.ImpTot = 0
                 CcbCMvto.ImpDoc = 0.
       RELEASE B-CMVTO.
   END.
   RUN Procesa-Handle IN lh_Handle ('Browse1').
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
  IF AVAILABLE CcbCMvto THEN DO WITH FRAME {&FRAME-NAME}:
     FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
          cb-ctas.codcta = CcbCMvto.CodCta NO-LOCK NO-ERROR.
     IF AVAILABLE cb-ctas  THEN DO:
        DISPLAY cb-ctas.nomcta @ FILL-IN_Banco.
        integral.CcbCMvto.CodMon:SCREEN-VALUE  = STRING(cb-ctas.codmon, '9').
     END.
     FIND gn-agbco WHERE gn-agbco.CodCia = s-codcia AND
          gn-agbco.codbco = cb-ctas.codbco AND
          gn-agbco.codage = CcbCMvto.CodAge NO-LOCK NO-ERROR.
     IF AVAILABLE gn-agbco  THEN DO:
        DISPLAY gn-agbco.nomage @ FILL-IN-Agencia.
     END.
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

    GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "ccb/rbccb.prl"
        RB-OTHER-PARAMETERS = "s-NomCia = " + s-nomcia.
  CASE Ccbcmvto.coddoc:
    WHEN 'B/T' 
        THEN ASSIGN
                RB-REPORT-NAME = "Planilla de Transito"
                RB-INCLUDE-RECORDS = 'O'
                RB-FILTER = "Ccbcmvto.CodCia = " + STRING(Ccbcmvto.codcia) +
                            " AND Ccbcmvto.coddoc = '" + Ccbcmvto.coddoc + "'" +
                            " AND Ccbcmvto.nrodoc = '" + Ccbcmvto.nrodoc + "'".
        OTHERWISE
            ASSIGN                
                RB-REPORT-NAME = "Letras banco"
                RB-FILTER = "CCbCdocu.CodCia = " + string(S-CODCIA) +
                    " and CcbCdocu.CodDoc = " + 'LET' +
                    " and CcbCdocu.CodDiv = " + S-CODDIV +
                    " and CcbCdocu.Codcta = " + X-CTA +
                    " and CcbCDocu.FlgSit = " + S-FLGSIT +
                    " and CcbCDocu.FlgUbi = " + S-FLGUBI.
  END CASE.


    RUN lib/_Imprime2(
        RB-REPORT-LIBRARY,
        RB-REPORT-NAME,
        RB-INCLUDE-RECORDS,
        RB-FILTER,
        RB-OTHER-PARAMETERS).

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
  s-fchdoc = TODAY.
  
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

  RUN Genera-Detalle.   
  RUN Graba-Totales.
  RUN Actualiza-Flag.
  
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse1'). 
  
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
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
       FacCorre.CodDoc = S-CODDOC AND
       FacCorre.CodDiv = S-CODDIV NO-ERROR.
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

    CASE HANDLE-CAMPO:name:
        WHEN "CodAge" THEN 
            ASSIGN input-var-1 = s-codbco.
        WHEN "CodCta" THEN 
            ASSIGN input-var-1 = "104".
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
  {src/adm/template/snd-list.i "CcbCMvto"}

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
DO WITH FRAME {&FRAME-NAME}:
   IF CcbCMvto.CodCta:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de cuenta no puede se blanco " VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY":U TO CcbCMvto.CodCta.
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
RETURN 'ADM-ERROR'.   /* No debe permitir realizar modificaciones  */
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Verifica-Anulacion V-table-Win 
PROCEDURE Verifica-Anulacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR s-resp AS CHAR NO-UNDO.
s-resp = ''.

FOR EACH CcbDMvto WHERE CcbDMvto.CodCia = CcbCMvto.CodCia AND
    CcbDMvto.CodDoc = CcbCMvto.CodDoc AND
    CcbDMvto.NroDoc = CcbCMvto.NroDoc:
    FIND CcbCDocu WHERE CcbCDocu.codcia = CcbDMvto.codcia AND
         CcbCDocu.CodDoc = CcbDMvto.codref AND
         CcbCDocu.NroDoc = CcbDMvto.Nroref NO-ERROR.
    IF AVAILABLE CcbCDocu THEN 
       IF CcbCDocu.FlgEst <> 'P' OR CcbCDocu.FlgUbi = 'C' OR
          CcbCDocu.SdoAct <> CcbCDocu.ImpTot THEN DO:
          s-resp = 'No'.
          LEAVE.
       END. 
END.
IF s-resp = 'No' THEN DO:
   MESSAGE 'Las letras registras amortizaciones' VIEW-AS ALERT-BOX ERROR.
   RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

