&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDM LIKE Facdpedm
       INDEX Llave01 CodCia CodDoc NroPed NroItm.



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
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-TERMINAL AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER INIT 1.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHAR.
DEFINE SHARED VARIABLE S-CNDVTA   AS CHAR INIT "000".
DEFINE SHARED VARIABLE CL-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-TPOCMB AS DECIMAL.  
DEFINE SHARED VARIABLE s-codter     LIKE ccbcterm.codter.

/* Local Variable Definitions ---                          */
FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
FIND LAST Gn-tccja WHERE Gn-tccja.Fecha <= TODAY NO-LOCK NO-ERROR.

DEF TEMP-TABLE PEDM-2 LIKE FacDPedm.  /* RESUMIR PEDIDO */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES Faccpedm
&Scoped-define FIRST-EXTERNAL-TABLE Faccpedm


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Faccpedm.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Faccpedm.CodCli Faccpedm.NomCli ~
Faccpedm.RucCli Faccpedm.DirCli Faccpedm.Cmpbnte Faccpedm.FmaPgo ~
Faccpedm.TpoCmb Faccpedm.CodVen Faccpedm.CodMon Faccpedm.Glosa 
&Scoped-define ENABLED-TABLES Faccpedm
&Scoped-define FIRST-ENABLED-TABLE Faccpedm
&Scoped-Define ENABLED-OBJECTS RECT-1 
&Scoped-Define DISPLAYED-FIELDS Faccpedm.NroPed Faccpedm.FchPed ~
Faccpedm.CodCli Faccpedm.NomCli Faccpedm.RucCli Faccpedm.DirCli ~
Faccpedm.Cmpbnte Faccpedm.FmaPgo Faccpedm.TpoCmb Faccpedm.CodVen ~
Faccpedm.CodMon Faccpedm.Glosa 
&Scoped-define DISPLAYED-TABLES Faccpedm
&Scoped-define FIRST-DISPLAYED-TABLE Faccpedm
&Scoped-Define DISPLAYED-OBJECTS F-Estado F-CndVta F-nomVen 

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
     SIZE 44.29 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .81
     FONT 0 NO-UNDO.

DEFINE VARIABLE F-nomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44.29 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 93 BY 5.19.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Faccpedm.NroPed AT ROW 1.19 COL 9 COLON-ALIGNED
          LABEL "Pedido" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 13.43 BY .81
          FONT 0
     F-Estado AT ROW 1.19 COL 40 COLON-ALIGNED NO-LABEL
     Faccpedm.FchPed AT ROW 1.19 COL 79 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Faccpedm.CodCli AT ROW 1.96 COL 9 COLON-ALIGNED HELP
          ""
          LABEL "Cliente"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     Faccpedm.NomCli AT ROW 1.96 COL 23 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 44 BY .81
     Faccpedm.RucCli AT ROW 1.96 COL 79 COLON-ALIGNED
          LABEL "Ruc/L.E" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .81
     Faccpedm.DirCli AT ROW 2.73 COL 9 COLON-ALIGNED
          LABEL "Direccion"
          VIEW-AS FILL-IN 
          SIZE 58 BY .81
     Faccpedm.Cmpbnte AT ROW 2.73 COL 79 COLON-ALIGNED
          LABEL "Comprobante"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "FAC","TCK" 
          DROP-DOWN-LIST
          SIZE 6.72 BY 1
     Faccpedm.FmaPgo AT ROW 3.5 COL 3.86
          LABEL "Cond.Vta"
          VIEW-AS COMBO-BOX INNER-LINES 2
          LIST-ITEMS "000","001" 
          DROP-DOWN-LIST
          SIZE 6.86 BY 1
     F-CndVta AT ROW 3.5 COL 17 COLON-ALIGNED NO-LABEL
     Faccpedm.TpoCmb AT ROW 3.5 COL 79 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Faccpedm.CodVen AT ROW 4.27 COL 9 COLON-ALIGNED FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 6.29 BY .81
     F-nomVen AT ROW 4.27 COL 17 COLON-ALIGNED NO-LABEL
     Faccpedm.CodMon AT ROW 4.46 COL 80.86 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.57 BY .81
     Faccpedm.Glosa AT ROW 5.04 COL 6.28
          LABEL "Glosa" FORMAT "X(100)"
          VIEW-AS FILL-IN 
          SIZE 52.43 BY .81
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 4.46 COL 74
     RECT-1 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.Faccpedm
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: PEDM T "SHARED" ? INTEGRAL Facdpedm
      ADDITIONAL-FIELDS:
          INDEX Llave01 CodCia CodDoc NroPed NroItm
      END-FIELDS.
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
         HEIGHT             = 5.19
         WIDTH              = 93.
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
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR COMBO-BOX Faccpedm.Cmpbnte IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Faccpedm.CodCli IN FRAME F-Main
   EXP-LABEL EXP-HELP                                                   */
