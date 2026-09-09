&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDocu FOR CcbCDocu.



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
DEFINE SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE cl-codcia  AS INT.
DEFINE SHARED VARIABLE s-codalm   AS CHAR.
DEFINE SHARED TEMP-TABLE DETA LIKE CcbDDocu.
DEFINE SHARED VARIABLE S-NROSER   AS INT.
DEFINE SHARED VARIABLE s-CndCre AS CHAR.
DEFINE SHARED VARIABLE s-TpoFac AS CHAR.

DEFINE SHARED VARIABLE S-PORDTO AS DEC.
DEFINE SHARED VARIABLE S-PORIGV AS DEC.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NRODOC       AS INTEGER   NO-UNDO.
DEFINE VARIABLE R-NRODEV       AS ROWID     NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE S-CODCLI       AS CHARACTER NO-UNDO. 
DEFINE VARIABLE R-ROWID        AS ROWID     NO-UNDO. 


FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV AND
     FacCorre.CodAlm = s-CodAlm AND 
     FacCorre.FlgEst = YES NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN I-NroSer = FacCorre.NroSer.

DEF VAR s-ClienteGenerico AS CHAR INIT '11111111111' NO-UNDO.

FIND FIRST FacCfgGn  WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
IF AVAILABLE FacCfgGn THEN s-ClienteGenerico = FacCfgGn.CliVar.

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
&Scoped-Define ENABLED-FIELDS CcbCDocu.FchDoc CcbCDocu.NroOrd ~
CcbCDocu.FchVto CcbCDocu.CodCli CcbCDocu.RucCli CcbCDocu.CodAnt ~
CcbCDocu.usuario CcbCDocu.NomCli CcbCDocu.DirCli CcbCDocu.CodRef ~
CcbCDocu.NroRef CcbCDocu.CodMon CcbCDocu.FmaPgo CcbCDocu.Glosa 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.NroOrd CcbCDocu.FchVto CcbCDocu.CodCli CcbCDocu.RucCli ~
CcbCDocu.CodAnt CcbCDocu.usuario CcbCDocu.NomCli CcbCDocu.FchAnu ~
CcbCDocu.DirCli CcbCDocu.UsuAnu CcbCDocu.CodRef CcbCDocu.NroRef ~
CcbCDocu.CodMon CcbCDocu.FmaPgo CcbCDocu.Glosa 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-EStado FILL-IN-FmaPgo 

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
DEFINE VARIABLE FILL-IN-EStado AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FmaPgo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.NroDoc AT ROW 1.19 COL 15 COLON-ALIGNED WIDGET-ID 182
          LABEL "Correlativo"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     FILL-IN-EStado AT ROW 1.19 COL 35 COLON-ALIGNED WIDGET-ID 172
     CcbCDocu.FchDoc AT ROW 1.19 COL 88 COLON-ALIGNED WIDGET-ID 168
          LABEL "Emisión"
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .81
     CcbCDocu.NroOrd AT ROW 1.96 COL 15 COLON-ALIGNED WIDGET-ID 194
          LABEL "No.Devolución" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     CcbCDocu.FchVto AT ROW 1.96 COL 88 COLON-ALIGNED WIDGET-ID 170
          LABEL "Vencimiento"
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .81
     CcbCDocu.CodCli AT ROW 2.73 COL 15 COLON-ALIGNED WIDGET-ID 156
          VIEW-AS FILL-IN 
          SIZE 15.43 BY .81
     CcbCDocu.RucCli AT ROW 2.73 COL 35 COLON-ALIGNED WIDGET-ID 186
          VIEW-AS FILL-IN 
          SIZE 16 BY .81
     CcbCDocu.CodAnt AT ROW 2.73 COL 57 COLON-ALIGNED WIDGET-ID 154
          LABEL "DNI" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
     CcbCDocu.usuario AT ROW 2.73 COL 88 COLON-ALIGNED WIDGET-ID 190
          LABEL "Creado por"
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     CcbCDocu.NomCli AT ROW 3.5 COL 15 COLON-ALIGNED WIDGET-ID 180
          VIEW-AS FILL-IN 
          SIZE 51.43 BY .81
     CcbCDocu.FchAnu AT ROW 3.5 COL 88 COLON-ALIGNED WIDGET-ID 166
          LABEL "Fecha Anulación" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .81
     CcbCDocu.DirCli AT ROW 4.27 COL 15 COLON-ALIGNED WIDGET-ID 164
          VIEW-AS FILL-IN 
          SIZE 61.43 BY .81
     CcbCDocu.UsuAnu AT ROW 4.27 COL 88 COLON-ALIGNED WIDGET-ID 188
          LABEL "Anulado por"
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     CcbCDocu.CodRef AT ROW 5.04 COL 15 COLON-ALIGNED WIDGET-ID 162
          LABEL "Referencia" FORMAT "x(3)"
          VIEW-AS COMBO-BOX INNER-LINES 3
          LIST-ITEM-PAIRS "FACTURA","FAC",
                     "BOLETA","BOL",
                     "TICKET","TCK"
          DROP-DOWN-LIST
          SIZE 12 BY 1
     CcbCDocu.NroRef AT ROW 5.04 COL 35 COLON-ALIGNED WIDGET-ID 184
          LABEL "Número"
          VIEW-AS FILL-IN 
          SIZE 13.43 BY .81
     CcbCDocu.CodMon AT ROW 5.04 COL 90 NO-LABEL WIDGET-ID 158
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dólares", 2
          SIZE 12 BY 1.54
     CcbCDocu.FmaPgo AT ROW 5.81 COL 15 COLON-ALIGNED WIDGET-ID 176
          LABEL "Forma de Pago"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FILL-IN-FmaPgo AT ROW 5.81 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 174
     CcbCDocu.Glosa AT ROW 6.58 COL 15 COLON-ALIGNED WIDGET-ID 178
          VIEW-AS FILL-IN 
          SIZE 61 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.CcbCDocu
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CDocu B "?" ? INTEGRAL CcbCDocu
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
         HEIGHT             = 6.69
         WIDTH              = 113.57.
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
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR COMBO-BOX CcbCDocu.CodRef IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.FchAnu IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.FchDoc IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchVto IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-EStado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FmaPgo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FmaPgo IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.NroOrd IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NroRef IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.UsuAnu IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.usuario IN FRAME F-Main
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
  IF INPUT {&self-name} = '' THEN RETURN.
  IF INPUT {&self-name} = s-ClienteGenerico THEN
      ASSIGN
      CcbCDocu.CodAnt:SENSITIVE = YES
      CcbCDocu.DirCli:SENSITIVE = YES
      CcbCDocu.NomCli:SENSITIVE = YES.
  ELSE 
      ASSIGN
      CcbCDocu.CodAnt:SENSITIVE = NO
      CcbCDocu.DirCli:SENSITIVE = NO
      CcbCDocu.NomCli:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodCli V-table-Win
