&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t_gre_header NO-UNDO LIKE gre_header
       FIELD NroOD AS CHAR
       FIELD NroPHR AS CHAR
       FIELD NroHR AS CHAR
       FIELD fhAceptadoSunat as datetime
       field fhAnulacion as datetime
       field usuario_anu as char
       field cmotivo as char
       field dmotivo as char
       .



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
DEFINE INPUT PARAMETER pSelecionaAlmacenes AS CHAR NO-UNDO.

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.

DEFINE VAR lSeleccionaAlmacenes AS LOG INIT NO.
IF pSelecionaAlmacenes = 'YES' THEN lSeleccionaAlmacenes = YES.

&SCOPED-DEFINE Condicion ( ~
gre_header.m_divorigen = s-coddiv AND ~
(RADIO-SET-rspta_sunat = "TODOS" OR LOOKUP(gre_header.m_rspta_sunat, RADIO-SET-rspta_sunat, '|') > 0)  AND ~
DATE(gre_header.m_fechahorareg) >= FILL-IN-FechaReg-1 AND DATE(gre_header.m_fechahorareg) <= FILL-IN-FechaReg-2 ~
                           )
DEFINE TEMP-TABLE talmacen LIKE almacen.

DEF VAR x-NroOD AS CHAR FORMAT 'x(12)' LABEL 'Orden de Despacho' NO-UNDO.
DEF VAR x-NroHR AS CHAR FORMAT 'x(12)' LABEL 'Hoja de Ruta' NO-UNDO.
DEF VAR x-NroPHR AS CHAR FORMAT 'x(12)' LABEL 'Pre-Hoja de Ruta' NO-UNDO.
DEF VAR x-fhAceptadoSunat AS DATETIME LABEL 'Fecha/Hora Aceptado Sunat' NO-UNDO.
DEFINE VAR x-fhAnulacion AS DATETIME LABEL "Fecha/Hora Aceptado Sunat" NO-UNDO.
DEFINE VAR x-usuario_anu AS CHAR FORMAT 'x(25)' LABEL "Usuario Anulacion" NO-UNDO.
DEFINE VAR x-cmotivo  AS CHAR FORMAT 'x(25)' LABEL "Cod.Mot.Anula" NO-UNDO.
DEFINE VAR x-dmotivo  AS CHAR FORMAT 'x(100)' LABEL "Motivo Anulacion" NO-UNDO.

