&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME C-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Dialog 
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

DEFINE &IF "{&NEW}" = "" &THEN INPUT PARAMETER &ELSE VARIABLE &ENDIF titulo AS CHARACTER.

/* Poner aqui el nombre del l-lookup en vez de h_l-tabla */
&SCOPED-DEFINE l-lookup h_l-guicsg

DEFINE SHARED TEMP-TABLE LIQU LIKE FacDLiqu.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartConsulta

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME C-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK Btn_Cancel Btn_Help Btn-Adiciona ~
Btn-Borra 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-detcsg AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-liqtmp AS HANDLE NO-UNDO.
DEFINE VARIABLE h_l-guicsg AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-option AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-Adiciona 
     IMAGE-UP FILE "img\btn-down":U
     LABEL "Btn 1" 
     SIZE 4 BY 1.

DEFINE BUTTON Btn-Borra 
     IMAGE-UP FILE "img\btn-up":U
     LABEL "Btn 2" 
     SIZE 4 BY 1.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Cancelar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     IMAGE-UP FILE "img\b-ayuda":U
     LABEL "A&yuda" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "&Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME C-Dialog
     Btn_OK AT ROW 17.27 COL 31.29
     Btn_Cancel AT ROW 17.27 COL 49.43
     Btn_Help AT ROW 17.27 COL 67
     Btn-Adiciona AT ROW 9.46 COL 85
     Btn-Borra AT ROW 13.96 COL 85
     SPACE(0.71) SKIP(4.61)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "<Título de Consulta>".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartConsulta
   Allow: Basic,Browse,DB-Fields,Smart,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX C-Dialog
                                                                        */
ASSIGN 
       FRAME C-Dialog:SCROLLABLE       = FALSE
       FRAME C-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX C-Dialog
/* Query rebuild information for DIALOG-BOX C-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX C-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Dialog C-Dialog
ON WINDOW-CLOSE OF FRAME C-Dialog /* <Título de Consulta> */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Adiciona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Adiciona C-Dialog
ON CHOOSE OF Btn-Adiciona IN FRAME C-Dialog /* Btn 1 */
DO:
  RUN Asigna-al-Temporal IN h_b-detcsg.
  RUN dispatch IN h_b-liqtmp ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Borra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Borra C-Dialog
ON CHOOSE OF Btn-Borra IN FRAME C-Dialog /* Btn 2 */
DO:
  RUN Borra-Registro IN h_b-liqtmp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel C-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME C-Dialog /* Cancelar */
DO:
  RUN Borra-Temporal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help C-Dialog
ON CHOOSE OF Btn_Help IN FRAME C-Dialog /* Ayuda */
OR HELP OF FRAME {&FRAME-NAME} DO:
    BELL.
    MESSAGE "Ayuda para Archivo: {&FILE-NAME}":U VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK C-Dialog
ON CHOOSE OF Btn_OK IN FRAME C-Dialog /* Aceptar */
DO:
    RUN captura-datos IN {&l-lookup}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Dialog 


/* ***************************  Main Block  *************************** */

IF titulo <> "" THEN ASSIGN FRAME {&FRAME-NAME}:TITLE = titulo.

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects C-Dialog _ADM-CREATE-OBJECTS
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
             INPUT  'aplic/lkup/l-guicsg.w':U ,
             INPUT  FRAME C-Dialog:HANDLE ,
             INPUT  'Layout = ,
                     SortBy-Case = No.Pedido':U ,
             OUTPUT h_l-guicsg ).
       RUN set-position IN h_l-guicsg ( 1.00 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 6.12 , 87.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'lkup/b-detcsg.w':U ,
             INPUT  FRAME C-Dialog:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-detcsg ).
       RUN set-position IN h_b-detcsg ( 7.19 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 5.27 , 82.86 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'lkup/b-liqtmp.w':U ,
             INPUT  FRAME C-Dialog:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-liqtmp ).
       RUN set-position IN h_b-liqtmp ( 12.69 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 4.12 , 83.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-option.w':U ,
             INPUT  FRAME C-Dialog:HANDLE ,
             INPUT  'Style = Combo-Box,
                     Drawn-in-UIB = yes,
                     Case-Attribute = SortBy-Case,
                     Case-Changed-Event = Open-Query,
                     Dispatch-Open-Query = yes,
                     Edge-Pixels = 2,
                     Label = ':U + '&Ordenado por:' + ',
                     Link-Name = SortBy-Target,
                     Margin-Pixels = 8,
                     Options-Attribute = SortBy-Options,
                     Font = 4':U ,
             OUTPUT h_p-option ).
       RUN set-position IN h_p-option ( 16.96 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-option ( 2.15 , 26.29 ) NO-ERROR.

       /* Links to SmartLookup h_l-guicsg. */
       RUN add-link IN adm-broker-hdl ( h_p-option , 'SortBy':U , h_l-guicsg ).

       /* Links to SmartBrowser h_b-detcsg. */
       RUN add-link IN adm-broker-hdl ( h_l-guicsg , 'Record':U , h_b-detcsg ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_l-guicsg ,
             Btn_OK:HANDLE , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-detcsg ,
             h_l-guicsg , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-liqtmp ,
             h_b-detcsg , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-option ,
             h_b-liqtmp , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available C-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal C-Dialog 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH LIQU :
    DELETE LIQU.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Dialog _DEFAULT-DISABLE
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
  HIDE FRAME C-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Dialog _DEFAULT-ENABLE
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
  ENABLE Btn_OK Btn_Cancel Btn_Help Btn-Adiciona Btn-Borra 
      WITH FRAME C-Dialog.
  VIEW FRAME C-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-C-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize C-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    /* Code placed here will execute AFTER standard behavior.    */

    RUN toma-handle IN {&l-lookup} ( THIS-PROCEDURE ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE p-aceptar C-Dialog 
PROCEDURE p-aceptar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    APPLY "CHOOSE" TO Btn_OK IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records C-Dialog _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartConsulta, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed C-Dialog 
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


