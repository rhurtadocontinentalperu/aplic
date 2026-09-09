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
/* Variables para el control de descargo de contipuntos */
DEF VAR p-Puntos AS INTEGER.
DEF VAR p-ImporteTotal AS DEC INIT 0.
DEF VAR p-Respuesta AS LOG INIT NO.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE CL-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-NROSER  AS INTEGER.
DEFINE SHARED VARIABLE S-IMPFLE  AS DECIMAL.

/* VARIABLES DEL TRACKING */
DEF VAR s-FechaI AS DATETIME NO-UNDO.
DEF VAR s-FechaT AS DATETIME NO-UNDO.
DEFINE VARIABLE s-aplic-fact-ade AS LOG NO-UNDO.    /* Aplicacion de la factura adelantada */

DEFINE SHARED TEMP-TABLE DETA LIKE CcbDDocu.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE I              AS INTEGER   NO-UNDO.
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
DEFINE BUFFER F-CDOCU FOR CcbCDocu.
DEFINE BUFFER F-DDOCU FOR CcbDDocu.

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

FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE TEMP-TABLE T-CPEDM LIKE FacCPedi.
   /*FIELD CodRef LIKE CcbCDocu.CodRef.*/
/*   FIELD t-NroRef LIKE CcbCDocu.NroRef.*/
DEFINE TEMP-TABLE T-DPEDM LIKE FacDPedi.

DEFINE VARIABLE RPTA        AS CHARACTER NO-UNDO.

DEF SHARED VAR s-NroPed LIKE CcbCDocu.NroPed.

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
&Scoped-Define ENABLED-FIELDS CcbCDocu.FchVto CcbCDocu.CodAnt ~
CcbCDocu.Glosa 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define ENABLED-OBJECTS RECT-21 
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.CodCli CcbCDocu.NomCli CcbCDocu.FchVto CcbCDocu.DirCli ~
CcbCDocu.TpoCmb CcbCDocu.RucCli CcbCDocu.CodAnt CcbCDocu.NroPed ~
CcbCDocu.NroCard CcbCDocu.NroOrd CcbCDocu.CodVen CcbCDocu.CodMon ~
CcbCDocu.FmaPgo CcbCDocu.CodAlm CcbCDocu.NroRef CcbCDocu.Glosa 
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
     SIZE 43 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE F-nOMvEN AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 96 BY 7.81.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.NroDoc AT ROW 1.27 COL 9 COLON-ALIGNED FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .81
          FONT 1
     F-Estado AT ROW 1.27 COL 25 COLON-ALIGNED NO-LABEL
     CcbCDocu.FchDoc AT ROW 1.27 COL 80 COLON-ALIGNED
          LABEL "F/ Emision"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.CodCli AT ROW 2.08 COL 9 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCDocu.NomCli AT ROW 2.08 COL 20 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 49 BY .81
     CcbCDocu.FchVto AT ROW 2.08 COL 80 COLON-ALIGNED
          LABEL "Vencimiento"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 FGCOLOR 9 
     CcbCDocu.DirCli AT ROW 2.88 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
     CcbCDocu.TpoCmb AT ROW 2.88 COL 80 COLON-ALIGNED
          LABEL "T/ Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.RucCli AT ROW 3.69 COL 9 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCDocu.CodAnt AT ROW 3.69 COL 29 COLON-ALIGNED
          LABEL "DNI"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCDocu.NroPed AT ROW 3.69 COL 80 COLON-ALIGNED FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 15 FGCOLOR 12 
     CcbCDocu.NroCard AT ROW 4.5 COL 9 COLON-ALIGNED
          LABEL "Nro.Tarjeta"
          VIEW-AS FILL-IN 
          SIZE 11.57 BY .81
     CcbCDocu.NroOrd AT ROW 4.5 COL 80 COLON-ALIGNED
          LABEL "O/ Compra" FORMAT "x(12)"
          VIEW-AS FILL-IN 
          SIZE 12.29 BY .81
     CcbCDocu.CodVen AT ROW 5.31 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     F-nOMvEN AT ROW 5.31 COL 16 COLON-ALIGNED NO-LABEL
     CcbCDocu.CodMon AT ROW 5.31 COL 82 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 10.72 BY .81
     CcbCDocu.FmaPgo AT ROW 6.12 COL 9 COLON-ALIGNED
          LABEL "Cond.Vta"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     F-CndVta AT ROW 6.12 COL 16 COLON-ALIGNED NO-LABEL
     CcbCDocu.CodAlm AT ROW 6.12 COL 80 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
          BGCOLOR 15 FGCOLOR 12 
     CcbCDocu.NroRef AT ROW 6.92 COL 9 COLON-ALIGNED
          LABEL "Guias" FORMAT "X(45)"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
     CcbCDocu.Glosa AT ROW 7.73 COL 9 COLON-ALIGNED
          LABEL "Glosa"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
          BGCOLOR 11 FGCOLOR 9 
     "Moneda:" VIEW-AS TEXT
          SIZE 6.43 BY .5 AT ROW 5.31 COL 75
     RECT-21 AT ROW 1 COL 1 WIDGET-ID 2
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
         HEIGHT             = 8.23
         WIDTH              = 97.
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

