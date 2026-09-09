&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tmp-w-report NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE tt-ChkTareas NO-UNDO LIKE ChkTareas
       field tcoddoc as char
       field tnrodoc as char
       field tnro-phr as char
       field tcliente as char
       field tsku as int
       field tbultos as int
       field tcrossdocking as char
       field tchequeador as char
       field tcodclie as char.
DEFINE TEMP-TABLE tt-w-report NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE tt-w-report-zebra NO-UNDO LIKE w-report.



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
DEFINE SHARED VAR s-user-id AS CHAR.
DEFINE SHARED VAR s-codalm AS CHAR.

DEFINE VAR x-cantidad-sku-col AS INT.
DEFINE VAR x-cantidad-bultos-col AS INT.
DEFINE VAR x-tiempo-observado-col AS CHAR.
DEFINE VAR x-nom-chequeador-col AS CHAR.
DEFINE VAR x-cliente-col AS CHAR.
DEFINE VAR x-es-crossdocking-col AS CHAR.
DEFINE VAR x-cantidad-sku AS INT.

DEFINE VAR x-codped AS CHAR.
DEFINE VAR x-nroped AS CHAR.

DEFINE TEMP-TABLE ttOrdenes
    FIELDS  tcoddoc     AS  CHAR    FORMAT  'x(5)'
    FIELDS  tnrodoc     AS  CHAR    FORMAT  'x(15)'
    FIELDS  tcoddiv     AS  CHAR    FORMAT  'x(10)'
.

DEFINE TEMP-TABLE ttOrdenesHPK
    FIELDS  tcodhpk     AS  CHAR    FORMAT  'x(5)'
    FIELDS  tnrohpk     AS  CHAR    FORMAT  'x(15)'
    FIELDS  tcoddiv     AS  CHAR    FORMAT  'x(10)'
    FIELDS  tcodod     AS  CHAR    FORMAT  'x(5)'
    FIELDS  tnrood     AS  CHAR    FORMAT  'x(15)'
.

DEFINE TEMP-TABLE rr-w-report LIKE w-report.
DEFINE TEMP-TABLE pck-w-report LIKE w-report.   /* Para el Packing en ZEBRA */

DEF STREAM REPORTE.

DEFINE VAR s-task-no AS INT.
DEF VAR cCodEAN AS CHARACTER.
DEFINE VAR iInt AS INT NO-UNDO.
DEFINE VAR x-bultos AS INT.

DEFINE VAR x-phr-esta-cerrada AS LOG.

DEFINE VAR x-col-codorden AS CHAR.
DEFINE VAR x-col-nroorden AS CHAR.
DEFINE VAR x-col-nro-phr AS CHAR.
DEFINE VAR x-col-bultos AS INT INIT 0.
DEFINE VAR x-col-chequeador AS CHAR INIT "".

DEFINE BUFFER x-ControlOD FOR ControlOD.
DEFINE BUFFER x-vtaddocu FOR vtaddocu.
DEFINE BUFFER x-vtacdocu FOR vtacdocu.
DEFINE BUFFER x-faccpedi FOR faccpedi.
DEFINE BUFFER x-facdpedi FOR facdpedi.
DEFINE BUFFER x-chkcontrol FOR ChkCOntrol.
DEFINE BUFFER x-almddocu FOR almddocu.

DEFINE BUFFER od-faccpedi FOR faccpedi.
DEFINE BUFFER ped-faccpedi FOR faccpedi.

DEFINE BUFFER t-tmp-w-report FOR tmp-w-report.
DEFINE BUFFER t-tt-w-report FOR tt-w-report.

DEFINE VAR x-bultos-od AS DEC.      /* Cantidad de bultos de toda la OD */
DEFINE VAR x-packing-consolidado AS LOG.

DEFINE VAR x-packing-list-destino AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-14

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ChkTareas VtaCDocu tt-ChkTareas tt-w-report ~
tmp-w-report

/* Definitions for BROWSE BROWSE-14                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-14 ChkTareas.CodDoc ChkTareas.NroPed ~
tt-chktareas.tnro-phr @ x-col-nro-phr tt-chktareas.tcoddoc @ x-col-codorden ~
tt-chkTareas.tnrodoc @  x-col-nroorden ~
tt-ChkTareas.tcliente @ x-cliente-col tt-chktareas.tbultos @ x-col-bultos ~
ChkTareas.Mesa tt-chktareas.tchequeador @ x-col-chequeador ~
tiempo-observado(chktareas.fechafin, chktareas.horafin) @ x-tiempo-observado-col 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-14 
&Scoped-define QUERY-STRING-BROWSE-14 FOR EACH ChkTareas ~
      WHERE ChkTareas.codcia = s-codcia and ~
(fill-in-hpk = "" or chktareas.nroped = fill-in-hpk) and  ~
(ChkTareas.fechafin >= fill-in-desde and ChkTareas.fechafin <= fill-in-hasta) and ~
(ChkTareas.FlgEst = 'T' or ChkTareas.FlgEst = 'C') NO-LOCK, ~
      FIRST VtaCDocu WHERE VtaCDocu.CodCia =  ChkTareas.CodCia AND ~
 VtaCDocu.CodPed  = ChkTareas.CodDoc   AND ~
 VtaCDocu.NroPed =  ChkTareas.NroPed ~
      AND (fill-in-codtrab = "" or entry(1,vtacdocu.libre_c04,"|") = fill-in-codtrab) NO-LOCK, ~
      FIRST tt-ChkTareas WHERE tt-ChkTareas.CodCia  =  ChkTareas.CodCia  ~
  AND  tt-ChkTareas.CodDoc  = ChkTareas.CodDoc ~
  AND  tt-ChkTareas.NroPed = ChkTareas.NroPed OUTER-JOIN NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-14 OPEN QUERY BROWSE-14 FOR EACH ChkTareas ~
      WHERE ChkTareas.codcia = s-codcia and ~
(fill-in-hpk = "" or chktareas.nroped = fill-in-hpk) and  ~
(ChkTareas.fechafin >= fill-in-desde and ChkTareas.fechafin <= fill-in-hasta) and ~
(ChkTareas.FlgEst = 'T' or ChkTareas.FlgEst = 'C') NO-LOCK, ~
      FIRST VtaCDocu WHERE VtaCDocu.CodCia =  ChkTareas.CodCia AND ~
 VtaCDocu.CodPed  = ChkTareas.CodDoc   AND ~
 VtaCDocu.NroPed =  ChkTareas.NroPed ~
      AND (fill-in-codtrab = "" or entry(1,vtacdocu.libre_c04,"|") = fill-in-codtrab) NO-LOCK, ~
      FIRST tt-ChkTareas WHERE tt-ChkTareas.CodCia  =  ChkTareas.CodCia  ~
  AND  tt-ChkTareas.CodDoc  = ChkTareas.CodDoc ~
  AND  tt-ChkTareas.NroPed = ChkTareas.NroPed OUTER-JOIN NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-14 ChkTareas VtaCDocu tt-ChkTareas
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-14 ChkTareas
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-14 VtaCDocu
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-14 tt-ChkTareas


/* Definitions for BROWSE BROWSE-16                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-16 tt-w-report.Campo-L[1] ~
tt-w-report.Campo-C[1] tt-w-report.Campo-C[2] tt-w-report.Campo-C[3] ~
tt-w-report.Campo-C[4] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-16 tt-w-report.Campo-L[1] 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-16 tt-w-report
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-16 tt-w-report
&Scoped-define QUERY-STRING-BROWSE-16 FOR EACH tt-w-report NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-16 OPEN QUERY BROWSE-16 FOR EACH tt-w-report NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-16 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-16 tt-w-report


/* Definitions for BROWSE BROWSE-18                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-18 tmp-w-report.Campo-L[1] ~
tmp-w-report.Campo-C[1] tmp-w-report.Campo-C[2] tmp-w-report.Campo-C[3] ~
tmp-w-report.Campo-C[4] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-18 tmp-w-report.Campo-L[1] 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-18 tmp-w-report
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-18 tmp-w-report
&Scoped-define QUERY-STRING-BROWSE-18 FOR EACH tmp-w-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-18 OPEN QUERY BROWSE-18 FOR EACH tmp-w-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-18 tmp-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-18 tmp-w-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-14}~
    ~{&OPEN-QUERY-BROWSE-16}~
    ~{&OPEN-QUERY-BROWSE-18}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-14 BROWSE-18 FILL-IN-codtrab ~
FILL-IN-phr FILL-IN-hpk FILL-IN-desde FILL-IN-hasta COMBO-BOX-CodDoc ~
FILL-IN-Orden BUTTON-3 BUTTON-35 TOGGLE-packing-zebra BUTTON-6 BUTTON-1 ~
BUTTON-2 BROWSE-16 BUTTON-7 BUTTON-8 BUTTON-9 BUTTON-10 BUTTON-11 BUTTON-34 ~
BUTTON-37 BUTTON-38 RECT-4 RECT-5 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-codtrab FILL-IN-phr FILL-IN-hpk ~
FILL-IN-desde FILL-IN-hasta COMBO-BOX-CodDoc FILL-IN-Orden ~
TOGGLE-packing-zebra 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cantidad-bultos W-Win 
FUNCTION cantidad-bultos RETURNS INTEGER
  ( INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cantidad-sku W-Win 
FUNCTION cantidad-sku RETURNS INTEGER
  ( INPUT pCodDoc AS CHAR, INPUT pNrodoc AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD chequeador W-Win 
FUNCTION chequeador RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroPed AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cliente W-Win 
FUNCTION cliente RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroDOc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD es-crossdocking W-Win 
FUNCTION es-crossdocking RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPeso-orden W-Win 
FUNCTION fPeso-orden RETURNS DECIMAL
  ( INPUT pCodOrden AS CHAR, INPUT pNroOrden AS CHAR, INPUT pCodHPK AS CHAR, INPUT pNroPHK AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD get-datos-adicionales W-Win 
FUNCTION get-datos-adicionales RETURNS CHARACTER
  ( INPUT pCodDOc AS CHAR, INPUT pNroDoc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tiempo-observado W-Win 
FUNCTION tiempo-observado RETURNS CHARACTER
  ( INPUT pFecha AS DATE, INPUT pHora AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Marcar todos" 
     SIZE 10 BY 1.12.

DEFINE BUTTON BUTTON-10 
     LABEL "Packing BCP" 
     SIZE 16 BY .96
     BGCOLOR 9 FGCOLOR 12 .

DEFINE BUTTON BUTTON-11 
     LABEL "Packing MI BANCO" 
     SIZE 16 BY .96
     BGCOLOR 9 FGCOLOR 12 .

DEFINE BUTTON BUTTON-2 
     LABEL "Desmarcar todo" 
     SIZE 12 BY 1.12.

DEFINE BUTTON BUTTON-3 
     LABEL "Refrescar" 
     SIZE 12.72 BY .96.

DEFINE BUTTON BUTTON-34 
     LABEL "Ir a Rotulos del Cliente ZEBRA" 
     SIZE 23.14 BY .92.

DEFINE BUTTON BUTTON-35 
     LABEL "Packinng Consolidado" 
     SIZE 17.43 BY 1.12.

DEFINE BUTTON BUTTON-37 
     LABEL "Rotulos despacho" 
     SIZE 16 BY 1.12.

DEFINE BUTTON BUTTON-38 
     LABEL "Packing List ZEBRA" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-4 
     LABEL "Imprimir Rotulos en la ZEBRA" 
     SIZE 21 BY 1.12.

DEFINE BUTTON BUTTON-5 
     LABEL "Imprimir Rotulo MASTER" 
     SIZE 27.43 BY 1.12.

DEFINE BUTTON BUTTON-6 
     LABEL "Packing List" 
     SIZE 13 BY 1.12.

DEFINE BUTTON BUTTON-7 
     LABEL "Ir a Rotulos del Cliente" 
     SIZE 18 BY .96.

DEFINE BUTTON BUTTON-8 
     LABEL "Marcar todos" 
     SIZE 11 BY 1.12.

DEFINE BUTTON BUTTON-9 
     LABEL "Desmarcar todo" 
     SIZE 13 BY 1.12.

DEFINE VARIABLE COMBO-BOX-CodDoc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cod.Doc." 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "O/D","OTR" 
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-codtrab AS CHARACTER FORMAT "x(6)":U 
     LABEL "Cod.Trab" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-copias AS INTEGER FORMAT ">>9":U INITIAL 1 
     LABEL "Copias" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .77
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-hpk AS CHARACTER FORMAT "X(12)":U 
     LABEL "HPK" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-Orden AS CHARACTER FORMAT "X(12)":U 
     LABEL "Orden" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-phr AS CHARACTER FORMAT "X(12)":U 
     LABEL "PHR" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20.57 BY 3.88.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 149 BY 2.42.

DEFINE VARIABLE TOGGLE-packing-zebra AS LOGICAL INITIAL yes 
     LABEL "Packing List en ZEBRA" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-14 FOR 
      ChkTareas, 
      VtaCDocu, 
      tt-ChkTareas SCROLLING.

DEFINE QUERY BROWSE-16 FOR 
      tt-w-report SCROLLING.

DEFINE QUERY BROWSE-18 FOR 
      tmp-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-14 W-Win _STRUCTURED
  QUERY BROWSE-14 NO-LOCK DISPLAY
      ChkTareas.CodDoc COLUMN-LABEL "Cod." FORMAT "x(3)":U WIDTH 3.43
            LABEL-FONT 0
      ChkTareas.NroPed COLUMN-LABEL "Nro.Orden" FORMAT "X(12)":U
            WIDTH 10.43 LABEL-FONT 0
      tt-chktareas.tnro-phr @ x-col-nro-phr COLUMN-LABEL "Nro. PHR." FORMAT "x(15)":U
            WIDTH 9.43 COLUMN-BGCOLOR 11
      tt-chktareas.tcoddoc @ x-col-codorden COLUMN-LABEL "Cod.Doc"
      tt-chkTareas.tnrodoc @  x-col-nroorden COLUMN-LABEL "Orden" FORMAT "x(12)":U
      tt-ChkTareas.tcliente @ x-cliente-col COLUMN-LABEL "Nombre Cliente" FORMAT "x(50)":U
            WIDTH 39.43
      tt-chktareas.tbultos @ x-col-bultos COLUMN-LABEL "Bultos"
            WIDTH 6.43
      ChkTareas.Mesa FORMAT "x(8)":U WIDTH 9.29
      tt-chktareas.tchequeador @ x-col-chequeador COLUMN-LABEL "Chequeador" FORMAT "x(40)":U
            WIDTH 23.86
      tiempo-observado(chktareas.fechafin, chktareas.horafin) @ x-tiempo-observado-col COLUMN-LABEL "Hora Terminado" FORMAT "x(25)":U
            WIDTH 23.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 149 BY 11.15
         FONT 4
         TITLE "Bandeja de ordenes terminadas - Impresion de Rotulos" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-16
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-16 W-Win _STRUCTURED
  QUERY BROWSE-16 NO-LOCK DISPLAY
      tt-w-report.Campo-L[1] COLUMN-LABEL "" FORMAT "Si/No":U WIDTH 4.43
            COLUMN-FONT 0 VIEW-AS TOGGLE-BOX
      tt-w-report.Campo-C[1] COLUMN-LABEL "Cod." FORMAT "X(4)":U
            WIDTH 5 COLUMN-FONT 0
      tt-w-report.Campo-C[2] COLUMN-LABEL "Orden" FORMAT "X(11)":U
            COLUMN-FONT 0
      tt-w-report.Campo-C[3] COLUMN-LABEL "Cod.Bulto" FORMAT "X(22)":U
            WIDTH 22.86 COLUMN-FONT 0
      tt-w-report.Campo-C[4] COLUMN-LABEL "Cliente" FORMAT "X(50)":U
            WIDTH 33.29
  ENABLE
      tt-w-report.Campo-L[1]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 79 BY 9.96
         FONT 4
         TITLE "BULTOS POR HPK" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-18
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-18 W-Win _STRUCTURED
  QUERY BROWSE-18 NO-LOCK DISPLAY
      tmp-w-report.Campo-L[1] COLUMN-LABEL "" FORMAT "Si/No":U
            WIDTH 5.43 VIEW-AS TOGGLE-BOX
      tmp-w-report.Campo-C[1] COLUMN-LABEL "Cod!Doc" FORMAT "X(3)":U
            WIDTH 5.43
      tmp-w-report.Campo-C[2] COLUMN-LABEL "Nro.!Doc." FORMAT "X(12)":U
            WIDTH 10.43
      tmp-w-report.Campo-C[3] COLUMN-LABEL "Bulto" FORMAT "X(25)":U
      tmp-w-report.Campo-C[4] COLUMN-LABEL "Cliente" FORMAT "X(50)":U
            WIDTH 21.29
  ENABLE
      tmp-w-report.Campo-L[1]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 66 BY 9.92
         FONT 4
         TITLE "BULTOS POR ORDEN DE DESPACHO" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-14 AT ROW 3.42 COL 2 WIDGET-ID 200
     BROWSE-18 AT ROW 14.69 COL 82 WIDGET-ID 400
     FILL-IN-codtrab AT ROW 1.31 COL 11.29 COLON-ALIGNED WIDGET-ID 30
     FILL-IN-phr AT ROW 1.35 COL 33 COLON-ALIGNED WIDGET-ID 32
     FILL-IN-hpk AT ROW 1.35 COL 54 COLON-ALIGNED WIDGET-ID 34
     FILL-IN-desde AT ROW 1.27 COL 101 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-hasta AT ROW 1.27 COL 121 COLON-ALIGNED WIDGET-ID 14
     COMBO-BOX-CodDoc AT ROW 2.27 COL 11 COLON-ALIGNED WIDGET-ID 54
     FILL-IN-Orden AT ROW 2.27 COL 25 COLON-ALIGNED WIDGET-ID 56
     BUTTON-3 AT ROW 1.81 COL 136 WIDGET-ID 16
     BUTTON-35 AT ROW 19.58 COL 150 WIDGET-ID 52
     TOGGLE-packing-zebra AT ROW 17.85 COL 149.43 WIDGET-ID 48
     FILL-IN-copias AT ROW 8.23 COL 143 COLON-ALIGNED WIDGET-ID 28
     BUTTON-6 AT ROW 24.62 COL 25.14 WIDGET-ID 26
     BUTTON-5 AT ROW 6.69 COL 122 WIDGET-ID 24
     BUTTON-4 AT ROW 22.15 COL 149 WIDGET-ID 20
     BUTTON-1 AT ROW 24.62 COL 14.14 WIDGET-ID 8
     BUTTON-2 AT ROW 24.62 COL 2.14 WIDGET-ID 10
     BROWSE-16 AT ROW 14.65 COL 2 WIDGET-ID 300
     BUTTON-7 AT ROW 24.88 COL 133 WIDGET-ID 36
     BUTTON-8 AT ROW 24.62 COL 95.29 WIDGET-ID 38
     BUTTON-9 AT ROW 24.62 COL 82 WIDGET-ID 40
     BUTTON-10 AT ROW 15.35 COL 149.43 WIDGET-ID 42
     BUTTON-11 AT ROW 16.69 COL 149.43 WIDGET-ID 44
     BUTTON-34 AT ROW 24.88 COL 109 WIDGET-ID 46
     BUTTON-37 AT ROW 24.65 COL 62 WIDGET-ID 62
     BUTTON-38 AT ROW 24.65 COL 40 WIDGET-ID 64
     "Ordenes terminadas" VIEW-AS TEXT
          SIZE 20.57 BY .62 AT ROW 1.5 COL 74 WIDGET-ID 18
          FGCOLOR 9 FONT 10
     RECT-4 AT ROW 15.12 COL 148.43 WIDGET-ID 50
     RECT-5 AT ROW 1 COL 2 WIDGET-ID 58
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 169.57 BY 24.92
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tmp-w-report T "?" NO-UNDO INTEGRAL w-report
      TABLE: tt-ChkTareas T "?" NO-UNDO INTEGRAL ChkTareas
      ADDITIONAL-FIELDS:
          field tcoddoc as char
          field tnrodoc as char
          field tnro-phr as char
          field tcliente as char
          field tsku as int
          field tbultos as int
          field tcrossdocking as char
          field tchequeador as char
          field tcodclie as char
      END-FIELDS.
      TABLE: tt-w-report T "?" NO-UNDO INTEGRAL w-report
      TABLE: tt-w-report-zebra T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Gestion de Ordenes terminadas - Impresion de Rotulos"
         HEIGHT             = 25.15
         WIDTH              = 170.43
         MAX-HEIGHT         = 27.04
         MAX-WIDTH          = 180.72
         VIRTUAL-HEIGHT     = 27.04
         VIRTUAL-WIDTH      = 180.72
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
/* BROWSE-TAB BROWSE-14 1 F-Main */
/* BROWSE-TAB BROWSE-18 BROWSE-14 F-Main */
/* BROWSE-TAB BROWSE-16 BUTTON-2 F-Main */
/* SETTINGS FOR BUTTON BUTTON-4 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-4:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-5 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-5:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-copias IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN-copias:HIDDEN IN FRAME F-Main           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-14
/* Query rebuild information for BROWSE BROWSE-14
     _TblList          = "INTEGRAL.ChkTareas,INTEGRAL.VtaCDocu WHERE INTEGRAL.ChkTareas ...,Temp-Tables.tt-ChkTareas WHERE INTEGRAL.ChkTareas ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST, FIRST OUTER"
     _Where[1]         = "ChkTareas.codcia = s-codcia and
(fill-in-hpk = """" or chktareas.nroped = fill-in-hpk) and 
(ChkTareas.fechafin >= fill-in-desde and ChkTareas.fechafin <= fill-in-hasta) and
(ChkTareas.FlgEst = 'T' or ChkTareas.FlgEst = 'C')"
     _JoinCode[2]      = "INTEGRAL.VtaCDocu.CodCia =  ChkTareas.CodCia AND
 INTEGRAL.VtaCDocu.CodPed  = ChkTareas.CodDoc   AND
 INTEGRAL.VtaCDocu.NroPed =  ChkTareas.NroPed"
     _Where[2]         = "(fill-in-codtrab = """" or entry(1,vtacdocu.libre_c04,""|"") = fill-in-codtrab)"
     _JoinCode[3]      = "Temp-Tables.tt-ChkTareas.CodCia  =  INTEGRAL.ChkTareas.CodCia 
  AND  Temp-Tables.tt-ChkTareas.CodDoc  = INTEGRAL.ChkTareas.CodDoc
  AND  Temp-Tables.tt-ChkTareas.NroPed = INTEGRAL.ChkTareas.NroPed"
     _FldNameList[1]   > INTEGRAL.ChkTareas.CodDoc
"ChkTareas.CodDoc" "Cod." ? "character" ? ? ? ? ? 0 no ? no no "3.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.ChkTareas.NroPed
"ChkTareas.NroPed" "Nro.Orden" ? "character" ? ? ? ? ? 0 no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"tt-chktareas.tnro-phr @ x-col-nro-phr" "Nro. PHR." "x(15)" ? 11 ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"tt-chktareas.tcoddoc @ x-col-codorden" "Cod.Doc" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"tt-chkTareas.tnrodoc @  x-col-nroorden" "Orden" "x(12)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"tt-ChkTareas.tcliente @ x-cliente-col" "Nombre Cliente" "x(50)" ? ? ? ? ? ? ? no ? no no "39.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"tt-chktareas.tbultos @ x-col-bultos" "Bultos" ? ? ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.ChkTareas.Mesa
"ChkTareas.Mesa" ? ? "character" ? ? ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"tt-chktareas.tchequeador @ x-col-chequeador" "Chequeador" "x(40)" ? ? ? ? ? ? ? no ? no no "23.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"tiempo-observado(chktareas.fechafin, chktareas.horafin) @ x-tiempo-observado-col" "Hora Terminado" "x(25)" ? ? ? ? ? ? ? no ? no no "23.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-14 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-16
/* Query rebuild information for BROWSE BROWSE-16
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-L[1]
"tt-w-report.Campo-L[1]" "" ? "logical" ? ? 0 ? ? ? yes ? no no "4.43" yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[1]
"tt-w-report.Campo-C[1]" "Cod." "X(4)" "character" ? ? 0 ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-C[2]
"tt-w-report.Campo-C[2]" "Orden" "X(11)" "character" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report.Campo-C[3]
"tt-w-report.Campo-C[3]" "Cod.Bulto" "X(22)" "character" ? ? 0 ? ? ? no ? no no "22.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-w-report.Campo-C[4]
"tt-w-report.Campo-C[4]" "Cliente" "X(50)" "character" ? ? ? ? ? ? no ? no no "33.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-16 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-18
/* Query rebuild information for BROWSE BROWSE-18
     _TblList          = "Temp-Tables.tmp-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tmp-w-report.Campo-L[1]
"tmp-w-report.Campo-L[1]" "" ? "logical" ? ? ? ? ? ? yes ? no no "5.43" yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[2]   > Temp-Tables.tmp-w-report.Campo-C[1]
"tmp-w-report.Campo-C[1]" "Cod!Doc" "X(3)" "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tmp-w-report.Campo-C[2]
"tmp-w-report.Campo-C[2]" "Nro.!Doc." "X(12)" "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tmp-w-report.Campo-C[3]
"tmp-w-report.Campo-C[3]" "Bulto" "X(25)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tmp-w-report.Campo-C[4]
"tmp-w-report.Campo-C[4]" "Cliente" "X(50)" "character" ? ? ? ? ? ? no ? no no "21.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-18 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Gestion de Ordenes terminadas - Impresion de Rotulos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Gestion de Ordenes terminadas - Impresion de Rotulos */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-14
&Scoped-define SELF-NAME BROWSE-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-14 W-Win
ON ENTRY OF BROWSE-14 IN FRAME F-Main /* Bandeja de ordenes terminadas - Impresion de Rotulos */
DO:
    x-codped = "".
    x-nroped = "".
    /*browse-15:TITLE = "".*/
    IF AVAILABLE chktareas THEN DO:
          x-codped = chktareas.coddoc.
          x-nroped = chktareas.nroped.          
    END.

    RUN rotulos-de-las-ordenes(INPUT x-codped, INPUT x-nroped).

    {&open-query-browse-16}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-14 W-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-14 IN FRAME F-Main /* Bandeja de ordenes terminadas - Impresion de Rotulos */