ON LEFT-MOUSE-DBLCLICK OF CcbCDocu.CodCli IN FRAME F-Main /* Cliente */
OR F8 OF CcbCDocu.CodCli
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''.
    RUN vtagn/c-gn-clie-01 ('Clientes').
    IF output-var-1 <> ? THEN CcbCDocu.CodCli:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.FmaPgo V-table-Win
ON LEAVE OF CcbCDocu.FmaPgo IN FRAME F-Main /* Forma de Pago */
DO:
  FIND gn-ConVt WHERE gn-ConVt.Codig = INPUT {&self-name} NO-LOCK NO-ERROR.
  IF AVAILABLE gn-ConVt THEN
      DISPLAY gn-ConVt.Nombr @ FILL-IN-FmaPgo WITH FRAME {&FRAME-NAME}.
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
   FOR EACH CcbDDocu WHERE CcbDDocu.CodCia = CcbCDocu.CodCia
                      AND  CcbDDocu.CodDoc = CcbCDocu.CodDoc
                      AND  CcbDDocu.NroDoc = CcbCDocu.NroDoc
                     NO-LOCK:
       CREATE DETA.
       ASSIGN DETA.CodCia = CcbDDocu.CodCia
              DETA.codmat = CcbDDocu.codmat 
              DETA.PreUni = CcbDDocu.PreUni 
              DETA.CanDes = CcbDDocu.CanDes 
              DETA.Factor = CcbDDocu.Factor 
              DETA.ImpIsc = CcbDDocu.ImpIsc
              DETA.ImpIgv = CcbDDocu.ImpIgv 
              DETA.ImpLin = CcbDDocu.ImpLin
              DETA.PorDto = CcbDDocu.PorDto 
              DETA.PreBas = CcbDDocu.PreBas 
              DETA.ImpDto = CcbDDocu.ImpDto
              DETA.AftIgv = CcbDDocu.AftIgv
              DETA.AftIsc = CcbDDocu.AftIsc
              DETA.UndVta = CcbDDocu.UndVta.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Documento V-table-Win 
