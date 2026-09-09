&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE DOCU LIKE CcbCDocu.



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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

DEF NEW SHARED VAR s-coddoc AS CHAR INIT 'PLT'.
DEF NEW SHARED VAR s-nroser AS INT.
DEF NEW SHARED VAR lh_handle AS HANDLE.

FIND FIRST FacCorre WHERE FacCorre.CodCia = s-codcia
    AND FacCorre.CodDiv = s-coddiv
    AND FacCorre.CodDoc = s-coddoc
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE "NO está definido un correlativo para el documento:" s-coddoc
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
s-NroSer = FacCorre.NroSer.

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
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 BUTTON-1 BUTTON-6 BUTTON-5 ~
BtnDone COMBO-NroSer 
&Scoped-Define DISPLAYED-OBJECTS COMBO-NroSer 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-preletraadelantada AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv95 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_qcanjexletra AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-genera-preletra AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-preletraadelantada AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     LABEL "Salir" 
     SIZE 11 BY 1.12
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "Modificar" 
     SIZE 11 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "Cancelar" 
     SIZE 11 BY 1.12.

DEFINE BUTTON BUTTON-5 
     LABEL "Imprimir" 
     SIZE 11 BY 1.12.

DEFINE BUTTON BUTTON-6 
     LABEL "Eliminar" 
     SIZE 11 BY 1.12.

DEFINE BUTTON BUTTON-8 
     LABEL "REHACER LETRAS" 
     SIZE 20 BY 1.12.

DEFINE VARIABLE COMBO-NroSer AS CHARACTER FORMAT "X(3)":U INITIAL "0" 
     LABEL "Serie" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 6.72 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 57 BY 1.62
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 5.65.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1.27 COL 3 WIDGET-ID 8
     BUTTON-2 AT ROW 1.27 COL 14 WIDGET-ID 10
     BUTTON-6 AT ROW 1.27 COL 25 WIDGET-ID 22
     BUTTON-5 AT ROW 1.27 COL 36 WIDGET-ID 16
     BtnDone AT ROW 1.27 COL 47 WIDGET-ID 14
     COMBO-NroSer AT ROW 1.54 COL 59.71 WIDGET-ID 6
     BUTTON-8 AT ROW 13.65 COL 54 WIDGET-ID 24
     RECT-1 AT ROW 1 COL 2 WIDGET-ID 18
     RECT-2 AT ROW 2.62 COL 2 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 84.43 BY 21.81
         FONT 4
         DEFAULT-BUTTON BtnDone WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: DOCU T "NEW SHARED" ? INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "PRE-LETRAS ADELANTADAS CAMPAÑA"
         HEIGHT             = 21.81
         WIDTH              = 84.43
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
/* SETTINGS FOR BUTTON BUTTON-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON BUTTON-8 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-8:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR COMBO-BOX COMBO-NroSer IN FRAME F-Main
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* PRE-LETRAS ADELANTADAS CAMPAÑA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* PRE-LETRAS ADELANTADAS CAMPAÑA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Salir */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Modificar */
DO:
  CASE TRUE:
      WHEN SELF:LABEL = 'Modificar' THEN DO:
          RUN valida-update IN h_v-preletraadelantada.
          IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
          RUN Carga-Temporal IN h_v-preletraadelantada.
          RUN select-page('2').
          RUN dispatch IN h_t-genera-preletra ('open-query':U).
          RUN dispatch IN h_qcanjexletra ('disable':U).
          RUN adm-disable IN h_p-navico.
          SELF:LABEL = 'Grabar'.
          BUTTON-2:SENSITIVE = YES.
          BUTTON-5:SENSITIVE = NO.
          COMBO-NroSer:SENSITIVE = NO.
          BUTTON-6:SENSITIVE = NO.
          BUTTON-8:SENSITIVE = YES.
          BUTTON-8:VISIBLE    = YES.
      END.
      WHEN SELF:LABEL = 'Grabar' THEN DO:
          RUN valida IN h_v-preletraadelantada.
          IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
          RUN Genera-Detalle IN h_v-preletraadelantada.
          RUN select-page('1').
          RUN dispatch IN h_b-preletraadelantada ('open-query':U).
          RUN dispatch IN h_qcanjexletra ('enable':U).
          RUN adm-enable IN h_p-navico.
          SELF:LABEL = 'Modificar'.
          BUTTON-2:SENSITIVE = NO.
          BUTTON-5:SENSITIVE = YES.
          BUTTON-6:SENSITIVE = YES.
          COMBO-NroSer:SENSITIVE = YES.
          BUTTON-8:SENSITIVE = NO.
          BUTTON-8:VISIBLE    = NO.
      END.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Cancelar */
DO:
    RUN select-page('1').
    BUTTON-1:LABEL = 'Modificar'.
    BUTTON-2:SENSITIVE = NO.
    BUTTON-5:SENSITIVE = YES.
    BUTTON-6:SENSITIVE = YES.
    COMBO-NroSer:SENSITIVE = YES.
    BUTTON-8:SENSITIVE = NO.
    BUTTON-8:VISIBLE    = NO.
    RUN adm-enable IN h_qcanjexletra.
    RUN adm-enable IN h_p-navico.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Imprimir */
