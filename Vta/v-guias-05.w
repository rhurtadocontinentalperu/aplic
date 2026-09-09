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
DEFINE SHARED VARIABLE pv-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE cl-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHAR.
DEFINE SHARED VARIABLE S-CODMOV   AS INTEGER.
DEFINE SHARED VARIABLE S-NROSER   AS INTEGER.

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

DEFINE BUFFER B-CDOCU FOR CcbCDocu.

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV AND
     FacCorre.NroSer = S-NROSER NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN I-NroSer = FacCorre.NroSer.

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
&Scoped-Define ENABLED-FIELDS CcbCDocu.NomCli CcbCDocu.TpoCmb ~
CcbCDocu.DirCli CcbCDocu.FchDoc CcbCDocu.RucCli CcbCDocu.FchVto ~
CcbCDocu.CodAge CcbCDocu.LugEnt CcbCDocu.Glosa 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define ENABLED-OBJECTS RECT-21 
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.CodRef ~
CcbCDocu.NroRef CcbCDocu.CodCli CcbCDocu.NomCli CcbCDocu.TpoCmb ~
CcbCDocu.DirCli CcbCDocu.FchDoc CcbCDocu.RucCli CcbCDocu.HorCie ~
CcbCDocu.CodVen CcbCDocu.FchVto CcbCDocu.FmaPgo CcbCDocu.CodPed ~
CcbCDocu.NroPed CcbCDocu.CodAge CcbCDocu.NroOrd CcbCDocu.LugEnt ~
CcbCDocu.Glosa CcbCDocu.CodMon 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-pedido F-Estado F-nOMvEN F-CndVta ~
F-NomTra C-TpoVta 

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
DEFINE VARIABLE C-TpoVta AS CHARACTER FORMAT "X(256)":U INITIAL "Contado" 
     LABEL "Tipo Venta" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Factura","Letras" 
     DROP-DOWN-LIST
     SIZE 11.72 BY 1 NO-UNDO.

DEFINE VARIABLE F-CndVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .69 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     FONT 0 NO-UNDO.

DEFINE VARIABLE F-NomTra AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .69 NO-UNDO.

DEFINE VARIABLE F-nOMvEN AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-pedido AS CHARACTER FORMAT "X(256)":U 
     LABEL "Pedido" 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 6.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.NroDoc AT ROW 1.12 COL 9 COLON-ALIGNED FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 17.29 BY .69
          FONT 1
     FILL-IN-pedido AT ROW 1.12 COL 33.14 COLON-ALIGNED
     CcbCDocu.CodRef AT ROW 1.12 COL 47 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .69
     CcbCDocu.NroRef AT ROW 1.12 COL 53.72 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .69
     F-Estado AT ROW 1.12 COL 72.43 COLON-ALIGNED NO-LABEL
     CcbCDocu.CodCli AT ROW 1.81 COL 9 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     CcbCDocu.NomCli AT ROW 1.81 COL 22 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 39 BY .69
     CcbCDocu.TpoCmb AT ROW 1.81 COL 74 COLON-ALIGNED
          LABEL "T/  Cambio"
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .69
     CcbCDocu.DirCli AT ROW 2.54 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 52 BY .69
     CcbCDocu.FchDoc AT ROW 2.54 COL 74 COLON-ALIGNED
          LABEL "Emisión"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbCDocu.RucCli AT ROW 3.19 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     CcbCDocu.HorCie AT ROW 3.19 COL 74 COLON-ALIGNED HELP
          "" NO-LABEL FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 7.72 BY .69
          FGCOLOR 12 
     CcbCDocu.CodVen AT ROW 3.88 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .69
     F-nOMvEN AT ROW 3.88 COL 15 COLON-ALIGNED NO-LABEL
     CcbCDocu.FchVto AT ROW 3.88 COL 74 COLON-ALIGNED
          LABEL "Vencmento"
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .69
     CcbCDocu.FmaPgo AT ROW 4.58 COL 9 COLON-ALIGNED
          LABEL "Cond.Vta"
          VIEW-AS FILL-IN 
          SIZE 6 BY .69
     F-CndVta AT ROW 4.58 COL 15 COLON-ALIGNED NO-LABEL
     CcbCDocu.CodPed AT ROW 4.58 COL 64.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .69
     CcbCDocu.NroPed AT ROW 4.58 COL 74 COLON-ALIGNED
          LABEL "Nro" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .69
     CcbCDocu.CodAge AT ROW 5.27 COL 9 COLON-ALIGNED
          LABEL "Transportista" FORMAT "X(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     F-NomTra AT ROW 5.27 COL 20 COLON-ALIGNED NO-LABEL
     CcbCDocu.NroOrd AT ROW 5.27 COL 74 COLON-ALIGNED
          LABEL "O/ Compra" FORMAT "x(12)"
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .69
     CcbCDocu.LugEnt AT ROW 5.96 COL 9 COLON-ALIGNED
          LABEL "Entregar en" FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 52 BY .69
          FGCOLOR 9 
     C-TpoVta AT ROW 5.96 COL 74 COLON-ALIGNED
     CcbCDocu.Glosa AT ROW 6.65 COL 9 COLON-ALIGNED
          LABEL "Glosa" FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 52 BY .69
     CcbCDocu.CodMon AT ROW 6.81 COL 76 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.14 BY .62
     "Moneda   :" VIEW-AS TEXT
          SIZE 8.14 BY .58 AT ROW 6.81 COL 67.72
     RECT-21 AT ROW 1 COL 1
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
         HEIGHT             = 7.58
         WIDTH              = 91.72.
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

