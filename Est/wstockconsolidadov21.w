&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          estavtas         PROGRESS
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
CREATE WIDGET-POOL.
/* ***************************  Definitions  ************************** */
/* Parameters Definitions ---                                           */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.

/* Local Variable Definitions ---                                       */
DEF NEW SHARED VAR input-var-1 AS CHAR.
DEF NEW SHARED VAR input-var-2 AS CHAR.
DEF NEW SHARED VAR input-var-3 AS CHAR.
DEF NEW SHARED VAR output-var-1 AS ROWID.
DEF NEW SHARED VAR output-var-2 AS CHAR.
DEF NEW SHARED VAR output-var-3 AS CHAR.

DEF TEMP-TABLE tt-txt
    FIELD Codigo AS CHAR FORMAT 'x(15)'.

DEF TEMP-TABLE tt-DimProducto LIKE integral.Almmmatg.

/*
    FIELD CHR__02           AS CHAR LABEL "Propio/Tercero"
    FIELD Volumen AS DEC FORMAT '>>>,>>9.9999' DECIMALS 4 LABEL 'VOLUMEN cm3'
    FIELD Peso    AS DEC FORMAT '>>>,>>9.9999' DECIMALS 4 LABEL 'PESO UNITARIO kg'
*/
DEF TEMP-TABLE Detalle NO-UNDO LIKE Almacen_Stocks 
    FIELD StkMaximo         AS DEC LABEL "Stk Maximo" INIT 0
    FIELD StkSeguridad      AS DEC LABEL "Stk Seguridad" INIT 0
    FIELD StkMax_Seg        AS DEC LABEL "Stk Maximo + Seguridad" INIT 0
    FIELD StkMaxCampa       AS DEC LABEL "Stk Maximo Campaña" INIT 0
    FIELD StkMaxNoCampa     AS DEC LABEL "Stk Maximo NoCampaña" INIT 0
    FIELD QEmpaque          AS DEC LABEL "Empaque" INIT 0
    FIELD CampClasifGral    AS CHAR     LABEL 'CAMPAÑA CLASIF GENERAL'
    FIELD CampRankingGral   AS INT64    LABEL 'CAMPAÑA RANKING GENERAL'
    FIELD CampClasifUtilex  AS CHAR     LABEL 'CAMPAÑA CLASIF UTILEX'
    FIELD CampRankingUtilex AS INT64    LABEL 'CAMPAÑA RANKING UTILEX'
    FIELD CampClasifMayo    AS CHAR     LABEL 'CAMPAÑA CLASIF MAYORISTA'
    FIELD CampRankingMayo   AS INT64    LABEL 'CAMPAÑA RANKING MAYORISTA'
    FIELD NoCampClasifGral    AS CHAR     LABEL 'NO CAMPAÑA CLASIF GENERAL'
    FIELD NoCampRankingGral   AS INT64    LABEL 'NO CAMPAÑA RANKING GENERAL'
    FIELD NoCampClasifUtilex  AS CHAR     LABEL 'NO CAMPAÑA CLASIF UTILEX'
    FIELD NoCampRankingUtilex AS INT64    LABEL 'NO CAMPAÑA RANKING UTILEX'
    FIELD NoCampClasifMayo    AS CHAR     LABEL 'NO CAMPAÑA CLASIF MAYORISTA'
    FIELD NoCampRankingMayo   AS INT64    LABEL 'NO CAMPAÑA RANKING MAYORISTA'
    FIELD Ean13 AS CHAR FORMAT 'x(15)' LABEL 'EAN 13'
    FIELD Ean14-1 AS CHAR FORMAT 'x(15)' LABEL 'EAN 14'
    FIELD Ean14-1e AS DEC FORMAT '>>>>>9.9999' DECIMALS 4 LABEL 'EQUIVALENCIA'
    FIELD Ean14-2 AS CHAR FORMAT 'x(15)' LABEL 'EAN 14'
    FIELD Ean14-2e AS DEC FORMAT '>>>>>9.9999' DECIMALS 4 LABEL 'EQUIVALENCIA'
    FIELD Ean14-3 AS CHAR FORMAT 'x(15)' LABEL 'EAN 14'
    FIELD Ean14-3e AS DEC FORMAT '>>>>>9.9999' DECIMALS 4 LABEL 'EQUIVALENCIA'
    FIELD Ean14-4 AS CHAR FORMAT 'x(15)' LABEL 'EAN 14'
    FIELD Ean14-4e AS DEC FORMAT '>>>>>9.9999' DECIMALS 4 LABEL 'EQUIVALENCIA'
    FIELD Ean14-5 AS CHAR FORMAT 'x(15)' LABEL 'EAN 14'
    FIELD Ean14-5e AS DEC FORMAT '>>>>>9.9999' DECIMALS 4 LABEL 'EQUIVALENCIA'
    FIELD flgcomercial AS CHAR FORMAT 'x(60)' LABEL "Indice Comercial"
    .
   

