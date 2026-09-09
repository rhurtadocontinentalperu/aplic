&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-ADocu FOR CcbADocu.
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER B-DDOCU FOR CcbDDocu.
DEFINE BUFFER GUIAS FOR CcbCDocu.



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
DEFINE SHARED VARIABLE CL-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE PV-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHAR.
DEFINE SHARED VARIABLE S-CODMOV   AS INTEGER.
DEFINE SHARED VARIABLE S-NROSER   AS INTEGER.
DEFINE SHARED VARIABLE S-TPOFAC   AS CHAR.

DEFINE NEW SHARED VARIABLE X-CTRANS  AS CHAR initial "100038146".
DEFINE NEW SHARED VARIABLE X-RTRANS  AS CHAR.
DEFINE NEW SHARED VARIABLE X-DTRANS  AS CHAR.
DEFINE NEW SHARED VARIABLE X-NUMORD  AS CHAR.
DEFINE NEW SHARED VARIABLE X-obser   AS CHAR.
DEF VAR X-Nombre LIKE gn-prov.NomPro.
DEF VAR X-ruc    LIKE gn-prov.Ruc.
DEF VAR X-TRANS  LIKE FACCPEDI.Libre_c01.


DEFINE SHARED TEMP-TABLE DETA LIKE CcbDDocu.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE C-CODPED       AS CHAR      NO-UNDO.
DEFINE VARIABLE C-NROPED       AS CHAR      NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NRODOC       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-ListPr       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE S-CODCLI       AS CHARACTER NO-UNDO. 
DEFINE VARIABLE S-CODVEN       AS CHARACTER NO-UNDO. 
DEFINE VARIABLE R-ROWID        AS ROWID     NO-UNDO. 
DEFINE VARIABLE x-codalm AS CHARACTER NO-UNDO.

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV AND
     FacCorre.NroSer = S-NROSER NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN I-NroSer = FacCorre.NroSer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).

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
&Scoped-Define ENABLED-FIELDS CcbCDocu.CodRef CcbCDocu.NroRef ~
CcbCDocu.CodPed CcbCDocu.NroPed CcbCDocu.Glosa 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.CodCli CcbCDocu.RucCli CcbCDocu.CodAnt CcbCDocu.CodRef ~
CcbCDocu.NroRef CcbCDocu.NomCli CcbCDocu.CodPed CcbCDocu.NroPed ~
CcbCDocu.DirCli CcbCDocu.LugEnt CcbCDocu.CodVen CcbCDocu.FmaPgo ~
CcbCDocu.Glosa 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS F-Estado f-NomVen F-CndVta 

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
     SIZE 53 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "ESTADO" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE f-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 53 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.NroDoc AT ROW 1 COL 17 COLON-ALIGNED FORMAT "XXX-XXXXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          FONT 1
     F-Estado AT ROW 1 COL 41 COLON-ALIGNED
     CcbCDocu.FchDoc AT ROW 1 COL 87 COLON-ALIGNED
          LABEL "Emisión"
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .81
     CcbCDocu.CodCli AT ROW 1.81 COL 17 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.RucCli AT ROW 1.81 COL 41 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     CcbCDocu.CodAnt AT ROW 1.81 COL 62 COLON-ALIGNED WIDGET-ID 2
          LABEL "DNI" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.CodRef AT ROW 1.81 COL 87 COLON-ALIGNED
          LABEL "Referencia"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     CcbCDocu.NroRef AT ROW 1.81 COL 94 NO-LABEL FORMAT "X(12)"
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
     CcbCDocu.NomCli AT ROW 2.62 COL 17 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 59 BY .81
     CcbCDocu.CodPed AT ROW 2.62 COL 87 COLON-ALIGNED
          LABEL "Pedido"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     CcbCDocu.NroPed AT ROW 2.62 COL 92 COLON-ALIGNED NO-LABEL FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
     CcbCDocu.DirCli AT ROW 3.42 COL 17 COLON-ALIGNED WIDGET-ID 6 FORMAT "x(80)"
          VIEW-AS FILL-IN 
          SIZE 75 BY .81
     CcbCDocu.LugEnt AT ROW 4.27 COL 17 COLON-ALIGNED WIDGET-ID 12 FORMAT "x(80)"
          VIEW-AS FILL-IN 
          SIZE 75 BY .81
     CcbCDocu.CodVen AT ROW 5.04 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     f-NomVen AT ROW 5.04 COL 23 COLON-ALIGNED NO-LABEL
     CcbCDocu.FmaPgo AT ROW 5.85 COL 17 COLON-ALIGNED
          LABEL "Condición de Venta"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     F-CndVta AT ROW 5.85 COL 23 COLON-ALIGNED NO-LABEL
     CcbCDocu.Glosa AT ROW 6.65 COL 17 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 59 BY .81
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
      TABLE: B-ADocu B "?" ? INTEGRAL CcbADocu
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: B-DDOCU B "?" ? INTEGRAL CcbDDocu
      TABLE: GUIAS B "?" ? INTEGRAL CcbCDocu
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
         HEIGHT             = 8.62
         WIDTH              = 119.86.
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