DEF TEMP-TABLE T-REPORTE
    FIELD fechaEmisionGuia LIKE gre_header.fechaEmisionGuia LABEL "Fecha Emisión"
    FIELD fechahora_envio_a_sunat LIKE gre_header.fechahora_envio_a_sunat LABEL "Enviado a Sunat"
    FIELD fhAceptadoSunat LIKE x-fhAceptadoSunat LABEL "Fecha/Hora aceptado por Sunat"
    FIELD nrohr LIKE x-nrohr    LABEL "# Hoja de Ruta"
    FIELD nrophr LIKE x-nrophr  LABEL "# Pre Hoja de Ruta"
    FIELD nroord LIKE x-nrood   LABEL "# Orden de Despacho"
    FIELD razonSocialDestinatario LIKE gre_header.razonSocialDestinatario LABEL "Cliente" 
    FIELD m_rspta_sunat LIKE gre_header.m_rspta_sunat LABEL "Status" 
    FIELD serieGuia LIKE gre_header.serieGuia LABEL "Serie Guia" 
    FIELD numeroGuia LIKE gre_header.numeroGuia LABEL "Correlativo" 
    FIELD descripcionMotivoTraslado LIKE gre_header.descripcionMotivoTraslado LABEL "Motivo de Traslado" 
    FIELD numeroRucTransportista LIKE gre_header.numeroRucTransportista LABEL "RucTransporte" 
    FIELD RazonSocialTransportista LIKE gre_header.RazonSocialTransportista LABEL "Transportista" 
    FIELD numeroLicencia LIKE gre_header.numeroLicencia LABEL "Licencia" 
    FIELD numeroPlacaVehiculoPrin LIKE gre_header.numeroPlacaVehiculoPrin LABEL "Placa 1" 
    FIELD numeroPlacaVehiculoSec1 LIKE gre_header.numeroPlacaVehiculoSec1 LABEL "Placa 2" 
    FIELD ubigeoPtoLLegada LIKE gre_header.ubigeoPtoLLegada LABEL "Ubigeo de Llegada" 
    FIELD direccionPtoLlegada LIKE gre_header.direccionPtoLlegada LABEL "Dirección de Llegada" 
    FIELD m_coddoc LIKE gre_header.m_coddoc LABEL "Tipo de Comprobante" 
    FIELD m_nroser LIKE gre_header.m_nroser LABEL "Serie Comprobante" 
    FIELD m_nrodoc LIKE gre_header.m_nrodoc LABEL "Correlativo Comprobante" 
    FIELD m_codmov LIKE gre_header.m_codmov LABEL "Tipo de Movimiento" 
    FIELD m_fechahorareg LIKE gre_header.m_fechahorareg LABEL "Fecha de Registro" 
    FIELD ubigeoPtoPartida LIKE gre_header.ubigeoPtoPartida LABEL "Ubigeo de Partida" 
    FIELD direccionPtoPartida LIKE gre_header.direccionPtoPartida LABEL "Dirección de Partida" 
    FIELD fhAnulacion LIKE x-fhAnulacion LABEL "Fecha de Anulacion" 
    FIELD usuario_anu LIKE x-usuario_anu    LABEL "Usuario anulacion"
    FIELD cmotivo LIKE x-cmotivo    LABEL "Cod.Motivo anulacion"
    FIELD dmotivo LIKE x-dmotivo    LABEL "Motivo anulacion"
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
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES t_gre_header gre_header

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 gre_header.fechaEmisionGuia ~
t_gre_header.fechahora_envio_a_sunat ~
t_gre_header.fhAceptadoSunat @ x-fhAceptadoSunat ~
t_gre_header.nrohr @ x-NroHR t_gre_header.nrophr @ x-NroPHR ~
t_gre_header.nrood @ x-NroOD gre_header.razonSocialDestinatario ~
gre_header.m_rspta_sunat gre_header.serieGuia gre_header.numeroGuia ~
gre_header.descripcionMotivoTraslado gre_header.numeroRucTransportista ~
gre_header.RazonSocialTransportista gre_header.numeroLicencia ~
gre_header.numeroPlacaVehiculoPrin gre_header.numeroPlacaVehiculoSec1 ~
gre_header.ubigeoPtoLLegada gre_header.direccionPtoLlegada ~
gre_header.m_coddoc gre_header.m_nroser gre_header.m_nrodoc ~
gre_header.m_codmov gre_header.m_fechahorareg gre_header.ubigeoPtoPartida ~
gre_header.direccionPtoPartida t_gre_header.fhAnulacion @ x-fhAnulacion ~
t_gre_header.usuario_anu @ x-usuario_anu t_gre_header.cmotivo @ x-cmotivo ~
t_gre_header.dmotivo @ x-dmotivo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 gre_header.serieGuia 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-2 gre_header
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-2 gre_header
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH t_gre_header NO-LOCK, ~
      FIRST gre_header WHERE gre_header.ncorrelatio = t_gre_header.ncorrelatio NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH t_gre_header NO-LOCK, ~
      FIRST gre_header WHERE gre_header.ncorrelatio = t_gre_header.ncorrelatio NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 t_gre_header gre_header
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 t_gre_header
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 gre_header


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-almacenes FILL-IN_NroHR ~
FILL-IN_NroOD FILL-IN_NroPHR FILL-IN-FechaReg-1 FILL-IN-FechaReg-2 ~
RADIO-SET-rspta_sunat BUTTON-Filtrar BUTTON-Texto BROWSE-2 RECT-1 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-msg FILL-IN-almacenes ~
FILL-IN_NroHR FILL-IN_NroOD FILL-IN_NroPHR FILL-IN-FechaReg-1 ~
FILL-IN-FechaReg-2 RADIO-SET-rspta_sunat 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Filtrar 
     LABEL "APLICAR FILTROS" 
     SIZE 20 BY 1.38
     FONT 6.

