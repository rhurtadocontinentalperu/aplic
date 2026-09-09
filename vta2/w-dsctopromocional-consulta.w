&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-w-report NO-UNDO LIKE w-report
       fields iprec_soles as dec.



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

define var x-sort-direccion as char init "".
define var x-sort-column as char init "".


DEFINE TEMP-TABLE tt-excel
    FIELD   tt-ctienda      AS  CHAR FORMAT 'x(6)'      COLUMN-LABEL "Cod.Tienda"
    FIELD   tt-dtienda      AS  CHAR FORMAT 'x(60)'     COLUMN-LABEL "Nombre de Tienda"
    FIELD   tt-codmat       AS  CHAR FORMAT 'x(6)'      COLUMN-LABEL "Cod.Articulo"
    FIELD   tt-desmat       AS  CHAR FORMAT 'x(60)'     COLUMN-LABEL "Nombre articulo"
    FIELD   tt-marca        AS  CHAR FORMAT 'x(50)'     COLUMN-LABEL "Marca"
    FIELD   tt-um           AS  CHAR FORMAT 'x(6)'      COLUMN-LABEL "U.M."
    FIELD   tt-clasf        AS  CHAR FORMAT 'x(15)'     COLUMN-LABEL "Clasificacion(G-U-M)"
    FIELD   tt-precio       AS  DEC FORMAT '->>,>>9.9999'   COLUMN-LABEL "Precio"
    FIELD   tt-dscto        AS  DEC FORMAT '->>,>>9.9999'   COLUMN-LABEL "% Dscto"
    FIELD   tt-finicio      AS  DATE    COLUMN-LABEL "Fecha de Inicio"
    FIELD   tt-ftermino     AS  DATE    COLUMN-LABEL "Fecha de Termino"
    FIELD   tt-familia      AS  CHAR    FORMAT 'x(80)'  COLUMN-LABEL "Familia".

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
&Scoped-define INTERNAL-TABLES Almtfami GN-DIVI tt-w-report

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 Almtfami.codfam Almtfami.desfam 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH Almtfami ~
      WHERE almtfami.codcia = s-codcia and almtfami.swcomercial = yes NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH Almtfami ~
      WHERE almtfami.codcia = s-codcia and almtfami.swcomercial = yes NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 Almtfami
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 Almtfami


/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 GN-DIVI.CodDiv GN-DIVI.DesDiv 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH GN-DIVI ~
      WHERE gn-divi.codcia = s-codcia and  ~
gn-divi.campo-log[1] = no and ~
gn-divi.campo-log[5] = no NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH GN-DIVI ~
      WHERE gn-divi.codcia = s-codcia and  ~
gn-divi.campo-log[1] = no and ~
gn-divi.campo-log[5] = no NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 GN-DIVI
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 GN-DIVI


/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 tt-w-report.Campo-C[1] ~
tt-w-report.Campo-C[2] tt-w-report.Campo-C[3] tt-w-report.Campo-C[4] ~
tt-w-report.Campo-C[5] tt-w-report.Campo-C[6] tt-w-report.Campo-C[7] ~
tt-w-report.Campo-F[1] tt-w-report.Campo-F[2] tt-w-report.Campo-D[1] ~
tt-w-report.Campo-D[2] tt-w-report.Campo-C[8] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH tt-w-report NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH tt-w-report NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 tt-w-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-3}~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-3 BROWSE-2 BUTTON-16 BUTTON-14 ~
txtVigenciaDesde txtVigenciaHasta BUTTON-13 BROWSE-4 BUTTON-15 
&Scoped-Define DISPLAYED-OBJECTS txtTotItems txtVigenciaDesde ~
txtVigenciaHasta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-13 
     LABEL "CONSULTAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-14 
     LABEL "Toda las Familias" 
     SIZE 17 BY 1.12.

DEFINE BUTTON BUTTON-15 
     LABEL "Toda las Tiendas" 
     SIZE 17 BY 1.12.