/* SETTINGS FOR FILL-IN CcbCDocu.CodAnt IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.CodCli IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.CodPed IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.CodRef IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.CodVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.DirCli IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.FmaPgo IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.LugEnt IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NroPed IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NroRef IN FRAME F-Main
   ALIGN-L EXP-FORMAT                                                   */
/* SETTINGS FOR FILL-IN CcbCDocu.RucCli IN FRAME F-Main
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
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE DETA.
IF NOT L-CREA THEN DO:
   FOR EACH CcbDDocu NO-LOCK WHERE 
            CcbDDocu.CodCia = CcbCDocu.CodCia AND  
            CcbDDocu.coddoc = CcbCDocu.coddoc AND
            CcbDDocu.NroDoc = CcbCDocu.NroDoc :
       CREATE DETA.
       BUFFER-COPY Ccbddocu TO DETA.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-datos V-table-Win 
PROCEDURE Asigna-datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT AVAILABLE Ccbcdocu 
        OR Ccbcdocu.flgest = 'A'
        THEN RETURN 'ADM-ERROR'.
    RUN vta/w-agtrans-02 (Ccbcdocu.codcia, Ccbcdocu.coddiv, Ccbcdocu.coddoc, Ccbcdocu.nrodoc).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Guia V-table-Win 
PROCEDURE Borra-Guia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH CcbDDocu EXCLUSIVE-LOCK WHERE 
           CcbDDocu.CodCia = CcbCDocu.CodCia AND  
           CcbDDocu.CodDoc = CcbCDocu.CodDoc AND  
           CcbDDocu.Nrodoc = CcbCDocu.NroDoc
           ON ERROR UNDO, RETURN "ADM-ERROR":
      DELETE CcbDDocu.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierra-Pedido V-table-Win 
PROCEDURE Cierra-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE I-NRO AS INTEGER INIT 0 NO-UNDO.
FOR EACH FacDPedi NO-LOCK WHERE 
         FacDPedi.CodCia = S-CODCIA AND
         FacDPedi.CodDoc = CcbCDocu.Codped AND
         FacDPedi.NroPed = CcbCDocu.NroPed:
    IF (FacDPedi.CanPed - FacDPedi.CanAte) > 0 THEN DO:
       I-NRO = 1.
       LEAVE.
    END.
END.
IF I-NRO = 0 THEN DO ON ERROR UNDO, RETURN "ADM-ERROR": 
   FIND FacCPedi WHERE 
        FacCPedi.CodCia = S-CODCIA AND
        FacCPedi.CodDoc = CcbCDocu.Codped AND
        FacCPedi.NroPed = C-NROPED EXCLUSIVE-LOCK NO-ERROR.
   IF AVAILABLE FacCPedi THEN ASSIGN FacCPedi.FlgEst = "C".
   RELEASE FacCPedi.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Copiar-Guia V-table-Win 
PROCEDURE Copiar-Guia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAMETER pRowidChar AS CHAR.

IF NOT AVAILABLE Ccbcdocu THEN RETURN.

MESSAGE 'Este proceso generará una NUEVA Guía de Remisión' SKIP
    'La Guía COPIADA será ANULADA' SKIP(1)
    'Continuamos con el proceso?'
    VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
    UPDATE rpta2 AS LOG.
IF rpta2 = NO THEN RETURN 'ADM-ERROR'.

/* Consistencias */
DEFINE VAR RPTA AS CHAR.

