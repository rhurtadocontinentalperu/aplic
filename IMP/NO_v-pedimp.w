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

DEFINE SHARED TEMP-TABLE DCMP LIKE ImDOCmp.
DEFINE SHARED TEMP-TABLE DREQ LIKE LG-DREQU.
DEFINE BUFFER B-CCMP  FOR ImCOCmp.
DEFINE BUFFER B-DCMP  FOR ImDOCmp.
DEFINE BUFFER B-CREQ FOR LG-CREQU.

DEFINE SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE PV-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-NomCia  AS CHARACTER.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE SHARED VARIABLE S-NROSER  AS INTEGER.
DEFINE SHARED VARIABLE S-PROVEE  AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
DEFINE VARIABLE p-NroRef LIKE LG-CREQU.NroReq.

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
&Scoped-define EXTERNAL-TABLES ImCOCmp
&Scoped-define FIRST-EXTERNAL-TABLE ImCOCmp


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ImCOCmp.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ImCOCmp.Periodo ImCOCmp.CodPro ImCOCmp.CodPrd ~
ImCOCmp.CodRep ImCOCmp.Version ImCOCmp.Pais ImCOCmp.FchProd ~
ImCOCmp.Proforma ImCOCmp.NroPedPro ImCOCmp.TpoCmb ImCOCmp.FlgEst[1] ~
ImCOCmp.Moneda ImCOCmp.ImpFob ImCOCmp.CndCmp ImCOCmp.ImpFle ImCOCmp.CodBco ~
ImCOCmp.NroCreDoc ImCOCmp.Carga ImCOCmp.NroCon ImCOCmp.FchIni ~
ImCOCmp.Observaciones ImCOCmp.FchFin 
&Scoped-define ENABLED-TABLES ImCOCmp
&Scoped-define FIRST-ENABLED-TABLE ImCOCmp
&Scoped-Define ENABLED-OBJECTS RECT-24 
&Scoped-Define DISPLAYED-FIELDS ImCOCmp.Periodo ImCOCmp.NroImp ~
ImCOCmp.NroReq ImCOCmp.NroPed ImCOCmp.Fchdoc ImCOCmp.CodPro ImCOCmp.NomPro ~
ImCOCmp.Hora ImCOCmp.CodPrd ImCOCmp.Userid-com ImCOCmp.CodRep ~
ImCOCmp.Version ImCOCmp.Pais ImCOCmp.FchProd ImCOCmp.Proforma ~
ImCOCmp.NroPedPro ImCOCmp.TpoCmb ImCOCmp.FlgEst[1] ImCOCmp.Moneda ~
ImCOCmp.ImpFob ImCOCmp.CndCmp ImCOCmp.ImpFle ImCOCmp.CodBco ~
ImCOCmp.NroCreDoc ImCOCmp.ImpCfr ImCOCmp.Carga ImCOCmp.NroCon ~
ImCOCmp.FchIni ImCOCmp.Observaciones ImCOCmp.FchFin 
&Scoped-define DISPLAYED-TABLES ImCOCmp
&Scoped-define FIRST-DISPLAYED-TABLE ImCOCmp
&Scoped-Define DISPLAYED-OBJECTS F-SitDoc F-Productor F-Represent F-Pais ~
F-RucPro F-Moneda F-DesCnd F-Banco F-Seguro F-Carga 

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
DEFINE VARIABLE F-Banco AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

DEFINE VARIABLE F-Carga AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24 BY .81 NO-UNDO.

DEFINE VARIABLE F-DesCnd AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

DEFINE VARIABLE F-Moneda AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE F-Pais AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .81 NO-UNDO.

DEFINE VARIABLE F-Productor AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .81 NO-UNDO.

DEFINE VARIABLE F-Represent AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .81 NO-UNDO.

DEFINE VARIABLE F-RucPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .81 NO-UNDO.

