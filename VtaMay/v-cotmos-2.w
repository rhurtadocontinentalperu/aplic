&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE ITEM NO-UNDO LIKE Facdpedm.



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
DEFINE SHARED VARIABLE S-CODDOC-2 AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-TERMINAL AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODVEN   AS CHAR.
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
DEFINE VARIABLE S-NROCOT       AS CHARACTER NO-UNDO.
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
DEFINE BUFFER B-CPedm FOR FacCPedm.
DEFINE BUFFER B-DPedm FOR FacDPedm.

DEFINE stream entra .

/*DEFINE VAR x-ClientesVarios AS CHAR INIT '11111111,11111112'.*/
DEFINE VAR x-ClientesVarios AS CHAR INIT '11111111111'.     /* 06.02.08 */

/* RHC 23.12.04 Variable para controlar cuando 
                un pedido se ha generado a partir de una copia */
DEFINE VAR s-copia-registro AS LOGICAL INIT FALSE NO-UNDO.
DEFINE VAR s-documento-registro AS CHAR INIT '' NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES FacCPedm
&Scoped-define FIRST-EXTERNAL-TABLE FacCPedm


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR FacCPedm.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Faccpedm.CodCli Faccpedm.NomCli ~
Faccpedm.TpoCmb Faccpedm.RucCli Faccpedm.fchven Faccpedm.NroCard ~
Faccpedm.ordcmp Faccpedm.DirCli Faccpedm.Cmpbnte Faccpedm.CodVen ~
Faccpedm.CodMon Faccpedm.FmaPgo Faccpedm.Glosa 
&Scoped-define ENABLED-TABLES Faccpedm
&Scoped-define FIRST-ENABLED-TABLE Faccpedm
&Scoped-Define ENABLED-OBJECTS RECT-21 
&Scoped-Define DISPLAYED-FIELDS Faccpedm.CodCli Faccpedm.NroPed ~
Faccpedm.FchPed Faccpedm.NomCli Faccpedm.TpoCmb Faccpedm.RucCli ~
Faccpedm.fchven Faccpedm.NroCard Faccpedm.ordcmp Faccpedm.DirCli ~
Faccpedm.Cmpbnte Faccpedm.CodVen Faccpedm.CodMon Faccpedm.FmaPgo ~
Faccpedm.Glosa 
&Scoped-define DISPLAYED-TABLES Faccpedm
&Scoped-define FIRST-DISPLAYED-TABLE Faccpedm
&Scoped-Define DISPLAYED-OBJECTS F-Estado F-Nomtar F-nOMvEN F-CndVta 

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
     SIZE 28 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE F-Nomtar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81 NO-UNDO.

DEFINE VARIABLE F-nOMvEN AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 100 BY 6.73.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Faccpedm.CodCli AT ROW 1.96 COL 9 COLON-ALIGNED HELP
          ""
          LABEL "Cliente" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Faccpedm.NroPed AT ROW 1.19 COL 9 COLON-ALIGNED
          LABEL "Numero" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .81
          BGCOLOR 15 FGCOLOR 1 FONT 0
     F-Estado AT ROW 1.19 COL 52 COLON-ALIGNED NO-LABEL
     Faccpedm.FchPed AT ROW 1.19 COL 84 COLON-ALIGNED
          LABEL "Fecha"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Faccpedm.NomCli AT ROW 1.96 COL 22 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 48 BY .81
     Faccpedm.TpoCmb AT ROW 1.96 COL 84 COLON-ALIGNED
          LABEL "T/  Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Faccpedm.RucCli AT ROW 2.73 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Faccpedm.fchven AT ROW 2.73 COL 84 COLON-ALIGNED
          LABEL "Vencimiento" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Faccpedm.NroCard AT ROW 3.5 COL 9 COLON-ALIGNED
          LABEL "Nro.Tarjeta"
          VIEW-AS FILL-IN 
          SIZE 11.57 BY .81
     F-Nomtar AT ROW 3.5 COL 22 COLON-ALIGNED NO-LABEL
     Faccpedm.ordcmp AT ROW 3.5 COL 84 COLON-ALIGNED
          LABEL "Cotizacion"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Faccpedm.DirCli AT ROW 4.27 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 61 BY .81
     Faccpedm.Cmpbnte AT ROW 4.27 COL 84 COLON-ALIGNED
          LABEL "Comprobante"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "FAC","BOL" 
          DROP-DOWN-LIST
          SIZE 8 BY 1
     Faccpedm.CodVen AT ROW 5.04 COL 9 COLON-ALIGNED FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
     F-nOMvEN AT ROW 5.04 COL 15 COLON-ALIGNED NO-LABEL
     Faccpedm.CodMon AT ROW 5.23 COL 86 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.57 BY .81
     Faccpedm.FmaPgo AT ROW 5.81 COL 9 COLON-ALIGNED
          LABEL "Cond.Vta" FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
     F-CndVta AT ROW 5.81 COL 15 COLON-ALIGNED NO-LABEL
     Faccpedm.Glosa AT ROW 6.58 COL 6.28
          VIEW-AS FILL-IN 
          SIZE 61 BY .81
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 5.23 COL 79
     RECT-21 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.FacCPedm
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: ITEM T "SHARED" NO-UNDO INTEGRAL Facdpedm
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
         HEIGHT             = 6.96
         WIDTH              = 100.72.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR COMBO-BOX Faccpedm.Cmpbnte IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Faccpedm.CodCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR FILL-IN Faccpedm.CodVen IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Nomtar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-nOMvEN IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Faccpedm.FchPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN Faccpedm.fchven IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Faccpedm.FmaPgo IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Faccpedm.Glosa IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN Faccpedm.NroCard IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Faccpedm.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN Faccpedm.ordcmp IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Faccpedm.TpoCmb IN FRAME F-Main
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

