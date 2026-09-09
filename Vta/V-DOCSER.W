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

DEFINE SHARED VARIABLE lh_Handle AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE cl-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA  AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC  AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE SHARED VARIABLE S-CODMON  AS INTEGER.
DEFINE SHARED VARIABLE S-CODALM  AS CHAR.
DEFINE SHARED VARIABLE S-CODCLI  AS CHAR.
DEFINE SHARED VARIABLE S-NROSER  AS INTEGER.

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
DEFINE VARIABLE S-CODMOV       AS INTEGER   NO-UNDO. 
DEFINE VARIABLE I-CODMON       AS INTEGER   NO-UNDO. 
DEFINE VARIABLE R-ROWID        AS ROWID     NO-UNDO. 
DEFINE VARIABLE C-CODVEN       AS CHAR      NO-UNDO.
DEFINE VARIABLE D-FCHVTO       AS DATE      NO-UNDO.
DEFINE VARIABLE F-totdias      AS INTEGER   NO-UNDO.
DEFINE VARIABLE F-DIST         AS CHAR      NO-UNDO. 
DEFINE VARIABLE F-DPTO         AS CHAR      NO-UNDO.
DEFINE VARIABLE F-PROV         AS CHAR      NO-UNDO.
DEFINE VARIABLE F-ImpTot       AS DECIMAL   NO-UNDO.
DEFINE VARIABLE F-ImpVta       AS DECIMAL   NO-UNDO.
DEFINE VARIABLE F-ImpIgv       AS DECIMAL   NO-UNDO.

DEFINE BUFFER B-CDOCU FOR CcbCDocu.
FIND FacDocum WHERE FacDocum.CodCia = S-CODCIA AND
     FacDocum.CodDoc = S-CODDOC NO-LOCK NO-ERROR.
IF AVAILABLE FacDocum THEN S-CODMOV = FacDocum.CodMov.

FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV AND
     FacCorre.NroSer = S-NROSER  NO-LOCK NO-ERROR.
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
&Scoped-define EXTERNAL-TABLES CcbCDocu
&Scoped-define FIRST-EXTERNAL-TABLE CcbCDocu


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCDocu.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCDocu.CodCli CcbCDocu.NomCli ~
CcbCDocu.DirCli CcbCDocu.RucCli CcbCDocu.FchDoc CcbCDocu.CodVen ~
CcbCDocu.FchVto CcbCDocu.FmaPgo CcbCDocu.LugEnt CcbCDocu.CodMon ~
CcbCDocu.Glosa CcbCDocu.ImpTot 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define ENABLED-OBJECTS RECT-19 RECT-22 
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.CodCli ~
CcbCDocu.NomCli CcbCDocu.TpoCmb CcbCDocu.DirCli CcbCDocu.RucCli ~
CcbCDocu.FchDoc CcbCDocu.CodVen CcbCDocu.FchVto CcbCDocu.FmaPgo ~
CcbCDocu.LugEnt CcbCDocu.CodMon CcbCDocu.Glosa CcbCDocu.ImpVta ~
CcbCDocu.ImpIgv CcbCDocu.ImpTot 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS F-nOMvEN F-CndVta F-Estado 

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
     SIZE 37.86 BY .69 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .69
     FONT 0 NO-UNDO.

