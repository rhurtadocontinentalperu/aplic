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
/* Shared Variable Definitions ---                                       */

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE CL-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHAR.
DEFINE SHARED VARIABLE S-CODMOV   AS INTEGER. 
DEFINE SHARED VARIABLE s-PorIgv   LIKE Ccbcdocu.PorIgv.
DEFINE SHARED VARIABLE S-CODREF   AS CHAR.
DEFINE SHARED VARIABLE S-NROREF   AS CHAR.
DEFINE SHARED VARIABLE s-status-almacen AS LOG.

DEFINE SHARED TEMP-TABLE DMOV LIKE AlmDMov.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE C-NROFAC       AS CHAR    NO-UNDO.
DEFINE VARIABLE I-NRODOC       AS INTEGER NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHAR    NO-UNDO.
DEFINE VARIABLE R-ROWID        AS ROWID   NO-UNDO. 

DEFINE BUFFER CMOV FOR AlmCMov.
DEFINE BUFFER B-DMOV FOR AlmDMov.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE VARIABLE SW-LOG1 AS LOGICAL.
DEFINE VARIABLE X-FACTOR AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-FACTOR AS DECIMAL   NO-UNDO.

DEFINE VARIABLE X-ALMDES AS CHARACTER.

DEFINE VAR pMensaje AS CHAR NO-UNDO.

DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER x-almcmov FOR almcmov.

    DEF VAR cReturnValue AS CHAR NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES Almcmov
&Scoped-define FIRST-EXTERNAL-TABLE Almcmov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almcmov.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Almcmov.CodRef Almcmov.NroRf1 Almcmov.LPN ~
Almcmov.CodCli Almcmov.Observ 
&Scoped-define ENABLED-TABLES Almcmov
&Scoped-define FIRST-ENABLED-TABLE Almcmov
&Scoped-Define DISPLAYED-FIELDS Almcmov.NroDoc Almcmov.FchDoc ~
Almcmov.CodRef Almcmov.NroRf1 Almcmov.LPN Almcmov.CodCli Almcmov.CodMon ~
Almcmov.Observ 
&Scoped-define DISPLAYED-TABLES Almcmov
&Scoped-define FIRST-DISPLAYED-TABLE Almcmov
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Estado FILL-IN_RucCli ~
FILL-IN_NomCli FILL-IN_DirCli FILL-IN-MotDev 

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
DEFINE VARIABLE FILL-IN-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE FILL-IN-MotDev AS CHARACTER FORMAT "X(256)":U 
     LABEL "Motivo" 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_DirCli AS CHARACTER FORMAT "x(60)" 
     LABEL "Direccion" 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81.

DEFINE VARIABLE FILL-IN_NomCli AS CHARACTER FORMAT "x(50)" 
     VIEW-AS FILL-IN 
     SIZE 37 BY .81.

DEFINE VARIABLE FILL-IN_RucCli AS CHARACTER FORMAT "x(11)" 
     LABEL "Ruc" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Almcmov.NroDoc AT ROW 1 COL 13 COLON-ALIGNED
          LABEL "No. Ingreso" FORMAT "999999999"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          FONT 0
     FILL-IN-Estado AT ROW 1 COL 28 COLON-ALIGNED NO-LABEL
     Almcmov.FchDoc AT ROW 1 COL 72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almcmov.CodRef AT ROW 1.81 COL 6.71
          LABEL "Referencia"
          VIEW-AS COMBO-BOX INNER-LINES 3
          LIST-ITEMS "FAI" 
          DROP-DOWN-LIST
          SIZE 7.86 BY 1
     Almcmov.NroRf1 AT ROW 1.81 COL 21.14 COLON-ALIGNED NO-LABEL FORMAT "x(15)"
          VIEW-AS FILL-IN 
          SIZE 17.86 BY .81
          FONT 0
     Almcmov.LPN AT ROW 1.81 COL 46 COLON-ALIGNED WIDGET-ID 8
          LABEL "RTV"
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .81
     FILL-IN_RucCli AT ROW 1.81 COL 72 COLON-ALIGNED
     Almcmov.CodCli AT ROW 2.62 COL 13 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     FILL-IN_NomCli AT ROW 2.62 COL 26 COLON-ALIGNED NO-LABEL
     Almcmov.CodMon AT ROW 2.62 COL 74 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.43 BY .81
     FILL-IN_DirCli AT ROW 3.42 COL 13 COLON-ALIGNED
     Almcmov.Observ AT ROW 4.23 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 50 BY .81
     FILL-IN-MotDev AT ROW 5.04 COL 13 COLON-ALIGNED WIDGET-ID 2
     "Moneda" VIEW-AS TEXT
          SIZE 6.14 BY .58 AT ROW 2.65 COL 67
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.Almcmov
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
         HEIGHT             = 5.85
         WIDTH              = 86.86.
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
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN Almcmov.CodCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR RADIO-SET Almcmov.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX Almcmov.CodRef IN FRAME F-Main
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN Almcmov.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-MotDev IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DirCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_RucCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.LPN IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN Almcmov.NroRf1 IN FRAME F-Main
   EXP-FORMAT                                                           */
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