/* Excel para Abastecimiento (M.Ramos)  */
DEFINE TEMP-TABLE tt-abastece
    FIELD   tcodalm     AS  CHAR FORMAT 'x(6)'   COLUMN-LABEL "CodAlm"
    FIELD   tDesalm     AS  CHAR FORMAT 'x(60)'  COLUMN-LABEL "Desc. almacen"
    FIELD   tcodmat     AS  CHAR FORMAT 'x(6)'   COLUMN-LABEL "Cod Producto"
    FIELD   tdesmat     AS  CHAR FORMAT 'x(60)'  COLUMN-LABEL "Des Producto"
    FIELD   tcodmar     as  char FORMAT '(5)'    COLUMN-LABEL "Cod. Marca"
    FIELD   tdesmar     AS  char FORMAT 'x(60)'  COLUMN-LABEL "Des. Marca"
    FIELD   tcodlinea   AS  CHAR FORMAT 'x(5)'   COLUMN-LABEL "Cod. Linea"
    FIELD   tdeslinea   AS  CHAR FORMAT 'x(60)'  COLUMN-LABEL "Des. Linea"
    FIELD   tcodslinea   AS  CHAR FORMAT 'x(5)'   COLUMN-LABEL "Cod. Sub-Linea"
    FIELD   tdesslinea   AS  CHAR FORMAT 'x(60)'  COLUMN-LABEL "Des. Sub-Linea"
    FIELD   tcodprov    AS  CHAR FORMAT 'x(11)'     COLUMN-LABEL "Cod.Proveedor"
    FIELD   tdesprov    AS  CHAR FORMAT 'x(60)'     COLUMN-LABEL "Des. Proveedor"
    FIELD   tum         AS  CHAR FORMAT 'x(5)'  COLUMN-LABEL "Unidad"
    FIELD   tstkfis     AS  DEC FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Stock Fisico"
    FIELD   tstkcomp    AS  DEC FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Comprometido"
    FIELD   tstkdisp    AS  DEC FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Stock Disponible"
    FIELD   tcostrepo   AS  DEC FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Costo Repo"
    FIELD   tcostprom   AS  DEC FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Costo Prom"
    FIELD   tvol        AS  DEC FORMAT '->>,>>9.9999'   COLUMN-LABEL "Volumen cm3"
    FIELD   tpeso       AS  DEC FORMAT '->>,>>9.9999'   COLUMN-LABEL "Peso Uni. Kg"
    FIELD   ttipoalm    AS  CHAR FORMAT 'x(15)'  COLUMN-LABEL "Tipo Alm"
    FIELD   talmrema    AS  CHAR    FORMAT 'x(5)' COLUMN-LABEL "Alm Remate"
    FIELD   talmcom     AS  CHAR    FORMAT 'x(5)'   COLUMN-LABEL "Alm Comercial"
    FIELD   tcoddiv     AS  CHAR    FORMAT 'x(10)'  COLUMN-LABEL "Division"
    FIELD   testado     AS  CHAR    FORMAT 'x(3)'   COLUMN-LABEL "Estado"
    FIELD   talms       AS  INT FORMAT '>>9'    COLUMN-LABEL "Almacenes"
    FIELD   tcatcont    AS  CHAR    FORMAT 'x(5)'   COLUMN-LABEL "Cat.Contable"
    FIELD   ttraxrec    AS  DEC FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Transito x Transferencias"
    FIELD   tcomxrec    AS  DEC FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Transito x Compras"
    FIELD   tproter     AS  CHAR    FORMAT 'x(3)'   COLUMN-LABEL "Propio/Tercero"
    FIELD   tstkmax     AS  DEC FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Stk Maximo"
    FIELD   tstkseg     AS  DEC FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Stk Seguridad"
    FIELD   tmaxseg     AS  DEC FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Stk Maximi + Seguridad"
    FIELD   tstkmaxcam  AS  DEC FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Stk Maximo Campaña"
    FIELD   tstkmaxncam AS  DEC FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Stk Maximo NoCampaña"
    FIELD   temprepo    AS  DEC FORMAT '->>,>>9.99' COLUMN-LABEL "Empaque Reposicion"
    FIELD   tempinn     AS  DEC FORMAT '->>,>>9.99' COLUMN-LABEL "Empaque Inner"
    FIELD   tempmas     AS  DEC FORMAT '->>,>>9.99' COLUMN-LABEL "Emapque Master"
    FIELD   tclsgrlcam  AS  CHAR    FORMAT 'x(3)'   COLUMN-LABEL "Campaña Clasf General"
    FIELD   tclsuticam  AS  CHAR    FORMAT 'x(3)'   COLUMN-LABEL "Campaña Clasf Utilex"
    FIELD   tclsmaycam  AS  CHAR    FORMAT 'x(3)'   COLUMN-LABEL "Campaña Clasf Mayorista"
    FIELD   tclsgrlncam AS  CHAR    FORMAT 'x(3)'   COLUMN-LABEL "No Campaña Clasf General"
    FIELD   tclsutincam AS  CHAR    FORMAT 'x(3)'   COLUMN-LABEL "No Campaña Clasf Utilex"
    FIELD   tclsmayncam AS  CHAR    FORMAT 'x(3)'   COLUMN-LABEL "No Campaña Clasf Mayorista"
    FIELD   trnkgrlcam  AS  INT    FORMAT '>,>>>,>>9'   COLUMN-LABEL "Campaña Ranking General"
    FIELD   trnkuticam  AS  INT    FORMAT '>,>>>,>>9'   COLUMN-LABEL "Campaña Ranking Utilex"
    FIELD   trnkmaycam  AS  INT    FORMAT '>,>>>,>>9'   COLUMN-LABEL "Campaña Ranking Mayorista"
    FIELD   trnkgrlncam AS  INT    FORMAT '>,>>>,>>9'   COLUMN-LABEL "No Campaña Ranking General"
    FIELD   trnkutincam AS  INT    FORMAT '>,>>>,>>9'   COLUMN-LABEL "No Campaña Ranking Utilex"
    FIELD   trnkmayncam AS  INT    FORMAT '>,>>>,>>9'   COLUMN-LABEL "No Campaña Ranking Mayorista"
    FIELD   tean13      AS  CHAR    FORMAT 'x(15)'  COLUMN-LABEL "EAN 13"
    FIELD   tean14-1    AS  CHAR    FORMAT 'x(15)'  COLUMN-LABEL "EAN 14-1"
    FIELD   tean14-2    AS  CHAR    FORMAT 'x(15)'  COLUMN-LABEL "EAN 14-2"
    FIELD   tean14-3    AS  CHAR    FORMAT 'x(15)'  COLUMN-LABEL "EAN 14-3"
    FIELD   tean14-4    AS  CHAR    FORMAT 'x(15)'  COLUMN-LABEL "EAN 14-4"
    FIELD   tean14-5    AS  CHAR    FORMAT 'x(15)'  COLUMN-LABEL "EAN 14-5"
    FIELD   tqean14-1    AS  INT    FORMAT '>,>>>,>>9'  COLUMN-LABEL "Equivalencia EAN 14-1"
    FIELD   tqean14-2    AS  INT    FORMAT '>,>>>,>>9'  COLUMN-LABEL "EquivalenciaEAN 14-2"
    FIELD   tqean14-3    AS  INT    FORMAT '>,>>>,>>9'  COLUMN-LABEL "EquivalenciaEAN 14-3"
    FIELD   tqean14-4    AS  INT    FORMAT '>,>>>,>>9'  COLUMN-LABEL "EquivalenciaEAN 14-4"
    FIELD   tqean14-5    AS  INT    FORMAT '>,>>>,>>9'  COLUMN-LABEL "EquivalenciaEAN 14-5"
    FIELD   flgcomercial AS CHAR FORMAT 'x(60)' LABEL "Indice Comercial"
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
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES DimLinea

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 DimLinea.CodFam DimLinea.NomFam 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH DimLinea NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH DimLinea NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 DimLinea
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 DimLinea


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-6 BROWSE-3 BUTTON-8 BtnDone ~
chkAbastecimiento BUTTON-10 BUTTON-2 ChkBoxSoloConStock chkbxFecha txtDate ~
EDITOR-CodAlm BUTTON-3 FILL-IN-CodPro BUTTON-1 BUTTON-9 
&Scoped-Define DISPLAYED-OBJECTS chkAbastecimiento ChkBoxSoloConStock ~
chkbxFecha txtDate EDITOR-CodAlm FILL-IN-CodPro FILL-IN-NomPro ~
FILL-IN-Mensaje FILL-IN-filetxt 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 7 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 5 BY 1.08.

DEFINE BUTTON BUTTON-10 
     LABEL "Marcar todos" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "Desmarcar todos" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-3 
     LABEL "..." 
     SIZE 4 BY .96.

DEFINE BUTTON BUTTON-8 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 8" 
     SIZE 7 BY 1.54.

DEFINE BUTTON BUTTON-9 
     LABEL "Borrar nombre de archivo de TEXTO" 
     SIZE 29 BY .96.