DEFINE VARIABLE F-nOMvEN AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.86 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.14 BY 10.69.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 12.29 BY .85.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.NroDoc AT ROW 1.15 COL 8.14 COLON-ALIGNED FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 17.29 BY .69
          FONT 1
     CcbCDocu.CodCli AT ROW 1.92 COL 8.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .69
     CcbCDocu.NomCli AT ROW 1.92 COL 18.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 38.14 BY .69
     CcbCDocu.TpoCmb AT ROW 1.85 COL 71.43 COLON-ALIGNED
          LABEL "T/ Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbCDocu.DirCli AT ROW 2.65 COL 8.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 34 BY .69
     CcbCDocu.RucCli AT ROW 2.69 COL 47 COLON-ALIGNED FORMAT "9(8)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbCDocu.FchDoc AT ROW 2.58 COL 71.43 COLON-ALIGNED
          LABEL "F/ Emision"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbCDocu.CodVen AT ROW 3.35 COL 8.14 COLON-ALIGNED FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 4.43 BY .69
     CcbCDocu.FchVto AT ROW 3.27 COL 71.43 COLON-ALIGNED
          LABEL "Vencimient"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbCDocu.FmaPgo AT ROW 4 COL 8.14 COLON-ALIGNED
          LABEL "Cond.Vta" FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 4.43 BY .69
     CcbCDocu.LugEnt AT ROW 4.73 COL 8.14 COLON-ALIGNED
          LABEL "Entregar en"
          VIEW-AS FILL-IN 
          SIZE 48.86 BY .69
     CcbCDocu.CodMon AT ROW 4.77 COL 73.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 10.72 BY .62
     CcbCDocu.Glosa AT ROW 5.42 COL 2 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 500 SCROLLBAR-VERTICAL
          SIZE 57 BY 6.04
          FONT 2
     CcbCDocu.ImpVta AT ROW 7.35 COL 69 COLON-ALIGNED FORMAT "-Z,ZZZ,ZZ9.99"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
          FONT 2
     CcbCDocu.ImpIgv AT ROW 9.04 COL 69 COLON-ALIGNED FORMAT "-Z,ZZZ,ZZ9.99"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
          FONT 2
     CcbCDocu.ImpTot AT ROW 10.58 COL 69 COLON-ALIGNED FORMAT "-Z,ZZZ,ZZ9.99"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
          FONT 2
     F-nOMvEN AT ROW 3.35 COL 19.14 COLON-ALIGNED NO-LABEL
     F-CndVta AT ROW 4 COL 19.14 COLON-ALIGNED NO-LABEL
     F-Estado AT ROW 1.12 COL 69.86 COLON-ALIGNED NO-LABEL
     "Moneda:" VIEW-AS TEXT
          SIZE 6.43 BY .5 AT ROW 4.77 COL 65.43
     RECT-19 AT ROW 1 COL 1
     RECT-22 AT ROW 4.65 COL 73
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
         HEIGHT             = 10.69
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN CcbCDocu.CodVen IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-nOMvEN IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchDoc IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchVto IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FmaPgo IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR EDITOR CcbCDocu.Glosa IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.ImpIgv IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.ImpTot IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.ImpVta IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.LugEnt IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.RucCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.TpoCmb IN FRAME F-Main
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

&Scoped-define SELF-NAME CcbCDocu.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodCli V-table-Win
ON LEAVE OF CcbCDocu.CodCli IN FRAME F-Main /* Cliente */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
        gn-clie.CodCli = CcbCDocu.CodCli:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-clie  THEN DO:
      S-CODCLI = SELF:SCREEN-VALUE.
      RUN VTA\D-RegCli.R (INPUT-OUTPUT S-CODCLI).
      IF S-CODCLI = "" THEN RETURN NO-APPLY.
      FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
           gn-clie.CodCli = S-CODCLI NO-LOCK NO-ERROR.
   END.
   DISPLAY gn-clie.NomCli @ CcbCDocu.NomCli 
           gn-clie.Ruc    @ CcbCDocu.RucCli 
           gn-clie.DirCli @ CcbCDocu.DirCli 
           gn-clie.CndVta @ CcbCDocu.FmaPgo 
           gn-clie.CodVen @ CcbCDocu.CodVen 
           gn-clie.DirEnt @ CcbCDocu.LugEnt WITH FRAME {&FRAME-NAME}.
           S-CODCLI = SELF:SCREEN-VALUE.

   ASSIGN F-DIST = gn-clie.CodDist
          F-DPTO = gn-clie.CodDept
          F-PROV = gn-clie.CodProv.
 
   IF FacCfgGn.CliVar <> SELF:SCREEN-VALUE THEN 
      ASSIGN CcbCDocu.NomCli:SENSITIVE IN FRAME {&FRAME-NAME} = NO
             CcbCDocu.DirCli:SENSITIVE IN FRAME {&FRAME-NAME} = NO
             CcbCDocu.RucCli:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
   ELSE 
      ASSIGN CcbCDocu.NomCli:SENSITIVE IN FRAME {&FRAME-NAME} = YES
             CcbCDocu.DirCli:SENSITIVE IN FRAME {&FRAME-NAME} = YES
             CcbCDocu.RucCli:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
   /* Ubica la Condicion Venta */
   FIND gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF AVAILABLE gn-convt THEN DO:
      f-totdias = gn-convt.totdias.
      F-CndVta:SCREEN-VALUE = gn-convt.nombr.
      DISPLAY TODAY + INTEGER(ENTRY(NUM-ENTRIES(gn-ConVt.Vencmtos),gn-ConVt.Vencmtos)) @ CcbCDocu.FchVto WITH FRAME {&FRAME-NAME}.
   END.   
   ELSE CcbCDocu.FmaPgo:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodMon V-table-Win
