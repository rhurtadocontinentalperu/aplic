&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-w-report NO-UNDO LIKE w-report.



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
DEFINE TEMP-TABLE tt-w-report LIKE w-report.

DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-w-report.

/* Local Variable Definitions ---                                       */
DEFINE VAR x-tabla AS CHAR INIT "PROD.PREM.STAND".
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.

DEFINE VAR x-fill-combo AS LOG INIT YES.
DEFINE VAR x-old-data AS CHAR.
DEFINE VAR x-old-premium AS CHAR.

DEFINE BUFFER x-vtatabla FOR vtatabla.
DEFINE BUFFER x-t-w-report FOR t-w-report.

DEFINE VAR x-sugeridos-completo AS LOG INIT NO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES t-w-report

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 t-w-report.Campo-C[2] ~
t-w-report.Campo-C[10] t-w-report.Campo-C[1] t-w-report.Campo-F[1] ~
t-w-report.Campo-C[3] t-w-report.Campo-C[4] t-w-report.Campo-C[5] ~
t-w-report.Campo-C[6] t-w-report.Campo-C[7] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 t-w-report.Campo-C[2] ~
t-w-report.Campo-C[10] t-w-report.Campo-C[1] t-w-report.Campo-F[1] ~
t-w-report.Campo-C[3] t-w-report.Campo-C[4] t-w-report.Campo-C[5] 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-3 t-w-report
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-3 t-w-report
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH t-w-report ~
      WHERE t-w-report.Campo-C[8] = "" NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH t-w-report ~
      WHERE t-w-report.Campo-C[8] = "" NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 t-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 t-w-report


/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 t-w-report.Campo-C[2] ~
t-w-report.Campo-C[10] t-w-report.Campo-C[1] t-w-report.Campo-F[1] ~
t-w-report.Campo-C[3] t-w-report.Campo-C[4] t-w-report.Campo-C[5] ~
t-w-report.Campo-C[6] t-w-report.Campo-C[7] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 t-w-report.Campo-C[1] ~
t-w-report.Campo-C[3] 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-4 t-w-report
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-4 t-w-report
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH t-w-report ~
      WHERE t-w-report.Campo-C[8] = "SUGERIDO" NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH t-w-report ~
      WHERE t-w-report.Campo-C[8] = "SUGERIDO" NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 t-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 t-w-report


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-3}~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-3 BROWSE-4 BUTTON-3 Btn_Cancel Btn_OK ~
BUTTON-sugeridos 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-txt 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel 
     LABEL "Cancel" 
     SIZE 11 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     LABEL "OK" 
     SIZE 10 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-3 
     LABEL "..." 
     SIZE 4.57 BY .96
     FONT 11.

DEFINE BUTTON BUTTON-sugeridos 
     LABEL "Buscar sugeridos faltantes" 
     SIZE 22 BY 1.

DEFINE VARIABLE FILL-IN-txt AS CHARACTER FORMAT "X(256)":U 
     LABEL "Ruta del TXT" 
      VIEW-AS TEXT 
     SIZE 64 BY .96
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      t-w-report SCROLLING.

