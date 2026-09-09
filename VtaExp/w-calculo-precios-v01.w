&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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

/*&SCOPED-DEFINE Precio-de-Venta vtagn/precio-venta-general-v01.p*/
&SCOPED-DEFINE precio-de-Venta pri/PrecioVentaMayorCredito

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR pv-codcia AS INT.

DEFINE VAR x-ruta-xls AS CHAR INIT "".

DEFINE VAR x-despacho-anticipado AS DEC.
DEFINE VAR x-descuento-financiero AS DEC.
DEFINE VAR x-descuento-rebate AS DEC.

DEFINE TEMP-TABLE ttListaPreciosEventosPromocional
    FIELDS  tItem       AS  CHAR    FORMAT 'x(10)'  COLUMN-LABEL "Item"
    FIELDS  tCodmat     AS  CHAR    FORMAT 'x(6)'   COLUMN-LABEL "Codigo"
    FIELDS  tDesMat     AS  CHAR    FORMAT 'x(80)'  COLUMN-LABEL "Descripcion"
    FIELDS  tUndVta     AS  CHAR    FORMAT 'x(5)'   COLUMN-LABEL "Und.Vta"
    FIELDS  tMarca      AS  CHAR    FORMAT 'x(50)'  COLUMN-LABEL "Marca"
    FIELDS  tInner      AS  DEC     FORMAT '->>,>>9.99' COLUMN-LABEL "Inner"
    FIELDS  tMaster     AS  DEC     FORMAT '->>,>>9.99' COLUMN-LABEL "Master Pack"
    FIELDS  tPrecLista  AS  DEC     FORMAT '->>,>>9.9999'   COLUMN-LABEL "Precio Lista"
    FIELDS  tPrecCateg  AS  DEC     FORMAT '->>,>>9.9999'   COLUMN-LABEL "Precio Categoria"
    FIELDS  tDsctoProm  AS  DEC     FORMAT '->>,>>9.9999'   COLUMN-LABEL "Dscto Promocional"
    FIELDS  tPrecioUni  AS  DEC     FORMAT '->>,>>9.9999'   COLUMN-LABEL "Precio Incl Dscto"
    FIELDS  tFlete      AS  DEC     FORMAT '->>,>>9.9999'   COLUMN-LABEL "Flete"
    FIELDS  tPrecFinal  AS  DEC     FORMAT '->>,>>9.9999'     COLUMN-LABEL "Precio Final"
    FIELDS  tTipoDscto  AS  CHAR    FORMAT 'x(15)'  COLUMN-LABEL "Tipo Dscto Aplicado"
    FIELDS  tcodprov    AS  CHAR     FORMAT 'x(12)'     COLUMN-LABEL "Cod.Proveedor"
    FIELDS  tnomprov    AS  CHAR     FORMAT 'x(80)'     COLUMN-LABEL "Nombre Proveedor"
    INDEX idx01 tDesmat
    .

DEFINE TEMP-TABLE ttListaPreciosEventosVolumen
    FIELDS  tItem       AS  CHAR    FORMAT 'x(10)'   COLUMN-LABEL "Item"
    FIELDS  tCodmat     AS  CHAR    FORMAT 'x(6)'   COLUMN-LABEL "Codigo"
    FIELDS  tDesMat     AS  CHAR    FORMAT 'x(80)'  COLUMN-LABEL "Descripcion"
    FIELDS  tUndVta     AS  CHAR    FORMAT 'x(5)'   COLUMN-LABEL "Und.Vta"
    FIELDS  tMarca      AS  CHAR    FORMAT 'x(50)'  COLUMN-LABEL "Marca"
    FIELDS  tInner      AS  DEC     FORMAT '->>,>>9.99' COLUMN-LABEL "Inner"
    FIELDS  tMaster     AS  DEC     FORMAT '->>,>>9.99' COLUMN-LABEL "Master"
    FIELDS  tPrecLista  AS  DEC     FORMAT '->>,>>9.9999'   COLUMN-LABEL "Precio Lista/Base"
    FIELDS  tFlete      AS  DEC     FORMAT '->>,>>9.9999'   COLUMN-LABEL "Flete"
    FIELDS  tPrecFinal  AS  DEC     FORMAT '->>,>>9.9999'     COLUMN-LABEL "Precio C/Flete"
    FIELDS  tCant01     AS  DEC     FORMAT '->>,>>9.99' COLUMN-LABEL "01.- Escala"   
    FIELDS  tDscto01    AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "01.- %Dscto-Escala"
    FIELDS  tPrecFin01  AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "01.- PrecioFinal-Escala"
    FIELDS  tPFinal01   AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "01.- PrecioFinal + Flete"
    FIELDS  tCant02     AS  DEC     FORMAT '->>,>>9.99' COLUMN-LABEL "02.- Escala"
    FIELDS  tDscto02    AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "02.- %Dscto-Escala"
    FIELDS  tPrecFin02  AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "02.- PrecioFinal-Escala"
    FIELDS  tPFinal02   AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "02.- PrecioFinal + Flete"
    FIELDS  tCant03     AS  DEC     FORMAT '->>,>>9.99' COLUMN-LABEL "03.- Escala"
    FIELDS  tDscto03    AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "03.- %Dscto-Escala"
    FIELDS  tPrecFin03  AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "03.- PrecioFinal-Escala"
    FIELDS  tPFinal03   AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "03.- PrecioFinal + Flete"
    FIELDS  tCant04     AS  DEC     FORMAT '->>,>>9.99' COLUMN-LABEL "04.- Escala"
    FIELDS  tDscto04    AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "04.- %Dscto-Escala"
    FIELDS  tPrecFin04  AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "04.- PrecioFinal-Escala"
    FIELDS  tPFinal04   AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "04.- PrecioFinal + Flete"
    FIELDS  tCant05     AS  DEC     FORMAT '->>,>>9.99' COLUMN-LABEL "05.- Escala"
    FIELDS  tDscto05    AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "05.- %Dscto-Escala"
    FIELDS  tPrecFin05  AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "05.- PrecioFinal-Escala"
    FIELDS  tPFinal05   AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "05.- PrecioFinal + Flete"
    FIELDS  tCant06     AS  DEC     FORMAT '->>,>>9.99' COLUMN-LABEL "06.- Escala"
    FIELDS  tDscto06    AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "06.- %Dscto-Escala"
    FIELDS  tPrecFin06  AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "06.- PrecioFinal-Escala"
    FIELDS  tPFinal06   AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "06.- PrecioFinal + Flete"
    FIELDS  tCant07     AS  DEC     FORMAT '->>,>>9.99' COLUMN-LABEL "07.- Escala"
    FIELDS  tDscto07    AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "07.- %Dscto-Escala"
    FIELDS  tPrecFin07  AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "07.- PrecioFinal-Escala"
    FIELDS  tPFinal07   AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "07.- PrecioFinal + Flete"
    FIELDS  tCant08     AS  DEC     FORMAT '->>,>>9.99' COLUMN-LABEL "08.- Escala"
    FIELDS  tDscto08    AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "08.- %Dscto-Escala"
    FIELDS  tPrecFin08  AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "08.- PrecioFinal-Escala"
    FIELDS  tPFinal08   AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "08.- PrecioFinal + Flete"
    FIELDS  tCant09     AS  DEC     FORMAT '->>,>>9.99' COLUMN-LABEL "09.- Escala"
    FIELDS  tDscto09    AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "09.- %Dscto-Escala"
    FIELDS  tPrecFin09  AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "09.- PrecioFinal-Escala"
    FIELDS  tPFinal09   AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "09.- PrecioFinal + Flete"
    FIELDS  tCant10     AS  DEC     FORMAT '->>,>>9.99' COLUMN-LABEL "10.- Escala"
    FIELDS  tDscto10    AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "10.- %Dscto-Escala"
    FIELDS  tPrecFin10  AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "10.- PrecioFinal-Escala"
    FIELDS  tPFinal10   AS  DEC     FORMAT '->>,>>9.9999' COLUMN-LABEL "10.- PrecioFinal + Flete"
    FIELDS  tcodprov    AS  CHAR     FORMAT 'x(12)'     COLUMN-LABEL "Cod.Proveedor"
    FIELDS  tnomprov    AS  CHAR     FORMAT 'x(80)'     COLUMN-LABEL "Nombre Proveedor"
    INDEX idx01 tDesmat
    .

DEFINE TEMP-TABLE ttListaPreciosPW
    FIELDS  tItem       AS  CHAR    FORMAT 'x(10)'  COLUMN-LABEL "Item"
    FIELDS  tCodmat     AS  CHAR    FORMAT 'x(6)'   COLUMN-LABEL "Codigo"
    FIELDS  tDesMat     AS  CHAR    FORMAT 'x(80)'  COLUMN-LABEL "Descripcion"
    FIELDS  tUndVta     AS  CHAR    FORMAT 'x(5)'   COLUMN-LABEL "Und.Vta"
    FIELDS  tMarca      AS  CHAR    FORMAT 'x(50)'  COLUMN-LABEL "Marca"
    FIELDS  tPrecLista  AS  CHAR    FORMAT 'x(50)'  COLUMN-LABEL "Precio Lista"
    FIELDS  tPrecLin13  AS  CHAR    FORMAT 'x(50)'  COLUMN-LABEL "Precio Feria en Linea 13"
    FIELDS  tDsctos1    AS  CHAR    FORMAT 'x(50)'  COLUMN-LABEL "Descuentos por categoria de clientes o por volumen"
    FIELDS  tDsctos2    AS  CHAR    FORMAT 'x(50)'  COLUMN-LABEL "Descuentos por feria segun producto - 1.5% hasta 10%"
    FIELDS  tDsctos3    AS  CHAR    FORMAT 'x(50)'  COLUMN-LABEL "Precio feria, con despacho hasta 30/11 (Opcional) - 0.05%"
    FIELDS  tDsctos4    AS  CHAR    FORMAT 'x(50)'  COLUMN-LABEL "Descuentos Financiero (Opcional) - Hasta 6%"
    FIELDS  tDsctos5    AS  CHAR    FORMAT 'x(50)'  COLUMN-LABEL "Rebate/Contipunto (Opcional) - Hasta 2%"
    .

{src/bin/_prns.i}

DEF SHARED VAR s-user-id  AS CHAR.
DEF SHARED VAR s-nomcia   AS CHAR.

DEFINE VAR s-task-no AS INT.

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "vta\RBVTA.prl".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Lista de precios - PW".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

/* capturamos ruta inicial */
DEF VAR S-REPORT-LIBRARY AS CHAR.

GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE s-report-library.
RB-REPORT-LIBRARY = s-report-library + "vta/RBVTA.prl".

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
&Scoped-define INTERNAL-TABLES ttListaPreciosEventosPromocional ~
ttListaPreciosEventosVolumen

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 ttListaPreciosEventosPromocional.tItem ttListaPreciosEventosPromocional.tCodmat ttListaPreciosEventosPromocional.tDesMat ttListaPreciosEventosPromocional.tUndVta ttListaPreciosEventosPromocional.tMarca ttListaPreciosEventosPromocional.tInner ttListaPreciosEventosPromocional.tMaster ttListaPreciosEventosPromocional.tPrecLista ttListaPreciosEventosPromocional.tPrecCateg ttListaPreciosEventosPromocional.tDsctoProm ttListaPreciosEventosPromocional.tPrecioUni ttListaPreciosEventosPromocional.tFlete ttListaPreciosEventosPromocional.tPrecFinal ttListaPreciosEventosPromocional.tTipoDscto ttListaPreciosEventosPromocional.tcodprov ttListaPreciosEventosPromocional.tnomprov   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2   
&Scoped-define SELF-NAME BROWSE-2
&Scoped-define OPEN-QUERY-BROWSE-2  SESSION:SET-WAIT-STATE('GENERAL').  OPEN QUERY {&SELF-NAME} FOR EACH ttListaPreciosEventosPromocional BY ttListaPreciosEventosPromocional.tItem.  SESSION:SET-WAIT-STATE('').
&Scoped-define TABLES-IN-QUERY-BROWSE-2 ttListaPreciosEventosPromocional
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 ttListaPreciosEventosPromocional


