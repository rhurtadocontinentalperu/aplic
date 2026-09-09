&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE PTOSDESPACHO NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE TORDENES NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE TORDENES_PIR NO-UNDO LIKE w-report.



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
DEFINE SHARED VAR s-coddiv AS CHAR.

DEFINE VAR x-es-nuevo AS LOG INIT NO.
DEFINE VAR x-es-PIR AS LOG INIT NO.
DEFINE VAR x-PIR-actualizable AS LOG INIT NO.
DEFINE VAR x-num-pir AS CHAR.

/* Sor Column Current */
DEFINE VAR x-sort-column-current AS CHAR.
DEFINE VAR x-sort-column-test AS CHAR.

DEFINE VAR x-factabla-tabla AS CHAR INIT "PIR_PTOS_DSPCHO".

DEFINE BUFFER x-gn-divi FOR gn-divi.
DEFINE BUFFER x-faccpedi FOR faccpedi.

DEF VAR s-coddoc AS CHAR INIT 'PIR' NO-UNDO.    /* Planificador Integral de Rutas */

DEFINE BUFFER b-di-rutaC FOR di-rutaC.
DEFINE BUFFER b-di-rutaD FOR di-rutaD.

IF NOT CAN-FIND(FIRST Faccorre WHERE FacCorre.CodCia = s-codcia 
                AND FacCorre.CodDiv = s-coddiv 
                AND FacCorre.CodDoc = s-coddoc 
                AND FacCorre.FlgEst = YES
                NO-LOCK) THEN DO:
    MESSAGE "NO definido el correlativo para el documento " +  s-coddoc 
            "para la division " + s-coddiv SKIP
        'Proceso Abortado' VIEW-AS ALERT-BOX INFORMATION.
    RETURN ERROR.
END.

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
&Scoped-define INTERNAL-TABLES TORDENES PTOSDESPACHO DI-RutaC TORDENES_PIR

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 TORDENES.Campo-C[5] ~
TORDENES.Campo-C[11] TORDENES.Campo-C[12] TORDENES.Campo-C[10] ~
TORDENES.Campo-C[16] TORDENES.Campo-C[13] TORDENES.Campo-C[4] ~
TORDENES.Campo-D[1] TORDENES.Campo-D[2] TORDENES.Campo-C[1] ~
TORDENES.Campo-C[2] TORDENES.Campo-C[14] TORDENES.Campo-C[7] ~
TORDENES.Campo-C[8] TORDENES.Campo-F[1] TORDENES.Campo-I[1] ~
TORDENES.Campo-F[2] TORDENES.Campo-F[3] TORDENES.Campo-I[2] ~
TORDENES.Campo-C[9] TORDENES.Campo-C[15] TORDENES.Campo-C[29] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH TORDENES ~
      WHERE TORDENES.campo-c[30] = "" NO-LOCK ~
    BY TORDENES.Campo-C[5] ~
       BY TORDENES.Campo-C[10] ~
        BY TORDENES.Campo-C[1] ~
         BY TORDENES.Campo-C[2]
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH TORDENES ~
      WHERE TORDENES.campo-c[30] = "" NO-LOCK ~
    BY TORDENES.Campo-C[5] ~
       BY TORDENES.Campo-C[10] ~
        BY TORDENES.Campo-C[1] ~
         BY TORDENES.Campo-C[2].
&Scoped-define TABLES-IN-QUERY-BROWSE-2 TORDENES
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 TORDENES


/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 TORDENES.Campo-C[5] ~
TORDENES.Campo-C[11] TORDENES.Campo-C[12] TORDENES.Campo-C[10] ~
TORDENES.Campo-C[16] TORDENES.Campo-C[13] TORDENES.Campo-C[4] ~
TORDENES.Campo-D[1] TORDENES.Campo-D[2] TORDENES.Campo-C[1] ~
TORDENES.Campo-C[2] TORDENES.Campo-C[14] TORDENES.Campo-C[7] ~
TORDENES.Campo-C[8] TORDENES.Campo-F[1] TORDENES.Campo-I[1] ~
TORDENES.Campo-F[2] TORDENES.Campo-F[3] TORDENES.Campo-I[2] ~
TORDENES.Campo-C[9] TORDENES.Campo-C[15] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH TORDENES ~
      WHERE TORDENES.campo-c[30] = "X" NO-LOCK ~
    BY TORDENES.Campo-C[5] ~
       BY TORDENES.Campo-C[10] ~
        BY TORDENES.Campo-C[1] ~
         BY TORDENES.Campo-C[2]
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH TORDENES ~
      WHERE TORDENES.campo-c[30] = "X" NO-LOCK ~
    BY TORDENES.Campo-C[5] ~
       BY TORDENES.Campo-C[10] ~
        BY TORDENES.Campo-C[1] ~
         BY TORDENES.Campo-C[2].
&Scoped-define TABLES-IN-QUERY-BROWSE-3 TORDENES
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 TORDENES


/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 PTOSDESPACHO.Campo-L[1] ~
PTOSDESPACHO.Llave-C PTOSDESPACHO.Campo-C[1] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH PTOSDESPACHO NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH PTOSDESPACHO NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 PTOSDESPACHO
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 PTOSDESPACHO


