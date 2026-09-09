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
&Scoped-define INTERNAL-TABLES Clf_Acumulador DimClfAcumulador ~
DimClfCatContable Clf_Clasificaciones Clf_Agrupador

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 DimClfAcumulador.Descripcion ~
Clf_Acumulador.Peso 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH Clf_Acumulador NO-LOCK, ~
      EACH DimClfAcumulador OF Clf_Acumulador NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH Clf_Acumulador NO-LOCK, ~
      EACH DimClfAcumulador OF Clf_Acumulador NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 Clf_Acumulador DimClfAcumulador
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 Clf_Acumulador
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 DimClfAcumulador


/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 DimClfCatContable.Codigo ~
DimClfCatContable.Descripcion 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH DimClfCatContable WHERE TRUE /* Join to Clf_Agrupador incomplete */ NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH DimClfCatContable WHERE TRUE /* Join to Clf_Agrupador incomplete */ NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 DimClfCatContable
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 DimClfCatContable


/* Definitions for BROWSE BROWSE-7                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-7 Clf_Clasificaciones.Codigo ~
Clf_Clasificaciones.Valor_Campana Clf_Clasificaciones.Valor_No_Campana 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-7 
&Scoped-define QUERY-STRING-BROWSE-7 FOR EACH Clf_Clasificaciones WHERE TRUE /* Join to Clf_Agrupador incomplete */ NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-7 OPEN QUERY BROWSE-7 FOR EACH Clf_Clasificaciones WHERE TRUE /* Join to Clf_Agrupador incomplete */ NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-7 Clf_Clasificaciones
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-7 Clf_Clasificaciones


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-5}~
    ~{&OPEN-QUERY-BROWSE-7}
&Scoped-define QUERY-STRING-F-Main FOR EACH Clf_Agrupador SHARE-LOCK
&Scoped-define OPEN-QUERY-F-Main OPEN QUERY F-Main FOR EACH Clf_Agrupador SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-F-Main Clf_Agrupador
&Scoped-define FIRST-TABLE-IN-QUERY-F-Main Clf_Agrupador


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-3 RECT-4 BUTTON-1 ~
COMBO-BOX_Id_Agrupador BROWSE-2 BROWSE-5 BROWSE-7 ~
COMBO-BOX_Id_Periodo_Actual 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX_Id_Agrupador EDITOR_Divisiones ~
COMBO-BOX_Id_Periodo_Actual FILL-IN_Periodo_Actual FILL-IN_FchIni_Actual ~
FILL-IN_FchFin_Actual COMBO-BOX_Tipo_Calculo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_q-clf-cfg-general AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-clf-cfg-general AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "PROCESAR" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX_Id_Agrupador AS INT64 FORMAT ">>>,>>>,>>9":U INITIAL ? 
     LABEL "Agrupador" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Base",1
     DROP-DOWN-LIST
     SIZE 23 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_Id_Periodo_Actual AS INT64 FORMAT ">>>,>>>,>>9":U INITIAL ? 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Base",1
     DROP-DOWN-LIST
     SIZE 23 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_Tipo_Calculo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo de Cálculo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "POR VALOR","PV",
                     "POR PROPORCION DEL MAYOR","PPM"
     DROP-DOWN-LIST
     SIZE 30 BY 1 NO-UNDO.

DEFINE VARIABLE EDITOR_Divisiones AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 57 BY 7.54.

DEFINE VARIABLE FILL-IN_FchFin_Actual AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de Término" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_FchIni_Actual AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de Inicio" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Periodo_Actual AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Año" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 6.19.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 9.42.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41 BY 4.58.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      Clf_Acumulador, 
      DimClfAcumulador SCROLLING.

DEFINE QUERY BROWSE-5 FOR 
      DimClfCatContable SCROLLING.

DEFINE QUERY BROWSE-7 FOR 
      Clf_Clasificaciones SCROLLING.

