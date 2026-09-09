&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE gre_header_disponibles NO-UNDO LIKE gre_header.
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
DEFINE SHARED VAR s-acceso-total  AS LOG.   /* Control GRE */

/* Local Variable Definitions ---                                       */

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.

DEFINE VAR cCoddoc AS CHAR INIT 'G/R'.      /* Si cambia aqui debe ir a p-series-solo-gr-electronica */

/* En definitions */
define var x-sort-column-current as char.

DEFINE BUFFER b-gre_header FOR gre_header.
DEFINE BUFFER b-faccorre FOR faccorre.

DEFINE VAR iSerieVenta AS INT.
DEFINE VAR iSerieResto AS INT.

DEFINE VAR gcCRLF AS CHAR.
ASSIGN gcCRLF = CHR(13) + CHR(10).

DEFINE VAR cNroPHR AS CHAR INIT "".
DEFINE VAR cNroOrden AS CHAR INIT "".
DEFINE VAR cTipoOrden AS CHAR INIT "<Todos>".

DEFINE VAR cFilertexto AS CHAR.

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
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 gre_header_disponibles.m_libre_c05 ~
gre_header_disponibles.fechahora_asigna_vehiculo ~
gre_header_disponibles.m_estado_bizlinks gre_header_disponibles.ncorrelatio ~
gre_header_disponibles.m_fechahorareg ~
gre_header_disponibles.correoRemitente ~
gre_header_disponibles.correoDestinatario ~
gre_header_disponibles.nombrePuertoAeropuerto ~
gre_header_disponibles.m_coddoc gre_header_disponibles.m_nroser ~
gre_header_disponibles.m_nrodoc gre_header_disponibles.motivoTraslado ~
gre_header_disponibles.descripcionMotivoTraslado ~
gre_header_disponibles.razonSocialDestinatario ~
gre_header_disponibles.direccionPtoLlegada ~
gre_header_disponibles.m_motivo_de_rechazo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH gre_header_disponibles ~
      WHERE (gre_header_disponibles.m_cco = "") and ~
((cNroPHR = "" or gre_header_disponibles.nombrePuertoAeropuerto = cNroPHR) and ~
(cTipoOrden = '<Todos>' or gre_header_disponibles.correoRemitente = cTipoOrden) and ~
(cNroOrden = "" or gre_header_disponibles.correoDestinatario = cNroOrden) ~
) NO-LOCK ~
    BY gre_header_disponibles.fechahora_asigna_vehiculo DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH gre_header_disponibles ~
      WHERE (gre_header_disponibles.m_cco = "") and ~
((cNroPHR = "" or gre_header_disponibles.nombrePuertoAeropuerto = cNroPHR) and ~
(cTipoOrden = '<Todos>' or gre_header_disponibles.correoRemitente = cTipoOrden) and ~
(cNroOrden = "" or gre_header_disponibles.correoDestinatario = cNroOrden) ~
) NO-LOCK ~
    BY gre_header_disponibles.fechahora_asigna_vehiculo DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 gre_header_disponibles
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 gre_header_disponibles


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-12 RECT-11 RECT-10 RECT-13 RECT-14 ~
BROWSE-2 BUTTON-1 FILL-IN-phr COMBO-BOX-tipoorden FILL-IN-orden ~
BUTTON-filtrar BUTTON-reset-filtros COMBO-BOX-ventas COMBO-BOX-otros ~
BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-phr COMBO-BOX-tipoorden ~
FILL-IN-orden FILL-IN-datos FILL-IN-placa-2 FILL-IN-placa FILL-IN_Marca-2 ~
FILL-IN_Marca FILL-IN_Carga-2 FILL-IN_Carga FILL-IN_Libre_d01-2 ~
FILL-IN_Libre_d01 FILL-IN_Libre_c02-2 FILL-IN_Libre_c02 FILL-IN_Libre_c04-2 ~
FILL-IN_Libre_c04 RADIO-SET_libre_d02 RADIO-SET_libre_d02-2 ~
FILL-IN_tarjeta-circulacion FILL-IN_tarjeta-circulacion-2 FILL-IN_CodPro ~
FILL-IN_Ruc FILL-IN_NomPro RADIO-SET_libre_d01a FILL-IN-brevete FILL-IN-DNI ~
FILL-IN-nombre FILL-IN-apellido FILL-IN-brevetevcto FILL-IN-entrega ~
COMBO-BOX-ventas COMBO-BOX-otros FILL-IN-peso FILL-IN-1 FILL-IN-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Refrescar data" 
     SIZE 24 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "Enviar a SUNAT" 
     SIZE 45 BY 1.12
     FGCOLOR 2 FONT 6.

DEFINE BUTTON BUTTON-filtrar 
     LABEL "Filtrar" 
     SIZE 15 BY .77.

DEFINE BUTTON BUTTON-reset-filtros 
     LABEL "Limpiar filtros" 
     SIZE 16.29 BY .77.

DEFINE VARIABLE COMBO-BOX-otros AS CHARACTER FORMAT "X(256)":U 
     LABEL "Guia otros traslados" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 10 BY 1
     FONT 11 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-tipoorden AS CHARACTER FORMAT "X(256)":U INITIAL "<Todos>" 
     LABEL "Tipo Orden" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "<Todos>","O/D","OTR" 
     DROP-DOWN-LIST
     SIZE 10.29 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE COMBO-BOX-ventas AS CHARACTER FORMAT "X(256)":U 
     LABEL "Guia Ventas" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 10 BY 1
     FONT 11 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(100)":U INITIAL "Para retirar la PGRE del vehiculo" 
      VIEW-AS TEXT 
     SIZE 28 BY .62
     BGCOLOR 15 FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(100)":U INITIAL "seleccione el registro y haga DOBLECLICK" 
      VIEW-AS TEXT 
     SIZE 36 BY .62
     BGCOLOR 15 FGCOLOR 4 FONT 6 NO-UNDO.

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

