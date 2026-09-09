&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttExpoTmpo NO-UNDO LIKE ExpoTmpo
       fields ttQtot as decimal.



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
DEFINE VAR pCodGrupo AS CHAR INIT '010'.

DEFINE VAR pColumnDataOld AS DEC INIT 0.

&SCOPED-DEFINE CONDICION ( ~
            ttExpoTmpo.CodCia = s-codcia AND ~
            ttExpoTmpo.Codgrupo = pCodgrupo)

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-4

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttExpoTmpo

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 ttExpoTmpo.Descripcion ~
ttExpoTmpo.Umed ttExpoTmpo.UMCaja ttExpoTmpo.Qvtamin ttExpoTmpo.QCol1 ~
ttExpoTmpo.QCol2 ttExpoTmpo.QCol3 ttExpoTmpo.QCol4 ttExpoTmpo.QCol5 ~
ttExpoTmpo.QCol6 Qcol1 + qCol2 + qCol3 + qCol4 + qCol5 + qCol6 @ ttQtot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 ttExpoTmpo.QCol1 ~
ttExpoTmpo.QCol2 ttExpoTmpo.QCol3 ttExpoTmpo.QCol4 ttExpoTmpo.QCol5 ~
ttExpoTmpo.QCol6 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-4 ttExpoTmpo
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-4 ttExpoTmpo
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH ttExpoTmpo ~
      WHERE {&Condicion} NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH ttExpoTmpo ~
      WHERE {&Condicion} NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 ttExpoTmpo
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 ttExpoTmpo


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS CboFamilia BtnAcceptar cboGrupo BROWSE-4 
&Scoped-Define DISPLAYED-OBJECTS CboFamilia cboGrupo txtCol1 txtCol2 ~
txtCol3 txtCol4 txtCol5 txtCol6 txtTotal 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD uf-celda-editable W-Win 
FUNCTION uf-celda-editable RETURNS LOGICAL
  ( INPUT cColumna AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD uf-get-codmat W-Win 
FUNCTION uf-get-codmat RETURNS CHARACTER
  ( INPUT cColumna AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD uf-tecla-funcion W-Win 
FUNCTION uf-tecla-funcion RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnAcceptar 
     LABEL "Aceptar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE CboFamilia AS CHARACTER FORMAT "X(256)":U INITIAL "010" 
     LABEL "Familia" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Familia 10","010",
                     "Familia 12","012",
                     "Familia 13","013"
     DROP-DOWN-LIST
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cboGrupo AS CHARACTER FORMAT "X(256)":U INITIAL "000" 
     LABEL "Grupo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "<Ninguno>","000"
     DROP-DOWN-LIST
     SIZE 57 BY 1 NO-UNDO.

DEFINE VARIABLE txtCol1 AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11 BY .85
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE txtCol2 AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11 BY .85
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE txtCol3 AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11 BY .85
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE txtCol4 AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11 BY .85
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE txtCol5 AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11 BY .85
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE txtCol6 AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11 BY .85
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE txtTotal AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .85
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      ttExpoTmpo SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      ttExpoTmpo.Descripcion COLUMN-LABEL "A R T I C U L O" FORMAT "x(80)":U
            WIDTH 42.57 COLUMN-FONT 11
      ttExpoTmpo.Umed COLUMN-LABEL "U.M." FORMAT "x(25)":U WIDTH 14
      ttExpoTmpo.UMCaja COLUMN-LABEL "CAJA" FORMAT "x(15)":U WIDTH 12.43
      ttExpoTmpo.Qvtamin COLUMN-LABEL "VTA. MIN." FORMAT "x(25)":U
            WIDTH 6.86
      ttExpoTmpo.QCol1 FORMAT ">>>,>>>,>>9.99":U WIDTH 10.43
      ttExpoTmpo.QCol2 FORMAT ">>>,>>>,>>9.99":U WIDTH 10.43
      ttExpoTmpo.QCol3 FORMAT ">>>,>>>,>>9.99":U WIDTH 10.43
      ttExpoTmpo.QCol4 FORMAT ">>>,>>>,>>9.99":U WIDTH 10.43
      ttExpoTmpo.QCol5 FORMAT ">>>,>>>,>>9.99":U WIDTH 10.43
      ttExpoTmpo.QCol6 FORMAT ">>>,>>>,>>9.99":U WIDTH 10.43
      Qcol1 + qCol2 + qCol3 + qCol4 + qCol5 + qCol6 @ ttQtot COLUMN-LABEL "T O T A L" FORMAT ">>>,>>9.99":U
            WIDTH 13.14 COLUMN-FGCOLOR 4 COLUMN-BGCOLOR 15 COLUMN-FONT 9
  ENABLE
      ttExpoTmpo.QCol1
      ttExpoTmpo.QCol2
      ttExpoTmpo.QCol3
      ttExpoTmpo.QCol4
      ttExpoTmpo.QCol5
      ttExpoTmpo.QCol6
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 159.14 BY 19.04 ROW-HEIGHT-CHARS .73.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CboFamilia AT ROW 1.38 COL 6.86 COLON-ALIGNED WIDGET-ID 2
     BtnAcceptar AT ROW 1.38 COL 117 WIDGET-ID 6
     cboGrupo AT ROW 1.42 COL 51.43 COLON-ALIGNED WIDGET-ID 4
     BROWSE-4 AT ROW 4.08 COL 1.86 WIDGET-ID 200
     txtCol1 AT ROW 23.23 COL 90.14 RIGHT-ALIGNED NO-LABEL WIDGET-ID 8
     txtCol2 AT ROW 23.23 COL 101.14 RIGHT-ALIGNED NO-LABEL WIDGET-ID 10
     txtCol3 AT ROW 23.23 COL 112.29 RIGHT-ALIGNED NO-LABEL WIDGET-ID 12
     txtCol4 AT ROW 23.23 COL 123.14 RIGHT-ALIGNED NO-LABEL WIDGET-ID 14
     txtCol5 AT ROW 23.23 COL 134.29 RIGHT-ALIGNED NO-LABEL WIDGET-ID 16
     txtCol6 AT ROW 23.23 COL 145.29 RIGHT-ALIGNED NO-LABEL WIDGET-ID 18
     txtTotal AT ROW 23.23 COL 159.01 RIGHT-ALIGNED NO-LABEL WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 161.57 BY 24.08 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Temp-Tables and Buffers:
      TABLE: ttExpoTmpo T "?" NO-UNDO INTEGRAL ExpoTmpo
      ADDITIONAL-FIELDS:
          fields ttQtot as decimal
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Prueba Browse"
         HEIGHT             = 24.08
         WIDTH              = 161.57
         MAX-HEIGHT         = 31.35
         MAX-WIDTH          = 164.57
         VIRTUAL-HEIGHT     = 31.35
         VIRTUAL-WIDTH      = 164.57
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
/* BROWSE-TAB BROWSE-4 cboGrupo F-Main */
/* SETTINGS FOR FILL-IN txtCol1 IN FRAME F-Main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN txtCol2 IN FRAME F-Main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN txtCol3 IN FRAME F-Main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN txtCol4 IN FRAME F-Main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN txtCol5 IN FRAME F-Main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN txtCol6 IN FRAME F-Main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN txtTotal IN FRAME F-Main
   NO-ENABLE ALIGN-R                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "Temp-Tables.ttExpoTmpo"
     _Options          = "NO-LOCK"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > Temp-Tables.ttExpoTmpo.Descripcion
"ttExpoTmpo.Descripcion" "A R T I C U L O" ? "character" ? ? 11 ? ? ? no ? no no "42.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.ttExpoTmpo.Umed
"ttExpoTmpo.Umed" "U.M." ? "character" ? ? ? ? ? ? no ? no no "14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.ttExpoTmpo.UMCaja
"ttExpoTmpo.UMCaja" "CAJA" ? "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ttExpoTmpo.Qvtamin
"ttExpoTmpo.Qvtamin" "VTA. MIN." ? "character" ? ? ? ? ? ? no ? no no "6.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ttExpoTmpo.QCol1
"ttExpoTmpo.QCol1" ? ? "decimal" ? ? ? ? ? ? yes ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ttExpoTmpo.QCol2
"ttExpoTmpo.QCol2" ? ? "decimal" ? ? ? ? ? ? yes ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ttExpoTmpo.QCol3
"ttExpoTmpo.QCol3" ? ? "decimal" ? ? ? ? ? ? yes ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ttExpoTmpo.QCol4
"ttExpoTmpo.QCol4" ? ? "decimal" ? ? ? ? ? ? yes ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.ttExpoTmpo.QCol5
"ttExpoTmpo.QCol5" ? ? "decimal" ? ? ? ? ? ? yes ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.ttExpoTmpo.QCol6
"ttExpoTmpo.QCol6" ? ? "decimal" ? ? ? ? ? ? yes ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"Qcol1 + qCol2 + qCol3 + qCol4 + qCol5 + qCol6 @ ttQtot" "T O T A L" ">>>,>>9.99" ? 15 4 9 ? ? ? no ? no no "13.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Prueba Browse */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Prueba Browse */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnAcceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnAcceptar W-Win
ON CHOOSE OF BtnAcceptar IN FRAME F-Main /* Aceptar */
DO:
    ASSIGN cboGrupo.
    
DEF VAR t_col_br AS INT NO-UNDO INITIAL 11. 
DEF VAR t_col_eti AS INT NO-UNDO INITIAL 2. 

DEF VAR t_celda_br AS WIDGET-HANDLE EXTENT 15 NO-UNDO. 
DEF VAR t_cual_celda AS WIDGET-HANDLE NO-UNDO. 
DEF VAR t_n_cols_browse AS INT NO-UNDO. 
DEF VAR t_col_act AS INT NO-UNDO. 

DEFINE VAR lTextoAdd AS CHAR INIT "".

DO t_n_cols_browse = 1 TO browse-4:NUM-COLUMNS. 
 t_celda_br[t_n_cols_browse] = browse-4:GET-BROWSE-COLUMN(t_n_cols_browse). 

 /*IF t_n_cols_browse = 15 THEN LEAVE. */
END. 
/* Reset LABEL Header */
DO t_n_cols_browse = 1 TO browse-4:NUM-COLUMNS. 
    t_cual_celda = t_celda_br[t_n_cols_browse]. 
    t_cual_celda:LABEL = " ".    
    /* No al TOTAL */
    IF t_n_cols_browse = (browse-4:NUM-COLUMNS - 1 ) THEN LEAVE. 
END.

t_cual_celda = t_celda_br[2]. 
t_cual_celda:LABEL = "U.M.".
t_cual_celda = t_celda_br[3]. 
t_cual_celda:LABEL = "CAJA".
t_cual_celda = t_celda_br[4]. 
t_cual_celda:LABEL = "VTA.MIN.".

FIND FIRST expoGrpo WHERE expogrpo.codcia = 1 AND expogrpo.codgrupo = cboGrupo
                             NO-LOCK NO-ERROR.
IF AVAILABLE expogrpo THEN DO:

    /**/
    lTextoAdd = IF (cboFamilia = '013') THEN "!         UM!         CAJA!        MIN.VTA" ELSE "".
    t_cual_celda = t_celda_br[1]. 
    t_cual_celda:LABEL = TRIM(expogrpo.desgrupo) + lTextoAdd.

    /**/
    /*lTextoAdd = IF (cboFamilia = '013') THEN "!         !           !           " ELSE "".*/
    lTextoAdd = IF (cboFamilia = '013') THEN "!" ELSE "".
    t_cual_celda = t_celda_br[5]. 
    t_cual_celda:LABEL = lTextoAdd + TRIM(expogrpo.col01).
    t_cual_celda = t_celda_br[6]. 
    t_cual_celda:LABEL = lTextoAdd + TRIM(expogrpo.col02).
    t_cual_celda = t_celda_br[7]. 
    t_cual_celda:LABEL = lTextoAdd + TRIM(expogrpo.col03).
    t_cual_celda = t_celda_br[8]. 
    t_cual_celda:LABEL = lTextoAdd + TRIM(expogrpo.col04).
    t_cual_celda = t_celda_br[9]. 
    t_cual_celda:LABEL = lTextoAdd + TRIM(expogrpo.col05).
    t_cual_celda = t_celda_br[10]. 
    t_cual_celda:LABEL = lTextoAdd + TRIM(expogrpo.col06).
END.

ASSIGN cboFamilia.
t_cual_celda = t_celda_br[2]. 
t_cual_celda:VISIBLE = IF (cboFamilia = '013') THEN NO ELSE YES.
t_cual_celda = t_celda_br[3]. 
t_cual_celda:VISIBLE = IF (cboFamilia = '013') THEN NO ELSE YES.
t_cual_celda = t_celda_br[4]. 
t_cual_celda:VISIBLE = IF (cboFamilia = '013') THEN NO ELSE YES.

    
ASSIGN cboGrupo.  
pCodGrupo = cboGrupo.
{&OPEN-QUERY-BROWSE-4}  

/* Totales */

txtCol1 = 0.
txtCol2 = 0.
txtCol3 = 0.
txtCol4 = 0.
txtCol5 = 0.
txtCol6 = 0.

GET FIRST {&BROWSE-NAME}.
DO  WHILE AVAILABLE ttExpoTmpo:
    txtCol1 = txtCol1 + ttExpoTmpo.QCOL1.
    txtCol2 = txtCol2 + ttExpoTmpo.QCOL2.
    txtCol3 = txtCol3 + ttExpoTmpo.QCOL3.
    txtCol4 = txtCol4 + ttExpoTmpo.QCOL4.
    txtCol5 = txtCol5 + ttExpoTmpo.QCOL5.
    txtCol6 = txtCol6 + ttExpoTmpo.QCOL6.
    GET NEXT {&BROWSE-NAME}.
END.

IF cboFamilia = '013' THEN DO:
    txtCol1:X = 294 + 15 .
    txtCol2:X = txtCol1:X + 77.
    txtCol3:X = txtCol2:X + 77.
    txtCol4:X = txtCol3:X + 77.
    txtCol5:X = txtCol4:X + 77.
    txtCol6:X = txtCol5:X + 77.
    txtTotal:X = txtCol6:X + 77.
END.
ELSE DO: 
    txtCol1:X = 624 - 70.
    txtCol2:X = txtCol1:X + 77.
    txtCol3:X = txtCol2:X + 77.
    txtCol4:X = txtCol3:X + 77.
    txtCol5:X = txtCol4:X + 77.
    txtCol6:X = txtCol5:X + 77.
    txtTotal:X = txtCol6:X + 77.    
END.

txtTotal = txtCol1 + txtCol2 + txtCol3 + txtCol4 + txtCol5 + txtCol6.
DISPLAY txtCol1 txtCol2 txtCol3 txtCol4 txtCol5 txtCol6 txtTotal WITH FRAME {&FRAME-NAME}.

GET FIRST {&BROWSE-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CboFamilia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CboFamilia W-Win
ON VALUE-CHANGED OF CboFamilia IN FRAME F-Main /* Familia */
DO:
 ASSIGN cboFamilia.
 DEFINE VAR lCodFam AS CHAR.
 DEFINE VAR lSec AS INT.

 lCodFam = cboFamilia.

 lSec = 1.
 CboGrupo:DELETE(CboGrupo:LIST-ITEM-PAIRS).
  FOR EACH expogrpo WHERE expogrpo.codcia = 1 AND 
      expogrpo.codfam = lCodFam NO-LOCK:
        cboGrupo:ADD-LAST(expogrpo.desgrupo , expogrpo.codgrupo).
      IF lSec = 1 THEN DO:
        cboGrupo:SCREEN-VALUE = expogrpo.codgrupo.
      END.
      lSec = lSec + 1.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

DEF VAR t_col_br AS INT NO-UNDO INITIAL 11. 
DEF VAR t_col_eti AS INT NO-UNDO INITIAL 2. 

DEF VAR t_celda_br AS WIDGET-HANDLE EXTENT 15 NO-UNDO. 
DEF VAR t_cual_celda AS WIDGET-HANDLE NO-UNDO. 
DEF VAR t_n_cols_browse AS INT NO-UNDO. 
DEF VAR t_col_act AS INT NO-UNDO. 

ON 'value-changed':U OF QCol1, QCol2, QCol3, QCol4, QCol5, QCol6 IN BROWSE BROWSE-4
DO:
    DEFINE VARIABLE hColumn AS HANDLE      NO-UNDO.
    DEFINE VAR cColumnName AS CHAR.

    ASSIGN hColumn = SELF:HANDLE.
    cColumnName = CAPS(hColumn:NAME).   
    
END.

ON ROW-DISPLAY OF browse-4 
DO: 

    DEFINE VAR lCodGrupo AS CHAR.
    DEFINE VAR lCodMtxArt AS CHAR.

    lCodGrupo = ttExpotmpo.codgrupo.
    lCodMtxArt = ttExpotmpo.codmtxart.

    FIND FIRST expoArt WHERE expoArt.codcia = s-codcia AND 
                            expoArt.codgrupo = lCodGrupo AND
                            expoArt.codmtxart = lCodMtxArt
                            NO-LOCK NO-ERROR.
    
    IF AVAILABLE expoart THEN DO:
        t_cual_celda = t_celda_br[5]. 
        t_cual_celda:BGCOLOR = IF (expoart.artcol01 = "" OR expoart.artcol01 = ?)  THEN 7 ELSE 15.
        /*t_cual_celda:FGCOLOR = IF (expoart.artcol01 = "" OR expoart.artcol01 = ?)  THEN 7 ELSE ?.*/
        IF (expoart.artcol01 = "" OR expoart.artcol01 = ?) THEN DO:
            t_cual_celda:FGCOLOR = 7.
        END.
        ELSE DO:
            t_cual_celda:FGCOLOR = IF (ttExpoTmpo.QCOL1 = 0) THEN 15 ELSE ?.
        END.

        t_cual_celda = t_celda_br[6]. 
        t_cual_celda:BGCOLOR = IF (expoart.artcol02 = "" OR expoart.artcol02 = ?)  THEN 7 ELSE 15.
        IF (expoart.artcol02 = "" OR expoart.artcol02 = ?) THEN DO:
            t_cual_celda:FGCOLOR = 7.
        END.
        ELSE DO:
            t_cual_celda:FGCOLOR = IF (ttExpoTmpo.QCOL2 = 0) THEN 15 ELSE ?.
        END.
        
        t_cual_celda = t_celda_br[7]. 
        t_cual_celda:BGCOLOR = IF (expoart.artcol03 = "" OR expoart.artcol03 = ?)  THEN 7 ELSE 15.
       IF (expoart.artcol03 = "" OR expoart.artcol03 = ?) THEN DO:
           t_cual_celda:FGCOLOR = 7.
       END.
       ELSE DO:
           t_cual_celda:FGCOLOR = IF (ttExpoTmpo.QCOL3 = 0) THEN 15 ELSE ?.
       END.
       
        t_cual_celda = t_celda_br[8]. 
        t_cual_celda:BGCOLOR = IF (expoart.artcol04 = "" OR expoart.artcol04 = ?)  THEN 7 ELSE 15.
       IF (expoart.artcol04 = "" OR expoart.artcol04 = ?) THEN DO:
           t_cual_celda:FGCOLOR = 7.
       END.
       ELSE DO:
           t_cual_celda:FGCOLOR = IF (ttExpoTmpo.QCOL4 = 0) THEN 15 ELSE ?.
       END.
        
        t_cual_celda = t_celda_br[9]. 
        t_cual_celda:BGCOLOR = IF (expoart.artcol05 = "" OR expoart.artcol05 = ?)  THEN 7 ELSE 15.
       IF (expoart.artcol05 = "" OR expoart.artcol05 = ?) THEN DO:
           t_cual_celda:FGCOLOR = 7.
       END.
       ELSE DO:
           t_cual_celda:FGCOLOR = IF (ttExpoTmpo.QCOL5 = 0) THEN 15 ELSE ?.
       END.
        
        t_cual_celda = t_celda_br[10]. 
        t_cual_celda:BGCOLOR = IF (expoart.artcol06 = "" OR expoart.artcol06 = ?)  THEN 7 ELSE 15.
       IF (expoart.artcol06 = "" OR expoart.artcol06 = ?) THEN DO:
           t_cual_celda:FGCOLOR = 7.
       END.
       ELSE DO:
           t_cual_celda:FGCOLOR = IF (ttExpoTmpo.QCOL6 = 0) THEN 15 ELSE ?.
       END.
        
    END.

END. 

ON ANY-KEY OF QCol1, QCol2, QCol3, QCol4, QCol5, QCol6 IN BROWSE BROWSE-4
DO:

    DEFINE VARIABLE hColumn AS HANDLE      NO-UNDO.
    DEFINE VAR cColumnName AS CHAR.

    ASSIGN hColumn = SELF:HANDLE.
    cColumnName = CAPS(hColumn:NAME).   
    
    IF uf-celda-editable(INPUT cColumnName) = NO THEN DO:
        /*  */        
        IF uf-tecla-funcion() = NO THEN RETURN NO-APPLY.
    END.
END.

ON LEAVE OF QCol1, QCol2, QCol3, QCol4, QCol5, QCol6 IN BROWSE BROWSE-4 
DO:

    DEFINE VAR lTot AS DEC.
    DEFINE VARIABLE hColumn AS HANDLE      NO-UNDO.
    DEFINE VAR cColumnName AS CHAR.
    DEFINE VAR lColumnDataNew AS DEC INIT 0.

    DEFINE VAR lVtaMin AS DEC INIT 0.
    DEFINE VAR lCodArt AS CHAR INIT "".
    DEFINE VAR lRowId AS ROWID.

    ASSIGN hColumn = SELF:HANDLE.
    cColumnName = CAPS(hColumn:NAME).   

    lColumnDataNew = DECIMAL(SELF:SCREEN-VALUE IN BROWSE BROWSE-4).

    /*  */
    IF uf-celda-editable(INPUT cColumnName) = YES THEN DO:

        /* El Codigo del Articulo */
        lCodArt = uf-get-codmat(INPUT cColumnName).

        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                    almmmatg.codmat = lCodArt 
                                    NO-LOCK NO-ERROR.
        IF AVAILABLE almmmatg THEN DO:
            lVtaMin = almmmatg.stkmax.
        END.
        IF lVtaMin <= 0 THEN lVtaMin = 1.
        IF (lColumnDataNew MODULO lVtaMin ) <> 0 THEN DO:
            MESSAGE "El valor debe ser Multiplo del Minimo de Venta".
            RETURN NO-APPLY.
        END.
        
        /* Refresh TOTALES */
        IF cColumnName = "QCOL1"  THEN txtCol1 = txtCol1 - pColumnDataOld + lColumnDataNew .
        IF cColumnName = "QCOL2"  THEN txtCol2 = txtCol2 - pColumnDataOld + lColumnDataNew.
        IF cColumnName = "QCOL3"  THEN txtCol3 = txtCol3 - pColumnDataOld + lColumnDataNew.
        IF cColumnName = "QCOL4"  THEN txtCol4 = txtCol4 - pColumnDataOld + lColumnDataNew.
        IF cColumnName = "QCOL5"  THEN txtCol5 = txtCol5 - pColumnDataOld + lColumnDataNew.
        IF cColumnName = "QCOL6"  THEN txtCol6 = txtCol6 - pColumnDataOld + lColumnDataNew.

        txtTotal = txtCol1 + txtCol2 + txtCol3 + txtCol4 + txtCol5 + txtCol6.
        DISPLAY txtCol1 txtCol2 txtCol3 txtCol4 txtCol5 txtCol6 txtTotal WITH FRAME {&FRAME-NAME}.

    END.

    lTot = DECIMAL(ttExpoTmpo.QCol1:SCREEN-VALUE IN BROWSE BROWSE-4) + 
        DECIMAL(ttExpoTmpo.QCol2:SCREEN-VALUE IN BROWSE BROWSE-4) + 
        DECIMAL(ttExpoTmpo.QCol3:SCREEN-VALUE IN BROWSE BROWSE-4) +
        DECIMAL(ttExpoTmpo.QCol4:SCREEN-VALUE IN BROWSE BROWSE-4) +
        DECIMAL(ttExpoTmpo.QCol5:SCREEN-VALUE IN BROWSE BROWSE-4) +
        DECIMAL(ttExpoTmpo.QCol6:SCREEN-VALUE IN BROWSE BROWSE-4).

    ttExpoTmpo.ttQtot:SCREEN-VALUE IN BROWSE BROWSE-4 = STRING(lTot,">>>,>>9.99").

    /* Color de la CELDA que se esta saliendo */
    RUN ue-celda-color(INPUT hColumn, "LEAVE").

    /* Ubicar la siguiente Celda EDITABLE */
    IF LASTKEY = KEYCODE("ENTER") OR LASTKEY = KEYCODE("DOWN-ARROW") THEN DO:
        /*
        RUN ue-siguiente-celda-editable(INPUT hColumn, OUTPUT lRowId).
        IF lRowid <> ? THEN DO:
            REPOSITION {&BROWSE-NAME} TO ROWID lRowId.
        END.
        */
    END.    
END.
    
ON ENTRY OF QCol1, QCol2, QCol3, QCol4, QCol5, QCol6 IN BROWSE BROWSE-4
DO:
    /**/
    DEFINE VARIABLE hColumn AS HANDLE      NO-UNDO.
    DEFINE VAR cColumnName AS CHAR.

    /*MESSAGE ttExpoTmpo.descripcion.*/

    ASSIGN hColumn = SELF:HANDLE.
    cColumnName = CAPS(hColumn:NAME).     
    
    /* Si no es EDITABLE salir */
    IF uf-celda-editable(INPUT cColumnName) = NO THEN DO:        
        RETURN NO-APPLY.
    END.
   /* ELSE hColumn:FGCOLOR = ?.*/
   
    pColumnDataOld = DECIMAL(SELF:SCREEN-VALUE IN BROWSE BROWSE-4).

    RUN ue-celda-color(INPUT hColumn, "ENTRY").
  
END.
/*
ON ENTRY OF BROWSE {&BROWSE-NAME} ANYWHERE DO:
    DEFINE VARIABLE hColumn AS HANDLE NO-UNDO.
    DEFINE VARIABLE iCounter AS INTEGER NO-UNDO.
    
    ASSIGN
        hColumn = SELF:HANDLE
        iCounter = 1.
    IF VALID-HANDLE(hColumn) AND hColumn:TYPE = "FILL-IN" THEN
        DO WHILE hColumn <> {&BROWSE-NAME}:FIRST-COLUMN :
            ASSIGN
                iCounter = iCounter + 1
                hColumn = hColumn:PREV-COLUMN.
        END.
        MESSAGE "Current column is column number: " iCounter of " {&BROWSE-NAME}:NUM-COLUMNS 
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
END.
*/    

DO t_n_cols_browse = 1 TO browse-4:NUM-COLUMNS. 
 t_celda_br[t_n_cols_browse] = browse-4:GET-BROWSE-COLUMN(t_n_cols_browse). 
 t_cual_celda = t_celda_br[t_n_cols_browse]. 
 t_cual_celda:LABEL-BGCOLOR = t_col_eti. 
 t_cual_celda:LABEL-FONT = IF (t_n_cols_browse < 5) THEN 12 ELSE 6. 
 t_cual_celda:COLUMN-FONT = IF (t_n_cols_browse < 5) THEN 2 ELSE 6.
 t_cual_celda:LABEL-FGCOLOR = 15. 

 /*IF t_n_cols_browse = 15 THEN LEAVE. */
END. 
/*
t_n_cols_browse = browse-4:NUM-COLUMNS. 
IF t_n_cols_browse > 15 THEN t_n_cols_browse = 15.
*/

/* Titulos */
t_cual_celda = t_celda_br[5]. 
t_cual_celda:LABEL = ''.
t_cual_celda = t_celda_br[6]. 
t_cual_celda:LABEL = ''.
t_cual_celda = t_celda_br[7]. 
t_cual_celda:LABEL = ''.
t_cual_celda = t_celda_br[8]. 
t_cual_celda:LABEL = ''.
t_cual_celda = t_celda_br[9]. 
t_cual_celda:LABEL = ''.
t_cual_celda = t_celda_br[10]. 
t_cual_celda:LABEL = ''.


/*
/* Iman - Titulo*/
t_cual_celda = t_celda_br[1]. 
t_cual_celda:LABEL = 'Iman!Cesar'.

t_cual_celda = t_celda_br[4]. 
t_cual_celda:VISIBLE = NO.

*/

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
  DISPLAY CboFamilia cboGrupo txtCol1 txtCol2 txtCol3 txtCol4 txtCol5 txtCol6 
          txtTotal 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE CboFamilia BtnAcceptar cboGrupo BROWSE-4 
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

  DEFINE VAR lSec AS INT.
  DEFINE VAR lCodFam AS CHAR INIT '010'.

  lSec = 1.

  CboGrupo:DELETE(CboGrupo:LIST-ITEM-PAIRS) IN FRAME {&FRAME-NAME}.
  FOR EACH expogrpo WHERE expogrpo.codcia = s-codcia AND 
     expogrpo.codfam = lCodFam NO-LOCK:
       cboGrupo:ADD-LAST(expogrpo.desgrupo , expogrpo.codgrupo).
     IF lSec = 1 THEN DO:
       cboGrupo:SCREEN-VALUE = expogrpo.codgrupo.
     END.
     lSec = lSec + 1.
  END.


  /* Code placed here will execute AFTER standard behavior.    */
  EMPTY TEMP-TABLE ttExpoTmpo.
  FOR EACH expoArt NO-LOCK:
        CREATE ttExpoTmpo.
        ASSIGN ttExpoTmpo.Codgrupo = expoArt.Codgrupo
                ttExpoTmpo.CodMtxArt = expoart.codmtxart
                ttExpoTmpo.Descripcion = expoart.desmatxart
                ttExpoTmpo.umed = expoart.um
                ttExpoTmpo.umcaja = expoart.caja
                ttExpoTmpo.qvtamin = expoart.vtamin
                ttExpoTmpo.Codcia = s-codcia.
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
  {src/adm/template/snd-list.i "ttExpoTmpo"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-celda-color W-Win 
PROCEDURE ue-celda-color :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
        pEvent = DISPLAY, LEAVE, ENTRY
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCelda AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER pEvent AS CHAR.

DEFINE VAR lEvent AS CHAR.
DEFINE VAR lColumnName AS CHAR INIT "".
DEFINE VAR lColumnDataNew AS DEC INIT 0.

lColumnName = CAPS(pCelda:NAME).
lEvent = CAPS(pEvent).

CASE lEvent:
    WHEN "ENTRY" THEN DO:
        IF uf-celda-editable(INPUT lColumnName) = YES THEN DO:
            pCelda:FGCOLOR = ?.
        END.
        ELSE pCelda:FGCOLOR = 7.
    END.

    WHEN "LEAVE" THEN DO:        
        IF uf-celda-editable(INPUT lColumnName) = YES THEN DO:
            lColumnDataNew = DECIMAL(pCelda:SCREEN-VALUE ).
            pCelda:FGCOLOR = IF(lColumnDataNew = 0) THEN 15 ELSE ?.
        END.
        ELSE DO:
            pCelda:FGCOLOR = 7.
        END.
    END.

    WHEN "DISPLAY" THEN DO:
        /*
        IF uf-celda-editable(INPUT lColumnName)=YES THEN DO:
        END.
        */
    END.
END CASE.

/*
    DEFINE VARIABLE hColumn AS HANDLE      NO-UNDO.
    DEFINE VAR cColumnName AS CHAR.

    ASSIGN hColumn = SELF:HANDLE.
    cColumnName = CAPS(hColumn:NAME).

    pColumnDataOld = DECIMAL(SELF:SCREEN-VALUE IN BROWSE BROWSE-4).

    hColumn:FGCOLOR = ?.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-siguiente-celda-editable W-Win 
PROCEDURE ue-siguiente-celda-editable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pColumn AS HANDLE    NO-UNDO.
DEFINE OUTPUT PARAMETER pRowId AS ROWID    NO-UNDO.

/*DEFINE BUFFER b-ttExpoTmpo FOR ttExpoTmpo.*/

DEFINE VAR lRowId AS ROWID.
DEFINE VAR lRowId2 AS ROWID.
DEFINE VAR cColName AS CHAR.

cColName = CAPS(pColumn:NAME).
lRowId = ROWID(ttExpoTmpo).
pRowId = ?.

/*
FIND FIRST b-ttExpoTmpo WHERE ROWID(b-ttExpoTmpo) = lRowId NO-ERROR.
IF AVAILABLE b-ttExpoTmpo THEN DO:
*/
    GET NEXT {&BROWSE-NAME}.
    DO  WHILE AVAILABLE ttExpoTmpo:
        lRowId2 = ROWID(ttExpoTmpo).
        /*  */
        IF uf-celda-editable(INPUT cColName) = YES THEN DO:
            /**/
            IF cColName = 'QCOL1' THEN APPLY 'ENTRY':U TO ttExpoTmpo.QCOL1 IN BROWSE {&BROWSE-NAME}.
            IF cColName = 'QCOL2' THEN APPLY 'ENTRY':U TO ttExpoTmpo.QCOL2 IN BROWSE {&BROWSE-NAME}.
            IF cColName = 'QCOL3' THEN APPLY 'ENTRY':U TO ttExpoTmpo.QCOL3 IN BROWSE {&BROWSE-NAME}.
            IF cColName = 'QCOL4' THEN APPLY 'ENTRY':U TO ttExpoTmpo.QCOL4 IN BROWSE {&BROWSE-NAME}.
            IF cColName = 'QCOL5' THEN APPLY 'ENTRY':U TO ttExpoTmpo.QCOL5 IN BROWSE {&BROWSE-NAME}.
            IF cColName = 'QCOL6' THEN APPLY 'ENTRY':U TO ttExpoTmpo.QCOL6 IN BROWSE {&BROWSE-NAME}.

            /*FIND FIRST ttExpoTmpo WHERE ROWID(ttExpoTmpo) = lRowId NO-ERROR.*/
            pRowId = lRowId2.
            /*REPOSITION {&BROWSE-NAME} TO ROWID lRowId2.*/

            LEAVE.
        END.        
        GET NEXT {&BROWSE-NAME}.
    END.
/*END.*/

/*RELEASE b-ttExpoTmpo.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION uf-celda-editable W-Win 
FUNCTION uf-celda-editable RETURNS LOGICAL
  ( INPUT cColumna AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR lCodGrupo AS CHAR.
    DEFINE VAR lCodMtxArt AS CHAR.
    DEFINE VAR lCodArt AS CHAR INIT "".
    DEFINE VAR lRetval AS LOG INIT NO.
    DEFINE VAR cColumnName AS CHAR.

    lCodGrupo = ttExpotmpo.codgrupo.
    lCodMtxArt = ttExpotmpo.codmtxart.
    cColumnName = CAPS(cColumna).

    FIND FIRST expoArt WHERE expoArt.codcia = s-codcia AND 
                            expoArt.codgrupo = lCodGrupo AND
                            expoArt.codmtxart = lCodMtxArt
                            NO-LOCK NO-ERROR.
    IF AVAILABLE expoart THEN DO:
        IF cColumnName = "QCOL1"  THEN lCodArt = expoart.artcol01.
        IF cColumnName = "QCOL2"  THEN lCodArt = expoart.artcol02.
        IF cColumnName = "QCOL3"  THEN lCodArt = expoart.artcol03.
        IF cColumnName = "QCOL4"  THEN lCodArt = expoart.artcol04.
        IF cColumnName = "QCOL5"  THEN lCodArt = expoart.artcol05.
        IF cColumnName = "QCOL6"  THEN lCodArt = expoart.artcol06.

        IF (lCodArt <> "" AND lCodArt <> ?) THEN DO:
            lRetVal = YES.
        END.
    END.

  RETURN lRetval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION uf-get-codmat W-Win 
FUNCTION uf-get-codmat RETURNS CHARACTER
  ( INPUT cColumna AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR lCodGrupo AS CHAR.
    DEFINE VAR lCodMtxArt AS CHAR.
    DEFINE VAR lCodArt AS CHAR INIT "".
    DEFINE VAR lRetval AS CHAR INIT "".
    DEFINE VAR cColumnName AS CHAR.

    lCodGrupo = ttExpotmpo.codgrupo.
    lCodMtxArt = ttExpotmpo.codmtxart.
    cColumnName = CAPS(cColumna).

    FIND FIRST expoArt WHERE expoArt.codcia = s-codcia AND 
                            expoArt.codgrupo = lCodGrupo AND
                            expoArt.codmtxart = lCodMtxArt
                            NO-LOCK NO-ERROR.
    IF AVAILABLE expoart THEN DO:
        IF cColumnName = "QCOL1"  THEN lCodArt = expoart.artcol01.
        IF cColumnName = "QCOL2"  THEN lCodArt = expoart.artcol02.
        IF cColumnName = "QCOL3"  THEN lCodArt = expoart.artcol03.
        IF cColumnName = "QCOL4"  THEN lCodArt = expoart.artcol04.
        IF cColumnName = "QCOL5"  THEN lCodArt = expoart.artcol05.
        IF cColumnName = "QCOL6"  THEN lCodArt = expoart.artcol06.

        IF (lCodArt <> "" AND lCodArt <> ?) THEN DO:
            lRetVal = lCodArt.
        END.
    END.

  RETURN lRetval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION uf-tecla-funcion W-Win 
FUNCTION uf-tecla-funcion RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR lRetVal AS LOG INIT NO.

lRetVal = NO.

IF LASTKEY = KEYCODE("TAB")  THEN lRetVal = YES.
IF LASTKEY = KEYCODE("ENTER")  THEN lRetVal = YES.
IF LASTKEY = KEYCODE("UP-ARROW")  THEN lRetVal = YES.
IF LASTKEY = KEYCODE("DOWN-ARROW")  THEN lRetVal = YES.

IF LASTKEY = KEYCODE("RIGHT")  THEN lRetVal = YES.
IF LASTKEY = KEYCODE("LEFT")  THEN lRetVal = YES.
IF LASTKEY = KEYCODE("PAGE–UP")  THEN lRetVal = YES.
IF LASTKEY = KEYCODE("PAGE–DOWN")  THEN lRetVal = YES.
IF LASTKEY = KEYCODE("BACK-TAB ")  THEN lRetVal = YES.

RETURN lRetVal.   /* Function return value. */

/*
UP, UP-ARROW
DOWN, DOWN-ARROW
RIGHT, RIGHT-ARROW
LEFT, LEFT-ARROW
*/

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

