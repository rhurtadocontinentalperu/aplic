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
DEFINE BUFFER B-CPEDI FOR Faccpedi.
DEFINE SHARED TEMP-TABLE ITEM NO-UNDO LIKE FacDPedm.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE CL-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE C-CODDOC   AS CHAR.
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
              NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN I-NroSer = FacCorre.NroSer
          S-PRINTER-NAME = FacCorre.Printer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

/****   Para cancelar Documentos    *****/
DEFINE VARIABLE C-MON AS CHAR NO-UNDO.
DEFINE VARIABLE C-HOR AS CHAR NO-UNDO.
DEFINE VARIABLE L-OK  AS LOGICAL NO-UNDO.
DEFINE VARIABLE X-OK  AS LOGICAL NO-UNDO.

DEFINE BUFFER B-PedM  FOR FacCPedm.
DEFINE BUFFER B-CDocu FOR CcbCDocu.
DEFINE BUFFER B-CPEDM FOR FacCPedm.
DEFINE BUFFER B-DPEDM FOR FacDPedm.

DEFINE SHARED TEMP-TABLE T-CcbDDocu LIKE CcbDDocu.
DEFINE SHARED TEMP-TABLE T-CcbCCaja LIKE CcbCCaja.

DEFINE TEMP-TABLE T-CPEDM LIKE FacCPedm
   FIELD CodRef LIKE CcbCDocu.CodRef
   FIELD NroRef LIKE CcbCDocu.NroRef.
DEFINE TEMP-TABLE T-DPEDM LIKE FacDPedm.


DEFINE SHARED VARIABLE S-PTOVTA     AS INTEGER.
DEFINE SHARED VARIABLE S-SERCJA     AS INTEGER.
DEFINE SHARED VARIABLE s-tipo       AS CHARACTER.
DEFINE SHARED VARIABLE s-codmov     LIKE Almtmovm.Codmov.
DEFINE SHARED VARIABLE s-codter     LIKE ccbcterm.codter.
DEFINE SHARED VARIABLE S-TPOCMB     AS DEC.


DEFINE VAR F-CODDOC AS CHAR NO-UNDO.
DEFINE VAR x-nrodoc LIKE CcbCDocu.NroDoc.

DEFINE BUFFER B-FacDPedm FOR FacDPedm.
/*****************************************/

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
Faccpedm.DirCli Faccpedm.RucCli Faccpedm.FmaPgo Faccpedm.CodVen ~
Faccpedm.Glosa Faccpedm.CodTrans Faccpedm.DocDesp Faccpedm.FchPed ~
Faccpedm.CodMon Faccpedm.Cmpbnte 
&Scoped-define ENABLED-TABLES Faccpedm
&Scoped-define FIRST-ENABLED-TABLE Faccpedm
&Scoped-Define ENABLED-OBJECTS v-NroSer v-NumDoc RECT-18 
&Scoped-Define DISPLAYED-FIELDS Faccpedm.NroPed Faccpedm.CodCli ~
Faccpedm.NomCli Faccpedm.DirCli Faccpedm.RucCli Faccpedm.FmaPgo ~
Faccpedm.CodVen Faccpedm.Glosa Faccpedm.CodTrans Faccpedm.DocDesp ~
Faccpedm.FchPed Faccpedm.CodMon Faccpedm.TpoCmb Faccpedm.Cmpbnte 
&Scoped-define DISPLAYED-TABLES Faccpedm
&Scoped-define FIRST-DISPLAYED-TABLE Faccpedm
&Scoped-Define DISPLAYED-OBJECTS v-NroSer v-NumDoc F-CndVta F-nomVen ~
F-Estado 

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
     SIZE 12.86 BY .69
     FONT 0 NO-UNDO.

DEFINE VARIABLE F-nomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44.29 BY .69 NO-UNDO.

DEFINE VARIABLE v-NroSer AS INTEGER FORMAT "999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .81 NO-UNDO.

