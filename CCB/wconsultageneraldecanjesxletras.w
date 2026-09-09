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

DEFINE NEW SHARED VARIABLE S-CODDOC AS CHAR INIT "CJE".

DEFINE NEW SHARED TEMP-TABLE DOCU LIKE CcbCDocu.
DEFINE NEW SHARED TEMP-TABLE MVTO LIKE CcbDMvto.

DEF NEW SHARED VAR s-nroser AS INT.
DEFINE NEW SHARED VARIABLE S-CODMON   AS INTEGER.
DEFINE NEW SHARED VARIABLE S-TPOCMB   AS DECIMAL.
DEFINE NEW SHARED VAR lh_handle AS HANDLE.
DEFINE NEW SHARED VARIABLE S-CODCLI   AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-aderec AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-divisiones AS HANDLE NO-UNDO.
DEFINE VARIABLE h_bcanjesxletras AS HANDLE NO-UNDO.
DEFINE VARIABLE h_bcanjexletra-01 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_bcanjexletra-01-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_bcanjexletra-02 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_bcanjexletra-02-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_bcanjexletra-02-3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-print-canje AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-print-refinanciacion AS HANDLE NO-UNDO.
DEFINE VARIABLE h_tab95 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vcanjexletra AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vletraadelantada AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vrefinanciacionletras AS HANDLE NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 138.43 BY 26.65 WIDGET-ID 100.


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
         TITLE              = "CONSULTA GENERAL DE CANJE POR LETRAS"
         HEIGHT             = 26.65
         WIDTH              = 138.43
         MAX-HEIGHT         = 26.65
         MAX-WIDTH          = 143.72
         VIRTUAL-HEIGHT     = 26.65
         VIRTUAL-WIDTH      = 143.72
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
ON END-ERROR OF W-Win /* CONSULTA GENERAL DE CANJE POR LETRAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONSULTA GENERAL DE CANJE POR LETRAS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
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
             INPUT  'src/adm-free/objects/tab95.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'LABEL-FONT = 4,
                     LABEL-FGCOLOR = 0,
                     FOLDER-BGCOLOR = 8,
                     FOLDER-PARENT-BGCOLOR = 8,
                     LABELS = Canje por Letras|Letras Adelantadas|Refinanciación':U ,
             OUTPUT h_tab95 ).
       RUN set-position IN h_tab95 ( 1.00 , 1.00 ) NO-ERROR.
       RUN set-size IN h_tab95 ( 26.54 , 138.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/gn/b-divisiones.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-divisiones ).
       RUN set-position IN h_b-divisiones ( 2.15 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-divisiones ( 5.38 , 50.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'CCB/bcanjesxletras.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bcanjesxletras ).
       RUN set-position IN h_bcanjesxletras ( 2.15 , 70.00 ) NO-ERROR.
       RUN set-size IN h_bcanjesxletras ( 6.92 , 67.29 ) NO-ERROR.

       /* Links to SmartTab95 h_tab95. */
       RUN add-link IN adm-broker-hdl ( h_tab95 , 'Page':U , THIS-PROCEDURE ).

       /* Links to SmartBrowser h_bcanjesxletras. */
       RUN add-link IN adm-broker-hdl ( h_b-divisiones , 'Record':U , h_bcanjesxletras ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-divisiones ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_bcanjesxletras ,
             h_b-divisiones , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/vcanjexletra.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_vcanjexletra ).
       RUN set-position IN h_vcanjexletra ( 9.27 , 3.00 ) NO-ERROR.
       /* Size in UIB:  ( 3.31 , 102.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/f-print-canje.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-print-canje ).
       RUN set-position IN h_f-print-canje ( 9.65 , 107.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.92 , 8.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/bcanjexletra-01.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bcanjexletra-01 ).
       RUN set-position IN h_bcanjexletra-01 ( 12.73 , 20.00 ) NO-ERROR.
       RUN set-size IN h_bcanjexletra-01 ( 6.38 , 85.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/bcanjexletra-02.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bcanjexletra-02 ).
       RUN set-position IN h_bcanjexletra-02 ( 19.27 , 43.00 ) NO-ERROR.
       RUN set-size IN h_bcanjexletra-02 ( 7.92 , 62.00 ) NO-ERROR.

       /* Links to SmartViewer h_vcanjexletra. */
       RUN add-link IN adm-broker-hdl ( h_bcanjesxletras , 'Record':U , h_vcanjexletra ).

       /* Links to SmartBrowser h_bcanjexletra-01. */
       RUN add-link IN adm-broker-hdl ( h_bcanjesxletras , 'Record':U , h_bcanjexletra-01 ).

       /* Links to SmartBrowser h_bcanjexletra-02. */
       RUN add-link IN adm-broker-hdl ( h_bcanjesxletras , 'Record':U , h_bcanjexletra-02 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_vcanjexletra ,
             h_bcanjesxletras , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-print-canje ,
             h_vcanjexletra , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_bcanjexletra-01 ,
             h_f-print-canje , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_bcanjexletra-02 ,
             h_bcanjexletra-01 , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/vletraadelantada.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_vletraadelantada ).
       RUN set-position IN h_vletraadelantada ( 9.27 , 3.00 ) NO-ERROR.
       /* Size in UIB:  ( 4.04 , 102.72 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/bcanjexletra-02.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bcanjexletra-02-2 ).
       RUN set-position IN h_bcanjexletra-02-2 ( 13.65 , 43.00 ) NO-ERROR.
       RUN set-size IN h_bcanjexletra-02-2 ( 7.92 , 62.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/b-aderec.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-aderec ).
       RUN set-position IN h_b-aderec ( 21.73 , 46.00 ) NO-ERROR.
       RUN set-size IN h_b-aderec ( 4.04 , 59.00 ) NO-ERROR.

       /* Links to SmartViewer h_vletraadelantada. */
       RUN add-link IN adm-broker-hdl ( h_bcanjesxletras , 'Record':U , h_vletraadelantada ).

       /* Links to SmartBrowser h_bcanjexletra-02-2. */
       RUN add-link IN adm-broker-hdl ( h_bcanjesxletras , 'Record':U , h_bcanjexletra-02-2 ).

       /* Links to SmartBrowser h_b-aderec. */
       RUN add-link IN adm-broker-hdl ( h_bcanjesxletras , 'Record':U , h_b-aderec ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_vletraadelantada ,
             h_bcanjesxletras , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_bcanjexletra-02-2 ,
             h_vletraadelantada , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-aderec ,
             h_bcanjexletra-02-2 , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/vrefinanciacionletras.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_vrefinanciacionletras ).
       RUN set-position IN h_vrefinanciacionletras ( 9.27 , 3.00 ) NO-ERROR.
       /* Size in UIB:  ( 3.31 , 103.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/f-print-refinanciacion.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-print-refinanciacion ).
       RUN set-position IN h_f-print-refinanciacion ( 9.85 , 107.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.92 , 8.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/bcanjexletra-01.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bcanjexletra-01-2 ).
       RUN set-position IN h_bcanjexletra-01-2 ( 12.73 , 20.00 ) NO-ERROR.
       RUN set-size IN h_bcanjexletra-01-2 ( 6.38 , 85.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/bcanjexletra-02.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bcanjexletra-02-3 ).
       RUN set-position IN h_bcanjexletra-02-3 ( 19.27 , 43.00 ) NO-ERROR.
       RUN set-size IN h_bcanjexletra-02-3 ( 7.92 , 62.00 ) NO-ERROR.

       /* Links to SmartViewer h_vrefinanciacionletras. */
       RUN add-link IN adm-broker-hdl ( h_bcanjesxletras , 'Record':U , h_vrefinanciacionletras ).

       /* Links to SmartBrowser h_bcanjexletra-01-2. */
       RUN add-link IN adm-broker-hdl ( h_bcanjesxletras , 'Record':U , h_bcanjexletra-01-2 ).

       /* Links to SmartBrowser h_bcanjexletra-02-3. */
       RUN add-link IN adm-broker-hdl ( h_bcanjesxletras , 'Record':U , h_bcanjexletra-02-3 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_vrefinanciacionletras ,
             h_bcanjesxletras , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-print-refinanciacion ,
             h_vrefinanciacionletras , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_bcanjexletra-01-2 ,
             h_f-print-refinanciacion , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_bcanjexletra-02-3 ,
             h_bcanjexletra-01-2 , 'AFTER':U ).
    END. /* Page 3 */

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
  VIEW FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-change-page W-Win 
PROCEDURE local-change-page :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN GET-ATTRIBUTE('current-page').

  CASE RETURN-VALUE:
      WHEN '1' THEN DO:
          s-coddoc = "CJE".
          RUN dispatch IN h_bcanjesxletras ('open-query':U).
      END.
      WHEN '2' THEN DO:
          s-coddoc = "CLA".
          RUN dispatch IN h_bcanjesxletras ('open-query':U).
      END.
      WHEN '3' THEN DO:
          s-coddoc = "REF".
          RUN dispatch IN h_bcanjesxletras ('open-query':U).
      END.
  END CASE.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'change-page':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Handle W-Win 
PROCEDURE Procesa-Handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pParametro AS CHAR.

CASE pParametro:
    WHEN 'Print-Canje' THEN RUN dispatch IN h_vcanjexletra ('imprime':U).
    WHEN 'Print-Canje-Adelantado' THEN RUN dispatch IN h_vletraadelantada ('imprime':U).
    WHEN 'Print-Refinanciacion' THEN RUN dispatch IN h_vrefinanciacionletras ('imprime':U).
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