/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 ttListaPreciosEventosVolumen.tItem ttListaPreciosEventosVolumen.tCodmat ttListaPreciosEventosVolumen.tDesMat ttListaPreciosEventosVolumen.tUndVta ttListaPreciosEventosVolumen.tMarca ttListaPreciosEventosVolumen.tInner ttListaPreciosEventosVolumen.tMaster ttListaPreciosEventosVolumen.tPrecLista ttListaPreciosEventosVolumen.tFlete ttListaPreciosEventosVolumen.tPrecFinal ttListaPreciosEventosVolumen.tCant01 ttListaPreciosEventosVolumen.tDscto01 ttListaPreciosEventosVolumen.tPrecFin01 ttListaPreciosEventosVolumen.tPFinal01 ttListaPreciosEventosVolumen.tCant02 ttListaPreciosEventosVolumen.tDscto02 ttListaPreciosEventosVolumen.tPrecFin02 ttListaPreciosEventosVolumen.tPFinal02 ttListaPreciosEventosVolumen.tCant03 ttListaPreciosEventosVolumen.tDscto03 ttListaPreciosEventosVolumen.tPrecFin03 ttListaPreciosEventosVolumen.tPFinal03 ttListaPreciosEventosVolumen.tCant04 ttListaPreciosEventosVolumen.tDscto04 ttListaPreciosEventosVolumen.tPrecFin04 ttListaPreciosEventosVolumen.tPFinal04 ttListaPreciosEventosVolumen.tCant05 ttListaPreciosEventosVolumen.tDscto05 ttListaPreciosEventosVolumen.tPrecFin05 ttListaPreciosEventosVolumen.tPFinal05 ttListaPreciosEventosVolumen.tCant06 ttListaPreciosEventosVolumen.tDscto06 ttListaPreciosEventosVolumen.tPrecFin06 ttListaPreciosEventosVolumen.tPFinal06 ttListaPreciosEventosVolumen.tCant07 ttListaPreciosEventosVolumen.tDscto07 ttListaPreciosEventosVolumen.tPrecFin07 ttListaPreciosEventosVolumen.tPFinal07 ttListaPreciosEventosVolumen.tCant08 ttListaPreciosEventosVolumen.tDscto08 ttListaPreciosEventosVolumen.tPrecFin08 ttListaPreciosEventosVolumen.tPFinal08 ttListaPreciosEventosVolumen.tCant09 ttListaPreciosEventosVolumen.tDscto09 ttListaPreciosEventosVolumen.tPrecFin09 ttListaPreciosEventosVolumen.tPFinal09 ttListaPreciosEventosVolumen.tCant10 ttListaPreciosEventosVolumen.tDscto10 ttListaPreciosEventosVolumen.tPrecFin10 ttListaPreciosEventosVolumen.tPFinal10 ttListaPreciosEventosVolumen.tcodprov ttListaPreciosEventosVolumen.tnomprov   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3   
&Scoped-define SELF-NAME BROWSE-3
&Scoped-define OPEN-QUERY-BROWSE-3  SESSION:SET-WAIT-STATE('GENERAL').  OPEN QUERY {&SELF-NAME} FOR EACH ttListaPreciosEventosVolumen BY ttListaPreciosEventosVolumen.tItem.  SESSION:SET-WAIT-STATE('').
&Scoped-define TABLES-IN-QUERY-BROWSE-3 ttListaPreciosEventosVolumen
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 ttListaPreciosEventosVolumen


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 COMBO-BOX-listaprecios BUTTON-1 ~
COMBO-BOX-familia COMBO-BOX-subfamilia BUTTON-3 ~
COMBO-BOX-ClasificacionCliente RADIO-SET-tipocliente BUTTON-12 ~
RADIO-SET-calculo RADIO-SET-proveedor FILL-IN-proveedor BUTTON-2 BROWSE-2 ~
BROWSE-3 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-listaprecios COMBO-BOX-familia ~
COMBO-BOX-subfamilia COMBO-BOX-ClasificacionCliente RADIO-SET-tipocliente ~
RADIO-SET-calculo RADIO-SET-proveedor FILL-IN-proveedor FILL-IN-nomprovee ~
FILL-IN-ruta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-12 
     LABEL "Imprimir formato especial" 
     SIZE 25 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "..." 
     SIZE 4 BY .73.

DEFINE BUTTON BUTTON-3 
     LABEL "Enviar a Excel" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX-ClasificacionCliente AS CHARACTER FORMAT "X(5)":U 
     LABEL "Clasif. Cliente" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 36 BY 1
     FONT 7 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-familia AS CHARACTER FORMAT "X(5)":U 
     LABEL "Familia" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 36 BY 1
     FONT 7 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-listaprecios AS CHARACTER FORMAT "X(6)":U 
     LABEL "Lista de Precios" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 51 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-subfamilia AS CHARACTER FORMAT "X(5)":U 
     LABEL "Sub-Familia" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 37.14 BY 1
     FONT 7 NO-UNDO.

DEFINE VARIABLE FILL-IN-nomprovee AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 64.43 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-proveedor AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-ruta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Donde grabar el archivo        ." 
     VIEW-AS FILL-IN 
     SIZE 75 BY 1
     FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE VARIABLE RADIO-SET-calculo AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Promocionales", 1,
"Volumen Normal", 2,
"Volumen Acumulados", 3
     SIZE 61 BY .96 NO-UNDO.

DEFINE VARIABLE RADIO-SET-proveedor AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", 1,
"Uno en particular", 2
     SIZE 28.57 BY 1.15 NO-UNDO.

DEFINE VARIABLE RADIO-SET-tipocliente AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "V.I.P", 1,
"Regular", 2
     SIZE 20 BY .96 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 114.57 BY 1.35.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      ttListaPreciosEventosPromocional SCROLLING.

DEFINE QUERY BROWSE-3 FOR 
      ttListaPreciosEventosVolumen SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _FREEFORM
  QUERY BROWSE-2 DISPLAY
      ttListaPreciosEventosPromocional.tItem       FORMAT 'x(10)'  COLUMN-LABEL "Item" WIDTH 5
    ttListaPreciosEventosPromocional.tCodmat     FORMAT 'x(6)'   COLUMN-LABEL "Codigo" WIDTH 7
    ttListaPreciosEventosPromocional.tDesMat     FORMAT 'x(80)'  COLUMN-LABEL "Descripcion"  WIDTH 45
    ttListaPreciosEventosPromocional.tUndVta     FORMAT 'x(5)'   COLUMN-LABEL "Und.Vta" WIDTH 4
    ttListaPreciosEventosPromocional.tMarca      FORMAT 'x(50)'  COLUMN-LABEL "Marca"  WIDTH 25
    ttListaPreciosEventosPromocional.tInner      FORMAT '->>,>>9.99' COLUMN-LABEL "Inner"
    ttListaPreciosEventosPromocional.tMaster     FORMAT '->>,>>9.99' COLUMN-LABEL "Master!Pack"
    ttListaPreciosEventosPromocional.tPrecLista  FORMAT '->>,>>9.9999'   COLUMN-LABEL "Precio!Lista"
    ttListaPreciosEventosPromocional.tPrecCateg  FORMAT '->>,>>9.9999'   COLUMN-LABEL "Precio!Categoria"
    ttListaPreciosEventosPromocional.tDsctoProm  FORMAT '->>,>>9.9999'   COLUMN-LABEL "Dscto!Promocional"
    ttListaPreciosEventosPromocional.tPrecioUni  FORMAT '->>,>>9.9999'   COLUMN-LABEL "Precio Incl!Dscto"
    ttListaPreciosEventosPromocional.tFlete      FORMAT '->>,>>9.9999'   COLUMN-LABEL "Flete"
    ttListaPreciosEventosPromocional.tPrecFinal  FORMAT '->>,>>9.9999'     COLUMN-LABEL "Precio Final"
    ttListaPreciosEventosPromocional.tTipoDscto  FORMAT 'x(15)'  COLUMN-LABEL "Tipo Dscto!Aplicado"
    ttListaPreciosEventosPromocional.tcodprov    FORMAT 'x(12)'     COLUMN-LABEL "Cod.Proveedor"
    ttListaPreciosEventosPromocional.tnomprov    FORMAT 'x(80)'     COLUMN-LABEL "Nombre Proveedor"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 131.57 BY 8.27 ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _FREEFORM
  QUERY BROWSE-3 DISPLAY
      ttListaPreciosEventosVolumen.tItem       FORMAT 'x(10)'   COLUMN-LABEL "Item" WIDTH 5
