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

/* Local Variable Definitions ---                                       */


/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR  S-CODCIA  AS INTEGER.
DEFINE SHARED VAR  S-USER-ID AS CHAR.
DEFINE VAR wcambio AS DECIMAL.
DEFINE VAR cl-codcia  AS INTEGER INITIAL 0 NO-UNDO.

FIND Empresas WHERE Empresas.CodCia = S-CODCIA NO-LOCK NO-ERROR.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = S-CODCIA.

FIND gn-LinUsr WHERE gn-LinUsr.Usuario = S-USER-ID NO-LOCK NO-ERROR.
FIND FIRST FacCfgGn  WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
wcambio = FacCfgGn.Tpocmb[1].

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
&Scoped-define EXTERNAL-TABLES gn-clie
&Scoped-define FIRST-EXTERNAL-TABLE gn-clie


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR gn-clie.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS gn-clie.Ruc gn-clie.ApePat gn-clie.ApeMat ~
gn-clie.Nombre gn-clie.NomCli gn-clie.E-Mail gn-clie.DirCli gn-clie.FaxCli ~
gn-clie.DirEnt gn-clie.Libre_L02 gn-clie.CndVta 
&Scoped-define ENABLED-TABLES gn-clie
&Scoped-define FIRST-ENABLED-TABLE gn-clie
&Scoped-Define ENABLED-OBJECTS RECT-31 RECT-33 
&Scoped-Define DISPLAYED-FIELDS gn-clie.Fching gn-clie.CodCli ~
gn-clie.Flgsit gn-clie.FchCes gn-clie.Ruc gn-clie.CodUnico gn-clie.ApePat ~
gn-clie.ApeMat gn-clie.Nombre gn-clie.FchAut[1] gn-clie.NomCli ~
gn-clie.E-Mail gn-clie.DirCli gn-clie.FaxCli gn-clie.DirEnt gn-clie.MonLC ~
gn-clie.UsrAut gn-clie.Libre_L02 gn-clie.CndVta gn-clie.clfCli ~
gn-clie.ClfCli2 
&Scoped-define DISPLAYED-TABLES gn-clie
&Scoped-define FIRST-DISPLAYED-TABLE gn-clie
&Scoped-Define DISPLAYED-OBJECTS f-ConVta f-ClfCli 

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
DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 4 BY .81 TOOLTIP "Seleccionar condiciones de venta".

DEFINE VARIABLE f-ClfCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY .81 NO-UNDO.

DEFINE VARIABLE f-ConVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 100 BY 6.46.

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 100 BY 6.73.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     gn-clie.Fching AT ROW 1.27 COL 74 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     gn-clie.CodCli AT ROW 1.54 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 15 FGCOLOR 1 
     gn-clie.Flgsit AT ROW 1.58 COL 30 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Activo", "A":U,