/* SETTINGS FOR FILL-IN CcbCDocu.CodAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.CodAnt IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.CodCli IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR RADIO-SET CcbCDocu.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.CodVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.DirCli IN FRAME F-Main
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
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FmaPgo IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.Glosa IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NroCard IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NroOrd IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.NroPed IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NroRef IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.RucCli IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
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
   FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
                 AND  gn-clie.CodCli = CcbCDocu.CodCli:SCREEN-VALUE
                NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-clie  THEN DO:
      MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.

   DISPLAY gn-clie.NomCli @ CcbCDocu.NomCli
           gn-clie.Ruc    @ CcbCDocu.RucCli
           gn-clie.DirCli @ CcbCDocu.DirCli WITH FRAME {&FRAME-NAME}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Pedidos V-table-Win 
PROCEDURE Actualiza-Pedidos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND FacCPedi WHERE
         FacCPedi.CodCia = CcbCDocu.CodCia AND
         FacCPedi.CodDoc = CcbCDocu.CodPed AND
         FacCPedi.NroPed = CcbCDocu.NroPed 
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    FOR EACH FacDPedi OF FacCPedi,
        FIRST CcbDDocu OF CcbCDocu WHERE CcbDDocu.CodMat = FacDPedi.CodMat NO-LOCK:
        ASSIGN
            FacDPedi.CanAte = CcbDDocu.CanDes.
    END.            
    ASSIGN FacCPedi.FlgEst = "F".
    FIND FIRST FacDPedi OF FacCPedi WHERE FacDPedi.CanAte = 0 NO-LOCK NO-ERROR.
    IF AVAILABLE FacDPedi THEN FacCPedi.FlgEst = 'P'.
    FOR EACH Facdpedi OF Faccpedi:
        ASSIGN Facdpedi.flgest = Faccpedi.flgest.
    END.
    RELEASE FacCPedi.
    RELEASE FacDPedi.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Pedidos V-table-Win 
PROCEDURE Asigna-Pedidos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR x-cto1 as deci init 0.
  DEFINE VAR x-cto2 as deci init 0.

  DO WITH FRAME {&FRAME-NAME}:
/*       RUN Actualiza-Deta.                          */
/*       ASSIGN                                       */
/*           input-var-1 = s-coddiv                   */
/*           input-var-2 = "PED"                      */
/*           input-var-3 = s-coddoc.                  */
/*       RUN lkup\c-pedpen-3 ("Pedidos Pendientes").  */
/*       IF output-var-1 = ? THEN RETURN 'ADM-ERROR'. */
/*                                                    */
/*       s-NroPed = output-var-2.                     */
      s-FechaI = DATETIME(TODAY, MTIME).
      FIND FacCPedi WHERE FacCPedi.CodCia = S-CODCIA 
          AND  FacCPedi.CodDiv = S-CodDiv 
          AND  FacCPedi.CodDoc = 'PED'
          AND  FacCPedi.NroPed = s-NroPed
          NO-LOCK NO-ERROR.
      I-CODMON = FacCPedi.CodMon.
      C-CODVEN = FacCPedi.CodVen.
      FOR EACH FacDPedi OF FacCPedi NO-LOCK WHERE FacDPedi.CanAte = 0:   /* RHC 14.10.05 */
         CREATE DETA.
         BUFFER-COPY FacDPedi TO DETA
             ASSIGN 
                DETA.CanDes = FacDPedi.CanPed.
         /***********Grabando Costos **********************/
         FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
             AND  Almmmatg.codmat = DETA.codmat 
             NO-LOCK NO-ERROR.
         IF AVAILABLE Almmmatg THEN DO: 
             IF almmmatg.monvta = 1 THEN DO:
                 x-cto1 = ROUND( Almmmatg.Ctotot * DETA.CanDes * DETA.Factor , 2 ).
                 x-cto2 = ROUND(( Almmmatg.Ctotot * DETA.CanDes * DETA.Factor ) /  Almmmatg.Tpocmb , 2 ).
             END.
             IF almmmatg.monvta = 2 THEN DO:
                 x-cto1 = ROUND( Almmmatg.Ctotot * DETA.CanDes * DETA.Factor * Almmmatg.TpoCmb, 2 ).
                 x-cto2 = ROUND(( Almmmatg.Ctotot * DETA.CanDes * DETA.Factor ) , 2 ).
             END.
             DETA.ImpCto = IF I-CODMON = 1 THEN x-cto1 ELSE x-cto2.
         END.
         /*************************************************/
     END.
     ASSIGN
         F-NomVen = ""
         F-CndVta = "".
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
         AND  gn-ven.CodVen = FaccPedi.CodVen 
         NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
     FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt THEN 
         ASSIGN 
            F-CndVta = gn-convt.Nombr
            D-FchVto = TODAY + gn-ConVt.TotDias.
     DISPLAY 
         FaccPedi.CodCli @ Ccbcdocu.CodCli
         FaccPedi.Nomcli @ CCbcdocu.Nomcli
         FaccPedi.DirCli @ CcbCdocu.Dircli
         FaccPedi.Ruccli @ Ccbcdocu.Ruccli
         FaccPedi.Atencion @ CcbCDocu.CodAnt
         FaccPedi.NroPed @ CcbCDocu.NroPed
         D-FCHVTO @ CcbCDocu.FchVto
         FacCPedi.ordcmp @ CcbCDocu.NroOrd
         FacCPedi.FmaPgo @ CcbCDocu.FmaPgo
         FaccPedi.CodVen @ CcbCDocu.CodVen
         FaccPedi.NroCard @ CcbCDocu.NroCard
         FaccPedi.Glosa  @ CcbCDocu.Glosa
         F-NomVen 
         F-CndVta.
     CcbCDocu.CodMon:SCREEN-VALUE = STRING(I-CodMon).
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
    FOR EACH ccbddocu OF ccbcdocu:
        DELETE ccbddocu.
    END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Despacho-Fac-Bol V-table-Win 
