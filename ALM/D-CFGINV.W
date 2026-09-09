&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-58 RECT-14 D-FchInv C-TipInv Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS D-FchInv C-TipInv 

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
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE D-FchInv AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha del Inventario" 
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .81 NO-UNDO.

DEFINE VARIABLE C-TipInv AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Total", "T",
"Parcial", "P"
     SIZE 20 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 8  NO-FILL 
     SIZE 24 BY 1.62.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 68 BY 1.69
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68.43 BY 7.65.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     D-FchInv AT ROW 2.77 COL 20.72 COLON-ALIGNED
     C-TipInv AT ROW 4.81 COL 22.72 NO-LABEL
     Btn_OK AT ROW 9 COL 44
     Btn_Cancel AT ROW 9 COL 56.29
     "Criterio de Seleccion" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1 COL 5.43
          FONT 6
     RECT-58 AT ROW 1.15 COL 1
     RECT-46 AT ROW 8.85 COL 1
     "Inventario" VIEW-AS TEXT
          SIZE 9.29 BY .69 AT ROW 4.08 COL 21.72
          BGCOLOR 1 FGCOLOR 15 FONT 6
     RECT-14 AT ROW 4.35 COL 21
     SPACE(24.43) SKIP(4.57)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Configuracion de Inventario".


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
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME D-Dialog
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Configuracion de Inventario */
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
  ASSIGN C-TipInv D-FchInv.
  RUN Configura.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Configura D-Dialog 
PROCEDURE Configura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE x-fchinv AS DATE NO-UNDO.

FIND LAST InvConfig WHERE InvConfig.CodCia = S-CODCIA 
                     AND  InvConfig.CodAlm = S-CODALM 
                    NO-LOCK NO-ERROR.
IF AVAIL InvConfig THEN x-fchinv = InvConfig.FchInv.

IF D-FchInv <= x-fchinv THEN DO:
    MESSAGE "Si Ud. desea configurar la Fecha de Inventario," SKIP
            "la nueva fecha debe de ser mayor a la ultima" SKIP
            "fecha del Inventario Fisico << " x-fchinv " >>"
            VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.

IF x-fchinv <> ? THEN DO:
    MESSAGE "La fecha de Inventario al ser cambiada." SKIP
            "Relizara un Cierre de Inventario Fisico." SKIP(2)
            "Esta seguro de relizar el cierre ?" SKIP
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            TITLE "" UPDATE Rpta AS LOGICAL.
    IF Rpta THEN DO:
        CREATE InvConfig.
        ASSIGN InvConfig.CodCia = S-CODCIA
               InvConfig.CodAlm = S-CODALM
               InvConfig.FchInv = D-FchInv
               InvConfig.TipInv = C-TipInv.
    END.
END.
ELSE DO:
    CREATE InvConfig.
    ASSIGN InvConfig.CodCia = S-CODCIA
           InvConfig.CodAlm = S-CODALM
           InvConfig.FchInv = D-FchInv
           InvConfig.TipInv = C-TipInv.
END.


/*     FIND InvConfig WHERE InvConfig.CodCia = S-CODCIA 
 *                      AND  InvConfig.CodAlm = S-CODALM 
 *                      AND  InvConfig.FchInv = D-FchInv
 *                     EXCLUSIVE-LOCK NO-ERROR.
 *      IF AVAILABLE InvConfig THEN DO:
 *         IF InvConfig.FchInv <> D-FchInv THEN DO:
 *            FIND FIRST InvConteo WHERE InvConteo.CodCia = S-CODCIA 
 *                                  AND  InvConteo.CodAlm = S-CODALM 
 *                                  AND  InvConteo.FchInv = D-FchInv
 *                                 NO-LOCK NO-ERROR.
 *            FIND FIRST InvRecont WHERE InvRecont.CodCia = S-CODCIA 
 *                                  AND  InvRecont.CodAlm = S-CODALM 
 *                                  AND  InvRecont.FchInv = D-FchInv
 *                                 NO-LOCK NO-ERROR.
 *            IF AVAILABLE InvConteo OR AVAILABLE InvRecont THEN DO:
 *               MESSAGE "La fecha de Inventario ha sido cambiada" SKIP(1)
 *                       "los datos anteriore seran guardados ?" VIEW-AS 
 *                       ALERT-BOX QUESTION BUTTONS YES-NO
 *                       TITLE "" UPDATE Rpta AS LOGICAL.
 *               IF Rpta THEN DO:
 * /*                 FOR EACH InvConteo WHERE InvConteo.CodCia = S-CODCIA 
 *  *                                      AND  InvConteo.CodAlm = S-CODALM :
 *  *                      DELETE InvConteo.
 *  *                  END.
 *  *                  FOR EACH InvRecont WHERE InvRecont.CodCia = S-CODCIA 
 *  *                                      AND  InvRecont.CodAlm = S-CODALM :
 *  *                      DELETE InvRecont.
 *  *                  END.*/
 *               END.
 *               ELSE RETURN.
 *            END.
 *         END.
 *         ELSE DO:
 *               MESSAGE "La fecha de Inventario ya existe"
 *                       VIEW-AS ALERT-BOX WARNING.
 *               RETURN.
 *         END.
 *      END.
 *      ELSE CREATE InvConfig.
 *      
 *      ASSIGN InvConfig.CodCia = S-CODCIA
 *             InvConfig.CodAlm = S-CODALM
 *             InvConfig.FchInv = D-FchInv
 *             InvConfig.TipInv = C-TipInv.
 * 
 *      FIND InvConfig WHERE InvConfig.CodCia = S-CODCIA 
 *                      AND  InvConfig.CodAlm = S-CODALM 
 *                      AND  InvConfig.FchInv = D-FchInv
 *                     NO-LOCK NO-ERROR.*/
            
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
  DISPLAY D-FchInv C-TipInv 
      WITH FRAME D-Dialog.
  ENABLE RECT-58 RECT-14 D-FchInv C-TipInv Btn_OK Btn_Cancel 
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

  ASSIGN FRAME {&FRAME-NAME}:TITLE = FRAME {&FRAME-NAME}:TITLE + " [ " + S-CODALM + " - " + S-DESALM + " ]".
  
  DO WITH FRAME {&FRAME-NAME}:
     FIND LAST InvConfig WHERE InvConfig.CodCia = S-CODCIA 
                          AND  InvConfig.CodAlm = S-CODALM 
                         NO-LOCK NO-ERROR.
     IF NOT AVAILABLE InvConfig THEN  
        ASSIGN C-TipInv = "T"
               D-FchInv = TODAY.
     ELSE 
        ASSIGN C-TipInv = InvConfig.TipInv
               D-FchInv = InvConfig.FchInv.
     DISPLAY C-TipInv D-FchInv.
  END.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
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


