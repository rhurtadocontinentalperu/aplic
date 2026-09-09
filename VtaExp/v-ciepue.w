&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDI NO-UNDO LIKE FacDPedi.



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
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-TERMINAL AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE SHARED VARIABLE S-CODTER   AS CHAR.
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER INIT 1.
DEFINE SHARED VARIABLE S-CODIGV   AS INTEGER INIT 1.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHARACTER.
DEFINE SHARED VARIABLE S-CNDVTA   AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB AS DECIMAL.  
DEFINE SHARED VARIABLE X-NRODEC AS INTEGER INIT 2.
DEFINE SHARED VARIABLE S-NROTAR   AS CHAR.
DEFINE SHARED VARIABLE CL-CODCIA  AS INTEGER.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE I-NroItm     AS INTEGER   NO-UNDO.
DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-NROPED       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE T-SALDO AS DECIMAL.
DEFINE VARIABLE F-totdias      AS INTEGER NO-UNDO.
DEFINE VARIABLE w-import       AS INTEGER NO-UNDO.
DEFINE VAR F-Observa AS CHAR NO-UNDO.
DEFINE VAR X-Codalm  AS CHAR NO-UNDO.

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
               AND  FacCorre.CodDoc = S-CODDOC 
               AND  FacCorre.CodDiv = S-CODDIV
               AND  FacCorre.CodAlm = S-CodAlm 
               NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN I-NroSer = FacCorre.NroSer
          S-PRINTER-NAME = FacCorre.Printer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

x-CodAlm = S-CODALM.

DEFINE BUFFER B-CCB FOR CcbCDocu.
DEFINE BUFFER B-CPedi FOR FacCPedi.
DEFINE BUFFER B-DPedi FOR FacDPedi.


DEFINE stream entra .

DEFINE VAR x-ClientesVarios AS CHAR INIT '11111111,11111112'.

DEFINE VAR s-copia-registro AS LOGICAL INIT FALSE NO-UNDO.

DEFINE VAR s-cndvta-validos AS CHAR.

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
&Scoped-Define ENABLED-FIELDS FacCPedi.CodCli FacCPedi.NomCli ~
FacCPedi.TpoCmb FacCPedi.RucCli FacCPedi.fchven FacCPedi.NroCard ~
FacCPedi.FchEnt FacCPedi.DirCli FacCPedi.CodPos FacCPedi.CodMon ~
FacCPedi.CodVen FacCPedi.FmaPgo FacCPedi.Glosa 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define ENABLED-OBJECTS RECT-21 
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.FchPed ~
FacCPedi.CodCli FacCPedi.NomCli FacCPedi.TpoCmb FacCPedi.RucCli ~
FacCPedi.fchven FacCPedi.NroCard FacCPedi.FchEnt FacCPedi.DirCli ~
FacCPedi.CodPos FacCPedi.CodMon FacCPedi.CodVen FacCPedi.FmaPgo ~
FacCPedi.Glosa 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS F-Estado FILL-IN-1 F-Nomtar C-TpoVta ~
FILL-IN-Postal F-nOMvEN F-CndVta 

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
DEFINE BUTTON BUTTON-Turno-Avanza 
     IMAGE-UP FILE "adeicon\pvforw":U
     IMAGE-INSENSITIVE FILE "adeicon\pvforwx":U
     LABEL "Button 1" 
     SIZE 5 BY 1.35 TOOLTIP "Siguiente en el turno".

DEFINE BUTTON BUTTON-Turno-Retrocede 
     IMAGE-UP FILE "adeicon\pvback":U
     IMAGE-INSENSITIVE FILE "adeicon\pvbackx":U
     LABEL "Button turno avanza 2" 
     SIZE 5 BY 1.35 TOOLTIP "Siguiente en el turno".

DEFINE VARIABLE C-TpoVta AS CHARACTER FORMAT "X(256)":U INITIAL "Factura" 
     LABEL "Tipo Venta" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Factura","Boleta" 
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE F-CndVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE F-Nomtar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE F-nOMvEN AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81
     FONT 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Postal AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 112 BY 7.69.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.NroPed AT ROW 1.19 COL 9 COLON-ALIGNED
          LABEL "Numero" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .81
          BGCOLOR 15 FGCOLOR 1 FONT 0
     F-Estado AT ROW 1.19 COL 52 COLON-ALIGNED NO-LABEL
     FacCPedi.FchPed AT ROW 1.19 COL 98 COLON-ALIGNED
          LABEL "Fecha"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     BUTTON-Turno-Retrocede AT ROW 1.77 COL 74
     BUTTON-Turno-Avanza AT ROW 1.77 COL 79
     FacCPedi.CodCli AT ROW 1.96 COL 9 COLON-ALIGNED HELP
          "" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.NomCli AT ROW 1.96 COL 22 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 49 BY .81
     FILL-IN-1 AT ROW 1.96 COL 82 COLON-ALIGNED NO-LABEL
     FacCPedi.TpoCmb AT ROW 1.96 COL 98 COLON-ALIGNED
          LABEL "T/  Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.RucCli AT ROW 2.73 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.fchven AT ROW 2.73 COL 98 COLON-ALIGNED
          LABEL "Vencimiento" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.NroCard AT ROW 3.5 COL 9 COLON-ALIGNED
          LABEL "Nro.Tarjeta"
          VIEW-AS FILL-IN 
          SIZE 11.57 BY .81
     F-Nomtar AT ROW 3.5 COL 21 COLON-ALIGNED NO-LABEL
     FacCPedi.FchEnt AT ROW 3.5 COL 98 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.DirCli AT ROW 4.27 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 62 BY .81
     C-TpoVta AT ROW 4.27 COL 98 COLON-ALIGNED
     FacCPedi.CodPos AT ROW 5.04 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FILL-IN-Postal AT ROW 5.04 COL 15 COLON-ALIGNED NO-LABEL
     FacCPedi.CodMon AT ROW 5.23 COL 100 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.57 BY .81
     FacCPedi.CodVen AT ROW 5.81 COL 9 COLON-ALIGNED FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
     F-nOMvEN AT ROW 5.81 COL 15 COLON-ALIGNED NO-LABEL
     FacCPedi.FmaPgo AT ROW 6.58 COL 9 COLON-ALIGNED
          LABEL "Cond.Vta" FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
     F-CndVta AT ROW 6.58 COL 15 COLON-ALIGNED NO-LABEL
     FacCPedi.Glosa AT ROW 7.35 COL 6.28
          VIEW-AS FILL-IN 
          SIZE 62 BY .81
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 5.23 COL 93
     RECT-21 AT ROW 1 COL 1
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
   Temp-Tables and Buffers:
      TABLE: PEDI T "SHARED" NO-UNDO INTEGRAL FacDPedi
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
         HEIGHT             = 7.77
         WIDTH              = 114.29.
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
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR BUTTON BUTTON-Turno-Avanza IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON BUTTON-Turno-Retrocede IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX C-TpoVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   EXP-FORMAT EXP-HELP                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.CodVen IN FRAME F-Main
   EXP-FORMAT                                                           */
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
/* SETTINGS FOR FILL-IN FacCPedi.fchven IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Postal IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FmaPgo IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.Glosa IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FacCPedi.NroCard IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.TpoCmb IN FRAME F-Main
   EXP-LABEL                                                            */
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

