&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CcbCDocu FOR CcbCDocu.
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

/* Shared Variable Definitions ---                                       */

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-TPOFAC   AS CHAR.
DEFINE SHARED VARIABLE CL-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-NROSER  AS INTEGER.
DEFINE SHARED VARIABLE S-IMPFLE  AS DECIMAL.
DEFINE SHARED VARIABLE S-CODCLI  AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB AS DEC.
DEFINE SHARED VARIABLE s-PorIgv LIKE Ccbcdocu.PorIgv.
DEFINE SHARED VARIABLE S-FLGSIT   AS CHAR.

DEFINE SHARED VARIABLE s-Sunat-Activo AS LOG.

DEFINE SHARED VAR s-amortiza-letras AS LOG INIT NO NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE s-aplic-fact-ade AS LOG NO-UNDO.    /* Aplicacion de la factura adelantada */

DEFINE VARIABLE I              AS INTEGER   NO-UNDO.
DEFINE VARIABLE C-NRODOC       AS CHAR      NO-UNDO.
DEFINE VARIABLE C-CODPED       AS CHAR      NO-UNDO.
DEFINE VARIABLE C-NROPED       AS CHAR      NO-UNDO.
DEFINE VARIABLE C-NROGUI       AS CHAR      NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NRODOC       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-ListPr       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.

/*DEFINE VARIABLE S-CODALM       AS CHAR      NO-UNDO.*/
DEFINE VARIABLE S-CODMOV       AS INTEGER   NO-UNDO. 
DEFINE VARIABLE I-CODMON       AS INTEGER   NO-UNDO. 
DEFINE VARIABLE R-ROWID        AS ROWID     NO-UNDO. 
DEFINE VARIABLE C-CODVEN       AS CHAR      NO-UNDO.
DEFINE VARIABLE D-FCHVTO       AS DATE      NO-UNDO.

DEFINE BUFFER B-CDOCU FOR CcbCDocu.
/* DEFINE BUFFER B-CCDOCU FOR CcbCDocu. */

FIND FacDocum WHERE FacDocum.CodCia = S-CODCIA AND
     FacDocum.CodDoc = S-CODDOC NO-LOCK NO-ERROR.
IF AVAILABLE FacDocum THEN S-CODMOV = FacDocum.CodMov.

FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV AND
     FacCorre.NroSer = S-NROSER NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN /*S-CodAlm = FacCorre.CodAlm */
          I-NroSer = FacCorre.NroSer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE VAR x-ClientesVarios AS CHAR INIT '11111111111'.     /* 06.02.08 */
x-ClientesVarios =  FacCfgGn.CliVar.                        /* 07.09.09 */

DEFINE TEMP-TABLE T-CPEDM LIKE FacCPedi.
DEFINE TEMP-TABLE T-DPEDM LIKE FacDPedi.

DEFINE VARIABLE RPTA        AS CHARACTER NO-UNDO.

DEFINE VARIABLE x-cto1 AS DECI INIT 0.
DEFINE VARIABLE x-cto2 AS DECI INIT 0.

DEFINE BUFFER F-CDOCU FOR CcbCDocu.
DEFINE BUFFER F-DDOCU FOR CcbDDocu.

DEF VAR s-FechaI AS DATETIME NO-UNDO.
DEF VAR s-FechaT AS DATETIME NO-UNDO.

s-FechaI = DATETIME(TODAY, MTIME).


DEFINE NEW SHARED TEMP-TABLE T-VVALE NO-UNDO LIKE VtaVVale.

/* Se usa para las retenciones */
DEFINE NEW SHARED TEMP-TABLE wrk_ret NO-UNDO
    FIELDS CodCia LIKE CcbDCaja.CodCia
    FIELDS CodCli LIKE CcbCDocu.CodCli
    FIELDS CodDoc LIKE CcbCDocu.CodDoc COLUMN-LABEL "Tipo  "
    FIELDS NroDoc LIKE CcbCDocu.NroDoc COLUMN-LABEL "Documento " FORMAT "x(10)"
    FIELDS CodRef LIKE CcbDCaja.CodRef
    FIELDS NroRef LIKE CcbDCaja.NroRef
    FIELDS FchDoc LIKE CcbCDocu.FchDoc COLUMN-LABEL "    Fecha    !    Emisión    "
    FIELDS FchVto LIKE CcbCDocu.FchVto COLUMN-LABEL "    Fecha    ! Vencimiento"
    FIELDS CodMon AS CHARACTER COLUMN-LABEL "Moneda" FORMAT "x(3)"
    FIELDS ImpTot LIKE CcbDCaja.ImpTot COLUMN-LABEL "Importe Total"
    FIELDS ImpRet LIKE CcbDCaja.ImpTot COLUMN-LABEL "Importe!a Retener"
    FIELDS FchRet AS DATE
    FIELDS NroRet AS CHARACTER
    INDEX ind01 CodRef NroRef.

/* Se usa para las N/C */
DEFINE NEW SHARED TEMP-TABLE wrk_dcaja NO-UNDO LIKE ccbdcaja.

DEF NEW SHARED TEMP-TABLE T-CcbDCaja LIKE CcbDCaja.
DEF NEW SHARED TEMP-TABLE T-CcbCCaja LIKE CcbCCaja.

DEF SHARED VAR s-ptovta  AS INTE.
DEF SHARED VAR s-tipo   AS CHAR INITIAL "MOSTRADOR".
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.


/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).

DEF VAR pMensaje AS CHAR NO-UNDO.

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
&Scoped-Define ENABLED-FIELDS CcbCDocu.FchDoc CcbCDocu.CodCli ~
CcbCDocu.NomCli CcbCDocu.TpoCmb CcbCDocu.DirCli CcbCDocu.FchVto ~
CcbCDocu.RucCli CcbCDocu.CodAnt CcbCDocu.NroPed CcbCDocu.CodVen ~
CcbCDocu.NroOrd CcbCDocu.FmaPgo CcbCDocu.CodMon CcbCDocu.Glosa 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.FchDoc CcbCDocu.CodCli ~
CcbCDocu.NomCli CcbCDocu.TpoCmb CcbCDocu.DirCli CcbCDocu.FchVto ~
CcbCDocu.RucCli CcbCDocu.CodAnt CcbCDocu.NroPed CcbCDocu.CodVen ~
CcbCDocu.NroOrd CcbCDocu.FmaPgo CcbCDocu.CodMon CcbCDocu.NroRef ~
CcbCDocu.Glosa 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NroSer FILL-IN-NroDoc F-Estado ~
F-nOMvEN F-CndVta 

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
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .81
     FONT 0 NO-UNDO.

DEFINE VARIABLE F-nOMvEN AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS INTEGER FORMAT "99999999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroSer AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Número" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-NroSer AT ROW 1 COL 9 COLON-ALIGNED WIDGET-ID 26
     FILL-IN-NroDoc AT ROW 1 COL 14 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     F-Estado AT ROW 1 COL 29 COLON-ALIGNED NO-LABEL
     CcbCDocu.FchDoc AT ROW 1 COL 117 COLON-ALIGNED
          LABEL "F/ Emision"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.CodCli AT ROW 1.81 COL 9 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.NomCli AT ROW 1.81 COL 21 COLON-ALIGNED NO-LABEL FORMAT "x(100)"
          VIEW-AS FILL-IN 
          SIZE 82 BY .81
     CcbCDocu.TpoCmb AT ROW 1.81 COL 117 COLON-ALIGNED
          LABEL "T/ Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.DirCli AT ROW 2.62 COL 9 COLON-ALIGNED FORMAT "x(100)"
          VIEW-AS FILL-IN 
          SIZE 94 BY .81
     CcbCDocu.FchVto AT ROW 2.62 COL 117 COLON-ALIGNED
          LABEL "Vencimiento"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.RucCli AT ROW 3.42 COL 9 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     CcbCDocu.CodAnt AT ROW 3.42 COL 29 COLON-ALIGNED WIDGET-ID 16
          LABEL "DNI" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
          BGCOLOR 11 FGCOLOR 0 
     CcbCDocu.NroPed AT ROW 3.42 COL 117 COLON-ALIGNED FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.CodVen AT ROW 4.23 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     F-nOMvEN AT ROW 4.23 COL 15 COLON-ALIGNED NO-LABEL
     CcbCDocu.NroOrd AT ROW 4.23 COL 117 COLON-ALIGNED
          LABEL "O/ Compra" FORMAT "x(12)"
          VIEW-AS FILL-IN 
          SIZE 12.29 BY .81
     CcbCDocu.FmaPgo AT ROW 5.04 COL 9 COLON-ALIGNED
          LABEL "Cond.Vta"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     F-CndVta AT ROW 5.04 COL 15 COLON-ALIGNED NO-LABEL
     CcbCDocu.CodMon AT ROW 5.04 COL 119.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 10.72 BY .81
     CcbCDocu.NroRef AT ROW 5.85 COL 9 COLON-ALIGNED
          LABEL "Guias" FORMAT "X(45)"
          VIEW-AS FILL-IN 
          SIZE 48.72 BY .81
     CcbCDocu.Glosa AT ROW 6.65 COL 9 COLON-ALIGNED
          LABEL "Glosa"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
          BGCOLOR 11 FGCOLOR 9 
     "Moneda:" VIEW-AS TEXT
          SIZE 6.43 BY .5 AT ROW 5.04 COL 112
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
   Temp-Tables and Buffers:
      TABLE: B-CcbCDocu B "?" ? INTEGRAL CcbCDocu
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
         HEIGHT             = 7.92
         WIDTH              = 134.43.
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

