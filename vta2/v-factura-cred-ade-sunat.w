&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.



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

DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-TPOFAC   AS CHAR.
DEFINE SHARED VARIABLE CL-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODVEN  AS CHAR.
DEFINE SHARED VARIABLE S-NROSER  AS INTEGER.
DEFINE SHARED VARIABLE S-IMPFLE  AS DECIMAL.
DEFINE SHARED VARIABLE lh_handle AS HANDLE.
DEFINE SHARED VARIABLE s-FmaPgo  AS CHAR.
DEFINE SHARED VARIABLE s-Sunat-Activo AS LOG.
DEFINE SHARED VARIABLE s-CodMat  AS CHAR.

/* Local Variable Definitions ---                                       */
DEF VAR s-cndvta AS CHAR.
DEF VAR s-cndvta-validos AS CHAR.

DEFINE VARIABLE I              AS INTEGER   NO-UNDO.
DEFINE VARIABLE C-NRODOC       AS CHAR      NO-UNDO.
DEFINE VARIABLE C-CODPED       AS CHAR      NO-UNDO.
DEFINE VARIABLE C-NROPED       AS CHAR      NO-UNDO.
DEFINE VARIABLE C-NROGUI       AS CHAR      NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NRODOC       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-ListPr       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE S-CODCLI       AS CHARACTER NO-UNDO. 
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
IF AVAILABLE FacCorre THEN ASSIGN I-NroSer = FacCorre.NroSer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
DEFINE VAR x-ClientesVarios AS CHAR.
x-ClientesVarios = FacCfgGn.CliVar.     /* 11 digitos */

DEF VAR s-FechaI AS DATETIME NO-UNDO.
DEF VAR s-FechaT AS DATETIME NO-UNDO.

s-FechaI = DATETIME(TODAY, MTIME).

DEF VAR pMensaje AS CHAR NO-UNDO.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).

/*  */
DEFINE VAR x-cambiar-fecha AS LOG.
x-cambiar-fecha = NO.

DEFINE VAR z-serie AS CHAR.

DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.

/*  */
DEFINE VAR x-anticipo-campana AS LOG.

x-anticipo-campana = NO.

IF S-TPOFAC = "A" THEN x-anticipo-campana = YES.

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
&Scoped-Define ENABLED-FIELDS CcbCDocu.FchDoc CcbCDocu.Libre_c01 ~
CcbCDocu.FchVto CcbCDocu.CodCli CcbCDocu.RucCli CcbCDocu.CodAnt ~
CcbCDocu.NomCli CcbCDocu.NroOrd CcbCDocu.DirCli CcbCDocu.TpoCmb ~
CcbCDocu.NroCard CcbCDocu.CodVen CcbCDocu.FmaPgo CcbCDocu.Glosa ~
CcbCDocu.CodMon CcbCDocu.ImpTot 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.Libre_c01 CcbCDocu.FchVto CcbCDocu.CodCli CcbCDocu.RucCli ~
CcbCDocu.CodAnt CcbCDocu.usuario CcbCDocu.NomCli CcbCDocu.NroOrd ~
CcbCDocu.DirCli CcbCDocu.TpoCmb CcbCDocu.NroCard CcbCDocu.CodVen ~
CcbCDocu.FmaPgo CcbCDocu.Glosa CcbCDocu.CodMon CcbCDocu.ImpTot ~
CcbCDocu.AcuBon[1] 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS F-Estado FILL-IN-Lista F-Nomtar f-NomVen ~
F-CndVta 

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
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "ESTADO" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE F-Nomtar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE f-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Lista AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.NroDoc AT ROW 1 COL 16 COLON-ALIGNED FORMAT "XXX-XXXXXXXX"
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
          FONT 1
     F-Estado AT ROW 1 COL 40 COLON-ALIGNED
     CcbCDocu.FchDoc AT ROW 1 COL 99 COLON-ALIGNED
          LABEL "Fecha de Emisión"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.Libre_c01 AT ROW 1.81 COL 16 COLON-ALIGNED WIDGET-ID 102
          LABEL "Lista de Precios" FORMAT "x(6)"
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
          BGCOLOR 14 FGCOLOR 0 
     FILL-IN-Lista AT ROW 1.81 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 100
     CcbCDocu.FchVto AT ROW 1.81 COL 99 COLON-ALIGNED
          LABEL "Fecha Vencimiento"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.CodCli AT ROW 2.62 COL 16 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
          BGCOLOR 11 FGCOLOR 0 
     CcbCDocu.RucCli AT ROW 2.62 COL 40 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
          BGCOLOR 11 FGCOLOR 0 
     CcbCDocu.CodAnt AT ROW 2.62 COL 61 COLON-ALIGNED WIDGET-ID 16
          LABEL "DNI" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     CcbCDocu.usuario AT ROW 2.62 COL 99 COLON-ALIGNED WIDGET-ID 18
          LABEL "Digitado por"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.NomCli AT ROW 3.42 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
     CcbCDocu.NroOrd AT ROW 3.42 COL 99 COLON-ALIGNED
          LABEL "Orden de Compra" FORMAT "x(12)"
          VIEW-AS FILL-IN 
          SIZE 17 BY .81
          BGCOLOR 11 FGCOLOR 0 
     CcbCDocu.DirCli AT ROW 4.23 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
     CcbCDocu.TpoCmb AT ROW 4.23 COL 99 COLON-ALIGNED
          LABEL "T/ Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.NroCard AT ROW 5.04 COL 16 COLON-ALIGNED WIDGET-ID 28
          LABEL "Tarjeta"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 FGCOLOR 0 
     F-Nomtar AT ROW 5.04 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 92
     CcbCDocu.CodVen AT ROW 5.85 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
          BGCOLOR 11 FGCOLOR 0 
     f-NomVen AT ROW 5.85 COL 22 COLON-ALIGNED NO-LABEL
     CcbCDocu.FmaPgo AT ROW 6.65 COL 16 COLON-ALIGNED
          LABEL "Condición de Venta"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
          BGCOLOR 11 FGCOLOR 0 
     F-CndVta AT ROW 6.65 COL 22 COLON-ALIGNED NO-LABEL
     CcbCDocu.Glosa AT ROW 7.46 COL 16 COLON-ALIGNED
          LABEL "Glosa"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
          BGCOLOR 11 FGCOLOR 0 
     CcbCDocu.CodMon AT ROW 8.27 COL 18.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 10.72 BY .81
          BGCOLOR 11 FGCOLOR 0 
     CcbCDocu.ImpTot AT ROW 9.08 COL 16 COLON-ALIGNED WIDGET-ID 94
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
          BGCOLOR 1 FGCOLOR 15 FONT 6
     CcbCDocu.AcuBon[1] AT ROW 9.12 COL 47 COLON-ALIGNED WIDGET-ID 96
          LABEL "TASA DE DESCUENTO" FORMAT ">9.99"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
          BGCOLOR 1 FGCOLOR 15 FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "Moneda:" VIEW-AS TEXT
          SIZE 6.43 BY .5 AT ROW 8.54 COL 11
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
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
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
         HEIGHT             = 10.5
         WIDTH              = 118.72.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR FILL-IN CcbCDocu.AcuBon[1] IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.CodAnt IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.CodCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Nomtar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchDoc IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchVto IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Lista IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FmaPgo IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.Glosa IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.Libre_c01 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NroCard IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NroOrd IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.RucCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.TpoCmb IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.usuario IN FRAME F-Main
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
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  RUN vtagn/p-gn-clie-01 (SELF:SCREEN-VALUE, s-CodDoc).
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  s-CodCli = SELF:SCREEN-VALUE.

  /* Cargamos las condiciones de venta válidas */
  FIND gn-clie WHERE gn-clie.codcia  = cl-codcia
      AND gn-clie.codcli = s-codcli
      NO-LOCK.
  RUN vtagn/p-fmapgo-01 (s-codcli, OUTPUT s-cndvta-validos).
  ASSIGN
      S-CNDVTA = ENTRY(1, s-cndvta-validos).
  IF s-FmaPgo > '' AND LOOKUP(s-FmaPgo, s-cndvta-validos) > 0 THEN s-CndVta = s-FmaPgo.

  DISPLAY 
    gn-clie.NomCli @ Ccbcdocu.NomCli
    gn-clie.Ruc    @ Ccbcdocu.RucCli
    gn-clie.DirCli @ Ccbcdocu.DirCli
    s-CndVta       @ CcbCDocu.FmaPgo            /* La primera del cliente */
    gn-clie.NroCard @ Ccbcdocu.NroCard
    gn-clie.CodVen WHEN Ccbcdocu.CodVen:SCREEN-VALUE = '' @ Ccbcdocu.CodVen 
    WITH FRAME {&FRAME-NAME}.

  /* Tarjeta */
  FIND Gn-Card WHERE Gn-Card.NroCard = gn-clie.nrocard NO-LOCK NO-ERROR.
  IF AVAILABLE GN-CARD 
  THEN ASSIGN
            F-NomTar:SCREEN-VALUE = GN-CARD.NomClie[1]
            Ccbcdocu.NroCard:SENSITIVE = NO.
  ELSE ASSIGN
            F-NomTar:SCREEN-VALUE = ''
            Ccbcdocu.NroCard:SENSITIVE = YES.
  
  /* Ubica la Condicion Venta */
  FIND gn-convt WHERE gn-convt.Codig = Ccbcdocu.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt 
  THEN DO:
       F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
  END.  
  ELSE F-CndVta:SCREEN-VALUE = "".

  IF Ccbcdocu.FmaPgo:SCREEN-VALUE = '900' AND Ccbcdocu.Glosa:SCREEN-VALUE = ''
  THEN Ccbcdocu.Glosa:SCREEN-VALUE = 'BONIFICACION DE CAMPAÑA POR COMPRA POR VOLUMEN'.

  /* Vendedor */
  F-NomVen:SCREEN-VALUE = "".
  FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
      AND  gn-ven.CodVen = Ccbcdocu.CodVen:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-ven THEN F-NomVen:SCREEN-VALUE = gn-ven.NomVen.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodCli V-table-Win
