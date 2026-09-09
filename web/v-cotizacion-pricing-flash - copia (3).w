&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE TEMP-TABLE BONIFICACION LIKE FacDPedi.
DEFINE SHARED TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE TEMP-TABLE ITEM-1 NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE ITEM-2 NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE ITEM-LE LIKE FacDPedi.
DEFINE TEMP-TABLE PEDI NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE T-DPEDI LIKE FacDPedi.



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

&SCOPED-DEFINE ARITMETICA-SUNAT YES

&SCOPED-DEFINE precio-venta-general web/PrecioFinalCreditoMayorista.p

&SCOPED-DEFINE Promocion vta2/promocion-generalv2.p

DEF VAR x-articulo-ICBPer AS CHAR INIT '099268'.

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-nroser AS INT.
DEF SHARED VAR s-codmon AS INT.
DEF SHARED VAR s-CodCli AS CHAR.
DEF SHARED VAR s-porigv AS DEC.
DEF SHARED VAR s-fmapgo AS CHAR.
DEF SHARED VAR s-tpocmb AS DEC.
DEF SHARED VAR s-codven AS CHAR.
DEF SHARED VAR lh_Handle AS HANDLE.
DEF SHARED VAR s-nrodec AS INT.
DEF SHARED VAR s-tpoped AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-flgigv AS LOG.
DEF SHARED VAR s-codalm AS CHAR.

DEF SHARED VAR s-adm-new-record AS CHAR.
DEF SHARED VAR S-NROPED AS CHAR.
DEF SHARED VAR pCodDiv  AS CHAR.        /* DIVISION DE LA LISTA DE PRECIOS */
DEF SHARED VAR S-CMPBNTE  AS CHAR.
DEF SHARED VAR S-CODTER   AS CHAR.
DEF SHARED VAR S-TPOMARCO AS CHAR.      /* CASO DE CLIENTES EXCEPCIONALES */

/* Parámetros de la División */
DEF SHARED VAR s-DiasVtoCot LIKE GN-DIVI.DiasVtoCot.
DEF SHARED VAR s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.
DEF SHARED VAR s-MinimoPesoDia AS DEC.
DEF SHARED VAR s-MaximaVarPeso AS DEC.
DEF SHARED VAR s-MinimoDiasDespacho AS DEC.
DEF SHARED VAR s-ClientesVIP AS LOG.
DEF SHARED VAR s-FlgEmpaque     LIKE GN-DIVI.FlgEmpaque.
DEF SHARED VAR s-FlgMinVenta    LIKE GN-DIVI.FlgMinVenta.
DEF SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.

DEF VAR s-copia-registro AS LOG.
DEF VAR s-cndvta-validos AS CHAR.
DEF VAR F-Observa        AS CHAR.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
DEFINE VAR x-ClientesVarios AS CHAR.
x-ClientesVarios = FacCfgGn.CliVar.     /* 11 digitos */

/* Variables para los mensajes de error */
DEF VAR pMensaje AS CHAR NO-UNDO.

DEFINE VAR lOrdenGrabada AS CHAR.
DEFINE VAR pFechaEntrega AS DATE.

lOrdenGrabada = "".
    
DEF TEMP-TABLE ResumenxLinea
    FIELD codmat LIKE almmmatg.codmat
    FIELD codfam LIKE almmmatg.codfam
    FIELD subfam LIKE almmmatg.subfam
    FIELD canped LIKE facdpedi.canped
    INDEX Llave01 AS PRIMARY /*UNIQUE*/ codmat codfam subfam.

DEF TEMP-TABLE ErroresxLinea LIKE ResumenxLinea.

/* VARIABLES PARA EL EXCEL */
DEFINE VARIABLE chExcelApplication  AS COM-HANDLE.
DEFINE VARIABLE chWorkbook          AS COM-HANDLE.
DEFINE VARIABLE chWorksheet         AS COM-HANDLE.
DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE t-Row           AS INTEGER INIT 1.

DEF VAR ImpMinPercep AS DEC INIT 1500 NO-UNDO.
DEF VAR ImpMinDNI    AS DEC INIT 700 NO-UNDO.

DEFINE VAR p-lfilexls AS CHAR INIT "".
DEFINE VAR p-lFileXlsProcesado AS CHAR INIT "".
DEFINE VARIABLE cCOTDesde AS CHAR INIT "".
DEFINE VARIABLE cCOTHasta AS CHAR INIT "".

DEFINE SHARED VAR s-nivel-acceso AS INT NO-UNDO.
/* 1: NO ha pasado por ABASTECIMIENTOS => Puede modificar todo (Por Defecto) */
/* 0: YA pasó por abastecimientos => Puede disminuir las cantidades mas no incrementarlas */

/* B2Bv2 */
DEFINE TEMP-TABLE OrdenCompra-tienda
    FIELDS nro-oc   AS CHAR
    FIELDS clocal-destino AS CHAR
    FIELDS dlocal-Destino AS CHAR
    FIELDS clocal-entrega AS CHAR
    FIELDS dlocal-entrega AS CHAR
    FIELDS fecha-entrega  AS DATE
    FIELDS CodClie AS CHAR

    INDEX llave01 AS PRIMARY nro-oc clocal-destino.

/* ************************************************************************* */
/* VARIABLES PARA SUPERMERCADOS */
/* ************************************************************************* */
/* 03Oct2014 - Plaza Vea cambio B2B*/
DEF TEMP-TABLE tt-OrdenesPlazVea
    FIELD tt-nroorden AS CHAR FORMAT 'x(15)'
    FIELD tt-codclie AS CHAR FORMAT 'x(11)'
    FIELD tt-locentrega AS CHAR FORMAT 'x(8)'.

DEF SHARED VAR s-import-b2b AS LOG.
DEF SHARED VAR s-import-ibc AS LOG.
/*DEF SHARED VAR s-import-cissac AS LOG.*/

DEF VAR s-pendiente-ibc AS LOG.

/* Ic - 10Feb2016, Metodo de Pago - Lista Express */
DEFINE TEMP-TABLE tt-MetodPagoListaExpress
    FIELDS tt-cotizacion AS CHAR
    FIELDS tt-pedidoweb AS CHAR
    FIELDS tt-metodopago AS CHAR
    FIELDS tt-tipopago AS CHAR
    FIELDS tt-nombreclie AS CHAR
    FIELDS tt-preciopagado AS DEC
    FIELDS tt-preciounitario AS DEC
    FIELDS tt-costoenvio AS DEC
    FIELDS tt-descuento AS DEC.

DEFINE BUFFER x-vtatabla FOR vtatabla.
DEFINE BUFFER x-gn-divi FOR gn-divi.

DEFINE TEMP-TABLE tt-listaexpress LIKE w-report.
DEFINE SHARED TEMP-TABLE tt-listaexpress-sugeridos LIKE w-report.

DEFINE SHARED VAR s-VerificaStock AS LOG INIT YES.

DEFINE SHARED VAR s-Solicita-Aprobacion AS LOGICAL.

DEFINE SHARED VAR x-order-type AS CHAR.     /* PREMIUM/STANDARD */
DEFINE VAR x-cod-origen AS CHAR.
DEFINE VAR x-nro-origen AS CHAR.

DEFINE BUFFER b-faccpedi FOR faccpedi.
DEFINE BUFFER b-vtatabla FOR vtatabla.
DEFINE BUFFER b-logdsctosped FOR logdsctosped.


DEFINE IMAGE IMAGE-1 FILENAME "IMG\Coti.ico" SIZE 12 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

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
&Scoped-define EXTERNAL-TABLES FacCPedi
&Scoped-define FIRST-EXTERNAL-TABLE FacCPedi


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR FacCPedi.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS FacCPedi.Libre_c01 FacCPedi.CodCli ~
FacCPedi.FaxCli FacCPedi.Libre_c04 FacCPedi.RucCli FacCPedi.Atencion ~
FacCPedi.e-mail FacCPedi.fchven FacCPedi.NomCli FacCPedi.FchEnt ~
FacCPedi.DirCli FacCPedi.ordcmp FacCPedi.CodVen FacCPedi.Cmpbnte ~
FacCPedi.FmaPgo FacCPedi.TpoCmb FacCPedi.CodMon FacCPedi.NroCard ~
FacCPedi.FlgIgv FacCPedi.Glosa FacCPedi.Libre_d01 FacCPedi.Sede ~
FacCPedi.CodPos FacCPedi.CodRef FacCPedi.NroRef FacCPedi.Cliente_Recoge ~
FacCPedi.CodAlm 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define ENABLED-OBJECTS RECT-27 RECT-25 RECT-26 
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.Libre_c01 ~
FacCPedi.FchPed FacCPedi.CodCli FacCPedi.FaxCli FacCPedi.Libre_c04 ~
FacCPedi.usuario FacCPedi.RucCli FacCPedi.Atencion FacCPedi.e-mail ~
FacCPedi.fchven FacCPedi.NomCli FacCPedi.FchEnt FacCPedi.DirCli ~
FacCPedi.ordcmp FacCPedi.CodVen FacCPedi.Cmpbnte FacCPedi.FmaPgo ~
FacCPedi.CodMon FacCPedi.NroCard FacCPedi.FlgIgv FacCPedi.Glosa ~
FacCPedi.Libre_d01 FacCPedi.Sede FacCPedi.CodPos FacCPedi.CodRef ~
FacCPedi.NroRef FacCPedi.Cliente_Recoge FacCPedi.CodAlm 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS F-Estado FILL-IN-1 FILL-IN-marco f-NomVen ~
F-CndVta F-Nomtar FILL-IN-sede txtStkLetras FILL-IN-CodPos FILL-IN-DesAlm ~
FILL-IN-OrderType 

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
DEFINE BUTTON BUTTON-Turno-Avanza 
     IMAGE-UP FILE "adeicon\pvforw":U
     IMAGE-INSENSITIVE FILE "adeicon\pvforwx":U
     LABEL "Button 1" 
     SIZE 5 BY .96 TOOLTIP "Siguiente en el turno".

DEFINE BUTTON BUTTON-Turno-Retrocede 
     IMAGE-UP FILE "adeicon\pvback":U
     IMAGE-INSENSITIVE FILE "adeicon\pvbackx":U
     LABEL "Button turno avanza 2" 
     SIZE 5 BY .96 TOOLTIP "Siguiente en el turno".

DEFINE VARIABLE F-CndVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "ESTADO" 
     VIEW-AS FILL-IN 
     SIZE 36 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE F-Nomtar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE f-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81
     FONT 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPos AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesAlm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-marco AS CHARACTER FORMAT "X(15)":U INITIAL "Lista MARCO?" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .73
     FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-OrderType AS CHARACTER FORMAT "X(25)":U 
     LABEL "Tipo de Orden" 
      VIEW-AS TEXT 
     SIZE 19 BY .62
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-sede AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 63 BY .81 NO-UNDO.

DEFINE VARIABLE txtStkLetras AS INTEGER FORMAT "->>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 15 FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 2.96.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42 BY 2.96.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 131 BY 10.77.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.NroPed AT ROW 1.27 COL 15 COLON-ALIGNED WIDGET-ID 58
          LABEL "Número" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     F-Estado AT ROW 1.27 COL 33 COLON-ALIGNED WIDGET-ID 114
     FacCPedi.Libre_c01 AT ROW 1.27 COL 83 COLON-ALIGNED WIDGET-ID 126
          LABEL "División de Venta" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
          BGCOLOR 14 FGCOLOR 0 FONT 6
     FacCPedi.FchPed AT ROW 1.27 COL 109 COLON-ALIGNED WIDGET-ID 46
          LABEL "Fecha de Emisión"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     BUTTON-Turno-Retrocede AT ROW 1.96 COL 46 WIDGET-ID 34
     BUTTON-Turno-Avanza AT ROW 1.96 COL 51 WIDGET-ID 32
     FacCPedi.CodCli AT ROW 2.08 COL 15 COLON-ALIGNED WIDGET-ID 38
          LABEL "Cliente"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.FaxCli AT ROW 2.08 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 124 FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
          FONT 6
     FILL-IN-1 AT ROW 2.08 COL 54 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     FILL-IN-marco AT ROW 2.08 COL 63 COLON-ALIGNED NO-LABEL WIDGET-ID 156
     FacCPedi.Libre_c04 AT ROW 2.08 COL 76 NO-LABEL WIDGET-ID 144
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Sí", "SI":U,
"No", ""
          SIZE 10 BY .81
          BGCOLOR 15 FGCOLOR 1 
     FacCPedi.usuario AT ROW 2.08 COL 109 COLON-ALIGNED WIDGET-ID 66
          LABEL "Digitado por"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.RucCli AT ROW 2.88 COL 15 COLON-ALIGNED WIDGET-ID 60
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.Atencion AT ROW 2.88 COL 33 COLON-ALIGNED WIDGET-ID 88
          LABEL "DNI" FORMAT "X(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.e-mail AT ROW 2.88 COL 52.57 WIDGET-ID 184
          LABEL "Correo" FORMAT "x(50)"
          VIEW-AS FILL-IN 
          SIZE 36 BY .81
     FacCPedi.fchven AT ROW 2.88 COL 109 COLON-ALIGNED WIDGET-ID 48 FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.NomCli AT ROW 3.69 COL 15 COLON-ALIGNED WIDGET-ID 54 FORMAT "x(256)"
          VIEW-AS FILL-IN 
          SIZE 77 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.FchEnt AT ROW 3.69 COL 109 COLON-ALIGNED WIDGET-ID 130
          LABEL "Fecha Entrega - Cliente"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.DirCli AT ROW 4.5 COL 15 COLON-ALIGNED WIDGET-ID 44
          LABEL "Dirección" FORMAT "x(256)"
          VIEW-AS FILL-IN 
          SIZE 77 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.ordcmp AT ROW 4.5 COL 109 COLON-ALIGNED WIDGET-ID 118 FORMAT "X(25)"
          VIEW-AS FILL-IN 
          SIZE 20 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.CodVen AT ROW 5.31 COL 15 COLON-ALIGNED WIDGET-ID 42
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
          BGCOLOR 11 FGCOLOR 0 
     f-NomVen AT ROW 5.31 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 94
     FacCPedi.Cmpbnte AT ROW 5.31 COL 111 NO-LABEL WIDGET-ID 102
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "FAC", "FAC":U,
"BOL", "BOL":U
          SIZE 17 BY .81
          BGCOLOR 11 FGCOLOR 0 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     FacCPedi.FmaPgo AT ROW 6.12 COL 15 COLON-ALIGNED WIDGET-ID 50
          LABEL "Condición de Venta"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
          BGCOLOR 11 FGCOLOR 0 
     F-CndVta AT ROW 6.12 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 90
     FacCPedi.TpoCmb AT ROW 6.12 COL 94 COLON-ALIGNED WIDGET-ID 64
          LABEL "T.C."
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FacCPedi.CodMon AT ROW 6.12 COL 111 NO-LABEL WIDGET-ID 78
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dólares", 2
          SIZE 15 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.NroCard AT ROW 6.92 COL 15 COLON-ALIGNED WIDGET-ID 56
          LABEL "Tarjeta"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 FGCOLOR 0 
     F-Nomtar AT ROW 6.92 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 92
     FacCPedi.FlgIgv AT ROW 6.92 COL 111 WIDGET-ID 116
          LABEL "Afecto a IGV"
          VIEW-AS TOGGLE-BOX
          SIZE 12 BY .77
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.Glosa AT ROW 7.73 COL 15 COLON-ALIGNED WIDGET-ID 110
          LABEL "Glosa" FORMAT "X(256)"
          VIEW-AS FILL-IN 
          SIZE 69 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.Libre_d01 AT ROW 7.73 COL 111 NO-LABEL WIDGET-ID 158
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "2", 2,
"3", 3,
"4", 4,
"5", 5
          SIZE 15 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.Sede AT ROW 9.08 COL 15 COLON-ALIGNED WIDGET-ID 62
          LABEL "Lugar de Entrega"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
          BGCOLOR 14 FGCOLOR 0 
     FILL-IN-sede AT ROW 9.08 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     txtStkLetras AT ROW 9.08 COL 106 COLON-ALIGNED NO-LABEL WIDGET-ID 152
     FacCPedi.CodPos AT ROW 9.88 COL 15 COLON-ALIGNED WIDGET-ID 170
          LABEL "Código Postal"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
          BGCOLOR 14 FGCOLOR 0 
     FILL-IN-CodPos AT ROW 9.88 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 128
     FacCPedi.CodRef AT ROW 9.88 COL 106 COLON-ALIGNED WIDGET-ID 120
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FacCPedi.NroRef AT ROW 9.88 COL 111 COLON-ALIGNED NO-LABEL WIDGET-ID 122
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.Cliente_Recoge AT ROW 10.69 COL 17 NO-LABEL WIDGET-ID 164
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Sí", yes,
"No", no
          SIZE 12 BY .81
          FGCOLOR 8 FONT 6
     FacCPedi.CodAlm AT ROW 10.69 COL 36 COLON-ALIGNED WIDGET-ID 176
          LABEL "Tienda" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     FILL-IN-DesAlm AT ROW 10.69 COL 43 COLON-ALIGNED NO-LABEL WIDGET-ID 178
     FILL-IN-OrderType AT ROW 10.85 COL 106 COLON-ALIGNED WIDGET-ID 182
     "Redondedo del P.U.:" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 8 COL 93 WIDGET-ID 100
     "Stock de Letras" VIEW-AS TEXT
          SIZE 15.14 BY .69 AT ROW 9.08 COL 92 WIDGET-ID 150
          BGCOLOR 15 FGCOLOR 9 FONT 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 6.04 COL 105.14 WIDGET-ID 84
     "Comprobante:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 5.31 COL 101.14 WIDGET-ID 106
     "Cliente Recoge?" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 10.96 COL 2 WIDGET-ID 168
          FGCOLOR 8 FONT 6
     RECT-27 AT ROW 1 COL 1 WIDGET-ID 180
     RECT-25 AT ROW 8.81 COL 1 WIDGET-ID 172
     RECT-26 AT ROW 8.81 COL 90 WIDGET-ID 174
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.FacCPedi
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
      TABLE: B-DPEDI B "?" ? INTEGRAL FacDPedi
      TABLE: BONIFICACION T "?" ? INTEGRAL FacDPedi
      TABLE: ITEM T "SHARED" ? INTEGRAL FacDPedi
      TABLE: ITEM-1 T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: ITEM-2 T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: ITEM-LE T "?" ? INTEGRAL FacDPedi
      TABLE: PEDI T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: T-DPEDI T "?" ? INTEGRAL FacDPedi
   END-TABLES.
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
         HEIGHT             = 10.77
         WIDTH              = 131.43.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR FILL-IN FacCPedi.Atencion IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR BUTTON BUTTON-Turno-Avanza IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-Turno-Avanza:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-Turno-Retrocede IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-Turno-Retrocede:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FacCPedi.CodAlm IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.CodPos IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.DirCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.e-mail IN FRAME F-Main
   ALIGN-L EXP-LABEL EXP-FORMAT                                         */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Nomtar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FaxCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.FchEnt IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FchPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.fchven IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN-1:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-CodPos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DesAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-marco IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-OrderType IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-sede IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX FacCPedi.FlgIgv IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FmaPgo IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.Glosa IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.Libre_c01 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.NomCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN FacCPedi.NroCard IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.ordcmp IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN FacCPedi.Sede IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.TpoCmb IN FRAME F-Main
   NO-DISPLAY EXP-LABEL                                                 */
ASSIGN 
       FacCPedi.TpoCmb:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN txtStkLetras IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
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

&Scoped-define SELF-NAME BUTTON-Turno-Avanza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Turno-Avanza V-table-Win
ON CHOOSE OF BUTTON-Turno-Avanza IN FRAME F-Main /* Button 1 */
DO:
  FIND NEXT ExpTurno WHERE expturno.codcia = s-codcia
    AND expturno.coddiv = s-coddiv
    AND expturno.block = s-codter
    AND expturno.fecha = TODAY
    AND expturno.estado = 'P'
    NO-LOCK NO-ERROR.
  IF AVAILABLE ExpTurno THEN DO:
    FILL-IN-1:SCREEN-VALUE = TRIM(ExpTurno.Tipo) + '-' +
                            TRIM(STRING(ExpTurno.Turno)).
    FIND GN-CLIE WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = expturno.codcli NO-LOCK NO-ERROR.
    IF AVAILABLE GN-CLIE
    THEN DISPLAY 
                gn-clie.codcli @ FacCPedi.CodCli            
                gn-clie.nomcli @ FacCPedi.NomCli
                gn-clie.dircli @ FacCPedi.DirCli 
                gn-clie.nrocard @ FacCPedi.NroCard 
                gn-clie.ruc @ FacCPedi.RucCli
                WITH FRAME {&FRAME-NAME}.
  END.
  APPLY 'ENTRY':U TO FacCPedi.CodCli.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Turno-Retrocede
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Turno-Retrocede V-table-Win
ON CHOOSE OF BUTTON-Turno-Retrocede IN FRAME F-Main /* Button turno avanza 2 */
DO:
  FIND PREV ExpTurno WHERE expturno.codcia = s-codcia
    AND expturno.coddiv = s-coddiv
    AND expturno.block = s-codter
    AND expturno.fecha = TODAY
    AND expturno.estado = 'P'
    NO-LOCK NO-ERROR.
  IF AVAILABLE ExpTurno THEN DO:
    FILL-IN-1:SCREEN-VALUE = TRIM(ExpTurno.Tipo) + '-' +
                            TRIM(STRING(ExpTurno.Turno)).
    FIND GN-CLIE WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = expturno.codcli NO-LOCK NO-ERROR.
    IF AVAILABLE GN-CLIE
    THEN DISPLAY 
                gn-clie.codcli @ FacCPedi.CodCli            
                gn-clie.nomcli @ FacCPedi.NomCli
                gn-clie.dircli @ FacCPedi.DirCli 
                gn-clie.nrocard @ FacCPedi.NroCard 
                gn-clie.ruc @ FacCPedi.RucCli
                WITH FRAME {&FRAME-NAME}.
  END.
  APPLY 'ENTRY':U TO FacCPedi.CodCli.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.Cmpbnte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.Cmpbnte V-table-Win
ON VALUE-CHANGED OF FacCPedi.Cmpbnte IN FRAME F-Main /* Tipo Comprobante */
DO:
    DO WITH FRAM {&FRAME-NAME}:
        IF SELF:SCREEN-VALUE = 'FAC' 
            AND FacCPedi.CodCli:SCREEN-VALUE <> '11111111112'
            THEN DO:
            FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                AND gn-clie.CodCli = FacCPedi.CodCli:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
            ASSIGN
                FacCPedi.DirCli:SENSITIVE = NO
                FacCPedi.NomCli:SENSITIVE = NO
                FacCPedi.Atencion:SENSITIVE = NO.
            IF AVAILABLE gn-clie THEN DO:
                ASSIGN
                    FacCPedi.DirCli:SCREEN-VALUE = GN-CLIE.DirCli
                    FacCPedi.NomCli:SCREEN-VALUE = GN-CLIE.NomCli
                    FacCPedi.RucCli:SCREEN-VALUE = gn-clie.Ruc.
            END.
        END.
        ELSE DO:
            ASSIGN
                FacCPedi.DirCli:SENSITIVE = YES
                FacCPedi.NomCli:SENSITIVE = YES
                FacCPedi.Atencion:SENSITIVE = YES.
            IF FacCPedi.CodCli:SCREEN-VALUE = '11111111112' THEN FacCPedi.RucCli:SENSITIVE = YES.
        END.
        S-CMPBNTE = SELF:SCREEN-VALUE.
        /*RUN Procesa-Handle IN lh_Handle ('Recalculo').*/
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodCli V-table-Win
ON LEAVE OF FacCPedi.CodCli IN FRAME F-Main /* Cliente */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  DEF VAR LogRecalcular AS LOG INIT NO NO-UNDO.

  IF s-ClientesVIP = YES THEN DO:
      RUN vtagn/p-clie-expo.r (SELF:SCREEN-VALUE, s-TpoPed, pCodDiv).
      IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  END.

  /* ****************************************************** */
  /* RHC 25/04/2020 Cliente Nuevo solo para VENTAS DELIVERY */
  /* ****************************************************** */
  IF s-CodDiv = '00101' THEN DO:
      FIND FIRST gn-clie WHERE gn-clie.CodCia = CL-CODCIA
          AND  gn-clie.CodCli = SELF:SCREEN-VALUE 
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-clie THEN DO:      /* CREA EL CLIENTE NUEVO */
          S-CODCLI = SELF:SCREEN-VALUE.
          RUN vtamay/d-regcli.r (INPUT-OUTPUT S-CODCLI).
          IF TRUE <> (S-CODCLI > "") THEN DO:
              APPLY "ENTRY" TO Faccpedi.CodCli.
              RETURN NO-APPLY.
          END.
          FIND FIRST gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
              AND  gn-clie.CodCli = S-CODCLI 
              NO-LOCK NO-ERROR.
          SELF:SCREEN-VALUE = s-codcli.
          LogRecalcular = YES.
      END.
  END.
  ELSE DO:
      /* ****************************************************** */
      IF s-CodCli <> SELF:SCREEN-VALUE THEN LogRecalcular = YES.
      /* ****************************************************** */
  END.
  s-CodCli = SELF:SCREEN-VALUE.
  /* ****************************************************** */
  /* **************************************** */
  /* RHC 22/07/2020 Nuevo bloqueo de clientes */
  /* **************************************** */
  RUN pri/p-verifica-cliente.r (INPUT s-CodCli,
                                INPUT s-CodDoc,
                                INPUT s-CodDiv).
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  /* ****************************************** */
  /* Cargamos las condiciones de venta válidas */
  /* ****************************************** */
  FIND gn-clie WHERE gn-clie.codcia  = cl-codcia AND gn-clie.codcli = s-codcli NO-LOCK.
   IF s-CodDiv = '00101' THEN DO:
       /* WhatsApp */
       RUN vtagn/p-fmapgo-valido.r (s-codcli, s-tpoped, s-CodDiv, OUTPUT s-cndvta-validos).
   END.
   ELSE DO:
       RUN vtagn/p-fmapgo-valido.r (s-codcli, s-tpoped, pCodDiv, OUTPUT s-cndvta-validos).
   END.   

   IF TRUE <> (FacCPedi.FmaPgo:SCREEN-VALUE > "") THEN s-FmaPgo = ENTRY(1, s-cndvta-validos).
   ELSE s-FmaPgo = FacCPedi.FmaPgo:SCREEN-VALUE.
  /* ****************************************** */
  /* DATOS DEL CLIENTE */
  /* ****************************************** */
  DISPLAY 
      gn-clie.NomCli @ Faccpedi.NomCli
      gn-clie.Ruc    @ Faccpedi.RucCli
      gn-clie.DirCli @ Faccpedi.DirCli
      s-FmaPgo       @ FacCPedi.FmaPgo
      gn-clie.NroCard @ FacCPedi.NroCard
      gn-clie.CodVen WHEN (TRUE <> (Faccpedi.CodVen:SCREEN-VALUE > '')) @ Faccpedi.CodVen 
      "@@@"          @ FacCPedi.Sede
      WITH FRAME {&FRAME-NAME}.
   APPLY 'LEAVE':U TO FacCPedi.Sede.
  /* ****************************************** */
  /* Tarjeta */
  /* ****************************************** */
  FIND FIRST Gn-Card WHERE Gn-Card.NroCard = gn-clie.nrocard NO-LOCK NO-ERROR.
  IF AVAILABLE GN-CARD 
  THEN ASSIGN
            F-Nomtar:SCREEN-VALUE = gn-card.NomCard
            FacCPedi.NroCard:SENSITIVE = NO.
  ELSE ASSIGN
            F-Nomtar:SCREEN-VALUE = ''
            FacCPedi.NroCard:SENSITIVE = YES.
  /* ****************************************** */
  /* Ubica la Condicion Venta */
  /* ****************************************** */
  FIND FIRST gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt 
  THEN DO:
       F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
  END.  
  ELSE F-CndVta:SCREEN-VALUE = "".

  /* Vendedor */
  F-NomVen:SCREEN-VALUE = "".
  FIND FIRST gn-ven WHERE gn-ven.CodCia = S-CODCIA 
      AND  gn-ven.CodVen = FacCPedi.CodVen:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-ven THEN F-NomVen:SCREEN-VALUE = gn-ven.NomVen.

  /* CLASIFICACIONES DEL CLIENTE */
  Faccpedi.FaxCli:SCREEN-VALUE = SUBSTRING(TRIM(gn-clie.clfcli) + "00",1,2) +
                                SUBSTRING(TRIM(gn-clie.clfcli2) + "00",1,2).

  /* Determina si es boleta o factura */
  IF TRUE <> (FacCPedi.RucCli:SCREEN-VALUE > '')
  THEN Faccpedi.Cmpbnte:SCREEN-VALUE = 'BOL'.
  ELSE Faccpedi.Cmpbnte:SCREEN-VALUE = 'FAC'.

  /* RHC 07/12/2015 SOLO CLIENTE HABILITADOS CONTRATO MARCO */
  IF LOOKUP(s-TpoPed, "R,M,E") = 0 AND s-adm-new-record = "YES" THEN DO:
      FIND TabGener WHERE TabGener.CodCia = s-codcia
          AND TabGener.Clave = "%MARCO"
          AND TabGener.Codigo = SELF:SCREEN-VALUE
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE TabGener THEN DO:
          ASSIGN Faccpedi.Libre_C04:SCREEN-VALUE = "" 
          S-TPOMARCO = "".
      END.
      IF s-tpoped <> 'TBLT' THEN DO:
          IF AVAILABLE TabGener THEN Faccpedi.Libre_C04:SENSITIVE = YES.
          ELSE ASSIGN Faccpedi.Libre_C04:SENSITIVE = NO.
      END.
  END.
  
  /* Stock de Letras */
  txtStkLetras:SCREEN-VALUE = "0".
  FIND FIRST ccbstklet WHERE ccbstklet.codcia = s-codcia AND 
      ccbstklet.codclie = gn-clie.codcli NO-LOCK NO-ERROR.
  IF AVAILABLE ccbstklet THEN txtStkLetras:SCREEN-VALUE = STRING(ccbstklet.qstklet,"->,>>99").

  IF LogRecalcular = YES THEN RUN Procesa-Handle IN lh_Handle ('Recalculo').

  APPLY 'VALUE-CHANGED' TO Faccpedi.Cmpbnte.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodCli V-table-Win
