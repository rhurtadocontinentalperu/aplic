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
DEFINE SHARED VARIABLE S-NROSER  AS INTEGER.
DEFINE SHARED VARIABLE S-IMPFLE  AS DECIMAL.

DEFINE SHARED TEMP-TABLE DETA LIKE CcbDDocu.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE I              AS INTEGER   NO-UNDO.
DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE C-NRODOC       AS CHAR      NO-UNDO.
DEFINE VARIABLE C-CODPED       AS CHAR      NO-UNDO.
DEFINE VARIABLE C-NROPED       AS CHAR      NO-UNDO.
DEFINE VARIABLE C-NROGUI       AS CHAR      NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NRODOC       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-ListPr       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE S-CODCLI       AS CHARACTER NO-UNDO. 
DEFINE VARIABLE S-CODALM       AS CHAR      NO-UNDO.
DEFINE VARIABLE S-CODMOV       AS INTEGER   NO-UNDO. 
DEFINE VARIABLE I-CODMON       AS INTEGER   NO-UNDO. 
DEFINE VARIABLE R-ROWID        AS ROWID     NO-UNDO. 
DEFINE VARIABLE C-CODVEN       AS CHAR      NO-UNDO.
DEFINE VARIABLE D-FCHVTO       AS DATE      NO-UNDO.

DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER B-CCDOCU FOR CcbCDocu.

FIND FacDocum WHERE FacDocum.CodCia = S-CODCIA AND
     FacDocum.CodDoc = S-CODDOC NO-LOCK NO-ERROR.
IF AVAILABLE FacDocum THEN S-CODMOV = FacDocum.CodMov.

FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV AND
     FacCorre.NroSer = S-NROSER NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN S-CodAlm = FacCorre.CodAlm 
          I-NroSer = FacCorre.NroSer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE TEMP-TABLE T-CPEDM LIKE FacCPedi
   FIELD CodRef LIKE CcbCDocu.CodRef.
/*   FIELD t-NroRef LIKE CcbCDocu.NroRef.*/
DEFINE TEMP-TABLE T-DPEDM LIKE FacDPedi.

DEFINE VARIABLE RPTA        AS CHARACTER NO-UNDO.

define var s-cndvta as char.

DEFINE VAR F-TOTDIAS AS INTEGER.
DEFINE BUFFER B-CCB FOR CCBCDOCU.

DEFINE VARIABLE S-CODMON   AS INTEGER INIT 1.

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
&Scoped-Define ENABLED-FIELDS CcbCDocu.NroDoc CcbCDocu.NroPed ~
CcbCDocu.CodCli CcbCDocu.NomCli CcbCDocu.FchDoc CcbCDocu.DirCli ~
CcbCDocu.RucCli CcbCDocu.FchVto CcbCDocu.CodVen CcbCDocu.FmaPgo ~
CcbCDocu.NroOrd CcbCDocu.NroRef CcbCDocu.CodMon CcbCDocu.ImpTot ~
CcbCDocu.ImpDto 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define ENABLED-OBJECTS RECT-19 
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.NroPed ~
CcbCDocu.TpoCmb CcbCDocu.CodCli CcbCDocu.NomCli CcbCDocu.FchDoc ~
CcbCDocu.DirCli CcbCDocu.RucCli CcbCDocu.FchVto CcbCDocu.CodVen ~
CcbCDocu.FmaPgo CcbCDocu.NroOrd CcbCDocu.NroRef CcbCDocu.Glosa ~
CcbCDocu.CodMon CcbCDocu.ImpTot CcbCDocu.ImpVta CcbCDocu.ImpIgv ~
CcbCDocu.ImpDto CcbCDocu.ImpBrt 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS F-Estado F-nOMvEN F-CndVta C-TpoVta 

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
DEFINE VARIABLE C-TpoVta AS CHARACTER FORMAT "X(256)":U INITIAL "Contado" 
     LABEL "Tipo Venta" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Factura","Letras" 
     DROP-DOWN-LIST
     SIZE 12.29 BY 1 NO-UNDO.

DEFINE VARIABLE F-CndVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42.29 BY .69 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .69
     FONT 0 NO-UNDO.

