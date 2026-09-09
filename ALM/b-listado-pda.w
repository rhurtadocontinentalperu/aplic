&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-InvCargaInicial NO-UNDO LIKE InvCargaInicial
       fields DifQty  as decimal
       fields iValorizado as decimal
       fields cSelected as char format 'x(1)'
       fields codfam as char format 'x(3)'
       fields desfam as char format 'x(30)'
       fields codsub as char format 'x(3)'
       fields dessub as char format 'x(30)'
       fields codmar as char format 'x(5)'
       fields desmar as char format 'x(30)'
       fields clsfica as char format 'x(1)'
       fields ranking as int
       fields dusr_conteo as char format 'x(50)'
       fields dusr_reconteo as char format 'x(50)'
       fields dusr_3erconteo as char format 'x(50)'.
DEFINE TEMP-TABLE tt-InvcPDA NO-UNDO LIKE InvcPDA
       fields qConteo as dec
       fields qReconteo as dec
       fields q3erConteo as dec.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
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

  Description: from BROWSER.W - Basic SmartBrowser Object Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

DEFINE SHARED VAR s-codcia  AS INTEGER INIT 1.
DEFINE SHARED VAR s-user-id AS CHARACTER.
DEFINE SHARED VAR s-nomcia  AS CHARACTER.
DEFINE SHARED VAR lh_handle AS HANDLE.
DEFINE VAR px-conteo AS INT.

DEFINE VARIABLE cConfi  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dQtyDif AS DECIMAL     NO-UNDO.
DEFINE VARIABLE iCant   AS INTEGER     NO-UNDO INIT 0.
DEFINE VARIABLE cArti   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dQtyCon AS DECIMAL     NO-UNDO.
DEFINE VARIABLE cFiltro AS CHARACTER   NO-UNDO.

DEFINE VARIABLE s-task-no AS INTEGER  NO-UNDO.

DEFINE TEMP-TABLE tt-clsfica
    FIELDS tt-clsfica AS CHAR FORMAT 'x(25)'
    INDEX idx01 IS PRIMARY tt-clsfica.

DEFINE TEMP-TABLE tt-Inventariador
    FIELDS tt-codper AS CHAR FORMAT 'x(8)'
    FIELDS tt-nomper AS CHAR FORMAT 'x(50)'
    INDEX idx01 IS PRIMARY tt-codper.

/*
DEFINE BUFFER tmp-tt-AlmDInv FOR tt-AlmDInv.
DEFINE TEMP-TABLE tt-Datos LIKE tmp-tt-AlmDInv.
*/
DEFINE VARIABLE Imp AS INTEGER NO-UNDO.

/*Mensaje de Proceso*/
DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

DEFINE VAR lClasificacion AS CHAR INIT 'Todos'.
DEFINE VAR lFamilia AS CHAR INIT 'Todos'.
DEFINE VAR lSubFamilia AS CHAR INIT 'Todos'.
DEFINE VAR lMarca AS CHAR INIT 'Todos'.
DEFINE VAR lUnidades AS INT INIT 1.
DEFINE VAR lUndDesde AS DEC INIT 0.
DEFINE VAR lUndHasta AS DEC INIT 99999999.
DEFINE VAR lInventariador AS CHAR INIT 'Todos'.

DEFINE VAR lVerSoloMarcados AS LOG INIT NO.

&SCOPED-DEFINE CONDICION ( ~
                            (lClasificacion = 'Todos' OR tt-invCargaInicial.clsfica = lClasificacion)  AND ~
                            (lFamilia = 'Todos' OR tt-invCargaInicial.codfam = lFamilia) AND ~
                            (lSubFamilia = 'Todos' OR tt-invCargaInicial.codSub = lSubFamilia ) AND ~
                            (lMarca = 'Todos' OR tt-invCargaInicial.codmar = lMarca ) AND ~
                            ( (lUnidades = 1 AND ( ABSOLUTE(tt-invCargaInicial.iValorizado) >= lUndDesde AND ~
                                                   ABSOLUTE(tt-invCargaInicial.iValorizado) <= lUndHasta)) OR ~
                              (lUnidades = 2 AND (tt-invCargaInicial.Ranking >= lUndDesde AND tt-invCargaInicial.Ranking <= lUndHasta)) ~
                            ) AND ~
                            (lVerSoloMarcados = NO OR tt-invCargaInicial.scontar = 'S') AND ~
                           (ChkConteo = NO OR tt-invCargaInicial.qcont1 <> ?) AND ~
                           (ChkReConteo = NO OR tt-invCargaInicial.qcont2 <> ?) AND ~
                           (Chk3erConteo = NO OR tt-invCargaInicial.qcont3 <> ?) AND ~
                           (lInventariador = 'Todos' OR (px-conteo <> 4 AND  ~
                                tt-invCargaInicial.usrInventario[px-conteo - 1] = lInventariador ) ) ~
                         )

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-InvCargaInicial Almmmatg tt-InvcPDA

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table tt-InvCargaInicial.sContar ~
tt-InvCargaInicial.CodMat Almmmatg.DesMat Almmmatg.DesMar Almmmatg.UndBas ~
tt-InvCargaInicial.QStkSis tt-InvCargaInicial.QCont1 ~
tt-InvCargaInicial.QCont2 tt-InvCargaInicial.QCont3 ~
tt-InvCargaInicial.QInvFinal DifQty @ DifQty iValorizado @ iValorizado ~
DesFam @ DesFam dessub @ dessub ~
tt-invCargaInicial.desmar @ tt-invCargaInicial.desmar ~
tt-invcargainicial.clsfica @ tt-invcargainicial.clsfica ~
tt-invcargainicial.ranking @ tt-invcargainicial.ranking ~
tt-invCargaInicial.dusr_conteo @ tt-invCargaInicial.dusr_conteo ~
tt-invCargaInicial.dusr_reconteo @ tt-invCargaInicial.dusr_reconteo ~
tt-invCargaInicial.dusr_3erconteo @ tt-invCargaInicial.dusr_3erconteo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH tt-InvCargaInicial WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} NO-LOCK, ~
      FIRST Almmmatg WHERE almmmatg.codcia = tt-invCargaInicial.codcia and  ~
almmmatg.codmat = tt-invCargaInicial.codmat NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH tt-InvCargaInicial WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} NO-LOCK, ~
      FIRST Almmmatg WHERE almmmatg.codcia = tt-invCargaInicial.codcia and  ~
almmmatg.codmat = tt-invCargaInicial.codmat NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table tt-InvCargaInicial Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table tt-InvCargaInicial
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for BROWSE br_tableZona                                  */
&Scoped-define FIELDS-IN-QUERY-br_tableZona tt-InvcPDA.CZona ~
qConteo @ qConteo qReConteo @ qReConteo q3erConteo @ q3erConteo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_tableZona 
&Scoped-define QUERY-STRING-br_tableZona FOR EACH tt-InvcPDA NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_tableZona OPEN QUERY br_tableZona FOR EACH tt-InvcPDA NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_tableZona tt-InvcPDA
&Scoped-define FIRST-TABLE-IN-QUERY-br_tableZona tt-InvcPDA


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br_tableZona}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS ChkConteo BtnDesFiltrar btnGrabar btnFiltrar ~
btnMarcar btnSoloMarcados cboClasifica rbUnidades txtDesde txt-codalm ~
txt-codmat tg-dif rbCuales CboFamilia cboSubFamilia cboMarca btn-consulta ~
btn-Excel btn-exit-2 br_table BUTTON-1 br_tableZona txtHasta btnDesMarcar ~
btnDesmarcarTodos cboInventariador ChkReConteo Chk3erConteo RECT-67 RECT-68 ~
RECT-74 RECT-75 RECT-76 
&Scoped-Define DISPLAYED-OBJECTS ChkConteo cboClasifica rbUnidades txtDesde ~
txt-codalm txt-codmat tg-dif rbCuales CboFamilia cboSubFamilia cboMarca ~
txtHasta cboInventariador ChkReConteo Chk3erConteo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS>
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
CodMat|y||INTEGRAL.tt-invCargaInicial.Codmat|yes
DesMat|||integral.almmmatg.DesMat|yes
DifQty|||INTEGRAL.tt-invCargaInicial.DifQty|no
iValorizado|||integral.tt-invCargaInicial.iValorizado|yes
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "':U + 'CodMat,DesMat,DifQty,iValorizado' + '",
     SortBy-Case = ':U + 'CodMat').

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).

