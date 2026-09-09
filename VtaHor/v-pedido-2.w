&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDI LIKE FacDPedi.



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
/* {lib/def-prn.i} */
DEFINE STREAM report.
/* Public Variable Definitions ---       
                                */
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER   INITIAL 1.
DEFINE SHARED VARIABLE S-CODDOC   AS CHARACTER INITIAL "PED".
DEFINE SHARED VARIABLE S-CODALM   AS CHARACTER INITIAL "15".
DEFINE SHARED VARIABLE S-NomCia   AS CHARACTER.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-USER-ID  AS CHARACTER.
DEFINE SHARED VARIABLE S-TERMINAL AS CHARACTER.
DEFINE SHARED VARIABLE S-CODDIV   AS CHARACTER INITIAL "00015".
DEFINE SHARED VARIABLE CL-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE PV-codcia  AS INTEGER.
DEFINE SHARED VARIABLE s-CodCli   AS CHAR.
DEFINE SHARED VARIABLE s-NroCot   AS CHAR.
DEFINE SHARED VARIABLE S-NROPED   AS CHAR.
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER.
DEFINE SHARED VARIABLE S-CNDVTA   AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB   AS DEC.
DEFINE SHARED VARIABLE S-PORDTO   AS DEC.

DEFINE SHARED VARIABLE S-PRECOT AS LOG.

FIND Empresas WHERE Empresas.codcia = s-CodCia NO-LOCK NO-ERROR.
IF NOT Empresas.Campo-CodCli THEN CL-CODCIA = s-CodCia.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE I-NroItm       AS INTEGER   NO-UNDO.
DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-NROPED       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
/*DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.*/
DEFINE VARIABLE T-SALDO        AS DECIMAL.
DEFINE VARIABLE F-totdias      AS INTEGER NO-UNDO.
DEFINE VARIABLE w-import       AS INTEGER NO-UNDO.
DEFINE VARIABLE F-Observa      AS CHAR NO-UNDO.
DEFINE VARIABLE dImpLCred      LIKE Gn-ClieL.ImpLC NO-UNDO.
DEFINE VARIABLE lEnCampan      AS LOGICAL NO-UNDO.
DEFINE VARIABLE X-NomCia       AS CHARACTER.
DEFINE VARIABLE X-CodDoc       AS CHARACTER INITIAL "PED".
DEFINE VARIABLE ped            AS CHARACTER.
DEFINE VARIABLE npage          AS INTEGER  NO-UNDO.
DEFINE VARIABLE c-items        AS INTEGER  NO-UNDO.
DEFINE VARIABLE clave AS CHARACTER FORMAT "x(20)" LABEL "Clave" NO-UNDO.
FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
               AND  FacCorre.CodDoc = S-CODDOC 
               AND  FacCorre.CodDiv = S-CODDIV
               AND  FacCorre.CodAlm = S-CodAlm 
               NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN I-NroSer = FacCorre.NroSer
          /*S-PRINTER-NAME = FacCorre.Printer*/ .

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEF BUFFER COTIZACION FOR FacCPedi.
DEF BUFFER B-DPEDI FOR FacDPedi.
DEF BUFFER B-CPedi FOR FacCPedi.
/*
DEFINE BUFFER B-CCB FOR CcbCDocu.
*/

DEFINE NEW SHARED VAR input-var-4 AS CHAR.

DEFINE TEMP-TABLE Reporte
    FIELDS NroPed   LIKE FacCPedi.NroPed
    FIELDS CodMat   LIKE FacDPedi.CodMat
    FIELDS DesMat   LIKE Almmmatg.DesMat
    FIELDS DesMar   LIKE Almmmatg.DesMar
    FIELDS UndBas   LIKE Almmmatg.UndBas
    FIELDS CanPed   LIKE FacDPedi.CanPed
    FIELDS CodUbi   LIKE Almmmate.CodUbi
    FIELDS X-TRANS  LIKE FacCPedi.Libre_c01
    FIELDS X-DIREC  LIKE FACCPEDI.Libre_c02
    FIELDS X-LUGAR  LIKE FACCPEDI.Libre_c03
    FIELDS X-CONTC  LIKE FACCPEDI.Libre_c04
    FIELDS X-HORA   LIKE FACCPEDI.Libre_c05
    FIELDS X-FECHA  LIKE FACCPEDI.Libre_f01
    FIELDS X-OBSER  LIKE FACCPEDI.Observa
    FIELDS X-Glosa  LIKE FACCPEDI.Glosa
    FIELDS X-codcli LIKE FACCPEDI.CodCli
    FIELDS X-NomCli LIKE FACCPEDI.NomCli
    FIELDS CodAlm   LIKE Faccpedi.codalm.

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
&Scoped-Define ENABLED-FIELDS FacCPedi.TipVta FacCPedi.Atencion ~
FacCPedi.CodCli FacCPedi.NroRef FacCPedi.NomCli FacCPedi.TpoCmb ~
FacCPedi.RucCli FacCPedi.fchven FacCPedi.NroCard FacCPedi.FchEnt ~
FacCPedi.DirCli FacCPedi.CodPos FacCPedi.CodVen FacCPedi.CodMon ~
FacCPedi.FmaPgo FacCPedi.Glosa 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define ENABLED-OBJECTS RECT-21 
&Scoped-Define DISPLAYED-FIELDS FacCPedi.TipVta FacCPedi.Atencion ~
FacCPedi.CodCli FacCPedi.NroRef FacCPedi.NroPed FacCPedi.FchPed ~
FacCPedi.NomCli FacCPedi.TpoCmb FacCPedi.RucCli FacCPedi.fchven ~
FacCPedi.NroCard FacCPedi.FchEnt FacCPedi.DirCli FacCPedi.CodPos ~
FacCPedi.CodVen FacCPedi.CodMon FacCPedi.FmaPgo FacCPedi.Glosa 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS F-Estado F-Nomtar FILL-IN-Postal F-nOMvEN ~
F-CndVta F-Situacion 

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
     SIZE 33 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE F-Nomtar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 53 BY .81 NO-UNDO.

DEFINE VARIABLE F-nOMvEN AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 59 BY .81 NO-UNDO.

DEFINE VARIABLE F-Situacion AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-Postal AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 107 BY 7.69.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.TipVta AT ROW 4.27 COL 90 NO-LABEL WIDGET-ID 4
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Factura", "1":U,
"Boleta", "2":U
          SIZE 17 BY .81
     FacCPedi.Atencion AT ROW 2.73 COL 26 COLON-ALIGNED
          LABEL "DNI" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 15 FGCOLOR 12 
     FacCPedi.CodCli AT ROW 1.96 COL 9 COLON-ALIGNED HELP
          ""
          LABEL "Código" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.NroRef AT ROW 6.19 COL 88 COLON-ALIGNED
          LABEL "Cotización" FORMAT "X(11)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.NroPed AT ROW 1.19 COL 9 COLON-ALIGNED
          LABEL "Número" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .81
          BGCOLOR 15 FGCOLOR 1 FONT 0
     F-Estado AT ROW 1.19 COL 39 COLON-ALIGNED NO-LABEL
     FacCPedi.FchPed AT ROW 1.19 COL 88 COLON-ALIGNED
          LABEL "Fecha"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.NomCli AT ROW 1.96 COL 22 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 52 BY .81
     FacCPedi.TpoCmb AT ROW 1.96 COL 88 COLON-ALIGNED
          LABEL "T/  Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.RucCli AT ROW 2.73 COL 9 COLON-ALIGNED
          LABEL "RUC"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.fchven AT ROW 2.73 COL 88 COLON-ALIGNED
          LABEL "Vencimiento" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.NroCard AT ROW 3.5 COL 9 COLON-ALIGNED
          LABEL "Nro.Tarjeta"
          VIEW-AS FILL-IN 
          SIZE 11.57 BY .81
     F-Nomtar AT ROW 3.5 COL 21 COLON-ALIGNED NO-LABEL
     FacCPedi.FchEnt AT ROW 3.5 COL 88 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.DirCli AT ROW 4.27 COL 9 COLON-ALIGNED
          LABEL "Dirección"
          VIEW-AS FILL-IN 
          SIZE 65 BY .81
     FacCPedi.CodPos AT ROW 5.04 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FILL-IN-Postal AT ROW 5.04 COL 15 COLON-ALIGNED NO-LABEL
     FacCPedi.CodVen AT ROW 5.81 COL 9 COLON-ALIGNED FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
     F-nOMvEN AT ROW 5.81 COL 15 COLON-ALIGNED NO-LABEL
     FacCPedi.CodMon AT ROW 5.23 COL 90 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.57 BY .81
     FacCPedi.FmaPgo AT ROW 6.58 COL 9 COLON-ALIGNED
          LABEL "Cond.Vta" FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
     F-CndVta AT ROW 6.58 COL 15 COLON-ALIGNED NO-LABEL
     FacCPedi.Glosa AT ROW 7.35 COL 6.28
          VIEW-AS FILL-IN 
          SIZE 65 BY .81
     F-Situacion AT ROW 1.19 COL 55 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 5.23 COL 83
     "Tipo Venta:" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 4.5 COL 81 WIDGET-ID 8
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
      TABLE: PEDI T "SHARED" ? INTEGRAL FacDPedi
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
         WIDTH              = 115.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
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