ON LEFT-MOUSE-DBLCLICK OF CcbCDocu.CodCli IN FRAME F-Main /* Cliente */
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''.
    RUN vtagn/c-gn-clie-01 ('Clientes').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodVen V-table-Win
ON LEAVE OF CcbCDocu.CodVen IN FRAME F-Main /* Vendedor */
DO:
  F-NomVen:SCREEN-VALUE = "".
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
    AND  gn-ven.CodVen = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-ven THEN DO:
      MESSAGE "Vendedor NO válido" VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = "".
      RETURN NO-APPLY.
  END.
  F-NomVen:SCREEN-VALUE = gn-ven.NomVen.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodVen V-table-Win
ON LEFT-MOUSE-DBLCLICK OF CcbCDocu.CodVen IN FRAME F-Main /* Vendedor */
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''.
    RUN lkup/c-vende ('Vendedor').
    IF output-var-1 <> ? THEN Ccbcdocu.CodVen:SCREEN-VALUE = output-var-2.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.FmaPgo V-table-Win
ON LEAVE OF CcbCDocu.FmaPgo IN FRAME F-Main /* Condición de Venta */
DO:
    F-CndVta:SCREEN-VALUE = ''.
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND gn-convt WHERE gn-convt.Codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-convt THEN DO:
        MESSAGE 'Condición de venta NO válida' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
    /* Filtrado de las condiciones de venta */
    IF LOOKUP(SELF:SCREEN-VALUE, s-cndvta-validos) = 0 THEN DO:
        MESSAGE 'Condición de venta NO autorizada para este cliente'
            VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    s-CndVta = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.FmaPgo V-table-Win
ON LEFT-MOUSE-DBLCLICK OF CcbCDocu.FmaPgo IN FRAME F-Main /* Condición de Venta */
DO:
    ASSIGN
        input-var-1 = s-cndvta-validos
        input-var-2 = ''
        input-var-3 = ''.
    RUN vta/d-cndvta.
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.Libre_c01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.Libre_c01 V-table-Win
ON LEAVE OF CcbCDocu.Libre_c01 IN FRAME F-Main /* Lista de Precios */
DO:
  FIND gn-divi WHERE GN-DIVI.codcia = S-CODCIA 
      AND gn-divi.coddiv = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-divi THEN FILL-IN-Lista:SCREEN-VALUE = gn-divi.desdiv.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.NroCard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.NroCard V-table-Win