/* SETTINGS FOR COMBO-BOX C-TpoVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.CodAge IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.CodCli IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR RADIO-SET CcbCDocu.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.CodPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.CodRef IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.CodVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomTra IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-nOMvEN IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchDoc IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchVto IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-pedido IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FmaPgo IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.Glosa IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.HorCie IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT EXP-HELP                              */
/* SETTINGS FOR FILL-IN CcbCDocu.LugEnt IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NroOrd IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.NroRef IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
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

&Scoped-define SELF-NAME CcbCDocu.CodAge
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodAge V-table-Win
ON LEAVE OF CcbCDocu.CodAge IN FRAME F-Main /* Transportista */
DO:
  F-NomTra = "".
  IF CcbcDocu.CodAge:SCREEN-VALUE <> "" THEN DO: 
     FIND GN-PROV WHERE GN-PROV.codpro = CcbcDocu.CodAge:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN F-NomTra = gn-prov.Nompro.
  END.
  DISPLAY F-NomTra WITH FRAME {&FRAME-NAME}.
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
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH DETA:
    DELETE DETA.
END.
IF NOT L-CREA THEN DO:
   FOR EACH CcbDDocu NO-LOCK WHERE 
            CcbDDocu.CodCia = CcbCDocu.CodCia AND  
            CcbDDocu.NroDoc = CcbCDocu.NroDoc :
       CREATE DETA.
       BUFFER-COPY CcbDDocu TO DETA.
/*       ASSIGN DETA.CodCia = CcbDDocu.CodCia 
 *               DETA.codmat = CcbDDocu.codmat 
 *               DETA.almdes = CcbDDocu.almdes
 *               DETA.PreUni = CcbDDocu.PreUni 
 *               DETA.CanDes = CcbDDocu.CanDes 
 *               DETA.Pesmat = CcbDDocu.Pesmat
 *               DETA.Factor = CcbDDocu.Factor 
 *               DETA.UndVta = CcbDDocu.UndVta
 *               DETA.PreBas = CcbDDocu.PreBas 
 *               DETA.PorDto = CcbDDocu.PorDto 
 *               DETA.ImpLin = CcbDDocu.ImpLin 
 *               DETA.ImpIsc = CcbDDocu.ImpIsc 
 *               DETA.ImpIgv = CcbDDocu.ImpIgv 
 *               DETA.ImpDto = CcbDDocu.ImpDto 
 *               DETA.AftIsc = CcbDDocu.AftIsc 
 *               DETA.AftIgv = CcbDDocu.AftIgv.*/
   END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Pedido V-table-Win 
