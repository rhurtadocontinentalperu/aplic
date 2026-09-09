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

/* Public Variable Definitions ---                                       */
DEFINE SHARED TEMP-TABLE PEDI LIKE FacDPedi.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE CL-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-TERMINAL AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER INIT 1.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHARACTER.
DEFINE SHARED VARIABLE S-CNDVTA   AS CHAR.
DEFINE SHARED VARIABLE C-clfCli   AS CHAR.
DEFINE SHARED VARIABLE S-NROTAR   AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB AS DECIMAL.  
/* RHC 22-12-2003 */
DEFINE SHARED VARIABLE S-NROCOT   AS CHARACTER.

/* Local Variable Definitions ---                                       */

DEFINE BUFFER B-CPedi FOR FacCPedi.
DEFINE BUFFER B-DPedi FOR FacDPedi.
DEFINE BUFFER B-Pedi FOR PEDI.

DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-NROPED       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
/*DEFINE VARIABLE S-NROCOT       AS CHARACTER NO-UNDO.*/
DEFINE VARIABLE T-SALDO AS DECIMAL.
DEFINE VARIABLE F-totdias           AS INTEGER NO-UNDO.

/* RHC 12.01.05 Variable para controlar cuando 
                un pedido se ha generado a partir de una copia */
DEFINE VAR s-copia-registro AS LOGICAL INIT FALSE NO-UNDO.

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN I-NroSer = FacCorre.NroSer
          S-PRINTER-NAME = FacCorre.Printer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE VARIABLE F-Coddoc       AS CHAR NO-UNDO.
DEFINE VAR F-Orddes  AS CHAR NO-UNDO.
DEFINE VAR F-Fchent  AS DATE NO-UNDO.
DEFINE VAR F-FchVto  AS DATE NO-UNDO.
DEFINE VAR F-Codtra  AS CHAR NO-UNDO.
DEFINE VAR F-LugEnt  AS CHAR NO-UNDO.
DEFINE VAR F-LugEnt2 AS CHAR NO-UNDO.
DEFINE VAR F-Flgsit  AS CHAR NO-UNDO.

DEFINE VAR F-Observa AS CHAR NO-UNDO.

DEFINE VAR SW-OK AS LOGICAL NO-UNDO.

DEFINE VARIABLE dImpLCred LIKE Gn-ClieL.ImpLC NO-UNDO.
DEFINE VARIABLE lEnCampan AS LOGICAL NO-UNDO.

DEFINE stream entra .

DEFINE VAR x-ClientesVarios AS CHAR INIT '11111111,11111112'.

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
&Scoped-define EXTERNAL-TABLES FacCPedi
&Scoped-define FIRST-EXTERNAL-TABLE FacCPedi


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR FacCPedi.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS FacCPedi.TpoPed FacCPedi.CodCli ~
FacCPedi.NomCli FacCPedi.DirCli FacCPedi.CodPos FacCPedi.FchEnt ~
FacCPedi.LugEnt FacCPedi.ordcmp FacCPedi.CodVen FacCPedi.FmaPgo ~
FacCPedi.CodMon FacCPedi.Glosa FacCPedi.NroCard 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define ENABLED-OBJECTS RECT-22 C-TpoVta T-Especial 
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.TpoPed ~
FacCPedi.TpoLic FacCPedi.FchPed FacCPedi.CodCli FacCPedi.NomCli ~
FacCPedi.TpoCmb FacCPedi.DirCli FacCPedi.RucCli FacCPedi.NroRef ~
FacCPedi.CodPos FacCPedi.FchEnt FacCPedi.LugEnt FacCPedi.ordcmp ~
FacCPedi.CodVen FacCPedi.FmaPgo FacCPedi.CodMon FacCPedi.Glosa ~
FacCPedi.NroCard 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS F-Estado FILL-IN-Postal F-nOMvEN C-TpoVta ~
F-CndVta T-Especial F-Nomtar 

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
DEFINE VARIABLE C-TpoVta AS CHARACTER FORMAT "X(256)":U INITIAL "FAC" 
     LABEL "Tipo Venta" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "FAC","BOL" 
     DROP-DOWN-LIST
     SIZE 11.86 BY 1 NO-UNDO.

DEFINE VARIABLE F-CndVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE F-Nomtar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

DEFINE VARIABLE F-nOMvEN AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Postal AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 91 BY 7.31.

DEFINE VARIABLE T-Especial AS LOGICAL INITIAL no 
     LABEL "Venta Especial" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.NroPed AT ROW 1.19 COL 9 COLON-ALIGNED
          LABEL "Pedido" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .81
          FONT 0
     FacCPedi.TpoPed AT ROW 1.19 COL 29.29 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Total", "1":U,
"Programado", "2":U
          SIZE 17.57 BY .81
     FacCPedi.TpoLic AT ROW 1.19 COL 46.86
          LABEL "Licitación"
          VIEW-AS TOGGLE-BOX
          SIZE 10 BY .81
     F-Estado AT ROW 1.19 COL 55 COLON-ALIGNED NO-LABEL
     FacCPedi.FchPed AT ROW 1.19 COL 76 COLON-ALIGNED
          LABEL "Emisión"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.CodCli AT ROW 1.96 COL 9 COLON-ALIGNED
          LABEL "Cliente" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     FacCPedi.NomCli AT ROW 1.96 COL 20 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 40 BY .81
     FacCPedi.TpoCmb AT ROW 1.96 COL 76 COLON-ALIGNED
          LABEL "T/  Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.DirCli AT ROW 2.73 COL 9 COLON-ALIGNED
          LABEL "Dirección"
          VIEW-AS FILL-IN 
          SIZE 42 BY .81
     FacCPedi.RucCli AT ROW 2.73 COL 55 COLON-ALIGNED
          LABEL "RUC" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .81
     FacCPedi.NroRef AT ROW 2.73 COL 76 COLON-ALIGNED
          LABEL "Cotización"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.CodPos AT ROW 3.5 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FILL-IN-Postal AT ROW 3.5 COL 15 COLON-ALIGNED NO-LABEL
     FacCPedi.FchEnt AT ROW 3.5 COL 76 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.LugEnt AT ROW 4.27 COL 9 COLON-ALIGNED
          LABEL "Entregar en"
          VIEW-AS FILL-IN 
          SIZE 52 BY .81
     FacCPedi.ordcmp AT ROW 4.27 COL 76 COLON-ALIGNED
          LABEL "O/ Compra" FORMAT "X(12)"
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .81
     FacCPedi.CodVen AT ROW 5.04 COL 9 COLON-ALIGNED FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
     F-nOMvEN AT ROW 5.04 COL 15 COLON-ALIGNED NO-LABEL
     C-TpoVta AT ROW 5.04 COL 76 COLON-ALIGNED
     FacCPedi.FmaPgo AT ROW 5.81 COL 9 COLON-ALIGNED
          LABEL "Cond.Vta" FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
     F-CndVta AT ROW 5.81 COL 15 COLON-ALIGNED NO-LABEL
     FacCPedi.CodMon AT ROW 5.81 COL 78 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12.29 BY .81
     FacCPedi.Glosa AT ROW 6.58 COL 6.28 FORMAT "X(80)"
          VIEW-AS FILL-IN 
          SIZE 64 BY .81
     T-Especial AT ROW 6.58 COL 78
     FacCPedi.NroCard AT ROW 7.35 COL 9 COLON-ALIGNED
          LABEL "Tarjeta"
          VIEW-AS FILL-IN 
          SIZE 7.57 BY .81
     F-Nomtar AT ROW 7.35 COL 17 COLON-ALIGNED NO-LABEL
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 6 COL 72
     "Tipo" VIEW-AS TEXT
          SIZE 4.29 BY .5 AT ROW 1.23 COL 25
          FONT 6
     RECT-22 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.FacCPedi
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
         HEIGHT             = 8.73
         WIDTH              = 92.
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

/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.CodVen IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN FacCPedi.DirCli IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Nomtar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-nOMvEN IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FchPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FILL-IN-Postal IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FmaPgo IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.Glosa IN FRAME F-Main
   ALIGN-L EXP-FORMAT                                                   */
/* SETTINGS FOR FILL-IN FacCPedi.LugEnt IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroCard IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.NroRef IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.ordcmp IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.RucCli IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.TpoCmb IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX FacCPedi.TpoLic IN FRAME F-Main
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

&Scoped-define SELF-NAME C-TpoVta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-TpoVta V-table-Win
ON VALUE-CHANGED OF C-TpoVta IN FRAME F-Main /* Tipo Venta */
DO:
   ASSIGN C-tpovta.
   FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                 AND  gn-clie.CodCli = FacCPedi.Codcli:SCREEN-VALUE
                NO-LOCK NO-ERROR.

   IF NOT AVAILABLE Gn-Clie THEN DO:
      MESSAGE "Codigo de Cliente no existe " VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.   
   END.
   DO WITH FRAME {&FRAME-NAME}:
    IF C-Tpovta = "FAC" AND LENGTH(TRIM(FaccPedi.RucCli:SCREEN-VALUE)) <> 11 THEN APPLY "ENTRY" TO Faccpedi.Codcli.
    IF C-Tpovta = "BOL" THEN DISPLAY "" @ FacCPedi.Ruccli.
    IF c-TpoVta = "FAC"
    THEN DO:
        ASSIGN
            FacCPedi.DirCli:SENSITIVE = NO
            FacCPedi.NomCli:SENSITIVE = NO
            FacCPedi.DirCli:SCREEN-VALUE = GN-CLIE.DirCli
            FacCPedi.NomCli:SCREEN-VALUE = GN-CLIE.NomCli.
    END.
    ELSE DO:
        ASSIGN
            FacCPedi.DirCli:SENSITIVE = YES
            FacCPedi.NomCli:SENSITIVE = YES.
    END.
   END.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodCli V-table-Win
ON LEAVE OF FacCPedi.CodCli IN FRAME F-Main /* Cliente */
DO:
   FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                 AND  gn-clie.CodCli = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.

   IF NOT AVAILABLE Gn-Clie THEN DO:
      MESSAGE "Codigo de Cliente no existe " VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.   
   END.
   
/*   IF gn-clie.FlgSit = "I" THEN DO:
 *     MESSAGE "Cliente esta Inactivo" SKIP 
 *             "Procedemos a ACTIVARLO?"
 *             VIEW-AS ALERT-BOX QUESTION
 *             UPDATE rpta-1 AS LOG.
 *     IF rpta-1 = NO THEN RETURN NO-APPLY.
 *    END.*/
   IF gn-clie.FlgSit = "I" THEN DO:
      MESSAGE "Cliente esta Inactivo" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.

   IF gn-clie.FlgSit = "C" THEN DO:
      MESSAGE "Cliente esta Cesado" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   
  /* RHC 09.09.04 NO debe ser cliente varios */
