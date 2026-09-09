&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE eve-w-report NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE tt-w-report NO-UNDO LIKE w-report.



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
DEFINE INPUT PARAMETER pConcepto AS CHAR.

/* Local Variable Definitions ---                                       */

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.

FIND FIRST factabla WHERE factabla.codcia = s-codcia AND
                            factabla.tabla = 'REBATE' NO-LOCK NO-ERROR.

IF NOT AVAILABLE factabla THEN DO:
    MESSAGE "Aun no se han creado el/los proceso(s) de Rebate"
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN ERROR.
END.

DEFINE VAR x-proceso AS CHAR.
DEFINE VAR x-tipo-dcmtos AS CHAR.
DEFINE VAR x-concepto-rebate AS CHAR.

x-concepto-rebate = pConcepto.

FIND FIRST ccbtabla WHERE ccbtabla.codcia = s-codcia AND
                            ccbtabla.tabla = 'N/C' AND 
                            ccbtabla.codigo = x-concepto-rebate NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbtabla THEN DO:
    MESSAGE "Concepto de rebate(" + x-concepto-rebate + ") no esta creado"
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN ERROR.
END.

DEFINE VAR x-cobranzas-desde AS DATE.
DEFINE VAR x-cobranzas-hasta AS DATE.

DEFINE VAR x-factor-premio1 AS DEC INIT 0.
DEFINE VAR x-factor-premio2 AS DEC INIT 0.
DEFINE VAR x-factor-premio3 AS DEC INIT 0.

/*  */
DEFINE TEMP-TABLE tt-lineas
    FIELD trazon    AS  CHAR    FORMAT 'x(10)'
    FIELD tcodfam   AS  CHAR
    FIELD tsubfam   AS  CHAR
    FIELD tmarca   AS  CHAR.

DEFINE TEMP-TABLE tt-lineas-gen-pnc
    FIELD trazon    AS  CHAR
    FIELD tcodfam   AS  CHAR
    FIELD tsubfam   AS  CHAR.

DEFINE TEMP-TABLE tt-agrupador
    FIELD tagrupador AS CHAR.

DEFINE TEMP-TABLE tt-eventos
    FIELD trazon    AS  CHAR
    FIELD tcoddiv   AS  CHAR.

DEFINE TEMP-TABLE tt-canjes
    FIELD tcoddoc   AS  CHAR
    FIELD tnrodoc   AS  CHAR.

DEFINE TEMP-TABLE tt-comprobantes
    FIELD tcoddoc   AS  CHAR
    FIELD tnrodoc   AS  CHAR
    FIELD tcodcli   AS  CHAR
    FIELD tnomcli   AS  CHAR
    FIELD tfchdoc    AS  DATE
    FIELD tcodmon   AS  INT
    FIELD titotal   AS  DEC     COLUMN-LABEL "Importe Total Comprobante"
    FIELD timptot   AS  DEC     COLUMN-LABEL "Importe para la Meta"
    FIELD timppremio AS  DEC     COLUMN-LABEL "Importe para el premio"
    FIELD ttpocmb   AS  DEC
    FIELD tcodcanc   AS  CHAR
    FIELD tnrocanc   AS  CHAR
    FIELD tfchcanc   AS  DATE
    FIELD timpcanc AS DEC
    FIELD tdoc-meta    AS  LOG INIT NO
    FIELD tdoc-premio  AS  LOG INIT NO
    FIELD tgrupo-docs AS    CHAR  INIT ""      /* El documento es de Campaña / No Campaña */
    .
DEFINE TEMP-TABLE tt-comprobantes-dtl
    FIELD tcoddoc   AS  CHAR    COLUMN-LABEL "Tipo Doc."
    FIELD tnrodoc   AS  CHAR    COLUMN-LABEL "Numero"
    FIELD tcodcli   AS  CHAR    COLUMN-LABEL "Cod.Cliente"
    FIELD tnomcli   AS  CHAR    COLUMN-LABEL "Nombre del Cliente"
    FIELD tfchdoc   AS  DATE    COLUMN-LABEL "Fecha de emision"
    FIELD tdoc-meta    AS  LOG INIT NO COLUMN-LABEL "Meta"
    FIELD tdoc-premio  AS  LOG INIT NO  COLUMN-LABEL "Premio"
    FIELD tgrupo-docs AS    CHAR  INIT ""  COLUMN-LABEL "Campaña / No Campaña"
    FIELD tcodmat  LIKE    Ccbddocu.codmat COLUMN-LABEL "Codigo Articulo"
    FIELD tdesmat  LIKE    Ccbddocu.codmat COLUMN-LABEL "Descripcion Articulo"
    FIELD tfactor  LIKE    Ccbddocu.factor COLUMN-LABEL "Factor Eqv"
    FIELD tcandes  LIKE    Ccbddocu.candes COLUMN-LABEL "Cantidad"
    FIELD tpreuni  LIKE    Ccbddocu.preuni COLUMN-LABEL "P.Unitario"
    FIELD timplin  LIKE    Ccbddocu.implin COLUMN-LABEL "Importe"
    FIELD tundvta  LIKE    Ccbddocu.undvta COLUMN-LABEL "Und.Venta"
    FIELD tflg_factor  LIKE Ccbddocu.flg_factor COLUMN-LABEL "Factor"
    FIELD taftigv  LIKE    Ccbddocu.aftigv  COLUMN-LABEL "Afecto al IGV"
    FIELD timpigv  LIKE    Ccbddocu.impigv  COLUMN-LABEL "Imp.IGV"
    FIELD tlinea    AS CHAR FORMAT 'x(50)'      COLUMN-LABEL "Linea"
    FIELD tsublinea    AS CHAR FORMAT 'x(50)'   COLUMN-LABEL "Sub-Linea"
    FIELD tmarca    AS CHAR FORMAT 'x(50)'      COLUMN-LABEL "Marca"
    .    

DEFINE TEMP-TABLE tt-comprobantes-gen-pnc
    FIELD tcoddoc   AS  CHAR
    FIELD tnrodoc   AS  CHAR
    FIELD tcodcli   AS  CHAR
    FIELD tnomcli   AS  CHAR
    FIELD tfchdoc    AS  DATE
    FIELD tcodmon   AS  INT
    FIELD titotal   AS  DEC
    FIELD timptot   AS  DEC
    FIELD ttpocmb   AS  DEC.

DEFINE TEMP-TABLE tt-cobranzas
    FIELD tcoddoc   AS  CHAR
    FIELD tnrodoc   AS  CHAR
    FIELD tfhdoc   AS  DATE
    FIELD tcodmon AS INT
    FIELD tcodref   AS  CHAR
    FIELD tnroref   AS  CHAR
    FIELD tcodcli   AS  CHAR
    FIELD tmonref AS INT
    FIELD timptot AS INT.

DEFINE TEMP-TABLE tt-clientes-calculo
    FIELD   tcodcli AS  CHAR    COLUMN-LABEL "Cod.Cliente"
    FIELD   tnomcli AS  CHAR    COLUMN-LABEL "Nombre del Cliente"
    FIELD   truc    AS  CHAR    COLUMN-LABEL "R.U.C."
    FIELD   tagrupador AS  CHAR    COLUMN-LABEL "Agrupador"
    FIELD   tmeta1  AS  DEC     FORMAT '->>,>>>,>>9.99'     COLUMN-LABEL "Meta 1"
    FIELD   tmeta2  AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Meta 2"
    FIELD   tmeta3  AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Meta 3"
    FIELD   tventas  AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Ventas Meta"
    FIELD   tvta-premio  AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Ventas Premio"
    FIELD   tcobros  AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Cobranzas"
    FIELD   tventasgrp  AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Ventas Grupo"
    FIELD   tcobrosgrp  AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Cobranzas Grupo"
    FIELD   tpremio AS INT  FORMAT '->>9' COLUMN-LABEL "Premio"     INIT 0
    FIELD   tfactorpremio AS DEC  FORMAT '->>9.9999' COLUMN-LABEL "%Premio"     INIT 0
    FIELD   timppremio  AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Importe Premio"   INIT 0      /* Cuanto le corresponde de premio en S/ */
    FIELD   tpremiocalc  AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Premio calculado"   INIT 0   /* La suma del calculado */
    FIELD   tvtaslinpremiadas  AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Total Lineas Premiadas"   INIT 0.

/* */
DEFINE TEMP-TABLE t-ccbcdocu LIKE ccbcdocu
    FIELDS tdoc-meta    AS  LOG INIT NO
    FIELDS tdoc-premio  AS  LOG INIT NO
    .

DEFINE TEMP-TABLE nc-ccbcdocu LIKE ccbcdocu.

/* Temporales de la PNC - Header */
DEFINE TEMP-TABLE pnc-ccbcdocu
    FIELD   codcia  LIKE    Ccbcdocu.codcia
    FIELD   coddiv  LIKE    Ccbcdocu.coddiv
    FIELD   coddoc  LIKE    Ccbcdocu.coddoc
    FIELD   nrodoc  LIKE    Ccbcdocu.nrodoc
    FIELD   fchdoc  LIKE    Ccbcdocu.fchdoc
    FIELD   horcie  LIKE    Ccbcdocu.horcie
    FIELD   fchvto  LIKE    Ccbcdocu.fchvto
    FIELD   codcli  LIKE    Ccbcdocu.codcli
    FIELD   ruccli  LIKE    Ccbcdocu.ruccli
    FIELD   nomcli  LIKE    Ccbcdocu.nomcli
    FIELD   dircli  LIKE    Ccbcdocu.dircli
    FIELD   porigv  LIKE    Ccbcdocu.porigv
    FIELD   codmon  LIKE    Ccbcdocu.codmon
    FIELD   usuario LIKE    Ccbcdocu.usuario
    FIELD   tpocmb  LIKE    Ccbcdocu.tpocmb
    FIELD   codref  LIKE    Ccbcdocu.codref
    FIELD   nroref  LIKE    Ccbcdocu.nroref
    FIELD   codven  LIKE    Ccbcdocu.codven
    FIELD   divori  LIKE    Ccbcdocu.divori
    FIELD   cndcre  LIKE    Ccbcdocu.cndcre
    FIELD   fmapgo  LIKE    Ccbcdocu.fmapgo
    FIELD   tpofac  LIKE    Ccbcdocu.tpofac
    FIELD   codcta  LIKE    Ccbcdocu.codcta          /*Concepto*/
    FIELD   tipo    LIKE    Ccbcdocu.tipo   /*"CREDITO"*/
    FIELD   codcaja LIKE    Ccbcdocu.codcaja
    FIELD   FlgEst  LIKE    Ccbcdocu.FlgEst
    FIELD   ImpBrt  LIKE    Ccbcdocu.ImpBrt
    FIELD   ImpExo  LIKE    Ccbcdocu.ImpExo
    FIELD   ImpDto  LIKE    Ccbcdocu.ImpDto
    FIELD   ImpIgv  LIKE    Ccbcdocu.ImpIgv
    FIELD   ImpTot  LIKE    Ccbcdocu.ImpTot
    FIELD   flgcie  LIKE    Ccbcdocu.flgcie
    FIELD   ImpVta  LIKE    Ccbcdocu.ImpVta
    FIELD   SdoAct  LIKE    Ccbcdocu.SdoAct
    FIELD   libre_c01 LIKE ccbcdocu.libre_c01
    FIELD   libre_c99 AS    CHAR    INIT ""               /* Para el correlativo correcto */
    FIELD   flg-num  AS  CHAR    INIT ""
    FIELD   tgrupo-docs AS    CHAR  INIT ""        /* El documento es de Campaña / No Campaña */.

/* Temporales de la PNC - Detail */
DEFINE TEMP-TABLE pnc-ccbddocu
    FIELD   codcia  LIKE    Ccbddocu.codcia
    FIELD   coddiv  LIKE    Ccbddocu.coddiv
    FIELD   coddoc  LIKE    Ccbddocu.coddoc
    FIELD   nrodoc  LIKE    Ccbddocu.nrodoc
    FIELD   fchdoc  LIKE    Ccbddocu.fchdoc
    FIELD   nroitm  LIKE    Ccbddocu.nroitm
    FIELD   codmat  LIKE    Ccbddocu.codmat
    FIELD   factor  LIKE    Ccbddocu.factor
    FIELD   candes  LIKE    Ccbddocu.candes
    FIELD   preuni  LIKE    Ccbddocu.preuni
    FIELD   implin  LIKE    Ccbddocu.implin
    FIELD   undvta  LIKE    Ccbddocu.undvta
    FIELD   flg_factor  LIKE Ccbddocu.flg_factor
    FIELD   aftigv  LIKE    Ccbddocu.aftigv
    FIELD   impigv  LIKE    Ccbddocu.impigv.

/* Los items de las N/Cs */
DEFINE TEMP-TABLE ttNCItems
    FIELD   tcodmat     AS  CHAR
    FIELD   tcant       AS  DEC INIT 0
    FIELD   timplin     AS  DEC INIT 0.

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
&Scoped-define INTERNAL-TABLES rbte_fecha_movimiento tt-w-report ~
eve-w-report

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 rbte_fecha_movimiento.codrazon ~
rbte_fecha_movimiento.fchdesde rbte_fecha_movimiento.fchhasta 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH rbte_fecha_movimiento ~
      WHERE rbte_fecha_movimiento.codcia = s-codcia and ~
rbte_fecha_movimiento.codproceso = x-proceso NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH rbte_fecha_movimiento ~
      WHERE rbte_fecha_movimiento.codcia = s-codcia and ~
rbte_fecha_movimiento.codproceso = x-proceso NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 rbte_fecha_movimiento
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 rbte_fecha_movimiento


/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 tt-w-report.Campo-C[1] ~
tt-w-report.Campo-C[2] tt-w-report.Campo-C[3] tt-w-report.Campo-C[4] ~
tt-w-report.Campo-C[5] tt-w-report.Campo-C[7] tt-w-report.Campo-C[8] ~
tt-w-report.Campo-C[6] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 tt-w-report


/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 eve-w-report.Campo-C[1] ~
eve-w-report.Campo-C[2] eve-w-report.Campo-C[3] eve-w-report.Campo-C[4] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH eve-w-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH eve-w-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 eve-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 eve-w-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-4}~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-procesar COMBO-BOX-procesos BROWSE-4 ~
BROWSE-2 BROWSE-5 RADIO-SET-tipodoc 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-titulo COMBO-BOX-procesos ~
RADIO-SET-tipodoc 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-procesar 
     LABEL "Procesar" 
     SIZE 13 BY 1.12.

DEFINE VARIABLE COMBO-BOX-procesos AS CHARACTER FORMAT "X(256)":U 
     LABEL "Procesos" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 45.57 BY 1
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-titulo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1
     BGCOLOR 15 FGCOLOR 9 FONT 9 NO-UNDO.

DEFINE VARIABLE RADIO-SET-tipodoc AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "TODOS", "*",
"FACTURAS", "FAC",
"BOLETAS", "BOL"
     SIZE 13 BY 3 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      rbte_fecha_movimiento SCROLLING.

DEFINE QUERY BROWSE-4 FOR 
      tt-w-report SCROLLING.