ON LEAVE OF CcbCDocu.NroCard IN FRAME F-Main /* Tarjeta */
DO:
    F-NomTar:SCREEN-VALUE = ''.
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    ASSIGN
      SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999") NO-ERROR.
    FIND Gn-Card WHERE Gn-Card.NroCard = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-Card THEN DO:
        MESSAGE 'Tarjeta de Cliente NO válida' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    F-NomTar:SCREEN-VALUE = GN-CARD.NomClie[1].
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.NroCard V-table-Win
ON LEFT-MOUSE-DBLCLICK OF CcbCDocu.NroCard IN FRAME F-Main /* Tarjeta */
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''.
    RUN lkup/c-gncard ('Tarjetas').
    IF output-var-1 <> ? THEN Ccbcdocu.NroCard:SCREEN-VALUE = output-var-2.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Guias V-table-Win 
PROCEDURE Actualiza-Guias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND B-CDOCU WHERE B-CDOCU.CodCia = Ccbcdocu.codcia
        AND  B-CDOCU.CodDoc = Ccbcdocu.codref
        AND  B-CDOCU.NroDoc = Ccbcdocu.nroref
        EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE B-CDOCU THEN DO :
        ASSIGN 
            B-CDOCU.FlgEst = "F"
            B-CDOCU.CodRef = CcbCDocu.CodDoc
            B-CDOCU.NroRef = CcbCDocu.NroDoc
            B-CDOCU.FchCan = CcbCDocu.FchDoc
            B-CDOCU.SdoAct = 0.
    END.
    RELEASE B-CDOCU.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Lista-Escolar V-table-Win 
PROCEDURE Actualiza-Lista-Escolar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER pTipo AS INT.
  
  FIND PedidoC WHERE PedidoC.NroPed = CcbCDocu.NroPed
    EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE PedidoC
  THEN IF pTipo = 1
        THEN ASSIGN
                    PedidoC.Estado = 'F'
                    PedidoC.FecFac = TODAY.
        ELSE ASSIGN
                    PedidoC.Estado = ''
                    PedidoC.FecFac = ?.
  RELEASE PedidoC.
                      
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel V-table-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE F-PreUni                LIKE CcbDDocu.Preuni.
DEFINE VARIABLE F-ImpLin                LIKE CcbDDocu.ImpLin.
DEFINE VARIABLE F-ImpTot                LIKE CcbCDocu.ImpTot.

DEF VAR can as integer.
DEF        VAR C-NomVen  AS CHAR FORMAT "X(30)".
DEF        VAR C-Descli  AS CHAR FORMAT "X(60)".
DEF        VAR C-Moneda  AS CHAR FORMAT "X(7)".
DEF        VAR C-NomCon  AS CHAR FORMAT "X(30)".
DEF        VAR W-DIRALM  AS CHAR FORMAT "X(50)".
DEF        VAR W-TLFALM  AS CHAR FORMAT "X(65)".
DEF        VAR X-ORDCOM AS CHARACTER FORMAT "X(18)".
DEF        VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.
DEFINE VARIABLE C-OBS AS CHAR EXTENT 2.
DEFINE VARIABLE K AS INTEGER.

IF NUM-ENTRIES(CcbCDocu.glosa,"-") - 1 > 6 THEN DO:
   DO K = 2 TO 7:
      IF ENTRY(K,CcbCDocu.glosa,"-") <> "" THEN 
         C-OBS[1] = C-OBS[1] + "- " + ENTRY(K,CcbCDocu.glosa,"-").
   END.
   DO K = 8 TO NUM-ENTRIES(CcbCDocu.glosa,"-"):
      IF ENTRY(K,CcbCDocu.glosa,"-") <> "" THEN 
         C-OBS[2] = C-OBS[2] + "- " + ENTRY(K,CcbCDocu.glosa,"-").
   END.
END.
ELSE DO: 
   C-OBS[1] = CcbCDocu.glosa.
   C-OBS[2] = "".
   /* 
   C-OBS[1] = SUBSTRING(FacCPedi.Observa,1,INDEX(FacCPedi.Observa,'@') - 1).
   C-OBS[2] = SUBSTRING(FacCPedi.Observa,INDEX(FacCPedi.Observa,'@') + 2).
   */
END.
/*IF CcbDDocu.aftIgv THEN DO:
 *    F-ImpTot = CcbCDocu.ImpTot.
 * END.
 * ELSE DO:
 *    F-ImpTot = CcbCDocu.ImpVta.
 * END.*/  

/* ************************ cargamos variables ********************* */
FIND gn-ven WHERE 
     gn-ven.CodCia = CcbCDocu.CodCia AND  
     gn-ven.CodVen = CcbCDocu.CodVen 
     NO-LOCK NO-ERROR.
C-NomVen = CcbCDocu.CodVen.
IF AVAILABLE gn-ven THEN C-NomVen = C-NomVen + " - " + gn-ven.NomVen.
FIND gn-clie WHERE 
     gn-clie.codcia = cl-codcia AND  
     gn-clie.codcli = CcbCDocu.codcli NO-LOCK NO-ERROR.
     
C-DESCLI  = Gn-clie.codcli + ' - ' + Gn-clie.Nomcli.
C-DESCLI  = CcbCDocu.codcli + ' - ' + CcbCDocu.Nomcli.

/*IF FacCPedi.coddoc = "PED" THEN 
    X-ORDCOM = "Orden de Compra : ".
ELSE 
    X-ORDCOM = "Solicitud Cotiz.: ".*/

FIND gn-ConVt WHERE gn-ConVt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
C-NomCon = CcbCDocu.FmaPgo.
IF AVAILABLE gn-ConVt THEN C-NomCon = gn-ConVt.Nombr.
IF CcbCDocu.Codmon = 2 THEN C-Moneda = "DOLARES".
ELSE C-Moneda = "SOLES".

/* ******************************************************************** */

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 4.
chWorkSheet:Columns("B"):ColumnWidth = 7.
chWorkSheet:Columns("C"):ColumnWidth = 10.
chWorkSheet:Columns("D"):ColumnWidth = 4.
chWorkSheet:Columns("E"):ColumnWidth = 45.
chWorkSheet:Columns("F"):ColumnWidth = 11.
chWorkSheet:Columns("G"):ColumnWidth = 15.
chWorkSheet:Columns("H"):ColumnWidth = 10.
chWorkSheet:Columns("I"):ColumnWidth = 15.


t-Column = t-Column + 2.
cColumn = STRING(t-Column).
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = CcbCDocu.NomCli.
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = CcbCDocu.CodCli.

t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = CcbCDocu.dircli. 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = CcbCDocu.ruccli.


t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = c-nomcon.

t-Column = t-Column + 3.
cColumn = STRING(t-Column).
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.fchdoc, '99/99/9999').
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "'" + CcbCDocu.NroPed. 
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "'" + CcbCDocu.NroRef.


