&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM2 SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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
DEF INPUT PARAMETER pRowid AS ROWID.
/*DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.*/

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

FIND gn-clie WHERE ROWID(gn-clie) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clie THEN RETURN "ADM-ERROR".

/*pError = "ERROR".       /* Valor por defecto */*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME gDialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES gn-clie

/* Definitions for DIALOG-BOX gDialog                                   */
&Scoped-define FIELDS-IN-QUERY-gDialog gn-clie.CodCli gn-clie.NomCli ~
gn-clie.DirCli gn-clie.DirRef gn-clie.DirEnt gn-clie.Telfnos[1] ~
gn-clie.Telfnos[2] gn-clie.E-Mail gn-clie.CodDiv gn-clie.CodDept ~
gn-clie.CodProv gn-clie.CodDist gn-clie.Codpos gn-clie.NroCard ~
gn-clie.CodVen 
&Scoped-define ENABLED-FIELDS-IN-QUERY-gDialog gn-clie.DirRef ~
gn-clie.DirEnt gn-clie.Telfnos[1] gn-clie.Telfnos[2] gn-clie.E-Mail 
&Scoped-define ENABLED-TABLES-IN-QUERY-gDialog gn-clie
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-gDialog gn-clie
&Scoped-define QUERY-STRING-gDialog FOR EACH gn-clie SHARE-LOCK
&Scoped-define OPEN-QUERY-gDialog OPEN QUERY gDialog FOR EACH gn-clie SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-gDialog gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-gDialog gn-clie


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS gn-clie.DirRef gn-clie.DirEnt ~
gn-clie.Telfnos[1] gn-clie.Telfnos[2] gn-clie.E-Mail 
&Scoped-define ENABLED-TABLES gn-clie
&Scoped-define FIRST-ENABLED-TABLE gn-clie
&Scoped-Define ENABLED-OBJECTS Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-FIELDS gn-clie.CodCli gn-clie.NomCli ~
gn-clie.DirCli gn-clie.DirRef gn-clie.DirEnt gn-clie.Telfnos[1] ~
gn-clie.Telfnos[2] gn-clie.E-Mail gn-clie.CodDiv gn-clie.CodDept ~
gn-clie.CodProv gn-clie.CodDist gn-clie.Codpos gn-clie.NroCard ~
gn-clie.CodVen 
&Scoped-define DISPLAYED-TABLES gn-clie
&Scoped-define FIRST-DISPLAYED-TABLE gn-clie
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-DesDiv FILL-IN-DEP FILL-IN-PROV ~
FILL-IN-DIS FILL-IN-POS FILL-IN-NomCli F-NomVen 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.15.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.15.

DEFINE VARIABLE F-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 63 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DEP AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesDiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 63 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DIS AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-POS AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-PROV AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY gDialog FOR 
      gn-clie SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     gn-clie.CodCli AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
          BGCOLOR 15 FGCOLOR 1 
     gn-clie.NomCli AT ROW 2.08 COL 19 COLON-ALIGNED WIDGET-ID 10 FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 70 BY .81
     gn-clie.DirCli AT ROW 2.88 COL 19 COLON-ALIGNED WIDGET-ID 4
          LABEL "Direccion"
          VIEW-AS FILL-IN 
          SIZE 70 BY .81
     gn-clie.DirRef AT ROW 3.69 COL 19 COLON-ALIGNED WIDGET-ID 46
          LABEL "Referencia"
          VIEW-AS FILL-IN 
          SIZE 70 BY .81
     gn-clie.DirEnt AT ROW 4.5 COL 19 COLON-ALIGNED WIDGET-ID 44
          LABEL "Entregar en"
          VIEW-AS FILL-IN 
          SIZE 70 BY .81
     gn-clie.Telfnos[1] AT ROW 5.31 COL 19 COLON-ALIGNED WIDGET-ID 12
          LABEL "Telefono 1"
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
     gn-clie.Telfnos[2] AT ROW 6.12 COL 19 COLON-ALIGNED WIDGET-ID 14
          LABEL "Telefono 2"
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
     gn-clie.FaxCli AT ROW 6.92 COL 19 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
     gn-clie.E-Mail AT ROW 7.73 COL 19 COLON-ALIGNED WIDGET-ID 6 FORMAT "X(50)"
          VIEW-AS FILL-IN 
          SIZE 30 BY .81
     gn-clie.CodDiv AT ROW 8.54 COL 19 COLON-ALIGNED WIDGET-ID 40 FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     gn-clie.CodDept AT ROW 9.35 COL 19 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     gn-clie.CodProv AT ROW 10.12 COL 19 COLON-ALIGNED WIDGET-ID 22
          LABEL "Provincia"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     gn-clie.CodDist AT ROW 10.88 COL 19 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     gn-clie.Codpos AT ROW 11.65 COL 19 COLON-ALIGNED WIDGET-ID 20
          LABEL "Codigo Postal"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     gn-clie.NroCard AT ROW 12.58 COL 19 COLON-ALIGNED WIDGET-ID 38
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     gn-clie.CodVen AT ROW 13.35 COL 19.14 COLON-ALIGNED WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     FILL-IN-DesDiv AT ROW 8.54 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     FILL-IN-DEP AT ROW 9.35 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     FILL-IN-PROV AT ROW 10.12 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     FILL-IN-DIS AT ROW 10.88 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     FILL-IN-POS AT ROW 11.65 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     FILL-IN-NomCli AT ROW 12.58 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     F-NomVen AT ROW 13.35 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     Btn_OK AT ROW 1.27 COL 93
     Btn_Cancel AT ROW 2.5 COL 93
     SPACE(1.28) SKIP(10.84)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "ACTUALIZACION DE DATOS DEL CLIENTE"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
   FRAME-NAME L-To-R,COLUMNS                                            */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN gn-clie.CodCli IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.CodDept IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.CodDist IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.CodDiv IN FRAME gDialog
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.Codpos IN FRAME gDialog
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN gn-clie.CodProv IN FRAME gDialog
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN gn-clie.CodVen IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.DirCli IN FRAME gDialog
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN gn-clie.DirEnt IN FRAME gDialog
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.DirRef IN FRAME gDialog
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.E-Mail IN FRAME gDialog
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN F-NomVen IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.FaxCli IN FRAME gDialog
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       gn-clie.FaxCli:HIDDEN IN FRAME gDialog           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-DEP IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DesDiv IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DIS IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-POS IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-PROV IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.NomCli IN FRAME gDialog
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.NroCard IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.Telfnos[1] IN FRAME gDialog
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.Telfnos[2] IN FRAME gDialog
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _TblList          = "INTEGRAL.gn-clie"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* ACTUALIZACION DE DATOS DEL CLIENTE */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel gDialog
ON CHOOSE OF Btn_Cancel IN FRAME gDialog /* Cancel */
DO:
  RETURN "ADM-ERROR".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK gDialog
