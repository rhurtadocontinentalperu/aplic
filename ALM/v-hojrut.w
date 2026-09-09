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

DEFINE SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR pv-codcia AS INT.
DEFINE SHARED VAR S-NOMCIA  AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR. 
DEFINE SHARED VAR S-CODALM  AS CHAR.
DEFINE SHARED VAR S-CODDOC  AS CHAR.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-NROSER  AS INTEGER.
DEFINE SHARED VAR S-DESALM  AS CHARACTER.

DEFINE SHARED TEMP-TABLE T-Rutad LIKE DI-Rutad.

DEFINE        VAR L-CREA   AS LOGICAL  NO-UNDO.

DEFINE BUFFER B-Rutac FOR DI-Rutac.

/*
DEFINE new SHARED VAR s-pagina-final AS INTEGER.
DEFINE new SHARED VAR s-pagina-inicial AS INTEGER.
DEFINE new SHARED VAR s-salida-impresion AS INTEGER.
DEFINE new SHARED VAR s-printer-name AS CHAR.
DEFINE new SHARED VAR s-print-file AS CHAR.
DEFINE new SHARED VAR s-nro-copias AS INTEGER.
DEFINE new SHARED VAR s-orientacion AS INTEGER.
*/

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "aplic/alm/rbalm.prl".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Hoja Ruta2".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

/* capturamos ruta inicial */
DEF VAR S-REPORT-LIBRARY AS CHAR.
GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE s-report-library.
RB-REPORT-LIBRARY = s-report-library + "alm\rbalm.prl".

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
&Scoped-define EXTERNAL-TABLES DI-RutaC
&Scoped-define FIRST-EXTERNAL-TABLE DI-RutaC


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR DI-RutaC.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS DI-RutaC.FchDoc DI-RutaC.FchRet ~
DI-RutaC.CodPro DI-RutaC.KmtIni DI-RutaC.KmtFin DI-RutaC.CodRut ~
DI-RutaC.DesRut DI-RutaC.HorSal DI-RutaC.HorRet DI-RutaC.CodCob ~
DI-RutaC.CodVeh DI-RutaC.CodMon DI-RutaC.Nomtra DI-RutaC.CtoRut ~
DI-RutaC.Observ DI-RutaC.TpoTra 
&Scoped-define ENABLED-TABLES DI-RutaC
&Scoped-define FIRST-ENABLED-TABLE DI-RutaC
&Scoped-Define ENABLED-OBJECTS RECT-3 RECT-4 RECT-5 
&Scoped-Define DISPLAYED-FIELDS DI-RutaC.NroDoc DI-RutaC.FchDoc ~
DI-RutaC.FchRet DI-RutaC.CodPro DI-RutaC.KmtIni DI-RutaC.KmtFin ~
DI-RutaC.CodRut DI-RutaC.DesRut DI-RutaC.HorSal DI-RutaC.HorRet ~
DI-RutaC.CodCob DI-RutaC.CodVeh DI-RutaC.CodMon DI-RutaC.Nomtra ~
DI-RutaC.CtoRut DI-RutaC.Observ DI-RutaC.TpoTra 
&Scoped-define DISPLAYED-TABLES DI-RutaC
&Scoped-define FIRST-DISPLAYED-TABLE DI-RutaC
&Scoped-Define DISPLAYED-OBJECTS F-Estado FILL-IN-NomPro F-NomCob ~
F-vehiculo 

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
     SIZE 16.72 BY .69
     FONT 6 NO-UNDO.

DEFINE VARIABLE F-NomCob AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.86 BY .69 NO-UNDO.

