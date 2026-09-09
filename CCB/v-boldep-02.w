&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.



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
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddoc  AS CHAR.
DEF SHARED VAR s-coddiv  AS CHAR.
DEF SHARED VAR s-nomcia  AS CHAR.
DEF SHARED VAR s-NroSer LIKE Faccorre.nroser.
DEF SHARED VAR cl-codcia AS INT.

DEFINE VAR W-TpoFac AS CHAR.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEF BUFFER b-Ccbcdocu FOR Ccbcdocu.

DEFINE STREAM report.

FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia no-lock.

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
&Scoped-define EXTERNAL-TABLES Ccbcdocu
&Scoped-define FIRST-EXTERNAL-TABLE Ccbcdocu


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Ccbcdocu.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCDocu.FmaPgo CcbCDocu.FchAte ~
CcbCDocu.FlgAte CcbCDocu.NroRef CcbCDocu.TpoFac CcbCDocu.CodCta ~
CcbCDocu.CodAge CcbCDocu.ImpTot CcbCDocu.CodCli CcbCDocu.CodDiv 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define ENABLED-OBJECTS RECT-40 RECT-29 RECT-39 
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.FlgSit CcbCDocu.FmaPgo CcbCDocu.FchAte CcbCDocu.FlgAte ~
CcbCDocu.CodMon CcbCDocu.NroRef CcbCDocu.TpoFac CcbCDocu.TpoCmb ~
CcbCDocu.CodCta CcbCDocu.Glosa CcbCDocu.CodAge CcbCDocu.ImpTot ~
CcbCDocu.SdoAct CcbCDocu.CodCli CcbCDocu.NomCli CcbCDocu.CodDiv ~
CcbCDocu.FlgUbi CcbCDocu.FchUbi CcbCDocu.usuario 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS F-Estado x-Nombr x-NomBco FILL-IN-Moneda ~
FILL-IN-NomDiv 

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
DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .81
     FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-Moneda AS CHARACTER FORMAT "X(256)":U INITIAL "S/." 
     LABEL "Importe Total" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81
     FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE FILL-IN-NomDiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomBco AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .81 NO-UNDO.

DEFINE VARIABLE x-Nombr AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 1.31.

DEFINE RECTANGLE RECT-39
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 6.15.

DEFINE RECTANGLE RECT-40
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 4.04.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.NroDoc AT ROW 1.27 COL 6 COLON-ALIGNED FORMAT "XXX-XXXXXXXX"
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .81
          FONT 0
     CcbCDocu.FchDoc AT ROW 1.27 COL 25.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.FlgSit AT ROW 1.27 COL 43 COLON-ALIGNED
          LABEL "Situacion" FORMAT "X(10)"
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Pendiente","Autorizada","Rechazada" 
          DROP-DOWN-LIST
          SIZE 11.29 BY 1
     F-Estado AT ROW 1.27 COL 55.29 COLON-ALIGNED NO-LABEL
     CcbCDocu.FmaPgo AT ROW 2.54 COL 14 COLON-ALIGNED
          LABEL "Cond de Venta" FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     x-Nombr AT ROW 2.54 COL 22 COLON-ALIGNED NO-LABEL
     CcbCDocu.FchAte AT ROW 2.54 COL 62 COLON-ALIGNED
          LABEL "Fecha de Depósito"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.FlgAte AT ROW 3.5 COL 14 COLON-ALIGNED
          LABEL "Banco" FORMAT "X(3)"
          VIEW-AS COMBO-BOX INNER-LINES 5
          DROP-DOWN-LIST
          SIZE 8 BY 1
     x-NomBco AT ROW 3.5 COL 23 COLON-ALIGNED NO-LABEL
     CcbCDocu.CodMon AT ROW 3.5 COL 64 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12 BY .81
     CcbCDocu.NroRef AT ROW 4.46 COL 14 COLON-ALIGNED
          LABEL "Nro. Deposito" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     CcbCDocu.TpoFac AT ROW 4.46 COL 31 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Efectivo", "EFE":U,