PROCEDURE Despacho-Fac-Bol :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
    RUN VTA\act_alm (ROWID(CcbCDocu)).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    /* Actualiza el flag de informaci¢n actualizada */
    ASSIGN 
        Ccbcdocu.FlgAte = 'D'
        Ccbcdocu.FchAte = TODAY.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales V-table-Win 
PROCEDURE Graba-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE F-IGV AS DECIMAL INIT 0 NO-UNDO.
  DEFINE VARIABLE F-ISC AS DECIMAL INIT 0 NO-UNDO.

  ASSIGN
      CcbCDocu.ImpDto = 0
      CcbCDocu.ImpIgv = 0
      CcbCDocu.ImpIsc = 0
      CcbCDocu.ImpTot = 0
      CcbCDocu.ImpExo = 0
      CcbCDocu.ImpFle = S-IMPFLE
      CcbCDocu.ImpCto = 0.
  FOR EACH CcbDDocu OF CcbCDocu NO-LOCK:
      F-Igv = F-Igv + CcbDDocu.ImpIgv.
      F-Isc = F-Isc + CcbDDocu.ImpIsc.
      CcbCDocu.ImpTot = CcbCDocu.ImpTot + CcbDDocu.ImpLin.
      IF NOT CcbDDocu.AftIgv THEN CcbCDocu.ImpExo = CcbCDocu.ImpExo + CcbDDocu.ImpLin.
      IF CcbDDocu.AftIgv = YES
      THEN CcbCDocu.ImpDto = CcbCDocu.ImpDto + ROUND(CcbDDocu.ImpDto / (1 + CcbCDocu.PorIgv / 100), 2).
      ELSE CcbCDocu.ImpDto = CcbCDocu.ImpDto + CcbDDocu.ImpDto.
      CcbCDocu.ImpCto = CcbCDocu.ImpCto + CcbDDocu.ImpCto.    
      IF Ccbddocu.almdes <> '' 
      THEN CcbCDocu.CodAlm = CcbDDocu.AlmDes.       /* OJO >> AQUI ACTUALIZAMOS EL CODIGO DEL ALMACEN */
  END.
  ASSIGN
      CcbCDocu.ImpIgv = ROUND(F-IGV,2)
      CcbCDocu.ImpIsc = ROUND(F-ISC,2)
      CcbCDocu.ImpVta = CcbCDocu.ImpTot - CcbCDocu.ImpExo - CcbCDocu.ImpIgv.
  IF CcbCDocu.PorDto > 0 THEN DO:
      ASSIGN
          CcbCDocu.ImpDto = CcbCDocu.ImpDto + ROUND((CcbCDocu.ImpVta + CcbCDocu.ImpExo) * CcbCDocu.PorDto / 100, 2)
          CcbCDocu.ImpTot = ROUND(CcbCDocu.ImpTot * (1 - CcbCDocu.PorDto / 100),2)
          CcbCDocu.ImpVta = ROUND(CcbCDocu.ImpVta * (1 - CcbCDocu.PorDto / 100),2)
          CcbCDocu.ImpExo = ROUND(CcbCDocu.ImpExo * (1 - CcbCDocu.PorDto / 100),2)
          CcbCDocu.ImpIgv = CcbCDocu.ImpTot - CcbCDocu.ImpExo - CcbCDocu.ImpVta.
  END.
  ASSIGN
      CcbCDocu.ImpBrt = CcbCDocu.ImpVta + CcbCDocu.ImpIsc + CcbCDocu.ImpDto + CcbCDocu.ImpExo
      CcbCDocu.SdoAct = CcbCDocu.ImpTot
      CcbCDocu.FlgEst = "P".
  /* RHC 20/10/08 */