DEFINE VARIABLE EDITOR-CodAlm AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 54 BY 2.31
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPro AS CHARACTER FORMAT "X(11)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-filetxt AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 72 BY 1
     BGCOLOR 15 FGCOLOR 4 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 62 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 66 BY 1 NO-UNDO.

DEFINE VARIABLE txtDate AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 62 BY 3.08.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83 BY 1.73.

DEFINE VARIABLE chkAbastecimiento AS LOGICAL INITIAL no 
     LABEL "Para abastecimiento" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .77 NO-UNDO.

DEFINE VARIABLE ChkBoxSoloConStock AS LOGICAL INITIAL yes 
     LABEL "Solo con STOCK" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.29 BY .77 NO-UNDO.

DEFINE VARIABLE chkbxFecha AS LOGICAL INITIAL no 
     LABEL "Considerar esta FECHA" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      DimLinea SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      DimLinea.CodFam COLUMN-LABEL "Linea" FORMAT "x(3)":U
      DimLinea.NomFam COLUMN-LABEL "Descripción" FORMAT "x(30)":U
            WIDTH 54.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 62 BY 14.42
         FONT 4
         TITLE "SELECCIONE UNA O MAS LINEAS A IMPRIMIR" ROW-HEIGHT-CHARS .46 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-3 AT ROW 1.19 COL 3 HELP
          "Presione CRTL para seleccionar más de un registro" WIDGET-ID 200
     BUTTON-8 AT ROW 1.19 COL 80 WIDGET-ID 40
     BtnDone AT ROW 1.19 COL 87 WIDGET-ID 38
     chkAbastecimiento AT ROW 2.92 COL 75 WIDGET-ID 82
     BUTTON-10 AT ROW 5.15 COL 67 WIDGET-ID 2
     BUTTON-2 AT ROW 6.31 COL 67 WIDGET-ID 70
     ChkBoxSoloConStock AT ROW 7.65 COL 67 WIDGET-ID 66
     chkbxFecha AT ROW 10.54 COL 69 WIDGET-ID 74
     txtDate AT ROW 11.35 COL 70.43 COLON-ALIGNED NO-LABEL WIDGET-ID 72
     EDITOR-CodAlm AT ROW 16.38 COL 4 NO-LABEL WIDGET-ID 76
     BUTTON-3 AT ROW 16.38 COL 59 WIDGET-ID 6
     FILL-IN-CodPro AT ROW 19.65 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 54
     FILL-IN-NomPro AT ROW 19.65 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 56
     FILL-IN-Mensaje AT ROW 21.19 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 42 NO-TAB-STOP 
     BUTTON-1 AT ROW 23.19 COL 75 WIDGET-ID 8
     FILL-IN-filetxt AT ROW 23.23 COL 3 NO-LABEL WIDGET-ID 10
     BUTTON-9 AT ROW 24.46 COL 26 WIDGET-ID 62
     "SELECCIONE UN PROVEEDOR" VIEW-AS TEXT
          SIZE 23 BY .5 AT ROW 19.08 COL 4 WIDGET-ID 58
          BGCOLOR 9 FGCOLOR 15 
     "Seleccione el Archivo de TEXTO con codigos de ARTICULOS" VIEW-AS TEXT
          SIZE 53.14 BY .62 AT ROW 22.54 COL 3 WIDGET-ID 12
          BGCOLOR 0 FGCOLOR 14 FONT 6
     "SELECCIONE UNO O MAS ALMACENES" VIEW-AS TEXT
          SIZE 29 BY .5 AT ROW 15.81 COL 4 WIDGET-ID 44
          BGCOLOR 9 FGCOLOR 15 
     RECT-2 AT ROW 16 COL 3 WIDGET-ID 46
     RECT-6 AT ROW 19.27 COL 3 WIDGET-ID 60
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 94.43 BY 24.54
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
         TITLE              = "STOCK CONSOLIDADO CONTI"
         HEIGHT             = 24.54
         WIDTH              = 94.43
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
/* BROWSE-TAB BROWSE-3 RECT-6 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-filetxt IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "estavtas.DimLinea"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > estavtas.DimLinea.CodFam
"DimLinea.CodFam" "Linea" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > estavtas.DimLinea.NomFam
"DimLinea.NomFam" "Descripción" ? "character" ? ? ? ? ? ? no ? no no "54.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* STOCK CONSOLIDADO CONTI */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* STOCK CONSOLIDADO CONTI */
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:

    DEFINE VARIABLE X-archivo AS CHARACTER.
    DEFINE VARIABLE OKpressed AS LOGICAL.

    DISPLAY "" @ FILL-IN-filetxt WITH FRAME {&FRAME-NAME}.
    

SYSTEM-DIALOG GET-FILE x-Archivo
            FILTERS "Archivo (*.txt)" "*.txt"
            MUST-EXIST
            TITLE "Seleccione archivo..."
            UPDATE OKpressed.   
          IF OKpressed = NO THEN RETURN.  

      DISPLAY X-archivo @ FILL-IN-filetxt WITH FRAME {&FRAME-NAME}.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-10 W-Win
ON CHOOSE OF BUTTON-10 IN FRAME F-Main /* Marcar todos */
DO:
  {&BROWSE-NAME}:SELECT-ALL().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Desmarcar todos */
DO:
  {&BROWSE-NAME}:DESELECT-ROWS().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* ... */
DO:
    DEFINE VARIABLE x-almacenes AS CHAR NO-UNDO.
    x-almacenes = EDITOR-CodAlm:SCREEN-VALUE.
    RUN alm/d-almacen (INPUT-OUTPUT x-almacenes).
    EDITOR-CodAlm:SCREEN-VALUE = x-almacenes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 W-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* Button 8 */
