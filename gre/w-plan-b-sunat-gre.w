&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE gre_header_disponibles NO-UNDO LIKE gre_header
       field rRowId as rowid
       .
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

DEFINE VAR iSerieVenta AS INT.
DEFINE VAR iSerieResto AS INT.

DEFINE VAR gcCRLF AS CHAR.
ASSIGN gcCRLF = CHR(13) + CHR(10).

 DEFINE TEMP-TABLE tTagsEstadoDoc
    FIELD   cTag    AS  CHAR    FORMAT 'x(100)' 
    FIELD   cValue  AS  CHAR    FORMAT 'x(255)'.


DEFINE VAR iRegSeleccionados AS INT.
DEFINE VAR cOldValue AS CHAR.
DEFINE VAR iMaximoRegSeleccionados AS INT.

/**/
DEFINE VAR cValorDeRetorno AS CHAR.

RUN gre/get-parametro-config-gre("PARAMETRO","MAXIMOREGISTROSSELECCIONADOS","GENERAR_GR_FISICAS","N","10",OUTPUT cValorDeRetorno).
IF cValorDeRetorno = "ERROR" THEN DO:
    MESSAGE "Hubo error al grabar/recuperar parametro MAXIMOREGISTROSSELECCIONADOS/GENERAR_GR_FISICAS" VIEW-AS ALERT-BOX INFORMATION.
    RETURN ERROR.
END.

iMaximoRegSeleccionados = INTEGER(TRIM(cValorDeRetorno)).

DEFINE BUFFER x-gre_header_disponibles FOR gre_header_disponibles.

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
gre_header_disponibles.indTrasladoTotalDAMoDS ~
gre_header_disponibles.serieGuia gre_header_disponibles.numeroGuia ~
gre_header_disponibles.fechahora_envio_a_sunat ~
gre_header_disponibles.m_estado_bizlinks ~
gre_header_disponibles.m_rspta_sunat ~
gre_header_disponibles.fechaEmisionGuia ~
gre_header_disponibles.horaEmisionGuia gre_header_disponibles.m_libre_c05 ~
gre_header_disponibles.m_fechahorareg gre_header_disponibles.ncorrelatio ~
gre_header_disponibles.nombrePuertoAeropuerto ~
gre_header_disponibles.m_coddoc gre_header_disponibles.m_nroser ~
gre_header_disponibles.m_nrodoc gre_header_disponibles.motivoTraslado ~
gre_header_disponibles.descripcionMotivoTraslado ~
gre_header_disponibles.razonSocialDestinatario ~
gre_header_disponibles.direccionPtoLlegada 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 ~
gre_header_disponibles.indTrasladoTotalDAMoDS 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-2 gre_header_disponibles
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-2 gre_header_disponibles
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH gre_header_disponibles ~
      WHERE gre_header_disponibles.m_rspta_sunat = 'ENVIADO A SUNAT' or  ~
gre_header_disponibles.m_rspta_sunat = 'ESPERANDO RESPUESTA SUNAT' NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH gre_header_disponibles ~
      WHERE gre_header_disponibles.m_rspta_sunat = 'ENVIADO A SUNAT' or  ~
gre_header_disponibles.m_rspta_sunat = 'ESPERANDO RESPUESTA SUNAT' NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 gre_header_disponibles
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 gre_header_disponibles


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-13 RECT-12 BROWSE-2 BUTTON-1 ~
COMBO-BOX-ventas COMBO-BOX-no-ventas BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-datos FILL-IN-placa-2 ~
FILL-IN-placa FILL-IN_Marca-2 FILL-IN_Marca FILL-IN_Carga-2 FILL-IN_Carga ~
FILL-IN_Libre_d01-2 FILL-IN_Libre_d01 FILL-IN_Libre_c02-2 FILL-IN_Libre_c02 ~
FILL-IN_Libre_c04-2 FILL-IN_Libre_c04 RADIO-SET_libre_d02-2 ~
RADIO-SET_libre_d02 FILL-IN_tarjeta-circulacion-2 ~
FILL-IN_tarjeta-circulacion FILL-IN_CodPro FILL-IN_Ruc FILL-IN_NomPro ~
RADIO-SET_libre_d01a FILL-IN-entrega FILL-IN-brevete FILL-IN-DNI ~
FILL-IN-nombre FILL-IN-apellido FILL-IN-brevetevcto COMBO-BOX-ventas ~
COMBO-BOX-no-ventas FILL-IN-peso FILL-IN-msg 

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
     LABEL "Generar Guia de Remision Fisicas (GRF)" 
     SIZE 45 BY 1.12
     FGCOLOR 2 FONT 6.

