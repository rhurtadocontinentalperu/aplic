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

DEF NEW SHARED VAR lh_handle AS HANDLE.

/* Variables para Cross Docking */
DEF VAR pCrossDocking AS LOG NO-UNDO.
DEF VAR pAlmacenXD AS CHAR NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS RECT-26 RECT-27 EDITOR-AlmPed BUTTON-16 ~
COMBO-BOX-Motivo BUTTON-4 FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 BUTTON-1 ~
FILL-IN-Fecha-1 FILL-IN-Fecha-2 EDITOR-CodAlm BUTTON-17 FILL-IN-Usuario ~
BUTTON-CONSULTAR 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-AlmPed COMBO-BOX-Motivo ~
FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 FILL-IN-Fecha-1 FILL-IN-Fecha-2 ~
EDITOR-CodAlm FILL-IN-Usuario 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-aprob-abastec-cab AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv96-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-aprob-abastec-v2 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "APROBAR SELECCIONADOS" 
     SIZE 27 BY 1.12
     FONT 6.

DEFINE BUTTON BUTTON-16 
     IMAGE-UP FILE "img/b-buscar.ico":U
     LABEL "Button 16" 
     SIZE 5 BY 1.12.

DEFINE BUTTON BUTTON-17 
     IMAGE-UP FILE "img/b-buscar.ico":U
     LABEL "Button 17" 
     SIZE 5 BY 1.12.

DEFINE BUTTON BUTTON-4 
     LABEL "RECHAZAR SELECCIONADOS" 
     SIZE 27 BY 1.12
     FONT 6.

DEFINE BUTTON BUTTON-CONSULTAR 
     LABEL "CONSULTAR" 
     SIZE 15 BY 1.12
     FONT 6.

DEFINE VARIABLE COMBO-BOX-Motivo AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Motivo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 32 BY 1 NO-UNDO.

DEFINE VARIABLE EDITOR-AlmPed AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 42 BY 2 NO-UNDO.

DEFINE VARIABLE EDITOR-CodAlm AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 42 BY 2 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Entrega" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Usuario AS CHARACTER FORMAT "X(256)":U 
     LABEL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 29 BY 4.58
     BGCOLOR 15 FGCOLOR 0 .

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 113 BY 4.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     EDITOR-AlmPed AT ROW 1.27 COL 17 NO-LABEL WIDGET-ID 52
     BUTTON-16 AT ROW 1.27 COL 59 WIDGET-ID 56
     COMBO-BOX-Motivo AT ROW 1.27 COL 75 COLON-ALIGNED WIDGET-ID 26
     BUTTON-4 AT ROW 1.27 COL 116 WIDGET-ID 18
     FILL-IN-FchDoc-1 AT ROW 2.08 COL 75 COLON-ALIGNED WIDGET-ID 30
     FILL-IN-FchDoc-2 AT ROW 2.08 COL 95 COLON-ALIGNED WIDGET-ID 32
     BUTTON-1 AT ROW 2.35 COL 116 WIDGET-ID 2
     FILL-IN-Fecha-1 AT ROW 2.88 COL 75 COLON-ALIGNED WIDGET-ID 34
     FILL-IN-Fecha-2 AT ROW 2.88 COL 95 COLON-ALIGNED WIDGET-ID 36
     EDITOR-CodAlm AT ROW 3.42 COL 17 NO-LABEL WIDGET-ID 60
     BUTTON-17 AT ROW 3.42 COL 59 WIDGET-ID 58
     FILL-IN-Usuario AT ROW 3.69 COL 95 COLON-ALIGNED WIDGET-ID 24
     BUTTON-CONSULTAR AT ROW 4.23 COL 69 WIDGET-ID 4
     "Almacén Despacho:" VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 1.27 COL 3 WIDGET-ID 54
     "Almacén Solicitante:" VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 3.42 COL 3 WIDGET-ID 62
     RECT-26 AT ROW 1 COL 115 WIDGET-ID 64
     RECT-27 AT ROW 1 COL 2 WIDGET-ID 66
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 161.72 BY 26.27
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
         TITLE              = "APROBACION / RECHAZO DE PEDIDOS DE CD"
         HEIGHT             = 26.27
         WIDTH              = 161.72
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 191
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 191
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
ON END-ERROR OF W-Win /* APROBACION / RECHAZO DE PEDIDOS DE CD */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* APROBACION / RECHAZO DE PEDIDOS DE CD */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* APROBAR SELECCIONADOS */
DO:
  RUN Aprobar-Seleccionados IN h_b-aprob-abastec-cab.
  APPLY "CHOOSE":U TO BUTTON-CONSULTAR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-16
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-16 W-Win
ON CHOOSE OF BUTTON-16 IN FRAME F-Main /* Button 16 */
DO:
  ASSIGN EDITOR-AlmPed.
  /*RUN alm/d-almacen-despacho.w (INPUT-OUTPUT EDITOR-AlmPed).*/
  RUN logis/d-almacenes.w (INPUT-OUTPUT EDITOR-AlmPed).
  DISPLAY EDITOR-AlmPed WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-17
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-17 W-Win
ON CHOOSE OF BUTTON-17 IN FRAME F-Main /* Button 17 */
DO:
  ASSIGN EDITOR-CodAlm.
  RUN alm/d-almacen.w (INPUT-OUTPUT EDITOR-CodAlm).
  DISPLAY EDITOR-CodAlm WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* RECHAZAR SELECCIONADOS */
