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
GET-KEY-VALUE SECTION "Startup" KEY "Base" VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "ccb\rbccb.prl".

DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Renovacion de Letras".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

/* Shared Variable Definitions ---                                       */

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-FCHDOC   AS DATE.
DEFINE SHARED TEMP-TABLE MVTO LIKE CcbDMvto.
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER.
DEFINE SHARED VARIABLE S-TPOCMB   AS DECIMAL.
DEFINE SHARED VARIABLE S-IMPTOT   AS DECIMAL.
DEFINE SHARED VARIABLE S-NROREF   AS CHAR.
DEFINE SHARED VARIABLE cl-codcia  AS INT.
S-CODMON = 1.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NRODOC       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE R-ROWID        AS ROWID     NO-UNDO. 
DEFINE VARIABLE S-CODBCO       AS CHAR      NO-UNDO.
DEFINE VARIABLE S-FLGUBI       AS CHAR      NO-UNDO.
DEFINE VARIABLE S-FLGSIT       AS CHAR      NO-UNDO.
DEFINE VARIABLE S-CODCTA       AS CHAR      NO-UNDO.

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
&Scoped-Define ENABLED-FIELDS CcbCMvto.CodCli CcbCMvto.TpoCmb ~
CcbCMvto.Glosa CcbCMvto.NroRef CcbCMvto.TipInt CcbCMvto.PorInt 
&Scoped-define ENABLED-TABLES CcbCMvto
&Scoped-define FIRST-ENABLED-TABLE CcbCMvto
&Scoped-Define ENABLED-OBJECTS RECT-20 RECT-21 RECT-19 
&Scoped-Define DISPLAYED-FIELDS CcbCMvto.NroDoc CcbCMvto.FchDoc ~
CcbCMvto.CodCli CcbCMvto.TpoCmb CcbCMvto.Glosa CcbCMvto.CodMon ~
CcbCMvto.NroRef CcbCMvto.TipInt CcbCMvto.PorInt CcbCMvto.ImpTot 
&Scoped-define DISPLAYED-TABLES CcbCMvto
&Scoped-define FIRST-DISPLAYED-TABLE CcbCMvto
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_Cliente F-Emision F-Vencimiento ~
F-Saldo F-Amortiza 

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
DEFINE VARIABLE F-Amortiza AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Importe Amortizar" 
     VIEW-AS FILL-IN 
     SIZE 11.86 BY .69 NO-UNDO.

DEFINE VARIABLE F-Emision AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Emision" 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .69 NO-UNDO.

DEFINE VARIABLE F-Saldo AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Saldo" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .69 NO-UNDO.

DEFINE VARIABLE F-Vencimiento AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Vencimiento" 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_Cliente AS CHARACTER FORMAT "x(50)" 
     VIEW-AS FILL-IN 
     SIZE 31.86 BY .69.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 2.58.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32.43 BY 1.04.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80.14 BY 3.65.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCMvto.NroDoc AT ROW 1.23 COL 11.86 COLON-ALIGNED
          LABEL "Numero"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbCMvto.FchDoc AT ROW 1.31 COL 68 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbCMvto.CodCli AT ROW 1.96 COL 11.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     FILL-IN_Cliente AT ROW 1.96 COL 24 COLON-ALIGNED NO-LABEL
     CcbCMvto.TpoCmb AT ROW 2.08 COL 68 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .69
     CcbCMvto.Glosa AT ROW 2.69 COL 11.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44.72 BY .69
     CcbCMvto.CodMon AT ROW 4 COL 67.86 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dólares", 2
          SIZE 9.14 BY 1.15
     CcbCMvto.NroRef AT ROW 4.04 COL 12.14 COLON-ALIGNED
          LABEL "LETRA"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     F-Emision AT ROW 4.04 COL 40.86 COLON-ALIGNED
     F-Vencimiento AT ROW 4.77 COL 40.86 COLON-ALIGNED
     F-Saldo AT ROW 5.58 COL 64.14 COLON-ALIGNED
     CcbCMvto.TipInt AT ROW 6.04 COL 17 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Porcentaje", "P":U,