DO:
    /*
  IF AVAILABLE chktareas THEN DO:
        MESSAGE "Pasar La Orden " + chktareas.coddoc + " " + chktareas.nroped  + " a Distribucion ?" VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.
    
    RUN terminar-orden.

  END.
  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-14 W-Win
ON VALUE-CHANGED OF BROWSE-14 IN FRAME F-Main /* Bandeja de ordenes terminadas - Impresion de Rotulos */
DO:
  x-codped = "".
  x-nroped = "".

  IF AVAILABLE chktareas THEN DO:
        x-codped = chktareas.coddoc.
        x-nroped = chktareas.nroped.
  END.
  
  RUN rotulos-de-las-ordenes(INPUT x-codped, INPUT x-nroped).   /* HPK */

  {&open-query-browse-16}
  {&open-query-browse-18}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Marcar todos */
DO:
  FOR EACH tt-w-report :
      ASSIGN tt-w-report.campo-l[1] = YES.
  END.

  {&open-query-browse-16}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-10 W-Win
ON CHOOSE OF BUTTON-10 IN FRAME F-Main /* Packing BCP */
DO:
  IF AVAILABLE chktareas THEN DO:

      ASSIGN toggle-packing-zebra.

      x-packing-consolidado = NO.

      RUN packing-bcp(INPUT chktareas.coddoc, INPUT chktareas.nroped).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-11 W-Win
ON CHOOSE OF BUTTON-11 IN FRAME F-Main /* Packing MI BANCO */
DO:
  IF AVAILABLE chktareas THEN DO:

      ASSIGN toggle-packing-zebra.

      x-packing-consolidado = NO.

      RUN packing-mi-banco(INPUT chktareas.coddoc, INPUT chktareas.nroped).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Desmarcar todo */
DO:
    FOR EACH tt-w-report :
        ASSIGN tt-w-report.campo-l[1] = NO.
    END.
  
    {&open-query-browse-16}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Refrescar */
DO:

    ASSIGN fill-in-codtrab fill-in-phr fill-in-hpk.
    ASSIGN COMBO-BOX-CodDoc FILL-IN-Orden.

  SESSION:SET-WAIT-STATE('GENERAL').
  RUN refrescar.
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-34
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-34 W-Win
ON CHOOSE OF BUTTON-34 IN FRAME F-Main /* Ir a Rotulos del Cliente ZEBRA */
DO:
  IF AVAILABLE chktareas THEN DO:


      IF  tt-chktareas.tcodclie = "20131376503" THEN DO:
            /* Senati */
            
            /* RUN dist/d-rotulo-bcp-extraordinario.r(INPUT tt-chktareas.tcoddoc, INPUT tt-chktareas.tnrodoc).*/
            
      END.
      ELSE DO:

          DEFINE VAR hProc AS HANDLE NO-UNDO.         /* Handle Libreria */

          RUN logis/logis-library.r PERSISTENT SET hProc.

          IF tt-chktareas.tcodclie = "20100047218" THEN DO:
              /* BCP */              
              RUN imprimir-rotulos IN hProc (INPUT chktareas.coddiv, 
                                             INPUT chktareas.coddoc, 
                                             INPUT chktareas.nroped,
                                             INPUT TABLE tmp-w-report,
                                             INPUT "ROTULOS BCP ZEBRA").               
          END.

          IF tt-chktareas.tcodclie = "20382036655" THEN DO:
              /* MI BANCO */
              RUN imprimir-rotulos IN hProc (INPUT chktareas.coddiv, 
                                             INPUT chktareas.coddoc, 
                                             INPUT chktareas.nroped,
                                             INPUT TABLE tmp-w-report,
                                             INPUT "ROTULOS MI BANCO ZEBRA"). 
          END.


          DELETE PROCEDURE hProc.                     /* Release Libreria */

      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-35
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-35 W-Win
ON CHOOSE OF BUTTON-35 IN FRAME F-Main /* Packinng Consolidado */
DO:
  
    ASSIGN toggle-packing-zebra.

    x-packing-consolidado = YES.

    RUN packing-consolidado(INPUT chktareas.coddoc, INPUT chktareas.nroped).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-37
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-37 W-Win
ON CHOOSE OF BUTTON-37 IN FRAME F-Main /* Rotulos despacho */
DO:

  /*
  RUN carga-info-rotulo.
  RUN imprime-rotulo-zebra.
  */

    IF NOT AVAILABLE chktareas THEN DO:
        RETURN.
    END.


    RUN carga-rotulos.

    DEFINE VAR hProc AS HANDLE NO-UNDO.         /* Handle Libreria */
    
    RUN logis/logis-library.r PERSISTENT SET hProc.
    
    /* Procedimientos */
    RUN imprimir-rotulos IN hProc (INPUT chktareas.coddiv, 
                                   INPUT chktareas.coddoc, 
                                   INPUT chktareas.nroped,
                                   INPUT TABLE rr-w-report,
                                   INPUT "ROTULOS DESPACHO"). 
    
    
    DELETE PROCEDURE hProc.                     /* Release Libreria */


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-38
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-38 W-Win
ON CHOOSE OF BUTTON-38 IN FRAME F-Main /* Packing List ZEBRA */
DO:
  
    x-packing-list-destino = "PACKING LIST ZEBRA".
  IF AVAILABLE chktareas THEN DO:
      RUN packing-list(INPUT chktareas.coddoc, INPUT chktareas.nroped). /* HPK */
  END.
  

/*RUN test-pl.*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Imprimir Rotulos en la ZEBRA */
DO:

  /*
  RUN carga-info-rotulo.
  RUN imprime-rotulo-zebra.
  */

    IF NOT AVAILABLE chktareas THEN DO:
        RETURN.
    END.


    RUN carga-rotulos.

    DEFINE VAR hProc AS HANDLE NO-UNDO.         /* Handle Libreria */
    
    RUN logis/logis-library.r PERSISTENT SET hProc.
    
    /* Procedimientos */
    RUN imprimir-rotulos IN hProc (INPUT chktareas.coddiv, 
                                   INPUT chktareas.coddoc, 
                                   INPUT chktareas.nroped,
                                   INPUT TABLE rr-w-report,
                                   INPUT "ORDENES TERMINADAS"). 
    
    
    DELETE PROCEDURE hProc.                     /* Release Libreria */


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Imprimir Rotulo MASTER */
DO:
  RUN imprime-rotulo-master.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Packing List */
DO:
    x-packing-list-destino = "PACKING LIST TINTA".
  IF AVAILABLE chktareas THEN DO:
      RUN packing-list(INPUT chktareas.coddoc, INPUT chktareas.nroped).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 W-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* Ir a Rotulos del Cliente */
DO:
  IF AVAILABLE chktareas THEN DO:


      IF  tt-chktareas.tcodclie = "20131376503" THEN DO:
            /* Senati */
            
            /*RUN packing-list(INPUT chktareas.coddoc, INPUT chktareas.nroped).*/
            RUN dist/d-rotulo-bcp-extraordinario.r(INPUT tt-chktareas.tcoddoc, INPUT tt-chktareas.tnrodoc).
            
      END.
      ELSE DO:

          DEFINE VAR hProc AS HANDLE NO-UNDO.         /* Handle Libreria */

          RUN logis/logis-library.r PERSISTENT SET hProc.

          IF tt-chktareas.tcodclie = "20100047218" THEN DO:
              /* BCP */
              RUN imprimir-rotulos IN hProc (INPUT chktareas.coddiv, 
                                             INPUT chktareas.coddoc, 
                                             INPUT chktareas.nroped,
                                             INPUT TABLE tmp-w-report,
                                             INPUT "ROTULOS BCP"). 
          END.

          IF tt-chktareas.tcodclie = "20382036655" THEN DO:
              /* MI BANCO */
              RUN imprimir-rotulos IN hProc (INPUT chktareas.coddiv, 
                                             INPUT chktareas.coddoc, 
                                             INPUT chktareas.nroped,
                                             INPUT TABLE tmp-w-report,
                                             INPUT "ROTULOS MI BANCO"). 
          END.


          DELETE PROCEDURE hProc.                     /* Release Libreria */

      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 W-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* Marcar todos */
DO:
  FOR EACH tmp-w-report :
      ASSIGN tmp-w-report.campo-l[1] = YES.
  END.

  {&open-query-browse-18}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-9 W-Win
ON CHOOSE OF BUTTON-9 IN FRAME F-Main /* Desmarcar todo */
DO:
    FOR EACH tmp-w-report :
        ASSIGN tmp-w-report.campo-l[1] = NO.
    END.
  
    {&open-query-browse-18}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

ON ROW-DISPLAY OF browse-14
DO:
    
    
END.

/* RETRIEVEEEEEEEE */
ON FIND OF chktareas
DO:

    DEFINE VAR x-nro-phr AS CHAR.
    DEFINE VAR x-cod-cliente AS CHAR.

    x-nro-phr = fill-in-phr:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    IF NOT (TRUE <> (x-nro-phr > "")) THEN DO:
        FIND FIRST x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND
                                    x-vtacdocu.codped = chktareas.CodDOc AND
                                    x-vtacdocu.nroped = chktareas.nroped NO-LOCK NO-ERROR.
        IF NOT AVAILABLE x-vtacdocu OR x-vtacdocu.nroori <> x-nro-phr THEN DO:
            RETURN ERROR.
        END.
    END.

    /* Filtro por O/D u OTR */
    IF FILL-IN-Orden > '' AND LOOKUP(COMBO-BOX-CodDoc, 'O/D,OTR') > 0 AND chktareas.CodDoc = 'HPK' THEN DO:
        FIND FIRST x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND
            x-vtacdocu.codped = chktareas.CodDOc AND
            x-vtacdocu.nroped = chktareas.nroped NO-LOCK NO-ERROR.
        IF NOT AVAILABLE x-vtacdocu THEN RETURN ERROR.
        IF NOT (x-vtacdocu.codref = COMBO-BOX-CodDoc AND x-vtacdocu.nroref = FILL-IN-Orden) THEN RETURN ERROR.
    END.

    DEFINE VAR x-dni AS CHAR.
    DEFINE VAR x-origen AS CHAR.
    DEFINE VAR x-retval AS CHAR.
    DEFINE VAR x-coddoc-nrodoc AS CHAR.    

    RUN ordenes-involucrados(INPUT chktareas.CodDOc, INPUT chktareas.nroped).   /* HPK */

    /*CREATE tt-chktareas.*/
    FIND FIRST tt-chktareas WHERE tt-chktareas.codcia = chktareas.codcia AND
                                    tt-chktareas.coddoc = chktareas.coddoc AND
                                    tt-chktareas.nroped = chktareas.nroped NO-LOCK NO-ERROR.
    IF NOT AVAILABLE tt-chktareas THEN DO:
        CREATE tt-chktareas.
        BUFFER-COPY chktareas TO tt-chktareas.

        IF chktareas.CodDOc = 'HPK' THEN DO:

            FIND FIRST x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND
                                            x-vtacdocu.codped = chktareas.CodDOc AND
                                            x-vtacdocu.nroped = chktareas.nroped NO-LOCK NO-ERROR.
            IF AVAILABLE x-vtacdocu THEN DO:
                ASSIGN tt-chktareas.tcoddoc = x-vtacdocu.codref
                        tt-chktareas.tnrodoc = x-vtacdocu.nroref
                        tt-chktareas.tnro-phr = x-vtacdocu.nroori.
            END.
        END.

        /* Bultos */    
        x-col-bultos = 0.
        /*
        FOR EACH ttOrdenes :
            FIND FIRST ccbcbult WHERE ccbcbult.codcia = s-codcia AND
                                        ccbcbult.coddoc = ttOrdenes.tCodDoc AND
                                        ccbcbult.nrodoc = ttOrdenes.tnroDoc NO-LOCK NO-ERROR.
            IF AVAILABLE ccbcbult THEN DO:
                x-col-bultos = x-col-bultos + ccbcbult.bultos.
            END.
        END.
        */
    
        x-coddoc-nrodoc = chktareas.CodDOc + "-" + chktareas.nroped.
    
        FOR EACH ttOrdenes :
            FOR EACH x-ControlOD WHERE x-ControlOD.codcia = s-codcia AND 
                                        x-ControlOD.coddoc = ttOrdenes.tCodDoc AND
                                        x-ControlOD.nrodoc = ttOrdenes.tnroDoc AND
                                        x-controlOD.nroetq BEGINS x-coddoc-nrodoc NO-LOCK:
                x-col-bultos =  x-col-bultos + 1.
                /*
                x-es-valido = YES.
                IF x-es-valido = YES THEN x-retval = x-retval + 1.
                */
            END.
        END.
    
        ASSIGN tt-chktareas.tbultos = x-col-bultos.
    
        /* Chequeador */
        x-col-chequeador = "".
        x-retval = "".
    
        IF chktareas.CodDOc = 'HPK' THEN DO:
            
            FIND FIRST x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND
                                            x-vtacdocu.codped = chktareas.CodDOc AND
                                            x-vtacdocu.nroped = chktareas.nroped NO-LOCK NO-ERROR.
            IF AVAILABLE x-vtacdocu THEN DO:
                IF NOT (TRUE <> (x-vtacdocu.libre_c04 > "")) THEN DO:
                    x-dni = ENTRY(1,x-vtacdocu.libre_c04,"|").
                    RUN logis/p-busca-por-dni.r(INPUT x-dni, OUTPUT x-retval, OUTPUT x-origen).
                END.            
            END.
        END.
        ELSE DO:        
            FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND 
                                            x-faccpedi.coddoc = chktareas.CodDOc AND 
                                            x-faccpedi.nroped = chktareas.nroped NO-LOCK NO-ERROR.
            IF AVAILABLE x-faccpedi THEN DO:
                IF NOT (TRUE <> (x-faccpedi.usrchq > "")) THEN DO:
                    x-dni = x-faccpedi.usrchq.
                    RUN logis/p-busca-por-dni.r(INPUT x-dni, OUTPUT x-retval, OUTPUT x-origen).
                END.            
            END.
        END.
    
        IF x-retval = "" THEN DO:
            /* buscarlo si existe en la maestra de personal */
            FIND FIRST pl-pers WHERE  pl-pers.codper = x-dni NO-LOCK NO-ERROR.
            IF  AVAILABLE pl-pers THEN DO:
                x-retval = pl-pers.patper + " " + pl-pers.matper + " " + pl-pers.nomper.
            END.
        END.
        
        x-col-chequeador = x-retval.
        ASSIGN tt-chktareas.tchequeador = x-col-chequeador.
    
        /* Es CrossDocking */
        x-es-crossdocking-col = "NO".
    
        FIND FIRST x-ChkControl WHERE x-ChkControl.codcia = s-codcia AND 
                                    x-ChkControl.coddiv = s-coddiv AND 
                                    x-ChkControl.coddoc = chktareas.Coddoc AND 
                                    x-ChkControl.nroped = chktareas.nroped NO-LOCK NO-ERROR.
        IF AVAILABLE x-ChkControl THEN DO:
          IF x-ChkControl.crossdocking THEN x-es-crossdocking-col = 'SI'.
        END.
    
         ASSIGN tt-chktareas.tcrossdocking = x-es-crossdocking-col.
    
        /* Cliente */
         x-cliente-col = "".
    
         IF chktareas.CodDoc = 'HPK' THEN DO:
    
             FIND FIRST x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND
                                             x-vtacdocu.codped = chktareas.CodDOc AND
                                             x-vtacdocu.nroped = chktareas.nroped NO-LOCK NO-ERROR.
             IF AVAILABL x-vtacdocu THEN DO:
                 x-cliente-col = x-vtacdocu.nomcli.
                 x-cod-cliente = x-vtacdocu.codcli.
             END.
                 
         END.
         ELSE DO:
    
    
             FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                         x-faccpedi.coddoc = chktareas.Coddoc AND
                                         x-faccpedi.nroped = chktareas.nroped NO-LOCK NO-ERROR.
             IF AVAILABL x-faccpedi THEN DO:
                 x-cod-cliente = x-faccpedi.codcli.
                 x-cliente-col = x-faccpedi.nomcli.
             END.
                 
         END.
    
         ASSIGN tt-chktareas.tcliente = x-cliente-col
                tt-chktareas.tcodclie = x-cod-cliente.
    END.

    RETURN.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-articulos-packing W-Win 
PROCEDURE carga-articulos-packing :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-coddoc-nrodoc AS CHAR.

IF NOT AVAILABLE chktareas THEN DO:
    RETURN.
END.

EMPTY TEMP-TABLE rr-w-report.

DEFINE VAR x-filer AS INT.

x-bultos-od = 0.

IF x-packing-consolidado = YES THEN DO:
    /* Por impresion A4 es todo la O/D y puede estar en diferente HPK */

    DEFINE VAR x-coddoc AS CHAR.
    DEFINE VAR x-nrodoc AS CHAR.

    FIND FIRST ttOrdenesHPK NO-LOCK NO-ERROR.
    IF AVAILABLE ttOrdenesHPK THEN DO:
        x-coddoc = ttOrdenesHPK.tcodod.        /* O/D */
        x-nrodoc = ttOrdenesHPK.tnrood.  
    END.
    FOR EACH controlOD WHERE controlOD.codcia = s-codcia AND
                                controlOD.coddoc = x-coddoc AND
                                controlOD.nrodoc = x-nrodoc NO-LOCK:

        x-bultos-od = x-bultos-od + 1.  

        FOR EACH logisdchequeo WHERE logisdchequeo.codcia = s-codcia AND
                                        logisdchequeo.etiqueta = controlOD.nroetq NO-LOCK :
            FIND FIRST rr-w-report WHERE /* rr-w-report.campo-c[1] = controlOD.nroetq AND */
                                            rr-w-report.campo-c[2] = logisdchequeo.codmat 
                                            EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE rr-w-report THEN DO:
                CREATE rr-w-report.
                ASSIGN /* rr-w-report.campo-c[1] = controlOD.nroetq */
                        rr-w-report.campo-c[2] = logisdchequeo.codmat.

                x-filer = x-filer + 1.
            END.
            ASSIGN rr-w-report.campo-f[1] = rr-w-report.campo-f[1] + (logisdchequeo.canchk * logisdchequeo.factor).
            RELEASE rr-w-report.

        END.

    END.
    /*
    MESSAGE "x-coddoc " x-coddoc SKIP
            "x-nrodoc " x-nrodoc SKIP
            "bultos " x-bultos-od SKIP
            "x-filer " x-filer.
    */
    
END.
ELSE DO:
    FOR EACH t-tmp-w-report WHERE t-tmp-w-report.campo-l[1] = YES NO-LOCK:
        FOR EACH logisdchequeo WHERE logisdchequeo.codcia = s-codcia AND
                                        logisdchequeo.etiqueta = t-tmp-w-report.campo-c[3] NO-LOCK :

            FIND FIRST rr-w-report WHERE rr-w-report.campo-c[1] = t-tmp-w-report.campo-c[3] AND
                                            rr-w-report.campo-c[2] = logisdchequeo.codmat 
                                            EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE rr-w-report THEN DO:
                CREATE rr-w-report.
                ASSIGN rr-w-report.campo-c[1] = t-tmp-w-report.campo-c[3]
                        rr-w-report.campo-c[2] = logisdchequeo.codmat.
            END.
            ASSIGN rr-w-report.campo-f[1] = rr-w-report.campo-f[1] + (logisdchequeo.canchk * logisdchequeo.factor).
            RELEASE rr-w-report.
        END.
    END.
END.

/* 
/* Los articulos de los bultos */
IF toggle-packing-zebra = YES THEN DO:
    FOR EACH t-tmp-w-report WHERE t-tmp-w-report.campo-l[1] = YES NO-LOCK:
        FOR EACH logisdchequeo WHERE logisdchequeo.codcia = s-codcia AND
                                        logisdchequeo.etiqueta = t-tmp-w-report.campo-c[3] NO-LOCK :

            FIND FIRST rr-w-report WHERE rr-w-report.campo-c[1] = t-tmp-w-report.campo-c[3] AND
                                            rr-w-report.campo-c[2] = logisdchequeo.codmat 
                                            EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE rr-w-report THEN DO:
                CREATE rr-w-report.
                ASSIGN rr-w-report.campo-c[1] = t-tmp-w-report.campo-c[3]
                        rr-w-report.campo-c[2] = logisdchequeo.codmat.
            END.
            ASSIGN rr-w-report.campo-f[1] = rr-w-report.campo-f[1] + (logisdchequeo.canchk * logisdchequeo.factor).
            RELEASE rr-w-report.
        END.
    END.
END.
ELSE DO:

    /* Por impresion A4 es todo la O/D y puede estar en diferente HPK */

    DEFINE VAR x-coddoc AS CHAR.
    DEFINE VAR x-nrodoc AS CHAR.

    FIND FIRST ttOrdenesHPK NO-LOCK NO-ERROR.
    IF AVAILABLE ttOrdenesHPK THEN DO:
        x-coddoc = ttOrdenesHPK.tcodod.        /* O/D */
        x-nrodoc = ttOrdenesHPK.tnrood.  
    END.
    FOR EACH controlOD WHERE controlOD.codcia = s-codcia AND
                                controlOD.coddoc = x-coddoc AND
                                controlOD.nrodoc = x-nrodoc NO-LOCK:

        x-bultos-od = x-bultos-od + 1.  

        FOR EACH logisdchequeo WHERE logisdchequeo.codcia = s-codcia AND
                                        logisdchequeo.etiqueta = controlOD.nroetq NO-LOCK :
            FIND FIRST rr-w-report WHERE /* rr-w-report.campo-c[1] = controlOD.nroetq AND */
                                            rr-w-report.campo-c[2] = logisdchequeo.codmat 
                                            EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE rr-w-report THEN DO:
                CREATE rr-w-report.
                ASSIGN /* rr-w-report.campo-c[1] = controlOD.nroetq */
                        rr-w-report.campo-c[2] = logisdchequeo.codmat.
            END.
            ASSIGN rr-w-report.campo-f[1] = rr-w-report.campo-f[1] + (logisdchequeo.canchk * logisdchequeo.factor).
            RELEASE rr-w-report.

        END.

    END.
END.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-info-rotulo W-Win 
PROCEDURE carga-info-rotulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-coddoc-nrodoc AS CHAR.

IF NOT AVAILABLE chktareas THEN DO:
  RETURN.
END.

x-coddoc-nrodoc = chktareas.coddoc + "-" + chktareas.nroped.

DEFINE VAR dPeso        AS DECIMAL   NO-UNDO.
DEFINE VAR cNomChq      AS CHARACTER NO-UNDO.
DEFINE VAR cDir         AS CHARACTER NO-UNDO.
DEFINE VAR cSede        AS CHARACTER NO-UNDO.
DEFINE VAR dFactor      AS DECIMAL   NO-UNDO.

DEFINE VAR lCodRef AS CHAR.
DEFINE VAR lNroRef AS CHAR.
DEFINE VAR lCodDoc AS CHAR.
DEFINE VAR lNroDoc AS CHAR.

DEFINE VAR lCodRef2 AS CHAR.
DEFINE VAR lNroRef2 AS CHAR.

DEFINE VAR x-almfinal AS CHAR.
DEFINE VAR x-cliente-final AS CHAR.
DEFINE VAR x-cliente-intermedio AS CHAR.
DEFINE VAR x-direccion-final AS CHAR.
DEFINE VAR x-direccion-intermedio AS CHAR.
DEFINE VAR lFiler1 AS CHAR.

DEFINE BUFFER x-almacen FOR almacen.
DEFINE BUFFER x-pedido FOR faccpedi.
DEFINE BUFFER x-cotizacion FOR faccpedi.
DEFINE BUFFER hpk-vtacdocu FOR vtacdocu.

EMPTY TEMP-TABLE rr-w-report.

DEFINE VAR i-nro AS INT.

DEFINE VAR x-total-bultos-orden AS INT.

SESSION:SET-WAIT-STATE("GENERAL").

/*  */
FIND FIRST hpk-vtacdocu WHERE hpk-vtacdocu.codcia = s-codcia AND
                                    hpk-vtacdocu.codped = chktareas.coddoc AND
                                    hpk-vtacdocu.nroped = chktareas.nroped NO-LOCK NO-ERROR.

/* Total bultos  */
/*x-total-bultos-orden = cantidad-bultos(chktareas.coddoc, chktareas.nroped).*/

DEFINE VAR x-es-correcto AS LOG.

