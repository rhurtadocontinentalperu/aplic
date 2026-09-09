&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-Almmmate NO-UNDO LIKE Almmmate.



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
DEFINE SHARED VAR s-codalm AS CHAR.
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE VAR lLimitexZona AS INT INITIAL 25.
DEFINE VAR lCuentaxZona AS INT INITIAL 0.

DEF VAR s-task-no AS INT.

FIND FIRST almacen WHERE codcia = s-codcia AND codalm = s-codalm NO-LOCK NO-ERROR.

IF NOT AVAILABLE almacen OR campo-c[10] = 'X' THEN DO:
    MESSAGE 'Almacen NO Habilitado para ZONIFICACION' VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-Almmmate

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 tt-Almmmate.Libre_d02 ~
tt-Almmmate.codmat tt-Almmmate.desmat tt-Almmmate.StkAct ~
tt-Almmmate.Libre_c01 tt-Almmmate.Libre_c02 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 tt-Almmmate.Libre_d02 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-3 tt-Almmmate
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-3 tt-Almmmate
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH tt-Almmmate NO-LOCK ~
    BY tt-Almmmate.Libre_d02 INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH tt-Almmmate NO-LOCK ~
    BY tt-Almmmate.Libre_d02 INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 tt-Almmmate
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 tt-Almmmate


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-3 BUTTON-1 BUTTON-2 txtCodUbi ~
btnCargar txtCodMatBuscar btnBuscar txtCodMatAdd ChkBxConfirmar ~
btnAddArticulo txtUbicDesde txtUbicHasta btnImprimir btnGrabar btnExcel ~
RECT-1 
&Scoped-Define DISPLAYED-OBJECTS txtCodAlm txtDesAlm txtCodUbi txtDesUbi ~
txtCodMatBuscar txtCodMatAdd ChkBxConfirmar txtUbicDesde txtUbicHasta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnAddArticulo 
     LABEL "Add Articulo" 
     SIZE 15 BY 1.12.

DEFINE BUTTON btnBuscar 
     LABEL "Buscar" 
     SIZE 10 BY 1.12.

DEFINE BUTTON btnCargar 
     LABEL "Cargar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON btnExcel 
     LABEL "Enviar a Excel" 
     SIZE 15 BY 1.12.

DEFINE BUTTON btnGrabar 
     LABEL "Grabar los cambios" 
     SIZE 21 BY 1.12.

DEFINE BUTTON btnImprimir 
     LABEL "Imprimir Barras Zonas" 
     SIZE 22 BY 1.12.

DEFINE BUTTON BUTTON-1 
     LABEL "BLANQUEAR TODOS de esta Zona" 
     SIZE 33.72 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "Cancelar BLANQUEO" 
     SIZE 23 BY 1.12.

DEFINE VARIABLE txtCodAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY 1
     FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE txtCodMatAdd AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE txtCodMatBuscar AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY 1 NO-UNDO.

DEFINE VARIABLE txtCodUbi AS CHARACTER FORMAT "X(8)":U 
     LABEL "Ubicacion" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesAlm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.43 BY 1
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE txtDesUbi AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 18.86 BY 1 NO-UNDO.

DEFINE VARIABLE txtUbicDesde AS CHARACTER FORMAT "X(10)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE txtUbicHasta AS CHARACTER FORMAT "X(11)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36 BY 4.04.

