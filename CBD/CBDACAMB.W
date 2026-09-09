&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
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

DEFINE        VARIABLE cb-codcia AS INTEGER NO-UNDO INITIAL 0.
DEFINE        VARIABLE PTO        AS LOGICAL NO-UNDO .
DEFINE {&NEW} SHARED VARIABLE s-NroMes      AS INTEGER INITIAL 1.
DEFINE {&NEW} SHARED VARIABLE s-periodo      AS INTEGER INITIAL 1996.
DEFINE {&NEW} SHARED VARIABLE s-codcia   AS INTEGER INITIAL 1.
DEFINE VARIABLE F-CODOPE AS CHAR INIT "060".
DEFINE VAR X-CAMBIO LIKE cb-cmov.TPOCMB.
DEFINE VAR X-D1  AS DECIMAL.
DEFINE VAR X-D2  AS DECIMAL.
DEFINE VAR X-H1  AS DECIMAL.
DEFINE VAR X-H2  AS DECIMAL.


FIND Empresas WHERE Empresas.CodCia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia.
PTO = SESSION:SET-WAIT-STATE("").

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 Btn_OK F-MES Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-MES 

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

DEFINE VARIABLE F-MES AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40 BY 3.77.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     Btn_OK AT ROW 1.54 COL 27
     F-MES AT ROW 2.88 COL 14 COLON-ALIGNED
     Btn_Cancel AT ROW 2.88 COL 27
     RECT-2 AT ROW 1 COL 1
     SPACE(0.00) SKIP(0.10)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Correcci¢n Tipo Cambio"
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Correcci¢n Tipo Cambio */
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
   DEF VAR X-NOM AS CHAR FORMAT "X(15)".
   F-CodOpe = "060".
   ASSIGN f-mes.
   FIND cb-oper WHERE cb-oper.CODCIA = cb-codcia AND
                          cb-oper.CODOPE = F-CodOpe  
                          NO-LOCK NO-ERROR.
   IF NOT AVAILABLE cb-oper THEN DO:
      MESSAGE "OPERACION NO REGISTRADA" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.     
   IF cb-oper.TPOCMB <> 1 AND cb-oper.TPOCMB <> 2 THEN DO:
      MESSAGE "OPERACION NO VALIDA " SKIP
              "CAMBIO DEBER SER COMPRA O VENTA"
               VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.     
   IF cb-oper.TPOCMB = 1 
        THEN X-NOM = "COMPRA".
        ELSE X-NOM = "VENTA".
                             
   MESSAGE "OPERACION: " cb-oper.NOMOPE SKIP(2)
           "CAMBIO   : " X-NOM              SKIP(2)
           "MES      : " F-MES
           VIEW-AS ALERT-BOX INFORMA
           BUTTON YES-NO UPDATE RPTA AS LOGICAL.
   IF NOT RPTA THEN APPLY "CHOOSE" TO BTN_CANCEL.
   PTO = SESSION:SET-WAIT-STATE("GENERAL").                        
   FOR EACH cb-cmov WHERE cb-cmov.CODCIA  = s-codcia AND
                          cb-cmov.PERIODO = s-periodo    AND
                          cb-cmov.NROMES  = F-MES    AND
                          cb-cmov.CODOPE  = F-CODOPE :   
       FIND gn-tcmb WHERE gn-tcmb.fecha   = cb-cmov.FCHAST 
            NO-LOCK NO-ERROR.
       IF AVAIL (gn-tcmb)  THEN DO:
           X-CAMBIO = IF cb-oper.TPOCMB = 1 THEN
                         gn-tcmb.COMPRA         ELSE
                         gn-tcmb.VENTA.      
       FIND FIRST cb-dmov WHERE cb-dmov.CODCIA  = cb-cmov.CODCIA   AND
                                cb-dmov.PERIODO = cb-cmov.PERIODO  AND
                                cb-dmov.NROMES  = cb-cmov.NROMES   AND
                                cb-dmov.CODOPE  = cb-cmov.CODOPE   AND
                                cb-dmov.NROAST  = cb-cmov.NROAST   
                                NO-ERROR.
       IF AVAIL cb-dmov THEN DO:                  
           cb-cmov.TPOCMB = X-CAMBIO.
           FOR EACH  cb-dmov WHERE cb-dmov.CODCIA  = cb-cmov.CODCIA   AND
                                   cb-dmov.PERIODO = cb-cmov.PERIODO  AND
                                   cb-dmov.NROMES  = cb-cmov.NROMES   AND
                                   cb-dmov.CODOPE  = cb-cmov.CODOPE   AND
                                   cb-dmov.NROAST  = cb-cmov.NROAST 
                                   BREAK BY cb-dmov.NROAST :
           IF FIRST-OF(cb-dmov.NROAST) THEN DO:
              X-D1 = 0.
              X-D2 = 0.
              X-H1 = 0.
              X-H2 = 0.
           END.               
           cb-dmov.TPOCMB  = X-CAMBIO.
           find cb-ctas WHERE cb-ctas.CODCIA = cb-codcia AND
                              cb-ctas.CODCTA = cb-dmov.CODCTA
                              NO-LOCK NO-ERROR.
                              
           CASE cb-dmov.CODMON :
              WHEN 1 THEN DO:
                IF cb-ctas.CODMON = 2 THEN cb-dmov.IMPMN1 = cb-dmov.IMPMN2 * X-CAMBIO.
                ELSE                       cb-dmov.IMPMN2 = cb-dmov.IMPMN1 / X-CAMBIO.
              END.
              WHEN 2 THEN DO:
                 cb-dmov.IMPMN1 = cb-dmov.IMPMN2 * X-CAMBIO.
              END.            
           END CASE.
           
           IF cb-dmov.TPOMOV THEN DO:
              X-H1 = X-H1 + cb-dmov.IMPMN1.
              X-H2 = X-H2 + cb-dmov.IMPMN2.
           END.   
           ELSE DO:
              X-D1 = X-D1 + cb-dmov.IMPMN1.
              X-D2 = X-D2 + cb-dmov.IMPMN2.
           END.
           IF LAST-OF(cb-dmov.NROAST) THEN DO:
              cb-cmov.DBEMN1 = X-D1.
              cb-cmov.DBEMN2 = X-D2.
              cb-cmov.HBEMN1 = X-H1.
              cb-cmov.HBEMN2 = X-H2.
           END.
           
           END. /*FIN DEL FOR EACH cb-dmov */
           
       END. /* FIND DEL AVAIL cb-dmov */                  
       
       END. /* FIN DEL AVAIL TPOCMB */
       
   END. /* FIN DEL FOR EACH cb-cmov */                      
   PTO = SESSION:SET-WAIT-STATE(""). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */
F-MES = s-NroMes.
F-CODOPE = "060".
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
  Purpose:     Dispatched to this procedure when the record-
               source has a new row available.  This procedure
               tries to get the new row and display it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* ADM-ROW-AVAILABLE does nothing because there are no External
     Tables specified for this SmartDialog.
     (See 'Procedure Settings' dialog to set External Tables.) */

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
  DISPLAY F-MES 
      WITH FRAME D-Dialog.
  ENABLE RECT-2 Btn_OK F-MES Btn_Cancel 
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