/* SETTINGS FOR FILL-IN CcbCDocu.CodAnt IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.CodCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.DirCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-nOMvEN IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchDoc IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchVto IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroSer IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FmaPgo IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.Glosa IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NomCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.NroOrd IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NroPed IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.NroRef IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.RucCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.TpoCmb IN FRAME F-Main
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

&Scoped-define SELF-NAME CcbCDocu.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodCli V-table-Win
ON LEAVE OF CcbCDocu.CodCli IN FRAME F-Main /* Cliente */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   FIND gn-clie WHERE gn-clie.CodCia = cl-codcia
                 AND  gn-clie.CodCli = CcbCDocu.CodCli:SCREEN-VALUE
                NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-clie  THEN DO:
      MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.

   IF gn-clie.FlgSit = "I" THEN DO:
      MESSAGE "Cliente esta Inactivo" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO CcbCDocu.CodCli.
      RETURN NO-APPLY.
   END.

   S-CODCLI = SELF:SCREEN-VALUE.
   DISPLAY gn-clie.NomCli @ CcbCDocu.NomCli
           gn-clie.Ruc    @ CcbCDocu.RucCli
           gn-clie.DirCli @ CcbCDocu.DirCli WITH FRAME {&FRAME-NAME}.
    /* RHC agregamos el distrito */
    FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept
      AND Tabdistr.Codprovi = gn-clie.codprov 
      AND Tabdistr.Coddistr = gn-clie.CodDist NO-LOCK NO-ERROR.
    IF AVAILABLE Tabdistr 
    THEN CcbCDocu.DirCli:SCREEN-VALUE = TRIM(CcbCDocu.DirCli:SCREEN-VALUE) + ' - ' +
                                      TabDistr.NomDistr.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodVen V-table-Win
ON LEAVE OF CcbCDocu.CodVen IN FRAME F-Main /* Vendedor */
DO:
    F-NomVen:SCREEN-VALUE = "".
    FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
    AND  gn-ven.CodVen = Ccbcdocu.CodVen:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE gn-ven THEN F-NomVen:SCREEN-VALUE = gn-ven.NomVen.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroDoc V-table-Win
ON LEAVE OF FILL-IN-NroDoc IN FRAME F-Main
DO:
/*   ASSIGN                                                      */
/*       SELF:SCREEN-VALUE = STRING(SELF:SCREEN-VALUE, '999999') */
/*       NO-ERROR.                                               */
  ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.FmaPgo V-table-Win
ON LEAVE OF CcbCDocu.FmaPgo IN FRAME F-Main /* Cond.Vta */
DO:
  F-CndVta:SCREEN-VALUE = ''.
  FIND gn-convt WHERE gn-convt.Codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Deta V-table-Win 