PROCEDURE Actualiza-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER I-Factor AS INTEGER.

  FOR EACH CcbDDocu NO-LOCK WHERE 
           CcbDDocu.CodCia = CcbCDocu.CodCia AND  
           CcbDDocu.CodDoc = CcbCDocu.CodDoc AND  
           CcbDDocu.NroDoc = CcbCDocu.NroDoc
           ON ERROR UNDO, RETURN "ADM-ERROR":
      FIND FacDPedi WHERE 
           FacDPedi.CodCia = CcbCDocu.CodCia AND  
           FacDPedi.CodDoc = CcbCDocu.Codped AND  
           FacDPedi.NroPed = CcbCDocu.NroPed AND  
           FacDPedi.CodMat = CcbDDocu.CodMat 
           EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE FacDPedi THEN DO:
         ASSIGN FacDPedi.CanAte = FacDPedi.CanAte + (CcbDDocu.CanDes * I-Factor).
         IF (FacDPedi.CanPed - FacDPedi.CanAte) = 0 
         THEN FacDPedi.FlgEst = "C".
         ELSE FacDPedi.FlgEst = "P".
      END.
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
    IF (FacDPedi.CanPed - FacDPedi.CanAte) < 0 THEN DO:
        MESSAGE 'INCONSISTENCIA: código' facdpedi.codmat SKIP
            'Cantidad pedida:' facdpedi.canped SKIP
            'Cantidad atendida:' facdpedi.canate
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
  END.
  IF I-NRO = 0 THEN DO ON ERROR UNDO, RETURN "ADM-ERROR": 
    FIND FacCPedi WHERE 
        FacCPedi.CodCia = S-CODCIA AND
        FacCPedi.CodDoc = CcbCDocu.Codped AND
        FacCPedi.NroPed = C-NROPED EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE FacCPedi 
    THEN ASSIGN FacCPedi.FlgEst = "C".
    RELEASE FacCPedi.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Guia V-table-Win 
PROCEDURE Genera-Guia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  ------------------------------------------------------------------------------*/

   FOR EACH DETA NO-LOCK WHERE DETA.CodMat <> "" BY DETA.NroItm ON ERROR UNDO, RETURN "ADM-ERROR": 
       CREATE CcbDDocu. 
       BUFFER-COPY DETA EXCEPT DETA.CanDev TO CcbDDocu
        ASSIGN 
            CcbDDocu.CodCia = CcbCDocu.CodCia
            CcbDDocu.Coddoc = CcbCDocu.Coddoc
            CcbDDocu.NroDoc = CcbCDocu.NroDoc 
            CcbDDocu.AlmDes = X-CODALM
            CcbDDocu.FchDoc = TODAY
            CcbDDocu.CodDiv = CcbcDocu.CodDiv.
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
DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.

DO ON ERROR UNDO, RETURN "ADM-ERROR":
   FIND B-CDOCU WHERE ROWID(B-CDOCU) = ROWID(CcbCDocu) EXCLUSIVE-LOCK NO-ERROR.
   B-CDOCU.ImpDto = 0.
   B-CDOCU.ImpIgv = 0.
   B-CDOCU.ImpIsc = 0.
   B-CDOCU.ImpTot = 0.
   B-CDOCU.ImpExo = 0.
   FOR EACH DETA NO-LOCK:        
       F-Igv = F-Igv + DETA.ImpIgv.
       F-Isc = F-Isc + DETA.ImpIsc.
       B-CDOCU.ImpTot = B-CDOCU.ImpTot + DETA.ImpLin.
       IF NOT DETA.AftIgv THEN B-CDOCU.ImpExo = B-CDOCU.ImpExo + DETA.ImpLin.
       IF DETA.AftIgv = YES
       THEN B-CDOCU.ImpDto = B-CDOCU.ImpDto + ROUND(DETA.ImpDto / (1 + B-CDOCU.PorIgv / 100), 2).
       ELSE B-CDOCU.ImpDto = B-CDOCU.ImpDto + DETA.ImpDto.
   END.
   B-CDOCU.ImpIgv = ROUND(F-IGV,2).
   B-CDOCU.ImpIsc = ROUND(F-ISC,2).
   B-CDOCU.ImpVta = B-CDOCU.ImpTot - B-CDOCU.ImpExo - B-CDOCU.ImpIgv.
  /* RHC 22.12.06 */
  IF B-CDOCU.PorDto > 0 THEN DO:
    B-CDOCU.ImpDto = B-CDOCU.ImpDto + ROUND((B-CDOCU.ImpVta + B-CDOCU.ImpExo) * B-CDOCU.PorDto / 100, 2).
    B-CDOCU.ImpTot = ROUND(B-CDOCU.ImpTot * (1 - B-CDOCU.PorDto / 100),2).
    B-CDOCU.ImpVta = ROUND(B-CDOCU.ImpVta * (1 - B-CDOCU.PorDto / 100),2).
    B-CDOCU.ImpExo = ROUND(B-CDOCU.ImpExo * (1 - B-CDOCU.PorDto / 100),2).
    B-CDOCU.ImpIgv = B-CDOCU.ImpTot - B-CDOCU.ImpExo - B-CDOCU.ImpVta.
  END.  
   B-CDOCU.ImpBrt = B-CDOCU.ImpVta + B-CDOCU.ImpIsc + B-CDOCU.ImpDto + B-CDOCU.ImpExo.