ON LEFT-MOUSE-DBLCLICK OF FacCPedi.CodCli IN FRAME F-Main /* Cliente */
OR f8 OF FacCPedi.CodCli
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?
        output-var-2 = ''
        output-var-3 = ''.
    CASE TRUE:
        WHEN s-TpoPed = "M" THEN DO:
            RUN vtagn/c-gn-clie-pub ('Clientes').
        END.
        WHEN s-ClientesVIP = YES THEN DO:
            input-var-1 = pCodDiv.
            RUN vtagn/d-clientes-vip ('Clientes Expolibreria').
        END.
        OTHERWISE DO:
            RUN vtagn/c-gn-clie-01 ('Clientes').
        END.
    END CASE.
/*     IF s-TpoPed = "M" THEN input-var-1 = "006".             */
/*     IF s-ClientesVIP = YES THEN DO:                         */
/*         input-var-1 = pCodDiv.                              */
/*         RUN vtagn/d-clientes-vip ('Clientes Expolibreria'). */
/*     END.                                                    */
/*     ELSE DO:                                                */
/*         RUN vtagn/c-gn-clie-01 ('Clientes').                */
/*     END.                                                    */
    IF output-var-1 <> ? THEN FacCPedi.CodCli:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodMon V-table-Win
ON VALUE-CHANGED OF FacCPedi.CodMon IN FRAME F-Main /* Cod!mon */
DO:
  S-CODMON = INTEGER(Faccpedi.CodMon:SCREEN-VALUE).
  RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodPos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodPos V-table-Win
ON LEAVE OF FacCPedi.CodPos IN FRAME F-Main /* Código Postal */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  FIND Almtabla WHERE almtabla.Tabla = "CP"
      AND almtabla.Codigo = FacCPedi.CodPos:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almtabla THEN FILL-IN-CodPos:SCREEN-VALUE = almtabla.Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodVen V-table-Win
ON LEAVE OF FacCPedi.CodVen IN FRAME F-Main /* Vendedor */
DO:
  F-NomVen:SCREEN-VALUE = "".
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
    AND  gn-ven.CodVen = FacCPedi.CodVen:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-ven THEN DO:
      MESSAGE "Vendedor NO válido" VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = "".
      RETURN NO-APPLY.
  END.
  F-NomVen:SCREEN-VALUE = gn-ven.NomVen.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodVen V-table-Win
ON LEFT-MOUSE-DBLCLICK OF FacCPedi.CodVen IN FRAME F-Main /* Vendedor */
OR f8 OF FacCPedi.CodVen
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''.
    RUN lkup/c-vende ('Vendedor').
    IF output-var-1 <> ? THEN FacCPedi.CodVen:SCREEN-VALUE = output-var-2.
    /*APPLY 'ENTRY':U TO FacCPedi.CodVen.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.FchEnt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FchEnt V-table-Win
ON LEAVE OF FacCPedi.FchEnt IN FRAME F-Main /* Fecha Entrega - Cliente */
DO:
    IF INPUT {&self-name} < ( (INPUT Faccpedi.FchPed) + s-MinimoDiasDespacho) THEN DO:
        MESSAGE 'No se puede despachar antes del' ( (INPUT Faccpedi.FchPed) + s-MinimoDiasDespacho)
            VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF s-MinimoPesoDia > 0 AND INPUT {&SELF-NAME} <> ? AND RETURN-VALUE = 'YES' THEN DO:
        DEF VAR x-Cuentas AS DEC NO-UNDO.
        DEF VAR x-Tope    AS DEC NO-UNDO.
        x-Tope = s-MinimoPesoDia * (1 + s-MaximaVarPeso / 100).
        FOR EACH B-CPEDI NO-LOCK WHERE B-CPEDI.codcia = s-codcia
            AND B-CPEDI.coddiv = s-coddiv
            AND B-CPEDI.coddoc = s-coddoc
            AND B-CPEDI.flgest <> 'A'
            AND B-CPEDI.fchped >= INPUT Faccpedi.FchPed
            AND B-CPEDI.fchent = INPUT {&SELF-NAME}:
            x-Cuentas = x-Cuentas + B-CPEDI.Libre_d02.
        END.            
        IF x-Cuentas > x-Tope THEN DO:
            MESSAGE 'Ya se cubrieron los despachos para ese día' 
                VIEW-AS ALERT-BOX WARNING.
            RETURN NO-APPLY.
        END.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.FlgIgv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FlgIgv V-table-Win
ON VALUE-CHANGED OF FacCPedi.FlgIgv IN FRAME F-Main /* Afecto a IGV */
DO:
    s-FlgIgv = INPUT {&self-name}.
    IF s-FlgIgv = YES THEN s-PorIgv = FacCfgGn.PorIgv.
    RUN Procesa-Handle IN lh_Handle ('Recalculo').
    IF s-FlgIgv = NO THEN DO:
        MESSAGE "AL DESMARCAR EL CAMPO IGV, TENDRA INCONVENIENTE CON LA EMISIÓN Y PROCESO DE LA FACTURA"
            VIEW-AS ALERT-BOX WARNING.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FmaPgo V-table-Win
ON LEAVE OF FacCPedi.FmaPgo IN FRAME F-Main /* Condición de Venta */
DO:
    F-CndVta:SCREEN-VALUE = ''.
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND FIRST gn-convt WHERE gn-convt.Codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-convt THEN DO:
        MESSAGE 'Condición de venta NO válida' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
    /* Filtrado de las condiciones de venta */
    IF LOOKUP(SELF:SCREEN-VALUE, s-cndvta-validos) = 0 THEN DO:
        MESSAGE 'Condición de venta NO autorizada para este cliente'
            VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    IF s-FmaPgo <> SELF:SCREEN-VALUE THEN DO:
        s-FmaPgo = SELF:SCREEN-VALUE.
        RUN Procesa-Handle IN lh_Handle ('Recalculo').
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FmaPgo V-table-Win
ON LEFT-MOUSE-DBLCLICK OF FacCPedi.FmaPgo IN FRAME F-Main /* Condición de Venta */
OR f8 OF FacCPedi.FmaPgo
DO:
    ASSIGN
        input-var-1 = s-cndvta-validos
        input-var-2 = ''
        input-var-3 = ''.
    RUN vta/d-cndvta.r.
    IF output-var-1 <> ? THEN FacCPedi.Fmapgo:SCREEN-VALUE = output-var-2.
    /*APPLY 'ENTRY':U TO FacCPedi.Fmapgo.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.Libre_c04
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.Libre_c04 V-table-Win
ON VALUE-CHANGED OF FacCPedi.Libre_c04 IN FRAME F-Main /* Libre_c04 */
DO:
    S-TPOMARCO = SELF:SCREEN-VALUE.
    RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.Libre_d01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.Libre_d01 V-table-Win
ON VALUE-CHANGED OF FacCPedi.Libre_d01 IN FRAME F-Main /* Libre_d01 */
DO:
    s-NroDec = INTEGER(SELF:SCREEN-VALUE).
    RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.NroCard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.NroCard V-table-Win
ON LEAVE OF FacCPedi.NroCard IN FRAME F-Main /* Tarjeta */
DO:
    F-NomTar:SCREEN-VALUE = ''.
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    ASSIGN
      SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999") NO-ERROR.
    FIND Gn-Card WHERE Gn-Card.NroCard = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-Card THEN DO:
        MESSAGE 'Tarjeta de Cliente NO válida' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    F-NomTar:SCREEN-VALUE = GN-CARD.NomClie[1].
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.NroCard V-table-Win
ON LEFT-MOUSE-DBLCLICK OF FacCPedi.NroCard IN FRAME F-Main /* Tarjeta */
OR f8 OF FacCPedi.NroCard
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''.
    RUN lkup/c-gncard ('Tarjetas').
    IF output-var-1 <> ? THEN FacCPedi.NroCard:SCREEN-VALUE = output-var-2.
    /*APPLY 'ENTRY':U TO FacCPedi.NroCard.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.Sede
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.Sede V-table-Win
ON LEAVE OF FacCPedi.Sede IN FRAME F-Main /* Lugar de Entrega */
DO:
    FILL-IN-Sede:SCREEN-VALUE = ''.
    FIND gn-clied WHERE gn-clied.codcia = cl-codcia
       AND gn-clied.codcli = Faccpedi.codcli:SCREEN-VALUE
       AND gn-clied.sede = Faccpedi.sede:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clied THEN DO:
        FILL-IN-Sede:SCREEN-VALUE = GN-ClieD.dircli. 
        FacCPedi.Glosa:SCREEN-VALUE = (IF TRUE <> (FacCPedi.Glosa:SCREEN-VALUE > '') 
                                       THEN Gn-ClieD.DirCli 
                                       ELSE FacCPedi.Glosa:SCREEN-VALUE).
        FacCPedi.CodPos:SCREEN-VALUE = Gn-ClieD.Codpos.
        APPLY 'LEAVE':U TO FacCPedi.CodPos.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.Sede V-table-Win
ON LEFT-MOUSE-DBLCLICK OF FacCPedi.Sede IN FRAME F-Main /* Lugar de Entrega */
OR f8 OF FacCPedi.Sede
DO:
    ASSIGN
      input-var-1 = FacCPedi.CodCli:SCREEN-VALUE
      input-var-2 = ""
      input-var-3 = ''
      output-var-1 = ?
      output-var-2 = ''
      output-var-3 = ''.
    RUN lkup/c-gn-clied-todo.r ('SEDES').
/*     ASSIGN                                       */
/*       input-var-1 = FacCPedi.CodCli:SCREEN-VALUE */
/*       input-var-2 = FacCPedi.NomCli:SCREEN-VALUE */
/*       input-var-3 = ''                           */
/*       output-var-1 = ?                           */
/*       output-var-2 = ''                          */
/*       output-var-3 = ''.                         */
/*     RUN vta/c-clied.                             */
    IF output-var-1 <> ?
        THEN ASSIGN 
              FILL-IN-Sede:SCREEN-VALUE = output-var-3
              FacCPedi.Sede:SCREEN-VALUE = output-var-2.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-datos-cliente V-table-Win 
PROCEDURE Actualiza-datos-cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF AVAILABLE gn-clie AND s-codcli <> '' THEN DO:
    IF gn-clie.codcli BEGINS '1111111111' THEN RETURN.

    RUN vtamay/gVtaCli.r (ROWID(gn-clie)).
    /*IF RETURN-VALUE <> "ADM-ERROR"  THEN APPLY "LEAVE":U TO FacCPedi.CodCli IN FRAME {&FRAME-NAME}.*/
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE actualiza-prepedido V-table-Win 
PROCEDURE actualiza-prepedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ACTUALIZA LA COTIZACION EN BASE AL PEDIDO AL CREDITO */

  DEFINE INPUT PARAMETER pFactor AS INT.    /* +1 actualiza    -1 desactualiza */
  DEFINE OUTPUT PARAMETER pError AS CHAR NO-UNDO.

  DEFINE VARIABLE I-NRO AS INTEGER INIT 0 NO-UNDO.

  DEFINE BUFFER B-CPEDI FOR FacCPedi.

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      {lib/lock-genericov3.i ~
          &Tabla="B-CPedi" ~
          &Condicion="B-CPedi.CodCia = FacCPedi.CodCia ~
          AND  B-CPedi.CodDiv = FacCPedi.CodDiv ~
          AND  B-CPedi.CodDoc = FacCPedi.CodRef ~
          AND  B-CPedi.NroPed = FacCPedi.NroRef" ~
          &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
          &Accion="RETRY" ~
          &Mensaje="NO" ~
          &txtMensaje="pMensaje"
          &TipoError="UNDO, RETURN 'ADM-ERROR'"}
      IF pFactor = +1 THEN ASSIGN B-CPedi.FlgEst = "C".
      ELSE B-CPedi.FlgEst = "P".
  END.
  IF AVAILABLE B-CPedi THEN RELEASE B-CPedi.

  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  {src/adm/template/row-list.i "FacCPedi"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "FacCPedi"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aritmetica-de-Sunat V-table-Win 
PROCEDURE Aritmetica-de-Sunat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Solo RIQRA
------------------------------------------------------------------------------*/

IF NOT AVAILABLE Faccpedi THEN RETURN.
IF LOOKUP(FacCPedi.FlgEst,"PV,T,I,P") = 0 THEN DO:
    MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
/* Si tiene atenciones parciales tambien se bloquea */
FIND FIRST facdpedi OF faccpedi WHERE CanAte <> 0 NO-LOCK NO-ERROR.
IF AVAILABLE facdpedi THEN DO:
    MESSAGE "Tiene atenciones parciales" SKIP "Acceso denegado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
/* ****************************************************************************************** */
/* Importes SUNAT */
/* ****************************************************************************************** */
DEF VAR hProc AS HANDLE NO-UNDO.

RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                             INPUT Faccpedi.CodDoc,
                             INPUT Faccpedi.NroPed,
                             OUTPUT pMensaje).
DELETE PROCEDURE hProc.
IF RETURN-VALUE = "ADM-ERROR" THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
RUN Procesa-Handle IN lh_handle("Repinta-Todo").


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Pedido V-table-Win 
PROCEDURE Borra-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FOR EACH FacDPedi OF FacCPedi NO-LOCK:
      {lib/lock-genericov3.i ~
          &Tabla="B-DPEDI" ~
          &Condicion="ROWID(B-DPEDI) = ROWID(FacDPedi)" ~
          &Bloqueo="EXCLUSIVE-LOCK" ~
          &Accion="RETRY" ~
          &Mensaje="YES" ~
          &TipoError="UNDO, RETURN 'ADM-ERROR'"}
      DELETE B-DPEDI.
  END.
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal V-table-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE ITEM.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Historico-Cotizaciones V-table-Win 
PROCEDURE Captura-Historico-Cotizaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF s-codcli = '' THEN RETURN.
  DEF VAR pError AS CHAR NO-UNDO.
  RUN vta2/d-historicocotcredmay (s-codcli, "COT", OUTPUT pError).
  IF pError = "ADM-ERROR" THEN RETURN.
  RUN Procesa-Handle IN lh_handle ("Recalculo").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal V-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE ITEM.
EMPTY TEMP-TABLE ITEM-LE.

DEF VAR LogRecalcular AS LOG INIT NO NO-UNDO.

FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.Libre_c05 <> "OF",
    FIRST Almmmatg OF Facdpedi NO-LOCK:
    
    CREATE ITEM.
    BUFFER-COPY Facdpedi TO ITEM.
    LogRecalcular = NO.
    /* 01/08/2022: Limpiamos descuentos finales */
    /* Por Descuentos Acumulados */
    IF ITEM.Libre_c04 > '' AND LOOKUP(ITEM.Libre_c04, 'PROM,VOL') = 0 THEN DO:
        LogRecalcular = YES.
        ASSIGN
            ITEM.Por_Dsctos[1] = 0
            ITEM.Por_Dsctos[2] = 0
            ITEM.Por_Dsctos[3] = 0
            ITEM.Libre_c04 = "".
    END.
    /* Por Descuentos Acumulados */
    IF ITEM.Libre_d03 > 0 THEN DO:
        ASSIGN
            ITEM.Por_Dsctos[1] = 0
            ITEM.Por_Dsctos[2] = 0
            ITEM.Por_Dsctos[3] = 0
            ITEM.CanPed = ITEM.CanPed - ITEM.Libre_d03
            ITEM.Libre_d03 = 0.
        LogRecalcular = YES.
    END.
    IF LogRecalcular = YES THEN DO:
        /* ARTIFICIO */
        Fi-Mensaje = "CARGANDO DETALLE: " + Facdpedi.codmat.
        DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
        
        DEF VAR s-UndVta AS CHAR NO-UNDO.
        DEF VAR f-factor AS DECI NO-UNDO.
        DEF VAR f-PreBas AS DECI NO-UNDO.
        DEF VAR f-PreVta AS DECI NO-UNDO.
        DEF VAR z-Dsctos AS DECI NO-UNDO.
        DEF VAR y-Dsctos AS DECI NO-UNDO.
        DEF VAR x-TipDto AS CHAR NO-UNDO.
        DEF VAR x-CanPed AS DECI NO-UNDO.
        DEF VAR f-Dsctos AS DECI NO-UNDO.
        DEF VAR f-FleteUnitario AS DECI NO-UNDO.
        RUN {&precio-venta-general} ((IF S-TPOMARCO = "SI" THEN "M" ELSE s-TpoPed),
                                     pCodDiv,
                                     s-CodCli,
                                     s-CodMon,
                                     INPUT-OUTPUT s-UndVta,
                                     OUTPUT f-Factor,
                                     ITEM.codmat,
                                     s-FmaPgo,
                                     (ITEM.CanPed * ITEM.Factor),
                                     s-NroDec,
                                     OUTPUT f-PreBas,
                                     OUTPUT f-PreVta,
                                     OUTPUT f-Dsctos,
                                     OUTPUT y-Dsctos,
                                     OUTPUT z-Dsctos,
                                     OUTPUT x-TipDto,
                                     "",     /* ClfCli: lo ingresamos solo si se quiere forzar la clasificacion */
                                     OUTPUT f-FleteUnitario,
                                     "",
                                     NO,
                                     OUTPUT pMensaje).
        IF RETURN-VALUE <> 'ADM-ERROR' 
            THEN ASSIGN
            ITEM.PreUni = F-PREVTA
            ITEM.PorDto = f-Dsctos
            ITEM.PreBas = F-PreBas 
            ITEM.PreVta[1] = F-PreVta
            ITEM.Por_Dsctos[2] = z-Dsctos
            ITEM.Por_Dsctos[3] = y-Dsctos
            ITEM.Libre_c04 = x-TipDto
            ITEM.Libre_d02 = f-FleteUnitario
            .
        /* ***************************************************************** */
        {vtagn/CalculoDetalleMayorCredito.i &Tabla="ITEM" }
        /* ***************************************************************** */
        /* ***************************************************************** */
/*         ASSIGN                                                                                    */
/*             ITEM.PreUni = ROUND(ITEM.PreBas + ITEM.Libre_d02, s-NroDec)                           */
/*             ITEM.ImpLin = ITEM.CanPed * ITEM.PreUni *                                             */
/*                             ( 1 - ITEM.Por_Dsctos[1] / 100 ) *                                    */
/*                             ( 1 - ITEM.Por_Dsctos[2] / 100 ) *                                    */
/*                             ( 1 - ITEM.Por_Dsctos[3] / 100 ).                                     */
/*         IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0           */
/*             THEN ITEM.ImpDto = 0.                                                                 */
/*         ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.                               */
/*         ASSIGN                                                                                    */
/*             ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)                                                   */
/*             ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).                                                  */
/*         IF ITEM.AftIgv                                                                            */
/*             THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ). */
        /* ***************************************************************** */
    END.
    IF ITEM.CanPed <= 0 THEN DELETE ITEM.
END.
FOR EACH Facdpedi NO-LOCK WHERE Facdpedi.codcia = Faccpedi.codcia
    AND Facdpedi.coddiv = Faccpedi.coddiv
    AND Facdpedi.coddoc = "CLE"     /* Cot Lista Express */
    AND Facdpedi.nroped = Faccpedi.nroped:
    CREATE ITEM-LE.
    BUFFER-COPY Facdpedi TO ITEM-LE.
END.

HIDE FRAME F-Proceso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CONTROL-IBC V-table-Win 
PROCEDURE CONTROL-IBC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Rpta AS CHAR.
                                  
/* Cargamos el temporal con las diferencias */
s-pendiente-ibc = NO.
RUN IBC-Diferencias.
FIND FIRST T-DPEDI NO-LOCK NO-ERROR.
IF NOT AVAILABLE T-DPEDI THEN RETURN 'OK'.

RUN vta/d-ibc-dif (OUTPUT x-Rpta).
IF x-Rpta = "ADM-ERROR" THEN RETURN "ADM-ERROR".

{adm/i-DocPssw.i s-CodCia 'IBC' ""UPD""}

/* Continua la grabacion */
s-pendiente-ibc = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Copia-Items V-table-Win 
PROCEDURE Copia-Items :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE ITEM.

    DEFINE VAR x-item AS INT.
    DEFINE VAR x-ok AS LOG.

    x-ok = YES.
    IF faccpedi.coddoc = 'PLE' AND faccpedi.OrderType = "PREMIUM" THEN x-ok = NO.
    

    FOR EACH facdPedi OF faccPedi NO-LOCK WHERE Facdpedi.Libre_c05 <> "OF":
        IF x-ok OR (faccpedi.coddoc = "PLE" AND faccpedi.OrderType = "PREMIUM" AND NOT (TRUE <> (Facdpedi.CodMatWeb > "")))  THEN DO:

            x-item = x-item + 1.

            CREATE ITEM.
    
            ASSIGN
                ITEM.AftIgv = Facdpedi.AftIgv
                ITEM.AftIsc = Facdpedi.AftIsc
                /*ITEM.AlmDes = Facdpedi.AlmDes*/
                ITEM.AlmDes = ENTRY(1,s-CodAlm)
                ITEM.CanPed = Facdpedi.CanPed
                ITEM.CanAte = 0
                ITEM.CanPick = Facdpedi.CanPed
                ITEM.CanSol = 0
                ITEM.CodCia = Facdpedi.CodCia
                ITEM.CodCli = Facdpedi.CodCli
                ITEM.CodDiv = Facdpedi.CodDiv
                ITEM.CodDoc = Facdpedi.CodDoc
                ITEM.codmat = Facdpedi.CodMat
                ITEM.Factor = Facdpedi.Factor
                ITEM.FchPed = TODAY
                ITEM.NroItm = Facdpedi.NroItm
                ITEM.Pesmat = Facdpedi.PesMat
                ITEM.TipVta = Facdpedi.TipVta
                ITEM.UndVta = Facdpedi.UndVta.
            IF ITEM.Libre_d03 > 0 THEN DO:
                ASSIGN
                    ITEM.Por_Dsctos[1] = 0
                    ITEM.Por_Dsctos[2] = 0
                    ITEM.Por_Dsctos[3] = 0
                    ITEM.CanPed = ITEM.CanPed - ITEM.Libre_d03
                    ITEM.Libre_d03 = 0.
            END.
            /* PrePedido ListaExpress 2022 */
            IF faccpedi.coddoc = "PLE" AND faccpedi.OrderType = "PREMIUM" THEN DO:
                IF NOT (TRUE <> (Facdpedi.CodMatWeb > "")) THEN DO:
                    ASSIGN 
                        ITEM.codmat = Facdpedi.CodMatWeb
                        ITEM.NroItm = x-item.
                END.
            END.
            IF ITEM.CanPed <= 0 THEN DELETE ITEM.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CREATE-TRANSACION V-table-Win 
PROCEDURE CREATE-TRANSACION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-serie-numero AS CHAR.        
        
