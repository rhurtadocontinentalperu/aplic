&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tAlmCIncidencia NO-UNDO LIKE AlmCIncidencia
       field dias as int.



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
DEFINE SHARED VAR s-coddiv AS CHAR.

define stream REPORT.

DEFINE BUFFER b-gn-divi FOR gn-divi.

define var x-sort-column-current as char.

s-coddiv ="00000".

DEFINE VAR x-cuales AS CHAR INIT "*".
DEFINE VAR x-dias AS INT INIT 0.

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
&Scoped-define INTERNAL-TABLES tAlmCIncidencia GN-DIVI

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tAlmCIncidencia.NroControl ~
tAlmCIncidencia.CodDiv GN-DIVI.DesDiv tAlmCIncidencia.dias @ x-dias ~
tAlmCIncidencia.ResponDistribucion tAlmCIncidencia.Fecha ~
tAlmCIncidencia.Hora tAlmCIncidencia.Usuario tAlmCIncidencia.FlgEst ~
tAlmCIncidencia.CodDoc tAlmCIncidencia.NroDoc tAlmCIncidencia.UsrAprobacion ~
tAlmCIncidencia.FechaAprobacion tAlmCIncidencia.HoraAprobacion ~
tAlmCIncidencia.ChkAlmDes tAlmCIncidencia.AlmOri tAlmCIncidencia.AlmDes ~
tAlmCIncidencia.MotivoRechazo tAlmCIncidencia.GlosaRechazo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tAlmCIncidencia ~
      WHERE x-cuales = "*" or ~
tAlmCIncidencia.ResponAlmacen = x-cuales NO-LOCK, ~
      EACH GN-DIVI WHERE GN-DIVI.CodDiv = tAlmCIncidencia.CodDiv NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tAlmCIncidencia ~
      WHERE x-cuales = "*" or ~
tAlmCIncidencia.ResponAlmacen = x-cuales NO-LOCK, ~
      EACH GN-DIVI WHERE GN-DIVI.CodDiv = tAlmCIncidencia.CodDiv NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tAlmCIncidencia GN-DIVI
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tAlmCIncidencia
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 GN-DIVI


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-consultar FILL-IN-desde FILL-IN-hasta ~
BUTTON-txt RADIO-SET-quienes BROWSE-2 FILL-IN-responsable BUTTON-addresp ~
EDITOR-comentarios COMBO-BOX-motivo BUTTON-grabar BUTTON-cancelar 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-desde FILL-IN-hasta ~
RADIO-SET-quienes FILL-IN-responsable EDITOR-comentarios COMBO-BOX-motivo ~
FILL-IN-div-despacho FILL-IN-nombre 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-addresp 
     LABEL "Add responsable" 
     SIZE 13 BY .81.

DEFINE BUTTON BUTTON-cancelar 
     LABEL "Cancelar" 
     SIZE 12 BY .81.

DEFINE BUTTON BUTTON-consultar 
     LABEL "Consultar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-grabar 
     LABEL "Grabar" 
     SIZE 12 BY .81.

DEFINE BUTTON BUTTON-txt 
     LABEL "File TXT" 
     SIZE 12 BY 1.12.

DEFINE VARIABLE COMBO-BOX-motivo AS CHARACTER FORMAT "X(80)":U 
     LABEL "Motivo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Prueba 001","001",
                     "Prueba 002","002"
     DROP-DOWN-LIST
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE EDITOR-comentarios AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 53 BY 2.69 NO-UNDO.

DEFINE VARIABLE FILL-IN-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Registrados desde" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-div-despacho AS CHARACTER FORMAT "X(100)":U 
     LABEL "Division" 
      VIEW-AS TEXT 
     SIZE 46 BY .62
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-nombre AS CHARACTER FORMAT "X(80)":U 
      VIEW-AS TEXT 
     SIZE 37 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-responsable AS CHARACTER FORMAT "X(10)":U 
     LABEL "Responsable" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-quienes AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", 1,
