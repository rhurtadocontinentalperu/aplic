&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-report NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE t-report-2 NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE t-VtaCDocu NO-UNDO LIKE VtaCDocu.



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

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.

/*DEF VAR s-coddiv AS CHAR INIT '00000' NO-UNDO.*/

DEF TEMP-TABLE detalle
    FIELD codref LIKE vtacdocu.codref
    FIELD nroref LIKE vtacdocu.nroref
    FIELD dni AS CHAR.

DEF NEW SHARED VAR lh_handle AS HANDLE.


DEF TEMP-TABLE Seg-Pedidos
    FIELD Tipo AS CHAR FORMAT 'x(15)'                   LABEL 'TIPO'
    FIELD Codigo AS CHAR FORMAT 'x(5)'                  LABEL 'CODIGO'
    FIELD Numero AS CHAR FORMAT 'x(15)'                 LABEL 'NUMERO'
    FIELD Fecha AS DATE FORMAT '99/99/9999'             LABEL 'FECHA DE P/C'
    FIELD Hora  AS CHAR FORMAT 'x(10)'                  LABEL 'HORA DE P/C'
    FIELD CodPer AS CHAR FORMAT 'x(15)'                 LABEL 'CODIGO DEL P/C'
    FIELD NomPer AS CHAR FORMAT 'x(60)'                 LABEL 'NOMBRE DEL P/C'
    FIELD Items AS INTE FORMAT '>>>,>>9'                LABEL 'ITEMS'
    FIELD Peso AS DECI FORMAT '>>>,>>9.99'              LABEL 'PESO'
    FIELD Volumen AS DECI FORMAT '>>>,>>9.9999'         LABEL 'VOLUMEN'
    FIELD llave AS CHAR FORMAT 'x(25)'                  LABEL 'LLAVE'
    FIELD Bultos AS INTE FORMAT '>>>9'                  LABEL 'BULTOS'
    FIELD EmpaqEspec AS LOG                             LABEL 'EMPAQUE ESPECIAL'
    .

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-Fecha 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Fecha 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-embalado-especial-ordenes AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-info-chk-series AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-info-fecha-entrega AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-info-fechas AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-info-fechas-orden AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-info-pick-check AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-info-pick-pick AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-info-pick-pick-zona AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-info-produc-diaria AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-info-rutas-pend AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-info-situacion AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-info-pick-topes AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-seg-pick-check AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv100 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_tab95 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-imp-oomovi-pend-mov AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-Fecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Fecha AT ROW 1.27 COL 15 COLON-ALIGNED WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 131.14 BY 23.88
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 8
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: t-report T "?" NO-UNDO INTEGRAL w-report
      TABLE: t-report-2 T "?" NO-UNDO INTEGRAL w-report
      TABLE: t-VtaCDocu T "?" NO-UNDO INTEGRAL VtaCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ANALISIS DE PRODUCCION DE PEDIDOS EN CD"
         HEIGHT             = 23.88
         WIDTH              = 131.14
         MAX-HEIGHT         = 25.46
         MAX-WIDTH          = 172.29
         VIRTUAL-HEIGHT     = 25.46
         VIRTUAL-WIDTH      = 172.29
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
ON END-ERROR OF W-Win /* ANALISIS DE PRODUCCION DE PEDIDOS EN CD */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ANALISIS DE PRODUCCION DE PEDIDOS EN CD */
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
                     LABELS = Producción Diaria|Rutas Pendientes|Picadores|Chequeadores|Fechas|Situación|Series|Embalado especial|Mvtos no recep.':U ,
             OUTPUT h_tab95 ).
       RUN set-position IN h_tab95 ( 2.08 , 2.00 ) NO-ERROR.
       RUN set-size IN h_tab95 ( 22.62 , 129.00 ) NO-ERROR.

       /* Links to SmartTab95 h_tab95. */
       RUN add-link IN adm-broker-hdl ( h_tab95 , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_tab95 ,
             FILL-IN-Fecha:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/f-seg-pick-check.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-seg-pick-check ).
       RUN set-position IN h_f-seg-pick-check ( 3.42 , 90.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.12 , 40.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-info-produc-diaria.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-info-produc-diaria ).
       RUN set-position IN h_b-info-produc-diaria ( 3.96 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-info-produc-diaria ( 10.38 , 85.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/f-info-pick-topes.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-info-pick-topes ).
       RUN set-position IN h_f-info-pick-topes ( 14.46 , 4.00 ) NO-ERROR.
       /* Size in UIB:  ( 5.92 , 70.00 ) */

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-seg-pick-check ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-info-produc-diaria ,
             h_f-seg-pick-check , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-info-pick-topes ,
             h_b-info-produc-diaria , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-info-rutas-pend.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-info-rutas-pend ).
       RUN set-position IN h_b-info-rutas-pend ( 3.96 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-info-rutas-pend ( 20.19 , 111.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-info-rutas-pend ,
             h_tab95 , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-info-pick-pick.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-info-pick-pick ).
       RUN set-position IN h_b-info-pick-pick ( 3.96 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-info-pick-pick ( 9.69 , 115.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-info-pick-pick-zona.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-info-pick-pick-zona ).
       RUN set-position IN h_b-info-pick-pick-zona ( 14.04 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-info-pick-pick-zona ( 10.00 , 95.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-info-pick-pick ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-info-pick-pick-zona ,
             h_b-info-pick-pick , 'AFTER':U ).
    END. /* Page 3 */
    WHEN 4 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-info-pick-check.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-info-pick-check ).
       RUN set-position IN h_b-info-pick-check ( 3.96 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-info-pick-check ( 19.38 , 114.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-info-pick-check ,
             h_tab95 , 'AFTER':U ).
    END. /* Page 4 */
    WHEN 5 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-info-fechas.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-info-fechas ).
       RUN set-position IN h_b-info-fechas ( 2.88 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-info-fechas ( 10.77 , 61.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-info-fecha-entrega.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-info-fecha-entrega ).
       RUN set-position IN h_b-info-fecha-entrega ( 3.69 , 68.00 ) NO-ERROR.
       RUN set-size IN h_b-info-fecha-entrega ( 10.77 , 61.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-info-fechas-orden.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-info-fechas-orden ).
       RUN set-position IN h_b-info-fechas-orden ( 13.65 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-info-fechas-orden ( 10.77 , 61.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-info-fechas ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-info-fecha-entrega ,
             h_b-info-fechas , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-info-fechas-orden ,
             h_b-info-fecha-entrega , 'AFTER':U ).
    END. /* Page 5 */
    WHEN 6 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-info-situacion.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-info-situacion ).
       RUN set-position IN h_b-info-situacion ( 3.96 , 5.00 ) NO-ERROR.
       RUN set-size IN h_b-info-situacion ( 9.69 , 73.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-info-situacion ,
             h_tab95 , 'AFTER':U ).
    END. /* Page 6 */
    WHEN 7 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-info-chk-series.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-info-chk-series ).
       RUN set-position IN h_b-info-chk-series ( 3.69 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-info-chk-series ( 19.65 , 122.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 0,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv100 ).
       RUN set-position IN h_p-updv100 ( 23.35 , 4.00 ) NO-ERROR.
       RUN set-size IN h_p-updv100 ( 1.23 , 29.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-info-chk-series. */
       RUN add-link IN adm-broker-hdl ( h_p-updv100 , 'TableIO':U , h_b-info-chk-series ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-info-chk-series ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv100 ,
             h_b-info-chk-series , 'AFTER':U ).
    END. /* Page 7 */
    WHEN 8 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-embalado-especial-ordenes.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-embalado-especial-ordenes ).
       RUN set-position IN h_b-embalado-especial-ordenes ( 3.15 , 2.57 ) NO-ERROR.
       RUN set-size IN h_b-embalado-especial-ordenes ( 21.38 , 128.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-embalado-especial-ordenes ,
             h_tab95 , 'AFTER':U ).
    END. /* Page 8 */
    WHEN 9 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/gn/v-imp-oomovi-pend-mov.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-imp-oomovi-pend-mov ).
       RUN set-position IN h_v-imp-oomovi-pend-mov ( 3.69 , 5.00 ) NO-ERROR.
       /* Size in UIB:  ( 6.46 , 86.00 ) */

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-imp-oomovi-pend-mov ,
             h_tab95 , 'AFTER':U ).
    END. /* Page 9 */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Fecha W-Win 
PROCEDURE Captura-Fecha :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pFecha AS DATE NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN FILL-IN-Fecha.

    pFecha = FILL-IN-Fecha.
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
  DISPLAY FILL-IN-Fecha 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-Fecha 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE First-Process W-Win 
PROCEDURE First-Process :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  EMPTY TEMP-TABLE t-report.
  /* Items chequeados */
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Items Chequeados'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P':
      /*AND VtaCDocu.FchPed >= FILL-IN-Fecha:*/
      IF VtaCDocu.Libre_c04 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c04,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c04,'|')) = FILL-IN-Fecha
          THEN DO:
          t-report.Campo-F[1] = t-report.Campo-F[1] + VtaCDocu.Items.
      END.
  END.
  /* Items picados */
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Items Picados'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P':
      /*AND VtaCDocu.FchPed >= FILL-IN-Fecha:*/
      IF VtaCDocu.Libre_c03 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c03,'|')) = FILL-IN-Fecha
          THEN DO:
          t-report.Campo-F[1] = t-report.Campo-F[1] + VtaCDocu.Items.
      END.
  END.

  /* Peso chequeado */
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Peso Chequeado'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P':
      /*AND VtaCDocu.FchPed >= FILL-IN-Fecha:*/
      IF VtaCDocu.Libre_c04 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c04,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c04,'|')) = FILL-IN-Fecha
          THEN DO:
          t-report.Campo-F[1] = t-report.Campo-F[1] + VtaCDocu.Peso.
      END.
  END.
  /* Peso picado */
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Peso Picado'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P':
      /*AND VtaCDocu.FchPed >= FILL-IN-Fecha:*/
      IF VtaCDocu.Libre_c03 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c03,'|')) = FILL-IN-Fecha
          THEN DO:
          t-report.Campo-F[1] = t-report.Campo-F[1] + VtaCDocu.Peso.
      END.
  END.

  /* Volumen chequeado */
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Volumen Chequeado'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P':
      /*AND VtaCDocu.FchPed >= FILL-IN-Fecha:*/
      IF VtaCDocu.Libre_c04 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c04,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c04,'|')) = FILL-IN-Fecha
          THEN DO:
          t-report.Campo-F[1] = t-report.Campo-F[1] + VtaCDocu.Volumen.
      END.
  END.
  /* Volumen picado */
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Volumen Picado'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P':
      /*AND VtaCDocu.FchPed >= FILL-IN-Fecha:*/
      IF VtaCDocu.Libre_c04 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c03,'|')) = FILL-IN-Fecha
          THEN DO:
          t-report.Campo-F[1] = t-report.Campo-F[1] + VtaCDocu.Volumen.
      END.
  END.

  /* Pedidos chequeados */
  EMPTY TEMP-TABLE detalle.
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Pedidos Chequeados'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P':
      /*AND VtaCDocu.FchPed >= FILL-IN-Fecha:*/
      IF VtaCDocu.Libre_c04 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c04,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c04,'|')) = FILL-IN-Fecha
          THEN DO:
          FIND FIRST detalle WHERE detalle.codref = vtacdocu.codref
              AND detalle.nroref = vtacdocu.nroref
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE detalle THEN DO:
              CREATE detalle.
              ASSIGN
                  detalle.codref = vtacdocu.codref
                  detalle.nroref = vtacdocu.nroref.
          END.
      END.
  END.
  FOR EACH detalle:
      ASSIGN
          t-report.Campo-F[1] = t-report.Campo-F[1] + 1.
  END.
  /* Pedidos picados */
  EMPTY TEMP-TABLE detalle.
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Pedidos Picados'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P':
      /*AND VtaCDocu.FchPed >= FILL-IN-Fecha:*/
      IF VtaCDocu.Libre_c03 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c03,'|')) = FILL-IN-Fecha
          THEN DO:
          FIND FIRST detalle WHERE detalle.codref = vtacdocu.codref
              AND detalle.nroref = vtacdocu.nroref
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE detalle THEN DO:
              CREATE detalle.
              ASSIGN
                  detalle.codref = vtacdocu.codref
                  detalle.nroref = vtacdocu.nroref.
          END.
      END.
  END.
  FOR EACH detalle:
      ASSIGN
          t-report.Campo-F[1] = t-report.Campo-F[1] + 1.
  END.

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
  FILL-IN-Fecha = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refrescar-zona W-Win 
