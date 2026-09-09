&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
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

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

DEF SHARED VAR S-CODCIA AS INT.
DEF SHARED VAR cb-codcia AS INT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES GN-DIVI
&Scoped-define FIRST-EXTERNAL-TABLE GN-DIVI


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR GN-DIVI.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS GN-DIVI.Libre_f01 GN-DIVI.CodDiv ~
GN-DIVI.Campo-Char[1] GN-DIVI.Campo-Log[10] GN-DIVI.Campo-Log[1] ~
GN-DIVI.Campo-Log[7] GN-DIVI.Campo-Char[7] GN-DIVI.DesDiv ~
GN-DIVI.Campo-Char[3] GN-DIVI.DirDiv GN-DIVI.Respon GN-DIVI.Campo-Char[4] ~
GN-DIVI.TelDiv GN-DIVI.Campo-Char[10] GN-DIVI.Campo-Char[5] ~
GN-DIVI.CanalVenta GN-DIVI.Grupo_Divi_GG GN-DIVI.FaxDiv ~
GN-DIVI.Centro_Costo GN-DIVI.Campo-Dec[5] GN-DIVI.DiasVtoCot ~
GN-DIVI.FlgRotacion GN-DIVI.DiasVtoPed GN-DIVI.FlgPreVta GN-DIVI.DiasVtoO_D ~
GN-DIVI.FlgEmpaque GN-DIVI.FlgMinVenta GN-DIVI.Campo-Log[4] GN-DIVI.flgrep ~
GN-DIVI.Campo-Log[9] GN-DIVI.Campo-Log[8] GN-DIVI.DiasAmpCot ~
GN-DIVI.VentaMayorista GN-DIVI.Libre_c01 GN-DIVI.FlgDtoVol ~
GN-DIVI.Campo-Log[6] GN-DIVI.Libre_L01 GN-DIVI.Campo-Dec[6] ~
GN-DIVI.FlgDtoProm GN-DIVI.Campo-Dec[7] GN-DIVI.Libre_c02 ~
GN-DIVI.FlgDtoClfCli GN-DIVI.PorDtoClfCli GN-DIVI.Libre_d01 ~
GN-DIVI.FlgDtoCndVta 
&Scoped-define ENABLED-TABLES GN-DIVI
&Scoped-define FIRST-ENABLED-TABLE GN-DIVI
&Scoped-Define ENABLED-OBJECTS RECT-46 RECT-48 RECT-51 RECT-52 RECT-53 ~
RECT-54 RECT-55 
&Scoped-Define DISPLAYED-FIELDS GN-DIVI.Libre_f01 GN-DIVI.CodDiv ~
GN-DIVI.Campo-Char[1] GN-DIVI.Campo-Log[5] GN-DIVI.Campo-Log[10] ~
GN-DIVI.Campo-Log[1] GN-DIVI.Campo-Log[7] GN-DIVI.Campo-Char[7] ~
GN-DIVI.DesDiv GN-DIVI.Campo-Char[3] GN-DIVI.DirDiv GN-DIVI.Respon ~
GN-DIVI.Campo-Char[4] GN-DIVI.TelDiv GN-DIVI.Campo-Char[10] ~
GN-DIVI.Campo-Char[5] GN-DIVI.CanalVenta GN-DIVI.Grupo_Divi_GG ~
GN-DIVI.FaxDiv GN-DIVI.Centro_Costo GN-DIVI.Campo-Dec[5] GN-DIVI.DiasVtoCot ~
GN-DIVI.FlgRotacion GN-DIVI.FlgPicking GN-DIVI.DiasVtoPed GN-DIVI.FlgPreVta ~
GN-DIVI.FlgBarras GN-DIVI.DiasVtoO_D GN-DIVI.FlgEmpaque GN-DIVI.FlgMinVenta ~
GN-DIVI.Campo-Log[4] GN-DIVI.flgrep GN-DIVI.Campo-Log[9] ~
GN-DIVI.Campo-Log[8] GN-DIVI.DiasAmpCot GN-DIVI.VentaMayorista ~
GN-DIVI.Libre_c01 GN-DIVI.FlgDtoVol GN-DIVI.Campo-Log[6] GN-DIVI.Libre_L01 ~
GN-DIVI.Campo-Dec[6] GN-DIVI.FlgDtoProm GN-DIVI.Campo-Dec[7] ~
GN-DIVI.Libre_c02 GN-DIVI.FlgDtoClfCli GN-DIVI.PorDtoClfCli ~
GN-DIVI.Libre_d01 GN-DIVI.FlgDtoCndVta 
&Scoped-define DISPLAYED-TABLES GN-DIVI
&Scoped-define FIRST-DISPLAYED-TABLE GN-DIVI
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NomDepto FILL-IN-NomProvi ~
txtDirEstablecimiento FILL-IN-NomDistr FILL-IN-Grupo_Divi_GG ~
FILL-IN-Centro_Costo FILL-IN-Usuario FILL-IN-Fecha 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-Centro_Costo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha AS CHARACTER FORMAT "X(256)":U 
     LABEL "Fecha Modif:" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Grupo_Divi_GG AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-NomDepto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomDistr AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomProvi AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Usuario AS CHARACTER FORMAT "X(256)":U 
     LABEL "Usuario Modif:" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE txtDirEstablecimiento AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 37.86 BY .81
     FGCOLOR 4  NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 153 BY 6.46.

