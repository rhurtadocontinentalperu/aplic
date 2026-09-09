&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CPEDI FOR FacCPedi.



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
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-NROSER  AS INTEGER.
DEFINE SHARED VARIABLE S-IMPFLE  AS DECIMAL.

DEFINE SHARED TEMP-TABLE DETA LIKE CcbDDocu.
DEFINE TEMP-TABLE T-DETA LIKE Ccbddocu.     /* PARA EL CONTROL DE PRECIOS AL SELCCIONAR LAS G/R */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE s-aplic-fact-ade AS LOG NO-UNDO.    /* Aplicacion de la factura adelantada */
DEFINE VARIABLE s-asigna-pedido AS CHAR INIT 'NO' NO-UNDO.
DEFINE VARIABLE s-asigna-guia   AS CHAR INIT 'NO' NO-UNDO.

DEFINE VARIABLE I              AS INTEGER   NO-UNDO.
/*DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.*/
DEFINE VARIABLE C-NRODOC       AS CHAR      NO-UNDO.
DEFINE VARIABLE C-CODPED       AS CHAR      NO-UNDO.
DEFINE VARIABLE C-NROPED       AS CHAR      NO-UNDO.
DEFINE VARIABLE C-NROGUI       AS CHAR      NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NRODOC       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-ListPr       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE S-CODCLI       AS CHARACTER NO-UNDO. 
DEFINE VARIABLE S-CODALM       AS CHAR      NO-UNDO.
DEFINE VARIABLE S-CODMOV       AS INTEGER   NO-UNDO. 
DEFINE VARIABLE I-CODMON       AS INTEGER   NO-UNDO. 
DEFINE VARIABLE R-ROWID        AS ROWID     NO-UNDO. 
DEFINE VARIABLE C-CODVEN       AS CHAR      NO-UNDO.
DEFINE VARIABLE D-FCHVTO       AS DATE      NO-UNDO.

DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER B-CCDOCU FOR CcbCDocu.

FIND FacDocum WHERE FacDocum.CodCia = S-CODCIA AND
     FacDocum.CodDoc = S-CODDOC NO-LOCK NO-ERROR.
IF AVAILABLE FacDocum THEN S-CODMOV = FacDocum.CodMov.

FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV AND
     FacCorre.NroSer = S-NROSER NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN S-CodAlm = FacCorre.CodAlm 
          I-NroSer = FacCorre.NroSer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE TEMP-TABLE T-CPEDM LIKE FacCPedi.
   /*FIELD CodRef LIKE CcbCDocu.CodRef.*/
DEFINE TEMP-TABLE T-DPEDM LIKE FacDPedi.

DEFINE VARIABLE RPTA        AS CHARACTER NO-UNDO.

DEFINE VARIABLE x-cto1 AS DECI INIT 0.
DEFINE VARIABLE x-cto2 AS DECI INIT 0.

DEFINE BUFFER F-CDOCU FOR CcbCDocu.
DEFINE BUFFER F-DDOCU FOR CcbDDocu.

DEF VAR s-FechaI AS DATETIME NO-UNDO.
DEF VAR s-FechaT AS DATETIME NO-UNDO.

s-FechaI = DATETIME(TODAY, MTIME).

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
&Scoped-Define ENABLED-FIELDS CcbCDocu.CodCli CcbCDocu.NomCli ~
CcbCDocu.DirCli CcbCDocu.RucCli CcbCDocu.CodVen CcbCDocu.NroOrd ~
CcbCDocu.FmaPgo CcbCDocu.Glosa 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define ENABLED-OBJECTS RECT-68 
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.CodCli CcbCDocu.NomCli CcbCDocu.TpoCmb CcbCDocu.DirCli ~
CcbCDocu.FchVto CcbCDocu.RucCli CcbCDocu.NroPed CcbCDocu.CodVen ~
CcbCDocu.NroOrd CcbCDocu.FmaPgo CcbCDocu.CodMon CcbCDocu.NroRef ~
CcbCDocu.Glosa 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS F-Estado F-nOMvEN F-CndVta 

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

DEFINE RECTANGLE RECT-68
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 93 BY 7.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.NroDoc AT ROW 1.27 COL 9 COLON-ALIGNED FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .81
          FONT 1
     F-Estado AT ROW 1.27 COL 25 COLON-ALIGNED NO-LABEL
     CcbCDocu.FchDoc AT ROW 1.27 COL 78 COLON-ALIGNED
          LABEL "F/ Emision"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.CodCli AT ROW 2.08 COL 9 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 9 
     CcbCDocu.NomCli AT ROW 2.08 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 48 BY .81
     CcbCDocu.TpoCmb AT ROW 2.08 COL 78 COLON-ALIGNED
          LABEL "T/ Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.DirCli AT ROW 2.88 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
     CcbCDocu.FchVto AT ROW 2.88 COL 78 COLON-ALIGNED
          LABEL "Vencimient"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.RucCli AT ROW 3.69 COL 9 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCDocu.NroPed AT ROW 3.69 COL 78 COLON-ALIGNED FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.CodVen AT ROW 4.5 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     F-nOMvEN AT ROW 4.5 COL 15 COLON-ALIGNED NO-LABEL
     CcbCDocu.NroOrd AT ROW 4.5 COL 78 COLON-ALIGNED
          LABEL "O/ Compra" FORMAT "x(12)"
          VIEW-AS FILL-IN 
          SIZE 12.29 BY .81
     CcbCDocu.FmaPgo AT ROW 5.31 COL 9 COLON-ALIGNED
          LABEL "Cond.Vta"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     F-CndVta AT ROW 5.31 COL 15 COLON-ALIGNED NO-LABEL
     CcbCDocu.CodMon AT ROW 5.31 COL 80.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 10.72 BY .81
     CcbCDocu.NroRef AT ROW 6.12 COL 9 COLON-ALIGNED
          LABEL "Guias" FORMAT "X(45)"
          VIEW-AS FILL-IN 
          SIZE 48.72 BY .81
     CcbCDocu.Glosa AT ROW 6.92 COL 9 COLON-ALIGNED
          LABEL "Glosa"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
          BGCOLOR 11 FGCOLOR 9 
     "Moneda:" VIEW-AS TEXT
          SIZE 6.43 BY .5 AT ROW 5.31 COL 74
     RECT-68 AT ROW 1 COL 1 WIDGET-ID 4
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
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
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
         HEIGHT             = 7.12
         WIDTH              = 93.43.
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
   EXP-FORMAT                                                           */