DEFINE VARIABLE ChkBxConfirmar AS LOGICAL INITIAL yes 
     LABEL "No pedir confirmacion" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      tt-Almmmate SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      tt-Almmmate.Libre_d02 COLUMN-LABEL "Orden" FORMAT ">>9.99":U
      tt-Almmmate.codmat FORMAT "X(6)":U WIDTH 8.14
      tt-Almmmate.desmat FORMAT "x(45)":U
      tt-Almmmate.StkAct FORMAT "(ZZZ,ZZZ,ZZ9.99)":U WIDTH 13.86
      tt-Almmmate.Libre_c01 COLUMN-LABEL "Accion" FORMAT "x(60)":U
            WIDTH 14.72
      tt-Almmmate.Libre_c02 COLUMN-LABEL "Anterior UBI" FORMAT "x(60)":U
            WIDTH 11.57
  ENABLE
      tt-Almmmate.Libre_d02
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 107.72 BY 23.27 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-3 AT ROW 3.69 COL 2.29 WIDGET-ID 200
     BUTTON-1 AT ROW 23.69 COL 115.14 WIDGET-ID 42
     BUTTON-2 AT ROW 25.23 COL 121.14 WIDGET-ID 44
     txtCodAlm AT ROW 1.96 COL 4.43 WIDGET-ID 2
     txtDesAlm AT ROW 1.96 COL 16.57 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     txtCodUbi AT ROW 1.96 COL 69.86 COLON-ALIGNED WIDGET-ID 6
     txtDesUbi AT ROW 1.92 COL 80.14 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     btnCargar AT ROW 1.85 COL 116 WIDGET-ID 10
     txtCodMatBuscar AT ROW 4.92 COL 112.86 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     btnBuscar AT ROW 6.08 COL 125.86 WIDGET-ID 14
     txtCodMatAdd AT ROW 14.54 COL 108.86 COLON-ALIGNED NO-LABEL WIDGET-ID 18 AUTO-RETURN 
     ChkBxConfirmar AT ROW 15.69 COL 117 WIDGET-ID 22
     btnAddArticulo AT ROW 16.65 COL 120 WIDGET-ID 26
     txtUbicDesde AT ROW 19.54 COL 117 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     txtUbicHasta AT ROW 19.54 COL 131 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     btnImprimir AT ROW 20.92 COL 120 WIDGET-ID 40
     btnGrabar AT ROW 8.96 COL 118.86 WIDGET-ID 24
     btnExcel AT ROW 10.69 COL 121.86 WIDGET-ID 28
     "Buscar Codigo en el Browse" VIEW-AS TEXT
          SIZE 26 BY .62 AT ROW 4.27 COL 117.14 WIDGET-ID 16
          FGCOLOR 1 
     "Agregar nuevo Codigo a la Zona" VIEW-AS TEXT
          SIZE 31 BY .62 AT ROW 13.77 COL 114 WIDGET-ID 20
          FGCOLOR 4 
     "Desde" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 18.81 COL 121 WIDGET-ID 36
     "Hasta" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 18.81 COL 134.86 WIDGET-ID 38
     RECT-1 AT ROW 18.38 COL 112.86 WIDGET-ID 34
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 151 BY 26.35 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-Almmmate T "?" NO-UNDO INTEGRAL Almmmate
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Articulos por Zonas"
         HEIGHT             = 26.35
         WIDTH              = 151
         MAX-HEIGHT         = 26.35
         MAX-WIDTH          = 151
         VIRTUAL-HEIGHT     = 26.35
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-3 1 F-Main */
/* SETTINGS FOR FILL-IN txtCodAlm IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN txtDesAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtDesUbi IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.tt-Almmmate"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.tt-Almmmate.Libre_d02|yes"
     _FldNameList[1]   > Temp-Tables.tt-Almmmate.Libre_d02
"tt-Almmmate.Libre_d02" "Orden" ">>9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-Almmmate.codmat
"tt-Almmmate.codmat" ? ? "character" ? ? ? ? ? ? no ? no no "8.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.tt-Almmmate.desmat
     _FldNameList[4]   > Temp-Tables.tt-Almmmate.StkAct
"tt-Almmmate.StkAct" ? ? "decimal" ? ? ? ? ? ? no ? no no "13.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-Almmmate.Libre_c01
"tt-Almmmate.Libre_c01" "Accion" ? "character" ? ? ? ? ? ? no ? no no "14.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-Almmmate.Libre_c02
"tt-Almmmate.Libre_c02" "Anterior UBI" ? "character" ? ? ? ? ? ? no ? no no "11.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Articulos por Zonas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Articulos por Zonas */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&Scoped-define SELF-NAME BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-3 W-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-3 IN FRAME F-Main
DO:

    DEFINE VAR s-Registro-Actual AS ROWID.
    
    IF ROWID(tt-almmmate) = ? THEN DO:
        /**/
    END.
    ELSE DO:
        IF tt-almmmate.libre_c01 <> 'RETIRAR' THEN DO:
            MESSAGE "Seguro de ELIMINAR el Codigo(" + tt-almmmate.codmat + ") ?" VIEW-AS ALERT-BOX QUESTION
                    BUTTONS YES-NO UPDATE rpta AS LOG.
            IF rpta = NO THEN RETURN NO-APPLY.

        END.

        IF tt-almmmate.libre_c01 = 'RETIRAR' THEN DO:
            ASSIGN tt-almmmate.libre_c01 = "".
        END.
        ELSE DO:
            ASSIGN tt-almmmate.libre_c01 = "RETIRAR".
        END.

        s-Registro-Actual = ROWID(tt-almmmate).
        {&OPEN-QUERY-BROWSE-3}
         REPOSITION {&BROWSE-NAME} TO ROWID s-Registro-Actual.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-Almmmate.Libre_d02
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-Almmmate.Libre_d02 BROWSE-3 _BROWSE-COLUMN W-Win
ON ANY-PRINTABLE OF tt-Almmmate.Libre_d02 IN BROWSE BROWSE-3 /* Orden */
DO:
  ASSIGN tt-almmmate.libre_c01 = 'ORDEN'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-Almmmate.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-Almmmate.codmat BROWSE-3 _BROWSE-COLUMN W-Win