DEFINE VARIABLE COMBO-BOX-no-ventas AS CHARACTER FORMAT "X(5)":U INITIAL "0" 
     LABEL "Serie transferencias" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 16 BY 1
     FONT 11 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-ventas AS CHARACTER FORMAT "X(5)":U INITIAL "0" 
     LABEL "Serie ventas" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 16 BY 1
     FONT 11 NO-UNDO.

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
     LABEL "Inicio del traslado de bienes" 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-msg AS CHARACTER FORMAT "X(100)":U 
      VIEW-AS TEXT 
     SIZE 80 BY .62
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-nombre AS CHARACTER FORMAT "X(60)":U 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 43.43 BY .88
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-peso AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Carga total de guias(Kgrs)" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88
     BGCOLOR 15 FGCOLOR 4 FONT 9 NO-UNDO.

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
     SIZE 31 BY .88
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
     SIZE 72.72 BY 8.62
     BGCOLOR 10 .

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37.43 BY 7.54.

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
      gre_header_disponibles.indTrasladoTotalDAMoDS COLUMN-LABEL "Sele" FORMAT "yes/no":U
            WIDTH 4.43 VIEW-AS TOGGLE-BOX
      gre_header_disponibles.serieGuia COLUMN-LABEL "Serie!Guia" FORMAT "999":U
            WIDTH 5.43 COLUMN-BGCOLOR 14 COLUMN-FONT 6
      gre_header_disponibles.numeroGuia COLUMN-LABEL "Numero!Guia" FORMAT "99999999":U
            WIDTH 11.43 COLUMN-BGCOLOR 14 COLUMN-FONT 6
      gre_header_disponibles.fechahora_envio_a_sunat FORMAT "99/99/9999 HH:MM:SS.SSS":U
      gre_header_disponibles.m_estado_bizlinks COLUMN-LABEL "Estado!Bizlinks" FORMAT "x(25)":U
            WIDTH 16.72
      gre_header_disponibles.m_rspta_sunat COLUMN-LABEL "Respuesta!de Sunat" FORMAT "x(25)":U
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
  ENABLE
      gre_header_disponibles.indTrasladoTotalDAMoDS
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 113 BY 23.58
         BGCOLOR 15 FONT 3
         TITLE BGCOLOR 15 "GENERAR GUIAS REMISION FISICAS - NO RESONDIDAS X SUNAT" ROW-HEIGHT-CHARS .46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-2 AT ROW 1.12 COL 2 WIDGET-ID 200
     BUTTON-1 AT ROW 1.27 COL 118 WIDGET-ID 4
     FILL-IN-datos AT ROW 2.54 COL 115 COLON-ALIGNED NO-LABEL WIDGET-ID 138
     FILL-IN-placa-2 AT ROW 4.08 COL 163.14 COLON-ALIGNED WIDGET-ID 158
     FILL-IN-placa AT ROW 4.23 COL 131.86 COLON-ALIGNED WIDGET-ID 8
     FILL-IN_Marca-2 AT ROW 4.96 COL 163.14 COLON-ALIGNED WIDGET-ID 160
     FILL-IN_Marca AT ROW 5.15 COL 124.29 COLON-ALIGNED WIDGET-ID 10
     FILL-IN_Carga-2 AT ROW 5.92 COL 169.29 COLON-ALIGNED WIDGET-ID 162
     FILL-IN_Carga AT ROW 6.04 COL 131.29 COLON-ALIGNED WIDGET-ID 14
     FILL-IN_Libre_d01-2 AT ROW 6.77 COL 169.29 COLON-ALIGNED WIDGET-ID 164
     FILL-IN_Libre_d01 AT ROW 6.92 COL 131.29 COLON-ALIGNED WIDGET-ID 20
     FILL-IN_Libre_c02-2 AT ROW 7.58 COL 169.29 COLON-ALIGNED WIDGET-ID 166
     FILL-IN_Libre_c02 AT ROW 7.81 COL 131.29 COLON-ALIGNED WIDGET-ID 16
     FILL-IN_Libre_c04-2 AT ROW 8.38 COL 169.29 COLON-ALIGNED WIDGET-ID 168
     FILL-IN_Libre_c04 AT ROW 8.69 COL 131.29 COLON-ALIGNED WIDGET-ID 18
     RADIO-SET_libre_d02-2 AT ROW 9.46 COL 175.29 NO-LABEL WIDGET-ID 170
     RADIO-SET_libre_d02 AT ROW 9.58 COL 136.29 NO-LABEL WIDGET-ID 24
     FILL-IN_tarjeta-circulacion-2 AT ROW 10.31 COL 168.86 COLON-ALIGNED WIDGET-ID 182
     FILL-IN_tarjeta-circulacion AT ROW 10.46 COL 132.86 COLON-ALIGNED WIDGET-ID 180
     FILL-IN_CodPro AT ROW 11.88 COL 130.29 COLON-ALIGNED HELP
          "C¢digo del Proveedor" WIDGET-ID 12
     FILL-IN_Ruc AT ROW 11.88 COL 154 COLON-ALIGNED HELP
          "Ruc del Proveedor" WIDGET-ID 66
     FILL-IN_NomPro AT ROW 12.77 COL 130.14 COLON-ALIGNED HELP
          "Nombre del Proveedor" WIDGET-ID 64
     RADIO-SET_libre_d01a AT ROW 13.73 COL 138.86 NO-LABEL WIDGET-ID 68
     FILL-IN-entrega AT ROW 15.38 COL 152.72 COLON-ALIGNED WIDGET-ID 156
     FILL-IN-brevete AT ROW 16.62 COL 130.29 COLON-ALIGNED WIDGET-ID 146
     FILL-IN-DNI AT ROW 16.62 COL 155.72 COLON-ALIGNED WIDGET-ID 148
     FILL-IN-nombre AT ROW 17.5 COL 130 COLON-ALIGNED WIDGET-ID 150
     FILL-IN-apellido AT ROW 18.38 COL 130 COLON-ALIGNED WIDGET-ID 152
     FILL-IN-brevetevcto AT ROW 19.27 COL 130 COLON-ALIGNED WIDGET-ID 154
     COMBO-BOX-ventas AT ROW 20.81 COL 128.43 COLON-ALIGNED WIDGET-ID 192
     COMBO-BOX-no-ventas AT ROW 20.81 COL 169.72 COLON-ALIGNED WIDGET-ID 194
     BUTTON-2 AT ROW 22.58 COL 130 WIDGET-ID 140
     FILL-IN-peso AT ROW 23.92 COL 167.86 COLON-ALIGNED WIDGET-ID 142
     FILL-IN-msg AT ROW 24.96 COL 22.72 COLON-ALIGNED NO-LABEL WIDGET-ID 196
     "¿Es categoria M1 o L?" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 9.65 COL 154.57 WIDGET-ID 174
          FGCOLOR 9 FONT 6
     "(privado = propio, publico = tercero)" VIEW-AS TEXT
          SIZE 29.86 BY .54 AT ROW 14.58 COL 137 WIDGET-ID 134
          FGCOLOR 9 FONT 6
     "¿Es categoria M1 o L?" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 9.73 COL 116.72 WIDGET-ID 62
          FGCOLOR 9 FONT 6
     "Modalidad traslado" VIEW-AS TEXT
          SIZE 18.72 BY .81 AT ROW 13.81 COL 120 WIDGET-ID 132
     RECT-10 AT ROW 11.77 COL 116.29 WIDGET-ID 136
     RECT-13 AT ROW 4 COL 115.57 WIDGET-ID 190
     RECT-12 AT ROW 4 COL 151.57 WIDGET-ID 178
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 188.86 BY 24.96
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
          field rRowId as rowid
          
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
         TITLE              = "Actualizar estados de SUNAT"
         HEIGHT             = 25
         WIDTH              = 189
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
/* BROWSE-TAB BROWSE-2 RECT-12 F-Main */
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
/* SETTINGS FOR FILL-IN FILL-IN-msg IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-nombre IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-peso IN FRAME F-Main
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
     _Where[1]         = "gre_header_disponibles.m_rspta_sunat = 'ENVIADO A SUNAT' or 
gre_header_disponibles.m_rspta_sunat = 'ESPERANDO RESPUESTA SUNAT'"
     _FldNameList[1]   > Temp-Tables.gre_header_disponibles.indTrasladoTotalDAMoDS
"gre_header_disponibles.indTrasladoTotalDAMoDS" "Sele" ? "logical" ? ? ? ? ? ? yes ? no no "4.43" yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[2]   > Temp-Tables.gre_header_disponibles.serieGuia
"gre_header_disponibles.serieGuia" "Serie!Guia" "999" "integer" 14 ? 6 ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.gre_header_disponibles.numeroGuia
"gre_header_disponibles.numeroGuia" "Numero!Guia" "99999999" "integer" 14 ? 6 ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.gre_header_disponibles.fechahora_envio_a_sunat
     _FldNameList[5]   > Temp-Tables.gre_header_disponibles.m_estado_bizlinks
"gre_header_disponibles.m_estado_bizlinks" "Estado!Bizlinks" "x(25)" "character" ? ? ? ? ? ? no ? no no "16.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.gre_header_disponibles.m_rspta_sunat
"gre_header_disponibles.m_rspta_sunat" "Respuesta!de Sunat" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.gre_header_disponibles.fechaEmisionGuia
"gre_header_disponibles.fechaEmisionGuia" "Emsion!PGRE" ? "date" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.gre_header_disponibles.horaEmisionGuia
"gre_header_disponibles.horaEmisionGuia" "Hora!PGRE" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.gre_header_disponibles.m_libre_c05
"gre_header_disponibles.m_libre_c05" "Placa!Vehiculo" "x(15)" "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.gre_header_disponibles.m_fechahorareg
"gre_header_disponibles.m_fechahorareg" "Registro!Vehiculo" ? "datetime" ? ? ? ? ? ? no ? no no "19.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.gre_header_disponibles.ncorrelatio
"gre_header_disponibles.ncorrelatio" "Nro ! PGRE" ">>>>>>>>9" "int64" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.gre_header_disponibles.nombrePuertoAeropuerto
"gre_header_disponibles.nombrePuertoAeropuerto" "PHR" "x(10)" "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.gre_header_disponibles.m_coddoc
"gre_header_disponibles.m_coddoc" "Tipo!Docto" ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.gre_header_disponibles.m_nroser
"gre_header_disponibles.m_nroser" "Serie" "999" "integer" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.gre_header_disponibles.m_nrodoc
"gre_header_disponibles.m_nrodoc" "Numero" "99999999" "integer" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.gre_header_disponibles.motivoTraslado
"gre_header_disponibles.motivoTraslado" "Cod.!Mtvo" ? "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.gre_header_disponibles.descripcionMotivoTraslado
"gre_header_disponibles.descripcionMotivoTraslado" "Descripcion motivo!traslado" "x(50)" "character" ? ? ? ? ? ? no ? no no "22.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.gre_header_disponibles.razonSocialDestinatario
"gre_header_disponibles.razonSocialDestinatario" "Destinatario" "x(80)" "character" ? ? ? ? ? ? no ? no no "33.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > Temp-Tables.gre_header_disponibles.direccionPtoLlegada
"gre_header_disponibles.direccionPtoLlegada" "Punto de llegada" "x(100)" "character" ? ? ? ? ? ? no ? no no "34.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Actualizar estados de SUNAT */
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
ON MOUSE-SELECT-DBLCLICK OF BROWSE-2 IN FRAME F-Main /* GENERAR GUIAS REMISION FISICAS - NO RESONDIDAS X SUNAT */
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
        /*
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(iRow) THEN DO:
        MESSAGE "Valor" SKIP
                iRow SKIP
                gre_header_disponibles.ncorrelatio.
        END.
        */
        /*
        FIND FIRST gre_header_seleccionados WHERE gre_header_seleccionados.ncorrelatio = gre_header_disponibles.ncorrelatio
                      EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE gre_header_seleccionados THEN DO:
              ASSIGN gre_header_disponibles.m_cco = "SELE".
              ASSIGN gre_header_seleccionados.m_cco = "OK".

            dPesoTotal = dPesoTotal + gre_header_seleccionados.pesoBrutoTotalBienes.
            RUN show_totales.

              {&open-query-browse-2}
              {&open-query-browse-9}
        END.
        */
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
ON START-SEARCH OF BROWSE-2 IN FRAME F-Main /* GENERAR GUIAS REMISION FISICAS - NO RESONDIDAS X SUNAT */
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
ON VALUE-CHANGED OF BROWSE-2 IN FRAME F-Main /* GENERAR GUIAS REMISION FISICAS - NO RESONDIDAS X SUNAT */
DO:
  RUN muestra-datos-transporte.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gre_header_disponibles.indTrasladoTotalDAMoDS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gre_header_disponibles.indTrasladoTotalDAMoDS BROWSE-2 _BROWSE-COLUMN W-Win
