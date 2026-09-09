&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
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
DEF INPUT PARAMETER pFlgCie AS CHAR.

DEFINE NEW SHARED VARIABLE S-FLGCIE  AS CHAR.

s-FlgCie = pFlgCie.

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
&Scoped-Define ENABLED-OBJECTS RECT-1 FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 ~
FILL-IN-NomCli COMBO-BOX-CodDoc FILL-IN-NroDoc BUTTON-1 BUTTON-2 ~
BUTTON-Refrescar BUTTON-Anular 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 ~
FILL-IN-NomCli COMBO-BOX-CodDoc FILL-IN-NroDoc 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-anula-ic-contado AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-anula-ic-contado-doc AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-anula-ic-contado-otro AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-divisiones AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Aplicar Filtro" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "Limpiar Filtro" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Anular 
     LABEL "ANULAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Refrescar 
     LABEL "REFRESCAR" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX-CodDoc AS CHARACTER FORMAT "X(256)":U INITIAL "BOL" 
     LABEL "Comprobante" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "BOL","FAC" 
     DROP-DOWN-LIST
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-1 AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Emitidos Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre Cliente" 
     VIEW-AS FILL-IN 
     SIZE 36 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "X(11)":U 
     LABEL "Número" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50 BY 5.65.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-FchDoc-1 AT ROW 2.35 COL 82 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-FchDoc-2 AT ROW 3.15 COL 82 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-NomCli AT ROW 3.96 COL 82 COLON-ALIGNED WIDGET-ID 12
     COMBO-BOX-CodDoc AT ROW 4.77 COL 82 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-NroDoc AT ROW 4.77 COL 96 COLON-ALIGNED WIDGET-ID 16
     BUTTON-1 AT ROW 6.12 COL 72 WIDGET-ID 22
     BUTTON-2 AT ROW 6.12 COL 88 WIDGET-ID 24
     BUTTON-Refrescar AT ROW 7.46 COL 71 WIDGET-ID 4
     BUTTON-Anular AT ROW 8.54 COL 71 WIDGET-ID 2
     "Filtros" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 1.54 COL 72 WIDGET-ID 20
          BGCOLOR 9 FGCOLOR 15 
     RECT-1 AT ROW 1.81 COL 71 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 142 BY 25.5
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 25.5
         WIDTH              = 142
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 144.29
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 144.29
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
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* <insert SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Aplicar Filtro */
DO:
  ASSIGN COMBO-BOX-CodDoc FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 FILL-IN-NomCli FILL-IN-NroDoc.
  RUN Filtrar IN h_b-anula-ic-contado
    ( INPUT FILL-IN-FchDoc-1 /* DATE */,
      INPUT FILL-IN-FchDoc-2 /* DATE */,
      INPUT FILL-IN-NomCli /* CHARACTER */,
      INPUT COMBO-BOX-CodDoc /* CHARACTER */,
      INPUT FILL-IN-NroDoc /* CHARACTER */).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Limpiar Filtro */
DO:
  ASSIGN
      COMBO-BOX-CodDoc = 'BOL'
      FILL-IN-FchDoc-1 = ?
      FILL-IN-FchDoc-2 = ?
      FILL-IN-NomCli = ''
      FILL-IN-NroDoc = ''.
  DISPLAY COMBO-BOX-CodDoc FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 FILL-IN-NomCli FILL-IN-NroDoc
      WITH FRAME {&FRAME-NAME}.
  RUN Limpiar-Filtro IN h_b-anula-ic-contado.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Anular
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Anular W-Win
ON CHOOSE OF BUTTON-Anular IN FRAME F-Main /* ANULAR */
DO:
  MESSAGE 'Procedemos con la anulación del I/C y de los COMPROBANTES relacionados?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  RUN Anular IN h_b-anula-ic-contado.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  RUN dispatch IN h_b-anula-ic-contado ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Refrescar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Refrescar W-Win
ON CHOOSE OF BUTTON-Refrescar IN FRAME F-Main /* REFRESCAR */
DO:
  RUN dispatch IN h_b-anula-ic-contado ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

CASE s-FlgCie:
    WHEN "C" THEN {&WINDOW-NAME}:TITLE = "ANULACION DE I/C POR VENTAS MOSTRADOR CERRADAS".
    WHEN "P" THEN {&WINDOW-NAME}:TITLE = "ANULACION DE I/C PÓR VENTAS MOSTRADOR PENDIENTES DE CERRAR".
END CASE.

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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/gn/b-divisiones.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-divisiones ).
       RUN set-position IN h_b-divisiones ( 1.27 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-divisiones ( 5.38 , 66.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/sunat/b-anula-ic-contado.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-anula-ic-contado ).
       RUN set-position IN h_b-anula-ic-contado ( 6.92 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-anula-ic-contado ( 12.38 , 66.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/sunat/b-anula-ic-contado-otro.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-anula-ic-contado-otro ).
       RUN set-position IN h_b-anula-ic-contado-otro ( 11.23 , 73.00 ) NO-ERROR.
       RUN set-size IN h_b-anula-ic-contado-otro ( 6.69 , 36.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/sunat/b-anula-ic-contado-doc.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-anula-ic-contado-doc ).
       RUN set-position IN h_b-anula-ic-contado-doc ( 19.58 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-anula-ic-contado-doc ( 6.69 , 92.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-anula-ic-contado. */
       RUN add-link IN adm-broker-hdl ( h_b-divisiones , 'Record':U , h_b-anula-ic-contado ).

       /* Links to SmartBrowser h_b-anula-ic-contado-otro. */
       RUN add-link IN adm-broker-hdl ( h_b-anula-ic-contado , 'Record':U , h_b-anula-ic-contado-otro ).

       /* Links to SmartBrowser h_b-anula-ic-contado-doc. */
       RUN add-link IN adm-broker-hdl ( h_b-anula-ic-contado , 'Record':U , h_b-anula-ic-contado-doc ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-divisiones ,
             FILL-IN-FchDoc-1:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-anula-ic-contado ,
             BUTTON-2:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-anula-ic-contado-otro ,
             BUTTON-Anular:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-anula-ic-contado-doc ,
             h_b-anula-ic-contado-otro , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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
  DISPLAY FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 FILL-IN-NomCli COMBO-BOX-CodDoc 
          FILL-IN-NroDoc 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 FILL-IN-NomCli 
         COMBO-BOX-CodDoc FILL-IN-NroDoc BUTTON-1 BUTTON-2 BUTTON-Refrescar 
         BUTTON-Anular 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
/*   CASE s-FlgCie:                                                                        */
/*       /* NO CERRADOS */                                                                 */
/*       WHEN "P" THEN DISABLE FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 WITH FRAME {&FRAME-NAME}. */
/*   END CASE.                                                                             */

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