ON LEFT-MOUSE-DBLCLICK OF tt-Almmmate.codmat IN BROWSE BROWSE-3 /* Codigo!Articulo */
DO:
  MESSAGE "CodMat".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-Almmmate.codmat BROWSE-3 _BROWSE-COLUMN W-Win
ON MOUSE-SELECT-DBLCLICK OF tt-Almmmate.codmat IN BROWSE BROWSE-3 /* Codigo!Articulo */
DO:
  MESSAGE "XXX".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnAddArticulo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnAddArticulo W-Win
ON CHOOSE OF btnAddArticulo IN FRAME F-Main /* Add Articulo */
DO:
  
    ASSIGN txtCodMatAdd ChkBxConfirmar txtCodUbi.

    IF lCuentaxZona < lLimitexZona THEN DO:
        IF txtCodUbi <> "" THEN DO:
            RUN ue-add-articulo.
            txtCodMatAdd:SET-SELECTION( 1 , LENGTH(txtCodMatAdd) + 2).
        END.
    END.
    ELSE DO:
        MESSAGE "Se esta excediendo el maximo de articulos x Zona" VIEW-AS ALERT-BOX.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnBuscar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnBuscar W-Win
ON CHOOSE OF btnBuscar IN FRAME F-Main /* Buscar */
DO:

  DEFINE VAR ltxtCodMat AS CHAR.
  DEFINE VAR lMsgBuscar AS CHAR.
  DEFINE VAR lCodMat AS CHAR.

  ASSIGN txtCodMatBuscar.

    ltxtCodMat = txtCodMatBuscar.
    lMsgBuscar = "".

  RUN ue-buscar-en-browse(INPUT lTxtCodMat, OUTPUT lMsgBuscar, OUTPUT lCodMat).

  IF lMsgBuscar<> "" AND lMsgBuscar<> "OK" THEN DO:
      MESSAGE lMsgBuscar VIEW-AS ALERT-BOX.
      RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnCargar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnCargar W-Win
ON CHOOSE OF btnCargar IN FRAME F-Main /* Cargar */
DO:
  ASSIGN txtCodUbi.

  RUN ue-cargar-data.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnExcel W-Win
ON CHOOSE OF btnExcel IN FRAME F-Main /* Enviar a Excel */
DO:

ASSIGN txtCodAlm txtDesAlm txtCodUbi.

  RUN ue-excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnGrabar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnGrabar W-Win
ON CHOOSE OF btnGrabar IN FRAME F-Main /* Grabar los cambios */
DO:
  RUN ue-grabar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnImprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnImprimir W-Win
ON CHOOSE OF btnImprimir IN FRAME F-Main /* Imprimir Barras Zonas */
DO:
  
    ASSIGN txtUbicDesde txtUbicHasta.

    txtUbicDesde = CAPS(txtUbicDesde).
    txtUbicHasta = CAPS(txtUbicHasta).

    RUN ue-barras-zonas.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* BLANQUEAR TODOS de esta Zona */
DO:
  
    DEFINE VAR s-Registro-Actual AS ROWID.
    
    IF ROWID(tt-almmmate) = ? THEN DO:
        /**/
    END.
    ELSE DO:

        MESSAGE "Seguro de BLANQUEAR todos los Articulos de la ZONA?" VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.

        s-Registro-Actual = ROWID(tt-almmmate).
        SESSION:SET-WAIT-STATE('GENERAL').
        FOR EACH tt-almmmate WHERE tt-almmmate.libre_c01 = "" :
            ASSIGN tt-almmmate.libre_c01 = "RETIRAR".
        END.
        SESSION:SET-WAIT-STATE('').
        
        {&OPEN-QUERY-BROWSE-3}
         REPOSITION {&BROWSE-NAME} TO ROWID s-Registro-Actual.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Cancelar BLANQUEO */