/* This SmartObject is a valid SortBy-Target. */
&IF '{&user-supported-links}':U ne '':U &THEN
  &Scoped-define user-supported-links {&user-supported-links},SortBy-Target
&ELSE
  &Scoped-define user-supported-links SortBy-Target
&ENDIF

/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-consulta 
     IMAGE-UP FILE "IMG/pvbrowd.bmp":U
     LABEL "Button 10" 
     SIZE 9 BY 1.88.

DEFINE BUTTON btn-Excel 
     IMAGE-UP FILE "IMG/excel.bmp":U
     LABEL "Button 1" 
     SIZE 9 BY 1.88.

DEFINE BUTTON btn-exit-2 
     IMAGE-UP FILE "IMG/exit.ico":U
     LABEL "btn exit 2" 
     SIZE 9 BY 1.88.

DEFINE BUTTON BtnDesFiltrar 
     LABEL "Limpiar filtros" 
     SIZE 13 BY .96.

DEFINE BUTTON btnDesMarcar 
     LABEL "Desmarcar todos" 
     SIZE 14 BY .77.

DEFINE BUTTON btnDesmarcarTodos 
     LABEL "DESMARCAR a todos" 
     SIZE 19.14 BY .92
     BGCOLOR 7 FGCOLOR 4 .

DEFINE BUTTON btnFiltrar 
     LABEL "Filtrar" 
     SIZE 12 BY .96.

DEFINE BUTTON btnGrabar 
     LABEL "Grabar los registros marcados" 
     SIZE 24 BY 1.12.

DEFINE BUTTON btnMarcar 
     LABEL "Marcar todos" 
     SIZE 13 BY .77.

DEFINE BUTTON btnSoloMarcados 
     LABEL "Mostrar solo los MARCADOS" 
     SIZE 22.72 BY .92
     BGCOLOR 7 FGCOLOR 4 .

DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE VARIABLE cboClasifica AS CHARACTER FORMAT "X(256)":U 
     LABEL "Clasificacion" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 19.86 BY 1 NO-UNDO.

DEFINE VARIABLE CboFamilia AS CHARACTER FORMAT "X(256)":U 
     LABEL "Familia" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 36 BY 1 NO-UNDO.

DEFINE VARIABLE cboInventariador AS CHARACTER FORMAT "X(256)":U 
     LABEL "Inventariador" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 29.86 BY 1 NO-UNDO.

DEFINE VARIABLE cboMarca AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 27 BY 1 NO-UNDO.

DEFINE VARIABLE cboSubFamilia AS CHARACTER FORMAT "X(256)":U 
     LABEL "SubFamilia" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 35.72 BY 1 NO-UNDO.

DEFINE VARIABLE txt-codalm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 47 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE txt-codmat AS CHARACTER FORMAT "X(6)":U 
     LABEL "Artículo" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE txtDesde AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE txtHasta AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE rbCuales AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos ", 1,
"Solo Inventariados", 2,
"Solo SIN Inventariar", 3
     SIZE 41.57 BY .96 NO-UNDO.

DEFINE VARIABLE rbUnidades AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Imp. Valorizado", 1,
"Ranking", 2
     SIZE 33 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-67
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 145 BY 2.81.

DEFINE RECTANGLE RECT-68
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 145 BY 15.96.

DEFINE RECTANGLE RECT-74
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 101.57 BY 5.46.

DEFINE RECTANGLE RECT-75
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36.14 BY 2.54.

DEFINE RECTANGLE RECT-76
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 27.86 BY 1.96.

DEFINE VARIABLE Chk3erConteo AS LOGICAL INITIAL no 
     LABEL "3er Conteo" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.

DEFINE VARIABLE ChkConteo AS LOGICAL INITIAL no 
     LABEL "Conteo" 
     VIEW-AS TOGGLE-BOX
     SIZE 9 BY .77 NO-UNDO.

DEFINE VARIABLE ChkReConteo AS LOGICAL INITIAL no 
     LABEL "Reconteo" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.

DEFINE VARIABLE tg-dif AS LOGICAL INITIAL no 
     LABEL "Solo diferencias" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      tt-InvCargaInicial, 
      Almmmatg SCROLLING.

DEFINE QUERY br_tableZona FOR 
      tt-InvcPDA SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      tt-InvCargaInicial.sContar COLUMN-LABEL "Sele" FORMAT "x":U
            WIDTH 3.29
      tt-InvCargaInicial.CodMat COLUMN-LABEL "Articulo" FORMAT "X(6)":U
            WIDTH 9.29
      Almmmatg.DesMat FORMAT "X(40)":U WIDTH 31.43
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(15)":U WIDTH 13
      Almmmatg.UndBas COLUMN-LABEL "Unidad" FORMAT "X(8)":U WIDTH 3.57
      tt-InvCargaInicial.QStkSis COLUMN-LABEL "Sistema" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 9.86
      tt-InvCargaInicial.QCont1 COLUMN-LABEL "Conteo" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 8.43
      tt-InvCargaInicial.QCont2 COLUMN-LABEL "Re-Conteo" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 8.14
      tt-InvCargaInicial.QCont3 COLUMN-LABEL "3er Conteo" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 9.14
      tt-InvCargaInicial.QInvFinal COLUMN-LABEL "Inventariado" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 9.14
      DifQty @ DifQty COLUMN-LABEL "Diferencia" FORMAT "-ZZZ,ZZZ,ZZ9.99":U
            WIDTH 8.29
      iValorizado @ iValorizado COLUMN-LABEL "Valorizado" FORMAT "->>,>>>,>>9.99":U
      DesFam @ DesFam COLUMN-LABEL "Familia" FORMAT "x(30)":U WIDTH 16.29
      dessub @ dessub COLUMN-LABEL "Sub.Familia" FORMAT "x(30)":U
            WIDTH 15.86
      tt-invCargaInicial.desmar @ tt-invCargaInicial.desmar COLUMN-LABEL "Marca"
            WIDTH 14.43
      tt-invcargainicial.clsfica @ tt-invcargainicial.clsfica COLUMN-LABEL "Clsf" FORMAT "x(25)":U
            WIDTH 7.14
      tt-invcargainicial.ranking @ tt-invcargainicial.ranking COLUMN-LABEL "Ranking" FORMAT ">,>>>,>>9":U
      tt-invCargaInicial.dusr_conteo @ tt-invCargaInicial.dusr_conteo COLUMN-LABEL "User Conteo" FORMAT "x(50)":U
            WIDTH 21.72
      tt-invCargaInicial.dusr_reconteo @ tt-invCargaInicial.dusr_reconteo COLUMN-LABEL "User Reconteo" FORMAT "x(50)":U
            WIDTH 20.29
      tt-invCargaInicial.dusr_3erconteo @ tt-invCargaInicial.dusr_3erconteo COLUMN-LABEL "User 3erConteo" FORMAT "x(50)":U
            WIDTH 19.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 142.86 BY 15.58
         FONT 4
         TITLE "Inventario de Artículos".