ttListaPreciosEventosVolumen.tCodmat     FORMAT 'x(6)'   COLUMN-LABEL "Codigo"  WIDTH 7
ttListaPreciosEventosVolumen.tDesMat     FORMAT 'x(80)'  COLUMN-LABEL "Descripcion"  WIDTH 40
ttListaPreciosEventosVolumen.tUndVta     FORMAT 'x(5)'   COLUMN-LABEL "Und.Vta"  WIDTH 4
ttListaPreciosEventosVolumen.tMarca      FORMAT 'x(50)'  COLUMN-LABEL "Marca"  WIDTH 25
ttListaPreciosEventosVolumen.tInner      FORMAT '->>,>>9.99' COLUMN-LABEL "Inner"
ttListaPreciosEventosVolumen.tMaster     FORMAT '->>,>>9.99' COLUMN-LABEL "Master"
ttListaPreciosEventosVolumen.tPrecLista  FORMAT '->>,>>9.9999'   COLUMN-LABEL "Precio!Lista/Base"
ttListaPreciosEventosVolumen.tFlete      FORMAT '->>,>>9.9999'   COLUMN-LABEL "Flete"
ttListaPreciosEventosVolumen.tPrecFinal  FORMAT '->>,>>9.9999'     COLUMN-LABEL "Precio!C/Flete"
ttListaPreciosEventosVolumen.tCant01     FORMAT '->>,>>9.99' COLUMN-LABEL "01.-!Escala"   
ttListaPreciosEventosVolumen.tDscto01    FORMAT '->>,>>9.9999' COLUMN-LABEL "01.-!%Dscto-Escala"
ttListaPreciosEventosVolumen.tPrecFin01  FORMAT '->>,>>9.9999' COLUMN-LABEL "01.-!PrecioFinal-Escala"
ttListaPreciosEventosVolumen.tPFinal01   FORMAT '->>,>>9.9999' COLUMN-LABEL "01.-!PrecioFinal + Flete"
ttListaPreciosEventosVolumen.tCant02     FORMAT '->>,>>9.99' COLUMN-LABEL "02.-!Escala"
ttListaPreciosEventosVolumen.tDscto02    FORMAT '->>,>>9.9999' COLUMN-LABEL "02.-!%Dscto-Escala"
ttListaPreciosEventosVolumen.tPrecFin02  FORMAT '->>,>>9.9999' COLUMN-LABEL "02.-!PrecioFinal-Escala"
ttListaPreciosEventosVolumen.tPFinal02   FORMAT '->>,>>9.9999' COLUMN-LABEL "02.-!PrecioFinal + Flete"
ttListaPreciosEventosVolumen.tCant03     FORMAT '->>,>>9.99' COLUMN-LABEL "03.-!Escala"
ttListaPreciosEventosVolumen.tDscto03    FORMAT '->>,>>9.9999' COLUMN-LABEL "03.-!%Dscto-Escala"
ttListaPreciosEventosVolumen.tPrecFin03  FORMAT '->>,>>9.9999' COLUMN-LABEL "03.-!PrecioFinal-Escala"
ttListaPreciosEventosVolumen.tPFinal03   FORMAT '->>,>>9.9999' COLUMN-LABEL "03.-!PrecioFinal + Flete"
ttListaPreciosEventosVolumen.tCant04     FORMAT '->>,>>9.99' COLUMN-LABEL "04.-!Escala"
ttListaPreciosEventosVolumen.tDscto04    FORMAT '->>,>>9.9999' COLUMN-LABEL "04.-!%Dscto-Escala"
ttListaPreciosEventosVolumen.tPrecFin04  FORMAT '->>,>>9.9999' COLUMN-LABEL "04.-!PrecioFinal-Escala"
ttListaPreciosEventosVolumen.tPFinal04   FORMAT '->>,>>9.9999' COLUMN-LABEL "04.-!PrecioFinal + Flete"
ttListaPreciosEventosVolumen.tCant05     FORMAT '->>,>>9.99' COLUMN-LABEL "05.-!Escala"
ttListaPreciosEventosVolumen.tDscto05    FORMAT '->>,>>9.9999' COLUMN-LABEL "05.-!%Dscto-Escala"
ttListaPreciosEventosVolumen.tPrecFin05  FORMAT '->>,>>9.9999' COLUMN-LABEL "05.-!PrecioFinal-Escala"
ttListaPreciosEventosVolumen.tPFinal05   FORMAT '->>,>>9.9999' COLUMN-LABEL "05.-!PrecioFinal + Flete"
ttListaPreciosEventosVolumen.tCant06     FORMAT '->>,>>9.99' COLUMN-LABEL "06.-!Escala"
ttListaPreciosEventosVolumen.tDscto06    FORMAT '->>,>>9.9999' COLUMN-LABEL "06.-!%Dscto-Escala"
ttListaPreciosEventosVolumen.tPrecFin06  FORMAT '->>,>>9.9999' COLUMN-LABEL "06.-!PrecioFinal-Escala"
ttListaPreciosEventosVolumen.tPFinal06   FORMAT '->>,>>9.9999' COLUMN-LABEL "06.-!PrecioFinal + Flete"
ttListaPreciosEventosVolumen.tCant07     FORMAT '->>,>>9.99' COLUMN-LABEL "07.-!Escala"
ttListaPreciosEventosVolumen.tDscto07    FORMAT '->>,>>9.9999' COLUMN-LABEL "07.-!%Dscto-Escala"
ttListaPreciosEventosVolumen.tPrecFin07  FORMAT '->>,>>9.9999' COLUMN-LABEL "07.-!PrecioFinal-Escala"
ttListaPreciosEventosVolumen.tPFinal07   FORMAT '->>,>>9.9999' COLUMN-LABEL "07.-!PrecioFinal + Flete"
ttListaPreciosEventosVolumen.tCant08     FORMAT '->>,>>9.99' COLUMN-LABEL "08.-!Escala"
ttListaPreciosEventosVolumen.tDscto08    FORMAT '->>,>>9.9999' COLUMN-LABEL "08.-!%Dscto-Escala"
ttListaPreciosEventosVolumen.tPrecFin08  FORMAT '->>,>>9.9999' COLUMN-LABEL "08.-!PrecioFinal-Escala"
ttListaPreciosEventosVolumen.tPFinal08   FORMAT '->>,>>9.9999' COLUMN-LABEL "08.-!PrecioFinal + Flete"
ttListaPreciosEventosVolumen.tCant09     FORMAT '->>,>>9.99' COLUMN-LABEL "09.-!Escala"
ttListaPreciosEventosVolumen.tDscto09    FORMAT '->>,>>9.9999' COLUMN-LABEL "09.-!%Dscto-Escala"
ttListaPreciosEventosVolumen.tPrecFin09  FORMAT '->>,>>9.9999' COLUMN-LABEL "09.-!PrecioFinal-Escala"
ttListaPreciosEventosVolumen.tPFinal09   FORMAT '->>,>>9.9999' COLUMN-LABEL "09.-!PrecioFinal + Flete"
ttListaPreciosEventosVolumen.tCant10     FORMAT '->>,>>9.99' COLUMN-LABEL "10.-!Escala"
ttListaPreciosEventosVolumen.tDscto10    FORMAT '->>,>>9.9999' COLUMN-LABEL "10.-!%Dscto-Escala"
ttListaPreciosEventosVolumen.tPrecFin10  FORMAT '->>,>>9.9999' COLUMN-LABEL "10.-!PrecioFinal-Escala"
ttListaPreciosEventosVolumen.tPFinal10   FORMAT '->>,>>9.9999' COLUMN-LABEL "10.-!PrecioFinal + Flete"
ttListaPreciosEventosVolumen.tcodprov    FORMAT 'x(12)'     COLUMN-LABEL "Cod.Proveedor"
ttListaPreciosEventosVolumen.tnomprov    FORMAT 'x(80)'     COLUMN-LABEL "Nombre Proveedor"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 131.72 BY 9.04 ROW-HEIGHT-CHARS .62 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-listaprecios AT ROW 1.58 COL 15 COLON-ALIGNED WIDGET-ID 4
     BUTTON-1 AT ROW 1.58 COL 115 WIDGET-ID 10
     COMBO-BOX-familia AT ROW 2.92 COL 15 COLON-ALIGNED WIDGET-ID 6
     COMBO-BOX-subfamilia AT ROW 2.92 COL 62.86 COLON-ALIGNED WIDGET-ID 8
     BUTTON-3 AT ROW 3.12 COL 115 WIDGET-ID 38
     COMBO-BOX-ClasificacionCliente AT ROW 4.12 COL 15 COLON-ALIGNED WIDGET-ID 16
     RADIO-SET-tipocliente AT ROW 4.12 COL 65.14 NO-LABEL WIDGET-ID 12
     BUTTON-12 AT ROW 5.04 COL 106 WIDGET-ID 40
     RADIO-SET-calculo AT ROW 5.23 COL 17 NO-LABEL WIDGET-ID 18
     RADIO-SET-proveedor AT ROW 6.92 COL 5.43 NO-LABEL WIDGET-ID 26
     FILL-IN-proveedor AT ROW 6.96 COL 32.57 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     FILL-IN-nomprovee AT ROW 6.96 COL 50.57 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     FILL-IN-ruta AT ROW 8.69 COL 25.29 COLON-ALIGNED WIDGET-ID 22
     BUTTON-2 AT ROW 8.85 COL 23 WIDGET-ID 24
     BROWSE-2 AT ROW 9.96 COL 2 WIDGET-ID 200
     BROWSE-3 AT ROW 14.46 COL 2.29 WIDGET-ID 300
     "Proveedor" VIEW-AS TEXT
          SIZE 10.57 BY .62 AT ROW 6.19 COL 3.72 WIDGET-ID 36
          FGCOLOR 4 
     RECT-1 AT ROW 6.81 COL 3.43 WIDGET-ID 32
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 134 BY 32.5 WIDGET-ID 100.


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
         TITLE              = "Calculos de Precios"
         HEIGHT             = 24.15
         WIDTH              = 134
         MAX-HEIGHT         = 32.5
         MAX-WIDTH          = 160.72
         VIRTUAL-HEIGHT     = 32.5
         VIRTUAL-WIDTH      = 160.72
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

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 BUTTON-2 F-Main */
/* BROWSE-TAB BROWSE-3 BROWSE-2 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-nomprovee IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ruta IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _START_FREEFORM

SESSION:SET-WAIT-STATE('GENERAL').

OPEN QUERY {&SELF-NAME} FOR EACH ttListaPreciosEventosPromocional BY ttListaPreciosEventosPromocional.tItem.

SESSION:SET-WAIT-STATE('').
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _START_FREEFORM

SESSION:SET-WAIT-STATE('GENERAL').

OPEN QUERY {&SELF-NAME} FOR EACH ttListaPreciosEventosVolumen BY ttListaPreciosEventosVolumen.tItem.

SESSION:SET-WAIT-STATE('').
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Calculos de Precios */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Calculos de Precios */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Procesar */
DO:
  ASSIGN combo-box-listaprecios combo-box-familia COMBO-BOX-subfamilia combo-box-clasificacioncliente 
      radio-set-calculo RADIO-SET-tipocliente fill-in-ruta fill-in-proveedor radio-set-proveedor.

  IF radio-set-proveedor = 2 THEN DO:
    IF fill-in-proveedor = "" OR fill-in-proveedor = ? THEN DO:
        MESSAGE "Ingrese codigo del proveedor".
        RETURN NO-APPLY.
    END.
    FIND FIRST gn-prov WHERE gn-prov.codcia = pv-codcia AND 
        gn-prov.codpro = fill-in-proveedor NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-prov THEN DO:
        MESSAGE "Codigo de proveedor no existe".
        RETURN NO-APPLY.
    END.
  END.
    /*
  IF fill-in-ruta = ? OR fill-in-ruta = "" THEN DO:
      MESSAGE "Ingrese la RUTA donde grabar el archivo EXCEL".
      RETURN NO-APPLY.
  END.  
  */
  /*
  MESSAGE combo-box-listaprecios ENTRY( combo-box-listaprecios:LOOKUP(combo-box-listaprecios) * 2 - 1 , combo-box-listaprecios:LIST-ITEM-PAIRS,"|" ).  
  MESSAGE entry(lookup(radio-set-tipocliente:screen-value,radio-set-tipocliente:radio-buttons) - 1,radio-set-tipocliente:radio-buttons) .
  */

  RUN proceso-calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-12 W-Win
ON CHOOSE OF BUTTON-12 IN FRAME F-Main /* Imprimir formato especial */
DO:
    ASSIGN combo-box-listaprecios combo-box-familia COMBO-BOX-subfamilia combo-box-clasificacioncliente 
        radio-set-calculo RADIO-SET-tipocliente fill-in-ruta fill-in-proveedor radio-set-proveedor.
    /*
    IF fill-in-ruta = ? OR fill-in-ruta = "" THEN DO:
        MESSAGE "Ingrese la RUTA donde grabar el archivo EXCEL".
        RETURN NO-APPLY.
    END.  
    */
  
    /*RUN envia-a-excel-pw.*/
    RUN imprimir-formato-especial.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* ... */