"Cesado", "C":U
          SIZE 16 BY .77
     gn-clie.FchCes AT ROW 2.04 COL 74 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     gn-clie.Ruc AT ROW 2.35 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 15 FGCOLOR 4 
     gn-clie.CodUnico AT ROW 2.35 COL 39 COLON-ALIGNED WIDGET-ID 4
          LABEL "Cod. Unico"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 15 FGCOLOR 12 
     gn-clie.ApePat AT ROW 3.15 COL 16 COLON-ALIGNED WIDGET-ID 8
          LABEL "Ap. Paterno"
          VIEW-AS FILL-IN 
          SIZE 27 BY .81
          BGCOLOR 11 FGCOLOR 9 
     gn-clie.ApeMat AT ROW 3.15 COL 53 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 30 BY .81
          BGCOLOR 11 FGCOLOR 9 
     gn-clie.Nombre AT ROW 3.96 COL 16 COLON-ALIGNED WIDGET-ID 10
          LABEL "Nombre/Razón Social" FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 50 BY .81
          BGCOLOR 11 FGCOLOR 9 
     gn-clie.FchAut[1] AT ROW 4.46 COL 74 COLON-ALIGNED
          LABEL "F. Autoriz."
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     gn-clie.NomCli AT ROW 4.77 COL 16 COLON-ALIGNED FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 50 BY .81
     gn-clie.E-Mail AT ROW 5.23 COL 74 COLON-ALIGNED FORMAT "X(50)"
          VIEW-AS FILL-IN 
          SIZE 24 BY .81
     gn-clie.DirCli AT ROW 5.58 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 50 BY .81
     gn-clie.FaxCli AT ROW 6 COL 74 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     gn-clie.DirEnt AT ROW 6.38 COL 16 COLON-ALIGNED
          LABEL "Entregar en"
          VIEW-AS FILL-IN 
          SIZE 50 BY .81
     gn-clie.MonLC AT ROW 7.73 COL 18 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 13 BY .81
     gn-clie.UsrAut AT ROW 7.77 COL 62 COLON-ALIGNED
          LABEL "Autorizacion Finanzas"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     gn-clie.Libre_L02 AT ROW 8.88 COL 18 WIDGET-ID 36
          LABEL "Solo OpenOrange"
          VIEW-AS TOGGLE-BOX
          SIZE 15 BY .77
     gn-clie.CndVta AT ROW 10.42 COL 16 COLON-ALIGNED FORMAT "X(256)"
          VIEW-AS FILL-IN 
          SIZE 45 BY .81
     BUTTON-1 AT ROW 10.42 COL 63 WIDGET-ID 2
     f-ConVta AT ROW 11.23 COL 16 COLON-ALIGNED NO-LABEL
     gn-clie.clfCli AT ROW 12.12 COL 28.72 COLON-ALIGNED
          LABEL "Clasificacion productos PROPIOS"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     f-ClfCli AT ROW 12.12 COL 35 COLON-ALIGNED NO-LABEL
     gn-clie.ClfCli2 AT ROW 13.19 COL 31 NO-LABEL WIDGET-ID 12
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "A++", "A++":U,
"A+", "A+":U,
"A-", "A-":U,
"Sin clasificacion", ""
          SIZE 35 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "Clasificacion productos de TERCEROS:" VIEW-AS TEXT
          SIZE 27 BY .5 AT ROW 13.38 COL 4 WIDGET-ID 18
     "Informacion General" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 1 COL 2
          BGCOLOR 1 FGCOLOR 15 
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 7.92 COL 11
     "Linea de Credito" VIEW-AS TEXT
          SIZE 12 BY .5 AT ROW 7.19 COL 2
          BGCOLOR 1 FGCOLOR 15 
     RECT-31 AT ROW 1.04 COL 1
     RECT-33 AT ROW 7.46 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.gn-clie
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
         HEIGHT             = 15
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN gn-clie.ApePat IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR BUTTON BUTTON-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.clfCli IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR RADIO-SET gn-clie.ClfCli2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.CndVta IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN gn-clie.CodCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.CodUnico IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN gn-clie.DirEnt IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.E-Mail IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN f-ClfCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-ConVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.FchAut[1] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN gn-clie.FchCes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.Fching IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET gn-clie.Flgsit IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX gn-clie.Libre_L02 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR RADIO-SET gn-clie.MonLC IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.Nombre IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.NomCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN gn-clie.UsrAut IN FRAME F-Main
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

&Scoped-define SELF-NAME gn-clie.ApeMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.ApeMat V-table-Win
ON LEAVE OF gn-clie.ApeMat IN FRAME F-Main /* Ap. Materno */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    gn-clie.nomcli:SCREEN-VALUE = TRIM (gn-clie.apepat:SCREEN-VALUE) + " " +
        TRIM (gn-clie.apemat:SCREEN-VALUE) + ", " +
        gn-clie.nombre:SCREEN-VALUE.
    IF gn-clie.apepat:SCREEN-VALUE = '' AND gn-clie.apemat:SCREEN-VALUE = '' 
    THEN gn-clie.nomcli:SCREEN-VALUE = gn-clie.nombre:SCREEN-VALUE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.ApePat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.ApePat V-table-Win
ON LEAVE OF gn-clie.ApePat IN FRAME F-Main /* Ap. Paterno */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    gn-clie.nomcli:SCREEN-VALUE = TRIM (gn-clie.apepat:SCREEN-VALUE) + " " +
        TRIM (gn-clie.apemat:SCREEN-VALUE) + ", " +
        gn-clie.nombre:SCREEN-VALUE.
    IF gn-clie.apepat:SCREEN-VALUE = '' AND gn-clie.apemat:SCREEN-VALUE = '' 
    THEN gn-clie.nomcli:SCREEN-VALUE = gn-clie.nombre:SCREEN-VALUE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 V-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:
    DEF VAR x-Condiciones AS CHAR.
    DEF VAR x-Descripcion AS CHAR.
    x-Condiciones = gn-clie.CndVta:SCREEN-VALUE.
    x-Descripcion = f-ConVta:SCREEN-VALUE.
    RUN vta/d-repo10 (INPUT-OUTPUT x-Condiciones, INPUT-OUTPUT x-Descripcion).
    gn-clie.CndVta:SCREEN-VALUE = x-Condiciones.
    f-convta:SCREEN-VALUE = x-Descripcion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.clfCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.clfCli V-table-Win