DEFINE VARIABLE F-nOMvEN AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42.29 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.14 BY 6.96.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.NroDoc AT ROW 1.12 COL 8.14 COLON-ALIGNED FORMAT "XXXXXXXXX"
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .69
          FONT 1
     CcbCDocu.NroPed AT ROW 1.12 COL 47 COLON-ALIGNED FORMAT "XXXXXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     F-Estado AT ROW 1.12 COL 69.86 COLON-ALIGNED NO-LABEL
     CcbCDocu.TpoCmb AT ROW 1.85 COL 71.43 COLON-ALIGNED
          LABEL "T/ Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbCDocu.CodCli AT ROW 1.92 COL 8.14 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     CcbCDocu.NomCli AT ROW 1.92 COL 19.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 37.57 BY .69
     CcbCDocu.FchDoc AT ROW 2.58 COL 71.43 COLON-ALIGNED
          LABEL "F/ Emision"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbCDocu.DirCli AT ROW 2.65 COL 8.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 34 BY .69
     CcbCDocu.RucCli AT ROW 2.69 COL 45.86 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     CcbCDocu.FchVto AT ROW 3.27 COL 71.43 COLON-ALIGNED
          LABEL "Vencimient"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbCDocu.CodVen AT ROW 3.35 COL 8.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .69
     F-nOMvEN AT ROW 3.35 COL 14.43 COLON-ALIGNED NO-LABEL
     CcbCDocu.FmaPgo AT ROW 4 COL 8.14 COLON-ALIGNED
          LABEL "Cond.Vta"
          VIEW-AS FILL-IN 
          SIZE 6 BY .69
     F-CndVta AT ROW 4 COL 14.43 COLON-ALIGNED NO-LABEL
     CcbCDocu.NroOrd AT ROW 4 COL 71.43 COLON-ALIGNED
          LABEL "O/ Compra" FORMAT "x(12)"
          VIEW-AS FILL-IN 
          SIZE 12.29 BY .69
     C-TpoVta AT ROW 4.65 COL 71.43 COLON-ALIGNED
     CcbCDocu.NroRef AT ROW 4.69 COL 8.14 COLON-ALIGNED
          LABEL "Guias" FORMAT "X(45)"
          VIEW-AS FILL-IN 
          SIZE 48.72 BY .69
     CcbCDocu.Glosa AT ROW 5.42 COL 8.14 COLON-ALIGNED
          LABEL "Glosa"
          VIEW-AS FILL-IN 
          SIZE 48.86 BY .69
     CcbCDocu.CodMon AT ROW 5.58 COL 73.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 10.72 BY .62
     CcbCDocu.ImpTot AT ROW 6.27 COL 12.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .69
     CcbCDocu.ImpVta AT ROW 6.27 COL 37.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .69
     CcbCDocu.ImpIgv AT ROW 6.31 COL 70.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .69
     CcbCDocu.ImpDto AT ROW 7 COL 12.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .69
     CcbCDocu.ImpBrt AT ROW 7.08 COL 37.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .69
     "Moneda:" VIEW-AS TEXT
          SIZE 6.43 BY .5 AT ROW 5.58 COL 65.43
     RECT-19 AT ROW 1 COL 1
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
         HEIGHT             = 6.96
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

/* SETTINGS FOR COMBO-BOX C-TpoVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.CodCli IN FRAME F-Main
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
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.Glosa IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.ImpBrt IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.ImpIgv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.ImpVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.NroOrd IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NroPed IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.NroRef IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
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
   FIND gn-clie WHERE gn-clie.CodCia = cl-codcia
                 AND  gn-clie.CodCli = CcbCDocu.CodCli:SCREEN-VALUE
                NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-clie  THEN DO:
      MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.

   IF gn-clie.FlgSit = "I" THEN DO:
      MESSAGE "Cliente esta Inactivo" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO CcbCDocu.CodCli.
      RETURN NO-APPLY.
   END.

   DISPLAY gn-clie.NomCli @ CcbCDocu.NomCli
           gn-clie.Ruc    @ CcbCDocu.RucCli
           gn-clie.DirCli @ CcbCDocu.DirCli 
           gn-clie.CodVen @ CcbCDocu.CodVen
           gn-clie.CndVta @ CcbCDocu.FmaPgo WITH FRAME {&FRAME-NAME}.

   S-CODCLI = SELF:SCREEN-VALUE .       

   S-CNDVTA = gn-clie.CndVta.

   IF gn-clie.CodCli <> FacCfgGn.CliVar THEN DO:
         CcbCDocu.NomCli:SENSITIVE = NO.
         CcbCDocu.RucCli:SENSITIVE = NO.
         CcbCDocu.DirCli:SENSITIVE = NO.
         APPLY "ENTRY" TO CcbCDocu.CodVen.

   END.   
   ELSE DO: 
        CcbCDocu.NomCli:SENSITIVE = YES.
        CcbCDocu.RucCli:SENSITIVE = YES.
        CcbCDocu.DirCli:SENSITIVE = YES.

        APPLY "ENTRY" TO CcbCDocu.NomCli.   
   END. 
   
   /* Ubica la Condicion Venta */
   FIND gn-convt WHERE gn-convt.Codig = CcbCdocu.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAILABLE gn-convt THEN DO:
           F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
           f-totdias = gn-convt.totdias.
           
        END.  
        ELSE F-CndVta:SCREEN-VALUE = "".

   DISPLAY DATE(CCbCDocu.FchDoc:SCREEN-VALUE) + f-totdias @ CcbCDocu.FchVto WITH FRAME {&FRAME-NAME} .

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodMon V-table-Win
ON VALUE-CHANGED OF CcbCDocu.CodMon IN FRAME F-Main /* Moneda */
DO:
  S-CODMON = INTEGER(CCbCDocu.CodMon:SCREEN-VALUE).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.FchDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.FchDoc V-table-Win
ON LEAVE OF CcbCDocu.FchDoc IN FRAME F-Main /* F/ Emision */
DO:

   DISPLAY DATE(CCbCDocu.FchDoc:SCREEN-VALUE) + f-totdias @ CcbCDocu.FchVto WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.FmaPgo V-table-Win
ON LEAVE OF CcbCDocu.FmaPgo IN FRAME F-Main /* Cond.Vta */
DO:
   FIND gn-convt WHERE gn-convt.Codig = CcbCdocu.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAILABLE gn-convt THEN DO:
           F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
           f-totdias = gn-convt.totdias.
           
        END.  
        ELSE F-CndVta:SCREEN-VALUE = "".

   DISPLAY DATE(CCbCDocu.FchDoc:SCREEN-VALUE) + f-totdias @ CcbCDocu.FchVto WITH FRAME {&FRAME-NAME}.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.NroDoc V-table-Win