&Scoped-define SELF-NAME Almcmov.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.CodCli V-table-Win
ON LEAVE OF Almcmov.CodCli IN FRAME F-Main /* Cliente */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
        gn-clie.CodCli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-clie  THEN DO:
      MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   DISPLAY gn-clie.NomCli @ FILL-IN_NomCli 
           gn-clie.Ruc    @ FILL-IN_RucCli  
           gn-clie.DirCli @ FILL-IN_DirCli WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.CodRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.CodRef V-table-Win
ON VALUE-CHANGED OF Almcmov.CodRef IN FRAME F-Main /* Referencia */
DO:
  s-CodRef = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.NroRf1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.NroRf1 V-table-Win
ON LEAVE OF Almcmov.NroRf1 IN FRAME F-Main /* Referencia 1 */
DO:
   IF Almcmov.NroRf1:SCREEN-VALUE = "" THEN RETURN.
   FIND CcbCDocu WHERE CcbCDocu.CodCia = S-CODCIA AND
       CcbCDocu.CodDoc = Almcmov.CodRef:SCREEN-VALUE  AND
       CcbCDocu.NroDoc = Almcmov.NroRf1:SCREEN-VALUE  NO-LOCK NO-ERROR.
   IF NOT AVAILABLE CcbCDocu THEN DO:
       MESSAGE "DOCUMENTO NO EXISTE" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
   END.
   IF LOOKUP(CcbCDocu.FlgEst,"C,P") = 0 THEN DO:
       MESSAGE "DOCUMENTO NO VALIDO" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
   END.
   IF CcbCDocu.FlgCon = "D" THEN DO:
       MESSAGE "El documento ya fue devuelto" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
   END.
   IF CAN-FIND(FIRST Ccbddocu OF Ccbcdocu WHERE Ccbddocu.candev > 0 NO-LOCK)
       THEN DO:
       MESSAGE 'Solo de puede hacer una devolución total' VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
   END.
   ASSIGN
       s-PorIgv = Ccbcdocu.PorIgv
       s-NroRef = SELF:SCREEN-VALUE.
   DISPLAY
       Ccbcdocu.codcli @ Almcmov.codcli
       Ccbcdocu.nomcli @ FILL-IN_NomCli
       Ccbcdocu.dircli @ FILL-IN_DirCli
       WITH FRAME {&FRAME-NAME}.
   RUN Carga-Detalle.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Factura V-table-Win 