DO:
   DEFINE VAR lDirectorio AS CHAR.

        lDirectorio = "".

        SYSTEM-DIALOG GET-DIR lDirectorio  
           RETURN-TO-START-DIR 
           TITLE 'Directorio Files'.
        IF lDirectorio <> "" THEN DO :
        fill-in-ruta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = lDirectorio.  
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Enviar a Excel */
DO:
    ASSIGN combo-box-listaprecios combo-box-familia COMBO-BOX-subfamilia combo-box-clasificacioncliente 
        radio-set-calculo RADIO-SET-tipocliente fill-in-ruta fill-in-proveedor radio-set-proveedor.

    IF fill-in-ruta = ? OR fill-in-ruta = "" THEN DO:
        MESSAGE "Ingrese la RUTA donde grabar el archivo EXCEL".
        RETURN NO-APPLY.
    END.  
  
    RUN enviar-a-excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-ClasificacionCliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-ClasificacionCliente W-Win
ON VALUE-CHANGED OF COMBO-BOX-ClasificacionCliente IN FRAME F-Main /* Clasif. Cliente */
DO:
  /*RUN cargar-subfamilia(INPUT COMBO-BOX-familia:SCREEN-VALUE IN FRAME {&FRAME-NAME}).*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-familia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-familia W-Win
ON VALUE-CHANGED OF COMBO-BOX-familia IN FRAME F-Main /* Familia */
DO:
  RUN cargar-subfamilia(INPUT COMBO-BOX-familia:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-proveedor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-proveedor W-Win
ON LEAVE OF FILL-IN-proveedor IN FRAME F-Main
DO:
  DO WITH FRAME {&FRAME-NAME}:
      fill-in-nomprovee:SCREEN-VALUE = "".
      FIND FIRST gn-prov WHERE gn-prov.codcia = 0 AND 
                                gn-prov.codpro = fill-in-proveedor:SCREEN-VALUE 
                                NO-LOCK NO-ERROR.
      IF AVAILABLE gn-prov THEN fill-in-nomprovee:SCREEN-VALUE = gn-prov.nompro.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-calculo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-calculo W-Win
ON VALUE-CHANGED OF RADIO-SET-calculo IN FRAME F-Main
DO:
    DO WITH FRAME {&FRAME-NAME} :
        BROWSE-3:VISIBLE = NO.
        BROWSE-2:VISIBLE = NO.
        IF radio-set-calculo:SCREEN-VALUE = '1' THEN DO:
            BROWSE-2:VISIBLE = YES.
            BROWSE-2:X = 11.
            BROWSE-2:Y = 235.
            BROWSE-2:height = 14.73.
        END.
        ELSE DO: 
            BROWSE-3:VISIBLE = YES.
            BROWSE-3:X = 11.
            BROWSE-3:Y = 235.
            BROWSE-3:height = 14.73.
        END.
            
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-proveedor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-proveedor W-Win
ON VALUE-CHANGED OF RADIO-SET-proveedor IN FRAME F-Main
DO:
    DO WITH FRAME {&FRAME-NAME}:
        
        DISABLE fill-in-proveedor.
        IF radio-set-proveedor:SCREEN-VALUE = '2' THEN DO:
            ENABLE fill-in-proveedor.
        END.
        
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

    
DEF VAR t_col_br AS INT NO-UNDO INITIAL 11. 
DEF VAR t_col_eti AS INT NO-UNDO INITIAL 2. 

DEF VAR t_celda_br AS WIDGET-HANDLE EXTENT 80 NO-UNDO. 
DEF VAR t_cual_celda AS WIDGET-HANDLE NO-UNDO. 
DEF VAR t_n_cols_browse AS INT NO-UNDO.  
DEF VAR t_col_act AS INT NO-UNDO. 

DO t_n_cols_browse = 1 TO browse-2:NUM-COLUMNS. 
 t_celda_br[t_n_cols_browse] = browse-2:GET-BROWSE-COLUMN(t_n_cols_browse). 
 t_cual_celda = t_celda_br[t_n_cols_browse]. 
 t_cual_celda:LABEL-FGCOLOR = 9.
END.

DO t_n_cols_browse = 1 TO browse-3:NUM-COLUMNS. 
 t_celda_br[t_n_cols_browse] = browse-3:GET-BROWSE-COLUMN(t_n_cols_browse). 
 t_cual_celda = t_celda_br[t_n_cols_browse]. 
 t_cual_celda:LABEL-FGCOLOR = 4.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-subfamilia W-Win 
PROCEDURE cargar-subfamilia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pFamilia AS CHAR.

    DEFINE VAR x-sec AS INT.    

    DO WITH FRAME {&FRAME-NAME}:
        IF NOT (TRUE <> (COMBO-BOX-subfamilia:LIST-ITEM-PAIRS > "")) THEN COMBO-BOX-subfamilia:DELETE(COMBO-BOX-subfamilia:LIST-ITEM-PAIRS).

        COMBO-BOX-subfamilia:ADD-LAST("Todos", "Todos").
        COMBO-BOX-subfamilia:SCREEN-VALUE = "Todos".

        FOR EACH almsfami WHERE almsfami.codcia = s-codcia AND almsfami.codfam = pFamilia NO-LOCK:
            COMBO-BOX-subfamilia:ADD-LAST(almsfami.dessub + " (" + almsfami.subfam + ")", almsfami.subfam).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dscto-x-vol-acumulado W-Win 
PROCEDURE dscto-x-vol-acumulado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-familia AS CHAR.
DEFINE VAR x-subfamilia AS CHAR.
DEFINE VAR x-lista-de-precio AS CHAR.
DEFINE VAR x-clasificacion-cliente AS CHAR.

DEFINE VAR x-codclie AS CHAR.
DEFINE VAR x-undvta AS CHAR.
DEFINE VAR x-factor AS INT INIT 1.
DEFINE VAR x-cond-vta AS CHAR INIT '404'.
DEFINE VAR x-cantidad AS DEC INIT 1.
DEFINE VAR x-nro-dec AS INT INIT 4.
DEFINE VAR x-prebas AS DEC INIT 0.
DEFINE VAR x-prevta AS DEC INIT 0.
DEFINE VAR f-dsctos AS DEC INIT 0.
DEFINE VAR y-dsctos AS DEC INIT 0.
DEFINE VAR z-dsctos AS DEC INIT 0.
DEFINE VAR x-tipdto AS CHAR INIT "".
DEFINE VAR x-item AS INT INIT 0.
DEFINE VAR x-flete-unitario AS DEC INIT 0.
DEFINE VAR x-tipo-pedido AS CHAR INIT "E".
DEFINE VAR x-moneda AS INT INIT 1.

DEFINE VAR x-sec AS INT INIT 0.
DEFINE VAR x-hdr AS LOG.

DEFINE VAR y-familia AS CHAR.
DEFINE VAR y-subfamilia AS CHAR.
DEFINE VAR x-codmat AS CHAR.

x-subfamilia = combo-box-subfamilia.
x-familia = combo-box-familia.
x-lista-de-precio = combo-box-listaprecios.
x-clasificacion-cliente = combo-box-clasificacioncliente.
x-codclie = IF(radio-set-tipocliente = 1) THEN "00000000100" ELSE "11111111111".

DEFINE BUFFER x-factabla FOR factabla.                        
                        
/* Acumulado x articulos */                       
FOR EACH factabla WHERE factabla.codcia = s-codcia AND
                            factabla.tabla = 'EDVXSALDOC' AND
                            factabla.codigo BEGINS x-lista-de-precio NO-LOCK.
    LOOP_DTL_EDVXSALDOD:
    FOR EACH x-factabla WHERE x-factabla.codcia = s-codcia AND 
                                x-factabla.tabla = 'EDVXSALDOD' AND 
                                x-factabla.codigo BEGINS factabla.codigo NO-LOCK.
        x-codmat = x-factabla.campo-c[1].
        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
                                    almmmatg.codmat = x-codmat NO-LOCK NO-ERROR.
        /* Debe pertenecer a la familia elegida en pantalla */
        IF NOT AVAILABLE almmmatg OR almmmatg.codfam <> x-familia THEN NEXT.
        /* Debe pertenecer a la SubFamilia elegida en pantalla */
        IF x-subfamilia <> "Todos" AND x-subfamilia <> almmmatg.subfam THEN NEXT.
        /* VOLUMEN */
        x-hdr = YES.
        REPEAT x-sec = 1 TO 10:
            IF factabla.Valor[x-sec] > 0 THEN DO:
                x-cantidad = factabla.Valor[x-sec].
                x-nro-dec = 4.
                x-prebas = 0.
                x-prevta = 0.
                f-dsctos = 0.
                y-dsctos = 0.
                x-undvta = "".
                x-tipdto = "".
                x-flete-unitario = 0.
                x-factor = 1.
                x-moneda = Almmmatg.MonVta.     /*1.*/
                x-tipo-pedido = 'E'.
                RUN {&Precio-de-Venta} (INPUT x-tipo-pedido, 
                                        INPUT x-lista-de-precio, 
                                        INPUT x-codclie,
                                        INPUT x-moneda, 
                                        INPUT-OUTPUT x-undvta, 
                                        OUTPUT x-factor, 
                                        INPUT x-codmat, 
                                        INPUT x-cond-vta,
                                        INPUT x-cantidad, 
                                        INPUT x-nro-dec, 
                                        OUTPUT x-prebas,
                                        OUTPUT x-prevta, 
                                        OUTPUT f-dsctos, 
                                        OUTPUT y-dsctos,
                                        OUTPUT z-dsctos,
                                        OUTPUT x-tipdto, 
                                        INPUT x-clasificacion-cliente, 
                                        OUTPUT x-flete-unitario, 
                                        "",
                                        INPUT NO).
                y-dsctos = factabla.Valor[x-sec + 10].
                IF x-hdr = YES THEN DO:
                    x-item = x-item + 1.
                    CREATE ttListaPreciosEventosVolumen.
                        ASSIGN ttListaPreciosEventosVolumen.tItem = "" /*x-item*/
                                ttListaPreciosEventosVolumen.tCodmat = x-codmat
                                ttListaPreciosEventosVolumen.tDesMat = factabla.nombre
                                ttListaPreciosEventosVolumen.tUndVta = x-undvta
                                ttListaPreciosEventosVolumen.tMarca = ""
                                ttListaPreciosEventosVolumen.tInner = 0
                                ttListaPreciosEventosVolumen.tMaster = 0
                                ttListaPreciosEventosVolumen.tPrecLista = x-prebas
                                ttListaPreciosEventosVolumen.tFlete = x-flete-unitario
                                ttListaPreciosEventosVolumen.tPrecFinal = x-prebas + ttListaPreciosEventosVolumen.tFlete
                    .
                    x-hdr = NO.
                END.

                /**/
                RUN _graba_detalle(INPUT x-sec, INPUT x-cantidad, INPUT y-dsctos, INPUT x-prevta).
                    
            END.
        END.
        /* Solo el primer codigo */
        LEAVE LOOP_DTL_EDVXSALDOD.
    END.
END.

/* Acumulado x Linea - SubLinea */
FOR EACH factabla WHERE factabla.codcia = s-codcia AND
                            factabla.tabla = 'DVXDSF' AND
                            factabla.codigo BEGINS x-lista-de-precio NO-LOCK.

    y-familia = ENTRY(2,factabla.codigo,"|").
    y-subfamilia = ENTRY(3,factabla.codigo,"|").

    /* Que sea de la misma familia que selecciono en los parametros */
    IF y-familia <> x-familia THEN NEXT.

    /* Que sea de la misma subfamilia que selecciono en los parametros */
    IF x-subfamilia <> "Todos" AND y-subfamilia <> x-subfamilia THEN NEXT.

    LOOP_SUBFAM:
    FOR EACH almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                almmmatg.codfam = y-familia AND
                                almmmatg.subfam = y-subfamilia NO-LOCK:
        /* El primero de la subfamilia pero que este registrado en la lista de precios */
        FIND FIRST VtaListaMay WHERE VtaListaMay.codcia = s-codcia AND 
                                        VtaListaMay.coddiv = x-lista-de-precio AND 
                                        VtaListaMay.codmat = almmmatg.codmat NO-LOCK NO-ERROR.
        IF AVAILABLE VtaListaMay THEN DO:
            FIND FIRST almtfam OF almmmatg NO-LOCK NO-ERROR.
            FIND FIRST almsfam OF almmmatg NO-LOCK NO-ERROR.

            x-codmat = almmmatg.codmat.

            /* VOLUMEN */
            x-hdr = YES.
            REPEAT x-sec = 1 TO 10:
                IF factabla.Valor[x-sec] > 0 THEN DO:

                    x-cantidad = factabla.Valor[x-sec].
                    x-nro-dec = 4.
                    x-prebas = 0.
                    x-prevta = 0.
                    f-dsctos = 0.
                    y-dsctos = 0.
                    x-undvta = "".
                    x-tipdto = "".
                    x-flete-unitario = 0.
                    x-factor = 1.
                    x-moneda = Almmmatg.MonVta.     /*1.*/
                    x-tipo-pedido.

                    RUN {&Precio-de-Venta} (INPUT x-tipo-pedido, 
                                            INPUT x-lista-de-precio, 
                                            INPUT x-codclie,
                                            INPUT x-moneda, 
                                            INPUT-OUTPUT x-undvta, 
                                            OUTPUT x-factor, 
                                            INPUT x-codmat, 
                                            INPUT x-cond-vta,
                                            INPUT x-cantidad, 
                                            INPUT x-nro-dec, 
                                            OUTPUT x-prebas,
                                            OUTPUT x-prevta, 
                                            OUTPUT f-dsctos, 
                                            OUTPUT y-dsctos,
                                            OUTPUT z-dsctos,
                                            OUTPUT x-tipdto, 
                                            INPUT x-clasificacion-cliente, 
                                            OUTPUT x-flete-unitario, 
                                            "",
                                            INPUT NO).
                    y-dsctos = factabla.Valor[x-sec + 10].

                    IF x-hdr = YES THEN DO:
                        x-item = x-item + 1.
                        CREATE ttListaPreciosEventosVolumen.
                            ASSIGN ttListaPreciosEventosVolumen.tItem = "" /*x-item*/
                                    ttListaPreciosEventosVolumen.tCodmat = x-codmat
                                    ttListaPreciosEventosVolumen.tDesMat = TRIM(almtfam.desfam) + "/" + TRIM(almsfam.dessub)
                                    ttListaPreciosEventosVolumen.tUndVta = x-undvta
                                    ttListaPreciosEventosVolumen.tMarca = ""
                                    ttListaPreciosEventosVolumen.tInner = 0
                                    ttListaPreciosEventosVolumen.tMaster = 0
                                    ttListaPreciosEventosVolumen.tPrecLista = x-prebas
                                    ttListaPreciosEventosVolumen.tFlete = x-flete-unitario
                                    ttListaPreciosEventosVolumen.tPrecFinal = x-prebas + ttListaPreciosEventosVolumen.tFlete
                        .
                        x-hdr = NO.
                    END.

                    /**/
                    RUN _graba_detalle(INPUT x-sec, INPUT x-cantidad, INPUT y-dsctos, INPUT x-prevta).

                END.
            END.
            /* Solo una de la subfamilia */
            LEAVE LOOP_SUBFAM.
        END.

    END.

END.


END PROCEDURE.

/* Grabar */
PROCEDURE _graba_detalle:
    DEFINE INPUT PARAMETER xsec AS INT.
    DEFINE INPUT PARAMETER xcantidad AS DEC.
    DEFINE INPUT PARAMETER xdsctos AS DEC.
    DEFINE INPUT PARAMETER xprevta AS DEC.

    IF xsec = 1 THEN ttListaPreciosEventosVolumen.tCant01 = xcantidad.
    IF xsec = 1 THEN ttListaPreciosEventosVolumen.tDscto01 = xdsctos.
    IF xsec = 1 THEN tPrecFin01 = if(xdsctos <> 0) THEN xprevta * ( 1 - xdsctos / 100) ELSE xprevta.
    IF xsec = 1 THEN tPFinal01 = tPrecFin01 + ttListaPreciosEventosVolumen.tFlete.
    IF xsec = 2 THEN tCant02 = xcantidad.
    IF xsec = 2 THEN tDscto02 = xdsctos.
    IF xsec = 2 THEN tPrecFin02 = if(xdsctos <> 0) THEN xprevta * ( 1 - xdsctos / 100) ELSE xprevta.
    IF xsec = 2 THEN tPFinal02 = tPrecFin02 + ttListaPreciosEventosVolumen.tFlete.
    IF xsec = 3 THEN tCant03 = xcantidad.
    IF xsec = 3 THEN tDscto03 = xdsctos.
    IF xsec = 3 THEN tPrecFin03 = if(xdsctos <> 0) THEN xprevta * ( 1 - xdsctos / 100) ELSE xprevta.
    IF xsec = 3 THEN tPFinal03 = tPrecFin03 + ttListaPreciosEventosVolumen.tFlete.
    IF xsec = 4 THEN tCant04 = xcantidad.
    IF xsec = 4 THEN tDscto04 = xdsctos.
    IF xsec = 4 THEN tPrecFin04 = if(xdsctos <> 0) THEN xprevta * ( 1 - xdsctos / 100) ELSE xprevta.
    IF xsec = 4 THEN tPFinal04 = tPrecFin04 + ttListaPreciosEventosVolumen.tFlete.
    IF xsec = 5 THEN tCant05 = xcantidad.
    IF xsec = 5 THEN tDscto05 = xdsctos.
    IF xsec = 5 THEN tPrecFin05 = if(xdsctos <> 0) THEN xprevta * ( 1 - xdsctos / 100) ELSE xprevta.
    IF xsec = 5 THEN tPFinal05 = tPrecFin05 + ttListaPreciosEventosVolumen.tFlete.
    IF xsec = 6 THEN tCant06 = xcantidad.
    IF xsec = 6 THEN tDscto06 = xdsctos.
    IF xsec = 6 THEN tPrecFin06 = if(xdsctos <> 0) THEN xprevta * ( 1 - xdsctos / 100) ELSE xprevta.
    IF xsec = 6 THEN tPFinal06 = tPrecFin06 + ttListaPreciosEventosVolumen.tFlete.
    IF xsec = 7 THEN tCant07 = xcantidad.
    IF xsec = 7 THEN tDscto07 = xdsctos.
    IF xsec = 7 THEN tPrecFin07 = if(xdsctos <> 0) THEN xprevta * ( 1 - xdsctos / 100) ELSE xprevta.
    IF xsec = 7 THEN tPFinal07 = tPrecFin07 + ttListaPreciosEventosVolumen.tFlete.
    IF xsec = 8 THEN tCant08 = xcantidad.
    IF xsec = 8 THEN tDscto08 = xdsctos.
    IF xsec = 8 THEN tPrecFin08 = if(xdsctos <> 0) THEN xprevta * ( 1 - xdsctos / 100) ELSE xprevta.
    IF xsec = 8 THEN tPFinal08 = tPrecFin08 + ttListaPreciosEventosVolumen.tFlete.
    IF xsec = 9 THEN tCant09 = xcantidad.
    IF xsec = 9 THEN tDscto09 = xdsctos.
    IF xsec = 9 THEN tPrecFin09 = if(xdsctos <> 0) THEN xprevta * ( 1 - xdsctos / 100) ELSE xprevta.
    IF xsec = 9 THEN tPFinal09 = tPrecFin09 + ttListaPreciosEventosVolumen.tFlete.
    IF xsec = 10 THEN tCant10 = xcantidad.
    IF xsec = 10 THEN tDscto10 = xdsctos.
    IF xsec = 10 THEN tPrecFin10 = if(xdsctos <> 0) THEN xprevta * ( 1 - xdsctos / 100) ELSE xprevta.
    IF xsec = 10 THEN tPFinal10 = tPrecFin10 + ttListaPreciosEventosVolumen.tFlete.

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
  DISPLAY COMBO-BOX-listaprecios COMBO-BOX-familia COMBO-BOX-subfamilia 
          COMBO-BOX-ClasificacionCliente RADIO-SET-tipocliente RADIO-SET-calculo 
          RADIO-SET-proveedor FILL-IN-proveedor FILL-IN-nomprovee FILL-IN-ruta 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 COMBO-BOX-listaprecios BUTTON-1 COMBO-BOX-familia 
         COMBO-BOX-subfamilia BUTTON-3 COMBO-BOX-ClasificacionCliente 
         RADIO-SET-tipocliente BUTTON-12 RADIO-SET-calculo RADIO-SET-proveedor 
         FILL-IN-proveedor BUTTON-2 BROWSE-2 BROWSE-3 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE encabezados-excel W-Win 
PROCEDURE encabezados-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pExcel AS CHAR.

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.

lFileXls = pExcel.              /* Nombre el archivo a abrir o crear, vacio solo para nuevos */
lNuevoFile = NO.                            /* Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

lMensajeAlTerminar = NO. /*  */
lCerrarAlTerminar = YES. /* Si permanece abierto el Excel luego de concluir el proceso */

DO WITH FRAME {&FRAME-NAME}:
    chWorkSheet:ROWS(1):SELECT.
    chWorkSheet:ROWS(1):INSERT.
    cRange = "B1".
    chWorkSheet:Range(cRange):VALUE = "Lista de Precios".
    chWorkSheet:Range("C1"):VALUE = combo-box-listaprecios + " " + 
        ENTRY(combo-box-listaprecios:LOOKUP(combo-box-listaprecios) * 2 - 1 , combo-box-listaprecios:LIST-ITEM-PAIRS,"|" ).

    chWorkSheet:ROWS(2):SELECT.
    chWorkSheet:ROWS(2):INSERT.
    cRange = "B2".
    chWorkSheet:Range(cRange):VALUE = "Familia".
    chWorkSheet:Range("C2"):VALUE = combo-box-familia + " " + 
        ENTRY(combo-box-familia:LOOKUP(combo-box-familia) * 2 - 1 , combo-box-familia:LIST-ITEM-PAIRS,"|" ).

    chWorkSheet:ROWS(3):SELECT.
    chWorkSheet:ROWS(3):INSERT.
    cRange = "B3".
    chWorkSheet:Range(cRange):VALUE = "SubFamilia".
    chWorkSheet:Range("C3"):VALUE = combo-box-subfamilia + " " + 
        ENTRY(combo-box-subfamilia:LOOKUP(combo-box-subfamilia) * 2 - 1 , combo-box-subfamilia:LIST-ITEM-PAIRS,"|" ).

    chWorkSheet:ROWS(4):SELECT.
    chWorkSheet:ROWS(4):INSERT.
    cRange = "B4".
    chWorkSheet:Range(cRange):VALUE = "Clasif.Cliente".
    chWorkSheet:Range("C4"):VALUE = combo-box-clasificacioncliente + " " + 
        ENTRY(combo-box-clasificacioncliente:LOOKUP(combo-box-clasificacioncliente) * 2 - 1 , combo-box-clasificacioncliente:LIST-ITEM-PAIRS,"|" ).

    chWorkSheet:ROWS(5):SELECT.
    chWorkSheet:ROWS(5):INSERT.
    cRange = "B5".
    chWorkSheet:Range(cRange):VALUE = "Tipo Cliente".
    chWorkSheet:Range("C5"):VALUE = entry(lookup(radio-set-tipocliente:screen-value, 
                                                 radio-set-tipocliente:radio-buttons) - 1,radio-set-tipocliente:radio-buttons).

    chWorkSheet:ROWS(6):SELECT.
    chWorkSheet:ROWS(6):INSERT.
    cRange = "B6".
    chWorkSheet:Range(cRange):VALUE = "Articulos".
    chWorkSheet:Range("C6"):VALUE = entry(lookup(radio-set-calculo:screen-value,                                      
                                                 radio-set-calculo:radio-buttons) - 1,radio-set-calculo:radio-buttons).

    chWorkSheet:ROWS(7):SELECT.
    chWorkSheet:ROWS(7):INSERT.
    cRange = "B7".
    chWorkSheet:Range(cRange):VALUE = "Proveedor".
    IF radio-set-proveedor = 2 THEN DO:
        chWorkSheet:Range("C7"):VALUE = fill-in-proveedor + " " + FILL-in-nomprovee.
    END.
    ELSE chWorkSheet:Range("C7"):VALUE = "Todos".
END.

chWorkbook:SAVE.

{lib\excel-close-file.i}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE envia-a-excel-pw W-Win 
PROCEDURE envia-a-excel-pw :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR hProc AS HANDLE NO-UNDO.

SESSION:SET-WAIT-STATE('GENRAL').

DEFINE VAR x-file-xls AS CHAR.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

DEFINE VAR x-lista-de-precio AS CHAR.
DEFINE VAR x-subfamilia AS CHAR.
DEFINE VAR x-familia AS CHAR.
DEFINE VAR x-clasificacion-cliente AS CHAR.
DEFINE VAR x-codclie AS CHAR.

x-lista-de-precio = combo-box-listaprecios.
x-subfamilia = combo-box-subfamilia.
x-familia = combo-box-familia.
x-clasificacion-cliente = combo-box-clasificacioncliente.
x-codclie = IF(radio-set-tipocliente = 1) THEN "00000000100" ELSE "11111111111".

x-file-xls = "LP-" + x-lista-de-precio + "_FM-" + x-familia + "_SFM-" + x-subfamilia + "_CLFCL-" + x-clasificacion-cliente + "_" + 
    IF(radio-set-tipocliente = 1) THEN "VIP" ELSE "REGULAR".

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

c-xls-file = FILL-IN-ruta + '\' + x-file-xls + '-Promocional.xlsx'.

run pi-crea-archivo-csv IN hProc (input  buffer ttListaPreciosPW:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer ttListaPreciosPW:handle,
                        input  c-csv-file,
                        output c-xls-file) .


DELETE PROCEDURE hProc.

/*  */
RUN encabezados-excel(INPUT c-xls-file).

SESSION:SET-WAIT-STATE('').

MESSAGE "Proceso Terminado".



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enviar-a-excel W-Win 
PROCEDURE enviar-a-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR hProc AS HANDLE NO-UNDO.

SESSION:SET-WAIT-STATE('GENRAL').

DEFINE VAR x-file-xls AS CHAR.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

DEFINE VAR x-lista-de-precio AS CHAR.
DEFINE VAR x-subfamilia AS CHAR.
DEFINE VAR x-familia AS CHAR.
DEFINE VAR x-clasificacion-cliente AS CHAR.
DEFINE VAR x-codclie AS CHAR.

x-lista-de-precio = combo-box-listaprecios.
x-subfamilia = combo-box-subfamilia.
x-familia = combo-box-familia.
x-clasificacion-cliente = combo-box-clasificacioncliente.
x-codclie = IF(radio-set-tipocliente = 1) THEN "00000000100" ELSE "11111111111".

x-file-xls = "LP-" + x-lista-de-precio + "_FM-" + x-familia + "_SFM-" + x-subfamilia + "_CLFCL-" + x-clasificacion-cliente + "_" + 
    IF(radio-set-tipocliente = 1) THEN "VIP" ELSE "REGULAR".

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

IF radio-set-calculo <> 1 THEN DO:

    IF radio-set-calculo = 2 THEN DO:
        c-xls-file = FILL-IN-ruta + '\' + x-file-xls + '-Volumen-Normal.xlsx'.
    END.
    ELSE c-xls-file = FILL-IN-ruta + '\' + x-file-xls + '-Volumen-acumulado.xlsx'.

    run pi-crea-archivo-csv IN hProc (input  buffer ttListaPreciosEventosVolumen:handle,
                            /*input  session:temp-directory + "file"*/ c-xls-file,
                            output c-csv-file) .

    run pi-crea-archivo-xls  IN hProc (input  buffer ttListaPreciosEventosVolumen:handle,
                            input  c-csv-file,
                            output c-xls-file) .
END.
ELSE DO:

    c-xls-file = FILL-IN-ruta + '\' + x-file-xls + '-Promocional.xlsx'.

    run pi-crea-archivo-csv IN hProc (input  buffer ttListaPreciosEventosPromocional:handle,
                            /*input  session:temp-directory + "file"*/ c-xls-file,
                            output c-csv-file) .

    run pi-crea-archivo-xls  IN hProc (input  buffer ttListaPreciosEventosPromocional:handle,
                            input  c-csv-file,
                            output c-xls-file) .
END.

DELETE PROCEDURE hProc.

/*  */

RUN encabezados-excel(INPUT c-xls-file).

SESSION:SET-WAIT-STATE('').

MESSAGE "Proceso Terminado".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir-formato-especial W-Win 
PROCEDURE imprimir-formato-especial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR x-llave AS CHAR.

    RUN bin/_prnctr.p.

    IF s-salida-impresion = 0 THEN RETURN.

    SESSION:SET-WAIT-STATE('GENERAL').    
    /* creo el temporal */ 
    REPEAT:
        s-task-no = RANDOM(1, 999999).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no
                        AND w-report.llave-c = s-user-id NO-LOCK)
            THEN DO:
            CREATE w-report.
            ASSIGN
                w-report.task-no = s-task-no.
            LEAVE.
        END.
    END.
    

    x-llave = STRING(TODAY,"99/99/9999") + "-" + STRING(TIME,"HH:MM:SS").
    /*  */
    FOR EACH ttListaPreciosPW :
        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no
            w-report.llave-c = x-llave
            w-report.campo-c[1] = ttListaPreciosPW.tItem
            w-report.campo-c[2] = ttListaPreciosPW.tCodmat
            w-report.campo-c[3] = ttListaPreciosPW.tDesMat
            w-report.campo-c[4] = ttListaPreciosPW.tUndVta
            w-report.campo-c[5] = ttListaPreciosPW.tMarca
            w-report.campo-c[6] = ttListaPreciosPW.tPrecLista
            w-report.campo-c[7] = ttListaPreciosPW.tPrecLin13
            w-report.campo-c[8] = ttListaPreciosPW.tDsctos1
            w-report.campo-c[9] = ttListaPreciosPW.tDsctos2
            w-report.campo-c[10] = ttListaPreciosPW.tDsctos3
            w-report.campo-c[11] = ttListaPreciosPW.tDsctos4
            w-report.campo-c[12] = ttListaPreciosPW.tDsctos5.
    END.

    SESSION:SET-WAIT-STATE('').

    /* */
    RB-INCLUDE-RECORDS = "O".
    
    RB-FILTER = " w-report.task-no = " + STRING(s-task-no) +  
                  " AND w-report.llave-c = '" + x-llave + "'".
    RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia.                            
        
    DEFINE VARIABLE cDatabaseName    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cHostName        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cNetworkProto    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cPortNumber      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cOtherParams     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cNewConnString   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDelimeter       AS CHARACTER NO-UNDO.
    
    GET-KEY-VALUE SECTION "RBParametros" KEY "cDatabaseName" VALUE cDatabaseName.
    GET-KEY-VALUE SECTION "RBParametros" KEY "cHostName" VALUE cHostName.
    GET-KEY-VALUE SECTION "RBParametros" KEY "cNetworkProto" VALUE cNetworkProto.
    GET-KEY-VALUE SECTION "RBParametros" KEY "cPortNumber" VALUE cPortNumber.
    GET-KEY-VALUE SECTION "RBParametros" KEY "cOtherParams" VALUE cOtherParams.
    
    ASSIGN cDelimeter = CHR(32).
    IF NOT (cDatabaseName = ? OR
       cHostName = ? OR
       cNetworkProto = ? OR
       cPortNumber = ?) THEN DO:
       ASSIGN
           cNewConnString =
           "-db" + cDelimeter + cDatabaseName + cDelimeter +
           "-H" + cDelimeter + cHostName + cDelimeter +
           "-N" + cDelimeter + cNetworkProto + cDelimeter +
           "-S" + cDelimeter + cPortNumber + cDelimeter.
       RB-DB-CONNECTION = cNewConnString.
    END.    
    
    ASSIGN
          RB-REPORT-NAME = "Lista de precios - PW"
          RB-BEGIN-PAGE = s-pagina-inicial
          RB-END-PAGE = s-pagina-final
          RB-PRINTER-NAME = s-printer-name
          RB-OUTPUT-FILE = s-print-file
          RB-NUMBER-COPIES = s-nro-copias.
      CASE s-salida-impresion:
          WHEN 1 THEN RB-PRINT-DESTINATION = "D".     /* Pantalla */
          WHEN 2 THEN RB-PRINT-DESTINATION = "".      /* Impresora */
          WHEN 3 THEN RB-PRINT-DESTINATION = "A".     /* Archivo */
      END CASE.

      /*
      FIND FIRST DI-RutaD OF DI-RutaC NO-LOCK NO-ERROR.
    
      IF AVAILABLE DI-RutaD THEN
      */

      RUN aderb/_prntrb2 (RB-REPORT-LIBRARY,
                          RB-REPORT-NAME,
                          RB-DB-CONNECTION,
                          RB-INCLUDE-RECORDS,
                          RB-FILTER,
                          RB-MEMO-FILE,
                          RB-PRINT-DESTINATION,
                          RB-PRINTER-NAME,
                          RB-PRINTER-PORT,
                          RB-OUTPUT-FILE,
                          RB-NUMBER-COPIES,
                          RB-BEGIN-PAGE,
                          RB-END-PAGE,
                          RB-TEST-PATTERN,
                          RB-WINDOW-TITLE,
                          RB-DISPLAY-ERRORS,
                          RB-DISPLAY-STATUS,
                          RB-NO-WAIT,
                          RB-OTHER-PARAMETERS,
                          "").

    /* */
    SESSION:SET-WAIT-STATE('GENERAL').

    /* Borar el temporal */
    DEF BUFFER B-w-report FOR w-report.
    DEFINE VAR lRowId AS ROWID.
    
    FOR EACH w-report WHERE w-report.task-no = s-task-no NO-LOCK:
        lRowId = ROWID(w-report).
        FIND FIRST b-w-report WHERE ROWID(b-w-report) = lRowid EXCLUSIVE NO-ERROR.
        IF AVAILABLE b-w-report THEN DO:
            DELETE b-w-report.            
        END.    
    END.
    RELEASE B-w-report.

    SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/*
    FIELDS  tItem       AS  CHAR    FORMAT 'x(10)'  COLUMN-LABEL "Item"
    FIELDS  tCodmat     AS  CHAR    FORMAT 'x(6)'   COLUMN-LABEL "Codigo"
    FIELDS  tDesMat     AS  CHAR    FORMAT 'x(80)'  COLUMN-LABEL "Descripcion"
    FIELDS  tUndVta     AS  CHAR    FORMAT 'x(5)'   COLUMN-LABEL "Und.Vta"
    FIELDS  tMarca      AS  CHAR    FORMAT 'x(50)'  COLUMN-LABEL "Marca"
    FIELDS  tPrecLista  AS  CHAR    FORMAT 'x(50)'  COLUMN-LABEL "Precio Lista"
    FIELDS  tPrecLin13  AS  CHAR    FORMAT 'x(50)'  COLUMN-LABEL "Precio Feria en Linea 13"
    FIELDS  tDsctos1    AS  CHAR    FORMAT 'x(50)'  COLUMN-LABEL "Descuentos por categoria de clientes o por volumen"
    FIELDS  tDsctos2    AS  CHAR    FORMAT 'x(50)'  COLUMN-LABEL "Descuentos por feria segun producto - 1.5% hasta 10%"
    FIELDS  tDsctos3    AS  CHAR    FORMAT 'x(50)'  COLUMN-LABEL "Precio feria, con despacho hasta 30/11 (Opcional) - 0.05%"
    FIELDS  tDsctos4    AS  CHAR    FORMAT 'x(50)'  COLUMN-LABEL "Descuentos Financiero (Opcional) - Hasta 6%"
    FIELDS  tDsctos5    AS  CHAR    FORMAT 'x(50)'  COLUMN-LABEL "Rebate/Contipunto (Opcional) - Hasta 2%"

*/

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
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-listaprecios:DELIMITER = "|".
      COMBO-BOX-familia:DELIMITER = "|".
      COMBO-BOX-subfamilia:DELIMITER = "|".
      COMBO-BOX-clasificacioncliente:DELIMITER = "|".
      COMBO-BOX-listaprecios:DELETE(1).
      COMBO-BOX-familia:DELETE(1).
      COMBO-BOX-subfamilia:DELETE(1).
      COMBO-BOX-clasificacioncliente:DELETE(1).
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      /* Lista de Precios */
      FOR EACH gn-divi WHERE gn-divi.codcia = 1 and 
          LOOKUP(gn-divi.campo-char[1], "A,L") > 0 and 
          gn-divi.canalventa = "FER"
          NO-LOCK:
          COMBO-BOX-listaprecios:ADD-LAST(gn-divi.desdiv + " (" + gn-divi.coddiv + ")", gn-divi.coddiv).
          IF TRUE <> (COMBO-BOX-listaprecios:SCREEN-VALUE > "") THEN COMBO-BOX-listaprecios:SCREEN-VALUE = gn-divi.coddiv.
      END.
      /* Familias */
      FOR EACH almtfami WHERE almtfami.codcia = s-codcia NO-LOCK:
          COMBO-BOX-familia:ADD-LAST(almtfami.codfam + ' - ' + AlmtFami.desfam, almtfami.codfam).
          IF TRUE <> (COMBO-BOX-familia:SCREEN-VALUE > "") THEN COMBO-BOX-familia:SCREEN-VALUE = almtfami.codfam.
      END.
      /* Clasificacion de Clientes */
      FOR EACH ClfClie NO-LOCK:
          COMBO-BOX-clasificacioncliente:ADD-LAST(ClfClie.descat, ClfClie.categoria).
          IF TRUE <> (COMBO-BOX-clasificacioncliente:SCREEN-VALUE > "") THEN COMBO-BOX-clasificacioncliente:SCREEN-VALUE = ClfClie.categoria.
      END.
    
      /*  SubFamilias */
      RUN cargar-subfamilia(INPUT COMBO-BOX-familia:SCREEN-VALUE).

      DISABLE fill-in-proveedor.
      BROWSE-3:VISIBLE = NO.
      BROWSE-2:X = 11.
      BROWSE-2:Y = 235.
      BROWSE-2:height = 14.73.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
