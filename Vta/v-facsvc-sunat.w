&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE DETA LIKE CcbDDocu.
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-nroser AS INT.
DEF SHARED VAR s-codref AS CHAR.
DEF SHARED VAR lh_handle AS HANDLE.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-TpoFac AS CHAR.

DEFINE SHARED VARIABLE s-Sunat-Activo AS LOG.

DEF BUFFER B-DOCU FOR Ccbcdocu.

FIND FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK.

DEF VAR pMensaje AS CHAR NO-UNDO.

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
&Scoped-Define ENABLED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.CodCli CcbCDocu.FchVto CcbCDocu.NomCli CcbCDocu.TpoCmb ~
CcbCDocu.DirCli CcbCDocu.CodMon CcbCDocu.CodAnt CcbCDocu.RucCli ~
CcbCDocu.usuario CcbCDocu.CodVen CcbCDocu.UsuAnu CcbCDocu.FmaPgo ~
CcbCDocu.FchAnu CcbCDocu.NroRef CcbCDocu.Glosa 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define ENABLED-OBJECTS RECT-66 
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.CodCli CcbCDocu.FchVto CcbCDocu.NomCli CcbCDocu.TpoCmb ~
CcbCDocu.DirCli CcbCDocu.CodMon CcbCDocu.CodAnt CcbCDocu.RucCli ~
CcbCDocu.usuario CcbCDocu.CodVen CcbCDocu.UsuAnu CcbCDocu.FmaPgo ~
CcbCDocu.FchAnu CcbCDocu.NroRef CcbCDocu.Glosa 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Estado FILL-IN-NomVen ~
FILL-IN-FmaPgo 

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
DEFINE VARIABLE FILL-IN-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     BGCOLOR 15 FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE FILL-IN-FmaPgo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-66
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 98 BY 7.69.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.NroDoc AT ROW 1.19 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.FchDoc AT ROW 1.19 COL 82 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FILL-IN-Estado AT ROW 1.27 COL 29 COLON-ALIGNED NO-LABEL
     CcbCDocu.CodCli AT ROW 1.96 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.FchVto AT ROW 1.96 COL 82 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.NomCli AT ROW 2.73 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 51 BY .81
     CcbCDocu.TpoCmb AT ROW 2.73 COL 82 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbCDocu.DirCli AT ROW 3.5 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 51 BY .81
     CcbCDocu.CodMon AT ROW 3.5 COL 84 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12 BY .81
     CcbCDocu.CodAnt AT ROW 4.23 COL 29 COLON-ALIGNED WIDGET-ID 2
          LABEL "DNI" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.RucCli AT ROW 4.27 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.usuario AT ROW 4.27 COL 82 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbCDocu.CodVen AT ROW 5.04 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FILL-IN-NomVen AT ROW 5.04 COL 20 COLON-ALIGNED NO-LABEL
     CcbCDocu.UsuAnu AT ROW 5.04 COL 82 COLON-ALIGNED
          LABEL "Anulado por"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbCDocu.FmaPgo AT ROW 5.81 COL 11 COLON-ALIGNED
          LABEL "Forma de Pago"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     FILL-IN-FmaPgo AT ROW 5.81 COL 19 COLON-ALIGNED NO-LABEL
     CcbCDocu.FchAnu AT ROW 5.81 COL 82 COLON-ALIGNED
          LABEL "Fecha Anulacion"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     CcbCDocu.NroRef AT ROW 6.58 COL 11 COLON-ALIGNED
          LABEL "G/R"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCDocu.Glosa AT ROW 7.35 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 55 BY .81
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 3.69 COL 77
     RECT-66 AT ROW 1 COL 1
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
      TABLE: DETA T "SHARED" ? INTEGRAL CcbDDocu
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
         HEIGHT             = 8.85
         WIDTH              = 106.29.
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
/* SETTINGS FOR FILL-IN CcbCDocu.FchAnu IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FmaPgo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FmaPgo IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NroRef IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.UsuAnu IN FRAME F-Main
   EXP-LABEL                                                            */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal V-table-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH DETA:
    DELETE DETA.
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
  RUN Borra-Temporal.
  FOR EACH Ccbddocu OF B-DOCU NO-LOCK:
    CREATE DETA.
    BUFFER-COPY Ccbddocu TO DETA.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Detalle V-table-Win 
