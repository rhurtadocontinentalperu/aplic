&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDocu FOR CcbCDocu.
DEFINE BUFFER B-DDocu FOR CcbDDocu.
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.



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

&SCOPED-DEFINE ARITMETICA-SUNAT YES

/* Parameters Definitions ---                                           */

/* Shared Variable Definitions ---                                       */

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE cl-codcia  AS INT.
/* DEFINE SHARED VARIABLE s-codalm   AS CHAR. */
DEFINE SHARED TEMP-TABLE DETA LIKE CcbDDocu.
DEFINE SHARED VARIABLE S-NROSER   AS INT.
DEFINE SHARED VARIABLE s-CndCre AS CHAR.
DEFINE SHARED VARIABLE s-TpoFac AS CHAR.
DEFINE SHARED VARIABLE s-Tipo   AS CHAR.
DEFINE SHARED VARIABLE s-CodTer AS CHAR.

DEFINE SHARED VARIABLE S-PORDTO AS DEC.
DEFINE SHARED VARIABLE S-PORIGV AS DEC. 
DEFINE SHARED VARIABLE s-Sunat-Activo AS LOG INIT NO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
/* DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO. */
DEFINE VARIABLE I-NRODOC       AS INTEGER   NO-UNDO.
DEFINE VARIABLE R-NRODEV       AS ROWID     NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE S-CODCLI       AS CHARACTER NO-UNDO. 
DEFINE VARIABLE R-ROWID        AS ROWID     NO-UNDO. 

DEFINE VARIABLE s-CodCta AS CHAR NO-UNDO.
/* Conceptos:
    00004: dev de mercaderia 
    00005: anulación de factura 
    */


/* FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND */
/*      FacCorre.CodDoc = S-CODDOC AND                      */
/*      FacCorre.CodDiv = S-CODDIV AND                      */
/*      FacCorre.CodAlm = s-CodAlm AND                      */
/*      FacCorre.FlgEst = YES NO-LOCK NO-ERROR.             */
/* IF AVAILABLE FacCorre THEN                               */
/*    ASSIGN I-NroSer = FacCorre.NroSer.                    */

DEF VAR s-ClienteGenerico AS CHAR INIT '11111111111' NO-UNDO.

FIND FIRST FacCfgGn  WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
IF AVAILABLE FacCfgGn THEN s-ClienteGenerico = FacCfgGn.CliVar.

  /* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
  DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.
  RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).

DEF VAR pMensaje AS CHAR NO-UNDO.

/* ICBPER */
DEFINE VAR x-articulo-ICBPER AS CHAR.

x-articulo-ICBPER = '099268'.

/* DEFINE VAR x-nueva-arimetica-sunat-2021 AS LOG. */
/*                                                 */
/* x-nueva-arimetica-sunat-2021 = YES.             */
/*                                                 */

DEFINE VAR x-tabla AS CHAR INIT "CONFIG-VTAS".
DEFINE VAR x-codigo AS CHAR INIT "PI.NO.VALIDAR.N/C".
DEFINE BUFFER x-vtatabla FOR vtatabla.

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
CcbCDocu.FchVto CcbCDocu.RucCli CcbCDocu.CodCli CcbCDocu.CodAnt ~
CcbCDocu.usuario CcbCDocu.NomCli CcbCDocu.DirCli CcbCDocu.CodRef ~
CcbCDocu.NroRef CcbCDocu.CodMon CcbCDocu.FmaPgo CcbCDocu.Glosa 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.NroOrd CcbCDocu.FchVto CcbCDocu.RucCli CcbCDocu.CodCli ~
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
          LABEL "Correlativo" FORMAT "X(12)"
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
     CcbCDocu.RucCli AT ROW 2.69 COL 35 COLON-ALIGNED WIDGET-ID 186
          VIEW-AS FILL-IN 
          SIZE 16 BY .81
     CcbCDocu.CodCli AT ROW 2.73 COL 15 COLON-ALIGNED WIDGET-ID 156
          VIEW-AS FILL-IN 
          SIZE 15.43 BY .81
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
                     "FAI","FAI"
          DROP-DOWN-LIST
          SIZE 12 BY 1
     CcbCDocu.NroRef AT ROW 5.04 COL 35 COLON-ALIGNED WIDGET-ID 184
          LABEL "Número" FORMAT "X(12)"
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
     "..." VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 6.58 COL 90 WIDGET-ID 196
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
      TABLE: B-DDocu B "?" ? INTEGRAL CcbDDocu
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
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
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.NroOrd IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NroRef IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
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


