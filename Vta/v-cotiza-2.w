&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW

/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDI LIKE INTEGRAL.FacDPedi.


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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-nomcia AS CHAR.

DEF SHARED VARIABLE lh_Handle  AS HANDLE.
DEF SHARED VARIABLE S-CODCLI   AS CHAR.
DEF SHARED VARIABLE S-CODMON   AS INTEGER INITIAL 1.
DEF SHARED VARIABLE S-CODIGV   AS INTEGER INITIAL 1.
DEF SHARED VARIABLE S-CNDVTA   AS CHAR.
DEF SHARED VARIABLE S-TPOCMB AS DECIMAL.  
DEF SHARED VARIABLE S-NROTAR   AS CHAR.
DEF SHARED VARIABLE S-CODALM   AS CHAR.

DEF VAR F-Observa AS CHAR NO-UNDO.
DEF VAR cl-codcia AS INT NO-UNDO.
DEF VAR s-Copia-Registro AS LOG NO-UNDO INIT NO.

FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES FacCPedi
&Scoped-define FIRST-EXTERNAL-TABLE FacCPedi


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR FacCPedi.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS FacCPedi.CodCli FacCPedi.NomCli ~
FacCPedi.fchven FacCPedi.DirCli FacCPedi.TpoCmb FacCPedi.RucCli ~
FacCPedi.ordcmp FacCPedi.NroCard FacCPedi.TipVta FacCPedi.CodVen ~
FacCPedi.FmaPgo FacCPedi.CodMon FacCPedi.Glosa 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}CodCli ~{&FP2}CodCli ~{&FP3}~
 ~{&FP1}NomCli ~{&FP2}NomCli ~{&FP3}~
 ~{&FP1}fchven ~{&FP2}fchven ~{&FP3}~
 ~{&FP1}DirCli ~{&FP2}DirCli ~{&FP3}~
 ~{&FP1}TpoCmb ~{&FP2}TpoCmb ~{&FP3}~
 ~{&FP1}RucCli ~{&FP2}RucCli ~{&FP3}~
 ~{&FP1}ordcmp ~{&FP2}ordcmp ~{&FP3}~
 ~{&FP1}NroCard ~{&FP2}NroCard ~{&FP3}~
 ~{&FP1}CodVen ~{&FP2}CodVen ~{&FP3}~
 ~{&FP1}FmaPgo ~{&FP2}FmaPgo ~{&FP3}~
 ~{&FP1}Glosa ~{&FP2}Glosa ~{&FP3}
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.FchPed ~
FacCPedi.CodCli FacCPedi.NomCli FacCPedi.fchven FacCPedi.DirCli ~
FacCPedi.TpoCmb FacCPedi.RucCli FacCPedi.ordcmp FacCPedi.NroCard ~
FacCPedi.TipVta FacCPedi.CodVen FacCPedi.FmaPgo FacCPedi.CodMon ~
FacCPedi.Glosa 
&Scoped-Define DISPLAYED-OBJECTS F-Estado f-NomCard F-NomVen F-CndVta 

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
     SIZE 55 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     FONT 0 NO-UNDO.

DEFINE VARIABLE f-NomCard AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY .81 NO-UNDO.

DEFINE VARIABLE F-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.NroPed AT ROW 1.15 COL 9 COLON-ALIGNED
          LABEL "Numero" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .81
          FONT 0
     F-Estado AT ROW 1.19 COL 25 COLON-ALIGNED NO-LABEL
     FacCPedi.FchPed AT ROW 1.19 COL 95 COLON-ALIGNED
          LABEL "Fecha"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.CodCli AT ROW 1.96 COL 9 COLON-ALIGNED HELP
          "" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.NomCli AT ROW 1.96 COL 22 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
     FacCPedi.fchven AT ROW 1.96 COL 95 COLON-ALIGNED
          LABEL "Vencimiento" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.DirCli AT ROW 2.73 COL 9 COLON-ALIGNED FORMAT "x(70)"
          VIEW-AS FILL-IN 
          SIZE 73 BY .81
     FacCPedi.TpoCmb AT ROW 2.73 COL 95 COLON-ALIGNED
          LABEL "T/  Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.RucCli AT ROW 3.5 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.ordcmp AT ROW 3.5 COL 95 COLON-ALIGNED
          LABEL "Solicitud de Cotización"
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .81
     FacCPedi.NroCard AT ROW 4.27 COL 9 COLON-ALIGNED
          LABEL "Nro.Tarjeta"
          VIEW-AS FILL-IN 
          SIZE 11.57 BY .81
     f-NomCard AT ROW 4.27 COL 21 COLON-ALIGNED NO-LABEL
     FacCPedi.TipVta AT ROW 4.27 COL 97 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Factura", "1":U,