IF CcbCDocu.FlgEst = "A" THEN DO:
    MESSAGE 'El documento se encuentra anulado...' VIEW-AS ALERT-BOX.
    RETURN 'ADM-ERROR'.
END.
/* RHC 21/10/2013 Verificamos H/R */
DEF VAR pHojRut   AS CHAR.
DEF VAR pFlgEst-1 AS CHAR.
DEF VAR pFlgEst-2 AS CHAR.
DEF VAR pFchDoc   AS DATE.

RUN dist/p-rut002 ( "G/R",
                    Ccbcdocu.coddoc,
                    Ccbcdocu.nrodoc,
                    "",
                    "",
                    "",
                    0,
                    0,
                    OUTPUT pHojRut,
                    OUTPUT pFlgEst-1,     /* de Di-RutaC */
                    OUTPUT pFlgEst-2,     /* de Di-RutaG */
                    OUTPUT pFchDoc).
IF pFlgEst-1 = "P" OR (pFlgEst-1 = "C" AND pFlgEst-2 = "C") THEN DO:
    MESSAGE "NO se puede anular" SKIP
        "Revisar la Hoja de Ruta:" pHojRut
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
/* *********************************** */
IF s-user-id <> "ADMIN" THEN DO:
    IF Ccbcdocu.FchDoc <> TODAY THEN DO:
        MESSAGE 'Solo se pueden copiar Guias generadas HOY'
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
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
    {adm/i-DocPssw.i s-CodCia s-CodDoc ""ADD""}
END.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
        AND FacCorre.CodDoc = S-CODDOC 
        AND FacCorre.NroSer = S-NROSER  
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCorre THEN DO:
        RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
        UNDO, RETURN 'ADM-ERROR'.
    END.
    FIND B-CDOCU WHERE ROWID(B-CDOCU) = ROWID(Ccbcdocu) EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CDOCU THEN UNDO, RETURN 'ADM-ERROR'.
    CREATE Ccbcdocu.
    BUFFER-COPY B-CDOCU 
        TO Ccbcdocu
        ASSIGN
        CcbCDocu.NroDoc = STRING(FacCorre.NroSer, ENTRY(1, x-Formato, '-')) +
                          STRING(FacCorre.Correlativo, ENTRY(2, x-Formato, '-'))
        CcbCDocu.usuario = S-USER-ID
        CcbCDocu.HorCie = string(time,'hh:mm:ss').
    pRowidChar = STRING(ROWID(Ccbcdocu)).
    ASSIGN 
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    FIND gn-clie WHERE 
         gn-clie.CodCia = CL-CODCIA AND
         gn-clie.CodCli = CcbCDocu.CodCli 
         NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie  THEN DO:
       ASSIGN CcbCDocu.CodDpto = gn-clie.CodDept 
              CcbCDocu.CodProv = gn-clie.CodProv 
              CcbCDocu.CodDist = gn-clie.CodDist.
    END.
    /* COPIAMOS DATOS DEL TRANSPORTISTA */
    FIND Ccbadocu WHERE Ccbadocu.codcia = B-CDOCU.codcia
        AND Ccbadocu.coddiv = B-CDOCU.coddiv
        AND Ccbadocu.coddoc = B-CDOCU.coddoc
        AND Ccbadocu.nrodoc = B-CDOCU.nrodoc
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbadocu THEN DO:
        FIND FIRST B-ADOCU WHERE B-ADOCU.codcia = s-codcia
            AND B-ADOCU.coddiv = Ccbcdocu.coddiv
            AND B-ADOCU.coddoc = Ccbcdocu.coddoc
            AND B-ADOCU.nrodoc = Ccbcdocu.nrodoc
            NO-ERROR.
        IF NOT AVAILABLE B-ADOCU THEN CREATE B-ADOCU.
        BUFFER-COPY Ccbadocu TO B-ADOCU
            ASSIGN
              B-ADOCU.CodDiv = Ccbcdocu.CodDiv
              B-ADOCU.CodDoc = Ccbcdocu.CodDoc
              B-ADOCU.NroDoc = Ccbcdocu.NroDoc.
    END.
    /* ******************************** */
    FOR EACH B-DDOCU OF B-CDOCU NO-LOCK:
        CREATE Ccbddocu.
        BUFFER-COPY B-DDOCU TO Ccbddocu
            ASSIGN
             CcbDDocu.NroDoc = Ccbcdocu.NroDoc.
    END.
    /* Anulamos Guia Original */
    ASSIGN
        B-CDOCU.FlgEst = "A"
        B-CDOCU.UsuAnu = s-user-id
        B-CDOCU.FchAnu = TODAY.

    IF AVAILABLE(B-CDOCU) THEN RELEASE B-CDOCU.
    IF AVAILABLE(Ccbddocu) THEN RELEASE Ccbddocu.
    IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
    IF AVAILABLE(B-ADOCU) THEN RELEASE B-ADOCU.