FOR EACH tt-w-report WHERE tt-w-report.campo-l[1] = YES 
            BREAK BY tt-w-report.campo-c[1] BY tt-w-report.campo-c[2]:

    IF FIRST-OF(tt-w-report.campo-c[1]) OR FIRST-OF(tt-w-report.campo-c[2]) THEN DO:
        
        x-total-bultos-orden = 0.
        i-nro = 0.
        
        FOR EACH controlOD WHERE controlOD.codcia = s-codcia AND
                                    controlOD.coddoc = tt-w-report.campo-c[1] AND
                                    controlOD.nrodoc = tt-w-report.campo-c[2] NO-LOCK:
            x-es-correcto = YES.
            IF chktareas.coddoc = 'HPK' THEN DO:
                x-es-correcto = NO. 
                IF controlOD.nroetq BEGINS x-coddoc-nrodoc THEN x-es-correcto = YES.
            END.
            IF x-es-correcto = YES THEN x-total-bultos-orden = x-total-bultos-orden + 1.
        END.
        IF x-total-bultos-orden = 0 THEN NEXT.
    END.

    /* Ubico la orden */
    FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia
        AND faccpedi.coddoc = tt-w-report.campo-c[1]
        AND faccpedi.nroped = tt-w-report.campo-c[2]
        NO-LOCK NO-ERROR.

    /*IF NOT AVAILABLE tt-w-report THEN NEXT.*/
    IF NOT AVAILABLE faccpedi THEN NEXT.

    cNomCHq = "".
    lCodDoc = "".
    lNroDoc = "".
    dPeso = 0.      /**ControlOD.PesArt.*/
    lCodRef2 = tt-w-report.campo-c[1].
    lNroRef2 = tt-w-report.campo-c[2].

    x-cliente-final = faccpedi.nomcli.
    x-direccion-final = faccpedi.dircli.
    x-cliente-intermedio = "".
    x-direccion-intermedio = "".

    /* CrossDocking almacen FINAL */
    x-almfinal = "".
    IF faccpedi.crossdocking = YES THEN DO:
        lCodRef2 = faccpedi.codref.
        lNroRef2 = faccpedi.nroref.
        lCodDoc = "(" + faccpedi.coddoc.
        lNroDoc = faccpedi.nroped + ")".

        x-cliente-intermedio = faccpedi.codcli + " " + faccpedi.nomcli.
        x-direccion-intermedio = faccpedi.dircli.

        IF faccpedi.codref = 'R/A' THEN DO:
            FIND FIRST x-almacen WHERE x-almacen.codcia = s-codcia AND 
                                        x-almacen.codalm = faccpedi.almacenxD
                                        NO-LOCK NO-ERROR.
            IF AVAILABLE x-almacen THEN x-cliente-final = TRIM(x-almacen.descripcion).
            IF AVAILABLE x-almacen THEN x-direccion-final = TRIM(x-almacen.diralm).
        END.
    END.

    /* Ic - 02Dic2016, si es OTR verificar si no proviene de una PED (pedido) */
    /* Si viene de un PED, los datos del cliente deben salir del PEDIDO */
    /* Crossdocking */
    IF faccpedi.coddoc = 'OTR' AND faccpedi.codref = 'PED' THEN DO:
        lCodDoc = "(" + tt-w-report.campo-c[1].
        lNroDoc = tt-w-report.campo-c[2] + ")".
        lCodRef = faccpedi.codref.
        lNroRef = faccpedi.nroref.
        RELEASE faccpedi.

        FIND faccpedi WHERE faccpedi.codcia = s-codcia
            AND faccpedi.coddoc = lCodRef
            AND faccpedi.nroped = lNroRef
            NO-LOCK NO-ERROR.
        IF NOT AVAIL faccpedi THEN DO:
            MESSAGE "Pedido de Referencia de la OTR no existe" lCodRef lNroRef
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN "ADM-ERROR".
        END.
        x-cliente-final = "".
        IF faccpedi.CodDoc = 'OTR' THEN x-cliente-final = faccpedi.codcli + " ".
        x-cliente-final = x-cliente-final + faccpedi.nomcli.
        x-direccion-final = faccpedi.dircli.
    END.
    /* Ic - 02Dic2016 - FIN */
    /* Datos Sede de Venta */
    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.  /*faccpedi.coddiv*/
    IF AVAIL gn-divi THEN 
        ASSIGN 
            cDir = INTEGRAL.GN-DIVI.DirDiv
            cSede = GN-DIVI.CodDiv + " " + INTEGRAL.GN-DIVI.DesDiv.
    FIND Almacen WHERE Almacen.codcia = s-codcia
        AND Almacen.codalm = s-CodAlm
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN cDir = Almacen.DirAlm.

    /**/
    lFiler1 = tt-w-report.campo-c[3].
    IF Chktareas.coddoc = 'HPK' THEN DO:
        lFiler1 = REPLACE(lFiler1,"-","").
        lFiler1 = REPLACE(lFiler1," ","").
    END.

    dPEso = fPeso-orden(INPUT tt-w-report.campo-c[1], INPUT tt-w-report.campo-c[2], 
                    INPUT chktareas.coddoc, INPUT chktareas.nroped).

    lCodDoc = Chequeador(INPUT chktareas.coddoc, INPUT chktareas.nroped).

    CREATE rr-w-report.
    ASSIGN         
        i-nro             = i-nro + 1
        rr-w-report.Llave-C  = "01" + faccpedi.nroped
        rr-w-report.Campo-C[1] = faccpedi.ruc
        rr-w-report.Campo-C[2] = x-cliente-final   
        rr-w-report.Campo-C[3] = x-direccion-final  
        rr-w-report.Campo-C[4] = cNomChq
        rr-w-report.Campo-D[1] = faccpedi.fchped
        rr-w-report.Campo-C[5] = STRING(x-total-bultos-orden)
        rr-w-report.Campo-F[1] = dPeso     /* Peso */
        rr-w-report.Campo-C[7] = lCodRef2 + "-" + lNroRef2 /*faccpedi.nroped*/
        rr-w-report.Campo-I[1] = i-nro
        rr-w-report.Campo-C[8] = cDir
        rr-w-report.Campo-C[9] = cSede
        rr-w-report.Campo-C[10] = lFiler1   /*tt-w-report.campo-c[3] /* ControlOD.NroEtq*/*/
        rr-w-report.Campo-D[2] = faccpedi.fchent
        rr-w-report.campo-c[11] = TRIM(lCodDoc + " " + lNroDoc)
        rr-w-report.campo-c[12] = x-cliente-intermedio
        rr-w-report.campo-c[13] = ""    /*STRING(pNroBulto)+ "-" + pGraficoRotulo + "-" + STRING(i-nro,"999")*/
        rr-w-report.campo-c[14] = ""
        rr-w-report.campo-c[19] = tt-w-report.campo-c[1]    /* O/D */
        rr-w-report.campo-c[20] = tt-w-report.campo-c[2]    /* Nro */
        .
    
    IF chktareas.coddoc = 'HPK' THEN DO:
        IF faccpedi.crossdocking = NO THEN DO:
            IF AVAILABLE hpk-vtacdocu THEN rr-w-report.campo-c[14] = hpk-vtacdocu.codori + " " + hpk-vtacdocu.nroori.
        END.       
    END.
    
    /* Ic - 15Feb2018, jalar la Nro de Orden de Iversa, ListaExpree */
    IF s-coddiv = '00506' THEN DO:
        /* Busco el Pedido */
        FIND FIRST x-pedido WHERE x-pedido.codcia = s-codcia AND 
                                    x-pedido.coddoc = faccpedi.codref AND 
                                    x-pedido.nroped = faccpedi.nroref NO-LOCK NO-ERROR.
        IF AVAILABLE x-pedido THEN DO:
            /* Busco la Cotizacion */
            FIND FIRST x-cotizacion WHERE x-cotizacion.codcia = s-codcia AND 
                                        x-cotizacion.coddoc = x-pedido.codref AND 
                                        x-cotizacion.nroped = x-pedido.nroref NO-LOCK NO-ERROR.
            IF AVAILABLE x-cotizacion THEN DO:
                ASSIGN w-report.campo-c[12] = "PEDIDO WEB :" + TRIM(x-cotizacion.nroref)
                        rr-w-report.campo-c[14] = "".
            END.
        END.
    END.

END.

SESSION:SET-WAIT-STATE("").

END PROCEDURE.



/*
DEFINE VAR dPeso        AS DECIMAL   NO-UNDO.
DEFINE VAR cNomChq      AS CHARACTER NO-UNDO.
DEFINE VAR cDir         AS CHARACTER NO-UNDO.
DEFINE VAR cSede        AS CHARACTER NO-UNDO.
DEFINE VAR dFactor      AS DECIMAL   NO-UNDO.

DEFINE VAR lCodRef AS CHAR.
DEFINE VAR lNroRef AS CHAR.
DEFINE VAR lCodDoc AS CHAR.
DEFINE VAR lNroDoc AS CHAR.

DEFINE VAR lCodRef2 AS CHAR.
DEFINE VAR lNroRef2 AS CHAR.

DEFINE VAR x-almfinal AS CHAR.
DEFINE VAR x-cliente-final AS CHAR.
DEFINE VAR x-cliente-intermedio AS CHAR.
DEFINE VAR x-direccion-final AS CHAR.
DEFINE VAR x-direccion-intermedio AS CHAR.

DEFINE BUFFER x-almacen FOR almacen.
DEFINE BUFFER x-pedido FOR faccpedi.
DEFINE BUFFER x-cotizacion FOR faccpedi.
DEFINE BUFFER hpk-vtacdocu FOR vtacdocu.

DEFINE VAR i-nro AS INT.

IF ppCodDoc = 'HPK' THEN DO:
    FIND FIRST hpk-vtacdocu WHERE hpk-vtacdocu.codcia = s-codcia AND
                                    hpk-vtacdocu.codped = ppCodDOc AND 
                                    hpk-vtacdocu.nroped = ppNroDoc NO-LOCK NO-ERROR.
    IF NOT AVAILABLE hpk-vtacdocu THEN DO:
        MESSAGE "Imposible encontrar la HPK".
        RETURN.        
    END.
    pCoddoc = hpk-vtacdocu.codref.  /* O/D */
    pNroDoc = hpk-vtacdocu.nroref.
END.

/* Ubico la orden */
FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia
    AND faccpedi.coddoc = pCodDoc
    AND faccpedi.nroped = pNroDoc
    NO-LOCK NO-ERROR.

IF NOT AVAILABLE faccpedi THEN DO:
    MESSAGE "Imposible encontrar la Orden".
    RETURN.
END.

cNomCHq = "".
lCodDoc = "".
lNroDoc = "".
dPeso = 0.      /**ControlOD.PesArt.*/
lCodRef2 = pCoddoc.
lNroRef2 = pNroDoc.

x-cliente-final = faccpedi.nomcli.
x-direccion-final = faccpedi.dircli.
x-cliente-intermedio = "".
x-direccion-intermedio = "".

/* CrossDocking almacen FINAL */
x-almfinal = "".
IF faccpedi.crossdocking = YES THEN DO:
    lCodRef2 = faccpedi.codref.
    lNroRef2 = faccpedi.nroref.
    lCodDoc = "(" + faccpedi.coddoc.
    lNroDoc = faccpedi.nroped + ")".

    x-cliente-intermedio = faccpedi.codcli + " " + faccpedi.nomcli.
    x-direccion-intermedio = faccpedi.dircli.

    IF faccpedi.codref = 'R/A' THEN DO:
        FIND FIRST x-almacen WHERE x-almacen.codcia = s-codcia AND 
                                    x-almacen.codalm = faccpedi.almacenxD
                                    NO-LOCK NO-ERROR.
        IF AVAILABLE x-almacen THEN x-cliente-final = TRIM(x-almacen.descripcion). /*x-almfinal = TRIM(x-almacen.descripcion).*/
        IF AVAILABLE x-almacen THEN x-direccion-final = TRIM(x-almacen.diralm). /*x-almfinal = TRIM(x-almacen.descripcion).*/
    END.
END.
/* Ic - 02Dic2016, si es OTR verificar si no proviene de una PED (pedido) */
/* Si viene de un PED, los datos del cliente deben salir del PEDIDO */
/* Crossdocking */
IF faccpedi.coddoc = 'OTR' AND faccpedi.codref = 'PED' THEN DO:
    lCodDoc = "(" + pCoddoc.
    lNroDoc = pNrodoc + ")".
    lCodRef = faccpedi.codref.
    lNroRef = faccpedi.nroref.
    RELEASE faccpedi.

    FIND faccpedi WHERE faccpedi.codcia = s-codcia
        AND faccpedi.coddoc = lCodRef
        AND faccpedi.nroped = lNroRef
        NO-LOCK NO-ERROR.
    IF NOT AVAIL faccpedi THEN DO:
        MESSAGE "Pedido de Referencia de la OTR no existe" lCodRef lNroRef
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "ADM-ERROR".
    END.
    x-cliente-final = "".
    IF CcbCBult.CodDoc = 'OTR' THEN x-cliente-final = faccpedi.codcli + " ".
    x-cliente-final = x-cliente-final + faccpedi.nomcli.
    x-direccion-final = faccpedi.dircli.
END.
/* Ic - 02Dic2016 - FIN */

/* Datos Sede de Venta */
FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = faccpedi.coddiv NO-LOCK NO-ERROR.
IF AVAIL gn-divi THEN 
    ASSIGN 
        cDir = INTEGRAL.GN-DIVI.DirDiv
        cSede = GN-DIVI.CodDiv + " " + INTEGRAL.GN-DIVI.DesDiv.
FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = s-CodAlm
    NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN cDir = Almacen.DirAlm.

EMPTY TEMP-TABLE rr-w-report.
i-nro = 0.

/* Rotulos marcados */
FOR EACH tt-w-report WHERE tt-w-report.campo-l[1] = YES :

    /* Peso total del bulto */
    dPeso = peso-total-bulto(tt-w-report.campo-c[1]).

    CREATE rr-w-report.
    ASSIGN         
        i-nro             = i-nro + 1
        rr-w-report.Llave-C  = "01" + faccpedi.nroped
        rr-w-report.Campo-C[1] = faccpedi.ruc
        rr-w-report.Campo-C[2] = x-cliente-final   
        rr-w-report.Campo-C[3] = x-direccion-final  
        rr-w-report.Campo-C[4] = cNomChq
        rr-w-report.Campo-D[1] = faccpedi.fchped
        rr-w-report.Campo-C[5] = '0'    /*STRING(Ccbcbult.bultos,'9999')*/
        rr-w-report.Campo-F[1] = dPeso
        rr-w-report.Campo-C[7] = lCodRef2 + "-" + lNroRef2 /*faccpedi.nroped*/
        rr-w-report.Campo-I[1] = i-nro
        rr-w-report.Campo-C[8] = cDir
        rr-w-report.Campo-C[9] = cSede
        rr-w-report.Campo-C[10] = tt-w-report.campo-c[1] /* ControlOD.NroEtq*/
        rr-w-report.Campo-D[2] = faccpedi.fchent
        rr-w-report.campo-c[11] = TRIM(lCodDoc + " " + lNroDoc)
        rr-w-report.campo-c[12] = x-cliente-intermedio
        rr-w-report.campo-c[13] = STRING(pNroBulto)+ "-" + pGraficoRotulo + "-" + STRING(i-nro,"999")
        rr-w-report.campo-c[14] = ""
        .       
    IF ppCodDoc = 'HPK' THEN DO:
        IF faccpedi.crossdocking = NO THEN DO:
            rr-w-report.campo-c[14] = hpk-vtacdocu.codori + " " + hpk-vtacdocu.nroori.
        END.       
    END.

    /* Ic - 15Feb2018, jalar la Nro de Orden de Iversa, ListaExpree */
    IF s-coddiv = '00506' THEN DO:
        /* Busco el Pedido */
        FIND FIRST x-pedido WHERE x-pedido.codcia = s-codcia AND 
                                    x-pedido.coddoc = faccpedi.codref AND 
                                    x-pedido.nroped = faccpedi.nroref NO-LOCK NO-ERROR.
        IF AVAILABLE x-pedido THEN DO:
            /* Busco la Cotizacion */
            FIND FIRST x-cotizacion WHERE x-cotizacion.codcia = s-codcia AND 
                                        x-cotizacion.coddoc = x-pedido.codref AND 
                                        x-cotizacion.nroped = x-pedido.nroref NO-LOCK NO-ERROR.
            IF AVAILABLE x-cotizacion THEN DO:
                ASSIGN w-report.campo-c[12] = "PEDIDO WEB :" + TRIM(x-cotizacion.nroref)
                        rr-w-report.campo-c[14] = "".
            END.
        END.
    END.
END.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Packing-HPK W-Win 
PROCEDURE Carga-Packing-HPK :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-coddoc-nrodoc AS CHAR.

IF NOT AVAILABLE chktareas THEN DO:
    RETURN.
END.

x-coddoc-nrodoc = chktareas.coddoc + "-" + chktareas.nroped.

cCodEAN = "".

DEFINE VAR x-es-correcto AS LOG.

/* Datos de Cabecera */
DEFINE VAR x-cliente AS CHAR.
DEFINE VAR x-chequeador AS CHAR.
DEFINE VAR x-ubigeo AS CHAR.
DEFINE VAR x-longuitud AS DEC.
DEFINE VAR x-latitud AS DEC.
DEFINE VAR x-dpto AS CHAR.
DEFINE VAR x-prov AS CHAR.
DEFINE VAR x-dist AS CHAR.
DEFINE VAR x-sede AS CHAR.
DEFINE VAR x-Orden_hpk AS CHAR.

x-cliente = cliente(chktareas.coddoc,chktareas.nroped).
x-chequeador = chequeador(chktareas.coddoc,chktareas.nroped).

FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                            x-faccpedi.coddoc = Vtacdocu.Codref AND
                            x-faccpedi.nroped = Vtacdocu.Nroref NO-LOCK NO-ERROR.
IF AVAILABLE x-faccpedi THEN DO:

    RUN logis/p-datos-sede-auxiliar.r (
        x-FacCPedi.Ubigeo[2],   /* ClfAux @CL @PV */
        x-FacCPedi.Ubigeo[3],   /* Auxiliar */
        x-FacCPedi.Ubigeo[1],   /* Sede */
        OUTPUT x-Ubigeo,
        OUTPUT x-Longuitud,
        OUTPUT x-Latitud
        ).

    FIND TabDepto WHERE TabDepto.CodDepto = SUBSTRING(x-Ubigeo,1,2) NO-LOCK NO-ERROR.
    IF AVAILABLE TabDepto THEN DO:
        x-dpto =TabDepto.NomDepto.
        FIND TabProv WHERE TabProv.CodDepto = SUBSTRING(x-Ubigeo,1,2) AND
                            TabProv.CodProv = SUBSTRING(x-Ubigeo,3,2) NO-LOCK NO-ERROR.
        IF AVAILABLE TabProv THEN DO:
            x-prov =TabProv.NomPRov.
            FIND TabDistr WHERE TabDistr.CodDepto = SUBSTRING(x-Ubigeo,1,2) AND
                                TabDistr.CodProv = SUBSTRING(x-Ubigeo,3,2) AND
                                TabDistr.Coddistr = SUBSTRING(x-Ubigeo,5,2) NO-LOCK NO-ERROR.
            IF AVAILABLE TabDistr THEN DO:
                x-dist = TabDistr.NomDistr.
            END.

        END.
    END.        
END.

FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.
IF AVAIL gn-divi THEN DO:
    x-Sede = GN-DIVI.CodDiv + " " + GN-DIVI.DesDiv.
END.

x-cantidad-sku = 0.

FOR EACH logisdchequeo NO-LOCK WHERE logisdchequeo.CodCia = s-CodCia AND
        logisdchequeo.CodDiv = s-CodDiv AND
        logisdchequeo.CodPed = Vtacdocu.CodPed AND  /* O/D, OTR */
        logisdchequeo.NroPed = Vtacdocu.NroPed,
    FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = logisdchequeo.CodCia AND
        Almmmatg.codmat = logisdchequeo.CodMat 
    BREAK BY logisdchequeo.Etiqueta BY logisdchequeo.NroItm:
    IF FIRST-OF(logisdchequeo.Etiqueta) THEN iInt = iInt + 1.     
    RUN Vta\R-CalCodEAN.p (INPUT Almmmatg.CodBrr, OUTPUT cCodEan).

    IF x-packing-list-destino = "PACKING LIST TINTA" THEN DO:
        CREATE w-report.
        ASSIGN
            w-report.Task-No    = s-task-no 
            w-report.Llave-I    = iInt
            w-report.Campo-C[1] = Vtacdocu.NroOrd
            w-report.Campo-C[5] = Vtacdocu.CodPed
            w-report.Campo-C[6] = Vtacdocu.NroPed
            w-report.Campo-C[7] = logisdchequeo.CodMat
            w-report.Campo-C[8] = Almmmatg.DesMat
            w-report.Campo-C[9] = cCodEan        
            w-report.Campo-C[10] = Almmmatg.CodBrr 
            w-report.Campo-C[11] = logisdchequeo.Etiqueta
            /* Ic - 22Set2015 */
            w-report.Campo-C[25] = TRIM(Vtacdocu.codcli) + " " + Vtacdocu.nomcli
            /* Ic - 22Set2015 */
            w-report.Campo-I[1] = iInt
            w-report.Campo-I[2] = 1
            w-report.Campo-F[2] = logisdchequeo.CanPed
            w-report.Campo-F[3] = ROUND(logisdchequeo.CanPed * Almmmatg.PesMat, 2)
            w-report.Campo-I[3] = logisdchequeo.CanPed
            w-report.Campo-I[4] = s-codcia.
    END.
    ELSE DO:

        FIND FIRST tt-w-report WHERE tt-w-report.campo-c[3] = logisdchequeo.etiqueta AND 
                                    tt-w-report.campo-l[1] = YES NO-LOCK NO-ERROR.
        IF AVAILABLE tt-w-report THEN DO:
            s-task-no = 9999.
            x-Orden_hpk = logisdchequeo.etiqueta. /*vtacdocu.NroPed + logisdchequeo.NroPed*/
            FIND FIRST tt-w-report-zebra WHERE tt-w-report-zebra.task-no = s-task-no AND 
                tt-w-report-zebra.llave-c = x-Orden_hpk AND
                tt-w-report-zebra.Campo-C[1] = logisdchequeo.CodMat EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE tt-w-report-zebra THEN DO:
                CREATE tt-w-report-zebra.
                ASSIGN tt-w-report-zebra.Task-No    = s-task-no 
                tt-w-report-zebra.Llave-c    = x-Orden_hpk
                tt-w-report-zebra.Campo-C[1] = logisdchequeo.CodMat
                tt-w-report-zebra.Campo-C[2] = vtacdocu.CodRef /* O/D OTR */
                tt-w-report-zebra.Campo-C[3] = vtacdocu.NroRef
                tt-w-report-zebra.Campo-C[4] = x-sede
                tt-w-report-zebra.Campo-C[5] = x-cliente
                tt-w-report-zebra.Campo-C[6] = x-dpto
                tt-w-report-zebra.Campo-C[7] = x-prov
                tt-w-report-zebra.Campo-C[8] = x-dist
                tt-w-report-zebra.Campo-C[9] = Almmmatg.DesMat
                /*tt-w-report-zebra.Campo-C[10] = Almmmatg.DesMar*/
                tt-w-report-zebra.Campo-C[10] = logisdchequeo.CodMat
                tt-w-report-zebra.Campo-C[11] = logisdchequeo.NroPed  /* No HPK */
                tt-w-report-zebra.Campo-C[12] = x-chequeador
                .
                x-cantidad-sku = x-cantidad-sku + 1.
            END.
                ASSIGN tt-w-report-zebra.Campo-i[1] = tt-w-report-zebra.Campo-i[1] + (logisdchequeo.CanChk * logisdchequeo.factor)
                tt-w-report-zebra.Campo-f[1] = tt-w-report-zebra.Campo-f[1] + ROUND((logisdchequeo.CanChk * logisdchequeo.factor) * Almmmatg.PesMat, 2)
                .
        END.
    END.

END.

END PROCEDURE.

/*
            CREATE tt-w-report.
                ASSIGN tt-w-report.campo-c[1] = controlOD.coddoc
                        tt-w-report.campo-c[2] = controlOD.nrodoc
                        tt-w-report.campo-c[3] = controlOD.nroetq
                        tt-w-report.campo-c[4] = controlOD.nomcli
                        tt-w-report.campo-c[5] = controlOD.codcli
                        tt-w-report.campo-f[1] = controlOD.pesart
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-packing-od W-Win 
PROCEDURE carga-packing-od :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-coddoc-nrodoc AS CHAR.

IF NOT AVAILABLE chktareas THEN DO:
    RETURN.
END.

x-coddoc-nrodoc = chktareas.coddoc + "-" + chktareas.nroped.

cCodEAN = "".

DEFINE VAR x-es-correcto AS LOG.

FOR EACH Vtaddocu NO-LOCK WHERE VtaDDocu.CodCia =  CcbCBult.CodCia
    AND VtaDDocu.CodDiv = s-CodDiv
    AND VtaDDocu.CodPed = CcbCBult.CodDoc
    AND VtaDDocu.NroPed = CcbCBult.NroDoc
    BREAK BY VtaDDocu.Libre_c01 BY VtaDDocu.NroItm:
    FIND FIRST almmmatg OF vtaddocu NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almmmatg THEN DO:
        NEXT.
    END.
    x-es-correcto = YES.
    IF chktareas.coddoc = 'HPK' THEN DO:
        x-es-correcto = NO. 
        IF VtaDDocu.Libre_c01 BEGINS x-coddoc-nrodoc THEN x-es-correcto = YES.
    END.
    IF x-es-correcto = NO THEN NEXT.
    IF FIRST-OF(VtaDDocu.Libre_c01) THEN iInt = iInt + 1.     
    RUN Vta\R-CalCodEAN.p (INPUT Almmmatg.CodBrr, OUTPUT cCodEan).
    CREATE w-report.
    ASSIGN
        w-report.Task-No    = s-task-no 
        w-report.Llave-I    = iInt
        w-report.Campo-C[1] = CcbCBult.OrdCmp
        w-report.Campo-C[5] = CcbCBult.CodDoc
        w-report.Campo-C[6] = CcbCBult.NroDoc
        w-report.Campo-C[7] = Vtaddocu.CodMat
        w-report.Campo-C[8] = Almmmatg.DesMat
        w-report.Campo-C[9] = cCodEan        
        w-report.Campo-C[10] = Almmmatg.CodBrr 
        w-report.Campo-C[11] = VtaDDocu.Libre_c01
        /* Ic - 22Set2015 */
        w-report.Campo-C[25] = trim(CcbCBult.codcli) + " " + CcbCBult.nomcli
        /* Ic - 22Set2015 */
        w-report.Campo-I[1] = iInt
        w-report.Campo-I[2] = CcbCBult.Bultos
        w-report.Campo-F[2] = VtaDDocu.CanPed
        w-report.Campo-F[3] = VtaDDocu.PesMat
        w-report.Campo-I[3] = VtaDDocu.CanPed
        w-report.Campo-I[4] = s-codcia.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-rotulos W-Win 
PROCEDURE carga-rotulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE rr-w-report.

FOR EACH tt-w-report WHERE tt-w-report.campo-l[1] = YES:
    CREATE rr-w-report.
    ASSIGN rr-w-report.campo-c[1] = tt-w-report.campo-c[1]    /* O/D */
            rr-w-report.campo-c[2] = tt-w-report.campo-c[2]    /* Nro */
            rr-w-report.campo-c[3] = tt-w-report.campo-c[3]
            rr-w-report.campo-c[4] = tt-w-report.campo-c[4].
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
  DISPLAY FILL-IN-codtrab FILL-IN-phr FILL-IN-hpk FILL-IN-desde FILL-IN-hasta 
          COMBO-BOX-CodDoc FILL-IN-Orden TOGGLE-packing-zebra 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-14 BROWSE-18 FILL-IN-codtrab FILL-IN-phr FILL-IN-hpk 
         FILL-IN-desde FILL-IN-hasta COMBO-BOX-CodDoc FILL-IN-Orden BUTTON-3 
         BUTTON-35 TOGGLE-packing-zebra BUTTON-6 BUTTON-1 BUTTON-2 BROWSE-16 
         BUTTON-7 BUTTON-8 BUTTON-9 BUTTON-10 BUTTON-11 BUTTON-34 BUTTON-37 
         BUTTON-38 RECT-4 RECT-5 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime-rotulo-master W-Win 
