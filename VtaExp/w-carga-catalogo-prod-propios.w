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

DEFINE TEMP-TABLE ttEnBruto LIKE w-report.

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE TEMP-TABLE ttFamilias
    FIELD   tcodfam     AS  CHAR    FORMAT 'x(5)'
.
DEFINE TEMP-TABLE ttTitulos
    FIELD   ttitulo     AS  CHAR    FORMAT 'x(100)'
    FIELD   tcodtitulo     AS  CHAR    FORMAT 'x(100)'
    FIELD   tcol01      AS  CHAR    FORMAT 'x(100)'
    FIELD   tcol02      AS  CHAR    FORMAT 'x(100)'
    FIELD   tcol03      AS  CHAR    FORMAT 'x(100)'
    FIELD   tcol04      AS  CHAR    FORMAT 'x(100)'
    FIELD   tcol05      AS  CHAR    FORMAT 'x(100)'
    FIELD   tcol06      AS  CHAR    FORMAT 'x(100)'
    FIELD   tmultititulo AS LOG INIT NO
.

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
tt-w-report.Campo-C[2] tt-w-report.Campo-C[3] tt-w-report.Campo-C[4] ~
tt-w-report.Campo-C[5] tt-w-report.Campo-C[6] tt-w-report.Campo-C[7] ~
tt-w-report.Campo-C[8] tt-w-report.Campo-C[9] tt-w-report.Campo-C[10] ~
tt-w-report.Campo-C[11] tt-w-report.Campo-C[12] tt-w-report.Campo-C[13] ~
tt-w-report.Campo-C[14] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH tt-w-report NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH tt-w-report NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 tt-w-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-11 BUTTON-8 TOGGLE-eliminar-todo ~
BROWSE-5 
&Scoped-Define DISPLAYED-OBJECTS TOGGLE-eliminar-todo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-11 
     LABEL "Grabar Catalogo" 
     SIZE 21 BY .96
     BGCOLOR 10 .

DEFINE BUTTON BUTTON-8 
     LABEL "Elija el Excel a Cargar" 
     SIZE 21 BY .96
     BGCOLOR 10 .

