&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE RUTA LIKE DI-RutaC.
DEFINE SHARED TEMP-TABLE T-DOSER LIKE lg-doser.



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

DEF SHARED VAR lh_handle AS HANDLE.
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR PV-CODCIA  AS INTEGER.
DEF SHARED VAR s-coddiv  AS CHAR.
DEF SHARED VAR s-nomcia  AS CHAR.
DEF SHARED VAR s-ruccia  AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddoc  AS CHAR.
DEF SHARED VAR s-aftigv  AS LOG.
DEF SHARED VAR s-CodPro LIKE GN-PROV.CodPro.
DEF SHARED VAR s-HojaRuta AS LOG.

/* Variables de Impresion */
DEF VAR RB-REPORT-LIBRARY AS CHAR INIT ''.      /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME    AS CHAR INIT ''.      /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR INIT ''.     /* "O" si necesita filtro */
DEF VAR RB-FILTER          AS CHAR INIT ''.     /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INIT ''.    /* Otros parametros */

GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "lgc/rblgc.prl".

DEF VAR RPTA AS CHAR NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES lg-coser
&Scoped-define FIRST-EXTERNAL-TABLE lg-coser


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR lg-coser.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS lg-coser.CodPro lg-coser.FchVto ~
lg-coser.FchEnt lg-coser.CndCmp lg-coser.NroRef lg-coser.Codmon ~
lg-coser.Requerimiento lg-coser.TpoCmb lg-coser.Proyecto ~
lg-coser.Observaciones lg-coser.glosa lg-coser.AftIgv lg-coser.LugSer 
&Scoped-define ENABLED-TABLES lg-coser
&Scoped-define FIRST-ENABLED-TABLE lg-coser
&Scoped-Define ENABLED-OBJECTS RECT-4 
&Scoped-Define DISPLAYED-FIELDS lg-coser.NroSer lg-coser.NroDoc ~
lg-coser.Fchdoc lg-coser.CodPro lg-coser.FchVto lg-coser.FchEnt ~
lg-coser.CndCmp lg-coser.usuario lg-coser.NroRef lg-coser.Codmon ~
lg-coser.Requerimiento lg-coser.TpoCmb lg-coser.Proyecto ~
lg-coser.Observaciones lg-coser.glosa lg-coser.AftIgv lg-coser.LugSer 
&Scoped-define DISPLAYED-TABLES lg-coser
&Scoped-define FIRST-DISPLAYED-TABLE lg-coser
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-FlgSit FILL-IN-NomPro ~
FILL-IN-DirPro FILL-IN-FmaPgo FILL-IN-Proyecto 

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
DEFINE VARIABLE FILL-IN-DirPro AS CHARACTER FORMAT "X(256)":U 
     LABEL "Direccion" 
     VIEW-AS FILL-IN 
     SIZE 66 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FlgSit AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     BGCOLOR 15 FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE FILL-IN-FmaPgo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Proyecto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 58 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 22 BY 2.12.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     lg-coser.NroSer AT ROW 1 COL 12 COLON-ALIGNED
          LABEL "Correlativo"
          VIEW-AS FILL-IN 
          SIZE 4 BY .81
          BGCOLOR 15 FGCOLOR 1 
     lg-coser.NroDoc AT ROW 1 COL 17 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
          BGCOLOR 15 FGCOLOR 1 
     FILL-IN-FlgSit AT ROW 1 COL 40 COLON-ALIGNED
     lg-coser.Fchdoc AT ROW 1 COL 91 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     lg-coser.CodPro AT ROW 1.77 COL 12 COLON-ALIGNED
          LABEL "Proveedor"
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     FILL-IN-NomPro AT ROW 1.77 COL 22 COLON-ALIGNED NO-LABEL
     lg-coser.FchVto AT ROW 1.77 COL 91 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FILL-IN-DirPro AT ROW 2.54 COL 12 COLON-ALIGNED
     lg-coser.FchEnt AT ROW 2.54 COL 91 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     lg-coser.CndCmp AT ROW 3.31 COL 12 COLON-ALIGNED
          LABEL "Forma de Pago"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
     FILL-IN-FmaPgo AT ROW 3.31 COL 18 COLON-ALIGNED NO-LABEL
     lg-coser.usuario AT ROW 3.31 COL 91 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     lg-coser.NroRef AT ROW 4.08 COL 12 COLON-ALIGNED FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 66 BY .81
     lg-coser.Codmon AT ROW 4.08 COL 93 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12 BY .77
     lg-coser.Requerimiento AT ROW 4.85 COL 12 COLON-ALIGNED
          LABEL "Requerido por"
          VIEW-AS FILL-IN 
          SIZE 66 BY .81
     lg-coser.TpoCmb AT ROW 4.85 COL 91 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     lg-coser.Proyecto AT ROW 5.62 COL 12 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     FILL-IN-Proyecto AT ROW 5.62 COL 20 COLON-ALIGNED NO-LABEL
     lg-coser.Observaciones AT ROW 6.38 COL 12 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 66 BY .81
     lg-coser.glosa AT ROW 7.15 COL 14 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 300 SCROLLBAR-VERTICAL
          SIZE 66 BY 2.42
     lg-coser.AftIgv AT ROW 7.35 COL 93 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Con IGV", yes,