/* SETTINGS FOR RADIO-SET CcbCDocu.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-nOMvEN IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.FchVto IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.FmaPgo IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.Glosa IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NroOrd IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NroPed IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NroRef IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.RucCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.TpoCmb IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
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
FOR EACH DETA:
    DELETE DETA.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Guias V-table-Win 
PROCEDURE Actualiza-Guias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF s-asigna-guia = 'NO' THEN RETURN.

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND B-CDOCU WHERE B-CDOCU.CodCia = Ccbcdocu.codcia
        AND  B-CDOCU.CodDoc = Ccbcdocu.codref
        AND  B-CDOCU.NroDoc = Ccbcdocu.nroref
        EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE B-CDOCU THEN DO :
        ASSIGN 
            B-CDOCU.FlgEst = "F"
            B-CDOCU.CodRef = CcbCDocu.CodDoc
            B-CDOCU.NroRef = CcbCDocu.NroDoc
            B-CDOCU.FchCan = CcbCDocu.FchDoc
            B-CDOCU.SdoAct = 0.
    END.
    RELEASE B-CDOCU.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Pedidos V-table-Win 
PROCEDURE Actualiza-Pedidos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF s-asigna-pedido = 'NO' THEN RETURN.

DO ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
   FIND FacCPedi WHERE FacCPedi.CodCia = CcbCDocu.CodCia 
       AND FacCPedi.CodDoc = CcbCDocu.CodPed 
       AND FacCPedi.NroPed = CcbCDocu.NroPed EXCLUSIVE-LOCK NO-ERROR.
   IF AVAILABLE FacCPedi THEN DO:
       FOR EACH FacDPedi OF FacCPedi :
        IF FacDPedi.CanPed - FacDPedi.CanAte > 0 THEN RETURN .
       END.
       ASSIGN FacCPedi.FlgEst = "F".
       RELEASE FacCPedi.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Guias V-table-Win 
PROCEDURE Asigna-Guias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR conta AS INTEGER INIT 0. 

DO WITH FRAME {&FRAME-NAME}:
    IF CcbCDocu.CodCli:SCREEN-VALUE = "" THEN DO:
       MESSAGE "Debe registrar al cliente" VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO Ccbcdocu.CodCli.
       RETURN "ADM-ERROR".
    END.
    IF s-asigna-pedido = 'YES' THEN DO:
       MESSAGE "Ya se le asignó un pedido" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    IF s-asigna-guia = 'YES' THEN DO:
       MESSAGE "Solo puede asignar una vez" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    RUN Actualiza-Deta.
    ASSIGN
        input-var-1 = CcbCDocu.CodCli:SCREEN-VALUE
        C-NROGUI = ""
        output-var-2 = "".
    RUN lkup/c-guias ("Guias Pendientes x Facturar").
    IF output-var-1 = ? THEN RETURN 'ADM-ERROR'.
    /* SOLO ES UNA GUIA A LA VEZ */
    ASSIGN
        C-NROGUI = output-var-2
        D-FCHVTO = ?
        C-NRODOC = output-var-2.
    FIND B-CDOCU WHERE B-CDOCU.CodCia = S-CODCIA
        AND  B-CDOCU.CodDoc = "G/R" 
        AND  B-CDOCU.NroDoc = C-NroDoc 
        NO-LOCK NO-ERROR.
    ASSIGN
        c-NroPed = B-CDOCU.NroPed       /* PED */
        I-CODMON = B-CDOCU.CodMon
        C-CODVEN = B-CDOCU.CodVen
        CcbCDocu.CodCli:SCREEN-VALUE = B-CDOCU.codcli
        CcbCDocu.nomCli:SCREEN-VALUE = B-CDOCU.nomcli
        CcbCDocu.dirCli:SCREEN-VALUE = B-CDOCU.dircli
        CcbCDocu.ruc:SCREEN-VALUE = B-CDOCU.ruc
        CcbCDocu.glosa:SCREEN-VALUE = B-CDOCU.glosa
        CcbCDocu.nroped:SCREEN-VALUE = C-NROPED
        CcbCDocu.nroref:SCREEN-VALUE = B-CDOCU.nrodoc.
    IF D-FCHVTO = ? THEN D-FCHVTO = B-CDOCU.FchVto.
    D-FCHVTO = MAXIMUM( D-FCHVTO , B-CDOCU.FchVto ).
    /* asigna los articulos a la factura */
    FOR EACH CcbDDocu OF B-CDOCU NO-LOCK,
        FIRST Almmmate NO-LOCK WHERE Almmmate.codcia = s-codcia
            AND Almmmate.codmat = Ccbddocu.codmat
            AND Almmmate.codalm = B-CDOCU.codalm,
        FIRST Almmmatg OF Ccbddocu NO-LOCK 
        BREAK BY Almmmate.CodUbi BY CcbDDocu.CodMat:
        conta = conta + 1.
        CREATE DETA.
        BUFFER-COPY CcbDDocu TO DETA
            ASSIGN 
                DETA.NroItm = conta.
        /***********Grabando Costos **********************/
        IF almmmatg.monvta = 1 THEN DO:
            x-cto1 = ROUND( Almmmatg.Ctotot * DETA.CanDes , 2 ).
            x-cto2 = ROUND(( Almmmatg.Ctotot * DETA.CanDes ) /  Almmmatg.Tpocmb , 2 ).
        END.
        IF almmmatg.monvta = 2 THEN DO:
            x-cto1 = ROUND( Almmmatg.Ctotot * DETA.CanDes * Almmmatg.TpoCmb, 2 ).
            x-cto2 = ROUND(( Almmmatg.Ctotot * DETA.CanDes  ) , 2 ).
        END.
        DETA.ImpCto = IF I-CODMON = 1 THEN x-cto1 ELSE x-cto2.
       /*************************************************/
    END. 
    ASSIGN
        F-NomVen = ""
        F-CndVta = "".
    DISPLAY 
        B-CDOCU.NroOrd @ CcbCDocu.NroOrd
        B-CDOCU.FmaPgo @ CcbCDocu.FmaPgo.
    FIND gn-convt WHERE gn-convt.Codig = B-CDOCU.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN F-CndVta = gn-convt.Nombr.
    FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
        AND  gn-ven.CodVen = C-CODVEN 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
    ASSIGN
        CcbCDocu.CodCli:SENSITIVE = NO
        CcbCDocu.CodMon:SCREEN-VALUE = STRING(I-CodMon).
    DISPLAY 
        C-NROPED @ CcbCDocu.NroPed
        C-CODVEN @ CcbCDocu.CodVen
        D-FCHVTO @ CcbCDocu.FchVto 
        F-NomVen F-CndVta.