"Boleta", "2":U
          SIZE 12 BY 1.54
     FacCPedi.CodVen AT ROW 5.04 COL 9 COLON-ALIGNED FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
     F-NomVen AT ROW 5.04 COL 15 COLON-ALIGNED NO-LABEL
     FacCPedi.FmaPgo AT ROW 5.81 COL 9 COLON-ALIGNED
          LABEL "Cond.Vta" FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
     F-CndVta AT ROW 5.81 COL 15 COLON-ALIGNED NO-LABEL
     FacCPedi.CodMon AT ROW 5.81 COL 97 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.57 BY .77
     FacCPedi.Glosa AT ROW 6.58 COL 6.28
          VIEW-AS FILL-IN 
          SIZE 73 BY .81
     "Moneda  :" VIEW-AS TEXT
          SIZE 7.57 BY .5 AT ROW 5.81 COL 89
     "Comprobante:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 4.46 COL 87
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.FacCPedi
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: PEDI T "SHARED" ? INTEGRAL FacDPedi
   END-TABLES.
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
         HEIGHT             = 6.73
         WIDTH              = 111.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   EXP-FORMAT EXP-HELP                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.CodVen IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN FacCPedi.DirCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-NomCard IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FchPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.fchven IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.FmaPgo IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.Glosa IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FacCPedi.NroCard IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.ordcmp IN FRAME F-Main
   EXP-LABEL                                                            */
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME FacCPedi.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodCli V-table-Win
ON LEAVE OF FacCPedi.CodCli IN FRAME F-Main /* Codigo */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND gn-clie WHERE gn-clie.CodCia = cl-codcia
    AND gn-clie.CodCli = SELF:SCREEN-VALUE 
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN DO:
    MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  DISPLAY 
    gn-clie.NomCli @ Faccpedi.NomCli
    gn-clie.Ruc    @ Faccpedi.RucCli
    gn-clie.DirCli @ Faccpedi.DirCli
    gn-clie.CodVen @ FacCPedi.CodVen
    gn-clie.CndVta @ FacCPedi.FmaPgo
    WITH FRAME {&FRAME-NAME}.
  ASSIGN
    S-CODCLI = gn-clie.codcli
    S-CNDVTA = gn-clie.CndVta
    FacCPedi.CodCli:SENSITIVE = NO.
  IF gn-clie.CodCli <> FacCfgGn.CliVar THEN DO:
    ASSIGN
        FacCPedi.NomCli:SENSITIVE = NO
        FacCPedi.RucCli:SENSITIVE = NO
        FacCPedi.DirCli:SENSITIVE = NO.
    APPLY "ENTRY" TO FacCPedi.NroCard.
  END.   
  ELSE DO: 
    ASSIGN
        FacCPedi.NomCli:SENSITIVE = YES
        FacCPedi.RucCli:SENSITIVE = YES
        FacCPedi.DirCli:SENSITIVE = YES.
    APPLY "ENTRY" TO FacCPedi.NomCli.
  END. 

  /* RHC agregamos el distrito */
  FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept
    AND Tabdistr.Codprovi = gn-clie.codprov 
    AND Tabdistr.Coddistr = gn-clie.CodDist NO-LOCK NO-ERROR.
  IF AVAILABLE Tabdistr 
  THEN Faccpedi.DirCli:SCREEN-VALUE = TRIM(Faccpedi.DirCli:SCREEN-VALUE) + ' - ' +
                                        TabDistr.NomDistr.
  /* Ubica la Condicion Venta */
  FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt 
  THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
  ELSE F-CndVta:SCREEN-VALUE = "".

  /* Tipo de Cambio Cotizacion */
  FIND LAST TcmbCot WHERE TcmbCot.Codcia = 0
    AND  (TcmbCot.Rango1 <= gn-convt.totdias
    AND   TcmbCot.Rango2 >= gn-convt.totdias)
    NO-LOCK NO-ERROR.
  IF AVAIL TcmbCot THEN DO:
    DISPLAY     
        TcmbCot.TpoCmb @ FacCPedi.TpoCmb
        WITH FRAME {&FRAME-NAME}.
    S-TPOCMB = TcmbCot.TpoCmb.  
  END.
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodMon V-table-Win
ON VALUE-CHANGED OF FacCPedi.CodMon IN FRAME F-Main /* Cod!mon */
DO:
  IF S-CODMON <> INTEGER(Faccpedi.CodMon:SCREEN-VALUE) THEN DO:
    S-CODMON = INTEGER(Faccpedi.CodMon:SCREEN-VALUE).
    RUN Procesa-Handle IN lh_Handle ('Recalculo').
  END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodVen V-table-Win