DO:
   DEF VAR pOptions AS CHAR.
   DEF VAR pArchivo AS CHAR.
   DEF VAR cArchivo AS CHAR.
   DEF VAR zArchivo AS CHAR.
   DEF VAR cComando AS CHAR.
   DEF VAR pDirectorio AS CHAR.
   DEF VAR lOptions AS CHAR.

   ASSIGN EDITOR-CodAlm FILL-IN-CodPro FILL-IN-filetxt chkboxSoloConStock chkAbastecimiento.
   ASSIGN txtDate ChkBxFecha.

   IF EDITOR-CodAlm = "" THEN DO:
       MESSAGE "Ingrese al menos un almacén" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
   END.

   RUN lib/tt-file-to-text-7zip (OUTPUT pOptions, OUTPUT pArchivo, OUTPUT pDirectorio).
   IF pOptions = "" THEN RETURN NO-APPLY.

   /*MESSAGE pArchivo pDirectorio.*/

   SESSION:SET-WAIT-STATE('GENERAL').
   RUN Carga-Temporal.
   SESSION:SET-WAIT-STATE('').

   FIND FIRST Detalle NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Detalle THEN DO:
       MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
       RETURN NO-APPLY.
   END.

   IF ChkAbastecimiento = YES THEN DO:
        SESSION:SET-WAIT-STATE('GENERAL').
        RUN abastecimiento-to-excel(INPUT pDirectorio, INPUT pArchivo).
        SESSION:SET-WAIT-STATE('').
        MESSAGE 'Proceso terminado!!!' VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
   END.

   /* El archivo se va a generar en un archivo temporal de trabajo antes 
   de enviarlo a su directorio destino */
   pOptions = pOptions + CHR(1) + "SkipList:Clasificacion,ClsfMayo,ClsfUtlx,IRanking,RnkgMayo,RnkgUtlx".
   pArchivo = REPLACE(pArchivo, '.', STRING(RANDOM(1,9999), '9999') + ".").
   cArchivo = LC(SESSION:TEMP-DIRECTORY + pArchivo).
   SESSION:SET-WAIT-STATE('GENERAL').
   SESSION:DATE-FORMAT = "mdy".
   RUN lib/tt-file (TEMP-TABLE Detalle:HANDLE, cArchivo, pOptions).
   SESSION:DATE-FORMAT = "dmy".
   SESSION:SET-WAIT-STATE('').

   /* Secuencia de comandos para encriptar el archivo con 7zip */
   IF INDEX(cArchivo, ".xls") > 0 THEN zArchivo = REPLACE(cArchivo, ".xls", ".zip").
   IF INDEX(cArchivo, ".txt") > 0 THEN zArchivo = REPLACE(cArchivo, ".txt", ".zip").
   cComando = '"C:\Archivos de programa\7-Zip\7z.exe" a ' + zArchivo + ' ' + cArchivo.
   OS-COMMAND 
       SILENT 
       VALUE ( cComando ).
   IF SEARCH(zArchivo) = ? THEN DO:
       MESSAGE 'NO se pudo encriptar el archivo' SKIP
           'Avise a sistemas'
           VIEW-AS ALERT-BOX ERROR.
       RETURN.
   END.
   OS-DELETE VALUE(cArchivo).

   IF INDEX(cArchivo, '.xls') > 0 THEN cArchivo = REPLACE(pArchivo, ".xls", ".zip").
   IF INDEX(cArchivo, '.txt') > 0 THEN cArchivo = REPLACE(pArchivo, ".txt", ".zip").
   cComando = "copy " + zArchivo + ' ' + TRIM(pDirectorio) + TRIM(cArchivo).
   OS-COMMAND 
       SILENT 
       VALUE(cComando).
   OS-DELETE VALUE(zArchivo).
   /* ******************************************************* */
   FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
   MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-9 W-Win
ON CHOOSE OF BUTTON-9 IN FRAME F-Main /* Borrar nombre de archivo de TEXTO */
DO:
  DISPLAY "" @ FILL-IN-filetxt WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodPro W-Win
ON LEAVE OF FILL-IN-CodPro IN FRAME F-Main
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND DimProveedor WHERE DimProveedor.codpro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE DimProveedor THEN DO:
        MESSAGE 'Proveedor no registrado' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    FILL-IN-NomPro:SCREEN-VALUE = DimProveedor.nompro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodPro W-Win
ON LEFT-MOUSE-DBLCLICK OF FILL-IN-CodPro IN FRAME F-Main
DO:
    RUN lkup/c-provee ('Proveedores').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE abastecimiento-to-excel W-Win 
PROCEDURE abastecimiento-to-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pDir AS CHAR.
DEFINE INPUT PARAMETER pFile AS CHAR.

DEFINE VAR lFileXls AS CHAR.

lFileXls = REPLACE(pFile,".xls",".xlsx").
lFileXls = REPLACE(lFileXls,".txt",".xlsx").


DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

c-xls-file = pDir + lFileXls.

run pi-crea-archivo-csv IN hProc (input  buffer tt-abastece:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-abastece:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-abastecimiento W-Win 
PROCEDURE carga-abastecimiento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*CREATE Detalle.*/

CREATE tt-abastece.
    ASSIGN  tcodalm = detalle.codalm
            tDesalm = detalle.almacen
            tcodmat = detalle.codmat
            tdesmat = detalle.producto      /*SUBSTRING(detalle.producto,8)*/
            tcodmar = SUBSTRING(detalle.marca,1,4)
            tdesmar = SUBSTRING(detalle.marca,6)
            tcodlinea   = SUBSTRING(detalle.linea,1,3)
            tdeslinea   = SUBSTRING(detalle.linea,5)
            tcodslinea   = SUBSTRING(detalle.sublinea,1,3)
            tdesslinea   = SUBSTRING(detalle.sublinea,5)
            tcodprov    = SUBSTRING(detalle.proveedor,1,INDEX(detalle.proveedor," ") - 1)
            tdesprov    = SUBSTRING(detalle.proveedor,INDEX(detalle.proveedor," ") + 1)
            tum         = detalle.unidad
            tstkfis     = detalle.stkact
            tstkcomp    = detalle.reservado
            tstkdisp    = tt-abastece.tstkfis - tt-abastece.tstkcomp
            tcostrepo   = detalle.costomn
            tcostprom   = detalle.promediomn
            tvol        = detalle.volumen
            tpeso       = detalle.peso
            ttipoalm    = detalle.tpoalm
            talmrema    = detalle.almrem
            talmcom     = detalle.almcom
            tcoddiv     = detalle.coddiv
            testado     = detalle.tpoart
            talms       = INTEGER(detalle.almacenes)
            tcatcont    = detalle.catconta
            ttraxrec    = detalle.trftransito
            tcomxrec    = detalle.cmptransito
            tproter     = detalle.CHR__02
            tstkmax     = detalle.StkMaximo
            tstkseg     = detalle.StkSeguridad
            tmaxseg     = detalle.StkMax_Seg
            tstkmaxcam  = Detalle.StkMaxCampa
            tstkmaxncam = detalle.StkMaxNoCampa
            temprepo    = detalle.QEmpaque
            tempinn     = IF(AVAILABLE almmmatg) THEN almmmatg.stkrep ELSE 0
            tempmas     = IF(AVAILABLE almmmatg) THEN almmmatg.canemp ELSE 0
            tclsgrlcam  = Detalle.CampClasifGral
            tclsuticam  = Detalle.CampClasifUtilex
            tclsmaycam  = Detalle.CampClasifMayo
            tclsgrlncam = Detalle.NoCampClasifGral
            tclsutincam = Detalle.NoCampClasifUtilex
            tclsmayncam = Detalle.NoCampClasifMayo
            trnkgrlcam  = Detalle.CampRankingGral
            trnkuticam  = Detalle.CampRankingUtilex
            trnkmaycam  = Detalle.CampRankingMayo
            trnkgrlncam = Detalle.NoCampRankingGral
            trnkutincam = Detalle.NoCampRankingUtilex
            trnkmayncam = Detalle.NoCampRankingMayo
            tean13      = Detalle.Ean13
            tean14-1    = detalle.Ean14-1
            tean14-2    = detalle.Ean14-2
            tean14-3    = detalle.Ean14-3
            tean14-4    = detalle.Ean14-4
            tean14-5    = detalle.Ean14-5
            tqean14-1   = detalle.Ean14-1e
            tqean14-2   = detalle.Ean14-2e
            tqean14-3   = detalle.Ean14-3e
            tqean14-4   = detalle.Ean14-4e
            tqean14-5   = detalle.Ean14-5e
            tt-abastece.flgcomercial = IF(AVAILABLE almtabla) THEN almtabla.nombre ELSE ""
        .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Compras W-Win 
PROCEDURE Carga-Compras :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF OUTPUT PARAMETER pCmpTransito AS DEC.

FOR EACH integral.Lg-cocmp NO-LOCK WHERE integral.Lg-cocmp.CodCia = S-CODCIA 
    AND integral.Lg-cocmp.coddiv = "00000"
    AND integral.Lg-cocmp.codalm = pCodAlm
    AND integral.Lg-cocmp.FlgSit = 'P'
    AND  INTEGRAL.LG-COCmp.FchVto >= TODAY,
    EACH integral.Lg-docmp OF integral.Lg-cocmp NO-LOCK WHERE integral.Lg-docmp.codmat = pCodMat
    AND integral.Lg-docmp.CanPedi >= integral.Lg-docmp.CanAten:
    ASSIGN
        pCmpTransito = pCmpTransito + (integral.Lg-docmp.CanPedi - integral.Lg-docmp.CanAten).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE Detalle.

DEFINE VAR lRutaFile AS CHAR.

lRutaFile = FILL-IN-filetxt:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

EMPTY TEMP-TABLE TT-TXT.

IF FILL-IN-filetxt <> "" THEN DO:
    /* Cargo el TXT */
    INPUT FROM VALUE(lRutaFile).
    REPEAT:
        CREATE tt-txt.
        IMPORT tt-txt.
        /*MESSAGE tt-txt.codigo.*/
    END.                    
    INPUT CLOSE.
END.

/* 1ro Continental */
RUN Carga-Temporal-Conti2.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Conti W-Win 
PROCEDURE Carga-Temporal-Conti :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR k AS INT NO-UNDO.

DEFINE VAR x-Stock AS DEC NO-UNDO.
DEFINE VAR x-CompxLlegar AS DEC NO-UNDO.
DEFINE VAR x-StockComprometido AS DEC NO-UNDO.
DEFINE VAR x-TrfTransito AS DEC NO-UNDO.
DEFINE VAR x-CmpTransito AS DEC NO-UNDO.

EMPTY TEMP-TABLE tt-DimProducto.
EMPTY TEMP-TABLE Detalle.
EMPTY TEMP-TABLE tt-abastece.

IF FILL-IN-filetxt <> "" THEN DO:
    FOR EACH tt-txt :
        FOR EACH integral.Almmmatg NO-LOCK WHERE integral.Almmmatg.codcia = s-codcia
            AND integral.Almmmatg.codmat = tt-txt.codigo:
            CREATE tt-DimProducto.
            BUFFER-COPY integral.Almmmatg TO tt-DimProducto.
        END.
    END.
END.
ELSE DO:
    DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) IN FRAME {&FRAME-NAME} THEN DO:
            FOR EACH integral.Almmmatg NO-LOCK WHERE integral.Almmmatg.codcia = s-codcia
                AND integral.Almmmatg.CodFam = estavtas.DimLinea.CodFam
                AND (FILL-IN-CodPro = "" OR integral.Almmmatg.CodPr1 = FILL-IN-CodPro):
                CREATE tt-DimProducto.
                BUFFER-COPY integral.Almmmatg TO tt-DimProducto.
            END.
        END.
    END.