ON VALUE-CHANGED OF CcbCDocu.CodMon IN FRAME F-Main /* Moneda */
DO:
  S-CODMON = INTEGER(SELF:SCREEN-VALUE).
  RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodVen V-table-Win
ON LEAVE OF CcbCDocu.CodVen IN FRAME F-Main /* Vendedor */
DO:
  F-NomVen = "".
  IF CcbCDocu.CodVen:SCREEN-VALUE <> "" THEN DO: 
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA AND 
          gn-ven.CodVen = CcbCDocu.CodVen:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
  END.
  DISPLAY F-NomVen WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.FchDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.FchDoc V-table-Win
ON LEAVE OF CcbCDocu.FchDoc IN FRAME F-Main /* F/ Emision */
DO:
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY INPUT CcbCDocu.FchDoc  @ CcbCDocu.FchVto.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.FmaPgo V-table-Win
ON LEAVE OF CcbCDocu.FmaPgo IN FRAME F-Main /* Cond.Vta */
DO:
  IF CcbCDocu.FmaPgo:SCREEN-VALUE <> "" THEN DO:
     F-CndVta:SCREEN-VALUE = "".
     FIND gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt THEN DO WITH FRAME {&FRAME-NAME}:
        F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
        IF gn-convt.totdias > F-totdias THEN DO:
            MESSAGE " Condicion Credito es Mayor al Asignado " VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        DISPLAY INPUT CcbCDocu.FchDoc + INTEGER(ENTRY(NUM-ENTRIES(gn-ConVt.Vencmtos),gn-ConVt.Vencmtos)) @ CcbCDocu.FchVto.
     END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.ImpTot
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.ImpTot V-table-Win
ON LEAVE OF CcbCDocu.ImpTot IN FRAME F-Main /* Importe Total */
DO:
  F-ImpTot = DECIMAL(CcbCDocu.ImpTot:SCREEN-VALUE).
  IF  F-ImpTot <> 0 THEN DO:
      F-ImpVta = ROUND(F-ImpTot / (1 + FacCfgGn.PorIgv / 100),2).
      F-ImpIgv = F-ImpTot - F-ImpVta.
     DISPLAY  F-ImpVta @ CcbCDocu.ImpVta
              F-ImpIgv @ CcbCDocu.ImpIgv WITH FRAME {&FRAME-NAME}.
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
             TODAY @ CcbCDocu.FchVto
             FacCfgGn.CliVar @ CcbCDocu.CodCli
             FacCfgGn.Tpocmb[1] @ CcbCDocu.TpoCmb
             0 @ CcbCDocu.ImpIgv 
             0 @ CcbCDocu.ImpTot 
             0 @ CcbCDocu.ImpVta
             STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999") @ CcbCDocu.NroDoc.
     CcbCDocu.NomCli:SENSITIVE = NO.
     CcbCDocu.DirCli:SENSITIVE = NO.
     CcbCDocu.RucCli:SENSITIVE = NO.
     CcbCDocu.FchVto:SENSITIVE = NO.
     CcbCDocu.CodMon:SCREEN-VALUE = "1".
     S-CODMON = 1.
     S-CODCLI = FacCfgGn.CliVar.
  END.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').

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
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
       FacCorre.CodDoc = S-CODDOC AND FacCorre.CodDiv = S-CODDIV AND
       FacCorre.NroSer = S-NROSER EXCLUSIVE-LOCK.
  I-NroDoc = FacCorre.Correlativo.
  ASSIGN CcbCDocu.NroDoc = STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999").
         FacCorre.Correlativo = FacCorre.Correlativo + 1.
  RELEASE FacCorre.
  DISPLAY CcbCDocu.NroDoc. 
  
  F-ImpTot = CcbCDocu.ImpTot.
  F-ImpVta = ROUND(F-ImpTot / (1 + FacCfgGn.PorIgv / 100),2).
  F-ImpIgv = F-ImpTot - F-ImpVta.
  ASSIGN 
    CcbCDocu.CodCia  = S-CODCIA
    CcbCDocu.CodAlm  = S-CODALM
    CcbCDocu.FlgEst  = "P"
    CcbCDocu.CodDoc  = S-CODDOC
    CcbCDocu.CodMov  = S-CODMOV 
    CcbCDocu.CodDiv  = S-CODDIV
    CcbCDocu.Tipo    = "SERVICIO"
    CcbCDocu.TpoFac  = "S"
    CcbCDocu.TpoCmb  = FacCfgGn.TpoCmb[1]
    CcbCDocu.PorIgv  = FacCfgGn.PorIgv
    CcbCDocu.CodDist = F-DIST
    CcbCDocu.CodProv = F-PROV
    CcbCDocu.CodDpto = F-DPTO
    CcbCDocu.ImpInt  = 0
    CcbCDocu.ImpDto  = 0
    CcbCDocu.ImpExo  = 0
    CcbCDocu.ImpIsc  = 0
    CcbCDocu.ImpBrt  = F-ImpVta 
    CcbCDocu.ImpVta  = F-ImpVta 
    CcbCDocu.ImpIgv  = F-ImpIgv 
    CcbCDocu.SdoAct  = CcbCDocu.ImpTot
    CcbCDocu.usuario = S-USER-ID.

  FIND gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt 
  THEN IF gn-convt.totdias = 0 
        THEN CcbCDocu.TipVta = "1".
        ELSE CcbCDocu.TipVta = "2".
      
  FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
      gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie  
  THEN ASSIGN 
        CcbCDocu.CodDpto = gn-clie.CodDept 
        CcbCDocu.CodProv = gn-clie.CodProv 
        CcbCDocu.CodDist = gn-clie.CodDist.

 /* ACTUALIZAR EL CENTRO DE COSTO 22.07.04 CY */
     FIND GN-VEN WHERE gn-ven.codcia = s-codcia
        AND gn-ven.codven = ccbcdocu.codven
        NO-LOCK NO-ERROR.
     IF AVAILABLE GN-VEN THEN ccbcdocu.cco = gn-ven.cco.

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
   IF NOT AVAILABLE ccbcdocu THEN RETURN "ADM-ERROR".
   IF CcbCDocu.FlgEst = "A" THEN DO:
      MESSAGE 'El documento se enuentra anulado...' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
   END.
   IF CcbCDocu.FlgEst = 'C' THEN DO:
      MESSAGE 'El documento se encuentra Cancelado' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
   END.
   IF CcbCDocu.SdoAct < CcbCDocu.ImpTot  THEN DO:
      MESSAGE 'El documento registra amortizaciones...' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
   END.
   
   /* Valida Password */
   
  {adm/i-DocPssw.i s-CodCia s-CodDoc ""DEL""}
  