PROCEDURE imprime-rotulo-master :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE chktareas THEN RETURN.

DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-nrodoc AS CHAR.
DEFINE VAR x-filer AS CHAR.

x-phr-esta-cerrada = YES.

/*

Validacion quedo desactivada x Max Ramos, 23/01/2019 : 11:35am

IF chktareas.coddoc = 'HPK' THEN DO:
    DEFINE VAR x-cod-phr AS CHAR.
    DEFINE VAR x-nro-phr AS CHAR.
    DEFINE VAR x-retval AS CHAR INIT "OK".

    FIND FIRST vtacdocu WHERE vtacdocu.codcia = s-codcia AND 
                                vtacdocu.codped = chktareas.coddoc AND
                                vtacdocu.nroped = chktareas.nroped NO-LOCK NO-ERROR.
    IF AVAILABLE vtacdocu THEN DO:
        RUN verificar-hpr-cerrada(INPUT vtacdocu.codori, INPUT vtacdocu.nroori, OUTPUT x-retval).
    END.
    IF x-retval <> "OK" THEN DO:
        
        MESSAGE "La PHR no esta cerrada, imposible imprimir rotulo MASTER" VIEW-AS ALERT-BOX INFORMATION.
        RETURN.
        /*
        MESSAGE "La PHR no esta cerrada, imposible imprimir rotulo MASTER" SKIP
                'Continuamos con la impresion ?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta2 AS LOG.
        IF rpta2 = NO THEN RETURN NO-APPLY.
        */
        x-phr-esta-cerrada = NO.
    END.
END.
*/

IF chktareas.coddoc = 'HPK' THEN DO:
    
    FIND FIRST vtacdocu WHERE vtacdocu.codcia = s-codcia AND
                                vtacdocu.codped = chktareas.coddoc AND
                                vtacdocu.nroped = chktareas.nroped NO-LOCK NO-ERROR.
    IF AVAILABLE vtacdocu THEN DO:
        x-coddoc = vtacdocu.codref.
        x-nrodoc = vtacdocu.nroref.     /* O/D */
        x-phr-esta-cerrada = YES.

        FOR EACH vtacdocu WHERE vtacdocu.codcia = s-codcia AND
                                    vtacdocu.codped = 'HPK' AND
                                    vtacdocu.codref = x-coddoc AND
                                    vtacdocu.nroref = x-nrodoc AND
                                    vtacdocu.flgest <> "A" NO-LOCK:
            IF LOOKUP(vtacdocu.flgsit, 'PC,C') = 0 THEN DO:
                x-phr-esta-cerrada = NO.
                x-filer = vtacdocu.nroped.
            END.
                
        END.
        /* Tío CheChar, aún siguen los problema 8-(  */
        IF x-phr-esta-cerrada = NO THEN DO:
            MESSAGE "La " + x-coddoc + "-" + x-nrodoc + " aun tiene la " 
                    "HPK " + x-filer + " pendiente por Chequear"
                VIEW-AS ALERT-BOX INFORMATION.
            RETURN.
        END.
    END.
END.

EMPTY TEMP-TABLE rr-w-report.

DEFINE BUFFER x-faccpedi FOR faccpedi.

FOR EACH rr-w-report NO-LOCK WHERE rr-w-report.campo-l[1] = YES
    BREAK BY rr-w-report.campo-c[19] BY rr-w-report.campo-c[20]:
    IF FIRST-OF(rr-w-report.campo-c[19]) OR FIRST-OF(rr-w-report.campo-c[20]) THEN DO:
        /* Verificar si las Ordenes estan Cierre Chequeo o pase a distribucion */
        FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                        x-faccpedi.coddoc = rr-w-report.campo-c[19] AND
                                        x-faccpedi.nroped = rr-w-report.campo-c[20] AND
                                        (x-faccpedi.flgsit = 'PC' OR x-faccpedi.flgsit = 'C')
                                        NO-LOCK NO-ERROR.
        IF AVAILABLE x-faccpedi THEN DO:
            CREATE ttOrdenes.
                ASSIGN ttOrdenes.tcoddoc = rr-w-report.campo-c[19]
                        ttOrdenes.tnrodoc = rr-w-report.campo-c[20].
        END.
    END.
END.

FIND FIRST ttOrdenes NO-ERROR.
IF AVAILABLE ttOrdenes THEN DO:

    DEFINE VAR rpta AS LOG.

    SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
    IF rpta = NO THEN RETURN.
END.
ELSE DO:
    MESSAGE "Seleccione las Ordenes a Imprimir, por favor" VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

/* Copias */
DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fill-in-copias.
END.
DEFINE VAR x-copia AS INT.

REPEAT x-copia = 1 TO fill-in-copias :
    FOR EACH ttOrdenes:
          /* Imprimir Rotulo Master */
          RUN dist/p-imprime-rotulo-master.r(INPUT -1,
                                             INPUT "",
                                             INPUT ttOrdenes.tCoddoc,
                                              INPUT ttOrdenes.tnrodoc).
    END.
END.


END PROCEDURE.
/*
DEFINE TEMP-TABLE ttOrdenes
    FIELDS  tcoddoc     AS  CHAR    FORMAT  'x(5)'
    FIELDS  tnrodoc     AS  CHAR    FORMAT  'x(15)'
.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime-rotulo-zebra W-Win 
PROCEDURE imprime-rotulo-zebra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND FIRST rr-w-report NO-LOCK NO-ERROR.
IF NOT AVAILABLE rr-w-report THEN DO:
    RETURN.
END.

DEFINE VAR lDireccion1 AS CHAR.
DEFINE VAR lDireccion2 AS CHAR.
DEFINE VAR lDirPart1 AS CHAR.
DEFINE VAR lDirPart2 AS CHAR.
DEFINE VAR lbarra AS CHAR.
DEFINE VAR lSede AS CHAR.
DEFINE VAR lRuc AS CHAR.
DEFINE VAR lpedido AS CHAR.
DEFINE VAR lCliente AS CHAR.
DEFINE VAR lChequeador AS CHAR.
DEFINE VAR lFecha AS DATE.
DEFINE VAR lFechaEnt AS DATE.
DEFINE VAR lEtiqueta AS CHAR.
DEFINE VAR lpeso AS DEC.
DEFINE VAR lBultos AS CHAR.
DEFINE VAR lFiler AS CHAR.
DEFINE VAR lRefOtr AS CHAR.
DEFINE VAR x-almfinal AS CHAR.

DEFINE VAR rpta AS LOG.

DEFINE VAR x-Bulto AS CHAR.


SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
IF rpta = NO THEN RETURN.

OUTPUT STREAM REPORTE TO PRINTER.

/* ---------------------------------------- */

/*
DEFINE VAR x-file-zpl AS CHAR.

x-file-zpl = SESSION:TEMP-DIRECTORY + REPLACE("HPK","/","") + "-" + "PRUEBA" + ".txt".

OUTPUT STREAM REPORTE TO VALUE(x-file-zpl).
*/

FOR EACH rr-w-report WHERE NO-LOCK BREAK BY rr-w-report.campo-c[19] BY rr-w-report.campo-c[20]:

    /* Los valores */
    lDireccion1 = rr-w-report.campo-c[8].
    lSede = rr-w-report.campo-c[9].
    lRuc = rr-w-report.campo-c[1].
    lPedido = rr-w-report.campo-c[7].
    lCliente = rr-w-report.campo-c[2].
    lDireccion2 = rr-w-report.campo-c[3].
    lChequeador = rr-w-report.campo-c[4].
    lFecha = rr-w-report.campo-d[1].
    lFechaEnt = rr-w-report.campo-d[2].
    lEtiqueta = rr-w-report.campo-c[10].
    lPeso = rr-w-report.campo-f[1].
    lBultos = STRING(rr-w-report.campo-i[1]) + " / " + rr-w-report.campo-c[5].   /*TRIM(rr-w-report.campo-c[13])*/
    lBarra = STRING(rr-w-report.llave-c,"99999999999") + STRING(rr-w-report.campo-i[1],"9999").    
    lRefOtr = TRIM(rr-w-report.campo-c[11]).

    /* Ic 08Nov2019, a pedido de Max Ramos */
    lEtiqueta = REPLACE(lEtiqueta,"-","").
    lEtiqueta = REPLACE(lEtiqueta," ","").

    lBarra = lEtiqueta.

    /* Ic - 10Set2018, realmente es el destino Intermedio */
    x-almfinal = TRIM(rr-w-report.campo-c[12]).
    IF s-coddiv <> '00506' THEN DO:
        IF x-almfinal <> "" THEN x-almfinal = "D.INTERMEDIO:" + x-almfinal.
    END.    
    IF rr-w-report.campo-c[14] <> "" THEN DO:
        /* Se imprime el HPR */
        x-almfinal = rr-w-report.campo-c[14].
    END.

    lDireccion2 = TRIM(lDireccion2) + FILL(" ",90).
    lDirPart1 = SUBSTRING(lDireccion2,1,45).
    lDirPart2 = SUBSTRING(lDireccion2,46).

    PUT STREAM REPORTE "^XA^LH010,010" SKIP.

    PUT STREAM REPORTE "^FO025,20" SKIP.
    PUT STREAM REPORTE "^ADN,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "CONTINENTAL S.A.C." SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /*
    PUT STREAM REPORTE "^FO035,020" SKIP.
    PUT STREAM REPORTE "^AVN,0,0" SKIP.
    PUT STREAM REPORTE "^FDBULTO : " + rr-w-report.campo-c[1] FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    */

    PUT STREAM REPORTE "^FO020,050" SKIP.
    PUT STREAM REPORTE "^AVN,0,0" SKIP.
    PUT STREAM REPORTE "^FD".
    /*PUT STREAM REPORTE "BULTO : " + lBultos FORMAT 'x(67)' SKIP.*/
    PUT STREAM REPORTE lEtiqueta FORMAT 'x(67)' SKIP.    
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FO035,130" SKIP.  /*080*/
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Direccion:" + lDireccion1 FORMAT 'x(67)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,160" SKIP. /*110*/
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Sede :" + lSede FORMAT 'x(60)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO690,030^BY2" SKIP. 
    PUT STREAM REPORTE "^B3R,N,80,N" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lBarra FORMAT 'x(15)' SKIP.
    PUT STREAM REPORTE "^FS".

    PUT STREAM REPORTE "^FO035,190" SKIP. /*150*/
    PUT STREAM REPORTE "^A0N,60,45" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Nro. " + lPedido FORMAT 'x(40)' SKIP.
    PUT STREAM REPORTE "^FS".
    /*
    PUT STREAM REPORTE "^FO400,200" SKIP.  /*150*/
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "RUC:" + lRuc FORMAT 'x(16)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    */
    PUT STREAM REPORTE "^FO035,250" SKIP.  /*200*/
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "DESTINO" FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,280" SKIP. /*230*/
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lCliente FORMAT 'x(70)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,320" SKIP.  /*270*/
    PUT STREAM REPORTE "^A0N,30,20" SKIP.  
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lDirPart1 FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,350" SKIP.   /*320*/
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lDirPart2 FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /*
    PUT STREAM REPORTE "^FO035,350" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Chequeador :" + lChequeador FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    */
    PUT STREAM REPORTE "^FO035,400" SKIP.
    PUT STREAM REPORTE "^A0N,35,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Fecha :" + STRING(lFecha,"99/99/9999") FORMAT 'x(18)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO290,400" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Etiqueta :" + lEtiqueta FORMAT 'x(28)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /*
    PUT STREAM REPORTE "^FO035,450" SKIP.
    PUT STREAM REPORTE "^A0N,35,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "BULTOS : " + lbultos FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    */
    PUT STREAM REPORTE "^FO370,450" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "PESO :" + STRING(lPeso,"ZZ,ZZZ,ZZ9.99") FORMAT 'x(19)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,500" SKIP.
    PUT STREAM REPORTE "^A0N,35,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Entrega :" + STRING(lFechaEnt,"99/99/9999") FORMAT 'x(20)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
 
    PUT STREAM REPORTE "^FO280,500" SKIP.
    PUT STREAM REPORTE "^A0N,40,20" SKIP.
    PUT STREAM REPORTE "^FDChequeador : " + lChequeador FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO350,500" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lRefOtr FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,550" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE x-almfinal FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^XZ" SKIP.

END.

OUTPUT STREAM REPORTE CLOSE.


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
  DO WITH FRAME {&FRAME-NAME}:
      fill-in-desde:SCREEN-VALUE = STRING(TODAY - 7,"99/99/9999").
      fill-in-hasta:SCREEN-VALUE = STRING(TODAY,"99/99/9999").
  END.

  RUN refrescar.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE orden-despacho-en-HPKs W-Win 
PROCEDURE orden-despacho-en-HPKs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodDoc AS CHAR. /* O/D */
DEFINE INPUT PARAMETER pNroDoc AS CHAR.

SESSION:SET-WAIT-STATE("GENERAL").

EMPTY TEMP-TABLE ttOrdenesHPK.

FOR EACH x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND
                            x-vtacdocu.codref = pCodDoc AND     /* O/D */
                            x-vtacdocu.nroref = pNroDoc AND 
                            x-vtacdocu.flgest <> 'A' NO-LOCK:
    CREATE ttOrdenesHPK.
        ASSIGN 
            ttOrdenesHPK.tcodhpk = x-vtacdocu.codped        /* HPK */
            ttOrdenesHPK.tnrohpk = x-vtacdocu.nroped
            ttOrdenesHPK.tcoddiv = x-vtacdocu.coddiv
            ttOrdenesHPK.tcodod = pCodDOc
            ttOrdenesHPK.tnrood = pNroDOc
            .
END.

SESSION:SET-WAIT-STATE("").


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ordenes-involucrados W-Win 
PROCEDURE ordenes-involucrados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.

DEFINE VAR x-llave AS CHAR.

/*
    Las ordenes contenidas en un HPK
*/

SESSION:SET-WAIT-STATE("GENERAL").

EMPTY TEMP-TABLE ttOrdenes.

IF pCodDoc = 'HPK' THEN DO:
    FIND FIRST x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND
        x-vtacdocu.codped = pCodDoc AND
        x-vtacdocu.nroped = pNroDoc NO-LOCK NO-ERROR.
    IF AVAILABLE x-vtacdocu THEN DO:
        IF x-vtacdocu.codter = 'ACUMULATIVO' THEN DO:
            x-llave = pCodDoc + "," + pNroDOc.
            FOR EACH x-almddocu WHERE x-almddocu.codcia = s-codcia AND 
                x-almddocu.codllave = x-llave NO-LOCK
                BREAK BY coddoc BY nrodoc.
                IF FIRST-OF(x-almddocu.coddoc) OR FIRST-OF(x-almddocu.nrodoc) THEN DO:
                    CREATE ttOrdenes.
                        ASSIGN 
                            tcoddoc = x-almddocu.coddoc
                            tnrodoc = x-almddocu.nrodoc.
                END.
            END.
        END.
        ELSE DO:
            CREATE ttOrdenes.
                ASSIGN 
                    tcoddoc = x-vtacdocu.codref
                    tnrodoc = x-vtacdocu.nroref.
        END.
    END.
END.
ELSE DO:
    CREATE ttOrdenes.
        ASSIGN tcoddoc = pCodDoc
                tnrodoc = pNroDoc.
END.

SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE packing-bcp W-Win 
PROCEDURE packing-bcp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.

DEFINE VAR x-codcot AS CHAR.
DEFINE VAR x-nrocot AS CHAR.

DEFINE VAR x-sele AS INT.

x-bultos-od = 0.

SESSION:SET-WAIT-STATE("GENERAL").

RUN ordenes-involucrados(INPUT pCodDoc, INPUT pNroDoc).     /* HPK ó O/D ó OTR */
RUN orden-despacho-en-HPKs(INPUT tt-chktareas.tcoddoc, INPUT tt-chktareas.tnrodoc). /* O/D */

/* Cuantos Bultos en total de la orden */
x-bultos = 0.
x-sele = 0.
FOR EACH tmp-w-report NO-LOCK:
    x-bultos = x-bultos + 1.
    IF tmp-w-report.campo-l[1] = YES THEN x-sele = x-sele + 1.
END.

IF x-sele <= 0 THEN DO:
    MESSAGE "Seleccione al menos un Bulto" 
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.
IF x-bultos <= 0 THEN DO:
    MESSAGE "No hay Rotulos" 
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

FIND FIRST t-tmp-w-report NO-LOCK NO-ERROR.

/* Busco la O/D */
/*   Todos son de la misma O/D */
FIND FIRST od-faccpedi WHERE od-faccpedi.codcia = s-codcia AND
                            od-faccpedi.coddoc = t-tmp-w-report.campo-c[1] AND      /* O/D */
                            od-faccpedi.nroped = t-tmp-w-report.campo-c[2] NO-LOCK NO-ERROR.
IF NOT AVAILABLE od-faccpedi THEN DO:
    MESSAGE "No existe la " + t-tmp-w-report.campo-c[1] + " " + t-tmp-w-report.campo-c[2]
        VIEW-AS ALERT-BOX INFORMATION.

    RETURN.
END.

/* Busco la PED */
FIND FIRST ped-faccpedi WHERE ped-faccpedi.codcia = s-codcia AND
                            ped-faccpedi.coddoc = od-faccpedi.codref AND      /* PED */
                            ped-faccpedi.nroped = od-faccpedi.nroref NO-LOCK NO-ERROR.

IF NOT AVAILABLE ped-faccpedi THEN DO:
    MESSAGE "No existe el " + od-faccpedi.codref + " " + od-faccpedi.nroref
        VIEW-AS ALERT-BOX INFORMATION.

    RETURN.
END.

/* Busco la COT */
FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                            faccpedi.coddoc = ped-faccpedi.codref AND      /* COT */
                            faccpedi.nroped = ped-faccpedi.nroref NO-LOCK NO-ERROR.

IF NOT AVAILABLE faccpedi THEN DO:
    MESSAGE "No se pudo ubicar la cotizacion de la " + t-tmp-w-report.campo-c[1] + " " + t-tmp-w-report.campo-c[2]
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

x-codcot = ped-faccpedi.codref.
x-nrocot = ped-faccpedi.nroref.

/**/
EMPTY TEMP-TABLE tt-w-report.
EMPTY TEMP-TABLE rr-w-report.       /* Los Articulos */
EMPTY TEMP-TABLE pck-w-report.      /* Packing ZEBRA */

DEFINE VARIABLE L-Ubica   AS LOGICAL INIT YES NO-UNDO.        
DEFINE VAR x-key2 AS CHAR.

x-key2 = STRING(TODAY,"99/99/9999") + STRING(TIME,"HH:MM:SS").

REPEAT WHILE L-Ubica:
    s-task-no = RANDOM(900000,999999).
    FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN L-Ubica = NO.
END.

IF s-task-no = 0 THEN DO:
    CORRELATIVO:
    REPEAT:
        s-task-no = RANDOM(1,999999).
        FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
        IF NOT AVAILABLE w-report THEN LEAVE CORRELATIVO.
    END.
END.

/* RUN Carga-Packing-bcp.      /* Carga los Articulos */ */
RUN carga-articulos-packing.

/*
IF toggle-packing-zebra = NO THEN DO:
    /* A4 */
    FOR EACH rr-w-report NO-LOCK:
        CREATE w-report.
        ASSIGN
            w-report.Task-No    = s-task-no 
            w-report.Llave-C    = x-key2
            w-report.Campo-C[1] = "TODA LA O/D"       /* Bulto */
            w-report.Campo-C[2] = "PEDIDO " + trim(faccpedi.ordertype)
            w-report.Campo-C[3] = trim(faccpedi.customerPurchaseOrder)
            w-report.Campo-C[4] = trim(faccpedi.OfficeCustomer) + " " + trim(faccpedi.OfficeCustomerName)
            w-report.Campo-C[5] = trim(faccpedi.CustomerStockDepo) + " " + trim(faccpedi.CustomerStockDepoName)
            w-report.Campo-C[6] = trim(faccpedi.DeliveryGroup)
            w-report.Campo-C[7] = trim(faccpedi.OrderType)
            w-report.Campo-C[8] = trim(faccpedi.DeliveryAddress)
            w-report.Campo-C[9] = trim(faccpedi.Region3Name)
            w-report.Campo-C[10] = trim(faccpedi.Region2Name)
            w-report.Campo-C[11] = trim(faccpedi.Region1Name)
            w-report.Campo-C[12] = trim(faccpedi.ContactReceptorName)
            w-report.Campo-C[13] = "Bultos de la 0/D " + STRING(x-bultos-od)
            /*w-report.Campo-C[13] = "Packing " + STRING(t-tmp-w-report.campo-i[1]) + " / " + STRING(x-bultos)*/
        .
        /* Datos del Articulo */
        FIND FIRST facdpedi WHERE facdpedi.codcia = s-codcia AND
                                    facdpedi.coddoc = x-codcot AND
                                    facdpedi.nroped = x-nrocot AND
                                    facdpedi.codmat = rr-w-report.campo-c[2] NO-LOCK NO-ERROR.
        IF AVAILABLE facdpedi THEN DO:
            ASSIGN w-report.Campo-C[14] = trim(facdpedi.CustomerArtCode)
                    w-report.Campo-C[15] = trim(facdpedi.CustomerOldArtCode)   /* Codigo antiguo */
                    w-report.Campo-C[16] = trim(facdpedi.CustomerArtDescription)
                    w-report.Campo-f[1] = rr-w-report.campo-f[1]
                    w-report.Campo-C[17] = trim(facdpedi.CustomerUnitCode)
                    w-report.Campo-C[18] = trim(faccpedi.CustomerRequest)
                .
        END.
    END.
END.
ELSE DO:
    FOR EACH t-tmp-w-report WHERE t-tmp-w-report.campo-l[1] = YES NO-LOCK :
        FOR EACH rr-w-report WHERE rr-w-report.campo-c[1] = t-tmp-w-report.campo-c[3] NO-LOCK:

            CREATE pck-w-report.
            ASSIGN
                pck-w-report.Task-No    = s-task-no 
                pck-w-report.Llave-C    = x-key2
                pck-w-report.Campo-C[1] = t-tmp-w-report.campo-c[3]       /* Bulto */
                pck-w-report.Campo-C[2] = "PEDIDO " + trim(faccpedi.ordertype)
                pck-w-report.Campo-C[3] = trim(faccpedi.customerPurchaseOrder)
                pck-w-report.Campo-C[4] = trim(faccpedi.OfficeCustomer) + " " + trim(faccpedi.OfficeCustomerName)
                pck-w-report.Campo-C[5] = trim(faccpedi.CustomerStockDepo) + " " + trim(faccpedi.CustomerStockDepoName)
                pck-w-report.Campo-C[6] = trim(faccpedi.DeliveryGroup)
                pck-w-report.Campo-C[7] = trim(faccpedi.OrderType)
                pck-w-report.Campo-C[8] = trim(faccpedi.DeliveryAddress)
                pck-w-report.Campo-C[9] = trim(faccpedi.Region3Name)
                pck-w-report.Campo-C[10] = trim(faccpedi.Region2Name)
                pck-w-report.Campo-C[11] = trim(faccpedi.Region1Name)
                pck-w-report.Campo-C[12] = trim(faccpedi.ContactReceptorName)
                pck-w-report.Campo-C[13] = "Packing " + STRING(t-tmp-w-report.campo-i[1]) + " / " + STRING(x-bultos)
            .
            /* Datos del Articulo */
            FIND FIRST facdpedi WHERE facdpedi.codcia = s-codcia AND
                                        facdpedi.coddoc = x-codcot AND
                                        facdpedi.nroped = x-nrocot AND
                                        facdpedi.codmat = rr-w-report.campo-c[2] NO-LOCK NO-ERROR.
            IF AVAILABLE facdpedi THEN DO:
                ASSIGN pck-w-report.Campo-C[14] = trim(facdpedi.CustomerArtCode)
                        pck-w-report.Campo-C[15] = trim(facdpedi.CustomerOldArtCode)   /* Codigo antiguo */
                        pck-w-report.Campo-C[16] = trim(facdpedi.CustomerArtDescription)
                        pck-w-report.Campo-f[1] = rr-w-report.campo-f[1]
                        pck-w-report.Campo-C[17] = trim(facdpedi.CustomerUnitCode)
                        pck-w-report.Campo-C[18] = trim(faccpedi.CustomerRequest)
                    .
            END.
        END.
    END.
END.
*/