END.

/* Cargamos Productos */
DEF VAR cCodAlm AS CHAR NO-UNDO.
DEF VAR iItem AS INT NO-UNDO.

FOR EACH tt-DimProducto NO-LOCK:
    DO iItem = 1 TO NUM-ENTRIES(EDITOR-CodAlm):
        FOR EACH estavtas.Almacen_Stocks NO-LOCK WHERE estavtas.Almacen_Stocks.codmat = tt-DimProducto.CodMat
            AND estavtas.Almacen_Stocks.codalm = TRIM(ENTRY(iItem,EDITOR-CodAlm)):
            IF estavtas.Almacen_Stocks.codalm = '999' THEN NEXT.
            /* Ic 13Abr2015 - de alguna fecha en particular */
            ASSIGN
                x-Stock = Almacen_Stocks.StkAct 
                x-StockComprometido = estavtas.Almacen_Stocks.Reservado 
                x-TrfTransito = Almacen_Stocks.TrfTransito 
                x-CmpTransito = Almacen_Stocks.CmpTransito.
            IF ChkBxFecha = YES THEN DO:
                x-Stock = 0.
                FIND LAST integral.Almstkal WHERE Almstkal.codcia = s-codcia AND 
                    Almstkal.codalm = estavtas.Almacen_Stocks.codalm AND
                    Almstkal.codmat = estavtas.Almacen_Stocks.codmat AND
                    Almstkal.fecha <= txtDate NO-LOCK NO-ERROR.
                IF AVAILABLE integral.Almstkal THEN x-Stock = integral.Almstkal.Stkact.
                ELSE NEXT.
            END.
            ELSE DO:
                FIND integral.Almmmate WHERE integral.Almmmate.CodCia = s-codcia
                    AND integral.Almmmate.CodAlm = estavtas.Almacen_Stocks.codalm
                    AND integral.Almmmate.codmat = estavtas.Almacen_Stocks.codmat
                    NO-LOCK NO-ERROR.
                IF AVAILABLE integral.Almmmate THEN DO:
                    /*RUN gn/stock-comprometido-v2.p (Almmmate.CodMat, Almmmate.CodAlm, NO, OUTPUT x-StockComprometido).*/
                    ASSIGN x-Stock = integral.Almmmate.StkAct.
                END.
            END.
            IF ChkBoxSoloConStock = YES AND x-Stock <= 0 THEN NEXT.
            FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "CARGANDO STOCK: " + tt-DimProducto.CodMat.
            CREATE Detalle.
            BUFFER-COPY Almacen_Stocks 
                TO Detalle
                ASSIGN 
                    detalle.stkact = x-stock
                    detalle.reservado = x-StockComprometido
                    detalle.trftransito = x-TrfTransito
                    detalle.cmptransito = x-CmpTransito
                    detalle.volumen = tt-DimProducto.Libre_d02
                    detalle.peso    = tt-DimProducto.PesMat.
            /* RHC 09/04/2015 */
            FIND integral.FacTabla WHERE integral.FacTabla.codcia = s-codcia
                AND integral.FacTabla.tabla = 'RANKVTA'
                AND integral.FacTabla.codigo = estavtas.Almacen_Stocks.codmat
                NO-LOCK NO-ERROR.
            IF AVAILABLE integral.FacTabla THEN
                ASSIGN
                Detalle.CampClasifGral      = integral.FacTabla.Campo-C[1]
                Detalle.CampRankingGral     = integral.FacTabla.Valor[1]
                Detalle.CampClasifUtilex    = integral.FacTabla.Campo-C[2]
                Detalle.CampRankingUtilex   = integral.FacTabla.Valor[2]
                Detalle.CampClasifMayo      = integral.FacTabla.Campo-C[3]
                Detalle.CampRankingMayo     = integral.FacTabla.Valor[3]
                Detalle.NoCampClasifGral    = integral.FacTabla.Campo-C[4]
                Detalle.NoCampRankingGral   = integral.FacTabla.Valor[4]
                Detalle.NoCampClasifUtilex  = integral.FacTabla.Campo-C[5]
                Detalle.NoCampRankingUtilex = integral.FacTabla.Valor[5]
                Detalle.NoCampClasifMayo    = integral.FacTabla.Campo-C[6]
                Detalle.NoCampRankingMayo   = integral.FacTabla.Valor[6].
            /* RHC 13/05/2015 Códigos EAN */
            ASSIGN
                Detalle.Ean13 = tt-DimProducto.CodBrr.
            FIND FIRST Almmmat1 OF tt-DimProducto WHERE Almmmat1.codcia = s-codcia
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almmmat1 THEN DO:
                Ean14-1 = Almmmat1.Barras[1].
                Ean14-2 = Almmmat1.Barras[2].
                Ean14-3 = Almmmat1.Barras[3].
                Ean14-4 = Almmmat1.Barras[4].
                Ean14-5 = Almmmat1.Barras[5].
                Ean14-1e = Almmmat1.Equival[1].
                Ean14-2e = Almmmat1.Equival[2].
                Ean14-3e = Almmmat1.Equival[3].
                Ean14-4e = Almmmat1.Equival[4].
                Ean14-5e = Almmmat1.Equival[5].
            END.
            /* Ic - 30Dic2015 : Stock de Seguridad */
            FIND FIRST Almmmate WHERE Almmmate.codcia = s-codcia AND 
                                        almmmate.codalm = estavtas.Almacen_Stocks.codalm AND
                                        almmmate.codmat = estavtas.Almacen_Stocks.codmat
                                        NO-LOCK NO-ERROR.
            IF AVAILABLE almmmate THEN DO:
                ASSIGN detalle.StkMaximo      = almmmate.VInMn1
                        detalle.StkSeguridad  = almmmate.VInMn2
                        detalle.StkMax_Seg    = almmmate.StkMin
                        detalle.StkMaxCampa   = almmmate.Vctmn1
                        detalle.StkMaxNoCampa = almmmate.Vctmn2
                        detalle.QEmpaque      = almmmate.StkMax.
            END.

            FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia
                AND Almmmatg.codmat = Detalle.CodMat NO-LOCK NO-ERROR.
            IF AVAILABLE almmmatg THEN Detalle.CHR__02  = Almmmatg.CHR__02.

            /* Compras x Llegar */
            x-CompxLlegar = 0.
            RUN compras-x-llegar(INPUT detalle.codalm, INPUT detalle.codmat, OUTPUT x-CompxLlegar).
            ASSIGN detalle.cmptransito = x-CompxLlegar.
            /* Cargar Data para reporte de Abastecimiento */
            RUN carga-abastecimiento.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-temporal-conti2 W-Win 
