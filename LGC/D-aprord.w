&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
DEFINE INPUT PARAMETER C-TIPDOC AS CHAR.
DEFINE INPUT PARAMETER C-NRODOC AS INTEGER.
DEFINE INPUT PARAMETER C-CODPRO AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE     SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE     SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE NEW SHARED VARIABLE S-PROVEE  AS CHAR.
DEFINE     SHARED VARIABLE S-USER-ID AS CHAR.
DEFINE NEW SHARED VARIABLE S-TPOCMB  AS DECIMAL.
DEFINE NEW SHARED VARIABLE S-CODMON  AS INTEGER.

DEFINE VARIABLE L-CREA   AS LOGICAL NO-UNDO.
DEFINE VARIABLE I-NROREQ AS INTEGER NO-UNDO.

DEFINE NEW SHARED VAR lh_Handle AS HANDLE.

DEFINE NEW SHARED TEMP-TABLE DCMP LIKE LG-DOCmp.
DEFINE BUFFER CCMP FOR LG-COCmp.

DEF VAR RPTA AS CHAR NO-UNDO.

DEFINE NEW SHARED VARIABLE S-TPODOC AS CHAR INIT "N".
DEFINE NEW SHARED VARIABLE s-adm-new-record AS CHAR.

DEFINE NEW SHARED VARIABLE s-contrato-marco AS LOG.

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
&Scoped-Define ENABLED-OBJECTS B-Rechaza B-otro B-Aprobar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-ordcmp AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-conord AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vordendecompra AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-Aprobar 
     LABEL "APROBAR" 
     SIZE 19.72 BY 1
     FONT 1.

DEFINE BUTTON B-otro 
     LABEL "EMITIDO" 
     SIZE 19.72 BY 1
     FONT 1.

DEFINE BUTTON B-Rechaza 
     LABEL "RECHAZAR" 
     SIZE 19.72 BY 1.04
     FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     B-Rechaza AT ROW 22.92 COL 14
     B-otro AT ROW 22.92 COL 46
     B-Aprobar AT ROW 22.92 COL 75.43
     SPACE(16.41) SKIP(0.42)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Orden de Compra".


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
   FRAME-NAME                                                           */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Orden de Compra */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Aprobar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Aprobar D-Dialog
ON CHOOSE OF B-Aprobar IN FRAME D-Dialog /* APROBAR */
DO:
  MESSAGE 'Aprobar Documento' VIEW-AS ALERT-BOX 
          QUESTION BUTTONS YES-NO UPDATE x-rpta AS LOGICAL.
  IF x-rpta THEN RUN Aprobar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-otro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-otro D-Dialog
ON CHOOSE OF B-otro IN FRAME D-Dialog /* EMITIDO */
DO:
/*  FIND FIRST Almacen WHERE almacen.codcia = s-codcia
 *     AND almacen.codalm = '11' NO-LOCK NO-ERROR.*/
  FIND Lg-Cocmp WHERE lg-cocmp.codcia = s-codcia
    AND lg-cocmp.tpodoc = c-tipdoc
    AND lg-cocmp.nrodoc = c-nrodoc
    NO-LOCK NO-ERROR.
  FIND Almacen WHERE almacen.codcia = s-codcia
    AND almacen.codalm = lg-cocmp.codalm
    NO-LOCK NO-ERROR.
/*  IF AVAILABLE Almacen
 *   THEN RUN ALM/D-CLAVE.R(Almacen.Clave,OUTPUT RPTA).
 *   ELSE RUN ALM/D-CLAVE.R('654321',OUTPUT RPTA).*/
  RUN ALM/D-CLAVE.R('extorno05',OUTPUT RPTA).
  IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
  
  MESSAGE 'Retornar a Estado Anterior' VIEW-AS ALERT-BOX 
          QUESTION BUTTONS YES-NO UPDATE x-rpta AS LOGICAL.
  IF x-rpta THEN RUN Emitido.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Rechaza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Rechaza D-Dialog