DO:
  MESSAGE 'Está seguro de RECHAZAR SELECCIONADOS?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  RUN Rechazar IN h_b-aprob-abastec-cab.
  APPLY "CHOOSE":U TO BUTTON-CONSULTAR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-CONSULTAR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-CONSULTAR W-Win
ON CHOOSE OF BUTTON-CONSULTAR IN FRAME F-Main /* CONSULTAR */
DO:
  ASSIGN  
      EDITOR-AlmPed EDITOR-CodAlm COMBO-BOX-Motivo 
      FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 
      FILL-IN-Fecha-1 FILL-IN-Fecha-2 FILL-IN-Usuario.
  RUN Carga-Temporal IN h_b-aprob-abastec-cab (INPUT FILL-IN-Usuario,
                                               INPUT COMBO-BOX-Motivo,
                                               INPUT FILL-IN-FchDoc-1,
                                               INPUT FILL-IN-FchDoc-2,
                                               INPUT FILL-IN-Fecha-1,
                                               INPUT FILL-IN-Fecha-2,
                                               INPUT EDITOR-AlmPed,
                                               INPUT EDITOR-CodAlm).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Motivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Motivo W-Win
ON VALUE-CHANGED OF COMBO-BOX-Motivo IN FRAME F-Main /* Motivo */
DO:
    ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchDoc-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchDoc-1 W-Win
ON LEAVE OF FILL-IN-FchDoc-1 IN FRAME F-Main /* Emitidos desde */
DO:
    ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchDoc-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchDoc-2 W-Win
ON LEAVE OF FILL-IN-FchDoc-2 IN FRAME F-Main /* Hasta */
DO:
    ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Fecha-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Fecha-1 W-Win
ON LEAVE OF FILL-IN-Fecha-1 IN FRAME F-Main /* Entrega */
DO:
    ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Fecha-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Fecha-2 W-Win
ON LEAVE OF FILL-IN-Fecha-2 IN FRAME F-Main /* Hasta */
DO:
    ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Usuario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Usuario W-Win
ON LEAVE OF FILL-IN-Usuario IN FRAME F-Main /* Usuario */
DO:
    ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