PROCEDURE Borra-Documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH CcbDDocu WHERE CcbDDocu.CodCia = CcbCDocu.CodCia
    AND  CcbDDocu.CodDoc = CcbCDocu.CodDoc 
    AND  CcbDDocu.NroDoc = CcbCDocu.NroDoc:
    DELETE CcbDDocu.
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

   FOR EACH DETA:
       CREATE CcbDDocu.
       ASSIGN 
           CcbDDocu.CodCia = CcbCDocu.CodCia 
           CcbDDocu.Coddiv = CcbCDocu.Coddiv 
           CcbDDocu.CodDoc = CcbCDocu.CodDoc 
           CcbDDocu.NroDoc = CcbCDocu.NroDoc
           CcbDDocu.FchDoc = CcbCDocu.FchDoc
           CcbDDocu.codmat = DETA.codmat 
           CcbDDocu.PreUni = DETA.PreUni 
           CcbDDocu.CanDes = DETA.CanDes 
           CcbDDocu.Factor = DETA.Factor 
           CcbDDocu.ImpIsc = DETA.ImpIsc
           CcbDDocu.ImpIgv = DETA.ImpIgv 
           CcbDDocu.ImpLin = DETA.ImpLin
           CcbDDocu.PorDto = DETA.PorDto 
           CcbDDocu.PreBas = DETA.PreBas 
           CcbDDocu.ImpDto = DETA.ImpDto
           CcbDDocu.AftIgv = DETA.AftIgv
           CcbDDocu.AftIsc = DETA.AftIsc
           CcbDDocu.UndVta = DETA.UndVta
           CcbDDocu.Por_Dsctos[1] = DETA.Por_Dsctos[1]
           CcbDDocu.Por_Dsctos[2] = DETA.Por_Dsctos[2]
           CcbDDocu.Por_Dsctos[3] = DETA.Por_Dsctos[3]
           CcbDDocu.Flg_factor = DETA.Flg_factor
           CcbDDocu.ImpCto     = DETA.ImpCto.
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

{vta/graba-totales-abono.i}

/* BLOQUEADO 13.08.10
FIND B-CDOCU WHERE B-CDOCU.codcia = CcbCDocu.codcia 
              AND  B-CDOCU.Coddoc = CcbCdocu.coddoc 
              AND  B-CDOCU.NroDoc = CcbCdocu.nrodoc 
             EXCLUSIVE-LOCK NO-ERROR.
     
IF AVAILABLE B-CDOCU THEN DO ON ERROR UNDO, RETURN "ADM-ERROR":
   ASSIGN 
      B-CDOCU.ImpBrt = 0
      B-CDOCU.ImpDto = 0
      B-CDOCU.ImpIgv = 0
      B-CDOCU.ImpTot = 0
      B-CDOCU.ImpVta = 0.
   FOR EACH DETA:
       ASSIGN
          B-CDOCU.ImpExo = B-CDOCU.ImpExo + IF DETA.AftIgv = No  THEN (DETA.PreUni * DETA.CanDes) ELSE 0
          B-CDOCU.ImpDto = B-CDOCU.ImpDto + DETA.ImpDto
          B-CDOCU.ImpIgv = B-CDOCU.ImpIgv + DETA.ImpIgv
          B-CDOCU.ImpTot = B-CDOCU.ImpTot + DETA.ImpLin.
          B-CDOCU.ImpCto = B-CDOCU.ImpCto + DETA.ImpCto.
       IF DETA.AftIgv = Yes THEN 
          ASSIGN
             B-CDOCU.ImpBrt = B-CDOCU.ImpBrt + (DETA.PreUni * DETA.CanDes)
             B-CDOCU.ImpVta = B-CDOCU.ImpVta + ((DETA.PreUni * DETA.CanDes) - (DETA.ImpIgv + DETA.ImpDto)).

   END.
   FIND FIRST FacCfgGn NO-LOCK NO-ERROR.
   ASSIGN
      B-CDOCU.SdoAct = B-CDOCU.ImpTot
      B-CDOCU.ImpTot2= B-CDOCU.ImpTot
      B-CDOCU.ImpIgv = B-CDOCU.ImpTot - (B-CDOCU.ImpTot / (1 + (FacCfgGn.PorIgv / 100)))
      B-CDOCU.ImpBrt = B-CDOCU.ImpTot - (B-CDOCU.ImpIgv  ) + B-CDOCU.ImpDto
      B-CDOCU.ImpVta = B-CDOCU.ImpBrt - B-CDOCU.ImpDto.

    /****   Add by C.Q. 04/02/2000  ****/
    IF B-CDOCU.PorDto > 0 THEN DO:
       B-CDOCU.ImpDto = B-CDOCU.ImpDto + ROUND(B-CDOCU.ImpTot * B-CDOCU.PorDto / 100,2).
       B-CDOCU.ImpTot = ROUND(B-CDOCU.ImpTot * (1 - B-CDOCU.PorDto / 100),2).
       B-CDOCU.ImpVta = ROUND(B-CDOCU.ImpTot / (1 + B-CDOCU.PorIgv / 100),2).
       B-CDOCU.ImpIgv = B-CDOCU.ImpTot - B-CDOCU.ImpVta.
       B-CDOCU.ImpBrt = B-CDOCU.ImpTot - B-CDOCU.ImpIgv - B-CDOCU.ImpIsc + 
                  B-CDOCU.ImpDto - B-CDOCU.ImpExo.
       B-CDOCU.SdoAct = B-CDOCU.ImpTot.
       B-CDOCU.ImpTot2= B-CDOCU.ImpTot.
    END.
    /***********************************/