&Scoped-define SELF-NAME Faccpedm.Cmpbnte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Faccpedm.Cmpbnte V-table-Win
ON VALUE-CHANGED OF Faccpedm.Cmpbnte IN FRAME F-Main /* Comprobante */
DO:
  IF SELF:SCREEN-VALUE = "FAC"
  THEN DO:
    ASSIGN
        Faccpedm.DirCli:SENSITIVE = NO
        Faccpedm.NomCli:SENSITIVE = NO.
    APPLY "ENTRY":U TO FAccpedm.codcli.
  END.
  ELSE DO:
    ASSIGN
        Faccpedm.DirCli:SENSITIVE = YES 
        Faccpedm.NomCli:SENSITIVE = YES
        Faccpedm.RucCli:SCREEN-VALUE = ''.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Faccpedm.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Faccpedm.CodCli V-table-Win
ON LEAVE OF Faccpedm.CodCli IN FRAME F-Main /* Cliente */
DO:
  IF Faccpedm.CodCli:SCREEN-VALUE = "" THEN RETURN.
  IF LENGTH(SELF:SCREEN-VALUE) < 11 THEN DO:
      MESSAGE "Codigo tiene menos de 11 dígitos" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
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
  /* RHC Convenio 17.04.07 NO instituciones publicas */
  IF Gn-Clie.Canal = '00001'
  THEN DO:
    MESSAGE 'El cliente pertenece a una institucion PUBLICA' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO FacCPedm.CodCli.
    RETURN NO-APPLY.
  END.
  /* *********************************************** */
 
  DO WITH FRAME {&FRAME-NAME}:
    IF SELF:SCREEN-VALUE <> x-ClientesVarios
    THEN DISPLAY 
            gn-clie.CodCli  @ Faccpedm.CodCli
            gn-clie.ruc     @ Faccpedm.Ruccli
            gn-clie.NroCard @ Faccpedm.NroCard
            gn-clie.NomCli  @ Faccpedm.NomCli
            gn-clie.DirCli  @ Faccpedm.DirCli.
    
    ASSIGN
        S-CODMON = INTEGER(Faccpedm.CodMon:SCREEN-VALUE)
        S-CNDVTA = gn-clie.CndVta
        S-CODCLI = gn-clie.CodCli
        F-NomVen = "".
    IF LOOKUP(TRIM(FacCPedm.CodCli:SCREEN-VALUE), x-ClientesVarios) > 0
    THEN ASSIGN
            Faccpedm.NroCard:SCREEN-VALUE = ''
            Faccpedm.NroCard:SENSITIVE = NO.
    ELSE Faccpedm.NroCard:SENSITIVE = YES.
  END.
  /*RUN Procesa-Handle IN lh_Handle ('browse').*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Faccpedm.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Faccpedm.CodMon V-table-Win
ON VALUE-CHANGED OF Faccpedm.CodMon IN FRAME F-Main /* Cod!mon */
DO:
  S-CODMON = INTEGER(FacCPedm.CodMon:SCREEN-VALUE).
  RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Faccpedm.CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Faccpedm.CodVen V-table-Win
ON LEAVE OF Faccpedm.CodVen IN FRAME F-Main /* Vendedor */
DO:
  F-NomVen:SCREEN-VALUE = "".
  FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
    AND  gn-ven.CodVen = FacCPedm.CodVen:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE gn-ven THEN F-NomVen:SCREEN-VALUE = gn-ven.NomVen.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Faccpedm.fchven
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Faccpedm.fchven V-table-Win
ON LEAVE OF Faccpedm.fchven IN FRAME F-Main /* Vencimiento */
DO:

      FIND TcmbCot WHERE  TcmbCot.Codcia = 0
                    AND  (TcmbCot.Rango1 <=  DATE(FacCPedm.FchVen:SCREEN-VALUE) - DATE(FacCPedm.FchPed:SCREEN-VALUE) + 1
                    AND   TcmbCot.Rango2 >= DATE(FacCPedm.FchVen:SCREEN-VALUE) - DATE(FacCPedm.FchPed:SCREEN-VALUE) + 1 )
                   NO-LOCK NO-ERROR.
      IF AVAIL TcmbCot THEN DO:
      
          DISPLAY TcmbCot.TpoCmb @ FacCPedm.TpoCmb
                  WITH FRAME {&FRAME-NAME}.
          S-TPOCMB = TcmbCot.TpoCmb.  
      END.
   
      RUN Procesa-Handle IN lh_Handle ('Recalculo').
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Faccpedm.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Faccpedm.FmaPgo V-table-Win
ON LEAVE OF Faccpedm.FmaPgo IN FRAME F-Main /* Cond.Vta */
DO:
  F-CndVta:SCREEN-VALUE = ''.
  s-CndVta = SELF:SCREEN-VALUE.
  FIND gn-convt WHERE gn-convt.Codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
  RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Faccpedm.NomCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Faccpedm.NomCli V-table-Win
ON LEAVE OF Faccpedm.NomCli IN FRAME F-Main /* Nombre */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Faccpedm.NroCard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Faccpedm.NroCard V-table-Win
ON LEAVE OF Faccpedm.NroCard IN FRAME F-Main /* Nro.Tarjeta */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  ASSIGN
    SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999") NO-ERROR.
  FIND Gn-Card WHERE Gn-Card.NroCard = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Gn-Card THEN DO:
     S-NROTAR = SELF:SCREEN-VALUE.
     RUN vta/D-RegCar (INPUT S-NROTAR).
     IF S-NROTAR = "" THEN DO:
         APPLY "ENTRY" TO FacCPedm.NroCard.
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


