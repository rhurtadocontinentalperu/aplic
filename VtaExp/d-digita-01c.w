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

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

DEF INPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pResultado AS CHAR.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF BUFFER B-DIGIT FOR ExpDigit.

FIND B-Digit WHERE ROWID(B-Digit) = pRowid NO-LOCK NO-ERROR.

pResultado = 'ADM-ERROR'.

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
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ExpDigit

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 ExpDigit.CodDig ExpDigit.NomDig 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH ExpDigit ~
      WHERE ExpDigit.FlgEst = "L" ~
 AND ExpDigit.CodCia = s-codcia ~
 AND ExpDigit.CodDiv = s-coddiv  NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH ExpDigit ~
      WHERE ExpDigit.FlgEst = "L" ~
 AND ExpDigit.CodCia = s-codcia ~
 AND ExpDigit.CodDiv = s-coddiv  NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 ExpDigit
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 ExpDigit


/* Definitions for DIALOG-BOX gDialog                                   */
&Scoped-define OPEN-BROWSERS-IN-QUERY-gDialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 Btn_OK Btn_Cancel 

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

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      ExpDigit SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 gDialog _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      ExpDigit.CodDig FORMAT "x(5)":U
      ExpDigit.NomDig COLUMN-LABEL "Digitador" FORMAT "x(30)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 61 BY 14.81 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     BROWSE-2 AT ROW 2.08 COL 3 WIDGET-ID 200
     Btn_OK AT ROW 2.08 COL 65
     Btn_Cancel AT ROW 3.31 COL 65
     "Seleccione el digitador y pulse el botón OK" VIEW-AS TEXT
          SIZE 39 BY .62 AT ROW 1.27 COL 3 WIDGET-ID 2
          BGCOLOR 1 FGCOLOR 15 
     SPACE(40.71) SKIP(15.33)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "REAASIGNACION DE TAREA AL DIGITADOR"
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

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 TEXT-1 gDialog */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.ExpDigit"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "INTEGRAL.ExpDigit.FlgEst = ""L""
 AND INTEGRAL.ExpDigit.CodCia = s-codcia
 AND INTEGRAL.ExpDigit.CodDiv = s-coddiv "
     _FldNameList[1]   = INTEGRAL.ExpDigit.CodDig
     _FldNameList[2]   > INTEGRAL.ExpDigit.NomDig
"ExpDigit.NomDig" "Digitador" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* REAASIGNACION DE TAREA AL DIGITADOR */
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
  /* Verificaciones previas */
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR'
      ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND CURRENT B-Digit EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE B-Digit THEN LEAVE.
      IF B-Digit.FlgEst <> "O" THEN DO:
          MESSAGE 'El digitador' B-Digit.coddiv 'NO tiene tareas activas' VIEW-AS ALERT-BOX ERROR.
          LEAVE.
      END.
      FIND ExpTarea WHERE ExpTarea.CodCia  = B-Digit.codcia AND
          ExpTarea.CodDiv  = B-Digit.coddiv AND
          ExpTarea.CodDig  = B-Digit.coddig AND
          ExpTarea.Estado  = 'P'      /* Tarea Pendiente */
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE ExpTarea THEN DO:
          MESSAGE 'El digitador' B-Digit.coddig 'NO tiene tareas pendientes' VIEW-AS ALERT-BOX ERROR.
          LEAVE.
      END.
      FIND ExpTurno WHERE ROWID(ExpTurno) = TO-ROWID(ExpTarea.Libre_c01) EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE ExpTurno THEN LEAVE.
      IF ExpTurno.Estado <> 'D' THEN DO:
          MESSAGE 'El turno ya NO se encuentra pendiente de asignar tarea' VIEW-AS ALERT-BOX ERROR.
          LEAVE.
      END.
      FIND VtaCDocu WHERE Vtacdocu.codcia = B-Digit.codcia
        AND Vtacdocu.coddiv = B-Digit.coddiv
        AND Vtacdocu.codped = 'PET'
        AND Vtacdocu.libre_c03 = ExpTarea.Tipo + '-' + TRIM(STRING(ExpTurno.Turno))
        AND Vtacdocu.codven = ExpTarea.CodVen
        AND Vtacdocu.codcli = ExpTarea.CodCli
        AND Vtacdocu.flgest = "P"
        AND Vtacdocu.fchped >= TODAY - 1
        EXCLUSIVE-LOCK NO-ERROR.
/*       FIND VtaCDocu WHERE Vtacdocu.codcia = B-Digit.codcia */
/*           AND Vtacdocu.coddiv = B-Digit.coddiv             */
/*           AND Vtacdocu.codped = 'PET'                      */
/*           AND Vtacdocu.usuario = B-Digit.coddig            */
/*           AND Vtacdocu.flgest = "P"                        */
/*           AND Vtacdocu.fchped >= TODAY - 1                 */
/*           AND Vtacdocu.Libre_c01 = STRING(ROWID(ExpTarea)) */
/*           EXCLUSIVE-LOCK NO-ERROR.                         */
      FIND CURRENT ExpDigit EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE ExpDigit THEN LEAVE.
      IF ExpDigit.FlgEst <> "L" THEN DO:
          MESSAGE 'El digitador' ExpDigit.coddig 'ya tiene asignada una tarea'
              VIEW-AS ALERT-BOX ERROR.
          LEAVE.
      END.
      ASSIGN
          ExpDigit.FlgEst = "O"        /* Ocupado */
          B-Digit.FlgEst  = "L".       /* Libre */
      /* datos principales */
      ASSIGN
          ExpTarea.CodDig  = ExpDigit.coddig
          ExpTarea.Fecha   = TODAY 
          ExpTarea.Usuario = s-user-id
          ExpTarea.HorIni  = STRING(YEAR(TODAY), '9999') +
                            STRING(MONTH(TODAY), '99') +
                            STRING(DAY(TODAY), '99') +
                            SUBSTRING(STRING(TIME, 'HH:MM'),1,2) +
                            SUBSTRING(STRING(TIME, 'HH:MM'),4,2)
          ExpTarea.Libre_c02 = STRING (DATETIME(TODAY, MTIME), '99/99/9999 HH:MM:SS').
      IF AVAILABLE VtaCDocu THEN VtaCDocu.Usuario = ExpDigit.CodDig.
  END.
  IF AVAILABLE(B-Digit)  THEN RELEASE B-Digit.
  IF AVAILABLE(ExpTurno) THEN RELEASE ExpTurno.
  IF AVAILABLE(ExpDigit) THEN RELEASE ExpDigit.
  IF AVAILABLE(ExpTarea) THEN RELEASE ExpTarea.
  IF AVAILABLE(VtaCDocu) THEN RELEASE VtaCDocu.
  pResultado = 'OK'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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
  ENABLE BROWSE-2 Btn_OK Btn_Cancel 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