DEFINE RECTANGLE RECT-48
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 153 BY 5.31.

DEFINE RECTANGLE RECT-51
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 153 BY 5.58.

DEFINE RECTANGLE RECT-52
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65 BY 2.12.

DEFINE RECTANGLE RECT-53
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65 BY 1.92.

DEFINE RECTANGLE RECT-54
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY 2.69.

DEFINE RECTANGLE RECT-55
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 23 BY 2.69.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     GN-DIVI.Libre_f01 AT ROW 1.19 COL 134 COLON-ALIGNED WIDGET-ID 176
          LABEL "INICIO SUNAT" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     GN-DIVI.CodDiv AT ROW 1.27 COL 12 COLON-ALIGNED WIDGET-ID 4
          LABEL "Codigo" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 9 BY 1.08
          BGCOLOR 1 FGCOLOR 14 FONT 9
     GN-DIVI.Campo-Char[1] AT ROW 1.27 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 170 FORMAT "x(8)"
          VIEW-AS COMBO-BOX INNER-LINES 3
          LIST-ITEM-PAIRS "Ambos","A",
                     "División","D",
                     "Lista de Precios","L"
          DROP-DOWN-LIST
          SIZE 30 BY 1
     GN-DIVI.Campo-Log[5] AT ROW 1.27 COL 77 WIDGET-ID 172
          LABEL "CENTRO DE DISTRIBUCION"
          VIEW-AS TOGGLE-BOX
          SIZE 29 BY .81
     GN-DIVI.Campo-Log[10] AT ROW 1.27 COL 112 WIDGET-ID 174
          LABEL "EN SUNAT"
          VIEW-AS TOGGLE-BOX
          SIZE 12 BY .81
     GN-DIVI.Campo-Log[1] AT ROW 1.54 COL 26 WIDGET-ID 166
          LABEL "INACTIVO"
          VIEW-AS TOGGLE-BOX
          SIZE 13 BY .81
     GN-DIVI.Campo-Log[7] AT ROW 2.08 COL 112 WIDGET-ID 204
          LABEL "CODIGO QR ACTIVO"
          VIEW-AS TOGGLE-BOX
          SIZE 19 BY .77
     GN-DIVI.Campo-Char[7] AT ROW 2.08 COL 129 COLON-ALIGNED NO-LABEL WIDGET-ID 206 FORMAT "x(8)"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Impresora x Programa","",
                     "Impresora x Defecto","Si"
          DROP-DOWN-LIST
          SIZE 20 BY 1
     GN-DIVI.DesDiv AT ROW 2.42 COL 12 COLON-ALIGNED WIDGET-ID 6
          LABEL "Nombre" FORMAT "X(80)"
          VIEW-AS FILL-IN 
          SIZE 87 BY .81
     GN-DIVI.Campo-Char[3] AT ROW 3.15 COL 110 COLON-ALIGNED WIDGET-ID 190
          LABEL "Departamento" FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     FILL-IN-NomDepto AT ROW 3.15 COL 116 COLON-ALIGNED NO-LABEL WIDGET-ID 196
     GN-DIVI.DirDiv AT ROW 3.19 COL 12 COLON-ALIGNED WIDGET-ID 8 FORMAT "X(100)"
          VIEW-AS FILL-IN 
          SIZE 87 BY .81
     GN-DIVI.Respon AT ROW 3.96 COL 12 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 77 BY .81
     GN-DIVI.Campo-Char[4] AT ROW 3.96 COL 110 COLON-ALIGNED WIDGET-ID 192
          LABEL "Provincia" FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     FILL-IN-NomProvi AT ROW 3.96 COL 116 COLON-ALIGNED NO-LABEL WIDGET-ID 198
     GN-DIVI.TelDiv AT ROW 4.73 COL 12 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 17 BY .81
     GN-DIVI.Campo-Char[10] AT ROW 4.77 COL 54 COLON-ALIGNED NO-LABEL WIDGET-ID 208 FORMAT "X(4)"
          VIEW-AS FILL-IN 
          SIZE 7.57 BY .92
          FGCOLOR 4 FONT 11
     txtDirEstablecimiento AT ROW 4.77 COL 62 COLON-ALIGNED NO-LABEL WIDGET-ID 212
     GN-DIVI.Campo-Char[5] AT ROW 4.77 COL 110 COLON-ALIGNED WIDGET-ID 194
          LABEL "Distrito" FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     FILL-IN-NomDistr AT ROW 4.77 COL 116 COLON-ALIGNED NO-LABEL WIDGET-ID 200
     GN-DIVI.CanalVenta AT ROW 5.5 COL 12 COLON-ALIGNED WIDGET-ID 2
          LABEL "Canal de Venta"
          VIEW-AS FILL-IN 
          SIZE 17 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     GN-DIVI.Grupo_Divi_GG AT ROW 5.58 COL 54 COLON-ALIGNED WIDGET-ID 226
          LABEL "Peldaño"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
          BGCOLOR 14 FGCOLOR 0 
     FILL-IN-Grupo_Divi_GG AT ROW 5.58 COL 62 COLON-ALIGNED NO-LABEL WIDGET-ID 228
     GN-DIVI.FaxDiv AT ROW 5.58 COL 110 COLON-ALIGNED WIDGET-ID 10
          LABEL "Dpto - Provincia - Distrito" FORMAT "X(80)"
          VIEW-AS FILL-IN 
          SIZE 39 BY .81 TOOLTIP "(Ejm : LIMA - LIMA - CERCADO)"
     GN-DIVI.Centro_Costo AT ROW 6.38 COL 54 COLON-ALIGNED WIDGET-ID 230
          LABEL "Centro de Costo"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
          BGCOLOR 14 FGCOLOR 0 
     FILL-IN-Centro_Costo AT ROW 6.38 COL 62 COLON-ALIGNED NO-LABEL WIDGET-ID 232
     GN-DIVI.Campo-Dec[5] AT ROW 7.77 COL 137 COLON-ALIGNED WIDGET-ID 168
          LABEL "Factor de Consolidación ODC" FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     GN-DIVI.DiasVtoCot AT ROW 7.96 COL 21 COLON-ALIGNED WIDGET-ID 26
          LABEL "Dias Vto. Cotiz."
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
     GN-DIVI.FlgRotacion AT ROW 7.96 COL 50 NO-LABEL WIDGET-ID 28
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "A", "A":U,
"A y B", "B":U
          SIZE 14 BY .81
     GN-DIVI.FlgPicking AT ROW 7.96 COL 81 WIDGET-ID 162
          LABEL "Control de Picking"
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .81
     GN-DIVI.DiasVtoPed AT ROW 8.73 COL 21 COLON-ALIGNED WIDGET-ID 34
          LABEL "Dias Vto. Pedido"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
     GN-DIVI.FlgPreVta AT ROW 8.73 COL 50 NO-LABEL WIDGET-ID 92
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Mayorista", yes,
"Minorista", no
          SIZE 20 BY .81
     GN-DIVI.FlgBarras AT ROW 8.73 COL 81 WIDGET-ID 40
          LABEL "Control de Barras"
          VIEW-AS TOGGLE-BOX
          SIZE 19 BY .81
     FILL-IN-Usuario AT ROW 8.81 COL 129 COLON-ALIGNED WIDGET-ID 214
     GN-DIVI.DiasVtoO_D AT ROW 9.5 COL 21 COLON-ALIGNED WIDGET-ID 90
          LABEL "Dias Vto. O/D"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
     GN-DIVI.FlgEmpaque AT ROW 9.5 COL 81 WIDGET-ID 42
          LABEL "Control de Empaque"
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .81
     FILL-IN-Fecha AT ROW 9.62 COL 129 COLON-ALIGNED WIDGET-ID 216
     GN-DIVI.FlgMinVenta AT ROW 10.42 COL 81 WIDGET-ID 44
          LABEL "Control del Mínimo de Ventas"
          VIEW-AS TOGGLE-BOX
          SIZE 28 BY .81
     GN-DIVI.Campo-Log[4] AT ROW 10.46 COL 23 WIDGET-ID 164
          LABEL "AJUSTE POR FLETE"
          VIEW-AS TOGGLE-BOX
          SIZE 25 BY .81
          BGCOLOR 14 FGCOLOR 0 FONT 6
     GN-DIVI.flgrep AT ROW 11.23 COL 81 WIDGET-ID 142
          LABEL "Acepta Fact. Interna (FAI)"
          VIEW-AS TOGGLE-BOX
          SIZE 26 BY .81
     GN-DIVI.Campo-Log[9] AT ROW 11.23 COL 113 WIDGET-ID 184
          LABEL "Verifica Stock por COTIZACION"
          VIEW-AS TOGGLE-BOX
          SIZE 25 BY .77
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     GN-DIVI.Campo-Log[8] AT ROW 11.42 COL 23 WIDGET-ID 188
          LABEL "Control de Despacho"
          VIEW-AS TOGGLE-BOX
          SIZE 18 BY .77
          BGCOLOR 14 FGCOLOR 0 
     GN-DIVI.DiasAmpCot AT ROW 11.42 COL 65 COLON-ALIGNED WIDGET-ID 36
          LABEL "Max. Cliente por dia"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
          BGCOLOR 14 FGCOLOR 0 
     GN-DIVI.VentaMayorista AT ROW 13.12 COL 5 NO-LABEL WIDGET-ID 98
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Lista de Precios General", 1,
"Lista de Precio por División", 2
          SIZE 27 BY 1.42
     GN-DIVI.Libre_c01 AT ROW 13.12 COL 64 NO-LABEL WIDGET-ID 126
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Prioridades Excluyentes", "",
"Prioridades Acumuladas", "A":U,
"Busca mejor precio", "M":U
          SIZE 67 BY .77
     GN-DIVI.FlgDtoVol AT ROW 14.27 COL 65 WIDGET-ID 58
          LABEL "Descuento por Volumen de Venta"
          VIEW-AS TOGGLE-BOX
          SIZE 23 BY .77
     GN-DIVI.Campo-Log[6] AT ROW 14.46 COL 5 WIDGET-ID 202
          LABEL "Solo Clientes VIP"
          VIEW-AS TOGGLE-BOX
          SIZE 15 BY .77
     GN-DIVI.Libre_L01 AT ROW 14.65 COL 94 WIDGET-ID 130
          LABEL "LISTAS PROMOCIONALES"
          VIEW-AS TOGGLE-BOX
          SIZE 30 BY .77
     GN-DIVI.Campo-Dec[6] AT ROW 14.85 COL 137.29 COLON-ALIGNED WIDGET-ID 218
          LABEL "Longuitd"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     GN-DIVI.FlgDtoProm AT ROW 15.23 COL 65 WIDGET-ID 56
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY .77
     GN-DIVI.Campo-Dec[7] AT ROW 15.65 COL 137.29 COLON-ALIGNED WIDGET-ID 220
          LABEL "Latitud"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     GN-DIVI.Libre_c02 AT ROW 16.19 COL 20 COLON-ALIGNED HELP
          "" WIDGET-ID 156
          LABEL "Tipo" FORMAT "x(15)"
          VIEW-AS COMBO-BOX INNER-LINES 2
          LIST-ITEMS "Porcentaje","Importe" 
          DROP-DOWN-LIST
          SIZE 16 BY 1
     GN-DIVI.FlgDtoClfCli AT ROW 16.38 COL 65 WIDGET-ID 60
          LABEL "Descuento por Clasificación del Cliente"
          VIEW-AS TOGGLE-BOX
          SIZE 36 BY .77
     GN-DIVI.PorDtoClfCli AT ROW 16.38 COL 117 COLON-ALIGNED WIDGET-ID 88
          LABEL "% Especial C"
          VIEW-AS FILL-IN 
          SIZE 8 BY 1
          BGCOLOR 12 FGCOLOR 15 
     GN-DIVI.Libre_d01 AT ROW 17.15 COL 20 COLON-ALIGNED HELP
          "" WIDGET-ID 158
          LABEL "Variación" FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 16 BY .81
     GN-DIVI.FlgDtoCndVta AT ROW 17.15 COL 65 WIDGET-ID 74
          LABEL "Descuento por Condición de Venta"
          VIEW-AS TOGGLE-BOX
          SIZE 35 BY .77
     "Prioridad 2.-" VIEW-AS TEXT
          SIZE 10 BY .62 AT ROW 16.38 COL 54 WIDGET-ID 124
          FONT 6
     "Calcular por:" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 13.31 COL 53 WIDGET-ID 116
          FONT 6
     "Cod. de Establecimiento" VIEW-AS TEXT
          SIZE 22.72 BY .96 AT ROW 4.77 COL 33 WIDGET-ID 210
          FGCOLOR 9 FONT 15
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "Rotación:" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 8.15 COL 41 WIDGET-ID 32
     "Prioridad 1.-" VIEW-AS TEXT
          SIZE 10 BY .62 AT ROW 14.27 COL 54 WIDGET-ID 104
          FONT 6
     "Variación Precio Unitario - Contrato Marco" VIEW-AS TEXT
          SIZE 47 BY .62 AT ROW 15.42 COL 2 WIDGET-ID 148
          BGCOLOR 14 FGCOLOR 0 
     "Tipo de Venta:" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 8.92 COL 38 WIDGET-ID 96
     "Configuración Precios de Venta y Descuento al Crédito Mayorista" VIEW-AS TEXT
          SIZE 57 BY .62 AT ROW 12.38 COL 2 WIDGET-ID 72
          BGCOLOR 1 FGCOLOR 15 
     "  Coordenadas GPS" VIEW-AS TEXT
          SIZE 17.57 BY .5 AT ROW 14.12 COL 131.43 WIDGET-ID 224
          FGCOLOR 4 FONT 6
     "Configuración de la venta" VIEW-AS TEXT
          SIZE 24 BY .62 AT ROW 7.19 COL 2 WIDGET-ID 64
          BGCOLOR 1 FGCOLOR 15 
     RECT-46 AT ROW 1 COL 1 WIDGET-ID 22
     RECT-48 AT ROW 7.46 COL 1 WIDGET-ID 62
     RECT-51 AT ROW 12.73 COL 1 WIDGET-ID 118
     RECT-52 AT ROW 14.08 COL 64 WIDGET-ID 120
     RECT-53 AT ROW 16.19 COL 64 WIDGET-ID 122
     RECT-54 AT ROW 15.62 COL 1 WIDGET-ID 150
     RECT-55 AT ROW 14.31 COL 130 WIDGET-ID 222
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.GN-DIVI
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 18.19
         WIDTH              = 154.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN GN-DIVI.Campo-Char[10] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR COMBO-BOX GN-DIVI.Campo-Char[1] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN GN-DIVI.Campo-Char[3] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN GN-DIVI.Campo-Char[4] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN GN-DIVI.Campo-Char[5] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR COMBO-BOX GN-DIVI.Campo-Char[7] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN GN-DIVI.Campo-Dec[5] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN GN-DIVI.Campo-Dec[6] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN GN-DIVI.Campo-Dec[7] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX GN-DIVI.Campo-Log[10] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX GN-DIVI.Campo-Log[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX GN-DIVI.Campo-Log[4] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX GN-DIVI.Campo-Log[5] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX GN-DIVI.Campo-Log[6] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX GN-DIVI.Campo-Log[7] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX GN-DIVI.Campo-Log[8] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX GN-DIVI.Campo-Log[9] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN GN-DIVI.CanalVenta IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN GN-DIVI.Centro_Costo IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN GN-DIVI.CodDiv IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN GN-DIVI.DesDiv IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN GN-DIVI.DiasAmpCot IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN GN-DIVI.DiasVtoCot IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN GN-DIVI.DiasVtoO_D IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN GN-DIVI.DiasVtoPed IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN GN-DIVI.DirDiv IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN GN-DIVI.FaxDiv IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
ASSIGN 
       GN-DIVI.FaxDiv:MANUAL-HIGHLIGHT IN FRAME F-Main = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Centro_Costo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Fecha IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Grupo_Divi_GG IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomDepto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomDistr IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomProvi IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Usuario IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX GN-DIVI.FlgBarras IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX GN-DIVI.FlgDtoClfCli IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX GN-DIVI.FlgDtoCndVta IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX GN-DIVI.FlgDtoVol IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX GN-DIVI.FlgEmpaque IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX GN-DIVI.FlgMinVenta IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX GN-DIVI.FlgPicking IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX GN-DIVI.flgrep IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN GN-DIVI.Grupo_Divi_GG IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX GN-DIVI.Libre_c02 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR FILL-IN GN-DIVI.Libre_d01 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR FILL-IN GN-DIVI.Libre_f01 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR TOGGLE-BOX GN-DIVI.Libre_L01 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN GN-DIVI.PorDtoClfCli IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN txtDirEstablecimiento IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME GN-DIVI.Campo-Char[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL GN-DIVI.Campo-Char[10] V-table-Win
ON LEAVE OF GN-DIVI.Campo-Char[10] IN FRAME F-Main /* Campo-Char */
DO:
    txtDirEstablecimiento:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
     FIND FIRST SunatTablaD WHERE SunatTablaD.codcia = s-codcia AND 
                                     SunatTablaD.tabla = 'CBD' AND 
                                     SunatTablaD.llave1 = 'ESTCOM' AND
                                     SunatTablaD.llave2 = GN-DIVI.Campo-Char[10]:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                                     NO-LOCK NO-ERROR.
     IF AVAILABLE SunatTablaD THEN DO:
        txtDirEstablecimiento:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SunatTablaD.descripcion.
     END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME GN-DIVI.Campo-Char[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL GN-DIVI.Campo-Char[3] V-table-Win
ON LEAVE OF GN-DIVI.Campo-Char[3] IN FRAME F-Main /* Departamento */
DO:
    FIND TabDepto WHERE TabDepto.CodDepto = GN-DIVI.Campo-Char[3]:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE TabDepto THEN FILL-IN-NomDepto:SCREEN-VALUE = TabDepto.NomDepto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL GN-DIVI.Campo-Char[3] V-table-Win
ON LEFT-MOUSE-DBLCLICK OF GN-DIVI.Campo-Char[3] IN FRAME F-Main /* Departamento */
OR f8 OF GN-DIVI.Campo-Char[3]
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?.
    RUN lkup/c-depart ('Departamento').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME GN-DIVI.Campo-Char[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL GN-DIVI.Campo-Char[4] V-table-Win
ON LEAVE OF GN-DIVI.Campo-Char[4] IN FRAME F-Main /* Provincia */
DO:
    FIND TabProvi WHERE TabProvi.CodDepto = GN-DIVI.Campo-Char[3]:SCREEN-VALUE
      AND TabProvi.CodProvi = GN-DIVI.Campo-Char[4]:SCREEN-VALUE
      NO-LOCK NO-ERROR.
    IF AVAILABLE TabProvi THEN FILL-IN-NomProvi:SCREEN-VALUE = TabProvi.NomProvi.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL GN-DIVI.Campo-Char[4] V-table-Win
ON LEFT-MOUSE-DBLCLICK OF GN-DIVI.Campo-Char[4] IN FRAME F-Main /* Provincia */
OR f8 OF GN-DIVI.Campo-Char[4]
DO:
    ASSIGN
        input-var-1 = GN-DIVI.Campo-Char[3]:SCREEN-VALUE
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?.
    RUN lkup/c-provin ('Provincia').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME GN-DIVI.Campo-Char[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL GN-DIVI.Campo-Char[5] V-table-Win
ON LEAVE OF GN-DIVI.Campo-Char[5] IN FRAME F-Main /* Distrito */
DO:
  FIND TabDistr WHERE TabDistr.CodDepto = GN-DIVI.Campo-Char[3]:SCREEN-VALUE
      AND TabDistr.CodProvi = GN-DIVI.Campo-Char[4]:SCREEN-VALUE
      AND TabDistr.CodDistr = GN-DIVI.Campo-Char[5]:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE TabDistr THEN FILL-IN-NomDistr:SCREEN-VALUE = TabDistr.NomDistr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL GN-DIVI.Campo-Char[5] V-table-Win
ON LEFT-MOUSE-DBLCLICK OF GN-DIVI.Campo-Char[5] IN FRAME F-Main /* Distrito */
OR f8 OF GN-DIVI.Campo-Char[5]
DO:
    ASSIGN
        input-var-1 = GN-DIVI.Campo-Char[3]:SCREEN-VALUE
        input-var-2 = GN-DIVI.Campo-Char[4]:SCREEN-VALUE
        input-var-3 = ''
        output-var-1 = ?.
    RUN lkup/c-distri ('Distrito').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME GN-DIVI.Centro_Costo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL GN-DIVI.Centro_Costo V-table-Win
ON LEAVE OF GN-DIVI.Centro_Costo IN FRAME F-Main /* Centro de Costo */
DO:
  FILL-IN-Centro_Costo:SCREEN-VALUE = ''.
  FIND FIRST cb-auxi WHERE cb-auxi.codcia = cb-codcia AND
      cb-auxi.clfaux = 'CCO' AND
      cb-auxi.codaux = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE cb-auxi THEN FILL-IN-Centro_Costo:SCREEN-VALUE = cb-auxi.nomaux.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL GN-DIVI.Centro_Costo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF GN-DIVI.Centro_Costo IN FRAME F-Main /* Centro de Costo */
DO:
  ASSIGN
    input-var-1 = 'CCO'
    input-var-2 = ''
    input-var-3 = ''
    output-var-1 = ?            /* Rowid */
    output-var-2 = ''
    output-var-3 = ''.


  RUN lkup/c-auxil.r ('Centro de Costos').
  IF output-var-1 = ? THEN RETURN 'ADM-ERROR'.

  self:screen-value = output-var-2.
  fill-in-Centro_Costo:screen-value = output-var-3.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME GN-DIVI.FlgEmpaque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL GN-DIVI.FlgEmpaque V-table-Win
ON VALUE-CHANGED OF GN-DIVI.FlgEmpaque IN FRAME F-Main /* Control de Empaque */
DO:
  IF INPUT {&self-name} = YES THEN gn-divi.FlgMinVenta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'NO'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME GN-DIVI.FlgMinVenta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL GN-DIVI.FlgMinVenta V-table-Win
ON VALUE-CHANGED OF GN-DIVI.FlgMinVenta IN FRAME F-Main /* Control del Mínimo de Ventas */
DO:
    IF INPUT {&self-name} = YES THEN gn-divi.FlgEmpaque:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'NO'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME GN-DIVI.Grupo_Divi_GG
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL GN-DIVI.Grupo_Divi_GG V-table-Win
ON LEAVE OF GN-DIVI.Grupo_Divi_GG IN FRAME F-Main /* Peldaño */
DO:
    FILL-IN-Grupo_Divi_GG:SCREEN-VALUE = ''.
    FIND FacTabla WHERE FacTabla.CodCia = s-CodCia AND
        FacTabla.Tabla = 'GRUPO_DIVGG' AND
        FacTabla.Codigo = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE FacTabla THEN FILL-IN-Grupo_Divi_GG:SCREEN-VALUE = FacTabla.Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "GN-DIVI"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "GN-DIVI"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      gn-divi.codcia = s-codcia
      gn-divi.canalventa = CAPS(gn-divi.canalventa).
  /* RHC 30.05.2012 EN TODOS LOS CASOS SERAN LISTAS GENERALES */
  ASSIGN
      gn-divi.VentaMinorista = 1.
  /* RHC 30.05.2012 EN TODOS LOS CASOS NO VA A HABER CONTROL DE PICKING */
/*   ASSIGN                       */
/*       gn-divi.FlgPIcking = NO. */
  IF GN-DIVI.Libre_L02 = NO THEN GN-DIVI.Libre_d02 = 0.

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

  /* LOG DE CONTROL */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' 
  THEN RUN lib/logtabla ('gn-divi',
                         gn-divi.coddiv,
                         'CREATE').
  ELSE RUN lib/logtabla ('gn-divi',
                         gn-divi.coddiv,
                         'UPDATE').
   RUN dispatch IN THIS-PROCEDURE ('display-fields':U).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF AVAILABLE gn-divi 
      THEN RUN lib/logtabla ('gn-divi',
                             gn-divi.coddiv,
                             'DELETE').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FIND TabDepto WHERE TabDepto.CodDepto = GN-DIVI.Campo-Char[3] NO-LOCK NO-ERROR.
      FIND TabProvi WHERE TabProvi.CodDepto = GN-DIVI.Campo-Char[3] 
          AND TabProvi.CodProvi = GN-DIVI.Campo-Char[4] 
          NO-LOCK NO-ERROR.
      FIND TabDistr WHERE TabDistr.CodDepto = GN-DIVI.Campo-Char[3] 
          AND TabDistr.CodProvi = GN-DIVI.Campo-Char[4] 
          AND TabDistr.CodDistr = GN-DIVI.Campo-Char[5] 
          NO-LOCK NO-ERROR.
      ASSIGN
          FILL-IN-NomDepto:SCREEN-VALUE = (IF AVAILABLE TabDepto THEN TabDepto.NomDepto ELSE '')
          FILL-IN-NomDistr:SCREEN-VALUE = (IF AVAILABLE TabDistr THEN TabDistr.NomDistr ELSE '')
          FILL-IN-NomProvi:SCREEN-VALUE = (IF AVAILABLE TabProvi THEN TabProvi.NomProvi ELSE '').

    
    txtDirEstablecimiento:SCREEN-VALUE = "".
     FIND FIRST SunatTablaD WHERE SunatTablaD.codcia = s-codcia AND 
                                     SunatTablaD.tabla = 'CBD' AND 
                                     SunatTablaD.llave1 = 'ESTCOM' AND
                                     SunatTablaD.llave2 = GN-DIVI.Campo-Char[10]:SCREEN-VALUE
                                     NO-LOCK NO-ERROR.
     IF AVAILABLE SunatTablaD THEN DO:
        txtDirEstablecimiento:SCREEN-VALUE = SunatTablaD.descripcion.
     END.
     /* RHC 128/01/2019 Usuario ultima modificacion */
     FILL-IN-Usuario:SCREEN-VALUE = ''.
     FILL-IN-Fecha:SCREEN-VALUE = ''.
     FIND LAST logtabla WHERE logtabla.codcia = s-codcia AND
         logtabla.Tabla = 'GN-DIVI' AND
         logtabla.ValorLlave = gn-divi.coddiv NO-LOCK NO-ERROR.
     IF AVAILABLE logtabla 
         THEN ASSIGN FILL-IN-Usuario:SCREEN-VALUE = logtabla.Usuario
         FILL-IN-Fecha:SCREEN-VALUE = STRING(logtabla.Dia, '99/99/9999') + ' ' + logtabla.Hora.
     /* RHC 27/11/2019 grupo división GG */
     FILL-IN-Grupo_Divi_GG = ''.
     FIND FacTabla WHERE FacTabla.CodCia = s-CodCia AND
         FacTabla.Tabla = 'GRUPO_DIVGG' AND
         FacTabla.Codigo = GN-DIVI.Grupo_Divi_GG NO-LOCK NO-ERROR.
     IF AVAILABLE FacTabla THEN FILL-IN-Grupo_Divi_GG = FacTabla.Nombre.
     DISPLAY FILL-IN-Grupo_Divi_GG.
     /* Centro de costo */
     FILL-IN-Centro_Costo:SCREEN-VALUE = ''.
     FIND cb-auxi WHERE cb-auxi.codcia = cb-codcia AND
         cb-auxi.clfaux = 'CCO' AND
         cb-auxi.codaux = GN-DIVI.Centro_Costo NO-LOCK NO-ERROR.
     IF AVAILABLE cb-auxi THEN FILL-IN-Centro_Costo:SCREEN-VALUE = cb-auxi.nomaux.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
/*       GN-DIVI.Libre_d02:SENSITIVE = NO.                    */
/*       RUN GET-ATTRIBUTE('ADM-NEW-RECORD').                 */
/*       IF RETURN-VALUE = 'NO' THEN DO:                      */
/*           GN-DIVI.Libre_d02:SENSITIVE = GN-DIVI.Libre_L02. */
/*       END.                                                 */
      /* RHC 18/03/2019 Bajo el control de ABASTECIMIENTOS */
      DISABLE 
          GN-DIVI.Campo-Log[5] 
          GN-DIVI.FlgPicking
          GN-DIVI.FlgBarras
          /*GN-DIVI.Grupo_Divi_GG*/
          .
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros V-table-Win 
PROCEDURE procesa-parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros V-table-Win 
PROCEDURE recoge-parametros :
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
        WHEN "Grupo_Divi_GG" THEN 
            ASSIGN
                input-var-1 = "GRUPO_DIVGG"
                input-var-2 = ""
                input-var-3 = "".
        WHEN "Centro_Costo" THEN 
            ASSIGN
                input-var-1 = "CCO"
                input-var-2 = ""
                input-var-3 = "".
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "GN-DIVI"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.
  
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.

  INTEGRAL.GN-DIVI.CodDiv:sensitive in frame {&FRAME-NAME} = no.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME} :
    /* RHC 27/06/2020 Campos obligatorios FOV */
    IF TRUE <> (GN-DIVI.DesDiv:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'Nombre en blanco' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO GN-DIVI.DesDiv.
        RETURN 'ADM-ERROR'.
    END.
    IF TRUE <> (GN-DIVI.DirDiv:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'Dirección en blanco' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO GN-DIVI.DirDiv.
        RETURN 'ADM-ERROR'.
    END.
    IF TRUE <> (GN-DIVI.Campo-Char[10]:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'Código de establecimiento en blanco' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO GN-DIVI.Campo-Char[10].
        RETURN 'ADM-ERROR'.
    END.
    IF TRUE <> (GN-DIVI.Grupo_Divi_GG:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'Peldaño en blanco' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO GN-DIVI.Grupo_Divi_GG.
        RETURN 'ADM-ERROR'.
    END.
    IF TRUE <> (GN-DIVI.Centro_Costo:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'Centro de Costo en blanco' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO GN-DIVI.Centro_Costo.
        RETURN 'ADM-ERROR'.
    END.
    IF TRUE <> (GN-DIVI.Campo-Char[3]:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'Código de Departamento en blanco' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO GN-DIVI.Campo-Char[3].
        RETURN 'ADM-ERROR'.
    END.
    IF TRUE <> (GN-DIVI.Campo-Char[4]:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'Código de Provincia en blanco' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO GN-DIVI.Campo-Char[4].
        RETURN 'ADM-ERROR'.
    END.
    IF TRUE <> (GN-DIVI.Campo-Char[5]:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'Código de Distrito en blanco' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO GN-DIVI.Campo-Char[5].
        RETURN 'ADM-ERROR'.
    END.
    IF TRUE <> (GN-DIVI.FaxDiv:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'Código de Dpto - Provincia - Distrito en blanco' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO GN-DIVI.FaxDiv.
        RETURN 'ADM-ERROR'.
    END.
    /* *********************************************************************************** */
    IF GN-DIVI.Campo-Char[3]:SCREEN-VALUE > '' THEN DO:
        FIND TabDepto WHERE TabDepto.CodDepto = GN-DIVI.Campo-Char[3]:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF NOT AVAILABLE TabDepto THEN DO:
            MESSAGE 'Departamento NO registrado' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO GN-DIVI.Campo-Char[3].
            RETURN 'ADM-ERROR'.
        END.
    END.
    IF GN-DIVI.Campo-Char[4]:SCREEN-VALUE > '' THEN DO:
        FIND TabProvi WHERE TabProvi.CodDepto = GN-DIVI.Campo-Char[3]:SCREEN-VALUE 
            AND TabProvi.CodProvi = GN-DIVI.Campo-Char[4]:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE TabProvi THEN DO:
            MESSAGE 'Provincia NO registrada' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO GN-DIVI.Campo-Char[4].
            RETURN 'ADM-ERROR'.
        END.
    END.
    IF GN-DIVI.Campo-Char[5]:SCREEN-VALUE > '' THEN DO:
        FIND TabDistr WHERE TabDistr.CodDepto = GN-DIVI.Campo-Char[3]:SCREEN-VALUE 
            AND TabDistr.CodProvi = GN-DIVI.Campo-Char[4]:SCREEN-VALUE
            AND TabDistr.CodDistr = GN-DIVI.Campo-Char[5]:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE TabDistr THEN DO:
            MESSAGE 'Distrito NO registrado' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO GN-DIVI.Campo-Char[5].
            RETURN 'ADM-ERROR'.
        END.
        IF GN-DIVI.FaxDiv:SCREEN-VALUE = '' THEN GN-DIVI.FaxDiv:SCREEN-VALUE = TRIM(TabDistr.NomDistr) + '-' +
            TRIM(TabProvi.NomProvi) + '-' + TabDepto.NomDept.
    END.
    /* Ic - 14Jun2018, por requerimiento de SUNAT */
    IF GN-DIVI.Campo-Char[10]:SCREEN-VALUE > '' THEN DO:
        FIND FIRST SunatTablaD WHERE SunatTablaD.codcia = s-codcia AND 
                                        SunatTablaD.tabla = 'CBD' AND 
                                        SunatTablaD.llave1 = 'ESTCOM' AND
                                        SunatTablaD.llave2 = GN-DIVI.Campo-Char[10]:SCREEN-VALUE
                                        NO-LOCK NO-ERROR.
        IF NOT AVAILABLE SunatTablaD THEN DO:
            MESSAGE 'codigo del establecimiento NO EXISTE' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO GN-DIVI.Campo-Char[10].
            RETURN 'ADM-ERROR'.        
        END.
    END.
    ELSE DO:
        MESSAGE 'Seguro de grabar sin codigo de ESTABLECIMIENTO?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
            IF rpta = NO THEN DO:
            APPLY 'ENTRY':U TO GN-DIVI.Campo-Char[10].
            RETURN "ADM-ERROR".
        END.
            
        /*
        MESSAGE 'Ingrese el codigo del establecimiento' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO GN-DIVI.Campo-Char[10].
        RETURN 'ADM-ERROR'.        
        */
    END.
    /* RHC 27/11/2019 */
    IF TRUE <> (GN-DIVI.Grupo_Divi_GG:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'Seguro de grabar PELDAÑO?' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta1 AS LOG.
        IF rpta1 = NO THEN DO:
            APPLY 'ENTRY':U TO GN-DIVI.Grupo_Divi_GG.
            RETURN 'ADM-ERROR'.
        END.
    END.
    ELSE DO:
        IF NOT CAN-FIND(FIRST FacTabla WHERE FacTabla.CodCia = s-CodCia AND
                        FacTabla.Tabla = 'GRUPO_DIVGG' AND
                        FacTabla.Codigo = GN-DIVI.Grupo_Divi_GG:SCREEN-VALUE
                        NO-LOCK)
            THEN DO:
            MESSAGE 'Grupo División GG NO válido' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO GN-DIVI.Grupo_Divi_GG.
            RETURN 'ADM-ERROR'.
        END.
    END.
    /* Centro de Costo */
    /* Ic - 22Jun2020, obligatorio Centro de Costo */
    IF GN-DIVI.Centro_Costo:SCREEN-VALUE > '' THEN DO:
        FIND FIRST cb-auxi WHERE cb-auxi.codcia = cb-codcia AND
            cb-auxi.clfaux = 'CCO' AND
            cb-auxi.codaux = GN-DIVI.Centro_Costo:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE cb-auxi THEN DO:
            MESSAGE 'Centro de costo NO válido' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO GN-DIVI.Centro_Costo.
            RETURN 'ADM-ERROR'.
        END.
    END.
    ELSE DO:
        MESSAGE 'Por favor es obligatorio el centro de costo!!!' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO GN-DIVI.Centro_Costo.
        RETURN 'ADM-ERROR'.
    END.

END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

