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

/* Local Variable Definitions ---                                       */

DEF SHARED VAR lh_handle AS HANDLE.
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-coddiv  AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddoc  AS CHAR.
DEF SHARED VAR s-ptovta  AS INTE.
DEF SHARED VAR s-tipo    AS CHAR.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR s-codcli  LIKE gn-clie.codcli.
DEF SHARED VAR s-tpocmb  AS DEC.

DEF VAR s-ok AS LOGICAL INITIAL NO NO-UNDO.
DEF VAR X-ImpNac AS DECIMAL INITIAL 0 NO-UNDO.
DEF VAR X-ImpUsa AS DECIMAL INITIAL 0 NO-UNDO.
DEF VAR X-Importe AS DECIMAL INITIAL 0 NO-UNDO.
DEF VAR x-mon AS INTEGER INIT 0 NO-UNDO.
DEF VAR X-NUMDOC AS CHAR INIT "".


DEF SHARED TEMP-TABLE T-CcbDCaja LIKE CcbDCaja.
DEF SHARED TEMP-TABLE T-CcbCCaja LIKE CcbCCaja.
DEF BUFFER b-ccbccaja FOR ccbccaja.
DEF BUFFER b-ccbdcaja FOR ccbdcaja.
DEF BUFFER b-CDocu    FOR ccbcdocu.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES CcbCCaja
&Scoped-define FIRST-EXTERNAL-TABLE CcbCCaja


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCCaja.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCCaja.CodCli CcbCCaja.TpoCmb ~
CcbCCaja.NomCli CcbCCaja.FchDoc CcbCCaja.Glosa 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}CodCli ~{&FP2}CodCli ~{&FP3}~
 ~{&FP1}TpoCmb ~{&FP2}TpoCmb ~{&FP3}~
 ~{&FP1}NomCli ~{&FP2}NomCli ~{&FP3}~
 ~{&FP1}FchDoc ~{&FP2}FchDoc ~{&FP3}~
 ~{&FP1}Glosa ~{&FP2}Glosa ~{&FP3}
&Scoped-define ENABLED-TABLES CcbCCaja
&Scoped-define FIRST-ENABLED-TABLE CcbCCaja
&Scoped-Define ENABLED-OBJECTS RECT-1 
&Scoped-Define DISPLAYED-FIELDS CcbCCaja.CodCli CcbCCaja.NroDoc ~
CcbCCaja.TpoCmb CcbCCaja.NomCli CcbCCaja.FchDoc CcbCCaja.Glosa ~
CcbCCaja.usuario 
&Scoped-Define DISPLAYED-OBJECTS X-Status FILL-IN_Ruc 

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
DEFINE VARIABLE FILL-IN_Ruc AS CHARACTER FORMAT "x(11)" 
     LABEL "Ruc" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69.

DEFINE VARIABLE X-Status AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 67.57 BY 3.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCCaja.CodCli AT ROW 1.96 COL 7 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     CcbCCaja.NroDoc AT ROW 1.19 COL 7 COLON-ALIGNED FORMAT "XXX-XXXXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .69
          FONT 6
     X-Status AT ROW 1.19 COL 54.14 COLON-ALIGNED
     CcbCCaja.TpoCmb AT ROW 1.92 COL 54.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     FILL-IN_Ruc AT ROW 1.96 COL 26.14 COLON-ALIGNED
     CcbCCaja.NomCli AT ROW 2.73 COL 7 COLON-ALIGNED
          LABEL "Nombre" FORMAT "X(50)"
          VIEW-AS FILL-IN 
          SIZE 40.86 BY .69
     CcbCCaja.FchDoc AT ROW 2.73 COL 54.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbCCaja.Glosa AT ROW 3.5 COL 7 COLON-ALIGNED
          LABEL "Concepto"
          VIEW-AS FILL-IN 
          SIZE 41 BY .69
     CcbCCaja.usuario AT ROW 3.5 COL 54.14 COLON-ALIGNED
          LABEL "User"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     RECT-1 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.CcbCCaja
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
         HEIGHT             = 5.04
         WIDTH              = 67.57.
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