PROCEDURE Actualiza-Deta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       POR AHORA NO SE PUEDE MODIFICAR, SOLO CREAR
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE PEDI.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Lista-Escolar V-table-Win 
PROCEDURE Actualiza-Lista-Escolar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER pTipo AS INT.
  
  FIND PedidoC WHERE PedidoC.NroPed = CcbCDocu.NroPed
    EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE PedidoC
  THEN IF pTipo = 1
        THEN ASSIGN
                    PedidoC.Estado = 'F'
                    PedidoC.FecFac = TODAY.
        ELSE ASSIGN
                    PedidoC.Estado = ''
                    PedidoC.FecFac = ?.
  RELEASE PedidoC.
                      
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Detalle V-table-Win 
PROCEDURE Borra-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH CcbDDocu WHERE CcbDDocu.CodCia = CcbCDocu.CodCia 
    AND CcbDDocu.CodDoc = CcbCDocu.CodDoc 
    AND CcbDDocu.NroDoc = CcbCDocu.NroDoc 
    ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
         
    DELETE CcbDDocu.
         
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cancelacion V-table-Win 
PROCEDURE Cancelacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* CANCELACION */
  DEF VAR x-Importe AS DEC.
  DEF VAR x-Mon AS INT.
  DEFINE VARIABLE monto_ret AS DECIMAL NO-UNDO.
  DEFINE VARIABLE dTpoCmb LIKE CcbcCaja.TpoCmb NO-UNDO.
  DEF VAR s-ok AS LOGICAL INITIAL NO NO-UNDO.

  ASSIGN
    X-Importe = 0
    x-mon = INTEGER(CcbCDocu.CodMon:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

  FOR EACH PEDI:
      x-Importe = x-Importe + PEDI.ImpLin.
  END.

  /* Retenciones */
  FOR EACH wrk_ret:
      DELETE wrk_ret.
  END.
  /* N/C */
  FOR EACH wrk_dcaja:
      DELETE wrk_dcaja.
  END.

  /* Ventana de Cancelación */
  DEF VAR t-CodDoc LIKE s-CodDoc.   /* Vamos a engañar al programa */

  t-CodDoc = s-CodDoc.
  s-CodDoc = "I/C".
  RUN ccb/d-canped-02a(
      x-mon,
      Ccbcdocu.ImpTot,
      monto_ret,
      Ccbcdocu.NomCli:SCREEN-VALUE IN FRAME {&FRAME-NAME},
      TRUE,     /* como una venta contado - pago con tarjeta de credito */
      "M",      /* digitacion manual acepta pago con tarjetas de crédito **/
      OUTPUT s-ok
      ).

  s-CodDoc = t-CodDoc.

  IF s-Ok = NO THEN RETURN 'ADM-ERROR'.
  ELSE RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Factura-Adelantada V-table-Win 
PROCEDURE Carga-Factura-Adelantada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Monto-Aplicar  AS DEC NO-UNDO.
  DEF VAR x-TpoCmb-Compra AS DEC INIT 1 NO-UNDO.
  DEF VAR x-TpoCmb-Venta  AS DEC INIT 1 NO-UNDO.
  DEF VAR x-NroItm        AS INT INIT 1 NO-UNDO.

  IF CcbCDocu.sdoact <= 0 THEN RETURN.
  
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND FIRST F-CDOCU WHERE F-CDOCU.codcia = CcbCDocu.codcia
        AND LOOKUP (F-CDOCU.coddoc, 'FAC,BOL') > 0
        AND F-CDOCU.tpofac = 'A'
        AND F-CDOCU.codcli = CcbCDocu.codcli
        AND F-CDOCU.flgest = 'C'
        AND F-CDOCU.imptot2 > 0
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE F-CDOCU THEN RETURN.
    FIND FIRST F-DDOCU OF F-CDOCU NO-LOCK NO-ERROR.
    IF NOT AVAILABLE F-DDOCU THEN RETURN.
  
    FIND LAST Gn-tccja WHERE Gn-tccja.Fecha <= TODAY NO-LOCK NO-ERROR.
  
    IF AVAILABLE Gn-TcCja 
    THEN ASSIGN
            x-TpoCmb-Compra = Gn-Tccja.Compra.
            x-TpoCmb-Venta  = Gn-Tccja.Venta.
  
    IF CcbCDocu.codmon = F-CDOCU.codmon
    THEN ASSIGN
            x-Monto-Aplicar  = MINIMUM(CcbCDocu.imptot, F-CDOCU.imptot2).
    ELSE IF CcbCDocu.codmon = 1
        THEN ASSIGN
                x-Monto-Aplicar  = ROUND(MINIMUM(F-CDOCU.imptot2 * x-TpoCmb-Compra, CcbCDocu.imptot),2).
        ELSE ASSIGN
                x-Monto-Aplicar  = ROUND(MINIMUM(F-CDOCU.imptot2 / x-TpoCmb-Venta , CcbCDocu.imptot),2).

    /* CREAMOS DETALLE */
    FOR EACH Ccbddocu OF CcbCDocu NO-LOCK:
        x-NroItm = x-NroItm + 1.
    END.
    CREATE CcbDDocu.
/*     BUFFER-COPY CcbCDocu TO Ccbddocu */
        ASSIGN
            Ccbddocu.codcia = Ccbcdocu.codcia
            Ccbddocu.coddiv = Ccbcdocu.coddiv
            Ccbddocu.coddoc = Ccbcdocu.coddoc
            Ccbddocu.nrodoc = Ccbcdocu.nrodoc
            Ccbddocu.codmat = F-DDOCU.codmat
            Ccbddocu.candes = 1
            Ccbddocu.factor = 1
            Ccbddocu.undvta = 'UNI'
            Ccbddocu.preuni = -1 * x-Monto-Aplicar
            Ccbddocu.implin = -1 * x-Monto-Aplicar
            Ccbddocu.impigv = -1 * ROUND(x-Monto-Aplicar / (1 + CcbCDocu.PorIgv / 100) * CcbCDocu.PorIgv / 100, 2)
            CcbDDocu.AftIgv = YES
            CcbDDocu.NroItm = x-NroItm.
    
    /* Control de descarga de facturas adelantadas */
    CREATE Ccbdmov.
    ASSIGN
        CCBDMOV.CodCia = s-codcia
        CCBDMOV.CodCli = F-CDOCU.codcli
        CCBDMOV.CodDiv = CcbCDocu.coddiv
        CCBDMOV.CodDoc = F-CDOCU.coddoc
        CCBDMOV.CodMon = CcbCDocu.codmon
        CCBDMOV.CodRef = CcbCDocu.coddoc
        CCBDMOV.FchDoc = CcbCDocu.fchdoc
        CCBDMOV.FchMov = TODAY
        CCBDMOV.HraMov = STRING(TIME,'HH:MM')
        CCBDMOV.ImpTot = x-Monto-Aplicar
        CCBDMOV.NroDoc = F-CDOCU.nrodoc
        CCBDMOV.NroRef = CcbCDocu.nrodoc
        CCBDMOV.TpoCmb = (IF CcbCDocu.codmon = 1 THEN x-TpoCmb-Compra ELSE x-TpoCmb-Venta)
        CCBDMOV.usuario = s-user-id.
    
    /* Actualizamos saldo factura adelantada */
    IF F-CDOCU.CodMon = Ccbdmov.codmon
    THEN F-CDOCU.ImpTot2 = F-CDOCU.ImpTot2 - Ccbdmov.ImpTot.
    ELSE IF F-CDOCU.CodMon = 1
        THEN F-CDOCU.ImpTot2 = F-CDOCU.ImpTot2 - Ccbdmov.ImpTot * Ccbdmov.TpoCmb.
        ELSE F-CDOCU.ImpTot2 = F-CDOCU.ImpTot2 - Ccbdmov.ImpTot / Ccbdmov.TpoCmb.
    
    RELEASE CcbDDocu.    
    RELEASE F-CDOCU.
    RELEASE Ccbdmov.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-temporal V-table-Win 
PROCEDURE Crea-temporal :
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
/*  FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.*/
  FOR EACH FacDPedi OF FacCPedi 
           BREAK BY FacDPedi.CodCia
                 BY FacDPedi.AlmDes : 
      IF FIRST-OF(FacDPedi.AlmDes) OR L-NewPed THEN DO:
         I-NPED = I-NPED + 1.
         CREATE T-CPEDM.
         ASSIGN T-CPEDM.CodCia   = FacCPedi.CodCia 
                T-CPEDM.CodDiv   = FacCPedi.CodDiv
                T-CPEDM.CodAlm   = FacDPedi.AlmDes
                T-CPEDM.CodDoc   = FacCPedi.CodDoc
                T-CPEDM.NroPed   = SUBSTRING(FacCPedi.NroPed,1,3) + STRING(I-NPED,"999999").
/*                T-CPEDM.Cmpbnte  = FacCPedi.Cmpbnte 
 *                 T-CPEDM.CodCli   = FacCPedi.CodCli 
 *                 T-CPEDM.CodMon   = FacCPedi.CodMon 
 *                 T-CPEDM.CodTrans = FacCPedi.CodTrans 
 *                 T-CPEDM.CodVen   = FacCPedi.CodVen 
 *                 T-CPEDM.DirCli   = FacCPedi.DirCli 
 *                 T-CPEDM.FchPed   = FacCPedi.FchPed 
 *                 T-CPEDM.FlgEst   = FacCPedi.FlgEst 
 *                 T-CPEDM.FmaPgo   = FacCPedi.FmaPgo 
 *                 T-CPEDM.Glosa    = FacCPedi.Glosa 
 *                 T-CPEDM.Hora     = FacCPedi.Hora 
 *                 T-CPEDM.LugEnt   = FacCPedi.LugEnt
 *                 T-CPEDM.NomCli   = FacCPedi.NomCli 
 *                 T-CPEDM.PorDto   = FacCPedi.PorDto 
 *                 T-CPEDM.PorIgv   = FacCPedi.PorIgv
 *                 T-CPEDM.RucCli   = FacCPedi.RucCli 
 *                 T-CPEDM.TipVta   = FacCPedi.TipVta 
 *                 T-CPEDM.TpoCmb   = FacCPedi.TpoCmb 
 *                 T-CPEDM.UsrDscto = FacCPedi.UsrDscto 
 *                 T-CPEDM.usuario  = FacCPedi.usuario
 *                 T-CPEDM.ImpBrt   = 0
 *                 T-CPEDM.ImpDto   = 0
 *                 T-CPEDM.ImpExo   = 0
 *                 T-CPEDM.ImpIgv   = 0
 *                 T-CPEDM.ImpIsc   = 0
 *                 T-CPEDM.ImpTot   = 0
 *                 T-CPEDM.ImpVta   = 0.
 *          F-IGV = 0.
 *          F-ISC = 0.*/
         L-NewPed = NO.
         I-NItem = 0.
      END.
/*      T-CPEDM.ImpDto = T-CPEDM.ImpDto + FacDPedi.ImpDto.
 *                F-IGV = F-IGV + FacDPedi.ImpIgv.
 *                F-ISC = F-ISC + FacDPedi.ImpIsc.
 *       T-CPEDM.ImpTot = T-CPEDM.ImpTot + FacDPedi.ImpLin.
 *       IF NOT FacDPedi.AftIgv THEN T-CPEDM.ImpExo = T-CPEDM.ImpExo + FacDPedi.ImpLin.
 *       CREATE T-DPEDM.
 *       RAW-TRANSFER FacDPedi TO T-DPEDM.
 *       ASSIGN T-DPEDM.NroPed = T-CPEDM.NroPed.
 *       I-NItem = I-NItem + 1.
 *       IF ( T-CPEDM.Cmpbnte = "BOL" AND I-NItem >= FacCfgGn.Items_Boleta ) OR 
 *          ( T-CPEDM.Cmpbnte = "FAC" AND I-NItem >= FacCfgGn.Items_Factura ) THEN DO:
 *          L-NewPed = YES.
 *       END.*/
      IF LAST-OF(FacDPedi.AlmDes) OR L-NewPed THEN DO:
         L-NewPed = YES.    /****   ADD BY C.Q. 03/03/2000  ****/
/*         ASSIGN T-CPEDM.ImpIgv = ROUND(F-IGV,2).
 *                 T-CPEDM.ImpIsc = ROUND(F-ISC,2).
 *                 T-CPEDM.ImpBrt = T-CPEDM.ImpTot - T-CPEDM.ImpIgv - T-CPEDM.ImpIsc + 
 *                                  T-CPEDM.ImpDto - T-CPEDM.ImpExo.
 *                 T-CPEDM.ImpVta = T-CPEDM.ImpBrt - T-CPEDM.ImpDto.
 * 
 *         /****    ADD BY C.Q. 03/03/2000  ****/
 *         /*** DESCUENTO GLOBAL ****/
 *         IF T-CPEDM.PorDto > 0 THEN DO:
 *            T-CPEDM.ImpDto = T-CPEDM.ImpDto + ROUND(T-CPEDM.ImpTot * T-CPEDM.PorDto / 100,2).
 *            T-CPEDM.ImpTot = ROUND(T-CPEDM.ImpTot * (1 - T-CPEDM.PorDto / 100),2).
 *            T-CPEDM.ImpVta = ROUND(T-CPEDM.ImpTot / (1 + T-CPEDM.PorIgv / 100),2).
 *            T-CPEDM.ImpIgv = T-CPEDM.ImpTot - T-CPEDM.ImpVta.
 *            T-CPEDM.ImpBrt = T-CPEDM.ImpTot - T-CPEDM.ImpIgv - T-CPEDM.ImpIsc + 
 *                             T-CPEDM.ImpDto - T-CPEDM.ImpExo.
 *         END.*/
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descarga-Factura-Adelantada V-table-Win 
PROCEDURE Descarga-Factura-Adelantada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Control de descarga de facturas adelantadas */
    FIND Ccbdmov WHERE Ccbdmov.codcia = Ccbcdocu.codcia
        AND LOOKUP (ccbdmov.coddoc, 'FAC,BOL') > 0      /* FACTURA ADELANTADA */
        AND Ccbdmov.codref = Ccbcdocu.coddoc
        AND Ccbdmov.nroref = Ccbcdocu.nrodoc
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbdmov THEN RETURN.
    FIND FIRST F-CDOCU WHERE F-CDOCU.codcia = Ccbdmov.codcia
        AND F-CDOCU.coddoc = Ccbdmov.coddoc
        AND F-CDOCU.nrodoc = Ccbdmov.nrodoc
        AND F-CDOCU.tpofac = 'A'    /* FACTURA ADELANTADA */
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE F-CDOCU THEN UNDO, RETURN 'ADM-ERROR'.
    /* Actualizamos saldo factura adelantada */
    IF F-CDOCU.CodMon = Ccbdmov.codmon
    THEN F-CDOCU.ImpTot2 = F-CDOCU.ImpTot2 + Ccbdmov.ImpTot.
    ELSE IF F-CDOCU.CodMon = 1
        THEN F-CDOCU.ImpTot2 = F-CDOCU.ImpTot2 + Ccbdmov.ImpTot * Ccbdmov.TpoCmb.
        ELSE F-CDOCU.ImpTot2 = F-CDOCU.ImpTot2 + Ccbdmov.ImpTot / Ccbdmov.TpoCmb.
    
    DELETE Ccbdmov.
    RELEASE Ccbdmov.
    RELEASE F-CDOCU.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel V-table-Win 
PROCEDURE Excel :
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
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE F-PreUni                LIKE CcbDDocu.Preuni.
DEFINE VARIABLE F-ImpLin                LIKE CcbDDocu.ImpLin.
DEFINE VARIABLE F-ImpTot                LIKE CcbCDocu.ImpTot.

DEF VAR can as integer.
DEF        VAR C-NomVen  AS CHAR FORMAT "X(30)".
DEF        VAR C-Descli  AS CHAR FORMAT "X(60)".
DEF        VAR C-Moneda  AS CHAR FORMAT "X(7)".
DEF        VAR C-NomCon  AS CHAR FORMAT "X(30)".
DEF        VAR W-DIRALM  AS CHAR FORMAT "X(50)".
DEF        VAR W-TLFALM  AS CHAR FORMAT "X(65)".
DEF        VAR X-ORDCOM AS CHARACTER FORMAT "X(18)".
DEF        VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.
DEFINE VARIABLE C-OBS AS CHAR EXTENT 2.
DEFINE VARIABLE K AS INTEGER.

IF NUM-ENTRIES(CcbCDocu.glosa,"-") - 1 > 6 THEN DO:
   DO K = 2 TO 7:
      IF ENTRY(K,CcbCDocu.glosa,"-") <> "" THEN 
         C-OBS[1] = C-OBS[1] + "- " + ENTRY(K,CcbCDocu.glosa,"-").
   END.
   DO K = 8 TO NUM-ENTRIES(CcbCDocu.glosa,"-"):
      IF ENTRY(K,CcbCDocu.glosa,"-") <> "" THEN 
         C-OBS[2] = C-OBS[2] + "- " + ENTRY(K,CcbCDocu.glosa,"-").
   END.
END.
ELSE DO: 
   C-OBS[1] = CcbCDocu.glosa.
   C-OBS[2] = "".
   /* 
   C-OBS[1] = SUBSTRING(FacCPedi.Observa,1,INDEX(FacCPedi.Observa,'@') - 1).
   C-OBS[2] = SUBSTRING(FacCPedi.Observa,INDEX(FacCPedi.Observa,'@') + 2).
   */
END.
/*IF CcbDDocu.aftIgv THEN DO:
 *    F-ImpTot = CcbCDocu.ImpTot.
 * END.
 * ELSE DO:
 *    F-ImpTot = CcbCDocu.ImpVta.
 * END.*/  

/* ************************ cargamos variables ********************* */
FIND gn-ven WHERE 
     gn-ven.CodCia = CcbCDocu.CodCia AND  
     gn-ven.CodVen = CcbCDocu.CodVen 
     NO-LOCK NO-ERROR.
C-NomVen = CcbCDocu.CodVen.
IF AVAILABLE gn-ven THEN C-NomVen = C-NomVen + " - " + gn-ven.NomVen.
FIND gn-clie WHERE 
     gn-clie.codcia = cl-codcia AND  
     gn-clie.codcli = CcbCDocu.codcli NO-LOCK NO-ERROR.
     
C-DESCLI  = Gn-clie.codcli + ' - ' + Gn-clie.Nomcli.
C-DESCLI  = CcbCDocu.codcli + ' - ' + CcbCDocu.Nomcli.

/*IF FacCPedi.coddoc = "PED" THEN 
    X-ORDCOM = "Orden de Compra : ".
ELSE 
    X-ORDCOM = "Solicitud Cotiz.: ".*/

FIND gn-ConVt WHERE gn-ConVt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
C-NomCon = CcbCDocu.FmaPgo.
IF AVAILABLE gn-ConVt THEN C-NomCon = gn-ConVt.Nombr.
IF CcbCDocu.Codmon = 2 THEN C-Moneda = "DOLARES".
ELSE C-Moneda = "SOLES".

/* ******************************************************************** */

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
chWorkSheet:Columns("B"):ColumnWidth = 7.
chWorkSheet:Columns("C"):ColumnWidth = 10.
chWorkSheet:Columns("D"):ColumnWidth = 4.
chWorkSheet:Columns("E"):ColumnWidth = 45.
chWorkSheet:Columns("F"):ColumnWidth = 11.
chWorkSheet:Columns("G"):ColumnWidth = 15.
chWorkSheet:Columns("H"):ColumnWidth = 10.
chWorkSheet:Columns("I"):ColumnWidth = 15.


t-Column = t-Column + 2.
cColumn = STRING(t-Column).
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = CcbCDocu.NomCli.
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = CcbCDocu.CodCli.

t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = CcbCDocu.dircli. 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = CcbCDocu.ruccli.


t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = c-nomcon.

t-Column = t-Column + 3.
cColumn = STRING(t-Column).
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.fchdoc, '99/99/9999').
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "'" + CcbCDocu.NroPed. 
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "'" + CcbCDocu.NroRef.


