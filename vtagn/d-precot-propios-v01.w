&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDI2 NO-UNDO LIKE VtaDDocu.
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

DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR s-nrocot AS CHAR.
DEFINE SHARED VAR s-CodCli LIKE gn-clie.codcli.
DEFINE SHARED VAR s-CodMon AS INT.
DEFINE SHARED VAR s-TpoCmb AS DEC.
DEFINE SHARED VAR s-CndVta AS CHAR.
DEFINE SHARED VAR s-codalm AS CHAR.
DEFINE SHARED VAR lh_handle AS HANDLE.
DEFINE SHARED VAR s-TpoPed AS CHAR.
DEFINE SHARED VAR pCodDiv  AS CHAR.
DEFINE SHARED VAR s-NroDec AS INT.
DEFINE SHARED VAR s-ControlPromotor AS LOG.     /* CONTROL DE PROMOTORES */

DEFINE SHARED VAR s-FlgEmpaque LIKE GN-DIVI.FlgEmpaque.
DEFINE SHARED VAR s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.
DEFINE SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.

DEFINE VARIABLE f-factor AS DECIMAL     INIT 1  NO-UNDO.
DEFINE VARIABLE s-undvta AS CHARACTER   NO-UNDO.

/* VARIABLES CONTROL DE PROMOTORES */
DEF VAR s-task-no AS INT.     /* Dato del Proveedor */
DEF VAR s-codpro AS CHAR INIT '51135890' NO-UNDO.   /* STANDFORD */
DEF SHARED VAR pv-codcia AS INT.

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
&Scoped-Define ENABLED-OBJECTS Btn_OK Btn_Cancel CboFamilia cboGrupo ~
BUTTON-8 BUTTON-10 BROWSE-4 
&Scoped-Define DISPLAYED-OBJECTS CboFamilia cboGrupo FILL-IN-Promotor ~
txtCol1 txtCol2 txtCol3 txtCol4 txtCol5 txtCol6 txtTotal 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fGetVtaMin D-Dialog 
FUNCTION fGetVtaMin RETURNS DECIMAL
  ( INPUT cColumna AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
     IMAGE-UP FILE "img/b-eliminar.bmp":U
     LABEL "Cancel" 
     SIZE 8 BY 1.73 TOOLTIP "Salir sin grabar"
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/save.ico":U
     LABEL "OK" 
     SIZE 9 BY 1.73 TOOLTIP "Grabar"
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-10 
     IMAGE-UP FILE "img/b-buscar.ico":U
     LABEL "Button 10" 
     SIZE 4 BY .96 TOOLTIP "Seleccionar el promotor".

DEFINE BUTTON BUTTON-8 
     LABEL "APLICAR FILTROS" 
     SIZE 17 BY 1.12.

DEFINE VARIABLE CboFamilia AS CHARACTER FORMAT "X(256)":U INITIAL "010" 
     LABEL "Familia" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Familia 10","010",
                     "Familia 11","011",
                     "Familia 12","012",
                     "Familia 13","013"
     DROP-DOWN-LIST
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cboGrupo AS CHARACTER FORMAT "X(256)":U INITIAL "000" 
     LABEL "Grupo" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "<Ninguno>","000"
     DROP-DOWN-LIST
     SIZE 57 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Promotor AS CHARACTER FORMAT "X(256)":U 
     LABEL "Promotor" 
     VIEW-AS FILL-IN 
     SIZE 56 BY .81 NO-UNDO.

DEFINE VARIABLE txtCol1 AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .85
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE txtCol2 AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .85
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE txtCol3 AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .85
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE txtCol4 AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .85
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE txtCol5 AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .85
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE txtCol6 AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .85
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE txtTotal AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .85
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
      ttExpoTmpo.Descripcion COLUMN-LABEL "A R T I C U L O" FORMAT "x(80)":U
            WIDTH 41.43
      ttExpoTmpo.Umed COLUMN-LABEL "U.M." FORMAT "x(25)":U WIDTH 11.43
            COLUMN-FONT 0
      ttExpoTmpo.UMCaja COLUMN-LABEL "CAJA" FORMAT "x(15)":U WIDTH 10.43
            COLUMN-FONT 0
      ttExpoTmpo.Qvtamin COLUMN-LABEL "VTA MIN" FORMAT "x(25)":U
            WIDTH 7.43 COLUMN-FONT 0
      ttExpoTmpo.QCol1 FORMAT ">>>,>>>,>>9.99":U WIDTH 14.43 LABEL-FGCOLOR 2 LABEL-BGCOLOR 15 LABEL-FONT 0
      ttExpoTmpo.QCol2 FORMAT ">>>,>>>,>>9.99":U WIDTH 14.43 LABEL-FONT 0
      ttExpoTmpo.QCol3 FORMAT ">>>,>>>,>>9.99":U WIDTH 14.43 LABEL-FONT 0
      ttExpoTmpo.QCol4 FORMAT ">>>,>>>,>>9.99":U WIDTH 14.43 LABEL-FONT 0
      ttExpoTmpo.QCol5 FORMAT ">>>,>>>,>>9.99":U WIDTH 14.43 LABEL-FONT 0
      ttExpoTmpo.QCol6 FORMAT ">>>,>>>,>>9.99":U WIDTH 14.43 LABEL-FONT 0
      Qcol1 + qCol2 + qCol3 + qCol4 + qCol5 + qCol6 @ ttQtot COLUMN-LABEL "TOTAL" FORMAT ">>>,>>>,>>9.99":U
            WIDTH 11.72
  ENABLE
      ttExpoTmpo.QCol1
      ttExpoTmpo.QCol2
      ttExpoTmpo.QCol3
      ttExpoTmpo.QCol4
      ttExpoTmpo.QCol5
      ttExpoTmpo.QCol6
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 178 BY 19.04
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     Btn_OK AT ROW 1.19 COL 140
     Btn_Cancel AT ROW 1.19 COL 149
     CboFamilia AT ROW 1.38 COL 6.86 COLON-ALIGNED WIDGET-ID 2
     cboGrupo AT ROW 1.42 COL 51.43 COLON-ALIGNED WIDGET-ID 4
     BUTTON-8 AT ROW 2.54 COL 2 WIDGET-ID 22
     BUTTON-10 AT ROW 2.54 COL 43 WIDGET-ID 40
     FILL-IN-Promotor AT ROW 2.54 COL 52 COLON-ALIGNED WIDGET-ID 38
     BROWSE-4 AT ROW 3.88 COL 2 WIDGET-ID 200
     txtCol1 AT ROW 23.23 COL 88.43 RIGHT-ALIGNED NO-LABEL WIDGET-ID 24
     txtCol2 AT ROW 23.23 COL 104.14 RIGHT-ALIGNED NO-LABEL WIDGET-ID 26
     txtCol3 AT ROW 23.23 COL 119 RIGHT-ALIGNED NO-LABEL WIDGET-ID 28
     txtCol4 AT ROW 23.23 COL 133.86 RIGHT-ALIGNED NO-LABEL WIDGET-ID 30
     txtCol5 AT ROW 23.23 COL 149 RIGHT-ALIGNED NO-LABEL WIDGET-ID 32
     txtCol6 AT ROW 23.23 COL 164.14 RIGHT-ALIGNED NO-LABEL WIDGET-ID 34
     txtTotal AT ROW 23.23 COL 178.86 RIGHT-ALIGNED NO-LABEL WIDGET-ID 36
     SPACE(0.70) SKIP(0.33)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Toma de Pedido"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: PEDI2 T "SHARED" NO-UNDO INTEGRAL VtaDDocu
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
/* BROWSE-TAB BROWSE-4 FILL-IN-Promotor D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Promotor IN FRAME D-Dialog
   NO-ENABLE                                                            */
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
"ttExpoTmpo.Descripcion" "A R T I C U L O" ? "character" ? ? ? ? ? ? no ? no no "41.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.ttExpoTmpo.Umed
"ttExpoTmpo.Umed" "U.M." ? "character" ? ? 0 ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.ttExpoTmpo.UMCaja
"ttExpoTmpo.UMCaja" "CAJA" ? "character" ? ? 0 ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ttExpoTmpo.Qvtamin
"ttExpoTmpo.Qvtamin" "VTA MIN" ? "character" ? ? 0 ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ttExpoTmpo.QCol1
"ttExpoTmpo.QCol1" ? ? "decimal" ? ? ? 15 2 0 yes ? no no "14.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ttExpoTmpo.QCol2
"ttExpoTmpo.QCol2" ? ? "decimal" ? ? ? ? ? 0 yes ? no no "14.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ttExpoTmpo.QCol3
"ttExpoTmpo.QCol3" ? ? "decimal" ? ? ? ? ? 0 yes ? no no "14.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ttExpoTmpo.QCol4
"ttExpoTmpo.QCol4" ? ? "decimal" ? ? ? ? ? 0 yes ? no no "14.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.ttExpoTmpo.QCol5
"ttExpoTmpo.QCol5" ? ? "decimal" ? ? ? ? ? 0 yes ? no no "14.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.ttExpoTmpo.QCol6
"ttExpoTmpo.QCol6" ? ? "decimal" ? ? ? ? ? 0 yes ? no no "14.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"Qcol1 + qCol2 + qCol3 + qCol4 + qCol5 + qCol6 @ ttQtot" "TOTAL" ">>>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no "11.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Toma de Pedido */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
    RUN Graba-Datos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-10 D-Dialog
ON CHOOSE OF BUTTON-10 IN FRAME D-Dialog /* Button 10 */
DO:
    ASSIGN
        input-var-1 = 'EXPOPROMOTOR'
        input-var-2 = s-CodDiv
        input-var-3 = s-CodPro.

    /*RUN lkup/c-promotor ('Seleccione el Promotor').*/
    RUN vtagn/c-promotor-v01 ('Seleccione el Promotor').

    IF output-var-1 <> ? THEN DO:
        FILL-IN-Promotor:SCREEN-VALUE = output-var-2.
        FIND w-report WHERE w-report.task-no = s-task-no
            AND w-report.Llave-C = s-CodPro
            AND w-report.Campo-C[10] = CboFamilia
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE w-report THEN DO:
            CREATE w-report.
            ASSIGN
                w-report.task-no = s-task-no
                w-report.Llave-C = s-CodPro
                w-report.Campo-C[10] = CboFamilia.
        END.
        ASSIGN
            output-var-3 = output-var-3 + '|' + CboFamilia  /* <<< OJO <<< */
            w-report.campo-c[2] = output-var-2    /* Nombre Promotor */
            w-report.campo-c[3] = output-var-3.   /* Proveedor|Promotor|Equipo|Familia */
        FIND CURRENT w-report NO-LOCK NO-ERROR.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
        /*lTextoAdd = IF (cboFamilia = '013') THEN "!         UM!         CAJA!        MIN.VTA" ELSE "".*/
        lTextoAdd = IF (expoGrpo.multititulo = YES) THEN "!         UM!         CAJA!        MIN.VTA" ELSE "".
        t_cual_celda = t_celda_br[1]. 
        t_cual_celda:LABEL = TRIM(expogrpo.desgrupo) + lTextoAdd.
        /**/
        lTextoAdd = IF (expoGrpo.multititulo = YES) THEN "!" ELSE "".
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
    /**/
    t_cual_celda = t_celda_br[2].     
    t_cual_celda:VISIBLE = IF (expoGrpo.multititulo = YES) THEN NO ELSE YES.
    t_cual_celda = t_celda_br[3]. 
    t_cual_celda:VISIBLE = IF (expoGrpo.multititulo = YES) THEN NO ELSE YES.
    t_cual_celda = t_celda_br[4]. 
    t_cual_celda:VISIBLE = IF (expoGrpo.multititulo = YES) THEN NO ELSE YES.

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
    /* Los Totales */
    txtCol1:X = {&BROWSE-NAME}:GET-BROWSE-COLUMN(5):X + 10.
    txtCol2:X = {&BROWSE-NAME}:GET-BROWSE-COLUMN(6):X + 10.
    txtCol3:X = {&BROWSE-NAME}:GET-BROWSE-COLUMN(7):X + 10.
    txtCol4:X = {&BROWSE-NAME}:GET-BROWSE-COLUMN(8):X + 10.
    txtCol5:X = {&BROWSE-NAME}:GET-BROWSE-COLUMN(9):X + 10.
    txtCol6:X = {&BROWSE-NAME}:GET-BROWSE-COLUMN(10):X + 10.

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
  FOR EACH expogrpo WHERE expogrpo.codcia = s-codcia AND 
      expogrpo.codfam = lCodFam NO-LOCK:
        cboGrupo:ADD-LAST(expogrpo.desgrupo + " (" + expogrpo.codgrupo + ")" , expogrpo.codgrupo).
      IF lSec = 1 THEN DO:
        cboGrupo:SCREEN-VALUE = expogrpo.codgrupo.
      END.
      lSec = lSec + 1.
  END.
  FILL-IN-Promotor:SCREEN-VALUE IN FRAME {&FRAME-NAME} =  ''.
  
  FIND w-report WHERE w-report.task-no = s-task-no
      AND w-report.Llave-C = s-codpro
      AND w-report.campo-c[10] = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE w-report 
      THEN FILL-IN-Promotor:SCREEN-VALUE IN FRAME {&FRAME-NAME} = w-report.campo-c[2].

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */
    DEF VAR t_col_br AS INT NO-UNDO INITIAL 11. 
    DEF VAR t_col_eti AS INT NO-UNDO INITIAL 0. /*2*/

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

        DEFINE VAR lQVtaMin AS DEC.

        DEFINE VAR lVtaMin AS DEC INIT 0.
        DEFINE VAR lCodArt AS CHAR INIT "".
        DEFINE VAR lRowId AS ROWID.

        ASSIGN hColumn = SELF:HANDLE.
        cColumnName = CAPS(hColumn:NAME).   
        lColumnDataNew = DECIMAL(SELF:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
        /*  */
        IF uf-celda-editable(INPUT cColumnName) = YES THEN DO:
            IF lColumnDataNew > 0 THEN DO:
                IF s-ControlPromotor = YES THEN DO:
                    /* RHC 03/01/2014 SI NO HA INGRESADO EL PROMOTOR NO DEJA PASAR */
                    /* RHC 14/09/2017 Bloqueado a pedido Carmen Ayala */
                    FIND FIRST w-report WHERE w-report.task-no = s-task-no
                        AND w-report.llave-c = s-codpro
                        AND w-report.campo-c[10] = CboFamilia
                        NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE w-report OR 
                        (AVAILABLE w-report AND w-report.Campo-C[3] = '') THEN DO:
                        MESSAGE "Debe ingresar el promotor" VIEW-AS ALERT-BOX ERROR.
                        SELF:SCREEN-VALUE IN BROWSE {&browse-name} = "0.00".
                        RETURN NO-APPLY.
                    END.
                END.
                /* CONTROL DE EMPAQUE Y MINIMO DE VENTA */
                DEF VAR f-Canped AS DEC NO-UNDO.
                DEF VAR f-Empaque AS DEC NO-UNDO.
                DEF VAR f-CanFinal AS DEC NO-UNDO.
                DEF VAR f-Sugerido AS DEC NO-UNDO.
                DEF VAR f-MinimoVentas AS DEC NO-UNDO.

                lCodArt = uf-get-codmat(INPUT cColumnName).
                FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia 
                    AND almmmatg.codmat = lCodArt 
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE almmmatg THEN DO:
                    MESSAGE "Articulo no existe...".
                    RETURN NO-APPLY.
                END.
                /* EMPAQUE */
                f-CanPed = lColumnDataNew * f-Factor.
                /* CONTROL DE EMPAQUE */
                IF s-FlgEmpaque = YES THEN DO:
                    DEF VAR pSugerido AS DEC NO-UNDO.
                    DEF VAR pEmpaque AS DEC NO-UNDO.
                    f-CanPed = lColumnDataNew * f-Factor.
                    RUN vtagn/p-cantidad-sugerida.p (s-TpoPed, Almmmatg.CodMat, f-CanPed, OUTPUT pSugerido, OUTPUT pEmpaque).
                    CASE s-TpoPed:
                        WHEN "E" THEN DO:     /* Caso EXPOLIBRERIAS */
                            f-CanPed = pSugerido / f-Factor.
                            SELF:SCREEN-VALUE IN BROWSE {&browse-name} = STRING(f-CanPed).
                        END.
                        OTHERWISE DO:         /* Todos los demás casos */
                            /* RHC solo se va a trabajar con una lista general */
                            IF pEmpaque > 0 THEN DO:
                                f-CanPed = TRUNCATE((f-CanPed / pEmpaque),0) * pEmpaque.
                                IF f-CanPed <> lColumnDataNew * f-Factor THEN DO:
                                    MESSAGE 'Solo puede vender en empaques de' pEmpaque Almmmatg.UndBas
                                        VIEW-AS ALERT-BOX ERROR.
                                    RETURN NO-APPLY.
                                END.
                            END.
                        END.
                    END CASE.
                END.
                /* MINIMO DE VENTA */
                /* NOTA: MINIMO DE VENTA y EMPAQUE NO se dan juntos, o es uno o el otro */
                lQVtaMin = fGetVtaMin(INPUT cColumnName).

                /* Ic - 02Ene2017, Validar el MIN.VTA con el catalogo */
                lQVtaMin = 0.

                f-CanPed = lColumnDataNew * f-Factor.
                IF lQVtaMin > 0 AND s-FlgMinVenta = YES  THEN DO:
                   f-CanPed = (TRUNCATE((f-CanPed / lQVtaMin),0) * lQVtaMin).
                    IF f-CanPed <> lColumnDataNew * f-Factor THEN DO:
                        MESSAGE 'Solo puede vender en multiplos de' lQVtaMin Almmmatg.UndBas
                            VIEW-AS ALERT-BOX ERROR.
                        RETURN NO-APPLY.
                    END.
                END.

                f-CanPed = lColumnDataNew * f-Factor.
                IF lQVtaMin <= 0 AND Almmmatg.StkMax > 0 AND s-FlgMinVenta = YES THEN DO:
                    f-CanPed = (TRUNCATE((f-CanPed / Almmmatg.StkMax),0) * Almmmatg.StkMax).
                    IF f-CanPed <> lColumnDataNew * f-Factor THEN DO:
                        MESSAGE 'Solo puede vender en multiplos de' Almmmatg.StkMax Almmmatg.UndBas
                            VIEW-AS ALERT-BOX ERROR.
                        RETURN NO-APPLY.
                    END.
                END.
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
        /*t_cual_celda:LABEL-FONT = IF (t_n_cols_browse < 5) THEN 12 ELSE 6. */
        t_cual_celda:LABEL-FGCOLOR = 2.

        /*t_cual_celda:COLUMN-FONT = IF (t_n_cols_browse < 5) THEN 2 ELSE 6.        */
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
  DISPLAY CboFamilia cboGrupo FILL-IN-Promotor txtCol1 txtCol2 txtCol3 txtCol4 
          txtCol5 txtCol6 txtTotal 
      WITH FRAME D-Dialog.
  ENABLE Btn_OK Btn_Cancel CboFamilia cboGrupo BUTTON-8 BUTTON-10 BROWSE-4 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Datos D-Dialog 
PROCEDURE Graba-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*Elimina otros datos*/
    DEF VAR x-NroItm AS INT INIT 0 NO-UNDO.

    FOR EACH PEDI2:
        x-NroItm = x-NroItm + 1.
    END.

    FOR EACH ttExpoTmpo, FIRST ExpoArt WHERE ExpoArt.CodCia = s-codcia
        AND ExpoArt.CodGrupo = ttExpoTmpo.CodGrupo
        AND ExpoArt.CodMtxArt = ttExpoTmpo.CodMtxArt NO-LOCK:
        /* Barremos las columnas */
        IF ttExpoTmpo.QCol1 > 0 
            THEN RUN Graba-Linea (ExpoArt.ArtCol01, ttExpoTmpo.QCol1, INPUT-OUTPUT x-NroItm).
        IF ttExpoTmpo.QCol2 > 0 
            THEN RUN Graba-Linea (ExpoArt.ArtCol02, ttExpoTmpo.QCol2, INPUT-OUTPUT x-NroItm).
        IF ttExpoTmpo.QCol3 > 0 
            THEN RUN Graba-Linea (ExpoArt.ArtCol03, ttExpoTmpo.QCol3, INPUT-OUTPUT x-NroItm).
        IF ttExpoTmpo.QCol4 > 0 
            THEN RUN Graba-Linea (ExpoArt.ArtCol04, ttExpoTmpo.QCol4, INPUT-OUTPUT x-NroItm).
        IF ttExpoTmpo.QCol5 > 0 
            THEN RUN Graba-Linea (ExpoArt.ArtCol05, ttExpoTmpo.QCol5, INPUT-OUTPUT x-NroItm).
        IF ttExpoTmpo.QCol6 > 0 
            THEN RUN Graba-Linea (ExpoArt.ArtCol06, ttExpoTmpo.QCol6, INPUT-OUTPUT x-NroItm).
    END.

END PROCEDURE.

PROCEDURE Graba-linea:

    DEF INPUT PARAMETER pCodMat AS CHAR.
    DEF INPUT PARAMETER pCanPed AS DEC.
    DEF INPUT-OUTPUT PARAMETER x-NroItm AS INT.

    /*MESSAGE pcodmat pcanped ExpoArt.CodGrupo ExpoArt.CodMtxArt.*/
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = pCodMat NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN RETURN.

    FIND FIRST PEDI2 WHERE PEDI2.codmat = pCodMat NO-ERROR.
    IF NOT AVAIL PEDI2 THEN DO:
        CREATE PEDI2.
        x-NroItm = x-NroItm + 1.
        ASSIGN
            PEDI2.Libre_c01 = '0001'
            PEDI2.Libre_c02 = '0001'
            /*PEDI2.Libre_c03 = s-CodPro*/
            PEDI2.NroItm = x-NroItm
            PEDI2.CodCia = s-codcia
            PEDI2.CodDiv = s-coddiv
            PEDI2.CodPed = "PET"
            PEDI2.NroPed = s-nrocot
            PEDI2.AlmDes = s-codalm.
    END.
    ASSIGN
        f-factor = 1
        PEDI2.CodMat = pCodMat
        PEDI2.Factor = f-factor
        PEDI2.UndVta = Almmmatg.Chr__01     /*s-UndVta*/
        PEDI2.CanPed = pCanPed
        PEDI2.Libre_d01 = pCanPed
        .
    FIND FIRST ExpoGrpo WHERE ExpoGrpo.CodCia = s-codcia
        AND ExpoGrpo.CodGrupo = ttExpoTmpo.Codgrupo
        NO-LOCK NO-ERROR.
    IF AVAILABLE ExpoGrpo THEN DO:
        /*MESSAGE 'uno' s-task-no s-codpro expogrpo.codfam.*/
    /*IF AVAILABLE ttExpoTmpo THEN DO:*/
        FIND w-report WHERE w-report.task-no = s-task-no
            AND w-report.Llave-C = s-codpro
            AND w-report.campo-c[10] = ExpoGrpo.CodFam
            NO-LOCK NO-ERROR.
        IF AVAILABLE w-report AND TRUE <> (PEDI2.Libre_c03 > '')      /* Solo si no tiene promotor asignado */
            THEN DO:
            PEDI2.Libre_c03 = w-report.campo-c[3].
        END.
    END.
    
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
  DEFINE VAR lCodFam AS CHAR INIT ''.

  DO WITH FRAME {&FRAME-NAME}.
      cboFamilia:DELIMITER = "|".
  END.
  
  cboFamilia:DELETE(cboFamilia:LIST-ITEM-PAIRS).

  lSec = 1.
  FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND
                            vtatabla.tabla = 'LINEAS-CATALOGO-PP' NO-LOCK:
      cboFamilia:ADD-LAST("Familia " + vtatabla.llave_c1, vtatabla.llave_c1).
      IF lSec = 1 THEN DO:
                cboFamilia:SCREEN-VALUE IN FRAME {&FRAME-NAME} = vtatabla.llave_c1.
            lCodFam = vtatabla.llave_c1.
      END.
      lSec = lSec + 1.
  END.

  lSec = 1.
  CboGrupo:DELETE(CboGrupo:LIST-ITEM-PAIRS) IN FRAME {&FRAME-NAME}.
  FOR EACH expogrpo WHERE expogrpo.codcia = s-codcia AND 
      expogrpo.codfam = lCodFam NO-LOCK:
/*       cboGrupo:ADD-LAST(expogrpo.desgrupo + " (" + expogrpo.codgrupo + ")" , expogrpo.codgrupo). */
      cboGrupo:ADD-LAST(expogrpo.desgrupo, expogrpo.codgrupo).
      IF lSec = 1 THEN DO:
          cboGrupo:SCREEN-VALUE = expogrpo.codgrupo.
      END.
      lSec = lSec + 1.
  END.

  EMPTY TEMP-TABLE ttExpoTmpo.
  FOR EACH expoArt WHERE ExpoArt.CodCia = s-codcia NO-LOCK,
      FIRST ExpoGrpo NO-LOCK WHERE ExpoGrpo.CodCia = ExpoArt.CodCia
      AND ExpoGrpo.CodGrupo = ExpoArt.CodGrupo:
      CREATE ttExpoTmpo.
      ASSIGN 
          ttExpoTmpo.Codgrupo = expoArt.Codgrupo
          ttExpoTmpo.CodMtxArt = expoart.codmtxart
          ttExpoTmpo.Descripcion = expoart.desmatxart
          ttExpoTmpo.umed = expoart.um
          ttExpoTmpo.umcaja = expoart.caja
          ttExpoTmpo.qvtamin = expoart.vtamin
          ttExpoTmpo.Codcia = s-codcia.
      /* Buscamos información ya grabada */
      FIND PEDI2 WHERE PEDI2.codmat = ExpoArt.ArtCol01 NO-ERROR.
      IF AVAILABLE PEDI2 THEN ttExpoTmpo.QCol1 = PEDI2.CanPed.
      FIND PEDI2 WHERE PEDI2.codmat = ExpoArt.ArtCol02 NO-ERROR.
      IF AVAILABLE PEDI2 THEN ttExpoTmpo.QCol2 = PEDI2.CanPed.
      FIND PEDI2 WHERE PEDI2.codmat = ExpoArt.ArtCol03 NO-ERROR.
      IF AVAILABLE PEDI2 THEN ttExpoTmpo.QCol3 = PEDI2.CanPed.
      FIND PEDI2 WHERE PEDI2.codmat = ExpoArt.ArtCol04 NO-ERROR.
      IF AVAILABLE PEDI2 THEN ttExpoTmpo.QCol4 = PEDI2.CanPed.
      FIND PEDI2 WHERE PEDI2.codmat = ExpoArt.ArtCol05 NO-ERROR.
      IF AVAILABLE PEDI2 THEN ttExpoTmpo.QCol5 = PEDI2.CanPed.
      FIND PEDI2 WHERE PEDI2.codmat = ExpoArt.ArtCol06 NO-ERROR.
      IF AVAILABLE PEDI2 THEN ttExpoTmpo.QCol6 = PEDI2.CanPed.
  END.

  /* Cargamos control de promotores del proveedor */
  s-task-no = 0.
  REPEAT:
      s-task-no = RANDOM(1,999999).
      IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK)
          THEN LEAVE.
  END.

  DEFINE BUFFER x-vtatabla FOR vtatabla.

  FOR EACH x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                            x-vtatabla.tabla = 'LINEAS-CATALOGO-PP' NO-LOCK:
    /*DO lSec = 1 TO 3:*/
      CREATE w-report.
      ASSIGN
          w-report.Task-No = s-task-no
          w-report.Llave-C = s-codpro.

      ASSIGN w-report.Campo-C[10] = x-vtatabla.llave_c1.
      /*
      IF lSec = 1 THEN w-report.Campo-C[10] = '010'.
      IF lSec = 2 THEN w-report.Campo-C[10] = '012'.
      IF lSec = 3 THEN w-report.Campo-C[10] = '013'.
      */
      FIND FIRST gn-prov WHERE gn-prov.codcia = pv-codcia
          AND gn-prov.codpro = s-codpro NO-LOCK NO-ERROR.
      IF AVAILABLE gn-prov THEN w-report.Campo-C[1] = gn-prov.nompro.
      /* Buscamos si hay algo digitado en la base */
        FOR EACH PEDI2 WHERE NUM-ENTRIES(PEDI2.Libre_C03,'|') >= 2:
            IF ENTRY(1,PEDI2.Libre_C03,'|') = gn-prov.codpro THEN DO:
                FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia
                    AND VtaTabla.Tabla = 'EXPOPROMOTOR'
                    AND VtaTabla.Llave_c1 = s-coddiv
                    AND VtaTabla.Llave_c2 = ENTRY(1,PEDI2.Libre_C03,'|')
                    AND VtaTabla.Llave_c3 = ENTRY(2,PEDI2.Libre_C03,'|')
                    NO-LOCK NO-ERROR.
                IF AVAILABLE VtaTabla 
                    THEN ASSIGN 
                    w-report.Campo-C[2] = VtaTabla.Libre_c01
                    w-report.Campo-C[3] = VtaTabla.Llave_c2 + '|' + VtaTabla.Llave_c3 + '|' + VtaTabla.Libre_c02 + '|' + w-report.Campo-C[10].
                LEAVE.
            END.
        END.
  END.

  FIND w-report WHERE w-report.task-no = s-task-no
      AND w-report.Llave-C = s-codpro
      AND w-report.campo-c[10] = lCodFam
      NO-LOCK NO-ERROR.
  IF AVAILABLE w-report 
      THEN FILL-IN-Promotor:SCREEN-VALUE IN FRAME {&FRAME-NAME} = w-report.campo-c[2].


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fGetVtaMin D-Dialog 
FUNCTION fGetVtaMin RETURNS DECIMAL
  ( INPUT cColumna AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VAR lRetVal AS DEC INIT 0.
  DEFINE VAR lColData AS CHAR INIT ''.

  /*ttExpoTmpo.CodMtxArt*/
  FIND FIRST ExpoGrpo WHERE ExpoGrpo.CodCia = s-codcia AND 
                            ExpoGrpo.CodGrupo = ttExpoTmpo.Codgrupo NO-LOCK NO-ERROR.
  IF ExpoGrpo.codfam = '013' THEN DO:
      IF cColumna = "QCOL1"  THEN lColData = expogrpo.col01.
      IF cColumna = "QCOL2"  THEN lColData = expogrpo.col02.
      IF cColumna = "QCOL3"  THEN lColData = expogrpo.col03.
      IF cColumna = "QCOL4"  THEN lColData = expogrpo.col04.
      IF cColumna = "QCOL5"  THEN lColData = expogrpo.col05.
      IF cColumna = "QCOL6"  THEN lColData = expogrpo.col06.

      IF lColData = ? THEN DO:
          lColData = "".
      END.
      lColData = TRIM(lColData).
      IF lColData <> "" THEN DO:
          lRetval = dec(trim(ENTRY(4,lColData,"!"))) NO-ERROR.
      END.
      
  END.
  ELSE DO:
      lRetVal = DEC(TRIM(ttExpoTmpo.QVtamin)) NO-ERROR.
  END.

  IF lRetVal < 0 THEN lRetVal = 1.

  RETURN lRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