DEFINE BUTTON BUTTON-16 
     LABEL "Excel" 
     SIZE 12.29 BY 1.12.

DEFINE VARIABLE txtTotItems AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Total Items" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE txtVigenciaDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Vigencia de PROMOCION inicien DESDE" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtVigenciaHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "HASTA" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      Almtfami SCROLLING.

DEFINE QUERY BROWSE-3 FOR 
      GN-DIVI SCROLLING.

DEFINE QUERY BROWSE-4 FOR 
      tt-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      Almtfami.codfam FORMAT "X(3)":U WIDTH 7.14
      Almtfami.desfam FORMAT "X(30)":U WIDTH 55.86 COLUMN-FONT 4 LABEL-FONT 0
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 66.72 BY 5.19 ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      GN-DIVI.CodDiv FORMAT "XX-XXX":U LABEL-FONT 0
      GN-DIVI.DesDiv FORMAT "X(40)":U WIDTH 55.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 66 BY 4.62 ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      tt-w-report.Campo-C[1] COLUMN-LABEL "Cod.Tda" FORMAT "X(6)":U
            WIDTH 6.72 COLUMN-FONT 0 LABEL-FONT 0
      tt-w-report.Campo-C[2] COLUMN-LABEL "Tienda" FORMAT "X(50)":U
            WIDTH 24.29 COLUMN-FONT 0 LABEL-FONT 0
      tt-w-report.Campo-C[3] COLUMN-LABEL "Cod.Art" FORMAT "X(8)":U
            COLUMN-FONT 0 LABEL-FONT 0
      tt-w-report.Campo-C[4] COLUMN-LABEL "Descripcion Articulo" FORMAT "X(60)":U
            WIDTH 35.72 COLUMN-FONT 0 LABEL-FONT 0
      tt-w-report.Campo-C[5] COLUMN-LABEL "Marca" FORMAT "X(30)":U
            WIDTH 14.86 COLUMN-FONT 0 LABEL-FONT 0
      tt-w-report.Campo-C[6] COLUMN-LABEL "U.M." FORMAT "X(5)":U
            COLUMN-FONT 0 LABEL-FONT 0
      tt-w-report.Campo-C[7] COLUMN-LABEL "G-U-M" FORMAT "X(10)":U
            WIDTH 8.86 COLUMN-FONT 0 LABEL-FONT 0
      tt-w-report.Campo-F[1] COLUMN-LABEL "Precio Promo" FORMAT "->>>,>>>,>>9.9999":U
            WIDTH 12.86 COLUMN-BGCOLOR 14 COLUMN-FONT 0 LABEL-FGCOLOR 0 LABEL-BGCOLOR 14 LABEL-FONT 0
      tt-w-report.Campo-F[2] COLUMN-LABEL "%Dscto Promo" FORMAT ">>9.9999":U
            WIDTH 12.43 COLUMN-FONT 0 LABEL-FONT 0
      tt-w-report.Campo-D[1] COLUMN-LABEL "Inicio Promo" FORMAT "99/99/9999":U
            COLUMN-FONT 0 LABEL-FONT 0
      tt-w-report.Campo-D[2] COLUMN-LABEL "Fin Promo" FORMAT "99/99/9999":U
            COLUMN-FONT 0 LABEL-FONT 0
      tt-w-report.Campo-C[8] COLUMN-LABEL "Familia" FORMAT "X(40)":U
            WIDTH 25.29 COLUMN-FONT 0 LABEL-FONT 0
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 124.29 BY 12.69 ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-3 AT ROW 7.88 COL 2 WIDGET-ID 300
     BROWSE-2 AT ROW 2.42 COL 1.57 WIDGET-ID 200
     txtTotItems AT ROW 11.58 COL 101 COLON-ALIGNED WIDGET-ID 20
     BUTTON-16 AT ROW 1.19 COL 105 WIDGET-ID 16
     BUTTON-14 AT ROW 5.04 COL 70 WIDGET-ID 12
     txtVigenciaDesde AT ROW 1.19 COL 39 COLON-ALIGNED WIDGET-ID 6
     txtVigenciaHasta AT ROW 1.19 COL 63 COLON-ALIGNED WIDGET-ID 8
     BUTTON-13 AT ROW 1.23 COL 83 WIDGET-ID 10
     BROWSE-4 AT ROW 12.73 COL 1.72 WIDGET-ID 400
     BUTTON-15 AT ROW 10.23 COL 70 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 126.43 BY 24.73 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-w-report T "?" NO-UNDO INTEGRAL w-report
      ADDITIONAL-FIELDS:
          fields iprec_soles as dec
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Consulta de Promociones"
         HEIGHT             = 24.73
         WIDTH              = 126.43
         MAX-HEIGHT         = 24.73
         MAX-WIDTH          = 147.57
         VIRTUAL-HEIGHT     = 24.73
         VIRTUAL-WIDTH      = 147.57
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
/* BROWSE-TAB BROWSE-2 BROWSE-3 F-Main */
/* BROWSE-TAB BROWSE-4 BUTTON-13 F-Main */
ASSIGN 
       BROWSE-4:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 3
       BROWSE-4:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* SETTINGS FOR FILL-IN txtTotItems IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.Almtfami"
     _Options          = "NO-LOCK"
     _Where[1]         = "almtfami.codcia = s-codcia and almtfami.swcomercial = yes"
     _FldNameList[1]   > INTEGRAL.Almtfami.codfam
