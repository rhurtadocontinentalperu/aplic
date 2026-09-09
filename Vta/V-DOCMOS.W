&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI ADM1
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

/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE VARIABLE I-CODMOV AS INTEGER NO-UNDO.
DEFINE VARIABLE I-NROSER AS INTEGER NO-UNDO.
DEFINE VARIABLE I-SERPED AS INTEGER NO-UNDO.
DEFINE VARIABLE I-NRODOC AS INTEGER NO-UNDO.
DEFINE VARIABLE C-NROIC  AS CHAR    NO-UNDO.
DEFINE VARIABLE S-NROPED AS CHAR    NO-UNDO.
DEFINE VARIABLE R-ROWID  AS ROWID   NO-UNDO.

/* Shared Variable Definitions ---                                       */
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE cl-codcia AS INT.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC  AS CHAR.
  
FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN I-NROSER = FacCorre.NroSer.

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = "P/M" AND
     FacCorre.CodDiv = S-CODDIV NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN I-SERPED = FacCorre.NroSer.

FIND FacDocum WHERE FacDocum.CodCia = S-CODCIA AND
     FacDocum.CodDoc = S-CODDOC NO-LOCK NO-ERROR.
IF AVAILABLE FacDocum THEN I-CODMOV = FacDocum.CodMov.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

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
&Scoped-define EXTERNAL-TABLES CcbCDocu
&Scoped-define FIRST-EXTERNAL-TABLE CcbCDocu


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCDocu.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCDocu.NroPed CcbCDocu.CodMon ~
CcbCDocu.Glosa 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-12 RECT-13 
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.CodDoc CcbCDocu.NroDoc ~
CcbCDocu.FchDoc CcbCDocu.NroPed CcbCDocu.TpoCmb CcbCDocu.CodCli ~
CcbCDocu.CodMon CcbCDocu.Glosa 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS F-NomCli F-DirCli F-RucCli FILL-IN_ImpUsa ~
FILL-IN_ImpNac FILL-IN_EfeUsa FILL-IN_EfeNac FILL-IN_VueNac FILL-IN_VueUsa 

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
DEFINE VARIABLE F-DirCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Direccion" 
     VIEW-AS FILL-IN 
     SIZE 45 BY .69 NO-UNDO.

DEFINE VARIABLE F-NomCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Razon Social" 
     VIEW-AS FILL-IN 
     SIZE 45 BY .69 NO-UNDO.

DEFINE VARIABLE F-RucCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "RUC" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_EfeNac AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_EfeUsa AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpNac AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpUsa AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_VueNac AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69.

DEFINE VARIABLE FILL-IN_VueUsa AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 4.69.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50 BY 3.58.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50 BY .12.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.CodDoc AT ROW 1.19 COL 3.29
          LABEL "Doc."
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .69
     CcbCDocu.NroDoc AT ROW 1.19 COL 12.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbCDocu.FchDoc AT ROW 1.19 COL 61 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.14 BY .69
     CcbCDocu.NroPed AT ROW 1.88 COL 12.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbCDocu.TpoCmb AT ROW 1.88 COL 61 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .69
     CcbCDocu.CodCli AT ROW 2.58 COL 12.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbCDocu.CodMon AT ROW 2.58 COL 63 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 13.43 BY .69
     F-NomCli AT ROW 3.27 COL 12.86 COLON-ALIGNED
     F-DirCli AT ROW 3.96 COL 12.86 COLON-ALIGNED
     F-RucCli AT ROW 3.96 COL 63 COLON-ALIGNED
     CcbCDocu.Glosa AT ROW 4.65 COL 12.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 45 BY .69
     FILL-IN_ImpUsa AT ROW 6.38 COL 63 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpNac AT ROW 6.46 COL 41 COLON-ALIGNED NO-LABEL
     FILL-IN_EfeUsa AT ROW 7.23 COL 63 COLON-ALIGNED NO-LABEL
     FILL-IN_EfeNac AT ROW 7.31 COL 41 COLON-ALIGNED NO-LABEL
     FILL-IN_VueNac AT ROW 8.31 COL 41 COLON-ALIGNED NO-LABEL
     FILL-IN_VueUsa AT ROW 8.31 COL 63 COLON-ALIGNED NO-LABEL
     "DOLARES" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 5.81 COL 66.86
          BGCOLOR 0 FGCOLOR 15 
     "Moneda :" VIEW-AS TEXT
          SIZE 6.86 BY .5 AT ROW 2.65 COL 56.14
     "SOLES" VIEW-AS TEXT
          SIZE 5.57 BY .5 AT ROW 5.81 COL 47.29
          BGCOLOR 0 FGCOLOR 15 
     "Vuelto" VIEW-AS TEXT
          SIZE 4.72 BY .69 AT ROW 8.31 COL 35.43
     "Efectivo" VIEW-AS TEXT
          SIZE 6.14 BY .69 AT ROW 7.27 COL 34
     "Total a Pagar" VIEW-AS TEXT
          SIZE 10.57 BY .69 AT ROW 6.46 COL 29.57
     RECT-1 AT ROW 1 COL 1
     RECT-12 AT ROW 5.65 COL 28
     RECT-13 AT ROW 8.15 COL 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.CcbCDocu
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
         HEIGHT             = 8.23
         WIDTH              = 77.72.
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
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN CcbCDocu.CodCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.CodDoc IN FRAME F-Main
   NO-ENABLE ALIGN-L EXP-LABEL                                          */