ON CHOOSE OF Btn_OK IN FRAME gDialog /* OK */
DO:
    FIND  gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = gn-clie.coddiv:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-divi THEN DO:
        MESSAGE 'División no registrada' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':u TO gn-clie.coddiv.
        RETURN NO-APPLY.
    END.

    FIND CURRENT gn-clie EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN DO:
        ASSIGN FRAME {&FRAME-NAME}
            gn-clie.NomCli
            gn-clie.CodDept 
            gn-clie.CodDist
            gn-clie.CodDiv
            gn-clie.Codpos 
            gn-clie.CodProv 
            gn-clie.CodVen 
            gn-clie.DirCli 
            gn-clie.E-Mail 
            gn-clie.FaxCli 
            gn-clie.NroCard 
            gn-clie.Telfnos[1] 
            gn-clie.Telfnos[2]
            gn-clie.DirRef
            gn-clie.DirEnt.
        ASSIGN
          gn-clie.usuario = s-user-id
          gn-clie.fchact = TODAY.
        /*pError = "".*/
    END.
    RELEASE gn-clie.
    RETURN "OK".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.CodDept
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.CodDept gDialog
ON LEAVE OF gn-clie.CodDept IN FRAME gDialog /* Departamento */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO:
    FIND  TabDepto WHERE TabDepto.CodDepto = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE TabDepto THEN DO:
        MESSAGE 'Departamento no registrado' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    Fill-in-dep:screen-value = TabDepto.NomDepto.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.CodDist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.CodDist gDialog
ON LEAVE OF gn-clie.CodDist IN FRAME gDialog /* Distrito */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO:
    FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept:screen-value 
        AND Tabdistr.Codprovi = gn-clie.codprov:screen-value 
        AND Tabdistr.Coddistr = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE TabDistr THEN DO:
        MESSAGE 'Distrito no registrado' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    Fill-in-dis:screen-value = Tabdistr.Nomdistr .
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.CodDiv gDialog
ON LEAVE OF gn-clie.CodDiv IN FRAME gDialog /* Division */
DO:
    IF SELF:SCREEN-VALUE <> "" THEN DO:
      FIND  gn-divi WHERE gn-divi.codcia = s-codcia
          AND gn-divi.coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-divi THEN DO:
          MESSAGE 'División no registrada' VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.
      Fill-in-desdiv:screen-value = GN-DIVI.DesDiv.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.Codpos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.Codpos gDialog
ON LEAVE OF gn-clie.Codpos IN FRAME gDialog /* Codigo Postal */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO:
    FIND almtabla WHERE almtabla.Tabla = 'CP' 
        AND almtabla.Codigo = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE AlmTabla THEN DO:
        MESSAGE 'Código postal no registrado' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    FILL-IN-POS:screen-value = almtabla.nombre.
  END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.CodProv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.CodProv gDialog
