&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE DETA LIKE CcbDDocu.



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

/* Public Variable Definitions ---                                       */
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-TPOFAC   AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CNDVTA   AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB AS DECIMAL.  
DEFINE SHARED VARIABLE X-NRODEC AS INTEGER INIT 2.
DEFINE SHARED VARIABLE CL-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-NROSER   AS INT.
DEFINE SHARED VARIABLE S-CODVEN AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE VAR s-cndvta-validos AS CHAR.
DEFINE VAR F-Observa AS CHAR NO-UNDO.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE VAR x-ClientesVarios AS CHAR.
x-ClientesVarios = FacCfgGn.CliVar.     /* 11 digitos */

/*DEF VAR i-NroPed AS INT.*/

DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER B-CCDOCU FOR CcbCDocu.

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
&Scoped-define EXTERNAL-TABLES Ccbcdocu
&Scoped-define FIRST-EXTERNAL-TABLE Ccbcdocu


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Ccbcdocu.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCDocu.CodCli CcbCDocu.RucCli ~
CcbCDocu.CodAnt CcbCDocu.FchVto CcbCDocu.NomCli CcbCDocu.DirCli ~
CcbCDocu.NroOrd CcbCDocu.LugEnt CcbCDocu.CodMon CcbCDocu.NroCard ~
CcbCDocu.TpoCmb CcbCDocu.Sede CcbCDocu.ImpTot CcbCDocu.CodVen ~
CcbCDocu.FmaPgo CcbCDocu.Glosa 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.CodCli CcbCDocu.RucCli CcbCDocu.CodAnt CcbCDocu.FchVto ~
CcbCDocu.NomCli CcbCDocu.usuario CcbCDocu.DirCli CcbCDocu.NroOrd ~
CcbCDocu.LugEnt CcbCDocu.CodMon CcbCDocu.NroCard CcbCDocu.TpoCmb ~
CcbCDocu.Sede CcbCDocu.ImpTot CcbCDocu.CodVen CcbCDocu.FmaPgo ~
CcbCDocu.Glosa 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS F-Estado F-Nomtar FILL-IN-sede F-nOMvEN ~
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
     SIZE 59 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "ESTADO" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE F-Nomtar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE F-nOMvEN AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 59 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-sede AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 59 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.NroDoc AT ROW 1 COL 15 COLON-ALIGNED WIDGET-ID 34 FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 15 FGCOLOR 1 
     F-Estado AT ROW 1 COL 40 COLON-ALIGNED
     CcbCDocu.FchDoc AT ROW 1 COL 99 COLON-ALIGNED
          LABEL "Fecha de Emisión"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.CodCli AT ROW 1.81 COL 15 COLON-ALIGNED HELP
          "" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.RucCli AT ROW 1.81 COL 40 COLON-ALIGNED
          LABEL "RUC"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.CodAnt AT ROW 1.81 COL 60 COLON-ALIGNED WIDGET-ID 2
          LABEL "DNI" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCDocu.FchVto AT ROW 1.81 COL 99 COLON-ALIGNED
          LABEL "Fecha Vencimiento" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.NomCli AT ROW 2.62 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 66 BY .81
     CcbCDocu.usuario AT ROW 2.62 COL 99 COLON-ALIGNED WIDGET-ID 36
          LABEL "Digitado por"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.DirCli AT ROW 3.42 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 66 BY .81
     CcbCDocu.NroOrd AT ROW 3.42 COL 99 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     CcbCDocu.LugEnt AT ROW 4.23 COL 15 COLON-ALIGNED WIDGET-ID 20
          LABEL "Lugar de entrega"
          VIEW-AS FILL-IN 
          SIZE 66 BY .81
     CcbCDocu.CodMon AT ROW 4.23 COL 101 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dólares", 2
          SIZE 15 BY .81
     CcbCDocu.NroCard AT ROW 5.04 COL 15 COLON-ALIGNED
          LABEL "Nro.Tarjeta"
          VIEW-AS FILL-IN 
          SIZE 11.57 BY .81
     F-Nomtar AT ROW 5.04 COL 27 COLON-ALIGNED NO-LABEL
     CcbCDocu.TpoCmb AT ROW 5.04 COL 99 COLON-ALIGNED
          LABEL "Tipo de cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.Sede AT ROW 5.85 COL 15 COLON-ALIGNED WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     FILL-IN-sede AT ROW 5.85 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     CcbCDocu.ImpTot AT ROW 5.85 COL 99 COLON-ALIGNED WIDGET-ID 32 FORMAT "ZZ,ZZZ,ZZ9.99"
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
          BGCOLOR 1 FGCOLOR 15 FONT 6
     CcbCDocu.CodVen AT ROW 6.65 COL 15 COLON-ALIGNED FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-nOMvEN AT ROW 6.65 COL 22 COLON-ALIGNED NO-LABEL
     CcbCDocu.FmaPgo AT ROW 7.46 COL 15 COLON-ALIGNED
          LABEL "Condición de Venta" FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-CndVta AT ROW 7.46 COL 22 COLON-ALIGNED NO-LABEL
     CcbCDocu.Glosa AT ROW 8.27 COL 12.28
          LABEL "Glosa" FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 66 BY .81
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 4.5 COL 95
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.Ccbcdocu
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: DETA T "SHARED" ? INTEGRAL CcbDDocu
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
         HEIGHT             = 8.31
         WIDTH              = 117.29.
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