/* SETTINGS FOR FILL-IN CcbCCaja.CodCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN FILL-IN_Ruc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.Glosa IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.NomCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCCaja.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCCaja.usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN X-Status IN FRAME F-Main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME CcbCCaja.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCCaja.CodCli V-table-Win
ON LEAVE OF CcbCCaja.CodCli IN FRAME F-Main /* Cliente */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-clie WHERE gn-clie.codcia = 0 AND
    gn-clie.codcli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie
  THEN DO:
    MESSAGE "Cliente no registrado" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  IF gn-clie.codcli <> "11111111" THEN DO:
     DISPLAY gn-clie.nomcli @ CcbcCaja.Nomcli
             gn-clie.ruc @ FILL-IN_Ruc 
             WITH FRAME {&FRAME-NAME}.
  END.           
  s-codcli = SELF:SCREEN-VALUE.
  CcbCcaja.Codcli:SENSITIVE = NO.
END.



/*  DISPLAY gn-clie.nomcli @ FILL-IN_NomCli gn-clie.ruc @ FILL-IN_Ruc 
        WITH FRAME {&FRAME-NAME}.
  s-codcli = SELF:SCREEN-VALUE.*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCCaja.TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCCaja.TpoCmb V-table-Win
ON LEAVE OF CcbCCaja.TpoCmb IN FRAME F-Main /* Tipo de cambio */
DO:
    /*
  ASSIGN
         CcbCcaja.TpoCmb = int(CcbCcaja.TpoCmb:SCREEN-VALUE).*/

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
FOR EACH T-CcbdCaja:
    DELETE T-ccbdCaja.
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
  {src/adm/template/row-list.i "CcbCCaja"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbCCaja"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anula-Cheque V-table-Win 
PROCEDURE Anula-Cheque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF ((CcbCCaja.Voucher[2] <> "" ) AND
     (CcbCCaja.ImpNac[2] + CcbCCaja.ImpUsa[2]) > 0 ) OR
     ((CcbCCaja.Voucher[3] <> "" ) AND
     (CcbCCaja.ImpNac[3] + CcbCCaja.ImpUsa[3]) > 0)
  THEN DO:

    IF CcbCCaja.Voucher[2] <> "" THEN X-NUMDOC = CcbCCaja.Voucher[2].
    IF CcbCCaja.Voucher[3] <> "" THEN X-NUMDOC = CcbCCaja.Voucher[3].       
   
    FIND CcbCDocu WHERE 
         CcbCDocu.CodCia = S-CodCia AND
         CcbCDocu.CodDoc = "CHC" AND
         CcbCDocu.NroDoc = X-NUMDOC 
         EXCLUSIVE-LOCK NO-ERROR. 
    IF AVAILABLE CcbCDocu  THEN DO:
       DELETE CcbCDocu.
    END.
  END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-temporal V-table-Win 
PROCEDURE Borra-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH T-CcbDCaja:
      DELETE T-CcbDCaja.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cancelar-Asignacion V-table-Win 
PROCEDURE Cancelar-Asignacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR X-import AS DECIMAL NO-UNDO.
  DEFINE VAR X-impsal AS DECIMAL NO-UNDO.
  x-import = 0.
  x-impsal = 0.
  
  FIND B-CDocu WHERE B-CDocu.CodCia = s-codcia AND
       B-CDocu.CodDoc = 'N/C' AND B-CDocu.NroDoc = T-CcbCCaja.Voucher[6] NO-LOCK NO-ERROR.
  IF NOT AVAILABLE B-CDocu THEN DO:
     MESSAGE 'Nota de Credito no se encuentra registrada' VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.

  IF B-CDocu.codmon = 1 THEN
     X-import = T-CcbCCaja.ImpNac[6].
  ELSE
     X-import = T-CcbCCaja.ImpUsa[6].
  
  FOR EACH b-ccbdcaja OF ccbccaja NO-LOCK:
    IF X-import <= 0 THEN NEXT.
    FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
        ccbcdocu.coddoc = b-ccbdcaja.codref AND
        ccbcdocu.nrodoc = b-ccbdcaja.nroref EXCLUSIVE-LOCK.
    IF ccbcdocu.sdoact > 0 THEN DO:
       IF Ccbcdocu.codmon = B-CDocu.codmon THEN DO:
          IF ccbcdocu.sdoact > X-import THEN
             ASSIGN 
                x-impsal = x-import.
          ELSE
             ASSIGN
                x-impsal = ccbcdocu.sdoact
                x-import = x-import - ccbcdocu.sdoact.
          END.
       ELSE DO:
          IF CcbCdocu.Codmon = 1 THEN DO:
             IF ccbcdocu.sdoact > (X-import * CcbCCaja.tpocmb) THEN
                ASSIGN 
                   x-impsal = X-import.   /* En la moneda de la Nota de Credito  */
             ELSE
                ASSIGN 
                   x-impsal = ROUND(ccbcdocu.sdoact / CcbCCaja.tpocmb,2)
                   x-import = x-import - ROUND(ccbcdocu.sdoact / CcbCCaja.tpocmb,2).
             END.
          ELSE DO:
             IF ccbcdocu.sdoact > ROUND((X-import / CcbCCaja.tpocmb), 2) THEN
                ASSIGN 
                   x-impsal = X-import.   /* En la moneda de la Nota de Credito  */
             ELSE
                ASSIGN 
                   x-impsal = ROUND(ccbcdocu.sdoact * CcbCCaja.tpocmb,2)
                   x-import = x-import - ROUND(ccbcdocu.sdoact * CcbCCaja.tpocmb,2).
          END.
       END.
       CREATE CcbDCaja.
       ASSIGN 
           CcbDCaja.CodCia = s-CodCia
           CcbDCaja.CodDoc = 'N/C'
           CcbDCaja.NroDoc = T-CcbCCaja.Voucher[6]
           CcbDCaja.CodMon = B-CDocu.CodMon
           CcbDCaja.TpoCmb = CcbCDocu.tpocmb
           CcbDCaja.CodCli = CcbCDocu.CodCli
           CcbDCaja.CodRef = B-CDocu.CodDoc
           CcbDCaja.NroRef = B-CDocu.NroDoc
           CcbDCaja.FchDoc = CcbCDocu.FchDoc.
           CcbDCaja.ImpTot = x-impsal.
      
        RUN Cancelar-Nota-Credito ( s-CodCia, CcbDCaja.CodRef, CcbDCaja.NroRef, CcbDCaja.CodMon,
                                    CcbDCaja.TpoCmb, CcbDCaja.ImpTot, FALSE ).
        RUN Cancelar-Nota-Credito ( s-CodCia, CcbDCaja.CodDoc, CcbDCaja.NroDoc, CcbDCaja.CodMon,
                                    CcbDCaja.TpoCmb, CcbDCaja.ImpTot, FALSE ).    
    END.
    RELEASE ccbcdocu.
  END.
        
  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cancelar-Nota-Credito V-table-Win 
PROCEDURE Cancelar-Nota-Credito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: wrc 
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER iCodCia AS INTEGER.
DEFINE INPUT PARAMETER cCodDoc AS CHAR.
DEFINE INPUT PARAMETER cNroDoc AS CHAR.
DEFINE INPUT PARAMETER iCodMon AS INTEGER.
DEFINE INPUT PARAMETER fTpoCmb AS DECIMAL.
DEFINE INPUT PARAMETER fImpTot AS DECIMAL.
DEFINE INPUT PARAMETER LSumRes AS LOGICAL.

DEFINE VAR XfImport AS DECIMAL INITIAL 0.

FIND FIRST B-CDocu WHERE B-CDocu.CodCia = iCodCia AND B-CDocu.CodDoc = cCodDoc AND 
                         B-CDocu.NroDoc = cNroDoc EXCLUSIVE-LOCK NO-ERROR.
IF AVAILABLE B-CDocu THEN DO :
   XfImport = fImpTot.
   IF B-CDocu.CodMon <> iCodMon THEN DO:
      IF B-CDocu.CodMon = 1 THEN 
         ASSIGN XfImport = ROUND( fImpTot * fTpoCmb , 2 ).
      ELSE ASSIGN XfImport = ROUND( fImpTot / fTpoCmb , 2 ).
   END.
   
   IF LSumRes THEN ASSIGN B-CDocu.SdoAct = B-CDocu.SdoAct + XfImport.
   ELSE ASSIGN B-CDocu.SdoAct = B-CDocu.SdoAct - XfImport.
   
   IF B-CDocu.SdoAct = 0    /* OJO */
   THEN ASSIGN 
            B-CDocu.FlgEst = "C"
            B-CDocu.FchCan = TODAY.
   ELSE ASSIGN 
            B-CDocu.FlgEst = "P"
            B-CDocu.FchCan = ?.
   RELEASE B-CDocu.
END.                          
ELSE MESSAGE "Nota de Credito no registrada " VIEW-AS ALERT-BOX.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Cheque V-table-Win 
PROCEDURE Genera-Cheque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
 FIND Gn-Clie WHERE Gn-Clie.Codcia = 0 AND
                    Gn-Clie.CodCli = T-CcbCCaja.Voucher[10] NO-LOCK NO-ERROR.                               
 CREATE CcbCDocu.
 ASSIGN
     CcbCDocu.CodCia = S-CodCia
     CcbCDocu.CodDiv = S-CodDiv
     CcbCDocu.CodDoc = "CHC"
     CcbCDocu.CodCli = T-CcbCCaja.Voucher[10]        
     CcbCDocu.NomCli = Gn-Clie.Nomcli
     CcbCDocu.RucCli = Gn-Clie.Ruc
     CcbCDocu.FlgEst = "P"
     CcbCDocu.Usuario = s-User-Id
     CcbCDocu.TpoCmb = T-CcbCCaja.TpoCmb 
     CcbCDocu.FchDoc = TODAY .

 IF T-CcbCCaja.ImpNac[2] + T-CcbCCaja.ImpUsa[2] > 0 THEN 
   ASSIGN
     CcbCDocu.NroDoc = T-CcbCCaja.Voucher[2]          
     CcbCDocu.CodMon = IF T-ccbCCaja.ImpNac[2] <> 0 THEN 1 ELSE 2         
     CcbCDocu.ImpTot = IF T-ccbCCaja.ImpNac[2] <> 0 THEN T-ccbCCaja.ImpNac[2] ELSE T-ccbCCaja.ImpUsa[2]
     CcbCDocu.SdoAct = IF T-ccbCCaja.ImpNac[2] <> 0 THEN T-ccbCCaja.ImpNac[2] ELSE T-ccbCCaja.ImpUsa[2]
     CcbCDocu.ImpBrt = IF T-ccbCCaja.ImpNac[2] <> 0 THEN T-ccbCCaja.ImpNac[2] ELSE T-ccbCCaja.ImpUsa[2]
     CcbCDocu.FchVto = T-CcbCCaja.FchVto[2] .
 ELSE
   ASSIGN
     CcbCDocu.NroDoc = T-CcbCCaja.Voucher[3]          
     CcbCDocu.CodMon = IF T-ccbCCaja.ImpNac[3] <> 0 THEN 1 ELSE 2         
     CcbCDocu.ImpTot = IF T-ccbCCaja.ImpNac[3] <> 0 THEN T-ccbCCaja.ImpNac[3] ELSE T-ccbCCaja.ImpUsa[3]
     CcbCDocu.SdoAct = IF T-ccbCCaja.ImpNac[3] <> 0 THEN T-ccbCCaja.ImpNac[3] ELSE T-ccbCCaja.ImpUsa[3]
     CcbCDocu.ImpBrt = IF T-ccbCCaja.ImpNac[3] <> 0 THEN T-ccbCCaja.ImpNac[3] ELSE T-ccbCCaja.ImpUsa[3]
     CcbCDocu.FchVto = T-CcbCCaja.FchVto[3] .     

 IF T-CcbCCaja.Voucher[2] <> "" THEN X-NUMDOC = T-CcbCCaja.Voucher[2].
 IF T-CcbCCaja.Voucher[3] <> "" THEN X-NUMDOC = T-CcbCCaja.Voucher[3].       

 FIND CcbCDocu WHERE 
      CcbCDocu.CodCia = S-CodCia AND
      CcbCDocu.CodDoc = "CHC" AND
      CcbCDocu.NroDoc = X-NUMDOC EXCLUSIVE-LOCK NO-ERROR. 
 IF AVAILABLE CcbCDocu THEN
  ASSIGN 
     CcbCDocu.CodRef = CcbCCaja.CodDoc 
     CcbCDocu.NroRef = CcbCCaja.NroDoc.               

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Ingreso-a-caja V-table-Win 
PROCEDURE Ingreso-a-caja :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND FIRST t-ccbccaja.
  ASSIGN
    CcbCCaja.CodBco[2] = t-CcbCCaja.CodBco[2] 
    CcbCCaja.CodBco[3] = t-CcbCCaja.CodBco[3] 
    CcbCCaja.CodBco[4] = t-CcbCCaja.CodBco[4]
    CcbCCaja.CodBco[5] = t-CcbCCaja.CodBco[5]
    CcbCCaja.Codcta[5] = t-CcbCCaja.CodBco[5] 
    CcbCCaja.FchVto[2] = t-CcbCCaja.FchVto[2] 
    CcbCCaja.FchVto[3] = t-CcbCCaja.FchVto[3] 
    CcbCCaja.ImpNac[1] = t-CcbCCaja.ImpNac[1] 
    CcbCCaja.ImpNac[2] = t-CcbCCaja.ImpNac[2] 
    CcbCCaja.ImpNac[3] = t-CcbCCaja.ImpNac[3] 
    CcbCCaja.ImpNac[4] = t-CcbCCaja.ImpNac[4] 
    CcbCCaja.ImpNac[5] = t-CcbCCaja.ImpNac[5] 
    CcbCCaja.ImpNac[6] = t-CcbCCaja.ImpNac[6] 
    CcbCCaja.ImpNac[7] = t-CcbCCaja.ImpNac[7] 
    CcbCCaja.ImpUsa[1] = t-CcbCCaja.ImpUsa[1] 
    CcbCCaja.ImpUsa[2] = t-CcbCCaja.ImpUsa[2] 
    CcbCCaja.ImpUsa[3] = t-CcbCCaja.ImpUsa[3] 
    CcbCCaja.ImpUsa[4] = t-CcbCCaja.ImpUsa[4] 
    CcbCCaja.ImpUsa[5] = t-CcbCCaja.ImpUsa[5] 
    CcbCCaja.ImpUsa[6] = t-CcbCCaja.ImpUsa[6] 
    CcbCCaja.ImpUsa[7] = t-CcbCCaja.ImpUsa[7] 
    CcbCCaja.Voucher[2]= t-CcbCCaja.Voucher[2] 
    CcbCCaja.Voucher[3]= t-CcbCCaja.Voucher[3] 
    CcbCCaja.Voucher[4]= t-CcbCCaja.Voucher[4] 
    CcbCCaja.Voucher[5]= t-CcbCCaja.Voucher[5] 
    CcbCCaja.Voucher[6]= t-CcbCCaja.Voucher[6] 
    CcbCCaja.Voucher[7]= t-CcbCCaja.Voucher[7] 
    CcbCCaja.VueNac    = t-CcbCCaja.VueNac    
    CcbCCaja.VueUsa    = t-CcbCCaja.VueUsa
    CcbCCaja.TpoCmb    = t-CcbCCaja.TpoCmb
    CcbcCaja.Flgest    = "C".
    
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
  RUN Borra-temporal.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Cambia-Pantalla IN lh_handle (INPUT 2).

  FIND faccorre WHERE faccorre.codcia = s-codcia AND faccorre.coddoc = s-coddoc AND
       NroSer = s-ptovta NO-LOCK.
  do with frame {&FRAME-NAME}:
     DISPLAY STRING(faccorre.nroser, "999") + STRING(FacCorre.Correlativo, "999999")
          @ ccbccaja.nrodoc WITH FRAME {&FRAME-NAME}.
     /* Tipo de Cambio */
  
      DISPLAY s-tpocmb @ ccbccaja.tpocmb TODAY @ ccbccaja.fchdoc WITH FRAME {&FRAME-NAME}.
  
     ccbccaja.tpocmb:sensitive = no.
     ccbccaja.fchDoc:sensitive = no.
     
  end.
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
  /* Detalle */
  FOR EACH t-ccbdcaja:
    CREATE ccbdcaja.
    ASSIGN
        CcbDCaja.CodCia = s-codcia
        CcbDCaja.CodDoc = ccbccaja.coddoc
        CcbDCaja.NroDoc = ccbccaja.nrodoc
        CcbDCaja.CodCli = ccbccaja.codcli
        CcbDCaja.CodMon = t-ccbdcaja.codmon
        CcbDCaja.CodRef = t-ccbdcaja.codref
        CcbDCaja.FchDoc = ccbccaja.fchdoc
        CcbDCaja.ImpTot = t-ccbdcaja.imptot
        CcbDCaja.NroRef = t-ccbdcaja.nroref.
        CcbDCaja.TpoCmb = ccbccaja.tpocmb.
  END.
  /* Cancela cuenta por cobrar */
  FOR EACH ccbdcaja OF ccbccaja NO-LOCK:
    FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
        ccbcdocu.coddoc = ccbdcaja.codref AND
        ccbcdocu.nrodoc = ccbdcaja.nroref EXCLUSIVE-LOCK.
    ASSIGN
        ccbcdocu.sdoact = ccbcdocu.sdoact - ccbdcaja.imptot.
    IF ccbcdocu.sdoact = 0      /* OJO */
    THEN ASSIGN
            ccbcdocu.fchcan = TODAY
            ccbcdocu.flgest = "C".
    RELEASE ccbcdocu.
  END.
  RUN Ingreso-a-Caja.
  
  /* Generar Asignacion de Nota de Credito */
  IF T-CcbCCaja.Voucher[6] <> ' ' AND
     (T-CcbCCaja.ImpNac[6] + T-CcbCCaja.ImpUsa[6]) > 0 THEN 
     RUN Cancelar-Asignacion.
  
       /*****************GENERACIO DE CHEQUE ********************/
  IF ((T-CcbCCaja.Voucher[2] <> "" ) AND
     (T-CcbCCaja.ImpNac[2] + T-CcbCCaja.ImpUsa[2]) > 0 ) OR
     ((T-CcbCCaja.Voucher[3] <> "" ) AND
     (T-CcbCCaja.ImpNac[3] + T-CcbCCaja.ImpUsa[3]) > 0) THEN 
     RUN Genera-Cheque.
      
        

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
  RUN Cambia-Pantalla IN lh_handle (INPUT 1).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND FacCorre WHERE FacCorre.CodCia = s-codcia AND
    FacCorre.CodDoc = s-coddoc AND FacCorre.NroSer = s-ptovta
    EXCLUSIVE-LOCK.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    CcbCCaja.CodCia = s-codcia
    CcbCCaja.CodDoc = s-coddoc
    CcbCCaja.NroDoc = STRING(faccorre.nroser, "999") + 
                      STRING(faccorre.correlativo, "999999")
    CcbcCaja.CodDiv = S-CODDIV
    CcbCCaja.Tipo   = s-tipo
    /*CcbCCaja.TpoCmb = s-TpoCmb*/
    CcbCCaja.usuario= s-user-id
    CcbCCaja.CodCaja= S-CODTER
    FacCorre.Correlativo = FacCorre.Correlativo + 1.
  RELEASE faccorre.

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

  IF ccbccaja.flgcie NE "P" THEN DO:
     MESSAGE "Ya se hizo el cierre de caja" VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.
  
  IF ((CcbCCaja.Voucher[2] <> "" ) AND
     (CcbCCaja.ImpNac[2] + CcbCCaja.ImpUsa[2]) > 0 ) OR
     ((CcbCCaja.Voucher[3] <> "" ) AND
     (CcbCCaja.ImpNac[3] + CcbCCaja.ImpUsa[3]) > 0)
  THEN DO:

    IF CcbCCaja.Voucher[2] <> "" THEN X-NUMDOC = CcbCCaja.Voucher[2].
    IF CcbCCaja.Voucher[3] <> "" THEN X-NUMDOC = CcbCCaja.Voucher[3].       
   
    FIND CcbCDocu WHERE 
         CcbCDocu.CodCia = S-CodCia AND
         CcbCDocu.CodDoc = "CHC" AND
         CcbCDocu.NroDoc = X-NUMDOC NO-LOCK NO-ERROR. 
    IF AVAILABLE CcbCDocu AND CcbCDocu.FlgEst = "C" THEN DO:
       MESSAGE "Ingreso con Cheque Aceptado, No es posible Anular la Operacion" 
       VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".       
    END.
  END.  
  
  {adm/i-DocPssw.i s-CodCia s-CodDoc ""DEL""}
  
  /* actualizamos la cuenta corriente */
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
     FOR EACH ccbdcaja OF ccbccaja:
         FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
              ccbcdocu.coddoc = ccbdcaja.codref AND
              ccbcdocu.nrodoc = ccbdcaja.nroref EXCLUSIVE-LOCK NO-ERROR.
         IF AVAILABLE ccbcdocu THEN DO:
            ASSIGN  ccbcdocu.sdoact = ccbcdocu.sdoact + ccbdcaja.imptot.
            IF CcbCCaja.Voucher[6] <> "" THEN DO:
               FIND b-ccbdcaja WHERE  
                    b-CcbDCaja.CodCia = CcbDCaja.CodCia     AND
                    b-CcbDCaja.CodDoc = 'N/C'               AND
                    b-CcbDCaja.NroDoc = CcbCCaja.Voucher[6] AND
                    b-CcbDCaja.CodRef = CcbDCaja.CodRef     AND
                    b-CcbDCaja.NroRef = CcbDCaja.NroRef NO-LOCK NO-ERROR.
               IF AVAILABLE b-CcbDCaja THEN 
                  ASSIGN CCbCDocu.SdoAct = CCbCDocu.SdoAct + b-CCbdCaja.ImpTot.
            END.
            IF ccbcdocu.sdoact <> 0     /* OJO */
            THEN ASSIGN 
                    ccbcdocu.flgest = "P"
                    ccbcdocu.fchcan = ?.
         END.
         RELEASE CCbcDocu.
         IF CcbCCaja.Voucher[6] <> "" THEN DO:
            RUN Restaura-Nota-de-Credito.
         END.
         DELETE ccbdcaja.
     END.
     RUN Restaura-Boleta-de-Deposito.
     RUN Anula-Cheque.     
     FIND b-ccbccaja WHERE ROWID(b-ccbccaja) = ROWID(ccbccaja) EXCLUSIVE-LOCK.
     ASSIGN  b-ccbccaja.flgest = "A".
     RELEASE b-ccbccaja.
  END.
  
  /* Code placed here will execute AFTER standard behavior.    */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Repintar-Detalle IN lh_handle.

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
  IF AVAILABLE ccbccaja 
  THEN DO WITH FRAME {&FRAME-NAME}:
    FIND gn-clie WHERE gn-clie.codcia = 0 AND
        gn-clie.codcli = ccbccaja.codcli NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie AND gn-clie.codcli <> "11111111" THEN 
       DISPLAY gn-clie.nomcli @ CcbcCaja.Nomcli gn-clie.ruc @ FILL-IN_Ruc.
    CASE ccbccaja.flgest:
    WHEN "A" THEN X-Status:SCREEN-VALUE = "ANULADO".
    OTHERWISE X-Status:SCREEN-VALUE = "EMITIDO".
    END CASE.
  END.
  
END PROCEDURE.

/*  THEN DISPLAY gn-clie.nomcli @ FILL-IN_NomCli gn-clie.ruc @ FILL-IN_Ruc.*/

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
  
 RUN CCB\r-recibo2 (ROWID(CcbcCaja)).

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
  ASSIGN
    X-ImpNac = 0
    X-ImpUsa = 0.
    X-Importe = 0.
        
  FOR EACH T-CcbDCaja:
      x-importe = x-importe + t-ccbdcaja.imptot.
  END.  
    RUN ccb/d-canc02 (X-Importe, x-mon, DECIMAL(CcbCCaja.TpoCmb:SCREEN-VALUE IN FRAME {&FRAME-NAME}), 
    s-codcli, OUTPUT s-ok).
    
  IF s-ok = NO THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
    
  /* Code placed here will execute AFTER standard behavior.    */
  RUN Cambia-Pantalla IN lh_handle (INPUT 1).
  RUN dispatch IN THIS-PROCEDURE ('imprime':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Documentos V-table-Win 
PROCEDURE Procesa-Documentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR I AS INTEGER.
  input-var-1 = "P".
  input-var-2 = S-CODCLI.
  
  RUN lkup\C-doctip-02 ("Documentos Pendientes") .

          
  IF output-var-1 = ? THEN RETURN ERROR.
  RUN Actualiza-Deta.
  DO WITH FRAME {&FRAME-NAME}:
     DO i = 1 TO NUM-ENTRIES(output-var-2):
        FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
             ccbcdocu.coddoc = SUBSTRING(ENTRY(I,output-var-2),1,3) AND
             ccbcdocu.nrodoc = SUBSTRING(ENTRY(I,output-var-2),4) 
             USE-INDEX LLAVE01 NO-LOCK NO-ERROR.

        CREATE T-CCBDCAJA.
        ASSIGN
           T-CcbDCaja.CodCia = S-CODCIA
           T-CcbDCaja.CodCli = Ccbcdocu.Codcli           
           T-CcbDCaja.NroRef = Ccbcdocu.NroDoc
           T-CcbDCaja.CodRef = Ccbcdocu.CodDoc
           T-CcbDCaja.CodMon = ccbcdocu.codmon
           T-CcbDcaja.coddoc = IF ccbcdocu.codmon = 1 THEN "S/." ELSE "US$" 
           T-CcbDcaja.imptot = ccbcdocu.sdoact.
           RELEASE T-CCBDCAJA.
/*           message t-ccbdcaja.NROREF.*/
        S-TIPO = 'CFAC'.
       
     END.  
  END.
    



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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Restaura-Boleta-de-Deposito V-table-Win 
PROCEDURE Restaura-Boleta-de-Deposito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF CcbCCaja.Voucher[5] <> "" AND (CcbCCaja.ImpNac[5] + CcbCCaja.ImpUsa[5]) > 0 THEN DO:
        FIND ccbboldep WHERE ccbboldep.CodCia = CcbCCaja.CodCia 
                       AND  ccbboldep.CodDoc = "BD" 
                       AND  ccbboldep.CodCli = CcbCCaja.CodCli 
                       AND  ccbboldep.nrodoc = CcbCCaja.Voucher[5] 
                      EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL ccbboldep THEN DO:
           IF CcbBolDep.CodMon = 1 THEN
               ASSIGN CcbBolDep.SdoAct = CcbBolDep.SdoAct + (CcbCCaja.ImpNac[5] + 
                                         (CcbCCaja.ImpUsa[5] * CcbCCaja.TpoCmb)).
           ELSE
               ASSIGN CcbBolDep.SdoAct = CcbBolDep.SdoAct + (CcbCCaja.ImpUsa[5] + 
                                         (CcbCCaja.ImpNac[5] / CcbCCaja.TpoCmb)).
           IF CcbBolDep.SdoAct > 0 THEN CcbBolDep.FlgEst = "P".
        END.
        RELEASE ccbboldep.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Restaura-Nota-de-Credito V-table-Win 
PROCEDURE Restaura-Nota-de-Credito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
         IF CcbCCaja.Voucher[6] <> "" THEN DO:
            FIND b-ccbdcaja WHERE  
                 b-CcbDCaja.CodCia = CcbDCaja.CodCia     AND
                 b-CcbDCaja.CodDoc = 'N/C'               AND
                 b-CcbDCaja.NroDoc = CcbCCaja.Voucher[6] AND
                 b-CcbDCaja.CodRef = CcbDCaja.CodRef     AND
                 b-CcbDCaja.NroRef = CcbDCaja.NroRef EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE b-CcbDCaja THEN DO:
               FIND ccbcdocu WHERE 
                    ccbcdocu.codcia = b-CcbDCaja.CodCia AND
                    ccbcdocu.coddoc = b-CcbDCaja.CodDoc AND
                    ccbcdocu.nrodoc = b-CcbDCaja.NroDoc EXCLUSIVE-LOCK NO-ERROR.
               IF AVAILABLE ccbcdocu THEN 
                  ASSIGN ccbcdocu.sdoact = ccbcdocu.sdoact + b-CcbDCaja.ImpTot
                         ccbcdocu.flgest = "P".
               RELEASE ccbcdocu.
               DELETE b-CcbDCaja.
            END.
            RELEASE b-CcbDCaja.
         END.

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
  {src/adm/template/snd-list.i "CcbCCaja"}

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
    FIND FIRST t-ccbdcaja NO-ERROR.
    IF NOT AVAILABLE t-ccbdcaja
    THEN DO:
        MESSAGE "No ha ingresado informacion" VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    IF CcbCCaja.CodCli:SCREEN-VALUE = "" THEN DO:
       MESSAGE "Codigo de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO CcbCCaja.CodCli.
       RETURN "ADM-ERROR".   
   END.

   x-mon = T-CcbDCaja.CodMon.
   FOR EACH T-CcbDCaja:
       IF x-mon <> T-CcbDCaja.CodMon THEN DO:
          MESSAGE "Documentos a cancelar con diferente moneda" VIEW-AS ALERT-BOX ERROR.
          RETURN "ADM-ERROR".         
       END.
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