/*   DEFINE VAR RPTA AS CHAR NO-UNDO.
 *    FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
 *    RUN ALM/D-CLAVE.R(FacCfgGn.Cla_Venta,OUTPUT RPTA). 
 *    IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".*/
     
   DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
      FIND B-CDOCU WHERE ROWID(B-CDOCU) = ROWID(CcbCDocu) NO-ERROR.
      IF AVAILABLE B-CDOCU THEN 
         ASSIGN B-CDOCU.FlgEst = "A"
                B-CDOCU.FchAnu =  TODAY
                B-CDOCU.UsuAnu =  S-USER-ID
                B-CDOCU.ImpBrt =  0    B-CDOCU.ImpDto =  0    B-CDOCU.ImpExo =  0    
                B-CDOCU.ImpIgv =  0    B-CDOCU.ImpInt =  0    B-CDOCU.ImpIsc =  0
                B-CDOCU.ImpTot =  0    B-CDOCU.ImpVta =  0    B-CDOCU.SdoAct =  0.
      RELEASE B-CDOCU.
   END.
   
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
     IF CcbCDocu.FlgEst = "P" THEN F-Estado:SCREEN-VALUE = "PENDIENTE".
     IF CcbCDocu.FlgEst = "A" THEN F-Estado:SCREEN-VALUE = "ANULADO".
     IF CcbCDocu.FlgEst = "C" THEN F-Estado:SCREEN-VALUE = "CANCELADO".
     IF CcbCDocu.CodCli <> FacCfgGn.CliVar THEN DO:
        FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
             gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie  THEN 
           DISPLAY gn-clie.DirCli @ CcbCDocu.DirCli 
                      gn-clie.Ruc @ CcbCDocu.RucCli.
     END.
     F-NomVen:screen-value = "".
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA AND 
          gn-ven.CodVen = CcbCDocu.CodVen NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
     F-CndVta:SCREEN-VALUE = "".
     FIND gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
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
  
  RUN VTA\R-IMPFSE.R(ROWID(CcbCDocu)).
  
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
          FacCorre.CodDiv = S-CODDIV AND
          FacCorre.NroSer = S-NROSER EXCLUSIVE-LOCK NO-ERROR.
  ELSE
     FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = S-CODDOC AND
          FacCorre.CodDiv = S-CODDIV AND
          FacCorre.NroSer = S-NROSER EXCLUSIVE-LOCK NO-ERROR.
  
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
  IF p-state = 'update-begin':U THEN DO WITH FRAME {&FRAME-NAME}:
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
DEFINE VARIABLE F-TOT AS DECIMAL INIT 0 NO-UNDO.
DO WITH FRAME {&FRAME-NAME} :
   IF CcbCDocu.CodCli:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO CcbCDocu.CodCli.
      RETURN "ADM-ERROR".   
   END.
   IF CcbCDocu.NomCli:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Nombre del cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO CcbCDocu.CodCli.
      RETURN "ADM-ERROR".   
   END.
   IF CcbCDocu.RucCli:SCREEN-VALUE = "" AND S-CODDOC = "FAC" THEN DO:
      MESSAGE "Cliente debe Tener RUC para otorgarle Factura" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO CcbCDocu.RucCli.
      RETURN "ADM-ERROR".   
   END.

   IF CcbCDocu.CodVen:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de Vendedor no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO CcbCDocu.CodVen.
      RETURN "ADM-ERROR".   
   END.
   IF CcbCDocu.FmaPgo:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Condicion Venta no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO CcbCDocu.FmaPgo.
      RETURN "ADM-ERROR".   
   END.
   F-ImpTot = DECIMAL(CcbCDocu.ImpTot:SCREEN-VALUE).
   IF F-ImpTot = 0 THEN DO:
      MESSAGE "Importe total debe ser mayor a Ceroo" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO CcbCDocu.ImpTot.
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