DEFINE QUERY F-Main FOR 
      Clf_Agrupador SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      DimClfAcumulador.Descripcion FORMAT "x(40)":U WIDTH 19.43
      Clf_Acumulador.Peso FORMAT ">>>,>>9.99":U WIDTH 10.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-LABELS NO-ROW-MARKERS SIZE 34 BY 4.58
         FONT 4
         TITLE "ACUMULADORES" ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      DimClfCatContable.Codigo FORMAT "x(8)":U
      DimClfCatContable.Descripcion FORMAT "x(40)":U WIDTH 24.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-LABELS NO-ROW-MARKERS SIZE 34 BY 2.96
         FONT 4
         TITLE "CATEGORIAS CONTABLES" ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-7 W-Win _STRUCTURED
  QUERY BROWSE-7 NO-LOCK DISPLAY
      Clf_Clasificaciones.Codigo COLUMN-LABEL "Clasificación" FORMAT "x(8)":U
            WIDTH 9.43
      Clf_Clasificaciones.Valor_Campana COLUMN-LABEL "CAMPAÑA" FORMAT ">>>,>>9.9999":U
      Clf_Clasificaciones.Valor_No_Campana COLUMN-LABEL "NO CAMPAÑA" FORMAT ">>>,>>9.9999":U
            WIDTH 10.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 34 BY 6.19
         FONT 4
         TITLE "CLASIFICACIONES" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1.27 COL 82 WIDGET-ID 36
     COMBO-BOX_Id_Agrupador AT ROW 1.54 COL 19 COLON-ALIGNED WIDGET-ID 26
     EDITOR_Divisiones AT ROW 2.62 COL 21 NO-LABEL WIDGET-ID 28
     BROWSE-2 AT ROW 2.62 COL 82 WIDGET-ID 200
     BROWSE-5 AT ROW 7.46 COL 82 WIDGET-ID 300
     BROWSE-7 AT ROW 10.69 COL 82 WIDGET-ID 400
     COMBO-BOX_Id_Periodo_Actual AT ROW 11.23 COL 19 COLON-ALIGNED WIDGET-ID 2
     FILL-IN_Periodo_Actual AT ROW 12.31 COL 19 COLON-ALIGNED WIDGET-ID 4
     FILL-IN_FchIni_Actual AT ROW 13.38 COL 19 COLON-ALIGNED WIDGET-ID 6
     FILL-IN_FchFin_Actual AT ROW 14.46 COL 19 COLON-ALIGNED WIDGET-ID 8
     COMBO-BOX_Tipo_Calculo AT ROW 15.54 COL 19 COLON-ALIGNED WIDGET-ID 38
     "CONFIGURACIONES GENERALES" VIEW-AS TEXT
          SIZE 40 BY .81 AT ROW 2.69 COL 116.43 WIDGET-ID 42
          BGCOLOR 8 FGCOLOR 0 
     "Divisiones:" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2.88 COL 13 WIDGET-ID 32
     "Seleccione periodo de cálculo" VIEW-AS TEXT
          SIZE 28 BY .5 AT ROW 10.42 COL 3 WIDGET-ID 20
          BGCOLOR 1 FGCOLOR 15 
     "Seleccione agrupador" VIEW-AS TEXT
          SIZE 28 BY .5 AT ROW 1 COL 3 WIDGET-ID 30
          BGCOLOR 1 FGCOLOR 15 
     RECT-1 AT ROW 10.69 COL 2 WIDGET-ID 18
     RECT-3 AT ROW 1.27 COL 2 WIDGET-ID 34
     RECT-4 AT ROW 2.62 COL 116 WIDGET-ID 40
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 157.29 BY 16.15
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
         TITLE              = "PRE-CALCULO"
         HEIGHT             = 16.15
         WIDTH              = 157.29
         MAX-HEIGHT         = 38.81
         MAX-WIDTH          = 274.29
         VIRTUAL-HEIGHT     = 38.81
         VIRTUAL-WIDTH      = 274.29
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
/* BROWSE-TAB BROWSE-2 EDITOR_Divisiones F-Main */
/* BROWSE-TAB BROWSE-5 BROWSE-2 F-Main */
/* BROWSE-TAB BROWSE-7 BROWSE-5 F-Main */
/* SETTINGS FOR COMBO-BOX COMBO-BOX_Tipo_Calculo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR EDITOR_Divisiones IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_FchFin_Actual IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_FchIni_Actual IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Periodo_Actual IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "integral.Clf_Acumulador,integral.DimClfAcumulador OF integral.Clf_Acumulador"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > integral.DimClfAcumulador.Descripcion
"DimClfAcumulador.Descripcion" ? ? "character" ? ? ? ? ? ? no ? no no "19.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.Clf_Acumulador.Peso
"Clf_Acumulador.Peso" ? ? "decimal" ? ? ? ? ? ? no ? no no "10.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "integral.DimClfCatContable WHERE integral.Clf_Agrupador <external> ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = integral.DimClfCatContable.Codigo
     _FldNameList[2]   > integral.DimClfCatContable.Descripcion
"DimClfCatContable.Descripcion" ? ? "character" ? ? ? ? ? ? no ? no no "24.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-7
/* Query rebuild information for BROWSE BROWSE-7
     _TblList          = "integral.Clf_Clasificaciones WHERE integral.Clf_Agrupador <external> ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > integral.Clf_Clasificaciones.Codigo
"Clf_Clasificaciones.Codigo" "Clasificación" ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.Clf_Clasificaciones.Valor_Campana
"Clf_Clasificaciones.Valor_Campana" "CAMPAÑA" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.Clf_Clasificaciones.Valor_No_Campana
"Clf_Clasificaciones.Valor_No_Campana" "NO CAMPAÑA" ? "decimal" ? ? ? ? ? ? no ? no no "10.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-7 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _TblList          = "integral.Clf_Agrupador"
     _Query            is OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* PRE-CALCULO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* PRE-CALCULO */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* PROCESAR */
