&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE DETA LIKE CcbDDocu.
DEFINE SHARED TEMP-TABLE T-GLOSA LIKE ccbgdocu.



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
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE PV-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE cl-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE CB-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHAR.
DEFINE SHARED VARIABLE S-DESALM   AS CHAR.
DEFINE SHARED VARIABLE S-NROSER   AS INTEGER.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NRODOC       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE R-ROWID        AS ROWID     NO-UNDO. 

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV AND
     FacCorre.NroSer = S-NROSER NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN I-NroSer = FacCorre.NroSer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
FIND EMPRESAS WHERE EMPRESAS.CODCIA  = S-CodCia NO-LOCK NO-ERROR.
IF NOT EMPRESAS.CAMPO-CODPRO THEN PV-CODCIA = S-CODCIA.
IF NOT EMPRESAS.CAMPO-CODCBD THEN CB-CODCIA = S-CODCIA.
IF NOT EMPRESAS.CAMPO-CODCLI THEN CL-CODCIA = S-CODCIA.

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
CcbCDocu.CodAlm CcbCDocu.CodAnt CcbCDocu.LugEnt CcbCDocu.NomCli ~
CcbCDocu.LugEnt2 CcbCDocu.CodRef CcbCDocu.CodAge 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.CodAlm CcbCDocu.usuario CcbCDocu.CodAnt CcbCDocu.LugEnt ~
CcbCDocu.NomCli CcbCDocu.LugEnt2 CcbCDocu.CodRef CcbCDocu.CodAge 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Estado F-DesAlm F-NomTra 

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
DEFINE VARIABLE F-DesAlm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81 NO-UNDO.

DEFINE VARIABLE F-NomTra AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 15 FGCOLOR 12  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.NroDoc AT ROW 1 COL 12 COLON-ALIGNED FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     FILL-IN-Estado AT ROW 1 COL 43 COLON-ALIGNED
     CcbCDocu.FchDoc AT ROW 1 COL 80 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.CodAlm AT ROW 1.77 COL 12 COLON-ALIGNED
          LABEL "Punto de partida"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     F-DesAlm AT ROW 1.77 COL 24 COLON-ALIGNED NO-LABEL
     CcbCDocu.usuario AT ROW 1.77 COL 80 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCDocu.CodAnt AT ROW 2.54 COL 12 COLON-ALIGNED
          LABEL "Punto de Llegada" FORMAT "X(10)"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "Almacen","Cliente","Proveedor" 
          DROP-DOWN-LIST
          SIZE 12 BY 1
     CcbCDocu.LugEnt AT ROW 2.54 COL 24 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCDocu.NomCli AT ROW 2.54 COL 35 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 49 BY .81
     CcbCDocu.LugEnt2 AT ROW 3.31 COL 12 COLON-ALIGNED
          LABEL "Direccion"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
     CcbCDocu.CodRef AT ROW 4.08 COL 12 COLON-ALIGNED HELP
          ""
          LABEL "Nº de placa" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCDocu.CodAge AT ROW 4.85 COL 12 COLON-ALIGNED HELP
          ""
          LABEL "Transportista" FORMAT "X(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     F-NomTra AT ROW 4.85 COL 24 COLON-ALIGNED NO-LABEL
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
      TABLE: T-GLOSA T "SHARED" ? INTEGRAL ccbgdocu
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
         HEIGHT             = 4.92
         WIDTH              = 92.72.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN CcbCDocu.CodAge IN FRAME F-Main
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR FILL-IN CcbCDocu.CodAlm IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX CcbCDocu.CodAnt IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.CodRef IN FRAME F-Main
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR FILL-IN F-DesAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomTra IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.LugEnt IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.LugEnt2 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.usuario IN FRAME F-Main
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

&Scoped-define SELF-NAME CcbCDocu.CodRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodRef V-table-Win
ON LEAVE OF CcbCDocu.CodRef IN FRAME F-Main /* Nº de placa */
DO:
  FIND Gn-vehic WHERE gn-vehic.codcia = s-codcia AND
    Gn-vehic.placa = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  ASSIGN
    F-NomTra:SCREEN-VALUE = ''
    CcbCDocu.CodAge:SCREEN-VALUE = ''.
  IF AVAILABLE Gn-Vehic
  THEN DO:
    CcbCDocu.CodAge:SCREEN-VALUE = gn-vehic.CodPro.
    FIND Gn-prov WHERE Gn-prov.codcia = pv-codcia
        AND Gn-prov.codpro = gn-vehic.codpro
        NO-LOCK NO-ERROR.
    IF AVAILABLE Gn-prov
    THEN F-NomTra:SCREEN-VALUE = gn-prov.nompro.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.LugEnt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.LugEnt V-table-Win
