&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER B-DDOCU FOR CcbDDocu.
DEFINE TEMP-TABLE DETA NO-UNDO LIKE CcbDDocu.
DEFINE TEMP-TABLE RowObject NO-UNDO
       {"aplic/ccb/dccbcdocu.i"}.
DEFINE BUFFER x-VtaTabla FOR VtaTabla.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*------------------------------------------------------------------------

  File:

  Description: from viewer.w - Template for SmartDataViewer objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
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

{src/adm2/widgetprto.i}

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-nroser AS INTE.
DEF SHARED VAR s-CndCre AS CHAR.
DEF SHARED VAR s-TpoFac AS CHAR.
DEF SHARED VAR s-Tipo   AS CHAR.

DEFINE VAR x-tabla AS CHAR INIT "CONFIG-VTAS".
DEFINE VAR x-codigo AS CHAR INIT "PI.NO.VALIDAR.N/C".
DEFINE VAR pMensaje AS CHAR NO-UNDO.

DEFINE SHARED VARIABLE S-PORIGV AS DEC. 
DEFINE SHARED VARIABLE S-PORDTO AS DEC.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VARIABLE s-NRODEV AS ROWID.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).

DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.

DEF VAR s-ClienteGenerico AS CHAR INIT '11111111111' NO-UNDO.

FIND FIRST FacCfgGn  WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
IF AVAILABLE FacCfgGn THEN s-ClienteGenerico = FacCfgGn.CliVar.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "aplic/ccb/dccbcdocu.i"

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.NroDoc RowObject.FchDoc ~
RowObject.usuario RowObject.NroOrd RowObject.NroPed RowObject.FchVto ~
RowObject.CodCli RowObject.RucCli RowObject.CodAnt RowObject.FchAnu ~
RowObject.UsuAnu RowObject.NomCli RowObject.DirCli RowObject.CodRef ~
RowObject.NroRef RowObject.CodMon RowObject.FmaPgo RowObject.CodCta ~
RowObject.Glosa 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define DISPLAYED-FIELDS RowObject.NroDoc RowObject.FchDoc ~
RowObject.usuario RowObject.NroOrd RowObject.NroPed RowObject.FchVto ~
RowObject.CodCli RowObject.RucCli RowObject.CodAnt RowObject.FchAnu ~
RowObject.UsuAnu RowObject.NomCli RowObject.DirCli RowObject.CodRef ~
RowObject.NroRef RowObject.CodMon RowObject.FmaPgo RowObject.CodCta ~
RowObject.Glosa 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-FmaPgo FILL-IN_CodCta 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-FmaPgo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 58 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodCta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 58 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RowObject.NroDoc AT ROW 1 COL 19 COLON-ALIGNED WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .81
     RowObject.FchDoc AT ROW 1 COL 97 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     RowObject.usuario AT ROW 1 COL 107 COLON-ALIGNED NO-LABEL WIDGET-ID 38
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     RowObject.NroOrd AT ROW 1.81 COL 19 COLON-ALIGNED WIDGET-ID 28
          LABEL "Nro. Ingreso"
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .81
     RowObject.NroPed AT ROW 1.81 COL 41 COLON-ALIGNED WIDGET-ID 30
          LABEL "PI"
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .81
     RowObject.FchVto AT ROW 1.81 COL 97 COLON-ALIGNED WIDGET-ID 18
          LABEL "Vencimiento"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     RowObject.CodCli AT ROW 2.62 COL 19 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 15.43 BY .81
     RowObject.RucCli AT ROW 2.62 COL 41 COLON-ALIGNED WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 15.43 BY .81
     RowObject.CodAnt AT ROW 2.62 COL 65 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .81
     RowObject.FchAnu AT ROW 2.62 COL 97 COLON-ALIGNED WIDGET-ID 14
          LABEL "Fecha Anulación" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     RowObject.UsuAnu AT ROW 2.62 COL 107 COLON-ALIGNED NO-LABEL WIDGET-ID 36
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     RowObject.NomCli AT ROW 3.42 COL 19 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 101.43 BY .81
     RowObject.DirCli AT ROW 4.23 COL 19 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 101.43 BY .81
     RowObject.CodRef AT ROW 5.04 COL 19 COLON-ALIGNED WIDGET-ID 46
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "FACTURA","FAC",
                     "BOLETA","BOL",
                     "FAI","FAI"
          DROP-DOWN-LIST
          SIZE 13 BY 1
     RowObject.NroRef AT ROW 5.04 COL 41 COLON-ALIGNED WIDGET-ID 32
          LABEL "Número"
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .81
     RowObject.CodMon AT ROW 5.04 COL 99 NO-LABEL WIDGET-ID 42
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dólares", 2
          SIZE 19 BY .81
     RowObject.FmaPgo AT ROW 5.85 COL 19 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     FILL-IN-FmaPgo AT ROW 5.85 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 174
     RowObject.CodCta AT ROW 6.65 COL 19 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     FILL-IN_CodCta AT ROW 6.65 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 184
     RowObject.Glosa AT ROW 7.46 COL 19 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 81.43 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "aplic\ccb\dccbcdocu.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: B-DDOCU B "?" ? INTEGRAL CcbDDocu
      TABLE: DETA T "?" NO-UNDO INTEGRAL CcbDDocu
      TABLE: RowObject D "?" NO-UNDO INTEGRAL CcbDDocu
      ADDITIONAL-FIELDS:
          {aplic/ccb/dccbcdocu.i}
      END-FIELDS.
      TABLE: x-VtaTabla B "?" ? INTEGRAL VtaTabla
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
  CREATE WINDOW vTableWin ASSIGN
         HEIGHT             = 7.88
         WIDTH              = 125.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB vTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW vTableWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR RADIO-SET RowObject.CodMon IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.FchAnu IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN RowObject.FchVto IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FmaPgo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodCta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN RowObject.NroOrd IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.NroPed IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.NroRef IN FRAME F-Main
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