"Sin IGV", no
          SIZE 10 BY 1.54
     lg-coser.LugSer AT ROW 9.65 COL 12 COLON-ALIGNED
          LABEL "Lugar de Servicio"
          VIEW-AS FILL-IN 
          SIZE 66 BY .81
     "Glosa:" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 7.35 COL 9
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 4.27 COL 87
     "Calcular:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 7.54 COL 86
     RECT-4 AT ROW 7.15 COL 82
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.lg-coser
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RUTA T "SHARED" ? INTEGRAL DI-RutaC
      TABLE: T-DOSER T "SHARED" ? INTEGRAL lg-doser
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
         HEIGHT             = 10.19
         WIDTH              = 111.
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

/* SETTINGS FOR FILL-IN lg-coser.CndCmp IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN lg-coser.CodPro IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN lg-coser.Fchdoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DirPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FlgSit IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FmaPgo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Proyecto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN lg-coser.LugSer IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN lg-coser.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN lg-coser.NroRef IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN lg-coser.NroSer IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN lg-coser.Requerimiento IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN lg-coser.usuario IN FRAME F-Main
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

&Scoped-define SELF-NAME lg-coser.AftIgv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lg-coser.AftIgv V-table-Win
ON VALUE-CHANGED OF lg-coser.AftIgv IN FRAME F-Main /* AftIgv */
DO:
  s-AftIgv = INPUT {&SELF-NAME}.
  /* CALCULAMOS EL IGV */
  DEF VAR s-PorIgv AS DEC INIT 0.
  FIND FacCfgGn WHERE faccfggn.codcia = s-codcia NO-LOCK NO-ERROR.
  IF AVAILABLE Faccfggn THEN s-PorIgv = Faccfggn.porigv.
  FOR EACH T-DOSER:
    ASSIGN
      T-DOSER.AftIgv = s-AftIgv
      T-DOSER.IgvMat = ( IF s-AftIgv = YES THEN s-PorIgv ELSE 0 )
      T-DOSER.ImpIgv = T-DOSER.imptot / (1 + T-DOSER.igvmat / 100) * T-DOSER.igvmat / 100.
  END.
  RUN Procesa-Handle IN lh_handle ('browse').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lg-coser.CndCmp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lg-coser.CndCmp V-table-Win
ON LEAVE OF lg-coser.CndCmp IN FRAME F-Main /* Forma de Pago */
DO:
  FILL-IN-FmaPgo:SCREEN-VALUE = ''.
  FIND gn-concp WHERE gn-concp.codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-concp THEN FILL-IN-FmaPgo:SCREEN-VALUE = gn-concp.nombr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lg-coser.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lg-coser.CodPro V-table-Win
ON LEAVE OF lg-coser.CodPro IN FRAME F-Main /* Proveedor */
DO:
  ASSIGN
    FILL-IN-DirPro:SCREEN-VALUE = ''
    FILL-IN-NomPro:SCREEN-VALUE = ''.
  FIND gn-prov WHERE gn-prov.codcia = PV-CODCIA
    AND gn-prov.codpro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov
  THEN ASSIGN
            FILL-IN-DirPro:SCREEN-VALUE = gn-prov.dirpro
            FILL-IN-NomPro:SCREEN-VALUE = gn-prov.nompro.
  s-CodPro = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lg-coser.NroRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lg-coser.NroRef V-table-Win
