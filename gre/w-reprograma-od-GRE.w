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
DEF INPUT PARAMETER pParam AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VARIABLE S-CODDOC AS CHARACTER.

s-CodDoc = pParam.
IF LOOKUP(s-CodDoc,'OD,OTR') = 0 THEN RETURN ERROR.
IF s-CodDoc = "OD" THEN s-CodDoc = "O/D".

DEF VAR LocalPage AS INTE INIT 0 NO-UNDO.       /* Indica la página activa */

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
&Scoped-Define ENABLED-OBJECTS BUTTON-Actualizar BUTTON-Reprogramar ~
BUTTON-Eliminar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-reprograma-od-cab AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-reprograma-od-cab-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-reprograma-od-cab-gre AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-reprograma-od-det AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-reprograma-od-det-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-reprograma-od-det-2-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-reprograma-od-det-3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-reprograma-od-det-4 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-reprograma-otr-det-2 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Actualizar 
     LABEL "REFRESCAR" 
     SIZE 20 BY 1.12.

DEFINE BUTTON BUTTON-Eliminar 
     LABEL "NO REPROGRAMAR" 
     SIZE 20 BY 1.12.

DEFINE BUTTON BUTTON-Reprogramar 
     LABEL "REPROGRAMAR" 
     SIZE 20 BY 1.12.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-Actualizar AT ROW 1.08 COL 3 WIDGET-ID 2
     BUTTON-Reprogramar AT ROW 1.08 COL 23 WIDGET-ID 4
     BUTTON-Eliminar AT ROW 1.08 COL 43 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.29 BY 25.88 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 3
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "REPROGRAMACION DE ORDENES DE DESPACHO"
         HEIGHT             = 25.88
         WIDTH              = 144.29
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
ON END-ERROR OF W-Win /* REPROGRAMACION DE ORDENES DE DESPACHO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPROGRAMACION DE ORDENES DE DESPACHO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Actualizar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Actualizar W-Win
ON CHOOSE OF BUTTON-Actualizar IN FRAME F-Main /* REFRESCAR */
DO:
  CASE LocalPage:
      WHEN 1 THEN DO:       /* GRE activa */
          CASE s-CodDoc:
              WHEN "O/D" THEN DO:
                  RUN dispatch IN h_b-reprograma-od-cab ('open-query':U).
              END.
          END CASE.
      END.
      WHEN 2 THEN DO:
          CASE s-CodDoc:
              /*WHEN "OTR" THEN RUN REPROGRAMAR-OTR IN h_b-reprograma-od-cab. Segun Max coordinado con su secretario HAROLD no va*/
          END CASE.
      END.
      WHEN 3 THEN DO:       /* GRE no activa */
          CASE s-CodDoc:
              WHEN "O/D" THEN DO:
                  RUN dispatch IN h_b-reprograma-od-cab-2 ('open-query':U).
              END.
          END CASE.
      END.
  END CASE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Eliminar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Eliminar W-Win
ON CHOOSE OF BUTTON-Eliminar IN FRAME F-Main /* NO REPROGRAMAR */
DO:
  MESSAGE 'Confirme la NO REPROGRAMACION' VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.

  DEF VAR pMensaje AS CHAR NO-UNDO.

  CASE LocalPage:
      WHEN 1 THEN DO:       /* GRE activa */
          CASE s-CodDoc:
              WHEN "O/D" THEN DO:
                  RUN Eliminar IN h_b-reprograma-od-cab (OUTPUT pMensaje).
                  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                      IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
                  END.
                  ELSE MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
                  RUN dispatch IN h_b-reprograma-od-cab ('open-query':U).
              END.
          END CASE.
      END.
      WHEN 2 THEN DO:
          CASE s-CodDoc:
          END CASE.
      END.
      WHEN 3 THEN DO:       /* GRE no activa */
          CASE s-CodDoc:
              WHEN "O/D" THEN DO:
                  RUN Eliminar IN h_b-reprograma-od-cab-2.
                  IF RETURN-VALUE = 'ADM-ERROR' 
                  THEN MESSAGE 'NO se pudo NO REPROGRAMAR' VIEW-AS ALERT-BOX ERROR.
                  ELSE MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
                  RUN dispatch IN h_b-reprograma-od-cab-2 ('open-query':U).
              END.
          END CASE.
      END.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Reprogramar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Reprogramar W-Win
ON CHOOSE OF BUTTON-Reprogramar IN FRAME F-Main /* REPROGRAMAR */
DO:

  CASE LocalPage:
      WHEN 1 THEN DO:       /* GRE activa */
          CASE s-CodDoc:
              WHEN "O/D" THEN DO:
                  RUN REPROGRAMAR IN h_b-reprograma-od-cab.
                  RUN dispatch IN h_b-reprograma-od-cab ('open-query':U).
              END.
          END CASE.
      END.
      WHEN 2 THEN DO:
          CASE s-CodDoc:
          END CASE.
      END.
      WHEN 3 THEN DO:       /* GRE no activa */
          CASE s-CodDoc:
              WHEN "O/D" THEN DO:
                  RUN REPROGRAMAR IN h_b-reprograma-od-cab-2.
                  RUN dispatch IN h_b-reprograma-od-cab-2 ('open-query':U).
              END.
          END CASE.
      END.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