DEFINE QUERY BROWSE-5 FOR 
      eve-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      rbte_fecha_movimiento.codrazon COLUMN-LABEL "Motivo" FORMAT "x(30)":U
            LABEL-FGCOLOR 9 LABEL-BGCOLOR 15 LABEL-FONT 6 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "Fecha de Cobranza","COBR",
                                      "Documentos de Campaña","MVTAS",
                                      "Otras Campañas","MVTAS1",
                                      "Lineas que generaran las N/C","LGNC"
                      DROP-DOWN-LIST 
      rbte_fecha_movimiento.fchdesde COLUMN-LABEL "Desde" FORMAT "99/99/9999":U
            WIDTH 8.86 LABEL-FGCOLOR 9 LABEL-BGCOLOR 15 LABEL-FONT 6
      rbte_fecha_movimiento.fchhasta COLUMN-LABEL "Hasta" FORMAT "99/99/9999":U
            LABEL-FGCOLOR 9 LABEL-BGCOLOR 15 LABEL-FONT 6
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 43 BY 7.27
         FONT 4
         TITLE "Rango de Fechas" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      tt-w-report.Campo-C[1] COLUMN-LABEL "Motivo" FORMAT "X(25)":U
            WIDTH 22.14 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "Fecha de Cobranza","COBR",
                                      "Documentos de Campaña","MVTAS",
                                      "Otras Campañas","MVTAS1",
                                      "Lineas que generaran las N/C","LGNC"
                      DROP-DOWN-LIST 
      tt-w-report.Campo-C[2] COLUMN-LABEL "Linea" FORMAT "X(5)":U
            WIDTH 4.57
      tt-w-report.Campo-C[3] COLUMN-LABEL "Nombre Linea" FORMAT "X(60)":U
            WIDTH 25.29
      tt-w-report.Campo-C[4] COLUMN-LABEL "Sub!Linea" FORMAT "X(5)":U
            WIDTH 4.43
      tt-w-report.Campo-C[5] COLUMN-LABEL "Nombre Sub-Linea" FORMAT "X(60)":U
            WIDTH 19.43
      tt-w-report.Campo-C[7] COLUMN-LABEL "Marca" FORMAT "X(5)":U
      tt-w-report.Campo-C[8] COLUMN-LABEL "Nombre Marca" FORMAT "X(60)":U
            WIDTH 33.86
      tt-w-report.Campo-C[6] COLUMN-LABEL "Signo" FORMAT "X(3)":U
            WIDTH 4.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 126 BY 11
         FONT 4
         TITLE "Lineas para la meta y la generacion de las pre-notas" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      eve-w-report.Campo-C[1] COLUMN-LABEL "Motivo" FORMAT "X(25)":U
            WIDTH 21.57 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "Fecha de Cobranza","COBR",
                                      "Documentos de Campaña","MVTAS",
                                      "Otras Campañas","MVTAS1"
                      DROP-DOWN-LIST 
      eve-w-report.Campo-C[2] COLUMN-LABEL "Lista!Precio" FORMAT "X(8)":U
            WIDTH 6
      eve-w-report.Campo-C[3] COLUMN-LABEL "Nombre Lista Precio" FORMAT "X(60)":U
            WIDTH 28
      eve-w-report.Campo-C[4] COLUMN-LABEL "Signo" FORMAT "X(3)":U
            WIDTH 3.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 64.14 BY 7.23
         FONT 4
         TITLE "Lista de Precios para la meta" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-procesar AT ROW 1.12 COL 117.57 WIDGET-ID 6
     FILL-IN-titulo AT ROW 1.19 COL 53.29 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     COMBO-BOX-procesos AT ROW 1.31 COL 7.14 COLON-ALIGNED WIDGET-ID 2
     BROWSE-4 AT ROW 2.31 COL 2 WIDGET-ID 300
     BROWSE-2 AT ROW 13.46 COL 67.14 WIDGET-ID 200
     BROWSE-5 AT ROW 13.5 COL 1.86 WIDGET-ID 400
     RADIO-SET-tipodoc AT ROW 14.77 COL 113.86 NO-LABEL WIDGET-ID 10
     " Documentos a Considerar" VIEW-AS TEXT
          SIZE 18.86 BY .5 AT ROW 14.08 COL 111.14 WIDGET-ID 14
          FGCOLOR 4 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 130.86 BY 20.12
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: eve-w-report T "?" NO-UNDO INTEGRAL w-report
      TABLE: tt-w-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Calculo de Rebate - Importe de Ventas"
         HEIGHT             = 20.12
         WIDTH              = 130.86
         MAX-HEIGHT         = 22.73
         MAX-WIDTH          = 143.72
         VIRTUAL-HEIGHT     = 22.73
         VIRTUAL-WIDTH      = 143.72
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
/* BROWSE-TAB BROWSE-4 COMBO-BOX-procesos F-Main */
/* BROWSE-TAB BROWSE-2 BROWSE-4 F-Main */
/* BROWSE-TAB BROWSE-5 BROWSE-2 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-titulo IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.rbte_fecha_movimiento"
     _Options          = "NO-LOCK"
     _Where[1]         = "rbte_fecha_movimiento.codcia = s-codcia and
rbte_fecha_movimiento.codproceso = x-proceso"
     _FldNameList[1]   > INTEGRAL.rbte_fecha_movimiento.codrazon
"rbte_fecha_movimiento.codrazon" "Motivo" "x(30)" "character" ? ? ? 15 9 6 no ? no no ? yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "Fecha de Cobranza,COBR,Documentos de Campaña,MVTAS,Otras Campañas,MVTAS1,Lineas que generaran las N/C,LGNC" 5 no 0 no no
     _FldNameList[2]   > INTEGRAL.rbte_fecha_movimiento.fchdesde
"rbte_fecha_movimiento.fchdesde" "Desde" ? "date" ? ? ? 15 9 6 no ? no no "8.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.rbte_fecha_movimiento.fchhasta
"rbte_fecha_movimiento.fchhasta" "Hasta" ? "date" ? ? ? 15 9 6 no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-C[1]
"tt-w-report.Campo-C[1]" "Motivo" "X(25)" "character" ? ? ? ? ? ? no ? no no "22.14" yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "Fecha de Cobranza,COBR,Documentos de Campaña,MVTAS,Otras Campañas,MVTAS1,Lineas que generaran las N/C,LGNC" 5 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[2]
"tt-w-report.Campo-C[2]" "Linea" "X(5)" "character" ? ? ? ? ? ? no ? no no "4.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-C[3]
"tt-w-report.Campo-C[3]" "Nombre Linea" "X(60)" "character" ? ? ? ? ? ? no ? no no "25.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report.Campo-C[4]
"tt-w-report.Campo-C[4]" "Sub!Linea" "X(5)" "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-w-report.Campo-C[5]
"tt-w-report.Campo-C[5]" "Nombre Sub-Linea" "X(60)" "character" ? ? ? ? ? ? no ? no no "19.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-w-report.Campo-C[7]
"tt-w-report.Campo-C[7]" "Marca" "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-w-report.Campo-C[8]
"tt-w-report.Campo-C[8]" "Nombre Marca" "X(60)" "character" ? ? ? ? ? ? no ? no no "33.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-w-report.Campo-C[6]
"tt-w-report.Campo-C[6]" "Signo" "X(3)" "character" ? ? ? ? ? ? no ? no no "4.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "Temp-Tables.eve-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.eve-w-report.Campo-C[1]
"eve-w-report.Campo-C[1]" "Motivo" "X(25)" "character" ? ? ? ? ? ? no ? no no "21.57" yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "Fecha de Cobranza,COBR,Documentos de Campaña,MVTAS,Otras Campañas,MVTAS1" 5 no 0 no no
     _FldNameList[2]   > Temp-Tables.eve-w-report.Campo-C[2]
"eve-w-report.Campo-C[2]" "Lista!Precio" ? "character" ? ? ? ? ? ? no ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.eve-w-report.Campo-C[3]
"eve-w-report.Campo-C[3]" "Nombre Lista Precio" "X(60)" "character" ? ? ? ? ? ? no ? no no "28" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.eve-w-report.Campo-C[4]
"eve-w-report.Campo-C[4]" "Signo" "X(3)" "character" ? ? ? ? ? ? no ? no no "3.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Calculo de Rebate - Importe de Ventas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Calculo de Rebate - Importe de Ventas */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-procesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-procesar W-Win
ON CHOOSE OF BUTTON-procesar IN FRAME F-Main /* Procesar */
DO:
  ASSIGN radio-set-tipodoc.

  x-tipo-dcmtos = 'FAC,BOL'.

  IF radio-set-tipodoc <> '*' THEN x-tipo-dcmtos = radio-set-tipodoc.

  RUN procesos.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-procesos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-procesos W-Win
ON VALUE-CHANGED OF COMBO-BOX-procesos IN FRAME F-Main /* Procesos */
DO:
  ASSIGN fill-in-titulo:SCREEN-VALUE = combo-box-procesos:SCREEN-VALUE.

  x-proceso = combo-box-procesos:SCREEN-VALUE.

  {&open-query-browse-2}
  RUN carga-lineas.
  RUN carga-eventos.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

DEF VAR celda_br AS WIDGET-HANDLE EXTENT 150 NO-UNDO.
 DEF VAR cual_celda AS WIDGET-HANDLE NO-UNDO.
 DEF VAR n_cols_browse AS INT NO-UNDO.
 DEF VAR col_act AS INT NO-UNDO.
 DEF VAR t_col_br AS INT NO-UNDO INITIAL 11.            /* Color del background de la celda ( 2 : Verde)*/
 DEF VAR vg_col_eti_b AS INT NO-UNDO INITIAL 28.        /* Color del la letra de la celda (15 : Blanco) */      

ON ROW-DISPLAY OF browse-4
DO:
     
  CASE tt-w-report.campo-c[1]:
      WHEN "COBR" THEN DO:
          t_col_br = 10.
      END.
      WHEN "MVTAS" THEN DO:
          t_col_br = 14.    /*2*/
      END.
      WHEN "MVTAS1" THEN DO:
          t_col_br = 6.
          vg_col_eti_b = 15.
      END.
      WHEN "LGNC" THEN DO:
          t_col_br = 10.
      END.

  END CASE.

  DO col_act = 1 TO n_cols_browse.
      
     cual_celda = celda_br[col_act].
     cual_celda:BGCOLOR = t_col_br.
  END.
END.

DO n_cols_browse = 1 TO browse-4:NUM-COLUMNS.
   celda_br[n_cols_browse] = browse-4:GET-BROWSE-COLUMN(n_cols_browse).
   cual_celda = celda_br[n_cols_browse].
     
   IF vg_col_eti_b <> 0 THEN cual_celda:LABEL-BGCOLOR = vg_col_eti_b.
   /*IF n_cols_browse = 15 THEN LEAVE.*/
END.

n_cols_browse = browse-4:NUM-COLUMNS.
/* IF n_cols_browse > 15 THEN n_cols_browse = 15. */

/*
If you need one color for a specific value of a field, then change the trigger ON ROW-DISPLAY OF browse-1
remove the line IF CURRENT-RESULT-ROW("browse-1") / 2 <> INT (CURRENT-RESULT-ROW("browse-1") / 2) THEN RETURN.

and put something like this:
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcula-premio W-Win 
PROCEDURE calcula-premio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH tt-clientes-calculo :
    IF tt-clientes-calculo.tcobrosgrp > tt-clientes-calculo.tmeta1 THEN DO:
        IF tt-clientes-calculo.tcobrosgrp > tt-clientes-calculo.tmeta3 THEN DO:
            ASSIGN tt-clientes-calculo.tpremio = 3
                    tt-clientes-calculo.tfactorpremio = x-factor-premio3
                    tt-clientes-calculo.timppremio = tt-clientes-calculo.tvta-premio * (x-factor-premio3 / 100).
                    .
        END.
        ELSE DO:
            IF tt-clientes-calculo.tcobrosgrp > tt-clientes-calculo.tmeta2 THEN DO:
                ASSIGN tt-clientes-calculo.tpremio = 2
                    tt-clientes-calculo.tfactorpremio = x-factor-premio2
                    tt-clientes-calculo.timppremio = tt-clientes-calculo.tvta-premio * (x-factor-premio2 / 100).
                    .
            END.
            ELSE DO:
                ASSIGN tt-clientes-calculo.tpremio = 1
                    tt-clientes-calculo.tfactorpremio = x-factor-premio1
                    tt-clientes-calculo.timppremio = tt-clientes-calculo.tvta-premio * (x-factor-premio1 / 100).
            END.
        END.

    END.

    /*
    IF tt-clientes-calculo.tcobrosgrp > tt-clientes-calculo.tmeta1 THEN DO:
        ASSIGN tt-clientes-calculo.tpremio = 3
                tt-clientes-calculo.tfactorpremio = x-factor-premio3
                tt-clientes-calculo.timppremio = tt-clientes-calculo.tvta-premio * (x-factor-premio3 / 100)
                .
    END.
    ELSE DO:
        IF (tt-clientes-calculo.tcobrosgrp >= tt-clientes-calculo.tmeta2 AND 
            tt-clientes-calculo.tcobrosgrp <= tt-clientes-calculo.tmeta3) THEN DO:
            ASSIGN tt-clientes-calculo.tpremio = 2
                tt-clientes-calculo.tfactorpremio = x-factor-premio2
                tt-clientes-calculo.timppremio = tt-clientes-calculo.tvta-premio * (x-factor-premio2 / 100)
                .
        END.
        ELSE DO:
            IF (tt-clientes-calculo.tcobrosgrp >= tt-clientes-calculo.tmeta1 AND 
                tt-clientes-calculo.tcobrosgrp <= tt-clientes-calculo.tmeta2) THEN DO:
                ASSIGN tt-clientes-calculo.tpremio = 1
                    tt-clientes-calculo.tfactorpremio = x-factor-premio1
                    tt-clientes-calculo.timppremio = tt-clientes-calculo.tvta-premio * (x-factor-premio1 / 100)
                    .
            END.
        END.
    END.
    */
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculo-fac-bol W-Win 
PROCEDURE calculo-fac-bol :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-fecha-desde AS DATE.
DEFINE VAR x-fecha-hasta AS DATE.
DEFINE VAR x-fecha AS DATE.
DEFINE VAR x-lista-precio AS CHAR.
DEFINE VAR x-header AS LOG.
DEFINE VAR x-impte-total-meta AS DEC.
DEFINE VAR x-impte-total-premio AS DEC.
DEFINE VAR x-impte-premio AS DEC.
DEFINE VAR x-tipo-cmb AS DEC.

DEFINE VAR x-codcot AS CHAR.
DEFINE VAR x-nrocot AS CHAR.
DEFINE VAR x-valida-linea-marca AS LOG.

/* Importe de lineas, para la meta y la premiacion */
DEFINE VAR x-doc-meta   AS LOG.
DEFINE VAR x-doc-premio AS LOG.

DEFINE VAR x-QueExcluye AS CHAR.

x-QueExcluye = "".