DEFINE VARIABLE F-Seguro AS DECIMAL FORMAT "ZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Seguro" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-SitDoc AS CHARACTER FORMAT "X(256)":U INITIAL "Emitido" 
     LABEL "Situacion" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 116 BY 11.73.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     ImCOCmp.Periodo AT ROW 1.19 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     ImCOCmp.NroImp AT ROW 1.19 COL 41 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
          FONT 6
     ImCOCmp.NroReq AT ROW 1.19 COL 65 COLON-ALIGNED
          LABEL "Nro. Requerimiento"
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
          FONT 6
     F-SitDoc AT ROW 1.27 COL 96 COLON-ALIGNED
     ImCOCmp.NroPed AT ROW 1.96 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22 BY .81
          FONT 6
     ImCOCmp.Fchdoc AT ROW 2.04 COL 96 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.CodPro AT ROW 2.77 COL 18 COLON-ALIGNED WIDGET-ID 8
          LABEL "Proveedor/Exportador:" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
     ImCOCmp.NomPro AT ROW 2.81 COL 26 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 47 BY .81
     ImCOCmp.Hora AT ROW 2.81 COL 96 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.CodPrd AT ROW 3.58 COL 18 COLON-ALIGNED
          LABEL "Productor:"
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
     F-Productor AT ROW 3.58 COL 26 COLON-ALIGNED NO-LABEL
     ImCOCmp.Userid-com AT ROW 3.58 COL 96 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.CodRep AT ROW 4.35 COL 18 COLON-ALIGNED WIDGET-ID 18
          LABEL "Representante:"
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
     F-Represent AT ROW 4.35 COL 26 COLON-ALIGNED NO-LABEL
     ImCOCmp.Version AT ROW 4.38 COL 96 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     F-Pais AT ROW 5.04 COL 24 COLON-ALIGNED NO-LABEL
     F-RucPro AT ROW 5.04 COL 54.43 COLON-ALIGNED NO-LABEL
     ImCOCmp.Pais AT ROW 5.12 COL 18 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     ImCOCmp.FchProd AT ROW 5.58 COL 96 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.Proforma AT ROW 5.85 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.57 BY .81
     ImCOCmp.NroPedPro AT ROW 5.88 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.TpoCmb AT ROW 6.35 COL 96 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.FlgEst[1] AT ROW 6.65 COL 18 COLON-ALIGNED
          LABEL "INCOTERM"
          VIEW-AS COMBO-BOX INNER-LINES 5
          DROP-DOWN-LIST
          SIZE 8 BY 1
     ImCOCmp.Incoterm AT ROW 6.65 COL 29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     F-Moneda AT ROW 7.38 COL 24 COLON-ALIGNED NO-LABEL
     ImCOCmp.Moneda AT ROW 7.42 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     ImCOCmp.ImpFob AT ROW 7.46 COL 96 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     F-DesCnd AT ROW 8.15 COL 24 COLON-ALIGNED NO-LABEL
     ImCOCmp.CndCmp AT ROW 8.19 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     ImCOCmp.ImpFle AT ROW 8.23 COL 96 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.CodBco AT ROW 8.96 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     F-Banco AT ROW 8.96 COL 24 COLON-ALIGNED NO-LABEL
     F-Seguro AT ROW 9 COL 96 COLON-ALIGNED
     ImCOCmp.NroCreDoc AT ROW 9.73 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.ImpCfr AT ROW 9.77 COL 96 COLON-ALIGNED
          LABEL "CFR"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.Carga AT ROW 10.42 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     F-Carga AT ROW 10.42 COL 24 COLON-ALIGNED NO-LABEL
     ImCOCmp.NroCon AT ROW 10.42 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4 BY .81
     ImCOCmp.FchIni AT ROW 10.96 COL 96 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.Observaciones AT ROW 11.31 COL 20 NO-LABEL
          VIEW-AS EDITOR
          SIZE 49 BY 1.35
     ImCOCmp.FchFin AT ROW 11.73 COL 96 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     "Observaciones:" VIEW-AS TEXT
          SIZE 11 BY .5 AT ROW 11.38 COL 9
     "R.U.C.:" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 5.23 COL 51
     "Vigencia del Doc. Credito:" VIEW-AS TEXT
          SIZE 18 BY .5 AT ROW 10.42 COL 74
     RECT-24 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.ImCOCmp
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
         HEIGHT             = 11.73
         WIDTH              = 116.57.
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

/* SETTINGS FOR FILL-IN ImCOCmp.CodPrd IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ImCOCmp.CodPro IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN ImCOCmp.CodRep IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN F-Banco IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Carga IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesCnd IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Moneda IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Pais IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Productor IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Represent IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-RucPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Seguro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-SitDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCOCmp.Fchdoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX ImCOCmp.FlgEst[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ImCOCmp.Hora IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCOCmp.ImpCfr IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN ImCOCmp.Incoterm IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN ImCOCmp.NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCOCmp.NroImp IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCOCmp.NroPed IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCOCmp.NroReq IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN ImCOCmp.Userid-com IN FRAME F-Main
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

&Scoped-define SELF-NAME ImCOCmp.Carga
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCOCmp.Carga V-table-Win
ON LEAVE OF ImCOCmp.Carga IN FRAME F-Main /* Tipo Carga */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND AlmTabla WHERE 
       AlmTabla.Tabla = "CA" AND
       AlmTabla.Codigo = ImCOCmp.Carga:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE AlmTabla THEN
       DISPLAY AlmTabla.Nombre @ F-Carga
      WITH FRAME {&FRAME-NAME}.
  ELSE DO:
        MESSAGE "Tipo de Carga no Registrado" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ImCOCmp.CndCmp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCOCmp.CndCmp V-table-Win
ON LEAVE OF ImCOCmp.CndCmp IN FRAME F-Main /* Forma Pago */
DO:
  IF ImCOCmp.CndCmp:SCREEN-VALUE <> "" THEN DO:
     F-DesCnd:SCREEN-VALUE = "".
     FIND gn-concp WHERE 
          gn-concp.Codig = ImCOCmp.CndCmp:SCREEN-VALUE NO-LOCK NO-ERROR.
          IF AVAILABLE gn-concp THEN 
             DISPLAY gn-concp.Nombr @ F-DesCnd WITH FRAME {&FRAME-NAME}.
          ELSE DO:
             MESSAGE "Forma de Pago no Registrado" VIEW-AS ALERT-BOX.
             RETURN NO-APPLY.
          END.
  END.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ImCOCmp.CodBco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCOCmp.CodBco V-table-Win
ON LEAVE OF ImCOCmp.CodBco IN FRAME F-Main /* Banco */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN "ADM-ERROR".
     FIND AlmTabla WHERE 
        AlmTabla.Tabla = "BN" AND
        AlmTabla.Codigo = ImCOCmp.CodBco:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE AlmTabla THEN
        DISPLAY AlmTabla.Nombre @ F-Banco
        WITH FRAME {&FRAME-NAME}.
     ELSE DO:
        MESSAGE "Banco no Registrado" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
     END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ImCOCmp.CodPrd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCOCmp.CodPrd V-table-Win
ON LEAVE OF ImCOCmp.CodPrd IN FRAME F-Main /* Productor: */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN "ADM-ERROR".
     FIND gn-prov WHERE 
        gn-prov.CodCia = PV-CODCIA AND
        gn-prov.CodPro = ImCocmp.CodPrd:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN
        DISPLAY gn-prov.NomPro @ F-Productor WITH FRAME {&FRAME-NAME}.
     ELSE DO:
        MESSAGE "Productor no Registrado" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
     END.
     IF gn-prov.flgsit = 'C' THEN DO:
        MESSAGE 'Productor CESADO' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ImCOCmp.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCOCmp.CodPro V-table-Win