t-Column = t-Column + 3.
cColumn = STRING(t-Column).
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = c-moneda. 
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "OFICINA".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.fchVto, '99/99/9999').
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = CcbCDocu.CodVen.
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "'" +  STRING(TIME,"HH:MM:SS") + "  " + S-USER-ID .
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = CcbCDocu.usuario.
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "'" + CcbCDocu.nroDoc.

t-Column = t-Column + 2.
cColumn = STRING(t-Column).
/*cRange = "A" + cColumn.
 * chWorkSheet:Range(cRange):Value = "ITEM".
 * cRange = "B" + cColumn.
 * chWorkSheet:Range(cRange):Value = "CODIGO".
 * cRange = "C" + cColumn.
 * chWorkSheet:Range(cRange):Value = "D E S C R I P C I O N".
 * cRange = "D" + cColumn.
 * chWorkSheet:Range(cRange):Value = "M A R C A".
 * cRange = "E" + cColumn.
 * chWorkSheet:Range(cRange):Value = "UND.".
 * cRange = "F" + cColumn.
 * chWorkSheet:Range(cRange):Value = "CANTIDAD".
 * cRange = "G" + cColumn.
 * chWorkSheet:Range(cRange):Value = "PRECI_UNI".
 * cRange = "H" + cColumn.
 * chWorkSheet:Range(cRange):Value = "DSCTO.".
 * cRange = "I" + cColumn.
 * chWorkSheet:Range(cRange):Value = "TOTAL NETO".*/

FOR EACH CcbDDocu OF CcbCDocu NO-LOCK,
        FIRST almmmatg OF CcbDDocu NO-LOCK
        BREAK BY CcbCDocu.NroPed BY CcbDDocu.NroItm:
    IF CcbDDocu.aftIgv THEN DO:
       F-PreUni = CcbDDocu.PreUni.
       F-ImpLin = CcbDDocu.ImpLin. 
    END.
    ELSE DO:
       F-PreUni = ROUND(CcbDDocu.PreUni / (1 + CcbCDocu.PorIgv / 100),2).
       F-ImpLin = ROUND(CcbDDocu.ImpLin / (1 + CcbCDocu.PorIgv / 100),2). 
    END.  
    
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    
    can = can + 1.
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value =  can.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + CcbDDocu.codmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbDDocu.UndVta.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbDDocu.candes.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = F-PreUni.
    /*cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = .*/
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = f-ImpLin.
END.

/* PIE DE PAGINA */
RUN bin/_numero(CcbCDocu.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = "SON : " + X-EnLetras + (IF CcbCDocu.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

t-column = t-column + 9.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = x-EnLetras.

t-column = t-column + 4.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "O.Compra:  " + CcbCDocu.NroOrd.
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.impbrt,'->>,>>>,>>9.99').
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.impdto,'->>,>>>,>>9.99').
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.impvta,'->>,>>>,>>9.99').

t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.PorIgv,'->>9.99') + " %".

t-column = t-column + 2.
cColumn = STRING(t-Column).
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.impigv,'->>,>>>,>>9.99').
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.imptot,'->>,>>>,>>9.99').
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "S/.        " + STRING(CcbCDocu.imptot,'->>,>>>,>>9.99').

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel2 V-table-Win 
PROCEDURE Excel2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE F-PreUni                LIKE CcbDDocu.Preuni.
DEFINE VARIABLE F-ImpLin                LIKE CcbDDocu.ImpLin.
DEFINE VARIABLE F-ImpTot                LIKE CcbCDocu.ImpTot.

DEF VAR C-NomVen   AS CHAR FORMAT "X(30)"       NO-UNDO.
DEF VAR C-Moneda   AS CHAR FORMAT "X(7)"        NO-UNDO.
DEF VAR C-NomCon   AS CHAR FORMAT "X(30)"       NO-UNDO.
DEF VAR X-ORDCOM   AS CHARACTER FORMAT "X(18)"  NO-UNDO.
DEF VAR X-EnLetras AS CHAR FORMAT "x(100)"      NO-UNDO.
DEF VAR C-OBS      AS CHAR EXTENT 2             NO-UNDO.
DEF VAR K          AS INTEGER              NO-UNDO.
DEF VAR iItm       AS INTEGER              NO-UNDO.

IF NUM-ENTRIES(CcbCDocu.glosa,"-") - 1 > 6 THEN DO:
   DO K = 2 TO 7:
      IF ENTRY(K,CcbCDocu.glosa,"-") <> "" THEN 
         C-OBS[1] = C-OBS[1] + "- " + ENTRY(K,CcbCDocu.glosa,"-").
   END.
   DO K = 8 TO NUM-ENTRIES(CcbCDocu.glosa,"-"):
      IF ENTRY(K,CcbCDocu.glosa,"-") <> "" THEN 
         C-OBS[2] = C-OBS[2] + "- " + ENTRY(K,CcbCDocu.glosa,"-").
   END.
END.
ELSE DO: 
   C-OBS[1] = CcbCDocu.glosa.
   C-OBS[2] = "".
END.
/* ************************ cargamos variables ********************* */
FIND gn-ven WHERE 
     gn-ven.CodCia = CcbCDocu.CodCia AND  
     gn-ven.CodVen = CcbCDocu.CodVen 
     NO-LOCK NO-ERROR.
C-NomVen = CcbCDocu.CodVen.
IF AVAILABLE gn-ven THEN C-NomVen = C-NomVen + " - " + gn-ven.NomVen.
FIND gn-clie WHERE 
     gn-clie.codcia = cl-codcia AND  
     gn-clie.codcli = CcbCDocu.codcli NO-LOCK NO-ERROR.
     
FIND gn-ConVt WHERE gn-ConVt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
C-NomCon = CcbCDocu.FmaPgo.
IF AVAILABLE gn-ConVt THEN C-NomCon = gn-ConVt.Nombr.
IF CcbCDocu.Codmon = 2 THEN C-Moneda = "DOLARES".
ELSE C-Moneda = "SOLES".

/* ******************************************************************** */

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

DEF var x-Plantilla AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION 'Plantillas' KEY 'Carpeta' VALUE x-Plantilla .
x-Plantilla = x-Plantilla + "FacturaTienda.xlt".