/* Data para el reporte */
FOR EACH t-tmp-w-report WHERE t-tmp-w-report.campo-l[1] = YES NO-LOCK :
    FOR EACH rr-w-report WHERE rr-w-report.campo-c[1] = t-tmp-w-report.campo-c[3] NO-LOCK:

        IF toggle-packing-zebra = NO THEN DO:
            CREATE w-report.
            ASSIGN
                w-report.Task-No    = s-task-no 
                w-report.Llave-C    = x-key2
                w-report.Campo-C[1] = t-tmp-w-report.campo-c[3]       /* Bulto */
                w-report.Campo-C[2] = "PEDIDO " + trim(faccpedi.ordertype)
                w-report.Campo-C[3] = trim(faccpedi.customerPurchaseOrder)
                w-report.Campo-C[4] = trim(faccpedi.OfficeCustomer) + " " + trim(faccpedi.OfficeCustomerName)
                w-report.Campo-C[5] = trim(faccpedi.CustomerStockDepo) + " " + trim(faccpedi.CustomerStockDepoName)
                w-report.Campo-C[6] = trim(faccpedi.DeliveryGroup)
                w-report.Campo-C[7] = trim(faccpedi.OrderType)
                w-report.Campo-C[8] = trim(faccpedi.DeliveryAddress)
                w-report.Campo-C[9] = trim(faccpedi.Region3Name)
                w-report.Campo-C[10] = trim(faccpedi.Region2Name)
                w-report.Campo-C[11] = trim(faccpedi.Region1Name)
                w-report.Campo-C[12] = trim(faccpedi.ContactReceptorName)
                w-report.Campo-C[13] = "Packing " + STRING(t-tmp-w-report.campo-i[1]) + " / " + STRING(x-bultos)
            .
            /* Datos del Articulo */
            FIND FIRST facdpedi WHERE facdpedi.codcia = s-codcia AND
                                        facdpedi.coddoc = x-codcot AND
                                        facdpedi.nroped = x-nrocot AND
                                        facdpedi.codmat = rr-w-report.campo-c[2] NO-LOCK NO-ERROR.
            IF AVAILABLE facdpedi THEN DO:
                ASSIGN w-report.Campo-C[14] = trim(facdpedi.CustomerArtCode)
                        w-report.Campo-C[15] = trim(facdpedi.CustomerOldArtCode)   /* Codigo antiguo */
                        w-report.Campo-C[16] = trim(facdpedi.CustomerArtDescription)
                        w-report.Campo-f[1] = rr-w-report.campo-f[1]
                        w-report.Campo-C[17] = trim(facdpedi.CustomerUnitCode)
                        w-report.Campo-C[18] = trim(faccpedi.CustomerRequest)
                    .
            END.
        END.
        ELSE DO:
            CREATE pck-w-report.
            ASSIGN
                pck-w-report.Task-No    = s-task-no 
                pck-w-report.Llave-C    = x-key2
                pck-w-report.Campo-C[1] = t-tmp-w-report.campo-c[3]       /* Bulto */
                pck-w-report.Campo-C[2] = "PEDIDO " + trim(faccpedi.ordertype)
                pck-w-report.Campo-C[3] = trim(faccpedi.customerPurchaseOrder)
                pck-w-report.Campo-C[4] = trim(faccpedi.OfficeCustomer) + " " + trim(faccpedi.OfficeCustomerName)
                pck-w-report.Campo-C[5] = trim(faccpedi.CustomerStockDepo) + " " + trim(faccpedi.CustomerStockDepoName)
                pck-w-report.Campo-C[6] = trim(faccpedi.DeliveryGroup)
                pck-w-report.Campo-C[7] = trim(faccpedi.OrderType)
                pck-w-report.Campo-C[8] = trim(faccpedi.DeliveryAddress)
                pck-w-report.Campo-C[9] = trim(faccpedi.Region3Name)
                pck-w-report.Campo-C[10] = trim(faccpedi.Region2Name)
                pck-w-report.Campo-C[11] = trim(faccpedi.Region1Name)
                pck-w-report.Campo-C[12] = trim(faccpedi.ContactReceptorName)
                pck-w-report.Campo-C[13] = "Packing " + STRING(t-tmp-w-report.campo-i[1]) + " / " + STRING(x-bultos)
            .
            /* Datos del Articulo */
            FIND FIRST facdpedi WHERE facdpedi.codcia = s-codcia AND
                                        facdpedi.coddoc = x-codcot AND
                                        facdpedi.nroped = x-nrocot AND
                                        facdpedi.codmat = rr-w-report.campo-c[2] NO-LOCK NO-ERROR.
            IF AVAILABLE facdpedi THEN DO:
                ASSIGN pck-w-report.Campo-C[14] = trim(facdpedi.CustomerArtCode)
                        pck-w-report.Campo-C[15] = trim(facdpedi.CustomerOldArtCode)   /* Codigo antiguo */
                        pck-w-report.Campo-C[16] = trim(facdpedi.CustomerArtDescription)
                        pck-w-report.Campo-f[1] = rr-w-report.campo-f[1]
                        pck-w-report.Campo-C[17] = trim(facdpedi.CustomerUnitCode)
                        pck-w-report.Campo-C[18] = trim(faccpedi.CustomerRequest)
                    .
            END.

        END.
    END.
END.


SESSION:SET-WAIT-STATE("").

IF toggle-packing-zebra = YES THEN DO:

    RUN packing-bcp-zebra.

    RETURN.
END.

/* Code placed here will execute PRIOR to standard behavior. */
DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */


GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'vta2/rbvta2.prl'.
RB-REPORT-NAME = 'Packing List bcp'.
RB-INCLUDE-RECORDS = 'O'.

RB-FILTER = "w-report.task-no = " + STRING(s-task-no) +
                " and w-report.llave-c = '" + x-key2 + "'".

RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                   RB-REPORT-NAME,
                   RB-INCLUDE-RECORDS,
                   RB-FILTER,
                   RB-OTHER-PARAMETERS).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE packing-bcp-zebra W-Win 
PROCEDURE packing-bcp-zebra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND FIRST pck-w-report NO-LOCK NO-ERROR.

IF NOT AVAILABLE pck-w-report THEN DO:
    MESSAGE "No hay data a Imprimir" VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.


DEFINE VAR x-papel AS LOG.

x-papel = YES.

IF x-papel = YES THEN DO:
    DEFINE VAR rpta AS LOG.

    SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
    IF rpta = NO THEN RETURN.

    OUTPUT STREAM REPORTE TO PRINTER.
END.
ELSE DO:
    DEFINE VAR x-file-zpl AS CHAR.

    x-file-zpl = SESSION:TEMP-DIRECTORY + "PackingList.txt".

    OUTPUT STREAM REPORTE TO VALUE(x-file-zpl).
END.

DEFINE VAR x-paginas AS INT.
DEFINE VAR x-pagina AS INT.
DEFINE VAR x-linea AS INT.
DEFINE VAR x-lineas-x-pag AS INT.

DEFINE VAR x-height-row AS INT.
DEFINE VAR x-row-ini1 AS INT.
DEFINE VAR x-row-ini2 AS INT.

DEFINE VAR x-registros AS INT.
DEFINE VAR x-registro AS INT.

DEFINE VAR x-codmat AS CHAR.
DEFINE VAR x-oldmat AS CHAR.
DEFINE VAR x-sku AS CHAR.
DEFINE VAR x-descripcion AS CHAR.
DEFINE VAR x-cantidad AS DEC.
DEFINE VAR x-um AS CHAR.

x-lineas-x-pag = 13.
x-pagina = 0.
x-linea = 9999999.
x-registros = 0.

FOR EACH pck-w-report NO-LOCK:
    x-registros = x-registros + 1.
END.

x-paginas = TRUNCATE(x-registros / x-lineas-x-pag ,0).
IF (x-registros MODULO x-lineas-x-pag) > 0 THEN x-paginas = x-paginas + 1.

FOR EACH pck-w-report NO-LOCK BY pck-w-report.Campo-C[1] :
    IF x-linea > x-lineas-x-pag  THEN DO:
        x-pagina = x-pagina + 1.
        x-linea = 1.
        /* Imprimir cabecera */
        PUT STREAM REPORTE "^XA^LH010,010" SKIP.
        PUT STREAM REPORTE "^XA" SKIP.
        PUT STREAM REPORTE "^FT180,60" SKIP.
        PUT STREAM REPORTE "^ARN^FDFORMULARIO DE DESPACHO^FS" SKIP.
        
        PUT STREAM REPORTE "^FT600,40" SKIP.
        PUT STREAM REPORTE "^AQN^FD".
        PUT STREAM REPORTE "FECHA : " + STRING(TODAY,"99/99/9999") + "^FS" FORMAT 'x(25)' SKIP.
        PUT STREAM REPORTE "^FT600,70" SKIP.
        PUT STREAM REPORTE "^AQN^FD".
        PUT STREAM REPORTE "PAG : " + STRING(x-pagina,">>9") + " / " + STRING(x-paginas,">>9") FORMAT 'x(25)' SKIP.
        PUT STREAM REPORTE "^FS" SKIP.
        PUT STREAM REPORTE "^FO10,75^GB790,50,3^FS" SKIP.
        PUT STREAM REPORTE "^FO100,75^GB1,50,3^FS" SKIP.
        PUT STREAM REPORTE "^FO200,75^GB1,50,3^FS" SKIP.
        PUT STREAM REPORTE "^FO640,75^GB1,50,3^FS" SKIP.
        PUT STREAM REPORTE "^FO730,75^GB1,50,3^FS" SKIP.

        PUT STREAM REPORTE "^FT20,110" SKIP.
        PUT STREAM REPORTE "^APN^FDMATERIAL^FS" SKIP.
        PUT STREAM REPORTE "^FT105,110" SKIP.
        PUT STREAM REPORTE "^APN^FDCOD.ANTIGUO^FS" SKIP.
        PUT STREAM REPORTE "^FT320,110" SKIP.
        PUT STREAM REPORTE "^AQN^FDDESCRIPCION DEL ITEM^FS" SKIP.
        PUT STREAM REPORTE "^FT660,110" SKIP.
        PUT STREAM REPORTE "^AQN^FDCANT.^FS" SKIP.
        PUT STREAM REPORTE "^FT740,110" SKIP.
        PUT STREAM REPORTE "^AQN^FDU.M.^FS" SKIP.


        x-height-row = 0.
        x-row-ini1 = 122.
        x-row-ini2 = 150.
    END.
    /*
    x-sku = STRING(x-registro,"999999999999999999").
    x-descripcion = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX".
    x-cantidad = 99999.99.
    x-um = "XXXXXX".
    */
    x-codmat           = pck-w-report.Campo-C[14].
    x-oldmat           = pck-w-report.Campo-C[15].
    x-descripcion   = pck-w-report.Campo-C[16].
    x-um            = pck-w-report.Campo-C[17].
    x-cantidad      = pck-w-report.Campo-F[1].

    IF LENGTH(x-descripcion) > 35 THEN x-descripcion = SUBSTRING(x-descripcion,1,35).

    x-row-ini1 = x-row-ini1 + x-height-row.
    x-row-ini2 = x-row-ini2 + x-height-row.

    PUT STREAM REPORTE "^FO10," + STRING(x-row-ini1) + "^GB790,40,3^FS" FORMAT 'X(100)' SKIP.

    PUT STREAM REPORTE "^FO100," + STRING(x-row-ini1) + "^GB1,40,3^FS" FORMAT 'X(100)' SKIP.
    PUT STREAM REPORTE "^FO200," + STRING(x-row-ini1) + "^GB1,40,3^FS" FORMAT 'X(100)' SKIP.
    PUT STREAM REPORTE "^FO640," + STRING(x-row-ini1) + "^GB1,40,3^FS" FORMAT 'X(100)' SKIP.
    PUT STREAM REPORTE "^FO730," + STRING(x-row-ini1) + "^GB1,40,3^FS" FORMAT 'X(100)' SKIP.

    PUT STREAM REPORTE "^FT15," + STRING(x-row-ini2) FORMAT 'X(100)' SKIP.
    PUT STREAM REPORTE "^APN^FD".
    PUT STREAM REPORTE x-codmat FORMAT 'x(10)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FT110," + STRING(x-row-ini2) FORMAT 'X(100)' SKIP.
    PUT STREAM REPORTE "^APN^FD".
    PUT STREAM REPORTE x-oldmat FORMAT 'x(10)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FT215," + STRING(x-row-ini2) FORMAT 'X(100)' SKIP.
    PUT STREAM REPORTE "^AQN^FD".
    PUT STREAM REPORTE x-descripcion FORMAT 'x(33)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FT660," + STRING(x-row-ini2) FORMAT 'X(100)' SKIP.
    PUT STREAM REPORTE "^APN^FD".
    PUT STREAM REPORTE x-cantidad FORMAT ">>,>>9.99" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FT740," + STRING(x-row-ini2) FORMAT 'X(100)' SKIP.
    PUT STREAM REPORTE "^APN^FD".
    PUT STREAM REPORTE x-um FORMAT 'x(6)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    x-linea = x-linea + 1.
    x-height-row = 37.
    IF x-linea > x-lineas-x-pag  THEN DO:
        /* Pie de Pagina */
        PUT STREAM REPORTE "^XZ" SKIP.
    END.
END.

PUT STREAM REPORTE "^XZ" SKIP.

OUTPUT STREAM REPORTE CLOSE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE packing-consolidado W-Win 
PROCEDURE packing-consolidado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.

DEFINE VAR x-codcot AS CHAR.
DEFINE VAR x-nrocot AS CHAR.

DEFINE VAR x-sele AS INT.

x-bultos-od = 0.

SESSION:SET-WAIT-STATE("GENERAL").

RUN ordenes-involucrados(INPUT pCodDoc, INPUT pNroDoc).     /* HPK ó O/D ó OTR */
RUN orden-despacho-en-HPKs(INPUT tt-chktareas.tcoddoc, INPUT tt-chktareas.tnrodoc). /* O/D */

/* Cuantos Bultos en total de la orden */
x-bultos = 0.
x-sele = 0.
FOR EACH tmp-w-report NO-LOCK:
    x-bultos = x-bultos + 1.
    IF tmp-w-report.campo-l[1] = YES THEN x-sele = x-sele + 1.
END.

IF x-sele <= 0 THEN DO:
    MESSAGE "Seleccione al menos un Bulto" 
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.
IF x-bultos <= 0 THEN DO:
    MESSAGE "No hay Rotulos" 
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-nrodoc AS CHAR.

FIND FIRST ttOrdenesHPK NO-LOCK NO-ERROR.
IF AVAILABLE ttOrdenesHPK THEN DO:
    x-coddoc = ttOrdenesHPK.tcodod.        /* O/D */
    x-nrodoc = ttOrdenesHPK.tnrood.  
END.


/* Busco la O/D */
/*   Todos son de la misma O/D */
FIND FIRST od-faccpedi WHERE od-faccpedi.codcia = s-codcia AND
                            od-faccpedi.coddoc = x-coddoc AND      /* O/D */
                            od-faccpedi.nroped = x-nrodoc NO-LOCK NO-ERROR.
IF NOT AVAILABLE od-faccpedi THEN DO:
    MESSAGE "No existe la " + x-coddoc + " " + x-nrodoc
        VIEW-AS ALERT-BOX INFORMATION.

    RETURN.
END.

/* Busco la PED */
FIND FIRST ped-faccpedi WHERE ped-faccpedi.codcia = s-codcia AND
                            ped-faccpedi.coddoc = od-faccpedi.codref AND      /* PED */
                            ped-faccpedi.nroped = od-faccpedi.nroref NO-LOCK NO-ERROR.

IF NOT AVAILABLE ped-faccpedi THEN DO:
    MESSAGE "No existe el " + od-faccpedi.codref + " " + od-faccpedi.nroref
        VIEW-AS ALERT-BOX INFORMATION.

    RETURN.
END.

/* Busco la COT */
FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                            faccpedi.coddoc = ped-faccpedi.codref AND      /* COT */
                            faccpedi.nroped = ped-faccpedi.nroref NO-LOCK NO-ERROR.

IF NOT AVAILABLE faccpedi THEN DO:
    MESSAGE "No se pudo ubicar la cotizacion de la " + ped-faccpedi.codref + " " + ped-faccpedi.nroref
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

x-codcot = ped-faccpedi.codref.
x-nrocot = ped-faccpedi.nroref.

/**/
EMPTY TEMP-TABLE tt-w-report.
EMPTY TEMP-TABLE rr-w-report.       /* Los Articulos */
EMPTY TEMP-TABLE pck-w-report.      /* Packing ZEBRA */

DEFINE VARIABLE L-Ubica   AS LOGICAL INIT YES NO-UNDO.        
DEFINE VAR x-key2 AS CHAR.

x-key2 = STRING(TODAY,"99/99/9999") + STRING(TIME,"HH:MM:SS").

REPEAT WHILE L-Ubica:
    s-task-no = RANDOM(900000,999999).
    FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN L-Ubica = NO.
END.

IF s-task-no = 0 THEN DO:
    CORRELATIVO:
    REPEAT:
        s-task-no = RANDOM(1,999999).
        FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
        IF NOT AVAILABLE w-report THEN LEAVE CORRELATIVO.
    END.
END.

/* RUN Carga-Packing-bcp.      /* Carga los Articulos */ */
RUN carga-articulos-packing.

/* Data para el reporte */
FOR EACH rr-w-report NO-LOCK:   

    IF faccpedi.codcli = "20100047218" THEN DO:
        /* BCP */
        CREATE w-report.
        ASSIGN
            w-report.Task-No    = s-task-no 
            w-report.Llave-C    = x-key2
            w-report.Campo-C[1] = "TODA LA O/D"       /* Bulto */
            w-report.Campo-C[2] = "PEDIDO " + trim(faccpedi.ordertype)
            w-report.Campo-C[3] = trim(faccpedi.customerPurchaseOrder)
            w-report.Campo-C[4] = trim(faccpedi.OfficeCustomer) + " " + trim(faccpedi.OfficeCustomerName)
            w-report.Campo-C[5] = trim(faccpedi.CustomerStockDepo) + " " + trim(faccpedi.CustomerStockDepoName)
            w-report.Campo-C[6] = trim(faccpedi.DeliveryGroup)
            w-report.Campo-C[7] = trim(faccpedi.OrderType)
            w-report.Campo-C[8] = trim(faccpedi.DeliveryAddress)
            w-report.Campo-C[9] = trim(faccpedi.Region3Name)
            w-report.Campo-C[10] = trim(faccpedi.Region2Name)
            w-report.Campo-C[11] = trim(faccpedi.Region1Name)
            w-report.Campo-C[12] = trim(faccpedi.ContactReceptorName)
            w-report.Campo-C[13] = "Bultos PED.Logistico " + STRING(x-bultos-od)
            /*w-report.Campo-C[13] = "Packing " + STRING(t-tmp-w-report.campo-i[1]) + " / " + STRING(x-bultos)*/
        .
        /* Datos del Articulo */
        FIND FIRST facdpedi WHERE facdpedi.codcia = s-codcia AND
                                    facdpedi.coddoc = x-codcot AND
                                    facdpedi.nroped = x-nrocot AND
                                    facdpedi.codmat = rr-w-report.campo-c[2] NO-LOCK NO-ERROR.
        IF AVAILABLE facdpedi THEN DO:
            ASSIGN w-report.Campo-C[14] = trim(facdpedi.CustomerArtCode)
                    w-report.Campo-C[15] = trim(facdpedi.CustomerOldArtCode)   /* Codigo antiguo */
                    w-report.Campo-C[16] = trim(facdpedi.CustomerArtDescription)
                    w-report.Campo-f[1] = rr-w-report.campo-f[1]
                    w-report.Campo-C[17] = trim(facdpedi.CustomerUnitCode)
                    w-report.Campo-C[18] = trim(faccpedi.CustomerRequest)
                .
        END.

    END.
    IF faccpedi.codcli = "20382036655" THEN DO:
        /* MI BANCO */
        CREATE w-report.
        ASSIGN
            w-report.Task-No    = s-task-no 
            w-report.Llave-C    = x-key2
            w-report.Campo-C[1] = "TODA LA O/D"       /* Bulto */
            w-report.Campo-C[2] = "PEDIDO " + trim(faccpedi.ordertype)
            w-report.Campo-C[3] = trim(faccpedi.customerPurchaseOrder)
            w-report.Campo-C[4] = /*trim(faccpedi.OfficeCustomer) + " " +*/ trim(faccpedi.OfficeCustomerName)
            w-report.Campo-C[5] = trim(faccpedi.CustomerStockDepo) + " " + trim(faccpedi.CustomerStockDepoName)
            w-report.Campo-C[6] = trim(faccpedi.DeliveryGroup)
            w-report.Campo-C[7] = trim(faccpedi.OrderType)
            w-report.Campo-C[8] = trim(faccpedi.DeliveryAddress)
            w-report.Campo-C[9] = trim(faccpedi.Region3Name)
            w-report.Campo-C[10] = trim(faccpedi.Region2Name)
            w-report.Campo-C[11] = trim(faccpedi.Region1Name)
            w-report.Campo-C[12] = trim(faccpedi.ContactReceptorName)
            w-report.Campo-C[13] = "Bultos PED.Logistico " + STRING(x-bultos-od)
            /*w-report.Campo-C[13] = "Packing " + STRING(t-tmp-w-report.campo-i[1]) + " / " + STRING(x-bultos)*/
        .
        /* Datos del Articulo */
        FIND FIRST facdpedi WHERE facdpedi.codcia = s-codcia AND
                                    facdpedi.coddoc = x-codcot AND
                                    facdpedi.nroped = x-nrocot AND
                                    facdpedi.codmat = rr-w-report.campo-c[2] NO-LOCK NO-ERROR.
        IF AVAILABLE facdpedi THEN DO:
            ASSIGN w-report.Campo-C[14] = trim(facdpedi.CustomerArtCode)
                    w-report.Campo-C[15] = trim(facdpedi.CustomerOldArtCode)   /* Codigo antiguo */
                    w-report.Campo-C[16] = trim(facdpedi.CustomerArtDescription)
                    w-report.Campo-f[1] = rr-w-report.campo-f[1]
                    w-report.Campo-C[17] = trim(facdpedi.CustomerUnitCode)
                    w-report.Campo-C[18] = trim(faccpedi.OfficeCustomer)   /*CustomerRequest*/
                .
        END.
    END.
END.

/* Code placed here will execute PRIOR to standard behavior. */
DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */


GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'vta2/rbvta2.prl'.

RB-REPORT-NAME = 'Packing List bcp'.
IF faccpedi.codcli = "20382036655" THEN RB-REPORT-NAME = 'Packing List mi banco'.

RB-INCLUDE-RECORDS = 'O'.

RB-FILTER = "w-report.task-no = " + STRING(s-task-no) +
                " and w-report.llave-c = '" + x-key2 + "'".

RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                   RB-REPORT-NAME,
                   RB-INCLUDE-RECORDS,
                   RB-FILTER,
                   RB-OTHER-PARAMETERS).


END PROCEDURE.

/*

BCP
/* Code placed here will execute PRIOR to standard behavior. */
DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */


GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'vta2/rbvta2.prl'.
RB-REPORT-NAME = 'Packing List bcp'.
RB-INCLUDE-RECORDS = 'O'.

RB-FILTER = "w-report.task-no = " + STRING(s-task-no) +
                " and w-report.llave-c = '" + x-key2 + "'".

RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                   RB-REPORT-NAME,
                   RB-INCLUDE-RECORDS,
                   RB-FILTER,
                   RB-OTHER-PARAMETERS).


MI BANCO

/* Code placed here will execute PRIOR to standard behavior. */
DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */


GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'vta2/rbvta2.prl'.
RB-REPORT-NAME = 'Packing List mi banco'.
RB-INCLUDE-RECORDS = 'O'.

RB-FILTER = "w-report.task-no = " + STRING(s-task-no) +
                " and w-report.llave-c = '" + x-key2 + "'".

RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                   RB-REPORT-NAME,
                   RB-INCLUDE-RECORDS,
                   RB-FILTER,
                   RB-OTHER-PARAMETERS).


*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE packing-list W-Win 
PROCEDURE packing-list :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.

DEFINE VAR x-llave AS CHAR.

DEF VAR pTipo AS INT NO-UNDO.
IF x-packing-list-destino <> "PACKING LIST ZEBRA" THEN DO:
    RUN dist/d-tipo-packinglist (OUTPUT pTipo).
    IF pTipo = 0 THEN RETURN.
END.

SESSION:SET-WAIT-STATE("GENERAL").

RUN ordenes-involucrados(INPUT pCodDoc, INPUT pNroDoc).     /* HPK ó O/D ó OTR */

/**/
/*EMPTY TEMP-TABLE tt-w-report.*/
EMPTY TEMP-TABLE tt-w-report-zebra.

DEFINE VARIABLE iInt      AS INTEGER          NO-UNDO.
DEFINE VARIABLE L-Ubica   AS LOGICAL INIT YES NO-UNDO.        

REPEAT WHILE L-Ubica:
    s-task-no = RANDOM(900000,999999).
    FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN L-Ubica = NO.
END.

IF s-task-no = 0 THEN DO:
    CORRELATIVO:
    REPEAT:
        s-task-no = RANDOM(1,999999).
        FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
        IF NOT AVAILABLE w-report THEN LEAVE CORRELATIVO.
    END.
END.

iInt = 0.
RUN Carga-Packing-HPK.

SESSION:SET-WAIT-STATE("").

IF x-packing-list-destino = "PACKING LIST ZEBRA" THEN DO:
    RUN packing-list-zebra.
    RETURN.
END.

/* FOR EACH ttOrdenes :                                                                          */
/*     FIND FIRST ccbcbult WHERE ccbcbult.codcia = s-codcia AND                                  */
/*         ccbcbult.coddoc = ttOrdenes.tcoddoc AND                                               */
/*         ccbcbult.nrodoc = ttOrdenes.tnrodoc NO-LOCK NO-ERROR.                                 */
/*     IF NOT AVAILABLE CcbCBult THEN NEXT.                                                      */
/*     IF CcbCBult.CodDoc = "O/D" OR CcbCBult.CodDoc = "OTR" OR CcbCBult.CodDoc = "O/M" THEN DO: */
/*         RUN Carga-Packing-OD.                                                                 */
/*     END.                                                                                      */
/* END.                                                                                          */


/* Code placed here will execute PRIOR to standard behavior. */
DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'dist/rbdist.prl'.
CASE pTipo:
    WHEN 1 THEN RB-REPORT-NAME = 'Packing List sin EAN'.
    WHEN 2 THEN RB-REPORT-NAME = 'Packing List'.
END CASE.
RB-INCLUDE-RECORDS = 'O'.

RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                   RB-REPORT-NAME,
                   RB-INCLUDE-RECORDS,
                   RB-FILTER,
                   RB-OTHER-PARAMETERS).


END PROCEDURE.

/*
    IF NOT AVAILABLE CcbCBult THEN RETURN.
    DEFINE VARIABLE iInt      AS INTEGER          NO-UNDO.
    DEFINE VARIABLE L-Ubica   AS LOGICAL INIT YES NO-UNDO.        

    REPEAT WHILE L-Ubica:
           s-task-no = RANDOM(900000,999999).
           FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
           IF NOT AVAILABLE w-report THEN L-Ubica = NO.
    END.

    CASE CcbCBult.CodDoc:
        WHEN "O/D" OR WHEN "OTR" OR WHEN "O/M" THEN DO:
            DEF VAR pTipo AS INT NO-UNDO.
            RUN dist/d-tipo-packinglist (OUTPUT pTipo).
            IF pTipo = 0 THEN RETURN.
            RUN Carga-Packing-OD.
            /* Code placed here will execute PRIOR to standard behavior. */
            DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
            DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
            DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
            DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
            DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

            GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
            RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'dist/rbdist.prl'.
            CASE pTipo:
                WHEN 1 THEN RB-REPORT-NAME = 'Packing List sin EAN'.
                WHEN 2 THEN RB-REPORT-NAME = 'Packing List'.
            END CASE.
            RB-INCLUDE-RECORDS = 'O'.

            RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
            RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                               RB-REPORT-NAME,
                               RB-INCLUDE-RECORDS,
                               RB-FILTER,
                               RB-OTHER-PARAMETERS).

        END.
        OTHERWISE DO:
        END.
    END CASE.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE packing-list-zebra W-Win 