/* SETTINGS FOR FILL-IN FacCPedi.Atencion IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
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
/* SETTINGS FOR FILL-IN F-Situacion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FchPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.fchven IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
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
/* SETTINGS FOR FILL-IN FacCPedi.NroRef IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.RucCli IN FRAME F-Main
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME FacCPedi.TipVta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.TipVta V-table-Win
ON VALUE-CHANGED OF FacCPedi.TipVta IN FRAME F-Main /* Tipo venta */
DO:
  IF SELF:SCREEN-VALUE = '1' 
  THEN ASSIGN
        Faccpedi.atencion:SENSITIVE = NO
        Faccpedi.atencion:SCREEN-VALUE = ''
        Faccpedi.nomcli:SENSITIVE = NO
        Faccpedi.dircli:SENSITIVE = NO.
  ELSE ASSIGN 
        Faccpedi.atencion:SENSITIVE = YES
        Faccpedi.nomcli:SENSITIVE = YES
        FAccpedi.dircli:SENSITIVE = YES.
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

  FOR EACH facdPedi OF faccPedi NO-LOCK ON ERROR UNDO, RETURN 'ADM-ERROR':
      FIND B-DPedi WHERE B-DPedi.CodCia = faccPedi.CodCia 
                    AND  B-DPedi.CodDoc = "COT" 
                    AND  B-DPedi.NroPed = FacCPedi.NroRef   
                    AND  B-DPedi.CodMat = FacDPedi.CodMat 
                   EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE B-DPedi THEN UNDO, RETURN 'ADM-ERROR'.
      B-DPedi.CanAte = B-DPedi.CanAte + FacDPedi.CanPed.
      RELEASE B-DPedi.
  END.
  FOR EACH FacDPedi NO-LOCK WHERE FacDPedi.CodCia = S-CODCIA 
                             AND  FacDPedi.CodDoc = "COT" 
                             AND  FacDPedi.NroPed = FacCPedi.NroRef:     
      IF (FacDPedi.CanPed - FacDPedi.CanAte) > 0 
      THEN DO:
         I-NRO = 1.
         LEAVE.
      END.
  END.
  /* RHC 22-03-2003 */
  FIND B-CPedi WHERE B-CPedi.CodCia = FacCPedi.CodCia
        AND  B-CPedi.CodDiv = FacCPedi.CodDiv
        AND  B-CPedi.CodDoc = "COT" 
        AND  B-CPedi.NroPed = FacCPedi.NroRef
        EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE B-CPedi THEN UNDO, RETURN 'ADM-ERROR'.
  IF I-NRO = 0 
  THEN ASSIGN B-CPedi.FlgEst = "C".
  ELSE ASSIGN B-CPedi.FlgEst = "P".
  RELEASE B-CPedi.

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
  FOR EACH PEDI:
    DELETE PEDI.
  END.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  /* RHC 15.11.05 MANTENER LAS CANTIDADES ATENDIDAS */
  IF RETURN-VALUE = 'NO' THEN DO:
    FOR EACH facdPedi OF faccPedi NO-LOCK:
        CREATE PEDI.
        BUFFER-COPY FacDPedi TO PEDI.
    END.
  END.
/*  IF RETURN-VALUE = 'NO' THEN DO:
 *     FOR EACH facdPedi OF faccPedi NO-LOCK:
 *         CREATE PEDI.
 *         BUFFER-COPY FacDPedi TO PEDI
 *             ASSIGN PEDi.CanAte = 0.
 *     END.
 *   END.*/
  
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
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE F-CANPED AS DECIMAL NO-UNDO.
  DEFINE VARIABLE S-STKDIS AS DECIMAL NO-UNDO.
  DEFINE VARIABLE S-OK     AS LOGICAL NO-UNDO.
  DEFINE VARIABLE F-FACTOR AS DECIMAL NO-UNDO.
  DEFINE VARIABLE X-CANPED AS DECIMAL NO-UNDO.
  DEFINE VARIABLE f-PreBas AS DECIMAL NO-UNDO.
  DEFINE VARIABLE f-PreVta AS DECIMAL NO-UNDO.
  DEFINE VARIABLE f-Dsctos AS DECIMAL NO-UNDO.
  DEFINE VARIABLE y-Dsctos AS DECIMAL NO-UNDO.

  DEFINE FRAME F-MENSAJE
    SPACE(1) SKIP
    'Procesando: ' facdpedi.codmat SKIP
    'Un momento por favor...' SKIP
    SPACE(1) SKIP
    WITH OVERLAY CENTERED NO-LABELS VIEW-AS DIALOG-BOX TITLE 'Procesando Cotizacion'.

  DO WITH FRAME {&FRAME-NAME}:  
    FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
        AND FacCorre.CodDoc = S-CODDOC 
        AND FacCorre.CodDiv = S-CODDIV 
        AND Faccorre.Codalm = S-CodAlm
        NO-LOCK NO-ERROR.
    FacCPedi.NroPed:SCREEN-VALUE = STRING(FacCorre.NroSer, '999') +
                                    STRING(FacCorre.Correlativo, '999999').
    ASSIGN
        F-NomVen:SCREEN-VALUE = ""
        F-CndVta:SCREEN-VALUE = "".
    FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
        AND  gn-ven.CodVen = COTIZACION.CodVen 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN F-NomVen:SCREEN-VALUE = gn-ven.NomVen.
    FIND gn-convt WHERE gn-convt.Codig = COTIZACION.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
    ASSIGN
        FacCPedi.CodCli:SCREEN-VALUE = COTIZACION.CodCli
        FacCPedi.NomCli:SCREEN-VALUE = COTIZACION.NomCli
        FacCPedi.DirCli:SCREEN-VALUE = COTIZACION.DirCli
        FacCPedi.FchPed:SCREEN-VALUE = STRING(TODAY)
        FacCPedi.RucCli:SCREEN-VALUE = COTIZACION.RucCli
        FacCPedi.FchEnt:SCREEN-VALUE = STRING(COTIZACION.FchEnt)
        FacCPedi.FchVen:SCREEN-VALUE = STRING(COTIZACION.FchVen)
        FacCPedi.TpoCmb:SCREEN-VALUE = STRING(COTIZACION.TpoCmb)
        FacCPedi.NroCard:SCREEN-VALUE = COTIZACION.NroCard
        FacCPedi.FmaPgo:SCREEN-VALUE = COTIZACION.FmaPgo
        FaccPedi.CodVen:SCREEN-VALUE = COTIZACION.CodVen
        FacCPedi.CodPos:SCREEN-VALUE = COTIZACION.CodPos
        FaccPedi.CodMon:SCREEN-VALUE = STRING(COTIZACION.CodMon)
        FacCPedi.NroRef:SCREEN-VALUE = COTIZACION.NroPed
        FacCPedi.Glosa:SCREEN-VALUE  = COTIZACION.Glosa
        FacCPedi.TipVta:SCREEN-VALUE = STRING(COTIZACION.TipVta).