DEFINE VARIABLE TOGGLE-eliminar-todo AS LOGICAL INITIAL no 
     LABEL "Eliminar TODO lo anterior" 
     VIEW-AS TOGGLE-BOX
     SIZE 37 BY .77
     BGCOLOR 15 FGCOLOR 12 FONT 9 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      tt-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      tt-w-report.Campo-C[1] COLUMN-LABEL "Estado" FORMAT "X(6)":U
            WIDTH 6.57
      tt-w-report.Campo-C[2] COLUMN-LABEL "Linea" FORMAT "X(5)":U
            WIDTH 5.43
      tt-w-report.Campo-C[3] COLUMN-LABEL "Es!Titulo?" FORMAT "X(2)":U
      tt-w-report.Campo-C[4] COLUMN-LABEL "Producto" FORMAT "X(80)":U
            WIDTH 47.14
      tt-w-report.Campo-C[5] COLUMN-LABEL "UM" FORMAT "X(25)":U
            WIDTH 11.43
      tt-w-report.Campo-C[6] COLUMN-LABEL "Caja" FORMAT "X(8)":U
            WIDTH 6.43
      tt-w-report.Campo-C[7] COLUMN-LABEL "VtaMin" FORMAT "X(8)":U
            WIDTH 6.43
      tt-w-report.Campo-C[8] COLUMN-LABEL "Col. #01" FORMAT "X(8)":U
            WIDTH 11.43
      tt-w-report.Campo-C[9] COLUMN-LABEL "Col. #02" FORMAT "X(8)":U
            WIDTH 11.43
      tt-w-report.Campo-C[10] COLUMN-LABEL "Col. #03" FORMAT "X(8)":U
            WIDTH 11.43
      tt-w-report.Campo-C[11] COLUMN-LABEL "Col. #04" FORMAT "X(8)":U
            WIDTH 11.43
      tt-w-report.Campo-C[12] COLUMN-LABEL "Col. #05" FORMAT "X(8)":U
            WIDTH 11.43
      tt-w-report.Campo-C[13] COLUMN-LABEL "Col. #06" FORMAT "X(8)":U
            WIDTH 10.43
      tt-w-report.Campo-C[14] COLUMN-LABEL "ERROR" FORMAT "X(70)":U
            WIDTH 45.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 166 BY 20.85
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-11 AT ROW 1.08 COL 115.57 WIDGET-ID 6
     BUTTON-8 AT ROW 1.08 COL 146.57 WIDGET-ID 4
     TOGGLE-eliminar-todo AT ROW 1.27 COL 69 WIDGET-ID 14
     BROWSE-5 AT ROW 2.62 COL 1.86 WIDGET-ID 200
     "  Proceso de Carga de Catalogo de Productos Propios" VIEW-AS TEXT
          SIZE 64 BY .96 AT ROW 1 COL 1 WIDGET-ID 2
          BGCOLOR 9 FGCOLOR 15 FONT 9
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 168.14 BY 22.85 WIDGET-ID 100.


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
         TITLE              = "Carga de Catalogo de productos propios"
         HEIGHT             = 22.85
         WIDTH              = 168.14
         MAX-HEIGHT         = 22.85
         MAX-WIDTH          = 196.72
         VIRTUAL-HEIGHT     = 22.85
         VIRTUAL-WIDTH      = 196.72
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
/* BROWSE-TAB BROWSE-5 TOGGLE-eliminar-todo F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-C[1]
"tt-w-report.Campo-C[1]" "Estado" "X(6)" "character" ? ? ? ? ? ? no ? no no "6.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[2]
"tt-w-report.Campo-C[2]" "Linea" "X(5)" "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-C[3]
"tt-w-report.Campo-C[3]" "Es!Titulo?" "X(2)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report.Campo-C[4]
"tt-w-report.Campo-C[4]" "Producto" "X(80)" "character" ? ? ? ? ? ? no ? no no "47.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-w-report.Campo-C[5]
"tt-w-report.Campo-C[5]" "UM" "X(25)" "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-w-report.Campo-C[6]
"tt-w-report.Campo-C[6]" "Caja" ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-w-report.Campo-C[7]
"tt-w-report.Campo-C[7]" "VtaMin" ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-w-report.Campo-C[8]
"tt-w-report.Campo-C[8]" "Col. #01" ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-w-report.Campo-C[9]
"tt-w-report.Campo-C[9]" "Col. #02" ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-w-report.Campo-C[10]
"tt-w-report.Campo-C[10]" "Col. #03" ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tt-w-report.Campo-C[11]
"tt-w-report.Campo-C[11]" "Col. #04" ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.tt-w-report.Campo-C[12]
"tt-w-report.Campo-C[12]" "Col. #05" ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.tt-w-report.Campo-C[13]
"tt-w-report.Campo-C[13]" "Col. #06" ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.tt-w-report.Campo-C[14]
"tt-w-report.Campo-C[14]" "ERROR" "X(70)" "character" ? ? ? ? ? ? no ? no no "45.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Carga de Catalogo de productos propios */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Carga de Catalogo de productos propios */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-11 W-Win
ON CHOOSE OF BUTTON-11 IN FRAME F-Main /* Grabar Catalogo */
DO:
        MESSAGE 'Seguro de Grabar el Catalogo?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.
  
        ASSIGN toggle-eliminar-todo.

        IF toggle-eliminar-todo THEN DO:
            IF rpta = NO THEN RETURN NO-APPLY.


            DEFINE VAR cRspta AS CHAR FORMAT 'x(12)'.
            MESSAGE "Escriba la palabra BORRARTODO" UPDATE cRspta.

            IF cRspta = "BORRARTODO" THEN DO:
                /*MESSAGE "OK".*/
            END.
            ELSE DO:
                MESSAGE "La palabra ingresada esta errada" VIEW-AS ALERT-BOX INFORMATION.
                RETURN NO-APPLY.
            END.
        END.

        RUN grabar-catalogo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 W-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* Elija el Excel a Cargar */
DO:
  RUN cargar-excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-5
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

DEF VAR celda_br AS WIDGET-HANDLE EXTENT 150 NO-UNDO.
DEF VAR cual_celda AS WIDGET-HANDLE NO-UNDO.
DEF VAR n_cols_browse AS INT NO-UNDO.
DEF VAR col_act AS INT NO-UNDO.
DEF VAR t_col_br AS INT NO-UNDO INITIAL 2.  /* 11 */
DEF VAR vg_col_eti_b AS INT NO-UNDO INITIAL 15.  /* 28 */.

ON ROW-DISPLAY OF browse-5
DO:
  /*IF CURRENT-RESULT-ROW("browse-1") / 2 <> INT (CURRENT-RESULT-ROW("browse-1") / 2) THEN RETURN.*/

  IF tt-w-report.campo-c[3] <> "SI" THEN RETURN.

  DO col_act = 1 TO n_cols_browse.
      
     cual_celda = celda_br[col_act].
     cual_celda:BGCOLOR = t_col_br.
     cual_celda:FGCOLOR = vg_col_eti_b.
  END.
END.

DO n_cols_browse = 1 TO browse-5:NUM-COLUMNS.
   celda_br[n_cols_browse] = browse-5:GET-BROWSE-COLUMN(n_cols_browse).
   cual_celda = celda_br[n_cols_browse].
     
   IF vg_col_eti_b <> 0 THEN cual_celda:LABEL-BGCOLOR = vg_col_eti_b.
   /*IF n_cols_browse = 15 THEN LEAVE.*/
END.