PROCEDURE Graba-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH DETA:
    CREATE Ccbddocu.
    BUFFER-COPY DETA TO ccbddocu
        ASSIGN
            Ccbddocu.codcia = Ccbcdocu.codcia
            Ccbddocu.coddoc = Ccbcdocu.coddoc
            Ccbddocu.nrodoc = Ccbcdocu.nrodoc.
         
  END.
  
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
  ASSIGN
    Ccbcdocu.ImpBrt = 0
    Ccbcdocu.ImpDto = 0
    Ccbcdocu.ImpExo = 0
    Ccbcdocu.ImpFle = 0
    Ccbcdocu.ImpIgv = 0
    Ccbcdocu.ImpIsc = 0
    Ccbcdocu.ImpTot = 0
    Ccbcdocu.ImpVta = 0.
  FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
    Ccbcdocu.impigv = Ccbcdocu.impigv + Ccbddocu.impigv.
    Ccbcdocu.impisc = Ccbcdocu.impisc + Ccbddocu.impisc.
    Ccbcdocu.ImpTot = Ccbcdocu.ImpTot + Ccbddocu.ImpLin.
    IF NOT Ccbddocu.AftIgv THEN Ccbcdocu.ImpExo = Ccbcdocu.ImpExo + Ccbddocu.ImpLin.
    IF Ccbddocu.AftIgv = YES
    THEN Ccbcdocu.ImpDto = Ccbcdocu.ImpDto + ROUND(Ccbddocu.ImpDto / (1 + Ccbcdocu.PorIgv / 100), 2).
    ELSE Ccbcdocu.ImpDto = Ccbcdocu.ImpDto + Ccbddocu.ImpDto.
  END.
  Ccbcdocu.impvta = Ccbcdocu.imptot - Ccbcdocu.impexo - Ccbcdocu.impigv.
  IF Ccbcdocu.PorDto > 0 THEN DO:
    ASSIGN
        Ccbcdocu.ImpDto = Ccbcdocu.ImpDto + ROUND((Ccbcdocu.ImpVta + Ccbcdocu.ImpExo) * Ccbcdocu.PorDto / 100, 2)
        Ccbcdocu.ImpTot = ROUND(Ccbcdocu.ImpTot * (1 - Ccbcdocu.PorDto / 100),2)
        Ccbcdocu.ImpVta = ROUND(Ccbcdocu.ImpVta * (1 - Ccbcdocu.PorDto / 100),2)
        Ccbcdocu.ImpExo = ROUND(Ccbcdocu.ImpExo * (1 - Ccbcdocu.PorDto / 100),2)
        Ccbcdocu.ImpIgv = Ccbcdocu.ImpTot - Ccbcdocu.ImpExo - Ccbcdocu.ImpVta.
  END.
  Ccbcdocu.ImpBrt = Ccbcdocu.ImpVta + Ccbcdocu.ImpIsc + Ccbcdocu.ImpDto + Ccbcdocu.ImpExo.
  Ccbcdocu.SdoAct = Ccbcdocu.ImpTot.
  /* RHC 5.7.10 Transferencia Gratuita */
  IF LOOKUP(Ccbcdocu.FmaPgo,'899,900') > 0 THEN Ccbcdocu.sdoact = 0.
  IF Ccbcdocu.sdoact <= 0 
  THEN ASSIGN
          Ccbcdocu.fchcan = TODAY
          Ccbcdocu.flgest = 'C'.

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
  DEF VAR p-NroRef LIKE CcbCDocu.NroPed.

  DEFINE VAR z-serie AS CHAR.
  DEFINE VAR x-cambiar-fecha AS LOG.
  
  {adm/i-DocPssw.i s-CodCia s-CodDoc ""ADD""}

  RUN vta/d-grpend (OUTPUT p-NroRef).
  IF p-NroRef = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

  FIND FacCorre WHERE Faccorre.codcia = s-codcia
    AND Faccorre.coddiv = s-coddiv
    AND Faccorre.coddoc = s-coddoc
    AND Faccorre.nroser = s-nroser
    NO-LOCK NO-ERROR.
  IF Faccorre.flgest = NO THEN DO:
    MESSAGE 'Serie INACTIVA' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  z-serie = STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-')).

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    FIND B-DOCU WHERE B-DOCU.codcia = s-codcia
        AND B-DOCU.coddiv = s-coddiv
        AND B-DOCU.coddoc = s-codref
        AND B-DOCU.nrodoc = p-nroref
        NO-LOCK.
    FIND Gn-Convt WHERE Gn-convt.codig = B-DOCU.FmaPgo NO-LOCK.
    FIND Gn-ven OF B-DOCU NO-LOCK.
    RUN Carga-Temporal.
    DISPLAY