"Cheque", "CHQ":U
          SIZE 18.72 BY .81
     CcbCDocu.TpoCmb AT ROW 4.46 COL 62 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbCDocu.CodCta AT ROW 5.42 COL 14 COLON-ALIGNED
          LABEL "Codigo de Cuenta"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbCDocu.Glosa AT ROW 5.42 COL 23 COLON-ALIGNED NO-LABEL FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 49 BY .81
     CcbCDocu.CodAge AT ROW 6.38 COL 16 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Lima", "Lima":U,
"Provincia", "Provincia":U,
"Otros", "Otros":U
          SIZE 27 BY .77
     FILL-IN-Moneda AT ROW 7.35 COL 14 COLON-ALIGNED
     CcbCDocu.ImpTot AT ROW 7.35 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     CcbCDocu.SdoAct AT ROW 7.35 COL 58 COLON-ALIGNED
          LABEL "Saldo Actual"
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     CcbCDocu.CodCli AT ROW 8.69 COL 14 COLON-ALIGNED
          LABEL "Cliente" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
     CcbCDocu.NomCli AT ROW 8.73 COL 28.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 37.14 BY .81
     CcbCDocu.CodDiv AT ROW 9.65 COL 14 COLON-ALIGNED
          LABEL "Division" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     FILL-IN-NomDiv AT ROW 9.65 COL 24 COLON-ALIGNED NO-LABEL
     CcbCDocu.FlgUbi AT ROW 10.5 COL 14 COLON-ALIGNED
          LABEL "Autorizó" FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     CcbCDocu.FchUbi AT ROW 10.5 COL 40.57 COLON-ALIGNED
          LABEL "Fecha Autorizacion"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.usuario AT ROW 11.38 COL 14 COLON-ALIGNED
          LABEL "Solicitante"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     "Plaza:" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 6.38 COL 11
     "Moneda" VIEW-AS TEXT
          SIZE 6.57 BY .81 AT ROW 3.5 COL 57
     RECT-40 AT ROW 8.5 COL 1
     RECT-29 AT ROW 1 COL 1
     RECT-39 AT ROW 2.35 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.Ccbcdocu
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
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
         HEIGHT             = 11.54
         WIDTH              = 77.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
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

/* SETTINGS FOR FILL-IN CcbCDocu.CodCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.CodCta IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.CodDiv IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR RADIO-SET CcbCDocu.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchAte IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchUbi IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FILL-IN-Moneda IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX CcbCDocu.FlgAte IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR COMBO-BOX CcbCDocu.FlgSit IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.FlgUbi IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.FmaPgo IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.Glosa IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NroRef IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.SdoAct IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.TpoCmb IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN x-NomBco IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-Nombr IN FRAME F-Main
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME CcbCDocu.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodCli V-table-Win
ON LEAVE OF CcbCDocu.CodCli IN FRAME F-Main /* Cliente */
DO:
  IF SELF:SCREEN-VALUE = "" THEN DO:
     DISPLAY 
        "" @ Ccbcdocu.NomCli 
        WITH FRAME {&FRAME-NAME}.
    RETURN.
  END.    
  FIND gn-clie WHERE gn-clie.codcia = cl-codcia
                AND  gn-clie.codcli = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN DO:
    MESSAGE "Cliente no registrado" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  DISPLAY 
    gn-clie.nomcli @ Ccbcdocu.NomCli 
/*    gn-clie.ruc @ FILL-IN_Ruc */
    WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.CodCta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodCta V-table-Win
ON LEAVE OF CcbCDocu.CodCta IN FRAME F-Main /* Codigo de Cuenta */
DO:
  IF SELF:SCREEN-VALUE = "" THEN DO:
     DISPLAY 
        "" @ Ccbcdocu.CodCta 
        WITH FRAME {&FRAME-NAME}.
    RETURN.
  END.    
                 
  FIND cb-ctas WHERE cb-ctas.codcia = cl-codcia
                AND  cb-ctas.Codcta = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE cb-ctas THEN DO:
    MESSAGE "Cuenta no registrado" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  Ccbcdocu.CodMon:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(cb-ctas.Codmon).
  Ccbcdocu.Glosa:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cb-ctas.Nomcta. 
  IF cb-ctas.codmon = 1
  THEN FILL-IN-Moneda:SCREEN-VALUE = 'S/.'.
  ELSE FILL-IN-Moneda:SCREEN-VALUE = 'US$'.
  DISPLAY 
    cb-ctas.Codcta @ Ccbcdocu.Codcta 
    cb-ctas.Nomcta @ Ccbcdocu.Glosa WITH FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodDiv V-table-Win
