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
DEFINE BUFFER B-CPEDM FOR Faccpedm.
DEFINE BUFFER B-CPEDI FOR Faccpedi.
DEFINE SHARED TEMP-TABLE ITEM LIKE FacDPedm.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE cl-codcia  AS INT.
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

DEFINE BUFFER B-CPEDM1 FOR FacCPedm.

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
Faccpedm.DirCli Faccpedm.FmaPgo Faccpedm.CodVen Faccpedm.Glosa ~
Faccpedm.CodTrans Faccpedm.DocDesp Faccpedm.CodMon 
&Scoped-define ENABLED-TABLES Faccpedm
&Scoped-define FIRST-ENABLED-TABLE Faccpedm
&Scoped-Define ENABLED-OBJECTS RECT-18 
&Scoped-Define DISPLAYED-FIELDS Faccpedm.NroPed Faccpedm.CodCli ~
Faccpedm.NomCli Faccpedm.DirCli Faccpedm.FmaPgo Faccpedm.CodVen ~
Faccpedm.Glosa Faccpedm.CodTrans Faccpedm.DocDesp Faccpedm.FchPed ~
Faccpedm.CodMon Faccpedm.TpoCmb Faccpedm.Cmpbnte 
&Scoped-define DISPLAYED-TABLES Faccpedm
&Scoped-define FIRST-DISPLAYED-TABLE Faccpedm
&Scoped-Define DISPLAYED-OBJECTS F-CndVta F-nomVen F-Estado 

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

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87.57 BY 5.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Faccpedm.NroPed AT ROW 1.19 COL 8.57 COLON-ALIGNED
          LABEL "Pedido" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 15.86 BY .69
          FONT 0
     Faccpedm.CodCli AT ROW 1.88 COL 8.57 COLON-ALIGNED HELP
          ""
          LABEL "Cliente" FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     Faccpedm.NomCli AT ROW 1.88 COL 20 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 41.14 BY .69
     Faccpedm.DirCli AT ROW 2.58 COL 8.57 COLON-ALIGNED
          LABEL "Direccion"
          VIEW-AS FILL-IN 
          SIZE 34.86 BY .69
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
          LABEL "Glosa" FORMAT "X(100)"
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
          LIST-ITEMS "FAC","BOL" 
          DROP-DOWN-LIST
          SIZE 6.72 BY 1
     "Transportista :" VIEW-AS TEXT
          SIZE 9.86 BY .5 AT ROW 5.58 COL 37.72
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
   NO-ENABLE EXP-LABEL                                                  */
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
/* SETTINGS FOR FILL-IN Faccpedm.FchPed IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX Faccpedm.FmaPgo IN FRAME F-Main
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN Faccpedm.Glosa IN FRAME F-Main
   ALIGN-L EXP-LABEL EXP-FORMAT                                         */
/* SETTINGS FOR FILL-IN Faccpedm.NroPed IN FRAME F-Main
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
     DISPLAY gn-clie.CodCli @ Faccpedm.CodCli.
     FacCPedm.FmaPgo:SCREEN-VALUE = "000" .
     
     S-CODMON = INTEGER(Faccpedm.CodMon:SCREEN-VALUE).

/*     IF S-USER-ID = "ADMIN" THEN DO:
 *         MESSAGE "PASA" S-CODMON VIEW-AS ALERT-BOX.
 *      END.*/

/*     DISPLAY gn-clie.NomCli @ Faccpedm.NomCli
 *              gn-clie.DirCli @ Faccpedm.DirCli.
 *      IF gn-clie.Ruc = "" THEN 
 *         Faccpedm.Cmpbnte:SCREEN-VALUE  = "BOL".
 *      ELSE 
 *         Faccpedm.Cmpbnte:SCREEN-VALUE = "FAC".*/

     IF Faccpedm.NomCli:SCREEN-VALUE = "" THEN DISPLAY gn-clie.NomCli @ Faccpedm.NomCli.
     IF Faccpedm.DirCli:SCREEN-VALUE = "" THEN DISPLAY gn-clie.DirCli @ Faccpedm.DirCli.
     IF gn-clie.Ruc = "" THEN Faccpedm.Cmpbnte:SCREEN-VALUE  = "BOL".
     ELSE Faccpedm.Cmpbnte:SCREEN-VALUE = "FAC".
     
     S-CNDVTA = gn-clie.CndVta.
     
     S-CODCLI = gn-clie.CodCli.
     C-CodVen = S-CODVEN.
     F-NomVen = "".
     IF C-CodVen = "" THEN C-CodVen = S-CODVEN.
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
                  AND  gn-ven.CodVen = C-CodVen 
                 NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
     IF gn-clie.CodVen <> "" THEN 
          DISPLAY gn-clie.CodVen @ FacCPedm.CodVen.
     DISPLAY F-NomVen.
     IF gn-clie.CodCli <> FacCfgGn.CliVar THEN DO:
         Faccpedm.NomCli:SENSITIVE = NO.
         Faccpedm.DirCli:SENSITIVE = NO.
         APPLY "ENTRY" TO Faccpedm.FmaPgo.
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
    DELETE FROM facdpedm WHERE facdpedm.codcia = faccpedm.codcia 
                          AND  facdpedm.coddoc = faccpedm.coddoc 
                          AND  facdpedm.nroped = faccpedm.nroped.

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
       RELEASE facdpedm.
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
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY @ faccpedm.FchPed
             FacCfgGn.TpoCmb[1] @ Faccpedm.TpoCmb
             FacCfgGn.CliVar @ Faccpedm.CodCli.
     Faccpedm.NomCli:SENSITIVE = NO.
     Faccpedm.DirCli:SENSITIVE = NO.
/*     Faccpedm.RucCli:SENSITIVE = NO.*/
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
               Faccpedm.codalm = S-CodAlm
               faccpedm.FchPed = TODAY
               Faccpedm.PorIgv = FacCfgGn.PorIgv
               Faccpedm.TpoCmb = FacCfgGn.TpoCmb[1]
               Faccpedm.NroPed = STRING(I-NroSer,"999") + STRING(I-NroPed,"999999")
               Faccpedm.CodDiv = S-CODDIV
               faccpedm.CodVen = faccpedm.CodVen:SCREEN-VALUE /* C-CODVEN*/
               Faccpedm.TipVta = "1" 
               faccpedm.Hora = STRING(TIME,"HH:MM")
               Faccpedm.Cmpbnte = Faccpedm.Cmpbnte:SCREEN-VALUE.
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
     IF AVAIL gn-clie THEN Faccpedm.RucCli = gn-clie.Ruc.
     
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

/*       DELETE FROM facdpedm WHERE facdpedm.codcia = faccpedm.codcia 
 *                              AND  facdpedm.coddoc = faccpedm.coddoc 
 *                              AND  facdpedm.nroped = faccpedm.nroped.*/

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
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN Genera-Pedido.    /* Detalle del pedido */ 
  RUN Graba-Totales.
  IF S-NroCot <> "" THEN RUN Actualiza-Cotizacion.
  
  IF NRO_PED <> "" THEN RUN Borra-Copia.
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