END.
RUN Procesa-Handle IN lh_Handle ('Browse').
s-asigna-guia = 'YES'.        /* <<< OJO <<< */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Pedidos V-table-Win 
PROCEDURE Asigna-Pedidos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    IF CcbCDocu.CodCli:SCREEN-VALUE = "" THEN DO:
       MESSAGE "Debe registrar al cliente" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    IF s-asigna-pedido = 'YES' THEN DO:
       MESSAGE "Solo puede asignar una vez" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    IF s-asigna-guia = 'YES' THEN DO:
       MESSAGE "Ya se le asignó una guia" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    RUN Actualiza-Deta.
    ASSIGN
        input-var-1 = "PED"
        input-var-2 = CcbCDocu.CodCli:SCREEN-VALUE.
    RUN lkup\C-Pedido.r("Pedidos Pendientes").
    IF output-var-1 = ? THEN RETURN 'ADM-ERROR'.

    ASSIGN
        C-NROGUI = ""
        C-CodPed = SUBSTRING(output-var-2,1,3)
        C-NroPed = SUBSTRING( output-var-2 ,4,9).
    FIND FacCPedi WHERE FacCPedi.CodCia = S-CODCIA 
        AND FacCPedi.CodDiv = S-CodDiv 
        AND FacCPedi.CodDoc = C-CodPed /*"PED"*/ 
        AND FacCPedi.NroPed = C-NroPed /*output-var-2*/ 
        NO-LOCK NO-ERROR.
    ASSIGN
        I-CODMON = FacCPedi.CodMon
        C-CODVEN = FacCPedi.CodVen
        CcbCDocu.CodCli:SCREEN-VALUE = FaccPedi.codcli
        CcbCDocu.nomCli:SCREEN-VALUE = FaccPedi.nomcli
        CcbCDocu.dirCli:SCREEN-VALUE = FaccPedi.dircli
        CcbCDocu.ruc:SCREEN-VALUE = FaccPedi.ruc
        CcbCDocu.glosa:SCREEN-VALUE = FaccPedi.glosa
        CcbCDocu.nroped:SCREEN-VALUE = FaccPedi.nroped.
    FOR EACH FacDPedi NO-LOCK WHERE FacDPedi.CodCia = FacCPedi.CodCia 
        AND FacDPedi.CodDoc = FacCPedi.CodDoc 
        AND FacDPedi.NroPed = FacCPedi.NroPed:
        CREATE DETA.
        BUFFER-COPY FacDPedi TO DETA
            ASSIGN
                DETA.CanDes = FacDPedi.CanPed.
        /***********Grabando Costos **********************/
        FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
            AND  Almmmatg.codmat = DETA.codmat 
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmatg THEN DO: 
            /***********Grabando Costos **********************/
            IF almmmatg.monvta = 1 then do:
                x-cto1 = ROUND( Almmmatg.Ctotot * DETA.CanDes , 2 ).
                x-cto2 = ROUND(( Almmmatg.Ctotot * DETA.CanDes ) /  Almmmatg.Tpocmb , 2 ).
            END.
            IF almmmatg.monvta = 2 then do:
                x-cto1 = ROUND( Almmmatg.Ctotot * DETA.CanDes * Almmmatg.TpoCmb, 2 ).
                x-cto2 = ROUND(( Almmmatg.Ctotot * DETA.CanDes  ) , 2 ).
            end.
            DETA.ImpCto = IF I-CODMON = 1 THEN x-cto1 ELSE x-cto2.
            /*************************************************/
        END.
    END.
    ASSIGN
        F-NomVen = ""
        F-CndVta = "".
    FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
        AND  gn-ven.CodVen = FaccPedi.CodVen NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
    FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN 
        ASSIGN 
            F-CndVta = gn-convt.Nombr
            D-FchVto = TODAY + INTEGER(ENTRY(NUM-ENTRIES(gn-ConVt.Vencmtos),gn-ConVt.Vencmtos)).
    DISPLAY 
        C-NroPed @ CcbCDocu.NroPed
        D-FCHVTO @ CcbCDocu.FchVto
        FacCPedi.ordcmp @ CcbCDocu.NroOrd
        FacCPedi.FmaPgo @ CcbCDocu.FmaPgo
        FaccPedi.CodVen @ CcbCDocu.CodVen
        F-NomVen F-CndVta.
    ASSIGN
        CcbCDocu.CodCli:SENSITIVE = NO
        CcbCDocu.CodMon:SCREEN-VALUE = STRING(I-CodMon).
