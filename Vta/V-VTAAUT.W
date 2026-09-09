&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE T-VVALE LIKE VtaVVale.



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
DEFINE BUFFER B-CPEDM FOR Faccpedm.
DEFINE BUFFER B-CPEDI FOR Faccpedi.
DEFINE SHARED TEMP-TABLE ITEM LIKE FacDPedm.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE CL-CODCIA  AS INTEGER.
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
DEFINE SHARED VARIABLE S-IMPTOT   AS DEC.
DEFINE SHARED VARIABLE s-PorDto  AS DEC.


/* Local Variable Definitions ---                          */
DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-NROPED       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE C-CODVEN       AS CHARACTER NO-UNDO.
DEFINE VARIABLE S-NROCOT       AS CHARACTER NO-UNDO.
DEFINE VARIABLE NRO_PED LIKE Faccpedm.NroPed NO-UNDO.

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
               AND  FacCorre.CodDoc = S-CODDOC 
               AND  FacCorre.CodDiv = S-CODDIV 
               AND  FacCorre.CodAlm = S-CODALM
              NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN I-NroSer = FacCorre.NroSer
          S-PRINTER-NAME = FacCorre.Printer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE BUFFER B-CPEDM1 FOR FacCPedm.

DEFINE VARIABLE F-FACTOR     AS DECIMAL   NO-UNDO.               
DEFINE VARIABLE F-PREVTA LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE BUFFER B-Almtconv FOR Almtconv.
DEFINE VARIABLE X-FACTOR  AS DECIMAL NO-UNDO.
DEFINE VARIABLE X-PREVTA1 LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE X-PREVTA2 LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE X-DSCTOS  LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE Y-DSCTOS  LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE SW-LOG1 AS LOGICAL NO-UNDO.



DEFINE BUFFER B-PedM  FOR FacCPedm.
DEFINE BUFFER B-CDocu FOR CcbCDocu.
DEFINE BUFFER B-DPEDM FOR FacDPedm.

DEFINE SHARED TEMP-TABLE T-CcbDDocu LIKE CcbDDocu.
DEFINE SHARED TEMP-TABLE T-CcbCCaja LIKE CcbCCaja.

DEFINE TEMP-TABLE T-CPEDM LIKE FacCPedm
   FIELD CodRef LIKE CcbCDocu.CodRef
   FIELD NroRef LIKE CcbCDocu.NroRef.

DEFINE TEMP-TABLE T-DPEDM LIKE FacDPedm.

/* Definicion de variables compartidas */

DEFINE VARIABLE L-OK AS LOGICAL.
DEFINE SHARED VARIABLE S-PTOVTA     AS INTEGER.
DEFINE SHARED VARIABLE S-SERCJA     AS INTEGER.
DEFINE SHARED VARIABLE s-tipo       AS CHARACTER.
DEFINE SHARED VARIABLE s-codmov     LIKE Almtmovm.Codmov.
DEFINE SHARED VARIABLE s-codter     LIKE ccbcterm.codter.

DEFINE VAR x-cto1 AS DECI INIT 0.
DEFINE VAR x-cto2 AS DECI INIT 0.

FIND LAST Gn-tccja WHERE Gn-tccja.Fecha <= TODAY
                         NO-LOCK NO-ERROR.

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
&Scoped-define EXTERNAL-TABLES faccpedm
&Scoped-define FIRST-EXTERNAL-TABLE faccpedm


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR faccpedm.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Faccpedm.CodCli Faccpedm.NomCli ~
Faccpedm.DirCli Faccpedm.CodVen Faccpedm.Glosa 
&Scoped-define ENABLED-TABLES Faccpedm
&Scoped-define FIRST-ENABLED-TABLE Faccpedm
&Scoped-Define ENABLED-OBJECTS TOGGLE-Vale RECT-26 
&Scoped-Define DISPLAYED-FIELDS Faccpedm.PorDto Faccpedm.RucCli ~
Faccpedm.NroPed Faccpedm.NroCard Faccpedm.CodCli Faccpedm.NomCli ~
Faccpedm.DirCli Faccpedm.FmaPgo Faccpedm.CodVen Faccpedm.Glosa ~
Faccpedm.CodTrans Faccpedm.DocDesp Faccpedm.FchPed Faccpedm.CodMon ~
Faccpedm.TpoCmb Faccpedm.Cmpbnte 
&Scoped-define DISPLAYED-TABLES Faccpedm
&Scoped-define FIRST-DISPLAYED-TABLE Faccpedm
&Scoped-Define DISPLAYED-OBJECTS TOGGLE-Vale F-CndVta F-nomVen F-Estado 

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
     SIZE 44.29 BY .69 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .69
     FONT 0 NO-UNDO.

DEFINE VARIABLE F-nomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44.29 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 6.35.

DEFINE VARIABLE TOGGLE-Vale AS LOGICAL INITIAL no 
     LABEL "Cupon de descuento" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     TOGGLE-Vale AT ROW 6.38 COL 19
     Faccpedm.PorDto AT ROW 6.38 COL 8.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
          BGCOLOR 15 FGCOLOR 12 
     Faccpedm.RucCli AT ROW 2.58 COL 49.14 COLON-ALIGNED
          LABEL "Ruc/L.E" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .69
     Faccpedm.NroPed AT ROW 1.19 COL 8.57 COLON-ALIGNED
          LABEL "Pedido" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 15.86 BY .69
          FONT 0
     Faccpedm.NroCard AT ROW 5.62 COL 73.72 COLON-ALIGNED
          LABEL "Nro.Tarjeta"
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .62
     Faccpedm.CodCli AT ROW 1.88 COL 8.57 COLON-ALIGNED HELP
          ""
          LABEL "Cliente" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     Faccpedm.NomCli AT ROW 1.88 COL 20 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 40.86 BY .69
     Faccpedm.DirCli AT ROW 2.58 COL 8.57 COLON-ALIGNED
          LABEL "Direccion"
          VIEW-AS FILL-IN 
          SIZE 33.43 BY .69
     Faccpedm.FmaPgo AT ROW 3.31 COL 3.43
          LABEL "Cond.Vta"
          VIEW-AS COMBO-BOX INNER-LINES 2
          LIST-ITEMS "000","001" 
          DROP-DOWN-LIST
          SIZE 6.86 BY 1
     Faccpedm.CodVen AT ROW 4.15 COL 8.57 COLON-ALIGNED FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 6.29 BY .69
     Faccpedm.Glosa AT ROW 4.85 COL 5.85
          LABEL "Glosa" FORMAT "X(100)"
          VIEW-AS FILL-IN 
          SIZE 52.43 BY .69
     Faccpedm.CodTrans AT ROW 5.62 COL 20.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .69
     Faccpedm.DocDesp AT ROW 5.54 COL 8.57 COLON-ALIGNED NO-LABEL
          VIEW-AS COMBO-BOX INNER-LINES 3
          LIST-ITEMS "NORMAL","GUIA" 
          DROP-DOWN-LIST
          SIZE 11.29 BY 1
     F-CndVta AT ROW 3.31 COL 16.43 COLON-ALIGNED NO-LABEL
     F-nomVen AT ROW 4.15 COL 16.43 COLON-ALIGNED NO-LABEL
     F-Estado AT ROW 1.19 COL 68.43 COLON-ALIGNED NO-LABEL
     Faccpedm.FchPed AT ROW 1.88 COL 75.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Faccpedm.CodMon AT ROW 2.69 COL 76.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.57 BY .69
     Faccpedm.TpoCmb AT ROW 3.5 COL 75.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Faccpedm.Cmpbnte AT ROW 4.31 COL 79.14 COLON-ALIGNED
          LABEL "Comprobante"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "FAC","TCK" 
          DROP-DOWN-LIST
          SIZE 6.72 BY 1
     "Moneda :" VIEW-AS TEXT
          SIZE 6.29 BY .5 AT ROW 2.62 COL 69.29
     RECT-26 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.faccpedm
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: T-VVALE T "SHARED" ? integral VtaVVale
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
         HEIGHT             = 7
         WIDTH              = 88.
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
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN Faccpedm.CodCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR RADIO-SET Faccpedm.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Faccpedm.CodTrans IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
ASSIGN 
       Faccpedm.CodTrans:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN Faccpedm.CodVen IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN Faccpedm.DirCli IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX Faccpedm.DocDesp IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
ASSIGN 
       Faccpedm.DocDesp:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-nomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Faccpedm.FchPed IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX Faccpedm.FmaPgo IN FRAME F-Main
   NO-ENABLE ALIGN-L EXP-LABEL                                          */
/* SETTINGS FOR FILL-IN Faccpedm.Glosa IN FRAME F-Main
   ALIGN-L EXP-LABEL EXP-FORMAT                                         */
/* SETTINGS FOR FILL-IN Faccpedm.NroCard IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
ASSIGN 
       Faccpedm.NroCard:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN Faccpedm.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN Faccpedm.PorDto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Faccpedm.RucCli IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN Faccpedm.TpoCmb IN FRAME F-Main
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

&Scoped-define SELF-NAME Faccpedm.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Faccpedm.CodCli V-table-Win
ON LEAVE OF Faccpedm.CodCli IN FRAME F-Main /* Cliente */
DO:
  IF Faccpedm.CodCli:SCREEN-VALUE = "" THEN DO: /*RETURN.*/
       MESSAGE "Ingrese codigo de Cliente" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
  END.
  
  FIND gn-clie WHERE gn-clie.CodCia = cl-codcia
                AND  gn-clie.CodCli = Faccpedm.CodCli:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie  THEN DO:
     S-CODCLI = Faccpedm.CodCli:SCREEN-VALUE.
     RUN VTA\D-RegCli.R (INPUT-OUTPUT S-CODCLI).
     IF S-CODCLI = "" THEN DO:
         APPLY "ENTRY" TO Faccpedm.CodCli.
         RETURN NO-APPLY.
     END.
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia
                   AND  gn-clie.CodCli = S-CODCLI 
                  NO-LOCK NO-ERROR.
  END.
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY gn-clie.CodCli @ Faccpedm.CodCli
             gn-clie.Nomcli @ Faccpedm.Nomcli
             gn-clie.ruc    @ Faccpedm.Ruccli.

     FacCPedm.FmaPgo:SCREEN-VALUE = "000" .
     S-CODMON = INTEGER(Faccpedm.CodMon:SCREEN-VALUE).

     IF Faccpedm.NomCli:SCREEN-VALUE = "" THEN DISPLAY gn-clie.NomCli @ Faccpedm.NomCli.
     IF Faccpedm.DirCli:SCREEN-VALUE = "" THEN DISPLAY gn-clie.DirCli @ Faccpedm.DirCli.
     IF gn-clie.Ruc = "" THEN Faccpedm.Cmpbnte:SCREEN-VALUE  = "TCK".
     ELSE Faccpedm.Cmpbnte:SCREEN-VALUE = "FAC".
     
     
     S-CNDVTA = gn-clie.CndVta.
     
     S-CODCLI = gn-clie.CodCli.
     S-CODVEN = gn-clie.CodVen.
     
     C-CodVen = S-CODVEN.
     /*C-Codven = "022".*/
     F-NomVen = "".
     IF C-CodVen = "" THEN C-CodVen = S-CODVEN.
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
                  AND  gn-ven.CodVen = C-CodVen 
                 NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
     DISPLAY c-codven @ FacCPedm.CodVen.
     DISPLAY F-NomVen.
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
  F-NomVen = "".
  IF SELF:SCREEN-VALUE = "" THEN DO: /*RETURN.*/
       MESSAGE "Ingrese codigo de Vendedor" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
  END.
  
  IF Faccpedm.CodVen:SCREEN-VALUE <> "" THEN DO: 
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
                  AND  gn-ven.CodVen = Faccpedm.CodVen:screen-value 
                 NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
     ELSE DO:
        MESSAGE "Vendedor no Registrado"
                VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Faccpedm.CodVen.
        RETURN NO-APPLY.
     END.
  END.
  DISPLAY F-NomVen WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Faccpedm.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Faccpedm.FmaPgo V-table-Win