/*   B-CDOCU.ImpBrt = B-CDOCU.ImpTot - B-CDOCU.ImpIgv - B-CDOCU.ImpIsc + 
 *                     B-CDOCU.ImpDto - B-CDOCU.ImpExo.*/
  B-CDOCU.SdoAct = B-CDOCU.ImpTot.
  RELEASE B-CDOCU.
END.

END PROCEDURE.

/* calculo anterior 
   B-CDOCU.ImpDto = 0.
   B-CDOCU.ImpIgv = 0.
   B-CDOCU.ImpIsc = 0.
   B-CDOCU.ImpTot = 0.
   B-CDOCU.ImpExo = 0.
   FOR EACH DETA NO-LOCK: 
       B-CDOCU.ImpDto = B-CDOCU.ImpDto + DETA.ImpDto.
       F-Igv = F-Igv + DETA.ImpIgv.
       F-Isc = F-Isc + DETA.ImpIsc.
       B-CDOCU.ImpTot = B-CDOCU.ImpTot + DETA.ImpLin.
       IF NOT DETA.AftIgv THEN B-CDOCU.ImpExo = B-CDOCU.ImpExo + DETA.ImpLin.
   END.
   B-CDOCU.ImpIgv = ROUND(F-IGV,2).
   B-CDOCU.ImpIsc = ROUND(F-ISC,2).
   B-CDOCU.ImpBrt = B-CDOCU.ImpTot - B-CDOCU.ImpIgv - B-CDOCU.ImpIsc + 
                    B-CDOCU.ImpDto - B-CDOCU.ImpExo.
   B-CDOCU.ImpVta = B-CDOCU.ImpBrt - B-CDOCU.ImpDto.
   B-CDOCU.SdoAct = B-CDOCU.ImpTot.
*/

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

  input-var-1 = "O/D".
  RUN lkup\C-Pedido.r("Ordenes Pendientes").
  IF output-var-1 = ? THEN RETURN ERROR.
  C-CodPed = SUBSTRING(output-var-2,1,3).
  C-NroPed = SUBSTRING( output-var-2 ,4,9).
  S-CODCLI = output-var-3.
  L-CREA = YES.
  RUN Actualiza-Deta.
  RUN Procesa-Pedido.
  
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN ERROR.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  RUN Numero-de-Documento(NO).
  DO WITH FRAME {&FRAME-NAME}:
     FIND FacCPedi WHERE 
          FacCPedi.CodCia = S-CODCIA AND  
          FacCPedi.CodDiv = S-CODDIV AND  
          FacCPedi.CodDoc = C-CODPED AND  
          FacCPedi.NroPed = C-NROPED 
          NO-LOCK NO-ERROR.
          X-CODALM = FaccPedi.Codalm.
     DISPLAY TODAY @ CcbCDocu.FchDoc
             TODAY @ CcbCDocu.FchVto
             C-NroPed @ CcbCDocu.NroPed
             S-CODCLI @ CcbCDocu.CodCli
             STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999") @ CcbCDocu.NroDoc 
             FacCPedi.ordcmp @ CcbCDocu.NroOrd
             FacCPedi.FmaPgo @ CcbCDocu.FmaPgo
             FaccPedi.CodVen @ CcbCDocu.CodVen
             FacCfgGn.Tpocmb[1] @ CcbCDocu.TpoCmb
             FacCPedi.Glosa  @ CcbCDocu.Glosa.
    DISPLAY FacCPedi.NomCli @ Ccbcdocu.NomCli 
            FacCPedi.RucCli @ Ccbcdocu.RucCli 
            FacCPedi.DirCli @ Ccbcdocu.DirCli.

     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
          gn-clie.CodCli = S-CODCLI NO-LOCK NO-ERROR.
     F-NomVen = "".
     F-CndVta = "".