/*     c-TpoVta:SCREEN-VALUE = ENTRY(INTEGER(COTIZACION.TipVta), c-TpoVta:LIST-ITEMS). */
      
    /* DETALLES */
    FOR EACH PEDI:
        DELETE PEDI.
    END.
    FOR EACH FacDPedi OF COTIZACION WHERE (FacDPedi.CanPed - FacDPedi.CanAte) > 0 NO-LOCK:
        DISPLAY Facdpedi.codmat WITH FRAME F-Mensaje.
        F-CANPED = (FacDPedi.CanPed - FacDPedi.CanAte).
        RUN vtamay/stkdispo (s-codcia, 
                          FacDPedi.AlmDes, 
                          FacDPedi.codmat, 
                          FacDPedi.Factor * F-CANPED ,
                          OUTPUT S-OK, 
                          OUTPUT S-STKDIS
                          ).
        IF NOT S-OK THEN F-CANPED = S-STKDIS / FacDPedi.Factor.  /* OJO RHC 22-12-2003 */
        IF F-CANPED > 0 
        THEN DO:
            CREATE PEDI.
            BUFFER-COPY FacDPedi EXCEPT FacDPedi.CanAte TO PEDI
                ASSIGN PEDI.CanPed = F-CanPed.
            IF PEDI.CanPed <> facdPedi.CanPed THEN DO:
                FIND Almmmatg WHERE Almmmatg.CodCia = PEDI.CodCia 
                               AND  Almmmatg.codmat = PEDI.codmat 
                              NO-LOCK NO-ERROR.
                ASSIGN
                  PEDI.ImpDto = ROUND( PEDI.PreUni * PEDI.CanPed * (PEDI.Por_Dsctos[1] / 100),4 )
                  PEDI.ImpLin = ROUND( PEDI.PreUni * PEDI.CanPed , 2 ) - PEDI.ImpDto.
                IF PEDI.AftIsc THEN 
                   PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
                IF PEDI.AftIgv THEN  
                   PEDI.ImpIgv = PEDI.ImpLin - ROUND(PEDI.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
 
                /* ************* RECALCULO DE PRECIOS ***************** */                
                IF S-PRECOT = NO THEN DO:
                    MESSAGE "El Precio del Articulo  " PEDI.Codmat  SKIP
                           "Sera recalculado........."
                           VIEW-AS ALERT-BOX WARNING.
                    ASSIGN
                        f-Factor = Pedi.Factor
                        x-CanPed = Pedi.CanPed.
                    RUN vtamay/PrecioVenta (s-CodCia,
                                        s-CodDiv,
                                        s-CodCli,
                                        s-CodMon,
                                        s-TpoCmb,
                                        f-Factor,
                                        Almmmatg.CodMat,
                                        s-CndVta,
                                        x-CanPed,
                                        4,
                                        OUTPUT f-PreBas,
                                        OUTPUT f-PreVta,
                                        OUTPUT f-Dsctos,
                                        OUTPUT y-Dsctos).
                   ASSIGN  
                        PEDI.PreUni = F-PREVTA
                        PEDI.PreBas = F-PREBAS
                        PEDI.PorDto = F-DSCTOS
                        PEDI.Por_DSCTOS[2] = Almmmatg.PorMax
                        PEDI.Por_Dsctos[3] = Y-DSCTOS 
                        PEDI.ImpDto = ROUND( PEDI.PreUni * PEDI.CanPed * (PEDI.Por_Dsctos[1] / 100),4 ).
                        PEDI.ImpLin = ROUND( PEDI.PreUni * PEDI.CanPed , 2 ) - PEDI.ImpDto.
                        IF PEDI.AftIsc THEN
                           PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
                        IF PEDI.AftIgv THEN
                           PEDI.ImpIgv = PEDI.ImpLin - ROUND(PEDI.ImpLin  / (1 + (COTIZACION.PorIgv / 100)),4).
                END.    /* FIN DE RECALCULO DE PRECIOS */
            END.
        END.
    END.   /* FIN DE CARGA DE DETALLES */
  END.
  HIDE FRAME F-Mensaje.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna_datos V-table-Win 
PROCEDURE Asigna_datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF NOT AVAILABLE FacCPedi THEN DO:
        MESSAGE 'Pedido NO Disponible'  VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.                                                        

    IF FaccPedi.FchVen < TODAY THEN DO:
       MESSAGE 'Pedido NO disponible' VIEW-AS ALERT-BOX ERROR.
       UNDO, RETURN 'ADM-ERROR'.
    END.
    IF FacCPedi.FlgEst <> "A" THEN RUN vtaexp\w-agtrans(ROWID(FacCPedi)).
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
  DEF INPUT PARAMETER pOk AS LOG.
  
  FOR EACH FacDPedi OF FacCPedi ON ERROR UNDO, RETURN 'ADM-ERROR'
        ON STOP UNDO, RETURN 'ADM-ERROR':
    /* BORRAMOS SALDO EN LAS COTIZACIONES */
    FIND B-DPedi WHERE B-DPedi.CodCia = FacCPedi.CodCia 
        AND  B-DPedi.CodDoc = "COT" 
        AND  B-DPedi.NroPed = FacCPedi.NroRef
        AND  B-DPedi.CodMat = FacDPedi.CodMat 
        EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE B-DPedi THEN DO:
        B-DPedi.CanAte = B-DPedi.CanAte - FacDPedi.CanPed.
        RELEASE B-DPedi.
    END.
    IF pOk = YES THEN DELETE FacDPedi.
  END.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal V-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUFFER b-CPedi FOR FacCPedi.

    DEFINE VAR conta AS INTEGER NO-UNDO INIT 0.
    FOR EACH reporte.
        DELETE Reporte.
    END.

    ped = FacCPedi.NroPed.
    FOR EACH b-CPedi NO-LOCK WHERE b-CPedi.CodCia = s-codcia 
        AND b-CPedi.CodDiv =  s-CodDiv                     
        AND b-CPedi.CodDoc =  x-CodDoc                     
        /*AND b-CPedi.CodAlm =  s-CodAlm */
        AND b-CPedi.NroPed =  PED:                         
        FOR EACH FacDPedi OF b-CPedi NO-LOCK,
            FIRST Almmmatg WHERE Almmmatg.CodCia = b-CPedi.CodCia
            AND Almmmatg.CodMat = FacDPedi.CodMat NO-LOCK,
            FIRST Almmmate NO-LOCK WHERE Almmmate.CodCia = b-CPedi.CodCia
            AND Almmmate.CodAlm = b-CPedi.CodAlm
            AND Almmmate.CodMat = FacDPedi.CodMat
            BREAK BY Almmmate.CodUbi
            BY FacDPedi.CodMat:
            conta = conta + 1.
            CREATE Reporte.
            ASSIGN 
                Reporte.NroPed   = b-CPedi.NroPed
                Reporte.CodMat   = FacDPedi.CodMat
                Reporte.DesMat   = Almmmatg.DesMat
                Reporte.DesMar   = Almmmatg.DesMar
                Reporte.UndBas   = Almmmatg.UndBas
                Reporte.CanPed   = FacDPedi.CanPed
                Reporte.CodUbi   = Almmmate.CodUbi
                Reporte.X-TRANS  = b-CPedi.Libre_c01
                Reporte.X-DIREC  = b-CPedi.Libre_c02
                Reporte.X-LUGAR  = b-CPedi.Libre_c03
                Reporte.X-CONTC  = b-CPedi.Libre_c04
                Reporte.X-HORA   = b-CPedi.Libre_c05
                Reporte.X-FECHA  = b-CPedi.Libre_f01
                Reporte.X-OBSER  = b-CPedi.Observa
                Reporte.X-Glosa  = b-CPedi.Glosa
                Reporte.X-nomcli = b-CPedi.codcli
                Reporte.X-NomCli = b-CPedi.NomCli
                Reporte.CodAlm   = b-CPedi.CodAlm.
        END.
    END.
    npage = DECIMAL(conta / c-items ) - INTEGER(conta / c-items).
    IF npage < 0 THEN npage = INTEGER(conta / c-items).
    ELSE npage = INTEGER(conta / c-items) + 1. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clave V-table-Win 
PROCEDURE clave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /*IF MONTH(FacCPedi.FchPed) <> MONTH(TODAY) 
     OR YEAR(FacCPedi.FchPed) <> YEAR(TODAY) THEN DO:*/
    /* {VtaExp/i-DocPssw.i /*s-CodCia s-CodDoc ""DEL""*/ }*/
  /*END.*/
  
  
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Envia_chequeo V-table-Win 
PROCEDURE Envia_chequeo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 IF NOT AVAILABLE FacCPedi THEN DO:
        MESSAGE 'Pedido NO Disponible'  VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.                                                        
 IF FaccPedi.FchVen < TODAY THEN DO:
       MESSAGE 'Pedido NO disponible' VIEW-AS ALERT-BOX ERROR.
       UNDO, RETURN 'ADM-ERROR'.
 END.

 FIND B-CPedi WHERE ROWID(B-CPedi) = ROWID(FacCPedi) EXCLUSIVE-LOCK NO-ERROR.
 IF AVAILABLE B-CPEDI THEN DO:
     IF FacCPedi.FlgEst = "P" AND FacCPedi.FlgSit = "" THEN DO:
        clave = "".
        UPDATE
            SKIP(.5)
            SPACE(2)
            clave PASSWORD-FIELD
            SPACE(2)
            SKIP(.5)
            WITH CENTERED VIEW-AS DIALOG-BOX THREE-D
            SIDE-LABEL TITLE "Ingrese Clave".
        IF clave = "pcl" THEN DO:
            ASSIGN
                B-CPedi.FlgSit = "X".                   /* X --> POR CHEQUEAR*/
        END.
        ELSE DO:
            RELEASE B-CPEDI.
            MESSAGE
                "CLAVE DE CREACION INCORRECTA"
                VIEW-AS ALERT-BOX ERROR.
                RETURN "ADM-ERROR".
        END.
      END.
 END.
 RELEASE B-CPEDI.
 RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1 V-table-Win 