/*    IF SELF:SCREEN-VALUE = FacCfgGn.CliVar
 *     THEN DO:
 *      MESSAGE 'Codigo de clientes varios NO permitido'
 *          VIEW-AS ALERT-BOX ERROR.
 *      RETURN NO-APPLY.
 *     END.*/
  IF LOOKUP(TRIM(SELF:SCREEN-VALUE), x-ClientesVarios) > 0
  THEN DO:
    MESSAGE 'Clientes varios NO permitidos' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO FacCPedi.CodCli.
    RETURN NO-APPLY.
  END.
   DO WITH FRAME {&FRAME-NAME}:   
    DISPLAY gn-clie.Nomcli @ FacCPedi.Nomcli
            gn-clie.Ruc    @ FacCPedi.Ruccli
            gn-clie.Dircli @ FacCPedi.Dircli
            /*gn-clie.CodVen @ FacCPedi.CodVen*/
            gn-clie.nrocard @ FacCPedi.NroCard.

    S-CODCLI = SELF:SCREEN-VALUE.
    
 
    /* Ubica la Condicion Venta */
    FIND gn-convt WHERE gn-convt.Codig = gn-clie.CndVta 
                  NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN DO:
         f-totdias = gn-convt.totdias.
    END.
    ELSE F-totdias = 0.

   END.

   RUN Procesa-Handle IN lh_Handle ('Recalculo').   
   RUN Procesa-Handle IN lh_Handle ('browse').

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodMon V-table-Win
ON VALUE-CHANGED OF FacCPedi.CodMon IN FRAME F-Main /* Cod!mon */
DO:
  S-CODMON = INTEGER(Faccpedi.CodMon:SCREEN-VALUE).
  RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodPos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodPos V-table-Win
ON LEAVE OF FacCPedi.CodPos IN FRAME F-Main /* Postal */
DO:
  FIND almtabla WHERE almtabla.tabla = 'CP'
    AND almtabla.codigo = INPUT {&SELF-NAME}
    NO-LOCK NO-ERROR.
  IF AVAILABLE almtabla
  THEN FILL-IN-Postal:SCREEN-VALUE = almtabla.nombre.
  ELSE FILL-IN-Postal:SCREEN-VALUE = ''.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodVen V-table-Win
ON LEAVE OF FacCPedi.CodVen IN FRAME F-Main /* Vendedor */
DO:
  F-NomVen = "".
  IF FacCPedi.CodVen:SCREEN-VALUE <> "" THEN DO: 
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA AND 
          gn-ven.CodVen = FacCPedi.CodVen:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
  END.
  DISPLAY F-NomVen WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.DirCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.DirCli V-table-Win
ON LEAVE OF FacCPedi.DirCli IN FRAME F-Main /* Dirección */
DO:
  IF FacCPedi.LugEnt:SCREEN-VALUE = ''
  THEN FacCPedi.LugEnt:SCREEN-VALUE = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FmaPgo V-table-Win
ON LEAVE OF FacCPedi.FmaPgo IN FRAME F-Main /* Cond.Vta */
DO:
   S-CNDVTA = FacCPedi.FmaPgo:SCREEN-VALUE.

   /* RHC 23-02-04 Verificamos que el cliente sea el correcto */   
   FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                 AND  gn-clie.CodCli = FacCPedi.CodCli:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Gn-Clie THEN DO:
      MESSAGE "Ingrese correctamente el Código del Cliente" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY":U TO FacCPedi.CodCli.
      RETURN NO-APPLY.   
   END.
    /* Ubica la Condicion Venta */
    FIND gn-convt WHERE gn-convt.Codig = gn-clie.CndVta 
                  NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN DO:
         f-totdias = gn-convt.totdias.
    END.
    ELSE F-totdias = 0.
   /* ******************************************************* */
   
   IF FacCPedi.FmaPgo:SCREEN-VALUE <> "" THEN DO:
      F-CndVta:SCREEN-VALUE = "".
      S-CNDVTA = FacCPedi.FmaPgo:SCREEN-VALUE.

      IF FacCPedi.FmaPgo:SCREEN-VALUE <> "000" AND FacCPedi.FmaPgo:SCREEN-VALUE <> "001" AND FacCPedi.FmaPgo:SCREEN-VALUE <> "002" THEN DO:
        IF gn-clie.FlgSit = "I" THEN DO:
           MESSAGE "Cliente esta Inactivo" VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO FacCPedi.FmaPgo.
           RETURN NO-APPLY.
        END.
      END.
      
    IF LOOKUP(FacCPedi.FmaPgo:SCREEN-VALUE,"000,001,002") = 0 THEN DO:
        dImpLCred = 0.
        lEnCampan = FALSE.
        FIND gn-clie WHERE
            gn-clie.CodCia = CL-CODCIA AND
            gn-clie.CodCli = FacCPedi.CodCli:SCREEN-VALUE 
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            /* Línea Crédito Campaña */
            FOR EACH Gn-ClieL WHERE
                Gn-ClieL.CodCia = gn-clie.codcia AND
                Gn-ClieL.CodCli = gn-clie.codcli AND
                Gn-ClieL.FchIni >= TODAY AND
                Gn-ClieL.FchFin <= TODAY NO-LOCK:
                dImpLCred = dImpLCred + Gn-ClieL.ImpLC.
                lEnCampan = TRUE.
            END.
            /* Línea Crédito Normal */
            IF NOT lEnCampan THEN dImpLCred = gn-clie.ImpLC.
        END.
        IF dImpLCred <= 0 THEN DO:
            MESSAGE
                " Cliente no Tiene Línea de Crédito " SKIP
                " Solicitar en Administración "
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO integral.FacCPedi.FmaPgo.
            RETURN NO-APPLY.
        END.

    END.
      FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF AVAILABLE gn-convt THEN DO:
         F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
         IF gn-convt.totdias > F-totdias THEN DO:
            MESSAGE " Condicion Credito es Mayor al Asignado " VIEW-AS ALERT-BOX ERROR.
            /*RETURN NO-APPLY.*/
         END.
         IF LOOKUP(FacCPedi.FmaPgo:SCREEN-VALUE,"000,001,002") = 0 THEN DO:
            RUN Calcula-importes.            
            IF SW-OK THEN DO:
                MESSAGE "Tiene Documentos Vencidos" SKIP
                        "Comuniquese con el Dpto de Creditos y Cobranzas" SKIP
                        "Continue con la operacion......." 
                        VIEW-AS ALERT-BOX WARNING.
                /*
                APPLY "ENTRY" TO FacCPedi.FmaPgo IN FRAME {&FRAME-NAME}.
                RETURN NO-APPLY.
                */
            END.
            T-SALDO = 0.
            FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                          AND  gn-clie.CodCli = FacCPedi.CodCli:SCREEN-VALUE 
                         NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clie THEN DO:
               run vta\lincre (gn-clie.CodCli,0,OUTPUT T-SALDO).
               IF RETURN-VALUE <> "OK" THEN DO:
                  MESSAGE "Linea de Crédito agotada. " SKIP(1)
                          "Verifique su Cta.Cte. o   " SKIP
                          "Pedidos Crédito Pendientes" SKIP
                          VIEW-AS ALERT-BOX WARNING.
                  RETURN NO-APPLY.
               END.
            END.
         END.
      END.
   END.
   ELSE F-CndVta:SCREEN-VALUE = "".
   IF SELF:SCREEN-VALUE = '900' 
   THEN FacCPedi.Glosa:SCREEN-VALUE = 'Bonificacion de cliente con tarjeta exclusiva'.
   RUN Procesa-Handle IN lh_Handle ('Recalculo').

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.NroCard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.NroCard V-table-Win
ON LEAVE OF FacCPedi.NroCard IN FRAME F-Main /* Tarjeta */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
  FIND Gn-Card WHERE Gn-Card.NroCard = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.

     IF NOT AVAILABLE Gn-Card THEN DO:
        S-NROTAR = SELF:SCREEN-VALUE.
        RUN VTA\D-RegCar.R (INPUT S-NROTAR).
        IF S-NROTAR = "" THEN DO:
            APPLY "ENTRY" TO Faccpedi.NroCard.
            RETURN NO-APPLY.
        END.
        FIND Gn-Card WHERE Gn-Card.NroCard = SELF:SCREEN-VALUE 
                           NO-LOCK NO-ERROR.
  
     END.
  DO WITH FRAME {&FRAME-NAME}:
     IF AVAILABLE Gn-Card THEN DO:
        DISPLAY Gn-Card.NroCard @ Faccpedi.NroCard
                Gn-Card.nomclie[1] @ F-Nomtar.
     END.
  END.
  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-Especial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-Especial V-table-Win
ON VALUE-CHANGED OF T-Especial IN FRAME F-Main /* Venta Especial */
DO:
  ASSIGN T-Especial.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Cotizacion V-table-Win 
PROCEDURE Actualiza-Cotizacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE I-NRO AS INTEGER INIT 0 NO-UNDO.
  DEFINE BUFFER B-DPedi FOR FacDPedi.

  /*MESSAGE S-NroCot VIEW-AS ALERT-BOX.*/
  FOR EACH facdPedi OF faccPedi NO-LOCK:
      FIND B-DPedi WHERE B-DPedi.CodCia = faccPedi.CodCia 
                    AND  B-DPedi.CodDoc = "COT" 
                    AND  B-DPedi.NroPed = FacCPedi.NroRef   /*B-DPedi.NroPed = S-NroCot */
                    AND  B-DPedi.CodMat = FacDPedi.CodMat 
                   EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE B-DPedi 
      THEN B-DPedi.CanAte = B-DPedi.CanAte + FacDPedi.CanPed.
      RELEASE B-DPedi.
  END.
  FOR EACH FacDPedi NO-LOCK WHERE FacDPedi.CodCia = S-CODCIA 
                             AND  FacDPedi.CodDoc = "COT" 
                             AND  FacDPedi.NroPed = FacCPedi.NroRef:     /*FacDPedi.NroPed = S-NroCot:*/
      IF (FacDPedi.CanPed - FacDPedi.CanAte) > 0 
      THEN DO:
         I-NRO = 1.
         LEAVE.
      END.
  END.
  /* RHC 22-03-2003 */
  /* ******************************
  IF I-NRO = 0 THEN DO TRANSACTION:
     FIND B-CPedi WHERE B-CPedi.CodCia = S-CODCIA 
                   AND  B-CPedi.CodDiv = S-CODDIV 
                   AND  B-CPedi.CodDoc = "COT" 
                   AND  B-CPedi.NroPed = FacCPedi.NroRef        /*B-CPedi.NroPed = S-NroCot */
                  EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE B-CPedi THEN ASSIGN B-CPedi.FlgEst = "C".
     RELEASE B-CPedi.
  END.
  ******************************** */
  DO TRANSACTION:
    FIND B-CPedi WHERE B-CPedi.CodCia = S-CODCIA 
        AND  B-CPedi.CodDiv = S-CODDIV 
        AND  B-CPedi.CodDoc = "COT" 
        AND  B-CPedi.NroPed = FacCPedi.NroRef        /*B-CPedi.NroPed = S-NroCot */
        EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE B-CPedI
    THEN DO:
        IF I-NRO = 0 
        THEN ASSIGN B-CPedi.FlgEst = "C".
        ELSE ASSIGN B-CPedi.FlgEst = "P".
        RELEASE B-CPedi.
    END.     
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Item V-table-Win 
PROCEDURE Actualiza-Item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF output-var-1 <> ? THEN 
    FIND faccPedi WHERE ROWID(faccPedi) = output-var-1 NO-LOCK NO-ERROR.

