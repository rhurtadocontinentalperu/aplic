&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE dtl-w-report-1 NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE p-di-rutaC LIKE DI-RutaC.
DEFINE TEMP-TABLE rsm-w-report-1 NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE rsm-w-report-2 NO-UNDO LIKE w-report.



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
DEFINE TEMP-TABLE ppResumen
    FIELD   tcuadrante     AS  CHAR    FORMAT 'x(5)'
    FIELD   ttotclie    AS  INT     INIT 0
    FIELD   ttotpeso    AS  DEC     INIT 0
    FIELD   ttotvol     AS  DEC     INIT 0
    FIELD   ttotimp     AS  DEC     INIT 0
    FIELD   ttotord     AS  INT     INIT 0
    FIELD   tnro-phruta AS CHAR     FORMAT 'x(15)'
    FIELD   tobserva    AS CHAR     FORMAT 'x(15)'
    FIELD   tswok       AS CHAR     FORMAT 'x(1)' INIT ""
.
DEFINE TEMP-TABLE   ppDetalle
    FIELD   tcuadrante     AS  CHAR    FORMAT 'x(5)'
    FIELD   tcoddoc     AS  CHAR    FORMAT '(5)'
    FIELD   tnroped     AS  CHAR    FORMAT 'x(15)'
    FIELD   tcodcli     AS  CHAR    FORMAT 'x(12)'
    FIELD   ttotpeso    AS  DEC     INIT 0
    FIELD   ttotvol     AS  DEC     INIT 0
    FIELD   ttotimp     AS  DEC     INIT 0
    FIELD   tubigeo     AS  CHAR    FORMAT 'x(8)'
    FIELD   titems      AS  INT     INIT 0
    FIELD   tfchped     AS  DATE
    FIELD   tfchent     AS  DATE
    FIELD   tnomcli     AS  CHAR
.

/*DEFINE TEMP-TABLE p-di-rutaC LIKE di-rutaC.*/
DEFINE TEMP-TABLE p-di-rutaD LIKE di-rutaD.

DEFINE INPUT PARAMETER TABLE FOR ppResumen.
DEFINE INPUT PARAMETER TABLE FOR ppDetalle.
DEFINE INPUT PARAMETER TABLE FOR p-di-rutaC.
DEFINE INPUT PARAMETER TABLE FOR p-di-rutaD.
DEFINE OUTPUT PARAMETER pProcesado AS CHAR.

/* Local Variable Definitions ---                                       */
pProcesado = 'NO'.

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.
DEFINE SHARED VAR cl-CodCia AS INT.

DEF VAR s-coddoc AS CHAR INIT 'PHR' NO-UNDO. 

DEFINE VAR x-cuadrante-1 AS CHAR INIT "".
DEFINE VAR x-cuadrante-2 AS CHAR INIT "".
DEFINE VAR x-orden AS CHAR INIT "".

DEFINE TEMP-TABLE tt-dtl-w-report-1 LIKE dtl-w-report-1.

DEFINE BUFFER x-faccpedi FOR faccpedi.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-11

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES rsm-w-report-1 rsm-w-report-2 dtl-w-report-1

/* Definitions for BROWSE BROWSE-11                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-11 rsm-w-report-1.Campo-C[1] ~
rsm-w-report-1.Campo-F[1] rsm-w-report-1.Campo-F[2] ~
rsm-w-report-1.Campo-F[3] rsm-w-report-1.Campo-C[10] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-11 
&Scoped-define QUERY-STRING-BROWSE-11 FOR EACH rsm-w-report-1 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-11 OPEN QUERY BROWSE-11 FOR EACH rsm-w-report-1 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-11 rsm-w-report-1
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-11 rsm-w-report-1


/* Definitions for BROWSE BROWSE-12                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-12 rsm-w-report-2.Campo-C[1] ~
rsm-w-report-2.Campo-F[1] rsm-w-report-2.Campo-F[2] ~
rsm-w-report-2.Campo-F[3] rsm-w-report-2.Campo-C[10] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-12 
&Scoped-define QUERY-STRING-BROWSE-12 FOR EACH rsm-w-report-2 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-12 OPEN QUERY BROWSE-12 FOR EACH rsm-w-report-2 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-12 rsm-w-report-2
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-12 rsm-w-report-2


/* Definitions for BROWSE BROWSE-14                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-14 dtl-w-report-1.Campo-C[1] ~
dtl-w-report-1.Campo-C[2] dtl-w-report-1.Campo-F[1] ~
dtl-w-report-1.Campo-F[2] dtl-w-report-1.Campo-F[3] ~
dtl-w-report-1.Campo-D[1] dtl-w-report-1.Campo-C[20] ~
dtl-w-report-1.Campo-C[21] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-14 
&Scoped-define QUERY-STRING-BROWSE-14 FOR EACH dtl-w-report-1 ~
      WHERE dtl-w-report-1.Llave-C = rsm-w-report-1.Campo-C[1] ~
/*Temp-Tables.dtl-w-report-1.Campo-C[10] = rsm-w-report-1.Campo-C[10]*/ NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-14 OPEN QUERY BROWSE-14 FOR EACH dtl-w-report-1 ~
      WHERE dtl-w-report-1.Llave-C = rsm-w-report-1.Campo-C[1] ~
/*Temp-Tables.dtl-w-report-1.Campo-C[10] = rsm-w-report-1.Campo-C[10]*/ NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-14 dtl-w-report-1
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-14 dtl-w-report-1


/* Definitions for BROWSE BROWSE-16                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-16 dtl-w-report-1.Campo-C[1] ~
dtl-w-report-1.Campo-C[2] dtl-w-report-1.Campo-F[1] ~
dtl-w-report-1.Campo-F[2] dtl-w-report-1.Campo-F[3] ~
dtl-w-report-1.Campo-D[1] dtl-w-report-1.Campo-C[20] ~
dtl-w-report-1.Campo-C[21] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-16 
&Scoped-define QUERY-STRING-BROWSE-16 FOR EACH dtl-w-report-1 ~
      WHERE dtl-w-report-1.Llave-C = rsm-w-report-2.Campo-C[1] ~
/*Temp-Tables.dtl-w-report-1.Campo-C[10] = rsm-w-report-2.Campo-C[10]*/ NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-16 OPEN QUERY BROWSE-16 FOR EACH dtl-w-report-1 ~
      WHERE dtl-w-report-1.Llave-C = rsm-w-report-2.Campo-C[1] ~