/* Definitions for BROWSE BROWSE-7                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-7 ~
DI-RutaC.TipAyudante-1 @ x-sort-column-test DI-RutaC.CodDoc DI-RutaC.NroDoc ~
DI-RutaC.FchDoc DI-RutaC.Libre_c01 DI-RutaC.usuario 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-7 
&Scoped-define QUERY-STRING-BROWSE-7 FOR EACH DI-RutaC ~
      WHERE DI-RutaC.CodCia = s-codcia and  ~
INTEGRAL.DI-RutaC.CodDiv = s-coddiv and ~
INTEGRAL.DI-RutaC.CodDoc = s-coddoc and ~
INTEGRAL.DI-RutaC.flgest = 'P' NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-7 OPEN QUERY BROWSE-7 FOR EACH DI-RutaC ~
      WHERE DI-RutaC.CodCia = s-codcia and  ~
INTEGRAL.DI-RutaC.CodDiv = s-coddiv and ~
INTEGRAL.DI-RutaC.CodDoc = s-coddoc and ~
INTEGRAL.DI-RutaC.flgest = 'P' NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-7 DI-RutaC
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-7 DI-RutaC


/* Definitions for BROWSE BROWSE-9                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-9 TORDENES_PIR.Campo-C[11] ~
TORDENES_PIR.Campo-C[1] TORDENES_PIR.Campo-C[2] TORDENES_PIR.Campo-D[2] ~
TORDENES_PIR.Campo-D[1] TORDENES_PIR.Campo-C[10] TORDENES_PIR.Campo-C[9] ~
TORDENES_PIR.Campo-C[5] TORDENES_PIR.Campo-C[4] TORDENES_PIR.Campo-C[7] ~
TORDENES_PIR.Campo-C[8] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-9 
&Scoped-define QUERY-STRING-BROWSE-9 FOR EACH TORDENES_PIR ~
      WHERE TORDENES_PIR.campo-C[30] = "X" NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-9 OPEN QUERY BROWSE-9 FOR EACH TORDENES_PIR ~
      WHERE TORDENES_PIR.campo-C[30] = "X" NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-9 TORDENES_PIR
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-9 TORDENES_PIR


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-3}~
    ~{&OPEN-QUERY-BROWSE-5}~
    ~{&OPEN-QUERY-BROWSE-7}~
    ~{&OPEN-QUERY-BROWSE-9}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-7 FILL-IN-desde FILL-IN-hasta ~
BUTTON-1 BROWSE-5 BROWSE-9 BROWSE-2 BUTTON-cancelar BUTTON-nuevo BROWSE-3 ~
BUTTON-2 BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-desde FILL-IN-hasta FILL-IN-3 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Refrescar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL ">>>" 
     SIZE 7 BY 1.12.

DEFINE BUTTON BUTTON-3 
     LABEL "<<<" 
     SIZE 7 BY 1.12.

DEFINE BUTTON BUTTON-cancelar 
     LABEL "Cancelar" 
     SIZE 14 BY .77
     BGCOLOR 12 .

DEFINE BUTTON BUTTON-nuevo 
     LABEL "Nuevo PIR" 
     SIZE 12 BY .77
     BGCOLOR 2 .

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(100)":U INITIAL "Mensaje...." 
      VIEW-AS TEXT 
     SIZE 55 BY .62
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de entrega DESDE" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "HASTA" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      TORDENES SCROLLING.

DEFINE QUERY BROWSE-3 FOR 
      TORDENES SCROLLING.

DEFINE QUERY BROWSE-5 FOR 
      PTOSDESPACHO SCROLLING.

DEFINE QUERY BROWSE-7 FOR 
      DI-RutaC SCROLLING.

DEFINE QUERY BROWSE-9 FOR 
      TORDENES_PIR SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      TORDENES.Campo-C[5] COLUMN-LABEL "Division!Despacho" FORMAT "X(50)":U
            WIDTH 25.72
      TORDENES.Campo-C[11] COLUMN-LABEL "Embalado!Especial" FORMAT "X(8)":U
      TORDENES.Campo-C[12] COLUMN-LABEL "Provincia" FORMAT "X(40)":U
      TORDENES.Campo-C[10] COLUMN-LABEL "Distrito de entrega" FORMAT "X(40)":U
            WIDTH 24.43
      TORDENES.Campo-C[16] COLUMN-LABEL "Cod.!Ref" FORMAT "X(5)":U
      TORDENES.Campo-C[13] COLUMN-LABEL "Nro!Referencia" FORMAT "X(11)":U
      TORDENES.Campo-C[4] COLUMN-LABEL "Division!Venta" FORMAT "X(50)":U
            WIDTH 21.14
      TORDENES.Campo-D[1] COLUMN-LABEL "Emision" FORMAT "99/99/9999":U
      TORDENES.Campo-D[2] COLUMN-LABEL "Entrega" FORMAT "99/99/9999":U
            WIDTH 8.57
      TORDENES.Campo-C[1] COLUMN-LABEL "Cod!Doc" FORMAT "X(5)":U
      TORDENES.Campo-C[2] COLUMN-LABEL "Nro!Doc" FORMAT "X(10)":U
            WIDTH 9.29
      TORDENES.Campo-C[14] COLUMN-LABEL "Estado" FORMAT "X(15)":U
            WIDTH 19.57
      TORDENES.Campo-C[7] COLUMN-LABEL "Cod.Cli" FORMAT "X(13)":U
            WIDTH 10.43
      TORDENES.Campo-C[8] COLUMN-LABEL "Nombre del Cliente" FORMAT "X(80)":U
      TORDENES.Campo-F[1] COLUMN-LABEL "Monto" FORMAT "->>,>>>,>>9.99":U
      TORDENES.Campo-I[1] COLUMN-LABEL "Items" FORMAT ">>>,>>9":U
      TORDENES.Campo-F[2] COLUMN-LABEL "Peso" FORMAT ">>>,>>9.99":U
      TORDENES.Campo-F[3] COLUMN-LABEL "Volumen" FORMAT "->,>>>,>>9.99":U
      TORDENES.Campo-I[2] COLUMN-LABEL "Bultos" FORMAT ">,>>>,>>9":U
      TORDENES.Campo-C[9] COLUMN-LABEL "Direccion del Cliente" FORMAT "X(80)":U
            WIDTH 41.43
      TORDENES.Campo-C[15] COLUMN-LABEL "Glosa" FORMAT "X(50)":U
            WIDTH 47
      TORDENES.Campo-C[29] COLUMN-LABEL "PIR" FORMAT "X(11)":U
            WIDTH 10.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 85 BY 17.23
         FONT 4 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      TORDENES.Campo-C[5] COLUMN-LABEL "Division!Despacho" FORMAT "X(50)":U
            WIDTH 25.72
      TORDENES.Campo-C[11] COLUMN-LABEL "Embalado!Especial" FORMAT "X(8)":U
      TORDENES.Campo-C[12] COLUMN-LABEL "Provincia" FORMAT "X(40)":U
      TORDENES.Campo-C[10] COLUMN-LABEL "Distrito de entrega" FORMAT "X(40)":U
            WIDTH 24.43
      TORDENES.Campo-C[16] COLUMN-LABEL "Cod.!Ref" FORMAT "X(5)":U
      TORDENES.Campo-C[13] COLUMN-LABEL "Nro!Referencia" FORMAT "X(11)":U
      TORDENES.Campo-C[4] COLUMN-LABEL "Division!Venta" FORMAT "X(50)":U
            WIDTH 21.14
      TORDENES.Campo-D[1] COLUMN-LABEL "Emision" FORMAT "99/99/9999":U
      TORDENES.Campo-D[2] COLUMN-LABEL "Entrega" FORMAT "99/99/9999":U
            WIDTH 8.57
      TORDENES.Campo-C[1] COLUMN-LABEL "Cod!Doc" FORMAT "X(5)":U
      TORDENES.Campo-C[2] COLUMN-LABEL "Nro!Doc" FORMAT "X(10)":U
            WIDTH 9.29
      TORDENES.Campo-C[14] COLUMN-LABEL "Estado" FORMAT "X(15)":U
            WIDTH 19.57
      TORDENES.Campo-C[7] COLUMN-LABEL "Cod.Cli" FORMAT "X(13)":U
            WIDTH 10.43
      TORDENES.Campo-C[8] COLUMN-LABEL "Nombre del Cliente" FORMAT "X(80)":U
      TORDENES.Campo-F[1] COLUMN-LABEL "Monto" FORMAT "->>,>>>,>>9.99":U
      TORDENES.Campo-I[1] COLUMN-LABEL "Items" FORMAT ">>>,>>9":U
      TORDENES.Campo-F[2] COLUMN-LABEL "Peso" FORMAT ">>>,>>9.99":U
      TORDENES.Campo-F[3] COLUMN-LABEL "Volumen" FORMAT "->,>>>,>>9.99":U
      TORDENES.Campo-I[2] COLUMN-LABEL "Bultos" FORMAT ">,>>>,>>9":U
      TORDENES.Campo-C[9] COLUMN-LABEL "Direccion del Cliente" FORMAT "X(80)":U
            WIDTH 41.43
      TORDENES.Campo-C[15] COLUMN-LABEL "Glosa" FORMAT "X(50)":U
            WIDTH 49.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 82.72 BY 13.27
         FONT 4
         TITLE "CREANDO UNA NUEVA PIR" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      PTOSDESPACHO.Campo-L[1] COLUMN-LABEL "" FORMAT "Si/No":U
            WIDTH 4.43 VIEW-AS TOGGLE-BOX
      PTOSDESPACHO.Llave-C COLUMN-LABEL "Cod.Divi" FORMAT "x(8)":U
      PTOSDESPACHO.Campo-C[1] COLUMN-LABEL "Division Despacho" FORMAT "X(60)":U
            WIDTH 23.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 38 BY 3.54
         FONT 4 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-7 W-Win _STRUCTURED
  QUERY BROWSE-7 NO-LOCK DISPLAY
      DI-RutaC.TipAyudante-1 @ x-sort-column-test COLUMN-LABEL "Pruebas"
      DI-RutaC.CodDoc FORMAT "x(3)":U
      DI-RutaC.NroDoc FORMAT "X(9)":U WIDTH 10
      DI-RutaC.FchDoc FORMAT "99/99/9999":U
      DI-RutaC.Libre_c01 COLUMN-LABEL "Hora" FORMAT "x(8)":U
      DI-RutaC.usuario COLUMN-LABEL "Usuario" FORMAT "x(10)":U
            WIDTH 13.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 53.86 BY 7.62
         FONT 4
         TITLE "LISTA DE PIR CREADOS" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-9 W-Win _STRUCTURED
  QUERY BROWSE-9 NO-LOCK DISPLAY
      TORDENES_PIR.Campo-C[11] COLUMN-LABEL "Estado" FORMAT "X(15)":U
      TORDENES_PIR.Campo-C[1] COLUMN-LABEL "Cod.!Doc" FORMAT "X(5)":U
      TORDENES_PIR.Campo-C[2] COLUMN-LABEL "Nro.Doc" FORMAT "X(11)":U
      TORDENES_PIR.Campo-D[2] COLUMN-LABEL "Emision" FORMAT "99/99/9999":U
      TORDENES_PIR.Campo-D[1] COLUMN-LABEL "Entrega" FORMAT "99/99/9999":U
      TORDENES_PIR.Campo-C[10] COLUMN-LABEL "Distrito Entrega" FORMAT "X(50)":U
            WIDTH 25.86
      TORDENES_PIR.Campo-C[9] COLUMN-LABEL "Direccion del Cliente" FORMAT "X(80)":U
            WIDTH 29.86
      TORDENES_PIR.Campo-C[5] COLUMN-LABEL "Division despacho" FORMAT "X(40)":U
            WIDTH 20.43
      TORDENES_PIR.Campo-C[4] COLUMN-LABEL "Division Venta" FORMAT "X(50)":U
            WIDTH 23.86
      TORDENES_PIR.Campo-C[7] COLUMN-LABEL "Cod.Clie" FORMAT "X(11)":U
      TORDENES_PIR.Campo-C[8] COLUMN-LABEL "Nombre del Cliente" FORMAT "X(80)":U
            WIDTH 29.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 70 BY 9.62
         FONT 4
         TITLE "DESDE DE UNA PIR EXISTENTE" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-7 AT ROW 1.12 COL 97.14 WIDGET-ID 500
     FILL-IN-desde AT ROW 1.23 COL 21 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-hasta AT ROW 1.23 COL 41.72 COLON-ALIGNED WIDGET-ID 14
     BUTTON-1 AT ROW 1.38 COL 71 WIDGET-ID 4
     BROWSE-5 AT ROW 2.31 COL 2.14 WIDGET-ID 400
     BROWSE-9 AT ROW 3.69 COL 20 WIDGET-ID 600
     BROWSE-2 AT ROW 5.88 COL 2 WIDGET-ID 200
     BUTTON-cancelar AT ROW 8.73 COL 153.43 WIDGET-ID 16
     BUTTON-nuevo AT ROW 8.73 COL 168.43 WIDGET-ID 18
     BROWSE-3 AT ROW 9.69 COL 96.86 WIDGET-ID 700
     BUTTON-2 AT ROW 13.85 COL 88.29 WIDGET-ID 6
     BUTTON-3 AT ROW 15.35 COL 88.29 WIDGET-ID 8
     FILL-IN-3 AT ROW 8.88 COL 95 COLON-ALIGNED NO-LABEL WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 180.14 BY 22.46
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Temp-Tables and Buffers:
      TABLE: PTOSDESPACHO T "?" NO-UNDO INTEGRAL w-report
      TABLE: TORDENES T "?" NO-UNDO INTEGRAL w-report
      TABLE: TORDENES_PIR T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Planificador de Rutas"
         HEIGHT             = 22.46
         WIDTH              = 180.14
         MAX-HEIGHT         = 22.46
         MAX-WIDTH          = 194.29
         VIRTUAL-HEIGHT     = 22.46
         VIRTUAL-WIDTH      = 194.29
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
/* BROWSE-TAB BROWSE-7 1 F-Main */
/* BROWSE-TAB BROWSE-5 BUTTON-1 F-Main */
/* BROWSE-TAB BROWSE-9 BROWSE-5 F-Main */
/* BROWSE-TAB BROWSE-2 BROWSE-9 F-Main */
/* BROWSE-TAB BROWSE-3 BUTTON-nuevo F-Main */
ASSIGN 
       BROWSE-2:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

