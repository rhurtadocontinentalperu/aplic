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
DEFINE INPUT-OUTPUT PARAMETER S-Observa AS CHAR.
DEFINE INPUT        PARAMETER F-Fmapgo  AS CHAR.
DEFINE INPUT        PARAMETER F-CODIGV  AS LOGICAL.
DEFINE INPUT        PARAMETER F-DIAS    AS INTEGER.

/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-21 TOGGLE-2 TOGGLE-3 TOGGLE-4 TOGGLE-5 ~
TOGGLE-6 TOGGLE-7 TOGGLE-8 TOGGLE-9 TOGGLE-10 Btn_OK Btn_Cancel F-Plazo ~
F-Nombre 
&Scoped-Define DISPLAYED-OBJECTS TOGGLE-1 TOGGLE-2 TOGGLE-3 TOGGLE-4 ~
TOGGLE-5 TOGGLE-6 TOGGLE-7 TOGGLE-8 TOGGLE-9 TOGGLE-10 FILL-IN-1 FILL-IN-2 ~
FILL-IN-3 FILL-IN-4 FILL-IN-5 FILL-IN-6 FILL-IN-7 FILL-IN-8 FILL-IN-9 ~
FILL-IN-10 F-Plazo F-Nombre 

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
     SIZE 12 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-END-KEY 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.54
     BGCOLOR 8 .

DEFINE VARIABLE F-Nombre AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26.43 BY .69 NO-UNDO.

DEFINE VARIABLE F-Plazo AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 3 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 66 BY .5 NO-UNDO.

DEFINE VARIABLE FILL-IN-10 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 66 BY .5 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.29 BY .5 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 66 BY .5 NO-UNDO.

DEFINE VARIABLE FILL-IN-4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 66 BY .5 NO-UNDO.

DEFINE VARIABLE FILL-IN-5 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 66 BY .5 NO-UNDO.

DEFINE VARIABLE FILL-IN-6 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 66 BY .5 NO-UNDO.

DEFINE VARIABLE FILL-IN-7 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 66 BY .5 NO-UNDO.

DEFINE VARIABLE FILL-IN-8 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 66 BY .5 NO-UNDO.

DEFINE VARIABLE FILL-IN-9 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.29 BY .5 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 73.86 BY 7.88.

DEFINE VARIABLE TOGGLE-1 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 3 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-10 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 3 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-2 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 3 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-3 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 3 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-4 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 3 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-5 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 3 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-6 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 3 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-7 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 3 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-8 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 3 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-9 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 3 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     TOGGLE-1 AT ROW 2.42 COL 3.43
     TOGGLE-2 AT ROW 3.12 COL 3.43
     TOGGLE-3 AT ROW 3.85 COL 3.43
     TOGGLE-4 AT ROW 4.58 COL 3.43
     TOGGLE-5 AT ROW 5.31 COL 3.43
     TOGGLE-6 AT ROW 6.04 COL 3.43
     TOGGLE-7 AT ROW 6.77 COL 3.43
     TOGGLE-8 AT ROW 7.46 COL 3.43
     TOGGLE-9 AT ROW 8.23 COL 3.43
     TOGGLE-10 AT ROW 9.04 COL 3.43
     FILL-IN-1 AT ROW 2.5 COL 4.86 COLON-ALIGNED NO-LABEL
     FILL-IN-2 AT ROW 3.31 COL 4.86 COLON-ALIGNED NO-LABEL
     FILL-IN-3 AT ROW 4.04 COL 4.86 COLON-ALIGNED NO-LABEL
     FILL-IN-4 AT ROW 4.77 COL 4.86 COLON-ALIGNED NO-LABEL
     FILL-IN-5 AT ROW 5.5 COL 4.86 COLON-ALIGNED NO-LABEL
     FILL-IN-6 AT ROW 6.23 COL 4.86 COLON-ALIGNED NO-LABEL
     FILL-IN-7 AT ROW 6.96 COL 4.86 COLON-ALIGNED NO-LABEL
     FILL-IN-8 AT ROW 7.65 COL 4.86 COLON-ALIGNED NO-LABEL
     FILL-IN-9 AT ROW 8.42 COL 4.86 COLON-ALIGNED NO-LABEL
     FILL-IN-10 AT ROW 9.23 COL 4.86 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 10.31 COL 23.14
     Btn_Cancel AT ROW 10.31 COL 43.57
     F-Plazo AT ROW 3.19 COL 44.14 COLON-ALIGNED NO-LABEL
     F-Nombre AT ROW 8.38 COL 44.14 COLON-ALIGNED NO-LABEL
     "  CONDICIONES DE VENTA :" VIEW-AS TEXT
          SIZE 26.72 BY .5 AT ROW 1.42 COL 1.86
          FONT 1
     RECT-21 AT ROW 2.12 COL 1.43
     SPACE(0.56) SKIP(2.18)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Design Page: 1
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