ON LEAVE OF lg-coser.NroRef IN FRAME F-Main /* Referencia */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lg-coser.Proyecto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lg-coser.Proyecto V-table-Win
ON LEAVE OF lg-coser.Proyecto IN FRAME F-Main /* Proyecto */
DO:
  FILL-IN-Proyecto:SCREEN-VALUE = ''.
  FIND Almtabla WHERE almtabla.tabla = 'PR'
    AND Almtabla.codigo = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE Almtabla THEN FILL-IN-Proyecto:SCREEN-VALUE = almtabla.nombre.
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
  {src/adm/template/row-list.i "lg-coser"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "lg-coser"}

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
  FOR EACH T-DOSER:
    DELETE T-DOSER.
  END.
  FOR EACH RUTA:
    DELETE RUTA.
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
  FOR EACH LG-DOSER OF LG-COSER NO-LOCK:
    CREATE T-DOSER.
    BUFFER-COPY LG-DOSER TO T-DOSER.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  s-HojaRuta = NO.
  RUN Procesa-Handle IN lh_handle ('Pagina2').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    FIND LG-CORR WHERE lg-corr.codcia = s-codcia 
        AND lg-corr.coddoc = s-coddoc 
        AND lg-corr.coddiv = s-coddiv NO-LOCK NO-ERROR.
    IF AVAILABLE LG-CORR
    THEN DISPLAY lg-corr.nroser @ lg-coser.nroser lg-corr.nrodoc @ lg-coser.NroDoc.
    ELSE DO:
        MESSAGE 'No existe la configuración de correlativos'
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    DISPLAY  
        TODAY @ lg-coser.Fchdoc
        TODAY @ lg-coser.Fchvto
        TODAY @ lg-coser.Fchent
        s-user-id @ lg-coser.usuario.
    FIND LAST gn-tcmb WHERE gn-tcmb.FECHA <= TODAY NO-LOCK NO-ERROR.
    IF AVAILABLE gn-tcmb 
    THEN DISPLAY gn-tcmb.compra @ lg-coser.TpoCmb.
    s-AftIgv = INPUT lg-coser.aftigv.
  END.
  RUN Borra-Temporal.
  RUN Procesa-Handle IN lh_handle ('browse-add').

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
  DEF VAR x-NroItm AS INT NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* Grabamos el detalle y calculamos totales */
  ASSIGN
    LG-COSER.Usuario = s-user-id
    LG-COSER.ImpNet = 0
    LG-COSER.ImpIgv = 0
    LG-COSER.ImpTot = 0.
  FOR EACH LG-DOSER OF LG-COSER:
    DELETE LG-DOSER.
  END.
  x-NroItm = 1.
  FOR EACH T-DOSER BY T-DOSER.NroItm:
    CREATE LG-DOSER.
    BUFFER-COPY T-DOSER TO LG-DOSER
        ASSIGN LG-DOSER.codcia = LG-COSER.codcia
                LG-DOSER.coddoc = LG-COSER.coddoc
                LG-DOSER.nroser = LG-COSER.nroser
                LG-DOSER.nrodoc = LG-COSER.nrodoc
                LG-DOSER.nroitm = x-NroItm.
    x-NroItm = x-NroItm + 1.
    ASSIGN
        LG-COSER.ImpTot = LG-COSER.ImpTot + LG-DOSER.ImpTot
        LG-COSER.ImpIgv = LG-COSER.ImpIgv + LG-DOSER.ImpIgv.
  END.
  ASSIGN
    LG-COSER.ImpNet = LG-COSER.ImpTot - LG-COSER.ImpIgv.

  /* RHC 14.07.06 Marcamos las hojas de ruta */
  IF s-HojaRuta = YES THEN DO:
    FOR EACH RUTA:
      FIND Di-RutaC OF RUTA EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE Di-RutaC THEN DO:
          Di-RutaC.CodCob = STRING(Lg-coser.nrodoc).
          RELEASE Di-RutaC.
      END.
      DELETE RUTA.
    END.
  END.
    
  RUN Procesa-Handle IN lh_handle ('pagina1').
  RUN Procesa-Handle IN lh_handle ('browse').
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
  s-HojaRuta = NO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('Pagina1').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  MESSAGE '¿Copia también el detalle?' VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO-CANCEL UPDATE rpta-1 AS LOG.
  IF rpta-1 = ? THEN RETURN 'ADM-ERROR'.
  IF rpta-1 = YES 
  THEN RUN Carga-Temporal.
  ELSE RUN Borra-Temporal.
  s-AftIgv = LG-COSER.AftIgv.
  s-CodPro = lg-coser.CodPro.
  s-HojaRuta = NO.
  RUN Procesa-Handle IN lh_handle ('Pagina2').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    FIND LG-CORR WHERE lg-corr.codcia = s-codcia 
        AND lg-corr.coddoc = s-coddoc 
        AND lg-corr.coddiv = s-coddiv NO-LOCK NO-ERROR.
    IF AVAILABLE LG-CORR
    THEN DISPLAY lg-corr.nroser @ lg-coser.nroser lg-corr.nrodoc @ lg-coser.NroDoc.
    ELSE DO:
        MESSAGE 'No existe la configuración de correlativos'
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    DISPLAY  
        TODAY @ lg-coser.Fchdoc
        TODAY @ lg-coser.Fchvto
        TODAY @ lg-coser.Fchent
        s-user-id @ lg-coser.usuario.
    FIND LAST gn-tcmb WHERE gn-tcmb.FECHA <= TODAY NO-LOCK NO-ERROR.
    IF AVAILABLE gn-tcmb 
    THEN DISPLAY gn-tcmb.compra @ lg-coser.TpoCmb.
  END.
  RUN Procesa-Handle IN lh_handle ('browse-add').

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
  FIND LG-CORR WHERE LG-CORR.codcia = s-codcia
    AND LG-CORR.coddiv = s-coddiv
    AND LG-CORR.coddoc = s-coddoc
    EXCLUSIVE-LOCK NO-ERROR.
  IF ERROR-STATUS:ERROR = YES
  THEN DO:
    MESSAGE 'No se pudo actualizar el control de correlativos'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    lg-coser.CodCia = s-codcia
    lg-coser.CodDoc = s-coddoc
    lg-coser.NroSer = LG-CORR.nroser
    lg-coser.NroDoc = LG-CORR.nrodoc
    lg-coser.Fchdoc = TODAY
    lg-coser.FlgSit = 'G'   /* Emitido */
    LG-CORR.nrodoc  = LG-CORR.nrodoc + 1.
  RELEASE LG-CORR.

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
  IF LG-COSER.FlgSit <> 'G'
  THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  RUN ALM/D-CLAVE ('servicio',OUTPUT RPTA).  
  IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".