PROCEDURE packing-list-zebra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-imp-header AS LOG.
DEFINE VAR x-cliente1 AS CHAR.
DEFINE VAR x-cliente2 AS CHAR.

DEFINE VAR x-fila AS INT.
DEFINE VAR x-reg AS INT.
DEFINE VAR x-pag AS INT.
DEFINE VAR x-regs-x-pag AS INT.
DEFINE VAR x-tot-pags AS INT.
DEFINE VAR x-peso AS DEC.
DEFINE VAR x-altura AS INT.

DEFINE VAR x-papel AS LOG.

x-papel = YES.

IF USERID("DICTDB") <> "MASTER" AND x-papel = YES THEN DO:
    DEFINE VAR rpta AS LOG.

    SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
    IF rpta = NO THEN RETURN.

    OUTPUT STREAM REPORTE TO PRINTER.
END.
ELSE DO:
    DEFINE VAR x-file-zpl AS CHAR.

    x-file-zpl = SESSION:TEMP-DIRECTORY + "PackingList ZEBRA.txt".

    OUTPUT STREAM REPORTE TO VALUE(x-file-zpl).
END.

FOR EACH tt-w-report NO-LOCK:
    /*
    MESSAGE tt-w-report.campo-c[3] SKIP
            tt-w-report.campo-l[1].
   */
    x-cantidad-sku = 0.
    FOR EACH tt-w-report-zebra WHERE tt-w-report-zebra.llave-c = tt-w-report.campo-c[3] NO-LOCK BREAK BY tt-w-report-zebra.llave-C :
        x-cantidad-sku = x-cantidad-sku + 1.
    END.

    x-imp-header = YES.
    x-regs-x-pag = 17.
    x-pag = 1.
    x-tot-pags = TRUNCATE(x-cantidad-sku / x-regs-x-pag,0).
    x-altura = 45.
    
    IF (x-cantidad-sku MODULO x-regs-x-pag) > 0 THEN x-tot-pags = x-tot-pags + 1.

    FOR EACH tt-w-report-zebra WHERE tt-w-report-zebra.llave-c = tt-w-report.campo-c[3] NO-LOCK BREAK BY tt-w-report-zebra.llave-C BY tt-w-report-zebra.Campo-C[9] :

        IF FIRST-OF(tt-w-report-zebra.llave-C) THEN DO:
            x-imp-header = YES.        
        END.

        IF x-imp-header = YES THEN DO:

            x-cliente1 = tt-w-report-zebra.Campo-C[5].
            IF LENGTH(tt-w-report-zebra.Campo-C[5]) > 50 THEN DO:
                x-cliente1 = SUBSTRING(tt-w-report-zebra.Campo-C[5],1,50).
                x-cliente2 = SUBSTRING(tt-w-report-zebra.Campo-C[5],50).
            END.

            PUT STREAM REPORTE "^XA^LH010,010" SKIP.

            PUT STREAM REPORTE "^LRY" SKIP.
            PUT STREAM REPORTE "^FO10,23" SKIP.
            PUT STREAM REPORTE "^GB790,40,40^FS" SKIP.
            PUT STREAM REPORTE "^FO20,23^AS" SKIP.
            PUT STREAM REPORTE "^FD" + tt-w-report-zebra.Campo-C[2] + " " + tt-w-report-zebra.Campo-C[3] + "^FS" FORMAT 'x(60)' SKIP.
            PUT STREAM REPORTE "^FO500,23^AS" SKIP.
            PUT STREAM REPORTE "^FD" + STRING(NOW,"99/99/9999 HH:MM:SS") + "^FS" FORMAT 'x(50)' SKIP.
            PUT STREAM REPORTE "^LRN" SKIP.

            PUT STREAM REPORTE "^FO20,80^ACN, 40,10" SKIP.
            PUT STREAM REPORTE "^FVCD DESPACHO : " + tt-w-report-zebra.Campo-C[4] + "^FS" FORMAT 'x(60)' SKIP.
            PUT STREAM REPORTE "^FO20,130^A0,40,28" SKIP.
            PUT STREAM REPORTE "^FV" + x-cliente1 + "^FS" FORMAT 'x(50)' SKIP.
            PUT STREAM REPORTE "^FO20,180^A0,40,28" SKIP.
            PUT STREAM REPORTE "^FV" + x-cliente2  + "^FS" FORMAT 'x(50)' SKIP.
            PUT STREAM REPORTE "^FO20,230^ACN, 40,10" SKIP.
            PUT STREAM REPORTE "^FVDISTRITO : " + tt-w-report-zebra.Campo-C[8] + "^FS" FORMAT 'x(60)' SKIP.
            PUT STREAM REPORTE "^FO20,280^ACN, 40,10" SKIP.
            PUT STREAM REPORTE "^FVDEPT/PROV : " + tt-w-report-zebra.Campo-C[6] + " / " + tt-w-report-zebra.Campo-C[7] + "^FS" FORMAT 'x(60)' SKIP.

            /* Logo CONTINENTAL */
            PUT STREAM REPORTE "^FO485,155" SKIP.
            RUN packing-list-zebra-logo.

            PUT STREAM REPORTE "^LRY" SKIP.
            PUT STREAM REPORTE "^FO10,340" SKIP.
            PUT STREAM REPORTE "^GB790,40,40^FS" SKIP.
            PUT STREAM REPORTE "^FO20,341^AS" SKIP.
            PUT STREAM REPORTE "^FDDESCRIPCION^FS" SKIP.
            PUT STREAM REPORTE "^FO480,340^AS" SKIP.
            PUT STREAM REPORTE "^FDCODIGO^FS" SKIP.
            PUT STREAM REPORTE "^FO620,340^AS" SKIP.
            PUT STREAM REPORTE "^FDQTY^FS" SKIP.
            PUT STREAM REPORTE "^FO710,340^AS" SKIP.
            PUT STREAM REPORTE "^FDPESO^FS" SKIP.
            PUT STREAM REPORTE "^LRN" SKIP.

            x-imp-header = NO.
            x-fila = 381.
            x-reg = 1.
            x-peso = 0.
        END.
        /*
        ^ACN, 30,10
        ^A0, 30,20
        */
        PUT STREAM REPORTE "^FO10," + STRING(x-fila)  + "^GB790," + STRING(x-altura) + ",3^FS" FORMAT 'x(80)' SKIP.
        PUT STREAM REPORTE "^FO15," + STRING(x-fila + 12) + "^A0, 30,20" FORMAT 'x(80)' SKIP.
        PUT STREAM REPORTE "^FV" + substring(tt-w-report-zebra.Campo-C[9],1,46) + "^FS" FORMAT 'x(50)' SKIP.

        PUT STREAM REPORTE "^FO480," + STRING(x-fila + 2) + "^GB3," + STRING(x-altura - 5) + ",3^FS" FORMAT 'x(80)' SKIP.
        PUT STREAM REPORTE "^FO500," + STRING(x-fila + 12) +  "^A0, 30,20" FORMAT 'x(80)' SKIP.
        PUT STREAM REPORTE "^FV" + substring(tt-w-report-zebra.Campo-C[10],1,18) + "^FS" FORMAT 'x(50)' SKIP.

        PUT STREAM REPORTE "^FO580," + STRING(x-fila + 2) + "^GB3," + STRING(x-altura - 5) + ",3^FS" FORMAT 'x(80)' SKIP.
        PUT STREAM REPORTE "^FO620," + STRING(x-fila + 12) + "^A0, 30,20" FORMAT 'x(80)' SKIP.
        PUT STREAM REPORTE "^FV" + STRING(tt-w-report-zebra.Campo-i[1],">>>>9.99") + "^FS" FORMAT 'x(80)' SKIP.

        PUT STREAM REPORTE "^FO690," + STRING(x-fila + 2) + "^GB3," + STRING(x-altura - 5) + ",3^FS" FORMAT 'x(80)' SKIP.
        PUT STREAM REPORTE "^FO730," + STRING(x-fila + 12) + "^A0, 30,20" FORMAT 'x(80)' SKIP.
        PUT STREAM REPORTE "^FV" + STRING(tt-w-report-zebra.Campo-f[1],">>>>9.99") + "^FS" FORMAT 'x(80)' SKIP.

        x-peso = x-peso + tt-w-report-zebra.Campo-f[1].

        IF x-reg >= x-regs-x-pag OR LAST-OF(tt-w-report-zebra.llave-C) THEN DO:

            PUT STREAM REPORTE "^FO20," + STRING(x-fila + 55) + "^ACN, 40,10" FORMAT 'x(50)' SKIP.
            PUT STREAM REPORTE "^FVHPK : " + tt-w-report-zebra.Campo-C[11] + ",   Hoja : " + STRING(x-pag) + " de " + STRING(x-tot-pags) + "^FS" FORMAT 'x(80)' SKIP.        

            PUT STREAM REPORTE "^LRY" SKIP.
            PUT STREAM REPORTE "^FO450," + STRING(x-fila + 55) FORMAT 'x(50)' SKIP.
            PUT STREAM REPORTE "^GB340,40,40^FS" SKIP.
            PUT STREAM REPORTE "^FO460," + STRING(x-fila + 55) + "^AS" FORMAT 'x(50)' SKIP.
            PUT STREAM REPORTE "^FD" + REPLACE(tt-w-report-zebra.llave-c,"HPK-","") + "^FS" FORMAT 'x(50)' SKIP.
            PUT STREAM REPORTE "^LRN" SKIP.

            x-fila = x-fila + 110.

            PUT STREAM REPORTE "^FO20," + STRING(x-fila) + "^ACN, 40,10" FORMAT 'x(80)' SKIP.
            PUT STREAM REPORTE "^FVPESO PAGINA : " + STRING(x-peso,">>>,>>9.99") + " Kgrs^FS" FORMAT 'x(50)' SKIP.
            PUT STREAM REPORTE "^FO20," + STRING(x-fila + 50) + "^ACN, 40,10" FORMAT 'x(80)' SKIP.
            PUT STREAM REPORTE "^FVCHK : " + SUBSTRING(tt-w-report-zebra.Campo-C[12],1,40) + "^FS" FORMAT 'x(80)' SKIP.

            PUT STREAM REPORTE "^FO20," + STRING(x-fila + 95) FORMAT 'x(60)' SKIP.
            PUT STREAM REPORTE "^BCN,80,Y,N,Y,N" SKIP.
            PUT STREAM REPORTE "^FD" + tt-w-report-zebra.Campo-C[3] + "^FS" FORMAT 'x(80)' SKIP.

            PUT STREAM REPORTE "^FO420," + STRING(x-fila + 95) FORMAT 'x(80)' SKIP.
            PUT STREAM REPORTE "^BCN,80,Y,N,Y,N" SKIP.
            PUT STREAM REPORTE "^FD" + tt-w-report-zebra.Campo-C[11] + "^FS" FORMAT 'x(80)' SKIP.


            PUT STREAM REPORTE "^XZ" SKIP.

            x-imp-header = YES.        

            x-pag = x-pag + 1.
        END.

        x-fila = x-fila + 45.
        x-reg = x-reg + 1.    

    END.
END.

/*
x-imp-header = YES.
x-regs-x-pag = 17.
x-pag = 1.
x-tot-pags = TRUNCATE(x-cantidad-sku / x-regs-x-pag,0).
x-altura = 45.

IF (x-cantidad-sku MODULO x-regs-x-pag) > 0 THEN x-tot-pags = x-tot-pags + 1.

FOR EACH tt-w-report-zebra NO-LOCK BREAK BY llave-C :

    IF FIRST-OF(llave-C) THEN DO:
        x-imp-header = YES.        
    END.

    IF x-imp-header = YES THEN DO:

        x-cliente1 = tt-w-report-zebra.Campo-C[5].
        IF LENGTH(tt-w-report-zebra.Campo-C[5]) > 50 THEN DO:
            x-cliente1 = SUBSTRING(tt-w-report-zebra.Campo-C[5],1,50).
            x-cliente2 = SUBSTRING(tt-w-report-zebra.Campo-C[5],50).
        END.

        PUT STREAM REPORTE "^XA^LH010,010" SKIP.
        PUT STREAM REPORTE "^XA^LRY" SKIP.

        PUT STREAM REPORTE "^FO10,23" SKIP.
        PUT STREAM REPORTE "^GB790,40,40^FS" SKIP.
        PUT STREAM REPORTE "^FO20,23^AS" SKIP.
        PUT STREAM REPORTE "^FD" + tt-w-report-zebra.Campo-C[2] + " " + tt-w-report-zebra.Campo-C[3] + "^FS" FORMAT 'x(60)' SKIP.
        PUT STREAM REPORTE "^FO500,23^AS" SKIP.
        PUT STREAM REPORTE "^FD" + STRING(NOW,"99/99/9999 HH:MM:SS") + "^FS" FORMAT 'x(50)' SKIP.

        PUT STREAM REPORTE "^FO20,80^ACN, 40,10" SKIP.
        PUT STREAM REPORTE "^FVCD DESPACHO : " + tt-w-report-zebra.Campo-C[4] + "^FS" FORMAT 'x(60)' SKIP.
        PUT STREAM REPORTE "^FO20,130^A0,40,28" SKIP.
        PUT STREAM REPORTE "^FV" + x-cliente1 + "^FS" FORMAT 'x(50)' SKIP.
        PUT STREAM REPORTE "^FO20,180^A0,40,28" SKIP.
        PUT STREAM REPORTE "^FV" + x-cliente2  + "^FS" FORMAT 'x(50)' SKIP.
        PUT STREAM REPORTE "^FO20,230^ACN, 40,10" SKIP.
        PUT STREAM REPORTE "^FVDISTRITO : " + tt-w-report-zebra.Campo-C[8] + "^FS" FORMAT 'x(60)' SKIP.
        PUT STREAM REPORTE "^FO20,280^ACN, 40,10" SKIP.
        PUT STREAM REPORTE "^FVDEPT/PROV : " + tt-w-report-zebra.Campo-C[6] + " / " + tt-w-report-zebra.Campo-C[7] + "^FS" FORMAT 'x(60)' SKIP.

        PUT STREAM REPORTE "^FO10,340" SKIP.
        PUT STREAM REPORTE "^GB790,40,40^FS" SKIP.
        PUT STREAM REPORTE "^FO20,341^AS" SKIP.
        PUT STREAM REPORTE "^FDDESCRIPCION^FS" SKIP.
        PUT STREAM REPORTE "^FO400,340^AS" SKIP.
        PUT STREAM REPORTE "^FDMARCA^FS" SKIP.
        PUT STREAM REPORTE "^FO600,340^AS" SKIP.
        PUT STREAM REPORTE "^FDQTY^FS" SKIP.
        PUT STREAM REPORTE "^FO710,340^AS" SKIP.
        PUT STREAM REPORTE "^FDPESO^FS" SKIP.


        x-imp-header = NO.
        x-fila = 381.
        x-reg = 1.
        x-peso = 0.
    END.
    /*
    ^ACN, 30,10
    ^A0, 30,20
    */
    PUT STREAM REPORTE "^FO10," + STRING(x-fila)  + "^GB790," + STRING(x-altura) + ",3^FS" FORMAT 'x(80)' SKIP.
    PUT STREAM REPORTE "^FO15," + STRING(x-fila + 12) + "^A0, 30,20" FORMAT 'x(80)' SKIP.
    PUT STREAM REPORTE "^FV" + substring(tt-w-report-zebra.Campo-C[9],1,36) + "^FS" FORMAT 'x(50)' SKIP.
    
    PUT STREAM REPORTE "^FO390," + STRING(x-fila + 2) + "^GB3," + STRING(x-altura - 5) + ",3^FS" FORMAT 'x(80)' SKIP.
    PUT STREAM REPORTE "^FO400," + STRING(x-fila + 12) +  "^A0, 30,20" FORMAT 'x(80)' SKIP.
    PUT STREAM REPORTE "^FV" + substring(tt-w-report-zebra.Campo-C[10],1,18) + "^FS" FORMAT 'x(50)' SKIP.

    PUT STREAM REPORTE "^FO580," + STRING(x-fila + 2) + "^GB3," + STRING(x-altura - 5) + ",3^FS" FORMAT 'x(80)' SKIP.
    PUT STREAM REPORTE "^FO620," + STRING(x-fila + 12) + "^A0, 30,20" FORMAT 'x(80)' SKIP.
    PUT STREAM REPORTE "^FV" + STRING(tt-w-report-zebra.Campo-i[1],">>>>9.99") + "^FS" FORMAT 'x(80)' SKIP.

    PUT STREAM REPORTE "^FO690," + STRING(x-fila + 2) + "^GB3," + STRING(x-altura - 5) + ",3^FS" FORMAT 'x(80)' SKIP.
    PUT STREAM REPORTE "^FO730," + STRING(x-fila + 12) + "^A0, 30,20" FORMAT 'x(80)' SKIP.
    PUT STREAM REPORTE "^FV" + STRING(tt-w-report-zebra.Campo-f[1],">>>>9.99") + "^FS" FORMAT 'x(80)' SKIP.

    x-peso = x-peso + tt-w-report-zebra.Campo-f[1].

    IF x-reg >= x-regs-x-pag OR LAST-OF(llave-C) THEN DO:

        PUT STREAM REPORTE "^FO20," + STRING(x-fila + 55) + "^ACN, 40,10" FORMAT 'x(50)' SKIP.
        PUT STREAM REPORTE "^FVHPK : " + tt-w-report-zebra.Campo-C[11] + ",   Hoja : " + STRING(x-pag) + " de " + STRING(x-tot-pags) + "^FS" FORMAT 'x(80)' SKIP.        

        PUT STREAM REPORTE "^FO450," + STRING(x-fila + 55) FORMAT 'x(50)' SKIP.
        PUT STREAM REPORTE "^GB340,40,40^FS" SKIP.
        PUT STREAM REPORTE "^FO460," + STRING(x-fila + 55) + "^AS" FORMAT 'x(50)' SKIP.
        PUT STREAM REPORTE "^FD" + REPLACE(llave-c,"HPK-","") + "^FS" FORMAT 'x(50)' SKIP.

        x-fila = x-fila + 110.

        PUT STREAM REPORTE "^FO20," + STRING(x-fila) + "^ACN, 40,10" FORMAT 'x(80)' SKIP.
        PUT STREAM REPORTE "^FVPESO PAGINA : " + STRING(x-peso,">>>,>>9.99") + " Kgrs^FS" FORMAT 'x(50)' SKIP.
        PUT STREAM REPORTE "^FO20," + STRING(x-fila + 50) + "^ACN, 40,10" FORMAT 'x(80)' SKIP.
        PUT STREAM REPORTE "^FVCHK : " + SUBSTRING(tt-w-report-zebra.Campo-C[12],1,40) + "^FS" FORMAT 'x(80)' SKIP.

        PUT STREAM REPORTE "^FO20," + STRING(x-fila + 95) FORMAT 'x(60)' SKIP.
        PUT STREAM REPORTE "^BCN,80,Y,N,Y,N" SKIP.
        PUT STREAM REPORTE "^FD" + tt-w-report-zebra.Campo-C[3] + "^FS" FORMAT 'x(80)' SKIP.

        PUT STREAM REPORTE "^FO420," + STRING(x-fila + 95) FORMAT 'x(80)' SKIP.
        PUT STREAM REPORTE "^BCN,80,Y,N,Y,N" SKIP.
        PUT STREAM REPORTE "^FD" + tt-w-report-zebra.Campo-C[11] + "^FS" FORMAT 'x(80)' SKIP.


        PUT STREAM REPORTE "^XZ" SKIP.

        x-imp-header = YES.        

        x-pag = x-pag + 1.
    END.

    x-fila = x-fila + 45.
    x-reg = x-reg + 1.    

END.
*/

OUTPUT STREAM REPORTE CLOSE.

END PROCEDURE.

/*         x-Orden_hpk = chktareas.nroped + logisdchequeo.NroPed.                                                                                      */
/*         FIND FIRST tt-w-report-zebra WHERE tt-w-report-zebra.task-no = s-task-no AND                                                                */
/*             tt-w-report-zebra.llave-c = x-Orden_hpk AND                                                                                             */
/*             tt-w-report-zebra.Campo-C[1] = logisdchequeo.CodMat EXCLUSIVE-LOCK NO-ERROR.                                                            */
/*         IF NOT AVAILABLE tt-w-report-zebra THEN DO:                                                                                                 */
/*             CREATE tt-w-report-zebra.                                                                                                               */
/*             ASSIGN tt-w-report-zebra.Task-No    = s-task-no                                                                                         */
/*             tt-w-report-zebra.Llave-c    = x-Orden_hpk                                                                                              */
/*             tt-w-report-zebra.Campo-C[1] = logisdchequeo.CodMat                                                                                     */
/*             tt-w-report-zebra.Campo-C[2] = logisdchequeo.CodPed /* O/D OTR */                                                                       */
/*             tt-w-report-zebra.Campo-C[3] = logisdchequeo.NroPed                                                                                     */
/*             tt-w-report-zebra.Campo-C[4] = x-sede                                                                                                   */
/*             tt-w-report-zebra.Campo-C[5] = x-cliente                                                                                                */
/*             tt-w-report-zebra.Campo-C[6] = x-dpto                                                                                                   */
/*             tt-w-report-zebra.Campo-C[7] = x-prov                                                                                                   */
/*             tt-w-report-zebra.Campo-C[8] = x-dist                                                                                                   */
/*             tt-w-report-zebra.Campo-C[9] = Almmmatg.DesMat                                                                                          */
/*             tt-w-report-zebra.Campo-C[10] = Almmmatg.DesMar                                                                                         */
/*             tt-w-report-zebra.Campo-C[11] = chktareas.nroped   /* No HPK */                                                                        */
/*             tt-w-report-zebra.Campo-C[12] = x-chequeador                                                                                            */
/*              .                                                                                                                                      */
/*                                                                                                                                                     */
/*             x-cantidad-sku = x-cantidad-sku + 1.                                                                                                    */
/*         END.                                                                                                                                        */
/*             ASSIGN tt-w-report-zebra.Campo-i[1] = tt-w-report-zebra.Campo-i[1] + (logisdchequeo.CanPed * logisdchequeo.factor)                      */
/*             tt-w-report-zebra.Campo-f[1] = tt-w-report-zebra.Campo-f[1] + ROUND((logisdchequeo.CanPed * logisdchequeo.factor) * Almmmatg.PesMat, 2) */
/*             .                                                                                                                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE packing-list-zebra-logo W-Win 
PROCEDURE packing-list-zebra-logo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
PUT STREAM REPORTE "^GFA,2940,2940,42,,:::::::::::::::P01MF,O03OFC,N01QF8,M03KFC7LF8,M0LFC7LFE,L07UFC,K03JF7398371DKF8,K07IFE2390311CKF8,J01JF8831019023JFE,J07IFC1002018C31E,J0JFC3046008C39EgH07EgP01FC,I01KFE046008C7E2Y03C07EgG03CM03FC,I03IFE0JF1IF8E18W01FC07Eg01FCM03FC,I07IFE0DMF0618W03FCgI01FCM03FC,I07IFC0818E00E2060CW03FCgI01FCM03FC,I0JFC00184I02I04W03FCgI03FEM03FC,I0JFC0018J02I04L07EI0F81F00IF87E03E07CI07FI0F81F007FF801FF003FC,I0JF81018J0201M07FFC01F8FFC1IF87E03F3FF803FFE00FCFFC0IFC0IFE03FC,I0JF83018L01L01JF01JFE1IF87E03JF80JF80JFE0IFC3JF03FC,I0JF03018L01L01JF81JFE1IF87E03JFC1JFC0KF0IFC7JF03FC,I0JF03018L01L03F81FC1FF1FE03FC07E03FE3FC1F81FC0FF8FF03FE00703F83FC,I0JF83018L01L07F01FE1FE0FE03FC07E03F81FC7F80FE0FF0FF01FCJ03FC3FC,I0JF81018J0201L07F00FE1FE07E03FC07E03F81FC7F80FF0FE07F01FCJ07F83FC,I0JFC00186I02I04J07F00FE1FC07E03FC07E03F81FC7KF0FC07F01FC007IF83FC,I07IFC0818IFC2020CJ0FF00FE1FC07E03FC07E03F81FC7IF8E0FC07F01FC03FE3F83FC,I07IFC081JFE2061CJ07F00FE1FC07E03FC07E03F81FC7F8J0FC07F01FC07FC3F83FC,I03IFE0FFC600FFE618J07F01FE1FC07E03FC07E03F81FC3F8J0FC07F01FC07E03F83FC,I01KFE04I08E1KFE03F83FC1FC07E03FC07E03F81FC1FC0FC0FC07F01FC0FF07F83FC,J0KF6K08C1LF03FC3F81FC07E03FC07E03F81FC1FC1FC0FC07F01FE07F0FF83FC,J0JFC3046008C19KF00JF01FC07E01FFC7E03F81FC0JF80FC07F00FFE7JFC3FC,J03JF1822019831JFC007FFC01FE0FE00FFC7E07F81FC03IF00FC07F007FE3FF1FC3FC,J01JF0C31019061JF8001FF001FC07E007FC7E03F81FC01FFC00FC07F007FC1FE0FC3FC,K07IFE6390331CJFE,L0VF,L07TFE,M0LFC7KFE,N03PFC,N01PF8,P01LF8,R03FF8,,:::::::::::::^FS" SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE packing-list-zebra-logo-borrar W-Win 
PROCEDURE packing-list-zebra-logo-borrar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

PUT STREAM REPORTE "^GFA,2940,2940,42," SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "00000000001FFFFFFF000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "0000000003FFFFFFFFFC0000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000001FFFFFFFFFFF8000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "00000003FFFFFC7FFFFFF800000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "0000000FFFFFFC7FFFFFFE00000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "0000007FFFFFFFFFFFFFFFC0000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000003FFFF7398371DFFFFF8000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000007FFFE2390311CFFFFF8000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "00001FFFF8831019023FFFFE000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "00007FFFC1002018C31E0000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "0000FFFFC3046008C39E00000000000000000000807E0000000000000000000000000000001FC0000000" SKIP.
PUT STREAM REPORTE "0001FFFFFE046008C3E200000000000000000003C07E0000000000000000000003C00000003FC0000000" SKIP.
PUT STREAM REPORTE "0003FFFE0FFFF1FFF8E18000000000000000001FC07E000000000000000000001FC00000003FC0000000" SKIP.
PUT STREAM REPORTE "0007FFFE0DFFFFFFF0618000000000000000003FC000000000000000000000001FC00000003FC0000000" SKIP.
PUT STREAM REPORTE "0007FFFC0818E00E2060C000000000000000003FC000000000000000000000001FC00000003FC0000000" SKIP.
PUT STREAM REPORTE "000FFFFC0018400020004000000000000000003FC000000000000000000000003FE00000003FC0000000" SKIP.
PUT STREAM REPORTE "000FFFFC00180000200040000007E000F81F00FFF87E03E07C0007F000F81F007FF801FF003FC0000000" SKIP.
PUT STREAM REPORTE "000FFFF81018000020100000007FFC01F8FFC1FFF87E03F3FF803FFE00FCFFC0FFFC0FFFE03FC0000000" SKIP.
PUT STREAM REPORTE "000FFFF8301800000010000001FFFF01FFFFE1FFF87E03FFFF80FFFF80FFFFE0FFFC3FFFF03FC0000000" SKIP.
PUT STREAM REPORTE "000FFFF0301800000010000001FFFF81FFFFE1FFF87E03FFFFC1FFFFC0FFFFF0FFFC7FFFF03FC0000000" SKIP.
PUT STREAM REPORTE "000FFFF0301800000010000003F81FC1FF1FE03FC07E03FE3FC1F81FC0FF8FF03FE00703F83FC0000000" SKIP.
PUT STREAM REPORTE "000FFFF8301800000010000007F01FE1FE0FE03FC07E03F81FC7F80FE0FF0FF01FC00003FC3FC0000000" SKIP.
PUT STREAM REPORTE "000FFFF8101800002010000007F00FE1FE07E03FC07E03F81FC7F80FF0FE07F01FC00007F83FC0000000" SKIP.
PUT STREAM REPORTE "000FFFFC001860002000400007F00FE1FC07E03FC07E03F81FC7FFFFF0FC07F01FC007FFF83FC0000000" SKIP.
PUT STREAM REPORTE "0007FFFC0818FFFC2020C00007F00FE1FC07E03FC07E03F81FC7FFF9E0FC07F01FC03FE3F83FC0000000" SKIP.
PUT STREAM REPORTE "0007FFFC081FFFFE2061C00007F00FE1FC07E03FC07E03F81FC7F80000FC07F01FC07FC3F83FC0000000" SKIP.
PUT STREAM REPORTE "0003FFFE0FFC600FFC61800007F01FE1FC07E03FC07E03F81FC3F80000FC07F01FC07E03F83FC0000000" SKIP.
PUT STREAM REPORTE "0001FFFFFE044008E1FFFFFE03F83FC1FC07E03FC07E03F81FC1FC0FC0FC07F01FC0FF07F83FC0000000" SKIP.
PUT STREAM REPORTE "0000FFFFF6000008C1FFFFFF03FC3F81FC07E03FC07E03F81FC1FC1FC0FC07F01FE07F0FF83FC0000000" SKIP.
PUT STREAM REPORTE "0000FFFFC3046008C19FFFFF00FFFF01FC07E01FFC7E03F81FC0FFFF80FC07F00FFE7FFFFC3FC0000000" SKIP.
PUT STREAM REPORTE "00003FFFF1822019C31FFFF8007FFC01FE0FE00FFC7E07F81FC03FFF00FC07F007FE3FF1FC3FC0000000" SKIP.
PUT STREAM REPORTE "00001FFFF0C31019061FFFF8001FF001FC07E007FC7E03F81FC01FFC00FC07F007FC1FE0FC3FC0000000" SKIP.
PUT STREAM REPORTE "000007FFFE6390331CFFFFE0000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000FFFFFFFFFFFFFFFF00000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "0000007FFFFFFFFFFFFFFE00000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "0000000FFFFFEC7FFFFFE000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000003FFFFFFFFFFC0000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000001FFFFFFFFFF80000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "00000000001FFFFFF8000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "0000000000003FF800000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "000000000000000000000000000000000000000000000000000000000000000000000000000000000000" SKIP.
PUT STREAM REPORTE "^FS" SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE packing-mi-banco W-Win 
PROCEDURE packing-mi-banco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.

DEFINE VAR x-codcot AS CHAR.
DEFINE VAR x-nrocot AS CHAR.

DEFINE VAR x-sele AS INT.

SESSION:SET-WAIT-STATE("GENERAL").

RUN ordenes-involucrados(INPUT pCodDoc, INPUT pNroDoc).     /* HPK ó O/D ó OTR */
RUN orden-despacho-en-HPKs(INPUT tt-chktareas.tcoddoc, INPUT tt-chktareas.tnrodoc). /* O/D */