&Scoped-define SELF-NAME CcbCDocu.CodRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodRef V-table-Win
ON VALUE-CHANGED OF CcbCDocu.CodRef IN FRAME F-Main /* Referencia */
DO:
  
  IF SELF:SCREEN-VALUE = 'FAC' THEN 
      ASSIGN
      CcbCDocu.NomCli:SENSITIVE = NO
      CcbCDocu.DirCli :SENSITIVE = NO
      CcbCDocu.CodAnt:SENSITIVE = NO.
  ELSE ASSIGN 
      CcbCDocu.NomCli:SENSITIVE = YES
      CcbCDocu.DirCli :SENSITIVE = YES
      CcbCDocu.CodAnt:SENSITIVE = YES.
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

    DEFINE VAR x-nuevo-preuni AS DEC.
    DEFINE VAR x-nuevo-implin AS DEC.
    DEFINE VAR x-nuevo-igv AS DEC.

   DEF VAR x-Items AS INT NO-UNDO.
   FOR EACH DETA BY DETA.NroItm:
       x-Items = x-Items + 1.
       CREATE CcbDDocu.
       ASSIGN 
           CcbDDocu.NroItm = x-Items
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
           CcbDDocu.PorDto = 0  /*DETA.PorDto */
           CcbDDocu.PreBas = DETA.PreBas 
           CcbDDocu.ImpDto = 0  /*DETA.ImpDto*/
           CcbDDocu.AftIgv = DETA.AftIgv
           CcbDDocu.AftIsc = DETA.AftIsc
           CcbDDocu.UndVta = DETA.UndVta
           CcbDDocu.Por_Dsctos[1] = 0 /*DETA.Por_Dsctos[1]*/
           CcbDDocu.Por_Dsctos[2] = 0 /*DETA.Por_Dsctos[2]*/
           CcbDDocu.Por_Dsctos[3] = 0 /*DETA.Por_Dsctos[3]*/
           CcbDDocu.Flg_factor = DETA.Flg_factor
           CcbDDocu.ImpCto     = DETA.ImpCto.
   END.

   /* ************************************* */
/* 06/09/2022: SI la devolución es total */
/* ************************************* */
&IF {&ARITMETICA-SUNAT} &THEN
    FOR EACH B-DDOCU OF B-CDOCU NO-LOCK:
        FIND DETA WHERE DETA.codmat = B-DDOCU.codmat NO-ERROR.
        IF NOT AVAILABLE DETA OR B-DDOCU.candes <> DETA.candes THEN RETURN.
    END.
    /*
    /* Reagrabamos importes - cuando la devolucion es total */
    FOR EACH Ccbddocu OF Ccbcdocu EXCLUSIVE-LOCK,
        FIRST B-DDOCU OF B-CDOCU NO-LOCK WHERE B-DDOCU.codmat = Ccbddocu.codmat:

        x-nuevo-preuni = ROUND((B-DDOCU.implin - B-DDOCU.impdto2) / B-DDOCU.candes,4).
        x-nuevo-implin = ROUND(CcbDDocu.CanDes * x-nuevo-preuni,4).
        x-nuevo-igv = B-DDOCU.ImpIgv.

        ASSIGN
            Ccbddocu.preuni = x-nuevo-preuni.
        /*
        ASSIGN
            Ccbddocu.preuni = B-DDOCU.ImporteUnitarioConImpuesto
            Ccbddocu.implin = B-DDOCU.cImporteTotalConImpuesto
            Ccbddocu.impigv = B-DDOCU.ImporteTotalImpuestos.
        */
    END.
    */
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Temp-FeLogErrores V-table-Win 
PROCEDURE Graba-Temp-FeLogErrores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH T-FeLogErrores:
    CREATE FeLogErrores.
    BUFFER-COPY T-FeLogErrores TO FeLogErrores NO-ERROR.
    DELETE T-FeLogErrores.