PROCEDURE Formato1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE conta    AS INTEGER NO-UNDO INIT 1.    
DEFINE VARIABLE X-Nombre LIKE gn-prov.NomPro.
DEFINE VARIABLE X-ruc    LIKE gn-prov.Ruc.
DEFINE VARIABLE x-Postal AS CHAR NO-UNDO.

FIND almtabla WHERE almtabla.tabla = 'CP'
    AND almtabla.codigo = faccpedi.codpos
    NO-LOCK NO-ERROR.
IF AVAILABLE almtabla
THEN x-Postal = almtabla.nombre.
ELSE x-Postal = ''.

FIND gn-prov WHERE 
          gn-prov.CodCia = PV-CODCIA AND
          gn-prov.CodPro = Reporte.X-TRANS 
          NO-LOCK NO-ERROR.
IF AVAILABLE gn-prov THEN                                     
          ASSIGN 
                X-Nombre = gn-prov.NomPro
                X-ruc    = gn-prov.Ruc.
DEFINE FRAME F-FtrPed
       HEADER
       'PRIMER TRAMO  : '    
       'SEGUNDO TRAMO  : '  AT 83 SKIP
       'Transport: ' X-Nombre FORMAT 'X(50)'
       'Destino  : ' AT 83 Reporte.X-LUGAR  FORMAT 'X(50)' SKIP
       'RUC      : ' X-ruc    FORMAT 'X(11)'
       'Contacto : ' AT 83 Reporte.X-CONTC FORMAT 'X(35)' SKIP
       'Dirección: ' Reporte.X-DIREC  FORMAT 'X(50)' 
       'Hora Aten :' AT 83 Reporte.X-HORA FORMAT 'X(10)' {&PRN6A} "Fecha Entrega : "  Reporte.X-FECHA {&PRN6B} SKIP /*{&PRN4} + {&PRN6A} + "Fecha Entrega : " + Reporte.X-FECHA + {&PRN6B} + {&PRN3} SKIP*/
       "OBSERVACIONES : " Reporte.X-OBSER VIEW-AS TEXT FORMAT "X(80)" SKIP
       "GLOSA         : " Reporte.X-Glosa VIEW-AS TEXT FORMAT "X(80)" SKIP
       "                                                  " SKIP
       "                                                  " SKIP
       "                                                  " SKIP
       "                                                      -------------------     -------------------    -------------------" SKIP
       "                                                          Operador(a)         VoBo Jefe de Ventas       VoBo Cta.Cte.   " SKIP
       "HORA : " AT 1 STRING(TIME,"HH:MM")  S-USER-ID TO 67 SKIP(1) 
       WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 160.

DEFINE FRAME f-cab
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
        {&PRN4} + {&PRN6A} + " Fecha : " AT 1 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "N° Pedido: " + Reporte.NroPed  + {&PRN6B} + {&PRN7B} + {&PRN3} AT 90 FORMAT "X(30)" SKIP  
        {&PRN3} + {&PRN7A} + {&PRN6B} + "  Almacen: " + Reporte.CodAlm  + {&PRN6B} + {&PRN7B} + {&PRN3} AT 90 FORMAT "X(30)" SKIP  
        "Fecha del Pedido: " AT 10 Faccpedi.fchped SKIP
        "Codigo: " AT 10 faccpedi.CodCli FORMAT "x(15)" "Cliente: " AT 35 FacCPedi.NomCli SKIP
        "Postal: " AT 10 x-Postal FORMAT 'x(30)' SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación            " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH PAGE-TOP WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

DEFINE FRAME f-det
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
FOR EACH Reporte BREAK BY Reporte.NroPed BY Reporte.CodUbi:
         VIEW STREAM Report FRAME F-Cab.
         VIEW STREAM Report FRAME F-FtrPed. 
         DISPLAY STREAM Report 
                Reporte.CodMat 
                Reporte.DesMat
                Reporte.DesMar
                Reporte.UndBas
                Reporte.CanPed
                Reporte.CodUbi
                WITH FRAME f-det.
         IF LAST-OF(Reporte.NroPed) THEN DO:
                PAGE STREAM Report.
                HIDE STREAM REPORT FRAME F-FtrPed .
         END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato2 V-table-Win 
PROCEDURE Formato2 PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE conta    AS INTEGER NO-UNDO INIT 1.    
DEFINE VARIABLE X-Nombre LIKE gn-prov.NomPro.
DEFINE VARIABLE X-ruc    LIKE gn-prov.Ruc.

FIND gn-prov WHERE 
          gn-prov.CodCia = PV-CODCIA AND
          gn-prov.CodPro = Reporte.X-TRANS 
          NO-LOCK NO-ERROR.
IF AVAILABLE gn-prov THEN                                     
          ASSIGN 
                X-Nombre = gn-prov.NomPro
                X-ruc    = gn-prov.Ruc.
DEFINE FRAME f-cab
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)"
        {&PRN4} + {&PRN6A} + " Fecha : " AT 1 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "N° Pedido: " + Reporte.NroPed  + {&PRN6B} + {&PRN7B} + {&PRN3} AT 90 FORMAT "X(30)" SKIP  
        "Codigo: " faccpedi.CodCli AT 10  FORMAT "x(15)" "Cliente: " FacCPedi.NomCli AT 35 SKIP(2)
        "----------------------------------------------------------------------------------------------------------------------------------------" SKIP(2)
        'PRIMER TRAMO  : ' SKIP   
        'Transport: ' X-Nombre FORMAT 'X(50)' SKIP
        'RUC      : ' X-ruc    FORMAT 'X(11)' SKIP
        'Dirección: ' Reporte.X-DIREC  FORMAT 'X(50)' SKIP(2)
        "----------------------------------------------------------------------------------------------------------------------------------------" SKIP(2)
        'SEGUNDO TRAMO  : '  SKIP
        'Destino  : ' Reporte.X-LUGAR  FORMAT 'X(50)' SKIP
        'Contacto : ' Reporte.X-CONTC  FORMAT 'X(35)' SKIP
        'Hora Aten :' Reporte.X-HORA   FORMAT 'X(10)' SKIP 
        {&PRN6A} "Fecha Entrega : "  Reporte.X-FECHA {&PRN6B} SKIP(2) 
        "OBSERVACIONES : " Reporte.X-OBSER VIEW-AS TEXT FORMAT "X(80)" SKIP
        "GLOSA         : " Reporte.X-Glosa VIEW-AS TEXT FORMAT "X(80)" SKIP
        WITH PAGE-TOP WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

DEFINE FRAME f-det
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
FOR EACH Reporte BREAK BY Reporte.NroPed BY Reporte.CodUbi:
         VIEW STREAM Report FRAME F-Cab.
         VIEW STREAM Report FRAME F-FtrPed. 
         IF LAST-OF(Reporte.NroPed) THEN DO:
                PAGE STREAM Report.
                HIDE STREAM REPORT FRAME F-FtrPed .
         END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato2-otro V-table-Win 