END.
RELEASE B-CDOCU.
*************************************************** */
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
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDoc = S-CODDOC 
      AND FacCorre.NroSer = s-NroSer
      NO-LOCK NO-ERROR.
  IF FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  RUN lkup\C-DevoPendientes.r("Devoluciones Pendientes").
  IF output-var-1 = ? THEN RETURN "ADM-ERROR".
  ASSIGN
      s-PorIgv = FacCfgGn.PorIgv
      s-PorDto = 0
      i-nroser = s-nroser.

  RUN Procesa-Handle IN lh_handle ("Disable-Head").

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FIND Almcmov WHERE ROWID(Almcmov) = output-var-1 NO-LOCK.
      FIND B-CDOCU WHERE B-CDOCU.codcia = s-codcia
          AND B-CDOCU.coddoc = Almcmov.codref
          AND B-CDOCU.nrodoc = Almcmov.nroref
          NO-LOCK.
      R-NRODEV = ROWID(Almcmov).
      DISPLAY
          Almcmov.NroRf2 @ CcbCDocu.NroOrd
          B-CDOCU.codcli @ Ccbcdocu.codcli
          B-CDOCU.nomcli @ Ccbcdocu.nomcli
          B-CDOCU.dircli @ Ccbcdocu.dircli
          B-CDOCU.ruccli @ Ccbcdocu.ruccli
          B-CDOCU.codant @ Ccbcdocu.codant
          B-CDOCU.nroref @ Ccbcdocu.nroref
          B-CDOCU.fmapgo @ Ccbcdocu.fmapgo
          B-CDOCU.glosa  @ Ccbcdocu.glosa
          STRING(FacCorre.nroSer, '999') + STRING(FacCorre.Correlativo, '999999') @  CcbCDocu.NroDoc
          TODAY @ CcbCDocu.FchDoc 
          ADD-INTERVAL(TODAY, 1, 'years') @ CcbCDocu.FchVto
          s-user-id @ CcbCDocu.usuario.
      ASSIGN
          Ccbcdocu.codref:SCREEN-VALUE = B-CDOCU.coddoc
          Ccbcdocu.nroref:SCREEN-VALUE = B-CDOCU.nrodoc
          CcbCDocu.CodMon:SCREEN-VALUE = STRING(B-CDOCU.codmon).

      EMPTY TEMP-TABLE DETA.
      FOR EACH Almdmov NO-LOCK WHERE Almdmov.CodCia = Almcmov.CodCia 
          AND  Almdmov.CodAlm = Almcmov.CodAlm 
          AND  Almdmov.TipMov = Almcmov.TipMov 
          AND  Almdmov.CodMov = Almcmov.CodMov 
          AND  Almdmov.NroDoc = Almcmov.NroDoc:
          CREATE DETA.
          ASSIGN 
              DETA.CodCia = AlmDMov.CodCia
              DETA.codmat = AlmDMov.codmat
              DETA.PreUni = AlmDMov.PreUni
              DETA.CanDes = AlmDMov.CanDes
              DETA.Factor = AlmDMov.Factor
              DETA.ImpIsc = AlmDMov.ImpIsc
              DETA.ImpIgv = AlmDMov.ImpIgv
              DETA.ImpLin = AlmDMov.ImpLin
              DETA.PorDto = AlmDMov.PorDto
              DETA.PreBas = AlmDMov.PreBas
              DETA.ImpDto = AlmDMov.ImpDto
              DETA.AftIgv = AlmDMov.AftIgv
              DETA.AftIsc = AlmDMov.AftIsc
              DETA.UndVta = AlmDMov.CodUnd
              DETA.Por_Dsctos[1] = Almdmov.Por_Dsctos[1]
              DETA.Por_Dsctos[2] = Almdmov.Por_Dsctos[2]
              DETA.Por_Dsctos[3] = Almdmov.Por_Dsctos[3]
              DETA.Flg_factor = Almdmov.Flg_factor.
          /*************Grabando Costos ********************/
          FIND CcbDDocu WHERE CcbDDocu.codcia = s-codcia 
              AND CcbDDocu.CodDiv = S-CODDIV
              AND CcbDDocu.CodDoc = Almcmov.CodRef 
              AND CcbDDocu.NroDoc = Almcmov.NroRf1 
              AND CcbDDocu.CodMat = Almdmov.codMat
              USE-INDEX LLAVE04 NO-LOCK NO-ERROR.
          IF AVAILABLE CcbDDocu THEN DO: 
              DETA.ImpCto = CcbDDocu.ImpCto * ( ( DETA.Candes * DETA.Factor ) / (CcbDDocu.Candes * CcbDDocu.Factor) ). 
          END.
      END.
      APPLY 'LEAVE':U TO CcbCDocu.CodCli.
      APPLY 'LEAVE':U TO CcbCDocu.FmaPgo.
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
  Notes:       NO hay modificación
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {lib/lock-genericov2.i ~
      &Tabla="FacCorre" ~
      &Condicion="FacCorre.CodCia = s-codcia ~
      AND FacCorre.CodDiv = s-coddiv ~
      AND FacCorre.CodDoc = s-coddoc ~
      AND FacCorre.NroSer = s-nroser" ~
      &Bloqueo="EXCLUSIVE-LOCK" ~
      &Accion="RETRY" ~
      &Mensaje="YES" ~
      &TipoError="RETURN 'ADM-ERROR'" ~
      }

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN 
      CcbCDocu.CodCia = S-CODCIA
      CcbCDocu.CodDiv = S-CODDIV
      CcbCDocu.CodDoc = S-CODDOC
      CcbCDocu.NroDoc = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
      CcbCDocu.FchDoc = TODAY
      CcbCDocu.FchVto = ADD-INTERVAL(TODAY, 1, 'years')
      CcbCDocu.FlgEst = "P"
      CcbCDocu.PorIgv = s-PorIgv
      CcbCDocu.PorDto = S-PORDTO
      CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
      CcbCDocu.CndCre = s-CndCre     /* POR DEVOLUCION */
      CcbCDocu.TpoFac = s-TpoFac
      CcbCDocu.Tipo   = "OFICINA"
      CcbCDocu.usuario = S-USER-ID
      CcbCDocu.SdoAct = CcbCDocu.Imptot.

  ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.

  FIND Almcmov WHERE ROWID(Almcmov) = R-NRODEV  NO-ERROR.
  ASSIGN 
      CcbCDocu.CodAlm = Almcmov.CodAlm
      CcbCDocu.CodMov = Almcmov.CodMov
      CcbCDocu.CodVen = Almcmov.CodVen
      CcbCDocu.NroPed = STRING(Almcmov.NroDoc)
      CcbCDocu.NroOrd = Almcmov.NroRf2.
  ASSIGN Almcmov.FlgEst = "C".

  /* ACTUALIZAR EL CENTRO DE COSTO 22.07.04 CY */
  FIND B-CDOCU WHERE B-CDOCU.codcia = s-codcia
      AND B-CDOCU.coddoc = ccbcdocu.codref
      AND B-CDOCU.nrodoc = ccbcdocu.nroref 
      NO-LOCK NO-ERROR.
  IF AVAILABLE B-CDOCU THEN DO:
      FIND GN-VEN WHERE gn-ven.codcia = s-codcia
          AND gn-ven.codven = B-CDOCU.codven
          NO-LOCK NO-ERROR.
      IF AVAILABLE GN-VEN THEN ccbcdocu.cco = gn-ven.cco.
  END.

  RUN Genera-Detalle.   

  RUN vta2/actualiza-cot-por-devolucion (ROWID(Ccbcdocu), -1).
  IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
  
  RUN Graba-Totales.

  /* GENERACION DE CONTROL DE PERCEPCIONES */
  RUN vta2/control-percepcion-abonos (ROWID(Ccbcdocu)) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
  /* ************************************* */

  /* RHC 02-07-2012 ASIENTO DE TRANSFERENCIA PARA SPEED */
  /*RUN aplic/sypsa/registroventas (INPUT ROWID(ccbcdocu), INPUT "I", YES).*/
  /* ************************************************** */
  
  /* AQUI DEBE IR LA RUTINA PARA MIGRAR A SUNAT */
  /* ****************************************** */


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
  RUN Procesa-Handle IN lh_handle ("Enable-Head").

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
  MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
  RETURN 'ADM-ERROR'.
  
  
  IF CcbCDocu.FlgEst = "A" THEN DO:
      MESSAGE 'El documento se encuentra anulado...' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
  END.
  IF CcbCDocu.SdoAct < CcbCDocu.ImpTot  THEN DO:
      MESSAGE 'El documento registra amortizaciones...' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
  END.
  IF CcbCDocu.CndCre <> 'D' THEN DO:
      MESSAGE 'El documento no corresponde a devolucion de mercaderia' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
  END.
  /* documento con canje de letras pendiente de aprobar */
  IF Ccbcdocu.flgsit = 'X' THEN DO:
      MESSAGE 'Documento con canje por letra pendiente de aprobar' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  /* consistencia de la fecha del cierre del sistema */
  IF s-user-id <> "ADMIN" THEN DO:
      DEF VAR dFchCie AS DATE.
      RUN gn/fecha-de-cierre (OUTPUT dFchCie).
      IF ccbcdocu.fchdoc <= dFchCie THEN DO:
          MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
              VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.
      /* RHC CONSISTENCIA SOLO PARA TIENDAS UTILEX */
      FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK.
      IF GN-DIVI.CanalVenta = "MIN" 