t-Column = t-Column + 3.
cColumn = STRING(t-Column).
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = c-moneda. 
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "OFICINA".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.fchVto, '99/99/9999').
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = CcbCDocu.CodVen.
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "'" +  STRING(TIME,"HH:MM:SS") + "  " + S-USER-ID .
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = CcbCDocu.usuario.
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "'" + CcbCDocu.nroDoc.

t-Column = t-Column + 2.
cColumn = STRING(t-Column).
/*cRange = "A" + cColumn.
 * chWorkSheet:Range(cRange):Value = "ITEM".
 * cRange = "B" + cColumn.
 * chWorkSheet:Range(cRange):Value = "CODIGO".
 * cRange = "C" + cColumn.
 * chWorkSheet:Range(cRange):Value = "D E S C R I P C I O N".
 * cRange = "D" + cColumn.
 * chWorkSheet:Range(cRange):Value = "M A R C A".
 * cRange = "E" + cColumn.
 * chWorkSheet:Range(cRange):Value = "UND.".
 * cRange = "F" + cColumn.
 * chWorkSheet:Range(cRange):Value = "CANTIDAD".
 * cRange = "G" + cColumn.
 * chWorkSheet:Range(cRange):Value = "PRECI_UNI".
 * cRange = "H" + cColumn.
 * chWorkSheet:Range(cRange):Value = "DSCTO.".
 * cRange = "I" + cColumn.
 * chWorkSheet:Range(cRange):Value = "TOTAL NETO".*/

FOR EACH CcbDDocu OF CcbCDocu NO-LOCK,
        FIRST almmmatg OF CcbDDocu NO-LOCK
        BREAK BY CcbCDocu.NroPed BY CcbDDocu.NroItm:
    IF CcbDDocu.aftIgv THEN DO:
       F-PreUni = CcbDDocu.PreUni.
       F-ImpLin = CcbDDocu.ImpLin. 
    END.
    ELSE DO:
       F-PreUni = ROUND(CcbDDocu.PreUni / (1 + CcbCDocu.PorIgv / 100),2).
       F-ImpLin = ROUND(CcbDDocu.ImpLin / (1 + CcbCDocu.PorIgv / 100),2). 
    END.  
    
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    
    can = can + 1.
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value =  can.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + CcbDDocu.codmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbDDocu.UndVta.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbDDocu.candes.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = F-PreUni.
    /*cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = .*/
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = f-ImpLin.
END.

/* PIE DE PAGINA */
RUN bin/_numero(CcbCDocu.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = "SON : " + X-EnLetras + (IF CcbCDocu.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

t-column = t-column + 9.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = x-EnLetras.

t-column = t-column + 4.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "O.Compra:  " + CcbCDocu.NroOrd.
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.impbrt,'->>,>>>,>>9.99').
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.impdto,'->>,>>>,>>9.99').
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.impvta,'->>,>>>,>>9.99').

t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.PorIgv,'->>9.99') + " %".

t-column = t-column + 2.
cColumn = STRING(t-Column).
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.impigv,'->>,>>>,>>9.99').
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.imptot,'->>,>>>,>>9.99').
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "S/.        " + STRING(CcbCDocu.imptot,'->>,>>>,>>9.99').

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel2 V-table-Win 
PROCEDURE Excel2 :
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
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE F-PreUni                LIKE CcbDDocu.Preuni.
DEFINE VARIABLE F-ImpLin                LIKE CcbDDocu.ImpLin.
DEFINE VARIABLE F-ImpTot                LIKE CcbCDocu.ImpTot.

DEF VAR C-NomVen   AS CHAR FORMAT "X(30)"       NO-UNDO.
DEF VAR C-Moneda   AS CHAR FORMAT "X(7)"        NO-UNDO.
DEF VAR C-NomCon   AS CHAR FORMAT "X(30)"       NO-UNDO.
DEF VAR X-ORDCOM   AS CHARACTER FORMAT "X(18)"  NO-UNDO.
DEF VAR X-EnLetras AS CHAR FORMAT "x(100)"      NO-UNDO.
DEF VAR C-OBS      AS CHAR EXTENT 2             NO-UNDO.
DEF VAR K          AS INTEGER              NO-UNDO.
DEF VAR iItm       AS INTEGER              NO-UNDO.

IF NUM-ENTRIES(CcbCDocu.glosa,"-") - 1 > 6 THEN DO:
   DO K = 2 TO 7:
      IF ENTRY(K,CcbCDocu.glosa,"-") <> "" THEN 
         C-OBS[1] = C-OBS[1] + "- " + ENTRY(K,CcbCDocu.glosa,"-").
   END.
   DO K = 8 TO NUM-ENTRIES(CcbCDocu.glosa,"-"):
      IF ENTRY(K,CcbCDocu.glosa,"-") <> "" THEN 
         C-OBS[2] = C-OBS[2] + "- " + ENTRY(K,CcbCDocu.glosa,"-").
   END.
END.
ELSE DO: 
   C-OBS[1] = CcbCDocu.glosa.
   C-OBS[2] = "".
END.
/* ************************ cargamos variables ********************* */
FIND gn-ven WHERE 
     gn-ven.CodCia = CcbCDocu.CodCia AND  
     gn-ven.CodVen = CcbCDocu.CodVen 
     NO-LOCK NO-ERROR.
C-NomVen = CcbCDocu.CodVen.
IF AVAILABLE gn-ven THEN C-NomVen = C-NomVen + " - " + gn-ven.NomVen.
FIND gn-clie WHERE 
     gn-clie.codcia = cl-codcia AND  
     gn-clie.codcli = CcbCDocu.codcli NO-LOCK NO-ERROR.
     
FIND gn-ConVt WHERE gn-ConVt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
C-NomCon = CcbCDocu.FmaPgo.
IF AVAILABLE gn-ConVt THEN C-NomCon = gn-ConVt.Nombr.
IF CcbCDocu.Codmon = 2 THEN C-Moneda = "DOLARES".
ELSE C-Moneda = "SOLES".

/* ******************************************************************** */

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

DEF var x-Plantilla AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION 'Plantillas' KEY 'Carpeta' VALUE x-Plantilla .
x-Plantilla = x-Plantilla + "FacturaTienda.xlt".

chWorkbook = chExcelApplication:Workbooks:Add(x-Plantilla).

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 6.
chWorkSheet:Columns("B"):ColumnWidth = 7.
chWorkSheet:Columns("C"):ColumnWidth = 50.
chWorkSheet:Columns("D"):ColumnWidth = 15.
chWorkSheet:Columns("E"):ColumnWidth = 10.
chWorkSheet:Columns("F"):ColumnWidth = 12.
chWorkSheet:Columns("G"):ColumnWidth = 12.
chWorkSheet:Columns("H"):ColumnWidth = 12.

t-Column = 9.
cColumn = STRING(t-Column).
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = CcbCDocu.CodDoc + '-' + CcbCDocu.nroDoc. 


t-Column = t-Column + 2.
cColumn = STRING(t-Column).

cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = 'Señor: ' + CcbCDocu.NomCli.
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = 'Codigo: ' + CcbCDocu.CodCli.