&Scoped-define SELF-NAME RowObject.CodCta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.CodCta vTableWin
ON LEAVE OF RowObject.CodCta IN FRAME F-Main /* Concepto */
DO:
  FILL-IN_CodCta:SCREEN-VALUE =  "".
  FIND Ccbtabla WHERE CcbTabla.CodCia = s-codcia AND
      CcbTabla.Tabla = "N/C" AND
      CcbTabla.Codigo = RowObject.CodCta:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE CcbTabla THEN FILL-IN_CodCta:SCREEN-VALUE = CcbTabla.Nombre. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.CodCta vTableWin
ON LEFT-MOUSE-DBLCLICK OF RowObject.CodCta IN FRAME F-Main /* Concepto */
OR F8 OF RowObject.CodCta DO:
    ASSIGN
        input-var-1 = s-TpoFac
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?.
    RUN lkup/c-cfg-tipos-nc-tipo.w ("Seleccione el concepto").
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord vTableWin 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/


  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VAR x-nuevo-preuni AS DEC.
  DEFINE VAR pRowid_Almcmov AS ROWID NO-UNDO.
  DEFINE VAR pRowid_Ccbcdocu AS ROWID NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida-add-record ( OUTPUT pRowid_Almcmov,
                          OUTPUT pRowid_Ccbcdocu,
                          OUTPUT pMensaje ).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF pMensaje > "" THEN MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
      RETURN "ADM-ERROR".
  END.
  ASSIGN
      s-PorIgv = FacCfgGn.PorIgv
      s-PorDto = 0.
  RUN Procesa-Handle IN lh_handle ("Disable-Head").

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FIND Almcmov WHERE ROWID(Almcmov) = pRowid_Almcmov NO-LOCK.
      FIND B-CDOCU WHERE ROWID(B-CDOCU) = pRowid_Ccbcdocu NO-LOCK.
      ASSIGN
          s-NRODEV = ROWID(Almcmov).
      DISPLAY
          STRING(Almcmov.nroser,'999') + STRING(Almcmov.nrodoc) @ RowObject.NroPed
          Almcmov.NroRf2 @  RowObject.NroOrd
          B-CDOCU.codcli @  RowObject.codcli
          B-CDOCU.nomcli @  RowObject.nomcli
          B-CDOCU.dircli @  RowObject.dircli
          B-CDOCU.ruccli @  RowObject.ruccli
          B-CDOCU.codant @  RowObject.codant
          B-CDOCU.nroref @  RowObject.nroref
          B-CDOCU.fmapgo @  RowObject.fmapgo
          B-CDOCU.glosa  @  RowObject.glosa
          STRING(FacCorre.nroSer, '999') + STRING(FacCorre.Correlativo, '999999') @  RowObject.NroDoc
          STRING(FacCorre.nroSer, ENTRY(1,x-Formato,'-')) + STRING(FacCorre.Correlativo, ENTRY(2,x-Formato,'-')) @  RowObject.NroDoc
          TODAY @ RowObject.FchDoc 
          TODAY @ RowObject.FchVto
          s-user-id @ RowObject.usuario.
      ASSIGN
          RowObject.codref:SCREEN-VALUE = B-CDOCU.coddoc
          RowObject.nroref:SCREEN-VALUE = B-CDOCU.nrodoc
          RowObject.CodMon:SCREEN-VALUE = STRING(B-CDOCU.codmon).

      EMPTY TEMP-TABLE DETA.
      FOR EACH Almdmov NO-LOCK WHERE Almdmov.CodCia = Almcmov.CodCia 
          AND Almdmov.CodAlm = Almcmov.CodAlm 
          AND Almdmov.TipMov = Almcmov.TipMov 
          AND Almdmov.CodMov = Almcmov.CodMov 
          AND Almdmov.NroSer = Almcmov.NroSer
          AND Almdmov.NroDoc = Almcmov.NroDoc:
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
          /************* Grabando Costos ********************/
          FIND FIRST CcbDDocu OF B-CDOCU WHERE CcbDDocu.CodMat = Almdmov.codMat NO-LOCK NO-ERROR.
          IF AVAILABLE CcbDDocu THEN DO: 
              x-nuevo-preuni = ROUND((CcbDDocu.implin - CcbDDocu.impdto2) / CcbDDocu.candes,4).
              ASSIGN 
                  DETA.PreUni = x-nuevo-preuni 
                  DETA.ImpLin = ROUND(x-nuevo-preuni * DETA.CanDes,2).
              ASSIGN
                  DETA.ImpCto = CcbDDocu.ImpCto * ( ( DETA.Candes * DETA.Factor ) / (CcbDDocu.Candes * CcbDDocu.Factor) ). 
          END.
      END.
      APPLY 'LEAVE':U TO RowObject.FmaPgo.
  END.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('Browse').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI vTableWin  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayRecord vTableWin 