DO:
    MESSAGE 
        'Los resultados temporales se van a guardar en tablas temporales' SKIP
        'Si ha hecho cálculos anteriormente se van a borrar' SKIP
        'Procedemos a procesar?' 
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.

    ASSIGN FRAME {&FRAME-NAME}
        COMBO-BOX_Id_Agrupador
        COMBO-BOX_Id_Periodo_Actual
        COMBO-BOX_Tipo_Calculo
        EDITOR_Divisiones
        FILL-IN_FchFin_Actual
        FILL-IN_FchIni_Actual
        FILL-IN_Periodo_Actual
        .

    DEFINE VAR hProc AS HANDLE NO-UNDO.

    RUN clf\clasificacion-articulos-proceso.r PERSISTENT SET hProc.

    DEFINE VAR cRetVal AS CHAR.

    /* Procedimientos */
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN calcular_clasificacion IN hProc (INPUT COMBO-BOX_Id_Periodo_Actual,
                                         INPUT COMBO-BOX_Id_Agrupador,
                                         INPUT NO,
                                         INPUT YES,
                                         OUTPUT cRetVal).
    SESSION:SET-WAIT-STATE('').

    DELETE PROCEDURE hProc.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF cRetVal > '' THEN MESSAGE cRetVal VIEW-AS ALERT-BOX WARNING.
    END.
    ELSE MESSAGE "PROCESO TERMINADO" VIEW-AS ALERT-BOX INFORMATION.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX_Id_Agrupador
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_Id_Agrupador W-Win
ON VALUE-CHANGED OF COMBO-BOX_Id_Agrupador IN FRAME F-Main /* Agrupador */
DO:
  ASSIGN {&SELF-NAME}.
  FIND Clf_Agrupador WHERE Clf_Agrupador.Id_Agrupador = {&SELF-NAME} NO-LOCK.
  IF AVAILABLE Clf_Agrupador THEN DO:
      EDITOR_Divisiones:SCREEN-VALUE = Clf_Agrupador.Divisiones.
  END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX_Id_Periodo_Actual
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_Id_Periodo_Actual W-Win
ON VALUE-CHANGED OF COMBO-BOX_Id_Periodo_Actual IN FRAME F-Main /* Periodo */
DO:
  ASSIGN {&SELF-NAME}.
  FIND Clf_Periodos WHERE Clf_Periodos.Id_Periodo = {&SELF-NAME} NO-LOCK.
  IF AVAILABLE Clf_Periodos THEN DO:
      DISPLAY
          Clf_Periodos.Fecha_Inicio @ FILL-IN_FchIni_Actual
          Clf_Periodos.Fecha_Termino @ FILL-IN_FchFin_Actual
          Clf_Periodos.Periodo @ FILL-IN_Periodo_Actual
          WITH FRAME {&FRAME-NAME}
          .
      COMBO-BOX_Tipo_Calculo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Clf_Periodos.Tipo_Calculo.
  END.
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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/clf/v-clf-cfg-general.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-clf-cfg-general ).
       RUN set-position IN h_v-clf-cfg-general ( 3.69 , 117.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.15 , 37.72 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/clf/q-clf-cfg-general.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-clf-cfg-general ).
       RUN set-position IN h_q-clf-cfg-general ( 1.00 , 146.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.50 , 7.72 ) */

       /* Links to SmartViewer h_v-clf-cfg-general. */
       RUN add-link IN adm-broker-hdl ( h_q-clf-cfg-general , 'Record':U , h_v-clf-cfg-general ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-clf-cfg-general ,
             BROWSE-2:HANDLE IN FRAME F-Main , 'AFTER':U ).
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

  {&OPEN-QUERY-F-Main}
  GET FIRST F-Main.
  DISPLAY COMBO-BOX_Id_Agrupador EDITOR_Divisiones COMBO-BOX_Id_Periodo_Actual 
          FILL-IN_Periodo_Actual FILL-IN_FchIni_Actual FILL-IN_FchFin_Actual 
          COMBO-BOX_Tipo_Calculo 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-3 RECT-4 BUTTON-1 COMBO-BOX_Id_Agrupador BROWSE-2 BROWSE-5 
         BROWSE-7 COMBO-BOX_Id_Periodo_Actual 
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
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX_Id_Agrupador:DELETE(1).
      FOR EACH Clf_Agrupador NO-LOCK BY integral.Clf_Agrupador.Id_Agrupador DESC:
          COMBO-BOX_Id_Agrupador:ADD-LAST(Clf_Agrupador.Codigo, Clf_Agrupador.Id_Agrupador).
          ASSIGN
              COMBO-BOX_Id_Agrupador = Clf_Agrupador.Id_Agrupador
              EDITOR_Divisiones = Clf_Agrupador.Divisiones
              .
      END.

      COMBO-BOX_Id_Periodo_Actual:DELETE(1).
      FOR EACH Clf_Periodos NO-LOCK 
          BY Clf_Periodos.Periodo BY Clf_Periodos.Fecha_Inicio DESCENDING:
          COMBO-BOX_Id_Periodo_Actual:ADD-LAST(Clf_Periodos.Descripcion, Clf_Periodos.Id_Periodo).
          ASSIGN
              COMBO-BOX_Id_Periodo_Actual = Clf_Periodos.Id_Periodo
              FILL-IN_Periodo_Actual =  Clf_Periodos.Periodo
              FILL-IN_FchFin_Actual = Clf_Periodos.Fecha_Termino
              FILL-IN_FchIni_Actual = Clf_Periodos.Fecha_Inicio 
              COMBO-BOX_Tipo_Calculo = Clf_Periodos.Tipo_Calculo
              .
      END.