DEFINE VARIABLE F-vehiculo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.43 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33.43 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 5.92.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 11.86 BY .69.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 17.72 BY .69.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     DI-RutaC.NroDoc AT ROW 1.15 COL 11.14 COLON-ALIGNED
          LABEL "No Documento"
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     F-Estado AT ROW 1.15 COL 31.29 COLON-ALIGNED NO-LABEL
     DI-RutaC.FchDoc AT ROW 1.15 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .69
     DI-RutaC.FchRet AT ROW 1.15 COL 76.86 COLON-ALIGNED
          LABEL "Ret" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .69
     DI-RutaC.CodPro AT ROW 1.92 COL 11.14 COLON-ALIGNED
          LABEL "Proveedor" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     FILL-IN-NomPro AT ROW 1.96 COL 23.72 COLON-ALIGNED NO-LABEL
     DI-RutaC.KmtIni AT ROW 1.96 COL 63.14 COLON-ALIGNED
          LABEL "Km"
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .69
     DI-RutaC.KmtFin AT ROW 1.96 COL 76.86 COLON-ALIGNED
          LABEL "Ret"
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .69
     DI-RutaC.CodRut AT ROW 2.73 COL 11.14 COLON-ALIGNED
          LABEL "Ruta"
          VIEW-AS FILL-IN 
          SIZE 6 BY .69
     DI-RutaC.DesRut AT ROW 2.77 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 39.43 BY .69
     DI-RutaC.HorSal AT ROW 2.77 COL 63.14 COLON-ALIGNED
          LABEL "Hora"
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .69
     DI-RutaC.HorRet AT ROW 2.77 COL 76.57 COLON-ALIGNED
          LABEL "Ret"
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .69
     DI-RutaC.CodCob AT ROW 3.54 COL 11.14 COLON-ALIGNED
          LABEL "Cobrador" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 8 BY .69
     F-NomCob AT ROW 3.54 COL 19.43 COLON-ALIGNED NO-LABEL
     DI-RutaC.CodVeh AT ROW 4.31 COL 11.14 COLON-ALIGNED
          LABEL "Vehiculo"
          VIEW-AS FILL-IN 
          SIZE 6 BY .69
     F-vehiculo AT ROW 4.35 COL 17.72 COLON-ALIGNED NO-LABEL
     DI-RutaC.CodMon AT ROW 4.58 COL 76.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 10 BY .5
     DI-RutaC.Nomtra AT ROW 5.15 COL 11.14 COLON-ALIGNED
          LABEL "Transportista"
          VIEW-AS FILL-IN 
          SIZE 45 BY .69
     DI-RutaC.CtoRut AT ROW 5.19 COL 74.57 COLON-ALIGNED
          LABEL "Costo Ruta"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     DI-RutaC.Observ AT ROW 5.96 COL 11.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 45 BY .69
     DI-RutaC.TpoTra AT ROW 6.04 COL 70.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Propio", "01":U,
"Externo", "02":U
          SIZE 17 BY .5
     "Tipo de Trans" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 6.12 COL 59.14
     "Moneda :" VIEW-AS TEXT
          SIZE 6.57 BY .69 AT ROW 4.54 COL 68.57
     RECT-3 AT ROW 1 COL 1
     RECT-4 AT ROW 4.46 COL 75.72
     RECT-5 AT ROW 5.96 COL 69.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.DI-RutaC
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
         HEIGHT             = 6
         WIDTH              = 89.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN DI-RutaC.CodCob IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN DI-RutaC.CodPro IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN DI-RutaC.CodRut IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN DI-RutaC.CodVeh IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN DI-RutaC.CtoRut IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomCob IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-vehiculo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN DI-RutaC.FchRet IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN DI-RutaC.HorRet IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN DI-RutaC.HorSal IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN DI-RutaC.KmtFin IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN DI-RutaC.KmtIni IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN DI-RutaC.Nomtra IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN DI-RutaC.NroDoc IN FRAME F-Main
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

