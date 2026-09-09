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

DEFINE SHARED TEMP-TABLE DCMP LIKE ImDOCmp.
/*DEFINE BUFFER B-CCMP FOR ImCOCmp.*/
/*DEFINE VARIABLE Im-CREA   AS LOGICAL NO-UNDO.*/
DEFINE SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE SHARED VARIABLE S-NROSER  AS INTEGER.
DEFINE SHARED VARIABLE S-PROVEE  AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
DEFINE SHARED VARIABLE S-PORCFR  AS DEC.
DEFINE SHARED VARIABLE S-TPOCMB  AS DECIMAL.
DEFINE SHARED VARIABLE S-IMPCFR  AS DECIMAL.

/*
 * DEFINE SHARED VARIABLE S-CODMON  AS INTEGER.
 * DEFINE SHARED VARIABLE S-TPODOC AS CHAR.
 * 
 * */
/*DEFINE VARIABLE F-FACTOR     AS DECIMAL   NO-UNDO.
 * 
 * DEFINE VARIABLE X-TIPO AS CHAR INIT "CC".
 * DEFINE VARIABLE s-Control-Compras AS LOG NO-UNDO.   /* Control de 7 dias */
 * 
 * 
 * */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES ImCOCmp
&Scoped-define FIRST-EXTERNAL-TABLE ImCOCmp


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ImCOCmp.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ImCOCmp.Periodo ImCOCmp.CodPro ImCOCmp.Pais ~
ImCOCmp.NroPedPro ImCOCmp.FlgEst[1] ImCOCmp.Moneda ImCOCmp.CndCmp ~
ImCOCmp.CodBco ImCOCmp.Observaciones ImCOCmp.FchProd ImCOCmp.TpoCmb ~
ImCOCmp.NroCreDoc ImCOCmp.ImpFob ImCOCmp.ImpFle 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}Periodo ~{&FP2}Periodo ~{&FP3}~
 ~{&FP1}CodPro ~{&FP2}CodPro ~{&FP3}~
 ~{&FP1}Pais ~{&FP2}Pais ~{&FP3}~
 ~{&FP1}NroPedPro ~{&FP2}NroPedPro ~{&FP3}~
 ~{&FP1}Moneda ~{&FP2}Moneda ~{&FP3}~
 ~{&FP1}CndCmp ~{&FP2}CndCmp ~{&FP3}~
 ~{&FP1}CodBco ~{&FP2}CodBco ~{&FP3}~
 ~{&FP1}FchProd ~{&FP2}FchProd ~{&FP3}~
 ~{&FP1}TpoCmb ~{&FP2}TpoCmb ~{&FP3}~
 ~{&FP1}NroCreDoc ~{&FP2}NroCreDoc ~{&FP3}~
 ~{&FP1}ImpFob ~{&FP2}ImpFob ~{&FP3}~
 ~{&FP1}ImpFle ~{&FP2}ImpFle ~{&FP3}
&Scoped-define ENABLED-TABLES ImCOCmp
&Scoped-define FIRST-ENABLED-TABLE ImCOCmp
&Scoped-Define ENABLED-OBJECTS RECT-24 
&Scoped-Define DISPLAYED-FIELDS ImCOCmp.Periodo ImCOCmp.NroPed ~
ImCOCmp.CodPro ImCOCmp.Pais ImCOCmp.NroPedPro ImCOCmp.FlgEst[1] ~
ImCOCmp.Moneda ImCOCmp.CndCmp ImCOCmp.CodBco ImCOCmp.Observaciones ~
ImCOCmp.NomPro ImCOCmp.NroImp ImCOCmp.Fchdoc ImCOCmp.Hora ~
ImCOCmp.Userid-com ImCOCmp.FchProd ImCOCmp.TpoCmb ImCOCmp.NroCreDoc ~
ImCOCmp.ImpFob ImCOCmp.ImpFle ImCOCmp.ImpCfr ImCOCmp.FlgSit 
&Scoped-Define DISPLAYED-OBJECTS F-Pais F-Moneda F-DesCnd F-Banco F-RucPro ~
F-SitDoc 

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
     SIZE 43 BY .81 NO-UNDO.

