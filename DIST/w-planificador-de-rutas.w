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
DEFINE TEMP-TABLE TPIR_LISTA NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE TRESUMEN_PTOS NO-UNDO LIKE w-report.



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
DEF VAR x-coddiv AS CHAR INIT '00000' NO-UNDO.    /* forzamos la division */

DEFINE VAR x-solo-pruebas AS LOG INIT YES.

DEFINE BUFFER b-di-rutaC FOR di-rutaC.
DEFINE BUFFER b-di-rutaD FOR di-rutaD.
DEFINE BUFFER x-TORDENES FOR TORDENES.

IF NOT CAN-FIND(FIRST Faccorre WHERE FacCorre.CodCia = s-codcia 
                AND FacCorre.CodDiv = x-coddiv 
                AND FacCorre.CodDoc = s-coddoc 
                AND FacCorre.FlgEst = YES
                NO-LOCK) THEN DO:
    MESSAGE "NO definido el correlativo para el documento " +  s-coddoc 
            "para la division " + x-coddiv SKIP
        'Proceso Abortado' VIEW-AS ALERT-BOX INFORMATION.
    RETURN ERROR.
END.

DEFINE TEMP-TABLE tt-puntos-entrega
    FIELD   tnropir AS CHAR
    FIELD   tcodcli AS CHAR
    FIELD   tsede AS CHAR
    INDEX idx01 tnropir tcodcli tsede.

DEFINE TEMP-TABLE tt-clientes
    FIELD   tcodcli AS CHAR
    INDEX idx01 tcodcli .



/**/
x-solo-pruebas = YES.
FIND FIRST factabla WHERE factabla.codcia = s-codcia AND
                            factabla.tabla = "INTERRUPTOR" AND
                            factabla.codigo = "PLANIFICADOR DE RUTAS" NO-LOCK NO-ERROR.
IF AVAILABLE factabla THEN DO:
    x-solo-pruebas = factabla.campo-l[1].
END.

IF x-solo-pruebas = YES THEN MESSAGE "Solo Pruebas".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-12

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES TRESUMEN_PTOS TORDENES PTOSDESPACHO ~
TPIR_LISTA TORDENES_PIR