DEFINE VARIABLE FILL-IN-datos AS CHARACTER FORMAT "X(60)":U INITIAL "DATOS DEL VEHICULO Y TRANSPORTISTA PARA EL TRASLADO" 
     VIEW-AS FILL-IN 
     SIZE 56 BY .88
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-DNI AS CHARACTER FORMAT "X(10)":U 
     LABEL "D.N.I" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-entrega AS DATE FORMAT "99/99/9999":U 
     LABEL "Inicio del traslado" 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-nombre AS CHARACTER FORMAT "X(60)":U 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 43.43 BY .88
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-orden AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "No. Orden" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-peso AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Carga total de guias(Kgrs)" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88
     BGCOLOR 15 FGCOLOR 4 FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN-phr AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Nro de PHR" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     BGCOLOR 15  NO-UNDO.

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
     SIZE 25.86 BY .88
     BGCOLOR 15 FGCOLOR 4 FONT 4 NO-UNDO.

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
     SIZE 72 BY 6.88.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36 BY 7.54.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36 BY 7.54.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36 BY 7.54.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 72.57 BY 2.23.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      gre_header_disponibles SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      gre_header_disponibles.m_libre_c05 COLUMN-LABEL "Placa!Vehiculo" FORMAT "x(15)":U
            WIDTH 8.43
      gre_header_disponibles.fechahora_asigna_vehiculo COLUMN-LABEL "Fecha/Hora!Asigna vehiculo" FORMAT "99/99/9999 HH:MM:SS.SSS":U
            WIDTH 19.43
      gre_header_disponibles.m_estado_bizlinks COLUMN-LABEL "Estado!Bizlinks" FORMAT "x(30)":U
            WIDTH 12.43
      gre_header_disponibles.ncorrelatio COLUMN-LABEL "Nro ! PGRE" FORMAT ">>>>>>>>9":U
            WIDTH 10.43
      gre_header_disponibles.m_fechahorareg COLUMN-LABEL "Fecha/Hora!Emision PGRE" FORMAT "99/99/9999 HH:MM:SS.SSS":U
            WIDTH 19.43
      gre_header_disponibles.correoRemitente COLUMN-LABEL "Cod!Orden" FORMAT "x(6)":U
            WIDTH 5 COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 15
      gre_header_disponibles.correoDestinatario COLUMN-LABEL "Nro.!Orden" FORMAT "x(15)":U
            WIDTH 10.86 COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 15
      gre_header_disponibles.nombrePuertoAeropuerto COLUMN-LABEL "PHR" FORMAT "x(10)":U
            WIDTH 12.43 COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 15
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
      gre_header_disponibles.m_motivo_de_rechazo COLUMN-LABEL "Motivo de envio" FORMAT "x(200)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 113 BY 23.58
         FONT 3
         TITLE "PRE-GUIAS DE REMISION DISPONIBLES PARA ENVIAR A SUNAT" ROW-HEIGHT-CHARS .46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-2 AT ROW 1.12 COL 2 WIDGET-ID 200
     BUTTON-1 AT ROW 1.27 COL 163 WIDGET-ID 4
     FILL-IN-phr AT ROW 3.08 COL 137 RIGHT-ALIGNED WIDGET-ID 196
     COMBO-BOX-tipoorden AT ROW 3.08 COL 150.72 COLON-ALIGNED WIDGET-ID 200
     FILL-IN-orden AT ROW 3.08 COL 185 RIGHT-ALIGNED WIDGET-ID 198
     BUTTON-filtrar AT ROW 4.12 COL 146 WIDGET-ID 206
     BUTTON-reset-filtros AT ROW 4.12 COL 163.72 WIDGET-ID 208
     FILL-IN-datos AT ROW 5.12 COL 114.86 COLON-ALIGNED NO-LABEL WIDGET-ID 138
     FILL-IN-placa-2 AT ROW 6.23 COL 163 COLON-ALIGNED WIDGET-ID 158
     FILL-IN-placa AT ROW 6.27 COL 131 COLON-ALIGNED WIDGET-ID 8
     FILL-IN_Marca-2 AT ROW 7.15 COL 163 COLON-ALIGNED WIDGET-ID 160
     FILL-IN_Marca AT ROW 7.19 COL 126.14 COLON-ALIGNED WIDGET-ID 10
     FILL-IN_Carga-2 AT ROW 8.04 COL 169.14 COLON-ALIGNED WIDGET-ID 162
     FILL-IN_Carga AT ROW 8.08 COL 131 COLON-ALIGNED WIDGET-ID 14
     FILL-IN_Libre_d01-2 AT ROW 8.92 COL 169.14 COLON-ALIGNED WIDGET-ID 164
     FILL-IN_Libre_d01 AT ROW 8.96 COL 131 COLON-ALIGNED WIDGET-ID 20
     FILL-IN_Libre_c02-2 AT ROW 9.81 COL 169.14 COLON-ALIGNED WIDGET-ID 166
     FILL-IN_Libre_c02 AT ROW 9.88 COL 131 COLON-ALIGNED WIDGET-ID 16
     FILL-IN_Libre_c04-2 AT ROW 10.69 COL 169.14 COLON-ALIGNED WIDGET-ID 168
     FILL-IN_Libre_c04 AT ROW 10.77 COL 131 COLON-ALIGNED WIDGET-ID 18
     RADIO-SET_libre_d02 AT ROW 11.69 COL 136.14 NO-LABEL WIDGET-ID 24
     RADIO-SET_libre_d02-2 AT ROW 11.69 COL 174.57 NO-LABEL WIDGET-ID 170
     FILL-IN_tarjeta-circulacion AT ROW 12.5 COL 132.72 COLON-ALIGNED WIDGET-ID 180
     FILL-IN_tarjeta-circulacion-2 AT ROW 12.5 COL 168.72 COLON-ALIGNED WIDGET-ID 182
     FILL-IN_CodPro AT ROW 13.65 COL 130 COLON-ALIGNED HELP
          "C¢digo del Proveedor" WIDGET-ID 12
     FILL-IN_Ruc AT ROW 13.65 COL 154 COLON-ALIGNED HELP
          "Ruc del Proveedor" WIDGET-ID 66
     FILL-IN_NomPro AT ROW 14.5 COL 123.57 COLON-ALIGNED HELP
          "Nombre del Proveedor" WIDGET-ID 64
     RADIO-SET_libre_d01a AT ROW 15.38 COL 136.14 NO-LABEL WIDGET-ID 68
     FILL-IN-brevete AT ROW 16.88 COL 129 COLON-ALIGNED WIDGET-ID 146
     FILL-IN-DNI AT ROW 16.88 COL 153.29 COLON-ALIGNED WIDGET-ID 148
     FILL-IN-nombre AT ROW 17.73 COL 129 COLON-ALIGNED WIDGET-ID 150
     FILL-IN-apellido AT ROW 18.58 COL 129 COLON-ALIGNED WIDGET-ID 152
     FILL-IN-brevetevcto AT ROW 19.42 COL 129 COLON-ALIGNED WIDGET-ID 154
     FILL-IN-entrega AT ROW 19.42 COL 166 COLON-ALIGNED WIDGET-ID 156
     COMBO-BOX-ventas AT ROW 20.96 COL 127 COLON-ALIGNED WIDGET-ID 2
     COMBO-BOX-otros AT ROW 21.12 COL 161 COLON-ALIGNED WIDGET-ID 6
     BUTTON-2 AT ROW 22.58 COL 124 WIDGET-ID 140
     FILL-IN-peso AT ROW 23.88 COL 168 COLON-ALIGNED WIDGET-ID 142
     FILL-IN-1 AT ROW 1.19 COL 118 COLON-ALIGNED NO-LABEL WIDGET-ID 186
     FILL-IN-2 AT ROW 1.81 COL 118 COLON-ALIGNED NO-LABEL WIDGET-ID 188
     " [ filtros ]" VIEW-AS TEXT
          SIZE 13 BY .54 AT ROW 2.5 COL 140 WIDGET-ID 204
          BGCOLOR 15 FGCOLOR 12 
     "¿Es categoria M1 o L?" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 11.85 COL 154.43 WIDGET-ID 174
          FGCOLOR 9 FONT 6
     "¿Es categoria M1 o L?" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 11.88 COL 116.57 WIDGET-ID 62
          FGCOLOR 9 FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 187.43 BY 24
         BGCOLOR 8 FONT 3 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "Modalidad traslado" VIEW-AS TEXT
          SIZE 18.72 BY .81 AT ROW 15.35 COL 117.29 WIDGET-ID 132
     "(privado = propio, publico = tercero)" VIEW-AS TEXT
          SIZE 29.86 BY .62 AT ROW 16.19 COL 137 WIDGET-ID 134
          FGCOLOR 9 FONT 4
     RECT-12 AT ROW 6 COL 151.43 WIDGET-ID 178
     RECT-11 AT ROW 5.92 COL 115.43 WIDGET-ID 176
     RECT-10 AT ROW 13.54 COL 115.57 WIDGET-ID 184
     RECT-13 AT ROW 6 COL 115.43 WIDGET-ID 190
     RECT-14 AT ROW 2.77 COL 115.43 WIDGET-ID 202
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 187.43 BY 24
         BGCOLOR 8 FONT 3 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: gre_header_disponibles T "?" NO-UNDO INTEGRAL gre_header
      TABLE: gre_header_seleccionados T "?" NO-UNDO INTEGRAL gre_header
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Preparar movilidad para el reparto"
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
/* BROWSE-TAB BROWSE-2 RECT-14 F-Main */
ASSIGN 
       BROWSE-2:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME F-Main
   NO-ENABLE                                                            */
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
/* SETTINGS FOR FILL-IN FILL-IN-orden IN FRAME F-Main
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-peso IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-phr IN FRAME F-Main
   ALIGN-R                                                              */
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
     _OrdList          = "Temp-Tables.gre_header_disponibles.fechahora_asigna_vehiculo|no"
     _Where[1]         = "(gre_header_disponibles.m_cco = """") and
((cNroPHR = """" or gre_header_disponibles.nombrePuertoAeropuerto = cNroPHR) and
(cTipoOrden = '<Todos>' or gre_header_disponibles.correoRemitente = cTipoOrden) and
(cNroOrden = """" or gre_header_disponibles.correoDestinatario = cNroOrden)
)"
     _FldNameList[1]   > Temp-Tables.gre_header_disponibles.m_libre_c05
"gre_header_disponibles.m_libre_c05" "Placa!Vehiculo" "x(15)" "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.gre_header_disponibles.fechahora_asigna_vehiculo
"gre_header_disponibles.fechahora_asigna_vehiculo" "Fecha/Hora!Asigna vehiculo" ? "datetime" ? ? ? ? ? ? no ? no no "19.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.gre_header_disponibles.m_estado_bizlinks
"gre_header_disponibles.m_estado_bizlinks" "Estado!Bizlinks" ? "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.gre_header_disponibles.ncorrelatio
"gre_header_disponibles.ncorrelatio" "Nro ! PGRE" ">>>>>>>>9" "int64" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.gre_header_disponibles.m_fechahorareg
"gre_header_disponibles.m_fechahorareg" "Fecha/Hora!Emision PGRE" ? "datetime" ? ? ? ? ? ? no ? no no "19.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.gre_header_disponibles.correoRemitente
"gre_header_disponibles.correoRemitente" "Cod!Orden" "x(6)" "character" 15 9 ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.gre_header_disponibles.correoDestinatario
"gre_header_disponibles.correoDestinatario" "Nro.!Orden" "x(15)" "character" 15 9 ? ? ? ? no ? no no "10.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.gre_header_disponibles.nombrePuertoAeropuerto
"gre_header_disponibles.nombrePuertoAeropuerto" "PHR" "x(10)" "character" 15 9 ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.gre_header_disponibles.m_coddoc
"gre_header_disponibles.m_coddoc" "Tipo!Docto" ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.gre_header_disponibles.m_nroser
"gre_header_disponibles.m_nroser" "Serie" "999" "integer" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.gre_header_disponibles.m_nrodoc
"gre_header_disponibles.m_nrodoc" "Numero" "99999999" "integer" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.gre_header_disponibles.motivoTraslado
"gre_header_disponibles.motivoTraslado" "Cod.!Mtvo" ? "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.gre_header_disponibles.descripcionMotivoTraslado
"gre_header_disponibles.descripcionMotivoTraslado" "Descripcion motivo!traslado" "x(50)" "character" ? ? ? ? ? ? no ? no no "22.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.gre_header_disponibles.razonSocialDestinatario
"gre_header_disponibles.razonSocialDestinatario" "Destinatario" "x(80)" "character" ? ? ? ? ? ? no ? no no "33.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.gre_header_disponibles.direccionPtoLlegada
"gre_header_disponibles.direccionPtoLlegada" "Punto de llegada" "x(100)" "character" ? ? ? ? ? ? no ? no no "34.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.gre_header_disponibles.m_motivo_de_rechazo
"gre_header_disponibles.m_motivo_de_rechazo" "Motivo de envio" "x(200)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Preparar movilidad para el reparto */
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
ON MOUSE-SELECT-DBLCLICK OF BROWSE-2 IN FRAME F-Main /* PRE-GUIAS DE REMISION DISPONIBLES PARA ENVIAR A SUNAT */
DO:
    DEFINE VARIABLE iRowHeight   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iLastY       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iRow         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE hCell        AS HANDLE      NO-UNDO.
    DEFINE VARIABLE iTopRowY     AS INTEGER     NO-UNDO.
    DEFINE VAR cMsg AS CHAR.
    
    DEFINE VARIABLE dRow         AS DEC     NO-UNDO.
    DEFINE VAR addRow AS INT.
    DEFINE VAR cMsgError AS CHAR.
    
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
        cMsgError = "".            
        RUN retirar-PGRE-de-vehiculo(OUTPUT cMsgError).
        IF RETURN-VALUE = "ADM-ERROR" THEN DO:
            MESSAGE "Hubo problemas" SKIP
                cMsgError
                VIEW-AS ALERT-BOX INFORMATION.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 W-Win
ON START-SEARCH OF BROWSE-2 IN FRAME F-Main /* PRE-GUIAS DE REMISION DISPONIBLES PARA ENVIAR A SUNAT */
DO:
    DEFINE VAR x-sql AS CHAR.

   /*
   x-SQL = "FOR EACH gre_cmpte WHERE gre_cmpte.estado = 'CMPTE GENERADO' and " +
            "gre_cmpte.coddivdesp = '" + s-coddiv + "' NO-LOCK, " + 
            "FIRST INTEGRAL.CcbCDocu WHERE ccbcdocu.codcia = " + string(s-codcia) + " and " +
            "ccbcdocu.coddoc = gre_cmpte.coddoc AND ccbcdocu.nrodoc = gre_cmpte.nrodoc NO-LOCK "
    */
    x-sql = "FOR EACH gre_header_disponibles WHERE (gre_header_disponibles.m_cco = '') and " + 
          "(('" + cNroPHR + "' = '' or gre_header_disponibles.nombrePuertoAeropuerto = '" + cNroPHR + "') and " + 
          "('" + cTipoOrden + "' = '<Todos>' or gre_header_disponibles.correoRemitente = '" + cTipoOrden + "') and " + 
          "('" + cNroOrden + "' = '' or gre_header_disponibles.correoDestinatario = '" + cNroOrden + "')) NO-LOCK ".

    {gn/sort-browse.i &ThisBrowse="browse-2" &ThisSQL = x-SQL}  
END.
/*
FOR EACH gre_header_disponibles
      WHERE (gre_header_disponibles.m_cco = "") and
((cNroPHR = "" or gre_header_disponibles.nombrePuertoAeropuerto = cNroPHR) and
(cTipoOrden = '<Todos>' or gre_header_disponibles.correoRemitente = cTipoOrden) and
(cNroOrden = "" or gre_header_disponibles.correoDestinatario = cNroOrden)
) NO-LOCK
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 W-Win
ON VALUE-CHANGED OF BROWSE-2 IN FRAME F-Main /* PRE-GUIAS DE REMISION DISPONIBLES PARA ENVIAR A SUNAT */
DO:
  RUN muestra-datos-transporte.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Refrescar data */
DO:
  RUN extrae-data-from-db.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Enviar a SUNAT */
DO:

    /* ******************************************** */
    /* 23/11/2023 */
    /* ******************************************** */
    IF s-acceso-total = NO THEN DO:
        RUN gre/d-error-gre-noactiva.w.
        RETURN NO-APPLY.
    END.
    /* ******************************************** */
    /* ******************************************** */

    IF browse-2:NUM-SELECTED-ROWS > 0 THEN DO:
        ASSIGN combo-box-ventas combo-box-otros.

           MESSAGE '¿Seguro de enviar ' + STRING(browse-2:NUM-SELECTED-ROWS) + ' PGRE(s) a Sunat?' VIEW-AS ALERT-BOX QUESTION
                   BUTTONS YES-NO UPDATE rpta AS LOG.
           IF rpta = NO THEN RETURN NO-APPLY.

         RUN grabar-envio-a-sunat.

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-filtrar W-Win
ON CHOOSE OF BUTTON-filtrar IN FRAME F-Main /* Filtrar */
DO:
  ASSIGN fill-in-phr fill-in-orden combo-box-tipoorden.

  cNroPHR = "".
  cNroOrden = "".
  cTipoOrden = combo-box-tipoorden.

  IF fill-in-phr > 0 THEN cNroPHR = STRING(fill-in-phr,"999999999").
  IF fill-in-orden > 0 THEN cNroOrden = STRING(fill-in-orden,"999999999").

  {&open-query-browse-2}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-reset-filtros
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-reset-filtros W-Win
ON CHOOSE OF BUTTON-reset-filtros IN FRAME F-Main /* Limpiar filtros */
DO:

    DO WITH FRAME {&FRAME-NAME}:
        fill-in-phr:SCREEN-VALUE = "0".
        combo-box-tipoorden:SCREEN-VALUE = '<Todos>'.
        fill-in-phr:SCREEN-VALUE = "0".
    END.

    ASSIGN fill-in-phr fill-in-orden combo-box-tipoorden.

    cNroPHR = "".
    cNroOrden = "".
    combo-box-tipoorden = combo-box-tipoorden.

    {&open-query-browse-2}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-tipoorden
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-tipoorden W-Win
ON ENTRY OF COMBO-BOX-tipoorden IN FRAME F-Main /* Tipo Orden */
DO:
  cFilertexto = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-tipoorden W-Win
ON VALUE-CHANGED OF COMBO-BOX-tipoorden IN FRAME F-Main /* Tipo Orden */
DO:
    IF cFilertexto <> SELF:SCREEN-VALUE THEN DO:
        APPLY 'CHOOSE':U TO button-filtrar IN FRAME {&FRAME-NAME}.
        cFilertexto = SELF:SCREEN-VALUE.
    END.
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


&Scoped-define SELF-NAME FILL-IN-orden
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-orden W-Win
ON ENTRY OF FILL-IN-orden IN FRAME F-Main /* No. Orden */
DO:
  cFilertexto = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-orden W-Win
ON LEAVE OF FILL-IN-orden IN FRAME F-Main /* No. Orden */
DO:
    IF cFilertexto <> SELF:SCREEN-VALUE THEN DO:
        APPLY 'CHOOSE':U TO button-filtrar IN FRAME {&FRAME-NAME}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-phr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-phr W-Win
ON ENTRY OF FILL-IN-phr IN FRAME F-Main /* Nro de PHR */
DO:
  cFilertexto = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-phr W-Win
ON LEAVE OF FILL-IN-phr IN FRAME F-Main /* Nro de PHR */
DO:

    IF cFilertexto <> SELF:SCREEN-VALUE THEN DO:
        APPLY 'CHOOSE':U TO button-filtrar IN FRAME {&FRAME-NAME}.
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
  DISPLAY FILL-IN-phr COMBO-BOX-tipoorden FILL-IN-orden FILL-IN-datos 
          FILL-IN-placa-2 FILL-IN-placa FILL-IN_Marca-2 FILL-IN_Marca 
          FILL-IN_Carga-2 FILL-IN_Carga FILL-IN_Libre_d01-2 FILL-IN_Libre_d01 
          FILL-IN_Libre_c02-2 FILL-IN_Libre_c02 FILL-IN_Libre_c04-2 
          FILL-IN_Libre_c04 RADIO-SET_libre_d02 RADIO-SET_libre_d02-2 
          FILL-IN_tarjeta-circulacion FILL-IN_tarjeta-circulacion-2 
          FILL-IN_CodPro FILL-IN_Ruc FILL-IN_NomPro RADIO-SET_libre_d01a 
          FILL-IN-brevete FILL-IN-DNI FILL-IN-nombre FILL-IN-apellido 
          FILL-IN-brevetevcto FILL-IN-entrega COMBO-BOX-ventas COMBO-BOX-otros 
          FILL-IN-peso FILL-IN-1 FILL-IN-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-12 RECT-11 RECT-10 RECT-13 RECT-14 BROWSE-2 BUTTON-1 FILL-IN-phr 
         COMBO-BOX-tipoorden FILL-IN-orden BUTTON-filtrar BUTTON-reset-filtros 
         COMBO-BOX-ventas COMBO-BOX-otros BUTTON-2 
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

DEFINE VAR cCodRef AS CHAR.
DEFINE VAR cNroRef AS CHAR.
DEFINE VAR cNroPHR AS CHAR.
DEFINE VAR cCmpte AS CHAR.
DEFINE VAR iRegis AS INT INIT 0.

SESSION:SET-WAIT-STATE("GENERAL").
FOR EACH gre_header WHERE gre_header.m_rspta_sunat = 'CON TRANSPORTISTA' AND
                     gre_header.m_divorigen = s-coddiv NO-LOCK:
    CREATE gre_header_disponibles.
    BUFFER-COPY gre_header TO gre_header_disponibles.

    CREATE gre_header_seleccionados.
    BUFFER-COPY gre_header TO gre_header_seleccionados.

    iRegis = iRegis + 1.

    cNroPHR = "".
    cCodRef = gre_header.m_coddoc.
    cNroRef = STRING(gre_header.m_serie,"999") + STRING(gre_header.m_nrodoc,"999999").
    cCmpte = "".

    /* Buscar la PHR */
    IF gre_header.m_coddoc <> 'OTR' THEN DO:
        /* Buscar la O/D */
        cCmpte = STRING(gre_header.m_nroser,"999") + STRING(gre_header.m_nrodoc,"99999999").
        IF gre_header.m_coddoc = 'FAI' THEN cCmpte = STRING(gre_header.m_nroser,"999") + STRING(gre_header.m_nrodoc,"999999").
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
                                LOOKUP(di-rutaD.flgest,"A,C") = 0 /*di-rutaD.flgest <> 'A'*/ NO-LOCK NO-ERROR.
    IF AVAILABLE di-rutaD THEN DO:
        cNroPHR = di-rutaD.nrodoc.
    END.
    
    /* Campos de ayuda nada mas */
    ASSIGN gre_header_disponibles.nombrePuertoAeropuerto = cNroPHR.
    ASSIGN gre_header_seleccionados.nombrePuertoAeropuerto = cNroPHR.

    ASSIGN gre_header_disponibles.correoRemitente = cCodRef         /* O/D */
            gre_header_disponibles.correoDestinatario = cNroRef.    /* Nro O/D */
    IF gre_header.m_coddoc = 'OTR' THEN DO:
        ASSIGN gre_header_disponibles.correoremitente = gre_header.m_coddoc     /* OTR */
                gre_header_disponibles.correoDestinatario = STRING(gre_header.m_nroser,"999") + STRING(gre_header.m_nrodoc,"999999").   /* Nro OTR */
    END.


    /* Placa del Vehiculo */
    ASSIGN gre_header_disponibles.m_libre_c05 = "".
    ASSIGN gre_header_seleccionados.m_libre_c05 = "".
    ASSIGN gre_header_seleccionados.m_fechahorareg = ?.

    FIND FIRST gre_vehiculo_hdr WHERE gre_vehiculo_hdr.ncorrelativo = gre_header.correlativo_vehiculo NO-LOCK NO-ERROR.
    IF AVAILABLE gre_vehiculo_hdr THEN DO:
        ASSIGN gre_header_disponibles.m_libre_c05 = gre_vehiculo_hdr.placa
                gre_header_disponibles.m_fechahorareg = gre_vehiculo_hdr.fhregistro.
        ASSIGN gre_header_seleccionados.m_libre_c05 = gre_vehiculo_hdr.placa
                gre_header_seleccionados.m_fechahorareg = gre_vehiculo_hdr.fhregistro.
    END.
    
END.
SESSION:SET-WAIT-STATE("").

{&open-query-browse-2}
{&open-query-browse-9}

APPLY 'CHOOSE':U TO button-filtrar IN FRAME {&FRAME-NAME}.
IF iRegis > 0 THEN DO:
    APPLY 'VALUE-CHANGED':U TO browse-2 IN FRAME {&FRAME-NAME}.
END.

/*dPesoTotal = 0.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-data W-Win 
PROCEDURE grabar-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*  Motivo de traslado de ventas
    01 : Venta
    03 : Venta con entrega a terceros
    14 : Venta sujeta a confirmacion
*/
DEFINE VAR rRowId AS ROWID.
DEFINE VAR iCorrelativo AS INT.
DEFINE VAR iRowsSelected AS INT.
DEFINE VAR iRow AS INT.

DEFINE VAR iSerie AS INT.
DEFINE VAR iNumero AS INT.
DEFINE VAR cReturn AS CHAR.
DEFINE VAR cStatusBizlinks AS CHAR.
DEFINE VAR cOtros AS CHAR.
DEFINE VAR iProcesados AS INT.

DEFINE VAR x-errores AS CHAR.
DEFINE VAR x-errores-cod AS CHAR.
DEFINE VAR cRsptaWS AS CHAR.

DO WITH FRAME {&FRAME-NAME}:
    iRowsSelected = browse-2:NUM-SELECTED-ROWS.

    IF iRowsSelected > 0 THEN DO:
        SESSION:SET-WAIT-STA("GENERAL").
        DO iRow = 1 TO iRowsSelected :
            IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(iRow) THEN DO:

                iCorrelativo = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nCorrelatio.
                FIND FIRST b-gre_header WHERE b-gre_header.ncorrelatio = gre_header_disponibles.ncorrelatio NO-LOCK NO-ERROR.
                IF NOT AVAILABLE b-gre_header THEN DO:
                    IF INDEX(x-errores-cod,"1") = 0 THEN x-errores-cod = x-errores-cod + "1".                    
                    NEXT.
                END.
                IF NOT b-gre_header.m_rspta_sunat = "CON TRANSPORTISTA" THEN DO:
                    /* Ya no esta lista para envio a Sunat */
                    IF INDEX(x-errores-cod,"2") = 0 THEN x-errores-cod = x-errores-cod + "2".
                    NEXT.
                END.
                IF b-gre_header.fechaInicioTraslado < TODAY THEN DO:
                    /* La fecha de inicio de traslado de la GRE es invalida */
                    IF INDEX(x-errores-cod,"8") = 0 THEN x-errores-cod = x-errores-cod + "8".
                    NEXT.
                END.
                /*
                IF b-gre_header.serieGuia <> 0 OR b-gre_header.numeroGuia <> 0 THEN DO:
                    /* Ya tiene correlativo */
                    IF INDEX(x-errores-cod,"3") = 0 THEN x-errores-cod = x-errores-cod + "3".
                    NEXT.
                END.
                */
                iSerie = INTEGER(combo-box-ventas).
                iNumero = 0.
                IF LOOKUP(b-gre_header.motivoTraslado,"01,03,14") = 0 THEN DO:
                    /* NO es VENTAS */
                    iSerie = INTEGER(combo-box-otros).
                END.
                IF b-gre_header.numeroGuia <= 0 THEN DO:
                    /* Correlativo de guia de remision electronica */                
                    FIND CURRENT b-gre_header EXCLUSIVE-LOCK NO-ERROR.
                    IF LOCKED b-gre_header THEN DO:
                        /* tabla esta bloqueado */
                        IF INDEX(x-errores-cod,"4") = 0 THEN x-errores-cod = x-errores-cod + "4".
                        NEXT.
                    END.
                    FIND FIRST b-facCorre WHERE b-facCorre.codcia = s-codcia AND
                                                    b-facCorre.coddiv = s-coddiv AND
                                                    b-facCorre.coddoc = cCoddoc AND
                                                    b-facCorre.nroser = iSerie EXCLUSIVE-LOCK NO-ERROR.
                    IF LOCKED b-faccorre THEN DO:
                        /* Tabla bloqueada */
                        RELEASE b-gre_header.
                        IF INDEX(x-errores-cod,"5") = 0 THEN x-errores-cod = x-errores-cod + "5".
                        NEXT.
                    END.
                    IF NOT AVAILABLE b-faccorre THEN DO:
                        /* No existe */
                        RELEASE b-gre_header.
                        RELEASE b-facCorre.
                        IF INDEX(x-errores-cod,"6") = 0 THEN x-errores-cod = x-errores-cod + "6".
                        NEXT.
                    END.

                    iNumero = b-facCorre.correlativo.

                    ASSIGN b-facCorre.correlativo = b-facCorre.correlativo + 1.

                    /* Libero Correlativos */
                    RELEASE b-facCorre NO-ERROR.

                    /* Libero GRE */
                    ASSIGN b-gre_header.serieGuia = iSerie
                            b-gre_header.numeroGuia = iNumero.
                END.
                ELSE DO:
                    iSerie = b-gre_header.serieGuia.
                    iNumero = b-gre_header.numeroGuia.
                END.

                FIND CURRENT b-gre_header NO-LOCK NO-ERROR.

                /* Envio a Sunat */
                cReturn = "".
                cOtros = "".
                cStatusBizlinks = "".
                IF LOOKUP(USERID("DICTDB"),"ADMIN,MASTER") = 0 THEN DO:
                    /* Solo genera file XML */
                    /*cOtros = "XML".*/
                END.
                /*
                MESSAGE "iSerie "  iSerie SKIP
                        "iNumero " iNumero SKIP
                        "s-coddiv " s-coddiv SKIP
                        "otros " cOtros.
                */
                FIND CURRENT b-gre_header EXCLUSIVE-LOCK NO-ERROR.
                IF NOT LOCKED b-gre_header THEN DO:
                    ASSIGN b-gre_header.fechaEmisionGuia = TODAY                    
                            b-gre_header.horaEmisionGuia = STRING(TIME,"hh:mm:ss").

                    FIND CURRENT b-gre_header NO-LOCK NO-ERROR.
                
                    RUN sunat/progress-to-bz-gre(iSerie, iNumero, s-coddiv, OUTPUT cReturn, INPUT-OUTPUT cOtros, INPUT-OUTPUT cStatusBizlinks).

                    cRsptaWS = caps(ENTRY(1,cStatusBizlinks,"|")).

                    /*IF ENTRY(1,cReturn,"|") = "OK" OR ENTRY(1,cReturn,"|") = "RECHAZADO POR SUNAT" THEN DO:*/
                    IF LOOKUP(cRsptaWS,"SIGNED,IN PROCESS,INVALID,DUPLICATED,ERROR") > 0 THEN DO:
                        /* ENVIADO A SUNAT */
                        FIND CURRENT b-gre_header EXCLUSIVE-LOCK NO-ERROR.
                        IF NOT LOCKED b-gre_header THEN DO:
                            ASSIGN b-gre_header.m_rspta_sunat = IF (LOOKUP(cRsptaWS,"SIGNED,IN PROCESS") > 0) THEN "ENVIADO A SUNAT" ELSE "RECHAZADO POR SUNAT"
                                    b-gre_header.fechahora_envio_a_sunat = NOW
                                    b-gre_header.USER_envio_a_sunat = USERID("DICTDB")
                                    b-gre_header.m_estado_bizlinks = cStatusBizlinks.

                            IF LOOKUP(cRsptaWS,"SIGNED,IN PROCESS") = 0 THEN DO:
                                ASSIGN b-gre_header.m_motivo_de_rechazo = IF (NUM-ENTRIES(cReturn,"|") > 2) THEN ENTRY(3,cReturn,"|") ELSE cReturn.
                            END.                                    
    
                            iProcesados = iProcesados + 1.
    
                            ASSIGN {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.m_cco = "LOQUESEA".   /* solo para q no lo muestre en pantalla */
                        END.
    
                        FIND CURRENT b-gre_header NO-LOCK NO-ERROR.                        
                    END.
                    ELSE DO:
                        FIND CURRENT b-gre_header EXCLUSIVE-LOCK NO-ERROR.
                        IF NOT LOCKED b-gre_header THEN DO:
                            ASSIGN b-gre_header.m_estado_bizlinks = cRsptaWS    /*cStatusBizlinks*/.
                                    b-gre_header.m_motivo_de_rechazo = IF (NUM-ENTRIES(cReturn,"|") > 2) THEN ENTRY(3,cReturn,"|") ELSE cReturn.
                        END.
                        FIND CURRENT b-gre_header NO-LOCK NO-ERROR.

                        ASSIGN {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.m_estado_bizlinks = cRsptaWS  /*cStatusBizlinks*/
                                {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.m_motivo_de_rechazo = IF (NUM-ENTRIES(cReturn,"|") > 2) THEN ENTRY(3,cReturn,"|") ELSE cReturn.

                    END.
                END.
                ELSE DO:
                    /*
                    FIND CURRENT b-gre_header EXCLUSIVE-LOCK NO-ERROR.
                    IF NOT LOCKED b-gre_header THEN DO:
                        ASSIGN b-gre_header.m_estado_bizlinks = cStatusBizlinks.
                                b-gre_header.m_motivo_de_rechazo = IF (NUM-ENTRIES(cReturn,"|") > 2) THEN ENTRY(3,cReturn,"|") ELSE cReturn.
                    END.
                    FIND CURRENT b-gre_header NO-LOCK NO-ERROR.

                    ASSIGN {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.m_estado_bizlinks = cStatusBizlinks
                            {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.m_motivo_de_rechazo = IF (NUM-ENTRIES(cReturn,"|") > 2) THEN ENTRY(3,cReturn,"|") ELSE cReturn.
                    
                    IF INDEX(x-errores-cod,"7") = 0 THEN x-errores-cod = x-errores-cod + "7".
                    */
                END.
            END.
        END.
        {&open-query-browse-2}

        SESSION:SET-WAIT-STA("").

        IF iProcesados = 0 THEN DO:
            MESSAGE "Hubo problemas al enviar a la sunat" SKIP
                    "a continuacion se mostraran cuales fueron los errores" 
                    VIEW-AS ALERT-BOX INFORMATION.
        END.
        ELSE DO:
            MESSAGE "Se enviaron a SUNAT, " + STRING(iProcesados) + " comprobante(s) de " + STRING(iRowsSelected) + " seleccionados" SKIP
                    "si hubieron inconsistencias, a continuacion se mostraran" 
                    VIEW-AS ALERT-BOX INFORMATION.
        END.

        x-errores = "".
        IF INDEX(x-errores-cod,"1") > 0 THEN x-errores = x-errores + "Se detecto que PRE-GUIAS no existen" + gcCRLF.
        IF INDEX(x-errores-cod,"2") > 0 THEN x-errores = x-errores + "Existen PRE-GUIAS que no tiene TRASNSPORTISTA" + gcCRLF.
        IF INDEX(x-errores-cod,"3") > 0 THEN x-errores = x-errores + "Exsiten PRE-GUIAS convertidas a GUIAS DE REMISION" + gcCRLF.
        IF INDEX(x-errores-cod,"4") > 0 THEN x-errores = x-errores + "La tabla de PRE-GUIAS esta bloqueada" + gcCRLF.
        IF INDEX(x-errores-cod,"5") > 0 THEN x-errores = x-errores + "La tabla de correlativos esta bloqueada" + gcCRLF.
        IF INDEX(x-errores-cod,"6") > 0 THEN x-errores = x-errores + "La serie de guia no esta configurada" + gcCRLF.
        IF INDEX(x-errores-cod,"7") > 0 THEN x-errores = x-errores + "Hubo problemas al enviar a Sunat ó han sido RECHAZADOS" + gcCRLF.
        IF INDEX(x-errores-cod,"8") > 0 THEN x-errores = x-errores + "Hubieron GRE cuya fecha de inicio de traslado es menor a hoy dia" + gcCRLF.

        IF x-errores <> "" THEN DO:
            MESSAGE x-errores
                VIEW-AS ALERT-BOX INFORMATION.
        END.

    END.
END.

{&open-query-browse-2}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-envio-a-sunat W-Win 
PROCEDURE grabar-envio-a-sunat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fill-in-placa fill-in_marca fill-in_carga FILL-IN_libre_d01 FILL-IN_libre_c02 
        FILL-IN_libre_c04 RADIO-SET_libre_d02.
    ASSIGN FILL-IN_codpro FILL-IN_ruc FILL-IN_nompro RADIO-SET_libre_d01a.         
    ASSIGN fill-in-brevete  fill-in-dni fill-in-nombre fill-in-apellido fill-in-brevetevcto.
    ASSIGN fill-in-peso.
    
    FIND FIRST gn-vehic WHERE gn-vehic.codcia = s-codcia AND gn-vehic.placa = fill-in-placa
                    NO-LOCK NO-ERROR.
    IF fill-in-placa > "" AND AVAILABLE gn-vehic THEN DO:

        IF gn-vehic.libre_c05 <> 'SI' THEN DO:
            MESSAGE "El vehiculo no esta ACTIVO" SKIP
                    "imposible continuar"
                VIEW-AS ALERT-BOX INFORMATION.
            RETURN "ADM-ERROR".
        END.

        FIND FIRST gn-prov WHERE gn-prov.codcia = 0 AND gn-prov.codpro = gn-vehic.codpro
                            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN DO:
            IF TRUE <> (FILL-IN_ruc > "") THEN DO:
                MESSAGE "El trasnportista no tiene RUC" SKIP
                        "imposible continuar"
                    VIEW-AS ALERT-BOX INFORMATION.
                RETURN "ADM-ERROR".
            END.
            IF LENGTH(FILL-IN_ruc) <> 11 THEN DO:
                MESSAGE "El trasnportista tiene RUC INVALIDO" SKIP
                        "imposible continuar"
                    VIEW-AS ALERT-BOX INFORMATION.
                RETURN "ADM-ERROR".
            END.
            IF FILL-IN_libre_c02 > "2TN" THEN DO:
                IF TRUE <> (FILL-IN_libre_c04 > "") THEN DO:
                    MESSAGE "Vehiculo con capacidad de mas de 2TN requiere" SKIP
                            "registro del MTC"
                        VIEW-AS ALERT-BOX INFORMATION.
                    RETURN "ADM-ERROR".
                END.
            END.
            IF RADIO-SET_libre_d01a = 0 THEN DO:
                MESSAGE "El trasnportista debe ser PUBLICO o PRIVADO" SKIP
                        "imposible continuar"
                    VIEW-AS ALERT-BOX INFORMATION.
                RETURN "ADM-ERROR".
            END.
            /* El chofer si el transportista es privado */
            IF RADIO-SET_libre_d01a = 2 THEN DO:
                FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                            vtatabla.llave_c1 = fill-in-brevete NO-LOCK NO-ERROR.
                IF fill-in-brevete = "" OR NOT AVAILABLE vtatabla THEN DO:
                    MESSAGE "Brevete no existe..." SKIP
                            "imposible continuar"
                        VIEW-AS ALERT-BOX INFORMATION.
                    RETURN "ADM-ERROR".
                END.
                IF vtatabla.llave_c8 <> 'SI' THEN DO:
                    MESSAGE "El conductor no esta activo" SKIP
                            "imposible continuar"
                        VIEW-AS ALERT-BOX INFORMATION.
                    RETURN "ADM-ERROR".
                END.
                IF fill-in-brevetevcto <> ? AND fill-in-brevetevcto < TODAY THEN DO:
                    MESSAGE "El brevete esta vencido" SKIP
                            "imposible continuar"
                        VIEW-AS ALERT-BOX INFORMATION.
                    RETURN "ADM-ERROR".
                END.
            END.
            IF INTEGER(combo-box-ventas) <= 0 OR  INTEGER(combo-box-otros) <= 0 THEN DO:
                MESSAGE "Elija los numeros de series correctamente" SKIP
                        "imposible continuar"
                    VIEW-AS ALERT-BOX INFORMATION.
                RETURN "ADM-ERROR".
            END.
            IF INTEGER(combo-box-ventas) = INTEGER(combo-box-otros) THEN DO:
                MESSAGE "Los numeros de series deben ser diferentes" SKIP
                        "imposible continuar"
                    VIEW-AS ALERT-BOX INFORMATION.
                RETURN "ADM-ERROR".
            END.

            /* Se procede a grabar */
            RUN grabar-data.

        END.
        ELSE DO:
            MESSAGE "El vehiculo ingresado no pertenece a ninguna" SKIP
                    "empresa de transporte...por favor verificar"
                VIEW-AS ALERT-BOX INFORMATION.
            RETURN "ADM-ERROR".
        END.
    END.
    ELSE DO:
        MESSAGE "Debe ingresar la placa del vehiculo correctamente"
            VIEW-AS ALERT-BOX INFORMATION.
        RETURN "ADM-ERROR".
    END.
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

  /* Code placed here will execute AFTER standard behavior.    */    
  DEF VAR pSeries AS CHAR NO-UNDO.

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
    FILL-IN-peso:SCREEN-VALUE = ""
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
    fill-in-brevetevcto:SCREEN-VALUE = "".
    fill-in-entrega:SCREEN-VALUE = "".

    ASSIGN fill-in-placa-2:SCREEN-VALUE = ""
    fill-in_marca-2:SCREEN-VALUE = ""
    fill-in_carga-2:SCREEN-VALUE = ""
    FILL-IN_libre_d01-2:SCREEN-VALUE = ""
    FILL-IN_libre_c02-2:SCREEN-VALUE = ""
    FILL-IN_libre_c04-2:SCREEN-VALUE = ""
    RADIO-SET_libre_d02-2:SCREEN-VALUE = ""
    FILL-IN_tarjeta-circulacion-2:SCREEN-VALUE = "".

    FIND FIRST gre_vehiculo_hdr WHERE gre_vehiculo_hdr.ncorrelativo = gre_header_disponibles.correlativo_vehiculo AND 
            gre_vehiculo_hdr.placa = gre_header_disponibles.numeroPlacaVehiculoPrin  NO-LOCK NO-ERROR.
    IF AVAILABLE gre_vehiculo_hdr THEN DO:
        ASSIGN 
        FILL-IN-peso:SCREEN-VALUE = STRING(gre_vehiculo_hdr.pesototal)
        fill-in-placa:SCREEN-VALUE = gre_vehiculo_hdr.placa
        fill-in_marca:SCREEN-VALUE = gre_vehiculo_hdr.marca
        fill-in_carga:SCREEN-VALUE = STRING(gre_vehiculo_hdr.cargamaxima)
        FILL-IN_libre_d01:SCREEN-VALUE = STRING(gre_vehiculo_hdr.capacidadmax)
        FILL-IN_libre_c02:SCREEN-VALUE = gre_vehiculo_hdr.tonelaje
        FILL-IN_libre_c04:SCREEN-VALUE = gre_vehiculo_hdr.registroMTC
        RADIO-SET_libre_d02:SCREEN-VALUE = IF(gre_vehiculo_hdr.catvehM1L = YES ) THEN '1' ELSE '0'
        FILL-IN_codpro:SCREEN-VALUE = gre_vehiculo_hdr.codtransportista
        FILL-IN_tarjeta-circulacion:SCREEN-VALUE = gre_vehiculo_hdr.codtransportista
        FILL-IN_nompro:SCREEN-VALUE = gre_vehiculo_hdr.transp_razonsocial
        FILL-IN_ruc:SCREEN-VALUE = gre_vehiculo_hdr.transp_ruc
        RADIO-SET_libre_d01a:SCREEN-VALUE = STRING(gre_vehiculo_hdr.transp_modalidad)
        fill-in-brevete:SCREEN-VALUE = gre_vehiculo_hdr.brevete
        fill-in-dni:SCREEN-VALUE = gre_vehiculo_hdr.chofer_dni
        fill-in-nombre:SCREEN-VALUE = gre_vehiculo_hdr.chofer_nombre
        fill-in-apellido:SCREEN-VALUE = gre_vehiculo_hdr.chofer_apellidos
        fill-in-brevetevcto:SCREEN-VALUE = string(gre_vehiculo_hdr.chofer_vctobrevete,"99/99/9999")
        fill-in-entrega:SCREEN-VALUE = string(gre_header_disponibles.fechaInicioTraslado,"99/99/9999")
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

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retirar-PGRE-de-vehiculo W-Win 
PROCEDURE retirar-PGRE-de-vehiculo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETE pMsgError AS CHAR.

MESSAGE '¿Seguro de retirar la PGRE ' + STRING(gre_header_disponibles.ncorrelatio) + ' del vehiculo?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN "OK".

DEFINE VAR cMsg AS CHAR.
/*
FIND FIRST gre_header_seleccionados WHERE gre_header_seleccionados.ncorrelatio = gre_header_disponibles.ncorrelatio
              EXCLUSIVE-LOCK NO-ERROR.
IF AVAILABLE gre_header_seleccionados THEN DO:
*/
      FIND FIRST b-gre_header WHERE b-gre_header.ncorrelatio = gre_header_disponibles.ncorrelatio NO-LOCK NO-ERROR.
      IF NOT AVAILABLE b-gre_header THEN DO:
          pMsgError = "La PGRE " + STRING(gre_header_disponibles.ncorrelatio) + " NO EXISTE".
          RETURN "ADM-ERROR".
      END.
      IF b-gre_header.numeroGuia > 0 THEN DO:
          pMsgError = "La PGRE " + STRING(gre_header_disponibles.ncorrelatio) + " ya tiene asignado numero de GRE".
          RETURN "ADM-ERROR".
      END.

    GRABAR:
    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':

          FIND CURRENT b-gre_header EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
          IF LOCKED b-gre_header THEN DO:
              cMsg = ERROR-STATUS:GET-MESSAGE(1).
              RELEASE b-gre_header NO-ERROR.
              pMsgError = "La PGRE " + STRING(gre_header_disponibles.ncorrelatio) + " tabla gre_header bloqueada " + CHR(10) + cMsg.
              UNDO GRABAR, RETURN 'ADM-ERROR'.
          END.

          CREATE gre_header_log.
          BUFFER-COPY b-gre_header TO gre_header_log NO-ERROR.
          IF ERROR-STATUS:ERROR THEN DO:
              pMsgError = "Se intenta guardar en el LOG" + CHR(10) + ERROR-STATUS:GET-MESSAGE(1).
              UNDO GRABAR, RETURN 'ADM-ERROR'.
          END.
          ASSIGN gre_header_log.m_motivo_log = "EXCLUIDO DEL VEHICULO"
                gre_header_log.USER_log = USERID("dictdb").

          ASSIGN b-gre_header.modalidadTraslado = ""
              b-gre_header.numeroRucTransportista = ""
              b-gre_header.tipoDocumentoTransportista = ""
              b-gre_header.RazonSocialTransportista = ""
              b-gre_header.numeroRegistroMTC = ""
              b-gre_header.indTrasVehiculoCatM1L = NO
              b-gre_header.numeroPlacaVehiculoPrin = ""
              b-gre_header.numeroPlacaVehiculoSec1 = ""
              b-gre_header.numeroDocumentoConductor = ""
              b-gre_header.tipoDocumentoConductor = ""
              b-gre_header.nombreConductor = ""
              b-gre_header.apellidoConductor = ""
              b-gre_header.numeroLicencia = ""
              b-gre_header.m_rspta_sunat = 'SIN ENVIAR' 
              b-gre_header.correlativo_vehiculo = 0
              b-gre_header.fechahora_asigna_vehiculo = ?
              b-gre_header.USER_asigna_vehiculo = ""
              b-gre_header.indTransbordoProgramado = 0
              b-gre_header.fechaInicioTraslado = ?
              b-gre_header.fechaEntregaBienes = ? 
              b-gre_header.serieGuia = 0
              b-gre_header.numeroGuia = 0
              b-gre_header.tarjetaUnicaCirculacionPri = ""
              b-gre_header.tarjetaUnicaCirculacionSec1 = ""
              b-gre_header.m_motivo_de_rechazo = ""
              b-gre_header.fechahora_envio_a_sunat = ?
              b-gre_header.USER_envio_a_sunat = ""
              b-gre_header.m_estado_bizlinks = ""
              b-gre_header.m_estado_mov_almacen = "POR PROCESAR"
              b-gre_header.m_msgerr_mov_almacen = ""
              /*b-gre_header.m_fechahorareg = NOW*/
              b-gre_header.m_fechahora_mov_almacen = ?
              b-gre_header.estado_en_hojaruta = "EN PROCESO"
              b-gre_header.user_recupera_cmpte = ""
              b-gre_header.fechahora_recupera_cmpte = ?
              /*
              b-gre_header.fechaEmisionGuia = TODAY
              b-gre_header.horaEmisionGuia = STRING(TIME,"hh:mm:ss") NO-ERROR*/ NO-ERROR.
        
        IF ERROR-STATUS:ERROR THEN DO:
            pMsgError = ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABAR, RETURN 'ADM-ERROR'.
        END.
        RELEASE b-gre_header NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMsgError = ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABAR, RETURN 'ADM-ERROR'.
        END.
        RELEASE gre_header_log.
        IF ERROR-STATUS:ERROR THEN DO:
            pMsgError = ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABAR, RETURN 'ADM-ERROR'.
        END.

    END.

    ASSIGN gre_header_disponibles.m_cco = "NO MOSTRAR".
    ASSIGN gre_header_seleccionados.m_cco = "NO MOSTRAR".

    {&open-query-browse-2}
/*END.*/

RETURN "OK".

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

