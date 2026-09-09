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
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEF SHARED VARIABLE S-NOMCIA  AS CHAR.
DEF SHARED VARIABLE s-CodDiv  AS CHAR.
DEF SHARED VARIABLE s-User-Id AS CHAR.

DEF VAR s-titulo AS CHAR NO-UNDO.

/*DEFINE new SHARED VAR s-pagina-final AS INTEGER.
 * DEFINE new SHARED VAR s-pagina-inicial AS INTEGER.
 * DEFINE new SHARED VAR s-salida-impresion AS INTEGER.
 * DEFINE new SHARED VAR s-printer-name AS CHAR.
 * DEFINE new SHARED VAR s-print-file AS CHAR.
 * DEFINE new SHARED VAR s-nro-copias AS INTEGER.
 * DEFINE new SHARED VAR s-orientacion AS INTEGER.*/

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "aplic/ccb/rbccb.prl".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Tarjeta".
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
RB-REPORT-LIBRARY = s-report-library + "ccb\rbccb.prl".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES gn-card
&Scoped-define FIRST-EXTERNAL-TABLE gn-card


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR gn-card.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS gn-card.NroCard gn-card.EstCard ~
gn-card.TipCli gn-card.TipBon[1] gn-card.NomClie[1] gn-card.AcuBon[4] ~
gn-card.ApeCli[1] gn-card.TipDocIde1[1] gn-card.Dir[1] gn-card.RefCli[1] ~
gn-card.RefDir1[1] gn-card.RefDir2[1] gn-card.NivEdu[1] gn-card.FchNac[1] ~
gn-card.Sexo[1] gn-card.EstCiv[1] gn-card.Email1[1] gn-card.Email2[1] ~
gn-card.FchNac[10] gn-card.EstCiv[9] gn-card.TelMov1[1] gn-card.TelMov2[1] ~
gn-card.TelFax1[1] gn-card.TelFax2[1] gn-card.EstCiv[10] gn-card.TelFij1[1] ~
gn-card.TelFij2[1] gn-card.Prov[1] gn-card.NroDocIde1[1] gn-card.Dist[1] ~
gn-card.NroDocIde2[1] gn-card.Dept[1] gn-card.Pais[1] 
&Scoped-define ENABLED-TABLES gn-card
&Scoped-define FIRST-ENABLED-TABLE gn-card
&Scoped-Define ENABLED-OBJECTS RECT-64 RECT-11 RECT-65 
&Scoped-Define DISPLAYED-FIELDS gn-card.NroCard gn-card.EstCard ~
gn-card.NomCard gn-card.TipCli gn-card.TipBon[1] gn-card.NomClie[1] ~
gn-card.AcuBon[4] gn-card.ApeCli[1] gn-card.TipDocIde1[1] gn-card.Dir[1] ~
gn-card.RefCli[1] gn-card.RefDir1[1] gn-card.RefDir2[1] gn-card.NivEdu[1] ~
gn-card.FchNac[1] gn-card.Sexo[1] gn-card.EstCiv[1] gn-card.Email1[1] ~
gn-card.Email2[1] gn-card.FchNac[10] gn-card.EstCiv[9] gn-card.TelMov1[1] ~
gn-card.TelMov2[1] gn-card.TelFax1[1] gn-card.TelFax2[1] gn-card.EstCiv[10] ~
gn-card.TelFij1[1] gn-card.TelFij2[1] gn-card.Prov[1] gn-card.NroDocIde1[1] ~
gn-card.Dist[1] gn-card.NroDocIde2[1] gn-card.Dept[1] gn-card.Pais[1] 
&Scoped-define DISPLAYED-TABLES gn-card
&Scoped-define FIRST-DISPLAYED-TABLE gn-card


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
DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 94.43 BY 18.08.

DEFINE RECTANGLE RECT-64
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 23 BY 3.65.

