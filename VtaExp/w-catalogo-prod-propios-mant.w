&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-ExpoArt NO-UNDO LIKE ExpoArt
       field ttitulo as char
       .



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
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE VAR x-linea AS CHAR.
DEFINE VAR x-es-titulo AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-7

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ExpoArt

/* Definitions for BROWSE BROWSE-7                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-7 tt-expoart.ttitulo @ x-es-titulo ~
tt-ExpoArt.DesMatxArt tt-ExpoArt.UM tt-ExpoArt.Caja tt-ExpoArt.VtaMin ~
tt-ExpoArt.ArtCol01 tt-ExpoArt.ArtCol02 tt-ExpoArt.ArtCol03 ~
tt-ExpoArt.ArtCol04 tt-ExpoArt.ArtCol05 tt-ExpoArt.ArtCol06 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-7 
&Scoped-define QUERY-STRING-BROWSE-7 FOR EACH tt-ExpoArt NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-7 OPEN QUERY BROWSE-7 FOR EACH tt-ExpoArt NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-7 tt-ExpoArt
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-7 tt-ExpoArt


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-7}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-12 COMBO-BOX-linea BUTTON-13 BROWSE-7 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-linea 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-12 
     LABEL "Consultar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-13 
     LABEL "Generar Plantilla de Excel" 
     SIZE 25.57 BY 1.12.

DEFINE VARIABLE COMBO-BOX-linea AS CHARACTER FORMAT "X(256)":U 
     LABEL "Seleccione Linea" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 27 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-7 FOR 
      tt-ExpoArt SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-7 W-Win _STRUCTURED
  QUERY BROWSE-7 NO-LOCK DISPLAY
      tt-expoart.ttitulo @ x-es-titulo COLUMN-LABEL "Titulo" FORMAT "x(4)":U
      tt-ExpoArt.DesMatxArt COLUMN-LABEL "P R O D U C T O" FORMAT "x(80)":U
            WIDTH 46.43
      tt-ExpoArt.UM FORMAT "x(25)":U WIDTH 15.43
      tt-ExpoArt.Caja FORMAT "x(15)":U WIDTH 10.43
      tt-ExpoArt.VtaMin FORMAT "x(15)":U WIDTH 8.43
      tt-ExpoArt.ArtCol01 COLUMN-LABEL "Columna-01" FORMAT "x(50)":U
            WIDTH 8.86
      tt-ExpoArt.ArtCol02 COLUMN-LABEL "Columna-02" FORMAT "x(50)":U
            WIDTH 9.43
      tt-ExpoArt.ArtCol03 COLUMN-LABEL "Columna-03" FORMAT "x(50)":U
            WIDTH 9.43
      tt-ExpoArt.ArtCol04 COLUMN-LABEL "Columna-04" FORMAT "x(50)":U
            WIDTH 9.43
      tt-ExpoArt.ArtCol05 COLUMN-LABEL "Columna-05" FORMAT "x(50)":U
            WIDTH 9.43
      tt-ExpoArt.ArtCol06 COLUMN-LABEL "Columna-06" FORMAT "x(50)":U
            WIDTH 15
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 156 BY 18.27
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-12 AT ROW 1.12 COL 52.29 WIDGET-ID 4
     COMBO-BOX-linea AT ROW 1.23 COL 22 COLON-ALIGNED WIDGET-ID 2
     BUTTON-13 AT ROW 1.23 COL 79.86 WIDGET-ID 6
     BROWSE-7 AT ROW 2.58 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 159.14 BY 20.15 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-ExpoArt T "?" NO-UNDO INTEGRAL ExpoArt
      ADDITIONAL-FIELDS:
          field ttitulo as char
          
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Generacion de Plantillas, Carga productos propios"
         HEIGHT             = 20.15
         WIDTH              = 159.14
         MAX-HEIGHT         = 20.96
         MAX-WIDTH          = 160.29
         VIRTUAL-HEIGHT     = 20.96
         VIRTUAL-WIDTH      = 160.29
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
/* BROWSE-TAB BROWSE-7 BUTTON-13 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-7
/* Query rebuild information for BROWSE BROWSE-7
     _TblList          = "Temp-Tables.tt-ExpoArt"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > "_<CALC>"
"tt-expoart.ttitulo @ x-es-titulo" "Titulo" "x(4)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-ExpoArt.DesMatxArt
"tt-ExpoArt.DesMatxArt" "P R O D U C T O" ? "character" ? ? ? ? ? ? no ? no no "46.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-ExpoArt.UM
"tt-ExpoArt.UM" ? ? "character" ? ? ? ? ? ? no ? no no "15.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-ExpoArt.Caja
"tt-ExpoArt.Caja" ? ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-ExpoArt.VtaMin
"tt-ExpoArt.VtaMin" ? ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-ExpoArt.ArtCol01
"tt-ExpoArt.ArtCol01" "Columna-01" "x(50)" "character" ? ? ? ? ? ? no ? no no "8.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-ExpoArt.ArtCol02
"tt-ExpoArt.ArtCol02" "Columna-02" "x(50)" "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-ExpoArt.ArtCol03
"tt-ExpoArt.ArtCol03" "Columna-03" "x(50)" "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-ExpoArt.ArtCol04
"tt-ExpoArt.ArtCol04" "Columna-04" "x(50)" "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-ExpoArt.ArtCol05
"tt-ExpoArt.ArtCol05" "Columna-05" "x(50)" "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tt-ExpoArt.ArtCol06
"tt-ExpoArt.ArtCol06" "Columna-06" "x(50)" "character" ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-7 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Generacion de Plantillas, Carga productos propios */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Generacion de Plantillas, Carga productos propios */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-12 W-Win
ON CHOOSE OF BUTTON-12 IN FRAME F-Main /* Consultar */
DO:
    ASSIGN COMBO-BOX-linea.

    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                                vtatabla.tabla  = 'LP' AND
                                vtatabla.llave_c1 = USERID("DICTDB") /*s-user-id*/ AND
                                vtatabla.llave_c2 = COMBO-BOX-linea NO-LOCK NO-ERROR.
    IF (USERID("DICTDB") <> "ADMIN") AND (USERID("DICTDB") <> "MASTER") THEN DO:
        IF NOT AVAILABLE vtatabla THEN DO:
            MESSAGE "El usuario " + s-user-id + " no tiene asignado la linea" VIEW-AS ALERT-BOX INFORMATION.
            RETURN NO-APPLY.
        END.
    END.
  
    EMPTY TEMP-TABLE tt-expoart.
    DEFINE VAR x-grupo AS LOG.
    DEFINE VAR x-sec AS INT.
    DEFINE VAR x-sec2 AS INT.
    DEFINE VAR x-col01 AS CHAR.
    DEFINE VAR x-col02 AS CHAR.
    DEFINE VAR x-col03 AS CHAR.
    DEFINE VAR x-col04 AS CHAR.
    DEFINE VAR x-col05 AS CHAR.
    DEFINE VAR x-col06 AS CHAR.

    FOR EACH expogrpo WHERE expogrpo.codcia = s-codcia AND 
                                expogrpo.codfam = combo-box-linea NO-LOCK:
        x-grupo = YES.
        FOR EACH expoart WHERE expoart.codcia = expogrpo.codcia AND
                                expoart.codgrupo = expogrpo.codgrupo NO-LOCK:
            IF x-grupo = YES THEN DO:

                x-sec2 = IF(expogrpo.multititulo = YES) THEN 4 ELSE 1.
                REPEAT x-sec = 1 TO x-sec2:
                    IF expogrpo.multititulo = YES THEN DO:
                        x-col01 = "".
                        x-col02 = "".
                        x-col03 = "". 
                        x-col04 = "". 
                        x-col05 = "". 
                        x-col06 = "". 
                        IF NOT (TRUE <> (expogrpo.col01 > "")) THEN x-col01 = ENTRY(x-sec,expogrpo.col01,"!").
                        IF NOT (TRUE <> (expogrpo.col02 > "")) THEN x-col02 = ENTRY(x-sec,expogrpo.col02,"!").
                        IF NOT (TRUE <> (expogrpo.col03 > "")) THEN x-col03 = ENTRY(x-sec,expogrpo.col03,"!").
                        IF NOT (TRUE <> (expogrpo.col04 > "")) THEN x-col04 = ENTRY(x-sec,expogrpo.col04,"!").
                        IF NOT (TRUE <> (expogrpo.col05 > "")) THEN x-col05 = ENTRY(x-sec,expogrpo.col05,"!").
                        IF NOT (TRUE <> (expogrpo.col06 > "")) THEN x-col06 = ENTRY(x-sec,expogrpo.col06,"!").
                    END.
                    ELSE DO:
                        x-col01 = expogrpo.col01.
                        x-col02 = expogrpo.col02.
                        x-col03 = expogrpo.col03.
                        x-col04 = expogrpo.col04.
                        x-col05 = expogrpo.col05.
                        x-col06 = expogrpo.col06.
                    END.
                    CREATE tt-expoart.
                    ASSIGN  tt-expoart.codcia = s-codcia
                            tt-expoart.codgrupo = expogrpo.codgrupo                            
                            tt-expoart.ttitulo = 'SI'
                            tt-expoart.um = ""
                            tt-expoart.caja = ""
                            tt-expoart.vtamin = ""
                            tt-expoart.artcol01 = x-col01
                            tt-expoart.artcol02 = x-col02
                            tt-expoart.artcol03 = x-col03
                            tt-expoart.artcol04 = x-col04
                            tt-expoart.artcol05 = x-col05
                            tt-expoart.artcol06 = x-col06
                    .
                    IF x-sec = 1  THEN tt-expoart.desmatxart = expogrpo.desgrupo.
                    IF x-sec = 2  THEN tt-expoart.desmatxart = "UM".
                    IF x-sec = 3  THEN tt-expoart.desmatxart = "Caja".
                    IF x-sec = 4  THEN tt-expoart.desmatxart = "Min".
                END.

            END.
            CREATE tt-expoart.
            BUFFER-COPY expoart TO tt-expoart.
            ASSIGN tt-expoart.ttitulo = ''.
            x-grupo = NO.
        END.
    END.

    {&open-query-browse-7}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-13 W-Win
