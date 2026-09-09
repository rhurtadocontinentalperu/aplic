&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME alog
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS alog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM2 SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
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

{src/adm2/widgetprto.i}

DEFINE INPUT PARAMETER X-ROWID AS ROWID.
FIND FACCPEDI WHERE ROWID(FACCPEDI) = X-ROWID EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE FACCPEDI THEN RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME alog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS F-CodTran F-Direccion F-Lugar F-Contacto ~
F-horario Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-CodTran FILL-IN-6 F-ruc F-Direccion ~
F-Lugar F-Contacto F-horario 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 11 BY 1.08.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 11 BY 1.08.

DEFINE VARIABLE F-CodTran AS CHARACTER FORMAT "X(256)":U 
     LABEL "Agencia Transporte" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     FONT 4 NO-UNDO.

DEFINE VARIABLE F-Contacto AS CHARACTER FORMAT "X(256)":U 
     LABEL "Contacto" 
     VIEW-AS FILL-IN 
     SIZE 42 BY .81
     FONT 4 NO-UNDO.

DEFINE VARIABLE F-Direccion AS CHARACTER FORMAT "X(256)":U 
     LABEL "Direccion" 
     VIEW-AS FILL-IN 
     SIZE 42 BY .81
     FONT 4 NO-UNDO.

DEFINE VARIABLE F-horario AS CHARACTER FORMAT "X(256)":U 
     LABEL "Horario de Atencion" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     FONT 4 NO-UNDO.

DEFINE VARIABLE F-Lugar AS CHARACTER FORMAT "X(256)":U 
     LABEL "Lugar de Entrega" 
     VIEW-AS FILL-IN 
     SIZE 42 BY .81
     FONT 4 NO-UNDO.

DEFINE VARIABLE F-ruc AS CHARACTER FORMAT "X(256)":U 
     LABEL "RUC" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     FONT 4 NO-UNDO.

DEFINE VARIABLE FILL-IN-6 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME alog
     F-CodTran AT ROW 1.27 COL 14 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-6 AT ROW 1.27 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     F-ruc AT ROW 2.08 COL 14 COLON-ALIGNED WIDGET-ID 14
     F-Direccion AT ROW 2.88 COL 14 COLON-ALIGNED WIDGET-ID 4
     F-Lugar AT ROW 3.69 COL 14 COLON-ALIGNED WIDGET-ID 6
     F-Contacto AT ROW 4.5 COL 14 COLON-ALIGNED WIDGET-ID 8
     F-horario AT ROW 5.31 COL 14 COLON-ALIGNED WIDGET-ID 10
     Btn_OK AT ROW 6.65 COL 21
     Btn_Cancel AT ROW 6.65 COL 37
     SPACE(22.71) SKIP(0.18)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "AGENCIA DE TRANSPORTE"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB alog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX alog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME alog:SCROLLABLE       = FALSE
       FRAME alog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-ruc IN FRAME alog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-6 IN FRAME alog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX alog
/* Query rebuild information for DIALOG-BOX alog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX alog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME alog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL alog alog
ON WINDOW-CLOSE OF FRAME alog /* AGENCIA DE TRANSPORTE */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel alog
ON CHOOSE OF Btn_Cancel IN FRAME alog /* Cancel */
DO:
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK alog
ON CHOOSE OF Btn_OK IN FRAME alog /* OK */
DO:
    
        ASSIGN
            F-CodTran:SCREEN-VALUE   = FacCPedi.Libre_c01
            F-direccion:SCREEN-VALUE = FacCPedi.Libre_c02
            F-lugar:SCREEN-VALUE     = FacCPedi.Libre_c03
            F-contacto:SCREEN-VALUE  = FacCPedi.Libre_c04
            F-horario:SCREEN-VALUE   = FacCPedi.Libre_c05 .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK alog 


/* ***************************  Main Block  *************************** */

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects alog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI alog  _DEFAULT-DISABLE
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
  HIDE FRAME alog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI alog  _DEFAULT-ENABLE
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
  DISPLAY F-CodTran FILL-IN-6 F-ruc F-Direccion F-Lugar F-Contacto F-horario 
      WITH FRAME alog.
  ENABLE F-CodTran F-Direccion F-Lugar F-Contacto F-horario Btn_OK Btn_Cancel 
      WITH FRAME alog.
  VIEW FRAME alog.
  {&OPEN-BROWSERS-IN-QUERY-alog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