ON LEAVE OF CcbCDocu.CodDiv IN FRAME F-Main /* Division */
DO:
  FIND GN-DIVI WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
  IF AVAILABLE GN-DIVI THEN FILL-IN-NomDiv:SCREEN-VALUE = GN-DIVI.DesDiv.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.FchDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.FchDoc V-table-Win
ON LEAVE OF CcbCDocu.FchDoc IN FRAME F-Main /* Fecha */
DO:
    FIND gn-tcmb WHERE gn-tcmb.fecha = DATE(Ccbcdocu.FchDoc:SCREEN-VALUE) NO-LOCK NO-ERROR.
    IF AVAIL gn-tcmb THEN 
    DISPLAY 
        gn-tcmb.compra @ Ccbcdocu.TpoCmb WITH FRAME {&FRAME-NAME}.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.FlgAte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.FlgAte V-table-Win
ON VALUE-CHANGED OF CcbCDocu.FlgAte IN FRAME F-Main /* Banco */
DO:
  FIND cb-tabl WHERE cb-tabl.tabla = '04'
    AND cb-tabl.codigo = SELF:SCREEN-VALUE NO-LOCK.
  x-NomBco:SCREEN-VALUE = cb-tabl.Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.FmaPgo V-table-Win
ON LEAVE OF CcbCDocu.FmaPgo IN FRAME F-Main /* Cond de Venta */
DO:
  x-Nombr:SCREEN-VALUE = ''.
  FIND Gn-convt WHERE Gn-convt.codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-convt THEN x-Nombr:SCREEN-VALUE = Gn-convt.nombr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.NroRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.NroRef V-table-Win