/* Todos los documentos sin NOTAS DE CREDITO */
FOR EACH rbte_fecha_movimiento WHERE rbte_fecha_movimiento.codcia = s-codcia AND
                                        rbte_fecha_movimiento.codproceso = x-proceso AND
                                        rbte_fecha_movimiento.codrazon BEGINS "MVTAS" NO-LOCK:

    x-fecha-desde = rbte_fecha_movimiento.fchdesde.
    x-fecha-hasta = rbte_fecha_movimiento.fchhasta.

    /* Solo los clientes de REBATE */
    FOR EACH rbte_cliente WHERE rbte_cliente.codcia = s-codcia AND
                                rbte_cliente.codproceso = x-proceso /*AND
                                rbte_cliente.codcli = '10102302813'*/
                                NO-LOCK:

        FIND FIRST tt-clientes-calculo WHERE tt-clientes-calculo.tcodcli = rbte_cliente.codcli 
                                                EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE tt-clientes-calculo THEN DO:
            CREATE tt-clientes-calculo.
                ASSIGN tt-clientes-calculo.tcodcli = rbte_cliente.codcli
                        tt-clientes-calculo.truc = rbte_cliente.ruc
                        tt-clientes-calculo.tagrupador = rbte_cliente.codagrupa
                        tt-clientes-calculo.tmeta1 = rbte_cliente.metas[1]
                        tt-clientes-calculo.tmeta2 = rbte_cliente.metas[2]
                        tt-clientes-calculo.tmeta3 = rbte_cliente.metas[3]
                        tt-clientes-calculo.tventas = 0
                        tt-clientes-calculo.tpremio = 0
                        tt-clientes-calculo.tcobros = 0
                        tt-clientes-calculo.tventasgrp = 0
                        tt-clientes-calculo.tcobrosgrp = 0

            .
        END.
        
        FOR EACH ccbcdocu USE-INDEX llave06 WHERE ccbcdocu.codcia = s-codcia AND
                                                    ccbcdocu.codcli = rbte_cliente.codcli AND                    
                                            (ccbcdocu.fchdoc >= x-fecha-desde AND ccbcdocu.fchdoc <= x-fecha-hasta) AND
                                            LOOKUP(ccbcdocu.coddoc,x-tipo-dcmtos) > 0 AND
                                            LOOKUP(ccbcdocu.tpofac,"A,S") = 0 AND           /* Anticipos y Servicios NO VA */
                                            ccbcdocu.flgest <> "A" NO-LOCK:

            /* Validar si la condicion de venta del documento de referencia permite generar N/C */
            FIND FIRST gn-convt WHERE gn-convt.codig = ccbcdocu.fmapgo NO-LOCK NO-ERROR.
            IF gn-convt.libre_c01 <> 'SI' THEN DO:
                /*
                MESSAGE "La condicion de venta del documento" SKIP
                        "que va servir de referencia para la N/C" SKIP
                        "no esta habilitado para generar Notas de Credito"
                        VIEW-AS ALERT-BOX INFORMATION.
                */
                NEXT.
            END.
            
            /* Verificamos si esta EXCLUIDO la condicion de venta */
            FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                        vtatabla.tabla = "WIN-TO-WIN-RBTE-CNDVTAS" AND
                                        vtatabla.llave_c1 = ccbcdocu.fmapgo NO-LOCK NO-ERROR.
            x-QueExcluye = "".
            IF AVAILABLE vtatabla THEN DO:
                x-QueExcluye = vtatabla.libre_c01.
                /* Si esta excluido para AMBOS no considerar */
                IF vtatabla.libre_c01 = 'AMBOS' THEN DO:
                    NEXT.
                END.                
            END.

            x-lista-precio = ccbcdocu.divori.

            /* Ubicamos el pedido */
            FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                                        faccpedi.coddoc = ccbcdocu.codped AND 
                                        faccpedi.nroped = ccbcdocu.nroped NO-LOCK NO-ERROR.
            IF NOT AVAILABLE faccpedi THEN DO:
                NEXT.
            END.

            /* No tiene Lista de Precio ? */
            IF TRUE <> (x-lista-precio > "") THEN DO:
                x-lista-precio = faccpedi.coddiv.
            END.

            /* Ubicamos la Cotizacion */
            x-codcot = faccpedi.codref.
            x-nrocot = faccpedi.nroref.

            FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                                        faccpedi.coddoc = x-codcot AND 
                                        faccpedi.nroped = x-nrocot NO-LOCK NO-ERROR.
            IF AVAILABLE faccpedi THEN DO:                
                IF NOT (TRUE <> (faccpedi.libre_c01 > "")) THEN DO:
                    x-lista-precio = faccpedi.libre_c01.
                END.
            END.
            FIND FIRST tt-eventos WHERE tt-eventos.trazon = rbte_fecha_movimiento.codrazon AND
                                        tt-eventos.tcoddiv = x-lista-precio NO-LOCK NO-ERROR.            
            IF AVAILABLE tt-eventos THEN DO:

                x-header = NO.
                x-impte-total-premio = 0.
                x-impte-total-meta = 0.

                /* Acumulo la suma de todas las N/C que hagan referencia al documento - x cada articulo  */
                RUN ncreditos-del-documento(INPUT ccbcdocu.coddoc, INPUT ccbcdocu.nrodoc).

                FOR EACH ccbddocu OF ccbcdocu NO-LOCK,
                    FIRST almmmatg OF ccbddocu NO-LOCK :

                    FIND FIRST almtfami OF almmmatg NO-LOCK NO-ERROR.
                    FIND FIRST almsfam OF almmmatg NO-LOCK NO-ERROR.

                    x-doc-meta = NO.
                    x-doc-premio = NO.

                    /* Linea esta configurada para la meta */
                    FIND FIRST tt-lineas WHERE tt-lineas.trazon = rbte_fecha_movimiento.codrazon AND
                                                tt-lineas.tcodfam = almmmatg.codfam AND
                                                tt-lineas.tsubfam = almmmatg.subfam AND
                                                tt-lineas.tmarca = almmmatg.codmar NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE tt-lineas THEN DO:
                        FIND FIRST tt-lineas WHERE tt-lineas.trazon = rbte_fecha_movimiento.codrazon AND
                                                    tt-lineas.tcodfam = almmmatg.codfam AND
                                                    tt-lineas.tsubfam = almmmatg.subfam AND
                                                    tt-lineas.tmarca = "*" NO-LOCK NO-ERROR.
                    END.
                    IF AVAILABLE tt-lineas THEN DO:
                        x-doc-meta = YES.
                    END.
                    /* Linea esta configurada para el premio */
                    FIND FIRST tt-lineas-gen-pnc WHERE tt-lineas-gen-pnc.trazon = 'LGNC' AND
                                                tt-lineas-gen-pnc.tcodfam = almmmatg.codfam AND
                                                tt-lineas-gen-pnc.tsubfam = almmmatg.subfam /*AND
                                                tt-lineas-gen-pnc.tmarca = almmmatg.codmar*/ NO-LOCK NO-ERROR.
                    IF AVAILABLE tt-lineas-gen-pnc THEN DO:
                        x-doc-premio = YES.
                    END.

                    IF x-doc-meta = YES OR x-doc-premio = YES THEN DO:
                        /* OK */
                        IF x-header = NO THEN DO:
                            CREATE t-ccbcdocu.
                            BUFFER-COPY ccbcdocu TO t-ccbcdocu.

                            x-header = YES.                                                        
                        END.
                        IF x-doc-meta = YES AND x-QueExcluye <> "META" THEN DO:
                            ASSIGN t-ccbcdocu.tdoc-meta = YES.
                        END.
                        IF x-doc-premio = YES AND x-QueExcluye <> "PREMIO" THEN DO:
                            ASSIGN t-ccbcdocu.tdoc-premio = YES.
                        END.

                        FIND FIRST tt-comprobantes WHERE tt-comprobantes.tcoddoc = ccbcdocu.coddoc AND
                                                            tt-comprobantes.tnrodoc = ccbcdocu.nrodoc 
                                                            EXCLUSIVE-LOCK NO-ERROR.
                        IF NOT AVAILABLE tt-comprobantes THEN DO:
                            CREATE tt-comprobantes.
                                ASSIGN tt-comprobantes.tcoddoc = ccbcdocu.coddoc
                                        tt-comprobantes.tnrodoc = ccbcdocu.nrodoc
                                        tt-comprobantes.tfchdoc = ccbcdocu.fchdoc
                                        tt-comprobantes.tcodmon = ccbcdocu.codmon
                                        tt-comprobantes.titotal = ccbcdocu.imptot
                                        tt-comprobantes.timptot = 0
                                        tt-comprobantes.ttpocmb = ccbcdocu.tpocmb
                                        tt-comprobantes.tcodcli = ccbcdocu.codcli
                                        tt-comprobantes.tnomcli = ccbcdocu.nomcli
                                        tt-comprobantes.tgrupo-docs = rbte_fecha_movimiento.codrazon
                                    .
                        END.
                        IF x-doc-meta = YES AND x-QueExcluye <> 'META' THEN DO:
                            ASSIGN tt-comprobantes.tdoc-meta = YES.
                        END.
                        IF x-doc-premio = YES AND x-QueExcluye <> 'PREMIO' THEN DO:
                            ASSIGN tt-comprobantes.tdoc-premio = YES.
                        END.

                        x-tipo-cmb = 1.
                        IF ccbcdocu.codmon = 2 THEN DO:

                            x-tipo-cmb = ccbcdocu.tpocmb.

                            x-impte-premio = (ccbddocu.implin * ccbcdocu.tpocmb).

                            /* Dolares */                            
                            IF x-doc-meta = YES AND x-QueExcluye <> 'META' THEN DO:
                                x-impte-total-meta = x-impte-total-meta + (ccbddocu.implin * ccbcdocu.tpocmb).
                                ASSIGN tt-comprobantes.timptot = tt-comprobantes.timptot + (ccbddocu.implin * ccbcdocu.tpocmb).
                            END.                            
                            IF x-doc-premio = YES AND x-QueExcluye <> 'PREMIO' THEN DO:
                                /* Si tiene notas de credito */
                                FIND FIRST ttNCItems WHERE tcodmat = ccbddocu.codmat NO-LOCK NO-ERROR.
                                IF AVAILABLE ttNCItems THEN DO:
                                    x-impte-premio = x-impte-premio - ttNCItems.timplin.
                                    IF x-impte-premio < 0 THEN x-impte-premio = 0.
                                END.

                                x-impte-total-premio = x-impte-total-premio + x-impte-premio .
                                ASSIGN tt-comprobantes.timppremio = tt-comprobantes.timppremio + x-impte-premio.
                            END.                            
                        END.
                        ELSE DO:

                            x-impte-premio = ccbddocu.implin.

                            IF x-doc-meta = YES AND x-QueExcluye <> 'META' THEN DO:
                                x-impte-total-meta = x-impte-total-meta + ccbddocu.implin.
                                ASSIGN tt-comprobantes.timptot = tt-comprobantes.timptot + ccbddocu.implin.
                            END.                            
                            IF x-doc-premio = YES AND x-QueExcluye <> 'PREMIO' THEN DO:
                                /* Si tiene notas de credito */
                                FIND FIRST ttNCItems WHERE tcodmat = ccbddocu.codmat NO-LOCK NO-ERROR.
                                IF AVAILABLE ttNCItems THEN DO:
                                    x-impte-premio = x-impte-premio - ttNCItems.timplin.
                                    IF x-impte-premio < 0 THEN x-impte-premio = 0.
                                END.
                                x-impte-total-premio = x-impte-total-premio + x-impte-premio.
                                ASSIGN tt-comprobantes.timppremio = tt-comprobantes.timppremio + x-impte-premio.
                            END.                            
                        END.                                                    
                        /* El detalle */
                        CREATE tt-comprobantes-dtl.
                            ASSIGN tt-comprobantes-dtl.tcoddoc = ccbcdocu.coddoc
                                tt-comprobantes-dtl.tnrodoc = ccbcdocu.nrodoc
                                tt-comprobantes-dtl.tcodcli = ccbcdocu.codcli
                                tt-comprobantes-dtl.tnomcli = ccbcdocu.nomcli
                                tt-comprobantes-dtl.tfchdoc = ccbcdocu.fchdoc
                                tt-comprobantes-dtl.tdoc-meta  = tt-comprobantes.tdoc-meta
                                tt-comprobantes-dtl.tdoc-premio = tt-comprobantes.tdoc-premio
                                tt-comprobantes-dtl.tgrupo-docs = tt-comprobantes.tgrupo-docs
                                tt-comprobantes-dtl.tcodmat =    Ccbddocu.codmat
                                tt-comprobantes-dtl.tdesmat =    almmmatg.desmat
                                tt-comprobantes-dtl.tfactor =    Ccbddocu.factor
                                tt-comprobantes-dtl.tcandes =    Ccbddocu.candes
                                tt-comprobantes-dtl.tpreuni =    Ccbddocu.preuni * x-tipo-cmb
                                tt-comprobantes-dtl.timplin =    Ccbddocu.implin * x-tipo-cmb
                                tt-comprobantes-dtl.tundvta =    Ccbddocu.undvta
                                tt-comprobantes-dtl.tflg_factor  = Ccbddocu.flg_factor
                                tt-comprobantes-dtl.taftigv  =    Ccbddocu.aftigv
                                tt-comprobantes-dtl.timpigv  =    Ccbddocu.impigv * x-tipo-cmb
                                tt-comprobantes-dtl.tlinea = almmmatg.codfam + " " + almtfam.desfam
                                tt-comprobantes-dtl.tsublinea = almmmatg.subfam + " " + almsfam.dessub
                                tt-comprobantes-dtl.tmarca = almmmatg.codmar + " " + almmmatg.desmar
                            .
                    END.
                END.
                ASSIGN tt-clientes-calculo.tventas = tt-clientes-calculo.tventas + x-impte-total-meta
                            tt-clientes-calculo.tvta-premio = tt-clientes-calculo.tvta-premio + x-impte-total-premio
                            tt-clientes-calculo.tvtaslinpremiadas = tt-clientes-calculo.tvtaslinpremiadas + x-impte-total-premio.

            END.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculo-nc W-Win 
PROCEDURE calculo-nc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-fecha-desde AS DATE.
DEFINE VAR x-fecha-hasta AS DATE.
DEFINE VAR x-fecha AS DATE.
DEFINE VAR x-lista-precio AS CHAR.

EMPTY TEMP-TABLE nc-ccbcdocu.

/* Todas las N/C que hacen referencias a la FAC/BOL */
FOR EACH t-ccbcdocu NO-LOCK:
    FOR EACH ccbcdocu USE-INDEX llave07 WHERE ccbcdocu.codcia = s-codcia AND
                                                ccbcdocu.codref = t-ccbcdocu.coddoc AND
                                                ccbcdocu.nroref = t-ccbcdocu.nrodoc AND
                                                ccbcdocu.coddoc = 'N/C' AND
                                                ccbcdocu.flgest <> 'A' NO-LOCK:    

        /* Verificamos si el concepto (motivo) de la N/C esta EXCLUIDA */
        FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                    vtatabla.tabla = 'WIN-TO-WIN-RBTE-CONC' AND 
                                    vtatabla.llave_c1 = x-concepto-rebate AND
                                    vtatabla.llave_c2 = ccbcdocu.codcta     /* Concepto-Motivo de la N/C */
                                    NO-LOCK NO-ERROR.       
        IF AVAILABLE vtatabla THEN DO:
            IF vtatabla.libre_c01 = 'AMBOS' THEN DO:
                NEXT.
            END.
        END.
                                    
        CREATE nc-ccbcdocu.
        BUFFER-COPY ccbcdocu TO nc-ccbcdocu.
                                                    
        FIND FIRST tt-comprobantes WHERE tt-comprobantes.tcoddoc = ccbcdocu.coddoc AND
                                            tt-comprobantes.tnrodoc = ccbcdocu.nrodoc 
                                            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE tt-comprobantes THEN DO:
            CREATE tt-comprobantes.
                ASSIGN tt-comprobantes.tcoddoc = ccbcdocu.coddoc
                        tt-comprobantes.tnrodoc = ccbcdocu.nrodoc
                        tt-comprobantes.tfchdoc = ccbcdocu.fchdoc
                        tt-comprobantes.tcodmon = ccbcdocu.codmon
                        tt-comprobantes.titotal = ccbcdocu.imptot
                        tt-comprobantes.timptot = 0
                        tt-comprobantes.ttpocmb = ccbcdocu.tpocmb
                        tt-comprobantes.tcodcli = ccbcdocu.codcli
                        tt-comprobantes.tnomcli = ccbcdocu.nomcli
                    .
        END.

        IF ccbcdocu.codmon = 2 THEN DO:
            /* Dolares */
            ASSIGN tt-comprobantes.timptot = tt-comprobantes.timptot + (ccbcdocu.imptot * ccbcdocu.tpocmb).
        END.
        ELSE DO:
            ASSIGN tt-comprobantes.timptot = tt-comprobantes.timptot + ccbcdocu.imptot.
        END.                                                    

    END.
END.

/* Agrego las N/C a la tabla de trabajo */
FOR EACH nc-ccbcdocu :
    CREATE t-ccbcdocu.
    BUFFER-COPY nc-ccbcdocu TO t-ccbcdocu.

    FIND FIRST tt-clientes-calculo WHERE tt-clientes-calculo.tcodcli = nc-ccbcdocu.codcli EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE tt-clientes-calculo THEN DO:

        CREATE tt-cobranzas.
            ASSIGN tt-cobranzas.tcoddoc = ""
                    tt-cobranzas.tnrodoc = ""
                    tt-cobranzas.tfhdoc = ?
                    tt-cobranzas.tcodmon = 0
                    tt-cobranzas.tcodref = nc-ccbcdocu.coddoc
                    tt-cobranzas.tnroref = nc-ccbcdocu.nrodoc
                    tt-cobranzas.tcodcli = nc-ccbcdocu.codcli
                    tt-cobranzas.tmonref = nc-ccbcdocu.codmon
                    tt-cobranzas.timptot = nc-ccbcdocu.imptot
                .

        IF nc-ccbcdocu.codmon = 2 THEN DO:
            /* Dolares */
            /*ASSIGN tt-clientes-calculo.tventas = tt-clientes-calculo.tventas - (nc-ccbcdocu.imptot * nc-ccbcdocu.tpocmb).*/
            /* Tambien considerar como COBRADOS */
            ASSIGN tt-clientes-calculo.tcobros = tt-clientes-calculo.tcobros - (nc-ccbcdocu.imptot * nc-ccbcdocu.tpocmb).
        END.
        ELSE DO:
            /*ASSIGN tt-clientes-calculo.tventas = tt-clientes-calculo.tventas - nc-ccbcdocu.imptot.*/
            /* Tambien considerar como COBRADOS */
            ASSIGN tt-clientes-calculo.tcobros = tt-clientes-calculo.tcobros - nc-ccbcdocu.imptot.
        END.
        
    END.
    
