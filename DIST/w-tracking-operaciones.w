&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE tt-w-report NO-UNDO LIKE w-report.



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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES FacCPedi

/* Definitions for FRAME F-Main                                         */
&Scoped-define QUERY-STRING-F-Main FOR EACH FacCPedi SHARE-LOCK
&Scoped-define OPEN-QUERY-F-Main OPEN QUERY F-Main FOR EACH FacCPedi SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-F-Main FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-F-Main FacCPedi


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 COMBO-BOX_CodDoc ~
FILL-IN_NroPed BUTTON-Buscar 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX_CodDoc FILL-IN_NroPed 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-detalle-checking AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-detalle-despacho AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-detalle-documentario AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-detalle-facturas AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-detalle-guias AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-detalle-picking AS HANDLE NO-UNDO.
DEFINE VARIABLE h_qcotizacionesypedidos AS HANDLE NO-UNDO.
DEFINE VARIABLE h_tab95 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-tracking-operaciones AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Buscar 
     LABEL "Buscar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Nueva 
     LABEL "Nueva Búsqueda" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX_CodDoc AS CHARACTER FORMAT "X(256)":U INITIAL "O/D" 
     LABEL "Ingrese" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "O/D","O/M","OTR" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_NroPed AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 142 BY 1.62.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 142 BY 5.12.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY F-Main FOR 
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX_CodDoc AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 32
     FILL-IN_NroPed AT ROW 1.27 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     BUTTON-Buscar AT ROW 1.27 COL 41 WIDGET-ID 34
     BUTTON-Nueva AT ROW 1.27 COL 56 WIDGET-ID 46
     RECT-1 AT ROW 1 COL 2 WIDGET-ID 42
     RECT-2 AT ROW 2.62 COL 2 WIDGET-ID 44
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.29 BY 25.85
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-w-report T "NEW SHARED" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "TRACKING DE OPERACIONES"
         HEIGHT             = 25.85
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
/* SETTINGS FOR BUTTON BUTTON-Nueva IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _TblList          = "INTEGRAL.FacCPedi"
     _Query            is OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* TRACKING DE OPERACIONES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* TRACKING DE OPERACIONES */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Buscar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Buscar W-Win
ON CHOOSE OF BUTTON-Buscar IN FRAME F-Main /* Buscar */
DO:
  ASSIGN COMBO-BOX_CodDoc FILL-IN_NroPed.
  IF NOT CAN-FIND(FIRST Faccpedi WHERE Faccpedi.codcia = s-codcia AND
                  Faccpedi.coddoc = COMBO-BOX_CodDoc AND
                  Faccpedi.nroped = FILL-IN_NroPed
                  NO-LOCK)
      THEN RETURN NO-APPLY.
  RUN Recibe-Parametros IN h_qcotizacionesypedidos
      ( INPUT COMBO-BOX_CodDoc /* CHARACTER */,
        INPUT FILL-IN_NroPed /* CHARACTER */).
  RUN ue-muestra-subordenes IN h_b-detalle-picking
      ( INPUT COMBO-BOX_CodDoc /* CHARACTER */,
        INPUT FILL-IN_NroPed /* CHARACTER */).
  ASSIGN
      BUTTON-Buscar:SENSITIVE = NO
      BUTTON-Nueva:SENSITIVE = YES
      COMBO-BOX_CodDoc:SENSITIVE = NO
      FILL-IN_NroPed:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Nueva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Nueva W-Win
ON CHOOSE OF BUTTON-Nueva IN FRAME F-Main /* Nueva Búsqueda */
DO:
    
    ASSIGN
        BUTTON-Buscar:SENSITIVE = YES
        BUTTON-Nueva:SENSITIVE = NO
        COMBO-BOX_CodDoc:SENSITIVE = YES
        FILL-IN_NroPed:SENSITIVE = YES.
    CLEAR FRAME {&FRAME-NAME} ALL NO-PAUSE.
    APPLY 'ENTRY':U TO FILL-IN_NroPed.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_NroPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_NroPed W-Win