/* Cuantos Bultos en total de la orden */
x-bultos = 0.
x-sele = 0.
FOR EACH tmp-w-report NO-LOCK:
    x-bultos = x-bultos + 1.
    IF tmp-w-report.campo-l[1] = YES THEN x-sele = x-sele + 1.
END.

IF x-sele <= 0 THEN DO:
    MESSAGE "Seleccione al menos un Bulto" 
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.
IF x-bultos <= 0 THEN DO:
    MESSAGE "No hay Rotulos" 
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

FIND FIRST t-tmp-w-report NO-LOCK NO-ERROR.

/* Busco la O/D */
/*   Todos son de la misma O/D */
FIND FIRST od-faccpedi WHERE od-faccpedi.codcia = s-codcia AND
                            od-faccpedi.coddoc = t-tmp-w-report.campo-c[1] AND      /* O/D */
                            od-faccpedi.nroped = t-tmp-w-report.campo-c[2] NO-LOCK NO-ERROR.
IF NOT AVAILABLE od-faccpedi THEN DO:
    MESSAGE "No existe la " + t-tmp-w-report.campo-c[1] + " " + t-tmp-w-report.campo-c[2]
        VIEW-AS ALERT-BOX INFORMATION.

    RETURN.
END.

/* Busco la PED */
FIND FIRST ped-faccpedi WHERE ped-faccpedi.codcia = s-codcia AND
                            ped-faccpedi.coddoc = od-faccpedi.codref AND      /* PED */
                            ped-faccpedi.nroped = od-faccpedi.nroref NO-LOCK NO-ERROR.

IF NOT AVAILABLE ped-faccpedi THEN DO:
    MESSAGE "No existe el " + od-faccpedi.codref + " " + od-faccpedi.nroref
        VIEW-AS ALERT-BOX INFORMATION.

    RETURN.
END.

/* Busco la COT */
FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                            faccpedi.coddoc = ped-faccpedi.codref AND      /* COT */
                            faccpedi.nroped = ped-faccpedi.nroref NO-LOCK NO-ERROR.

IF NOT AVAILABLE faccpedi THEN DO:
    MESSAGE "No se pudo ubicar la cotizacion de la " + t-tmp-w-report.campo-c[1] + " " + t-tmp-w-report.campo-c[2]
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

x-codcot = ped-faccpedi.codref.
x-nrocot = ped-faccpedi.nroref.

/**/
EMPTY TEMP-TABLE tt-w-report.
EMPTY TEMP-TABLE rr-w-report.       /* Los Articulos */
EMPTY TEMP-TABLE pck-w-report.      /* PackingList Zebra */

DEFINE VARIABLE L-Ubica   AS LOGICAL INIT YES NO-UNDO.        
DEFINE VAR x-key2 AS CHAR.

x-key2 = STRING(TODAY,"99/99/9999") + STRING(TIME,"HH:MM:SS").

REPEAT WHILE L-Ubica:
    s-task-no = RANDOM(900000,999999).
    FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN L-Ubica = NO.
END.

IF s-task-no = 0 THEN DO:
    CORRELATIVO:
    REPEAT:
        s-task-no = RANDOM(1,999999).
        FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
        IF NOT AVAILABLE w-report THEN LEAVE CORRELATIVO.
    END.
END.

/*RUN Carga-Packing-bcp.      /* Carga los Articulos */*/
RUN carga-articulos-packing.

/* Data para el reporte */
FOR EACH t-tmp-w-report WHERE t-tmp-w-report.campo-l[1] = YES NO-LOCK :
    FOR EACH rr-w-report WHERE rr-w-report.campo-c[1] = t-tmp-w-report.campo-c[3] NO-LOCK:

        IF toggle-packing-zebra = NO THEN DO:
            CREATE w-report.
            ASSIGN
                w-report.Task-No    = s-task-no 
                w-report.Llave-C    = x-key2
                w-report.Campo-C[1] = t-tmp-w-report.campo-c[3]       /* Bulto */
                w-report.Campo-C[2] = "PEDIDO " + trim(faccpedi.ordertype)
                w-report.Campo-C[3] = trim(faccpedi.customerPurchaseOrder)
                w-report.Campo-C[4] = /*trim(faccpedi.OfficeCustomer) + " " +*/ trim(faccpedi.OfficeCustomerName)
                w-report.Campo-C[5] = trim(faccpedi.CustomerStockDepo) + " " + trim(faccpedi.CustomerStockDepoName)
                w-report.Campo-C[6] = trim(faccpedi.DeliveryGroup)
                w-report.Campo-C[7] = trim(faccpedi.OrderType)
                w-report.Campo-C[8] = trim(faccpedi.DeliveryAddress)
                w-report.Campo-C[9] = trim(faccpedi.Region3Name)
                w-report.Campo-C[10] = trim(faccpedi.Region2Name)
                w-report.Campo-C[11] = trim(faccpedi.Region1Name)
                w-report.Campo-C[12] = trim(faccpedi.ContactReceptorName)
                w-report.Campo-C[13] = "Packing " + STRING(t-tmp-w-report.campo-i[1]) + " / " + STRING(x-bultos)
            .
            /* Datos del Articulo */
            FIND FIRST facdpedi WHERE facdpedi.codcia = s-codcia AND
                                        facdpedi.coddoc = x-codcot AND
                                        facdpedi.nroped = x-nrocot AND
                                        facdpedi.codmat = rr-w-report.campo-c[2] NO-LOCK NO-ERROR.
            IF AVAILABLE facdpedi THEN DO:
                ASSIGN w-report.Campo-C[14] = trim(facdpedi.CustomerArtCode)
                        w-report.Campo-C[15] = trim(facdpedi.CustomerOldArtCode)   /* Codigo antiguo */
                        w-report.Campo-C[16] = trim(facdpedi.CustomerArtDescription)
                        w-report.Campo-f[1] = rr-w-report.campo-f[1]
                        w-report.Campo-C[17] = trim(facdpedi.CustomerUnitCode)
                        w-report.Campo-C[18] = trim(faccpedi.OfficeCustomer)   /*CustomerRequest*/
                    .
            END.
        END.
        ELSE DO:
            CREATE pck-w-report.
                ASSIGN
                    pck-w-report.Task-No    = s-task-no 
                    pck-w-report.Llave-C    = x-key2
                    pck-w-report.Campo-C[1] = t-tmp-w-report.campo-c[3]       /* Bulto */
                    pck-w-report.Campo-C[2] = "PEDIDO " + trim(faccpedi.ordertype)
                    pck-w-report.Campo-C[3] = trim(faccpedi.customerPurchaseOrder)
                    pck-w-report.Campo-C[4] = /*trim(faccpedi.OfficeCustomer) + " " +*/ trim(faccpedi.OfficeCustomerName)
                    pck-w-report.Campo-C[5] = trim(faccpedi.CustomerStockDepo) + " " + trim(faccpedi.CustomerStockDepoName)
                    pck-w-report.Campo-C[6] = trim(faccpedi.DeliveryGroup)
                    pck-w-report.Campo-C[7] = trim(faccpedi.OrderType)
                    pck-w-report.Campo-C[8] = trim(faccpedi.DeliveryAddress)
                    pck-w-report.Campo-C[9] = trim(faccpedi.Region3Name)
                    pck-w-report.Campo-C[10] = trim(faccpedi.Region2Name)
                    pck-w-report.Campo-C[11] = trim(faccpedi.Region1Name)
                    pck-w-report.Campo-C[12] = trim(faccpedi.ContactReceptorName)
                    pck-w-report.Campo-C[13] = "Packing " + STRING(t-tmp-w-report.campo-i[1]) + " / " + STRING(x-bultos)
                .
                /* Datos del Articulo */
                FIND FIRST facdpedi WHERE facdpedi.codcia = s-codcia AND
                                            facdpedi.coddoc = x-codcot AND
                                            facdpedi.nroped = x-nrocot AND
                                            facdpedi.codmat = rr-w-report.campo-c[2] NO-LOCK NO-ERROR.
                IF AVAILABLE facdpedi THEN DO:
                    ASSIGN pck-w-report.Campo-C[14] = trim(facdpedi.CustomerArtCode)
                            pck-w-report.Campo-C[15] = trim(facdpedi.CustomerOldArtCode)   /* Codigo antiguo */
                            pck-w-report.Campo-C[16] = trim(facdpedi.CustomerArtDescription)
                            pck-w-report.Campo-f[1] = rr-w-report.campo-f[1]
                            pck-w-report.Campo-C[17] = trim(facdpedi.CustomerUnitCode)
                            pck-w-report.Campo-C[18] = trim(faccpedi.OfficeCustomer)   /*CustomerRequest*/
                        .
                END.
        END.
    END.
END.

SESSION:SET-WAIT-STATE("").

IF toggle-packing-zebra = YES THEN DO:

    RUN packing-mi-banco-zebra.

    RETURN.
END.

/* Code placed here will execute PRIOR to standard behavior. */
DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */


GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'vta2/rbvta2.prl'.
RB-REPORT-NAME = 'Packing List mi banco'.
RB-INCLUDE-RECORDS = 'O'.

RB-FILTER = "w-report.task-no = " + STRING(s-task-no) +
                " and w-report.llave-c = '" + x-key2 + "'".

RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                   RB-REPORT-NAME,
                   RB-INCLUDE-RECORDS,
                   RB-FILTER,
                   RB-OTHER-PARAMETERS).



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE packing-mi-banco-zebra W-Win 
PROCEDURE packing-mi-banco-zebra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST pck-w-report NO-LOCK NO-ERROR.

IF NOT AVAILABLE pck-w-report THEN DO:
    MESSAGE "No hay data a Imprimir" VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.


DEFINE VAR x-papel AS LOG.

x-papel = YES.

IF x-papel = YES THEN DO:
    DEFINE VAR rpta AS LOG.

    SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
    IF rpta = NO THEN RETURN.

    OUTPUT STREAM REPORTE TO PRINTER.
END.
ELSE DO:
    DEFINE VAR x-file-zpl AS CHAR.

    x-file-zpl = SESSION:TEMP-DIRECTORY + "PackingList.txt".

    OUTPUT STREAM REPORTE TO VALUE(x-file-zpl).
END.

DEFINE VAR x-paginas AS INT.
DEFINE VAR x-pagina AS INT.
DEFINE VAR x-linea AS INT.
DEFINE VAR x-lineas-x-pag AS INT.

DEFINE VAR x-height-row AS INT.
DEFINE VAR x-row-ini1 AS INT.
DEFINE VAR x-row-ini2 AS INT.

DEFINE VAR x-registros AS INT.
DEFINE VAR x-registro AS INT.

DEFINE VAR x-sku AS CHAR.
DEFINE VAR x-descripcion AS CHAR.
DEFINE VAR x-cantidad AS DEC.
DEFINE VAR x-um AS CHAR.

x-lineas-x-pag = 13.
x-pagina = 0.
x-linea = 9999999.
x-registros = 0.

FOR EACH pck-w-report NO-LOCK:
    x-registros = x-registros + 1.
END.

x-paginas = TRUNCATE(x-registros / x-lineas-x-pag ,0).
IF (x-registros MODULO x-lineas-x-pag) > 0 THEN x-paginas = x-paginas + 1.

/*REPEAT x-registro = 1 TO x-registros:*/

FOR EACH pck-w-report NO-LOCK BY pck-w-report.Campo-C[1] :
    IF x-linea > x-lineas-x-pag  THEN DO:
        x-pagina = x-pagina + 1.
        x-linea = 1.
        /* Imprimir cabecera */
        PUT STREAM REPORTE "^XA^LH010,010" SKIP.
        PUT STREAM REPORTE "^XA" SKIP.
        PUT STREAM REPORTE "^FT180,60" SKIP.
        PUT STREAM REPORTE "^ARN^FDFORMULARIO DE DESPACHO^FS" SKIP.
        
        PUT STREAM REPORTE "^FT600,40" SKIP.
        PUT STREAM REPORTE "^AQN^FD".
        PUT STREAM REPORTE "FECHA : " + STRING(TODAY,"99/99/9999") + "^FS" FORMAT 'x(25)' SKIP.
        PUT STREAM REPORTE "^FT600,70" SKIP.
        PUT STREAM REPORTE "^AQN^FD".
        PUT STREAM REPORTE "PAG : " + STRING(x-pagina,">>9") + " / " + STRING(x-paginas,">>9") FORMAT 'x(25)' SKIP.
        PUT STREAM REPORTE "^FS" SKIP.
        
        PUT STREAM REPORTE "^FO10,75^GB790,50,3^FS" SKIP.
        PUT STREAM REPORTE "^FO170,75^GB1,50,3^FS" SKIP.
        PUT STREAM REPORTE "^FO640,75^GB1,50,3^FS" SKIP.
        PUT STREAM REPORTE "^FO730,75^GB1,50,3^FS" SKIP.
        PUT STREAM REPORTE "^FT80,110" SKIP.
        PUT STREAM REPORTE "^AQN^FDSKU^FS" SKIP.
        PUT STREAM REPORTE "^FT320,110" SKIP.
        PUT STREAM REPORTE "^AQN^FDMATERIAL^FS" SKIP.
        PUT STREAM REPORTE "^FT660,110" SKIP.
        PUT STREAM REPORTE "^AQN^FDCANT.^FS" SKIP.
        PUT STREAM REPORTE "^FT740,110" SKIP.
        PUT STREAM REPORTE "^AQN^FDU.M.^FS" SKIP.

        x-height-row = 0.
        x-row-ini1 = 122.
        x-row-ini2 = 150.
    END.
    /*
    x-sku = STRING(x-registro,"999999999999999999").
    x-descripcion = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX".
    x-cantidad = 99999.99.
    x-um = "XXXXXX".
    */
    x-sku           = pck-w-report.Campo-C[14].
    x-descripcion   = pck-w-report.Campo-C[16].
    x-um            = pck-w-report.Campo-C[17].
    x-cantidad      = pck-w-report.Campo-F[1].

    IF LENGTH(x-descripcion) > 35 THEN x-descripcion = SUBSTRING(x-descripcion,1,35).

    x-row-ini1 = x-row-ini1 + x-height-row.
    x-row-ini2 = x-row-ini2 + x-height-row.

    PUT STREAM REPORTE "^FO10," + STRING(x-row-ini1) + "^GB790,40,3^FS" FORMAT 'X(100)' SKIP.
    PUT STREAM REPORTE "^FO170," + STRING(x-row-ini1) + "^GB1,40,3^FS" FORMAT 'X(100)' SKIP.
    PUT STREAM REPORTE "^FO640," + STRING(x-row-ini1) + "^GB1,40,3^FS" FORMAT 'X(100)'  SKIP.
    PUT STREAM REPORTE "^FO730," + STRING(x-row-ini1) + "^GB1,40,3^FS" FORMAT 'X(100)'  SKIP.

    PUT STREAM REPORTE "^FT20," + STRING(x-row-ini2) FORMAT 'X(100)' SKIP.
    PUT STREAM REPORTE "^APN^FD".
    PUT STREAM REPORTE x-sku FORMAT 'x(18)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FT180," + STRING(x-row-ini2) FORMAT 'X(100)' SKIP.
    PUT STREAM REPORTE "^AQN^FD".
    PUT STREAM REPORTE x-descripcion FORMAT 'x(35)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FT660," + STRING(x-row-ini2) FORMAT 'X(100)' SKIP.
    PUT STREAM REPORTE "^APN^FD".
    PUT STREAM REPORTE x-cantidad FORMAT ">>,>>9.99" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FT740," + STRING(x-row-ini2) FORMAT 'X(100)' SKIP.
    PUT STREAM REPORTE "^APN^FD".
    PUT STREAM REPORTE x-um FORMAT 'x(6)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.    

    x-linea = x-linea + 1.
    x-height-row = 37.
    IF x-linea > x-lineas-x-pag  THEN DO:
        /* Pie de Pagina */
        PUT STREAM REPORTE "^XZ" SKIP.
    END.
END.

PUT STREAM REPORTE "^XZ" SKIP.

OUTPUT STREAM REPORTE CLOSE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE packing-mi-bancoXXXX W-Win 
PROCEDURE packing-mi-bancoXXXX :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.

DEFINE VAR x-codcot AS CHAR.
DEFINE VAR x-nrocot AS CHAR.

DEFINE VAR x-sele AS INT.

x-bultos-od = 0.

SESSION:SET-WAIT-STATE("GENERAL").

RUN ordenes-involucrados(INPUT pCodDoc, INPUT pNroDoc).     /* HPK ó O/D ó OTR */
RUN orden-despacho-en-HPKs(INPUT tt-chktareas.tcoddoc, INPUT tt-chktareas.tnrodoc). /* O/D */

/* Cuantos Bultos en total de la orden */
x-bultos = 0.
x-sele = 0.
FOR EACH tmp-w-report NO-LOCK:
    x-bultos = x-bultos + 1.
    IF tmp-w-report.campo-l[1] = YES THEN x-sele = x-sele + 1.
END.

IF x-sele <= 0 THEN DO:
    MESSAGE "Seleccione al menos un Bulto" 
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.
IF x-bultos <= 0 THEN DO:
    MESSAGE "No hay Rotulos" 
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

FIND FIRST t-tmp-w-report NO-LOCK NO-ERROR.

/* Busco la O/D */
/*   Todos son de la misma O/D */
FIND FIRST od-faccpedi WHERE od-faccpedi.codcia = s-codcia AND
                            od-faccpedi.coddoc = t-tmp-w-report.campo-c[1] AND      /* O/D */
                            od-faccpedi.nroped = t-tmp-w-report.campo-c[2] NO-LOCK NO-ERROR.
IF NOT AVAILABLE od-faccpedi THEN DO:
    MESSAGE "No existe la " + t-tmp-w-report.campo-c[1] + " " + t-tmp-w-report.campo-c[2]
        VIEW-AS ALERT-BOX INFORMATION.

    RETURN.
END.

/* Busco la PED */
FIND FIRST ped-faccpedi WHERE ped-faccpedi.codcia = s-codcia AND
                            ped-faccpedi.coddoc = od-faccpedi.codref AND      /* PED */
                            ped-faccpedi.nroped = od-faccpedi.nroref NO-LOCK NO-ERROR.

IF NOT AVAILABLE ped-faccpedi THEN DO:
    MESSAGE "No existe el " + od-faccpedi.codref + " " + od-faccpedi.nroref
        VIEW-AS ALERT-BOX INFORMATION.

    RETURN.
END.

/* Busco la COT */
FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                            faccpedi.coddoc = ped-faccpedi.codref AND      /* COT */
                            faccpedi.nroped = ped-faccpedi.nroref NO-LOCK NO-ERROR.

IF NOT AVAILABLE faccpedi THEN DO:
    MESSAGE "No se pudo ubicar la cotizacion de la " + t-tmp-w-report.campo-c[1] + " " + t-tmp-w-report.campo-c[2]
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

x-codcot = ped-faccpedi.codref.
x-nrocot = ped-faccpedi.nroref.

/**/
EMPTY TEMP-TABLE tt-w-report.
EMPTY TEMP-TABLE rr-w-report.       /* Los Articulos */
EMPTY TEMP-TABLE pck-w-report.      /* PackingList Zebra */

DEFINE VARIABLE L-Ubica   AS LOGICAL INIT YES NO-UNDO.        
DEFINE VAR x-key2 AS CHAR.

x-key2 = STRING(TODAY,"99/99/9999") + STRING(TIME,"HH:MM:SS").

REPEAT WHILE L-Ubica:
    s-task-no = RANDOM(900000,999999).
    FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN L-Ubica = NO.
END.

IF s-task-no = 0 THEN DO:
    CORRELATIVO:
    REPEAT:
        s-task-no = RANDOM(1,999999).
        FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
        IF NOT AVAILABLE w-report THEN LEAVE CORRELATIVO.
    END.
END.

/* RUN Carga-Packing-bcp.      /* Carga los Articulos */*/
RUN carga-articulos-packing.

IF toggle-packing-zebra = YES THEN DO:
    FOR EACH t-tmp-w-report WHERE t-tmp-w-report.campo-l[1] = YES NO-LOCK :
        FOR EACH rr-w-report WHERE rr-w-report.campo-c[1] = t-tmp-w-report.campo-c[3] NO-LOCK:
            CREATE pck-w-report.
                ASSIGN
                    pck-w-report.Task-No    = s-task-no 
                    pck-w-report.Llave-C    = x-key2
                    pck-w-report.Campo-C[1] = t-tmp-w-report.campo-c[3]       /* Bulto */
                    pck-w-report.Campo-C[2] = "PEDIDO " + trim(faccpedi.ordertype)
                    pck-w-report.Campo-C[3] = trim(faccpedi.customerPurchaseOrder)
                    pck-w-report.Campo-C[4] = /*trim(faccpedi.OfficeCustomer) + " " +*/ trim(faccpedi.OfficeCustomerName)
                    pck-w-report.Campo-C[5] = trim(faccpedi.CustomerStockDepo) + " " + trim(faccpedi.CustomerStockDepoName)
                    pck-w-report.Campo-C[6] = trim(faccpedi.DeliveryGroup)
                    pck-w-report.Campo-C[7] = trim(faccpedi.OrderType)
                    pck-w-report.Campo-C[8] = trim(faccpedi.DeliveryAddress)
                    pck-w-report.Campo-C[9] = trim(faccpedi.Region3Name)
                    pck-w-report.Campo-C[10] = trim(faccpedi.Region2Name)
                    pck-w-report.Campo-C[11] = trim(faccpedi.Region1Name)
                    pck-w-report.Campo-C[12] = trim(faccpedi.ContactReceptorName)
                    pck-w-report.Campo-C[13] = "Packing " + STRING(t-tmp-w-report.campo-i[1]) + " / " + STRING(x-bultos)
                .
                /* Datos del Articulo */
                FIND FIRST facdpedi WHERE facdpedi.codcia = s-codcia AND
                                            facdpedi.coddoc = x-codcot AND
                                            facdpedi.nroped = x-nrocot AND
                                            facdpedi.codmat = rr-w-report.campo-c[2] NO-LOCK NO-ERROR.
                IF AVAILABLE facdpedi THEN DO:
                    ASSIGN pck-w-report.Campo-C[14] = trim(facdpedi.CustomerArtCode)
                            pck-w-report.Campo-C[15] = trim(facdpedi.CustomerOldArtCode)   /* Codigo antiguo */
                            pck-w-report.Campo-C[16] = trim(facdpedi.CustomerArtDescription)
                            pck-w-report.Campo-f[1] = rr-w-report.campo-f[1]
                            pck-w-report.Campo-C[17] = trim(facdpedi.CustomerUnitCode)
                            pck-w-report.Campo-C[18] = trim(faccpedi.OfficeCustomer)   /*CustomerRequest*/
                        .
                END.
        END.
    END.