ON LEAVE OF ImCOCmp.CodPro IN FRAME F-Main /* Proveedor/Exportador: */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN "ADM-ERROR".
     FIND gn-prov WHERE 
        gn-prov.CodCia = PV-CODCIA AND
        gn-prov.CodPro = ImCocmp.CodPro:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN
        DISPLAY gn-prov.NomPro @ ImCOCmp.NomPro
                gn-prov.Ruc    @ F-RucPro WITH FRAME {&FRAME-NAME}.
     ELSE DO:
        MESSAGE "Proveedor no Registrado" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
     END.
     IF gn-prov.flgsit = 'C' THEN DO:
        MESSAGE 'Proveedor CESADO' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ImCOCmp.CodRep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCOCmp.CodRep V-table-Win
ON LEAVE OF ImCOCmp.CodRep IN FRAME F-Main /* Representante: */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN "ADM-ERROR".
     FIND gn-prov WHERE 
        gn-prov.CodCia = PV-CODCIA AND
        gn-prov.CodPro = ImCocmp.CodRep:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN
        DISPLAY gn-prov.NomPro @ F-Represent WITH FRAME {&FRAME-NAME}.
     ELSE DO:
        MESSAGE "Representante no Registrado" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
     END.
     IF gn-prov.flgsit = 'C' THEN DO:
        MESSAGE 'Representante CESADO' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ImCOCmp.FlgEst[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCOCmp.FlgEst[1] V-table-Win
ON VALUE-CHANGED OF ImCOCmp.FlgEst[1] IN FRAME F-Main /* INCOTERM */
DO:
    ImCOCmp.ImpCfr:LABEL = 'CFR'.
    ImCOCmp.ImpFle:HIDDEN = FALSE.
    ImCOCmp.ImpCfr:HIDDEN = FALSE.
    F-Seguro:HIDDEN = TRUE.
    IF ImCOCmp.FlgEst[1]:SCREEN-VALUE = "CFR" THEN DO:
        ImCOCmp.ImpCfr:LABEL = 'CFR'.
        ImCOCmp.ImpFle:HIDDEN = FALSE.
        ImCOCmp.ImpFle:SENSITIVE = TRUE.
        ImCOCmp.ImpCfr:HIDDEN = FALSE.
        F-Seguro:HIDDEN = TRUE.    
    END.
    CASE ImCOCmp.FlgEst[1]:SCREEN-VALUE:
        WHEN "FOB" THEN DO:
            ImCOCmp.ImpFle:HIDDEN = TRUE.
            ImCOCmp.ImpFle:SENSITIVE = FALSE.
            ImCOCmp.ImpCfr:HIDDEN = TRUE.
        END.
        WHEN "CIF" THEN DO: 
            ImCOCmp.ImpCfr:LABEL = 'CIF'.
            ImCOCmp.ImpFle:SENSITIVE = TRUE.
            F-Seguro:HIDDEN = FALSE.
            F-Seguro:SENSITIVE = TRUE.
        END.
        OTHERWISE ImCOCmp.ImpFle:SENSITIVE = TRUE.
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ImCOCmp.Moneda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCOCmp.Moneda V-table-Win
ON LEAVE OF ImCOCmp.Moneda IN FRAME F-Main /* Moneda */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND AlmTabla WHERE 
       AlmTabla.Tabla = "MO" AND
       AlmTabla.Codigo = ImCOCmp.Moneda:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE AlmTabla THEN
       DISPLAY AlmTabla.Nombre @ F-Moneda
      WITH FRAME {&FRAME-NAME}.
  ELSE DO:
        MESSAGE "Moneda no Registrado" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ImCOCmp.Pais
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCOCmp.Pais V-table-Win
ON LEAVE OF ImCOCmp.Pais IN FRAME F-Main /* Pais */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND AlmTabla WHERE 
       AlmTabla.Tabla = "PA" AND
       AlmTabla.Codigo = ImCOCmp.pais:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE AlmTabla THEN
       DISPLAY AlmTabla.Nombre @ F-Pais
      WITH FRAME {&FRAME-NAME}.
  ELSE DO:
        MESSAGE "Pais no Registrado" VIEW-AS ALERT-BOX.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-O/C V-table-Win 
PROCEDURE Actualiza-O/C :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR SumandoT AS DECIMAL INIT 0.
  DEFINE VAR BAN      AS INTEGER INIT 0 NO-UNDO .
     
  FOR EACH B-CCMP NO-LOCK WHERE B-CCMP.CODCIA = S-CODCIA
     AND B-CCMP.NroReq = p-NroRef,
     EACH B-DCMP OF B-CCMP NO-LOCK 
          BREAK BY B-CCMP.NroReq BY B-DCMP.CodMat:
          /* ACCUMULATE B-DCMP.CanAten(SUB-TOTAL BY B-DCMP.CodMat). */
            FIND FIRST LG-CREQU WHERE LG-CREQU.CodCia = s-CodCia
            AND LG-CREQU.NroReq = p-NroRef
            AND LG-CREQU.FlgSit = 'A'
            NO-LOCK NO-ERROR.
                IF AVAILABLE LG-CREQU THEN DO:
                    FOR EACH LG-DREQU OF LG-CREQU WHERE LG-DREQU.CodMat = B-DCMP.CodMat:
                        /* SumandoT = ACCUM SUB-TOTAL by B-DCMP.CodMat B-DCMP.CanAten.  */
                        ASSIGN LG-DREQU.CanAten = B-DCMP.CanPedi.    
                    END.
                END.
  END.
  RELEASE LG-CREQU.
  RELEASE LG-DREQU.
  
  /*Bloqueando Orden de Compra*/ 
  FIND FIRST B-CREQ WHERE B-CREQ.CodCia = s-CodCia
       AND B-CREQ.NroReq = p-NroRef
       AND B-CREQ.FlgSit = 'A'
       EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE B-CREQ THEN DO:
       FOR EACH LG-DREQU OF B-CREQ WHERE 
           LG-DREQU.CanPed <> LG-DREQU.CanAten BREAK BY LG-DREQU.CodMat:
           BAN = BAN + 1.
       END. 
       IF BAN = 0 THEN ASSIGN B-CREQ.FlgSit = 'B'.
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
  {src/adm/template/row-list.i "ImCOCmp"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ImCOCmp"}

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
   FOR EACH ImDOCmp OF ImCOCmp EXCLUSIVE-LOCK
        ON ERROR UNDO, RETURN 'ADM-ERROR'   
        ON STOP UNDO, RETURN 'ADM-ERROR':
     DELETE ImDOCmp. 
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal V-table-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH DCMP:
    DELETE DCMP.
  END.
  
  FOR EACH DREQ:
    DELETE DREQ.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal V-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   RUN Borra-Temporal.
   /*Validando Cantidades*/
   MESSAGE INTEGER(ImCOCmp.NroReq:SCREEN-VALUE IN FRAME {&FRAME-NAME}) VIEW-AS ALERT-BOX.            
   FOR EACH LG-DREQU WHERE 
            LG-DREQU.CodCia  = S-CodCia AND
            LG-DREQU.NroReq  = INTEGER(ImCOCmp.NroReq:SCREEN-VALUE IN FRAME {&FRAME-NAME}) AND 
            LG-DREQU.CanApro > 0 NO-LOCK:
            FOR EACH B-CCMP WHERE B-CCMP.NroReq = INTEGER(ImCOcmp.NroReq:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-LOCK,
                EACH B-DCMP WHERE B-DCMP.NroImp = B-CCMP.NroImp
                BREAK BY B-DCMP.CodMat:
                  ACCUMULATE B-DCMP.canpedi (SUB-TOTAL BY B-DCMP.CodMat).   
                  MESSAGE B-DCMP.CodMat SKIP 
                          "cant mat en orden" ACCUM SUB-TOTAL BY B-DCMP.CodMat B-DCMP.canpedi 
                  VIEW-AS ALERT-BOX. 
                  IF Lg-DRequ.CanApro <> ACCUM SUB-TOTAL BY B-DCMP.CodMat B-DCMP.canpedi THEN DO:
                     CREATE DREQ.
/*                   BUFFER-COPY LG-DREQU TO DREQ. */
                     ASSIGN 
                          DREQ.CodCia  = s-codcia
                          DREQ.CodMat  = Lg-DRequ.CodMat
                          DREQ.CanApro = Lg-DRequ.CanApro.
                  END.
            END. 
   END.
   
/*    FOR EACH LG-DREQU WHERE                                                                */
/*        LG-DREQU.CodCia  = S-CodCia AND                                                    */
/*        LG-DREQU.NroReq  = INTEGER(ImCOCmp.NroReq:SCREEN-VALUE IN FRAME {&FRAME-NAME}) AND */
/*        LG-DREQU.CanApro > 0 NO-LOCK:                                                      */
/*             CREATE DREQ.                                                                  */
/*             BUFFER-COPY LG-DREQU TO DREQ.                                                 */
/*    END.                                                                                   */



   FOR EACH DREQ /* WHERE DREQ.CanApro <> 0 */ :
       CREATE DCMP.
       ASSIGN
            DCMP.NroImp  = INTEGER(ImCOCmp.NroImp:SCREEN-VALUE IN FRAME {&FRAME-NAME})
            DCMP.CodCia  = DREQ.CodCia
            DCMP.CodDoc  = "O/C"
            DCMP.CodMat  = DREQ.CodMat
            DCMP.CanPedi = DREQ.CanApro.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal2 V-table-Win 
PROCEDURE Carga-Temporal2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   RUN Borra-Temporal.
   FOR EACH B-DCMP WHERE
       B-DCMP.NroImp = ImCOCmp.NroImp NO-LOCK:
       CREATE DCMP.
       /* BUFFER-COPY B-DCMP TO DCMP. */
         ASSIGN
            DCMP.NroImp     = ImCOCmp.NroImp
            DCMP.CodCia     = ImCOCmp.CodCia
            DCMP.CodDoc     = "O/C"
            DCMP.CodMat     = B-DCMP.CodMat
            DCMP.CanPedi    = B-DCMP.CanPedi
            DCMP.Tolerancia = B-DCMP.Tolerancia
            DCMP.PreUni     = B-DCMP.PreUni.
            DCMP.ImpTot     = B-DCMP.ImpTot.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Contador V-table-Win 
PROCEDURE Contador :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
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
  FOR EACH DCMP:
    CREATE ImDOCmp.
    BUFFER-COPY DCMP TO ImDOcmp
        ASSIGN 
            ImDOCmp.CodCia      = ImCOCmp.CodCia 
            ImDOCmp.Coddoc      = ImCOCmp.Coddoc
            ImDOCmp.NroImp      = ImCOCmp.NroImp
            ImDOCmp.codmat      = DCMP.CodMat 
            ImDOCmp.Tolerancia  = DCMP.Tolerancia
            ImDOCmp.PreUni      = DCMP.PreUni
            ImDOCmp.CanPedi     = DCMP.CanPedi
            ImDOCmp.ImpTot      = ImDOCmp.PreUni * ImDOCmp.CanPedi.        
  END.
  RELEASE ImDOCmp.
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

    DEFINE VARIABLE ImpTot AS DECIMAL INIT 0 NO-UNDO.   

    FOR EACH B-DCMP NO-LOCK WHERE
        B-DCMP.codCia = ImcOcmp.Codcia AND
        B-DCMP.codDoc = ImcOCmp.CodDoc AND
        B-DCMP.NroImp = ImcOcmp.NroImp:
        ImpTot = ImpTot + B-DCMP.ImpTot.
    END.
    ASSIGN ImCOCmp.ImpTot = ImpTot.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Incoterm V-table-Win 
PROCEDURE Incoterm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE Seg  AS DECIMAL.
    DEFINE VARIABLE tem  AS DECIMAL.
    
     /************************CFR**********************************/
    IF ImCOCmp.FlgEst[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "CFR" THEN DO: 
        ASSIGN ImCOCmp.ImpCfr = ImCOCmp.ImpTot.
        DISPLAY ImCOCmp.ImpCfr WITH FRAME {&FRAME-NAME}.
    END.
    /************************FOB*********************************/ 
    IF ImCOCmp.FlgEst[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "FOB" THEN DO: 
         ASSIGN ImCOCmp.ImpFob = ImCOCmp.ImpTot.
         DISPLAY ImCOCmp.ImpFob WITH FRAME {&FRAME-NAME}.
    END.
    /************************CIF*********************************/
    IF ImCOCmp.FlgEst[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "CIF" THEN DO: 
         ASSIGN ImCOCmp.ImpCfr = ImCOCmp.ImpTot.
         DISPLAY ImCOCmp.ImpCfr WITH FRAME {&FRAME-NAME}.
         tem = ImCOCmp.ImpFob + ImCOCmp.ImpFle. 
         Seg = ImCOCmp.ImpTot - tem.
         ASSIGN F-Seguro = Seg.
         DISPLAY Seg @ F-Seguro WITH FRAME {&FRAME-NAME}.
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
  
  RUN IMP\d-reqpen (OUTPUT p-NroRef).
  IF p-NroRef = 0 THEN RETURN 'ADM-ERROR'.
  
  FIND LG-CORR WHERE LG-CORR.CodCia = S-CODCIA 
    AND LG-CORR.CodDiv = s-CodDiv 
    AND LG-CORR.CodDoc = "O/C" 
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE LG-CORR THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
    DO WITH FRAME {&FRAME-NAME}:
    FOR EACH LG-CREQU WHERE LG-CREQU.NroReq = p-NroRef. 
        DISPLAY p-NroRef   @ ImCOCmp.NroReq WITH FRAME {&FRAME-NAME}.
    END.
    RUN Carga-Temporal.
    DISPLAY
        TODAY                 @ ImCOCmp.FchDoc
        S-USER-ID             @ ImCOCmp.Userid-com
        STRING(TIME, "HH:MM") @ ImCOCmp.Hora
        LG-CORR.NroImp        @ ImCOCmp.NroImp.  
    DISPLAY 
        YEAR(TODAY) @ ImCOCmp.Periodo WITH FRAME {&FRAME-NAME}.
    ImCOCmp.FlgEst[1]:SCREEN-VALUE = ENTRY(1,ImCOCmp.FlgEst[1]:LIST-ITEMS).
    IF ImCOCmp.FlgEst[1]:SCREEN-VALUE = "CFR" THEN DO:
        ImCOCmp.ImpCfr:LABEL = 'CFR'.
        ImCOCmp.ImpFle:SENSITIVE = TRUE.
        ImCOCmp.ImpFle:HIDDEN = FALSE.
        ImCOCmp.ImpCfr:HIDDEN = FALSE.
        F-Seguro:HIDDEN = TRUE.   
    END.

  END.
  RUN Procesa-Handle IN lh_handle ('Pagina2').
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR CONTADOR AS INTEGER INIT 1. 
      
    /* Code placed here will execute PRIOR to standard behavior. */
    FIND LG-CORR WHERE 
        LG-CORR.codcia = s-codcia AND 
        LG-CORR.coddiv = s-coddiv AND 
        LG-CORR.coddoc = "O/C"
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE LG-CORR THEN DO:
        MESSAGE 'Correlativo No Disponible'
        VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
 
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' THEN DO WITH FRAME {&FRAME-NAME}:  
       IF B-CCMP.FLGSIT = "B" THEN DO:
          ASSIGN B-CREQ.FlgSit = "P".
       END.
       ELSE DO:
           IF B-CCMP.FLGSIT = "F" THEN DO:
               ASSIGN B-CREQ.FlgSit = "T". 
           END.
       END.
       FOR EACH B-CCMP WHERE B-CCMP.PERIODO = INTEGER(IMCOCMP.PERIODO:SCREEN-VALUE)
           BREAK BY B-CCMP.PERIODO:
           CONTADOR = CONTADOR + 1.
       END.
       FIND FIRST B-CREQ WHERE B-CREQ.CodCia = s-CodCia
       AND B-CREQ.NroReq = p-NroRef EXCLUSIVE-LOCK NO-ERROR.
       IF AVAILABLE B-CREQ THEN DO:
             ASSIGN B-CREQ.FlgSit = "O".            
       END.
       ASSIGN
             ImCOCmp.NroImp = LG-CORR.NroImp
             ImCOCmp.codcia = s-codcia
             ImCOCmp.CodDiv = s-coddiv
             ImCOCmp.CodDoc = "O/C"
             ImCOCmp.NroPed = "CO" + "-" +
                     STRING(ImCOCmp.periodo, "9999") + "-" +
                     STRING(Contador, "999") + "-" + ImCOCmp.NroPedPro 
             ImCOCmp.NroReq = integer(ImCOCmp.NroReq:screen-value in frame {&FRAME-NAME})
             ImCOCmp.FchDoc = TODAY
             ImCOCmp.Userid-com = S-USER-ID
             ImCOCmp.Hora = STRING(TIME, 'HH:MM')
             ImCOCmp.FlgSit = 'E'      /* Emitido */
             LG-CORR.NroImp = LG-CORR.NroImp + 1
             ImCOCmp.NomPro.
          /*  DISPLAY ImCOCmp.NroImp WITH FRAME {&FRAME-NAME}. */
           /* DISPLAY ImCOCmp.NroReq WITH FRAME {&FRAME-NAME}. */
    END.
    ELSE DO:
            RUN Carga-Temporal2.
            RUN Borra-Detalle.
    END.
    RUN Genera-Detalle.
    RUN Graba-Totales.
    RUN Requerimiento.
    RUN Incoterm.
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
  
  RUN Procesa-Handle IN lh_Handle ("Pagina1").
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
  
    IF LOOKUP(ImCOCmp.FlgSit, "E") = 0 THEN DO:
        MESSAGE "La Orden de Compra no puede ser anulada" SKIP
                "se encuentra " ENTRY(LOOKUP(ImCOCmp.FlgSit,"A,C"),"Anulada,Cerrada")
                VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    ELSE DO:     
         FIND B-CCMP OF ImCOCmp EXCLUSIVE-LOCK NO-ERROR.
         IF AVAILABLE B-CCMP AND B-CCMP.FlgSit = "E" THEN DO:
            FOR EACH ImDOCmp OF ImCOCmp EXCLUSIVE-LOCK
                ON ERROR UNDO, RETURN 'ADM-ERROR'   
                ON STOP UNDO, RETURN 'ADM-ERROR':
                DELETE ImDOCmp.
            END.
            FIND FIRST B-CREQ WHERE B-CREQ.CodCia = ImCOCmp.CodCia AND 
                 B-CREQ.NroReq = ImCOCmp.NroReq EXCLUSIVE-LOCK NO-ERROR.
                 IF AVAILABLE B-CREQ THEN DO:
                    ASSIGN B-CREQ.FlgSit = "A".            
                 END.
            ASSIGN
                B-CCMP.FlgSit = "A"
                B-CCMP.Userid-com = S-USER-ID.      
         END.
         RELEASE B-CCMP.
         FIND CURRENT ImCOCmp NO-LOCK NO-ERROR.
    END.
    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
    RUN Procesa-Handle IN lh_Handle ('Pagina1').  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE Seg  AS DECIMAL.
  DEFINE VARIABLE tem  AS DECIMAL.
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  IF AVAILABLE ImCOCmp THEN DO WITH FRAME {&FRAME-NAME}:   
     
     CASE ImCOCmp.FlgSit:
        WHEN "E" THEN DISPLAY "Emitida"   @ F-SitDoc WITH FRAME {&FRAME-NAME}.
        WHEN "A" THEN DISPLAY "Anulada"   @ F-SitDoc WITH FRAME {&FRAME-NAME}.
        WHEN "C" THEN DISPLAY "Cerrrada"  @ F-SitDoc WITH FRAME {&FRAME-NAME}.
        WHEN "F" THEN DISPLAY "Facturada" @ F-SitDoc WITH FRAME {&FRAME-NAME}.
      END CASE.   
     F-RucPro:SCREEN-VALUE = "".
     FIND gn-prov WHERE 
          gn-prov.CodCia = PV-CODCIA AND 
          gn-prov.CodPro = ImCOCmp.CodPro 
          NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN
        F-RucPro:screen-value = gn-prov.Ruc.
     F-Productor:SCREEN-VALUE = "".
     FIND gn-prov WHERE 
          gn-prov.CodCia = PV-CODCIA AND 
          gn-prov.CodPro = ImCOCmp.CodPrd 
          NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN
        F-Productor:screen-value = gn-prov.NomPro. 
     F-Represent:SCREEN-VALUE = "".
     FIND gn-prov WHERE 
          gn-prov.CodCia = PV-CODCIA AND 
          gn-prov.CodPro = ImCOCmp.CodRep 
          NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN
        F-Represent:screen-value = gn-prov.NomPro.
     F-DesCnd:SCREEN-VALUE = "".  
     FIND gn-concp WHERE 
          gn-concp.Codig = ImCOCmp.CndCmp 
          NO-LOCK NO-ERROR.
     IF AVAILABLE gn-concp THEN 
        F-DesCnd:SCREEN-VALUE = Gn-ConCp.Nombr.           
     F-Pais:SCREEN-VALUE = "".
     FIND AlmTabla WHERE 
          AlmTabla.Tabla = "PA" AND 
          AlmTabla.Codigo = ImCOCmp.pais:SCREEN-VALUE 
          NO-LOCK NO-ERROR.
     IF AVAILABLE AlmTabla THEN
        F-Pais:screen-value = AlmTabla.Nombre. 
     F-Moneda:SCREEN-VALUE = "".
     FIND AlmTabla WHERE 
          AlmTabla.Tabla = "MO" AND 
          AlmTabla.Codigo = ImCOCmp.Moneda:SCREEN-VALUE 
          NO-LOCK NO-ERROR.
     IF AVAILABLE AlmTabla THEN
        F-Moneda:screen-value = AlmTabla.Nombre. 
     F-Banco:SCREEN-VALUE = "".
     FIND AlmTabla WHERE 
          AlmTabla.Tabla = "BN" AND 
          AlmTabla.Codigo = ImCOCmp.CodBco:SCREEN-VALUE 
          NO-LOCK NO-ERROR.
     IF AVAILABLE AlmTabla THEN
        F-Banco:screen-value = AlmTabla.Nombre.
     F-Carga:SCREEN-VALUE = "".
     FIND AlmTabla WHERE 
          AlmTabla.Tabla = "CA" AND 
          AlmTabla.Codigo = ImCOCmp.Carga:SCREEN-VALUE 
          NO-LOCK NO-ERROR.
     IF AVAILABLE AlmTabla THEN
        F-Carga:screen-value = AlmTabla.Nombre.

    ImCOCmp.ImpCfr:LABEL = 'CFR'.
    ImCOCmp.ImpFle:HIDDEN = FALSE.
    DISPLAY ImCOCmp.ImpFle.
    DISPLAY ImCOCmp.ImpCfr.
    ImCOCmp.ImpCfr:HIDDEN = FALSE.
    F-Seguro:HIDDEN = TRUE.
   
    IF ImCOCmp.FlgEst[1]:SCREEN-VALUE = "CFR" THEN DO:
        ImCOCmp.ImpCfr:LABEL = 'CFR'.
        ImCOCmp.ImpFle:HIDDEN = FALSE.
        ImCOCmp.ImpCfr:HIDDEN = FALSE.
        F-Seguro:HIDDEN = TRUE.    
    END.

    CASE ImCOCmp.FlgEst[1]:SCREEN-VALUE:
        WHEN "FOB" THEN DO:
            ImCOCmp.ImpFle:HIDDEN = TRUE.
            ImCOCmp.ImpCfr:HIDDEN = TRUE.
        END.
        WHEN "CIF" THEN DO: 
            ImCOCmp.ImpCfr:LABEL = 'CIF'.
            F-Seguro:HIDDEN = FALSE.
            F-Seguro:SENSITIVE = FALSE.
        END.
    END CASE.
    IF ImCOCmp.FlgEst[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "CIF" THEN DO: 
         DISPLAY ImCOCmp.ImpCfr WITH FRAME {&FRAME-NAME}.
         tem = ImCOCmp.ImpFob + ImCOCmp.ImpFle. 
         Seg = ImCOCmp.ImpTot - tem.
         ASSIGN F-Seguro = Seg.
         DISPLAY Seg @ F-Seguro WITH FRAME {&FRAME-NAME}.
         
    END.
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
  DEF VAR I AS INTEGER.
  DEF VAR x-Ok AS LOG NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  SYSTEM-DIALOG PRINTER-SETUP UPDATE x-Ok.
  IF x-Ok = NO THEN RETURN.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */ 

  IF ImCOCmp.FlgSit <> "A" THEN RUN IMP\r-pedimp(ROWID(ImCOCmp), ImCOCmp.CODDOC, ImCOCmp.NROIMP).

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


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    
    DO WITH FRAME {&FRAME-NAME}:
        
        FOR EACH Lg-Tabla NO-LOCK WHERE
            Lg-Tabla.codcia = s-codcia AND
            Lg-Tabla.Tabla = '01':
            ImCOCmp.FlgEst[1]:ADD-LAST(lg-tabla.Codigo).
        END.
        ImCOCmp.FlgEst[1]:SCREEN-VALUE = ENTRY(1,ImCOCmp.FlgEst[1]:LIST-ITEMS).
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
  
  RUN Procesa-Handle IN lh_Handle ("Pagina1").
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
    input-var-1 = "".
    CASE HANDLE-CAMPO:name:
        WHEN "CndCmp" THEN ASSIGN input-var-1 = "" /*"20"*/.
        

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Requerimiento V-table-Win 
PROCEDURE Requerimiento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VAR cont AS INTEGER INIT 0 NO-UNDO.
   MESSAGE ImCOcmp.NroReq VIEW-AS ALERT-BOX.
   FOR EACH Lg-Crequ NO-LOCK WHERE Lg-CRequ.Codcia = s-codcia 
       AND Lg-CRequ.NroReq =  ImCOcmp.NroReq,
       EACH Lg-DRequ NO-LOCK WHERE Lg-DRequ.CodCia = Lg-CRequ.Codcia
       AND Lg-DRequ.NroReq = Lg-CRequ.NroReq BREAK BY Lg-DRequ.CodMat:
           
       FOR EACH B-CCMP WHERE B-CCMP.NroReq = ImCOcmp.NroReq NO-LOCK,
           EACH B-DCMP WHERE B-DCMP.NroImp = B-CCMP.NroImp
           BREAK BY B-DCMP.CodMat:
             ACCUMULATE B-DCMP.canpedi (SUB-TOTAL BY B-DCMP.CodMat).     
             MESSAGE B-DCMP.CodMat SKIP ACCUM SUB-TOTAL BY B-DCMP.CodMat B-DCMP.canpedi VIEW-AS ALERT-BOX. 
             IF Lg-DRequ.CanApro = ACCUM SUB-TOTAL BY B-DCMP.CodMat B-DCMP.canpedi THEN DO:
                cont = cont + 1.
             END.
       END.
       IF cont > 0 THEN DO:
          ASSIGN lg-CRequ.FlgSit = 'O'.
          MESSAGE "completo" VIEW-AS ALERT-BOX.
       END.
       ELSE do:
           ASSIGN lg-CRequ.FlgSit = 'A'.
           MESSAGE "aceptada" VIEW-AS ALERT-BOX.
       END.
   END.
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
  {src/adm/template/snd-list.i "ImCOCmp"}

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
  
  /*IF p-state = 'update-begin':U THEN DO WITH FRAME {&FRAME-NAME}:
 *      Im-CREA = NO.
 *      RUN Actualiza-DCMP.
 *      RUN Procesa-Handle IN lh_Handle ("Pagina2").
 *      RUN Procesa-Handle IN lh_Handle ('Browse').
  END.*/
  
  
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
    DEFINE VARIABLE Cfr   AS DECIMAL.
    DEFINE VARIABLE F-Tot AS DECIMAL NO-UNDO.
    DEFINE VARIABLE Cfr1  AS DECIMAL.

DO WITH FRAME {&FRAME-NAME} :   
   IF ImCocmp.Periodo:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Ingrese el Periodo" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO ImCocmp.Periodo.
      RETURN "ADM-ERROR".   
   END.
   IF ImCocmp.CodPro:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de proveedor no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO ImCocmp.CodPro.
      RETURN "ADM-ERROR".   
   END.
   IF ImCocmp.CodPrd:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de productor no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO ImCocmp.CodPrd.
      RETURN "ADM-ERROR".   
   END.
   IF ImCocmp.Pais:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de pais no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO ImCocmp.Pais.
      RETURN "ADM-ERROR".   
   END.
   IF ImCocmp.NroPedPro:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Ingrese el Nro de Pedido del Proveedor" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO ImCocmp.NroPedPro.
      RETURN "ADM-ERROR".   
   END.
   IF ImCocmp.Moneda:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de moneda no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO ImCocmp.Moneda.
      RETURN "ADM-ERROR".   
   END.
   IF ImCOCmp.CndCmp:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Condicion de Compra no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO ImCOCmp.CndCmp.
      RETURN "ADM-ERROR".         
   END.  
   IF ImCocmp.Carga:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Ingrese el Codigo de Carga" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO ImCocmp.Carga.
      RETURN "ADM-ERROR".   
   END.
   FIND gn-prov WHERE gn-prov.CodCia = PV-CODCIA 
                 AND  gn-prov.CodPro = ImCocmp.CodPro:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-prov THEN DO:
      MESSAGE "Proveedor no Registrado" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO ImCocmp.CodPro.
      RETURN "ADM-ERROR".
   END.
   F-Tot = 0.
   FOR EACH DCMP NO-LOCK BREAK BY CODMAT:
       F-Tot = F-Tot + DCMP.ImpTot.
   END.
   IF ImCOCmp.FlgEst[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "CFR" THEN DO: 
        
        IF DECIMAL(ImCocmp.ImpFob:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = 0 THEN DO:
             MESSAGE "El valor FOB debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO ImCocmp.ImpFob.
             RETURN "ADM-ERROR". 
        END.
        IF DECIMAL(ImCocmp.ImpFle:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = 0 THEN DO:
             MESSAGE "El valor de Flete debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO ImCocmp.ImpFle.
             RETURN "ADM-ERROR". 
        END.
        Cfr = DECIMAL(ImCocmp.ImpFob:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + DECIMAL(ImCocmp.ImpFle:SCREEN-VALUE IN FRAME {&FRAME-NAME}). 
        IF F-Tot <> Cfr THEN DO: 
             MESSAGE "Verifique que el valor Cfr sea: CFR = FOB + Flete" VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO ImCocmp.ImpFob.
             RETURN "ADM-ERROR". 
        END.
   END.
   IF ImCOCmp.FlgEst[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "CIF" THEN DO: 
        
         IF DECIMAL(ImCocmp.ImpFob:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = 0 THEN DO:
             MESSAGE "El valor FOB debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO ImCocmp.ImpFob.
             RETURN "ADM-ERROR". 
         END.
         IF DECIMAL(ImCocmp.ImpFle:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = 0 THEN DO:
             MESSAGE "El valor de Flete debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO ImCocmp.ImpFle.
             RETURN "ADM-ERROR". 
         END.
         Cfr1 = DECIMAL(ImCocmp.ImpFob:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + DECIMAL(ImCocmp.ImpFle:SCREEN-VALUE IN FRAME {&FRAME-NAME}). 
         IF  Cfr1 > F-Tot OR Cfr1 = F-Tot THEN DO: 
             MESSAGE "Se debe cumplir que: CIF = FOB + Flete + Seguro" VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO ImCocmp.ImpFob.
             RETURN "ADM-ERROR".
         END.   
   END.
   IF F-Tot = 0 THEN DO:
      MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".   
   END.  
   FIND Lg-Tabla WHERE Lg-Tabla.CodCia = s-CodCia
        AND Lg-Tabla.Tabla = '01'
        AND Lg-Tabla.Codigo = ImCOCmp.FlgEst[1]:SCREEN-VALUE
        NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Lg-Tabla THEN DO:
      MESSAGE "INCOTERM no valido" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO ImCOCmp.FlgEst[1].
      RETURN "ADM-ERROR".         
   END. 
   IF ImCocmp.VERSION:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Ingrese la version del Costeo" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO ImCocmp.VERSION.
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
IF NOT AVAILABLE ImCOCmp THEN RETURN "ADM-ERROR".
IF LOOKUP(ImCOCmp.FlgSit, "E") = 0 THEN DO:
    MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.
    RUN Carga-Temporal2.
FIND Lg-tabla WHERE Lg-tabla.codcia = s-codcia
    AND Lg-tabla.tabla = '01'
    AND Lg-tabla.codigo = ImCOCmp.FlgEst[1]
    NO-LOCK NO-ERROR.
  
   RUN Procesa-Handle IN lh_handle ('Pagina2').  

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