PROCEDURE carga-temporal-conti2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR k AS INT NO-UNDO.

DEFINE VAR x-Stock AS DEC NO-UNDO.
DEFINE VAR x-CompxLlegar AS DEC NO-UNDO.
DEFINE VAR x-StockComprometido AS DEC NO-UNDO.
DEFINE VAR x-TrfTransito AS DEC NO-UNDO.
DEFINE VAR x-CmpTransito AS DEC NO-UNDO.

EMPTY TEMP-TABLE tt-DimProducto.
EMPTY TEMP-TABLE Detalle.
EMPTY TEMP-TABLE tt-abastece.

IF FILL-IN-filetxt <> "" THEN DO:
    FOR EACH tt-txt :
        FOR EACH integral.Almmmatg NO-LOCK WHERE integral.Almmmatg.codcia = s-codcia
            AND integral.Almmmatg.codmat = tt-txt.codigo:
            CREATE tt-DimProducto.
            BUFFER-COPY integral.Almmmatg TO tt-DimProducto.
        END.
    END.
END.
ELSE DO:
    DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) IN FRAME {&FRAME-NAME} THEN DO:
            FOR EACH integral.Almmmatg NO-LOCK WHERE integral.Almmmatg.codcia = s-codcia
                AND integral.Almmmatg.CodFam = estavtas.DimLinea.CodFam
                AND (FILL-IN-CodPro = "" OR integral.Almmmatg.CodPr1 = FILL-IN-CodPro):
                CREATE tt-DimProducto.
                BUFFER-COPY integral.Almmmatg TO tt-DimProducto.
            END.
        END.
    END.
END.

/* Cargamos Productos */
DEF VAR cCodAlm AS CHAR NO-UNDO.
DEF VAR iItem AS INT NO-UNDO.

DEFINE VAR x-cargar-otros AS LOG.

FOR EACH tt-DimProducto NO-LOCK:
    DO iItem = 1 TO NUM-ENTRIES(EDITOR-CodAlm):

        x-cargar-otros = NO.

        IF ChkBxFecha = YES THEN DO:
            IF TRIM(ENTRY(iItem,EDITOR-CodAlm)) <> "999" THEN DO:
                FIND LAST Almstkal WHERE Almstkal.codcia = s-codcia AND 
                        Almstkal.codalm = TRIM(ENTRY(iItem,EDITOR-CodAlm)) AND
                        Almstkal.codmat = tt-DimProducto.CodMat AND
                        Almstkal.fecha <= txtDate NO-LOCK NO-ERROR.

                x-Stock = 0.
                
                IF AVAILABLE almstkal THEN x-Stock = integral.Almstkal.Stkact.

                IF ChkBoxSoloConStock = YES AND x-Stock <= 0 THEN NEXT.

                FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
                                            almmmatg.codmat = tt-DimProducto.CodMat NO-LOCK NO-ERROR.
                FIND FIRST almacen WHERE almacen.codcia = s-codcia AND 
                                        almacen.codalm = TRIM(ENTRY(iItem,EDITOR-CodAlm)) NO-LOCK NO-ERROR.
                FIND FIRST almtfam OF almmmatg NO-LOCK NO-ERROR.
                FIND FIRST almsfam OF almmmatg NO-LOCK NO-ERROR.
                FIND FIRST gn-prov WHERE gn-prov.codcia = 0 AND 
                                            gn-prov.codpro = almmmatg.codpr1 NO-LOCK NO-ERROR.

                FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "CARGANDO STOCK: " + tt-DimProducto.CodMat.

                /* -- */
                CREATE Detalle.

                FIND FIRST Almacen_Stocks WHERE Almacen_Stocks.codalm = TRIM(ENTRY(iItem,EDITOR-CodAlm)) AND
                                                Almacen_Stocks.codmat = tt-DimProducto.CodMat NO-LOCK NO-ERROR.
                IF AVAILABLE Almacen_Stocks THEN DO:
                    BUFFER-COPY Almacen_Stocks TO Detalle.
                END.

                ASSIGN Detalle.codalm = TRIM(ENTRY(iItem,EDITOR-CodAlm))
                        detalle.codmat = tt-DimProducto.CodMat
                        detalle.producto = tt-DimProducto.CodMat + " " + almmmatg.desmat
                        detalle.almacen = TRIM(ENTRY(iItem,EDITOR-CodAlm)) + " " + almacen.descripcion
                        detalle.linea = almmmatg.codfam + " " + if( AVAILABLE almtfam) THEN almtfam.desfam ELSE " ** NO EXISTE **"
                        detalle.sublinea = almmmatg.subfam + " " + if(AVAILABLE almsfam) THEN almsfam.dessub ELSE " ** NO EXISTE **"
                        detalle.marca = almmmatg.codmar + " " + almmmatg.desmar
                        detalle.proveedor = almmmatg.codpr1 + " " + IF(AVAILABLE gn-prov) THEN gn-prov.nompro ELSE ""
                        detalle.unidad = almmmatg.undbas
                        detalle.stkact = x-stock
                        detalle.reservado = 0
                        detalle.trftransito = 0
                        detalle.cmptransito = 0
                        detalle.volumen = almmmatg.Libre_d02
                        detalle.peso    = almmmatg.PesMat.                            
                        .
                x-cargar-otros = YES.

                /* Los */
            END.
        END.
        ELSE DO:
            FOR EACH estavtas.Almacen_Stocks NO-LOCK WHERE estavtas.Almacen_Stocks.codmat = tt-DimProducto.CodMat
                AND estavtas.Almacen_Stocks.codalm = TRIM(ENTRY(iItem,EDITOR-CodAlm)):

                x-cargar-otros = NO.

                IF estavtas.Almacen_Stocks.codalm = '999' THEN NEXT.
                /* Ic 13Abr2015 - de alguna fecha en particular */
                ASSIGN
                    x-Stock = Almacen_Stocks.StkAct 
                    x-StockComprometido = estavtas.Almacen_Stocks.Reservado 
                    x-TrfTransito = Almacen_Stocks.TrfTransito 
                    x-CmpTransito = Almacen_Stocks.CmpTransito.