chWorkbook = chExcelApplication:Workbooks:Add(x-Plantilla).

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 6.
chWorkSheet:Columns("B"):ColumnWidth = 7.
chWorkSheet:Columns("C"):ColumnWidth = 50.
chWorkSheet:Columns("D"):ColumnWidth = 15.
chWorkSheet:Columns("E"):ColumnWidth = 10.
chWorkSheet:Columns("F"):ColumnWidth = 12.
chWorkSheet:Columns("G"):ColumnWidth = 12.
chWorkSheet:Columns("H"):ColumnWidth = 12.

t-Column = 9.
cColumn = STRING(t-Column).
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = CcbCDocu.CodDoc + '-' + CcbCDocu.nroDoc. 


t-Column = t-Column + 2.
cColumn = STRING(t-Column).

cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = 'Señor: ' + CcbCDocu.NomCli.
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = 'Codigo: ' + CcbCDocu.CodCli.

t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = 'Dirección: ' + CcbCDocu.dircli. 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = 'RUC: ' + CcbCDocu.ruccli.

t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = c-nomcon.

t-Column = t-Column + 1.
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Pedido: " + CcbCDocu.NroPed. 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = 'Fecha Emision: ' + STRING(CcbCDocu.fchdoc, '99/99/9999').

t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = 'Moneda: ' + c-moneda. 
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "'" + CcbCDocu.NroRef.
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = 'Fecha Vcto: ' + STRING(CcbCDocu.fchVto, '99/99/9999').

t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Vendedor: " + CcbCDocu.CodVen + '-' + c-NomVen.
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "OFICINA".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Hora: " +  STRING(TIME,"HH:MM:SS") + "  " + S-USER-ID .
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = CcbCDocu.usuario.

t-Column = t-Column + 6.
cColumn = STRING(t-Column).

FOR EACH CcbDDocu OF CcbCDocu NO-LOCK,
        FIRST almmmatg OF CcbDDocu NO-LOCK
        BREAK BY CcbCDocu.NroPed BY CcbDDocu.NroItm DESC:
    IF CcbDDocu.aftIgv THEN DO:
       F-PreUni = CcbDDocu.PreUni.
       F-ImpLin = CcbDDocu.ImpLin. 
    END.
    ELSE DO:
       F-PreUni = ROUND(CcbDDocu.PreUni / (1 + CcbCDocu.PorIgv / 100),2).
       F-ImpLin = ROUND(CcbDDocu.ImpLin / (1 + CcbCDocu.PorIgv / 100),2). 
    END.  

        /*Agrega Row*/
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):EntireRow:INSERT.

    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbDDocu.NroItm.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + CcbDDocu.codmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbDDocu.UndVta.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbDDocu.candes.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = F-PreUni.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = f-ImpLin.
    iItm = iItm + 1.

END.