PROCEDURE refrescar-zona :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pPicador AS CHAR NO-UNDO.

RUN refrescar-zona-picador IN h_b-info-pick-pick-zona(INPUT pPicador).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Second-Process W-Win 
PROCEDURE Second-Process :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


  EMPTY TEMP-TABLE t-vtacdocu.

  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND Vtacdocu.FlgEst = 'P'
      AND LOOKUP(Vtacdocu.FlgSit, 'PC,C') = 0:
      FIND t-vtacdocu WHERE t-vtacdocu.codcia = s-codcia 
          AND t-vtacdocu.coddiv = s-coddiv
          AND t-vtacdocu.codped = Vtacdocu.codori
          AND t-vtacdocu.nroped = Vtacdocu.nroori
          NO-ERROR.
      IF NOT AVAILABLE t-vtacdocu THEN DO:
          CREATE t-vtacdocu.
          ASSIGN
              t-vtacdocu.codcia = s-codcia 
              t-vtacdocu.coddiv = s-coddiv
              t-vtacdocu.codped = Vtacdocu.codori
              t-vtacdocu.nroped = Vtacdocu.nroori.
      END.
      t-vtacdocu.items = t-vtacdocu.items + Vtacdocu.Items.
      t-vtacdocu.peso = t-vtacdocu.peso + Vtacdocu.Peso.
      t-vtacdocu.volumen = t-vtacdocu.volumen + Vtacdocu.Volumen.
  END.
  FOR EACH t-vtacdocu EXCLUSIVE,
      EACH vtacdocu NO-LOCK WHERE vtacdocu.codcia = t-vtacdocu.codcia
      AND vtacdocu.codori = t-vtacdocu.codped
      AND vtacdocu.nroori = t-vtacdocu.nroped
      AND Vtacdocu.FlgEst = 'P'
      AND LOOKUP(Vtacdocu.FlgSit, 'PC,C') = 0
      BREAK BY vtacdocu.codref BY vtacdocu.nroref:
      IF FIRST-OF(vtacdocu.codref) OR FIRST-OF(vtacdocu.nroref) 
          THEN t-vtacdocu.libre_d01 = t-vtacdocu.libre_d01 + 1.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Seg-Pick-Check W-Win 