DEFINE RECTANGLE RECT-65
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36 BY 2.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     gn-card.NroCard AT ROW 1.19 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     gn-card.EstCard AT ROW 1.19 COL 80 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.14 BY .81
     gn-card.NomCard AT ROW 2.27 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 37 BY .81
     gn-card.TipCli AT ROW 2.27 COL 61.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.57 BY .81
     gn-card.TipBon[1] AT ROW 2.27 COL 79.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.86 BY .73
     gn-card.NomClie[1] AT ROW 3.27 COL 14 COLON-ALIGNED
          LABEL "Nombres"
          VIEW-AS FILL-IN 
          SIZE 37.14 BY .81
     gn-card.AcuBon[4] AT ROW 4.08 COL 67 COLON-ALIGNED HELP
          "No mas de 3%" WIDGET-ID 4
          LABEL "% Descuento" FORMAT ">9.99"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     gn-card.ApeCli[1] AT ROW 4.19 COL 14 COLON-ALIGNED
          LABEL "Apellidos"
          VIEW-AS FILL-IN 
          SIZE 37.14 BY .81
     gn-card.TipDocIde1[1] AT ROW 4.85 COL 67 COLON-ALIGNED WIDGET-ID 8
          LABEL "DNI" FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     gn-card.Dir[1] AT ROW 5.15 COL 13.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 37.14 BY .81
     gn-card.RefCli[1] AT ROW 6 COL 15.57 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 70.29 BY .81
     gn-card.RefDir1[1] AT ROW 6.88 COL 15.57 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 70.29 BY .81
     gn-card.RefDir2[1] AT ROW 7.77 COL 15.43 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 70.29 BY .81
     gn-card.NivEdu[1] AT ROW 8.65 COL 59.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     gn-card.FchNac[1] AT ROW 8.73 COL 13.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     gn-card.Sexo[1] AT ROW 8.73 COL 30.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.14 BY .81
     gn-card.EstCiv[1] AT ROW 8.73 COL 40.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     gn-card.Email1[1] AT ROW 9.73 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 30 BY .81
     gn-card.Email2[1] AT ROW 10.77 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 30 BY .81
     gn-card.FchNac[10] AT ROW 10.81 COL 79 COLON-ALIGNED
          LABEL "Fecha"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 15 FGCOLOR 12 
     gn-card.EstCiv[9] AT ROW 11.77 COL 79 COLON-ALIGNED
          LABEL "Usuario" FORMAT "x(10)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 15 FGCOLOR 12 
     gn-card.TelMov1[1] AT ROW 11.81 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
     gn-card.TelMov2[1] AT ROW 11.81 COL 34.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
     gn-card.TelFax1[1] AT ROW 12.65 COL 12.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
     gn-card.TelFax2[1] AT ROW 12.69 COL 34.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
     gn-card.EstCiv[10] AT ROW 12.73 COL 79 COLON-ALIGNED
          LABEL "Division" FORMAT "x(10)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 15 FGCOLOR 12 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     gn-card.TelFij1[1] AT ROW 13.58 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
     gn-card.TelFij2[1] AT ROW 13.65 COL 34.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
     gn-card.Prov[1] AT ROW 14.54 COL 13.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .81
     gn-card.NroDocIde1[1] AT ROW 14.62 COL 55.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     gn-card.Dist[1] AT ROW 15.35 COL 13.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .81
     gn-card.NroDocIde2[1] AT ROW 15.5 COL 55.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     gn-card.Dept[1] AT ROW 16.27 COL 13.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .81
     gn-card.Pais[1] AT ROW 17.23 COL 13.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     "SOLO PARA CHICLAYO" VIEW-AS TEXT
          SIZE 17 BY .5 AT ROW 3.31 COL 56 WIDGET-ID 6
          BGCOLOR 9 FGCOLOR 15 
     "Datos de la inscripción" VIEW-AS TEXT
          SIZE 17 BY .5 AT ROW 10.23 COL 71
          BGCOLOR 1 FGCOLOR 15 
     RECT-64 AT ROW 10.42 COL 70
     RECT-11 AT ROW 1 COL 1
     RECT-65 AT ROW 3.5 COL 55 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.gn-card
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
         HEIGHT             = 18.12
         WIDTH              = 94.72.
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
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR FILL-IN gn-card.AcuBon[4] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR FILL-IN gn-card.ApeCli[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-card.EstCiv[10] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-card.EstCiv[9] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-card.FchNac[10] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-card.NomCard IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-card.NomClie[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-card.RefCli[1] IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN gn-card.RefDir1[1] IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN gn-card.RefDir2[1] IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN gn-card.TipDocIde1[1] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
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

&Scoped-define SELF-NAME gn-card.NroCard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-card.NroCard V-table-Win
ON LEAVE OF gn-card.NroCard IN FRAME F-Main /* NroCard */
DO:
  ASSIGN
    SELF:SCREEN-VALUE = STRING(DECIMAL(SELF:SCREEN-VALUE), '999999')
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
  {src/adm/template/row-list.i "gn-card"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "gn-card"}

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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      gn-card.nomcard = TRIM (gn-card.apecli[1]) + ', ' + TRIM (gn-card.nomcli[1]).
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' 
  THEN ASSIGN
        Gn-Card.FchNac[10] = TODAY  /* Fecha de creacion */
        gn-card.EstCiv[9]  = s-User-Id
        gn-card.EstCiv[10] = s-CodDiv.

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
  DO WITH FRAME {&FRAME-NAME}:
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
  DEFINE VAR X-NUMERO AS CHAR.
  X-NUMERO = Gn-card.NroCard .
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /*RUN bin/_prnctr.p.*/
  RUN lib/Imprimir2.
  IF s-salida-impresion = 0 THEN RETURN.

  
  /* test de impresion */
  s-titulo = "Tarjeta Cliente Exclusivo".
  RB-INCLUDE-RECORDS = "O".
  
  RB-FILTER = "Gn-Card.NroCard = '" + x-numero + "'"  .
  
           
  RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia +
                        "~ns-titulo = " + s-titulo .
                        
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
  
  RUN aderb/_prntrb2 (RB-REPORT-LIBRARY,
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
                      RB-OTHER-PARAMETERS,
                      "").    
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
  {src/adm/template/snd-list.i "gn-card"}

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
  
  integral.Gn-Card.NroCard:sensitive in frame {&FRAME-NAME} = no.
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
   IF Gn-Card.NroCard:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Numero de Tarjeta no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Gn-Card.NroCard.
      RETURN "ADM-ERROR".   
   END.
   RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
   IF RETURN-VALUE = 'YES'
   THEN DO:
    IF CAN-FIND(FIRST gn-card WHERE gn-card.nrocard = Gn-Card.NroCard:SCREEN-VALUE 
        NO-LOCK)
    THEN DO:
        MESSAGE 'El numero de tarjeta esta repetido' VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Gn-Card.NroCard.
        RETURN "ADM-ERROR".
    END.
   END.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
    /* Que no se repita el nombre */
    IF CAN-FIND(FIRST Gn-Card WHERE Gn-Card.NomCli[1] = Gn-Card.NOmCli[1]:SCREEN-VALUE NO-LOCK)
    THEN DO:
        MESSAGE 'Nombre repetido' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO Gn-Card.NomCli[1].
        RETURN 'ADM-ERROR'.
    END.
  END.
  IF INPUT gn-card.acubon[4] > 3.00 THEN DO:
      MESSAGE 'El % Descuento para CHICLAYO no puede ser mas de 3%'
          VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO acubon[4].
      RETURN 'ADM-ERROR'.
  END.
  IF INPUT gn-card.acubon[4] > 0.00 THEN DO:
      IF gn-card.TipDocIde1[1]:SCREEN-VALUE = '' THEN DO:
          MESSAGE 'Ingrese en DNI' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO gn-card.TipDocIde1[1].
          RETURN 'ADM-ERROR'.
      END.
      ASSIGN
          gn-card.TipDocIde1[1]:SCREEN-VALUE = STRING(INTEGER(gn-card.TipDocIde1[1]:SCREEN-VALUE), '99999999')
          NO-ERROR.
      IF ERROR-STATUS:ERROR THEN DO:
          MESSAGE 'DNI mal ingresado' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO gn-card.TipDocIde1[1].
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
IF NOT AVAILABLE Gn-Card THEN RETURN "ADM-ERROR".
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

