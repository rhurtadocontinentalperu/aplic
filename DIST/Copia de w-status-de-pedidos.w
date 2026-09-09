&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-w-report NO-UNDO LIKE w-report.



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

DEF NEW SHARED VAR lh_handle AS HANDLE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-Sectores

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-w-report

/* Definitions for BROWSE BROWSE-Sectores                               */
&Scoped-define FIELDS-IN-QUERY-BROWSE-Sectores tt-w-report.Campo-C[1] ~
tt-w-report.Campo-C[2] tt-w-report.Campo-C[10] tt-w-report.Campo-C[14] ~
tt-w-report.Campo-C[3] tt-w-report.Campo-C[4] tt-w-report.Campo-C[13] ~
tt-w-report.Campo-C[5] tt-w-report.Campo-C[6] tt-w-report.Campo-C[7] ~
tt-w-report.Campo-I[1] tt-w-report.Campo-F[2] tt-w-report.Campo-F[3] ~
tt-w-report.Campo-C[11] tt-w-report.Campo-C[12] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-Sectores 
&Scoped-define QUERY-STRING-BROWSE-Sectores FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-Sectores OPEN QUERY BROWSE-Sectores FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-Sectores tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-Sectores tt-w-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-Sectores}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RADIO-SET-1 FILL-IN-FchEnt-1 ~
FILL-IN-FchEnt-2 SELECT-Status BUTTON-Filtrar RECT-1 BROWSE-Sectores RECT-2 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-1 FILL-IN-FchEnt-1 ~
FILL-IN-FchEnt-2 SELECT-Status 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-tiempo W-Win 
FUNCTION fget-tiempo RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-status-de-pedidos AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Filtrar 
     LABEL "Aplicar Filtro" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-FchEnt-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de Entrega Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchEnt-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de Entrega Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS CHARACTER INITIAL "O/D" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Orden de Despacho", "O/D",
"Orden de Mostrador", "O/M",
"Orden de Transferencia", "OTR",
"Todos", "O/D|O/M|OTR"
     SIZE 20 BY 3 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 115 BY 5.65.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 24 BY 5.65.