ON LEAVE OF gn-clie.clfCli IN FRAME F-Main /* Clasificacion productos PROPIOS */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  f-ClfCli:SCREEN-VALUE = 'SIN CLASIFICACION'.
  FIND ClfClie WHERE ClfClie.Categoria = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE ClfClie THEN f-ClfCli:SCREEN-VALUE = ClfClie.DesCat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.CndVta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.CndVta V-table-Win
ON LEAVE OF gn-clie.CndVta IN FRAME F-Main /* Condicion de Venta */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO:
     FIND gn-convt WHERE gn-convt.Codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt 
     THEN F-ConVta:screen-value = gn-convt.Nombr.
     ELSE F-Convta:screen-value = "".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.Nombre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.Nombre V-table-Win
ON LEAVE OF gn-clie.Nombre IN FRAME F-Main /* Nombre/Razón Social */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    gn-clie.nomcli:SCREEN-VALUE = TRIM (gn-clie.apepat:SCREEN-VALUE) + " " +
        TRIM (gn-clie.apemat:SCREEN-VALUE) + ", " +
        gn-clie.nombre:SCREEN-VALUE.
    IF gn-clie.apepat:SCREEN-VALUE = '' AND gn-clie.apemat:SCREEN-VALUE = '' 
    THEN gn-clie.nomcli:SCREEN-VALUE = gn-clie.nombre:SCREEN-VALUE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.Ruc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.Ruc V-table-Win