/*Temp-Tables.dtl-w-report-1.Campo-C[10] = rsm-w-report-2.Campo-C[10]*/ NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-16 dtl-w-report-1
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-16 dtl-w-report-1


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-11}~
    ~{&OPEN-QUERY-BROWSE-12}~
    ~{&OPEN-QUERY-BROWSE-14}~
    ~{&OPEN-QUERY-BROWSE-16}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-1 IMAGE-2 BROWSE-11 BROWSE-12 Btn_OK ~
Btn_Cancel BUTTON-6 BROWSE-14 BROWSE-16 BUTTON-4 BUTTON-5 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "CANCELAR" 
     SIZE 23 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Grabar la PRE-RUTA" 
     SIZE 23 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "adeicon/icfdev.ico":U
     LABEL "Unir RUTA" 
     SIZE 13.29 BY 1.54.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "adeicon/icfdevas.ico":U
     LABEL "Unir RUTA" 
     SIZE 13.29 BY 1.54.

DEFINE BUTTON BUTTON-6 
     LABEL "COPIAR REGISTRO EN BLANCO" 
     SIZE 38 BY 1.12.

DEFINE IMAGE IMAGE-1
     FILENAME "img/forward.ico":U
     SIZE 5 BY 1.35.

DEFINE IMAGE IMAGE-2
     FILENAME "img/forward.ico":U
     SIZE 5 BY 1.35.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-11 FOR 
      rsm-w-report-1 SCROLLING.

DEFINE QUERY BROWSE-12 FOR 
      rsm-w-report-2 SCROLLING.

DEFINE QUERY BROWSE-14 FOR 
      dtl-w-report-1 SCROLLING.

DEFINE QUERY BROWSE-16 FOR 
      dtl-w-report-1 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-11 D-Dialog _STRUCTURED
  QUERY BROWSE-11 NO-LOCK DISPLAY
      rsm-w-report-1.Campo-C[1] COLUMN-LABEL "Pre-Ruta" FORMAT "X(12)":U
            COLUMN-FONT 0
      rsm-w-report-1.Campo-F[1] COLUMN-LABEL "Peso" FORMAT ">>>,>>9.99":U
            COLUMN-FONT 0
      rsm-w-report-1.Campo-F[2] COLUMN-LABEL "Volumen" FORMAT ">>>,>>9.99":U
            COLUMN-FONT 0
      rsm-w-report-1.Campo-F[3] COLUMN-LABEL "Importe" FORMAT ">>,>>>,>>9.99":U
            WIDTH 13.14 COLUMN-FONT 0
      rsm-w-report-1.Campo-C[10] COLUMN-LABEL "Cuadrante" FORMAT "X(8)":U
            WIDTH 17.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 59.86 BY 7.35
         FONT 4 ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-12 D-Dialog _STRUCTURED
  QUERY BROWSE-12 NO-LOCK DISPLAY
      rsm-w-report-2.Campo-C[1] COLUMN-LABEL "Pre-Ruta" FORMAT "X(12)":U
            COLUMN-FONT 0
      rsm-w-report-2.Campo-F[1] COLUMN-LABEL "Peso" FORMAT ">>>,>>9.99":U
            WIDTH 9.86 COLUMN-FONT 0
      rsm-w-report-2.Campo-F[2] COLUMN-LABEL "Volumen" FORMAT ">>>,>>9.99":U
            COLUMN-FONT 0
      rsm-w-report-2.Campo-F[3] COLUMN-LABEL "Importe" FORMAT ">,>>>,>>9.99":U
            WIDTH 13.29 COLUMN-FONT 0
      rsm-w-report-2.Campo-C[10] COLUMN-LABEL "Cuadrante" FORMAT "X(8)":U
            WIDTH 14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 59 BY 7.35
         FONT 4 ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-14 D-Dialog _STRUCTURED
  QUERY BROWSE-14 NO-LOCK DISPLAY
      dtl-w-report-1.Campo-C[1] COLUMN-LABEL "Distrito" FORMAT "X(40)":U
            WIDTH 26.43 COLUMN-FONT 0
      dtl-w-report-1.Campo-C[2] COLUMN-LABEL "O/D" FORMAT "X(15)":U
            WIDTH 13.43 COLUMN-FONT 0
      dtl-w-report-1.Campo-F[1] COLUMN-LABEL "Peso" FORMAT ">>>,>>9.99":U
            COLUMN-FONT 0
      dtl-w-report-1.Campo-F[2] COLUMN-LABEL "Volumen" FORMAT ">>>,>>9.99":U
            WIDTH 8 COLUMN-FONT 0
      dtl-w-report-1.Campo-F[3] COLUMN-LABEL "Importe" FORMAT ">,>>>,>>9.99":U
            WIDTH 14.72 COLUMN-FONT 0
      dtl-w-report-1.Campo-D[1] COLUMN-LABEL "F.Entrega" FORMAT "99/99/9999":U
      dtl-w-report-1.Campo-C[20] COLUMN-LABEL "Nombre Cliente" FORMAT "X(50)":U
            WIDTH 28.29
      dtl-w-report-1.Campo-C[21] COLUMN-LABEL "Lugar de entrega" FORMAT "X(60)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 77 BY 15.62
         FONT 4
         TITLE "Detalle" ROW-HEIGHT-CHARS .62 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-16
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-16 D-Dialog _STRUCTURED
  QUERY BROWSE-16 NO-LOCK DISPLAY
      dtl-w-report-1.Campo-C[1] COLUMN-LABEL "Distrito" FORMAT "X(40)":U
            WIDTH 29.43 COLUMN-FONT 0
      dtl-w-report-1.Campo-C[2] COLUMN-LABEL "O/D" FORMAT "X(15)":U
            WIDTH 13.43 COLUMN-FONT 0
      dtl-w-report-1.Campo-F[1] COLUMN-LABEL "Peso" FORMAT ">>>,>>9.99":U
            COLUMN-FONT 0
      dtl-w-report-1.Campo-F[2] COLUMN-LABEL "Volumen" FORMAT ">>>,>>9.99":U
            WIDTH 8 COLUMN-FONT 0
      dtl-w-report-1.Campo-F[3] COLUMN-LABEL "Importe" FORMAT ">,>>>,>>9.99":U
            WIDTH 12.72 COLUMN-FONT 0
      dtl-w-report-1.Campo-D[1] COLUMN-LABEL "F.Entrega" FORMAT "99/99/9999":U
      dtl-w-report-1.Campo-C[20] COLUMN-LABEL "Nombre Cliente" FORMAT "X(50)":U
            WIDTH 33.43
      dtl-w-report-1.Campo-C[21] COLUMN-LABEL "Lugar de entrega" FORMAT "X(60)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 78 BY 15.62
         FONT 4
         TITLE "Detalle" ROW-HEIGHT-CHARS .62 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BROWSE-11 AT ROW 1.15 COL 2.14 WIDGET-ID 200
     BROWSE-12 AT ROW 1.15 COL 112 WIDGET-ID 300
     Btn_OK AT ROW 1.27 COL 68
     Btn_Cancel AT ROW 2.62 COL 68
     BUTTON-6 AT ROW 3.96 COL 68 WIDGET-ID 14
     BROWSE-14 AT ROW 8.81 COL 2 WIDGET-ID 400
     BROWSE-16 AT ROW 8.81 COL 93 WIDGET-ID 500
     BUTTON-4 AT ROW 13.73 COL 79.29 WIDGET-ID 4
     BUTTON-5 AT ROW 16.92 COL 79.29 WIDGET-ID 8
     "   Unir Ruta" VIEW-AS TEXT
          SIZE 13.29 BY .85 AT ROW 12.92 COL 79.29 WIDGET-ID 6
          BGCOLOR 2 FGCOLOR 15 FONT 11
     "   Pasar O/D" VIEW-AS TEXT
          SIZE 13.29 BY .85 AT ROW 16.12 COL 79.29 WIDGET-ID 10
          BGCOLOR 9 FGCOLOR 15 FONT 11
     IMAGE-1 AT ROW 3.96 COL 63 WIDGET-ID 16
     IMAGE-2 AT ROW 3.96 COL 107 WIDGET-ID 18
     SPACE(59.56) SKIP(19.91)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Modificacion de Pre-Rutas" WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: dtl-w-report-1 T "?" NO-UNDO INTEGRAL w-report
      TABLE: p-di-rutaC T "?" ? INTEGRAL DI-RutaC
      TABLE: rsm-w-report-1 T "?" NO-UNDO INTEGRAL w-report
      TABLE: rsm-w-report-2 T "?" NO-UNDO INTEGRAL w-report
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
/* BROWSE-TAB BROWSE-11 IMAGE-2 D-Dialog */
/* BROWSE-TAB BROWSE-12 BROWSE-11 D-Dialog */
/* BROWSE-TAB BROWSE-14 BUTTON-6 D-Dialog */
/* BROWSE-TAB BROWSE-16 BROWSE-14 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-11
/* Query rebuild information for BROWSE BROWSE-11
     _TblList          = "Temp-Tables.rsm-w-report-1"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.rsm-w-report-1.Campo-C[1]
"rsm-w-report-1.Campo-C[1]" "Pre-Ruta" "X(12)" "character" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.rsm-w-report-1.Campo-F[1]
"rsm-w-report-1.Campo-F[1]" "Peso" ">>>,>>9.99" "decimal" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.rsm-w-report-1.Campo-F[2]
"rsm-w-report-1.Campo-F[2]" "Volumen" ">>>,>>9.99" "decimal" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.rsm-w-report-1.Campo-F[3]
"rsm-w-report-1.Campo-F[3]" "Importe" ">>,>>>,>>9.99" "decimal" ? ? 0 ? ? ? no ? no no "13.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.rsm-w-report-1.Campo-C[10]
"rsm-w-report-1.Campo-C[10]" "Cuadrante" ? "character" ? ? ? ? ? ? no ? no no "17.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-11 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-12
/* Query rebuild information for BROWSE BROWSE-12
     _TblList          = "Temp-Tables.rsm-w-report-2"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.rsm-w-report-2.Campo-C[1]
"rsm-w-report-2.Campo-C[1]" "Pre-Ruta" "X(12)" "character" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.rsm-w-report-2.Campo-F[1]
"rsm-w-report-2.Campo-F[1]" "Peso" ">>>,>>9.99" "decimal" ? ? 0 ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.rsm-w-report-2.Campo-F[2]
"rsm-w-report-2.Campo-F[2]" "Volumen" ">>>,>>9.99" "decimal" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.rsm-w-report-2.Campo-F[3]
"rsm-w-report-2.Campo-F[3]" "Importe" ">,>>>,>>9.99" "decimal" ? ? 0 ? ? ? no ? no no "13.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.rsm-w-report-2.Campo-C[10]
"rsm-w-report-2.Campo-C[10]" "Cuadrante" ? "character" ? ? ? ? ? ? no ? no no "14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-12 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-14
/* Query rebuild information for BROWSE BROWSE-14
     _TblList          = "Temp-Tables.dtl-w-report-1"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "Temp-Tables.dtl-w-report-1.Llave-C = Temp-Tables.rsm-w-report-1.Campo-C[1]
/*Temp-Tables.dtl-w-report-1.Campo-C[10] = Temp-Tables.rsm-w-report-1.Campo-C[10]*/"
     _FldNameList[1]   > Temp-Tables.dtl-w-report-1.Campo-C[1]