END.
RETURN 'OK'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Guia V-table-Win 
PROCEDURE Genera-Guia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  ------------------------------------------------------------------------------*/
  
  /* Solo los items que alcancen en la guia */
  DEF VAR x-Items AS INT INIT 1 NO-UNDO.
  FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK.
  FOR EACH DETA BY DETA.NroItm:
      CREATE CcbDDocu. 
      BUFFER-COPY DETA 
          TO Ccbddocu
          ASSIGN 
                CcbDDocu.CodCia = CcbCDocu.CodCia 
                CcbDDocu.Coddoc = CcbCDocu.Coddoc
                CcbDDocu.NroDoc = CcbCDocu.NroDoc 
                CcbDDocu.FchDoc = CcbCDocu.FchDoc
                CcbDDocu.CodDiv = CcbcDocu.CodDiv
                CcbDDocu.NroItm = x-Items.
      DELETE DETA.
      x-Items = x-Items + 1.
      IF x-Items > FacCfgGn.Items_Guias THEN LEAVE.
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

{vta2/graba-totales-factura-cred.i}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir-Transportista V-table-Win 
PROCEDURE Imprimir-Transportista :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE Ccbcdocu THEN RETURN.

RUN vta2/imprime-transportista ( Ccbcdocu.codcia,
                                 Ccbcdocu.coddiv,
                                 Ccbcdocu.coddoc,
                                 Ccbcdocu.nrodoc,
                                 Ccbcdocu.codcli,
                                 Ccbcdocu.nomcli).
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
/*   MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX INFORMATION. */
/*   RETURN 'ADM-ERROR'.                                      */
  
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
       FacCorre.CodDoc = S-CODDOC AND
       FacCorre.NroSer = S-NROSER  NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCorre OR FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Serie NO autorizada para hacer movimientos' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  input-var-1 = "".
  RUN vta2/d-facbol-gr-manual.
  IF output-var-1 = ? THEN RETURN "ADM-ERROR".
  ASSIGN
      S-CODCLI = output-var-3
      L-CREA = YES.
  RUN Actualiza-Deta.
  RUN Procesa-Factura.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Numero-de-Documento(NO).
  DO WITH FRAME {&FRAME-NAME}:
     FIND b-cdocu WHERE ROWID(B-Cdocu) = output-var-1 NO-LOCK.
     DISPLAY 
         TODAY @ CcbCDocu.FchDoc
         S-CODCLI @ CcbCDocu.CodCli
         STRING(I-NroSer, ENTRY(1, x-Formato, '-')) + STRING(I-NroDoc, ENTRY(2, x-Formato, '-')) @ CcbCDocu.NroDoc
         b-cdocu.CodVen @ CcbCDocu.CodVen
         b-cdocu.FmaPgo @ Ccbcdocu.FmaPgo
         b-cdocu.NomCli @ ccbcdocu.NomCli 
         b-cdocu.RucCli @ ccbcdocu.RucCli 
         b-cdocu.CodAnt @ ccbcdocu.CodAnt
         b-cdocu.DirCli @ ccbcdocu.DirCli
         b-cdocu.CodDoc @ ccbcdocu.codref
         b-cdocu.NroDoc @ ccbcdocu.nroref
         b-cdocu.CodPed @ ccbcdocu.codped
         b-cdocu.NroPed @ ccbcdocu.nroped.
     ASSIGN
         F-NomVen = ""
         F-CndVta = "".
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
         AND gn-ven.CodVen = b-cdocu.CodVen 
         NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
     FIND gn-convt WHERE gn-convt.Codig = b-cdocu.FmaPgo NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt THEN F-CndVta = gn-convt.Nombr.                                                      
     DISPLAY F-NomVen F-CndVta.
  END.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('Browse').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       Solo se crean Guias, NO se modifican
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND CURRENT b-cdocu EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE b-cdocu THEN UNDO, RETURN 'ADM-ERROR'.
  /* RHC 17/08/2017 Consistencia */
  FIND FIRST GUIAS WHERE GUIAS.codcia = s-codcia
      AND GUIAS.codref = B-CDOCU.coddoc
      AND GUIAS.nroref = B-CDOCU.nrodoc
      AND GUIAS.coddoc = "G/R"
      AND GUIAS.TpoFac = s-TpoFac
      AND GUIAS.FlgEst <> "A"
      NO-LOCK NO-ERROR.
  IF AVAILABLE GUIAS THEN DO:
      MESSAGE 'Ya se ha generado una guía manual para este comprobante' SKIP
          GUIAS.coddoc GUIAS.nrodoc GUIAS.fchdoc SKIP(2)
          'Proceso abortado'
          VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN 'ADM-ERROR'.
  END.

  DEF VAR pMensaje AS CHAR NO-UNDO.

  {lib/lock-genericov3.i ~
      &Tabla="FacCorre" ~
      &Condicion="FacCorre.CodCia = s-codcia ~
      AND FacCorre.CodDoc = s-coddoc ~
      AND FacCorre.NroSer = s-nroser" ~
      &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
      &Accion="RETRY" ~
      &Mensaje="YES" ~
      &txtMensaje="pMensaje" ~
      &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
      }

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  BUFFER-COPY B-CDOCU 
      EXCEPT
      B-CDOCU.CodPed
      B-CDOCU.NroPed
      B-CDOCU.CodRef
      B-CDOCU.NroRef
      B-CDOCU.Glosa
      TO Ccbcdocu
      ASSIGN
      CcbCDocu.CodDiv = S-CODDIV
      CcbCDocu.DivOri = B-CDOCU.CodDiv
      CcbCDocu.CodDoc = S-CODDOC
      CcbCDocu.NroDoc = STRING(FacCorre.NroSer, ENTRY(1, x-Formato, '-')) +
                        STRING(FacCorre.Correlativo, ENTRY(2, x-Formato, '-'))
      CcbCDocu.FchDoc = TODAY 
      CcbCDocu.FchVto = TODAY 
      CcbCDocu.CodMov = S-CODMOV 
      CcbCDocu.CodRef = b-cdocu.CodDoc
      CcbCDocu.Nroref = b-cdocu.Nrodoc
      CcbCDocu.Tipo   = "OFICINA"
      CcbCDocu.TipVta = "2"
      CcbCDocu.TpoFac = s-TpoFac       /*  Guia Manual */
      CcbCDocu.FlgEst = "F"
      CcbCDocu.FlgSit = "P"
      CcbCDocu.usuario = S-USER-ID
      CcbCDocu.HorCie = string(time,'hh:mm:ss').
  /* RHC 03/11/2016 BLOQUEADO */