PROCEDURE procesa-parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proceso-calculo W-Win 
PROCEDURE proceso-calculo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-familia AS CHAR.
DEFINE VAR x-subfamilia AS CHAR.
DEFINE VAR x-lista-de-precio AS CHAR.
DEFINE VAR x-clasificacion-cliente AS CHAR.

DEFINE VAR x-codclie AS CHAR.
DEFINE VAR x-undvta AS CHAR.
DEFINE VAR x-factor AS INT INIT 1.
DEFINE VAR x-cond-vta AS CHAR INIT '404'.
DEFINE VAR x-cantidad AS DEC INIT 1.
DEFINE VAR x-nro-dec AS INT INIT 4.
DEFINE VAR x-prebas AS DEC INIT 0.
DEFINE VAR x-prevta AS DEC INIT 0.
DEFINE VAR f-dsctos AS DEC INIT 0.
DEFINE VAR y-dsctos AS DEC INIT 0.
DEFINE VAR z-dsctos AS DEC INIT 0.
DEFINE VAR x-tipdto AS CHAR INIT "".
DEFINE VAR x-item AS INT INIT 0.
DEFINE VAR x-itemPW AS INT INIT 0.
DEFINE VAR x-flete-unitario AS DEC INIT 0.
DEFINE VAR x-moneda AS INT INIT 1.
DEFINE VAR x-tipo-pedido AS CHAR INIT "E".