ON ENTRY OF gre_header_disponibles.indTrasladoTotalDAMoDS IN BROWSE BROWSE-2 /* Sele */
DO:
  cOldValue = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gre_header_disponibles.indTrasladoTotalDAMoDS BROWSE-2 _BROWSE-COLUMN W-Win
ON LEAVE OF gre_header_disponibles.indTrasladoTotalDAMoDS IN BROWSE BROWSE-2 /* Sele */
DO:
    IF SELF:SCREEN-VALUE = 'no' THEN DO:
        IF cOldValue = 'yes' THEN iRegSeleccionados = iRegSeleccionados - 1.
        IF iRegSeleccionados < 0 THEN iRegSeleccionados = 0.
    END.
    ELSE DO:
        IF cOldValue = 'no' THEN DO:
            IF iRegSeleccionados + 1 > iMaximoRegSeleccionados THEN DO:
                SELF:SCREEN-VALUE = 'no'.
            END.
            ELSE DO:
                iRegSeleccionados = iRegSeleccionados + 1.
            END.            
        END.            
    END.

    RUN muestra-msg.

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
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Generar Guia de Remision Fisicas (GRF) */
DO:

 ASSIGN combo-box-ventas combo-box-no-ventas.

  RUN procesar-guias.
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
  DISPLAY FILL-IN-datos FILL-IN-placa-2 FILL-IN-placa FILL-IN_Marca-2 
          FILL-IN_Marca FILL-IN_Carga-2 FILL-IN_Carga FILL-IN_Libre_d01-2 
          FILL-IN_Libre_d01 FILL-IN_Libre_c02-2 FILL-IN_Libre_c02 
          FILL-IN_Libre_c04-2 FILL-IN_Libre_c04 RADIO-SET_libre_d02-2 
          RADIO-SET_libre_d02 FILL-IN_tarjeta-circulacion-2 
          FILL-IN_tarjeta-circulacion FILL-IN_CodPro FILL-IN_Ruc FILL-IN_NomPro 
          RADIO-SET_libre_d01a FILL-IN-entrega FILL-IN-brevete FILL-IN-DNI 
          FILL-IN-nombre FILL-IN-apellido FILL-IN-brevetevcto COMBO-BOX-ventas 
          COMBO-BOX-no-ventas FILL-IN-peso FILL-IN-msg 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-10 RECT-13 RECT-12 BROWSE-2 BUTTON-1 COMBO-BOX-ventas 
         COMBO-BOX-no-ventas BUTTON-2 
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