ASSIGN 
       BROWSE-3:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

ASSIGN 
       BROWSE-7:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

ASSIGN 
       BROWSE-9:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.TORDENES"
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST"
     _OrdList          = "INTEGRAL.TORDENES.Campo-C[5]|yes,INTEGRAL.TORDENES.Campo-C[10]|yes,INTEGRAL.TORDENES.Campo-C[1]|yes,INTEGRAL.TORDENES.Campo-C[2]|yes"
     _Where[1]         = "TORDENES.campo-c[30] = """""
     _FldNameList[1]   > Temp-Tables.TORDENES.Campo-C[5]
"Campo-C[5]" "Division!Despacho" "X(50)" "character" ? ? ? ? ? ? no ? no no "25.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.TORDENES.Campo-C[11]
"Campo-C[11]" "Embalado!Especial" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.TORDENES.Campo-C[12]
"Campo-C[12]" "Provincia" "X(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.TORDENES.Campo-C[10]
"Campo-C[10]" "Distrito de entrega" "X(40)" "character" ? ? ? ? ? ? no ? no no "24.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.TORDENES.Campo-C[16]
"Campo-C[16]" "Cod.!Ref" "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.TORDENES.Campo-C[13]
"Campo-C[13]" "Nro!Referencia" "X(11)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.TORDENES.Campo-C[4]
"Campo-C[4]" "Division!Venta" "X(50)" "character" ? ? ? ? ? ? no ? no no "21.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.TORDENES.Campo-D[1]
"Campo-D[1]" "Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.TORDENES.Campo-D[2]
"Campo-D[2]" "Entrega" ? "date" ? ? ? ? ? ? no ? no no "8.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.TORDENES.Campo-C[1]
"Campo-C[1]" "Cod!Doc" "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.TORDENES.Campo-C[2]
"Campo-C[2]" "Nro!Doc" "X(10)" "character" ? ? ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.TORDENES.Campo-C[14]
"Campo-C[14]" "Estado" "X(15)" "character" ? ? ? ? ? ? no ? no no "19.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.TORDENES.Campo-C[7]
"Campo-C[7]" "Cod.Cli" "X(13)" "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.TORDENES.Campo-C[8]
"Campo-C[8]" "Nombre del Cliente" "X(80)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.TORDENES.Campo-F[1]
"Campo-F[1]" "Monto" "->>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.TORDENES.Campo-I[1]
"Campo-I[1]" "Items" ">>>,>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.TORDENES.Campo-F[2]
"Campo-F[2]" "Peso" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.TORDENES.Campo-F[3]
"Campo-F[3]" "Volumen" "->,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > Temp-Tables.TORDENES.Campo-I[2]
"Campo-I[2]" "Bultos" ">,>>>,>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > Temp-Tables.TORDENES.Campo-C[9]
"Campo-C[9]" "Direccion del Cliente" "X(80)" "character" ? ? ? ? ? ? no ? no no "41.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > Temp-Tables.TORDENES.Campo-C[15]
"Campo-C[15]" "Glosa" "X(50)" "character" ? ? ? ? ? ? no ? no no "47" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > Temp-Tables.TORDENES.Campo-C[29]
"Campo-C[29]" "PIR" "X(11)" "character" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.TORDENES"
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST"
     _OrdList          = "Temp-Tables.TORDENES.Campo-C[5]|yes,Temp-Tables.TORDENES.Campo-C[10]|yes,Temp-Tables.TORDENES.Campo-C[1]|yes,Temp-Tables.TORDENES.Campo-C[2]|yes"
     _Where[1]         = "TORDENES.campo-c[30] = ""X"""
     _FldNameList[1]   > Temp-Tables.TORDENES.Campo-C[5]