&Scoped-define SELF-NAME BUTTON-Turno-Avanza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Turno-Avanza V-table-Win
ON CHOOSE OF BUTTON-Turno-Avanza IN FRAME F-Main /* Button 1 */
DO:
  FIND NEXT ExpTurno WHERE expturno.codcia = s-codcia
    AND expturno.coddiv = s-coddiv
    AND expturno.block = s-codter
    AND expturno.fecha = TODAY
    AND expturno.estado = 'P'
    NO-LOCK NO-ERROR.
  IF AVAILABLE ExpTurno THEN DO:
    FILL-IN-1:SCREEN-VALUE = TRIM(ExpTurno.Tipo) + '-' +
                            TRIM(STRING(ExpTurno.Turno)).
    FIND GN-CLIE WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = expturno.codcli NO-LOCK NO-ERROR.
    IF AVAILABLE GN-CLIE
    THEN DISPLAY 
                gn-clie.codcli @ FacCPedi.CodCli            
                gn-clie.nomcli @ FacCPedi.NomCli
                gn-clie.dircli @ FacCPedi.DirCli 
                gn-clie.nrocard @ FacCPedi.NroCard 
                gn-clie.ruc @ FacCPedi.RucCli
                gn-clie.Codpos @ FacCPedi.CodPos
                WITH FRAME {&FRAME-NAME}.
  END.
  APPLY 'ENTRY':U TO FacCPedi.CodCli.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Turno-Retrocede
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Turno-Retrocede V-table-Win
ON CHOOSE OF BUTTON-Turno-Retrocede IN FRAME F-Main /* Button turno avanza 2 */
DO:
  FIND PREV ExpTurno WHERE expturno.codcia = s-codcia
    AND expturno.coddiv = s-coddiv
    AND expturno.block = s-codter
    AND expturno.fecha = TODAY
    AND expturno.estado = 'P'
    NO-LOCK NO-ERROR.
  IF AVAILABLE ExpTurno THEN DO:
    FILL-IN-1:SCREEN-VALUE = TRIM(ExpTurno.Tipo) + '-' +
                            TRIM(STRING(ExpTurno.Turno)).
    FIND GN-CLIE WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = expturno.codcli NO-LOCK NO-ERROR.
    IF AVAILABLE GN-CLIE
    THEN DISPLAY 
                gn-clie.codcli @ FacCPedi.CodCli            
                gn-clie.nomcli @ FacCPedi.NomCli
                gn-clie.dircli @ FacCPedi.DirCli 
                gn-clie.nrocard @ FacCPedi.NroCard 
                gn-clie.ruc @ FacCPedi.RucCli
                gn-clie.Codpos @ FacCPedi.CodPos
                WITH FRAME {&FRAME-NAME}.
  END.
  APPLY 'ENTRY':U TO FacCPedi.CodCli.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-TpoVta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-TpoVta V-table-Win
ON VALUE-CHANGED OF C-TpoVta IN FRAME F-Main /* Tipo Venta */
DO:
  ASSIGN C-tpovta.
  IF C-Tpovta = "Boleta" THEN DISPLAY "" @ FacCPedi.Ruccli WITH FRAME {&FRAME-NAME}.
  IF c-TpoVta = "Factura" THEN DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
            FacCPedi.DirCli:SENSITIVE = NO
            FacCPedi.NomCli:SENSITIVE = NO
            FacCPedi.DirCli:SCREEN-VALUE = GN-CLIE.DirCli
            FacCPedi.NomCli:SCREEN-VALUE = GN-CLIE.NomCli.
    IF FacCPedi.RucCli:SCREEN-VALUE = ''  THEN DO:
        FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
            AND gn-clie.CodCli = FacCPedi.CodCli:SCREEN-VALUE 
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN FacCPedi.RucCli:SCREEN-VALUE = gn-clie.Ruc.
    END.
  END.
  ELSE DO:
        ASSIGN
            FacCPedi.DirCli:SENSITIVE = YES
            FacCPedi.NomCli:SENSITIVE = YES.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodCli V-table-Win
ON LEAVE OF FacCPedi.CodCli IN FRAME F-Main /* Codigo */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  IF SELF:SCREEN-VALUE = S-CODCLI THEN RETURN.  
  FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
    AND  gn-clie.CodCli = SELF:SCREEN-VALUE 
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN DO:
    MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  IF LOOKUP(TRIM(SELF:SCREEN-VALUE), x-ClientesVarios) > 0
  THEN DO:
    MESSAGE 'Clientes varios NO permitidos' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO FacCPedi.CodCli.
    RETURN NO-APPLY.
  END.
  DISPLAY 
    gn-clie.NomCli @ Faccpedi.NomCli
    gn-clie.Ruc    @ Faccpedi.RucCli
    gn-clie.DirCli @ Faccpedi.DirCli
    /*gn-clie.CndVta @ FacCPedi.FmaPgo*/
    gn-clie.NroCard @ FacCPedi.NroCard
    WITH FRAME {&FRAME-NAME}.
  ASSIGN
    S-CODCLI = Faccpedi.CodCli:SCREEN-VALUE
    /*S-CNDVTA = gn-clie.CndVta*/
    S-NROTAR = gn-clie.NroCard.

  /* Tarjeta */
  FIND Gn-Card WHERE Gn-Card.NroCard = S-NROTAR NO-LOCK NO-ERROR.
  IF AVAILABLE GN-CARD 
  THEN ASSIGN
            F-NomTar:SCREEN-VALUE = GN-CARD.NomClie[1]
            FacCPedi.NroCard:SENSITIVE = NO.
  ELSE ASSIGN
            F-NomTar:SCREEN-VALUE = ''
            FacCPedi.NroCard:SENSITIVE = YES.
  
  /* Ubica la Condicion Venta */
  FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt 
  THEN DO:
       F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
       f-totdias = gn-convt.totdias.
  END.  
  ELSE F-CndVta:SCREEN-VALUE = "".

  FIND TcmbCot WHERE  TcmbCot.Codcia = 0
    AND (TcmbCot.Rango1 <= gn-convt.totdias
    AND  TcmbCot.Rango2 >= gn-convt.totdias)
    NO-LOCK NO-ERROR.
  IF AVAIL TcmbCot THEN DO:
       DISPLAY TcmbCot.TpoCmb @ FacCPedi.TpoCmb
               WITH FRAME {&FRAME-NAME}.
       S-TPOCMB = TcmbCot.TpoCmb.  
  END.