PROCEDURE Seg-Pick-Check :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEF VAR pOptions AS CHAR NO-UNDO.
DEF VAR pArchivo AS CHAR NO-UNDO.

DEF VAR OKpressed AS LOG.
DEF VAR pNombre AS CHAR NO-UNDO.
DEF VAR porigen AS CHAR NO-UNDO.

SYSTEM-DIALOG GET-FILE pArchivo
    FILTERS "Archivo txt" "*.txt"
    ASK-OVERWRITE 
    CREATE-TEST-FILE
    DEFAULT-EXTENSION ".txt"
    SAVE-AS
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN NO-APPLY.

ASSIGN
    pOptions = "FileType:TXT" + CHR(1) + ~
          "Grid:ver" + CHR(1) + ~ 
          "ExcelAlert:false" + CHR(1) + ~
          "ExcelVisible:false" + CHR(1) + ~
          "Labels:yes".

/* Capturamos información de la cabecera y el detalle */
DEF VAR pInicio AS DATE NO-UNDO.
DEF VAR pFin AS DATE NO-UNDO.

pInicio = TODAY.
pFin = TODAY.

RUN gn/d-filtro-fechas (INPUT '',
                        INPUT-OUTPUT pInicio,
                        INPUT-OUTPUT pFin).

IF pInicio = ? THEN RETURN.