PRINCIPAL:                                                                                  
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {vta2/icorrelativosecuencial.i &Codigo = s-coddoc &Serie = s-nroser}

    /* Ic - 16Ene2023, para evitar bloqueos de la tabla faccorre */
    x-serie-numero = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999").
    /* Ic - 16Ene2023 */
    ASSIGN 
        FacCPedi.CodCia = S-CODCIA
        FacCPedi.CodDiv = S-CODDIV
        FacCPedi.CodDoc = s-coddoc 
        /* FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")  Ic - 16Ene2023 */
        FacCPedi.NroPed = x-serie-numero
        FacCPedi.FchPed = TODAY 
        FacCPedi.Hora   = STRING(TIME,"HH:MM:SS")
        FacCPedi.TpoPed = s-TpoPed
        FacCPedi.FlgEst = (IF FacCPedi.CodCli BEGINS "SYS" THEN "I" ELSE "P")     /* APROBADO */
        FacCPedi.Lista_de_Precios = FacCPedi.Libre_c01      /* OJO */
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* NUEVA COTIZACION */
    ASSIGN
        Faccpedi.Usuario = S-USER-ID
        Faccpedi.Hora   = STRING(TIME,"HH:MM:SS").
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    RELEASE FacCorre NO-ERROR.
    /*
    ASSIGN
        FacCPedi.CodAlm = s-CodAlm    /* Lista de Almacenes Válidos de Venta */
    */
    /* DATOS SUPERMERCADOS */
    CASE s-TpoPed:
        WHEN "S" THEN DO:
            IF s-Import-Ibc = YES THEN FacCPedi.Libre_C05 = "1".
            IF s-Import-B2B = YES THEN FacCPedi.Libre_C05 = "3".  /* OJO*/
        END.
    END CASE.
    /*  */
    IF lOrdenGrabada > '' THEN DO:
        DISABLE TRIGGERS FOR LOAD OF factabla.
        FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
            factabla.tabla = 'OC PLAZA VEA' AND 
            factabla.codigo = lOrdenGrabada EXCLUSIVE NO-ERROR.
        IF NOT AVAILABLE factabla THEN DO:
            CREATE factabla.
            ASSIGN 
                factabla.codcia = s-codcia
                factabla.tabla = 'OC PLAZA VEA'
                factabla.codigo = lOrdenGrabada
                factabla.campo-c[2] = STRING(NOW,"99/99/9999 HH:MM:SS").
        END.
    END.
    /* RHC 05/10/17 En caso de COPIAR una cotizacion hay que "limpiar" estos campos */
    ASSIGN
        Faccpedi.Libre_c02 = ""       /* "PROCESADO" por Abastecimientos */
        Faccpedi.LugEnt2   = ""
        .
    IF Faccpedi.CodRef = "PPV" THEN DO:
        RUN actualiza-prepedido ( +1, OUTPUT pMensaje ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.
END.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cuenta-Corriente V-table-Win 
PROCEDURE Cuenta-Corriente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN ccb/w-consul-cct2a.w(s-codcli).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Delete-Items-Cbo V-table-Win 
PROCEDURE Delete-Items-Cbo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Borra Bonificaciones
------------------------------------------------------------------------------*/

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Eliminamos Detalle */
    FOR EACH FacDPedi NO-LOCK WHERE FacDPedi.CodCia = Faccpedi.codcia AND
        FacDPedi.CodDiv = Faccpedi.coddiv AND
        FacDPedi.CodDoc = "CBO" AND
        FacDPedi.NroPed = Faccpedi.nroped:
        {lib/lock-genericov3.i ~
            &Tabla="B-DPEDI" ~
            &Condicion="ROWID(B-DPEDI) = ROWID(FacDPedi)" ~
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &txtMensaje="pMensaje" ~
            &TippoError="UNDO PRINCIPAL, RETURN 'ADM-ERROR'"}
        DELETE B-DPEDI.            
    END.
END.
IF AVAILABLE(FacDPedi) THEN RELEASE FacDPedi.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Delete-Items-Cot V-table-Win 
PROCEDURE Delete-Items-Cot :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Eliminamos Detalle */
    FOR EACH FacDPedi NO-LOCK WHERE FacDPedi.CodCia = Faccpedi.codcia AND
        FacDPedi.CodDiv = Faccpedi.coddiv AND
        FacDPedi.CodDoc = Faccpedi.coddoc AND
        FacDPedi.NroPed = Faccpedi.nroped:
        {lib/lock-genericov3.i ~
            &Tabla="B-DPEDI" ~
            &Condicion="ROWID(B-DPEDI) = ROWID(FacDPedi)" ~
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &txtMensaje="pMensaje" ~
            &TippoError="UNDO PRINCIPAL, RETURN 'ADM-ERROR'"}
        DELETE B-DPEDI.            
    END.
END.
IF AVAILABLE(FacDPedi) THEN RELEASE FacDPedi.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Delete-Items-Log V-table-Win 
PROCEDURE Delete-Items-Log :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF BUFFER b-logdsctosped FOR logdsctosped.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Eliminamos Detalle */
    FOR EACH logdsctosped NO-LOCK WHERE logdsctosped.CodCia = Faccpedi.codcia AND
        logdsctosped.CodPed = Faccpedi.coddoc AND
        logdsctosped.NroPed = Faccpedi.nroped:
        {lib/lock-genericov3.i ~
            &Tabla="b-logdsctosped" ~
            &Condicion="ROWID(b-logdsctosped) = ROWID(logdsctosped)" ~
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &txtMensaje="pMensaje" ~
            &TippoError="UNDO PRINCIPAL, RETURN 'ADM-ERROR'"}
        DELETE b-logdsctosped.
    END.
END.
IF AVAILABLE(LogDsctosPed) THEN RELEASE LogDsctosPed.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DESCUENTOS-FINALES V-table-Win 
PROCEDURE DESCUENTOS-FINALES :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  /* ************************************************************************************** */
  /* DESCUENTOS APLICADOS A TODA LA COTIZACION */
  /* ************************************************************************************** */
  DEF VAR hProc AS HANDLE NO-UNDO.
  RUN vtagn/ventas-library PERSISTENT SET hProc.
  RUN DCTO_VOL_LINEA IN hProc (INPUT ROWID(Faccpedi),
                               INPUT s-TpoPed,
                               INPUT pCodDiv,
                               OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN DCTO_VOL_SALDO IN hProc (INPUT ROWID(Faccpedi),
                               INPUT s-TpoPed,
                               INPUT pCodDiv,
                               OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN DCTO_VOL_SALDO_EVENTO IN hProc (INPUT ROWID(Faccpedi),
                                      INPUT s-TpoPed,
                                      INPUT pCodDiv,
                                      OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN DCTO_PRONTO_DESPACHO IN hProc (INPUT ROWID(Faccpedi),
                                     INPUT pCodDiv,
                                     OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  
  RUN DCTO_IMP_ACUM IN hProc (INPUT ROWID(Faccpedi),
                              INPUT pCodDiv,
                              OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  
/*   RUN DCTO_MAS_POR_MENOS IN hProc (INPUT ROWID(Faccpedi),      */
/*                                    INPUT pCodDiv,              */
/*                                    OUTPUT pMensaje).           */
/*   IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */

  /* 16-9-23: Este descuento va por encima de todos los anteriores C.Camus */
  RUN DCTO_VOL_ACUM_TIME IN hProc (INPUT ROWID(Faccpedi),
                                   INPUT pCodDiv,
                                   INPUT Faccpedi.CodCli,
                                   OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  DELETE PROCEDURE hProc.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Edi-Comparativo V-table-Win 
PROCEDURE Edi-Comparativo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF AVAILABLE FacCPedi AND FacCPedi.FlgEst <> "A" 
    THEN RUN vta2\r-impcot-superm (ROWID(FacCPedi)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Enviar-al-Administrador V-table-Win 
PROCEDURE Enviar-al-Administrador :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE Faccpedi OR Faccpedi.FlgEst <> "PV" THEN RETURN.
CASE s-Solicita-Aprobacion:
    WHEN YES THEN DO:
        MESSAGE 'Procedemos a enviar el Pedido Comercial al Administrador?'
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta1 AS LOG.
        IF rpta1 = NO THEN RETURN.
        FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES OR Faccpedi.FlgEst <> "PV" THEN DO:
            MESSAGE 'Pedido Comercial en uso por otro usuario o ya no está disponible para enviar adl Administrador'
                VIEW-AS ALERT-BOX ERROR.
        END.
        ELSE DO:
            ASSIGN
                Faccpedi.FlgEst = "PA".
        END.
    END.
    WHEN NO THEN DO:
        MESSAGE 'Procedemos a APROBAR el Pedido Comercial?'
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta2 AS LOG.
        IF rpta2 = NO THEN RETURN.
        FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES OR Faccpedi.FlgEst <> "PV" THEN DO:
            MESSAGE 'Pedido Comercial en uso por otro usuario o ya no está disponible para enviar adl Administrador'
                VIEW-AS ALERT-BOX ERROR.
        END.
        ELSE DO:
            ASSIGN
                Faccpedi.FlgEst = "P".
        END.
    END.
END CASE.
FIND CURRENT Faccpedi NO-LOCK NO-ERROR NO-WAIT.

RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel_Utilex V-table-Win 
PROCEDURE Excel_Utilex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER l-incigv AS LOGICAL.

RUN vta2/d-cot-excel-utilex.r ( ROWID(Faccpedi), l-IncIgv).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exportar-a-Pdf V-table-Win 
PROCEDURE Exportar-a-Pdf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF NOT AVAILABLE FacCPedi OR FacCPedi.FlgEst = "A"  THEN RETURN.

  F-Observa = FacCPedi.Observa.
  RUN vtamay/d-cotiza (INPUT-OUTPUT F-Observa,
                        F-CndVta:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                        YES,
                        (DATE(FacCPedi.FchVen:SCREEN-VALUE IN FRAME {&FRAME-NAME}) - DATE(FacCPedi.FchPed:SCREEN-VALUE IN FRAME {&FRAME-NAME})) + 1
                        ).
  IF F-Observa = '***' THEN RETURN "ADM-ERROR".
  /* Bloqueamos y grabamos */
  FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
  IF ERROR-STATUS:ERROR = YES THEN DO:
      {lib/mensaje-de-error.i &MensajeError="pMensaje"}
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      RETURN.
  END.
  ASSIGN
      FacCPedi.Observa = F-Observa.
  FIND CURRENT Faccpedi NO-LOCK NO-ERROR.

  &IF {&ARITMETICA-SUNAT} &THEN 
  RUN vtagn/impresion-cot-pdf-sunat.r (ROWID(FacCPedi)).
  &ELSE
  RUN vtagn/impresion-cot-pdf.r (ROWID(FacCPedi)).
  &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Excel-Trabajo V-table-Win 
PROCEDURE Genera-Excel-Trabajo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE F-PreUni                LIKE FacDPedi.Preuni.
DEFINE VARIABLE F-ImpLin                LIKE FacDPedi.ImpLin.
DEFINE VARIABLE F-ImpTot                LIKE FacCPedi.ImpTot.

/* Ic - 07May2015  */
DEFINE VAR x-Qty AS CHAR.
DEFINE VAR x-PU AS CHAR.
DEFINE VAR x-ClasCli AS CHAR.

DEF        VAR C-NomVen  AS CHAR FORMAT "X(30)".
DEF        VAR C-Descli  AS CHAR FORMAT "X(60)".
DEF        VAR C-Moneda  AS CHAR FORMAT "X(7)".
DEF        VAR C-SimMon  AS CHAR FORMAT "X(7)".
DEF        VAR C-NomCon  AS CHAR FORMAT "X(30)".
DEF        VAR X-ORDCOM AS CHARACTER FORMAT "X(18)".
DEF        VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.
DEFINE VARIABLE C-OBS AS CHAR EXTENT 2 NO-UNDO.
DEFINE VARIABLE K AS INTEGER NO-UNDO.

IF NUM-ENTRIES(FacCPedi.Observa,"-") - 1 > 6 THEN DO:
   DO K = 2 TO 7:
      IF ENTRY(K,FacCPedi.Observa,"-") <> "" THEN 
         C-OBS[1] = C-OBS[1] + "- " + ENTRY(K,FacCPedi.Observa,"-").
   END.
   DO K = 8 TO NUM-ENTRIES(FacCPedi.Observa,"-"):
      IF ENTRY(K,FacCPedi.Observa,"-") <> "" THEN 
         C-OBS[2] = C-OBS[2] + "- " + ENTRY(K,FacCPedi.Observa,"-").
   END.
END.
ELSE DO: 
   C-OBS[1] = FacCPedi.Observa.
   C-OBS[2] = "".
END.

F-ImpTot = FacCPedi.ImpTot.

/* ************************ cargamos variables ********************* */
FIND gn-ven WHERE 
     gn-ven.CodCia = FacCPedi.CodCia AND  
     gn-ven.CodVen = FacCPedi.CodVen 
     NO-LOCK NO-ERROR.
C-NomVen = FacCPedi.CodVen.
IF AVAILABLE gn-ven THEN C-NomVen = C-NomVen + " - " + gn-ven.NomVen.
FIND gn-clie WHERE 
     gn-clie.codcia = cl-codcia AND  
     gn-clie.codcli = FacCPedi.codcli NO-LOCK NO-ERROR.
     
C-DESCLI  = Gn-clie.codcli + ' - ' + Gn-clie.Nomcli     .
C-DESCLI  = FaccPedi.codcli + ' - ' + FaccPedi.Nomcli     .

IF FacCPedi.coddoc = "PED" THEN 
    X-ORDCOM = "Orden de Compra : ".
ELSE 
    X-ORDCOM = "Solicitud Cotiz.: ".

FIND gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
C-NomCon = FacCPedi.FmaPgo.
IF AVAILABLE gn-ConVt THEN C-NomCon = gn-ConVt.Nombr.
IF FacCpedi.Codmon = 2 THEN DO: 
    C-Moneda = "DOLARES US$.".
    c-SimMon = "US$".
END.
ELSE DO: 
    C-Moneda = "SOLES   S/. ".
    c-SimMon = "S/.".
END.

/* ******************************************************************** */

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
/*chWorkbook = chExcelApplication:Workbooks:Add("C:\PRG\Templates\q fue\Cotizacion.xlt").*/
DEF var x-Plantilla AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION 'Plantillas' KEY 'Carpeta' VALUE x-Plantilla .
x-Plantilla = x-Plantilla + "Cotizacion_de_trabajo.xlt".

chWorkbook = chExcelApplication:Workbooks:Add(x-Plantilla).

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 4.
chWorkSheet:Columns("B"):ColumnWidth = 7.
chWorkSheet:Columns("C"):ColumnWidth = 10.
chWorkSheet:Columns("D"):ColumnWidth = 4.
chWorkSheet:Columns("E"):ColumnWidth = 45.
chWorkSheet:Columns("F"):ColumnWidth = 11.
chWorkSheet:Columns("G"):ColumnWidth = 15.
chWorkSheet:Columns("H"):ColumnWidth = 10.
chWorkSheet:Columns("I"):ColumnWidth = 15.
/*Datos Cliente*/
t-Column = 11.
cColumn = STRING(t-Column).
/* cRange = "F" + cColumn.                                               */
/* chWorkSheet:Range(cRange):Value = "COTIZACION Nº " + faccpedi.nroped. */
cRange = "G9".
chWorkSheet:Range(cRange):Value = STRING(faccpedi.nroped, 'XXX-XXXXXX'). 
chWorkSheet:Range(cRange):FONT:Bold = TRUE.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Señor(es) :" + c-descli. 

t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Direccion :" + gn-clie.dircli. 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Emision         : " + STRING(faccpedi.fchped, '99/99/9999').
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Referencia :" . 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Vencimiento     : " + STRING(faccpedi.fchven, '99/99/9999') . 
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "VENDEDOR  : " + c-nomven . 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Forma de pago   : " + c-nomcon.
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "ATT.". 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Moneda          : " + c-moneda. 
t-Column = t-Column + 5.
cColumn = STRING(t-Column).
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value =  "(" + c-simmon + ")". 
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value =  "(" + c-simmon + ")". 

t-Column = t-Column + 2.
/* Ic 07May2015 */
DEF VAR x-StkDisponible AS DEC NO-UNDO.
DEF VAR x-StockComprometido AS DEC NO-UNDO.

FOR EACH facdpedi OF faccpedi NO-LOCK, FIRST almmmatg OF facdpedi NO-LOCK BREAK BY FacDPedi.NroItm:
    F-ImpLin = FacDPedi.ImpLin. 
    F-PreUni = FacDPedi.ImpLin / FacDPedi.CanPed.
    /*Agrega Row*/
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + STRING(facdpedi.nroitm, '>>>9').
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + facdpedi.codmat.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.
    x-Qty = cRange.
    chWorkSheet:Range(cRange):Value = facdpedi.canped.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = facdpedi.undvta.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "Z" + cColumn.
    chWorkSheet:Range(cRange):Value = f-PreUni.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "G" + cColumn.
    chWorksheet:Range(cRange):NumberFormat = '###,###,##0.0000'.
    ASSIGN chWorkSheet:Range(cRange):VALUE = F-PreUni NO-ERROR.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.    
    cRange = "H" + cColumn.
    chWorksheet:Range(cRange):NumberFormat = '###,###,##0.00' .    
    chWorkSheet:Range(cRange):VALUE = F-ImpLin.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.canemp.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    FOR EACH Almmmate NO-LOCK WHERE Almmmate.codcia = facdpedi.codcia
        AND Almmmate.codmat = facdpedi.CodMat
        AND Almmmate.codalm <> '11T'
        AND Almmmate.stkact > 0,
        FIRST Almacen OF Almmmate NO-LOCK WHERE Almacen.Campo-C[9] <> "I":
        /* STOCK comprometido */
        RUN gn/stock-comprometido-v2 (almmmate.CodMat, almmmate.CodAlm, yes, OUTPUT x-StockComprometido).
        X-StkDisponible = almmmate.stkact - x-StockComprometido.
        IF x-StkDisponible <= 0 THEN NEXT.
        cColumn = STRING(t-Column).
        cRange = "J" + cColumn.
        chWorksheet:Range(cRange):NumberFormat = '@' .    
        chWorkSheet:Range(cRange):FONT:Bold = TRUE.
        chWorkSheet:Range(cRange):Value = Almmmate.CodAlm.
        cRange = "K" + cColumn.
        chWorksheet:Range(cRange):NumberFormat = '###,###,##0.00' .    
        chWorkSheet:Range(cRange):FONT:Bold = TRUE.
        chWorkSheet:Range(cRange):VALUE = x-StkDisponible.
        t-column = t-column + 1.
    END.
    t-column = t-column + 1.
END.
t-column = t-column + 3.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "* LOS PRECIOS INCLUYEN IGV.".

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE genera-excel-vendedores V-table-Win 
PROCEDURE genera-excel-vendedores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER l-incigv AS LOGICAL.

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE F-PreUni                LIKE FacDPedi.Preuni.
DEFINE VARIABLE F-ImpLin                LIKE FacDPedi.ImpLin.
DEFINE VARIABLE F-ImpTot                LIKE FacCPedi.ImpTot.

/* Ic - 07May2015  */
DEFINE VAR x-Qty AS CHAR.
DEFINE VAR x-PU AS CHAR.
DEFINE VAR x-suma-Desde AS CHAR.
DEFINE VAR x-suma-Hasta AS CHAR.
DEFINE VAR x-ClasCli AS CHAR.

DEF        VAR C-NomVen  AS CHAR FORMAT "X(30)".
DEF        VAR C-Descli  AS CHAR FORMAT "X(60)".
DEF        VAR C-Moneda  AS CHAR FORMAT "X(7)".
DEF        VAR C-SimMon  AS CHAR FORMAT "X(7)".
DEF        VAR C-NomCon  AS CHAR FORMAT "X(30)".
DEF        VAR X-ORDCOM AS CHARACTER FORMAT "X(18)".
DEF        VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.
DEFINE VARIABLE C-OBS AS CHAR EXTENT 2 NO-UNDO.
DEFINE VARIABLE K AS INTEGER NO-UNDO.
DEFINE VARIABLE P AS INTEGER NO-UNDO.

IF NUM-ENTRIES(FacCPedi.Observa,"-") - 1 > 6 THEN DO:
   DO K = 2 TO 7:
      IF ENTRY(K,FacCPedi.Observa,"-") <> "" THEN 
         C-OBS[1] = C-OBS[1] + "- " + ENTRY(K,FacCPedi.Observa,"-").
   END.
   DO K = 8 TO NUM-ENTRIES(FacCPedi.Observa,"-"):
      IF ENTRY(K,FacCPedi.Observa,"-") <> "" THEN 
         C-OBS[2] = C-OBS[2] + "- " + ENTRY(K,FacCPedi.Observa,"-").
   END.
END.
ELSE DO: 
   C-OBS[1] = FacCPedi.Observa.
   C-OBS[2] = "".
END.
/*IF FacCpedi.FlgIgv THEN DO:*/
IF l-incigv THEN DO:
   F-ImpTot = FacCPedi.ImpTot.
END.
ELSE DO:
   F-ImpTot = FacCPedi.ImpVta.
END.  

/* ************************ cargamos variables ********************* */
FIND gn-ven WHERE 
     gn-ven.CodCia = FacCPedi.CodCia AND  
     gn-ven.CodVen = FacCPedi.CodVen 
     NO-LOCK NO-ERROR.
C-NomVen = FacCPedi.CodVen.
IF AVAILABLE gn-ven THEN C-NomVen = C-NomVen + " - " + gn-ven.NomVen.
FIND gn-clie WHERE 
     gn-clie.codcia = cl-codcia AND  
     gn-clie.codcli = FacCPedi.codcli NO-LOCK NO-ERROR.
     
C-DESCLI  = Gn-clie.codcli + ' - ' + Gn-clie.Nomcli     .
C-DESCLI  = FaccPedi.codcli + ' - ' + FaccPedi.Nomcli     .

IF FacCPedi.coddoc = "PED" THEN 
    X-ORDCOM = "Orden de Compra : ".
ELSE 
    X-ORDCOM = "Solicitud Cotiz.: ".

FIND gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
C-NomCon = FacCPedi.FmaPgo.
IF AVAILABLE gn-ConVt THEN C-NomCon = gn-ConVt.Nombr.
IF FacCpedi.Codmon = 2 THEN DO: 
    C-Moneda = "DOLARES US$.".
    c-SimMon = "US$".
END.
ELSE DO: 
    C-Moneda = "SOLES   S/. ".
    c-SimMon = "S/.".
END.

/* ******************************************************************** */

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
/*chWorkbook = chExcelApplication:Workbooks:Add("C:\PRG\Templates\q fue\Cotizacion.xlt").*/
DEF var x-Plantilla AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION 'Plantillas' KEY 'Carpeta' VALUE x-Plantilla .
x-Plantilla = x-Plantilla + "Cotizacion_vendedores.xlt".

chWorkbook = chExcelApplication:Workbooks:Add(x-Plantilla).

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 4.
chWorkSheet:Columns("B"):ColumnWidth = 7.
chWorkSheet:Columns("C"):ColumnWidth = 10.
chWorkSheet:Columns("D"):ColumnWidth = 4.
chWorkSheet:Columns("E"):ColumnWidth = 45.
chWorkSheet:Columns("F"):ColumnWidth = 11.
chWorkSheet:Columns("G"):ColumnWidth = 15.
chWorkSheet:Columns("H"):ColumnWidth = 10.
chWorkSheet:Columns("I"):ColumnWidth = 15.
/*Datos Cliente*/
t-Column = 11.
cColumn = STRING(t-Column).
/* cRange = "F" + cColumn.                                               */
/* chWorkSheet:Range(cRange):Value = "COTIZACION Nº " + faccpedi.nroped. */
cRange = "G9".
chWorkSheet:Range(cRange):Value = STRING(faccpedi.nroped, 'XXX-XXXXXX'). 
chWorkSheet:Range(cRange):FONT:Bold = TRUE.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Señor(es) :" + c-descli. 

t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Direccion :" + gn-clie.dircli. 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Emision         : " + STRING(faccpedi.fchped, '99/99/9999').
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Referencia :" . 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Vencimiento     : " + STRING(faccpedi.fchven, '99/99/9999') . 
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "VENDEDOR  : " + c-nomven . 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Forma de pago   : " + c-nomcon.
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "ATT.". 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Moneda          : " + c-moneda. 

t-Column = t-Column + 5.
cColumn = STRING(t-Column).
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value =  "(" + c-simmon + ")". 
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value =  "(" + c-simmon + ")". 

/*
chWorkSheet:Range("G20"):Value = "(" + c-simmon + ")". 
chWorkSheet:Range("H20"):Value = "(" + c-simmon + ")". 
*/

t-Column = t-Column + 2.
/* Ic 07May2015 */
x-suma-desde = "".
x-suma-hasta = "".

P = t-Column.
FOR EACH facdpedi OF faccpedi NO-LOCK,
        FIRST almmmatg OF facdpedi NO-LOCK
        BREAK BY FacDPedi.NroPed BY FacDPedi.NroItm DESC:
    /*RDP01 - 
    IF FacCpedi.FlgIgv THEN DO:
       F-PreUni = FacDPedi.PreUni.
       F-ImpLin = FacDPedi.ImpLin. 
    END.
    ELSE DO:
       F-PreUni = ROUND(FacDPedi.PreUni / (1 + FacCPedi.PorIgv / 100),2).
       F-ImpLin = ROUND(FacDPedi.ImpLin / (1 + FacCPedi.PorIgv / 100),2). 
    END.  
    */

    IF l-incigv THEN DO:
       /*F-PreUni = FacDPedi.PreUni.*/
       F-ImpLin = FacDPedi.ImpLin. 
       F-PreUni = FacDPedi.ImpLin / FacDPedi.CanPed.
    END.
    ELSE DO:
       /*F-PreUni = ROUND(FacDPedi.PreUni / (1 + FacCPedi.PorIgv / 100),2).*/
       F-ImpLin = ROUND(FacDPedi.ImpLin / (1 + FacCPedi.PorIgv / 100),2). 
       F-PreUni = ROUND(f-ImpLin / FacDPedi.CanPed,2).
    END.  

    IF almmmatg.monvta = 2 THEN DO:
        F-PreUni = almmmatg.preofi * almmmatg.tpocmb.
    END.
    ELSE DO: 
        F-PreUni = almmmatg.preofi.
    END.
    F-PreUni = round(F-PreUni,4).

    /*Agrega Row*/
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):EntireRow:INSERT.
    
    /*t-column = t-column + 1.*/
    p = p + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + STRING(facdpedi.nroitm, '>>>9').
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + facdpedi.codmat.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.
    x-Qty = cRange.
    /*chWorkSheet:Range(cRange):Value = facdpedi.canped.*/
    chWorkSheet:Range(cRange):Value = 0.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = facdpedi.undvta.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
   
    cRange = "Z" + cColumn.
    chWorkSheet:Range(cRange):Value = f-PreUni.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.

    cRange = "G" + cColumn.
    x-PU = cRange.
    x-ClasCli = "Y5".
    /*chWorkSheet:Range(cRange):Value = f-PreUni.*/
    chWorksheet:Range(cRange):NumberFormat = '###,###,##0.0000'.
    ASSIGN chWorkSheet:Range(cRange):VALUE = "= Z" + cColumn + "*((100 - " + x-ClasCli + ") / 100)" NO-ERROR.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.    

    cRange = "H" + cColumn.
    /*chWorkSheet:Range(cRange):Value = f-ImpLin.*/
    chWorksheet:Range(cRange):NumberFormat = '###,###,##0.00' .    
    chWorkSheet:Range(cRange):VALUE = "= " + x-Qty + " * " + x-PU.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.

    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.canemp.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.

    IF x-suma-hasta = "" THEN x-suma-hasta = cRange.
    x-suma-desde = cRange.
END.
t-column = p + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "TOTAL " + c-simmon.
chWorkSheet:Range(cRange):FONT:Bold = TRUE.
cRange = "H" + cColumn.
chWorksheet:Range(cRange):NumberFormat = '###,###,##0.00' .
ASSIGN chWorkSheet:Range(cRange):VALUE = "=SUMA(" + x-suma-desde + ":" + x-suma-hasta + ") " + CHR(13) NO-ERROR.
chWorkSheet:Range(cRange):FONT:Bold = TRUE.

t-column = t-column + 3.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
IF l-incigv THEN chWorkSheet:Range(cRange):Value = "* LOS PRECIOS INCLUYEN IGV.".
ELSE chWorkSheet:Range(cRange):Value = "* LOS PRECIOS NO INCLUYEN IGV.".

/* PERCEPCION */
IF Faccpedi.acubon[5] > 0 THEN DO:
    t-column = t-column + 4.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "* Operación sujeta a percepción del IGV: " +
        (IF FacCPedi.codmon = 1 THEN "S/." ELSE "US$") + 
        TRIM(STRING(Faccpedi.acubon[5], '>>>,>>9.99')).
    t-column = t-column + 1.
END.

/*RD01-Condicion Venta*/
FIND FIRST gn-convt WHERE gn-convt.codig =  facCPedi.fmapgo NO-LOCK NO-ERROR.
IF AVAIL gn-convt THEN DO:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "* FORMA DE PAGO: " +  gn-convt.Nombr.
END.


/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Excel2 V-table-Win 
PROCEDURE Genera-Excel2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER l-incigv AS LOGICAL.

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE F-PreUni                LIKE FacDPedi.Preuni.
DEFINE VARIABLE F-ImpLin                AS DEC DECIMALS 4 NO-UNDO.
DEFINE VARIABLE F-ImpTot                LIKE FacCPedi.ImpTot.

DEF        VAR C-NomVen  AS CHAR FORMAT "X(30)".
DEF        VAR C-Descli  AS CHAR FORMAT "X(60)".
DEF        VAR C-Moneda  AS CHAR FORMAT "X(7)".
DEF        VAR C-SimMon  AS CHAR FORMAT "X(7)".
DEF        VAR C-NomCon  AS CHAR FORMAT "X(30)".
DEF        VAR X-ORDCOM AS CHARACTER FORMAT "X(18)".
DEF        VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.
DEFINE VARIABLE C-OBS AS CHAR EXTENT 2 NO-UNDO.
DEFINE VARIABLE K AS INTEGER NO-UNDO.
DEFINE VARIABLE P AS INTEGER NO-UNDO.

IF NUM-ENTRIES(FacCPedi.Observa,"-") - 1 > 6 THEN DO:
   DO K = 2 TO 7:
      IF ENTRY(K,FacCPedi.Observa,"-") <> "" THEN 
         C-OBS[1] = C-OBS[1] + "- " + ENTRY(K,FacCPedi.Observa,"-").
   END.
   DO K = 8 TO NUM-ENTRIES(FacCPedi.Observa,"-"):
      IF ENTRY(K,FacCPedi.Observa,"-") <> "" THEN 
         C-OBS[2] = C-OBS[2] + "- " + ENTRY(K,FacCPedi.Observa,"-").
   END.
END.
ELSE DO: 
   C-OBS[1] = FacCPedi.Observa.
   C-OBS[2] = "".
END.
/*IF FacCpedi.FlgIgv THEN DO:*/
IF l-incigv THEN DO:
   F-ImpTot = FacCPedi.ImpTot.
END.
ELSE DO:
   F-ImpTot = FacCPedi.ImpVta.
   F-ImpTot = 0.
END.  

/* ************************ cargamos variables ********************* */
FIND gn-ven WHERE 
     gn-ven.CodCia = FacCPedi.CodCia AND  
     gn-ven.CodVen = FacCPedi.CodVen 
     NO-LOCK NO-ERROR.
C-NomVen = FacCPedi.CodVen.
IF AVAILABLE gn-ven THEN C-NomVen = C-NomVen + " - " + gn-ven.NomVen.
FIND gn-clie WHERE 
     gn-clie.codcia = cl-codcia AND  
     gn-clie.codcli = FacCPedi.codcli NO-LOCK NO-ERROR.
     
C-DESCLI  = Gn-clie.codcli + ' - ' + Gn-clie.Nomcli     .
C-DESCLI  = FaccPedi.codcli + ' - ' + FaccPedi.Nomcli     .

IF FacCPedi.coddoc = "PED" THEN 
    X-ORDCOM = "Orden de Compra : ".
ELSE 
    X-ORDCOM = "Solicitud Cotiz.: ".

FIND gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
C-NomCon = FacCPedi.FmaPgo.
IF AVAILABLE gn-ConVt THEN C-NomCon = gn-ConVt.Nombr.
IF FacCpedi.Codmon = 2 THEN DO: 
    C-Moneda = "DOLARES US$.".
    c-SimMon = "US$".
END.
ELSE DO: 
    C-Moneda = "SOLES   S/. ".
    c-SimMon = "S/.".
END.

/* ******************************************************************** */

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
/*chWorkbook = chExcelApplication:Workbooks:Add("C:\PRG\Templates\q fue\Cotizacion.xlt").*/
DEF var x-Plantilla AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION 'Plantillas' KEY 'Carpeta' VALUE x-Plantilla .
x-Plantilla = x-Plantilla + "Cotizacion.xlt".

chWorkbook = chExcelApplication:Workbooks:Add(x-Plantilla).

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 4.
chWorkSheet:Columns("B"):ColumnWidth = 7.
chWorkSheet:Columns("C"):ColumnWidth = 10.
chWorkSheet:Columns("D"):ColumnWidth = 4.
chWorkSheet:Columns("E"):ColumnWidth = 45.
chWorkSheet:Columns("F"):ColumnWidth = 11.
chWorkSheet:Columns("G"):ColumnWidth = 15.
chWorkSheet:Columns("H"):ColumnWidth = 10.
chWorkSheet:Columns("I"):ColumnWidth = 15.
/*Datos Cliente*/
t-Column = 11.
cColumn = STRING(t-Column).
/* cRange = "F" + cColumn.                                               */
/* chWorkSheet:Range(cRange):Value = "COTIZACION Nº " + faccpedi.nroped. */
cRange = "G9".
chWorkSheet:Range(cRange):Value = STRING(faccpedi.nroped, 'XXX-XXXXXX'). 
chWorkSheet:Range(cRange):FONT:Bold = TRUE.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Señor(es) :" + c-descli. 
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Direccion :" + gn-clie.dircli. 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Emision         : " + STRING(faccpedi.fchped, '99/99/9999').
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Referencia :" . 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Vencimiento     : " + STRING(faccpedi.fchven, '99/99/9999') . 
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "VENDEDOR  : " + c-nomven . 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Forma de pago   : " + c-nomcon.
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "ATT.". 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Moneda          : " + c-moneda. 

t-Column = t-Column + 5.
cColumn = STRING(t-Column).
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value =  "(" + c-simmon + ")". 
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value =  "(" + c-simmon + ")". 

t-Column = t-Column + 2.

/* Dias Vigencia - Ic 10Jun2021 */
DEFINE VAR x-txt-vcto AS CHAR.
DEFINE VAR x-mascara AS CHAR.

x-txt-vcto = "* PEDIDO COMERCIAL VALIDO POR 07 DIAS.".
x-txt-vcto = "* PEDIDO COMERCIAL VALIDO POR ".
FIND FIRST x-gn-divi WHERE x-gn-divi.codcia = s-codcia AND
                            x-gn-divi.coddiv = faccpedi.coddiv NO-LOCK NO-ERROR.
IF AVAILABLE x-gn-divi THEN DO:
    x-mascara = "99".
    IF x-gn-divi.diasvtocot > 99 THEN x-mascara = FILL("9",INT(x-gn-divi.diasvtocot)).

    /*x-txt-vcto = "* PEDIDO COMERCIAL VALIDO POR " + STRING(x-gn-divi.diasvtocot,"999") + " DIA(S)".*/
    x-txt-vcto = "* PEDIDO COMERCIAL VALIDO POR " + STRING(x-gn-divi.diasvtocot,x-mascara) + " DIAS".
END.
cRange = "A30".
chWorkSheet:Range(cRange):Value =  x-txt-vcto. 
/* Dias Vigencia - Ic 10Jun2021 */

P = t-Column.
FOR EACH facdpedi OF faccpedi NO-LOCK,
    FIRST almmmatg OF facdpedi NO-LOCK
    BREAK BY FacDPedi.NroPed BY FacDPedi.NroItm DESC:
    /* *************************************************************************** */
    /* RHC 17/12/2020 Si no hay descuentos el precio unitario se toma directamente */
    /* *************************************************************************** */
    IF (FacDPedi.Por_Dsctos[1] + FacDPedi.Por_Dsctos[2] + FacDPedi.Por_Dsctos[3] + ~
        FacDPedi.ImpDto2) = 0 THEN DO:
        F-PreUni = FacDPedi.ImporteUnitarioConImpuesto.     /*FacDPedi.PreUni.*/
    END.
    ELSE DO:
        IF l-IncIgv = YES THEN F-PreUni = ROUND(FacDPedi.ImpLin / FacDPedi.CanPed, INTEGER(Faccpedi.Libre_d01)).
        ELSE F-PreUni = ROUND(FacDPedi.ImpLin / FacDPedi.CanPed, 4).
    END.
    CASE TRUE:
        WHEN l-IncIgv = YES AND Facdpedi.AftIgv = YES THEN DO:
            F-ImpLin = FacDPedi.ImpLin. 
        END.
        WHEN l-IncIgv = NO AND Facdpedi.AftIgv = YES THEN DO:
            F-PreUni = ROUND(F-PreUni / (1 + FacCPedi.PorIgv / 100), 4).
            F-ImpLin = ROUND(FacDPedi.ImpLin / (1 + FacCPedi.PorIgv / 100), 2).
        END.
        OTHERWISE DO:
            F-ImpLin = FacDPedi.ImpLin. 
        END.
    END CASE.
    /* *************************************************************************** */
    /* *************************************************************************** */
    /* Sin IGV se calcula el VVTA */
    IF l-incigv = NO THEN F-ImpTot = F-ImpTot + F-ImpLin.
    /*Agrega Row*/
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):EntireRow:INSERT.
    p = p + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + STRING(facdpedi.nroitm, '>>>>>>9').
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + facdpedi.codmat.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.    
    chWorkSheet:Range(cRange):Value = facdpedi.canped.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = facdpedi.undvta.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = f-PreUni.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = f-ImpLin.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
END.
t-column = p + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "TOTAL " + c-simmon.
chWorkSheet:Range(cRange):FONT:Bold = TRUE.
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = f-ImpTot.
chWorkSheet:Range(cRange):FONT:Bold = TRUE.

t-column = t-column + 3.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
IF l-incigv THEN chWorkSheet:Range(cRange):Value = "* LOS PRECIOS INCLUYEN IGV.".
ELSE chWorkSheet:Range(cRange):Value = "* LOS PRECIOS NO INCLUYEN IGV.".

/* PERCEPCION */
IF Faccpedi.acubon[5] > 0 THEN DO:
    t-column = t-column + 4.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "* Operación sujeta a percepción del IGV: " +
        (IF FacCPedi.codmon = 1 THEN "S/." ELSE "US$") + 
        TRIM(STRING(Faccpedi.acubon[5], '>>>,>>9.99')).
    t-column = t-column + 1.
END.

/*RD01-Condicion Venta*/
FIND FIRST gn-convt WHERE gn-convt.codig =  facCPedi.fmapgo NO-LOCK NO-ERROR.
IF AVAIL gn-convt THEN DO:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "* FORMA DE PAGO: " +  gn-convt.Nombr.
END.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IBC-Diferencias V-table-Win 
PROCEDURE IBC-Diferencias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR f-PreBas AS DEC NO-UNDO.
DEF VAR f-PreVta AS DEC NO-UNDO.
DEF VAR f-Dsctos AS DEC NO-UNDO.
DEF VAR y-Dsctos AS DEC NO-UNDO.
DEF VAR z-Dsctos AS DEC NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.

EMPTY TEMP-TABLE T-DPEDI.
FOR EACH ITEM:
    /* Valida Maestro Productos */
    FIND Almmmatg WHERE 
         Almmmatg.CodCia = S-CODCIA AND  
         Almmmatg.codmat = ITEM.codmat
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN NEXT.
    IF Almmmatg.TpoArt = "D" THEN NEXT.
    IF Almmmatg.Chr__01 = "" THEN NEXT.
    FIND Almmmate WHERE 
         Almmmate.CodCia = S-CODCIA AND  
         Almmmate.CodAlm = S-CODALM AND  
         Almmmate.CodMat = ITEM.codmat
         USE-INDEX mate01
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN NEXT.
    F-FACTOR = 1.
    /* RHC 10/08/2012 PRECIO SUPERMERCADO */
    RUN vta2/PrecioSupermercado (s-TpoPed,
                                 pCodDiv,
                                 s-CodCli,
                                 s-CodMon,
                                 ITEM.UndVta,
                                 f-Factor,
                                 ITEM.CodMat,
                                 s-FmaPgo,
                                 ITEM.CanPed,
                                 s-NroDec,
                                 OUTPUT f-PreBas,
                                 OUTPUT f-PreVta,
                                 OUTPUT f-Dsctos,
                                 OUTPUT y-Dsctos,
                                 OUTPUT z-Dsctos,
                                 NO).
    f-PreVta = f-PreVta * ( 1 - z-Dsctos / 100 ) * ( 1 - y-Dsctos / 100 ).
    /* Solo si hay una diferencia mayor al 1% */
    IF ABSOLUTE(ITEM.PreUni - f-PreVta) / f-PreVta * 100 > 0.25 THEN DO:
        CREATE T-DPEDI.
        BUFFER-COPY ITEM TO T-DPEDI
            ASSIGN
                T-DPEDI.Libre_d01 = f-PreVta.
    END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importar-excel-2015 V-table-Win 
PROCEDURE importar-excel-2015 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN vtagn/ventas-library PERSISTENT SET hProc.

RUN COT_Importar-Excel IN hProc (INPUT-OUTPUT TABLE ITEM).
DELETE PROCEDURE hProc.
IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.

FOR EACH ITEM WHERE TRUE <> (ITEM.AlmDes > ''):
    ITEM.AlmDes = ENTRY(1,s-CodAlm).
END.
RUN Procesa-Handle IN lh_handle ( "Recalculo" ).
RUN Procesa-Handle IN lh_handle ( "Browse" ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Excel-Marco V-table-Win 
PROCEDURE Importar-Excel-Marco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE Faccpedi THEN RETURN.
DEFINE VAR RPTA AS CHAR.
DEFINE VAR cTipoPrecio AS CHAR.

RUN valida-update.
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    RUN Procesa-Handle IN lh_Handle ('Pagina1').
    RETURN.
END.
RUN Procesa-Handle IN lh_Handle ('Pagina1').

/* RECALCULAMOS LOS ITEMS ANTES */
EMPTY TEMP-TABLE ITEM-2.
FOR EACH ITEM:
    CREATE ITEM-2.
    BUFFER-COPY ITEM TO ITEM-2.
END.
RUN Procesa-Handle IN lh_handle ("Recalculo").

DEFINE VARIABLE FILL-IN-Archivo AS CHAR NO-UNDO.
DEFINE VARIABLE OKpressed AS LOG NO-UNDO.
                                          
SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
    FILTERS "Archivos Excel (*.xls,*.xlsx)" "*.xls,*.xlsx"
    TITLE "COTIZACION CONTRATO MARCO"
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.

/* CREAMOS LA HOJA EXCEL */
CREATE "Excel.Application" chExcelApplication.
chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-Archivo).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

SESSION:SET-WAIT-STATE('GENERAL').

EMPTY TEMP-TABLE PEDI.  /* Limpiamos el temporal */
RUN Importar-Detalle-Excel-Marco (OUTPUT cTipoPrecio) NO-ERROR.
IF ERROR-STATUS:ERROR THEN EMPTY TEMP-TABLE PEDI.
SESSION:SET-WAIT-STATE('').

/* CERRAMOS EL EXCEL */
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 

/* Pasamos PEDI a ITEM */
IF NOT CAN-FIND(FIRST PEDI) THEN RETURN.    /* OJO */

/* Consistencia de ida y vuelta */
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
FOR EACH PEDI:
    FIND FIRST ITEM WHERE ITEM.codmat = PEDI.codmat NO-ERROR.
    IF NOT AVAILABLE ITEM THEN DO:
        MESSAGE 'Artículo' PEDI.codmat 'no registrado en la cotización'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    IF PEDI.canped <> ITEM.canped THEN DO:
        MESSAGE 'Artículo' PEDI.codmat 'cantidad diferente en la cotización'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    IF PEDI.undvta <> ITEM.undvta THEN DO:
        MESSAGE 'Artículo' PEDI.codmat 'unidad de venta diferente en la cotización'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
END.
FOR EACH ITEM:
    FIND FIRST PEDI WHERE PEDI.codmat = ITEM.codmat NO-ERROR.
    IF NOT AVAILABLE PEDI THEN DO:
        MESSAGE 'Artículo' ITEM.codmat 'no registrado en el Excel'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
END.
/* LIMITES PERMITIDOS */
IF s-TpoPed = "M" THEN DO:
    FOR EACH PEDI, FIRST ITEM WHERE ITEM.codmat = PEDI.codmat:
        CASE TRUE:
            WHEN gn-divi.libre_c02 = 'Porcentaje' AND gn-divi.libre_d01 > 0 THEN DO:
                IF (ABS(PEDI.ImpLin - ITEM.ImpLin) / ITEM.ImpLin) * 100 > gn-divi.libre_d01 
                    THEN DO:
                    MESSAGE 'El artículo' ITEM.codmat 'supera el margen permitido' SKIP
                        'Proceso abortado'
                        VIEW-AS ALERT-BOX ERROR.
                    RETURN.
                END.
            END.
            WHEN gn-divi.libre_c02 = 'Importe' AND gn-divi.libre_d01 > 0 THEN DO:
                IF ABS(PEDI.ImpLin - ITEM.ImpLin) > gn-divi.libre_d01 
                    THEN DO:
                    MESSAGE 'El artículo' ITEM.codmat 'supera el margen permitido' SKIP
                        'Proceso abortado'
                        VIEW-AS ALERT-BOX ERROR.
                    RETURN.
                END.
            END.
        END CASE.
    END.
END.
/* Actualizamos información del ITEM */
FOR EACH PEDI, FIRST ITEM WHERE ITEM.codmat = PEDI.codmat, FIRST Almmmatg OF ITEM NO-LOCK:
    /* Cargamos valores del Excel */
    ASSIGN
        ITEM.PreUni = PEDI.PreUni
        ITEM.ImpLin = PEDI.ImpLin
        ITEM.Por_Dsctos[1] = 0
        ITEM.Por_Dsctos[2] = 0
        ITEM.Por_Dsctos[3] = 0
        ITEM.ImpDto = 0
        ITEM.PreUni = ROUND(ITEM.ImpLin / ITEM.CanPed, 6).  /* Por si acaso */
    /* Recalculamos linea */
    IF ITEM.AftIsc 
    THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
    ELSE ITEM.ImpIsc = 0.
    IF ITEM.AftIgv 
    THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (Faccpedi.PorIgv / 100) ), 4 ).
    ELSE ITEM.ImpIgv = 0.
    /* CALCULO DE PERCEPCION */
    ASSIGN
        ITEM.CanApr = ROUND(ITEM.implin * ITEM.CanSol / 100, 2).
END.
/* Grabamos Cotizacion */
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccpedi THEN DO:
        MESSAGE 'Cotización en uso por otro usuario' VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    RUN Borra-Pedido.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        MESSAGE 'Cotización en uso por otro usuario' VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* Detalle */
    FOR EACH ITEM WHERE ITEM.ImpLin > 0 BY ITEM.NroItm: 
        CREATE FacDPedi.
        BUFFER-COPY ITEM TO FacDPedi.
    END.
    /* ****************************************************************************************** */
    &IF {&ARITMETICA-SUNAT} &THEN
        {vtagn/totales-cotizacion-sunat.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
        /* ****************************************************************************************** */
        /* Importes SUNAT */
        /* ****************************************************************************************** */
        DEF VAR hProc AS HANDLE NO-UNDO.
        RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
        RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                                     INPUT Faccpedi.CodDoc,
                                     INPUT Faccpedi.NroPed,
                                     OUTPUT pMensaje).
        IF RETURN-VALUE = "ADM-ERROR" THEN DO:
            MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN 'ADM-ERROR'.
        END.
        DELETE PROCEDURE hProc.
    &ELSE
        {vtagn/totales-cotizacion-unificada.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
        /* ****************************************************************************************** */
        /* Importes SUNAT */
        /* No se actualiza los valores Progress */
        /* ****************************************************************************************** */
        DEF VAR hProc AS HANDLE NO-UNDO.
        RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
        RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                                     INPUT Faccpedi.CodDoc,
                                     INPUT Faccpedi.NroPed,
                                     OUTPUT pMensaje).
        IF RETURN-VALUE = "ADM-ERROR" THEN DO:
            MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN 'ADM-ERROR'.
        END.
        DELETE PROCEDURE hProc.
    &ENDIF
    /* ****************************************************************************************** */
    FIND CURRENT Faccpedi NO-LOCK.
END.
RUN Procesa-Handle IN lh_handle ('browse').
MESSAGE 'Importación Exitosa' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* *********************************** */
PROCEDURE Importar-Detalle-Excel-Marco:
/* *********************************** */
DEF OUTPUT PARAMETER cTipoPrecio AS CHAR.
DEF VAR I-NPEDI AS INT NO-UNDO.

/* CHEQUEAMOS LA INTEGRIDAD DEL ARCHIVO EXCEL */
/* 1ro el Cliente */
cValue = chWorkSheet:Cells(11,1):VALUE.      
ASSIGN
    cValue = SUBSTRING(cValue,12,11)
    NO-ERROR.
IF cValue = "" OR cValue = ? OR ERROR-STATUS:ERROR = YES THEN DO:
    MESSAGE 'No hay datos del cliente:' cValue VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
IF Faccpedi.codcli <> cValue THEN DO:
    MESSAGE 'Cliente errado' SKIP
        'Cliente:' cValue 'errado'
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
/* 2do la Cotización */
cValue = chWorkSheet:Cells(9,7):VALUE.      
ASSIGN
    cValue = REPLACE(cValue,'-','')
    NO-ERROR.
IF cValue = "" OR cValue = ? OR error-status:ERROR = YES THEN DO:
    MESSAGE 'No hay datos del número de cotización:' cValue VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
IF Faccpedi.nroped <> cValue THEN DO:
    MESSAGE 'Formato del archivo Excel errado' SKIP
        'Número de pedido:' cValue 'errado'
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
/* Cargamos detalle */
ASSIGN
    t-Row = 21
    I-NPEDI = 0.
REPEAT:
    ASSIGN
        t-Row  = t-Row + 1
        I-NPEDI = I-NPEDI + 1.

    cValue = chWorkSheet:Cells(t-Row, 2):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 

    /* Artículo */
    ASSIGN
        cValue = STRING(INTEGER(cValue), '999999')
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN NEXT.
    CREATE PEDI.
    ASSIGN
        PEDI.NroItm = I-NPEDI
        PEDI.codcia = s-codcia
        PEDI.codmat = cValue.
    /* Cantidad */
    cValue = chWorkSheet:Cells(t-Row, 3):VALUE.
    ASSIGN
        PEDI.canped = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES OR PEDI.canPed <= 0 THEN DO:
        MESSAGE "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  SKIP
            "Cantidad Pedida" VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
    /* Unidad */
    cValue = chWorkSheet:Cells(t-Row, 4):VALUE.
    ASSIGN
        PEDI.UndVta = cValue
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES OR PEDI.UndVta = "" THEN DO:
        MESSAGE "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  SKIP
            "Unidad de Venta" VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
    /* Unitario */
    cValue = chWorkSheet:Cells(t-Row, 8):VALUE.
    ASSIGN
        PEDI.PreUni = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES OR PEDI.PreUni = 0 THEN DO:
        MESSAGE "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  SKIP
            "Precio Unitario" VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
    /* Total */
    cValue = chWorkSheet:Cells(t-Row, 8):VALUE.
    ASSIGN
        PEDI.ImpLin = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES OR PEDI.ImpLin = 0 THEN DO:
        MESSAGE "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  SKIP
            "Total" VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
END.
/* Buscamos si están o no con igv */
cValue = chWorkSheet:Cells(t-Row + 4, 1):VALUE.
CASE TRUE:
    WHEN INDEX(cValue, 'NO INCLUYEN') > 0   THEN cTipoPrecio = "SIN IGV".
    WHEN INDEX(cValue, 'INCLUYEN') > 0      THEN cTipoPrecio = "CON IGV".
END CASE.
IF cTipoPrecio = "SIN IGV" THEN DO:
    FOR EACH PEDI:
        ASSIGN
            PEDI.PreUni = PEDI.PreUni * (1 + Faccpedi.PorIgv / 100)
            PEDI.ImpLin = ROUND(PEDI.ImpLin * (1 + Faccpedi.PorIgv / 100), 2).
    END.
END.
/* Borramos cantidades en cero */
I-NPEDI = I-NPEDI - 1.
FOR EACH PEDI WHERE PEDI.CanPed <= 0:
    I-NPEDI = I-NPEDI - 1.
    DELETE PEDI.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Excel-Provincias V-table-Win 
PROCEDURE Importar-Excel-Provincias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN vtagn/ventas-library PERSISTENT SET hProc.

RUN COT_Importar-Excel-Provincias IN hProc (INPUT-OUTPUT TABLE ITEM).
DELETE PROCEDURE hProc.

RUN Procesa-Handle IN lh_handle ( "Browse" ).

RUN Procesa-Handle IN lh_handle ( "Recalculo" ).


END PROCEDURE.

/*
DEFINE VARIABLE FILL-IN-Archivo AS CHAR NO-UNDO.
DEFINE VARIABLE OKpressed AS LOG NO-UNDO.
                                          
SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
    FILTERS "Archivos Excel (*.xls)" "*.xls", "Todos (*.*)" "*.*"
    TITLE "Archivo(s) de Carga..."
    MUST-EXIST
    /*RETURN-TO-START-DIR */
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.

/* CREAMOS LA HOJA EXCEL */
CREATE "Excel.Application" chExcelApplication.
chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-Archivo).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

SESSION:SET-WAIT-STATE('GENERAL').
RUN Importar-Detalle-Excel-Provincias.
SESSION:SET-WAIT-STATE('').

/* CERRAMOS EL EXCEL */
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 

END PROCEDURE.

/* **************************************** */
PROCEDURE Importar-Detalle-Excel-Provincias:
/* **************************************** */

DEF VAR I-NITEM AS INT NO-UNDO.
DEFINE VAR cCodArt AS CHAR.
DEFINE VAR cQty AS CHAR.

/* Cargamos detalle */
ASSIGN
    t-Row = 21   /* 8 */
    I-NITEM = 0.
EMPTY TEMP-TABLE ITEM.
REPEAT:
    ASSIGN
        t-Row  = t-Row + 1
        I-NITEM = I-NITEM + 1.

    /*cValue = chWorkSheet:Cells(t-Row, 1):VALUE.*/
    cCodArt = chWorkSheet:Cells(t-Row, 2):VALUE.
    IF cCodArt = "" OR cCodArt = ? THEN LEAVE.    /* FIN DE DATOS */ 

    /*cValue = chWorkSheet:Cells(t-Row, 8):VALUE.*/
    cValue = chWorkSheet:Cells(t-Row, 3):VALUE.
    IF cValue = ? OR cValue = "" THEN cValue = "0" .

    IF cValue <> "0" THEN DO:
        CREATE ITEM.
        ASSIGN
            ITEM.NroItm = I-NITEM
            ITEM.codcia = s-codcia
            ITEM.codmat = cCodArt.


        ASSIGN
            ITEM.canped = DECIMAL(cValue)
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  SKIP
                "Cantidad Pedida" VIEW-AS ALERT-BOX ERROR.
            RETURN.
        END.
    END.
END.
/* Borramos cantidades en cero */
I-NITEM = I-NITEM - 1.
FOR EACH ITEM WHERE ITEM.CanPed <= 0:
    I-NITEM = I-NITEM - 1.
    DELETE ITEM.
END.
/* Renumeramos */
FOR EACH ITEM BY ITEM.nroitm DESC:
    ITEM.nroitm = I-NITEM.
    I-NITEM = I-NITEM - 1.
END.

RUN Procesa-Handle IN lh_handle ('Browse').

END PROCEDURE.


*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-ListaExpress V-table-Win 
PROCEDURE Importar-ListaExpress :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Documentos a generar: COT, PED, O/D e inclusive HPK
------------------------------------------------------------------------------*/
MESSAGE 'Funcionalidad de baja' VIEW-AS ALERT-BOX WARNING.
RETURN 'ADM-ERROR'.

/* MESSAGE '¿Procedemos con la importación' VIEW-AS ALERT-BOX QUESTION         */
/*     BUTTONS YES-NO UPDATE rpta AS LOG.                                      */
/* IF rpta = NO THEN RETURN 'ADM-ERROR'.                                       */
/*                                                                             */
/* DEF VAR pEstado AS CHAR NO-UNDO.                                            */
/*                                                                             */
/* RUN gn/p-ecommerce ("aplic/gn/p-ecommerce-import-le.p","", OUTPUT pEstado). */
/* RUN Procesa-Handle IN lh_handle ('Ultimo-Registro').                        */
/* IF pEstado > '' THEN DO:                                                    */
/*     MESSAGE pEstado VIEW-AS ALERT-BOX ERROR.                                */
/*     RETURN 'ADM-ERROR'.                                                     */
/* END.                                                                        */
/* ELSE RETURN 'OK'.                                                           */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importar-listaexpress-iversa V-table-Win 
PROCEDURE importar-listaexpress-iversa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pEstado AS CHAR NO-UNDO.     

RUN gn/p-ecommerce ("aplic/gn/p-ecommerce-import-ped.p","", OUTPUT pEstado).
IF pEstado > '' THEN DO:
    MESSAGE pEstado VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
ELSE RUN Procesa-Handle IN lh_handle ('Ultimo-Registro').
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-ListaExpress-TXT V-table-Win 
PROCEDURE Importar-ListaExpress-TXT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-listaexpress.

DEFINE VAR x-regs AS INT.

RUN web\d-listaexpress-txt.r(INPUT-OUTPUT TABLE tt-listaexpress).

SESSION:SET-WAIT-STATE("GENERAL").

x-order-type = "PREMIUM".

FOR EACH tt-listaexpress NO-LOCK:
    x-regs = x-regs + 1.
END.

IF x-regs > 0 THEN DO:
    x-regs = 0.
    EMPTY TEMP-TABLE ITEM.
    FOR EACH tt-listaexpress WHERE tt-listaexpress.campo-c[8] = "" NO-LOCK:
        x-regs = x-regs + 1.
       CREATE ITEM.
        ASSIGN
            ITEM.NroItm = x-regs
            ITEM.codcia = s-codcia
            ITEM.codmat = tt-listaexpress.campo-c[1]
            ITEM.canped = tt-listaexpress.campo-f[1]
            ITEM.CodMatWeb = tt-listaexpress.campo-c[3]
            item.DesMatWeb = tt-listaexpress.campo-c[2].
    END.

    EMPTY TEMP-TABLE tt-listaexpress-sugeridos.
    FOR EACH tt-listaexpress WHERE tt-listaexpress.campo-c[8] = "SUGERIDO" NO-LOCK:
        CREATE tt-listaexpress-sugeridos.
        ASSIGN tt-listaexpress-sugeridos.campo-c[1] = tt-listaexpress.campo-c[1]
                tt-listaexpress-sugeridos.campo-c[2] = tt-listaexpress.campo-c[3].
    END.
END.

RUN Procesa-Handle IN lh_handle ( "Browse" ).

RUN Procesa-Handle IN lh_handle ( "Recalculo" ).

SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-MarketPlace V-table-Win 
PROCEDURE Importar-MarketPlace :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN vtagn/d-marketplace.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Supermercados V-table-Win 
PROCEDURE Importar-Supermercados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-Linea   AS CHAR FORMAT 'x(200)' NO-UNDO.
DEF VAR x-CodMat LIKE ITEM.codmat NO-UNDO.
DEF VAR x-CanPed LIKE ITEM.canped NO-UNDO.
DEF VAR x-ImpLin LIKE ITEM.implin NO-UNDO.
DEF VAR x-ImpIgv LIKE ITEM.impigv NO-UNDO.
DEF VAR x-Encabezado AS LOG INIT FALSE.
DEF VAR x-Detalle    AS LOG INIT FALSE.
DEF VAR x-NroItm AS INT INIT 0.
DEF VAR x-Ok AS LOG.
DEF VAR x-Item AS CHAR NO-UNDO.
  
DEFINE VARIABLE cSede   AS CHAR NO-UNDO.
DEFINE VARIABLE cCodCli AS CHAR NO-UNDO.

SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Archivo texto (.txt)' '*.txt'
    RETURN-TO-START-DIR
    TITLE 'Selecciona al archivo texto'
    MUST-EXIST
    USE-FILENAME
    UPDATE x-Ok.
IF x-Ok = NO THEN RETURN "ADM-ERROR".

EMPTY TEMP-TABLE ITEM.

/* Para Makro */
DEFINE VAR x-len AS INT.
DEFINE VAR x-pos AS INT.
DEFINE VAR x-len-oc AS INT INIT 12.         /* Caracteres de la O/C */
    
INPUT FROM VALUE(x-Archivo).
TEXTO:
REPEAT:
    IMPORT UNFORMATTED x-Linea.
    IF x-Linea BEGINS 'ENC' THEN DO:
        ASSIGN
            x-Encabezado = YES
            x-Detalle    = NO
            x-CodMat = ''
            x-CanPed = 0
            x-ImpLin = 0
            x-ImpIgv = 0.
        x-Item = TRIM(ENTRY(6,x-Linea)).
        
        /* Ic - 26Set2018, correo pilar vega CASO 65407, 12 penultimos digitos (el ultimo NO) */
        /*FacCPedi.ordcmp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(x-Item,11,10).*/
        IF LENGTH(x-item) > x-len-oc THEN DO:
            x-len = LENGTH(x-item) - 1.
            x-pos = (x-len - x-len-oc) + 1.
            x-item = SUBSTRING(x-item,x-pos,x-len-oc).
        END.
        FacCPedi.ordcmp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-Item.
    END.
/*     IF x-Linea BEGINS 'DTM' THEN DO:                                                                            */
/*         x-Item = ENTRY(5,x-Linea).                                                                              */
/*         ASSIGN                                                                                                  */
/*             FacCPedi.fchven:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(DATE(SUBSTRING(x-Item,7,2) + '/' +     */
/*                                                                                   SUBSTRING(x-Item,5,2) + '/' + */
/*                                                                                  SUBSTRING(x-Item,1,4)) )       */
/*             NO-ERROR.                                                                                           */
/*     END.                                                                                                        */
    /* Sede y Lugar de Entrega */
    IF x-Linea BEGINS 'DPGR' AND NUM-ENTRIES(x-Linea) > 1 THEN DO:
        cSede = TRIM(ENTRY(2,x-Linea)).
    END.
    /* Cliente */
    IF x-Linea BEGINS 'IVAD' AND NUM-ENTRIES(x-Linea) > 1 THEN DO:
        cCodCli = TRIM(ENTRY(2,x-Linea)).
        /* PINTAMOS INFORMACION */
        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codibc = cCodCli
            AND gn-clie.flgsit = 'A'
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            ASSIGN
                /*s-codcli = gn-clie.codcli.*/
                Faccpedi.codcli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gn-clie.codcli.
            FIND FIRST gn-clied OF gn-clie WHERE Gn-ClieD.Libre_c01 = cSede NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clied THEN DO WITH FRAME {&FRAME-NAME}:
                ASSIGN
                    Faccpedi.sede:SCREEN-VALUE = Gn-ClieD.Sede.
                FIND gn-clied WHERE gn-clied.codcia = cl-codcia
                    AND gn-clied.codcli = Faccpedi.codcli:SCREEN-VALUE 
                    AND gn-clied.sede = Faccpedi.sede:SCREEN-VALUE 
                    NO-LOCK NO-ERROR.
                IF AVAILABLE gn-clied
                THEN ASSIGN 
                      FILL-IN-Sede:SCREEN-VALUE = Gn-ClieD.DirCli
                      /*FacCPedi.LugEnt:SCREEN-VALUE = Gn-ClieD.DirCli*/
                      FacCPedi.Glosa:SCREEN-VALUE = (IF FacCPedi.Glosa:SCREEN-VALUE = '' THEN Gn-ClieD.DirCli ELSE FacCPedi.Glosa:SCREEN-VALUE).
            END.
        END.
    END.

    /* DETALLE */
    IF x-Linea BEGINS 'LIN' 
    THEN ASSIGN
            x-Encabezado = FALSE
            x-Detalle = YES.
    IF x-Detalle = YES THEN DO:
        IF x-Linea BEGINS 'LIN' 
        THEN DO:
            x-Item = ENTRY(2,x-Linea).
            IF NUM-ENTRIES(x-Linea) = 6
            THEN ASSIGN x-CodMat = STRING(INTEGER(ENTRY(6,x-Linea)), '999999') NO-ERROR.
            ELSE ASSIGN x-CodMat = ENTRY(3,x-Linea) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN x-CodMat = ENTRY(3,x-Linea).
        END.
        FIND Almmmatg WHERE almmmatg.codcia = s-codcia
            AND Almmmatg.codmat = x-codmat
            AND Almmmatg.tpoart <> 'D'
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatg
        THEN DO:
            FIND Almmmatg WHERE almmmatg.codcia = s-codcia
                AND almmmatg.codbrr = x-codmat
                AND Almmmatg.tpoart <> 'D'
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almmmatg THEN x-codmat = almmmatg.codmat.
        END.
        IF NOT AVAILABLE Almmmatg
        THEN DO:
            MESSAGE "El Item" x-Item x-codmat "no esta registrado en el catalogo"
                    VIEW-AS ALERT-BOX ERROR.
            NEXT TEXTO.
        END.

        IF x-Linea BEGINS 'QTY' THEN x-CanPed = DECIMAL(ENTRY(2,x-Linea)).
        IF x-Linea BEGINS 'MOA' THEN x-ImpLin = DECIMAL(ENTRY(2,x-Linea)).
        IF x-Linea BEGINS 'TAX' 
        THEN DO:
            ASSIGN
                x-ImpIgv = DECIMAL(ENTRY(3,x-Linea))
                x-NroItm = x-NroItm + 1.
            /* consistencia de duplicidad */
            FIND FIRST ITEM WHERE ITEM.codmat = x-CodMat NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ITEM THEN DO:
                CREATE ITEM.
                ASSIGN 
                    ITEM.CodCia = s-codcia
                    ITEM.codmat = x-CodMat
                    ITEM.Factor = 1 
                    ITEM.CanPed = x-CanPed
                    ITEM.NroItm = x-NroItm 
                    ITEM.UndVta = (IF AVAILABLE Almmmatg THEN Almmmatg.Chr__01 ELSE '')
                    ITEM.ALMDES = ENTRY(1,S-CODALM)
                    ITEM.AftIgv = (IF x-ImpIgv > 0 THEN YES ELSE NO).
                /* RHC 09.08.06 IGV de acuerdo al cliente */
                IF LOOKUP(TRIM(s-CodCli), '20100070970,20109072177,20100106915,20504912851') > 0
                THEN ASSIGN
                        ITEM.ImpIgv = x-ImpIgv 
                        ITEM.ImpLin = x-ImpLin
                        ITEM.PreUni = (ITEM.ImpLin / ITEM.CanPed).
                ELSE ASSIGN
                        ITEM.ImpIgv = x-ImpIgv 
                        ITEM.ImpLin = x-ImpLin + x-ImpIgv
                        ITEM.PreUni = (ITEM.ImpLin / ITEM.CanPed).
            END.    /* fin de grabacion del detalle */
        END.
    END.
  END.
  INPUT CLOSE.
  /* BLOQUEAMOS CAMPOS */
  ASSIGN
      FacCPedi.CodCli:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      FacCPedi.CodMon:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      FacCPedi.Libre_d01:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

  /* Variable de control */
  ASSIGN
      s-import-ibc = YES.
  
  /* PINTAMOS INFORMACION */
  IF FacCPedi.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN DO:
      ASSIGN
          FacCPedi.CodCli:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
      APPLY 'ENTRY':U TO Faccpedi.codcli IN FRAME {&FRAME-NAME}.
  END.
  ELSE APPLY 'LEAVE':U TO Faccpedi.codcli IN FRAME {&FRAME-NAME}.

  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importar-supermercados-B2Bv2 V-table-Win 
PROCEDURE importar-supermercados-B2Bv2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE BUFFER b-FacCorre FOR FacCorre.                                
                                
FIND b-FacCorre WHERE b-FacCorre.CodCia = S-CODCIA 
    AND b-FacCorre.CodDoc = S-CODDOC 
    AND b-FacCorre.NroSer = s-NroSer
    NO-LOCK NO-ERROR.
IF b-FacCorre.FlgEst = NO THEN DO:
    MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.

DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-Linea   AS CHAR FORMAT 'x(200)' NO-UNDO.
DEF VAR x-CodMat LIKE ITEM.codmat NO-UNDO.
DEF VAR x-CanPed LIKE ITEM.canped NO-UNDO.
DEF VAR x-ImpLin LIKE ITEM.implin NO-UNDO.
DEF VAR x-ImpIgv LIKE ITEM.impigv NO-UNDO.
DEF VAR x-Encabezado AS LOG INIT FALSE.
DEF VAR x-Detalle    AS LOG INIT FALSE.
DEF VAR x-NroItm AS INT INIT 0.
DEF VAR x-Ok AS LOG.
DEF VAR x-Item AS CHAR NO-UNDO.

DEFINE VAR x-precio AS DEC.
DEFINE VAR x-precio-sin-igv AS DEC.
DEFINE VAR x-Cargo-Orden AS LOG.
DEFINE VAR x-ordenes-x-cargar AS INT.
  
DEFINE VARIABLE cSede   AS CHAR NO-UNDO.
DEFINE VARIABLE cCodCli AS CHAR NO-UNDO.
/* B2Bv2 */
DEFINE VARIABLE cNro-oc AS CHAR .
DEFINE VARIABLE clocal AS CHAR.
DEFINE VARIABLE cMsgFinal AS CHAR.

SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Archivo Excel (.xls)' '*.xls' , 'Archivo Excel (.xlsx)' '*.xlsx'
    RETURN-TO-START-DIR
    TITLE 'Selecciona al archivo Excel'
    MUST-EXIST
    USE-FILENAME
    UPDATE x-Ok.
IF x-Ok = NO THEN RETURN "ADM-ERROR".

EMPTY TEMP-TABLE tt-OrdenesPlazVea.

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.

DEFINE VAR lOrden AS CHAR.
DEFINE VAR lCodEan AS CHAR.

lFileXls = x-Archivo.           /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = NO.        /* YES : Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

chExcelApplication:Visible = FALSE.

lMensajeAlTerminar = NO. /*  */
lCerrarAlTerminar = YES.        /* Si permanece abierto el Excel luego de concluir el proceso */

EMPTY TEMP-TABLE tt-OrdenesPlazVea.
EMPTY TEMP-TABLE OrdenCompra-Tienda.

/* Cuantas ORDENES tiene el Excel */
iColumn = 1.
x-ordenes-x-cargar = 0.
DO iColumn = 2 TO 65000:
    cRange = "B" + TRIM(STRING(iColumn)).
    cValue = TRIM(STRING(chWorkSheet:Range(cRange):VALUE,">>>>>>>>>>>9")).

    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */

    /* O/C */
    cNro-oc = cValue.
    /* Local destino */
    cRange = "U" + TRIM(STRING(iColumn)).
    cLocal = TRIM(chWorkSheet:Range(cRange):VALUE).

    FIND FIRST tt-OrdenesPlazVea WHERE tt-nroorden = cNro-Oc NO-ERROR.
    IF NOT AVAILABLE tt-OrdenesPlazVea THEN DO:
        /* LAS ORDENES DE COMPRA */
        FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                factabla.tabla = 'OC PLAZA VEA' AND 
                factabla.codigo = cNro-Oc NO-LOCK NO-ERROR.
        IF NOT AVAILABLE factabla THEN DO:
            CREATE tt-OrdenesPlazVea.
                ASSIGN tt-OrdenesPlazVea.tt-nroorden = cNro-Oc
                        cRange = "A" + TRIM(STRING(iColumn))
                        tt-OrdenesPlazVea.tt-CodClie = TRIM(chWorkSheet:Range(cRange):VALUE)                    
                        cRange = "D" + TRIM(STRING(iColumn))
                        tt-OrdenesPlazVea.tt-locentrega = TRIM(chWorkSheet:Range(cRange):VALUE).
        END.
    END.  
    /* ORDENES DE COMPRA X LOCAL */
    FIND FIRST OrdenCompra-Tienda WHERE nro-oc = cNro-oc AND
                                        clocal-destino = cLocal NO-ERROR.
    IF NOT AVAILABLE OrdenCompra-Tienda THEN DO:
        CREATE OrdenCompra-Tienda.
        ASSIGN  OrdenCompra-Tienda.nro-oc = cNro-oc
                OrdenCompra-Tienda.clocal-destino = cLocal
                cRange = "V" + TRIM(STRING(iColumn))
                OrdenCompra-Tienda.dlocal-destino = TRIM(chWorkSheet:Range(cRange):VALUE)
                cRange = "D" + TRIM(STRING(iColumn))
                OrdenCompra-Tienda.clocal-entrega = TRIM(chWorkSheet:Range(cRange):VALUE)
                cRange = "E" + TRIM(STRING(iColumn))
                OrdenCompra-Tienda.dlocal-entrega = TRIM(chWorkSheet:Range(cRange):VALUE)
                cRange = "A" + TRIM(STRING(iColumn))
                OrdenCompra-Tienda.CodClie = TRIM(chWorkSheet:Range(cRange):VALUE).

        /* Fecha de Entrega - En el excel debe estar asi : 24-02-2017  (dd-mm-aaaa)*/
        cRange = "H" + TRIM(STRING(iColumn)).
        ASSIGN  OrdenCompra-tienda.fecha-entrega = DATE(TRIM(chWorkSheet:Range(cRange):TEXT)) NO-ERROR.
    END.

END.
/* ******************************************* */
/* RHC 15/08/2017 Control de errores del excel */
/* ******************************************* */
DO iColumn = 2 TO 65000:
    ASSIGN 
        x-CodMat = ''.
    /* Orden */
    cRange = "B" + TRIM(STRING(iColumn)).
    cValue = TRIM(STRING(chWorkSheet:Range(cRange):VALUE,">>>>>>>>>>>9")).
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */
    /* Articulo de la misma Orden  */
    cRange = "J" + TRIM(STRING(iColumn)).
    lCodEan = TRIM(chWorkSheet:Range(cRange):VALUE).                
    /* Buscar el codigo como interno */
    FIND FIRST Almmmatg WHERE almmmatg.codcia = s-codcia 
        AND almmmatg.Codmat = lCodEan NO-LOCK NO-ERROR.
    x-CodMat = IF(AVAILABLE almmmatg) THEN almmmatg.codmat ELSE x-CodMat.
    IF X-CodMat = '' THEN DO:
        /* Buscar el codigo interno primero con EAN13 */
        FIND FIRST Almmmatg WHERE almmmatg.codcia = s-codcia 
            AND almmmatg.CodBrr = lCodEan NO-LOCK NO-ERROR.
        x-CodMat = IF(AVAILABLE almmmatg) THEN almmmatg.codmat ELSE x-CodMat.
    END.
    /* si no existe com EAN13 lo busco como EAN14  */
    IF X-CodMat = '' THEN DO:
        FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia 
            AND almmmat1.barras[1] = lCodEan NO-LOCK NO-ERROR.
        x-CodMat = IF(AVAILABLE almmmat1) THEN almmmat1.barras[1] ELSE x-CodMat.
    END.
    IF X-CodMat = '' THEN DO:
        FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia 
            AND almmmat1.barras[2] = lCodEan NO-LOCK NO-ERROR.
        x-CodMat = IF(AVAILABLE almmmat1) THEN almmmat1.barras[2] ELSE x-CodMat.
    END.
    IF X-CodMat = '' THEN DO:
        FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia 
            AND almmmat1.barras[3] = lCodEan NO-LOCK NO-ERROR.
        x-CodMat = IF(AVAILABLE almmmat1) THEN almmmat1.barras[3] ELSE x-CodMat.
    END.
    IF X-CodMat = '' THEN DO:
        FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia 
            AND almmmat1.barras[4] = lCodEan NO-LOCK NO-ERROR.
        x-CodMat = IF(AVAILABLE almmmat1) THEN almmmat1.barras[4] ELSE x-CodMat.
    END.
    IF X-CodMat = '' THEN DO:
        FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND 
                            almmmat1.barras[5] = lCodEan NO-LOCK NO-ERROR.
        x-CodMat = IF(AVAILABLE almmmat1) THEN almmmat1.barras[5] ELSE x-CodMat.
    END.
    IF x-CodMat = '' THEN DO:
        MESSAGE 'ERROR línea' iColumn SKIP 'EAN' lCodEan 'NO REGISTTRADO' VIEW-AS ALERT-BOX ERROR.
        /* Cerrar el Excel  */
        {lib\excel-close-file.i}
        RETURN 'ADM-ERROR'.
    END.
    /* Se ubico el Codigo Interno  */
    FIND Almmmatg WHERE almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = x-codmat
        AND Almmmatg.tpoart <> 'D'
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        MESSAGE 'ERROR línea' iColumn SKIP 'EAN' lCodEan 'DESACTIVADO' VIEW-AS ALERT-BOX ERROR.
        /* Cerrar el Excel  */
        {lib\excel-close-file.i}
        RETURN 'ADM-ERROR'.
    END.
END.
/* ******************************************* */

x-ordenes-x-cargar = 0.
cCOTDesde = "".
cCOTHasta = "".

PRINCIPAL:
FOR EACH tt-OrdenesPlazVea :
    lOrden = tt-OrdenesPlazVea.tt-nroorden.
    FOR EACH OrdenCompra-tienda WHERE lOrden = OrdenCompra-Tienda.nro-oc :
        ASSIGN
            cCodCli = TRIM(OrdenCompra-Tienda.CodClie)
            cSede = OrdenCompra-Tienda.clocal-entrega
            lOrden = OrdenCompra-Tienda.nro-oc.

        SESSION:SET-WAIT-STATE('GENERAL').
        /* Adiciono Registro en Cabecera */
        RUN ue-add-record.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, LEAVE PRINCIPAL.

        ASSIGN s-Import-B2B = YES.  /* OJO */
    
        ASSIGN 
            Faccpedi.FlgEst = "P"     /* OJO */
            FacCPedi.Glosa = TRIM(OrdenCompra-tienda.clocal-destino) + " " + TRIM(OrdenCompra-tienda.dlocal-destino)
            FacCPedi.ordcmp = OrdenCompra-Tienda.nro-oc
            FacCPedi.ubigeo[1] = TRIM(OrdenCompra-tienda.clocal-destino) + " " + TRIM(OrdenCompra-tienda.dlocal-destino).        
        /* ******************************************** */
        /* RHC 19/050/2021 Datos para HOMOLOGAR las COT */
        /* ******************************************** */
        IF TRUE <> (FacCPedi.CustomerPurchaseOrder  > '') THEN FacCPedi.CustomerPurchaseOrder = Faccpedi.OrdCmp.
        /* ******************************************** */
        /* ******************************************** */
        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = cCodCli
            AND gn-clie.flgsit = 'A'
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            ASSIGN
                s-codcli = gn-clie.codcli.
                Faccpedi.codcli = gn-clie.codcli.
    
            FIND FIRST gn-clied OF gn-clie WHERE Gn-ClieD.sede = cSede NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clied THEN DO WITH FRAME {&FRAME-NAME}:
                ASSIGN
                    Faccpedi.sede = Gn-ClieD.Sede.
                FIND gn-clied WHERE gn-clied.codcia = cl-codcia
                    AND gn-clied.codcli = cCodCli 
                    AND gn-clied.sede = csede
                    NO-LOCK NO-ERROR.
                IF AVAILABLE gn-clied THEN 
                    ASSIGN 
                        FacCPedi.LugEnt = Gn-ClieD.DirCli.
            END.

            /* Del CLIENTE */

            s-CodCli = cCodCli.

            /* Cargamos las condiciones de venta válidas */
            FIND gn-clie WHERE gn-clie.codcia  = cl-codcia
                AND gn-clie.codcli = s-codcli
                NO-LOCK.
            RUN vta2/p-fmapgo (s-codcli, s-tpoped, OUTPUT s-cndvta-validos).            
            s-FmaPgo = ENTRY(1, s-cndvta-validos).

            ASSIGN 
                FacCPedi.FmaPgo = s-FmaPgo
                Faccpedi.NomCli = gn-clie.NomCli
                Faccpedi.DirCli = gn-clie.DirCli
                Faccpedi.RucCli = gn-clie.Ruc
                FacCPedi.NroCard = gn-clie.NroCard
                Faccpedi.CodVen = gn-clie.CodVen
                Faccpedi.FaxCli = SUBSTRING(TRIM(gn-clie.clfcli) + "00",1,2) +
                                    SUBSTRING(TRIM(gn-clie.clfcli2) + "00",1,2)
                Faccpedi.Cmpbnte = 'FAC'.
            /* ------------------------------ */
        END.
        /* Leer el Detalle */
        x-NroItm = 0.
        x-Cargo-Orden = NO.
        lOrdenGrabada = "".
        /* El Detalle de la Orden */
        DO iColumn = 2 TO 65000:
            ASSIGN 
                x-CodMat = ''
                x-CanPed = 0
                x-ImpLin = 0
                x-ImpIgv = 0
                x-precio = 0.
            /* Orden */
            cRange = "B" + TRIM(STRING(iColumn)).
            cValue = TRIM(STRING(chWorkSheet:Range(cRange):VALUE,">>>>>>>>>>>9")).
    
            IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */
    
            /* O/C */
            cNro-oc = cValue.
            /* Local destino */
            cRange = "U" + TRIM(STRING(iColumn)).
            cLocal = TRIM(chWorkSheet:Range(cRange):VALUE).
    
            IF cNro-oc = OrdenCompra-Tienda.nro-oc AND cLocal = OrdenCompra-Tienda.clocal-destino THEN DO:
                /* Articulo de la misma Orden  */
                cRange = "J" + TRIM(STRING(iColumn)).
                lCodEan = TRIM(chWorkSheet:Range(cRange):VALUE).                
    
                /* Buscar el codigo como interno */
                FIND FIRST Almmmatg WHERE almmmatg.codcia = s-codcia AND 
                            almmmatg.Codmat = lCodEan NO-LOCK NO-ERROR.
                x-CodMat = IF(AVAILABLE almmmatg) THEN almmmatg.codmat ELSE x-CodMat.
                IF X-CodMat = '' THEN DO:
                    /* Buscar el codigo interno primero con EAN13 */
                    FIND FIRST Almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                almmmatg.CodBrr = lCodEan NO-LOCK NO-ERROR.
                    x-CodMat = IF(AVAILABLE almmmatg) THEN almmmatg.codmat ELSE x-CodMat.
                END.
                /* si no existe com EAN13 lo busco como EAN14  */
                IF X-CodMat = '' THEN DO:
                    FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND 
                                        almmmat1.barras[1] = lCodEan NO-LOCK NO-ERROR.
                    x-CodMat = IF(AVAILABLE almmmat1) THEN almmmat1.barras[1] ELSE x-CodMat.
                END.
                IF X-CodMat = '' THEN DO:
                    FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND 
                                        almmmat1.barras[2] = lCodEan NO-LOCK NO-ERROR.
                    x-CodMat = IF(AVAILABLE almmmat1) THEN almmmat1.barras[2] ELSE x-CodMat.
                END.
                IF X-CodMat = '' THEN DO:
                    FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND 
                                        almmmat1.barras[3] = lCodEan NO-LOCK NO-ERROR.
                    x-CodMat = IF(AVAILABLE almmmat1) THEN almmmat1.barras[3] ELSE x-CodMat.
                END.
                IF X-CodMat = '' THEN DO:
                    FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND 
                                        almmmat1.barras[4] = lCodEan NO-LOCK NO-ERROR.
                    x-CodMat = IF(AVAILABLE almmmat1) THEN almmmat1.barras[4] ELSE x-CodMat.
                END.
                IF X-CodMat = '' THEN DO:
                    FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND 
                                        almmmat1.barras[5] = lCodEan NO-LOCK NO-ERROR.
                    x-CodMat = IF(AVAILABLE almmmat1) THEN almmmat1.barras[5] ELSE x-CodMat.
                END.
                /* 4,5 Ean14s */
                IF x-CodMat <> ''  THEN DO:
                    /* Se ubico el Codigo Interno  */
                    FIND Almmmatg WHERE almmmatg.codcia = s-codcia
                        AND Almmmatg.codmat = x-codmat
                        AND Almmmatg.tpoart <> 'D'
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE Almmmatg THEN DO:
    
                        /* Cantidad pedida */
                        cRange = "W" + TRIM(STRING(iColumn)).
                        x-CanPed = chWorkSheet:Range(cRange):VALUE.
                        /* El precio final */
                        cRange = "T" + TRIM(STRING(iColumn)).
                        x-precio =  chWorkSheet:Range(cRange):VALUE.
                        /* Precio sin IGV */
                        cRange = "S" + TRIM(STRING(iColumn)).
                        x-precio-sin-igv = chWorkSheet:Range(cRange):VALUE.
                        /**/
                        x-ImpLin = x-CanPed * x-precio.
                        /* Verificar el IGV */
                        IF x-precio > x-precio-sin-igv THEN DO:
                            x-ImpIgv = x-ImpLin - (x-CanPed * x-precio-sin-igv).
                        END.                        
    
                        /* Items */
                        FIND FIRST ITEM WHERE ITEM.codmat = x-CodMat NO-LOCK NO-ERROR.
                        IF NOT AVAILABLE ITEM THEN DO:
    
                            x-Cargo-Orden = YES.
                            x-NroItm = x-NroItm + 1.
                            lOrdenGrabada = lOrden.
    
                            CREATE ITEM.
                            ASSIGN 
                                ITEM.CodCia = s-codcia
                                ITEM.codmat = x-CodMat
                                ITEM.Factor = 1 
                                ITEM.CanPed = x-CanPed
                                ITEM.NroItm = x-NroItm 
                                ITEM.UndVta = (IF AVAILABLE Almmmatg THEN Almmmatg.Chr__01 ELSE '')
                                ITEM.ALMDES = S-CODALM
                                ITEM.AftIgv = (IF x-ImpIgv > 0 THEN YES ELSE NO).
                            /* RHC 09.08.06 IGV de acuerdo al cliente */
                            IF LOOKUP(TRIM(s-CodCli), '20100070970,20109072177,20100106915,20504912851') > 0
                            THEN ASSIGN
                                    ITEM.ImpIgv = x-ImpIgv 
                                    ITEM.ImpLin = x-ImpLin
                                    ITEM.PreUni = x-precio.  /* (ITEM.ImpLin / ITEM.CanPed).*/
                            ELSE ASSIGN
                                    ITEM.ImpIgv = x-ImpIgv 
                                    ITEM.ImpLin = x-ImpLin /*+ x-ImpIgv*/
                                    ITEM.PreUni = x-precio. /* (ITEM.ImpLin / ITEM.CanPed) */
                        END.    /* fin de grabacion del detalle */
    
                    END.
                    ELSE DO:
                        /*
                        MESSAGE "El Item " x-Item " Articulo (" x-codmat ") no esta registrado en el catalogo"
                                VIEW-AS ALERT-BOX ERROR.
                        */
                    END.                    
                END.
                ELSE DO:
                    /*
                    MESSAGE "El Item" x-Item "Cod Ean (" lCodEan ") es inubicable"
                            VIEW-AS ALERT-BOX ERROR.
                    */
                END.
            END.            
        END.        
        /* ----------------------------- */
        IF x-Cargo-Orden = YES THEN DO:
            x-ordenes-x-cargar = x-ordenes-x-cargar + 1.
            ASSIGN
                s-Import-B2B = YES
                FacCPedi.Libre_c05 = "3".   /* OJO */
            RUN ue-assign-statement.
        END.
        SESSION:SET-WAIT-STATE('').
    END.
END.
/* Cerrar el Excel  */
{lib\excel-close-file.i}

MESSAGE "Se generaron " + STRING(x-ordenes-x-cargar,">>>9") + " COTIZACION(ES)" SKIP(1)
            "Desde " + cCOTDesde + " Hasta " + cCOTHasta.

RUN Procesa-Handle IN lh_handle ('Ultimo-Registro').

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Tiendas-B2B V-table-Win 
PROCEDURE Importar-Tiendas-B2B :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pTienda AS INT NO-UNDO.

RUN vta2\d-selecciona-tienda-b2b (OUTPUT pTienda).
IF pTienda = 0 THEN RETURN.

IF pTienda = 1 THEN DO:
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN importar-supermercados-B2Bv2.
    SESSION:SET-WAIT-STATE('').
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE impuesto-icbper V-table-Win 
PROCEDURE impuesto-icbper :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Ic - 03Oct2019, bolsas plasticas, adicionar el registro de IMPUESTO (ICBPER) */
  DEFINE VAR x-ultimo-item AS INT.
  DEFINE VAR x-cant-bolsas AS INT.
  DEFINE VAR x-precio-ICBPER AS DEC.
  DEFINE VAR x-alm-des AS CHAR INIT "".

  x-ultimo-item = -1.
  x-cant-bolsas = 0.
  x-precio-ICBPER = 0.0.

  /* Sacar el importe de bolsas plasticas */
  DEFINE VAR z-hProc AS HANDLE NO-UNDO.               /* Handle Libreria */
  
  RUN ccb\libreria-ccb.p PERSISTENT SET z-hProc.
  /* Procedimientos */
  RUN precio-impsto-bolsas-plastica IN z-hProc (INPUT TODAY, OUTPUT x-precio-ICBPER).
  DELETE PROCEDURE z-hProc.                   /* Release Libreria */

  FOR EACH ITEM, FIRST Almmmatg OF ITEM NO-LOCK BY ITEM.NroItm DESC:
      IF Almmmatg.CodFam = '086' AND Almmmatg.SubFam = '001' THEN DO:
          x-cant-bolsas = x-cant-bolsas + (ITEM.canped * ITEM.factor).
          x-alm-des = ITEM.almdes.
      END.
  END.

  x-ultimo-item = 0.
  FOR EACH ITEM WHERE item.codmat = x-articulo-ICBPER :
      DELETE ITEM.
  END.

  FOR EACH ITEM BY ITEM.NroItm:
      x-ultimo-item = x-ultimo-item + 1.
      ASSIGN ITEM.implinweb = x-ultimo-item.
  END.
  FOR EACH ITEM :
      x-ultimo-item = x-ultimo-item + 1.
      ASSIGN ITEM.NroItm = ITEM.implinweb
            ITEM.implinweb = 0.
  END.

  IF x-cant-bolsas > 0 THEN DO:

      FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                almmmatg.codmat = x-articulo-ICBPER NO-LOCK NO-ERROR.

        x-ultimo-item = x-ultimo-item + 1.

        CREATE ITEM.
        ASSIGN
          ITEM.CodCia = Faccpedi.CodCia
          ITEM.CodDiv = Faccpedi.CodDiv
          ITEM.coddoc = Faccpedi.coddoc
          ITEM.NroPed = Faccpedi.NroPed
          ITEM.FchPed = Faccpedi.FchPed
          ITEM.Hora   = Faccpedi.Hora 
          ITEM.FlgEst = Faccpedi.FlgEst
          ITEM.NroItm = x-ultimo-item
          ITEM.CanPick = 0.   /* OJO */

      ASSIGN 
          ITEM.codmat = x-articulo-ICBPER
          ITEM.UndVta = IF (AVAILABLE almmmatg) THEN Almmmatg.UndA ELSE 'UNI'
          ITEM.almdes = x-alm-des
          ITEM.Factor = 1
          ITEM.PorDto = 0
          ITEM.PreBas = x-precio-ICBPER
          ITEM.AftIgv = IF (AVAILABLE almmmatg) THEN Almmmatg.AftIgv ELSE NO
          ITEM.AftIsc = NO
          ITEM.Libre_c04 = "".
      ASSIGN 
          ITEM.CanPed = x-cant-bolsas
          ITEM.PreUni = x-precio-ICBPER
          ITEM.Por_Dsctos[1] = 0.00
          ITEM.Por_Dsctos[2] = 0.00
          ITEM.Por_Dsctos[3] = 0.00
          ITEM.Libre_d02     = 0.
      ASSIGN
          ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                        ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                        ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                        ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
      IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
          THEN ITEM.ImpDto = 0.
          ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
      /* ***************************************************************** */
    
      ASSIGN
          ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
          ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
      IF ITEM.AftIsc 
        THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
      ELSE ITEM.ImpIsc = 0.
        IF ITEM.AftIgv 
      THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
        ELSE ITEM.ImpIgv = 0.
  END.

  /* Ic - 03Oct2019, bolsas plasticas */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /**/
  EMPTY TEMP-TABLE tt-listaexpress-sugeridos.

  /* Code placed here will execute PRIOR to standard behavior. */
  CASE s-TpoPed:
      WHEN "LF" THEN DO:
          MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
  END CASE.
  
  /* ********************************************************* */
  /* RHC 17/04/19 Consistencia de vigencia de lista de precios */
  /* ********************************************************* */
  FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-div.coddiv = pCodDiv NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-divi THEN DO:
      MESSAGE 'Lista de Precios' pCodDiv 'NO válida' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  IF GN-DIVI.Campo-Date[1] <> ? AND GN-DIVI.Campo-Date[2] <> ? THEN DO:
      IF NOT (TODAY >= GN-DIVI.Campo-Date[1] AND TODAY <= GN-DIVI.Campo-Date[2]) THEN DO:
          MESSAGE 'Lista de Precios' pCodDiv 'no está vigente' SKIP
              'Comuníquese con el área Comercial' SKIP(1)
              'Proceso Abortado'
              VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.
  END.
  /* 22/01/2022 Solo para EVENTOS*/
  IF s-TpoPed = "E" THEN DO:
      IF GN-DIVI.Campo-Date[1] = ? OR GN-DIVI.Campo-Date[2] = ? THEN DO:
          MESSAGE 'Debe estar configurada correctamente la vigencia de la lista de precios' SKIP
              'Comuníquese con el área Comercial' SKIP(1)
              'Proceso Abortado'
              VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.
  END.
  /* ********************************************************* */
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDoc = S-CODDOC 
      AND FacCorre.NroSer = s-NroSer
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCorre THEN DO:
      MESSAGE 'La serie' s-NroSer 'NO existe' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  IF FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK.
  ASSIGN
      s-Import-IBC      = NO
      s-Import-B2B      = NO
      s-Copia-Registro = NO
      s-PorIgv = FacCfgGn.PorIgv
      s-adm-new-record = "YES"
      s-nroped = ""
      lOrdenGrabada = ""
      S-TPOMARCO = ""
      s-nivel-acceso = 1.   /* Permitido */

  /* ********************************************************* */
  /* Dispatch standard ADM method.                             */
  /* ********************************************************* */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* ********************************************************* */

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Borra-Temporal.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          s-CodMon = 1
          s-CodCli = ""     /* FacCfgGn.CliVar */
          s-FmaPgo = ''
          s-TpoCmb = 1
          s-NroDec = 4
          s-FlgIgv = YES    /* Venta AFECTA a IGV */
          FacCPedi.CodMon:SCREEN-VALUE = "Soles"
          FacCPedi.Cmpbnte:SCREEN-VALUE = "FAC"
          FacCPedi.Libre_d01:SCREEN-VALUE = STRING(s-NroDec, '9')
          FacCPedi.FlgIgv:SCREEN-VALUE = "YES".

      FIND TcmbCot WHERE  TcmbCot.Codcia = 0
          AND  (TcmbCot.Rango1 <= TODAY - TODAY + 1
          AND   TcmbCot.Rango2 >= TODAY - TODAY + 1)
          NO-LOCK NO-ERROR.
      IF AVAIL TcmbCot THEN S-TPOCMB = TcmbCot.TpoCmb.  

      /* RHC 11.08.2014 TC Caja Compra */
      FOR EACH gn-tccja NO-LOCK BY Fecha:
          IF TODAY >= Fecha THEN s-TpoCmb = Gn-TCCja.Compra.
      END.

      DISPLAY 
          pCodDiv @ FacCPedi.Libre_c01 
          STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ FacCPedi.NroPed
          TODAY                          @ FacCPedi.FchPed
          S-TPOCMB                       @ FacCPedi.TpoCmb
          (TODAY + s-DiasVtoCot)         @ FacCPedi.FchVen 
          (TODAY + s-MinimoDiasDespacho) @ FacCPedi.FchEnt
          s-CodCli @ Faccpedi.codcli
          s-CodVen @ Faccpedi.codven.

/*       RUN Borra-Temporal. */

      /* RHC 14/10/2013 ***************************************************************** */
      RUN rutina-add-extra.
      /* ******************************************************************************** */
      APPLY 'ENTRY':U TO FacCPedi.CodCli.
  END.
  x-order-type = "".
  x-cod-origen =  "".
  x-nro-origen = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  /* ********************************************************* */
  /* Dispatch standard ADM method.                             */
  /* ********************************************************* */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  /* ********************************************************* */

  /* Code placed here will execute AFTER standard behavior.    */
  DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  CASE RETURN-VALUE:
      WHEN "YES" THEN DO:   /* CREAR */
          /* GRABA DATOS CABECERA */
          RUN CREATE-TRANSACION.
          IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
              IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar la cotización'.
              UNDO, RETURN 'ADM-ERROR'.
          END.
      END.
      WHEN "NO" THEN DO:    /* MODIFICAR */
          /* ELIMINA DATOS PRE-GRABADOS */
          RUN UPDATE-TRANSACION.
          IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
              IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo actualiza la cotización'.
              UNDO, RETURN 'ADM-ERROR'.
          END.
      END.
  END CASE.
  /* ************************************************************************ */
  /* RUTINAS GENERALES TANTO AL CREAR COMO MODIFICAR */
  /* ************************************************************************ */
  /* Control si el Cliente Recoge */
  IF FacCPedi.Cliente_Recoge = NO THEN FacCPedi.CodAlm = ''.
  /* ************************************************************************ */
  /* *************************** POR APROBAR ******************************** */
  /* ************************************************************************ */
  /* ************************************************************************ */
  /* RHC 13/10/2020 Llican PreVenta: Primer estado de la cotización           */
  /* ************************************************************************ */
  ASSIGN
      Faccpedi.FlgEst = 'PV'.     /* Por Aprobar */
  /* ************************************************************************ */
  /* ************************************************************************ */
  ASSIGN 
      FacCPedi.LugEnt = FILL-IN-sede:SCREEN-VALUE IN FRAME {&FRAME-NAME}
      FacCPedi.PorIgv = s-PorIgv
      FacCPedi.Observa = F-Observa
      FacCPedi.Libre_c01 = pCodDiv
      Faccpedi.OrderType = x-order-type
      faccpedi.codorigen = x-cod-origen
      faccpedi.nroorigen = x-nro-origen
      FacCPedi.Atencion = Atencion:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  /* ************************************************************************ */
  /* Ic - 03Oct2019, bolsas plasticas, adicionar el registro de IMPUESTO (ICBPER) */
  /* ************************************************************************ */
  &IF {&ARITMETICA-SUNAT} = NO &THEN
      RUN impuesto-icbper. 
  &ENDIF
  /* ******************************************** */
  /* RHC 19/050/2021 Datos para HOMOLOGAR las COT */
  /* ******************************************** */
  ASSIGN
      FacCPedi.CustomerPurchaseOrder = Faccpedi.OrdCmp.
  /* ************************************************************************ */
  /* GRABACION DEL DETALLE DE LA COTIZACION */
  /* ************************************************************************ */
  RUN WRITE-DETAIL.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  /* ************************************************************************ */
  /* 02/08/2022: Log de descuentos básicos */
  /* ************************************************************************ */
  FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.Libre_c04 > '':
      CREATE logdsctosped.
      BUFFER-COPY Facdpedi TO logdsctosped
          ASSIGN
          logdsctosped.CodPed = Facdpedi.coddoc
          logdsctosped.NroPed = Facdpedi.nroped
          logdsctosped.CodCli = Faccpedi.CodCli
          logdsctosped.CodMon = Faccpedi.CodMon
          logdsctosped.Fecha = TODAY
          logdsctosped.Hora = STRING(TIME,'HH:MM:SS')
          logdsctosped.TipDto = Facdpedi.Libre_c04
          logdsctosped.PorDto = Facdpedi.Por_Dsctos[3]
          logdsctosped.Usuario = s-user-id.
  END.
  IF AVAILABLE(LogDsctosPed) THEN RELEASE LogDsctosPed.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_Handle ('Pagina1').
  RUN Procesa-Handle IN lh_Handle ('Browse').
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF NOT AVAILABLE Faccpedi THEN RETURN 'ADM-ERROR'.

  CASE TRUE:
      WHEN s-TpoPed = "LF" THEN DO:
          MESSAGE 'Acceso Denegado LFFFFF ' VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
      WHEN s-TpoPed = "S" THEN DO:
          MESSAGE 'Copia NO permitida' VIEW-AS ALERT-BOX ERROR.
          RETURN "ADM-ERROR".
      END.
  END CASE.

  /* PrePedido ListaExpress 2022 - Ic */
  IF s-TpoPed = "PPLE" THEN DO:
      /* Cualquier validacion ponerlo aca */
  END.
  
  /* ********************************************************* */
  /* RHC 17/04/19 Consistencia de vigencia de lista de precios */
  /* ********************************************************* */
  FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-div.coddiv = pCodDiv NO-LOCK.
  IF GN-DIVI.Campo-Date[1] <> ? AND GN-DIVI.Campo-Date[2] <> ? THEN DO:
      IF NOT (TODAY >= GN-DIVI.Campo-Date[1] AND TODAY <= GN-DIVI.Campo-Date[2]) THEN DO:
          MESSAGE 'Lista de Precios' pCodDiv 'no está vigente' SKIP
              'Comuníquese con el área Comercial' SKIP(1)
              'Proceso Abortado'
              VIEW-AS ALERT-BOX INFORMATION.
          RETURN 'ADM-ERROR'.
      END.
  END.
  /* 22/01/2022 Solo para EVENTOS*/
  IF s-TpoPed = "E" THEN DO:
      IF GN-DIVI.Campo-Date[1] = ? OR GN-DIVI.Campo-Date[2] = ? THEN DO:
          MESSAGE 'Debe estar configurada correctamente la vigencia de la lista de precios' SKIP
              'Comuníquese con el área Comercial' SKIP(1)
              'Proceso Abortado'
              VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.
  END.
  /* ********************************************************* */
  DEF VAR pParametro AS CHAR NO-UNDO.

  IF NOT AVAILABLE FaccPedi THEN RETURN "ADM-ERROR".

  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDoc = S-CODDOC 
      AND FacCorre.NroSer = s-NroSer
      NO-LOCK NO-ERROR.
  IF FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  /* ********************************************************* */
  /* CONTROL DE COPIA */
  /* ********************************************************* */
  IF NOT s-TpoPed = "I" AND                     /* NO Institucionales */
      LOOKUP(Faccpedi.FlgEst, "E,P") > 0 AND    /* Solo */
      NOT CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE Facdpedi.canate > 0 NO-LOCK)    /* SIN atenciones */
      THEN DO:
      MESSAGE 'Desea dar de baja a la Cotización' Faccpedi.nroped '(S/N)?' SKIP(2)
          "NOTA: si no tiene atenciones parciales entonces se ANULA la cotización"
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
          UPDATE rpta AS LOG.
      IF rpta = ? THEN RETURN 'ADM-ERROR'.
      IF rpta = NO THEN DO:
          /* Seguridad */
          RUN vta2/gConfirmaCopia ("CONFIRMAR NO BAJA DE COTIZACION", OUTPUT pParametro).
          IF pParametro = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
      END.
      ELSE DO:
          FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE Faccpedi THEN RETURN 'ADM-ERROR'.
          ASSIGN
              Faccpedi.flgest = "X".    /* CERRADO MANUALMENTE */
          /* RHC 15/10/2013 Si NO tienen atenciones entonces la anulamos */
          IF NOT CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE Facdpedi.canate > 0 NO-LOCK)
              THEN Faccpedi.flgest = "A".       /* ANULADO */
          FIND CURRENT Faccpedi NO-LOCK.
          RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
      END.
  END.

  ASSIGN
      s-Import-B2B = NO
      s-Import-IBC = NO
      s-CodMon = Faccpedi.codmon
      /*s-CodCli = Faccpedi.codcli*/        /* CONTROL POR USUARIO */
      s-CodCli = ""
      s-FmaPgo = ""     /* La condición de venta depende del cliente */
      s-TpoCmb = 1
      s-FlgIgv = YES    /* Venta AFECTA a IGV */
      s-Copia-Registro = YES    /* <<< OJO >>> */
      s-PorIgv = FacCfgGn.PorIgv
      s-NroDec = Faccpedi.Libre_d01
      s-adm-new-record = "YES"
      s-nroped = ""
      pFechaEntrega = Faccpedi.fchent
      S-TPOMARCO = Faccpedi.Libre_c04
      .
  RUN Copia-Items.

  RUN vtagn/p-fmapgo-valido.r (s-codcli, s-tpoped, pCodDiv, OUTPUT s-cndvta-validos).
  s-FmaPgo = ENTRY(1, s-cndvta-validos).

  /* PrePEdidoListaExpress 2022 */
  x-cod-origen =  "".
  x-nro-origen = "".
  x-order-type = "".
  IF faccpedi.coddoc = "PLE" AND faccpedi.OrderType = "PREMIUM" THEN DO:
      x-cod-origen =  faccpedi.coddoc.
      x-nro-origen = faccpedi.nroped.
      x-order-type = "STANDARD".
  END.

  /* ******************************************************************************** */
  /* 22/01/2024: C. Tenazoa */
  /* ******************************************************************************** */
  ASSIGN
      s-CodCli = Faccpedi.CodCli
      s-FmaPgo = Faccpedi.FmaPgo.
  /* ******************************************************************************** */

  /* ********************************************************* */
  /* Dispatch standard ADM method.                             */
  /* ********************************************************* */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .
  /* ********************************************************* */

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FIND TcmbCot WHERE  TcmbCot.Codcia = 0
          AND  (TcmbCot.Rango1 <= TODAY - TODAY + 1
          AND   TcmbCot.Rango2 >= TODAY - TODAY + 1)
          NO-LOCK NO-ERROR.
      IF AVAIL TcmbCot THEN S-TPOCMB = TcmbCot.TpoCmb.  
      DISPLAY 
          "" @ F-Estado
          STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ FacCPedi.NroPed
          TODAY @ FacCPedi.FchPed
          S-TPOCMB @ FacCPedi.TpoCmb
          (TODAY + s-DiasVtoCot)         @ FacCPedi.FchVen 
          (TODAY + s-MinimoDiasDespacho) @ FacCPedi.FchEnt
          s-FmaPgo @ FacCPedi.FmaPgo
          s-CodVen @ Faccpedi.codven
          "" @ Faccpedi.Glosa
      FacCPedi.FlgIgv:SCREEN-VALUE = "YES".
  END.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  /* RHC 14/10/2013 ***************************************************************** */
  RUN rutina-add-extra.
  /* ******************************************************************************** */

  RUN Procesa-Handle IN lh_Handle ('Recalculo').    /* 22/01/2024: C. Tenazoa */
  APPLY 'ENTRY':U TO FacCPedi.CodCli.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

/*
            WHEN 'PV' THEN pEstado = "POR APROBAR".  /* Vendedor */
            WHEN 'PA' THEN pEstado = "POR APROBAR POR ADMINISTRADOR".
            WHEN 'E' THEN pEstado = "POR APROBAR POR SUPERVISOR".
            WHEN 'P' THEN pEstado = "PENDIENTE".
            WHEN 'PP' THEN pEstado = "EN PROCESO".
            WHEN 'V' THEN pEstado = "VENCIDA".
            WHEN 'R' THEN pEstado = "RECHAZADO".
            WHEN 'A' THEN pEstado = "ANULADO".
            WHEN 'C' THEN pEstado = "ATENDIDO TOTAL".
            WHEN 'S' THEN pEstado = "SUSPENDIDA".
            WHEN 'X' THEN pEstado = "CERRADO MANUALMENTE".
            WHEN 'T' THEN pEstado = "EN REVISION".
            WHEN 'ST' THEN pEstado = "SALDO TRANSFERIDO".
*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
/*   RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) . */

  /* Code placed here will execute AFTER standard behavior.    */
  IF NOT AVAILABLE FacCPedi THEN RETURN "ADM-ERROR".
  FIND CURRENT FacCPedi NO-LOCK NO-ERROR.

  IF LOOKUP(FacCPedi.FlgEst,"PV,PA,P,T,V") = 0 THEN DO:
      MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.

  /* BLOQUEAR SI SE HA TRABAJADO CON OTRA LISTA DE PRECIOS */
  IF pCodDiv <> Faccpedi.Libre_c01 THEN DO:
      MESSAGE 'NO puede anular una Cotización generada con otra lista de precios'
          VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  /* ***************************************************** */
  
  /* Si tiene atenciones parciales tambien se bloquea */
  FIND FIRST facdpedi OF faccpedi WHERE CanAte <> 0 NO-LOCK NO-ERROR.
  IF AVAILABLE facdpedi THEN DO:
      MESSAGE "La Cotización tiene atenciones parciales" SKIP "Acceso denegado" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
    
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND CURRENT FacCPedi EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE FacCPedi THEN UNDO, RETURN 'ADM-ERROR'.
      /* RHC 04/01/2016 Pre-Pedido Expolibreria */
      IF Faccpedi.codref = 'PET' 
          AND CAN-FIND(FIRST Vtacdocu WHERE VtaCDocu.CodCia = Faccpedi.codcia 
                       /*AND VtaCDocu.CodDiv = Faccpedi.coddiv*/
                       AND VtaCDocu.CodPed = Faccpedi.codref
                       AND VtaCDocu.NroPed = Faccpedi.nroref
                       NO-LOCK)
          THEN DO:
          FIND Vtacdocu WHERE VtaCDocu.CodCia = Faccpedi.codcia 
              AND VtaCDocu.CodPed = Faccpedi.codref
              AND VtaCDocu.NroPed = Faccpedi.nroref
              EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE Vtacdocu THEN DO:
              MESSAGE 'NO se pudo bloquear el' Faccpedi.codref Faccpedi.nroref
                  VIEW-AS ALERT-BOX ERROR.
              UNDO, RETURN 'ADM-ERROR'.
          END.
          ASSIGN
              Vtacdocu.Libre_c05 = ''
              Vtacdocu.FlgSit = "X".
          RELEASE Vtacdocu.
      END.
      /* ************************************** */
      ASSIGN                 
          FacCPedi.UsrAprobacion = s-user-id
          FacCPedi.FchAprobacion = TODAY
          FacCPedi.FlgEst = 'A'
          FacCPedi.Glosa  = "ANULADO POR: " + TRIM (s-user-id) + " EL DIA: " + STRING(TODAY) + " " + STRING(TIME, 'HH:MM').
      FIND CURRENT FacCPedi NO-LOCK.
      /* Si es Compra Plaza Vea */
      IF FacCPedi.codcli = '20100070970' THEN DO:
          DISABLE TRIGGERS FOR LOAD OF factabla.

          FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                  factabla.tabla = 'OC PLAZA VEA' AND 
                  factabla.codigo = FacCPedi.ordcmp EXCLUSIVE NO-ERROR.
          IF AVAILABLE factabla THEN DO:
              ASSIGN factabla.codigo = TRIM(factabla.codigo) + " - Anulado el " + STRING(NOW,"99/99/9999 HH:MM:SS").
          END.
      END.
      /*  */
      RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* ********************************************************* */
  /* Dispatch standard ADM method.                             */
  /* ********************************************************* */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .
  /* ********************************************************* */

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          BUTTON-Turno-Avanza:SENSITIVE     = NO
          BUTTON-Turno-Retrocede:SENSITIVE  = NO
          BUTTON-Turno-Avanza:VISIBLE       = NO
          BUTTON-Turno-Retrocede:VISIBLE    = NO.
  END.

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

  /* ********************************************************* */
  /* Dispatch standard ADM method.                             */
  /* ********************************************************* */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  /* ********************************************************* */

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
     txtStkLetras:SCREEN-VALUE = "0".
     fill-in-OrderType:SCREEN-VALUE = "".
  END.

  IF AVAILABLE FacCPedi THEN DO WITH FRAME {&FRAME-NAME}:
      RUN vta2/p-faccpedi-flgest.r(Faccpedi.flgest, Faccpedi.coddoc, OUTPUT f-Estado).
      DISPLAY f-Estado.
      F-Nomtar:SCREEN-VALUE = ''.
      FIND FIRST Gn-Card WHERE Gn-Card.NroCard = FacCPedi.NroCar NO-LOCK NO-ERROR.
      IF AVAILABLE Gn-Card THEN F-NomTar:SCREEN-VALUE = GN-CARD.NomClie[1].
      FILL-IN-sede:SCREEN-VALUE = "".
      FIND GN-ClieD WHERE GN-ClieD.CodCia = CL-CODCIA
          AND GN-ClieD.CodCli = FacCPedi.Codcli
          AND GN-ClieD.sede = FacCPedi.sede
          NO-LOCK NO-ERROR.
      IF AVAILABLE GN-ClieD THEN FILL-IN-sede:SCREEN-VALUE = GN-ClieD.dircli.
      F-NomVen:SCREEN-VALUE = "".
      FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
          AND  gn-ven.CodVen = FacCPedi.CodVen 
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
      F-CndVta:SCREEN-VALUE = "".
      FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
      IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.

      /* Stock de Letras */
      FIND FIRST ccbstklet WHERE ccbstklet.codcia = s-codcia AND 
                                    ccbstklet.codclie = FacCPedi.Codcli NO-LOCK NO-ERROR.
      IF AVAILABLE ccbstklet THEN txtStkLetras:SCREEN-VALUE = STRING(ccbstklet.qstklet,"->,>>99").

      FILL-IN-DesAlm:SCREEN-VALUE = ''.
      IF FacCPedi.CodAlm > '' THEN DO:
          FIND Almacen WHERE Almacen.codcia = s-codcia AND
              Almacen.codalm = FacCPedi.CodAlm NO-LOCK NO-ERROR.
          IF AVAILABLE Almacen THEN FILL-IN-DesAlm:SCREEN-VALUE = Almacen.Descripcion.
      END.

      FILL-IN-CodPos:SCREEN-VALUE = ''.
      FIND Almtabla WHERE almtabla.Tabla = "CP"
          AND almtabla.Codigo = FacCPedi.CodPos
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almtabla THEN FILL-IN-CodPos:SCREEN-VALUE = almtabla.Nombre.

      /* RHC 16/10/2020 Botones */
      CASE Faccpedi.FlgEst:
          WHEN "PV" THEN RUN Procesa-Botones IN lh_handle ("Enviar-al-Administrador-On").
          OTHERWISE RUN Procesa-Botones IN lh_handle ("Enviar-al-Administrador-Off").
      END CASE.
      /* 14/12/2023: Solo Riqra */
      IF TRIM(Faccpedi.CodOrigen) = "RIQRA" THEN RUN Procesa-Botones IN lh_handle ("Aritmetica-Sunat-On").
      ELSE RUN Procesa-Botones IN lh_handle ("Aritmetica-Sunat-Off").

      fill-in-OrderType:SCREEN-VALUE = faccpedi.OrderType.
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

  /* ********************************************************* */                                                                 
  /* Dispatch standard ADM method.                             */
  /* ********************************************************* */                                                                 
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
  /* ********************************************************* */                                                                 

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          FacCPedi.DirCli:SENSITIVE = NO
          FacCPedi.NomCli:SENSITIVE = NO
          FacCPedi.RucCli:SENSITIVE = NO
          FacCPedi.FaxCli:SENSITIVE = NO
          FacCPedi.TpoCmb:SENSITIVE = NO
          FacCPedi.Libre_c04:SENSITIVE = NO
          FacCPedi.CodRef:SENSITIVE = NO
          FacCPedi.NroRef:SENSITIVE = NO
          FacCPedi.Libre_c01:SENSITIVE = NO
          FacCPedi.Cliente_Recoge:SENSITIVE = NO
          FacCPedi.CodAlm:SENSITIVE = NO
          FacCPedi.CodPos:SENSITIVE = NO
          .
      CASE s-TpoPed:
          WHEN "E" THEN DO:     /* EVENTOS */
              ASSIGN 
                  /*FacCPedi.CodMon:SENSITIVE = NO*/
                  FacCPedi.FlgIgv:SENSITIVE = NO
                  FacCPedi.Libre_d01:SENSITIVE = NO.  /* NO cambia los decimales del redondeo */
          END.
      END CASE.

      /* 16Jun2021 - Mientras decide el KeyUsr */
      ASSIGN FacCPedi.FlgIgv:SENSITIVE = NO.
      
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'NO' THEN DO:

          FacCPedi.CodCli:SENSITIVE = NO.
          /* Ic - 03Feb2021, autorizado por Daniel Llican a pedido de HIROSHI, ventas Whatsapp */
          FIND FIRST x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                                        x-vtatabla.tabla = 'CONFIG-VTAS' AND
                                        x-vtatabla.llave_c1 = 'DIV.EDITAR-CLIENTE' AND
                                        x-vtatabla.llave_c2 = s-coddiv NO-LOCK NO-ERROR.
          IF AVAILABLE x-vtatabla AND x-vtatabla.llave_c3 = 'SI' THEN DO:
                FacCPedi.CodCli:SENSITIVE = YES.                    
          END.

          IF LOOKUP(s-TpoPed, "R,M,E") = 0 THEN DO:
              FIND TabGener WHERE TabGener.CodCia = s-codcia
                  AND TabGener.Clave = "%MARCO"
                  AND TabGener.Codigo = FacCPedi.CodCli
                  NO-LOCK NO-ERROR.
              IF AVAILABLE TabGener THEN Faccpedi.Libre_C04:SENSITIVE = YES.
          END.
          IF s-TpoPed = "LF" THEN DO:   /* Lista Express */
              ASSIGN
                  FacCPedi.Cmpbnte:SENSITIVE = NO
                  FacCPedi.CodMon:SENSITIVE = NO
                  FacCPedi.FlgIgv:SENSITIVE = NO
                  FacCPedi.Libre_d01:SENSITIVE = NO
                  FacCPedi.FmaPgo:SENSITIVE = NO.
          END.
          /* Control de Programacion de Abastecimientos */
          IF s-nivel-acceso = 0 THEN FacCPedi.FchEnt:SENSITIVE = NO.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF FacCPedi.FlgEst = "A" THEN RETURN.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  F-Observa = FacCPedi.Observa.
  RUN vtamay/d-cotiza (INPUT-OUTPUT F-Observa,
                        F-CndVta:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                        YES,
                        (DATE(FacCPedi.FchVen:SCREEN-VALUE IN FRAME {&FRAME-NAME}) - DATE(FacCPedi.FchPed:SCREEN-VALUE IN FRAME {&FRAME-NAME})) + 1
                        ).
  IF F-Observa = '***' THEN RETURN "ADM-ERROR".
  /* Bloqueamos y grabamos */
  FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
  IF ERROR-STATUS:ERROR = YES THEN DO:
      {lib/mensaje-de-error.i &MensajeError="pMensaje"}
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      RETURN.
  END.
  ASSIGN
      FacCPedi.Observa = F-Observa.
  FIND CURRENT Faccpedi NO-LOCK NO-ERROR.


  CASE s-TpoPed:
      WHEN "E" THEN DO:     /* Evento */
          ASSIGN
              s-codalm = Faccpedi.codalm
              s-fmapgo = Faccpedi.fmapgo
              s-codmon = Faccpedi.codmon
              s-codcli = Faccpedi.codcli
              s-nrodec = Faccpedi.libre_d01
              s-PorIgv = Faccpedi.porigv.
          &IF {&ARITMETICA-SUNAT} &THEN
          RUN vtaexp/impresion-cot-laser-sunat (ROWID(FacCPedi)).
          &ELSE
          RUN vtaexp/impresion-cot-laser (ROWID(FacCPedi)).
          &ENDIF
      END.
      OTHERWISE DO:
          MESSAGE '¿Para Imprimir el documento marque'  SKIP
              '   1. Si = Incluye IGV.      ' SKIP
              '   2. No = No incluye IGV.      '
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
              UPDATE lchoice AS LOGICAL.
          IF lchoice = ? THEN RETURN.
          &IF {&ARITMETICA-SUNAT} &THEN
          RUN VTA\R-ImpCot-sunat (ROWID(FacCPedi),lchoice).
          &ELSE
          RUN VTA\R-ImpCot-1 (ROWID(FacCPedi),lchoice).
          &ENDIF
      END.
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
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
      faccpedi.e-mail:HANDLE:VISIBLE = NO.
      IF s-coddoc = 'PLE' THEN DO:
          faccpedi.e-mail:HANDLE:VISIBLE = YES.
          faccpedi.ordcmp:HANDLE:LABEL = "Identificador".
      END.
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
  F-Observa = FacCPedi.Observa.
   
  /* ********************************************************* */
  /* Dispatch standard ADM method.                             */
  /* ********************************************************* */
  DEF VAR LocalAdmNewRecord AS CHAR NO-UNDO.

  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  LocalAdmNewRecord = RETURN-VALUE.

  pMensaje = ''.
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      RUN Procesa-handle IN lh_handle ('browse').
      RETURN 'ADM-ERROR'.
  END.
  /* ********************************************************* */
  /* GRABACIONES DATOS ADICIONALES A LA COTIZACION */
  /* ********************************************************* */
  RUN WRITE-HEADER (LocalAdmNewRecord).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF pMensaje > '' THEN MESSAGE pMensaje SKIP(2) 'REPITA EL PROCESO DE GRABACION'
          VIEW-AS ALERT-BOX ERROR.
      RUN Procesa-handle IN lh_handle ('browse').
      RETURN 'ADM-ERROR'.
  END.
  FIND CURRENT FacCPedi NO-LOCK NO-ERROR.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Procesa-Handle IN lh_Handle ('browse'). 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Precios V-table-Win 
PROCEDURE Recalcular-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ************************************************************************ */
/* RHC 06/11/2017 NO recalcular precios para CANAL MODERNO NI LISTA EXPRESS */
/* ************************************************************************ */
IF s-TpoPed = "LF" THEN RETURN.     /* LISTA EXPRESS */
IF s-TpoPed = "S" AND s-Import-B2B = YES THEN RETURN.   /* SUPERMERCADOS */
IF s-TpoPed = "S" AND s-Import-IBC = YES THEN RETURN.   /* SUPERMERCADOS */
/* ******************************************************* */
/* ******************************************************* */

/* ARTIFICIO */
Fi-Mensaje = "RECALCULANDO PRECIOS".
DISPLAY Fi-Mensaje WITH FRAME F-Proceso.

IF S-TPOMARCO = "SI" THEN RUN Recalcular-Precio-TpoPed-M.
ELSE RUN Recalcular-Precio-TpoPed.

RUN Procesa-Handle IN lh_handle ('Browse').

HIDE FRAME F-Proceso.

END PROCEDURE.

PROCEDURE Recalcular-Precio-TpoPed:
/* ***************************** */

    {web/recalcular-cotizacion-unificada-web.i &pMuestraError=YES}

END PROCEDURE.


PROCEDURE Recalcular-Precio-TpoPed-M:
/* ***************************** */

    DEF VAR pTpoPed AS CHAR NO-UNDO.

    pTpoPed = s-TpoPed.
    s-TpoPed = "M".

    {web/recalcular-cotizacion-unificada-web.i &pMuestraError=YES }

    s-TpoPed = pTpoPed.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rutina-add-extra V-table-Win 
PROCEDURE rutina-add-extra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    /* RHC 14/10/2013 ***************************************************************** */
    CASE TRUE:
        WHEN s-TpoPed = "E" THEN DO:  /* EVENTOS */
            ASSIGN
                BUTTON-Turno-Avanza:SENSITIVE     = YES
                BUTTON-Turno-Retrocede:SENSITIVE  = YES
                BUTTON-Turno-Avanza:VISIBLE       = YES
                BUTTON-Turno-Retrocede:VISIBLE    = YES.
            /* cliente que espera turno */        
            FIND FIRST ExpTurno WHERE expturno.codcia = s-codcia
                AND expturno.coddiv = s-coddiv
                AND ExpTurno.Block = s-codter
                AND expturno.fecha = TODAY
                AND ExpTurno.Estado = 'P'
                NO-LOCK NO-ERROR.
            IF AVAILABLE ExpTurno THEN DO:
                FILL-IN-1:SCREEN-VALUE = TRIM(ExpTurno.Tipo) + '-' +
                    TRIM(STRING(ExpTurno.Turno)).
                FIND GN-CLIE WHERE gn-clie.codcia = cl-codcia
                    AND gn-clie.codcli = expturno.codcli NO-LOCK NO-ERROR.
                IF AVAILABLE GN-CLIE
                    THEN DISPLAY 
                    gn-clie.codcli @ FacCPedi.CodCli            
                    gn-clie.nomcli @ FacCPedi.NomCli
                    gn-clie.dircli @ FacCPedi.DirCli 
                    gn-clie.nrocard @ FacCPedi.NroCard 
                    gn-clie.ruc    @ FacCPedi.RucCli.
            END.
        END.
    END CASE.
    /* ******************************************************************************** */
END.

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
  {src/adm/template/snd-list.i "FacCPedi"}

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
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Transferencia-de-Saldos V-table-Win 
PROCEDURE Transferencia-de-Saldos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pRowidS AS ROWID.

IF NOT AVAILABLE Faccpedi THEN RETURN.

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN vtagn/ventas-library PERSISTENT SET hProc.

&IF {&ARITMETICA-SUNAT} &THEN
RUN COT_Transferir-Saldo-Sunat IN hProc (INPUT ROWID(Faccpedi),
                                         INPUT pCodDiv,
                                         OUTPUT pRowidS).
&ELSE
RUN COT_Transferir-Saldo IN hProc (INPUT ROWID(Faccpedi),
                                   INPUT pCodDiv,
                                   OUTPUT pRowidS).
&ENDIF

DELETE PROCEDURE hProc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-add-record V-table-Win 
PROCEDURE ue-add-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Code placed here will execute PRIOR to standard behavior. */
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDoc = S-CODDOC 
      AND FacCorre.NroSer = s-NroSer
      NO-LOCK NO-ERROR.
  IF FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK.
  ASSIGN
      s-Copia-Registro = NO
      s-PorIgv = FacCfgGn.PorIgv
      s-Import-IBC      = NO
      s-Import-B2B      = NO
      s-adm-new-record = "YES"
      s-nroped = ""
      lOrdenGrabada = "".

  ASSIGN
      s-CodMon = 1
      s-CodCli = ''
      s-FmaPgo = ''
      s-TpoCmb = 1
      s-NroDec = 4
      s-FlgIgv = YES    /* Venta AFECTA a IGV */.

  FIND TcmbCot WHERE  TcmbCot.Codcia = 0
      AND (TcmbCot.Rango1 <= TODAY - TODAY + 1
      AND TcmbCot.Rango2 >= TODAY - TODAY + 1)
      NO-LOCK NO-ERROR.
  IF AVAIL TcmbCot THEN S-TPOCMB = TcmbCot.TpoCmb.  
  /* RHC 11.08.2014 TC Caja Compra */
  FOR EACH gn-tccja NO-LOCK BY Fecha:
      IF TODAY >= Fecha THEN s-TpoCmb = Gn-TCCja.Compra.
  END.

  /* Adiciono el NUEVO REGISTRO */
  CREATE FacCPedi.
  ASSIGN 
      FacCPedi.CodMon = s-CodMon
      FacCPedi.Cmpbnte = "FAC"
      FacCPedi.Libre_d01  = s-NroDec
      FacCPedi.FlgIgv = YES
      FacCPedi.NroPed = STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999')
      FacCPedi.FchPed = TODAY
      FacCPedi.TpoCmb = s-tpocmb
      FacCPedi.FchVen = TODAY + s-DiasVtoCot
      FacCPedi.FchEnt = OrdenCompra-tienda.fecha-entrega
      Faccpedi.codven = s-CodVen
      Faccpedi.ImpDto2 = 0 
      NO-ERROR.
  IF ERROR-STATUS:ERROR = YES THEN DO:
      {lib/mensaje-de-error.i &MensajeError="pMensaje"}
      UNDO, RETURN 'ADM-ERROR'.
  END.
  IF OrdenCompra-tienda.fecha-entrega = ? THEN DO:
      ASSIGN FacCPedi.FchVen = TODAY + s-MinimoDiasDespacho.
  END.

  RUN Borra-Temporal.

  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-assign-statement V-table-Win 
PROCEDURE ue-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

  DEFINE VAR lCodCli AS CHAR.

  {vta2/icorrelativosecuencial.i &Codigo = s-coddoc &Serie = s-nroser}

  ASSIGN 
      FacCPedi.CodCia = S-CODCIA
      FacCPedi.CodDiv = S-CODDIV
      FacCPedi.CodDoc = s-coddoc 
      FacCPedi.CodAlm = s-CodAlm    /* Lista de Almacenes Válidos de Venta */
      FacCPedi.FchPed = TODAY 
      FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
      FacCPedi.TpoPed = s-TpoPed
      FacCPedi.FlgEst = "P".    /* APROBADO */
  IF s-TpoPed = "LF" THEN FacCPedi.FlgEst = "E".    /* Por Aprobar */

  lCodCli = FacCPedi.CodCli.
  IF cCOTDesde = "" THEN cCOTDesde = FacCPedi.NroPed.
  cCOTHasta = FacCPedi.NroPed.

  ASSIGN
      FacCorre.Correlativo = FacCorre.Correlativo + 1.

  ASSIGN 
      FacCPedi.PorIgv = s-PorIgv
      FacCPedi.Hora = STRING(TIME,"HH:MM")
      FacCPedi.Usuario = S-USER-ID
      FacCPedi.Observa = F-Observa
      FacCPedi.Libre_c01 = pCodDiv.

  FOR EACH ITEM WHERE ITEM.ImpLin > 0,
      FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = ITEM.codmat
      BY ITEM.NroItm:
      I-NITEM = I-NITEM + 1.
      CREATE FacDPedi.
      BUFFER-COPY ITEM 
          TO FacDPedi
          ASSIGN
              FacDPedi.CodCia = FacCPedi.CodCia
              FacDPedi.CodDiv = FacCPedi.CodDiv
              FacDPedi.coddoc = FacCPedi.coddoc
              FacDPedi.NroPed = FacCPedi.NroPed
              FacDPedi.FchPed = FacCPedi.FchPed
              FacDPedi.Hora   = FacCPedi.Hora 
              FacDPedi.FlgEst = FacCPedi.FlgEst
              FacDPedi.NroItm = I-NITEM.
  END.

  /* Guardar la ORDEN DE COMPRA DE PLAZA VEA  */
  DISABLE TRIGGERS FOR LOAD OF factabla.

  FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
          factabla.tabla = 'OC PLAZA VEA' AND 
          factabla.codigo = lOrdenGrabada EXCLUSIVE NO-ERROR.
  IF NOT AVAILABLE factabla THEN DO:
      CREATE factabla.
        ASSIGN factabla.codcia = s-codcia
                factabla.tabla = 'OC PLAZA VEA'
                factabla.codigo = lOrdenGrabada
                factabla.campo-c[2] = STRING(NOW,"99/99/9999 HH:MM:SS").
  END.
  /* CONTROL PARA EL LPN */
  FIND FIRST SupControlOC WHERE SupControlOC.codcia = s-codcia AND 
                                SupControlOC.CodDiv = s-CodDiv AND
                                SupControlOC.CodCli = lCodCli  AND 
                                SupControlOC.OrdCmp = lOrdenGrabada NO-ERROR.
  IF NOT AVAILABLE SupControlOC THEN DO:
      CREATE SupControlOC.
        ASSIGN SupControlOC.Codcia = s-codcia
                SupControlOC.CodCli = lCodCli 
                SupControlOC.Ordcmp = lOrdenGrabada
                SupControlOC.FchPed = TODAY
                SupControlOC.coddiv = S-CODDIV
                SupControlOC.usuario = S-USER-ID
                SupControlOC.correlativo = 0
                SupControlOC.hora = string(TIME,"HH:MM:SS").
  END.

  /* Ic 10Feb2016 - Metodo de Pago Lista Express */
  IF s-TpoPed = "LF" THEN DO:
      DISABLE TRIGGERS FOR LOAD OF vtatabla.
      DEFINE BUFFER i-vtatabla FOR vtatabla.

      DEFINE VAR lxDescuentos AS DEC.    
      DEFINE VAR lxdsctosinigv AS DEC.

      lxDescuentos = 0.
      FOR EACH tt-MetodPagoListaExpress :        
          CREATE i-vtatabla.
              ASSIGN i-vtatabla.codcia = s-codcia
                      i-vtatabla.tabla = 'MTPGLSTEXPRS'
                      i-vtatabla.llave_c1 = FacCPedi.NroPed
                      i-vtatabla.llave_c2 = tt-MetodPagoListaExpress.tt-pedidoweb
                      i-vtatabla.llave_c3 = tt-MetodPagoListaExpress.tt-metodopago
                      i-vtatabla.llave_c5 = tt-MetodPagoListaExpress.tt-tipopago                        
                      i-vtatabla.llave_c4 = tt-MetodPagoListaExpress.tt-nombreclie
                      i-vtatabla.valor[1] = tt-MetodPagoListaExpress.tt-preciopagado
                      i-vtatabla.valor[2] = tt-MetodPagoListaExpress.tt-preciounitario
                      i-vtatabla.valor[3] = tt-MetodPagoListaExpress.tt-costoenvio
                      i-vtatabla.valor[4] = tt-MetodPagoListaExpress.tt-descuento.

                      lxDescuentos = lxDescuentos + i-vtatabla.valor[4].
      END.

      lxdsctosinigv = 0.
      IF lxDescuentos > 0  THEN DO:
            lxdsctosinigv = (lxDescuentos * 100) / 118.
      END.
      ASSIGN faccpedi.impdto2 = lxDescuentos
            faccpedi.importe[3] = lxdsctosinigv.

      RELEASE i-vtatabla.
      EMPTY TEMP-TABLE tt-MetodPagoListaExpress.
      /* *************************************************** */
      /* Creamos una copia del pedido completo sin modificar */
      /* *************************************************** */
      CREATE B-CPEDI.
      BUFFER-COPY Faccpedi
          TO B-CPEDI
          ASSIGN B-CPEDI.CodDoc = "CLE".    /* Cotizacion Lista Express */
      I-NITEM = 0.
      FOR EACH ITEM-LE BY ITEM-LE.NroItm:
          I-NITEM = I-NITEM + 1.
          CREATE FacDPedi.
          BUFFER-COPY ITEM-LE
              TO FacDPedi
              ASSIGN
                  FacDPedi.CodCia = B-CPEDI.CodCia
                  FacDPedi.CodDiv = B-CPEDI.CodDiv
                  FacDPedi.coddoc = B-CPEDI.coddoc
                  FacDPedi.NroPed = B-CPEDI.NroPed
                  FacDPedi.FchPed = B-CPEDI.FchPed
                  FacDPedi.Hora   = B-CPEDI.Hora 
                  FacDPedi.FlgEst = B-CPEDI.FlgEst
                  FacDPedi.NroItm = I-NITEM.
      END.
  END.
  /* ****************************************************************************************** */
  &IF {&ARITMETICA-SUNAT} &THEN
      {vtagn/totales-cotizacion-sunat.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
      /* ****************************************************************************************** */
      /* Importes SUNAT */
      /* ****************************************************************************************** */
      DEF VAR hProc AS HANDLE NO-UNDO.
      RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
      RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                                   INPUT Faccpedi.CodDoc,
                                   INPUT Faccpedi.NroPed,
                                   OUTPUT pMensaje).
      IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
      DELETE PROCEDURE hProc.
  &ELSE
      {vtagn/totales-cotizacion-unificada.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
      /* ****************************************************************************************** */
      /* Importes SUNAT */
      /* No actualiza campos Progress */
      /* ****************************************************************************************** */
      DEF VAR hProc AS HANDLE NO-UNDO.
      RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
      RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                                   INPUT Faccpedi.CodDoc,
                                   INPUT Faccpedi.NroPed,
                                   OUTPUT pMensaje).
      IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
      DELETE PROCEDURE hProc.
  &ENDIF
  /* ****************************************************************************************** */

  /* **************** RHC 24.07.2014 MARGEN MINIMO POR DIVISION ****************** */
      /* 14/12/2022: Se control apor Pricing */
/*   DEF VAR pError AS CHAR.                                                                         */
/*                                                                                                   */
/*   RUN vtagn/p-margen-utilidad-por-cotizacion ( ROWID(Faccpedi) , YES, OUTPUT pError ).            */
/*                                                                                                   */
/*   IF pError = "ADM-ERROR" THEN ASSIGN Faccpedi.FlgEst = "T".                                      */
/*   IF Faccpedi.FlgEst = "T" AND pError = "OK" THEN ASSIGN Faccpedi.FlgEst = "P".    /* APROBADO */ */

  IF AVAILABLE(Faccorre) THEN RELEASE FacCorre.
  IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE UPDATE-TRANSACION V-table-Win 
PROCEDURE UPDATE-TRANSACION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

PRINCIPAL:                                                                                  
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    ASSIGN                                                  
        FacCPedi.UsrAct = S-USER-ID
        Faccpedi.fecact = TODAY
        FacCPedi.HorAct = STRING(TIME,"HH:MM:SS").
    /* Eliminamos (temporalmente) items de la cotización */
    RUN Delete-Items-Cot.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    /* Eliminamos Bonificaciones */
    RUN Delete-Items-Cbo.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    /* Eliminamos Log de Descuentos */
    RUN Delete-Items-Log.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
END.

RETURN 'OK'.

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

DEFINE VARIABLE F-TOT AS DECIMAL INIT 0 NO-UNDO.
DEFINE VARIABLE F-BOL AS DECIMAL INIT 0 NO-UNDO.

DEFINE VAR ls-DiasVtoCot AS INT.
DEFINE VAR lFechaControl AS DATE.
DEFINE VAR lDias AS INT.
DEFINE VAR lCotProcesada AS LOG.

DEFINE VAR lUsrFchEnt AS CHAR.
DEFINE VAR lValFecEntrega AS CHAR.

DEFINE VAR lListaPrecio AS CHAR.
  
DO WITH FRAME {&FRAME-NAME} :
      /* VALIDACION DEL CLIENTE */
      IF TRUE <> (FacCPedi.CodCli:SCREEN-VALUE > "") THEN DO:
         MESSAGE "Codigo de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO FacCPedi.CodCli.
         RETURN "ADM-ERROR".   
      END.
      IF s-ClientesVIP = YES THEN DO:
          RUN vtagn/p-clie-expo (Faccpedi.CodCli:SCREEN-VALUE , s-tpoped, pCodDiv).
          IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
      END.
      /* **************************************** */
      /* RHC 22/07/2020 Nuevo bloqueo de clientes */
      /* **************************************** */
      RUN pri/p-verifica-cliente.r (INPUT Faccpedi.CodCli:SCREEN-VALUE,
                                  INPUT s-CodDoc,
                                  INPUT s-CodDiv).
      IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
      /* **************************************** */

      FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
          AND gn-clie.codcli = Faccpedi.codcli:SCREEN-VALUE
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-clie THEN DO:
          MESSAGE 'Cliente No registrado' VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO FacCPedi.Glosa.
          RETURN 'ADM-ERROR'.
      END.
      /* CONTRATO MARCO -> CHEQUEO DE CANAL */
      /* 13/05/2022: Verificar configuración del cliente */
      IF s-TpoPed = "M" THEN DO:
          FIND VtaTabla WHERE VtaTabla.CodCia = s-CodCia
              AND VtaTabla.Tabla = 'CN-GN'
              AND VtaTabla.Llave_c1 =  Gn-Clie.Canal
              AND VtaTabla.Llave_c2 =  Gn-Clie.GirCli
              NO-LOCK NO-ERROR.
          IF AVAILABLE VtaTabla AND VtaTabla.Libre_c01 <> "SI" THEN DO:
              MESSAGE 'Cliente no permitido en este canal de venta de venta'
                  VIEW-AS ALERT-BOX ERROR.
              APPLY "ENTRY" TO FacCPedi.CodCli.
              RETURN "ADM-ERROR".   
          END.
      END.
/*       IF s-TpoPed = "M" AND gn-clie.canal <> '006' THEN DO:              */
/*           MESSAGE 'Cliente no permitido en este canal de venta de venta' */
/*              VIEW-AS ALERT-BOX ERROR.                                    */
/*          APPLY "ENTRY" TO FacCPedi.CodCli.                               */
/*          RETURN "ADM-ERROR".                                             */
/*      END.                                                                */
     IF Faccpedi.Cmpbnte:SCREEN-VALUE = "FAC" AND FacCpedi.RucCli:SCREEN-VALUE = '' THEN DO:
        MESSAGE "El Cliente NO tiene R.U.C." VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FacCPedi.CodCli.
        RETURN "ADM-ERROR".   
     END.      
     IF Faccpedi.Cmpbnte:SCREEN-VALUE = "FAC" THEN DO:
         IF LENGTH(FacCPedi.RucCli:SCREEN-VALUE) < 11 THEN DO:
             MESSAGE 'El RUC debe tener 11 dígitos' VIEW-AS ALERT-BOX ERROR.
             APPLY 'ENTRY':U TO FacCPedi.CodCli.
             RETURN 'ADM-ERROR'.
         END.
         IF LOOKUP(SUBSTRING(FacCPedi.RucCli:SCREEN-VALUE,1,2), '20,15,17,10') = 0 THEN DO:
             MESSAGE 'El RUC debe comenzar con 10,15,17 ó 20' VIEW-AS ALERT-BOX ERROR.
             APPLY 'ENTRY':U TO FacCPedi.CodCli.
             RETURN 'ADM-ERROR'.
         END.
         /* dígito verificador */
         DEF VAR pResultado AS CHAR NO-UNDO.
         RUN lib/_ValRuc (FacCPedi.RucCli:SCREEN-VALUE, OUTPUT pResultado).
         IF pResultado = 'ERROR' THEN DO:
             MESSAGE 'Código RUC MAL registrado' VIEW-AS ALERT-BOX WARNING.
             APPLY 'ENTRY':U TO FacCPedi.CodCli.
             RETURN 'ADM-ERROR'.
         END.
     END.
     /* rhc 22.06.09 Control de Precios IBC */
     CASE s-TpoPed:
         WHEN "S" THEN DO:
             IF s-Import-IBC = YES THEN DO:
                 RUN CONTROL-IBC.
                 IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
             END.
         END.
     END CASE.
     /* RHC 23.06.10 Control de sedes por autoservicios
          Los clientes deben estar inscritos en la opcion DESCUENTOS E INCREMENTOS */
     IF TRUE <> (FacCPedi.Sede:SCREEN-VALUE > '') THEN DO:
         MESSAGE 'Debe registrar la sede para este cliente' VIEW-AS ALERT-BOX ERROR.
         APPLY 'ENTRY':U TO FacCPedi.Sede.
         RETURN 'ADM-ERROR'.
     END.
     FIND FIRST Gn-clied OF Gn-clie WHERE Gn-clied.Sede = Faccpedi.Sede:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-clied THEN DO:
          MESSAGE 'Sede no registrada para este cliente' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO FacCPedi.Sede.
          RETURN 'ADM-ERROR'.
      END.
    /* VALIDACION DEL VENDEDOR */
     IF TRUE <> (FacCPedi.CodVen:SCREEN-VALUE > "") THEN DO:
        MESSAGE "Codigo de Vendedor no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FacCPedi.CodVen.
        RETURN "ADM-ERROR".   
     END.
     FIND FIRST gn-ven WHERE gn-ven.CodCia = S-CODCIA 
         AND  gn-ven.CodVen = FacCPedi.CodVen:SCREEN-VALUE 
         NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gn-ven THEN DO:
        MESSAGE "Codigo de Vendedor no existe" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FacCPedi.CodVen.
        RETURN "ADM-ERROR".   
     END.
     ELSE DO:
         IF gn-ven.flgest = "C" THEN DO:
             MESSAGE "Codigo de Vendedor Cesado" VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO FacCPedi.CodVen.
             RETURN "ADM-ERROR".   
         END.
     END.
    /* VALIDACION DE LA CONDICION DE VENTA */    
     IF FacCPedi.FmaPgo:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Condicion Venta no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FacCPedi.FmaPgo.
        RETURN "ADM-ERROR".   
     END.
     FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gn-convt THEN DO:
        MESSAGE "Condicion Venta no existe" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FacCPedi.FmaPgo.
        RETURN "ADM-ERROR".   
     END.
     /* Ic - 28Ene2016, Para la VU (Vales Utilex, condicion de venta debe ser FAI */
     IF s-tpoped = 'VU' THEN DO:
         IF gn-convt.libre_l01 <> YES THEN DO:
             MESSAGE "Condicion Venta debe aceptar FAI" VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO FacCPedi.FmaPgo.
             RETURN "ADM-ERROR".   
         END.
     END.
     /* RHC 09/05/2014 SOLO condiciones de ventas válidas */
     IF gn-convt.Estado <> "A" THEN DO:
         MESSAGE "Condición Venta Inactiva" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO FacCPedi.FmaPgo.
         RETURN "ADM-ERROR".   
     END.
     /* RHC 12/11/2015 Correo de Susana León */
     IF INPUT FacCPedi.CodCli = x-ClientesVarios AND INPUT FacCPedi.FmaPgo <> '000' THEN DO:
        /* 02Feb2021 - Vtas Whatsapp */
        FIND FIRST x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                                x-vtatabla.tabla = "CONFIG-VTAS" AND
                                x-vtatabla.llave_c1 = "DIV.VTA-COND.VTA" AND
                                x-vtatabla.llave_c2 = s-coddiv AND
                                x-vtatabla.llave_c3 = INPUT FacCPedi.FmaPgo NO-LOCK NO-ERROR.   
        IF NOT AVAILABLE x-vtatabla THEN DO:
            MESSAGE 'Solo se permite la Condición de Venta 000' VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FacCPedi.CodCli.
            RETURN "ADM-ERROR".   
        END.
     END.
     /* ********************************************************** */
     /* RHC 13/11/2017 Limitación de la condición de venta Campaña */
     /* ********************************************************** */
     FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = pCodDiv NO-LOCK NO-ERROR.
     IF AVAILABLE gn-divi THEN DO:
         IF gn-ConVt.Libre_l02 = YES AND GN-DIVI.CanalVenta <> "FER" THEN DO:
             MESSAGE 'Condición de venta válida solo para EXPOLIBRERIAS' VIEW-AS ALERT-BOX ERROR.
             APPLY 'ENTRY':U TO FacCPedi.FmaPgo.
             RETURN 'ADM-ERROR'.
         END.
     END.
     /* ********************************************************** */
     /* RHC 21.08.2014 Control de FAI */
     FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.
     IF gn-convt.Libre_L01 = YES AND gn-divi.FlgRep = NO THEN DO:
         MESSAGE 'Condición de venta NO válida para esta división' VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO FacCPedi.FmaPgo.
         RETURN "ADM-ERROR".   
     END.
     /* Ic - 28Ene2016, Para la VU (Vales Utilex, la division debe aceptar FAI */
     IF s-tpoped = 'VU' THEN DO:
         IF gn-divi.FlgRep <> YES THEN DO:
             MESSAGE "La division debe aceptar FAI" VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO FacCPedi.FmaPgo.
             RETURN "ADM-ERROR".   
         END.
     END.
     /* VALIDACION DE LA TARJETA */
     IF Faccpedi.NroCar:SCREEN-VALUE > "" THEN DO:
         FIND Gn-Card WHERE Gn-Card.NroCard = Faccpedi.NroCar:SCREEN-VALUE
             NO-LOCK NO-ERROR.
         IF NOT AVAILABLE Gn-Card THEN DO:
             MESSAGE "Numero de Tarjeta Incorrecto, Verifique... " VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO FacCPedi.NroCar.
             RETURN "ADM-ERROR".   
         END.   
     END.           
     /* VALIDACION DE AFECTO A IGV */
     IF s-flgigv = NO THEN DO:
         MESSAGE 'La cotización NO ESTA AFECTA A IGV' SKIP
             'Es eso correcto?'
             VIEW-AS ALERT-BOX QUESTION
             BUTTONS YES-NO UPDATE rpta AS LOG.
         IF rpta = NO THEN RETURN 'ADM-ERROR'.
     END.
     /* VALIDACION DE ITEMS */
     FOR EACH ITEM NO-LOCK:
         F-Tot = F-Tot + ITEM.ImpLin.
     END.
     IF F-Tot = 0 THEN DO:
        MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FacCPedi.CodCli.
        RETURN "ADM-ERROR".   
     END.
    /* *********************************************************** */
    /* VALIDACION DE MONTO MINIMO POR BOLETA */
    /* Si es es BOL y no llega al monto mínimo blanqueamos el DNI */
    /* *********************************************************** */
    F-BOL = IF INTEGER(FacCPedi.CodMon:SCREEN-VALUE) = 1 
        THEN F-TOT
        ELSE F-Tot * DECIMAL(FacCPedi.TpoCmb:SCREEN-VALUE).
    /*IF Faccpedi.Cmpbnte:SCREEN-VALUE = 'BOL' AND F-BOL <= ImpMinDNI THEN FacCPedi.Atencion:SCREEN-VALUE = ''.*/
    DEF VAR cNroDni AS CHAR NO-UNDO.
    DEF VAR iLargo  AS INT NO-UNDO.
    DEF VAR cError  AS CHAR NO-UNDO.
    cNroDni = FacCPedi.Atencion:SCREEN-VALUE.
    IF Faccpedi.Cmpbnte:SCREEN-VALUE = 'BOL' AND F-BOL > ImpMinDNI THEN DO:
        RUN lib/_valid_number (INPUT-OUTPUT cNroDni, OUTPUT iLargo, OUTPUT cError).
        /* 03/07/2023: Carnet de extranjeria tiene actualment 9 dígitos Gianella Chirinos S.Leon */
        IF cError > '' OR iLargo < 8 THEN DO:
            cError = cError + (IF cError > '' THEN CHR(10) ELSE '') +
                    "El DNI debe tener al menos 8 dígitos".
            MESSAGE cError VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FacCPedi.Atencion.
            RETURN "ADM-ERROR".   
        END.
        IF iLargo <> 8 AND gn-clie.Libre_c01 = "N" THEN DO:
            MESSAGE 'El DNI debete tener 8 dígitos' VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FacCPedi.Atencion.
            RETURN "ADM-ERROR".   
        END.

        IF TRUE <> (FacCPedi.NomCli:SCREEN-VALUE > '') THEN DO:
            MESSAGE "Venta Mayor a" ImpMinDNI SKIP
                "Debe ingresar el Nombre del Cliente"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FacCPedi.NomCli.
            RETURN "ADM-ERROR".   
        END.
        IF TRUE <> (FacCPedi.DirCli:SCREEN-VALUE > '') THEN DO:
            MESSAGE "Venta Mayor a" ImpMinDNI SKIP
                "Debe ingresar la Dirección del Cliente"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FacCPedi.DirCli.
            RETURN "ADM-ERROR".   
        END.
    END.
    /* *********************************************************** */
    /* *********************************************************** */
    /* VALIDACION DE IMPORTE MINIMO POR COTIZACION */
    DEF VAR pImpMin AS DEC NO-UNDO.
    DEFINE VAR x-fecha-emision AS DATE.
    DEFINE VAR x-msg AS CHAR.

    x-fecha-emision = DATE(faccpedi.fchped:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-ERROR.

    RUN gn/p-minimo-vta-x-canal.r (s-CodCia,
                       s-CodDiv,       /* Pto Venta */
                       pCodDiv,        /* Lista de Precio */
                       'COT',          /* Tipo Documento */
                       x-fecha-emision,
                       OUTPUT pImpMin).

    IF f-Tot < pImpMin THEN DO:
        IF pImpMin = 999999999.00 THEN DO:
            x-msg = "Se debe configurar el importe minimo de venta " + CHR(13) + CHR(10) +
                   "para la lista de precios " + pCodDiv + " el tipo de documento COT".                    
        END.
        ELSE DO:
            x-msg = "El importe minimo de venta es de " + STRING(pImpMin,"->>,>>>,>>9.99") + CHR(13) + CHR(10) +
                   "para la lista de precios " + pCodDiv + " el tipo de documento COT".                    
        END.
        MESSAGE x-msg
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    /* OTRAS VALIDACIONES */
     IF FacCPedi.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '11111111112'
         AND LOOKUP(FacCPedi.FmaPgo:SCREEN-VALUE IN FRAME {&FRAME-NAME}, '899,900') > 0
         AND FacCPedi.NroCard:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '' THEN DO:
         MESSAGE "Ingrese el numero de tarjeta" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO FacCPedi.NroCard.
         RETURN "ADM-ERROR".   
     END.
     IF LOOKUP(FacCPedi.FmaPgo:SCREEN-VALUE IN FRAME {&FRAME-NAME}, '899,900') > 0
         AND FacCPedi.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> '11111111112'
         AND FacCPedi.NroCard:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> '' THEN DO:
         MESSAGE "En caso de transferencia gratuita NO es válido el Nº de Tarjeta" 
             VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO FacCPedi.NroCard.
         RETURN "ADM-ERROR".   
     END.
     IF INPUT FacCPedi.FchVen < INPUT FacCPedi.fchped THEN DO:
         MESSAGE 'Ingrese correctamente la fecha de vencimiento' VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO FacCPedi.FchVen.
         RETURN "ADM-ERROR".   
     END.
     IF INPUT FacCPedi.FchEnt < INPUT FacCPedi.fchped THEN DO:
         MESSAGE 'Ingrese correctamente la fecha de entrega' VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO FacCPedi.FchEnt.
         RETURN "ADM-ERROR".   
     END.
     /* Ic 26Oct2015 */
     RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
     IF RETURN-VALUE = 'YES' THEN DO:
         IF INPUT FacCPedi.FchEnt < TODAY THEN DO:
             MESSAGE 'La fecha de entrega debe ser mayor al de HOY' VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO FacCPedi.FchEnt.
             RETURN "ADM-ERROR".   
         END.
     END.
     /* RHC 14/02/2015 VALIDA FOTOCOPIAS */
     FOR EACH ITEM, FIRST Almmmatg OF ITEM NO-LOCK WHERE Almmmatg.codfam = '011':
         IF GN-DIVI.CanalVenta = 'TDA' AND INPUT Faccpedi.codmon = 1
             AND Almmmatg.codfam = '011' AND gn-ConVt.TotDias > 45 THEN DO:
             MESSAGE 'NO se puede vender papel fotocopia a mas de 45 dias en SOLES' SKIP
                 'Cambiar la moneda de venta a DOLARES'
                 VIEW-AS ALERT-BOX ERROR.
             APPLY 'ENTRY':U TO Faccpedi.codmon.
             RETURN "ADM-ERROR". 
         END.
     END.
     /* Ic - 26Oct2015 - Validar para FERIAS contra la Lista de Precios */ 
     ls-DiasVtoCot = s-DiasVtoCot.
     DEFINE BUFFER b-gn-divi FOR gn-divi.     
     IF faccpedi.libre_c01:SCREEN-VALUE <> ? THEN DO:
         FIND FIRST b-gn-divi WHERE b-gn-divi.coddiv = faccpedi.libre_c01:SCREEN-VALUE 
             NO-LOCK NO-ERROR.
         IF AVAILABLE b-gn-divi THEN DO:
             ls-DiasVtoCot = b-GN-DIVI.DiasVtoCot.
         END.    
     END.
    /* RHC 17/02/2015 VALIDACION FECHA VENCIMIENTO */
     IF INPUT FacCPedi.FchVen - INPUT FacCPedi.fchped > ls-DiasVtoCot THEN DO:
         MESSAGE 'La fecha de vencimiento no puede ser mayor a' s-DiasVtoCot 'días' VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO FacCPedi.FchVen.
         RETURN "ADM-ERROR".
     END.
     /* Lista escolares de ListaExpress */
     IF s-coddoc = 'PLE' THEN DO:
         IF TRUE <> (FacCPedi.e-mail:SCREEN-VALUE > "") THEN DO:
            MESSAGE "Correo no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FacCPedi.e-mail.
            RETURN "ADM-ERROR".   
         END.
         IF TRUE <> (FacCPedi.ordcmp:SCREEN-VALUE > "") THEN DO:
            MESSAGE "Identificador no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FacCPedi.ordcmp.
            RETURN "ADM-ERROR".   
         END.
     END.

     /* ******************************************************** */
     /* ******************************************************** */
     /* Ic - 06Nov2015 - Validar fecha de entrega no interfiera con
        la programacion de LUCY MESIA
     */
     DEFINE BUFFER b-factabla FOR factabla.
    /* Ic - Que usuarios no validar fecha de entrega */
     lUsrFchEnt = "".
     lValFecEntrega = ''.
     FIND FIRST b-factabla WHERE b-factabla.codcia = s-codcia AND 
                                b-factabla.tabla = 'VALIDA' AND 
                                b-factabla.codigo = 'FCHENT' NO-LOCK NO-ERROR.
    IF AVAILABLE b-factabla THEN DO:
        lUsrFchEnt      = b-factabla.campo-c[1].  /* Usuarios Exceptuados de la Validacion */
        lValFecEntrega  = b-factabla.campo-c[2].  /* Valida Si o NO */
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

/**/                                           
EMPTY TEMP-TABLE tt-listaexpress-sugeridos.

IF NOT AVAILABLE FacCPedi THEN RETURN "ADM-ERROR".

DEFINE VAR RPTA AS CHAR.
/* ****************************************************************************** */
/* FILTROS DE MODIFICACION 
            WHEN 'PV' THEN pEstado = "POR APROBAR".  /* Vendedor */
            WHEN 'PA' THEN pEstado = "POR APROBAR POR ADMINISTRADOR".
            WHEN 'E' THEN pEstado = "POR APROBAR POR SUPERVISOR".
            WHEN 'P' THEN pEstado = "PENDIENTE".
            WHEN 'PP' THEN pEstado = "EN PROCESO".
            WHEN 'V' THEN pEstado = "VENCIDA".
            WHEN 'R' THEN pEstado = "RECHAZADO".
            WHEN 'A' THEN pEstado = "ANULADO".
            WHEN 'C' THEN pEstado = "ATENDIDO TOTAL".
            WHEN 'S' THEN pEstado = "SUSPENDIDA".
            WHEN 'X' THEN pEstado = "CERRADO MANUALMENTE".
            WHEN 'T' THEN pEstado = "EN REVISION".
            WHEN 'ST' THEN pEstado = "SALDO TRANSFERIDO".
*/
/* ****************************************************************************** */
IF LOOKUP(FacCPedi.FlgEst,"PV,T,I") = 0 THEN DO:
    MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
IF FacCPedi.FchVen < TODAY THEN DO:
    MESSAGE 'Venció el' faccpedi.fchven SKIP 'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
/* BLOQUEAR SI SE HA TRABAJADO CON OTRA LISTA DE PRECIOS */
IF pCodDiv <> Faccpedi.Libre_c01 THEN DO:
    MESSAGE 'NO puede modificar una Cotización generada con otra lista de precios'
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
/* Si tiene atenciones parciales tambien se bloquea */
FIND FIRST facdpedi OF faccpedi WHERE CanAte <> 0 NO-LOCK NO-ERROR.
IF AVAILABLE facdpedi THEN DO:
    MESSAGE "Tiene atenciones parciales" SKIP "Acceso denegado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
s-nivel-acceso = 1.     /* Permitido */
IF Faccpedi.Libre_c02 = "PROCESADO" THEN DO:
    MESSAGE 'Cotización ya ha sido programada por ABASTECIMIENTOS' VIEW-AS ALERT-BOX WARNING.
    s-nivel-acceso = 0.     /* Bloqueado */
END.
/* ****************************************************************************** */
/* RHC 30/04/2020 NO modificar si ya está vencida */
/* ****************************************************************************** */
DEF VAR TimeOut AS INT NO-UNDO.
DEF VAR TimeNow AS INT NO-UNDO.
FIND FIRST FacTabla WHERE FacTabla.codcia = s-codcia AND
    FacTabla.tabla = 'GN-DIVI' AND
    FacTabla.codigo = s-CodDiv AND 
    FacTabla.campo-l[2] = YES AND
    FacTabla.valor[1] > 0 NO-LOCK NO-ERROR.
IF AVAILABLE FacTabla THEN DO:
    TimeOut = (FacTabla.Valor[1] * 3600).       /* En segundos */
    TimeNow = (TODAY - Faccpedi.FchPed) * 24 * 3600.
    TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(faccpedi.Hora, 1, 2)) * 3600) +
              (INTEGER(SUBSTRING(faccpedi.Hora, 4, 2)) * 60) ).
    IF TimeOut > 0 THEN DO:
        IF TimeNow > TimeOut THEN DO: /* Dentro de la valides */
            MESSAGE 'Cotización ' Faccpedi.nroped ' , ya venció su tiempo de espera' SKIP 
                'Por favor comunicarse con el area de ventas' VIEW-AS ALERT-BOX INFORMATION.
            RETURN 'ADM-ERROR'.
        END.
    END.