ON LEAVE OF CcbCDocu.LugEnt IN FRAME F-Main /* Lugar de entrega */
DO:
  CASE CcbCDocu.CodAnt:SCREEN-VALUE:
    WHEN 'Almacen' THEN DO:
        FIND Almacen WHERE Almacen.codcia = s-codcia
            AND Almacen.codalm = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAILABLE Almacen
        THEN ASSIGN
                CcbCDocu.NomCli:SCREEN-VALUE = Almacen.Descripcion
                CcbCDocu.LugEnt2:SCREEN-VALUE = Almacen.DirAlm.
    END.
    WHEN 'Cliente' THEN DO:
        FIND gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie
        THEN ASSIGN
                CcbCDocu.NomCli:SCREEN-VALUE = gn-clie.nomcli
                CcbCDocu.LugEnt2:SCREEN-VALUE = gn-clie.dircli.
    END.
    WHEN 'Proveedor' THEN DO:
        FIND gn-prov WHERE gn-prov.codcia = pv-codcia
            AND gn-prov.codpro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov
        THEN ASSIGN
                CcbCDocu.NomCli:SCREEN-VALUE = gn-prov.nompro
                CcbCDocu.LugEnt2:SCREEN-VALUE = gn-prov.dirpro.
    END.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.LugEnt V-table-Win