/*   ASSIGN                                */
/*       B-CDOCU.codref = Ccbcdocu.coddoc  */
/*       B-CDOCU.nroref = Ccbcdocu.nrodoc. */
  ASSIGN 
      FacCorre.Correlativo = FacCorre.Correlativo + 1.
  FIND gn-clie WHERE 
       gn-clie.CodCia = CL-CODCIA AND
       gn-clie.CodCli = CcbCDocu.CodCli 
       NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie  THEN DO:
     ASSIGN CcbCDocu.CodDpto = gn-clie.CodDept 
            CcbCDocu.CodProv = gn-clie.CodProv 
            CcbCDocu.CodDist = gn-clie.CodDist.
  END.
  /* COPIAMOS DATOS DEL TRANSPORTISTA */
  FIND Ccbadocu WHERE Ccbadocu.codcia = B-CDOCU.codcia
      AND Ccbadocu.coddiv = B-CDOCU.coddiv
      AND Ccbadocu.coddoc = B-CDOCU.coddoc
      AND Ccbadocu.nrodoc = B-CDOCU.nrodoc
      NO-LOCK NO-ERROR.
  IF AVAILABLE Ccbadocu THEN DO:
      FIND FIRST B-ADOCU WHERE B-ADOCU.codcia = s-codcia
          AND B-ADOCU.coddiv = Ccbcdocu.coddiv
          AND B-ADOCU.coddoc = Ccbcdocu.coddoc
          AND B-ADOCU.nrodoc = Ccbcdocu.nrodoc
          NO-ERROR.
      IF NOT AVAILABLE B-ADOCU THEN CREATE B-ADOCU.
      BUFFER-COPY Ccbadocu TO B-ADOCU
          ASSIGN
            B-ADOCU.CodDiv = Ccbcdocu.CodDiv
            B-ADOCU.CodDoc = Ccbcdocu.CodDoc
            B-ADOCU.NroDoc = Ccbcdocu.NroDoc.
  END.
  /* ******************************** */

  RUN Genera-Guia.    /* Detalle de la Guia */ 
  RUN Graba-Totales.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* ********************************************* */
  /* Damos vueltas hasta completar todos los items */
  /* ********************************************* */
  REPEAT:
      FIND FIRST DETA NO-LOCK NO-ERROR.
      IF NOT AVAILABLE DETA THEN LEAVE.
      CREATE B-CDOCU.
      BUFFER-COPY CcbCDocu 
          TO B-CDOCU
          ASSIGN
          B-CDOCU.NroDoc = STRING(FacCorre.NroSer, ENTRY(1, x-Formato, '-')) +
                            STRING(FacCorre.Correlativo, ENTRY(2, x-Formato, '-')).
      ASSIGN 
          FacCorre.Correlativo = FacCorre.Correlativo + 1.
      FIND Ccbcdocu WHERE ROWID(Ccbcdocu) = ROWID(B-CDOCU) EXCLUSIVE-LOCK.
      RUN Genera-Guia.    /* Detalle de la Guia */ 
      RUN Graba-Totales.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

  
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
  DEFINE VAR RPTA AS CHAR.
   
   IF CcbCDocu.FlgEst = "A" THEN DO:
      MESSAGE 'El documento se encuentra anulado...' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
   END.


   /* CONSISTENCIA DE LA GUIA DE REMISION */
   /* RHC 21/10/2013 Verificamos H/R */
   DEF VAR pHojRut   AS CHAR.
   DEF VAR pFlgEst-1 AS CHAR.
   DEF VAR pFlgEst-2 AS CHAR.
   DEF VAR pFchDoc   AS DATE.

   RUN dist/p-rut002 ( "G/R",
                       Ccbcdocu.coddoc,
                       Ccbcdocu.nrodoc,
                       "",
                       "",
                       "",
                       0,
                       0,
                       OUTPUT pHojRut,
                       OUTPUT pFlgEst-1,     /* de Di-RutaC */
                       OUTPUT pFlgEst-2,     /* de Di-RutaG */
                       OUTPUT pFchDoc).
   IF pFlgEst-1 = "P" OR
       (pFlgEst-1 = "C" AND pFlgEst-2 = "C")
       THEN DO:
       MESSAGE "NO se puede anular" SKIP
           "Revisar la Hoja de Ruta:" pHojRut
           VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
   END.
   /* *********************************** */
   IF s-TpoFac = "A" AND Ccbcdocu.FchDoc <> TODAY THEN DO:
       MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
       RETURN 'ADM-ERROR'.
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
   {adm/i-DocPssw.i s-CodCia s-CodDoc ""DEL""}
   
   /* Motivo de anulacion */
   DEF VAR cReturnValue AS CHAR NO-UNDO.
   RUN ccb/d-motanu (ccbcdocu.codcia, ccbcdocu.coddoc, ccbcdocu.nrodoc, s-user-id, OUTPUT cReturnValue).
   IF cReturnValue = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

   DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
       /* Anulamos guia */
       FIND CURRENT Ccbcdocu EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
       IF ERROR-STATUS:ERROR THEN DO:
           RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
           UNDO, RETURN 'ADM-ERROR'.
       END.
       ASSIGN 
          Ccbcdocu.FlgEst = "A"
          Ccbcdocu.SdoAct = 0
          Ccbcdocu.Glosa  = "A N U L A D O"
          Ccbcdocu.FchAnu = TODAY
          Ccbcdocu.Usuanu = S-USER-ID. 
       /* ANULAMOS TRACKING */
       RUN vtagn/pTracking-04 (Ccbcdocu.CodCia,
                         Ccbcdocu.CodDiv,
                         Ccbcdocu.CodPed,
                         Ccbcdocu.NroPed,
                         s-User-Id,
                         'EGUI',
                         'A',
                         DATETIME(TODAY, MTIME),
                         DATETIME(TODAY, MTIME),
                         Ccbcdocu.coddoc,
                         Ccbcdocu.nrodoc,
                         Ccbcdocu.Libre_C01,
                         Ccbcdocu.Libre_C02).
       /* extornamos FAC o BOL */
