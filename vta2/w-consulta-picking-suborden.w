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
* Code is Progress IDE code released to open/ source December 1, 2000.*
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

DEFINE NEW SHARED VAR ltxtDesde AS DATE.
DEFINE NEW SHARED VAR ltxtHasta AS DATE.
DEFINE NEW SHARED VAR lChequeados AS LOGICAL.
DEFINE NEW SHARED VAR pSoloImpresos AS LOGICAL.
DEFINE NEW SHARED VAR s-CodDoc AS CHAR INIT 'O/D'.
DEFINE NEW SHARED VAR s-busqueda AS CHAR.
DEFINE NEW SHARED VAR i-tipo-busqueda AS INT.

DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE NEW SHARED VARIABLE lMsgRetorno  AS CHAR.

DEF SHARED VAR s-coddiv AS CHAR.
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
&Scoped-define BROWSE-NAME BROWSE-5

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-w-report

/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 tt-w-report.Campo-C[1] ~
tt-w-report.Campo-C[2] tt-w-report.Campo-C[10] tt-w-report.Campo-C[14] ~
tt-w-report.Campo-C[3] tt-w-report.Campo-C[4] tt-w-report.Campo-C[13] ~
tt-w-report.Campo-C[5] tt-w-report.Campo-C[6] tt-w-report.Campo-C[7] ~
tt-w-report.Campo-I[1] tt-w-report.Campo-F[2] tt-w-report.Campo-F[3] ~
tt-w-report.Campo-C[11] tt-w-report.Campo-C[12] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 tt-w-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RADIO-SET-CodDoc RECT-2 BUTTON-Excxel ~
BtnDone BUTTON-13 rsSectores txtDesde txtHasta cbSituacion BUTTON-14 ~
BROWSE-5 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-CodDoc rsSectores txtDesde ~
txtHasta cbSituacion txtLeyenda 

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
DEFINE VARIABLE h_b-consulta-picking-suborden AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 7 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-13 
     IMAGE-UP FILE "img/reload.ico":U
     LABEL "REFRESCAR" 
     SIZE 7 BY 1.54 TOOLTIP "Recargar datos".

DEFINE BUTTON BUTTON-14 
     LABEL "Excel - Subordenes" 
     SIZE 20 BY 1.12.

DEFINE BUTTON BUTTON-Excxel 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "EXCEL" 
     SIZE 7 BY 1.54.

DEFINE VARIABLE cbSituacion AS CHARACTER FORMAT "X(40)":U INITIAL "< Todos >" 
     LABEL "Situacion" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 20
     LIST-ITEM-PAIRS "< Todos >","< Todos >",
                     "1. SIN EMPEZAR","SIN EMPEZAR",
                     "7. COMPLETADO","COMPLETADO",
                     "5. PARCIALMENTE IMPRESOS","PARCIALMENTE IMPRESOS",
                     "2. SOLO IMPRESOS","SOLO IMPRESOS",
                     "4. AVANCE PARCIAL","AVANCE PARCIAL",
                     "3. SOLO ASIGNADOS","SOLO ASIGNADOS",
                     "6. ASIGNADO PARCIAL","ASIGNADO PARCIAL",
                     "8. FACTURADO/G.REMISION","FACTURADO/G.REMISION"
     DROP-DOWN-LIST
     SIZE 32 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtLeyenda AS CHARACTER FORMAT "X(150)":U 
     VIEW-AS FILL-IN 
     SIZE 109.86 BY 1
     BGCOLOR 15 FGCOLOR 4 FONT 10 NO-UNDO.

DEFINE VARIABLE RADIO-SET-CodDoc AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Orden de Despacho (O/D)", "O/D",
"Orden de Mostrador (O/M)", "O/M",
"Orden de Transferencia (OTR)", "OTR",
"Todos", "Todos"
     SIZE 98 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE rsSectores AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todos", 1,
