&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE Detalle NO-UNDO LIKE VtaTabla.



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
DEF SHARED VAR cl-codcia AS INT.

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
&Scoped-define INTERNAL-TABLES Detalle

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 Detalle.Llave_c1 Detalle.Llave_c2 ~
Detalle.LLave_c3 Detalle.Llave_c4 Detalle.Llave_c5 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH Detalle NO-LOCK ~
    BY Detalle.Llave_c1 ~
       BY Detalle.Llave_c2 ~
        BY Detalle.LLave_c3 ~
         BY Detalle.Llave_c4 ~
          BY Detalle.Llave_c5 INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH Detalle NO-LOCK ~
    BY Detalle.Llave_c1 ~
       BY Detalle.Llave_c2 ~
        BY Detalle.LLave_c3 ~
         BY Detalle.Llave_c4 ~
          BY Detalle.Llave_c5 INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 Detalle
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 Detalle


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS txtOrdenCompra FILL-IN-CodCli ~
FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 BUTTON-17 BUTTON-16 BROWSE-2 RECT-67 ~
RECT-68 
&Scoped-Define DISPLAYED-OBJECTS txtOrdenCompra FILL-IN-CodCli ~
FILL-IN-NomCli FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-16 
     LABEL "APLICAR FILTROS" 
     SIZE 22 BY 1.12.

DEFINE BUTTON BUTTON-17 
     IMAGE-UP FILE "img/aplic.ico":U
     LABEL "Button 17" 
     SIZE 15 BY 2.12 TOOLTIP "Asignación de LPN".

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "FAI emitidos desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 67 BY 1 NO-UNDO.

DEFINE VARIABLE txtOrdenCompra AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-67
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 99 BY 3.46.

DEFINE RECTANGLE RECT-68
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 34 BY 3.46.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      Detalle SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      Detalle.Llave_c1 COLUMN-LABEL "Número de O/C" FORMAT "x(20)":U
            WIDTH 17.43
      Detalle.Llave_c2 COLUMN-LABEL "Lugar de entrega" FORMAT "x(60)":U
      Detalle.LLave_c3 COLUMN-LABEL "Número de FAI" FORMAT "x(12)":U
      Detalle.Llave_c4 COLUMN-LABEL "Número de O/D" FORMAT "x(12)":U
            WIDTH 17.14
      Detalle.Llave_c5 COLUMN-LABEL "Nro. Interno" FORMAT "x(20)":U
            WIDTH 21.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 134 BY 15.58 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txtOrdenCompra AT ROW 3.19 COL 116.86 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     FILL-IN-CodCli AT ROW 1.96 COL 14 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-NomCli AT ROW 1.96 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     FILL-IN-FchDoc-1 AT ROW 3.12 COL 22 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-FchDoc-2 AT ROW 3.12 COL 45 COLON-ALIGNED WIDGET-ID 8
     BUTTON-17 AT ROW 2.23 COL 102.43 WIDGET-ID 16
     BUTTON-16 AT ROW 3.12 COL 67 WIDGET-ID 10
     BROWSE-2 AT ROW 4.85 COL 2 WIDGET-ID 200
     "Filtros" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 1.19 COL 2 WIDGET-ID 12
          BGCOLOR 9 FGCOLOR 15 
     "O/C a Generar" VIEW-AS TEXT
          SIZE 13 BY .96 AT ROW 2.15 COL 119.29 WIDGET-ID 22
     RECT-67 AT ROW 1.38 COL 2 WIDGET-ID 14
     RECT-68 AT ROW 1.38 COL 101 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 135.86 BY 20.04 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: Detalle T "?" NO-UNDO INTEGRAL VtaTabla
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ASIGNACION DE CODIGOS LPN - SUPERMERCADOS"
         HEIGHT             = 20.04
         WIDTH              = 135.86
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

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-2 BUTTON-16 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.Detalle"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.Detalle.Llave_c1|yes,Temp-Tables.Detalle.Llave_c2|yes,Temp-Tables.Detalle.LLave_c3|yes,Temp-Tables.Detalle.Llave_c4|yes,Temp-Tables.Detalle.Llave_c5|yes"
     _FldNameList[1]   > Temp-Tables.Detalle.Llave_c1