END.
RUN Procesa-Handle IN lh_Handle ('Browse').
s-asigna-pedido = 'YES'.        /* <<< OJO <<< */

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
  
  /* RHC 10.12.2010 Ahora solo se actualiza el campo ImpTot2 */
  FIND FIRST F-CDOCU USE-INDEX Llave06 WHERE F-CDOCU.codcia = CcbCDocu.codcia
      AND F-CDOCU.codcli = CcbCDocu.codcli
      AND F-CDOCU.flgest = 'C'
      AND LOOKUP (F-CDOCU.coddoc, 'FAC,BOL') > 0
      AND F-CDOCU.tpofac = 'A'
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

  /* Guardamos el monto aplicado a la Factura */
  ASSIGN
      Ccbcdocu.ImpTot2 = x-Monto-Aplicar.

  /* Control de descarga de facturas adelantadas */
  CREATE Ccbdcaja.
  ASSIGN
      CcbDCaja.CodCia = s-codcia
      CcbDCaja.CodCli = Ccbcdocu.codcli
      CcbDCaja.CodDiv = Ccbcdocu.coddiv
      CcbDCaja.CodDoc = F-CDOCU.CodDoc
      CcbDCaja.NroDoc = F-CDOCU.NroDoc
      CcbDCaja.CodMon = Ccbcdocu.codmon
      CcbDCaja.CodRef = Ccbcdocu.coddoc
      CcbDCaja.NroRef = Ccbcdocu.nrodoc
      CcbDCaja.FchDoc = TODAY
      CcbDCaja.ImpTot = x-Monto-Aplicar
      CcbDCaja.TpoCmb = (IF CcbCDocu.codmon = 1 THEN x-TpoCmb-Compra ELSE x-TpoCmb-Venta).

  /* Actualizamos saldo factura adelantada */
  IF F-CDOCU.CodMon = Ccbdcaja.codmon
  THEN F-CDOCU.ImpTot2 = F-CDOCU.ImpTot2 - Ccbdcaja.ImpTot.
  ELSE IF F-CDOCU.CodMon = 1
      THEN F-CDOCU.ImpTot2 = F-CDOCU.ImpTot2 - Ccbdcaja.ImpTot * Ccbdcaja.TpoCmb.
      ELSE F-CDOCU.ImpTot2 = F-CDOCU.ImpTot2 - Ccbdcaja.ImpTot / Ccbdcaja.TpoCmb.

  RELEASE F-CDOCU.
  RELEASE Ccbdcaja.

  /*
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND FIRST F-CDOCU USE-INDEX Llave06 WHERE F-CDOCU.codcia = CcbCDocu.codcia
          AND F-CDOCU.codcli = CcbCDocu.codcli
          AND F-CDOCU.flgest = 'C'
          AND LOOKUP (F-CDOCU.coddoc, 'FAC,BOL') > 0
          AND F-CDOCU.tpofac = 'A'
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
          CCBDMOV.NroRef = CcbCDocu.nrodoc
          CCBDMOV.FchDoc = CcbCDocu.fchdoc
          CCBDMOV.FchMov = TODAY
          CCBDMOV.HraMov = STRING(TIME,'HH:MM')
          CCBDMOV.ImpTot = x-Monto-Aplicar
          CCBDMOV.NroDoc = F-CDOCU.nrodoc
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
  */

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
    /* RHC 10.12.2010 Nuevo Control Factura Adelantada */
      FIND Ccbdcaja WHERE Ccbdcaja.codcia = Ccbcdocu.codcia
          AND LOOKUP (ccbdcaja.coddoc, 'FAC,BOL') > 0      /* FACTURA ADELANTADA */
          AND Ccbdcaja.codref = Ccbcdocu.coddoc
          AND Ccbdcaja.nroref = Ccbcdocu.nrodoc
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Ccbdcaja THEN RETURN.
      FIND FIRST F-CDOCU WHERE F-CDOCU.codcia = Ccbdcaja.codcia
          AND F-CDOCU.coddoc = Ccbdcaja.coddoc
          AND F-CDOCU.nrodoc = Ccbdcaja.nrodoc
          AND F-CDOCU.tpofac = 'A'    /* FACTURA ADELANTADA */
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE F-CDOCU THEN UNDO, RETURN 'ADM-ERROR'.
      /* Actualizamos saldo factura adelantada */
      IF F-CDOCU.CodMon = Ccbdcaja.codmon
      THEN F-CDOCU.ImpTot2 = F-CDOCU.ImpTot2 + Ccbdcaja.ImpTot.
      ELSE IF F-CDOCU.CodMon = 1
          THEN F-CDOCU.ImpTot2 = F-CDOCU.ImpTot2 + Ccbdcaja.ImpTot * Ccbdcaja.TpoCmb.
          ELSE F-CDOCU.ImpTot2 = F-CDOCU.ImpTot2 + Ccbdcaja.ImpTot / Ccbdcaja.TpoCmb.

      DELETE Ccbdcaja.
      RELEASE Ccbdcaja.
      RELEASE F-CDOCU.