ON CHOOSE OF B-Rechaza IN FRAME D-Dialog /* RECHAZAR */
DO:
  MESSAGE 'Rechazar Documento' VIEW-AS ALERT-BOX 
          QUESTION BUTTONS YES-NO UPDATE x-rpta AS LOGICAL.
  IF x-rpta THEN RUN Rechazar.
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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'LGC/vordendecompra.w':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_vordendecompra ).
       RUN set-position IN h_vordendecompra ( 1.00 , 9.43 ) NO-ERROR.
       /* Size in UIB:  ( 8.85 , 92.72 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'lgc/b-aprord.r':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-ordcmp ).
       RUN set-position IN h_b-ordcmp ( 10.04 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-ordcmp ( 12.58 , 106.14 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'lgc/q-conord.w':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-conord ).
       RUN set-position IN h_q-conord ( 22.92 , 96.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.15 , 14.86 ) */

       /* Links to SmartViewer h_vordendecompra. */
       RUN add-link IN adm-broker-hdl ( h_q-conord , 'Record':U , h_vordendecompra ).

       /* Links to SmartBrowser h_b-ordcmp. */
       RUN add-link IN adm-broker-hdl ( h_vordendecompra , 'Record':U , h_b-ordcmp ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_vordendecompra ,
             B-Rechaza:HANDLE , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-ordcmp ,
             h_vordendecompra , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-conord ,
             B-Aprobar:HANDLE , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aprobar D-Dialog 
PROCEDURE Aprobar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR x-Llave AS CHAR.
    
    FIND CCMP WHERE CCMP.CODCIA = S-CODCIA 
        AND CCMP.CODDIV = S-CODDIV
        AND CCMP.TPODOC = C-TIPDOC 
        AND CCMP.NRODOC = C-NRODOC NO-ERROR.
    IF AVAILABLE CCMP THEN DO:
        ASSIGN
            x-Llave = STRING(S-CODDIV, 'x(5)')+
                        STRING(c-TipDoc, 'X') +
                        STRING(c-NroDoc, '999999') +
                        'P'    
            CCMP.FlgSit = "P".
        RUN dispatch IN h_vordendecompra ('display-fields':U).
        RUN Imprime-Texto IN h_vordendecompra.
        /* RHC 26.05.04 Guardar un log */
        RUN lib/logtabla ('LG-COCMP', x-Llave, 'APROBADO').   /* Log de cambios */
    END.                 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Emitido D-Dialog 
PROCEDURE Emitido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR x-Llave AS CHAR.
    
    FIND CCMP WHERE CCMP.CODCIA = S-CODCIA 
        AND CCMP.CODDIV = S-CODDIV
        AND CCMP.TPODOC = C-TIPDOC 
        AND CCMP.NRODOC = C-NRODOC NO-ERROR.
    IF AVAILABLE CCMP THEN DO:
        /* RHC 12.04.04 VERIFICAMOS QUE NO TENGA ATENCIONES PARCIALES */
        FOR EACH LG-DOCMP OF CCMP NO-LOCK:
            IF LG-DOCMP.CanAten > 0
            THEN DO:
                MESSAGE "La Orden de Compra tiene atenciones parciales" SKIP
                    "No va a ser posible regresarla al estado de EMITIDA"
                    VIEW-AS ALERT-BOX ERROR.
                RETURN.
            END.
        END.
        ASSIGN
            x-Llave = STRING(s-CodDiv, 'x(5)') +
                        STRING(c-TipDoc, 'X') +
                        STRING(c-NroDoc, '999999') +
                        'G'    
            CCMP.FlgSit = "G".
        RUN dispatch IN h_vordendecompra ('display-fields':U).        
        /* RHC 26.05.04 Guardar un log */
        RUN lib/logtabla ('LG-COCMP', x-Llave, 'EMITIDO').   /* Log de cambios */
    END.                 

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
  ENABLE B-Rechaza B-otro B-Aprobar 
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
  
  RUN Recibe-Parametros IN h_q-conord (C-TIPDOC,C-NRODOC,C-CODPRO).
  FIND CCMP WHERE CCMP.CODCIA = S-CODCIA 
    AND CCMP.CODDIV = S-CODDIV
    AND CCMP.TPODOC = C-TIPDOC 
    AND CCMP.NRODOC = C-NRODOC NO-ERROR.
       IF AVAILABLE CCMP THEN DO:
          DO WITH FRAME {&FRAME-NAME}:
             CASE CCMP.FLGSIT :
             
                   WHEN "X" THEN DO:
                        B-APROBAR:HIDDEN = TRUE.
                        B-RECHAZA:HIDDEN = TRUE.
                        B-OTRO:HIDDEN = FALSE.
                   END.
                   WHEN "P" THEN DO:
                        B-APROBAR:HIDDEN = TRUE.
                        B-RECHAZA:HIDDEN = TRUE.
                        B-OTRO:HIDDEN = FALSE.
                   END.
                   WHEN "G" THEN DO:
                        B-APROBAR:HIDDEN = FALSE.
                        B-RECHAZA:HIDDEN = FALSE.
                        B-OTRO:HIDDEN = TRUE.
                   END.
             END.
          END.    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rechazar D-Dialog 
PROCEDURE Rechazar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Llave AS CHAR.
  
  FIND CCMP WHERE CCMP.CODCIA = S-CODCIA 
    AND CCMP.CODDIV = S-CODDIV
    AND CCMP.TPODOC = C-TIPDOC 
    AND CCMP.NRODOC = C-NRODOC NO-ERROR.
     IF AVAILABLE CCMP THEN DO:
        ASSIGN
            x-Llave = STRING(s-CodDiv, 'x(5)') +
                        STRING(c-TipDoc, 'X') +
                        STRING(c-NroDoc, '999999') +
                        'X'    
          CCMP.FlgSit = "X".
          RUN dispatch IN h_vordendecompra ('display-fields':U).        
        /* RHC 26.05.04 Guardar un log */
        RUN lib/logtabla ('LG-COCMP', x-Llave, 'RECHAZADO').   /* Log de cambios */
     END.                 

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