ON LEAVE OF CcbCDocu.NroRef IN FRAME F-Main /* Nro. Deposito */
DO:
  ASSIGN
    SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE), '99999999')
    NO-ERROR.
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
  {src/adm/template/row-list.i "Ccbcdocu"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Ccbcdocu"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND Faccorre WHERE Faccorre.codcia = s-codcia
    AND Faccorre.coddiv = s-coddiv
    AND Faccorre.coddoc = s-coddoc
    AND Faccorre.nroser = s-nroser
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccorre THEN DO:
    MESSAGE 'No pudo encontrar el control de correlativos'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */

  DO WITH FRAME {&FRAME-NAME}:
    FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= TODAY NO-LOCK NO-ERROR.
    DISPLAY 
        STRING(s-NroSer, '999') + STRING(Faccorre.correlativo, '999999') @ Ccbcdocu.nrodoc
        TODAY @ Ccbcdocu.FchAte
        TODAY @ Ccbcdocu.FchDoc
        gn-tcmb.compra @ Ccbcdocu.TpoCmb. 
    FOR EACH cb-tabl WHERE cb-tabl.tabla = '04' NO-LOCK:
        Ccbcdocu.FlgAte:ADD-LAST(cb-tabl.codigo).
    END.
    ASSIGN
        Ccbcdocu.TpoFac:SCREEN-VALUE = 'EFE'
        Ccbcdocu.CodDiv:SCREEN-VALUE = s-coddiv.
    FIND GN-DIVI WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = s-coddiv
        NO-LOCK NO-ERROR.
    IF AVAILABLE GN-DIVI THEN FILL-IN-NomDiv:SCREEN-VALUE = GN-DIVI.DesDiv.
  END.
    
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
  RUN GET-ATTRIBUTE ('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
    FIND FIRST FacCorre WHERE FacCorre.CodCia = s-codcia 
        AND  FacCorre.CodDiv = s-coddiv 
        AND  FacCorre.CodDoc = s-coddoc 
        AND  FacCorre.NroSer = s-NroSer
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCorre THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1
        Ccbcdocu.NroDoc = STRING(faccorre.nroser, "999") + 
                        STRING(faccorre.correlativo, "999999")
        Ccbcdocu.FlgEst = "E"       /* OJO -> Emitido */
        Ccbcdocu.FlgSit = 'Pendiente'   /* OJO */
        Ccbcdocu.FchUbi = DATE("")
        CcbCDocu.HorCie = STRING(TIME, 'HH:MM').
  END.
  ASSIGN
      Ccbcdocu.FlgSit = 'Pendiente'.   /* OJO >>> SIEMPRE A PENDIENTE */
 
  ASSIGN
    Ccbcdocu.CodCia = s-codcia
    Ccbcdocu.CodDoc = s-coddoc
    Ccbcdocu.usuario= s-user-id
    Ccbcdocu.SdoAct = Ccbcdocu.ImpTot
    Ccbcdocu.Nomcli = Ccbcdocu.Nomcli:screen-value in frame {&frame-name}
    Ccbcdocu.Glosa = Ccbcdocu.Glosa:screen-value in frame {&frame-name}
    Ccbcdocu.Codmon = INTEGER (Ccbcdocu.Codmon:screen-value in frame {&frame-name}).

  RELEASE faccorre.
    

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
  DEF VAR s-rpta-1 AS CHAR NO-UNDO.
  
  IF Ccbcdocu.FlgEst = "A" THEN
  DO:
    MESSAGE "Documento Anulado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.
  IF Ccbcdocu.FlgEst = "C" THEN
  DO:
    MESSAGE "El Documento se encuentra Cancelado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.
  IF Ccbcdocu.FlgEst = "X" THEN
  DO:
    MESSAGE "El Documento se encuentra Cerrado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.
  IF Ccbcdocu.FlgSit = "Autorizada" THEN
  DO:
    MESSAGE "El Documento está Autorizado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.  
  IF Ccbcdocu.ImpTot <> Ccbcdocu.SdoAct THEN
  DO:
    MESSAGE "El Documento tiene Amortizaciones" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.

  /* consistencia de la fecha del cierre del sistema */
  DEF VAR dFchCie AS DATE.
  IF s-user-id <> 'ADMIN' THEN DO:
      RUN gn/fecha-de-cierre (OUTPUT dFchCie).
      IF ccbcdocu.fchdoc <= dFchCie THEN DO:
          MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
              VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.
      /* fin de consistencia */
  END.

  /* Code placed here will execute AFTER standard behavior.    */
  FIND CURRENT Ccbcdocu EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Ccbcdocu THEN RETURN 'ADM-ERROR'.
  ASSIGN
    CcbCDocu.UsuAnu = s-user-id
    CcbCDocu.FchAnu = TODAY
    Ccbcdocu.FlgEst = 'A'
    Ccbcdocu.SdoAct = 0.
  FIND CURRENT Ccbcdocu NO-LOCK NO-ERROR.
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
    FOR EACH cb-tabl WHERE cb-tabl.tabla = '04' NO-LOCK:
        Ccbcdocu.FlgAte:ADD-LAST(cb-tabl.codigo).
    END.
    FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia NO-LOCK:
        Ccbcdocu.coddiv:ADD-LAST(gn-divi.coddiv).
    END.
    FIND cb-tabl WHERE cb-tabl.tabla = '04'
        AND cb-tabl.codigo = Ccbcdocu.FlgAte NO-LOCK NO-ERROR.
    IF AVAILABLE cb-tabl THEN x-NomBco:SCREEN-VALUE = cb-tabl.Nombre.
    IF Ccbcdocu.FlgEst = "E" THEN F-Estado:SCREEN-VALUE = "POR APROBAR".
    IF Ccbcdocu.FlgEst = "P" THEN F-Estado:SCREEN-VALUE = "PENDIENTE".
    IF Ccbcdocu.FlgEst = "A" THEN F-Estado:SCREEN-VALUE = "ANULADO".
    IF Ccbcdocu.FlgEst = "C" THEN F-Estado:SCREEN-VALUE = "CANCELADO".
    IF Ccbcdocu.FlgEst = "X" THEN F-Estado:SCREEN-VALUE = "CERRADO".
    IF Ccbcdocu.FlgSit = "Rechazada" THEN F-Estado:SCREEN-VALUE = "RECHAZADA".
    IF Ccbcdocu.codmon = 1
    THEN FILL-IN-Moneda:SCREEN-VALUE = 'S/.'.
    ELSE FILL-IN-Moneda:SCREEN-VALUE = 'US$'.
    FIND GN-DIVI WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = Ccbcdocu.coddiv
        NO-LOCK NO-ERROR.
    IF AVAILABLE GN-DIVI
    THEN FILL-IN-NomDiv:SCREEN-VALUE = GN-DIVI.DesDiv.
    ELSE FILL-IN-NomDiv:SCREEN-VALUE = ''.

    x-Nombr:SCREEN-VALUE = ''.
    FIND Gn-convt WHERE Gn-convt.codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE GN-convt THEN x-Nombr:SCREEN-VALUE = gn-ConVt.Nombr.
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
    Ccbcdocu.fchdoc:SENSITIVE = NO.
    Ccbcdocu.CodDiv:SENSITIVE = NO.
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

DEFINE VAR F-MONEDA AS CHAR.  

DEFINE FRAME F-CAB
/*  Ccbcdocu.NroDoc FORMAT "XXX-XXXXXX"
    Ccbcdocu.FchDoc FORMAT "99/99/9999"
    Ccbcdocu.FlgSit 
    Ccbcdocu.CodMon 
    Ccbcdocu.TpoCmb 
    Ccbcdocu.Hora  
    Ccbcdocu.FlgAte  
    Ccbcdocu.NroRef 
    Ccbcdocu.TpoFac 
    Ccbcdocu.CodCta 
    Ccbcdocu.Glosa 
    Ccbcdocu.CodAge 
    Ccbcdocu.ImpTot 
    Ccbcdocu.SdoAct 
    Ccbcdocu.CodCli 
    Ccbcdocu.NomCli 
    Ccbcdocu.FchUbi 
    Ccbcdocu.usuario
    Ccbcdocu.CodDiv
    Ccbcdocu.FlgUbi*/

    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN2} FORMAT "X(45)" SKIP(2)
    WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 200 STREAM-IO DOWN.         
    OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 30.
    PUT STREAM Report CONTROL {&PRN0} + {&PRN5A} + CHR(33) + {&PRN2}.  

    IF Ccbcdocu.CodMon = 2 THEN F-MONEDA = "US$.".
       ELSE F-MONEDA = "S/.".
       
       
    PUT STREAM REPORT {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN2} FORMAT "X(45)" 
                      {&PRN3} + "Fecha : " AT 65 FORMAT "X(10)" TODAY AT 77 FORMAT "99/99/9999" SKIP.
    PUT STREAM REPORT "Hora : " + STRING(TIME,"HH:MM AM") AT 94 FORMAT "X(20)" SKIP.
                      
    PUT STREAM REPORT {&PRN2} + {&PRN7A} + {&PRN6A} + "BOLETA DE DEPOSITO" + {&PRN6B} + {&PRN7B} + {&PRN2} FORMAT "X(30)" AT 35 SKIP(2).
    PUT STREAM REPORT "NUMERO : " AT 1 
                      {&PRN6A} + Ccbcdocu.NroDoc + {&PRN6B} AT 12 FORMAT "XXXXX-XXXXXXXXX" 
                      {&PRN2} + "FECHA : "  AT 35 FORMAT "X(10)" 
                      Ccbcdocu.FchDoc AT 46 FORMAT "99/99/9999" 
                      {&PRN2} + {&PRN7A} + {&PRN6A} + Ccbcdocu.FlgSit + {&PRN6B} + {&PRN7B} + {&PRN2} AT 65 FORMAT "X(20)" SKIP(1).
                      
    PUT STREAM REPORT "-----------------------------------------------------------------------------------" AT 1 SKIP(1).
    
    PUT STREAM REPORT "MONEDA : " AT 1 
                      F-MONEDA    AT 12 FORMAT "X(10)" 
                      "TIPO DE CAMBIO : " AT 27 
                      Ccbcdocu.TpoCmb FORMAT ">>9.9999" AT 45 
                      "HORA : " AT 57
                      /*Ccbcdocu.Hora AT 65*/ SKIP(1).    
    PUT STREAM REPORT "BANCO : " AT 1 
                      Ccbcdocu.FlgAte AT 12 FORMAT "X(08)" 
                      "NUMERO DE DEPOSITO : " AT 27 
                      {&PRN6A} + Ccbcdocu.NroRef + {&PRN6B} AT 49 FORMAT "X(20)" SKIP(1).
    PUT STREAM REPORT "CODIGO DE CUENTA : " AT 1 
                      Ccbcdocu.CodCta AT 27 FORMAT "X(10)" 
                      Ccbcdocu.Glosa AT 45 FORMAT "X(25)" SKIP(1).    
    PUT STREAM REPORT "AGENCIA : " AT 1 
                      Ccbcdocu.CodAge AT 12 FORMAT "X(10)" 
                      "IMPORTE TOTAL : " AT 27 
                      Ccbcdocu.ImpTot FORMAT ">>>>,>>9.99" AT 45 
                      "SALDO ACTUAL  : " AT 57 
                      Ccbcdocu.SdoAct FORMAT ">>>>,>>9.99" AT 73 SKIP(1).    
    PUT STREAM REPORT "CLIENTE : " AT 1 
                      Ccbcdocu.CodCli AT 12 FORMAT "X(10)" 
                      Ccbcdocu.NomCli AT 27 FORMAT "X(40)" SKIP(1).

    PUT STREAM REPORT "-----------------------------------------------------------------------------------" AT 1 SKIP(1).

    PUT STREAM REPORT "DIVISION : " AT 1 
                      Ccbcdocu.CodDiv AT 12 FORMAT "X(10)"
                      "FlgUbi : " AT 27 
                      Ccbcdocu.FlgUbi AT 39 FORMAT "X(12)"
                      "Fecha AUTORIZACION : " at 52
                      Ccbcdocu.FchUbi at 74 SKIP(1).
    PUT STREAM REPORT "USUARIO : " AT 1 
                      {&PRN6A} + Ccbcdocu.usuario  + {&PRN6B} AT 12 SKIP(1).
    OUTPUT STREAM Report CLOSE.

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
 DO WITH FRAME {&FRAME-NAME}:
    CASE HANDLE-CAMPO:name:
        WHEN "FmaPgo" THEN ASSIGN input-var-1 = "1".
        WHEN "FlgAte" THEN ASSIGN input-var-1 = "04".
        WHEN "CODCTA" THEN ASSIGN input-var-1 = "10" input-var-2 = Ccbcdocu.FlgAte:SCREEN-VALUE.
        WHEN "CODAGE" THEN ASSIGN input-var-1 = Ccbcdocu.FlgAte:SCREEN-VALUE.
          /*
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.
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
  {src/adm/template/snd-list.i "Ccbcdocu"}

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
    RUN vtagn/p-gn-clie-01 (Ccbcdocu.CodCli:SCREEN-VALUE , s-coddoc).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        APPLY "ENTRY" TO Ccbcdocu.CodCli.
        RETURN "ADM-ERROR".   
    END.
    IF Ccbcdocu.CodCli:SCREEN-VALUE = FacCfgGn.CliVar THEN DO:
        MESSAGE 'NO se puede registrar a un cliente genérico'
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    IF Ccbcdocu.FlgAte:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Codigo de Banco no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO Ccbcdocu.FlgAte.
         RETURN "ADM-ERROR".   
    END.
    IF Ccbcdocu.CodCta:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Codigo de Cuenta no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO Ccbcdocu.CodCta.
         RETURN "ADM-ERROR".   
    END.
    FIND cb-ctas WHERE cb-ctas.codcia = cl-codcia
        AND  cb-ctas.Codcta = Ccbcdocu.CodCta:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE "Código de cuenta NO registrado" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.CodCta.
        RETURN "ADM-ERROR".   
    END.
    IF cb-ctas.codbco <> ccbcdocu.flgate:SCREEN-VALUE THEN DO:
        MESSAGE "El código de cuenta no pertenece al banco" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.FlgAte.
        RETURN "ADM-ERROR".   
    END.


    IF CcbCDocu.FmaPgo:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Código de Venta no debe ser en blanco"
        VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO CcbCDocu.FmaPgo.
        RETURN "ADM-ERROR".
    END.
    
    IF DEC(Ccbcdocu.ImpTot:SCREEN-VALUE) = 0 THEN DO:
        MESSAGE "El Importe Total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.ImpTot.
        RETURN "ADM-ERROR".   
    END.      

    IF CcbCDocu.FmaPgo:SCREEN-VALUE <> '' THEN DO:
        FIND Gn-convt WHERE Gn-convt.codig = CcbCDocu.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF NOT AVAILABLE GN-convt THEN DO:
            MESSAGE
                "Condicion de venta no existe"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO CcbCDocu.FmaPgo.
            RETURN "ADM-ERROR".
        END.
    END.

    IF Ccbcdocu.NroRef:SCREEN-VALUE = '' THEN DO:
        MESSAGE 'Registre el Nro. del Depósito' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U to Ccbcdocu.NroRef.
        RETURN 'ADM-ERROR'.
    END.
    DEF VAR iValue AS INTE NO-UNDO.
    ASSIGN iValue = INTEGER(Ccbcdocu.NroRef:SCREEN-VALUE) NO-ERROR.
    IF ERROR-STATUS:ERROR = NO AND iValue = 0 THEN DO:
        MESSAGE 'El Nro. de Depósito NO puede ser cero' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U to Ccbcdocu.NroRef.
        RETURN 'ADM-ERROR'.
    END.

    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' THEN DO:
        FIND FIRST B-Ccbcdocu WHERE B-Ccbcdocu.CodCia = S-CODCIA 
            AND B-Ccbcdocu.CodDoc = s-coddoc
            AND  B-Ccbcdocu.FlgAte = Ccbcdocu.FlgAte:SCREEN-VALUE 
            AND B-Ccbcdocu.NroRef = INPUT Ccbcdocu.NroRef
            AND B-Ccbcdocu.CodCli = INPUT Ccbcdocu.CodCli
            /*AND B-Ccbcdocu.ImpTot = INPUT Ccbcdocu.ImpTot*/
            AND B-Ccbcdocu.FchAte = INPUT Ccbcdocu.FchAte
            AND  B-Ccbcdocu.FlgEst <> "A" 
            NO-LOCK NO-ERROR.
        /* RHC 02.12.10 Pedido por SLM */
/*         FIND FIRST B-Ccbcdocu WHERE B-Ccbcdocu.CodCia = S-CODCIA  */
/*             AND B-Ccbcdocu.CodDoc = s-coddoc                      */
/*             AND B-Ccbcdocu.CodCli = CcbCDocu.CodCli:SCREEN-VALUE  */
/*             AND  B-Ccbcdocu.FlgAte = Ccbcdocu.FlgAte:SCREEN-VALUE */
/*             AND B-Ccbcdocu.NroRef = INPUT Ccbcdocu.NroRef         */
/*             AND B-Ccbcdocu.ImpTot = INPUT Ccbcdocu.ImpTot         */
/*             AND  B-Ccbcdocu.FlgEst <> "A"                         */
/*             NO-LOCK NO-ERROR.                                     */
    END.
    ELSE DO:
        FIND FIRST B-Ccbcdocu WHERE B-Ccbcdocu.CodCia = S-CODCIA 
            AND B-Ccbcdocu.CodDoc = s-coddoc
            AND  B-Ccbcdocu.FlgAte = Ccbcdocu.FlgAte:SCREEN-VALUE 
            AND B-Ccbcdocu.NroRef = INPUT Ccbcdocu.NroRef
            AND B-Ccbcdocu.ImpTot = INPUT Ccbcdocu.ImpTot
            AND B-Ccbcdocu.FchAte = INPUT Ccbcdocu.FchAte
            AND  B-Ccbcdocu.FlgEst <> "A" 
            AND ROWID(B-Ccbcdocu) <> ROWID(CCbcdocu)
            NO-LOCK NO-ERROR.
        /* RHC 02.12.10 Pedido por SLM */
/*         FIND FIRST B-Ccbcdocu WHERE B-Ccbcdocu.CodCia = S-CODCIA  */
/*             AND B-Ccbcdocu.CodDoc = s-coddoc                      */
/*             AND B-Ccbcdocu.CodCli = CcbCDocu.CodCli:SCREEN-VALUE  */
/*             AND  B-Ccbcdocu.FlgAte = Ccbcdocu.FlgAte:SCREEN-VALUE */
/*             AND B-Ccbcdocu.NroRef = INPUT Ccbcdocu.NroRef         */
/*             AND B-Ccbcdocu.ImpTot = INPUT Ccbcdocu.ImpTot         */
/*             AND  B-Ccbcdocu.FlgEst <> "A"                         */
/*             AND ROWID(B-Ccbcdocu) <> ROWID(CCbcdocu)              */
/*             NO-LOCK NO-ERROR.                                     */
    END.
    IF AVAILABLE B-Ccbcdocu THEN DO:
       MESSAGE "Número de Depósito ya Existe" SKIP
               "esta en Proceso Nro. " B-Ccbcdocu.NroDoc SKIP
               "en el Deposito  Nro. " B-Ccbcdocu.NroRef SKIP
               "en la división " B-Ccbcdocu.coddiv 
               VIEW-AS ALERT-BOX ERROR.
       RETURN 'ADM-ERROR'.
    END.
    /* RHC 06/10/2014 Cruzamos contra Cheques Depositados */
    FIND FIRST B-CDOCU WHERE B-CDOCU.codcia = s-codcia
        AND B-CDOCU.coddoc >= 'CHD'
        AND B-CDOCU.flgest <> 'A'
        AND B-CDOCU.nroord = CcbCDocu.NroRef:SCREEN-VALUE
        AND B-CDOCU.codcta = CcbCDocu.CodCta:SCREEN-VALUE
        AND B-CDOCU.codage = CcbCDocu.FlgAte:SCREEN-VALUE
        AND B-CDOCU.codcli = CcbCDocu.CodCli:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE B-CDOCU THEN DO:
        MESSAGE 'Se ha detectado un cheque depositado en esta cuenta:' SKIP
            'Cheque Nro:' B-CDOCU.nrodoc SKIP
            'Necesito la confirmación de esta boleta de depósito'
            VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
            UPDATE rpta AS LOG.
        IF rpta = NO THEN DO:
            APPLY 'ENTRY':U to Ccbcdocu.NroRef.
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
IF Ccbcdocu.FlgEst = "A" THEN
DO:
    MESSAGE "Documento Anulado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
IF Ccbcdocu.FlgEst = "C" THEN
DO:
    MESSAGE "El Documento se encuentra Cancelado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
IF Ccbcdocu.FlgEst = "X" THEN
DO:
    MESSAGE "El Documento se encuentra Cerrado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
IF Ccbcdocu.ImpTot <> Ccbcdocu.SdoAct THEN
DO:
    MESSAGE "El Documento tiene Amortizaciones" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
IF Ccbcdocu.FlgSit = "Autorizada" THEN
DO:
    MESSAGE "El Documento está Autorizado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.  
   /* consistencia de la fecha del cierre del sistema */
   DEF VAR dFchCie AS DATE.
   RUN gn/fecha-de-cierre (OUTPUT dFchCie).
   IF ccbcdocu.fchdoc <= dFchCie THEN DO:
       MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
           VIEW-AS ALERT-BOX WARNING.
       RETURN 'ADM-ERROR'.
   END.
   /* fin de consistencia */

RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