/*   CcbCDocu.ImpTot2 = CcbCDocu.SdoAct. */

  /* APLICAMOS EL IMPORTE POR FACTURA POR ADELANTOS */
  ASSIGN
      Ccbcdocu.SdoAct = Ccbcdocu.SdoAct - Ccbcdocu.ImpTot2.

  /* RHC 22.12.06 */
  IF CcbCDocu.FmaPgo = '900' THEN DO:      /* Transferencia Gratuita */
      CcbCDocu.SdoAct = 0.
  END.
  IF Ccbcdocu.SdoAct <= 0
  THEN ASSIGN
          Ccbcdocu.FlgEst = 'C'
          Ccbcdocu.FchCan = TODAY.

    


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir V-table-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER L-CREA AS LOG.
  
  IF NOT AVAILABLE Ccbcdocu THEN RETURN.
  IF S-CODDOC = "FAC" THEN DO:
      CASE ccbcdocu.coddiv:
          WHEN '00011' THEN RUN vtamay/r-fac00011 (ROWID(ccbcdocu)).
          WHEN '00005' THEN RUN vtamay/r-fac00005 (ROWID(ccbcdocu)).
          OTHERWISE DO:
              RUN vtamay/r-fac00002 (ROWID(ccbcdocu)).
          END.
      END CASE.
  END.    
  IF S-CODDOC = "BOL" THEN DO:
      RUN vtamay/R-BOLE01 (ROWID(CcbCDocu)).    