DEFINE VAR x-sec AS INT INIT 0.
DEFINE VAR x-hdr AS LOG.

DEFINE VAR x-filer1 AS DEC INIT 0.
DEFINE VAR x-filer2 AS DEC INIT 0.
DEFINE VAR x-filer3 AS DEC INIT 0.

x-lista-de-precio = combo-box-listaprecios.
x-subfamilia = combo-box-subfamilia.
x-familia = combo-box-familia.
x-clasificacion-cliente = combo-box-clasificacioncliente.
x-codclie = IF(radio-set-tipocliente = 1) THEN "00000000100" ELSE "11111111111".

EMPTY TEMP-TABLE ttListaPreciosEventosPromocional.
EMPTY TEMP-TABLE ttListaPreciosEventosVolumen.

SESSION:SET-WAIT-STATE('GENERAL').

x-itemPW = 0.

x-despacho-anticipado = 0.05.
x-descuento-financiero = 0.06.
x-descuento-rebate = 0.02.

IF radio-set-calculo = 3 THEN DO:
    /* Dsctos x Volumen Acumulado */

    RUN dscto-x-vol-acumulado.

    x-item = 1.
    
    FOR EACH ttListaPreciosEventosVolumen :
        ASSIGN ttListaPreciosEventosVolumen.tItem = STRING(x-item,">>>,>>9").
        x-item = x-item + 1.
    END.

    {&OPEN-QUERY-BROWSE-3}

