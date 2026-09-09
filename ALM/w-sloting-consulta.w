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
DEF SHARED VAR s-nomcia AS CHAR.

/* Local Variable Definitions ---                                       */

DEF NEW SHARED VAR lh_handle AS HANDLE.

DEF VAR s-Task-No AS INT NO-UNDO.

DEF VAR pHoraInicio AS DATETIME NO-UNDO.
DEFINE VAR imprimirDetallado AS LOG.
DEFINE VAR imprimirDetalladoExcel AS LOG INIT NO.

DEFINE VAR fill-in-desde AS DATE. 
DEFINE VAR fill-in-hasta AS DATE.
DEFINE VAR toggle-rango AS LOG.

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
DEFINE VARIABLE h_b-sloting-dev-cab AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-sloting-oc-cab AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-sloting-oc-det AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-sloting-oc-det-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-sloting-oc-det-3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-sloting-otr-cab AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-actualiza-sloting AS HANDLE NO-UNDO.
DEFINE VARIABLE h_tab95 AS HANDLE NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 151 BY 25.85 WIDGET-ID 100.


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
         TITLE              = "CONSULTA"
         HEIGHT             = 25.85
         WIDTH              = 151
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 151
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 151
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
ON END-ERROR OF W-Win /* CONSULTA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONSULTA */
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
                     LABELS = O/C|OTR|DEV.CLIENTE':U ,
             OUTPUT h_tab95 ).
       RUN set-position IN h_tab95 ( 1.00 , 1.00 ) NO-ERROR.
       RUN set-size IN h_tab95 ( 25.85 , 150.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/f-actualiza-sloting.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-actualiza-sloting ).
       RUN set-position IN h_f-actualiza-sloting ( 2.15 , 129.57 ) NO-ERROR.
       /* Size in UIB:  ( 6.50 , 20.00 ) */

       /* Links to SmartTab95 h_tab95. */
       RUN add-link IN adm-broker-hdl ( h_tab95 , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-actualiza-sloting ,
             h_tab95 , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/b-sloting-oc-cab.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-sloting-oc-cab ).
       RUN set-position IN h_b-sloting-oc-cab ( 2.08 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-sloting-oc-cab ( 6.69 , 127.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/b-sloting-oc-det.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-sloting-oc-det ).
       RUN set-position IN h_b-sloting-oc-det ( 8.81 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-sloting-oc-det ( 16.15 , 142.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-sloting-oc-det. */
       RUN add-link IN adm-broker-hdl ( h_b-sloting-oc-cab , 'Record':U , h_b-sloting-oc-det ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-sloting-oc-cab ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-sloting-oc-det ,
             h_f-actualiza-sloting , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/b-sloting-otr-cab.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-sloting-otr-cab ).
       RUN set-position IN h_b-sloting-otr-cab ( 2.08 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-sloting-otr-cab ( 6.69 , 126.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/b-sloting-oc-det.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-sloting-oc-det-2 ).
       RUN set-position IN h_b-sloting-oc-det-2 ( 8.81 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-sloting-oc-det-2 ( 16.15 , 142.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-sloting-oc-det-2. */
       RUN add-link IN adm-broker-hdl ( h_b-sloting-otr-cab , 'Record':U , h_b-sloting-oc-det-2 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-sloting-otr-cab ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-sloting-oc-det-2 ,
             h_f-actualiza-sloting , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/b-sloting-dev-clie.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-sloting-dev-cab ).
       RUN set-position IN h_b-sloting-dev-cab ( 2.35 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-sloting-dev-cab ( 6.69 , 127.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/b-sloting-oc-det.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-sloting-oc-det-3 ).
       RUN set-position IN h_b-sloting-oc-det-3 ( 9.31 , 2.29 ) NO-ERROR.
       RUN set-size IN h_b-sloting-oc-det-3 ( 16.15 , 142.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-sloting-oc-det-3. */
       RUN add-link IN adm-broker-hdl ( h_b-sloting-dev-cab , 'Record':U , h_b-sloting-oc-det-3 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-sloting-dev-cab ,
             h_f-actualiza-sloting , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-sloting-oc-det-3 ,
             h_b-sloting-dev-cab , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

s-Task-No = 0.

REPEAT:
    s-task-no = RANDOM(1,999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK) THEN DO:
        CREATE w-report.
        w-report.task-no = s-task-no.
        LEAVE.
    END.
END.

/* Pantalla activa */
RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
IF RETURN-VALUE = '1' AND h_b-sloting-otr-cab = ? THEN DO:
    RUN select-page ('3').
    RUN select-page ('2').
    RUN select-page ('1').
END.

DEF VAR x-Items AS INT INIT 1 NO-UNDO.
/* Cargamos información de la O/D y OTR */
pHoraInicio = NOW.
IF h_b-sloting-oc-cab <> ? THEN RUN Carga-Impresion IN h_b-sloting-oc-cab ( INPUT s-Task-No, 
                                                                            INPUT pHoraInicio, 
                                                                            INPUT imprimirDetallado,
                                                                            INPUT fill-in-desde, 
                                                                            INPUT fill-in-hasta, 
                                                                            INPUT toggle-rango ).
IF h_b-sloting-otr-cab <> ? THEN RUN Carga-Impresion IN h_b-sloting-otr-cab ( INPUT s-Task-No, 
                                                                              INPUT pHoraInicio, 
                                                                              INPUT imprimirDetallado,
                                                                              INPUT fill-in-desde, 
                                                                              INPUT fill-in-hasta, 
                                                                              INPUT toggle-rango ).
IF h_b-sloting-dev-cab <> ? THEN RUN Carga-Impresion IN h_b-sloting-dev-cab ( INPUT s-Task-No, 
                                                                              INPUT pHoraInicio, 
                                                                              INPUT imprimirDetallado,
                                                                              INPUT fill-in-desde, 
                                                                              INPUT fill-in-hasta, 
                                                                              INPUT toggle-rango ).
/* Limpiamos el registro vacío */
FOR EACH w-report WHERE w-report.task-no = s-task-no AND (TRUE <> (w-report.Campo-C[1] > '')):
    DELETE w-report.
END.

END PROCEDURE.

.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

imprimirDetallado = NO.

SESSION:SET-WAIT-STATE('GENERAL').
RUN Carga-Temporal.
SESSION:SET-WAIT-STATE('').

GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "alm/rbalm.prl".
RB-REPORT-NAME = "Consulta Sloting Pendientes".
RB-INCLUDE-RECORDS = "O".
RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia + 
    "~ns-inicio = " + STRING(pHoraInicio, '99/99/9999 HH:MM').
RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                   RB-REPORT-NAME,
                   RB-INCLUDE-RECORDS,
                   RB-FILTER,
                   RB-OTHER-PARAMETERS).
FOR EACH w-report EXCLUSIVE-LOCK WHERE w-report.task-no = s-task-no:
    DELETE w-report.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pinta-Browse W-Win 
PROCEDURE Pinta-Browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN GET-ATTRIBUTE('current-page').

CASE RETURN-VALUE:
    WHEN "1" THEN RUN dispatch IN h_b-sloting-oc-cab ('open-query':U).
    WHEN "2" THEN RUN dispatch IN h_b-sloting-otr-cab ('open-query':U).
    WHEN "3" THEN RUN dispatch IN h_b-sloting-dev-cab ('open-query':U).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ubicaciones W-Win 
PROCEDURE ubicaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pfill-in-desde AS DATE. 
DEFINE INPUT PARAMETER pfill-in-hasta AS DATE.
DEFINE INPUT PARAMETER ptoggle-rango AS LOG.

fill-in-desde = pfill-in-desde. 
fill-in-hasta = pfill-in-hasta.
toggle-rango = ptoggle-rango.

IF toggle-rango = YES THEN DO:
    IF fill-in-desde = ? OR fill-in-hasta = ? THEN DO:
        MESSAGE "Rango de fechas estan incorrectas" VIEW-AS ALERT-BOX INFORMATION.
        RETURN "ADM-ERROR".
    END.
    IF fill-in-desde > fill-in-hasta THEN DO:
        MESSAGE "Rango de fechas erradas" VIEW-AS ALERT-BOX INFORMATION.
        RETURN "ADM-ERROR".
    END.
END.

DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

imprimirDetallado = YES.

SESSION:SET-WAIT-STATE('GENERAL').
RUN Carga-Temporal.
SESSION:SET-WAIT-STATE('').

GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "alm/rbalm.prl".
RB-REPORT-NAME = "Sloting Pendientes ubicaciones".
RB-INCLUDE-RECORDS = "O".
RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia + 
    "~ns-inicio = " + STRING(pHoraInicio, '99/99/9999 HH:MM').
RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                   RB-REPORT-NAME,
                   RB-INCLUDE-RECORDS,
                   RB-FILTER,
                   RB-OTHER-PARAMETERS).
FOR EACH w-report EXCLUSIVE-LOCK WHERE w-report.task-no = s-task-no:
    DELETE w-report.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ubicaciones-excel W-Win 
PROCEDURE ubicaciones-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pfill-in-desde AS DATE. 
DEFINE INPUT PARAMETER pfill-in-hasta AS DATE.
DEFINE INPUT PARAMETER ptoggle-rango AS LOG.

fill-in-desde = pfill-in-desde. 
fill-in-hasta = pfill-in-hasta.
toggle-rango = ptoggle-rango.

IF toggle-rango = YES THEN DO:
    IF fill-in-desde = ? OR fill-in-hasta = ? THEN DO:
        MESSAGE "Rango de fechas estan incorrectas" VIEW-AS ALERT-BOX INFORMATION.
        RETURN "ADM-ERROR".
    END.
    IF fill-in-desde > fill-in-hasta THEN DO:
        MESSAGE "Rango de fechas erradas" VIEW-AS ALERT-BOX INFORMATION.
        RETURN "ADM-ERROR".
    END.
END.

imprimirDetallado = YES.

SESSION:SET-WAIT-STATE('GENERAL').
RUN Carga-Temporal.

SESSION:SET-WAIT-STATE('GENERAL').

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.
DEFINE VAR cValue as char.

lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = YES.       /* YES : Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

chExcelApplication:Visible = TRUE.

lMensajeAlTerminar = YES. /*  */
lCerrarAlTerminar = NO. /* Si permanece abierto el Excel luego de concluir el proceso */
/*cColList - Array Columnas (A,B,C...AA,AB,AC...) */


chWorkSheet = chExcelApplication:Sheets:Item(1).

iColumn = 1.
cColumn = STRING(iColumn).

cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Cod.Doc".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Nro.Doc".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Cod".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripcion" .
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Fecha".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Hora".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "LeadTime".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "Codigo".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripcion Articulo".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "Marca".
cRange = "K" + cColumn.
chWorkSheet:Range(cRange):Value = "U.M.".
cRange = "L" + cColumn.
chWorkSheet:Range(cRange):Value = "Cantidad".
cRange = "M" + cColumn.
chWorkSheet:Range(cRange):Value = "Ubicacion".
cRange = "N" + cColumn.
chWorkSheet:Range(cRange):Value = "Lote".
cRange = "O" + cColumn.
chWorkSheet:Range(cRange):Value = "Vcto Lote".
cRange = "P" + cColumn.
chWorkSheet:Range(cRange):Value = "Peso".
cRange = "Q" + cColumn.
chWorkSheet:Range(cRange):Value = "Volumen".
cRange = "R" + cColumn.
chWorkSheet:Range(cRange):Value = "Items".


FOR EACH w-report EXCLUSIVE-LOCK WHERE w-report.task-no = s-task-no:
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[1].
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[2].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[3].
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[4].
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-d[1].
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[5].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[6].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[9].
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[10].
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[11].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[8].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-f[1].
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[7].
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[12].
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-d[2].
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-f[2].
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-f[3].
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-f[4].

END.

FOR EACH w-report EXCLUSIVE-LOCK WHERE w-report.task-no = s-task-no:
    DELETE w-report.
END.

SESSION:SET-WAIT-STATE('').

{lib\excel-close-file.i}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