/*         STRING(Faccorre.nroser, '999') +                             */
/*             STRING(Faccorre.correlativo, '999999') @ Ccbcdocu.nrodoc */
        z-serie /* STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-')) */ +
        STRING(FacCorre.Correlativo,ENTRY(2,x-Formato,'-')) @ Ccbcdocu.nrodoc

        B-DOCU.codcli @ CcbCDocu.CodCli 
        B-DOCU.codven @ CcbCDocu.CodVen 
        B-DOCU.dircli @ CcbCDocu.DirCli 
        TODAY @ CcbCDocu.FchDoc 
        TODAY + Gn-convt.totdias @ CcbCDocu.FchVto 
        Gn-convt.nombr @ FILL-IN-FmaPgo
        gn-ven.NomVen @ FILL-IN-NomVen
        FacCfgGn.Tpocmb[1] @ CcbCDocu.TpoCmb
        B-DOCU.fmapgo @ CcbCDocu.FmaPgo 
        B-DOCU.nomcli @ CcbCDocu.NomCli 
        p-nroref @ CcbCDocu.NroRef 
        B-DOCU.ruccli @ CcbCDocu.RucCli
        B-DOCU.CodAnt @ CcbCDocu.CodAnt
        WITH FRAME {&FRAME-NAME}.
    ASSIGN
        CcbCDocu.CodMon:SCREEN-VALUE = STRING(B-DOCU.codmon, '9').

      /* Validamos que permita ingresar la fecha de emision */
      x-cambiar-fecha = NO.
      DEFINE VAR hProc AS HANDLE NO-UNDO.

      RUN ccb\libreria-ccb.r PERSISTENT SET hProc.

      RUN serie-cambia-fecha IN hProc (INPUT s-coddoc, INPUT z-serie, OUTPUT x-cambiar-fecha).

      DELETE PROCEDURE hProc.

      DISABLE ccbcdocu.fchdoc.
      DISABLE ccbcdocu.fchvto.
      IF x-cambiar-fecha = YES THEN DO:
          ENABLE ccbcdocu.fchdoc.
          ENABLE ccbcdocu.fchvto.
      END.

  END.
  RUN Procesa-handle IN lh_handle ('Pagina2').
  

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
  FIND FacCorre WHERE Faccorre.codcia = s-codcia
    AND Faccorre.coddiv = s-coddiv
    AND Faccorre.coddoc = s-coddoc
    AND Faccorre.nroser = s-nroser
    EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccorre THEN UNDO, RETURN 'ADM-ERROR'.
  FIND B-DOCU WHERE B-DOCU.codcia = s-codcia
    AND B-DOCU.coddoc = s-codref
    AND B-DOCU.nrodoc = Ccbcdocu.nroref:SCREEN-VALUE IN FRAME {&FRAME-NAME}
    EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE B-DOCU OR B-DOCU.FlgEst <> 'P' THEN DO:
    MESSAGE 'GRS no válida' VIEW-AS ALERT-BOX ERROR.
    UNDO, RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    Ccbcdocu.codcia = s-codcia
    Ccbcdocu.coddoc = s-coddoc
    Ccbcdocu.coddiv = s-coddiv
    Ccbcdocu.tpofac = s-tpofac
    Ccbcdocu.tipo   = "CREDITO"
    Ccbcdocu.codref = s-codref
/*     Ccbcdocu.nrodoc = STRING(Faccorre.nroser, '999') + STRING(Faccorre.correlativo, '999999') */
    CcbCDocu.NroDoc = STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-')) + STRING(FacCorre.Correlativo,ENTRY(2,x-Formato,'-')) 
    FacCorre.Correlativo = FacCorre.Correlativo + 1
    B-DOCU.FlgEst = 'F'
    B-DOCU.CodRef = ccbcdocu.coddoc
    Ccbcdocu.usuario = s-user-id
    Ccbcdocu.FlgEst = 'P'
    Ccbcdocu.PorDto = B-DOCU.PorDto
    Ccbcdocu.PorIgv = B-DOCU.PorIgv.
  
  RUN Graba-Detalle.
  RUN Graba-Totales.
  ASSIGN
    Ccbcdocu.sdoact = Ccbcdocu.imptot.
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
  /* RHC 02-07-2012 ASIENTO DE TRANSFERENCIA PARA SPEED */