DO:
    DEFINE VAR s-Registro-Actual AS ROWID.
    
    IF ROWID(tt-almmmate) = ? THEN DO:
        /**/
    END.
    ELSE DO:

        MESSAGE "Seguro de CANCELAR BLANQUEO de la ZONA?" VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.

        SESSION:SET-WAIT-STATE('GENERAL').
        s-Registro-Actual = ROWID(tt-almmmate).
        FOR EACH tt-almmmate WHERE tt-almmmate.libre_c01 <> "" :
            ASSIGN tt-almmmate.libre_c01 = "".
        END.
        SESSION:SET-WAIT-STATE('').
        
        {&OPEN-QUERY-BROWSE-3}
         REPOSITION {&BROWSE-NAME} TO ROWID s-Registro-Actual.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCodMatAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCodMatAdd W-Win
ON LEAVE OF txtCodMatAdd IN FRAME F-Main
OR RETURN OF txtcodmatadd
    DO:
    
    ASSIGN txtCodMatAdd ChkBxConfirmar txtCodUbi.

    IF txtCodUbi <> "" AND txtCodMatAdd <> "" THEN DO:
        RUN ue-add-articulo.
        txtCodMatAdd:SET-SELECTION( 1 , LENGTH(txtCodMatAdd) + 2).
        RETURN NO-APPLY.
    END.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCodMatBuscar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCodMatBuscar W-Win
