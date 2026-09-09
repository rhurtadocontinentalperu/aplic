&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CLIE FOR gn-clie.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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
DEF INPUT-OUTPUT PARAMETER pcDirCli AS CHAR.
DEF INPUT-OUTPUT PARAMETER pcCodDept AS CHAR.
DEF INPUT-OUTPUT PARAMETER pcCodProv AS CHAR.
DEF INPUT-OUTPUT PARAMETER pcCodDist AS CHAR.
DEF OUTPUT PARAMETER pcError AS CHAR NO-UNDO.

pcError = "NO definida la dirección fiscal del cliente".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 F-DirCli F-CodDept F-CodProv ~
F-CodDist Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-DirCli F-CodDept F-CodProv F-CodDist ~
FILL-IN-DEP FILL-IN-PROV FILL-IN-DIS 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE F-CodDept AS CHARACTER FORMAT "X(2)" 
     LABEL "Departamento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81.

DEFINE VARIABLE F-CodDist AS CHARACTER FORMAT "X(2)" 
     LABEL "Distrito" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81.

DEFINE VARIABLE F-CodProv AS CHARACTER FORMAT "X(2)" 
     LABEL "Provincias" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81.

DEFINE VARIABLE F-DirCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Direccion Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 71 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DEP AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DIS AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-PROV AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 4.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     F-DirCli AT ROW 1.81 COL 13 COLON-ALIGNED WIDGET-ID 172
     F-CodDept AT ROW 2.62 COL 13 COLON-ALIGNED
     F-CodProv AT ROW 3.42 COL 13 COLON-ALIGNED
     F-CodDist AT ROW 4.23 COL 13 COLON-ALIGNED
     FILL-IN-DEP AT ROW 2.62 COL 20 COLON-ALIGNED NO-LABEL
     FILL-IN-PROV AT ROW 3.42 COL 20 COLON-ALIGNED NO-LABEL
     FILL-IN-DIS AT ROW 4.23 COL 20 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 1.54 COL 100
     Btn_Cancel AT ROW 3.15 COL 100
     RECT-1 AT ROW 1.27 COL 2 WIDGET-ID 170
     SPACE(26.85) SKIP(0.76)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "UBIGEO DIRECCION FISCAL".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CLIE B "?" ? INTEGRAL gn-clie
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME L-To-R,COLUMNS                                            */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-DEP IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DIS IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-PROV IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* UBIGEO DIRECCION FISCAL */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  MESSAGE 'Está seguro que los datos están correctos?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.

   ASSIGN 
       F-DirCli
       F-CodDept 
       F-CodDist 
       F-CodProv
       fill-in-dep
       fill-in-prov
       fill-in-dis
       .

   IF TRUE <> (F-DirCli > '') THEN DO:
       MESSAGE 'Debe ingresar la dirección fiscal' VIEW-AS ALERT-BOX WARNING.
       RETURN NO-APPLY.
   END.

    FIND FIRST Tabdistr WHERE Tabdistr.CodDepto = F-CodDept 
        AND Tabdistr.Codprovi = F-CodProv
        AND Tabdistr.Coddistr = F-CodDist NO-LOCK NO-ERROR.
    IF NOT AVAILABLE TabDistr THEN DO:
        MESSAGE 'Código de Distrito no Registrado' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.

    FIND FIRST Tabprovi WHERE Tabprovi.CodDepto = F-CodDept AND
        Tabprovi.Codprovi = F-CodProv NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Tabprovi THEN DO:
        MESSAGE 'Código de Provincia no Registrado' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.

    FIND FIRST TabDepto WHERE TabDepto.CodDepto = F-CodDept NO-LOCK NO-ERROR.
    IF NOT AVAILABLE TabDepto THEN DO:
        MESSAGE 'Código de Departamento no Registrado' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.

    ASSIGN
        pcDirCli = f-DirCli
        pcCodDept = f-CodDept
        pcCodDist = f-CodDist
        pcCodProv = f-CodProv
        pcError = ""
        .

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodDept
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodDept D-Dialog
ON LEAVE OF F-CodDept IN FRAME D-Dialog /* Departamento */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO:
     FIND  TabDepto WHERE TabDepto.CodDepto = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE TabDepto THEN
        Fill-in-dep:screen-value = TabDepto.NomDepto.
     ELSE 
        Fill-in-dep:screen-value = "".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodDist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodDist D-Dialog
ON LEAVE OF F-CodDist IN FRAME D-Dialog /* Distrito */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO:
     FIND Tabdistr WHERE Tabdistr.CodDepto = F-CodDept:SCREEN-VALUE AND
                       Tabdistr.Codprovi = F-CodProv:SCREEN-VALUE AND
                       Tabdistr.Coddistr = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE Tabdistr THEN 
        Fill-in-dis:screen-value = Tabdistr.Nomdistr .
     ELSE
        Fill-in-dis:screen-value = "".
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodProv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodProv D-Dialog
ON LEAVE OF F-CodProv IN FRAME D-Dialog /* Provincias */
DO:
   IF SELF:SCREEN-VALUE <> "" THEN DO:
      FIND Tabprovi WHERE Tabprovi.CodDepto = F-CodDept:SCREEN-VALUE AND
           Tabprovi.Codprovi = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF AVAILABLE Tabprovi THEN 
         fill-in-prov:screen-value = Tabprovi.Nomprovi.
      ELSE
         fill-in-prov:screen-value = "".
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-DirCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DirCli D-Dialog
ON LEAVE OF F-DirCli IN FRAME D-Dialog /* Direccion Fiscal */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY F-DirCli F-CodDept F-CodProv F-CodDist FILL-IN-DEP FILL-IN-PROV 
          FILL-IN-DIS 
      WITH FRAME D-Dialog.
  ENABLE RECT-1 F-DirCli F-CodDept F-CodProv F-CodDist Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  F-CodDept = pcCodDept.
  F-CodDist = pcCodDist.
  F-CodProv = pcCodProv.
  F-DirCli = pcDirCli.
  FIND  TabDepto WHERE TabDepto.CodDepto = F-CodDept NO-LOCK NO-ERROR.
  IF AVAILABLE TabDepto THEN Fill-in-dep = TabDepto.NomDepto.
  FIND Tabprovi WHERE Tabprovi.CodDepto = F-CodDept AND
      Tabprovi.Codprovi = F-CodProv NO-LOCK NO-ERROR.
  IF AVAILABLE Tabprovi THEN fill-in-prov = Tabprovi.Nomprovi.
  FIND Tabdistr WHERE Tabdistr.CodDepto = F-CodDept AND
      Tabdistr.Codprovi = F-CodProv AND
      Tabdistr.Coddistr = F-CodDist NO-ERROR.
  IF AVAILABLE Tabdistr THEN Fill-in-dis = Tabdistr.Nomdistr .

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros D-Dialog 
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
        WHEN "" THEN DO:
        END.
    END CASE.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros D-Dialog 
PROCEDURE Recoge-Parametros :
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
       ASSIGN F-CodDept F-CodProv F-CodDist.
       CASE HANDLE-CAMPO:name:
            WHEN "F-GirCli"  THEN ASSIGN input-var-1 = "GN".
            WHEN "F-CodProv" THEN ASSIGN input-var-1 = F-CodDept.
            WHEN "F-CodDist" THEN ASSIGN input-var-1 = F-CodDept
                                         input-var-2 = F-CodProv.
         /* ASSIGN input-para-1 = ""
                   input-para-2 = ""
                   input-para-3 = "". */
       END CASE.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