END.
/* ****************************************************************************** */
/* 22/01/2022 Solo para EVENTOS */
/* ****************************************************************************** */
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-div.coddiv = pCodDiv NO-LOCK NO-ERROR.
IF s-TpoPed = "E" THEN DO:
    IF GN-DIVI.Campo-Date[1] = ? OR GN-DIVI.Campo-Date[2] = ? THEN DO:
        MESSAGE 'Debe estar configurada correctamente la vigencia de la lista de precios' SKIP
            'Comuníquese con el área Comercial' SKIP(1)
            'Proceso Abortado'
            VIEW-AS ALERT-BOX WARNING.
        RETURN 'ADM-ERROR'.
    END.
    IF NOT (TODAY >= GN-DIVI.Campo-Date[1] AND TODAY <= GN-DIVI.Campo-Date[2]) THEN DO:
        MESSAGE 'Lista de Precios' pCodDiv 'no está vigente' SKIP
            'Comuníquese con el área Comercial' SKIP(1)
            'Proceso Abortado'
            VIEW-AS ALERT-BOX WARNING.
        RETURN 'ADM-ERROR'.
    END.
END.
/* ****************************************************************************** */
ASSIGN
    s-Import-IBC    = NO
    s-Import-B2B    = NO
    S-CODMON = FacCPedi.CodMon
    S-CODCLI = FacCPedi.CodCli
    S-TPOCMB = FacCPedi.TpoCmb
    S-FmaPgo = FacCPedi.FmaPgo
    s-Copia-Registro = NO
    s-PorIgv = Faccpedi.porigv
    s-NroDec = (IF Faccpedi.Libre_d01 <= 0 THEN 4 ELSE Faccpedi.Libre_d01)
    s-FlgIgv = Faccpedi.FlgIgv
    s-adm-new-record = "NO"
    s-nroped = Faccpedi.nroped
    S-CMPBNTE = Faccpedi.Cmpbnte
    pFechaEntrega = Faccpedi.fchent
    S-TPOMARCO = Faccpedi.Libre_C04.    /* CASO DE CLIENTES EXCEPCIONALES */