/*     FIND Ccbdmov WHERE Ccbdmov.codcia = Ccbcdocu.codcia                           */
/*         AND LOOKUP (ccbdmov.coddoc, 'FAC,BOL') > 0      /* FACTURA ADELANTADA */  */
/*         AND Ccbdmov.codref = Ccbcdocu.coddoc                                      */
/*         AND Ccbdmov.nroref = Ccbcdocu.nrodoc                                      */
/*         EXCLUSIVE-LOCK NO-ERROR.                                                  */
/*     IF NOT AVAILABLE Ccbdmov THEN RETURN.                                         */
/*     FIND FIRST F-CDOCU WHERE F-CDOCU.codcia = Ccbdmov.codcia                      */
/*         AND F-CDOCU.coddoc = Ccbdmov.coddoc                                       */
/*         AND F-CDOCU.nrodoc = Ccbdmov.nrodoc                                       */
/*         AND F-CDOCU.tpofac = 'A'    /* FACTURA ADELANTADA */                      */
/*         EXCLUSIVE-LOCK NO-ERROR.                                                  */
/*     IF NOT AVAILABLE F-CDOCU THEN UNDO, RETURN 'ADM-ERROR'.                       */
/*     /* Actualizamos saldo factura adelantada */                                   */
/*     IF F-CDOCU.CodMon = Ccbdmov.codmon                                            */
/*     THEN F-CDOCU.ImpTot2 = F-CDOCU.ImpTot2 + Ccbdmov.ImpTot.                      */
/*     ELSE IF F-CDOCU.CodMon = 1                                                    */
/*         THEN F-CDOCU.ImpTot2 = F-CDOCU.ImpTot2 + Ccbdmov.ImpTot * Ccbdmov.TpoCmb. */
/*         ELSE F-CDOCU.ImpTot2 = F-CDOCU.ImpTot2 + Ccbdmov.ImpTot / Ccbdmov.TpoCmb. */
/*                                                                                   */
/*     DELETE Ccbdmov.                                                               */
/*     RELEASE Ccbdmov.                                                              */
/*     RELEASE F-CDOCU.                                                              */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle V-table-Win 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
   RUN Borra-Detalle. 
   FOR EACH DETA WHERE DETA.CanDes > 0 BY DETA.NroItm:
       CREATE CcbDDocu.
       BUFFER-COPY DETA TO CcbDDocu
           ASSIGN 
                CcbDDocu.CodCia = CcbCDocu.CodCia 
                CcbDDocu.NroItm = DETA.NroItm
                CcbDDocu.CodDoc = CcbCDocu.CodDoc 
                CcbDDocu.NroDoc = CcbCDocu.NroDoc
                CcbDDocu.FchDoc = TODAY
                CcbDDocu.CodDiv = CcbCDocu.CodDiv
                CcbDDOcu.CanDev = 0.                /* Control de Devoluciones */
   END.
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

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':

    {vta/graba-totales-fac.i}

    /* RHC 30-11-2006 Transferencia Gratuita */
    IF Ccbcdocu.FmaPgo = '900' THEN Ccbcdocu.sdoact = 0.
    IF Ccbcdocu.sdoact <= 0 
    THEN ASSIGN
            Ccbcdocu.fchcan = TODAY
            Ccbcdocu.flgest = 'C'.
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
  {adm/i-DocPssw.i s-CodCia s-CodDoc ""ADD""}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Numero-de-Documento(NO).
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY @ CcbCDocu.FchDoc
             TODAY @ CcbCDocu.FchVto
             FacCfgGn.CliVar @ CcbCDocu.CodCli
             FacCfgGn.Tpocmb[1] @ CcbCDocu.TpoCmb
             STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999") @ CcbCDocu.NroDoc.
     ASSIGN
         CcbCDocu.CodVen:SENSITIVE = NO
         CcbCDocu.FmaPgo:SENSITIVE = NO
         CcbCDocu.NroOrd:SENSITIVE = NO
         CcbCDocu.DirCli:SENSITIVE = NO
         CcbCDocu.NomCli:SENSITIVE = NO
         CcbCDocu.RucCli:SENSITIVE = NO.
  END.
  RUN Actualiza-Deta.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('Browse').
  ASSIGN
      s-FechaI = DATETIME(TODAY, MTIME)
      s-asigna-pedido = 'NO'
      s-asigna-guia = 'NO'.

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
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
       FacCorre.CodDoc = S-CODDOC AND
       FacCorre.CodDiv = S-CODDIV AND
       FacCorre.NroSer = S-NROSER EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccorre THEN UNDO, RETURN 'ADM-ERROR'.
  ASSIGN 
      I-NroSer = FacCorre.NroSer
      I-NroDoc = FacCorre.Correlativo
      FacCorre.Correlativo = FacCorre.Correlativo + 1.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF s-asigna-guia = 'YES' THEN DO:
      /* Buscamos la Guia de Remision */
      FIND B-CDOCU WHERE B-CDOCU.codcia = s-codcia
          AND B-CDOCU.coddoc = 'G/R'
          AND B-CDOCU.nrodoc = c-NroGui
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE B-CDOCU THEN UNDO, RETURN 'ADM-ERROR'.
      /* Buscamos el pedido */
      FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
          AND Faccpedi.coddoc = B-CDOCU.codped
          AND Faccpedi.nroped = B-CDOCU.nroped
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Faccpedi THEN UNDO, RETURN 'ADM-ERROR'.
      BUFFER-COPY B-CDOCU 
          TO CcbCDocu
          ASSIGN 
              CcbCDocu.CodCia = S-CODCIA
              CcbCDocu.CodDoc = S-CODDOC
              CcbCDocu.CodMov = S-CODMOV 
              CcbCDocu.CodDiv = Faccpedi.CODDIV
              CcbCDocu.NroDoc = STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999")
              CcbCDocu.CodRef = B-CDOCU.CodDoc
              CcbCDocu.NroRef = B-CDOCU.NroDoc.
  END.
  IF s-asigna-pedido = 'YES' THEN DO:
      /* Buscamos el pedido */
      FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
          AND Faccpedi.coddoc = 'PED'
          AND Faccpedi.nroped = c-NroPed
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Faccpedi THEN UNDO, RETURN 'ADM-ERROR'.
      BUFFER-COPY Faccpedi 
          EXCEPT Faccpedi.NroRef        /* SIN Referencia a las guias */
          TO CcbCDocu
          ASSIGN
              CcbCDocu.CodCia = S-CODCIA
              CcbCDocu.CodDoc = S-CODDOC
              CcbCDocu.CodMov = S-CODMOV 
              CcbCDocu.CodDiv = Faccpedi.CODDIV
              CcbCDocu.NroDoc = STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999")
              CcbCDocu.CodRef = ''
              CcbCDocu.CodPed = Faccpedi.CodDoc
              CcbCDocu.NroPed = Faccpedi.NroPed
              CcbCDocu.TipBon[1] = Faccpedi.TipBon[1].
  END.
  ASSIGN 
      CcbCDocu.FchDoc = TODAY
      CcbCDocu.FchVto = D-FCHVTO
      CcbCDocu.FchAte = TODAY
      CcbCDocu.FlgEst = "P"
      CcbCDocu.FlgAte = "P"
      CcbCDocu.Tipo   = "OFICINA"
      CcbCDocu.TipVta = "2"
      CcbCDocu.TpoFac = "R"
      CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
      CcbCDocu.FlgAte = 'D'
      CcbCDocu.usuario = S-USER-ID
      CcbCDocu.HorCie = STRING(TIME, 'HH:MM')
      CcbCDocu.Libre_c01 = s-asigna-guia
      CcbCDocu.Libre_c02 = s-asigna-pedido
      CcbCDocu.ImpTot2 = 0.       /* OJO >> Control de Aplicación de Fact. Adelantadas */

  FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
      AND gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie  THEN DO:
      ASSIGN 
          CcbCDocu.CodDpto = gn-clie.CodDept 
          CcbCDocu.CodProv = gn-clie.CodProv 
          CcbCDocu.CodDist = gn-clie.CodDist.
  END.
  /* ACTUALIZAR EL CENTRO DE COSTO 22.07.04 CY */
  FIND GN-VEN WHERE gn-ven.codcia = s-codcia
      AND gn-ven.codven = ccbcdocu.codven
      NO-LOCK NO-ERROR.
  IF AVAILABLE GN-VEN THEN ccbcdocu.cco = gn-ven.cco.

  /* TRACKING FACTURAS */
  IF s-asigna-guia = 'YES' THEN DO:
      FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
          AND Faccpedi.coddoc = Ccbcdocu.codped
          AND Faccpedi.nroped = Ccbcdocu.nroped
          NO-LOCK NO-ERROR.
      RUN vtagn/pTracking-04 (s-CodCia,
                           s-CodDiv,
                       Ccbcdocu.CodPed,
                       Ccbcdocu.NroPed,
                       s-User-Id,
                       'EFAC',
                       'P',
                       DATETIME(TODAY, MTIME),
                       DATETIME(TODAY, MTIME),
                       Ccbcdocu.coddoc,
                       Ccbcdocu.nrodoc,
                       Ccbcdocu.codref,
                       Ccbcdocu.nroref).
      FIND Almacen OF Ccbcdocu NO-LOCK.
      s-FechaT = DATETIME(TODAY, MTIME).