DEFINE VARIABLE v-NumDoc AS INTEGER FORMAT "999999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 6.29 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87.57 BY 5.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     v-NroSer AT ROW 5.12 COL 72 COLON-ALIGNED NO-LABEL
     v-NumDoc AT ROW 5.12 COL 76.72 COLON-ALIGNED NO-LABEL
     Faccpedm.NroPed AT ROW 1.19 COL 8.57 COLON-ALIGNED
          LABEL "Pedido" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 15.86 BY .69
          FONT 0
     Faccpedm.CodCli AT ROW 1.88 COL 8.57 COLON-ALIGNED HELP
          ""
          LABEL "Cliente" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     Faccpedm.NomCli AT ROW 1.92 COL 20.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 41.14 BY .69
     Faccpedm.DirCli AT ROW 2.58 COL 8.57 COLON-ALIGNED
          LABEL "Direccion"
          VIEW-AS FILL-IN 
          SIZE 34.86 BY .69
     Faccpedm.RucCli AT ROW 2.58 COL 50 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 15.43 BY .69
     Faccpedm.FmaPgo AT ROW 3.31 COL 3.43
          LABEL "Cond.Vta"
          VIEW-AS COMBO-BOX INNER-LINES 3
          LIST-ITEMS "000","001","002" 
          DROP-DOWN-LIST
          SIZE 6.86 BY 1
     Faccpedm.CodVen AT ROW 4.15 COL 8.57 COLON-ALIGNED FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 6.29 BY .69
     Faccpedm.Glosa AT ROW 4.85 COL 5.85
          LABEL "Glosa"
          VIEW-AS FILL-IN 
          SIZE 52.43 BY .69
     Faccpedm.CodTrans AT ROW 5.62 COL 45.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .69
     Faccpedm.DocDesp AT ROW 5.54 COL 8.57 COLON-ALIGNED NO-LABEL
          VIEW-AS COMBO-BOX INNER-LINES 3
          LIST-ITEMS "NORMAL","GUIA" 
          DROP-DOWN-LIST
          SIZE 11.29 BY 1
     F-CndVta AT ROW 3.31 COL 16.43 COLON-ALIGNED NO-LABEL
     F-nomVen AT ROW 4.15 COL 16.43 COLON-ALIGNED NO-LABEL
     F-Estado AT ROW 1.19 COL 72.72 COLON-ALIGNED NO-LABEL
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
     Faccpedm.Cmpbnte AT ROW 5.12 COL 64.72 COLON-ALIGNED NO-LABEL
          VIEW-AS COMBO-BOX INNER-LINES 2
          LIST-ITEMS "FAC","BOL" 
          DROP-DOWN-LIST
          SIZE 6.72 BY 1
     "Transportista :" VIEW-AS TEXT
          SIZE 9.86 BY .5 AT ROW 5.58 COL 37.72
     "Comprobante" VIEW-AS TEXT
          SIZE 9.43 BY .5 AT ROW 4.5 COL 67.43
     "Despacho :" VIEW-AS TEXT
          SIZE 7.86 BY .5 AT ROW 5.5 COL 2.86
     "Moneda :" VIEW-AS TEXT
          SIZE 6.29 BY .5 AT ROW 2.62 COL 69.29
     RECT-18 AT ROW 1 COL 1
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
         HEIGHT             = 6.27
         WIDTH              = 87.86.
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
/* SETTINGS FOR FILL-IN Faccpedm.CodTrans IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Faccpedm.CodVen IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN Faccpedm.DirCli IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX Faccpedm.DocDesp IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-nomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX Faccpedm.FmaPgo IN FRAME F-Main
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN Faccpedm.Glosa IN FRAME F-Main
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN Faccpedm.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN Faccpedm.RucCli IN FRAME F-Main
   EXP-FORMAT                                                           */
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
  IF SELF:SCREEN-VALUE = "" THEN DO: /*RETURN.*/
       MESSAGE "Ingrese codigo de Cliente" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
  END.
  
/*  IF LENGTH(TRIM(SELF:SCREEN-VALUE)) < 9 THEN DO:
 *        MESSAGE "Codigo de Cliente debe de ser de 9 digitos" VIEW-AS ALERT-BOX ERROR.
 *        RETURN NO-APPLY.
 *   END.*/
  
  FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                AND  gn-clie.CodCli = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie  THEN DO:
     S-CODCLI = SELF:SCREEN-VALUE.
     RUN VTA\D-RegCli.R (INPUT-OUTPUT S-CODCLI).
     IF S-CODCLI = "" THEN DO:
         APPLY "ENTRY" TO Faccpedm.CodCli.
         RETURN NO-APPLY.
     END.
     FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                   AND  gn-clie.CodCli = S-CODCLI 
                  NO-LOCK NO-ERROR.
  END.
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY gn-clie.CodCli @ Faccpedm.CodCli.
     FacCPedm.FmaPgo:SCREEN-VALUE = "000" .
     IF Faccpedm.NomCli:SCREEN-VALUE = "" THEN DISPLAY gn-clie.NomCli @ Faccpedm.NomCli.
     IF Faccpedm.RucCli:SCREEN-VALUE = "" THEN DISPLAY gn-clie.Ruc    @ Faccpedm.RucCli.
     IF Faccpedm.DirCli:SCREEN-VALUE = "" THEN DISPLAY gn-clie.DirCli @ Faccpedm.DirCli.
     IF gn-clie.Ruc = "" THEN DO: 
        Faccpedm.Cmpbnte:SCREEN-VALUE  = "BOL".
/*        Faccpedm.Cmpbnte:SENSITIVE  = YES.*/
     END.
     ELSE DO:
/*        Faccpedm.Cmpbnte:SENSITIVE = YES.*/
        Faccpedm.Cmpbnte:SCREEN-VALUE = "FAC".
     END.

     S-CNDVTA = gn-clie.CndVta.
     
     S-CODCLI = gn-clie.CodCli.
     C-CodVen = S-CODVEN.
     F-NomVen = "".
     IF C-CodVen = "" THEN C-CodVen = S-CODVEN.
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
                  AND  gn-ven.CodVen = C-CodVen 
                 NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
     DISPLAY gn-clie.CodVen @ FacCPedm.CodVen
             F-NomVen.
     IF gn-clie.CodCli <> FacCfgGn.CliVar THEN DO:
         Faccpedm.NomCli:SENSITIVE = NO.
         Faccpedm.DirCli:SENSITIVE = NO.
         Faccpedm.RucCli:SENSITIVE = NO.
         APPLY "ENTRY" TO Faccpedm.FmaPgo.
         RETURN NO-APPLY.
     END.   
     ELSE DO: 
         Faccpedm.NomCli:SENSITIVE = YES.
         Faccpedm.DirCli:SENSITIVE = YES.
         Faccpedm.RucCli:SENSITIVE = YES. 
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


&Scoped-define SELF-NAME Faccpedm.RucCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Faccpedm.RucCli V-table-Win
ON LEAVE OF Faccpedm.RucCli IN FRAME F-Main /* Ruc */
DO:
  DO WITH FRAME {&FRAME-NAME}:
     IF Faccpedm.RucCli:SCREEN-VALUE = "" THEN DO:
        Faccpedm.Cmpbnte:SCREEN-VALUE = "BOL".
     END.
     ELSE DO:
        Faccpedm.Cmpbnte:SCREEN-VALUE = "FAC".
     END.
  END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Faccpedm.TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Faccpedm.TpoCmb V-table-Win