"dtl-w-report-1.Campo-C[1]" "Distrito" "X(40)" "character" ? ? 0 ? ? ? no ? no no "26.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.dtl-w-report-1.Campo-C[2]
"dtl-w-report-1.Campo-C[2]" "O/D" "X(15)" "character" ? ? 0 ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.dtl-w-report-1.Campo-F[1]
"dtl-w-report-1.Campo-F[1]" "Peso" ">>>,>>9.99" "decimal" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.dtl-w-report-1.Campo-F[2]
"dtl-w-report-1.Campo-F[2]" "Volumen" ">>>,>>9.99" "decimal" ? ? 0 ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.dtl-w-report-1.Campo-F[3]
"dtl-w-report-1.Campo-F[3]" "Importe" ">,>>>,>>9.99" "decimal" ? ? 0 ? ? ? no ? no no "14.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.dtl-w-report-1.Campo-D[1]
"dtl-w-report-1.Campo-D[1]" "F.Entrega" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.dtl-w-report-1.Campo-C[20]
"dtl-w-report-1.Campo-C[20]" "Nombre Cliente" "X(50)" "character" ? ? ? ? ? ? no ? no no "28.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.dtl-w-report-1.Campo-C[21]
"dtl-w-report-1.Campo-C[21]" "Lugar de entrega" "X(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-14 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-16
/* Query rebuild information for BROWSE BROWSE-16
     _TblList          = "Temp-Tables.dtl-w-report-1"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "Temp-Tables.dtl-w-report-1.Llave-C = Temp-Tables.rsm-w-report-2.Campo-C[1]
/*Temp-Tables.dtl-w-report-1.Campo-C[10] = Temp-Tables.rsm-w-report-2.Campo-C[10]*/"
     _FldNameList[1]   > Temp-Tables.dtl-w-report-1.Campo-C[1]