/*        FIND B-CDOCU WHERE B-CDOCU.codcia = Ccbcdocu.codcia                            */
/*            AND B-CDOCU.coddoc = Ccbcdocu.codref                                       */
/*            AND B-CDOCU.nrodoc = Ccbcdocu.nroref                                       */
/*            AND B-CDOCU.codref = Ccbcdocu.coddoc                                       */
/*            AND B-CDOCU.nroref = Ccbcdocu.nrodoc                                       */
/*            EXCLUSIVE-LOCK NO-ERROR.                                                   */
/*        IF NOT AVAILABLE B-CDOCU THEN DO:                                              */
/*            MESSAGE 'NO pudo actualizar la referencia' ccbcdocu.codref ccbcdocu.nroref */
/*                VIEW-AS ALERT-BOX ERROR.                                               */
/*            UNDO, RETURN 'ADM-ERROR'.                                                  */
/*        END.                                                                           */
/*        /* RHC 03/11/2016 BLOQUEADO */                                                 */
/*        ASSIGN                                                                         */
/*            B-CDOCU.codref = ""                                                        */
/*            B-CDOCU.nroref = "".                                                       */
       FIND CURRENT Ccbcdocu NO-LOCK.
       IF AVAILABLE(B-CDOCU) THEN RELEASE B-CDOCU.
   END.
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

  /* Dispatch standard ADM method.     
                                  */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
    
  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE CcbCDocu THEN DO WITH FRAME {&FRAME-NAME}:
     CASE CcbCDocu.FlgEst:
         WHEN "A" THEN DISPLAY "ANULADO" @ F-Estado WITH FRAME {&FRAME-NAME}.
         WHEN "F" THEN DISPLAY "FACTURADO" @ F-Estado WITH FRAME {&FRAME-NAME}. 
         WHEN "X" THEN DISPLAY "POR CHEQUEAR" @ F-Estado WITH FRAME {&FRAME-NAME}.
         WHEN "P" THEN DISPLAY "PENDIENTE" @ F-Estado WITH FRAME {&FRAME-NAME}. 
     END CASE.         
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA AND 
          gn-ven.CodVen = CcbCDocu.CodVen NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen:SCREEN-VALUE = gn-ven.NomVen.
     FIND gn-convt WHERE gn-convt.Codig = Ccbcdocu.FmaPgo NO-LOCK NO-ERROR.
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
          CcbCDocu.CodPed:SENSITIVE = NO
          CcbCDocu.CodRef:SENSITIVE = NO
          CcbCDocu.NroPed:SENSITIVE = NO
          CcbCDocu.NroRef:SENSITIVE = NO.
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
  IF Ccbcdocu.FlgEst = 'A' THEN RETURN.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /*RUN vta2/d-fmtgui ( ROWID(Ccbcdocu) ).*/
  RUN logis/d-formato-gr (ROWID(Ccbcdocu) ).

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
  IF AVAILABLE(B-CDOCU) THEN RELEASE B-CDOCU.
  IF AVAILABLE(Ccbddocu) THEN RELEASE Ccbddocu.
  IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
  IF AVAILABLE(B-ADOCU) THEN RELEASE B-ADOCU.
  
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

  IF L-INCREMENTA THEN
     FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = S-CODDOC AND
          FacCorre.NroSer = S-NROSER  EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
  
  ELSE
     FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = S-CODDOC AND
          FacCorre.NroSer = S-NROSER  NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCorre THEN DO:
      RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
      RETURN 'ADM-ERROR'.
  END.
  ASSIGN 
      I-NroDoc = FacCorre.Correlativo.
  IF L-INCREMENTA THEN 
      ASSIGN 
      FacCorre.Correlativo = FacCorre.Correlativo + 1.
  ASSIGN
      I-NROSER = FacCorre.NroSer.
      /*S-CODALM = FacCorre.CodAlm.*/
  RELEASE FacCorre.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Factura V-table-Win 