/*     IF gn-clie.CodCli = FacCfgGn.CliVar THEN DO:
 *          DISPLAY FacCPedi.NomCli @ FILL-IN_NomCli 
 *                  FacCPedi.RucCli @ FILL-IN_RucCli 
 *                  FacCPedi.DirCli @ FILL-IN_DirCli.
 *      END.                   */

     FIND gn-ven WHERE 
          gn-ven.CodCia = S-CODCIA AND  
          gn-ven.CodVen = FaccPedi.CodVen 
          NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
     FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt THEN F-CndVta = gn-convt.Nombr.                                                      
     DISPLAY F-NomVen F-CndVta.
     C-TpoVta:SCREEN-VALUE = 'Factura'.
     CcbCDocu.CodMon:SCREEN-VALUE = STRING(FacCPedi.CodMon).
/*     IF AVAILABLE gn-clie THEN DO:
 *         DISPLAY gn-clie.NomCli @ FILL-IN_NomCli 
 *                 gn-clie.Ruc    @ FILL-IN_RucCli  
 *                 gn-clie.DirCli @ FILL-IN_DirCli
 *                 gn-clie.DirEnt @ CcbCDocu.LugEnt.
 *         /* RHC agregamos el distrito */
 *         FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept
 *             AND Tabdistr.Codprovi = gn-clie.codprov 
 *             AND Tabdistr.Coddistr = gn-clie.CodDist NO-LOCK NO-ERROR.
 *         IF AVAILABLE Tabdistr 
 *         THEN Ccbcdocu.DirCli:SCREEN-VALUE = TRIM(Ccbcdocu.DirCli:SCREEN-VALUE) + ' - ' +
 *                                             TabDistr.NomDistr.
 *      END.
 *      IF gn-clie.CodCli = FacCfgGn.CliVar THEN DO:
 *          DISPLAY FacCPedi.NomCli @ FILL-IN_NomCli 
 *                  FacCPedi.RucCli @ FILL-IN_RucCli 
 *                  FacCPedi.DirCli @ FILL-IN_DirCli.
 *      END.                   */
     DISPLAY FacCPedi.LugEnt @ CcbCDocu.LugEnt.
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
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF L-CREA THEN DO WITH FRAME {&FRAME-NAME}:
     FIND FacCPedi WHERE 
          FacCPedi.CodCia = S-CODCIA AND  
          FacCPedi.CodDiv = S-CodDiv AND  
          FacCPedi.CodDoc = C-CODPED AND  
          FacCPedi.NroPed = C-NROPED 
          NO-LOCK NO-ERROR.
     if not available Faccpedi 
     then DO:
        message "error de Correlativo," + c-codped.
        UNDO, RETURN 'ADM-ERROR'.
     END.        
     RUN Numero-de-Documento(YES).
     IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
     /*S-CODALM = FacCPedi.CodAlm.*/
     ASSIGN CcbCDocu.CodCia = S-CODCIA
            CcbCDocu.CodAlm = X-CODALM
            CcbCDocu.CodDiv = S-CODDIV
            CcbCDocu.CodDoc = S-CODDOC
            CcbCDocu.NroDoc = STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999") 
         /* CcbCDocu.FchDoc = TODAY */
            CcbCDocu.CodMov = S-CODMOV 
            CcbCDocu.CodPed = C-CODPED 
            CcbCDocu.NroPed = C-NROPED 
            CcbCDocu.Tipo   = "OFICINA"
            CcbCDocu.FchVto = TODAY 
            CcbCDocu.CodCli = FacCPedi.CodCli
            CcbCDocu.CodVen = FacCPedi.CodVen
            /*CcbCDocu.NroPed = FacCPedi.NroRef*/
            CcbCDocu.TipVta = "2"
            CcbCDocu.TpoFac = "R"
            CcbCDocu.FmaPgo = FacCPedi.FmaPgo
            CcbCDocu.CodMon = FacCPedi.CodMon
            CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
            CcbCDocu.PorIgv = FacCfgGn.PorIgv
            CcbCDocu.NroOrd = /*FacCPedi.Nroref*/ FacCPedi.ordcmp
            CcbCDocu.FlgEst = "P"
            CcbCDocu.FlgSit = "P"
         /* CcbCDocu.FlgAte = "P" */
            CcbCDocu.usuario = S-USER-ID
            CcbCDocu.HorCie = string(time,'hh:mm')
            CcbCDocu.FlgEnv = (FacCPedi.TpoPed = 'M').      /* Marca de G/R Manual */

     FIND gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt THEN do:
        CcbCDocu.TipVta = IF gn-ConVt.TotDias = 0 THEN "1" ELSE "2".
        CcbCDocu.FchVto = CcbCDocu.FchDoc + INTEGER(ENTRY(NUM-ENTRIES(gn-ConVt.Vencmtos),gn-ConVt.Vencmtos)).
        end.
     ELSE MESSAGE "Error en Gn-Convt".
     DISPLAY CcbCDocu.NroDoc.

     FIND gn-clie WHERE 
          gn-clie.CodCia = cl-codcia AND
          gn-clie.CodCli = CcbCDocu.CodCli 
          NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie  THEN DO:
        ASSIGN CcbCDocu.CodDpto = gn-clie.CodDept 
               CcbCDocu.CodProv = gn-clie.CodProv 
               CcbCDocu.CodDist = gn-clie.CodDist.
     END.
  END.
  RUN Genera-Guia.    /* Detalle de la Guia */ 
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  RUN Actualiza-Pedido(1).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  RUN Graba-Totales.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  RUN Cierra-Pedido.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    
  /* descargamos de almacen */
  /* Para no perder la variable s-codalm */
  ASSIGN
    x-CodAlm = s-CodAlm
    s-CodAlm = CcbCDocu.CodAlm.
  RUN VTA\act_alm (ROWID(CcbCDocu)).
  ASSIGN
    s-CodAlm = x-CodAlm
    x-CodAlm = CcbCDocu.CodAlm.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  
  /* RHC 10.11.06 Auditoria */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
    CREATE CcbAudit.
    ASSIGN
        CcbAudit.CodCia = Ccbcdocu.codcia
        CcbAudit.CodCli = Ccbcdocu.codcli
        CcbAudit.CodDiv = Ccbcdocu.coddiv
        CcbAudit.CodDoc = Ccbcdocu.coddoc
        CcbAudit.CodMon = Ccbcdocu.codmon
        CcbAudit.CodRef = Ccbcdocu.codped
        CcbAudit.Evento = 'CREATE'
        CcbAudit.Fecha = TODAY
        CcbAudit.Hora = STRING(TIME, 'HH:MM')
        CcbAudit.ImpTot = Ccbcdocu.imptot
        CcbAudit.NomCli = Ccbcdocu.nomcli
        CcbAudit.NroDoc = Ccbcdocu.nrodoc
        CcbAudit.NroRef = Ccbcdocu.nroped
        CcbAudit.Usuario= s-user-id.
  END.
  /* ********************** */

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
  /* Code placed here will execute PRIOR to standard behavior. */
   DEFINE VAR RPTA AS CHAR.
   
   IF CcbCDocu.FlgEst = "A" THEN DO:
      MESSAGE 'El documento se enuentra anulado...' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
   END.
   IF CcbCDocu.FlgEst = 'F' THEN DO:
      MESSAGE 'El documento se encuentra Facturado' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
   END.
   IF CcbCDocu.SdoAct < CcbCDocu.ImpTot  THEN DO:
      MESSAGE 'El documento registra amortizaciones...' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
   END.
   
    RUN alm/p-ciealm-01 (Ccbcdocu.FchDoc, Ccbcdocu.CodAlm).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

  {adm/i-DocPssw.i s-CodCia s-CodDoc ""DEL""}