"CON responsable", 2,
"SIN responsable", 3
     SIZE 39.14 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tAlmCIncidencia, 
      GN-DIVI SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tAlmCIncidencia.NroControl COLUMN-LABEL "Nro!Incidencia" FORMAT "x(12)":U
            WIDTH 10.43
      tAlmCIncidencia.CodDiv COLUMN-LABEL "Division" FORMAT "x(5)":U
            WIDTH 5.43
      GN-DIVI.DesDiv FORMAT "X(40)":U
      tAlmCIncidencia.dias @ x-dias COLUMN-LABEL "Dias!Aprob/Anula" FORMAT "->>9":U
            WIDTH 8.57
      tAlmCIncidencia.ResponDistribucion COLUMN-LABEL "AprobAnula!hh:mm:ss" FORMAT "x(10)":U
            WIDTH 8.43
      tAlmCIncidencia.Fecha FORMAT "99/99/9999":U
      tAlmCIncidencia.Hora FORMAT "x(8)":U WIDTH 7.57
      tAlmCIncidencia.Usuario FORMAT "x(12)":U WIDTH 10
      tAlmCIncidencia.FlgEst FORMAT "x(12)":U WIDTH 11.43
      tAlmCIncidencia.CodDoc COLUMN-LABEL "Cod." FORMAT "x(5)":U
            WIDTH 4.43
      tAlmCIncidencia.NroDoc FORMAT "x(12)":U WIDTH 8.43
      tAlmCIncidencia.UsrAprobacion COLUMN-LABEL "Usuario!Aprob/Anulac" FORMAT "x(12)":U
      tAlmCIncidencia.FechaAprobacion COLUMN-LABEL "Fecha!Aprob/Anulac" FORMAT "99/99/9999":U
            WIDTH 9.57
      tAlmCIncidencia.HoraAprobacion COLUMN-LABEL "Hora!Aprob/Anulac" FORMAT "x(8)":U
            WIDTH 10.43
      tAlmCIncidencia.ChkAlmDes COLUMN-LABEL "Chequeador" FORMAT "x(60)":U
            WIDTH 33
      tAlmCIncidencia.AlmOri COLUMN-LABEL "Alm!Origen" FORMAT "x(8)":U
      tAlmCIncidencia.AlmDes COLUMN-LABEL "Alm!Destino" FORMAT "x(8)":U
      tAlmCIncidencia.MotivoRechazo COLUMN-LABEL "Motivo!Rechazo" FORMAT "x(80)":U
            WIDTH 35.86
      tAlmCIncidencia.GlosaRechazo COLUMN-LABEL "Glosa Rechazo" FORMAT "x(100)":U
            WIDTH 39.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS NO-SCROLLBAR-VERTICAL SIZE 140 BY 14.54
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-consultar AT ROW 1.12 COL 107.86 WIDGET-ID 14
     FILL-IN-desde AT ROW 1.27 COL 70.86 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-hasta AT ROW 1.27 COL 88.14 COLON-ALIGNED WIDGET-ID 10
     BUTTON-txt AT ROW 1.85 COL 127.72 WIDGET-ID 20
     RADIO-SET-quienes AT ROW 2.12 COL 10.14 NO-LABEL WIDGET-ID 38
     BROWSE-2 AT ROW 3.15 COL 1.72 WIDGET-ID 200
     FILL-IN-responsable AT ROW 18.08 COL 10.72 COLON-ALIGNED WIDGET-ID 26
     BUTTON-addresp AT ROW 18.31 COL 121 WIDGET-ID 42
     EDITOR-comentarios AT ROW 18.42 COL 64.86 NO-LABEL WIDGET-ID 32
     COMBO-BOX-motivo AT ROW 19.12 COL 19.14 COLON-ALIGNED WIDGET-ID 30
     BUTTON-grabar AT ROW 19.38 COL 121 WIDGET-ID 44
     BUTTON-cancelar AT ROW 20.19 COL 121 WIDGET-ID 46
     FILL-IN-div-despacho AT ROW 1.31 COL 8.29 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-nombre AT ROW 18.12 COL 19.29 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     "Comentarios" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 17.85 COL 65.43 WIDGET-ID 36
     "(cod.planilla)" VIEW-AS TEXT
          SIZE 9.43 BY .5 AT ROW 18.88 COL 3.14 WIDGET-ID 34
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 141.86 BY 20.31
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tAlmCIncidencia T "?" NO-UNDO INTEGRAL AlmCIncidencia
      ADDITIONAL-FIELDS:
          field dias as int
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Incidencias reportadas MERCADERIA DESPACHADA"
         HEIGHT             = 20.31
         WIDTH              = 141.86
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
/* BROWSE-TAB BROWSE-2 RADIO-SET-quienes F-Main */
ASSIGN 
       BROWSE-2:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-div-despacho IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-nombre IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN-nombre:READ-ONLY IN FRAME F-Main        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.tAlmCIncidencia,INTEGRAL.GN-DIVI WHERE Temp-Tables.tAlmCIncidencia ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "x-cuales = ""*"" or