PROCEDURE Procesa-Factura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE C-RETORNO AS CHAR INIT "OK" NO-UNDO.

DEF BUFFER B-GUIA FOR Ccbcdocu.

FIND B-CDOCU WHERE ROWID(B-CDOCU) = output-var-1 NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CDOCU THEN RETURN "ADM-ERROR".

/* verificamos que no tenga una guia anterior */
IF B-CDOCU.CodRef = s-CodDoc THEN DO:
    FIND B-GUIA WHERE B-GUIA.codcia = B-CDOCU.codcia
        AND B-GUIA.coddoc = B-CDOCU.codref
        AND B-GUIA.nrodoc = B-CDOCU.nroref
        NO-LOCK NO-ERROR.
    IF AVAILABLE B-GUIA AND B-GUIA.flgest <> 'A' THEN DO:
        MESSAGE 'El comprobante' B-CDOCU.coddoc B-CDOCU.nrodoc 
            'ya tiene una' s-coddoc 'asignada' 
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
END.
/* RHC 13/06/19 */
/* IF B-CDOCU.CodPed <> "P/M" THEN DO:                                                    */
/*     MESSAGE 'Solo se pueden aceptar comprobantes que vengan de una Orden de Mostrador' */
/*         VIEW-AS ALERT-BOX ERROR.                                                       */
/*     RETURN 'ADM-ERROR'.                                                                */
/* END.                                                                                   */