"Importe", "I":U
          SIZE 11 BY 1.15
     CcbCMvto.PorInt AT ROW 6.38 COL 41.29 COLON-ALIGNED
          LABEL "Porcentaje" FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 6.72 BY .69
     F-Amortiza AT ROW 6.38 COL 64 COLON-ALIGNED
     CcbCMvto.ImpTot AT ROW 7.65 COL 64 COLON-ALIGNED
          LABEL "Saldo a Finaciar" FORMAT "-ZZ,ZZZ,ZZ9.99"
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .69
     "Moneda" VIEW-AS TEXT
          SIZE 6.57 BY .5 AT ROW 4.35 COL 59.29
     "Amortizar en" VIEW-AS TEXT
          SIZE 8.86 BY .5 AT ROW 6.42 COL 6.86
     RECT-20 AT ROW 7.5 COL 49
     RECT-21 AT ROW 3.73 COL 1
     RECT-19 AT ROW 1.04 COL 1
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
         HEIGHT             = 7.62
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

/* SETTINGS FOR RADIO-SET CcbCMvto.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Amortiza IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Emision IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Saldo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Vencimiento IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCMvto.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Cliente IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCMvto.ImpTot IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCMvto.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCMvto.NroRef IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCMvto.PorInt IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
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

&Scoped-define SELF-NAME CcbCMvto.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.CodCli V-table-Win
ON LEAVE OF CcbCMvto.CodCli IN FRAME F-Main /* Cliente */
DO:
  FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
       gn-clie.codcli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN DO:
     MESSAGE 'Cliente no existe' VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY gn-clie.nomcli @ FILL-IN_Cliente.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Amortiza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Amortiza V-table-Win
ON LEAVE OF F-Amortiza IN FRAME F-Main /* Importe Amortizar */
DO:
  /*ASSIGN F-Saldo F-Amortiza.*/
  DO WITH FRAME {&FRAME-NAME}:
      CcbCMvto.ImpTot:SCREEN-VALUE = STRING(DECIMAL(F-Saldo:SCREEN-VALUE) - DECIMAL(F-Amortiza:SCREEN-VALUE)).
      s-imptot        = DECIMAL(CcbCMvto.ImpTot:SCREEN-VALUE).
      /*DISPLAY CcbCMvto.ImpTot.*/
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCMvto.NroRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.NroRef V-table-Win
ON LEAVE OF CcbCMvto.NroRef IN FRAME F-Main /* LETRA */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND CcbCDocu WHERE CcbCDocu.codcia = s-codcia AND
       CcbCDocu.coddoc = 'LET' AND
       CcbCDocu.nrodoc = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE CcbCDocu THEN DO:
     MESSAGE 'Letra no se encuentra registrada' VIEW-AS ALERT-BOX ERROR.
     RETURN 'NO-APPLY'.
  END.
  /* Debe estar en banco y no protestada */
  IF NOT (Ccbcdocu.flgest = "P" AND Ccbcdocu.flgubi = "B") THEN DO:
      MESSAGE 'La letra NO se encuentra en el banco' VIEW-AS ALERT-BOX ERROR.
      RETURN 'NO-APPLY'.
  END.
  IF LOOKUP(Ccbcdocu.flgsit, 'C,G,D') = 0 THEN DO:
      MESSAGE 'La letra NO está en cobranza en el banco' VIEW-AS ALERT-BOX ERROR.
      RETURN 'NO-APPLY'.
  END.
  /*
  IF CcbCDocu.FlgEst = 'C' THEN DO:
     MESSAGE 'El documento se encuentra cancelado' VIEW-AS ALERT-BOX ERROR.
     RETURN 'NO-APPLY'.
  END.
  IF CcbCDocu.FlgUbi = 'C' AND CcbCDocu.FlgSit = 'P' THEN DO:
     MESSAGE 'El documento se encuentra en Protesto' VIEW-AS ALERT-BOX ERROR.
     RETURN 'NO-APPLY'.
  END.
  */
  IF CcbCDocu.CodCli <> CcbCMvto.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} THEN DO:
     MESSAGE 'Letra no corresponde al cliente' VIEW-AS ALERT-BOX ERROR.
     RETURN 'NO-APPLY'.
  END.
  s-nroref = SELF:SCREEN-VALUE.
  s-flgubi = CcbCDocu.FlgUbi.
  s-flgsit = CcbCDocu.Flgsit.
  s-codcta = CcbCDocu.Codcta.
  
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY 
       CcbCDocu.FchDoc @ F-Emision 
       CcbCDocu.SdoAct @ F-Saldo 
       CcbCDocu.FchVto @ F-Vencimiento.
           
     CcbCMvto.CodMon:SCREEN-VALUE = STRING(CcbCDocu.CodMon, '9').
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCMvto.PorInt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.PorInt V-table-Win
ON LEAVE OF CcbCMvto.PorInt IN FRAME F-Main /* Porcentaje */
DO:
  /*ASSIGN 
     F-saldo.*/
  DO WITH FRAME {&FRAME-NAME}:
      F-Amortiza      = DECIMAL(F-Saldo:SCREEN-VALUE) * ( INTEGER(CcbCMvto.PorInt:SCREEN-VALUE) / 100).
      CcbCMvto.ImpTot:SCREEN-VALUE = STRING(DECIMAL(F-Saldo:SCREEN-VALUE) - F-Amortiza).
      s-imptot        = DECIMAL(CcbCMvto.ImpTot:SCREEN-VALUE).
     DISPLAY 
         F-Amortiza 
         /*CcbCMvto.ImpTot*/.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCMvto.TipInt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.TipInt V-table-Win