SESSION:SET-WAIT-STATE('GENERAL').
RUN bgn/p-seg-pick-check (INPUT pInicio,
                          INPUT pFin,
                          INPUT s-CodDiv,
                          OUTPUT TABLE t-report-2).
SESSION:SET-WAIT-STATE('').

FIND FIRST t-report-2 NO-LOCK NO-ERROR.
IF NOT AVAILABLE t-report-2 THEN DO:
    MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
    RETURN NO-APPLY.
END.

EMPTY TEMP-TABLE Seg-Pedidos.
FOR EACH t-report-2 NO-LOCK:
    CREATE Seg-Pedidos.
    ASSIGN
        Seg-Pedidos.Tipo = t-report-2.Llave-C
        Seg-Pedidos.NomPer = t-report-2.campo-c[2]
        Seg-Pedidos.Codigo = t-report-2.campo-c[3]
        Seg-Pedidos.Numero = t-report-2.campo-c[4]
        Seg-Pedidos.Fecha = t-report-2.campo-d[1]
        Seg-Pedidos.Hora = t-report-2.campo-c[5]
        Seg-Pedidos.CodPer = t-report-2.campo-c[1]
        Seg-Pedidos.Items = t-report-2.campo-f[1]
        Seg-Pedidos.Peso = t-report-2.campo-f[2]
        Seg-Pedidos.Volumen = t-report-2.campo-f[3]
        Seg-Pedidos.llave = t-report-2.Campo-c[6]
        Seg-Pedidos.Bultos = t-report-2.Campo-i[1]
        Seg-Pedidos.EmpaqEspec = t-report-2.Campo-L[1]
        .