ON LEAVE OF FacCPedi.CodVen IN FRAME F-Main /* Vendedor */
DO:
  F-NomVen:SCREEN-VALUE = "".
  IF FacCPedi.CodVen:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
    AND  gn-ven.CodVen = SELF:SCREEN-VALUE 
    NO-LOCK NO-ERROR.
  IF AVAILABLE gn-ven THEN F-NomVen:SCREEN-VALUE = gn-ven.NomVen.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.fchven
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.fchven V-table-Win
ON LEAVE OF FacCPedi.fchven IN FRAME F-Main /* Vencimiento */
DO:
  FIND LAST TcmbCot WHERE  TcmbCot.Codcia = 0
    AND  (TcmbCot.Rango1 <=  DATE(Faccpedi.FchVen:SCREEN-VALUE) - DATE(Faccpedi.FchPed:SCREEN-VALUE) + 1
    AND   TcmbCot.Rango2 >= DATE(Faccpedi.FchVen:SCREEN-VALUE) - DATE(Faccpedi.FchPed:SCREEN-VALUE) + 1 )
    NO-LOCK NO-ERROR.
  IF AVAIL TcmbCot AND s-TpoCmb <> TcmbCot.TpoCmb THEN DO:
    DISPLAY TcmbCot.TpoCmb @ FacCPedi.TpoCmb WITH FRAME {&FRAME-NAME}.
    S-TPOCMB = TcmbCot.TpoCmb.  
    RUN Procesa-Handle IN lh_Handle ('Recalculo').
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FmaPgo V-table-Win
ON LEAVE OF FacCPedi.FmaPgo IN FRAME F-Main /* Cond.Vta */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  F-CndVta:SCREEN-VALUE = "".
  FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt AND s-CndVta <> FacCPedi.FmaPgo:SCREEN-VALUE THEN DO:
    F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
    S-CNDVTA = FacCPedi.FmaPgo:SCREEN-VALUE.
    RUN Procesa-Handle IN lh_Handle ('Recalculo').
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.NroCard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.NroCard V-table-Win
ON LEAVE OF FacCPedi.NroCard IN FRAME F-Main /* Nro.Tarjeta */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  ASSIGN
    SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999")
    f-NomCard:SCREEN-VALUE = ''
    NO-ERROR.
  FIND Gn-Card WHERE Gn-Card.NroCard = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Gn-Card THEN DO:
    S-NROTAR = SELF:SCREEN-VALUE.
    RUN vta/D-RegCar (INPUT-OUTPUT S-NROTAR).
    IF S-NROTAR = "" THEN DO:
        APPLY "ENTRY" TO Faccpedi.NroCard.
        RETURN NO-APPLY.
    END.
    FIND Gn-Card WHERE Gn-Card.NroCard = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    f-NomCard:SCREEN-VALUE = gn-card.NomCard.
  END.
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
  DEF INPUT PARAMETER pCrear AS LOG.

  FOR EACH PEDI:
    DELETE PEDI.
  END.
  IF pCrear = NO THEN DO:
    FOR EACH facdPedi OF faccPedi NO-LOCK:
        CREATE PEDI.
        BUFFER-COPY FacDPedi TO PEDI.
    END.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Pedido V-table-Win 