/*     IF s-coddiv = '00015'       /* Expolibreria */ */
/*     THEN RUN vta/r-bolexpo (ROWID(CcbCDocu)).      */
/*     ELSE RUN vtamay/R-BOLE01 (ROWID(CcbCDocu)).    */
  END.
  
  IF L-CREA THEN DO:
    /*RD01-Nuevo formato impresion
    RUN vtamay/r-odesp (ROWID(ccbcdocu), CcbCDocu.CodAlm).
    */  

    FIND FIRST b-cdocu WHERE ROWID(b-cdocu) = ROWID(ccbcdocu) NO-ERROR.
    IF AVAIL b-cdocu THEN DO:        
        IF NOT b-cdocu.FlgCbd THEN DO:
            RUN vtamay/r-odesp-001a (ROWID(ccbcdocu), CcbCDocu.CodAlm,'ORIGINAL').
            ASSIGN b-cdocu.FlgCbd = YES.
        END.
        ELSE RUN vtamay/r-odesp-001a (ROWID(ccbcdocu), CcbCDocu.CodAlm,'DUPLICADO').
    END.    
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
  RUN Actualiza-Deta.
  ASSIGN
      input-var-1 = s-coddiv
      input-var-2 = "PED"
      input-var-3 = s-coddoc.
  RUN lkup\c-pedpen-3 ("Pedidos Pendientes").
  IF output-var-1 = ? THEN UNDO, RETURN 'ADM-ERROR'.

  s-NroPed = output-var-2.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Numero-de-Documento(NO).
  DO WITH FRAME {&FRAME-NAME}:
      RUN Asigna-Pedidos.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
     DISPLAY 
         TODAY @ CcbCDocu.FchDoc
         STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999") @ CcbCDocu.NroDoc.
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
  Notes:       SOLO se puden CREAR facturas
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR N-ITMS AS INT INIT 1 NO-UNDO.
  DEF VAR x-Limite-Items AS INT INIT 0 NO-UNDO.
  
  DEF VAR x-ControlDocumento AS INT INIT 1 NO-UNDO.
  DEF VAR x-NuevoDocumento AS LOG INIT YES NO-UNDO.

  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
        FacCorre.CodDoc = S-CODDOC AND
        FacCorre.CodDiv = S-CODDIV AND
        FacCorre.NroSer = S-NROSER EXCLUSIVE-LOCK NO-ERROR.
  IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.  

  FIND B-CPEDI WHERE B-CPEDI.codcia = s-codcia
      AND B-CPEDI.coddoc = 'PED'
      AND B-CPEDI.nroped = s-NroPed
      EXCLUSIVE-LOCK NO-ERROR.
  IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* SE VAN A GENERAR GRUPOS DE FACTURAS DE ACUERDO AL ALMACEN DESPACHO */
  CASE s-coddoc:
    WHEN 'FAC' THEN x-Limite-Items = FacCfgGn.Items_Factura.
    WHEN 'BOL' THEN x-Limite-Items = FacCfgGn.Items_Boleta.
  END CASE.
  FOR EACH DETA BREAK BY DETA.AlmDes BY DETA.NroItm:
      IF FIRST-OF(DETA.AlmDes) OR x-NuevoDocumento = YES THEN DO:
          FIND Almacen WHERE Almacen.codcia = s-codcia
              AND Almacen.codalm = DETA.almdes NO-LOCK.
          ASSIGN 
              I-NroSer = FacCorre.NroSer
              I-NroDoc = FacCorre.Correlativo
              FacCorre.Correlativo = FacCorre.Correlativo + 1.          
          IF x-ControlDocumento > 1 THEN DO:
              CREATE B-CDOCU.
              BUFFER-COPY CcbCDocu 
                  EXCEPT B-CDOCU.ImpTot2    /* OJO >> Control de Aplicación de Fact. Adelantadas */
                  TO B-CDOCU
                  ASSIGN                     
                    B-CDOCU.CodAlm = DETA.AlmDes
                    B-CDOCU.NroDoc = STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999").
              FIND CcbCDocu WHERE ROWID(CcbCDocu) = ROWID(B-CDOCU) EXCLUSIVE-LOCK NO-ERROR.
              IF NOT AVAILABLE CcbCDocu THEN UNDO, RETURN 'ADM-ERROR'.
          END.
          ELSE DO:
              BUFFER-COPY B-CPEDI 
                  EXCEPT B-CPEDI.Glosa B-CPEDI.NroRef
                  TO Ccbcdocu
                  ASSIGN 
                    CcbCDocu.CodCia = S-CODCIA
                    CcbCDocu.CodAlm = DETA.AlmDes
                    CcbCDocu.FchDoc = TODAY
                    CcbCDocu.FlgEst = "P"
                    CcbCDocu.FlgAte = "P"
                    CcbCDocu.CodDoc = S-CODDOC
                    CcbCDocu.CodMov = S-CODMOV 
                    CcbCDocu.CodDiv = S-CODDIV
                    CcbCDocu.NroDoc = STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999")
                    CcbCDocu.CodPed = "PED"
                    CcbCDocu.NroPed = B-CPEDI.NroPed
                    CcbCDocu.Tipo   = "OFICINA"
                    CcbCDocu.TipVta = "2"
                    CcbCDocu.TpoFac = "R"
                    CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
                    CcbCDocu.Usuario = S-USER-ID
                    CcbCDocu.ImpTot2 = 0.       /* OJO >> Control de Aplicación de Fact. Adelantadas */
              /* CONTROL DE ENVIO DE MERCADERIA CON GUIAS DE REMISION */
              IF B-CPEDI.FlgEnv = YES 
              THEN CcbCDocu.FlgCon = 'P'.
              ELSE CcbCDocu.FlgCon = ''.

              FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                  AND gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK NO-ERROR.
              IF AVAILABLE gn-clie THEN DO:
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
          END.
          x-ControlDocumento = x-ControlDocumento + 1.
          x-NuevoDocumento = NO.
          /* TRACKING POR ALMACEN-DIVISION */
          RUN vtagn/pTracking-04 (s-CodCia,
                       Almacen.CodDiv,
                       Ccbcdocu.CodPed,
                       Ccbcdocu.NroPed,
                       s-User-Id,
                       'EFAC',
                       'P',
                       DATETIME(TODAY, MTIME),
                       DATETIME(TODAY, MTIME),
                       Ccbcdocu.coddoc,
                       Ccbcdocu.nrodoc,
                       Ccbcdocu.codped,
                       Ccbcdocu.nroped).
          s-FechaT = DATETIME(TODAY, MTIME).