/* cargamos información */
FOR EACH CcbDdocu OF B-CDOCU NO-LOCK:   /* FAC o BOL */
    CREATE DETA.
    BUFFER-COPY Ccbddocu TO DETA.
END.
RETURN C-RETORNO.

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
  IF p-state = 'update-begin':U THEN DO:
     L-CREA = NO.
     RUN Actualiza-Deta.
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

DEFINE VARIABLE X-ITEMS AS INTEGER INIT 0.
DEFINE VARIABLE I-ITEMS AS DECIMAL NO-UNDO.
DO WITH FRAME {&FRAME-NAME} :
   X-ITEMS = 0.
   FOR EACH DETA NO-LOCK:
       I-ITEMS = I-ITEMS + DETA.CanDes.
       X-ITEMS = X-ITEMS + 1.
   END.
   IF I-ITEMS = 0 THEN DO:
      MESSAGE "No hay items por despachar" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO CcbCDocu.Glosa.
      RETURN "ADM-ERROR".   
   END.
   
    FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
    IF X-ITEMS >  FacCfgGn.Items_Guias THEN DO:
        MESSAGE "Numero de Items Mayor al Configurado para el Tipo de Documento " SKIP
            "Se va(n) a generar" TRUNCATE(x-Items / FacCfgGn.Items_Guias, 0) + 1 'Guia(s)' SKIP
            'Continuamos con la Generación de Guias?'
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN DO:
            APPLY "ENTRY" TO CcbCDocu.Glosa.
            RETURN "ADM-ERROR".
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

  MESSAGE "Acceso Denegado" VIEW-AS ALERT-BOX WARNING.
  RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