DEFINE VAR dHoraMinutoConfigurada AS DEC.
DEFINE VAR cValorDeRetorno AS CHAR.
DEFINE VAR iMinutosSinRespuesta AS INT.
DEFINE VAR dHoraMinutoSinRespuesta AS DEC.

RUN gre/get-parametro-config-gre("PARAMETRO","TIEMPOENHORAS","SINRESPUESTASUNAT","N","2.5",OUTPUT cValorDeRetorno).

If cValorDeRetorno = "ERROR" THEN DO:
    MESSAGE "ERROR : No se pudo encontrar el parametro que indica el tiempo considerado como demora de respuesta de Sunat".
    RETURN "ADM-ERROR".
END.

dHoraMinutoConfigurada = DECIMAL(TRIM(cValorDeRetorno)) NO-ERROR.   /* En hora minuto 1.5 = Una hora 50 minutos, 1:27 una hora 27 minutos */

SESSION:SET-WAIT-STATE("GENERAL").
FOR EACH gre_header WHERE gre_header.m_rspta_sunat = 'ENVIADO A SUNAT' AND
                     gre_header.m_divorigen = s-coddiv NO-LOCK:

    iMinutosSinRespuesta = INTERVAL(NOW, gre_header.fechahora_envio_a_sunat, "minutes").  /* En minutos */
    dHoraMinutoSinRespuesta = INT(iMinutosSinRespuesta / 60) + (iMinutosSinRespuesta MODULO 60) / 100.
    /*
    MESSAGE "dHoraMinutoConfigurada " dHoraMinutoConfigurada SKIP
            "iMinutosSinRespuesta " iMinutosSinRespuesta SKIP
            "dHoraMinutoSinRespuesta " dHoraMinutoSinRespuesta.
    */
    IF dHoraMinutoConfigurada > dHoraMinutoSinRespuesta THEN NEXT.

    CREATE gre_header_disponibles.
    BUFFER-COPY gre_header TO gre_header_disponibles.

    ASSIGN gre_header_disponibles.rRowId = ROWID(gre_header)
            gre_header_disponibles.indTrasladoTotalDAMoDS = NO.     /* Se usa para seleccionar o desseleccionar */
    
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

    FIND FIRST gre_vehiculo_hdr WHERE gre_vehiculo_hdr.ncorrelativo = gre_header.correlativo_vehiculo NO-LOCK NO-ERROR.
    IF AVAILABLE gre_vehiculo_hdr THEN DO:
        ASSIGN gre_header_disponibles.m_libre_c05 = gre_vehiculo_hdr.placa
                gre_header_disponibles.m_fechahorareg = gre_vehiculo_hdr.fhregistro.
        ASSIGN gre_header_seleccionados.m_libre_c05 = gre_vehiculo_hdr.placa
                gre_header_seleccionados.m_fechahorareg = gre_vehiculo_hdr.fhregistro.
    END.
    