/*           RUN gn/pTracking-01 (s-CodCia,                               */
/*                             Almacen.CodDiv,                            */
/*                             Ccbcdocu.CodPed,                           */
/*                             Ccbcdocu.NroPed,                           */
/*                             s-User-Id,                                 */
/*                             'EFAC',                                    */
/*                             'P',                                       */
/*                             s-FechaI,                                  */
/*                             s-FechaT,                                  */
/*                             Ccbcdocu.CodDoc,                           */
/*                             Ccbcdocu.NroDoc,                           */
/*                             Ccbcdocu.CodPed,                           */
/*                             Ccbcdocu.NroPed).                          */
/*           IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
      END.
      CREATE CcbDDocu.
      BUFFER-COPY DETA TO CcbDDocu
          ASSIGN 
              CcbDDocu.CodCia = CcbCDocu.CodCia 
              CcbDDocu.CodDiv = CcbCDocu.CodDiv
              CcbDDocu.CodDoc = CcbCDocu.CodDoc 
              CcbDDocu.NroDoc = CcbCDocu.NroDoc
              CcbDDocu.FchDoc = CcbCDocu.FchDoc
              CcbDDocu.ImpCto = DETA.ImpCto
              CcbDDocu.NroItm = N-ITMS.
      RELEASE Ccbddocu.
      N-ITMS = N-ITMS + 1.
      IF N-ITMS > x-Limite-Items THEN x-NuevoDocumento = YES.
      IF LAST-OF(DETA.AlmDes) OR x-NuevoDocumento = YES THEN DO:
          RUN Graba-Totales. 

          /* RHC 10.12.2010 APLICACION DE FACTURAS ADELANTADAS */
          IF s-aplic-fact-ade = YES THEN DO:
              RUN vtagn/p-aplica-factura-adelantada ( ROWID(Ccbcdocu) ).
              RUN Graba-Totales. 
          END.

          RUN Actualiza-Pedidos.
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

          RUN Despacho-Fac-Bol.
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

          /* RHC 05.10.05 */
          IF p-Respuesta = NO THEN DO:
            /* CALCULO DE PUNTOS BONUS */
            RUN vtamay/puntosbonus (ccbcdocu.codcia, ccbcdocu.coddoc, ccbcdocu.coddiv, ccbcdocu.nrodoc).
          END.
          ELSE DO:
            /* RHC 05.10.05 Saldo en el cliente pero en la TARJETA */
            FIND GN-CARD WHERE GN-CARD.NroCard = Ccbcdocu.NroCard EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE GN-CARD THEN DO:
                GN-CARD.AcuBon[10] = GN-CARD.AcuBon[10] - p-Puntos.
                p-Puntos = 0.
            END.
            Ccbcdocu.Puntos = -1 * p-Puntos.
            RELEASE GN-CARD.
          END.    
          N-ITMS = 1.
      END.
  END.

  RELEASE FacCorre.     /* OJO */
  RELEASE B-CPEDI.

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
  DEFINE VAR x-flgOD AS LOGICAL NO-UNDO.

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
      MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
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

  FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

  IF MONTH(Ccbcdocu.FchDoc) <> MONTH(TODAY) 
        OR YEAR(Ccbcdocu.FchDoc) <> YEAR(TODAY) THEN DO:
    {adm/i-DocPssw.i s-CodCia s-CodDoc ""DEL""}
  END.
  
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
      /* Motivo de anulacion */
      DEF VAR cReturnValue AS CHAR NO-UNDO.
      RUN ccb/d-motanu (ccbcdocu.codcia, ccbcdocu.coddoc, ccbcdocu.nrodoc, s-user-id, OUTPUT cReturnValue).
      IF cReturnValue = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      /* ******************* */
      /* TRACKING FACTURAS */
      IF Ccbcdocu.codped = 'PED' THEN DO:
          FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
              AND Faccpedi.coddoc = Ccbcdocu.codped
              AND Faccpedi.nroped = Ccbcdocu.nroped
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Faccpedi THEN DO:
              MESSAGE 'No se pudo actualizar el' Ccbcdocu.codped Ccbcdocu.nroped.
              UNDO, RETURN 'ADM-ERROR'.
          END.
          FIND Almacen WHERE Almacen.codcia = Ccbcdocu.codcia
              AND Almacen.codalm = Ccbcdocu.codalm NO-LOCK.
          RUN vtagn/pTracking-04 (s-CodCia,
                              Almacen.CodDiv,
                              Ccbcdocu.CodPed,
                              Ccbcdocu.NroPed,
                              s-User-Id,
                              'EFAC',
                              'A',
                              DATETIME(TODAY, MTIME),
                              DATETIME(TODAY, MTIME),
                              Ccbcdocu.coddoc,
                              Ccbcdocu.nrodoc,
                              Ccbcdocu.codped,
                              Ccbcdocu.nroped).