"Almtfami.codfam" ? ? "character" ? ? ? ? ? ? no ? no no "7.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almtfami.desfam
"Almtfami.desfam" ? ? "character" ? ? 4 ? ? 0 no ? no no "55.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "INTEGRAL.GN-DIVI"
     _Options          = "NO-LOCK"
     _Where[1]         = "gn-divi.codcia = s-codcia and 
gn-divi.campo-log[1] = no and
gn-divi.campo-log[5] = no"
     _FldNameList[1]   > INTEGRAL.GN-DIVI.CodDiv
"GN-DIVI.CodDiv" ? ? "character" ? ? ? ? ? 0 no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.GN-DIVI.DesDiv
"GN-DIVI.DesDiv" ? ? "character" ? ? ? ? ? ? no ? no no "55.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-C[1]
"tt-w-report.Campo-C[1]" "Cod.Tda" "X(6)" "character" ? ? 0 ? ? 0 no ? no no "6.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[2]
"tt-w-report.Campo-C[2]" "Tienda" "X(50)" "character" ? ? 0 ? ? 0 no ? no no "24.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-C[3]
"tt-w-report.Campo-C[3]" "Cod.Art" ? "character" ? ? 0 ? ? 0 no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report.Campo-C[4]
"tt-w-report.Campo-C[4]" "Descripcion Articulo" "X(60)" "character" ? ? 0 ? ? 0 no ? no no "35.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-w-report.Campo-C[5]
"tt-w-report.Campo-C[5]" "Marca" "X(30)" "character" ? ? 0 ? ? 0 no ? no no "14.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-w-report.Campo-C[6]
"tt-w-report.Campo-C[6]" "U.M." "X(5)" "character" ? ? 0 ? ? 0 no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-w-report.Campo-C[7]
"tt-w-report.Campo-C[7]" "G-U-M" "X(10)" "character" ? ? 0 ? ? 0 no ? no no "8.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-w-report.Campo-F[1]
"tt-w-report.Campo-F[1]" "Precio Promo" ? "decimal" 14 ? 0 14 0 0 no ? no no "12.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-w-report.Campo-F[2]
"tt-w-report.Campo-F[2]" "%Dscto Promo" ">>9.9999" "decimal" ? ? 0 ? ? 0 no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-w-report.Campo-D[1]
"tt-w-report.Campo-D[1]" "Inicio Promo" ? "date" ? ? 0 ? ? 0 no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tt-w-report.Campo-D[2]
"tt-w-report.Campo-D[2]" "Fin Promo" ? "date" ? ? 0 ? ? 0 no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.tt-w-report.Campo-C[8]
"tt-w-report.Campo-C[8]" "Familia" "X(40)" "character" ? ? 0 ? ? 0 no ? no no "25.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Consulta de Promociones */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Consulta de Promociones */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
&Scoped-define SELF-NAME BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 W-Win
ON START-SEARCH OF BROWSE-4 IN FRAME F-Main
DO:
    DEFINE VARIABLE hSortColumn AS WIDGET-HANDLE.
    DEFINE VAR lColumName AS CHAR.
    DEFINE VAR hQueryHandle AS HANDLE NO-UNDO.

    hSortColumn = BROWSE BROWSE-4:CURRENT-COLUMN.
    lColumName = hSortColumn:NAME.
    lColumName = TRIM(REPLACE(lColumName," no","")).

    CASE LOWER(hSortColumn:LABEL):
        WHEN "cod.tda" THEN lColumName = "campo-c[1]".
        WHEN "tienda" THEN lColumName = "campo-c[2]".
        WHEN "cod.art" THEN lColumName = "campo-c[3]".
        WHEN "descripcion articulo" THEN lColumName = "campo-c[4]".
        WHEN "marca" THEN lColumName = "campo-c[5]".
        WHEN "u.m." THEN lColumName = "campo-c[6]".
        WHEN "g-u-m" THEN lColumName = "campo-c[7]".
        WHEN "familia" THEN lColumName = "campo-c[8]".
        WHEN "precio promo" THEN lColumName = "campo-f[1]".
        WHEN "%dscto promo" THEN lColumName = "campo-f[2]".
        WHEN "inicio promo" THEN lColumName = "campo-d[1]".
        WHEN "fin promo" THEN lColumName = "campo-d[2]".
        OTHERWISE 
            RETURN.
    END CASE.

    /*MESSAGE hSortColumn:LABEL.*/

    IF CAPS(lColumName) <> CAPS(x-sort-column) THEN DO:
        x-sort-direccion = "".
    END.
    ELSE DO:
        IF x-sort-direccion = "" THEN DO:
            x-sort-direccion = "DESC".
        END.
        ELSE DO:            
            x-sort-direccion = "".
        END.
    END.
    x-sort-column = lColumName.


    hQueryHandle = BROWSE BROWSE-4:QUERY.
    hQueryHandle:QUERY-CLOSE().
    
    hQueryHandle:QUERY-PREPARE("FOR EACH tt-w-report NO-LOCK BY " + lColumName + " " + x-sort-direccion).
    hQueryHandle:QUERY-OPEN().
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-13 W-Win
ON CHOOSE OF BUTTON-13 IN FRAME F-Main /* CONSULTAR */
DO:
  ASSIGN txtVigenciaDesde txtVigenciahasta.

  IF txtVigenciaDesde > txtVigenciaHasta THEN DO:
      MESSAGE "Vigencias estan erradas!".
      RETURN NO-APPLY.
  END.

  RUN procesa-promociones.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-14 W-Win