ON LEAVE OF CcbCDocu.NroDoc IN FRAME F-Main /* Numero */
DO:
  FIND B-CCB WHERE B-CCB.Codcia = S-CODCIA AND
                   B-CCB.CodDoc = S-CODDOC AND
                   B-CCB.NroDoc = SELF:SCREEN-VALUE NO-ERROR. 
  IF AVAILABLE B-CCB THEN DO:
     MESSAGE "Numero Documento Ya se Encuentra Registrado" 
     VIEW-AS ALERT-BOX.
     RETURN NO-APPLY.
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
  Notes:       POR AHORA NO SE PUEDE MODIFICAR, SOLO CREAR
------------------------------------------------------------------------------*/
FOR EACH DETA:
    DELETE DETA.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Guias V-table-Win 
PROCEDURE Actualiza-Guias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF C-NROGUI <> "" THEN DO ON ERROR UNDO, RETURN "ADM-ERROR":
     DO I = 1 TO NUM-ENTRIES(C-NROGUI):
        C-NRODOC = ENTRY(I,C-NROGUI).
        FIND B-CDOCU WHERE B-CDOCU.CodCia = S-CODCIA
                      AND  B-CDOCU.CodDoc = "G/R" 
                      AND  B-CDOCU.NroDoc = C-NroDoc 
                     EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE B-CDOCU THEN DO :
           ASSIGN B-CDOCU.FlgEst = "F"
                  B-CDOCU.CodRef = CcbCDocu.CodDoc
                  B-CDOCU.NroRef = CcbCDocu.NroDoc
                  B-CDOCU.FchCan = CcbCDocu.FchDoc
                  B-CDOCU.SdoAct = 0.
        END.
        RELEASE B-CDOCU.
     END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Pedidos V-table-Win 
PROCEDURE Actualiza-Pedidos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO ON ERROR UNDO, RETURN "ADM-ERROR":
  /* FIND FacCPedi WHERE
 *         FacCPedi.CodCia = CcbCDocu.CodCia AND
 *         FacCPedi.CodDoc = CcbCDocu.CodPed AND
 *         FacCPedi.NroPed = CcbCDocu.NroPed EXCLUSIVE-LOCK NO-ERROR.
 *    IF AVAILABLE FacCPedi THEN ASSIGN FacCPedi.FlgEst = "F".
 *    RELEASE FacCPedi.*/
   
   FIND FacCPedi WHERE
        FacCPedi.CodCia = CcbCDocu.CodCia AND
        FacCPedi.CodDoc = CcbCDocu.CodPed AND
        FacCPedi.NroPed = CcbCDocu.NroPed EXCLUSIVE-LOCK NO-ERROR.
   IF AVAILABLE FacCPedi THEN DO:
       FOR EACH FacDPedi OF FacCPedi :
        IF FacDPedi.CanPed - FacDPedi.CanAte > 0 THEN RETURN .
       END.
       ASSIGN FacCPedi.FlgEst = "F".
       RELEASE FacCPedi.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Guias V-table-Win 
PROCEDURE Asigna-Guias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DO WITH FRAME {&FRAME-NAME}:
    /*
    IF CcbCDocu.CodCli:SCREEN-VALUE = "" THEN DO:
       MESSAGE "Debe registrar al cliente" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    */
    IF NOT CcbCDocu.CodCli:SENSITIVE THEN DO:
       MESSAGE "Solo puede asignar una vez" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    RUN Actualiza-Deta.
    input-var-1 = CcbCDocu.CodCli:SCREEN-VALUE.
    C-NROGUI = "".
    output-var-2 = "".
    RUN lkup\C-Guias.r("Guias Pendientes x Facturar").
    IF output-var-2 <> ? THEN DO:
       C-NROGUI = output-var-2.
       D-FCHVTO = ?.
/*       MESSAGE output-var-2.*/
       DO I = 1 TO NUM-ENTRIES(output-var-2):
          C-NRODOC = ENTRY(I,output-var-2).

          FIND B-CDOCU WHERE B-CDOCU.CodCia = S-CODCIA
                        AND  B-CDOCU.CodDoc = "G/R" 
                        AND  B-CDOCU.NroDoc = C-NroDoc 
                       NO-LOCK NO-ERROR.
          /***************Agregado 09/22/2000 MAG *******************/
          FIND FACCPEDI WHERE FACCPEDI.CODCIA = S-CODCIA 
                         AND  FACCPEDI.CODDOC = B-CDOCU.CodPed
                         AND  FACCPEDI.NROPED = B-CDOCU.NroPed
                         NO-LOCK NO-ERROR.
          
          C-NROPED = FACCPEDI.NROREF.
          /************************************************************/
          /*C-NROPED = B-CDOCU.NroPed.*/ /*B-CDOCU.NroOrd.*/  
          I-CODMON = B-CDOCU.CodMon.
          C-CODVEN = B-CDOCU.CodVen.
          
          CcbCDocu.CodCli:SCREEN-VALUE = B-CDOCU.codcli.
          CcbCDocu.nomCli:SCREEN-VALUE = B-CDOCU.nomcli.
          CcbCDocu.dirCli:SCREEN-VALUE = B-CDOCU.dircli.
          CcbCDocu.ruc:SCREEN-VALUE = B-CDOCU.ruc.
          CcbCDocu.glosa:SCREEN-VALUE = B-CDOCU.glosa.
          /*CcbCDocu.nroped:SCREEN-VALUE = B-CDOCU.nroped.*/
          CcbCDocu.nroped:SCREEN-VALUE = C-NROPED.
          CcbCDocu.nroref:SCREEN-VALUE = B-CDOCU.nroref.

          