/* USAMOS RUTINA PROPIA
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
*/
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR':
    /* Solo marcamos la orden como anulada */
    FIND CURRENT LG-COSER EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN UNDO, RETURN 'ADM-ERROR'.

    /* Extorno de Hojas de Ruta */
    FOR EACH Di-RutaC WHERE Di-rutac.codcia = s-codcia
            AND Di-rutac.coddoc = 'H/R'
            AND Di-Rutac.flgest <> 'A'
            AND Di-Rutac.codcob <> '',
            FIRST Gn-vehic NO-LOCK WHERE Gn-vehic.codcia = s-codcia
                AND Gn-vehic.placa = Di-rutac.codveh
                AND Gn-vehic.codpro = Lg-coser.codpro:
        IF INTEGER(Di-rutac.codcob) = Lg-coser.nrodoc THEN Di-rutac.codcob = ''.
    END.                

    ASSIGN
        LG-COSER.FlgSit = 'A'.
    FIND CURRENT LG-COSER NO-LOCK NO-ERROR.
    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
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
  IF AVAILABLE LG-COSER THEN DO WITH FRAME {&FRAME-NAME}:
    CASE LG-COSER.FlgSit:
        WHEN 'G' THEN FILL-IN-FlgSit:SCREEN-VALUE = 'Emitida'.
        WHEN 'P' THEN FILL-IN-FlgSit:SCREEN-VALUE = 'Aprobada'.
        WHEN 'A' THEN FILL-IN-FlgSit:SCREEN-VALUE = 'Anulada'.
        WHEN 'C' THEN FILL-IN-FlgSit:SCREEN-VALUE = 'Cerrada'.
        WHEN 'X' THEN FILL-IN-FlgSit:SCREEN-VALUE = 'Rechazada'.
        OTHERWISE FILL-IN-FlgSit:SCREEN-VALUE = '???'.
    END CASE.
    ASSIGN
        FILL-IN-DirPro:SCREEN-VALUE = ''
        FILL-IN-NomPro:SCREEN-VALUE = ''.
    FIND gn-prov WHERE gn-prov.codcia = PV-CODCIA
        AND gn-prov.codpro = lg-coser.codpro
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov
    THEN ASSIGN
            FILL-IN-DirPro:SCREEN-VALUE = gn-prov.dirpro
            FILL-IN-NomPro:SCREEN-VALUE = gn-prov.nompro.
    ASSIGN
        FILL-IN-FmaPgo:SCREEN-VALUE = ''.
    FIND gn-concp WHERE gn-concp.codig = lg-coser.CndCmp NO-LOCK NO-ERROR.
    IF AVAILABLE gn-concp
    THEN ASSIGN
            FILL-IN-FmaPgo:SCREEN-VALUE = gn-concp.Nombr.

    FILL-IN-Proyecto:SCREEN-VALUE = ''.
    FIND Almtabla WHERE almtabla.tabla = 'PR'
        AND Almtabla.codigo = lg-coser.Proyecto
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtabla THEN FILL-IN-Proyecto:SCREEN-VALUE = almtabla.nombre.
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