"Campo-C[5]" "Division!Despacho" "X(50)" "character" ? ? ? ? ? ? no ? no no "25.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.TORDENES.Campo-C[11]
"Campo-C[11]" "Embalado!Especial" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.TORDENES.Campo-C[12]
"Campo-C[12]" "Provincia" "X(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.TORDENES.Campo-C[10]
"Campo-C[10]" "Distrito de entrega" "X(40)" "character" ? ? ? ? ? ? no ? no no "24.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.TORDENES.Campo-C[16]
"Campo-C[16]" "Cod.!Ref" "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.TORDENES.Campo-C[13]
"Campo-C[13]" "Nro!Referencia" "X(11)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.TORDENES.Campo-C[4]
"Campo-C[4]" "Division!Venta" "X(50)" "character" ? ? ? ? ? ? no ? no no "21.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.TORDENES.Campo-D[1]
"Campo-D[1]" "Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.TORDENES.Campo-D[2]
"Campo-D[2]" "Entrega" ? "date" ? ? ? ? ? ? no ? no no "8.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.TORDENES.Campo-C[1]
"Campo-C[1]" "Cod!Doc" "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.TORDENES.Campo-C[2]
"Campo-C[2]" "Nro!Doc" "X(10)" "character" ? ? ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.TORDENES.Campo-C[14]
"Campo-C[14]" "Estado" "X(15)" "character" ? ? ? ? ? ? no ? no no "19.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.TORDENES.Campo-C[7]
"Campo-C[7]" "Cod.Cli" "X(13)" "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.TORDENES.Campo-C[8]
"Campo-C[8]" "Nombre del Cliente" "X(80)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.TORDENES.Campo-F[1]
"Campo-F[1]" "Monto" "->>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.TORDENES.Campo-I[1]
"Campo-I[1]" "Items" ">>>,>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.TORDENES.Campo-F[2]
"Campo-F[2]" "Peso" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.TORDENES.Campo-F[3]
"Campo-F[3]" "Volumen" "->,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > Temp-Tables.TORDENES.Campo-I[2]
"Campo-I[2]" "Bultos" ">,>>>,>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > Temp-Tables.TORDENES.Campo-C[9]
"Campo-C[9]" "Direccion del Cliente" "X(80)" "character" ? ? ? ? ? ? no ? no no "41.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > Temp-Tables.TORDENES.Campo-C[15]
"Campo-C[15]" "Glosa" "X(50)" "character" ? ? ? ? ? ? no ? no no "49.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "Temp-Tables.PTOSDESPACHO"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.PTOSDESPACHO.Campo-L[1]
"PTOSDESPACHO.Campo-L[1]" "" ? "logical" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "TOGGLE-BOX" "?" ? ? 5 no 0 no no
     _FldNameList[2]   > Temp-Tables.PTOSDESPACHO.Llave-C
"PTOSDESPACHO.Llave-C" "Cod.Divi" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.PTOSDESPACHO.Campo-C[1]
"PTOSDESPACHO.Campo-C[1]" "Division Despacho" "X(60)" "character" ? ? ? ? ? ? no ? no no "23.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-7
/* Query rebuild information for BROWSE BROWSE-7
     _TblList          = "INTEGRAL.DI-RutaC"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "INTEGRAL.DI-RutaC.CodCia = s-codcia and 
INTEGRAL.DI-RutaC.CodDiv = s-coddiv and
INTEGRAL.DI-RutaC.CodDoc = s-coddoc and
INTEGRAL.DI-RutaC.flgest = 'P'"
     _FldNameList[1]   > "_<CALC>"
"DI-RutaC.TipAyudante-1 @ x-sort-column-test" "Pruebas" ? ? ? ? ? ? ? ? no "DI-RutaC.TipAyudante-1" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.DI-RutaC.CodDoc
     _FldNameList[3]   > INTEGRAL.DI-RutaC.NroDoc
"DI-RutaC.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = INTEGRAL.DI-RutaC.FchDoc
     _FldNameList[5]   > INTEGRAL.DI-RutaC.Libre_c01
"DI-RutaC.Libre_c01" "Hora" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.DI-RutaC.usuario
"DI-RutaC.usuario" "Usuario" ? "character" ? ? ? ? ? ? no ? no no "13.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-7 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-9
/* Query rebuild information for BROWSE BROWSE-9
     _TblList          = "Temp-Tables.TORDENES_PIR"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "TORDENES_PIR.campo-C[30] = ""X"""
     _FldNameList[1]   > Temp-Tables.TORDENES_PIR.Campo-C[11]
"TORDENES_PIR.Campo-C[11]" "Estado" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.TORDENES_PIR.Campo-C[1]
"TORDENES_PIR.Campo-C[1]" "Cod.!Doc" "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.TORDENES_PIR.Campo-C[2]
"TORDENES_PIR.Campo-C[2]" "Nro.Doc" "X(11)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.TORDENES_PIR.Campo-D[2]
"TORDENES_PIR.Campo-D[2]" "Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.TORDENES_PIR.Campo-D[1]
"TORDENES_PIR.Campo-D[1]" "Entrega" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.TORDENES_PIR.Campo-C[10]
"TORDENES_PIR.Campo-C[10]" "Distrito Entrega" "X(50)" "character" ? ? ? ? ? ? no ? no no "25.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.TORDENES_PIR.Campo-C[9]
"TORDENES_PIR.Campo-C[9]" "Direccion del Cliente" "X(80)" "character" ? ? ? ? ? ? no ? no no "29.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.TORDENES_PIR.Campo-C[5]
"TORDENES_PIR.Campo-C[5]" "Division despacho" "X(40)" "character" ? ? ? ? ? ? no ? no no "20.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.TORDENES_PIR.Campo-C[4]
"TORDENES_PIR.Campo-C[4]" "Division Venta" "X(50)" "character" ? ? ? ? ? ? no ? no no "23.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.TORDENES_PIR.Campo-C[7]
"TORDENES_PIR.Campo-C[7]" "Cod.Clie" "X(11)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.TORDENES_PIR.Campo-C[8]
"TORDENES_PIR.Campo-C[8]" "Nombre del Cliente" "X(80)" "character" ? ? ? ? ? ? no ? no no "29.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-9 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Planificador de Rutas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Planificador de Rutas */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 W-Win
ON START-SEARCH OF BROWSE-2 IN FRAME F-Main
DO:

    DEFINE VAR x-sql AS CHAR.

    x-sql = "FOR EACH TORDENES WHERE TORDENES.campo-c[30] = '' NO-LOCK ".

    {gn/sort-browse.i &ThisBrowse="browse-2" &ThisSQL = x-SQL}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&Scoped-define SELF-NAME BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-3 W-Win
ON START-SEARCH OF BROWSE-3 IN FRAME F-Main /* CREANDO UNA NUEVA PIR */
DO:

    DEFINE VAR x-sql AS CHAR.

    x-sql = "FOR EACH TORDENES WHERE TORDENES.campo-c[30] = 'X' NO-LOCK".

    {gn/sort-browse.i &ThisBrowse="browse-3" &ThisSQL = x-SQL}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-7
&Scoped-define SELF-NAME BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-7 W-Win
ON START-SEARCH OF BROWSE-7 IN FRAME F-Main /* LISTA DE PIR CREADOS */
DO:

    DEFINE VAR x-sql AS CHAR.

    x-sql = "FOR EACH DI-RutaC WHERE DI-RutaC.CodCia = " + STRING(s-codcia) + " and DI-RutaC.CodDiv = '" + s-coddiv + "' and " + 
                            "DI-RutaC.CodDoc = '" + s-coddoc + "' and DI-RutaC.flgest = 'P' NO-LOCK ".

    {gn/sort-browse.i &ThisBrowse="browse-7" &ThisSQL = x-SQL}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-7 W-Win
ON VALUE-CHANGED OF BROWSE-7 IN FRAME F-Main /* LISTA DE PIR CREADOS */
DO:
      /* Datos del PIR */
    RUN PIR-CARGAR.

    DO WITH FRAME {&FRAME-NAME}:

        {&open-query-browse-9}

    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-9
&Scoped-define SELF-NAME BROWSE-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-9 W-Win
ON START-SEARCH OF BROWSE-9 IN FRAME F-Main /* DESDE DE UNA PIR EXISTENTE */
DO:
    DEFINE VAR x-sql AS CHAR.

    x-sql = "FOR EACH TORDENES_PIR WHERE TORDENES_PIR.campo-C[30] = 'X' NO-LOCK".

    {gn/sort-browse.i &ThisBrowse="browse-9" &ThisSQL = x-SQL}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Refrescar */
DO:
  ASSIGN fill-in-desde fill-in-hasta.

  IF fill-in-desde = ? OR fill-in-hasta = ? THEN DO:
      MESSAGE "Rango de fechas estan errados".
      RETURN NO-APPLY.
  END.

  IF fill-in-desde > fill-in-hasta THEN DO:
      MESSAGE "Fecha DESDE debe ser menor/igual a HASTA".
      RETURN NO-APPLY.
  END.

  IF (fill-in-hasta - fill-in-desde) > 15 THEN DO:
      MESSAGE "Rango de fecha no debe ser mayor a 15 dias".
      RETURN NO-APPLY.
  END.

  RUN carga-temporal.

  RUN PIR-Nuevo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* >>> */
