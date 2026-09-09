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
&Scoped-Define ENABLED-OBJECTS BUTTON-Aplicar COMBO-BOX-CodDoc ~
FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 FILL-IN-NomCli FILL-IN-NroPed ~
FILL-IN-NroHPK FILL-IN-FchEnt-1 FILL-IN-FchEnt-2 BUTTON-Limpiar BUTTON-15 ~
BUTTON-16 BUTTON-18 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodDoc FILL-IN-FchDoc-1 ~
FILL-IN-FchDoc-2 FILL-IN-NomCli FILL-IN-NroPed FILL-IN-NroHPK ~
FILL-IN-FchEnt-1 FILL-IN-FchEnt-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-hpk-consulta-cab AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-hpk-consulta-det AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-hpk-tracking AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-ped-tracking AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-phr-consulta-doc AS HANDLE NO-UNDO.
DEFINE VARIABLE h_tab95 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-15 
     IMAGE-UP FILE "img/print.ico":U
     LABEL "Button 15" 
     SIZE 7 BY 1.88 TOOLTIP "Impresión Selectiva".

DEFINE BUTTON BUTTON-16 
     IMAGE-UP FILE "img/print.ico":U
     LABEL "Button 16" 
     SIZE 7 BY 1.88 TOOLTIP "Impresión Total".

DEFINE BUTTON BUTTON-18 
     IMAGE-UP FILE "img/print.ico":U
     LABEL "Button 18" 
     SIZE 7 BY 1.88 TOOLTIP "Impresión Total (Almacén)".