ON LEAVE OF txtCodMatBuscar IN FRAME F-Main
OR RETURN OF txtCodMatBuscar
   
        DO:
  DEFINE VAR ltxtCodMat AS CHAR.
  DEFINE VAR lMsgBuscar AS CHAR.
  DEFINE VAR lCodMat AS CHAR.

  ASSIGN txtCodMatBuscar.

    ltxtCodMat = txtCodMatBuscar.
    lMsgBuscar = "".

  RUN ue-buscar-en-browse(INPUT lTxtCodMat, OUTPUT lMsgBuscar, OUTPUT lCodMat).

  IF lMsgBuscar<> "" AND lMsgBuscar<> "OK" THEN DO:
      MESSAGE lMsgBuscar VIEW-AS ALERT-BOX.
      RETURN NO-APPLY.
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCodUbi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCodUbi W-Win
ON LEAVE OF txtCodUbi IN FRAME F-Main /* Ubicacion */
DO:
  
    txtcodubi:SCREEN-VALUE = REPLACE(txtcodubi:SCREEN-VALUE,"'","-").

    IF txtcodubi:SCREEN-VALUE <> "" THEN DO:

        DEFINE VAR lFiler AS CHAR.
    
        FIND FIRST almtubic WHERE almtubic.codcia = s-codcia AND
            almtubic.codalm = s-codalm AND
            almtubic.codubi = txtcodubi:SCREEN-VALUE NO-LOCK NO-ERROR.
    
        txtDesUbi:SCREEN-VALUE = IF(AVAILABLE almtubic) THEN almtubic.desubi ELSE "".
        lFiler = txtDesUbi:SCREEN-VALUE.
    
      /*IF lFiler = "" THEN DO:*/
      IF NOT AVAILABLE almtubic THEN DO:
          /* Ic - 05Ene2022 validacion pedida por Max Ramos */
        MESSAGE "Ubicacion no existe ò no pertenece al almcen" SKIP
                "--------------------------------------------" SKIP
                "Comuniquese con el administrador del almacen" SKIP
                "Muchas gracias" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
      END.

       ASSIGN txtCodUbi.

       RUN ue-cargar-data.

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
  DISPLAY txtCodAlm txtDesAlm txtCodUbi txtDesUbi txtCodMatBuscar txtCodMatAdd 
          ChkBxConfirmar txtUbicDesde txtUbicHasta 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-3 BUTTON-1 BUTTON-2 txtCodUbi btnCargar txtCodMatBuscar 
         btnBuscar txtCodMatAdd ChkBxConfirmar btnAddArticulo txtUbicDesde 
         txtUbicHasta btnImprimir btnGrabar btnExcel RECT-1 
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

  FIND FIRST almacen WHERE almacen.codcia = s-codcia 
      AND almacen.codalm = s-codalm NO-LOCK NO-ERROR.

  txtcodalm:SCREEN-VALUE IN FRAME {&FRAME-NAME} = s-codalm.
  txtdesalm:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF(AVAILABLE almacen) THEN almacen.descripcion ELSE "".

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
  {src/adm/template/snd-list.i "tt-Almmmate"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-add-articulo W-Win 
PROCEDURE ue-add-articulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


  DEFINE VAR ltxtCodMat AS CHAR.
  DEFINE VAR lMsgBuscar AS CHAR.
  DEFINE VAR lCodMat AS CHAR.

  DEFINE VAR s-Registro-Actual AS ROWID.

    ltxtCodMat = txtCodMatAdd.
    lMsgBuscar = "".

  RUN ue-buscar-en-browse(INPUT lTxtCodMat, OUTPUT lMsgBuscar, OUTPUT lCodMat).

  IF lMsgBuscar<> "" AND lMsgBuscar="OK" THEN DO:
      /*
      lMsgBuscar = "Codigo ya esta registrado".
      MESSAGE lMsgBuscar VIEW-AS ALERT-BOX.
      */
      RETURN NO-APPLY.
  END.

  IF lMsgBuscar<> "" THEN DO:
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
        almmmatg.codmat = lCodMat NO-LOCK NO-ERROR.

    IF NOT AVAILABLE almmmatg THEN DO:
        MESSAGE "Codigo de Articulo INEXISTENTE" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
    END.

    FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND 
        almmmate.codalm = s-codalm AND almmmate.codmat = lCodmat
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almmmate THEN DO:
        MESSAGE "Codigo de Articulo no existe en el ALMACEN (" + s-codalm + ")" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
    END.
    IF almmmate.codubi = ? OR almmmate.codubi = "" OR caps(almmmate.codubi) = 'G-0' THEN DO:
        /* Ok */
    END.
    ELSE DO:
        IF almmmate.codubi = txtCodUbi THEN DO:
            RETURN NO-APPLY.
        END.
        MESSAGE "El Articulo(" + lCodmat + ") se ubica en (" + almmmate.codubi + "), Seguro de cambiarlo?" VIEW-AS ALERT-BOX QUESTION
                    BUTTONS YES-NO UPDATE rpta2 AS LOG.
            IF rpta2 = NO THEN RETURN NO-APPLY.

    END.

    IF ChkBxConfirmar = YES THEN DO:
        MESSAGE 'Seguro de Agregar/Cambiar el Articulo?' VIEW-AS ALERT-BOX QUESTION
                    BUTTONS YES-NO UPDATE rpta AS LOG.
            IF rpta = NO THEN RETURN NO-APPLY.

    END.

    /* llevar la Cuenta */
    lCuentaxZona = lCuentaxZona + 1.

    CREATE tt-almmmate.

    ASSIGN tt-almmmate.codcia = s-codcia
            tt-almmmate.codalm = s-codalm
            tt-almmmate.undvta = almmmatg.Chr__01
            tt-almmmate.codubi = txtCodUbi
            tt-almmmate.desmat = almmmatg.desmat
            tt-almmmate.codmat = almmmatg.codmat
            tt-almmmate.codmar = almmmatg.codmar
            tt-almmmate.stkact = almmmate.Stkact
            tt-almmmate.libre_d02 = lCuentaxZona
            tt-almmmate.libre_c01 = 'NUEVO'
            tt-almmmate.libre_c02 = if(AVAILABLE almmmate) THEN almmmate.codubi ELSE "".            

    s-Registro-Actual = ROWID(tt-almmmate).

    {&OPEN-QUERY-BROWSE-3}

     REPOSITION {&BROWSE-NAME} TO ROWID s-Registro-Actual.
    

    /*IF NOT AVAILABLE almmmate THEN DO:
        
        CREATE tt-almmmate.
        
        ASSIGN tt-almmmate.codcia = s-codcia
                tt-almmmate.codalm = s-codalm
                tt-almmmate.undvta = almmmatg.Chr__01
                tt-almmmate.codubi = txtCodUbi
                tt-almmmate.desmat = almmmatg.desmat
                tt-almmmate.codmat = almmmatg.codmat
                tt-almmmate.codmar = almmmatg.codmar
                tt-almmmate.libre_c01 = 'NUEVO'.
        
    END.
    ELSE DO: 
        ASSIGN tt-almmmate.libre_c01 = 'CAMBIO'
                tt-almmmate.libre_c02 = almmmate.codubi.
    END.
*/


  END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-barras-zonas W-Win 
PROCEDURE ue-barras-zonas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE L-Ubica   AS LOGICAL INIT YES NO-UNDO.        
DEFINE VARIABLE lEtq AS INT.
DEFINE VAR lRegs AS INT.

IF txtUbicDesde = "" OR txtUbicHasta = "" THEN DO:
    RETURN NO-APPLY.
END.

REPEAT WHILE L-Ubica:
       s-task-no = RANDOM(900000,999999).
       FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
       IF NOT AVAILABLE w-report THEN L-Ubica = NO.
END.

letq = 100.
lRegs = 0.
FOR EACH almtubic WHERE almtubic.codcia = s-codcia AND 
        almtubic.codalm = s-codalm AND
        (almtubic.codubi >= txtUbicDesde AND almtubic.codubi <= txtUbicHasta) 
        NO-LOCK :
    IF letq > 2  THEN DO:
        lRegs = lRegs + 1.
        lEtq = 1.
        CREATE w-report.
            ASSIGN w-report.Task-No  = s-task-no
                w-report.Llave-C  = "01-" + STRING(lRegs,"9999999").
    END.
    ASSIGN w-report.Campo-C[lEtq] = "*" + almtubic.codubi + "*"
            w-report.Campo-C[lEtq + 4] = almtubic.codubi
            w-report.Campo-C[4] = "Alm : " + s-codalm.

    lEtq = lEtq + 1.
END.

    /* Code placed here will execute PRIOR to standard behavior. */
    DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
    DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
    DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
    DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
    DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

    GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'alm/rbalm.prl'.
    /*RB-REPORT-NAME = 'RotuloxPedidos-1'.*/
    RB-REPORT-NAME = 'Ubicacion almacenes barras v2'.
    RB-INCLUDE-RECORDS = 'O'.

    RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
    RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                       RB-REPORT-NAME,
                       RB-INCLUDE-RECORDS,
                       RB-FILTER,
                       RB-OTHER-PARAMETERS).




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-buscar-en-browse W-Win 
PROCEDURE ue-buscar-en-browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER ptxtCodMatBuscar AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER pMsgBuscar AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER ptxtCodMat AS CHAR    NO-UNDO.