DO:

    RUN mover-registros(INPUT ">>>").
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* <<< */
DO:
  RUN mover-registros(INPUT "<<<").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-cancelar W-Win
ON CHOOSE OF BUTTON-cancelar IN FRAME F-Main /* Cancelar */
DO:
    RUN PIR-Cancelar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-nuevo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-nuevo W-Win
ON CHOOSE OF BUTTON-nuevo IN FRAME F-Main /* Nuevo PIR */
DO:
    DO WITH FRAME {&FRAME-NAME} :

        SESSION:SET-WAIT-STATE("GENERAL").

        IF LOOKUP(CAPS(BUTTON-nuevo:LABEL),"GRABAR PIR,ACTUALIZAR PIR") > 0 THEN DO:
            IF CAPS(BUTTON-nuevo:LABEL) = "GRABAR PIR" THEN DO:
                RUN PIR-Grabar-nuevo-PIR.
            END.
            ELSE DO:
                /* actualizar PIR */
                RUN PIR-actualizar-PIR.

                RUN PIR-CARGAR.

            END.
            
        END.
        ELSE DO:
            BROWSE-9:VISIBLE = NO.
            BROWSE-3:VISIBLE = YES.

            RUN PIR-Nuevo.
        END.

        SESSION:SET-WAIT-STATE("").
    END.
    

  
END.

/*
BROWSE-9:X = BROWSE-3:X.
BROWSE-9:Y = BROWSE-3:Y.
BROWSE-9:HEIGHT = BROWSE-3:HEIGHT.
BROWSE-9:WIDTH = BROWSE-3:WIDTH.


*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

ON mouse-select-down OF BROWSE {&BROWSE-NAME} ANYWHERE DO:
    DEFINE VARIABLE hColumn AS HANDLE NO-UNDO.

    ASSIGN
    hColumn = SELF:HANDLE.
    IF VALID-HANDLE(hColumn) AND hColumn:TYPE = "FILL-IN" THEN DO:
        hColumn:MOVABLE = TRUE.
        MESSAGE hColumn:LABEL.
    END.

END.

ON ENTRY OF BROWSE {&BROWSE-NAME} ANYWHERE DO:

    DEFINE VARIABLE hColumn AS HANDLE NO-UNDO.
    DEFINE VARIABLE iCounter AS INTEGER NO-UNDO.

    ASSIGN
    hColumn = SELF:HANDLE.
    IF VALID-HANDLE(hColumn) AND hColumn:TYPE = "FILL-IN" THEN DO:
        hColumn:MOVABLE = TRUE.
        
    END.


    /*
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
        */
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-ptos-despacho W-Win 
PROCEDURE carga-ptos-despacho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE PTOSDESPACHO.   

/* Cargar los puntos de despacho */
/*
EMPTY TEMP-TABLE PTOSDESPACHO.
FOR EACH almtabla WHERE almtabla.tabla = x-factabla-tabla NO-LOCK:
    CREATE PTOSDESPACHO.
        ASSIGN PTOSDESPACHO.llave-c = almtabla.codigo
                PTOSDESPACHO.campo-l[1] = YES.

END.
*/
                               
FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia AND
                        gn-divi.campo-log[1] = NO AND           /* Que NO este INACTIVO */
                        gn-divi.campo-log[5] = YES NO-LOCK:     /* Que sea CD */

        FIND FIRST almtabla WHERE almtabla.tabla = x-factabla-tabla AND
                                    almtabla.codigo = gn-divi.coddiv NO-LOCK NO-ERROR.

        IF AVAILABLE almtabla THEN DO:
            FIND FIRST PTOSDESPACHO WHERE PTOSDESPACHO.task-no = 99 AND
                                            PTOSDESPACHO.llave-c = gn-divi.coddiv EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE PTOSDESPACHO THEN DO:
                CREATE PTOSDESPACHO.
                    ASSIGN PTOSDESPACHO.task-no = 99
                            PTOSDESPACHO.llave-c = gn-divi.coddiv
                            PTOSDESPACHO.campo-c[1] = gn-divi.desdiv
                            PTOSDESPACHO.campo-l[1] = YES.

            END.
        END.
END.

{&open-query-browse-5}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-temporal W-Win 
PROCEDURE carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE TORDENES.

DEFINE VAR x-ordenes AS CHAR INIT "O/D,OTR".
DEFINE VAR x-orden AS CHAR .
DEFINE VAR x-conteo AS INT.

DEF VAR pUbigeo AS CHAR NO-UNDO.
DEF VAR pLongitud AS DEC NO-UNDO.
DEF VAR pLatitud AS DEC NO-UNDO.
DEF VAR pCuadrante AS CHAR NO-UNDO.
DEFINE VAR x-fecha-desde AS DATE.
DEFINE VAR x-estado AS CHAR.

DEFINE VAR x1 AS DATETIME.
DEFINE VAR x2 AS DATETIME.

x1 = NOW.

SESSION:SET-WAIT-STATE("GENERAL").

FOR EACH PTOSDESPACHO WHERE PTOSDESPACHO.campo-l[1] = YES NO-LOCK:

    REPEAT x-conteo = 1 TO NUM-ENTRIES(x-ordenes,","):

        x-orden = ENTRY(x-conteo,x-ordenes,",").

        /* Las O/D y OTR */
        FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia AND
                                    faccpedi.divdes = PTOSDESPACHO.llave-c AND
                                    faccpedi.coddoc = x-orden AND    
                                    faccpedi.flgest = 'P' AND 
                                    (faccpedi.fchent >= fill-in-desde AND faccpedi.fchent <= fill-in-hasta) AND 
                                    /*(faccpedi.flgsit = 'T') AND*/
                                    faccpedi.cliente_recoge = NO NO-LOCK:
    
                    /* FALTA VALIDAR QUE NO ESTE EN PHR  */
    
                /* Que la Orden no se encuentre en ninguna PIR */
                FIND FIRST di-rutaD WHERE di-rutaD.codcia = s-codcia AND
                                        di-rutaD.coddoc = s-coddoc AND
                                        di-rutaD.codref = faccpedi.coddoc AND
                                        di-rutaD.nroref = faccpedi.nroped NO-LOCK NO-ERROR.
                IF AVAILABLE di-rutaD THEN DO:
                    FIND FIRST di-rutaC OF di-rutaD NO-LOCK WHERE di-rutaC.flgest <> 'A' NO-ERROR.
    
                    IF AVAILABLE di-rutaC THEN DO:
                        NEXT.
                    END.
                END.                   
    
                CREATE TORDENES.

                {dist/PIR_datos-orden.i &wrkTORDENES="TORDENES"}.

                    /*{gn/sort-browse.i &ThisBrowse="browse-3" &ThisSQL = x-SQL}*/

                /*
                    ASSIGN  TORDENES.campo-c[1] = faccpedi.coddoc
                            TORDENES.campo-c[2] = faccpedi.nroped
                            TORDENES.campo-d[1] = faccpedi.fchped
                            TORDENES.campo-d[2] = faccpedi.fchent
                            TORDENES.campo-c[9] = faccpedi.dircli
                            TORDENES.campo-c[7] = faccpedi.codcli
                            TORDENES.campo-c[8] = faccpedi.nomcli
                            TORDENES.campo-c[5] = ""            /* Div Despacho */
                            TORDENES.campo-c[6] = faccpedi.divdes
                            TORDENES.campo-c[3] = faccpedi.coddiv
                            TORDENES.campo-c[4] = ""            /* Div venta */
                            TORDENES.campo-c[10] = ""           /* Distrio entrega */
                            TORDENES.campo-c[29] = ""           /* uso interno */
                            TORDENES.campo-c[30] = ""           /* uso interno */
                            TORDENES.campo-c[13] = faccpedi.nroref
                            TORDENES.campo-c[16] = faccpedi.codref
                            TORDENES.campo-f[1] = faccpedi.acubon[8]
                            TORDENES.campo-i[1] = faccpedi.items
                            TORDENES.campo-f[2] = faccpedi.peso
                            TORDENES.campo-f[3] = faccpedi.volumen
                            TORDENES.campo-i[2] = faccpedi.acubon[9]
                            TORDENES.campo-c[14] = ""               /* Estado de la Orden */
                            TORDENES.campo-c[12] = ""               /* Provincia */
                            TORDENES.campo-c[15] = ""               /* Glosa */
                            TORDENES.campo-c[11] = "NO"             /* Embalado especial */
                    .
                    RUN vta2/p-faccpedi-flgest(INPUT faccpedi.flgest,
                                                INPUT faccpedi.coddoc,
                                                OUTPUT x-estado).
                    ASSIGN TORDENES.campo-c[14] = x-estado.
                        
                    FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                                x-faccpedi.coddoc = faccpedi.codref AND
                                                x-faccpedi.nroped = faccpedi.nroref NO-LOCK NO-ERROR.
                    IF AVAILABLE x-faccpedi THEN DO:
                        ASSIGN TORDENES.campo-c[15] = x-faccpedi.glosa.
                        IF x-faccpedi.embalaje_especial = YES THEN TORDENES.campo-c[11] = "SI".
                    END.
    
                    FIND FIRST x-gn-divi WHERE x-gn-divi.codcia = s-codcia AND
                                                x-gn-divi.coddiv = faccpedi.coddiv NO-LOCK NO-ERROR.
                    IF AVAILABLE x-gn-divi THEN DO:
                        ASSIGN TORDENES.campo-c[4] = x-gn-divi.desdiv.
    
                    END.
                        
                    FIND FIRST x-gn-divi WHERE x-gn-divi.codcia = s-codcia AND
                                                x-gn-divi.coddiv = faccpedi.divdes NO-LOCK NO-ERROR.
                    
                    IF AVAILABLE x-gn-divi THEN DO:
                        ASSIGN TORDENES.campo-c[5] = x-gn-divi.desdiv.
                    END.
    
                RUN logis/p-datos-sede-auxiliar (
                  FacCPedi.Ubigeo[2],   /* ClfAux @CL @PV */
                  FacCPedi.Ubigeo[3],   /* Auxiliar */
                  FacCPedi.Ubigeo[1],   /* Sede */
                  OUTPUT pUbigeo,
                  OUTPUT pLongitud,
                  OUTPUT pLatitud).
    
                FIND FIRST TabProvi WHERE TabProvi.CodDepto = SUBSTRING(pUbigeo,1,2)
                  AND TabProvi.CodProvi = SUBSTRING(pUbigeo,3,2) NO-LOCK NO-ERROR.
                IF AVAILABLE TabProvi THEN DO:
                    ASSIGN TORDENES.campo-c[12] = TabProvi.NomProvi.
                END.
    
                FIND FIRST TabDistr WHERE TabDistr.CodDepto = SUBSTRING(pUbigeo,1,2)
                  AND TabDistr.CodProvi = SUBSTRING(pUbigeo,3,2)
                  AND TabDistr.CodDistr = SUBSTRING(pUbigeo,5,2)
                  NO-LOCK NO-ERROR.
                IF AVAILABLE TabDistr THEN DO:
                    ASSIGN TORDENES.campo-c[10] = TabDistr.NomDistr.
                END.       
                */
        END.   
    END.
