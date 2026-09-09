&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttExpoTmpo NO-UNDO LIKE ExpoTmpo
       FIELD ttQtot AS DECIMAL.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
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

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
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


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK CboFamilia cboGrupo Btn_Cancel ~
BUTTON-8 BROWSE-4 
&Scoped-Define DISPLAYED-OBJECTS CboFamilia cboGrupo txtCol1 txtCol2 ~
txtCol3 txtCol4 txtCol5 txtCol6 txtTotal 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartDialogCues" D-Dialog _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/* SmartDialog,ab,49267
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD uf-celda-editable D-Dialog 
FUNCTION uf-celda-editable RETURNS LOGICAL
  ( INPUT cColumna AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD uf-get-codmat D-Dialog 
FUNCTION uf-get-codmat RETURNS CHARACTER
  ( INPUT cColumna AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD uf-tecla-funcion D-Dialog 
FUNCTION uf-tecla-funcion RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-8 
     LABEL "APLICAR FILTROS" 
     SIZE 17 BY 1.12.

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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 D-Dialog _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      ttExpoTmpo.Descripcion COLUMN-LABEL "A RT I C U L O" FORMAT "x(80)":U
            WIDTH 41.43
      ttExpoTmpo.Umed COLUMN-LABEL "U.M." FORMAT "x(25)":U WIDTH 14.43
      ttExpoTmpo.UMCaja COLUMN-LABEL "CAJA" FORMAT "x(15)":U WIDTH 13.43
      ttExpoTmpo.Qvtamin COLUMN-LABEL "VTA MIN" FORMAT "x(25)":U
            WIDTH 7.43
      ttExpoTmpo.QCol1 FORMAT ">>>,>>>,>>9.99":U WIDTH 9.43
      ttExpoTmpo.QCol2 FORMAT ">>>,>>>,>>9.99":U WIDTH 10.43
      ttExpoTmpo.QCol3 FORMAT ">>>,>>>,>>9.99":U WIDTH 10.43
      ttExpoTmpo.QCol4 FORMAT ">>>,>>>,>>9.99":U WIDTH 10.43
      ttExpoTmpo.QCol5 FORMAT ">>>,>>>,>>9.99":U WIDTH 11.43
      ttExpoTmpo.QCol6 FORMAT ">>>,>>>,>>9.99":U WIDTH 9.43
      Qcol1 + qCol2 + qCol3 + qCol4 + qCol5 + qCol6 @ ttQtot COLUMN-LABEL "TOTAL" FORMAT ">>>,>>9.99":U
            WIDTH 10.72
  ENABLE
      ttExpoTmpo.QCol1
      ttExpoTmpo.QCol2
      ttExpoTmpo.QCol3
      ttExpoTmpo.QCol4
      ttExpoTmpo.QCol5
      ttExpoTmpo.QCol6
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 158 BY 19.04
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     Btn_OK AT ROW 1.19 COL 129
     CboFamilia AT ROW 1.38 COL 6.86 COLON-ALIGNED WIDGET-ID 2
     cboGrupo AT ROW 1.42 COL 51.43 COLON-ALIGNED WIDGET-ID 4
     Btn_Cancel AT ROW 2.42 COL 129
     BUTTON-8 AT ROW 2.54 COL 2 WIDGET-ID 22
     BROWSE-4 AT ROW 3.88 COL 2 WIDGET-ID 200
     txtCol1 AT ROW 23.23 COL 90.14 RIGHT-ALIGNED NO-LABEL WIDGET-ID 24
     txtCol2 AT ROW 23.23 COL 101.14 RIGHT-ALIGNED NO-LABEL WIDGET-ID 26
     txtCol3 AT ROW 23.23 COL 112.29 RIGHT-ALIGNED NO-LABEL WIDGET-ID 28
     txtCol4 AT ROW 23.23 COL 123.14 RIGHT-ALIGNED NO-LABEL WIDGET-ID 30
     txtCol5 AT ROW 23.23 COL 134.29 RIGHT-ALIGNED NO-LABEL WIDGET-ID 32
     txtCol6 AT ROW 23.23 COL 145.29 RIGHT-ALIGNED NO-LABEL WIDGET-ID 34
     txtTotal AT ROW 23.23 COL 159.01 RIGHT-ALIGNED NO-LABEL WIDGET-ID 36
     SPACE(1.70) SKIP(0.33)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "<insert SmartDialog title>"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttExpoTmpo T "?" NO-UNDO INTEGRAL ExpoTmpo
      ADDITIONAL-FIELDS:
          FIELD ttQtot AS DECIMAL
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-4 BUTTON-8 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN txtCol1 IN FRAME D-Dialog
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN txtCol2 IN FRAME D-Dialog
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN txtCol3 IN FRAME D-Dialog
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN txtCol4 IN FRAME D-Dialog
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN txtCol5 IN FRAME D-Dialog
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN txtCol6 IN FRAME D-Dialog
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN txtTotal IN FRAME D-Dialog
   NO-ENABLE ALIGN-R                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "Temp-Tables.ttExpoTmpo"
     _Options          = "NO-LOCK"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > Temp-Tables.ttExpoTmpo.Descripcion
"Descripcion" "A RT I C U L O" ? "character" ? ? ? ? ? ? no ? no no "41.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.ttExpoTmpo.Umed
"Umed" "U.M." ? "character" ? ? ? ? ? ? no ? no no "14.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.ttExpoTmpo.UMCaja
"UMCaja" "CAJA" ? "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ttExpoTmpo.Qvtamin
"Qvtamin" "VTA MIN" ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ttExpoTmpo.QCol1
"QCol1" ? ? "decimal" ? ? ? ? ? ? yes ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ttExpoTmpo.QCol2
"QCol2" ? ? "decimal" ? ? ? ? ? ? yes ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ttExpoTmpo.QCol3
"QCol3" ? ? "decimal" ? ? ? ? ? ? yes ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ttExpoTmpo.QCol4
"QCol4" ? ? "decimal" ? ? ? ? ? ? yes ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.ttExpoTmpo.QCol5
"QCol5" ? ? "decimal" ? ? ? ? ? ? yes ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.ttExpoTmpo.QCol6
"QCol6" ? ? "decimal" ? ? ? ? ? ? yes ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"Qcol1 + qCol2 + qCol3 + qCol4 + qCol5 + qCol6 @ ttQtot" "TOTAL" ">>>,>>9.99" ? ? ? ? ? ? ? no ? no no "10.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* <insert SmartDialog title> */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 D-Dialog
ON CHOOSE OF BUTTON-8 IN FRAME D-Dialog /* APLICAR FILTROS */
DO:
    ASSIGN cboGrupo.

    DEF VAR t_col_br AS INT NO-UNDO INITIAL 11. 
    DEF VAR t_col_eti AS INT NO-UNDO INITIAL 2. 

    DEF VAR t_celda_br AS WIDGET-HANDLE EXTENT 15 NO-UNDO. 
    DEF VAR t_cual_celda AS WIDGET-HANDLE NO-UNDO. 
    DEF VAR t_n_cols_browse AS INT NO-UNDO. 
    DEF VAR t_col_act AS INT NO-UNDO. 

    DEFINE VAR lTextoAdd AS CHAR INIT "".

    DO t_n_cols_browse = 1 TO {&BROWSE-NAME}:NUM-COLUMNS. 
        t_celda_br[t_n_cols_browse] = {&BROWSE-NAME}:GET-BROWSE-COLUMN(t_n_cols_browse). 
    END.
    /* Reset LABEL Header */
    DO t_n_cols_browse = 1 TO {&BROWSE-NAME}:NUM-COLUMNS. 
        t_cual_celda = t_celda_br[t_n_cols_browse]. 
        t_cual_celda:LABEL = " ".    
        /* No al TOTAL */
        IF t_n_cols_browse = ({&BROWSE-NAME}:NUM-COLUMNS - 1 ) THEN LEAVE. 
    END.

    t_cual_celda = t_celda_br[2]. 
    t_cual_celda:LABEL = "U.M.".
    t_cual_celda = t_celda_br[3]. 
    t_cual_celda:LABEL = "CAJA".
    t_cual_celda = t_celda_br[4]. 
    t_cual_celda:LABEL = "VTA.MIN.".

    FIND FIRST expoGrpo WHERE expogrpo.codcia = s-codcia AND expogrpo.codgrupo = cboGrupo
        NO-LOCK NO-ERROR.
    IF AVAILABLE expogrpo THEN DO:
        /**/
        lTextoAdd = IF (cboFamilia = '013') THEN "!         UM!         CAJA!        MIN.VTA" ELSE "".
        t_cual_celda = t_celda_br[1]. 
        t_cual_celda:LABEL = TRIM(expogrpo.desgrupo) + lTextoAdd.
        /**/
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

    ASSIGN 
        cboFamilia.
    t_cual_celda = t_celda_br[2]. 
    t_cual_celda:VISIBLE = IF (cboFamilia = '013') THEN NO ELSE YES.
    t_cual_celda = t_celda_br[3]. 
    t_cual_celda:VISIBLE = IF (cboFamilia = '013') THEN NO ELSE YES.
    t_cual_celda = t_celda_br[4]. 
    t_cual_celda:VISIBLE = IF (cboFamilia = '013') THEN NO ELSE YES.

    ASSIGN 
        cboGrupo.  
    pCodGrupo = cboGrupo.

    {&OPEN-QUERY-{&BROWSE-NAME}}

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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CboFamilia D-Dialog
ON VALUE-CHANGED OF CboFamilia IN FRAME D-Dialog /* Familia */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */


    DEF VAR t_col_br AS INT NO-UNDO INITIAL 11. 
    DEF VAR t_col_eti AS INT NO-UNDO INITIAL 2. 

    DEF VAR t_celda_br AS WIDGET-HANDLE EXTENT 15 NO-UNDO. 
    DEF VAR t_cual_celda AS WIDGET-HANDLE NO-UNDO. 
    DEF VAR t_n_cols_browse AS INT NO-UNDO. 
    DEF VAR t_col_act AS INT NO-UNDO. 

    ON ROW-DISPLAY OF {&BROWSE-NAME} 
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
            IF (expoart.artcol01 = "" OR expoart.artcol01 = ?) THEN t_cual_celda:FGCOLOR = 7.
            ELSE t_cual_celda:FGCOLOR = IF (ttExpoTmpo.QCOL1 = 0) THEN 15 ELSE ?.
            t_cual_celda = t_celda_br[6]. 
            t_cual_celda:BGCOLOR = IF (expoart.artcol02 = "" OR expoart.artcol02 = ?)  THEN 7 ELSE 15.
            IF (expoart.artcol02 = "" OR expoart.artcol02 = ?) THEN t_cual_celda:FGCOLOR = 7.
            ELSE t_cual_celda:FGCOLOR = IF (ttExpoTmpo.QCOL2 = 0) THEN 15 ELSE ?.
            t_cual_celda = t_celda_br[7]. 
            t_cual_celda:BGCOLOR = IF (expoart.artcol03 = "" OR expoart.artcol03 = ?)  THEN 7 ELSE 15.
            IF (expoart.artcol03 = "" OR expoart.artcol03 = ?) THEN t_cual_celda:FGCOLOR = 7.
            ELSE t_cual_celda:FGCOLOR = IF (ttExpoTmpo.QCOL3 = 0) THEN 15 ELSE ?.
            t_cual_celda = t_celda_br[8]. 
            t_cual_celda:BGCOLOR = IF (expoart.artcol04 = "" OR expoart.artcol04 = ?)  THEN 7 ELSE 15.
            IF (expoart.artcol04 = "" OR expoart.artcol04 = ?) THEN t_cual_celda:FGCOLOR = 7.
            ELSE t_cual_celda:FGCOLOR = IF (ttExpoTmpo.QCOL4 = 0) THEN 15 ELSE ?.
            t_cual_celda = t_celda_br[9]. 
            t_cual_celda:BGCOLOR = IF (expoart.artcol05 = "" OR expoart.artcol05 = ?)  THEN 7 ELSE 15.
            IF (expoart.artcol05 = "" OR expoart.artcol05 = ?) THEN t_cual_celda:FGCOLOR = 7.
            ELSE t_cual_celda:FGCOLOR = IF (ttExpoTmpo.QCOL5 = 0) THEN 15 ELSE ?.
            t_cual_celda = t_celda_br[10]. 
            t_cual_celda:BGCOLOR = IF (expoart.artcol06 = "" OR expoart.artcol06 = ?)  THEN 7 ELSE 15.
            IF (expoart.artcol06 = "" OR expoart.artcol06 = ?) THEN t_cual_celda:FGCOLOR = 7.
            ELSE t_cual_celda:FGCOLOR = IF (ttExpoTmpo.QCOL6 = 0) THEN 15 ELSE ?.
        END.
    END. 

    ON ANY-KEY OF QCol1, QCol2, QCol3, QCol4, QCol5, QCol6 IN BROWSE {&BROWSE-NAME}
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

    ON LEAVE OF QCol1, QCol2, QCol3, QCol4, QCol5, QCol6 IN BROWSE {&BROWSE-NAME} 
    DO:
        DEFINE VAR lTot AS DEC.
        DEFINE VAR hColumn AS HANDLE      NO-UNDO.
        DEFINE VAR cColumnName AS CHAR.
        DEFINE VAR lColumnDataNew AS DEC INIT 0.

        DEFINE VAR lVtaMin AS DEC INIT 0.
        DEFINE VAR lCodArt AS CHAR INIT "".
        DEFINE VAR lRowId AS ROWID.

        ASSIGN hColumn = SELF:HANDLE.
        cColumnName = CAPS(hColumn:NAME).   
        lColumnDataNew = DECIMAL(SELF:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
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
            IF cColumnName = "QCOL1"  THEN txtCol1 = txtCol1 - pColumnDataOld + lColumnDataNew.
            IF cColumnName = "QCOL2"  THEN txtCol2 = txtCol2 - pColumnDataOld + lColumnDataNew.
            IF cColumnName = "QCOL3"  THEN txtCol3 = txtCol3 - pColumnDataOld + lColumnDataNew.
            IF cColumnName = "QCOL4"  THEN txtCol4 = txtCol4 - pColumnDataOld + lColumnDataNew.
            IF cColumnName = "QCOL5"  THEN txtCol5 = txtCol5 - pColumnDataOld + lColumnDataNew.
            IF cColumnName = "QCOL6"  THEN txtCol6 = txtCol6 - pColumnDataOld + lColumnDataNew.

            txtTotal = txtCol1 + txtCol2 + txtCol3 + txtCol4 + txtCol5 + txtCol6.
            DISPLAY txtCol1 txtCol2 txtCol3 txtCol4 txtCol5 txtCol6 txtTotal WITH FRAME {&FRAME-NAME}.
        END.
        lTot = DECIMAL(ttExpoTmpo.QCol1:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) + 
            DECIMAL(ttExpoTmpo.QCol2:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) + 
            DECIMAL(ttExpoTmpo.QCol3:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) +
            DECIMAL(ttExpoTmpo.QCol4:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) +
            DECIMAL(ttExpoTmpo.QCol5:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) +
            DECIMAL(ttExpoTmpo.QCol6:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).

        ttExpoTmpo.ttQtot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(lTot,">>>,>>9.99").

        /* Color de la CELDA que se esta saliendo */
        RUN ue-celda-color(INPUT hColumn, "LEAVE").

    END.

    ON ENTRY OF QCol1, QCol2, QCol3, QCol4, QCol5, QCol6 IN BROWSE {&BROWSE-NAME}
    DO:
        /**/
        DEFINE VARIABLE hColumn AS HANDLE      NO-UNDO.
        DEFINE VAR cColumnName AS CHAR.

        ASSIGN hColumn = SELF:HANDLE.
        cColumnName = CAPS(hColumn:NAME).     

        /* Si no es EDITABLE salir */
        IF uf-celda-editable(INPUT cColumnName) = NO THEN DO:        
            RETURN NO-APPLY.
        END.
        pColumnDataOld = DECIMAL(SELF:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
        RUN ue-celda-color(INPUT hColumn, "ENTRY").
    END.

    DO t_n_cols_browse = 1 TO {&BROWSE-NAME}:NUM-COLUMNS. 
        t_celda_br[t_n_cols_browse] = {&BROWSE-NAME}:GET-BROWSE-COLUMN(t_n_cols_browse). 
        t_cual_celda = t_celda_br[t_n_cols_browse]. 
        t_cual_celda:LABEL-BGCOLOR = t_col_eti. 
        t_cual_celda:LABEL-FONT = IF (t_n_cols_browse < 5) THEN 12 ELSE 6. 
        t_cual_celda:COLUMN-FONT = IF (t_n_cols_browse < 5) THEN 2 ELSE 6.
        t_cual_celda:LABEL-FGCOLOR = 15. 
    END. 

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



    {src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
      WITH FRAME D-Dialog.
  ENABLE Btn_OK CboFamilia cboGrupo Btn_Cancel BUTTON-8 BROWSE-4 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
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

  EMPTY TEMP-TABLE ttExpoTmpo.
  FOR EACH expoArt WHERE ExpoArt.CodCia = s-codcia NO-LOCK:
      CREATE ttExpoTmpo.
      ASSIGN 
          ttExpoTmpo.Codgrupo = expoArt.Codgrupo
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros D-Dialog 
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
        WHEN "" THEN ASSIGN input-var-1 = "".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-celda-color D-Dialog 
PROCEDURE ue-celda-color :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION uf-celda-editable D-Dialog 
FUNCTION uf-celda-editable RETURNS LOGICAL
  ( INPUT cColumna AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR lCodGrupo AS CHAR.
    DEFINE VAR lCodMtxArt AS CHAR.
    DEFINE VAR lCodArt AS CHAR INIT "".
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
            RETURN YES.
        END.
    END.
    RETURN NO.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION uf-get-codmat D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION uf-tecla-funcion D-Dialog 
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