PROCEDURE Formato2-otro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE conta    AS INTEGER NO-UNDO INIT 1.    
DEFINE VARIABLE X-Nombre LIKE gn-prov.NomPro.
DEFINE VARIABLE X-ruc    LIKE gn-prov.Ruc.

FIND gn-prov WHERE 
          gn-prov.CodCia = PV-CODCIA AND
          gn-prov.CodPro = Reporte.X-TRANS 
          NO-LOCK NO-ERROR.
IF AVAILABLE gn-prov THEN                                     
          ASSIGN 
                X-Nombre = gn-prov.NomPro
                X-ruc    = gn-prov.Ruc.
/*DEFINE FRAME F-FtrPed
       HEADER
       'PRIMER TRAMO  : '    
       'SEGUNDO TRAMO  : '  AT 83 SKIP
       'Transport: ' X-Nombre FORMAT 'X(50)'
       'Destino  : ' AT 83 Reporte.X-LUGAR  FORMAT 'X(50)' SKIP
       'RUC      : ' X-ruc    FORMAT 'X(11)'
       'Contacto : ' AT 83 Reporte.X-CONTC FORMAT 'X(35)' SKIP
       'Dirección: ' Reporte.X-DIREC  FORMAT 'X(50)' 
       'Hora Aten :' AT 83 Reporte.X-HORA FORMAT 'X(10)' {&PRN6A} "Fecha Entrega : "  Reporte.X-FECHA {&PRN6B} SKIP /*{&PRN4} + {&PRN6A} + "Fecha Entrega : " + Reporte.X-FECHA + {&PRN6B} + {&PRN3} SKIP*/
       "OBSERVACIONES : " Reporte.X-OBSER VIEW-AS TEXT FORMAT "X(80)" SKIP
       "GLOSA         : " Reporte.X-Glosa VIEW-AS TEXT FORMAT "X(80)" SKIP
       "                                                  " SKIP
       "                                                  " SKIP
       "                                                  " SKIP
       "                                                  " SKIP
       "                                                      -------------------     -------------------    -------------------" SKIP
       "                                                          Operador(a)         VoBo Jefe de Ventas       VoBo Cta.Cte.   " SKIP
       "HORA : " AT 1 STRING(TIME,"HH:MM")  S-USER-ID TO 67 SKIP  
       WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 160.*/

DEFINE FRAME f-cab
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
        {&PRN4} + {&PRN6A} + " Fecha : " AT 1 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "N° Pedido: " + Reporte.NroPed  + {&PRN6B} + {&PRN7B} + {&PRN3} AT 90 FORMAT "X(30)" SKIP  
        "Codigo: " faccpedi.CodCli AT 10  FORMAT "x(15)" "Cliente: " FacCPedi.NomCli AT 35 SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
        /*"Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación            " SKIP*/
        "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
        'PRIMER TRAMO  : '    
       'SEGUNDO TRAMO  : '  AT 83 SKIP
       'Transport: ' X-Nombre FORMAT 'X(50)'
       'Destino  : ' AT 83 Reporte.X-LUGAR  FORMAT 'X(50)' SKIP
       'RUC      : ' X-ruc    FORMAT 'X(11)'
       'Contacto : ' AT 83 Reporte.X-CONTC FORMAT 'X(35)' SKIP
       'Dirección: ' Reporte.X-DIREC  FORMAT 'X(50)' 
       'Hora Aten :' AT 83 Reporte.X-HORA FORMAT 'X(10)' {&PRN6A} "Fecha Entrega : "  Reporte.X-FECHA {&PRN6B} SKIP /*{&PRN4} + {&PRN6A} + "Fecha Entrega : " + Reporte.X-FECHA + {&PRN6B} + {&PRN3} SKIP*/
       "OBSERVACIONES : " Reporte.X-OBSER VIEW-AS TEXT FORMAT "X(80)" SKIP
       "GLOSA         : " Reporte.X-Glosa VIEW-AS TEXT FORMAT "X(80)" SKIP
       "                                                  " SKIP
       "                                                  " SKIP
       "                                                  " SKIP
       "                                                  " SKIP
       "                                                      -------------------     -------------------    -------------------" SKIP
       "                                                          Operador(a)         VoBo Jefe de Ventas       VoBo Cta.Cte.   " SKIP
       "HORA : " AT 1 STRING(TIME,"HH:MM")  S-USER-ID TO 67 SKIP
/***     999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH PAGE-TOP WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.


DEFINE FRAME f-det
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
FOR EACH Reporte BREAK BY Reporte.NroPed :
         VIEW STREAM Report FRAME F-Cab.
         VIEW STREAM Report FRAME F-FtrPed. 
         DISPLAY STREAM Report 
                Reporte.CodMat 
                Reporte.DesMat
                Reporte.DesMar
                Reporte.UndBas
                Reporte.CanPed
                Reporte.CodUbi
                WITH FRAME f-det.
         IF LAST-OF(Reporte.NroPed) THEN DO:
                PAGE STREAM Report.
                HIDE STREAM REPORT FRAME F-FtrPed .
         END.
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
  DEFINE INPUT PARAMETER x-CodAlm AS CHAR.
  
  DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.
  DEFINE VARIABLE S-OK AS LOG INIT NO.
  DEFINE VARIABLE S-STKDIS AS DEC INIT 0.

  RUN Borra-Pedido (YES). 
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
  
  FOR EACH PEDI WHERE PEDI.AlmDes = x-CodAlm BY PEDI.NroItm: 
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' THEN DO:
        /* RHC 14.11.05 VERIFICAMOS EL STOCK DISPONIBLE ANTES DE GRABAR */
        RUN vtamay/stkdispo (s-codcia, 
                          PEDI.AlmDes, 
                          PEDI.CodMat,
                          PEDI.Factor * PEDI.CanPed, 
                          OUTPUT S-OK, 
                          OUTPUT S-STKDIS
                          ).
        IF S-OK = NO THEN DO:
            MESSAGE 'Se agotó el stock del material' PEDI.codmat SKIP
                'El IMPORTE del pedido será recalculado'
                VIEW-AS ALERT-BOX WARNING.
            NEXT.
        END.
        /* RHC 30.01.09 VERIFICAMOS EL SALDO DE LA COTIZACION */
        FIND FacDPedi WHERE FAcdpedi.codcia = s-codcia
            AND Facdpedi.coddoc = 'COT'
            AND Facdpedi.nroped = Faccpedi.nroref
            AND Facdpedi.codmat = PEDI.codmat
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Facdpedi OR PEDI.canped > (Facdpedi.canped - Facdpedi.canate) THEN DO:
            MESSAGE 'AVISO: Se ha detectado un cambio en los saldos por despachar de la cotización' SKIP 
                'Material:' PEDI.codmat SKIP
                'Cantidad PEDIDO:' PEDI.canped SKIP
                'Por despachar COTIZACION:' (Facdpedi.canped - Facdpedi.canate) SKIP
                'El IMPORTE del pedido será recalculado'
                VIEW-AS ALERT-BOX WARNING.
            NEXT.
        END.

    END.
    
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
    DELETE PEDI.
  END.