END.

{&open-query-browse-2}
{&open-query-browse-3}
{&open-query-browse-5}
{&open-query-browse-7}

SESSION:SET-WAIT-STATE("").

x2 = NOW.

/*
MESSAGE x1 SKIP
        x2.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE crear-pir-nuevo W-Win 
PROCEDURE crear-pir-nuevo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/



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
  DISPLAY FILL-IN-desde FILL-IN-hasta FILL-IN-3 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-7 FILL-IN-desde FILL-IN-hasta BUTTON-1 BROWSE-5 BROWSE-9 
         BROWSE-2 BUTTON-cancelar BUTTON-nuevo BROWSE-3 BUTTON-2 BUTTON-3 
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
  fill-in-desde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 3,"99/99/9999").
  fill-in-hasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY + 3,"99/99/9999").

  RUN carga-ptos-despacho.

  button-cancelar:VISIBLE IN FRAME {&FRAME-NAME} = NO.
  button-nuevo:VISIBLE IN FRAME {&FRAME-NAME} = NO.

  browse-9:VISIBLE IN FRAME {&FRAME-NAME} = NO.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MOVER-registros W-Win 
PROCEDURE MOVER-registros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pDireccion AS CHAR NO-UNDO.

DEFINE VAR x-origen AS HANDLE.
DEFINE VAR x-destino AS HANDLE.
DEFINE VAR x-tot AS INT.
DEFINE VAR x-sec AS INT.
DEFINE VAR x-value AS CHAR INIT "".

DO WITH FRAME {&FRAME-NAME}:
    
    IF pDireccion <> "Cancelar" THEN DO:
        IF CAPS(button-nuevo:LABEL) = "NUEVO PIR" OR
            CAPS(button-nuevo:LABEL) = "GRABAR PIR"  THEN DO:
            IF pDireccion = ">>>" THEN DO:
                x-origen = browse-2:HANDLE.
                x-destino = browse-3:HANDLE.
                x-value = "X".
            END.
            ELSE DO:
                x-origen = browse-3:HANDLE.
                x-destino = browse-2:HANDLE.
            END.    
            x-tot = x-origen:NUM-SELECTED-ROWS.

            DO x-sec = 1 TO x-tot :
                IF x-origen:FETCH-SELECTED-ROW(x-sec) THEN DO:
                    ASSIGN {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-c[30] = x-value.
                END.
            END.
        END.
        ELSE DO:
            /**/
            IF pDireccion = ">>>" THEN DO:
                x-origen = browse-2:HANDLE.
                x-destino = browse-9:HANDLE.                
                x-value = "X".
            END.
            ELSE DO:
                x-origen = browse-9:HANDLE.
                x-destino = browse-2:HANDLE.                
            END.    
            x-tot = x-origen:NUM-SELECTED-ROWS.

            /* Marco/Desmarco  */
            DO x-sec = 1 TO x-tot :
                IF x-origen:FETCH-SELECTED-ROW(x-sec) THEN DO:
                    IF pDireccion = ">>>" THEN DO:
                        ASSIGN {&FIRST-TABLE-IN-QUERY-BROWSE-2}.campo-c[30] = x-value.
                        ASSIGN {&FIRST-TABLE-IN-QUERY-BROWSE-2}.campo-c[25] = "X".
                    END.
                    ELSE DO:
                        ASSIGN {&FIRST-TABLE-IN-QUERY-BROWSE-9}.campo-c[30] = x-value.
                        ASSIGN {&FIRST-TABLE-IN-QUERY-BROWSE-9}.campo-c[25] = "X".
                    END.
                END.
            END.
            /* Muevo */
            IF pDireccion = ">>>" THEN DO:
                FOR EACH TORDENES WHERE TORDENES.campo-c[25] = "X":
                    FIND FIRST TORDENES_PIR WHERE TORDENES_PIR.campo-c[1] = TORDENES.campo-c[1] AND
                                                TORDENES_PIR.campo-c[2] = TORDENES.campo-c[2]
                                                EXCLUSIVE-LOCK NO-ERROR.
                    IF NOT AVAILABLE TORDENES_PIR THEN DO:
                        CREATE TORDENES_PIR.
                    END.
                    BUFFER-COPY TORDENES TO TORDENES_PIR.
                    
                END.
            END.
            ELSE DO:
                FOR EACH TORDENES_PIR WHERE TORDENES_PIR.campo-c[25] = "X":
                    
                    FIND FIRST TORDENES WHERE TORDENES.campo-c[1] = TORDENES_PIR.campo-c[1] AND
                                                TORDENES.campo-c[2] = TORDENES_PIR.campo-c[2]
                                                EXCLUSIVE-LOCK NO-ERROR.
                    IF NOT AVAILABLE TORDENES THEN DO:
                        CREATE TORDENES.
                    END.
                    BUFFER-COPY TORDENES_PIR TO TORDENES.                    
                END.
            END.

        END.
    END.
END.