/*       IF LOOKUP(s-coddiv, '00023,00027,00501,00502,00503,00504,00505,00506,00507,00508') > 0 */
           AND Ccbcdocu.fchdoc < TODAY
           THEN DO:
           MESSAGE 'Solo se pueden anular documentos del día'
               VIEW-AS ALERT-BOX ERROR.
           RETURN 'ADM-ERROR'.
      END.
      /* fin de consistencia */
      {adm/i-DocPssw.i ccbcdocu.CodCia ccbcdocu.CodDoc ""DEL""}
  END.

  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
       /* Motivo de anulacion */
       DEF VAR cReturnValue AS CHAR NO-UNDO.
       RUN ccb/d-motanu (ccbcdocu.codcia, ccbcdocu.coddoc, ccbcdocu.nrodoc, s-user-id, OUTPUT cReturnValue).
       IF cReturnValue = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
       /* ******************* */

       RUN vta2/actualiza-cot-por-devolucion (ROWID(Ccbcdocu), +1).
       IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".

       /* EXTORNA CONTROL DE PERCEPCIONES POR ABONOS */
       FOR EACH B-CDOCU WHERE B-CDOCU.codcia = Ccbcdocu.codcia
           AND B-CDOCU.coddiv = Ccbcdocu.coddiv
           AND B-CDOCU.coddoc = "PRA"
           AND B-CDOCU.codref = Ccbcdocu.coddoc
           AND B-CDOCU.nroref = Ccbcdocu.nrodoc:
           DELETE B-CDOCU.
       END.
       /* ****************************************** */
       
       /*RUN Borra-Documento.   */

       FIND B-CDOCU WHERE ROWID(B-CDOCU) = ROWID(CcbCDocu) NO-ERROR.
       IF AVAILABLE B-CDOCU THEN 
           ASSIGN 
           CcbCDocu.FlgEst = "A"
           CcbCDocu.SdoAct = 0 
           CcbCDocu.Glosa  = '**** Documento Anulado ****'
           CcbCDocu.UsuAnu = S-USER-ID.
       FIND Almcmov WHERE Almcmov.CodCia = CcbCDocu.CodCia
           AND  Almcmov.CodAlm = CcbCDocu.CodAlm 
           AND  Almcmov.TipMov = "I"
           AND  Almcmov.CodMov = CcbCDocu.CodMov 
           AND  Almcmov.NroDoc = INTEGER(CcbCDocu.NroPed)
           NO-ERROR.
       ASSIGN Almcmov.FlgEst = "P".
       /* *************** ANULAMOS LA N/C EN EL SPEED **************** */
       RUN sypsa/anular-comprobante (ROWID(Ccbcdocu)).
       IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
       /* ************************************************************ */
       RELEASE B-CDOCU.
       RELEASE Almcmov.
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
  IF NOT AVAILABLE Ccbcdocu THEN RETURN 'ADM-ERROR'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      RUN gn/fFlgEstCCB (Ccbcdocu.flgest, OUTPUT FILL-IN-Estado).
      DISPLAY FILL-IN-Estado.

      FIND gn-ConVt WHERE gn-ConVt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
      IF AVAILABLE gn-ConVt THEN DISPLAY gn-ConVt.Nombr @ FILL-IN-FmaPgo.
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
          CcbCDocu.NroDoc:SENSITIVE = NO
          CcbCDocu.FchDoc:SENSITIVE = NO
          CcbCDocu.FchVto:SENSITIVE = NO
          CcbCDocu.CodCli:SENSITIVE = NO
          CcbCDocu.RucCli:SENSITIVE = NO
          CcbCDocu.CodAnt:SENSITIVE = NO
          CcbCDocu.NomCli:SENSITIVE = NO
          CcbCDocu.DirCli:SENSITIVE = NO
          CcbCDocu.CodRef:SENSITIVE = NO
          CcbCDocu.NroRef:SENSITIVE = NO
          CcbCDocu.CodMon:SENSITIVE = NO
          CcbCDocu.FmaPgo:SENSITIVE = NO
          CcbCDocu.NroOrd:SENSITIVE = NO
          CcbCDocu.UsuAnu:SENSITIVE = NO
          CcbCDocu.usuario:SENSITIVE = NO.
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
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse'). 
  RUN Procesa-Handle IN lh_handle ("Enable-Head").
  IF AVAILABLE(Almcmov) THEN RELEASE Almcmov.
  IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
  
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
     FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                    AND  FacCorre.CodDoc = S-CODDOC 
                    AND  FacCorre.CodDiv = S-CODDIV 
                    AND  FacCorre.NroSer = s-NroSer
                   EXCLUSIVE-LOCK NO-ERROR.
  ELSE
     FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                    AND  FacCorre.CodDoc = S-CODDOC 
                    AND  FacCorre.CodDiv = S-CODDIV 
                    AND  FacCorre.NroSer = s-NroSer
                   NO-LOCK NO-ERROR.
  IF AVAILABLE FacCorre THEN DO:      
     ASSIGN I-NroDoc = FacCorre.Correlativo.
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
DO WITH FRAME {&FRAME-NAME}:
    RUN vtagn/p-gn-clie-01 (Ccbcdocu.CodCli:SCREEN-VALUE , s-coddoc).
    IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = Ccbcdocu.codcli:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN DO:
        MESSAGE 'Cliente No registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.codcli.
        RETURN 'ADM-ERROR'.
    END.

    FIND B-CDOCU WHERE B-CDOCU.codcia = s-codcia
        AND B-CDOCU.coddoc = INPUT CcbCDocu.CodRef
        AND B-CDOCU.nrodoc = INPUT CcbCDocu.NroRef
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CDOCU THEN DO:
        MESSAGE 'Documento de Referencia NO registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.nroref.
        RETURN 'ADM-ERROR'.
    END.
    IF B-CDOCU.codcli <> INPUT CcbCDocu.CodCli THEN DO:
        MESSAGE 'Documento de referencia NO pertenece al cliente' VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.nroref.
        RETURN 'ADM-ERROR'.
    END.

    IF CcbCDocu.CodCli:SCREEN-VALUE = s-ClienteGenerico AND LENGTH(CcbCDocu.CodAnt:SCREEN-VALUE) <> 8 
        THEN DO:
        MESSAGE 'Debe ingresar el DNI' VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO CcbCDocu.CodAnt.
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
IF NOT AVAILABLE CcbCDocu THEN RETURN "ADM-ERROR".
MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
RETURN 'ADM-ERROR'. /* No se puede realizar modificaciones */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