/*                 FIND integral.Almmmate WHERE integral.Almmmate.CodCia = s-codcia  */
/*                     AND integral.Almmmate.CodAlm = estavtas.Almacen_Stocks.codalm */
/*                     AND integral.Almmmate.codmat = estavtas.Almacen_Stocks.codmat */
/*                     NO-LOCK NO-ERROR.                                             */
/*                 IF AVAILABLE integral.Almmmate THEN DO:                           */
/*                     ASSIGN x-Stock = integral.Almmmate.StkAct.                    */
/*                 END.                                                              */
                IF ChkBoxSoloConStock = YES AND x-Stock <= 0 THEN NEXT.

                FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "CARGANDO STOCK: " + tt-DimProducto.CodMat.
                CREATE Detalle.
                BUFFER-COPY Almacen_Stocks 
                    TO Detalle
                    ASSIGN 
                        detalle.stkact = x-stock
                        detalle.reservado = x-StockComprometido
                        detalle.trftransito = x-TrfTransito
                        detalle.cmptransito = x-CmpTransito
                        detalle.volumen = tt-DimProducto.Libre_d02
                        detalle.peso    = tt-DimProducto.PesMat.

                x-cargar-otros = YES.

            END.
        END.
        IF x-cargar-otros = YES THEN DO:
            /* RHC 09/04/2015 */
            FIND integral.FacTabla WHERE integral.FacTabla.codcia = s-codcia
                AND integral.FacTabla.tabla = 'RANKVTA'
                AND integral.FacTabla.codigo = tt-DimProducto.CodMat /*estavtas.Almacen_Stocks.codmat*/
                NO-LOCK NO-ERROR.
            IF AVAILABLE integral.FacTabla THEN
                ASSIGN
                Detalle.CampClasifGral      = integral.FacTabla.Campo-C[1]
                Detalle.CampRankingGral     = integral.FacTabla.Valor[1]
                Detalle.CampClasifUtilex    = integral.FacTabla.Campo-C[2]
                Detalle.CampRankingUtilex   = integral.FacTabla.Valor[2]
                Detalle.CampClasifMayo      = integral.FacTabla.Campo-C[3]
                Detalle.CampRankingMayo     = integral.FacTabla.Valor[3]
                Detalle.NoCampClasifGral    = integral.FacTabla.Campo-C[4]
                Detalle.NoCampRankingGral   = integral.FacTabla.Valor[4]
                Detalle.NoCampClasifUtilex  = integral.FacTabla.Campo-C[5]
                Detalle.NoCampRankingUtilex = integral.FacTabla.Valor[5]
                Detalle.NoCampClasifMayo    = integral.FacTabla.Campo-C[6]
                Detalle.NoCampRankingMayo   = integral.FacTabla.Valor[6].
            /* RHC 13/05/2015 Códigos EAN */
            ASSIGN
                Detalle.Ean13 = tt-DimProducto.CodBrr.
            FIND FIRST Almmmat1 OF tt-DimProducto WHERE Almmmat1.codcia = s-codcia
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almmmat1 THEN DO:
                Ean14-1 = Almmmat1.Barras[1].
                Ean14-2 = Almmmat1.Barras[2].
                Ean14-3 = Almmmat1.Barras[3].
                Ean14-4 = Almmmat1.Barras[4].
                Ean14-5 = Almmmat1.Barras[5].
                Ean14-1e = Almmmat1.Equival[1].
                Ean14-2e = Almmmat1.Equival[2].
                Ean14-3e = Almmmat1.Equival[3].
                Ean14-4e = Almmmat1.Equival[4].
                Ean14-5e = Almmmat1.Equival[5].
            END.
            /* Ic - 30Dic2015 : Stock de Seguridad */
            FIND FIRST Almmmate WHERE Almmmate.codcia = s-codcia AND 
                                        almmmate.codalm = Detalle.codalm AND
                                        almmmate.codmat = Detalle.codmat
                                        NO-LOCK NO-ERROR.
            IF AVAILABLE almmmate THEN DO:
                ASSIGN detalle.StkMaximo      = almmmate.VInMn1
                        detalle.StkSeguridad  = almmmate.VInMn2
                        detalle.StkMax_Seg    = almmmate.StkMin
                        detalle.StkMaxCampa   = almmmate.Vctmn1
                        detalle.StkMaxNoCampa = almmmate.Vctmn2
                        detalle.QEmpaque      = almmmate.StkMax.
            END.

            FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia
                AND Almmmatg.codmat = Detalle.CodMat NO-LOCK NO-ERROR.
            IF AVAILABLE almmmatg THEN DO:
                ASSIGN Detalle.CHR__02  = Almmmatg.CHR__02.
                /* Ic - 11Set2018, INDICE COMERCIAL correo de lucy mesia 10Set2018 */
                FIND FIRST almtabla WHERE almtabla.tabla = 'IN_CO' AND 
                                            almtabla.codigo = almmmatg.flgcomercial NO-LOCK NO-ERROR.
                IF AVAILABLE almtabla THEN ASSIGN detalle.flgcomercial = almtabla.nombre.
            END.                 

            /* Compras x Llegar */
            x-CompxLlegar = 0.
            RUN compras-x-llegar(INPUT detalle.codalm, INPUT detalle.codmat, OUTPUT x-CompxLlegar).
            ASSIGN detalle.cmptransito = x-CompxLlegar.

            /* Cargar Data para reporte de Abastecimiento */
            RUN carga-abastecimiento.
        END.
    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Transferencias W-Win 