END.
IF AVAILABLE(FeLogErrores) THEN RELEASE FeLogErrores.

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
    
    DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    /*{vta/graba-totales-abono.i} */

    {vtagn/i-total-factura-sunat.i &Cabecera="Ccbcdocu" &Detalle="Ccbddocu"}

    /* Ic - 16Nov2021 - Arimetica de Sunat */
    &IF {&ARITMETICA-SUNAT} &THEN
        DEF VAR hxProc AS HANDLE NO-UNDO.
        RUN sunat/sunat-calculo-importes.r PERSISTENT SET hxProc.
        RUN tabla-ccbcdocu IN hxProc (INPUT Ccbcdocu.CodDiv,
                                     INPUT Ccbcdocu.CodDoc,
                                     INPUT Ccbcdocu.NroDoc,
                                     OUTPUT pMensaje).
        DELETE PROCEDURE hxProc.
        IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
    &ENDIF
    
/*     IF x-nueva-arimetica-sunat-2021 = YES THEN DO:                   */
/*         DEF VAR hxProc AS HANDLE NO-UNDO.                            */
/*         RUN sunat/sunat-calculo-importes.r PERSISTENT SET hxProc.    */
/*         RUN tabla-ccbcdocu IN hxProc (INPUT Ccbcdocu.CodDiv,         */
/*                                      INPUT Ccbcdocu.CodDoc,          */
/*                                      INPUT Ccbcdocu.NroDoc,          */
/*                                      OUTPUT pMensaje).               */
/*         DELETE PROCEDURE hxProc.                                     */
/*         IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'. */
/*     END.                                                             */
    
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

  DEFINE VAR x-impte AS DEC.
  DEFINE VAR x-impte-QR AS DEC.
  DEFINE VAR x-impte-devolucion AS DEC.

  DEFINE VAR x-factor-aplicado-anticipo AS DEC.
  DEFINE VAR x-impte-tot-comprobante AS DEC.
  DEFINE VAR x-impte-cmpte-referenciado AS DEC.
  DEFINE VAR x-porcentaje-devol AS DEC.
  DEFINE VAR x-diferencia AS DEC.
  DEFINE VAR x-dev-total AS LOG.

  DEFINE VAR x-nuevo-preuni AS DEC.
  DEFINE VAR x-nuevo-implin AS DEC.

  DEFINE VAR x-valida-nc AS LOG.
  
  /* Code placed here will execute PRIOR to standard behavior. */
  IF s-TpoFac = "LI" THEN RETURN 'ADM-ERROR'.   /* NO Logística Inversa */

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

  /* Ic - 04Nov2016 */
  IF s-CodDoc = 'NCI' THEN DO:
      FIND Almcmov WHERE ROWID(Almcmov) = output-var-1 NO-LOCK.
      IF Almcmov.codref <> 'FAI' THEN DO:
          MESSAGE 'Seleccione documentos FAIs' VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.
  END.
  IF s-CodDoc = 'NC' OR s-CodDoc = 'N/C' THEN DO:
      FIND Almcmov WHERE ROWID(Almcmov) = output-var-1 NO-LOCK.
      IF Almcmov.codref <> 'FAC' AND Almcmov.codref <> 'BOL' THEN DO:
          MESSAGE 'Seleccione documentos FAC o BOL' VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.

      /*  */
      FIND Almcmov WHERE ROWID(Almcmov) = output-var-1 NO-LOCK.
      FIND B-CDOCU WHERE B-CDOCU.codcia = s-codcia
          AND B-CDOCU.coddoc = Almcmov.codref
          AND B-CDOCU.nrodoc = Almcmov.nroref
          NO-LOCK.
      IF NOT AVAILABLE B-CDOCU THEN DO:
          MESSAGE 'NO existe el documento ' + Almcmov.codref + " " + Almcmov.nroref 
              VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.

      /* Que no supere el monto - Ic 07Jun2021 */
      FOR EACH Almdmov NO-LOCK WHERE Almdmov.CodCia = Almcmov.CodCia 
          AND  Almdmov.CodAlm = Almcmov.CodAlm 
          AND  Almdmov.TipMov = Almcmov.TipMov 
          AND  Almdmov.CodMov = Almcmov.CodMov 
          AND  Almdmov.NroDoc = Almcmov.NroDoc:
          /* Ic - 14Nov2022, verificar si el producto  */
          FIND CcbDDocu WHERE CcbDDocu.codcia = s-codcia 
              AND CcbDDocu.CodDiv = S-CODDIV
              AND CcbDDocu.CodDoc = Almcmov.CodRef 
              AND CcbDDocu.NroDoc = Almcmov.NroRf1 
              AND CcbDDocu.CodMat = Almdmov.codMat
              USE-INDEX LLAVE04 NO-LOCK NO-ERROR.
          x-nuevo-implin = 0.
          IF AVAILABLE CcbDDocu THEN DO: 
              IF CcbDDocu.candes > 0 THEN DO:
                  x-nuevo-preuni = ROUND((CcbDDocu.implin - CcbDDocu.impdto2) / CcbDDocu.candes,4).
                  x-nuevo-implin = ROUND(x-nuevo-preuni * Almdmov.CanDes,2).
              END.
          END.
          
          /*x-impte-devolucion = x-impte-devolucion + AlmDMov.ImpLin.*/
          x-impte-devolucion = x-impte-devolucion + x-nuevo-implin.
      END.

        DEFINE VAR hxProc AS HANDLE NO-UNDO.            /* Handle Libreria */
        
        RUN ccb\libreria-ccb.r PERSISTENT SET hxProc.
                                                         
        RUN sumar-imptes-nc_ref-cmpte IN hxProc (INPUT "*",     /* Algun concepto o todos */
                                                INPUT B-CDocu.CodDoc, 
                                                INPUT B-CDocu.NroDoc,
                                                OUTPUT x-impte).
        
        DELETE PROCEDURE hxProc.                        /* Release Libreria */

        x-impte-cmpte-referenciado = B-CDOCU.imptot.        
        x-impte-QR = 0.

        /* Ic - 15Dic2021 - Verificamos si tiene A/C para sacar le importe real del comprobante */
        IF B-CDocu.imptot2 > 0 THEN DO:
            
            FIND FIRST FELogComprobantes WHERE FELogComprobantes.codcia = s-codcia AND
                                            FELogComprobantes.coddoc = B-CDOCU.coddoc AND
                                            FELogComprobantes.nrodoc = B-CDOCU.nrodoc NO-LOCK NO-ERROR.
            IF AVAILABLE FELogComprobantes THEN DO:
                IF NUM-ENTRIES(FELogComprobantes.dataQR,"|") > 5 THEN DO:
                    x-impte-cmpte-referenciado = DEC(TRIM(ENTRY(6,FELogComprobantes.dataQR,"|"))).
                    x-impte-QR = x-impte-cmpte-referenciado.
                END.
            END.
            IF x-impte-cmpte-referenciado <= 0 THEN DO:
                x-impte-cmpte-referenciado = B-CDOCU.TotalPrecioVenta.
            END.
        END.
        x-porcentaje-devol = ROUND(x-impte-devolucion / x-impte-cmpte-referenciado,4).

        IF x-impte =  0 AND x-porcentaje-devol = 1 THEN DO:
            /* Por la Arimetica de Sunat el PI = pueder 23.93 y el comprobante 23.90 */
        END.
        ELSE DO:

           x-valida-nc = YES.
           /* Ic - Excepciones 12Jul2021 si el comprobante esta exceptuado de validar - correo de Mayra */
           FIND FIRST x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                                       x-vtatabla.tabla = x-tabla AND
                                       x-vtatabla.llave_c1 = x-codigo AND
                                       x-vtatabla.llave_c2 = B-CDOCU.coddoc AND
                                       x-vtatabla.llave_c3 = B-CDOCU.nrodoc NO-LOCK NO-ERROR.
        
           IF AVAILABLE x-vtatabla THEN x-valida-nc = NO.

            IF x-valida-nc = YES THEN DO:

                x-diferencia = (x-impte + x-impte-devolucion) - x-impte-cmpte-referenciado.

                /*IF (x-impte + x-impte-devolucion) - x-impte-cmpte-referenciado > 0.05 THEN DO:*/
                /* X la aritmetica de SUNAT */
                IF x-diferencia > 0.09 THEN DO:
                    MESSAGE "Existen N/Cs emitidas referenciando al comprobante" SKIP 
                            B-CDocu.CodDoc + " " + B-CDocu.NroDoc + " y cuya suma de sus importes" SKIP
                            "superan a dicho comprobante" SKIP
                            "-----------------------------------------" SKIP
                            "Importe Comprobante : " + STRING(x-impte-cmpte-referenciado) SKIP
                            "Importe Devolucion : " + string(x-impte-devolucion) SKIP
                            "Importes N/Cs : " + STRING(x-impte) SKIP 
                            "Importe A/C : " + STRING(B-CDocu.imptot2) SKIP
                            "importe QR : " + STRING(x-impte-QR)
                        VIEW-AS ALERT-BOX INFORMATION.
                    RETURN "ADM-ERROR".
                END.
            END.
        END.
  END.
  /* Ic - 04Nov2016 - FIN */

  ASSIGN
      s-PorIgv = FacCfgGn.PorIgv
      s-PorDto = 0.
      /*i-nroser = s-nroser.*/

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
          STRING(FacCorre.nroSer, ENTRY(1,x-Formato,'-')) + STRING(FacCorre.Correlativo, ENTRY(2,x-Formato,'-')) @  CcbCDocu.NroDoc

          TODAY @ CcbCDocu.FchDoc 
          TODAY @ CcbCDocu.FchVto
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
              DETA.Por_Dsctos[1] = 0 /*Almdmov.Por_Dsctos[1]*/
              DETA.Por_Dsctos[2] = 0 /*Almdmov.Por_Dsctos[2]*/
              DETA.Por_Dsctos[3] = 0 /* Almdmov.Por_Dsctos[3]*/
              DETA.Flg_factor = Almdmov.Flg_factor.
          /*************Grabando Costos ********************/
          FIND CcbDDocu WHERE CcbDDocu.codcia = s-codcia 
              AND CcbDDocu.CodDiv = S-CODDIV
              AND CcbDDocu.CodDoc = Almcmov.CodRef 
              AND CcbDDocu.NroDoc = Almcmov.NroRf1 
              AND CcbDDocu.CodMat = Almdmov.codMat
              USE-INDEX LLAVE04 NO-LOCK NO-ERROR.
          IF AVAILABLE CcbDDocu THEN DO: 
              x-nuevo-preuni = ROUND((CcbDDocu.implin - CcbDDocu.impdto2) / CcbDDocu.candes,4).
              ASSIGN DETA.PreUni = x-nuevo-preuni 
                        DETA.ImpLin = ROUND(x-nuevo-preuni * DETA.CanDes,2).
              DETA.ImpCto = CcbDDocu.ImpCto * ( ( DETA.Candes * DETA.Factor ) / (CcbDDocu.Candes * CcbDDocu.Factor) ). 
          END.
      END.
      /*
      x-dev-total = YES.
      FOR EACH B-DDOCU OF B-CDOCU NO-LOCK:
          FIND DETA WHERE DETA.codmat = B-DDOCU.codmat NO-ERROR.
          IF NOT AVAILABLE DETA OR B-DDOCU.candes <> DETA.candes THEN DO:
                x-dev-total = NO.
                EXIT.
          END.
      END.
      */

      APPLY 'LEAVE':U TO CcbCDocu.CodCli.
      APPLY 'LEAVE':U TO CcbCDocu.FmaPgo.
  END.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('Browse').
  APPLY 'VALUE-CHANGED':U TO CcbCDocu.CodRef IN FRAME {&FRAME-NAME}.

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
  /* RHC 22/11/2016  Bloqueamos de todas maneras el movimiento de almacén */
  FIND Almcmov WHERE ROWID(Almcmov) = R-NRODEV  EXCLUSIVE-LOCK NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
      pMensaje = 'Movimiento de Ingreso al Almacén en uso por otro usuario'.
      UNDO, RETURN 'ADM-ERROR'.
  END.
  IF Almcmov.FlgEst <> "P" THEN DO:
      pMensaje = 'Movimiento de Ingreso al Almacén ha sido modificado por otro usuario' + CHR(10) +
          'Proceso Abortado'.
      UNDO, RETURN 'ADM-ERROR'.
  END.
  /* Bloqueamos Correlativo */
  {lib/lock-genericov3.i ~
      &Tabla="FacCorre" ~
      &Condicion="FacCorre.CodCia = s-codcia ~
      AND FacCorre.CodDiv = s-coddiv ~
      AND FacCorre.CodDoc = s-coddoc ~
      AND FacCorre.NroSer = s-nroser" ~
      &Bloqueo="EXCLUSIVE-LOCK" ~
      &Accion="RETRY" ~
      &Mensaje="YES" ~
      &txtMensaje="pMensaje" ~
      &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
      }

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
  ASSIGN 
      CcbCDocu.CodCia = S-CODCIA
      CcbCDocu.CodDiv = S-CODDIV
      CcbCDocu.CodDoc = S-CODDOC
      CcbCDocu.NroDoc = STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-')) + STRING(FacCorre.Correlativo,ENTRY(2,x-Formato,'-')) 
      CcbCDocu.FchDoc = TODAY
      CcbCDocu.FchVto = ADD-INTERVAL (TODAY, 1, 'years')
      CcbCDocu.FlgEst = "P"
      CcbCDocu.PorIgv = s-PorIgv
      CcbCDocu.PorDto = S-PORDTO
      CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
      CcbCDocu.CndCre = s-CndCre     /* POR DEVOLUCION */
      CcbCDocu.TpoFac = s-TpoFac
      CcbCDocu.Tipo   = s-Tipo
      CcbCDocu.CodCaja= s-CodTer
      CcbCDocu.usuario = S-USER-ID
      CcbCDocu.SdoAct = CcbCDocu.Imptot
      NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
      IF ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
          pMensaje = ERROR-STATUS:GET-MESSAGE(1).
          DO ix = 2 TO ERROR-STATUS:NUM-MESSAGES:
              pMensaje = pMensaje + CHR(10) + ERROR-STATUS:GET-MESSAGE(ix).
          END.
      END.
      UNDO, RETURN 'ADM-ERROR'.
  END.
  /* Control de Aprobación de N/C */
  RUN lib/LogTabla ("ccbcdocu",
                    ccbcdocu.coddoc + ',' + ccbcdocu.nrodoc,
                    "APROBADO").
  /* **************************** */
  ASSIGN 
      FacCorre.Correlativo = FacCorre.Correlativo + 1.
  ASSIGN 
      CcbCDocu.CodAlm = Almcmov.CodAlm
      CcbCDocu.CodMov = Almcmov.CodMov
      CcbCDocu.CodVen = Almcmov.CodVen
      CcbCDocu.NroPed = STRING(Almcmov.NroDoc)
      CcbCDocu.NroOrd = Almcmov.NroRf2.
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
  IF RETURN-VALUE = "ADM-ERROR" THEN DO:
      pMensaje = "NO se pudo actualizar la cotización" + CHR(10) +
                "Proceso Abortado".
      UNDO, RETURN "ADM-ERROR".
  END.
  
  RUN Graba-Totales (OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-EROR' THEN UNDO, RETURN 'ADM-ERROR'.

  FIND FIRST B-CDOCU WHERE B-CDOCU.codcia = s-codcia
      AND B-CDOCU.coddoc = ccbcdocu.codref
      AND B-CDOCU.nrodoc = ccbcdocu.nroref 
      NO-LOCK NO-ERROR.
  IF B-CDOCU.ImpTot = Ccbcdocu.ImpTot THEN s-CodCta = '00005'.
  ELSE s-CodCta = '00004'.
  ASSIGN
      Ccbcdocu.CodCta = s-CodCta.

  

  /*
    Ic - 24Ago2020, Correo de Julissa del 21 de Agosto del 2020
    
        Al momento que el area de credito genere la NCI, y referencie el FAI, EN AUTOMÁTICO quedarán liquidados ambos documentos,
        Con esta nueva operativa minimizamos el tiempo en las liquidaciones        
  */

   DEFINE VAR hProc AS HANDLE NO-UNDO.          /* Handle Libreria */
   DEFINE VAR cRetVal AS CHAR.

   RUN ccb\libreria-ccb.r PERSISTENT SET hProc.

   /* Procedimientos */
   RUN CCB_Aplica-NCI IN hProc (INPUT CcbCDocu.coddoc, INPUT CcbCDocu.nrodoc, OUTPUT cRetVal).   

   DELETE PROCEDURE hProc.                      /* Release Libreria */

   IF cRetVal <> "" THEN DO:
       MESSAGE "Hubo problemas en la grabacion " SKIP
                cRetval VIEW-AS ALERT-BOX INFORMATION.
       UNDO, RETURN 'ADM-ERROR'.
   END.


  /* ********************************************************************** */
  /* RHC 17/07/17 OJO: Hay una condición de error el el trigger w-almcmov.p */
  /* ********************************************************************** */
  ASSIGN 
      Almcmov.FlgEst = "C".
  RELEASE Almcmov.  /* Forzamos la ejecución del Trigger WRITE */
  /* ********************************************************************** */

  /* GENERACION DE CONTROL DE PERCEPCIONES */
  RUN vta2/control-percepcion-abonos (ROWID(Ccbcdocu)) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
  /* ************************************* */

  /* ************************************************** */
  /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
  RUN sunat\progress-to-ppll-v3  ( INPUT Ccbcdocu.coddiv,
                                   INPUT Ccbcdocu.coddoc,
                                   INPUT Ccbcdocu.nrodoc,
                                   INPUT-OUTPUT TABLE T-FELogErrores,
                                   OUTPUT pMensaje ).
  IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
  IF RETURN-VALUE = 'ERROR-EPOS' THEN DO:
      /* NO se pudo confirmar el comprobante en el e-pos */
      /* Se procede a ANULAR el comprobante              */
      pMensaje = pMensaje + CHR(10) +
          "Se procede a anular el comprobante: " + Ccbcdocu.coddoc + " " + Ccbcdocu.nrodoc + CHR(10) +
          "Salga del sistema, vuelva a entra y vuelva a intentarlo".
      ASSIGN
          CcbCDocu.FchAnu = TODAY
          CcbCDocu.FlgEst = "A"
          CcbCDocu.SdoAct = 0
          CcbCDocu.UsuAnu = s-user-id.
      FIND Almcmov WHERE ROWID(Almcmov) = R-NRODEV  EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE Almcmov THEN Almcmov.FlgEst = "P".
      RUN vta2/actualiza-cot-por-devolucion (ROWID(Ccbcdocu), +1).
      /* EXTORNA CONTROL DE PERCEPCIONES POR ABONOS */
      FOR EACH B-CDOCU WHERE B-CDOCU.codcia = Ccbcdocu.codcia
          AND B-CDOCU.coddiv = Ccbcdocu.coddiv
          AND B-CDOCU.coddoc = "PRA"
          AND B-CDOCU.codref = Ccbcdocu.coddoc
          AND B-CDOCU.nroref = Ccbcdocu.nrodoc:
          DELETE B-CDOCU.
      END.
  END.
  /* *********************************************************** */
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse'). 
  RUN Procesa-Handle IN lh_handle ("Enable-Head").

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
  /* ********************************************* */
  /* Inicio de actividades facturación electrónica */
  /* ********************************************* */
  IF s-user-id <> 'ADMIN' AND s-Sunat-Activo = YES THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  /* ********************************************* */
  
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
/*           CcbCDocu.CodAnt:SENSITIVE = NO */
/*           CcbCDocu.NomCli:SENSITIVE = NO */
/*           CcbCDocu.DirCli:SENSITIVE = NO */
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
  IF CCBCDOCU.FLGEST <> "A" THEN DO:
      IF s-Sunat-Activo = YES  THEN DO:
          /* Ic - 27Dic2017, impresion QR */

          DEFINE BUFFER x-gn-divi FOR gn-divi.

          FIND FIRST x-gn-divi OF ccbcdocu NO-LOCK NO-ERROR.
          /* Division apta para impresion QR */
          IF AVAILABLE x-gn-divi AND x-gn-divi.campo-log[7] = YES THEN DO:

            DEFINE VAR x-version AS CHAR.
            DEFINE VAR x-formato-tck AS LOG.
            DEFINE VAR x-Imprime-directo AS LOG.
            DEFINE VAR x-nombre-impresora AS CHAR.

            x-version = 'L'.
            x-formato-tck = NO.        /* YES : Formato Ticket,  NO : Formato A4 */
            x-imprime-directo = NO.
            x-nombre-impresora = "".

/*             DEF VAR answer AS LOGICAL NO-UNDO.             */
/*                 SYSTEM-DIALOG PRINTER-SETUP UPDATE answer. */
/*                 IF NOT answer THEN RETURN.                 */
/*                                                            */
/*             x-nombre-impresora = SESSION:PRINTER-NAME.     */

            &IF {&ARITMETICA-SUNAT} &THEN
                RUN sunat\r-impresion-doc-electronico-sunat.r (INPUT ccbcdocu.coddiv, 
                                                             INPUT ccbcdocu.coddoc, 
                                                             INPUT ccbcdocu.nrodoc,
                                                             INPUT x-version,
                                                             INPUT x-formato-tck,
                                                             INPUT x-imprime-directo,
                                                             INPUT x-nombre-impresora).
    
                x-version = 'A'.
                RUN sunat\r-impresion-doc-electronico-sunat.r (INPUT ccbcdocu.coddiv, 
                                                             INPUT ccbcdocu.coddoc, 
                                                             INPUT ccbcdocu.nrodoc,
                                                             INPUT x-version,
                                                             INPUT x-formato-tck,
                                                             INPUT x-imprime-directo,
                                                             INPUT x-nombre-impresora).
            &ELSE
                RUN sunat\r-impresion-doc-electronico.r (INPUT ccbcdocu.coddiv, 
                                                             INPUT ccbcdocu.coddoc, 
                                                             INPUT ccbcdocu.nrodoc,
                                                             INPUT x-version,
                                                             INPUT x-formato-tck,
                                                             INPUT x-imprime-directo,
                                                             INPUT x-nombre-impresora).
    
                x-version = 'A'.
                RUN sunat\r-impresion-doc-electronico.r (INPUT ccbcdocu.coddiv, 
                                                             INPUT ccbcdocu.coddoc, 
                                                             INPUT ccbcdocu.nrodoc,
                                                             INPUT x-version,
                                                             INPUT x-formato-tck,
                                                             INPUT x-imprime-directo,
                                                             INPUT x-nombre-impresora).
            &ENDIF
          END.
          ELSE DO:
              /* Matricial sin QR */
              RUN sunat\r-impresion-documentos-sunat ( ROWID(Ccbcdocu), "O", NO ).
          END.

          RELEASE x-gn-divi.          
      END.
      ELSE DO:
          CASE Ccbcdocu.coddiv:
              WHEN '00005' THEN RUN ccb/r-notcre00005 (ROWID(CCBCDOCU)).
              OTHERWISE RUN CCB\R-NOTCRE3 (ROWID(CCBCDOCU)).
          END CASE.
      END.
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
  EMPTY TEMP-TABLE T-FELogErrores.    /* CONTROL DE ERRORES DE FACTURACION ELECTRONICA */
  pMensaje = "".
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF pMensaje <> "" THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Graba-Temp-FeLogErrores.    /* Control de Errores (si es que hay) */
  IF AVAILABLE(Almcmov)  THEN RELEASE Almcmov.
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

    /* *********************************************************** */
    /* VALIDACION DE MONTO MINIMO POR BOLETA */
    /* *********************************************************** */
    IF Ccbcdocu.CodRef:SCREEN-VALUE = 'FAC' THEN CcbCDocu.CodAnt:SCREEN-VALUE = ''.
    DEF VAR cNroDni AS CHAR NO-UNDO.
    DEF VAR iLargo  AS INT NO-UNDO.
    DEF VAR cError  AS CHAR NO-UNDO.
    cNroDni = Ccbcdocu.CodAnt:SCREEN-VALUE.
    IF Ccbcdocu.CodRef:SCREEN-VALUE = 'BOL' THEN DO:
        RUN lib/_valid_number (INPUT-OUTPUT cNroDni, OUTPUT iLargo, OUTPUT cError).
        IF cError > '' OR iLargo <> 8 THEN DO:
            cError = cError + (IF cError > '' THEN CHR(10) ELSE '') +
                    "El DNI debe tener 8 números".
            MESSAGE cError VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO CcbCDocu.CodAnt.
            RETURN "ADM-ERROR".   
        END.
        IF TRUE <> (Ccbcdocu.NomCli:SCREEN-VALUE > '') THEN DO:
            MESSAGE "Debe ingresar el Nombre del Cliente" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO CcbCDocu.NomCli.
            RETURN "ADM-ERROR".   
        END.
        IF TRUE <> (Ccbcdocu.DirCli:SCREEN-VALUE > '') THEN DO:
            MESSAGE "Debe ingresar la Dirección del Cliente" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO CcbCDocu.DirCli.
            RETURN "ADM-ERROR".   
        END.
    END.
    /* *********************************************************** */
    /* *********************************************************** */


    IF CcbCDocu.CodRef:SCREEN-VALUE = "FAC" THEN DO:
        /* dígito verificador */
        DEF VAR pResultado AS CHAR NO-UNDO.
        RUN lib/_ValRuc (Ccbcdocu.RucCli:SCREEN-VALUE, OUTPUT pResultado).
        IF pResultado = 'ERROR' THEN DO:
            MESSAGE 'Código RUC MAL registrado' VIEW-AS ALERT-BOX WARNING.
            APPLY 'ENTRY':U TO Ccbcdocu.codcli.
            RETURN 'ADM-ERROR'.
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
IF NOT AVAILABLE CcbCDocu THEN RETURN "ADM-ERROR".
MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
RETURN 'ADM-ERROR'. /* No se puede realizar modificaciones */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