"dtl-w-report-1.Campo-C[1]" "Distrito" "X(40)" "character" ? ? 0 ? ? ? no ? no no "29.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.dtl-w-report-1.Campo-C[2]
"dtl-w-report-1.Campo-C[2]" "O/D" "X(15)" "character" ? ? 0 ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.dtl-w-report-1.Campo-F[1]
"dtl-w-report-1.Campo-F[1]" "Peso" ">>>,>>9.99" "decimal" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.dtl-w-report-1.Campo-F[2]
"dtl-w-report-1.Campo-F[2]" "Volumen" ">>>,>>9.99" "decimal" ? ? 0 ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.dtl-w-report-1.Campo-F[3]
"dtl-w-report-1.Campo-F[3]" "Importe" ">,>>>,>>9.99" "decimal" ? ? 0 ? ? ? no ? no no "12.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.dtl-w-report-1.Campo-D[1]
"dtl-w-report-1.Campo-D[1]" "F.Entrega" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.dtl-w-report-1.Campo-C[20]
"dtl-w-report-1.Campo-C[20]" "Nombre Cliente" "X(50)" "character" ? ? ? ? ? ? no ? no no "33.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.dtl-w-report-1.Campo-C[21]
"dtl-w-report-1.Campo-C[21]" "Lugar de entrega" "X(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-16 */
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
ON END-ERROR OF FRAME D-Dialog /* Modificacion de Pre-Rutas */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Modificacion de Pre-Rutas */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  /*APPLY "END-ERROR":U TO SELF.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-11
&Scoped-define SELF-NAME BROWSE-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-11 D-Dialog
ON VALUE-CHANGED OF BROWSE-11 IN FRAME D-Dialog
DO:
  x-orden = "".
  {&open-query-browse-14}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-12
&Scoped-define SELF-NAME BROWSE-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-12 D-Dialog
ON VALUE-CHANGED OF BROWSE-12 IN FRAME D-Dialog
DO:
  {&open-query-browse-16}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-14
&Scoped-define SELF-NAME BROWSE-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-14 D-Dialog
ON ENTRY OF BROWSE-14 IN FRAME D-Dialog /* Detalle */
DO:
    x-orden = "".
    IF AVAILABLE dtl-w-report-1 THEN x-orden = dtl-w-report-1.campo-c[2]:SCREEN-VALUE IN BROWSE BROWSE-14.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-14 D-Dialog
ON VALUE-CHANGED OF BROWSE-14 IN FRAME D-Dialog /* Detalle */
DO:

  x-orden = "".  
  IF AVAILABLE dtl-w-report-1 THEN x-orden = dtl-w-report-1.campo-c[2]:SCREEN-VALUE IN BROWSE BROWSE-14.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* CANCELAR */
DO:

    /*RUN enviar-a-excel.*/

    pProcesado = 'NO'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Grabar la PRE-RUTA */
DO:

    DEFINE VAR x-msg AS CHAR INIT "".

    btn_ok:AUTO-GO = NO.
    MESSAGE 'Seguro de grabar el proceso?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = YES THEN DO:

        RUN grabar-pre-rutas(OUTPUT x-msg).

        pProcesado = 'NO'.
        IF x-msg = 'OK' THEN DO:
            pProcesado = 'SI'.
            btn_ok:AUTO-GO = YES.
        END.
     END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 D-Dialog
ON CHOOSE OF BUTTON-4 IN FRAME D-Dialog /* Unir RUTA */
DO:
  RUN unir-rutas.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 D-Dialog
ON CHOOSE OF BUTTON-5 IN FRAME D-Dialog /* Unir RUTA */
DO:
  RUN unir-od.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 D-Dialog
ON CHOOSE OF BUTTON-6 IN FRAME D-Dialog /* COPIAR REGISTRO EN BLANCO */
DO:
  RUN Add-New-Report2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-11
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Add-New-Report2 D-Dialog 
PROCEDURE Add-New-Report2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE rsm-w-report-1 THEN RETURN.

DEF VAR x-New-Number AS INT NO-UNDO.
DEF VAR x-Length-Number AS INT NO-UNDO.
DEF BUFFER b-report2 FOR rsm-w-report-2.
DEF BUFFER b-report1 FOR rsm-w-report-1.
DEF BUFFER b-rutac   FOR p-Di-RutaC.


FOR EACH b-report2 NO-LOCK BY b-report2.campo-c[1]:
    x-New-Number = INTEGER(b-report2.campo-c[1]) + 1.
    x-Length-Number = LENGTH(b-report2.campo-c[1]).
END.
CREATE b-report2.
ASSIGN
    b-report2.campo-c[1] = STRING(x-New-Number, FILL('9', x-Length-Number))
    b-report2.campo-c[10] = rsm-w-report-1.campo-c[10].
CREATE b-report1.
BUFFER-COPY b-report2 TO b-report1.

FIND FIRST p-Di-RutaC WHERE p-Di-RutaC.NroDoc = rsm-w-report-1.Campo-C[1] NO-LOCK NO-ERROR.
IF AVAILABLE p-Di-RutaC THEN DO:
    CREATE b-RutaC.
    BUFFER-COPY p-Di-RutaC 
        EXCEPT p-Di-RutaC.Libre_d01 p-Di-RutaC.Libre_d02 p-Di-RutaC.Libre_d03   /* Ni clientes, peso y vol */
        TO b-RutaC 
        ASSIGN b-RutaC.NroDoc = STRING(x-New-Number, FILL('9', x-Length-Number)).
END.

RELEASE b-report1.
RELEASE b-report2.
RELEASE p-Di-RutaC.

{&open-query-browse-11}
{&open-query-browse-12}
{&open-query-browse-14}
{&open-query-browse-16}
/*{&open-query-browse-18}*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-info D-Dialog 
PROCEDURE cargar-info :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

x-orden = "".

FOR EACH ppResumen NO-LOCK:
    /* Resumen */
    CREATE rsm-w-report-1.
        ASSIGN rsm-w-report-1.campo-c[1] = ppResumen.tnro-phruta
                rsm-w-report-1.campo-f[1] = ppResumen.ttotpeso
                rsm-w-report-1.campo-f[2] = ppResumen.ttotvol
                rsm-w-report-1.campo-f[3] = ppResumen.ttotimp
                rsm-w-report-1.campo-c[10] = ppResumen.tcuadrante
                rsm-w-report-1.campo-i[1] = ppResumen.ttotclie
    .
    /* Resumen */
    CREATE rsm-w-report-2.
        ASSIGN rsm-w-report-2.campo-c[1] = ppResumen.tnro-phruta
                rsm-w-report-2.campo-f[1] = ppResumen.ttotpeso
                rsm-w-report-2.campo-f[2] = ppResumen.ttotvol
                rsm-w-report-2.campo-f[3] = ppResumen.ttotimp
                rsm-w-report-2.campo-c[10] = ppResumen.tcuadrante
                rsm-w-report-2.campo-i[1] = ppResumen.ttotclie
    .
