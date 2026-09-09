&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-DI-RutaC NO-UNDO LIKE DI-RutaC.



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
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR x-Dias AS INTE INIT -30 NO-UNDO.

IF s-user-id = 'ADMIN' THEN x-Dias = -365.

&SCOPED-DEFINE Condicion (~
DI-RutaC.CodCia = s-codcia AND ~
DI-RutaC.CodDiv = s-coddiv AND ~
DI-RutaC.CodDoc = "H/R" AND ~
DI-RutaC.Libre_l01 = YES AND ~
DI-RutaC.FlgEst = "C" AND ~
DI-RutaC.FchDoc >= ADD-INTERVAL(TODAY,x-Dias,"days") )

DEF VAR x-Peso AS DECI NO-UNDO.
DEF VAR x-Volumen AS DECI NO-UNDO.

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
&Scoped-define INTERNAL-TABLES t-DI-RutaC DI-RutaC

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 DI-RutaC.NroDoc DI-RutaC.FchDoc ~
DI-RutaC.CodVeh fPeso() @ DI-RutaC.Libre_d01 ~
fVolumen() @ DI-RutaC.Libre_d02 DI-RutaC.FchSal 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH t-DI-RutaC NO-LOCK, ~
      FIRST DI-RutaC OF t-DI-RutaC NO-LOCK ~
    BY t-DI-RutaC.NroDoc DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH t-DI-RutaC NO-LOCK, ~
      FIRST DI-RutaC OF t-DI-RutaC NO-LOCK ~
    BY t-DI-RutaC.NroDoc DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 t-DI-RutaC DI-RutaC
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 t-DI-RutaC
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 DI-RutaC


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN_NroDoc BUTTON_Cargar ~
FILL-IN_FchSal-1 FILL-IN_FchSal-2 BROWSE-2 BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_NroDoc FILL-IN_FchSal-1 ~
FILL-IN_FchSal-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPeso W-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fVolumen W-Win 
FUNCTION fVolumen RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "RECALCULAR PESOS Y VOLUMENES" 
     SIZE 38 BY 1.12
     FONT 6.

DEFINE BUTTON BUTTON_Cargar 
     LABEL "CARGAR BD" 
     SIZE 15 BY 1.12
     FONT 6.

DEFINE VARIABLE FILL-IN_FchSal-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de Salida desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_FchSal-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_NroDoc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nro. de H/R" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      t-DI-RutaC, 
      DI-RutaC SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      DI-RutaC.NroDoc FORMAT "X(9)":U WIDTH 11.43
      DI-RutaC.FchDoc FORMAT "99/99/9999":U WIDTH 11.43
      DI-RutaC.CodVeh COLUMN-LABEL "Placa del!Vehículo" FORMAT "X(15)":U
      fPeso() @ DI-RutaC.Libre_d01 COLUMN-LABEL "Peso!kg" FORMAT "->>>,>>>,>>9.99":U
      fVolumen() @ DI-RutaC.Libre_d02 COLUMN-LABEL "Volumen!m3" FORMAT "->>>,>>>,>>9.99":U
      DI-RutaC.FchSal COLUMN-LABEL "Salida" FORMAT "99/99/9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 71 BY 13.19
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN_NroDoc AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 4
     BUTTON_Cargar AT ROW 1.54 COL 57 WIDGET-ID 10
     FILL-IN_FchSal-1 AT ROW 2.08 COL 19 COLON-ALIGNED WIDGET-ID 6
     FILL-IN_FchSal-2 AT ROW 2.08 COL 39 COLON-ALIGNED WIDGET-ID 8
     BROWSE-2 AT ROW 3.15 COL 3 WIDGET-ID 200
     BUTTON-1 AT ROW 16.62 COL 2 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 74.86 BY 17.04
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: t-DI-RutaC T "?" NO-UNDO INTEGRAL DI-RutaC
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "RECALCULAR PESOS Y VOLUMENES HOJA DE RUTA"
         HEIGHT             = 17.04
         WIDTH              = 74.86
         MAX-HEIGHT         = 26.15
         MAX-WIDTH          = 191.29
         VIRTUAL-HEIGHT     = 26.15
         VIRTUAL-WIDTH      = 191.29
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
/* BROWSE-TAB BROWSE-2 FILL-IN_FchSal-2 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.t-DI-RutaC,INTEGRAL.DI-RutaC OF Temp-Tables.t-DI-RutaC"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST"
     _OrdList          = "Temp-Tables.t-DI-RutaC.NroDoc|no"
     _FldNameList[1]   > INTEGRAL.DI-RutaC.NroDoc
"DI-RutaC.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.DI-RutaC.FchDoc
"DI-RutaC.FchDoc" ? ? "date" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.DI-RutaC.CodVeh
"DI-RutaC.CodVeh" "Placa del!Vehículo" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fPeso() @ DI-RutaC.Libre_d01" "Peso!kg" "->>>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fVolumen() @ DI-RutaC.Libre_d02" "Volumen!m3" "->>>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.DI-RutaC.FchSal
"DI-RutaC.FchSal" "Salida" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* RECALCULAR PESOS Y VOLUMENES HOJA DE RUTA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* RECALCULAR PESOS Y VOLUMENES HOJA DE RUTA */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* RECALCULAR PESOS Y VOLUMENES */
DO:
  IF NOT AVAILABLE t-Di-RutaC THEN RETURN NO-APPLY.
  MESSAGE 'Procedemos con el recalculo?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.

  DEFINE VAR hProc AS HANDLE NO-UNDO.

  RUN logis/logis-librerias PERSISTENT SET hProc.
  DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
      {lib/lock-genericov3.i ~
          &Tabla="Di-RutaC" ~
          &Condicion="DI-RutaC.CodCia = t-DI-RutaC.CodCia AND ~
          DI-RutaC.CodDiv = t-DI-RutaC.CodDiv AND ~
          DI-RutaC.CodDoc = t-DI-RutaC.CodDoc AND ~
          DI-RutaC.NroDoc = t-DI-RutaC.NroDoc" ~
          &Bloqueo="EXCLUSIVE-LOCK NO-ERROR NO-WAIT" ~
          &Accion="RETRY" ~
          &Mensaje="YES" ~
          &TipoError="UNDO, LEAVE" }
      RUN HR_Peso-y-Volumen-Calculo IN hProc (INPUT Di-RutaC.CodDiv,
                                              INPUT Di-RutaC.CodDoc,
                                              INPUT Di-RutaC.NroDoc).
  END.
  DELETE PROCEDURE hProc.
  DELETE t-Di-RutaC.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  MESSAGE 'Recalculo culminado' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Cargar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Cargar W-Win