&Scoped-define SELF-NAME Faccpedm.TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Faccpedm.TpoCmb V-table-Win
ON LEAVE OF Faccpedm.TpoCmb IN FRAME F-Main /* T/  Cambio */
DO:
    S-TPOCMB = DEC(FacCPedm.TpoCmb:SCREEN-VALUE).
    
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

  FOR EACH FacDPedm OF FacCPedm NO-LOCK ON ERROR UNDO, RETURN 'ADM-ERROR':
      FIND B-DPedm WHERE B-DPedm.CodCia = FacCPedm.CodCia 
                    AND  B-DPedm.CodDoc = "COT" 
                    AND  B-DPedm.NroPed = FacCPedm.OrdCmp
                    AND  B-DPedm.CodMat = FacDPedm.CodMat 
                   EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE B-DPedm THEN B-DPedm.CanAte = B-DPedm.CanAte + FacDPedm.CanPed.
      RELEASE B-DPedm.
  END.
  FOR EACH FacDPedm NO-LOCK WHERE FacDPedm.CodCia = S-CODCIA 
                             AND  FacDPedm.CodDoc = "COT" 
                             AND  FacDPedm.NroPed = FacCPedm.OrdCmp:     
      IF (FacDPedm.CanPed - FacDPedm.CanAte) > 0 
      THEN DO:
         I-NRO = 1.
         LEAVE.
      END.
  END.
  /* RHC 22-03-2003 */
  FIND B-CPedm WHERE B-CPedm.CodCia = FacCPedm.CodCia
        AND  B-CPedm.CodDiv = FacCPedm.CodDiv
        AND  B-CPedm.CodDoc = "COT" 
        AND  B-CPedm.NroPed = FacCPedm.OrdCmp
        EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE B-CPedm THEN UNDO, RETURN 'ADM-ERROR'.
  IF I-NRO = 0 
  THEN ASSIGN B-CPedm.FlgEst = "C".
  ELSE ASSIGN B-CPedm.FlgEst = "P".
  RELEASE B-CPedm.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Datos-Cliente V-table-Win 
PROCEDURE Actualiza-Datos-Cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF AVAILABLE gn-clie AND s-codcli <> '' THEN RUN vtamay/gVtaCli (ROWID(gn-clie)).
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
  FOR EACH ITEM:
    DELETE ITEM.
  END.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN DO:
    FOR EACH facdPedm OF FacCPedm NO-LOCK:
        CREATE ITEM.
        BUFFER-COPY FacDPedm TO ITEM.
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
  {src/adm/template/row-list.i "FacCPedm"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "FacCPedm"}

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
  DEFINE VARIABLE X-CANPED AS DECIMAL NO-UNDO.
  DEFINE VARIABLE S-STKDIS AS DECIMAL NO-UNDO.
  DEFINE VARIABLE S-OK     AS LOGICAL NO-UNDO.
  DEFINE VARIABLE F-FACTOR AS DECIMAL NO-UNDO.
  DEFINE BUFFER B-CPEDM FOR Faccpedm.
  DEFINE VAR F-PREBAS AS DECIMAL NO-UNDO.
  DEFINE VAR F-PREVTA AS DECIMAL NO-UNDO.
  DEFINE VAR F-DSCTOS AS DECIMAL NO-UNDO.
  DEFINE VAR Y-DSCTOS AS DECIMAL NO-UNDO.
  DEFINE VAR SW-LOG1 AS LOGICAL NO-UNDO.  
  DEFINE FRAME F-Mensaje
    'Procesando: ' FacDPedm.codmat SKIP(1)
    'Espere un momento por favor ...' SKIP
    WITH CENTERED NO-LABELS OVERLAY VIEW-AS DIALOG-BOX TITLE 'TRASLADANDO COTIZACION'.
    

  DO WITH FRAME {&FRAME-NAME}:  
    IF NOT FacCPedm.CodCli:SENSITIVE THEN RETURN "ADM-ERROR".
    S-NroCot = "".
    input-var-1 = "COT".
    input-var-2 = FacCPedm.CodCli:SCREEN-VALUE.
    RUN lkup/C-Cotizam1 ("Cotizaciones Pendientes").
    IF output-var-1 = ? THEN RETURN "ADM-ERROR".
    RUN Actualiza-Item.
    S-NroCot = output-var-2.
    FIND B-CPedm WHERE ROWID(B-CPedm) = output-var-1 NO-LOCK NO-ERROR.

    F-NomVen = "".
    FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
        AND  gn-ven.CodVen = B-CPedm.CodVen 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
    
    F-CndVta:SCREEN-VALUE = "".
    S-CNDVTA = B-CPedm.FmaPgo.
    FIND gn-convt WHERE gn-convt.Codig = B-CPedm.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN F-CndVta = gn-convt.Nombr.
    
    DISPLAY 
        B-CPedm.CodCli @ FaccPedm.CodCli
        B-CPedm.NomCli @ FaccPedm.NomCli
        B-CPedm.RucCli @ FaccPedm.RucCli
        B-CPedm.DirCli @ FaccPedm.Dircli
        B-CPedm.CodVen @ FaccPedm.CodVen
        B-CPedm.Glosa  @ FaccPedm.Glosa
        B-CPedm.FmaPgo @ FaccPedm.FmaPgo
        s-NroCot @ FaccPedm.OrdCmp
        F-CndVta           
        F-NomVen. 
    ASSIGN
        FaccPedm.Cmpbnte:SCREEN-VALUE = B-CPedm.Cmpbnte        
        FaccPedm.CodMon:SCREEN-VALUE = STRING(B-CPedm.CodMon).

    /* DETALLES */
    FOR EACH FacDPedm OF B-CPedm NO-LOCK WHERE (FacDPedm.CanPed - FacDPedm.CanAte) > 0:
        DISPLAY Facdpedm.codmat WITH FRAME F-Mensaje.
        F-CANPED = (FacDPedm.CanPed - FacDPedm.CanAte).
        RUN vta/stkdispo (s-codcia, s-codalm, FacdPedm.codmat, FacdPedm.Factor * F-CANPED ,
                          OUTPUT S-OK, OUTPUT S-STKDIS).
        IF NOT S-OK THEN F-CANPED = ((S-STKDIS - (S-STKDIS MODULO FacDPedm.Factor)) / FacDPedm.Factor).
        IF F-CANPED > 0 THEN DO:
            CREATE ITEM.
            BUFFER-COPY FacDPedm TO ITEM
                ASSIGN ITEM.CanPed = F-CANPED
                        ITEM.PorDto = ABSOLUTE(FacDPedm.PorDto).
            /* SE DEBE MANTENER EL PRECIO DE LA COTIZACION */                
            ASSIGN 
              ITEM.ImpDto = ROUND( ITEM.PreBas * (ITEM.PorDto / 100) * ITEM.CanPed , 2 )
              ITEM.ImpLin = ROUND( ITEM.PreUni * ITEM.CanPed , 2 ).
            IF ITEM.AftIsc 
            THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
            IF ITEM.AftIgv 
            THEN  ITEM.ImpIgv = ITEM.ImpLin - ROUND(ITEM.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).