/*  ASSIGN
 *     BUTTON-Turno:VISIBLE = NO
 *     BUTTON-Turno:SENSITIVE = NO.*/
  
  /* Determina si es boleta o factura */
  IF FacCPedi.RucCli:SCREEN-VALUE = ''
  THEN C-TpoVta:SCREEN-VALUE = 'Boleta'.
  ELSE C-TpoVta:SCREEN-VALUE = 'Factura'.
  APPLY 'VALUE-CHANGED' TO c-TpoVta.
  /*RUN Procesa-Handle IN lh_Handle ('browse').*/
  /*RUN Procesa-Handle IN lh_Handle ('Recalculo').*/

  /* Cargamos las condiciones de venta válidas */
  /*s-cndvta-validos = gn-clie.cndvta.*/
  /* rhc 18.12.09 forzamos la condicion de venta */
  s-cndvta-validos = '001'.
  IF LOOKUP('400', gn-clie.cndvta) > 0
      THEN s-cndvta-validos = s-cndvta-validos + ',400'.
  IF LOOKUP('401', gn-clie.cndvta) > 0
      THEN s-cndvta-validos = s-cndvta-validos + ',401'.
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
  F-NomVen:SCREEN-VALUE = "".
  FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
    AND  gn-ven.CodVen = FacCPedi.CodVen:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE gn-ven THEN F-NomVen:SCREEN-VALUE = gn-ven.NomVen.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.FchEnt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FchEnt V-table-Win
ON LEAVE OF FacCPedi.FchEnt IN FRAME F-Main /* Fecha Entrega */
DO:
  /* RHC 10.01.06 RANGO DE DESPACHOS */
/*  IF NOT (INPUT {&SELF-NAME} >= 01/19/2008 AND INPUT {&SELF-NAME} <= 02/25/2008)
 *   THEN DO:
 *     MESSAGE 'Los despachos deben programarse entre el 19 de Enero y el 25 de Febrero'
 *         VIEW-AS ALERT-BOX WARNING.
 *     RETURN NO-APPLY.
 *   END.*/
  /* RHC 22.12.05 MAXIMO 40 DESPACHOS POR DIA */
  IF NOT (INPUT {&SELF-NAME} >= 01/15/2009)
  THEN DO:
      MESSAGE 'Los despachos deben programarse a partir del 15 de Enero'
          VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF INPUT {&SELF-NAME} <> ? AND RETURN-VALUE = 'YES' THEN DO:
    DEF VAR x-Cuentas AS INT NO-UNDO.
    DEF VAR x-Tope    AS INT INIT 40 NO-UNDO.
    FOR EACH B-CPEDI NO-LOCK WHERE B-CPEDI.codcia = s-codcia
            AND B-CPEDI.coddoc = s-coddoc
            AND B-CPEDI.coddiv = s-coddiv
            AND B-CPEDI.flgest <> 'A'
            AND B-CPEDI.fchped >= 01/01/2008
            AND B-CPEDI.fchent = INPUT {&SELF-NAME}:
        x-Cuentas = x-Cuentas + 1.
    END.            
/*    IF INPUT {&SELF-NAME} = 01/31/2008 OR 
 *         INPUT {&SELF-NAME} = 02/01/2008 OR
 *         INPUT {&SELF-NAME} = 02/15/2008
 *     THEN x-Tope = 60.*/
    IF x-Cuentas > x-Tope THEN DO:
        MESSAGE 'Ya se cubrieron los despachos para ese día' 
            VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.fchven
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.fchven V-table-Win
ON LEAVE OF FacCPedi.fchven IN FRAME F-Main /* Vencimiento */
DO:
  FIND TcmbCot WHERE  TcmbCot.Codcia = 0
    AND  (TcmbCot.Rango1 <=  DATE(Faccpedi.FchVen:SCREEN-VALUE) - DATE(Faccpedi.FchPed:SCREEN-VALUE) + 1
    AND   TcmbCot.Rango2 >= DATE(Faccpedi.FchVen:SCREEN-VALUE) - DATE(Faccpedi.FchPed:SCREEN-VALUE) + 1 )
    NO-LOCK NO-ERROR.
  IF AVAIL TcmbCot THEN DO:
    DISPLAY TcmbCot.TpoCmb @ FacCPedi.TpoCmb
        WITH FRAME {&FRAME-NAME}.
    S-TPOCMB = TcmbCot.TpoCmb.  
  END.
  RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FmaPgo V-table-Win
ON LEAVE OF FacCPedi.FmaPgo IN FRAME F-Main /* Cond.Vta */
DO:
  F-CndVta:SCREEN-VALUE = ''.
  s-CndVta = SELF:SCREEN-VALUE.
  FIND gn-convt WHERE gn-convt.Codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  /* Filtrado de las condiciones de venta */
  IF LOOKUP(SELF:SCREEN-VALUE, s-cndvta-validos) = 0 THEN DO:
      MESSAGE 'Condición de venta NO autorizado para este cliente'
          VIEW-AS ALERT-BOX WARNING.
      SELF:SCREEN-VALUE = '001'.
      RETURN NO-APPLY.
  END.
  IF AVAILABLE gn-convt THEN DO:
    F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
    /* Ubica la Condicion Venta */
    FIND TcmbCot WHERE  TcmbCot.Codcia = 0
      AND (TcmbCot.Rango1 <= gn-convt.totdias
      AND  TcmbCot.Rango2 >= gn-convt.totdias)
      NO-LOCK NO-ERROR.
    IF AVAIL TcmbCot THEN DO:
         DISPLAY TcmbCot.TpoCmb @ FacCPedi.TpoCmb
                 WITH FRAME {&FRAME-NAME}.
         S-TPOCMB = TcmbCot.TpoCmb.  
    END.
  END.
  RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FmaPgo V-table-Win
ON LEFT-MOUSE-DBLCLICK OF FacCPedi.FmaPgo IN FRAME F-Main /* Cond.Vta */
OR left-mouse-dblclick OF Faccpedi.fmapgo
DO:
    input-var-1 = s-cndvta-validos.
    input-var-2 = ''.
    input-var-3 = ''.