PROCEDURE Actualiza-Factura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER FACTOR AS INTEGER.
  DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  DEFINE VARIABLE F-Des AS DECIMAL INIT 0 NO-UNDO.
  DEFINE VARIABLE F-Dev AS DECIMAL INIT 0 NO-UNDO.
  DEFINE VARIABLE C-SIT AS CHARACTER INIT "" NO-UNDO.
  
  pMensaje = "".
  RLOOP:
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
      {lib/lock-genericov3.i ~
          &Tabla="Ccbcdocu" ~
          &Condicion="CcbCDocu.CodCia = S-CODCIA ~
          AND CcbCDocu.CodDoc = Almcmov.CodRef ~
          AND CcbCDocu.NroDoc = Almcmov.NroRf1" ~
          &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
          &Accion="RETRY" ~
          &Mensaje="NO" ~
          &txtMensaje="pMensaje" ~
          &TipoError="UNDO, RETURN 'ADM-ERROR'" }
      FOR EACH Almdmov OF Almcmov NO-LOCK:
          FIND FIRST CcbDDocu WHERE CcbDDocu.CodCia = Almdmov.CodCia 
              AND  CcbDDocu.CodDoc = Almcmov.CodRef 
              AND  CcbDDocu.NroDoc = Almcmov.NroRf1 
              AND  CcbDDocu.CodMat = Almdmov.CodMat 
              EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
          IF ERROR-STATUS:ERROR = YES THEN DO:
              {lib/mensaje-de-error.i &MensajeError="pMensaje"}
              UNDO RLOOP, RETURN 'ADM-ERROR'.
          END.
          ASSIGN 
              CcbDDocu.CanDev = CcbDDocu.CanDev + (FACTOR * Almdmov.CanDes).
          RELEASE CcbDDocu.
      END.
      IF Ccbcdocu.FlgEst <> 'A' THEN DO:
          FOR EACH CcbDDocu OF CcbCDocu NO-LOCK:
              F-Des = F-Des + CcbDDocu.CanDes.
              F-Dev = F-Dev + CcbDDocu.CanDev. 
          END.
          IF F-Dev > 0 THEN C-SIT = "P".
          IF F-Des = F-Dev THEN C-SIT = "D".
          ASSIGN 
              CcbCDocu.FlgCon = C-SIT.
      END.
  END.  
  IF AVAILABLE Ccbcdocu THEN RELEASE CcbCDocu.
  RETURN 'OK'.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Temporal V-table-Win 