/* SETTINGS FOR FILL-IN F-DirCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-RucCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_EfeNac IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_EfeUsa IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpNac IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpUsa IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_VueNac IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_VueUsa IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.TpoCmb IN FRAME F-Main
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

&Scoped-define SELF-NAME FILL-IN_EfeNac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_EfeNac V-table-Win
ON LEAVE OF FILL-IN_EfeNac IN FRAME F-Main
DO:
   RUN Control-Pago.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_EfeUsa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_EfeUsa V-table-Win
ON LEAVE OF FILL-IN_EfeUsa IN FRAME F-Main
DO:
   RUN Control-Pago.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.NroPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.NroPed V-table-Win
ON LEAVE OF CcbCDocu.NroPed IN FRAME F-Main /* Pedido */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
  S-NROPED = STRING(I-SERPED,"999") + SELF:SCREEN-VALUE.
  FIND Faccpedm WHERE Faccpedm.CodCia = S-CODCIA AND
       Faccpedm.CodDoc = "P/M" AND
       Faccpedm.NroPed = S-NROPED NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccpedm THEN DO:
     MESSAGE "Numero de Pedido no existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY Faccpedm.CodCli @ CcbCDocu.CodCli.
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
          gn-clie.CodCli = Faccpedm.CodCli NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie THEN 
        DISPLAY gn-clie.NomCli @ F-NomCli 
                gn-clie.Ruc @ F-RucCli
                gn-clie.DirCli @ F-DirCli.
     IF Faccpedm.CodMon = 1 THEN DO:
        FILL-IN_ImpNac = Faccpedm.ImpTot.
        FILL-IN_ImpUsa = ROUND(Faccpedm.ImpTot / Faccpedm.TpoCmb,2).
     END.
     ELSE DO:
        FILL-IN_ImpNac = ROUND(Faccpedm.ImpTot * Faccpedm.TpoCmb,2).
        FILL-IN_ImpUsa = Faccpedm.ImpTot.
     END.
     DISPLAY FILL-IN_ImpNac
             FILL-IN_ImpUsa.
     CcbCDocu.CodMon:SCREEN-VALUE = STRING(Faccpedm.CodMon).
     FILL-IN_EfeNac:SENSITIVE = YES.
     FILL-IN_EfeUsa:SENSITIVE = YES.
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
  {src/adm/template/row-list.i "CcbCDocu"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbCDocu"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Control-Pago V-table-Win 
PROCEDURE Control-Pago :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
   ASSIGN FILL-IN_EfeNac FILL-IN_EfeUsa.
   IF FILL-IN_EfeNac > FILL-IN_ImpNac THEN
      FILL-IN_VueNac = FILL-IN_EfeNac - FILL-IN_ImpNac.
   IF FILL-IN_EfeUsa > FILL-IN_ImpUsa THEN
      FILL-IN_VueUsa = FILL-IN_EfeUsa - FILL-IN_ImpUsa.
   DISPLAY FILL-IN_VueNac
           FILL-IN_VueUsa.
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
FOR EACH Facdpedm NO-LOCK WHERE Facdpedm.CodCia = CcbCDocu.CodCia AND
         Facdpedm.CodDoc = "P/M" AND
         Facdpedm.NroPed = CcbCDocu.NroPed:
    CREATE CcbDDocu.
    ASSIGN
          CcbDDocu.CodCia = CcbCDocu.CodCia
          CcbDDocu.CodDoc = CcbCDocu.CodDoc 
          CcbDDocu.NroDoc = CcbCDocu.NroDoc 
          CcbDDocu.AftIgv = Facdpedm.AftIgv 
          CcbDDocu.AftIsc = Facdpedm.AftIsc 
          CcbDDocu.CanDes = Facdpedm.CanPed 
          CcbDDocu.codmat = Facdpedm.codmat 
          CcbDDocu.ImpDto = Facdpedm.ImpDto 
          CcbDDocu.ImpIgv = Facdpedm.ImpIgv 
          CcbDDocu.ImpIsc = Facdpedm.ImpIsc 
          CcbDDocu.ImpLin = Facdpedm.ImpLin 
          CcbDDocu.PorDto = Facdpedm.PorDto 
          CcbDDocu.PreBas = Facdpedm.PreBas 
          CcbDDocu.PreUni = Facdpedm.PreUni 
          CcbDDocu.UndVta = Facdpedm.UndVta
          CcbDDocu.Factor = Facdpedm.Factor.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Ingreso-Caja V-table-Win 
PROCEDURE Genera-Ingreso-Caja :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
   ASSIGN FILL-IN_EfeNac FILL-IN_EfeUsa FILL-IN_VueNac FILL-IN_VueUsa.
END.
RUN Numero-de-Ingreso-Caja.
DO TRANSACTION:
   CREATE CcbCCaja.
   ASSIGN CcbCCaja.CodCia = S-CODCIA
          CcbCCaja.CodDoc = "ICM"
          CcbCCaja.NroDoc = C-NROIC
          CcbCCaja.CodCli = CcbCDocu.CodCli
          CcbCCaja.CodMon = CcbCDocu.CodMon
          CcbCCaja.FchDoc = CcbCDocu.FchDoc
          CcbCCaja.FlgEst = "C"
          CcbCCaja.Glosa = CcbCDocu.Glosa
          CcbCCaja.Tipo = CcbCDocu.Tipo
          CcbCCaja.TpoCmb = CcbCDocu.TpoCmb
          CcbCCaja.ImpNac[1] = FILL-IN_EfeNac
          CcbCCaja.ImpUsa[1] = FILL-IN_EfeUsa
          CcbCCaja.usuario = CcbCDocu.Usuario
          CcbCCaja.VueNac = FILL-IN_VueNac 
          CcbCCaja.VueUsa = FILL-IN_VueUsa.
   CREATE CcbDCaja.
   ASSIGN CcbDCaja.CodCia = CcbCCaja.CodCia 
          CcbDCaja.CodDoc = CcbCCaja.CodDoc 
          CcbDCaja.NroDoc = CcbCCaja.NroDoc 
          CcbDCaja.CodRef = CcbCDocu.CodDoc
          CcbDCaja.NroRef = CcbCDocu.NroDoc
          CcbDCaja.ImpTot = CcbCDocu.ImpTot.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Movimiento-Almacen V-table-Win 
PROCEDURE Genera-Movimiento-Almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH CcbDDocu NO-LOCK WHERE 
         CcbDDocu.CodCia = CcbCDocu.CodCia AND
         CcbDDocu.CodDoc = CcbCDocu.CodDoc AND
         CcbDDocu.NroDoc = CcbCDocu.NroDoc:
    CREATE Almdmov.
    ASSIGN Almdmov.CodCia = CcbDDocu.CodCia
           Almdmov.TipMov = "S"
           Almdmov.CodMov = CcbCDocu.CodMov
           Almdmov.NroDoc = I-NRODOC
           Almdmov.NroSer = I-NROSER
           Almdmov.CodAlm = CcbCDocu.CodAlm
           Almdmov.CanDes = CcbDDocu.CanDes 
           Almdmov.codmat = CcbDDocu.codmat 
           Almdmov.CodMon = CcbCDocu.CodMon
           Almdmov.CodUnd = CcbDDocu.UndVta
           Almdmov.Factor = CcbDDocu.Factor 
           Almdmov.FchDoc = CcbCDocu.FchDoc.
    R-ROWID = ROWID(Almdmov).
    RUN ALM\ALMDGSTK (R-ROWID).
    RUN ALM\ALMACPR1 (R-ROWID,"U").
    RUN ALM\ALMACPR2 (R-ROWID,"U").

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
  
  RUN Numero-de-Documento(NO).
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY S-CODDOC @ CcbCDocu.CodDoc
             STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999") @ CcbCDocu.NroDoc
             FacCfgGn.Tpocmb[1] @ CcbCDocu.TpoCmb.
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
  RUN Numero-de-Documento(YES).
  ASSIGN CcbCDocu.CodCia  = S-CODCIA
         CcbCDocu.CodDoc  = S-CODDOC
         CcbCDocu.FchDoc  = TODAY
         CcbCDocu.FchCan  = TODAY 
         CcbCDocu.FchVto  = TODAY 
         CcbCDocu.NroDoc  = STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999")
         CcbCDocu.Usuario = S-USER-ID
         CcbCDocu.CodPed  = "P/M"
         CcbCDocu.CodMov  = I-CODMOV
         CcbCDocu.Tipo    = "MOSTRADOR"
         CcbCDocu.CodRef  = ""
         CcbCDocu.NroRef  = ""
         CcbCDocu.FlgEst  = "C"
         CcbCDocu.NroOrd  = "".
         
  FIND Faccpedm WHERE Faccpedm.CodCia = S-CODCIA AND
       Faccpedm.CodDoc = "P/M" AND
       Faccpedm.NroPed = CcbCDocu.NroPed NO-LOCK NO-ERROR.
  IF AVAILABLE Faccpedm THEN DO:
     ASSIGN CcbCDocu.CodVen = Faccpedm.CodVen
            CcbCDocu.TpoCmb = Faccpedm.TpoCmb
            CcbCDocu.CodCli = Faccpedm.CodCli
            CcbCDocu.CodMon = Faccpedm.CodMon
            CcbCDocu.CodAlm = Faccpedm.CodAlm
            CcbCDocu.ImpBrt = Faccpedm.ImpBrt 
            CcbCDocu.ImpDto = Faccpedm.ImpDto 
            CcbCDocu.ImpExo = Faccpedm.ImpExo 
            CcbCDocu.ImpIgv = Faccpedm.ImpIgv 
            CcbCDocu.ImpIsc = Faccpedm.ImpIsc 
            CcbCDocu.ImpTot = Faccpedm.ImpTot 
            CcbCDocu.ImpVta = Faccpedm.ImpVta 
            CcbCDocu.PorIgv = Faccpedm.PorIgv.
  END.
  DISPLAY CcbCDocu.NroDoc WITH FRAME {&FRAME-NAME}.
  
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
  
  DO WITH FRAME {&FRAME-NAME}:
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
          gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie THEN 
        DISPLAY gn-clie.NomCli @ F-NomCli 
                gn-clie.Ruc @ F-RucCli
                gn-clie.DirCli @ F-DirCli.
     FILL-IN_EfeNac:SENSITIVE = NO.
     FILL-IN_EfeUsa:SENSITIVE = NO.
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
  
  RUN Genera-Detalle.
  RUN Genera-Ingreso-Caja.
  RUN Genera-Movimiento-Almacen.
  RUN Emite-Orden-Despacho.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Numero-de-Documento V-table-Win 
PROCEDURE Numero-de-Documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER L-INCREMENTA AS LOGICAL.
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
       FacCorre.CodDoc = S-CODDOC AND
       FacCorre.NroSer = I-NROSER NO-ERROR.
  IF AVAILABLE FacCorre THEN DO:
     ASSIGN I-NroDoc = FacCorre.Correlativo.
     IF L-INCREMENTA THEN ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
  END.
  RELEASE FacCorre.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Numero-de-Ingreso-Caja V-table-Win 
PROCEDURE Numero-de-Ingreso-Caja :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND FacDoxUs WHERE FacDoxUs.CodCia = S-CODCIA AND
     FacDoxUs.Usuario = S-USER-ID AND
     FacDoxUs.CodDiv = S-CODDIV AND
     FacDoxUs.CodDoc = "ICM" NO-LOCK NO-ERROR.
IF AVAILABLE FacDoxUs THEN DO:
   FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
        FacCorre.CodDoc = "ICM" AND
        FacCorre.NroSer = FacDoxUs.NroSer NO-ERROR.
   IF AVAILABLE FacCorre THEN DO:
      C-NROIC = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999").
      FacCorre.Correlativo = FacCorre.Correlativo + 1.
   END.
   RELEASE FacCorre.
END.
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
        WHEN "NroPed" THEN ASSIGN input-var-1 = STRING(I-SERPED,"999").
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
  {src/adm/template/snd-list.i "CcbCDocu"}

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
DO WITH FRAME {&FRAME-NAME} :
   ASSIGN FILL-IN_EfeNac FILL-IN_EfeUsa.
   IF CcbCDocu.NroPed:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Campo no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO CcbCDocu.NroPed.
      RETURN "ADM-ERROR".   
   END.
   IF FILL-IN_ImpNac - (FILL-IN_EfeNac + ROUND(FILL-IN_EfeUsa * FacCfgGn.Tpocmb[1],2)) > 0 THEN DO:
      MESSAGE "Cancelacion es menor que el importe total" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO FILL-IN_EfeNac.
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

RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