ON VALUE-CHANGED OF CcbCMvto.TipInt IN FRAME F-Main /* Tipo */
DO:
  CASE CcbCMvto.TipInt:SCREEN-VALUE IN FRAME {&FRAME-NAME} :
  WHEN 'P' THEN DO WITH FRAME {&FRAME-NAME}:
        CcbCMvto.PorInt:SENSITIVE = Yes.
        F-Amortiza:SENSITIVE = No.
        APPLY 'ENTRY' TO CcbCMvto.PorInt.
     END.
  WHEN 'I' THEN DO WITH FRAME {&FRAME-NAME}:
        CcbCMvto.PorInt:SENSITIVE = No.
        F-Amortiza:SENSITIVE = Yes.
        APPLY 'ENTRY' TO F-Amortiza.
     END.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCMvto.TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.TpoCmb V-table-Win
ON LEAVE OF CcbCMvto.TpoCmb IN FRAME F-Main /* Tipo de cambio */
DO:
/*   ASSIGN CcbCMvto.TpoCmb. */
  S-TPOCMB = INPUT CcbCMvto.TpoCmb.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Saldo V-table-Win 
PROCEDURE Actualiza-Saldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND CcbCDocu WHERE CcbCDocu.CodCia = CcbCMvto.CodCia AND
     CcbCDocu.CodDoc = 'LET' AND  
     CcbCDocu.NroDoc = CcbCMvto.NroRef NO-ERROR.
IF AVAILABLE CcbCDocu THEN DO:
   IF CcbCDocu.CodMon = CcbCMvto.CodMon THEN
      ASSIGN
         CcbCDocu.SdoAct = CcbCDocu.SdoAct - CcbCMvto.ImpTot.
   ELSE DO:
      IF CcbCDocu.CodMon = 1 THEN
         ASSIGN
            CcbCDocu.SdoAct = CcbCDocu.SdoAct - (CcbCMvto.ImpTot * CcbCMvto.TpoCmb).
      ELSE
         ASSIGN
            CcbCDocu.SdoAct = CcbCDocu.SdoAct - (CcbCMvto.ImpTot / CcbCMvto.TpoCmb).
   END.
   ASSIGN
      CcbCDocu.SdoAct = IF CcbCDocu.SdoAct <= 0 THEN 0 ELSE CcbCDocu.SdoAct
      CcbCDocu.FlgEst = IF CcbCDocu.SdoAct = 0 THEN 'C' ELSE CcbCDocu.FlgEst.
END.