DEFINE QUERY BROWSE-4 FOR 
      t-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 D-Dialog _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      t-w-report.Campo-C[2] COLUMN-LABEL "Articulo del Cliente" FORMAT "X(60)":U
            WIDTH 45.72 LABEL-FGCOLOR 9 LABEL-FONT 6
      t-w-report.Campo-C[10] COLUMN-LABEL "MARCA" FORMAT "X(40)":U
            WIDTH 21.43 LABEL-FGCOLOR 9 LABEL-FONT 6 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEMS "NINGUNO" 
                      DROP-DOWN-LIST  MAX-CHARS 20
      t-w-report.Campo-C[1] COLUMN-LABEL "Articulo!Premiun!  (F8)" FORMAT "X(8)":U
            WIDTH 7.14 COLUMN-BGCOLOR 11 COLUMN-FONT 6 LABEL-FGCOLOR 9 LABEL-FONT 6
      t-w-report.Campo-F[1] COLUMN-LABEL "Cantidad" FORMAT "->>,>>9.99":U
            WIDTH 7.43 LABEL-FGCOLOR 9 LABEL-FONT 6
      t-w-report.Campo-C[3] COLUMN-LABEL "Articulo!Standard" FORMAT "X(8)":U
            WIDTH 7.86 COLUMN-BGCOLOR 6 COLUMN-FONT 6 LABEL-FGCOLOR 9 LABEL-FONT 6
      t-w-report.Campo-C[4] COLUMN-LABEL "Articulo Premiun Descripcion" FORMAT "X(60)":U
            WIDTH 30.43 LABEL-FGCOLOR 9 LABEL-FONT 6
      t-w-report.Campo-C[5] COLUMN-LABEL "Articulo Premiun Marca" FORMAT "X(30)":U
            WIDTH 22.43 LABEL-FGCOLOR 9 LABEL-FONT 6
      t-w-report.Campo-C[6] COLUMN-LABEL "Articulo Standard Descripcion" FORMAT "X(60)":U
            WIDTH 32.43 LABEL-FGCOLOR 9 LABEL-FONT 6
      t-w-report.Campo-C[7] COLUMN-LABEL "Articulo Standard Marca" FORMAT "X(30)":U
            WIDTH 23.72 LABEL-FGCOLOR 9 LABEL-FONT 6
  ENABLE
      t-w-report.Campo-C[2]
      t-w-report.Campo-C[10]
      t-w-report.Campo-C[1]
      t-w-report.Campo-F[1]
      t-w-report.Campo-C[3]
      t-w-report.Campo-C[4]
      t-w-report.Campo-C[5]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 144 BY 10.12
         FONT 3 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 D-Dialog _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      t-w-report.Campo-C[2] COLUMN-LABEL "" FORMAT "X(60)":U WIDTH 45.72
            LABEL-FGCOLOR 9 LABEL-FONT 6
      t-w-report.Campo-C[10] COLUMN-LABEL "MARCA" FORMAT "X(40)":U
            WIDTH 21.43 LABEL-FGCOLOR 9 LABEL-FONT 6 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEMS "NINGUNO" 
                      DROP-DOWN-LIST  MAX-CHARS 20
      t-w-report.Campo-C[1] COLUMN-LABEL "Articulo!Premiun" FORMAT "X(8)":U
            WIDTH 7.14 LABEL-FGCOLOR 9 LABEL-FONT 6
      t-w-report.Campo-F[1] COLUMN-LABEL "Cantidad" FORMAT "->>,>>9.99":U
            WIDTH 7.43 LABEL-FGCOLOR 9 LABEL-FONT 6
      t-w-report.Campo-C[3] COLUMN-LABEL "Articulo!Standard" FORMAT "X(8)":U
            WIDTH 7.86 LABEL-FGCOLOR 9 LABEL-FONT 6
      t-w-report.Campo-C[4] COLUMN-LABEL "Articulo Premiun Descripcion" FORMAT "X(60)":U
            WIDTH 30.43 LABEL-FGCOLOR 9 LABEL-FONT 6
      t-w-report.Campo-C[5] COLUMN-LABEL "Articulo Premiun Marca" FORMAT "X(30)":U
            WIDTH 22.43 LABEL-FGCOLOR 9 LABEL-FONT 6
      t-w-report.Campo-C[6] COLUMN-LABEL "Articulo Standard Descripcion" FORMAT "X(60)":U
            WIDTH 32.43 LABEL-FGCOLOR 9 LABEL-FONT 6
      t-w-report.Campo-C[7] COLUMN-LABEL "Articulo Standard Marca" FORMAT "X(30)":U
            WIDTH 23.72 LABEL-FGCOLOR 9 LABEL-FONT 6
  ENABLE
      t-w-report.Campo-C[1]
      t-w-report.Campo-C[3]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 144 BY 9.15
         FONT 3
         TITLE "Articulos SUGERIDOS" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BROWSE-3 AT ROW 1.08 COL 1.57 WIDGET-ID 200
     BROWSE-4 AT ROW 11.27 COL 1.43 WIDGET-ID 300
     BUTTON-3 AT ROW 20.65 COL 81.43 WIDGET-ID 4
     Btn_Help AT ROW 1 COL 102
     Btn_Cancel AT ROW 20.58 COL 113
     Btn_OK AT ROW 20.58 COL 126
     BUTTON-sugeridos AT ROW 20.62 COL 89 WIDGET-ID 6
     FILL-IN-txt AT ROW 20.69 COL 15 COLON-ALIGNED WIDGET-ID 2
     SPACE(65.85) SKIP(0.19)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "TXT de LISTAEXPRESS" WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: t-w-report T "?" NO-UNDO INTEGRAL w-report
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-3 1 D-Dialog */
/* BROWSE-TAB BROWSE-4 BROWSE-3 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

ASSIGN 
       t-w-report.Campo-C[2]:COLUMN-READ-ONLY IN BROWSE BROWSE-3 = TRUE
       t-w-report.Campo-C[4]:COLUMN-READ-ONLY IN BROWSE BROWSE-3 = TRUE
       t-w-report.Campo-C[5]:COLUMN-READ-ONLY IN BROWSE BROWSE-3 = TRUE.

/* SETTINGS FOR BUTTON Btn_Help IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       Btn_Help:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-txt IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.t-w-report"
     _Options          = "NO-LOCK"
     _Where[1]         = "t-w-report.Campo-C[8] = """""
     _FldNameList[1]   > Temp-Tables.t-w-report.Campo-C[2]
"t-w-report.Campo-C[2]" "Articulo del Cliente" "X(60)" "character" ? ? ? ? 9 6 yes ? no no "45.72" yes no yes "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.t-w-report.Campo-C[10]
"t-w-report.Campo-C[10]" "MARCA" "X(40)" "character" ? ? ? ? 9 6 yes ? no no "21.43" yes no no "U" "" "" "DROP-DOWN-LIST" "," "NINGUNO" ? 5 no 20 no no
     _FldNameList[3]   > Temp-Tables.t-w-report.Campo-C[1]
"t-w-report.Campo-C[1]" "Articulo!Premiun!  (F8)" ? "character" 11 ? 6 ? 9 6 yes ? no no "7.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.t-w-report.Campo-F[1]
"t-w-report.Campo-F[1]" "Cantidad" "->>,>>9.99" "decimal" ? ? ? ? 9 6 yes ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.t-w-report.Campo-C[3]
"t-w-report.Campo-C[3]" "Articulo!Standard" ? "character" 6 ? 6 ? 9 6 yes ? no no "7.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.t-w-report.Campo-C[4]
"t-w-report.Campo-C[4]" "Articulo Premiun Descripcion" "X(60)" "character" ? ? ? ? 9 6 yes ? no no "30.43" yes no yes "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.t-w-report.Campo-C[5]
"t-w-report.Campo-C[5]" "Articulo Premiun Marca" "X(30)" "character" ? ? ? ? 9 6 yes ? no no "22.43" yes no yes "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.t-w-report.Campo-C[6]
"t-w-report.Campo-C[6]" "Articulo Standard Descripcion" "X(60)" "character" ? ? ? ? 9 6 no ? no no "32.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.t-w-report.Campo-C[7]
"t-w-report.Campo-C[7]" "Articulo Standard Marca" "X(30)" "character" ? ? ? ? 9 6 no ? no no "23.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "Temp-Tables.t-w-report"
     _Options          = "NO-LOCK"
     _Where[1]         = "t-w-report.Campo-C[8] = ""SUGERIDO"""
     _FldNameList[1]   > Temp-Tables.t-w-report.Campo-C[2]
"t-w-report.Campo-C[2]" "" "X(60)" "character" ? ? ? ? 9 6 no ? no no "45.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.t-w-report.Campo-C[10]
"t-w-report.Campo-C[10]" "MARCA" "X(40)" "character" ? ? ? ? 9 6 no ? no no "21.43" yes no no "U" "" "" "DROP-DOWN-LIST" "," "NINGUNO" ? 5 no 20 no no
     _FldNameList[3]   > Temp-Tables.t-w-report.Campo-C[1]
"t-w-report.Campo-C[1]" "Articulo!Premiun" ? "character" ? ? ? ? 9 6 yes ? no no "7.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.t-w-report.Campo-F[1]
"t-w-report.Campo-F[1]" "Cantidad" "->>,>>9.99" "decimal" ? ? ? ? 9 6 no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.t-w-report.Campo-C[3]
"t-w-report.Campo-C[3]" "Articulo!Standard" ? "character" ? ? ? ? 9 6 yes ? no no "7.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.t-w-report.Campo-C[4]
"t-w-report.Campo-C[4]" "Articulo Premiun Descripcion" "X(60)" "character" ? ? ? ? 9 6 no ? no no "30.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.t-w-report.Campo-C[5]
"t-w-report.Campo-C[5]" "Articulo Premiun Marca" "X(30)" "character" ? ? ? ? 9 6 no ? no no "22.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.t-w-report.Campo-C[6]
"t-w-report.Campo-C[6]" "Articulo Standard Descripcion" "X(60)" "character" ? ? ? ? 9 6 no ? no no "32.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.t-w-report.Campo-C[7]
"t-w-report.Campo-C[7]" "Articulo Standard Marca" "X(30)" "character" ? ? ? ? 9 6 no ? no no "23.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* TXT de LISTAEXPRESS */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&Scoped-define SELF-NAME BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-3 D-Dialog
ON ROW-DISPLAY OF BROWSE-3 IN FRAME D-Dialog
DO:
  /*MESSAGE "Rowdisplay".*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-3 D-Dialog
ON VALUE-CHANGED OF BROWSE-3 IN FRAME D-Dialog
DO:
    DEFINE VAR x-sugerido AS CHAR.

    DO WITH FRAME {&FRAME-NAME}:
        x-sugerido = t-w-report.campo-c[8].
    END.
    /*
    {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-c[3]:READ-ONLY IN BROWSE {&BROWSE-NAME}= NO.
    IF x-sugerido = "SUGERIDO" THEN DO:
        {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-c[3]:READ-ONLY IN BROWSE {&BROWSE-NAME}= YES.
    END.
    */
    {&FIRST-TABLE-IN-QUERY-BROWSE-3}.campo-c[3]:READ-ONLY IN BROWSE BROWSE-3= NO.
    IF x-sugerido = "SUGERIDO" THEN DO:
        {&FIRST-TABLE-IN-QUERY-BROWSE-3}.campo-c[3]:READ-ONLY IN BROWSE BROWSE-3= YES.
    END.

    /*{&OPEN-QUERY-BROWSE-4}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME t-w-report.Campo-C[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL t-w-report.Campo-C[10] BROWSE-3 _BROWSE-COLUMN D-Dialog
ON LEAVE OF t-w-report.Campo-C[10] IN BROWSE BROWSE-3 /* MARCA */
DO:

  DEFINE VAR x-new-data AS CHAR.

  x-new-data = SELF:SCREEN-VALUE.

  
      IF x-old-data <> x-new-data THEN DO:
            ASSIGN t-w-report.campo-c[3]:SCREEN-VALUE IN BROWSE BROWSE-3 = ""
                    t-w-report.campo-c[4]:SCREEN-VALUE IN BROWSE BROWSE-3 = ""
                    t-w-report.campo-c[5]:SCREEN-VALUE IN BROWSE BROWSE-3 = ""
                    t-w-report.campo-c[6]:SCREEN-VALUE IN BROWSE BROWSE-3 = ""
                    t-w-report.campo-c[7]:SCREEN-VALUE IN BROWSE BROWSE-3 = ""
                    t-w-report.campo-c[1]:SCREEN-VALUE IN BROWSE BROWSE-3 = "".
      END.
     
      {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-c[3]:READ-ONLY IN BROWSE {&BROWSE-NAME}= YES.
        IF NOT TRUE <> (x-new-data > "") THEN DO:
                {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-c[3]:READ-ONLY IN BROWSE {&BROWSE-NAME}= NO.
        END.

 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME t-w-report.Campo-C[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL t-w-report.Campo-C[1] BROWSE-3 _BROWSE-COLUMN D-Dialog
ON ENTRY OF t-w-report.Campo-C[1] IN BROWSE BROWSE-3 /* Articulo!Premiun!  (F8) */
DO:
    DEFINE VAR x-premium AS CHAR.
    DEFINE VAR x-es-sugerido AS CHAR.

    x-es-sugerido = t-w-report.campo-c[8].
    x-premium = t-w-report.campo-c[1]:SCREEN-VALUE IN BROWSE BROWSE-3.

    IF x-es-sugerido = 'SUGERIDO' THEN DO:
      /*IF NOT TRUE <> (x-sugerido > "") THEN DO:*/
          RETURN NO-APPLY.
      /*END.*/
    END.
    x-old-premium = x-premium.  /*SELF:SCREEN-VALUE.*/

    /*
    MESSAGE "x-sugerido " x-sugerido SKIP
            "SELF:SCREEN-VALUE " SELF:SCREEN-VALUE.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL t-w-report.Campo-C[1] BROWSE-3 _BROWSE-COLUMN D-Dialog
ON F8 OF t-w-report.Campo-C[1] IN BROWSE BROWSE-3 /* Articulo!Premiun!  (F8) */
DO:
      DEFINE VAR pTipoLista AS CHAR NO-UNDO.
      DEFINE VAR pCodProdPremium AS CHAR NO-UNDO.
      DEFINE VAR pNomProdPremium AS CHAR NO-UNDO.
      DEFINE VAR pCodProdStandard AS CHAR NO-UNDO.
      DEFINE VAR pNomProdStandard AS CHAR NO-UNDO.
      DEFINE VAR pCantidad AS DEC NO-UNDO.


    RUN vta2/d-productos-listaexpres.r(INPUT pTipoLista, 
                                     OUTPUT pCodProdPremium,
                                     OUTPUT pNomProdPremium,
                                     OUTPUT pCodProdStandard,
                                     OUTPUT pNomProdStandard,
                                     OUTPUT pCantidad).

    IF pCantidad <> -99 THEN DO:
        ASSIGN t-w-report.campo-c[1]:SCREEN-VALUE IN BROWSE BROWSE-3 = pCodProdPremium
                t-w-report.campo-f[1]:SCREEN-VALUE IN BROWSE BROWSE-3 = STRING(pCantidad)
                t-w-report.campo-c[3]:SCREEN-VALUE IN BROWSE BROWSE-3 = pCodProdStandard.

        APPLY 'RETURN':U TO t-w-report.campo-c[1] IN BROWSE browse-3.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL t-w-report.Campo-C[1] BROWSE-3 _BROWSE-COLUMN D-Dialog
ON LEAVE OF t-w-report.Campo-C[1] IN BROWSE BROWSE-3 /* Articulo!Premiun!  (F8) */
DO:
   /* Validamos el producto PREMIUM */

  DEFINE VAR x-codPremium AS CHAR.
  DEFINE VAR x-codStandard AS CHAR.
  DEFINE VAR x-art-sugerido AS CHAR.
  DEFINE VAR x-current-rowid AS ROWID.

  DEFINE VAR x-marca AS CHAR.

  ASSIGN t-w-report.campo-c[3]:SCREEN-VALUE IN BROWSE BROWSE-3 = ""
      t-w-report.campo-c[4]:SCREEN-VALUE IN BROWSE BROWSE-3 = ""
      t-w-report.campo-c[5]:SCREEN-VALUE IN BROWSE BROWSE-3 = ""
      t-w-report.campo-c[6]:SCREEN-VALUE IN BROWSE BROWSE-3 = ""
      t-w-report.campo-c[7]:SCREEN-VALUE IN BROWSE BROWSE-3 = "".

  x-marca = t-w-report.campo-c[10]:SCREEN-VALUE IN BROWSE BROWSE-3.
  x-codPremium = t-w-report.campo-c[1]:SCREEN-VALUE IN BROWSE BROWSE-3.

  x-art-sugerido = t-w-report.campo-c[8].
  x-current-rowid = ROWID(t-w-report).

  /* Blanquear los sugeridos del anterior PREMIUM (Solo si esta modificando) */
  FOR EACH x-t-w-report WHERE x-t-w-report.campo-c[8] = 'SUGERIDO' AND x-t-w-report.campo-c[20] = x-old-premium:
          ASSIGN x-t-w-report.campo-c[1] = ""
              x-t-w-report.campo-c[20] = ""
              x-t-w-report.campo-c[4] = ""
              x-t-w-report.campo-c[5] = "".
  END.      
  
  IF TRUE <> (x-codPremium > "") THEN DO:
      ASSIGN t-w-report.campo-f[1]:SCREEN-VALUE IN BROWSE BROWSE-3 = "0.00".

      IF NOT TRUE <> (x-old-premium > "") THEN DO:
          /*REPOSITION browse-3 TO ROWID x-current-RowId.   */
      END.

      browse-3:BUFFER-RELEASE() IN FRAME {&FRAME-NAME}.
      browse-4:BUFFER-RELEASE() IN FRAME {&FRAME-NAME}.

      RETURN "OK".
  END.
  x-old-premium = "".
  
  IF TRUE <> (x-marca > "") THEN DO:
      /* No selecciono Marca */
      RUN validar-articulo-premium(INPUT x-CodPremium, OUTPUT x-codStandard). 
    
      IF RETURN-VALUE = "ADM-ERROR" THEN DO:
          MESSAGE "El articulo " x-codPremium " No esta configurado como PREMIUM" 
              VIEW-AS ALERT-BOX INFORMATION.
          ASSIGN t-w-report.campo-c[1]:SCREEN-VALUE IN BROWSE BROWSE-3 = ""
                t-w-report.campo-f[1]:SCREEN-VALUE IN BROWSE BROWSE-3 = "0.00".
          /**/
          browse-3:BUFFER-RELEASE() IN FRAME {&FRAME-NAME}.
          browse-4:BUFFER-RELEASE() IN FRAME {&FRAME-NAME}.

          RETURN.
      END.
      /* Que aun no este registrado */
      FIND FIRST x-t-w-report WHERE x-t-w-report.campo-c[1] = x-codPremium AND
                                    x-t-w-report.campo-c[8] = "" NO-LOCK NO-ERROR.
      IF AVAILABLE x-t-w-report THEN DO:
          IF x-current-rowid <> ROWID(x-t-w-report) THEN DO:
              MESSAGE "El articulo " x-codpremium " ya esta registrada en la lista" VIEW-AS ALERT-BOX INFORMATION.
              ASSIGN t-w-report.campo-c[1]:SCREEN-VALUE IN BROWSE BROWSE-3 = "".
              browse-3:BUFFER-RELEASE() IN FRAME {&FRAME-NAME}.

              RETURN.
          END.
      END.
      /* Las descripcion del articulo PREMIUM y la MARCA */
      ASSIGN t-w-report.campo-c[3]:SCREEN-VALUE IN BROWSE BROWSE-3 = x-codStandard.      
      FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
                                almmmatg.codmat = x-codpremium NO-LOCK NO-ERROR.
      IF AVAILABLE almmmatg THEN DO:
            ASSIGN t-w-report.campo-c[4]:SCREEN-VALUE IN BROWSE BROWSE-3 = almmmatg.desmat
            t-w-report.campo-c[5]:SCREEN-VALUE IN BROWSE BROWSE-3 = almmmatg.desmar.
            /*browse-3:BUFFER-RELEASE() IN FRAME {&FRAME-NAME}.*/
      END.

      /* ---------------- STANDARD ---------------------------- */
      IF NOT TRUE <> (x-codStandard > "") THEN DO:
          FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
                                    almmmatg.codmat = x-codStandard NO-LOCK NO-ERROR.
          IF AVAILABLE almmmatg THEN DO:
                ASSIGN t-w-report.campo-c[6]:SCREEN-VALUE IN BROWSE BROWSE-3 = almmmatg.desmat                
                    t-w-report.campo-c[7]:SCREEN-VALUE IN BROWSE BROWSE-3 = almmmatg.desmar.
                /*browse-3:BUFFER-RELEASE() IN FRAME {&FRAME-NAME}.*/
          END.
      END.
      {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-c[3]:READ-ONLY IN BROWSE {&BROWSE-NAME}= YES.
  END.
  ELSE DO:
        /* De una Marca en especial */
         DEFINE VAR x-codmarca AS CHAR.

         x-codStandard = t-w-report.campo-c[3]:SCREEN-VALUE IN BROWSE BROWSE-3.

        FIND FIRST almtabla WHERE almtabla.tabla = "MK" AND almtabla.nombre = x-marca NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almtabla THEN DO:
            MESSAGE "El articulo " x-codpremium " imposible ubicar la marca selecionada" VIEW-AS ALERT-BOX INFORMATION.
            ASSIGN t-w-report.campo-c[1]:SCREEN-VALUE IN BROWSE BROWSE-3 = "".
            browse-3:BUFFER-RELEASE() IN FRAME {&FRAME-NAME}.            

            RETURN.
        END.
        x-codmarca = almtabla.codigo.

        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
                                almmmatg.codmat = x-codpremium NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almmmatg THEN DO:
            MESSAGE "El articulo " x-codpremium " no existe en la maestra de Articulos" VIEW-AS ALERT-BOX INFORMATION.
            ASSIGN t-w-report.campo-c[1]:SCREEN-VALUE IN BROWSE BROWSE-3 = "".
            browse-3:BUFFER-RELEASE() IN FRAME {&FRAME-NAME}.

            RETURN.
        END.
        IF x-codmarca <> almmmatg.codmar THEN DO:
            MESSAGE "El articulo " x-codpremium " No es de la marca que se a seleecionado" VIEW-AS ALERT-BOX INFORMATION.
            ASSIGN t-w-report.campo-c[1]:SCREEN-VALUE IN BROWSE BROWSE-3 = "".
            browse-3:BUFFER-RELEASE() IN FRAME {&FRAME-NAME}.

            RETURN.
        END.

        /* Que el articulo aun no este registrado en PREMIUM */
        FIND FIRST x-t-w-report WHERE x-t-w-report.campo-c[1] = x-codPremium AND
                                      x-t-w-report.campo-c[8] = "" NO-LOCK NO-ERROR.
        IF AVAILABLE x-t-w-report THEN DO:
            IF x-current-rowid <> ROWID(x-t-w-report) THEN DO:
                MESSAGE "El articulo " x-codpremium " ya esta registrada en la lista de PREMIUM" VIEW-AS ALERT-BOX INFORMATION.
                ASSIGN t-w-report.campo-c[1]:SCREEN-VALUE IN BROWSE BROWSE-3 = "".
                browse-3:BUFFER-RELEASE() IN FRAME {&FRAME-NAME}.

                RETURN.
            END.
        END.
        /* Que el articulo aun no este registrado en STANDARD */
        FIND FIRST x-t-w-report WHERE x-t-w-report.campo-c[3] = x-codPremium AND
                                      x-t-w-report.campo-c[8] = "" NO-LOCK NO-ERROR.
        IF AVAILABLE x-t-w-report THEN DO:
            IF x-current-rowid <> ROWID(x-t-w-report) THEN DO:
                MESSAGE "El articulo " x-codpremium " ya esta registrada en la lista de PREMIUM" VIEW-AS ALERT-BOX INFORMATION.
                ASSIGN t-w-report.campo-c[1]:SCREEN-VALUE IN BROWSE BROWSE-3 = "".
                browse-3:BUFFER-RELEASE() IN FRAME {&FRAME-NAME}.

                RETURN.
            END.
        END.

        /* Validar si el articulo se vende en el peldaño */
        DEFINE VAR x-retval AS CHAR.

        RUN valida-peldaño(INPUT x-codpremium, INPUT s-coddiv, OUTPUT x-retval).
        IF RETURN-VALUE = "ADM-ERROR" THEN DO:
            MESSAGE x-retval VIEW-AS ALERT-BOX INFORMATION TITLE "ERROR EN EL PELDAÑO (" + x-codpremium + ")".
            ASSIGN t-w-report.campo-c[1]:SCREEN-VALUE IN BROWSE BROWSE-3 = "".
            browse-3:BUFFER-RELEASE() IN FRAME {&FRAME-NAME}.

            RETURN.
        END.

        {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-c[3]:READ-ONLY IN BROWSE {&BROWSE-NAME}= NO.
            ASSIGN t-w-report.campo-c[4]:SCREEN-VALUE IN BROWSE BROWSE-3 = almmmatg.desmat
            t-w-report.campo-c[5]:SCREEN-VALUE IN BROWSE BROWSE-3 = almtabla.nombre.

        /* Copiamos el mismo codigo PREMIUM como STANDARD */
       IF TRUE <> (x-codStandard > "") THEN DO:
            /*
           /* Que el articulo aun no este registrado en PREMIUM */
           FIND FIRST x-t-w-report WHERE x-t-w-report.campo-c[1] = x-codPremium AND
                                         x-t-w-report.campo-c[8] = "" NO-LOCK NO-ERROR.
           IF AVAILABLE x-t-w-report THEN DO:
               IF x-current-rowid <> ROWID(x-t-w-report) THEN DO:
                   MESSAGE "El articulo " x-codpremium " ya esta registrada en la lista de PREMIUM" VIEW-AS ALERT-BOX INFORMATION.
                   ASSIGN t-w-report.campo-c[1]:SCREEN-VALUE IN BROWSE BROWSE-3 = "".
                   browse-3:BUFFER-RELEASE() IN FRAME {&FRAME-NAME}.

                   RETURN.
               END.
           END.
           */
           /* Que el articulo aun no este registrado en STANDARD */
           FIND FIRST x-t-w-report WHERE x-t-w-report.campo-c[3] = x-codPremium AND
                                         x-t-w-report.campo-c[8] = "" NO-LOCK NO-ERROR.
           IF AVAILABLE x-t-w-report THEN DO:
               IF x-current-rowid <> ROWID(x-t-w-report) THEN DO:
                   MESSAGE "El articulo " x-codpremium " ya esta registrada en la lista de STANDARD" VIEW-AS ALERT-BOX INFORMATION.
                   ASSIGN t-w-report.campo-c[1]:SCREEN-VALUE IN BROWSE BROWSE-3 = "".
                   browse-3:BUFFER-RELEASE() IN FRAME {&FRAME-NAME}.

                   RETURN.
               END.
           END.
            /*  */
            ASSIGN t-w-report.campo-c[3]:SCREEN-VALUE IN BROWSE BROWSE-3 = x-codpremium
                t-w-report.campo-c[6]:SCREEN-VALUE IN BROWSE BROWSE-3 = almmmatg.desmat
                t-w-report.campo-c[7]:SCREEN-VALUE IN BROWSE BROWSE-3 = almtabla.nombre.
       END.
  END.

  DEFINE VAR x-sugerido AS INT.  
  DEFINE VAR x-rowid AS ROWID.

  /* Sugeridos */
  x-sugerido = 0.
  x-art-sugerido = "".

  FIND FIRST x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                                x-vtatabla.tabla = 'PROD.SUGERIDOS' AND
                                x-vtatabla.llave_c1 = x-codpremium NO-LOCK NO-ERROR.
  IF AVAILABLE x-vtatabla THEN DO:
      /* Sugeridos Obligados */      
      FOR EACH x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                                x-vtatabla.tabla = 'PROD.SUGERIDOS' AND
                                x-vtatabla.llave_c1 = x-codpremium AND 
                                x-vtatabla.libre_c01 = 'ACTIVO' AND 
                                x-vtatabla.libre_c02 = 'SI' NO-LOCK
                                BY x-vtatabla.valor[1] :
          x-sugerido = -1.
          PASO_00:
          FOR EACH x-t-w-report WHERE x-t-w-report.campo-c[8] = 'SUGERIDO' AND 
                                    x-t-w-report.campo-c[1] = x-vtatabla.llave_c2 NO-LOCK:
              x-sugerido = 1.   /* Ya existe como sugerido */
              LEAVE PASO_00.
          END.
          IF x-sugerido = 1 THEN NEXT.

          x-sugerido = 1.
          /* Buscar si articulo PREMIUM ya tiene sugerido, se actualiza */
          PASO_01:
          FOR EACH x-t-w-report WHERE x-t-w-report.campo-c[8] = 'SUGERIDO' AND x-t-w-report.campo-c[20] = x-codpremium:
              ASSIGN    x-t-w-report.campo-c[1] = x-vtatabla.llave_c2.
                        x-art-sugerido = x-vtatabla.llave_c2.
              x-rowid = ROWID(x-t-w-report).
              x-sugerido = 2.   /**/
              LEAVE PASO_01.
          END.
          IF x-sugerido = 1 THEN DO:
              /* Buscamos al primer disponible y cargamos al sugerido */
              PASO_02:
              FOR EACH x-t-w-report WHERE x-t-w-report.campo-c[8] = 'SUGERIDO' AND x-t-w-report.campo-c[20] = "":
                  ASSIGN x-t-w-report.campo-c[1] = x-vtatabla.llave_c2
                            x-t-w-report.campo-c[20] = x-codpremium.
                  x-art-sugerido = x-vtatabla.llave_c2.
                  x-rowid = ROWID(x-t-w-report).
                  x-sugerido = 2.
                  LEAVE PASO_02.
              END.              
          END.
          IF x-sugerido = 1 THEN DO:
              /* Ya no hay registro libre sugerido para enlazarlo con el premium */
          END.
          ELSE DO:
              FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
                                      almmmatg.codmat = x-art-sugerido NO-LOCK NO-ERROR.
              IF NOT AVAILABLE almmmatg OR almmmatg.tpoart <> 'A' THEN DO:
                  MESSAGE "El articulo sugerido " x-art-sugerido " no existe en la maestra de Articulos o esta dado de baja" VIEW-AS ALERT-BOX INFORMATION.                  
                  /* Revertir */
                  FIND FIRST x-t-w-report WHERE ROWID(x-t-w-report) = x-rowid EXCLUSIVE-LOCK NO-ERROR.
                  IF AVAILABLE x-t-w-report THEN DO:
                      ASSIGN x-t-w-report.campo-c[1] = ""
                            x-t-w-report.campo-c[20] = "".
                      browse-4:BUFFER-RELEASE() IN FRAME {&FRAME-NAME}.
                  END.                 
              END.
              ELSE DO:
                  FIND FIRST x-t-w-report WHERE ROWID(x-t-w-report) = x-rowid EXCLUSIVE-LOCK NO-ERROR.
                  IF AVAILABLE x-t-w-report THEN DO:
                    ASSIGN x-t-w-report.campo-c[4] = almmmatg.desmat
                            x-t-w-report.campo-c[5] = almmmatg.desmar.
                    browse-4:BUFFER-RELEASE() IN FRAME {&FRAME-NAME}.
                  END.
              END.
          END.
      END.
  END.

  browse-3:BUFFER-RELEASE() IN FRAME {&FRAME-NAME}.
  /*
  browse-4:SELECT-ROW(1) IN FRAME {&FRAME-NAME}.
  browse-4:SELECT-PREV-ROW() IN FRAME {&FRAME-NAME}.
  browse-4:SELECT-NEXT-ROW() IN FRAME {&FRAME-NAME}.
      
  FOR EACH x-t-w-report WHERE x-t-w-report.campo-c[8] = 'SUGERIDO':
      /*MESSAGE x-t-w-report.campo-c[1].*/
  END.
  */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME t-w-report.Campo-C[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL t-w-report.Campo-C[3] BROWSE-3 _BROWSE-COLUMN D-Dialog
ON LEAVE OF t-w-report.Campo-C[3] IN BROWSE BROWSE-3 /* Articulo!Standard */
DO:
    /* Validamos el producto STANDARD */  

    DEFINE VAR x-codStandard AS CHAR.
    DEFINE VAR x-codPremium AS CHAR.

    DEFINE VAR x-marca AS CHAR.

    ASSIGN 
        t-w-report.campo-c[6]:SCREEN-VALUE IN BROWSE BROWSE-3 = ""
        t-w-report.campo-c[7]:SCREEN-VALUE IN BROWSE BROWSE-3 = ""
        .

    x-marca = t-w-report.campo-c[10]:SCREEN-VALUE IN BROWSE BROWSE-3.

    x-codStandard = t-w-report.campo-c[3]:SCREEN-VALUE IN BROWSE BROWSE-3.
    x-codPremium = t-w-report.campo-c[1]:SCREEN-VALUE IN BROWSE BROWSE-3.

    IF TRUE <> (x-codStandard > "") THEN DO:
        RETURN.
    END.
    IF TRUE <> (x-codPremium > "") THEN DO:
        MESSAGE "Primero debe ingresar el producto PREMIUM" VIEW-AS ALERT-BOX INFORMATION.
        RETURN.
    END.
    IF TRUE <> (x-marca > "") THEN DO:
        /*
        RUN validar-articulo-premium(INPUT x-CodPremium, OUTPUT x-codStandard).

        IF RETURN-VALUE = "ADM-ERROR" THEN DO:
            MESSAGE "El articulo " x-codPremium " No esta configurado coomo PREMIUM" 
                VIEW-AS ALERT-BOX INFORMATION.
            ASSIGN t-w-report.campo-c[1]:SCREEN-VALUE IN BROWSE BROWSE-3 = ""
                  t-w-report.campo-f[1]:SCREEN-VALUE IN BROWSE BROWSE-3 = "0.00".
            RETURN.
        END.

        t-w-report.campo-c[3]:SCREEN-VALUE IN BROWSE BROWSE-3 = x-codStandard.

        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
                                  almmmatg.codmat = x-codpremium NO-LOCK NO-ERROR.
        IF AVAILABLE almmmatg THEN DO:
              ASSIGN t-w-report.campo-c[4]:SCREEN-VALUE IN BROWSE BROWSE-3 = almmmatg.desmat
              t-w-report.campo-c[5]:SCREEN-VALUE IN BROWSE BROWSE-3 = almmmatg.desmar.
        END.

        {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-c[3]:READ-ONLY IN BROWSE {&BROWSE-NAME}= YES.
        */
    END.
    ELSE DO:

           DEFINE VAR x-codmarca AS CHAR.

          FIND FIRST almtabla WHERE almtabla.tabla = "MK" AND almtabla.nombre = x-marca NO-LOCK NO-ERROR.
          IF NOT AVAILABLE almtabla THEN DO:
              MESSAGE "El articulo " x-codstandard " imposible ubicar la marca selecionada" VIEW-AS ALERT-BOX INFORMATION.
              ASSIGN t-w-report.campo-c[3]:SCREEN-VALUE IN BROWSE BROWSE-3 = "".
              RETURN.
          END.
          x-codmarca = almtabla.codigo.

          FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
                                  almmmatg.codmat = x-codstandard NO-LOCK NO-ERROR.
          IF NOT AVAILABLE almmmatg THEN DO:
              MESSAGE "El articulo " x-codstandard " no existe en la maestra de Articulos" VIEW-AS ALERT-BOX INFORMATION.
              ASSIGN t-w-report.campo-c[3]:SCREEN-VALUE IN BROWSE BROWSE-3 = "".
              RETURN.
          END.
          IF x-codmarca <> almmmatg.codmar THEN DO:
              MESSAGE "El articulo " x-codstandard " No es de la marca que usted a elejido" VIEW-AS ALERT-BOX INFORMATION.
              ASSIGN t-w-report.campo-c[3]:SCREEN-VALUE IN BROWSE BROWSE-3 = "".
              RETURN.
          END.
          /*{&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-c[3]:READ-ONLY IN BROWSE {&BROWSE-NAME}= NO.*/

          /* Validar si el articulo se vende en el peldaño */
          DEFINE VAR x-retval AS CHAR.

          RUN valida-peldaño(INPUT x-codstandard, INPUT s-coddiv, OUTPUT x-retval).
          IF RETURN-VALUE = "ADM-ERROR" THEN DO:
              MESSAGE x-retval VIEW-AS ALERT-BOX INFORMATION TITLE "ERROR EN EL PELDAÑO (" + x-codstandard + ")".

              ASSIGN t-w-report.campo-c[3]:SCREEN-VALUE IN BROWSE BROWSE-3 = "".
              RETURN.
          END.
          ASSIGN t-w-report.campo-c[6]:SCREEN-VALUE IN BROWSE BROWSE-3 = almmmatg.desmat
          t-w-report.campo-c[7]:SCREEN-VALUE IN BROWSE BROWSE-3 = almtabla.nombre.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
&Scoped-define SELF-NAME BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 D-Dialog
ON ROW-DISPLAY OF BROWSE-4 IN FRAME D-Dialog /* Articulos SUGERIDOS */
DO:
  /*MESSAGE "Rowdisplay".*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 D-Dialog
ON VALUE-CHANGED OF BROWSE-4 IN FRAME D-Dialog /* Articulos SUGERIDOS */
DO:
    
    DEFINE VAR x-sugerido AS CHAR.

    DO WITH FRAME {&FRAME-NAME}:
        /*browse-4:REFRESH().*/
    END.
   /* 
    {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-c[3]:READ-ONLY IN BROWSE {&BROWSE-NAME}= NO.
    IF x-sugerido = "SUGERIDO" THEN DO:
        {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-c[3]:READ-ONLY IN BROWSE {&BROWSE-NAME}= YES.
    END.
    */

   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME t-w-report.Campo-C[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL t-w-report.Campo-C[2] BROWSE-4 _BROWSE-COLUMN D-Dialog
ON ENTRY OF t-w-report.Campo-C[2] IN BROWSE BROWSE-4
DO:
    DEFINE VAR x-sugerido AS CHAR.
     DEFINE VAR x-es-sugerido AS CHAR.

     x-es-sugerido = t-w-report.campo-c[8].
     x-sugerido = t-w-report.campo-c[1]:SCREEN-VALUE IN BROWSE BROWSE-4.

     IF x-es-sugerido = 'SUGERIDO' THEN DO:
       /*IF NOT TRUE <> (x-sugerido > "") THEN DO:*/
           RETURN NO-APPLY.
       /*END.*/
     END.
     x-old-premium = SELF:SCREEN-VALUE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME t-w-report.Campo-C[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL t-w-report.Campo-C[1] BROWSE-4 _BROWSE-COLUMN D-Dialog
ON ENTRY OF t-w-report.Campo-C[1] IN BROWSE BROWSE-4 /* Articulo!Premiun */
DO:
  
    DEFINE VAR x-sugerido AS CHAR.
    DEFINE VAR x-es-sugerido AS CHAR.

    x-es-sugerido = t-w-report.campo-c[8].
    x-sugerido = t-w-report.campo-c[1]:SCREEN-VALUE IN BROWSE BROWSE-4.

    IF x-es-sugerido = 'SUGERIDO' THEN DO:
      /*IF NOT TRUE <> (x-sugerido > "") THEN DO:*/
          RETURN NO-APPLY.
      /*END.*/
    END.
    /*x-old-premium = SELF:SCREEN-VALUE.*/
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME t-w-report.Campo-C[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL t-w-report.Campo-C[3] BROWSE-4 _BROWSE-COLUMN D-Dialog
ON ENTRY OF t-w-report.Campo-C[3] IN BROWSE BROWSE-4 /* Articulo!Standard */
DO:
    DEFINE VAR x-sugerido AS CHAR.
    DEFINE VAR x-es-sugerido AS CHAR.

    x-es-sugerido = t-w-report.campo-c[8].

    IF x-es-sugerido = 'SUGERIDO' THEN DO:
      /*IF NOT TRUE <> (x-sugerido > "") THEN DO:*/
          RETURN NO-APPLY.
      /*END.*/
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Cancel */
DO:
  RUN Salir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help D-Dialog
ON CHOOSE OF Btn_Help IN FRAME D-Dialog /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
MESSAGE "Help for File: {&FILE-NAME}":U VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
    IF x-sugeridos-completo = NO THEN DO:
        MESSAGE 'Aun NO a procesado la busqueda de SUGERIDOS' SKIP 
                'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.
    END.
    MESSAGE 'Esta seguro de CONTINUAR con esta lista escolar' SKIP 
            'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta1 AS LOG.
    IF rpta1 = NO THEN RETURN NO-APPLY.

  RUN generar-rows.

  IF RETURN-VALUE = "OK" THEN DO:
      RUN Salir.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 D-Dialog
ON CHOOSE OF BUTTON-3 IN FRAME D-Dialog /* ... */
DO:

    DEFINE VAR x-archivo AS CHAR.
    DEFINE VAR OKpressed AS LOG.

          SYSTEM-DIALOG GET-FILE x-Archivo
            FILTERS "Archivo (*.txt)" "*.txt"
            MUST-EXIST
            TITLE "Seleccione archivo..."
            UPDATE OKpressed.   
          IF OKpressed = NO THEN RETURN NO-APPLY.

   fill-in-txt:SCREEN-VALUE = x-archivo.

    DEFINE VAR x-linea-texto AS CHAR.
    DEFINE VAR x-linea-texto2 AS CHAR.
    DEFINE VAR x-sec AS INT INIT 0.
    
    EMPTY TEMP-TABLE t-w-report.
    
    INPUT FROM VALUE(x-archivo).
    REPEAT:
        IMPORT UNFORMATTED x-linea-texto.
    
        x-linea-texto = TRIM(x-linea-texto).
        x-linea-texto2 = CODEPAGE-CONVERT(x-linea-texto, SESSION:CHARSET, "utf-8").
        IF NOT TRUE <> (x-linea-texto2 > "") THEN DO:
            CREATE t-w-report.
            ASSIGN t-w-report.campo-c[2] = x-linea-texto2
                    t-w-report.campo-c[8] = "".
            x-sec = x-sec + 1.
        END.
    END.
    
    INPUT CLOSE.

    IF x-sec > 0 THEN DO:
        /* Sugeridos */
        /*
        CREATE t-w-report.
        ASSIGN t-w-report.campo-c[2] = "----------- PRODUCTOS SUGERIDOS -----------".
        */
        REPEAT x-sec = 1 TO 10:
            CREATE t-w-report.
            ASSIGN t-w-report.campo-c[2] = ".- Sugerido numero " + STRING(x-sec)
                    t-w-report.campo-c[8] = "SUGERIDO".
        END.

        DO WITH FRAME {&FRAME-NAME}:
           button-sugeridos:VISIBLE = YES.
        END.

        x-sugeridos-completo = NO.
    END.
    ELSE DO:
        MESSAGE "La lista seleccionada no contiene ninguna informacion"
            VIEW-AS ALERT-BOX INFORMATION.
    END.
    
    GET FIRST browse-3.
    GET FIRST browse-4.

    {&OPEN-QUERY-BROWSE-4}
    {&OPEN-QUERY-BROWSE-3}



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-sugeridos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-sugeridos D-Dialog
ON CHOOSE OF BUTTON-sugeridos IN FRAME D-Dialog /* Buscar sugeridos faltantes */
DO:
  browse-4:REFRESH() IN FRAME {&FRAME-NAME}.

  /**/
  RUN busca-sugeridos-faltantes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

DO WITH FRAME {&FRAME-NAME}:



    ON 'RETURN':U OF t-w-report.campo-c[1], t-w-report.campo-f[1], t-w-report.campo-c[3] IN BROWSE BROWSE-3 DO:
        APPLY 'TAB':U.
        RETURN NO-APPLY.
    END.
    
    ON ENTRY OF t-w-report.campo-c[10] IN BROWSE BROWSE-3 DO:
        /**/
        DEFINE VARIABLE hColumn AS HANDLE      NO-UNDO.
        DEFINE VAR cColumnName AS CHAR.
        DEFINE VAR x-conteo AS INT.
    
        ASSIGN hColumn = SELF:HANDLE.
        cColumnName = CAPS(hColumn:NAME).     
        
        IF x-fill-combo = YES THEN DO:
    
            /* Eliminar lo anterior definidos */
                REPEAT WHILE hColumn:NUM-ITEMS > 0:
                    hColumn:DELETE(1).
                END.
            x-conteo = 0.
            SESSION:SET-WAIT-STATE("GENERAL").
            RUN AddComboItem(INPUT hColumn,"","").
            SELF:SCREEN-VALUE = "".
            FOR EACH almtabla WHERE almtabla.tabla = "MK" NO-LOCK BY almtabla.nombre:
        
                    IF TRUE <> (almtabla.nombre > "") THEN NEXT.
                    IF x-conteo <= 5 THEN DO:
                        /*MESSAGE almtabla.nombre.*/
                    END.
                    x-conteo = x-conteo * 1.

                    /* Solo los Vigentes */
                    RUN AddComboItem(INPUT hColumn,TRIM(almtabla.nombre),"").
    
                    /*IF SELF:SCREEN-VALUE = '' THEN SELF:SCREEN-VALUE = TRIM(almtabla.nombre).*/
                    x-fill-combo = NO.
                
            END.
            SESSION:SET-WAIT-STATE("").
            
        END.    
        x-old-data = SELF:SCREEN-VALUE.
                    
    END.
END.

{src/adm/template/dialogmn.i}

PROCEDURE AddComboItem :
/*------------------------------------------------------------------------------
  Purpose:     add an item to the combo-box. Each item can be associated with 
               itemdata (is low-level implementation of PRIVATE-DATA).
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER ip_hCombobox AS HANDLE  NO-UNDO.
  DEFINE INPUT PARAMETER ip_ItemText  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER ip_ItemData  AS INTEGER NO-UNDO.
 
  DEFINE VARIABLE lpString AS MEMPTR  NO-UNDO.
  DEFINE VARIABLE SelIndex AS INTEGER NO-UNDO.
  DEFINE VARIABLE retval   AS INTEGER NO-UNDO.
 
  SET-SIZE(lpString)     = 0.
  SET-SIZE(lpString)     = LENGTH(ip_ItemText) + 1.
  PUT-STRING(lpString,1) = ip_ItemText.
 
  RUN SendMessageA (ip_hCombobox:HWND,
                    323, /* = CB_ADSTRING */
                    0,
                    GET-POINTER-VALUE(lpString),
                    OUTPUT selIndex) NO-ERROR.
 
  RUN SendMessageA (ip_hCombobox:HWND  ,
                    337, /* = CB_SETITEMDATA */
                    SelIndex,
                    ip_ItemData,
                    OUTPUT retval) NO-ERROR.
  SET-SIZE(lpString)=0.
 
  RETURN.
END PROCEDURE.

PROCEDURE SendMessageA EXTERNAL "user32.dll":
    DEFINE INPUT PARAMETER hwnd AS LONG.
    DEFINE INPUT PARAMETER umsg AS LONG.
    DEFINE INPUT PARAMETER wparam AS LONG.
    DEFINE INPUT PARAMETER lparam AS LONG.
    DEFINE OUTPUT PARAMETER lRetval AS LONG.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE busca-sugeridos-faltantes D-Dialog 
PROCEDURE busca-sugeridos-faltantes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-conteo AS INT INIT 0.
DEFINE VAR x-azar AS INT INIT 0.

FOR EACH x-t-w-report WHERE x-t-w-report.campo-c[8] = "SUGERIDO" AND x-t-w-report.campo-c[1] = "" NO-LOCK:
    x-conteo = x-conteo + 1.
END.

IF x-conteo = 0 THEN DO:
    MESSAGE "La lista de productos sugeridos ya esta completa"
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN "OK".
END.

DEFINE VAR x-posibles AS CHAR EXTENT 50.
DEFINE VAR x-cuantos-posibles AS INT.
DEFINE VAR x-azar-sugeridos AS CHAR EXTENT 50.
DEFINE VAR x-salir AS INT.
DEFINE VAR x-existe AS LOG.
DEFINE VAR x-posible AS CHAR.
DEFINE VAR x-azar-conteo AS INT.

x-azar-conteo = 0.
DEFINE BUFFER y-t-w-report FOR t-w-report.

/* Blanqueo */
FOR EACH x-t-w-report WHERE x-t-w-report.campo-c[8] = "SUGERIDO" AND x-t-w-report.campo-c[20] = "":
    ASSIGN x-t-w-report.campo-c[1] = ""
            x-t-w-report.campo-c[4] = ""
            x-t-w-report.campo-c[5] = "".                        
END.

/* Articulos de la LISTA */
FOR EACH t-w-report WHERE t-w-report.campo-c[8] = "" AND t-w-report.campo-c[1] <> "" NO-LOCK:
    /* Buscamos si el articulo PREMIUM NO TIENE sugeridos */
    FIND FIRST y-t-w-report WHERE y-t-w-report.campo-c[20] = t-w-report.campo-c[1] NO-LOCK NO-ERROR.
    IF NOT AVAILABLE y-t-w-report THEN DO:
        /*  */
        REPEAT x-conteo = 1 TO 50:
            x-posibles[x-conteo] = "".
        END.
        /* Cuales son sus sugeridos */
        x-cuantos-posibles = 0.
        FOR EACH x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                                  x-vtatabla.tabla = 'PROD.SUGERIDOS' AND
                                  x-vtatabla.llave_c1 = t-w-report.campo-c[1] AND 
                                  x-vtatabla.libre_c01 = 'ACTIVO' AND 
                                  x-vtatabla.libre_c02 = 'NO' NO-LOCK
                                  BY x-vtatabla.valor[1] :
            x-cuantos-posibles = x-cuantos-posibles + 1.
            x-posibles[x-cuantos-posibles] = x-vtatabla.llave_c2.
        END.

        IF x-cuantos-posibles > 0 THEN DO:
            LOOP_01:
            REPEAT x-salir = 1 TO 100:
                IF x-cuantos-posibles > 1 THEN DO:
                    x-azar = RANDOM(1,x-cuantos-posibles).
                END.
                ELSE DO:
                    x-azar = 1.
                END.
                
                x-posible = x-posibles[x-azar].
                x-existe = NO.

                SUGERIDO_EXISTE:
                DO x-conteo = 1 TO 50:
                    IF x-azar-sugeridos[x-conteo] = x-posible THEN DO:
                        /* ya existe */
                        x-existe = YES.
                        LEAVE SUGERIDO_EXISTE.
                    END.
                    /* --- */
                    FIND FIRST y-t-w-report WHERE y-t-w-report.campo-c[8] = "" AND y-t-w-report.campo-c[1] = x-posible NO-LOCK NO-ERROR.
                    IF AVAILABLE y-t-w-report THEN DO:
                        /* ya existe como producto PRIMUM */
                        x-existe = YES.
                        LEAVE SUGERIDO_EXISTE.
                    END.
                    FIND FIRST y-t-w-report WHERE y-t-w-report.campo-c[8] = "" AND y-t-w-report.campo-c[3] = x-posible NO-LOCK NO-ERROR.
                    IF AVAILABLE y-t-w-report THEN DO:
                        /* ya existe como producto STANDARD */
                        x-existe = YES.
                        LEAVE SUGERIDO_EXISTE.
                    END.
                    FIND FIRST y-t-w-report WHERE y-t-w-report.campo-c[8] = "SUGERIDO" AND y-t-w-report.campo-c[1] = x-posible NO-LOCK NO-ERROR.
                    IF AVAILABLE y-t-w-report THEN DO:
                        /* ya existe como producto SUGERIDO */
                        x-existe = YES.
                        LEAVE SUGERIDO_EXISTE.
                    END.
                END.
                /**/
                IF x-existe = NO THEN DO:
                    FIND FIRST y-t-w-report WHERE y-t-w-report.campo-c[8] = "SUGERIDO" AND y-t-w-report.campo-c[1] = x-posible NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE y-t-w-report THEN DO:
                        x-azar-conteo = x-azar-conteo + 1.
                        x-azar-sugeridos[x-azar-conteo] = x-posible.
                        x-existe = NO.
                        LEAVE LOOP_01.                            
                    END.
                    ELSE DO:
                        x-existe = YES.
                    END.
                END.
            END.                
        END.
    END.
END.
REPEAT x-conteo = 1 TO x-azar-conteo:
    /* Filas sugeridos en blanco para rellenar  */
    FOR EACH x-t-w-report WHERE x-t-w-report.campo-c[8] = "SUGERIDO" AND x-t-w-report.campo-c[1] = "":
        ASSIGN x-t-w-report.campo-c[1] = x-azar-sugeridos[x-conteo]
                  /*x-t-w-report.campo-c[20] = t-w-report.campo-c[1]*/.

        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
                                almmmatg.codmat = x-azar-sugeridos[x-conteo] NO-LOCK NO-ERROR.
        IF AVAILABLE almmmatg THEN DO:
            ASSIGN  x-t-w-report.campo-c[4] = almmmatg.desmat
                    x-t-w-report.campo-c[5] = almmmatg.desmar.                        
        END.
        LEAVE.
    END.
END.

{&open-query-browse-4}

x-sugeridos-completo = YES.


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
  DISPLAY FILL-IN-txt 
      WITH FRAME D-Dialog.
  ENABLE BROWSE-3 BROWSE-4 BUTTON-3 Btn_Cancel Btn_OK BUTTON-sugeridos 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-rows D-Dialog 
PROCEDURE generar-rows :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-w-report.

DEFINE VAR x-cantidad AS DEC.
DEFINE VAR x-codpremium AS CHAR.
DEFINE VAR x-codstandard AS CHAR.
DEFINE VAR x-des-web AS CHAR.
DEFINE VAR x-sugerido AS CHAR.
DEFINE VAR x-conteo AS INT.

DEFINE VAR pCanPed AS DEC NO-UNDO.
DEFINE VAR pMensaje AS CHAR NO-UNDO.
DEFINE VAR hProc AS HANDLE NO-UNDO.
DEFINE VAR x-error AS LOG.

RUN vtagn/ventas-library PERSISTENT SET hProc.

    DO WITH FRAME {&FRAME-NAME}:

        /**/
        browse-4:BUFFER-RELEASE() IN FRAME {&FRAME-NAME}.
        browse-3:BUFFER-RELEASE() IN FRAME {&FRAME-NAME}.
        /**/

        x-error = NO.

        VALIDAD_CANTIDAD:
        FOR EACH x-t-w-report NO-LOCK:
            x-codpremium = x-t-w-report.campo-c[1].
            x-cantidad = x-t-w-report.campo-f[1].
            x-codstandard = x-t-w-report.campo-c[3].
            x-des-web = x-t-w-report.campo-c[2].
            x-sugerido = x-t-w-report.campo-c[8].
            IF (x-sugerido = "SUGERIDO" AND (NOT (TRUE<>(x-codpremium > "")) OR NOT (TRUE <> (x-codstandard > ""))))
                OR (x-cantidad > 0 AND (NOT (TRUE<>(x-codpremium > "")) OR NOT (TRUE <> (x-codstandard > "")))) THEN DO:
                /* */
                pCanPed = x-cantidad.
                IF x-codpremium > "" THEN DO:
                    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
                                                almmmatg.codmat = x-codpremium NO-LOCK NO-ERROR.

                    RUN VTA_Valida-Cantidad IN hProc (INPUT x-codpremium,
                                                      INPUT almmmatg.undbas,
                                                      INPUT-OUTPUT pCanPed,
                                                      OUTPUT pMensaje).
                    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                        MESSAGE "El articulo PREMIUM " x-codpremium SKIP
                                pMensaje VIEW-AS ALERT-BOX ERROR.
                        x-error = YES.
                        LEAVE VALIDAD_CANTIDAD.
                    END.
                END.
                IF x-codstandard > "" THEN DO:
                    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
                                                almmmatg.codmat = x-codstandard NO-LOCK NO-ERROR.

                    RUN VTA_Valida-Cantidad IN hProc (INPUT x-codstandard,
                                                      INPUT almmmatg.undbas,
                                                      INPUT-OUTPUT pCanPed,
                                                      OUTPUT pMensaje).
                    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                        MESSAGE "El articulo STANDARD " x-codstandard SKIP
                                pMensaje VIEW-AS ALERT-BOX ERROR.
                        x-error = YES.
                        LEAVE VALIDAD_CANTIDAD.
                    END.
                END.

            END.
        END.
        DELETE PROCEDURE hProc.

        IF x-error = YES THEN DO:
            RETURN "ADM-ERROR".
        END.

        FOR EACH x-t-w-report NO-LOCK:
            x-codpremium = x-t-w-report.campo-c[1].
            x-cantidad = x-t-w-report.campo-f[1].
            x-codstandard = x-t-w-report.campo-c[3].
            x-des-web = x-t-w-report.campo-c[2].
            x-sugerido = x-t-w-report.campo-c[8].
            IF (x-sugerido = "SUGERIDO" AND (NOT (TRUE<>(x-codpremium > "")) OR NOT (TRUE <> (x-codstandard > ""))))
                OR (x-cantidad > 0 AND (NOT (TRUE<>(x-codpremium > "")) OR NOT (TRUE <> (x-codstandard > "")))) THEN DO:
                CREATE tt-w-report.
                    ASSIGN tt-w-report.campo-c[1] = x-codpremium
                            tt-w-report.campo-c[2] = x-des-web
                            tt-w-report.campo-c[3] = x-codstandard
                            tt-w-report.campo-f[1] = x-cantidad
                            tt-w-report.campo-c[8] = x-sugerido.
                x-conteo = x-conteo + 1.
            END.
        END.
    END.

    RETURN "OK".

END PROCEDURE.

/*cFami = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Codfam.*/


/*   
                    MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
                    ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(pCanPed).
                    ASSIGN ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
                    APPLY 'ENTRY':U TO ITEM.CodMat.
                    RETURN "ADM-ERROR".
  */

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
  DO WITH FRAME {&FRAME-NAME}:
      button-sugeridos:VISIBLE = NO.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Salir D-Dialog 
PROCEDURE Salir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*APPLY "CLOSE":U TO THIS-PROCEDURE.*/
APPLY "END-ERROR":U TO SELF.

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
  {src/adm/template/snd-list.i "t-w-report"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-peldaño D-Dialog 
PROCEDURE valida-peldaño :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodmat AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pCodDiv AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR.

DEFINE VAR hProc AS HANDLE NO-UNDO.             /* Handle Libreria */

RUN lib\API_consumo.r PERSISTENT SET hProc.

DEFINE VAR x-api AS LONGCHAR.
DEFINE VAR x-resultado AS LONGCHAR.

/* Procedimientos */
RUN API_tabla IN hProc (INPUT "ARTICULO.PELDAÑO", OUTPUT x-api).

IF TRUE<>(x-api > "") THEN DO:
    pRetVal = "NO se pudo ubicar la API para validar el peldaño del articulo".
    RETURN "ADM-ERROR".
END.

x-api = x-api + "&FieldName=SalesChannel&ArtCode=" + pCodMat + "&Code=" + pCodDiv.

RUN API_consumir IN hProc (INPUT x-api, OUTPUT x-resultado).
IF x-resultado BEGINS "ERROR:" THEN DO:
    pRetVal = STRING(x-resultado).
    RETURN "ADM-ERROR".
END.
IF index(lower(x-resultado),"not content") > 0 THEN DO:
    pRetVal = "El articulo " + pCodMat + " no se comercializa en el punto de venta " + pCodDiv.
    RETURN "ADM-ERROR".
END.

pRetVal = "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validar-articulo-premium D-Dialog 
PROCEDURE validar-articulo-premium :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodMat AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pCodMatStandard AS CHAR NO-UNDO.
/*
FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                            vtatabla.tabla = x-tabla AND
                            vtatabla.llave_c1 = pCodMat NO-LOCK NO-ERROR.
IF NOT AVAILABLE vtatabla THEN RETURN "ADM-ERROR".

pCodMatStandard = vtatabla.llave_c2.
*/

FIND FIRST listaexpressarticulos WHERE listaexpressarticulos.codcia = s-codcia AND
                            listaexpressarticulos.codprodpremium = pCodMat NO-LOCK NO-ERROR.
IF NOT AVAILABLE listaexpressarticulos THEN RETURN "ADM-ERROR".

pCodMatStandard = listaexpressarticulos.codprodstandard.


RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