/* SETTINGS FOR FILL-IN Faccpedm.CodVen IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN Faccpedm.DirCli IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-nomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Faccpedm.FchPed IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX Faccpedm.FmaPgo IN FRAME F-Main
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN Faccpedm.Glosa IN FRAME F-Main
   ALIGN-L EXP-LABEL EXP-FORMAT                                         */
/* SETTINGS FOR FILL-IN Faccpedm.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN Faccpedm.RucCli IN FRAME F-Main
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

&Scoped-define SELF-NAME Faccpedm.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Faccpedm.CodCli V-table-Win
ON LEAVE OF Faccpedm.CodCli IN FRAME F-Main /* Cliente */
DO:
  IF Faccpedm.CodCli:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
    AND  gn-clie.CodCli = Faccpedm.CodCli:SCREEN-VALUE 
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie  
  THEN DO:      /* CREA EL CLIENTE NUEVO */
    S-CODCLI = Faccpedm.CodCli:SCREEN-VALUE.
    RUN vtamay/d-regcli (INPUT-OUTPUT S-CODCLI).
    IF S-CODCLI = "" 
    THEN DO:
        APPLY "ENTRY" TO Faccpedm.CodCli.
        RETURN NO-APPLY.
    END.
    FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
        AND  gn-clie.CodCli = S-CODCLI 
        NO-LOCK NO-ERROR.
  END.
  /* BLOQUEO DEL CLIENTE */
  IF gn-clie.FlgSit = "I" THEN DO:
      MESSAGE "Cliente esta Inactivo" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF gn-clie.FlgSit = "C" THEN DO:
      MESSAGE "Cliente esta Cesado" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
 
  DO WITH FRAME {&FRAME-NAME}:
    IF SELF:SCREEN-VALUE <> FacCfgGn.CliVar
    THEN DISPLAY 
            gn-clie.CodCli  @ Faccpedm.CodCli
            gn-clie.ruc     @ Faccpedm.Ruccli
            /*gn-clie.NroCard @ Faccpedm.NroCard*/
            gn-clie.NomCli  @ Faccpedm.NomCli
            gn-clie.DirCli  @ Faccpedm.DirCli.
    ASSIGN
        S-CODMON = INTEGER(Faccpedm.CodMon:SCREEN-VALUE)
        S-CNDVTA = gn-clie.CndVta
        S-CODCLI = gn-clie.CodCli
        F-NomVen = "".
     IF gn-clie.Ruc = "" 
     THEN Faccpedm.Cmpbnte:SCREEN-VALUE = "TCK".
     ELSE Faccpedm.Cmpbnte:SCREEN-VALUE = "FAC".

    /* RUTINA DEL VENDEDOR */
    IF Faccpedm.codven:SCREEN-VALUE = '' THEN DO:
        s-CodVen = GN-CLIE.CodVen.
        IF s-CodVen = '' THEN DO:
            FIND FIRST FacUsers WHERE FacUsers.codcia = s-codcia
                AND FacUsers.CodDiv = s-coddiv
                AND FacUsers.usuario = s-user-id NO-LOCK NO-ERROR.
            IF AVAILABLE FacUsers THEN s-codven = FacUsers.CodVen.
        END.
        FIND GN-VEN WHERE GN-VEN.codcia = s-codcia
            AND GN-VEN.codven = s-codven NO-LOCK NO-ERROR.
        IF AVAILABLE GN-VEN THEN f-NomVen = GN-VEN.nomven.
        DISPLAY 
            s-codven @ faccpedm.codven
            f-nomven.
    END.


     IF gn-clie.CodCli <> FacCfgGn.CliVar THEN DO:
         Faccpedm.NomCli:SENSITIVE = NO.
         Faccpedm.DirCli:SENSITIVE = NO.
         APPLY "ENTRY" TO Faccpedm.Glosa.
         RETURN NO-APPLY.
     END.   
     ELSE DO: 
         Faccpedm.NomCli:SENSITIVE = YES.
         Faccpedm.DirCli:SENSITIVE = YES.
         APPLY "ENTRY" TO Faccpedm.NomCli.
         RETURN NO-APPLY.
     END.
  END.
  RUN Procesa-Handle IN lh_Handle ('browse').
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Faccpedm.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Faccpedm.CodMon V-table-Win
ON VALUE-CHANGED OF Faccpedm.CodMon IN FRAME F-Main /* Cod!mon */
DO:
  S-CODMON = INTEGER(Faccpedm.CodMon:SCREEN-VALUE).
  RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Faccpedm.CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Faccpedm.CodVen V-table-Win