/* Grabar cancelacion */
CREATE CcbDCaja.
ASSIGN
   CcbDCaja.CodCia = CcbCMvto.CodCia 
   CcbDCaja.CodCli = CcbCMvto.CodCli
   CcbDCaja.CodDoc = CcbCMvto.CodDoc 
   CcbDCaja.CodMon = CcbCMvto.CodMon 
   CcbDCaja.CodRef = 'LET'
   CcbDCaja.FchDoc = CcbCMvto.FchDoc
   CcbDCaja.ImpTot = CcbCMvto.ImpTot 
   CcbDCaja.NroDoc = CcbCMvto.NroDoc 
   CcbDCaja.NroRef = CcbCMvto.NroRef 
   CcbDCaja.TpoCmb = CcbCMvto.TpoCmb. 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Letras V-table-Win 
PROCEDURE Borra-Letras :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Actualiza el Saldo de la letra */
FIND CcbCDocu WHERE CcbCDocu.CodCia = CcbCMvto.CodCia AND
     CcbCDocu.CodDoc = 'LET' AND  
     CcbCDocu.NroDoc = CcbCMvto.NroRef NO-ERROR.
IF AVAILABLE CcbCDocu THEN DO:
   IF CcbCDocu.CodMon = CcbCMvto.CodMon THEN
      ASSIGN
         CcbCDocu.SdoAct = CcbCDocu.SdoAct + CcbCMvto.ImpTot.
   ELSE DO:
      IF CcbCDocu.CodMon = 1 THEN
         ASSIGN
            CcbCDocu.SdoAct = CcbCDocu.SdoAct + (CcbCMvto.ImpTot * CcbCMvto.TpoCmb).
      ELSE
         ASSIGN
            CcbCDocu.SdoAct = CcbCDocu.SdoAct + (CcbCMvto.ImpTot / CcbCMvto.TpoCmb).
   END.
   ASSIGN
      CcbCDocu.SdoAct = IF CcbCDocu.SdoAct <= 0 THEN 0 ELSE CcbCDocu.SdoAct
      CcbCDocu.FlgEst = IF CcbCDocu.SdoAct = 0 THEN 'C' ELSE 'P'.
END.

/* Eliminar el documento cancelado en caja */
FOR EACH CcbDCaja WHERE CcbDCaja.CodCia = CcbCMvto.CodCia AND
     CcbDCaja.CodDoc = CcbCMvto.CodDoc AND
     CcbDCaja.NroDoc = CcbCMvto.NroDoc:
     DELETE CcbDCaja.
END.

/* Elimina Letras */
FOR EACH CcbCDocu WHERE CcbCDocu.codcia = CcbCMvto.codcia AND
    CcbCDocu.codref = CcbCMvto.coddoc AND
    CcbCDocu.nroref = CcbCMvto.nrodoc:
    DELETE CcbCDocu.
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
              CcbDMvto.CodRef = MVTO.CodRef
              CcbDMvto.NroRef = MVTO.NroRef
              CcbDMvto.FchEmi = MVTO.FchEmi
              CcbDMvto.FchVto = MVTO.FchVto
              CcbDMvto.ImpDoc = MVTO.ImpTot
              CcbDMvto.ImpTot = MVTO.ImpTot.
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
     
IF AVAILABLE B-CMVTO THEN 
   FOR EACH MVTO:
       s-canlet = s-canlet + 1.
   END.