ON CHOOSE OF BUTTON-13 IN FRAME F-Main /* Generar Plantilla de Excel */
DO:
  RUN generar-plantilla.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-7
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

DEF VAR celda_br AS WIDGET-HANDLE EXTENT 150 NO-UNDO.
 DEF VAR cual_celda AS WIDGET-HANDLE NO-UNDO.
 DEF VAR n_cols_browse AS INT NO-UNDO.
 DEF VAR col_act AS INT NO-UNDO.
 DEF VAR t_col_br AS INT NO-UNDO INITIAL 2.             /* Color del background de la celda ( 2 : Verde)*/
 DEF VAR vg_col_eti_b AS INT NO-UNDO INITIAL 15.        /* Color del la letra de la celda (15 : Blanco) */      

ON ROW-DISPLAY OF browse-7
DO:
  IF tt-expoart.ttitulo <> 'SI' THEN return.

  DO col_act = 1 TO n_cols_browse.
      
     cual_celda = celda_br[col_act].
     cual_celda:BGCOLOR = t_col_br.
     cual_celda:FGCOLOR = vg_col_eti_b.
  END.
END.

DO n_cols_browse = 1 TO browse-7:NUM-COLUMNS.
   celda_br[n_cols_browse] = browse-7:GET-BROWSE-COLUMN(n_cols_browse).
   cual_celda = celda_br[n_cols_browse].
     
   IF vg_col_eti_b <> 0 THEN cual_celda:LABEL-BGCOLOR = vg_col_eti_b.
   /*IF n_cols_browse = 15 THEN LEAVE.*/