ON LEAVE OF Faccpedm.CodVen IN FRAME F-Main /* Vendedor */
DO:
  F-NomVen:SCREEN-VALUE = ''.
  IF Faccpedm.CodVen:SCREEN-VALUE <> "" THEN DO: 
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
        AND gn-ven.CodVen = Faccpedm.CodVen:SCREEN-VALUE
        NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen:SCREEN-VALUE = gn-ven.NomVen.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Faccpedm.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Faccpedm.FmaPgo V-table-Win
ON VALUE-CHANGED OF Faccpedm.FmaPgo IN FRAME F-Main /* Cond.Vta */
DO:
   S-CNDVTA = FacCPedm.FmaPgo:SCREEN-VALUE.
   
   IF FacCPedm.FmaPgo:SCREEN-VALUE <> "" THEN DO:
      F-CndVta:SCREEN-VALUE = "".
      S-CNDVTA = FacCPedm.FmaPgo:SCREEN-VALUE.
      FIND gn-convt WHERE 
           gn-convt.Codig = FacCPedm.FmaPgo:SCREEN-VALUE 
           AND  gn-ConVt.TipVta BEGINS "1" NO-LOCK NO-ERROR.
      IF AVAILABLE gn-convt THEN DO:
         F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
      END.
   END.
   ELSE F-CndVta:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Faccpedm.RucCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Faccpedm.RucCli V-table-Win