tAlmCIncidencia.ResponAlmacen = x-cuales"
     _JoinCode[2]      = "INTEGRAL.GN-DIVI.CodDiv = Temp-Tables.tAlmCIncidencia.CodDiv"
     _FldNameList[1]   > Temp-Tables.tAlmCIncidencia.NroControl
"Temp-Tables.tAlmCIncidencia.NroControl" "Nro!Incidencia" ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tAlmCIncidencia.CodDiv
"Temp-Tables.tAlmCIncidencia.CodDiv" "Division" ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.GN-DIVI.DesDiv
     _FldNameList[4]   > "_<CALC>"
"tAlmCIncidencia.dias @ x-dias" "Dias!Aprob/Anula" "->>9" ? ? ? ? ? ? ? no ? no no "8.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tAlmCIncidencia.ResponDistribucion
"Temp-Tables.tAlmCIncidencia.ResponDistribucion" "AprobAnula!hh:mm:ss" "x(10)" "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = Temp-Tables.tAlmCIncidencia.Fecha
     _FldNameList[7]   > Temp-Tables.tAlmCIncidencia.Hora
"Temp-Tables.tAlmCIncidencia.Hora" ? ? "character" ? ? ? ? ? ? no ? no no "7.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tAlmCIncidencia.Usuario
"Temp-Tables.tAlmCIncidencia.Usuario" ? ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tAlmCIncidencia.FlgEst
"Temp-Tables.tAlmCIncidencia.FlgEst" ? "x(12)" "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tAlmCIncidencia.CodDoc
"Temp-Tables.tAlmCIncidencia.CodDoc" "Cod." "x(5)" "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tAlmCIncidencia.NroDoc
"Temp-Tables.tAlmCIncidencia.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.tAlmCIncidencia.UsrAprobacion
"Temp-Tables.tAlmCIncidencia.UsrAprobacion" "Usuario!Aprob/Anulac" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.tAlmCIncidencia.FechaAprobacion
"Temp-Tables.tAlmCIncidencia.FechaAprobacion" "Fecha!Aprob/Anulac" ? "date" ? ? ? ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.tAlmCIncidencia.HoraAprobacion
"Temp-Tables.tAlmCIncidencia.HoraAprobacion" "Hora!Aprob/Anulac" ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.tAlmCIncidencia.ChkAlmDes
"Temp-Tables.tAlmCIncidencia.ChkAlmDes" "Chequeador" "x(60)" "character" ? ? ? ? ? ? no ? no no "33" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.tAlmCIncidencia.AlmOri
"Temp-Tables.tAlmCIncidencia.AlmOri" "Alm!Origen" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.tAlmCIncidencia.AlmDes
"Temp-Tables.tAlmCIncidencia.AlmDes" "Alm!Destino" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.tAlmCIncidencia.MotivoRechazo
"Temp-Tables.tAlmCIncidencia.MotivoRechazo" "Motivo!Rechazo" "x(80)" "character" ? ? ? ? ? ? no ? no no "35.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > Temp-Tables.tAlmCIncidencia.GlosaRechazo
"Temp-Tables.tAlmCIncidencia.GlosaRechazo" "Glosa Rechazo" ? "character" ? ? ? ? ? ? no ? no no "39.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Incidencias reportadas MERCADERIA DESPACHADA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Incidencias reportadas MERCADERIA DESPACHADA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 W-Win
ON START-SEARCH OF BROWSE-2 IN FRAME F-Main
DO:
    /* ----------------- En el trigger START-SEARCH del BROWSE si la funcionalidad esta en un INI ---------------*/
    DEFINE VAR x-sql AS CHAR.
   /*
   x-SQL = "FOR EACH gre_cmpte WHERE gre_cmpte.estado = 'CMPTE GENERADO' and " +
            "gre_cmpte.coddivdesp = '" + s-coddiv + "' NO-LOCK, " + 
            "FIRST INTEGRAL.CcbCDocu WHERE ccbcdocu.codcia = " + string(s-codcia) + " and " +
            "ccbcdocu.coddoc = gre_cmpte.coddoc AND ccbcdocu.nrodoc = gre_cmpte.nrodoc NO-LOCK "
    */
    x-sql = "FOR EACH tAlmCIncidencia NO-LOCK, " + 
            "EACH GN-DIVI WHERE INTEGRAL.GN-DIVI.CodDiv = tAlmCIncidencia.CodDiv NO-LOCK".

    {gn/sort-browse.i &ThisBrowse="browse-2" &ThisSQL = x-SQL}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 W-Win