CASE s-CodDoc:
    WHEN "O/D" THEN {&WINDOW-NAME}:TITLE = "REPROGRAMACION DE ORDENES DE DESPACHO".
    WHEN "OTR" THEN {&WINDOW-NAME}:TITLE = "REPROGRAMACION DE ORDENES DE TRANSFERENCIA".
END CASE.

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

    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'gre/b-reprograma-od-cab-GRE.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ,
                     SortBy-Case = NroDoc':U ,
             OUTPUT h_b-reprograma-od-cab ).
       RUN set-position IN h_b-reprograma-od-cab ( 2.35 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-reprograma-od-cab ( 6.69 , 140.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/dist/b-reprograma-od-det-2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-reprograma-od-det-2 ).
       RUN set-position IN h_b-reprograma-od-det-2 ( 9.35 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-reprograma-od-det-2 ( 6.69 , 95.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/dist/b-reprograma-od-det.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-reprograma-od-det ).
       RUN set-position IN h_b-reprograma-od-det ( 16.35 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-reprograma-od-det ( 9.96 , 108.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-reprograma-od-det-2. */
       RUN add-link IN adm-broker-hdl ( h_b-reprograma-od-cab , 'Record':U , h_b-reprograma-od-det-2 ).

       /* Links to SmartBrowser h_b-reprograma-od-det. */
       RUN add-link IN adm-broker-hdl ( h_b-reprograma-od-cab , 'Record':U , h_b-reprograma-od-det ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-reprograma-od-cab ,
             BUTTON-Eliminar:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-reprograma-od-det-2 ,
             h_b-reprograma-od-cab , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-reprograma-od-det ,
             h_b-reprograma-od-det-2 , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/gre/b-reprograma-od-cab-gre.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ,
                     SortBy-Case = NroDoc':U ,
             OUTPUT h_b-reprograma-od-cab-gre ).
       RUN set-position IN h_b-reprograma-od-cab-gre ( 2.35 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-reprograma-od-cab-gre ( 6.69 , 140.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/dist/b-reprograma-otr-det-2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-reprograma-otr-det-2 ).
       RUN set-position IN h_b-reprograma-otr-det-2 ( 9.35 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-reprograma-otr-det-2 ( 6.69 , 66.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/dist/b-reprograma-od-det.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-reprograma-od-det-3 ).
       RUN set-position IN h_b-reprograma-od-det-3 ( 16.35 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-reprograma-od-det-3 ( 9.96 , 108.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-reprograma-otr-det-2. */
       RUN add-link IN adm-broker-hdl ( h_b-reprograma-od-cab-gre , 'Record':U , h_b-reprograma-otr-det-2 ).

       /* Links to SmartBrowser h_b-reprograma-od-det-3. */
       RUN add-link IN adm-broker-hdl ( h_b-reprograma-od-cab-gre , 'Record':U , h_b-reprograma-od-det-3 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-reprograma-od-cab-gre ,
             BUTTON-Eliminar:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-reprograma-otr-det-2 ,
             h_b-reprograma-od-cab-gre , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-reprograma-od-det-3 ,
             h_b-reprograma-otr-det-2 , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/dist/b-reprograma-od-cab.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ,
                     SortBy-Case = NroDoc':U ,
             OUTPUT h_b-reprograma-od-cab-2 ).
       RUN set-position IN h_b-reprograma-od-cab-2 ( 2.35 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-reprograma-od-cab-2 ( 6.69 , 140.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/dist/b-reprograma-od-det-2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-reprograma-od-det-2-2 ).
       RUN set-position IN h_b-reprograma-od-det-2-2 ( 9.35 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-reprograma-od-det-2-2 ( 6.69 , 95.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/dist/b-reprograma-od-det.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-reprograma-od-det-4 ).
       RUN set-position IN h_b-reprograma-od-det-4 ( 16.35 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-reprograma-od-det-4 ( 9.96 , 108.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-reprograma-od-det-2-2. */
       RUN add-link IN adm-broker-hdl ( h_b-reprograma-od-cab-2 , 'Record':U , h_b-reprograma-od-det-2-2 ).

       /* Links to SmartBrowser h_b-reprograma-od-det-4. */
       RUN add-link IN adm-broker-hdl ( h_b-reprograma-od-cab-2 , 'Record':U , h_b-reprograma-od-det-4 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-reprograma-od-cab-2 ,
             BUTTON-Eliminar:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-reprograma-od-det-2-2 ,
             h_b-reprograma-od-cab-2 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-reprograma-od-det-4 ,
             h_b-reprograma-od-det-2-2 , 'AFTER':U ).
    END. /* Page 3 */

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
  ENABLE BUTTON-Actualizar BUTTON-Reprogramar BUTTON-Eliminar 
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
  CASE s-CodDoc:
      WHEN "O/D" THEN DO:
          RUN select-page("1").
          LocalPage = 1.
      END.
      WHEN "OTR" THEN DO:
          RUN select-page("2").
          LocalPage = 2.
      END.
  END CASE.
  /* 27/11/2023: GRE activa o no */
  DEF VAR lGREONLINE AS LOG INIT NO NO-UNDO.

  RUN gn/gre-online.r(OUTPUT lGREONLINE).
  IF lGREONLINE = NO THEN DO:
      RUN select-page("3").
      LocalPage = 3.
  END.

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