ON LEAVE OF gn-clie.Ruc IN FRAME F-Main /* Ruc */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    IF LENGTH(SELF:SCREEN-VALUE) < 11 OR LOOKUP(SUBSTRING(SELF:SCREEN-VALUE,1,2), '10,20,15') = 0 THEN DO:
        MESSAGE 'Debe tener 11 dígitos y comenzar con 20, 10 ó 15' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    /* dígito verificador */
    DEF VAR pResultado AS CHAR.
    RUN lib/_ValRuc (SELF:SCREEN-VALUE, OUTPUT pResultado).
    IF pResultado = 'ERROR' THEN DO:
        MESSAGE 'Código MAL registrado' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
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
  {src/adm/template/row-list.i "gn-clie"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "gn-clie"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-FchCes AS DATE.
  DEF VAR x-FchAut AS DATE.
  DEF VAR x-FlagAut AS CHAR.
  DEF VAR s-LogTabla AS LOG INIT NO.
  
  /* Code placed here will execute PRIOR to standard behavior. */
  IF GN-CLIE.FlgSit = 'C'
  THEN x-FchCes = GN-CLIE.FchCes.        /* Antes de grabar los cambios */
  ELSE x-FchCes = TODAY.
  ASSIGN
    x-FchAut = GN-CLIE.FchAut[1]
    x-FlagAut = GN-CLIE.FlagAut.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  /* SOLO SE MODIFICA */
  gn-clie.MonLC = 2.
  /* **************** */

  IF Gn-clie.FlagAut = 'A' AND Gn-clie.FlagAut <> x-FlagAut 
  THEN ASSIGN
        Gn-clie.FchAut[1] = TODAY.
  ELSE ASSIGN
        Gn-clie.FchAut[1] = ?.
  IF gn-clie.impLC > 0 THEN DO:
     ASSIGN
        gn-clie.usrLC = S-USER-ID.
  END.
  ELSE DO:       
     ASSIGN
        gn-clie.usrLC = "".
  END.
  IF gn-clie.flagAut <> "" THEN DO:
     ASSIGN
        gn-clie.usrAut = S-USER-ID.
  END.
  ELSE DO:
     ASSIGN
        gn-clie.usrAut = "".
  END.      
     
  IF gn-clie.Flgsit = 'C'  
  THEN gn-clie.FchCes = x-FchCes.       /* despues de grabar los cambios */
  ELSE gn-clie.FchCes = ?.
  
  /* RHC 05.10.04 Historico de lineas de credito */
  CREATE LogTabla.
  ASSIGN
    logtabla.codcia = s-codcia
    logtabla.Dia = TODAY
    logtabla.Evento = 'LINEA-CREDITO-A'
    logtabla.Hora = STRING(TIME, 'HH:MM')
    logtabla.Tabla = 'GN-CLIE'
    logtabla.Usuario = s-user-id
    logtabla.ValorLlave = STRING(gn-clie.codcli, 'x(11)') + '|' +
                            STRING(gn-clie.nomcli, 'x(50)') + '|' +
                            STRING(gn-clie.FlagAut, 'X').
  RELEASE LogTabla.

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  
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
  FOR EACH Gn-CLieB OF Gn-Clie:
    DELETE Gn-ClieB.
  END.
  FOR EACH Gn-CLieD OF Gn-Clie:
    DELETE Gn-ClieD.
  END.
  FOR EACH Gn-CLieL OF Gn-Clie:
    DELETE Gn-ClieL.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      BUTTON-1:SENSITIVE = NO.
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
  DEF VAR k AS INT NO-UNDO.
  DEF VAR i AS INT INIT 1 NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE GN-CLIE THEN DO WITH FRAME {&FRAME-NAME}:
    /*
    FIND gn-convt WHERE gn-convt.Codig = gn-clie.CndVta NO-LOCK NO-ERROR.
    IF AVAILABLE  gn-convt THEN DISPLAY gn-ConVt.Nombr @ f-ConVta.
    */
  DO k = 1 TO NUM-ENTRIES(gn-clie.cndvta):
      FIND gn-convt WHERE gn-convt.codig = ENTRY(k, gn-clie.cndvta) NO-LOCK NO-ERROR.
      IF AVAILABLE gn-convt THEN DO:
          IF i = 1 
          THEN ASSIGN
                  f-convta:SCREEN-VALUE = TRIM(gn-convt.nombr).
          ELSE ASSIGN
                  f-convta:SCREEN-VALUE = f-convta:SCREEN-VALUE + ',' + TRIM(gn-convt.nombr).
          i = i + 1.
      END.
  END.

    f-ClfCli = 'SIN CLASIFICACION'.
    FIND ClfClie WHERE ClfClie.Categoria = gn-clie.clfCli NO-LOCK NO-ERROR.
    IF AVAILABLE ClfClie THEN f-ClfCli:SCREEN-VALUE = ClfClie.DesCat.
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
      gn-clie.CndVta:SENSITIVE = NO.
      BUTTON-1:SENSITIVE = YES.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE riesgo-crediticio V-table-Win 
PROCEDURE riesgo-crediticio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pBuscarComoDNI AS LOG.

IF NOT AVAILABLE gn-clie THEN RETURN.

DEFINE VAR lTipoDoc AS CHAR.
DEFINE VAR lNroDoc AS CHAR.
DEFINE VAR lParameter AS CHAR.

ltipodoc = "".
lnrodoc = "".

IF AVAILABLE gn-clie THEN DO:
    if TRUE <> (gn-clie.ruc > "") THEN DO:
        MESSAGE "Codigo de CLiente(" + gn-clie.codcli + ") no tiene RUC ni tampoco DNI".
    END.
    ELSE DO:
        lnrodoc = gn-clie.ruc.
        IF LENGTH(gn-clie.ruc)=8 THEN ltipodoc = 'D'.
        IF LENGTH(gn-clie.ruc)=11 THEN ltipodoc = 'R'.
        IF ltipodoc <> "" THEN DO:
            IF ltipodoc = 'R' THEN DO:
                /* Buscar con DNI */
                IF SUBSTRING(gn-clie.ruc,1,2)='10' AND pBuscarComoDNI THEN DO:
                    ltipodoc = 'D'.
                    lnrodoc = SUBSTRING(gn-clie.ruc,3,8).
                END.
            END.
            /* - */
            lParameter = lTipoDoc + "|" + lNroDoc.
            /*RUN ccb/w-sentinel-rcrediticio.r(INPUT ltipodoc, INPUT lnrodoc).*/
            RUN ccb/w-sentinel-rcrediticio.r(INPUT lParameter).
        END.
        ELSE DO:
            MESSAGE "Imposible identificar si es un RUC o DNI".
        END.
    END.
END.


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
  {src/adm/template/snd-list.i "gn-clie"}

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
    IF gn-clie.ClfCli:SCREEN-VALUE <> ''
    THEN DO:
        FIND ClfClie WHERE ClfClie.Categoria = gn-clie.clfCli:SCREEN-VALUE 
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ClfClie
        THEN DO:
            MESSAGE 'La clasificacion del cliente esta errada'
                VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-clie.ClfCli.
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
FIND gn-LinUsr WHERE gn-LinUsr.Usuario = S-USER-ID NO-LOCK NO-ERROR.
IF NOT AVAILABLE Gn-LinUsr THEN DO:
    MESSAGE 'El usuario NO tiene autorización para modificar la línea de crédito'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