/*   RUN aplic/sypsa/registroventas (INPUT ROWID(ccbcdocu), INPUT "I", YES). */
  /* ************************************************** */
  /* GENERACION DE INFORMACION PARA SUNAT */
  RUN sunat\progress-to-ppll-v3( INPUT Ccbcdocu.coddiv,
                                 INPUT Ccbcdocu.coddoc,
                                 INPUT Ccbcdocu.nrodoc,
                                 INPUT-OUTPUT TABLE T-FELogErrores,
                                 OUTPUT pMensaje ).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF pMensaje = "" THEN pMensaje = "ERROR: No se pudo generar el comprobante" .
      UNDO, RETURN 'ADM-ERROR'.
  END.
  IF RETURN-VALUE = 'ERROR-EPOS' THEN DO:
      IF pMensaje = "" THEN pMensaje = "ERROR: No se pudo confirmar el comprobante" .
      ASSIGN Ccbcdocu.flgest = "A".
  END.
  /* *********************************************************** */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RELEASE FacCorre.
  RELEASE B-DOCU.
  RELEASE Ccbddocu.

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
  RUN Procesa-handle IN lh_handle ('Pagina1').

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
  /* ********************************************* */
  /* Inicio de actividades facturación electrónica */
  /* ********************************************* */
  IF s-user-id <> "ADMIN" THEN DO:
    IF s-Sunat-Activo = YES THEN DO:
          MESSAGE 'Acceso Denegado...Sunat Inactivo' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
  END.
  /* ********************************************* */
  IF LOOKUP(Ccbcdocu.fmapgo,'899,900') = 0 THEN DO:
      IF CcbCDocu.FlgEst = "C" AND Ccbcdocu.ImpTot > 0 THEN DO:
         MESSAGE 'El documento se encuentra Cancelado...' VIEW-AS ALERT-BOX.
         RETURN 'ADM-ERROR'.
      END.
      IF Ccbcdocu.flgest <> "P" THEN DO:
        MESSAGE "Acceso Denegado...Flgest <> 'P' " VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
      END.
      IF Ccbcdocu.imptot <> Ccbcdocu.sdoact THEN DO:
        MESSAGE "El documento tiene amortizaciones" VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
      END.
  END.
  /* consistencia de la fecha del cierre del sistema */
  IF s-user-id <> "ADMIN" THEN DO:
      DEF VAR dFchCie AS DATE.
      RUN gn/fecha-de-cierre (OUTPUT dFchCie).
      IF ccbcdocu.fchdoc <= dFchCie THEN DO:
          MESSAGE 'NO se puede anular ningun documento antes del' (dFchCie + 1)
              VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.
  END.
  /* fin de consistencia */
  IF MONTH(Ccbcdocu.FchDoc) <> MONTH(TODAY) OR YEAR(Ccbcdocu.FchDoc) <> YEAR(TODAY) THEN DO:
    {adm/i-DocPssw.i s-CodCia s-CodDoc ""DEL""}
  END.
  
/*
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
*/

  DO TRANSACTION ON STOP UNDO, RETURN "ADM-ERROR" ON ERROR UNDO, RETURN "ADM-ERROR":
      /* Motivo de anulacion */
      DEF VAR cReturnValue AS CHAR NO-UNDO.
      RUN ccb/d-motanu (ccbcdocu.codcia, ccbcdocu.coddoc, ccbcdocu.nrodoc, s-user-id, OUTPUT cReturnValue).
      IF cReturnValue = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      /* ******************* */

    FIND CURRENT Ccbcdocu EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcdocu THEN UNDO, RETURN "ADM-ERROR".
    ASSIGN
        Ccbcdocu.flgest = "A"
        Ccbcdocu.usuanu = s-user-id
        Ccbcdocu.fchanu = TODAY.
    FIND B-DOCU WHERE B-DOCU.codcia = s-codcia
        AND B-DOCU.coddoc = s-codref
        AND B-DOCU.nrodoc = Ccbcdocu.nroref
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcdocu THEN UNDO, RETURN "ADM-ERROR".
    ASSIGN
        B-DOCU.FlgEst = 'P'.