ON LEFT-MOUSE-DBLCLICK OF CcbCDocu.LugEnt IN FRAME F-Main /* Lugar de entrega */
OR F8 OF ccbcdocu.lugent
DO:
  CASE CcbCDocu.CodAnt:SCREEN-VALUE:
    WHEN 'Almacen' THEN DO:
        ASSIGN
            input-var-1 = ''
            input-var-2 = ''
            input-var-3 = ''
            output-var-1 = ?
            output-var-2 = ''
            output-var-3 = ''.
        RUN lkup/c-almcen ('Almacenes').
        IF output-var-1 <> ?
        THEN DO:
            FIND Almacen WHERE ROWID(Almacen) = output-var-1 NO-LOCK NO-ERROR.
            ASSIGN
                SELF:SCREEN-VALUE = Almacen.codalm
                CcbCDocu.NomCli:SCREEN-VALUE = Almacen.Descripcion
                CcbCDocu.LugEnt2:SCREEN-VALUE = Almacen.DirAlm.
        END.
    END.
    WHEN 'Cliente' THEN DO:
        ASSIGN
            input-var-1 = ''
            input-var-2 = ''
            input-var-3 = ''
            output-var-1 = ?
            output-var-2 = ''
            output-var-3 = ''.
        RUN lkup/c-client ('Clientes').        
        IF output-var-1 <> ?
        THEN DO:
            FIND gn-clie WHERE ROWID(gn-clie) = output-var-1 NO-LOCK NO-ERROR.
            ASSIGN
                SELF:SCREEN-VALUE = gn-clie.CodCli
                CcbCDocu.NomCli:SCREEN-VALUE = gn-clie.nomcli
                CcbCDocu.LugEnt2:SCREEN-VALUE = gn-clie.dircli.
        END.            
    END.
    WHEN 'Proveedor' THEN DO:
        ASSIGN
            input-var-1 = ''
            input-var-2 = ''
            input-var-3 = ''
            output-var-1 = ?
            output-var-2 = ''
            output-var-3 = ''.
        RUN lkup/c-provee ('Proveedores').        
        IF output-var-1 <> ?
        THEN DO:
            FIND gn-prov WHERE ROWID(gn-prov) = output-var-1 NO-LOCK NO-ERROR.
            ASSIGN
                SELF:SCREEN-VALUE = gn-prov.CodPro
                CcbCDocu.NomCli:SCREEN-VALUE = gn-prov.nompro
                CcbCDocu.LugEnt2:SCREEN-VALUE = gn-prov.dirpro.
        END.            
    END.
  END CASE.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal V-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH DETA:
    DELETE DETA.
  END.
  FOR EACH T-GLOSA:
    DELETE T-GLOSA.
  END.
  IF AVAILABLE CcbCDocu
  THEN DO:
    FOR EACH ccbddocu OF ccbcdocu NO-LOCK:
        CREATE DETA.
        BUFFER-COPY ccbddocu TO DETA.
    END.
    FOR EACH ccbgdocu OF ccbcdocu NO-LOCK:
        CREATE T-GLOSA.
        BUFFER-COPY ccbgdocu TO T-GLOSA.
    END.
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
  DEF VAR x-Item AS INT INIT 0 NO-UNDO.
  
  FOR EACH DETA NO-LOCK WHERE DETA.CodMat <> "" BY DETA.NroItm
        ON ERROR UNDO, RETURN "ADM-ERROR": 
    x-Item = x-Item + 1.
    CREATE CcbDDocu. 
    BUFFER-COPY DETA TO CcbDDocu
        ASSIGN CcbDDocu.CodCia = CcbCDocu.CodCia 
                CcbDDocu.Coddoc = CcbCDocu.Coddoc
                CcbDDocu.NroDoc = CcbCDocu.NroDoc 
                CcbDDocu.AlmDes = CcbCDocu.CodAlm
                CcbDDocu.CodDiv = CcbCDocu.CodDiv
                CcbDDocu.FchDoc = CcbCDocu.FchDoc
                CcbDDocu.NroItm = x-Item.
    FIND T-GLOSA OF DETA NO-LOCK NO-ERROR.
    IF AVAILABLE T-GLOSA
    THEN DO:
        CREATE CcbGDocu.
        BUFFER-COPY T-GLOSA TO CcbGDocu
            ASSIGN CcbGDocu.CodCia = CcbCDocu.CodCia 
                    CcbGDocu.Coddoc = CcbCDocu.Coddoc
                    CcbGDocu.NroDoc = CcbCDocu.NroDoc 
                    CcbGDocu.CodDiv = CcbCDocu.CodDiv.
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
  RUN Numero-de-Documento (FALSE).
  IF RETURN-VALUE = 'ADM-ERROR' 
  THEN DO:
    MESSAGE 'No esta configurado el correlativo para esta division'
        VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* VALORES EN PANTALLA */
  DO WITH FRAME {&FRAME-NAME}:
    /* Correlativo */
    RUN Numero-de-Documento(NO).
    DISPLAY 
        STRING(i-NroSer, '999') + STRING(i-NroDoc, '999999') @ CcbCDocu.NroDoc
        s-codalm    @ CcbCDocu.CodAlm
        s-desalm    @ F-DesAlm
        TODAY       @ CcbCDocu.FchDoc.
    ASSIGN
        CcbCDocu.CodAnt:SCREEN-VALUE = 'Almacen'.
  END.
  RUN Carga-Temporal.
  RUN Procesa-Handle IN lh_handle ('Pagina2').
  RUN Procesa-Handle IN lh_handle ('browse').

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
  ASSIGN 
    CcbCDocu.usuario = S-USER-ID
    CcbCDocu.HorCie = string(time,'hh:mm:ss').
  RUN Genera-Guia.    /* Detalle de la Guia */ 
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  RUN Procesa-Handle IN lh_handle ('Pagina1').
  
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
  RUN Procesa-Handle IN lh_handle ('Pagina1').
  RUN Procesa-Handle IN lh_handle ('browse').

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Numero-de-Documento(YES).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  ASSIGN 
    CcbCDocu.NroDoc = STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999") 
    CcbCDocu.CodCia = S-CODCIA
    CcbCDocu.CodAlm = S-CODALM
    CcbCDocu.CodDiv = S-CODDIV
    CcbCDocu.CodDoc = S-CODDOC
    CcbCDocu.Tipo   = "OFICINA"
    CcbCDocu.TipVta = "2"
    CcbCDocu.TpoFac = "R"
    CcbCDocu.FlgEst = "F"
    CcbCDocu.FlgSit = "P".
  DISPLAY ccbcdocu.nrodoc WITH FRAME {&FRAME-NAME}.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