"Detalle.Llave_c1" "Número de O/C" "x(20)" "character" ? ? ? ? ? ? no ? no no "17.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.Detalle.Llave_c2
"Detalle.Llave_c2" "Lugar de entrega" "x(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.Detalle.LLave_c3
"Detalle.LLave_c3" "Número de FAI" "x(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.Detalle.Llave_c4
"Detalle.Llave_c4" "Número de O/D" "x(12)" "character" ? ? ? ? ? ? no ? no no "17.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.Detalle.Llave_c5
"Detalle.Llave_c5" "Nro. Interno" "x(20)" "character" ? ? ? ? ? ? no ? no no "21.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ASIGNACION DE CODIGOS LPN - SUPERMERCADOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ASIGNACION DE CODIGOS LPN - SUPERMERCADOS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-16
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-16 W-Win
ON CHOOSE OF BUTTON-16 IN FRAME F-Main /* APLICAR FILTROS */
DO:
  ASSIGN  FILL-IN-CodCli FILL-IN-FchDoc-1 FILL-IN-FchDoc-2.
  RUN Carga-Temporal.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-17
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-17 W-Win
ON CHOOSE OF BUTTON-17 IN FRAME F-Main /* Button 17 */
DO:
  ASSIGN txtOrdenCompra.

  IF txtOrdenCompra <> '' THEN DO:
      FIND FIRST detalle WHERE detalle.llave_c1 = txtOrdenCompra NO-ERROR.
      IF AVAILABLE detalle THEN DO:
          MESSAGE 'Seguro de Generar el LPN?' VIEW-AS ALERT-BOX QUESTION
                  BUTTONS YES-NO UPDATE rpta AS LOG.
          IF rpta = NO THEN RETURN NO-APPLY.

          RUN Genera-LPN.
      END.
      ELSE DO:
          MESSAGE "Orden de Compra no EXISTE".
      END.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli W-Win
ON LEAVE OF FILL-IN-CodCli IN FRAME F-Main /* Cliente */
DO:
  IF SELF:SCREEN-VALUE = '' THEN LEAVE.
  RUN vtagn/p-gn-clie-01 (SELF:SCREEN-VALUE, "").
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  FIND gn-clie WHERE gn-clie.codcia  = cl-codcia
      AND gn-clie.codcli = SELF:SCREEN-VALUE
      NO-LOCK.
  FILL-IN-NomCli:SCREEN-VALUE = gn-clie.NomCli.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli W-Win
ON LEFT-MOUSE-DBLCLICK OF FILL-IN-CodCli IN FRAME F-Main /* Cliente */
OR F8 OF FILL-IN-CodCli
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''.
    RUN vtagn/c-gn-clie-01 ('Clientes').
    IF output-var-1 <> ? THEN ASSIGN SELF:SCREEN-VALUE = output-var-2  FILL-IN-NomCli:SCREEN-VALUE = output-var-3.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF BUFFER PEDIDO FOR Faccpedi.
DEF BUFFER COTIZACION FOR Faccpedi.