ON LEAVE OF Faccpedm.RucCli IN FRAME F-Main /* Ruc/L.E */
DO:
  IF LENGTH(FacCPedm.RucCli:SCREEN-VALUE) <> 8 THEN 
  RETURN NO-APPLY.
  FacCPedm.RucCli:SENSITIVE = NO.
  
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
  FOR EACH PEDM:
    DELETE PEDM.
  END.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN DO:
    FOR EACH facdPedm OF FacCPedm NO-LOCK:
        CREATE PEDM.
        BUFFER-COPY FacDPedm TO PEDM.
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
  {src/adm/template/row-list.i "Faccpedm"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Faccpedm"}

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
  DEF INPUT PARAMETER p-Ok AS LOG.

  FOR EACH FacDPedm OF FacCPedm ON ERROR UNDO, RETURN 'ADM-ERROR':
    IF p-Ok = YES
    THEN DELETE FacDPedm.
    ELSE FacDPedm.FlgEst = 'A'.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cancelar-Pedido V-table-Win 
PROCEDURE Cancelar-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF NOT AVAILABLE FaccPedm THEN RETURN.
  IF FaccPedm.FlgEst <> "P" THEN RETURN.

  RUN vtamin/cancelar-pedido-mostrador-01 (ROWID(FacCPedm)).

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Pedido V-table-Win 
PROCEDURE Genera-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

  RUN Borra-Pedido (TRUE). 
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
  
  FOR EACH PEDM NO-LOCK BY PEDM.NroItm: 
    I-NITEM = I-NITEM + 1.
    CREATE FacDPedm.
    BUFFER-COPY PEDM TO FacDPedm
        ASSIGN
            FacDPedm.CodCia = FacCPedm.CodCia
            /*FacDPedm.CodDiv = FacCPedm.CodDiv*/
            FacDPedm.coddoc = FacCPedm.coddoc
            FacDPedm.NroPed = FacCPedm.NroPed
            FacDPedm.FchPed = FacCPedm.FchPed
            FacDPedm.Hora   = FacCPedm.Hora 
            FacDPedm.FlgEst = FacCPedm.FlgEst
            FacDPedm.NroItm = I-NITEM.
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
  DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
  DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.

  ASSIGN
    FacCPedm.ImpDto = 0
    FacCPedm.ImpIgv = 0
    FacCPedm.ImpIsc = 0
    FacCPedm.ImpTot = 0
    FacCPedm.ImpExo = 0.
  FOR EACH FacDPedm OF FacCPedm NO-LOCK: 
    /*FacCPedm.ImpDto = FacCPedm.ImpDto + FacDPedm.ImpDto.*/
    F-Igv = F-Igv + FacDPedm.ImpIgv.
    F-Isc = F-Isc + FacDPedm.ImpIsc.
    FacCPedm.ImpTot = FacCPedm.ImpTot + FacDPedm.ImpLin.
    IF NOT FacDPedm.AftIgv THEN FacCPedm.ImpExo = FacCPedm.ImpExo + FacDPedm.ImpLin.
    IF FacDPedm.AftIgv = YES
    THEN FacCPedm.ImpDto = FacCPedm.ImpDto + ROUND(FacDPedm.ImpDto / (1 + FacCPedm.PorIgv / 100), 2).
    ELSE FacCPedm.ImpDto = FacCPedm.ImpDto + FacDPedm.ImpDto.
  END.
  ASSIGN
    FacCPedm.ImpIgv = ROUND(F-IGV,2)
    FacCPedm.ImpIsc = ROUND(F-ISC,2)
    FacCPedm.ImpVta = FacCPedm.ImpTot - FacCPedm.ImpExo - FacCPedm.ImpIgv.
  IF FacCPedm.PorDto > 0 THEN DO:
    ASSIGN
        FacCPedm.ImpDto = FacCPedm.ImpDto + ROUND((FacCPedm.ImpVta + FacCPedm.ImpExo) * FacCPedm.PorDto / 100,2)
        FacCPedm.ImpTot = ROUND(FacCPedm.ImpTot * (1 - FacCPedm.PorDto / 100),2)
        FacCPedm.ImpVta = ROUND(FacCPedm.ImpVta * (1 - FacCPedm.PorDto / 100),2)
        FacCPedm.ImpExo = ROUND(FacCPedm.ImpExo * (1 - FacCPedm.PorDto / 100), 2)
        FacCPedm.ImpIgv = FacCPedm.ImpTot - FacCPedm.ImpExo - FacCPedm.ImpVta.
  END.
  FacCPedm.ImpBrt = FacCPedm.ImpVta + FacCPedm.ImpIsc + FacCPedm.ImpDto + FacCPedm.ImpExo.

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
  FIND LAST Gn-tccja WHERE Gn-tccja.Fecha <= TODAY NO-LOCK NO-ERROR.

    DEFINE VARIABLE lAnswer AS LOGICAL NO-UNDO.
    DEFINE BUFFER b-ccbccaja FOR ccbccaja.

    /* Verifica Monto Tope por CAJA */
    RUN ccb\p-vermtoic.p(OUTPUT lAnswer).
    IF lAnswer THEN RETURN ERROR.

    /* Busca I/C tipo "Sencillo" Activo */
    IF NOT s-codter BEGINS "ATE" THEN DO:
        lAnswer = FALSE.
        FOR EACH b-ccbccaja WHERE
            b-ccbccaja.codcia = s-codcia AND
            b-ccbccaja.coddiv = s-coddiv AND
            b-ccbccaja.coddoc = "I/C" AND
            b-ccbccaja.tipo = "SENCILLO" AND
            b-ccbccaja.usuario = s-user-id AND
            b-ccbccaja.codcaja = s-codter AND
            b-ccbccaja.flgcie = "P" NO-LOCK:
            IF b-ccbccaja.flgest <> "A" THEN lAnswer = TRUE.
        END.
        IF NOT lAnswer THEN DO:
            MESSAGE
                "Se debe ingresar el I/C SENCILLO como primer movimiento"
                VIEW-AS ALERT-BOX ERROR.
            RETURN ERROR.
        END.
    END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
        AND FacCorre.CodDoc = S-CODDOC 
        AND FacCorre.CodDiv = S-CODDIV 
        AND Faccorre.Codalm = S-CodAlm
        NO-LOCK NO-ERROR.
    DISPLAY
        STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ FacCPedm.NroPed.
    ASSIGN
        /*s-TpoCmb = FacCfgGn.TpoCmb[1] */
        s-TpoCmb = Gn-Tccja.Venta
        /*S-NroTar = ""*/.
    DISPLAY 
        TODAY @ FacCPedm.FchPed
        S-TPOCMB @ FacCPedm.TpoCmb
        /*TODAY @ FacCPedm.FchVen*/
        FacCfgGn.CliVar @ Faccpedm.CodCli.
    ASSIGN
        Faccpedm.fmapgo:SCREEN-VALUE = '000'
        S-CODMON = INTEGER(FacCPedm.CodMon:SCREEN-VALUE)
        S-CODCLI = FacCPedm.CodCli:SCREEN-VALUE
        S-CNDVTA = FacCPedm.FmaPgo:SCREEN-VALUE.
    FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
        AND gn-clie.CodCli = Faccpedm.CodCli:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie  
    THEN DO:
        DISPLAY 
            gn-clie.CodCli @ Faccpedm.CodCli
            gn-clie.ruc    @ Faccpedm.Ruccli.
        IF gn-clie.Ruc = "" 
        THEN Faccpedm.Cmpbnte:SCREEN-VALUE = "TCK".
        ELSE Faccpedm.Cmpbnte:SCREEN-VALUE = "FAC".
        ASSIGN
            Faccpedm.NomCli:SENSITIVE = YES
            Faccpedm.DirCli:SENSITIVE = YES.
    END.
    FIND gn-convt WHERE gn-convt.Codig = FacCPedm.FmaPgo:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.

    RUN Actualiza-Item.
    RUN Procesa-Handle IN lh_Handle ('Pagina2').
    APPLY "ENTRY" TO Faccpedm.CodCli.
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
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN 
        FacCPedm.Hora = STRING(TIME,"HH:MM")
        FacCPedm.Usuario = S-USER-ID.
     IF Faccpedm.FmaPgo = "001" AND Faccpedm.FlgEst = "" 
     THEN Faccpedm.FlgEst = "X".
     ELSE Faccpedm.FlgEst = "P".
    RUN Resume-Pedido.      /* Agrupa por codigos */
    RUN Genera-Pedido.    /* Detalle del pedido */ 
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    RUN Graba-Totales.
  END.  
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

  RUN Actualiza-Item.

  /* Code placed here will execute PRIOR to standard behavior. */
  IF NOT AVAILABLE faccpedm THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    S-CODMON = Faccpedm.CodMon
    S-CODCLI = Faccpedm.CodCli.
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY "" @ Faccpedm.NroPed
             "" @ F-Estado.
  END.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('Browse').

END PROCEDURE.


/*
  IF NOT AVAILABLE FacCPedm THEN RETURN "ADM-ERROR".
  ASSIGN
    S-CODMON = FacCPedm.CodMon
    S-CODCLI = FacCPedm.CodCli
    S-CODIGV = IF FacCPedm.FlgIgv THEN 1 ELSE 2
    S-TPOCMB = FacCPedm.TpoCmb
    s-NroTar = FacCPedm.NroCard
    S-CNDVTA = FacCPedm.FmaPgo.
  FOR EACH ITEM:
    DELETE ITEM.
  END.
  FOR EACH ITEM-2:
    DELETE ITEM-2.
  END.
  FOR EACH facdPedm OF FacCPedm NO-LOCK:
    CREATE ITEM.
    BUFFER-COPY FacDPedm TO ITEM.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
        AND FacCorre.CodDoc = S-CODDOC 
        AND FacCorre.CodDiv = S-CODDIV 
        AND Faccorre.Codalm = S-CodAlm
        NO-LOCK NO-ERROR.
    DISPLAY
        STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ FacCPedm.NroPed.
    ASSIGN
        s-TpoCmb = FacCfgGn.TpoCmb[1].
    DISPLAY 
        TODAY @ FacCPedm.FchPed
        S-TPOCMB @ FacCPedm.TpoCmb
        TODAY @ FacCPedm.FchVen.
    F-Estado:SCREEN-VALUE = ''.
  END.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('Recalcular-Precios').
  RUN Procesa-Handle IN lh_Handle ('Browse').
  s-Copia-Registro = YES.   /* <<< OJO >>> */
  s-Documento-Registro = '*' + STRING(faccpedm.coddoc, 'x(3)') + ' ' + STRING(faccpedm.nroped, 'x(9)').

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
    AND FacCorre.CodDoc = S-CODDOC 
    AND FacCorre.CodDiv = S-CODDIV 
    AND Faccorre.Codalm = S-CodAlm
    EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCorre THEN RETURN 'ADM-ERROR'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN 
    FacCPedm.CodCia = S-CODCIA
    FacCPedm.CodDoc = s-coddoc 
    FacCPedm.FchPed = TODAY 
    FacCPedm.FchVen = TODAY 
    FacCPedm.CodAlm = S-CODALM
    FacCPedm.PorIgv = FacCfgGn.PorIgv 
    FacCPedm.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
    FacCPedm.CodDiv = S-CODDIV
    FacCPedm.FlgEst = 'P'
    FacCPedm.TipVta = '1'.
  /* RHC 23.12.04 Control de pedidos hechos por copia de otro */
/*  IF s-Copia-Registro = YES
 *   THEN FacCPedm.CodTrans = s-Documento-Registro.       /* Este campo no se usa */*/
  /* ******************************************************** */
  ASSIGN
    FacCorre.Correlativo = FacCorre.Correlativo + 1.
  RELEASE FacCorre.

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
    IF FacCPedm.FlgEst = "A" THEN DO:
       MESSAGE "El pedido ya fue anulado" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    IF FacCPedm.FlgEst = "C" THEN DO:
       MESSAGE "No puede eliminar un pedido TOTALMENTE atendido" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    FIND CURRENT FacCPedm EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCPedm THEN RETURN 'ADM-ERROR'.
    RUN Borra-Pedido (NO).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN
        FacCPedm.FlgEst = 'A'
        FacCPedm.Glosa  = " A N U L A D O".
    FIND CURRENT FacCPedm NO-LOCK.
        
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE FacCPedm THEN DO WITH FRAME {&FRAME-NAME}:
    CASE Faccpedm.FlgEst:
          WHEN "A" THEN DISPLAY " ANULADO "   @ F-Estado .
          WHEN "C" THEN DISPLAY "CANCELADO"   @ F-Estado .
          WHEN "P" THEN DISPLAY "PENDIENTE"   @ F-Estado .
          WHEN "X" THEN DISPLAY "POR APROBAR" @ F-Estado .
          WHEN "S" THEN DISPLAY "POR MODIFICAR" @ F-Estado .
    END CASE.
    F-NomVen:screen-value = "".
    FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
                  AND  gn-ven.CodVen = FacCPedm.CodVen 
                 NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
    F-CndVta:SCREEN-VALUE = "".
    FIND gn-convt WHERE gn-convt.Codig = FacCPedm.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
    IF FacCPedm.FchVen < TODAY AND FacCPedm.FlgEst = 'P'
    THEN DISPLAY " VENCIDO " @ F-Estado WITH FRAME {&FRAME-NAME}.

/*    F-Nomtar:SCREEN-VALUE = ''.
 *     FIND Gn-Card WHERE Gn-Card.NroCard = FacCPedm.NroCar NO-LOCK NO-ERROR.
 *     IF AVAILABLE Gn-Card THEN F-NomTar:SCREEN-VALUE = GN-CARD.NomClie[1].*/
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
        FacCPedm.CodMon:SENSITIVE = NO
        FacCPedm.RucCli:SENSITIVE = NO
        FacCPedm.TpoCmb:SENSITIVE = NO
        Faccpedm.Cmpbnte:SENSITIVE = NO.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'NO'
    THEN ASSIGN
            FacCPedm.FmaPgo:SENSITIVE = NO
            FacCPedm.TpoCmb:SENSITIVE = NO.
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
  IF FacCPedm.FlgEst <> 'C' THEN RETURN.
  
  DEF VAR RPTA AS CHAR NO-UNDO.

  FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
  RPTA = "ERROR".        
  RUN ALM/D-CLAVE.R(FacCfgGn.Cla_Venta,OUTPUT RPTA). 
  
  IF RPTA = "ERROR" THEN DO:
      MESSAGE "No tiene Autorizacion Para Imprimir"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      RETURN.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia
        AND ccbcdocu.coddoc = Faccpedm.Cmpbnte
        AND CcbCDocu.CodPed = faccpedm.coddoc
        AND CcbCDocu.NroPed = faccpedm.nroped
        NO-LOCK NO-ERROR.
  IF AVAILABLE ccbcdocu AND ccbcdocu.coddoc = 'FAC'
  THEN RUN vtamin/r-impfac2 (ROWID(ccbcdocu)).
  IF AVAILABLE ccbcdocu AND ccbcdocu.coddoc = 'TCK' THEN DO:
    CASE s-codter:
        WHEN "TERM04" THEN RUN vtamin/r-tick500 (ROWID(ccbcdocu)).
        OTHERWISE RUN vtamin/r-tick01 (ROWID(ccbcdocu)).
    END CASE.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resume-Pedido V-table-Win 
PROCEDURE Resume-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* RHC 25.08.06
     COMO LOS ITEMS SE REPITEN ENTONCES PRIMERO LOS AGRUPAMOS POR CODIGO */
  
  FOR EACH PEDM-2:
    DELETE PEDM-2.
  END.

  FOR EACH PEDM BY PEDM.CodMat:
    FIND PEDM-2 WHERE PEDM-2.CodMat = PEDM.CodMat EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE PEDM-2 THEN CREATE PEDM-2.
    BUFFER-COPY PEDM TO PEDM-2
        ASSIGN
            PEDM-2.CanPed = PEDM-2.CanPed + PEDM.CanPed
            PEDM-2.ImpIgv = PEDM-2.ImpIgv + PEDM.ImpIgv
            PEDM-2.ImpDto = PEDM-2.ImpDto + PEDM.ImpDto
            PEDM-2.ImpIsc = PEDM-2.ImpIsc + PEDM.ImpIsc
            PEDM-2.ImpLin = PEDM-2.ImpLin + PEDM.ImpLin.
    DELETE PEDM.
  END.
  
  FOR EACH PEDM-2:
    CREATE PEDM.
    BUFFER-COPY PEDM-2 TO PEDM.
    DELETE PEDM-2.
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
  {src/adm/template/snd-list.i "Faccpedm"}

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
     /*L-CREA = NO.*/
     RUN Actualiza-Item.
     
     FacCPedm.TpoCmb:SENSITIVE = NO.
     
     RUN Procesa-Handle IN lh_Handle ('Pagina2').
     RUN Procesa-Handle IN lh_Handle ('browse').
     APPLY 'ENTRY':U TO Faccpedm.NomCli IN FRAME {&FRAME-NAME}.
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
DO WITH FRAME {&FRAME-NAME} :
   /* IF CAMPO:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Campo no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CAMPO.
         RETURN "ADM-ERROR".   
   
      END.
   */

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

IF NOT AVAILABLE FacCPedm THEN RETURN "ADM-ERROR".
IF LOOKUP(FacCPedm.FlgEst,"C,A") > 0 THEN  RETURN "ADM-ERROR".
ASSIGN
    S-CODMON = FacCPedm.CodMon
    S-CODCLI = FacCPedm.CodCli
    /*S-CODIGV = IF FacCPedm.FlgIgv THEN 1 ELSE 2*/
    S-TPOCMB = FacCPedm.TpoCmb
    /*X-NRODEC = IF s-CodDiv = '00013' THEN 4 ELSE 2*/
    /*s-NroTar = FacCPedm.NroCard*/
    S-CNDVTA = FacCPedm.FmaPgo.
    
IF FacCPedm.fchven < TODAY THEN DO:
    FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
                  AND  Almacen.CodAlm = S-CODALM 
                 NO-LOCK NO-ERROR.
    RUN ALM/D-CLAVE (Almacen.Clave,OUTPUT RPTA).
    IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