n_cols_browse = browse-5:NUM-COLUMNS.
/*IF n_cols_browse > 15 THEN n_cols_browse = 15.*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-excel W-Win 
PROCEDURE cargar-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR X-archivo AS CHAR.
DEFINE VAR rpta AS LOG.

DEFINE VAR x-filer AS CHAR.
DEFINE VAR x-linea-titulo AS INT.

SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Excel (*.xls)' '*.xls,*.xlsx'
    DEFAULT-EXTENSION '.xls'
    RETURN-TO-START-DIR
    TITLE 'Importar Excel'
    UPDATE rpta.
IF rpta = NO OR x-Archivo = '' THEN RETURN.

SESSION:SET-WAIT-STATE("GENERAL").

EMPTY TEMP-TABLE ttEnBruto.
EMPTY TEMP-TABLE ttFamilias.

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.
DEFINE VAR lLinea AS INT.
DEFINE VAR x-Sec AS INT.
DEFINE VAR x-hubo-titulo-anterior AS LOG.

DEFINE VAR xCaso AS CHAR.
DEFINE VAR x-titulos AS INT.
DEFINE VAR x-correlativo AS INT.
DEFINE VAR x-titulo AS CHAR.

DEFINE VAR dValor AS DEC.
DEFINE VAR lTpoCmb AS DEC.

lFileXls = x-Archivo.           /* Nombre el archivo a abrir o crear, vacio solo para nuevos */
lNuevoFile = NO.                            /* Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

lMensajeAlTerminar = NO. /*  */
lCerrarAlTerminar = YES.        /* Si permanece abierto el Excel luego de concluir el proceso */

iColumn = 1.
lLinea = 1.

x-correlativo = 0.
cColumn = STRING(lLinea).
REPEAT iColumn = 2 TO 65000 :
    cColumn = STRING(iColumn).

    cRange = "A" + cColumn.
    xCaso = chWorkSheet:Range(cRange):TEXT.

    IF xCaso = "" OR xCaso = ? THEN LEAVE.    /* FIN DE DATOS */

    x-correlativo = x-correlativo + 1.
    CREATE ttEnBruto.
    ASSIGN ttEnBruto.task-no = 0
            ttEnBruto.llave-c = STRING(x-correlativo,"9999999999")
        
    /*  */
    cRange = "A" + cColumn.         /* Familia */
    ASSIGN ttEnBruto.campo-c[1] = IF (TRUE <> (chWorkSheet:Range(cRange):TEXT > "")) THEN "" ELSE chWorkSheet:Range(cRange):TEXT.
    cRange = "B" + cColumn.         /* Titulo */
    ASSIGN ttEnBruto.campo-c[2] = IF (TRUE <> (chWorkSheet:Range(cRange):TEXT > "")) THEN "" ELSE chWorkSheet:Range(cRange):TEXT.
    cRange = "C" + cColumn.         /* Producto */
    ASSIGN ttEnBruto.campo-c[3] = IF (TRUE <> (chWorkSheet:Range(cRange):TEXT > "")) THEN "" ELSE chWorkSheet:Range(cRange):TEXT.
    cRange = "D" + cColumn.         /* UM */
    ASSIGN ttEnBruto.campo-c[4] = IF (TRUE <> (chWorkSheet:Range(cRange):TEXT > "")) THEN "" ELSE chWorkSheet:Range(cRange):TEXT.
    cRange = "E" + cColumn.         /* Caja */
    ASSIGN ttEnBruto.campo-c[5] = IF (TRUE <> (chWorkSheet:Range(cRange):TEXT > "")) THEN "" ELSE chWorkSheet:Range(cRange):TEXT.
    cRange = "F" + cColumn.         /* VtaMin */
    ASSIGN ttEnBruto.campo-c[6] = IF (TRUE <> (chWorkSheet:Range(cRange):TEXT > "")) THEN "" ELSE chWorkSheet:Range(cRange):TEXT.
    cRange = "G" + cColumn.         /* Col #01 */
    ASSIGN ttEnBruto.campo-c[7] = IF (TRUE <> (chWorkSheet:Range(cRange):TEXT > "")) THEN "" ELSE chWorkSheet:Range(cRange):TEXT.
    cRange = "H" + cColumn.         /* Col #02 */
    ASSIGN ttEnBruto.campo-c[8] = IF (TRUE <> (chWorkSheet:Range(cRange):TEXT > "")) THEN "" ELSE chWorkSheet:Range(cRange):TEXT.
    cRange = "I" + cColumn.         /* Col #03 */
    ASSIGN ttEnBruto.campo-c[9] = IF (TRUE <> (chWorkSheet:Range(cRange):TEXT > "")) THEN "" ELSE chWorkSheet:Range(cRange):TEXT.
    cRange = "J" + cColumn.         /* Col #04 */
    ASSIGN ttEnBruto.campo-c[10] = IF (TRUE <> (chWorkSheet:Range(cRange):TEXT > "")) THEN "" ELSE chWorkSheet:Range(cRange):TEXT.
    cRange = "K" + cColumn.         /* Col #05 */
    ASSIGN ttEnBruto.campo-c[11] = IF (TRUE <> (chWorkSheet:Range(cRange):TEXT > "")) THEN "" ELSE chWorkSheet:Range(cRange):TEXT.
    cRange = "L" + cColumn.         /* Col #06 */
    ASSIGN ttEnBruto.campo-c[12] = IF (TRUE <> (chWorkSheet:Range(cRange):TEXT > "")) THEN "" ELSE chWorkSheet:Range(cRange):TEXT.