/*   RUN ALM/D-CLAVE('venta06', OUTPUT RPTA).
 *    IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".*/
   
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
    RUN Actualiza-Pedido(-1).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      
    RUN Borra-Guia.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      
    /* ACTUALIZAMOS STOCK DE ALMACEN */
    RUN VTA\des_alm (ROWID(CcbCDocu)).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      
    FIND B-CDOCU WHERE ROWID(B-CDOCU) = ROWID(CcbCDocu) EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN 
        B-CDOCU.FlgEst = "A"
        B-CDOCU.SdoAct = 0
        B-CDOCU.Glosa  = "A N U L A D O"
        B-CDOCU.FchAnu = TODAY
        B-CDOCU.Usuanu = S-USER-ID. 
    RELEASE B-CDOCU.
    FIND FacCPedi WHERE 
           FacCPedi.CodCia = CcbCDocu.CodCia AND
           FacCPedi.CodDoc = CcbCDocu.Codped AND
           FacCPedi.NroPed = CcbCDocu.NroPed EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE FacCPedi THEN ASSIGN FacCPedi.FlgEst = "P".
    RELEASE FacCPedi.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE CcbCDocu 
  THEN DO WITH FRAME {&FRAME-NAME}:
    FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
          gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK NO-ERROR.
/*    IF AVAILABLE gn-clie  
 *     THEN DISPLAY gn-clie.NomCli @ FILL-IN_NomCli 
 *                 gn-clie.Ruc    @ FILL-IN_RucCli  
 *                 gn-clie.DirCli @ FILL-IN_DirCli.
 *        
 *     IF CcbCDocu.CodCli = FacCfgGn.CliVar 
 *     THEN DO:
 *          DISPLAY CcbCDocu.NomCli @ FILL-IN_NomCli 
 *                   CcbCDocu.RucCli @ FILL-IN_RucCli 
 *                   CcbCDocu.DirCli @ FILL-IN_DirCli.
 *     END.*/
    CASE CcbCDocu.FlgEst:
         WHEN "A" THEN DISPLAY " ANULADO " @ F-Estado WITH FRAME {&FRAME-NAME}.
         WHEN "F" THEN DISPLAY "FACTURADO" @ F-Estado WITH FRAME {&FRAME-NAME}.
         WHEN "P" THEN DISPLAY "PENDIENTE" @ F-Estado WITH FRAME {&FRAME-NAME}.
         WHEN "X" THEN DISPLAY "POR CHEQUEAR" @ F-Estado WITH FRAME {&FRAME-NAME}.
    END CASE.         
                  
     F-NomVen:screen-value = "".
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA AND 
          gn-ven.CodVen = CcbCDocu.CodVen NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
     F-CndVta:SCREEN-VALUE = "".
     FIND gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
     
      FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND gn-prov.CODPRO = CcbCDocu.CodAge NO-LOCK NO-ERROR.
     IF AVAILABLE GN-PROV THEN F-NomTra:SCREEN-VALUE = GN-PROV.NomPRO.
     
     C-TpoVta:SCREEN-VALUE = ENTRY(INTEGER(CcbCDocu.TipVta),C-TpoVta:LIST-ITEMS).
     FILL-IN-pedido:screen-value = "".
     FIND FaccPedi WHERE FaccPedi.Codcia = S-CODCIA AND
                         FaccPedi.Coddoc = CcbCDocu.CodPed AND
                         FaccPedi.NroPed = CcbCDocu.NroPed NO-LOCK NO-ERROR.
     IF AVAILABLE FaccPedi THEN FILL-IN-pedido:screen-value = FaccPedi.NroRef.
  
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
        CcbCDocu.FchDoc:SENSITIVE = NO
        CcbCDocu.DirCli:SENSITIVE = NO
        CcbCDocu.NomCli:SENSITIVE = NO
        CcbCDocu.RucCli:SENSITIVE = NO.
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
        IF Ccbcdocu.flgest = 'X' THEN DO:
            MESSAGE 'NO se puede imprimir la guía' VIEW-AS ALERT-BOX ERROR.
            RETURN.
        END.
  
  /*IF CcbCDocu.FlgEst <> "A" THEN RUN VTA\R-ImpGui.R(ROWID(CcbCDocu)).*/
  IF CcbCDocu.FlgEst <> "A" THEN DO:
    IF CcbCDocu.FlgEnv  = YES    /* Es G/R manual */
    THEN DO:
        MESSAGE 'Esta es una GUIA MANUAL' SKIP
            'SOLO imprimirla en papel blanco' SKIP
            'Continuamos la impresion?'
            VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
            UPDATE rpta-1 AS LOG.
        IF rpta-1 = NO THEN RETURN.
    END.
    RUN vta/d-fmtgui-02 (ROWID(CcbCDocu)).
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
          FacCorre.CodDiv = S-CODDIV AND
          FacCorre.NroSer = S-NROSER  EXCLUSIVE-LOCK NO-ERROR.
  ELSE
     FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = S-CODDOC AND
          FacCorre.CodDiv = S-CODDIV AND
          FacCorre.NroSer = S-NROSER  NO-LOCK NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN 'ADM-ERROR'.     
  ASSIGN I-NroDoc = FacCorre.Correlativo.
  IF L-INCREMENTA THEN ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
  I-NROSER = FacCorre.NroSer.
  S-CODALM = FacCorre.CodAlm.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Pedido V-table-Win 