END.

/* Descargo memoria */
EMPTY TEMP-TABLE nc-ccbcdocu.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-eventos W-Win 
PROCEDURE carga-eventos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE eve-w-report.                                                                                             
                                                                                             
FOR EACH rbte_evento_movimiento WHERE rbte_evento_movimiento.codcia = s-codcia AND
                                        rbte_evento_movimiento.codproceso = x-proceso NO-LOCK:
    CREATE eve-w-report.
        ASSIGN eve-w-report.campo-c[1] = rbte_evento_movimiento.codrazon
                eve-w-report.campo-c[2] = rbte_evento_movimiento.coddiv
                eve-w-report.campo-c[4] = rbte_evento_movimiento.signo
            .
        IF rbte_evento_movimiento.coddiv = '*' THEN DO:
            ASSIGN eve-w-report.campo-c[3] = "< Todas las Lista de precio >".
        END.
        ELSE DO:
            ASSIGN eve-w-report.campo-c[3] = "** ERROR **".
            FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND
                                        gn-divi.coddiv = rbte_evento_movimiento.coddiv
                                        NO-LOCK NO-ERROR.
            IF AVAILABLE gn-divi THEN DO:
                ASSIGN eve-w-report.campo-c[3] = gn-divi.desdiv.
            END.
        END.
END.

{&open-query-browse-5}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-lineas W-Win 
PROCEDURE carga-lineas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-w-report.                                                                                             
                                                                                             
FOR EACH rbte_linea_movimiento WHERE rbte_linea_movimiento.codcia = s-codcia AND
                                        rbte_linea_movimiento.codproceso = x-proceso NO-LOCK:
    CREATE tt-w-report.
        ASSIGN tt-w-report.campo-c[1] = rbte_linea_movimiento.codrazon
                tt-w-report.campo-c[2] = rbte_linea_movimiento.codlinea
                tt-w-report.campo-c[4] = rbte_linea_movimiento.codsublinea
                tt-w-report.campo-c[7] = rbte_linea_movimiento.campo-c[3]
                tt-w-report.campo-c[6] = rbte_linea_movimiento.signo
            .
        IF rbte_linea_movimiento.codlinea = '*' THEN DO:
            ASSIGN tt-w-report.campo-c[3] = "< Todas las Lineas >".
        END.
        ELSE DO:
            ASSIGN tt-w-report.campo-c[3] = "** ERROR **".
            FIND FIRST almtfami WHERE almtfami.codcia = s-codcia AND
                                        almtfami.codfam = rbte_linea_movimiento.codlinea 
                                        NO-LOCK NO-ERROR.
            IF AVAILABLE almtfami THEN DO:
                ASSIGN tt-w-report.campo-c[3] = almtfami.desfam.
            END.
        END.
        /**/
        IF rbte_linea_movimiento.codsublinea = '*' THEN DO:
            ASSIGN tt-w-report.campo-c[5] = "< Todas las Sub-Lineas >".
        END.
        ELSE DO:
            ASSIGN tt-w-report.campo-c[5] = "** ERROR **".
            FIND FIRST almsfami WHERE almsfami.codcia = s-codcia AND
                                        almsfami.codfam = rbte_linea_movimiento.codlinea AND
                                        almsfami.subfam = rbte_linea_movimiento.codsublinea 
                                        NO-LOCK NO-ERROR.
            IF AVAILABLE almsfami THEN DO:
                ASSIGN tt-w-report.campo-c[5] = almsfami.dessub.
            END.
        END.
        /* MARCA */
        IF rbte_linea_movimiento.campo-c[3] = '*' THEN DO:
            ASSIGN tt-w-report.campo-c[8] = "< Todas las MARCAS >".
        END.
        ELSE DO:
            ASSIGN tt-w-report.campo-c[8] = "** ERROR **".
            FIND FIRST almtabla WHERE almtabla.tabla = "MK" AND
                                        almtabla.codigo = rbte_linea_movimiento.campo-c[3]
                                        NO-LOCK NO-ERROR.
            IF AVAILABLE almtabla THEN DO:
                ASSIGN tt-w-report.campo-c[8] = almtabla.nombre.
            END.
        END.

END.

/* Lineas para la Generacion los PNC */
FOR EACH rbte_linea_generan_nc WHERE rbte_linea_generan_nc.codcia = s-codcia AND
                                        rbte_linea_generan_nc.codproceso = x-proceso NO-LOCK:
    CREATE tt-w-report.
        ASSIGN tt-w-report.campo-c[1] = rbte_linea_generan_nc.codrazon
                tt-w-report.campo-c[2] = rbte_linea_generan_nc.codlinea
                tt-w-report.campo-c[4] = rbte_linea_generan_nc.codsublinea
                tt-w-report.campo-c[7] = "*"
                tt-w-report.campo-c[8] = "< Todas las MARCAS >"
                tt-w-report.campo-c[6] = rbte_linea_generan_nc.signo.

            IF rbte_linea_generan_nc.codlinea = '*' THEN DO:
                ASSIGN tt-w-report.campo-c[3] = "< Todas las Lineas >".
            END.
            ELSE DO:
                ASSIGN tt-w-report.campo-c[3] = "** ERROR **".
                FIND FIRST almtfami WHERE almtfami.codcia = s-codcia AND
                                            almtfami.codfam = rbte_linea_generan_nc.codlinea 
                                            NO-LOCK NO-ERROR.
                IF AVAILABLE almtfami THEN DO:
                    ASSIGN tt-w-report.campo-c[3] = almtfami.desfam.
                END.
            END.
            /**/
            IF rbte_linea_generan_nc.codsublinea = '*' THEN DO:
                ASSIGN tt-w-report.campo-c[5] = "< Todas las Sub-Lineas >".
            END.
            ELSE DO:
                ASSIGN tt-w-report.campo-c[5] = "** ERROR **".
                FIND FIRST almsfami WHERE almsfami.codcia = s-codcia AND
                                            almsfami.codfam = rbte_linea_generan_nc.codlinea AND
                                            almsfami.subfam = rbte_linea_generan_nc.codsublinea 
                                            NO-LOCK NO-ERROR.
                IF AVAILABLE almsfami THEN DO:
                    ASSIGN tt-w-report.campo-c[5] = almsfami.dessub.
                END.
            END.

END.

{&open-query-browse-4}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-procesos W-Win 
PROCEDURE carga-procesos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR x-nombre AS CHAR INIT "".

  DO WITH FRAME {&FRAME-NAME} :

      IF NOT (TRUE <> (COMBO-BOX-procesos:LIST-ITEM-PAIRS > "")) THEN COMBO-BOX-procesos:DELETE(COMBO-BOX-procesos:LIST-ITEM-PAIRS).

      FOR EACH factabla WHERE factabla.codcia = s-codcia AND
                                factabla.tabla = "REBATE" NO-LOCK:
          COMBO-BOX-procesos:ADD-LAST(factabla.nombre, factabla.codigo).
          IF TRUE <> (COMBO-BOX-procesos:SCREEN-VALUE > "") THEN DO:

            x-nombre = factabla.codigo.
            ASSIGN COMBO-BOX-procesos:SCREEN-VALUE = x-nombre.
            ASSIGN fill-in-titulo:SCREEN-VALUE = x-nombre.
          END.

      END.

      APPLY 'VALUE-CHANGED':U TO COMBO-BOX-procesos.
      
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cobranza-canjes W-Win 
PROCEDURE cobranza-canjes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-canjes.                  
                  
/* Buscar los comprobantes que sufrieron CANJE */
FOR EACH t-ccbcdocu WHERE t-ccbcdocu.coddoc <> 'N/C':
    FOR EACH ccbdcaja WHERE ccbdcaja.codcia = s-codcia AND
                            ccbdcaja.codref = t-ccbcdocu.coddoc AND
                            ccbdcaja.nroref = t-ccbcdocu.nrodoc AND
                            LOOKUP(ccbdcaja.coddoc,"CJE") > 0 NO-LOCK:

        FIND FIRST ccbcmvto WHERE ccbcmvto.codcia = s-codcia AND
                                    ccbcmvto.coddoc = ccbdcaja.coddoc AND
                                    ccbcmvto.nrodoc = ccbdcaja.nrodoc NO-LOCK NO-ERROR.

        /*FIND FIRST ccbccaja OF ccbdcaja NO-LOCK NO-ERROR.*/

        /* No ANULADOS */
        IF AVAILABLE ccbcmvto AND ccbcmvto.flgest <> "A" THEN DO:
            FIND FIRST tt-canjes WHERE tt-canjes.tcoddoc = ccbdcaja.coddoc AND
                                            tt-canjes.tnrodoc = ccbdcaja.nrodoc EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE tt-canjes THEN DO:
                CREATE tt-canjes.
                    ASSIGN tt-canjes.tcoddoc = ccbdcaja.coddoc
                            tt-canjes.tnrodoc = ccbdcaja.nrodoc.
            END.
            /**/
            FIND FIRST tt-comprobantes WHERE tt-comprobantes.tcoddoc = t-ccbcdocu.coddoc AND
                                                tt-comprobantes.tnrodoc = t-ccbcdocu.nrodoc 
                                                EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE tt-comprobantes THEN DO:
                ASSIGN tt-comprobantes.tcodcanc = ccbdcaja.coddoc
                        tt-comprobantes.tnrocanc = ccbdcaja.nrodoc
                        tt-comprobantes.tfchcanc = ccbcmvto.fchdoc
                    .
            END.

        END.
    END.
END.

/* Canjes  */
FOR EACH tt-canjes :

    /* LETRAS del CANJE */
    FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                            ccbcdocu.codref = tt-canjes.tcoddoc AND
                            ccbcdocu.nroref = tt-canjes.tnrodoc AND
                            ccbcdocu.coddoc = 'LET' AND
                            ccbcdocu.flgest <> "A" NO-LOCK:

        /* Cancelados x I/C y/o N/B */
        FOR EACH ccbdcaja WHERE ccbdcaja.codcia = s-codcia AND
                                ccbdcaja.codref = ccbcdocu.coddoc AND
                                ccbdcaja.nroref = ccbcdocu.nrodoc AND
                                LOOKUP(ccbdcaja.coddoc,"I/C,N/B,C/P") > 0 NO-LOCK:      /* C/P : Canje con proveedor */

            FIND FIRST ccbccaja OF ccbdcaja NO-LOCK NO-ERROR.

            /* No ANULADOS */
            IF AVAILABLE ccbccaja AND ccbccaja.flgest <> "A" AND ccbccaja.fchdoc <= x-cobranzas-hasta THEN DO:
                FIND FIRST tt-clientes-calculo WHERE tt-clientes-calculo.tcodcli = ccbcdocu.codcli EXCLUSIVE-LOCK NO-ERROR.

                IF AVAILABLE tt-clientes-calculo THEN DO:

                    CREATE tt-cobranzas.
                        ASSIGN tt-cobranzas.tcoddoc = ccbccaja.coddoc
                                tt-cobranzas.tnrodoc = ccbccaja.nrodoc
                                tt-cobranzas.tfhdoc = ccbccaja.fchdoc
                                tt-cobranzas.tcodmon = ccbccaja.codmon
                                tt-cobranzas.tcodref = ccbdcaja.codref
                                tt-cobranzas.tnroref = ccbdcaja.nroref
                                tt-cobranzas.tcodcli = ccbcdocu.codcli
                                tt-cobranzas.tmonref = ccbcdocu.codmon
                                tt-cobranzas.timptot = ccbdcaja.imptot
                            .

                    IF ccbdcaja.codmon = 2 THEN DO:
                        ASSIGN tt-clientes-calculo.tcobros = tt-clientes-calculo.tcobros + (ccbdcaja.imptot * ccbdcaja.tpocmb).
                    END.
                    ELSE DO: 
                        ASSIGN tt-clientes-calculo.tcobros = tt-clientes-calculo.tcobros + ccbdcaja.imptot.
                    END.
                END.
            END.
        END.
    END.

END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cobranza-comprobantes W-Win 
PROCEDURE cobranza-comprobantes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-importe AS DEC.        
DEFINE VAR x-signo AS INT.

EMPTY TEMP-TABLE tt-canjes.
        
/* La cancelacion de los documentos NO Notas de credito */
FOR EACH t-ccbcdocu WHERE t-ccbcdocu.coddoc <> 'N/C' :
    x-importe = 0.
    FOR EACH ccbdcaja WHERE ccbdcaja.codcia = s-codcia AND
                            ccbdcaja.codref = t-ccbcdocu.coddoc AND
                            ccbdcaja.nroref = t-ccbcdocu.nrodoc AND
                            LOOKUP(ccbdcaja.coddoc,"I/C,E/C,A/C,C/P") > 0 NO-LOCK:

        FIND FIRST ccbccaja OF ccbdcaja NO-LOCK NO-ERROR.

        /* No ANULADOS */
        IF AVAILABLE ccbccaja AND ccbccaja.flgest <> "A" AND ccbccaja.fchdoc <= x-cobranzas-hasta THEN DO:
            x-signo = 1.
            IF ccbdcaja.coddoc = 'E/C' THEN x-signo = -1.

            IF ccbdcaja.codmon = 2 THEN DO:
                x-importe = x-importe + ((ccbdcaja.imptot * ccbdcaja.tpocmb) * x-signo).
            END.
            ELSE DO: 
                x-importe = x-importe + (ccbdcaja.imptot * x-signo).
            END.

            CREATE tt-cobranzas.
                ASSIGN tt-cobranzas.tcoddoc = ccbccaja.coddoc
                        tt-cobranzas.tnrodoc = ccbccaja.nrodoc
                        tt-cobranzas.tfhdoc = ccbccaja.fchdoc
                        tt-cobranzas.tcodmon = ccbccaja.codmon
                        tt-cobranzas.tcodref = ccbdcaja.codref
                        tt-cobranzas.tnroref = ccbdcaja.nroref
                        tt-cobranzas.tcodcli = t-ccbcdocu.codcli
                        tt-cobranzas.tmonref = t-ccbcdocu.codmon
                        tt-cobranzas.timptot = ccbdcaja.imptot
                    .
        END.

    END.

    FIND FIRST tt-clientes-calculo WHERE tt-clientes-calculo.tcodcli = t-ccbcdocu.codcli EXCLUSIVE-LOCK NO-ERROR.

    IF AVAILABLE tt-clientes-calculo THEN DO:
        ASSIGN tt-clientes-calculo.tcobros = tt-clientes-calculo.tcobros + x-importe.
    END.
END.

/* Resto las Aplicaciones de las N/C */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE configuracion-eventos W-Win 
PROCEDURE configuracion-eventos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-eventos.

/* INCLUSIONES */

/* Existe todas las Listas de Precios */
FOR EACH rbte_evento_movimiento WHERE rbte_evento_movimiento.codcia = s-codcia AND
                                        rbte_evento_movimiento.codproceso = x-proceso AND
                                        rbte_evento_movimiento.coddiv = '*' AND
                                        rbte_evento_movimiento.signo = '+' NO-LOCK:

    /* Lista de Precios y Ambas */
    FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia /*AND
                            (gn-divi.campo-char[1] = 'L' OR gn-divi.campo-char[1] = 'A')*/
                                NO-LOCK:
        CREATE tt-eventos.
                ASSIGN tt-eventos.trazon = rbte_evento_movimiento.codrazon
                        tt-eventos.tcoddiv = gn-divi.coddiv.
    END.

END.