"x Asignar", 2,
"x Recepcionar", 3,
"Todos asignados", 4
     SIZE 18 BY 2.46 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 21 BY 3.08.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      tt-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      tt-w-report.Campo-C[1] COLUMN-LABEL "Sector" FORMAT "X(3)":U
            WIDTH 5
      tt-w-report.Campo-C[2] COLUMN-LABEL "Pickeador" FORMAT "X(10)":U
            WIDTH 7.86
      tt-w-report.Campo-C[10] COLUMN-LABEL "Nombre Pickeador" FORMAT "X(30)":U
      tt-w-report.Campo-C[14] COLUMN-LABEL "Impresion" FORMAT "X(25)":U
            WIDTH 19.86
      tt-w-report.Campo-C[3] COLUMN-LABEL "Fec/Hora!Sacado" FORMAT "X(25)":U
            WIDTH 16.86
      tt-w-report.Campo-C[4] COLUMN-LABEL "Fec/Hora!Recep." FORMAT "X(25)":U
            WIDTH 17.43
      tt-w-report.Campo-C[13] COLUMN-LABEL "Tiempo" FORMAT "X(25)":U
            WIDTH 17.29
      tt-w-report.Campo-C[5] COLUMN-LABEL "Zona!Pickeo" FORMAT "X(4)":U
      tt-w-report.Campo-C[6] COLUMN-LABEL "User!Asigna" FORMAT "X(10)":U
            WIDTH 8.72
      tt-w-report.Campo-C[7] COLUMN-LABEL "User!Recepc." FORMAT "X(10)":U
            WIDTH 8.43
      tt-w-report.Campo-I[1] COLUMN-LABEL "Itms" FORMAT ">,>>9":U
      tt-w-report.Campo-F[2] COLUMN-LABEL "Peso" FORMAT "->>>,>>>,>>9.9999":U
            WIDTH 7.43
      tt-w-report.Campo-F[3] COLUMN-LABEL "Volumen" FORMAT "->>>,>>>,>>9.9999":U
            WIDTH 7.72
      tt-w-report.Campo-C[11] COLUMN-LABEL "Sup. Asignacion" FORMAT "X(30)":U
      tt-w-report.Campo-C[12] COLUMN-LABEL "Sup. Recepcion" FORMAT "X(30)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 143 BY 7.5
         FONT 4 ROW-HEIGHT-CHARS .46 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-SET-CodDoc AT ROW 1 COL 1 NO-LABEL WIDGET-ID 36
     BUTTON-Excxel AT ROW 1.19 COL 130 WIDGET-ID 76
     BtnDone AT ROW 1.19 COL 137 WIDGET-ID 10
     BUTTON-13 AT ROW 1.27 COL 123 WIDGET-ID 4
     rsSectores AT ROW 1.77 COL 103 NO-LABEL WIDGET-ID 66
     txtDesde AT ROW 2.73 COL 8 COLON-ALIGNED WIDGET-ID 16
     txtHasta AT ROW 2.73 COL 30 COLON-ALIGNED WIDGET-ID 20
     cbSituacion AT ROW 2.73 COL 57 COLON-ALIGNED WIDGET-ID 74
     BUTTON-14 AT ROW 3.08 COL 123 WIDGET-ID 78
     BROWSE-5 AT ROW 17.73 COL 2 WIDGET-ID 200
     txtLeyenda AT ROW 25.42 COL 2 NO-LABEL WIDGET-ID 64
     "  Sectores" VIEW-AS TEXT
          SIZE 9.57 BY .62 AT ROW 1 COL 101 WIDGET-ID 72
          FGCOLOR 4 FONT 6
     RECT-2 AT ROW 1.38 COL 101 WIDGET-ID 70
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.57 BY 25.54 WIDGET-ID 100.


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
         TITLE              = "CONSULTA AVANCE DE ORDENES PICKEO"
         HEIGHT             = 25.54
         WIDTH              = 144.57
         MAX-HEIGHT         = 27.38
         MAX-WIDTH          = 159.43
         VIRTUAL-HEIGHT     = 27.38
         VIRTUAL-WIDTH      = 159.43
         MAX-BUTTON         = no
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
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-5 BUTTON-14 F-Main */
/* SETTINGS FOR FILL-IN txtLeyenda IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-C[1]
"tt-w-report.Campo-C[1]" "Sector" "X(3)" "character" ? ? ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[2]
"tt-w-report.Campo-C[2]" "Pickeador" "X(10)" "character" ? ? ? ? ? ? no ? no no "7.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-C[10]
"tt-w-report.Campo-C[10]" "Nombre Pickeador" "X(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report.Campo-C[14]
"tt-w-report.Campo-C[14]" "Impresion" "X(25)" "character" ? ? ? ? ? ? no ? no no "19.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-w-report.Campo-C[3]
"tt-w-report.Campo-C[3]" "Fec/Hora!Sacado" "X(25)" "character" ? ? ? ? ? ? no ? no no "16.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-w-report.Campo-C[4]
"tt-w-report.Campo-C[4]" "Fec/Hora!Recep." "X(25)" "character" ? ? ? ? ? ? no ? no no "17.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-w-report.Campo-C[13]
"tt-w-report.Campo-C[13]" "Tiempo" "X(25)" "character" ? ? ? ? ? ? no ? no no "17.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-w-report.Campo-C[5]
"tt-w-report.Campo-C[5]" "Zona!Pickeo" "X(4)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-w-report.Campo-C[6]
"tt-w-report.Campo-C[6]" "User!Asigna" "X(10)" "character" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-w-report.Campo-C[7]
"tt-w-report.Campo-C[7]" "User!Recepc." "X(10)" "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tt-w-report.Campo-I[1]
"tt-w-report.Campo-I[1]" "Itms" ">,>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.tt-w-report.Campo-F[2]
"tt-w-report.Campo-F[2]" "Peso" ? "decimal" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.tt-w-report.Campo-F[3]
"tt-w-report.Campo-F[3]" "Volumen" ? "decimal" ? ? ? ? ? ? no ? no no "7.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.tt-w-report.Campo-C[11]
"tt-w-report.Campo-C[11]" "Sup. Asignacion" "X(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.tt-w-report.Campo-C[12]
"tt-w-report.Campo-C[12]" "Sup. Recepcion" "X(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONSULTA AVANCE DE ORDENES PICKEO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONSULTA AVANCE DE ORDENES PICKEO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-13 W-Win
ON CHOOSE OF BUTTON-13 IN FRAME F-Main /* REFRESCAR */
DO:
    ASSIGN txtDesde txtHasta rsSectores cbSituacion.
    ltxtDesde = txtDesde.
    ltxtHasta = txtHasta.
    
    i-tipo-busqueda = rsSectores.
    s-busqueda = cbSituacion.

    RUN Carga-Temporal IN h_b-consulta-picking-suborden.
    RUN dispatch IN h_b-consulta-picking-suborden ('open-query':U).
    RUN Procesa-Handle IN lh_handle ('Enable-Buttons').

    {&OPEN-QUERY-BROWSE-5}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-14 W-Win
