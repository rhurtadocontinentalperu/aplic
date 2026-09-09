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

/* Local Variable Definitions ---                                       */

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.

/* En definitions */
define var x-sort-column-current as char.

DEFINE VAR dPesoTotal AS DEC INIT 0.

DEFINE BUFFER b-gre_header FOR gre_header.
DEFINE BUFFER x-gre_header FOR gre_header.

/* Cuanto tiempo debe estar vivo la PGRE.m_rspta_sunat = SIN ENVIAR */
DEFINE VAR iMaximoDiasAntiguedadPGRE AS INT.
DEFINE VAR cValorDeRetorno AS CHAR.

DEFINE VAR iMaximoDiasInicioTrasladoPGRE AS INT.

/**/
RUN gre/get-parametro-config-gre("PARAMETRO","TIEMPO_VIDA_PGRE","DIAS","N","2",OUTPUT cValorDeRetorno).

If cValorDeRetorno = "ERROR" THEN DO:
    MESSAGE "Hubo problemas al recuperar el parametro de tiempo de vida de la PGRE" VIEW-AS ALERT-BOX INFORMATION.
    RETURN ERROR.
END.

iMaximoDiasAntiguedadPGRE = INTEGER(cValorDeRetorno).

RUN gn/parametro-config-vtatabla("CONFIG-GRE",
                                "PARAMETRO",
                                "PANTALLA",
                                "MAXIMODIAS_INICIOTRASLADO",
                                "Maximo dias para el inicio del traslado",
                                "N",
                                "5",
                                OUTPUT cValorDeRetorno).

If cValorDeRetorno = "ERROR" THEN DO:
    MESSAGE "Hubo problemas al recuperar el parametro de tiempo maximo de incio de traslado de la PGRE" VIEW-AS ALERT-BOX INFORMATION.
    RETURN ERROR.
END.

iMaximoDiasInicioTrasladoPGRE = INTEGER(cValorDeRetorno).

DEFINE VAR cFiltro AS CHAR INIT "Todos".
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
&Scoped-define INTERNAL-TABLES gre_header_disponibles ~
gre_header_seleccionados

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 gre_header_disponibles.ncorrelatio ~
gre_header_disponibles.fechaEmisionGuia ~
gre_header_disponibles.horaEmisionGuia ~
gre_header_disponibles.correoRemitente ~
gre_header_disponibles.correoDestinatario ~
gre_header_disponibles.nombrePuertoAeropuerto ~
gre_header_disponibles.m_coddoc gre_header_disponibles.m_nroser ~
gre_header_disponibles.m_nrodoc gre_header_disponibles.motivoTraslado ~
gre_header_disponibles.descripcionMotivoTraslado ~
gre_header_disponibles.razonSocialDestinatario ~
gre_header_disponibles.direccionPtoLlegada 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH gre_header_disponibles ~
      WHERE (gre_header_disponibles.m_cco = "") and ~
((cNroPHR = "" or gre_header_disponibles.nombrePuertoAeropuerto = cNroPHR) and ~
(cTipoOrden = '<Todos>' or gre_header_disponibles.correoRemitente = cTipoOrden) and ~
(cNroOrden = "" or gre_header_disponibles.correoDestinatario = cNroOrden)) NO-LOCK ~
    BY gre_header_disponibles.fechaEmisionGuia DESCENDING ~
       BY gre_header_disponibles.horaEmisionGuia DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH gre_header_disponibles ~
      WHERE (gre_header_disponibles.m_cco = "") and ~
((cNroPHR = "" or gre_header_disponibles.nombrePuertoAeropuerto = cNroPHR) and ~
(cTipoOrden = '<Todos>' or gre_header_disponibles.correoRemitente = cTipoOrden) and ~
(cNroOrden = "" or gre_header_disponibles.correoDestinatario = cNroOrden)) NO-LOCK ~
    BY gre_header_disponibles.fechaEmisionGuia DESCENDING ~
       BY gre_header_disponibles.horaEmisionGuia DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 gre_header_disponibles
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 gre_header_disponibles