lh_handle = THIS-PROCEDURE.

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
             INPUT  'ALM/b-aprob-abastec-cab.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-aprob-abastec-cab ).
       RUN set-position IN h_b-aprob-abastec-cab ( 5.58 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-aprob-abastec-cab ( 21.27 , 142.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/v-aprob-abastec-v2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-aprob-abastec-v2 ).
       RUN set-position IN h_v-aprob-abastec-v2 ( 5.58 , 89.00 ) NO-ERROR.
       /* Size in UIB:  ( 4.04 , 55.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv96-2 ).
       RUN set-position IN h_p-updv96-2 ( 5.58 , 144.00 ) NO-ERROR.
       RUN set-size IN h_p-updv96-2 ( 4.04 , 11.00 ) NO-ERROR.

       /* Links to SmartViewer h_v-aprob-abastec-v2. */
       RUN add-link IN adm-broker-hdl ( h_b-aprob-abastec-cab , 'Record':U , h_v-aprob-abastec-v2 ).
       RUN add-link IN adm-broker-hdl ( h_p-updv96-2 , 'TableIO':U , h_v-aprob-abastec-v2 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-aprob-abastec-cab ,
             BUTTON-CONSULTAR:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-aprob-abastec-v2 ,
             h_b-aprob-abastec-cab , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv96-2 ,
             h_v-aprob-abastec-v2 , 'AFTER':U ).
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
  DISPLAY EDITOR-AlmPed COMBO-BOX-Motivo FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 
          FILL-IN-Fecha-1 FILL-IN-Fecha-2 EDITOR-CodAlm FILL-IN-Usuario 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-26 RECT-27 EDITOR-AlmPed BUTTON-16 COMBO-BOX-Motivo BUTTON-4 
         FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 BUTTON-1 FILL-IN-Fecha-1 
         FILL-IN-Fecha-2 EDITOR-CodAlm BUTTON-17 FILL-IN-Usuario 
         BUTTON-CONSULTAR 
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
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          FILL-IN-FchDoc-1 = ADD-INTERVAL(TODAY, -3, 'months')
          FILL-IN-FchDoc-2 = TODAY
          FILL-IN-Fecha-1 = ADD-INTERVAL(TODAY, -3, 'months')
          FILL-IN-Fecha-2 = ADD-INTERVAL(TODAY, 15, 'days').
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Handle W-Win 
PROCEDURE Procesa-Handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pParametro AS CHAR.

CASE pParametro:
    WHEN 'disable-header' THEN DO WITH FRAME {&FRAME-NAME}:
         RUN dispatch IN h_p-updv96-2 ('disable':U).
         ASSIGN
             BUTTON-1:SENSITIVE = NO
             BUTTON-16:SENSITIVE = NO
             BUTTON-17:SENSITIVE = NO
             BUTTON-CONSULTAR:SENSITIVE = NO
             BUTTON-4:SENSITIVE = NO
             EDITOR-AlmPed:SENSITIVE = NO
             EDITOR-CodAlm:SENSITIVE = NO
             COMBO-BOX-Motivo:SENSITIVE = NO
             FILL-IN-Usuario:SENSITIVE = NO.
    END.
    WHEN 'enable-header' THEN DO WITH FRAME {&FRAME-NAME}:
         RUN dispatch IN h_p-updv96-2 ('enable':U).
         ASSIGN
             BUTTON-1:SENSITIVE = YES
             BUTTON-16:SENSITIVE = YES
             BUTTON-17:SENSITIVE = YES
             BUTTON-CONSULTAR:SENSITIVE = YES
             BUTTON-4:SENSITIVE = YES
             EDITOR-AlmPed:SENSITIVE = YES
             EDITOR-CodAlm:SENSITIVE = YES
             COMBO-BOX-Motivo:SENSITIVE = YES
             FILL-IN-Usuario:SENSITIVE = YES.
    END.
    WHEN 'open-queries' THEN DO:
        RUN dispatch IN h_b-aprob-abastec-cab ('open-query':U).
    END.
END CASE.
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