END.
/**/
FOR EACH gre_header WHERE gre_header.m_rspta_sunat = 'ESPERANDO RESPUESTA SUNAT' AND
                     gre_header.m_divorigen = s-coddiv NO-LOCK:

    iMinutosSinRespuesta = INTERVAL(NOW, gre_header.fechahora_envio_a_sunat, "minutes").  /* En minutos */
    dHoraMinutoSinRespuesta = INT(iMinutosSinRespuesta / 60) + (iMinutosSinRespuesta MODULO 60) / 100.

    IF dHoraMinutoConfigurada > dHoraMinutoSinRespuesta THEN NEXT.

    CREATE gre_header_disponibles.
    BUFFER-COPY gre_header TO gre_header_disponibles.

    ASSIGN gre_header_disponibles.rRowId = ROWID(gre_header)
                    gre_header_disponibles.indTrasladoTotalDAMoDS = NO.     /* Se usa para seleccionar o desseleccionar */
    
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
    ASSIGN gre_header_disponibles.nombrePuertoAeropuerto = cNroPHR.
    ASSIGN gre_header_seleccionados.nombrePuertoAeropuerto = cNroPHR.

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
/*{&open-query-browse-9}*/

IF iRegis > 0 THEN DO:
    APPLY 'VALUE-CHANGED':U TO browse-2 IN FRAME {&FRAME-NAME}.