/* Lista de Precio con signo (+) */
FOR EACH rbte_evento_movimiento WHERE rbte_evento_movimiento.codcia = s-codcia AND
                                        rbte_evento_movimiento.codproceso = x-proceso AND
                                        rbte_evento_movimiento.coddiv <> "*" AND
                                        rbte_evento_movimiento.signo = '+'
                                        NO-LOCK:

    FIND FIRST tt-eventos WHERE tt-eventos.trazon = rbte_evento_movimiento.codrazon AND
                                tt-eventos.tcoddiv = rbte_evento_movimiento.coddiv NO-ERROR.
    IF NOT AVAILABLE tt-eventos THEN DO:
        CREATE tt-eventos.
                ASSIGN  tt-eventos.trazon = rbte_evento_movimiento.codrazon
                        tt-eventos.tcoddiv = rbte_evento_movimiento.coddiv.
    END.

END.

/* LAS EXCLUSIONES */

/* Lista de Precio con signo (-) */
FOR EACH rbte_evento_movimiento WHERE rbte_evento_movimiento.codcia = s-codcia AND
                                        rbte_evento_movimiento.codproceso = x-proceso AND
                                        rbte_evento_movimiento.coddiv <> "*" AND
                                        rbte_evento_movimiento.signo = '-'
                                        NO-LOCK:
    FIND FIRST tt-eventos WHERE tt-eventos.trazon = rbte_evento_movimiento.codrazon AND
                                tt-eventos.tcoddiv = rbte_evento_movimiento.coddiv NO-ERROR.
    IF AVAILABLE tt-eventos THEN DO:
        DELETE tt-eventos.
    END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE configuracion-lineas W-Win 
PROCEDURE configuracion-lineas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-lineas.

/* INCLUSIONES */

/* Todas las Lineas y SubLineas */
FOR EACH rbte_linea_movimiento WHERE rbte_linea_movimiento.codcia = s-codcia AND
                                        rbte_linea_movimiento.codproceso = x-proceso AND
                                        rbte_linea_movimiento.codlinea = '*' AND
                                        rbte_linea_movimiento.signo = '+' NO-LOCK.
    FOR EACH almtfami WHERE almtfami.codcia = s-codcia NO-LOCK:
        FOR EACH almsfami OF almtfami NO-LOCK:
            /*
            IF rbte_linea_movimiento.campo-c[3] = '*' THEN DO:
                FOR EACH almtabla WHERE almtabla.tabla = 'MK' NO-LOCK:
                    FIND FIRST tt-lineas WHERE tt-lineas.trazon = rbte_linea_movimiento.codrazon AND
                                                tt-lineas.tcodfam = almtfam.codfam AND
                                                tt-lineas.tsubfam = almsfam.subfam AND 
                                                tt-lineas.tmarca = almtabla.codigo
                                                EXCLUSIVE-LOCK NO-ERROR.
                    IF NOT AVAILABLE tt-lineas THEN DO:
                        CREATE tt-lineas.
                            ASSIGN  tt-lineas.trazon = rbte_linea_movimiento.codrazon
                                    tt-lineas.tcodfam = almtfami.codfam
                                    tt-lineas.tsubfam = almsfami.subfam
                                    tt-lineas.tmarca = almtabla.codigo
                                    .
                    END.
                END.
            END.
            ELSE DO:
            */
                FIND FIRST tt-lineas WHERE tt-lineas.trazon = rbte_linea_movimiento.codrazon AND
                                            tt-lineas.tcodfam = almtfam.codfam AND
                                            tt-lineas.tsubfam = almsfam.subfam AND 
                                            tt-lineas.tmarca = rbte_linea_movimiento.campo-c[3]
                                            EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE tt-lineas THEN DO:
                    CREATE tt-lineas.
                        ASSIGN  tt-lineas.trazon = rbte_linea_movimiento.codrazon
                                tt-lineas.tcodfam = almtfami.codfam
                                tt-lineas.tsubfam = almsfami.subfam
                                tt-lineas.tmarca = rbte_linea_movimiento.campo-c[3]
                                .
                END.
            /*END.*/
        END.                                
    END.
END.

/* Linea y todas las SubLineas (*) con signo (+) */
FOR EACH rbte_linea_movimiento WHERE rbte_linea_movimiento.codcia = s-codcia AND
                                        rbte_linea_movimiento.codproceso = x-proceso AND
                                        rbte_linea_movimiento.codlinea <> "*" AND
                                        rbte_linea_movimiento.codsublinea = '*' AND
                                        rbte_linea_movimiento.signo = '+'
                                        NO-LOCK:
    FOR EACH almtfami WHERE almtfami.codcia = s-codcia AND
                            almtfami.codfam = rbte_linea_movimiento.codlinea NO-LOCK:
        FOR EACH almsfami OF almtfami NO-LOCK:
            /*
            IF rbte_linea_movimiento.campo-c[3] = '*' THEN DO:
                FOR EACH almtabla WHERE almtabla.tabla = 'MK' NO-LOCK:
                    FIND FIRST tt-lineas WHERE tt-lineas.trazon = rbte_linea_movimiento.codrazon AND
                                                tt-lineas.tcodfam = almtfam.codfam AND
                                                tt-lineas.tsubfam = almsfam.subfam AND 
                                                tt-lineas.tmarca = almtabla.codigo
                                                EXCLUSIVE-LOCK NO-ERROR.
                    IF NOT AVAILABLE tt-lineas THEN DO:
                        CREATE tt-lineas.
                            ASSIGN  tt-lineas.trazon = rbte_linea_movimiento.codrazon
                                    tt-lineas.tcodfam = almtfami.codfam
                                    tt-lineas.tsubfam = almsfami.subfam
                                    tt-lineas.tmarca = almtabla.codigo
                                    .
                    END.
                END.
            END.
            ELSE DO:
            */
                FIND FIRST tt-lineas WHERE tt-lineas.trazon = rbte_linea_movimiento.codrazon AND
                                            tt-lineas.tcodfam = almtfam.codfam AND
                                            tt-lineas.tsubfam = almsfam.subfam AND 
                                            tt-lineas.tmarca = rbte_linea_movimiento.campo-c[3]
                                            EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE tt-lineas THEN DO:
                    CREATE tt-lineas.
                        ASSIGN  tt-lineas.trazon = rbte_linea_movimiento.codrazon
                                tt-lineas.tcodfam = almtfami.codfam
                                tt-lineas.tsubfam = almsfami.subfam
                                tt-lineas.tmarca = rbte_linea_movimiento.campo-c[3]
                                .
                END.

            /*END.*/
            /*
            FIND FIRST tt-lineas WHERE tt-lineas.trazon = rbte_linea_movimiento.codrazon AND
                                        tt-lineas.tcodfam = almtfam.codfam AND
                                        tt-lineas.tsubfam = almsfam.subfam AND
                                        tt-lineas.tmarca = rbte_linea_movimiento.campo-c[3]
                                        EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE tt-lineas THEN DO:
                CREATE tt-lineas.
                    ASSIGN  tt-lineas.trazon = rbte_linea_movimiento.codrazon
                            tt-lineas.tcodfam = almtfami.codfam
                            tt-lineas.tsubfam = almsfami.subfam
                            tt-lineas.tmarca = rbte_linea_movimiento.campo-c[3].
            END.
            */
        END.
    END.
END.
/* Linea y SubLinea con signo (+) */
FOR EACH rbte_linea_movimiento WHERE rbte_linea_movimiento.codcia = s-codcia AND
                                        rbte_linea_movimiento.codproceso = x-proceso AND
                                        rbte_linea_movimiento.codlinea <> "*" AND
                                        rbte_linea_movimiento.codsublinea <> '*' AND
                                        rbte_linea_movimiento.signo = '+'
                                        NO-LOCK:
    FOR EACH almtfami WHERE almtfami.codcia = s-codcia AND
                            almtfami.codfam = rbte_linea_movimiento.codlinea NO-LOCK:
        FOR EACH almsfami WHERE almsfami.codcia = s-codcia AND
                                almsfami.codfam = rbte_linea_movimiento.codlinea AND
                                almsfami.subfam = rbte_linea_movimiento.codsublinea NO-LOCK:

            /*
            IF rbte_linea_movimiento.campo-c[3] = '*' THEN DO:
                FOR EACH almtabla WHERE almtabla.tabla = 'MK' NO-LOCK:
                    FIND FIRST tt-lineas WHERE tt-lineas.trazon = rbte_linea_movimiento.codrazon AND
                                                tt-lineas.tcodfam = almtfam.codfam AND
                                                tt-lineas.tsubfam = almsfam.subfam AND 
                                                tt-lineas.tmarca = almtabla.codigo
                                                EXCLUSIVE-LOCK NO-ERROR.
                    IF NOT AVAILABLE tt-lineas THEN DO:
                        CREATE tt-lineas.
                            ASSIGN  tt-lineas.trazon = rbte_linea_movimiento.codrazon
                                    tt-lineas.tcodfam = almtfami.codfam
                                    tt-lineas.tsubfam = almsfami.subfam
                                    tt-lineas.tmarca = almtabla.codigo
                                    .
                    END.
                END.
            END.
            ELSE DO:
            */
                FIND FIRST tt-lineas WHERE tt-lineas.trazon = rbte_linea_movimiento.codrazon AND
                                            tt-lineas.tcodfam = almtfam.codfam AND
                                            tt-lineas.tsubfam = almsfam.subfam AND 
                                            tt-lineas.tmarca = rbte_linea_movimiento.campo-c[3]
                                            EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE tt-lineas THEN DO:
                    CREATE tt-lineas.
                        ASSIGN  tt-lineas.trazon = rbte_linea_movimiento.codrazon
                                tt-lineas.tcodfam = almtfami.codfam
                                tt-lineas.tsubfam = almsfami.subfam
                                tt-lineas.tmarca = rbte_linea_movimiento.campo-c[3]
                                .
                END.
            /*END.*/

        END.
    END.
END.

/* LAS EXCLUSIONES */

/* Linea y todas las SubLineas (*) con signo (-) */
FOR EACH rbte_linea_movimiento WHERE rbte_linea_movimiento.codcia = s-codcia AND
                                        rbte_linea_movimiento.codproceso = x-proceso AND
                                        rbte_linea_movimiento.codlinea <> "*" AND
                                        rbte_linea_movimiento.codsublinea = '*' AND
                                        rbte_linea_movimiento.signo = '-'
                                        NO-LOCK:
    FOR EACH almtfami WHERE almtfami.codcia = s-codcia AND
                            almtfami.codfam = rbte_linea_movimiento.codlinea NO-LOCK:
        FOR EACH almsfami OF almtfami NO-LOCK:
            /*
            IF rbte_linea_movimiento.campo-c[3] = '*' THEN DO:
                FOR EACH almtabla WHERE almtabla.tabla = 'MK' NO-LOCK:
                    FIND FIRST tt-lineas WHERE tt-lineas.trazon = rbte_linea_movimiento.codrazon AND
                                                tt-lineas.tcodfam = almtfam.codfam AND
                                                tt-lineas.tsubfam = almsfam.subfam AND 
                                                tt-lineas.tmarca = almtabla.codigo
                                                EXCLUSIVE-LOCK NO-ERROR.
                    IF NOT AVAILABLE tt-lineas THEN DO:
                        DELETE tt-lineas.
                    END.
                END.
            END.
            ELSE DO:
            */
                FIND FIRST tt-lineas WHERE tt-lineas.trazon = rbte_linea_movimiento.codrazon AND
                                            tt-lineas.tcodfam = almtfam.codfam AND
                                            tt-lineas.tsubfam = almsfam.subfam AND 
                                            tt-lineas.tmarca = rbte_linea_movimiento.campo-c[3]
                                            EXCLUSIVE-LOCK NO-ERROR.
                IF AVAILABLE tt-lineas THEN DO:
                    DELETE tt-lineas.
                END.
            /*END.*/

            /*
            FIND FIRST tt-lineas WHERE  tt-lineas.trazon = rbte_linea_movimiento.codrazon AND
                                        tt-lineas.tcodfam = almtfam.codfam AND
                                        tt-lineas.tsubfam = almsfam.subfam NO-ERROR.
            IF AVAILABLE tt-lineas THEN DO:
                DELETE tt-lineas.
            END.
            */
        END.
    END.
END.
/* Linea y SubLinea con signo (-) */
FOR EACH rbte_linea_movimiento WHERE rbte_linea_movimiento.codcia = s-codcia AND
                                        rbte_linea_movimiento.codproceso = x-proceso AND
                                        rbte_linea_movimiento.codlinea <> "*" AND
                                        rbte_linea_movimiento.codsublinea <> '*' AND
                                        rbte_linea_movimiento.signo = '-'
                                        NO-LOCK:
    FOR EACH almtfami WHERE almtfami.codcia = s-codcia AND
                            almtfami.codfam = rbte_linea_movimiento.codlinea NO-LOCK:
        FOR EACH almsfami WHERE almsfami.codcia = s-codcia AND
                                almsfami.codfam = rbte_linea_movimiento.codlinea AND
                                almsfami.subfam = rbte_linea_movimiento.codsublinea NO-LOCK:
            /*
            IF rbte_linea_movimiento.campo-c[3] = '*' THEN DO:
                FOR EACH almtabla WHERE almtabla.tabla = 'MK' NO-LOCK:
                    FIND FIRST tt-lineas WHERE tt-lineas.trazon = rbte_linea_movimiento.codrazon AND
                                                tt-lineas.tcodfam = almtfam.codfam AND
                                                tt-lineas.tsubfam = almsfam.subfam AND 
                                                tt-lineas.tmarca = almtabla.codigo
                                                EXCLUSIVE-LOCK NO-ERROR.
                    IF NOT AVAILABLE tt-lineas THEN DO:
                        DELETE tt-lineas.
                    END.
                END.
            END.
            ELSE DO:
            */
                FIND FIRST tt-lineas WHERE tt-lineas.trazon = rbte_linea_movimiento.codrazon AND
                                            tt-lineas.tcodfam = almtfam.codfam AND
                                            tt-lineas.tsubfam = almsfam.subfam AND 
                                            tt-lineas.tmarca = rbte_linea_movimiento.campo-c[3]
                                            EXCLUSIVE-LOCK NO-ERROR.
                IF AVAILABLE tt-lineas THEN DO:
                    DELETE tt-lineas.
                END.
            /*END.*/
            /*
            FIND FIRST tt-lineas WHERE  tt-lineas.trazon = rbte_linea_movimiento.codrazon AND
                                        tt-lineas.tcodfam = almtfam.codfam AND
                                        tt-lineas.tsubfam = almsfam.subfam NO-LOCK NO-ERROR.
            IF NOT AVAILABLE tt-lineas THEN DO:
                DELETE tt-lineas.
            END.
            */
        END.
    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE configuracion-lineas-gen-pnc W-Win 
PROCEDURE configuracion-lineas-gen-pnc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-lineas-gen-pnc.

/* INCLUSIONES */

/* Todas las Lineas y SubLineas */
FOR EACH rbte_linea_generan_nc WHERE rbte_linea_generan_nc.codcia = s-codcia AND
                                        rbte_linea_generan_nc.codproceso = x-proceso AND
                                        rbte_linea_generan_nc.codlinea = '*' AND
                                        rbte_linea_generan_nc.signo = '+' NO-LOCK.
    FOR EACH almtfami WHERE almtfami.codcia = s-codcia NO-LOCK:
        FOR EACH almsfami OF almtfami NO-LOCK:
            CREATE tt-lineas-gen-pnc.
                ASSIGN  tt-lineas-gen-pnc.trazon = rbte_linea_generan_nc.codrazon
                        tt-lineas-gen-pnc.tcodfam = almtfami.codfam
                        tt-lineas-gen-pnc.tsubfam = almsfami.subfam.
        END.                                
    END.

END.