PROCEDURE Procesa-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE C-RETORNO AS CHAR INIT "OK" NO-UNDO.
FIND FacCPedi WHERE FacCPedi.CodCia = S-CODCIA 
               AND  FacCPedi.CodDiv = S-CODDIV 
               AND  FacCPedi.CodDoc = C-CODPED 
               AND  FacCPedi.NroPed = C-NROPED 
              NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCPedi THEN RETURN "ADM-ERROR".

FOR EACH FacDPedi OF FacCPedi NO-LOCK BY FacDPedi.NroItm:
    IF (FacDPedi.CanPed - FacDPedi.CanAte) > 0 THEN DO:
        FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
                       AND  Almmmate.CodAlm = FacCPedi.CodAlm 
                       AND  Almmmate.codmat = FacDPedi.CodMat 
                      NO-LOCK NO-ERROR.
        
        IF NOT AVAILABLE Almmmate OR Almmmate.StkAct <= 0 OR
           (Almmmate.StkAct - ((FacDPedi.CanPed - FacDPedi.CanAte) * FacDPedi.Factor)) < 0  THEN DO:         
           MESSAGE "No hay Stock para atender el articulo " FacDPedi.CodMat VIEW-AS ALERT-BOX ERROR.
           C-RETORNO = "ADM-ERROR".
           LEAVE.
        END.
        
        /* cargamos candev con el saldo del pedido para controlar lo maximo que podemos despachar  */
        CREATE DETA.
        BUFFER-COPY Facdpedi TO DETA
            ASSIGN 
                DETA.CodCia = S-CODCIA
                DETA.almdes = FacCPedi.CodAlm    /* OJO */
                DETA.CanDes = (FacDPedi.CanPed - FacDPedi.CanAte)
                DETA.CanDev = (FacDPedi.CanPed - FacDPedi.CanAte)
                DETA.ImpDto = ROUND( DETA.PreBas * (DETA.PorDto / 100) * DETA.CanDes , 2 )
                /* RHC 22.06.06 */
                DETA.ImpDto = DETA.ImpDto + ROUND( DETA.PreBas * DETA.CanDes * (1 - DETA.PorDto / 100) * (DETA.Por_Dsctos[1] / 100),4 )
                /* ************ */
                DETA.ImpLin = ROUND( DETA.PreUni * DETA.CanDes , 2 ) /* - DETA.ImpDto*/.

        IF DETA.AftIgv THEN 
           DETA.ImpIgv = DETA.ImpLin - ROUND(DETA.ImpLin / (1 + (FacCfgGn.PorIgv / 100)),4).
        FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                       AND  Almmmatg.codmat = FacDPedi.CodMat 
                      NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmatg AND DETA.AftIsc THEN 
           ASSIGN
              DETA.ImpIsc = ROUND(DETA.PreBas * DETA.CanDes * Almmmatg.PorIsc / 100,2).
        IF AVAILABLE Almmmatg THEN
           ASSIGN 
              DETA.Pesmat = Almmmatg.Pesmat * (DETA.Candes * DETA.Factor).
    END.