DEFINE BROWSE br_tableZona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_tableZona B-table-Win _STRUCTURED
  QUERY br_tableZona NO-LOCK DISPLAY
      tt-InvcPDA.CZona COLUMN-LABEL "Zona" FORMAT "x(10)":U WIDTH 12.14
      qConteo @ qConteo COLUMN-LABEL "Conteo" FORMAT ">>,>>>,>>9.99":U
            WIDTH 9.43
      qReConteo @ qReConteo COLUMN-LABEL "Reconteo" FORMAT ">>,>>>,>>9.99":U
            WIDTH 9.43
      q3erConteo @ q3erConteo COLUMN-LABEL "3er Conteo" FORMAT ">>,>>>,>>9.99":U
            WIDTH 6
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 41.86 BY 3.42
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     ChkConteo AT ROW 23.35 COL 96 WIDGET-ID 130
     BtnDesFiltrar AT ROW 22.12 COL 132.86 WIDGET-ID 122
     btnGrabar AT ROW 2.23 COL 95.14 WIDGET-ID 120
     btnFiltrar AT ROW 21 COL 133.14 WIDGET-ID 80
     btnMarcar AT ROW 24.88 COL 117.43 WIDGET-ID 94
     btnSoloMarcados AT ROW 24.23 COL 1.86 WIDGET-ID 100
     cboClasifica AT ROW 20.96 COL 53.86 COLON-ALIGNED WIDGET-ID 90
     rbUnidades AT ROW 21 COL 97.29 NO-LABEL WIDGET-ID 86
     txtDesde AT ROW 21.96 COL 100.43 COLON-ALIGNED WIDGET-ID 82
     txt-codalm AT ROW 1.54 COL 8.29 COLON-ALIGNED WIDGET-ID 30
     txt-codmat AT ROW 2.73 COL 8.29 COLON-ALIGNED WIDGET-ID 54
     tg-dif AT ROW 2.73 COL 21.72 WIDGET-ID 56
     rbCuales AT ROW 2.65 COL 37.57 NO-LABEL WIDGET-ID 66
     CboFamilia AT ROW 21.92 COL 53.72 COLON-ALIGNED WIDGET-ID 78
     cboSubFamilia AT ROW 22.85 COL 53.86 COLON-ALIGNED WIDGET-ID 74
     cboMarca AT ROW 23.85 COL 53.72 COLON-ALIGNED WIDGET-ID 76
     btn-consulta AT ROW 1.81 COL 82.14 WIDGET-ID 8
     btn-Excel AT ROW 1.69 COL 121.86 WIDGET-ID 20
     btn-exit-2 AT ROW 1.77 COL 136 WIDGET-ID 52
     br_table AT ROW 4.46 COL 3.14
     BUTTON-1 AT ROW 1.54 COL 58.29 WIDGET-ID 62
     br_tableZona AT ROW 20.42 COL 2.29 WIDGET-ID 200
     txtHasta AT ROW 21.96 COL 117 COLON-ALIGNED WIDGET-ID 84
     btnDesMarcar AT ROW 24.88 COL 131.43 WIDGET-ID 96
     btnDesmarcarTodos AT ROW 24.23 COL 25.14 WIDGET-ID 102
     cboInventariador AT ROW 24.81 COL 53.86 COLON-ALIGNED WIDGET-ID 124
     ChkReConteo AT ROW 23.35 COL 105 WIDGET-ID 132
     Chk3erConteo AT ROW 23.35 COL 116.43 WIDGET-ID 134
     "  Filtros de informacion" VIEW-AS TEXT
          SIZE 23 BY .5 AT ROW 20.35 COL 47.43 WIDGET-ID 110
          FGCOLOR 9 FONT 10
     RECT-67 AT ROW 1.27 COL 2 WIDGET-ID 32
     RECT-68 AT ROW 4.27 COL 2 WIDGET-ID 34
     RECT-74 AT ROW 20.54 COL 45.43 WIDGET-ID 108
     RECT-75 AT ROW 20.54 COL 95.72 WIDGET-ID 112
     RECT-76 AT ROW 1.73 COL 93.14 WIDGET-ID 116
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-InvCargaInicial T "?" NO-UNDO INTEGRAL InvCargaInicial
      ADDITIONAL-FIELDS:
          fields DifQty  as decimal
          fields iValorizado as decimal
          fields cSelected as char format 'x(1)'
          fields codfam as char format 'x(3)'
          fields desfam as char format 'x(30)'
          fields codsub as char format 'x(3)'
          fields dessub as char format 'x(30)'
          fields codmar as char format 'x(5)'
          fields desmar as char format 'x(30)'
          fields clsfica as char format 'x(1)'
          fields ranking as int
          fields dusr_conteo as char format 'x(50)'
          fields dusr_reconteo as char format 'x(50)'
          fields dusr_3erconteo as char format 'x(50)'
      END-FIELDS.
      TABLE: tt-InvcPDA T "?" NO-UNDO INTEGRAL InvcPDA
      ADDITIONAL-FIELDS:
          fields qConteo as dec
          fields qReconteo as dec
          fields q3erConteo as dec
      END-FIELDS.
   END-TABLES.
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 25.08
         WIDTH              = 146.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
/* BROWSE-TAB br_table btn-exit-2 F-Main */
/* BROWSE-TAB br_tableZona BUTTON-1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 2
       br_table:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.tt-InvCargaInicial,INTEGRAL.Almmmatg WHERE Temp-Tables.tt-InvCargaInicial ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _Where[1]         = "{&CONDICION}"
     _JoinCode[2]      = "almmmatg.codcia = tt-invCargaInicial.codcia and 
almmmatg.codmat = tt-invCargaInicial.codmat"
     _FldNameList[1]   > Temp-Tables.tt-InvCargaInicial.sContar
"tt-InvCargaInicial.sContar" "Sele" ? "character" ? ? ? ? ? ? no ? no no "3.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-InvCargaInicial.CodMat
"tt-InvCargaInicial.CodMat" "Articulo" ? "character" ? ? ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(40)" "character" ? ? ? ? ? ? no ? no no "31.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(15)" "character" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.Almmmatg.UndBas
"Almmmatg.UndBas" "Unidad" ? "character" ? ? ? ? ? ? no ? no no "3.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-InvCargaInicial.QStkSis
"tt-InvCargaInicial.QStkSis" "Sistema" ? "decimal" ? ? ? ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-InvCargaInicial.QCont1
"tt-InvCargaInicial.QCont1" "Conteo" ? "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-InvCargaInicial.QCont2
"tt-InvCargaInicial.QCont2" "Re-Conteo" ? "decimal" ? ? ? ? ? ? no ? no no "8.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-InvCargaInicial.QCont3
"tt-InvCargaInicial.QCont3" "3er Conteo" ? "decimal" ? ? ? ? ? ? no ? no no "9.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-InvCargaInicial.QInvFinal
"tt-InvCargaInicial.QInvFinal" "Inventariado" ? "decimal" ? ? ? ? ? ? no ? no no "9.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"DifQty @ DifQty" "Diferencia" "-ZZZ,ZZZ,ZZ9.99" ? ? ? ? ? ? ? no ? no no "8.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"iValorizado @ iValorizado" "Valorizado" "->>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"DesFam @ DesFam" "Familia" "x(30)" ? ? ? ? ? ? ? no ? no no "16.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"dessub @ dessub" "Sub.Familia" "x(30)" ? ? ? ? ? ? ? no ? no no "15.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"tt-invCargaInicial.desmar @ tt-invCargaInicial.desmar" "Marca" ? ? ? ? ? ? ? ? no ? no no "14.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > "_<CALC>"
"tt-invcargainicial.clsfica @ tt-invcargainicial.clsfica" "Clsf" "x(25)" ? ? ? ? ? ? ? no ? no no "7.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > "_<CALC>"
"tt-invcargainicial.ranking @ tt-invcargainicial.ranking" "Ranking" ">,>>>,>>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > "_<CALC>"
"tt-invCargaInicial.dusr_conteo @ tt-invCargaInicial.dusr_conteo" "User Conteo" "x(50)" ? ? ? ? ? ? ? no ? no no "21.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > "_<CALC>"
"tt-invCargaInicial.dusr_reconteo @ tt-invCargaInicial.dusr_reconteo" "User Reconteo" "x(50)" ? ? ? ? ? ? ? no ? no no "20.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > "_<CALC>"
"tt-invCargaInicial.dusr_3erconteo @ tt-invCargaInicial.dusr_3erconteo" "User 3erConteo" "x(50)" ? ? ? ? ? ? ? no ? no no "19.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_tableZona
/* Query rebuild information for BROWSE br_tableZona
     _TblList          = "Temp-Tables.tt-InvcPDA"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-InvcPDA.CZona
"CZona" "Zona" "x(10)" "character" ? ? ? ? ? ? no ? no no "12.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"qConteo @ qConteo" "Conteo" ">>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"qReConteo @ qReConteo" "Reconteo" ">>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"q3erConteo @ q3erConteo" "3er Conteo" ">>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br_tableZona */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON MOUSE-SELECT-DBLCLICK OF br_table IN FRAME F-Main /* Inventario de Artículos */
DO:
DEFINE VARIABLE iRowHeight   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iLastY       AS INTEGER     NO-UNDO.
DEFINE VARIABLE iRow         AS INTEGER     NO-UNDO.
DEFINE VARIABLE hCell        AS HANDLE      NO-UNDO.
DEFINE VARIABLE iTopRowY     AS INTEGER     NO-UNDO.

DEFINE VARIABLE dRow         AS DEC     NO-UNDO.