/* SOLO CANAL MODERNO */
IF s-TpoPed = "S" THEN DO:
    IF FacCPedi.Libre_C05 = "1" THEN s-Import-Ibc       = YES.
    IF FacCPedi.Libre_C05 = "3" THEN s-Import-B2B       = YES.
    /* RHC 07/12/2015 SEGUNDO CHEQUEO */
    IF (s-import-ibc = YES AND s-pendiente-ibc = YES) THEN DO:
        MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    IF s-Import-B2B = YES THEN DO:
        MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
END.

RUN Carga-Temporal.

x-order-type = faccpedi.OrderType.
x-cod-origen =  faccpedi.codorigen.
x-nro-origen = faccpedi.nroorigen.

/* Cargamos las condiciones de venta válidas */
FIND gn-clie WHERE gn-clie.codcia  = cl-codcia
    AND gn-clie.codcli = s-codcli
    NO-LOCK.

RUN vtagn/p-fmapgo-valido (s-codcli, s-tpoped, pCodDiv, OUTPUT s-cndvta-validos).

RUN Procesa-Handle IN lh_Handle ('Pagina2').
/*RUN Procesa-Handle IN lh_Handle ('browse').*/

/* ********************************************************************************/
IF s-TpoPed = "LF" THEN RUN Procesa-Handle IN lh_Handle ('Pagina4').


RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VTA_Valida-Margen-Utilidad-Total V-table-Win 
PROCEDURE VTA_Valida-Margen-Utilidad-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

DEF BUFFER B-CPEDI FOR Faccpedi.
pError = "".
FIND B-CPEDI WHERE ROWID(B-CPEDI) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CPEDI THEN RETURN 'OK'.

IF LOOKUP(B-CPEDI.TpoPed, "M,R,E,LF") > 0 THEN RETURN "OK".   

DEF VAR pMargen AS DEC NO-UNDO.
DEF VAR pLimite AS DEC NO-UNDO.

FOR EACH Facdpedi OF B-CPEDI NO-LOCK WHERE Facdpedi.Libre_c05 <> "OF":
    RUN vtagn/p-margen-utilidad-v2 (INPUT B-CPEDI.Lista_de_Precios,   /* INPUT B-CPEDI.CodDiv,*/
                                    INPUT Facdpedi.codmat,
                                    INPUT (Facdpedi.ImpLin / Facdpedi.CanPed),
                                    INPUT Facdpedi.UndVta,
                                    INPUT B-CPEDI.CodMon,
                                    INPUT B-CPEDI.TpoCmb,
                                    INPUT NO,
                                    INPUT Facdpedi.AlmDes,
                                    OUTPUT pMargen,
                                    OUTPUT pLimite,
                                    OUTPUT pError).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE WRITE-DETAIL V-table-Win 