/*           RUN gn/pTracking-01 (s-CodCia,                               */
/*                             Almacen.CodDiv,                            */
/*                             Ccbcdocu.CodPed,                           */
/*                             Ccbcdocu.NroPed,                           */
/*                             s-User-Id,                                 */
/*                             'EFAC',                                    */
/*                             'A',                                       */
/*                             DATETIME(TODAY, MTIME),                    */
/*                             DATETIME(TODAY, MTIME),                    */
/*                             Ccbcdocu.CodDoc,                           */
/*                             Ccbcdocu.NroDoc,                           */
/*                             Ccbcdocu.CodPed,                           */
/*                             Ccbcdocu.NroPed).                          */
/*           IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
      END.

      RUN VTA\des_alm (ROWID(CcbCDocu)).
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          MESSAGE 'NO se encontró la salida de almacen' ccbcdocu.nrosal
              VIEW-AS ALERT-BOX ERROR.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      /****   Add by C.Q. 17/03/2000  
              Imprime un Documento similar a la O/D Indicando
              el motivo de Anulación  ****/
      FIND FIRST Ccbddocu OF Ccbcdocu NO-LOCK NO-ERROR.
      IF AVAIL CcbDdocu THEN
         RUN ccb/r-motanu (ROWID(ccbcdocu), CcbDDocu.AlmDes, "Documento Anulado").
      RELEASE CcbDdocu.
      /**********************************/

    /* RHC 14.10.05 ACTUALIZAMOS PEDIDO */
    FIND FacCPedi WHERE FacCPedi.CodCia = CcbCDocu.CodCia 
        AND  FacCPedi.CodDoc = CcbCDocu.CodPed 
        AND  FacCPedi.NroPed = CcbCDocu.NroPed 
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacCPedi 
    THEN DO:
        FIND CURRENT FacCPedi EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
        FacCPedi.FlgEst = "P".
        FOR EACH FacDPedi OF FacCPedi,
            FIRST CcbDDocu OF CcbCDocu WHERE CcbDDocu.CodMat = FacDPedi.CodMat NO-LOCK:
            ASSIGN
                FacDPedi.CanAte = FacDPedi.CanAte - CcbDDocu.CanDes
                FacDPedi.FlgEst = FacCPedi.FlgEst.
        END.            
        RELEASE FacCPedi.
    END.

      RUN Borra-Detalle.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    
      /* RHC 10.12.2010 ACTUALIZAMOS FACTURA ADELANTADA */
      RUN vtagn/p-extorna-factura-adelantada ( ROWID(Ccbcdocu) ).