/* See if there are ANY rows in view... */
IF SELF:NUM-ITERATIONS = 0 THEN 
DO:
   /* No rows, the user clicked on an empty browse widget */
   RETURN NO-APPLY. 
END.

/* We don't know which row was clicked on, we have to calculate it from the mouse coordinates and the row heights. No really. */
SELF:SELECT-ROW(1).               /* Select the first row so we can get the first cell. */
hCell      = SELF:FIRST-COLUMN.   /* Get the first cell so we can get the Y coord of the first row, and the height of cells. */
iTopRowY   = hCell:Y - 1.         /* The Y coord of the top of the top row relative to the browse widget. Had to subtract 1 pixel to get it accurate. */
iRowHeight = hCell:HEIGHT-PIXELS. /* SELF:ROW-HEIGHT-PIXELS is not the same as hCell:HEIGHT-PIXELS for some reason */
iLastY     = LAST-EVENT:Y.        /* The Y position of the mouse event (relative to the browse widget) */

/* calculate which row was clicked. Truncate so that it doesn't round clicks past the middle of the row up to the next row. */
dRow       = 1 + (iLastY - iTopRowY) / iRowHeight.
iRow       = 1 + TRUNCATE((iLastY - iTopRowY) / iRowHeight, 0).

IF iRow = 1  THEN DO:
    IF dRow > 1  THEN DO:
        iRow = iRow + 1.
    END.
END.
ELSE DO:
    iRow = iRow + 1.
END.

IF iRow > 0 AND iRow <= SELF:NUM-ITERATIONS THEN 
DO:
  /* The user clicked on a populated row */
  /*Your coding here, for example:*/
    SELF:SELECT-ROW(iRow).    

    /* Que se esta procesando...2:Reconteo 3:3erConteo 4:Listado FINAL */
    IF  px-conteo = 4  THEN RETURN NO-APPLY.

    DEFINE VAR lCodMat AS CHAR.
    DEFINE VAR lAlm AS CHAR.

    lCodMat = tt-invCargaInicial.codmat.
    lAlm    = tt-invCargaInicial.codalm.

    FIND FIRST invCargaInicial WHERE invCargaInicial.codcia = s-codcia AND 
                                    invCargaInicial.codalm = lAlm AND
                                    invCargaInicial.codmat = lCodMat NO-LOCK NO-ERROR.

    IF AVAILABLE invCargaInicial THEN DO:
        IF invCargaInicial.QCont2 = ? OR invCargaInicial.QCont3 = ? THEN DO:
            IF tt-invCargaInicial.sContar = 'S' THEN DO:
                ASSIGN tt-invCargaInicial.sContar = ''.
                tt-invCargaInicial.sContar:SCREEN-VALUE IN BROWSE br_table = ''.
            END.
            ELSE DO:
                ASSIGN tt-invCargaInicial.sContar = 'S'.
                tt-invCargaInicial.sContar:SCREEN-VALUE IN BROWSE br_table = 'S'.
            END.
        END.
        ELSE DO:
            MESSAGE "Articulo ya tiene CONTEO y RECONTEO".
        END.
    END.
    
END.
ELSE DO:
  /* The click was on an empty row. */
  /*SELF:DESELECT-ROWS().*/

  RETURN NO-APPLY.
END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-DISPLAY OF br_table IN FRAME F-Main /* Inventario de Artículos */
DO:
    /*
    IF tt-almdinv.difqty <> 0 THEN
        ASSIGN tt-almdinv.difqty:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12.
    */ 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main /* Inventario de Artículos */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* Inventario de Artículos */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON START-SEARCH OF br_table IN FRAME F-Main /* Inventario de Artículos */
DO:
    DEFINE VARIABLE hSortColumn  AS WIDGET-HANDLE.
    DEFINE VARIABLE hQueryHandle AS HANDLE     NO-UNDO.

    hSortColumn = BROWSE {&BROWSE-NAME}:CURRENT-COLUMN.
    CASE hSortColumn:NAME:
        WHEN "CodMat" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'CodMat').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "DesMat" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'DesMat').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "DifQty" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'DifQty').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "iValorizado" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'iValorizado').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
    END CASE.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* Inventario de Artículos */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}

  EMPTY TEMP-TABLE tt-invCPDA.

  FOR EACH invCPDA WHERE invCPDA.codcia = s-codcia AND 
                        invCPDA.CodAlm = tt-invCargaInicial.CodAlm AND
                        invCPDA.CodMat = tt-invCargaInicial.CodMat
                        NO-LOCK:
      FIND FIRST tt-invCPDA WHERE tt-invCPDA.czona = invCPDA.czona NO-LOCK NO-ERROR.
      IF NOT AVAILABLE tt-invCPDA THEN DO:
          CREATE tt-invCPDA.
           ASSIGN tt-invCPDA.czona  = invCPDA.czona
                tt-invCPDA.qConteo = 0
                tt-invCPDA.qReConteo = 0
                tt-invCPDA.q3erConteo = 0.
            
      END.
      CASE invCPDA.sConteo:
        WHEN 1 THEN DO:
            ASSIGN tt-invCPDA.qConteo = tt-invCPDA.qConteo + invCPDA.QNeto.
        END.
        WHEN 2 THEN DO:
            ASSIGN tt-invCPDA.qReConteo = tt-invCPDA.qReConteo + invCPDA.QNeto.
        END.
        WHEN 3 THEN DO:
            ASSIGN tt-invCPDA.q3erConteo = tt-invCPDA.q3erConteo + invCPDA.QNeto.
        END.
      END CASE.
  END.

  {&OPEN-QUERY-br_tablezona}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-InvCargaInicial.sContar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-InvCargaInicial.sContar br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF tt-InvCargaInicial.sContar IN BROWSE br_table /* Sele */
DO:
  MESSAGE "XXX".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-InvCargaInicial.sContar br_table _BROWSE-COLUMN B-table-Win
ON MOUSE-SELECT-DBLCLICK OF tt-InvCargaInicial.sContar IN BROWSE br_table /* Sele */
DO:
  MESSAGE "ACA".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-consulta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-consulta B-table-Win
ON CHOOSE OF btn-consulta IN FRAME F-Main /* Button 10 */
DO:
    ASSIGN 
        txt-codalm        
        txt-codmat
        tg-dif
        rbCuales.   

    RUN Carga-Temporal.
    RUN adm-open-query.   
    EMPTY TEMP-TABLE tt-invCPDA.

    /* Zonas */
    FOR EACH invCPDA WHERE invCPDA.codcia = s-codcia AND 
                          invCPDA.CodAlm = tt-invCargaInicial.CodAlm AND
                          invCPDA.CodMat = tt-invCargaInicial.CodMat
                          NO-LOCK:
        FIND FIRST tt-invCPDA WHERE tt-invCPDA.czona = invCPDA.czona NO-LOCK NO-ERROR.
        IF NOT AVAILABLE tt-invCPDA THEN DO:
            CREATE tt-invCPDA.
             ASSIGN tt-invCPDA.czona  = invCPDA.czona
                  tt-invCPDA.qConteo = 0
                  tt-invCPDA.qReConteo = 0
                  tt-invCPDA.q3erConteo = 0.

        END.
        CASE invCPDA.sConteo:
          WHEN 1 THEN DO:
              ASSIGN tt-invCPDA.qConteo = tt-invCPDA.qConteo + invCPDA.QNeto.
          END.
          WHEN 2 THEN DO:
              ASSIGN tt-invCPDA.qReConteo = tt-invCPDA.qReConteo + invCPDA.QNeto.
          END.
          WHEN 3 THEN DO:
              ASSIGN tt-invCPDA.q3erConteo = tt-invCPDA.q3erConteo + invCPDA.QNeto.
          END.
        END CASE.
    END.

    {&OPEN-QUERY-br_tablezona}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-Excel B-table-Win
ON CHOOSE OF btn-Excel IN FRAME F-Main /* Button 1 */
DO:
    RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-exit-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-exit-2 B-table-Win
ON CHOOSE OF btn-exit-2 IN FRAME F-Main /* btn exit 2 */
DO:
  RUN adm-exit.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDesFiltrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDesFiltrar B-table-Win