END.

n_cols_browse = browse-7:NUM-COLUMNS.

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
  DISPLAY COMBO-BOX-linea 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-12 COMBO-BOX-linea BUTTON-13 BROWSE-7 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-plantilla W-Win 
PROCEDURE generar-plantilla :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.
define VAR cValue as char.

lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = YES.       /* YES : Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

chExcelApplication:Visible = TRUE.

lMensajeAlTerminar = NO. /*  */
lCerrarAlTerminar = NO. /* Si permanece abierto el Excel luego de concluir el proceso */
/*cColList - Array Columnas (A,B,C...AA,AB,AC...) */

chWorkSheet = chExcelApplication:Sheets:Item(1).  

iRow = 1.
    cColumn = TRIM(STRING(iRow)).
    cRange = "A" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "Familia".
    cRange = "B" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "TITULO".
    cRange = "C" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "Producto".
    cRange = "D" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "UM".
    cRange = "E" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "Caja".
    cRange = "F" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "VtaMin".
    cRange = "G" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "Columna-01".
    cRange = "H" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "Columna-02".
    cRange = "I" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "Columna-03".
    cRange = "J" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "Columna-04".
    cRange = "K" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "Columna-05".
    cRange = "L" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "Columna-06".


iRow = 2.

GET FIRST {&BROWSE-NAME}.
DO  WHILE AVAILABLE tt-expoart:
    cColumn = TRIM(STRING(iRow)).
    cRange = "A" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "'" + combo-box-linea.
    cRange = "B" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "'" + IF (TRUE <> (tt-expoart.ttitulo > "")) THEN "" ELSE tt-expoart.ttitulo.
    cRange = "C" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "'" + tt-expoart.desmatxart.
    cRange = "D" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "'" + IF (TRUE <> (tt-expoart.um > "")) THEN "" ELSE tt-expoart.um.
    cRange = "E" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "'" + IF (TRUE <> (tt-expoart.caja > "")) THEN "" ELSE tt-expoart.caja.
    cRange = "F" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "'" + IF (TRUE <> (tt-expoart.vtamin > "")) THEN "" ELSE tt-expoart.vtamin.
    cRange = "G" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "'" + IF (TRUE <> (tt-expoart.artcol01 > "")) THEN "" ELSE tt-expoart.artcol01.
    cRange = "H" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "'" + IF (TRUE <> (tt-expoart.artcol02 > "")) THEN "" ELSE tt-expoart.artcol02.
    cRange = "I" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "'" + IF (TRUE <> (tt-expoart.artcol03 > "")) THEN "" ELSE tt-expoart.artcol03.
    cRange = "J" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "'" + IF (TRUE <> (tt-expoart.artcol04 > "")) THEN "" ELSE tt-expoart.artcol04.
    cRange = "K" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "'" + IF (TRUE <> (tt-expoart.artcol05 > "")) THEN "" ELSE tt-expoart.artcol05.
    cRange = "L" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "'" + IF (TRUE <> (tt-expoart.artcol06 > "")) THEN "" ELSE tt-expoart.artcol06.

    IF CAPS(tt-expoart.ttitulo) = 'SI' THEN DO:
        cRange = "A" + cColumn + ":" + CHR(65 + 11) + cColumn.
        chWorkSheet:Range(cRange):Select().
        chExcelApplication:Selection:Interior:ColorIndex = 10.
        chExcelApplication:Selection:FONT:ColorIndex = 2.
    END.

    GET NEXT {&BROWSE-NAME}.
    iRow = iRow + 1.
END.

ASSIGN cRange = CHR(65) + ":" + CHR(65 + 11).
    chWorkSheet:COLUMNS(cRange):SELECT.
    chWorkSheet:COLUMNS(cRange):autofit.
    chWorkSheet:range("A1"):SELECT.


{lib\excel-close-file.i} 



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
  
  DO WITH FRAME {&FRAME-NAME} :
      COMBO-BOX-linea:DELETE(COMBO-BOX-linea:NUM-ITEMS) IN FRAME {&FRAME-NAME}.
      FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND
                                        vtatabla.tabla = 'LINEAS-CATALOGO-PP' NO-LOCK :
            combo-box-Linea:ADD-LAST("Linea " + vtatabla.llave_c1 , vtatabla.llave_c1).
            IF TRUE <> (combo-box-Linea:SCREEN-VALUE > "") THEN DO:
                combo-box-Linea:SCREEN-VALUE = vtatabla.llave_c1.
            END.
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
  {src/adm/template/snd-list.i "tt-ExpoArt"}

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