/*            IF ITEM.CanPed <> FacdPedm.CanPed THEN DO:
 *                 MESSAGE "El Precio del Articulo  " ITEM.Codmat  SKIP
 *                        "Sera recalculado........."
 *                        VIEW-AS ALERT-BOX WARNING.
 *                 ASSIGN
 *                     f-Factor = FacDPedm.Factor
 *                     x-CanPed = FacDPedm.CanPed.
 *                 RUN vta/PrecioConta (s-CodCia,
 *                                     s-CodDiv,
 *                                     s-CodCli,
 *                                     s-CodMon,
 *                                     s-TpoCmb,
 *                                     f-Factor,
 *                                     FacDPedm.CodMat,
 *                                     s-CndVta,
 *                                     x-CanPed,
 *                                     4,
 *                                     OUTPUT f-PreBas,
 *                                     OUTPUT f-PreVta,
 *                                     OUTPUT f-Dsctos,
 *                                     OUTPUT y-Dsctos,
 *                                     OUTPUT SW-LOG1).
 *                ASSIGN  
 *                     ITEM.Flg_factor = IF SW-LOG1 THEN "1" ELSE "0"                     
 *                     ITEM.PreUni = F-PREVTA
 *                     ITEM.PreBas = F-PREBAS
 *                     ITEM.PorDto = F-DSCTOS
 *                     ITEM.Por_Dsctos[3] = Y-DSCTOS 
 *                     ITEM.ImpDto = ROUND( ITEM.PreUni * (ITEM.Por_Dsctos[1] / 100) * (IF SW-LOG1 THEN ITEM.CanPed ELSE (ITEM.CanPed * F-FACTOR)), 2 ).
 *                     ITEM.ImpLin = ROUND( ITEM.PreUni * (IF SW-LOG1 THEN ITEM.CanPed ELSE (ITEM.CanPed * F-FACTOR)) , 2 ) - ITEM.ImpDto.      
 *                     IF ITEM.AftIsc THEN
 *                        ITEM.ImpIsc = ROUND(ITEM.PreBas * (IF SW-LOG1 THEN ITEM.CanPed ELSE (ITEM.CanPed * F-FACTOR)) * (Almmmatg.PorIsc / 100),4).
 *                     IF ITEM.AftIgv THEN
 *                        ITEM.ImpIgv = ITEM.ImpLin - ROUND(ITEM.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
 *             END.              */
        END.
    END.
    HIDE FRAME F-Mensaje.
    FacCPedm.CodCli:SENSITIVE = NO.
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
  DEF INPUT PARAMETER p-Ok AS LOG.
  
  FOR EACH FacDPedm OF FacCPedm ON ERROR UNDO, RETURN 'ADM-ERROR':
    /* BORRAMOS SALDO EN LAS COTIZACIONES */
    FIND B-DPedm WHERE B-DPedm.CodCia = FacCPedm.CodCia 
        AND  B-DPedm.CodDoc = "COT" 
        AND  B-DPedm.NroPed = FacCPedm.OrdCmp
        AND  B-DPedm.CodMat = FacDPedm.CodMat 
        EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE B-DPedm 
    THEN B-DPedm.CanAte = B-DPedm.CanAte - FacDPedm.CanPed.
    RELEASE B-DPedm.
    IF p-Ok = YES
    THEN DELETE FacDPedm.
    ELSE FacDPedm.FlgEst = 'A'.
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