ON CHOOSE OF BUTTON_Cargar IN FRAME F-Main /* CARGAR BD */
DO:
  ASSIGN FILL-IN_FchSal-1 FILL-IN_FchSal-2 FILL-IN_NroDoc.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporal.
  SESSION:SET-WAIT-STATE('').
  {&OPEN-QUERY-{&BROWSE-NAME}}
  MESSAGE 'Carga terminada' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* ON FIND OF DI-RutaC DO:                               */
/*     DEF VAR hProc AS HANDLE NO-UNDO.                  */
/*     DEF VAR pPeso AS DECI NO-UNDO.                    */
/*     DEF VAR pVolumen AS DECI NO-UNDO.                 */
/*                                                       */
/*     RUN logis/logis-librerias PERSISTENT SET hProc.   */
/*                                                       */
/*     RUN HR_Peso-y-Volumen IN hProc (DI-RutaC.CodDiv,  */
/*                                     DI-RutaC.CodDoc,  */
/*                                     DI-RutaC.NroDoc,  */
/*                                     OUTPUT pPeso,     */
/*                                     OUTPUT pVolumen). */
/*     DELETE PROCEDURE hProc.                           */
/*     ASSIGN                                            */
/*         x-Peso = pPeso                                */
/*         x-Volumen = pVolumen.                         */
/*     RETURN.                                           */
/* END.                                                  */


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE t-Di-rutac.

FOR EACH Di-Rutac NO-LOCK WHERE {&Condicion} AND 
    ( TRUE <> (FILL-IN_NroDoc > "") OR DI-RutaC.NroDoc = FILL-IN_NroDoc ):
    IF FILL-IN_FchSal-1 <> ? AND DI-RutaC.FchSal < FILL-IN_FchSal-1 THEN NEXT.
    IF FILL-IN_FchSal-2 <> ? AND DI-RutaC.FchSal > FILL-IN_FchSal-2 THEN NEXT.
    CREATE t-Di-rutac.
    BUFFER-COPY Di-rutac TO t-Di-rutac.
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
  DISPLAY FILL-IN_NroDoc FILL-IN_FchSal-1 FILL-IN_FchSal-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN_NroDoc BUTTON_Cargar FILL-IN_FchSal-1 FILL-IN_FchSal-2 
         BROWSE-2 BUTTON-1 
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
  {src/adm/template/snd-list.i "t-DI-RutaC"}
  {src/adm/template/snd-list.i "DI-RutaC"}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPeso W-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEF VAR hProc AS HANDLE NO-UNDO.
    DEF VAR pPeso AS DECI NO-UNDO.
    DEF VAR pVolumen AS DECI NO-UNDO.

    RUN logis/logis-librerias PERSISTENT SET hProc.

    RUN HR_Peso-y-Volumen IN hProc (DI-RutaC.CodDiv, 
                                    DI-RutaC.CodDoc, 
                                    DI-RutaC.NroDoc,
                                    OUTPUT pPeso,
                                    OUTPUT pVolumen).
    DELETE PROCEDURE hProc.

    RETURN pPeso.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fVolumen W-Win 
FUNCTION fVolumen RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEF VAR hProc AS HANDLE NO-UNDO.
    DEF VAR pPeso AS DECI NO-UNDO.
    DEF VAR pVolumen AS DECI NO-UNDO.

    RUN logis/logis-librerias PERSISTENT SET hProc.

    RUN HR_Peso-y-Volumen IN hProc (DI-RutaC.CodDiv, 
                                    DI-RutaC.CodDoc, 
                                    DI-RutaC.NroDoc,
                                    OUTPUT pPeso,
                                    OUTPUT pVolumen).
    DELETE PROCEDURE hProc.

    RETURN pVolumen.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