pMsgBuscar = "".

IF ptxtCodMatBuscar = "" THEN DO:
    RETURN NO-APPLY.
END.

DEFINE VAR lCodMat AS CHAR.
DEFINE VAR lCodEan AS CHAR.
DEFINE VAR s-Registro-Actual AS ROWID.

lCodMat = trim(ptxtCodMatBuscar).
lCodEan = "".
ptxtCodMat = lCodMat.

IF LENGTH(lCodMat) > 6 THEN DO:
    lCodEan = lCodMat.
    /* Lo Busco como EAN13 */
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
        almmmatg.codbrr = lCodEan NO-LOCK NO-ERROR.
    IF AVAILABLE almmmatg THEN lCodMat = almmmatg.codmat.

    IF lCodEan = lCodMat THEN DO:
        /* Lo busco como EAN14 */
        FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND
            almmmat1.barras[1] = lCodEan NO-LOCK NO-ERROR.
        IF AVAILABLE almmmat1 THEN lCodMat = almmmat1.codmat.

        IF lCodEan = lCodMat THEN DO:
            FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND
                almmmat1.barras[2] = lCodEan NO-LOCK NO-ERROR.
            IF AVAILABLE almmmat1 THEN lCodMat = almmmat1.codmat.
        END.
        IF lCodEan = lCodMat THEN DO:
            FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND
                almmmat1.barras[3] = lCodEan NO-LOCK NO-ERROR.
            IF AVAILABLE almmmat1 THEN lCodMat = almmmat1.codmat.
        END.
    END.
    ptxtCodMat = lCodMat.
    IF lCodEan = lCodMat THEN DO:
        /*MESSAGE "Codigo EAN no existe" VIEW-AS ALERT-BOX.*/
        pMsgBuscar = "Codigo EAN no existe".
        RETURN NO-APPLY.
    END.
END.

FIND FIRST tt-almmmate WHERE tt-almmmate.codmat = lCodMat 
    NO-LOCK NO-ERROR.

IF NOT AVAILABLE tt-almmmate THEN DO:
    pMsgBuscar = "No existe Codigo".
    /*MESSAGE "No existe Codigo" VIEW-AS ALERT-BOX.*/
    RETURN NO-APPLY.
