&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE T-RutaDv NO-UNDO LIKE Di-RutaDv.



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
DEF INPUT PARAMETER x-Rowid AS ROWID.

/* Local Variable Definitions ---                                       */
FIND Di-RutaD WHERE ROWID(Di-RutaD) = x-Rowid NO-LOCK.
FIND ccbcdocu WHERE ccbcdocu.codcia = di-rutad.codcia
    AND ccbcdocu.coddoc = di-rutad.codref
    AND ccbcdocu.nrodoc = di-rutad.nroref NO-LOCK.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCDocu

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define FIELDS-IN-QUERY-D-Dialog CcbCDocu.CodDoc CcbCDocu.NroDoc ~
CcbCDocu.FchDoc CcbCDocu.CodCli CcbCDocu.NomCli 
&Scoped-define QUERY-STRING-D-Dialog FOR EACH CcbCDocu SHARE-LOCK
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH CcbCDocu SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog CcbCDocu


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 Btn_OK Btn_Cancel FILL-IN-Glosa 
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.CodDoc CcbCDocu.NroDoc ~
CcbCDocu.FchDoc CcbCDocu.CodCli CcbCDocu.NomCli 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-1 FILL-IN-Glosa 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-rut002b AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv96 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Aceptar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-Glosa AS CHARACTER FORMAT "X(256)":U 
     LABEL "Glosa" 
     VIEW-AS FILL-IN 
     SIZE 83 BY 1 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS CHARACTER INITIAL "R" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Reprogramado", "R",
"Anulado", "A"
     SIZE 14 BY 3 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 3.46.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     RADIO-SET-1 AT ROW 1.27 COL 83 NO-LABEL WIDGET-ID 2
     CcbCDocu.CodDoc AT ROW 1.38 COL 12 COLON-ALIGNED
          LABEL "Documento"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     CcbCDocu.NroDoc AT ROW 1.38 COL 18 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     Btn_OK AT ROW 1.38 COL 69
     CcbCDocu.FchDoc AT ROW 2.35 COL 12 COLON-ALIGNED
          LABEL "Emision"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Btn_Cancel AT ROW 2.73 COL 69
     CcbCDocu.CodCli AT ROW 3.31 COL 12 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCDocu.NomCli AT ROW 3.31 COL 24 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 37.14 BY .81
     FILL-IN-Glosa AT ROW 12.04 COL 7 COLON-ALIGNED WIDGET-ID 6
     RECT-1 AT ROW 1 COL 2
     SPACE(17.56) SKIP(9.07)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "DEVOLUCION PARCIAL"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-RutaDv T "NEW SHARED" NO-UNDO INTEGRAL Di-RutaDv
   END-TABLES.
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

