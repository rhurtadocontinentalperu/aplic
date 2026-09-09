&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
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
DEFINE INPUT-OUTPUT PARAMETER S-CODCLI AS CHAR.
/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE CL-CODCIA  AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES gn-clie

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define QUERY-STRING-D-Dialog FOR EACH gn-clie SHARE-LOCK
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH gn-clie SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog gn-clie


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS F-CodCli F-NomCli F-DirCli F-RucCli F-TlfCli ~
F-DNICli F-GirCli F-CodDept F-CodProv F-CodDist f-vende f-condvta Btn_OK ~
Btn_Cancel RECT-19 
&Scoped-Define DISPLAYED-OBJECTS F-CodCli F-NomCli F-DirCli F-RucCli ~
F-TlfCli F-DNICli F-GirCli F-CodDept F-CodProv F-CodDist f-vende f-condvta ~
f-descond f-nomven F-giro FILL-IN-DEP FILL-IN-PROV FILL-IN-DIS 

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

DEFINE VARIABLE F-CodCli AS CHARACTER FORMAT "X(9)":U 
     LABEL "Codigo" 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .81 NO-UNDO.

DEFINE VARIABLE F-CodDept AS CHARACTER FORMAT "X(2)" 
     LABEL "Departamento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81.

DEFINE VARIABLE F-CodDist AS CHARACTER FORMAT "X(2)" 
     LABEL "Distrito" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81.

DEFINE VARIABLE F-CodProv AS CHARACTER FORMAT "X(2)" 
     LABEL "Provincias" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81.

DEFINE VARIABLE f-condvta AS CHARACTER FORMAT "XXX":U 
     LABEL "Condicion Vta." 
     VIEW-AS FILL-IN 
     SIZE 4.86 BY .81 NO-UNDO.

DEFINE VARIABLE f-descond AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-DirCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Direccion" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .81 NO-UNDO.

DEFINE VARIABLE F-DNICli AS CHARACTER FORMAT "x(8)" 
     LABEL "DNI" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81.

DEFINE VARIABLE F-GirCli AS CHARACTER FORMAT "X(4)" 
     LABEL "Giro Empr." 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .81.

DEFINE VARIABLE F-giro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-NomCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .81 NO-UNDO.

DEFINE VARIABLE f-nomven AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-RucCli AS CHARACTER FORMAT "X(8)":U 
     LABEL "RUC" 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .81 NO-UNDO.