END.

DEF VAR cArchivo AS CHAR NO-UNDO.
/* El archivo se va a generar en un archivo temporal de trabajo antes 
de enviarlo a su directorio destino */
cArchivo = LC(pArchivo).
SESSION:SET-WAIT-STATE('GENERAL').
RUN lib/tt-filev2 (TEMP-TABLE Seg-Pedidos:HANDLE, cArchivo, pOptions).
SESSION:SET-WAIT-STATE('').
/* ******************************************************* */
MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Third-Process W-Win 
PROCEDURE Third-Process :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  EMPTY TEMP-TABLE t-report-2.
  EMPTY TEMP-TABLE detalle.

  /* Cargamos Picadores */
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst <> 'A'
      AND VtaCDocu.FchPed >= FILL-IN-Fecha:
      IF VtaCDocu.Libre_c03 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 3
          AND DATE(ENTRY(2,VtaCDocu.Libre_c03,'|')) = FILL-IN-Fecha
          THEN DO:
          FIND t-report-2 WHERE t-report-2.campo-c[1] = ENTRY(3,VtaCDocu.Libre_c03,'|')
              EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE t-report-2 THEN DO:
              CREATE t-report-2.
              ASSIGN 
                  t-report-2.campo-c[1] = ENTRY(3,VtaCDocu.Libre_c03,'|').
          END.
          ASSIGN
              t-report-2.Campo-F[1] = t-report-2.Campo-F[1] + VtaCDocu.Items
              t-report-2.Campo-F[2] = t-report-2.Campo-F[2] + VtaCDocu.Peso
              t-report-2.Campo-F[3] = t-report-2.Campo-F[1] + VtaCDocu.Volumen
              .
          FIND FIRST detalle WHERE detalle.dni = t-report-2.campo-c[1]
              AND detalle.codref = vtacdocu.codref
              AND detalle.nroref = vtacdocu.nroref
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE detalle THEN DO:
              CREATE detalle.
              ASSIGN
                  detalle.dni = t-report-2.campo-c[1]
                  detalle.codref = vtacdocu.codref
                  detalle.nroref = vtacdocu.nroref.
          END.
      END.
  END.
  /* Buscamos su nombre */
  DEF VAR pNombre AS CHAR NO-UNDO.
  DEF VAR pOrigen AS CHAR NO-UNDO.

  FOR EACH t-report-2:
      RUN logis/p-busca-por-dni ( INPUT t-report-2.campo-c[1],
                                  OUTPUT pNombre,
                                  OUTPUT pOrigen).
      IF pOrigen <> 'ERROR' THEN t-report-2.campo-c[2] = pNombre.
      FOR EACH detalle NO-LOCK WHERE detalle.dni = t-report-2.campo-c[1]:
           t-report-2.Campo-F[4] =  t-report-2.Campo-F[4] + 1.
      END.
  END.

/*   
  /* Pedidos picados */
  EMPTY TEMP-TABLE detalle.
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Pedidos Picados'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst <> 'A'
      AND VtaCDocu.FchPed >= FILL-IN-Fecha:
      IF VtaCDocu.Libre_c03 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c03,'|')) = FILL-IN-Fecha
          THEN DO:
          FIND FIRST detalle WHERE detalle.codref = vtacdocu.codref
              AND detalle.nroref = vtacdocu.nroref
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE detalle THEN DO:
              CREATE detalle.
              ASSIGN
                  detalle.codref = vtacdocu.codref
                  detalle.nroref = vtacdocu.nroref.
          END.
      END.
  END.
  FOR EACH detalle:
      ASSIGN
          t-report.Campo-F[1] = t-report.Campo-F[1] + 1.
  END.

*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