/* SETTINGS FOR FILL-IN CcbCDocu.CodCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.CodDoc IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.FchDoc IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.NomCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET RADIO-SET-1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "INTEGRAL.CcbCDocu"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* DEVOLUCION PARCIAL */
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
  /* Verificamos si ha hecho devoluciones o no */
  ASSIGN RADIO-SET-1 FILL-IN-Glosa.

  IF TRUE <> (FILL-IN-Glosa > '') THEN DO:
      MESSAGE 'La Glosa es obligatoria' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN-Glosa.
      RETURN NO-APPLY.
  END.

  DEF VAR x-CanDev LIKE Di-RutaDv.CanDev INIT 0 NO-UNDO.

  FOR EACH T-RutaDv:
    x-CanDev = x-CanDev + t-rutadv.candev.
  END.  
  IF x-CanDev = 0
  THEN DO:
      MESSAGE "No ha ingresado las devoluciones" VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.
  FIND CURRENT Di-RutaD EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
  IF ERROR-STATUS:ERROR
  THEN DO:
      MESSAGE "El registro esta en uso por otro usuario"
          VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  FOR EACH Di-RutaDv WHERE Di-RutaDv.CodCia = Di-RutaD.codcia
      AND Di-RutaDv.CodDiv = Di-RutaD.coddiv
      AND Di-RutaDv.CodDoc = Di-RutaD.coddoc
      AND Di-RutaDv.NroDoc = Di-RutaD.nrodoc
      AND Di-RutaDv.CodRef = Di-RutaD.codref
      AND Di-RutaDv.NroRef = Di-RutaD.nroref:
      DELETE Di-RutaDv.
  END.
  FOR EACH T-RutaDv:
      CREATE Di-RutaDv.
      BUFFER-COPY T-RutaDv TO Di-RutaDv.
  END.
  ASSIGN 
      Di-RutaD.FlgEst = 'D'
      Di-RutaD.FlgEstDet = ''
      Di-RutaD.Libre_c02 = RADIO-SET-1
      Di-RutaD.Libre_c03 = FILL-IN-Glosa.
  RELEASE Di-RutaD.
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
             INPUT  'aplic/alm/b-rut002b.w':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-rut002b ).
       RUN set-position IN h_b-rut002b ( 4.85 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-rut002b ( 6.69 , 80.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv96 ).
       RUN set-position IN h_p-updv96 ( 5.62 , 84.00 ) NO-ERROR.
       RUN set-size IN h_p-updv96 ( 5.19 , 10.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-rut002b. */
       RUN add-link IN adm-broker-hdl ( h_p-updv96 , 'TableIO':U , h_b-rut002b ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-rut002b ,
             CcbCDocu.NomCli:HANDLE , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv96 ,
             h_b-rut002b , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Browse D-Dialog 
PROCEDURE Carga-Browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH T-RutaDv:
    DELETE T-RutaDv.
  END.
  
  FIND FIRST Di-RutaDv WHERE Di-RutaDv.CodCia = Di-RutaD.codcia
    AND Di-RutaDv.CodDiv = Di-RutaD.coddiv
    AND Di-RutaDv.CodDoc = Di-RutaD.coddoc
    AND Di-RutaDv.NroDoc = Di-RutaD.nrodoc 
    AND Di-RutaDv.CodRef = Di-RutaD.codref
    AND Di-RutaDv.NroRef = Di-RutaD.nroref NO-LOCK NO-ERROR.
  IF AVAILABLE Di-RutaDv
  THEN DO:      /* Cargamos la informacion */
    FOR EACH Di-RutaDv NO-LOCK WHERE Di-RutaDv.CodCia = Di-RutaD.codcia
            AND Di-RutaDv.CodDiv = Di-RutaD.coddiv
            AND Di-RutaDv.CodDoc = Di-RutaD.coddoc
            AND Di-RutaDv.NroDoc = Di-RutaD.nrodoc
            AND Di-RutaDv.CodRef = Di-RutaD.codref
            AND Di-RutaDv.NroRef = Di-RutaD.nroref:
        CREATE T-RutaDv.
        BUFFER-COPY Di-RutaDv TO T-RutaDv.
    END.
  END.
  ELSE DO:      /* Creamos los registros */
    FOR EACH ccbddocu OF ccbcdocu NO-LOCK:
        CREATE T-RutaDv.
        BUFFER-COPY CcbDDocu TO T-RutaDv
            ASSIGN
                T-RutaDv.CodCia = di-rutad.codcia 
                T-RutaDv.CodDiv = di-rutad.coddiv
                T-RutaDv.CodDoc = di-rutad.coddoc
                T-RutaDv.NroDoc = di-rutad.nrodoc
                T-RutaDv.CodRef = di-rutad.codref
                T-RutaDv.NroRef = di-rutad.nroref
                T-RutaDv.CanDev = 0.
        /*        
        BUFFER-COPY Di-RutaD TO T-RutaDv
            ASSIGN 
                T-RutaDv.codmat = ccbddocu.codmat
        */
    END.
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
  DISPLAY RADIO-SET-1 FILL-IN-Glosa 
      WITH FRAME D-Dialog.
  IF AVAILABLE CcbCDocu THEN 
    DISPLAY CcbCDocu.CodDoc CcbCDocu.NroDoc CcbCDocu.FchDoc CcbCDocu.CodCli 
          CcbCDocu.NomCli 
      WITH FRAME D-Dialog.
  ENABLE RECT-1 Btn_OK Btn_Cancel FILL-IN-Glosa 
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
  RUN Carga-Browse.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN dispatch IN h_b-rut002b ('open-query':U).

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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "CcbCDocu"}

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