END PROCEDURE.
/*
  DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

  RUN Borra-Pedido. 
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
  
  FOR EACH PEDI NO-LOCK BY PEDI.NroItm: 
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
  END.
*/

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
    /*FacCPedi.ImpDto = FacCPedi.ImpDto + FacDPedi.ImpDto.*/
    F-Igv = F-Igv + FacDPedi.ImpIgv.
    F-Isc = F-Isc + FacDPedi.ImpIsc.
    FacCPedi.ImpTot = FacCPedi.ImpTot + FacDPedi.ImpLin.
    IF NOT FacDPedi.AftIgv THEN FacCPedi.ImpExo = FacCPedi.ImpExo + FacDPedi.ImpLin.
    IF FacDPedi.AftIgv = YES
    THEN FacCPedi.ImpDto = FacCPedi.ImpDto + ROUND(FacDPedi.ImpDto / (1 + FacCPedi.PorIgv / 100), 2).
    ELSE FacCPedi.ImpDto = FacCPedi.ImpDto + FacDPedi.ImpDto.
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
/*    FacCPedi.ImpBrt = FacCPedi.ImpTot - FacCPedi.ImpIgv - FacCPedi.ImpIsc + FacCPedi.ImpDto - FacCPedi.ImpExo
 *     FacCPedi.ImpVta = FacCPedi.ImpBrt - FacCPedi.ImpDto.*/
    FacCPedi.ImpVta = FacCPedi.ImpTot - FacCPedi.ImpExo - FacCPedi.ImpIgv.
  IF FacCPedi.PorDto > 0 THEN DO:
    ASSIGN
        /*FacCPedi.ImpDto = FacCPedi.ImpDto + ROUND(FacCPedi.ImpTot * FacCPedi.PorDto / 100,2)*/
        FacCPedi.ImpDto = FacCPedi.ImpDto + ROUND((FacCPedi.ImpVta + FacCPedi.ImpExo) * FacCPedi.PorDto / 100, 2)
        FacCPedi.ImpTot = ROUND(FacCPedi.ImpTot * (1 - FacCPedi.PorDto / 100),2)
        FacCPedi.ImpVta = ROUND(FacCPedi.ImpVta * (1 - FacCPedi.PorDto / 100),2)
/*        FacCPedi.ImpIgv = IF FacCPedi.ImpExo = 0 THEN (FacCPedi.ImpTot - FacCPedi.ImpVta) ELSE ROUND(FacCPedi.ImpVta * FacCPedi.PorIgv / 100, 2)
 *         FacCPedi.ImpBrt = FacCPedi.ImpTot - FacCPedi.ImpIgv - FacCPedi.ImpIsc + FacCPedi.ImpDto - FacCPedi.ImpExo.*/
        FacCPedi.ImpExo = ROUND(FacCPedi.ImpExo * (1 - FacCPedi.PorDto / 100),2)
        FacCPedi.ImpIgv = FacCPedi.ImpTot - FacCPedi.ImpExo - FacCPedi.ImpVta.
  END.
  FacCPedi.ImpBrt = FacCPedi.ImpVta + FacCPedi.ImpIsc + FacCPedi.ImpDto + FacCPedi.ImpExo.
  FacCPedi.Importe[3] = IF Y-IMPTOT > FacCPedi.ImpTot THEN FacCPedi.ImpTot ELSE Y-IMPTOT.

END PROCEDURE.

/* calculo con descuento
   B-CPEDI.UsrDscto = S-USER-ID.
   B-CPEDI.ImpDto = 0.
   B-CPEDI.ImpIgv = 0.
   B-CPEDI.ImpIsc = 0.
   B-CPEDI.ImpTot = 0.
   B-CPEDI.ImpExo = 0.
   B-CPEDI.ImpBrt = 0.
   FOR EACH PEDI NO-LOCK:
       B-CPEDI.ImpDto = B-CPEDI.ImpDto + PEDI.ImpDto.
               F-IGV  = F-IGV + PEDI.ImpIgv.
               F-ISC  = F-ISC + PEDI.ImpIsc.
       B-CPEDI.ImpTot = B-CPEDI.ImpTot + PEDI.ImpLin.
       IF NOT PEDI.AftIgv THEN B-CPEDI.ImpExo = B-CPEDI.ImpExo + PEDI.ImpLin.
   END.
   
   B-CPEDI.ImpIgv = ROUND(F-IGV,2).
   B-CPEDI.ImpIsc = ROUND(F-ISC,2).
   B-CPEDI.ImpBrt = B-CPEDI.ImpTot - B-CPEDI.ImpIgv - B-CPEDI.ImpIsc + 
                    B-CPEDI.ImpDto - B-CPEDI.ImpExo.
   B-CPEDI.ImpVta = B-CPEDI.ImpBrt - B-CPEDI.ImpDto.
   
   /*** DESCUENTO GLOBAL ****/
    /* RHC 28/01/2004 Se vuelve a habilitar el descuento global  por EXPOLIBRERIA */
    IF B-CPEDI.PorDto > 0 THEN DO:
        B-CPEDI.ImpDto = B-CPEDI.ImpDto + ROUND(B-CPEDI.ImpTot * B-CPEDI.PorDto / 100,2).
        B-CPEDI.ImpTot = ROUND(B-CPEDI.ImpTot * (1 - B-CPEDI.PorDto / 100),2).
        B-CPEDI.ImpVta = ROUND(B-CPEDI.ImpTot / (1 + B-CPEDI.PorIgv / 100),2).
        B-CPEDI.ImpIgv = B-CPEDI.ImpTot - B-CPEDI.ImpVta.
        B-CPEDI.ImpBrt = B-CPEDI.ImpTot - B-CPEDI.ImpIgv - B-CPEDI.ImpIsc + 
        B-CPEDI.ImpDto - B-CPEDI.ImpExo.
    END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir V-table-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
    IF NOT AVAILABLE FacCPedi THEN RETURN.
    IF FacCPedi.FlgEst <> "A" THEN DO:
        IF Faccpedi.Libre_c01 <> '' OR  Faccpedi.Libre_c03 <> '' 
        THEN RUN vtaexp/r-imppedexp-1 (ROWID(FacCPedi)).    /* con transportista */
        ELSE RUN vtaexp/r-imppedexp-2 (ROWID(FacCPedi)).
    END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir1 V-table-Win 
PROCEDURE Imprimir1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR x-Ok AS LOG INIT NO NO-UNDO.

    SYSTEM-DIALOG PRINTER-SETUP UPDATE x-Ok.
    IF x-Ok = NO THEN RETURN.
    
    RUN Carga-Temporal.
    OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 60.
    PUT STREAM report CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
    RUN Formato1.
    OUTPUT STREAM report CLOSE.

END PROCEDURE.

