&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tw-report NO-UNDO LIKE w-report.



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

DEFINE SHARED VAR s-codcia AS INT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tw-report

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tw-report.Campo-C[1] ~
tw-report.Campo-C[2] tw-report.Campo-D[1] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tw-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tw-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tw-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tw-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS EDITOR_Divisiones BUTTON-3 FILL-IN_Ruta ~
BUTTON-4 BROWSE-2 FILL-IN-dias BUTTON-procesar BUTTON_EECC 
&Scoped-Define DISPLAYED-OBJECTS EDITOR_Divisiones FILL-IN_Ruta ~
FILL-IN-dias 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/b-buscar.ico":U
     LABEL "Button 3" 
     SIZE 5 BY 1.08.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/b-buscar.ico":U
     LABEL "Button 4" 
     SIZE 5 BY 1.08.

DEFINE BUTTON BUTTON-procesar 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON_EECC 
     LABEL "Genera EECC" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE EDITOR_Divisiones AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 62 BY 1.62
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-dias AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN_Ruta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Seleccione carpeta destino" 
     VIEW-AS FILL-IN 
     SIZE 62 BY .88
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tw-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tw-report.Campo-C[1] COLUMN-LABEL "Codigo!Cliente" FORMAT "X(15)":U
            WIDTH 13.29
      tw-report.Campo-C[2] COLUMN-LABEL "Nombre del cliente" FORMAT "X(80)":U
            WIDTH 36.43
      tw-report.Campo-D[1] COLUMN-LABEL "Fecha!Proceso" FORMAT "99/99/9999":U
            WIDTH 9.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 63.86 BY 16.19
         FONT 3 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     EDITOR_Divisiones AT ROW 1.27 COL 31 NO-LABEL WIDGET-ID 14
     BUTTON-3 AT ROW 1.27 COL 94 WIDGET-ID 18
     FILL-IN_Ruta AT ROW 3.15 COL 29 COLON-ALIGNED WIDGET-ID 22
     BUTTON-4 AT ROW 3.15 COL 94 WIDGET-ID 20
     BROWSE-2 AT ROW 4.23 COL 2.14 WIDGET-ID 200
     FILL-IN-dias AT ROW 5.73 COL 80.57 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     BUTTON-procesar AT ROW 7.46 COL 76.86 WIDGET-ID 4
     BUTTON_EECC AT ROW 9.08 COL 77 WIDGET-ID 24
     "Seleccione divisiones:" VIEW-AS TEXT
          SIZE 22 BY .54 AT ROW 1.27 COL 9 WIDGET-ID 16
     "Clientes que tengan transacciones" VIEW-AS TEXT
          SIZE 35.86 BY .54 AT ROW 5.04 COL 67 WIDGET-ID 8
     "(dias)" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 5.85 COL 92 WIDGET-ID 10
     "de los últimos" VIEW-AS TEXT
          SIZE 15 BY .54 AT ROW 5.85 COL 67 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 102.43 BY 19.65
         FONT 3 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tw-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Generacion de EECC y envio masivo via mail"
         HEIGHT             = 19.65
         WIDTH              = 102.43
         MAX-HEIGHT         = 19.65
         MAX-WIDTH          = 110.72
         VIRTUAL-HEIGHT     = 19.65
         VIRTUAL-WIDTH      = 110.72
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
/* BROWSE-TAB BROWSE-2 BUTTON-4 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.tw-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tw-report.Campo-C[1]
"tw-report.Campo-C[1]" "Codigo!Cliente" "X(15)" "character" ? ? ? ? ? ? no ? no no "13.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tw-report.Campo-C[2]
"tw-report.Campo-C[2]" "Nombre del cliente" "X(80)" "character" ? ? ? ? ? ? no ? no no "36.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tw-report.Campo-D[1]
"tw-report.Campo-D[1]" "Fecha!Proceso" ? "date" ? ? ? ? ? ? no ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Generacion de EECC y envio masivo via mail */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Generacion de EECC y envio masivo via mail */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  DEF VAR pCodigos AS CHAR NO-UNDO.

  pCodigos = EDITOR_Divisiones:SCREEN-VALUE.
  RUN gn/d-filtro-divisiones (INPUT-OUTPUT pCodigos,
                              INPUT "Seleccione las Divisiones Válidas").
  EDITOR_Divisiones:SCREEN-VALUE = pCodigos.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
  DEF VAR pDirectorio AS CHAR NO-UNDO.
  
  pDirectorio = FILL-IN_Ruta:SCREEN-VALUE.
  SYSTEM-DIALOG GET-DIR pDirectorio INITIAL-DIR SESSION:TEMP-DIRECTORY TITLE "Seleccione el directorio destino".
  FILL-IN_Ruta:SCREEN-VALUE = pDirectorio.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-procesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-procesar W-Win
