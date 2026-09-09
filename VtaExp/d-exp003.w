&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
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

DEF SHARED VAR input-var-1 AS CHAR.
DEF SHARED VAR input-var-2 AS CHAR.
DEF SHARED VAR input-var-3 AS CHAR.
DEF SHARED VAR output-var-1 AS ROWID.
DEF SHARED VAR output-var-2 AS CHAR.
DEF SHARED VAR output-var-3 AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES VtaDActi gn-clie

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 VtaDActi.CodCli gn-clie.NomCli   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3   
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-3
&Scoped-define SELF-NAME BROWSE-3
&Scoped-define OPEN-QUERY-BROWSE-3 CASE COMBO-BOX-1: WHEN 'Todos' THEN OPEN QUERY {&SELF-NAME} FOR EACH VtaDActi       WHERE VtaDActi.CodCia = INTEGER(input-var-1)  AND VtaDActi.CodActi = input-var-2 NO-LOCK, ~
             EACH gn-clie WHERE gn-clie.CodCli = VtaDActi.CodCli   AND gn-clie.CodCia = INTEGER(input-var-3) NO-LOCK. WHEN 'Inicien' THEN OPEN QUERY {&SELF-NAME} FOR EACH VtaDActi       WHERE VtaDActi.CodCia = INTEGER(input-var-1)  AND VtaDActi.CodActi = input-var-2 NO-LOCK, ~
             EACH gn-clie WHERE gn-clie.CodCli = VtaDActi.CodCli   AND gn-clie.CodCia = INTEGER(input-var-3)   AND gn-clie.NomCli BEGINS x-NomCli NO-LOCK. WHEN 'Contengan' THEN OPEN QUERY {&SELF-NAME} FOR EACH VtaDActi       WHERE VtaDActi.CodCia = INTEGER(input-var-1)  AND VtaDActi.CodActi = input-var-2 NO-LOCK, ~
             EACH gn-clie WHERE gn-clie.CodCli = VtaDActi.CodCli   AND gn-clie.CodCia = INTEGER(input-var-3)   AND INDEX(gn-clie.NomCli, ~
       x-NomCli) > 0  NO-LOCK. END CASE.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 VtaDActi gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 VtaDActi


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-1 BROWSE-3 Btn_OK Btn_Cancel ~
x-NomCli 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-1 x-NomCli 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Aceptar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","Inicien","Contengan" 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE x-NomCli AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 58 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      VtaDActi, 
      gn-clie SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 D-Dialog _FREEFORM
  QUERY BROWSE-3 NO-LOCK DISPLAY
      VtaDActi.CodCli COLUMN-LABEL "<<<Cliente>>>"
      gn-clie.NomCli FORMAT "x(60)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 76 BY 12.12
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     COMBO-BOX-1 AT ROW 1.38 COL 2 COLON-ALIGNED NO-LABEL
     BROWSE-3 AT ROW 2.35 COL 3
     Btn_OK AT ROW 15.04 COL 4
     Btn_Cancel AT ROW 15.04 COL 17
     x-NomCli AT ROW 1.38 COL 19 COLON-ALIGNED NO-LABEL
     SPACE(9.71) SKIP(14.53)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "<insert SmartDialog title>"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


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
                                                                        */
/* BROWSE-TAB BROWSE-3 COMBO-BOX-1 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _START_FREEFORM
CASE COMBO-BOX-1:
WHEN 'Todos'
THEN OPEN QUERY {&SELF-NAME} FOR EACH VtaDActi
      WHERE VtaDActi.CodCia = INTEGER(input-var-1)
 AND VtaDActi.CodActi = input-var-2 NO-LOCK,
      EACH gn-clie WHERE gn-clie.CodCli = VtaDActi.CodCli
  AND gn-clie.CodCia = INTEGER(input-var-3) NO-LOCK.
WHEN 'Inicien'
THEN OPEN QUERY {&SELF-NAME} FOR EACH VtaDActi
      WHERE VtaDActi.CodCia = INTEGER(input-var-1)
 AND VtaDActi.CodActi = input-var-2 NO-LOCK,
      EACH gn-clie WHERE gn-clie.CodCli = VtaDActi.CodCli
  AND gn-clie.CodCia = INTEGER(input-var-3)
  AND gn-clie.NomCli BEGINS x-NomCli NO-LOCK.
WHEN 'Contengan'
THEN OPEN QUERY {&SELF-NAME} FOR EACH VtaDActi
      WHERE VtaDActi.CodCia = INTEGER(input-var-1)
 AND VtaDActi.CodActi = input-var-2 NO-LOCK,
      EACH gn-clie WHERE gn-clie.CodCli = VtaDActi.CodCli
  AND gn-clie.CodCia = INTEGER(input-var-3)
  AND INDEX(gn-clie.NomCli, x-NomCli) > 0  NO-LOCK.
END CASE.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Where[1]         = "INTEGRAL.VtaDActi.CodCia = INTEGER(input-var-1)
 AND INTEGRAL.VtaDActi.CodActi = input-var-2"
     _JoinCode[2]      = "INTEGRAL.gn-clie.CodCli = INTEGRAL.VtaDActi.CodCli
  AND INTEGRAL.gn-clie.CodCia = INTEGER(input-var-3)"
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* <insert SmartDialog title> */
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
  ASSIGN
    output-var-1 = ROWID(vtadacti)
    output-var-2 = vtadacti.codcli
    output-var-3 = gn-clie.nomcli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-1 D-Dialog
ON VALUE-CHANGED OF COMBO-BOX-1 IN FRAME D-Dialog
DO:
  ASSIGN 
    {&SELF-NAME}
    x-NomCli.
  CASE SELF:SCREEN-VALUE:
    WHEN 'Todos' THEN ASSIGN x-NomCli = ''.
  END CASE.
  DISPLAY x-NomCli WITH FRAME {&FRAME-NAME}.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
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
  DISPLAY COMBO-BOX-1 x-NomCli 
      WITH FRAME D-Dialog.
  ENABLE COMBO-BOX-1 BROWSE-3 Btn_OK Btn_Cancel x-NomCli 
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
  ASSIGN
    output-var-1 = ?
    output-var-2 = ''
    output-var-3 = ''.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "VtaDActi"}
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