END.
RETURN C-RETORNO.
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
   FIND GN-PROV WHERE GN-PROV.CodPro = CcbcDocu.CodAge:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE GN-PROV THEN DO:
      MESSAGE "Codigo de transportista no existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO CcbCDocu.CodAge.
      RETURN "ADM-ERROR".   
   END.
   X-ITEMS = 0.
   FOR EACH DETA NO-LOCK:
       I-ITEMS = I-ITEMS + DETA.CanDes.
       X-ITEMS = X-ITEMS + 1.
   END.
   IF I-ITEMS = 0 THEN DO:
      MESSAGE "No hay items por despachar" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO CcbCDocu.CodAge.
      RETURN "ADM-ERROR".   
   END.
    
    FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
    IF X-ITEMS >  FacCfgGn.Items_Guias THEN DO:
     MESSAGE "Numero de Items Mayor al Configurado para el Tipode Documento " VIEW-AS ALERT-BOX INFORMATION.
     RETURN "ADM-ERROR".
    END. 

/*   FIND AlmCierr WHERE 
 *         AlmCierr.CodCia = S-CODCIA AND 
 *         AlmCierr.FchCie = INPUT CcbCDocu.FchDoc 
 *         NO-LOCK NO-ERROR.
 *    IF AVAILABLE AlmCierr AND
 *       AlmCierr.FlgCie THEN DO:
 *       MESSAGE "Este dia " AlmCierr.FchCie " se encuentra cerrado" SKIP 
 *               "Consulte con sistemas " VIEW-AS ALERT-BOX INFORMATION.
 *       RETURN "ADM-ERROR".
 *    END.*/

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
IF NOT AVAILABLE CcbCDocu THEN RETURN "ADM-ERROR".
x-CodAlm = CcbCDocu.CodAlm.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