/*     FOR EACH B-DOCU WHERE B-DOCU.codcia = Ccbcdocu.codcia */
/*             AND B-DOCU.coddoc = s-codref                  */
/*             AND B-DOCU.codref = Ccbcdocu.coddoc           */
/*             AND B-DOCU.nroref = Ccbcdocu.nrodoc           */
/*             EXCLUSIVE-LOCK:                               */
/*         ASSIGN                                            */
/*             B-DOCU.flgest = "P"                           */
/*             B-DOCU.codref = ""                            */
/*             B-DOCU.nroref = "".                           */
/*     END.                                                  */
    RELEASE B-DOCU.
    FIND CURRENT Ccbcdocu NO-LOCK NO-ERROR.
  END.
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
  IF AVAILABLE Ccbcdocu THEN DO WITH FRAME {&FRAME-NAME}:
    CASE Ccbcdocu.flgest:
        WHEN "A" THEN FILL-IN-Estado:SCREEN-VALUE = "Anulado".
        WHEN "C" THEN FILL-IN-Estado:SCREEN-VALUE = "Cancelado".
        WHEN "P" THEN FILL-IN-Estado:SCREEN-VALUE = "Pendiente".
        OTHERWISE FILL-IN-Estado:SCREEN-VALUE = "???".
    END CASE.
    FIND Gn-Convt WHERE Gn-convt.codig = Ccbcdocu.FmaPgo NO-LOCK NO-ERROR.
    FIND Gn-ven OF Ccbcdocu NO-LOCK NO-ERROR.
    FILL-IN-FmaPgo:SCREEN-VALUE = IF AVAILABLE Gn-convt THEN gn-ConVt.Nombr ELSE "".
    FILL-IN-NomVen:SCREEN-VALUE = IF AVAILABLE Gn-ven THEN gn-ven.NomVen ELSE "".
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
        CcbCDocu.CodCli:SENSITIVE = NO
        CcbCDocu.CodMon:SENSITIVE = NO
        CcbCDocu.CodVen:SENSITIVE = NO
        CcbCDocu.DirCli:SENSITIVE = NO
        CcbCDocu.FchAnu:SENSITIVE = NO
        CcbCDocu.FchDoc:SENSITIVE = NO
        CcbCDocu.FmaPgo:SENSITIVE = NO
        CcbCDocu.NomCli:SENSITIVE = NO
        CcbCDocu.NroDoc:SENSITIVE = NO
        CcbCDocu.NroRef:SENSITIVE = NO
        CcbCDocu.RucCli:SENSITIVE = NO
        CcbCDocu.CodAnt:SENSITIVE = NO
        CcbCDocu.TpoCmb:SENSITIVE = NO
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
  IF NOT AVAILABLE Ccbcdocu THEN RETURN 'ADM-ERROR'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF s-Sunat-Activo = YES THEN DO:
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
        x-imprime-directo = YES.
        x-nombre-impresora = "".

        DEF VAR answer AS LOGICAL NO-UNDO.
            SYSTEM-DIALOG PRINTER-SETUP UPDATE answer.
            IF NOT answer THEN RETURN.
        
        x-nombre-impresora = SESSION:PRINTER-NAME.
  
        RUN sunat\r-impresion-doc-electronico-sunat (INPUT ccbcdocu.coddiv, 
                                                     INPUT ccbcdocu.coddoc, 
                                                     INPUT ccbcdocu.nrodoc,
                                                     INPUT x-version,
                                                     INPUT x-formato-tck,
                                                     INPUT x-imprime-directo,
                                                     INPUT x-nombre-impresora).

        x-version = 'A'.
        RUN sunat\r-impresion-doc-electronico-sunat (INPUT ccbcdocu.coddiv, 
                                                     INPUT ccbcdocu.coddoc, 
                                                     INPUT ccbcdocu.nrodoc,
                                                     INPUT x-version,
                                                     INPUT x-formato-tck,
                                                     INPUT x-imprime-directo,
                                                     INPUT x-nombre-impresora).
      END.
      ELSE DO:
          /* Matricial sin QR */          
          RUN sunat\r-impresion-documentos-sunat ( ROWID(Ccbcdocu), "O", NO ).
      END.
      RELEASE x-gn-divi.          
  END.
  ELSE DO:
      CASE Ccbcdocu.coddoc:
        WHEN "FAC" THEN RUN vta/r-impfacsvc (ROWID(Ccbcdocu)).
        WHEN "BOL" THEN RUN vta/r-impbolsvc (ROWID(Ccbcdocu)).
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
  RUN Graba-Temp-FeLogErrores.    /* Control de Errores (si es que hay) */
  IF pMensaje <> '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-handle IN lh_handle ('Pagina1').

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
DO WITH FRAME {&FRAME-NAME} :
   /* IF CAMPO:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Campo no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CAMPO.
         RETURN "ADM-ERROR".   
   
      END.
   */

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