ON CHOOSE OF BUTTON-14 IN FRAME F-Main /* Toda las Familias */
DO:
  SESSION:SET-WAIT-STATE('GENERAL').
  IF BUTTON-14:LABEL = 'Toda las Familias' THEN DO:
     BROWSE-2:SELECT-ALL().
     BUTTON-14:LABEL IN FRAME {&FRAME-NAME} = 'Ninguna Familia'.
  END.
  ELSE DO:
        BROWSE-2:DESELECT-ROWS().
        BUTTON-14:LABEL IN FRAME {&FRAME-NAME} = 'Toda las Familias'.
  END.
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-15
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-15 W-Win
ON CHOOSE OF BUTTON-15 IN FRAME F-Main /* Toda las Tiendas */
DO:
    /* */
    IF BUTTON-15:LABEL = 'Toda las Tiendas' THEN DO:
       BUTTON-15:LABEL IN FRAME {&FRAME-NAME} = 'Ninguna Tienda'.
       BROWSE-3:SELECT-ALL().
    END.
    ELSE DO:
          BROWSE-3:DESELECT-ROWS().
          BUTTON-15:LABEL IN FRAME {&FRAME-NAME} = 'Toda las Tiendas'.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-16
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-16 W-Win
ON CHOOSE OF BUTTON-16 IN FRAME F-Main /* Excel */
DO: 