PROCEDURE Genera-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

  RUN Borra-Pedido. 
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

  FOR EACH PEDI NO-LOCK BY PEDI.NroItm: 
    I-NITEM = I-NITEM + 1.
    CREATE FacDPedi.
    BUFFER-COPY PEDI TO Facdpedi
        ASSIGN       
            Facdpedi.codcia = Faccpedi.codcia
            Facdpedi.coddiv = Faccpedi.coddiv
            Facdpedi.coddoc = Faccpedi.coddoc
            Facdpedi.nroped = Faccpedi.nroped
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
  DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
  DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.
      
  ASSIGN
    FacCPedi.ImpDto = 0
    FacCPedi.ImpIgv = 0
    FacCPedi.ImpIsc = 0
    FacCPedi.ImpTot = 0
    FacCPedi.ImpExo = 0.
  FOR EACH PEDI NO-LOCK: 
    FacCPedi.ImpDto = FacCPedi.ImpDto + PEDI.ImpDto.
    F-Igv = F-Igv + PEDI.ImpIgv.
    F-Isc = F-Isc + PEDI.ImpIsc.
    FacCPedi.ImpTot = FacCPedi.ImpTot + PEDI.ImpLin.
    IF NOT PEDI.AftIgv THEN FacCPedi.ImpExo = FacCPedi.ImpExo + PEDI.ImpLin.
  END.
  ASSIGN
    FacCPedi.ImpIgv = ROUND(F-IGV,2)
    FacCPedi.ImpIsc = ROUND(F-ISC,2)
    FacCPedi.ImpBrt = FacCPedi.ImpTot - FacCPedi.ImpIgv - FacCPedi.ImpIsc + 
                        FacCPedi.ImpDto - FacCPedi.ImpExo
    FacCPedi.ImpVta = FacCPedi.ImpBrt - FacCPedi.ImpDto
    FacCPedi.ImpTot = ROUND(FacCPedi.ImpTot * (1 - FacCPedi.PorDto / 100),2)
    FacCPedi.ImpVta = ROUND(FacCPedi.ImpTot / (1 + FacCPedi.PorIgv / 100),2)
    FacCPedi.ImpIgv = FacCPedi.ImpTot - FacCPedi.ImpVta
    FacCPedi.ImpBrt = FacCPedi.ImpTot - FacCPedi.ImpIgv - FacCPedi.ImpIsc + 
                        FacCPedi.ImpDto - FacCPedi.ImpExo.

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
  /* Control del correlativo */
  FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
    AND FacCorre.CodDoc = S-CODDOC 
    AND FacCorre.CodDiv = S-CODDIV 
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCorre THEN DO:
   MESSAGE "Codigo de Documento no configurado" VIEW-AS ALERT-BOX ERROR.
   RETURN 'ADM-ERROR'.
  END.
  /* Tipo de cambio Cotizacion */
  FIND TcmbCot WHERE TcmbCot.Codcia = 0
    AND  (TcmbCot.Rango1 <= TODAY - TODAY + 1
    AND   TcmbCot.Rango2 >= TODAY - TODAY + 1)
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE TcmbCot THEN DO:
    MESSAGE 'NO está definido el tipo de cambio para las Cotizaciones'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  ASSIGN
    s-TpoCmb = TcmbCot.TpoCmb
    s-CodMon = 1
    s-CndVta = ''.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    DISPLAY 
        STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ FacCPedi.NroPed
        TODAY @ FacCPedi.fchped
        FacCfgGn.CliVar @ FacCPedi.CodCli
        TODAY @ FacCPedi.fchven
        s-TpoCmb @ FacCPedi.TpoCmb.
    ASSIGN
        FacCPedi.CodMon:SCREEN-VALUE = STRING(s-codmon)
        FacCPedi.TipVta:SCREEN-VALUE = '1'.                 /* Factura */
    RUN Actualiza-Item (YES).
  END.
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
  ASSIGN
    FacCPedi.Hora = STRING(TIME,"HH:MM")
    Faccpedi.usuario = s-user-id.

  RUN Genera-Pedido.    /* Detalle del pedido */ 
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  RUN Graba-Totales.
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
  /* Control del correlativo */
  FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
    AND FacCorre.CodDoc = S-CODDOC 
    AND FacCorre.CodDiv = S-CODDIV 
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCorre THEN DO:
   MESSAGE "Codigo de Documento no configurado" VIEW-AS ALERT-BOX ERROR.
   RETURN 'ADM-ERROR'.
  END.
  /* Tipo de cambio Cotizacion */
  FIND TcmbCot WHERE TcmbCot.Codcia = 0
    AND  (TcmbCot.Rango1 <= TODAY - TODAY + 1
    AND   TcmbCot.Rango2 >= TODAY - TODAY + 1)
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE TcmbCot THEN DO:
    MESSAGE 'NO está definido el tipo de cambio para las Cotizaciones'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  ASSIGN
    s-TpoCmb = TcmbCot.TpoCmb.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    S-CODMON = FacCPedi.CodMon
    S-CODCLI = FacCPedi.CodCli
    S-CODIGV = IF FacCPedi.FlgIgv THEN 1 ELSE 2
    S-CNDVTA = FacCPedi.FmaPgo.
  DISPLAY 
    STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ FacCPedi.NroPed
    TODAY @ FacCPedi.fchped
    TODAY @ FacCPedi.fchven
    s-TpoCmb @ FacCPedi.TpoCmb
    WITH FRAME {&FRAME-NAME}.
  RUN Actualiza-Item (YES).
  RUN Procesa-Handle IN lh_Handle ('Recalculo').
  RUN Procesa-Handle IN lh_Handle ('Pagina2').

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
  FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
    AND FacCorre.CodDoc = S-CODDOC 
    AND FacCorre.CodDiv = S-CODDIV 
    EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE 'No se pudo actualizar el control de correlativos'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    FacCPedi.CodCia = s-codcia
    FacCPedi.CodDiv = s-coddiv
    FacCPedi.CodDoc = s-coddoc
    FacCPedi.FchPed = TODAY
    FacCPedi.FlgEst = 'E'
    FacCPedi.NroPed = STRING(Faccorre.nroser, '999') +
                        STRING(Faccorre.correlativo, '999999').
  ASSIGN
    Faccorre.correlativo = Faccorre.correlativo + 1.
  RELEASE Faccorre.

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
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    ASSIGN
        FacCPedi.TpoCmb:SENSITIVE = NO.
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
  RUN vta/d-cotiza (INPUT-OUTPUT F-Observa,  
                        F-CndVta:SCREEN-VALUE IN FRAME {&FRAME-NAME},
/*                        FacCPedi.FlgIgv:SCREEN-VALUE IN FRAME {&FRAME-NAME},*/
                        Yes,
                        (DATE(FacCPedi.FchVen:SCREEN-VALUE IN FRAME {&FRAME-NAME}) - DATE(FacCPedi.FchPed:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + 1)
                        ).
  IF F-Observa = '***' THEN RETURN "ADM-ERROR".
  
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
   IF FacCPedi.CodCli:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCPedi.CodCli.
      RETURN "ADM-ERROR".   
   END.
   FIND gn-clie WHERE gn-clie.CodCia = cl-codcia
                 AND  gn-clie.CodCli = FacCPedi.CodCli:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-clie THEN DO:
      MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCPedi.CodCli.
      RETURN "ADM-ERROR".   
   END.
   IF FacCPedi.CodVen:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de Vendedor no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCPedi.CodVen.
      RETURN "ADM-ERROR".   
   END.
   FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
                AND  gn-ven.CodVen = FacCPedi.CodVen:SCREEN-VALUE
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
   FOR EACH PEDI NO-LOCK: 
       F-Tot = F-Tot + PEDI.ImpLin.
   END.
   IF F-Tot = 0 THEN DO:
      MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCPedi.CodCli.
      RETURN "ADM-ERROR".   
   END.
   /* RHC 09/03/04 */
   F-BOL = IF INTEGER(FacCPedi.CodMon:SCREEN-VALUE) = 1 THEN F-TOT
            ELSE F-Tot * DECIMAL(FacCPedi.TpoCmb:SCREEN-VALUE).
   IF FacCPedi.TipVta:SCREEN-VALUE = '2' AND F-BOL >= 1600
   THEN DO:
        MESSAGE "Venta Mayor a 1600.00 Ingresar Nro. Ruc., Verifique... " 
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FacCPedi.CodCli.
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
  DEFINE VAR RPTA AS CHAR.

  IF NOT AVAILABLE FacCPedi THEN RETURN "ADM-ERROR".

  IF LOOKUP(FacCPedi.FlgEst,"C,A,P") > 0 THEN  RETURN "ADM-ERROR".
  ASSIGN
    S-CODMON = FacCPedi.CodMon.
    S-CODCLI = FacCPedi.CodCli.
    S-CODIGV = IF FacCPedi.FlgIgv THEN 1 ELSE 2.
    S-TPOCMB = FacCPedi.TpoCmb.
    S-CNDVTA = FacCPedi.FmaPgo.

  IF FacCPedi.fchven < TODAY THEN DO:
    FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
                  AND  Almacen.CodAlm = S-CODALM 
                 NO-LOCK NO-ERROR.
    RUN ALM/D-CLAVE (Almacen.Clave,OUTPUT RPTA).
    IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
  END.
  RUN Actualiza-Item (NO).
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('browse').

  RETURN "OK".
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


