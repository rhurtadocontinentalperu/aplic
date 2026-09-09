&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
DEF INPUT-OUTPUT PARAMETER x-HorLle AS CHAR.
DEF INPUT-OUTPUT PARAMETER x-HorPar AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER pPtosDestino AS INT.
DEF OUTPUT PARAMETER x-Ok AS LOG.

DEFINE VAR lHora1 AS INT.
DEFINE VAR lMinuto1 AS INT.
DEFINE VAR lHora2 AS INT.
DEFINE VAR lMinuto2 AS INT.

lHora1 = INT(SUBSTRING(X-HorLle,1,2)).
lMinuto1 = INT(SUBSTRING(X-HorLle,3,2)).

lHora2 = INT(SUBSTRING(X-HorPar,1,2)).
lMinuto2 = INT(SUBSTRING(X-HorPar,3,2)).


/* Local Variable Definitions ---                                       */

x-Ok = NO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS txtHora1 txtMinuto1 txtHora2 txtMinuto2 ~
TOGGLE-ptos-destino Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS txtHora1 txtMinuto1 txtHora2 txtMinuto2 ~
TOGGLE-ptos-destino 

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

DEFINE VARIABLE txtHora1 AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "HH" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .81.

DEFINE VARIABLE txtHora2 AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "HH" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .81.

DEFINE VARIABLE txtMinuto1 AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "MM" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .81.

DEFINE VARIABLE txtMinuto2 AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "MM" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .81.

DEFINE VARIABLE TOGGLE-ptos-destino AS LOGICAL INITIAL yes 
     LABEL "Toggle 1" 
     VIEW-AS TOGGLE-BOX
     SIZE 55 BY .77
     FGCOLOR 9 FONT 10 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     txtHora1 AT ROW 1.54 COL 22 COLON-ALIGNED WIDGET-ID 6
     txtMinuto1 AT ROW 1.54 COL 29.14 COLON-ALIGNED WIDGET-ID 8
     txtHora2 AT ROW 2.42 COL 22 COLON-ALIGNED WIDGET-ID 10
     txtMinuto2 AT ROW 2.46 COL 29.14 COLON-ALIGNED WIDGET-ID 12
     TOGGLE-ptos-destino AT ROW 3.69 COL 4 WIDGET-ID 14
     Btn_OK AT ROW 5.04 COL 32
     Btn_Cancel AT ROW 5.04 COL 47
     "Hora de Partida del Cliente:" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 2.58 COL 2 WIDGET-ID 4
     "Hora de Llegada al Cliente :" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 1.65 COL 2 WIDGET-ID 2
     "Formato 24 horas HH:MM" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 1.77 COL 36.43
     "Formato 24 horas HH:MM" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 2.73 COL 36.14
     SPACE(5.42) SKIP(3.26)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "TIEMPO DE ESTANCIA EN EL PUNTO DE ENTREGA"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


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
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* TIEMPO DE ESTANCIA EN EL PUNTO DE ENTREGA */
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
  /* 09Jul2013 - Ic
  ASSIGN
    FILL-IN-HorLle
    FILL-IN-HorPar.
  IF FILL-IN-HorLle = '0000' THEN FILL-IN-HorLle = ''.
  IF FILL-IN-HorPar = '0000' THEN FILL-IN-HorPar = ''.
  ASSIGN
    x-HorLle = FILL-IN-HorLle
    x-HorPar = FILL-IN-HorPar
    x-Ok = YES.
   */

    DEFINE VAR lLlegada AS INT.
    DEFINE VAR lPartida AS INT.

    ASSIGN txtHora1 txtMinuto1
            txtHora2 txtMinuto2
            toggle-ptos-destino.
    IF txtHora1 < 0 OR txtHora1 > 23  THEN DO:
        /* Error */
        MESSAGE 'Hora (HH) de Llegada esta ERRADA'
                VIEW-AS ALERT-BOX WARNING.     
        APPLY 'ENTRY':U TO txtHora1.
        RETURN NO-APPLY.
    END.
    IF txtMinuto1 < 0 OR txtMinuto1 > 59  THEN DO:
        /* Error */
        MESSAGE 'Minuto (MM) de Llegada esta ERRADA'
                VIEW-AS ALERT-BOX WARNING.       
        APPLY 'ENTRY':U TO txtMinuto1.
        RETURN NO-APPLY.
    END.
    IF txtHora2 < 0 OR txtHora2 > 23  THEN DO:
        /* Error */
        MESSAGE 'Hora (HH) de Partida esta ERRADA'
                VIEW-AS ALERT-BOX WARNING.       
        APPLY 'ENTRY':U TO txtHora2.
        RETURN NO-APPLY.
    END.
    IF txtMinuto2 < 0 OR txtMinuto2 > 59  THEN DO:
        /* Error */
        MESSAGE 'Minuto (MM) de Partida esta ERRADA'
                VIEW-AS ALERT-BOX WARNING.       
        APPLY 'ENTRY':U TO txtMinuto2.
        RETURN NO-APPLY.
    END.

    lLlegada = INT(STRING(txtHora1,"99") + STRING(txtMinuto1,"99")).
    lPartida = INT(STRING(txtHora2,"99") + STRING(txtMinuto2,"99")).

    IF lLlegada > lPartida THEN DO:
        MESSAGE 'La Hora/Minuto de Llegada debe ser menor a la Hora/Minuto de Partida...'
                VIEW-AS ALERT-BOX WARNING.       
        APPLY 'ENTRY':U TO txtHora1.
        RETURN NO-APPLY.
    END.

    ASSIGN
        x-HorLle = STRING(txtHora1,"99") + STRING(txtMinuto1,"99")
        x-HorPar = STRING(txtHora2,"99") + STRING(txtMinuto2,"99").

    IF pPtosDestino > 1 THEN DO:
       IF toggle-ptos-destino = YES THEN DO:
           pPtosDestino = 1.
       END.
       ELSE DO:
            pPtosDestino = 0.
       END.          
    END.

    

    ASSIGN 
        X-Ok = YES.
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
  DISPLAY txtHora1 txtMinuto1 txtHora2 txtMinuto2 TOGGLE-ptos-destino 
      WITH FRAME D-Dialog.
  ENABLE txtHora1 txtMinuto1 txtHora2 txtMinuto2 TOGGLE-ptos-destino Btn_OK 
         Btn_Cancel 
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
  /*
  FILL-IN-HorLle = x-HorLle.
  FILL-IN-HorPar = x-HorPar.
  */
  txtHora1      = lHora1.
  txtMinuto1    = lMinuto1.
  txtHora2      = lHora2.
  txtMinuto2    = lMinuto2.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  toggle-ptos-destino:LABEL IN FRAME {&FRAME-NAME} = "" .
  toggle-ptos-destino:VISIBLE = NO.

  IF pPtosDestino > 1 THEN DO:
    toggle-ptos-destino:LABEL IN FRAME {&FRAME-NAME} = "Actualizar los " + String(pPtosDestino) + " Guias de Remision" .
    toggle-ptos-destino:VISIBLE = YES.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
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