/* Definitions for BROWSE BROWSE-9                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-9 ~
gre_header_seleccionados.ncorrelatio ~
gre_header_seleccionados.fechaEmisionGuia ~
gre_header_seleccionados.horaEmisionGuia ~
gre_header_seleccionados.correoRemitente ~
gre_header_seleccionados.correoDestinatario ~
gre_header_seleccionados.nombrePuertoAeropuerto ~
gre_header_seleccionados.m_coddoc gre_header_seleccionados.m_nroser ~
gre_header_seleccionados.m_nrodoc gre_header_seleccionados.motivoTraslado ~
gre_header_seleccionados.descripcionMotivoTraslado ~
gre_header_seleccionados.razonSocialDestinatario ~
gre_header_seleccionados.direccionPtoLlegada 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-9 
&Scoped-define QUERY-STRING-BROWSE-9 FOR EACH gre_header_seleccionados ~
      WHERE gre_header_seleccionados.m_cco = "OK" NO-LOCK ~
    BY gre_header_seleccionados.fechaEmisionGuia DESCENDING ~
       BY gre_header_seleccionados.horaEmisionGuia DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-9 OPEN QUERY BROWSE-9 FOR EACH gre_header_seleccionados ~
      WHERE gre_header_seleccionados.m_cco = "OK" NO-LOCK ~
    BY gre_header_seleccionados.fechaEmisionGuia DESCENDING ~
       BY gre_header_seleccionados.horaEmisionGuia DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-9 gre_header_seleccionados
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-9 gre_header_seleccionados


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-9}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-11 RECT-12 RECT-14 BROWSE-2 ~
BUTTON-1 BUTTON-3 FILL-IN-phr COMBO-BOX-tipoorden FILL-IN-orden ~
BUTTON-filtrar BUTTON-reset-filtros FILL-IN-placa FILL-IN-placa-2 BROWSE-9 ~
RADIO-SET-transbordo FILL-IN-brevete FILL-IN-entrega BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-phr COMBO-BOX-tipoorden ~
FILL-IN-orden FILL-IN-datos FILL-IN-placa FILL-IN-placa-2 FILL-IN_Marca ~
FILL-IN_Marca-2 FILL-IN_Carga-2 FILL-IN_Carga FILL-IN_Libre_d01-2 ~
FILL-IN_Libre_d01 FILL-IN_Libre_c02-2 FILL-IN_Libre_c02 FILL-IN_Libre_c04-2 ~
FILL-IN_Libre_c04 RADIO-SET_libre_d02-2 RADIO-SET_libre_d02 ~
FILL-IN_tarjeta-circulacion FILL-IN_tarjeta-circulacion-2 FILL-IN_CodPro ~
FILL-IN_Ruc FILL-IN_NomPro RADIO-SET_libre_d01a RADIO-SET-transbordo ~
FILL-IN-brevete FILL-IN-DNI FILL-IN-nombre FILL-IN-apellido ~
FILL-IN-brevetevcto FILL-IN-entrega FILL-IN-peso 

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
     LABEL "Grabar transportista y dejar listo para envio a SUNAT" 
     SIZE 45 BY 1.12
     FGCOLOR 2 FONT 6.

DEFINE BUTTON BUTTON-3 
     LABEL "( Seleccionar mas de uno) >>>..." 
     SIZE 25 BY 1.12.

DEFINE BUTTON BUTTON-filtrar 
     LABEL "Filtrar" 
     SIZE 15 BY .77.

DEFINE BUTTON BUTTON-reset-filtros 
     LABEL "Limpiar filtros" 
     SIZE 16.29 BY .77.

DEFINE VARIABLE COMBO-BOX-series AS CHARACTER FORMAT "X(256)":U 
     LABEL "Guia Ventas" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 8 BY 1
     FONT 11 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-series-salidas AS CHARACTER FORMAT "X(256)":U 
     LABEL "Guia otros traslados" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 8 BY 1
     FONT 11 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-tipoorden AS CHARACTER FORMAT "X(256)":U INITIAL "<Todos>" 
     LABEL "Tipo Orden" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "<Todos>","O/D","OTR" 
     DROP-DOWN-LIST
     SIZE 10.29 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-apellido AS CHARACTER FORMAT "X(60)":U 
     LABEL "Apellidos" 
     VIEW-AS FILL-IN 
     SIZE 43.43 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-brevete AS CHARACTER FORMAT "X(12)":U 
     LABEL "Brevete" 
     VIEW-AS FILL-IN 
     SIZE 14.29 BY .88
     FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-brevetevcto AS DATE FORMAT "99/99/9999":U 
     LABEL "Vcto brevete" 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-datos AS CHARACTER FORMAT "X(60)":U INITIAL "DATOS DEL VEHICULO Y TRANSPORTISTA PARA EL TRASLADO" 
     VIEW-AS FILL-IN 
     SIZE 66.43 BY .88
     BGCOLOR 15 FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-DNI AS CHARACTER FORMAT "X(10)":U 
     LABEL "D.N.I" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-entrega AS DATE FORMAT "99/99/9999":U 
     LABEL "Inicio del traslado" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-nombre AS CHARACTER FORMAT "X(60)":U 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 43.43 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-orden AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "No. Orden" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-peso AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Peso total (Kgrs)" 
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
     FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-placa-2 AS CHARACTER FORMAT "X(10)":U 
     LABEL "Placa 2" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88
     FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_Carga AS DECIMAL FORMAT "->>>,>>9.99" INITIAL 0 
     LABEL "Carga maxima" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_Carga-2 AS DECIMAL FORMAT "->>>,>>9.99" INITIAL 0 
     LABEL "Carga maxima" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodPro AS CHARACTER FORMAT "x(11)" 
     LABEL "Transportista" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88
     FGCOLOR 4 FONT 6.

DEFINE VARIABLE FILL-IN_Libre_c02 AS CHARACTER FORMAT "x(10)" 
     LABEL "Tonelaje" 
     VIEW-AS FILL-IN 
     SIZE 7.86 BY .88
     FGCOLOR 9 FONT 6.

DEFINE VARIABLE FILL-IN_Libre_c02-2 AS CHARACTER FORMAT "x(10)" 
     LABEL "Tonelaje" 
     VIEW-AS FILL-IN 
     SIZE 7.86 BY .88
     FGCOLOR 9 FONT 6.

DEFINE VARIABLE FILL-IN_Libre_c04 AS CHARACTER FORMAT "x(20)" 
     LABEL "Registro MTC" 
     VIEW-AS FILL-IN 
     SIZE 15.86 BY .88
     FGCOLOR 9 FONT 6.

DEFINE VARIABLE FILL-IN_Libre_c04-2 AS CHARACTER FORMAT "x(20)" 
     LABEL "Registro MTC" 
     VIEW-AS FILL-IN 
     SIZE 15.86 BY .88
     FGCOLOR 9 FONT 6.

DEFINE VARIABLE FILL-IN_Libre_d01 AS DECIMAL FORMAT "->>,>>>,>>9.99" INITIAL 0 
     LABEL "Capacidad minima" 
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88
     FGCOLOR 9 FONT 6.

DEFINE VARIABLE FILL-IN_Libre_d01-2 AS DECIMAL FORMAT "->>,>>>,>>9.99" INITIAL 0 
     LABEL "Capacidad minima" 
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88
     BGCOLOR 15 FGCOLOR 9 FONT 6.

DEFINE VARIABLE FILL-IN_Marca AS CHARACTER FORMAT "x(20)" 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 21.43 BY .88
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_Marca-2 AS CHARACTER FORMAT "x(20)" 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 21.43 BY .88
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_NomPro AS CHARACTER FORMAT "x(50)" 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 46.86 BY .88
     FGCOLOR 4 FONT 6.

DEFINE VARIABLE FILL-IN_Ruc AS CHARACTER FORMAT "x(11)" 
     LABEL "Ruc" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88
     FGCOLOR 4 FONT 6.

DEFINE VARIABLE FILL-IN_tarjeta-circulacion AS CHARACTER FORMAT "x(20)" 
     LABEL "Tarjeta. circul." 
     VIEW-AS FILL-IN 
     SIZE 15.86 BY .88
     FGCOLOR 9 FONT 6.

DEFINE VARIABLE FILL-IN_tarjeta-circulacion-2 AS CHARACTER FORMAT "x(20)" 
     LABEL "Tarjeta. circul." 
     VIEW-AS FILL-IN 
     SIZE 15.86 BY .88
     FGCOLOR 9 FONT 6.

DEFINE VARIABLE RADIO-SET-transbordo AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "NO Programado", 0,
"Programado", 1
     SIZE 14 BY 1.38 NO-UNDO.

DEFINE VARIABLE RADIO-SET_libre_d01a AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Ninguno", 0,
"Publico", 1,
"Privado", 2
     SIZE 27.86 BY .69
     BGCOLOR 15 FONT 4 NO-UNDO.

DEFINE VARIABLE RADIO-SET_libre_d02 AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Si", 1,
"No", 0
     SIZE 12 BY .81
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE RADIO-SET_libre_d02-2 AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Si", 1,
"No", 0
     SIZE 12 BY .81
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 72 BY 6.88.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36 BY 7.19.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36 BY 7.19.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 72.57 BY 2.23.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      gre_header_disponibles SCROLLING.

DEFINE QUERY BROWSE-9 FOR 
      gre_header_seleccionados SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      gre_header_disponibles.ncorrelatio COLUMN-LABEL "Nro ! PGRE" FORMAT ">>>>>>>>9":U
            WIDTH 10.43
      gre_header_disponibles.fechaEmisionGuia COLUMN-LABEL "Fecha!Emsion" FORMAT "99/99/9999":U
            WIDTH 11.43
      gre_header_disponibles.horaEmisionGuia COLUMN-LABEL "Hora!Emision" FORMAT "x(8)":U
            WIDTH 8.43
      gre_header_disponibles.correoRemitente COLUMN-LABEL "Cod!Orden" FORMAT "x(5)":U
            WIDTH 5 COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 15
      gre_header_disponibles.correoDestinatario COLUMN-LABEL "Nro!Orden" FORMAT "x(15)":U
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
            WIDTH 34.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 113.43 BY 12.54
         FONT 3
         TITLE "PRE-GUIAS DE REMISION DISPONIBLES" ROW-HEIGHT-CHARS .46.

DEFINE BROWSE BROWSE-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-9 W-Win _STRUCTURED
  QUERY BROWSE-9 NO-LOCK DISPLAY
      gre_header_seleccionados.ncorrelatio COLUMN-LABEL "Nro. !PGRE" FORMAT ">>>>>>>>9":U
            WIDTH 10.43
      gre_header_seleccionados.fechaEmisionGuia COLUMN-LABEL "Fecha!Emision" FORMAT "99/99/9999":U
            WIDTH 11.43
      gre_header_seleccionados.horaEmisionGuia COLUMN-LABEL "Hora!Emision" FORMAT "x(8)":U
            WIDTH 8.43
      gre_header_seleccionados.correoRemitente COLUMN-LABEL "Cod!Orden" FORMAT "x(6)":U
            WIDTH 5 COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 15
      gre_header_seleccionados.correoDestinatario COLUMN-LABEL "Nro!Orden" FORMAT "x(15)":U
            WIDTH 10.86 COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 15
      gre_header_seleccionados.nombrePuertoAeropuerto COLUMN-LABEL "PHR" FORMAT "x(10)":U
            WIDTH 12.43 COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 15
      gre_header_seleccionados.m_coddoc COLUMN-LABEL "Tipo!Docto" FORMAT "x(5)":U
            WIDTH 5.43
      gre_header_seleccionados.m_nroser COLUMN-LABEL "Serie" FORMAT "999":U
            WIDTH 5.43
      gre_header_seleccionados.m_nrodoc COLUMN-LABEL "Numero" FORMAT "99999999":U
            WIDTH 9.43
      gre_header_seleccionados.motivoTraslado COLUMN-LABEL "Cod.!Mtvo" FORMAT "x(2)":U
            WIDTH 4.43
      gre_header_seleccionados.descripcionMotivoTraslado COLUMN-LABEL "Descripcion Motivo!Traslado" FORMAT "x(100)":U
            WIDTH 22.43
      gre_header_seleccionados.razonSocialDestinatario COLUMN-LABEL "Destinatario" FORMAT "x(80)":U
            WIDTH 33.43
      gre_header_seleccionados.direccionPtoLlegada COLUMN-LABEL "Direccion de llegada" FORMAT "x(100)":U
            WIDTH 36
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS DROP-TARGET SIZE 113.43 BY 10.88
         FONT 3
         TITLE "PRE-GUIAS SELECCIONADAS PARA ASIGNARLE TRANSPORTISTA".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-2 AT ROW 1.12 COL 1.72 WIDGET-ID 200
     BUTTON-1 AT ROW 1.15 COL 118 WIDGET-ID 4
     BUTTON-3 AT ROW 1.15 COL 148 WIDGET-ID 144
     FILL-IN-phr AT ROW 2.92 COL 137 RIGHT-ALIGNED WIDGET-ID 196
     COMBO-BOX-tipoorden AT ROW 2.92 COL 150.72 COLON-ALIGNED WIDGET-ID 200
     FILL-IN-orden AT ROW 2.92 COL 185 RIGHT-ALIGNED WIDGET-ID 198
     BUTTON-filtrar AT ROW 3.96 COL 146 WIDGET-ID 206
     BUTTON-reset-filtros AT ROW 3.96 COL 163.72 WIDGET-ID 208
     FILL-IN-datos AT ROW 5.27 COL 114.57 COLON-ALIGNED NO-LABEL WIDGET-ID 138
     FILL-IN-placa AT ROW 6.35 COL 132 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-placa-2 AT ROW 6.38 COL 163.14 COLON-ALIGNED WIDGET-ID 158
     FILL-IN_Marca AT ROW 7.23 COL 125.72 COLON-ALIGNED WIDGET-ID 10
     FILL-IN_Marca-2 AT ROW 7.23 COL 163.14 COLON-ALIGNED WIDGET-ID 160
     FILL-IN_Carga-2 AT ROW 8.08 COL 169.29 COLON-ALIGNED WIDGET-ID 162
     FILL-IN_Carga AT ROW 8.12 COL 132.86 COLON-ALIGNED WIDGET-ID 14
     FILL-IN_Libre_d01-2 AT ROW 8.92 COL 169.29 COLON-ALIGNED WIDGET-ID 164
     FILL-IN_Libre_d01 AT ROW 8.96 COL 132.86 COLON-ALIGNED WIDGET-ID 20
     FILL-IN_Libre_c02-2 AT ROW 9.77 COL 169.29 COLON-ALIGNED WIDGET-ID 166
     FILL-IN_Libre_c02 AT ROW 9.81 COL 132.86 COLON-ALIGNED WIDGET-ID 16
     FILL-IN_Libre_c04-2 AT ROW 10.62 COL 169.29 COLON-ALIGNED WIDGET-ID 168
     FILL-IN_Libre_c04 AT ROW 10.65 COL 132.86 COLON-ALIGNED WIDGET-ID 18
     RADIO-SET_libre_d02-2 AT ROW 11.5 COL 174.72 NO-LABEL WIDGET-ID 170
     RADIO-SET_libre_d02 AT ROW 11.54 COL 136.29 NO-LABEL WIDGET-ID 24
     FILL-IN_tarjeta-circulacion AT ROW 12.35 COL 132.86 COLON-ALIGNED WIDGET-ID 180
     FILL-IN_tarjeta-circulacion-2 AT ROW 12.35 COL 168.86 COLON-ALIGNED WIDGET-ID 182
     FILL-IN_CodPro AT ROW 13.54 COL 130 COLON-ALIGNED HELP
          "C¢digo del Proveedor" WIDGET-ID 12
     FILL-IN_Ruc AT ROW 13.54 COL 154 COLON-ALIGNED HELP
          "Ruc del Proveedor" WIDGET-ID 66
     BROWSE-9 AT ROW 13.81 COL 1.57 WIDGET-ID 300
     FILL-IN_NomPro AT ROW 14.42 COL 123.57 COLON-ALIGNED HELP
          "Nombre del Proveedor" WIDGET-ID 64
     RADIO-SET_libre_d01a AT ROW 15.35 COL 136.14 NO-LABEL WIDGET-ID 68
     RADIO-SET-transbordo AT ROW 16.04 COL 172.43 NO-LABEL WIDGET-ID 210
     FILL-IN-brevete AT ROW 16.77 COL 129.72 COLON-ALIGNED WIDGET-ID 146
     FILL-IN-DNI AT ROW 16.77 COL 149.43 COLON-ALIGNED WIDGET-ID 148
     FILL-IN-nombre AT ROW 17.65 COL 129.72 COLON-ALIGNED WIDGET-ID 150
     FILL-IN-apellido AT ROW 18.5 COL 129.72 COLON-ALIGNED WIDGET-ID 152
     FILL-IN-brevetevcto AT ROW 19.35 COL 129.72 COLON-ALIGNED WIDGET-ID 154
     FILL-IN-entrega AT ROW 19.35 COL 171 COLON-ALIGNED WIDGET-ID 156
     COMBO-BOX-series-salidas AT ROW 20.77 COL 136.57 COLON-ALIGNED WIDGET-ID 6
     COMBO-BOX-series AT ROW 20.77 COL 160.57 COLON-ALIGNED WIDGET-ID 2
     BUTTON-2 AT ROW 22.19 COL 124 WIDGET-ID 140
     FILL-IN-peso AT ROW 23.81 COL 135 COLON-ALIGNED WIDGET-ID 142
     "Transbordo" VIEW-AS TEXT
          SIZE 9.57 BY .5 AT ROW 15.35 COL 174.43 WIDGET-ID 214
          FGCOLOR 9 FONT 6
     " [ filtros ]" VIEW-AS TEXT
          SIZE 13 BY .54 AT ROW 2.35 COL 140 WIDGET-ID 204
          BGCOLOR 15 FGCOLOR 12 
     "(privado = propio, publico = tercero)" VIEW-AS TEXT
          SIZE 25 BY .65 AT ROW 16 COL 135 WIDGET-ID 134
          FGCOLOR 9 FONT 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 187.86 BY 24
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "¿Es categoria M1 o L?" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 11.73 COL 154.57 WIDGET-ID 174
          FGCOLOR 9 FONT 6
     "¿Es categoria M1 o L?" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 11.77 COL 116.72 WIDGET-ID 62
          FGCOLOR 9 FONT 6
     "Modalidad traslado :" VIEW-AS TEXT
          SIZE 13.72 BY .81 AT ROW 15.27 COL 134.44 RIGHT-ALIGNED WIDGET-ID 132
     RECT-10 AT ROW 13.46 COL 116 WIDGET-ID 136
     RECT-11 AT ROW 6.19 COL 116 WIDGET-ID 176
     RECT-12 AT ROW 6.19 COL 151.72 WIDGET-ID 178
     RECT-14 AT ROW 2.62 COL 115.43 WIDGET-ID 202
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 187.86 BY 24
         FONT 4 WIDGET-ID 100.


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
         WIDTH              = 188.29
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
/* BROWSE-TAB BROWSE-9 FILL-IN_Ruc F-Main */
ASSIGN 
       BROWSE-2:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* SETTINGS FOR COMBO-BOX COMBO-BOX-series IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       COMBO-BOX-series:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR COMBO-BOX COMBO-BOX-series-salidas IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       COMBO-BOX-series-salidas:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-apellido IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-brevetevcto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-datos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DNI IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-nombre IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-orden IN FRAME F-Main
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-peso IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-phr IN FRAME F-Main
   ALIGN-R                                                              */
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
/* SETTINGS FOR TEXT-LITERAL "Modalidad traslado :"
          SIZE 13.72 BY .81 AT ROW 15.27 COL 134.44 RIGHT-ALIGNED       */

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.gre_header_disponibles"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.gre_header_disponibles.fechaEmisionGuia|no,Temp-Tables.gre_header_disponibles.horaEmisionGuia|no"
     _Where[1]         = "(gre_header_disponibles.m_cco = """") and
((cNroPHR = """" or gre_header_disponibles.nombrePuertoAeropuerto = cNroPHR) and
(cTipoOrden = '<Todos>' or gre_header_disponibles.correoRemitente = cTipoOrden) and
(cNroOrden = """" or gre_header_disponibles.correoDestinatario = cNroOrden))"
     _FldNameList[1]   > Temp-Tables.gre_header_disponibles.ncorrelatio
"gre_header_disponibles.ncorrelatio" "Nro ! PGRE" ">>>>>>>>9" "int64" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.gre_header_disponibles.fechaEmisionGuia
"gre_header_disponibles.fechaEmisionGuia" "Fecha!Emsion" ? "date" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.gre_header_disponibles.horaEmisionGuia
"gre_header_disponibles.horaEmisionGuia" "Hora!Emision" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.gre_header_disponibles.correoRemitente
"gre_header_disponibles.correoRemitente" "Cod!Orden" "x(5)" "character" 15 9 ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.gre_header_disponibles.correoDestinatario
"gre_header_disponibles.correoDestinatario" "Nro!Orden" "x(15)" "character" 15 9 ? ? ? ? no ? no no "10.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.gre_header_disponibles.nombrePuertoAeropuerto
"gre_header_disponibles.nombrePuertoAeropuerto" "PHR" "x(10)" "character" 15 9 ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.gre_header_disponibles.m_coddoc
"gre_header_disponibles.m_coddoc" "Tipo!Docto" ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.gre_header_disponibles.m_nroser
"gre_header_disponibles.m_nroser" "Serie" "999" "integer" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.gre_header_disponibles.m_nrodoc
"gre_header_disponibles.m_nrodoc" "Numero" "99999999" "integer" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.gre_header_disponibles.motivoTraslado
"gre_header_disponibles.motivoTraslado" "Cod.!Mtvo" ? "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.gre_header_disponibles.descripcionMotivoTraslado
"gre_header_disponibles.descripcionMotivoTraslado" "Descripcion motivo!traslado" "x(50)" "character" ? ? ? ? ? ? no ? no no "22.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.gre_header_disponibles.razonSocialDestinatario
"gre_header_disponibles.razonSocialDestinatario" "Destinatario" "x(80)" "character" ? ? ? ? ? ? no ? no no "33.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.gre_header_disponibles.direccionPtoLlegada
"gre_header_disponibles.direccionPtoLlegada" "Punto de llegada" "x(100)" "character" ? ? ? ? ? ? no ? no no "34.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-9
/* Query rebuild information for BROWSE BROWSE-9
     _TblList          = "Temp-Tables.gre_header_seleccionados"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.gre_header_seleccionados.fechaEmisionGuia|no,Temp-Tables.gre_header_seleccionados.horaEmisionGuia|no"
     _Where[1]         = "gre_header_seleccionados.m_cco = ""OK"""
     _FldNameList[1]   > Temp-Tables.gre_header_seleccionados.ncorrelatio
"gre_header_seleccionados.ncorrelatio" "Nro. !PGRE" ">>>>>>>>9" "int64" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.gre_header_seleccionados.fechaEmisionGuia
"gre_header_seleccionados.fechaEmisionGuia" "Fecha!Emision" ? "date" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.gre_header_seleccionados.horaEmisionGuia
"gre_header_seleccionados.horaEmisionGuia" "Hora!Emision" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.gre_header_seleccionados.correoRemitente
"gre_header_seleccionados.correoRemitente" "Cod!Orden" "x(6)" "character" 15 9 ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.gre_header_seleccionados.correoDestinatario
"gre_header_seleccionados.correoDestinatario" "Nro!Orden" "x(15)" "character" 15 9 ? ? ? ? no ? no no "10.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.gre_header_seleccionados.nombrePuertoAeropuerto
"gre_header_seleccionados.nombrePuertoAeropuerto" "PHR" "x(10)" "character" 15 9 ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.gre_header_seleccionados.m_coddoc
"gre_header_seleccionados.m_coddoc" "Tipo!Docto" ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.gre_header_seleccionados.m_nroser
"gre_header_seleccionados.m_nroser" "Serie" "999" "integer" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.gre_header_seleccionados.m_nrodoc
"gre_header_seleccionados.m_nrodoc" "Numero" "99999999" "integer" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.gre_header_seleccionados.motivoTraslado
"gre_header_seleccionados.motivoTraslado" "Cod.!Mtvo" ? "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.gre_header_seleccionados.descripcionMotivoTraslado
"gre_header_seleccionados.descripcionMotivoTraslado" "Descripcion Motivo!Traslado" ? "character" ? ? ? ? ? ? no ? no no "22.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.gre_header_seleccionados.razonSocialDestinatario
"gre_header_seleccionados.razonSocialDestinatario" "Destinatario" "x(80)" "character" ? ? ? ? ? ? no ? no no "33.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.gre_header_seleccionados.direccionPtoLlegada
"gre_header_seleccionados.direccionPtoLlegada" "Direccion de llegada" "x(100)" "character" ? ? ? ? ? ? no ? no no "36" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-9 */
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
ON MOUSE-SELECT-DBLCLICK OF BROWSE-2 IN FRAME F-Main /* PRE-GUIAS DE REMISION DISPONIBLES */
DO:
    DEFINE VARIABLE iRowHeight   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iLastY       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iRow         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE hCell        AS HANDLE      NO-UNDO.
    DEFINE VARIABLE iTopRowY     AS INTEGER     NO-UNDO.
    DEFINE VAR cRetVal AS CHAR.
    
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

        RUN pgre-es_valida(gre_header_disponibles.ncorrelatio, OUTPUT cRetVal).
        IF RETURN-VALUE <> "OK" THEN DO:
            MESSAGE cRetVal VIEW-AS ALERT-BOX INFORMATION.
            RETURN NO-APPLY.
        END.

        FIND FIRST gre_header_seleccionados WHERE gre_header_seleccionados.ncorrelatio = gre_header_disponibles.ncorrelatio
                      EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE gre_header_seleccionados THEN DO:
              ASSIGN gre_header_seleccionados.m_cco = "OK".              
              /**/
              ASSIGN gre_header_disponibles.m_cco = "SELE".
              

            dPesoTotal = dPesoTotal + gre_header_seleccionados.pesoBrutoTotalBienes.
            RUN show_totales.

              {&open-query-browse-2}
              {&open-query-browse-9}
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
ON START-SEARCH OF BROWSE-2 IN FRAME F-Main /* PRE-GUIAS DE REMISION DISPONIBLES */
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


&Scoped-define BROWSE-NAME BROWSE-9
&Scoped-define SELF-NAME BROWSE-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-9 W-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-9 IN FRAME F-Main /* PRE-GUIAS SELECCIONADAS PARA ASIGNARLE TRANSPORTISTA */
DO:
    /*
  FIND FIRST gre_header_disponibles WHERE gre_header_disponibles.ncorrelatio = gre_header_seleccionados.ncorrelatio
                EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE gre_header_disponibles THEN DO:
        ASSIGN gre_header_disponibles.m_cco = "".
        ASSIGN gre_header_seleccionados.m_cco = "NO".

        dPesoTotal = dPesoTotal - gre_header_disponibles.pesoBrutoTotalBienes.
        RUN show_totales.
  END.

  {&open-query-browse-2}
  {&open-query-browse-9}    
      */
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
        
        FIND FIRST gre_header_disponibles WHERE gre_header_disponibles.ncorrelatio = gre_header_seleccionados.ncorrelatio
                      EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE gre_header_disponibles THEN DO:
              ASSIGN gre_header_disponibles.m_cco = "".
              ASSIGN gre_header_seleccionados.m_cco = "NO".

            dPesoTotal = dPesoTotal - gre_header_disponibles.pesoBrutoTotalBienes.
            RUN show_totales.

              {&open-query-browse-2}
              {&open-query-browse-9}
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
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Grabar transportista y dejar listo para envio a SUNAT */
DO:

 APPLY 'LEAVE':U TO FILL-IN-placa-2.
 APPLY 'LEAVE':U TO FILL-IN-placa.

  RUN grabar-info-movilidad.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* ( Seleccionar mas de uno) >>>... */
DO:
  RUN seleccion-masiva.
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
                                    vtatabla.tabla = "BREVETE" AND
                                    vtatabla.llave_c1 = fill-in-brevete NO-LOCK NO-ERROR.
        IF fill-in-brevete > "" AND AVAILABLE vtatabla THEN DO:
            ASSIGN fill-in-dni:SCREEN-VALUE = vtatabla.llave_c2
                    fill-in-nombre:SCREEN-VALUE = vtatabla.libre_c03
                    fill-in-apellido:SCREEN-VALUE = TRIM(vtatabla.libre_c01) + " " + trim(vtatabla.libre_c02)
                    FILL-IN-brevetevcto:SCREEN-VALUE = STRING(vtatabla.rango_fecha[1],"99/99/9999") 
                .
        END.
        ELSE DO:
            MESSAGE "El brevete no esta registrado"
                    VIEW-AS ALERT-BOX INFORMATION.
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


&Scoped-define BROWSE-NAME BROWSE-2
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
    FILL-IN_tarjeta-circulacion:SCREEN-VALUE = ""
    FILL-IN_carga:SCREEN-VALUE = ""
    radio-set_libre_d01a:SCREEN-VALUE = "".
    
    /* Vehiculo Principal */
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
            FILL-IN_tarjeta-circulacion:SCREEN-VALUE = gn-vehic.tipo
            FILL-IN_carga:SCREEN-VALUE = string(gn-vehic.carga)
            radio-set_libre_d02:SCREEN-VALUE = string(gn-vehic.libre_d02)
            fill-in_ruc:SCREEN-VALUE = gn-prov.ruc
            FILL-IN_nompro:SCREEN-VALUE = gn-prov.nompro
            radio-set_libre_d01a:SCREEN-VALUE = string(gn-prov.libre_d01).

        END.
        ELSE DO:
            MESSAGE "La placa princiap del vehiculo no pertenece"
                    "a niguna empresa de transporte"
                VIEW-AS ALERT-BOX INFORMATION.
        END.
    END.
    ELSE DO:
        MESSAGE "Placa princiapl del vehiculo no existe"
            VIEW-AS ALERT-BOX INFORMATION.
    END.
    
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE datos-del-transportista-2 W-Win 
PROCEDURE datos-del-transportista-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fill-in-placa-2 FILL-IN_codpro fill-in_ruc fill-in-placa.

    ASSIGN fill-in_marca-2:SCREEN-VALUE = ""
    FILL-IN_libre_d01-2:SCREEN-VALUE = ""
    FILL-IN_libre_c02-2:SCREEN-VALUE = ""
    FILL-IN_libre_c04-2:SCREEN-VALUE = ""
    radio-set_libre_d02-2:SCREEN-VALUE = ""
    FILL-IN_tarjeta-circulacion-2:SCREEN-VALUE = ""
    FILL-IN_carga-2:SCREEN-VALUE = "".
    
    IF TRUE <> (fill-in-placa-2 > "") THEN DO:
        RETURN NO-APPLY.
    END.

    IF TRUE <> (fill-in-placa > "") THEN DO:
        MESSAGE "Ingrese la placa principal del vehiculo, por favor"
                VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.

    /* Placa 2 */
    FIND FIRST gn-vehic WHERE gn-vehic.codcia = s-codcia AND gn-vehic.placa = fill-in-placa-2
                    NO-LOCK NO-ERROR.
    IF AVAILABLE gn-vehic THEN DO:

        FIND FIRST gn-prov WHERE gn-prov.codcia = 0 AND gn-prov.codpro = gn-vehic.codpro
                            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN DO:
            IF FILL-IN_codpro = gn-vehic.codpro THEN DO:
                ASSIGN fill-in_marca-2:SCREEN-VALUE = gn-vehic.marca            
                FILL-IN_libre_d01-2:SCREEN-VALUE = string(gn-vehic.libre_d01)
                FILL-IN_libre_c02-2:SCREEN-VALUE = gn-vehic.libre_c02
                FILL-IN_libre_c04-2:SCREEN-VALUE = gn-vehic.libre_c04
                radio-set_libre_d02-2:SCREEN-VALUE = string(gn-vehic.libre_d02)
                FILL-IN_tarjeta-circulacion-2:SCREEN-VALUE = gn-vehic.tipo
                FILL-IN_carga-2:SCREEN-VALUE = string(gn-vehic.carga).
            END.
            ELSE DO:
                MESSAGE "El transportista de la placa 2 no es el mismo de la placa principal"
                        VIEW-AS ALERT-BOX INFORMATION.
            END.
        END.
        ELSE DO:
            MESSAGE "La placa 2 del vehiculo no pertenece"
                    "a nigun transportista"
                VIEW-AS ALERT-BOX INFORMATION.
        END.
    END.
    ELSE DO:
        MESSAGE "Placa 2 del vehiculo no existe"
            VIEW-AS ALERT-BOX INFORMATION.
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
          FILL-IN-placa FILL-IN-placa-2 FILL-IN_Marca FILL-IN_Marca-2 
          FILL-IN_Carga-2 FILL-IN_Carga FILL-IN_Libre_d01-2 FILL-IN_Libre_d01 
          FILL-IN_Libre_c02-2 FILL-IN_Libre_c02 FILL-IN_Libre_c04-2 
          FILL-IN_Libre_c04 RADIO-SET_libre_d02-2 RADIO-SET_libre_d02 
          FILL-IN_tarjeta-circulacion FILL-IN_tarjeta-circulacion-2 
          FILL-IN_CodPro FILL-IN_Ruc FILL-IN_NomPro RADIO-SET_libre_d01a 
          RADIO-SET-transbordo FILL-IN-brevete FILL-IN-DNI FILL-IN-nombre 
          FILL-IN-apellido FILL-IN-brevetevcto FILL-IN-entrega FILL-IN-peso 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-10 RECT-11 RECT-12 RECT-14 BROWSE-2 BUTTON-1 BUTTON-3 FILL-IN-phr 
         COMBO-BOX-tipoorden FILL-IN-orden BUTTON-filtrar BUTTON-reset-filtros 
         FILL-IN-placa FILL-IN-placa-2 BROWSE-9 RADIO-SET-transbordo 
         FILL-IN-brevete FILL-IN-entrega BUTTON-2 
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

SESSION:SET-WAIT-STATE("GENERAL").
FOR EACH gre_header WHERE gre_header.m_rspta_sunat = 'SIN ENVIAR' AND
                     gre_header.m_divorigen = s-coddiv NO-LOCK:
    CREATE gre_header_disponibles.
    BUFFER-COPY gre_header TO gre_header_disponibles.

    CREATE gre_header_seleccionados.
    BUFFER-COPY gre_header TO gre_header_seleccionados.

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
                                di-rutaD.flgest <> 'A' NO-LOCK NO-ERROR.
    IF AVAILABLE di-rutaD THEN DO:
        cNroPHR = di-rutaD.nrodoc.
    END.
    /*
    ASSIGN gre_header_disponibles.nombrePuertoAeropuerto = cNroPHR.
    ASSIGN gre_header_seleccionados.nombrePuertoAeropuerto = cNroPHR.
    */
    /* Campos de ayuda nada mas */
    ASSIGN gre_header_disponibles.nombrePuertoAeropuerto = cNroPHR.

    ASSIGN gre_header_disponibles.correoRemitente = cCodRef         /* O/D */
            gre_header_disponibles.correoDestinatario = cNroRef.    /* Nro O/D */
    IF gre_header.m_coddoc = 'OTR' THEN DO:
        ASSIGN gre_header_disponibles.correoremitente = gre_header.m_coddoc     /* OTR */
                gre_header_disponibles.correoDestinatario = STRING(gre_header.m_nroser,"999") + STRING(gre_header.m_nrodoc,"999999").   /* Nro OTR */
    END.
END.
SESSION:SET-WAIT-STATE("").

{&open-query-browse-2}
{&open-query-browse-9}

dPesoTotal = 0.

APPLY 'CHOOSE':U TO button-filtrar IN FRAME {&FRAME-NAME}.

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
/*
FOR EACH gre_header WHERE gre_header.m_rspta_sunat = 'SIN ENVIAR' AND
                     gre_header.m_divorigen = s-coddiv NO-LOCK:
                     
    modalidadTraslado
    fechaInicioTraslado
    indRetornoVehiculoEnvaseVacio
    fechaEntregaBienes
    indTrasVehiculoCatM1L
    indRetornoVehiculoVacio
    numeroRucTransportista
    tipoDocumentoTransportista
    RazonSocialTransportista
    numeroRegistroMTC 
    
    numeroPlacaVehiculoPrin
    tarjetaUnicaCirculacion
    numeroPlacaVehiculoSec1
    tarjetaUnicaCirculacionSec1
    
    numeroDocumentoConductor
    tipoDocumentoConductor
    nombreConductor
    apellidoConductor
    numeroLicencia
*/

DEFINE VAR iCorrelativo AS INT.
DEFINE VAR cRetVal AS CHAR.

RUN gre/correlativo-salida-vehiculo.r(OUTPUT iCorrelativo).
IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "PROBLEMAS AL CREAR EL CORRELATIVO DE PRE-GRE".

DEFINE VAR iCuantos AS INT.                          
                          
SESSION:SET-WAIT-STATE("GENERAL").

DO TRANSACTION ON ERROR UNDO, LEAVE:
    DO:
        /* Placa principal */
        CREATE gre_vehiculo_hdr.
            ASSIGN gre_vehiculo_hdr.ncorrelativo = iCorrelativo
                    gre_vehiculo_hdr.fsalida = fill-in-entrega
                    gre_vehiculo_hdr.pesototal = FILL-IN-peso
                    gre_vehiculo_hdr.placa = fill-in-placa
                    gre_vehiculo_hdr.marca = fill-in_marca
                    gre_vehiculo_hdr.cargamaxima = fill-in_carga
                    gre_vehiculo_hdr.capacidadmax = FILL-IN_libre_d01   /* es capacidad minima */
                    gre_vehiculo_hdr.tonelaje = FILL-IN_libre_c02 
                    gre_vehiculo_hdr.registroMTC = FILL-IN_libre_c04
                    gre_vehiculo_hdr.catvehM1L = IF(RADIO-SET_libre_d02 = 1) THEN YES ELSE NO
                    gre_vehiculo_hdr.codtransportista = FILL-IN_codpro
                    gre_vehiculo_hdr.transp_razonsocial = FILL-IN_nompro
                    gre_vehiculo_hdr.transp_ruc = FILL-IN_ruc
                    gre_vehiculo_hdr.transp_modalidad = RADIO-SET_libre_d01a
                    gre_vehiculo_hdr.brevete = fill-in-brevete
                    gre_vehiculo_hdr.chofer_dni = fill-in-dni
                    gre_vehiculo_hdr.chofer_nombre = fill-in-nombre
                    gre_vehiculo_hdr.chofer_apellidos = fill-in-apellido
                    gre_vehiculo_hdr.chofer_vctobrevete = fill-in-brevetevcto
                    gre_vehiculo_hdr.coddiv = s-coddiv
                    gre_vehiculo_hdr.usercrea = USERID("DICTDB").

        IF NOT (TRUE <> (fill-in-placa-2 > "")) THEN DO:
            /* Placa 2 */
            CREATE gre_vehiculo_hdr.
                ASSIGN gre_vehiculo_hdr.ncorrelativo = iCorrelativo
                        gre_vehiculo_hdr.fsalida = fill-in-entrega
                        gre_vehiculo_hdr.pesototal = FILL-IN-peso
                        gre_vehiculo_hdr.placa = fill-in-placa-2
                        gre_vehiculo_hdr.marca = fill-in_marca-2
                        gre_vehiculo_hdr.cargamaxima = fill-in_carga-2
                        gre_vehiculo_hdr.capacidadmax = FILL-IN_libre_d01-2   /* es capacidad minima */
                        gre_vehiculo_hdr.tonelaje = FILL-IN_libre_c02-2 
                        gre_vehiculo_hdr.registroMTC = FILL-IN_libre_c04-2
                        gre_vehiculo_hdr.catvehM1L = IF(RADIO-SET_libre_d02-2 = 1) THEN YES ELSE NO
                        gre_vehiculo_hdr.codtransportista = FILL-IN_codpro
                        gre_vehiculo_hdr.transp_razonsocial = FILL-IN_nompro
                        gre_vehiculo_hdr.transp_ruc = FILL-IN_ruc
                        gre_vehiculo_hdr.transp_modalidad = RADIO-SET_libre_d01a
                        gre_vehiculo_hdr.brevete = fill-in-brevete
                        gre_vehiculo_hdr.chofer_dni = fill-in-dni
                        gre_vehiculo_hdr.chofer_nombre = fill-in-nombre
                        gre_vehiculo_hdr.chofer_apellidos = fill-in-apellido
                        gre_vehiculo_hdr.chofer_vctobrevete = fill-in-brevetevcto
                        gre_vehiculo_hdr.coddiv = s-coddiv
                        gre_vehiculo_hdr.usercrea = USERID("DICTDB").
        END.
    END.

    FOR EACH gre_header_seleccionados WHERE gre_header_seleccionados.m_cco = "OK" NO-LOCK ON ERROR UNDO, THROW:

        /**/
        RUN pgre-es_valida(gre_header_seleccionados.ncorrelatio, OUTPUT cRetVal).
        IF cRetVal <> 'OK' THEN NEXT.

        FIND FIRST b-gre_header WHERE b-gre_header.ncorrelatio = gre_header_seleccionados.ncorrelatio EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE b-gre_header AND b-gre_header.m_rspta_sunat = 'SIN ENVIAR' THEN DO:

            ASSIGN b-gre_header.modalidadTraslado = string(RADIO-SET_libre_d01a,"99")
                b-gre_header.numeroRucTransportista = FILL-IN_ruc
                b-gre_header.tipoDocumentoTransportista = "6"
                b-gre_header.RazonSocialTransportista = FILL-IN_nompro
                b-gre_header.numeroRegistroMTC = FILL-IN_libre_c04
                b-gre_header.indTrasVehiculoCatM1L = IF (RADIO-SET_libre_d02 = 1) THEN YES ELSE NO
                b-gre_header.numeroPlacaVehiculoPrin = fill-in-placa
                b-gre_header.numeroPlacaVehiculoSec1 = fill-in-placa-2
                b-gre_header.numeroDocumentoConductor = fill-in-dni
                b-gre_header.tipoDocumentoConductor = '1'
                b-gre_header.nombreConductor = fill-in-nombre
                b-gre_header.apellidoConductor = fill-in-apellido
                b-gre_header.numeroLicencia = fill-in-brevete
                b-gre_header.m_rspta_sunat = 'CON TRANSPORTISTA' 
                b-gre_header.correlativo_vehiculo = iCorrelativo
                b-gre_header.fechahora_asigna_vehiculo = NOW
                b-gre_header.USER_asigna_vehiculo = USERID("DICTDB")
                b-gre_header.indTransbordoProgramado = radio-set-transbordo /* Se quedo con MAX que siempre sea programado, se cambio x reclamo de cliente 03Ago2023 */
                b-gre_header.fechaInicioTraslado = FILL-in-entrega.
                b-gre_header.fechaEntregaBienes = FILL-in-entrega.

            CREATE gre_vehiculo_dtl.
                ASSIGN gre_vehiculo_dtl.ncorrelativo = iCorrelativo
                        gre_vehiculo_dtl.gre_correlativo = b-gre_header.ncorrelatio
                        gre_vehiculo_dtl.fsalida = gre_vehiculo_hdr.fsalida
                    .
            ASSIGN gre_header_seleccionados.m_cco = "PROCESADO".  /* Para q no pinte en pantalla */

            IF RADIO-SET_libre_d01a = 1 THEN DO:
                /* Transporte Publico - tarjeta de circulacion */
                ASSIGN b-gre_header.tarjetaUnicaCirculacionPri = FILL-IN_tarjeta-circulacion
                        b-gre_header.tarjetaUnicaCirculacionSec1 = FILL-IN_tarjeta-circulacion-2.

            END.
            iCuantos = iCuantos + 1.
        END.
        RELEASE b-gre_header NO-ERROR.
    END.
    IF iCuantos <= 0 THEN DO:
        UNDO.
    END.

END. /* TRANSACTION block */


RELEASE b-gre_header NO-ERROR.
RELEASE gre_vehiculo_hdr NO-ERROR.
RELEASE gre_vehiculo_dtl NO-ERROR.

{&open-query-browse-2}
{&open-query-browse-9}

RUN reset-datos-transporte.

SESSION:SET-WAIT-STATE("").

MESSAGE "Se grabaron " STRING(iCuantos) " documentos" 
    VIEW-AS ALERT-BOX INFORMATION.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-info-movilidad W-Win 
PROCEDURE grabar-info-movilidad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR iDiasParaInicioDeTraslado AS INT NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fill-in-placa fill-in_marca fill-in_carga FILL-IN_libre_d01 FILL-IN_libre_c02 radio-set-transbordo
        FILL-IN_libre_c04 RADIO-SET_libre_d02 FILL-IN_carga-2 FILL-IN_tarjeta-circulacion.

    ASSIGN FILL-IN_codpro FILL-IN_ruc FILL-IN_nompro RADIO-SET_libre_d01a.         
    ASSIGN fill-in-brevete  fill-in-dni fill-in-nombre fill-in-apellido fill-in-brevetevcto.
    ASSIGN fill-in-peso fill-in-entrega.

    ASSIGN fill-in-placa-2 fill-in_marca-2 fill-in_carga-2 FILL-IN_libre_d01-2 FILL-IN_libre_c02-2 
        FILL-IN_libre_c04-2 RADIO-SET_libre_d02-2 FILL-IN_carga-2 FILL-IN_tarjeta-circulacion-2.

    DEFINE VAR x-fecha-entrega AS DATE.
    
    FIND FIRST gn-vehic WHERE gn-vehic.codcia = s-codcia AND gn-vehic.placa = fill-in-placa
                    NO-LOCK NO-ERROR.
    IF fill-in-placa > "" AND AVAILABLE gn-vehic THEN DO:

        IF fill-in-placa-2 > "" THEN DO:
            IF fill-in-placa-2 = fill-in-placa THEN DO:
                MESSAGE "Las placas NO deben ser iguales" SKIP
                        "imposible continuar"
                    VIEW-AS ALERT-BOX INFORMATION.
                RETURN "ADM-ERROR".
            END.

            FIND FIRST gn-vehic WHERE gn-vehic.codcia = s-codcia AND gn-vehic.placa = fill-in-placa-2
                            NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-vehic THEN DO:
                MESSAGE "La placa 2 no existe... " SKIP
                        "imposible continuar"
                    VIEW-AS ALERT-BOX INFORMATION.
                RETURN "ADM-ERROR".
            END.
            IF gn-vehic.libre_c05 <> 'SI' THEN DO:
                MESSAGE "La placa 2 del vehiculo no esta ACTIVO" SKIP
                        "imposible continuar"
                    VIEW-AS ALERT-BOX INFORMATION.
                RETURN "ADM-ERROR".
            END.
            IF FILL-IN_libre_c02-2 > "2TN" THEN DO:
                IF TRUE <> (FILL-IN_libre_c04-2 > "") THEN DO:
                    MESSAGE "La placa 2 con capacidad de mas de 2TN requiere" SKIP
                            "registro del MTC"
                        VIEW-AS ALERT-BOX INFORMATION.
                    RETURN "ADM-ERROR".
                END.
            END.
            IF FILL-IN_codpro <> gn-vehic.codpro THEN DO:
                MESSAGE "La placa principal y la placa 2 del vehiculo no pertencen al mismo transportista" SKIP
                        "imposible continuar"
                    VIEW-AS ALERT-BOX INFORMATION.
                RETURN "ADM-ERROR".
            END.
            IF RADIO-SET_libre_d02-2 <> RADIO-SET_libre_d02 THEN DO:
                MESSAGE "La placa principal y la placa 2 deben ser de la misma categoria" SKIP
                        "imposible continuar"
                    VIEW-AS ALERT-BOX INFORMATION.
                RETURN "ADM-ERROR".
            END.
        END.

        FIND FIRST gn-vehic WHERE gn-vehic.codcia = s-codcia AND gn-vehic.placa = fill-in-placa
                        NO-LOCK NO-ERROR.
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
                                            vtatabla.tabla = "BREVETE" AND
                                            vtatabla.llave_c1 = fill-in-brevete NO-LOCK NO-ERROR.
                IF fill-in-brevete = "" OR NOT AVAILABLE vtatabla THEN DO:
                    MESSAGE "Brevete no existe..." SKIP
                            "imposible continuar"
                        VIEW-AS ALERT-BOX INFORMATION.
                    RETURN "ADM-ERROR".
                END.
                IF LENGTH(fill-in-brevete) < 9 THEN DO:
                    MESSAGE "El Numero de licencia del conductor no cumple con el formato establecido" SKIP
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

            IF FILL-in-entrega:VISIBLE THEN DO:
               x-fecha-entrega = DATE(FILL-in-entrega:SCREEN-VALUE) NO-ERROR.
               IF x-fecha-entrega = ? THEN DO:
                   MESSAGE "Debe ingresar fecha de inicio de traslado" SKIP
                           "imposible continuar"
                       VIEW-AS ALERT-BOX INFORMATION.
                   RETURN "ADM-ERROR".
               END.
               IF x-fecha-entrega < TODAY THEN DO:
                   MESSAGE "Fecha de inicio de traslado debe ser mayor/igual al dia de hoy" SKIP
                           "imposible continuar"
                       VIEW-AS ALERT-BOX INFORMATION.
                   RETURN "ADM-ERROR".
               END.

               /* -----------------*/
               iDiasParaInicioDeTraslado = INTERVAL(x-fecha-entrega,TODAY,'days').

               IF iDiasParaInicioDeTraslado > iMaximoDiasInicioTrasladoPGRE THEN DO:
                   MESSAGE "Fecha de inicio de traslado esta incorrecta" SKIP
                            "el maximo dias para el inicio del traslado es(" + string(iMaximoDiasInicioTrasladoPGRE) + ")" SKIP
                           "imposible continuar"
                       VIEW-AS ALERT-BOX INFORMATION.
                   RETURN "ADM-ERROR".
               END.
            END.

            /* Se procede a grabar */
            RUN grabar-data.

        END.
        ELSE DO:
            MESSAGE "La placa principal del vehiculo ingresado no pertenece a ninguna" SKIP
                    "empresa de transporte...por favor verificar"
                VIEW-AS ALERT-BOX INFORMATION.
            RETURN "ADM-ERROR".
        END.
    END.
    ELSE DO:
        MESSAGE "Debe ingresar la placa principal del vehiculo correctamente"
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

  DO WITH FRAME {&FRAME-NAME}:
      /*FILL-in-entrega:VISIBLE = NO.*/
  END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pgre-es_valida W-Win 
PROCEDURE pgre-es_valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER piPGRE AS INT NO-UNDO.
DEFINE OUTPUT PARAMETER pcRetVal AS CHAR NO-UNDO.

DEFINE VAR dFechaEmisionPGRE AS DATE.
DEFINE VAR iDiasAntiguedadPGRE AS INT.

pcRetVal = 'OK'.
/* Se vuelve a validar iDiasAntiguedadPGRE */
FIND FIRST x-gre_header WHERE x-gre_header.ncorrelatio = piPGRE NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-gre_header THEN DO:
    pcRetVal = "La PGRE(" + STRING(x-gre_header.ncorrelatio) + ") no existe".
    RETURN "ADM-ERROR".
END.
IF x-gre_header.m_rspta_sunat <> 'SIN ENVIAR' THEN DO:
    pcRetVal = "La PGRE(" + STRING(x-gre_header.ncorrelatio) + ") no tiene el estado correcto : SIN ENVIAR".
    RETURN "ADM-ERROR".
END.

dFechaEmisionPGRE = DATE(x-gre_header.m_fechahorareg).
iDiasAntiguedadPGRE = INTERVAL(TODAY,dFechaEmisionPGRE,'days').

IF iDiasAntiguedadPGRE > iMaximoDiasAntiguedadPGRE THEN DO:
    pcRetVal = "La PGRE(" + STRING(x-gre_header.ncorrelatio) + ") es demasiado antiguo(" + STRING(iDiasAntiguedadPGRE) + " dias), " +
                "el maximo de dias de antiguedad es(" + STRING(iMaximoDiasAntiguedadPGRE) + " dias)".
    RETURN "ADM-ERROR".
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reset-datos-transporte W-Win 
PROCEDURE reset-datos-transporte :
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
END.

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

DEFINE VAR rRowId AS ROWID.
DEFINE VAR iCorrelativo AS INT.
DEFINE VAR iRowsSelected AS INT.
DEFINE VAR iRow AS INT.
DEFINE VAR cRetVal AS CHAR.

DO WITH FRAME {&FRAME-NAME}:
    iRowsSelected = browse-2:NUM-SELECTED-ROWS.

    IF iRowsSelected > 1 THEN DO:
        SESSION:SET-WAIT-STA("GENERAL").
        DO iRow = 1 TO iRowsSelected :
            IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(iRow) THEN DO:

                iCorrelativo = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nCorrelatio.

                RUN pgre-es_valida(iCorrelativo, OUTPUT cRetVal).
                IF RETURN-VALUE = "OK" THEN DO:
                    FIND FIRST gre_header_seleccionados WHERE gre_header_seleccionados.ncorrelatio = gre_header_disponibles.ncorrelatio
                                  EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAILABLE gre_header_seleccionados THEN DO:
                        ASSIGN gre_header_disponibles.m_cco = "SELE".
                        ASSIGN gre_header_seleccionados.m_cco = "OK".

                        dPesoTotal = dPesoTotal + gre_header_seleccionados.pesoBrutoTotalBienes.
                    END.
                END.
            END.
        END.
        RUN show_totales.

          {&open-query-browse-2}
          {&open-query-browse-9}

        SESSION:SET-WAIT-STA("").

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
  {src/adm/template/snd-list.i "gre_header_seleccionados"}
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
    fill-in-peso:SCREEN-VALUE = STRING(dPesoTotal,">,>>>,>>9.99").
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