PROCEDURE WRITE-DETAIL :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE x-StkActual AS DECIMAL NO-UNDO.
DEFINE VARIABLE s-StkComprometido AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-StkDisponible AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-CanPedida AS DECIMAL NO-UNDO.
DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

FOR EACH ITEM NO-LOCK WHERE ITEM.ImpLin > 0,
    FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = ITEM.codmat
    BY ITEM.NroItm:
    /* 
      Ic - 19Ago2022 : Pre Carritos ListaExpress NO VALIDAR Stocks, segun diseño Daniel Llican 
              en coordinacion con Gianella Chirinos
    */
    IF Faccpedi.coddoc <> "PLE" THEN DO:          
        /* ****************************************************************************** */
        /* VER SI LA DIVISION SOLO GRABA SI HAY STOCK */
        /* ****************************************************************************** */
        FIND FacTabla WHERE FacTabla.codcia = s-CodCia AND
            FacTabla.tabla = "GN-DIVI" AND
            FacTabla.codigo = s-CodDiv AND
            FacTabla.campo-L[1] = YES
            NO-LOCK NO-ERROR.
        IF AVAILABLE FacTabla THEN DO:
            /* Verificamos el stock del primer almacén válido */
            FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
                AND  Almmmate.CodAlm = ENTRY(1, s-CodAlm)
                AND  Almmmate.codmat = ITEM.CodMat
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almmmate THEN x-StkActual = Almmmate.StkAct.
            ELSE x-StkActual = 0.
            RUN gn/Stock-Comprometido-v2 (ITEM.CodMat,
                                          ENTRY(1, s-CodAlm),
                                          YES,
                                          OUTPUT s-StkComprometido).
            x-StkDisponible = x-StkActual - s-StkComprometido.
            x-CanPedida = ITEM.CanPed * ITEM.Factor.
            IF x-CanPedida > x-StkDisponible THEN DO:
                pMensaje = "No hay STOCK disponible en el almacén " + ENTRY(1, s-CodAlm) + CHR(10) +
                           "para el producto " + ITEM.CodMat + CHR(10) +
                           "     STOCK ACTUAL : " + STRING(x-StkActual) + CHR(10) +
                           "     COMPROMETIDO : " + STRING(s-StkComprometido) + CHR(10) + CHR(10) +
                           "Proceso Abortado".
                UNDO, RETURN 'ADM-ERROR'.
            END.
        END.
     END.
    /* ****************************************************************************** */
    /* ****************************************************************************** */
    I-NITEM = I-NITEM + 1.
    CREATE FacDPedi.
    BUFFER-COPY ITEM EXCEPT ITEM.Libre_d05
        TO FacDPedi
        ASSIGN
            FacDPedi.CodCia = FacCPedi.CodCia
            FacDPedi.CodDiv = FacCPedi.CodDiv
            FacDPedi.coddoc = FacCPedi.coddoc
            FacDPedi.NroPed = FacCPedi.NroPed
            FacDPedi.FchPed = FacCPedi.FchPed
            FacDPedi.Hora   = FacCPedi.Hora 
            FacDPedi.FlgEst = FacCPedi.FlgEst
            FacDPedi.NroItm = I-NITEM.