DO:
   RUN dispatch IN h_v-preletraadelantada ('imprime':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Eliminar */
DO:
  MESSAGE '¿Está seguro?' VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  RUN dispatch IN h_v-preletraadelantada ('delete-record':U).
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 W-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* REHACER LETRAS */
DO:
  RUN Nuevas-Letras IN h_t-genera-preletra.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer W-Win
ON VALUE-CHANGED OF COMBO-NroSer IN FRAME F-Main /* Serie */
DO:
    ASSIGN COMBO-NroSer.
    s-NroSer = INTEGER(COMBO-NroSer).
    RUN dispatch IN h_qcanjexletra ('open-query':U).
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
             INPUT  'aplic/ccb/v-preletraadelantada.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-preletraadelantada ).
       RUN set-position IN h_v-preletraadelantada ( 2.88 , 4.00 ) NO-ERROR.
       /* Size in UIB:  ( 5.12 , 68.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Right':U ,
             OUTPUT h_p-navico ).
       RUN set-position IN h_p-navico ( 2.88 , 76.00 ) NO-ERROR.
       RUN set-size IN h_p-navico ( 4.31 , 7.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/qcanjexletra.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'SortBy-Case = NroDoc':U ,
             OUTPUT h_qcanjexletra ).
       RUN set-position IN h_qcanjexletra ( 1.27 , 72.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.35 , 12.00 ) */

       /* Links to SmartViewer h_v-preletraadelantada. */
       RUN add-link IN adm-broker-hdl ( h_qcanjexletra , 'Record':U , h_v-preletraadelantada ).

       /* Links to SmartQuery h_qcanjexletra. */
       RUN add-link IN adm-broker-hdl ( h_p-navico , 'Navigation':U , h_qcanjexletra ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-preletraadelantada ,
             COMBO-NroSer:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico ,
             h_v-preletraadelantada , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_qcanjexletra ,
             BUTTON-8:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/b-preletraadelantada.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-preletraadelantada ).
       RUN set-position IN h_b-preletraadelantada ( 8.54 , 11.00 ) NO-ERROR.
       RUN set-size IN h_b-preletraadelantada ( 14.00 , 40.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-preletraadelantada. */
       RUN add-link IN adm-broker-hdl ( h_qcanjexletra , 'Record':U , h_b-preletraadelantada ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-preletraadelantada ,
             h_p-navico , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/t-genera-preletra.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-genera-preletra ).
       RUN set-position IN h_t-genera-preletra ( 8.54 , 11.00 ) NO-ERROR.
       RUN set-size IN h_t-genera-preletra ( 14.00 , 42.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv95.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv95 ).
       RUN set-position IN h_p-updv95 ( 9.62 , 54.00 ) NO-ERROR.
       RUN set-size IN h_p-updv95 ( 4.04 , 10.00 ) NO-ERROR.

       /* Links to SmartBrowser h_t-genera-preletra. */
       RUN add-link IN adm-broker-hdl ( h_p-updv95 , 'TableIO':U , h_t-genera-preletra ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-genera-preletra ,
             h_p-navico , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv95 ,
             h_t-genera-preletra , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE DOCU.
FOR EACH Ccbdmvto NO-LOCK WHERE CcbCMvto.CodCia = Ccbcmvto.codcia AND
    CcbCMvto.CodDiv = Ccbcmvto.coddiv AND
    CcbCMvto.CodDoc = Ccbcmvto.coddoc AND
    CcbCMvto.NroDoc = Ccbcmvto.nrodoc:
    CREATE DOCU.
    ASSIGN
        DOCU.coddoc = Ccbdmvto.codref
        DOCU.nrodoc = Ccbdmvto.nroref
        DOCU.fchvto = Ccbdmvto.fchvto
        DOCU.imptot = Ccbdmvto.imptot
        DOCU.Libre_c01 = ENTRY(1, Ccbdmvto.codcta,'|')
        DOCU.Libre_c02 = ENTRY(2, Ccbdmvto.codcta,'|').
END.

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
  DISPLAY COMBO-NroSer 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 BUTTON-1 BUTTON-6 BUTTON-5 BtnDone COMBO-NroSer 
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
  DEFINE VARIABLE cListItems AS CHARACTER NO-UNDO.

  FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.
  FOR EACH FacCorre NO-LOCK WHERE 
      FacCorre.CodCia = s-CodCia AND
      FacCorre.CodDoc = s-CodDoc AND
      FacCorre.CodDiv = s-CodDiv AND
      FacCorre.FlgEst = YES:
      IF cListItems = "" THEN cListItems = STRING(FacCorre.NroSer,"999").
      ELSE cListItems = cListItems + "," + STRING(FacCorre.NroSer,"999").
  END.
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-NroSer:LIST-ITEMS = cListItems.
      COMBO-NroSer = ENTRY(1,COMBO-NroSer:LIST-ITEMS).
      s-NroSer = INTEGER(COMBO-NroSer).
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-handle W-Win 
PROCEDURE Procesa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pParam AS CHAR.

CASE pParam:
    WHEN 'disable-button' THEN BUTTON-8:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    WHEN 'enable-button'  THEN BUTTON-8:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
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

