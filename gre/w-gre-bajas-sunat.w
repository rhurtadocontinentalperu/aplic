&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE gre_header_disponibles NO-UNDO LIKE gre_header
       fields cImpreso as char.
DEFINE TEMP-TABLE gre_header_seleccionados NO-UNDO LIKE gre_header.



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

DEFINE VAR cCoddoc AS CHAR INIT 'G/R'.      /* Si cambia aqui debe ir a p-series-solo-gr-electronica */

/* En definitions */
define var x-sort-column-current as char.

DEFINE BUFFER b-gre_header FOR gre_header.
DEFINE BUFFER b-faccorre FOR faccorre.
DEFINE BUFFER b-faccpedi FOR faccpedi.
DEFINE BUFFER b-almcmov FOR almcmov.
DEFINE BUFFER b-almdmov FOR almdmov.
DEFINE BUFFER x-gre_header FOR gre_header.
DEFINE BUFFER x-almcmov FOR almcmov.
DEFINE BUFFER x-vtatabla FOR vtatabla.
DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.

DEFINE TEMP-TABLE t-gre_header LIKE gre_header.
DEFINE TEMP-TABLE t-gre_detail LIKE gre_detail.
DEFINE TEMP-TABLE t-almcmov LIKE almcmov.
DEFINE TEMP-TABLE t-almdmov LIKE almdmov.

DEFINE VAR iRegis AS INT INIT 0.

DEFINE VAR gcCRLF AS CHAR.
ASSIGN gcCRLF = CHR(13) + CHR(10).

DEFINE TEMP-TABLE tTagsEstadoDoc
    FIELD   cTag    AS  CHAR    FORMAT 'x(100)'
    FIELD   cValue  AS  CHAR    FORMAT 'x(255)'.

DEFINE VAR dFechaDesde AS DATETIME .

DEFINE VAR cFiltro AS CHAR INIT "Todos".

DEFINE VAR cMotivo AS CHAR.
DEFINE VAR cMotivoDetalle AS CHAR.

DEFINE VAR cTabla AS CHAR NO-UNDO INIT "CONFIG-GRE".
DEFINE VAR cLlave_c1 AS CHAR NO-UNDO INIT "MOTIVO".
DEFINE VAR cLlave_c2 AS CHAR NO-UNDO INIT "BAJA SUNAT".

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
&Scoped-define INTERNAL-TABLES gre_header_disponibles

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 ~
gre_header_disponibles.m_rspta_sunat gre_header_disponibles.serieGuia ~
gre_header_disponibles.numeroGuia ~
gre_header_disponibles.fechahora_envio_a_sunat ~
gre_header_disponibles.m_estado_bizlinks ~
gre_header_disponibles.fechaEmisionGuia ~
gre_header_disponibles.horaEmisionGuia gre_header_disponibles.m_libre_c05 ~
gre_header_disponibles.m_fechahorareg gre_header_disponibles.ncorrelatio ~
gre_header_disponibles.nombrePuertoAeropuerto ~
gre_header_disponibles.m_coddoc gre_header_disponibles.m_nroser ~
gre_header_disponibles.m_nrodoc gre_header_disponibles.motivoTraslado ~
gre_header_disponibles.descripcionMotivoTraslado ~
gre_header_disponibles.razonSocialDestinatario ~
gre_header_disponibles.direccionPtoLlegada 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH gre_header_disponibles ~
      WHERE cFiltro = 'Todos' or  ~
gre_header_disponibles.m_rspta_sunat = cFiltro NO-LOCK ~
    BY gre_header_disponibles.fechahora_envio_a_sunat DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH gre_header_disponibles ~
      WHERE cFiltro = 'Todos' or  ~