DO WITH FRAME {&FRAME-NAME}:
    IF pDireccion = "Cancelar" THEN DO: 
        IF CAPS(button-nuevo:LABEL) = "NUEVO PIR" OR
            CAPS(button-nuevo:LABEL) = "GRABAR PIR"  THEN DO:
    
            GET FIRST browse-3.
            DO  WHILE AVAILABLE TORDENES:            
                ASSIGN TORDENES.campo-c[30] = ''.
                GET NEXT Browse-3.
            END.
        END.
        ELSE DO:
            /**/

            RUN PIR-CARGAR.

            x-sec = 0.
            x-tot = 0.
            FOR EACH TORDENES :
                IF TORDENES.campo-c[29] = x-num-pir THEN DO:
                    DELETE TORDENES.
                    x-sec = x-sec + 1.
                END.
                ELSE DO:
                    ASSIGN TORDENES.campo-c[30] = "".
                    x-tot = x-tot + 1.
                END.                
            END.

        END.
    END.
END.

{&open-query-browse-2}
{&open-query-browse-3}
{&open-query-browse-9}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PIR-Actualizar-PIR W-Win 
PROCEDURE PIR-Actualizar-PIR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-proceso AS CHAR INIT "OK".    
    
DEFINE VAR x-rowid AS ROWID.



GRABAR_DATOS:
DO TRANSACTION ON ERROR UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS ON STOP UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS:
        /*
        CREATE b-DI-RutaC.
        ASSIGN
            b-DI-RutaC.CodCia = s-codcia
            b-DI-RutaC.CodDiv = s-coddiv
            b-DI-RutaC.CodDoc = s-coddoc
            b-DI-RutaC.FchDoc = TODAY
            b-DI-RutaC.NroDoc = STRING(x-serie, "999") + STRING(x-numero, "999999")
            b-DI-RutaC.codrut = "AUTOMATICO"    /*pGlosa*/
            b-DI-RutaC.observ = ""
            b-DI-RutaC.usuario = USERID("DICTDB")
            b-DI-RutaC.flgest  = "P"     /* Pendiente x Pickear*/
            b-DI-RutaC.libre_c01 = STRING(TIME,"HH:MM:SS")
            NO-ERROR.
                
        IF ERROR-STATUS:ERROR = YES  THEN DO:
            x-Proceso = "Hubo problemas al intentrar grabar en la tabla Di-RUTAC".
            UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
        END.
        */

    FIND FIRST b-di-rutaC WHERE b-di-rutaC.codcia = s-codcia AND
                                b-di-rutaC.coddoc = s-coddoc AND
                                b-di-rutaC.nrodoc = x-num-pir EXCLUSIVE-LOCK NO-ERROR.

    IF ERROR-STATUS:ERROR = YES  THEN DO:
        x-Proceso = "Hubo problemas cuando buscaba el PIR en DI-RUTAC".
        UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
    END.

    FOR EACH di-rutaD OF b-di-rutaC NO-LOCK:
        x-rowid = ROWID(di-rutaD).
        FIND FIRST b-di-rutaD WHERE ROWID(b-di-rutaD) = x-rowid EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR = YES  THEN DO:
            x-Proceso = "Hubo problemas al intentrar ELIMINAR orden de DI-RUTAD".
            UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
        END.
        DELETE b-di-rutaD.
    END.

    /* Las Ordenes */
    FOR EACH TORDENES_PIR WHERE TORDENES_PIR.campo-c[30] = "X" NO-LOCK:
        CREATE b-DI-RutaD.
        ASSIGN
            b-DI-RutaD.CodCia = b-DI-RutaC.CodCia
            b-DI-RutaD.CodDiv = b-DI-RutaC.CodDiv
            b-DI-RutaD.CodDoc = b-DI-RutaC.CodDoc
            b-DI-RutaD.NroDoc = b-DI-RutaC.NroDoc
            b-DI-RutaD.CodRef = TORDENES_PIR.campo-c[1]
            b-DI-RutaD.NroRef = TORDENES_PIR.campo-c[2]
            NO-ERROR.

        IF ERROR-STATUS:ERROR = YES  THEN DO:
            x-Proceso = "Hubo problemas al intentrar ADICIONAR en la tabla Di-RUTAD".
            UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
        END.
    END.

    FOR EACH TORDENES_PIR WHERE TORDENES_PIR.campo-c[30] = 'X' NO-LOCK:
        FIND FIRST TORDENES WHERE TORDENES.campo-c[1] = TORDENES_PIR.campo-c[1] AND
                                    TORDENES.campo-c[2] = TORDENES_PIR.campo-c[2] EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE TORDENES THEN DELETE TORDENES.
    END.
END.

RELEASE b-di-rutaC NO-ERROR.
RELEASE b-di-rutaD NO-ERROR.

IF x-proceso = "OK" THEN DO:
    MESSAGE "Se ACTUALIZO correctamente el PIR : " + x-num-pir
        VIEW-AS ALERT-BOX INFORMATION.

END.
ELSE DO:
    MESSAGE "Hubo PROBLEMAS al ACTUALIZAR elPIR " + x-num-pir SKIP
            x-proceso
        VIEW-AS ALERT-BOX INFORMATION.

END.

{&open-query-browse-2}
{&open-query-browse-3}
{&open-query-browse-5}
{&open-query-browse-7}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PIR-Cancelar W-Win 
PROCEDURE PIR-Cancelar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    IF CAPS(button-cancelar:LABEL) =  "CANCELAR" THEN DO:

        IF CAPS(button-nuevo:LABEL) = "GRABAR PIR" OR 
            CAPS(button-nuevo:LABEL) = "NUEVO PIR" THEN DO:

            RUN mover-registros(INPUT "Cancelar").                                                        

            /*button-cancelar:VISIBLE = NO.*/
            button-nuevo:VISIBLE = YES.            

            x-es-nuevo = NO.
            x-es-PIR = YES.

            /* ---------- */
            BROWSE-9:X = BROWSE-3:X.
            BROWSE-9:Y = BROWSE-3:Y.
            BROWSE-9:HEIGHT = BROWSE-3:HEIGHT.
            BROWSE-9:WIDTH = BROWSE-3:WIDTH.

            BROWSE-9:VISIBLE = YES.
            BROWSE-3:VISIBLE = NO.

            /* Datos del PIR */
            RUN PIR-CARGAR.
        END.
        ELSE DO:
            /* Cancela Actualizacion */
            /*
            button-nuevo:LABEL = "NUEVO PIR".
            BROWSE-9:VISIBLE = NO.
            BROWSE-3:VISIBLE = YES.
            */            

            RUN mover-registros(INPUT "Cancelar").
            RUN PIR-Nuevo.

        END.


    END.

END.