/*       RUN Descarga-Factura-Adelantada. */
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      /* ACTUALIZAMOS LAS GUIAS DE REMISION */
      FOR EACH B-CDOCU WHERE B-CDOCU.CodCia = S-CODCIA
              AND  B-CDOCU.CodDoc = "G/R" 
              AND  B-CDOCU.FlgEst = "F" 
              AND  B-CDOCU.CodRef = CcbCDocu.CodDoc 
              AND  B-CDOCU.NroRef = CcbCDocu.NroDoc:
        ASSIGN 
            B-CDOCU.FlgEst = "P"
            B-CDOCU.SdoAct = CcbCDocu.SdoAct.
      END.   

      FIND B-CDOCU WHERE ROWID(B-CDOCU) = ROWID(CcbCDocu) EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE B-CDOCU THEN DO:
        RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
        UNDO, RETURN 'ADM-ERROR'.
      END.
      ASSIGN 
        B-CDOCU.FlgEst = "A"
        B-CDOCU.SdoAct = 0
        B-CDOCU.UsuAnu = S-USER-ID
        B-CDOCU.Glosa  = "A N U L A D O".
      RELEASE B-CDOCU.
    
      /* RHC 05.10.05 Reversion de puntos bonus */
      FIND GN-CARD WHERE GN-CARD.nrocard = Ccbcdocu.nrocard EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE GN-CARD THEN DO:
          GN-CARD.AcuBon[10] = GN-CARD.AcuBon[10] - Ccbcdocu.puntos.
      END.
      RELEASE GN-CARD.
  END.
  
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
  IF AVAILABLE CcbCDocu THEN DO WITH FRAME {&FRAME-NAME}:
     IF CcbCDocu.FlgEst = "P" THEN F-Estado:SCREEN-VALUE = "PENDIENTE".
     IF CcbCDocu.FlgEst = "A" THEN F-Estado:SCREEN-VALUE = "ANULADO".
     IF CcbCDocu.FlgEst = "C" THEN F-Estado:SCREEN-VALUE = "CANCELADO".
     /*
     FIND gn-clie WHERE gn-clie.CodCia = 0 AND
          gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie  THEN 
        DISPLAY gn-clie.NomCli @ FILL-IN_NomCli 
                gn-clie.Ruc    @ FILL-IN_RucCli  
                gn-clie.DirCli @ FILL-IN_DirCli. 
     */
     F-NomVen:screen-value = "".
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA AND 
          gn-ven.CodVen = CcbCDocu.CodVen NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
     F-CndVta:SCREEN-VALUE = "".
     FIND gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
  END.
  /* Code placed here will execute AFTER standard behavior.    */

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
  DISABLE INTEGRAL.CcbCDocu.CodAnt WITH FRAME {&FRAME-NAME}.

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
    /* RHC 18-03-04 cambio de formato en Andahuaylas */
    CASE s-coddiv:
    WHEN '00013' THEN RUN vta/r-impfacexpo (ROWID(ccbcdocu)).   /* Expolibreria */
    WHEN '00002' THEN RUN vta/r-fac00002 (ROWID(ccbcdocu)).     /* Andahuaylas */
    WHEN '00001' THEN RUN vta/r-fac00002 (ROWID(ccbcdocu)).     /* Ucayali */
    WHEN '00014' THEN RUN vta/r-fac00002 (ROWID(ccbcdocu)).     /* Horizontal */
    WHEN '00003' THEN RUN vta/r-impfac (ROWID(ccbcdocu)).     /* Andahuaylas */
    OTHERWISE RUN vta/r-fac00002 (ROWID(ccbcdocu)).
    END CASE.
  END.    
  IF S-CODDOC = "BOL" THEN DO:
    IF s-coddiv = '00013'       /* Expolibreria */
    THEN RUN vta/r-bolexpo (ROWID(CcbCDocu)).
    ELSE RUN VTA\R-BOLE01.R(ROWID(CcbCDocu)).
  END.

/*   IF L-CREA THEN DO:                                    */
/*     RUN ccb/r-odesp (ROWID(ccbcdocu), CcbCDocu.CodALm). */
/*   END.                                                  */

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

  ASSIGN
    p-Puntos = 0
    p-ImporteTotal = 0
    p-Respuesta = NO.

  /* RHC 10.05.05 Descarga de ContiPuntos */
  IF CcbCDocu.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '11111111112'
        /*AND CcbCDocu.CodVen:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '002'*/
        AND CcbCDocu.FmaPgo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '900' 
        AND CcbCDocu.NroCard:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> '' THEN DO:
    FOR EACH DETA NO-LOCK:
        p-ImporteTotal = p-ImporteTotal + DETA.ImpLin.
    END.
    RUN vtamay/d-despto (CcbCDocu.NroCard:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                    INTEGER(CcbCDocu.CodMon:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                    p-ImporteTotal,
                    OUTPUT p-Puntos,
                    OUTPUT p-Respuesta).
    IF p-Respuesta = NO THEN RETURN 'ADM-ERROR'.
  END.
/* */

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

  IF L-INCREMENTA  
  THEN
     FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = S-CODDOC AND
          FacCorre.CodDiv = S-CODDIV AND
          FacCorre.NroSer = S-NROSER EXCLUSIVE-LOCK NO-ERROR.
  ELSE
     FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = S-CODDOC AND
          FacCorre.CodDiv = S-CODDIV AND
          FacCorre.NroSer = S-NROSER NO-LOCK NO-ERROR.

  IF ERROR-STATUS:ERROR THEN RETURN 'ADM-ERROR'.  
  ASSIGN I-NroDoc = FacCorre.Correlativo.
  IF L-INCREMENTA THEN ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
  I-NroSer = FacCorre.NroSer.
  S-CodAlm = FacCorre.CodAlm.
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
RETURN "ADM-ERROR".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