t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = 'Dirección: ' + CcbCDocu.dircli. 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = 'RUC: ' + CcbCDocu.ruccli.

t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = c-nomcon.

t-Column = t-Column + 1.
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Pedido: " + CcbCDocu.NroPed. 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = 'Fecha Emision: ' + STRING(CcbCDocu.fchdoc, '99/99/9999').

t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = 'Moneda: ' + c-moneda. 
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "'" + CcbCDocu.NroRef.
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = 'Fecha Vcto: ' + STRING(CcbCDocu.fchVto, '99/99/9999').

t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Vendedor: " + CcbCDocu.CodVen + '-' + c-NomVen.
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "OFICINA".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Hora: " +  STRING(TIME,"HH:MM:SS") + "  " + S-USER-ID .
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = CcbCDocu.usuario.

t-Column = t-Column + 6.
cColumn = STRING(t-Column).

FOR EACH CcbDDocu OF CcbCDocu NO-LOCK,
        FIRST almmmatg OF CcbDDocu NO-LOCK
        BREAK BY CcbCDocu.NroPed BY CcbDDocu.NroItm DESC:
    IF CcbDDocu.aftIgv THEN DO:
       F-PreUni = CcbDDocu.PreUni.
       F-ImpLin = CcbDDocu.ImpLin. 
    END.
    ELSE DO:
       F-PreUni = ROUND(CcbDDocu.PreUni / (1 + CcbCDocu.PorIgv / 100),2).
       F-ImpLin = ROUND(CcbDDocu.ImpLin / (1 + CcbCDocu.PorIgv / 100),2). 
    END.  

        /*Agrega Row*/
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):EntireRow:INSERT.

    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbDDocu.NroItm.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + CcbDDocu.codmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbDDocu.UndVta.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbDDocu.candes.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = F-PreUni.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = f-ImpLin.
    iItm = iItm + 1.

END.