ON VALUE-CHANGED OF BROWSE-2 IN FRAME F-Main
DO:
  
  button-addresp:VISIBLE IN FRAME {&FRAME-NAME} = NO.
  button-grabar:VISIBLE IN FRAME {&FRAME-NAME} = NO.
  button-cancelar:VISIBLE IN FRAME {&FRAME-NAME} = NO.

  fill-in-responsable:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = "".
  fill-in-nombre:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = "".  
  editor-comentarios:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

  DISABLE fill-in-responsable WITH FRAME {&FRAME-NAME} .
  DISABLE combo-box-motivo WITH FRAME {&FRAME-NAME} .
  DISABLE editor-comentarios WITH FRAME {&FRAME-NAME} .

  IF NOT AVAILABLE tAlmCIncidencia THEN RETURN.

  FIND FIRST vtactabla WHERE vtactabla.codcia = 1 AND vtactabla.tabla = "INC-RESP" AND
                            vtactabla.llave = tAlmCIncidencia.nrocontrol NO-LOCK NO-ERROR.
  IF AVAILABLE vtactabla THEN DO:
    DO WITH FRAME {&FRAME-NAME}:
        FILL-IN-responsable:SCREEN-VALUE = vtactabla.libre_C01.
        combo-box-motivo:SCREEN-VALUE = vtactabla.libre_C02.
        editor-comentarios:SCREEN-VALUE = vtactabla.libre_C03.

        RUN datos-planilla(vtactabla.libre_C01).
    END.
  END.
  ELSE DO:
    button-addresp:VISIBLE IN FRAME {&FRAME-NAME} = YES.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-addresp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-addresp W-Win
ON CHOOSE OF BUTTON-addresp IN FRAME F-Main /* Add responsable */
DO:
  RUN add-responsable.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-cancelar W-Win
ON CHOOSE OF BUTTON-cancelar IN FRAME F-Main /* Cancelar */
DO:
  button-addresp:VISIBLE IN FRAME {&FRAME-NAME} = YES.
  button-grabar:VISIBLE IN FRAME {&FRAME-NAME} = NO.
  button-cancelar:VISIBLE IN FRAME {&FRAME-NAME} = NO.

  fill-in-responsable:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = "".
  editor-comentarios:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  fill-in-nombre:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = "".

  DISABLE fill-in-responsable WITH FRAME {&FRAME-NAME} .
  DISABLE combo-box-motivo WITH FRAME {&FRAME-NAME} .
  DISABLE editor-comentarios WITH FRAME {&FRAME-NAME} .  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-consultar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-consultar W-Win
ON CHOOSE OF BUTTON-consultar IN FRAME F-Main /* Consultar */
DO:
  ASSIGN fill-in-desde fill-in-hasta radio-set-quienes.
  RUN cargar-temporal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-grabar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-grabar W-Win
ON CHOOSE OF BUTTON-grabar IN FRAME F-Main /* Grabar */
DO:
  RUN grabar-responsable.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-txt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-txt W-Win
ON CHOOSE OF BUTTON-txt IN FRAME F-Main /* File TXT */
DO:
  ASSIGN fill-in-desde fill-in-hasta radio-set-quienes.  
  RUN generar-filetxt.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-responsable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-responsable W-Win