DEFINE VARIABLE F-DesCnd AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE VARIABLE F-Moneda AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE F-Pais AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE F-RucPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 18.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-SitDoc AS CHARACTER FORMAT "X(256)":U INITIAL "Emitido" 
     LABEL "Situacion" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 93 BY 8.85.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     ImCOCmp.Periodo AT ROW 1.12 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     ImCOCmp.NroPed AT ROW 1.88 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22 BY .81
     ImCOCmp.CodPro AT ROW 2.69 COL 16 COLON-ALIGNED NO-LABEL FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     ImCOCmp.Pais AT ROW 3.5 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     ImCOCmp.NroPedPro AT ROW 4.27 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
     ImCOCmp.FlgEst[1] AT ROW 5.04 COL 16 COLON-ALIGNED
          LABEL "INCOTERM"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS " "
          SIZE 14 BY 1
     ImCOCmp.Moneda AT ROW 5.81 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     ImCOCmp.CndCmp AT ROW 6.58 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     ImCOCmp.CodBco AT ROW 7.35 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     ImCOCmp.Observaciones AT ROW 8.12 COL 18 NO-LABEL
          VIEW-AS EDITOR
          SIZE 48 BY 1.54
     F-Pais AT ROW 3.5 COL 21 COLON-ALIGNED NO-LABEL
     F-Moneda AT ROW 5.81 COL 21 COLON-ALIGNED NO-LABEL
     F-DesCnd AT ROW 6.58 COL 21 COLON-ALIGNED NO-LABEL
     F-Banco AT ROW 7.35 COL 21 COLON-ALIGNED NO-LABEL
     ImCOCmp.NomPro AT ROW 2.69 COL 25.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 40 BY .81
     ImCOCmp.NroImp AT ROW 1.12 COL 39 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-RucPro AT ROW 3.5 COL 47 COLON-ALIGNED NO-LABEL
     F-SitDoc AT ROW 1.19 COL 78 COLON-ALIGNED
     ImCOCmp.Fchdoc AT ROW 1.96 COL 78 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.Hora AT ROW 2.73 COL 78 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.Userid-com AT ROW 3.5 COL 78 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.FchProd AT ROW 4.65 COL 78 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.TpoCmb AT ROW 5.42 COL 78 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.NroCreDoc AT ROW 6.19 COL 78 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     ImCOCmp.ImpFob AT ROW 7.35 COL 78 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     ImCOCmp.ImpFle AT ROW 8.12 COL 78 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     ImCOCmp.ImpCfr AT ROW 8.88 COL 78 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     ImCOCmp.FlgSit AT ROW 1.19 COL 89 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 2.14 BY .81
     "Proveedor:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 2.88 COL 10
     "R.U.C.:" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 3.69 COL 44
     "Observaciones:" VIEW-AS TEXT
          SIZE 11 BY .5 AT ROW 8.31 COL 7
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 8.85
         WIDTH              = 93.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN ImCOCmp.CodPro IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN F-Banco IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesCnd IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Moneda IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Pais IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-RucPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-SitDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCOCmp.Fchdoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX ImCOCmp.FlgEst[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ImCOCmp.FlgSit IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCOCmp.Hora IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCOCmp.ImpCfr IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCOCmp.NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCOCmp.NroImp IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCOCmp.NroPed IN FRAME F-Main
   NO-ENABLE                                                            */
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME ImCOCmp.CndCmp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCOCmp.CndCmp V-table-Win
ON LEAVE OF ImCOCmp.CndCmp IN FRAME F-Main /* Forma Pago */
DO:
  IF ImCOCmp.CndCmp:SCREEN-VALUE <> "" THEN DO:
     F-DesCnd:SCREEN-VALUE = "".
     FIND gn-concp WHERE gn-concp.Codig = ImCOCmp.CndCmp:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE gn-concp THEN F-DesCnd:SCREEN-VALUE = gn-concp.Nombr.
        DISPLAY gn-concp.Nombr @ F-DesCnd WITH FRAME {&FRAME-NAME}.
  END.   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ImCOCmp.CodBco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCOCmp.CodBco V-table-Win
ON LEAVE OF ImCOCmp.CodBco IN FRAME F-Main /* Banco */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
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


&Scoped-define SELF-NAME ImCOCmp.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCOCmp.CodPro V-table-Win
ON LEAVE OF ImCOCmp.CodPro IN FRAME F-Main /* C¢digo */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-prov WHERE 
       gn-prov.CodCia = 0 AND
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
  S-PROVEE = ImCocmp.CodPro:SCREEN-VALUE.
  APPLY "ENTRY":U TO ImCOCmp.Fchdoc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ImCOCmp.Fchdoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCOCmp.Fchdoc V-table-Win
ON LEAVE OF ImCOCmp.Fchdoc IN FRAME F-Main /* Fecha Emision */
DO:
  IF INPUT ImCOCmp.Fchdoc = ? THEN RETURN.
  FIND LAST gn-tcmb WHERE gn-tcmb.FECHA <= INPUT ImCOCmp.Fchdoc NO-LOCK NO-ERROR.
  IF AVAILABLE gn-tcmb THEN DO:
     DISPLAY gn-tcmb.compra @ ImCOCmp.TpoCmb WITH FRAME {&FRAME-NAME}.
     S-TPOCMB = gn-tcmb.compra.
  END.
  ELSE MESSAGE "Tipo de cambio no registrado" VIEW-AS ALERT-BOX WARNING.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ImCOCmp.FlgEst[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCOCmp.FlgEst[1] V-table-Win
ON VALUE-CHANGED OF ImCOCmp.FlgEst[1] IN FRAME F-Main /* INCOTERM */
DO:
    S-PORCFR = 0.
    FIND Lg-tabla WHERE Lg-tabla.codcia = s-codcia
        AND Lg-tabla.tabla = '01'
        AND Lg-tabla.codigo = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE Lg-tabla THEN s-PorCfr = lg-tabla.Valor[1].
    /******************************FOB********************************/
    MESSAGE ImCOCmp.FlgEst[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME} VIEW-AS ALERT-BOX.
    IF ImCOCmp.FlgEst[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "FOB" THEN DO: 
        /*HIDE ImCOCmp.ImpFle.*/
        ImCOCmp.ImpFle:HIDDEN = TRUE.
        ImCOCmp.ImpCfr:HIDDEN = TRUE.

    END.
    ELSE DO: 
        ImCOCmp.ImpFle:HIDDEN = FALSE.
        ImCOCmp.ImpCfr:HIDDEN = FALSE.
    END.
    /******************************CIF********************************/
    /*IF ImCOCmp.FlgEst[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "CIF" THEN DO: 
 *         IF DECIMAL(ImCocmp.ImpFob:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = 0 THEN DO:
 *             MESSAGE "El valor FOB debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
 *             APPLY "ENTRY":U TO ImCocmp.ImpFob.
 *             RETURN "ADM-ERROR". 
 *         END.
 *         IF DECIMAL(ImCocmp.ImpFle:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = 0 THEN DO:
 *             MESSAGE "El valor de Flete debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
 *             APPLY "ENTRY":U TO ImCocmp.ImpFle.
 *             RETURN "ADM-ERROR". 
 *         END.
 *         Cfr1 = ImCocmp.ImpFob + ImCocmp.ImpFle.
 *         ASSIGN ImCOCmp.ImpCfr = Cfr1. 
 *         IF DECIMAL(ImCocmp.ImpCfr:SCREEN-VALUE IN FRAME {&FRAME-NAME}) < ImDOCmp.ImpTot THEN DO:
 *             DISPLAY ImCOCmp.ImpCfr WITH FRAME {&FRAME-NAME}.
 *         END.  
 *         ELSE DO:
 *             MESSAGE "El valor CFR debe ser menor al Importe Total" VIEW-AS ALERT-BOX ERROR.
 *             APPLY "ENTRY":U TO ImCocmp.ImpFob.
 *             RETURN "ADM-ERROR". 
 *         END.
 *     END.*/


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ImCOCmp.ImpCfr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCOCmp.ImpCfr V-table-Win
ON LEAVE OF ImCOCmp.ImpCfr IN FRAME F-Main /* CFR */
DO:
/*  ASSIGN ImCOCmp.ImpCfr.*/
/*  S-IMPCFR = ImCOCmp.ImpCfr.*/
  
  ASSIGN 
       ImCOCmp.ImpFob = DECIMAL(ImCocmp.ImpFob:SCREEN-VALUE IN FRAME {&FRAME-NAME})
       ImCOCmp.ImpFle = DECIMAL(ImCocmp.ImpFle:SCREEN-VALUE IN FRAME {&FRAME-NAME})
       ImCOCmp.ImpCfr = DECIMAL(ImCocmp.ImpFle:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
       
  FOR EACH ImCOCmp:
       ImCOCmp.ImpCfr = ImCOCmp.ImpFob + ImCOCmp.ImpFle.
  END.
/*  IF ImCOCmp.ImpFle = 0 THEN DO:
 *        ImCOCmp.ImpCfr = ImCOCmp.ImpFob.
 *   END.*/
  DISPLAY ImCOCmp.ImpCfr.

/*DISPLAY 
 *        ImCOCmp.ImpFob = 0
 *        ImCOCmp.ImpFle = 0
 *        ImCOCmp.ImpCfr = 0
 *        WITH FRAME {&FRAME-NAME}.*/

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
 /* IF gn-prov.flgsit = 'C' THEN DO:
 *     MESSAGE 'Proveedor CESADO' VIEW-AS ALERT-BOX ERROR.
 *     RETURN NO-APPLY.
 *   END.
 *   S-PROVEE = ImCocmp.CodPro:SCREEN-VALUE.
 *   APPLY "ENTRY":U TO ImCOCmp.Fchdoc.*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ImCOCmp.TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCOCmp.TpoCmb V-table-Win
ON LEAVE OF ImCOCmp.TpoCmb IN FRAME F-Main /* Tipo de cambio */
DO:
  S-TPOCMB = DECIMAL(SELF:SCREEN-VALUE).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-DCMP V-table-Win 
PROCEDURE Actualiza-DCMP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*FOR EACH DCMP:
 *     DELETE DCMP.
 * END.
 * IF NOT Im-CREA THEN DO:
 *    FOR EACH ImDOCmp NO-LOCK WHERE ImDOCmp.CodCia = ImCOCmp.CodCia 
 *                     AND  ImDOCmp.NroImp = ImCOCmp.NroImp:
 *        CREATE DCMP.
 *        BUFFER-COPY ImDOCmp TO DCMP.
 *    END.
 * END.
 * */
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
  FOR EACH ImDOCmp USE-INDEX Llave01 OF ImCOCmp NO-LOCK: 
    CREATE DCMP.
    BUFFER-COPY ImDOCmp TO DCMP.
  END. 
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
            ImDOCmp.CodCia = ImCOCmp.CodCia 
            ImDOCmp.Coddoc = ImCOCmp.Coddoc
            ImDOCmp.NroImp = ImCOCmp.NroImp.        
    RELEASE ImDOCmp.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Orden-Compra V-table-Win 
PROCEDURE Genera-Orden-Compra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  

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
DEFINE VARIABLE Cfr   AS DECIMAL.
DEFINE VARIABLE Cfr1  AS DECIMAL.

/*  ImCOCmp.ImpCfr = ImCOCmp.ImpFob + ImCOCmp.ImpFob.
    CASE ImCOCmp.FlgEst[1]: 
        WHEN "FOB" THEN DO: 
            DISPLAY ImCOCmp.ImpFob WITH FRAME {&FRAME-NAME}.
            ASSIGN ImCOCmp.ImpFob = ImCOCmp.ImpTot. 
        END.
        WHEN "CFR" THEN DO: 
            DISPLAY ImCOCmp.ImpCfr WITH FRAME {&FRAME-NAME}.
            ASSIGN ImCOCmp.ImpCfr = ImCOCmp.ImpTot.
        END.
        WHEN "CIF" THEN DO:      
            IF ImCOCmp.ImpCfr < ImCOCmp.ImpTot THEN DO:
                DISPLAY ImCOCmp.ImpCfr WITH FRAME {&FRAME-NAME}.
            END.
        END.
    END CASE.
*/
    ASSIGN
        ImCOCmp.ImpTot = 0
        ImCOCmp.ImpCfr = 0.
    FOR EACH ImDOCmp OF ImCOCmp NO-LOCK:
        ImCOCmp.ImpTot = ImCOCmp.ImpTot + ImDOCmp.ImpTot.
        /************************CFR**********************************/
        /*IF ImCOCmp.FlgEst[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "CFR" THEN DO: 
 *             ASSIGN ImCOCmp.ImpCfr = ImDOCmp.ImpTot.
 *             DISPLAY ImCOCmp.ImpCfr WITH FRAME {&FRAME-NAME}.
 *             IF DECIMAL(ImCocmp.ImpFob:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = 0 THEN DO:
 *                 MESSAGE "El valor FOB debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
 *                 APPLY "ENTRY":U TO ImCocmp.ImpFob.
 *                 RETURN "ADM-ERROR". 
 *             END.
 *             IF DECIMAL(ImCocmp.ImpFle:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = 0 THEN DO:
 *                 MESSAGE "El valor de Flete debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
 *                 APPLY "ENTRY":U TO ImCocmp.ImpFle.
 *                 RETURN "ADM-ERROR". 
 *             END.
 *             Cfr = ImCocmp.ImpFob + ImCocmp.ImpFle. 
 *             IF DECIMAL(ImCOCmp.ImpCfr:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = Cfr THEN DO: 
 *                 DISPLAY ImCOCmp.ImpCfr WITH FRAME {&FRAME-NAME}.
 *             END.
 *             ELSE DO:
 *                 MESSAGE "Verifique que el valor Cfr sea: CFR = FOB + Flete" VIEW-AS ALERT-BOX ERROR.
 *                 APPLY "ENTRY":U TO ImCocmp.ImpFob.
 *                 RETURN "ADM-ERROR". 
 *             END.
 *             DISPLAY ImCOCmp.ImpCfr
 *                 ImCOCmp.ImpFle  
 *                 ImCOCmp.ImpFob WITH FRAME {&FRAME-NAME}.  
 *             END.
 *          END.*/
        /************************FOB****************************/ 
        IF ImCOCmp.FlgEst[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "FOB" THEN DO: 
            ASSIGN ImCOCmp.ImpFob = ImDOCmp.ImpTot. 
            /*ASSIGN ImCOCmp.ImpCfr = ImDOCmp.ImpTot.*/ 
            DISPLAY ImCOCmp.ImpFob WITH FRAME {&FRAME-NAME}.
        END.
        /******************************CIF********************************/
        IF ImCOCmp.FlgEst[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "CIF" THEN DO: 
            ASSIGN ImCOCmp.ImpCfr = ImDOCmp.ImpTot. 
            IF DECIMAL(ImCocmp.ImpFob:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = 0 THEN DO:
                MESSAGE "El valor FOB debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
                APPLY "ENTRY":U TO ImCocmp.ImpFob.
                RETURN "ADM-ERROR". 
            END.
            IF DECIMAL(ImCocmp.ImpFle:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = 0 THEN DO:
                MESSAGE "El valor de Flete debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
                APPLY "ENTRY":U TO ImCocmp.ImpFle.
                RETURN "ADM-ERROR". 
            END.
            Cfr1 = ImCocmp.ImpFob + ImCocmp.ImpFle.
            IF DECIMAL(ImCocmp.ImpCfr:SCREEN-VALUE IN FRAME {&FRAME-NAME}) < ImDOCmp.ImpTot THEN DO: 
                DISPLAY ImCOCmp.ImpCfr WITH FRAME {&FRAME-NAME}.
            END.  
            ELSE DO:
                MESSAGE "El valor CFR debe ser menor al Importe Total" VIEW-AS ALERT-BOX ERROR.
                APPLY "ENTRY":U TO ImCocmp.ImpFob.
                RETURN "ADM-ERROR". 
            END.
        END.
/*        ImCOCmp.ImpCfr = ImCOCmp.ImpCfr + ImDOCmp.ImpTot.*/
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
 DEFINE VARIABLE P-NROREF LIKE ImCOCmp.NroImp.
  /* Code placed here will execute PRIOR to standard behavior. */
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
    DISPLAY
       /*"CO" + STRING(ImCOCmp.periodo, "9999") + "001" + 
 *         ImCOCmp.NroPedPro        @ ImCOCmp.NroPed*/
        TODAY                    @ ImCOCmp.FchDoc
        S-USER-ID                @ ImCOCmp.Userid-com
        STRING(TIME, "HH:MM")    @ ImCOCmp.Hora.
        
    RUN Borra-Temporal.
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

  /* Code placed here will execute PRIOR to standard behavior. */

    DEFINE VARIABLE X-NRODOC AS INTEGER NO-UNDO.
    DEFINE VARIABLE f-ImpTot AS DEC NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' THEN DO WITH FRAME {&FRAME-NAME}:
        FIND LG-CORR WHERE 
            LG-CORR.codcia = s-codcia AND 
            LG-CORR.coddiv = s-coddiv AND 
            LG-CORR.coddoc = "O/C"
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE LG-CORR THEN DO:
            MESSAGE
                'Correlativo No Disponible'
                VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            ImCOCmp.nroimp = LG-CORR.NroImp
            ImCOCmp.codcia = s-codcia
            ImCOCmp.CodDiv = s-coddiv
            ImCOCmp.CodDoc = "O/C"
            ImCOCmp.NroPed = "CO" +
                STRING(ImCOCmp.periodo, "9999") + 
                "001" + ImCOCmp.NroPedPro
            ImCOCmp.FchDoc = TODAY
            ImCOCmp.Userid-com = S-USER-ID
            ImCOCmp.Hora = STRING(TIME, 'HH:MM')
            ImCOCmp.FlgEst = 'E'      /* Emitido */
            LG-CORR.NroImp = LG-CORR.NroImp + 1
            ImCOCmp.NomPro.
        DISPLAY ImCOCmp.nroimp WITH FRAME {&FRAME-NAME}.
        RELEASE LG-CORR.
    END.
    ELSE DO:
        RUN Borra-Detalle.
    END.

    RUN Genera-Detalle.
    RUN Graba-Totales.

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
  
  /*RUN Procesa-Handle IN lh_Handle ('Browse').
    RUN dispatch IN THIS-PROCEDURE ('display-fields':U). */

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
  RUN valida-update.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

  DO TRANSACTION ON STOP UNDO, RETURN 'ADM-ERROR':
    RUN Borra-Detalle.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    FIND CURRENT ImCOCmp EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE ImCOCmp THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN
        ImCOCmp.FlgEst = 'A'.
    FIND CURRENT ImCOCmp NO-LOCK NO-ERROR.
    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  END.

/*
 *   IF ImCOCmp.FlgSit = "A" THEN DO:
 *      MESSAGE "La Orden de Compra ya esta Anulada" VIEW-AS ALERT-BOX ERROR.
 *      RETURN "ADM-ERROR".
 *   END.    
 *   ELSE DO:
 *      IF ImCOCmp.FlgSit = "C" THEN DO:
 *         MESSAGE "La Orden de Compra esta Cerrada" VIEW-AS ALERT-BOX ERROR.
 *         RETURN "ADM-ERROR".
 *      END.
 *      ELSE DO:
 *          FIND CURRENT ImCOCmp EXCLUSIVE-LOCK NO-ERROR.
 *          IF AVAILABLE ImCOCmp AND ImCOCmp.FlgSit = "E" THEN DO:
 *             FIND B-CCMP USE-INDEX Llave01 EXCLUSIVE-LOCK NO-ERROR.
 *             /*FIND B-CCMP USE-INDEX Llave01 OF ImCOCmp  EXCLUSIVE-LOCK NO-ERROR.*/
 *             IF AVAILABLE B-CCMP THEN DO:
 *                ASSIGN B-CCMP.FlgSit = "A"
 *                       B-CCMP.Userid-com = S-USER-ID.
 *                RUN Borra-Detalle.
 *             END.
 *             RELEASE B-CCMP.
 *          END.
 *      END.    
 *   END.
 *   RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
 *   RUN Procesa-Handle IN lh_Handle ('Browse').
 * */

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
  
  IF AVAILABLE ImCOCmp THEN DO WITH FRAME {&FRAME-NAME}:
     CASE ImCOCmp.FlgSit:
        WHEN "E" THEN DISPLAY "Emitido"  @ F-SitDoc WITH FRAME {&FRAME-NAME}.
        WHEN "A" THEN DISPLAY "Anulado"  @ F-SitDoc WITH FRAME {&FRAME-NAME}.
        WHEN "C" THEN DISPLAY "Cerrrado" @ F-SitDoc WITH FRAME {&FRAME-NAME}.
     END CASE.   
     F-RucPro:SCREEN-VALUE = "".
     FIND gn-prov WHERE 
          gn-prov.CodCia = 0 AND 
          gn-prov.CodPro = ImCOCmp.CodPro 
          NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN
        F-RucPro:screen-value = gn-prov.Ruc.
     F-DesCnd:SCREEN-VALUE = "".  
     FIND gn-concp WHERE 
          gn-concp.Codig = ImCOCmp.CndCmp 
          NO-LOCK NO-ERROR.
     IF AVAILABLE gn-concp THEN F-DesCnd:SCREEN-VALUE = Gn-ConCp.Nombr.           
      
  END.
  /* S-PROVEE = ImCOCmp.CodPro.
 *      DISPLAY 
 *           S-USER-ID              @ ImCOCmp.Userid-com
 *           TODAY                  @ ImCOCmp.FchDoc    
 *           STRING(TIME,"HH:MM")   @ ImCOCmp.Hora. 
 *           /*ImCOCmp.NroImp     = LG-CORR.NroImp*/*/
  /*     LG-CORR.NroImp = LG-CORR.NroImp + 1.
  *      DISPLAY LG-CORR.NroImp      @ ImCocmp.NroImp.
         DISPLAY gn-prov.Ruc    @ F-RucPro.         */
 
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
  DEF VAR MENS AS CHARACTER.
  DEF VAR x-Ok AS LOG NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  SYSTEM-DIALOG PRINTER-SETUP UPDATE x-Ok.
  IF x-Ok = NO THEN RETURN.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF LG-COCmp.FlgSit <> "A" THEN RUN lgc\r-impcmp(ROWID(LG-COCmp), MENS). 
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

    DEFINE VARIABLE ind AS INTEGER NO-UNDO.
    DEFINE VARIABLE pto AS INTEGER NO-UNDO.

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
/*  RUN Genera-Detalle.*/

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
DEFINE VARIABLE F-Tot AS DECIMAL.

DO WITH FRAME {&FRAME-NAME} :   
   IF ImCocmp.CodPro:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de proveedor no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO ImCocmp.CodPro.
      RETURN "ADM-ERROR".   
   END.
  /* FIND Gn-Prov WHERE Gn-Prov.CodCia = CL-CODCIA
 *         AND  gn-clie.CodCli = FacCPedi.CodCli:SCREEN-VALUE 
 *         NO-LOCK NO-ERROR.
 *     IF NOT AVAILABLE gn-clie THEN DO:
 *       MESSAGE "Codigo de cliente NO existe" VIEW-AS ALERT-BOX ERROR.
 *       RETURN "ADM-ERROR".
 *     END.*/
   IF ImCocmp.Pais:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de pais no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO ImCocmp.Pais.
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

   FIND gn-prov WHERE gn-prov.CodCia = 0 
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
   IF F-Tot = 0 THEN DO:
      MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".   
   END.  
   
 /*  IF DECIMAL(ImCocmp.ImpFob:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = 0 THEN DO:
 *       MESSAGE "El valor FOB debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
 *       APPLY "ENTRY":U TO ImCocmp.ImpFob.
 *       RETURN "ADM-ERROR". 
 *    END.
 *    IF DECIMAL(ImCocmp.ImpFle:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = 0 THEN DO:
 *       MESSAGE "El valor de Flete debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
 *       APPLY "ENTRY":U TO ImCocmp.ImpFle.
 *       RETURN "ADM-ERROR". 
 *    END.*/
   FIND Lg-Tabla WHERE Lg-Tabla.CodCia = s-CodCia
        AND Lg-Tabla.Tabla = '01'
        AND Lg-Tabla.Codigo = ImCOCmp.FlgEst[1]:SCREEN-VALUE
        NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Lg-Tabla THEN DO:
      MESSAGE "INCOTERM no valido" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO ImCOCmp.FlgEst[1].
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
RUN Carga-Temporal.

  RUN Procesa-Handle IN lh_handle ('Pagina2').
  
  RETURN "OK".

/*S-TPOCMB = ImCOCmp.TpoCmb.*/
/*S-CODMON = LG-COCmp.Codmon.*/
/*S-PORCFR = 0.*/
/*FIND Lg-tabla WHERE Lg-tabla.codcia = s-codcia
 *     AND Lg-tabla.tabla = '01'
 *     AND Lg-tabla.codigo = ImCOCmp.FlgEst[1]
 *     NO-LOCK NO-ERROR.
 * IF AVAILABLE Lg-tabla THEN s-PorCfr = lg-tabla.Valor[1].*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