END.
ELSE DO:
    FOR EACH almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                almmmatg.codfam = x-familia AND 
                                (x-subfamilia = 'Todos' OR almmmatg.subfam = x-subfamilia) NO-LOCK:

        /* Un proveedor especifico */
        IF RADIO-SET-proveedor = 2 THEN DO:
            IF almmmatg.codpr1 <> fill-in-proveedor THEN NEXT.
        END.
        FIND FIRST gn-prov WHERE gn-prov.codcia = 0 AND
                                    gn-prov.codpro = almmmatg.codpr1 NO-LOCK NO-ERROR.

        FIND FIRST VtaListaMay WHERE VtaListaMay.codcia = s-codcia AND 
                                        VtaListaMay.coddiv = x-lista-de-precio AND 
                                        VtaListaMay.codmat = almmmatg.codmat NO-LOCK NO-ERROR.
        IF AVAILABLE VtaListaMay THEN DO:

            IF radio-set-calculo <> 1 THEN DO:
                /* VOLUMEN */
                x-hdr = YES.
                REPEAT x-sec = 1 TO 10:
                    IF vtalistamay.DtoVolR[x-sec] > 0 THEN DO:

                        x-cantidad = vtalistamay.DtoVolR[x-sec].
                        x-nro-dec = 4.
                        x-prebas = 0.
                        x-prevta = 0.
                        f-dsctos = 0.
                        y-dsctos = 0.
                        x-undvta = "".
                        x-tipdto = "".
                        x-flete-unitario = 0.
                        x-factor = 1.
                        x-moneda = Almmmatg.MonVta.      /*1.*/
                        x-tipo-pedido = 'E'.        /* pri/p-precio-mayor-credito */
                        RUN {&Precio-de-Venta} (INPUT x-tipo-pedido, 
                                                INPUT x-lista-de-precio, 
                                                INPUT x-codclie,
                                                INPUT x-moneda, 
                                                INPUT-OUTPUT x-undvta, 
                                                OUTPUT x-factor, 
                                                INPUT vtalistamay.codmat, 
                                                INPUT x-cond-vta,
                                                INPUT x-cantidad, 
                                                INPUT x-nro-dec, 
                                                OUTPUT x-prebas,
                                                OUTPUT x-prevta, 
                                                OUTPUT f-dsctos, 
                                                OUTPUT y-dsctos,
                                                OUTPUT z-dsctos,
                                                OUTPUT x-tipdto, 
                                                INPUT x-clasificacion-cliente, 
                                                OUTPUT x-flete-unitario, 
                                                "",
                                                INPUT NO).

                        IF X-TIPDTO = "VOL" THEN DO:
                            IF x-hdr = YES THEN DO:
                                x-item = x-item + 1.
                                CREATE ttListaPreciosEventosVolumen.
                                    ASSIGN ttListaPreciosEventosVolumen.tItem = "" /*x-item*/
                                            ttListaPreciosEventosVolumen.tCodmat = almmmatg.codmat
                                            ttListaPreciosEventosVolumen.tDesMat = almmmatg.desmat
                                            ttListaPreciosEventosVolumen.tUndVta = x-undvta
                                            ttListaPreciosEventosVolumen.tMarca = almmmatg.desmar   
                                            ttListaPreciosEventosVolumen.tInner = almmmatg.stkrep
                                            ttListaPreciosEventosVolumen.tMaster = almmmatg.canemp
                                            ttListaPreciosEventosVolumen.tPrecLista = x-prebas
                                            ttListaPreciosEventosVolumen.tFlete = x-flete-unitario
                                            ttListaPreciosEventosVolumen.tPrecFinal = x-prebas + ttListaPreciosEventosVolumen.tFlete
                                            ttListaPreciosEventosVolumen.tcodpro = IF(AVAILABLE gn-prov) THEN gn-prov.codpro ELSE ""
                                            ttListaPreciosEventosVolumen.tnompro = IF(AVAILABLE gn-prov) THEN gn-prov.nompro ELSE ""
                                .
                                x-hdr = NO.
                            END.

                            x-itemPW = x-itemPW + 1.

                            x-prevta = if(y-dsctos <> 0) THEN x-prevta * ( 1 - y-dsctos / 100) ELSE x-prevta.
                
                            x-filer1 = x-prevta * ( 1 - (x-despacho-anticipado / 100) ).
                            x-filer2 = x-filer1 * ( 1 - (x-descuento-financiero / 100) ).
                            x-filer3 = x-filer2 * ( 1 - (x-descuento-rebate / 100) ).
                
                            CREATE ttListaPreciosPW.
                                ASSIGN ttListaPreciosPW.tItem = String(x-itemPW)
                                        ttListaPreciosPW.tCodMat = almmmatg.codmat
                                        ttListaPreciosPW.tDesMat = almmmatg.desmat
                                        ttListaPreciosPW.tUndVta = x-undvta
                                        ttListaPreciosPW.tMarca = almmmatg.desmar
                                        ttListaPreciosPW.tPrecLista = STRING(x-prebas,"->,>>>,>>9.9999")
                                        ttListaPreciosPW.tPrecLin13 = IF (almmmatg.codfam = '013') THEN STRING(x-prevta,"->,>>>,>>9.9999") ELSE ' '
                                        ttListaPreciosPW.tDsctos1 = STRING(Y-DSCTOS ,"->,>>9.9999") + " %"    /* f-dsctos */
                                        ttListaPreciosPW.tDsctos2 = ""  /*STRING(Y-DSCTOS,"->,>>9.9999") + " %"*/
                                        ttListaPreciosPW.tDsctos3 = STRING(x-filer1, "->,>>9.9999")
                                        ttListaPreciosPW.tDsctos4 = STRING(x-filer2, "->,>>9.9999")
                                        ttListaPreciosPW.tDsctos5 = STRING(x-filer3, "->,>>9.9999").
                                                                    

                            /* x-prevta */

                            IF x-sec = 1 THEN tCant01 = x-cantidad.
                            IF x-sec = 1 THEN tDscto01 = y-dsctos.
                            IF x-sec = 1 THEN tPrecFin01 = if(y-dsctos <> 0) THEN x-prebas * ( 1 - y-dsctos / 100) ELSE x-prevta.
                            IF x-sec = 1 THEN tPFinal01 = tPrecFin01 + ttListaPreciosEventosVolumen.tFlete.
                            IF x-sec = 2 THEN tCant02 = x-cantidad.
                            IF x-sec = 2 THEN tDscto02 = y-dsctos.
                            IF x-sec = 2 THEN tPrecFin02 = if(y-dsctos <> 0) THEN x-prebas * ( 1 - y-dsctos / 100) ELSE x-prevta.
                            IF x-sec = 2 THEN tPFinal02 = tPrecFin02 + ttListaPreciosEventosVolumen.tFlete.
                            IF x-sec = 3 THEN tCant03 = x-cantidad.
                            IF x-sec = 3 THEN tDscto03 = y-dsctos.
                            IF x-sec = 3 THEN tPrecFin03 = if(y-dsctos <> 0) THEN x-prebas * ( 1 - y-dsctos / 100) ELSE x-prevta.
                            IF x-sec = 3 THEN tPFinal03 = tPrecFin03 + ttListaPreciosEventosVolumen.tFlete.
                            IF x-sec = 4 THEN tCant04 = x-cantidad.
                            IF x-sec = 4 THEN tDscto04 = y-dsctos.
                            IF x-sec = 4 THEN tPrecFin04 = if(y-dsctos <> 0) THEN x-prebas * ( 1 - y-dsctos / 100) ELSE x-prevta.
                            IF x-sec = 4 THEN tPFinal04 = tPrecFin04 + ttListaPreciosEventosVolumen.tFlete.
                            IF x-sec = 5 THEN tCant05 = x-cantidad.
                            IF x-sec = 5 THEN tDscto05 = y-dsctos.
                            IF x-sec = 5 THEN tPrecFin05 = if(y-dsctos <> 0) THEN x-prebas * ( 1 - y-dsctos / 100) ELSE x-prevta.
                            IF x-sec = 5 THEN tPFinal05 = tPrecFin05 + ttListaPreciosEventosVolumen.tFlete.
                            IF x-sec = 6 THEN tCant06 = x-cantidad.
                            IF x-sec = 6 THEN tDscto06 = y-dsctos.
                            IF x-sec = 6 THEN tPrecFin06 = if(y-dsctos <> 0) THEN x-prebas * ( 1 - y-dsctos / 100) ELSE x-prevta.
                            IF x-sec = 6 THEN tPFinal06 = tPrecFin06 + ttListaPreciosEventosVolumen.tFlete.
                            IF x-sec = 7 THEN tCant07 = x-cantidad.
                            IF x-sec = 7 THEN tDscto07 = y-dsctos.
                            IF x-sec = 7 THEN tPrecFin07 = if(y-dsctos <> 0) THEN x-prebas * ( 1 - y-dsctos / 100) ELSE x-prevta.
                            IF x-sec = 7 THEN tPFinal07 = tPrecFin07 + ttListaPreciosEventosVolumen.tFlete.
                            IF x-sec = 8 THEN tCant08 = x-cantidad.
                            IF x-sec = 8 THEN tDscto08 = y-dsctos.
                            IF x-sec = 8 THEN tPrecFin08 = if(y-dsctos <> 0) THEN x-prebas * ( 1 - y-dsctos / 100) ELSE x-prevta.
                            IF x-sec = 8 THEN tPFinal08 = tPrecFin08 + ttListaPreciosEventosVolumen.tFlete.
                            IF x-sec = 9 THEN tCant09 = x-cantidad.
                            IF x-sec = 9 THEN tDscto09 = y-dsctos.
                            IF x-sec = 9 THEN tPrecFin09 = if(y-dsctos <> 0) THEN x-prebas * ( 1 - y-dsctos / 100) ELSE x-prevta.
                            IF x-sec = 9 THEN tPFinal09 = tPrecFin09 + ttListaPreciosEventosVolumen.tFlete.
                            IF x-sec = 10 THEN tCant10 = x-cantidad.
                            IF x-sec = 10 THEN tDscto10 = y-dsctos.
                            IF x-sec = 10 THEN tPrecFin10 = if(y-dsctos <> 0) THEN x-prebas * ( 1 - y-dsctos / 100) ELSE x-prevta.
                            IF x-sec = 10 THEN tPFinal10 = tPrecFin10 + ttListaPreciosEventosVolumen.tFlete.
                        END.
                    END.
                END.
            END.
            ELSE DO:
                x-cantidad = 1.
                x-nro-dec = 4.
                x-prebas = 0.
                x-prevta = 0.
                f-dsctos = 0.
                y-dsctos = 0.
                x-undvta = "".
                x-tipdto = "".
                x-factor = 1.
                x-moneda = Almmmatg.MonVta.     /*1.*/
                x-tipo-pedido = 'E'.
                RUN {&Precio-de-Venta} (INPUT x-tipo-pedido, 
                                        INPUT x-lista-de-precio, 
                                        INPUT x-codclie,
                                        INPUT x-moneda, 
                                        INPUT-OUTPUT x-undvta, 
                                        OUTPUT x-factor, 
                                        INPUT vtalistamay.codmat, 
                                        INPUT x-cond-vta,
                                        INPUT x-cantidad, 
                                        INPUT x-nro-dec, 
                                        OUTPUT x-prebas,
                                        OUTPUT x-prevta, 
                                        OUTPUT f-dsctos, 
                                        OUTPUT y-dsctos,
                                        OUTPUT z-dsctos,
                                        OUTPUT x-tipdto, 
                                        INPUT x-clasificacion-cliente, 
                                        OUTPUT x-flete-unitario, 
                                        "",
                                        INPUT NO).

                IF X-TIPDTO <> "VOL" THEN DO:
                    x-item = x-item + 1.

                    CREATE ttListaPreciosEventosPromocional.
                        ASSIGN ttListaPreciosEventosPromocional.tItem = "" /*x-item*/
                                ttListaPreciosEventosPromocional.tCodmat = almmmatg.codmat
                                ttListaPreciosEventosPromocional.tDesMat = almmmatg.desmat
                                ttListaPreciosEventosPromocional.tUndVta = x-undvta
                                ttListaPreciosEventosPromocional.tMarca = almmmatg.desmar   
                                ttListaPreciosEventosPromocional.tInner = almmmatg.stkrep
                                ttListaPreciosEventosPromocional.tMaster = almmmatg.canemp
                                ttListaPreciosEventosPromocional.tPrecLista = x-prebas
                                ttListaPreciosEventosPromocional.tPrecCateg = x-prevta
                                ttListaPreciosEventosPromocional.tDsctoProm = y-dsctos
                                ttListaPreciosEventosPromocional.tPrecioUni = if(y-dsctos <> 0) THEN Round(x-prevta * ( 1 - y-dsctos / 100), x-nro-dec) ELSE x-prevta
                                ttListaPreciosEventosPromocional.tFlete = x-flete-unitario
                                ttListaPreciosEventosPromocional.tPrecFinal = tPrecioUni + ttListaPreciosEventosPromocional.tFlete
                                tTipoDscto = X-TIPDTO
                                ttListaPreciosEventosPromocional.tcodpro = IF(AVAILABLE gn-prov) THEN gn-prov.codpro ELSE ""
                                ttListaPreciosEventosPromocional.tnompro = IF(AVAILABLE gn-prov) THEN gn-prov.nompro ELSE ""
                            . 

                x-itemPW = x-itemPW + 1.
    
                x-filer1 = x-prevta * ( 1 - (x-despacho-anticipado / 100) ).
                x-filer2 = x-filer1 * ( 1 - (x-descuento-financiero / 100) ).
                x-filer3 = x-filer2 * ( 1 - (x-descuento-rebate / 100) ).
    
                CREATE ttListaPreciosPW.
                    ASSIGN ttListaPreciosPW.tItem = String(x-itemPW)
                            ttListaPreciosPW.tCodMat = almmmatg.codmat
                            ttListaPreciosPW.tDesMat = almmmatg.desmat
                            ttListaPreciosPW.tUndVta = x-undvta
                            ttListaPreciosPW.tMarca = almmmatg.desmar
                            ttListaPreciosPW.tPrecLista = STRING(x-prebas,"->,>>>,>>9.9999")
                            ttListaPreciosPW.tPrecLin13 = IF (almmmatg.codfam = '013') THEN STRING(x-prevta,"->,>>>,>>9.9999") ELSE ' '
                            ttListaPreciosPW.tDsctos1 = STRING(f-dsctos,"->,>>9.9999") + " %"
                            ttListaPreciosPW.tDsctos2 = STRING(Y-DSCTOS,"->,>>9.9999") + " %"
                            ttListaPreciosPW.tDsctos3 = STRING(x-filer1, "->,>>9.9999")
                            ttListaPreciosPW.tDsctos4 = STRING(x-filer2, "->,>>9.9999")
                            ttListaPreciosPW.tDsctos5 = STRING(x-filer3, "->,>>9.9999")
                            .
                END.
            END.

        END.
    END.
    /**/
    x-item = 1.
    FOR EACH ttListaPreciosEventosPromocional :
        ASSIGN ttListaPreciosEventosPromocional.tItem = STRING(x-item,">>>,>>9").
        x-item = x-item + 1.
    END.        

END.
{&OPEN-QUERY-BROWSE-2}
{&OPEN-QUERY-BROWSE-3}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
PROCEDURE recoge-parametros :
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
  {src/adm/template/snd-list.i "ttListaPreciosEventosVolumen"}
  {src/adm/template/snd-list.i "ttListaPreciosEventosPromocional"}

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