/* Definitions for BROWSE BROWSE-12                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-12 TRESUMEN_PTOS.Campo-C[1] ~
TRESUMEN_PTOS.Campo-I[1] TRESUMEN_PTOS.Campo-I[2] TRESUMEN_PTOS.Campo-I[3] ~
TRESUMEN_PTOS.Campo-F[1] TRESUMEN_PTOS.Campo-F[2] TRESUMEN_PTOS.Campo-F[3] ~
TRESUMEN_PTOS.Campo-I[4] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-12 
&Scoped-define QUERY-STRING-BROWSE-12 FOR EACH TRESUMEN_PTOS NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-12 OPEN QUERY BROWSE-12 FOR EACH TRESUMEN_PTOS NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-12 TRESUMEN_PTOS
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-12 TRESUMEN_PTOS


/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 TORDENES.Campo-C[5] ~
TORDENES.Campo-C[11] TORDENES.Campo-C[17] TORDENES.Campo-C[12] ~
TORDENES.Campo-C[10] TORDENES.Campo-C[16] TORDENES.Campo-C[13] ~
TORDENES.Campo-C[4] TORDENES.Campo-D[1] TORDENES.Campo-D[2] ~
TORDENES.Campo-C[1] TORDENES.Campo-C[2] TORDENES.Campo-C[14] ~
TORDENES.Campo-C[7] TORDENES.Campo-C[8] TORDENES.Campo-F[1] ~
TORDENES.Campo-I[1] TORDENES.Campo-F[2] TORDENES.Campo-F[3] ~
TORDENES.Campo-I[2] TORDENES.Campo-C[9] TORDENES.Campo-C[15] ~
TORDENES.Campo-C[29] 
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
TORDENES.Campo-C[11] TORDENES.Campo-C[17] TORDENES.Campo-C[12] ~
TORDENES.Campo-C[10] TORDENES.Campo-C[16] TORDENES.Campo-C[13] ~
TORDENES.Campo-C[4] TORDENES.Campo-D[1] TORDENES.Campo-D[2] ~
TORDENES.Campo-C[1] TORDENES.Campo-C[2] TORDENES.Campo-C[14] ~
TORDENES.Campo-C[7] TORDENES.Campo-C[8] TORDENES.Campo-F[1] ~
TORDENES.Campo-I[1] TORDENES.Campo-F[2] TORDENES.Campo-F[3] ~
TORDENES.Campo-I[2] TORDENES.Campo-C[9] TORDENES.Campo-C[15] 
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
&Scoped-define FIELDS-IN-QUERY-BROWSE-7 TPIR_LISTA.Campo-C[1] ~
TPIR_LISTA.Campo-I[1] TPIR_LISTA.Campo-I[2] TPIR_LISTA.Campo-F[1] ~
TPIR_LISTA.Campo-F[2] TPIR_LISTA.Campo-F[3] TPIR_LISTA.Campo-I[3] ~
TPIR_LISTA.Campo-I[4] TPIR_LISTA.Campo-C[2] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-7 
&Scoped-define QUERY-STRING-BROWSE-7 FOR EACH TPIR_LISTA ~
      WHERE TPIR_LISTA.campo-c[30] = '' NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-7 OPEN QUERY BROWSE-7 FOR EACH TPIR_LISTA ~
      WHERE TPIR_LISTA.campo-c[30] = '' NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-7 TPIR_LISTA
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-7 TPIR_LISTA


/* Definitions for BROWSE BROWSE-9                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-9 TORDENES_PIR.Campo-C[5] ~
TORDENES_PIR.Campo-C[11] TORDENES_PIR.Campo-C[17] TORDENES_PIR.Campo-C[12] ~
TORDENES_PIR.Campo-C[10] TORDENES_PIR.Campo-C[16] TORDENES_PIR.Campo-C[13] ~
TORDENES_PIR.Campo-C[4] TORDENES_PIR.Campo-D[1] TORDENES_PIR.Campo-D[2] ~
TORDENES_PIR.Campo-C[1] TORDENES_PIR.Campo-C[2] TORDENES_PIR.Campo-C[14] ~
TORDENES_PIR.Campo-C[8] TORDENES_PIR.Campo-F[1] TORDENES_PIR.Campo-I[1] ~
TORDENES_PIR.Campo-F[2] TORDENES_PIR.Campo-F[3] TORDENES_PIR.Campo-I[2] ~
TORDENES_PIR.Campo-C[9] TORDENES_PIR.Campo-C[15] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-9 
&Scoped-define QUERY-STRING-BROWSE-9 FOR EACH TORDENES_PIR ~
      WHERE TORDENES_PIR.campo-C[30] = "X" NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-9 OPEN QUERY BROWSE-9 FOR EACH TORDENES_PIR ~
      WHERE TORDENES_PIR.campo-C[30] = "X" NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-9 TORDENES_PIR
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-9 TORDENES_PIR


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-12}~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-3}~
    ~{&OPEN-QUERY-BROWSE-5}~
    ~{&OPEN-QUERY-BROWSE-7}~
    ~{&OPEN-QUERY-BROWSE-9}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-7 FILL-IN-desde FILL-IN-hasta ~
BUTTON-1 BROWSE-5 BUTTON-phr BUTTON-buscar RADIO-SET-campos ~
BUTTON-fraccionar FILL-IN-buscar BROWSE-9 BROWSE-2 RADIO-SET-1 ~
BUTTON-cancelar BUTTON-nuevo BROWSE-3 BUTTON-2 BUTTON-3 BROWSE-12 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-desde FILL-IN-hasta ~
RADIO-SET-campos FILL-IN-buscar RADIO-SET-1 FILL-IN-items-4 FILL-IN-peso-4 ~
FILL-IN-volumen-4 FILL-IN-bultos-4 FILL-IN-importe-4 FILL-IN-3 ~
FILL-IN-items-2 FILL-IN-peso-2 FILL-IN-volumen-2 FILL-IN-bultos-2 ~
FILL-IN-importe-2 FILL-IN-items FILL-IN-items-3 FILL-IN-peso FILL-IN-peso-3 ~
FILL-IN-volumen-3 FILL-IN-bultos FILL-IN-bultos-3 FILL-IN-importe-3 ~
FILL-IN-importe FILL-IN-volumen 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-BROWSE-2 
       MENU-ITEM m_Generar_TXT  LABEL "Generar TXT"   .

DEFINE MENU POPUP-MENU-BROWSE-3 
       MENU-ITEM m_Generar_TXT2 LABEL "Generar TXT"   .

DEFINE MENU POPUP-MENU-BROWSE-9 
       MENU-ITEM m_Generar_TXT3 LABEL "Generar TXT"   .


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

DEFINE BUTTON BUTTON-buscar 
     LABEL "Buscar" 
     SIZE 9 BY 1.12.

DEFINE BUTTON BUTTON-cancelar 
     LABEL "Cancelar" 
     SIZE 11.57 BY .77
     BGCOLOR 12 .

DEFINE BUTTON BUTTON-fraccionar 
     LABEL "Fraccionar" 
     SIZE 12 BY 1.12.

DEFINE BUTTON BUTTON-nuevo 
     LABEL "Nuevo PIR" 
     SIZE 12 BY .77
     BGCOLOR 2 .

DEFINE BUTTON BUTTON-phr 
     LABEL "Genera PHR" 
     SIZE 12 BY 1.12.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(100)":U INITIAL "Mensaje...." 
      VIEW-AS TEXT 
     SIZE 55 BY .62
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-bultos AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Bultos" 
      VIEW-AS TEXT 
     SIZE 11 BY .62
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-bultos-2 AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Bultos" 
      VIEW-AS TEXT 
     SIZE 11 BY .62
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-bultos-3 AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Bultos" 
      VIEW-AS TEXT 
     SIZE 11 BY .62
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-bultos-4 AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Bultos" 
      VIEW-AS TEXT 
     SIZE 11 BY .62
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-buscar AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de entrega DESDE" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "HASTA" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-importe AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "Importe" 
      VIEW-AS TEXT 
     SIZE 11 BY .62
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-importe-2 AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "Importe" 
      VIEW-AS TEXT 
     SIZE 11 BY .62
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-importe-3 AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "Importe" 
      VIEW-AS TEXT 
     SIZE 11 BY .62
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-importe-4 AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "Importe" 
      VIEW-AS TEXT 
     SIZE 11 BY .62
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-items AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Items" 
      VIEW-AS TEXT 
     SIZE 11 BY .62
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-items-2 AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Items" 
      VIEW-AS TEXT 
     SIZE 11 BY .62
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-items-3 AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Items" 
      VIEW-AS TEXT 
     SIZE 11 BY .62
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-items-4 AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Items" 
      VIEW-AS TEXT 
     SIZE 11 BY .62
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-peso AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "Peso" 
      VIEW-AS TEXT 
     SIZE 11 BY .62
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-peso-2 AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "Peso" 
      VIEW-AS TEXT 
     SIZE 11 BY .62
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-peso-3 AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "Peso" 
      VIEW-AS TEXT 
     SIZE 11 BY .62
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-peso-4 AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "Peso" 
      VIEW-AS TEXT 
     SIZE 11 BY .62
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-volumen AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "Volumen" 
      VIEW-AS TEXT 
     SIZE 11 BY .62
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-volumen-2 AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "Volumen" 
      VIEW-AS TEXT 
     SIZE 11 BY .62
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-volumen-3 AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "Volumen" 
      VIEW-AS TEXT 
     SIZE 11 BY .62
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-volumen-4 AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "Volumen" 
      VIEW-AS TEXT 
     SIZE 11 BY .62
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Ordenar", 1,
"Mover", 2
     SIZE 9 BY 1.35 NO-UNDO.

DEFINE VARIABLE RADIO-SET-campos AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Cliente", 1,
"Orden", 2,
"Referencia", 3
     SIZE 31 BY .96 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-12 FOR 
      TRESUMEN_PTOS SCROLLING.

DEFINE QUERY BROWSE-2 FOR 
      TORDENES SCROLLING.

DEFINE QUERY BROWSE-3 FOR 
      TORDENES SCROLLING.

DEFINE QUERY BROWSE-5 FOR 
      PTOSDESPACHO SCROLLING.

DEFINE QUERY BROWSE-7 FOR 
      TPIR_LISTA SCROLLING.

DEFINE QUERY BROWSE-9 FOR 
      TORDENES_PIR SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-12 W-Win _STRUCTURED
  QUERY BROWSE-12 NO-LOCK DISPLAY
      TRESUMEN_PTOS.Campo-C[1] COLUMN-LABEL "Punto!Despacho" FORMAT "X(50)":U
            WIDTH 32.14
      TRESUMEN_PTOS.Campo-I[1] COLUMN-LABEL "Items" FORMAT ">>>,>>9":U
      TRESUMEN_PTOS.Campo-I[2] COLUMN-LABEL "Bultos" FORMAT ">>>,>>9":U
            WIDTH 5.43
      TRESUMEN_PTOS.Campo-I[3] COLUMN-LABEL "Clientes" FORMAT ">>>,>>9":U
            WIDTH 5.43
      TRESUMEN_PTOS.Campo-F[1] COLUMN-LABEL "Peso" FORMAT ">,>>>,>>9.99":U
      TRESUMEN_PTOS.Campo-F[2] COLUMN-LABEL "Volumen" FORMAT ">,>>>,>>9.99":U
            WIDTH 8.57
      TRESUMEN_PTOS.Campo-F[3] COLUMN-LABEL "Importe" FORMAT ">>,>>>,>>9.99":U
            WIDTH 9.43
      TRESUMEN_PTOS.Campo-I[4] COLUMN-LABEL "Ptos!entrega" FORMAT ">>>,>>9":U
            WIDTH 8.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 93.72 BY 4.42
         FONT 4
         TITLE "Punto de Despacho" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      TORDENES.Campo-C[5] COLUMN-LABEL "Division!Despacho" FORMAT "X(50)":U
            WIDTH 25.72
      TORDENES.Campo-C[11] COLUMN-LABEL "Embalado!Especial" FORMAT "X(8)":U
      TORDENES.Campo-C[17] COLUMN-LABEL "Cliente!Recoje" FORMAT "X(5)":U
      TORDENES.Campo-C[12] COLUMN-LABEL "Provincia" FORMAT "X(40)":U
            WIDTH 23.86
      TORDENES.Campo-C[10] COLUMN-LABEL "Distrito de entrega" FORMAT "X(40)":U
            WIDTH 34.29
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
      TORDENES.Campo-C[9] COLUMN-LABEL "Direccion de entrega" FORMAT "X(100)":U
            WIDTH 62.43
      TORDENES.Campo-C[15] COLUMN-LABEL "Glosa" FORMAT "X(50)":U
            WIDTH 47
      TORDENES.Campo-C[29] COLUMN-LABEL "PIR" FORMAT "X(11)":U
            WIDTH 10.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 85 BY 18.96
         FONT 4
         TITLE "Ordenes disponibles para crear PIRs" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      TORDENES.Campo-C[5] COLUMN-LABEL "Division!Despacho" FORMAT "X(50)":U
            WIDTH 25.72
      TORDENES.Campo-C[11] COLUMN-LABEL "Embalado!Especial" FORMAT "X(8)":U
      TORDENES.Campo-C[17] COLUMN-LABEL "Cliente!Recoje" FORMAT "X(5)":U
            WIDTH 5
      TORDENES.Campo-C[12] COLUMN-LABEL "Provincia" FORMAT "X(40)":U
            WIDTH 24
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
            WIDTH 44.29
      TORDENES.Campo-F[1] COLUMN-LABEL "Monto" FORMAT "->>,>>>,>>9.99":U
      TORDENES.Campo-I[1] COLUMN-LABEL "Items" FORMAT ">>>,>>9":U
      TORDENES.Campo-F[2] COLUMN-LABEL "Peso" FORMAT ">>>,>>9.99":U
      TORDENES.Campo-F[3] COLUMN-LABEL "Volumen" FORMAT "->,>>>,>>9.99":U
      TORDENES.Campo-I[2] COLUMN-LABEL "Bultos" FORMAT ">,>>>,>>9":U
      TORDENES.Campo-C[9] COLUMN-LABEL "Direccion de entrega" FORMAT "X(100)":U
            WIDTH 52.86
      TORDENES.Campo-C[15] COLUMN-LABEL "Glosa" FORMAT "X(50)":U
            WIDTH 49.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 94.14 BY 10.5
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
      TPIR_LISTA.Campo-C[1] COLUMN-LABEL "Nro.!PIR" FORMAT "X(11)":U
            WIDTH 9.29
      TPIR_LISTA.Campo-I[1] COLUMN-LABEL "Cant.!Clientes" FORMAT ">>>,>>9":U
            WIDTH 5.43
      TPIR_LISTA.Campo-I[2] COLUMN-LABEL "Puntos!entrega" FORMAT ">>>,>>9":U
            WIDTH 5.43
      TPIR_LISTA.Campo-F[1] COLUMN-LABEL "Monto!Total" FORMAT ">,>>>,>>9.99":U
      TPIR_LISTA.Campo-F[2] COLUMN-LABEL "Peso!Total" FORMAT ">,>>>,>>9.99":U
      TPIR_LISTA.Campo-F[3] COLUMN-LABEL "Volumen!Total" FORMAT "->,>>>,>>9.99":U
      TPIR_LISTA.Campo-I[3] COLUMN-LABEL "Total!Bultos" FORMAT ">>>,>>9":U
            WIDTH 5.29
      TPIR_LISTA.Campo-I[4] COLUMN-LABEL "Total!Items" FORMAT ">>>,>>9":U
            WIDTH 4.29
      TPIR_LISTA.Campo-C[2] COLUMN-LABEL "Glosa" FORMAT "X(100)":U
            WIDTH 16.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 81.86 BY 7.19
         FONT 4
         TITLE "LISTA DE PIR CREADOS" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-9 W-Win _STRUCTURED
  QUERY BROWSE-9 NO-LOCK DISPLAY
      TORDENES_PIR.Campo-C[5] COLUMN-LABEL "Division despacho" FORMAT "X(40)":U
            WIDTH 20.43
      TORDENES_PIR.Campo-C[11] COLUMN-LABEL "Embalaje!especial" FORMAT "X(5)":U
      TORDENES_PIR.Campo-C[17] COLUMN-LABEL "Cliente!Recoje" FORMAT "X(5)":U
            WIDTH 4.72
      TORDENES_PIR.Campo-C[12] COLUMN-LABEL "Provincia" FORMAT "X(50)":U
      TORDENES_PIR.Campo-C[10] COLUMN-LABEL "Distrito" FORMAT "X(50)":U
            WIDTH 25.86
      TORDENES_PIR.Campo-C[16] COLUMN-LABEL "Cod!Ref" FORMAT "X(5)":U
      TORDENES_PIR.Campo-C[13] COLUMN-LABEL "Nro.!Referencia" FORMAT "X(11)":U
      TORDENES_PIR.Campo-C[4] COLUMN-LABEL "Division Venta" FORMAT "X(50)":U
            WIDTH 23.86
      TORDENES_PIR.Campo-D[1] COLUMN-LABEL "Fecha!Emision" FORMAT "99/99/9999":U
      TORDENES_PIR.Campo-D[2] COLUMN-LABEL "Fecha!Entrega" FORMAT "99/99/9999":U
      TORDENES_PIR.Campo-C[1] COLUMN-LABEL "Cod.!Orden" FORMAT "X(5)":U
      TORDENES_PIR.Campo-C[2] COLUMN-LABEL "Nro.!Orden" FORMAT "X(11)":U
      TORDENES_PIR.Campo-C[14] COLUMN-LABEL "Estado" FORMAT "X(15)":U
      TORDENES_PIR.Campo-C[8] COLUMN-LABEL "Nombre del Cliente" FORMAT "X(80)":U
            WIDTH 29.43
      TORDENES_PIR.Campo-F[1] COLUMN-LABEL "Monti" FORMAT "->,>>>,>>9.99":U
      TORDENES_PIR.Campo-I[1] COLUMN-LABEL "Items" FORMAT ">>>,>>9":U
      TORDENES_PIR.Campo-F[2] COLUMN-LABEL "Peso" FORMAT "->,>>>,>>9.99":U
      TORDENES_PIR.Campo-F[3] COLUMN-LABEL "Volumen" FORMAT "->,>>>,>>9.99":U
      TORDENES_PIR.Campo-I[2] COLUMN-LABEL "Bultos" FORMAT ">>>,>>9":U
      TORDENES_PIR.Campo-C[9] COLUMN-LABEL "Direccion de entrega" FORMAT "X(100)":U
            WIDTH 58.72
      TORDENES_PIR.Campo-C[15] COLUMN-LABEL "Glosa" FORMAT "X(80)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 70 BY 9.62
         FONT 4
         TITLE "DESDE DE UNA PIR EXISTENTE" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-7 AT ROW 1.04 COL 97.14 WIDGET-ID 500
     FILL-IN-desde AT ROW 1.23 COL 21 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-hasta AT ROW 1.23 COL 41.72 COLON-ALIGNED WIDGET-ID 14
     BUTTON-1 AT ROW 1.38 COL 71 WIDGET-ID 4
     BROWSE-5 AT ROW 2.31 COL 2.14 WIDGET-ID 400
     BUTTON-phr AT ROW 2.73 COL 179.86 WIDGET-ID 56
     BUTTON-buscar AT ROW 3.69 COL 74.29 WIDGET-ID 54
     RADIO-SET-campos AT ROW 3.88 COL 42 NO-LABEL WIDGET-ID 58
     BUTTON-fraccionar AT ROW 4.15 COL 179.86 WIDGET-ID 74
     FILL-IN-buscar AT ROW 4.88 COL 40 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     BROWSE-9 AT ROW 5.42 COL 24 WIDGET-ID 600
     BROWSE-2 AT ROW 5.88 COL 2 WIDGET-ID 200
     RADIO-SET-1 AT ROW 6.58 COL 181 NO-LABEL WIDGET-ID 76
     BUTTON-cancelar AT ROW 9.12 COL 154 WIDGET-ID 16
     BUTTON-nuevo AT ROW 9.12 COL 166.43 WIDGET-ID 18
     BROWSE-3 AT ROW 9.96 COL 96.86 WIDGET-ID 700
     BUTTON-2 AT ROW 15.04 COL 88.29 WIDGET-ID 6
     BUTTON-3 AT ROW 16.54 COL 88.29 WIDGET-ID 8
     BROWSE-12 AT ROW 20.46 COL 97.29 WIDGET-ID 900
     FILL-IN-items-4 AT ROW 8.31 COL 101 COLON-ALIGNED WIDGET-ID 66
     FILL-IN-peso-4 AT ROW 8.31 COL 116.29 COLON-ALIGNED WIDGET-ID 68
     FILL-IN-volumen-4 AT ROW 8.31 COL 132.72 COLON-ALIGNED WIDGET-ID 70
     FILL-IN-bultos-4 AT ROW 8.31 COL 150 COLON-ALIGNED WIDGET-ID 62
     FILL-IN-importe-4 AT ROW 8.31 COL 166.14 COLON-ALIGNED WIDGET-ID 64
     FILL-IN-3 AT ROW 9.12 COL 95 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     FILL-IN-items-2 AT ROW 24.92 COL 7 COLON-ALIGNED WIDGET-ID 36
     FILL-IN-peso-2 AT ROW 24.92 COL 22.29 COLON-ALIGNED WIDGET-ID 38
     FILL-IN-volumen-2 AT ROW 24.92 COL 38.72 COLON-ALIGNED WIDGET-ID 40
     FILL-IN-bultos-2 AT ROW 24.92 COL 56 COLON-ALIGNED WIDGET-ID 32
     FILL-IN-importe-2 AT ROW 24.92 COL 72.14 COLON-ALIGNED WIDGET-ID 34
     FILL-IN-items AT ROW 25 COL 101 COLON-ALIGNED WIDGET-ID 22
     FILL-IN-items-3 AT ROW 25 COL 101 COLON-ALIGNED WIDGET-ID 46
     FILL-IN-peso AT ROW 25 COL 116.72 COLON-ALIGNED WIDGET-ID 24
     FILL-IN-peso-3 AT ROW 25 COL 116.72 COLON-ALIGNED WIDGET-ID 48
     FILL-IN-volumen-3 AT ROW 25 COL 133.14 COLON-ALIGNED WIDGET-ID 50
     FILL-IN-bultos AT ROW 25 COL 150.43 COLON-ALIGNED WIDGET-ID 28
     FILL-IN-bultos-3 AT ROW 25 COL 150.43 COLON-ALIGNED WIDGET-ID 42
     FILL-IN-importe-3 AT ROW 25 COL 166.57 COLON-ALIGNED WIDGET-ID 44
     FILL-IN-importe AT ROW 25 COL 166.57 COLON-ALIGNED WIDGET-ID 30
     FILL-IN-volumen AT ROW 25.04 COL 133.14 COLON-ALIGNED WIDGET-ID 26
     "Click Columna" VIEW-AS TEXT
          SIZE 10.72 BY .5 AT ROW 5.92 COL 180.29 WIDGET-ID 80
          FGCOLOR 12 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 194.29 BY 24.73
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: PTOSDESPACHO T "?" NO-UNDO INTEGRAL w-report
      TABLE: TORDENES T "?" NO-UNDO INTEGRAL w-report
      TABLE: TORDENES_PIR T "?" NO-UNDO INTEGRAL w-report
      TABLE: TPIR_LISTA T "?" NO-UNDO INTEGRAL w-report
      TABLE: TRESUMEN_PTOS T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Planificador de Rutas"
         HEIGHT             = 24.73
         WIDTH              = 194.29
         MAX-HEIGHT         = 27.12
         MAX-WIDTH          = 198.72
         VIRTUAL-HEIGHT     = 27.12
         VIRTUAL-WIDTH      = 198.72
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
/* BROWSE-TAB BROWSE-7 TEXT-1 F-Main */
/* BROWSE-TAB BROWSE-5 BUTTON-1 F-Main */
/* BROWSE-TAB BROWSE-9 FILL-IN-buscar F-Main */
/* BROWSE-TAB BROWSE-2 BROWSE-9 F-Main */
/* BROWSE-TAB BROWSE-3 BUTTON-nuevo F-Main */
/* BROWSE-TAB BROWSE-12 BUTTON-3 F-Main */
ASSIGN 
       BROWSE-12:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE
       BROWSE-12:COLUMN-RESIZABLE IN FRAME F-Main       = TRUE.