END.
FOR EACH ppDetalle, FIRST ppResumen NO-LOCK WHERE ppResumen.tcuadrante = ppDetalle.tcuadrante:
/*FOR EACH ppDetalle, FIRST ppResumen NO-LOCK WHERE ppResumen.tnro-phruta = ppDetalle.tnro-phruta:*/
    
    FIND FIRST tabdistr WHERE   tabdistr.coddepto = SUBSTRING(ppDetalle.tubigeo,1,2) AND
                                tabdistr.codprov = SUBSTRING(ppDetalle.tubigeo,3,2) AND
                                tabdistr.coddist = SUBSTRING(ppDetalle.tubigeo,5,2)
                             NO-LOCK NO-ERROR.
    CREATE dtl-w-report-1.
        ASSIGN 
                dtl-w-report-1.llave-c    = ppResumen.tnro-phruta /* OJO Llave de amarre */
                dtl-w-report-1.campo-c[1] = IF(AVAILABLE tabdistr) THEN tabdistr.nomdistr ELSE "<no existe>"
                dtl-w-report-1.campo-c[2] = ppDetalle.tcoddoc + "-" + ppDetalle.tnroped
                dtl-w-report-1.campo-f[1] = ppDetalle.ttotpeso
                dtl-w-report-1.campo-f[2] = ppDetalle.ttotvol
                dtl-w-report-1.campo-f[3] = ppDetalle.ttotimp
                dtl-w-report-1.campo-c[8] = ppDetalle.tcoddoc
                dtl-w-report-1.campo-c[9] = ppDetalle.tnroped
                dtl-w-report-1.campo-c[10] = ppDetalle.tcuadrante
                dtl-w-report-1.campo-c[20] = ""
                dtl-w-report-1.campo-c[21] = ""                
        .
    /**/
    FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                x-faccpedi.coddoc = ppDetalle.tcoddoc AND
                                x-faccpedi.nroped = ppDetalle.tnroped NO-LOCK NO-ERROR.
    IF AVAILABLE x-faccpedi THEN DO:
        ASSIGN dtl-w-report-1.campo-c[20] = x-faccpedi.nomcli
                dtl-w-report-1.campo-d[1] = x-faccpedi.fchent
                .

        FIND FIRST Gn-ClieD WHERE Gn-ClieD.CodCia = cl-CodCia AND
            Gn-ClieD.CodCli = x-faccpedi.ubigeo[3] AND
            Gn-ClieD.Sede = x-faccpedi.ubigeo[1]
            NO-LOCK NO-ERROR.
        IF AVAILABLE Gn-ClieD THEN DO:
            ASSIGN dtl-w-report-1.campo-c[21] = Gn-ClieD.dircli.
        END.

    END.
END.

END PROCEDURE.

/*
DEFINE TEMP-TABLE ppResumen
    FIELD   tcuadrante     AS  CHAR    FORMAT 'x(5)'
    FIELD   ttotclie    AS  INT     INIT 0
    FIELD   ttotpeso    AS  DEC     INIT 0
    FIELD   ttotvol     AS  DEC     INIT 0
    FIELD   ttotimp     AS  DEC     INIT 0
    FIELD   ttotord     AS  INT     INIT 0
    FIELD   tnro-phruta AS CHAR     FORMAT 'x(15)'
    FIELD   tobserva    AS CHAR     FORMAT 'x(15)'
.
DEFINE TEMP-TABLE   ppDetalle
    FIELD   tcuadrante     AS  CHAR    FORMAT 'x(5)'
    FIELD   tcoddoc     AS  CHAR    FORMAT '(5)'
    FIELD   tnroped     AS  CHAR    FORMAT 'x(15)'
    FIELD   tcodcli     AS  CHAR    FORMAT 'x(12)'
    FIELD   ttotpeso    AS  DEC     INIT 0
    FIELD   ttotvol     AS  DEC     INIT 0
    FIELD   ttotimp     AS  DEC     INIT 0
    FIELD   tubigeo     AS  CHAR    FORMAT 'x(8)'
.
*/

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
  ENABLE IMAGE-1 IMAGE-2 BROWSE-11 BROWSE-12 Btn_OK Btn_Cancel BUTTON-6 
         BROWSE-14 BROWSE-16 BUTTON-4 BUTTON-5 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enviar-a-excel D-Dialog 
PROCEDURE enviar-a-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF s-user-id = "ADMIN" THEN DO:
    DEFINE VAR hProc AS HANDLE NO-UNDO.

    RUN lib\Tools-to-excel PERSISTENT SET hProc.

    def var c-csv-file as char no-undo.
    def var c-xls-file as char no-undo. /* will contain the XLS file path created */


    c-xls-file = 'd:\xpciman\di-rutaC.xlsx'.

    run pi-crea-archivo-csv IN hProc (input  buffer p-di-rutaC:handle,
                            /*input  session:temp-directory + "file"*/ c-xls-file,
                            output c-csv-file) .

    run pi-crea-archivo-xls  IN hProc (input  buffer p-di-rutaC:handle,
                            input  c-csv-file,
                            output c-xls-file) .

    c-xls-file = 'd:\xpciman\di-rutaD.xlsx'.

    run pi-crea-archivo-csv IN hProc (input  buffer p-di-rutaD:handle,
                            /*input  session:temp-directory + "file"*/ c-xls-file,
                            output c-csv-file) .

    run pi-crea-archivo-xls  IN hProc (input  buffer p-di-rutaD:handle,
                            input  c-csv-file,
                            output c-xls-file) .


    DELETE PROCEDURE hProc.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-pre-rutas D-Dialog 
PROCEDURE grabar-pre-rutas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pProcesado AS CHAR NO-UNDO.

DEFINE VAR x-serie AS INT.
DEFINE VAR x-numero AS INT.

DEFINE VAR x-cuantos AS INT INIT 0.

SESSION:SET-WAIT-STATE("GENERAL").
pProcesado = "".
FOR EACH p-di-rutaC :
    ASSIGN p-di-rutaC.guiatransportista = "".
