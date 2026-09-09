&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR x-Nombre AS CHAR NO-UNDO.
DEF VAR x-Origen AS CHAR NO-UNDO.

DEF VAR x-NroHPKs AS INT NO-UNDO.
DEF VAR x-NroItems AS INT NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-PERSONAL

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES rut-pers-turno VtaCDocu

/* Definitions for BROWSE BROWSE-PERSONAL                               */
&Scoped-define FIELDS-IN-QUERY-BROWSE-PERSONAL rut-pers-turno.dni ~
fNombreOrigen(rut-pers-turno.dni, 1) @ x-Nombre ~
fNombreOrigen(rut-pers-turno.dni, 2) @ x-Origen rut-pers-turno.turno ~
fNroHPKs() @ x-NroHPKs fNroItems() @ x-NroItems 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-PERSONAL 
&Scoped-define QUERY-STRING-BROWSE-PERSONAL FOR EACH rut-pers-turno ~
      WHERE rut-pers-turno.codcia = s-codcia ~
 AND rut-pers-turno.coddiv = s-coddiv ~
 AND rut-pers-turno.rol = "PICADOR" ~
 AND rut-pers-turno.fchasignada = today NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-PERSONAL OPEN QUERY BROWSE-PERSONAL FOR EACH rut-pers-turno ~
      WHERE rut-pers-turno.codcia = s-codcia ~
 AND rut-pers-turno.coddiv = s-coddiv ~
 AND rut-pers-turno.rol = "PICADOR" ~
 AND rut-pers-turno.fchasignada = today NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-PERSONAL rut-pers-turno
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-PERSONAL rut-pers-turno


/* Definitions for BROWSE BROWSE-PHK                                    */
&Scoped-define FIELDS-IN-QUERY-BROWSE-PHK VtaCDocu.CodPed VtaCDocu.NroPed ~
VtaCDocu.UsrSac VtaCDocu.FecSac VtaCDocu.HorSac ~
fNombreOrigen(VtaCDocu.UsrSac, 1) @ x-Nombre ~
fNombreOrigen(VtaCDocu.UsrSac, 2) @ x-Origen VtaCDocu.Items ~
VtaCDocu.ZonaPickeo VtaCDocu.CodOri VtaCDocu.NroOri 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-PHK 
&Scoped-define QUERY-STRING-BROWSE-PHK FOR EACH VtaCDocu ~
      WHERE VtaCDocu.CodCia = s-codcia ~
 AND VtaCDocu.CodDiv = s-coddiv ~
 AND VtaCDocu.CodPed = "HPK" and ~
(fill-in-dni = "" or VtaCDocu.usrsac = fill-in-dni) ~
 AND VtaCDocu.FlgEst = "P" ~
 AND VtaCDocu.FlgSit = "TI" /*VtaCDocu.FlgSit = "TP"*/ ~
 AND (FILL-IN-NroPed = '' OR VtaCDocu.NroPed = FILL-IN-NroPed) NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-PHK OPEN QUERY BROWSE-PHK FOR EACH VtaCDocu ~
      WHERE VtaCDocu.CodCia = s-codcia ~
 AND VtaCDocu.CodDiv = s-coddiv ~
 AND VtaCDocu.CodPed = "HPK" and ~
(fill-in-dni = "" or VtaCDocu.usrsac = fill-in-dni) ~
 AND VtaCDocu.FlgEst = "P" ~
 AND VtaCDocu.FlgSit = "TI" /*VtaCDocu.FlgSit = "TP"*/ ~
 AND (FILL-IN-NroPed = '' OR VtaCDocu.NroPed = FILL-IN-NroPed) NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-PHK VtaCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-PHK VtaCDocu


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-PERSONAL}~
    ~{&OPEN-QUERY-BROWSE-PHK}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-NroPed BUTTON-Refrescar BUTTON-15 ~