/* Linea y todas las SubLineas (*) con signo (+) */
FOR EACH rbte_linea_generan_nc WHERE rbte_linea_generan_nc.codcia = s-codcia AND
                                        rbte_linea_generan_nc.codproceso = x-proceso AND
                                        rbte_linea_generan_nc.codlinea <> "*" AND
                                        rbte_linea_generan_nc.codsublinea = '*' AND
                                        rbte_linea_generan_nc.signo = '+'
                                        NO-LOCK:
    FOR EACH almtfami WHERE almtfami.codcia = s-codcia AND
                            almtfami.codfam = rbte_linea_generan_nc.codlinea NO-LOCK:
        FOR EACH almsfami OF almtfami NO-LOCK:
            FIND FIRST tt-lineas-gen-pnc WHERE tt-lineas-gen-pnc.trazon = rbte_linea_generan_nc.codrazon AND
                                        tt-lineas-gen-pnc.tcodfam = almtfam.codfam AND
                                        tt-lineas-gen-pnc.tsubfam = almsfam.subfam EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE tt-lineas-gen-pnc THEN DO:
                CREATE tt-lineas-gen-pnc.
                    ASSIGN  tt-lineas-gen-pnc.trazon = rbte_linea_generan_nc.codrazon
                            tt-lineas-gen-pnc.tcodfam = almtfami.codfam
                            tt-lineas-gen-pnc.tsubfam = almsfami.subfam.
            END.
        END.
    END.
END.
/* Linea y SubLinea con signo (+) */
FOR EACH rbte_linea_generan_nc WHERE rbte_linea_generan_nc.codcia = s-codcia AND
                                        rbte_linea_generan_nc.codproceso = x-proceso AND
                                        rbte_linea_generan_nc.codlinea <> "*" AND
                                        rbte_linea_generan_nc.codsublinea <> '*' AND
                                        rbte_linea_generan_nc.signo = '+'
                                        NO-LOCK:
    FOR EACH almtfami WHERE almtfami.codcia = s-codcia AND
                            almtfami.codfam = rbte_linea_generan_nc.codlinea NO-LOCK:
        /*FOR EACH almsfami OF almtfami NO-LOCK:*/
        FOR EACH almsfami WHERE almsfami.codcia = s-codcia AND
                                almsfami.codfam = rbte_linea_generan_nc.codlinea AND
                                almsfami.subfam = rbte_linea_generan_nc.codsublinea NO-LOCK:

            FIND FIRST tt-lineas-gen-pnc WHERE  tt-lineas-gen-pnc.trazon = rbte_linea_generan_nc.codrazon AND
                                        tt-lineas-gen-pnc.tcodfam = almtfam.codfam AND
                                        tt-lineas-gen-pnc.tsubfam = almsfam.subfam NO-LOCK NO-ERROR.
            IF NOT AVAILABLE tt-lineas-gen-pnc THEN DO:
                CREATE tt-lineas-gen-pnc.
                    ASSIGN  tt-lineas-gen-pnc.trazon = rbte_linea_generan_nc.codrazon
                            tt-lineas-gen-pnc.tcodfam = almtfami.codfam
                            tt-lineas-gen-pnc.tsubfam = almsfami.subfam.
            END.
        END.
    END.
END.

/* LAS EXCLUSIONES */

/* Linea y todas las SubLineas (*) con signo (-) */
FOR EACH rbte_linea_generan_nc WHERE rbte_linea_generan_nc.codcia = s-codcia AND
                                        rbte_linea_generan_nc.codproceso = x-proceso AND
                                        rbte_linea_generan_nc.codlinea <> "*" AND
                                        rbte_linea_generan_nc.codsublinea = '*' AND
                                        rbte_linea_generan_nc.signo = '-'
                                        NO-LOCK:
    FOR EACH almtfami WHERE almtfami.codcia = s-codcia AND
                            almtfami.codfam = rbte_linea_generan_nc.codlinea NO-LOCK:
        FOR EACH almsfami OF almtfami NO-LOCK:
            FIND FIRST tt-lineas-gen-pnc WHERE  tt-lineas-gen-pnc.trazon = rbte_linea_generan_nc.codrazon AND
                                        tt-lineas-gen-pnc.tcodfam = almtfam.codfam AND
                                        tt-lineas-gen-pnc.tsubfam = almsfam.subfam NO-ERROR.
            IF AVAILABLE tt-lineas-gen-pnc THEN DO:
                DELETE tt-lineas-gen-pnc.
            END.
        END.
    END.
END.
/* Linea y SubLinea con signo (-) */
FOR EACH rbte_linea_generan_nc WHERE rbte_linea_generan_nc.codcia = s-codcia AND
                                        rbte_linea_generan_nc.codproceso = x-proceso AND
                                        rbte_linea_generan_nc.codlinea <> "*" AND
                                        rbte_linea_generan_nc.codsublinea <> '*' AND
                                        rbte_linea_generan_nc.signo = '-'
                                        NO-LOCK:
    FOR EACH almtfami WHERE almtfami.codcia = s-codcia AND
                            almtfami.codfam = rbte_linea_generan_nc.codlinea NO-LOCK:
        FOR EACH almsfami WHERE almsfami.codcia = s-codcia AND
                                almsfami.codfam = rbte_linea_generan_nc.codlinea AND
                                almsfami.subfam = rbte_linea_generan_nc.codsublinea NO-LOCK:

            FIND FIRST tt-lineas-gen-pnc WHERE  tt-lineas-gen-pnc.trazon = rbte_linea_generan_nc.codrazon AND
                                        tt-lineas-gen-pnc.tcodfam = almtfam.codfam AND
                                        tt-lineas-gen-pnc.tsubfam = almsfam.subfam NO-LOCK NO-ERROR.
            IF NOT AVAILABLE tt-lineas-gen-pnc THEN DO:
                DELETE tt-lineas-gen-pnc.
            END.
        END.
    END.
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
  DISPLAY FILL-IN-titulo COMBO-BOX-procesos RADIO-SET-tipodoc 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-procesar COMBO-BOX-procesos BROWSE-4 BROWSE-2 BROWSE-5 
         RADIO-SET-tipodoc 
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

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

c-xls-file = 'd:\xpciman\calculo-rebate-v2.xlsx'.

run pi-crea-archivo-csv IN hProc (input  buffer tt-clientes-calculo:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-clientes-calculo:handle,
                        input  c-csv-file,
                        output c-xls-file) .

/* ------------------------------------------------------------------------------- */
c-xls-file = 'd:\xpciman\calculo-rebate-cobranzas.xlsx'.

run pi-crea-archivo-csv IN hProc (input  buffer tt-cobranzas:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-cobranzas:handle,
                        input  c-csv-file,
                        output c-xls-file) .

/* ------------------------------------------------------------------------------ */
c-xls-file = 'd:\xpciman\calculo-rebate-header.xlsx'.

run pi-crea-archivo-csv IN hProc (input  buffer pnc-ccbcdocu:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer pnc-ccbcdocu:handle,
                        input  c-csv-file,
                        output c-xls-file) .

/* ----------------------------------------------------------------------------- */
c-xls-file = 'd:\xpciman\calculo-rebate-detail.xlsx'.

run pi-crea-archivo-csv IN hProc (input  buffer pnc-ccbddocu:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer pnc-ccbddocu:handle,
                        input  c-csv-file,
                        output c-xls-file) .

/* ---------------------------------------------------------------------------- */

c-xls-file = 'd:\xpciman\calculo-rebate-comprobantes.xlsx'.

run pi-crea-archivo-csv IN hProc (input  buffer tt-comprobantes:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-comprobantes:handle,
                        input  c-csv-file,
                        output c-xls-file) .
/* ---------------------------------------------------------------------------- */

c-xls-file = 'd:\xpciman\calculo-rebate-comprobantes-dtl.xlsx'.