DEFINE VARIABLE F-TlfCli AS CHARACTER FORMAT "X(13)":U 
     LABEL "Telefono" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE f-vende AS CHARACTER FORMAT "XXX":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 4.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DEP AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DIS AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-PROV AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28.86 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 9.62.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      gn-clie SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     F-CodCli AT ROW 1.19 COL 10 COLON-ALIGNED
     F-NomCli AT ROW 2 COL 10 COLON-ALIGNED
     F-DirCli AT ROW 2.81 COL 10 COLON-ALIGNED
     F-RucCli AT ROW 3.62 COL 10 COLON-ALIGNED
     F-TlfCli AT ROW 3.65 COL 34 COLON-ALIGNED
     F-DNICli AT ROW 4.46 COL 10 COLON-ALIGNED HELP
          "DNI DEL (Cliente)"
     F-GirCli AT ROW 5.27 COL 10 COLON-ALIGNED
     F-CodDept AT ROW 6.04 COL 10 COLON-ALIGNED
     F-CodProv AT ROW 6.85 COL 10 COLON-ALIGNED
     F-CodDist AT ROW 7.65 COL 10 COLON-ALIGNED
     f-vende AT ROW 8.46 COL 10 COLON-ALIGNED
     f-condvta AT ROW 9.27 COL 10 COLON-ALIGNED
     f-descond AT ROW 9.31 COL 16.43 COLON-ALIGNED NO-LABEL
     f-nomven AT ROW 8.46 COL 16.43 COLON-ALIGNED NO-LABEL
     F-giro AT ROW 5.27 COL 16.43 COLON-ALIGNED NO-LABEL
     FILL-IN-DEP AT ROW 6.04 COL 16.43 COLON-ALIGNED NO-LABEL
     FILL-IN-PROV AT ROW 6.85 COL 16.43 COLON-ALIGNED NO-LABEL
     FILL-IN-DIS AT ROW 7.65 COL 16.43 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 3.04 COL 49.29
     Btn_Cancel AT ROW 5.42 COL 49.29
     RECT-19 AT ROW 1 COL 1
     SPACE(13.85) SKIP(0.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Registro de Clientes".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
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
   FRAME-NAME Custom                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN f-descond IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-giro IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-nomven IN FRAME D-Dialog
   NO-ENABLE                                                            */
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
     _TblList          = "integral.gn-clie"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Registro de Clientes */
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
   ASSIGN F-CodCli 
          F-CodDept 
          F-CodDist 
          F-CodProv 
          F-DirCli 
          F-NomCli 
          F-RucCli
          F-DNICli 
          F-TlfCli 
          F-Vende 
          F-CondVta.
          
   IF F-CodCli = "" THEN DO:
      MESSAGE "Codigo de Cliente en blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-CodCli.
      RETURN NO-APPLY.
   END.
   IF F-NomCli = "" THEN DO:
      MESSAGE "Nombre de Cliente en blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-NomCli.
      RETURN NO-APPLY.
   END.
   RUN Crea-Cliente.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodCli D-Dialog
ON LEAVE OF F-CodCli IN FRAME D-Dialog /* Codigo */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
                AND  gn-clie.CodCli = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie THEN DO:
     MESSAGE "Codigo ya existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  F-RucCli:SCREEN-VALUE = SUBSTRING(SELF:SCREEN-VALUE,1,8).
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


&Scoped-define SELF-NAME f-condvta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-condvta D-Dialog
ON LEAVE OF f-condvta IN FRAME D-Dialog /* Condicion Vta. */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO:
  /*   
  gn-ConVt.Codig 
  gn-ConVt.Nombr 
  gn-ConVt.TipVta 
  gn-ConVt.TotDias 
  gn-ConVt.Vencmtos
  */   
  FIND gn-ConVt WHERE gn-ConVt.Codig = F-condvta:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ConVt THEN 
        F-descond:screen-value = gn-ConVt.Nombr.
     ELSE
        F-descond:screen-value = "".
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-GirCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-GirCli D-Dialog
ON LEAVE OF F-GirCli IN FRAME D-Dialog /* Giro Empr. */
DO:
  ASSIGN F-GirCli.
  IF F-GirCli <> "" THEN DO:
  FIND Almtabla WHERE Almtabla.Tabla = "GN" AND 
                      Almtabla.Codigo = F-GirCli NO-LOCK NO-ERROR.
    IF AVAILABLE Almtabla THEN 
        F-giro:screen-value = Almtabla.Nombre.
    ELSE
        F-giro:screen-value = "".
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-NomCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-NomCli D-Dialog
ON LEAVE OF F-NomCli IN FRAME D-Dialog /* Nombre */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-vende
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-vende D-Dialog
ON LEAVE OF f-vende IN FRAME D-Dialog /* Vendedor */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO:
     FIND gn-ven WHERE gn-ven.CodVen = F-vende:SCREEN-VALUE AND
                       gn-ven.PtoVta = S-CODDIV NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN 
        F-nomven:screen-value = gn-ven.NomVen.
     ELSE
        F-nomven:screen-value = "".
  END.  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Cliente D-Dialog 
PROCEDURE Crea-Cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO TRANSACTION ON STOP UNDO, RETURN "ADM-ERROR":U
               ON ERROR UNDO, RETURN "ADM-ERROR":U
   WITH FRAME {&FRAME-NAME}:
   CREATE gn-clie.
   ASSIGN gn-clie.CodCia     = 0 
          gn-clie.CodCli     = F-CodCli 
          gn-clie.NomCli     = F-NomCli 
          gn-clie.DirCli     = F-DirCli 
          gn-clie.Ruc        = F-RucCli 
          gn-clie.DNI        = F-DNICli
          gn-clie.Telfnos[1] = F-TlfCli 
          gn-clie.clfCli     = "M" 
          gn-clie.CodDept    = F-CodDept 
          gn-clie.CodDist    = F-CodDist 
          gn-clie.CodPais    = "01" 
          gn-clie.CodVen     = F-vende
          gn-clie.CndVta     = F-CondVta
          gn-clie.CodProv    = F-CodProv 
          gn-clie.Fching     = TODAY 
          gn-clie.usuario    = S-USER-ID 
          gn-clie.TpoCli     = "1"
          gn-clie.CodDiv     = S-CODDIV.
   S-CODCLI = gn-clie.CodCli.
END.
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
  DISPLAY F-CodCli F-NomCli F-DirCli F-RucCli F-TlfCli F-DNICli F-GirCli 
          F-CodDept F-CodProv F-CodDist f-vende f-condvta f-descond f-nomven 
          F-giro FILL-IN-DEP FILL-IN-PROV FILL-IN-DIS 
      WITH FRAME D-Dialog.
  ENABLE F-CodCli F-NomCli F-DirCli F-RucCli F-TlfCli F-DNICli F-GirCli 
         F-CodDept F-CodProv F-CodDist f-vende f-condvta Btn_OK Btn_Cancel 
         RECT-19 
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  DISPLAY S-CODCLI @ F-CodCli WITH FRAME {&FRAME-NAME}.
  S-CODCLI = "".
  
  APPLY "ENTRY" TO F-CodCli.
  RETURN NO-APPLY.
  
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
        WHEN "F-CodCli" THEN DO:
            IF output-var-2 <> ? THEN DO:
                F-CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = output-var-2.
                F-NomCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = output-var-3.
            END.
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
            WHEN "F-CodCli"  THEN ASSIGN input-var-1 = SUBSTRING(F-CodCli:SCREEN-VALUE,1,8).
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "gn-clie"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