/*
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
*/
  DEF VAR RPTA AS CHAR NO-UNDO.
  
  IF CcbCDocu.FlgEst = "A" THEN DO:
      MESSAGE 'El documento se enuentra anulado...' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
  END.
  FIND Almacen WHERE 
        Almacen.CodCia = S-CODCIA AND
        Almacen.CodAlm = S-CODALM NO-LOCK NO-ERROR.
  RUN vta/g-CLAVE (Almacen.Clave,OUTPUT RPTA).
  IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR':
    FIND CURRENT CcbCDocu EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN RETURN 'ADM-ERROR'.
    FOR EACH CcbDDocu OF CcbCDocu EXCLUSIVE-LOCK:
        DELETE CcbDDocu.
    END.
    FOR EACH CcbGDocu OF CcbCDocu EXCLUSIVE-LOCK:
        DELETE CcbGDocu.
    END.
    ASSIGN
        CcbCDocu.FlgEst = 'A'
        CcbCDocu.SdoAct = 0
        CcbCDocu.Glosa  = "A N U L A D O"
        CcbCDocu.FchAnu = TODAY
        CcbCDocu.Usuanu = S-USER-ID. 
    FIND CURRENT CcbCDocu NO-LOCK NO-ERROR.
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
  IF AVAILABLE CcbCDocu THEN DO WITH FRAME {&FRAME-NAME}:
    CASE CcbCDocu.FlgEst:
        WHEN "A" THEN DISPLAY "ANULADO"   @ FILL-IN-Estado WITH FRAME {&FRAME-NAME}.
        WHEN "F" THEN DISPLAY "FACTURADO" @ FILL-IN-Estado WITH FRAME {&FRAME-NAME}.
        WHEN "P" THEN DISPLAY "PENDIENTE" @ FILL-IN-Estado WITH FRAME {&FRAME-NAME}.
        OTHERWISE DISPLAY "?" @ FILL-IN-Estado WITH FRAME {&FRAME-NAME}.
    END CASE.         
    FIND Almacen WHERE Almacen.codcia = s-codcia
      AND Almacen.codalm = ccbcdocu.codalm
      NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen
    THEN F-DesAlm:SCREEN-VALUE = Almacen.Descripcion.
    ELSE F-DesAlm:SCREEN-VALUE = ''.
    FIND gn-prov WHERE gn-prov.CodCia = pv-codcia
        AND gn-prov.CODPRO = CcbCDocu.CodAge NO-LOCK NO-ERROR.
    IF AVAILABLE GN-PROV 
    THEN F-NomTra:SCREEN-VALUE = GN-PROV.NomPRO.
    ELSE F-NomTra:SCREEN-VALUE = ''.
  END.
  RUN Carga-Temporal.
  RUN Procesa-Handle IN lh_handle ('browse').

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
        CcbCDocu.NroDoc:SENSITIVE = NO
        CcbCDocu.CodAlm:SENSITIVE = NO
        CcbCDocu.CodAge:SENSITIVE = NO
        CcbCDocu.NomCli:SENSITIVE = NO.
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
  IF ccbcdocu.flgest = 'A' THEN RETURN.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF CcbCDocu.FlgEst <> "A" THEN RUN vta/R-ImpGMA2a (ROWID(CcbCDocu)).

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
  IF L-INCREMENTA 
  THEN
     FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = S-CODDOC AND
          FacCorre.CodDiv = S-CODDIV AND
          FacCorre.NroSer = S-NROSER AND
          FacCorre.CodAlm = S-CODALM EXCLUSIVE-LOCK NO-ERROR.
  
  ELSE
     FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = S-CODDOC AND
          FacCorre.CodDiv = S-CODDIV AND
          FacCorre.NroSer = S-NROSER AND
          FacCorre.CodAlm = S-CODALM NO-LOCK NO-ERROR.
     
  IF ERROR-STATUS:ERROR THEN RETURN 'ADM-ERROR'.
  ASSIGN I-NroDoc = FacCorre.Correlativo.
  IF L-INCREMENTA THEN ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
  I-NROSER = FacCorre.NroSer.
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
  DEFINE VARIABLE X-ITEMS AS INTEGER INIT 0.
  DEFINE VARIABLE I-ITEMS AS DECIMAL NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    FIND Gn-Vehic WHERE Gn-Vehic.codcia = s-codcia
        AND Gn-Vehic.placa = CcbCDocu.CodRef:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE GN-PROV THEN DO:
       MESSAGE "Nº de placa no existe" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO CcbCDocu.CodRef.
       RETURN "ADM-ERROR".   
    END.
    FIND GN-PROV WHERE GN-PROV.codcia = pv-codcia
        AND GN-PROV.CodPro = CcbcDocu.CodAge:SCREEN-VALUE
        NO-LOCK NO-ERROR.
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
    IF X-ITEMS > FacCfgGn.Items_Guias THEN DO:
     MESSAGE "Numero de Items Mayor al Configurado para el Tipo de Documento " VIEW-AS ALERT-BOX INFORMATION.
     RETURN "ADM-ERROR".
    END. 

/*    FIND AlmCierr WHERE 
 *         AlmCierr.CodCia = S-CODCIA AND 
 *         AlmCierr.FchCie = INPUT CcbCDocu.FchDoc 
 *         NO-LOCK NO-ERROR.
 *     IF AVAILABLE AlmCierr 
 *         AND AlmCierr.FlgCie THEN DO:
 *       MESSAGE "Este dia " AlmCierr.FchCie " se encuentra cerrado" SKIP 
 *               "Consulte con sistemas " VIEW-AS ALERT-BOX INFORMATION.
 *       RETURN "ADM-ERROR".
 *     END.*/
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
MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