PROCEDURE displayRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FILL-IN-FmaPgo:SCREEN-VALUE = "".
      FIND gn-ConVt WHERE gn-ConVt.Codig = RowObject.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF AVAILABLE gn-ConVt THEN FILL-IN-FmaPgo:SCREEN-VALUE = gn-ConVt.Nombr.
      FILL-IN_CodCta:SCREEN-VALUE = "".
      FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia AND
          CcbTabla.Tabla = "N/C" AND 
          CcbTabla.Codigo = RowObject.CodCta:SCREEN-VALUE
          NO-LOCK NO-ERROR.
      IF AVAILABLE CcbTabla THEN FILL-IN_CodCta:SCREEN-VALUE = CcbTabla.Nombre.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields vTableWin 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  DISABLE RowObject.CodAnt RowObject.CodCli RowObject.CodRef 
      RowObject.DirCli RowObject.FchAnu 
      RowObject.FchDoc RowObject.FchVto 
      RowObject.FmaPgo RowObject.NomCli 
      RowObject.NroDoc RowObject.NroOrd 
      RowObject.NroPed RowObject.NroRef 
      RowObject.RucCli RowObject.UsuAnu 
      RowObject.usuario RowObject.CodMon
      WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Export-Temp-Table vTableWin 
PROCEDURE Export-Temp-Table :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER TABLE FOR DETA.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Import-Temp-Table vTableWin 
PROCEDURE Import-Temp-Table :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER TABLE FOR DETA.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-add-record vTableWin 
PROCEDURE valida-add-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER pRowid_Almcmov AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER pRowid_Ccbcdocu AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  DEFINE VAR x-nuevo-preuni             AS DEC NO-UNDO.
  DEFINE VAR x-nuevo-implin             AS DEC NO-UNDO.
  DEFINE VAR x-impte-devolucion         AS DEC NO-UNDO.
  DEFINE VAR x-impte-cmpte-referenciado AS DEC NO-UNDO. 
  DEFINE VAR x-impte-QR                 AS DEC NO-UNDO. 
  DEFINE VAR x-porcentaje-devol         AS DEC NO-UNDO. 
  DEFINE VAR x-valida-nc                AS LOG NO-UNDO. 
  DEFINE VAR x-diferencia               AS DEC NO-UNDO.
  
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDoc = S-CODDOC 
      AND FacCorre.NroSer = s-NroSer
      NO-LOCK NO-ERROR.
  IF FacCorre.FlgEst = NO THEN DO:
      pMensaje = 'Esta serie está bloqueada para hacer movimientos'.
      RETURN 'ADM-ERROR'.
  END.
  
  /* Piden PI */
  RUN lkup\C-DevoPendientes.r ("Devoluciones Pendientes").
  IF output-var-1 = ? THEN RETURN "ADM-ERROR".

  FIND Almcmov WHERE ROWID(Almcmov) = output-var-1 NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almcmov THEN DO:
      pMensaje = 'NO existe el movimiento de almacén'.
      RETURN 'ADM-ERROR'.
  END.
  FIND B-CDOCU WHERE B-CDOCU.codcia = s-codcia
      AND B-CDOCU.coddoc = Almcmov.codref
      AND B-CDOCU.nrodoc = Almcmov.nroref
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE B-CDOCU THEN DO:
      pMensaje = 'NO existe el documento ' + Almcmov.codref + " " + Almcmov.nroref .
      RETURN 'ADM-ERROR'.
  END.
  ASSIGN
      pRowid_Almcmov = ROWID(Almcmov)
      pRowid_Ccbcdocu = ROWID(B-CDOCU).
  
  /* Ic - 04Nov2016 */
  CASE s-CodDoc:
      WHEN 'NCI' THEN DO:
          IF Almcmov.codref <> 'FAI' THEN DO:
              pMensaje = 'Seleccione documentos FAIs'.
              RETURN 'ADM-ERROR'.
          END.
      END.
      OTHERWISE DO:
          IF LOOKUP(TRIM(Almcmov.CodRef), 'FAC,BOL') = 0 THEN DO:
              pMensaje = 'Seleccione documentos FAC o BOL'.
              RETURN 'ADM-ERROR'.
          END.
      END.
  END CASE.

  /* Que no supere el monto - Ic 07Jun2021 */
  FOR EACH Almdmov NO-LOCK WHERE Almdmov.CodCia = Almcmov.CodCia 
      AND Almdmov.CodAlm = Almcmov.CodAlm 
      AND Almdmov.TipMov = Almcmov.TipMov 
      AND Almdmov.CodMov = Almcmov.CodMov 
      AND Almdmov.NroSer = Almcmov.NroSer
      AND Almdmov.NroDoc = Almcmov.NroDoc:
      /* Ic - 14Nov2022, verificar si el producto  */
      FIND FIRST B-DDOCU OF B-CDOCU WHERE B-DDOCU.CodMat = Almdmov.CodMat NO-LOCK NO-ERROR.
      x-nuevo-implin = 0.
      IF AVAILABLE B-DDOCU AND (B-DDOCU.candes - B-DDOCU.candev) >= Almdmov.CanDes THEN DO: 
          x-nuevo-preuni = ROUND((B-DDOCU.implin - B-DDOCU.impdto2) / B-DDOCU.candes,4).
          x-nuevo-implin = ROUND(x-nuevo-preuni * Almdmov.CanDes,2).
          x-impte-devolucion = x-impte-devolucion + x-nuevo-implin.
      END.
  END.

  /* Acumulamos NC y PNC relacionados al comprobante base */
  DEFINE VAR x-impte AS DEC.
  DEFINE VAR hxProc AS HANDLE NO-UNDO.            /* Handle Libreria */

  RUN ccb\libreria-ccb.r PERSISTENT SET hxProc.
  RUN sumar-imptes-nc_ref-cmpte IN hxProc (INPUT "*",     /* Algún concepto o todos */
                                           INPUT B-CDocu.CodDoc, 
                                           INPUT B-CDocu.NroDoc,
                                           OUTPUT x-impte).
  DELETE PROCEDURE hxProc.                        /* Release Libreria */

  ASSIGN
      x-impte-cmpte-referenciado = B-CDOCU.imptot
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
      IF x-impte-cmpte-referenciado <= 0 THEN x-impte-cmpte-referenciado = B-CDOCU.TotalPrecioVenta.
  END.
  ASSIGN
      x-porcentaje-devol = ROUND(x-impte-devolucion / x-impte-cmpte-referenciado,4).
  IF x-impte =  0 AND (x-porcentaje-devol >= 1 AND x-porcentaje-devol <= 1.0050 ) THEN DO:
      /* Por la Arimetica de Sunat el PI = pueder 23.93 y el comprobante 23.90 */
  END.
  ELSE DO:
      ASSIGN
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
          /* X la aritmetica de SUNAT */
          IF x-diferencia > 0.09 THEN DO:
              pMensaje = "Existen N/Cs emitidas referenciando al comprobante" + CHR(10) +
                  B-CDocu.CodDoc + " " + B-CDocu.NroDoc + " y cuya suma de sus importes" + CHR(10) +
                  "superan a dicho comprobante" + CHR(10) +
                  "-----------------------------------------" + CHR(10) +
                  "Importe Comprobante : " + STRING(x-impte-cmpte-referenciado) + CHR(10) +
                  "Importe Devolucion : " + string(x-impte-devolucion) + CHR(10) +
                  "Importes N/Cs : " + STRING(x-impte) + CHR(10) +
                  "Importe A/C : " + STRING(B-CDocu.imptot2) + CHR(10) +
                  "importe QR : " + STRING(x-impte-QR).
              RETURN "ADM-ERROR".
          END.
      END.
  END.
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