ASSIGN
   B-CMVTO.NroLet = s-canlet
   B-CMVTO.ImpDoc = B-CMVTO.ImpTot.      
   
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
  /*s-tpocmb = CcbCMvto.TpoCmb.*/
  s-tpocmb = FacCfgGn.Tpocmb[1].
  RUN Numero-de-Documento(NO).
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY @ CcbCMvto.FchDoc
             FacCfgGn.Tpocmb[1] @ CcbCMvto.TpoCmb
             STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999") @ CcbCMvto.NroDoc.
    CcbCMvto.TipInt:SCREEN-VALUE = 'P'.
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
            CcbCMvto.usuario = S-USER-ID
            CcbCMvto.CodMon = DECIMAL(CcbCMvto.CodMon:SCREEN-VALUE)            
            CcbCMvto.Imptot = DECIMAL(CcbCMvto.Imptot:SCREEN-VALUE).
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
  F-Amortiza:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

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
   IF s-user-id <> 'ADMIN' THEN DO:
       DEF VAR dFchCie AS DATE.
       RUN gn/fecha-de-cierre (OUTPUT dFchCie).
       IF ccbcmvto.fchdoc <= dFchCie THEN DO:
           MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
               VIEW-AS ALERT-BOX WARNING.
           RETURN 'ADM-ERROR'.
       END.
   END.
   /* fin de consistencia */

   DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
       RUN Borra-Letras.
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
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
          gn-clie.codcli = CcbCMvto.codcli NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie  THEN DO:
        DISPLAY gn-clie.nomcli @ FILL-IN_Cliente.
     END.
     FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
          CcbCDocu.coddoc = 'LET' AND
          CcbCDocu.nrodoc = CcbCMvto.NroRef NO-LOCK NO-ERROR.
     IF AVAILABLE CcbCDocu  THEN DO:
        DISPLAY 
          CcbCDocu.FchDoc @ F-Emision 
          CcbCDocu.ImpTot @ F-Saldo 
          CcbCDocu.FchVto @ F-Vencimiento.
        CcbCMvto.CodMon:SCREEN-VALUE = STRING(CcbCDocu.CodMon, '99').
        IF CcbCMvto.FlgEst = 'E' THEN
           DISPLAY
              CcbCDocu.ImpTot - CcbCMvto.Imptot @ F-Amortiza.
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

  IF CCBCMVTO.FLGEST <> "A" THEN RUN CCB\R-RENLET.R(ROWID(CCBCMVTO)).
    
/*   GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY. */
/*     ASSIGN                                                            */
/*         RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "ccb/rbccb.prl"       */
/*         RB-REPORT-NAME = "Renovacion de Letras"                       */
/*         RB-FILTER = "CCbCdocu.CodCia = " + string(S-CODCIA) +         */
/*             " and CcbCdocu.CodDoc = " + 'LET' +                       */
/*             " and CcbCdocu.CodDiv = " + S-CODDIV +                    */
/*             " and CcbCDocu.FlgSit = " + S-FLGSIT +                    */
/*             " and CcbCDocu.FlgUbi = " + S-FLGUBI                      */
/*         RB-OTHER-PARAMETERS = "Gs-NomCia = " + s-nomcia.              */
/*                                                                       */
/*     RUN lib/_Imprime2(                                                */
/*         RB-REPORT-LIBRARY,                                            */
/*         RB-REPORT-NAME,                                               */
/*         RB-INCLUDE-RECORDS,                                           */
/*         RB-FILTER,                                                    */
/*         RB-OTHER-PARAMETERS).                                         */

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
  RUN Actualiza-Saldo.  /* La letra origen */
  RUN Nuevas-Letras.
  
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse1'). 
  F-Amortiza:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Nuevas-Letras V-table-Win 
PROCEDURE Nuevas-Letras :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH MVTO:
    CREATE CcbCDocu.
    ASSIGN
       CcbCDocu.CodCia = CcbCMvto.CodCia 
       CcbCDocu.CodCli = CcbCMvto.CodCli
       CcbCDocu.CodDoc = MVTO.CodRef
       CcbCDocu.NroDoc = MVTO.NroRef 
       CcbCDocu.NroSal = MVTO.NroDep
       CcbCMvto.CodDiv = S-CODDIV       
       CcbCDocu.CodMon = CcbCMvto.CodMon 
       CcbCDocu.FchDoc = MVTO.FchEmi
       CcbCDocu.FchVto = MVTO.FchVto
       CcbCDocu.FlgEst = 'P'
       CcbCDocu.FlgUbi = 'C'
       CcbCDocu.Glosa  = CcbCMvto.Glosa
       CcbCDocu.ImpTot = MVTO.ImpTot 
       CcbCDocu.CodRef = CcbCMVTO.CodDoc
       CcbCDocu.NroRef = CcbCMVTO.NroDoc
       CcbCDocu.SdoAct = MVTO.ImpTot 
       CcbCDocu.TpoCmb = CcbCMvto.TpoCmb
       CcbCDocu.FlgUbi = s-flgubi
       CcbCDocu.FlgSit = s-flgsit
       CcbCDocu.codcta = s-codcta
       CcbCDocu.usuario= S-USER-ID.