DEFINE BUTTON BUTTON-Texto 
     IMAGE-UP FILE "img/reportes.ico":U
     LABEL "Button 2" 
     SIZE 9 BY 1.88 TOOLTIP "Exportar a Texto".

DEFINE VARIABLE FILL-IN-almacenes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacenes" 
     VIEW-AS FILL-IN 
     SIZE 56 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FechaReg-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Registro Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FechaReg-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-msg AS CHARACTER FORMAT "X(256)":U INITIAL "(Vacio = Todos, varios = 11,21,01,88....)" 
      VIEW-AS TEXT 
     SIZE 35 BY .62
     FGCOLOR 12 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_NroHR AS CHARACTER FORMAT "X(256)":U 
     LABEL "# de Hoja de Ruta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_NroOD AS CHARACTER FORMAT "X(256)":U 
     LABEL "# Orden de Despacho" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_NroPHR AS CHARACTER FORMAT "X(256)":U 
     LABEL "# de PHR" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-rspta_sunat AS CHARACTER INITIAL "ACEPTADO POR SUNAT" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "ACEPTADO POR SUNAT", "ACEPTADO POR SUNAT",
"RECHAZADO POR SUNAT", "RECHAZADO POR SUNAT",
"BAJA EN SUNAT", "BAJA EN SUNAT",
"ANULADO", "ANULADO",
"OTROS", "SIN ENVIAR|CON TRANSPORTISTA|CON CORRELATIVO|ENVIADO A SUNAT|ESPERANDO RESPUESTA SUNAT",
"TODOS", "TODOS"
     SIZE 27 BY 3.5
     FONT 3 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 173 BY 4.04.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 17 BY 4.04.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      t_gre_header, 
      gre_header SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      gre_header.fechaEmisionGuia COLUMN-LABEL "Fecha Emisión" FORMAT "99/99/9999":U
      t_gre_header.fechahora_envio_a_sunat COLUMN-LABEL "Enviado a SUNAT" FORMAT "99/99/9999 HH:MM:SS":U
            WIDTH 16
      t_gre_header.fhAceptadoSunat @ x-fhAceptadoSunat COLUMN-LABEL "Aceptado Sunat" FORMAT "99/99/9999 hh:mm:ss":U
      t_gre_header.nrohr @ x-NroHR COLUMN-LABEL "# Hoja de Ruta"
            WIDTH 11.43
      t_gre_header.nrophr @ x-NroPHR COLUMN-LABEL "# Pre Hoja de Ruta"
            WIDTH 13.43
      t_gre_header.nrood @ x-NroOD COLUMN-LABEL "# Orden de Despacho"
            WIDTH 15.43
      gre_header.razonSocialDestinatario COLUMN-LABEL "Cliente" FORMAT "x(250)":U
            WIDTH 52.29
      gre_header.m_rspta_sunat COLUMN-LABEL "Status" FORMAT "x(25)":U
            WIDTH 19.43
      gre_header.serieGuia COLUMN-LABEL "Serie Guia" FORMAT ">>>>>9":U
      gre_header.numeroGuia COLUMN-LABEL "Correlativo" FORMAT "9999999999":U
      gre_header.descripcionMotivoTraslado COLUMN-LABEL "Motivo de Traslado" FORMAT "x(100)":U
            WIDTH 40
      gre_header.numeroRucTransportista COLUMN-LABEL "RucTransporte" FORMAT "x(11)":U
      gre_header.RazonSocialTransportista COLUMN-LABEL "Transportista" FORMAT "x(250)":U
            WIDTH 60
      gre_header.numeroLicencia COLUMN-LABEL "Licencia" FORMAT "x(10)":U
      gre_header.numeroPlacaVehiculoPrin COLUMN-LABEL "Placa 1" FORMAT "x(10)":U
      gre_header.numeroPlacaVehiculoSec1 COLUMN-LABEL "Placa 2" FORMAT "x(10)":U
      gre_header.ubigeoPtoLLegada COLUMN-LABEL "Ubigeo de Llegada" FORMAT "x(6)":U
      gre_header.direccionPtoLlegada COLUMN-LABEL "Dirección de Llegada" FORMAT "x(250)":U
            WIDTH 63.72
      gre_header.m_coddoc COLUMN-LABEL "Tipo de Comprobante" FORMAT "x(5)":U
      gre_header.m_nroser COLUMN-LABEL "Serie Comprobante" FORMAT "9999":U
      gre_header.m_nrodoc COLUMN-LABEL "Correlativo Comprobante" FORMAT "9999999999":U
      gre_header.m_codmov COLUMN-LABEL "Tipo de Movimiento" FORMAT ">>9":U
      gre_header.m_fechahorareg COLUMN-LABEL "Fecha de Registro" FORMAT "99/99/9999 HH:MM:SS.SSS":U
      gre_header.ubigeoPtoPartida COLUMN-LABEL "Ubigeo de Partida" FORMAT "x(6)":U
      gre_header.direccionPtoPartida COLUMN-LABEL "Dirección de Partida" FORMAT "x(250)":U
            WIDTH 43.72
      t_gre_header.fhAnulacion @ x-fhAnulacion COLUMN-LABEL "Fecha/Hora!Anulacion" FORMAT "99/99/9999 hh:mm:ss":U
      t_gre_header.usuario_anu @ x-usuario_anu COLUMN-LABEL "Usuario!Anulacion" FORMAT "x(25)":U
      t_gre_header.cmotivo @ x-cmotivo COLUMN-LABEL "Motivo!Anulacion" FORMAT "x(5)":U
      t_gre_header.dmotivo @ x-dmotivo COLUMN-LABEL "Descripcion del motivo!Anulacion" FORMAT "x(80)":U
  ENABLE
      gre_header.serieGuia
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 189 BY 21.81
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-msg AT ROW 2.38 COL 117 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     FILL-IN-almacenes AT ROW 1.54 COL 112 COLON-ALIGNED WIDGET-ID 28
     FILL-IN_NroHR AT ROW 2.62 COL 89 COLON-ALIGNED WIDGET-ID 26
     FILL-IN_NroOD AT ROW 1.54 COL 89 COLON-ALIGNED WIDGET-ID 22
     FILL-IN_NroPHR AT ROW 3.69 COL 89 COLON-ALIGNED WIDGET-ID 24
     FILL-IN-FechaReg-1 AT ROW 1.54 COL 19 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-FechaReg-2 AT ROW 2.62 COL 19 COLON-ALIGNED WIDGET-ID 14
     RADIO-SET-rspta_sunat AT ROW 1.27 COL 42 NO-LABEL WIDGET-ID 2
     BUTTON-Filtrar AT ROW 3.31 COL 150 WIDGET-ID 10
     BUTTON-Texto AT ROW 2.08 COL 178 WIDGET-ID 16
     BROWSE-2 AT ROW 5.04 COL 2 WIDGET-ID 200
     RECT-1 AT ROW 1 COL 1 WIDGET-ID 18
     RECT-2 AT ROW 1 COL 174 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 191.29 BY 26.15
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: t_gre_header T "?" NO-UNDO INTEGRAL gre_header
      ADDITIONAL-FIELDS:
          FIELD NroOD AS CHAR
          FIELD NroPHR AS CHAR
          FIELD NroHR AS CHAR
          FIELD fhAceptadoSunat as datetime
          field fhAnulacion as datetime
          field usuario_anu as char
          field cmotivo as char
          field dmotivo as char
          
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "REPORTE DE PREGUIAS Y GUIAS DE REMISION ELECTRONICAS"
         HEIGHT             = 26.15
         WIDTH              = 191.29
         MAX-HEIGHT         = 26.15
         MAX-WIDTH          = 191.29
         VIRTUAL-HEIGHT     = 26.15
         VIRTUAL-WIDTH      = 191.29
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
/* BROWSE-TAB BROWSE-2 BUTTON-Texto F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-msg IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.t_gre_header,INTEGRAL.gre_header WHERE Temp-Tables.t_gre_header ..."
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST"
     _JoinCode[2]      = "INTEGRAL.gre_header.ncorrelatio = Temp-Tables.t_gre_header.ncorrelatio"
     _FldNameList[1]   > INTEGRAL.gre_header.fechaEmisionGuia
"gre_header.fechaEmisionGuia" "Fecha Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.t_gre_header.fechahora_envio_a_sunat
"t_gre_header.fechahora_envio_a_sunat" "Enviado a SUNAT" "99/99/9999 HH:MM:SS" "datetime" ? ? ? ? ? ? no ? no no "16" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"t_gre_header.fhAceptadoSunat @ x-fhAceptadoSunat" "Aceptado Sunat" "99/99/9999 hh:mm:ss" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"t_gre_header.nrohr @ x-NroHR" "# Hoja de Ruta" ? ? ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"t_gre_header.nrophr @ x-NroPHR" "# Pre Hoja de Ruta" ? ? ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"t_gre_header.nrood @ x-NroOD" "# Orden de Despacho" ? ? ? ? ? ? ? ? no ? no no "15.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.gre_header.razonSocialDestinatario
"gre_header.razonSocialDestinatario" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "52.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.gre_header.m_rspta_sunat
"gre_header.m_rspta_sunat" "Status" ? "character" ? ? ? ? ? ? no ? no no "19.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.gre_header.serieGuia
"gre_header.serieGuia" "Serie Guia" ? "integer" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.gre_header.numeroGuia
"gre_header.numeroGuia" "Correlativo" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.gre_header.descripcionMotivoTraslado
"gre_header.descripcionMotivoTraslado" "Motivo de Traslado" ? "character" ? ? ? ? ? ? no ? no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.gre_header.numeroRucTransportista
"gre_header.numeroRucTransportista" "RucTransporte" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > INTEGRAL.gre_header.RazonSocialTransportista
"gre_header.RazonSocialTransportista" "Transportista" ? "character" ? ? ? ? ? ? no ? no no "60" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > INTEGRAL.gre_header.numeroLicencia
"gre_header.numeroLicencia" "Licencia" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > INTEGRAL.gre_header.numeroPlacaVehiculoPrin
"gre_header.numeroPlacaVehiculoPrin" "Placa 1" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > INTEGRAL.gre_header.numeroPlacaVehiculoSec1
"gre_header.numeroPlacaVehiculoSec1" "Placa 2" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > INTEGRAL.gre_header.ubigeoPtoLLegada
"gre_header.ubigeoPtoLLegada" "Ubigeo de Llegada" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > INTEGRAL.gre_header.direccionPtoLlegada
"gre_header.direccionPtoLlegada" "Dirección de Llegada" ? "character" ? ? ? ? ? ? no ? no no "63.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > INTEGRAL.gre_header.m_coddoc
"gre_header.m_coddoc" "Tipo de Comprobante" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > INTEGRAL.gre_header.m_nroser
"gre_header.m_nroser" "Serie Comprobante" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > INTEGRAL.gre_header.m_nrodoc
"gre_header.m_nrodoc" "Correlativo Comprobante" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > INTEGRAL.gre_header.m_codmov
"gre_header.m_codmov" "Tipo de Movimiento" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > INTEGRAL.gre_header.m_fechahorareg
"gre_header.m_fechahorareg" "Fecha de Registro" ? "datetime" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[24]   > INTEGRAL.gre_header.ubigeoPtoPartida
"gre_header.ubigeoPtoPartida" "Ubigeo de Partida" "x(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[25]   > INTEGRAL.gre_header.direccionPtoPartida
"gre_header.direccionPtoPartida" "Dirección de Partida" ? "character" ? ? ? ? ? ? no ? no no "43.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[26]   > "_<CALC>"
"t_gre_header.fhAnulacion @ x-fhAnulacion" "Fecha/Hora!Anulacion" "99/99/9999 hh:mm:ss" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[27]   > "_<CALC>"
"t_gre_header.usuario_anu @ x-usuario_anu" "Usuario!Anulacion" "x(25)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[28]   > "_<CALC>"
"t_gre_header.cmotivo @ x-cmotivo" "Motivo!Anulacion" "x(5)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[29]   > "_<CALC>"
"t_gre_header.dmotivo @ x-dmotivo" "Descripcion del motivo!Anulacion" "x(80)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE PREGUIAS Y GUIAS DE REMISION ELECTRONICAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE PREGUIAS Y GUIAS DE REMISION ELECTRONICAS */
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
  DEFINE VARIABLE hSortColumn  AS WIDGET-HANDLE.
  DEFINE VARIABLE hQueryHandle AS HANDLE     NO-UNDO.

  hSortColumn = BROWSE BROWSE-2:CURRENT-COLUMN.
  hQueryHandle = BROWSE BROWSE-2:QUERY.

  CASE hSortColumn:NAME:
      WHEN "x-NroOD" THEN hSortColumn:NAME = "NroOD".
      WHEN "x-NroHR" THEN hSortColumn:NAME = "NroHR".
      WHEN "x-NroPHR" THEN hSortColumn:NAME = "NroPHR".
  END CASE.
  hQueryHandle:QUERY-CLOSE().
  hQueryHandle:QUERY-PREPARE("FOR EACH t_gre_header NO-LOCK, ~
                             FIRST gre_header WHERE gre_header.ncorrelatio = t_gre_header.ncorrelatio ~
                             NO-LOCK BY " + hSortColumn:NAME).
  hQueryHandle:QUERY-OPEN().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Filtrar W-Win
ON CHOOSE OF BUTTON-Filtrar IN FRAME F-Main /* APLICAR FILTROS */
DO:
  ASSIGN FILL-IN-FechaReg-1 FILL-IN-FechaReg-2 RADIO-SET-rspta_sunat.
  ASSIGN FILL-IN_NroHR FILL-IN_NroOD FILL-IN_NroPHR fill-in-almacenes.
  RUN Carga-Temporal.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Texto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Texto W-Win
ON CHOOSE OF BUTTON-Texto IN FRAME F-Main /* Button 2 */
DO:
    /* Pantalla de Impresión */
    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
    DEF VAR cArchivo AS CHAR.
    DEF VAR x-FieldList AS CHAR.

    x-FieldList = "~
nrood,~
nrohr,~
nrophr,~
m_fechahorareg,~
m_rspta_sunat,~
fechaEmisionGuia,~
horaEmisionGuia,~
fechahora_envio_a_sunat,~
fhAceptadoSunat,~
razonSocialDestinatario,~
descripcionMotivoTraslado,~
numeroRucTransportista,~
RazonSocialTransportista,~
numeroLicencia,~
numeroPlacaVehiculoPrin,~
numeroPlacaVehiculoSec1,~
serieGuia,~
numeroGuia,~
m_coddoc,~
m_nroser,~
m_nrodoc,~
m_codmov,~
ubigeoPtoPartidal,~
direccionPtoPartida,~
ubigeoPtoLLegada,~
direccionPtoLlegada,~
fhAnulacion,~
usuario_anu,~
cmotivo,~
dmotivo" .

    RUN lib/tt-file-to-onlytext (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.
    pOptions = pOptions + CHR(1) + "FieldList:" + x-FieldList.
    cArchivo = LC(pArchivo).

    EMPTY TEMP-TABLE T-REPORTE.
    GET FIRST {&BROWSE-NAME}.
    DO WHILE NOT QUERY-OFF-END('{&BROWSE-NAME}'):
        CREATE T-REPORTE.
        BUFFER-COPY t_gre_header TO T-REPORTE.
        GET NEXT  {&BROWSE-NAME}.
    END.

    IF INDEX(pOptions, 'FileType:XLS') > 0 THEN SESSION:DATE-FORMAT = "mdy".
    RUN lib/tt-filev2 (TEMP-TABLE T-REPORTE:HANDLE, cArchivo, pOptions).
    SESSION:DATE-FORMAT = "dmy".
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */



/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}


ASSIGN gre_header.serieGuia:READ-ONLY IN BROWSE {&BROWSE-NAME} = TRUE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE t_gre_header.
EMPTY TEMP-TABLE talmacen.
DEFINE VAR iConteo AS INT.

SESSION:SET-WAIT-STATE('GENERAL').

IF lSeleccionaAlmacenes = YES THEN DO:
    IF TRUE <> (FILL-in-almacenes > "") THEN DO:
        FOR EACH almacen WHERE almacen.codcia = 1 NO-LOCK :
            CREATE talmacen.
            BUFFER-COPY almacen TO talmacen.
        END.
    END.
    ELSE DO:
        REPEAT iConteo = 1 TO NUM-ENTRIES(fill-in-almacenes,","):
            FIND FIRST talmacen WHERE talmacen.codcia = 1 AND talmacen.codalm = ENTRY(iConteo,fill-in-almacenes,",") NO-LOCK NO-ERROR.
            IF NOT AVAILABLE talmacen THEN DO:
                CREATE talmacen.
                ASSIGN talmacen.codcia = 1 
                        talmacen.codalm = ENTRY(iConteo,fill-in-almacenes,",").
            END.
        END.
    END.
END.
ELSE DO:
    IF TRUE <> (FILL-in-almacenes > "") THEN DO:
        FOR EACH almacen WHERE almacen.codcia = 1 AND almacen.coddiv = s-coddiv NO-LOCK :
            CREATE talmacen.
            BUFFER-COPY almacen TO talmacen.
        END.
    END.
END.
/*
&SCOPED-DEFINE Condicion ( ~
gre_header.m_divorigen = s-coddiv AND ~
(RADIO-SET-rspta_sunat = "TODOS" OR LOOKUP(gre_header.m_rspta_sunat, RADIO-SET-rspta_sunat, '|') > 0)  AND ~
DATE(gre_header.m_fechahorareg) >= FILL-IN-FechaReg-1 AND DATE(gre_header.m_fechahorareg) <= FILL-IN-FechaReg-2 ~
                           )
*/

FOR EACH talmacen NO-LOCK:
    FOR EACH gre_header WHERE gre_header.m_codalm = talmacen.codalm AND
        (RADIO-SET-rspta_sunat = "TODOS" OR LOOKUP(gre_header.m_rspta_sunat, RADIO-SET-rspta_sunat, '|') > 0)  AND 
        (DATE(gre_header.m_fechahorareg) >= FILL-IN-FechaReg-1 AND DATE(gre_header.m_fechahorareg) <= FILL-IN-FechaReg-2 ) NO-LOCK:

        CREATE t_gre_header.
        BUFFER-COPY gre_header TO t_gre_header.

        /* Buscamos OD, PHR y HR */
        FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia AND
            Ccbcdocu.coddoc = 'G/R' AND 
            Ccbcdocu.nrodoc = STRING(gre_header.serieguia, '999') + STRING(gre_header.numeroguia, '99999999')
            NO-LOCK NO-ERROR.
        IF AVAILABLE Ccbcdocu THEN DO:
            t_gre_header.nrood = (IF Ccbcdocu.libre_c01 = 'O/D' THEN Ccbcdocu.libre_c02 ELSE '').
            FOR EACH Di-RutaD WHERE DI-RutaD.CodCia = Ccbcdocu.codcia AND
                DI-RutaD.CodDoc = "H/R" AND
                DI-RutaD.CodRef = Ccbcdocu.coddoc AND
                DI-RutaD.NroRef = Ccbcdocu.nrodoc NO-LOCK:
                t_gre_header.nrohr = DI-RutaD.NroDoc. 
            END.
            IF t_gre_header.nrood > '' THEN DO:
                FOR EACH Di-RutaD WHERE DI-RutaD.CodCia = Ccbcdocu.codcia AND
                    DI-RutaD.CodDoc = "PHR" AND
                    DI-RutaD.CodRef = Ccbcdocu.libre_c01 AND
                    DI-RutaD.NroRef = Ccbcdocu.libre_c02 NO-LOCK:
                    t_gre_header.nrophr = DI-RutaD.NroDoc. 
                END.
            END.
        END.
        IF FILL-IN_NroOD > '' AND t_gre_header.nrood <> FILL-IN_NroOD THEN DO:
            DELETE t_gre_header.
            NEXT.
        END.
        IF FILL-IN_NroHR > '' AND t_gre_header.nrohr <> FILL-IN_NroHR THEN DO:
            DELETE t_gre_header.
            NEXT.
        END.
        IF FILL-IN_NroPHR > '' AND t_gre_header.nrophr <> FILL-IN_NroPHR THEN DO:
            DELETE t_gre_header.
            NEXT.
        END.
        /* Buscamos cuando fue aceptado por Sunat */
        FIND FIRST gre_header_qr WHERE gre_header_qr.ncorrelativo = gre_header.ncorrelatio NO-LOCK NO-ERROR.
        IF AVAILABLE gre_header_qr THEN DO:
            ASSIGN t_gre_header.fhAceptadoSunat = gre_header_qr.fechaHorareg.
        END.
        /* Buscamos si tiene ANULACION AUTOMATICA POR CIERRE DE H/R */
        FIND FIRST gre_header_log WHERE gre_header_log.ncorrelatio = gre_header.ncorrelatio AND 
                                gre_header_log.cmotivo = '99' NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gre_header_log THEN DO:
            FIND FIRST gre_header_log WHERE gre_header_log.ncorrelatio = gre_header.ncorrelatio NO-LOCK NO-ERROR.
        END.
        IF AVAILABLE gre_header_log THEN DO:
            ASSIGN t_gre_header.fhAnulacion = gre_header_log.m_fechahorareg
                    t_gre_header.usuario_anu = gre_header_log.USER_log 
                    t_gre_header.cmotivo = gre_header_log.cmotivo
                    t_gre_header.dmotivo = gre_header_log.dmotivo_detalle.
        END.
    END.
END.


SESSION:SET-WAIT-STATE('').

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
  DISPLAY FILL-IN-msg FILL-IN-almacenes FILL-IN_NroHR FILL-IN_NroOD 
          FILL-IN_NroPHR FILL-IN-FechaReg-1 FILL-IN-FechaReg-2 
          RADIO-SET-rspta_sunat 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-almacenes FILL-IN_NroHR FILL-IN_NroOD FILL-IN_NroPHR 
         FILL-IN-FechaReg-1 FILL-IN-FechaReg-2 RADIO-SET-rspta_sunat 
         BUTTON-Filtrar BUTTON-Texto BROWSE-2 RECT-1 RECT-2 
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
  ASSIGN
      FILL-IN-FechaReg-1 = ADD-INTERVAL(TODAY, -30, 'days') 
      FILL-IN-FechaReg-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF lSeleccionaAlmacenes = NO THEN DO:
      DO WITH FRAME {&FRAME-NAME}:
          FILL-IN-almacenes:VISIBLE = NO.                    
          FILL-IN-msg:VISIBLE = NO.
      END.      
      
      
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
  {src/adm/template/snd-list.i "t_gre_header"}
  {src/adm/template/snd-list.i "gre_header"}

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

