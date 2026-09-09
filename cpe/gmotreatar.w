&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
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

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF INPUT PARAMETER pRowid AS ROWID.

FIND CpeTareas WHERE ROWID(CpeTareas) = pRowid NO-LOCK.

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

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-CodPer-2 COMBO-BOX-Motivo Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodPer-1 FILL-IN-NomPer-1 ~
FILL-IN-CodPer-2 FILL-IN-NomPer-2 FILL-IN-Area COMBO-BOX-Motivo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNomPer gDialog 
FUNCTION fNomPer RETURNS CHARACTER
  ( INPUT pCodPer AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Cancel" 
     SIZE 15 BY 1.62.

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "OK" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE COMBO-BOX-Motivo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Motivo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Area AS CHARACTER FORMAT "X(256)":U 
     LABEL "Area" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPer-1 AS CHARACTER FORMAT "X(6)":U 
     LABEL "Personal saliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPer-2 AS CHARACTER FORMAT "X(6)":U 
     LABEL "Personal entrante" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPer-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPer-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     FILL-IN-CodPer-1 AT ROW 1.54 COL 19 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-NomPer-1 AT ROW 1.54 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     FILL-IN-CodPer-2 AT ROW 2.62 COL 19 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-NomPer-2 AT ROW 2.62 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     FILL-IN-Area AT ROW 3.69 COL 19 COLON-ALIGNED WIDGET-ID 12
     COMBO-BOX-Motivo AT ROW 4.77 COL 19 COLON-ALIGNED WIDGET-ID 10
     Btn_OK AT ROW 6.38 COL 3
     Btn_Cancel AT ROW 6.38 COL 18
     SPACE(57.13) SKIP(0.45)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "REASIGNACION DE TAREAS"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


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

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Area IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodPer-1 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPer-1 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPer-2 IN FRAME gDialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* REASIGNACION DE TAREAS */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK gDialog
ON CHOOSE OF Btn_OK IN FRAME gDialog /* OK */
DO:
    FIND pl-pers WHERE pl-pers.codper = FILL-IN-CodPer-2:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pl-pers THEN DO:
        MESSAGE 'Personal NO registrado' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    FIND cpetrased WHERE cpetrased.CodCia = s-codcia
        AND cpetrased.CodDiv = s-coddiv
        AND cpetrased.CodPer = FILL-IN-CodPer-2:SCREEN-VALUE
        AND cpetrased.FlgEst = 'P'
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cpetrased THEN DO:
        MESSAGE 'Trabajador NO registrado en la SEDE' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF CpeTraSed.FlgTarea <> 'L' THEN DO:
        MESSAGE 'El trabajador YA tiene una tarea asignada' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    /* Grabación */
    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        FIND CURRENT CpeTareas EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE CpeTareas THEN UNDO, RETURN 'ADM-ERROR'.
        /* Tracking de Tareas */
        CREATE CpeTrkTar.
        BUFFER-COPY CpeTareas TO CpeTrkTar.
        ASSIGN
            CpeTrkTar.Estado = 'Tarea Cerrada por Reasignación'
            CpeTrkTar.CodMot = ENTRY(1, COMBO-BOX-Motivo, ' - ')
            CpeTrkTar.Fecha = DATETIME(TODAY, MTIME)
            CpeTrkTar.FchFin = DATETIME(TODAY, MTIME)
            CpeTrkTar.Usuario = s-user-id.
        /* ***************** */
        /* Cambiamos el personal */
        ASSIGN
            CpeTareas.CodMot = ENTRY(1, COMBO-BOX-Motivo:SCREEN-VALUE, ' - ')
            CpeTareas.CodPer = FILL-IN-CodPer-2:SCREEN-VALUE
            CpeTareas.FchInicio = DATETIME(TODAY, MTIME)
            CpeTareas.UsuarioReg = s-user-id.
        /* Tracking de Tareas */
        CREATE CpeTrkTar.
        BUFFER-COPY CpeTareas TO CpeTrkTar.
        ASSIGN
            CpeTrkTar.Estado = 'Tarea Asignada por Reasignación'
            CpeTrkTar.CodMot = ENTRY(1, COMBO-BOX-Motivo, ' - ')
            CpeTrkTar.Fecha = DATETIME(TODAY, MTIME)
            CpeTrkTar.Usuario = s-user-id.
        /* ***************** */
        /* Liberamos de la tarea */
        FIND cpetrased WHERE cpetrased.CodCia = s-codcia
            AND cpetrased.CodDiv = s-coddiv
            AND cpetrased.FlgEst = 'P'
            AND cpetrased.CodPer = FILL-IN-CodPer-1:SCREEN-VALUE
            EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE cpetrased THEN CpeTraSed.FlgTarea = 'L'.
        /* Lo marcamos como ocupado */
        FIND cpetrased WHERE cpetrased.CodCia = s-codcia
            AND cpetrased.CodDiv = s-coddiv
            AND cpetrased.FlgEst = 'P'
            AND cpetrased.CodPer = FILL-IN-CodPer-2:SCREEN-VALUE
            EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE cpetrased THEN CpeTraSed.FlgTarea = 'O'.
        RELEASE CpeTraSed.
        RELEASE CpeTareas.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodPer-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodPer-2 gDialog
ON LEAVE OF FILL-IN-CodPer-2 IN FRAME gDialog /* Personal entrante */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND pl-pers WHERE pl-pers.codper = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers THEN DO:
        FILL-IN-NomPer-2:SCREEN-VALUE = fNomPer(SELF:SCREEN-VALUE).
        FIND cpetrased WHERE cpetrased.CodCia = s-codcia
            AND cpetrased.CodDiv = s-coddiv
            AND cpetrased.CodPer = FILL-IN-CodPer-2:SCREEN-VALUE
            AND cpetrased.FlgEst = 'P'
            NO-LOCK NO-ERROR.
        IF AVAILABLE cpetrased THEN DO:
            FIND Almtabla WHERE Almtabla.Tabla = 'AS'
                AND almtabla.Codigo = cpetrased.CodArea
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtabla THEN FILL-IN-Area:SCREEN-VALUE = almtabla.Nombre.
        END.
        ELSE DO:
            MESSAGE 'Trabajador NO registrado en la SEDE' VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
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
  DISPLAY FILL-IN-CodPer-1 FILL-IN-NomPer-1 FILL-IN-CodPer-2 FILL-IN-NomPer-2 
          FILL-IN-Area COMBO-BOX-Motivo 
      WITH FRAME gDialog.
  ENABLE FILL-IN-CodPer-2 COMBO-BOX-Motivo Btn_OK Btn_Cancel 
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
      ASSIGN
          FILL-IN-CodPer-1:SCREEN-VALUE = CpeTareas.CodPer.
      FIND pl-pers WHERE pl-pers.codper = FILL-IN-CodPer-1:SCREEN-VALUE NO-LOCK NO-ERROR.
      FILL-IN-NomPer-1:SCREEN-VALUE = fNomPer(FILL-IN-CodPer-1:SCREEN-VALUE).
      FOR EACH Vtatabla NO-LOCK WHERE Vtatabla.codcia = s-codcia
          AND Vtatabla.tabla = 'CPEMOTREA':
          COMBO-BOX-Motivo:ADD-LAST(VtaTabla.Llave_c1 + ' - ' + VtaTabla.Llave_c2).
      END.
      COMBO-BOX-Motivo:SCREEN-VALUE = COMBO-BOX-Motivo:ENTRY(1).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNomPer gDialog 
FUNCTION fNomPer RETURNS CHARACTER
  ( INPUT pCodPer AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 
  FIND pl-pers WHERE pl-pers.codper = pCodPer NO-LOCK NO-ERROR.
  IF AVAILABLE pl-pers 
      THEN RETURN TRIM(pl-pers.patper) + ' ' + TRIM(pl-pers.matper) + ', ' + pl-pers.nomper.
    ELSE RETURN ''.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