/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-10 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-6 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-7 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-8 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-9 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-1 IN FRAME D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Cancelar */
DO:
   s-Observa = '***'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN
     TOGGLE-1 TOGGLE-2 TOGGLE-3 TOGGLE-4 TOGGLE-5 TOGGLE-6 TOGGLE-7 TOGGLE-8 TOGGLE-9 TOGGLE-10 F-Nombre F-Plazo.
  S-Observa = ''.
  IF TOGGLE-1 THEN S-Observa = S-Observa + '- ' + TRIM(FILL-IN-1:SCREEN-VALUE) + CHR(13).
  IF TOGGLE-2 THEN S-Observa = S-Observa + '- ' + TRIM(FILL-IN-2:SCREEN-VALUE) + " " + TRIM(STRING(F-Plazo)) + " DIAS" + CHR(13).
  IF TOGGLE-3 THEN S-Observa = S-Observa + '- ' + TRIM(FILL-IN-3:SCREEN-VALUE) + CHR(13).
  IF TOGGLE-4 THEN S-Observa = S-Observa + '- ' + TRIM(FILL-IN-4:SCREEN-VALUE) + CHR(13).
  IF TOGGLE-5 THEN S-Observa = S-Observa + '- ' + TRIM(FILL-IN-5:SCREEN-VALUE) + CHR(13).
  IF TOGGLE-6 THEN S-Observa = S-Observa + '- ' + TRIM(FILL-IN-6:SCREEN-VALUE) + CHR(13).
  IF TOGGLE-7 THEN S-Observa = S-Observa + '- ' + TRIM(FILL-IN-7:SCREEN-VALUE) + CHR(13).
  IF TOGGLE-8 THEN S-Observa = S-Observa + '- ' + TRIM(FILL-IN-8:SCREEN-VALUE) + CHR(13).
  S-Observa = S-Observa + '- FORMA DE PAGO: ' + F-Fmapgo + CHR(13).
  IF TOGGLE-9 THEN S-Observa = S-Observa + '- ' + TRIM(FILL-IN-9:SCREEN-VALUE) + TRIM(F-Nombre) + CHR(13).
  IF TOGGLE-10 THEN S-Observa = S-Observa + '- ' + TRIM(FILL-IN-10:SCREEN-VALUE) + CHR(13).
  RUN vta\d-cotiz2(INPUT-OUTPUT S-Observa).
  
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
  DISPLAY TOGGLE-1 TOGGLE-2 TOGGLE-3 TOGGLE-4 TOGGLE-5 TOGGLE-6 TOGGLE-7 
          TOGGLE-8 TOGGLE-9 TOGGLE-10 FILL-IN-1 FILL-IN-2 FILL-IN-3 FILL-IN-4 
          FILL-IN-5 FILL-IN-6 FILL-IN-7 FILL-IN-8 FILL-IN-9 FILL-IN-10 F-Plazo 
          F-Nombre 
      WITH FRAME D-Dialog.
  ENABLE RECT-21 TOGGLE-2 TOGGLE-3 TOGGLE-4 TOGGLE-5 TOGGLE-6 TOGGLE-7 TOGGLE-8 
         TOGGLE-9 TOGGLE-10 Btn_OK Btn_Cancel F-Plazo F-Nombre 
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
  DO WITH FRAME {&FRAME-NAME}:
     TOGGLE-1  = TRUE.
     TOGGLE-2  = TRUE.
     TOGGLE-3  = FALSE.
     TOGGLE-4  = TRUE.
     TOGGLE-5  = TRUE.
     TOGGLE-6  = FALSE.
     TOGGLE-7  = TRUE.
     TOGGLE-8  = TRUE.
     TOGGLE-9  = TRUE.
     TOGGLE-10 = TRUE.
     
     ASSIGN
        FILL-IN-1:SCREEN-VALUE = IF F-CODIGV THEN 
                                 ("LOS PRECIOS INCLUYEN IGV") 
                                 ELSE 
                                 ("LOS PRECIOS NO INCLUYEN IGV")
        FILL-IN-2:SCREEN-VALUE = "PLAZO DE ENTREGA  "
        FILL-IN-3:SCREEN-VALUE = " "
        FILL-IN-4:SCREEN-VALUE = "CONFIRMAR EL PEDIDO ANTES DE HACER EL DEPOSITO"
        FILL-IN-5:SCREEN-VALUE = "COTIZACION VALIDA POR " + STRING(F-DIAS,"9999") + " DIAS."
        FILL-IN-6:SCREEN-VALUE = " "
        FILL-IN-7:SCREEN-VALUE = "MATERIAL NO COTIZADO SEGUN SU REQUERIMIENTO, SIN STOCK EN ALMACEN."
        FILL-IN-8:SCREEN-VALUE = "CONFIRMAR SU PEDIDO CON ORDEN DE COMPRA."
        FILL-IN-9:SCREEN-VALUE = "CONSULTAR CON (SR/SRTA)."
        FILL-IN-10:SCREEN-VALUE = "GARANTIZAMOS NUESTROS PRODUCTOS CON CERTIFICADOS DE CALIDAD.".
     
     DISPLAY 
        TOGGLE-1 
        TOGGLE-2 
        TOGGLE-3 
        TOGGLE-4 
        TOGGLE-5 
        TOGGLE-6 
        TOGGLE-7 
        TOGGLE-8 
        TOGGLE-9 
        TOGGLE-10 .
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