/* SETTINGS FOR FILL-IN CcbCDocu.CodAnt IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.CodCli IN FRAME F-Main
   EXP-FORMAT EXP-HELP                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.CodVen IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Nomtar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-nOMvEN IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.FchVto IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-sede IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FmaPgo IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.Glosa IN FRAME F-Main
   ALIGN-L EXP-LABEL EXP-FORMAT                                         */
/* SETTINGS FOR FILL-IN CcbCDocu.ImpTot IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.LugEnt IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NroCard IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.RucCli IN FRAME F-Main
   EXP-LABEL                                                            */
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

  /* Cargamos las condiciones de venta válidas */
  FIND gn-clie WHERE gn-clie.codcia  = cl-codcia
      AND gn-clie.codcli = SELF:SCREEN-VALUE
      NO-LOCK.
  RUN vtagn/p-fmapgo-01 (SELF:SCREEN-VALUE, OUTPUT s-cndvta-validos).

  DISPLAY 
    gn-clie.NomCli @ Ccbcdocu.NomCli
    gn-clie.Ruc    @ Ccbcdocu.RucCli
    gn-clie.DirCli @ Ccbcdocu.DirCli
    ENTRY(1, s-cndvta-validos) @ Ccbcdocu.FmaPgo  /* La primera del cliente */
    gn-clie.NroCard @ Ccbcdocu.NroCard
    gn-clie.CodVen WHEN Ccbcdocu.CodVen:SCREEN-VALUE = '' @ Ccbcdocu.CodVen 
    WITH FRAME {&FRAME-NAME}.
  ASSIGN
      S-CNDVTA = ENTRY(1, s-cndvta-validos).

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

  IF Ccbcdocu.FmaPgo:SCREEN-VALUE = '900' 
    AND Ccbcdocu.Glosa:SCREEN-VALUE = ''
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
OR f8 OF Ccbcdocu.CodCli
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
    AND  gn-ven.CodVen = Ccbcdocu.CodVen:SCREEN-VALUE
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


&Scoped-define SELF-NAME CcbCDocu.FchVto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.FchVto V-table-Win
ON LEAVE OF CcbCDocu.FchVto IN FRAME F-Main /* Fecha Vencimiento */
DO:

      FIND TcmbCot WHERE  TcmbCot.Codcia = 0
                    AND  (TcmbCot.Rango1 <=  DATE(ccbcdocu.fchvto:SCREEN-VALUE) - DATE(ccbcdocu.fchdoc:SCREEN-VALUE) + 1
                    AND   TcmbCot.Rango2 >= DATE(ccbcdocu.fchvto:SCREEN-VALUE) - DATE(ccbcdocu.fchdoc:SCREEN-VALUE) + 1 )
                   NO-LOCK NO-ERROR.
      IF AVAIL TcmbCot THEN DO:
      
          DISPLAY TcmbCot.TpoCmb @ Ccbcdocu.TpoCmb
                  WITH FRAME {&FRAME-NAME}.
          S-TPOCMB = TcmbCot.TpoCmb.  
      END.