FOR EACH PEDI:
    DELETE PEDI.
END.
IF NOT L-CREA THEN DO:
   FOR EACH facdPedi OF faccPedi NO-LOCK
    where trim(facdPedi.codmat) ne "" :
       CREATE PEDI.
       RAW-TRANSFER facdpedi TO PEDI.
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
  {src/adm/template/row-list.i "FacCPedi"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "FacCPedi"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Cotizacion V-table-Win 
PROCEDURE Asigna-Cotizacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE F-CANPED AS DECIMAL NO-UNDO.
DEFINE VARIABLE S-STKDIS AS DECIMAL NO-UNDO.
DEFINE VARIABLE S-OK     AS LOGICAL NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:  
    IF NOT FacCPedi.CodCli:SENSITIVE THEN RETURN "ADM-ERROR".
    FIND FIRST PEDI NO-LOCK NO-ERROR.
    IF AVAILABLE PEDI THEN RETURN "ADM-ERROR".
    S-NroCot = "".
    input-var-1 = "COT".
    input-var-2 = FacCPedi.CodCli:SCREEN-VALUE.
    RUN lkup\C-Pedido.r("Cotizaciones Pendientes").
    IF output-var-1 = ? THEN RETURN "ADM-ERROR".
    RUN Actualiza-Item.
    S-NroCot = SUBSTRING(output-var-2,4,9).
    FIND B-CPedi WHERE B-CPedi.CodCia = S-CODCIA 
                  AND  B-CPedi.CodDiv = S-CODDIV 
                  AND  B-CPedi.CodDoc = "COT" 
                  AND  B-CPedi.NroPed = s-NroCot 
                 NO-LOCK NO-ERROR.
    F-NomVen = "".
    F-CndVta = "".
    FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
                 AND  gn-ven.CodVen = B-CPedi.CodVen 
                NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
    FIND gn-convt WHERE gn-convt.Codig = B-CPedi.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN F-CndVta = gn-convt.Nombr.
    DISPLAY 
     B-CPedi.FmaPgo @ FacCPedi.FmaPgo
     B-CPedi.CodVen @ FaccPedi.CodVen
     B-CPedi.ordcmp @ FacCPedi.ordcmp
     B-CPedi.TpoCmb @ Faccpedi.Tpocmb           
     F-NomVen
     F-CndVta
     s-NroCot @ FaccPedi.NroRef
     B-CPedi.NomCli @ FacCPedi.NomCli
     B-CPedi.DirCli @ FacCPedi.DirCli
     B-CPedi.FchEnt @ FacCPedi.FchEnt
     B-CPedi.CodPos @ FacCPedi.CodPos.
    IF B-CPedi.CodCli <> FacCfgGn.CliVar     /* NO Clientes Varios */
    THEN DO:
        FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
            AND gn-clie.CodCli = B-CPedi.CodCli
            NO-LOCK NO-ERROR.
        IF AVAILABLE GN-CLIE
        THEN DISPLAY
                gn-clie.nomcli @ FacCPedi.NomCli
                gn-clie.dircli @ FacCPedi.DirCli
                gn-clie.codpos WHEN gn-clie.codpos <> '' @ FacCPedi.CodPos .
    END.            
   /*C-TpoVta:SCREEN-VALUE = ENTRY(INTEGER(B-CPedi.TipVta),C-TpoVta:LIST-ITEMS).*/
   IF INTEGER(B-CPedi.TipVta) <= 2
   THEN c-TpoVta:SCREEN-VALUE = ENTRY(1,c-TpoVta:LIST-ITEMS).
   ELSE c-TpoVta:SCREEN-VALUE = ENTRY(2,c-TpoVta:LIST-ITEMS).
   FaccPedi.CodMon:SCREEN-VALUE = STRING(B-CPedi.CodMon).
   F-FchVto = B-CPedi.FchVen.
   S-TPOCMB = B-CPedi.TpoCmb.
   S-CNDVTA = B-CPedi.FmaPgo.
   s-CodMon = B-CPedi.CodMon.
      
   /* DETALLES */
   FOR EACH FacDPedi NO-LOCK WHERE FacDPedi.CodCia = S-CODCIA 
                              AND  FacDPedi.CodDoc = "COT" 
                              AND  FacDPedi.NroPed = S-NroCot 
                              AND  (FacDPedi.CanPed - FacDPedi.CanAte) > 0:
       F-CANPED = (FacDPedi.CanPed - FacDPedi.CanAte).
       RUN vta/stkdispo (s-codcia, 
                         s-codalm, 
                         FacDPedi.codmat, 
                         FacDPedi.Factor * F-CANPED ,
                         OUTPUT S-OK, 
                         OUTPUT S-STKDIS
                         ).
       IF NOT S-OK THEN F-CANPED = S-STKDIS / FacDPedi.Factor.  /* OJO RHC 22-12-2003 */
       IF F-CANPED > 0 
       THEN DO:
          CREATE PEDI.
          ASSIGN PEDI.CodCia = facdPedi.CodCia 
                 PEDI.codmat = facdPedi.codmat 
                 PEDI.almdes = FacDPedi.almdes
                 PEDI.Factor = facdPedi.Factor 
                 PEDI.CanPed = F-CANPED
                 PEDI.NroItm = facdPedi.NroItm 
                 PEDI.PorDto = facdPedi.PorDto 
                 PEDI.PreBas = FacdPedi.PreBas 
                 PEDI.PreUni = facdPedi.PreUni 
                 PEDI.UndVta = facdPedi.UndVta
                 PEDI.AftIgv = FacdPedi.AftIgv 
                 PEDI.AftIsc = FacdPedi.AftIsc 
                 PEDI.ImpIgv = FacdPedi.ImpIgv 
                 PEDI.ImpIsc = FacdPedi.ImpIsc 
                 PEDI.ImpDto = facdPedi.ImpDto 
                 PEDI.ImpLin = facdPedi.ImpLin.
          IF PEDI.CanPed <> facdPedi.CanPed THEN DO:
             FIND Almmmatg WHERE Almmmatg.CodCia = PEDI.CodCia 
                            AND  Almmmatg.codmat = PEDI.codmat 
                           NO-LOCK NO-ERROR.
             PEDI.ImpDto = ROUND( PEDI.PreUni * (PEDI.PorDto / 100) * PEDI.CanPed , 2 ).
             PEDI.ImpLin = ROUND( PEDI.PreUni * PEDI.CanPed , 2 ) - PEDI.ImpDto.
             IF PEDI.AftIsc THEN 
                PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
             IF PEDI.AftIgv THEN  
                PEDI.ImpIgv = PEDI.ImpLin - ROUND(PEDI.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
          END.
       END.
   END.
   FacCPedi.CodCli:SENSITIVE = NO.
   FacCPedi.FmaPgo:SENSITIVE = NO.
   FacCPedi.CodMon:SENSITIVE = NO.
   
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Pedido V-table-Win 
PROCEDURE Borra-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    DELETE FROM FacDPedi WHERE FacDPedi.codcia = FacCPedi.codcia 
                          AND  FacDPedi.coddoc = FacCPedi.coddoc 
                          AND  FacDPedi.nroped = FacCPedi.nroped.
    */
    /* RHC 22-03-2003 */
    FOR EACH FAcDPedi WHERE FacDPedi.codcia = FacCPedi.codcia 
            AND  FacDPedi.coddoc = FacCPedi.coddoc 
            AND  FacDPedi.nroped = FacCPedi.nroped:
        IF FacCPedi.NroRef <> ''    /* Extorno de la Cotizacion */
        THEN DO:
            FIND B-DPedi WHERE B-DPedi.CodCia = faccPedi.CodCia 
                AND  B-DPedi.CodDoc = "COT" 
                AND  B-DPedi.NroPed = FacCPedi.NroRef   /*B-DPedi.NroPed = S-NroCot */
                AND  B-DPedi.CodMat = FacDPedi.CodMat 
                EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE B-DPedi 
            THEN B-DPedi.CanAte = B-DPedi.CanAte - FacDPedi.CanPed.
            RELEASE B-DPedi.
        END.
        DELETE FacDPedi.
    END.                          

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-importes V-table-Win 
PROCEDURE Calcula-importes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR I-DIAS   AS INTEGER NO-UNDO.

DEFINE VAR w-cambio AS INTEGER NO-UNDO.

DEFINE VAR F-lincre AS DECIMAL.
DEFINE VAR F-creusa AS DECIMAL.
DEFINE VAR F-credis AS DECIMAL.
DEFINE VAR F-TotDol AS DECIMAL.
DEFINE VAR F-TotSol AS DECIMAL.

DEFINE VAR F-TpoVSo AS DECIMAL.
DEFINE VAR F-TVenSo AS DECIMAL.
DEFINE VAR F-TotS0  AS DECIMAL.

DEFINE VAR r-TpoDoc AS LOGICAL INITIAL TRUE.

DEFINE  VAR F-FlgEst AS CHAR NO-UNDO.
F-Flgest = 'P'.
DEFINE  VAR S-DOCUMEN AS CHAR.

/*ASSIGN F-TpoVDo = 0 
 *        F-TvenDo = 0 
 *        F-TotD0  = 0 
 *        F-TotD15 = 0 
 *        F-TotD30 = 0 
 *        F-TotD45 = 0 
 *        F-TotD60 = 0 
 *        F-TotS15 = 0
 *        F-TotS30 = 0 
 *        F-TotS45 = 0
 *        F-TotS60 = 0*/

ASSIGN F-CreUsa = 0
       F-CreDis = 0
       F-TotDol = 0 
       F-TotSol = 0
       F-TpoVSo = 0 
       F-TVenSo = 0 
       F-TotS0  = 0.
     
FIND FIRST FacCfgGn NO-LOCK NO-ERROR.
      IF AVAILABLE FacCfgGn THEN 
            w-cambio = FacCfgGn.Tpocmb[1].
      ELSE  w-cambio = 0.     

SW-OK = FALSE.

FIND FIRST CcbCDocu WHERE CcbCDocu.CodCia = s-CodCia
                     AND  CcbCDocu.CodCli = gn-clie.CodCli
                     AND  LOOKUP(CcbCDocu.CodDoc, "FAC,BOL,CHQ,LET,N/D") > 0 /* BEGINS f-CodDoc */
                     AND  CcbCDocu.FlgEst BEGINS f-FlgEst 
                     AND  CcbCDocu.FchVto <= TODAY
                    NO-LOCK NO-ERROR. 
IF AVAIL CcbCDocu THEN DO:
    SW-OK = TRUE.
    RETURN.
END.
        
/*FOR EACH CcbCDocu WHERE CcbCDocu.CodCia = s-CodCia
 *                    AND  CcbCDocu.CodCli = gn-clie.CodCli
 *                    AND  CcbCDocu.CodDiv = s-CodDiv 
 *                    AND  CcbCDocu.CodDoc BEGINS f-CodDoc 
 *                    AND  CcbCDocu.FlgEst BEGINS f-FlgEst 
 *                   NO-LOCK,
 *     FIRST FacDocum OF CcbCDocu
 *                   WHERE FacDocum.TpoDoc = r-TpoDoc NO-LOCK :
 *     CASE CcbCDocu.CodMon :           
 *          WHEN 1 THEN DO :
 *                 F-TotSol = F-TotSol + CcbCDocu.SdoAct.
 *                 /* por vencer */
 * /*                IF CcbCDocu.FchVto >= TODAY THEN F-TpoVSo = F-TpoVSo + CcbCDocu.SdoAct.
 *  *                 /* Vencido */
 *  *                 IF CcbCDocu.FchVto < TODAY THEN DO:
 *  *                    F-TVenSo = F-TVenSo + CcbCDocu.SdoAct. 
 *  *                    I-DIAS = TODAY - CcbCDocu.FchVto.
 *  *                    CASE (I-DIAS > 0):
 *  *                         WHEN YES AND I-DIAS <= 15 THEN 
 *  *                              F-TotS0  = F-TotS0 + CcbCDocu.SdoAct.
 *  *                         WHEN YES AND I-DIAS > 15 AND I-DIAS <= 30 THEN 
 *  *                              F-TotS15  = F-TotS15 + CcbCDocu.SdoAct.
 *  *                         WHEN YES AND I-DIAS > 30 AND I-DIAS <= 45 THEN 
 *  *                              F-TotS30  = F-TotS30 + CcbCDocu.SdoAct.
 *  *                         WHEN YES AND I-DIAS > 45 AND I-DIAS <= 60 THEN 
 *  *                              F-TotS45  = F-TotS45 + CcbCDocu.SdoAct.
 *  *                         WHEN YES AND I-DIAS > 60 THEN 
 *  *                              F-TotS60  = F-TotS60 + CcbCDocu.SdoAct.
 *  *                    END CASE.
 *  *                 END.*/
 *            END.     
 *          WHEN 2 THEN DO :
 *                 F-TotDol = F-TotDol + CcbCDocu.SdoAct.
 *                 /* por vencer */
 * /*                IF CcbCDocu.FchVto >= TODAY THEN F-TpoVDo = F-TpoVDo + CcbCDocu.SdoAct.
 *  *                 /* Vencido */
 *  *                 IF CcbCDocu.FchVto < TODAY THEN DO:
 *  *                    F-TVenDo = F-TVenDo + CcbCDocu.SdoAct.   
 *  *                    I-DIAS = TODAY - CcbCDocu.FchVto.
 *  *                    CASE (I-DIAS > 0):
 *  *                         WHEN YES AND I-DIAS <= 15 THEN 
 *  *                              F-TotD0  = F-TotD0 + CcbCDocu.SdoAct.
 *  *                         WHEN YES AND I-DIAS > 15 AND I-DIAS <= 30 THEN 
 *  *                              F-TotD15  = F-TotD15 + CcbCDocu.SdoAct.
 *  *                         WHEN YES AND I-DIAS > 30 AND I-DIAS <= 45 THEN 
 *  *                              F-TotD30  = F-TotD30 + CcbCDocu.SdoAct.
 *  *                         WHEN YES AND I-DIAS > 45 AND I-DIAS <= 60 THEN 
 *  *                              F-TotD45  = F-TotD45 + CcbCDocu.SdoAct.
 *  *                         WHEN YES AND I-DIAS > 60 THEN 
 *  *                              F-TotD60  = F-TotD60 + CcbCDocu.SdoAct.
 *  *                    END CASE.
 *  *                 END.*/
 *            END.
 *     END CASE .
 * END.
 * 
 * CASE gn-clie.MonLC:  
 *      WHEN 1 THEN 
 *           F-CreUsa = ( F-TotDol * w-cambio ) + F-TotSol.
 *      WHEN 2 THEN 
 *           F-CreUsa = ( F-TotSol / w-cambio ) + F-TotDol.
 *      WHEN 0 THEN 
 *           F-CreUsa = ( F-TotSol / w-cambio ) + F-TotDol.
 * END CASE.           
 * 
 * F-CreDis = gn-clie.ImpLC - F-CreUsa.
 * F-LinCre = gn-clie.ImpLC.
 * 
 * IF F-CreDis < 0 THEN DO:
 *     MESSAGE "LINEA DE CREDITO SOBREGIRADO"
 *             VIEW-AS ALERT-BOX WARNING.
 *     APPLY "ENTRY" TO FacCPedi.CodCli IN FRAME {&FRAME-NAME}.
 *     RETURN NO-APPLY.
 * END.
 * 
 * /*
 * MESSAGE F-LinCre F-CreUsa F-CreDis VIEW-AS ALERT-BOX.
 * */*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Orden-Despacho V-table-Win 
PROCEDURE Genera-Orden-Despacho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  F-CODDOC = 'O/D'.
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                 AND  FacCorre.CodDoc = F-CODDOC 
                 AND  FacCorre.CodDiv = trim(S-CODDIV) 
                EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE FacCorre THEN DO:
     I-NroPed = FacCorre.Correlativo.
     CREATE B-CPedi.
     ASSIGN 
        B-CPedi.codcia = s-codcia
        B-CPedi.coddoc = F-Coddoc
        B-CPedi.nroped = STRING(I-NroSer,"999") + STRING(I-NroPed,"999999")
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
  END.
  RELEASE FacCorre.
  ASSIGN 
     B-CPedi.FchPed = FacCPedi.Fchped
     B-CPedi.CodAlm = trim(S-CODALM)
     B-CPedi.PorIgv = FacCfgGn.PorIgv 
     B-CPedi.TpoCmb = FacCfgGn.TpoCmb[1] 
     B-CPedi.CodDiv = trim(S-CODDIV)
     B-CPedi.Nroref = FacCPedi.NroPed
     B-CPedi.Hora   = STRING(TIME,"HH:MM")
     B-CPedi.Usuario = S-USER-ID
     B-CPedi.TipVta = FacCPedi.Tipvta
     B-CPedi.Codcli = FacCPedi.Codcli
     B-CPedi.NomCli = FacCPedi.Nomcli
     B-CPedi.DirCli = FacCPedi.DirCli
     B-CPedi.Codven = FacCPedi.Codven
     B-CPedi.Fmapgo = FacCPedi.Fmapgo
     B-CPedi.Fchven = F-Fchent
     B-CPedi.Tpocmb = FacCPedi.Tpocmb
     B-CPedi.Glosa  = FacCPedi.Glosa
     B-CPedi.CodTrans = F-Codtra
     B-CPedi.LugEnt = F-Lugent
     B-CPedi.LugEnt2 = F-Lugent2
     B-CPedi.Flgsit = IF F-flgsit = "2" THEN "P" ELSE ""
     B-CPEDI.ImpBrt = FacCPedi.ImpBrt
     B-CPEDI.ImpDto = FacCPedi.ImpDto
     B-CPEDI.ImpVta = FacCPedi.ImpVta
     B-CPEDI.ImpExo = FacCPedi.ImpExo
     B-CPEDI.ImpIgv = FacCPedi.ImpIgv
     B-CPEDI.ImpIsc = FacCPedi.ImpIsc
     B-CPEDI.ImpFle = FacCPedi.ImpFle
     B-CPEDI.ImpTot = FacCPedi.ImpTot.
     
  RUN Genera-Orden-Detalle.
  
  DEFINE VARIABLE I-NRO AS INTEGER INIT 0 NO-UNDO.
  FOR EACH FacDPedi OF B-CPedi NO-LOCK:
      FIND B-DPedi WHERE B-DPedi.CodCia = FacCPedi.CodCia 
                    AND  B-DPedi.CodDoc = FacCPedi.Coddoc 
                    AND  B-DPedi.NroPed = FacCPedi.Nroped 
                    AND  B-DPedi.CodMat = trim(FacDPedi.CodMat) 
                   EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE B-DPedi THEN DO:
         B-DPedi.CanAte = B-DPedi.CanAte + (FacDPedi.CanPed).
      END.
      RELEASE B-DPedi.
  END.
  FOR EACH FacDPedi NO-LOCK WHERE FacDPedi.CodCia = S-CODCIA 
                             AND  FacDPedi.CodDoc = FacCPedi.coddoc 
                             AND  FacDPedi.NroPed = FacCPedi.nroped:
      IF (FacDPedi.CanPed - FacDPedi.CanAte) > 0 THEN DO:
         I-NRO = 1.
         LEAVE.
      END.
  END.
     FIND B-CPedi WHERE B-CPedi.CodCia = S-CODCIA 
                   AND  B-CPedi.CodDiv = FacCPedi.Coddiv 
                   AND  B-CPedi.CodDoc = FacCPedi.Coddoc 
                   AND  B-CPedi.NroPed = FacCPedi.Nroped 
                  EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE B-CPedi THEN ASSIGN B-CPedi.FlgEst = IF I-NRO = 0 THEN "C" ELSE "P".
  RELEASE B-CPedi.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Orden-Detalle V-table-Win 
PROCEDURE Genera-Orden-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.
   FOR EACH FacDPedi OF FacCPedi NO-LOCK BY FacDPedi.NroItm: 
       CREATE B-DPedi. 
       ASSIGN B-DPedi.CodCia = B-CPedi.CodCia 
              B-DPedi.coddiv = B-CPedi.coddiv 
              B-DPedi.coddoc = B-CPedi.coddoc 
              B-DPedi.NroPed = B-CPedi.NroPed 
              B-DPedi.FchPed = B-CPedi.FchPed
              B-DPedi.Hora   = B-CPedi.Hora 
              B-DPedi.FlgEst = B-CPedi.FlgEst
              B-DPedi.tipvta = FacDPedi.tipvta
              B-DPedi.codmat = trim(FacDPedi.codmat) 
              B-DPedi.Factor = FacDPedi.Factor 
              B-DPedi.CanPed = FacDPedi.CanPed 
              B-DPedi.Pesmat = FacDPedi.Pesmat
              B-DPedi.ImpDto = FacDPedi.ImpDto 
              B-DPedi.ImpLin = FacDPedi.ImpLin 
              B-DPedi.NroItm = FacDPedi.Nroitm 
              B-DPedi.PorDto = FacDPedi.PorDto 
              B-DPedi.PorDto2 = FacDPedi.PorDto2 
              B-DPedi.MrgUti = FacDPedi.MrgUti
              B-DPedi.PreUni = FacDPedi.PreUni 
              B-DPedi.UndVta = trim(FacDPedi.UndVta) 
              B-DPedi.AftIgv = FacDPedi.AftIgv 
              B-DPedi.AftIsc = FacDPedi.AftIsc 
              B-DPedi.ImpIgv = FacDPedi.ImpIgv 
              B-DPedi.ImpIsc = FacDPedi.ImpIsc 
              B-DPedi.PreBas = FacDPedi.PreBas. 
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Pedido V-table-Win 
PROCEDURE Genera-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.
   RUN Borra-Pedido. 
   FOR EACH PEDI NO-LOCK BY PEDI.NroItm: 
       I-NITEM = I-NITEM + 1.
       CREATE FacDPedi. 
       ASSIGN FacDPedi.CodCia = FacCPedi.CodCia 
              FacDPedi.coddiv = FacCPedi.coddiv 
              FacDPedi.coddoc = FacCPedi.coddoc 
              FacDPedi.NroPed = FacCPedi.NroPed 
              FacDPedi.FchPed = FacCPedi.FchPed
              FacDPedi.Hora   = FacCPedi.Hora 
              FacDPedi.FlgEst = FacCPedi.FlgEst
              FacDPedi.codmat = trim(PEDI.codmat) 
              FacDPedi.Factor = PEDI.Factor 
              FacDPedi.CanPed = PEDI.CanPed 
              FacDPedi.CanAte = PEDI.CanAte
              FacDPedi.ImpDto = PEDI.ImpDto 
              FacDPedi.ImpLin = PEDI.ImpLin 
              FacDPedi.NroItm = I-NITEM 
              FacDPedi.PorDto = PEDI.PorDto 
              FacDPedi.PreUni = PEDI.PreUni 
              FacDPedi.UndVta = trim(PEDI.UndVta) 
              FacDPedi.AftIgv = PEDI.AftIgv 
              FacDPedi.AftIsc = PEDI.AftIsc 
              FacDPedi.ImpIgv = PEDI.ImpIgv 
              FacDPedi.ImpIsc = PEDI.ImpIsc 
              FacDPedi.PreBas = PEDI.PreBas
              FacDPedi.AlmDes = trim(PEDI.AlmDes)
              FacDPedi.Por_Dsctos[3] = PEDI.Por_Dsctos[3]. 
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
DO TRANSACTION:
   DEFINE VARIABLE X-STANDFORD AS DECIMAL NO-UNDO.
   DEFINE VARIABLE X-LINEA1    AS DECIMAL NO-UNDO.
   DEFINE VARIABLE X-OTROS     AS DECIMAL NO-UNDO.
   DEFINE VARIABLE X-AFECTO    AS DECIMAL NO-UNDO.
   DEFINE VARIABLE X-DTO1      AS DECIMAL NO-UNDO.
   DEFINE VARIABLE X-DTO2      AS DECIMAL NO-UNDO.

   DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
   DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.
   FIND B-CPEDI WHERE ROWID(B-CPEDI) = ROWID(FacCPedi) EXCLUSIVE-LOCK NO-ERROR.
   B-CPEDI.ImpDto = 0.
   B-CPEDI.ImpIgv = 0.
   B-CPEDI.ImpIsc = 0.
   B-CPEDI.ImpTot = 0.
   B-CPEDI.ImpExo = 0.
   B-CPEDI.Importe[1] = 0.
   B-CPEDI.Importe[2] = 0.
   B-CPEDI.Importe[3] = 0.
   FOR EACH PEDI NO-LOCK: 
       B-CPEDI.ImpDto = B-CPEDI.ImpDto + PEDI.ImpDto.
       F-Igv = F-Igv + PEDI.ImpIgv.
       F-Isc = F-Isc + PEDI.ImpIsc.
       B-CPEDI.ImpTot = B-CPEDI.ImpTot + PEDI.ImpLin.
       IF NOT PEDI.AftIgv THEN B-CPEDI.ImpExo = B-CPEDI.ImpExo + PEDI.ImpLin.
       /******************Identificacion de Importes para Descuento**********/
        FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND 
                            Almmmatg.Codmat = PEDI.CodMat NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmatg THEN DO:
           IF Almmmatg.CodFam = "002" AND Almmmatg.SubFam = "012" AND TRIM(Almmmatg.Desmar) = "STANDFORD" THEN X-STANDFORD = X-STANDFORD + PEDI.ImpLin.
           IF PEDI.Por_Dsctos[3] = 0 THEN DO:
              IF Almmmatg.CodFam = "001" THEN X-LINEA1 = X-LINEA1 + PEDI.ImpLin.
              ELSE X-OTROS = X-OTROS + PEDI.ImpLin.
           END.                
        END.
       /*********************************************************************/
      B-CPedi.CodAlm = PEDI.AlmDes .

   END.
   B-CPEDI.ImpIgv = ROUND(F-IGV,2).
   B-CPEDI.ImpIsc = ROUND(F-ISC,2).
   B-CPEDI.ImpBrt = B-CPEDI.ImpTot - B-CPEDI.ImpIgv - B-CPEDI.ImpIsc + 
                    B-CPEDI.ImpDto - B-CPEDI.ImpExo.
   B-CPEDI.ImpVta = B-CPEDI.ImpBrt - B-CPEDI.ImpDto.
   
   /*******Descuento Especial********************/
   IF X-STANDFORD >= 500 THEN DO:
      X-AFECTO = X-LINEA1 .
      IF X-LINEA1 > X-STANDFORD THEN X-AFECTO = X-STANDFORD.  
      X-DTO1   = 0 .
   END.
   /*********************************************/
   
   DEFINE VAR X-IMPTOT AS DECI INIT 0.
   DEFINE VAR Y-IMPTOT AS DECI INIT 0.
   X-DTO2 = 0 .
   Y-IMPTOT = ( X-LINEA1 - X-AFECTO + X-OTROS ) .
   IF B-CPEDI.CodMon = 1 THEN X-IMPTOT = Y-IMPTOT .
   IF B-CPEDI.CodMon = 2 THEN X-IMPTOT = Y-IMPTOT * B-CPEDI.TpoCmb .           
   /*
   /*******Descuento Por Tarjeta **************************/
   DO WITH FRAME {&FRAME-NAME}:
        IF Faccpedi.NroCard:SCREEN-VALUE <> "" THEN DO:
           IF X-IMPTOT >= 500  AND X-IMPTOT < 1000 THEN X-DTO2 = 0.15.
           IF X-IMPTOT >= 1000 AND X-IMPTOT < 1500 THEN X-DTO2 = 0.20.
           IF X-IMPTOT >= 1500 AND X-IMPTOT < 2000 THEN X-DTO2 = 0.25.
           IF X-IMPTOT >= 2000 AND X-IMPTOT < 2500 THEN X-DTO2 = 0.30.
           IF X-IMPTOT >= 2500 AND X-IMPTOT < 3000 THEN X-DTO2 = 0.35.
           IF X-IMPTOT >= 3000 AND X-IMPTOT < 3500 THEN X-DTO2 = 0.40.
           IF X-IMPTOT >= 3500 AND X-IMPTOT < 4000 THEN X-DTO2 = 0.45.
           IF X-IMPTOT >= 4000 AND X-IMPTOT < 4500 THEN X-DTO2 = 0.50.
           IF X-IMPTOT >= 4500 AND X-IMPTOT < 5000 THEN X-DTO2 = 0.55.
           IF X-IMPTOT >= 5000 AND X-IMPTOT < 5500 THEN X-DTO2 = 0.60.
           IF X-IMPTOT >= 5500 AND X-IMPTOT < 6000 THEN X-DTO2 = 0.65.
           IF X-IMPTOT >= 6000 AND X-IMPTOT < 6500 THEN X-DTO2 = 0.70.
           IF X-IMPTOT >= 6500 AND X-IMPTOT < 7000 THEN X-DTO2 = 0.75.
           IF X-IMPTOT >= 7000 AND X-IMPTOT < 7500 THEN X-DTO2 = 0.80.
           IF X-IMPTOT >= 7500 AND X-IMPTOT < 8000 THEN X-DTO2 = 0.85.
           IF X-IMPTOT >= 8000 AND X-IMPTOT < 8500 THEN X-DTO2 = 0.90.
           IF X-IMPTOT >= 8500 AND X-IMPTOT < 9000 THEN X-DTO2 = 0.95.
           IF X-IMPTOT >= 9000 AND X-IMPTOT < 10000 THEN X-DTO2 = 1.00.
           IF X-IMPTOT >= 10000 THEN X-DTO2 = 1.05.              
        END.
   END.
   */
           
   /******************************************************/
    IF LOOKUP(B-CPEDI.FmaPgo,"000,001") > 0  THEN DO:
       B-CPEDI.Importe[1] = ROUND((( X-AFECTO * X-DTO1 ) / 100 ),2) .
       B-CPEDI.Importe[2] = ROUND((( Y-IMPTOT * X-DTO2 ) / 100 ),2) .
    END.
    B-cpedi.PorDto = ROUND(((( B-CPEDI.Importe[1] + B-CPEDI.Importe[2] ) / B-CPEDI.ImpTot ) * 100 ),2).    
    B-CPEDI.ImpDto = B-CPEDI.ImpDto + B-CPEDI.Importe[1] + B-CPEDI.Importe[2] .
    B-CPEDI.ImpTot = ROUND(B-CPEDI.ImpTot * (1 - B-cpedi.PorDto / 100),2).
    B-CPEDI.ImpVta = ROUND(B-CPEDI.ImpTot / (1 + B-CPEDI.PorIgv / 100),2).
    B-CPEDI.ImpIgv = B-CPEDI.ImpTot - B-CPEDI.ImpVta.
    B-CPEDI.ImpBrt = B-CPEDI.ImpTot - B-CPEDI.ImpIgv - B-CPEDI.ImpIsc + 
                     B-CPEDI.ImpDto - B-CPEDI.ImpExo.
    IF LOOKUP(B-CPEDI.FmaPgo,"000,001") > 0  THEN DO:
       B-CPEDI.Importe[3] = IF Y-IMPTOT > B-CPEDI.ImpTot THEN B-CPEDI.ImpTot ELSE Y-IMPTOT.
    END.                 
   /******************************************************/
   
  /* Aprobacion automatica en caso de pedidos contado-contraentrega */
  IF s-CodDiv = '00013'               /* Expolibreria */
      AND B-CPedi.FmaPgo = '001'      /* Contado contra-entrega */
  THEN DO:
      B-CPedi.Flgest = 'P'.
      FOR EACH FacDPedi OF B-CPedi :
          FacDPedi.Flgest = B-CPedi.Flgest.
      END.
      RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  END.

   RELEASE B-CPEDI.

END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Cabecera V-table-Win 
PROCEDURE Importar-Cabecera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT parameter X-ARCHIVO AS CHAR.
IF X-Archivo = ? THEN RETURN.
Def var x as integer init 0.
Def var lin as char.
Input stream entra from value(x-archivo).

    Import stream entra unformatted lin.  
    FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                  AND  gn-clie.CodCli = trim(entry(1,lin,'|')) 
                 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN DO:
       MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    
    /* Ubica la Condicion Venta */
    FIND gn-convt WHERE gn-convt.Codig = gn-clie.CndVta 
                  NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN DO:
         f-totdias = gn-convt.totdias.
    END.
    ELSE F-totdias = 0.


    FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
                 AND  gn-ven.CodVen = trim(entry(2,lin,'|')) 
                NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-ven THEN DO:
       MESSAGE "Codigo de vendedor no existe" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.

    FIND gn-convt WHERE gn-convt.Codig = trim(entry(3,lin,'|'))
                        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-convt THEN DO:
       MESSAGE "Condicion de Pago no existe" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.


    FIND TcmbCot WHERE  TcmbCot.Codcia = 0
                  AND  (TcmbCot.Rango1 <=  1
                  AND   TcmbCot.Rango2 >=  1)
                 NO-LOCK NO-ERROR.

    IF AVAIL TcmbCot THEN DO:
        DISPLAY TcmbCot.TpoCmb @ FacCPedi.TpoCmb
                WITH FRAME {&FRAME-NAME}.
        S-TPOCMB = TcmbCot.TpoCmb.  
    END.

  

    S-CODCLI = trim(entry(1,lin,'|')).
    S-CNDVTA = trim(entry(3,lin,'|')).
    S-CODVEN = trim(entry(2,lin,'|')).

    DO WITH FRAME {&FRAME-NAME}:
        DISPLAY  S-CODCLI @ FacCPedi.Codcli
                 Gn-Clie.NomCli @ FacCPedi.Nomcli
                 Gn-Clie.Ruc    @ FacCPedi.Ruc
                 S-CODVEN @ FacCPedi.CodVen
                 Gn-ven.NomVen @ F-Nomven
                 S-CNDVTA @ FacCPedi.FmaPgo
                 Gn-Convt.Nombr @ F-CndVta.
    END.



input stream entra close.

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
  s-Copia-Registro = NO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  L-CREA = YES.
  S-CODMON = 2.
  S-NroCot = "".
  T-Especial = NO.
  F-FchVto = TODAY.
  S-CNDVTA = "".
   
  FIND TcmbCot WHERE  TcmbCot.Codcia = 0
                AND  (TcmbCot.Rango1 <= 1
                AND   TcmbCot.Rango2 >= 1)
               NO-LOCK NO-ERROR.
  IF AVAIL TcmbCot THEN DO:
      S-TPOCMB = TcmbCot.TpoCmb.  
  END.
  
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY @ FacCPedi.FchPed
             TODAY @ FacCPedi.FchEnt
             S-TPOCMB @ FacCPedi.TpoCmb
             /*FacCfgGn.CliVar @ FacCPedi.CodCli*/
             T-Especial.
    ASSIGN  
        FacCPedi.CodMon:SCREEN-VALUE = "2"
        C-TpoVta:SENSITIVE = YES
        C-TpoVta:SCREEN-VALUE = ENTRY(1,C-TpoVta:LIST-ITEMS)
        T-Especial:SENSITIVE = YES
        FacCPedi.DirCli:SENSITIVE = NO
        FacCPedi.NomCli:SENSITIVE = NO.
    /* RHC 11-03-04 actualizamos informacion preliminar */ 
    FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
        AND  gn-clie.CodCli = FacCPedi.CodCli:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie
    THEN DO:
        DISPLAY 
            gn-clie.Nomcli @ FacCPedi.Nomcli
            gn-clie.Ruc    @ FacCPedi.Ruccli
            gn-clie.Dircli @ FacCPedi.Dircli
            gn-clie.CodVen @ FacCPedi.CodVen.
        S-CODCLI = FacCPedi.CodCli:SCREEN-VALUE.
        /* Ubica la Condicion Venta */
        FIND gn-convt WHERE gn-convt.Codig = gn-clie.CndVta 
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-convt 
        THEN f-totdias = gn-convt.totdias.
        ELSE F-totdias = 0.
    END.
  END.
  RUN Actualiza-Item.
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
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN C-TPOVTA.
     IF L-CREA THEN DO:
         RUN Numero-de-Pedido(YES).
         ASSIGN FacCPedi.CodCia = S-CODCIA
                FacCPedi.CodDoc = s-coddoc 
             /*   FacCPedi.FchPed = TODAY */
                FacCPedi.CodAlm = S-CODALM
                FacCPedi.PorIgv = FacCfgGn.PorIgv 
                FacCPedi.TpoCmb = FacCfgGn.TpoCmb[1] 
                FacCPedi.NroPed = STRING(I-NroSer,"999") + STRING(I-NroPed,"999999")
                FacCPedi.CodDiv = S-CODDIV
                FacCPedi.Flgest = 'G'
                FacCPedi.CodMon = S-CODMON
                FaccPedi.NroCard = FaccPedi.NroCard:SCREEN-VALUE .
        ASSIGN
            FacCPedi.NroRef = s-NroCot.     /* RHC 22-03-2003 */
        DISPLAY FacCPedi.NroPed.
        /* RHC 12.01.05 Control de pedidos hechos por copia de otro */
        IF s-Copia-Registro = YES
        THEN FacCPedi.CodTrans = '*'.       /* Este campo no se usa */
        /* ******************************************************** */
     END.
    
     ASSIGN 
        FacCPedi.Hora = STRING(TIME,"HH:MM")
        FacCPedi.Usuario = S-USER-ID
        FacCPedi.TipVta = STRING(LOOKUP(C-TpoVta,C-TpoVta:LIST-ITEMS))
/*      FacCPedi.TipVta = w-tipo*/
        FacCPedi.NomCli = FacCPedi.NomCli:screen-value
        FacCPedi.DirCli = FacCPedi.DirCli:screen-value
        FacCPedi.RucCli = FacCPedi.RucCli:screen-value
        FacCPedi.Cmpbnte = C-tpoVta:SCREEN-VALUE
        FacCPedi.Tpoped = ""
        FacCPedi.FchVen = F-FchVto
        FaccPedi.TipBon[1] = IF T-Especial THEN 1 ELSE 0.
        
        IF C-tpoVta:SCREEN-VALUE = "BOL" THEN Faccpedi.Ruccli = "".
     IF AVAIL B-CPedi THEN 
         ASSIGN
            FacCPedi.TpoLic = B-CPedi.TpoLic.

    /* VEAMOS LA ACTIVACION DE CLIENTE */
    FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
        AND  gn-clie.CodCli = Faccpedi.CodCli
        NO-LOCK NO-ERROR.
    IF gn-clie.FlgSit = "I" 
    THEN DO:      
        FIND CURRENT GN-CLIE EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
        ASSIGN
            gn-clie.FlgSit = 'A'.
        /* Historico */
        CREATE LogTabla.
        ASSIGN
          logtabla.codcia = s-codcia
          logtabla.Dia = TODAY
          logtabla.Evento = 'WRITE'
          logtabla.Hora = STRING(TIME, 'HH:MM')
          logtabla.Tabla = 'GN-CLIE'
          logtabla.Usuario = s-user-id
          logtabla.ValorLlave = STRING(gn-clie.codcia, '999') + '|' +
                                  STRING(gn-clie.codcli, 'x(11)').
        RELEASE LogTabla. 
        RELEASE GN-CLIE.        
    END.
    /* CONTROL DE PEDIDOS PARA ENVIO */
    MESSAGE 'El Pedido es para enviar?' 
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
        TITLE 'Confirmacion de Pedidos a Enviar' UPDATE rpta-1 AS LOG.
    FacCPedi.FlgEnv = rpta-1.
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
  RUN Procesa-Handle IN lh_Handle ('Browse').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
  IF NOT AVAILABLE FacCPedi THEN RETURN 'ADM-ERROR'.
  IF LOOKUP(TRIM(FacCPedi.FlgEst), 'A,F,R') > 0 THEN RETURN 'ADM-ERROR'.

  ASSIGN
    output-var-1 = ?
    L-Crea = NO.
  RUN Actualiza-Item.   /* Cargamos el temporal */
  ASSIGN
    L-CREA = YES
    S-CODMON = faccpedi.codmon
    S-NroCot = faccpedi.nroref
    T-Especial = (IF faccpedi.tipbon[1] = 1 THEN YES ELSE NO)
    F-FchVto = faccpedi.fchven
    S-CNDVTA = faccpedi.fmapgo
    s-CodCli = faccpedi.codcli.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  
  /* Code placed here will execute AFTER standard behavior.    */
  /* DEBE SER SIMILAR RUTINA A local-add-record */
  FIND TcmbCot WHERE  TcmbCot.Codcia = 0
                AND  (TcmbCot.Rango1 <= 1
                AND   TcmbCot.Rango2 >= 1)
               NO-LOCK NO-ERROR.
  IF AVAIL TcmbCot THEN DO:
      S-TPOCMB = TcmbCot.TpoCmb.  
  END.
  
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY @ FacCPedi.FchPed
             TODAY @ FacCPedi.FchEnt
             S-TPOCMB @ FacCPedi.TpoCmb
             T-Especial
             "" @ FacCPedi.NroPed.
    ASSIGN  
        C-TpoVta:SENSITIVE = YES
        C-TpoVta:SCREEN-VALUE = ENTRY(1,C-TpoVta:LIST-ITEMS)
        T-Especial:SENSITIVE = YES
        FacCPedi.DirCli:SENSITIVE = NO
        FacCPedi.NomCli:SENSITIVE = NO.
    /* RHC 11-03-04 actualizamos informacion preliminar */ 
    FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
        AND  gn-clie.CodCli = FacCPedi.CodCli:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie
    THEN DO:
        /* Ubica la Condicion Venta */
        FIND gn-convt WHERE gn-convt.Codig = gn-clie.CndVta 
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-convt 
        THEN f-totdias = gn-convt.totdias.
        ELSE F-totdias = 0.
    END.
  END.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('Browse').
  RUN Procesa-Handle IN lh_Handle ('Recalculo').

  s-Copia-Registro = YES.   /* <<< OJO >>> */

/* ************ RHC 05.10.04 NUEVA RUTINA DE COPIA 
  /* Code placed here will execute PRIOR to standard behavior. */
  RETURN "ADM-ERROR".
  
  IF NOT AVAILABLE FaccPedi THEN RETURN "ADM-ERROR".
/*  IF LOOKUP(FaccPedi.FlgEst,"C,A") > 0 THEN  RETURN "ADM-ERROR".*/
  S-CODMON = FaccPedi.CodMon.
  S-CODCLI = FaccPedi.CodCli.
/*  NRO_PED = FaccPedi.NroPed.*/
  L-CREA = NO.
  RUN Actualiza-Item.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  L-CREA = YES.
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY "" @ FaccPedi.NroPed
             "" @ F-Estado.
  END.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('Browse').
************************************************************* */

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
    IF FacCPedi.FlgEst = "A" THEN DO:
       MESSAGE "El pedido ya fue anulado" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    IF FacCPedi.FlgEst = "C" THEN DO:
       MESSAGE "No puede eliminar un pedido atendido" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    IF FacCPedi.FlgEst = "F" THEN DO:
       MESSAGE "No puede eliminar un pedido facturado" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
/*        DELETE FROM FacDPedi WHERE FacDPedi.codcia = FacCPedi.codcia 
 *                               AND  FacDPedi.coddoc = FacCPedi.coddoc 
 *                               AND  FacDPedi.nroped = FacCPedi.nroped.*/
        /* RHC 22-03-2003 ACTUALIZAMOS LA COTIZACION */
        IF FacCPedi.NroRef <> ''    /* Extorno de la Cotizacion */
        THEN DO:
            FOR EACH FacDPedi WHERE FacDPedi.codcia = FacCPedi.codcia 
                    AND  FacDPedi.coddoc = FacCPedi.coddoc 
                    AND  FacDPedi.nroped = FacCPedi.nroped NO-LOCK:
                FIND B-DPedi WHERE B-DPedi.CodCia = faccPedi.CodCia 
                    AND  B-DPedi.CodDoc = "COT" 
                    AND  B-DPedi.NroPed = FacCPedi.NroRef   /*B-DPedi.NroPed = S-NroCot */
                    AND  B-DPedi.CodMat = FacDPedi.CodMat 
                    EXCLUSIVE-LOCK NO-ERROR.
                IF AVAILABLE B-DPedi 
                THEN B-DPedi.CanAte = B-DPedi.CanAte - FacDPedi.CanPed.
                RELEASE B-DPedi.
            END.
            FIND B-CPedi WHERE B-CPedi.CodCia = S-CODCIA 
                AND  B-CPedi.CodDiv = S-CODDIV 
                AND  B-CPedi.CodDoc = "COT" 
                AND  B-CPedi.NroPed = FacCPedi.NroRef        /*B-CPedi.NroPed = S-NroCot */
                EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE B-CPedI
            THEN DO:
                ASSIGN B-CPedi.FlgEst = "P".
                RELEASE B-CPedi.
            END.     
        END.
        /* *************** */
        FIND B-CPedi WHERE ROWID(B-CPedi) = ROWID(FacCPedi) EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE B-CPedi THEN 
            ASSIGN B-CPedi.FlgEst = "A"
                 B-CPedi.Glosa = " A N U L A D O".
        RELEASE B-CPedi.
    END.
    
    RUN Procesa-Handle IN lh_Handle ('browse').
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
  C-TpoVta:SENSITIVE IN FRAME {&FRAME-NAME} = NO. 
  T-Especial:SENSITIVE IN FRAME {&FRAME-NAME} = NO. 
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE FacCPedi THEN DO WITH FRAME {&FRAME-NAME}:
     FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                   AND  gn-clie.CodCli = FacCPedi.CodCli 
                  NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie  THEN DO: 
        /*
        DISPLAY gn-clie.NomCli @ FacCPedi.NomCli 
                gn-clie.Ruc    @ FacCPedi.RucCli  
                gn-clie.DirCli @ FacCPedi.DirCli.
        */
        CASE FaccPedi.FlgEst:
          WHEN "A" THEN DISPLAY "  ANULADO  " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "C" THEN DISPLAY " ATENDIDO  " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "G" THEN DISPLAY " GENERADO  " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "P" THEN DISPLAY " APROBADO  " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "V" THEN DISPLAY "  VENCIDO  " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "F" THEN DISPLAY " FACTURADO " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "X" THEN DISPLAY "NO APROBADO" @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "R" THEN DISPLAY " RECHAZADO " @ F-Estado WITH FRAME {&FRAME-NAME}.
       END CASE.         
     END.  
     F-NomVen:screen-value = "".
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
                  AND  gn-ven.CodVen = FacCPedi.CodVen 
                 NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
     F-CndVta:SCREEN-VALUE = "".
     FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
     C-TpoVta:SCREEN-VALUE = ENTRY(INTEGER(FacCPedi.TipVta),C-TpoVta:LIST-ITEMS).

     IF Faccpedi.NroCar <> "" THEN DO:
        FIND Gn-Card WHERE Gn-Card.NroCard = Faccpedi.NroCar
                              NO-LOCK NO-ERROR.
     
        IF AVAILABLE Gn-Card THEN DO:
           DISPLAY Gn-Card.nomclie[1] @ F-Nomtar.
        END.   
     END.           
     T-Especial = IF FaccPedi.TipBon[1] = 1 THEN TRUE ELSE NO.
     DISPLAY T-Especial.
    FIND almtabla WHERE almtabla.tabla = 'CP'
        AND almtabla.codigo = faccpedi.codpos
        NO-LOCK NO-ERROR.
    IF AVAILABLE almtabla
    THEN FILL-IN-Postal:SCREEN-VALUE = almtabla.nombre.
    ELSE FILL-IN-Postal:SCREEN-VALUE = ''.
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
  
  IF FacCPedi.FlgEst <> "A" THEN RUN VTA\R-ImpPed.r(ROWID(FacCPedi)).

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
  
  RUN Genera-Pedido.    /* Detalle del pedido */ 
  RUN Graba-Totales.

  /*IF S-NroCot <> "" THEN RUN Actualiza-Cotizacion.*/
  IF FacCPedi.NroRef <> '' THEN RUN Actualiza-Cotizacion.   /* RHC 22-03-2003 */
  RUN Verifica-Cliente.
  
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse'). 
  
  C-TpoVta:SENSITIVE IN FRAME {&FRAME-NAME} = NO. 
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Numero-de-Pedido V-table-Win 
PROCEDURE Numero-de-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER L-INCREMENTA AS LOGICAL.
  IF L-INCREMENTA THEN
      FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                     AND  FacCorre.CodDoc = S-CODDOC 
                     AND  FacCorre.CodDiv = S-CODDIV 
                    EXCLUSIVE-LOCK NO-ERROR.
  ELSE 
      FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                     AND  FacCorre.CodDoc = S-CODDOC 
                     AND  FacCorre.CodDiv = S-CODDIV 
                    NO-LOCK NO-ERROR.
  IF AVAILABLE FacCorre THEN DO:
     ASSIGN I-NroPed = FacCorre.Correlativo.
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
  {src/adm/template/snd-list.i "FacCPedi"}

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
     RUN Actualiza-Item.
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
DEFINE VARIABLE F-TOT AS DECIMAL INIT 0 NO-UNDO.
DEFINE VARIABLE F-BOL AS DECIMAL INIT 0 NO-UNDO.
DEFINE VARIABLE X-FREC AS INTEGER INIT 0 NO-UNDO.

DO WITH FRAME {&FRAME-NAME} :
   IF FacCPedi.CodCli:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCPedi.CodCli.
      RETURN "ADM-ERROR".   
   END.
   FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                 AND  gn-clie.CodCli = FacCPedi.CodCli:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-clie THEN DO:
      MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCPedi.CodCli.
      RETURN "ADM-ERROR".   
   END.
    
    IF LENGTH(TRIM(FacCPedi.CodCli:SCREEN-VALUE)) <> 11
    THEN DO:
        MESSAGE 'El codigo del cliente debe tener 11 digitos' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FacCPedi.CodCli.
        RETURN 'ADM-ERROR'.
    END.

   /***** Valida Ingreso de Ruc. *****/
   IF c-TpoVta:SCREEN-VALUE = "FAC" 
        AND FacCpedi.RucCli:SCREEN-VALUE = '' THEN DO:
      MESSAGE "El Cliente NO tiene R.U.C." VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCPedi.CodCli.
      RETURN "ADM-ERROR".   
   END.      

   IF FacCPedi.CodVen:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de Vendedor no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCPedi.CodVen.
      RETURN "ADM-ERROR".   
   END.
   FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
                AND  gn-ven.CodVen = FacCPedi.CodVen:screen-value 
               NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-ven THEN DO:
      MESSAGE "Codigo de Vendedor no existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCPedi.CodVen.
      RETURN "ADM-ERROR".   
   END.
   IF FacCPedi.FmaPgo:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Condicion Venta no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCPedi.FmaPgo.
      RETURN "ADM-ERROR".   
   END.
   IF FacCPedi.FmaPgo:SCREEN-VALUE = "000" THEN DO:
      MESSAGE "Condicion Venta no debe ser contado" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCPedi.FmaPgo.
      RETURN "ADM-ERROR".   
   END.
   FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-convt THEN DO:
      MESSAGE "Condicion Venta no existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCPedi.FmaPgo.
      RETURN "ADM-ERROR".   
   END.
   IF C-TpoVta:SCREEN-VALUE = "FAC" AND LENGTH(TRIM(FacCPedi.RucCli:SCREEN-VALUE)) <> 11 THEN DO:
      MESSAGE "Codigo de cliente sin RUC" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCPedi.CodCli.
      RETURN "ADM-ERROR".   
   END.

   FOR EACH PEDI NO-LOCK BREAK BY ALMDES:
       IF FIRST-OF(ALMDES) THEN DO:
          X-FREC = X-FREC + 1.
       END.        
       F-Tot = F-Tot + PEDI.ImpLin.
   END.
  
   IF Faccpedi.NroCar:SCREEN-VALUE <> "" THEN DO:
     FIND Gn-Card WHERE Gn-Card.NroCard = Faccpedi.NroCar:SCREEN-VALUE
                           NO-LOCK NO-ERROR.
  
     IF NOT AVAILABLE Gn-Card THEN DO:
         MESSAGE "Numero de Tarjeta Incorrecto, Verifique... " VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO FacCPedi.NroCar.
         RETURN "ADM-ERROR".   
     END.   
   END.           
   IF F-Tot = 0 THEN DO:
      MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCPedi.CodCli.
      RETURN "ADM-ERROR".   
   END.

   /* RHC 09/03/04 */
   F-BOL = IF INTEGER(FacCPedi.CodMon:SCREEN-VALUE) = 1 THEN F-TOT
            ELSE F-Tot * DECIMAL(FacCPedi.TpoCmb:SCREEN-VALUE).
   IF C-TpoVta:SCREEN-VALUE = 'BOL' AND F-BOL >= 1600
   THEN DO:
        MESSAGE "Venta Mayor a 1600.00 Ingresar Nro. Ruc., Verifique... " 
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FacCPedi.CodCli.
        RETURN "ADM-ERROR".   
   END.

   IF X-FREC > 1 THEN DO:
      MESSAGE "No puede despachar de varios almacenes, modifique su pedido" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCPedi.CodCli.
      RETURN "ADM-ERROR".   
   END.
   IF gn-convt.totdias > 0 THEN DO:
      IF S-CODMON = 1 THEN DO:
         IF gn-clie.MonLC = 2 THEN F-Tot = F-Tot / FacCfgGn.TpoCmb[1].
      END. 
      ELSE DO:
         IF gn-clie.MonLC = 1 THEN F-Tot = F-Tot * FacCfgGn.TpoCmb[1].
      END.

/****   COMENTAR SI EN CASO NO SE QUIERE VALIDAR LA CTA.CTE.    ****/
      IF LOOKUP(TRIM(Faccpedi.Fmapgo:SCREEN-VALUE),"000,001,002") = 0 THEN DO: 
        IF L-CREA 
        THEN run vta\lincre.r(gn-clie.CodCli,F-Tot,OUTPUT T-SALDO).
        ELSE run vta\lincre.r(gn-clie.CodCli,F-Tot - FacCpedi.Imptot,OUTPUT T-SALDO).

        dImpLCred = 0.
        lEnCampan = FALSE.
        /* Línea Crédito Campaña */
        FOR EACH Gn-ClieL WHERE
            Gn-ClieL.CodCia = gn-clie.codcia AND
            Gn-ClieL.CodCli = gn-clie.codcli AND
            Gn-ClieL.FchIni >= TODAY AND
            Gn-ClieL.FchFin <= TODAY NO-LOCK:
            dImpLCred = dImpLCred + Gn-ClieL.ImpLC.
            lEnCampan = TRUE.
        END.
        /* Línea Crédito Normal */
        IF NOT lEnCampan THEN dImpLCred = gn-clie.ImpLC.

        IF RETURN-VALUE <> "OK" THEN DO:
            MESSAGE
                "LINEA CREDITO  : " (IF gn-clie.MonLC = 1 THEN "S/. " ELSE "US$ " ) 
                    STRING(dImpLCred,"ZZ,ZZZ,ZZ9.99") SKIP
                "USADO                 : " (IF gn-clie.MonLC = 1 THEN "S/. " ELSE "US$ " ) 
                    STRING(T-SALDO,"ZZ,ZZZ,ZZ9.99") SKIP
                "CREDITO DISPONIBLE    : " (IF gn-clie.MonLC = 1 THEN "S/. " ELSE "US$ " ) 
                    STRING(dImpLCred - T-SALDO,"-Z,ZZZ,ZZ9.99")
                VIEW-AS ALERT-BOX ERROR. 
           APPLY "ENTRY" TO FacCPedi.CodCli.
           RETURN "ADM-ERROR".   
        END.
      END.
/*******************************************************************/

    FIND almtabla WHERE almtabla.tabla = 'CP'
        AND almtabla.codigo = FacCPedi.CodPos:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almtabla
    THEN DO:
        MESSAGE 'Código Postal no Regsitrado'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FacCPedi.CodPos.
        RETURN 'ADM-ERROR':U.
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
IF NOT AVAILABLE FacCPedi THEN RETURN "ADM-ERROR".
IF LOOKUP(FacCPedi.FlgEst,"F,C,A") > 0 THEN  RETURN "ADM-ERROR".
S-CODMON = FacCPedi.CodMon.
S-CODCLI = FacCPedi.CodCli.
S-TPOCMB = FaccPedi.Tpocmb.
S-CNDVTA = FaccPedi.FmaPgo.
F-FchVto = FaccPedi.FchVen.
s-NroCot = FacCPedi.NroRef.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Verifica-Cliente V-table-Win 
PROCEDURE Verifica-Cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF LOOKUP(FacCPedi.Flgest, 'G,X') > 0  THEN DO:
   DEFINE VAR OK AS LOGICAL NO-UNDO.
   DEFINE VAR X-CREUSA AS DECIMAL NO-UNDO.
   DEFINE VARIABLE I-ListPr     AS INTEGER   NO-UNDO.
   DEFINE VARIABLE F-MRGUTI     AS INTEGER   NO-UNDO.

   FIND B-CPedi WHERE B-CPedi.codcia = s-codcia 
                 AND  B-CPedi.coddoc = FacCPedi.coddoc 
                 AND  B-CPedi.nroped = FacCPedi.nroped 
                NO-ERROR.

    /* Deuda vencida */
   FIND FIRST CcbCDocu WHERE CcbCDocu.CodCia = s-CodCia
                        AND  CcbCDocu.CodCli = FacCPedi.Codcli                         
                        AND  LOOKUP(CcbCDocu.CodDoc, "FAC,BOL,CHQ,LET,N/D") > 0 /* BEGINS f-CodDoc */
                        AND  CcbCDocu.FlgEst = "P" 
                        AND  CcbCDocu.FchVto <= TODAY
                        NO-LOCK NO-ERROR. 
    IF AVAIL CcbCDocu THEN DO:
      ASSIGN
         B-CPedi.Flgest = 'X'
         B-CPedi.Glosa  = TRIM (B-CPedi.Glosa) + '//Doc. Venc.'.
    END.

/*    
    
   /* Linea de Credito */
   OK = TRUE.
   FIND gn-clie WHERE gn-clie.CodCia = 0 
                 AND  gn-clie.CodCli = FacCPedi.Codcli 
                NO-LOCK NO-ERROR.
/*   IF gn-clie.ClfCli = "D" THEN OK = FALSE.*/
   IF FacCPedi.Flgest = 'P' THEN 
      RUN vta\lincre.r(gn-clie.CodCli,0,OUTPUT T-SALDO).
   ELSE
      RUN vta\lincre.r(gn-clie.CodCli,FacCPedi.Imptot,OUTPUT T-SALDO).

   IF RETURN-VALUE <> "OK" THEN OK = FALSE.

   IF AVAILABLE B-CPedi AND NOT OK THEN
      ASSIGN
         B-CPedi.Flgest = 'X'
         B-CPedi.Glosa  = TRIM (B-CPedi.Glosa) + '//Linea Credito'.
   ELSE
      ASSIGN B-CPedi.Flgest = 'P'.
  */ 


   /* Condicion Crediticia */
   OK = TRUE.
   FIND gn-convt WHERE gn-convt.Codig = gn-clie.cndvta NO-LOCK NO-ERROR.
   IF AVAILABLE gn-convt THEN F-totdias = gn-convt.totdias.
   
   FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
   IF AVAILABLE gn-convt THEN 
      IF gn-convt.totdias > F-totdias AND F-totdias > 0 THEN OK = FALSE.


   IF AVAILABLE B-CPedi AND NOT OK THEN DO:
      ASSIGN
         B-CPedi.Flgest = 'X'
         B-CPedi.Glosa  = TRIM (B-CPedi.Glosa) + '//Cond.Cred.'.
    END.     


/*
   /* Margen de Utilidad */
   OK = TRUE.
/*   I-ListPr = INTEGER(gn-clie.TpoCli).
   IF FacCPedi.TipVta = 'Margen Utilidad' THEN DO:
      CASE I-ListPr:
           WHEN 1 THEN ASSIGN F-MRGUTI = FacCfgGn.MrgMin.
           WHEN 2 THEN ASSIGN F-MRGUTI = FacCfgGn.MrgMay.
           WHEN 3 THEN ASSIGN F-MRGUTI = FacCfgGn.MrgDis.
           WHEN 4 THEN ASSIGN F-MRGUTI = FacCfgGn.MrgPub.
      END CASE. 
      FOR EACH FacDPedi OF FacCPedi NO-LOCK:
          IF FacDPedi.MrgUti < F-MRGUTI THEN OK = FALSE.
      END.*/
      FOR EACH FacDPedi OF FacCPedi NO-LOCK:
          IF FacDPedi.MrgUti <= 0 THEN OK = FALSE.
      END.
      IF AVAILABLE B-CPedi AND NOT OK THEN
         ASSIGN
            B-CPedi.Flgest = 'X'
            B-CPedi.Glosa  = TRIM (B-CPedi.Glosa) + '//%MrgUti.'.
/*   END.*/
*/

   /*Ventas Contra Entrega*/
   OK = TRUE.
   IF LOOKUP(FacCPedi.fmaPgo,"001,002") > 0 THEN OK = FALSE.

   IF AVAILABLE B-CPedi AND NOT OK THEN DO:
      ASSIGN
         B-CPedi.Flgest = 'X'
         B-CPedi.Glosa  = TRIM (B-CPedi.Glosa) + '//Cond.Cred.'.
   END.

   /* RHC 15.10.04 Transferencias Gratuitas */
   IF B-CPedi.FmaPgo = '900' THEN B-CPEDI.FlgEst = 'X'.      /* NO Aprobado */
   /* ************************************* */
   
   IF  B-CPEDI.Flgest = "G" THEN B-CPEDI.Flgest = "P".

   FOR EACH FacDPedi OF FacCPedi:
       ASSIGN
          FacDPedi.Flgest = FacCPedi.Flgest.
       RELEASE FacDPedi.
   END.
   RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
END.      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Verifica-Orden-Despacho V-table-Win 
PROCEDURE Verifica-Orden-Despacho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF FacCPedi.Flgest = 'P' THEN DO:
  DEFINE VAR ok AS LOGICAL NO-UNDO.
  IF FacCPedi.TpoPed = "2" THEN DO:
    MESSAGE "No puede generar una Orden de Despacho Total" skip
            "El pedido es de Tipo Programado"
            VIEW-AS ALERT-BOX WARNING.
  END.
  ELSE DO:
    MESSAGE 'Desea generar ORDEN DE DESPACHO TOTAL' VIEW-AS ALERT-BOX 
        QUESTION BUTTONS YES-NO UPDATE x-rpta AS LOGICAL.
    IF x-rpta THEN DO TRANSACTION:
       F-Orddes = ''.
       FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                      AND  FacCorre.CodDoc = 'O/D' 
                      AND  FacCorre.CodDiv = S-CODDIV 
                     NO-LOCK NO-ERROR.
       IF AVAILABLE FacCorre THEN 
          F-Orddes = STRING(I-NroSer,"999") + STRING(FacCorre.Correlativo,"999999").
       RUN vta\d-orddes (F-Orddes, INPUT-OUTPUT F-Fchent, INPUT-OUTPUT F-Codtra, INPUT-OUTPUT F-Lugent, INPUT-OUTPUT F-Lugent2, INPUT-OUTPUT F-flgsit, OUTPUT ok).
       IF OK THEN RUN Genera-Orden-Despacho.
       RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
    END.
  END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