END.

/*dPesoTotal = 0.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-textoQR W-Win 
PROCEDURE get-textoQR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pcTextoQR AS CHAR NO-UNDO.

DEFINE VAR v-result AS CHAR.
DEFINE VAR v-response AS LONGCHAR.
DEFINE VAR v-content AS LONGCHAR.
DEFINE VAR cTagInicial AS CHAR.
DEFINE VAR cTagFinal AS CHAR.
DEFINE VAR cTexto AS LONGCHAR.

DEFINE VAR curlCDR AS CHAR.

pcTextoQR = "".

/* Tag del link del CDR : xmlFileSunatUrl */
FIND FIRST tTagsEstadoDoc WHERE tTagsEstadoDoc.cTag = 'xmlFileSunatUrl' NO-LOCK NO-ERROR.
IF AVAILABLE tTagsEstadoDoc THEN DO:
    
    curlCDR = TRIM( tTagsEstadoDoc.cValue).    

    RUN lib\http-get-contenido.p(cUrlCDR,output v-result,output v-response,output v-content).
                    
    IF v-result = "1:Success"  THEN DO:
        /* Sacar el el texto para generar el QR */

        cTagInicial = "<cac:DocumentReference>".
        cTagFinal = "</cac:DocumentReference>".

        RUN getValueTag(v-content,cTagInicial,cTagFinal, OUTPUT cTexto).

        IF NOT (TRUE <> (cTexto > "")) THEN DO:
            cTagInicial = "<cbc:DocumentDescription>".
            cTagFinal = "</cbc:DocumentDescription>".

            RUN getValueTAG(cTexto,cTagInicial,cTagFinal, OUTPUT pcTextoQR).            
        END.
    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getValueTag W-Win 
PROCEDURE getValueTag :
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

    pRetVal = "".

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

  /* Code placed here will execute AFTER standard behavior.    */    
  DEFINE VAR hProc AS HANDLE NO-UNDO.

  RUN alm/almacen-library.p PERSISTENT SET hProc.
  
  DEF VAR pSeries AS CHAR NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    /* Serie x Ventas */
    RUN GR_Lista_de_Series IN hProc (INPUT s-CodDiv,
                                     INPUT "",
                                     INPUT "VENTAS",
                                     INPUT TRUE,
                                     INPUT "ELECTRONICA",
                                     OUTPUT pSeries).
/*     RUN gn/p-series-solo-gr.r(INPUT s-CodDiv, */
/*                            INPUT "VENTAS",    */
/*                            INPUT YES,         */
/*                            OUTPUT pSeries).   */
    combo-box-ventas:LIST-ITEMS = pSeries.
    combo-box-ventas = ENTRY(1,combo-box-ventas:LIST-ITEMS).
    DISPLAY combo-box-ventas.
    
    pSeries = "".
    /* Serie x NO Ventas */
    RUN GR_Lista_de_Series IN hProc (INPUT s-CodDiv,
                                     INPUT "",
                                     INPUT "TRANSFERENCIAS",
                                     INPUT TRUE,
                                     INPUT "ELECTRONICA",
                                     OUTPUT pSeries).