PROCEDURE Actualiza-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH DMOV:
    DELETE DMOV.
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
  {src/adm/template/row-list.i "Almcmov"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almcmov"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Documento V-table-Win 
PROCEDURE Asigna-Documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
   IF Almcmov.CodCli:SCREEN-VALUE = "" THEN DO:
     MESSAGE "Debe Solicitar al Cliente" VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
   END.
   IF NOT Almcmov.CodCli:SENSITIVE THEN DO:
      MESSAGE "Solo puede asignar una vez" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
   END.
   C-NROFAC = "".
   input-var-1 = Almcmov.CodRef:SCREEN-VALUE.
   input-var-2 = Almcmov.CodCli:SCREEN-VALUE.
   input-var-3 = "A".
   RUN LKUP\C-DocDev ("Comprobantes").
   IF output-var-1 <> ? THEN DO:
      FIND CcbCDocu WHERE ROWID(CcbCDocu) = output-var-1 NO-LOCK NO-ERROR.
      IF CcbCDocu.FlgCon = "D" THEN DO:
         MESSAGE "El documento ya fue devuelto" VIEW-AS ALERT-BOX ERROR.
         RETURN "ADM-ERROR".
      END.
      C-NROFAC = CcbCDocu.NroDoc.
      DISPLAY C-NROFAC @ Almcmov.NroRf1.
      ASSIGN
          s-PorIgv = Ccbcdocu.PorIgv
          s-NroRef = c-NroFac.
      RUN Carga-Detalle.
   END.
END.

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
      FOR EACH B-DMOV NO-LOCK WHERE B-DMOV.CodCia = Almcmov.CodCia AND  
          B-DMOV.CodAlm = Almcmov.CodAlm AND  
          B-DMOV.TipMov = Almcmov.TipMov AND  
          B-DMOV.CodMov = Almcmov.CodMov AND  
          B-DMOV.NroSer = Almcmov.NroSer AND  
          B-DMOV.NroDoc = Almcmov.NroDoc:
          FIND Almdmov WHERE ROWID(Almdmov) = ROWID(B-DMOV) EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE Almdmov THEN UNDO, RETURN 'ADM-ERROR'.
          ASSIGN R-ROWID = ROWID(Almdmov).
          RUN ALM\ALMDCSTK (R-ROWID). /* Descarga del Almacen */
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

          /*
          RUN ALM\ALMACPR1 (R-ROWID,"D").
          RUN ALM\ALMACPR2 (R-ROWID,"D").
          */
          /* RHC 31.03.04 REACTIVAMOS KARDEX POR ALMACEN */
          RUN alm/almacpr1 (R-ROWID, 'D').
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

          DELETE B-DMOV.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle V-table-Win 
PROCEDURE Carga-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* NOTA: El cálculo se va a basar en el precio unitario */
  EMPTY TEMP-TABLE DMOV.
  DO WITH FRAME {&FRAME-NAME}:
      C-NROFAC = CcbCDocu.NroDoc.
      X-ALMDES = CcbCDocu.CodAlm.
      FOR EACH CcbDDocu NO-LOCK WHERE CcbDDocu.CodCia = CcbCDocu.CodCia 
          AND  CcbDDocu.CodDoc = CcbCDocu.CodDoc 
          AND  CcbDDocu.NroDoc = CcbCDocu.NroDoc,
          FIRST Almmmatg OF Ccbddocu NO-LOCK:
          IF (CcbDDocu.CanDes - CcbDDocu.CanDev) > 0 THEN DO:
              CREATE DMOV.
              ASSIGN 
                  DMOV.CodCia = CcbDDocu.CodCia
                  DMOV.CodAlm = s-CodAlm
                  DMOV.TipMov = "S"
                  DMOV.codmat = CcbDDocu.CodMat
                  DMOV.CanDes = (CcbDDocu.CanDes - CcbDDocu.CanDev)
                  DMOV.CanDev = (CcbDDocu.CanDes - CcbDDocu.CanDev)
                  DMOV.CodUnd = CcbDDocu.UndVta 
                  DMOV.Factor = CcbDDocu.Factor 
                  DMOV.AftIsc = CcbDDocu.AftIsc 
                  DMOV.AftIgv = CcbDDocu.AftIgv
                  DMOV.Flg_factor = CcbDDocu.Flg_factor.
              /* Recalculamos Precios */
              IF DMOV.CanDes = Ccbddocu.CanDes THEN DO:   /* DEVOLUCION TOTAL */
                  ASSIGN
                      DMOV.ImpLin = Ccbddocu.ImpLin - Ccbddocu.ImpDto2
                      DMOV.PreUni = Ccbddocu.ImpLin / DMOV.CanDes.
              END.
              ELSE DO:    /* DEVOLUCION PARCIAL */
                  ASSIGN
                      DMOV.PreUni = ( Ccbddocu.ImpLin - Ccbddocu.ImpDto2 ) / Ccbddocu.CanDes
                      DMOV.ImpLin = ROUND (DMOV.CanDes * DMOV.PreUni, 2).
              END.
              IF DMOV.AftIgv = YES THEN DMOV.ImpIgv = ROUND(DMOV.ImpLin / ( 1 + Ccbcdocu.PorIgv / 100) * Ccbcdocu.PorIgv / 100, 2).
          END.
      END.
      Almcmov.CodCli:SENSITIVE = NO.
      RUN Procesa-Handle IN lh_Handle ('browse'). 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle V-table-Win 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

   pMensaje = "".

   DEF VAR X AS INTEGER.

   RLOOP:
   DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
       RUN Borra-Detalle.
       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
       FOR EACH DMOV NO-LOCK:
           CREATE almdmov.
           ASSIGN Almdmov.CodCia = Almcmov.CodCia 
                  Almdmov.CodAlm = Almcmov.CodAlm 
                  Almdmov.TipMov = Almcmov.TipMov 
                  Almdmov.CodMov = Almcmov.CodMov 
                  Almdmov.NroSer = Almcmov.NroSer
                  Almdmov.NroDoc = Almcmov.NroDoc 
                  Almdmov.CodMon = Almcmov.CodMon 
                  Almdmov.FchDoc = Almcmov.FchDoc 
                  Almdmov.TpoCmb = Almcmov.TpoCmb 
                  Almdmov.codmat = DMOV.codmat
                  Almdmov.CanDes = DMOV.CanDes
                  Almdmov.CodUnd = DMOV.CodUnd
                  Almdmov.Factor = DMOV.Factor
                  Almdmov.ImpCto = DMOV.ImpCto
                  Almdmov.PreUni = DMOV.PreUni
                  Almdmov.CodAjt = '' 
                  Almdmov.PreBas = DMOV.PreBas 
                  Almdmov.PorDto = DMOV.PorDto 
                  Almdmov.ImpLin = DMOV.ImpLin 
                  Almdmov.ImpIsc = DMOV.ImpIsc 
                  Almdmov.ImpIgv = DMOV.ImpIgv 
                  Almdmov.ImpDto = DMOV.ImpDto 
                  Almdmov.AftIsc = DMOV.AftIsc 
                  Almdmov.AftIgv = DMOV.AftIgv 
                  Almdmov.CodAnt = DMOV.CodAnt
                  Almdmov.Por_Dsctos[1] = DMOV.Por_Dsctos[1]
                  Almdmov.Por_Dsctos[2] = DMOV.Por_Dsctos[2]
                  Almdmov.Por_Dsctos[3] = DMOV.Por_Dsctos[3]
                  Almdmov.Flg_factor = DMOV.Flg_factor
                  Almdmov.HraDoc     = Almcmov.HorRcp.
           ASSIGN
               R-ROWID = ROWID(Almdmov).
           RUN ALM\ALMACSTK (R-ROWID).
           IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
               pMensaje = 'Producto: ' + Almdmov.codmat + ' NO asignado al almacén'.
               UNDO RLOOP, RETURN 'ADM-ERROR'.
           END.
           /* RHC 31.03.04 REACTIVAMOS KARDEX POR ALMACEN */
           RUN alm/almacpr1 (R-ROWID, 'U').
           IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, RETURN 'ADM-ERROR'.
       END.
   END.
   IF AVAILABLE Almdmov THEN RELEASE Almdmov.
   RETURN 'OK'.
   
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
  IF s-status-almacen = NO THEN DO:
      MESSAGE 'Almacén INACTIVO' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  
  ASSIGN
      s-PorIgv = FacCfgGn.PorIgv
      s-CodRef = "FAI".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ).

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      DISPLAY TODAY @ Almcmov.FchDoc.
      Almcmov.CodRef:SCREEN-VALUE = s-CodRef.
  END.
  C-NROFAC = "".
  RUN Actualiza-Temporal.
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
  {lib/lock-genericov3.i ~
      &Tabla="Almacen" ~
      &Condicion="Almacen.CodCia = S-CODCIA ~
      AND Almacen.CodAlm = s-CodAlm" ~
      &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
      &Accion="RETRY" ~
      &Mensaje="NO" ~
      &txtMensaje="pMensaje" ~
      &TipoError="UNDO, RETURN 'ADM-ERROR'" }
  REPEAT:   /* RHC 06/04/2015 */
      ASSIGN 
          I-NroDoc = Almacen.CorrIng
          Almacen.CorrIng = Almacen.CorrIng + 1.
      ASSIGN 
          Almcmov.CodCia = S-CodCia 
          Almcmov.CodAlm = s-CodAlm
          Almcmov.TipMov = "I"
          Almcmov.CodMov = S-CodMov 
          Almcmov.NroSer = 000
          Almcmov.NroDoc = I-NRODOC
          Almcmov.FchDoc = TODAY
          Almcmov.NroRef = C-NROFAC
          Almcmov.TpoCmb = FacCfgGn.Tpocmb[1]
          Almcmov.FlgEst = "P"
          Almcmov.HorRcp = STRING(TIME,"HH:MM:SS")
          Almcmov.usuario = S-USER-ID
          Almcmov.NomRef  = Fill-in_nomcli:SCREEN-VALUE IN FRAME {&FRAME-NAME}
          NO-ERROR.
      IF ERROR-STATUS:ERROR = NO THEN LEAVE.
  END.
  ASSIGN
      Almcmov.NroRf3 = cReturnValue.

  FIND CcbCDocu WHERE CcbCDocu.CodCia = S-CODCIA 
      AND  CcbCDocu.CodDoc = Almcmov.CodRef 
      AND  CcbCDocu.NroDoc = Almcmov.NroRef 
      NO-LOCK NO-ERROR.
  IF AVAILABLE CcbCDocu THEN DO:
      ASSIGN 
          Almcmov.CodCli = CcbCDocu.CodCli
          Almcmov.CodMon = CcbCDocu.CodMon
          Almcmov.CodVen = CcbCDocu.CodVen.
  END.

  RUN Genera-Detalle (OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF TRUE <> (pMensaje > '')  THEN pMensaje = 'NO se pudo generar el detalle de la devolución'.
      UNDO, RETURN 'ADM-ERROR'.
  END.
  
  RUN Actualiza-Factura (INPUT 1, OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF TRUE <> (pMensaje > '')  THEN pMensaje = 'NO se pudo actualizar el comprobante'.
      UNDO, RETURN 'ADM-ERROR'.
  END.

  IF AVAILABLE Almacen  THEN RELEASE Almacen.
  IF AVAILABLE FacCorre THEN RELEASE FacCorre.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  IF s-status-almacen = NO THEN DO:
      MESSAGE 'Almacén INACTIVO' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.

  /* Code placed here will execute PRIOR to standard behavior. */
   DEFINE VAR RPTA AS CHAR.
   
   IF Almcmov.FlgEst <> 'P' THEN DO:
      MESSAGE "Devolucion no puede ser anulada" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
   END.

   DEF VAR dFchCie AS DATE.
   dFchCie = TODAY.
       IF almcmov.fchdoc <> dFchCie THEN DO:
           MESSAGE 'NO se puede anular ningun documento antes del' (dFchCie)
               VIEW-AS ALERT-BOX WARNING.
           RETURN 'ADM-ERROR'.
       END.

   pMensaje = "".
   RLOOP:
   DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
      RUN Actualiza-Factura(INPUT -1, OUTPUT pMensaje).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, LEAVE.

      FOR EACH Almdmov EXCLUSIVE-LOCK WHERE Almdmov.CodCia = Almcmov.CodCia AND  
          Almdmov.CodAlm = Almcmov.CodAlm AND  
          Almdmov.TipMov = Almcmov.TipMov AND  
          Almdmov.CodMov = Almcmov.CodMov AND  
          Almdmov.NroSer = Almcmov.NroSer AND  
          Almdmov.NroDoc = Almcmov.NroDoc:
          /* **************************** */
          /* Extornamos control de series */
          /* **************************** */
          DEFINE VAR hProc AS HANDLE NO-UNDO.
          RUN alm/almacen-library PERSISTENT SET hProc.
          RUN FIFO_Control-de-Series IN hProc (INPUT 'DELETE',
                                               INPUT Almdmov.CodAlm,
                                               INPUT Almdmov.AlmOri,
                                               INPUT Almdmov.TipMov,
                                               INPUT Almdmov.CodMov,
                                               INPUT Almdmov.NroSer,
                                               INPUT Almdmov.NroDoc,
                                               INPUT Almdmov.CodMat,
                                               INPUT Almdmov.CodUnd,
                                               '',      /* OJO > No envío el número de serie, en este caso */
                                               INPUT Almdmov.CanDes,
                                               INPUT Almdmov.Factor,
                                               OUTPUT pMensaje).
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, LEAVE RLOOP.
          DELETE PROCEDURE hProc.
          /* **************************** */
          ASSIGN 
              R-ROWID = ROWID(Almdmov).
          RUN ALM\ALMDCSTK (R-ROWID). /* Descarga del Almacen */
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, LEAVE RLOOP.
          RUN alm/almacpr1 (R-ROWID, 'D').
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, LEAVE RLOOP.

          DELETE Almdmov.
      END.
      
      /* Solo marcamos el FlgEst como Anulado */
      FIND CMOV WHERE CMOV.CodCia = Almcmov.CodCia 
                 AND  CMOV.CodAlm = Almcmov.CodAlm 
                 AND  CMOV.TipMov = Almcmov.TipMov 
                 AND  CMOV.CodMov = Almcmov.CodMov 
                 AND  CMOV.NroSer = Almcmov.NroSer 
                 AND  CMOV.NroDoc = Almcmov.NroDoc 
                EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE CMOV
      THEN DO:
        RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
        UNDO, LEAVE.
      END.
      ASSIGN 
          CMOV.FlgEst = 'A'
          CMOV.Observ = "      A   N   U   L   A   D   O       ".
      RELEASE CMOV.
   END.
   IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
   RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
   RUN Procesa-Handle IN lh_Handle ('Browse').
   
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

  IF AVAILABLE Almcmov THEN DO WITH FRAME {&FRAME-NAME}:
      CASE almcmov.flgest:
          WHEN 'A' THEN FILL-IN-Estado:SCREEN-VALUE = 'ANULADA'.
          WHEN 'P' THEN FILL-IN-Estado:SCREEN-VALUE = 'PENDIENTE'.
          WHEN 'C' THEN FILL-IN-Estado:SCREEN-VALUE = 'CERRADA'.
      END CASE.
      FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
          AND  gn-clie.CodCli = Almcmov.CodCli 
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-clie  THEN 
          DISPLAY 
          gn-clie.NomCli @ FILL-IN_NomCli 
          gn-clie.Ruc    @ FILL-IN_RucCli 
          gn-clie.DirCli @ FILL-IN_DirCli.
      FIND ccbtabla WHERE ccbtabla.codcia = s-codcia
          AND ccbtabla.tabla = 'MD'
          AND CcbTabla.Codigo = almcmov.nrorf3
          NO-LOCK NO-ERROR.
     IF AVAILABLE ccbtabla THEN FILL-IN-MotDev:SCREEN-VALUE = ccbtabla.nombre.
     ELSE FILL-IN-MotDev:SCREEN-VALUE = ''.
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
          Almcmov.CodCli:SENSITIVE = NO.
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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'Imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN VTA\R-DEVFAC.R(ROWID(ALMCMOV)).

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
  
  RUN alm/d-motdev (OUTPUT cReturnValue).
  IF cReturnValue = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

  /* Dispatch standard ADM method.                             */
  pMensaje = "".
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.

  /* Code placed here will execute AFTER standard behavior.    */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Numero-Mvto-Almacen V-table-Win 
PROCEDURE Numero-Mvto-Almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
               AND Almacen.CodAlm = s-CodAlm
               EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Almacen THEN RETURN 'ADM-ERROR'.
  ASSIGN 
    I-NroDoc = Almacen.CorrIng
    Almacen.CorrIng = Almacen.CorrIng + 1.
  /*RELEASE Almacen.*/

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
  {src/adm/template/snd-list.i "Almcmov"}

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

DEF VAR X AS INTEGER.
DEF VAR X-TOPE AS INTEGER INIT 7 NO-UNDO.

DO WITH FRAME {&FRAME-NAME} :
   X = 0.
   FOR EACH DMOV NO-LOCK:
       X = X + 1.
   END.
   FIND FacCfgGn WHERE Faccfggn.codcia = s-codcia NO-LOCK NO-ERROR.
   IF AVAILABLE Faccfggn THEN X-TOPE = Faccfggn.items_n_credito.
   
   IF Almcmov.CodCli:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcmov.CodCli.
      RETURN "ADM-ERROR".   
   END.
   /* SOLO OPENORANGE */
   DEF VAR pClienteOpenOrange AS LOG NO-UNDO.
   RUN gn/clienteopenorange (cl-codcia, Almcmov.CodCli:SCREEN-VALUE, "", OUTPUT pClienteOpenOrange).
   IF pClienteOpenOrange = YES THEN DO:
       MESSAGE "Cliente NO se puede antender por Continental" SKIP
           "Solo se le puede antender por OpenOrange"
           VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO Almcmov.CodCli.
       RETURN "ADM-ERROR".   
   END.

   IF TRUE <> (Almcmov.NroRf1:SCREEN-VALUE > "") THEN DO:
      MESSAGE "Numero de documento no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcmov.NroRf1.
      RETURN "ADM-ERROR".   
   END.
   FIND CcbCDocu WHERE CcbCDocu.CodCia = S-CODCIA 
       AND CcbCDocu.CodDoc = Almcmov.CodRef:SCREEN-VALUE  
       AND CcbCDocu.NroDoc = Almcmov.NroRf1:SCREEN-VALUE  
       NO-LOCK NO-ERROR.
   IF NOT AVAILABLE CcbCDocu THEN DO:
      MESSAGE "DOCUMENTO NO EXISTE" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcmov.NroRf1.
      RETURN "ADM-ERROR".   
   END.
   IF CcbCDocu.CodCli <> Almcmov.CodCli:SCREEN-VALUE THEN DO:
      MESSAGE "DOCUMENTO NO PERTENECE AL CLIENTE" Almcmov.CodCli:SCREEN-VALUE VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcmov.NroRf1.
      RETURN "ADM-ERROR".   
   END.
   IF LOOKUP(CcbCDocu.FlgEst,"C,P") = 0 THEN DO:
      MESSAGE "DOCUMENTO NO VALIDO" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcmov.NroRf1.
      RETURN "ADM-ERROR".   
   END.
   IF CcbCDocu.FlgSit = "D" THEN DO:
      MESSAGE "El documento ya fue devuelto" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcmov.NroRf1.
      RETURN "ADM-ERROR".   
   END.
   IF C-NROFAC = "" THEN DO:
      MESSAGE "No asignó ninguna FAI" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcmov.CodCli.
      RETURN "ADM-ERROR".   
   END.
   /* Ic-27Ago2017, Si la devolucion de mercaderia es de Supermercados peruanos, obligar ingreso de RTV */
   IF CcbCDocu.CodCli = "20100070970" THEN DO:
       if TRUE <> (Almcmov.lpn:SCREEN-VALUE > "") THEN DO:
           MESSAGE "Para SUPERMERCADOS PERUANOS debe ingresar el RTV" VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO Almcmov.lpn.
           RETURN "ADM-ERROR".   
       END.       
   END.
   /* Ic - 27Ago2019, que el comprobante no tenga PI pendientes */
   DEFINE VAR x-cuantas-nc AS INT.
   x-cuantas-nc = 0.
   FOR EACH x-almcmov WHERE x-almcmov.codcia = s-codcia 
       AND x-almcmov.codref = ccbcdocu.coddoc 
       AND x-almcmov.nroref = ccbcdocu.nrodoc 
       AND x-almcmov.tipmov = 'I' 
       AND x-almcmov.codmov = 9 
       AND x-almcmov.flgest = 'P' NO-LOCK:
       x-cuantas-nc = x-cuantas-nc + 1.
   END.
   IF x-cuantas-nc > 0 THEN DO:
       MESSAGE "El documento " + ccbcdocu.coddoc + "-" + ccbcdocu.nrodoc SKIP
                "Tiene " + STRING(x-cuantas-nc,">>9") + " Partes de Ingreso pendientes" SKIP
                "Imposible realizar la devolucion total"
           VIEW-AS ALERT-BOX INFORMATION.
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
  /* consistencia de la fecha del cierre del sistema */
  MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
  RETURN "ADM-ERROR".
  
  IF s-status-almacen = NO THEN DO:
      MESSAGE 'Almacén INACTIVO' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  
  DEF VAR dFchCie AS DATE.
  RUN gn/fecha-de-cierre (OUTPUT dFchCie).
  IF almcmov.fchdoc <= dFchCie THEN DO:
      MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
          VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  ASSIGN
      s-CodRef = Almcmov.CodRef
      s-NroRef = ALmcmov.NroRf1.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