PROCEDURE Carga-Transferencias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF OUTPUT PARAMETER pTrfTransito AS DEC.

pTrfTransito = 0.
/* REPOSICIONES */
FOR EACH integral.Almdrepo NO-LOCK WHERE INTEGRAL.almdrepo.CodCia = s-codcia
    AND INTEGRAL.almdrepo.CodMat = pCodMat
    AND (integral.almdrepo.CanApro > integral.almdrepo.CanAten),
    FIRST integral.Almcrepo OF integral.Almdrepo NO-LOCK WHERE integral.Almcrepo.CodAlm = pCodAlm:
    IF NOT (LOOKUP(integral.Almcrepo.AlmPed, '997,998') = 0
            AND integral.Almcrepo.FlgEst = 'P'
            AND LOOKUP(integral.Almcrepo.FlgSit, 'A,P') > 0)
        THEN NEXT.
    ASSIGN 
        pTrfTransito = pTrfTransito + (integral.Almdrepo.CanApro - integral.Almdrepo.CanAten).
END.
/* FOR EACH integral.Almcrepo NO-LOCK WHERE integral.Almcrepo.codcia = s-codcia                     */
/*     AND integral.Almcrepo.CodAlm = pCodAlm                                                       */
/*     AND LOOKUP(integral.Almcrepo.AlmPed, '997,998') = 0                                          */
/*     AND integral.Almcrepo.FlgEst = 'P'                                                           */
/*     AND LOOKUP(integral.Almcrepo.FlgSit, 'A,P') > 0,     /* Aprobado y x Aprobar */              */
/*     EACH integral.Almdrepo OF integral.Almcrepo NO-LOCK WHERE integral.almdrepo.CodMat = pCodMat */
/*     AND integral.almdrepo.CanApro > integral.almdrepo.CanAten:                                   */
/*     ASSIGN                                                                                       */
/*         pTrfTransito = pTrfTransito + (integral.Almdrepo.CanApro - integral.Almdrepo.CanAten).   */
/* END.                                                                                             */
/* TRANSFERENCIAS */
FOR EACH INTEGRAL.Almdmov NO-LOCK USE-INDEX almd03 WHERE INTEGRAL.Almdmov.CodCia = s-codcia
    AND INTEGRAL.Almdmov.CodAlm = pCodAlm
    AND INTEGRAL.Almdmov.codmat = pCodMat
    AND INTEGRAL.Almdmov.tipmov = 's'
    AND INTEGRAL.Almdmov.codmov = 03,
    FIRST integral.Almcmov OF integral.Almdmov NO-LOCK WHERE integral.Almcmov.flgest <> "A"
    AND integral.Almcmov.flgsit = "T":
    IF integral.Almcmov.almdes = pCodAlm THEN
        ASSIGN 
            pTrfTransito = pTrfTransito + integral.Almdmov.candes.
END.
/* FOR EACH integral.Almacen NO-LOCK WHERE integral.Almacen.codcia = s-codcia,                    */
/*     EACH integral.Almcmov NO-LOCK WHERE integral.Almcmov.codcia = integral.Almacen.codcia      */
/*     AND integral.Almcmov.codalm = integral.Almacen.codalm                                      */
/*     AND integral.Almcmov.almdes = pCodAlm                                                      */
/*     AND integral.Almcmov.tipmov = "S"                                                          */
/*     AND integral.Almcmov.codmov = 03                                                           */
/*     AND integral.Almcmov.flgest <> "A"                                                         */
/*     AND integral.Almcmov.flgsit = "T",                                                         */
/*     EACH integral.Almdmov OF integral.Almcmov NO-LOCK WHERE integral.Almdmov.codmat = pCodMat: */
/*     ASSIGN                                                                                     */
/*         pTrfTransito = pTrfTransito + integral.Almdmov.candes.                                 */
/* END.                                                                                           */
FOR EACH integral.Facdpedi NO-LOCK WHERE integral.Facdpedi.codcia = s-codcia
    AND integral.Facdpedi.codmat = pCodMat
    AND integral.Facdpedi.coddoc = "OTR"
    AND integral.Facdpedi.flgest = "P",
    FIRST integral.Faccpedi OF integral.Facdpedi NO-LOCK WHERE integral.Faccpedi.flgest = "P"
    AND integral.Faccpedi.codcli = pCodAlm:
    ASSIGN
        pTrfTransito = pTrfTransito + integral.Facdpedi.Factor * (integral.Facdpedi.CanPed - integral.Facdpedi.CanAte).
END.
/* FOR EACH integral.Faccpedi NO-LOCK WHERE integral.Faccpedi.codcia = s-codcia                                            */
/*     AND integral.Faccpedi.coddoc = "OTR"                                                                                */
/*     AND integral.Faccpedi.flgest = "P"                                                                                  */
/*     AND integral.Faccpedi.codcli = pCodAlm,                                                                             */
/*     EACH integral.Facdpedi OF integral.Faccpedi NO-LOCK WHERE integral.Facdpedi.codmat = pCodMat                        */
/*     AND integral.Facdpedi.flgest = 'P':                                                                                 */
/*     ASSIGN                                                                                                              */
/*         pTrfTransito = pTrfTransito + integral.Facdpedi.Factor * (integral.Facdpedi.CanPed - integral.Facdpedi.CanAte). */
/* END.                                                                                                                    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE compras-x-llegar W-Win 
PROCEDURE compras-x-llegar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodAlm AS CHAR.
DEFINE INPUT PARAMETER pCodmat AS CHAR.
DEFINE OUTPUT PARAMETER pCant AS DEC.

pCant = 0.
FOR EACH OOComPend USE-INDEX idx02 WHERE OOComPend.codalm = pCodAlm AND 
                                        OOComPend.codmat = pCodMat NO-LOCK :
    pCant = pCant + (OOComPend.Canped - OOComPend.CanAte).
END.

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
  DISPLAY chkAbastecimiento ChkBoxSoloConStock chkbxFecha txtDate EDITOR-CodAlm 
          FILL-IN-CodPro FILL-IN-NomPro FILL-IN-Mensaje FILL-IN-filetxt 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-2 RECT-6 BROWSE-3 BUTTON-8 BtnDone chkAbastecimiento BUTTON-10 
         BUTTON-2 ChkBoxSoloConStock chkbxFecha txtDate EDITOR-CodAlm BUTTON-3 
         FILL-IN-CodPro BUTTON-1 BUTTON-9 
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
  txtDate:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 1,"99/99/9999").

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
  {src/adm/template/snd-list.i "DimLinea"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Stock-Comprometido W-Win 
PROCEDURE Stock-Comprometido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/stock-comprometido.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