DEFINE VAR lRucCia AS CHAR.

  /* Code placed here will execute PRIOR to standard behavior. */
  IF AVAILABLE Lg-Coser AND LOOKUP(Lg-Coser.flgsit, 'P,G') = 0 THEN DO:
    MESSAGE 'No se puede imprimir la orden' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
  END.

    IF s-nomcia MATCHES '*CONTINENTAL*' THEN DO:
        lRucCia  = "RUC : 20100038146".
    END.
    ELSE lRucCia = "RUC : 20511358907".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  CASE LG-COSER.CodDoc:
    WHEN 'O/S' THEN RB-REPORT-NAME = 'Orden de Servicio'.
    WHEN 'OCA' THEN RB-REPORT-NAME = 'Compra Administrativa'.
    OTHERWISE RETURN.
  END CASE.
  RB-INCLUDE-RECORDS = 'O'.
  RB-FILTER = "lg-coser.codcia = " + STRING(lg-coser.codcia) +
                " AND lg-coser.coddoc = '" + TRIM(s-coddoc) + "'" +
                " AND lg-coser.nroser = " + STRING(lg-coser.nroser) +
                " AND lg-coser.nrodoc = " + STRING(lg-coser.nrodoc).
  RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia +
                        "~ns-ruccia = " + STRING(s-ruccia) + 
                        "~ns-ruc = " + lRucCia.
  RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                    RB-REPORT-NAME,
                    RB-INCLUDE-RECORDS,
                    RB-FILTER,
                    RB-OTHER-PARAMETERS).
  
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
    CASE s-coddoc:
        WHEN 'O/S' THEN lg-coser.lugser:LABEL = 'Lugar de Servicio'.
        WHEN 'OCA' THEN lg-coser.lugser:LABEL = 'Lugar de Entrega'.
    END CASE.
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
  s-HojaRuta = NO.

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
        WHEN "Proyecto" THEN 
            ASSIGN
                input-var-1 = "PR"
                input-var-2 = ""
                input-var-3 = "".
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
  {src/adm/template/snd-list.i "lg-coser"}

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
     RUN Carga-Temporal.
     RUN Procesa-Handle IN lh_handle ('pagina2').
     RUN Procesa-Handle IN lh_handle ('browse-add').
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
    FIND gn-prov WHERE gn-prov.codcia = PV-CODCIA 
        AND gn-prov.codpro = lg-coser.CodPro:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-prov
    THEN DO:
        MESSAGE 'Proveedor no registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY' TO lg-coser.CodPro.
        RETURN 'ADM-ERROR'.
    END.        
    FIND gn-concp WHERE gn-concp.codig = lg-coser.CndCmp:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-concp
    THEN DO:
        MESSAGE 'Condicion de Venta no registrada' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY' TO lg-coser.CndCmp.
        RETURN 'ADM-ERROR'.
    END.        
    IF lg-coser.Proyecto:SCREEN-VALUE <> ''
    THEN DO:
        FIND Almtabla WHERE almtabla.tabla = 'PR'
            AND Almtabla.codigo = lg-coser.Proyecto:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtabla
        THEN DO:
            MESSAGE 'Codigo del proyecto no valido' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO lg-coser.proyecto.
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
  IF LG-COSER.FlgSit <> 'G'
  THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.

  /* INICIALIZAMOS VARIABLE */
  IF TODAY - lg-coser.Fchdoc > 2 THEN DO:
    RUN ALM/D-CLAVE ('servicio',OUTPUT RPTA).  
    IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
  END.
  s-AftIgv = LG-COSER.AftIgv.
  s-CodPro = lg-coser.CodPro.
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