/*
DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.
    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.
    IF FacCPedi.FlgEst <> "A" THEN DO:
        RUN Carga-Temporal.
    END.
        IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".
    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .
        RUN Formato1.
        PAGE STREAM REPORT.
        OUTPUT STREAM REPORT CLOSE.
    END.
    OUTPUT STREAM REPORT CLOSE.
    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/W-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir2 V-table-Win 
PROCEDURE Imprimir2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR x-Ok AS LOG INIT NO NO-UNDO.

    SYSTEM-DIALOG PRINTER-SETUP UPDATE x-Ok.
    IF x-Ok = NO THEN RETURN.
    
    RUN Carga-Temporal.

    OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 33.
    PUT STREAM report CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
    RUN Formato2.
    OUTPUT STREAM report CLOSE.

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
  /* Llamamos a la cotizacion credito pendiente */
  ASSIGN
    input-var-1 = STRING(s-codcia)
    input-var-2 = 'COT'
    input-var-3 = s-coddiv
    input-var-4 = s-user-id
    output-var-1 = ?.
  RUN vtamay/c-cotpen-2 ('Cotizaciones Pendientes').
  IF OUTPUT-VAR-1 = ? THEN RETURN 'ADM-ERROR'.
  FIND COTIZACION WHERE ROWID(COTIZACION) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
  IF NOT AVAILABLE COTIZACION
  THEN DO:
    MESSAGE 'No pudo ubicar la Cotizacion' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  s-CodCli = COTIZACION.CodCli.
  s-NroCot = COTIZACION.NroPed.
  s-CodMon = COTIZACION.CodMon.
  s-CndVta = COTIZACION.FmaPgo.
  s-TpoCmb = COTIZACION.TpoCmb.
  s-PorDto = COTIZACION.PorDto.
  s-NroPed = '?'.   /* Aún no definido */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Asigna-Cotizacion.
  RUN Procesa-Handle IN lh_Handle ('browse'). 
  APPLY 'VALUE-CHANGED' TO FaccPedi.TipVta IN FRAME {&FRAME-NAME}.

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
  /* DEFINIMOS CUANTOS ALMACENES TIENE EL PEDIDO */
  DEF VAR p-CodAlm AS CHAR.
  
  FOR EACH PEDI BREAK BY PEDI.AlmDes:
    IF FIRST-OF(PEDI.AlmDes) THEN DO:
        p-CodAlm = IF p-CodAlm = '' THEN TRIM(PEDI.AlmDes) ELSE p-CodAlm + ',' + TRIM(PEDI.AlmDes).
    END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* GRABAMOS LLAVES */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
        AND FacCorre.CodDoc = S-CODDOC 
        AND FacCorre.CodDiv = S-CODDIV 
        AND Faccorre.Codalm = S-CodAlm
        EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE FacCorre THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN 
          FacCPedi.CodCia = s-codcia
          FacCPedi.CodDiv = s-coddiv
          FacCPedi.CodDoc = s-coddoc 
          FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
          FacCPedi.FchPed = TODAY 
          FacCPedi.NroRef = COTIZACION.NroPed
          FacCPedi.FlgEst = 'G'
          FacCPedi.TpoPed = '1'.
      ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
  END.

  /* BARREMOS TODOS LOS ALMACENES */
  DEF VAR x-CodAlm AS CHAR.
  DEF VAR j AS INT.

  x-CodAlm = ENTRY(1, p-CodAlm).
  ASSIGN 
        FacCPedi.Hora = STRING(TIME,"HH:MM")
        FacCPedi.Usuario = S-USER-ID
        FacCPedi.CodAlm = x-CodAlm.

  RUN Genera-Pedido (x-CodAlm).    /* Detalle del pedido */ 
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN Graba-Totales.
    
  /* Actualizamos la cotizacion */
  RUN Actualiza-Cotizacion.
    
  /* Verificacion del Cliente */
  RUN Verifica-Cliente.
    
  /* CONTROL DE PEDIDOS PARA ENVIO */
  MESSAGE 'El Pedido es para enviar?' 
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
        TITLE 'Confirmacion de Pedidos a Enviar' UPDATE rpta-1 AS LOG.
    FacCPedi.FlgEnv = rpta-1.
  
  DO j = 2 TO NUM-ENTRIES(p-CodAlm):
    x-CodAlm = ENTRY(j, p-CodAlm).      /* Almacen Activo */
    CREATE B-CPEDI.
    BUFFER-COPY FacCPedi TO B-CPEDI
      ASSIGN 
          B-CPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
          B-CPedi.FlgEst = 'G'
          B-CPedi.CodAlm = x-CodAlm.
    ASSIGN
      FacCorre.Correlativo = FacCorre.Correlativo + 1.
    FIND FacCPedi OF B-CPedi EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.

    RUN Genera-Pedido (x-CodAlm).    /* Detalle del pedido */ 
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    RUN Graba-Totales.
    
    /* Actualizamos la cotizacion */
    RUN Actualiza-Cotizacion.
    
    /* Verificacion del Cliente */
    RUN Verifica-Cliente.
    
    FacCPedi.FlgEnv = rpta-1.
  END.
  RELEASE FacCorre.     /* OJO */

  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
/*   FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA     */
/*     AND FacCorre.CodDoc = S-CODDOC                   */
/*     AND FacCorre.CodDiv = S-CODDIV                   */
/*     AND Faccorre.Codalm = S-CodAlm                   */
/*     EXCLUSIVE-LOCK NO-ERROR.                         */
/*   IF NOT AVAILABLE FacCorre THEN RETURN 'ADM-ERROR'. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
/*   BUFFER-COPY COTIZACION TO FacCPedi                                                            */
/*     ASSIGN                                                                                      */
/*         FacCPedi.CodDoc = s-coddoc                                                              */
/*         FacCPedi.FchPed = TODAY                                                                 */
/*         FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999") */
/*         FacCPedi.NroRef = COTIZACION.NroPed                                                     */
/*         FacCPedi.FlgEst = 'G'                                                                   */
/*         FacCPedi.TpoPed = '1'.                                                                  */
/*   ASSIGN                                                                                        */
/*     FacCorre.Correlativo = FacCorre.Correlativo + 1.                                            */
/*   RELEASE FacCorre.                                                                             */

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
  IF FacCPedi.FlgEst = "P" AND FacCPedi.FlgSit = "P"  THEN DO:
       MESSAGE "No puede eliminar un pedido Chequeado" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
  END.
  /* RHC 15.11.05 VERIFICAR SI TIENE ATENCIONES PARCIALES */
  FIND FIRST FacDPedi OF FacCPedi WHERE FacDPedi.CanAte > 0 NO-LOCK NO-ERROR.
  IF AVAILABLE FacDPedi THEN DO:
    MESSAGE 'No se puede eliminar un pedido con atenciones parciales' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
    
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND CURRENT FacCPedi EXCLUSIVE-LOCK NO-ERROR.
    ASSIGN 
        FacCPedi.FlgEst = "A"
        FacCPedi.Glosa = " A N U L A D O".
    RUN Borra-Pedido (NO).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    FIND B-CPedi WHERE B-CPedi.CodCia = FacCPedi.CodCia 
        AND  B-CPedi.CodDiv = FacCPedi.CodDiv
        AND  B-CPedi.CodDoc = "COT" 
        AND  B-CPedi.NroPed = FacCPedi.NroRef
        EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE B-CPedi THEN DO:
        B-CPedi.FlgEst = "P".
    END.
    RELEASE B-CPedi.
    FIND CURRENT FacCPedi NO-LOCK.    
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
/*   C-TpoVta:SENSITIVE IN FRAME {&FRAME-NAME} = NO. */
  /*F-Nrodec:HIDDEN IN FRAME {&FRAME-NAME} = YES. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE FacCPedi THEN DO WITH FRAME {&FRAME-NAME}:
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
   CASE FaccPedi.FlgSit:
     WHEN "X" THEN DISPLAY "POR CHEQUEAR" @ F-Situacion WITH FRAME {&FRAME-NAME}.
     WHEN "P" THEN DISPLAY " CHEQUEADO  " @ F-Situacion WITH FRAME {&FRAME-NAME}.
     WHEN ""  THEN DISPLAY "            " @ F-Situacion WITH FRAME {&FRAME-NAME}.
   END CASE.
    F-NomVen:screen-value = "".
    FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
                  AND  gn-ven.CodVen = FacCPedi.CodVen 
                 NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
    F-CndVta:SCREEN-VALUE = "".
    FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
/*     C-TpoVta:SCREEN-VALUE = ENTRY(INTEGER(FacCPedi.TipVta),C-TpoVta:LIST-ITEMS). */
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
    FacCPedi.DirCli:SENSITIVE = NO.
    FacCPedi.CodCli:SENSITIVE = NO.
    FacCPedi.NomCli:SENSITIVE = NO.
    FacCPedi.DirCli:SENSITIVE = NO.
    FacCPedi.FchPed:SENSITIVE = NO.
    FacCPedi.RucCli:SENSITIVE = NO.
    FacCPedi.Atencion:SENSITIVE = NO.
    FacCPedi.FchEnt:SENSITIVE = NO.
    FacCPedi.FchVen:SENSITIVE = NO.
    FacCPedi.TpoCmb:SENSITIVE = NO.
    FacCPedi.NroCard:SENSITIVE = NO.
    FacCPedi.FmaPgo:SENSITIVE = NO.
    FaccPedi.CodVen:SENSITIVE = NO.
    FacCPedi.CodPos:SENSITIVE = NO.
    FaccPedi.CodMon:SENSITIVE = NO.
    FacCPedi.NroRef:SENSITIVE = NO.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'NO' THEN DO:
        IF Faccpedi.TipVta = '2' 
        THEN ASSIGN
            FacCPedi.NomCli:SENSITIVE = YES
            FacCPedi.DirCli:SENSITIVE = YES
            FacCPedi.Atencion:SENSITIVE = YES.
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
  IF NOT AVAILABLE Faccpedi THEN RETURN.
  IF Faccpedi.flgest = 'A'  THEN RETURN.
  
  /* Dispatch standard ADM method.                             */
  
    DEFINE VARIABLE cMode AS CHARACTER NO-UNDO.

    RUN vtaexp/d-impped (OUTPUT cMode).

    IF cMode = 'ADM-ERROR' THEN RETURN NO-APPLY.

    CASE cMode:
        WHEN '1' THEN RUN Imprimir.
        WHEN '2' THEN RUN Imprimir1.
        WHEN '3' THEN RUN Imprimir2.
        WHEN '4' THEN DO: 
            RUN Imprimir.
            RUN Imprimir1.
        END.
        WHEN '5' THEN DO:
            RUN Imprimir.
            RUN Imprimir2.
        END.
        WHEN '6' THEN DO:
            RUN Imprimir1.
            RUN Imprimir2.
        END.
        WHEN '7' THEN DO:
            RUN Imprimir. 
            RUN Imprimir1.
            RUN Imprimir2.
        END.
    END CASE.

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
  RUN vtamay/d-sdocot (faccpedi.codcia, 'COT', faccpedi.nroref).
    
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

