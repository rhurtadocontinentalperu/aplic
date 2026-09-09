&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog

/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE T-DOSER LIKE INTEGRAL.lg-doser.


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

DEF INPUT PARAMETER s-Rowid AS ROWID.

FIND T-DOSER WHERE ROWID(T-DOSER) = s-Rowid.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-DOSER

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define FIELDS-IN-QUERY-D-Dialog T-DOSER.glosa[1] T-DOSER.glosa[2] ~
T-DOSER.glosa[3] T-DOSER.glosa[4] T-DOSER.glosa[5] T-DOSER.glosa[6] ~
T-DOSER.glosa[7] T-DOSER.glosa[8] T-DOSER.glosa[9] T-DOSER.glosa[10] ~
T-DOSER.desser 
&Scoped-define ENABLED-FIELDS-IN-QUERY-D-Dialog T-DOSER.glosa[1] ~
T-DOSER.glosa[2] T-DOSER.glosa[3] T-DOSER.glosa[4] T-DOSER.glosa[5] ~
T-DOSER.glosa[6] T-DOSER.glosa[7] T-DOSER.glosa[8] T-DOSER.glosa[9] ~
T-DOSER.glosa[10] 
&Scoped-define ENABLED-TABLES-IN-QUERY-D-Dialog T-DOSER
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-D-Dialog T-DOSER

&Scoped-define FIELD-PAIRS-IN-QUERY-D-Dialog~
 ~{&FP1}glosa[1] ~{&FP2}glosa[1] ~{&FP3}~
 ~{&FP1}glosa[2] ~{&FP2}glosa[2] ~{&FP3}~
 ~{&FP1}glosa[3] ~{&FP2}glosa[3] ~{&FP3}~
 ~{&FP1}glosa[4] ~{&FP2}glosa[4] ~{&FP3}~
 ~{&FP1}glosa[5] ~{&FP2}glosa[5] ~{&FP3}~
 ~{&FP1}glosa[6] ~{&FP2}glosa[6] ~{&FP3}~
 ~{&FP1}glosa[7] ~{&FP2}glosa[7] ~{&FP3}~
 ~{&FP1}glosa[8] ~{&FP2}glosa[8] ~{&FP3}~
 ~{&FP1}glosa[9] ~{&FP2}glosa[9] ~{&FP3}~
 ~{&FP1}glosa[10] ~{&FP2}glosa[10] ~{&FP3}
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH T-DOSER SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog T-DOSER
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog T-DOSER


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS T-DOSER.glosa[1] T-DOSER.glosa[2] ~
T-DOSER.glosa[3] T-DOSER.glosa[4] T-DOSER.glosa[5] T-DOSER.glosa[6] ~
T-DOSER.glosa[7] T-DOSER.glosa[8] T-DOSER.glosa[9] T-DOSER.glosa[10] 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}glosa[1] ~{&FP2}glosa[1] ~{&FP3}~
 ~{&FP1}glosa[2] ~{&FP2}glosa[2] ~{&FP3}~
 ~{&FP1}glosa[3] ~{&FP2}glosa[3] ~{&FP3}~
 ~{&FP1}glosa[4] ~{&FP2}glosa[4] ~{&FP3}~
 ~{&FP1}glosa[5] ~{&FP2}glosa[5] ~{&FP3}~
 ~{&FP1}glosa[6] ~{&FP2}glosa[6] ~{&FP3}~
 ~{&FP1}glosa[7] ~{&FP2}glosa[7] ~{&FP3}~
 ~{&FP1}glosa[8] ~{&FP2}glosa[8] ~{&FP3}~
 ~{&FP1}glosa[9] ~{&FP2}glosa[9] ~{&FP3}~
 ~{&FP1}glosa[10] ~{&FP2}glosa[10] ~{&FP3}