END.

{lib\excel-close-file.i}

FIND FIRST ttEnBruto NO-ERROR.
IF NOT AVAILABLE ttEnBruto THEN DO:
    /* No hay data */
    RETURN.
END.

/* Ubico familias familias */
FOR EACH ttEnBruto :
    FIND FIRST ttFamilias WHERE ttFamilias.tcodfam = ttEnBruto.campo-c[1] NO-ERROR.
    IF NOT AVAILABLE ttFamilias THEN DO:
        CREATE ttFamilias.
            ASSIGN ttFamilias.tcodfam = ttEnBruto.campo-c[1].
    END.  
END.

x-correlativo = 0.
FOR EACH ttFamilias :
    FIND FIRST almtfam WHERE almtfam.codcia = s-codcia AND
                                almtfam.codfam = ttFamilias.tcodfam
                                NO-LOCK NO-ERROR.
    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                                vtatabla.tabla  = 'LP' AND
                                vtatabla.llave_c1 = s-user-id AND
                                vtatabla.llave_c2 = ttFamilias.tcodfam NO-LOCK NO-ERROR.

    x-linea-titulo = 1.  
    x-titulos = 1.        
    x-hubo-titulo-anterior = NO.
    x-titulo = "".
    FOR EACH ttEnBruto WHERE ttEnBruto.campo-c[1] = ttFamilias.tcodfam :        
        x-correlativo = x-correlativo + 1.
        CREATE tt-w-report.
            ASSIGN tt-w-report.task-no = 0
                    tt-w-report.llave-c = STRING(x-correlativo,"9999999999")
                    tt-w-report.campo-c[1] = "OK"
                    tt-w-report.campo-c[2] = ttEnBruto.campo-c[1]
                    tt-w-report.campo-c[3] = ttEnBruto.campo-c[2]
                    tt-w-report.campo-c[4] = ttEnBruto.campo-c[3]
                    tt-w-report.campo-c[5] = ttEnBruto.campo-c[4]
                    tt-w-report.campo-c[6] = ttEnBruto.campo-c[5]
                    tt-w-report.campo-c[7] = ttEnBruto.campo-c[6]
                    tt-w-report.campo-c[8] = ttEnBruto.campo-c[7]
                    tt-w-report.campo-c[9] = ttEnBruto.campo-c[8]
                    tt-w-report.campo-c[10] = ttEnBruto.campo-c[9]
                    tt-w-report.campo-c[11] = ttEnBruto.campo-c[10]
                    tt-w-report.campo-c[12] = ttEnBruto.campo-c[11]
                    tt-w-report.campo-c[13] = ttEnBruto.campo-c[12]
                    tt-w-report.campo-c[14] = ""
                    tt-w-report.campo-c[20] = x-titulo              /* Titulo */
                    tt-w-report.campo-i[1] = x-linea-titulo
                    tt-w-report.campo-i[2] = x-titulos
        .
        /* Inicio de Validaciones */

        /* Linea */
        IF NOT AVAILABLE almtfam THEN DO:
            ASSIGN tt-w-report.campo-c[1] = "ERROR"
                    tt-w-report.campo-c[14] = "Linea no existe".
            NEXT.
        END.
        /* Linea asignado al usuario */
        IF USERID("DICTDB") <> "ADMIN" AND USERID("DICTDB") <> "MASTER" THEN DO:
            IF NOT AVAILABLE vtatabla THEN DO:
                ASSIGN tt-w-report.campo-c[1] = "ERROR"
                        tt-w-report.campo-c[14] = "El usuario no tiene asignado la LINEA".
                NEXT.
            END.
        END.
        /* Columna Es Titulo */
        IF tt-w-report.campo-c[3] <> ""  THEN DO:
            IF tt-w-report.campo-c[3] <> "SI" THEN DO:
                ASSIGN tt-w-report.campo-c[1] = "ERROR"
                        tt-w-report.campo-c[14] = "Debe ser SI o vacio".
                NEXT.
            END.
        END.
        /* Columna Producto */
        IF tt-w-report.campo-c[4] = ""  THEN DO:
            ASSIGN tt-w-report.campo-c[1] = "ERROR"
                    tt-w-report.campo-c[14] = "La columna PRODUCTO esta vacio".
            NEXT.
        END.
        
        /* Columna Es Titulo */
        IF tt-w-report.campo-c[3] = ""  THEN DO:
            /* Linea no es TITULO */            
            IF x-linea-titulo = 1 THEN DO:
                ASSIGN tt-w-report.campo-c[1] = "ERROR"
                        tt-w-report.campo-c[14] = "Debe empezar con TITULO".
                NEXT.
            END.
            IF x-titulos = 1 THEN DO:
                /* UM */
                IF tt-w-report.campo-c[5] = "" THEN DO:
                    ASSIGN tt-w-report.campo-c[1] = "ERROR"
                            tt-w-report.campo-c[14] = "UM esta vacio".
                    NEXT.
                END.
                /* Caja */
                IF tt-w-report.campo-c[6] = "" THEN DO:
                    ASSIGN tt-w-report.campo-c[1] = "ERROR"
                            tt-w-report.campo-c[14] = "CAJA esta vacio".
                    NEXT.
                END.
                /* VtaMin */
                IF tt-w-report.campo-c[7] = "" THEN DO:
                    ASSIGN tt-w-report.campo-c[1] = "ERROR"
                            tt-w-report.campo-c[14] = "VTAMIN esta vacio".
                    NEXT.
                END.
            END.
            ELSE DO:
                IF x-titulos < 4 THEN DO:
                    ASSIGN tt-w-report.campo-c[1] = "ERROR"
                            tt-w-report.campo-c[14] = "Esta Linea deberia ser un TITULO".
                    NEXT.
                END.
            END.
            /* Columnas */
            x-filer = TRIM(TRIM(tt-w-report.campo-c[8]) + TRIM(tt-w-report.campo-c[9]) +
                            TRIM(tt-w-report.campo-c[10]) + TRIM(tt-w-report.campo-c[11]) + 
                            TRIM(tt-w-report.campo-c[12]) + TRIM(tt-w-report.campo-c[13])).
            IF x-filer = "" THEN DO:
                ASSIGN tt-w-report.campo-c[1] = "ERROR"
                        tt-w-report.campo-c[14] = "Asigne al menos un ARTICULO".
                NEXT.
            END.
            /* Codigos de articulos */
            REPEAT x-sec = 8 TO 13:
                x-filer = TRIM(tt-w-report.campo-c[x-sec]).
                IF LENGTH(x-filer) > 0 AND LENGTH(x-filer) <> 6 THEN DO:
                    ASSIGN tt-w-report.campo-c[1] = "ERROR"
                        tt-w-report.campo-c[14] = "ARTICULO de la columna " + STRING(x-sec - 7) + " debe tener 6 digitos".
                    x-sec = 20.
                    x-filer = "ERROR".
                END.
                IF x-filer <> "" THEN DO:
                    x-filer = STRING(INTEGER(x-filer),"999999").
                    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
                                                almmmatg.codmat = x-filer
                                                NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE almmmatg THEN DO:
                        ASSIGN tt-w-report.campo-c[1] = "ERROR"
                            tt-w-report.campo-c[14] = "ARTICULO de la columna " + STRING(x-sec - 7) + " no existe".
                        x-sec = 20.
                        x-filer = "ERROR".
                    END.
                    IF almmmatg.codfam <> almtfam.codfam THEN DO:
                        ASSIGN tt-w-report.campo-c[1] = "ERROR"
                            tt-w-report.campo-c[14] = "El ARTICULO de la columna " + STRING(x-sec - 7) + " no pertence a LINEA".
                        x-sec = 20.
                        x-filer = "ERROR".
                    END.
                END.               
            END.
            IF x-filer = "ERROR" THEN DO:
                NEXT.
            END.
            x-hubo-titulo-anterior = NO.
            /*  */            
        END.
        ELSE DO:
            /* Titulos */
            x-linea-titulo = x-linea-titulo + 1.
            IF x-hubo-titulo-anterior = NO THEN x-titulos = 0.
            x-titulos = x-titulos + 1.  

            IF x-titulos = 1 THEN DO:
                /* Columnas */
                x-filer = TRIM(TRIM(tt-w-report.campo-c[8]) + TRIM(tt-w-report.campo-c[9]) +
                                TRIM(tt-w-report.campo-c[10]) + TRIM(tt-w-report.campo-c[11]) + 
                                TRIM(tt-w-report.campo-c[12]) + TRIM(tt-w-report.campo-c[13])).
                IF x-filer = "" THEN DO:
                    ASSIGN tt-w-report.campo-c[1] = "ERROR"
                            tt-w-report.campo-c[14] = "Faltan los Titulos del grupo".
                    NEXT.
                END.
                /* Titulo Repetido */
                FIND FIRST ttTitulos WHERE ttTitulos.ttitulo = tt-w-report.campo-c[4] EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE ttTitulos THEN DO:
                    CREATE ttTitulos.
                        ASSIGN ttTitulos.ttitulo = tt-w-report.campo-c[4]
                                ttTitulos.tcol01 = TRIM(tt-w-report.campo-c[8])
                                ttTitulos.tcol02 = TRIM(tt-w-report.campo-c[9])
                                ttTitulos.tcol03 = TRIM(tt-w-report.campo-c[10])
                                ttTitulos.tcol04 = TRIM(tt-w-report.campo-c[11])
                                ttTitulos.tcol05 = TRIM(tt-w-report.campo-c[12])
                                ttTitulos.tcol06 = TRIM(tt-w-report.campo-c[13])
                                .
                        x-titulo = tt-w-report.campo-c[4].
                END.
                ELSE DO:
                    ASSIGN tt-w-report.campo-c[1] = "ERROR"
                            tt-w-report.campo-c[14] = "Titulo esta repetido".
                    NEXT.
                END.
                /**/
                ASSIGN tt-w-report.campo-c[20] = tt-w-report.campo-c[4].
            END.
            ELSE DO:
                /**/
                ASSIGN tt-w-report.campo-c[20] = x-titulo.

                IF x-titulos < 5 THEN DO:
                    /* Columnas */
                    x-filer = TRIM(TRIM(tt-w-report.campo-c[8]) + TRIM(tt-w-report.campo-c[9]) +
                                    TRIM(tt-w-report.campo-c[10]) + TRIM(tt-w-report.campo-c[11]) + 
                                    TRIM(tt-w-report.campo-c[12]) + TRIM(tt-w-report.campo-c[13])).
                    IF x-filer = "" THEN DO:
                        ASSIGN tt-w-report.campo-c[1] = "ERROR"
                                tt-w-report.campo-c[14] = "Faltan las Unidades de Medida del ARTICULO".
                        NEXT.
                    END.
                    /* Multititulos */
                    FIND FIRST ttTitulos WHERE ttTitulos.ttitulo = x-titulo EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAILABLE ttTitulos THEN DO:
                        ASSIGN ttTitulos.tmultititulo = YES.
                        /**/
                        IF (TRIM(tt-w-report.campo-c[8]) <> "") THEN DO:
                            ASSIGN ttTitulos.tcol01 = ttTitulos.tcol01 + "!" + TRIM(tt-w-report.campo-c[8]).
                        END.
                        IF (TRIM(tt-w-report.campo-c[9]) <> "") THEN DO:
                            ASSIGN ttTitulos.tcol02 = ttTitulos.tcol02 + "!" + TRIM(tt-w-report.campo-c[9]).
                        END.
                        IF (TRIM(tt-w-report.campo-c[10]) <> "") THEN DO:
                            ASSIGN ttTitulos.tcol03 = ttTitulos.tcol03 + "!" + TRIM(tt-w-report.campo-c[10]).
                        END.
                        IF (TRIM(tt-w-report.campo-c[11]) <> "") THEN DO:
                            ASSIGN ttTitulos.tcol04 = ttTitulos.tcol04 + "!" + TRIM(tt-w-report.campo-c[11]).
                        END.
                        IF (TRIM(tt-w-report.campo-c[12]) <> "") THEN DO:
                            ASSIGN ttTitulos.tcol05 = ttTitulos.tcol05 + "!" + TRIM(tt-w-report.campo-c[12]).
                        END.
                        IF (TRIM(tt-w-report.campo-c[13]) <> "") THEN DO:
                            ASSIGN ttTitulos.tcol06 = ttTitulos.tcol06 + "!" + TRIM(tt-w-report.campo-c[13]).
                        END.
                    
                    END.
                END.
                ELSE DO:
                    ASSIGN tt-w-report.campo-c[1] = "ERROR"
                            tt-w-report.campo-c[14] = "Esta Fila no debe ser de titulo".
                    NEXT.
                END.
            END.

            x-hubo-titulo-anterior = YES.
        END.
    END.