/*     RUN vta/d-cndvta.                         */
/*     IF output-var-1 = ? THEN RETURN NO-APPLY. */
/*     SELF:SCREEN-VALUE = output-var-2.         */
/*     f-cndvta:SCREEN-VALUE = output-var-3.     */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.NroCard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.NroCard V-table-Win
ON LEAVE OF FacCPedi.NroCard IN FRAME F-Main /* Nro.Tarjeta */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  ASSIGN
    SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999") NO-ERROR.
  FIND Gn-Card WHERE Gn-Card.NroCard = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Gn-Card THEN DO:
     S-NROTAR = SELF:SCREEN-VALUE.
     RUN vta/D-RegCar (INPUT S-NROTAR).
     IF S-NROTAR = "" THEN DO:
         APPLY "ENTRY" TO Faccpedi.NroCard.
         RETURN NO-APPLY.
     END.
  END.
  F-NomTar:SCREEN-VALUE = ''.
  FIND Gn-Card WHERE Gn-Card.NroCard = SELF:SCREEN-VALUE 
    NO-LOCK NO-ERROR.
  IF AVAILABLE GN-CARD THEN F-NomTar:SCREEN-VALUE = GN-CARD.NomClie[1].
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.TpoCmb V-table-Win
ON LEAVE OF FacCPedi.TpoCmb IN FRAME F-Main /* T/  Cambio */
DO:
    S-TPOCMB = DEC(FacCPedi.TpoCmb:SCREEN-VALUE).
    
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
  FOR EACH PEDI:
    DELETE PEDI.
  END.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN DO:
    FOR EACH facdPedi OF faccPedi NO-LOCK:
        CREATE PEDI.
        BUFFER-COPY FacDPedi TO PEDI
            ASSIGN PEDi.CanAte = 0.
        RELEASE PEDI.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Pedido V-table-Win 
PROCEDURE Borra-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH FacDPedi OF FacCPedi NO-LOCK TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR'
        ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND B-DPEDI WHERE ROWID(B-DPEDI) = ROWID(FacDPedi) EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE B-DPEDI THEN UNDO, RETURN 'ADM-ERROR'.
    DELETE B-DPedi.
    RELEASE B-DPEDI.
  END.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierre-de-atencion V-table-Win 
PROCEDURE Cierre-de-atencion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Cierre de atención */
    FIND FIRST ExpTurno WHERE expturno.codcia = s-codcia
        AND expturno.coddiv = s-coddiv
        AND expturno.block = s-codter
        AND expturno.estado = 'P'
        AND expturno.fecha = TODAY
        AND expturno.codcli = faccpedi.codcli
        NO-LOCK NO-ERROR.
    IF AVAILABLE ExpTurno THEN DO:
        MESSAGE 'CERRAMOS la atención?' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO
            UPDATE rpta AS LOG.
        IF rpta = YES 
        THEN DO:
            FIND CURRENT ExpTurno EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            FIND B-CPEDI WHERE ROWID(B-CPEDI) = ROWID(FacCPedi) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF AVAILABLE ExpTurno AND AVAILABLE B-CPEDI
            THEN ASSIGN
                    Expturno.Estado = 'C'
                    B-CPedi.Libre_c05 = '*'.
            RELEASE ExpTurno.
            RELEASE B-CPEDI.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Excel V-table-Win 
PROCEDURE Genera-Excel :
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
DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 10.
DEFINE VARIABLE x-item                  AS INTEGER .
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.

DEFINE VARIABLE x-desmon                AS CHARACTER.
DEFINE VARIABLE x-enletras              AS CHARACTER.