gre_header_disponibles.m_rspta_sunat = cFiltro NO-LOCK ~
    BY gre_header_disponibles.fechahora_envio_a_sunat DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 gre_header_disponibles
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 gre_header_disponibles


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-12 RECT-13 BROWSE-2 BUTTON-1 ~
COMBO-BOX-filtro FILL-IN-desde COMBO-BOX-motivo EDITOR-detalle BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-filtro FILL-IN-desde ~
FILL-IN-datos FILL-IN-placa-2 FILL-IN-placa FILL-IN_Marca-2 FILL-IN_Marca ~
FILL-IN_Carga-2 FILL-IN_Carga FILL-IN_Libre_d01-2 FILL-IN_Libre_d01 ~
FILL-IN_Libre_c02-2 FILL-IN_Libre_c02 FILL-IN_Libre_c04-2 FILL-IN_Libre_c04 ~
RADIO-SET_libre_d02-2 RADIO-SET_libre_d02 FILL-IN_tarjeta-circulacion-2 ~
FILL-IN_tarjeta-circulacion FILL-IN_CodPro FILL-IN_Ruc FILL-IN_NomPro ~
RADIO-SET_libre_d01a FILL-IN-entrega FILL-IN-brevete FILL-IN-DNI ~
FILL-IN-nombre FILL-IN-apellido FILL-IN-brevetevcto COMBO-BOX-motivo ~
EDITOR-detalle 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-impresiones W-Win 
FUNCTION fget-impresiones RETURNS INTEGER
  ( INPUT pNroPGRE AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Refrescar data" 
     SIZE 19 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "DAR DE BAJAS guias de remision" 
     SIZE 30 BY 1.12
     FGCOLOR 2 FONT 6.

DEFINE VARIABLE COMBO-BOX-filtro AS CHARACTER FORMAT "X(50)":U INITIAL "Todos" 
     LABEL "Elija" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","ACEPTADO POR SUNAT","BAJA EN SUNAT" 
     DROP-DOWN-LIST
     SIZE 22.29 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-motivo AS CHARACTER FORMAT "X(100)":U 
     LABEL "Motivo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "A","B"
     DROP-DOWN-LIST
     SIZE 47 BY 1 NO-UNDO.

DEFINE VARIABLE EDITOR-detalle AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP MAX-CHARS 220 SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 57.86 BY 3.23
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-apellido AS CHARACTER FORMAT "X(60)":U 
     LABEL "Apellidos" 
     VIEW-AS FILL-IN 
     SIZE 43.43 BY .88
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-brevete AS CHARACTER FORMAT "X(12)":U 
     LABEL "Brevete" 
     VIEW-AS FILL-IN 
     SIZE 14.29 BY .88
     BGCOLOR 15 FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-brevetevcto AS DATE FORMAT "99/99/9999":U 
     LABEL "Vcto brevete" 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-datos AS CHARACTER FORMAT "X(50)":U INITIAL "DATOS DEL VEHICULO Y TRANSPORTISTA PARA EL REPARTO" 
     VIEW-AS FILL-IN 
     SIZE 56 BY .88
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-desde AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88
     BGCOLOR 15 FGCOLOR 9 FONT 10 NO-UNDO.

DEFINE VARIABLE FILL-IN-DNI AS CHARACTER FORMAT "X(10)":U 
     LABEL "D.N.I" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-entrega AS DATE FORMAT "99/99/9999":U 
     LABEL "Inicio del traslado de bienes" 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-nombre AS CHARACTER FORMAT "X(60)":U 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 43.43 BY .88
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-placa AS CHARACTER FORMAT "X(10)":U 
     LABEL "Placa principal" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88
     BGCOLOR 15 FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-placa-2 AS CHARACTER FORMAT "X(10)":U 
     LABEL "Placa 2" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_Carga AS DECIMAL FORMAT "->>>,>>9.99" INITIAL 0 
     LABEL "Carga maxima" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88
     BGCOLOR 15 FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_Carga-2 AS DECIMAL FORMAT "->>>,>>9.99" INITIAL 0 
     LABEL "Carga maxima" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodPro AS CHARACTER FORMAT "x(11)" 
     LABEL "Transportista" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88
     BGCOLOR 15 FGCOLOR 4 FONT 6.

DEFINE VARIABLE FILL-IN_Libre_c02 AS CHARACTER FORMAT "x(10)" 
     LABEL "Tonelaje" 
     VIEW-AS FILL-IN 
     SIZE 7.86 BY .88
     BGCOLOR 15 FGCOLOR 4 FONT 6.

DEFINE VARIABLE FILL-IN_Libre_c02-2 AS CHARACTER FORMAT "x(10)" 
     LABEL "Tonelaje" 
     VIEW-AS FILL-IN 
     SIZE 7.86 BY .88
     BGCOLOR 15 FGCOLOR 9 FONT 6.

DEFINE VARIABLE FILL-IN_Libre_c04 AS CHARACTER FORMAT "x(20)" 
     LABEL "Registro MTC" 
     VIEW-AS FILL-IN 
     SIZE 15.86 BY .88
     BGCOLOR 15 FGCOLOR 4 FONT 6.

DEFINE VARIABLE FILL-IN_Libre_c04-2 AS CHARACTER FORMAT "x(20)" 
     LABEL "Registro MTC" 
     VIEW-AS FILL-IN 
     SIZE 15.86 BY .88
     BGCOLOR 15 FGCOLOR 9 FONT 6.

DEFINE VARIABLE FILL-IN_Libre_d01 AS DECIMAL FORMAT "->>,>>>,>>9.99" INITIAL 0 
     LABEL "Capacida minima" 
     VIEW-AS FILL-IN 
     SIZE 16.43 BY .88
     BGCOLOR 15 FGCOLOR 4 FONT 6.

DEFINE VARIABLE FILL-IN_Libre_d01-2 AS DECIMAL FORMAT "->>,>>>,>>9.99" INITIAL 0 
     LABEL "Capacidad minima" 
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88
     BGCOLOR 15 FGCOLOR 9 FONT 6.

DEFINE VARIABLE FILL-IN_Marca AS CHARACTER FORMAT "x(20)" 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 21.43 BY .88
     BGCOLOR 15 FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_Marca-2 AS CHARACTER FORMAT "x(20)" 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 21.43 BY .88
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_NomPro AS CHARACTER FORMAT "x(50)" 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 46.86 BY .88
     BGCOLOR 15 FGCOLOR 4 FONT 6.

DEFINE VARIABLE FILL-IN_Ruc AS CHARACTER FORMAT "x(11)" 
     LABEL "Ruc" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88
     BGCOLOR 15 FGCOLOR 4 FONT 6.

DEFINE VARIABLE FILL-IN_tarjeta-circulacion AS CHARACTER FORMAT "x(20)" 
     LABEL "Tarjeta. circul." 
     VIEW-AS FILL-IN 
     SIZE 15.86 BY .88
     BGCOLOR 15 FGCOLOR 9 FONT 6.

DEFINE VARIABLE FILL-IN_tarjeta-circulacion-2 AS CHARACTER FORMAT "x(20)" 
     LABEL "Tarjeta. circul." 
     VIEW-AS FILL-IN 
     SIZE 15.86 BY .88
     BGCOLOR 15 FGCOLOR 9 FONT 6.

DEFINE VARIABLE RADIO-SET_libre_d01a AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Ninguno", 0,
"Publico", 1,
"Privado", 2
     SIZE 31 BY .69
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE RADIO-SET_libre_d02 AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Si", 1,
"No", 0
     SIZE 12 BY .81
     BGCOLOR 15 FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE VARIABLE RADIO-SET_libre_d02-2 AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Si", 1,
"No", 0
     SIZE 12 BY .81
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 72.43 BY 8.27
     BGCOLOR 10 .

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36 BY 7.54.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36 BY 7.54.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      gre_header_disponibles SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      gre_header_disponibles.m_rspta_sunat COLUMN-LABEL "Estado Sunat" FORMAT "x(25)":U
            WIDTH 20.43
      gre_header_disponibles.serieGuia COLUMN-LABEL "Serie!Guia" FORMAT "999":U
            WIDTH 5.43
      gre_header_disponibles.numeroGuia COLUMN-LABEL "Numero!Guia" FORMAT "99999999":U
            WIDTH 11.43
      gre_header_disponibles.fechahora_envio_a_sunat COLUMN-LABEL "Fecha/Hora!envio a sunat" FORMAT "99/99/9999 HH:MM:SS.SSS":U
      gre_header_disponibles.m_estado_bizlinks COLUMN-LABEL "Estado!Bizlinks" FORMAT "x(25)":U
            WIDTH 8.86
      gre_header_disponibles.fechaEmisionGuia COLUMN-LABEL "Emsion!PGRE" FORMAT "99/99/9999":U
            WIDTH 11.43
      gre_header_disponibles.horaEmisionGuia COLUMN-LABEL "Hora!PGRE" FORMAT "x(8)":U
            WIDTH 8.43
      gre_header_disponibles.m_libre_c05 COLUMN-LABEL "Placa!Vehiculo" FORMAT "x(15)":U
            WIDTH 8.43
      gre_header_disponibles.m_fechahorareg COLUMN-LABEL "Registro!Vehiculo" FORMAT "99/99/9999 HH:MM:SS.SSS":U
            WIDTH 19.43
      gre_header_disponibles.ncorrelatio COLUMN-LABEL "Nro ! PGRE" FORMAT ">>>>>>>>9":U
            WIDTH 8.43
      gre_header_disponibles.nombrePuertoAeropuerto COLUMN-LABEL "PHR" FORMAT "x(10)":U
            WIDTH 12.43
      gre_header_disponibles.m_coddoc COLUMN-LABEL "Tipo!Docto" FORMAT "x(5)":U
            WIDTH 5.43
      gre_header_disponibles.m_nroser COLUMN-LABEL "Serie" FORMAT "999":U
            WIDTH 5.43
      gre_header_disponibles.m_nrodoc COLUMN-LABEL "Numero" FORMAT "99999999":U
            WIDTH 9.43
      gre_header_disponibles.motivoTraslado COLUMN-LABEL "Cod.!Mtvo" FORMAT "x(2)":U
            WIDTH 4.43
      gre_header_disponibles.descripcionMotivoTraslado COLUMN-LABEL "Descripcion motivo!traslado" FORMAT "x(50)":U
            WIDTH 22.57
      gre_header_disponibles.razonSocialDestinatario COLUMN-LABEL "Destinatario" FORMAT "x(80)":U
            WIDTH 33.43
      gre_header_disponibles.direccionPtoLlegada COLUMN-LABEL "Punto de llegada" FORMAT "x(100)":U
            WIDTH 34.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 113 BY 23.58
         BGCOLOR 8 FGCOLOR 9 FONT 3
         TITLE BGCOLOR 8 FGCOLOR 9 "DAR DE BAJA GUIAS DE REMISION" ROW-HEIGHT-CHARS .46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-2 AT ROW 1.12 COL 2 WIDGET-ID 200
     BUTTON-1 AT ROW 1.19 COL 118 WIDGET-ID 4
     COMBO-BOX-filtro AT ROW 1.27 COL 164 COLON-ALIGNED WIDGET-ID 166
     FILL-IN-desde AT ROW 1.31 COL 142.57 COLON-ALIGNED WIDGET-ID 164
     FILL-IN-datos AT ROW 2.58 COL 116.43 COLON-ALIGNED NO-LABEL WIDGET-ID 138
     FILL-IN-placa-2 AT ROW 3.77 COL 163.14 COLON-ALIGNED WIDGET-ID 158
     FILL-IN-placa AT ROW 3.92 COL 132.43 COLON-ALIGNED WIDGET-ID 8
     FILL-IN_Marca-2 AT ROW 4.65 COL 163.14 COLON-ALIGNED WIDGET-ID 190
     FILL-IN_Marca AT ROW 4.85 COL 126.14 COLON-ALIGNED WIDGET-ID 10
     FILL-IN_Carga-2 AT ROW 5.58 COL 169.29 COLON-ALIGNED WIDGET-ID 184
     FILL-IN_Carga AT ROW 5.73 COL 131.72 COLON-ALIGNED WIDGET-ID 14
     FILL-IN_Libre_d01-2 AT ROW 6.46 COL 169.29 COLON-ALIGNED WIDGET-ID 188
     FILL-IN_Libre_d01 AT ROW 6.62 COL 131.72 COLON-ALIGNED WIDGET-ID 20
     FILL-IN_Libre_c02-2 AT ROW 7.38 COL 169.29 COLON-ALIGNED WIDGET-ID 186
     FILL-IN_Libre_c02 AT ROW 7.5 COL 131.72 COLON-ALIGNED WIDGET-ID 16
     FILL-IN_Libre_c04-2 AT ROW 8.23 COL 169.29 COLON-ALIGNED WIDGET-ID 168
     FILL-IN_Libre_c04 AT ROW 8.38 COL 131.57 COLON-ALIGNED WIDGET-ID 18
     RADIO-SET_libre_d02-2 AT ROW 9.15 COL 175.29 NO-LABEL WIDGET-ID 170
     RADIO-SET_libre_d02 AT ROW 9.27 COL 136 NO-LABEL WIDGET-ID 24
     FILL-IN_tarjeta-circulacion-2 AT ROW 10.08 COL 168.86 COLON-ALIGNED WIDGET-ID 182
     FILL-IN_tarjeta-circulacion AT ROW 10.15 COL 132.43 COLON-ALIGNED WIDGET-ID 180
     FILL-IN_CodPro AT ROW 11.38 COL 129.72 COLON-ALIGNED HELP
          "C¢digo del Proveedor" WIDGET-ID 12
     FILL-IN_Ruc AT ROW 11.38 COL 153.72 COLON-ALIGNED HELP
          "Ruc del Proveedor" WIDGET-ID 66
     FILL-IN_NomPro AT ROW 12.23 COL 124 COLON-ALIGNED HELP
          "Nombre del Proveedor" WIDGET-ID 64
     RADIO-SET_libre_d01a AT ROW 13.15 COL 136 NO-LABEL WIDGET-ID 68
     FILL-IN-entrega AT ROW 14.62 COL 147 COLON-ALIGNED WIDGET-ID 156
     FILL-IN-brevete AT ROW 15.65 COL 130 COLON-ALIGNED WIDGET-ID 146
     FILL-IN-DNI AT ROW 15.65 COL 153 COLON-ALIGNED WIDGET-ID 148
     FILL-IN-nombre AT ROW 16.54 COL 130 COLON-ALIGNED WIDGET-ID 150
     FILL-IN-apellido AT ROW 17.42 COL 130 COLON-ALIGNED WIDGET-ID 152
     FILL-IN-brevetevcto AT ROW 18.31 COL 130 COLON-ALIGNED WIDGET-ID 154
     COMBO-BOX-motivo AT ROW 19.54 COL 125.72 COLON-ALIGNED WIDGET-ID 2
     EDITOR-detalle AT ROW 20.46 COL 127.86 NO-LABEL WIDGET-ID 202
     BUTTON-2 AT ROW 23.77 COL 143 WIDGET-ID 140
     "Glosa" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 20.62 COL 121 WIDGET-ID 6
     "Modalidad traslado" VIEW-AS TEXT
          SIZE 18.72 BY .73 AT ROW 13.23 COL 117 WIDGET-ID 132
     "(privado = propio, publico = tercero)" VIEW-AS TEXT
          SIZE 29.86 BY .54 AT ROW 13.92 COL 136.43 WIDGET-ID 134
          FGCOLOR 9 FONT 6
     "¿Es categoria M1 o L?" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 9.35 COL 155.57 WIDGET-ID 192
          FGCOLOR 9 FONT 6
     "¿Es categoria M1 o L?" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 9.42 COL 116.43 WIDGET-ID 62
          FGCOLOR 9 FONT 6
     RECT-10 AT ROW 11.19 COL 115.57 WIDGET-ID 136
     RECT-12 AT ROW 3.58 COL 152 WIDGET-ID 178
     RECT-13 AT ROW 3.62 COL 115.57 WIDGET-ID 194
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 187.72 BY 24
         BGCOLOR 8 FONT 3 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: gre_header_disponibles T "?" NO-UNDO INTEGRAL gre_header
      ADDITIONAL-FIELDS:
          fields cImpreso as char
      END-FIELDS.
      TABLE: gre_header_seleccionados T "?" NO-UNDO INTEGRAL gre_header
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Guias de remision aceptadas x SUNAT"
         HEIGHT             = 24.08
         WIDTH              = 188.43
         MAX-HEIGHT         = 29.27
         MAX-WIDTH          = 205.86
         VIRTUAL-HEIGHT     = 29.27
         VIRTUAL-WIDTH      = 205.86
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
/* BROWSE-TAB BROWSE-2 RECT-13 F-Main */
ASSIGN 
       BROWSE-2:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-apellido IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-brevete IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-brevetevcto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-datos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DNI IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-entrega IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-nombre IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-placa IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-placa-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Carga IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Carga-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Libre_c02 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Libre_c02-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Libre_c04 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Libre_c04-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Libre_d01 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Libre_d01-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Marca IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Marca-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Ruc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_tarjeta-circulacion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_tarjeta-circulacion-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET RADIO-SET_libre_d01a IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET RADIO-SET_libre_d02 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET RADIO-SET_libre_d02-2 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.gre_header_disponibles"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.gre_header_disponibles.fechahora_envio_a_sunat|no"
     _Where[1]         = "cFiltro = 'Todos' or 
gre_header_disponibles.m_rspta_sunat = cFiltro"
     _FldNameList[1]   > Temp-Tables.gre_header_disponibles.m_rspta_sunat
"gre_header_disponibles.m_rspta_sunat" "Estado Sunat" ? "character" ? ? ? ? ? ? no ? no no "20.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.gre_header_disponibles.serieGuia
"gre_header_disponibles.serieGuia" "Serie!Guia" "999" "integer" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.gre_header_disponibles.numeroGuia
"gre_header_disponibles.numeroGuia" "Numero!Guia" "99999999" "integer" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.gre_header_disponibles.fechahora_envio_a_sunat
"gre_header_disponibles.fechahora_envio_a_sunat" "Fecha/Hora!envio a sunat" ? "datetime" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.gre_header_disponibles.m_estado_bizlinks
"gre_header_disponibles.m_estado_bizlinks" "Estado!Bizlinks" "x(25)" "character" ? ? ? ? ? ? no ? no no "8.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.gre_header_disponibles.fechaEmisionGuia
"gre_header_disponibles.fechaEmisionGuia" "Emsion!PGRE" ? "date" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.gre_header_disponibles.horaEmisionGuia
"gre_header_disponibles.horaEmisionGuia" "Hora!PGRE" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.gre_header_disponibles.m_libre_c05
"gre_header_disponibles.m_libre_c05" "Placa!Vehiculo" "x(15)" "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.gre_header_disponibles.m_fechahorareg
"gre_header_disponibles.m_fechahorareg" "Registro!Vehiculo" ? "datetime" ? ? ? ? ? ? no ? no no "19.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.gre_header_disponibles.ncorrelatio
"gre_header_disponibles.ncorrelatio" "Nro ! PGRE" ">>>>>>>>9" "int64" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.gre_header_disponibles.nombrePuertoAeropuerto
"gre_header_disponibles.nombrePuertoAeropuerto" "PHR" "x(10)" "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.gre_header_disponibles.m_coddoc
"gre_header_disponibles.m_coddoc" "Tipo!Docto" ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.gre_header_disponibles.m_nroser
"gre_header_disponibles.m_nroser" "Serie" "999" "integer" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.gre_header_disponibles.m_nrodoc
"gre_header_disponibles.m_nrodoc" "Numero" "99999999" "integer" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.gre_header_disponibles.motivoTraslado
"gre_header_disponibles.motivoTraslado" "Cod.!Mtvo" ? "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.gre_header_disponibles.descripcionMotivoTraslado
"gre_header_disponibles.descripcionMotivoTraslado" "Descripcion motivo!traslado" "x(50)" "character" ? ? ? ? ? ? no ? no no "22.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.gre_header_disponibles.razonSocialDestinatario
"gre_header_disponibles.razonSocialDestinatario" "Destinatario" "x(80)" "character" ? ? ? ? ? ? no ? no no "33.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.gre_header_disponibles.direccionPtoLlegada
"gre_header_disponibles.direccionPtoLlegada" "Punto de llegada" "x(100)" "character" ? ? ? ? ? ? no ? no no "34.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Guias de remision aceptadas x SUNAT */
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
ON MOUSE-SELECT-DBLCLICK OF BROWSE-2 IN FRAME F-Main /* DAR DE BAJA GUIAS DE REMISION */
DO:
    DEFINE VARIABLE iRowHeight   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iLastY       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iRow         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE hCell        AS HANDLE      NO-UNDO.
    DEFINE VARIABLE iTopRowY     AS INTEGER     NO-UNDO.
    
    DEFINE VARIABLE dRow         AS DEC     NO-UNDO.
    DEFINE VAR addRow AS INT.
    
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
    
    /* Si tiene activo la barra de titulo en el browse cambia a 1 el addRow*/
    addRow = 1.
    
    IF iRow = 1  THEN DO:
        IF dRow > 1  THEN DO:
            iRow = iRow + addRow.
        END.
    END.
    ELSE DO:
        iRow = iRow + addRow.
    END.
    
    
    IF iRow > 0 AND iRow <= SELF:NUM-ITERATIONS THEN DO:
      /* The user clicked on a populated row */
      /*Your coding here, for example:*/
        SELF:DESELECT-ROWS().
        SELF:SELECT-ROW(iRow).
    END.
    ELSE DO:
      /* The click was on an empty row. */
      /*SELF:DESELECT-ROWS().*/
    
      RETURN NO-APPLY.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 W-Win
ON START-SEARCH OF BROWSE-2 IN FRAME F-Main /* DAR DE BAJA GUIAS DE REMISION */
DO:
    DEFINE VAR x-sql AS CHAR.

   /*
   x-SQL = "FOR EACH gre_cmpte WHERE gre_cmpte.estado = 'CMPTE GENERADO' and " +
            "gre_cmpte.coddivdesp = '" + s-coddiv + "' NO-LOCK, " + 
            "FIRST INTEGRAL.CcbCDocu WHERE ccbcdocu.codcia = " + string(s-codcia) + " and " +
            "ccbcdocu.coddoc = gre_cmpte.coddoc AND ccbcdocu.nrodoc = gre_cmpte.nrodoc NO-LOCK "
    */
    x-sql = "FOR EACH gre_header_disponibles WHERE gre_header_disponibles.m_cco = '' NO-LOCK".

    {gn/sort-browse.i &ThisBrowse="browse-2" &ThisSQL = x-SQL}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 W-Win
ON VALUE-CHANGED OF BROWSE-2 IN FRAME F-Main /* DAR DE BAJA GUIAS DE REMISION */
DO:
    RUN muestra-datos-transporte.

    DEFINE VAR cValorDeRetorno AS CHAR.
    DEFINE VAR iMaximoRegsSeleccionables AS INT.
    DEFINE VAR iNroPGRE AS INT.
    DEFINE VAR cEstadodeSunat AS CHAR.
    DEFINE VAR iImpresionesExistentes AS INT.

    iImpresionesExistentes = browse-2:NUM-SELECTED-ROWS.

    RUN gre/get-parametro-config-gre("PARAMETRO","MAXIMOREGISTROSSELECCIONADOS","GENERAR_GR_FISICAS","N","10",OUTPUT cValorDeRetorno).

    IF cValorDeRetorno = "ERROR" THEN RETURN NO-APPLY.

    cEstadodeSunat = TRIM(gre_header_disponibles.m_rspta_sunat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
    IF cEstadodeSunat = 'BAJA EN SUNAT' THEN DO:
        BROWSE-2:DESELECT-FOCUSED-ROW().
    END.
    
    iMaximoRegsSeleccionables = INTEGER(TRIM(cValorDeRetorno)).

    /*
    iNroPGRE = INTEGER(gre_header_disponibles.ncorrelatio:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).

    IF iNroPGRE <= 0 THEN RETURN NO-APPLY.

    iImpresionesExistentes = fget-impresiones(iNroPGRE).
    */

    IF iImpresionesExistentes > iMaximoRegsSeleccionables THEN DO:
        MESSAGE "Se llego al limite de cantidad maxima seleccionables (Max :" + STRING(iMaximoRegsSeleccionables) + ")"  .
        BROWSE-2:DESELECT-FOCUSED-ROW().
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Refrescar data */
DO:

    ASSIGN fill-in-desde.

  RUN extrae-data-from-db.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* DAR DE BAJAS guias de remision */
DO:
    IF browse-2:NUM-SELECTED-ROWS > 0 THEN DO:
        ASSIGN combo-box-motivo editor-detalle.

        IF TRUE <> (combo-box-motivo > "") THEN DO:
            MESSAGE "Ingrese el motivo de la baja" VIEW-AS ALERT-BOX INFORMATION.
            RETURN NO-APPLY.
        END.
        IF TRUE <> (editor-detalle > "") THEN DO:
            MESSAGE "Ingrese el detalle de la baja" VIEW-AS ALERT-BOX INFORMATION.
            RETURN NO-APPLY.
        END.

        IF LENGTH(TRIM(editor-detalle)) < 25 THEN DO:
            MESSAGE "La glosa debe ser mas detallado" VIEW-AS ALERT-BOX INFORMATION.
            RETURN NO-APPLY.
        END.

        /*
        pCMotivo = combo-box-motivo.
        pCMotivoGlosa = EDITOR-detalle.
        */
           MESSAGE '¿Seguro de DAR DE BAJA la(s) ' + STRING(browse-2:NUM-SELECTED-ROWS) + ' GRE(s)?' VIEW-AS ALERT-BOX QUESTION
                   BUTTONS YES-NO UPDATE rpta AS LOG.
           IF rpta = NO THEN RETURN NO-APPLY.

         RUN procesar-la-baja.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-filtro W-Win
ON VALUE-CHANGED OF COMBO-BOX-filtro IN FRAME F-Main /* Elija */
DO:

  cFiltro = combo-box-filtro:SCREEN-VALUE.

  {&open-query-browse-2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-brevete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-brevete W-Win
ON LEAVE OF FILL-IN-brevete IN FRAME F-Main /* Brevete */
DO:
  /*codcia = 1 and tabla = 'BREVETE' and llave_c8 = 'SI'*/
    DO WITH FRAME {&FRAME-NAME}:
        SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).

        ASSIGN fill-in-brevete.

        ASSIGN fill-in-dni:SCREEN-VALUE = ""
            fill-in-nombre:SCREEN-VALUE = ""
            fill-in-apellido:SCREEN-VALUE = ""
            FILL-IN-brevetevcto:SCREEN-VALUE = ""
            .
        FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                    vtatabla.llave_c1 = fill-in-brevete NO-LOCK NO-ERROR.
        IF fill-in-brevete > "" AND AVAILABLE vtatabla THEN DO:
            ASSIGN fill-in-dni:SCREEN-VALUE = vtatabla.llave_c2
                    fill-in-nombre:SCREEN-VALUE = vtatabla.libre_c03
                    fill-in-apellido:SCREEN-VALUE = TRIM(vtatabla.libre_c01) + " " + trim(vtatabla.libre_c02)
                    FILL-IN-brevetevcto:SCREEN-VALUE = STRING(vtatabla.rango_fecha[1],"99/99/9999") 
                .
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-placa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-placa W-Win
ON LEAVE OF FILL-IN-placa IN FRAME F-Main /* Placa principal */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  RUN datos-del-transportista.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-placa-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-placa-2 W-Win
ON LEAVE OF FILL-IN-placa-2 IN FRAME F-Main /* Placa 2 */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  RUN datos-del-transportista-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dar-de-baja-gre W-Win 
PROCEDURE dar-de-baja-gre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER piSerieGuia AS INT NO-UNDO.
DEFINE INPUT PARAMETER piNumeroGuia AS INT NO-UNDO.
DEFINE OUTPUT PARAMETER piNuevoPGRE AS INT NO-UNDO.
DEFINE OUTPUT PARAMETER pcRetVal AS CHAR NO-UNDO.

/*RUN gre\p-dar-de-baja-GRE.r(piSerieGuia, piNumeroGuia, cMotivo, cMotivoDetalle, */

RUN gre\p-dar-de-baja-GRE.r(piSerieGuia, piNumeroGuia, combo-box-motivo, editor-detalle, 
                            OUTPUT piNuevoPGRE, OUTPUT pcRetVal).

RETURN RETURN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE datos-del-transportista W-Win 
PROCEDURE datos-del-transportista :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fill-in-placa.

    ASSIGN fill-in_marca:SCREEN-VALUE = ""
    FILL-IN_libre_d01:SCREEN-VALUE = ""
    FILL-IN_libre_c02:SCREEN-VALUE = ""
    FILL-IN_libre_c04:SCREEN-VALUE = ""
    radio-set_libre_d02:SCREEN-VALUE = ""
    FILL-IN_ruc:SCREEN-VALUE = ""
    FILL-IN_nompro:SCREEN-VALUE = ""
    FILL-IN_codpro:SCREEN-VALUE = ""
    radio-set_libre_d01a:SCREEN-VALUE = ""
    .
    FIND FIRST gn-vehic WHERE gn-vehic.codcia = s-codcia AND gn-vehic.placa = fill-in-placa
                    NO-LOCK NO-ERROR.
    IF AVAILABLE gn-vehic THEN DO:

        FIND FIRST gn-prov WHERE gn-prov.codcia = 0 AND gn-prov.codpro = gn-vehic.codpro
                            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN DO:
            ASSIGN fill-in_marca:SCREEN-VALUE = gn-vehic.marca
            FILL-IN_codpro:SCREEN-VALUE = gn-vehic.codpro
            FILL-IN_libre_d01:SCREEN-VALUE = string(gn-vehic.libre_d01)
            FILL-IN_libre_c02:SCREEN-VALUE = gn-vehic.libre_c02
            FILL-IN_libre_c04:SCREEN-VALUE = gn-vehic.libre_c04
            radio-set_libre_d02:SCREEN-VALUE = string(gn-vehic.libre_d02)
            fill-in_ruc:SCREEN-VALUE = gn-prov.ruc
            FILL-IN_nompro:SCREEN-VALUE = gn-prov.nompro
            radio-set_libre_d01a:SCREEN-VALUE = string(gn-prov.libre_d01)
            .
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
  DISPLAY COMBO-BOX-filtro FILL-IN-desde FILL-IN-datos FILL-IN-placa-2 
          FILL-IN-placa FILL-IN_Marca-2 FILL-IN_Marca FILL-IN_Carga-2 
          FILL-IN_Carga FILL-IN_Libre_d01-2 FILL-IN_Libre_d01 
          FILL-IN_Libre_c02-2 FILL-IN_Libre_c02 FILL-IN_Libre_c04-2 
          FILL-IN_Libre_c04 RADIO-SET_libre_d02-2 RADIO-SET_libre_d02 
          FILL-IN_tarjeta-circulacion-2 FILL-IN_tarjeta-circulacion 
          FILL-IN_CodPro FILL-IN_Ruc FILL-IN_NomPro RADIO-SET_libre_d01a 
          FILL-IN-entrega FILL-IN-brevete FILL-IN-DNI FILL-IN-nombre 
          FILL-IN-apellido FILL-IN-brevetevcto COMBO-BOX-motivo EDITOR-detalle 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-10 RECT-12 RECT-13 BROWSE-2 BUTTON-1 COMBO-BOX-filtro 
         FILL-IN-desde COMBO-BOX-motivo EDITOR-detalle BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE extrae-data-from-db W-Win 
PROCEDURE extrae-data-from-db :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* tablas temporales */    
EMPTY TEMP-TABLE gre_header_disponibles.
EMPTY TEMP-TABLE gre_header_seleccionados.

DEFINE VAR cParametro AS CHAR.
DEFINE VAR iDias AS INT.

iRegis = 0.

dFechaDesde = fill-in-desde.

/*
/**/
RUN gre/get-parametro-config-gre("PARAMETRO","PANTALLA","BAJASENSUNAT","N","15",OUTPUT cParametro).

iDias = INTEGER(cParametro).

dFechaDesde = DATETIME(string(TODAY - iDias) + " 00:00:00").

fill-in-desde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(DATE(dFechaDesde),"99/99/9999").
*/

/*
dFechaDesde = DATE(9,28,2023).
MESSAGE s-coddiv SKIP
    dFechaDesde.
*/

RUN tempo_grabar('ACEPTADO POR SUNAT').
RUN tempo_grabar('BAJA EN SUNAT').

{&open-query-browse-2}
{&open-query-browse-9}

IF iRegis > 0 THEN DO:
    APPLY 'VALUE-CHANGED':U TO browse-2 IN FRAME {&FRAME-NAME}.
END.

END PROCEDURE.

/**/
PROCEDURE tempo_grabar:
    DEFINE INPUT PARAMETER pEstado AS CHAR.

    DEFINE VAR cCodRef AS CHAR.
    DEFINE VAR cNroRef AS CHAR.
    DEFINE VAR cNroPHR AS CHAR.
    DEFINE VAR cCmpte AS CHAR.    
   
    SESSION:SET-WAIT-STATE("GENERAL").
    FOR EACH gre_header WHERE gre_header.m_rspta_sunat = pEstado AND
                         gre_header.m_divorigen = s-coddiv AND gre_header.fechahora_envio_a_sunat >= dFechaDesde NO-LOCK:
        CREATE gre_header_disponibles.
        BUFFER-COPY gre_header TO gre_header_disponibles.

        CREATE gre_header_seleccionados.
        BUFFER-COPY gre_header TO gre_header_seleccionados.

        /* */
        ASSIGN gre_header_disponibles.cImpreso = "NO".
        FIND FIRST gre_header_impresiones WHERE gre_header_impresiones.ncorrelativo = gre_header.ncorrelatio NO-LOCK NO-ERROR.
        IF AVAILABLE gre_header_impresiones THEN DO:
            ASSIGN gre_header_disponibles.cImpreso = "SI".
        END.

        iRegis = iRegis + 1.

        cNroPHR = "".
        cCodRef = gre_header.m_coddoc.
        cNroRef = STRING(gre_header.m_serie,"999") + STRING(gre_header.m_nrodoc,"999999").
        cCmpte = "".

        /* Buscar la PHR */
        IF gre_header.m_coddoc <> 'OTR' THEN DO:
            /* Buscar la O/D */
            cCmpte = STRING(gre_header.m_nroser,"999") + STRING(gre_header.m_nrodoc,"99999999").
            cCodRef = "".
            cNroRef = "".
            FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND ccbcdocu.coddoc = gre_header.m_coddoc AND
                                        ccbcdocu.nrodoc = cCmpte NO-LOCK NO-ERROR.
            IF AVAILABLE ccbcdocu THEN DO:
                cCodRef = ccbcdocu.libre_c01.   /* O/D */
                cNroRef = ccbcdocu.libre_c02.
            END.
        END.

        FIND FIRST di-rutaD WHERE di-rutaD.codcia = s-codcia AND di-rutaD.coddoc = 'PHR' AND
                                    di-rutaD.codref = cCodRef AND di-rutaD.nroref = cNroRef AND 
                                    LOOKUP(di-rutaD.flgest,"A,C") = 0
                                    /*di-rutaD.flgest <> 'A'*/ NO-LOCK NO-ERROR.
        IF AVAILABLE di-rutaD THEN DO:
            cNroPHR = di-rutaD.nrodoc.
        END.
        ASSIGN gre_header_disponibles.nombrePuertoAeropuerto = cNroPHR.
        ASSIGN gre_header_seleccionados.nombrePuertoAeropuerto = cNroPHR.

        /* Placa del Vehiculo */
        ASSIGN gre_header_disponibles.m_libre_c05 = "".
        ASSIGN gre_header_seleccionados.m_libre_c05 = "".
        ASSIGN gre_header_seleccionados.m_fechahorareg = ?.

        FIND FIRST gre_vehiculo_hdr WHERE gre_vehiculo_hdr.ncorrelativo = gre_header.correlativo_vehiculo AND
                                             gre_vehiculo_hdr.placa = gre_header.numeroPlacaVehiculoPri NO-LOCK NO-ERROR.
        IF AVAILABLE gre_vehiculo_hdr THEN DO:
            ASSIGN gre_header_disponibles.m_libre_c05 = gre_vehiculo_hdr.placa
                    gre_header_disponibles.m_fechahorareg = gre_vehiculo_hdr.fhregistro.
            ASSIGN gre_header_seleccionados.m_libre_c05 = gre_vehiculo_hdr.placa
                    gre_header_seleccionados.m_fechahorareg = gre_vehiculo_hdr.fhregistro.
        END.

    END.
    SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTexto W-Win 
PROCEDURE getTexto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pContent AS LONGCHAR.
    DEFINE INPUT PARAMETER pTagInicial AS CHAR.
    DEFINE INPUT PARAMETER ptagFinal AS CHAR.
    DEFINE OUTPUT PARAMETER pRetVal AS LONGCHAR.

    DEFINE VAR iPosInicial AS INT.
    DEFINE VAR iPosFinal AS INT.

    iPosInicial = INDEX(pContent,pTagInicial).
    IF iPosInicial > 0 THEN DO:
        iPosFinal = INDEX(pContent,pTagFinal).
        IF iPosFinal > 0 THEN DO:
            pRetVal = SUBSTRING(pContent,iPosInicial + LENGTH(pTagInicial),(iPosFinal - (iPosInicial + LENGTH(pTagInicial))) ).
        END.
        ELSE DO:
            pRetVal = SUBSTRING(pContent,iPosInicial + LENGTH(pTagInicial) ).
        END.

        pRetVal = TRIM(pRetVal).

        IF pRetVal = ? THEN pRetVal = "".
    END.


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
/*
  /* Code placed here will execute AFTER standard behavior.    */    
  DEF VAR pSeries AS CHAR NO-UNDO.

  DEF VAR s-printer-list  AS CHAR NO-UNDO.
  DEF VAR s-port-list     AS CHAR NO-UNDO.
  DEF VAR s-printer-count AS INT  NO-UNDO.
  DEF VAR iPrinter-count AS INT.


  /* Definimos impresoras */
  RUN aderb/_prlist ( OUTPUT s-printer-list,
                      OUTPUT s-port-list,
                      OUTPUT s-printer-count ).

  IF s-printer-count <> 0 THEN DO:
      DO WITH FRAME {&FRAME-NAME}:
        DO iPrinter-count = 1 TO NUM-ENTRIES(s-Printer-list):
            COMBO-BOX-impresoras:ADD-LAST(ENTRY(iPrinter-count,s-Printer-list)).
        END.
        COMBO-BOX-impresoras = ENTRY(1,COMBO-BOX-impresoras:LIST-ITEMS).
        /*s-printer-port = ENTRY(1,cPort-list).*/
        DISPLAY COMBO-BOX-impresoras.
      END.
  END.

  DO WITH FRAME {&FRAME-NAME}:
      /*  */
      fill-in-copias:SCREEN-VALUE = "ORIGINAL".

      FIND FIRST vtatabla WHERE vtatabla.codcia = 1 AND vtatabla.tabla = "CONFIG-GRE" AND
                vtatabla.llave_c1 = "IMPRESION" AND vtatabla.llave_c2 = 'COPIAS' AND 
                vtatabla.llave_c3 = s-coddiv NO-LOCK NO-ERROR.
      IF NOT AVAILABLE vtatabla THEN DO:
          FIND FIRST vtatabla WHERE vtatabla.codcia = 1 AND vtatabla.tabla = "CONFIG-GRE" AND
                    vtatabla.llave_c1 = "IMPRESION" AND vtatabla.llave_c2 = 'COPIAS' AND 
                    vtatabla.llave_c3 = "TODAS LAS DIVISIONES" NO-LOCK NO-ERROR.
      END.
      IF AVAILABLE vtatabla THEN DO:
          fill-in-copias:SCREEN-VALUE = vtatabla.llave_c4.
      END.
      
  END.
*/

/*
  DO WITH FRAME {&FRAME-NAME}:
    /* Serie x Ventas */
    RUN gre/p-series-solo-gr-electronica (INPUT s-CodDiv,
                           INPUT "VENTAS", 
                           INPUT YES,
                           OUTPUT pSeries).
    combo-box-ventas:LIST-ITEMS = pSeries.
    combo-box-ventas = ENTRY(1,combo-box-ventas:LIST-ITEMS).
    DISPLAY combo-box-ventas.
    
    pSeries = "".
    /* Serie x NO Ventas */
    RUN gre/p-series-solo-gr-electronica (INPUT s-CodDiv,
                           INPUT "TRANSFERENCIAS", 
                           INPUT YES,
                           OUTPUT pSeries).

        combo-box-otros:LIST-ITEMS = pSeries.
        combo-box-otros = ENTRY(1,combo-box-otros:LIST-ITEMS).        
        DISPLAY combo-box-otros.
  END.
*/

DEFINE VAR cParametro AS CHAR.
DEFINE VAR iDias AS INT.

iRegis = 0.

/**/
RUN gre/get-parametro-config-gre("PARAMETRO","PANTALLA","BAJASENSUNAT","N","15",OUTPUT cParametro).

iDias = INTEGER(cParametro).

dFechaDesde = DATETIME(string(TODAY - iDias) + " 00:00:00").

DO WITH FRAME {&FRAME-NAME}:
    fill-in-desde:SCREEN-VALUE = STRING(DATE(dFechaDesde),"99/99/9999").
    /*fill-in-desde:VISIBLE = YES.*/
    fill-in-desde:ENABLED = NO.
    fill-in-desde:READ-ONLY = YES.
    IF LOOKUP(USERID("DICTDB"),"ADMIN,MASTER") > 0 THEN DO:
        /*fill-in-desde:ENABLED = YES.*/
        fill-in-desde:READ-ONLY = NO.
    END.
    
END.

  DO WITH FRAME {&FRAME-NAME}:

        COMBO-BOX-motivo:DELETE(COMBO-BOX-motivo:NUM-ITEMS).
        COMBO-BOX-motivo:SCREEN-VALUE = "".

        FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = cTabla AND 
                                vtatabla.llave_c1 = cLlave_c1 AND vtatabla.llave_c2 = cLlave_c2 AND
                                vtatabla.libre_c01 = 'SI' NO-LOCK :
                        COMBO-BOX-motivo:ADD-LAST(vtatabla.llave_c4, vtatabla.llave_c3).
                IF TRUE <> (COMBO-BOX-motivo:SCREEN-VALUE > "") THEN DO:
                    ASSIGN COMBO-BOX-motivo:SCREEN-VALUE = vtatabla.llave_c3.
                END.
        END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE motivo-rechazo W-Win 
PROCEDURE motivo-rechazo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
DEFINE VAR cEstadoBizLinks AS CHAR.  
DEFINE VAR cEstadoSUNAT AS CHAR.
DEFINE VAR cEstadoDocumento AS CHAR.

DEFINE VAR iRow AS INT.
DEFINE VAR iRowsSelected AS INT.

DEFINE VAR cNrodoc AS CHAR.
DEFINE VAR cCoddiv AS CHAR.

DEFINE VAR rRowId AS ROWID.

DO WITH FRAME {&FRAME-NAME}:
    iRowsSelected = browse-2:NUM-SELECTED-ROWS.

    IF iRowsSelected > 0 THEN DO:
        SESSION:SET-WAIT-STA("GENERAL").
        DO iRow = 1 TO iRowsSelected :
            IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(iRow) THEN DO:
                /*cCoddiv = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.coddivdesp.*/
                cNrodoc = STRING({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.serieGuia,"999") + 
                            STRING({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.numeroGuia,"99999999").

                cEstadoSUNAT = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.m_rspta_sunat.
                /*IF LOOKUP(cEstadoSUNAT,"ENVIADO A SUNAT,ESPERANDO RESPUESTA SUNAT") > 0 THEN DO:*/
                    RUN gn/p-estado-documento-electronico-v2(cCoddoc, cNrodoc, cCoddiv,
                                                          OUTPUT cEstadoBizLinks, OUTPUT cEstadoSunat, OUTPUT cEstadoDocumento).
                    rRowId = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.rRowId.
                    FIND FIRST b-gre_header WHERE ROWID(b-gre_header) = rRowid EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAILABLE b-gre_header THEN DO:
                        ASSIGN b-gre_header.m_rspta_sunat = CAPS(cEstadoDocumento)
                                b-gre_header.m_estado_bizlinks = CAPS(ENTRY(1,cEstadoBizLinks,"|")).
                        RELEASE b-gre_header NO-ERROR.
                        browse-2:REFRESH().
                        /*  */
                        ASSIGN {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.m_rspta_sunat = "LOQUESEA".   /* solo para q no lo muestre en pantalla */
                    END.
                    ELSE DO:
                        RELEASE b-gre_header NO-ERROR.
                    END.
                    /*  */
                /*END.*/
            END.
        END.
        SESSION:SET-WAIT-STA("").
    END.
END.

{&open-query-browse-2}
    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE muestra-datos-transporte W-Win 
PROCEDURE muestra-datos-transporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN 
    /*FILL-IN-peso:SCREEN-VALUE = ""*/
    fill-in-placa:SCREEN-VALUE = ""
    fill-in_marca:SCREEN-VALUE = ""
    fill-in_carga:SCREEN-VALUE = ""
    FILL-IN_libre_d01:SCREEN-VALUE = ""
    FILL-IN_libre_c02:SCREEN-VALUE = ""
    FILL-IN_libre_c04:SCREEN-VALUE = ""
    RADIO-SET_libre_d02:SCREEN-VALUE = ""
    FILL-IN_codpro:SCREEN-VALUE = ""
    FILL-IN_nompro:SCREEN-VALUE = ""
    FILL-IN_ruc:SCREEN-VALUE = ""
    RADIO-SET_libre_d01a:SCREEN-VALUE = ""
    fill-in-brevete:SCREEN-VALUE = ""
    fill-in-dni:SCREEN-VALUE = ""
    fill-in-nombre:SCREEN-VALUE = ""
    fill-in-apellido:SCREEN-VALUE = ""
    fill-in-brevetevcto:SCREEN-VALUE = ""
    fill-in-entrega:SCREEN-VALUE = ""
    FILL-IN_tarjeta-circulacion:SCREEN-VALUE = "".

    ASSIGN fill-in-placa-2:SCREEN-VALUE = ""
    fill-in_marca-2:SCREEN-VALUE = ""
    fill-in_carga-2:SCREEN-VALUE = ""
    FILL-IN_libre_d01-2:SCREEN-VALUE = ""
    FILL-IN_libre_c02-2:SCREEN-VALUE = ""
    FILL-IN_libre_c04-2:SCREEN-VALUE = ""
    RADIO-SET_libre_d02-2:SCREEN-VALUE = ""
    FILL-IN_tarjeta-circulacion-2:SCREEN-VALUE = "".
/*
    FILL-IN-cmotivo:SCREEN-VALUE = ""
    editor-dmotivo:SCREEN-VALUE = "".
*/
    FIND FIRST gre_vehiculo_hdr WHERE gre_vehiculo_hdr.ncorrelativo = gre_header_disponibles.correlativo_vehiculo AND 
            gre_vehiculo_hdr.placa = gre_header_disponibles.numeroPlacaVehiculoPrin  NO-LOCK NO-ERROR.
    IF AVAILABLE gre_vehiculo_hdr THEN DO:
        ASSIGN 
        /*FILL-IN-peso:SCREEN-VALUE = STRING(gre_vehiculo_hdr.pesototal)*/
        fill-in-placa:SCREEN-VALUE = gre_vehiculo_hdr.placa
        fill-in_marca:SCREEN-VALUE = gre_vehiculo_hdr.marca
        fill-in_carga:SCREEN-VALUE = STRING(gre_vehiculo_hdr.cargamaxima)
        FILL-IN_libre_d01:SCREEN-VALUE = STRING(gre_vehiculo_hdr.capacidadmax)
        FILL-IN_libre_c02:SCREEN-VALUE = gre_vehiculo_hdr.tonelaje
        FILL-IN_libre_c04:SCREEN-VALUE = gre_vehiculo_hdr.registroMTC
        RADIO-SET_libre_d02:SCREEN-VALUE = IF(gre_vehiculo_hdr.catvehM1L = YES ) THEN '1' ELSE '0'
        FILL-IN_codpro:SCREEN-VALUE = gre_vehiculo_hdr.codtransportista
        FILL-IN_nompro:SCREEN-VALUE = gre_vehiculo_hdr.transp_razonsocial
        FILL-IN_ruc:SCREEN-VALUE = gre_vehiculo_hdr.transp_ruc
        RADIO-SET_libre_d01a:SCREEN-VALUE = STRING(gre_vehiculo_hdr.transp_modalidad)
        fill-in-brevete:SCREEN-VALUE = gre_vehiculo_hdr.brevete
        fill-in-dni:SCREEN-VALUE = gre_vehiculo_hdr.chofer_dni
        fill-in-nombre:SCREEN-VALUE = gre_vehiculo_hdr.chofer_nombre
        fill-in-apellido:SCREEN-VALUE = gre_vehiculo_hdr.chofer_apellidos
        fill-in-brevetevcto:SCREEN-VALUE = string(gre_vehiculo_hdr.chofer_vctobrevete,"99/99/9999")
        fill-in-entrega:SCREEN-VALUE = string(gre_header_disponibles.fechaEntregaBienes,"99/99/9999")
        FILL-IN_tarjeta-circulacion:SCREEN-VALUE = gre_vehiculo_hdr.codtransportista
        .
    END.
    FIND FIRST gre_vehiculo_hdr WHERE gre_vehiculo_hdr.ncorrelativo = gre_header_disponibles.correlativo_vehiculo AND 
            gre_vehiculo_hdr.placa = gre_header_disponibles.numeroPlacaVehiculoSec1  NO-LOCK NO-ERROR.
    IF AVAILABLE gre_vehiculo_hdr THEN DO:
        ASSIGN 
        fill-in-placa-2:SCREEN-VALUE = gre_vehiculo_hdr.placa
        fill-in_marca-2:SCREEN-VALUE = gre_vehiculo_hdr.marca
        fill-in_carga-2:SCREEN-VALUE = STRING(gre_vehiculo_hdr.cargamaxima)
        FILL-IN_libre_d01-2:SCREEN-VALUE = STRING(gre_vehiculo_hdr.capacidadmax)
        FILL-IN_libre_c02-2:SCREEN-VALUE = gre_vehiculo_hdr.tonelaje
        FILL-IN_libre_c04-2:SCREEN-VALUE = gre_vehiculo_hdr.registroMTC
        RADIO-SET_libre_d02-2:SCREEN-VALUE = IF(gre_vehiculo_hdr.catvehM1L = YES ) THEN '1' ELSE '0'
        FILL-IN_tarjeta-circulacion-2:SCREEN-VALUE = gre_vehiculo_hdr.codtransportista
        .
    END.
    /*
    FIND FIRST gre_header_log WHERE gre_header_log.ncorrelatio = gre_header_disponibles.ncorrelatio AND
                                     gre_header_log.m_motivo_log = "BAJA EN SUNAT" NO-LOCK NO-ERROR.
    IF AVAILABLE gre_header_log THEN DO:
        FILL-IN-cmotivo:SCREEN-VALUE = gre_header_log.cmotivo.
        editor-dmotivo:SCREEN-VALUE = gre_header_log.dmotivo_detalle.
        FIND FIRST x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND x-vtatabla.tabla = "CONFIG-GRE" AND
                                    x-vtatabla.llave_c1 = "MOTIVO" AND x-vtatabla.llave_c2 = "BAJA SUNAT" AND
                                    x-vtatabla.llave_c3 = gre_header_log.cmotivo NO-LOCK NO-ERROR.
        IF AVAILABLE x-vtatabla THEN DO:
            FILL-IN-cmotivo:SCREEN-VALUE = gre_header_log.cmotivo + " " + x-vtatabla.llave_c4.
        END.
    END.
    */
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar-la-baja W-Win 
PROCEDURE procesar-la-baja :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:

    IF browse-2:NUM-SELECTED-ROWS <= 0 THEN RETURN "OK".

    DEFINE VAR iRowsSelected AS INT.
    DEFINE VAR cCodDoc AS CHAR.
    DEFINE VAR iSerieDoc AS INT.
    DEFINE VAR iNroDoc AS INT.
    DEFINE VAR iRow AS INT.
    DEFINE VAR cRetVal AS CHAR.
    DEFINE VAR iNuevoPGRE AS INT.
    DEFINE VAR dtfechahora_envio_a_sunat AS DATETIME.
    DEFINE VAR iSerieGuia AS INT.
    DEFINE VAR iNumeroGuia AS INT.
    DEFINE VAR cSerieGuia AS CHAR.
    DEFINE VAR cNumeroGuia AS CHAR.
    DEFINE VAR cMessageError AS CHAR.
    DEFINE VAR iProcesados AS INT.

    DEFINE VAR cValorDeRetorno AS CHAR.
    DEFINE VAR iPlazoDias AS INT.
    DEFINE VAR iDiasAntigueda AS INT.
    DEFINE VAR iDiasAntiguedaEnviado_a_Sunat AS INT.

    /*RUN gre/get-parametro-config-gre("PARAMETRO","BAJA SUNAT","PLAZO-DIAS","N","3",OUTPUT cValorDeRetorno).*/
    RUN gre/get-parametro-config-gre("PARAMETRO","BAJA_EN_SUNAT","MAXIMO_DIAS","N","5",OUTPUT cValorDeRetorno).
    IF cValorDeRetorno = "ERROR" THEN DO:
        MESSAGE "No se pudo encontrar el parametro de plazo en dias para baja sunat" VIEW-AS ALERT-BOX INFORMATION.
        RETURN "ADM-ERROR".
    END.        
    iPlazoDias = INTEGER(TRIM(cValorDeRetorno)).

    iRowsSelected = browse-2:NUM-SELECTED-ROWS.

    SESSION:SET-WAIT-STA("GENERAL").
    DO iRow = 1 TO iRowsSelected :
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(iRow) THEN DO:            
            cCoddoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.m_coddoc.
            iSerieDoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.m_nroser.
            iNroDoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.m_nrodoc.

            FIND FIRST x-gre_header WHERE x-gre_header.serieGuia = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.serieGuia AND 
                            x-gre_header.numeroGuia = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.numeroGuia NO-LOCK NO-ERROR.

            IF NOT AVAILABLE x-gre_header THEN DO:
                IF cMessageError = "" THEN DO:
                    cMessageError = "No existe GRE " + STRING({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.serieGuia,"999") + "-" + 
                        STRING({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.numeroGuia,"99999999") .
                END.                
                NEXT.
            END.            
            IF x-gre_header.m_rspta_sunat <> "ACEPTADO POR SUNAT"  THEN DO:
                IF cMessageError = "" THEN DO:
                    cMessageError = "La GRE " + STRING({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.serieGuia,"999") + "-" + 
                    STRING({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.numeroGuia,"99999999") + " Debe estar aceptado por SUNAT".
                END.
                NEXT.
            END.

            /* 
            /* Que la OTR, FAI, FAC, BOL no este anulado */
            RUN verifica-documento(cCodDoc, iSerieDoc, iNroDoc, OUTPUT cRetVal).
            IF cRetVal <> "OK" THEN DO:
                IF iRowsSelected = 1 THEN DO:
                    MESSAGE cRetval VIEW-AS ALERT-BOX INFORMATION.
                END.
                NEXT.
            END.
            */

            cSerieGuia  = STRING({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.serieGuia,"999").
            cNumeroGuia = STRING({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.numeroGuia,"99999999").
            iSerieGuia  = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.serieGuia.
            iNumeroGuia = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.numeroGuia.
            dtfechahora_envio_a_sunat = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.fechahora_envio_a_sunat.

            /* Por transferencias no debe estar recepcionada */                
            IF {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.m_codmov = 03 THEN DO:
                RUN verifica-gre-no-recepcionada({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.serieGuia, 
                                                 {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.numeroGuia,
                                                 OUTPUT cRetVal).
                IF cRetVal <> "OK" THEN DO:
                    IF cMessageError = "" THEN DO:
                        cMessageError = cRetval.
                    END.
                    NEXT.
                END.            
            END.
            /* Que no este en H/R */

            /* Ventas */
            FIND FIRST di-rutaD WHERE di-rutaD.codcia = s-codcia AND di-rutaD.coddoc = 'H/R' AND 
                                        di-rutaD.codref = cSerieGuia AND di-rutaD.nroref = cNumeroGuia NO-LOCK NO-ERROR.
            IF AVAILABLE di-rutaD THEN DO:
                IF di-rutaD.flgest <> 'N'  THEN DO:         /* N: No entregado 24Feb2025 */
                    FIND FIRST di-rutaC OF di-rutaD NO-LOCK NO-ERROR.
                    IF AVAILABLE di-rutaC AND di-rutaC.flgest <> 'A'  THEN DO:
                        IF cMessageError = "" THEN DO:
                            cMessageError = "La GRE tiene Hoja de Ruta " + di-rutaC.nrodoc.
                        END.
                        NEXT.
                    END.
                END.
            END.
            /* Transferencias x OTR */
            FIND FIRST di-rutaG WHERE di-rutaG.codcia = s-codcia AND di-rutaG.coddoc = 'H/R' AND 
                                    di-rutaG.codalm = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.m_codalm AND
                                    di-rutaG.tipmov = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.m_tipmov AND
                                    di-rutaG.codmov = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.m_codmov AND
                                    di-rutaG.serref = iSerieGuia AND di-rutaG.nroref = inumeroGuia NO-LOCK NO-ERROR.
            IF AVAILABLE di-rutaG AND di-rutaG.flgest <> 'N' THEN DO:       /* Esta estregado (N:No entregado) */
                FIND FIRST di-rutaC OF di-rutaG NO-LOCK NO-ERROR.
                IF AVAILABLE di-rutaC AND di-rutaC.flgest <> 'A'  THEN DO:
                    IF cMessageError = "" THEN DO:
                        cMessageError = "La GRE tiene Hoja de Ruta " + di-rutaC.nrodoc.
                    END.
                    NEXT.
                END.
            END.
            /* Itinerantes .... di-rutaDG, no tiene el indice adecuado, queda pendiente */
            FIND FIRST di-rutaDG WHERE di-rutaDG.codcia = s-codcia AND di-rutaDG.coddoc = 'H/R' AND 
                                        di-rutaDG.codref = 'G/R' AND di-rutaDG.nroref = (cSerieGuia + cnumeroGuia) NO-LOCK NO-ERROR.
            IF AVAILABLE di-rutaDG AND di-rutaG.flgest <> 'N' THEN DO:       /* Esta estregado (N:No entregado) */
                FIND FIRST di-rutaC OF di-rutaDG NO-LOCK NO-ERROR.
                IF AVAILABLE di-rutaC AND di-rutaC.flgest <> 'A'  THEN DO:
                    IF cMessageError = "" THEN DO:
                        cMessageError = "La GRE tiene Hoja de Ruta " + di-rutaC.nrodoc.
                    END.
                    NEXT.
                END.
            END.

            /*  */
            iDiasAntiguedaEnviado_a_Sunat = INTERVAL(TODAY,DATE(dtfechahora_envio_a_sunat),'days').
            IF iDiasAntiguedaEnviado_a_Sunat > iPlazoDias THEN DO:
                IF cMessageError = "" THEN DO:
                    cMessageError = "La GRE " + STRING(iSerieGuia,"999") + "-" + STRING(iNumeroGuia,"99999999") + " fue aceptado a sunat hace " + STRING(iDiasAntiguedaEnviado_a_Sunat) + " dia(s) " +
                            "y el maximo de dias para la baja es " + STRING(iPlazoDias) .
                END.
                /*RETURN "ADM-ERROR".*/
                NEXT.
            END.
            /*
            cMotivo = "".
            cMotivoDetalle = "".
            RUN gre/d-motivo-baja-sunat.r(OUTPUT cMotivo, OUTPUT cMotivoDetalle, OUTPUT cRetVal).
            IF cRetVal <> "OK" THEN DO:
                NEXT.
            END.
            */

            /* La BAJA */
            iNuevoPGRE = 0.
            RUN dar-de-baja-gre({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.serieGuia, 
                                                 {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.numeroGuia, OUTPUT iNuevoPGRE,
                                                 OUTPUT cRetVal).
            IF cRetVal = "OK" THEN DO:
                ASSIGN {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.m_rspta_sunat = "BAJA EN SUNAT".
                iProcesados = iProcesados + 1.
                /*MESSAGE "Se procedio a generar una nueva PGRE No.: " + STRING(iNuevoPGRE) VIEW-AS ALERT-BOX INFORMATION.*/
            END.
            ELSE DO:
                IF cMessageError = "" THEN DO:
                    cMessageError = cRetVal.
                END.
                /*
                MESSAGE cRetVal SKIP
                    "Verifique el porque del ERROR" VIEW-AS ALERT-BOX INFORMATION.
                */
            END.
        END.
    END.
    SESSION:SET-WAIT-STA("").

    BROWSE-2:REFRESH().    
END.

IF cMessageError <> "" THEN DO:  
    cMessageError = "Se dieron de Baja " + STRING(iProcesados) + " de " + STRING(iRowsSelected) + " GRE " + chr(10) + cMessageError.
END.
ELSE DO:
    cMessageError = "Se dieron de Baja " + STRING(iProcesados) + " de " + STRING(iRowsSelected) + " GRE ".
END.

MESSAGE cMessageError VIEW-AS ALERT-BOX INFORMATION.

BROWSE-2:DESELECT-ROWS().


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE seleccion-masiva W-Win 
PROCEDURE seleccion-masiva :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*                    
DEFINE VAR rRowId AS ROWID.
DEFINE VAR iCorrelativo AS INT.
DEFINE VAR iRowsSelected AS INT.
DEFINE VAR iRow AS INT.

DO WITH FRAME {&FRAME-NAME}:
    iRowsSelected = browse-2:NUM-SELECTED-ROWS.

    IF iRowsSelected > 1 THEN DO:
        SESSION:SET-WAIT-STA("GENERAL").
        DO iRow = 1 TO iRowsSelected :
            IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(iRow) THEN DO:

                iCorrelativo = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nCorrelatio.

                FIND FIRST gre_header_seleccionados WHERE gre_header_seleccionados.ncorrelatio = gre_header_disponibles.ncorrelatio
                              EXCLUSIVE-LOCK NO-ERROR.
                IF AVAILABLE gre_header_seleccionados THEN DO:
                    ASSIGN gre_header_disponibles.m_cco = "SELE".
                    ASSIGN gre_header_seleccionados.m_cco = "OK".

                    dPesoTotal = dPesoTotal + gre_header_seleccionados.pesoBrutoTotalBienes.
                END.
            END.
        END.
        RUN show_totales.

          {&open-query-browse-2}
          {&open-query-browse-9}

        SESSION:SET-WAIT-STA("").

    END.
END.
*/

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
  {src/adm/template/snd-list.i "gre_header_disponibles"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE show_totales W-Win 
PROCEDURE show_totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    /*fill-in-peso:SCREEN-VALUE = STRING(dPesoTotal,">,>>>,>>9.99").*/
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verifica-documento W-Win 
PROCEDURE verifica-documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcCodDoc AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER piSerieDoc AS INT NO-UNDO.
DEFINE INPUT PARAMETER piNroDoc AS INT NO-UNDO.
DEFINE OUTPUT PARAMETER pcRetVal AS CHAR NO-UNDO.

DEFINE VAR cNroDoc AS CHAR.

pcRetVal = "OK".
IF TRUE <> (pcCodDoc > "") THEN RETURN "OK".

cNroDoc = STRING(piSerieDoc,"999") + STRING(piNroDoc,"999999").

IF LOOKUP(pcCodDoc,"FAC,BOL") > 0 THEN cNroDoc = STRING(piSerieDoc,"999") + STRING(piNroDoc,"99999999").

IF pcCodDoc = 'OTR' THEN DO:
    FIND FIRST faccpedi WHERE faccpedi.codcia = 1 AND faccpedi.coddoc = pcCodDoc AND 
                                faccpedi.nroped = cNroDoc NO-LOCK NO-ERROR.
    IF NOT AVAILABLE faccpedi THEN DO:
        pcRetVal = "El documento " + pcCodDoc + " " + cNroDoc + " NO EXISTE".
        RETURN "ADM-ERROR".
    END.
    IF faccpedi.flgest = "A" THEN DO:
        pcRetVal = "El documento " + pcCodDoc + " " + cNroDoc + " esta ANULADO".
        RETURN "ADM-ERROR".
    END.
END.
ELSE DO:
    FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = 1 AND ccbcdocu.coddoc = pcCodDoc AND
                            ccbcdocu.nrodoc = cNroDoc NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ccbcdocu THEN DO:
        pcRetVal = "El documento " + pcCodDoc + " " + cNroDoc + " NO EXISTE".
        RETURN "ADM-ERROR".
    END.
    IF ccbcdocu.flgest = "A" THEN DO:
        pcRetVal = "El documento " + pcCodDoc + " " + cNroDoc + " esta ANULADO".
        RETURN "ADM-ERROR".
    END.
END.

pcRetVal = "OK".

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verifica-gre-no-recepcionada W-Win 
PROCEDURE verifica-gre-no-recepcionada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER piSerieGuia AS INT NO-UNDO.
DEFINE INPUT PARAMETER piNumeroGuia AS INT NO-UNDO.
DEFINE OUTPUT PARAMETER pcRetVal AS CHAR NO-UNDO.

FIND FIRST x-gre_header WHERE x-gre_header.serieGuia = piSerieGuia AND
                                x-gre_header.numeroGuia = piNumeroGuia NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-gre_header THEN DO:
    pcRetval = "GRE " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999") +  " no existe".
    RETURN "ADM-ERROR".
END.

/* Lo buscamos en el movimiento de almacen */
FIND FIRST x-almcmov WHERE x-almcmov.codcia = 1 AND x-almcmov.codalm = x-gre_header.m_codalm AND
                            x-almcmov.tipmov = x-gre_header.m_tipmov AND x-almcmov.codmov = x-gre_header.m_codmov AND
                            x-almcmov.nroser = x-gre_header.serieGuia AND x-almcmov.nroDoc = x-gre_header.numeroGuia
                            NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-almcmov THEN DO:
    pcRetval = "GRE " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999") +  " no existe en movimientos de almacen".
    RETURN "ADM-ERROR".
END.
IF x-almcmov.flgest = "A" THEN DO:
    pcRetval = "GRE " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999") +  " esta ANULADO".
    RETURN "ADM-ERROR".
END.
IF x-almcmov.flgSit = "R" THEN DO:
    pcRetval = "GRE " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999") +  " ya fue recepcionada por el almacen destino".
    RETURN "ADM-ERROR".
END.

pcRetVal = "OK".

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-impresiones W-Win 
FUNCTION fget-impresiones RETURNS INTEGER
  ( INPUT pNroPGRE AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR iQtyImpresiones AS INT INIT 0.

    FOR EACH gre_header_impresiones WHERE gre_header_impresiones.ncorrelativo = pNroPGRE NO-LOCK:
        iQtyImpresiones = iQtyImpresiones + 1.
    END.

  RETURN iQtyImpresiones.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