/*       RUN gn/pTracking-01 (s-CodCia,                               */
/*                         Almacen.CodDiv,                            */
/*                         Faccpedi.CodDoc,                           */
/*                         Faccpedi.NroPed,                           */
/*                         s-User-Id,                                 */
/*                         'EFAC',                                    */
/*                         'P',                                       */
/*                         s-FechaI,                                  */
/*                         s-FechaT,                                  */
/*                         Ccbcdocu.coddoc,                           */
/*                         Ccbcdocu.nrodoc,                           */
/*                         Ccbcdocu.codref,                           */
/*                         Ccbcdocu.nroref).                          */
/*       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
  END.

  RUN Genera-Detalle.    /* Detalle de la Factura/Boleta */ 
  RUN Graba-Totales.
  RUN Actualiza-Guias.
  RUN Actualiza-Pedidos.
  
  /* RHC 10.12.2010 APLICACION DE FACTURAS ADELANTADAS */
  IF s-aplic-fact-ade = YES THEN DO:
      RUN vtagn/p-aplica-factura-adelantada ( ROWID(Ccbcdocu) ).
      RUN Graba-Totales. 
  END.

  RELEASE FacCorre.
  
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
  IF CcbCDocu.FlgEst = "A" THEN DO:
     MESSAGE 'El documento se encuentra Anulado...' VIEW-AS ALERT-BOX.
     RETURN 'ADM-ERROR'.
  END.
  /* RHC 19.09.05 NO anular si ya salio por vigilancia */
  FIND AlmDCDoc WHERE Almdcdoc.codcia = ccbcdocu.codcia
    AND Almdcdoc.coddoc = ccbcdocu.coddoc
    AND Almdcdoc.nrodoc = ccbcdocu.nrodoc
    AND Almdcdoc.flgest = 'S'
    NO-LOCK NO-ERROR.
  IF AVAILABLE Almdcdoc
  THEN DO:
    MESSAGE "La" ccbcdocu.coddoc ccbcdocu.nrodoc "ya salió por Vigilancia"  SKIP
            "Imposible anular el documento" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.
  /* ************************************************* */
  /* consistencia de la fecha del cierre del sistema */
  DEF VAR dFchCie AS DATE.
  RUN gn/fecha-de-cierre (OUTPUT dFchCie).
  IF ccbcdocu.fchdoc <= dFchCie THEN DO:
      MESSAGE 'NO se puede anular ningun documento antes del' (dFchCie + 1)
          VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  /* fin de consistencia */
  /* CONSISTENCIA DE AMORTIZACIONES AL DOCUMENTO */
  DEF VAR x-Adelantos AS DEC NO-UNDO.
  /* por aplicación de facturas adelantadas campaña */
  FOR EACH Ccbdcaja NO-LOCK WHERE Ccbdcaja.codcia = s-codcia
      AND LOOKUP(Ccbdcaja.coddoc, 'FAC,BOL') > 0
      AND Ccbdcaja.codref = Ccbcdocu.coddoc
      AND Ccbdcaja.nroref = CCbcdocu.nrodoc:
      x-Adelantos = x-Adelantos + CcbDCaja.ImpTot.
  END.
  IF Ccbcdocu.FmaPgo <> "900" THEN DO:          /* NO TRANSFERENCIA GRATUITA */
      IF Ccbcdocu.SdoAct <> (Ccbcdocu.ImpTot - x-Adelantos) THEN DO:
          MESSAGE 'El documento registra amortizaciones...' VIEW-AS ALERT-BOX.
          RETURN 'ADM-ERROR'.
      END.
  END.

  IF MONTH(Ccbcdocu.FchDoc) <> MONTH(TODAY) OR YEAR(Ccbcdocu.FchDoc) <> YEAR(TODAY) THEN DO:
    {adm/i-DocPssw.i s-CodCia s-CodDoc ""DEL""}
  END.
  
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
      DEF VAR cReturnValue AS CHAR NO-UNDO.
      RUN ccb/d-motanu (ccbcdocu.codcia, ccbcdocu.coddoc, ccbcdocu.nrodoc, s-user-id, OUTPUT cReturnValue).
      IF cReturnValue = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      ASSIGN
          s-asigna-guia = CcbCDocu.Libre_c01
          s-asigna-pedido = CcbCDocu.Libre_c02.
      /* TRACKING FACTURAS */
      IF s-asigna-guia = 'YES' THEN DO:
          FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
              AND Faccpedi.coddoc = Ccbcdocu.codped     /* PED */
              AND Faccpedi.nroped = Ccbcdocu.nroped
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Faccpedi THEN UNDO, RETURN 'ADM-ERROR'.
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
          FIND Almacen OF Ccbcdocu NO-LOCK.