ON LEAVE OF Faccpedm.FmaPgo IN FRAME F-Main /* Cond.Vta */
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


&Scoped-define SELF-NAME Faccpedm.NroCard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Faccpedm.NroCard V-table-Win
ON LEAVE OF Faccpedm.NroCard IN FRAME F-Main /* Nro.Tarjeta */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  
  IF Faccpedm.NroCard:SCREEN-VALUE <> "" THEN DO: 
     FIND Gn-Card WHERE Gn-Card.NroCard = Faccpedm.NroCard:SCREEN-VALUE 
                  NO-LOCK NO-ERROR.
     IF NOT AVAILABLE Gn-Card THEN DO:
        MESSAGE "Numero de Tarjeta NO Existe"
                VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Faccpedm.NroCard.
        RETURN NO-APPLY.
     END.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Faccpedm.PorDto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Faccpedm.PorDto V-table-Win
ON LEAVE OF Faccpedm.PorDto IN FRAME F-Main /* % Dscto. */
DO:
  IF INPUT {&SELF-NAME} > 5
  THEN DO:
    MESSAGE "No puede hacer un descuento mayor al 5%"
        VIEW-AS ALERT-BOX WARNING.
    RETURN NO-APPLY.
  END.
  s-PorDto = INPUT {&SELF-NAME}.
  RUN Procesa-Handle IN lh_Handle ('Recalculo').
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


&Scoped-define SELF-NAME TOGGLE-Vale
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-Vale V-table-Win
ON VALUE-CHANGED OF TOGGLE-Vale IN FRAME F-Main /* Cupon de descuento */
DO:
  IF INPUT {&SELF-NAME} = YES
  THEN ASSIGN
            Faccpedm.PorDto:SCREEN-VALUE = STRING(FacCfgGn.MrgMin)
            s-PorDto = FacCfgGn.MrgMin.
  ELSE ASSIGN
            Faccpedm.PorDto:SCREEN-VALUE = STRING(0.00)
            s-PorDto = 0.00.
  RUN Procesa-Handle IN lh_Handle ('Recalculo').
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
FOR EACH ITEM:
    DELETE ITEM.
END.
IF NOT L-CREA THEN DO:
   FOR EACH facdpedm OF faccpedm NO-LOCK:
       CREATE ITEM.
       RAW-TRANSFER facdpedm TO ITEM.
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
  {src/adm/template/row-list.i "faccpedm"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "faccpedm"}

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
    FOR EACH facdpedm WHERE facdpedm.codcia = faccpedm.codcia 
                          AND  facdpedm.coddoc = faccpedm.coddoc 
                          AND  facdpedm.nroped = faccpedm.nroped:
                          DELETE facdpedm.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calculo-Precios-Batch V-table-Win 