END.

DEFINE VAR x-des-grupo AS CHAR INIT "".
DEFINE VAR x-cod-grupo AS INT INIT 0.

FOR EACH tt-w-report BY tt-w-report.llave-c:
    IF x-des-grupo <> tt-w-report.campo-c[20] THEN DO:
        x-cod-grupo = x-cod-grupo + 1.
        x-des-grupo = tt-w-report.campo-c[20].

        FIND FIRST ttTitulos WHERE ttTitulos.ttitulo = x-des-grupo EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE ttTitulos THEN DO:
                ASSIGN ttTitulos.tcodtitulo = STRING(x-cod-grupo,"999999") + " - " + tt-w-report.campo-c[20].
        END.

    END.
    ASSIGN tt-w-report.campo-c[30] = STRING(x-cod-grupo,"999999") + " - " + tt-w-report.campo-c[20].
END.

{&open-query-browse-5}


SESSION:SET-WAIT-STATE("").


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
  DISPLAY TOGGLE-eliminar-todo 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-11 BUTTON-8 TOGGLE-eliminar-todo BROWSE-5 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-catalogo W-Win 
PROCEDURE grabar-catalogo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
DEFINE TEMP-TABLE ttFamilias
    FIELD   tcodfam     AS  CHAR    FORMAT 'x(5)'.