RUN enviar-excel.

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

  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

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
  DISPLAY txtTotItems txtVigenciaDesde txtVigenciaHasta 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-3 BROWSE-2 BUTTON-16 BUTTON-14 txtVigenciaDesde 
         txtVigenciaHasta BUTTON-13 BROWSE-4 BUTTON-15 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enviar-excel W-Win 
PROCEDURE enviar-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-archivo AS CHAR.
DEFINE VAR rpta AS LOG.

SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Excel (*.xlsx)' '*.xlsx'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.xlsx'
    RETURN-TO-START-DIR
    SAVE-AS
    TITLE 'Exportar a Excel'
    UPDATE rpta.
IF rpta = NO OR x-Archivo = '' THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').

EMPTY TEMP-TABLE tt-excel.

FOR EACH tt-w-report :
    CREATE tt-excel.
        ASSIGN tt-ctienda   = tt-w-report.campo-c[1]
                tt-dtienda   = tt-w-report.campo-c[2]
                tt-codmat   = tt-w-report.campo-c[3]
                tt-desmat   = tt-w-report.campo-c[4]
                tt-marca   = tt-w-report.campo-c[5]
                tt-um   = tt-w-report.campo-c[6]
                tt-clasf   = tt-w-report.campo-c[7]
                tt-precio   = tt-w-report.campo-f[1]
                tt-dscto   = tt-w-report.campo-f[2]
                tt-finicio   = tt-w-report.campo-d[1]
                tt-ftermino   = tt-w-report.campo-d[2]
                tt-familia   = tt-w-report.campo-c[8].

END.

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */


c-xls-file = x-archivo.

run pi-crea-archivo-csv IN hProc (input  buffer tt-excel:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-excel:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.

SESSION:SET-WAIT-STATE('').

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
  txtVigenciaDESDE:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 30,"99/99/9999") .
  txtVigenciaHASTA:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-promociones W-Win 
PROCEDURE procesa-promociones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lFamilias AS CHAR.
DEFINE VAR lTiendas AS CHAR.
DEFINE VAR lComa AS CHAR.
DEFINE VAR lQFamilias AS INT INIT 0.
DEFINE VAR lQTiendas AS INT INIT 0.
DEFINE VAR iCont AS INT.
DEFINE VAR lFiler AS CHAR.
DEFINE VAR lCanalVenta AS CHAR.

DEFINE VAR lTotItems AS INT.

SESSION:SET-WAIT-STATE('GENERAL').

lQFamilias = BROWSE-2:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}.
lQTiendas = BROWSE-3:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}.

lFamilias = "".
lTiendas = "".