DEFINE VARIABLE SELECT-Status AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SCROLLBAR-VERTICAL 
     LIST-ITEM-PAIRS "uno","uno" 
     SIZE 20 BY 4.85 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-Sectores FOR 
      tt-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-Sectores
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-Sectores W-Win _STRUCTURED
  QUERY BROWSE-Sectores NO-LOCK DISPLAY
      tt-w-report.Campo-C[1] COLUMN-LABEL "Sector" FORMAT "X(3)":U
            WIDTH 5.43
      tt-w-report.Campo-C[2] COLUMN-LABEL "Pickeador" FORMAT "X(10)":U
            WIDTH 7.29
      tt-w-report.Campo-C[10] COLUMN-LABEL "Nombre Pickeador" FORMAT "X(30)":U
            WIDTH 18.43
      tt-w-report.Campo-C[14] COLUMN-LABEL "Impresion" FORMAT "X(25)":U
            WIDTH 12.57
      tt-w-report.Campo-C[3] COLUMN-LABEL "Fec/Hora!Sacado" FORMAT "X(25)":U
            WIDTH 10.43
      tt-w-report.Campo-C[4] COLUMN-LABEL "Fec/Hora!Recep." FORMAT "X(25)":U
            WIDTH 9.43
      tt-w-report.Campo-C[13] COLUMN-LABEL "Tiempo" FORMAT "X(25)":U
            WIDTH 6.43
      tt-w-report.Campo-C[5] COLUMN-LABEL "Zona!Pickeo" FORMAT "X(4)":U
      tt-w-report.Campo-C[6] COLUMN-LABEL "User!Asigna" FORMAT "X(10)":U
            WIDTH 5.86
      tt-w-report.Campo-C[7] COLUMN-LABEL "User!Recepc." FORMAT "X(10)":U
            WIDTH 7.43
      tt-w-report.Campo-I[1] COLUMN-LABEL "Itms" FORMAT ">,>>9":U
      tt-w-report.Campo-F[2] COLUMN-LABEL "Peso" FORMAT "->>>,>>>,>>9.9999":U
            WIDTH 5.57
      tt-w-report.Campo-F[3] COLUMN-LABEL "Volumen" FORMAT "->>>,>>>,>>9.9999":U
            WIDTH 7
      tt-w-report.Campo-C[11] COLUMN-LABEL "Sup. Asignacion" FORMAT "X(30)":U
            WIDTH 11.72
      tt-w-report.Campo-C[12] COLUMN-LABEL "Sup. Recepcion" FORMAT "X(30)":U
            WIDTH 10.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 140 BY 7.81
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-SET-1 AT ROW 1.81 COL 11 NO-LABEL WIDGET-ID 2
     FILL-IN-FchEnt-1 AT ROW 1.81 COL 51 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-FchEnt-2 AT ROW 2.88 COL 51 COLON-ALIGNED WIDGET-ID 10
     SELECT-Status AT ROW 1.81 COL 79 NO-LABEL WIDGET-ID 14
     BUTTON-Filtrar AT ROW 1.54 COL 101 WIDGET-ID 22
     BROWSE-Sectores AT ROW 18.23 COL 2 WIDGET-ID 200
     "Filtros" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 1 COL 3 WIDGET-ID 20
          BGCOLOR 9 FGCOLOR 15 FONT 6
     "Status:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 1.81 COL 73 WIDGET-ID 16
     RECT-1 AT ROW 1.27 COL 2 WIDGET-ID 18
     RECT-2 AT ROW 1.27 COL 117 WIDGET-ID 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 142.29 BY 25.35
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-w-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "STATUS DE ORDENES DE PICKING"
         HEIGHT             = 25.35
         WIDTH              = 142.29
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-Sectores RECT-1 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-Sectores
/* Query rebuild information for BROWSE BROWSE-Sectores
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-C[1]
"tt-w-report.Campo-C[1]" "Sector" "X(3)" "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[2]
"tt-w-report.Campo-C[2]" "Pickeador" "X(10)" "character" ? ? ? ? ? ? no ? no no "7.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-C[10]
"tt-w-report.Campo-C[10]" "Nombre Pickeador" "X(30)" "character" ? ? ? ? ? ? no ? no no "18.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report.Campo-C[14]
"tt-w-report.Campo-C[14]" "Impresion" "X(25)" "character" ? ? ? ? ? ? no ? no no "12.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-w-report.Campo-C[3]
"tt-w-report.Campo-C[3]" "Fec/Hora!Sacado" "X(25)" "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-w-report.Campo-C[4]
"tt-w-report.Campo-C[4]" "Fec/Hora!Recep." "X(25)" "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-w-report.Campo-C[13]
"tt-w-report.Campo-C[13]" "Tiempo" "X(25)" "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-w-report.Campo-C[5]
"tt-w-report.Campo-C[5]" "Zona!Pickeo" "X(4)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-w-report.Campo-C[6]
"tt-w-report.Campo-C[6]" "User!Asigna" "X(10)" "character" ? ? ? ? ? ? no ? no no "5.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-w-report.Campo-C[7]
"tt-w-report.Campo-C[7]" "User!Recepc." "X(10)" "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tt-w-report.Campo-I[1]
"tt-w-report.Campo-I[1]" "Itms" ">,>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.tt-w-report.Campo-F[2]
"tt-w-report.Campo-F[2]" "Peso" ? "decimal" ? ? ? ? ? ? no ? no no "5.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.tt-w-report.Campo-F[3]
"tt-w-report.Campo-F[3]" "Volumen" ? "decimal" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.tt-w-report.Campo-C[11]
"tt-w-report.Campo-C[11]" "Sup. Asignacion" "X(30)" "character" ? ? ? ? ? ? no ? no no "11.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.tt-w-report.Campo-C[12]
"tt-w-report.Campo-C[12]" "Sup. Recepcion" "X(30)" "character" ? ? ? ? ? ? no ? no no "10.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-Sectores */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* STATUS DE ORDENES DE PICKING */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* STATUS DE ORDENES DE PICKING */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Filtrar W-Win
ON CHOOSE OF BUTTON-Filtrar IN FRAME F-Main /* Aplicar Filtro */
DO:
  ASSIGN FILL-IN-FchEnt-1 FILL-IN-FchEnt-2 RADIO-SET-1 SELECT-Status.
  IF FILL-IN-FchEnt-1 = ? OR FILL-IN-FchEnt-2 = ? THEN DO:
      MESSAGE 'Ingrese el rango de fecha' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  RUN Carga-Temporal IN h_b-status-de-pedidos
    ( INPUT RADIO-SET-1 /* CHARACTER */,
      INPUT FILL-IN-FchEnt-1 /* DATE */,
      INPUT FILL-IN-FchEnt-2 /* DATE */,
      INPUT SELECT-Status).   /* CHARACTER */
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-Sectores
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
             INPUT  'aplic/dist/b-status-de-pedidos.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-status-de-pedidos ).
       RUN set-position IN h_b-status-de-pedidos ( 7.19 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-status-de-pedidos ( 10.50 , 140.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-status-de-pedidos ,
             BUTTON-Filtrar:HANDLE IN FRAME F-Main , 'AFTER':U ).
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
  DISPLAY RADIO-SET-1 FILL-IN-FchEnt-1 FILL-IN-FchEnt-2 SELECT-Status 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RADIO-SET-1 FILL-IN-FchEnt-1 FILL-IN-FchEnt-2 SELECT-Status 
         BUTTON-Filtrar RECT-1 BROWSE-Sectores RECT-2 
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
  DO WITH FRAME {&FRAME-NAME}:
      SELECT-Status:DELETE(1).
      FOR EACH TabTrkDocs NO-LOCK WHERE TabTrkDocs.CodCia = s-codcia AND
          TabTrkDocs.Clave = 'TRCKPED':
          SELECT-Status:ADD-LAST(TabTrkDocs.NomCorto, TabTrkDocs.Codigo).
      END.
      FILL-IN-FchEnt-1:SCREEN-VALUE = STRING(TODAY - 1,"99/99/9999").
      FILL-IN-FchEnt-2:SCREEN-VALUE = STRING(TODAY,"99/99/9999").
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-w-report"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-muestra-subordenes W-Win 
PROCEDURE ue-muestra-subordenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.

DEFINE VAR lSectores AS CHAR.
DEFINE VAR nSectores AS INT INIT 0.
DEFINE VAR nSectoresImp AS INT  INIT 0.
DEFINE VAR nSectoresAsig AS INT  INIT 0.
DEFINE VAR nSectoresReto AS INT  INIT 0.
DEFINE VAR nSectoresSinAsig AS INT  INIT 0.

EMPTY TEMP-TABLE tt-w-report.

SESSION:SET-WAIT-STATE('GENERAL').

lSectores = "".
FOR EACH VtaCDocu WHERE VtaCDocu.codcia = s-codcia 
    AND VtaCDocu.CodPed = pCodDoc 
    AND ENTRY(1,VtaCDocu.nroped,"-") = pNroDoc
    NO-LOCK:
    lSectores = lSectores + IF(lSectores <> "") THEN "," ELSE "".
    lSectores = lSectores + ENTRY(2,VtaCDocu.nroped,"-").
    nSectores = nSectores + 1.
    IF NOT (TRUE <> (VtaCDocu.UsrImpOD > ""))   THEN DO:
        nSectoresImp = nSectoresImp + 1.
    END.
    IF NOT (TRUE <> (VtaCDocu.UsrSac > ""))   THEN DO:
        nSectoresAsig = nSectoresAsig + 1.
    END.
    IF NOT (TRUE <> (VtaCDocu.UsrSacRecep > ""))   THEN DO:
        nSectoresReto = nSectoresReto + 1.
    END.

    /**/
    CREATE tt-w-report.
    ASSIGN  
            tt-w-report.campo-c[5] = VtaCDocu.ZonaPickeo
            tt-w-report.campo-c[6] = VtaCDocu.UsrSacAsign
            tt-w-report.campo-c[7] = VtaCDocu.UsrSacRecep
            tt-w-report.campo-c[2] = VtaCDocu.UsrSac.

        tt-w-report.campo-c[1] = ENTRY(2,VtaCDocu.nroped,"-").        
        tt-w-report.campo-c[3] = STRING(VtaCDocu.fecsac,"99/99/9999") + " " + VtaCDocu.horsac.
        tt-w-report.campo-c[4] = IF(NUM-ENTRIES(VtaCDocu.libre_c03,"|")>1) THEN ENTRY(2,VtaCDocu.libre_c03,"|") ELSE "".
        tt-w-report.campo-c[13] = fget-tiempo().
        tt-w-report.campo-c[14] = STRING(VtaCDocu.fchimpOD).

    /* Pickeador */
    FIND FIRST pl-pers WHERE pl-pers.codper = VtaCDocu.UsrSac NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers THEN tt-w-report.campo-c[10] = TRIM(pl-pers.patper) + " " +
                                                        TRIM(pl-pers.matper) + " " +
                                                        TRIM(pl-pers.nomper).
    /* Supervisor Asignacion */
    FIND FIRST pl-pers WHERE pl-pers.codper = VtaCDocu.UsrSacAsign NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers THEN tt-w-report.campo-c[11] = TRIM(pl-pers.patper) + " " +
                                                        TRIM(pl-pers.matper) + " " +
                                                        TRIM(pl-pers.nomper).
    /* Supervisor Recepcion */
    FIND FIRST pl-pers WHERE pl-pers.codper = VtaCDocu.UsrSacRecep NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers THEN tt-w-report.campo-c[12] = TRIM(pl-pers.patper) + " " +
                                                        TRIM(pl-pers.matper) + " " +
                                                        TRIM(pl-pers.nomper).
    
    /* Detalle */
    FOR EACH VtaDDocu OF VtaCDocu NO-LOCK,
        FIRST almmmatg OF VtaDDocu NO-LOCK:
        tt-w-report.campo-i[1] = tt-w-report.campo-i[1] + 1.
        tt-w-report.campo-f[1] = tt-w-report.campo-f[1] + VtaDDocu.implin.
        tt-w-report.campo-f[2] = tt-w-report.campo-f[2] + ((VtaDDocu.canped * VtaDDocu.factor) * Almmmatg.pesmat).
        tt-w-report.campo-f[3] = tt-w-report.campo-f[3] + ((VtaDDocu.canped * VtaDDocu.factor) * Almmmatg.libre_d02).
    END.
    tt-w-report.campo-f[3] = tt-w-report.campo-f[3] / 1000000.
END.
nSectoresSinAsig = nSectores - nSectoresAsig.

{&OPEN-QUERY-BROWSE-Sectores}

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-tiempo W-Win 
FUNCTION fget-tiempo RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VAR x-tiempo AS CHAR INIT "".
         
  IF AVAILABLE VtaCDocu THEN DO:
      IF VtaCDocu.fecsac <> ? THEN DO:
          IF NUM-ENTRIES(VtaCDocu.libre_c03,"|") > 1  THEN DO:
                RUN lib/_time-passed (DATETIME(STRING(VtaCDocu.fecsac,"99/99/9999") + " " + VtaCDocu.horsac), DATETIME(ENTRY(2,VtaCDocu.libre_c03,"|")), OUTPUT x-Tiempo).
          END.
          ELSE DO:
                RUN lib/_time-passed (DATETIME(STRING(VtaCDocu.fecsac,"99/99/9999") + " " + VtaCDocu.horsac), DATETIME(TODAY, MTIME), OUTPUT x-Tiempo).                
          END.
      END.
  END.

  RETURN x-Tiempo.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