END.
ELSE DO:    
    FOR EACH rr-w-report NO-LOCK:
        CREATE w-report.
        ASSIGN
            w-report.Task-No    = s-task-no 
            w-report.Llave-C    = x-key2
            w-report.Campo-C[1] = "TODA LA O/D"       /* Bulto */
            w-report.Campo-C[2] = "PEDIDO " + trim(faccpedi.ordertype)
            w-report.Campo-C[3] = trim(faccpedi.customerPurchaseOrder)
            w-report.Campo-C[4] = /*trim(faccpedi.OfficeCustomer) + " " +*/ trim(faccpedi.OfficeCustomerName)
            w-report.Campo-C[5] = trim(faccpedi.CustomerStockDepo) + " " + trim(faccpedi.CustomerStockDepoName)
            w-report.Campo-C[6] = trim(faccpedi.DeliveryGroup)
            w-report.Campo-C[7] = trim(faccpedi.OrderType)
            w-report.Campo-C[8] = trim(faccpedi.DeliveryAddress)
            w-report.Campo-C[9] = trim(faccpedi.Region3Name)
            w-report.Campo-C[10] = trim(faccpedi.Region2Name)
            w-report.Campo-C[11] = trim(faccpedi.Region1Name)
            w-report.Campo-C[12] = trim(faccpedi.ContactReceptorName)
            w-report.Campo-C[13] = "Bultos de la 0/D " + STRING(x-bultos-od)
            /*w-report.Campo-C[13] = "Packing " + STRING(t-tmp-w-report.campo-i[1]) + " / " + STRING(x-bultos)*/
        .
        /* Datos del Articulo */
        FIND FIRST facdpedi WHERE facdpedi.codcia = s-codcia AND
                                    facdpedi.coddoc = x-codcot AND
                                    facdpedi.nroped = x-nrocot AND
                                    facdpedi.codmat = rr-w-report.campo-c[2] NO-LOCK NO-ERROR.
        IF AVAILABLE facdpedi THEN DO:
            ASSIGN w-report.Campo-C[14] = trim(facdpedi.CustomerArtCode)
                    w-report.Campo-C[15] = trim(facdpedi.CustomerOldArtCode)   /* Codigo antiguo */
                    w-report.Campo-C[16] = trim(facdpedi.CustomerArtDescription)
                    w-report.Campo-f[1] = rr-w-report.campo-f[1]
                    w-report.Campo-C[17] = trim(facdpedi.CustomerUnitCode)
                    w-report.Campo-C[18] = trim(faccpedi.OfficeCustomer)   /*CustomerRequest*/
                .
        END.
    END.
END.

SESSION:SET-WAIT-STATE("").

IF toggle-packing-zebra = YES THEN DO:

    RUN packing-mi-banco-zebra.

    RETURN.
END.

/* Code placed here will execute PRIOR to standard behavior. */
DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */


GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'vta2/rbvta2.prl'.
RB-REPORT-NAME = 'Packing List mi banco'.
RB-INCLUDE-RECORDS = 'O'.

RB-FILTER = "w-report.task-no = " + STRING(s-task-no) +
                " and w-report.llave-c = '" + x-key2 + "'".

RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                   RB-REPORT-NAME,
                   RB-INCLUDE-RECORDS,
                   RB-FILTER,
                   RB-OTHER-PARAMETERS).




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refrescar W-Win 
PROCEDURE refrescar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fill-in-desde fill-in-hasta.
END.

{&open-query-browse-14}

x-codped = "".
x-nroped = "".

IF AVAILABLE chktareas THEN DO:
      x-codped = chktareas.coddoc.      /* HKP */
      x-nroped = chktareas.nroped.
END.

RUN rotulos-de-las-ordenes(INPUT x-codped, INPUT x-nroped).

{&open-query-browse-16}
{&open-query-browse-18}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rotulos-de-las-ordenes W-Win 
PROCEDURE rotulos-de-las-ordenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.     /* HPK */
DEFINE INPUT PARAMETER pNroDoc AS CHAR.

DEFINE VAR x-llave AS CHAR.
DEFINE VAR x-coddoc-nrodoc AS CHAR.
DEFINE VAR x-es-valido AS LOG.
DEFINE VAR x-sec AS INT.

SESSION:SET-WAIT-STATE("GENERAL").

RUN ordenes-involucrados(INPUT pCodDOc, INPUT pNroDoc).

/**/
EMPTY TEMP-TABLE tt-w-report.
EMPTY TEMP-TABLE tmp-w-report.

x-coddoc-nrodoc = pCodDoc + "-" + pNroDoc.

x-sec = 0.
FOR EACH ttOrdenes :
    FOR EACH controlOD WHERE controlOD.codcia = s-codcia AND
                                controlOD.coddoc = ttOrdenes.tcoddoc AND
                                controlOD.nrodoc =ttOrdenes.tnrodoc NO-LOCK:
        x-sec = x-sec + 1.

        x-es-valido = YES.
        IF pCodDoc = 'HPK' THEN DO:
            x-es-valido = NO.
            IF controlOD.nroetq BEGINS x-coddoc-nrodoc THEN DO:
                x-es-valido = YES.
            END.
        END.
        IF x-es-valido = YES THEN DO:
            CREATE tt-w-report.
                ASSIGN tt-w-report.campo-c[1] = controlOD.coddoc
                        tt-w-report.campo-c[2] = controlOD.nrodoc
                        tt-w-report.campo-c[3] = controlOD.nroetq
                        tt-w-report.campo-c[4] = controlOD.nomcli
                        tt-w-report.campo-c[5] = controlOD.codcli
                        tt-w-report.campo-f[1] = controlOD.pesart
                .
        END.
        CREATE tmp-w-report.
            ASSIGN tmp-w-report.campo-c[1] = controlOD.coddoc
                    tmp-w-report.campo-c[2] = controlOD.nrodoc
                    tmp-w-report.campo-c[3] = controlOD.nroetq
                    tmp-w-report.campo-c[4] = controlOD.nomcli
                    tmp-w-report.campo-c[5] = controlOD.codcli
                    tmp-w-report.campo-f[1] = controlOD.pesart
                    tmp-w-report.campo-i[1] = x-sec.
    END.
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
  {src/adm/template/snd-list.i "tmp-w-report"}
  {src/adm/template/snd-list.i "tt-w-report"}
  {src/adm/template/snd-list.i "ChkTareas"}
  {src/adm/template/snd-list.i "VtaCDocu"}
  {src/adm/template/snd-list.i "tt-ChkTareas"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE terminar-orden W-Win 
PROCEDURE terminar-orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-procesoOk AS CHAR NO-UNDO.

x-procesoOk = 'Inicio'.

DEFINE BUFFER b-faccpedi FOR faccpedi.
DEFINE BUFFER b-vtacdocu FOR vtacdocu.
DEFINE BUFFER b-chktareas FOR chktareas.

GRABAR_REGISTROS:
DO TRANSACTION ON ERROR UNDO, LEAVE:
    /* Ordenes */
    x-procesoOk = "Actualizar la orden como Pase a Districion (C)". 
    FOR EACH ttOrdenes :
        FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND 
                                        b-faccpedi.coddoc = ttOrdenes.tcoddoc AND
                                        b-faccpedi.nroped = ttOrdenes.tnrodoc EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE b-faccpedi THEN DO:
            x-procesoOk = "Error al actualizar la ORDEN como pase a Distribucion".
            UNDO GRABAR_REGISTROS, LEAVE GRABAR_REGISTROS.
        END.
        ASSIGN b-faccpedi.flgsit = 'C'.
    END.

  DO:
    IF chktareas.coddoc = 'HPK' THEN DO:
        x-procesoOk = "Actualizar la orden como Cierre de Chequeo (PC)". 
        FIND FIRST b-vtacdocu WHERE b-vtacdocu.codcia = s-codcia AND 
                                        b-vtacdocu.codped = chktareas.coddoc AND
                                        b-vtacdocu.nroped = chktareas.nroped EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE b-vtacdocu THEN DO:
            x-procesoOk = "Error al actualizar la ORDEN como Cierre de Chequeo".
            UNDO GRABAR_REGISTROS, LEAVE GRABAR_REGISTROS.
        END.
        ASSIGN b-vtacdocu.flgsit = 'PC'.

    END.

    /* Tarea Observacion */
    x-procesoOk = "Ponemos la tarea como Pase a Distribucion".
    FIND FIRST b-chktareas WHERE b-chktareas.codcia = chktareas.codcia AND
                                b-chktareas.coddiv = chktareas.coddiv AND 
                                b-chktareas.coddoc = chktareas.coddoc AND
                                b-chktareas.nroped = chktareas.nroped AND
                                b-chktareas.mesa = chktareas.mesa EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE b-chktareas THEN DO:
        x-procesoOk = "Error al actualizar la tarea como Pase a Distribucion".
        UNDO GRABAR_REGISTROS, LEAVE GRABAR_REGISTROS.
    END.
    ASSIGN b-chktareas.flgest = 'C' 
        b-chktareas.fechafin = TODAY
        b-chktareas.horafin = STRING(TIME,"HH:MM:SS")
        b-chktareas.usuariofin = s-user-id NO-ERROR
    .
                                
    x-procesoOk = "OK".

  END.

END. /* TRANSACTION block */

RELEASE b-faccpedi.
RELEASE b-vtacdocu.
RELEASE b-chktareas.

IF x-procesoOk = "OK" THEN DO:
    {&open-query-browse-14}

    x-codped = "".
    x-nroped = "".
    IF AVAILABLE chktareas THEN DO:
          x-codped = chktareas.coddoc.
          x-nroped = chktareas.nroped.
    END.

    RUN recopilar-ordenes(INPUT x-nroped, INPUT x-nroped).

END.
ELSE DO:
    MESSAGE x-procesoOk.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE test-pl W-Win 
PROCEDURE test-pl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR rpta AS LOG.
SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
IF rpta = NO THEN RETURN.

OUTPUT STREAM REPORTE TO PRINTER.

PUT STREAM REPORTE "^XA^LH010,010" SKIP.
PUT STREAM REPORTE "^XA^LRY" SKIP.

PUT STREAM REPORTE "^FO10,23" SKIP.
PUT STREAM REPORTE "^GB790,40,40^FS" SKIP.
PUT STREAM REPORTE "^FO20,23^AS" SKIP.
PUT STREAM REPORTE "^FDO/D 506015435^FS" SKIP.
PUT STREAM REPORTE "^FO500,23^AS" SKIP.
PUT STREAM REPORTE "^FD24/06/2022 17:45:15^FS" SKIP.

PUT STREAM REPORTE "^FO20,80^ACN, 40,10" SKIP.
PUT STREAM REPORTE "^FVCD DESPACHO : 1234567890123456789012345678901234567890^FS" SKIP.
PUT STREAM REPORTE "^FO20,130^A0,40,28" SKIP.
PUT STREAM REPORTE "^FVINMOBILIARIA LAS PIEDRAS SOCIEDAD ANONIMA CERRADA SAC^FS" SKIP.
PUT STREAM REPORTE "^FO20,180^A0,40,28" SKIP.
PUT STREAM REPORTE "^FVY MAS NOMBRE^FS" SKIP.
PUT STREAM REPORTE "^FO20,230^ACN, 40,10" SKIP.
PUT STREAM REPORTE "^FVDISTRITO : VILLA MARIA DEL TRIUNFO^FS" SKIP.
PUT STREAM REPORTE "^FO20,280^ACN, 40,10" SKIP.
PUT STREAM REPORTE "^FVDEPT/PROV : LIMA / CERRO LARGO Y COLORADO^FS" SKIP.

PUT STREAM REPORTE "^FO10,340" SKIP.
PUT STREAM REPORTE "^GB790,40,40^FS" SKIP.
PUT STREAM REPORTE "^FO20,341^AS" SKIP.
PUT STREAM REPORTE "^FDDESCRIPCION^FS" SKIP.
PUT STREAM REPORTE "^FO400,340^AS" SKIP.
PUT STREAM REPORTE "^FDMARCA^FS" SKIP.
PUT STREAM REPORTE "^FO600,340^AS" SKIP.
PUT STREAM REPORTE "^FDQTY^FS" SKIP.
PUT STREAM REPORTE "^FO710,340^AS" SKIP.
PUT STREAM REPORTE "^FDPESO^FS" SKIP.

PUT STREAM REPORTE "^FO10,381^GB790,60,3^FS" SKIP.
PUT STREAM REPORTE "^FO360,384^GB3,54,3^FS" SKIP.
PUT STREAM REPORTE "^FO580,384^GB3,54,3^FS" SKIP.
PUT STREAM REPORTE "^FO690,384^GB3,54,3^FS" SKIP.

PUT STREAM REPORTE "^FO10,441^GB790,60,3^FS" SKIP.
PUT STREAM REPORTE "^FO360,444^GB3,54,3^FS" SKIP.
PUT STREAM REPORTE "^FO580,444^GB3,54,3^FS" SKIP.
PUT STREAM REPORTE "^FO690,444^GB3,54,3^FS" SKIP.

PUT STREAM REPORTE "^FO10,501^GB790,60,3^FS" SKIP.
PUT STREAM REPORTE "^FO360,504^GB3,54,3^FS" SKIP.
PUT STREAM REPORTE "^FO580,504^GB3,54,3^FS" SKIP.
PUT STREAM REPORTE "^FO690,504^GB3,54,3^FS" SKIP.

PUT STREAM REPORTE "^FO10,561^GB790,60,3^FS" SKIP.
PUT STREAM REPORTE "^FO10,621^GB790,60,3^FS" SKIP.
PUT STREAM REPORTE "^FO10,681^GB790,60,3^FS" SKIP.
PUT STREAM REPORTE "^FO10,741^GB790,60,3^FS" SKIP.
PUT STREAM REPORTE "^FO10,801^GB790,60,3^FS" SKIP.
PUT STREAM REPORTE "^FO10,861^GB790,60,3^FS" SKIP.
PUT STREAM REPORTE "^FO10,921^GB790,60,3^FS" SKIP.
PUT STREAM REPORTE "^FO10,981^GB790,60,3^FS" SKIP.
PUT STREAM REPORTE "^FO10,1041^GB790,60,3^FS" SKIP.
PUT STREAM REPORTE "^FO10,1101^GB790,60,3^FS" SKIP.

PUT STREAM REPORTE "^FO20,1200^ACN, 40,10" SKIP.
PUT STREAM REPORTE "^FVPESO TOTAL : 128,985.56 Kgrs^FS" SKIP.
PUT STREAM REPORTE "^FO20,1250^ACN, 40,10" SKIP.
PUT STREAM REPORTE "^FVCHK : GONZALES SEDANO FRANCISO^FS" SKIP.

PUT STREAM REPORTE "^FO20,1300" SKIP.
PUT STREAM REPORTE "^BCN,80,Y,N,Y,N" SKIP.
PUT STREAM REPORTE "^FD00000131908^FS" SKIP.

PUT STREAM REPORTE "^FO420,1300" SKIP.
PUT STREAM REPORTE "^BCN,80,Y,N,Y,N" SKIP.
PUT STREAM REPORTE "^FD814015623^FS" SKIP.


PUT STREAM REPORTE "^XZ" SKIP.

OUTPUT STREAM REPORTE CLOSE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificar-hpr-cerrada W-Win 
PROCEDURE verificar-hpr-cerrada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcod-hpr AS CHAR.
DEFINE INPUT PARAMETER pnro-hpr AS CHAR.
DEFINE OUTPUT PARAMETER pCerrado AS CHAR.

pCerrado = "OK".
DEFINE BUFFER x-vtacdocu FOR vtacdocu.

FOR EACH x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND 
                            x-vtacdocu.codped = 'HPK' AND
                            x-vtacdocu.codori = pcod-hpr AND
                            x-vtacdocu.nroori = pnro-hpr NO-LOCK:
    IF x-vtacdocu.flgsit <> 'PC' THEN pCerrado = 'NO'.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cantidad-bultos W-Win 
FUNCTION cantidad-bultos RETURNS INTEGER
  ( INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VAR x-retval AS INT INIT 0.
    DEFINE VAR x-coddoc-nrodoc AS CHAR.
    DEFINE VAR x-es-valido AS LOG.

    x-coddoc-nrodoc = pCodDoc + "-" + pNroDoc.
    
    /*
    FOR EACH x-ControlOD WHERE x-ControlOD.codcia = s-codcia AND 
                                x-controlOD.nroetq BEGINS x-coddoc-nrodoc NO-LOCK:
        
        x-es-valido = YES.
        /*
        IF pCodDoc = 'HPK' THEN DO:
            x-es-valido = NO.
            IF x-controlOD.nroetq BEGINS x-coddoc-nrodoc THEN DO:
                x-es-valido = YES.
            END.
        END.
        */
        IF x-es-valido = YES THEN x-retval = x-retval + 1.
        
    END.
    */

    /*RUN ordenes-involucrados(INPUT pCodDOc, INPUT pNroDoc).*/
    
    FOR EACH ttOrdenes :
        FOR EACH x-ControlOD WHERE x-ControlOD.codcia = s-codcia AND 
                                    x-ControlOD.coddoc = ttOrdenes.tCodDoc AND
                                    x-ControlOD.nrodoc = ttOrdenes.tnroDoc AND
                                    x-controlOD.nroetq BEGINS x-coddoc-nrodoc NO-LOCK:
            
            x-es-valido = YES.
            /*
            IF pCodDoc = 'HPK' THEN DO:
                x-es-valido = NO.
                IF x-controlOD.nroetq BEGINS x-coddoc-nrodoc THEN DO:
                    x-es-valido = YES.
                END.
            END.
            */
            IF x-es-valido = YES THEN x-retval = x-retval + 1.
            
        END.
    END.
    
    RETURN x-retval.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cantidad-sku W-Win 
FUNCTION cantidad-sku RETURNS INTEGER
  ( INPUT pCodDoc AS CHAR, INPUT pNrodoc AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VAR x-retval AS INT INIT 0.

    x-col-codorden = "".
    x-col-nroorden = "".
    x-col-nro-phr = "".

   /* RUN ordenes-involucrados(INPUT pCodDOc, INPUT pNroDoc).*/

  IF pCodDoc = 'HPK' THEN DO:

      FIND FIRST x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND
                                    x-vtacdocu.codped = pCodDoc AND 
                                    x-vtacdocu.nroped = pNroDoc NO-LOCK NO-ERROR.
                                    
      IF AVAILABLE x-vtacdocu THEN DO:
          x-col-codorden = x-vtacdocu.codref.
          x-col-nroorden = x-vtacdocu.nroref.
          x-col-nro-phr = x-vtacdocu.nroori.
      END.
      /*
      FOR EACH x-vtaddocu WHERE x-vtaddocu.codcia = s-codcia AND
                                    x-vtaddocu.codped = pCodDoc AND
                                    x-vtaddocu.nroped = pNrodoc NO-LOCK:
            x-retval = x-retval + 1.

      END.
      */
  END.
  ELSE DO:
      DEFINE BUFFER x-facdpedi FOR facdpedi.
        /*
      FOR EACH x-facdpedi WHERE x-facdpedi.codcia = s-codcia AND
                                    x-facdpedi.coddoc = pCodDoc AND
                                    x-facdpedi.nroped = pNrodoc NO-LOCK:
            x-retval = x-retval + 1.

      END.
      */
  END.

  RETURN x-retval.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION chequeador W-Win 
FUNCTION chequeador RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroPed AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

/*RUN ordenes-involucrados(INPUT pCodDOc, INPUT pNroped).*/

FIND FIRST ttOrdenes NO-ERROR.
DEFINE VAR x-retval AS CHAR INIT "".
DEFINE VAR x-dni AS CHAR INIT "".
DEFINE VAR x-origen AS CHAR INIT "".

/*IF AVAILABLE ttOrdenes THEN DO:    */

    

    IF pCodDoc = 'HPK' THEN DO:
        
        FIND FIRST x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND
                                        x-vtacdocu.codped = pCodDOc AND
                                        x-vtacdocu.nroped = pNroPEd NO-LOCK NO-ERROR.
        IF AVAILABLE x-vtacdocu THEN DO:
            IF NOT (TRUE <> (x-vtacdocu.libre_c04 > "")) THEN DO:
                x-dni = ENTRY(1,x-vtacdocu.libre_c04,"|").
                RUN logis/p-busca-por-dni.r(INPUT x-dni, OUTPUT x-retval, OUTPUT x-origen).
            END.            
        END.
    END.
    ELSE DO:        
        FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND 
                                        x-faccpedi.coddoc = ttOrdenes.tcoddoc AND 
                                        x-faccpedi.nroped = ttOrdenes.tnrodoc NO-LOCK NO-ERROR.
        IF AVAILABLE x-faccpedi THEN DO:
            IF NOT (TRUE <> (x-faccpedi.usrchq > "")) THEN DO:
                x-dni = x-faccpedi.usrchq.
                RUN logis/p-busca-por-dni.r(INPUT x-dni, OUTPUT x-retval, OUTPUT x-origen).
            END.            
        END.
    END.

    IF x-retval = "" THEN DO:
        /* buscarlo si existe en la maestra de personal */
        FIND FIRST pl-pers WHERE  pl-pers.codper = x-dni NO-LOCK NO-ERROR.
        IF  AVAILABLE pl-pers THEN DO:
            x-retval = pl-pers.patper + " " + pl-pers.matper + " " + pl-pers.nomper.
        END.
    END.
/*END.*/

RETURN x-retval.

END FUNCTION.

/*
DEF INPUT PARAMETER pDNI AS CHAR.
DEF OUTPUT PARAMETER pNombre AS CHAR.
DEF OUTPUT PARAMETER pOrigen AS CHAR.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cliente W-Win 
FUNCTION cliente RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroDOc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR x-retval AS CHAR.

IF pCodDoc = 'HPK' THEN DO:

    FIND FIRST x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND
                                    x-vtacdocu.codped = pCodDOc AND
                                    x-vtacdocu.nroped = pNrodoc NO-LOCK NO-ERROR.
    IF AVAILABL x-vtacdocu THEN x-retval = x-vtacdocu.nomcli.
END.
ELSE DO:

    
    FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                x-faccpedi.coddoc = pCoddoc AND
                                x-faccpedi.nroped = pNroDoc NO-LOCK NO-ERROR.
    IF AVAILABL x-faccpedi THEN x-retval = x-faccpedi.nomcli.
END.

RETURN x-retval.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION es-crossdocking W-Win 
FUNCTION es-crossdocking RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VAR x-retval AS CHAR INIT "NO".

  FIND FIRST x-ChkControl WHERE x-ChkControl.codcia = s-codcia AND 
                              x-ChkControl.coddiv = s-coddiv AND 
                              x-ChkControl.coddoc = pCoddoc AND 
                              x-ChkControl.nroped = pNrodoc NO-LOCK NO-ERROR.
  IF AVAILABLE x-ChkControl THEN DO:
    IF x-ChkControl.crossdocking THEN x-retval = 'SI'.
  END.


  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPeso-orden W-Win 
FUNCTION fPeso-orden RETURNS DECIMAL
  ( INPUT pCodOrden AS CHAR, INPUT pNroOrden AS CHAR, INPUT pCodHPK AS CHAR, INPUT pNroPHK AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VAR x-retval AS DEC INIT 0.
  DEFINE VAR x-bulto AS CHAR INIT "".

  FOR EACH x-vtaddocu WHERE x-vtaddocu.codcia = s-codcia AND
                            x-vtaddocu.codped = pCodOrden AND
                            x-vtaddocu.nroped = pNroOrden AND
                            x-vtaddocu.libre_c01 BEGINS x-bulto NO-LOCK:
      x-retval = x-retval + (x-vtaddocu.pesmat * x-vtaddocu.canped).
  END.

  RETURN x-retval.
/*
                    vtaddocu.pesmat = almmmatg.pesmat
                    vtaddocu.codmat = tt-articulos-pickeados.campo-c[1]
                    vtaddocu.canped = tt-articulos-pickeados.campo-f[3]                    
                    vtaddocu.factor = tt-articulos-pickeados.campo-f[2]
                    vtaddocu.libre_c01 = tt-articulos-pickeados.campo-c[5]       /* El bulto */

*/

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION get-datos-adicionales W-Win 
FUNCTION get-datos-adicionales RETURNS CHARACTER
  ( INPUT pCodDOc AS CHAR, INPUT pNroDoc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tiempo-observado W-Win 
FUNCTION tiempo-observado RETURNS CHARACTER
  ( INPUT pFecha AS DATE, INPUT pHora AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR x-tiempo AS CHAR.

    x-Tiempo = STRING(pFecha,"99/99/9999") + " " + pHora.
    /*
    RUN lib/_time-passed ( DATETIME(STRING(pFecha,"99/99/9999") + ' ' + pHora),
                             DATETIME(STRING(TODAY,"99/99/9999") + ' ' + STRING(TIME,"HH:MM:SS")), OUTPUT x-Tiempo).
    */
    

    RETURN x-tiempo.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