/* PIE DE PAGINA */
RUN bin/_numero(CcbCDocu.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = "SON : " + X-EnLetras + (IF CcbCDocu.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

t-column = t-column + iItm + 4.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = x-EnLetras.

t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "O.Compra:  " + CcbCDocu.NroOrd.
/****************
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.impbrt,'->>,>>>,>>9.99').
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.impdto,'->>,>>>,>>9.99').
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.impvta,'->>,>>>,>>9.99').

t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.PorIgv,'->>9.99') + " %".

t-column = t-column + 2.
cColumn = STRING(t-Column).
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.impigv,'->>,>>>,>>9.99').
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.imptot,'->>,>>>,>>9.99').
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "S/.        " + STRING(CcbCDocu.imptot,'->>,>>>,>>9.99').

*******/

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Temp-FeLogErrores V-table-Win 
PROCEDURE Graba-Temp-FeLogErrores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH T-FeLogErrores:
    CREATE FeLogErrores.
    BUFFER-COPY T-FeLogErrores TO FeLogErrores NO-ERROR.
    DELETE T-FeLogErrores.
END.
IF AVAILABLE(FeLogErrores) THEN RELEASE FeLogErrores.

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

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':

    {vta2/graba-totales-fac.i}

    /* RHC 30-11-2006 Transferencia Gratuita */
    IF Ccbcdocu.FmaPgo = '900' THEN Ccbcdocu.sdoact = 0.
    IF Ccbcdocu.sdoact <= 0 
    THEN ASSIGN
            Ccbcdocu.fchcan = TODAY
            Ccbcdocu.flgest = 'C'.
END.
RETURN "OK".

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
  FIND FacCorre WHERE FacCorre.codcia = s-codcia
      AND FacCorre.coddoc = s-coddoc
      AND FacCorre.nroser = s-nroser
      NO-LOCK NO-ERROR.
  IF FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Esta serie está desactivada' VIEW-AS ALERT-BOX WARNING.
      RETURN "ADM-ERROR".
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  z-serie = STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-')).

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      DISPLAY 
          s-FmaPgo @ CcbCDocu.FmaPgo
          z-serie /*STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-'))*/ +
          STRING(FacCorre.Correlativo,ENTRY(2,x-Formato,'-')) @ Ccbcdocu.nrodoc
          TODAY @ Ccbcdocu.FchDoc
          FacCfgGn.Tpocmb[1] @ Ccbcdocu.TpoCmb
          TODAY  @ Ccbcdocu.FchVto
          s-CodVen @ Ccbcdocu.codven.

      /* Validamos que permita ingresar la fecha de emision */
      x-cambiar-fecha = NO.
      DEFINE VAR hProc AS HANDLE NO-UNDO.

      RUN ccb\libreria-ccb.r PERSISTENT SET hProc.

      RUN serie-cambia-fecha IN hProc (INPUT s-coddoc, INPUT z-serie, OUTPUT x-cambiar-fecha).

      DELETE PROCEDURE hProc.

      DISABLE ccbcdocu.fchdoc.
      DISABLE ccbcdocu.fchvto.
      IF x-cambiar-fecha = YES THEN DO:
          ENABLE ccbcdocu.fchdoc.
          ENABLE ccbcdocu.fchvto.
      END.

  END.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       SOLO SE PUEDEN CREAR FACTURAS
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  {vtagn/i-faccorre-01.i &Codigo = s-coddoc &Serie = s-nroser}

  ASSIGN 
      Ccbcdocu.CodCia = S-CODCIA
      Ccbcdocu.CodDiv = S-CODDIV
      Ccbcdocu.CodDoc = s-coddoc 
      CcbCDocu.NroDoc = STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-')) + STRING(FacCorre.Correlativo,ENTRY(2,x-Formato,'-')) 
      Ccbcdocu.TpoFac = s-TpoFac
      Ccbcdocu.FlgEst = "P"     /* PENDIENTE */      
      CcbCDocu.Tipo   = "CREDITO"
      CcbCDocu.TipVta = "2"
      CcbCDocu.usuario = S-USER-ID
      CcbCDocu.HorCie = STRING(TIME, 'HH:MM').

    IF x-cambiar-fecha = NO THEN CcbCDocu.FchDoc = TODAY.

  ASSIGN
      CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
      CcbCDocu.PorIgv = FacCfgGn.PorIgv
      Ccbcdocu.FlgCbd = YES     /* AFECTO */
      Ccbcdocu.ImpDto = 0
      Ccbcdocu.ImpDto2 = 0
      Ccbcdocu.ImpIgv = 0
      Ccbcdocu.ImpIsc = 0
      Ccbcdocu.ImpExo = 0.
  ASSIGN
      Ccbcdocu.ImpVta = ROUND(Ccbcdocu.ImpTot / ( 1 + Ccbcdocu.PorIgv / 100 ), 2)
      Ccbcdocu.ImpIgv = Ccbcdocu.ImpTot - Ccbcdocu.ImpVta
      Ccbcdocu.ImpBrt = Ccbcdocu.ImpVta
      Ccbcdocu.SdoAct = Ccbcdocu.ImpTot.
  ASSIGN
      FacCorre.Correlativo = FacCorre.Correlativo + 1.
  FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
      AND gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie  THEN DO:
      ASSIGN 
          CcbCDocu.CodDpto = gn-clie.CodDept 
          CcbCDocu.CodProv = gn-clie.CodProv 
          CcbCDocu.CodDist = gn-clie.CodDist.
  END.
  /* CREAMOS UN REGISTRO FALSO PARA LA IMPRESION */
  DEF VAR cCodMat AS CHAR NO-UNDO INIT '035866'.

  IF s-CodMat > '' THEN cCodMat = s-CodMat.
  ELSE CASE s-TpoFac:
      WHEN "A" THEN cCodMat = '035866'.
      WHEN "V" THEN cCodMat = '082636'.
  END CASE.
  CREATE Ccbddocu.
  BUFFER-COPY Ccbcdocu 
      TO Ccbddocu
      ASSIGN
      Ccbddocu.codmat = cCodMat
      Ccbddocu.undvta = "UNI"
      Ccbddocu.candes = 1
      Ccbddocu.factor = 1
      Ccbddocu.preuni = Ccbcdocu.imptot
      Ccbddocu.implin = Ccbcdocu.imptot
      Ccbddocu.aftigv = Ccbcdocu.flgcbd
      Ccbddocu.impigv = Ccbcdocu.impigv.
  /* ****************************************************************************************** */
  /* Importes SUNAT */
  /* ****************************************************************************************** */
  DEF VAR hProc AS HANDLE NO-UNDO.
  RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
  RUN tabla-ccbcdocu IN hProc (INPUT Ccbcdocu.CodDiv,
                               INPUT Ccbcdocu.CodDoc,
                               INPUT Ccbcdocu.NroDoc,
                               OUTPUT pMensaje).
  IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
  DELETE PROCEDURE hProc.
  /* ****************************************************************************************** */
  /* ****************************************************************************************** */
  /* GENERACION DE INFORMACION PARA SUNAT */
  RUN sunat\progress-to-ppll-v3( INPUT Ccbcdocu.coddiv,
                                 INPUT Ccbcdocu.coddoc,
                                 INPUT Ccbcdocu.nrodoc,
                                 INPUT-OUTPUT TABLE T-FELogErrores,
                                 OUTPUT pMensaje ).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF pMensaje = "" THEN pMensaje = "ERROR: No se pudo generar el comprobante" .
      UNDO, RETURN 'ADM-ERROR'.
  END.
  IF RETURN-VALUE = 'ERROR-EPOS' THEN DO:
      IF pMensaje = "" THEN pMensaje = "ERROR: No se pudo confirmar el comprobante" .
      ASSIGN
          Ccbcdocu.FlgEst = "A".
  END.
  /* *********************************************************** */
  IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
  IF AVAILABLE(Ccbddocu) THEN RELEASE Ccbddocu.
  
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
  IF s-user-id <> 'ADMIN' THEN DO:
      /* ********************************************* */
      /* Inicio de actividades facturación electrónica */
      /* ********************************************* */
      IF s-Sunat-Activo = YES THEN DO:
          MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
      /* ********************************************* */
  END.
  IF CcbCDocu.FlgEst = "A" THEN DO:
     MESSAGE 'El documento se encuentra Anulado...' VIEW-AS ALERT-BOX.
     RETURN 'ADM-ERROR'.
  END.
  IF CcbCDocu.SdoAct < CcbCDocu.ImpTot  THEN DO:
     MESSAGE 'El documento registra amortizaciones...' VIEW-AS ALERT-BOX.
     RETURN 'ADM-ERROR'.
  END.
  /* consistencia de la fecha del cierre del sistema */
  IF s-user-id <> "ADMIN" THEN DO:
      DEF VAR dFchCie AS DATE.
      RUN gn/fecha-de-cierre (OUTPUT dFchCie).
      IF ccbcdocu.fchdoc <= dFchCie THEN DO:
          MESSAGE 'NO se puede anular ningun documento antes del' (dFchCie + 1)
              VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.
  END.
  /* fin de consistencia */
  IF MONTH(Ccbcdocu.FchDoc) <> MONTH(TODAY) 
        OR YEAR(Ccbcdocu.FchDoc) <> YEAR(TODAY) THEN DO:
    {adm/i-DocPssw.i s-CodCia s-CodDoc ""DEL""}
  END.
  
  DEF VAR cReturnValue AS CHAR NO-UNDO.
  RUN ccb/d-motanu (ccbcdocu.codcia, ccbcdocu.coddoc, ccbcdocu.nrodoc, s-user-id, OUTPUT cReturnValue).
  IF cReturnValue = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

  ELIMINACION:
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
      FOR EACH CcbDDocu OF CcbCDocu:
          DELETE CcbDDocu.
      END.
      /* ANULAMOS LA FACTURA */
      FIND B-CDOCU WHERE ROWID(B-CDOCU) = ROWID(CcbCDocu) EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABL B-CDOCU THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN 
          B-CDOCU.FlgEst = "A"
          B-CDOCU.SdoAct = 0
          B-CDOCU.UsuAnu = S-USER-ID
          B-CDOCU.FchAnu = TODAY
          B-CDOCU.Glosa  = "A N U L A D O".
     IF AVAILABLE(B-CDOCU) THEN RELEASE B-CDOCU.
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

     FILL-IN-Lista:SCREEN-VALUE = ''.
     FIND gn-divi WHERE GN-DIVI.codcia = S-CODCIA 
         AND gn-divi.coddiv = CcbCDocu.Libre_c01
         NO-LOCK NO-ERROR.
     IF AVAILABLE gn-divi THEN FILL-IN-Lista:SCREEN-VALUE = gn-divi.desdiv.
  END.
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
      ASSIGN
          Ccbcdocu.RucCli:SENSITIVE = NO
          Ccbcdocu.NomCli:SENSITIVE = NO
          Ccbcdocu.DirCli:SENSITIVE = NO
          ccbcdocu.fchvto:SENSITIVE = NO
          Ccbcdocu.TpoCmb:SENSITIVE = NO.
      IF s-CodDoc = 'BOL'
          THEN ASSIGN
                    Ccbcdocu.DirCli:SENSITIVE = YES
                    Ccbcdocu.NomCli:SENSITIVE = YES.
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
  IF NOT AVAILABLE Ccbcdocu OR Ccbcdocu.flgest = "A" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF s-Sunat-Activo = YES THEN DO:
      /*RUN sunat\r-impresion-documentos-sunat ( ROWID(Ccbcdocu), "O", NO ).*/
      RUN sunat\r-impresion-doc-electronico-sunat (INPUT CcbCDocu.CodDiv, 
                                                   INPUT CcbCDocu.coddoc, 
                                                   INPUT CcbCDocu.nrodoc,
                                                   INPUT "O",   /* Original */
                                                   INPUT NO,    /* Formato Ticket */
                                                   INPUT NO,    /* Imprimir directo */
                                                   INPUT "").   /* Nombre de impresora */
  END.
  ELSE DO:
      IF S-CODDOC = "FAC" THEN DO:
         RUN VTA2\r-impfacade (ROWID(CcbCDocu)).
      END.    

      IF S-CODDOC = "BOL" THEN DO:
         RUN VTA\R-IMPBOL2 (ROWID(CcbCDocu)).
      END.
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
  EMPTY TEMP-TABLE T-FELogErrores.    /* CONTROL DE ERRORES DE FACTURACION ELECTRONICA */
  pMensaje = "".
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  RUN Graba-Temp-FeLogErrores.    /* Control de Errores (si es que hay) */
  IF pMensaje <> "" THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* Code placed here will execute AFTER standard behavior.    */
  pMensaje = "".
  RUN Procesa-Handle IN lh_Handle ('Pagina1').
  IF RETURN-VALUE = 'ADM-ERROR' AND pMensaje <> '' THEN DO:
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
  END.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

  MESSAGE "Imprimir Documentos"  SKIP(1)
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      TITLE "" UPDATE choice AS LOGICAL.
  IF choice THEN RUN dispatch IN THIS-PROCEDURE ('imprime':U).
  
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
          FacCorre.NroSer = S-NROSER EXCLUSIVE-LOCK NO-ERROR.
  ELSE
     FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = S-CODDOC AND
          FacCorre.NroSer = S-NROSER NO-LOCK NO-ERROR.
  
  IF AVAILABLE FacCorre THEN DO:
     ASSIGN I-NroDoc = FacCorre.Correlativo.
     IF L-INCREMENTA THEN ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
     I-NroSer = FacCorre.NroSer.
     /*S-CodAlm = FacCorre.CodAlm.*/
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
        WHEN "codcli" THEN
            ASSIGN
                input-var-1 = s-coddiv
                input-var-2 = "G/R"
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
  DEFINE VARIABLE F-BOL AS DECIMAL INIT 0 NO-UNDO.

  DO WITH FRAME {&FRAME-NAME} :
      /* Validación Lista de Precio */
      FIND gn-divi WHERE GN-DIVI.codcia = S-CODCIA 
          AND gn-divi.coddiv = CcbCDocu.Libre_c01:SCREEN-VALUE
/*           AND LOOKUP(gn-divi.campo-char[1],'A,L') > 0 */
/*           AND gn-divi.canalventa = 'FER'              */
          NO-LOCK NO-ERROR.
      IF ERROR-STATUS:ERROR THEN DO:
          MESSAGE 'Lista de Precios NO válida' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO CcbCDocu.Libre_c01.
          RETURN 'ADM-ERROR'.
      END.
      /* VALIDACION DEL CLIENTE */
      IF Ccbcdocu.CodCli:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Codigo de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO Ccbcdocu.CodCli.
         RETURN "ADM-ERROR".   
      END.
/*       FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA                     */
/*           AND  gn-clie.CodCli = Ccbcdocu.CodCli:SCREEN-VALUE            */
/*           NO-LOCK NO-ERROR.                                             */
/*       IF NOT AVAILABLE gn-clie THEN DO:                                 */
/*          MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR. */
/*          APPLY "ENTRY" TO Ccbcdocu.CodCli.                              */
/*          RETURN "ADM-ERROR".                                            */
/*       END.                                                              */
      RUN vtagn/p-gn-clie-01 (Ccbcdocu.CodCli:SCREEN-VALUE , s-coddoc).
      IF RETURN-VALUE = "ADM-ERROR" THEN DO:
          APPLY "ENTRY" TO Ccbcdocu.CodCli.
          RETURN "ADM-ERROR".   
      END.
      IF NOT (s-coddoc = 'C/M' OR s-coddoc = 'P/M') THEN DO:
          IF LOOKUP(TRIM(SELF:SCREEN-VALUE), x-ClientesVarios) > 0
          THEN DO:
            MESSAGE 'Clientes varios NO permitidos' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO Ccbcdocu.CodCli.
            RETURN 'ADM-ERROR'.
          END.
      END.
      /* CONTRATO MARCO -> CHEQUEO DE CANAL */
     IF gn-clie.canal = '006' THEN DO:
         MESSAGE 'Cliente no permitido en este canal de venta de venta'
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.CodCli.
        RETURN "ADM-ERROR".   
    END.
     IF s-CodDoc = "FAC" AND Ccbcdocu.RucCli:SCREEN-VALUE = '' THEN DO:
        MESSAGE "El Cliente NO tiene R.U.C." VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.CodCli.
        RETURN "ADM-ERROR".   
     END.      
    /* VALIDACION DEL VENDEDOR */
     IF Ccbcdocu.CodVen:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Codigo de Vendedor no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.CodVen.
        RETURN "ADM-ERROR".   
     END.
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
         AND  gn-ven.CodVen = Ccbcdocu.CodVen:SCREEN-VALUE 
         NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gn-ven THEN DO:
        MESSAGE "Codigo de Vendedor no existe" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.CodVen.
        RETURN "ADM-ERROR".   
     END.
     ELSE DO:
         IF gn-ven.flgest = "C" THEN DO:
             MESSAGE "Codigo de Vendedor Cesado" VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO Ccbcdocu.CodVen.
             RETURN "ADM-ERROR".   
         END.
     END.
    /* VALIDACION DE LA CONDICION DE VENTA */    
     IF Ccbcdocu.FmaPgo:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Condicion Venta no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.FmaPgo.
        RETURN "ADM-ERROR".   
     END.
     FIND gn-convt WHERE gn-convt.Codig = Ccbcdocu.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gn-convt THEN DO:
        MESSAGE "Condicion Venta no existe" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.FmaPgo.
        RETURN "ADM-ERROR".   
     END.
     IF Ccbcdocu.FmaPgo:SCREEN-VALUE = "000" THEN DO:
        MESSAGE "Condicion Venta no debe ser contado" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.FmaPgo.
        RETURN "ADM-ERROR".   
     END.
    
     /* Ic - 17Ene2020 */
     IF x-anticipo-campana = YES  THEN DO:
         IF gn-convt.libre_l03 <> YES THEN DO:
             MESSAGE "Condicion Venta debe ser de ANTICIPO DE CAMPAÑA " VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO Ccbcdocu.FmaPgo.
             RETURN "ADM-ERROR".   
         END.
     END.

    /* VALIDACION DE LA TARJETA */
     IF Ccbcdocu.NroCar:SCREEN-VALUE <> "" THEN DO:
         FIND Gn-Card WHERE Gn-Card.NroCard = Ccbcdocu.NroCar:SCREEN-VALUE
             NO-LOCK NO-ERROR.
         IF NOT AVAILABLE Gn-Card THEN DO:
             MESSAGE "Numero de Tarjeta Incorrecto, Verifique... " VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO Ccbcdocu.NroCar.
             RETURN "ADM-ERROR".   
         END.   
     END.           
     /* VALIDACION DE ITEMS */
     f-Tot = DECIMAL (CcbCDocu.ImpTot:SCREEN-VALUE).
     IF F-Tot = 0 THEN DO:
        MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.ImpTot.
        RETURN "ADM-ERROR".   
     END.
     /* VALIDACION DE MONTO MINIMO POR BOLETA */
     F-BOL = IF INTEGER(Ccbcdocu.CodMon:SCREEN-VALUE) = 1 
             THEN F-TOT
             ELSE F-Tot * DECIMAL(Ccbcdocu.TpoCmb:SCREEN-VALUE).
     IF s-CodDoc = 'BOL' AND F-BOL > 700 
         AND (Ccbcdocu.CodAnt:SCREEN-VALUE = '' 
             OR LENGTH(Ccbcdocu.CodAnt:SCREEN-VALUE, "CHARACTER") < 8)
     THEN DO:
         MESSAGE "Venta Mayor a 700.00" SKIP
                 "Debe ingresar en DNI"
             VIEW-AS ALERT-BOX ERROR.
         RETURN "ADM-ERROR".   
     END.
    /* OTRAS VALIDACIONES */
     IF Ccbcdocu.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '11111111112'
         AND Ccbcdocu.FmaPgo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '900' 
         AND Ccbcdocu.NroCard:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '' THEN DO:
        MESSAGE "Ingrese el numero de tarjeta" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.NroCard.
        RETURN "ADM-ERROR".   
     END.
     IF Ccbcdocu.FmaPgo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '900'
         AND Ccbcdocu.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> '11111111112'
         AND Ccbcdocu.NroCard:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> '' THEN DO:
        MESSAGE "En caso de transferencia gratuita NO es válido el Nº de Tarjeta" 
             VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.NroCard.
        RETURN "ADM-ERROR".   
     END.
/*      IF DECIMAL(CcbCDocu.AcuBon[1]:SCREEN-VALUE) = 0 THEN DO:         */
/*          MESSAGE 'Ingrese la tasa Descuento' VIEW-AS ALERT-BOX ERROR. */
/*          APPLY 'ENTRY':U TO CcbCDocu.AcuBon[1].                       */
/*          RETURN "ADM-ERROR".                                          */
/*      END.                                                             */

     DEFINE VAR x-fecha-emision AS DATE.
     DEFINE VAR x-fecha-vto AS DATE.

     x-fecha-emision = DATE(Ccbcdocu.fchdoc:SCREEN-VALUE).
     x-fecha-vto = DATE(Ccbcdocu.fchvto:SCREEN-VALUE).

     /*IF x-cambiar-fecha = YES THEN DO:*/
        IF x-fecha-emision = ? OR x-fecha-vto = ? THEN DO:
            MESSAGE "Fecha de EMISION y/o VENCIMIENTO esta errado" 
                 VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO Ccbcdocu.fchdoc.
            RETURN "ADM-ERROR".   
        END.
        IF x-fecha-emision > x-fecha-vto THEN DO:
            MESSAGE "Fecha de EMISION no debe ser mayor al VENCIMIENTO" 
                 VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO Ccbcdocu.fchdoc.
            RETURN "ADM-ERROR".   
        END.
        IF x-fecha-emision > TODAY THEN DO:
            MESSAGE "Fecha de EMISION no debe ser mayor a la del SISTEMA" 
                 VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO Ccbcdocu.fchdoc.
            RETURN "ADM-ERROR".   
        END.
        IF (TODAY - x-fecha-emision) > 6 THEN DO:
            MESSAGE "No puede emitir comprobantes con mas 7 dias de antiguedad"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO Ccbcdocu.dircli.
            RETURN "ADM-ERROR".
        END.

        FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND 
                                  x-ccbcdocu.coddoc = s-coddoc AND 
                                  x-ccbcdocu.nrodoc BEGINS z-serie AND
                                  x-ccbcdocu.fchdoc > x-fecha-emision NO-LOCK NO-ERROR.
        IF AVAILABLE x-ccbcdocu THEN DO:
            MESSAGE 'Ya existen documentos generados con fecha superior a ' + Ccbcdocu.fchdoc:SCREEN-VALUE
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO Ccbcdocu.dircli.
            RETURN "ADM-ERROR".
        END.

     /*END.*/



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