ON CHOOSE OF BUTTON-procesar IN FRAME F-Main /* Procesar */
DO:
  ASSIGN fill-in-dias EDITOR_Divisiones FILL-IN_Ruta.

  IF TRUE <> (EDITOR_Divisiones > '') THEN DO:
      MESSAGE 'Debe registrar al menos una división' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.

  RUN buscar-clientes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_EECC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_EECC W-Win
ON CHOOSE OF BUTTON_EECC IN FRAME F-Main /* Genera EECC */
DO:
  ASSIGN fill-in-dias EDITOR_Divisiones FILL-IN_Ruta.

  IF TRUE <> (FILL-IN_Ruta > '') THEN DO:
      MESSAGE 'Debe registrar la carpeta destino' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.

  RUN Registra-Parametros.    /* Valores por defecto a usar en la siguiente consulta */
  
  DEFINE VAR hProc AS HANDLE NO-UNDO.

  RUN ccb/libreria-ccb PERSISTENT SET hProc.

  SESSION:SET-WAIT-STATE('GENERAL').
  FOR EACH tw-report NO-LOCK:
      RUN eecc-imprimir IN hProc (tw-report.Campo-C[1],     /* Cliente */
                                  YES,                      /* Enviar a PDF */
                                  FILL-IN_Ruta).
  END.
  DELETE PROCEDURE hProc.
  SESSION:SET-WAIT-STATE('').
  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscar-clientes W-Win 
PROCEDURE buscar-clientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-divisiones AS CHAR.
DEFINE VAR x-division AS CHAR.
DEFINE VAR x-fecha-ini AS DATE.
DEFINE VAR x-sec AS INT.

DEFINE VAR x-f1 AS DATETIME.
DEFINE VAR x-f2 AS DATETIME.

/*x-divisiones = "00024,00030,000070,000519,10070".*/
x-Divisiones = EDITOR_Divisiones.
x-fecha-ini = TODAY - fill-in-dias.

EMPTY TEMP-TABLE tw-report.

SESSION:SET-WAIT-STATE("GENERAL").

x-f1 = NOW.
REPEAT x-sec = 1 TO NUM-ENTRIES(x-divisiones,","):
    x-division = ENTRY(x-sec,x-divisiones,",").
    FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
            ccbcdocu.divori = x-division AND
            ccbcdocu.fchdoc >= x-fecha-ini AND
            LOOKUP(ccbcdocu.coddoc,"FAC,BOL") > 0 AND 
            ccbcdocu.tpofac <> 'S' AND 
            ccbcdocu.flgest <> 'A' NO-LOCK:

        FIND FIRST tw-report WHERE tw-report.task-no = 0 AND tw-report.llave-c = ccbcdocu.codcli EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE tw-report THEN DO:
            CREATE tw-report.
            ASSIGN 
                tw-report.task-no = 0
                tw-report.llave-c = ccbcdocu.codcli
                tw-report.campo-c[1] = ccbcdocu.codcli
                tw-report.campo-c[2] = ccbcdocu.nomcli
                tw-report.campo-d[1] = TODAY
                .
        END.
    END.
END.
SESSION:SET-WAIT-STATE("").

{&open-query-browse-2}

/*
x-f2 = NOW.
MESSAGE x-f1 SKIP
        x-f2 .
*/

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
  DISPLAY EDITOR_Divisiones FILL-IN_Ruta FILL-IN-dias 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE EDITOR_Divisiones BUTTON-3 FILL-IN_Ruta BUTTON-4 BROWSE-2 FILL-IN-dias 
         BUTTON-procesar BUTTON_EECC 
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
  FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia AND
      CcbTabla.Tabla = "CCB_REPORTS" AND
      CcbTabla.Codigo = "EECC_MASIVO"
      NO-LOCK NO-ERROR.
  IF AVAILABLE CcbTabla THEN DO:
      EDITOR_Divisiones = CcbTabla.Libre_c01.
      FILL-IN_Ruta = CcbTabla.Libre_c02.
      FILL-IN-dias = CcbTabla.Libre_d01.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Registra-Parametros W-Win 
PROCEDURE Registra-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF TRUE <> (EDITOR_Divisiones > '') AND TRUE <> (FILL-IN_Ruta > '') THEN RETURN.

FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia AND
    CcbTabla.Tabla = "CCB_REPORTS" AND
    CcbTabla.Codigo = "EECC_MASIVO"
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE CcbTabla THEN DO:
    CREATE CcbTabla.
    ASSIGN
        CcbTabla.CodCia = s-codcia 
        CcbTabla.Tabla = "CCB_REPORTS"
        CcbTabla.Codigo = "EECC_MASIVO"
        NO-ERROR.
END.
ELSE DO:
    FIND CURRENT CcbTabla EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
END.
IF ERROR-STATUS:ERROR = YES THEN UNDO, RETURN.
ASSIGN
    CcbTabla.Libre_c01 = EDITOR_Divisiones 
    CcbTabla.Libre_c02 = FILL-IN_Ruta 
    CcbTabla.Libre_d01 = FILL-IN-dias.
RELEASE CcbTabla.

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
  {src/adm/template/snd-list.i "tw-report"}

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