&Scoped-define SELF-NAME DI-RutaC.CodCob
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DI-RutaC.CodCob V-table-Win
ON LEAVE OF DI-RutaC.CodCob IN FRAME F-Main /* Cobrador */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-cob WHERE gn-cob.codcia = S-CODCIA AND
                    gn-cob.codcob = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-cob
  THEN DO:
    MESSAGE "Cobrador no registrado" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  DISPLAY gn-cob.nomcob @ F-Nomcob
          WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DI-RutaC.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DI-RutaC.CodPro V-table-Win
ON LEAVE OF DI-RutaC.CodPro IN FRAME F-Main /* Proveedor */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.

       FIND gn-prov WHERE gn-prov.CodCia = pv-codcia
                     AND  gn-prov.CodPro = SELF:SCREEN-VALUE
                    NO-LOCK NO-ERROR.
       IF AVAILABLE gn-prov THEN DISPLAY gn-prov.NomPro @ FILL-IN-NomPro WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DI-RutaC.CodRut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DI-RutaC.CodRut V-table-Win
ON LEAVE OF DI-RutaC.CodRut IN FRAME F-Main /* Ruta */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND almtabla WHERE almtabla.Tabla = "RR" AND
          almtabla.Codigo = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE almtabla THEN 
        DISPLAY almtabla.Nombre @ DI-Rutac.DesRut WITH FRAME {&FRAME-NAME}.
   ELSE DO:
      MESSAGE "Codigo de Ruta no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DI-RutaC.CodVeh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DI-RutaC.CodVeh V-table-Win
ON LEAVE OF DI-RutaC.CodVeh IN FRAME F-Main /* Vehiculo */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND almtabla WHERE almtabla.Tabla = "UM" AND
          almtabla.Codigo = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE almtabla THEN 
     DISPLAY almtabla.Nombre @ F-Vehiculo WITH FRAME {&FRAME-NAME}.
  ELSE DO:
     MESSAGE "Codigo de Vehiculo no Existe" VIEW-AS ALERT-BOX ERROR.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Rutad V-table-Win 
PROCEDURE Actualiza-Rutad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH T-Rutad:
    DELETE T-Rutad.