ON CHOOSE OF BtnDesFiltrar IN FRAME F-Main /* Limpiar filtros */
DO:

    cboClasifica:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Todos'.
    cboFamilia:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Todos'.
    cboSubFamilia:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Todos'.
    cboMarca:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Todos'.
    cboInventariador:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Todos'.
    rbUnidades:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '1'.
    txtDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '0'.
    txtHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '0'.
    ChkConteo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'no'.
    ChkReConteo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'no'.
    Chk3erConteo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'no'.

    ASSIGN cboClasifica cboFamilia cboSubFamilia cboMarca rbUnidades cboInventariador.
    ASSIGN txtDesde txtHasta ChkConteo ChkReconteo Chk3erConteo.

    lClasificacion = cboClasifica.
    lFamilia = cboFamilia.
    lSubFamilia = cboSubFamilia.
    lMarca = cboMarca.
    lInventariador = cboInventariador.
    lUnidades = rbUnidades.
    lUndDesde = IF (txtDesde < 0) THEN 0 ELSE txtDesde.
    lUndHasta = IF (txtHasta = 0) THEN 99999999 ELSE txtHasta.
    
    IF lFamilia <> 'Todos' THEN lFamilia = SUBSTRING(lFamilia,1,3).
    IF lSubFamilia <> 'Todos' THEN lSubFamilia = SUBSTRING(lSubFamilia,1,3).
    IF lMarca <> 'Todos' THEN lMarca = SUBSTRING(lMarca,1,4).
    IF lInventariador <> 'Todos' THEN lInventariador = SUBSTRING(lInventariador,1,6).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnDesMarcar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnDesMarcar B-table-Win
ON CHOOSE OF btnDesMarcar IN FRAME F-Main /* Desmarcar todos */
DO:
    GET FIRST {&BROWSE-NAME}.
    DO  WHILE AVAILABLE tt-invCargaInicial:
        ASSIGN tt-invCargaInicial.scontar = ''.
        GET NEXT {&BROWSE-NAME}.
    END.  
    {&OPEN-QUERY-br_table}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnDesmarcarTodos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnDesmarcarTodos B-table-Win
ON CHOOSE OF btnDesmarcarTodos IN FRAME F-Main /* DESMARCAR a todos */
DO:
    DEFINE VAR lRowId AS ROWID.

    lRowId = ROWID(tt-invCargaInicial).

    FOR EACH tt-invCargaInicial :
        ASSIGN tt-invCargaInicial.scontar = ''.
    END.
    {&OPEN-QUERY-br_table}
    IF lRowId <> ? THEN DO:        
        REPOSITION br_table  TO ROWID lRowId.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnFiltrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnFiltrar B-table-Win
ON CHOOSE OF btnFiltrar IN FRAME F-Main /* Filtrar */
DO:
    ASSIGN cboClasifica cboFamilia cboSubFamilia cboMarca rbUnidades cboInventariador.
    ASSIGN txtDesde txtHasta ChkConteo ChkReconteo Chk3erConteo.

    lClasificacion = cboClasifica.
    lFamilia = cboFamilia.
    lSubFamilia = cboSubFamilia.
    lMarca = cboMarca.
    lInventariador = cboInventariador.
    lUnidades = rbUnidades.
    lUndDesde = IF (txtDesde < 0) THEN 0 ELSE txtDesde.
    lUndHasta = IF (txtHasta = 0) THEN 99999999 ELSE txtHasta.
    lVerSoloMarcados = NO.

    IF lFamilia <> 'Todos' THEN lFamilia = SUBSTRING(lFamilia,1,3).
    IF lSubFamilia <> 'Todos' THEN lSubFamilia = SUBSTRING(lSubFamilia,1,3).
    IF lMarca <> 'Todos' THEN lMarca = SUBSTRING(lMarca,1,4).
    IF lInventariador <> 'Todos' THEN lInventariador = SUBSTRING(lInventariador,1,6).

    {&OPEN-QUERY-br_table}    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnGrabar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnGrabar B-table-Win
ON CHOOSE OF btnGrabar IN FRAME F-Main /* Grabar los registros marcados */
DO:
    DEFINE VAR lxTitulo AS CHAR.

    RUN ue-que-proceso IN lh_Handle (OUTPUT px-conteo).

    IF px-Conteo = 2 THEN lxTitulo = "RECONTEO?".
    IF px-Conteo = 3 THEN lxTitulo = "3ER CONTEO?".

    MESSAGE 'Desea grabar los registros para el ' + lxTitulo VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.

    DEFINE VAR lCodMat AS CHAR.

    SESSION:SET-WAIT-STATE('GENERAL').

    IF px-Conteo = 2 THEN DO:
        FOR EACH tt-invCargaInicial /*WHERE tt-invCargaInicial.sContar = 'S' */:
            lCodMat = tt-invCargaInicial.Codmat.
            FIND FIRST invCargaInicial WHERE invCargaInicial.codcia = s-codcia AND 
                                            invCargaInicial.codalm = tt-invCargaInicial.codalm AND
                                            invCargaInicial.codmat = lCodMat  AND
                                            /*invCargaInicial.sRecontar <> 'S' AND */
                                            ( invCargaInicial.swrksele[2] = '' OR 
                                              invCargaInicial.swrksele[2] = ?)                                       
                                            EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE invCargaInicial THEN DO:
                /* 
                    Solo aquellos que tengan Conteo y aun no tengan reconteo ni 3erconteo 
                    y ademas no hayan sido seleccionados para reconteo.
                */
                IF invCargaInicial.QCont1 <> ? AND 
                    invCargaInicial.QCont2 = ? AND
                    invCargaInicial.QCont3 = ? THEN DO:
                    ASSIGN invCargaInicial.sRecontar = tt-invCargaInicial.sContar.
                END.
            END.
            RELEASE invCargaInicial.
        END.
    END.
    IF px-Conteo = 3 THEN DO:

        FOR EACH tt-invCargaInicial /*WHERE tt-invCargaInicial.sContar = 'S'*/:
            lCodMat = tt-invCargaInicial.Codmat.
            FIND FIRST invCargaInicial WHERE invCargaInicial.codcia = s-codcia AND 
                                            invCargaInicial.codalm = tt-invCargaInicial.codalm AND
                                            invCargaInicial.codmat = lCodMat AND
                                            /*
                                            (invCargaInicial.s3erRecontar = ? OR 
                                             invCargaInicial.s3erRecontar <> 'S') AND
                                             */
                                            ( invCargaInicial.swrksele[3] = '' OR 
                                              invCargaInicial.swrksele[3] = ?)                                       
                                            EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE invCargaInicial THEN DO:
                /* 
                    Solo aquellos que tengan Conteo y reconteo y aun no tenga 3erconteo
                    y ademas no haya sido seleccionado anteriormente para 3erconteo
                 */
                IF invCargaInicial.QCont1 <> ? AND 
                    invCargaInicial.QCont2 <> ? AND
                    invCargaInicial.QCont3 = ? THEN DO:
                    ASSIGN invCargaInicial.s3erRecontar = tt-invCargaInicial.sContar.
                END.
            END.
            RELEASE invCargaInicial.
        END.

    END.
    SESSION:SET-WAIT-STATE('').
    RUN adm-exit.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnMarcar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnMarcar B-table-Win
ON CHOOSE OF btnMarcar IN FRAME F-Main /* Marcar todos */
DO:
    GET FIRST {&BROWSE-NAME}.
    DO  WHILE AVAILABLE tt-invCargaInicial:
        ASSIGN tt-invCargaInicial.scontar = 'S'.
        GET NEXT {&BROWSE-NAME}.
    END.  
    {&OPEN-QUERY-br_table}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnSoloMarcados
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSoloMarcados B-table-Win
ON CHOOSE OF btnSoloMarcados IN FRAME F-Main /* Mostrar solo los MARCADOS */
DO:
    /*
  lClasificacion = 'Todos'.
  lFamilia = 'Todos'.
  lSubFamilia = 'Todos'.
  lMarca = 'Todos'.
  lUnidades = 1.
  lUndDesde = 0.
  lUndHasta = 99999999.   
  */

  APPLY 'CHOOSE':U TO BtnDesFiltrar.

  IF lVerSoloMarcados = NO THEN DO:
     btnSoloMarcados:LABEL = "Mostrar TODOS".
     lVerSoloMarcados = YES.
  END.
  ELSE DO:
     lVerSoloMarcados = NO.
     btnSoloMarcados:LABEL = "Mostrar solo los MARCADOS".     
  END.

   {&OPEN-QUERY-br_table}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:

    DEF VAR x-Almacenes AS CHAR.
    x-Almacenes = txt-CodAlm:SCREEN-VALUE.
    RUN alm/d-repalm (INPUT-OUTPUT x-Almacenes).
    txt-CodAlm:SCREEN-VALUE = x-Almacenes.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CboFamilia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CboFamilia B-table-Win