/*  IF p-state = 'update-begin':U THEN DO WITH FRAME {&FRAME-NAME}:
 *      L-CREA = NO.
 *      RUN Actualiza-Item.
 *      
 *      FacCPedi.TpoCmb:SENSITIVE = NO.
 *      
 *      RUN Procesa-Handle IN lh_Handle ('Pagina2').
 *      RUN Procesa-Handle IN lh_Handle ('browse').
 *   END.*/
  
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
  DEF VAR F-Tot AS DEC.
  DEF VAR F-Bol AS DEC.
  DEF VAR x-Ok  AS LOG.
  
  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH PEDI NO-LOCK BREAK BY ALMDES:
       F-Tot = F-Tot + PEDI.ImpLin.
    END.
    IF F-Tot = 0 THEN DO:
      MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".   
    END.
/*    /* RHC 09/03/04 */
 *     F-BOL = IF INTEGER(FacCPedi.CodMon:SCREEN-VALUE) = 1 THEN F-TOT
 *             ELSE F-Tot * DECIMAL(FacCPedi.TpoCmb:SCREEN-VALUE).
 *     IF C-TpoVta:SCREEN-VALUE = 'BOL' AND F-BOL >= 1600
 *     THEN DO:
 *         MESSAGE "Venta Mayor a 1600.00, Verifique... " 
 *             VIEW-AS ALERT-BOX ERROR.
 *         RETURN "ADM-ERROR".   
 *     END.*/
    FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
    FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
        AND  gn-clie.CodCli = FacCPedi.CodCli:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
/*    IF gn-convt.totdias > 0 AND gn-clie.ImpLC > 0 THEN DO:*/
        IF INTEGER(FacCPedi.CodMon:SCREEN-VALUE) = 1 
        THEN IF gn-clie.MonLC = 2 THEN F-Tot = F-Tot / FacCfgGn.TpoCmb[1].
        ELSE IF gn-clie.MonLC = 1 THEN F-Tot = F-Tot * FacCfgGn.TpoCmb[1].
/*    END.*/
    /****   COMENTAR SI EN CASO NO SE QUIERE VALIDAR LA CTA.CTE.    ****/
    IF LOOKUP(TRIM(Faccpedi.Fmapgo:SCREEN-VALUE),"000,001,002") = 0 THEN DO: 
        RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
        IF RETURN-VALUE = 'YES'
        THEN RUN vtamay/lincre (FacCPedi.CodCli:SCREEN-VALUE, F-Tot, OUTPUT T-SALDO).
        ELSE RUN vtamay/lincre (FacCPedi.CodCli:SCREEN-VALUE, F-Tot - FacCpedi.Imptot, OUTPUT T-SALDO).

        dImpLCred = 0.
        lEnCampan = FALSE.
        /* Línea Crédito Campaña */
        FOR EACH Gn-ClieL WHERE
            Gn-ClieL.CodCia = gn-clie.codcia AND
            Gn-ClieL.CodCli = gn-clie.codcli AND
            TODAY >= Gn-ClieL.FchIni AND
            TODAY <= Gn-ClieL.FchFin NO-LOCK:
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
                STRING(T-SALDO + f-Tot,"ZZ,ZZZ,ZZ9.99") SKIP
                "CREDITO DISPONIBLE    : " (IF gn-clie.MonLC = 1 THEN "S/. " ELSE "US$ " ) 
                STRING(dImpLCred - T-SALDO - f-Tot,"-Z,ZZZ,ZZ9.99")
                VIEW-AS ALERT-BOX ERROR. 
            RETURN "ADM-ERROR".
        END.
    END.

    /* Verificamos los montos de acuerdo al almacen de despacho */
    FOR EACH PEDI NO-LOCK BREAK BY ALMDES:
        IF FIRST-OF(AlmDes) THEN F-Tot = 0.
        F-Tot = F-Tot + PEDI.ImpLin.
        IF LAST-OF(AlmDes) THEN DO:
            F-BOL = IF INTEGER(FacCPedi.CodMon:SCREEN-VALUE) = 1 
                    THEN F-TOT
                    ELSE F-Tot * DECIMAL(FacCPedi.TpoCmb:SCREEN-VALUE).
            IF FaccPedi.TipVta:SCREEN-VALUE = '2' AND F-BOL > 700 
                AND (FacCPedi.Atencion:SCREEN-VALUE = '' 
                    OR LENGTH(FacCPedi.Atencion:SCREEN-VALUE, "CHARACTER") < 8)
            THEN DO:
                MESSAGE "Venta Mayor a 700.00" SKIP
                        "Debe ingresar en DNI"
                    VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO FacCPedi.Atencion.
                RETURN "ADM-ERROR".   
            END.
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
  IF FacCPedi.FlgSit <> "" THEN RETURN "ADM-ERROR".
  s-NroCot = FacCPedi.NroRef.   /* Para validar el detalle */
  s-CodCli = FacCPedi.CodCli.
  s-CodMon = FacCPedi.CodMon.
  s-CndVta = FacCPedi.FmaPgo.
  s-TpoCmb = FacCPedi.TpoCmb.
  s-PorDto = FacCPedi.PorDto.
  s-NroPed = FacCPedi.NroPed.   /* Ya definido */

  RUN Actualiza-Item.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('browse').

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
  DEFINE VAR OK AS LOGICAL NO-UNDO.
  DEFINE VAR X-CREUSA AS DECIMAL NO-UNDO.
  DEFINE VARIABLE I-ListPr     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE F-MRGUTI     AS INTEGER   NO-UNDO.

  IF LOOKUP(FacCPedi.Flgest, 'G,X') > 0  THEN DO:
    /* Deuda vencida */
    FIND FIRST CcbCDocu WHERE CcbCDocu.CodCia = FacCPedi.CodCia
        AND  CcbCDocu.CodCli = FacCPedi.Codcli                         
        AND  LOOKUP(CcbCDocu.CodDoc, "FAC,BOL,CHQ,LET,N/D") > 0
        AND  CcbCDocu.FlgEst = "P" 
        AND  CcbCDocu.FchVto <= TODAY
        NO-LOCK NO-ERROR. 
    IF AVAIL CcbCDocu 
    THEN ASSIGN
            FacCPedi.Flgest = 'X'
            FacCPedi.Glosa  = TRIM (FacCPedi.Glosa) + '//Doc. Venc.'.

    /* Condicion Crediticia */
    OK = TRUE.
    FIND gn-convt WHERE gn-convt.Codig = gn-clie.cndvta NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN F-totdias = gn-convt.totdias.
    
    FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt 
    THEN IF gn-convt.totdias > F-totdias AND F-totdias > 0 THEN OK = FALSE.
 
    IF NOT OK 
    THEN ASSIGN
          FacCPedi.Flgest = 'X'
          FacCPedi.Glosa  = TRIM (FacCPedi.Glosa) + '//Cond.Cred.'.
 
    /* Ventas Contra Entrega*/
    OK = TRUE.
    IF LOOKUP(FacCPedi.fmaPgo,"001,002") > 0 THEN OK = FALSE.
 
    IF NOT OK 
    THEN ASSIGN
          FacCPedi.Flgest = 'X'
          FacCPedi.Glosa  = TRIM (FacCPedi.Glosa) + '//Cond.Cred.Ctra.Entr.'.
 
    /* RHC 15.10.04 Transferencias Gratuitas */
    IF FacCPedi.FmaPgo = '900' THEN FacCPedi.FlgEst = 'X'.      /* NO Aprobado */
    /* ************************************* */
    
    IF FacCPEDI.Flgest = "G" THEN FacCPEDI.Flgest = "P".

    /* Aprobacion automatica en caso de pedidos contado-contraentrega */
    IF s-CodDiv = '00015'               /* Expolibreria */
        AND FacCPedi.FmaPgo = '001'      /* Contado contra-entrega */
    THEN FacCPedi.Flgest = 'P'.
 
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