END.

/* Elimino las Vacias */
FOR EACH p-di-rutaC :
    FIND FIRST p-di-rutaD WHERE p-di-rutaD.coddoc = p-di-rutaC.coddoc AND 
                            p-di-rutaD.nrodoc = p-di-rutaC.nrodoc NO-ERROR.
    IF NOT AVAILABLE p-di-rutaD THEN DO:
        DELETE p-di-rutaC.
    END.
END.

CORRELATIVO:
DO TRANSACTION ON ERROR UNDO CORRELATIVO, LEAVE CORRELATIVO :
    FIND FIRST faccorre WHERE FacCorre.CodCia = s-codcia AND
                                faccorre.coddiv = s-coddiv AND
                                faccorre.coddoc = s-coddoc AND
                                faccorre.flgest = YES EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE faccorre THEN DO:
        pProcesado = "Hubo problemas para generar el Correlativo".
        UNDO CORRELATIVO, LEAVE CORRELATIVO.
    END.
    x-numero = faccorre.correlativo.
    x-serie = FacCorre.nroser.

    x-cuantos = 0.
    FOR EACH p-di-rutaC :
        /* Campo Temporal */
        ASSIGN p-di-rutaC.guiatransportista = STRING(x-serie, '999') + STRING(x-numero, '999999').

        x-numero = x-numero + 1.
        x-cuantos = x-cuantos + 1.
    END.

    ASSIGN FacCorre.Correlativo = x-numero.    
    pProcesado = "OK".
END.
RELEASE faccorre.

IF pProcesado = "OK" THEN DO:
    /* Renumero los PHR */
    FOR EACH p-di-rutaC :
        FOR EACH p-di-rutaD WHERE p-di-rutaD.coddoc = p-di-rutaC.coddoc AND 
                                    p-di-rutaD.nrodoc = p-di-rutaC.nrodoc :
            ASSIGN p-di-rutaD.nrodoc = p-di-rutaC.guiatransportista.
        END.
        ASSIGN p-di-rutaC.nrodoc = p-di-rutaC.guiatransportista.
    END.
    FOR EACH p-di-rutaC :
        ASSIGN p-di-rutaC.guiatransportista = "".
    END.

/*     RUN enviar-a-excel. */

    pProcesado = "Error grabacion de la PRE-RUTA".
    /* Grabo la PHRUTA */
    GRABA_PHRUTA:
    DO TRANSACTION ON ERROR UNDO GRABA_PHRUTA, LEAVE GRABA_PHRUTA :
        FOR EACH p-di-rutaC :
            /* Cabcera */
            CREATE di-rutaC.
                BUFFER-COPY p-di-rutaC EXCEPT nrodoc TO di-rutaC NO-ERROR.
                ASSIGN di-rutaC.nrodoc = p-di-rutaC.nrodoc NO-ERROR.

            IF ERROR-STATUS:ERROR = YES THEN DO:
                pProcesado = "Error al grabar la pre-ruta " + di-rutaC.nrodoc.
                UNDO GRABA_PHRUTA, LEAVE GRABA_PHRUTA.
            END.

            FOR EACH p-di-rutaD WHERE p-di-rutaD.coddoc = p-di-rutaC.coddoc AND 
                                        p-di-rutaD.nrodoc = p-di-rutaC.nrodoc :
                /* Detalle */
                CREATE di-rutaD.
                    BUFFER-COPY p-di-rutaD EXCEPT nrodoc TO di-rutaD NO-ERROR.
                    ASSIGN di-rutaD.nrodoc = p-di-rutaC.nrodoc NO-ERROR.

                IF ERROR-STATUS:ERROR = YES THEN DO:
                    pProcesado = "Error al grabar la pre-ruta " + di-rutaC.nrodoc + " orden " + di-rutaD.codref + "-" + di-rutaD.nroref.
                    UNDO GRABA_PHRUTA, LEAVE GRABA_PHRUTA.
                END.
            END.
        END.
        pProcesado = "OK".
    END.
END.

RELEASE di-rutaC.
RELEASE di-rutaD.

SESSION:SET-WAIT-STATE("").

IF pProcesado = "OK" THEN DO:
    MESSAGE "Se generaron " + STRING(x-cuantos) + " PRE-RUTAS" VIEW-AS ALERT-BOX INFORMATION.
