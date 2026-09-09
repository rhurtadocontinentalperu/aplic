&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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

DEFINE SHARED VAR s-codcia AS INT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rdBtn TxtNroDocto txtBultos BtnActualizar 
&Scoped-Define DISPLAYED-OBJECTS rdBtn TxtNroDocto txtEmitido txtBultos 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnActualizar 
     LABEL "Actualizar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtBultos AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Bultos" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtEmitido AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitido" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE TxtNroDocto AS CHARACTER FORMAT "X(9)":U 
     LABEL "Nro de Documento" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE rdBtn AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Orden de Despacho (O/D)", 1,
"Transferencia (TRA)", 2,
"Orden de Transferencia (OTR)", 3
     SIZE 31 BY 2.31 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     rdBtn AT ROW 1.96 COL 5 NO-LABEL WIDGET-ID 2
     TxtNroDocto AT ROW 2.54 COL 55 COLON-ALIGNED WIDGET-ID 6
     txtEmitido AT ROW 5.42 COL 10 COLON-ALIGNED WIDGET-ID 10
     txtBultos AT ROW 5.42 COL 35 COLON-ALIGNED WIDGET-ID 12
     BtnActualizar AT ROW 8.31 COL 49 WIDGET-ID 14
     "Ejm. 001002536" VIEW-AS TEXT
          SIZE 13.57 BY .62 AT ROW 1.85 COL 57.14 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 77.43 BY 8.96 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Correcion de Bultos"
         HEIGHT             = 8.81
         WIDTH              = 76.72
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN txtEmitido IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Correcion de Bultos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Correcion de Bultos */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnActualizar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnActualizar W-Win
ON CHOOSE OF BtnActualizar IN FRAME F-Main /* Actualizar */
DO:
  IF txtBultos:VISIBLE = FALSE THEN DO:
      MESSAGE "Busque un documento para actualizar" VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.

  ASSIGN txtBultos.
  ASSIGN rdBtn rdBtn txtNroDocto.
  DEFINE VAR lCodDoc AS CHAR.

  IF txtNroDocto = "" THEN RETURN .

/*  IF (rdBtn = 1) THEN lCodDoc = 'O/D'. ELSE lCodDoc = 'TRA'.*/

    CASE rdBtn:
        WHEN 1 THEN /* Yes */
        DO:
          lCodDoc = 'O/D'.
        END.
    WHEN 2 THEN
        DO:
          lCodDoc = 'TRA'.
        END.
    WHEN 3 THEN
        DO:
          lCodDoc = 'OTR'.
        END.
    END CASE.
  
  FIND FIRST ccbcbult WHERE ccbcbult.codcia = s-codcia AND
      ccbcbult.Coddoc = lCodDoc AND ccbcbult.nrodoc = txtNroDocto EXCLUSIVE NO-ERROR.
  IF AVAILABLE ccbcbult THEN DO:      
      ASSIGN ccbcbult.bultos = txtBultos.
      MESSAGE "Los datos se ACTUALIZARON CORRECTAMENTE..." VIEW-AS ALERT-BOX WARNING.
  END.
  ELSE DO:
      MESSAGE "No existe el Documento..." VIEW-AS ALERT-BOX WARNING.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rdBtn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rdBtn W-Win
ON ENTRY OF rdBtn IN FRAME F-Main
DO:
         DO WITH FRAME {&FRAME-NAME}:
           txtEmitido:VISIBLE = FALSE.
            txtBultos:VISIBLE = FALSE.
            BtnActualizar:LABEL = "Buscar".
            /*BtnActualizar:VISIBLE = FALSE.*/
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rdBtn W-Win
ON GO OF rdBtn IN FRAME F-Main
DO:
    /*
    DISABLE txtEmitido WITH FRAME {&FRAME-NAME}.
    DISABLE txtBultos WITH FRAME {&FRAME-NAME}.
    */
    MESSAGE '2222222222 NO existe el material' VIEW-AS ALERT-BOX ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TxtNroDocto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TxtNroDocto W-Win
ON ENTRY OF TxtNroDocto IN FRAME F-Main /* Nro de Documento */
DO:
    txtEmitido:VISIBLE = FALSE.  
    txtBultos:VISIBLE = FALSE.
    BtnActualizar:LABEL = "Buscar".
    /*BtnActualizar:VISIBLE = FALSE.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TxtNroDocto W-Win
ON LEAVE OF TxtNroDocto IN FRAME F-Main /* Nro de Documento */
DO:
  DEFINE VAR lCOdDoc AS CHAR.
 
  ASSIGN rdBtn rdBtn txtNroDocto.

  IF txtNroDocto = "" THEN RETURN .

  /*IF (rdBtn = 1) THEN lCodDoc = 'O/D'. ELSE lCodDoc = 'TRA'.*/

        CASE rdBtn:
            WHEN 1 THEN /* Yes */
            DO:
              lCodDoc = 'O/D'.
            END.
        WHEN 2 THEN
            DO:
              lCodDoc = 'TRA'.
            END.
        WHEN 3 THEN
            DO:
              lCodDoc = 'OTR'.
            END.
        END CASE.
  
  FIND FIRST ccbcbult WHERE ccbcbult.codcia = s-codcia AND
      ccbcbult.Coddoc = lCodDoc AND ccbcbult.nrodoc = txtNroDocto NO-LOCK NO-ERROR.
  IF AVAILABLE ccbcbult THEN DO:      
      /*BtnActualizar:VISIBLE = TRUE .*/
      txtEmitido:VISIBLE = TRUE.
      txtBultos:VISIBLE = TRUE.      

      txtEmitido:SCREEN-VALUE = STRING(ccbcbult.fchdoc,"99/99/9999").
      txtBultos:SCREEN-VALUE = STRING(ccbcbult.bultos,">>,>>9").

      BtnActualizar:LABEL = "Actualizar".

      APPLY 'ENTRY':U TO txtBultos.

      RETURN NO-APPLY.
  END.
  ELSE DO:
      txtEmitido:VISIBLE = FALSE.
      txtBultos:VISIBLE = FALSE.
      /*BtnActualizar:VISIBLE = FALSE.*/

      MESSAGE "No existe el Documento" VIEW-AS ALERT-BOX WARNING.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  DISPLAY rdBtn TxtNroDocto txtEmitido txtBultos 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE rdBtn TxtNroDocto txtBultos BtnActualizar 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable W-Win 
PROCEDURE local-disable :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable W-Win 
PROCEDURE local-enable :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable':U ) .

  /* Code placed here will execute AFTER standard behavior.    */  

  /*ENABLE txtBultos.*/
  ENABLE txtBultos.
     txtBultos:VISIBLE = TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
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