ON LEAVE OF gn-clie.CodProv IN FRAME gDialog /* Provincia */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO:
    FIND  Tabprovi WHERE Tabprovi.CodDepto = gn-clie.CodDept:screen-value 
        AND Tabprovi.Codprovi = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE TabProvi THEN DO:
        MESSAGE 'Provincia no registrada' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    fill-in-prov:screen-value = Tabprovi.Nomprovi.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.CodVen gDialog
ON LEAVE OF gn-clie.CodVen IN FRAME gDialog /* Codigo Vendedor */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO:
     FIND gn-ven WHERE gn-ven.codcia = s-codcia
        AND gn-ven.CodVen = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gn-ven THEN DO:
         MESSAGE 'Vendedor no registrado' VIEW-AS ALERT-BOX ERROR.
         RETURN NO-APPLY.
     END.
     F-NomVen:screen-value = gn-ven.NomVen.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.NomCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.NomCli gDialog
ON LEAVE OF gn-clie.NomCli IN FRAME gDialog /* Nombre */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.NroCard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.NroCard gDialog
ON LEAVE OF gn-clie.NroCard IN FRAME gDialog /* NroCard */
DO:
  IF SELF:SCREEN-VALUE <> ''
  THEN DO:
    FIND GN-CARD WHERE gn-card.nrocard = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-card THEN DO:
        MESSAGE 'Tarjtea no registrada' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    FILL-IN-NomCli:SCREEN-VALUE = gn-card.nomclie[1].
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY FILL-IN-DesDiv FILL-IN-DEP FILL-IN-PROV FILL-IN-DIS FILL-IN-POS 
          FILL-IN-NomCli F-NomVen 
      WITH FRAME gDialog.
  IF AVAILABLE gn-clie THEN 
    DISPLAY gn-clie.CodCli gn-clie.NomCli gn-clie.DirCli gn-clie.DirRef 
          gn-clie.DirEnt gn-clie.Telfnos[1] gn-clie.Telfnos[2] gn-clie.E-Mail 
          gn-clie.CodDiv gn-clie.CodDept gn-clie.CodProv gn-clie.CodDist 
          gn-clie.Codpos gn-clie.NroCard gn-clie.CodVen 
      WITH FRAME gDialog.
  ENABLE gn-clie.DirRef gn-clie.DirEnt gn-clie.Telfnos[1] gn-clie.Telfnos[2] 
         gn-clie.E-Mail Btn_OK Btn_Cancel 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject gDialog 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FIND  TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF AVAILABLE TabDepto THEN DO:
          Fill-in-dep:screen-value = TabDepto.NomDepto.
      END.
      FIND  Tabprovi WHERE Tabprovi.CodDepto = gn-clie.CodDept:screen-value 
          AND Tabprovi.Codprovi = gn-clie.CodProv:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF AVAILABLE TabProvi THEN DO:
          fill-in-prov:screen-value = Tabprovi.Nomprovi.
      END.
      FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept:screen-value 
          AND Tabdistr.Codprovi = gn-clie.codprov:screen-value 
          AND Tabdistr.Coddistr = gn-clie.CodDist:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF AVAILABLE TabDistr THEN DO:
          Fill-in-dis:screen-value = Tabdistr.Nomdistr .
      END.
      FIND almtabla WHERE almtabla.Tabla = 'CP' 
          AND almtabla.Codigo = gn-clie.CodPos:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF AVAILABLE AlmTabla THEN DO:
          FILL-IN-POS:screen-value = almtabla.nombre.
      END.
      FIND GN-CARD WHERE gn-card.nrocard = gn-clie.nrocard:SCREEN-VALUE
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-card THEN DO:
          FILL-IN-NomCli:SCREEN-VALUE = gn-card.nomclie[1].
      END.
      FIND gn-ven WHERE gn-ven.codcia = s-codcia
         AND gn-ven.CodVen = gn-clie.codven:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF AVAILABLE gn-ven THEN DO:
          F-NomVen:screen-value = gn-ven.NomVen.
      END.
      FIND  gn-divi WHERE gn-divi.codcia = s-codcia
          AND gn-divi.coddiv = gn-clie.coddiv:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF AVAILABLE gn-divi THEN DO:
          FILL-IN-DesDiv:SCREEN-VALUE = gn-divi.desdiv.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros gDialog 
PROCEDURE Procesa-Parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros gDialog 
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
    DO with frame {&FRAME-NAME} :    
     CASE HANDLE-CAMPO:name:
        WHEN "CodPos" THEN ASSIGN input-var-1 = "CP".
        WHEN "CodProv" THEN ASSIGN input-var-1 = gn-clie.CodDept:screen-value.
        WHEN "CodDist" THEN DO:
               input-var-1 = gn-clie.CodDept:screen-value.
               input-var-2 = GN-clie.CodProv:screen-value.
          END.
     END CASE.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