/*     RUN gn/p-series-solo-gr(INPUT s-CodDiv,        */
/*                            INPUT "TRANSFERENCIAS", */
/*                            INPUT YES,              */
/*                            OUTPUT pSeries).        */

        combo-box-no-ventas:LIST-ITEMS = pSeries.
        combo-box-no-ventas = ENTRY(1,combo-box-no-ventas:LIST-ITEMS).        
        DISPLAY combo-box-no-ventas.
  END.

  RUN muestra-msg.

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
        FILL-IN_nompro:SCREEN-VALUE = gre_vehiculo_hdr.transp_razonsocial
        FILL-IN_tarjeta-circulacion:SCREEN-VALUE = gre_vehiculo_hdr.codtransportista
        FILL-IN_ruc:SCREEN-VALUE = gre_vehiculo_hdr.transp_ruc
        RADIO-SET_libre_d01a:SCREEN-VALUE = STRING(gre_vehiculo_hdr.transp_modalidad)
        fill-in-brevete:SCREEN-VALUE = gre_vehiculo_hdr.brevete
        fill-in-dni:SCREEN-VALUE = gre_vehiculo_hdr.chofer_dni
        fill-in-nombre:SCREEN-VALUE = gre_vehiculo_hdr.chofer_nombre
        fill-in-apellido:SCREEN-VALUE = gre_vehiculo_hdr.chofer_apellidos
        fill-in-brevetevcto:SCREEN-VALUE = string(gre_vehiculo_hdr.chofer_vctobrevete,"99/99/9999")
        fill-in-entrega:SCREEN-VALUE = string(gre_header_disponibles.fechaEntregaBienes,"99/99/9999")
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE muestra-msg W-Win 
PROCEDURE muestra-msg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

fill-in-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Registro(s) seleccionado(s) " + STRING(iRegSeleccionados) + " , tope maximo " + string(iMaximoRegSeleccionados).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar-estados W-Win 
PROCEDURE procesar-estados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR cEstadoBizLinks AS CHAR.  
DEFINE VAR cEstadoSUNAT AS CHAR.
DEFINE VAR cEstadoDocumento AS CHAR.

DEFINE VAR iRow AS INT.
DEFINE VAR iRowsSelected AS INT.

DEFINE VAR cNrodoc AS CHAR.
DEFINE VAR cCoddiv AS CHAR.

DEFINE VAR rRowId AS ROWID.
DEFINE VAR cMotivoRechazo AS CHAR.
DEFINE VAR cCodEstado AS CHAR.
DEFINE VAR cDesEstado AS CHAR.