/*          message "EL NUMERO g/r ES: " CcbCDocu.nroref:SCREEN-VALUE view-as alert-box.*/

          IF D-FCHVTO = ? THEN D-FCHVTO = B-CDOCU.FchVto.
          D-FCHVTO = MAXIMUM( D-FCHVTO , B-CDOCU.FchVto ).
          
          
          /* asigna los articulos a la factura */
          FOR EACH CcbDDocu NO-LOCK OF B-CDOCU /*WHERE CcbDDocu.CodCia = B-CDOCU.CodCia AND  CcbDDocu.NroDoc = B-CDOCU.NroDoc*/ :
              FIND DETA WHERE DETA.CodCia = CcbDDocu.CodCia 
                         AND  DETA.codmat = CcbDDocu.codmat NO-ERROR.
              IF NOT AVAILABLE DETA THEN
              CREATE DETA.
              ASSIGN DETA.CodCia = CcbDDocu.CodCia
                     DETA.codmat = CcbDDocu.codmat 
                     DETA.PreUni = CcbDDocu.PreUni 
                     DETA.Factor = CcbDDocu.Factor 
                     DETA.PorDto = CcbDDocu.PorDto 
                     DETA.PreBas = CcbDDocu.PreBas 
                     DETA.AftIgv = CcbDDocu.AftIgv
                     DETA.AftIsc = CcbDDocu.AftIsc
                     DETA.UndVta = CcbDDocu.UndVta.
                     DETA.CanDes = DETA.CanDes + CcbDDocu.CanDes.
                     
              FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                             AND  Almmmatg.codmat = DETA.codmat 
                            NO-LOCK NO-ERROR.
              IF AVAILABLE Almmmatg THEN DO:
                 ASSIGN DETA.ImpDto = ROUND( DETA.PreUni * (DETA.PorDto / 100) * DETA.CanDes , 2 )
                        DETA.ImpLin = ROUND( DETA.PreUni * DETA.CanDes , 2 ) /*- DETA.ImpDto*/.
                 IF DETA.AftIsc THEN 
                    DETA.ImpIsc = ROUND(DETA.PreBas * DETA.CanDes * (Almmmatg.PorIsc / 100),4).
                 IF DETA.AftIgv THEN 
                    DETA.ImpIgv = DETA.ImpLin - ROUND(DETA.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
 
                 /***********Grabando Costos **********************/
                 DETA.ImpCto = ROUND( Almmmatg.Ctotot * DETA.CanDes , 2 ) . 
                 IF I-CODMON <> Almmmatg.Monvta THEN DO:
                    DETA.ImpCto = IF I-CODMON = 1 THEN ROUND( Almmmatg.Ctotot * DETA.CanDes * Almmmatg.Tpocmb , 2 )
                                                  ELSE ROUND(( Almmmatg.Ctotot * DETA.CanDes ) /  Almmmatg.Tpocmb , 2 ).
                 END.
                 /*************************************************/
 
              END.
          END. 
       END.
       F-NomVen = "".
       F-CndVta = "".
       DISPLAY B-CDOCU.NroOrd @ CcbCDocu.NroOrd
               B-CDOCU.FmaPgo @ CcbCDocu.FmaPgo.
       C-TpoVta:SCREEN-VALUE = ENTRY(INTEGER(B-CDOCU.TipVta),C-TpoVta:LIST-ITEMS).
       FIND gn-convt WHERE gn-convt.Codig = B-CDOCU.FmaPgo NO-LOCK NO-ERROR.
       IF AVAILABLE gn-convt THEN F-CndVta = gn-convt.Nombr.
       FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
                    AND  gn-ven.CodVen = C-CODVEN 
                   NO-LOCK NO-ERROR.
       IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
       CcbCDocu.CodCli:SENSITIVE = NO.
       CcbCDocu.CodMon:SCREEN-VALUE = STRING(I-CodMon).
       DISPLAY C-NROPED @ CcbCDocu.NroPed
               C-CODVEN @ CcbCDocu.CodVen
               D-FCHVTO @ CcbCDocu.FchVto 
               F-NomVen F-CndVta.
       END.
 END.
RUN Procesa-Handle IN lh_Handle ('Browse').
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Pedidos V-table-Win 
PROCEDURE Asigna-Pedidos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DO WITH FRAME {&FRAME-NAME}:
    /*
    IF CcbCDocu.CodCli:SCREEN-VALUE = "" THEN DO:
       MESSAGE "Debe registrar al cliente" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    */
    IF NOT CcbCDocu.CodCli:SENSITIVE THEN DO:
       MESSAGE "Solo puede asignar una vez" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    RUN Actualiza-Deta.
    input-var-1 = "PED".
    input-var-2 = CcbCDocu.CodCli:SCREEN-VALUE.
    RUN lkup\C-Pedido.r("Pedidos Pendientes").
    IF output-var-2 <> ? THEN DO:
    
       C-CodPed = SUBSTRING(output-var-2,1,3).
       C-NroPed = SUBSTRING( output-var-2 ,4,9).
    
       FIND FacCPedi WHERE 
            FacCPedi.CodCia = S-CODCIA AND  
            FacCPedi.CodDiv = S-CodDiv AND  
            FacCPedi.CodDoc = C-CodPed /*"PED"*/ AND  
            FacCPedi.NroPed = C-NroPed /*output-var-2*/ 
            NO-LOCK NO-ERROR.
       /* C-NROPED = output-var-2.*/
       I-CODMON = FacCPedi.CodMon.
       C-CODVEN = FacCPedi.CodVen.
       
       CcbCDocu.CodCli:SCREEN-VALUE = FaccPedi.codcli.
       CcbCDocu.nomCli:SCREEN-VALUE = FaccPedi.nomcli.
       CcbCDocu.dirCli:SCREEN-VALUE = FaccPedi.dircli.
       CcbCDocu.ruc:SCREEN-VALUE = FaccPedi.ruc.
       CcbCDocu.glosa:SCREEN-VALUE = FaccPedi.glosa.
       CcbCDocu.nroped:SCREEN-VALUE = FaccPedi.nroped.
       CcbCDocu.nroref:SCREEN-VALUE = FaccPedi.nroref.

       FOR EACH FacDPedi NO-LOCK WHERE 
                FacDPedi.CodCia = FacCPedi.CodCia /*S-CODCIA */ AND  
                FacDPedi.CodDoc = FacCPedi.CodDoc /*"PED" */  AND  
                FacDPedi.NroPed = FacCPedi.NroPed /*output-var-2*/:
           CREATE DETA.
           ASSIGN DETA.CodCia = FacDPedi.CodCia 
                  DETA.codmat = FacDPedi.codmat 
                  DETA.PreUni = FacDPedi.PreUni 
                  DETA.CanDes = FacDPedi.CanPed 
                  DETA.Factor = FacDPedi.Factor 
                  DETA.ImpIsc = FacDPedi.ImpIsc 
                  DETA.ImpIgv = FacDPedi.ImpIgv 
                  DETA.ImpLin = FacDPedi.ImpLin 
                  DETA.PorDto = FacDPedi.PorDto 
                  DETA.PreBas = FacDPedi.PreBas 
                  DETA.ImpDto = FacDPedi.ImpDto 
                  DETA.AftIgv = FacDPedi.AftIgv 
                  DETA.AftIsc = FacDPedi.AftIsc 
                  DETA.UndVta = FacDPedi.UndVta
                  DETA.AlmDes = FacDPedi.AlmDes.
 
              /***********Grabando Costos **********************/
              FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                             AND  Almmmatg.codmat = DETA.codmat 
                            NO-LOCK NO-ERROR.
              IF AVAILABLE Almmmatg THEN DO: 
                 DETA.ImpCto = ROUND( Almmmatg.Ctotot * DETA.CanDes , 2 ) . 
                 IF I-CODMON <> Almmmatg.Monvta THEN DO:
                    DETA.ImpCto = IF I-CODMON = 1 THEN ROUND( Almmmatg.Ctotot * DETA.CanDes * Almmmatg.Tpocmb , 2 )
                                                  ELSE ROUND(( Almmmatg.Ctotot * DETA.CanDes ) /  Almmmatg.Tpocmb , 2 ).
                 END. 
              END.
              /*************************************************/
                  
       END.
       F-NomVen = "".
       F-CndVta = "".
       FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
                    AND  gn-ven.CodVen = FaccPedi.CodVen 
                   NO-LOCK NO-ERROR.
       IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
       FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
       IF AVAILABLE gn-convt THEN 
         ASSIGN F-CndVta = gn-convt.Nombr
                D-FchVto = TODAY + INTEGER(ENTRY(NUM-ENTRIES(gn-ConVt.Vencmtos),gn-ConVt.Vencmtos)).
       DISPLAY C-NroPed @ CcbCDocu.NroPed
               D-FCHVTO @ CcbCDocu.FchVto
               FacCPedi.ordcmp @ CcbCDocu.NroOrd
               FacCPedi.FmaPgo @ CcbCDocu.FmaPgo
               FaccPedi.CodVen @ CcbCDocu.CodVen
               F-NomVen F-CndVta.
       CcbCDocu.CodCli:SENSITIVE = NO.
       CcbCDocu.CodMon:SCREEN-VALUE = STRING(I-CodMon).
       C-TpoVta:SCREEN-VALUE = ENTRY(INTEGER(FacCPedi.TipVta),C-TpoVta:LIST-ITEMS).
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
FOR EACH CcbDDocu WHERE 
         CcbDDocu.CodCia = CcbCDocu.CodCia AND 
         CcbDDocu.CodDoc = CcbCDocu.CodDoc AND 
         CcbDDocu.NroDoc = CcbCDocu.NroDoc 
         ON ERROR UNDO, RETURN "ADM-ERROR":
         
    DELETE CcbDDocu.
         
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-temporal V-table-Win 
PROCEDURE Crea-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
  DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.
  FOR EACH T-CPEDM:
      DELETE T-CPEDM.
  END.
  FOR EACH T-DPEDM:
      DELETE T-DPEDM.
  END.
  DEFINE VARIABLE L-NewPed AS LOGICAL INIT YES NO-UNDO.
  DEFINE VARIABLE I-NPED   AS INTEGER INIT 0.
  DEFINE VARIABLE I-NItem  AS INTEGER INIT 0.
/*  FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.*/
  FOR EACH FacDPedi OF FacCPedi 
           BREAK BY FacDPedi.CodCia
                 BY FacDPedi.AlmDes : 
      IF FIRST-OF(FacDPedi.AlmDes) OR L-NewPed THEN DO:
         I-NPED = I-NPED + 1.
         CREATE T-CPEDM.
         ASSIGN T-CPEDM.CodCia   = FacCPedi.CodCia 
                T-CPEDM.CodDiv   = FacCPedi.CodDiv
                T-CPEDM.CodAlm   = FacDPedi.AlmDes
                T-CPEDM.CodDoc   = FacCPedi.CodDoc
                T-CPEDM.NroPed   = SUBSTRING(FacCPedi.NroPed,1,3) + STRING(I-NPED,"999999").
/*                T-CPEDM.Cmpbnte  = FacCPedi.Cmpbnte 
 *                 T-CPEDM.CodCli   = FacCPedi.CodCli 
 *                 T-CPEDM.CodMon   = FacCPedi.CodMon 
 *                 T-CPEDM.CodTrans = FacCPedi.CodTrans 
 *                 T-CPEDM.CodVen   = FacCPedi.CodVen 
 *                 T-CPEDM.DirCli   = FacCPedi.DirCli 
 *                 T-CPEDM.FchPed   = FacCPedi.FchPed 
 *                 T-CPEDM.FlgEst   = FacCPedi.FlgEst 
 *                 T-CPEDM.FmaPgo   = FacCPedi.FmaPgo 
 *                 T-CPEDM.Glosa    = FacCPedi.Glosa 
 *                 T-CPEDM.Hora     = FacCPedi.Hora 
 *                 T-CPEDM.LugEnt   = FacCPedi.LugEnt
 *                 T-CPEDM.NomCli   = FacCPedi.NomCli 
 *                 T-CPEDM.PorDto   = FacCPedi.PorDto 
 *                 T-CPEDM.PorIgv   = FacCPedi.PorIgv
 *                 T-CPEDM.RucCli   = FacCPedi.RucCli 
 *                 T-CPEDM.TipVta   = FacCPedi.TipVta 
 *                 T-CPEDM.TpoCmb   = FacCPedi.TpoCmb 
 *                 T-CPEDM.UsrDscto = FacCPedi.UsrDscto 
 *                 T-CPEDM.usuario  = FacCPedi.usuario
 *                 T-CPEDM.ImpBrt   = 0
 *                 T-CPEDM.ImpDto   = 0
 *                 T-CPEDM.ImpExo   = 0
 *                 T-CPEDM.ImpIgv   = 0
 *                 T-CPEDM.ImpIsc   = 0
 *                 T-CPEDM.ImpTot   = 0
 *                 T-CPEDM.ImpVta   = 0.
 *          F-IGV = 0.
 *          F-ISC = 0.*/
         L-NewPed = NO.
         I-NItem = 0.
      END.
/*      T-CPEDM.ImpDto = T-CPEDM.ImpDto + FacDPedi.ImpDto.
 *                F-IGV = F-IGV + FacDPedi.ImpIgv.
 *                F-ISC = F-ISC + FacDPedi.ImpIsc.
 *       T-CPEDM.ImpTot = T-CPEDM.ImpTot + FacDPedi.ImpLin.
 *       IF NOT FacDPedi.AftIgv THEN T-CPEDM.ImpExo = T-CPEDM.ImpExo + FacDPedi.ImpLin.
 *       CREATE T-DPEDM.
 *       RAW-TRANSFER FacDPedi TO T-DPEDM.
 *       ASSIGN T-DPEDM.NroPed = T-CPEDM.NroPed.
 *       I-NItem = I-NItem + 1.
 *       IF ( T-CPEDM.Cmpbnte = "BOL" AND I-NItem >= FacCfgGn.Items_Boleta ) OR 
 *          ( T-CPEDM.Cmpbnte = "FAC" AND I-NItem >= FacCfgGn.Items_Factura ) THEN DO:
 *          L-NewPed = YES.
 *       END.*/
      IF LAST-OF(FacDPedi.AlmDes) OR L-NewPed THEN DO:
         L-NewPed = YES.    /****   ADD BY C.Q. 03/03/2000  ****/
/*         ASSIGN T-CPEDM.ImpIgv = ROUND(F-IGV,2).
 *                 T-CPEDM.ImpIsc = ROUND(F-ISC,2).
 *                 T-CPEDM.ImpBrt = T-CPEDM.ImpTot - T-CPEDM.ImpIgv - T-CPEDM.ImpIsc + 
 *                                  T-CPEDM.ImpDto - T-CPEDM.ImpExo.
 *                 T-CPEDM.ImpVta = T-CPEDM.ImpBrt - T-CPEDM.ImpDto.
 * 
 *         /****    ADD BY C.Q. 03/03/2000  ****/
 *         /*** DESCUENTO GLOBAL ****/
 *         IF T-CPEDM.PorDto > 0 THEN DO:
 *            T-CPEDM.ImpDto = T-CPEDM.ImpDto + ROUND(T-CPEDM.ImpTot * T-CPEDM.PorDto / 100,2).
 *            T-CPEDM.ImpTot = ROUND(T-CPEDM.ImpTot * (1 - T-CPEDM.PorDto / 100),2).
 *            T-CPEDM.ImpVta = ROUND(T-CPEDM.ImpTot / (1 + T-CPEDM.PorIgv / 100),2).
 *            T-CPEDM.ImpIgv = T-CPEDM.ImpTot - T-CPEDM.ImpVta.
 *            T-CPEDM.ImpBrt = T-CPEDM.ImpTot - T-CPEDM.ImpIgv - T-CPEDM.ImpIsc + 
 *                             T-CPEDM.ImpDto - T-CPEDM.ImpExo.
 *         END.*/
      END.
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
   RUN Borra-Detalle. 
   FOR EACH DETA NO-LOCK ON ERROR UNDO, RETURN "ADM-ERROR":
       IF DETA.CanDes > 0 THEN DO:
          CREATE CcbDDocu.
          ASSIGN CcbDDocu.CodCia = CcbCDocu.CodCia 
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
                 CcbDDocu.AlmDes = DETA.AlmDes
                 CcbDDocu.FchDoc = TODAY.
                 CcbDDocu.CodDiv = CcbCDocu.CodDiv.
                 CcbDDocu.ImpCto = DETA.ImpCto.

       END.
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
   FIND B-CDOCU WHERE ROWID(B-CDOCU) = ROWID(CcbCDocu) EXCLUSIVE-LOCK NO-ERROR.
   B-CDOCU.ImpIgv = 0.
   B-CDOCU.ImpIsc = 0.
   B-CDOCU.ImpExo = 0.

   

   B-CDOCU.ImpVta = ROUND(B-CDOCU.ImpTot / 1.18 , 2).
   B-CDOCU.ImpIgv = B-CDOCU.ImpTot - B-CDOCU.ImpVta.

   B-CDOCU.ImpBrt = B-CDOCU.ImpTot - B-CDOCU.ImpIgv - B-CDOCU.ImpIsc + 
                    B-CDOCU.ImpDto - B-CDOCU.ImpExo.


   B-CDOCU.SdoAct  = B-CDOCU.ImpTot.
   B-CDOCU.Imptot2 = B-CDOCU.ImpTot.
   RELEASE B-CDOCU.
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
  S-CODMON = 1.

  RUN Numero-de-Documento(NO).
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY @ CcbCDocu.FchDoc
             TODAY @ CcbCDocu.FchVto
             FacCfgGn.CliVar @ CcbCDocu.CodCli
             FacCfgGn.Tpocmb[1] @ CcbCDocu.TpoCmb
             STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999") @ CcbCDocu.NroDoc.
 
     CcbCDocu.NroOrd:SENSITIVE = NO.
     CcbCDocu.DirCli:SENSITIVE = NO. 
     CcbCDocu.NomCli:SENSITIVE = NO. 
     CcbCDocu.RucCli:SENSITIVE = NO.
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
  
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN CcbCDocu.CodCia = S-CODCIA
            CcbCDocu.CodAlm = S-CODALM
            CcbCDocu.FchDoc = DATE(CcbCDocu.FchDoc:SCREEN-VALUE)
            CcbCDocu.FlgEst = "P"
            CcbCDocu.FlgAte = "P"
            CcbCDocu.CodDoc = S-CODDOC
            CcbCDocu.CodMov = S-CODMOV 
            CcbCDocu.CodDiv = S-CODDIV
            CcbCDocu.NroDoc = CcbCDocu.NroDoc:SCREEN-VALUE

            CcbCDocu.CodPed = "PED"
            CcbCDocu.NroPed = CcbCDocu.NroPed:SCREEN-VALUE  
            CcbCDocu.CodRef = "G/R"
            CcbCDocu.NroRef = CcbCDocu.NroRef:SCREEN-VALUE
           
            CcbCDocu.Tipo   = "OFICINA"
            CcbCDocu.TipVta = "2"
            CcbCDocu.TpoFac = ""
            CcbCDocu.FchVto = DATE(CcbCDocu.FchVto:SCREEN-VALUE)
            CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
            CcbCDocu.PorIgv = FacCfgGn.PorIgv
            CcbCDocu.CodMon = S-CodMon
            CcbCDocu.CodVen = CcbCDocu.CodVen:SCREEN-VALUE
            CcbCDocu.FlgAte = 'D'
            CcbCDocu.FchAte = TODAY
            CCbCDocu.Imptot = DECI(CCbCDocu.Imptot:SCREEN-VALUE)
            CCbCDocu.ImpDto = DECI(CCbCDocu.ImpDto:SCREEN-VALUE)
            CcbCDocu.usuario = S-USER-ID.
     DISPLAY CcbCDocu.NroDoc.
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
          gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie  THEN DO:
        ASSIGN CcbCDocu.CodDpto = gn-clie.CodDept 
               CcbCDocu.CodProv = gn-clie.CodProv 
               CcbCDocu.CodDist = gn-clie.CodDist.
     END.
    /* ACTUALIZAR EL CENTRO DE COSTO 22.07.04 CY */
    FIND GN-VEN WHERE gn-ven.codcia = s-codcia
        AND gn-ven.codven = ccbcdocu.codven NO-LOCK NO-ERROR.
    IF AVAILABLE GN-VEN THEN ccbcdocu.cco = gn-ven.cco.
  END.
  RUN Graba-Totales.


  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
    
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
  DEFINE VAR x-flgOD AS LOGICAL NO-UNDO.
  
  FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
  RUN ALM/D-CLAVE.R(FacCfgGn.Cla_Venta,OUTPUT RPTA). 
  IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
  
  /* Code placed here will execute PRIOR to standard behavior. */
  IF CcbCDocu.FlgEst = "A" THEN DO:
     MESSAGE 'El documento se enuentra Anulado...' VIEW-AS ALERT-BOX.
     RETURN 'ADM-ERROR'.
  END.
  IF CcbCDocu.SdoAct < CcbCDocu.ImpTot  THEN DO:
     MESSAGE 'El documento registra amortizaciones...' VIEW-AS ALERT-BOX.
     RETURN 'ADM-ERROR'.
  END.
   
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
     /****   Add by C.Q. 17/03/2000  
             Imprime un Documento similar a la O/D Indicando
             el motivo de Anulación  ****/
     FIND FIRST Ccbddocu OF Ccbcdocu NO-LOCK NO-ERROR.
     IF AVAIL CcbDdocu THEN
        RUN ccb/r-motanu (ROWID(ccbcdocu), CcbDDocu.AlmDes, "Documento Anulado").
     RELEASE CcbDdocu.
     /**********************************/
     
     RUN Borra-Detalle.
     
     FOR EACH B-CDOCU EXCLUSIVE-LOCK WHERE 
              B-CDOCU.CodCia = S-CODCIA AND  
              B-CDOCU.CodDoc = "G/R"    AND  
              B-CDOCU.FlgEst = "F"      AND  
              B-CDOCU.CodRef = CcbCDocu.CodDoc AND  
              B-CDOCU.NroRef = CcbCDocu.NroDoc 
              ON ERROR UNDO, LEAVE:
         ASSIGN B-CDOCU.FlgEst = "P"
              B-CDOCU.SdoAct = B-CDOCU.ImpTot.
     END.   
     
     FIND B-CDOCU WHERE ROWID(B-CDOCU) = ROWID(CcbCDocu) EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE B-CDOCU THEN 
        ASSIGN B-CDOCU.FlgEst = "A"
               B-CDOCU.SdoAct = 0
               B-CDOCU.UsuAnu = S-USER-ID
               B-CDOCU.FchAnu = TODAY
               B-CDOCU.Glosa  = "A N U L A D O".
     RELEASE B-CDOCU.
      
     /* Verifico que el pedido tiene Ordenes de Despacho */
     x-flgOD = FALSE.
     /*
     FIND FIRST FacCPedi WHERE 
                FacCPedi.CodCia = CcbCDocu.CodCia AND  
                FacCPedi.NroRef = CcbCDocu.NroPed 
                NO-LOCK NO-ERROR.
     IF AVAILABLE FacCPedi THEN x-flgOD = TRUE.
     FIND FacCPedi WHERE 
          FacCPedi.CodCia = CcbCDocu.CodCia AND  
          FacCPedi.CodDoc = CcbCDocu.CodPed AND  
          FacCPedi.NroPed = CcbCDocu.NroPed 
          EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE FacCPedi THEN 
        ASSIGN FacCPedi.FlgEst = IF x-flgOD THEN "C" ELSE "P".
     RELEASE FacCPedi.
      */
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
  
  IF AVAILABLE CcbCDocu THEN DO WITH FRAME {&FRAME-NAME}:
     
     IF CcbCDocu.FlgEst = "P" THEN F-Estado:SCREEN-VALUE = "PENDIENTE".
     IF CcbCDocu.FlgEst = "A" THEN F-Estado:SCREEN-VALUE = "ANULADO".
     IF CcbCDocu.FlgEst = "C" THEN F-Estado:SCREEN-VALUE = "CANCELADO".
     
     F-NomVen:screen-value = "".
     FIND gn-ven WHERE 
          gn-ven.CodCia = S-CODCIA AND 
          gn-ven.CodVen = CcbCDocu.CodVen 
          NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
     F-CndVta:SCREEN-VALUE = "".
     
     FIND gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
     
     C-TpoVta:SCREEN-VALUE = ENTRY(INTEGER(CcbCDocu.TipVta),C-TpoVta:LIST-ITEMS).
     

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

  IF S-CODDOC = "FAC" THEN DO:
     RUN VTA\R-IMPFAC2 (ROWID(CcbCDocu)).
  END.    
  
  IF S-CODDOC = "BOL" THEN DO:
     RUN VTA\R-IMPBOL2 (ROWID(CcbCDocu)).
  END.
  
  IF S-CODDIV <> "00000" THEN DO:
   RUN VTA\r-odesp.R(ROWID(CcbCDocu)).
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
     FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = S-CODDOC AND
          FacCorre.CodDiv = S-CODDIV AND
          FacCorre.NroSer = S-NROSER EXCLUSIVE-LOCK NO-ERROR.
  ELSE
     FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
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
   IF CcbCDocu.CodCli:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO CcbCDocu.CodCli.
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
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