ASSIGN 
       BROWSE-2:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-BROWSE-2:HANDLE
       BROWSE-2:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE
       BROWSE-2:COLUMN-RESIZABLE IN FRAME F-Main       = TRUE.

ASSIGN 
       BROWSE-3:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-BROWSE-3:HANDLE
       BROWSE-3:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE
       BROWSE-3:COLUMN-RESIZABLE IN FRAME F-Main       = TRUE.

ASSIGN 
       BROWSE-7:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE
       BROWSE-7:COLUMN-RESIZABLE IN FRAME F-Main       = TRUE.

ASSIGN 
       BROWSE-9:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-BROWSE-9:HANDLE
       BROWSE-9:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE
       BROWSE-9:COLUMN-RESIZABLE IN FRAME F-Main       = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-bultos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-bultos-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-bultos-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-bultos-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-importe IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-importe-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-importe-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-importe-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-items IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-items-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-items-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-items-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-peso IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-peso-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-peso-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-peso-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-volumen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-volumen-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-volumen-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-volumen-4 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-12
/* Query rebuild information for BROWSE BROWSE-12
     _TblList          = "Temp-Tables.TRESUMEN_PTOS"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.TRESUMEN_PTOS.Campo-C[1]
"TRESUMEN_PTOS.Campo-C[1]" "Punto!Despacho" "X(50)" "character" ? ? ? ? ? ? no ? no no "32.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.TRESUMEN_PTOS.Campo-I[1]
"TRESUMEN_PTOS.Campo-I[1]" "Items" ">>>,>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.TRESUMEN_PTOS.Campo-I[2]
"TRESUMEN_PTOS.Campo-I[2]" "Bultos" ">>>,>>9" "integer" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.TRESUMEN_PTOS.Campo-I[3]
"TRESUMEN_PTOS.Campo-I[3]" "Clientes" ">>>,>>9" "integer" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.TRESUMEN_PTOS.Campo-F[1]
"TRESUMEN_PTOS.Campo-F[1]" "Peso" ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.TRESUMEN_PTOS.Campo-F[2]
"TRESUMEN_PTOS.Campo-F[2]" "Volumen" ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.TRESUMEN_PTOS.Campo-F[3]
"TRESUMEN_PTOS.Campo-F[3]" "Importe" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.TRESUMEN_PTOS.Campo-I[4]
"TRESUMEN_PTOS.Campo-I[4]" "Ptos!entrega" ">>>,>>9" "integer" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-12 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.TORDENES"
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST"
     _OrdList          = "Temp-Tables.TORDENES.Campo-C[5]|yes,Temp-Tables.TORDENES.Campo-C[10]|yes,Temp-Tables.TORDENES.Campo-C[1]|yes,Temp-Tables.TORDENES.Campo-C[2]|yes"
     _Where[1]         = "TORDENES.campo-c[30] = """""
     _FldNameList[1]   > Temp-Tables.TORDENES.Campo-C[5]
"TORDENES.Campo-C[5]" "Division!Despacho" "X(50)" "character" ? ? ? ? ? ? no ? no no "25.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.TORDENES.Campo-C[11]
"TORDENES.Campo-C[11]" "Embalado!Especial" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.TORDENES.Campo-C[17]
"TORDENES.Campo-C[17]" "Cliente!Recoje" "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.TORDENES.Campo-C[12]
"TORDENES.Campo-C[12]" "Provincia" "X(40)" "character" ? ? ? ? ? ? no ? no no "23.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.TORDENES.Campo-C[10]
"TORDENES.Campo-C[10]" "Distrito de entrega" "X(40)" "character" ? ? ? ? ? ? no ? no no "34.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.TORDENES.Campo-C[16]
"TORDENES.Campo-C[16]" "Cod.!Ref" "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.TORDENES.Campo-C[13]
"TORDENES.Campo-C[13]" "Nro!Referencia" "X(11)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.TORDENES.Campo-C[4]
"TORDENES.Campo-C[4]" "Division!Venta" "X(50)" "character" ? ? ? ? ? ? no ? no no "21.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.TORDENES.Campo-D[1]
"TORDENES.Campo-D[1]" "Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.TORDENES.Campo-D[2]
"TORDENES.Campo-D[2]" "Entrega" ? "date" ? ? ? ? ? ? no ? no no "8.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.TORDENES.Campo-C[1]
"TORDENES.Campo-C[1]" "Cod!Doc" "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.TORDENES.Campo-C[2]
"TORDENES.Campo-C[2]" "Nro!Doc" "X(10)" "character" ? ? ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.TORDENES.Campo-C[14]
"TORDENES.Campo-C[14]" "Estado" "X(15)" "character" ? ? ? ? ? ? no ? no no "19.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.TORDENES.Campo-C[7]
"TORDENES.Campo-C[7]" "Cod.Cli" "X(13)" "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.TORDENES.Campo-C[8]
"TORDENES.Campo-C[8]" "Nombre del Cliente" "X(80)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.TORDENES.Campo-F[1]
"TORDENES.Campo-F[1]" "Monto" "->>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.TORDENES.Campo-I[1]
"TORDENES.Campo-I[1]" "Items" ">>>,>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.TORDENES.Campo-F[2]
"TORDENES.Campo-F[2]" "Peso" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > Temp-Tables.TORDENES.Campo-F[3]
"TORDENES.Campo-F[3]" "Volumen" "->,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > Temp-Tables.TORDENES.Campo-I[2]
"TORDENES.Campo-I[2]" "Bultos" ">,>>>,>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > Temp-Tables.TORDENES.Campo-C[9]
"TORDENES.Campo-C[9]" "Direccion de entrega" "X(100)" "character" ? ? ? ? ? ? no ? no no "62.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > Temp-Tables.TORDENES.Campo-C[15]
"TORDENES.Campo-C[15]" "Glosa" "X(50)" "character" ? ? ? ? ? ? no ? no no "47" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > Temp-Tables.TORDENES.Campo-C[29]
"TORDENES.Campo-C[29]" "PIR" "X(11)" "character" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
"TORDENES.Campo-C[5]" "Division!Despacho" "X(50)" "character" ? ? ? ? ? ? no ? no no "25.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.TORDENES.Campo-C[11]
"TORDENES.Campo-C[11]" "Embalado!Especial" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.TORDENES.Campo-C[17]
"TORDENES.Campo-C[17]" "Cliente!Recoje" "X(5)" "character" ? ? ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.TORDENES.Campo-C[12]
"TORDENES.Campo-C[12]" "Provincia" "X(40)" "character" ? ? ? ? ? ? no ? no no "24" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.TORDENES.Campo-C[10]
"TORDENES.Campo-C[10]" "Distrito de entrega" "X(40)" "character" ? ? ? ? ? ? no ? no no "24.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.TORDENES.Campo-C[16]
"TORDENES.Campo-C[16]" "Cod.!Ref" "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.TORDENES.Campo-C[13]
"TORDENES.Campo-C[13]" "Nro!Referencia" "X(11)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.TORDENES.Campo-C[4]
"TORDENES.Campo-C[4]" "Division!Venta" "X(50)" "character" ? ? ? ? ? ? no ? no no "21.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.TORDENES.Campo-D[1]
"TORDENES.Campo-D[1]" "Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.TORDENES.Campo-D[2]
"TORDENES.Campo-D[2]" "Entrega" ? "date" ? ? ? ? ? ? no ? no no "8.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.TORDENES.Campo-C[1]
"TORDENES.Campo-C[1]" "Cod!Doc" "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.TORDENES.Campo-C[2]
"TORDENES.Campo-C[2]" "Nro!Doc" "X(10)" "character" ? ? ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.TORDENES.Campo-C[14]
"TORDENES.Campo-C[14]" "Estado" "X(15)" "character" ? ? ? ? ? ? no ? no no "19.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.TORDENES.Campo-C[7]
"TORDENES.Campo-C[7]" "Cod.Cli" "X(13)" "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.TORDENES.Campo-C[8]
"TORDENES.Campo-C[8]" "Nombre del Cliente" "X(80)" "character" ? ? ? ? ? ? no ? no no "44.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.TORDENES.Campo-F[1]
"TORDENES.Campo-F[1]" "Monto" "->>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.TORDENES.Campo-I[1]
"TORDENES.Campo-I[1]" "Items" ">>>,>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.TORDENES.Campo-F[2]
"TORDENES.Campo-F[2]" "Peso" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > Temp-Tables.TORDENES.Campo-F[3]
"TORDENES.Campo-F[3]" "Volumen" "->,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > Temp-Tables.TORDENES.Campo-I[2]
"TORDENES.Campo-I[2]" "Bultos" ">,>>>,>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > Temp-Tables.TORDENES.Campo-C[9]
"TORDENES.Campo-C[9]" "Direccion de entrega" "X(100)" "character" ? ? ? ? ? ? no ? no no "52.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > Temp-Tables.TORDENES.Campo-C[15]
"TORDENES.Campo-C[15]" "Glosa" "X(50)" "character" ? ? ? ? ? ? no ? no no "49.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
     _TblList          = "Temp-Tables.TPIR_LISTA"
     _Options          = "NO-LOCK"
     _Where[1]         = "TPIR_LISTA.campo-c[30] = ''"
     _FldNameList[1]   > Temp-Tables.TPIR_LISTA.Campo-C[1]
"TPIR_LISTA.Campo-C[1]" "Nro.!PIR" "X(11)" "character" ? ? ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.TPIR_LISTA.Campo-I[1]
"TPIR_LISTA.Campo-I[1]" "Cant.!Clientes" ">>>,>>9" "integer" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.TPIR_LISTA.Campo-I[2]
"TPIR_LISTA.Campo-I[2]" "Puntos!entrega" ">>>,>>9" "integer" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.TPIR_LISTA.Campo-F[1]
"TPIR_LISTA.Campo-F[1]" "Monto!Total" ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.TPIR_LISTA.Campo-F[2]
"TPIR_LISTA.Campo-F[2]" "Peso!Total" ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.TPIR_LISTA.Campo-F[3]
"TPIR_LISTA.Campo-F[3]" "Volumen!Total" "->,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.TPIR_LISTA.Campo-I[3]
"TPIR_LISTA.Campo-I[3]" "Total!Bultos" ">>>,>>9" "integer" ? ? ? ? ? ? no ? no no "5.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.TPIR_LISTA.Campo-I[4]
"TPIR_LISTA.Campo-I[4]" "Total!Items" ">>>,>>9" "integer" ? ? ? ? ? ? no ? no no "4.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.TPIR_LISTA.Campo-C[2]
"TPIR_LISTA.Campo-C[2]" "Glosa" "X(100)" "character" ? ? ? ? ? ? no ? no no "16.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-7 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-9
/* Query rebuild information for BROWSE BROWSE-9
     _TblList          = "Temp-Tables.TORDENES_PIR"
     _Options          = "NO-LOCK"
     _Where[1]         = "TORDENES_PIR.campo-C[30] = ""X"""
     _FldNameList[1]   > Temp-Tables.TORDENES_PIR.Campo-C[5]
"TORDENES_PIR.Campo-C[5]" "Division despacho" "X(40)" "character" ? ? ? ? ? ? no ? no no "20.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.TORDENES_PIR.Campo-C[11]
"TORDENES_PIR.Campo-C[11]" "Embalaje!especial" "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.TORDENES_PIR.Campo-C[17]
"TORDENES_PIR.Campo-C[17]" "Cliente!Recoje" "X(5)" "character" ? ? ? ? ? ? no ? no no "4.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.TORDENES_PIR.Campo-C[12]
"TORDENES_PIR.Campo-C[12]" "Provincia" "X(50)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.TORDENES_PIR.Campo-C[10]
"TORDENES_PIR.Campo-C[10]" "Distrito" "X(50)" "character" ? ? ? ? ? ? no ? no no "25.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.TORDENES_PIR.Campo-C[16]
"TORDENES_PIR.Campo-C[16]" "Cod!Ref" "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.TORDENES_PIR.Campo-C[13]
"TORDENES_PIR.Campo-C[13]" "Nro.!Referencia" "X(11)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.TORDENES_PIR.Campo-C[4]
"TORDENES_PIR.Campo-C[4]" "Division Venta" "X(50)" "character" ? ? ? ? ? ? no ? no no "23.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.TORDENES_PIR.Campo-D[1]
"TORDENES_PIR.Campo-D[1]" "Fecha!Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.TORDENES_PIR.Campo-D[2]
"TORDENES_PIR.Campo-D[2]" "Fecha!Entrega" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.TORDENES_PIR.Campo-C[1]
"TORDENES_PIR.Campo-C[1]" "Cod.!Orden" "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.TORDENES_PIR.Campo-C[2]
"TORDENES_PIR.Campo-C[2]" "Nro.!Orden" "X(11)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.TORDENES_PIR.Campo-C[14]
"TORDENES_PIR.Campo-C[14]" "Estado" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.TORDENES_PIR.Campo-C[8]
"TORDENES_PIR.Campo-C[8]" "Nombre del Cliente" "X(80)" "character" ? ? ? ? ? ? no ? no no "29.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.TORDENES_PIR.Campo-F[1]
"TORDENES_PIR.Campo-F[1]" "Monti" "->,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.TORDENES_PIR.Campo-I[1]
"TORDENES_PIR.Campo-I[1]" "Items" ">>>,>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.TORDENES_PIR.Campo-F[2]
"TORDENES_PIR.Campo-F[2]" "Peso" "->,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.TORDENES_PIR.Campo-F[3]
"TORDENES_PIR.Campo-F[3]" "Volumen" "->,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > Temp-Tables.TORDENES_PIR.Campo-I[2]
"TORDENES_PIR.Campo-I[2]" "Bultos" ">>>,>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > Temp-Tables.TORDENES_PIR.Campo-C[9]
"TORDENES_PIR.Campo-C[9]" "Direccion de entrega" "X(100)" "character" ? ? ? ? ? ? no ? no no "58.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > Temp-Tables.TORDENES_PIR.Campo-C[15]
"TORDENES_PIR.Campo-C[15]" "Glosa" "X(80)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON MOUSE-SELECT-DBLCLICK OF BROWSE-2 IN FRAME F-Main /* Ordenes disponibles para crear PIRs */
DO:
    IF AVAILABLE TORDENES THEN DO:
        RUN logis/d-detalle-orden (TORDENES.campo-c[1], TORDENES.campo-c[2]).
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 W-Win
ON START-SEARCH OF BROWSE-2 IN FRAME F-Main /* Ordenes disponibles para crear PIRs */
DO:

    DEFINE VAR x-sql AS CHAR.

    x-sql = "FOR EACH TORDENES WHERE TORDENES.campo-c[30] = '' NO-LOCK ".

    {gn/sort-browse.i &ThisBrowse="browse-2" &ThisSQL = x-SQL}

    /*
    DO WITH FRAME {&FRAME-NAME} :
        IF browse-2:HELP <> "" THEN DO:
            button-buscar:LABEL  = "Buscar en " + REPLACE(ENTRY(2,browse-2:HELP,"|"),"!"," ").
        END.
    END.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 W-Win
ON VALUE-CHANGED OF BROWSE-2 IN FRAME F-Main /* Ordenes disponibles para crear PIRs */
DO:
    RUN mostrar-totales(INPUT BROWSE-2:HANDLE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&Scoped-define SELF-NAME BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-3 W-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-3 IN FRAME F-Main /* CREANDO UNA NUEVA PIR */
DO:
    IF AVAILABLE TORDENES THEN DO:
        RUN logis/d-detalle-orden (TORDENES.campo-c[1], TORDENES.campo-c[2]).
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
    /*
    x-sql = "FOR EACH DI-RutaC WHERE DI-RutaC.CodCia = " + STRING(s-codcia) + " and DI-RutaC.CodDiv = '" + s-coddiv + "' and " + 
                            "DI-RutaC.CodDoc = '" + s-coddoc + "' and DI-RutaC.flgest = 'P' NO-LOCK ".
    */

    x-sql = "FOR EACH TPIR_LISTA NO-LOCK WHERE TPIR_LISTA.campo-c[30] = ''".

    {gn/sort-browse.i &ThisBrowse="browse-7" &ThisSQL = x-SQL}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-7 W-Win
ON VALUE-CHANGED OF BROWSE-7 IN FRAME F-Main /* LISTA DE PIR CREADOS */
DO:

    RUN mostrar-totales(INPUT BROWSE-7:HANDLE).

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
ON MOUSE-SELECT-DBLCLICK OF BROWSE-9 IN FRAME F-Main /* DESDE DE UNA PIR EXISTENTE */
DO:
    IF AVAILABLE TORDENES_PIR THEN DO:
        RUN logis/d-detalle-orden (TORDENES_PIR.campo-c[1], TORDENES_PIR.campo-c[2]).
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

  IF (fill-in-hasta - fill-in-desde) > 30 THEN DO:
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


&Scoped-define SELF-NAME BUTTON-buscar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-buscar W-Win
ON CHOOSE OF BUTTON-buscar IN FRAME F-Main /* Buscar */
DO:
  DO WITH FRAME {&FRAME-NAME}:

      ASSIGN radio-set-campos fill-in-buscar.

      DEFINE VAR x-campo AS CHAR.
      DEFINE VAR x-condicion AS CHAR.
      DEFINE VAR x-cual-valor AS CHAR.


      CASE radio-set-campos:
          WHEN 1 THEN DO:
              x-condicion = "campo[8] begins '" + fill-in-buscar + "'".
          END.
          WHEN 2 THEN DO:
              x-condicion = "campo[2] begins '" + fill-in-buscar + "'".
          END.
          WHEN 3 THEN DO:
              x-condicion = "campo[13] begins '" + fill-in-buscar + "'".
          END.

      END CASE.

      {gn/find-browse.i &QueTabla="TORDENES" &QueBrowse="browse-2" &queCondcion=x-condicion}
      
  END.
END.

/*
FIND FIRST {&QueTabla} WHERE {&QueCampo} BEGINS {&cualValor} NO-LOCK NO-ERROR.
 IF AVAILABLE({&QueTabla}) THEN
    REPOSITION {&QueBrowse} TO RECID (RECID({&QueTabla})).



 IF browse-2:HELP <> "" THEN DO:
    button-buscar:LABEL  = "Buscar en " + REPLACE(ENTRY(2,browse-2:HELP,"|"),"!"," ").
END.
*/

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


&Scoped-define SELF-NAME BUTTON-fraccionar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-fraccionar W-Win
ON CHOOSE OF BUTTON-fraccionar IN FRAME F-Main /* Fraccionar */
DO:
  
    DEFINE VAR x-retval AS CHAR.
    
    IF NOT AVAILABLE TPIR_LISTA THEN RETURN NO-APPLY.

    RUN logis/p-generacion-de-PHR.r(INPUT TPIR_LISTA.campo-c[1], OUTPUT x-retval).

    IF x-retval = "OK" THEN DO:
        /* Actualizo el estado del PIR y refresh */
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-nuevo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-nuevo W-Win
ON CHOOSE OF BUTTON-nuevo IN FRAME F-Main /* Nuevo PIR */
DO:
    DO WITH FRAME {&FRAME-NAME} :

        FIND FIRST TORDENES WHERE TORDENES.campo-c[30] = 'X' NO-LOCK NO-ERROR.

        IF CAPS(BUTTON-nuevo:LABEL) = "GRABAR PIR" THEN DO:
            IF NOT AVAILABLE TORDENES THEN DO:
                MESSAGE "Aun no ha seleccionado ORDENES para generar un nuevo PIR"
                    VIEW-AS ALERT-BOX INFORMATION.
                RETURN NO-APPLY.
            END.
        END.

        MESSAGE 'Seguro de ' + CAPS(BUTTON-nuevo:LABEL) + '?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.

        SESSION:SET-WAIT-STATE("GENERAL").

        IF LOOKUP(CAPS(BUTTON-nuevo:LABEL),"GRABAR PIR,ACTUALIZAR PIR") > 0 THEN DO:
            IF CAPS(BUTTON-nuevo:LABEL) = "GRABAR PIR" THEN DO:
                RUN PIR-Grabar-nuevo-PIR.

                RUN PIR-Nuevo.
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


&Scoped-define SELF-NAME BUTTON-phr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-phr W-Win
ON CHOOSE OF BUTTON-phr IN FRAME F-Main /* Genera PHR */
DO:
  
    DEFINE VAR x-retval AS CHAR.
    DEFINE VAR x-docnuevos AS CHAR.

    DEFINE VAR x-ip-servidor AS CHAR.

    IF NOT AVAILABLE TPIR_LISTA THEN RETURN NO-APPLY.

    RUN ip-del-servidor(OUTPUT x-ip-servidor).

    IF x-ip-servidor <> "192.168.100.210" THEN DO:

        MESSAGE 'Seguro de generar PHR apartir del PIR nro ' TPIR_LISTA.campo-c[1] VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.

        RUN logis/p-generacion-de-PHR.r(INPUT s-coddoc, INPUT TPIR_LISTA.campo-c[1], OUTPUT x-retval, 
                                    OUTPUT x-docnuevos, INPUT x-solo-pruebas).
    
        IF x-retval = "OK" THEN DO:

            ASSIGN {&FIRST-TABLE-IN-QUERY-browse-7}.campo-c[30] = 'X'.

            /* Actualizo el estado del PIR y refresh */
            MESSAGE "Se crearon " + STRING(NUM-ENTRIES(x-docnuevos,";")) + " documento(s) nuevo(s)" SKIP
                    x-docnuevos
                VIEW-AS ALERT-BOX INFORMATION.

            {&open-query-browse-7}

        END.
        ELSE DO:
            MESSAGE x-retval VIEW-AS ALERT-BOX INFORMATION.
        END.
    END.
    ELSE DO:
        MESSAGE "La generacion de PHR no esta habilitado para el servidor PRODUCTIVO"
            VIEW-AS ALERT-BOX INFORMATION.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Generar_TXT
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Generar_TXT W-Win
ON CHOOSE OF MENU-ITEM m_Generar_TXT /* Generar TXT */
DO:
  RUN generar-txt(INPUT browse-2:HANDLE IN FRAME {&FRAME-NAME}).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Generar_TXT2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Generar_TXT2 W-Win
ON CHOOSE OF MENU-ITEM m_Generar_TXT2 /* Generar TXT */
DO:
  RUN generar-txt(INPUT browse-3:HANDLE IN FRAME {&FRAME-NAME}).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Generar_TXT3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Generar_TXT3 W-Win
ON CHOOSE OF MENU-ITEM m_Generar_TXT3 /* Generar TXT */
DO:
  RUN generar-txt(INPUT browse-9:HANDLE IN FRAME {&FRAME-NAME}).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-1 W-Win
ON VALUE-CHANGED OF RADIO-SET-1 IN FRAME F-Main
DO:
  DEFINE VAR x-dato AS INT.
  DEFINE VAR x-filer AS LOG.

  x-dato = INTEGER(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

  IF x-dato = 1 THEN DO:
      x-filer = NO.      
  END.
  ELSE DO:
     x-filer = YES.
  END.
  browse-2:COLUMN-MOVABLE = x-filer.
  browse-3:COLUMN-MOVABLE = x-filer.
  browse-7:COLUMN-MOVABLE = x-filer.
  browse-9:COLUMN-MOVABLE = x-filer.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-12
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/*
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-ptos-despacho W-Win 
PROCEDURE carga-ptos-despacho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE PTOSDESPACHO.   
                            
FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia AND
                        gn-divi.campo-log[1] = NO /* AND           /* Que NO este INACTIVO */
                        gn-divi.campo-log[5] = YES */ NO-LOCK,     /* Que sea CD */
                        FIRST TabGener WHERE TabGener.codcia = s-codcia AND
                                                TabGener.clave = "CFGINC" AND
                                                TabGener.codigo = gn-divi.coddiv AND 
                                                TabGener.libre_c01 = 'SI' NO-LOCK:
    
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

RUN carga-ptos-despacho.

FOR EACH PTOSDESPACHO WHERE PTOSDESPACHO.campo-l[1] = YES NO-LOCK:

    REPEAT x-conteo = 1 TO NUM-ENTRIES(x-ordenes,","):

        x-orden = ENTRY(x-conteo,x-ordenes,",").

        /* Las O/D y OTR */
        ORDENES:
        FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia AND
                                    faccpedi.divdes = PTOSDESPACHO.llave-c AND
                                    faccpedi.coddoc = x-orden AND    
                                    faccpedi.flgest = 'P' AND
                                    (faccpedi.fchent >= fill-in-desde AND faccpedi.fchent <= fill-in-hasta) AND 
                                    (FacCPedi.FlgSit = "T" OR FacCPedi.FlgSit = "TG" ) NO-LOCK:

                CASE TRUE:
                    WHEN Faccpedi.CodDoc = "OTR" THEN DO:
                        IF Faccpedi.TpoPed = "INC" THEN DO:
                            IF NOT Faccpedi.Glosa BEGINS 'INCIDENCIA: MAL ESTADO' THEN NEXT.
                        END.
                        IF Faccpedi.TpoPed = "XD" THEN NEXT.
                    END.
                    WHEN Faccpedi.CodDoc = "O/D" THEN DO:
                        IF Faccpedi.TipVta = "SI"  THEN NEXT.       /* TRAMITE DOCUMENTARIO */
                    END.
                END CASE.
   
                /* FALTA VALIDAR QUE NO ESTE EN PHR  */
                /* ******************************************************************** */
                /* SOLO SE VAN A ACEPTAR O/D OTR O/M QUE NO TENGAN HISTORIAL EN UNA PHR */
                /* ******************************************************************** */

                IF x-solo-pruebas = NO THEN DO:
                    FOR EACH Di-RutaD NO-LOCK WHERE Di-RutaD.codcia = s-codcia AND
                        Di-RutaD.coddiv = faccpedi.divdes /*s-coddiv*/ AND      /* PHR de la division de despacho */
                        Di-RutaD.coddoc = "PHR" AND
                        Di-RutaD.codref = Faccpedi.coddoc AND
                        Di-RutaD.nroref = Faccpedi.nroped,
                        FIRST Di-RutaC OF Di-RutaD NO-LOCK WHERE Di-RutaC.FlgEst <> "A":
                        /* Cabecera */
                        IF Di-RutaC.FlgEst BEGINS "P" THEN NEXT ORDENES.   /* NO debe estar en una PHR en PROCESO */
                        /* Detalle */
                        IF Di-RutaD.FlgEst = "A" THEN NEXT.         /* NO se considera el ANULADO */
                        /* Si está REPROGRAMADO se acepta, caso contrario no pasa */
                        IF Di-RutaD.FlgEst <> "R" THEN NEXT ORDENES.  /* Otra Orden */
                    END.
                END.

                /* **************************************************************** */
                /* RHC 12/10/2019 Ninguna que venga por reprogramación */
                /* **************************************************************** */
                FIND FIRST Almcdocu WHERE Almcdocu.codcia = s-codcia AND
                    Almcdocu.coddoc = Faccpedi.coddoc AND 
                    Almcdocu.nrodoc = Faccpedi.nroped AND
                    Almcdocu.codllave = faccpedi.divdes /*s-coddiv*/ AND    /* De la division de despacho */
                    Almcdocu.libre_c01 = 'H/R' NO-LOCK NO-ERROR.
                IF AVAILABLE Almcdocu THEN NEXT.

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

        END.   
    END.
END.

RUN PIR_cargar-existentes.

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
  DISPLAY FILL-IN-desde FILL-IN-hasta RADIO-SET-campos FILL-IN-buscar 
          RADIO-SET-1 FILL-IN-items-4 FILL-IN-peso-4 FILL-IN-volumen-4 
          FILL-IN-bultos-4 FILL-IN-importe-4 FILL-IN-3 FILL-IN-items-2 
          FILL-IN-peso-2 FILL-IN-volumen-2 FILL-IN-bultos-2 FILL-IN-importe-2 
          FILL-IN-items FILL-IN-items-3 FILL-IN-peso FILL-IN-peso-3 
          FILL-IN-volumen-3 FILL-IN-bultos FILL-IN-bultos-3 FILL-IN-importe-3 
          FILL-IN-importe FILL-IN-volumen 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-7 FILL-IN-desde FILL-IN-hasta BUTTON-1 BROWSE-5 BUTTON-phr 
         BUTTON-buscar RADIO-SET-campos BUTTON-fraccionar FILL-IN-buscar 
         BROWSE-9 BROWSE-2 RADIO-SET-1 BUTTON-cancelar BUTTON-nuevo BROWSE-3 
         BUTTON-2 BUTTON-3 BROWSE-12 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-txt W-Win 
PROCEDURE generar-txt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-Browse AS HANDLE.

DEFINE VAR x-archivo AS CHAR.
DEFINE VAR rpta AS LOG.

    SYSTEM-DIALOG GET-FILE x-Archivo
        FILTERS 'TXTs (*.txt)' '*.txt'
        ASK-OVERWRITE
        CREATE-TEST-FILE
        DEFAULT-EXTENSION '.txt'
        RETURN-TO-START-DIR
        SAVE-AS
        TITLE 'Exportar a TXT'
        UPDATE rpta.
    IF rpta = NO OR x-Archivo = '' THEN DO:
        MESSAGE "Ud. cancelo el proceso." SKIP
                "no se graba ningun archivo"
            VIEW-AS ALERT-BOX INFORMATION.
        RETURN.
    END.                        

    output to value(x-Archivo).

    def var i as int no-undo.
    def var v-handle as handle no-undo.
    def var v-line as int no-undo.
    def var v-qu as log no-undo.
   do i = 1 to p-browse:num-columns:
      v-handle = p-browse:get-browse-column(i).

      put unformatted 
          REPLACE(v-handle:LABEL,";"," ")
          if not i = p-browse:num-columns then ";" else "". 

   end.
   put skip.

   v-line = 1.
   repeat:
      if v-line = 1 then v-qu = p-browse:select-row(1).
      else v-qu = p-browse:select-next-row().
      if v-qu = no then leave.

      v-line = v-line + 1.

      do i = 1 to p-browse:num-columns:
         v-handle = p-browse:get-browse-column(i).
         
         if v-handle:data-type begins "dec" then 
             put unformatted 
                 dec(v-handle:screen-value)
                 if not i = p-browse:num-columns then ";" else "". 
         else if v-handle:data-type begins "int" then 
             put unformatted 
                 int(v-handle:screen-value)
                 if not i = p-browse:num-columns then ";" else "". 
             
         else 
             put unformatted 
                REPLACE(v-handle:screen-value,";"," ")
                if not i = p-browse:num-columns then ";" else "". 

      end.
      put skip.
   end.

   output close.

   MESSAGE "Se genero el siguiente archivo" SKIP
           x-Archivo SKIP
           "Para la separacion de campos se uso el punto y coma (;)"
           VIEW-AS ALERT-BOX INFORMATION.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-del-servidor W-Win 
PROCEDURE ip-del-servidor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER pRetVal AS CHAR.                   
                   
DEFINE VAR x-servidor AS CHAR.

x-servidor = "ninguno".
x-servidor = CAPS(SESSION:STARTUP-PARAMETERS).
IF INDEX(x-servidor,"-H") > 0 THEN DO:
    x-servidor = SUBSTRING(x-servidor,INDEX(x-servidor,"-H")).
    x-servidor = REPLACE(x-servidor,"-H","").
    IF INDEX(x-servidor,",") > 1 THEN DO:
        x-servidor = SUBSTRING(x-servidor,1,INDEX(x-servidor,",") - 1).
    END.
END.

pRetVal = TRIM(x-servidor).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mostrar-totales W-Win 
PROCEDURE mostrar-totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pBrowse AS HANDLE.

    DEFINE VAR x-items AS INT.
    DEFINE VAR x-peso AS DEC.
    DEFINE VAR x-vol AS DEC.
    DEFINE VAR x-bultos AS INT.
    DEFINE VAR x-importe AS DEC.

    DEFINE VAR x-sec AS INT.
    DEFINE VAR x-tot AS INT.
    DEFINE VAR x-data AS CHAR.

    DO WITH FRAME {&FRAME-NAME}:

        IF CAPS(pBrowse:NAME) = "BROWSE-2" THEN DO:

            x-tot = browse-2:NUM-SELECTED-ROWS.
            
            DO x-sec = 1 TO x-tot:
                IF browse-2:FETCH-SELECTED-ROW(x-sec) THEN DO:
                    x-items = x-items + {&FIRST-TABLE-IN-QUERY-browse-2}.campo-i[30].
                    x-peso = x-peso + {&FIRST-TABLE-IN-QUERY-browse-2}.campo-f[30].
                    x-vol = x-vol + {&FIRST-TABLE-IN-QUERY-browse-2}.campo-f[29].
                    x-bultos = x-bultos + {&FIRST-TABLE-IN-QUERY-browse-2}.campo-i[29].
                    x-importe = x-importe + {&FIRST-TABLE-IN-QUERY-browse-2}.campo-f[28].
                END.
            END.
        END.
        ELSE DO:
            
            IF CAPS(pBrowse:NAME) = "BROWSE-3" THEN DO:  

                FOR EACH TORDENES WHERE TORDENES.campo-c[30] = 'X':
                    x-items = x-items + TORDENES.campo-i[30].
                    x-peso = x-peso + TORDENES.campo-f[30].
                    x-vol = x-vol + TORDENES.campo-f[29].
                    x-bultos = x-bultos + TORDENES.campo-i[29].
                    x-importe = x-importe + TORDENES.campo-f[28].
                END.

            END.
            IF CAPS(pBrowse:NAME) = "BROWSE-9" THEN DO:
                FOR EACH TORDENES_PIR WHERE TORDENES_PIR.campo-c[30] = 'X':
                        x-items = x-items + TORDENES_PIR.campo-i[30].
                        x-peso = x-peso + TORDENES_PIR.campo-f[30].
                        x-vol = x-vol + TORDENES_PIR.campo-f[29].
                        x-bultos = x-bultos + TORDENES_PIR.campo-i[29].
                        x-importe = x-importe + TORDENES_PIR.campo-f[28].
                END.
            END.
            IF CAPS(pBrowse:NAME) = "BROWSE-7" THEN DO:


                x-tot = browse-7:NUM-SELECTED-ROWS.

                DO x-sec = 1 TO x-tot:
                    IF browse-7:FETCH-SELECTED-ROW(x-sec) THEN DO:
                        x-items = x-items + {&FIRST-TABLE-IN-QUERY-browse-7}.campo-i[4].
                        x-peso = x-peso + {&FIRST-TABLE-IN-QUERY-browse-7}.campo-f[2].
                        x-vol = x-vol + {&FIRST-TABLE-IN-QUERY-browse-7}.campo-f[3].
                        x-bultos = x-bultos + {&FIRST-TABLE-IN-QUERY-browse-7}.campo-i[3].
                        x-importe = x-importe + {&FIRST-TABLE-IN-QUERY-browse-7}.campo-f[1].
                    END.
                END.
            END.

        END.
    END.

      IF CAPS(pBrowse:NAME) = "BROWSE-2" THEN DO:
          fill-in-items-2:SCREEN-VALUE = STRING(x-items,fill-in-items-2:FORMAT).
          fill-in-peso-2:SCREEN-VALUE = STRING(x-peso,fill-in-peso-2:FORMAT).
          fill-in-volumen-2:SCREEN-VALUE = STRING(x-vol,fill-in-volumen-2:FORMAT).
          fill-in-bultos-2:SCREEN-VALUE = STRING(x-bultos,fill-in-bultos-2:FORMAT).
          fill-in-importe-2:SCREEN-VALUE = STRING(x-importe,fill-in-importe-2:FORMAT).
      END.
      IF CAPS(pBrowse:NAME) = "BROWSE-9" THEN DO:
          fill-in-items-3:SCREEN-VALUE = STRING(x-items,fill-in-items-3:FORMAT).
          fill-in-peso-3:SCREEN-VALUE = STRING(x-peso,fill-in-peso-3:FORMAT).
          fill-in-volumen-3:SCREEN-VALUE = STRING(x-vol,fill-in-volumen-3:FORMAT).
          fill-in-bultos-3:SCREEN-VALUE = STRING(x-bultos,fill-in-bultos-3:FORMAT).
          fill-in-importe-3:SCREEN-VALUE = STRING(x-importe,fill-in-importe-3:FORMAT).
      END.
      IF CAPS(pBrowse:NAME) = "BROWSE-3" THEN DO:
          fill-in-items:SCREEN-VALUE = STRING(x-items,fill-in-items:FORMAT).
          fill-in-peso:SCREEN-VALUE = STRING(x-peso,fill-in-peso:FORMAT).
          fill-in-volumen:SCREEN-VALUE = STRING(x-vol,fill-in-volumen:FORMAT).
          fill-in-bultos:SCREEN-VALUE = STRING(x-bultos,fill-in-bultos:FORMAT).
          fill-in-importe:SCREEN-VALUE = STRING(x-importe,fill-in-importe:FORMAT).
      END.
      IF CAPS(pBrowse:NAME) = "BROWSE-7" THEN DO:
          fill-in-items-4:SCREEN-VALUE = STRING(x-items,fill-in-items:FORMAT).
          fill-in-peso-4:SCREEN-VALUE = STRING(x-peso,fill-in-peso:FORMAT).
          fill-in-volumen-4:SCREEN-VALUE = STRING(x-vol,fill-in-volumen:FORMAT).
          fill-in-bultos-4:SCREEN-VALUE = STRING(x-bultos,fill-in-bultos:FORMAT).
          fill-in-importe-4:SCREEN-VALUE = STRING(x-importe,fill-in-importe:FORMAT).
      END.


END PROCEDURE.

/*
  */

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
                    ASSIGN {&FIRST-TABLE-IN-QUERY-browse-3}.campo-c[30] = x-value.
                END.
            END.
            /**/
            RUN mostrar-totales(INPUT browse-3:HANDLE).
        END.
        ELSE DO:

            IF CAPS(button-nuevo:LABEL) = "ACTUALIZAR PIR" THEN DO:
                /**/
                IF x-num-pir = "" THEN DO:
                    MESSAGE "No existe ninguna PIR para trabajar"
                        VIEW-AS ALERT-BOX INFORMATION.
                    RETURN.
                END.
            END.

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
            RUN mostrar-totales(INPUT browse-9:HANDLE).
            RUN mostrar-totales(INPUT browse-7:HANDLE).
        END.
        /**/
        
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

            IF x-num-pir <> "" THEN DO:
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
END.

{&open-query-browse-2}
{&open-query-browse-3}
{&open-query-browse-9}

 RUN PIR-cargar-resumen.

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

FIND FIRST b-di-rutaC WHERE b-di-rutaC.codcia = s-codcia AND
                            b-di-rutaC.coddoc = s-coddoc AND
                            b-di-rutaC.nrodoc = x-num-pir NO-LOCK NO-ERROR.
IF NOT AVAILABLE b-di-rutaC THEN DO:
    MESSAGE "El Nro. de PIR " + x-num-pir " NO EXISTE" SKIP
            "Por favor, haga click en REFRESCAR"
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.
IF b-di-rutaC.flgest <> "P" THEN DO:
    MESSAGE "El Nro. de PIR " + x-num-pir " ya no esta habilitada para ACTUALIZAR"
        "Por favor, haga click en REFRESCAR"
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

GRABAR_DATOS:
DO TRANSACTION ON ERROR UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS ON STOP UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS:

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

/* Refresca los totales */
FIND FIRST di-rutaC WHERE di-rutaC.codcia = s-codcia AND
                                di-rutaC.coddoc = s-coddoc AND
                                di-rutaC.nrodoc = x-num-pir NO-LOCK NO-ERROR.
IF AVAILABLE di-rutaC THEN DO:
    RUN PIR_cargar-ordenes.

    BROWSE-7:REFRESH() IN FRAME {&FRAME-NAME}. 
END.
RUN mostrar-totales(INPUT BROWSE-7:HANDLE IN FRAME {&FRAME-NAME}).

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

            RUN mover-registros(INPUT "Cancelar").
            RUN PIR-Nuevo.

        END.


    END.

END.

{&open-query-browse-2}
{&open-query-browse-3}
{&open-query-browse-9}

RUN PIR-cargar-resumen.

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

    DEFINE VAR x-items AS INT.
    DEFINE VAR x-peso AS DEC.
    DEFINE VAR x-vol AS DEC.
    DEFINE VAR x-bultos AS INT.
    DEFINE VAR x-importe AS DEC.

    x-PIR-actualizable = YES.

    x-num-pir = "".

    IF AVAILABLE TPIR_LISTA THEN DO:
        FIND FIRST di-rutaC WHERE di-rutaC.codcia = s-codcia AND
                                    di-rutaC.coddoc = 'PIR' AND
                                    di-rutaC.nrodoc = TPIR_lista.campo-c[1] NO-LOCK NO-ERROR.

        IF AVAILABLE di-rutaC THEN DO:

            x-num-pir = di-rutaC.nrodoc.

            FOR EACH di-rutaD OF di-rutaC NO-LOCK:

                CREATE TORDENES_PIR.
                ASSIGN TORDENES_PIR.campo-c[1] = di-rutaD.codref
                        TORDENES_PIR.campo-c[2] = di-rutaD.nroref
                        TORDENES_PIR.campo-c[10] = ""
                        TORDENES_PIR.campo-c[29] = di-rutaC.nrodoc          /* Indicador de que pertenece a un PIR */
                        TORDENES_PIR.campo-c[30] = "X"
                    .
                FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                                            faccpedi.coddoc = di-rutaD.codref AND
                                            faccpedi.nroped = di-rutaD.nroref NO-LOCK NO-ERROR.
                IF AVAILABLE faccpedi THEN DO:

                    {dist/PIR_datos-orden.i &wrkTORDENES="TORDENES_PIR"}.

                    ASSIGN TORDENES_PIR.campo-c[30] = "X"
                            TORDENES_PIR.campo-c[29] = di-rutaC.nrodoc.

                    x-items = x-items + TORDENES_PIR.campo-i[30].
                    x-peso = x-peso + TORDENES_PIR.campo-f[30].
                    x-vol = x-vol + TORDENES_PIR.campo-f[29].
                    x-bultos = x-bultos + TORDENES_PIR.campo-i[29].
                    x-importe = x-importe + TORDENES_PIR.campo-f[28].

                END.
            END.
        END.
    END.

    DO WITH FRAME {&FRAME-NAME}:

        IF browse-9:VISIBLE = YES THEN DO:
            IF CAPS(button-nuevo:LABEL) = "NUEVO PIR" OR 
                CAPS(button-nuevo:LABEL) = "GRABAR PIR" THEN  DO:
                button-nuevo:LABEL = "Actualizar PIR".
            END.

            fill-in-3:SCREEN-VALUE = "SE ESTA ACTUALIZANDO LA PIR " + x-num-pir.
            browse-9:TITLE = "ORDENES CONTENIDAS EN LA PIR " + x-num-pir.

            {&open-query-browse-9}
            RUN mostrar-totales(INPUT BROWSE-9:HANDLE).
            
            fill-in-items-3:VISIBLE = YES.
            fill-in-peso-3:VISIBLE = YES.
            fill-in-volumen-3:VISIBLE = YES.
            fill-in-bultos-3:VISIBLE = YES.
            fill-in-importe-3:VISIBLE = YES.

            fill-in-items:VISIBLE = NOT fill-in-items-3:VISIBLE.
            fill-in-peso:VISIBLE = NOT fill-in-peso-3:VISIBLE.
            fill-in-volumen:VISIBLE = NOT fill-in-volumen-3:VISIBLE.
            fill-in-bultos:VISIBLE = NOT fill-in-bultos-3:VISIBLE.
            fill-in-importe:VISIBLE = NOT fill-in-importe-3:VISIBLE.

        END.

    END.

    RUN PIR-cargar-resumen.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PIR-cargar-resumen W-Win 
PROCEDURE PIR-cargar-resumen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE TRESUMEN_PTOS.            
EMPTY TEMP-TABLE tt-puntos-entrega.
EMPTY TEMP-TABLE tt-clientes.

            
DO WITH FRAME {&FRAME-NAME}:
    IF browse-3:VISIBLE THEN DO:
        FOR EACH TORDENES WHERE TORDENES.campo-c[30] = 'X' NO-LOCK:
            RUN datos_orden(INPUT TORDENES.campo-c[5], INPUT TORDENES.campo-c[1], INPUT TORDENES.campo-c[2]).
        END.
    END.
    ELSE DO:
        FOR EACH TORDENES_PIR WHERE TORDENES_PIR.campo-c[30] = 'X' NO-LOCK:
            RUN datos_orden(INPUT TORDENES_PIR.campo-c[5], INPUT TORDENES_PIR.campo-c[1], INPUT TORDENES_PIR.campo-c[2]).
        END.

    END.
END.

{&open-query-browse-12}

END PROCEDURE.

PROCEDURE datos_orden:

    DEFINE INPUT PARAMETER pPuntoDspacho AS CHAR.
    DEFINE INPUT PARAMETER pCodDoc AS CHAR.
    DEFINE INPUT PARAMETER pNroDoc AS CHAR.

    FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                            faccpedi.coddoc = pCodDoc AND
                            faccpedi.nroped = pNroDoc NO-LOCK.
    IF NOT AVAILABLE faccpedi THEN RETURN.

    FIND FIRST TRESUMEN_PTOS WHERE TRESUMEN_PTOS.campo-c[1] = pPuntoDspacho EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE TRESUMEN_PTOS THEN DO:
        CREATE TRESUMEN_PTOS.
            ASSIGN TRESUMEN_PTOS.campo-c[1] = pPuntoDspacho.
    END.
    ASSIGN TRESUMEN_PTOS.campo-i[1] = TRESUMEN_PTOS.campo-i[1] + faccpedi.items
            TRESUMEN_PTOS.campo-i[2] = TRESUMEN_PTOS.campo-i[2] + faccpedi.acubon[9]
            TRESUMEN_PTOS.campo-f[1] = TRESUMEN_PTOS.campo-f[1] + faccpedi.peso
            TRESUMEN_PTOS.campo-f[2] = TRESUMEN_PTOS.campo-f[2] + faccpedi.volumen
            TRESUMEN_PTOS.campo-f[3] = TRESUMEN_PTOS.campo-f[3] + faccpedi.acubon[8]
        .

    /* Ptos */
    FIND FIRST tt-puntos-entrega WHERE  tt-puntos-entrega.tnropir = pPuntoDspacho AND
                                        tt-puntos-entrega.tcodcli = faccpedi.codcli AND
                                        tt-puntos-entrega.tsede = faccpedi.sede EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE tt-puntos-entrega THEN DO:
        CREATE tt-puntos-entrega.
            ASSIGN tt-puntos-entrega.tnropir = pPuntoDspacho
                    tt-puntos-entrega.tcodcli = faccpedi.codcli
                    tt-puntos-entrega.tsede = faccpedi.sede
                .

        ASSIGN TRESUMEN_PTOS.campo-i[4] = TRESUMEN_PTOS.campo-i[4] + 1.
    END.
    /* Clientes */
    FIND FIRST tt-clientes WHERE  tt-clientes.tcodcli = pPuntoDspacho + faccpedi.codcli EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE tt-clientes THEN DO:
        CREATE tt-clientes.
            ASSIGN tt-clientes.tcodcli = pPuntoDspacho + faccpedi.codcli
                .

        ASSIGN TRESUMEN_PTOS.campo-i[3] = TRESUMEN_PTOS.campo-i[3] + 1.
    END.

    /*
    EMPTY TEMP-TABLE tt-puntos-entrega.
    EMPTY TEMP-TABLE tt-clientes.
    
    .
    FOR EACH di-rutaD OF di-rutaC NO-LOCK, 
        FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                                faccpedi.coddoc = di-rutaD.codref AND
                                faccpedi.nroped = di-rutaD.nroref NO-LOCK:

        /* Ptos */
        FIND FIRST tt-puntos-entrega WHERE  tt-puntos-entrega.tnropir = di-rutaC.nrodoc AND
                                            tt-puntos-entrega.tcodcli = faccpedi.codcli AND
                                            tt-puntos-entrega.tsede = faccpedi.sede EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE tt-puntos-entrega THEN DO:
            CREATE tt-puntos-entrega.
                ASSIGN tt-puntos-entrega.tcodcli = faccpedi.codcli
                        tt-puntos-entrega.tcodcli = faccpedi.codcli
                        tt-puntos-entrega.tsede = faccpedi.sede
                    .

            ASSIGN TPIR_LISTA.campo-i[2] = TPIR_LISTA.campo-i[2] + 1.
        END.
        /* Clientes */
        FIND FIRST tt-clientes WHERE  tt-clientes.tcodcli = faccpedi.codcli EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE tt-clientes THEN DO:
            CREATE tt-clientes.
                ASSIGN tt-clientes.tcodcli = faccpedi.codcli
                    .

            ASSIGN TPIR_LISTA.campo-i[1] = TPIR_LISTA.campo-i[1] + 1.
        END.

        ASSIGN TPIR_LISTA.campo-f[1] = TPIR_LISTA.campo-f[1] + faccpedi.acubon[8]
            TPIR_LISTA.campo-f[2] = TPIR_LISTA.campo-f[2] + faccpedi.peso
            TPIR_LISTA.campo-f[3] = TPIR_LISTA.campo-f[3] + faccpedi.volumen
            TPIR_LISTA.campo-i[3] = TPIR_LISTA.campo-i[3] + faccpedi.acubon[9]
            TPIR_LISTA.campo-i[4] = TPIR_LISTA.campo-i[4] + faccpedi.items
        .
    END.
    */
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
            faccorre.coddiv = x-coddiv AND
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
            b-DI-RutaC.CodDiv = x-coddiv
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
        DELETE TORDENES NO-ERROR.
    END.
END.

RELEASE b-di-rutaC NO-ERROR.
RELEASE b-di-rutaD NO-ERROR.
RELEASE faccorre NO-ERROR.

IF x-proceso = "OK" THEN DO:
    MESSAGE "Se genero el Nro. de PIR :" + 
        STRING(x-serie, '999') + STRING(x-numero, '999999')
        VIEW-AS ALERT-BOX INFORMATION.

    /**/
    FIND FIRST DI-RutaC WHERE DI-RutaC.CodCia = s-codcia and 
                                DI-RutaC.CodDiv = x-coddiv and
                                DI-RutaC.CodDoc = s-coddoc and
                                DI-RutaC.nrodoc = STRING(x-serie, '999') + STRING(x-numero, '999999') 
                                NO-LOCK NO-ERROR.
    IF AVAILABLE DI-RutaC THEN DO:

        CREATE TPIR_LISTA.

        RUN PIR_cargar-ordenes.
    END.

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

    RUN mostrar-totales(INPUT BROWSE-3:HANDLE).
    RUN PIR-cargar-resumen.

    fill-in-items:VISIBLE = YES.
    fill-in-peso:VISIBLE = YES.
    fill-in-volumen:VISIBLE = YES.
    fill-in-bultos:VISIBLE = YES.
    fill-in-importe:VISIBLE = YES.

    fill-in-items-3:VISIBLE = NOT fill-in-items:VISIBLE.
    fill-in-peso-3:VISIBLE = NOT fill-in-peso:VISIBLE.
    fill-in-volumen-3:VISIBLE = NOT fill-in-volumen:VISIBLE.
    fill-in-bultos-3:VISIBLE = NOT fill-in-bultos:VISIBLE.
    fill-in-importe-3:VISIBLE = NOT fill-in-importe:VISIBLE.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PIR_cargar-existentes W-Win 
PROCEDURE PIR_cargar-existentes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE TPIR_lISTA.

FOR EACH DI-RutaC WHERE DI-RutaC.CodCia = s-codcia and 
                            DI-RutaC.CodDiv = x-coddiv and
                            DI-RutaC.CodDoc = s-coddoc and
                            DI-RutaC.flgest = 'P' NO-LOCK:

    /**/
    CREATE TPIR_LISTA.
        RUN PIR_cargar-ordenes.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PIR_cargar-ordenes W-Win 
PROCEDURE PIR_cargar-ordenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-puntos-entrega.
    EMPTY TEMP-TABLE tt-clientes.
    
        ASSIGN TPIR_LISTA.campo-c[1] = DI-RutaC.nrodoc
                TPIR_LISTA.campo-i[1] = 0       /* Qty Clientes */
                TPIR_LISTA.campo-i[2] = 0       /* Qty Ptos entrega */
                TPIR_LISTA.campo-f[1] = 0       /* Monto */
                TPIR_LISTA.campo-f[2] = 0       /* Peso */
                TPIR_LISTA.campo-f[3] = 0       /* Volumen */
                TPIR_LISTA.campo-i[3] = 0       /* Bultos */
                TPIR_LISTA.campo-i[4] = 0       /* SKUs */
                TPIR_LISTA.campo-c[2] = ""      /* Glosa */
    .
    FOR EACH di-rutaD OF di-rutaC NO-LOCK, 
        FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                                faccpedi.coddoc = di-rutaD.codref AND
                                faccpedi.nroped = di-rutaD.nroref NO-LOCK:

        /* Ptos */
        FIND FIRST tt-puntos-entrega WHERE  tt-puntos-entrega.tnropir = di-rutaC.nrodoc AND
                                            tt-puntos-entrega.tcodcli = faccpedi.codcli AND
                                            tt-puntos-entrega.tsede = faccpedi.sede EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE tt-puntos-entrega THEN DO:
            CREATE tt-puntos-entrega.
                ASSIGN tt-puntos-entrega.tnropir = di-rutaC.nrodoc
                        tt-puntos-entrega.tcodcli = faccpedi.codcli
                        tt-puntos-entrega.tsede = faccpedi.sede
                    .

            ASSIGN TPIR_LISTA.campo-i[2] = TPIR_LISTA.campo-i[2] + 1.
        END.
        /* Clientes */
        FIND FIRST tt-clientes WHERE  tt-clientes.tcodcli = faccpedi.codcli EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE tt-clientes THEN DO:
            CREATE tt-clientes.
                ASSIGN tt-clientes.tcodcli = faccpedi.codcli
                    .

            ASSIGN TPIR_LISTA.campo-i[1] = TPIR_LISTA.campo-i[1] + 1.
        END.

        ASSIGN TPIR_LISTA.campo-f[1] = TPIR_LISTA.campo-f[1] + faccpedi.acubon[8]
            TPIR_LISTA.campo-f[2] = TPIR_LISTA.campo-f[2] + faccpedi.peso
            TPIR_LISTA.campo-f[3] = TPIR_LISTA.campo-f[3] + faccpedi.volumen
            TPIR_LISTA.campo-i[3] = TPIR_LISTA.campo-i[3] + faccpedi.acubon[9]
            TPIR_LISTA.campo-i[4] = TPIR_LISTA.campo-i[4] + faccpedi.items
        .
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
  {src/adm/template/snd-list.i "TPIR_LISTA"}
  {src/adm/template/snd-list.i "PTOSDESPACHO"}
  {src/adm/template/snd-list.i "TORDENES"}
  {src/adm/template/snd-list.i "TRESUMEN_PTOS"}

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