/*       RUN Procesa-Handle IN lh_Handle ('Recalculo'). */
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
        SELF:SCREEN-VALUE = ''.
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
    IF output-var-1 <> ? THEN Ccbcdocu.Fmapgo:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.NroCard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.NroCard V-table-Win
ON LEAVE OF CcbCDocu.NroCard IN FRAME F-Main /* Nro.Tarjeta */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  ASSIGN
    SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999") NO-ERROR.
  FIND Gn-Card WHERE Gn-Card.NroCard = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Gn-Card THEN DO:
      APPLY "ENTRY" TO Ccbcdocu.NroCard.
      RETURN NO-APPLY.
  END.
  F-NomTar:SCREEN-VALUE = ''.
  FIND Gn-Card WHERE Gn-Card.NroCard = SELF:SCREEN-VALUE 
    NO-LOCK NO-ERROR.
  IF AVAILABLE GN-CARD THEN F-NomTar:SCREEN-VALUE = GN-CARD.NomClie[1].
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.RucCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.RucCli V-table-Win
ON LEAVE OF CcbCDocu.RucCli IN FRAME F-Main /* RUC */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    IF LENGTH(SELF:SCREEN-VALUE) < 11 OR LOOKUP(SUBSTRING(SELF:SCREEN-VALUE,1,2), '10,20,15') = 0 THEN DO:
        MESSAGE 'Debe tener 11 dígitos y comenzar con 20, 10 ó 15' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    /* dígito verificador */
    DEF VAR pResultado AS CHAR.
    RUN lib/_ValRuc (SELF:SCREEN-VALUE, OUTPUT pResultado).
    IF pResultado = 'ERROR' THEN DO:
        MESSAGE 'Código MAL registrado' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.Sede
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.Sede V-table-Win
ON LEAVE OF CcbCDocu.Sede IN FRAME F-Main /* Sede */
DO:
    FILL-IN-Sede:SCREEN-VALUE = "".
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    FIND gn-clied WHERE gn-clied.codcia = cl-codcia
        AND gn-clied.codcli = Ccbcdocu.codcli:SCREEN-VALUE
        AND gn-clied.sede = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clied THEN DO:
        MESSAGE "Sede NO válida" VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
    ASSIGN 
        FILL-IN-Sede:SCREEN-VALUE = Gn-ClieD.DirCli
        Ccbcdocu.LugEnt:SCREEN-VALUE = Gn-ClieD.DirCli
        Ccbcdocu.Glosa:SCREEN-VALUE = (IF Ccbcdocu.Glosa:SCREEN-VALUE = '' THEN Gn-ClieD.DirCli ELSE Ccbcdocu.Glosa:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.Sede V-table-Win
ON LEFT-MOUSE-DBLCLICK OF CcbCDocu.Sede IN FRAME F-Main /* Sede */
DO:
    ASSIGN
      input-var-1 = Ccbcdocu.CodCli:SCREEN-VALUE
      input-var-2 = Ccbcdocu.NomCli:SCREEN-VALUE
      input-var-3 = ''
      output-var-1 = ?
      output-var-2 = ''
      output-var-3 = ''.
    RUN vta/c-clied.
    IF output-var-1 <> ?
        THEN ASSIGN 
              FILL-IN-Sede:SCREEN-VALUE = output-var-2
              Ccbcdocu.LugEnt:SCREEN-VALUE = output-var-2
              Ccbcdocu.Glosa:SCREEN-VALUE = (IF Ccbcdocu.Glosa:SCREEN-VALUE = '' THEN output-var-2 ELSE Ccbcdocu.Glosa:SCREEN-VALUE)
              Ccbcdocu.Sede:SCREEN-VALUE = output-var-3.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.TpoCmb V-table-Win
ON LEAVE OF CcbCDocu.TpoCmb IN FRAME F-Main /* Tipo de cambio */
DO:
    S-TPOCMB = DEC(Ccbcdocu.TpoCmb:SCREEN-VALUE).
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Item V-table-Win 
PROCEDURE Actualiza-Item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH DETA:
    DELETE DETA.
  END.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN DO:
      FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
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
  {src/adm/template/row-list.i "Ccbcdocu"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Ccbcdocu"}

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

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH Ccbddocu OF Ccbcdocu:
      DELETE Ccbddocu.
    END.    
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

    EMPTY TEMP-TABLE DETA.

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

DO ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
    CREATE Ccbddocu.
    ASSIGN 
        CcbDDocu.CodCia = CcbCDocu.CodCia 
        CcbDDocu.CodDiv = CcbCDocu.CodDiv
        CcbDDocu.CodDoc = CcbCDocu.CodDoc 
        CcbDDocu.NroDoc = CcbCDocu.NroDoc
        CcbDDocu.FchDoc = TODAY
        CcbDDocu.CanDes = 1
        CcbDDocu.CanDev = 0                 /* Control de Devoluciones */
        CcbDDocu.Factor = 1
        Ccbddocu.NroItm = 1
        Ccbddocu.CodMat = '035866'
        CcbDDocu.UndVta = 'UNI'
        CcbDDocu.PreUni = Ccbcdocu.ImpTot
        CcbDDocu.PorDto = 0
        CcbDDocu.Por_Dsctos[1] = 0
        CcbDDocu.PreBas = Ccbcdocu.ImpTot
        CcbDDocu.Por_DSCTOS[2] = 0
        CcbDDocu.Por_Dsctos[3] = 0
        CcbDDocu.ImpDto = ROUND( CcbDDocu.PreUni * CcbDDocu.CanDes * (CcbDDocu.Por_Dsctos[1] / 100),4 )
        CcbDDocu.ImpLin = ROUND( CcbDDocu.PreUni * CcbDDocu.CanDes , 2 ) - CcbDDocu.ImpDto
        CcbDDocu.AftIgv = YES
        CcbDDocu.AftIsc = NO.
      IF CcbDDocu.AftIsc 
      THEN CcbDDocu.ImpIsc = ROUND(CcbDDocu.PreBas * CcbDDocu.CanDes * (Almmmatg.PorIsc / 100),4).
      IF CcbDDocu.AftIgv 
      THEN  CcbDDocu.ImpIgv = CcbDDocu.ImpLin - ROUND(CcbDDocu.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
END.
RETURN 'OK'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir-Txt V-table-Win 
PROCEDURE Imprimir-Txt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       init ""
------------------------------------------------------------------------------*/
  DEFINE VARIABLE o-file AS CHARACTER.

  IF Ccbcdocu.FlgEst <> "A" THEN DO:
/*      RUN VTA/d-file.r (OUTPUT o-file).*/

      RUN VTA\R-ImpTxt.r(ROWID(Ccbcdocu), 
                         o-file).

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
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDoc = S-CODDOC 
      AND FacCorre.NroSer = s-NroSer
      NO-LOCK NO-ERROR.
  IF FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    DISPLAY
        STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ Ccbcdocu.NroDoc.
    ASSIGN
        s-CndVta = ''
        s-TpoCmb = 1.
    FIND TcmbCot WHERE  TcmbCot.Codcia = 0
        AND  (TcmbCot.Rango1 <= TODAY - TODAY + 1
        AND   TcmbCot.Rango2 >= TODAY - TODAY + 1)
        NO-LOCK NO-ERROR.
    IF AVAIL TcmbCot THEN S-TPOCMB = TcmbCot.TpoCmb.  
    DISPLAY 
        TODAY @ ccbcdocu.fchdoc
        S-TPOCMB @ Ccbcdocu.TpoCmb
        (TODAY ) @ ccbcdocu.fchvto 
        s-CodVen @ Ccbcdocu.codven.
    ASSIGN
        S-CNDVTA = Ccbcdocu.FmaPgo:SCREEN-VALUE.
    RUN Borra-Temporal.
    RUN Procesa-Handle IN lh_Handle ('Pagina2').
    APPLY 'ENTRY':U TO Ccbcdocu.CodCli.
  END.

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
  DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE I-NRODOC       AS INTEGER   NO-UNDO.

  {vtagn/i-faccorre-01.i &Codigo = s-CodDoc &Serie = s-NroSer }

  ASSIGN 
      I-NroSer = FacCorre.NroSer
      I-NroDoc = FacCorre.Correlativo
      FacCorre.Correlativo = FacCorre.Correlativo + 1.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN 
      CcbCDocu.CodCia = S-CODCIA
      CcbCDocu.CodDoc = S-CODDOC
      CcbCDocu.CodDiv = S-CODDIV
      CcbCDocu.NroDoc = STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999").
  ASSIGN 
      CcbCDocu.FchDoc = TODAY
      CcbCDocu.FchVto = TODAY
      CcbCDocu.FchAte = TODAY
      CcbCDocu.FlgEst = "P"
      CcbCDocu.Tipo   = "OFICINA"
      CcbCDocu.TipVta = "2"
      CcbCDocu.TpoFac = S-TPOFAC
      CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
      CcbCDocu.PorIgv = FacCfgGn.PorIgv
      CcbCDocu.FlgCbd = YES     /* VA A SIMULAR AFECTO A IGV */
      CcbCDocu.FlgAte = 'D'
      CcbCDocu.usuario = S-USER-ID
      CcbCDocu.HorCie = STRING(TIME, 'HH:MM').

  FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
      AND gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie  THEN DO:
      ASSIGN 
          CcbCDocu.CodDpto = gn-clie.CodDept 
          CcbCDocu.CodProv = gn-clie.CodProv 
          CcbCDocu.CodDist = gn-clie.CodDist.
  END.
  /* ACTUALIZAR EL CENTRO DE COSTO 22.07.04 CY */
  FIND GN-VEN WHERE gn-ven.codcia = s-codcia
      AND gn-ven.codven = ccbcdocu.codven
      NO-LOCK NO-ERROR.
  IF AVAILABLE GN-VEN THEN ccbcdocu.cco = gn-ven.cco.

  /* TRACKING FACTURAS */
  RUN vtagn/pTracking-04 (s-CodCia,
                       s-CodDiv,
                       Ccbcdocu.CodPed,
                       Ccbcdocu.NroPed,
                       s-User-Id,
                       'EFAC',
                       'P',
                       DATETIME(TODAY, MTIME),
                       DATETIME(TODAY, MTIME),
                       Ccbcdocu.coddoc,
                       Ccbcdocu.nrodoc,
                       Ccbcdocu.codref,
                       Ccbcdocu.nroref).

  ASSIGN
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

  RELEASE FacCorre.

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

  DO WITH FRAME {&FRAME-NAME}:
     Ccbcdocu.NomCli:SENSITIVE = NO.
     Ccbcdocu.RucCli:SENSITIVE = NO.
     Ccbcdocu.DirCli:SENSITIVE = NO.
  END. 
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

  /* Code placed here will execute PRIOR to standard behavior. */
  IF CcbCDocu.FlgEst = "A" THEN DO:
     MESSAGE 'El documento se encuentra Anulado...' VIEW-AS ALERT-BOX.
     RETURN 'ADM-ERROR'.
  END.
  IF Ccbcdocu.fmapgo <> '900' THEN DO:
      IF CcbCDocu.FlgEst = "C" AND Ccbcdocu.ImpTot > 0 THEN DO:
         MESSAGE 'El documento se encuentra Cancelado...' VIEW-AS ALERT-BOX.
         RETURN 'ADM-ERROR'.
      END.
  END.
  /* consistencia de la fecha del cierre del sistema */
  DEF VAR dFchCie AS DATE.
  RUN gn/fecha-de-cierre (OUTPUT dFchCie).
  IF ccbcdocu.fchdoc <= dFchCie THEN DO:
      MESSAGE 'NO se puede anular ningun documento antes del' (dFchCie + 1)
          VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  /* fin de consistencia */

  IF MONTH(Ccbcdocu.FchDoc) <> MONTH(TODAY) OR YEAR(Ccbcdocu.FchDoc) <> YEAR(TODAY) THEN DO:
    {adm/i-DocPssw.i s-CodCia s-CodDoc ""DEL""}
  END.
  
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
      DEF VAR cReturnValue AS CHAR NO-UNDO.
      RUN ccb/d-motanu (ccbcdocu.codcia, ccbcdocu.coddoc, ccbcdocu.nrodoc, s-user-id, OUTPUT cReturnValue).
      IF cReturnValue = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      /* TRACKING FACTURAS */
      RUN vtagn/pTracking-04 (s-CodCia,
                              Ccbcdocu.CodDiv,
                              Ccbcdocu.CodPed,
                              Ccbcdocu.NroPed,
                              s-User-Id,
                              'EFAC',
                              'A',
                              DATETIME(TODAY, MTIME),
                              DATETIME(TODAY, MTIME),
                              Ccbcdocu.coddoc,
                              Ccbcdocu.nrodoc,
                              Ccbcdocu.codref,
                              Ccbcdocu.nroref).

      /* Eliminamos el detalle */
/*       RUN Borra-Detalle.                                           */
/*       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
     
      FIND B-CDOCU WHERE ROWID(B-CDOCU) = ROWID(CcbCDocu) EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABL B-CDOCU THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN 
          B-CDOCU.FlgEst = "A"
          B-CDOCU.SdoAct = 0
          B-CDOCU.UsuAnu = S-USER-ID
          B-CDOCU.FchAnu = TODAY
          B-CDOCU.Glosa  = "A N U L A D O".
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
  
  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Ccbcdocu THEN DO WITH FRAME {&FRAME-NAME}:
      IF CcbCDocu.FlgEst = "P" THEN F-Estado:SCREEN-VALUE = "PENDIENTE".
      IF CcbCDocu.FlgEst = "A" THEN F-Estado:SCREEN-VALUE = "ANULADO".
      IF CcbCDocu.FlgEst = "C" THEN F-Estado:SCREEN-VALUE = "CANCELADO".
      F-NomVen:screen-value = "".
      FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
          AND  gn-ven.CodVen = Ccbcdocu.CodVen 
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
      F-CndVta:SCREEN-VALUE = "".
      FIND gn-convt WHERE gn-convt.Codig = Ccbcdocu.FmaPgo NO-LOCK NO-ERROR.
      IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
      IF ccbcdocu.fchvto < TODAY AND Ccbcdocu.FlgEst = 'P'
          THEN DISPLAY " VENCIDO " @ F-Estado WITH FRAME {&FRAME-NAME}.
      F-Nomtar:SCREEN-VALUE = ''.
      FIND FIRST Gn-Card WHERE Gn-Card.NroCard = Ccbcdocu.NroCar NO-LOCK NO-ERROR.
      IF AVAILABLE Gn-Card THEN F-NomTar:SCREEN-VALUE = GN-CARD.NomClie[1].
      FIND GN-ClieD WHERE GN-ClieD.CodCia = CL-CODCIA
          AND GN-ClieD.CodCli = Ccbcdocu.Codcli
          AND GN-ClieD.sede = Ccbcdocu.sede
          NO-LOCK NO-ERROR.
      IF AVAILABLE GN-ClieD 
          THEN ASSIGN FILL-IN-sede = GN-ClieD.dircli.
      ELSE ASSIGN FILL-IN-sede = "".
      DISPLAY FILL-IN-sede WITH FRAME {&FRAME-NAME}.
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
        /*Ccbcdocu.FlgCbd:SENSITIVE = NO*/
        /*Ccbcdocu.CodMon:SENSITIVE = NO*/
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'NO' THEN DO:
        ASSIGN
            Ccbcdocu.CodCli:SENSITIVE = NO
            ccbcdocu.fchvto:SENSITIVE = NO
            Ccbcdocu.FmaPgo:SENSITIVE = NO
            /*Ccbcdocu.FlgCbd:SENSITIVE = NO*/
            Ccbcdocu.TpoCmb:SENSITIVE = NO
            Ccbcdocu.NroCard:SENSITIVE = NO.
        IF s-CodDoc = 'BOL'
        THEN ASSIGN
            Ccbcdocu.DirCli:SENSITIVE = YES
            Ccbcdocu.NomCli:SENSITIVE = YES.
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
  
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  IF Ccbcdocu.FlgEst <> "A" THEN DO:
      RUN vtamay/r-cotiza-4 (ROWID(Ccbcdocu)).
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
    DO WITH FRAME {&FRAME-NAME}:
        CASE HANDLE-CAMPO:name:
            WHEN "" THEN ASSIGN input-var-1 = "".
            WHEN "" THEN ASSIGN input-var-2 = "".
            WHEN "" THEN ASSIGN input-var-3 = "".
            WHEN 'FmaPgo' THEN input-var-1 = ''.
            WHEN 'CodPos' THEN input-var-1 = 'CP'.
        END CASE.
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
  {src/adm/template/snd-list.i "Ccbcdocu"}

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
      /* VALIDACION DEL CLIENTE */
      IF Ccbcdocu.CodCli:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Codigo de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO Ccbcdocu.CodCli.
         RETURN "ADM-ERROR".   
      END.
      FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
          AND  gn-clie.CodCli = Ccbcdocu.CodCli:SCREEN-VALUE 
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-clie THEN DO:
         MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO Ccbcdocu.CodCli.
         RETURN "ADM-ERROR".   
      END.
      RUN vtagn/p-gn-clie-01 (Ccbcdocu.CodCli:SCREEN-VALUE , s-coddoc).
      IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
      IF LOOKUP(TRIM(SELF:SCREEN-VALUE), x-ClientesVarios) > 0
      THEN DO:
        MESSAGE 'Clientes varios NO permitidos' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO Ccbcdocu.CodCli.
        RETURN 'ADM-ERROR'.
      END.

     IF s-CodDoc = "FAC" AND Ccbcdocu.RucCli:SCREEN-VALUE = '' THEN DO:
        MESSAGE "El Cliente NO tiene R.U.C." VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.CodCli.
        RETURN "ADM-ERROR".   
     END.      
     /* RHC 23.06.10 COntrol de sedes por autoservicios
          Los clientes deben estar inscritos en la opcion DESCUENTOS E INCREMENTOS */
     FIND FacTabla WHERE FacTabla.codcia = s-codcia
         AND FacTabla.Tabla = 'AU'
         AND FacTabla.Codigo = Ccbcdocu.codcli:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE FacTabla AND Ccbcdocu.Sede:SCREEN-VALUE = '' THEN DO:
         MESSAGE 'Debe registrar la sede para este cliente' VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO Ccbcdocu.Sede.
         RETURN 'ADM-ERROR'.
     END.
     IF Ccbcdocu.Sede:SCREEN-VALUE <> '' THEN DO:
         FIND Gn-clied OF Gn-clie WHERE Gn-clied.Sede = Ccbcdocu.Sede:SCREEN-VALUE NO-LOCK NO-ERROR.
          IF NOT AVAILABLE gn-clied THEN DO:
              MESSAGE 'Sede no registrada para este cliente' VIEW-AS ALERT-BOX ERROR.
              APPLY "ENTRY" TO Ccbcdocu.Sede.
              RETURN 'ADM-ERROR'.
          END.
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
     f-Tot = DECIMAL(CcbCDocu.ImpTot:SCREEN-VALUE).
     IF f-Tot = 0 THEN DO:
        MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.ImpTot.
        RETURN "ADM-ERROR".   
     END.
     /* VALIDACION DE MONTO MINIMO POR BOLETA */
     F-BOL = IF INTEGER(Ccbcdocu.CodMon:SCREEN-VALUE) = 1 
             THEN f-Tot
             ELSE f-Tot * DECIMAL(Ccbcdocu.TpoCmb:SCREEN-VALUE).
     IF s-CodDoc = 'BOL' AND F-BOL > 700 
         AND (Ccbcdocu.CodAnt:SCREEN-VALUE = '' 
             OR LENGTH(Ccbcdocu.CodAnt:SCREEN-VALUE, "CHARACTER") < 8)
     THEN DO:
         MESSAGE "Venta Mayor a 700.00" SKIP
                 "Debe ingresar en DNI"
             VIEW-AS ALERT-BOX ERROR.
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