/* PIE DE PAGINA */
RUN bin/_numero(CcbCDocu.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = "SON : " + X-EnLetras + (IF CcbCDocu.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

t-column = t-column + iItm + 4.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = x-EnLetras.

t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "O.Compra:  " + CcbCDocu.NroOrd.
/****************
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.impbrt,'->>,>>>,>>9.99').
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.impdto,'->>,>>>,>>9.99').
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.impvta,'->>,>>>,>>9.99').

t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.PorIgv,'->>9.99') + " %".

t-column = t-column + 2.
cColumn = STRING(t-Column).
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.impigv,'->>,>>>,>>9.99').
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.imptot,'->>,>>>,>>9.99').
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "S/.        " + STRING(CcbCDocu.imptot,'->>,>>>,>>9.99').

*******/

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Cheque V-table-Win 
PROCEDURE Genera-Cheque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cliename LIKE Gn-Clie.Nomcli.
    DEFINE VARIABLE clieruc LIKE Gn-Clie.Ruc.

    FIND Gn-Clie WHERE
        Gn-Clie.Codcia = cl-codcia AND
        Gn-Clie.CodCli = T-CcbCCaja.Voucher[10]
        NO-LOCK NO-ERROR.
    IF AVAILABLE Gn-Clie THEN
        ASSIGN
            cliename = Gn-Clie.Nomcli
            clieruc = Gn-Clie.Ruc.

    CREATE B-CcbCDocu.
    ASSIGN
        B-CcbCDocu.CodCia = S-CodCia
        B-CcbCDocu.CodDiv = S-CodDiv
        B-CcbCDocu.CodDoc = "CHC"
        B-CcbCDocu.CodCli = T-CcbCCaja.Voucher[10]
        B-CcbCDocu.NomCli = cliename
        B-CcbCDocu.RucCli = clieRuc
        B-CcbCDocu.FlgEst = "P"
        B-CcbCDocu.Usuario = s-User-Id
        B-CcbCDocu.TpoCmb = T-CcbCCaja.TpoCmb 
        B-CcbCDocu.FchDoc = TODAY
        B-CcbCDocu.CodRef = CcbCCaja.CodDoc
        B-CcbCDocu.NroRef = CcbCCaja.NroDoc.
    IF T-CcbCCaja.ImpNac[2] + T-CcbCCaja.ImpUsa[2] > 0 THEN
        ASSIGN
            B-CcbCDocu.NroDoc = T-CcbCCaja.Voucher[2]
            B-CcbCDocu.CodMon = IF T-ccbCCaja.ImpNac[2] <> 0 THEN 1 ELSE 2
            B-CcbCDocu.ImpTot = IF T-ccbCCaja.ImpNac[2] <> 0 THEN
                T-ccbCCaja.ImpNac[2] ELSE T-ccbCCaja.ImpUsa[2]
            B-CcbCDocu.SdoAct = IF T-ccbCCaja.ImpNac[2] <> 0 THEN
                T-ccbCCaja.ImpNac[2] ELSE T-ccbCCaja.ImpUsa[2]
            B-CcbCDocu.ImpBrt = IF T-ccbCCaja.ImpNac[2] <> 0 THEN
                T-ccbCCaja.ImpNac[2] ELSE T-ccbCCaja.ImpUsa[2]
            B-CcbCDocu.FchVto = T-CcbCCaja.FchVto[2].
    ELSE
        ASSIGN
            B-CcbCDocu.NroDoc = T-CcbCCaja.Voucher[3]
            B-CcbCDocu.CodMon = IF T-ccbCCaja.ImpNac[3] <> 0 THEN 1 ELSE 2
            B-CcbCDocu.ImpTot = IF T-ccbCCaja.ImpNac[3] <> 0 THEN
                T-ccbCCaja.ImpNac[3] ELSE T-ccbCCaja.ImpUsa[3]
            B-CcbCDocu.SdoAct = IF T-ccbCCaja.ImpNac[3] <> 0 THEN
                T-ccbCCaja.ImpNac[3] ELSE T-ccbCCaja.ImpUsa[3]
            B-CcbCDocu.ImpBrt = IF T-ccbCCaja.ImpNac[3] <> 0 THEN
                T-ccbCCaja.ImpNac[3] ELSE T-ccbCCaja.ImpUsa[3]
            B-CcbCDocu.FchVto = T-CcbCCaja.FchVto[3].
    RELEASE B-CcbCDocu.

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

DEFINE VARIABLE X_cto1 AS DEC NO-UNDO.
DEFINE VARIABLE X_cto2 AS DEC NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
   FOR EACH PEDI WHERE PEDI.CanPed > 0, FIRST Almmmatg OF PEDI NO-LOCK
       BY PEDI.NroItm:
       CREATE CcbDDocu.
       BUFFER-COPY PEDI TO CcbDDocu
           ASSIGN 
                CcbDDocu.CodCia = CcbCDocu.CodCia 
                CcbDDocu.CodDiv = CcbCDocu.CodDiv
                CcbDDocu.CodDoc = CcbCDocu.CodDoc 
                CcbDDocu.NroDoc = CcbCDocu.NroDoc
                CcbDDocu.FchDoc = TODAY
                CcbDDocu.CanDes = PEDI.CanPed
                CcbDDOcu.CanDev = 0.                /* Control de Devoluciones */
       /* Guarda Costos */
       IF almmmatg.monvta = 1 THEN DO:
           x_cto1 = ROUND(Almmmatg.Ctotot * CcbDDocu.CanDes * CcbDDocu.Factor,2).
           x_cto2 = ROUND((Almmmatg.Ctotot * CcbDDocu.CanDes * CcbDDocu.Factor) / Almmmatg.Tpocmb,2).
       END.
       IF almmmatg.monvta = 2 THEN DO:
           x_cto1 = ROUND(Almmmatg.Ctotot * CcbDDocu.CanDes * CcbDDocu.Factor * Almmmatg.TpoCmb, 2).
           x_cto2 = ROUND((Almmmatg.Ctotot * CcbDDocu.CanDes * CcbDDocu.Factor), 2).
       END.
       CcbDDocu.ImpCto = IF CcbCDocu.Codmon = 1 THEN x_cto1 ELSE x_cto2.
       CcbCDocu.ImpCto = CcbCDocu.ImpCto + CcbDDocu.ImpCto.
   END.
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

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
    /*{vta2/graba-totales-fac.i}*/
    {vtagn/i-total-factura-sunat.i &Cabecera="CcbCDocu" &Detalle="CcbDDocu"}

    /* ****************************************************************************************** */
    /* Importes SUNAT */
    /* ****************************************************************************************** */
    DEF VAR hProc AS HANDLE NO-UNDO.
    RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
    RUN tabla-ccbcdocu IN hProc (INPUT Ccbcdocu.CodDiv,
                                 INPUT Ccbcdocu.CodDoc,
                                 INPUT Ccbcdocu.NroDoc,
                                 OUTPUT pMensaje).
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
    DELETE PROCEDURE hProc.
    /* ****************************************************************************************** */
    /* ****************************************************************************************** */

    /* RHC 30-11-2006 Transferencia Gratuita */
    IF LOOKUP(Ccbcdocu.FmaPgo, "899,900") > 0 THEN Ccbcdocu.sdoact = 0.
    IF Ccbcdocu.sdoact <= 0 
    THEN ASSIGN
            Ccbcdocu.fchcan = TODAY
            Ccbcdocu.flgest = 'C'.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Ingreso-a-caja V-table-Win 
PROCEDURE Ingreso-a-caja :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR s-CodDoc AS CHAR.

s-CodDoc = "I/C".

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR'.
    /* Cabecera de Caja */
    FIND FacCorre WHERE
        FacCorre.CodCia = s-codcia AND
        FacCorre.CodDoc = s-coddoc AND
        FacCorre.NroSer = s-ptovta
        EXCLUSIVE-LOCK.

    CREATE CcbCCaja.
    ASSIGN
        CcbCCaja.CodCia     = s-codcia
        CcbCCaja.CodDoc     = s-coddoc
        CcbCCaja.NroDoc     = STRING(faccorre.nroser, "999") +
            STRING(faccorre.correlativo, "999999")
        CcbcCaja.CodDiv     = S-CODDIV
        CcbcCaja.CodCli     = Ccbcdocu.codcli
        CcbcCaja.nomcli     = Ccbcdocu.nomcli
        Ccbccaja.fchdoc     = Ccbcdocu.fchdoc
        CcbcCaja.CodMon     = Ccbcdocu.codmon
        CcbCCaja.Tipo       = s-tipo
        CcbCCaja.usuario    = s-user-id
        CcbCCaja.CodCaja    = S-CODTER
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    
    FIND FIRST t-ccbccaja.
    ASSIGN
        CcbCCaja.CodBco[2]  = t-CcbCCaja.CodBco[2]
        CcbCCaja.CodBco[3]  = t-CcbCCaja.CodBco[3]
        CcbCCaja.CodBco[4]  = t-CcbCCaja.CodBco[4]
        CcbCCaja.CodBco[5]  = t-CcbCCaja.CodBco[5]
        CcbCCaja.CodBco[7]  = t-CcbCCaja.CodBco[7]
        CcbCCaja.CodBco[8]  = t-CcbCCaja.CodBco[8]
        CcbCCaja.Codcta[5]  = t-CcbCCaja.CodBco[5]
        CcbCCaja.FchVto[2]  = t-CcbCCaja.FchVto[2]
        CcbCCaja.FchVto[3]  = t-CcbCCaja.FchVto[3]
        CcbCCaja.ImpNac[1]  = t-CcbCCaja.ImpNac[1]
        CcbCCaja.ImpNac[2]  = t-CcbCCaja.ImpNac[2]
        CcbCCaja.ImpNac[3]  = t-CcbCCaja.ImpNac[3]
        CcbCCaja.ImpNac[4]  = t-CcbCCaja.ImpNac[4]
        CcbCCaja.ImpNac[5]  = t-CcbCCaja.ImpNac[5]
        CcbCCaja.ImpNac[6]  = t-CcbCCaja.ImpNac[6]
        CcbCCaja.ImpNac[7]  = t-CcbCCaja.ImpNac[7]
        CcbCCaja.ImpNac[8]  = t-CcbCCaja.ImpNac[8]
        CcbCCaja.ImpNac[9]  = t-CcbCCaja.ImpNac[9]
        CcbCCaja.ImpNac[10]  = t-CcbCCaja.ImpNac[10]
        CcbCCaja.ImpUsa[1]  = t-CcbCCaja.ImpUsa[1]
        CcbCCaja.ImpUsa[2]  = t-CcbCCaja.ImpUsa[2]
        CcbCCaja.ImpUsa[3]  = t-CcbCCaja.ImpUsa[3]
        CcbCCaja.ImpUsa[4]  = t-CcbCCaja.ImpUsa[4]
        CcbCCaja.ImpUsa[5]  = t-CcbCCaja.ImpUsa[5]
        CcbCCaja.ImpUsa[6]  = t-CcbCCaja.ImpUsa[6]
        CcbCCaja.ImpUsa[7]  = t-CcbCCaja.ImpUsa[7]
        CcbCCaja.ImpUsa[8]  = t-CcbCCaja.ImpUsa[8]
        CcbCCaja.ImpUsa[9]  = t-CcbCCaja.ImpUsa[9]
        CcbCCaja.ImpUsa[10]  = t-CcbCCaja.ImpUsa[10]
        CcbCCaja.Voucher[2] = t-CcbCCaja.Voucher[2]
        CcbCCaja.Voucher[3] = t-CcbCCaja.Voucher[3]
        CcbCCaja.Voucher[4] = t-CcbCCaja.Voucher[4]
        CcbCCaja.Voucher[5] = t-CcbCCaja.Voucher[5]
        CcbCCaja.Voucher[6] = t-CcbCCaja.Voucher[6]
        CcbCCaja.Voucher[7] = t-CcbCCaja.Voucher[7]
        CcbCCaja.Voucher[8] = t-CcbCCaja.Voucher[8]
        CcbCCaja.Voucher[9] = t-CcbCCaja.Voucher[9]
        CcbCCaja.Voucher[10] = t-CcbCCaja.Voucher[10]
        CcbCCaja.VueNac     = t-CcbCCaja.VueNac
        CcbCCaja.VueUsa     = t-CcbCCaja.VueUsa
        CcbCCaja.TpoCmb     = t-CcbCCaja.TpoCmb
        CcbcCaja.Flgest     = "C".

    /* Crea Detalle de Caja */
    CREATE ccbdcaja.
    ASSIGN
        CcbDCaja.CodCia = s-codcia
        CcbDCaja.CodDoc = ccbccaja.coddoc
        CcbDCaja.NroDoc = ccbccaja.nrodoc
        CcbDCaja.CodCli = ccbccaja.codcli
        CcbDCaja.CodMon = ccbcdocu.codmon
        CcbDCaja.CodRef = ccbcdocu.coddoc
        CcbDCaja.FchDoc = ccbccaja.fchdoc
        CcbDCaja.ImpTot = ccbcdocu.imptot
        CcbDCaja.NroRef = ccbcdocu.nrodoc
        CcbDCaja.TpoCmb = ccbccaja.tpocmb.

    /* Cancela cuenta por cobrar */
    ASSIGN 
        ccbcdocu.sdoact = ccbcdocu.sdoact - ccbdcaja.imptot.
    IF ccbcdocu.sdoact <= 0 THEN DO: /* OJO */
        ASSIGN
            ccbcdocu.fchcan = TODAY
            ccbcdocu.flgest = "C".
    END.

    /* Genera Cheque */
    IF ((T-CcbCCaja.Voucher[2] <> "" ) AND
        (T-CcbCCaja.ImpNac[2] + T-CcbCCaja.ImpUsa[2]) > 0 ) OR
        ((T-CcbCCaja.Voucher[3] <> "" ) AND
        (T-CcbCCaja.ImpNac[3] + T-CcbCCaja.ImpUsa[3]) > 0) THEN
        RUN Genera-Cheque.

    /* Actualiza la Boleta de Deposito */
    IF T-CcbCCaja.Voucher[5] <> "" AND
        (T-CcbCCaja.ImpNac[5] + T-CcbCCaja.ImpUsa[5]) > 0 THEN DO:
        RUN proc_AplicaDoc(
            "BD",
            T-CcbCCaja.Voucher[5],
            ccbccaja.nrodoc,
            T-CcbCCaja.tpocmb,
            T-CcbCCaja.ImpNac[5],
            T-CcbCCaja.ImpUsa[5]
            ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.

    /* Aplica Nota de Credito */
    IF CAN-FIND(FIRST wrk_dcaja) THEN DO:
        FOR EACH wrk_dcaja NO-LOCK,
                FIRST CcbCDocu WHERE CcbCDocu.CodCia = wrk_dcaja.CodCia
                AND CcbCDocu.CodCli = wrk_dcaja.CodCli
                AND CcbCDocu.CodDoc = wrk_dcaja.CodRef
                AND CcbCDocu.NroDoc = wrk_dcaja.NroRef NO-LOCK:
            RUN proc_AplicaDoc(
                CcbCDocu.CodDoc,
                CcbCDocu.NroDoc,
                ccbccaja.nrodoc,
                T-CcbCCaja.tpocmb,
                IF CcbCDocu.CodMon = 1 THEN wrk_dcaja.Imptot ELSE 0,
                IF CcbCDocu.CodMon = 2 THEN wrk_dcaja.Imptot ELSE 0
                ).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        END.
    END.

    /* Aplica Anticipo */
    IF T-CcbCCaja.Voucher[7] <> "" AND
        (T-CcbCCaja.ImpNac[7] + T-CcbCCaja.ImpUsa[7]) > 0 THEN DO:
        RUN proc_AplicaDoc(
            /*"A/R",*/
            T-CcbCCaja.CodBco[7],
            T-CcbCCaja.Voucher[7],
            ccbccaja.nrodoc,
            T-CcbCCaja.tpocmb,
            T-CcbCCaja.ImpNac[7],
            T-CcbCCaja.ImpUsa[7]
            ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.
END.
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
  FIND FacCorre WHERE FacCorre.codcia = s-codcia
      AND FacCorre.coddoc = s-coddoc
      AND FacCorre.nroser = s-nroser
      NO-LOCK NO-ERROR.
  IF FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Esta serie está desactivada' VIEW-AS ALERT-BOX WARNING.
      RETURN "ADM-ERROR".
  END.

  {adm/i-DocPssw.i s-CodCia s-CodDoc ""ADD""}

  RUN Actualiza-Deta.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Numero-de-Documento(NO).
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY 
         TODAY @ CcbCDocu.FchDoc
         TODAY @ CcbCDocu.FchVto
         FacCfgGn.CliVar @ CcbCDocu.CodCli
         FacCfgGn.Tpocmb[1] @ CcbCDocu.TpoCmb
         /*STRING (I-NroSer, '999') + STRING (I-NroDoc, '999999')  @ Ccbcdocu.nrodoc*/
         I-NroSer @ FILL-IN-NroSer
         I-NroDoc @ FILL-IN-NroDoc
         '000' @ CcbCDocu.FmaPgo.
     FILL-IN-NroDoc = I-NroDoc.
     FILL-IN-NroSer = I-NroSer.
  END.
  APPLY 'LEAVE':U TO CcbCDocu.FmaPgo IN FRAME {&FRAME-NAME}.
  ASSIGN
      s-TpoCmb = FacCfgGn.Tpocmb[1]
      s-PorIgv = FacCfgGn.PorIgv.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('Browse').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       SOLO SE PUEDEN CREAR FACTURAS
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {vtagn/i-faccorre-01.i &Codigo = s-CodDoc &Serie = s-NroSer }

  ASSIGN 
      I-NroSer = s-NroSer
      I-NroDoc = INTEGER(FILL-IN-NroDoc)
      NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
      MESSAGE 'Error en el número correlativo' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN-NroDoc IN FRAME {&FRAME-NAME}.
      UNDO, RETURN 'ADM-ERROR'.
  END.
  FIND B-Ccbcdocu WHERE B-Ccbcdocu.codcia = s-codcia
      AND B-Ccbcdocu.coddiv = s-coddiv
      AND B-Ccbcdocu.coddoc = s-coddoc
      AND B-Ccbcdocu.nrodoc = STRING(i-NroSer, '999') + STRING(i-NroDoc, '999999')
      NO-LOCK NO-ERROR.
  IF AVAILABLE B-Ccbcdocu THEN DO:
      MESSAGE 'Comprobante YA registrado' VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN 'ADM-ERROR'.
  END.
  IF i-NroDoc >= FacCorre.Correlativo THEN FacCorre.Correlativo = i-NroDoc + 1.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN 
      CcbCDocu.CodCia = S-CODCIA
      CcbCDocu.CodDoc = S-CODDOC
      CcbCDocu.PorIgv = S-PORIGV
      CcbCDocu.CodMov = S-CODMOV 
      CcbCDocu.CodDiv = S-CODDIV
      CcbCDocu.NroDoc = STRING(I-NroSer, FILL-IN-NroSer:FORMAT IN FRAME {&FRAME-NAME}) + 
                        STRING(I-NroDoc, FILL-IN-NroDoc:FORMAT IN FRAME {&FRAME-NAME}).
  ASSIGN 
      CcbCDocu.FchAte = TODAY
      CcbCDocu.FlgEst = "P"
      CcbCDocu.FlgSit = "P"
      CcbCDocu.FlgAte = "P"
      CcbCDocu.Tipo   = "MOSTRADOR"
      CcbCDocu.CodCaja= s-CodTer
      CcbCDocu.TipVta = "1"
      CcbCDocu.TpoFac = S-TPOFAC
      CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
      CcbCDocu.FlgAte = 'D'
      CcbCDocu.usuario = S-USER-ID
      CcbCDocu.HorCie = STRING(TIME, 'HH:MM').

  FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
      AND gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie  THEN DO:
      ASSIGN 
          CcbCDocu.CodDpto = gn-clie.CodDept 
          CcbCDocu.CodProv = gn-clie.CodProv 
          CcbCDocu.CodDist = gn-clie.CodDist.
  END.
  /* Guarda Centro de Costo */
  FIND gn-ven WHERE
      gn-ven.codcia = s-codcia AND
      gn-ven.codven = ccbcdocu.codven
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-ven THEN ccbcdocu.cco = gn-ven.cco.
  
  RUN Genera-Detalle.    /* Detalle de la Factura/Boleta */ 
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE 'NO pudo actualizar el detalle del comprobante'
          VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN "ADM-ERROR".
  END.
  RUN Graba-Totales.
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE 'NO pudo actualizar el total de la factura'
          VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN "ADM-ERROR".
  END.
  /* Descarga de Almacen */
  RUN vta2/act_alm (ROWID(CcbCDocu)).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* Pantalla de Cancelación */
  RUN Cancelacion.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* Ingreso a caja */
   RUN Ingreso-a-caja.
   IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

   IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.

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
  
  /* Code placed here will execute PRIOR to standard behavior. */
  
  /* ********************************************* */
  /* Inicio de actividades facturación electrónica */
  /* ********************************************* */
/*   DEF VAR pStatus AS LOG.                                                 */
/*   RUN sunat\p-inicio-actividades (INPUT Ccbcdocu.fchdoc, OUTPUT pStatus). */
/*   IF pStatus = YES THEN DO:     /* Ya iniciaron las actividades */        */
  IF s-Sunat-Activo = YES THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  /* ********************************************* */
  
  IF CcbCDocu.FlgEst = "A" THEN DO:
     MESSAGE 'El documento se encuentra Anulado...' VIEW-AS ALERT-BOX.
     RETURN 'ADM-ERROR'.
  END.
  IF Ccbcdocu.fmapgo <> '900' THEN DO:
      IF CcbCDocu.FlgEst = "C" AND Ccbcdocu.ImpTot > 0 THEN DO:
         MESSAGE 'El documento se encuentra Cancelado...' VIEW-AS ALERT-BOX.
         RETURN 'ADM-ERROR'.
      END.
  END.
  /* consistencia de la fecha del cierre del sistema */
  DEF VAR dFchCie AS DATE.
  RUN gn/fecha-de-cierre (OUTPUT dFchCie).
  IF ccbcdocu.fchdoc <= dFchCie THEN DO:
      MESSAGE 'NO se puede anular ningun documento antes del' (dFchCie + 1)
          VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  /* fin de consistencia */

  IF MONTH(Ccbcdocu.FchDoc) <> MONTH(TODAY) OR YEAR(Ccbcdocu.FchDoc) <> YEAR(TODAY) THEN DO:
    {adm/i-DocPssw.i s-CodCia s-CodDoc ""DEL""}
  END.
  
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
      DEF VAR cReturnValue AS CHAR NO-UNDO.
      RUN ccb/d-motanu (ccbcdocu.codcia, ccbcdocu.coddoc, ccbcdocu.nrodoc, s-user-id, OUTPUT cReturnValue).
      IF cReturnValue = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      /* TRACKING FACTURAS */
      RUN vtagn/pTracking-04 (s-CodCia,
                              Ccbcdocu.CodDiv,
                              Ccbcdocu.CodPed,
                              Ccbcdocu.NroPed,
                              s-User-Id,
                              'EFAC',
                              'A',
                              DATETIME(TODAY, MTIME),
                              DATETIME(TODAY, MTIME),
                              Ccbcdocu.coddoc,
                              Ccbcdocu.nrodoc,
                              Ccbcdocu.codref,
                              Ccbcdocu.nroref).

      /* Extorna Salida de Almacen */
      RUN vta2/des_alm (ROWID(CcbCDocu)).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      /* Eliminamos el detalle */
      RUN Borra-Detalle.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      FIND B-CDOCU WHERE ROWID(B-CDOCU) = ROWID(CcbCDocu) EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABL B-CDOCU THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN 
          B-CDOCU.FlgEst = "A"
          B-CDOCU.SdoAct = 0
          B-CDOCU.UsuAnu = S-USER-ID
          B-CDOCU.FchAnu = TODAY.
          /*B-CDOCU.Glosa  = "A N U L A D O".*/
      RELEASE B-CDOCU.
  END.
  RUN Procesa-Handle IN lh_Handle ('Browse').
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
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          FILL-IN-NroDoc:SENSITIVE = NO.
  END.
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
  IF AVAILABLE CcbCDocu THEN DO WITH FRAME {&FRAME-NAME}:
      DISPLAY
          INTEGER(SUBSTRING(Ccbcdocu.nrodoc,1,3)) @ FILL-IN-NroSer
          INTEGER(SUBSTRING(Ccbcdocu.nrodoc,4)) @ FILL-IN-NroDoc.

     IF CcbCDocu.FlgEst = "P" THEN F-Estado:SCREEN-VALUE = "PENDIENTE".
     IF CcbCDocu.FlgEst = "A" THEN F-Estado:SCREEN-VALUE = "ANULADO".
     IF CcbCDocu.FlgEst = "C" THEN F-Estado:SCREEN-VALUE = "CANCELADO".
     F-NomVen:screen-value = "".
     FIND gn-ven WHERE 
          gn-ven.CodCia = S-CODCIA AND 
          gn-ven.CodVen = CcbCDocu.CodVen 
          NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
     F-CndVta:SCREEN-VALUE = "".
     
     FIND gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
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
          FILL-IN-NroDoc:SENSITIVE = YES
          CcbCDocu.CodMon:SENSITIVE = NO
          CcbCDocu.FchVto:SENSITIVE = NO
          CcbCDocu.FmaPgo:SENSITIVE = NO
          CcbCDocu.NroOrd:SENSITIVE = NO
          CcbCDocu.NroPed:SENSITIVE = NO
          CcbCDocu.NroRef:SENSITIVE = NO
          CcbCDocu.RucCli:SENSITIVE = NO
          CcbCDocu.TpoCmb:SENSITIVE = NO
          CcbCDocu.CodAnt:SENSITIVE = NO.
      IF s-CodDoc = "BOL" THEN CcbCDocu.CodAnt:SENSITIVE = YES.
      APPLY 'entry' TO FILL-IN-NroDoc.
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
  IF s-Sunat-Activo = YES THEN DO:
      RUN sunat\r-impresion-documentos-sunat ( ROWID(Ccbcdocu), "O", NO ).
  END.
  ELSE DO:
      IF S-CODDOC = "FAC" THEN DO:
        IF ccbcdocu.codcli = '20337564373' AND YEAR(ccbcdocu.fchdoc) = 2007
        THEN RUN vta/r-facripley (ROWID(CcbCDocu)).
        ELSE DO:
            RUN VTA\R-IMPFAC2-1 (ROWID(CcbCDocu)).
        END.
      END.    

      IF S-CODDOC = "BOL" THEN DO:
         RUN VTA\R-IMPBOL2-1 (ROWID(CcbCDocu)).
      END.
  END.
 
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          FILL-IN-NroSer:FORMAT = TRIM(ENTRY(1,x-Formato,'-'))
          FILL-IN-NroDoc:FORMAT = TRIM(ENTRY(2,x-Formato,'-')).
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

/*   /* CANCELACION */                                                          */
/*   DEF VAR x-Importe AS DEC.                                                  */
/*   DEF VAR x-Mon AS INT.                                                      */
/*   DEFINE VARIABLE monto_ret AS DECIMAL NO-UNDO.                              */
/*   DEFINE VARIABLE dTpoCmb LIKE CcbcCaja.TpoCmb NO-UNDO.                      */
/*   DEF VAR s-ok AS LOGICAL INITIAL NO NO-UNDO.                                */
/*                                                                              */
/*   ASSIGN                                                                     */
/*     X-Importe = 0                                                            */
/*     x-mon = INTEGER(CcbCDocu.CodMon:SCREEN-VALUE IN FRAME {&FRAME-NAME}).    */
/*                                                                              */
/*   FOR EACH PEDI:                                                             */
/*       x-Importe = x-Importe + PEDI.ImpLin.                                   */
/*   END.                                                                       */
/*                                                                              */
/*   /* Retenciones */                                                          */
/*   FOR EACH wrk_ret:                                                          */
/*       DELETE wrk_ret.                                                        */
/*   END.                                                                       */
/*   /* N/C */                                                                  */
/*   FOR EACH wrk_dcaja:                                                        */
/*       DELETE wrk_dcaja.                                                      */
/*   END.                                                                       */
/*                                                                              */
/*   /* Ventana de Cancelación */                                               */
/*   DEF VAR t-CodDoc LIKE s-CodDoc.   /* Vamos a engañar al programa */        */
/*   t-CodDoc = s-CodDoc.                                                       */
/*   s-CodDoc = "I/C".                                                          */
/*   RUN ccb/d-canped-02a(                                                      */
/*       x-mon,                                                                 */
/*       X-Importe,                                                             */
/*       monto_ret,                                                             */
/*       Ccbcdocu.NomCli:SCREEN-VALUE IN FRAME {&FRAME-NAME},                   */
/*       TRUE,     /* como una venta contado - pago con tarjeta de credito */   */
/*       "M",      /* digitacion manual acepta pago con tarjetas de crédito **/ */
/*       OUTPUT s-ok                                                            */
/*       ).                                                                     */
/*                                                                              */
/*   s-CodDoc = t-CodDoc.                                                       */
  /* listo el engaño */

/*   IF s-ok = NO THEN RETURN "ADM-ERROR". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse'). 
  
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
  IF L-INCREMENTA  THEN
     FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = S-CODDOC AND
          FacCorre.NroSer = S-NROSER EXCLUSIVE-LOCK NO-ERROR.
  ELSE
     FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = S-CODDOC AND
          FacCorre.NroSer = S-NROSER NO-LOCK NO-ERROR.
  
  IF AVAILABLE FacCorre THEN DO:
     ASSIGN 
         I-NroDoc = FacCorre.Correlativo.
     IF L-INCREMENTA THEN ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
     I-NroSer = FacCorre.NroSer.
     /*S-CodAlm = FacCorre.CodAlm.*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_AplicaDoc V-table-Win 
PROCEDURE proc_AplicaDoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_CodDoc LIKE CcbCDocu.CodDoc.
    DEFINE INPUT PARAMETER para_NroDoc LIKE CcbDMov.NroDoc.
    DEFINE INPUT PARAMETER para_NroDocCja LIKE CcbDMov.NroDoc.    
    DEFINE INPUT PARAMETER para_TpoCmb LIKE CCBDMOV.TpoCmb.
    DEFINE INPUT PARAMETER para_ImpNac LIKE CcbDMov.ImpTot.
    DEFINE INPUT PARAMETER para_ImpUSA LIKE CcbDMov.ImpTot.

    DEFINE BUFFER B-CDocu FOR CcbCDocu.

    /* Tipo de Documento */
    FIND FacDoc WHERE
        FacDoc.CodCia = s-CodCia AND
        FacDoc.CodDoc = para_CodDoc
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacDoc THEN DO:
        MESSAGE
            para_CodDoc 'NO CONFIGURADO'
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        /* Busca Documento */
        FIND FIRST B-CDocu WHERE
            B-CDocu.CodCia = s-codcia AND
            B-CDocu.CodDoc = para_CodDoc AND
            B-CDocu.NroDoc = para_NroDoc
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE B-CDocu THEN DO:
            MESSAGE
                "DOCUMENTO" para_CodDoc para_NroDoc "NO REGISTRADO"
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.
        /* Crea Detalle de la Aplicación */
        CREATE CCBDMOV.
        ASSIGN
            CCBDMOV.CodCia = s-CodCia
            CCBDMOV.CodDiv = s-CodDiv
            CCBDMOV.NroDoc = B-CDocu.NroDoc
            CCBDMOV.CodDoc = B-CDocu.CodDoc
            CCBDMOV.CodMon = B-CDocu.CodMon
            CCBDMOV.CodRef = s-CodDoc
            CCBDMOV.NroRef = para_NroDocCja
            CCBDMOV.CodCli = B-CDocu.CodCli
            CCBDMOV.FchDoc = B-CDocu.FchDoc
            CCBDMOV.HraMov = STRING(TIME,"HH:MM:SS")
            CCBDMOV.TpoCmb = para_tpocmb
            CCBDMOV.usuario = s-User-ID.
        IF B-CDocu.CodMon = 1 THEN
            ASSIGN CCBDMOV.ImpTot = para_ImpNac.
        ELSE ASSIGN CCBDMOV.ImpTot = para_ImpUSA.
        IF FacDoc.TpoDoc THEN
            ASSIGN B-CDocu.SdoAct = B-CDocu.SdoAct + CCBDMOV.ImpTot.
        ELSE
            ASSIGN B-CDocu.SdoAct = B-CDocu.SdoAct - CCBDMOV.ImpTot.
        /* Cancela Documento */
        IF B-CDocu.SdoAct = 0 THEN
            ASSIGN 
                B-CDocu.FlgEst = "C"
                B-CDocu.FchCan = TODAY.
        ELSE
            ASSIGN
                B-CDocu.FlgEst = "P"
                B-CDocu.FchCan = ?.

        RELEASE B-CDocu.
        RELEASE Ccbdmov.
    END. /* DO TRANSACTION... */

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
        WHEN "codcli" THEN
            ASSIGN
                input-var-1 = s-coddiv
                input-var-2 = "G/R"
                input-var-3 = "P".
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
DEFINE VARIABLE X-ITMS AS DECIMAL NO-UNDO.
DO WITH FRAME {&FRAME-NAME} :
    IF Ccbcdocu.CodCli:SCREEN-VALUE = "" THEN DO:
       MESSAGE "Codigo de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO Ccbcdocu.CodCli.
       RETURN "ADM-ERROR".   
    END.
    FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
        AND  gn-clie.CodCli = Ccbcdocu.CodCli:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN DO:
       MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO Ccbcdocu.CodCli.
       RETURN "ADM-ERROR".   
    END.
    IF gn-clie.FlgSit = "I" THEN DO:
       MESSAGE "Cliente esta Inactivo" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO Ccbcdocu.CodCli.
       RETURN "ADM-ERROR".   
    END.
    IF gn-clie.FlgSit = "C" THEN DO:
       MESSAGE "Cliente esta Cesado" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO Ccbcdocu.CodCli.
       RETURN "ADM-ERROR".   
    END.
    IF LOOKUP(TRIM(Ccbcdocu.CodCli:SCREEN-VALUE), x-ClientesVarios) = 0
        AND LENGTH(TRIM(Ccbcdocu.CodCli:SCREEN-VALUE)) <> 11
        THEN DO:
        MESSAGE 'El codigo del cliente debe tener 11 digitos' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO Ccbcdocu.CodCli.
        RETURN 'ADM-ERROR'.
    END.
    /***** Valida Ingreso de Ruc. *****/
    IF s-CodDoc = "FAC" AND Ccbcdocu.RucCli:SCREEN-VALUE = '' THEN DO:
        MESSAGE "El Cliente NO tiene R.U.C." VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.CodCli.
        RETURN "ADM-ERROR".   
    END.      
    IF s-CodDoc = "FAC" THEN DO:
        /* dígito verificador */
        DEF VAR pResultado AS CHAR NO-UNDO.
        RUN lib/_ValRuc (Ccbcdocu.RucCli:SCREEN-VALUE, OUTPUT pResultado).
        IF pResultado = 'ERROR' THEN DO:
            MESSAGE 'Código RUC MAL registrado' VIEW-AS ALERT-BOX WARNING.
            APPLY 'ENTRY':U TO Ccbcdocu.CodCli.
            RETURN 'ADM-ERROR'.
        END.
    END.
   
    FOR EACH PEDI:
       X-ITMS = X-ITMS + PEDI.CanPed.
    END.

   IF X-ITMS = 0 THEN DO:
      MESSAGE "No existen items a generar" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO CcbCDocu.Glosa.
      RETURN "ADM-ERROR".   
   END.
   IF Ccbcdocu.CodVen:SCREEN-VALUE = "" THEN DO:
          MESSAGE "Codigo de Vendedor no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO Ccbcdocu.CodVen.
       RETURN "ADM-ERROR".   
    END.
    FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
                 AND  gn-ven.CodVen = Ccbcdocu.CodVen:screen-value 
                NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-ven THEN DO:
       MESSAGE "Codigo de Vendedor no existe" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO Ccbcdocu.CodVen.
       RETURN "ADM-ERROR".   
    END.
    ELSE DO:
        IF gn-ven.flgest = "C" THEN DO:
            MESSAGE "Codigo de Vendedor Cesado" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO Ccbcdocu.CodVen.
            RETURN "ADM-ERROR".   
        END.
    END.

    /* IMporte de control */
    DEF VAR x-ImpLin AS DEC NO-UNDO.
    x-ImpLin = 0.
    FOR EACH PEDI:
        x-ImpLin = x-ImpLin + PEDI.ImpLin.
    END.

    /* DNI */
    IF s-CodDoc = "BOL" AND x-ImpLin > 700 AND LENGTH(CcbCDocu.CodAnt:SCREEN-VALUE) <> 8
        THEN DO:
        MESSAGE 'Debe ingresar el DNI' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO CcbCDocu.CodAnt.
        RETURN 'ADM-ERROR'.
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
/* LAS FACTURAS Y BOLETAS NO SE PUEDEN MODIFICAR */
MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
RETURN "ADM-ERROR".
/*RETURN "ok".*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