ON VALUE-CHANGED OF CboFamilia IN FRAME F-Main /* Familia */
DO:  
   DEFINE VAR lFamilia AS CHAR.

    lFamilia = trim(cboFamilia:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

    cboSubFamilia:DELETE(CboSubFamilia:LIST-ITEMS) IN FRAME {&FRAME-NAME}.
    cboSubFamilia:ADD-LAST('Todos').
    cboSubFamilia:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Todos'.

    IF lFamilia <> 'Todos'  THEN DO:
        lFamilia = SUBSTRING(lFamilia,1,3).
        FOR EACH almsfami WHERE almsfami.codcia = s-codcia AND
                        almsfami.codfam = lFamilia NO-LOCK:
          cboSubFamilia:ADD-LAST(almsfami.subfam + ' - ' + AlmsFami.dessub).
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

  RUN get-attribute ('SortBy-Case':U).
  CASE RETURN-VALUE:
    WHEN 'CodMat':U THEN DO:
      &Scope SORTBY-PHRASE BY tt-invCargaInicial.Codmat
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'DesMat':U THEN DO:
      &Scope SORTBY-PHRASE BY almmmatg.DesMat
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'DifQty':U THEN DO:
      &Scope SORTBY-PHRASE BY tt-invCargaInicial.DifQty DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'iValorizado':U THEN DO:
      &Scope SORTBY-PHRASE BY tt-invCargaInicial.iValorizado
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    OTHERWISE DO:
      &Undefine SORTBY-PHRASE
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* OTHERWISE...*/
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal B-table-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tt-invCargaInicial:
        DELETE tt-invCargaInicial.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Impresion B-table-Win 
PROCEDURE Carga-Impresion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR L-Ubica AS LOGICAL INIT YES.       
/*
    REPEAT WHILE L-Ubica:
           s-task-no = RANDOM(900000,999999).
           FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
           IF NOT AVAILABLE w-report THEN L-Ubica = NO.
    END.

    FOR EACH tt-AlmDInv NO-LOCK
        BREAK BY tt-AlmDInv.NroPagina 
            BY tt-AlmDInv.NroSecuencia:

        FIND FIRST almacen WHERE almacen.codcia = tt-almdinv.codcia
            AND almacen.codalm = tt-almdinv.codalm NO-LOCK NO-ERROR.

        CREATE w-report.
        ASSIGN
            w-report.Task-No    = s-task-no
            w-report.Llave-I    = tt-AlmDInv.CodCia
            w-report.Campo-I[1] = tt-AlmDInv.NroPagina
            w-report.Campo-I[2] = tt-AlmDInv.NroSecuencia
            w-report.Campo-C[1] = tt-AlmDInv.CodAlm
            w-report.Campo-C[2] = tt-AlmDInv.CodUbi
            w-report.Campo-C[3] = tt-AlmDInv.CodMat
            w-report.Campo-C[5] = "Almacen: " + tt-AlmDInv.CodAlm + "-" + Almacen.Descripcion
            w-report.Campo-F[1] = tt-AlmDInv.QtyFisico
            w-report.Campo-F[2] = tt-AlmDInv.QtyConteo
            w-report.Campo-F[3] = tt-AlmDInv.QtyReconteo.
            w-report.Campo-F[5] = tt-AlmDInv.libre_d02.
        /*Diferencia*/
        ASSIGN w-report.Campo-F[4] = (tt-AlmDInv.Libre_d01 - tt-AlmDInv.QtyFisico).
        IF tt-AlmDInv.CodUserRec = '' THEN w-report.Campo-C[4] = tt-AlmDInv.CodUserCon.
        ELSE w-report.Campo-C[4] = tt-AlmDInv.CodUserRec.
        DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
    END.
    HIDE FRAME f-proceso.
    */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
    DEFINE VARIABLE cAlmc     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iint      AS INTEGER     NO-UNDO.
    DEFINE VAR lDiferencias AS DEC.
    DEFINE VAR lInventariados AS LOG.
    DEFINE VAR x-ctopro AS DEC.

    DEFINE VAR lxQTodos AS INT INIT 0.
    DEFINE VAR lxQConteo AS INT INIT 0.
    DEFINE VAR lxQ2Conteo AS INT INIT 0.
    DEFINE VAR lxQ3Conteo AS INT INIT 0.
    DEFINE VAR lxQRegs AS INT INIT 0.

    DEFINE VAR lxCConteo AS CHAR INIT "".
    DEFINE VAR lxC2Conteo AS CHAR INIT "".
    DEFINE VAR lxC3Conteo AS CHAR INIT "".
    DEFINE VAR lxCRegs AS CHAR INIT "".
    DEFINE VAR lxFiler AS CHAR.

    SESSION:SET-WAIT-STATE('GENERAL').

    RUN Borra-Temporal.  

    cAlmc   = txt-CodAlm:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    DO iint = 1 TO NUM-ENTRIES(cAlmc):
        FIND FIRST invCargaInicial WHERE invCargaInicial.CodCia = s-codcia
            AND invCargaInicial.CodAlm = ENTRY(iint,calmc,",") NO-LOCK NO-ERROR.
        IF NOT AVAIL invCargaInicial THEN DO:
            MESSAGE 'Almacén ' + ENTRY(iint,calmc,",")
                    ' no Inventariado   ' SKIP
                    'o número página no encontrada'
                VIEW-AS ALERT-BOX INFO BUTTONS OK.            
        END.
    END.                        

    /* Blanqueo tt-clsfica */
    EMPTY TEMP-TABLE tt-clsfica.
    /* Que se esta procesando...2:Reconteo 3:3erConteo 4:Listado FINAL */
    RUN ue-que-proceso IN lh_Handle (OUTPUT px-conteo).

    DISABLE btn-excel  WITH FRAME {&FRAME-NAME}.
    IF px-conteo = 4 THEN DO:
        /* Solo CONSULTA */
        DISABLE btnGrabar WITH FRAME {&FRAME-NAME}.
        ENABLE btn-excel  WITH FRAME {&FRAME-NAME}.
        DISABLE btnMarcar WITH FRAME {&FRAME-NAME}.
        DISABLE btnDesmarcar WITH FRAME {&FRAME-NAME}.
        DISABLE btnDesmarcarTodos WITH FRAME {&FRAME-NAME}.
        DISABLE cboInventariador WITH FRAME {&FRAME-NAME}.
    END.

    FOR EACH invCargaInicial WHERE invCargaInicial.codcia = s-codcia AND
                        LOOKUP(TRIM(invCargaInicial.CodAlm),cAlmc) > 0 AND 
                        invCargaInicial.CodMat BEGINS txt-CodMat NO-LOCK: 

        lxQTodos = lxQTodos + 1.
        IF invCargaInicial.QCont1 <> ? THEN lxQConteo = lxQConteo + 1.
        IF invCargaInicial.QCont2 <> ? THEN lxQ2Conteo = lxQ2Conteo + 1.
        IF invCargaInicial.QCont3 <> ? THEN lxQ3Conteo = lxQ3Conteo + 1.

        /* Pide RECONTEO, si no hay CONTEO ignorar */
        IF px-Conteo = 2 AND (invCargaInicial.QCont1 = ? OR invCargaInicial.QCont2 <> ?) THEN NEXT.
        /* Pide 3erCONTEO, si no hay RECONTEO ignorar */
        IF px-Conteo = 3 AND (invCargaInicial.QCont2 = ? OR invCargaInicial.QCont3 <> ?) THEN NEXT.

/*
        /* Pide RECONTEO y ya esta MARCADO para este proceso ignorarlo */
        IF px-Conteo = 2 AND invCargaInicial.sRecontar = 'S' THEN NEXT.
        /* Pide 3erCONTEO y ya esta MARCADO para este proceso ignorarlo */
        IF px-Conteo = 3 AND invCargaInicial.s3erRecontar = 'S' THEN NEXT.
*/
        lInventariados = NO.
        IF px-conteo = 2 THEN DO:
            /* Para reconteo */
            IF invCargaInicial.QCont1 <> ? OR invCargaInicial.QCont2 = ? OR
                invCargaInicial.QCont3 <> ? THEN DO:
                lInventariados = YES.
            END.
        END.
        IF px-conteo = 3 THEN DO:
            /* Para 3er Conteo */
            IF invCargaInicial.QCont1 <> ? OR invCargaInicial.QCont2 <> ? OR
                invCargaInicial.QCont3 = ? THEN DO:
                lInventariados = YES.
            END.
        END.
        IF px-conteo = 4 THEN DO:
            /* Listado FINAL */
            IF invCargaInicial.QCont1 <> ? OR invCargaInicial.QCont2 <> ? OR
                invCargaInicial.QCont3 <> ? THEN DO:
                lInventariados = YES.
            END.
        END.

        IF (rbCuales = 1) OR (rbCuales = 2 AND lInventariados = YES ) 
            OR (rbCuales = 3 AND lInventariados = NO) THEN DO:
            IF invCargaInicial.QinvFinal = ? THEN DO:
                lDiferencias = invCargaInicial.QStkSis.
            END.
            ELSE DO:
                lDiferencias = (invCargaInicial.QinvFinal - invCargaInicial.QStkSis).
            END.

            IF NOT tg-dif OR lDiferencias <> 0 THEN DO:

                FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                            almmmatg.codmat = invCargaInicial.Codmat NO-LOCK NO-ERROR.
                IF AVAILABLE almmmatg THEN DO:
                    FIND FIRST almtfam WHERE almtfam.codcia = s-codcia AND 
                                            almtfam.codfam = almmmatg.codfam NO-LOCK NO-ERROR. 
                    FIND FIRST almsfam WHERE almsfam.codcia = s-codcia AND 
                                            almsfam.codfam = almmmatg.codfam AND 
                                            almsfam.subfam = almmmatg.subfam NO-LOCK NO-ERROR.                                  
                    FIND FIRST almtabla WHERE almtabla.tabla = 'MK' AND 
                                            almtabla.codigo = almmmatg.codmar NO-LOCK NO-ERROR. 
                END.

                CREATE tt-invCargaInicial.
                BUFFER-COPY invCargaInicial TO tt-invCargaInicial.
                ASSIGN tt-invCargaInicial.sContar = ''
                       tt-invCargaInicial.clsfica = 'Sin clasificacion'
                       tt-invCargaInicial.ranking = 999999
                        tt-invCargaInicial.codfam = ""
                        tt-invCargaInicial.codsub = ""
                        tt-invCargaInicial.codmar = ""
                        tt-invCargaInicial.desfam = ''
                        tt-invCargaInicial.dessub = ''
                        tt-invCargaInicial.desmar = ''
                        tt-invCargaInicial.dusr_conteo = ''
                        tt-invCargaInicial.dusr_reconteo = ''
                        tt-invCargaInicial.dusr_3erConteo = ''.

                        IF px-Conteo = 2 AND invCargaInicial.sRecontar = 'S' THEN ASSIGN tt-invCargaInicial.sContar = invCargaInicial.sRecontar.
                        IF px-Conteo = 3 AND invCargaInicial.s3erRecontar = 'S' THEN ASSIGN tt-invCargaInicial.sContar = invCargaInicial.s3erRecontar.

                lxQRegs = lxQRegs + 1.
                    .
                IF AVAILABLE almmmatg THEN DO:
                    ASSIGN tt-invCargaInicial.codfam = almmmatg.codfam
                            tt-invCargaInicial.codsub = almmmatg.subfam
                            tt-invCargaInicial.codmar = almmmatg.codmar
                            tt-invCargaInicial.desfam = IF(AVAILABLE almtfam) THEN almtfam.desfam ELSE ''
                            tt-invCargaInicial.dessub = IF(AVAILABLE almsfam) THEN almsfam.dessub ELSE ''
                            tt-invCargaInicial.desmar = IF(AVAILABLE almtabla) THEN almtabla.nombre ELSE ''.
                END.
                /* User Conteo */
                lxFiler = invCargaInicial.usrInventario[1].
                IF lxFiler <> ? AND lxFiler <> '' THEN DO:
                    FIND FIRST pl-pers WHERE pl-pers.codper = lxFiler NO-LOCK NO-ERROR.
                    ASSIGN tt-invCargaInicial.dusr_conteo = pl-pers.patper + " " + pl-pers.matper + " " + pl-pers.nomper.
                END.
                /* User ReConteo */
                lxFiler = invCargaInicial.usrInventario[2].
                IF lxFiler <> ? AND lxFiler <> '' THEN DO:
                    FIND FIRST pl-pers WHERE pl-pers.codper = lxFiler NO-LOCK NO-ERROR.
                    ASSIGN tt-invCargaInicial.dusr_Reconteo = pl-pers.patper + " " + pl-pers.matper + " " + pl-pers.nomper.
                END.
                /* User 3erConteo */
                lxFiler = invCargaInicial.usrInventario[3].
                IF lxFiler <> ? AND lxFiler <> '' THEN DO:
                    FIND FIRST pl-pers WHERE pl-pers.codper = lxFiler NO-LOCK NO-ERROR.
                    ASSIGN tt-invCargaInicial.dusr_3erconteo = pl-pers.patper + " " + pl-pers.matper + " " + pl-pers.nomper.
                END.


                /* Clasificacion y Ranking */
                FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                        factabla.tabla = 'RANKVTA' AND 
                        factabla.codigo = tt-invCargaInicial.Codmat NO-LOCK NO-ERROR.
                IF AVAILABLE factabla THEN DO:
                    ASSIGN tt-invCargaInicial.clsfica = if(factabla.campo-c[1]='') THEN 'Sin clasificacion' ELSE factabla.campo-c[1].
                            tt-invCargaInicial.ranking = if(factabla.valor[1] = 0) THEN 999999 ELSE factabla.valor[1].
                    IF tt-invCargaInicial.clsfica <> 'Sin clasificacion' THEN DO:
                        FIND FIRST tt-clsfica WHERE tt-clsfica = factabla.campo-c[1] NO-ERROR.
                        IF NOT AVAILABLE tt-clsfica THEN DO:
                            CREATE tt-clsfica.
                                ASSIGN tt-clsfica = factabla.campo-c[1].
                        END.
                    END.
                END.
                /* Inventariadores */
                IF px-conteo <> 4 THEN DO:
                    IF invCargaInicial.usrInventario[px-conteo - 1] <> ? AND 
                        invCargaInicial.usrInventario[px-conteo - 1 ] <> '' THEN DO:
                        FIND FIRST tt-inventariador 
                            WHERE tt-inventariador.tt-codper = invCargaInicial.usrInventario[px-conteo - 1]
                                NO-ERROR.
                        IF NOT AVAILABLE tt-inventariador THEN DO:
                            FIND FIRST pl-pers WHERE pl-pers.codper = invCargaInicial.usrInventario[px-conteo - 1]
                                    NO-LOCK NO-ERROR.
                            CREATE tt-inventariador.
                                ASSIGN tt-inventariador.tt-codper = invCargaInicial.usrInventario[px-conteo - 1].
                            IF AVAILABLE pl-pers THEN DO:
                                ASSIGN tt-inventariador.tt-nomper = pl-pers.patper + " " + pl-pers.matper + " " + pl-pers.nomper.
                            END.
                        END.
                    END.
                END.

                IF invCargaInicial.QinvFinal = ? THEN DO:
                    tt-invCargaInicial.DifQty = invCargaInicial.QStkSis.
                END.
                ELSE DO:
                    tt-invCargaInicial.DifQty = (invCargaInicial.QinvFinal - invCargaInicial.QStkSis).
                END.
                /* Valorizado */
                x-ctopro = 0.
                FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia
                    AND AlmStkGe.codmat = tt-invCargaInicial.codmat
                    AND AlmStkGe.fecha <= tt-invCargaInicial.FechInv
                    /*AND AlmStkGe.fecha <= tt-invCargaInicial.FechInv*/
                    NO-LOCK NO-ERROR.
                IF AVAILABLE AlmStkGe THEN x-ctopro = AlmStkge.CtoUni. 

                ASSIGN tt-invCargaInicial.iValorizado = tt-invCargaInicial.DifQty * x-ctopro.

            END.
        END.
    END.
    /* Cargo las Clasificaciones */
    cboClasifica:DELETE(cboClasifica:LIST-ITEMS).    
    cboClasifica:ADD-LAST('Todos').
    cboClasifica:ADD-LAST('Sin clasificacion').
    cboClasifica:SCREEN-VALUE = 'Todos'.

    FOR EACH tt-clsfica :
        cboClasifica:ADD-LAST(tt-clsfica).
    END.

    /* Cargo Inventariadores */
    cboInventariador:DELETE(cboInventariador:LIST-ITEMS).    
    cboInventariador:ADD-LAST('Todos').
    cboInventariador:SCREEN-VALUE = 'Todos'.

    FOR EACH tt-inventariador :
        cboInventariador:ADD-LAST(tt-inventariador.tt-codper + " " + tt-inventariador.tt-nomper).
    END.


    HIDE FRAME F-Proceso.

    IF lxQTodos > 0 THEN DO:
        lxCConteo = STRING( (lxQConteo / lxQTodos) * 100,">>>9.99") + "%".
        lxC2Conteo = STRING( (lxQ2Conteo / lxQTodos) * 100,">>>9.99") + "%".
        lxC3Conteo = STRING( (lxQ3Conteo / lxQTodos) * 100,">>>9.99") + "%".
        lxCRegs = STRING( (lxQRegs / lxQTodos) * 100,">>>9.99") + "%".
    END.
    br_table:TITLE = "TOTAL :" + STRING(lxQTodos,">>>,>>9") + "        " +
                        "CONTEO :" + STRING(lxQConteo,">>>,>>9") + " (" + lxCConteo  + ")" + "        " +
                        "RECONTEO :" + STRING(lxQ2Conteo,">>>,>>9") + " (" + lxC2Conteo  + ")" + "        " +
                        "3ER CONTEO :" + STRING(lxQ3Conteo,">>>,>>9") + " (" + lxC3Conteo  + ")" + "        " +
                        "UBICADOS :" + STRING(lxQRegs,">>>,>>9")  + " (" + lxCRegs  + ")".

    SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel B-table-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 5.
DEFINE VARIABLE i-Column                AS INTEGER NO-UNDO.
DEFINE VARIABLE j-Column                AS INTEGER NO-UNDO.

DEFINE VARIABLE x-DesMat AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-DesMar AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-Und    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-ctopro AS DECIMAL     NO-UNDO.

SESSION:SET-WAIT-STATE('GENERAL').

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/*Header del Excel */
cRange = "E" + '2'.
chWorkSheet:Range(cRange):Value = "LISTADO DE INVENTARIO".
cRange = "K" + '2'.
chWorkSheet:Range(cRange):Value = TODAY.
cRange = "C" + '3'.
chWorkSheet:Range(cRange):Value = "Almacen(es): ".
cRange = "D" + '3'.
chWorkSheet:Range(cRange):Value = txt-CodAlm.

/*Formato*/
chWorkSheet:Columns("A"):NumberFormat = "@".
/*
chWorkSheet:Columns("D"):NumberFormat = "@".
chWorkSheet:Columns("E"):NumberFormat = "@".
*/
/* set the column names for the Worksheet */
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Código".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripción".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Marca".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Unidad".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Costo Kardex".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Cantidad Sistema".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Cantidad Conteo".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "Cantidad Reconteo".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "3er Conteo".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "Conteo Final".
cRange = "K" + cColumn.
chWorkSheet:Range(cRange):Value = "Diferencia".
cRange = "L" + cColumn.
chWorkSheet:Range(cRange):Value = "Valorizado".

FOR EACH tt-invCargaInicial BREAK BY tt-invCargaInicial.CodAlm  :
    FIND FIRST Almmmatg WHERE Almmmatg.CodCia = s-CodCia
        AND Almmmatg.CodMat = tt-invCargaInicial.codmat NO-LOCK NO-ERROR.
    IF AVAIL Almmmatg THEN DO:
        ASSIGN 
            x-DesMat = Almmmatg.DesMat
            x-DesMar = Almmmatg.DesMar
            x-Und    = Almmmatg.UndBas.
        IF tt-invCargaInicial.CodAlm = '10' THEN x-DesMat = Almmmatg.CodBrr + "-" + Almmmatg.DesMat.
    END.
    /*Costo Promedio Kardex*/
    x-ctopro = 0.
    FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia
        AND AlmStkGe.codmat = Almmmatg.codmat
        AND AlmStkGe.fecha <= tt-invCargaInicial.FechInv
        NO-LOCK NO-ERROR.
    IF AVAILABLE AlmStkGe THEN x-ctopro = AlmStkge.CtoUni. 

    t-Column = t-Column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-invCargaInicial.codmat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = x-Desmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = x-DesMar.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = x-Und.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = x-ctopro.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-invCargaInicial.QStkSis.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-invCargaInicial.QCont1.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-invCargaInicial.QCont2.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-invCargaInicial.QCont3.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-invCargaInicial.QinvFinal.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-invCargaInicial.DifQty.
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = (tt-invCargaInicial.DifQty * x-ctopro).

END.

SESSION:SET-WAIT-STATE('').
HIDE FRAME F-Proceso.

/* launch Excel so it is visible to the user */
 chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir B-table-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
  DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
  DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
  DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
  DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */
   
  RUN Carga-Impresion.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
  RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'alm/rbalm.prl'.
  IF imp = 1 THEN RB-REPORT-NAME = 'Listado Final Inventario'.
  ELSE RB-REPORT-NAME = 'Listado Final Inventario Draft'.
  RB-INCLUDE-RECORDS = 'O'.
  RB-FILTER = "w-report.task-no = " + STRING(S-TASK-NO).

  RB-OTHER-PARAMETERS = "s-nomcia=" + s-nomcia.               

  RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                     RB-REPORT-NAME,
                     RB-INCLUDE-RECORDS,
                     RB-FILTER,
                     RB-OTHER-PARAMETERS).

    
  /*Borrando Temporal*/
  FOR EACH w-report WHERE task-no = s-task-no:
      DELETE w-report.
  END.
  s-task-no = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca B-table-Win 