RUN bin/_numero(FacCPedi.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF FacCPedi.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").
X-desmon = (IF FacCPedi.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

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
chWorkSheet:Columns("B"):ColumnWidth = 6.
chWorkSheet:Columns("C"):ColumnWidth = 45.
chWorkSheet:Columns("D"):ColumnWidth = 15.
chWorkSheet:Columns("E"):ColumnWidth = 8.
chWorkSheet:Columns("F"):ColumnWidth = 20.
chWorkSheet:Columns("G"):ColumnWidth = 20.
chWorkSheet:Columns("H"):ColumnWidth = 20.

chWorkSheet:Columns("A:A"):NumberFormat = "0".
chWorkSheet:Columns("B:B"):NumberFormat = "@".
chWorkSheet:Columns("C:C"):NumberFormat = "@".
chWorkSheet:Columns("D:D"):NumberFormat = "@".
chWorkSheet:Columns("E:E"):NumberFormat = "@".
chWorkSheet:Columns("F:F"):NumberFormat = "0.0000".
chWorkSheet:Columns("G:G"):NumberFormat = "0.00".
chWorkSheet:Columns("H:H"):NumberFormat = "0.00".

chWorkSheet:Range("A10:H10"):Font:Bold = TRUE.
chWorkSheet:Range("A10"):Value = "Item".
chWorkSheet:Range("B10"):Value = "Codigo".
chWorkSheet:Range("C10"):Value = "Descripcion".
chWorkSheet:Range("D10"):Value = "Marca".
chWorkSheet:Range("E10"):Value = "Unidad".
chWorkSheet:Range("F10"):Value = "Precio".
chWorkSheet:Range("G10"):Value = "Cantidad".
chWorkSheet:Range("H10"):Value = "Importe".

chWorkSheet:Range("A2"):Value = "Cotizacion: " + FacCPedi.NroPed.
chWorkSheet:Range("A3"):Value = "Fecha     : " + STRING(FacCPedi.FchPed,"99/99/9999").
chWorkSheet:Range("A4"):Value = "Cliente   : " + FacCPedi.Codcli + " " + FacCPedi.Nomcli.
chWorkSheet:Range("A5"):Value = "Vendedor  : " + FacCPedi.CodVen + " " + F-Nomven:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
chWorkSheet:Range("A6"):Value = "Moneda    : " + x-desmon.

FOR EACH FacDPedi OF FacCPedi :
    x-item  = x-item + 1.
    FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                        Almmmatg.CodMat = FacDPedi.CodMat
                        NO-LOCK NO-ERROR.
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = x-item.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = FacDPedi.codmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = FacDPedi.undvta.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = FacDPedi.preuni.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = FacDPedi.canped.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = FacDPedi.implin.

END.

iColumn = iColumn + 2.                           
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "SON : " + x-enletras.

iColumn = iColumn + 2.                           
cColumn = STRING(iColumn).
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = FacCPedi.imptot.

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

  FOR EACH PEDI NO-LOCK BY PEDI.NroItm TRANSACTION ON STOP UNDO, RETURN 'ADM-ERROR'
        ON ERROR UNDO, RETURN 'ADM-ERROR': 
    I-NITEM = I-NITEM + 1.
    CREATE FacDPedi.
    BUFFER-COPY PEDI TO FacDPedi
        ASSIGN
            FacDPedi.CodCia = FacCPedi.CodCia
            FacDPedi.CodDiv = FacCPedi.CodDiv
            FacDPedi.coddoc = FacCPedi.coddoc
            FacDPedi.NroPed = FacCPedi.NroPed
            FacDPedi.FchPed = FacCPedi.FchPed
            FacDPedi.Hora   = FacCPedi.Hora 
            FacDPedi.FlgEst = FacCPedi.FlgEst
            FacDPedi.NroItm = I-NITEM.
    RELEASE FacDPedi.
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

{vta/graba-totales.i}

/*
{vtaexp/graba-totales.i}
*/


/*
  DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
  DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.
  DEFINE VARIABLE X-STANDFORD AS DECIMAL NO-UNDO.
  DEFINE VARIABLE X-LINEA1 AS DECIMAL NO-UNDO.
  DEFINE VARIABLE X-OTROS AS DECIMAL NO-UNDO.
  DEFINE VARIABLE Y-IMPTOT AS DECIMAL NO-UNDO.

  ASSIGN
    FacCPedi.ImpDto = 0
    FacCPedi.ImpIgv = 0
    FacCPedi.ImpIsc = 0
    FacCPedi.ImpTot = 0
    FacCPedi.ImpExo = 0
    FacCPedi.Importe[3] = 0.
  FOR EACH FacDPedi OF FacCPedi NO-LOCK: 
    FacCPedi.ImpDto = FacCPedi.ImpDto + FacDPedi.ImpDto.
    F-Igv = F-Igv + FacDPedi.ImpIgv.
    F-Isc = F-Isc + FacDPedi.ImpIsc.
    FacCPedi.ImpTot = FacCPedi.ImpTot + FacDPedi.ImpLin.
    IF NOT FacDPedi.AftIgv THEN FacCPedi.ImpExo = FacCPedi.ImpExo + FacDPedi.ImpLin.
    /******************Identificacion de Importes para Descuento**********/
    FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND 
                         Almmmatg.Codmat = FacDPedi.CodMat NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN DO:
        IF Almmmatg.CodFam = "002" AND Almmmatg.SubFam = "012" AND TRIM(Almmmatg.Desmar) = "STANDFORD" 
        THEN X-STANDFORD = X-STANDFORD + FacDPedi.ImpLin.
        IF FacDPedi.Por_Dsctos[3] = 0 THEN DO:
           IF Almmmatg.CodFam = "001" 
           THEN X-LINEA1 = X-LINEA1 + FacDPedi.ImpLin.
           ELSE X-OTROS = X-OTROS + FacDPedi.ImpLin.
        END.                
    END.
    /*********************************************************************/
  END.
  Y-IMPTOT = ( X-LINEA1 + X-OTROS ) .   
  ASSIGN
    FacCPedi.ImpIgv = ROUND(F-IGV,2)
    FacCPedi.ImpIsc = ROUND(F-ISC,2)
    FacCPedi.ImpBrt = FacCPedi.ImpTot - FacCPedi.ImpIgv - FacCPedi.ImpIsc + 
                        FacCPedi.ImpDto - FacCPedi.ImpExo
    FacCPedi.ImpVta = FacCPedi.ImpBrt - FacCPedi.ImpDto
    FacCPedi.ImpDto = FacCPedi.ImpDto + ROUND(FacCPedi.ImpTot * FacCPedi.PorDto / 100,2)
    FacCPedi.ImpTot = ROUND(FacCPedi.ImpTot * (1 - FacCPedi.PorDto / 100),2)
    FacCPedi.ImpVta = ROUND(FacCPedi.ImpTot / (1 + FacCPedi.PorIgv / 100),2)
    FacCPedi.ImpIgv = FacCPedi.ImpTot - FacCPedi.ImpVta
    FacCPedi.ImpBrt = FacCPedi.ImpTot - FacCPedi.ImpIgv - FacCPedi.ImpIsc + 
                        FacCPedi.ImpDto - FacCPedi.ImpExo.
    FacCPedi.Importe[3] = IF Y-IMPTOT > FacCPedi.ImpTot THEN FacCPedi.ImpTot ELSE Y-IMPTOT.
*/

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
                  AND  (TcmbCot.Rango1 <=  DATE(Faccpedi.FchPed:SCREEN-VALUE IN FRAME {&FRAME-NAME}) - DATE(Faccpedi.FchVen:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + 1
                  AND   TcmbCot.Rango2 >= DATE(Faccpedi.FchPed:SCREEN-VALUE IN FRAME {&FRAME-NAME}) - DATE(Faccpedi.FchVen:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + 1 )
                 NO-LOCK NO-ERROR.
    IF AVAIL TcmbCot THEN DO:
        DISPLAY TcmbCot.TpoCmb @ FacCPedi.TpoCmb
                WITH FRAME {&FRAME-NAME}.
        S-TPOCMB = TcmbCot.TpoCmb.  
    END.

    
    f-totdias = DATE(Faccpedi.FchPed:SCREEN-VALUE IN FRAME {&FRAME-NAME}) - DATE(Faccpedi.FchVen:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + 1.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir-Txt V-table-Win 
PROCEDURE Imprimir-Txt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       init ""
------------------------------------------------------------------------------*/
  DEFINE VARIABLE o-file AS CHARACTER.

  IF FacCPedi.FlgEst <> "A" THEN DO:
/*      RUN VTA/d-file.r (OUTPUT o-file).*/

      RUN VTA\R-ImpTxt.r(ROWID(FacCPedi), 
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        s-Copia-Registro = NO
        BUTTON-Turno-Avanza:SENSITIVE = YES
        BUTTON-Turno-Retrocede:SENSITIVE = YES.

    FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
        AND FacCorre.CodDoc = S-CODDOC 
        AND FacCorre.CodDiv = S-CODDIV 
        AND Faccorre.Codalm = S-CodAlm
        NO-LOCK NO-ERROR.
    DISPLAY
        STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ FacCPedi.NroPed.
    ASSIGN
        s-TpoCmb = 1
        S-NroTar = "".
    FIND TcmbCot WHERE  TcmbCot.Codcia = 0
        AND  (TcmbCot.Rango1 <= TODAY - TODAY + 1
        AND   TcmbCot.Rango2 >= TODAY - TODAY + 1)
        NO-LOCK NO-ERROR.
    IF AVAIL TcmbCot THEN S-TPOCMB = TcmbCot.TpoCmb.  
    DISPLAY 
        TODAY @ FacCPedi.FchPed
        01/07/2010 @ FacCPedi.FchEnt
        S-TPOCMB @ FacCPedi.TpoCmb
        (TODAY + 90) @ FacCPedi.FchVen
        '001' @ FacCPedi.FmaPgo.
    ASSIGN
        C-TpoVta:SENSITIVE = YES
        S-CODMON = INTEGER(FacCPedi.CodMon:SCREEN-VALUE)
        S-CODCLI = Faccpedi.CodCli:SCREEN-VALUE
        S-CNDVTA = FacCPedi.FmaPgo:SCREEN-VALUE.
    /* vendedor del terminal */
    FIND GN-VEN WHERE gn-ven.codcia = s-codcia
        AND gn-ven.codven = s-codven NO-LOCK NO-ERROR.
    DISPLAY 
        s-codven @ FacCPedi.CodVen
        gn-ven.nomven @ F-NomVen.
    /* cliente que espera turno */        
    FIND FIRST ExpTurno WHERE expturno.codcia = s-codcia
        AND expturno.coddiv = s-coddiv
        AND ExpTurno.Block = s-codter
        AND expturno.fecha = TODAY
        AND ExpTurno.Estado = 'P'
        NO-LOCK NO-ERROR.
    IF AVAILABLE ExpTurno THEN DO:
        FILL-IN-1:SCREEN-VALUE = TRIM(ExpTurno.Tipo) + '-' +
                                TRIM(STRING(ExpTurno.Turno)).
        FIND GN-CLIE WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = expturno.codcli NO-LOCK NO-ERROR.
        IF AVAILABLE GN-CLIE
        THEN DISPLAY 
                    gn-clie.codcli @ FacCPedi.CodCli            
                    gn-clie.nomcli @ FacCPedi.NomCli
                    gn-clie.dircli @ FacCPedi.DirCli 
                    gn-clie.nrocard @ FacCPedi.NroCard 
                    gn-clie.ruc @ FacCPedi.RucCli
                    gn-clie.Codpos @ FacCPedi.CodPos.
    END.
    RUN Actualiza-Item.
    RUN Procesa-Handle IN lh_Handle ('Pagina2').
    APPLY 'ENTRY':U TO FacCPedi.CodCli.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
    FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
        AND FacCorre.CodDoc = S-CODDOC 
        AND FacCorre.CodDiv = S-CODDIV 
        AND Faccorre.Codalm = S-CodAlm
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCorre THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN 
        FacCPedi.CodCia = S-CODCIA
        FacCPedi.CodDoc = s-coddoc 
        FacCPedi.FchPed = TODAY 
        FacCPedi.CodAlm = S-CODALM
        FacCPedi.PorIgv = FacCfgGn.PorIgv 
        FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        FacCPedi.CodDiv = S-CODDIV
        FacCPedi.TpoPed = "".
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
  END.
  ELSE DO:
    RUN Borra-Pedido. 
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.
  
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN 
        C-TPOVTA.
        /*X-NRODEC = INTEGER(F-NRODEC:SCREEN-VALUE).*/
     ASSIGN 
        FacCPedi.Hora = STRING(TIME,"HH:MM")
        FacCPedi.Usuario = S-USER-ID
        FacCPedi.TipVta  = STRING(LOOKUP(C-TpoVta,C-TpoVta:LIST-ITEMS))
        FacCPedi.Cmpbnte = (IF FacCPedi.TipVta = '1' THEN 'FAC' ELSE 'BOL')
        FacCPedi.Observa = F-Observa.

    RUN Genera-Pedido.    /* Detalle del pedido */ 
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    RUN Graba-Totales.
    
    C-TpoVta:SENSITIVE = NO. 
  END.  
  
  RELEASE FacCorre.
  
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse'). 

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
     FaccPedi.NomCli:SENSITIVE = NO.
     FaccPedi.RucCli:SENSITIVE = NO.
     FaccPedi.DirCli:SENSITIVE = NO.
  END. 
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
  IF NOT AVAILABLE FaccPedi THEN RETURN "ADM-ERROR".
  ASSIGN
    S-CODMON = FaccPedi.CodMon
    S-CODCLI = FaccPedi.CodCli
    S-CODIGV = IF FacCPedi.FlgIgv THEN 1 ELSE 2
    C-TpoVta:SENSITIVE IN FRAME {&FRAME-NAME} = YES
    S-TPOCMB = FacCPedi.TpoCmb
    X-NRODEC = IF s-CodDiv = '00013' THEN 4 ELSE 2
    s-NroTar = FacCPedi.NroCard
    S-CNDVTA = FacCPedi.FmaPgo.
  L-CREA = NO.
  RUN Actualiza-Item.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  L-CREA = YES.
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY "" @ FaccPedi.NroPed
             "" @ F-Estado.
    FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
        AND FacCorre.CodDoc = S-CODDOC 
        AND FacCorre.CodDiv = S-CODDIV 
        AND Faccorre.Codalm = S-CodAlm
        NO-LOCK NO-ERROR.
    DISPLAY
        STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ FacCPedi.NroPed.
    FIND TcmbCot WHERE  TcmbCot.Codcia = 0
        AND  (TcmbCot.Rango1 <= TODAY - TODAY + 1
        AND   TcmbCot.Rango2 >= TODAY - TODAY + 1)
        NO-LOCK NO-ERROR.
    IF AVAIL TcmbCot THEN S-TPOCMB = TcmbCot.TpoCmb.  
    DISPLAY 
        TODAY @ FacCPedi.FchPed
        TODAY @ FacCPedi.FchEnt
        S-TPOCMB @ FacCPedi.TpoCmb
        (TODAY + 150) @ FacCPedi.FchVen.
    /* RHC 20.01.07 */
    FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
      AND  gn-clie.CodCli = s-codcli
      NO-LOCK NO-ERROR.
    DISPLAY 
      gn-clie.NomCli @ Faccpedi.NomCli
      gn-clie.Ruc    @ Faccpedi.RucCli
      gn-clie.DirCli @ Faccpedi.DirCli
      gn-clie.NroCard @ FacCPedi.NroCard
      WITH FRAME {&FRAME-NAME}.
    /* ************* */
  END.
  s-Copia-Registro = YES.   /* <<< OJO >>> */
  /* Cargamos las condiciones de venta válidas */
  s-cndvta-validos = gn-clie.cndvta.
  RUN Recalcula-Precios.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('Browse').

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
/*  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
 *     AND FacCorre.CodDoc = S-CODDOC 
 *     AND FacCorre.CodDiv = S-CODDIV 
 *     AND Faccorre.Codalm = S-CodAlm
 *     EXCLUSIVE-LOCK NO-ERROR.
 *   IF NOT AVAILABLE FacCorre THEN RETURN 'ADM-ERROR'.*/

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
/*  ASSIGN 
 *     FacCPedi.CodCia = S-CODCIA
 *     FacCPedi.CodDoc = s-coddoc 
 *     FacCPedi.FchPed = TODAY 
 *     FacCPedi.CodAlm = S-CODALM
 *     FacCPedi.PorIgv = FacCfgGn.PorIgv 
 *     FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
 *     FacCPedi.CodDiv = S-CODDIV
 *     FacCPedi.TpoPed = "".
 *   ASSIGN
 *     FacCorre.Correlativo = FacCorre.Correlativo + 1.
 *   RELEASE FacCorre.*/
 
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
       MESSAGE "No puede eliminar una cotizacion TOTALMENTE atendida" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    IF FacCPedi.FlgEst = "X" THEN DO:
       MESSAGE "No puede eliminar una cotizacion CERRADA" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    FIND FIRST facdpedi OF faccpedi WHERE CanAte > 0 NO-LOCK NO-ERROR.
    IF AVAILABLE FacDPedi THEN DO:
       MESSAGE "No puede eliminar un pedido PARCIALMENTE atendido" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.

    FIND CURRENT FacCPedi EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCPedi THEN RETURN 'ADM-ERROR'.
    ASSIGN
        FacCPedi.FlgEst = 'A'
        FacCPedi.Glosa  = " A N U L A D O".
    FIND CURRENT FacCPedi NO-LOCK.
        
    RUN Procesa-Handle IN lh_Handle ('browse').
    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
        BUTTON-Turno-Avanza:SENSITIVE IN FRAME {&FRAME-NAME} = NO
        BUTTON-Turno-Retrocede:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

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
  /*F-Nrodec:HIDDEN IN FRAME {&FRAME-NAME} = YES. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE FacCPedi THEN DO WITH FRAME {&FRAME-NAME}:
     FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                   AND  gn-clie.CodCli = FacCPedi.CodCli 
                  NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie  THEN DO: 
        DISPLAY FaccPedi.NomCli 
                FaccPedi.RucCli  
                FaccPedi.DirCli.
        CASE FaccPedi.FlgEst:
          WHEN "A" THEN DISPLAY " ANULADO " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "C" THEN DISPLAY "ATENDIDO " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "P" THEN DISPLAY "PENDIENTE" @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "V" THEN DISPLAY " VENCIDO " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "X" THEN DISPLAY " CERRADA " @ F-Estado WITH FRAME {&FRAME-NAME}.
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
    ASSIGN
        C-TpoVta:SCREEN-VALUE = ENTRY(INTEGER(FacCPedi.TipVta),C-TpoVta:LIST-ITEMS)
        NO-ERROR.
    FIND almtabla WHERE almtabla.tabla = 'CP'
        AND almtabla.codigo = faccpedi.codpos
        NO-LOCK NO-ERROR.
    IF AVAILABLE almtabla
    THEN FILL-IN-Postal:SCREEN-VALUE = almtabla.nombre.
    ELSE FILL-IN-Postal:SCREEN-VALUE = ''.
    IF FaccPedi.FchVen < TODAY AND FacCPedi.FlgEst = 'P'
    THEN DISPLAY " VENCIDO " @ F-Estado WITH FRAME {&FRAME-NAME}.
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
        FacCPedi.RucCli:SENSITIVE = NO
        FacCPedi.NomCli:SENSITIVE = NO
        FacCPedi.DirCli:SENSITIVE = NO
        FacCPedi.fchven:SENSITIVE = NO
        FacCPedi.TpoCmb:SENSITIVE = NO.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'NO' THEN DO:
        ASSIGN
            FacCPedi.CodCli:SENSITIVE = NO
            FacCPedi.fchven:SENSITIVE = NO
            FacCPedi.FmaPgo:SENSITIVE = NO
            /*FacCPedi.NroCard:SENSITIVE = NO*/
            FacCPedi.CodMon:SENSITIVE = NO
            FacCPedi.CodVen:SENSITIVE = NO
            FacCPedi.TpoCmb:SENSITIVE = NO.
            /*F-NroDec:SENSITIVE = NO.*/
/*        IF c-TpoVta:SCREEN-VALUE = 'Boleta'
 *         THEN ASSIGN
 *             FacCPedi.DirCli:SENSITIVE = YES
 *             FacCPedi.NomCli:SENSITIVE = YES.*/
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
  
  IF FacCPedi.FlgEst <> "A" THEN DO:
    /* RUN VTA\R-CotExpLib (ROWID(FacCPedi)). */
    RUN vtaexp/R-CotExpLib-1 (ROWID(FacCPedi)).
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

  F-Observa = FacCPedi.Observa.
  RUN vta\d-cotiza (INPUT-OUTPUT F-Observa,  
                        F-CndVta:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                        YES,
                        (DATE(FacCPedi.FchVen:SCREEN-VALUE IN FRAME {&FRAME-NAME}) - DATE(FacCPedi.FchPed:SCREEN-VALUE IN FRAME {&FRAME-NAME})) + 1
                        ).
  IF F-Observa = '***' THEN RETURN "ADM-ERROR".
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF RETURN-VALUE <> 'ADM-ERROR' THEN RUN Cierre-de-atencion.
  
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
      FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
           FacCorre.CodDoc = S-CODDOC AND
           FacCorre.CodDiv = S-CODDIV AND
           Faccorre.Codalm = S-CodAlm
           EXCLUSIVE-LOCK NO-ERROR.
/*  ELSE 
 *       FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
 *            FacCorre.CodDoc = S-CODDOC AND
 *            FacCorre.CodDiv = S-CODDIV NO-LOCK NO-ERROR.*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcula-Precios V-table-Win 
PROCEDURE Recalcula-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR f-Factor AS DEC.
  DEF VAR x-CanPed AS DEC.
  DEF VAR f-PreBas AS DEC.
  DEF VAR f-PreVta AS DEC.
  DEF VAR f-Dsctos AS DEC.
  DEF VAR y-Dsctos AS DEC.
  DEF VAR z-Dsctos AS DEC.
  
  FOR EACH PEDI:
    FIND Almmmatg OF PEDI NO-LOCK.
    ASSIGN
        f-Factor = Pedi.Factor
        x-CanPed = Pedi.CanPed.
    RUN vtamay/PrecioVenta (s-CodCia,
                        s-CodDiv,
                        s-CodCli,
                        s-CodMon,
                        s-TpoCmb,
                        f-Factor,
                        PEDI.CodMat,
                        s-CndVta,
                        x-CanPed,
                        4,
                        OUTPUT f-PreBas,
                        OUTPUT f-PreVta,
                        OUTPUT f-Dsctos,
                        OUTPUT y-Dsctos).
    /* RHC 8.11.05  DESCUENTO ADICIONAL POR EXPOLIBRERIA */
    z-Dsctos = 0.
    FIND FacTabla WHERE factabla.codcia = s-codcia
        AND factabla.tabla = 'EL'
        AND factabla.codigo = STRING(YEAR(TODAY), '9999')
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacTabla 
        AND y-Dsctos = 0 
        AND LOOKUP(TRIM(s-CndVta), '000,001') > 0 
        THEN DO:    /* NO Promociones */
        CASE Almmmatg.Chr__02:
            WHEN 'P' THEN z-Dsctos = 3.
            WHEN 'T' THEN z-Dsctos = 1.
        END CASE.
    END.
    IF AVAILABLE FacTabla 
        AND y-Dsctos = 0 
        AND LOOKUP(TRIM(s-CndVta), '400,401') > 0 
        THEN DO:    /* NO Promociones */
        CASE Almmmatg.Chr__02:
            WHEN 'P' THEN z-Dsctos = 3.
            WHEN 'T' THEN z-Dsctos = 1.
        END CASE.
    END.
    /* ************************************************* */
    ASSIGN 
      PEDI.PreBas = F-PreBas 
      PEDI.PreUni = f-PreVta
      PEDI.PorDto = f-Dsctos
      PEDI.Por_Dsctos[3] = y-Dsctos
      PEDI.Por_Dsctos[1] = z-Dsctos 
      PEDI.ImpDto = ROUND( PEDI.PreUni * PEDI.CanPed * (PEDI.Por_Dsctos[1] / 100),4 )
      PEDI.ImpLin = ROUND( PEDI.PreUni * PEDI.CanPed , 2 ) - PEDI.ImpDto.
    IF PEDI.AftIsc 
    THEN PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
    IF PEDI.AftIgv 
    THEN  PEDI.ImpIgv = PEDI.ImpLin - ROUND(PEDI.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
  END.
  
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

  IF p-state = 'update-begin':U THEN DO WITH FRAME {&FRAME-NAME}:
     L-CREA = NO.
     RUN Actualiza-Item.
     
     FacCPedi.TpoCmb:SENSITIVE = NO.
     
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
    IF gn-clie.FlgSit = "I" THEN DO:
       MESSAGE "Cliente esta Inactivo" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FacCPedi.CodCli.
       RETURN "ADM-ERROR".   
    END.
    IF gn-clie.FlgSit = "C" THEN DO:
       MESSAGE "Cliente esta Cesado" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FacCPedi.CodCli.
       RETURN "ADM-ERROR".   
    END.
    IF LOOKUP(TRIM(SELF:SCREEN-VALUE), x-ClientesVarios) > 0
    THEN DO:
      MESSAGE 'Clientes varios NO permitidos' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FacCPedi.CodCli.
      RETURN 'ADM-ERROR'.
    END.

    IF c-TpoVta:SCREEN-VALUE = "Factura" AND FacCpedi.RucCli:SCREEN-VALUE = '' THEN DO:
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
    FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-convt THEN DO:
       MESSAGE "Condicion Venta no existe" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FacCPedi.FmaPgo.
       RETURN "ADM-ERROR".   
    END.
    IF FacCPedi.FmaPgo:SCREEN-VALUE = "000" THEN DO:
       MESSAGE "Condicion Venta no debe ser contado" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FacCPedi.FmaPgo.
       RETURN "ADM-ERROR".   
    END.
 
    IF FacCPedi.CodPos:SCREEN-VALUE = ''
    THEN DO:
        MESSAGE 'Ingrese el código postal'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FacCPedi.CodPos.
        RETURN 'ADM-ERROR':U.
    END.
    FIND almtabla WHERE almtabla.tabla = 'CP'
        AND almtabla.codigo = FacCPedi.CodPos:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almtabla
    THEN DO:
        MESSAGE 'Código Postal no Registrado'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FacCPedi.CodPos.
        RETURN 'ADM-ERROR':U.
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
 
    FOR EACH PEDI NO-LOCK BREAK BY ALMDES:
        IF FIRST-OF(ALMDES) THEN DO:
           X-FREC = X-FREC + 1.
        END.        
        F-Tot = F-Tot + PEDI.ImpLin.
    END.
    IF F-Tot = 0 THEN DO:
       MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FacCPedi.CodCli.
       RETURN "ADM-ERROR".   
    END.
/*    IF X-FREC > 1 THEN DO:
 *        MESSAGE "No puede despachar de varios almacenes, modifique su cotizacion" VIEW-AS ALERT-BOX ERROR.
 *        APPLY "ENTRY" TO FacCPedi.CodCli.
 *        RETURN "ADM-ERROR".   
 *     END.*/
    /* RHC 20.09.05 Transferencia gratuita */
    IF FacCPedi.FmaPgo:SCREEN-VALUE = '900' AND Faccpedi.NroCar:SCREEN-VALUE <> '' THEN DO:
        MESSAGE 'En caso de transferencia gratuita NO es válido el Nº de Tarjeta' 
            VIEW-AS ALERT-BOX WARNING.
        RETURN 'ADM-ERROR'.
    END.
/*    /* RHC 11.01.05 MINIMO US$1000.00 */
 *     IF INTEGER(FacCPedi.CodMon:SCREEN-VALUE) = 1
 *     THEN f-Tot = f-Tot / DECIMAL(FacCPedi.TpoCmb:SCREEN-VALUE).
 *     IF f-Tot < 1000 THEN DO:
 *         MESSAGE 'El monto mínimo a cotizar es de US$1000.00' SKIP
 *                 'Necesita AUTORIZACION'
 *                 VIEW-AS ALERT-BOX WARNING.
 *         DEF VAR x-Rep AS CHAR.
 *         RUN lib/_clave ('PCL', OUTPUT x-Rep).
 *         IF x-Rep = 'ERROR' THEN RETURN 'ADM-ERROR'.
 *     END.*/
    /* RHC 9.01.08 MINIMO S/.3000.00 */
    IF INTEGER(FacCPedi.CodMon:SCREEN-VALUE) = 2
    THEN f-Tot = f-Tot * DECIMAL(FacCPedi.TpoCmb:SCREEN-VALUE).
    IF f-Tot < 3000 THEN DO:
        MESSAGE 'El monto mínimo a cotizar es de S/.3000.00' SKIP
                'Necesita AUTORIZACION'
                VIEW-AS ALERT-BOX WARNING.
        DEF VAR x-Rep AS CHAR.
        RUN lib/_clave ('PCL', OUTPUT x-Rep).
        IF x-Rep = 'ERROR' THEN RETURN 'ADM-ERROR'.
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
DEFINE VAR RPTA AS CHAR.

IF NOT AVAILABLE FacCPedi THEN RETURN "ADM-ERROR".
IF LOOKUP(FacCPedi.FlgEst,"C,A,X") > 0 THEN  RETURN "ADM-ERROR".

/* Si tiene atenciones parciales tambien se bloquea */
IF FacCPedi.Libre_c05 = '*' THEN DO:
    MESSAGE 'La Atención al Cliente YA FUE CERRADA'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

FIND FIRST facdpedi OF faccpedi WHERE CanAte > 0 NO-LOCK NO-ERROR.
IF AVAILABLE facdpedi 
THEN DO:
    MESSAGE "La Cotización tiene atenciones parciales" VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
ASSIGN
    S-CODMON = FacCPedi.CodMon
    S-CODCLI = FacCPedi.CodCli
    S-CODIGV = IF FacCPedi.FlgIgv THEN 1 ELSE 2
    C-TpoVta:SENSITIVE IN FRAME {&FRAME-NAME} = YES
    S-TPOCMB = FacCPedi.TpoCmb
    X-NRODEC = IF s-CodDiv = '00013' THEN 4 ELSE 2
    s-NroTar = FacCPedi.NroCard
    S-CNDVTA = FacCPedi.FmaPgo.
    
IF FacCPedi.fchven < TODAY THEN DO:
    FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
                  AND  Almacen.CodAlm = S-CODALM 
                 NO-LOCK NO-ERROR.
    RUN ALM/D-CLAVE ('EXPO',OUTPUT RPTA).
    IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
END.
/*F-Nrodec:HIDDEN = NO.*/
/*F-NRODEC:SCREEN-VALUE = STRING(X-NRODEC,"9").*/

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