DEFINE BUTTON BUTTON-Aplicar 
     LABEL "Aplicar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Limpiar 
     LABEL "Limpiar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX-CodDoc AS CHARACTER FORMAT "X(256)":U INITIAL "PHR" 
     LABEL "Ruta" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "PHR" 
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchEnt-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Entrega Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchEnt-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre Cliente" 
     VIEW-AS FILL-IN 
     SIZE 32 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroHPK AS CHARACTER FORMAT "X(15)":U 
     LABEL "# de HPK" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroPed AS CHARACTER FORMAT "X(15)":U 
     LABEL "# de O/D" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE TOGGLE-HR AS LOGICAL INITIAL yes 
     LABEL "Sin H/R" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-Aplicar AT ROW 1 COL 112 WIDGET-ID 6
     COMBO-BOX-CodDoc AT ROW 1.27 COL 9 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-FchDoc-1 AT ROW 1.27 COL 29 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-FchDoc-2 AT ROW 1.27 COL 49 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-NomCli AT ROW 1.27 COL 76 COLON-ALIGNED WIDGET-ID 20
     TOGGLE-HR AT ROW 2.08 COL 11 WIDGET-ID 4
     FILL-IN-NroPed AT ROW 2.08 COL 29 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-NroHPK AT ROW 2.08 COL 49 COLON-ALIGNED WIDGET-ID 18
     FILL-IN-FchEnt-1 AT ROW 2.08 COL 77 COLON-ALIGNED WIDGET-ID 26
     FILL-IN-FchEnt-2 AT ROW 2.08 COL 95 COLON-ALIGNED WIDGET-ID 28
     BUTTON-Limpiar AT ROW 2.08 COL 112 WIDGET-ID 8
     BUTTON-15 AT ROW 3.42 COL 119 WIDGET-ID 10
     BUTTON-16 AT ROW 5.58 COL 119 WIDGET-ID 22
     BUTTON-18 AT ROW 7.73 COL 119 WIDGET-ID 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 127.14 BY 24.96
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CONSULTA GENERAL DE PEDIDOS"
         HEIGHT             = 24.96
         WIDTH              = 127.14
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
/* SETTINGS FOR TOGGLE-BOX TOGGLE-HR IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       TOGGLE-HR:HIDDEN IN FRAME F-Main           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONSULTA GENERAL DE PEDIDOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONSULTA GENERAL DE PEDIDOS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-15
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-15 W-Win
ON CHOOSE OF BUTTON-15 IN FRAME F-Main /* Button 15 */
DO:
  MESSAGE 'Procedemos con la impresión?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN.
  DEF VAR pTipo AS INT NO-UNDO.
  RUN GET-ATTRIBUTE('CURRENT-PAGE').
  pTipo = INTEGER(RETURN-VALUE).
  RUN Imprimir IN h_b-hpk-consulta-cab ( INPUT pTipo /* INTEGER */).
  /*RUN dispatch IN h_b-hpk-consulta-cab ('imprime':U).*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-16
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-16 W-Win
ON CHOOSE OF BUTTON-16 IN FRAME F-Main /* Button 16 */
DO:
  MESSAGE 'Procedemos con la impresión?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN.
  DEF VAR pTipo AS INT NO-UNDO.
  RUN GET-ATTRIBUTE('CURRENT-PAGE').
  pTipo = INTEGER(RETURN-VALUE).
  RUN Imprimir-Todo IN h_b-hpk-consulta-cab ( INPUT pTipo /* INTEGER */).
  /*RUN dispatch IN h_b-hpk-consulta-cab ('imprime':U).*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-18
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-18 W-Win
ON CHOOSE OF BUTTON-18 IN FRAME F-Main /* Button 18 */
DO:
  MESSAGE 'Procedemos con la impresión?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN.
  DEF VAR pTipo AS INT NO-UNDO.
  RUN GET-ATTRIBUTE('CURRENT-PAGE').
  pTipo = INTEGER(RETURN-VALUE).
  RUN Imprimir-Todo-Almacen IN h_b-hpk-consulta-cab ( INPUT pTipo /* INTEGER */).
  /*RUN dispatch IN h_b-hpk-consulta-cab ('imprime':U).*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Aplicar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Aplicar W-Win
ON CHOOSE OF BUTTON-Aplicar IN FRAME F-Main /* Aplicar */
DO:
  ASSIGN COMBO-BOX-CodDoc TOGGLE-HR.
  ASSIGN FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 FILL-IN-NroPed FILL-IN-NroHPK FILL-IN-NomCli.
  ASSIGN FILL-IN-FchEnt-1 FILL-IN-FchEnt-2.

  IF FILL-IN-FchEnt-1 <> ? AND FILL-IN-FchEnt-2 = ? THEN DO:
    MESSAGE "Ingrese fecha de entrega HASTA"
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN NO-APPLY.
  END.
  IF FILL-IN-FchEnt-1 = ? AND FILL-IN-FchEnt-2 <> ? THEN DO:
        MESSAGE "Ingrese fecha de entrega DESDE"
        VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
  END.


  DEF VAR pFlgEst AS CHAR NO-UNDO.

  IF TOGGLE-HR = YES THEN pFlgEst = "P,PK,PF".
  ELSE pFlgEst = "P,C".
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Filtros IN h_b-hpk-consulta-cab
    ( INPUT pFlgEst /* CHARACTER */,
      INPUT FILL-IN-FchDoc-1,
      INPUT FILL-IN-FchDoc-2,
      INPUT FILL-IN-NroPed,
      INPUT FILL-IN-NroHPK,
      INPUT FILL-IN-NomCli,
      INPUT FILL-IN-FchEnt-1,
      INPUT FILL-IN-FchEnt-2
      ).
  RUN Carga-Filtros IN h_b-hpk-consulta-det
    ( INPUT FILL-IN-FchEnt-1 /* DATE */,
      INPUT FILL-IN-FchEnt-2 /* DATE */).
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Limpiar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Limpiar W-Win
ON CHOOSE OF BUTTON-Limpiar IN FRAME F-Main /* Limpiar */
DO:
  ASSIGN
      FILL-IN-FchDoc-1 = ?
      FILL-IN-FchDoc-2 = ?
      FILL-IN-FchEnt-1 = ?
      FILL-IN-FchEnt-2 = ?
      FILL-IN-NomCli = ''
      FILL-IN-NroHPK = ''
      FILL-IN-NroPed = ''.
  DISPLAY FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 FILL-IN-FchEnt-1 FILL-IN-FchEnt-2 
      FILL-IN-NomCli FILL-IN-NroHPK FILL-IN-NroPed WITH FRAME {&FRAME-NAME}.
  APPLY 'CHOOSE':U TO BUTTON-Aplicar.
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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-hpk-consulta-cab.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-hpk-consulta-cab ).
       RUN set-position IN h_b-hpk-consulta-cab ( 3.15 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-hpk-consulta-cab ( 6.69 , 116.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-free/objects/tab95.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'LABEL-FONT = 4,
                     LABEL-FGCOLOR = 0,
                     FOLDER-BGCOLOR = 8,
                     FOLDER-PARENT-BGCOLOR = 8,
                     LABELS = Picking y Checking|Documentación y Despacho':U ,
             OUTPUT h_tab95 ).
       RUN set-position IN h_tab95 ( 9.88 , 2.00 ) NO-ERROR.
       RUN set-size IN h_tab95 ( 15.88 , 126.00 ) NO-ERROR.

       /* Links to SmartTab95 h_tab95. */
       RUN add-link IN adm-broker-hdl ( h_tab95 , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-hpk-consulta-cab ,
             BUTTON-Limpiar:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_tab95 ,
             BUTTON-18:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-hpk-consulta-det.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-hpk-consulta-det ).
       RUN set-position IN h_b-hpk-consulta-det ( 10.96 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-hpk-consulta-det ( 6.69 , 122.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-hpk-tracking.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-hpk-tracking ).
       RUN set-position IN h_b-hpk-tracking ( 17.96 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-hpk-tracking ( 6.69 , 110.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-hpk-consulta-det. */
       RUN add-link IN adm-broker-hdl ( h_b-hpk-consulta-cab , 'Record':U , h_b-hpk-consulta-det ).

       /* Links to SmartBrowser h_b-hpk-tracking. */
       RUN add-link IN adm-broker-hdl ( h_b-hpk-consulta-det , 'Record':U , h_b-hpk-tracking ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-hpk-consulta-det ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-hpk-tracking ,
             h_b-hpk-consulta-det , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-phr-consulta-doc.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-phr-consulta-doc ).
       RUN set-position IN h_b-phr-consulta-doc ( 11.23 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-phr-consulta-doc ( 6.69 , 124.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-ped-tracking.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-ped-tracking ).
       RUN set-position IN h_b-ped-tracking ( 18.23 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-ped-tracking ( 6.69 , 66.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-phr-consulta-doc. */
       RUN add-link IN adm-broker-hdl ( h_b-hpk-consulta-cab , 'Record':U , h_b-phr-consulta-doc ).

       /* Links to SmartBrowser h_b-ped-tracking. */
       RUN add-link IN adm-broker-hdl ( h_b-phr-consulta-doc , 'Record':U , h_b-ped-tracking ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-phr-consulta-doc ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-ped-tracking ,
             h_b-phr-consulta-doc , 'AFTER':U ).
    END. /* Page 2 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

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
  DISPLAY COMBO-BOX-CodDoc FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 FILL-IN-NomCli 
          FILL-IN-NroPed FILL-IN-NroHPK FILL-IN-FchEnt-1 FILL-IN-FchEnt-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-Aplicar COMBO-BOX-CodDoc FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 
         FILL-IN-NomCli FILL-IN-NroPed FILL-IN-NroHPK FILL-IN-FchEnt-1 
         FILL-IN-FchEnt-2 BUTTON-Limpiar BUTTON-15 BUTTON-16 BUTTON-18 
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
  FILL-IN-FchDoc-1 = ADD-INTERVAL (TODAY, -15, 'days').
  FILL-IN-FchDoc-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