{&open-query-browse-2}
{&open-query-browse-3}
{&open-query-browse-9}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PIR-CARGAR W-Win 
PROCEDURE PIR-CARGAR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE TORDENES_PIR.

    DEF VAR pUbigeo AS CHAR NO-UNDO.
    DEF VAR pLongitud AS DEC NO-UNDO.
    DEF VAR pLatitud AS DEC NO-UNDO.
    DEF VAR pCuadrante AS CHAR NO-UNDO.
    DEFINE VAR x-estado AS CHAR.

    x-PIR-actualizable = YES.

    x-num-pir = "".
    
    IF AVAILABLE di-rutaC THEN DO:

        x-num-pir = di-rutaC.nrodoc.

        FOR EACH di-rutaD OF di-rutaC NO-LOCK:
    
            CREATE TORDENES_PIR.
            ASSIGN TORDENES_PIR.campo-c[1] = di-rutaD.codref
                    TORDENES_PIR.campo-c[2] = di-rutaD.nroref
                    TORDENES_PIR.campo-c[10] = ""
                    TORDENES_PIR.campo-c[29] = di-rutaC.nrodoc          /* Indicador de que pertenece a un PIR */
                    /*TORDENES_PIR.campo-c[11] = "ERROR"*/
                    TORDENES_PIR.campo-c[30] = "X"
                .
            FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                                        faccpedi.coddoc = di-rutaD.codref AND
                                        faccpedi.nroped = di-rutaD.nroref NO-LOCK NO-ERROR.
            IF AVAILABLE faccpedi THEN DO:
                
                {dist/PIR_datos-orden.i &wrkTORDENES="TORDENES_PIR"}.

                ASSIGN TORDENES_PIR.campo-c[30] = "X".

                /*
                ASSIGN
                TORDENES_PIR.campo-d[1] = faccpedi.fchped
                TORDENES_PIR.campo-d[2] = faccpedi.fchent
                TORDENES_PIR.campo-c[9] = faccpedi.dircli
                TORDENES_PIR.campo-c[7] = faccpedi.codcli
                TORDENES_PIR.campo-c[8] = faccpedi.nomcli
                TORDENES_PIR.campo-c[5] = ""
                TORDENES_PIR.campo-c[6] = faccpedi.divdes
                TORDENES_PIR.campo-c[3] = faccpedi.coddiv
                TORDENES_PIR.campo-c[4] = ""
                TORDENES_PIR.campo-c[10] = ""
                TORDENES_PIR.campo-c[11] = "OK"
                .
                IF (faccpedi.flgest <> "P") OR (faccpedi.flgsit <> "T") THEN DO:
                    ASSIGN TORDENES_PIR.campo-c[10] = "PROCESO LOGISTICO".
                    x-PIR-actualizable = NO.
                END.
                    
                IF faccpedi.flgest = "A" THEN DO:
                    TORDENES_PIR.campo-c[10] = "ORDEN ANULADO".
                END.
                    
                /**/
                FIND FIRST x-gn-divi WHERE x-gn-divi.codcia = s-codcia AND
                                            x-gn-divi.coddiv = faccpedi.coddiv NO-LOCK NO-ERROR.
                IF AVAILABLE x-gn-divi THEN DO:
                    ASSIGN TORDENES_PIR.campo-c[4] = x-gn-divi.desdiv.
                END.

                FIND FIRST x-gn-divi WHERE x-gn-divi.codcia = s-codcia AND
                                            x-gn-divi.coddiv = faccpedi.divdes NO-LOCK NO-ERROR.
                
                IF AVAILABLE x-gn-divi THEN DO:
                    ASSIGN TORDENES_PIR.campo-c[5] = x-gn-divi.desdiv.
                END.

              RUN logis/p-datos-sede-auxiliar (
                  FacCPedi.Ubigeo[2],   /* ClfAux @CL @PV */
                  FacCPedi.Ubigeo[3],   /* Auxiliar */
                  FacCPedi.Ubigeo[1],   /* Sede */
                  OUTPUT pUbigeo,
                  OUTPUT pLongitud,
                  OUTPUT pLatitud).
    
              FIND FIRST TabDistr WHERE TabDistr.CodDepto = SUBSTRING(pUbigeo,1,2)
                  AND TabDistr.CodProvi = SUBSTRING(pUbigeo,3,2)
                  AND TabDistr.CodDistr = SUBSTRING(pUbigeo,5,2)
                  NO-LOCK NO-ERROR.
                IF AVAILABLE TabDistr THEN DO:
                    ASSIGN TORDENES_PIR.campo-c[10] = TabDistr.NomDistr.
                END.
            */                
            END.
        END.
    END.
    ELSE DO:
        x-PIR-actualizable = NO.
    END.
    
    DO WITH FRAME {&FRAME-NAME}:

        IF browse-9:VISIBLE = YES THEN DO:
            IF CAPS(button-nuevo:LABEL) = "NUEVO PIR" OR 
                CAPS(button-nuevo:LABEL) = "GRABAR PIR" THEN  DO:
                button-nuevo:LABEL = "Actualizar PIR".
            END.

            fill-in-3:SCREEN-VALUE = "SE ESTA ACTUALIZANDO AL PIR " + x-num-pir.
            browse-9:TITLE = "ORDENES CONTENIDAS EN LA PIR " + x-num-pir.

            {&open-query-browse-9}

        END.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PIR-Grabar-Nuevo-PIR W-Win 
PROCEDURE PIR-Grabar-Nuevo-PIR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-proceso AS CHAR INIT "OK".    
    
FIND FIRST TORDENES WHERE TORDENES.campo-c[30] = 'X' NO-LOCK NO-ERROR.
IF NOT AVAILABLE TORDENES THEN RETURN.

DEFINE VAR x-numero AS INT.
DEFINE VAR x-serie AS INT.

GRABAR_DATOS:
DO TRANSACTION ON ERROR UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS ON STOP UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS:
    DO:
        FIND FIRST faccorre WHERE FacCorre.CodCia = s-codcia AND
            faccorre.coddiv = s-coddiv AND
            faccorre.coddoc = s-coddoc AND
            faccorre.flgest = YES EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE faccorre THEN DO:
            x-Proceso = "Hubo problemas para generar el Correlativo".
            UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
        END.        

        x-numero = faccorre.correlativo.
        x-serie = FacCorre.nroser.

        ASSIGN faccorre.correlativo = faccorre.correlativo + 1 .

        CREATE b-DI-RutaC.
        ASSIGN
            b-DI-RutaC.CodCia = s-codcia
            b-DI-RutaC.CodDiv = s-coddiv
            b-DI-RutaC.CodDoc = s-coddoc
            b-DI-RutaC.FchDoc = TODAY
            b-DI-RutaC.NroDoc = STRING(x-serie, "999") + STRING(x-numero, "999999")
            b-DI-RutaC.codrut = "AUTOMATICO"    /*pGlosa*/
            b-DI-RutaC.observ = ""
            b-DI-RutaC.usuario = USERID("DICTDB")
            b-DI-RutaC.flgest  = "P"     /* Pendiente x Pickear*/
            b-DI-RutaC.libre_c01 = STRING(TIME,"HH:MM:SS")
            NO-ERROR.
        
        IF ERROR-STATUS:ERROR = YES  THEN DO:
            x-Proceso = "Hubo problemas al intentrar grabar en la tabla Di-RUTAC".
            UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
        END.

    END.

    /* Las Ordenes */
    FOR EACH TORDENES WHERE TORDENES.campo-c[30] = 'X' NO-LOCK:
        CREATE b-DI-RutaD.
        ASSIGN
            b-DI-RutaD.CodCia = b-DI-RutaC.CodCia
            b-DI-RutaD.CodDiv = b-DI-RutaC.CodDiv
            b-DI-RutaD.CodDoc = b-DI-RutaC.CodDoc
            b-DI-RutaD.NroDoc = b-DI-RutaC.NroDoc
            b-DI-RutaD.CodRef = TORDENES.campo-c[1]
            b-DI-RutaD.NroRef = TORDENES.campo-c[2]
            NO-ERROR.

        IF ERROR-STATUS:ERROR = YES  THEN DO:
            x-Proceso = "Hubo problemas al intentrar grabar en la tabla Di-RUTAD".
            UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
        END.
    END.

    FOR EACH TORDENES WHERE TORDENES.campo-c[30] = 'X':
        DELETE TORDENES.
    END.
END.

RELEASE b-di-rutaC NO-ERROR.
RELEASE b-di-rutaD NO-ERROR.
RELEASE faccorre NO-ERROR.

IF x-proceso = "OK" THEN DO:
    MESSAGE "Se genero el Nro. de PIR :" + 
        STRING(x-serie, '999') + STRING(x-numero, '999999')
        VIEW-AS ALERT-BOX INFORMATION.

END.
ELSE DO:
    MESSAGE "Hubo PROBLEMAS al grabar el nuevo PIR" SKIP
            x-proceso
        VIEW-AS ALERT-BOX INFORMATION.

END.

{&open-query-browse-2}
{&open-query-browse-3}
{&open-query-browse-5}
{&open-query-browse-7}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PIR-Nuevo W-Win 
PROCEDURE PIR-Nuevo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    button-cancelar:VISIBLE = YES.
    button-nuevo:VISIBLE = YES.
    button-nuevo:LABEL = "GRABAR PIR".

    x-es-nuevo = YES.
    x-es-PIR = NO.

    browse-3:VISIBLE = YES.
    browse-9:VISIBLE = NO.

    fill-in-3:SCREEN-VALUE = "SE ESTA CREANDO UNA NUEVA PIR ".

    browse-3:TITLE = "ORDENES PARA LA NUEVA PIR".
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
  {src/adm/template/snd-list.i "TORDENES_PIR"}
  {src/adm/template/snd-list.i "DI-RutaC"}
  {src/adm/template/snd-list.i "PTOSDESPACHO"}
  {src/adm/template/snd-list.i "TORDENES"}

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