END.
IF AVAILABLE(FacDPedi) THEN RELEASE FacDPedi.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE WRITE-HEADER V-table-Win 
PROCEDURE WRITE-HEADER :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pAdmNewRecord AS CHAR.

DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* BLOQUEAMOS CABECERA NUEVAMENTE: Se supone que solo un vendedor está manipulando la cotización */
    FIND CURRENT FacCPedi EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR = YES  THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* ************************************************************************************** */
    /* DESCUENTOS APLICADOS A TODA LA COTIZACION */
    /* ************************************************************************************** */
    RUN DESCUENTOS-FINALES (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'ERROR al aplicar los descuentos totales a la cotización'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* ****************************************************************************************** */
    DEF VAR hProc AS HANDLE NO-UNDO.
    /* ****************************************************************************************** */
    /* RHC 02/01/2020 Promociones proyectadas */
    /* ****************************************************************************************** */
    EMPTY TEMP-TABLE ITEM.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK:
        CREATE ITEM.
        BUFFER-COPY Facdpedi TO ITEM.
    END.
    RUN vtagn/p-promocion-general.r (INPUT Faccpedi.CodDiv,
                                     INPUT Faccpedi.CodDoc,
                                     INPUT Faccpedi.NroPed,
                                     INPUT TABLE ITEM,
                                     OUTPUT TABLE BONIFICACION,
                                     OUTPUT pMensaje).
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".

    I-NITEM = 0.
    FOR EACH BONIFICACION,
        FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia AND 
        Almmmatg.codmat = BONIFICACION.codmat
        BY BONIFICACION.NroItm:
        I-NITEM = I-NITEM + 1.
        CREATE FacDPedi.
        BUFFER-COPY BONIFICACION
            TO FacDPedi
            ASSIGN
                FacDPedi.CodCia = FacCPedi.CodCia
                FacDPedi.CodDiv = FacCPedi.CodDiv
                FacDPedi.coddoc = "CBO"   /* Bonificacion en COT */
                FacDPedi.NroPed = FacCPedi.NroPed
                FacDPedi.FchPed = FacCPedi.FchPed
                FacDPedi.Hora   = FacCPedi.Hora 
                FacDPedi.FlgEst = FacCPedi.FlgEst
                FacDPedi.NroItm = I-NITEM.
    END.
    /* ****************************************************************************************** */
    /* ****************************************************************************************** */
    &IF {&ARITMETICA-SUNAT} &THEN
      {vtagn/totales-cotizacion-sunat.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
      /* ****************************************************************************************** */
      /* Importes SUNAT */
      /* ****************************************************************************************** */
      RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
      RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                                   INPUT Faccpedi.CodDoc,
                                   INPUT Faccpedi.NroPed,
                                   OUTPUT pMensaje).
      IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
      DELETE PROCEDURE hProc.
    &ELSE
      {vtagn/totales-cotizacion-unificada.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
      /* ****************************************************************************************** */
      /* Importes SUNAT */
      /* NO actualiza importes Progress */
      /* ****************************************************************************************** */
      RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
      RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                                   INPUT Faccpedi.CodDoc,
                                   INPUT Faccpedi.NroPed,
                                   OUTPUT pMensaje).
      IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
      DELETE PROCEDURE hProc.
    &ENDIF
    /* ****************************************************************************************** */
    DEFINE VAR x-tabla AS CHAR.
    DEFINE VAR x-llave_c1 AS CHAR.
    DEFINE VAR x-llave_c2 AS CHAR.
    DEFINE VAR x-rowid AS ROWID.

    x-tabla = "LISTAEXPRESS".
    x-llave_c1 = "PRE-CARRITOS".

    /*RUN GET-ATTRIBUTE('ADM-NEW-RECORD').*/
    IF pAdmNewRecord = "YES" THEN DO:
        IF faccpedi.coddoc = "PLE" THEN DO:    
            IF x-order-type = "STANDARD" THEN DO:
                /* Se esta creando el PRE-Carrito de Precios STANDARD apartir de un PREMIUM */
                FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND
                                b-faccpedi.coddoc = x-cod-origen AND
                                b-faccpedi.nroped = x-nro-origen EXCLUSIVE-LOCK NO-ERROR.   /* el nro del pedido PREMIUM */
                IF AVAILABLE b-faccpedi THEN DO:
                    /* En el PREMIUM grabo el numero de pedido STANDARD */
                    ASSIGN b-faccpedi.codorigen = faccpedi.coddoc
                                b-faccpedi.nroorigen = faccpedi.nroped.
                END.

                /* SUGERIDOS */
                x-llave_c2 = "STANDARD".
                FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = x-tabla AND
                                        vtatabla.llave_c1 = x-llave_c1 AND vtatabla.llave_c2 = x-llave_c2 AND
                                        vtatabla.llave_c3 = x-cod-origen + "-" + x-nro-origen NO-LOCK:
                    x-rowid = ROWID(vtatabla).
                    FIND FIRST b-vtatabla WHERE ROWID(b-vtatabla) = x-rowid EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAILABLE b-vtatabla THEN DO:
                        ASSIGN b-vtatabla.llave_c3 = faccpedi.coddoc + "-" + faccpedi.nroped.
                    END.
                END.

            END.
            /* 
                SUGERIDOS, como primero se graba el PREMIUM, tbm grabo los STANDARD con el mismo numero
                cuando genero el STANDARD le cambio el numero de pedido
             */ 
            FOR EACH tt-listaexpress-sugeridos NO-LOCK:
                IF x-order-type = "PREMIUM" THEN DO:
                    IF NOT (TRUE <> (tt-listaexpress-sugeridos.campo-c[1] > "")) THEN DO:
                        x-llave_c2 = "PREMIUM".
                        CREATE b-vtatabla.
                        ASSIGN b-vtatabla.codcia = s-codcia
                                b-vtatabla.tabla = x-tabla
                                b-vtatabla.llave_c1 = x-llave_c1
                                b-vtatabla.llave_c2 = x-llave_c2
                                b-vtatabla.llave_c3 = faccpedi.coddoc + "-" + faccpedi.nroped
                                b-vtatabla.llave_c4 = tt-listaexpress-sugeridos.campo-c[1]
                            .
                    END.
                    IF NOT (TRUE <> (tt-listaexpress-sugeridos.campo-c[2] > "")) THEN DO:
                        x-llave_c2 = "STANDARD".
                        CREATE b-vtatabla.
                        ASSIGN b-vtatabla.codcia = s-codcia
                                b-vtatabla.tabla = x-tabla
                                b-vtatabla.llave_c1 = x-llave_c1
                                b-vtatabla.llave_c2 = x-llave_c2
                                b-vtatabla.llave_c3 = faccpedi.coddoc + "-" + faccpedi.nroped
                                b-vtatabla.llave_c4 = tt-listaexpress-sugeridos.campo-c[2]
                            .
                    END.
                END.
            END.
        END.
    END.
END.
IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
IF AVAILABLE(gn-clie)  THEN RELEASE Gn-Clie.
IF AVAILABLE(VtaTabla) THEN RELEASE VtaTabla.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

