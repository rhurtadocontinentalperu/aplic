&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral          PROGRESS
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

/* Local Variable Definitions ---                                       */

DEFINE SHARED VAR s-Codcia AS INTEGER.

FIND AC-CNFG WHERE ac-cnfg.Codcia = s-CodCia AND ac-cnfg.tpoCfg = "G" AND
                   ac-cnfg.CodCfg = "VTA" NO-ERROR.

IF NOT AVAILABLE AC-CNFG THEN DO :
   CREATE AC-CNFG.
   ASSIGN ac-cnfg.Codcia = s-CodCia 
          ac-cnfg.tpoCfg = "G" 
          ac-cnfg.CodCfg = "VTA"
          ac-cnfg.DesCfg = "CONFIGURACION DE CUENTAS DE VENTA".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES AC-CNFG

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define FIELDS-IN-QUERY-D-Dialog AC-CNFG.CodCfg AC-CNFG.DesCfg ~
AC-CNFG.CodCta[1] AC-CNFG.CodCta[2] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-D-Dialog AC-CNFG.CodCta[1] ~
&Scoped-define ENABLED-TABLES-IN-QUERY-D-Dialog AC-CNFG
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-D-Dialog AC-CNFG

&Scoped-define FIELD-PAIRS-IN-QUERY-D-Dialog~
 ~{&FP1}CodCta[1] ~{&FP2}CodCta[1] ~{&FP3}~
 ~{&FP1}CodCta[2] ~{&FP2}CodCta[2] ~{&FP3}
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH AC-CNFG SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog AC-CNFG
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog AC-CNFG


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS AC-CNFG.CodCta[1] AC-CNFG.CodCta[2] 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}CodCta[1] ~{&FP2}CodCta[1] ~{&FP3}~
 ~{&FP1}CodCta[2] ~{&FP2}CodCta[2] ~{&FP3}
&Scoped-define ENABLED-TABLES AC-CNFG
&Scoped-define FIRST-ENABLED-TABLE AC-CNFG
&Scoped-Define ENABLED-OBJECTS RECT-4 RECT-3 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-FIELDS AC-CNFG.CodCfg AC-CNFG.DesCfg ~
AC-CNFG.CodCta[1] AC-CNFG.CodCta[2] 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\pvsalir":U
     LABEL "Cancelar" 
     SIZE 5 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\pvgrabar":U
     LABEL "Aceptar" 
     SIZE 5 BY 1.15
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 6.43 BY 2.88.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 53.57 BY 1.73.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      AC-CNFG SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     AC-CNFG.CodCfg AT ROW 1.77 COL 2.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 6.43 BY .81
          FONT 0
     AC-CNFG.DesCfg AT ROW 1.77 COL 9.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 39.29 BY .81
          FONT 0
     AC-CNFG.CodCta[1] AT ROW 3.5 COL 12 COLON-ALIGNED
          LABEL "Cuenta I.G.V."
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     AC-CNFG.CodCta[2] AT ROW 3.5 COL 37 COLON-ALIGNED
          LABEL "Por Venta de Activo"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Btn_OK AT ROW 1.58 COL 57.43
     Btn_Cancel AT ROW 2.92 COL 57.43
     RECT-4 AT ROW 1.38 COL 2.43
     RECT-3 AT ROW 1.38 COL 56.72
     SPACE(1.98) SKIP(0.58)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Configuraci¢n deBaja".

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   Default                                                              */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN AC-CNFG.CodCfg IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN AC-CNFG.CodCta[1] IN FRAME D-Dialog
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN AC-CNFG.CodCta[2] IN FRAME D-Dialog
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN AC-CNFG.DesCfg IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "integral.AC-CNFG"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Configuraci¢n deBaja */
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
  AC-CNFG.CodCta[1] = AC-CNFG.CodCta[1]:SCREEN-VALUE.
  AC-CNFG.CodCta[2] = AC-CNFG.CodCta[2]:SCREEN-VALUE.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
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
  IF AVAILABLE AC-CNFG THEN 
    DISPLAY AC-CNFG.CodCfg AC-CNFG.DesCfg AC-CNFG.CodCta[1] AC-CNFG.CodCta[2] 
      WITH FRAME D-Dialog.
  ENABLE RECT-4 AC-CNFG.CodCta[1] AC-CNFG.CodCta[2] RECT-3 Btn_OK Btn_Cancel 
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
  
  AC-CNFG.CodCta[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = AC-CNFG.CodCta[1].
  AC-CNFG.CodCta[2]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = AC-CNFG.CodCta[2].

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "AC-CNFG"}

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