END.
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
        WHEN "NroRef" THEN 
            ASSIGN 
            input-var-1 = ""
            input-var-2 = integral.CcbCMvto.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME}
            input-var-3 = "P".
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
DEFINE VAR s-implet AS DECIMAL NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    IF Ccbcmvto.nroref:SCREEN-VALUE = "" THEN DO:
        MESSAGE 'Debe ingresar la letra' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY' TO Ccbcmvto.nroref.
        RETURN 'ADM-ERROR'.
    END.
    FIND CcbCDocu WHERE CcbCDocu.codcia = s-codcia 
        AND CcbCDocu.coddoc = 'LET' 
        AND CcbCDocu.nrodoc = Ccbcmvto.NroRef:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE CcbCDocu THEN DO:
        MESSAGE 'Letra no se encuentra registrada' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY' TO Ccbcmvto.nroref.
        RETURN 'ADM-ERROR'.
    END.
    IF CcbCDocu.CodCli <> CcbCMvto.CodCli:SCREEN-VALUE THEN DO:
        APPLY 'ENTRY' TO Ccbcmvto.codcli.
        RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        s-implet = 0.
    FOR EACH MVTO:
        s-implet = s-implet + MVTO.ImpTot.
        IF CAN-FIND(Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
                    AND Ccbcdocu.coddoc = 'LET'
                    AND Ccbcdocu.nrodoc = MVTO.nroref
                    NO-LOCK)
            THEN DO:
            MESSAGE 'La nueva letra renovada' MVTO.nroref 'YA existe'
                VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
    END.
    IF s-imptot <> s-implet THEN DO:
        MESSAGE 'Verificar el importe total de letras' VIEW-AS ALERT-BOX ERROR.
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
RETURN 'ADM-ERROR'.   /* No debe permitir realizar modificaciones  */
/*RETURN "OK".*/

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

/*FIND CcbCDocu WHERE CcbCDocu.codcia = CcbCMvto.codcia AND
 *      CcbCDocu.CodDoc = 'LET' AND
 *      CcbCDocu.NroDoc = CcbCMvto.Nroref NO-ERROR.
 * IF AVAILABLE CcbCDocu THEN DO:
 *    IF CcbCDocu.FlgEst = 'C' THEN DO:
 *       MESSAGE 'Las letra origen registras amortizaciones' VIEW-AS ALERT-BOX ERROR.
 *       RETURN 'ADM-ERROR'.
 *    END.
 *    IF CcbCDocu.FlgUbi = 'C' AND CcbCDocu.FlgSit = 'P' THEN DO:
 *       MESSAGE 'Las letra origen se encuentra protestada' VIEW-AS ALERT-BOX ERROR.
 *       RETURN 'ADM-ERROR'.
 *    END.
 * END.*/

FOR EACH CcbDMvto WHERE CcbDMvto.CodCia = CcbCMvto.CodCia AND
    CcbDMvto.CodDoc = CcbCMvto.CodDoc AND
    CcbDMvto.NroDoc = CcbCMvto.NroDoc:
    FIND CcbCDocu WHERE CcbCDocu.codcia = CcbDMvto.codcia AND
         CcbCDocu.CodDoc = CcbDMvto.codref AND
         CcbCDocu.NroDoc = CcbDMvto.Nroref NO-ERROR.
    IF AVAILABLE CcbCDocu THEN 
       IF CcbCDocu.FlgEst <> 'P' OR /*CcbCDocu.FlgUbi = 'C' OR*/
          CcbCDocu.SdoAct <> CcbCDocu.ImpTot THEN DO:
          s-resp = 'No'.
          LEAVE.
       END. 
END.
IF s-resp = 'No' THEN DO:
   MESSAGE 'Las letras registran amortizaciones' VIEW-AS ALERT-BOX ERROR.
   RETURN 'ADM-ERROR'.
END.

RETURN 'OK'.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