PROCEDURE local-busca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'busca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /*RUN PL/C-XXX.W("").*/
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
         END.
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  DO WITH FRAME {&FRAME-NAME}.
      cboFamilia:DELIMITER = "|".
      cboSubFamilia:DELIMITER = "|".
      cboMarca:DELIMITER = "|".
      cboInventariador:DELIMITER = "|".
  END.

  /* Code placed here will execute AFTER standard behavior.    */
  cboFamilia:DELETE(CboFamilia:LIST-ITEMS) IN FRAME {&FRAME-NAME}.
  cboFamilia:ADD-LAST('Todos').
  cboFamilia:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Todos'.
  
  FOR EACH almtfami WHERE almtfami.codcia = s-codcia NO-LOCK:
    cboFamilia:ADD-LAST(almtfami.codfam + ' - ' + AlmtFami.desfam).
  END.

  cboSubFamilia:DELETE(CboSubFamilia:LIST-ITEMS) IN FRAME {&FRAME-NAME}.
  CboSubFamilia:ADD-LAST('Todos').
  cboSubFamilia:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Todos'.

  cboMarca:DELETE(CboMarca:LIST-ITEMS) IN FRAME {&FRAME-NAME}.
  CboMarca:ADD-LAST('Todos').
  cboMarca:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Todos'.

  cboClasifica:DELETE(cboClasifica:LIST-ITEMS) IN FRAME {&FRAME-NAME}.
  CboClasifica:ADD-LAST('Todos').
  cboClasifica:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Todos'.

  cboInventariador:DELETE(cboInventariador:LIST-ITEMS) IN FRAME {&FRAME-NAME}.
  CboInventariador:ADD-LAST('Todos').
  cboInventariador:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Todos'.

  FOR EACH almtabla WHERE almtabla.tabla = 'MK' NO-LOCK BY almtabla.nombre :
    cboMarca:ADD-LAST(almtabla.codigo + ' - ' + almtabla.nombre).
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros B-table-Win 
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
        WHEN "" THEN.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros B-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-InvcPDA"}
  {src/adm/template/snd-list.i "tt-InvCargaInicial"}
  {src/adm/template/snd-list.i "Almmmatg"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