lComa = "".
DO WITH FRAME {&FRAME-NAME}:
    DO iCont = 1 TO lQFamilias :
        IF BROWSE-2:FETCH-SELECTED-ROW(icont) THEN DO:
            lFiler = Almtfami.Codfam.
            lFamilias = lFamilias + lComa + lFiler.
            lComa = ",".
        END.
    END.    
    IF lQFamilias <= 0 THEN DO:
        lComa = "".
        GET FIRST BROWSE-2.
        DO  WHILE AVAILABLE almtfami:
            lFiler = Almtfami.Codfam.
            lFamilias = lFamilias + lComa + lFiler.
            lComa = ",".

            GET NEXT BROWSE-2.
        END.
    END.

    lComa = "".
    DO iCont = 1 TO lQTiendas :
        IF BROWSE-3:FETCH-SELECTED-ROW(icont) THEN DO:
            lFiler = gn-divi.Coddiv.
            lTiendas = lTiendas + lComa + lFiler.
            lComa = ",".
        END.
    END.
    IF lQTiendas <= 0 THEN DO:
        lComa = "".
        GET FIRST BROWSE-3.
        DO  WHILE AVAILABLE gn-divi:
            lFiler = gn-divi.Coddiv.
            lTiendas = lTiendas + lComa + lFiler.
            lComa = ",".

            GET NEXT BROWSE-3.
        END.
    END.
END.

DEFINE BUFFER b-gn-divi FOR gn-divi.
DEFINE BUFFER b-almtfami FOR almtfami.

DEFINE VAR lRnkVta AS CHAR.

EMPTY TEMP-TABLE tt-w-report.

lTotItems = 0.
FOR EACH VtaDctoProm NO-LOCK WHERE VtaDctoProm.CodCia = s-CodCia 
    AND VtaDctoProm.FchIni >= txtVigenciaDesde
    AND VtaDctoProm.FchFin <= txtVigenciaHasta:
    IF lTiendas = "" OR LOOKUP(VtaDctoProm.CodDiv,lTiendas) > 0 THEN DO:
        FIND FIRST b-gn-divi WHERE b-gn-divi.codcia = s-codcia AND 
                                b-gn-divi.coddiv = VtaDctoProm.CodDiv NO-LOCK NO-ERROR.
        FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                                factabla.tabla = 'RANKVTA' AND
                                factabla.codigo = VtaDctoProm.CodMat NO-LOCK NO-ERROR.
        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                            almmmatg.codmat = VtaDctoProm.CodMat NO-LOCK NO-ERROR.
        IF AVAILABLE almmmatg THEN DO:
            IF lFamilias = "" OR LOOKUP(almmmatg.codfam,lFamilias) > 0 THEN DO:
                lRnkVta = " -  -  ".
                IF AVAILABLE factabla THEN DO:
                    lRnkvta = factabla.campo-c[1] + " - " + factabla.campo-c[2] + " - " + factabla.campo-c[3].
                END.

                FIND FIRST almtfami OF almmmatg NO-LOCK NO-ERROR.

                CREATE tt-w-report.
                ASSIGN  tt-w-report.campo-c[1] = VtaDctoProm.CodDiv
                        tt-w-report.campo-c[2] = IF(AVAILABLE b-gn-divi) THEN b-gn-divi.desdiv ELSE ""
                        tt-w-report.campo-c[3] = VtaDctoProm.CodMat
                        tt-w-report.campo-c[4] = almmmatg.desmat
                        tt-w-report.campo-c[5] = almmmatg.desmar
                        tt-w-report.campo-c[6] = almmmatg.CHR__01
                        tt-w-report.campo-c[7] = lRnkVta
                        tt-w-report.campo-c[8] = IF(AVAILABLE almtfami) THEN almtfami.desfam ELSE VtaDctoProm.CodMat
                        tt-w-report.campo-f[1] = VtaDctoProm.Precio * (IF(almmmatg.monvta = 2) THEN almmmatg.tpocmb ELSE 1)
                        tt-w-report.campo-f[2] = VtaDctoProm.Descuento
                        tt-w-report.campo-d[1] = VtaDctoProm.FchIni
                        tt-w-report.campo-d[2] = VtaDctoProm.FchFin.
                lTotItems = lTotItems + 1.
            END.
        END.
    END.
END.

{&OPEN-QUERY-BROWSE-4}

txtTotItems:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(lTotItems,">>,>>>,>>9").

SESSION:SET-WAIT-STATE('').

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
  {src/adm/template/snd-list.i "GN-DIVI"}
  {src/adm/template/snd-list.i "Almtfami"}

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