PROCEDURE Calculo-Precios-Batch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                  AND  Almmmatg.codmat = ITEM.CodMat 
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Almmmatg THEN DO:
      MESSAGE "Codigo de Articulo no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
   END.

   FIND Almtconv WHERE 
        Almtconv.CodUnid  = Almmmatg.UndBas AND  
        Almtconv.Codalter = ITEM.UndVta 
        NO-LOCK NO-ERROR.
   IF AVAILABLE Almtconv THEN
      F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
   ELSE DO:
        MESSAGE "Equivalencia no Registrado" VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
   END.
   

        X-FACTOR = 1.
        X-PREVTA1 = 0.
        X-PREVTA2 = 0.
        SW-LOG1 = FALSE.
        
        /****   PRECIO C    ****/
        IF Almmmatg.UndC <> "" AND NOT SW-LOG1 THEN DO:
            FIND B-Almtconv WHERE B-Almtconv.CodUnid = Almmmatg.UndBas 
                             AND  B-Almtconv.Codalter = Almmmatg.UndC 
                            NO-LOCK NO-ERROR.
            IF AVAILABLE B-Almtconv THEN
               X-FACTOR = B-Almtconv.Equival.
    
            IF (ITEM.CanPed * F-FACTOR) >= 
               (0.25 * X-FACTOR) THEN  
            DO:
                SW-LOG1 = TRUE.
                F-DSCTOS = Almmmatg.dsctos[3].
                IF Almmmatg.MonVta = 1 THEN
                  ASSIGN X-PREVTA1 = Almmmatg.Prevta[4]
                         X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
                ELSE
                  ASSIGN X-PREVTA2 = Almmmatg.Prevta[4]
                         X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
                         
                X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
                X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
                IF ITEM.UndVta = Almmmatg.UndC THEN DO:
                   F-PREBAS = IF S-CODMON = 1 THEN X-PREVTA1 ELSE X-PREVTA2.
                END.
            END.
        END.
    
        /****   PRECIO B    ****/
        IF Almmmatg.UndB <> "" AND NOT SW-LOG1 THEN DO:
            FIND B-Almtconv WHERE B-Almtconv.CodUnid = Almmmatg.UndBas 
                             AND  B-Almtconv.Codalter = Almmmatg.UndB 
                            NO-LOCK NO-ERROR.
            IF AVAILABLE B-Almtconv THEN
               X-FACTOR = B-Almtconv.Equival.
    
            IF (ITEM.CanPed * F-FACTOR) >= 
               (0.25 * X-FACTOR) THEN
            DO:
                SW-LOG1 = TRUE.
                F-DSCTOS = Almmmatg.dsctos[2].
                IF Almmmatg.MonVta = 1 THEN 
                  ASSIGN X-PREVTA1 = Almmmatg.Prevta[3]
                         X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
                ELSE
                  ASSIGN X-PREVTA2 = Almmmatg.Prevta[3]
                         X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
                X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
                X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
                IF ITEM.UndVta = Almmmatg.UndB THEN DO:
                   F-PREBAS = IF S-CODMON = 1 THEN X-PREVTA1 ELSE X-PREVTA2.
                END.

            END.
        END.
    
        /****   PRECIO A    ****/
        IF Almmmatg.UndA <> "" AND NOT SW-LOG1 THEN DO:
            FIND B-Almtconv WHERE B-Almtconv.CodUnid = Almmmatg.UndBas 
                             AND  B-Almtconv.Codalter = Almmmatg.UndA 
                            NO-LOCK NO-ERROR.
            IF AVAILABLE B-Almtconv THEN
               X-FACTOR = B-Almtconv.Equival.
    
            IF (ITEM.CanPed * F-FACTOR) >= 
               (0.25 * X-FACTOR) THEN
            DO:
                SW-LOG1 = TRUE.
                F-DSCTOS = Almmmatg.dsctos[1].
                IF Almmmatg.MonVta = 1 THEN 
                  ASSIGN X-PREVTA1 = Almmmatg.Prevta[2]
                         X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
                ELSE
                  ASSIGN X-PREVTA2 = Almmmatg.Prevta[2]
                         X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
                X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
                X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
                IF ITEM.UndVta = Almmmatg.UndA THEN DO:
                   F-PREBAS = IF S-CODMON = 1 THEN X-PREVTA1 ELSE X-PREVTA2.
                END.
            
            END.
            ELSE DO:
                SW-LOG1 = FALSE.
                F-DSCTOS = Almmmatg.dsctos[1].
                IF Almmmatg.MonVta = 1 THEN 
                  ASSIGN X-PREVTA1 = Almmmatg.Prevta[2]
                         X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
                ELSE
                  ASSIGN X-PREVTA2 = Almmmatg.Prevta[2]
                         X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
                X-PREVTA1 = (X-PREVTA1 / X-FACTOR) /* * F-FACTOR*/.
                X-PREVTA2 = (X-PREVTA2 / X-FACTOR) /* * F-FACTOR*/.
                IF ITEM.UndVta = Almmmatg.UndA THEN DO:
                   F-PREBAS = IF S-CODMON = 1 THEN X-PREVTA1 ELSE X-PREVTA2.
                END.

            END.
        END.       
 
        Y-DSCTOS = 0.
        
        /************Descuento Promocional ************/
        DEFINE VAR J AS INTEGER .
        DO J = 1 TO 10 :
           IF Almmmatg.PromDivi[J] = S-CODDIV AND
                            TODAY >= Almmmatg.PromFchD[J] AND 
                            TODAY <= Almmmatg.PromFchH[J] THEN DO:
              F-DSCTOS = Almmmatg.PromDto[J] .         
              F-PREVTA = Almmmatg.Prevta[1] * (1 - F-DSCTOS / 100).
              Y-DSCTOS = Almmmatg.PromDto[J] .
              SW-LOG1  = TRUE.              
              /*MESSAGE "Producto " + Almmmatg.Codmat + " Tiene Descuento Promocional " VIEW-AS ALERT-BOX INFORMATION.*/
              
              FIND B-Almtconv WHERE B-Almtconv.CodUnid = Almmmatg.UndBas 
                               AND  B-Almtconv.Codalter = ITEM.UndVta 
                               NO-LOCK NO-ERROR.
                 IF AVAILABLE B-Almtconv THEN
                     X-FACTOR = B-Almtconv.Equival.
                     IF Almmmatg.Monvta = 1 THEN 
                       ASSIGN X-PREVTA1 = F-PREVTA
                              X-PREVTA2 = ROUND(F-PREVTA / Almmmatg.TpoCmb,6).
                     ELSE
                       ASSIGN X-PREVTA2 = F-PREVTA
                              X-PREVTA1 = ROUND(F-PREVTA * Almmmatg.TpoCmb,6).
                     X-PREVTA1 = X-PREVTA1 * X-FACTOR.
                     X-PREVTA2 = X-PREVTA2 * X-FACTOR.
              
              
           END.   
        END.
        /************************************************/
     
        /***************Descuento Volumen****************/
        IF ITEM.CanPed <> 0 THEN DO:
           DEFINE VAR X-RANGO AS INTEGER INIT 0.   
           DEFINE VAR X-CANTI AS DECI    INIT 0.   
           FIND B-Almtconv WHERE B-Almtconv.CodUnid = Almmmatg.UndBas 
                           AND  B-Almtconv.Codalter = ITEM.UndVta 
                           NO-LOCK NO-ERROR.
           IF AVAILABLE B-Almtconv THEN DO:
              X-FACTOR = B-Almtconv.Equival.
              X-CANTI = ITEM.CanPed * X-FACTOR .
           END.
                       
           DO J = 1 TO 10 :
              IF X-CANTI >= Almmmatg.DtoVolR[J] AND Almmmatg.DtoVolR[J] > 0  THEN DO:
                 
                 IF X-RANGO  = 0 THEN X-RANGO = Almmmatg.DtoVolR[J].
                 IF X-RANGO <= Almmmatg.DtoVolR[J] THEN DO:
                    X-RANGO  = Almmmatg.DtoVolR[J] .
                    F-DSCTOS = Almmmatg.DtoVolD[J] .         
                    F-PREVTA = Almmmatg.Prevta[1] * (1 - F-DSCTOS / 100).
                    Y-DSCTOS = Almmmatg.DtoVolD[J] .
                    SW-LOG1  = TRUE.
                    /*MESSAGE "Producto " + Almmmatg.Codmat + " Tiene Descuento X Volumen" VIEW-AS ALERT-BOX INFORMATION.*/
                    
                    
                       IF Almmmatg.MonVta = 1 THEN 
                          ASSIGN X-PREVTA1 = F-PREVTA
                                 X-PREVTA2 = ROUND(F-PREVTA / Almmmatg.TpoCmb,6).
                       ELSE
                          ASSIGN X-PREVTA2 = F-PREVTA
                                 X-PREVTA1 = ROUND(F-PREVTA * Almmmatg.TpoCmb,6).
                          X-PREVTA1 = X-PREVTA1 * X-FACTOR.
                          X-PREVTA2 = X-PREVTA2 * X-FACTOR.
                    
                                        
                 END.   
              END.   
           END.
         END.        
        /************************************************/
       
        IF S-CODMON = 1 THEN 
            F-PREVTA = X-PREVTA1.
        ELSE 
            F-PREVTA = X-PREVTA2.
       


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cancelar-Documento V-table-Win 
PROCEDURE Cancelar-Documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND B-CDocu WHERE B-CDocu.CodCia = s-codcia 
                AND  B-CDocu.CodDoc = 'N/C' 
                AND  B-CDocu.NroDoc = T-CcbCCaja.Voucher[6] 
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE B-CDocu THEN DO:
     MESSAGE 'Nota de Credito no se encuentra registrada' VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.
  CREATE CcbDCaja.
  ASSIGN 
     CcbDCaja.CodCia = s-CodCia
     CcbDCaja.CodDoc = 'N/C'
     CcbDCaja.NroDoc = T-CcbCCaja.Voucher[6]
     CcbDCaja.CodMon = B-CDocu.CodMon
     CcbDCaja.TpoCmb = CcbCDocu.tpocmb
     CcbDCaja.CodCli = CcbCDocu.CodCli
     CcbDCaja.CodRef = B-CDocu.CodDoc
     CcbDCaja.NroRef = B-CDocu.NroDoc
     CcbDCaja.FchDoc = CcbCDocu.FchDoc.
  IF B-CDocu.CodMon = 1 THEN
     ASSIGN 
        CcbDCaja.ImpTot = T-CcbCCaja.ImpNac[6].
  ELSE
     ASSIGN 
        CcbDCaja.ImpTot = T-CcbCCaja.ImpUsa[6].

  RUN Cancelar_Nota_Credito ( s-CodCia, CcbDCaja.CodRef, CcbDCaja.NroRef, CcbDCaja.CodMon,
                              CcbDCaja.TpoCmb, CcbDCaja.ImpTot, FALSE ).
  /*
  RUN Cancelar_Nota_Credito ( s-CodCia, CcbDCaja.CodDoc, CcbDCaja.NroDoc, CcbDCaja.CodMon,
                              CcbDCaja.TpoCmb, CcbDCaja.ImpTot, FALSE ).    
  */

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
  IF FaccPedm.FlgEst <>  "P" THEN RETURN.
   
  DEFINE VARIABLE i       AS INTEGER INITIAL 1 NO-UNDO.
  DEFINE VARIABLE D-ROWID AS ROWID NO-UNDO.
  
  D-ROWID = ROWID(faccpedm).
  
  FIND B-PedM WHERE ROWID(B-PedM) = D-ROWID NO-LOCK NO-ERROR. 
  /**** SOLO CONTADO Y CONTADO ANTICIPADO GENERAN INGRESO A CAJA ****/

  /*********Miguel Gomez **********/
  FIND FIRST ccbdterm WHERE CcbDTerm.CodCia = s-codcia 
                       AND  CcbDTerm.CodDiv = s-coddiv 
                       AND  CcbDTerm.CodDoc = B-PEDM.Cmpbnte 
                       AND  CcbDTerm.CodTer = s-codter NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ccbdterm
  THEN DO:
      MESSAGE "Terminal no configurada" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.

  s-ptovta = ccbdterm.nroser.
  /*****************************************/
   
  FIND FacDocum WHERE facdocum.codcia = s-codcia AND facdocum.coddoc = faccpedm.cmpbnte
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacDocum
  THEN DO:
      MESSAGE "No esta definido el documento" faccpedm.cmpbnte VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  s-codmov = facdocum.codmov.
  FIND almtmovm WHERE Almtmovm.CodCia = s-codcia AND
      Almtmovm.Codmov = s-codmov AND Almtmovm.Tipmov = "S" NO-LOCK NO-ERROR.
  IF NOT AVAILABLE almtmovm
  THEN DO:
      MESSAGE "No esta definido el movimiento de salida" s-codmov VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  FIND FacCorre WHERE faccorre.codcia = s-codcia AND 
                      faccorre.coddoc = faccpedm.cmpbnte AND
                      faccorre.nroser = s-ptovta NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCorre
  THEN DO:
      MESSAGE "No esta definida la serie" s-ptovta SKIP
              "para el comprobante "  faccpedm.cmpbnte 
              VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  s-codalm = faccorre.codalm.
  
  IF LOOKUP(B-PedM.FmaPgo,"000,002") > 0 
  /*THEN RUN ccb\Canc_Ped ( D-ROWID, OUTPUT L-OK).*/
  THEN RUN ccb/canc_ped12 (D-ROWID, OUTPUT L-OK).
  ELSE L-OK = YES.

  IF L-OK = NO THEN RETURN "ADM-ERROR".
  
  S-CODDOC = B-PedM.Cmpbnte.

  RUN Crea-Temporal.
           
  DO TRANSACTION ON ERROR UNDO, RETURN ERROR:
     FIND B-PedM WHERE ROWID(B-PedM) = D-ROWID EXCLUSIVE-LOCK . 
      
     FOR EACH T-CPEDM:
         S-CodAlm = trim(T-CPEDM.CodAlm). 
         CREATE CcbCDocu.
         FIND faccorre WHERE 
              faccorre.codcia = s-codcia AND  
              faccorre.coddoc = s-coddoc AND  
              faccorre.NroSer = s-ptovta EXCLUSIVE-LOCK NO-ERROR.
         IF AVAILABLE faccorre THEN 
            ASSIGN ccbcdocu.nrodoc = STRING(faccorre.nroser, "999") + STRING(FacCorre.Correlativo, "999999")
                   faccorre.correlativo = faccorre.correlativo + 1.
         RELEASE faccorre.
         ASSIGN T-CPEDM.CodRef    = s-CodDoc
                T-CPEDM.NroRef    = ccbcdocu.nrodoc
                CcbCDocu.CodCia   = S-CodCia
                CcbCDocu.CodDoc   = s-CodDoc
                CcbCDocu.FchDoc   = TODAY
                CcbCDocu.usuario  = S-User-Id
                CcbCDocu.usrdscto = T-CPEDM.usrdscto 
                CcbCDocu.Tipo     = S-Tipo
                CcbCDocu.CodAlm   = S-CodAlm
                CcbCDocu.CodDiv   = S-CodDiv
                CcbCDocu.CodCli   = T-CPEDM.Codcli
                CcbCDocu.RucCli   = T-CPEDM.RucCli
                CcbCDocu.NomCli   = T-CPEDM.Nomcli
                CcbCDocu.DirCli   = T-CPEDM.DirCli
                CcbCDocu.CodMon   = T-CPEDM.codmon
                CcbCDocu.CodMov   = S-CodMov
                CcbCDocu.CodPed   = T-CPEDM.coddoc
                CcbCDocu.CodVen   = T-CPEDM.codven
                CcbCDocu.FchCan   = TODAY
                CcbCDocu.FchVto   = TODAY
                CcbCDocu.ImpBrt   = T-CPEDM.impbrt
                CcbCDocu.ImpDto   = T-CPEDM.impdto
                CcbCDocu.ImpExo   = T-CPEDM.impexo
                CcbCDocu.ImpIgv   = T-CPEDM.impigv
                CcbCDocu.ImpIsc   = T-CPEDM.impisc
                CcbCDocu.ImpTot   = T-CPEDM.imptot
                CcbCDocu.ImpVta   = T-CPEDM.impvta
                CcbCDocu.TipVta   = "1" 
                CcbCDocu.TpoFac   = "C"
                CcbCDocu.FlgEst   = "P"
                CcbCDocu.FmaPgo   = T-CPEDM.FmaPgo
                CcbCDocu.NroPed   = B-PedM.NroPed
                CcbCDocu.PorIgv   = T-CPEDM.porigv 
                CcbCDocu.PorDto   = T-CPEDM.PorDto
                CcbCDocu.SdoAct   = T-CPEDM.imptot
                CcbCDocu.TpoCmb   = T-CPEDM.tpocmb
                CcbCDocu.Glosa    = T-CPEDM.Glosa
                CcbCDocu.AcuBon[1] = T-CPEDM.AcuBon[1]
               /* CcbCDocu.AcuBon[2] = T-CPEDM.AcuBon[2] */
                CcbCDocu.AcuBon[2] = T-CPEDM.Importe[1]
                CcbCDocu.AcuBon[3] = T-CPEDM.Importe[2]
                CcbCDocu.tipBon[1] = T-CPEDM.tipBon[1]
                CcbCDocu.NroCard   = T-CPEDM.NroCard .
                
                /* POR AHORA GRABAMOS EL TIPO DE ENTREGA */
                CcbCDocu.CodAge   = T-CPEDM.CodTrans.
                CcbCDocu.FlgSit   = IF T-CPEDM.DocDesp = "GUIA" THEN "G" ELSE "".
                CcbCDocu.FlgCon   = IF T-CPEDM.DocDesp = "GUIA" THEN "G" ELSE "".
                IF B-PedM.FmaPgo  = "001" THEN CcbCDocu.FlgCon = "E".
                IF B-PedM.FmaPgo  = "002" THEN CcbCDocu.FlgCon = "A".
         /* actualizamos el detalle */
         i = 1.     /****   Add by C.Q. 13/02/2000  ****/

         FOR EACH T-DPEDM OF T-CPEDM BY nroitm:
             CREATE ccbDDocu.
             ASSIGN CcbDDocu.CodCia = ccbcdocu.codcia
                    CcbDDocu.CodDoc = ccbcdocu.coddoc
                    CcbDDocu.NroDoc = ccbcdocu.nrodoc
                    CcbDDocu.codmat = T-DPEDM.codmat
                    CcbDDocu.Factor = T-DPEDM.factor
                    CcbDDocu.ImpDto = T-DPEDM.impdto
                    CcbDDocu.ImpIgv = T-DPEDM.impigv
                    CcbDDocu.ImpIsc = T-DPEDM.impisc
                    CcbDDocu.ImpLin = T-DPEDM.implin
                    CcbDDocu.AftIgv = T-DPEDM.aftigv
                    CcbDDocu.AftIsc = T-DPEDM.aftisc
                    CcbDDocu.CanDes = T-DPEDM.canped
                    CcbDDocu.NroItm = i
                    CcbDDocu.PorDto = T-DPEDM.pordto
                    CcbDDocu.PreBas = T-DPEDM.prebas
                    CcbDDocu.PreUni = T-DPEDM.preuni
                    CcbDDocu.PreVta[1] = T-DPEDM.prevta[1]
                    CcbDDocu.PreVta[2] = T-DPEDM.prevta[2]
                    CcbDDocu.PreVta[3] = T-DPEDM.prevta[3]
                    CcbDDocu.UndVta = T-DPEDM.undvta
                    CcbDDocu.AlmDes = T-DPEDM.AlmDes
                    CcbDDocu.Por_Dsctos[1] = T-DPEDM.Por_Dsctos[1]
                    CcbDDocu.Por_Dsctos[2] = T-DPEDM.Por_Dsctos[2]
                    CcbDDocu.Por_Dsctos[3] = T-DPEDM.Por_Dsctos[3]
                    CcbDDocu.Flg_factor = T-DPEDM.Flg_factor
                    CcbDDocu.FchDoc   = TODAY
                    CcbDDocu.CodDiv   = S-CodDiv

                 i = i + 1.
                /***********Grabando Costos **********************/
                  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                                 AND  Almmmatg.codmat = CcbDDocu.Codmat 
                                NO-LOCK NO-ERROR.
                  IF AVAILABLE Almmmatg THEN DO: 
                      if almmmatg.monvta = 1 then do:
                        x-cto1 = ROUND( Almmmatg.Ctotot * CcbDDocu.CanDes * CcbDDocu.Factor , 2 ).
                        x-cto2 = ROUND(( Almmmatg.Ctotot * CcbDDocu.CanDes * CcbDDocu.Factor ) /  Almmmatg.Tpocmb , 2 ).
                      end.
            
                      if almmmatg.monvta = 2 then do:
                        x-cto1 = ROUND( Almmmatg.Ctotot * CcbDDocu.CanDes * CcbDDocu.Factor * Almmmatg.TpoCmb, 2 ).
                        x-cto2 = ROUND(( Almmmatg.Ctotot * CcbDDocu.CanDes * CcbDDocu.Factor ) , 2 ).
                      end.
                     CcbDDocu.ImpCto = IF CcbCDocu.Codmon = 1 THEN x-cto1 ELSE x-cto2.
                  END.
                  CcbCDocu.ImpCto = CcbCDocu.ImpCto + CcbDDocu.ImpCto.
                
                /*************************************************/        

                
         END.
     END.
     /**** ACTUALIZAMOS FLAG DEL PEDIDO  DE MOSTRADOR COMO ATENDIDO ****/
     ASSIGN  B-PedM.flgest = "C".
     /***********************************/
     
     /**** SOLO CONTADO Y CONTADO ANTICIPADO GENERAN INGRESO A CAJA ****/
     IF LOOKUP(B-PedM.FmaPgo,"000,002") > 0 THEN DO:
        /* Cancelacion del documento */
        RUN Ingreso-a-Caja-original.
        /* Generar Asignacion de Nota de Credito */
        IF T-CcbCCaja.Voucher[6] <> "" AND
           (T-CcbCCaja.ImpNac[6] + T-CcbCCaja.ImpUsa[6]) > 0 
        THEN RUN Cancelar_Documento.
     END.
     /**** SOLO CONTADO Y CONTRA ENTREGA DESCARGAN DEL ALMACEN ****/
     RUN Descarga-de-Almacen.
  END.
  RELEASE B-PedM.
  
  /**** IMPRIMIMOS LAS FACTURAS O BOLETAS Y SUS ORDENES DE DESPACHO ****/
  FOR EACH T-CPEDM NO-LOCK 
           BY T-CPEDM.NroPed ON ERROR UNDO, RETURN "ADM-ERROR":
      FIND CcbCDocu WHERE 
           CcbCDocu.CodCia = S-CodCia AND
           CcbCDocu.CodDoc = T-CPEDM.CodRef AND
           CcbCDocu.NroDoc = T-CPEDM.NroRef EXCLUSIVE-LOCK NO-ERROR. 
      IF AVAILABLE CcbCDocu THEN  DO:
        /* Cambiamos al formato similar al de ATE */
        /*IF Ccbcdocu.CodDoc = "FAC" THEN RUN ccb/r-factet (ROWID(ccbcdocu)).*/
        /*IF Ccbcdocu.CodDoc = "FAC" THEN RUN vta/r-impfac2 (ROWID(ccbcdocu)).*/
        IF ccbcdocu.coddoc = 'FAC' THEN RUN ccb/r-fact01 (ROWID(ccbcdocu)).
        IF ccbcdocu.coddoc = 'TCK'
        THEN DO:
            CASE s-codter:
                WHEN 'TERM01' OR WHEN 'TERM02' THEN RUN ccb/r-tick500 (ROWID(ccbcdocu)).
                OTHERWISE RUN ccb/r-tick01 (ROWID(ccbcdocu)).
            END CASE.
         END.
         /*IF Ccbcdocu.CodDoc = "BOL" THEN RUN ccb/r-bole01 (ROWID(ccbcdocu)).*/
         FIND FIRST Ccbddocu OF Ccbcdocu NO-LOCK NO-ERROR.
      END.
  END.

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  S-CODDOC = "P/M".
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cancelar_Documento V-table-Win 
PROCEDURE Cancelar_Documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND B-CDocu WHERE B-CDocu.CodCia = s-codcia 
                AND  B-CDocu.CodDoc = 'N/C' 
                AND  B-CDocu.NroDoc = T-CcbCCaja.Voucher[6] 
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE B-CDocu THEN DO:
     MESSAGE 'Nota de Credito no se encuentra registrada' VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.
  CREATE CcbDCaja.
  ASSIGN 
     CcbDCaja.CodCia = s-CodCia
     CcbDCaja.CodDoc = 'N/C'
     CcbDCaja.NroDoc = T-CcbCCaja.Voucher[6]
     CcbDCaja.CodMon = B-CDocu.CodMon
     CcbDCaja.TpoCmb = FacCPedm.TpoCMb      /*CcbCDocu.tpocmb*/
     CcbDCaja.CodCli = FacCPedm.CodCli      /*CcbCDocu.CodCli*/
     CcbDCaja.CodRef = B-CDocu.CodDoc
     CcbDCaja.NroRef = B-CDocu.NroDoc
     CcbDCaja.FchDoc = TODAY.               /*CcbCDocu.FchDoc.*/
  IF B-CDocu.CodMon = 1 THEN
     ASSIGN 
        CcbDCaja.ImpTot = T-CcbCCaja.ImpNac[6].
  ELSE
     ASSIGN 
        CcbDCaja.ImpTot = T-CcbCCaja.ImpUsa[6].

  RUN Cancelar_Nota_Credito ( s-CodCia, CcbDCaja.CodRef, CcbDCaja.NroRef, CcbDCaja.CodMon,
                              CcbDCaja.TpoCmb, CcbDCaja.ImpTot, FALSE ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cancelar_Nota_Credito V-table-Win 
PROCEDURE Cancelar_Nota_Credito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER iCodCia AS INTEGER.
DEFINE INPUT PARAMETER cCodDoc AS CHAR.
DEFINE INPUT PARAMETER cNroDoc AS CHAR.
DEFINE INPUT PARAMETER iCodMon AS INTEGER.
DEFINE INPUT PARAMETER fTpoCmb AS DECIMAL.
DEFINE INPUT PARAMETER fImpTot AS DECIMAL.
DEFINE INPUT PARAMETER LSumRes AS LOGICAL.

DEFINE VAR XfImport AS DECIMAL INITIAL 0.

FIND FIRST B-CDocu WHERE B-CDocu.CodCia = iCodCia 
                    AND  B-CDocu.CodDoc = cCodDoc 
                    AND  B-CDocu.NroDoc = cNroDoc 
                   EXCLUSIVE-LOCK NO-ERROR.
IF AVAILABLE B-CDocu THEN DO :
   XfImport = fImpTot.
   IF B-CDocu.CodMon <> iCodMon THEN DO:
      IF B-CDocu.CodMon = 1 THEN 
         ASSIGN XfImport = ROUND( fImpTot * fTpoCmb , 2 ).
      ELSE ASSIGN XfImport = ROUND( fImpTot / fTpoCmb , 2 ).
   END.
   
   IF LSumRes THEN ASSIGN B-CDocu.SdoAct = B-CDocu.SdoAct + XfImport.
   ELSE ASSIGN B-CDocu.SdoAct = B-CDocu.SdoAct - XfImport.
   
   IF B-CDocu.SdoAct <= 0 THEN ASSIGN B-CDocu.FlgEst = "C".
   ELSE ASSIGN B-CDocu.FlgEst = "P".
   RELEASE B-CDocu.
END.                          
ELSE MESSAGE "Nota de Credito no registrada " VIEW-AS ALERT-BOX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Canje-Factura V-table-Win 
PROCEDURE Canje-Factura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR C-NROGUI AS CHAR.
DEFINE VAR D-FCHVTO AS DATE.
DEFINE VAR I AS INTEGER.
DEFINE VAR C-NRODOC AS CHAR.
DEFINE VAR C-NROPED AS CHAR.
DEFINE VAR I-CODMON AS INTEGER.
DEFINE VAR X-CODDOC AS CHAR.

 DO WITH FRAME {&FRAME-NAME}:
    /*
    IF FaccPedm.CodCli:SCREEN-VALUE = "" THEN DO:
       MESSAGE "Debe registrar al cliente" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    */
    IF NOT FaccPedm.CodCli:SENSITIVE THEN DO:
       MESSAGE "Solo puede asignar una vez" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    RUN Actualiza-ITEM.
    input-var-1 = FaccPedm.CodCli:SCREEN-VALUE.
    C-NROGUI = "".
    output-var-2 = "".
    RUN lkup\C-Facbac.r("Tickets x Canjear").
    IF output-var-2 <> ? THEN DO:
       C-NROGUI = output-var-2.
       D-FCHVTO = ?.
/*       MESSAGE output-var-2.*/
       DO I = 1 TO NUM-ENTRIES(output-var-2):
          C-NRODOC = ENTRY(I,output-var-2).
          x-coddoc = output-var-3.
          
          FIND B-CDOCU WHERE B-CDOCU.CodCia = S-CODCIA
                        AND  B-CDOCU.CodDoc = x-coddoc
                        AND  B-CDOCU.NroDoc = C-NroDoc 
                       NO-LOCK NO-ERROR.
          C-NROPED = B-CDOCU.NroPed.  
          I-CODMON = B-CDOCU.CodMon.
          C-CODVEN = B-CDOCU.CodVen.
          
          FaccPedm.CodCli:SCREEN-VALUE = B-CDOCU.codcli.
          FaccPedm.nomCli:SCREEN-VALUE = B-CDOCU.nomcli.
          FaccPedm.dirCli:SCREEN-VALUE = B-CDOCU.dircli.
          FaccPedm.ruc:SCREEN-VALUE = B-CDOCU.ruc.
          FaccPedm.glosa:SCREEN-VALUE = B-CDOCU.glosa.
          /*
          FaccPedm.nroped:SCREEN-VALUE = C-NROPED.
          */
          
/*          message "EL NUMERO g/r ES: " FaccPedm.nroref:SCREEN-VALUE view-as alert-box.*/

          IF D-FCHVTO = ? THEN D-FCHVTO = B-CDOCU.FchVto.
          D-FCHVTO = MAXIMUM( D-FCHVTO , B-CDOCU.FchVto ).
          
          
          /* asigna los articulos a la factura */
          FOR EACH CcbDDocu NO-LOCK OF B-CDOCU /*WHERE CcbDDocu.CodCia = B-CDOCU.CodCia AND  CcbDDocu.NroDoc = B-CDOCU.NroDoc*/ :
              FIND ITEM WHERE ITEM.CodCia = CcbDDocu.CodCia 
                         AND  ITEM.codmat = CcbDDocu.codmat NO-ERROR.
              IF NOT AVAILABLE ITEM THEN
              CREATE ITEM.
              ASSIGN ITEM.CodCia = CcbDDocu.CodCia
                     ITEM.NroItm = Ccbddocu.Nroitm
                     ITEM.AlmDes = CcbDDocu.Almdes
                     ITEM.codmat = CcbDDocu.codmat 
                     ITEM.PreUni = CcbDDocu.PreUni 
                     ITEM.Factor = CcbDDocu.Factor 
                     ITEM.PorDto = CcbDDocu.PorDto 
                     ITEM.PreBas = CcbDDocu.PreBas 
                     ITEM.AftIgv = CcbDDocu.AftIgv
                     ITEM.AftIsc = CcbDDocu.AftIsc
                     ITEM.UndVta = CcbDDocu.UndVta.
                     ITEM.CanPed = ITEM.CanPed + CcbDDocu.CanDes.
                     
              FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                             AND  Almmmatg.codmat = ITEM.codmat 
                            NO-LOCK NO-ERROR.
              IF AVAILABLE Almmmatg THEN DO:
                 ASSIGN ITEM.ImpDto = ROUND( ITEM.PreUni * (ITEM.PorDto / 100) * ITEM.CanPed , 2 )
                        ITEM.ImpLin = ROUND( ITEM.PreUni * ITEM.CanPed , 2 ) /*- ITEM.ImpDto*/.
                 IF ITEM.AftIsc THEN 
                    ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
                 IF ITEM.AftIgv THEN 
                    ITEM.ImpIgv = ITEM.ImpLin - ROUND(ITEM.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
 
 
              END.
          END. 
       END.
       F-NomVen = "".
       F-CndVta = "".
/*       DISPLAY B-CDOCU.FmaPgo @ FaccPedm.FmaPgo.*/
/*       C-TpoVta:SCREEN-VALUE = ENTRY(INTEGER(B-CDOCU.TipVta),C-TpoVta:LIST-ITEMS).*/
       FIND gn-convt WHERE gn-convt.Codig = B-CDOCU.FmaPgo NO-LOCK NO-ERROR.
       IF AVAILABLE gn-convt THEN F-CndVta = gn-convt.Nombr.
       FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
                    AND  gn-ven.CodVen = C-CODVEN 
                   NO-LOCK NO-ERROR.
       IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
       /*FaccPedm.CodCli:SENSITIVE = NO.*/
       FaccPedm.CodMon:SCREEN-VALUE = STRING(I-CodMon).
       DISPLAY C-NROPED @ FaccPedm.NroPed
               C-CODVEN @ FaccPedm.CodVen
               F-NomVen F-CndVta.
       END.
 END.
RUN Procesa-Handle IN lh_Handle ('Browse').
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Copiar-factura V-table-Win 
PROCEDURE Copiar-factura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
message "No entiendes ?" view-as alert-box question.

IF S-USER-ID <> "ADMIN" THEN DO:
    RETURN.
END.

RUN XXXX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Temporal V-table-Win 
PROCEDURE Crea-Temporal :
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
  DEFINE VARIABLE I-NPED   AS INTEGER INIT 0.
  DEFINE VARIABLE I-NItem  AS INTEGER INIT 0.

  FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

  CREATE T-CPEDM.
    ASSIGN T-CPEDM.NroPed   = FacCPedm.NroPed
           T-CPEDM.CodAlm   = FaccPedm.CodAlm
           T-CPEDM.Cmpbnte  = Faccpedm.Cmpbnte 
           T-CPEDM.CodCia   = Faccpedm.CodCia 
           T-CPEDM.CodCli   = Faccpedm.CodCli 
           T-CPEDM.CodDiv   = Faccpedm.CodDiv 
           T-CPEDM.CodDoc   = Faccpedm.CodDoc 
           T-CPEDM.CodMon   = Faccpedm.CodMon 
           T-CPEDM.CodTrans = Faccpedm.CodTrans 
           T-CPEDM.CodVen   = Faccpedm.CodVen 
           T-CPEDM.DirCli   = Faccpedm.DirCli 
           T-CPEDM.DocDesp  = Faccpedm.DocDesp 
           T-CPEDM.FchPed   = Faccpedm.FchPed 
           T-CPEDM.FlgEst   = Faccpedm.FlgEst 
           T-CPEDM.FmaPgo   = Faccpedm.FmaPgo 
           T-CPEDM.Glosa    = Faccpedm.Glosa 
           T-CPEDM.Hora     = Faccpedm.Hora 
           T-CPEDM.LugEnt   = Faccpedm.LugEnt
           T-CPEDM.NomCli   = Faccpedm.NomCli 
           T-CPEDM.PorDto   = Faccpedm.PorDto 
           T-CPEDM.PorIgv   = Faccpedm.PorIgv
           T-CPEDM.RucCli   = Faccpedm.RucCli 
           T-CPEDM.TipVta   = Faccpedm.TipVta 
           T-CPEDM.TpoCmb   = Faccpedm.TpoCmb 
           T-CPEDM.UsrDscto = Faccpedm.UsrDscto 
           T-CPEDM.usuario  = Faccpedm.usuario
           T-CPEDM.ImpBrt   = Faccpedm.ImpBrt
           T-CPEDM.ImpDto   = Faccpedm.ImpDto
           T-CPEDM.ImpExo   = Faccpedm.ImpExo
           T-CPEDM.ImpIgv   = Faccpedm.ImpIgv
           T-CPEDM.ImpIsc   = Faccpedm.ImpIsc
           T-CPEDM.ImpTot   = Faccpedm.ImpTot
           T-CPEDM.ImpVta   = Faccpedm.ImpVta
           T-CPEDM.TipBon[1] = Faccpedm.TipBon[1].

  FOR EACH Facdpedm of Faccpedm:
      FIND T-DPEDM WHERE T-DPEDM.CodMat = FacdPedm.CodMat 
           NO-ERROR .
      IF NOT AVAILABLE T-DPEDM THEN DO:
         CREATE T-DPEDM.
         ASSIGN
         T-DPEDM.NroPed = Facdpedm.NroPed
         T-DPEDM.PreUni = Facdpedm.PreUni
         T-DPEDM.CodDoc = Facdpedm.Coddoc
         T-DPEDM.Codcia = Facdpedm.Codcia 
         T-DPEDM.AftIgv = Facdpedm.AftIgv 
         T-DPEDM.AftIsc = Facdpedm.AftIsc 
         T-DPEDM.AlmDes = Facdpedm.AlmDes          
         T-DPEDM.Coddoc = Facdpedm.CodDoc 
         T-DPEDM.CodMat = Facdpedm.codmat 
         T-DPEDM.Factor = Facdpedm.Factor 
         T-DPEDM.FchPed = Facdpedm.FchPed 
         T-DPEDM.FlgEst = Facdpedm.FlgEst 
         T-DPEDM.Flg_Factor = Facdpedm.Flg_Factor 
         T-DPEDM.Hora = Facdpedm.Hora 
         T-DPEDM.MrgUti  = Facdpedm.MrgUti 
         T-DPEDM.PorDto2 = Facdpedm.PorDto2 
         T-DPEDM.Por_Dsctos[1] = Facdpedm.Por_Dsctos[1] 
         T-DPEDM.Por_Dsctos[2] = Facdpedm.Por_Dsctos[2] 
         T-DPEDM.Por_Dsctos[3] = Facdpedm.Por_Dsctos[3] 
         T-DPEDM.PreBas = Facdpedm.PreBas 
         T-DPEDM.PreVta[1] = Facdpedm.PreVta[1] 
         T-DPEDM.PreVta[2] = Facdpedm.PreVta[2] 
         T-DPEDM.PreVta[3] = Facdpedm.PreVta[3] 
         T-DPEDM.UndVta = Facdpedm.UndVta.
         I-NItem = I-NItem + 1.
      END.
      ASSIGN
        T-DPEDM.ImpIsc = T-DPEDM.ImpIsc + Facdpedm.ImpIsc
        T-DPEDM.ImpDto = T-DPEDM.ImpDto + Facdpedm.ImpDto
        T-DPEDM.ImpIgv = T-DPEDM.ImpIgv + Facdpedm.ImpIgv
        T-DPEDM.ImpLin = T-DPEDM.ImpLin + Facdpedm.ImpLin    
        T-DPEDM.CanAte = T-DPEDM.CanAte + Facdpedm.CanAte    
        T-DPEDM.CanPed = T-DPEDM.CanPed + Facdpedm.CanPed.    
 
  END.
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descarga-de-Almacen V-table-Win 
PROCEDURE Descarga-de-Almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF VAR i AS INTEGER INITIAL 1 NO-UNDO.
   FOR EACH T-CPEDM NO-LOCK BY T-CPEDM.NroPed ON ERROR UNDO, RETURN "ADM-ERROR":
       FIND CcbCDocu WHERE 
            CcbCDocu.CodCia = S-CodCia AND
            CcbCDocu.CodDoc = T-CPEDM.CodRef AND
            CcbCDocu.NroDoc = T-CPEDM.NroRef AND
            CcbCDocu.CodAlm = trim(T-CPEDM.CodAlm)        /****   ADD BY C.Q. 03/03/2000  ****/
            EXCLUSIVE-LOCK NO-ERROR. 
       IF AVAILABLE CcbCDocu THEN  DO:
          /* Correlativo de Salida */
          FIND Almacen WHERE 
               Almacen.CodCia = CcbCDocu.CodCia AND  
               Almacen.CodAlm = trim(CcbCDocu.CodAlm)  EXCLUSIVE-LOCK NO-ERROR.
          CREATE Almcmov.
          ASSIGN Almcmov.CodCia  = CcbCDocu.CodCia
                 Almcmov.CodAlm  = trim(CcbCDocu.CodAlm)
                 Almcmov.TipMov  = "S"
                 Almcmov.CodMov  = CcbCDocu.CodMov
                 Almcmov.NroSer  = S-PtoVta
                 Almcmov.NroDoc  = Almacen.CorrSal
                 Almcmov.CodRef  = CcbCDocu.CodDoc
                 Almcmov.NroRef  = CcbCDocu.NroDoc
                 Almcmov.NroRf1  = SUBSTRING(CcbCDocu.CodDoc,1,1) + CcbCDocu.NroDoc
                 Almcmov.NroRf2  = CcbCDocu.NroPed
                 Almcmov.Nomref  = CcbCDocu.NomCli
                 Almcmov.FchDoc  = TODAY
                 Almcmov.HorSal  = STRING(TIME, "HH:MM:SS")
                 Almcmov.CodVen  = Ccbcdocu.CodVen
                 Almcmov.CodCli  = Ccbcdocu.CodCli
                 Almcmov.usuario = S-User-Id
                 CcbcDocu.NroSal = STRING(Almcmov.NroDoc,"999999").
                 Almacen.CorrSal = Almacen.CorrSal + 1.
          RELEASE Almacen.
          FOR EACH ccbddocu OF ccbcdocu NO-LOCK ON ERROR UNDO, RETURN "ADM-ERROR":
              CREATE Almdmov.
              ASSIGN Almdmov.CodCia = AlmCmov.CodCia
                     Almdmov.CodAlm = trim(AlmCmov.CodAlm)
                     Almdmov.TipMov = trim(AlmCmov.TipMov)
                     Almdmov.CodMov = AlmCmov.CodMov
                     Almdmov.NroSer = Almcmov.NroSer
                     Almdmov.NroDoc = Almcmov.NroDoc
                     Almdmov.FchDoc = Almcmov.FchDoc
                     Almdmov.NroItm = i
                     Almdmov.codmat = trim(ccbddocu.codmat)
                     Almdmov.CanDes = ccbddocu.candes
                     Almdmov.AftIgv = ccbddocu.aftigv
                     Almdmov.AftIsc = ccbddocu.aftisc
                     Almdmov.CodMon = ccbcdocu.codmon
                     Almdmov.CodUnd = ccbddocu.undvta
                     Almdmov.Factor = ccbddocu.factor
                     Almdmov.ImpDto = ccbddocu.impdto
                     Almdmov.ImpIgv = ccbddocu.impigv
                     Almdmov.ImpIsc = ccbddocu.impisc
                     Almdmov.ImpLin = ccbddocu.implin
                     Almdmov.PorDto = ccbddocu.pordto
                     Almdmov.PreBas = ccbddocu.prebas
                     Almdmov.PreUni = ccbddocu.preuni
                     Almdmov.TpoCmb = ccbcdocu.tpocmb
                     Almdmov.Por_Dsctos[1] = ccbddocu.Por_Dsctos[1]
                     Almdmov.Por_Dsctos[2] = ccbddocu.Por_Dsctos[2]
                     Almdmov.Por_Dsctos[3] = ccbddocu.Por_Dsctos[3]
                     Almdmov.Flg_factor = ccbddocu.Flg_factor
                     Almcmov.TotItm = i
                     i = i + 1.
            /*RUN alm/almdgstk (ROWID(almdmov)).*/
            RUN alm/almdcstk (ROWID(almdmov)).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
            
            /* RHC REACTIVAMOS KARDEX POR ALMACEN */
            RUN alm/almacpr1 (ROWID(almdmov), 'U').
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
              
          END.
       END.
   END.
   RELEASE almcmov.
   RELEASE almdmov.
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

   RUN Borra-Pedido. 
   FOR EACH ITEM WHERE trim(item.codmat) ne "" BY ITEM.NroItm: 
       I-NITEM = I-NITEM + 1.
       CREATE facdpedm.
       item.CodCia = faccpedm.CodCia.
       item.coddoc = faccpedm.coddoc.
       item.NroPed = faccpedm.NroPed.
       ASSIGN Facdpedm.CodCia = Faccpedm.CodCia 
              Facdpedm.coddoc = Faccpedm.coddoc 
              Facdpedm.NroPed = Faccpedm.NroPed 
              Facdpedm.FlgEst = Faccpedm.FlgEst
              Facdpedm.Hora   = Faccpedm.Hora
              FacDPedm.FchPed = FacCPedm.FchPed
              Facdpedm.AftIgv = ITEM.AftIgv
              Facdpedm.AftIsc = ITEM.AftIsc
              Facdpedm.AlmDes = ITEM.AlmDes
              Facdpedm.CanPed = ITEM.CanPed
              Facdpedm.codmat = ITEM.CodMat
              Facdpedm.Factor = ITEM.Factor              
              Facdpedm.FlgEst = ITEM.FlgEst
              Facdpedm.Flg_Factor  = ITEM.Flg_Factor
              Facdpedm.ImpDto = ITEM.ImpDto
              Facdpedm.ImpIgv = ITEM.ImpIgv
              Facdpedm.ImpIsc = ITEM.ImpIsc
              Facdpedm.ImpLin = ITEM.ImpLin
              Facdpedm.MrgUti = ITEM.mrgUti
              Facdpedm.PorDto = ITEM.PorDto
              Facdpedm.PorDto2 = ITEM.PorDto2
              Facdpedm.Por_Dsctos[1] = ITEM.Por_Dsctos[1]
              Facdpedm.Por_Dsctos[2] = ITEM.Por_Dsctos[2]
              Facdpedm.Por_Dsctos[3] = ITEM.Por_Dsctos[3]
              Facdpedm.PreBas    = ITEM.PreBas
              Facdpedm.PreUni    = ITEM.PreUni 
              Facdpedm.PreVta[1] = ITEM.PreVta[1] 
              Facdpedm.PreVta[2] = ITEM.PreVta[2] 
              Facdpedm.PreVta[3] = ITEM.PreVta[3]               
              Facdpedm.UndVta    = ITEM.UndVta              
              facdpedm.NroItm    = I-NITEM. 
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
  DEFINE VARIABLE X-STANDFORD AS DECIMAL NO-UNDO.
  DEFINE VARIABLE X-LINEA1    AS DECIMAL NO-UNDO.
  DEFINE VARIABLE X-OTROS     AS DECIMAL NO-UNDO.
  DEFINE VARIABLE X-AFECTO    AS DECIMAL NO-UNDO.
  DEFINE VARIABLE X-DTO1      AS DECIMAL NO-UNDO.
  DEFINE VARIABLE X-DTO2      AS DECIMAL NO-UNDO.
  
  DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
  DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.

  FIND B-CPEDM WHERE ROWID(B-CPEDM) = ROWID(Faccpedm) EXCLUSIVE-LOCK NO-ERROR.
  B-CPEDM.ImpDto = 0.
  B-CPEDM.ImpIgv = 0.
  B-CPEDM.ImpIsc = 0.
  B-CPEDM.ImpTot = 0.
  B-CPEDM.ImpExo = 0.
  B-CPEDM.Importe[1] = 0 .
  B-CPEDM.Importe[2] = 0 .
  B-CPEDM.Importe[3] = 0 .
  FOR EACH ITEM NO-LOCK:
      B-CPEDM.ImpDto = B-CPEDM.ImpDto + ITEM.ImpDto.
               F-IGV = F-IGV + ITEM.ImpIgv.
               F-ISC = F-ISC + ITEM.ImpIsc.
      B-CPEDM.ImpTot = B-CPEDM.ImpTot + ITEM.ImpLin.
      IF NOT ITEM.AftIgv THEN B-CPEDM.ImpExo = B-CPEDM.ImpExo + ITEM.ImpLin.
  END.
  B-CPEDM.ImpIgv = ROUND(F-IGV,2).
  B-CPEDM.ImpIsc = ROUND(F-ISC,2).
  B-CPEDM.ImpBrt = B-CPEDM.ImpTot - B-CPEDM.ImpIgv - B-CPEDM.ImpIsc + 
                   B-CPEDM.ImpDto .
  B-CPEDM.ImpVta = B-CPEDM.ImpBrt - B-CPEDM.ImpDto - B-CPEDM.ImpExo.

/*    
  IF B-CPEDM.PorDto > 0 THEN DO:
    B-CPEDM.ImpDto = B-CPEDM.ImpDto + ROUND(B-CPEDM.ImpTot * B-CPEDM.PorDto / 100,2).
    B-CPEDM.ImpTot = ROUND(B-CPEDM.ImpTot * (1 - B-CPEDM.PorDto / 100),2).
    B-CPEDM.ImpVta = ROUND(B-CPEDM.ImpTot / (1 + B-CPEDM.PorIgv / 100),2).
    B-CPEDM.ImpIgv = B-CPEDM.ImpTot - B-CPEDM.ImpVta.
    B-CPEDM.ImpBrt = B-CPEDM.ImpTot - B-CPEDM.ImpIgv - B-CPEDM.ImpIsc + 
                    B-CPEDM.ImpDto - B-CPEDM.ImpExo.
  END.
*/

  RELEASE B-CPEDM.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Ingreso-a-Caja-Original V-table-Win 
PROCEDURE Ingreso-a-Caja-Original :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO ON ERROR UNDO, RETURN "ADM-ERROR":
       FIND Faccorre WHERE 
            FacCorre.CodCia = s-codcia AND  
            FacCorre.CodDoc = "I/C"    AND  
            FacCorre.NroSer = s-sercja AND  
            FacCorre.CodDiv = s-coddiv EXCLUSIVE-LOCK NO-ERROR.
           
       FIND FIRST T-CcbCCaja.
       
       CREATE CcbCCaja.
       ASSIGN CcbCCaja.CodCia    = S-CodCia
              CcbCCaja.CodDiv    = S-CodDiv 
              CcbCCaja.CodDoc    = "I/C"
              CcbCCaja.NroDoc    = STRING(FacCorre.NroSer, "999") + STRING(FacCorre.Correlativo, "999999")
              FacCorre.Correlativo = FacCorre.Correlativo + 1
              CcbCCaja.CodCli     = B-PedM.codcli
              CcbCCaja.NomCli     = B-PedM.NomCli
              CcbCCaja.CodMon     = B-PedM.CodMon
              CcbCCaja.FchDoc     = TODAY
              CcbCCaja.CodBco[2]  = T-CcbCCaja.CodBco[2] 
              CcbCCaja.CodBco[3]  = T-CcbCCaja.CodBco[3] 
              CcbCCaja.CodBco[4]  = T-CcbCCaja.CodBco[4] 
              CcbCCaja.CodBco[5]  = T-CcbCCaja.CodBco[5] 
              CcbCCaja.ImpNac[1]  = T-CcbCCaja.ImpNac[1] 
              CcbCCaja.ImpNac[2]  = T-CcbCCaja.ImpNac[2] 
              CcbCCaja.ImpNac[3]  = T-CcbCCaja.ImpNac[3] 
              CcbCCaja.ImpNac[4]  = T-CcbCCaja.ImpNac[4] 
              CcbCCaja.ImpNac[5]  = T-CcbCCaja.ImpNac[5] 
              CcbCCaja.ImpNac[6]  = T-CcbCCaja.ImpNac[6] 
              CcbCCaja.ImpUsa[1]  = T-CcbCCaja.ImpUsa[1] 
              CcbCCaja.ImpUsa[2]  = T-CcbCCaja.ImpUsa[2] 
              CcbCCaja.ImpUsa[3]  = T-CcbCCaja.ImpUsa[3]
              CcbCCaja.ImpUsa[4]  = T-CcbCCaja.ImpUsa[4] 
              CcbCCaja.ImpUsa[5]  = T-CcbCCaja.ImpUsa[5] 
              CcbCCaja.ImpUsa[6]  = T-CcbCCaja.ImpUsa[6] 
              CcbCcaja.Tipo       = IF S-CODDOC = "FAC" THEN "CAFA" ELSE "CABO" 
              CcbCCaja.CodCaja    = S-CODTER
              CcbCCaja.TpoCmb     = T-CcbCCaja.TpoCmb
              CcbCCaja.usuario    = s-user-id
              CcbCCaja.Voucher[2] = T-CcbCCaja.Voucher[2]
              CcbCCaja.Voucher[3] = T-CcbCCaja.Voucher[3]
              CcbCCaja.Voucher[4] = T-CcbCCaja.Voucher[4] 
              CcbCCaja.Voucher[5] = T-CcbCCaja.Voucher[5] 
              CcbCCaja.Voucher[6] = T-CcbCCaja.Voucher[6] 
              CcbCCaja.Voucher[8] = T-CcbCCaja.Voucher[8]   /* Tarjeta de Credito */
              CcbCCaja.FchVto[2]  = T-CcbCCaja.FchVto[2]
              CcbCCaja.FchVto[3]  = T-CcbCCaja.FchVto[3]
              CcbCCaja.VueNac     = T-CcbCCaja.VueNac 
              CcbCCaja.VueUsa     = T-CcbCCaja.VueUsa
              CcbCCaja.FLGEST     = "C".
       RELEASE faccorre.
       FOR EACH T-CPEDM NO-LOCK BY T-CPEDM.NroPed ON ERROR UNDO, RETURN "ADM-ERROR":
           FIND CcbCDocu WHERE 
                CcbCDocu.CodCia = S-CodCia AND
                CcbCDocu.CodDoc = T-CPEDM.CodRef AND
                CcbCDocu.NroDoc = T-CPEDM.NroRef EXCLUSIVE-LOCK NO-ERROR. 
           IF AVAILABLE CcbCDocu THEN  DO:
              CREATE CcbDCaja.
              ASSIGN CcbDCaja.CodCia = S-CodCia
                     CcbDCaja.CodDoc = CcbCCaja.CodDoc
                     CcbDCaja.NroDoc = CcbCCaja.NroDoc
                     CcbDCaja.CodRef = CcbCDocu.CodDoc
                     CcbDCaja.NroRef = CcbCDocu.NroDoc
                     CcbDCaja.CodCli = CcbCDocu.CodCli
                     CcbDCaja.CodMon = CcbCDocu.CodMon
                     CcbDCaja.FchDoc = CcbCCaja.FchDoc
                     CcbDCaja.ImpTot = CcbCDocu.ImpTot
                     CcbDCaja.TpoCmb = CcbCCaja.TpoCmb
                     CcbCDocu.FlgEst = "C"
                     CcbCDocu.FchCan = TODAY
                     CcbCDocu.SdoAct = 0.
           END.
           RELEASE CcbCDocu.
       END.
       /* ACTUALIZAMOS EL CONTROL DE VALES DE COMPRA */
        FOR EACH T-VVALE:
            CREATE VtaVVale.
            BUFFER-COPY T-VVALE TO VtaVVale
                ASSIGN
                    VtaVVale.CodCia = s-codcia
                    VtaVVale.CodDiv = s-coddiv
                    VtaVVale.CodRef = ccbccaja.coddoc
                    VtaVVale.Fecha  = TODAY
                    VtaVVale.Hora   = STRING(TIME, 'HH:MM')
                    VtaVVale.NroRef = ccbccaja.nrodoc.
        END.
        /* ****************************************** */
       RELEASE ccbccaja.
       RELEASE ccbdcaja.
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
  NRO_PED = "".
  s-PorDto = 0.
  
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY @ faccpedm.FchPed
             Gn-Tccja.Venta @ Faccpedm.TpoCmb
             FacCfgGn.CliVar @ Faccpedm.CodCli.
     Faccpedm.NomCli:SENSITIVE = NO.
     Faccpedm.DirCli:SENSITIVE = NO.
  END.
  RUN Actualiza-Item.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  
  DO WITH FRAME {&FRAME-NAME}:
    APPLY "ENTRY" TO Faccpedm.CodCli.
    /*RETURN NO-APPLY.*/
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
     IF L-CREA THEN DO:
        RUN Numero-de-Pedido(YES).
        ASSIGN Faccpedm.CodCia = S-CODCIA
               Faccpedm.CodDoc = s-coddoc
               Faccpedm.codalm = trim(S-CodAlm)
               faccpedm.FchPed = TODAY
               Faccpedm.PorIgv = FacCfgGn.PorIgv
               Faccpedm.TpoCmb = FacCfgGn.TpoCmb[1]
               Faccpedm.NroPed = STRING(I-NroSer,"999") + STRING(I-NroPed,"999999")
               Faccpedm.CodDiv = trim(S-CODDIV)
               faccpedm.CodVen = faccpedm.CodVen:SCREEN-VALUE /* C-CODVEN*/
               Faccpedm.TipVta = "1" 
               faccpedm.Hora = STRING(TIME,"HH:MM")
               Faccpedm.Cmpbnte = Faccpedm.Cmpbnte:SCREEN-VALUE
               Faccpedm.NroCard = Faccpedm.NroCard:SCREEN-VALUE 
               Faccpedm.RucCli  = Faccpedm.RucCli:SCREEN-VALUE      
               Faccpedm.FmaPgo  = Faccpedm.FmaPgo:SCREEN-VALUE .     
        DISPLAY Faccpedm.NroPed WITH FRAME {&FRAME-NAME}.
     END.
     IF Faccpedm.FmaPgo = "001" AND Faccpedm.FlgEst = "" THEN 
        Faccpedm.FlgEst = "X".
     ELSE 
        Faccpedm.FlgEst = "P".
     ASSIGN faccpedm.Usuario = S-USER-ID.

     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
                   AND  gn-clie.CodCli = Faccpedm.CodCli
                  NO-LOCK NO-ERROR.
     
     IF AVAIL gn-clie AND Faccpedm.Cmpbnte:SCREEN-VALUE = "FAC" 
     THEN Faccpedm.RucCli = gn-clie.Ruc.
  END.
  
  RUN Genera-Pedido.    /* Detalle del pedido */ 
  RUN Graba-Totales.
  IF S-NroCot <> "" THEN RUN Actualiza-Cotizacion.
  
      
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
  IF NOT AVAILABLE faccpedm THEN RETURN "ADM-ERROR".
/*  IF LOOKUP(faccpedm.FlgEst,"C,A") > 0 THEN  RETURN "ADM-ERROR".*/
  
  S-CODMON = Faccpedm.CodMon.
  S-CODCLI = Faccpedm.CodCli.
  NRO_PED = Faccpedm.NroPed.
  L-CREA = NO.
  RUN Actualiza-Item.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  L-CREA = YES.
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY "" @ Faccpedm.NroPed
             "" @ F-Estado.
  END.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
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
    RUN valida-Delete.
    IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

    DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
      FIND B-CPEDM1 WHERE ROWID(B-CPEDM1) = ROWID(faccpedm) EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE B-CPEDM1 THEN 
         ASSIGN B-CPEDM1.FlgEst = "A".
      RELEASE B-CPEDM1.
        FOR EACH facdpedm WHERE facdpedm.codcia = faccpedm.codcia
                           AND  facdpedm.coddoc = faccpedm.coddoc
                           AND  facdpedm.nroped = faccpedm.nroped:
            Facdpedm.FlgEst = "A".
        END.
    END.
/*  
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
*/
    /* Code placed here will execute AFTER standard behavior.    */
    RUN Procesa-Handle IN lh_Handle ('browse').
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

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
  IF AVAILABLE Faccpedm THEN DO WITH FRAME {&FRAME-NAME}:
     CASE Faccpedm.FlgEst:
          WHEN "A" THEN DISPLAY " ANULADO "   @ F-Estado .
          WHEN "C" THEN DISPLAY "CANCELADO"   @ F-Estado .
          WHEN "P" THEN DISPLAY "PENDIENTE"   @ F-Estado .
          WHEN "X" THEN DISPLAY "POR APROBAR" @ F-Estado .
          WHEN "S" THEN DISPLAY "POR MODIFICAR" @ F-Estado .
     END CASE.
     IF Faccpedm.CodCli <> FacCfgGn.CliVar THEN DO:
        FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
                      AND  gn-clie.CodCli = Faccpedm.CodCli 
                     NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie  THEN DO:
           DISPLAY gn-clie.DirCli @ Faccpedm.DirCli 
/*                   gn-clie.Ruc    @ Faccpedm.RucCli*/.
        END.
     END.
     
     F-NomVen:SCREEN-VALUE = "".
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
                  AND  gn-ven.CodVen = FacCPedm.CodVen 
                 NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen:SCREEN-VALUE = gn-ven.NomVen.
     
     FIND gn-convt WHERE gn-convt.Codig = FacCPedm.FmaPgo 
                    AND  gn-ConVt.TipVta BEGINS "1"
                   NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt THEN
        F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
     ELSE
        F-CndVta:SCREEN-VALUE = "".
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
  DEF VAR RPTA AS CHAR NO-UNDO.
  
  IF faccpedm.flgest = 'A' THEN RETURN 'ADM-ERROR'.
  RUN ALM/D-CLAVE.R(FacCfgGn.Cla_Venta,OUTPUT RPTA). 
  IF RPTA = "ERROR" THEN DO:
      MESSAGE "No tiene Autorizacion Para Reimprimir"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      RETURN "ADM-ERROR".
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
/*  
  IF Faccpedm.FlgEst <> "A" THEN RUN vta\r-impvm.r(ROWID(Faccpedm)).
*/
  FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = faccpedm.codcia
    AND LOOKUP(ccbcdocu.coddoc, 'FAC,TCK') > 0
    AND ccbcdocu.codped = faccpedm.coddoc
    AND ccbcdocu.nroped = faccpedm.nroped
    NO-LOCK NO-ERROR.
  IF AVAILABLE ccbcdocu AND ccbcdocu.flgest <> 'A'
  THEN DO:
    IF ccbcdocu.coddoc = 'FAC' THEN RUN ccb/r-fact01 (ROWID(ccbcdocu)).
    IF ccbcdocu.coddoc = 'TCK'
    THEN DO:
        CASE s-codter:
        WHEN 'TERM01' OR WHEN 'TERM02' THEN RUN ccb/r-tick500 (ROWID(ccbcdocu)).
        OTHERWISE RUN ccb/r-tick01 (ROWID(ccbcdocu)).
        END CASE.
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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse'). 

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
                     AND  FacCorre.CodAlm = S-CODALM    /* OJO */
                    EXCLUSIVE-LOCK NO-ERROR.
  ELSE
      FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                     AND  FacCorre.CodDoc = S-CODDOC 
                     AND  FacCorre.CodDiv = S-CODDIV 
                     AND  FacCorre.CodAlm = S-CODALM    /* OJO */
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

    CASE HANDLE-CAMPO:name:
        WHEN "FmaPgo" THEN ASSIGN input-var-1 = "1".
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
  {src/adm/template/snd-list.i "faccpedm"}

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
DO WITH FRAME {&FRAME-NAME} :
   IF Faccpedm.CodCli:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Codio de cliente no debe ser blanco"  VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO Faccpedm.CodCli.
         RETURN "ADM-ERROR".   
   END.
   FIND gn-clie WHERE gn-clie.CodCia = cl-codcia
                 AND  gn-clie.CodCli = FacCPedm.CodCli:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-clie THEN DO:
      MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCPedm.CodCli.
      RETURN "ADM-ERROR".   
   END.
   
   /***** Valida Ingreso de Ruc. *****/
/*   IF FacCpedm.Cmpbnte:screen-value = "FAC" AND LENGTH(FacCpedm.RucCli:screen-value) <> 8 THEN DO:
 *       MESSAGE "Ruc del Cliente Mal Ingresado" VIEW-AS ALERT-BOX ERROR.
 *       APPLY "ENTRY" TO FacCPedm.RucCli.
 *       RETURN "ADM-ERROR".   
 *    END.      */

   IF Faccpedm.CodVen:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Codio de Vendedor no debe ser blanco"  VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO Faccpedm.CodVen.
         RETURN "ADM-ERROR".
   END.
   
   FOR EACH ITEM NO-LOCK: 
       F-Tot = F-Tot + ITEM.ImpLin.
   END.
   IF F-Tot = 0 THEN DO:
      MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCPedm.CodCli.
      RETURN "ADM-ERROR".   
   END.
   
   DEFINE VAR X-TOT AS DECI INIT 0.
   X-TOT = IF S-CODMON = 1 THEN F-TOT ELSE F-TOT * DECI(FaccPedm.Tpocmb:SCREEN-VALUE).
   
   IF F-Tot >= 1550 AND 
      FaccPedm.Cmpbnte:SCREEN-VALUE = "BOL" THEN DO:
      IF LENGTH(TRIM(Faccpedm.Ruccli:SCREEN-VALUE)) <> 8 THEN DO:
         MESSAGE "L.E. o D.N.I. debe tener 8 digitos, Verifique... " VIEW-AS ALERT-BOX ERROR.
         FacCPedm.RucCli:SENSITIVE = YES.
         APPLY "ENTRY" TO FacCPedm.RucCli.
         RETURN "ADM-ERROR".   
      END.
   END.
/* RHC 17-02-04 YA NO VA, AHORA ES DESCUENTO GLOBAL 
  /* Verificamos si se ha ingresado un descuento */
  DEF VAR RPTA AS CHAR INIT '' NO-UNDO.
  
  FOR EACH ITEM WHERE trim(item.codmat) ne "":
    IF ITEM.PorDto > 0 THEN RPTA = 'ERROR'.
  END.
  IF RPTA = 'ERROR'
  THEN DO:
    RUN alm/d-clave (FacCFgGn.Cla_Venta, OUTPUT RPTA).
    IF RPTA = 'ERROR' THEN RETURN 'ADM-ERROR':U.
  END.
********************************************************* */

END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-delete V-table-Win 
PROCEDURE valida-delete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT AVAILABLE faccpedm THEN RETURN "ADM-ERROR".
IF LOOKUP(faccpedm.FlgEst,"C,A") > 0 THEN  RETURN "ADM-ERROR".

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
/* no se puede modificar por errores al momento de cancelar */
/*MESSAGE "No se puede modificar, " SKIP
 *         "debe copiar el pedido" VIEW-AS ALERT-BOX ERROR.
 * RETURN "ADM-ERROR".*/

IF NOT AVAILABLE faccpedm THEN RETURN "ADM-ERROR".
IF LOOKUP(faccpedm.FlgEst,"C,A") > 0 THEN  RETURN "ADM-ERROR".
S-CODMON = Faccpedm.CodMon.
S-CODCLI = Faccpedm.CodCli.
NRO_PED = "".

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE XXXX V-table-Win 
PROCEDURE XXXX :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE X-ROWID AS ROWID.

  RUN VTA/D-INGDOC.R (OUTPUT X-ROWID). 

  IF X-ROWID <> ? THEN DO:
/*    RUN dispatch IN THIS-PROCEDURE ('add-record':U).*/

    FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
    IF AVAIL ccbcdocu THEN DO:

        RUN dispatch IN THIS-PROCEDURE ('add-record':U).

        S-CODMON = CcbCDocu.CodMon.
        S-CODCLI = CcbCDocu.CodCli.
        NRO_PED = CcbCDocu.NroPed.
        L-CREA = YES.

        DO WITH FRAME {&FRAME-NAME}:
            DISPLAY TODAY @ faccpedm.FchPed
                    FacCfgGn.TpoCmb[1] @ Faccpedm.TpoCmb
                    S-CODCLI @ Faccpedm.CodCli
                    CcbCDocu.NomCli @ Faccpedm.NomCli
                    CcbCDocu.DirCli @ Faccpedm.DirCli
                    CcbCDocu.CodVen @ Faccpedm.CodVen 
                    .
            Faccpedm.FmaPgo:SCREEN-VALUE = CcbCDocu.FmaPgo.
            Faccpedm.Cmpbnte:SCREEN-VALUE = CcbCDocu.CodDoc.
            Faccpedm.CodMon:SCREEN-VALUE = STRING(S-CODMON).
            
            Faccpedm.NomCli:SENSITIVE = NO.
            Faccpedm.DirCli:SENSITIVE = NO.
/*            Faccpedm.RucCli:SENSITIVE = NO.*/

        END.

        /**********/
        FOR EACH ITEM:
            DELETE ITEM.
        END.
        FOR EACH CcbDDocu OF ccbcdocu:
            CREATE ITEM.
            ASSIGN ITEM.CodCia = CcbDDocu.CodCia
                   ITEM.coddoc = CcbCDocu.CodPed 
                   ITEM.NroPed = CcbCDocu.NroPed
                   ITEM.FlgEst = "P"
                   ITEM.Hora   = STRING(TIME, "HH:MM:SS")
                   ITEM.FchPed = TODAY
                   ITEM.CodMat = CcbDDocu.codmat
                   ITEM.Factor = CcbDDocu.Factor
                   ITEM.ImpDto = CcbDDocu.ImpDto
                   ITEM.ImpIgv = CcbDDocu.ImpIgv
                   ITEM.ImpIsc = CcbDDocu.ImpIsc
                   ITEM.ImpLin = CcbDDocu.ImpLin
                   ITEM.AftIgv = CcbDDocu.AftIgv
                   ITEM.AftIsc = CcbDDocu.AftIsc
                   ITEM.Canped = CcbDDocu.CanDes
                   ITEM.NroItm = CcbDDocu.NroItm
                   ITEM.PorDto = CcbDDocu.PorDto
                   ITEM.PreBas = CcbDDocu.PreBas
                   ITEM.PreUni = CcbDDocu.PreUni
                   ITEM.PreVta[1] = CcbDDocu.PreVta[1]
                   ITEM.PreVta[2] = CcbDDocu.PreVta[2]
                   ITEM.PreVta[3] = CcbDDocu.PreVta[3]
                   ITEM.UndVta = CcbDDocu.UndVta
                   ITEM.AlmDes = CcbDDocu.AlmDes.
        END.
        /***********/
/*
        RUN Procesa-Handle IN lh_Handle ('Pagina2').
  */      
        DO WITH FRAME {&FRAME-NAME}:
        MESSAGE "INGRESA" VIEW-AS ALERT-BOX.
            APPLY "ENTRY" TO Faccpedm.CodCli.
            RETURN NO-APPLY.
        END.
        
          /* Dispatch standard ADM method.                             */
          RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .
          
          /* Code placed here will execute AFTER standard behavior.    */
          L-CREA = YES.
          DO WITH FRAME {&FRAME-NAME}:
             DISPLAY "" @ Faccpedm.NroPed
                     "" @ F-Estado.
          END.

        RUN Procesa-Handle IN lh_Handle ('Pagina2').
        RUN Procesa-Handle IN lh_Handle ('Browse').

    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