RUN bin/_numero(faccpedm.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF faccpedm.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").
X-desmon = (IF faccpedm.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

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

chWorkSheet:Range("A2"):Value = "Pedido No : " + FacCPedm.NroPed.
chWorkSheet:Range("A3"):Value = "Fecha     : " + STRING(FacCPedm.FchPed,"99/99/9999").
chWorkSheet:Range("A4"):Value = "Cliente   : " + FacCPedm.Codcli + " " + FacCPedm.Nomcli.
chWorkSheet:Range("A5"):Value = "Vendedor  : " + FacCPedm.CodVen + " " + F-Nomven:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
chWorkSheet:Range("A6"):Value = "Moneda    : " + x-desmon.

FOR EACH FacDPedm OF FacCPedm :
    x-item  = x-item + 1.
    FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                        Almmmatg.CodMat = FacDPedm.CodMat
                        NO-LOCK NO-ERROR.
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = x-item.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = facdpedm.codmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = facdpedm.undvta.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = facdpedm.preuni.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = facdpedm.canped.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = facdpedm.implin.

END.

iColumn = iColumn + 2.                           
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "SON : " + x-enletras.

iColumn = iColumn + 2.                           
cColumn = STRING(iColumn).
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = faccpedm.imptot.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Excel2 V-table-Win 
PROCEDURE Genera-Excel2 :
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE F-PreUni                LIKE FacDPedi.Preuni.
DEFINE VARIABLE F-ImpLin                LIKE FacDPedi.ImpLin.
DEFINE VARIABLE F-ImpTot                LIKE FacCPedm.ImpTot.

DEFINE VARIABLE C-NomVen  AS CHAR FORMAT "X(30)".
DEFINE VARIABLE C-Descli  AS CHAR FORMAT "X(60)".
DEFINE VARIABLE C-Moneda  AS CHAR FORMAT "X(7)".
DEFINE VARIABLE C-SimMon  AS CHAR FORMAT "X(7)".
DEFINE VARIABLE C-NomCon  AS CHAR FORMAT "X(30)".
DEFINE VARIABLE W-DIRALM  AS CHAR FORMAT "X(50)".
DEFINE VARIABLE X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.
DEFINE VARIABLE C-OBS AS CHAR EXTENT 2 NO-UNDO.
DEFINE VARIABLE K AS INTEGER NO-UNDO.
DEFINE VARIABLE P AS INTEGER NO-UNDO.
DEFINE VARIABLE x-desmon                AS CHARACTER.

RUN bin/_numero(faccpedm.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF faccpedm.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").
X-desmon = (IF faccpedm.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

IF FacCPedm.FlgIgv THEN DO:
   F-ImpTot = FacCPedm.ImpTot.
END.
ELSE DO:
   F-ImpTot = FacCPedm.ImpVta.
END.  

/* ************************ cargamos variables ********************* */
FIND gn-ven WHERE 
     gn-ven.CodCia = FacCPedm.CodCia AND  
     gn-ven.CodVen = FacCPedm.CodVen 
     NO-LOCK NO-ERROR.
C-NomVen = FacCPedm.CodVen.
IF AVAILABLE gn-ven THEN C-NomVen = C-NomVen + " - " + gn-ven.NomVen.
FIND gn-clie WHERE 
     gn-clie.codcia = cl-codcia AND  
     gn-clie.codcli = FacCPedm.codcli NO-LOCK NO-ERROR.
     
C-DESCLI  = Gn-clie.codcli + ' - ' + Gn-clie.Nomcli     .
C-DESCLI  = FacCPedm.codcli + ' - ' + FacCPedm.Nomcli     .

FIND gn-ConVt WHERE gn-ConVt.Codig = FacCPedm.FmaPgo NO-LOCK NO-ERROR.
C-NomCon = FacCPedm.FmaPgo.
IF AVAILABLE gn-ConVt THEN C-NomCon = gn-ConVt.Nombr.
IF FacCPedm.Codmon = 2 THEN DO: 
    C-Moneda = "DOLARES US$.".
    c-SimMon = "US$".
END.
ELSE DO: 
    C-Moneda = "SOLES   S/. ".
    c-SimMon = "S/.".
END.

/* ******************************************************************** */

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
/*chWorkbook = chExcelApplication:Workbooks:Add("C:\PRG\Templates\q fue\Cotizacion.xlt").*/
DEF var x-Plantilla AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION 'Plantillas' KEY 'Carpeta' VALUE x-Plantilla .
x-Plantilla = x-Plantilla + "CotizacionTienda.xlt".

chWorkbook = chExcelApplication:Workbooks:Add(x-Plantilla).

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 4.
chWorkSheet:Columns("B"):ColumnWidth = 7.
chWorkSheet:Columns("C"):ColumnWidth = 10.
chWorkSheet:Columns("D"):ColumnWidth = 10.
chWorkSheet:Columns("E"):ColumnWidth = 40.
chWorkSheet:Columns("F"):ColumnWidth = 25.
chWorkSheet:Columns("G"):ColumnWidth = 10.
chWorkSheet:Columns("H"):ColumnWidth = 20.

/*Datos Cliente*/
t-Column = 9.
cColumn = STRING(t-Column).
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "COTIZACION Nº " + FacCPedm.NroPed. 
t-Column = t-Column + 2.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Señor(es) :" + c-descli. 

t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Direccion :" + gn-clie.dircli. 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Emision         : " + STRING(FacCPedm.fchped, '99/99/9999').

t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Referencia      : " .
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Vencimiento     : " + STRING(FacCPedm.fchven, '99/99/9999') . 

t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "VENDEDOR  : " + c-nomven . 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Forma de pago   : " + c-nomcon.

t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "ATT.". 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Moneda          : " + c-moneda. 


t-Column = t-Column + 4.
cColumn = STRING(t-Column).
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value =  "(" + c-simmon + ")". 
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value =  "(" + c-simmon + ")". 

/*
chWorkSheet:Range("G20"):Value = "(" + c-simmon + ")". 
chWorkSheet:Range("H20"):Value = "(" + c-simmon + ")". 
*/

t-Column = t-Column + 2.
P = t-Column.

FOR EACH FacDPedm OF FacCPedm 
    BREAK BY Facdpedm.NroPed
        BY Facdpedm.NroItm DESC:
    x-item  = x-item + 1.
    FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                        Almmmatg.CodMat = FacDPedm.CodMat
                        NO-LOCK NO-ERROR.
    /*iColumn = iColumn + 1.*/
    /*Agrega Row*/
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):EntireRow:INSERT.
    
    p = p + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = Facdpedm.NroItm.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + facdpedm.codmat.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = facdpedm.canped.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = facdpedm.undvta.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = facdpedm.preuni.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = facdpedm.implin.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.

END.

t-column = p + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "TOTAL " + c-simmon.
chWorkSheet:Range(cRange):FONT:Bold = TRUE.
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = f-ImpTot.
chWorkSheet:Range(cRange):FONT:Bold = TRUE.

t-column = t-column + 3.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
IF FacCPedm.flgigv THEN chWorkSheet:Range(cRange):Value = "* LOS PRECIOS INCLUYEN IGV.".
ELSE chWorkSheet:Range(cRange):Value = "* LOS PRECIOS NO INCLUYEN IGV.".


/*RD01-Condicion Venta*/
FIND FIRST gn-convt WHERE gn-convt.codig =  FacCPedm.fmapgo NO-LOCK NO-ERROR.
IF AVAIL gn-convt THEN DO:
    t-column = t-column + 2.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "* FORMA DE PAGO: " +  gn-convt.Nombr.
END.


/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

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
  
  FOR EACH ITEM NO-LOCK BY ITEM.NroItm: 
    I-NITEM = I-NITEM + 1.
    CREATE FacDPedm.
    BUFFER-COPY ITEM TO FacDPedm
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
  FOR EACH ITEM NO-LOCK: 
    /*FacCPedm.ImpDto = FacCPedm.ImpDto + ITEM.ImpDto.*/
    F-Igv = F-Igv + ITEM.ImpIgv.
    F-Isc = F-Isc + ITEM.ImpIsc.
    FacCPedm.ImpTot = FacCPedm.ImpTot + ITEM.ImpLin.
    IF NOT ITEM.AftIgv THEN FacCPedm.ImpExo = FacCPedm.ImpExo + ITEM.ImpLin.
    IF ITEM.AftIgv = YES
    THEN FacCPedm.ImpDto = FacCPedm.ImpDto + ROUND(ITEM.ImpDto / (1 + FacCPedm.PorIgv / 100), 2).
    ELSE FacCPedm.ImpDto = FacCPedm.ImpDto + ITEM.ImpDto.
  END.
/*  ASSIGN
 *     FacCPedm.ImpIgv = ROUND(F-IGV,2)
 *     FacCPedm.ImpIsc = ROUND(F-ISC,2)
 *     FacCPedm.ImpBrt = FacCPedm.ImpTot - FacCPedm.ImpIgv - FacCPedm.ImpIsc + 
 *                         FacCPedm.ImpDto - FacCPedm.ImpExo
 *     FacCPedm.ImpVta = FacCPedm.ImpBrt - FacCPedm.ImpDto
 *     FacCPedm.ImpTot = ROUND(FacCPedm.ImpTot * (1 - FacCPedm.PorDto / 100),2)
 *     FacCPedm.ImpVta = ROUND(FacCPedm.ImpTot / (1 + FacCPedm.PorIgv / 100),2)
 *     FacCPedm.ImpIgv = FacCPedm.ImpTot - FacCPedm.ImpVta
 *     FacCPedm.ImpBrt = FacCPedm.ImpTot - FacCPedm.ImpIgv - FacCPedm.ImpIsc + 
 *                         FacCPedm.ImpDto - FacCPedm.ImpExo.*/
  FacCPedm.ImpIgv = ROUND(F-IGV,2).
  FacCPedm.ImpIsc = ROUND(F-ISC,2).
  FacCPedm.ImpVta = FacCPedm.ImpTot - FacCPedm.ImpExo - FacCPedm.ImpIgv.
  IF FacCPedm.PorDto > 0 THEN DO:
    ASSIGN
        FacCPedm.ImpDto = FacCPedm.ImpDto + ROUND((FacCPedm.ImpVta + FacCPedm.ImpExo) * FacCPedm.PorDto / 100, 2)
        FacCPedm.ImpTot = ROUND(FacCPedm.ImpTot * (1 - FacCPedm.PorDto / 100),2)
        FacCPedm.ImpVta = ROUND(FacCPedm.ImpVta * (1 - FacCPedm.PorDto / 100),2)
        FacCPedm.ImpExo = ROUND(FacCPedm.ImpExo * (1 - FacCPedm.PorDto / 100),2)
        FacCPedm.ImpIgv = FacCPedm.ImpTot - FacCPedm.ImpExo - FacCPedm.ImpVta.
  END.
  FacCPedm.ImpBrt = FacCPedm.ImpVta + FacCPedm.ImpIsc + FacCPedm.ImpDto + FacCPedm.ImpExo.
  
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
                  AND  (TcmbCot.Rango1 <=  DATE(FacCPedm.FchPed:SCREEN-VALUE IN FRAME {&FRAME-NAME}) - DATE(FacCPedm.FchVen:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + 1
                  AND   TcmbCot.Rango2 >= DATE(FacCPedm.FchPed:SCREEN-VALUE IN FRAME {&FRAME-NAME}) - DATE(FacCPedm.FchVen:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + 1 )
                 NO-LOCK NO-ERROR.
    IF AVAIL TcmbCot THEN DO:
        DISPLAY TcmbCot.TpoCmb @ FacCPedm.TpoCmb
                WITH FRAME {&FRAME-NAME}.
        S-TPOCMB = TcmbCot.TpoCmb.  
    END.

    
    f-totdias = DATE(FacCPedm.FchPed:SCREEN-VALUE IN FRAME {&FRAME-NAME}) - DATE(FacCPedm.FchVen:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + 1.
    S-CODCLI = trim(entry(1,lin,'|')).
    S-CNDVTA = trim(entry(3,lin,'|')).
    S-CODVEN = trim(entry(2,lin,'|')).

    DO WITH FRAME {&FRAME-NAME}:
        DISPLAY  S-CODCLI @ FacCPedm.Codcli
                 Gn-Clie.NomCli @ FacCPedm.Nomcli
                 Gn-Clie.Ruc    @ FacCPedm.Ruc
                 S-CODVEN @ FacCPedm.CodVen
                 Gn-ven.NomVen @ F-Nomven
                 S-CNDVTA @ FacCPedm.FmaPgo
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

  IF FacCPedm.FlgEst <> "A" THEN DO:
/*      RUN VTA/d-file.r (OUTPUT o-file).*/

      RUN VTA\R-ImpTxt.r(ROWID(FacCPedm), 
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
  ASSIGN
    s-Copia-Registro = NO
    s-Documento-Registro = ''.

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
        s-TpoCmb = FacCfgGn.TpoCmb[1] 
        S-NroTar = "".
    DISPLAY 
        TODAY @ FacCPedm.FchPed
        S-TPOCMB @ FacCPedm.TpoCmb
        TODAY @ FacCPedm.FchVen
        /*FacCfgGn.CliVar @ Faccpedm.CodCli*/
        x-ClientesVarios @ Faccpedm.codcli
        '000' @ Faccpedm.fmapgo.
    ASSIGN
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
        THEN Faccpedm.Cmpbnte:SCREEN-VALUE = "BOL".
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
        FacCPedm.Usuario = S-USER-ID
        Faccpedm.FlgEst = "P".

    RUN Genera-Pedido.    /* Detalle del pedido */ 
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    RUN Graba-Totales.

    /* ACTIVACION DEL CLIENTE */
    FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
        AND  gn-clie.CodCli = Faccpedm.CodCli
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

  DO WITH FRAME {&FRAME-NAME}:
     FacCPedm.NomCli:SENSITIVE = NO.
     FacCPedm.RucCli:SENSITIVE = NO.
     FacCPedm.DirCli:SENSITIVE = NO.
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
    FacCPedm.CodAlm = S-CODALM
    FacCPedm.PorIgv = FacCfgGn.PorIgv 
    FacCPedm.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
    FacCPedm.CodDiv = S-CODDIV
    /*FacCPedm.FlgEst = 'P'.*/
    FacCPedm.TipVta = '1'.
  /* RHC 23.12.04 Control de pedidos hechos por copia de otro */
  IF s-Copia-Registro = YES
  THEN FacCPedm.CodTrans = s-Documento-Registro.       /* Este campo no se usa */
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
    FIND FIRST facdpedm OF FacCPedm WHERE CanAte > 0 NO-LOCK NO-ERROR.
    IF AVAILABLE FacDPedm THEN DO:
       MESSAGE "No puede eliminar un pedido PARCIALMENTE atendido" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR':
    FIND CURRENT FacCPedm EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCPedm THEN RETURN 'ADM-ERROR'.
    ASSIGN
        FacCPedm.FlgEst = 'A'
        FacCPedm.Glosa  = " A N U L A D O".
    RUN Borra-Pedido (FALSE).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    FIND CURRENT FacCPedm NO-LOCK.
  END.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Procesa-Handle IN lh_Handle ('browse').
      
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
     FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                   AND  gn-clie.CodCli = FacCPedm.CodCli 
                  NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie  THEN DO: 
        DISPLAY FacCPedm.NomCli 
                FacCPedm.RucCli  
                FacCPedm.DirCli.
        CASE FacCPedm.FlgEst:
          WHEN "A" THEN DISPLAY " ANULADO " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "C" THEN DISPLAY "ATENDIDO " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "P" THEN DISPLAY "PENDIENTE" @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "V" THEN DISPLAY " VENCIDO " @ F-Estado WITH FRAME {&FRAME-NAME}.
       END CASE.         
    END.  
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

    F-Nomtar:SCREEN-VALUE = ''.
    FIND Gn-Card WHERE Gn-Card.NroCard = FacCPedm.NroCar NO-LOCK NO-ERROR.
    IF AVAILABLE Gn-Card THEN F-NomTar:SCREEN-VALUE = GN-CARD.NomClie[1].
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
        FacCPedm.RucCli:SENSITIVE = NO
        FacCPedm.NomCli:SENSITIVE = NO
        FacCPedm.DirCli:SENSITIVE = NO
        FacCPedm.fchven:SENSITIVE = NO
        FacCPedm.TpoCmb:SENSITIVE = NO
        FacCPedm.FmaPgo:SENSITIVE = NO
        FacCPedm.OrdCmp:SENSITIVE = NO.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'NO'
    THEN ASSIGN
            FacCPedm.CodCli:SENSITIVE = NO
            FacCPedm.fchven:SENSITIVE = NO
            FacCPedm.FmaPgo:SENSITIVE = NO
            FacCPedm.NroCard:SENSITIVE = NO
            FacCPedm.CodMon:SENSITIVE = NO
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF Faccpedm.FlgEst <> "A" THEN RUN vtamay/r-impvm (ROWID(Faccpedm)).

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
  {src/adm/template/snd-list.i "FacCPedm"}

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
     
     FacCPedm.TpoCmb:SENSITIVE = NO.
     
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
    IF FacCPedm.CodCli:SCREEN-VALUE = "" THEN DO:
       MESSAGE "Codigo de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FacCPedm.CodCli.
       RETURN "ADM-ERROR".   
    END.
    FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
        AND  gn-clie.CodCli = FacCPedm.CodCli:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN DO:
       MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FacCPedm.CodCli.
       RETURN "ADM-ERROR".   
    END.
    IF gn-clie.FlgSit = "I" THEN DO:
       MESSAGE "Cliente esta Inactivo" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    IF gn-clie.FlgSit = "C" THEN DO:
       MESSAGE "Cliente esta Cesado" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    IF LOOKUP(TRIM(FacCPedm.CodCli:SCREEN-VALUE), x-ClientesVarios) = 0
        AND LENGTH(TRIM(FacCPedm.CodCli:SCREEN-VALUE)) <> 11
        THEN DO:
        MESSAGE 'El codigo del cliente debe tener 11 digitos' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FacCPedm.CodCli.
        RETURN 'ADM-ERROR'.
    END.
    /***** Valida Ingreso de Ruc. *****/
    IF FacCpedm.Cmpbnte:screen-value = "FAC" 
            AND FacCpedm.RucCli:SCREEN-VALUE = '' THEN DO:
        MESSAGE "El Cliente NO tiene R.U.C." VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FacCPedm.CodCli.
        RETURN "ADM-ERROR".   
    END.      

    IF FacCPedm.CodVen:SCREEN-VALUE = "" THEN DO:
       MESSAGE "Codigo de Vendedor no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FacCPedm.CodVen.
       RETURN "ADM-ERROR".   
    END.
    FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
                 AND  gn-ven.CodVen = FacCPedm.CodVen:screen-value 
                NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-ven THEN DO:
       MESSAGE "Codigo de Vendedor no existe" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FacCPedm.CodVen.
       RETURN "ADM-ERROR".   
    END.
    ELSE DO:
        IF gn-ven.flgest = "C" THEN DO:
            MESSAGE "Codigo de Vendedor Cesado" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FacCPedm.CodVen.
            RETURN "ADM-ERROR".   
        END.
    END.
    
    FIND gn-convt WHERE gn-convt.Codig = FacCPedm.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-convt THEN DO:
       MESSAGE "Condicion Venta no existe" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FacCPedm.FmaPgo.
       RETURN "ADM-ERROR".   
    END.
 
    IF FacCPedm.NroCar:SCREEN-VALUE <> "" THEN DO:
      FIND Gn-Card WHERE Gn-Card.NroCard = FacCPedm.NroCar:SCREEN-VALUE
                            NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Gn-Card THEN DO:
          MESSAGE "Numero de Tarjeta Incorrecto, Verifique... " VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO FacCPedm.NroCar.
          RETURN "ADM-ERROR".   
      END.   
    END.           
 
    FOR EACH ITEM NO-LOCK BREAK BY ALMDES:
        IF FIRST-OF(ALMDES) THEN DO:
           X-FREC = X-FREC + 1.
        END.        
        F-Tot = F-Tot + ITEM.ImpLin.
    END.
    IF F-Tot = 0 THEN DO:
       MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FacCPedm.CodCli.
       RETURN "ADM-ERROR".   
    END.
    IF X-FREC > 1 THEN DO:
       MESSAGE "No puede despachar de varios almacenes, modifique su cotizacion" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FacCPedm.CodCli.
       RETURN "ADM-ERROR".   
    END.

/*    DEFINE VAR X-TOT AS DECI INIT 0.
 *     X-TOT = IF S-CODMON = 1 THEN F-TOT ELSE F-TOT * DECI(FaccPedm.Tpocmb:SCREEN-VALUE).
 *     IF F-Tot >= 1600 THEN DO:
 *        IF Faccpedm.Cmpbnte:SCREEN-VALUE = 'BOL' THEN DO:
 *           MESSAGE "Boleta de Venta Venta Mayor a S/.1,600.00 Ingresar Nro. Ruc., Verifique... " 
 *              VIEW-AS ALERT-BOX ERROR.
 *           APPLY "ENTRY" TO FacCPedm.CodCli.
 *           RETURN "ADM-ERROR".   
 *        END.
 *     END.*/

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
/* Si tiene atenciones parciales tambien se bloquea */
FIND FIRST facdpedm OF FacCPedm WHERE CanAte > 0 NO-LOCK NO-ERROR.
IF AVAILABLE facdpedm 
THEN DO:
    MESSAGE "La Cotización tiene atenciones parciales" VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
ASSIGN
    S-CODMON = FacCPedm.CodMon
    S-CODCLI = FacCPedm.CodCli
    S-CODIGV = IF FacCPedm.FlgIgv THEN 1 ELSE 2
    S-TPOCMB = FacCPedm.TpoCmb
    X-NRODEC = IF s-CodDiv = '00013' THEN 4 ELSE 2
    s-NroTar = FacCPedm.NroCard
    S-CNDVTA = FacCPedm.FmaPgo.
    
IF FacCPedm.fchven < TODAY THEN DO:
    FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
                  AND  Almacen.CodAlm = S-CODALM 
                 NO-LOCK NO-ERROR.
    RUN ALM/D-CLAVE (Almacen.Clave,OUTPUT RPTA).
    IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
END.
/*F-Nrodec:HIDDEN = NO.*/
/*F-NRODEC:SCREEN-VALUE = STRING(X-NRODEC,"9").*/

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