FILL-IN-dni BROWSE-PHK BROWSE-PERSONAL 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NroPed FILL-IN-dni 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNombreOrigen W-Win 
FUNCTION fNombreOrigen RETURNS CHARACTER
  ( INPUT pDNI AS CHAR, INPUT pDato AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNroHPKs W-Win 
FUNCTION fNroHPKs RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNroItems W-Win 
FUNCTION fNroItems RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-15 
     LABEL "REASIGNAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Refrescar 
     LABEL "REFRESCAR" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-dni AS CHARACTER FORMAT "X(20)":U 
     LABEL "Sacador" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroPed AS CHARACTER FORMAT "X(12)":U 
     LABEL "Número HPK" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-PERSONAL FOR 
      rut-pers-turno SCROLLING.

DEFINE QUERY BROWSE-PHK FOR 
      VtaCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-PERSONAL
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-PERSONAL W-Win _STRUCTURED
  QUERY BROWSE-PERSONAL NO-LOCK DISPLAY
      rut-pers-turno.dni COLUMN-LABEL "Sacador" FORMAT "x(8)":U
            WIDTH 8.43
      fNombreOrigen(rut-pers-turno.dni, 1) @ x-Nombre COLUMN-LABEL "Nombre" FORMAT "x(30)":U
            WIDTH 30
      fNombreOrigen(rut-pers-turno.dni, 2) @ x-Origen COLUMN-LABEL "Origen" FORMAT "x(10)":U
            WIDTH 10
      rut-pers-turno.turno FORMAT "x(10)":U
      fNroHPKs() @ x-NroHPKs COLUMN-LABEL "# HPK" FORMAT ">>9":U
      fNroItems() @ x-NroItems COLUMN-LABEL "# Items" FORMAT ">>>9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 72 BY 23.15
         FONT 4
         TITLE "SELECCIONE LA PERSONA A LA CUAL DESEA REASIGNAR TAREAS".

DEFINE BROWSE BROWSE-PHK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-PHK W-Win _STRUCTURED
  QUERY BROWSE-PHK NO-LOCK DISPLAY
      VtaCDocu.CodPed FORMAT "x(3)":U WIDTH 5.43
      VtaCDocu.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U WIDTH 9.43
      VtaCDocu.UsrSac FORMAT "x(8)":U WIDTH 8.43
      VtaCDocu.FecSac FORMAT "99/99/9999":U
      VtaCDocu.HorSac FORMAT "x(8)":U WIDTH 7.72
      fNombreOrigen(VtaCDocu.UsrSac, 1) @ x-Nombre COLUMN-LABEL "Nombre" FORMAT "x(30)":U
            WIDTH 30
      fNombreOrigen(VtaCDocu.UsrSac, 2) @ x-Origen COLUMN-LABEL "Origen" FORMAT "x(10)":U
            WIDTH 10
      VtaCDocu.Items FORMAT ">>>,>>9":U
      VtaCDocu.ZonaPickeo FORMAT "x(10)":U
      VtaCDocu.CodOri COLUMN-LABEL "Ref" FORMAT "x(3)":U WIDTH 5.14
      VtaCDocu.NroOri COLUMN-LABEL "Número" FORMAT "x(15)":U WIDTH 11.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 104 BY 23.15
         FONT 4
         TITLE "SELECCIONA UNA O MAS HPK A REASIGNAR" ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-NroPed AT ROW 1.27 COL 37 COLON-ALIGNED WIDGET-ID 12
     BUTTON-Refrescar AT ROW 1.27 COL 61 WIDGET-ID 8
     BUTTON-15 AT ROW 1.27 COL 92 WIDGET-ID 6
     FILL-IN-dni AT ROW 1.31 COL 8.86 COLON-ALIGNED WIDGET-ID 10
     BROWSE-PHK AT ROW 2.62 COL 2 WIDGET-ID 200
     BROWSE-PERSONAL AT ROW 2.62 COL 107 WIDGET-ID 300
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 178.29 BY 25.08
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "REASIGNACION DE TAREAS"
         HEIGHT             = 25.08
         WIDTH              = 178.29
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 181.43
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 181.43
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
/* BROWSE-TAB BROWSE-PHK FILL-IN-dni F-Main */
/* BROWSE-TAB BROWSE-PERSONAL BROWSE-PHK F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-PERSONAL
/* Query rebuild information for BROWSE BROWSE-PERSONAL
     _TblList          = "INTEGRAL.rut-pers-turno"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "rut-pers-turno.codcia = s-codcia
 AND rut-pers-turno.coddiv = s-coddiv
 AND rut-pers-turno.rol = ""PICADOR""
 AND rut-pers-turno.fchasignada = today"
     _FldNameList[1]   > INTEGRAL.rut-pers-turno.dni
"rut-pers-turno.dni" "Sacador" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fNombreOrigen(rut-pers-turno.dni, 1) @ x-Nombre" "Nombre" "x(30)" ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fNombreOrigen(rut-pers-turno.dni, 2) @ x-Origen" "Origen" "x(10)" ? ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.rut-pers-turno.turno
"rut-pers-turno.turno" ? "x(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fNroHPKs() @ x-NroHPKs" "# HPK" ">>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fNroItems() @ x-NroItems" "# Items" ">>>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-PERSONAL */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-PHK
/* Query rebuild information for BROWSE BROWSE-PHK
     _TblList          = "INTEGRAL.VtaCDocu"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "VtaCDocu.CodCia = s-codcia
 AND VtaCDocu.CodDiv = s-coddiv
 AND VtaCDocu.CodPed = ""HPK"" and
(fill-in-dni = """" or VtaCDocu.usrsac = fill-in-dni)
 AND VtaCDocu.FlgEst = ""P""
 AND VtaCDocu.FlgSit = ""TI"" /*VtaCDocu.FlgSit = ""TP""*/
 AND (FILL-IN-NroPed = '' OR VtaCDocu.NroPed = FILL-IN-NroPed)"
     _FldNameList[1]   > INTEGRAL.VtaCDocu.CodPed
"VtaCDocu.CodPed" ? ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.VtaCDocu.NroPed
"VtaCDocu.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.VtaCDocu.UsrSac
"VtaCDocu.UsrSac" ? ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.VtaCDocu.FecSac
"VtaCDocu.FecSac" ? "99/99/9999" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.VtaCDocu.HorSac
"VtaCDocu.HorSac" ? ? "character" ? ? ? ? ? ? no ? no no "7.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fNombreOrigen(VtaCDocu.UsrSac, 1) @ x-Nombre" "Nombre" "x(30)" ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fNombreOrigen(VtaCDocu.UsrSac, 2) @ x-Origen" "Origen" "x(10)" ? ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = INTEGRAL.VtaCDocu.Items
     _FldNameList[9]   = INTEGRAL.VtaCDocu.ZonaPickeo
     _FldNameList[10]   > INTEGRAL.VtaCDocu.CodOri
"VtaCDocu.CodOri" "Ref" ? "character" ? ? ? ? ? ? no ? no no "5.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.VtaCDocu.NroOri
"VtaCDocu.NroOri" "Número" ? "character" ? ? ? ? ? ? no ? no no "11.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-PHK */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REASIGNACION DE TAREAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REASIGNACION DE TAREAS */
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
ON CHOOSE OF BUTTON-15 IN FRAME F-Main /* REASIGNAR */
DO:
  IF NOT AVAILABLE rut-pers-turno THEN RETURN.

  MESSAGE 'Confirmamos la reasignación?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.

  DEF VAR pError AS CHAR NO-UNDO.
  DEF VAR k AS INT NO-UNDO.

  pError = "".
  DEF BUFFER B-CDOCU FOR Vtacdocu.
  /* Buscamos la tarea activa */
  DO k = 1 TO BROWSE-PHK:NUM-SELECTED-ROWS ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
      IF BROWSE-PHK:FETCH-SELECTED-ROW(k) THEN DO:
          {lib/lock-genericov3.i ~
              &Tabla="B-CDOCU" ~
              &Condicion="ROWID(B-CDOCU) = ROWID(Vtacdocu)" ~
              &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
              &Accion="LEAVE" ~
              &Mensaje="NO" ~
              &txtMensaje="pError" ~
              &TipoError="UNDO, LEAVE"}
          /* Actualizamos el sacador */
          ASSIGN
              B-CDOCU.usrsac    = rut-pers-turno.dni
              B-CDOCU.ubigeo[4] = rut-pers-turno.dni.
      END.
  END.
  IF AVAILABLE(rut-pers-turno) THEN RELEASE rut-pers-turno.
  IF AVAILABLE(B-CDOCU)        THEN RELEASE B-CDOCU.
  IF pError > '' THEN MESSAGE pError VIEW-AS ALERT-BOX ERROR.
  APPLY 'CHOOSE':U TO BUTTON-Refrescar IN FRAME {&FRAME-NAME}.
  IF pError > '' THEN MESSAGE pError VIEW-AS ALERT-BOX ERROR.
  ELSE MESSAGE 'Asignación Exitosa' VIEW-AS ALERT-BOX INFORMATION. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Refrescar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Refrescar W-Win
ON CHOOSE OF BUTTON-Refrescar IN FRAME F-Main /* REFRESCAR */
DO:
    ASSIGN fill-in-dni FILL-IN-NroPed.
    
    {&OPEN-QUERY-BROWSE-PERSONAL}
    {&OPEN-QUERY-BROWSE-PHK}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-PERSONAL
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
  DISPLAY FILL-IN-NroPed FILL-IN-dni 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-NroPed BUTTON-Refrescar BUTTON-15 FILL-IN-dni BROWSE-PHK 
         BROWSE-PERSONAL 
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
  {src/adm/template/snd-list.i "VtaCDocu"}
  {src/adm/template/snd-list.i "rut-pers-turno"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNombreOrigen W-Win 
FUNCTION fNombreOrigen RETURNS CHARACTER
  ( INPUT pDNI AS CHAR, INPUT pDato AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pNombre AS CHAR.
  DEF VAR pOrigen AS CHAR.

  RUN logis/p-busca-por-dni (pDNI, OUTPUT pNombre, OUTPUT pOrigen).
  CASE pDato:
      WHEN 1 THEN RETURN pNombre.
      WHEN 2 THEN RETURN pOrigen.
  END CASE.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNroHPKs W-Win 
FUNCTION fNroHPKs RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF BUFFER B-CDOCU FOR Vtacdocu.

  DEF VAR k AS INT.
  FOR EACH B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = s-codcia AND
      B-CDOCU.coddiv = s-coddiv AND
      B-CDOCU.codped = 'HPK' AND
      B-CDOCU.flgest = 'P' AND
      LOOKUP(B-CDOCU.flgsit, 'TI,TP,TX') > 0 AND
      B-CDOCU.usrsac = rut-pers-turno.dni:
      k = k + 1.
  END.

  RETURN k.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNroItems W-Win 
FUNCTION fNroItems RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF BUFFER B-CDOCU FOR Vtacdocu.
  DEF BUFFER B-DDOCU FOR Vtaddocu.

  DEF VAR k AS INT.
  FOR EACH B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = s-codcia AND
      B-CDOCU.coddiv = s-coddiv AND
      B-CDOCU.codped = 'HPK' AND
      B-CDOCU.flgest = 'P' AND
      LOOKUP(B-CDOCU.flgsit, 'TI,TP,TX') > 0 AND
      B-CDOCU.usrsac = rut-pers-turno.dni,
      EACH B-DDOCU OF B-CDOCU NO-LOCK:
      k = k + 1.
  END.

  RETURN k.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