ON LEAVE OF FILL-IN_NroPed IN FRAME F-Main
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  /* Buscamos la H/R */
  DEF VAR x-NroDoc AS CHAR NO-UNDO.

  IF SELF:SCREEN-VALUE BEGINS '*' THEN DO:
      x-NroDoc = REPLACE(SELF:SCREEN-VALUE,"*","").
      SELF:SCREEN-VALUE = x-NroDoc.
      FIND FacDocum WHERE FacDocum.CodCia = s-CodCia AND
          LOOKUP(FacDocum.CodDoc, 'O/D,O/M,OTR') > 0 AND
          FacDocum.CodCta[8] = SUBSTRING(x-NroDoc,1,3)
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE FacDocum THEN DO:
          MESSAGE 'El documento NO es una O/D ni una O/M ni una OTR' VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = ''.
          RETURN NO-APPLY.
      END.
      x-NroDoc = SUBSTRING(x-NroDoc,4).
      SELF:SCREEN-VALUE = x-NroDoc.
      COMBO-BOX_CodDoc:SCREEN-VALUE = FacDocum.CodDoc.
  END.
  ELSE DO:
      x-NroDoc = SELF:SCREEN-VALUE.
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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/dist/v-tracking-operaciones.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-tracking-operaciones ).
       RUN set-position IN h_v-tracking-operaciones ( 3.15 , 10.00 ) NO-ERROR.
       /* Size in UIB:  ( 4.31 , 115.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-free/objects/tab95.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'LABEL-FONT = 4,
                     LABEL-FGCOLOR = 0,
                     FOLDER-BGCOLOR = 8,
                     FOLDER-PARENT-BGCOLOR = 8,
                     LABELS = Detalle del Picking|Detalle de Checking|Detalle Documentario|Detalle Despacho':U ,
             OUTPUT h_tab95 ).
       RUN set-position IN h_tab95 ( 7.73 , 1.00 ) NO-ERROR.
       RUN set-size IN h_tab95 ( 19.12 , 144.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/qcotizacionesypedidos.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_qcotizacionesypedidos ).
       RUN set-position IN h_qcotizacionesypedidos ( 1.27 , 122.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.50 , 7.72 ) */

       /* Links to SmartViewer h_v-tracking-operaciones. */
       RUN add-link IN adm-broker-hdl ( h_qcotizacionesypedidos , 'Record':U , h_v-tracking-operaciones ).

       /* Links to SmartTab95 h_tab95. */
       RUN add-link IN adm-broker-hdl ( h_tab95 , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-tracking-operaciones ,
             BUTTON-Nueva:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_tab95 ,
             h_v-tracking-operaciones , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/dist/b-detalle-picking.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-detalle-picking ).
       RUN set-position IN h_b-detalle-picking ( 9.08 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-detalle-picking ( 6.69 , 140.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-detalle-picking ,
             h_tab95 , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/dist/b-detalle-checking.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-detalle-checking ).
       RUN set-position IN h_b-detalle-checking ( 9.08 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-detalle-checking ( 6.69 , 140.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-detalle-checking. */
       RUN add-link IN adm-broker-hdl ( h_qcotizacionesypedidos , 'Record':U , h_b-detalle-checking ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-detalle-checking ,
             h_tab95 , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/dist/b-detalle-documentario.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-detalle-documentario ).
       RUN set-position IN h_b-detalle-documentario ( 9.08 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-detalle-documentario ( 6.69 , 66.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/dist/b-detalle-guias.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-detalle-guias ).
       RUN set-position IN h_b-detalle-guias ( 9.08 , 71.00 ) NO-ERROR.
       RUN set-size IN h_b-detalle-guias ( 6.69 , 66.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/dist/b-detalle-facturas.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-detalle-facturas ).
       RUN set-position IN h_b-detalle-facturas ( 16.08 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-detalle-facturas ( 9.81 , 140.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-detalle-documentario. */
       RUN add-link IN adm-broker-hdl ( h_qcotizacionesypedidos , 'Record':U , h_b-detalle-documentario ).

       /* Links to SmartBrowser h_b-detalle-guias. */
       RUN add-link IN adm-broker-hdl ( h_b-detalle-documentario , 'Record':U , h_b-detalle-guias ).

       /* Links to SmartBrowser h_b-detalle-facturas. */
       RUN add-link IN adm-broker-hdl ( h_b-detalle-documentario , 'Record':U , h_b-detalle-facturas ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-detalle-documentario ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-detalle-guias ,
             h_b-detalle-documentario , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-detalle-facturas ,
             h_b-detalle-guias , 'AFTER':U ).
    END. /* Page 3 */
    WHEN 4 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/dist/b-detalle-despacho.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-detalle-despacho ).
       RUN set-position IN h_b-detalle-despacho ( 9.08 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-detalle-despacho ( 6.69 , 139.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-detalle-despacho. */
       RUN add-link IN adm-broker-hdl ( h_qcotizacionesypedidos , 'Record':U , h_b-detalle-despacho ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-detalle-despacho ,
             h_tab95 , 'AFTER':U ).
    END. /* Page 4 */

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

  {&OPEN-QUERY-F-Main}
  GET FIRST F-Main.
  DISPLAY COMBO-BOX_CodDoc FILL-IN_NroPed 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 COMBO-BOX_CodDoc FILL-IN_NroPed BUTTON-Buscar 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "FacCPedi"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