DEFINE VAR ctextoQR AS CHAR.
DEFINE VAR ctextoQROK AS CHAR.

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
                IF LOOKUP(cEstadoSUNAT,"ENVIADO A SUNAT,ESPERANDO RESPUESTA SUNAT") > 0 THEN DO:

                    RUN gn/p-estado-documento-electronico-v3.r(INPUT cCodDoc,
                                        INPUT cNroDoc,
                                        INPUT "",
                                        INPUT "ESTADO DOCUMENTO",
                                        INPUT-OUTPUT TABLE tTagsEstadoDoc) NO-ERROR.

                    IF ERROR-STATUS:ERROR THEN NEXT.
                    FIND FIRST tTagsEstadoDoc WHERE tTagsEstadoDoc.cTag = "messageSunat" NO-LOCK NO-ERROR.
                    IF AVAILABLE tTagsEstadoDoc THEN cMotivoRechazo = tTagsEstadoDoc.cValue.

                    FIND FIRST tTagsEstadoDoc WHERE tTagsEstadoDoc.cTag = "statusSunat" NO-LOCK NO-ERROR.
                    IF AVAILABLE tTagsEstadoDoc THEN DO:
                        cCodEstado = tTagsEstadoDoc.cValue.

                        IF LOOKUP(tTagsEstadoDoc.cValue,"RC_05,AC_03,ERROR") > 0 THEN DO:

                            cDesEstado = "ACEPTADO POR SUNAT".
                            IF tTagsEstadoDoc.cValue = "RC_05" OR tTagsEstadoDoc.cValue = "ERROR" THEN DO:
                                cDesEstado = "RECHAZADO POR SUNAT".
                                /* Fue rechazado */
                                FIND FIRST tTagsEstadoDoc WHERE tTagsEstadoDoc.cTag = "messageSunat" NO-LOCK NO-ERROR.
                                IF AVAILABLE tTagsEstadoDoc THEN DO:
                                    cMotivoRechazo = tTagsEstadoDoc.cValue.
                                END.
                            END.
                            /* QR */
                            ctextoQR = "".
                            IF cDesEstado = "ACEPTADO POR SUNAT" THEN DO:
                                FIND FIRST gre_header_qr WHERE gre_header_qr.ncorrelativo = gre_header_disponibles.ncorrelatio NO-LOCK NO-ERROR NO-WAIT.
                                IF NOT AVAILABLE gre_header_qr THEN DO:
                                    RUN get-textoQR(OUTPUT ctextoQR).                
                                END.                
                            END.
                            /* Actualizo */
                            FIND FIRST b-gre_header WHERE ROWID(b-gre_header) = gre_header_disponibles.rRowid EXCLUSIVE-LOCK NO-ERROR.
                            IF AVAILABLE b-gre_header THEN DO:
                                /* QR */
                                IF ctextoQR <> "" THEN DO:
                                    FIND FIRST gre_header_qr WHERE gre_header_qr.ncorrelativo = gre_header_disponibles.ncorrelatio EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                                    IF NOT LOCKED gre_header_qr THEN DO:
                                        IF NOT AVAILABLE gre_header_qr THEN DO:
                                            CREATE gre_header_qr.
                                                ASSIGN gre_header_qr.ncorrelativo = gre_header_disponibles.ncorrelatio
                                                        gre_header_qr.USER_crea = USERID("dictdb").
                                        END.
                                        ASSIGN gre_header_qr.data_QR = ctextoQR.
                                    END.
                                    RELEASE gre_header_qr NO-ERROR.
                                END.
                                /**/
                                ASSIGN b-gre_header.m_rspta_sunat = CAPS(cDesEstado)
                                        /*gre_header.m_estado_bizlinks = CAPS(cCodEstado)*/
                                        b-gre_header.m_motivo_de_rechazo = cMotivoRechazo.
                                RELEASE b-gre_header NO-ERROR.
                            END.
                            ASSIGN {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.m_rspta_sunat = "LOQUESEA".   /* solo para q no lo muestre en pantalla */
                        END.
                        ELSE DO:
                            FIND FIRST b-gre_header WHERE ROWID(b-gre_header) = gre_header_disponibles.rRowid EXCLUSIVE-LOCK NO-ERROR.
                            IF AVAILABLE b-gre_header THEN DO:
                                ASSIGN /*gre_header.m_estado_bizlinks = CAPS(cCodEstado)*/
                                        b-gre_header.m_motivo_de_rechazo = cMotivoRechazo.
                                RELEASE b-gre_header NO-ERROR.
                            END.
                        END.
                    END.
                END.
            END.
        END.
        SESSION:SET-WAIT-STA("").
    END.
END.

{&open-query-browse-2}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar-guias W-Win 
PROCEDURE procesar-guias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR iSerieGuia AS INT.
DEFINE VAR cRetVal AS CHAR.

DEFINE VAR iTotalGRE AS INT.
DEFINE VAR iTotalGREProcesadas AS INT.
DEFINE VAR iTotalGREerror AS INT.

SESSION:SET-WAIT-STATE("GENERAL").

FOR EACH x-gre_header_disponibles WHERE x-gre_header_disponibles.indTrasladoTotalDAMoDS = YES :

    iSerieGuia = -99.
    iTotalGRE = iTotalGRE + 1.

    CASE TRUE.
        WHEN x-gre_header_disponibles.m_codmov = 2 AND LOOKUP(x-gre_header_disponibles.m_coddoc,"FAC,BOL,FAI") > 0 THEN DO:
            iSerieGuia = integer(combo-box-ventas).
        END.
        WHEN x-gre_header_disponibles.m_codmov = 3 AND LOOKUP(x-gre_header_disponibles.m_coddoc,"OTR") > 0 THEN DO:
            iSerieGuia = integer(combo-box-no-ventas).
        END.
    END CASE.
    
    IF iSerieGuia = -99 THEN DO:
        iTotalGREerror = iTotalGREerror + 1.
        NEXT.
    END.         

    RUN gre/gre-procesos-plan-b.r(x-gre_header_disponibles.serieGuia, x-gre_header_disponibles.numeroGuia,
                                  s-coddiv,iSerieGuia,OUTPUT cRetVal).

    IF RETURN-VALUE = "OK" THEN DO:
        iTotalGREProcesadas = iTotalGREProcesadas + 1.
        ASSIGN x-gre_header_disponibles.indTrasladoTotalDAMoDS = NO
                x-gre_header_disponibles.m_rspta_sunat = "ZZZZZ".       /* Solo para procesos de pintado de pantalla */
    END.
    ELSE DO:
        iTotalGREerror = iTotalGREerror + 1.
        /*MESSAGE cRetVal.        /* ?????????????????????????????????????????? */*/
    END.
END.

SESSION:SET-WAIT-STATE("").

iRegSeleccionados = iTotalGREError.
IF iRegSeleccionados < 0 THEN iRegSeleccionados = 0.

RUN muestra-msg.

{&OPEN-QUERY-BROWSE-2}

MESSAGE "Resultados del Proceso " SKIP
        "GRE elegidas : " + STRING(iTotalGRE) SKIP
        "GRE procesadas correctamente : " + STRING(iTotalGREProcesadas) SKIP
        "GRE que generaron ERRORES :" + STRING(iTotalGREError)
    VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/*
DEFINE INPUT PARAMETER pserieGRE AS INT NO-UNDO.
DEFINE INPUT PARAMETER pnumeroGRE AS INT NO-UNDO.
DEFINE INPUT PARAMETER pCodDiv AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pserieGRF AS INT NO-UNDO.        /* Guia de remision Fisica */
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.
*/

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