END.

ptxtCodMat = lCodMat.
pMsgBuscar = "OK".  /* Existe en el Browse */

s-Registro-Actual = ROWID(tt-almmmate).

REPOSITION {&BROWSE-NAME} TO ROWID s-Registro-Actual.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-cargar-data W-Win 
PROCEDURE ue-cargar-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-almmmate.

SESSION:SET-WAIT-STATE('GENERAL').

lCuentaxZona = 0.

FOR EACH almmmate WHERE almmmate.codcia = s-codcia AND almmmate.codalm = s-codalm 
    AND almmmate.codubi = txtCodUbi NO-LOCK:

    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
        almmmatg.codmat = almmmate.codmat NO-LOCK NO-ERROR.

    lCuentaxZona = lCuentaxZona + 1.

    CREATE tt-almmmate.
        BUFFER-COPY almmmate TO tt-almmmate.

        ASSIGN tt-almmmate.libre_c01 = ""   /* ELIMINAR, ADD */
               tt-almmmate.libre_c02 = ""
            tt-almmmate.desmat = IF(AVAILABLE almmmatg) THEN almmmatg.desmat ELSE "** ERROR **".
        IF tt-almmmate.libre_d02 = 0 THEN DO:
            ASSIGN tt-almmmate.libre_d02 = lCuentaxZona
                    tt-almmmate.libre_c01 = 'ORDEN'.
        END.
    
END.

FIND FIRST tt-almmmate NO-LOCK NO-ERROR.

{&OPEN-QUERY-BROWSE-3}

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-excel W-Win 
PROCEDURE ue-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

MESSAGE "Seguro de Generar Excel?" VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.


        DEFINE VARIABLE lFileXls                 AS CHARACTER.
        DEFINE VARIABLE lNuevoFile               AS LOG.

        lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
        lNuevoFile = YES.       /* YES : Si va crear un nuevo archivo o abrir */

        {lib\excel-open-file.i}

        iColumn = 1.
    cColumn = STRING(iColumn).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Almacen:" + txtCodAlm + " - " + txtDesAlm + " / Ubicacion :" + txtCodUbi.

    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "CodArticulo".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Descripcion".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Accion".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Ubic.Anterior".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Stock".


        FOR EACH tt-almmmate NO-LOCK :
             iColumn = iColumn + 1.
             cColumn = STRING(iColumn).

             cRange = "A" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + tt-almmmate.codmat.
             cRange = "B" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + tt-almmmate.desmat.
             cRange = "C" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + tt-almmmate.libre_c01.
             cRange = "D" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + tt-almmmate.libre_c02.
             cRange = "E" + cColumn.
             chWorkSheet:Range(cRange):Value = tt-almmmate.Stkact.

        END.

        {lib\excel-close-file.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-grabar W-Win 
PROCEDURE ue-grabar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

MESSAGE "Seguro de Grabar?" VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.

DEF VAR x-CodUbiIni AS CHAR NO-UNDO.
DEF VAR x-CodUbiFin AS CHAR NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.

FOR EACH tt-almmmate WHERE tt-almmmate.libre_c01 <> "" :
    FIND FIRST almmmate WHERE almmmate.codcia = tt-almmmate.codcia AND
        almmmate.codalm = tt-almmmate.codalm AND
        almmmate.codmat = tt-almmmate.codmat EXCLUSIVE NO-ERROR.
    IF AVAILABLE almmmate THEN DO:
        x-CodUbiIni = Almmmate.CodUbi.
        ASSIGN 
            almmmate.codubi = if(tt-almmmate.libre_c01 = "RETIRAR") THEN "G-0" ELSE tt-almmmate.codubi
            almmmate.desmat = tt-almmmate.desmat
            almmmate.codmar = tt-almmmate.codmar
            almmmate.undvta = tt-almmmate.undvta
            almmmate.libre_d02 = tt-almmmate.libre_d02.
        x-CodUbiFin = Almmmate.CodUbi.
        /* 11/08/2022
        {alm/i-logubimat-01.i &iAlmmmate="Almmmate"}
        */
    END.
    ASSIGN tt-almmmate.libre_c01 = "".
END.

RELEASE almmmate.

EMPTY TEMP-TABLE tt-almmmate.
/*FIND FIRST tt-almmmate NO-LOCK NO-ERROR.*/
{&OPEN-QUERY-BROWSE-3}



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

