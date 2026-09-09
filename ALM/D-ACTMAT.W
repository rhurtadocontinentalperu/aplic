&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
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
DEFINE INPUT PARAMETER R-MATG AS ROWID.
/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE S-CODALM AS CHAR.

FIND Almmmatg WHERE ROWID(Almmmatg) = R-MATG NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 FILL-IN_StkMax FILL-IN_StkMin ~
FILL-IN_AlmDes FILL-IN_CodUbi Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_codmat FILL-IN_desmat ~
FILL-IN_StkAct FILL-IN_StkMax FILL-IN_StkMin FILL-IN_AlmDes FILL-IN_CodUbi ~
FILL-IN_UndStk FILL-IN_CanEmp 

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

DEFINE VARIABLE FILL-IN_AlmDes AS CHARACTER FORMAT "X(70)" 
     LABEL "Almacen  Despacho" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .81.

DEFINE VARIABLE FILL-IN_CanEmp AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Empaque" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .81
     BGCOLOR 15 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_codmat AS CHARACTER FORMAT "X(6)" 
     LABEL "Codigo Articulo" 
     VIEW-AS FILL-IN 
     SIZE 8.72 BY .81
     BGCOLOR 15 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_CodUbi AS CHARACTER FORMAT "x(6)" 
     LABEL "Ubicaci¢n" 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .81.

DEFINE VARIABLE FILL-IN_desmat AS CHARACTER FORMAT "x(45)" 
     LABEL "descripcion" 
     VIEW-AS FILL-IN 
     SIZE 42 BY .81
     BGCOLOR 15 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_StkAct AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Stock actual" 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .81
     BGCOLOR 15 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_StkMax AS DECIMAL FORMAT "->,>>>,>>9.99" INITIAL 0 
     LABEL "Stock maximo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81.

DEFINE VARIABLE FILL-IN_StkMin AS DECIMAL FORMAT "->,>>>,>>9.99" INITIAL 0 
     LABEL "Stock minimo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81.

DEFINE VARIABLE FILL-IN_UndStk AS CHARACTER FORMAT "X(4)" 
     VIEW-AS FILL-IN 
     SIZE 5.29 BY .81
     BGCOLOR 15 FGCOLOR 0 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 4 GRAPHIC-EDGE  NO-FILL 
     SIZE 59.43 BY 6.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN_codmat AT ROW 1.38 COL 15 COLON-ALIGNED
     FILL-IN_desmat AT ROW 2.19 COL 15 COLON-ALIGNED
     FILL-IN_StkAct AT ROW 3 COL 15 COLON-ALIGNED
     FILL-IN_StkMax AT ROW 3.81 COL 15 COLON-ALIGNED
     FILL-IN_StkMin AT ROW 4.62 COL 15 COLON-ALIGNED
     FILL-IN_AlmDes AT ROW 5.42 COL 2.43
     FILL-IN_CodUbi AT ROW 6.23 COL 15 COLON-ALIGNED
     FILL-IN_UndStk AT ROW 3 COL 28 COLON-ALIGNED NO-LABEL
     FILL-IN_CanEmp AT ROW 3 COL 44.43 COLON-ALIGNED
     Btn_OK AT ROW 1.96 COL 61
     Btn_Cancel AT ROW 3.96 COL 61
     RECT-2 AT ROW 1 COL 1
     SPACE(12.99) SKIP(0.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Actualizando".

 

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

/* SETTINGS FOR FILL-IN FILL-IN_AlmDes IN FRAME D-Dialog
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN_CanEmp IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_codmat IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_desmat IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_StkAct IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_UndStk IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK KEEP-EMPTY"
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Actualizando */
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
  ASSIGN FILL-IN_AlmDes FILL-IN_codmat FILL-IN_CodUbi FILL-IN_desmat FILL-IN_StkMax FILL-IN_StkMin.
  FIND Almmmate WHERE 
       Almmmate.CodCia = Almmmatg.CodCia AND
       Almmmate.CodAlm = S-CODALM        AND
       Almmmate.CodMat = Almmmatg.CodMat EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE Almmmate THEN DO WITH FRAME {&FRAME-NAME}:
     Almmmate.CodUbi = FILL-IN_CodUbi.
     Almmmate.almdes = FILL-IN_AlmDes.
     Almmmate.stkmax = FILL-IN_StkMax.
     Almmmate.stkmin = FILL-IN_StkMin.
  END.
  RELEASE Almmmate.
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
  DISPLAY FILL-IN_codmat FILL-IN_desmat FILL-IN_StkAct FILL-IN_StkMax 
          FILL-IN_StkMin FILL-IN_AlmDes FILL-IN_CodUbi FILL-IN_UndStk 
          FILL-IN_CanEmp 
      WITH FRAME D-Dialog.
  ENABLE RECT-2 FILL-IN_StkMax FILL-IN_StkMin FILL-IN_AlmDes FILL-IN_CodUbi 
         Btn_OK Btn_Cancel 
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
  
  FIND Almmmate WHERE 
       Almmmate.CodCia = Almmmatg.CodCia AND
       Almmmate.CodAlm = S-CODALM AND
       Almmmate.CodMat = Almmmatg.CodMat NO-LOCK NO-ERROR.
  IF AVAILABLE Almmmate THEN DO WITH FRAME {&FRAME-NAME}:
     FILL-IN_codmat = Almmmate.codmat.
     FILL-IN_desmat = Almmmate.desmat.
     FILL-IN_CodUbi = Almmmate.CodUbi.
     FILL-IN_AlmDes = Almmmate.almdes.
     FILL-IN_StkAct = Almmmate.stkact.
     FILL-IN_StkMax = Almmmate.stkmax.
     FILL-IN_StkMin = Almmmate.stkmin.
     FILL-IN_CanEmp = Almmmatg.CanEmp.
     FILL-IN_UndStk = Almmmatg.UndStk.
     DISPLAY FILL-IN_AlmDes FILL-IN_codmat FILL-IN_CodUbi FILL-IN_desmat 
             FILL-IN_StkAct FILL-IN_StkMax FILL-IN_StkMin FILL-IN_CanEmp FILL-IN_UndStk.
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