run pi-crea-archivo-csv IN hProc (input  buffer tt-comprobantes-dtl:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-comprobantes-dtl:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.


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
  COMBO-BOX-procesos:DELETE(COMBO-BOX-procesos:NUM-ITEMS) IN FRAME {&FRAME-NAME}.

  RUN carga-procesos.
  RUN carga-lineas.
  RUN carga-eventos.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE movimiento-gen-pnc W-Win 
PROCEDURE movimiento-gen-pnc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-fecha-desde AS DATE.
DEFINE VAR x-fecha-hasta AS DATE.

DEFINE VAR x-importe-premio-ganado AS DEC.
DEFINE VAR x-importe-premio-calculado AS DEC.
DEFINE VAR x-importe AS DEC.
DEFINE VAR x-tpocmb AS DEC.

DEFINE VAR x-header AS LOG.
DEFINE VAR x-ciclo-concluido AS LOG.
DEFINE VAR x-nro-doc AS INT.
DEFINE VAR x-item AS INT.
DEFINE VAR x-lineas AS CHAR.

DEFINE VAR x-ImpBrt AS DEC.
DEFINE VAR x-ImpIgv AS DEC.
DEFINE VAR x-ImpTot AS DEC.
DEFINE VAR x-ImpExo AS DEC.

DEFINE VAR x-impte-articulo AS DEC.
DEFINE VAR x-impte-igv-tmpo AS DEC.
DEFINE VAR x-igv-tmpo AS DEC.

DEFINE VAR x-cuantos-docs AS INT.

DEFINE VAR x-QueExcluye AS CHAR.
DEFINE VAR x-tolerancia-nc-pnc-articulo AS INT.
DEFINE VAR articulo-con-notas-de-credito AS INT.

/**/
DEFINE VAR hProc AS HANDLE NO-UNDO.         /* Handle Libreria */

RUN ccb\libreria-ccb.r PERSISTENT SET hProc.

x-tolerancia-nc-pnc-articulo = 0.
RUN maximo-nc-pnc-x-articulo IN hProc (INPUT x-concepto-rebate, OUTPUT x-tolerancia-nc-pnc-articulo).   

/**/

x-nro-doc = 0.

/* Los clientes que tienen premio */
FOR EACH tt-clientes-calculo WHERE tt-clientes-calculo.tpremio > 0 BY tagrupador BY tvtaslinpremiadas DESC :

    x-importe-premio-ganado = tt-clientes-calculo.timppremio.
    x-importe-premio-calculado = 0.

    x-cuantos-docs = 0.

    /* Prorrateo el premio en los documemtos de campaña */
    FOR EACH tt-comprobantes WHERE tt-comprobantes.tcodcli = tt-clientes-calculo.tcodcli AND 
                                        tt-comprobantes.tdoc-premio = YES AND       /* Tiene itens premiados */
                                        tt-comprobantes.tgrupo-docs BEGINS 'MVTAS'      /* Solo para campaña y no campaña */
                                        BY tt-comprobantes.timppremio DESC :
        x-cuantos-docs = x-cuantos-docs + 1.
    END.

    CLIENTE_DCMTOS:
    /* Todos los documentos sin NOTAS DE CREDITO */
    FOR EACH rbte_fecha_movimiento WHERE rbte_fecha_movimiento.codcia = s-codcia AND
                                            rbte_fecha_movimiento.codproceso = x-proceso AND
                                            rbte_fecha_movimiento.codrazon BEGINS "MVTAS" NO-LOCK:   /* Solo Campañas y no campañas*/

        x-fecha-desde = rbte_fecha_movimiento.fchdesde.
        x-fecha-hasta = rbte_fecha_movimiento.fchhasta.
        
        /**/
        x-ciclo-concluido = NO.

        FOR EACH ccbcdocu USE-INDEX llave06 WHERE ccbcdocu.codcia = s-codcia AND
                                                    ccbcdocu.codcli = tt-clientes-calculo.tcodcli AND                    
                                            (ccbcdocu.fchdoc >= x-fecha-desde AND ccbcdocu.fchdoc <= x-fecha-hasta) AND
                                            LOOKUP(ccbcdocu.coddoc,x-tipo-dcmtos) > 0 AND
                                            LOOKUP(ccbcdocu.tpofac,"A,S") = 0 AND           /* Anticipos y Servicios NO VA */
                                            ccbcdocu.flgest <> "A" NO-LOCK:

            /* Verificamos si esta EXCLUIDO la condicion de venta */
            FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                        vtatabla.tabla = "WIN-TO-WIN-RBTE-CNDVTAS" AND
                                        vtatabla.llave_c1 = ccbcdocu.fmapgo NO-LOCK NO-ERROR.
            x-QueExcluye = "".
            IF AVAILABLE vtatabla THEN DO:
                x-QueExcluye = vtatabla.libre_c01.
                /* Si esta excluido para PREMIO, AMBOS no considerar */
                IF vtatabla.libre_c01 = 'AMBOS' OR vtatabla.libre_c01 = "PREMIO" THEN DO:
                    NEXT.
                END.                
            END.
        
            x-header = NO.
            x-item = 0.
            x-lineas = "".
            x-ImpBrt = 0.
            x-ImpIgv = 0.
            x-ImpTot = 0.
            x-ImpExo = 0.

            x-tpocmb = 1. 
            IF ccbcdocu.codmon = 2 THEN x-tpocmb = ccbcdocu.tpocmb. 

            /* Notas de credito del documento (ttNCItems) */
            RUN ncreditos-del-documento(INPUT ccbcdocu.coddoc, INPUT ccbcdocu.nrodoc).
        
            FOR EACH ccbddocu OF ccbcdocu NO-LOCK,
                FIRST almmmatg OF ccbddocu NO-LOCK:
                
                /* Linea esta configurada */
                FIND FIRST tt-lineas-gen-pnc WHERE tt-lineas-gen-pnc.trazon = "LGNC" AND
                                            tt-lineas-gen-pnc.tcodfam = almmmatg.codfam AND
                                            tt-lineas-gen-pnc.tsubfam = almmmatg.subfam NO-LOCK NO-ERROR.
                IF AVAILABLE tt-lineas-gen-pnc THEN DO:

                    /* Verificar si es que no estamos generando mas de una */
                    articulo-con-notas-de-credito = 0.
                    /* Ic - 15Nov2019 - Validar cuantas N/C y/o PNC sin aprobar tiene el articulo */
                    RUN articulo-con-notas-de-credito IN hProc (INPUT x-concepto-rebate, 
                                                                INPUT ccbddocu.codmat,
                                                                INPUT ccbddocu.coddoc,
                                                                INPUT ccbddocu.nrodoc,
                                                                OUTPUT articulo-con-notas-de-credito).
                                                                
                    IF articulo-con-notas-de-credito >= x-tolerancia-nc-pnc-articulo THEN DO:
                        /* El articulo ya tiene N/C y/o PNC (pendientes x aprobar) y llego al limite */
                        NEXT.
                    END.   
        
                    x-impte-articulo = (ccbddocu.implin * x-tpocmb).

                    /* Es regalo */
                    IF x-impte-articulo <= 0 THEN NEXT.

                    /* Si tiene notas de credito */
                    FIND FIRST ttNCItems WHERE tcodmat = ccbddocu.codmat NO-LOCK NO-ERROR.
                    IF AVAILABLE ttNCItems THEN DO:
                        /* El articulo tienes N/Cs que superan el importe de la FAC/BOL */
                        IF ttNCItems.timplin >= x-impte-articulo THEN NEXT.

                        /* Descontamos las N/C */
                        x-impte-articulo = x-impte-articulo - ttNCItems.timplin.
                    END.

                    IF x-importe-premio-calculado < x-importe-premio-ganado THEN DO:

                        x-importe = x-impte-articulo * (tt-clientes-calculo.tfactorpremio / 100).

                        IF (x-importe-premio-calculado + x-importe) > x-importe-premio-ganado THEN DO:
                            x-importe = x-importe-premio-ganado - x-importe-premio-calculado.
                            x-importe-premio-calculado = x-importe-premio-ganado.
                        END.
                        ELSE DO:
                            x-importe-premio-calculado = x-importe-premio-calculado + x-importe.
                        END.

                        /* Solo para validar */
                        x-igv-tmpo = ( IF ccbcdocu.porigv > 0 THEN ccbcdocu.porigv ELSE FacCfgGn.PorIgv ).
                        x-impte-igv-tmpo = x-importe - (x-importe / (1 + (x-igv-tmpo / 100))).

                        IF almmmatg.aftigv THEN DO:
                            /* El IGV es cero (2 decimales) */
                            IF x-impte-igv-tmpo < 0.005 THEN NEXT.
                        END.

                        /*  */
                        ASSIGN tt-clientes-calculo.tpremiocalc = x-importe-premio-calculado.

                        /**/
                        IF x-header = NO THEN DO:
                            x-nro-doc = x-nro-doc + 1.
                            x-header = YES.
                            CREATE pnc-ccbcdocu.
                            ASSIGN pnc-Ccbcdocu.codcia = s-codcia
                                pnc-Ccbcdocu.coddiv = s-coddiv
                                pnc-Ccbcdocu.coddoc = "PNC"
                                pnc-Ccbcdocu.nrodoc = "XXX" + STRING(x-nro-doc,"99999999")
                                pnc-Ccbcdocu.fchdoc = TODAY       /* OJO */
                                pnc-Ccbcdocu.horcie = STRING(TIME,"HH:MM:SS")
                                pnc-Ccbcdocu.fchvto = ADD-INTERVAL (TODAY, 1, 'years')
                                pnc-Ccbcdocu.codcli = ccbcdocu.codcli
                                pnc-Ccbcdocu.ruccli = ccbcdocu.ruccli
                                pnc-Ccbcdocu.nomcli = ccbcdocu.nomcli
                                pnc-Ccbcdocu.dircli = ccbcdocu.dircli
                                pnc-Ccbcdocu.porigv = ( IF ccbcdocu.porigv > 0 THEN ccbcdocu.porigv ELSE FacCfgGn.PorIgv )
                                pnc-Ccbcdocu.codmon = 1     /* SOLES */    /*Ccbcdocu.codmon*/  
                                pnc-Ccbcdocu.usuario = s-user-id
                                pnc-Ccbcdocu.tpocmb = Faccfggn.tpocmb[1]
                                pnc-Ccbcdocu.codref = ccbcdocu.coddoc
                                pnc-Ccbcdocu.nroref = ccbcdocu.nrodoc
                                pnc-Ccbcdocu.codven = ccbcdocu.codven
                                pnc-Ccbcdocu.divori = ccbcdocu.divori
                                pnc-Ccbcdocu.cndcre = 'N'
                                pnc-Ccbcdocu.fmapgo = ccbcdocu.fmapgo
                                pnc-Ccbcdocu.tpofac = "OTROS"
                                pnc-Ccbcdocu.codcta = x-concepto-rebate          /*Concepto*/
                                pnc-Ccbcdocu.tipo   = Ccbcdocu.tipo   /*"CREDITO"*/
                                pnc-Ccbcdocu.codcaja= ""
                                pnc-Ccbcdocu.FlgEst = 'T'   /* POR APROBAR */
                                pnc-Ccbcdocu.ImpBrt = 0
                                pnc-Ccbcdocu.ImpExo = 0
                                pnc-Ccbcdocu.ImpDto = 0
                                pnc-Ccbcdocu.ImpIgv = 0
                                pnc-Ccbcdocu.ImpTot = 0.

                                x-item = 0.
                        END.

                        x-item = x-item + 1.
                        /*  */
                        CREATE pnc-ccbddocu.
                            BUFFER-COPY pnc-Ccbcdocu TO pnc-Ccbddocu.
                            ASSIGN
                                pnc-Ccbddocu.nroitm = x-item
                                pnc-Ccbddocu.codmat = ccbddocu.codmat
                                pnc-Ccbddocu.factor = ccbddocu.factor
                                pnc-Ccbddocu.candes = ccbddocu.candes
                                pnc-Ccbddocu.preuni = ROUND(x-importe / ccbddocu.candes,4)
                                pnc-Ccbddocu.implin = x-importe
                                pnc-Ccbddocu.undvta = ccbddocu.undvta
                                pnc-Ccbddocu.flg_factor = ""                    /* Se va usar en la aprobacion de la PNC */
                                NO-ERROR.

                        IF almmmatg.aftigv THEN DO:
                            ASSIGN  pnc-Ccbddocu.AftIgv = Yes
                                    pnc-Ccbddocu.ImpIgv = pnc-ccbddocu.implin - (pnc-ccbddocu.implin / (1 + (pnc-Ccbcdocu.PorIgv / 100))).
                        END.
                        ELSE DO:
                            ASSIGN  Ccbddocu.AftIgv = No
                                    Ccbddocu.ImpIgv = 0.
                        END.

                        IF pnc-Ccbddocu.AftIgv = YES THEN x-ImpBrt = x-ImpBrt + pnc-ccbddocu.implin.
                        IF pnc-Ccbddocu.AftIgv = NO THEN x-ImpExo = x-ImpExo + pnc-ccbddocu.implin.
                        x-ImpIgv = x-ImpIgv + pnc-Ccbddocu.ImpIgv.
                        x-ImpTot = x-ImpTot + pnc-Ccbddocu.ImpLin.

                        /* Las lineas */
                        IF LOOKUP(almmmatg.codfam,x-lineas,",") = 0 THEN DO:
                            IF x-lineas <> "" THEN x-lineas = x-lineas + ",".
                            x-lineas = x-lineas + TRIM(almmmatg.codfam).
                        END.

                        /*  */
                        IF x-importe-premio-calculado = x-importe-premio-ganado THEN x-ciclo-concluido = yes.

                    END.
                END.
            END.

            /**/
            IF x-header = YES THEN DO:
                ASSIGN
                    pnc-ccbcdocu.libre_c01 = x-lineas       /* Todas las lineas segun los articulos contenidos */
                    pnc-Ccbcdocu.flgcie = ""
                    pnc-Ccbcdocu.ImpBrt = x-impbrt
                    pnc-Ccbcdocu.ImpExo = x-impexo
                    pnc-Ccbcdocu.ImpIgv = x-ImpIgv
                    pnc-Ccbcdocu.ImpTot = x-ImpTot
                    pnc-Ccbcdocu.ImpVta = pnc-Ccbcdocu.ImpBrt - pnc-Ccbcdocu.ImpIgv
                    pnc-Ccbcdocu.ImpBrt = pnc-Ccbcdocu.ImpBrt - pnc-Ccbcdocu.ImpIgv
                    pnc-Ccbcdocu.SdoAct = pnc-Ccbcdocu.ImpTot.
            END.
            IF x-ciclo-concluido = YES THEN LEAVE CLIENTE_DCMTOS.

        END.
    END.
END.

DELETE PROCEDURE hProc.                 /* Release Libreria */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE movimiento-gen-pncXXX W-Win 
PROCEDURE movimiento-gen-pncXXX :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-fecha-desde AS DATE.
DEFINE VAR x-fecha-hasta AS DATE.

DEFINE VAR x-importe-premio-ganado AS DEC.
DEFINE VAR x-importe-premio-calculado AS DEC.
DEFINE VAR x-importe AS DEC.
DEFINE VAR x-tpocmb AS DEC.

DEFINE VAR x-header AS LOG.
DEFINE VAR x-ciclo-concluido AS LOG.
DEFINE VAR x-nro-doc AS INT.
DEFINE VAR x-item AS INT.
DEFINE VAR x-lineas AS CHAR.

DEFINE VAR x-ImpBrt AS DEC.
DEFINE VAR x-ImpIgv AS DEC.
DEFINE VAR x-ImpTot AS DEC.
DEFINE VAR x-ImpExo AS DEC.

x-nro-doc = 0.

/* Los clientes que tienen premio */
FOR EACH tt-clientes-calculo WHERE tt-clientes-calculo.tpremio > 0 BY tagrupador BY tvtaslinpremiadas DESC :

    x-importe-premio-ganado = tt-clientes-calculo.timppremio.
    x-importe-premio-calculado = 0.

    CLIENTE_DCMTOS:
    /* Todos los documentos sin NOTAS DE CREDITO */
    FOR EACH rbte_fecha_movimiento WHERE rbte_fecha_movimiento.codcia = s-codcia AND
                                            rbte_fecha_movimiento.codproceso = x-proceso AND
                                            rbte_fecha_movimiento.codrazon = "MVTAS" NO-LOCK:   /* Solo Campañas */

        x-fecha-desde = rbte_fecha_movimiento.fchdesde.
        x-fecha-hasta = rbte_fecha_movimiento.fchhasta.
        
        /**/
        x-ciclo-concluido = NO.

        FOR EACH ccbcdocu USE-INDEX llave06 WHERE ccbcdocu.codcia = s-codcia AND
                                                    ccbcdocu.codcli = tt-clientes-calculo.tcodcli AND                    
                                            (ccbcdocu.fchdoc >= x-fecha-desde AND ccbcdocu.fchdoc <= x-fecha-hasta) AND
                                            LOOKUP(ccbcdocu.coddoc,x-tipo-dcmtos) > 0 AND
                                            LOOKUP(ccbcdocu.tpofac,"A,S") = 0 AND           /* Anticipos y Servicios NO VA */
                                            ccbcdocu.flgest <> "A" NO-LOCK:
        
            x-header = NO.
            x-item = 0.
            x-lineas = "".
            x-ImpBrt = 0.
            x-ImpIgv = 0.
            x-ImpTot = 0.
            x-ImpExo = 0.

            x-tpocmb = 1. 
            IF ccbcdocu.codmon = 2 THEN x-tpocmb = ccbcdocu.tpocmb. 
        
            FOR EACH ccbddocu OF ccbcdocu NO-LOCK,
                FIRST almmmatg OF ccbddocu NO-LOCK:
                
                /* Linea esta configurada */
                FIND FIRST tt-lineas-gen-pnc WHERE tt-lineas-gen-pnc.trazon = "LGNC" AND
                                            tt-lineas-gen-pnc.tcodfam = almmmatg.codfam AND
                                            tt-lineas-gen-pnc.tsubfam = almmmatg.subfam NO-LOCK NO-ERROR.
                IF AVAILABLE tt-lineas-gen-pnc THEN DO:
        
                    IF x-importe-premio-calculado < x-importe-premio-ganado THEN DO:
                        x-importe = (ccbddocu.implin * x-tpocmb) * (tt-clientes-calculo.tfactorpremio / 100).
                        IF (x-importe-premio-calculado + x-importe) > x-importe-premio-ganado THEN DO:
                            x-importe = x-importe-premio-ganado - x-importe-premio-calculado.
                            x-importe-premio-calculado = x-importe-premio-ganado.
                        END.
                        ELSE DO:
                            x-importe-premio-calculado = x-importe-premio-calculado + x-importe.
                        END.

                        /*  */
                        ASSIGN tt-clientes-calculo.tpremiocalc = x-importe-premio-calculado.

                        /**/
                        IF x-header = NO THEN DO:
                            x-nro-doc = x-nro-doc + 1.
                            x-header = YES.
                            CREATE pnc-ccbcdocu.
                            ASSIGN pnc-Ccbcdocu.codcia = s-codcia
                                pnc-Ccbcdocu.coddiv = s-coddiv
                                pnc-Ccbcdocu.coddoc = "PNC"
                                pnc-Ccbcdocu.nrodoc = "XXX" + STRING(x-nro-doc,"99999999")
                                pnc-Ccbcdocu.fchdoc = TODAY       /* OJO */
                                pnc-Ccbcdocu.horcie = STRING(TIME,"HH:MM:SS")
                                pnc-Ccbcdocu.fchvto = ADD-INTERVAL (TODAY, 1, 'years')
                                pnc-Ccbcdocu.codcli = ccbcdocu.codcli
                                pnc-Ccbcdocu.ruccli = ccbcdocu.ruccli
                                pnc-Ccbcdocu.nomcli = ccbcdocu.nomcli
                                pnc-Ccbcdocu.dircli = ccbcdocu.dircli
                                pnc-Ccbcdocu.porigv = ( IF ccbcdocu.porigv > 0 THEN ccbcdocu.porigv ELSE FacCfgGn.PorIgv )
                                pnc-Ccbcdocu.codmon = 1     /* SOLES */    /*Ccbcdocu.codmon*/  
                                pnc-Ccbcdocu.usuario = s-user-id
                                pnc-Ccbcdocu.tpocmb = Faccfggn.tpocmb[1]
                                pnc-Ccbcdocu.codref = ccbcdocu.coddoc
                                pnc-Ccbcdocu.nroref = ccbcdocu.nrodoc
                                pnc-Ccbcdocu.codven = ccbcdocu.codven
                                pnc-Ccbcdocu.divori = ccbcdocu.divori
                                pnc-Ccbcdocu.cndcre = 'N'
                                pnc-Ccbcdocu.fmapgo = ccbcdocu.fmapgo
                                pnc-Ccbcdocu.tpofac = "OTROS"
                                pnc-Ccbcdocu.codcta = x-concepto-rebate          /*Concepto*/
                                pnc-Ccbcdocu.tipo   = Ccbcdocu.tipo   /*"CREDITO"*/
                                pnc-Ccbcdocu.codcaja= ""
                                pnc-Ccbcdocu.FlgEst = 'T'   /* POR APROBAR */
                                pnc-Ccbcdocu.ImpBrt = 0
                                pnc-Ccbcdocu.ImpExo = 0
                                pnc-Ccbcdocu.ImpDto = 0
                                pnc-Ccbcdocu.ImpIgv = 0
                                pnc-Ccbcdocu.ImpTot = 0.

                                x-item = 0.
                        END.

                        x-item = x-item + 1.
                        /*  */
                        CREATE pnc-ccbddocu.
                            BUFFER-COPY pnc-Ccbcdocu TO pnc-Ccbddocu.
                            ASSIGN
                                pnc-Ccbddocu.nroitm = x-item
                                pnc-Ccbddocu.codmat = ccbddocu.codmat
                                pnc-Ccbddocu.factor = ccbddocu.factor
                                pnc-Ccbddocu.candes = ccbddocu.candes
                                pnc-Ccbddocu.preuni = ROUND(x-importe / ccbddocu.candes,4)
                                pnc-Ccbddocu.implin = x-importe
                                pnc-Ccbddocu.undvta = ccbddocu.undvta
                                pnc-Ccbddocu.flg_factor = ""                    /* Se va usar en la aprobacion de la PNC */
                                NO-ERROR.

                        IF almmmatg.aftigv THEN DO:
                            ASSIGN  pnc-Ccbddocu.AftIgv = Yes
                                    pnc-Ccbddocu.ImpIgv = pnc-ccbddocu.implin - (pnc-ccbddocu.implin / (1 + (pnc-Ccbcdocu.PorIgv / 100))).
                        END.
                        ELSE DO:
                            ASSIGN  Ccbddocu.AftIgv = No
                                    Ccbddocu.ImpIgv = 0.
                        END.

                        IF pnc-Ccbddocu.AftIgv = YES THEN x-ImpBrt = x-ImpBrt + pnc-ccbddocu.implin.
                        IF pnc-Ccbddocu.AftIgv = NO THEN x-ImpExo = x-ImpExo + pnc-ccbddocu.implin.
                        x-ImpIgv = x-ImpIgv + pnc-Ccbddocu.ImpIgv.
                        x-ImpTot = x-ImpTot + pnc-Ccbddocu.ImpLin.

                        /* Las lineas */
                        IF LOOKUP(almmmatg.codfam,x-lineas,",") = 0 THEN DO:
                            IF x-lineas <> "" THEN x-lineas = x-lineas + ",".
                            x-lineas = x-lineas + TRIM(almmmatg.codfam).
                        END.

                        /*  */
                        IF x-importe-premio-calculado = x-importe-premio-ganado THEN x-ciclo-concluido = yes.

                    END.
                END.
            END.

            /**/
            IF x-header = YES THEN DO:
                ASSIGN
                    pnc-ccbcdocu.libre_c01 = x-lineas       /* Todas las lineas segun los articulos contenidos */
                    pnc-Ccbcdocu.flgcie = ""
                    pnc-Ccbcdocu.ImpBrt = x-impbrt
                    pnc-Ccbcdocu.ImpExo = x-impexo
                    pnc-Ccbcdocu.ImpIgv = x-ImpIgv
                    pnc-Ccbcdocu.ImpTot = x-ImpTot
                    pnc-Ccbcdocu.ImpVta = pnc-Ccbcdocu.ImpBrt - pnc-Ccbcdocu.ImpIgv
                    pnc-Ccbcdocu.ImpBrt = pnc-Ccbcdocu.ImpBrt - pnc-Ccbcdocu.ImpIgv
                    pnc-Ccbcdocu.SdoAct = pnc-Ccbcdocu.ImpTot.
            END.
            IF x-ciclo-concluido = YES THEN LEAVE CLIENTE_DCMTOS.

        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE movimiento-vtas-lineas W-Win 
PROCEDURE movimiento-vtas-lineas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-fecha-desde AS DATE.
DEFINE VAR x-fecha-hasta AS DATE.

DEFINE VAR x-importe-premio-a-ganado AS DEC.
DEFINE VAR x-importe-premio-a-calculado AS DEC.
DEFINE VAR x-importe AS DEC.
DEFINE VAR x-tpocmb AS DEC.

/* Todos los documentos sin NOTAS DE CREDITO */
FOR EACH rbte_fecha_movimiento WHERE rbte_fecha_movimiento.codcia = s-codcia AND
                                        rbte_fecha_movimiento.codproceso = x-proceso AND
                                        rbte_fecha_movimiento.codrazon = "MVTAS" NO-LOCK:   /* Solo Campañas */

    x-fecha-desde = rbte_fecha_movimiento.fchdesde.
    x-fecha-hasta = rbte_fecha_movimiento.fchhasta.

    /* Los clientes que tienen premio */
    FOR EACH tt-clientes-calculo WHERE tt-clientes-calculo.tpremio > 0 /*AND tt-clientes-calculo.tagrupador = "" */:

        x-importe-premio-a-ganado = tt-clientes-calculo.timppremio.
        x-importe-premio-a-calculado = 0.

        CLIENTE_DCMTOS:
        FOR EACH ccbcdocu USE-INDEX llave06 WHERE ccbcdocu.codcia = s-codcia AND
                                                    ccbcdocu.codcli = tt-clientes-calculo.tcodcli AND                    
                                            (ccbcdocu.fchdoc >= x-fecha-desde AND ccbcdocu.fchdoc <= x-fecha-hasta) AND
                                            LOOKUP(ccbcdocu.coddoc,x-tipo-dcmtos) > 0 AND
                                            LOOKUP(ccbcdocu.tpofac,"A,S") = 0 AND           /* Anticipos y Servicios NO VA */
                                            ccbcdocu.flgest <> "A" NO-LOCK:

            x-tpocmb = 1. 
            IF ccbcdocu.codmon = 2 THEN x-tpocmb = ccbcdocu.tpocmb. 

            FOR EACH ccbddocu OF ccbcdocu NO-LOCK,
                FIRST almmmatg OF ccbddocu NO-LOCK:
                
                /* Linea esta configurada */
                FIND FIRST tt-lineas-gen-pnc WHERE tt-lineas-gen-pnc.trazon = "LGNC" AND
                                            tt-lineas-gen-pnc.tcodfam = almmmatg.codfam AND
                                            tt-lineas-gen-pnc.tsubfam = almmmatg.subfam NO-LOCK NO-ERROR.
                IF AVAILABLE tt-lineas-gen-pnc THEN DO:

                    ASSIGN tt-clientes-calculo.tvtaslinpremiadas = tt-clientes-calculo.tvtaslinpremiadas + (ccbddocu.implin * x-tpocmb).

                    
                    IF x-importe-premio-a-calculado < x-importe-premio-a-ganado THEN DO:
                        x-importe = (ccbddocu.implin * x-tpocmb) * (tt-clientes-calculo.tfactorpremio / 100).
                        IF (x-importe-premio-a-calculado + x-importe) > x-importe-premio-a-ganado THEN DO:
                            x-importe = x-importe-premio-a-ganado - x-importe-premio-a-calculado.
                            x-importe-premio-a-calculado = x-importe-premio-a-ganado.
                        END.
                        ELSE DO:
                            x-importe-premio-a-calculado = x-importe-premio-a-calculado + x-importe.
                        END.
                        /*IF x-importe-premio-a-calculado = x-importe-premio-a-ganado THEN LEAVE CLIENTE_DCMTOS.*/
                    END.
                END.
            END.
        END.
    END.

END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ncreditos-del-documento W-Win 
PROCEDURE ncreditos-del-documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodRef AS CHAR.     /* FAC,BOL */
DEFINE INPUT PARAMETER pNroRef AS CHAR.     /* Numero de la referencia */

DEFINE VAR x-tipocmb AS DEC INIT 0.
DEFINE VAR x-operacion AS CHAR.
DEFINE VAR x-factor AS DEC INIT 0.
DEFINE VAR x-importe AS DEC INIT 0.

EMPTY TEMP-TABLE ttNCItems.

DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER x-ccbddocu FOR ccbddocu.

DEFINE BUFFER z-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER z-ccbddocu FOR ccbddocu.


/* Tiene N/Cs la factura */
FOR EACH x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                            x-ccbcdocu.codref = pCodRef AND
                            x-ccbcdocu.nroref = pNroRef AND
                            x-ccbcdocu.coddoc = 'N/C' AND
                            x-ccbcdocu.flgest <> 'A' NO-LOCK:

    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                vtatabla.tabla = "WIN-TO-WIN-RBTE-CONC" AND
                                vtatabla.llave_c1 = pConcepto AND
                                vtatabla.llave_c2 = x-ccbcdocu.codcta NO-LOCK NO-ERROR.
    IF AVAILABLE vtatabla THEN DO:
        /* Excluido para el importe a premiar */
        IF LOOKUP(vtatabla.libre_c01,'PREMIO,AMBOS') > 0 THEN NEXT.
    END.


    x-tipocmb = 1.
    
    IF x-ccbcdocu.codmon <> ccbcdocu.codmon THEN DO:
        /* La Moneda de la factura referenciada sera la misma de la PRE NOTA */
        IF ccbcdocu.codmon = 2 THEN DO:
            /* PRE NOTA va ser Dolares, la N/C esta Soles */
            x-operacion = "DIVIDIR".
        END.
        ELSE DO:
            /* PRE NOTA va ser Soles, la N/C esta Dolares */
            x-operacion = "MULTIPLICAR".
        END.
        x-tipocmb = x-ccbcdocu.tpocmb.
    END.

    IF x-ccbcdocu.cndcre = 'D' OR (x-ccbcdocu.cndcre = 'N' AND x-ccbcdocu.tpofac = 'OTROS') THEN DO:
       /* Devolucion de Mercaderia o N/C otros pero detallado x Item*/
        FOR EACH x-ccbddocu OF x-ccbcdocu NO-LOCK:
            FIND FIRST ttNCItems WHERE tcodmat = x-ccbddocu.codmat EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE ttNCItems THEN DO:
                CREATE ttNCItems.
                ASSIGN  ttNCItems.tcodmat = x-ccbddocu.codmat.
            END.

            IF x-operacion = "DIVIDIR" THEN DO:
                ASSIGN ttNCItems.timplin = ttNCItems.timplin + (x-ccbddocu.implin / x-tipocmb).
            END.
            ELSE DO:
                ASSIGN ttNCItems.timplin = ttNCItems.timplin + (x-ccbddocu.implin * x-tipocmb).
            END.
            
        END.
    END.
    ELSE DO:        
        /* ES LA FACTURA REFERENCIADA */
        FIND FIRST z-ccbcdocu WHERE z-ccbcdocu.codcia = s-codcia AND
                                        z-ccbcdocu.coddoc = pCodRef AND
                                        z-ccbcdocu.nrodoc = pNroRef NO-LOCK NO-ERROR.
        IF AVAILABLE z-ccbcdocu THEN DO:

            /* Nota de Credito otros conceptos - SIN DETALLE*/
            IF x-operacion = "DIVIDIR" THEN DO:
                x-factor = ROUND((x-ccbcdocu.imptot / x-tipocmb )/ z-ccbcdocu.imptot,6). /* Importe N/C total entre Importe Total Factura */
            END.
            ELSE DO:
                x-factor = ROUND((x-ccbcdocu.imptot * x-tipocmb )/ z-ccbcdocu.imptot,6). /* Importe N/C total entre Importe Total Factura */
            END.
            IF x-ccbcdocu.imptot >= z-ccbcdocu.imptot THEN DO:
                /* Si el Importe de la N/C es mayor/igual al de la factura/boleta referenciada */
                x-factor = 1.
            END.

            FOR EACH z-ccbddocu OF z-ccbcdocu NO-LOCK:
                FIND FIRST ttNCItems WHERE tcodmat = z-ccbddocu.codmat EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE ttNCItems THEN DO:
                    CREATE ttNCItems.
                    ASSIGN  ttNCItems.tcodmat = z-ccbddocu.codmat.
                END.

                /* x-importe = z-ccbddocu.implin - ttNCItems.timplin.    /* Importe del articulo menos los n/c cargadas */        */
                x-importe = z-ccbddocu.implin.   

                ASSIGN ttNCItems.timplin = ttNCItems.timplin + (x-importe * x-factor).

            END.
        END.
    END.
END.

/*
EMPTY TEMP-TABLE tt-ccbddocu.

FOR EACH ccbddocu OF ccbcdocu NO-LOCK:
    CREATE tt-ccbddocu.
    BUFFER-COPY ccbddocu TO tt-ccbddocu.
    ASSIGN tt-ccbddocu.candev = 0
            tt-ccbddocu.impisc = 0
            tt-ccbddocu.aftisc = NO
            tt-ccbddocu.impdto = 0
            tt-ccbddocu.preuni = ccbddocu.implin / ccbddocu.candes.

    /* Si tiene notas de credito */
    FIND FIRST ttNCItems WHERE tcodmat = ccbddocu.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE ttNCItems THEN DO:
        ASSIGN tt-ccbddocu.impdto = ttNCItems.timplin.
    END.
    ASSIGN tt-ccbddocu.impdto2 = tt-ccbddocu.implin - tt-ccbddocu.impdto.
    IF tt-ccbddocu.impdto2 < 0 THEN ASSIGN tt-ccbddocu.impdto2 = 0.
    /*  */
    ASSIGN tt-ccbddocu.pesmat = ROUND(tt-ccbddocu.impdto2 / ccbddocu.candes,4).
END.
*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesos W-Win 
PROCEDURE procesos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE("GENERAL").

EMPTY TEMP-TABLE tt-clientes-calculo.
EMPTY TEMP-TABLE tt-agrupador.
EMPTY TEMP-TABLE tt-comprobantes-dtl.

FIND FIRST rbte_fecha_movimiento WHERE rbte_fecha_movimiento.codcia = s-codcia AND
                                        rbte_fecha_movimiento.codproceso = x-proceso AND
                                        rbte_fecha_movimiento.codrazon = "COBR" NO-LOCK NO-ERROR.

IF NOT AVAILABLE rbte_fecha_movimiento THEN DO:
    MESSAGE "No esta configurado las fechas para la cobranza de documentos"
            VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

x-cobranzas-desde = rbte_fecha_movimiento.fchdesde.
x-cobranzas-hasta = rbte_fecha_movimiento.fchhasta.

FIND FIRST rbte_Premio WHERE rbte_Premio.codcia = s-codcia AND
                                        rbte_Premio.codproceso = x-proceso
                                        NO-LOCK NO-ERROR.

IF NOT AVAILABLE rbte_Premio THEN DO:
    MESSAGE "No esta configurado % de premios"
            VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

FIND FIRST rbte_fecha_movimiento WHERE rbte_fecha_movimiento.codcia = s-codcia AND
                                        rbte_fecha_movimiento.codproceso = x-proceso AND
                                        rbte_fecha_movimiento.codrazon BEGINS "MVTAS" NO-LOCK NO-ERROR.

IF NOT AVAILABLE rbte_fecha_movimiento THEN DO:
    MESSAGE "No esta configurado las Lineas para la meta"
            VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

FIND FIRST rbte_evento_movimiento WHERE rbte_evento_movimiento.codcia = s-codcia AND
                                        rbte_evento_movimiento.codproceso = x-proceso AND
                                        rbte_evento_movimiento.codrazon BEGINS "MVTAS" NO-LOCK NO-ERROR.

IF NOT AVAILABLE rbte_evento_movimiento THEN DO:
    MESSAGE "No esta configurado las Listas de precio para la meta"
            VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

FIND FIRST rbte_linea_generan_nc WHERE rbte_linea_generan_nc.codcia = s-codcia AND
                                        rbte_linea_generan_nc.codproceso = x-proceso
                                         NO-LOCK NO-ERROR.

IF NOT AVAILABLE rbte_linea_generan_nc THEN DO:
    
    MESSAGE "No esta configurado las Lineas para la generacion de las PNC"
            VIEW-AS ALERT-BOX INFORMATION.

   RETURN.
END.

FIND FIRST Faccfggn WHERE Faccfggn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccfggn THEN DO:
    MESSAGE "La tabla FACCFGGN no existe registro de configuracion" VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".
END.
/* --------------------------------------------------------------------------------------------- */
/*  Calculo de movimientos para la meta   */
/* --------------------------------------------------------------------------------------------- */
x-factor-premio1 = rbte_Premio.premio[1].
x-factor-premio2 = rbte_Premio.premio[2].
x-factor-premio3 = rbte_Premio.premio[3].

/* Cargamos las Configuraciones */
RUN configuracion-eventos.
RUN configuracion-lineas.
RUN configuracion-lineas-gen-pnc.

/* Transacciones de ventas para la META y PREMIO */
RUN calculo-fac-bol.
RUN calculo-nc.

/* Cobranzas */
RUN cobranza-comprobantes.
RUN cobranza-canjes.

/*  */
FOR EACH tt-clientes-calculo :

    ASSIGN tt-clientes-calculo.tnomcli = "< ERROR : CLIENTE NO EXISTE >".

    FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND
                                gn-clie.codcli = tt-clientes-calculo.tcodcli NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN DO:
        ASSIGN tt-clientes-calculo.tnomcli = gn-clie.nomcli.
    END.

    IF  TRUE <> (tt-clientes-calculo.tagrupador > "") THEN DO:
        /* No tiene agrupador */
        ASSIGN tt-clientes-calculo.tventasgrp = tt-clientes-calculo.tventas
                tt-clientes-calculo.tcobrosgrp = tt-clientes-calculo.tcobros.

    END.                                                      
    ELSE DO:
        /* Si tiene agrupador */
        FIND FIRST tt-agrupador WHERE tt-agrupador.tagrupador = tt-clientes-calculo.tagrupador
                                        EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE tt-agrupador THEN DO:
            CREATE tt-agrupador.
                ASSIGN tt-agrupador.tagrupador = tt-clientes-calculo.tagrupador.
        END.
    END.
END.

DEFINE VAR x-ventas AS DEC.
DEFINE VAR x-cobros AS DEC.

/* Sumar todos los agrupados */
FOR EACH tt-agrupador :
    x-ventas = 0.
    x-cobros = 0.
    FOR EACH tt-clientes-calculo WHERE tt-clientes-calculo.tagrupador = tt-agrupador.tagrupador NO-LOCK:
        x-ventas = x-ventas + tt-clientes-calculo.tventas.
        x-cobros = x-cobros + tt-clientes-calculo.tcobros.
    END.
    FOR EACH tt-clientes-calculo WHERE tt-clientes-calculo.tagrupador = tt-agrupador.tagrupador NO-LOCK:
        ASSIGN tt-clientes-calculo.tventasgrp = x-ventas
                tt-clientes-calculo.tcobrosgrp = x-cobros.
    END.

END.

/* Calculamos que premio consiguio (1%, 1.5%, 2%) */
RUN calcula-premio.

/*RUN movimiento-vtas-lineas.*/
RUN movimiento-gen-pnc.

/* Solo desarrollo y ADMIN */
IF LOOKUP(USERID("DICTDB"),"ADMIN","MASTER") > 0  THEN DO:
    RUN enviar-excel.
END.

/* */
DEFINE VAR x-procesado AS LOG.

RUN vta2/d-rbte-calculo-premiados.r(OUTPUT x-procesado,
                                    INPUT TABLE tt-clientes-calculo,
                                    INPUT TABLE pnc-ccbcdocu,
                                    INPUT TABLE pnc-ccbddocu
                                    ).

IF x-procesado = YES THEN DO:
    DISABLE button-procesar.
END.


SESSION:SET-WAIT-STATE("").


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
  {src/adm/template/snd-list.i "eve-w-report"}
  {src/adm/template/snd-list.i "tt-w-report"}
  {src/adm/template/snd-list.i "rbte_fecha_movimiento"}

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