/*           RUN gn/pTracking-01 (s-CodCia,                               */
/*                             Almacen.CodDiv,                            */
/*                             Faccpedi.CodDoc,                           */
/*                             Faccpedi.NroPed,                           */
/*                             s-User-Id,                                 */
/*                             'EFAC',                                    */
/*                             'A',                                       */
/*                             DATETIME(TODAY, MTIME),                    */
/*                             DATETIME(TODAY, MTIME),                    */
/*                             Ccbcdocu.coddoc,                           */
/*                             Ccbcdocu.nrodoc,                           */
/*                             Ccbcdocu.codref,                           */
/*                             Ccbcdocu.nroref).                          */
/*           IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
      END.

      /* Eliminamos el detalle */
      RUN Borra-Detalle.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
     
      /* RHC 10.12.2010 ACTUALIZAMOS FACTURA ADELANTADA */
      RUN vtagn/p-extorna-factura-adelantada ( ROWID(Ccbcdocu) ).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      IF s-asigna-guia = 'YES' THEN DO:
          FOR EACH B-CDOCU WHERE B-CDOCU.CodCia = S-CODCIA 
              AND B-CDOCU.CodDoc = "G/R"    
              AND B-CDOCU.FlgEst = "F"      
              AND B-CDOCU.CodRef = CcbCDocu.CodDoc 
              AND B-CDOCU.NroRef = CcbCDocu.NroDoc:
              ASSIGN 
                 B-CDOCU.FlgEst = "P"
                 B-CDOCU.SdoAct = B-CDOCU.ImpTot.
          END.   
          RELEASE B-CDOCU.
      END.

      IF s-asigna-pedido = 'YES' THEN DO:
         FIND FacCPedi WHERE FacCPedi.CodCia = CcbCDocu.CodCia 
             AND FacCPedi.CodDoc = CcbCDocu.CodPed 
             AND FacCPedi.NroPed = CcbCDocu.NroPed EXCLUSIVE-LOCK NO-ERROR.
         IF AVAILABLE FacCPedi THEN DO:
             ASSIGN FacCPedi.FlgEst = "P".
             FOR EACH FacDPedi OF FacCPedi :
                 Facdpedi.flgest = Faccpedi.flgest.
             END.
             RELEASE FacCPedi.
         END.
      END.

      FIND B-CDOCU WHERE ROWID(B-CDOCU) = ROWID(CcbCDocu) EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABL B-CDOCU THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN 
          B-CDOCU.FlgEst = "A"
          B-CDOCU.SdoAct = 0
          B-CDOCU.UsuAnu = S-USER-ID
          B-CDOCU.FchAnu = TODAY
          B-CDOCU.Glosa  = "A N U L A D O".
     RELEASE B-CDOCU.
  END.
  
  RUN Procesa-Handle IN lh_Handle ('Browse').
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
  
  IF AVAILABLE CcbCDocu THEN DO WITH FRAME {&FRAME-NAME}:
     
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
  IF S-CODDOC = "FAC" THEN DO:
    IF ccbcdocu.codcli = '20337564373' AND YEAR(ccbcdocu.fchdoc) = 2007
    THEN RUN vta/r-facripley (ROWID(CcbCDocu)).
    ELSE DO:
        RUN VTA\R-IMPFAC2 (ROWID(CcbCDocu)).
    END.
  END.    
  
  IF S-CODDOC = "BOL" THEN DO:
     RUN VTA\R-IMPBOL2 (ROWID(CcbCDocu)).
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
  DEF VAR x-Moneda AS CHAR FORMAT 'x(3)'.  
  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  /* Control de Facturas Adelantadas */
  DEFINE VARIABLE x-saldo-mn AS DEC NO-UNDO.
  DEFINE VARIABLE x-saldo-me AS DEC NO-UNDO.
  ASSIGN
      s-aplic-fact-ade = NO
      x-saldo-mn = 0
      x-saldo-me = 0.
  FOR EACH F-CDOCU USE-INDEX Llave06 NO-LOCK WHERE F-CDOCU.codcia = s-codcia
      AND F-CDOCU.codcli = CcbCDocu.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME}
      AND F-CDOCU.flgest = 'C'
      AND LOOKUP (F-CDOCU.coddoc, 'FAC,BOL') > 0
      AND F-CDOCU.tpofac = 'A'
      AND F-CDOCU.imptot2 > 0:
      IF F-CDOCU.CodMon = 1 THEN x-saldo-mn = x-saldo-mn + F-CDOCU.ImpTot2.
      ELSE x-saldo-me = x-saldo-me + F-CDOCU.ImpTot2.
  END.
  FOR EACH F-CDOCU USE-INDEX Llave06 NO-LOCK WHERE F-CDOCU.codcia = s-codcia
      AND F-CDOCU.codcli = CcbCDocu.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME}
      AND F-CDOCU.flgest = 'P'
      AND F-CDOCU.coddoc = "A/C":
      IF F-CDOCU.CodMon = 1 THEN x-saldo-mn = x-saldo-mn + F-CDOCU.SdoAct.
      ELSE x-saldo-me = x-saldo-me + F-CDOCU.SdoAct.
  END.
  IF x-saldo-mn > 0 OR x-saldo-me > 0 THEN DO:
      MESSAGE 'Hay un SALDO de Factura(s) Adelantada(s) por aplicar' SKIP
          'Por aplicar NUEVOS SOLES:' x-saldo-mn SKIP
          'Por aplicar DOLARES:' x-saldo-me SKIP
          'APLICAMOS el(los) Adelanto(s)?' VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO-CANCEL
          UPDATE s-aplic-fact-ade.
      IF s-aplic-fact-ade = ? THEN RETURN 'ADM-ERROR'.
  END.

/*   s-aplic-fact-ade = NO.                                                               */
/*   FIND FIRST F-CDOCU USE-INDEX Llave06 WHERE F-CDOCU.codcia = s-codcia                 */
/*       AND F-CDOCU.codcli = CcbCDocu.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME}         */
/*       AND F-CDOCU.flgest = 'C'                                                         */
/*       AND LOOKUP (F-CDOCU.coddoc, 'FAC,BOL') > 0                                       */
/*       AND F-CDOCU.tpofac = 'A'                                                         */
/*       AND F-CDOCU.imptot2 > 0                                                          */
/*       NO-LOCK NO-ERROR.                                                                */
/*   IF AVAILABLE F-CDOCU THEN DO:                                                        */
/*       FIND FIRST F-DDOCU OF F-CDOCU NO-LOCK NO-ERROR.                                  */
/*       IF AVAILABLE F-DDOCU THEN DO:                                                    */
/*           x-Moneda = (IF F-CDOCU.CodMon = 1 THEN 'S/.' ELSE 'US$').                    */
/*           MESSAGE 'Hay un SALDO de Factura Adelantada por aplicar' SKIP                */
/*               F-CDOCU.coddoc F-CDOCU.nrodoc x-Moneda F-CDOCU.ImpTot2 SKIP              */
/*               'APLICAMOS el Adelanto?' VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO-CANCEL */
/*               UPDATE s-aplic-fact-ade.                                                 */
/*           IF s-aplic-fact-ade = ? THEN RETURN 'ADM-ERROR'.                             */
/*       END.                                                                             */
/*   END.                                                                                 */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  MESSAGE "Imprimir Documentos"  SKIP(1)
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      TITLE "" UPDATE choice AS LOGICAL.
  IF choice THEN RUN dispatch IN THIS-PROCEDURE ('imprime':U).
  
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
          FacCorre.CodDiv = S-CODDIV AND
          FacCorre.NroSer = S-NROSER EXCLUSIVE-LOCK NO-ERROR.
  ELSE
     FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = S-CODDOC AND
          FacCorre.CodDiv = S-CODDIV AND
          FacCorre.NroSer = S-NROSER NO-LOCK NO-ERROR.
  
  IF AVAILABLE FacCorre THEN DO:
     ASSIGN I-NroDoc = FacCorre.Correlativo.
     IF L-INCREMENTA THEN ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
     I-NroSer = FacCorre.NroSer.
     S-CodAlm = FacCorre.CodAlm.
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
   IF CcbCDocu.CodCli:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO CcbCDocu.CodCli.
      RETURN "ADM-ERROR".   
   END.
   FOR EACH DETA:
       X-ITMS = X-ITMS + DETA.CanDes.
   END.
   IF X-ITMS = 0 THEN DO:
      MESSAGE "No existen items a generar" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO CcbCDocu.Glosa.
      RETURN "ADM-ERROR".   
   END.