ON CHOOSE OF BUTTON-14 IN FRAME F-Main /* Excel - Subordenes */
DO:
    RUN Excel-subordenes IN h_b-consulta-picking-suborden.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Excxel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Excxel W-Win
ON CHOOSE OF BUTTON-Excxel IN FRAME F-Main /* EXCEL */
DO:
    RUN Excel IN h_b-consulta-picking-suborden.
    /*RUN Excel-subordenes IN h_b-consulta-picking-suborden.*/
    MESSAGE 'Proceso concluido' VIEW-AS ALERT-BOX.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cbSituacion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cbSituacion W-Win
ON VALUE-CHANGED OF cbSituacion IN FRAME F-Main /* Situacion */
DO:
    ASSIGN cbSituacion.
    s-busqueda = cbSituacion.
    RUN dispatch IN h_b-consulta-picking-suborden ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-CodDoc W-Win
ON VALUE-CHANGED OF RADIO-SET-CodDoc IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  s-CodDoc = {&self-name}.
  RUN dispatch IN h_b-consulta-picking-suborden ('open-query':U).
  CASE s-CodDoc:
      WHEN "O/D" OR WHEN "O/M" THEN DO:
      END.
      WHEN "OTR" THEN DO:
      END.
  END CASE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-5
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
             INPUT  'vta2/b-consulta-picking-suborden.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ,
                     SortBy-Case = FchPed':U ,
             OUTPUT h_b-consulta-picking-suborden ).
       RUN set-position IN h_b-consulta-picking-suborden ( 4.46 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-consulta-picking-suborden ( 13.08 , 143.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-consulta-picking-suborden ,
             BUTTON-14:HANDLE IN FRAME F-Main , 'AFTER':U ).
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
  DISPLAY RADIO-SET-CodDoc rsSectores txtDesde txtHasta cbSituacion txtLeyenda 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RADIO-SET-CodDoc RECT-2 BUTTON-Excxel BtnDone BUTTON-13 rsSectores 
         txtDesde txtHasta cbSituacion BUTTON-14 BROWSE-5 
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
  txtDesde:SCREEN-VALUE IN FRAME {&frame-name} = STRING(TODAY - 1,"99/99/9999").
  txtHasta:SCREEN-VALUE IN FRAME {&frame-name} = STRING(TODAY,"99/99/9999").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Handle W-Win 
PROCEDURE Procesa-Handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pParametro AS CHAR.

CASE pParametro:
    WHEN "Disable-Buttons" THEN DO WITH FRAME {&FRAME-NAME}:
        /*BtnExcel:SENSITIVE = NO.*/
    END.
    WHEN "Enable-Buttons" THEN DO WITH FRAME {&FRAME-NAME}:
         /*BUTTON-Alfabeticamente:SENSITIVE = YES.*/
    END.
    WHEN 'ue-pinta-referencia' THEN DO:
        

    END.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
PROCEDURE procesa-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
PROCEDURE recoge-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-guia-hruta W-Win 
PROCEDURE ue-guia-hruta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-CodDoc AS CHAR    NO-UNDO.
DEFINE INPUT PARAMETER p-NroDoc AS CHAR    NO-UNDO.

EMPTY TEMP-TABLE tt-w-report.

DEFINE BUFFER i-faccpedi FOR faccpedi.
DEFINE BUFFER i-ccbcdocu FOR ccbcdocu.

SESSION:SET-WAIT-STATE('GENERAL').

/*FIND FIRST i-faccpedi WHERE ROWID(i-faccpedi) = p-RowId NO-LOCK NO-ERROR.*/
FIND FIRST i-faccpedi WHERE i-faccpedi.codcia = s-codcia AND 
                            i-faccpedi.coddoc = p-CodDoc AND
                             i-faccpedi.nroped = p-NroDoc NO-LOCK NO-ERROR.
IF AVAILABLE i-faccpedi THEN DO:
    /* Guias de la orden de despacho */
    IF i-faccpedi.coddoc = 'O/D' THEN DO:
        FOR EACH i-ccbcdocu USE-INDEX llave15 WHERE i-ccbcdocu.codcia = s-codcia AND 
                                i-ccbcdocu.codped = i-faccpedi.codref AND 
                                i-ccbcdocu.nroped = i-faccpedi.nroref AND 
                                i-ccbcdocu.flgest <> 'A' NO-LOCK :
            IF i-ccbcdocu.coddoc = 'G/R' AND 
                i-ccbcdocu.libre_c01 = i-faccpedi.coddoc AND 
                i-ccbcdocu.libre_c02 = i-faccpedi.nroped THEN DO:
                CREATE tt-w-report.
                    ASSIGN tt-w-report.campo-c[1] = i-ccbcdocu.coddoc
                            tt-w-report.campo-c[2] = i-ccbcdocu.nrodoc.
                /* Hoja de Ruta */
                FIND FIRST di-rutaD USE-INDEX llave02 WHERE di-rutaD.codcia = s-codcia AND 
                                            di-rutaD.coddoc = 'H/R' AND 
                                            di-rutaD.codref = i-ccbcdocu.coddoc AND 
                                            di-rutaD.nroref = i-ccbcdocu.nrodoc NO-LOCK NO-ERROR.
                IF AVAILABLE di-rutaD THEN DO:
                    /*FIND FIRST di-RutaC OF di-rutaD NO-LOCK.*/
                    tt-w-report.campo-c[3] = di-rutaD.nrodoc.
                END.
            END.
        END.
    END.

    /* Guias de Transferencias */
    IF i-faccpedi.coddoc = 'OTR' THEN DO:
        FOR EACH almcmov WHERE almcmov.codcia = s-codcia AND 
                                almcmov.codref = 'OTR' AND 
                                almcmov.nroref = i-faccpedi.nroped AND
                                almcmov.flgest <> 'A' NO-LOCK :
            CREATE tt-w-report.
                ASSIGN tt-w-report.campo-c[1] = 'G/R'
                        tt-w-report.campo-c[2] = STRING(almcmov.nroser,"999") + 
                                                STRING(almcmov.nrodoc,"999999").

            FIND FIRST di-rutaG WHERE DI-RutaG.codcia  = almcmov.codcia  AND                 
                                di-rutaG.codalm = almcmov.codalm  AND
                                di-rutaG.tipmov = almcmov.tipmov AND
                                di-rutaG.codmov = almcmov.codmov AND                                
                                di-rutaG.serref = almcmov.nroser AND
                                di-rutaG.nroref = almcmov.nrodoc NO-LOCK NO-ERROR.
            IF AVAILABLE di-rutaG THEN DO:
                tt-w-report.campo-c[3] = di-rutaG.nrodoc.
            END.

        END.
    END.

END.

RELEASE i-faccpedi.
RELEASE i-ccbcdocu.
{&OPEN-QUERY-BROWSE-5}

SESSION:SET-WAIT-STATE('').

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

txtleyenda:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

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

txtleyenda:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(nSectores) + " Sector(es), " +
                    STRING(nSectoresImp) + " Impreso(s), " + 
                    STRING(nSectoresAsig) + " Asignado(s), " + 
                    STRING(nSectoresReto) + " Retornado(s), " + 
                    STRING(nSectoresSinAsig) + " NO asignados".

{&OPEN-QUERY-BROWSE-5}

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-pinta-referencia W-Win 
PROCEDURE ue-pinta-referencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodRef AS CHAR.
DEFINE INPUT PARAMETER pNroRef AS CHAR.
/*
txtCodRef:SCREEN-VALUE IN FRAME {&FRAME-NAME}= pCodRef.
txtNroRef:SCREEN-VALUE IN FRAME {&FRAME-NAME}= pNroRef.
*/
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