/*       COMBO-BOX_Id_Periodo_Anterior:DELETE(1).                                                       */
/*       FOR EACH Clf_Periodos NO-LOCK                                                                  */
/*           BY Clf_Periodos.Periodo BY Clf_Periodos.Fecha_Inicio DESCENDING:                           */
/*           COMBO-BOX_Id_Periodo_Anterior:ADD-LAST(Clf_Periodos.Descripcion, Clf_Periodos.Id_Periodo). */
/*           ASSIGN                                                                                     */
/*               COMBO-BOX_Id_Periodo_Anterior = Clf_Periodos.Id_Periodo                                */
/*               FILL-IN_Periodo_Anterior =  Clf_Periodos.Periodo                                       */
/*               FILL-IN_FchFin_Anterior = Clf_Periodos.Fecha_Termino                                   */
/*               FILL-IN_FchIni_Anterior = Clf_Periodos.Fecha_Inicio                                    */
/*               .                                                                                      */
/*       END.                                                                                           */

  END.

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
  {src/adm/template/snd-list.i "Clf_Agrupador"}
  {src/adm/template/snd-list.i "Clf_Clasificaciones"}
  {src/adm/template/snd-list.i "DimClfCatContable"}
  {src/adm/template/snd-list.i "Clf_Acumulador"}
  {src/adm/template/snd-list.i "DimClfAcumulador"}

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