DEFINE TEMP-TABLE ttTitulos
    FIELD   ttitulo     AS  CHAR    FORMAT 'x(100)'.
*/

EMPTY TEMP-TABLE ttFamilias.

DEFINE VAR x-codgrupo AS INT.

DEFINE BUFFER b-expoGrpo FOR expoGrpo.
DEFINE BUFFER b-expoArt FOR expoArt.
DEFINE VAR x-rowid AS ROWID.
DEFINE VAR x-correlativo AS INT.

FIND FIRST tt-w-report WHERE tt-w-report.campo-c[1] <> "OK" NO-ERROR.

IF AVAILABLE tt-w-report THEN DO:
    MESSAGE "El catalogo tiene ERRORES, por favor carge correctamente la informacion" 
                    VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

SESSION:SET-WAIT-STATE("GENERAL").

/* Familias a Cargar */
FOR EACH tt-w-report :
    FIND FIRST ttFamilias WHERE ttFamilias.tcodfam = tt-w-report.campo-c[2] NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ttFamilias THEN DO:
        CREATE ttFamilias.
            ASSIGN ttFamilias.tcodfam = tt-w-report.campo-c[2].
    END.
END.

DEFINE VAR x-msg AS CHAR INIT "*ERROR*" NO-UNDO.

GRABAR_DATOS:
DO TRANSACTION ON ERROR UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS:

    IF toggle-eliminar-todo THEN DO:
        x-msg = "Eliminado TODO lo anterior".
        FOR EACH expoGrpo WHERE expoGrpo.codcia = s-codcia NO-LOCK:
            FOR EACH expoArt WHERE expoArt.codcia = s-codcia AND
                                    expoArt.codgrupo = expoGrpo.codgrupo NO-LOCK:
                x-rowid = ROWID(expoArt).
                FIND FIRST b-expoArt WHERE ROWID(b-expoArt) = x-rowid EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE b-expoArt THEN DO:
                    x-msg = "No pudo eliminar la registro en expoArt".
                    UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
                END.
                DELETE b-expoArt.
            END.
            x-rowid = ROWID(expoGrpo).
            FIND FIRST b-expoGrpo WHERE ROWID(b-expoGrpo) = x-rowid EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE b-expoGrpo THEN DO:
                x-msg = "No pudo eliminar la registro en expoGrpo".
                UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
            END.
            DELETE b-expoGrpo.    
        END.
        EMPTY TEMP-TABLE ttFamilias.
    END.

    /* Eliminar las familias anteriores */
    x-msg = "Eliminado las familias anteriores".
    FOR EACH ttFamilias :
        FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                    vtatabla.tabla = 'LINEAS-CATALOGO-PP' AND
                                    vtatabla.llave_c1 = ttFamilias.tcodfam EXCLUSIVE-LOCK NO-ERROR.
        IF LOCKED vtatabla THEN DO:
            x-msg = "No pudo eliminar la linea en vtatabla".
            UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
        END.
        IF AVAILABLE vtatabla THEN DO:
            DELETE vtatabla.
        END.

        FOR EACH expoGrpo WHERE expoGrpo.codcia = s-codcia AND
                                expoGrpo.codfam = ttFamilias.tcodfam NO-LOCK:
            FOR EACH expoArt WHERE expoArt.codcia = s-codcia AND
                                    expoArt.codgrupo = expoGrpo.codgrupo NO-LOCK:
                x-rowid = ROWID(expoArt).
                FIND FIRST b-expoArt WHERE ROWID(b-expoArt) = x-rowid EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE b-expoArt THEN DO:
                    x-msg = "No pudo eliminar la registro en expoArt".
                    UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
                END.
                DELETE b-expoArt.
            END.
            x-rowid = ROWID(expoGrpo).
            FIND FIRST b-expoGrpo WHERE ROWID(b-expoGrpo) = x-rowid EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE b-expoGrpo THEN DO:
                x-msg = "No pudo eliminar la registro en expoGrpo".
                UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
            END.
            DELETE b-expoGrpo.
    
        END.
    END.
    
    x-msg = "Registrando el Catalogo".
    /* Grabar los nuevos datos */
    FOR EACH ttFamilias :
        /* */
        FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                    vtatabla.tabla = 'LINEAS-CATALOGO-PP' AND
                                    vtatabla.llave_c1 = ttFamilias.tcodfam NO-LOCK NO-ERROR.
        IF NOT AVAILABLE vtatabla THEN DO:
            CREATE vtatabla.
                ASSIGN vtatabla.codcia = s-codcia
                        vtatabla.tabla = 'LINEAS-CATALOGO-PP'
                        vtatabla.llave_c1 = ttFamilias.tcodfam NO-ERROR.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                x-msg = "No se pudo agregar la linea " + ttFamilias.tcodfam + " en vtatabla".
                UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
            END.
        END.

        x-codgrupo = 1.
        x-msg = "Cargando la familia " + ttFamilias.tcodfam.
        FOR EACH tt-w-report WHERE tt-w-report.campo-c[2] = ttFamilias.tCodFam
                                    AND tt-w-report.campo-c[3] = "" NO-LOCK:
            /* Grupo */
            FIND FIRST expoGrpo WHERE expoGrpo.codcia = s-codcia AND
                                        expoGrpo.codgrupo = tt-w-report.campo-c[30] NO-LOCK NO-ERROR.
            IF NOT AVAILABLE expoGrpo THEN DO:                
                CREATE expoGrpo.
                    ASSIGN expoGrpo.codcia = s-codcia
                        expoGrpo.codgrupo = tt-w-report.campo-c[30]                        
                        expoGrpo.codfam = tt-w-report.campo-c[2]
                    .
                FIND FIRST ttTitulos WHERE ttTitulos.tcodtitulo = tt-w-report.campo-c[30] NO-LOCK NO-ERROR.
                ASSIGN expoGrpo.col01 = ttTitulos.tcol01
                        expoGrpo.col02 = ttTitulos.tcol02
                        expoGrpo.col03 = ttTitulos.tcol03
                        expoGrpo.col04 = ttTitulos.tcol04
                        expoGrpo.col05 = ttTitulos.tcol05
                        expoGrpo.col06 = ttTitulos.tcol06
                        expoGrpo.multititulo = ttTitulos.tmultititulo
                    expoGrpo.desgrupo = ttTitulos.ttitulo
                    .
                x-correlativo = 0.
                x-codgrupo = x-codgrupo + 1.
            END.

            x-correlativo = x-correlativo + 1.
            CREATE expoArt.
            ASSIGN 
                expoArt.codcia = s-codcia 
                expoArt.codgrupo = tt-w-report.campo-c[30]
                expoArt.codmtxArt = STRING(x-correlativo,"99999")
                expoArt.desmatxart = tt-w-report.campo-c[4]
                expoArt.UM = tt-w-report.campo-c[5]
                expoArt.caja = tt-w-report.campo-c[6]
                expoArt.vtamin = tt-w-report.campo-c[7]
                expoArt.artcol01 = tt-w-report.campo-c[8]
                expoArt.artcol02 = tt-w-report.campo-c[9]
                expoArt.artcol03 = tt-w-report.campo-c[10]
                expoArt.artcol04 = tt-w-report.campo-c[11]
                expoArt.artcol05 = tt-w-report.campo-c[12]
                expoArt.artcol06 = tt-w-report.campo-c[13]
                .
            /* Por cada ArtCol actualizamos el catálogo */
            DEF VAR x-Item AS INT NO-UNDO.
            DO x-Item = 8 TO 13:
                IF CAN-FIND(Almmmatg WHERE Almmmatg.codcia = s-codcia AND
                            Almmmatg.codmat = tt-w-report.campo-c[x-Item] NO-LOCK)
                    THEN DO:
                    {lib/lock-genericov3.i ~
                        &Tabla="Almmmatg" ~
                        &Condicion="Almmmatg.codcia = s-codcia AND ~
                        Almmmatg.codmat = tt-w-report.campo-c[x-Item]" ~
                        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
                        &Accion="RETRY" ~
                        &Mensaje="YES" ~
                        &TipoError="UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS" ~
                        }
                    /* Actualizamos el Catalogo */
                    ASSIGN
                        Almmmatg.StkMax    = DECIMAL(tt-w-report.campo-c[7])
                        Almmmatg.Libre_d03 = DECIMAL(tt-w-report.campo-c[6])
                        NO-ERROR.
                    RELEASE Almmmatg.
                END.
            END.
            /* ****************************************** */
        END.
    END.
    x-msg = "OK".
END.

RELEASE expoGrpo.
RELEASE expoArt.

SESSION:SET-WAIT-STATE("").

IF x-msg <> "OK" THEN DO:
    MESSAGE "Hubo problemas al grabar el Catalogo" SKIP
            x-msg VIEW-AS ALERT-BOX ERROR.
END.
ELSE DO:
    MESSAGE "Grabacion del Catalogo OK" VIEW-AS ALERT-BOX INFORMATION.
END.

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

  /*x-columnas-del-browse = browse-5:NUM-COLUMNS IN FRAME {&FRAME-NAME}.*/

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