ON LEAVE OF FILL-IN-responsable IN FRAME F-Main /* Responsable */
DO:

  fill-in-nombre:SCREEN-VALUE = "".


  RUN datos-planilla(fill-in-responsable:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-quienes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-quienes W-Win
ON VALUE-CHANGED OF RADIO-SET-quienes IN FRAME F-Main
DO:
  
 IF SELF:SCREEN-VALUE = "1" THEN x-cuales = "*".
 IF SELF:SCREEN-VALUE = "2" THEN x-cuales = "RESP".
 IF SELF:SCREEN-VALUE = "3" THEN x-cuales = "".

 {&open-Query-browse-2}

APPLY "value-changed" TO BROWSE browse-2.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE add-responsable W-Win 
PROCEDURE add-responsable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  button-addresp:VISIBLE IN FRAME {&FRAME-NAME} = NO.
  button-grabar:VISIBLE IN FRAME {&FRAME-NAME} = YES.
  button-cancelar:VISIBLE IN FRAME {&FRAME-NAME} = YES.

  ENABLE fill-in-responsable WITH FRAME {&FRAME-NAME} .
  ENABLE combo-box-motivo WITH FRAME {&FRAME-NAME} .
  ENABLE editor-comentarios WITH FRAME {&FRAME-NAME} .

  APPLY "entry" TO fill-in-responsable.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-temporal W-Win 
PROCEDURE cargar-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lEliminar AS LOG.
DEFINE VAR dtRegistro AS DATETIME.
DEFINE VAR dtAprobacion AS DATETIME.
DEFINE VAR xFiler AS CHAR.
DEFINE VAR xFiler1 AS INT.
DEFINE VAR xDias AS INT.
DEFINE VAR xHoras AS INT.
DEFINE VAR xSegundos AS INT64.
DEFINE VAR xMinutos AS INT64.

SESSION:SET-WAIT-STATE('GENERAL').

EMPTY TEMP-TABLE tAlmCIncidencia.

/* Incidencias reportadas por el almacen de destino y aceptadas por almacen de origen */
FOR EACH AlmCIncidencia WHERE AlmCIncidencia.codcia = 1 AND AlmCIncidencia.divori = s-coddiv AND
                        AlmCIncidencia.fecha >= fill-in-desde NO-LOCK:

    IF AlmCIncidencia.fecha > fill-in-hasta THEN NEXT.
    IF AlmCIncidencia.flgest <> "C" THEN NEXT.

    CREATE tAlmCIncidencia.
    BUFFER-COPY AlmCIncidencia TO tAlmCIncidencia.

END.

/* Incidencias reportadas al almacen origen y que fue rechazada */
FOR EACH AlmCIncidencia WHERE AlmCIncidencia.codcia = 1 AND AlmCIncidencia.coddiv = s-coddiv AND
                        AlmCIncidencia.fecha >= fill-in-desde NO-LOCK:

    IF AlmCIncidencia.fecha > fill-in-hasta THEN NEXT.
    IF AlmCIncidencia.flgest <> "A" THEN NEXT.

    CREATE tAlmCIncidencia.
    BUFFER-COPY AlmCIncidencia TO tAlmCIncidencia.
    ASSIGN tAlmCIncidencia.coddiv = AlmCIncidencia.divori.
END.

xfiler1 = 0.
FOR EACH tAlmCIncidencia:
    lEliminar = NO.
    
    IF lookup(tAlmCIncidencia.flgest,'C,A') = 0 THEN lEliminar = YES.
    IF lEliminar = NO AND tAlmCIncidencia.flgest = 'A' THEN DO:
        /* Verificar si esta rechazado por el destinatario */
        FIND FIRST almcrepo WHERE almcrepo.codcia = 1 AND almcrepo.tipmov = 'INC' AND
                                    almcrepo.codref = 'INC' AND almcrepo.nroref = tAlmCIncidencia.nrocontrol AND 
                                    almcrepo.FlgEst = "R" NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almcrepo THEN lEliminar = YES.
    END.

    IF lEliminar = YES THEN DO:
        DELETE tAlmCIncidencia.
        NEXT.
    END.

    ASSIGN tAlmCIncidencia.ResponAlmacen = "".
    FIND FIRST vtactabla WHERE vtactabla.codcia = 1 AND vtactabla.tabla = "INC-RESP" AND
                              vtactabla.llave = tAlmCIncidencia.nrocontrol NO-LOCK NO-ERROR.

    IF AVAILABLE vtactabla THEN ASSIGN tAlmCIncidencia.ResponAlmacen = "RESP".

    dtRegistro = ?.
    dtAprobacion = ?.
    xDias = 0.
    xHoras = 0.
    xMinutos = 0.
    xSegundos = 0.

    xFiler = STRING(tAlmCIncidencia.fecha,"99/99/9999") + " " + tAlmCIncidencia.hora.
    dtRegistro = DATETIME(xFiler).
    IF tAlmCIncidencia.flgest = 'C' THEN DO:
        xFiler = STRING(tAlmCIncidencia.fechaAprobacion,"99/99/9999") + " " + tAlmCIncidencia.horaAprobacion.
        dtAprobacion = DATETIME(xFiler).
    END.
    IF tAlmCIncidencia.flgest = 'A' THEN DO:
        xFiler = STRING(tAlmCIncidencia.fechaAnulacion,"99/99/9999") + " " + tAlmCIncidencia.horaAnulacion.
        dtAprobacion = DATETIME(xFiler).
    END.    
    IF dtAprobacion <> ? THEN DO:
        /*xMinutos = INTERVAL(dtAprobacion,dtRegistro,"minutes").*/
        xSegundos = INTERVAL(dtAprobacion,dtRegistro,"seconds").
    END.
    xFiler = "".
    xFIler1 = 0.
    IF xSegundos > 0 THEN DO:

        xDias = TRUNCATE(xSegundos / 86400,0).
        xSegundos = xSegundos - (xDias * 86400).
        xHoras = TRUNCATE(xSegundos / 3600,0).
        xSegundos = xSegundos - (xHoras * 3600).
        xMinutos = TRUNCATE(xSegundos / 60,0).
        xSegundos = xSegundos - (xMinutos * 60).
        xfiler = STRING(xHoras,"99") + ":" + STRING(xMinutos,"99") + ":" + STRING(xSegundos,"99") .

        /*
        xDias = TRUNCATE(xMinutos / 1440,0).
        xMinutos = xMinutos - (xDias * 1440).
        xHoras = TRUNCATE(xMinutos / 60,0).
        xMinutos = xMinutos - (xHoras * 60).
        IF xDias > 0 THEN xFiler = STRING(xDias) + " dia(s)".
        IF xHoras > 0 THEN DO:
            IF xFiler <> "" THEN xFiler = xFiler + ", ".
            xFiler = xFiler + STRING(xHoras) + " hora(s)".
        END.
        IF xMinutos > 0 THEN DO:
            IF xFiler <> "" THEN xFiler = xFiler + ", ".
            xFiler = xFiler + STRING(xMinutos) + " minuto(s)".
        END.
        */
        xFiler1 = 1.
    END.
    ASSIGN tAlmCIncidencia.ResponDistribucion = xFiler
            tAlmCIncidencia.dias = xDias.

    IF tAlmCIncidencia.flgest = 'A' THEN DO:
        ASSIGN tAlmCIncidencia.usraprobacion = tAlmCIncidencia.usranulacion
                tAlmCIncidencia.fechaaprobacion = tAlmCIncidencia.fechaanulacion
                tAlmCIncidencia.horaaprobacion = tAlmCIncidencia.horaanulacion.
    END.

    IF tAlmCIncidencia.flgest = 'C' THEN ASSIGN tAlmCIncidencia.flgest = 'APROBADO'.
    IF tAlmCIncidencia.flgest = 'A' THEN ASSIGN tAlmCIncidencia.flgest = 'RECHAZADO'.

    FIND FIRST pl-pers WHERE pl-pers.codper = tAlmCIncidencia.ChkAlmDes NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers THEN DO:
        ASSIGN tAlmCIncidencia.ChkAlmDes = trim(tAlmCIncidencia.ChkAlmDes + " " + TRIM(pl-pers.nomper) +
                                    " " + TRIM(pl-pers.patper) + " " + TRIM(pl-pers.matper)).
    END.
      FIND FacTabla WHERE FacTabla.codcia = 1 AND
          FacTabla.tabla = 'OTRDELETE' AND
          facTabla.codigo= tAlmCIncidencia.MotivoRechazo
          NO-LOCK NO-ERROR.
      IF AVAILABLE FacTabla THEN ASSIGN tAlmCIncidencia.MotivoRechazo = tAlmCIncidencia.MotivoRechazo
                        + " " + FacTabla.Nombre.    
END.

{&open-query-browse-2}

FIND FIRST tAlmCIncidencia NO-LOCK NO-ERROR.

SESSION:SET-WAIT-STATE('').

APPLY "value-changed" TO BROWSE browse-2.

END PROCEDURE.

/*
  FIND FacTabla WHERE FacTabla.codcia = s-codcia AND
      FacTabla.tabla = 'OTRDELETE' AND
      facTabla.codigo= AlmCIncidencia.MotivoRechazo
      NO-LOCK NO-ERROR.
  IF AVAILABLE FacTabla THEN RETURN FacTabla.Nombre.
  ELSE RETURN "".   /* Function return value. */
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE datos-planilla W-Win 
PROCEDURE datos-planilla :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodPla AS CHAR NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:

    fill-in-nombre:SCREEN-VALUE = "".

    IF TRUE <> (pCOdPla > "") THEN RETURN.

    FIND FIRST pl-pers WHERE pl-pers.codper = pCodPla NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers THEN DO:
      fill-in-nombre:SCREEN-VALUE = trim(pl-pers.patper) + " " + trim(pl-pers.matper) + " " + trim(pl-pers.nomper).
    END.
    ELSE DO:
      fill-in-nombre:SCREEN-VALUE = " ERROR : No existe codigo".
    END.

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
  DISPLAY FILL-IN-desde FILL-IN-hasta RADIO-SET-quienes FILL-IN-responsable 
          EDITOR-comentarios COMBO-BOX-motivo FILL-IN-div-despacho 
          FILL-IN-nombre 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-consultar FILL-IN-desde FILL-IN-hasta BUTTON-txt 
         RADIO-SET-quienes BROWSE-2 FILL-IN-responsable BUTTON-addresp 
         EDITOR-comentarios COMBO-BOX-motivo BUTTON-grabar BUTTON-cancelar 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-filetxt W-Win 
PROCEDURE generar-filetxt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lDirectorio AS CHAR.
DEFINE VAR cFileName AS CHAR.
DEFINE VAR cFiler1 AS CHAR.
DEFINE VAR cFiler2 AS CHAR.

DEFINE VAR xCodPla AS CHAR.
DEFINE VAR xNomPla AS CHAR.
DEFINE VAR xMotivo AS CHAR.
DEFINE VAR xComentarios AS CHAR.

lDirectorio = "".

SYSTEM-DIALOG GET-DIR lDirectorio  
   RETURN-TO-START-DIR 
   TITLE 'Directorio Files'.
IF lDirectorio = "" THEN RETURN.

cFIleName = "incidencias".

IF radio-set-quienes = 1 THEN cFIleName = cFIleName + "_todos".
IF radio-set-quienes = 2 THEN cFIleName = cFIleName + "_con_responsable".
IF radio-set-quienes = 3 THEN cFIleName = cFIleName + "_sin_responsable".

cFiler1 = STRING(fill-in-desde,"99/99/9999").
cFiler1 = ENTRY(3,cFIler1,"/") + ENTRY(2,cFIler1,"/") + ENTRY(1,cFIler1,"/").

cFIleName = cFIleName + "_" + cFiler1.

cFiler1 = STRING(fill-in-hasta,"99/99/9999").
cFiler1 = ENTRY(3,cFIler1,"/") + ENTRY(2,cFIler1,"/") + ENTRY(1,cFIler1,"/").
cFIleName = cFIleName + "-" + cFiler1.

cFIleName = lDirectorio + "\" + cFileName + ".txt".

SESSION:SET-WAIT-STATE('GENERAL').

OUTPUT STREAM REPORT TO VALUE(cFIleName).

    PUT STREAM report 
        "Nro Incidencia|"
        "Cod.Div|"
        "Division|"
        "Dias Aprob/Anula|"
        "Aprob/Anula hh:mm:ss|"
        "Fecha Registro|"
        "Hora Registro|"
        "Usuario Registro|"
        "Estado|"
        "Cod|"
        "Nro.Doc|"
        "Chequeador|"
        "Usuario Aprueba/Anula|"
        "Fecha Aprueba/Anula|"
        "Hora Aprueba/Anula|"
        "Alm Origen|"
        "Alm Destino|"
        "Motivo rechazo|"
        "Glosa Rechazo|"
        "CodPla|"
        "Responsable|"
        "Motivo|"
        "Comentarios" SKIP.

FOR EACH tAlmCIncidencia NO-LOCK:

    IF radio-set-quienes > 1 THEN DO:
        IF tAlmCIncidencia.ResponAlmacen <> x-cuales THEN NEXT.
    END.

    xCodPla = "".
    xNomPla = "".
    xMotivo = "".
    xComentarios = "".

    FIND FIRST vtactabla WHERE vtactabla.codcia = 1 AND vtactabla.tabla = "INC-RESP" AND
                              vtactabla.llave = tAlmCIncidencia.nrocontrol NO-LOCK NO-ERROR.
    IF AVAILABLE vtactabla THEN DO:
        xCodPla = vtactabla.libre_C01.
        xMotivo = vtactabla.libre_C02.
        xComentarios = vtactabla.libre_C03.

        FIND FIRST pl-pers WHERE pl-pers.codper = vtactabla.libre_C01 NO-LOCK NO-ERROR.
        IF AVAILABLE pl-pers THEN DO:
            xNomPla = trim(pl-pers.patper) + " " + trim(pl-pers.matper) + " " + trim(pl-pers.nomper).
            
            FIND FIRST factabla WHERE factabla.codcia = 1 AND factabla.tabla = 'INC-MOT-RESP' AND 
                        factabla.codigo = xMotivo NO-LOCK NO-ERROR.
            IF AVAILABLE factabla THEN xMotivo = xMotivo + " " + TRIM(factabla.nombre).
        END.

    END.


    FIND FIRST b-gn-divi WHERE b-gn-divi.codcia = 1 AND b-gn-divi.coddiv = tAlmCIncidencia.CodDiv NO-LOCK NO-ERROR.
    PUT STREAM report 
        tAlmCIncidencia.NroControl "|"
        tAlmCIncidencia.CodDiv "|"
        b-gn-divi.desdiv "|"
        tAlmCIncidencia.dias "|"
        tAlmCIncidencia.ResponDistribucion FORMAT 'x(10)' "|"
        tAlmCIncidencia.fecha "|"
        tAlmCIncidencia.hora "|"
        tAlmCIncidencia.usuario "|"
        tAlmCIncidencia.flgest FORMAT 'x(15)' "|" 
        tAlmCIncidencia.coddoc "|"
        tAlmCIncidencia.nrodoc "|"
        tAlmCIncidencia.ChkAlmDes FORMAT 'x(60)' "|" 
        tAlmCIncidencia.usraprobacion "|"
        tAlmCIncidencia.fechaaprobacion "|"
        tAlmCIncidencia.horaaprobacion "|"
        tAlmCIncidencia.almori "|"
        tAlmCIncidencia.almdes "|"
        tAlmCIncidencia.MotivoRechazo FORMAT 'X(80)' "|"
        tAlmCIncidencia.GlosaRechazo FORMAT 'X(80)' "|"
        xCodPla FORMAT 'X(8)' "|"
        xNomPla FORMAT 'X(80)' "|"
        xMotivo FORMAT 'X(80)' "|"        
        xComentarios SKIP.
END.

OUTPUT STREAM REPORT CLOSE.

SESSION:SET-WAIT-STATE('').

MESSAGE "Se genero el file" SKIP
        cFileName VIEW-AS ALERT-BOX INFORMATION.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-responsable W-Win 
PROCEDURE grabar-responsable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fill-in-responsable combo-box-motivo editor-comentarios.
END.

IF TRUE <> (fill-in-responsable > "") THEN DO:
    MESSAGE "Debe ingresar el codigo del responsable" VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".
END.

IF TRUE <> (combo-box-motivo > "") THEN DO:
    MESSAGE "Debe ingresar el el motivo" VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".
END.

IF TRUE <> (editor-comentarios > "") THEN DO:
    MESSAGE "Debe ingresar los comentarios" VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".
END.

CREATE vtactabla.
ASSIGN vtactabla.codcia = 1
        vtactabla.tabla = "INC-RESP"
        vtactabla.llave = tAlmCIncidencia.nrocontrol
        vtactabla.libre_c01 = trim(FILL-IN-responsable)
        vtactabla.libre_c02 = trim(combo-box-motivo)
        vtactabla.libre_c03 = trim(editor-comentarios).


RELEASE vtactabla.

APPLY "value-changed" TO BROWSE browse-2.

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
  fill-in-desde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 15,"99/99/9999").
  fill-in-hasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").

  FIND FIRST gn-divi WHERE gn-divi.codcia = 1 AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.
  IF AVAILABLE gn-divi THEN DO:
      fill-in-div-despacho:SCREEN-VALUE IN FRAME {&FRAME-NAME} = s-coddiv + " - " + gn-divi.desdiv.
  END.

  DISABLE fill-in-responsable WITH FRAME {&FRAME-NAME} .
  DISABLE combo-box-motivo WITH FRAME {&FRAME-NAME} .
  DISABLE editor-comentarios WITH FRAME {&FRAME-NAME} .

  button-addresp:VISIBLE IN FRAME {&FRAME-NAME} = NO.
  button-grabar:VISIBLE IN FRAME {&FRAME-NAME} = NO.
  button-cancelar:VISIBLE IN FRAME {&FRAME-NAME} = NO.

  REPEAT WHILE COMBO-BOX-motivo:NUM-ITEMS > 0:
    COMBO-BOX-motivo:DELETE(1).
  END.

  FOR EACH factabla WHERE factabla.codcia = 1 AND factabla.tabla = 'INC-MOT-RESP' NO-LOCK:
     COMBO-BOX-motivo:ADD-LAST(factabla.nombre, factabla.codigo).
     IF TRUE <> (COMBO-BOX-motivo:SCREEN-VALUE > "") THEN DO:
             ASSIGN COMBO-BOX-motivo:SCREEN-VALUE = factabla.codigo.
     END.
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
  {src/adm/template/snd-list.i "tAlmCIncidencia"}
  {src/adm/template/snd-list.i "GN-DIVI"}

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