ON LEAVE OF Faccpedm.TpoCmb IN FRAME F-Main /* Tipo de cambio */
DO:
  
    S-TPOCMB = DEC(Faccpedm.TpoCmb:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-NumDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-NumDoc V-table-Win
ON LEAVE OF v-NumDoc IN FRAME F-Main
DO:



     IF integer(v-NroSer:screen-value) = 0 THEN DO:
      MESSAGE "Serie 000 no válido" skip
      "Reingrese la Serie"
       VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO v-NroSer.
      RETURN "ADM-ERROR".   
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Cotizacion V-table-Win 
PROCEDURE Actualiza-Cotizacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE I-NRO AS INTEGER INIT 0 NO-UNDO.
  DEFINE BUFFER B-DPedi FOR FacDPedi.
  FOR EACH facdPedi OF faccPedi NO-LOCK:
      FIND B-DPedi WHERE B-DPedi.CodCia = faccPedi.CodCia 
                    AND  B-DPedi.CodDoc = "COT" 
                    AND  B-DPedi.NroPed = S-NroCot 
                    AND  B-DPedi.CodMat = FacDPedi.CodMat EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE B-DPedi THEN DO:
         B-DPedi.CanAte = B-DPedi.CanAte + FacDPedi.CanPed.
      END.
      RELEASE B-DPedi.
  END.
  FOR EACH FacDPedi NO-LOCK WHERE FacDPedi.CodCia = S-CODCIA 
                             AND  FacDPedi.CodDoc = "COT" 
                             AND  FacDPedi.NroPed = S-NroCot:
      IF (FacDPedi.CanPed - FacDPedi.CanAte) > 0 THEN DO:
         I-NRO = 1.
         LEAVE.
      END.
  END.
  IF I-NRO = 0 THEN DO TRANSACTION:
     FIND B-CPedi WHERE B-CPedi.CodCia = S-CODCIA 
                   AND  B-CPedi.CodDiv = S-CODDIV 
                   AND  B-CPedi.CodDoc = "COT" 
                   AND  B-CPedi.NroPed = S-NroCot 
                  EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE B-CPedi THEN ASSIGN B-CPedi.FlgEst = "C".
     RELEASE B-CPedi.
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
FOR EACH ITEM:
    DELETE ITEM.
END.
IF NOT L-CREA THEN DO:
   FOR EACH facdpedm OF faccpedm NO-LOCK:
       CREATE ITEM.
       ASSIGN ITEM.CodCia = facdpedm.CodCia 
              ITEM.codmat = facdpedm.codmat 
              ITEM.Factor = facdpedm.Factor 
              ITEM.CanPed = facdpedm.CanPed 
              ITEM.ImpDto = facdpedm.ImpDto 
              ITEM.ImpLin = facdpedm.ImpLin 
              ITEM.NroItm = facdpedm.NroItm 
              ITEM.PorDto = facdpedm.PorDto 
              ITEM.PreUni = facdpedm.PreUni 
              ITEM.UndVta = facdpedm.UndVta
              ITEM.AftIgv = Facdpedm.AftIgv 
              ITEM.AftIsc = Facdpedm.AftIsc 
              ITEM.ImpDto = Facdpedm.ImpDto 
              ITEM.ImpIgv = Facdpedm.ImpIgv 
              ITEM.ImpIsc = Facdpedm.ImpIsc 
              ITEM.PreBas = Facdpedm.PreBas
              ITEM.AlmDes = Facdpedm.AlmDes.
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
   IF NOT FacCPedm.CodCli:SENSITIVE THEN RETURN "ADM-ERROR".
   S-NroCot = "".
   input-var-1 = "COT".
   input-var-2 = FacCPedm.CodCli:SCREEN-VALUE.
   RUN lkup\C-Pedcot.r("Cotizaciones Pendientes").
   IF output-var-1 = ? THEN RETURN "ADM-ERROR".
   RUN Actualiza-Item.
   S-NroCot = output-var-2.
   FIND B-CPedi WHERE B-CPedi.CodCia = S-CODCIA 
                 AND  B-CPedi.CodDiv = S-CODDIV 
                 AND  B-CPedi.CodDoc = "COT" 
                 AND  B-CPedi.NroPed = s-NroCot 
                NO-LOCK NO-ERROR.
   F-NomVen = "".
   FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
                AND  gn-ven.CodVen = B-CPedi.CodVen 
               NO-LOCK NO-ERROR.
   IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
   
   
   DISPLAY B-CPedi.CodVen @ FaccPedm.CodVen
           F-NomVen. 
  
   Faccpedm.Cmpbnte:SCREEN-VALUE = ENTRY(INTEGER(B-CPedi.TipVta),Faccpedm.Cmpbnte:LIST-ITEMS).
   FaccPedm.CodMon:SCREEN-VALUE = STRING(B-CPedi.CodMon).
   /* DETALLES */
   FOR EACH FacDPedi NO-LOCK WHERE FacDPedi.CodCia = S-CODCIA 
                              AND  FacDPedi.CodDoc = "COT" 
                              AND  FacDPedi.NroPed = S-NroCot 
                              AND  (FacDPedi.CanPed - FacDPedi.CanAte) > 0:
       F-CANPED = (FacDPedi.CanPed - FacDPedi.CanAte).
       RUN vta/stkdispo (s-codcia, s-codalm, facdPedi.codmat, facdPedi.Factor * F-CANPED ,
                         OUTPUT S-OK, OUTPUT S-STKDIS).
       IF NOT S-OK THEN F-CANPED = S-STKDIS.
       IF F-CANPED > 0 THEN DO:
          CREATE ITEM.
          ASSIGN ITEM.CodCia = facdPedi.CodCia 
                 ITEM.codmat = facdPedi.codmat 
                 ITEM.UndVta = facdPedi.UndVta
                 ITEM.Factor = facdPedi.Factor 
                 ITEM.NroItm = facdPedi.NroItm 
                 ITEM.CanPed = F-CANPED 
                 ITEM.PreBas = FacdPedi.PreBas
                 ITEM.PreUni = facdPedi.PreUni 
                 ITEM.PorDto = facdPedi.PorDto 
                 ITEM.AftIgv = FacdPedi.AftIgv 
                 ITEM.AftIsc = FacdPedi.AftIsc 
                 ITEM.ImpIgv = FacdPedi.ImpIgv 
                 ITEM.ImpIsc = FacdPedi.ImpIsc 
                 ITEM.ImpDto = facdPedi.ImpDto 
                 ITEM.ImpLin = facdPedi.ImpLin.
          IF ITEM.CanPed <> facdPedi.CanPed THEN DO:
             FIND Almmmatg WHERE Almmmatg.CodCia = ITEM.CodCia 
                            AND  Almmmatg.codmat = ITEM.codmat 
                           NO-LOCK NO-ERROR.
             ITEM.ImpDto = ROUND( ITEM.PreUni * (ITEM.PorDto / 100) * ITEM.CanPed , 2 ).
             ITEM.ImpLin = ROUND( ITEM.PreUni * ITEM.CanPed , 2 ) - ITEM.ImpDto.
             IF ITEM.AftIsc THEN 
                ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
             IF ITEM.AftIgv THEN  
                ITEM.ImpIgv = ITEM.ImpLin - ROUND(ITEM.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
          END.
       END.
   END.
   FacCPedm.CodCli:SENSITIVE = NO.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Copia V-table-Win 
PROCEDURE Borra-Copia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* EN EL CASO QUE ESTEMOS COPIANDO, borramos los datos del registro copiado */
/*  FIND B-CPEDM WHERE B-CPEDM.codcia = S-CODCIA 
 *                 AND  B-CPEDM.coddoc = S-CODDOC 
 *                 AND  B-CPEDM.nroped = NRO_PED.
 *   IF AVAILABLE B-CPEDM THEN DO:
 *      FOR EACH facdpedm WHERE facdpedm.codcia = B-CPEDM.codcia 
 *                         AND  facdpedm.coddoc = B-CPEDM.coddoc 
 *                         AND  facdpedm.nroped = B-CPEDM.nroped.
 *          DELETE facdpedm.
 *      END.
 *      DELETE B-CPEDM.
 *   END.
 *   RELEASE B-CPEDM.*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cancelar-pedido V-table-Win 
PROCEDURE Cancelar-pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i       AS INTEGER INITIAL 1 NO-UNDO.
  DEFINE VARIABLE D-ROWID AS ROWID NO-UNDO.
  DEFINE VARIABLE g-CodDoc AS CHAR NO-UNDO.
  
  g-CodDoc = s-CodDoc.      /* Para no perder el valor */
  
  D-ROWID = ROWID(faccpedm).
  FIND B-PedM WHERE ROWID(B-PedM) = D-ROWID NO-LOCK NO-ERROR. 
  
  /**** SOLO CONTADO Y CONTADO ANTICIPADO GENERAN INGRESO A CAJA ****/
  
/*  IF LOOKUP(B-PedM.FmaPgo,"000,002") > 0 THEN 
 *        RUN ccb\Canc_Ped ( D-ROWID, OUTPUT L-OK).
 *   ELSE L-OK = YES.
 *   
 *   IF L-OK = NO THEN RETURN "ADM-ERROR".*/
  
  S-CODDOC = B-PedM.Cmpbnte.        /* Cuidado con esto */
  
  RUN Crea-Temporal.
  
  DO TRANSACTION ON ERROR UNDO, RETURN ERROR:
     FIND B-PedM WHERE ROWID(B-PedM) = D-ROWID EXCLUSIVE-LOCK . 
     FOR EACH T-CPEDM:
         S-CodAlm = T-CPEDM.CodAlm.   /* << OJO << lo tomamos del pedido */
         CREATE CcbCDocu.
/*         FIND faccorre WHERE 
 *               faccorre.codcia = s-codcia AND  
 *               faccorre.coddoc = s-coddoc AND  
 *               faccorre.NroSer = s-ptovta EXCLUSIVE-LOCK NO-ERROR.
 *          IF AVAILABLE faccorre THEN 
 *             ASSIGN ccbcdocu.nrodoc = STRING(faccorre.nroser, "999") + STRING(FacCorre.Correlativo, "999999")
 *                    faccorre.correlativo = faccorre.correlativo + 1.
 *          RELEASE faccorre.*/

         ASSIGN ccbcdocu.nrodoc = x-nrodoc.
         ASSIGN T-CPEDM.CodRef    = S-CodDoc
                T-CPEDM.NroRef    = ccbcdocu.nrodoc
                CcbCDocu.CodCia   = S-CodCia
                CcbCDocu.CodDoc   = S-CodDoc
                CcbCDocu.FchDoc   = T-CPEDM.FchPed /*TODAY*/
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
                CcbCDocu.FchCan   = T-CPEDM.FchPed /*TODAY*/
                CcbCDocu.FchVto   = T-CPEDM.FchPed /*TODAY*/
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
                CcbCDocu.Glosa    = T-CPEDM.Glosa.
                
                /* POR AHORA GRABAMOS EL TIPO DE ENTREGA */
                CcbCDocu.CodAge   = T-CPEDM.CodTrans.
                CcbCDocu.FlgSit   = IF T-CPEDM.DocDesp = "GUIA" THEN "G" ELSE "".
                CcbCDocu.FlgCon   = IF T-CPEDM.DocDesp = "GUIA" THEN "G" ELSE "".
                IF B-PedM.FmaPgo  = "001" THEN CcbCDocu.FlgCon = "E".
                IF B-PedM.FmaPgo  = "002" THEN CcbCDocu.FlgCon = "A".
         /* actualizamos el detalle */
         FOR EACH T-DPEDM OF T-CPEDM BY nroitm:
             CREATE ccbDDocu.
             ASSIGN CcbDDocu.CodCia = ccbcdocu.codcia
                    CcbDDocu.CodDoc = ccbcdocu.coddoc
                    CcbDDocu.NroDoc = ccbcdocu.nrodoc
                    CcbDDocu.CodDiv = ccbcdocu.CodDiv
                    CcbDDocu.Fchdoc = ccbcdocu.Fchdoc
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
             i = i + 1.
         END.
     END.
     /**** ACTUALIZAMOS FLAG DEL PEDIDO  DE MOSTRADOR COMO ATENDIDO ****/
     ASSIGN  B-PedM.flgest = "C".
     /****  Add by C.Q. 09/03/2000  *****/
/*     FOR EACH B-DPEDM OF B-PedM:
 *         B-DPEDM.FlgEst = "C".
 *      END.*/
     /***********************************/

     /**** SOLO CONTADO Y CONTADO ANTICIPADO GENERAN INGRESO A CAJA ****/
     IF LOOKUP(B-PedM.FmaPgo,"000,002") > 0 THEN DO:
        /* Cancelacion del documento */
        RUN Ingreso-a-Caja.
        /* Generar Asignacion de Nota de Credito */
        IF T-CcbCCaja.Voucher[6] <> ' ' AND
           (T-CcbCCaja.ImpNac[6] + T-CcbCCaja.ImpUsa[6]) > 0 THEN 
           RUN Cancelar_Documento.
     END.
     /**** SOLO CONTADO Y CONTRA ENTREGA DESCARGAN DEL ALMACEN ****/
     IF LOOKUP(B-PedM.FmaPgo,"000,001") > 0 THEN RUN Descarga-de-Almacen.
     IF LOOKUP(B-PedM.FmaPgo,"002") > 0 THEN RUN Genera-Orden-Despacho.
  END.
  RELEASE B-PedM.
  
  /**** IMPRIMIMOS LAS FACTURAS O BOLETAS Y SUS ORDENES DE DESPACHO ****/
/*  FOR EACH T-CPEDM NO-LOCK 
 *            BY T-CPEDM.NroPed ON ERROR UNDO, RETURN "ADM-ERROR":
 *       FIND CcbCDocu WHERE 
 *            CcbCDocu.CodCia = S-CodCia AND
 *            CcbCDocu.CodDoc = T-CPEDM.CodRef AND
 *            CcbCDocu.NroDoc = T-CPEDM.NroRef EXCLUSIVE-LOCK NO-ERROR. 
 *       IF AVAILABLE CcbCDocu THEN  DO:
 *          IF Ccbcdocu.CodDoc = "FAC" THEN RUN ccb/r-fact01 (ROWID(ccbcdocu)).
 *          IF Ccbcdocu.CodDoc = "BOL" THEN RUN ccb/r-bole01 (ROWID(ccbcdocu)).
 *          RUN ccb/r-odesp  (ROWID(ccbcdocu)).
 *       END.
 *   END.*/

  s-CodDoc = g-CodDoc.      /* Volvemos a recuperar el valor */

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
  RUN Cancelar_Nota_Credito ( s-CodCia, CcbDCaja.CodDoc, CcbDCaja.NroDoc, CcbDCaja.CodMon,
                              CcbDCaja.TpoCmb, CcbDCaja.ImpTot, FALSE ).    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cancelar_nota_credito V-table-Win 
PROCEDURE Cancelar_nota_credito :
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
  DEFINE VARIABLE L-NewPed AS LOGICAL INIT YES NO-UNDO.
  DEFINE VARIABLE I-NPED   AS INTEGER INIT 0.
  DEFINE VARIABLE I-NItem  AS INTEGER INIT 0.
  FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
  
  FOR EACH b-FacDPedm WHERE b-FacDPedm.CODCIA = FacCPedm.CODCIA 
                       AND  b-FacDPedm.CODDOC = FacCPedm.CODDOC
                       AND  b-FacDPedm.NROPED = FacCPedm.NROPED
/*                       OF FacCPedm */
                      BREAK BY b-FacDPedm.CodCia
                            BY b-FacDPedm.AlmDes : 
      IF FIRST-OF(b-FacDPedm.AlmDes) OR L-NewPed THEN DO:
         I-NPED = I-NPED + 1.
         CREATE T-CPEDM.
         ASSIGN T-CPEDM.NroPed   = SUBSTRING(FacCPedm.NroPed,1,3) + STRING(I-NPED,"999999")
                T-CPEDM.CodAlm   = b-FacDPedm.AlmDes
                T-CPEDM.Cmpbnte  = Faccpedm.Cmpbnte 
/*                T-CPEDM.CodAlm   = Faccpedm.CodAlm*/      /**** MOD BY C.Q 03/03/2000 ****/
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
                T-CPEDM.ImpBrt   = 0
                T-CPEDM.ImpDto   = 0
                T-CPEDM.ImpExo   = 0
                T-CPEDM.ImpIgv   = 0
                T-CPEDM.ImpIsc   = 0
                T-CPEDM.ImpTot   = 0
                T-CPEDM.ImpVta   = 0.
         F-IGV = 0.
         F-ISC = 0.
         L-NewPed = NO.
         I-NItem = 0.
      END.
      T-CPEDM.ImpDto = T-CPEDM.ImpDto + b-FacDPedm.ImpDto.
               F-IGV = F-IGV + b-FacDPedm.ImpIgv.
               F-ISC = F-ISC + b-FacDPedm.ImpIsc.
      T-CPEDM.ImpTot = T-CPEDM.ImpTot + b-FacDPedm.ImpLin.
      IF NOT b-FacDPedm.AftIgv THEN T-CPEDM.ImpExo = T-CPEDM.ImpExo + b-FacDPedm.ImpLin.
      CREATE T-DPEDM.
      RAW-TRANSFER b-FacDPedm TO T-DPEDM.
      ASSIGN T-DPEDM.NroPed = T-CPEDM.NroPed.
      I-NItem = I-NItem + 1.
      IF ( T-CPEDM.Cmpbnte = "BOL" AND I-NItem >= FacCfgGn.Items_Boleta ) OR 
         ( T-CPEDM.Cmpbnte = "FAC" AND I-NItem >= FacCfgGn.Items_Factura ) THEN DO:
         L-NewPed = YES.
      END.
      IF LAST-OF(b-FacDPedm.AlmDes) OR L-NewPed THEN DO:
         L-NewPed = YES.    /****   ADD BY C.Q. 03/03/2000  ****/
         ASSIGN T-CPEDM.ImpIgv = ROUND(F-IGV,2).
                T-CPEDM.ImpIsc = ROUND(F-ISC,2).
                T-CPEDM.ImpBrt = T-CPEDM.ImpTot - T-CPEDM.ImpIgv - T-CPEDM.ImpIsc + 
                                 T-CPEDM.ImpDto - T-CPEDM.ImpExo.
                T-CPEDM.ImpVta = T-CPEDM.ImpBrt - T-CPEDM.ImpDto.

   /****    ADD BY C.Q. 03/03/2000  ****/
   /*** DESCUENTO GLOBAL ****/
   IF T-CPEDM.PorDto > 0 THEN DO:
      T-CPEDM.ImpDto = T-CPEDM.ImpDto + ROUND(T-CPEDM.ImpTot * T-CPEDM.PorDto / 100,2).
      T-CPEDM.ImpTot = ROUND(T-CPEDM.ImpTot * (1 - T-CPEDM.PorDto / 100),2).
      T-CPEDM.ImpVta = ROUND(T-CPEDM.ImpTot / (1 + T-CPEDM.PorIgv / 100),2).
      T-CPEDM.ImpIgv = T-CPEDM.ImpTot - T-CPEDM.ImpVta.
      T-CPEDM.ImpBrt = T-CPEDM.ImpTot - T-CPEDM.ImpIgv - T-CPEDM.ImpIsc + 
                       T-CPEDM.ImpDto - T-CPEDM.ImpExo.
   END.

      END.
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
            CcbCDocu.NroDoc = T-CPEDM.NroRef EXCLUSIVE-LOCK NO-ERROR. 
       IF AVAILABLE CcbCDocu THEN  DO:
          /* Correlativo de Salida */
          FIND Almacen WHERE 
               Almacen.CodCia = CcbCDocu.CodCia AND  
               Almacen.CodAlm = CcbCDocu.CodAlm  EXCLUSIVE-LOCK NO-ERROR.
          CREATE Almcmov.
          ASSIGN Almcmov.CodCia  = CcbCDocu.CodCia
                 Almcmov.CodAlm  = CcbCDocu.CodAlm
                 Almcmov.TipMov  = "S"
                 Almcmov.CodMov  = CcbCDocu.CodMov
                 Almcmov.NroSer  = S-PtoVta
                 Almcmov.NroDoc  = Almacen.CorrSal
                 Almcmov.CodRef  = CcbCDocu.CodDoc
                 Almcmov.NroRef  = CcbCDocu.NroDoc
                 Almcmov.NroRf1  = SUBSTRING(CcbCDocu.CodDoc,1,1) + CcbCDocu.NroDoc
                 Almcmov.NroRf2  = CcbCDocu.NroPed
                 Almcmov.Nomref  = CcbCDocu.NomCli
                 Almcmov.FchDoc  = CcbCDocu.FchDoc /*TODAY*/
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
                     Almdmov.CodAlm = AlmCmov.CodAlm
                     Almdmov.TipMov = AlmCmov.TipMov
                     Almdmov.CodMov = AlmCmov.CodMov
                     Almdmov.NroSer = Almcmov.NroSer
                     Almdmov.NroDoc = Almcmov.NroDoc
                     Almdmov.FchDoc = Almcmov.FchDoc
                     Almdmov.NroItm = i
                     Almdmov.codmat = ccbddocu.codmat
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
              RUN alm/almdgstk (ROWID(almdmov)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Orden-Despacho V-table-Win 
PROCEDURE Genera-Orden-Despacho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR I-Nroped AS INTEGER NO-UNDO.
  DEF VAR i AS INTEGER INITIAL 1 NO-UNDO.
  F-CODDOC = 'O/D'.
  FOR EACH T-CPEDM NO-LOCK BY T-CPEDM.NroPed ON ERROR UNDO, RETURN "ADM-ERROR":
      FIND CcbCDocu WHERE CcbCDocu.CodCia = S-CodCia 
                     AND  CcbCDocu.CodDoc = T-CPEDM.CodRef 
                     AND  CcbCDocu.NroDoc = T-CPEDM.NroRef 
                    EXCLUSIVE-LOCK NO-ERROR. 
      IF AVAILABLE CcbCDocu THEN  DO:
         FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                              AND  FacCorre.CodDoc = F-CODDOC 
                              AND  FacCorre.CodDiv = S-CODDIV 
/*                              AND  Faccorre.NroSer = s-ptovta */ /* Mod. by C.Q. 04/04/2000 */
                             EXCLUSIVE-LOCK NO-ERROR.
         IF AVAILABLE FacCorre THEN DO:
           I-NroPed = FacCorre.Correlativo.
           CREATE FacCPedi.
           ASSIGN FacCPedi.CodCia = S-CodCia
                  FacCPedi.CodDoc = F-CodDoc
                  FacCPedi.NroPed = STRING(s-ptovta,"999") + STRING(I-NroPed,"999999")
                  FacCorre.Correlativo = FacCorre.Correlativo + 1.
         END.
         RELEASE FacCorre.
         ASSIGN FacCPedi.FchPed = CcbCDocu.FchDoc
                FacCPedi.CodAlm = CcbCDocu.CodAlm
                FacCPedi.PorIgv = CcbCDocu.PorIgv 
                FacCPedi.TpoCmb = CcbCDocu.TpoCmb
                FacCPedi.CodDiv = CcbCDocu.CodDiv
                FacCPedi.Nroref = CcbCDocu.NroPed
                FacCPedi.Tpoped = 'MOSTRADOR'
                FacCPedi.Hora   = STRING(TIME,"HH:MM")
                FacCPedi.TipVta = CcbCDocu.Tipvta
                FacCPedi.Codcli = CcbCDocu.Codcli
                FacCPedi.NomCli = CcbCDocu.Nomcli
                FacCPedi.DirCli = CcbCDocu.DirCli
                FacCPedi.Codven = CcbCDocu.Codven
                FacCPedi.Fmapgo = CcbCDocu.Fmapgo
                FacCPedi.Glosa  = CcbCDocu.Glosa
                FacCPedi.LugEnt = CcbCDocu.Lugent
                FacCPedi.ImpBrt = CcbCDocu.ImpBrt
                FacCPedi.ImpDto = CcbCDocu.ImpDto
                FacCPedi.ImpVta = CcbCDocu.ImpVta
                FacCPedi.ImpExo = CcbCDocu.ImpExo
                FacCPedi.ImpIgv = CcbCDocu.ImpIgv
                FacCPedi.ImpIsc = CcbCDocu.ImpIsc
                FacCPedi.ImpTot = CcbCDocu.ImpTot
                FacCPedi.Flgest = 'F'
                FacCPedi.Cmpbnte  = CcbCDocu.CodDoc
                FacCPedi.NCmpbnte = CcbCDocu.Nrodoc
                FacCPedi.CodTrans = CcbCDocu.CodAge
                FacCPedi.Usuario  = S-USER-ID.
         FOR EACH CcbDDocu OF CcbCDocu BY NroItm:
             CREATE FacDPedi. 
             ASSIGN FacDPedi.CodCia = FacCPedi.CodCia 
                    FacDPedi.coddoc = FacCPedi.coddoc 
                    FacDPedi.NroPed = FacCPedi.NroPed 
                    FacDPedi.FchPed = FacCPedi.FchPed
                    FacDPedi.Hora   = FacCPedi.Hora 
                    FacDPedi.FlgEst = FacCPedi.FlgEst
                    FacDPedi.codmat = CcbDDocu.codmat 
                    FacDPedi.Factor = CcbDDocu.Factor 
                    FacDPedi.CanPed = CcbDDocu.CanDes
                    FacDPedi.ImpDto = CcbDDocu.ImpDto 
                    FacDPedi.ImpLin = CcbDDocu.ImpLin 
                    FacDPedi.PorDto = CcbDDocu.PorDto 
                    FacDPedi.PorDto2 = CcbDDocu.PorDto2 
                    FacDPedi.PreUni = CcbDDocu.PreUni 
                    FacDPedi.UndVta = CcbDDocu.UndVta 
                    FacDPedi.AftIgv = CcbDDocu.AftIgv 
                    FacDPedi.AftIsc = CcbDDocu.AftIsc 
                    FacDPedi.ImpIgv = CcbDDocu.ImpIgv 
                    FacDPedi.ImpIsc = CcbDDocu.ImpIsc 
                    FacDPedi.PreBas = CcbDDocu.PreBas
                    FacDPedi.Por_Dsctos[1] = CcbDDocu.Por_Dsctos[1]
                    FacDPedi.Por_Dsctos[2] = CcbDDocu.Por_Dsctos[2]
                    FacDPedi.Por_Dsctos[3] = CcbDDocu.Por_Dsctos[3]
                    FacDPedi.Flg_factor = CcbDDocu.Flg_factor
                    .
         END.
         ASSIGN CcbCDocu.CodRef = FacCPedi.CodDoc
                CcbCDocu.NroRef = FacCPedi.NroPed.
      END.
      RELEASE CcbCDocu.
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
   FOR EACH ITEM NO-LOCK BY ITEM.NroItm: 
       I-NITEM = I-NITEM + 1.
       CREATE facdpedm. 
       RAW-TRANSFER ITEM TO facdpedm.
       ASSIGN facdpedm.CodCia = faccpedm.CodCia 
              facdpedm.coddoc = faccpedm.coddoc 
              facdpedm.NroPed = faccpedm.NroPed 
              Facdpedm.FlgEst = Faccpedm.FlgEst
              Facdpedm.Hora   = Faccpedm.Hora
              FacDPedm.FchPed = FacCPedm.FchPed
              facdpedm.NroItm = I-NITEM. 
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
   DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
   DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.
   FIND B-CPEDM WHERE ROWID(B-CPEDM) = ROWID(Faccpedm) EXCLUSIVE-LOCK NO-ERROR.
   B-CPEDM.ImpDto = 0.
   B-CPEDM.ImpIgv = 0.
   B-CPEDM.ImpIsc = 0.
   B-CPEDM.ImpTot = 0.
   B-CPEDM.ImpExo = 0.
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
                    B-CPEDM.ImpDto - B-CPEDM.ImpExo.
   B-CPEDM.ImpVta = B-CPEDM.ImpBrt - B-CPEDM.ImpDto.
   RELEASE B-CPEDM.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Ingreso-a-Caja V-table-Win 
PROCEDURE Ingreso-a-Caja :
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
              CcbCCaja.FchDoc     = B-PedM.FchPed /*TODAY*/
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
                     CcbCDocu.FchCan = CcbCDocu.FchCan /*TODAY*/
                     CcbCDocu.SdoAct = 0.
           END.
           RELEASE CcbCDocu.
       END.
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
  S-IMPTOT = 0.
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY @ faccpedm.FchPed
             FacCfgGn.TpoCmb[1] @ Faccpedm.TpoCmb
             FacCfgGn.CliVar @ Faccpedm.CodCli.
     Faccpedm.NomCli:SENSITIVE = NO.
     Faccpedm.DirCli:SENSITIVE = NO.
     Faccpedm.RucCli:SENSITIVE = NO.
  END.
  RUN Actualiza-Item.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  
  DO WITH FRAME {&FRAME-NAME}:
    APPLY "ENTRY" TO Faccpedm.CodCli.
    RETURN NO-APPLY.
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
               Faccpedm.codalm = S-CodAlm
/*               faccpedm.FchPed = TODAY*/
               Faccpedm.PorIgv = FacCfgGn.PorIgv
               Faccpedm.TpoCmb = FacCfgGn.TpoCmb[1]
               Faccpedm.NroPed = STRING(I-NroSer,"999") + STRING(I-NroPed,"999999")
               Faccpedm.CodDiv = S-CODDIV
               faccpedm.CodVen = faccpedm.CodVen:SCREEN-VALUE /* C-CODVEN*/
               Faccpedm.TipVta = "1" 
               faccpedm.Hora = STRING(TIME,"HH:MM")
               Faccpedm.Cmpbnte = Faccpedm.Cmpbnte:SCREEN-VALUE.
        DISPLAY Faccpedm.NroPed WITH FRAME {&FRAME-NAME}.
        IF Faccpedm.FmaPgo = "001" THEN Faccpedm.FlgEst = "X".
     END.
     ASSIGN faccpedm.Usuario = S-USER-ID.
  END.

  RUN Genera-Pedido.    /* Detalle del pedido */ 
  RUN Graba-Totales.
  IF S-NroCot <> "" THEN RUN Actualiza-Cotizacion.
/*  
  IF NRO_PED <> "" THEN RUN Borra-Copia.
*/      

  /*****    Cancela Documento   *****/
  RUN Cancelar-pedido.
  /**********************************/

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
       DELETE FROM facdpedm WHERE facdpedm.codcia = faccpedm.codcia AND
             facdpedm.coddoc = faccpedm.coddoc AND
             facdpedm.nroped = faccpedm.nroped.
    END.
  
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
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
  IF AVAILABLE Faccpedm THEN DO WITH FRAME {&FRAME-NAME}:
     CASE Faccpedm.FlgEst:
          WHEN "A" THEN DISPLAY " ANULADO "   @ F-Estado .
          WHEN "C" THEN DISPLAY "CANCELADO"   @ F-Estado .
          WHEN "P" THEN DISPLAY "PENDIENTE"   @ F-Estado .
          WHEN "X" THEN DISPLAY "POR APROBAR" @ F-Estado .
     END CASE.
     IF Faccpedm.CodCli <> FacCfgGn.CliVar THEN DO:
        FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                      AND  gn-clie.CodCli = Faccpedm.CodCli 
                     NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie  THEN DO:
           DISPLAY gn-clie.DirCli @ Faccpedm.DirCli 
                   gn-clie.Ruc    @ Faccpedm.RucCli.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  IF Faccpedm.FlgEst <> "A" THEN RUN vta\r-impvm.r(ROWID(Faccpedm)).

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

  DEFINE VARIABLE i       AS INTEGER INITIAL 1 NO-UNDO.
  DEFINE VARIABLE D-ROWID AS ROWID NO-UNDO.

  D-ROWID = ROWID(faccpedm).

  /**** SOLO CONTADO Y CONTADO ANTICIPADO GENERAN INGRESO A CAJA ****/
  
  IF LOOKUP(Faccpedm.FmaPgo:SCREEN-VALUE IN FRAME {&FRAME-NAME},"000,002") > 0 THEN 
      RUN ccb/d-canc03 (INT(FacCPedM.codmon:SCREEN-VALUE), 
                        S-IMPTOT /*FacCPedM.imptot*/,
                        FacCPedM.Cmpbnte:SCREEN-VALUE,
                        FacCPedM.CodCli:SCREEN-VALUE, 
                        Faccpedm.NomCli:SCREEN-VALUE, 
                        OUTPUT x-nrodoc, 
                        OUTPUT X-OK
                        ).
  ELSE L-OK = YES.
  DO WITH FRAME {&FRAME-NAME}:
  IF Faccpedm.FmaPgo:SCREEN-VALUE  = "001" THEN DO:
        X-OK = YES.
        X-NRODOC = V-NROSER:SCREEN-VALUE  + V-NUMDOC:SCREEN-VALUE.
     /*
        ENABLE x-nrodoc WITH CENTERED.
        WAIT-FOR RETURN OF x-nrodoc.
     */   
  END.
  END.
  IF X-OK = NO THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
/*  /*****    Cancela Documento   *****/
 *   RUN Cancelar-pedido.
 * 
 *   /**********************************/*/
  
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
   FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                 AND  gn-clie.CodCli = FacCPedm.CodCli:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-clie THEN DO:
      MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCPedm.CodCli.
      RETURN "ADM-ERROR".   
   END.
   
   /***** Valida Ingreso de Ruc. *****/
   
   IF FacCpedm.Cmpbnte:screen-value = "FAC" AND LENGTH(FacCpedm.RucCli:screen-value) <> 11 THEN DO:
      MESSAGE "Ruc del Cliente Mal Ingresado" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FacCPedm.RucCli.
      RETURN "ADM-ERROR".   
   END.      

   IF Faccpedm.CodVen:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Codigo de Vendedor no debe ser blanco"  VIEW-AS ALERT-BOX ERROR.
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
   
   IF integer(v-NroSer:screen-value) = 0 THEN DO:
      MESSAGE "Serie 000 no válido" skip
      "Reingrese la Serie"
       VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO v-NroSer.
      RETURN "ADM-ERROR".   
   END.
   
   IF integer(v-NumDoc:screen-value) = 0 THEN DO:
      MESSAGE "Número 000000" skip
      "Reingrese el número"
      VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO v-NumDoc.
      RETURN "ADM-ERROR".
   END.

   
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