/*    IF s-asigna-guia = 'YES' THEN DO:                                   */
/*        /* rhc 18.12.09 Buscar guias por chequear */                    */
/*        FIND FIRST F-CDOCU WHERE F-CDOCU.codcia = s-codcia              */
/*            AND F-CDOCU.coddoc = 'G/R'                                  */
/*            AND F-CDOCU.codcli = Ccbcdocu.CodCli:SCREEN-VALUE           */
/*            AND F-CDOCU.flgest = 'X'                                    */
/*            AND F-CDOCU.nroped = Ccbcdocu.NroPed:SCREEN-VALUE           */
/*            NO-LOCK NO-ERROR.                                           */
/*        IF AVAILABLE F-CDOCU THEN DO:                                   */
/*            MESSAGE 'Falta chequear la Guia de Remision' F-CDOCU.NroDoc */
/*                VIEW-AS ALERT-BOX ERROR.                                */
/*            RETURN 'ADM-ERROR'.                                         */
/*        END.                                                            */
/*        /* 11.01.10 buscamos si la O/D aun no se ha cerrado */          */
/*        FIND FIRST B-CPEDI WHERE B-CPEDI.codcia = s-codcia              */
/*            AND B-CPEDI.coddoc = 'O/D'                                  */
/*            AND B-CPEDI.codcli = Ccbcdocu.CodCli:SCREEN-VALUE           */
/*            AND B-CPEDI.flgest = 'P'                                    */
/*            AND B-CPEDI.nroref = Ccbcdocu.NroPed:SCREEN-VALUE           */
/*            NO-LOCK NO-ERROR.                                           */
/*        IF AVAILABLE B-CPEDI THEN DO:                                   */
/*            MESSAGE 'Falta cerrar la Orden de Despacho' B-CPEDI.NroPed  */
/*                VIEW-AS ALERT-BOX ERROR.                                */
/*            RETURN 'ADM-ERROR'.                                         */
/*        END.                                                            */
/*    END.                                                                */
END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida-Asigna-Guias V-table-Win 
PROCEDURE Valida-Asigna-Guias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER pGuias AS CHAR.
  
  DEF VAR i AS INT NO-UNDO.
  DEF VAR cNroDoc AS CHAR NO-UNDO.  /* Guia de Remision */
  DEF VAR cNroPed AS CHAR NO-UNDO.  /* Pedido(s) */
  
  /* Verificamos los Pedidos */
  FOR EACH T-DETA:
    DELETE T-DETA.
  END.
  DO i = 1 TO NUM-ENTRIES(pGuias):
    cNroDoc = ENTRY(i, pGuias).
    /* Verificamos si tiene mas de un pedido */
    FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
        AND Ccbcdocu.coddoc = 'G/R'
        AND Ccbcdocu.nrodoc = cNroDoc
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbcdocu THEN DO:
        FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
            CREATE T-DETA.
            BUFFER-COPY Ccbddocu TO T-DETA.
        END.
        /* Buscamos la O/D */
        FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
            AND Faccpedi.coddoc = Ccbcdocu.codped
            AND Faccpedi.nroped = Ccbcdocu.nroped
            NO-LOCK NO-ERROR.
        IF AVAILABLE Faccpedi THEN DO:
            /* Capturamos los pedidos */
            IF cNroPed = ''
            THEN cNroPed = Faccpedi.nroref.
            ELSE DO:
                IF LOOKUP(TRIM(Faccpedi.nroref), cNroPed) = 0 
                THEN cNroPed = cNroPed + ',' + Faccpedi.nroref.
            END.
        END.            
    END.
  END.
  IF NUM-ENTRIES(cNroPed) > 1 THEN DO:
        MESSAGE 'Las Guías de Remisión pertenecen a mas de un pedido:' SKIP
            cNroPed SKIP 'Continuamos?' VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
            UPDATE rpta-1 AS LOG.
        IF rpta-1 = NO THEN RETURN 'ADM-ERROR'.
  END.
  /* Verificamos los precios */
  DO i = 1 TO NUM-ENTRIES(pGuias):
    cNroDoc = ENTRY(i, pGuias).
    FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
        AND Ccbcdocu.coddoc = 'G/R'
        AND Ccbcdocu.nrodoc = cNroDoc
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcdocu THEN NEXT.
    FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
        FOR EACH T-DETA NO-LOCK WHERE T-DETA.CodMat = Ccbddocu.CodMat
                AND T-DETA.NroDoc <> Ccbddocu.NroDoc:
            IF T-DETA.PreUni <> Ccbddocu.PreUni THEN DO:
                MESSAGE 'Los precios unitarios no coinciden en el producto' Ccbddocu.codmat SKIP
                    'Entre las Guias de Remision' T-DETA.nrodoc 'y' Ccbddocu.nrodoc
                    VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
            END.
        END.
    END.
  END.
    
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
RETURN "ADM-ERROR".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