&Scoped-define ENABLED-TABLES T-DOSER
&Scoped-define FIRST-ENABLED-TABLE T-DOSER
&Scoped-Define ENABLED-OBJECTS RECT-4 RECT-5 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-FIELDS T-DOSER.glosa[1] T-DOSER.glosa[2] ~
T-DOSER.glosa[3] T-DOSER.glosa[4] T-DOSER.glosa[5] T-DOSER.glosa[6] ~
T-DOSER.glosa[7] T-DOSER.glosa[8] T-DOSER.glosa[9] T-DOSER.glosa[10] ~
T-DOSER.desser 

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
     SIZE 14 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 14 BY 1.54
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 79 BY 1.54.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 79 BY 8.46.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      T-DOSER SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     T-DOSER.glosa[1] AT ROW 3.5 COL 5 COLON-ALIGNED
          LABEL "1."
          VIEW-AS FILL-IN 
          SIZE 72 BY .81
     T-DOSER.glosa[2] AT ROW 4.27 COL 5 COLON-ALIGNED
          LABEL "2."
          VIEW-AS FILL-IN 
          SIZE 72 BY .81
     T-DOSER.glosa[3] AT ROW 5.04 COL 5 COLON-ALIGNED
          LABEL "3." FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 72 BY .81
     T-DOSER.glosa[4] AT ROW 5.81 COL 5 COLON-ALIGNED
          LABEL "4." FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 72 BY .81
     T-DOSER.glosa[5] AT ROW 6.58 COL 5 COLON-ALIGNED
          LABEL "5." FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 72 BY .81
     T-DOSER.glosa[6] AT ROW 7.35 COL 5 COLON-ALIGNED
          LABEL "6." FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 72 BY .81
     T-DOSER.glosa[7] AT ROW 8.12 COL 5 COLON-ALIGNED
          LABEL "7." FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 72 BY .81
     T-DOSER.glosa[8] AT ROW 8.88 COL 5 COLON-ALIGNED
          LABEL "8." FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 72 BY .81
     T-DOSER.glosa[9] AT ROW 9.65 COL 5 COLON-ALIGNED
          LABEL "9." FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 72 BY .81
     T-DOSER.glosa[10] AT ROW 10.42 COL 5 COLON-ALIGNED
          LABEL "10." FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 72 BY .81
     T-DOSER.desser AT ROW 1.77 COL 9 COLON-ALIGNED
          LABEL "Servicio"
          VIEW-AS FILL-IN 
          SIZE 68 BY .81
          BGCOLOR 15 FGCOLOR 1 
     Btn_OK AT ROW 3.69 COL 84
     Btn_Cancel AT ROW 5.42 COL 84
     RECT-4 AT ROW 1.38 COL 3
     RECT-5 AT ROW 3.12 COL 3
     SPACE(19.71) SKIP(0.91)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "DETALLE DEL SERVICIO".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-DOSER T "SHARED" ? INTEGRAL lg-doser
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
                                                                        */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN T-DOSER.desser IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN T-DOSER.glosa[10] IN FRAME D-Dialog
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN T-DOSER.glosa[1] IN FRAME D-Dialog
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN T-DOSER.glosa[2] IN FRAME D-Dialog
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN T-DOSER.glosa[3] IN FRAME D-Dialog
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN T-DOSER.glosa[4] IN FRAME D-Dialog
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN T-DOSER.glosa[5] IN FRAME D-Dialog
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN T-DOSER.glosa[6] IN FRAME D-Dialog
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN T-DOSER.glosa[7] IN FRAME D-Dialog
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN T-DOSER.glosa[8] IN FRAME D-Dialog
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN T-DOSER.glosa[9] IN FRAME D-Dialog
   EXP-LABEL EXP-FORMAT                                                 */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "Temp-Tables.T-DOSER"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* DETALLE DEL SERVICIO */
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
    T-DOSER.Glosa.
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
  IF AVAILABLE T-DOSER THEN 
    DISPLAY T-DOSER.glosa[1] T-DOSER.glosa[2] T-DOSER.glosa[3] T-DOSER.glosa[4] 
          T-DOSER.glosa[5] T-DOSER.glosa[6] T-DOSER.glosa[7] T-DOSER.glosa[8] 
          T-DOSER.glosa[9] T-DOSER.glosa[10] T-DOSER.desser 
      WITH FRAME D-Dialog.
  ENABLE RECT-4 RECT-5 T-DOSER.glosa[1] T-DOSER.glosa[2] T-DOSER.glosa[3] 
         T-DOSER.glosa[4] T-DOSER.glosa[5] T-DOSER.glosa[6] T-DOSER.glosa[7] 
         T-DOSER.glosa[8] T-DOSER.glosa[9] T-DOSER.glosa[10] Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
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
        WHEN "" THEN .
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

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN ASSIGN input-var-1 = "".
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
  {src/adm/template/snd-list.i "T-DOSER"}

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


