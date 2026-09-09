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
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.

DEFINE VAR F-STKACT AS DECIMAL NO-UNDO.
DEFINE VAR F-CANDES AS DECIMAL NO-UNDO.

DEFINE BUFFER MATE FOR Almmmate.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-12 RECT-11 DesdeC HastaC Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Proceso FILL-IN-CodAlm ~
FILL-IN-DesAlm DesdeC HastaC 

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

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodAlm AS CHARACTER FORMAT "X(3)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesAlm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29.43 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Proceso AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .92
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 42 BY 1.58.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 45.29 BY 5.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-Proceso AT ROW 5.15 COL 1 COLON-ALIGNED NO-LABEL
     FILL-IN-CodAlm AT ROW 1.27 COL 7.43 COLON-ALIGNED
     FILL-IN-DesAlm AT ROW 1.27 COL 13.29 COLON-ALIGNED NO-LABEL
     DesdeC AT ROW 3.62 COL 10.29 COLON-ALIGNED
     HastaC AT ROW 3.62 COL 31.72 COLON-ALIGNED
     Btn_OK AT ROW 1.81 COL 47.72
     Btn_Cancel AT ROW 4 COL 47.86
     RECT-12 AT ROW 1 COL 1
     "Articulos" VIEW-AS TEXT
          SIZE 11.43 BY .81 AT ROW 2.73 COL 3.57
          BGCOLOR 1 FGCOLOR 15 FONT 0
     RECT-11 AT ROW 3.19 COL 3
     SPACE(14.85) SKIP(3.03)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Regeneracion de Stock por Almacen".


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

/* SETTINGS FOR FILL-IN FILL-IN-CodAlm IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DesAlm IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Proceso IN FRAME D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Regeneracion de Stock por Almacen */
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
  ASSIGN DesdeC HastaC.
  IF HastaC = "" THEN HastaC = "999999".
  RUN Calculo-por-Almacen.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC D-Dialog
ON LEAVE OF DesdeC IN FRAME D-Dialog /* Desde */
DO:
  IF INPUT DesdeC = "" THEN RETURN.
  DesdeC:SCREEN-VALUE = STRING(INTEGER(DesdeC:SCREEN-VALUE),"999999").
  FIND Almmmatg WHERE 
       Almmmatg.CodCia = S-CODCIA AND 
       Almmmatg.CodMat = DesdeC:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME HastaC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaC D-Dialog
ON LEAVE OF HastaC IN FRAME D-Dialog /* Hasta */
DO:
  IF INPUT HastaC = "" THEN RETURN.
  HastaC:SCREEN-VALUE = STRING(INTEGER(HastaC:SCREEN-VALUE),"999999").
  FIND Almmmatg WHERE 
       Almmmatg.CodCia = S-CODCIA AND 
       Almmmatg.CodMat = HastaC:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calculo-por-Almacen D-Dialog 
PROCEDURE Calculo-por-Almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH Almmmate NO-LOCK WHERE Almmmate.CodCia = S-CODCIA
                           AND  Almmmate.CodAlm = S-CODALM
                           AND  Almmmate.codmat >= DesdeC
                           AND  Almmmate.codmat <= HastaC:
    DISPLAY "Articulo " + Almmmate.CodMat @ FILL-IN-Proceso WITH FRAME {&FRAME-NAME}.
    F-STKACT = 0.
    FOR EACH Almdmov NO-LOCK WHERE Almdmov.CodCia = Almmmate.CodCia 
                              AND  Almdmov.CodAlm = Almmmate.CodAlm 
                              AND  Almdmov.CodMat = Almmmate.CodMat
                             USE-INDEX Almd03:
        DISPLAY "Articulo " + Almmmate.CodMat + " Movimiento " + 
                 Almdmov.TipMov + STRING(Almdmov.CodMov,"99") + " - " +
                 STRING(Almdmov.NroSer,"999") + "-" + STRING(Almdmov.NroDoc,"9999999")
                 @ FILL-IN-Proceso WITH FRAME {&FRAME-NAME}.
        F-CANDES = Almdmov.CanDes.
        /* CANTIDAD DESPACHADA EN UNIDADES DE STOCK */
        IF Almdmov.Factor > 0 THEN  F-CANDES = Almdmov.CanDes * Almdmov.Factor.
        IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0 THEN 
             F-STKACT = F-STKACT + F-CANDES.
        ELSE F-STKACT = F-STKACT - F-CANDES.
    END.  /* FIN DEL FOR EACH DE ALMDMOV */
    /* ACTUALIZAMOS MATERIALES POR ALMACEN */
    FIND MATE WHERE ROWID(MATE) = ROWID(Almmmate) EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE MATE THEN /*MATE.StkRep = F-STKACT.*/
                           MATE.StkAct = F-STKACT.
    RELEASE MATE.
END.

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
  DISPLAY FILL-IN-Proceso FILL-IN-CodAlm FILL-IN-DesAlm DesdeC HastaC 
      WITH FRAME D-Dialog.
  ENABLE RECT-12 RECT-11 DesdeC HastaC Btn_OK Btn_Cancel 
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
  
  DISPLAY S-CODALM @ FILL-IN-CodAlm  
          S-DESALM @ FILL-IN-DesAlm WITH FRAME {&FRAME-NAME}.


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