EMPTY TEMP-TABLE Detalle.
FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
    /*AND ccbcdocu.coddoc = 'FAI'*/
    AND ccbcdocu.coddoc = 'FAC'
    AND ccbcdocu.divori = '00017'       /* Canal Moderno */ 
    AND ccbcdocu.fchdoc >= FILL-IN-FchDoc-1
    AND ccbcdocu.fchdoc <= FILL-IN-FchDoc-2
    AND ccbcdocu.flgest <> 'A' /* AND ccbcdocu.flgest = 'C'*/,
    FIRST PEDIDO NO-LOCK WHERE PEDIDO.codcia = Ccbcdocu.codcia
    /*AND PEDIDO.coddiv = Ccbcdocu.divori*/
    AND PEDIDO.coddoc = Ccbcdocu.codped
    AND PEDIDO.nroped = Ccbcdocu.nroped,
    FIRST COTIZACION NO-LOCK WHERE COTIZACION.codcia = PEDIDO.codcia
    /*AND COTIZACION.coddiv = PEDIDO.coddiv*/
    AND COTIZACION.coddoc = PEDIDO.codref
    AND COTIZACION.nroped = PEDIDO.nroref,
    EACH ControlOD NO-LOCK WHERE ControlOD.codcia = Ccbcdocu.codcia
    AND ControlOD.coddiv = s-coddiv
    AND ControlOD.coddoc = Ccbcdocu.Libre_c01   /* O/D */
    AND ControlOD.nrodoc = Ccbcdocu.Libre_c02
    AND ControlOD.LPN = "POR DEFINIR":
    FIND FIRST Detalle WHERE Detalle.Libre_c01 = COTIZACION.coddiv
        AND Detalle.Libre_c02 = COTIZACION.codcli
        AND Llave_c1 = ControlOD.OrdCmp
        AND Llave_c2 = COTIZACION.Ubigeo[1]
        AND LLave_c3 = Ccbcdocu.nrodoc
        AND Llave_c4 = ControlOD.nrodoc
        AND Llave_c5 = ControlOD.NroEtq
        NO-ERROR.
    IF NOT AVAILABLE Detalle THEN CREATE Detalle.
    ASSIGN
        Detalle.Libre_c01 = COTIZACION.coddiv
        Detalle.Libre_c02 = COTIZACION.codcli
        Detalle.Llave_c1 = ControlOD.OrdCmp
        Detalle.Llave_c2 = COTIZACION.Ubigeo[1]
        Detalle.LLave_c3 = Ccbcdocu.nrodoc
        Detalle.Libre_c03 = ControlOD.coddoc
        Detalle.Llave_c4 = ControlOD.nrodoc
        Detalle.Llave_c5 = ControlOD.NroEtq.
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
  DISPLAY txtOrdenCompra FILL-IN-CodCli FILL-IN-NomCli FILL-IN-FchDoc-1 
          FILL-IN-FchDoc-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE txtOrdenCompra FILL-IN-CodCli FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 
         BUTTON-17 BUTTON-16 BROWSE-2 RECT-67 RECT-68 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-LPN W-Win 
PROCEDURE Genera-LPN :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

MESSAGE 'Se va a proceder a generar los números LPN' SKIP
    'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.

FOR EACH Detalle WHERE detalle.llave_c1 = txtOrdenCompra BREAK BY Detalle.Llave_c1
    BY Detalle.Llave_c2
    BY Detalle.LLave_c3
    BY Detalle.Llave_c4
    BY Detalle.Llave_c5
    TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    IF FIRST-OF(Detalle.Llave_c1) THEN DO:
        /* Bloqueamos control de cortrelativos */
        {lib/lock-genericov2.i ~
            &Tabla="SupControlOC" ~
            &Condicion="SupControlOC.CodCia = s-codcia ~
            AND SupControlOC.CodDiv = Detalle.Libre_c01 ~
            AND SupControlOC.CodCli = Detalle.Libre_c02 ~
            AND SupControlOC.OrdCmp = Detalle.Llave_c1" ~
            &Bloqueo="EXCLUSIVE-LOCK" 
            &Accion="RETRY" ~
            &Mensaje="YES" ~
            &TipoError="RETURN ERROR" ~
            }
    END.
    FIND ControlOD WHERE ControlOD.CodCia = s-codcia
        AND ControlOD.CodDiv = s-CodDiv
        AND ControlOD.OrdCmp = Detalle.Llave_c1
        AND ControlOD.NroEtq = Detalle.Llave_c5
        AND ControlOD.CodDoc = Detalle.Libre_c03
        AND ControlOD.NroDoc = Detalle.Llave_c4
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE ControlOD THEN DO:
        MESSAGE 'NO se pudo bloquear:' SKIP
            Detalle.Llave_c1 Detalle.Llave_c2 Detalle.Llave_c3 Detalle.Llave_c4 Detalle.Llave_c5
            VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN ERROR.
    END.
    ASSIGN
        ControlOD.LPN3 = STRING(SupControlOC.Correlativo + 1, '9999')
        ControlOD.LPN  = TRIM(ControlOD.LPN1) + TRIM(ControlOD.LPN2) + TRIM(ControlOD.LPN3).
    ASSIGN
        SupControlOC.Correlativo = SupControlOC.Correlativo + 1.
END.
IF AVAILABLE SupControlOC THEN RELEASE SupControlOC.
EMPTY TEMP-TABLE Detalle.
{&OPEN-QUERY-{&BROWSE-NAME}}

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
  ASSIGN
      FILL-IN-FchDoc-1 = TODAY
      FILL-IN-FchDoc-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "Detalle"}

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