END.
IF NOT L-CREA THEN DO:
   FOR EACH DI-Rutad OF Di-Rutac NO-LOCK :
       CREATE T-Rutad.
       RAW-TRANSFER DI-Rutad TO T-Rutad.
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
  {src/adm/template/row-list.i "DI-RutaC"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "DI-RutaC"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

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
FOR EACH DI-Rutad OF Di-RutaC:
    DELETE Di-Rutad.
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
   FOR EACH T-Rutad
       ON ERROR UNDO, RETURN "ADM-ERROR":
       CREATE DI-Rutad.
       ASSIGN DI-Rutad.CodCia = Di-Rutac.CodCia 
              DI-Rutad.Coddiv = DI-Rutac.CodDiv 
              DI-Rutad.Coddoc = DI-Rutac.Coddoc 
              DI-Rutad.NroDoc = DI-Rutac.NroDoc 
              DI-Rutad.Codref = T-Rutad.CodRef
              DI-Rutad.FlgEst = T-Rutad.FlgEst
              DI-Rutad.HorAte = T-Rutad.HorAte
              DI-Rutad.ImpCob = T-Rutad.ImpCob
              DI-Rutad.Moncob = T-Rutad.MonCob
              DI-Rutad.Glosa  = T-Rutad.Glosa
              DI-Rutad.Nroref = T-Rutad.NroRef.
   END.
/*   RUN Procesa-Handle IN lh_Handle ('browse').*/

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  l-CREA = YES.
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY @ DI-Rutac.FchDoc
             TODAY @ DI-Rutac.FchRet.
  END.
  
  RUN Actualiza-Rutad.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  IF L-CREA THEN DO:
     ASSIGN DI-RutaC.CodCia = S-CODCIA 
            DI-RutaC.CodDoc = S-CODDOC
            DI-RutaC.CodDiv = S-CODDIV
            DI-RutaC.FchDoc = TODAY.
     
        FIND FIRST FacCorre WHERE 
                  FacCorre.CodCia = S-CODCIA AND  
                  FacCorre.CodDoc = S-CODDOC AND  
                  FacCorre.CodDiv = S-CODDIV 
                  EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE FacCorre THEN DO:
           ASSIGN DI-RutaC.NroDoc = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999").
                  FacCorre.Correlativo = FacCorre.Correlativo + 1.
        END.
        RELEASE FacCorre.
  END.
  
  ASSIGN DI-RutaC.usuario = S-USER-ID.

  /* ELIMINAMOS EL DETALLE ANTERIOR */  
  IF NOT L-CREA THEN RUN Borra-Detalle.

  RUN Genera-Detalle.
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
/*  RUN Procesa-Handle IN lh_Handle ('Browse').*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN valida-update.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  
  /* Eliminamos el detalle */
  
  /* Solo marcamos el FlgEst como Anulado */
  DO TRANSACTION:
     RUN Borra-Detalle.
     FIND B-Rutac WHERE B-Rutac.CodCia = DI-Rutac.CodCia 
                AND  B-Rutac.Coddiv = DI-Rutac.Coddiv 
                AND  B-Rutac.Coddoc = DI-Rutac.Coddoc 
                AND  B-Rutac.NroDoc = DI-Rutac.NroDoc 
               EXCLUSIVE-LOCK NO-ERROR.
     ASSIGN B-Rutac.FlgEst = 'A'
            B-Rutac.Observ = "      A   N   U   L   A   D   O       "
            B-Rutac.Usuario = S-USER-ID.
     RELEASE B-Rutac.
  END.
  /* refrescamos los datos del viewer */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  /* refrescamos los datos del browse */
  RUN Procesa-Handle IN lh_Handle ('browse').

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
  IF AVAILABLE DI-Rutac THEN DO WITH FRAME {&FRAME-NAME}:
    F-Estado:SCREEN-VALUE = "".
    IF DI-Rutac.FlgEst  = "A" THEN F-Estado:SCREEN-VALUE = "  ANULADO   ".  

         FIND gn-prov WHERE gn-prov.CodCia = pv-codcia 
                       AND  gn-prov.CodPro = Di-Rutac.CodPro 
                      NO-LOCK NO-ERROR.
         IF AVAILABLE gn-prov THEN DISPLAY gn-prov.NomPro @ FILL-IN-NomPro WITH FRAME {&FRAME-NAME}.

    IF DI-rutac.CodVeh <> "" THEN DO:
       FIND almtabla WHERE almtabla.Tabla = "UM" AND
            almtabla.Codigo = DI-rutac.CodVeh 
            NO-LOCK NO-ERROR.
       IF AVAILABLE almtabla THEN 
          DISPLAY almtabla.Nombre @ F-Vehiculo WITH FRAME {&FRAME-NAME}.
    END.

    IF DI-Rutac.Codcob <> "" THEN DO:
       FIND gn-cob WHERE gn-cob.codcia = S-CODCIA AND
                         gn-cob.codcob = DI-Rutac.Codcob
                         NO-LOCK NO-ERROR.
       IF AVAILABLE gn-cob THEN
          DISPLAY gn-cob.nomcob @ F-Nomcob WITH FRAME {&FRAME-NAME}.
    END.

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
   DEFINE VAR x-nrodoc AS CHAR.
   IF Di-Rutac.FlgEst = "A" THEN RETURN.
   
   x-nrodoc = DI-Rutac.Nrodoc.
   
  /* LOGICA PRINCIPAL */
  /* Pantalla general de parametros de impresion */
  RUN bin/_prnctr.p.
  IF s-salida-impresion = 0 THEN RETURN.

 
  /* test de impresion */
  RB-INCLUDE-RECORDS = "O".

  RB-FILTER = "DI-Rutad.Codcia = " + STRING(s-codcia) +  
              " AND Di-Rutad.Coddiv = '" + s-coddiv + "'" +
              " AND DI-Rutad.Coddoc = '" + s-coddoc + "'" + 
              " AND Di-Rutad.Nrodoc = '" + x-nrodoc + "'".


  RB-OTHER-PARAMETERS = "x-nomcia = " + s-nomcia +
                        "~nx-desalm = " + s-desalm +
                        "~nx-nrodoc = " + DI-Rutac.NroDoc +
                        "~nx-codcob = " + Di-Rutac.codcob +
                        "~nx-codrut = " + Di-Rutac.codrut +
                        "~nx-desrut = " + Di-Rutac.desrut +
                        "~nx-codpro = " + DI-Rutac.codpro +
                        "~nx-despro = " + Gn-prov.nompro +
                        "~nx-nomtra = " + Di-Rutac.nomtra +
                        "~nx-desveh = " + Almtabla.Nombre +
                        "~nx-codveh = " + Di-Rutac.codveh +
                        "~nx-nomcob = " + Gn-Cob.Nomcob +
                        "~nx-horsal = " + Di-Rutac.horsal +
                        "~nx-horret = " + Di-Rutac.horret +
                        "~nx-kmini  = " + STRING(Di-Rutac.kmtini,">>>,>>>,>>9.99") +
                        "~nx-kmfin  = " + STRING(Di-Rutac.kmtfin,">>>,>>>,>>9.99") +
                        "~nx-fchdoc = " + string(Di-Rutac.Fchdoc,"99/99/9999") +
                        "~nx-fchret = " + string(Di-Rutac.FchRet,"99/99/9999") .
                        
  /* Captura parametros de impresion */
  ASSIGN
      RB-BEGIN-PAGE = s-pagina-inicial
      RB-END-PAGE = s-pagina-final
      RB-PRINTER-NAME = s-printer-name
      RB-OUTPUT-FILE = s-print-file
      RB-NUMBER-COPIES = s-nro-copias.
  CASE s-salida-impresion:
      WHEN 1 THEN RB-PRINT-DESTINATION = "D".     /* Pantalla */
      WHEN 2 THEN RB-PRINT-DESTINATION = "".      /* Impresora */
      WHEN 3 THEN RB-PRINT-DESTINATION = "A".     /* Archivo */
  END CASE.
  
  RUN aderb/_printrb (RB-REPORT-LIBRARY,
                      RB-REPORT-NAME,
                      RB-DB-CONNECTION,
                      RB-INCLUDE-RECORDS,
                      RB-FILTER,
                      RB-MEMO-FILE,
                      RB-PRINT-DESTINATION,
                      RB-PRINTER-NAME,
                      RB-PRINTER-PORT,
                      RB-OUTPUT-FILE,
                      RB-NUMBER-COPIES,
                      RB-BEGIN-PAGE,
                      RB-END-PAGE,
                      RB-TEST-PATTERN,
                      RB-WINDOW-TITLE,
                      RB-DISPLAY-ERRORS,
                      RB-DISPLAY-STATUS,
                      RB-NO-WAIT,
                      RB-OTHER-PARAMETERS).    
    


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
  
  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ).
  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN Procesa-Handle IN lh_Handle ('Pagina1').
  RUN Procesa-Handle IN lh_Handle ('Browse').
  
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

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
            WHEN "codrut" THEN ASSIGN input-var-1 = "RR".
            WHEN "codveh" THEN ASSIGN input-var-1 = "UM".

            /*
              ASSIGN
                    input-var-1 = ""
                    input-var-2 = ""
                    input-var-3 = "".
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
  {src/adm/template/snd-list.i "DI-RutaC"}

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
     RUN Actualiza-Rutad.
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
IF NOT AVAILABLE DI-Rutac THEN  RETURN "ADM-ERROR".

DEFINE VAR RPTA AS CHAR.


IF Di-Rutac.FlgEst = 'A' THEN DO:
   MESSAGE "Documento Anulado" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