END.
ELSE DO:
    MESSAGE pProcesado VIEW-AS ALERT-BOX ERROR.
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
  RUN cargar-info.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "dtl-w-report-1"}
  {src/adm/template/snd-list.i "rsm-w-report-2"}
  {src/adm/template/snd-list.i "rsm-w-report-1"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE unir-od D-Dialog 
PROCEDURE unir-od :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT AVAILABLE dtl-w-report-1 THEN DO:
    MESSAGE "No hay Pre-Rutas generadas" VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.

IF x-orden = "" THEN DO:
    MESSAGE "Seleccione una orden por favor" VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.

DEFINE VAR x-pre-ruta-1 AS CHAR.
DEFINE VAR x-pre-ruta-2 AS CHAR.
DEFINE VAR x-cuadrante-1 AS CHAR.
DEFINE VAR x-cuadrante-2 AS CHAR.

x-pre-ruta-1 = rsm-w-report-1.campo-c[1].
x-pre-ruta-2 = rsm-w-report-2.campo-c[1].
x-cuadrante-1 = rsm-w-report-1.campo-c[10].
x-cuadrante-2 = rsm-w-report-2.campo-c[10].

IF x-pre-ruta-1 = x-pre-ruta-2 THEN DO:
    MESSAGE "No puede pasar Orden al mismo numero de PRE-RUTA" VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.

MESSAGE "Esta seguro de para Orden " + x-orden + " hacia la Pre-Ruta " + x-pre-ruta-2  VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN DO:
    RETURN "ADM-ERROR".
END.

EMPTY TEMP-TABLE tt-dtl-w-report-1.

FIND FIRST dtl-w-report-1 WHERE dtl-w-report-1.llave-c = x-pre-ruta-1 AND
    /*dtl-w-report-1.campo-c[10] = rsm-w-report-1.campo-c[10] AND*/
    dtl-w-report-1.campo-c[2] = x-orden NO-ERROR.
IF NOT AVAILABLE dtl-w-report-1 THEN RETURN "ADM-ERROR".
/* Actualizo totales del DESTINO */
ASSIGN  rsm-w-report-2.campo-i[1] = rsm-w-report-2.campo-i[1] + 1       /* Ojo No de clientes*/
        rsm-w-report-2.campo-f[1] = rsm-w-report-2.campo-f[1] + dtl-w-report-1.campo-f[1]
        rsm-w-report-2.campo-f[2] = rsm-w-report-2.campo-f[2] + dtl-w-report-1.campo-f[2]
        rsm-w-report-2.campo-f[3] = rsm-w-report-2.campo-f[3] + dtl-w-report-1.campo-f[3]
.
/* Actualizo totales del ORIGEN */
ASSIGN  rsm-w-report-1.campo-i[1] = rsm-w-report-1.campo-i[1] - 1       /* Ojo No de clientes*/
        rsm-w-report-1.campo-f[1] = rsm-w-report-1.campo-f[1] - dtl-w-report-1.campo-f[1]
        rsm-w-report-1.campo-f[2] = rsm-w-report-1.campo-f[2] - dtl-w-report-1.campo-f[2]
        rsm-w-report-1.campo-f[3] = rsm-w-report-1.campo-f[3] - dtl-w-report-1.campo-f[3]
.

/* Detalle */                                
ASSIGN 
    dtl-w-report-1.llave-c = x-pre-ruta-2
    dtl-w-report-1.campo-c[10] = rsm-w-report-2.campo-c[10].

/* Actualizo los datos del browse - Origen */
FIND FIRST rsm-w-report-1 WHERE rsm-w-report-1.campo-c[1] = x-pre-ruta-2 NO-ERROR.
IF AVAILABLE rsm-w-report-1 THEN DO:
    ASSIGN rsm-w-report-1.campo-f[1] = rsm-w-report-2.campo-f[1]
            rsm-w-report-1.campo-f[2] = rsm-w-report-2.campo-f[2]
            rsm-w-report-1.campo-f[3] = rsm-w-report-2.campo-f[3]
    .    
END.

/* DI-RUTAC y DI-RUTAD */

/* Renumero el Detalle  */
FIND FIRST p-di-rutad WHERE p-di-rutad.nrodoc = x-pre-ruta-1 AND
                            p-di-rutad.codref = dtl-w-report-1.campo-c[8] AND
                            p-di-rutad.nroref = dtl-w-report-1.campo-c[9] NO-ERROR.
IF AVAILABLE p-di-rutad THEN DO:
    ASSIGN p-di-rutad.nrodoc = x-pre-ruta-2.
END.
/* Actualizo totales */
FIND FIRST p-di-rutac WHERE p-di-rutac.nrodoc = x-pre-ruta-2 NO-ERROR.
IF AVAILABLE p-di-rutaC THEN DO:
    ASSIGN  p-DI-RutaC.Libre_d01 = p-DI-RutaC.Libre_d01 + dtl-w-report-1.campo-f[1]
            p-DI-RutaC.Libre_d02 = p-DI-RutaC.Libre_d02 + dtl-w-report-1.campo-f[2]
           p-DI-RutaC.Libre_d03 = p-DI-RutaC.Libre_d03 + dtl-w-report-1.campo-f[3].
END.
        
/* Elimino Cabeceras si es que no hay detalle en el ORIGEN */
FIND FIRST p-di-rutaD WHERE p-di-rutaD.nrodoc = x-pre-ruta-1 NO-ERROR.
IF NOT AVAILABLE p-di-rutaD THEN DO:
    FIND FIRST p-di-rutac WHERE p-di-rutac.nrodoc = x-pre-ruta-1 NO-ERROR.
    IF AVAILABLE p-di-rutaC THEN DO:
        DELETE p-di-rutaC.
    END.
END.

FIND FIRST dtl-w-report-1 WHERE dtl-w-report-1.llave-c = x-pre-ruta-1 
    /* AND dtl-w-report-1.campo-c[10] = x-cuadrante-1*/ NO-ERROR.
IF NOT AVAILABLE dtl-w-report-1 THEN DO:
    /**/    
    FIND FIRST rsm-w-report-2 WHERE rsm-w-report-2.campo-c[1] = x-pre-ruta-1
        /*AND rsm-w-report-2.campo-c[10] = x-cuadrante-1*/ NO-ERROR.
    IF AVAILABLE rsm-w-report-2 THEN DO:
        DELETE rsm-w-report-2.
    END.
    FIND FIRST rsm-w-report-1 WHERE rsm-w-report-1.campo-c[1] = x-pre-ruta-1 
        /*AND rsm-w-report-1.campo-c[10] = x-cuadrante-1*/ NO-ERROR.
    IF AVAILABLE rsm-w-report-1 THEN DO:
        DELETE rsm-w-report-1.
    END.
END.

{&open-query-browse-11}
{&open-query-browse-12}
{&open-query-browse-14}
{&open-query-browse-16}
/*{&open-query-browse-18}*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE unir-rutas D-Dialog 
PROCEDURE unir-rutas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE rsm-w-report-1 THEN DO:
    MESSAGE "No hay Pre-Rutas generadas" VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
IF NOT AVAILABLE rsm-w-report-2 THEN DO:
    MESSAGE "No hay Pre-Rutas generadas" VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.

DEFINE VAR x-pre-ruta-1 AS CHAR.
DEFINE VAR x-pre-ruta-2 AS CHAR.

x-pre-ruta-1 = rsm-w-report-1.campo-c[1].
x-pre-ruta-2 = rsm-w-report-2.campo-c[1].

IF x-pre-ruta-1 = x-pre-ruta-2 THEN DO:
    MESSAGE "No puede unir Pre-Rutas con el mismo numero" VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.

MESSAGE "Esta seguro de Unir la Pre-Ruta " + x-pre-ruta-1 + " hacia la Pre-Ruta " + x-pre-ruta-2  VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN DO:
    RETURN "ADM-ERROR".
END.

EMPTY TEMP-TABLE tt-dtl-w-report-1.

SESSION:SET-WAIT-STATE("GENERAL").
/* Realizamos el Proceso */
FOR EACH rsm-w-report-1 WHERE rsm-w-report-1.campo-c[1] = x-pre-ruta-1 :
    /* Un cuadrante es una Pre-Ruta */
    FOR EACH dtl-w-report-1 WHERE dtl-w-report-1.llave-c = x-pre-ruta-1:
        /*dtl-w-report-1.campo-c[10] = rsm-w-report-1.campo-c[10] :*/
        CREATE tt-dtl-w-report-1.
            ASSIGN 
                    tt-dtl-w-report-1.campo-c[1] = dtl-w-report-1.campo-c[1]
                    tt-dtl-w-report-1.campo-c[2] = dtl-w-report-1.campo-c[2]
                    tt-dtl-w-report-1.campo-f[1] = dtl-w-report-1.campo-f[1]
                    tt-dtl-w-report-1.campo-f[2] = dtl-w-report-1.campo-f[2]
                    tt-dtl-w-report-1.campo-f[3] = dtl-w-report-1.campo-f[3]
                    tt-dtl-w-report-1.campo-c[8] = dtl-w-report-1.campo-c[8]
                    tt-dtl-w-report-1.campo-c[9] = dtl-w-report-1.campo-c[9]
                    tt-dtl-w-report-1.llave-c     = x-pre-ruta-2
                    tt-dtl-w-report-1.campo-c[10] = rsm-w-report-2.campo-c[10]     /* El cuadrante del destino */
        .
    END.
    /* Actualizo totales */
    ASSIGN  rsm-w-report-2.campo-i[1] = rsm-w-report-2.campo-i[1] + rsm-w-report-1.campo-i[1]
            rsm-w-report-2.campo-f[1] = rsm-w-report-2.campo-f[1] + rsm-w-report-1.campo-f[1]
            rsm-w-report-2.campo-f[2] = rsm-w-report-2.campo-f[2] + rsm-w-report-1.campo-f[2]
            rsm-w-report-2.campo-f[3] = rsm-w-report-2.campo-f[3] + rsm-w-report-1.campo-f[3]
    .
    DELETE rsm-w-report-1.
END.

/* Adicionar al detalle - Destino */
FOR EACH tt-dtl-w-report-1:
    CREATE dtl-w-report-1.
        BUFFER-COPY tt-dtl-w-report-1 TO dtl-w-report-1.
END.
/* Actualizo los datos del browse - Origen */
FIND FIRST rsm-w-report-1 WHERE rsm-w-report-1.campo-c[1] = x-pre-ruta-2 NO-ERROR.
IF AVAILABLE rsm-w-report-1 THEN DO:
    ASSIGN rsm-w-report-1.campo-f[1] = rsm-w-report-2.campo-f[1]
            rsm-w-report-1.campo-f[2] = rsm-w-report-2.campo-f[2]
            rsm-w-report-1.campo-f[3] = rsm-w-report-2.campo-f[3]
    .    
END.

FIND FIRST rsm-w-report-2 WHERE rsm-w-report-2.campo-c[1] = x-pre-ruta-1 NO-ERROR.
IF AVAILABLE rsm-w-report-2 THEN DO:
    DELETE rsm-w-report-2.
END.

/* DI-RUTAC y DI-RUTAD */

/* Renumero el Detalle  */
FOR EACH p-di-rutad WHERE p-di-rutad.nrodoc = x-pre-ruta-1 :
    ASSIGN p-di-rutad.nrodoc = x-pre-ruta-2.
END.
/* Actualizo totales */
FIND FIRST rsm-w-report-2 WHERE rsm-w-report-2.campo-c[1] = x-pre-ruta-2 NO-ERROR.

FIND FIRST p-di-rutac WHERE p-di-rutac.nrodoc = x-pre-ruta-2 NO-ERROR.
IF AVAILABLE p-di-rutaC THEN DO:
    ASSIGN  p-DI-RutaC.Libre_d01 = rsm-w-report-2.campo-i[1]
            p-DI-RutaC.Libre_d02 = rsm-w-report-2.campo-f[1]
           p-DI-RutaC.Libre_d03 = rsm-w-report-2.campo-f[2].
END.
/* cabecera */
FOR EACH p-di-rutaC WHERE p-di-rutaC.nrodoc = x-pre-ruta-1 :
    DELETE p-di-rutaC.
END.

{&open-query-browse-11}
{&open-query-browse-12}
{&open-query-browse-14}
{&open-query-browse-16}
/*-{&open-query-browse-18}*/

SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/*
DEFINE INPUT PARAMETER TABLE FOR ppResumen.
DEFINE INPUT PARAMETER TABLE FOR ppDetalle.
DEFINE OUTPUT PARAMETER pProcesado AS CHAR.
DEFINE INPUT PARAMETER TABLE FOR p-di-rutaC.
DEFINE INPUT PARAMETER TABLE FOR p-di-rutaD.

  
DEFINE TEMP-TABLE ppResumen
    FIELD   tcuadrante     AS  CHAR    FORMAT 'x(5)'
    FIELD   ttotclie    AS  INT     INIT 0
    FIELD   ttotpeso    AS  DEC     INIT 0
    FIELD   ttotvol     AS  DEC     INIT 0
    FIELD   ttotimp     AS  DEC     INIT 0
    FIELD   ttotord     AS  INT     INIT 0
    FIELD   tnro-phruta AS CHAR     FORMAT 'x(15)'
    FIELD   tobserva    AS CHAR     FORMAT 'x(15)'
    FIELD   tswok       AS CHAR     FORMAT 'x(1)' INIT ""
.
DEFINE TEMP-TABLE   ppDetalle
    FIELD   tcuadrante     AS  CHAR    FORMAT 'x(5)'
    FIELD   tcoddoc     AS  CHAR    FORMAT '(5)'
    FIELD   tnroped     AS  CHAR    FORMAT 'x(15)'
    FIELD   tcodcli     AS  CHAR    FORMAT 'x(12)'
    FIELD   ttotpeso    AS  DEC     INIT 0
    FIELD   ttotvol     AS  DEC     INIT 0
    FIELD   ttotimp     AS  DEC     INIT 0
    FIELD   tubigeo     AS  CHAR    FORMAT 'x(8)'
    
    
CREATE rsm-w-report-2.
    ASSIGN rsm-w-report-2.campo-c[1] = ppResumen.tnro-phruta
            rsm-w-report-2.campo-f[1] = ppResumen.ttotpeso
            rsm-w-report-2.campo-f[2] = ppResumen.ttotvol
            rsm-w-report-2.campo-f[3] = ppResumen.ttotimp
            rsm-w-report-2.campo-c[10] = ppResumen.tcuadrante
    .
    CREATE dtl-w-report-1.
        ASSIGN dtl-w-report-1.campo-c[1] = IF(AVAILABLE tabdistr) THEN tabdistr.nomdistr ELSE "<no existe>"
                dtl-w-report-1.campo-c[2] = ppDetalle.tcoddoc + "-" + ppDetalle.tnroped
                dtl-w-report-1.campo-f[1] = ppDetalle.ttotpeso
                dtl-w-report-1.campo-f[2] = ppDetalle.ttotvol
                dtl-w-report-1.campo-f[3] = ppDetalle.ttotimp
                dtl-w-report-1.campo-c[10] = ppDetalle.tcuadrante
    
  
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

