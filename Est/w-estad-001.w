&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
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

{src/adm2/widgetprto.i}

{lib/tt-file.i}

DEF NEW SHARED VAR input-var-1 AS CHAR.
DEF NEW SHARED VAR input-var-2 AS CHAR.
DEF NEW SHARED VAR input-var-3 AS CHAR.
DEF NEW SHARED VAR output-var-1 AS ROWID.
DEF NEW SHARED VAR output-var-2 AS CHAR.
DEF NEW SHARED VAR output-var-3 AS CHAR.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.

/* VARIABLES PARA EL RESUMEN */
DEF VAR x-CodDiv LIKE DimDivision.coddiv   NO-UNDO.
DEF VAR x-DivDes LIKE DimDivision.coddiv   NO-UNDO.
DEF VAR x-CodCli LIKE DimCliente.codcli   NO-UNDO.
DEF VAR x-ClfCli LIKE DimCliente.clfcli   NO-UNDO.
DEF VAR x-CodMat LIKE DimProducto.codmat  NO-UNDO.
DEF VAR x-CodPro LIKE DimProveedor.codpro   NO-UNDO.
DEF VAR x-CodVen LIKE DimVendedor.codven    NO-UNDO.
DEF VAR x-CodFam LIKE DimProducto.codfam  NO-UNDO.
DEF VAR x-SubFam LIKE DimProducto.subfam  NO-UNDO.
DEF VAR x-CanalVenta LIKE DimDivision.CanalVenta NO-UNDO.
DEF VAR x-Canal  LIKE DimCliente.canal    NO-UNDO.
DEF VAR x-Giro   LIKE DimCliente.gircli   NO-UNDO.
DEF VAR x-NroCard LIKE DimCliente.nrocard NO-UNDO.
DEF VAR x-Zona   AS CHAR               NO-UNDO.
DEF VAR x-CodDept LIKE DimCliente.coddept NO-UNDO.
DEF VAR x-CodProv LIKE DimCliente.codprov NO-UNDO.
DEF VAR x-CodDist LIKE DimCliente.coddist NO-UNDO.
DEF VAR x-CuentaReg  AS INT             NO-UNDO.    /* Contador de registros */
DEF VAR x-MuestraReg AS INT             NO-UNDO.    /* Tope para mostrar registros */
DEF VAR x-TpoCmbCmp AS DECI INIT 1 NO-UNDO.
DEF VAR x-TpoCmbVta AS DECI INIT 1 NO-UNDO.
DEF VAR x-CostoExtCIGV LIKE VentasxProducto.CostoExtCIGV NO-UNDO.
DEF VAR x-CostoNacCIGV LIKE VentasxProducto.CostoNacCIGV NO-UNDO.

/* VARIABLES PARA EL EXCEL O TEXTO */
DEF VAR iContador AS INT NO-UNDO.
DEF VAR iLimite   AS INT NO-UNDO.

DEFINE VAR x-Llave AS CHAR.
DEF STREAM REPORTE.

/* Configuracion de opciones del reporte por usuario */
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-aplic-id AS CHAR.

DEF VAR s-ConCostos             AS LOG INIT NO NO-UNDO.
DEF VAR s-TodasLasDivisiones    AS LOG INIT NO NO-UNDO.
DEF VAR s-Familia010            AS LOG INIT NO NO-UNDO.

FIND EstadTabla WHERE EstadTabla.Tabla = 'EST'
    AND EstadTabla.Codigo = s-user-id
    NO-LOCK NO-ERROR.
IF AVAILABLE EstadTabla THEN
    ASSIGN
        s-ConCostos =  EstadTabla.Campo-Logical[1] 
        s-TodasLasDivisiones = EstadTabla.Campo-Logical[2] 
        s-Familia010 = EstadTabla.Campo-Logical[3].


/*Tabla Clientes*/
DEFINE TEMP-TABLE tt-cliente NO-UNDO
    FIELDS tt-codcli LIKE DimCliente.codcli
    FIELDS tt-nomcli LIKE DimCliente.nomcli
    INDEX idx01 IS PRIMARY tt-codcli.

/*Tabla Productos*/
DEFINE TEMP-TABLE tt-articulo NO-UNDO
    FIELDS tt-codmat LIKE DimProducto.codmat
    FIELDS tt-desmat LIKE DimProducto.desmat
    INDEX idx01 IS PRIMARY tt-codmat.

DEFINE TEMP-TABLE tt-datos NO-UNDO
    FIELDS tt-codigo AS CHAR.

/* TABLA GENERAL ACUMULADOS */
DEF TEMP-TABLE Detalle NO-UNDO
    FIELD Llave     AS CHAR
    FIELD Campania  AS CHAR FORMAT 'x(20)'
    FIELD Periodo   AS INT  FORMAT 'ZZZ9' LABEL 'Año'
    FIELD NroMes    AS INT  FORMAT 'Z9' LABEL 'Mes'
    FIELD Dia       AS DATE FORMAT '99/99/9999' LABEL 'Dia'
    FIELD Division  AS CHAR  FORMAT 'x(60)'
    FIELD Destino   AS CHAR  FORMAT 'x(60)'
    FIELD CanalVenta AS CHAR    LABEL "Canal Venta" FORMAT 'x(60)'
    FIELD Producto  AS CHAR FORMAT 'x(60)'
    FIELD Ranking   AS INT  FORMAT '>>>>>9' LABEL 'Rank. Gral'
    FIELD Categoria AS CHAR FORMAT 'X' LABEL 'Clasf. Gral'
    FIELD clsfutlx AS CHAR FORMAT 'X' LABEL 'Clasf. Utilex'
    FIELD rnkgutlx AS INT FORMAT '>>>,>>>,>>9' LABEL 'Rank. Utilex'
    FIELD clsfmayo AS CHAR FORMAT 'X' LABEL 'Clasf. Mayorista'
    FIELD rnkgmayo AS INT FORMAT '>>>,>>>,>>9' LABEL 'Rank. Mayorista'
    FIELD Linea     AS CHAR FORMAT 'x(60)'
    FIELD Sublinea  AS CHAR FORMAT 'x(60)'
    FIELD Marca     AS CHAR FORMAT 'x(20)'
    FIELD Unidad    AS CHAR FORMAT 'x(10)'
    FIELD Licencia  AS CHAR FORMAT 'x(60)'
    FIELD Licenciatario AS CHAR FORMAT 'x(60)'
    FIELD Proveedor AS CHAR FORMAT 'x(60)'
    FIELD Cliente   AS CHAR FORMAT 'x(60)'
    FIELD CliUnico  AS CHAR FORMAT 'x(60)'
    FIELD CliAcc    AS CHAR FORMAT 'x(8)'       /* Cliente Accionista */
    FIELD Canal     AS CHAR FORMAT 'x(60)'
    FIELD Giro      AS CHAR FORMAT 'x(60)'
    FIELD Tarjeta   AS CHAR FORMAT 'x(60)'
    FIELD Departamento AS CHAR FORMAT 'x(20)'
    FIELD Provincia AS CHAR FORMAT 'x(20)'
    FIELD Distrito  AS CHAR FORMAT 'x(20)'
    FIELD Zona      AS CHAR FORMAT 'x(20)'
    FIELD Clasificacion AS CHAR FORMAT 'x(20)'
    FIELD Tipo      AS CHAR FORMAT 'x(20)'
    FIELD Vendedor  AS CHAR FORMAT 'x(60)'
    FIELD SubTipo   AS CHAR LABEL 'SubTipo'     FORMAT 'x(30)'
    FIELD CodAsoc   AS CHAR LABEL 'Cod Asociado'    FORMAT 'x(60)'
    FIELD Delivery  AS CHAR LABEL 'Delivery'    FORMAT 'x(2)'
    FIELD ListaBase AS CHAR LABEL 'Lista Base'  FORMAT 'x(60)'
    FIELD CanxMes   AS DEC  LABEL "Cantidad"    FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD VtaxMesMe AS DEC  LABEL "Ventas US$"  FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD VtaxMesMn AS DEC  LABEL "Ventas S/."  FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD CtoxMesMe AS DEC  LABEL "Costo US$"   FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD CtoxMesMn AS DEC  LABEL "Costo S/."   FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD ProxMesMe AS DEC  LABEL "Promedio US$"    FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD ProxMesMn AS DEC  LABEL "Promedio S/."    FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD ProxMesMe2 AS DEC  LABEL "Promedio US$ (SIN IGV)"    FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD ProxMesMn2 AS DEC  LABEL "Promedio S/. (SIN IGV)"    FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD CodigoPadre AS CHAR LABEL 'Cod. Padre' FORMAT 'x(60)'
    FIELD FactorPadre AS DEC LABEL 'Factor Padre' FORMAT '>>>,>>9.9999'
    FIELD NCantidad   AS DEC LABEL 'NCantidad' FORMAT '->>>,>>>,>>>,>>9.99'
    INDEX Indice01 AS PRIMARY Llave.

DEF TEMP-TABLE T-Detalle NO-UNDO LIKE Detalle.

DEF VAR cCampania LIKE Detalle.Campania.
DEF VAR cPeriodo LIKE Detalle.Periodo.
DEF var cNroMes   LIKE Detalle.NroMes.
DEF VAR cDia      LIKE Detalle.Dia.
DEF VAR cDivision LIKE Detalle.Division.
DEF VAR cDestino  LIKE Detalle.Destino.
DEF VAR cCanalVenta LIKE Detalle.CanalVenta.
DEF VAR cProducto  LIKE Detalle.Producto.

DEF VAR cRanking   LIKE Detalle.Ranking.
DEF VAR cCategoria LIKE Detalle.Categoria.

DEF VAR cRUtilex  LIKE Detalle.rnkgutlx.
DEF VAR cCUtilex   LIKE Detalle.clsfutlx.

DEF VAR cRMayo   LIKE Detalle.rnkgmayo.
DEF VAR cCMayo  LIKE Detalle.clsfmayo.

DEF VAR cLinea     LIKE Detalle.Linea.
DEF VAR cSublinea  LIKE Detalle.Sublinea.
DEF VAR cMarca     LIKE Detalle.Marca.
DEF VAR cUnidad    LIKE Detalle.Unidad.
DEF VAR cLicencia  LIKE Detalle.Licencia.
DEF VAR cLicenciatario  LIKE Detalle.Licenciatario.
DEF VAR cProveedor LIKE Detalle.Proveedor.
DEF VAR cCliente   LIKE Detalle.Cliente.
DEF VAR cCliUnico  LIKE Detalle.CliUnico.
DEF VAR cCliAcc    LIKE Detalle.CliAcc.
DEF VAR cCanal     LIKE Detalle.Canal.
DEF VAR cGiro      LIKE Detalle.Giro.
DEF VAR cTarjeta   LIKE Detalle.Tarjeta.
DEF VAR cDepartamento LIKE Detalle.Departamento.
DEF VAR cProvincia LIKE Detalle.Provincia.
DEF VAR cDistrito  LIKE Detalle.Distrito.
DEF VAR cZona      LIKE Detalle.Zona.
DEF VAR cClasificacion LIKE Detalle.Clasificacion.
DEF VAR cTipo      LIKE Detalle.Tipo.
DEF VAR cVendedor  LIKE Detalle.Vendedor.
DEF VAR cSubTipo    LIKE Detalle.SubTipo.
DEF VAR cCodAsoc    LIKE Detalle.CodAsoc.
DEF VAR cDelivery   LIKE Detalle.Delivery.
DEF VAR cListaBase  LIKE Detalle.ListaBase.

DEF VAR pOptions AS CHAR.
DEF VAR pArchivo AS CHAR.
DEF VAR cArchivo AS CHAR.
DEF VAR zArchivo AS CHAR.
DEF VAR cComando AS CHAR.
DEF VAR pDirectorio AS CHAR.
DEF VAR lOptions AS CHAR.
DEF VAR cListaDivisiones AS CHAR.
DEF VAR cDivisiones AS CHAR.

DEF BUFFER B-Producto FOR DimProducto.
DEF BUFFER B-Cliente  FOR DimCliente.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 RECT-4 RECT-5 BUTTON-1 ~
BtnDone TOGGLE-CodDiv TOGGLE-CodCli TOGGLE-CodMat TOGGLE-CodVen ~
RADIO-SET-Tipo BUTTON-7 DesdeF HastaF TOGGLE-NoVentas rRanking 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Mensaje TOGGLE-CodDiv ~
SELECT-CodDiv TOGGLE-CodCli FILL-IN-CodCli FILL-IN-NomCli FILL-IN-file ~
TOGGLE-Resumen-Depto TOGGLE-CodMat COMBO-BOX-CodFam TOGGLE-Resumen-Linea ~
TOGGLE-Resumen-solo-linea COMBO-BOX-SubFam TOGGLE-Resumen-Marca ~
FILL-IN-CodMat FILL-IN-DesMat FILL-IN-file-2 FILL-IN-CodPro FILL-IN-NomPro ~
TOGGLE-CodVen FILL-IN-CodVen FILL-IN-NomVen RADIO-SET-Tipo DesdeF HastaF ~
TOGGLE-NoVentas rRanking 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 6 BY 1.62 TOOLTIP "Salir"
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 6 BY 1.62 TOOLTIP "MIgrar a Excel".

DEFINE BUTTON BUTTON-5 
     LABEL "..." 
     SIZE 5 BY 1.

DEFINE BUTTON BUTTON-6 
     LABEL "..." 
     SIZE 5 BY 1.

DEFINE BUTTON BUTTON-7 
     LABEL "VER STOCKS VALORIZADOS" 
     SIZE 28 BY 1.12.

DEFINE VARIABLE COMBO-BOX-CodFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Linea" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-SubFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Sub-linea" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodMat AS CHARACTER FORMAT "X(6)":U 
     LABEL "Codigo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPro AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodVen AS CHARACTER FORMAT "X(3)":U 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesMat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-file AS CHARACTER FORMAT "X(256)":U 
     LABEL "Archivo de Clientes" 
     VIEW-AS FILL-IN 
     SIZE 76 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-file-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Archivo de Productos" 
     VIEW-AS FILL-IN 
     SIZE 76 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 97 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 83 BY 1 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Tipo AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Resumido", 1,
"Mensual", 2,
"Diario", 3
     SIZE 34 BY 1.08 NO-UNDO.

DEFINE VARIABLE rRanking AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Campaña", 1,
"NO Campaña", 2
     SIZE 31 BY .96 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 116 BY 6.73.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 116 BY 3.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 116 BY 5.92.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 116 BY 1.62.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 116 BY 3.77.

DEFINE VARIABLE SELECT-CodDiv AS CHARACTER INITIAL "Todos" 
     VIEW-AS SELECTION-LIST MULTIPLE SCROLLBAR-VERTICAL 
     LIST-ITEM-PAIRS "Todos","Todos" 
     SIZE 93 BY 5.65 NO-UNDO.

DEFINE VARIABLE TOGGLE-CodCli AS LOGICAL INITIAL no 
     LABEL "Cliente" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-CodDiv AS LOGICAL INITIAL no 
     LABEL "Division Origen" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-CodMat AS LOGICAL INITIAL no 
     LABEL "Artículo" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-CodVen AS LOGICAL INITIAL no 
     LABEL "Vendedor" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-NoVentas AS LOGICAL INITIAL no 
     LABEL "INCLUIR ~"NO VENTAS~"" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Resumen-Depto AS LOGICAL INITIAL no 
     LABEL "Resumido por Departamento-Provincia" 
     VIEW-AS TOGGLE-BOX
     SIZE 37 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Resumen-Linea AS LOGICAL INITIAL yes 
     LABEL "Resumido por Linea y Sub-Linea" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Resumen-Marca AS LOGICAL INITIAL no 
     LABEL "Resumido por Marca" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Resumen-solo-linea AS LOGICAL INITIAL no 
     LABEL "Resumido solo por Linea" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     BUTTON-1 AT ROW 1 COL 106 WIDGET-ID 24
     BtnDone AT ROW 1 COL 112 WIDGET-ID 28
     FILL-IN-Mensaje AT ROW 1.27 COL 2 NO-LABEL WIDGET-ID 22
     TOGGLE-CodDiv AT ROW 2.88 COL 5 WIDGET-ID 2
     SELECT-CodDiv AT ROW 2.88 COL 23 NO-LABEL WIDGET-ID 106
     TOGGLE-CodCli AT ROW 9.62 COL 5 WIDGET-ID 6
     FILL-IN-CodCli AT ROW 9.62 COL 23 COLON-ALIGNED WIDGET-ID 32
     FILL-IN-NomCli AT ROW 9.62 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     BUTTON-5 AT ROW 10.69 COL 102 WIDGET-ID 66
     FILL-IN-file AT ROW 10.73 COL 23 COLON-ALIGNED WIDGET-ID 68
     TOGGLE-Resumen-Depto AT ROW 11.77 COL 25 WIDGET-ID 64
     TOGGLE-CodMat AT ROW 13.12 COL 5 WIDGET-ID 14
     COMBO-BOX-CodFam AT ROW 13.12 COL 23 COLON-ALIGNED WIDGET-ID 36
     TOGGLE-Resumen-Linea AT ROW 13.12 COL 75 WIDGET-ID 92
     TOGGLE-Resumen-solo-linea AT ROW 13.92 COL 75 WIDGET-ID 90
     COMBO-BOX-SubFam AT ROW 14.19 COL 23 COLON-ALIGNED WIDGET-ID 38
     TOGGLE-Resumen-Marca AT ROW 14.73 COL 75 WIDGET-ID 94
     FILL-IN-CodMat AT ROW 15.54 COL 23 COLON-ALIGNED WIDGET-ID 70
     FILL-IN-DesMat AT ROW 15.54 COL 38.14 COLON-ALIGNED NO-LABEL WIDGET-ID 72
     BUTTON-6 AT ROW 16.58 COL 102 WIDGET-ID 74
     FILL-IN-file-2 AT ROW 16.62 COL 23 COLON-ALIGNED WIDGET-ID 76
     FILL-IN-CodPro AT ROW 17.69 COL 23 COLON-ALIGNED WIDGET-ID 40
     FILL-IN-NomPro AT ROW 17.69 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     TOGGLE-CodVen AT ROW 19.04 COL 5 WIDGET-ID 18
     FILL-IN-CodVen AT ROW 19.04 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     FILL-IN-NomVen AT ROW 19.04 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     RADIO-SET-Tipo AT ROW 20.58 COL 25 NO-LABEL WIDGET-ID 56
     BUTTON-7 AT ROW 21.46 COL 88 WIDGET-ID 98
     DesdeF AT ROW 21.58 COL 23 COLON-ALIGNED WIDGET-ID 10
     HastaF AT ROW 21.58 COL 45 COLON-ALIGNED WIDGET-ID 12
     TOGGLE-NoVentas AT ROW 21.85 COL 63 WIDGET-ID 96
     rRanking AT ROW 22.85 COL 26 NO-LABEL WIDGET-ID 100
     "Mantener la tecla CTRL presionada para seleccionar varios registros" VIEW-AS TEXT
          SIZE 59 BY .62 AT ROW 8.54 COL 5 WIDGET-ID 108
     "Mostrar el Ranking de :" VIEW-AS TEXT
          SIZE 20 BY .62 AT ROW 23 COL 5.14 WIDGET-ID 104
          FGCOLOR 12 FONT 6
     RECT-1 AT ROW 2.62 COL 2 WIDGET-ID 78
     RECT-2 AT ROW 9.35 COL 2 WIDGET-ID 80
     RECT-3 AT ROW 12.85 COL 2 WIDGET-ID 82
     RECT-4 AT ROW 18.77 COL 2 WIDGET-ID 84
     RECT-5 AT ROW 20.31 COL 2 WIDGET-ID 86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 121.86 BY 23.58 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "ESTADISTICAS DE VENTAS"
         HEIGHT             = 23.58
         WIDTH              = 121.86
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.14
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.14
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON BUTTON-5 IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON BUTTON-6 IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-CodFam IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-SubFam IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodCli IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodMat IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodPro IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodVen IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DesMat IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-file IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-file-2 IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME fMain
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomVen IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR SELECTION-LIST SELECT-CodDiv IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-Resumen-Depto IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-Resumen-Linea IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-Resumen-Marca IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-Resumen-solo-linea IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* ESTADISTICAS DE VENTAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* ESTADISTICAS DE VENTAS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone wWin
ON CHOOSE OF BtnDone IN FRAME fMain /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 wWin
ON CHOOSE OF BUTTON-1 IN FRAME fMain /* Button 1 */
DO:
    ASSIGN
        TOGGLE-CodCli 
        TOGGLE-CodDiv 
        TOGGLE-CodMat 
        TOGGLE-CodVen
        TOGGLE-Resumen-Linea 
        TOGGLE-Resumen-solo-linea
        TOGGLE-Resumen-Marca
        TOGGLE-Resumen-Depto
        TOGGLE-NoVentas
        rRanking.
    ASSIGN
        SELECT-CodDiv 
        COMBO-BOX-CodFam 
        COMBO-BOX-SubFam 
        FILL-IN-CodCli 
        FILL-IN-CodPro 
        FILL-IN-CodVen 
        FILL-IN-CodMat
        FILL-IN-file 
        FILL-IN-file-2.
    ASSIGN
        RADIO-SET-Tipo
        DesdeF HastaF
        pOptions = "".
    /* CONSISTENCIA */
    IF (TOGGLE-CodCli OR 
        TOGGLE-CodDiv OR
        TOGGLE-CodMat OR
        TOGGLE-CodVen
        ) = NO
        THEN DO:
        MESSAGE 'Debe seleccionar por lo menos uno' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    IF HastaF - DesdeF > 30 AND RADIO-SET-Tipo = 3 THEN DO:
        MESSAGE 'La diferencia de fechas es de más de 30 días' SKIP
            'La información puede ser excesiva para cargarla en una hoja Excel' SKIP
            '¿Continuamos con el proceso?' 
            VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.
    END.
    RUN lib/tt-file-to-text-7zip (OUTPUT pOptions, OUTPUT pArchivo, OUTPUT pDirectorio).
    IF pOptions = "" THEN RETURN NO-APPLY.

    SESSION:SET-WAIT-STATE('GENERAL').
    IF INDEX(pOptions, 'FileType:XLS') > 0 THEN SESSION:DATE-FORMAT = "mdy".
    RUN Carga-Temporal.
    SESSION:DATE-FORMAT = "dmy".
    SESSION:SET-WAIT-STATE('').

    FIND FIRST Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    pOptions = pOptions + CHR(1) + "SkipList:Llave".

    /* El archivo se va a generar en un archivo temporal de trabajo antes 
    de enviarlo a su directorio destino */
    pArchivo = REPLACE(pArchivo, '.', STRING(RANDOM(1,9999), '9999') + ".").
    cArchivo = LC(SESSION:TEMP-DIRECTORY + pArchivo).
    SESSION:SET-WAIT-STATE('GENERAL').
    IF INDEX(pOptions, 'FileType:XLS') > 0 THEN SESSION:DATE-FORMAT = "mdy".
    RUN lib/tt-file (TEMP-TABLE Detalle:HANDLE, cArchivo, pOptions).
    SESSION:DATE-FORMAT = "dmy".
    SESSION:SET-WAIT-STATE('').

    /* Secuencia de comandos para encriptar el archivo con 7zip */
    IF INDEX(cArchivo, ".xls") > 0 THEN zArchivo = REPLACE(cArchivo, ".xls", ".zip").
    IF INDEX(cArchivo, ".txt") > 0 THEN zArchivo = REPLACE(cArchivo, ".txt", ".zip").
    cComando = '"C:\Archivos de programa\7-Zip\7z.exe" a ' + zArchivo + ' ' + cArchivo.
    OS-COMMAND 
        SILENT 
        VALUE ( cComando ).
    IF SEARCH(zArchivo) = ? THEN DO:
        MESSAGE 'NO se pudo encriptar el archivo' SKIP
            'Avise a sistemas'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    OS-DELETE VALUE(cArchivo).

    IF INDEX(cArchivo, '.xls') > 0 THEN cArchivo = REPLACE(pArchivo, ".xls", ".zip").
    IF INDEX(cArchivo, '.txt') > 0 THEN cArchivo = REPLACE(pArchivo, ".txt", ".zip").
    cComando = "copy " + zArchivo + ' ' + TRIM(pDirectorio) + TRIM(cArchivo).
    OS-COMMAND 
        SILENT 
        /*NO-WAIT */
        /*NO-CONSOLE */
        VALUE(cComando).
    OS-DELETE VALUE(zArchivo).
    /* ******************************************************* */

    ASSIGN
       FILL-IN-file = ''
       FILL-IN-file-2 = ''.

    DISPLAY FILL-IN-file FILL-IN-file-2 WITH FRAME {&FRAME-NAME}.
    MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 wWin
ON CHOOSE OF BUTTON-5 IN FRAME fMain /* ... */
DO:

    DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.

    SYSTEM-DIALOG GET-FILE FILL-IN-file
        FILTERS
            "Archivos Texto (*.txt)" "*.txt"
        TITLE
            "Archivo(s) de Carga..."
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.

    IF OKpressed = TRUE THEN
        FILL-IN-file:SCREEN-VALUE = FILL-IN-file.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 wWin
ON CHOOSE OF BUTTON-6 IN FRAME fMain /* ... */
DO:

    DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.

    SYSTEM-DIALOG GET-FILE FILL-IN-file-2
        FILTERS
            "Archivos Texto (*.txt)" "*.txt"
        TITLE
            "Archivo(s) de Carga..."
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.

    IF OKpressed = TRUE THEN
        FILL-IN-file-2:SCREEN-VALUE = FILL-IN-file-2.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 wWin
ON CHOOSE OF BUTTON-7 IN FRAME fMain /* VER STOCKS VALORIZADOS */
DO:
   RUN est/d-lineavalorizada.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodFam wWin
ON VALUE-CHANGED OF COMBO-BOX-CodFam IN FRAME fMain /* Linea */
DO:
    COMBO-BOX-SubFam:DELETE(COMBO-BOX-SubFam:LIST-ITEMS).
    COMBO-BOX-SubFam:ADD-LAST('Todos').
    COMBO-BOX-SubFam:SCREEN-VALUE = 'Todos'.
    IF SELF:SCREEN-VALUE <> 'Todos' THEN DO:
        FOR EACH DimSubLinea NO-LOCK WHERE DimSubLinea.codfam = ENTRY(1, SELF:SCREEN-VALUE, ' - '):
            COMBO-BOX-SubFam:ADD-LAST(DimSubLinea.subfam + ' - '+ DimSubLinea.NomSubFam).
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli wWin
ON LEAVE OF FILL-IN-CodCli IN FRAME fMain /* Cliente */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND DimCliente WHERE DimCliente.codcli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE DimCliente THEN DO:
      MESSAGE 'Cliente no registrado' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  FILL-IN-NomCli:SCREEN-VALUE = DimCliente.nomcli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli wWin
ON LEFT-MOUSE-DBLCLICK OF FILL-IN-CodCli IN FRAME fMain /* Cliente */
OR F8 OF FILL-IN-CodCli
DO:
    RUN lkup/c-client ('Clientes').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodMat wWin
ON LEAVE OF FILL-IN-CodMat IN FRAME fMain /* Codigo */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND DimProducto WHERE DimProducto.codmat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE DimProducto THEN DO:
      MESSAGE 'Articulo Inválido' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  FILL-IN-DesMat:SCREEN-VALUE = DimProducto.desmat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodPro wWin
ON LEAVE OF FILL-IN-CodPro IN FRAME fMain /* Proveedor */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND DimProveedor WHERE DimProveedor.codpro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE DimProveedor THEN DO:
        MESSAGE 'Proveedor no registrado' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    FILL-IN-NomPro:SCREEN-VALUE = DimProveedor.nompro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodPro wWin
ON LEFT-MOUSE-DBLCLICK OF FILL-IN-CodPro IN FRAME fMain /* Proveedor */
DO:
    RUN lkup/c-provee ('Proveedores').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodVen wWin
ON LEAVE OF FILL-IN-CodVen IN FRAME fMain
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND DimVendedor WHERE DimVendedor.codven = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE DimVendedor THEN DO:
        MESSAGE 'Vendedor no registrado' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    FILL-IN-NomVen:SCREEN-VALUE = DimVendedor.nomven.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-CodCli wWin
ON VALUE-CHANGED OF TOGGLE-CodCli IN FRAME fMain /* Cliente */
DO:
    FILL-IN-CodCli:SENSITIVE = NOT FILL-IN-CodCli:SENSITIVE.
    TOGGLE-Resumen-Depto:SENSITIVE = NOT TOGGLE-Resumen-Depto:SENSITIVE.
    IF INPUT {&self-name} = YES 
        THEN ASSIGN
                BUTTON-5:SENSITIVE = YES.
        ELSE ASSIGN     
                BUTTON-5:SENSITIVE = NO
                FILL-IN-file:SCREEN-VALUE = ''.
    APPLY 'VALUE-CHANGED' TO TOGGLE-Resumen-Linea.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-CodDiv wWin
ON VALUE-CHANGED OF TOGGLE-CodDiv IN FRAME fMain /* Division Origen */
DO:
  SELECT-CodDiv:SENSITIVE = NOT SELECT-CodDiv:SENSITIVE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-CodMat wWin
ON VALUE-CHANGED OF TOGGLE-CodMat IN FRAME fMain /* Artículo */
DO:
    COMBO-BOX-CodFam:SENSITIVE = NOT COMBO-BOX-CodFam:SENSITIVE.
    COMBO-BOX-SubFam:SENSITIVE = NOT COMBO-BOX-SubFam:SENSITIVE.
    FILL-IN-CodPro:SENSITIVE = NOT FILL-IN-CodPro:SENSITIVE.
    FILL-IN-CodMat:SENSITIVE = NOT FILL-IN-CodMat:SENSITIVE.
    TOGGLE-Resumen-Linea:SENSITIVE = NOT TOGGLE-Resumen-Linea:SENSITIVE.
    TOGGLE-Resumen-Solo-Linea:SENSITIVE = NOT TOGGLE-Resumen-Solo-Linea:SENSITIVE.
    TOGGLE-Resumen-Marca:SENSITIVE = NOT TOGGLE-Resumen-Marca:SENSITIVE.
    APPLY 'VALUE-CHANGED' TO TOGGLE-Resumen-Linea.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-CodVen wWin
ON VALUE-CHANGED OF TOGGLE-CodVen IN FRAME fMain /* Vendedor */
DO:
    FILL-IN-CodVen:SENSITIVE = NOT FILL-IN-CodVen:SENSITIVE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-Resumen-Linea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-Resumen-Linea wWin
ON VALUE-CHANGED OF TOGGLE-Resumen-Linea IN FRAME fMain /* Resumido por Linea y Sub-Linea */
DO:
    ASSIGN
        TOGGLE-CodCli TOGGLE-CodMat TOGGLE-Resumen-Linea TOGGLE-Resumen-Marca.
    ASSIGN {&self-name}.
    IF {&self-name} = YES THEN TOGGLE-Resumen-Solo-Linea:SCREEN-VALUE = "NO".
    IF ( TOGGLE-CodCli = YES AND TOGGLE-CodMat = YES 
         AND ( TOGGLE-Resumen-Linea = YES OR TOGGLE-Resumen-Marca = YES ) )
    THEN ASSIGN 
              FILL-IN-CodPro:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''
              FILL-IN-CodPro:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    ELSE ASSIGN
              FILL-IN-CodPro:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

    IF TOGGLE-Resumen-Linea = YES OR TOGGLE-Resumen-Marca = YES 
        THEN ASSIGN
                  FILL-IN-file-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''
                  BUTTON-6:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                  FILL-IN-CodMat:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                  FILL-IN-CodMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
    ELSE ASSIGN
              BUTTON-6:SENSITIVE IN FRAME {&FRAME-NAME} = YES
              FILL-IN-CodMat:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-Resumen-Marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-Resumen-Marca wWin
ON VALUE-CHANGED OF TOGGLE-Resumen-Marca IN FRAME fMain /* Resumido por Marca */
DO:
    APPLY 'VALUE-CHANGED' TO TOGGLE-Resumen-Linea.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-Resumen-solo-linea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-Resumen-solo-linea wWin
ON VALUE-CHANGED OF TOGGLE-Resumen-solo-linea IN FRAME fMain /* Resumido solo por Linea */
DO:
  ASSIGN {&self-name}.
  IF {&self-name} = YES THEN TOGGLE-Resumen-Linea:SCREEN-VALUE = "NO".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Lista-Articulos wWin 
PROCEDURE Carga-Lista-Articulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-datos.
    EMPTY TEMP-TABLE tt-articulo.

    /* Carga de Excel */
    IF SEARCH(FILL-IN-file-2) <> ? THEN DO:
        INPUT FROM VALUE(FILL-IN-file-2).
        REPEAT:
            CREATE tt-datos.
            IMPORT tt-codigo.
        END.
        INPUT CLOSE.
    END.
    FOR EACH tt-datos WHERE tt-datos.tt-codigo = '':
        DELETE tt-datos.
    END.
    FIND FIRST tt-datos NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-datos THEN DO:
        CREATE tt-datos.        
        ASSIGN tt-codigo = FILL-IN-CodMat.
    END.

    /*Carga Tabla Articulos*/
    FOR EACH tt-datos:
        FIND DimProducto WHERE DimProducto.codmat = tt-datos.tt-codigo
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE DimProducto THEN NEXT.
        FIND FIRST tt-articulo WHERE tt-articulo.tt-codmat = tt-codigo 
            NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-articulo THEN  DO:
            CREATE tt-articulo.
            ASSIGN tt-articulo.tt-codmat = tt-datos.tt-codigo.
        END.
    END.

    x-CodMat = ''.
    FOR EACH tt-articulo:
        IF x-CodMat = '' THEN x-CodMat = tt-articulo.tt-codmat.
        ELSE x-CodMat = x-CodMat + ',' + tt-articulo.tt-codmat.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Lista-Clientes wWin 
PROCEDURE Carga-Lista-Clientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR x-linea LIKE DimCliente.codcli.

    EMPTY TEMP-TABLE tt-cliente.

    /* Carga de Excel */
    IF SEARCH(FILL-IN-file) <> ? THEN DO:
        INPUT FROM VALUE(FILL-IN-file).
        REPEAT:
            IMPORT UNFORMATTED x-linea.
            FIND tt-cliente WHERE tt-cliente.tt-codcli = x-linea NO-ERROR.
            IF NOT AVAILABLE tt-cliente THEN CREATE tt-cliente.
            tt-cliente.tt-codcli = x-linea.
        END.
        INPUT CLOSE.
    END.
    
    FOR EACH tt-cliente WHERE tt-cliente.tt-codcli = '':
        DELETE tt-cliente.
    END.

    FIND FIRST tt-cliente NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-cliente THEN DO:
        CREATE tt-cliente.        
        ASSIGN tt-codcli = fill-in-codcli.
    END.

    FOR EACH tt-cliente:
        FIND DimCliente WHERE DimCliente.codcli = tt-cliente.tt-codcli
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE DimCliente THEN DELETE tt-cliente.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal wWin 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR Control-Resumen AS LOG INIT NO NO-UNDO.
DEF VAR k AS INT NO-UNDO.

EMPTY TEMP-TABLE Detalle.

/* INFORMACION RESUMIDA */
ASSIGN
    x-CodDiv = ''
    x-DivDes = ''
    x-CodCli = ''
    x-CodPro = ''
    x-CodVen = ''
    x-CodFam = ''
    x-SubFam = ''
    x-CodMat = ''
    x-CuentaReg = 0
    x-MuestraReg = 1000.     /* cada 1000 registros */

/*IF TOGGLE-CodDiv AND NOT SELECT-CodDiv BEGINS 'Todos' THEN x-CodDiv = ENTRY(1, SELECT-CodDiv, ' - ').*/
IF TOGGLE-CodCli THEN x-CodCli = FILL-IN-CodCli.
IF TOGGLE-CodMat THEN x-CodMat = FILL-IN-CodMat.
IF TOGGLE-CodMat AND NOT COMBO-BOX-CodFam BEGINS 'Todos' THEN x-CodFam = ENTRY(1, COMBO-BOX-CodFam, ' - ').
IF TOGGLE-CodMat AND NOT COMBO-BOX-SubFam BEGINS 'Todos' THEN x-SubFam = ENTRY(1, COMBO-BOX-SubFam, ' - ').
IF TOGGLE-CodMat THEN x-CodPro = FILL-IN-CodPro.
IF TOGGLE-CodVen THEN x-CodVen = FILL-IN-CodVen.

/* Barremos por cada división */
DEF VAR xListaDivisiones AS CHAR.

CASE TRUE:
    WHEN TOGGLE-CodDiv = NO THEN xListaDivisiones = cDivisiones.
    WHEN INDEX(SELECT-CodDiv, 'Todos') > 0 THEN xListaDivisiones = cDivisiones.
    OTHERWISE DO WITH FRAME {&FRAME-NAME}:
        DO k = 1 TO NUM-ENTRIES(SELECT-CodDiv,'|'):
            xListaDivisiones = xListaDivisiones + (IF TRUE <> (xListaDivisiones > '') THEN '' ELSE ',') +
                ENTRY(k, SELECT-CodDiv, '|').
        END.
    END.
        
END CASE.
/* IF SELECT-CodDiv = 'Todos' OR TOGGLE-CodDiv = NO THEN DO:                            */
/*     DO k = 2 TO NUM-ENTRIES(cListaDivisiones):                                       */
/*         IF xListaDivisiones = '' THEN xListaDivisiones = ENTRY(k, cListaDivisiones). */
/*         ELSE xListaDivisiones = xListaDivisiones + ',' + ENTRY(k, cListaDivisiones). */
/*     END.                                                                             */
/* END.                                                                                 */
/* ELSE xListaDivisiones = SELECT-CodDiv.                                               */

RUN Carga-Lista-Articulos.
RUN Carga-Lista-Clientes.

/*MESSAGE xListaDivisiones.*/

DO k = 1 TO NUM-ENTRIES(xListaDivisiones):
    /*x-CodDiv = ENTRY(1, ENTRY(k, xListaDivisiones), ' - ').*/
    x-CodDiv = ENTRY(k,xListaDivisiones).
    Control-Resumen = NO.
    /* FILTROS */
    IF TOGGLE-NoVentas = NO AND x-CodDiv = '99999' THEN NEXT.
    /* Por División y/o Vendedor */
    IF (TOGGLE-CodDiv = YES OR TOGGLE-CodVen = YES) AND ( TOGGLE-CodCli = NO AND TOGGLE-CodMat = NO)
        THEN DO:
        /*MESSAGE 'uno'. RETURN.*/
        RUN Resumen-por-division.
        Control-Resumen = YES.
    END.
    /* Por Clientes */
    IF TOGGLE-CodCli = YES AND TOGGLE-CodMat = NO AND TOGGLE-CodVen = NO
        THEN DO:
        /*MESSAGE 'dos'. RETURN.*/
        RUN Resumen-por-cliente.
        Control-Resumen = YES.
    END.
    /* Por Clientes y Productos Resumidos por Linea y/o Sublinea */
    IF TOGGLE-CodCli = YES AND TOGGLE-CodMat = YES AND TOGGLE-CodVen = NO
        AND (TOGGLE-Resumen-Linea = YES OR TOGGLE-Resumen-Marca = YES
             OR TOGGLE-Resumen-solo-linea = YES)
        THEN DO:
        /*MESSAGE 'tres'. RETURN.*/
        RUN Resumen-por-climat.
        Control-Resumen = YES.
    END.
    /* Por Clientes y Vendedor */
    IF TOGGLE-CodCli = YES AND TOGGLE-CodMat = NO AND TOGGLE-CodVen = YES
        THEN DO:
        /*MESSAGE 'cuatro'. RETURN.*/
        RUN Resumen-por-vendcli.
        Control-Resumen = YES.
    END.
    /* Por Producto */
    IF TOGGLE-CodCli = NO AND TOGGLE-CodMat = YES AND TOGGLE-CodVen = NO
        AND ( TOGGLE-Resumen-Linea = NO AND TOGGLE-Resumen-Marca = NO
              AND TOGGLE-Resumen-solo-linea = NO )
        THEN DO:
        /*MESSAGE 'Resumen por producto'.*/
        RUN Resumen-por-producto.
        Control-Resumen = YES.
    END.
    IF TOGGLE-CodCli = NO AND TOGGLE-CodMat = YES 
        AND (TOGGLE-Resumen-Linea = YES OR TOGGLE-Resumen-Marca = YES 
             OR TOGGLE-Resumen-solo-linea = YES)
        THEN DO:

        /*MESSAGE x-CodDiv.*/

        /*MESSAGE 'seis'. RETURN.*/
        RUN Resumen-por-linea.
        Control-Resumen = YES.
    END.

    IF Control-Resumen = NO THEN DO:
        /*MESSAGE 'siete'. RETURN.*/
        ASSIGN
            iContador = 1       /* Valor por defecto */
            x-CodCli = ''.
        FOR EACH tt-cliente NO-LOCK:
            iContador = iContador + 1.
            IF x-CodCli = '' THEN x-CodCli = tt-cliente.tt-codcli.
            ELSE x-CodCli = x-CodCli + ',' + tt-cliente.tt-codcli.
            IF iContador = 1000 THEN DO:
                {est/resumengeneral.i}
                ASSIGN
                    iContador = 0
                    x-CodCli = ''.
            END.
        END.
        IF iContador > 0 THEN DO:
            {est/resumengeneral.i}
        END.
    END.
END.

/* Revisamos si tiene configurado algunas lineas */
FIND FIRST EstadUserLinea WHERE EstadUserLinea.aplic-id = s-aplic-id
    AND EstadUserLinea.USER-ID = s-user-id
    NO-LOCK NO-ERROR.
IF AVAILABLE EstadUserLinea THEN DO:
    FOR EACH Detalle WHERE Detalle.Linea <> "":
        FIND FIRST EstadUserLinea WHERE EstadUserLinea.aplic-id = s-aplic-id
            AND EstadUserLinea.USER-ID = s-user-id
            AND EstadUserLinea.CodFam = ENTRY(1, Detalle.Linea, ' ')
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE EstadUserLinea THEN DO:
            ASSIGN
                Detalle.CtoxMesMe = 0
                Detalle.CtoxMesMn = 0
                Detalle.ProxMesMe = 0
                Detalle.ProxMesMn = 0.
        END.
    END.
END.
IF s-Familia010 = YES THEN RUN Resumen-por-familia.

/* DEFINIMOS CAMPOS A IMPRIMIR */
ASSIGN
    lOptions = "FieldList:".
IF RADIO-SET-Tipo = 2 THEN DO:
    ASSIGN
        lOptions = lOptions + 'Campania,Periodo,Nromes'.
END.
IF RADIO-SET-Tipo = 3 THEN DO:
    ASSIGN
        lOptions = lOptions + 'Campania,Dia'.
END.
IF TOGGLE-CodDiv = YES THEN DO:
     ASSIGN
         lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                    'Division,Destino,CanalVenta'.
END.
IF TOGGLE-CodCli = YES THEN DO:
    IF TOGGLE-Resumen-Depto = NO THEN DO:
        ASSIGN
            lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                        'Cliente,CliAcc,CliUnico'.
    END.
    ASSIGN
        lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                    'Canal,Giro,Departamento,Provincia,Distrito,Zona'.
END.
IF TOGGLE-CodMat = YES THEN DO:
    IF (TOGGLE-Resumen-Linea = NO AND TOGGLE-Resumen-Marca = NO AND TOGGLE-Resumen-Solo-Linea = NO) THEN DO:
         ASSIGN
             lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                        'Producto,Ranking,Categoria,rnkgutlx,clsfutlx,rnkgmayo,clsfmayo,Linea,Sublinea,Marca,Unidad,SubTipo,CodAsoc' +
                        ',CodigoPadre,FactorPadre,NCantidad'.
    END.
    ELSE DO:
         IF TOGGLE-Resumen-Linea = YES THEN DO:
             ASSIGN
                 lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                            'Linea,Sublinea'.
         END.
         IF TOGGLE-Resumen-Solo-Linea = YES THEN DO:
             ASSIGN
                 lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                            'Linea'.
         END.
         IF TOGGLE-Resumen-Marca = YES THEN DO:
             ASSIGN
                 lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                            'Marca'.
         END.
    END.
    ASSIGN
         lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                    'Licencia,Licenciatario,Proveedor'.
END.
IF TOGGLE-CodVen = YES THEN DO:
     ASSIGN
         lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                    'Vendedor'.
END.
ASSIGN
     lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                'Tipo,Delivery,ListaBase'.
ASSIGN
    pOptions = pOptions + CHR(1) + lOptions.
ASSIGN
    pOptions = pOptions + ',CanxMes,VtaxMesMe,VtaxMesMn'.
IF s-ConCostos = YES THEN DO:
    pOptions = pOptions + ',CtoxMesMe,CtoxMesMn,ProxMesMe,ProxMesMn,ProxMesMe2,ProxMesMn2'.
END.
/* *************************** */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-Mensaje TOGGLE-CodDiv SELECT-CodDiv TOGGLE-CodCli 
          FILL-IN-CodCli FILL-IN-NomCli FILL-IN-file TOGGLE-Resumen-Depto 
          TOGGLE-CodMat COMBO-BOX-CodFam TOGGLE-Resumen-Linea 
          TOGGLE-Resumen-solo-linea COMBO-BOX-SubFam TOGGLE-Resumen-Marca 
          FILL-IN-CodMat FILL-IN-DesMat FILL-IN-file-2 FILL-IN-CodPro 
          FILL-IN-NomPro TOGGLE-CodVen FILL-IN-CodVen FILL-IN-NomVen 
          RADIO-SET-Tipo DesdeF HastaF TOGGLE-NoVentas rRanking 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE RECT-1 RECT-2 RECT-3 RECT-4 RECT-5 BUTTON-1 BtnDone TOGGLE-CodDiv 
         TOGGLE-CodCli TOGGLE-CodMat TOGGLE-CodVen RADIO-SET-Tipo BUTTON-7 
         DesdeF HastaF TOGGLE-NoVentas rRanking 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  SELECT-CodDiv:DELIMITER IN FRAME {&FRAME-NAME} = '|'.
  ASSIGN
      DesdeF = TODAY - DAY(TODAY) + 1
      HastaF = TODAY
      /*cListaDivisiones = 'Todos,Todos'*/
      cDivisiones = ''.
  /* Bucamos si tiene divisiones registradas */
  FIND FIRST estavtas.EstadUserDiv WHERE estavtas.EstadUserDiv.user-id = s-user-id
      AND estavtas.EstadUserDiv.aplic-id = s-aplic-id
      NO-LOCK NO-ERROR.

  IF AVAILABLE EstadUserDiv AND s-user-id <> 'ADMIN' THEN DO:
      FOR EACH EstadUserDiv NO-LOCK WHERE EstadUserDiv.user-id = s-user-id
          AND EstadUserDiv.aplic-id = s-aplic-id,
          FIRST DimDivision OF EstadUserDiv NO-LOCK:
          cListaDivisiones = cListaDivisiones  + 
                            (IF TRUE <> (cListaDivisiones > '') THEN '' ELSE '|') + 
              (DimDivision.coddiv + ' - ' + DimDivision.DesDiv) + '|' + DimDivision.coddiv.
          cDivisiones = cDivisiones + (IF TRUE <> (cDivisiones > '') THEN '' ELSE ',') + DimDivision.coddiv.
      END.
  END.
  ELSE DO:
      FOR EACH DimDivision NO-LOCK:
        cListaDivisiones = cListaDivisiones  + 
                            (IF TRUE <> (cListaDivisiones > '') THEN '' ELSE '|') +         
                    (DimDivision.coddiv + ' - ' + DimDivision.DesDiv) + '|' + DimDivision.coddiv.
        cDivisiones = cDivisiones + (IF TRUE <> (cDivisiones > '') THEN '' ELSE ',') + DimDivision.coddiv.
      END.
      
  END.


  cListaDivisiones = 'Todos|Todos|' + cListaDivisiones.

  SELECT-CodDiv:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = cListaDivisiones .
  SELECT-CodDiv = SELECT-CodDiv:ENTRY(1) IN FRAME {&FRAME-NAME}.

  FOR EACH DimLinea NO-LOCK:
      COMBO-BOX-CodFam:ADD-LAST(DimLinea.codfam + ' - ' + DimLinea.nomfam) IN FRAME {&FRAME-NAME}.
  END.

  IF MONTH(TODAY) = 4 OR MONTH(TODAY) = 5 OR MONTH(TODAY) = 6 OR
      MONTH(TODAY) = 7 OR MONTH(TODAY) = 8 OR MONTH(TODAY) = 9 OR MONTH(TODAY) = 10 THEN DO:
        /* No campaña */
        rRanking = 2.
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resumen-por-cliente wWin 
PROCEDURE Resumen-por-cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN
    iContador = 1       /* Valor por defecto */
    x-CodCli = ''.
FOR EACH tt-cliente NO-LOCK:
    iContador = iContador + 1.
    IF x-CodCli = '' THEN x-CodCli = tt-cliente.tt-codcli.
    ELSE x-CodCli = x-CodCli + ',' + tt-cliente.tt-codcli.
    IF iContador = 1000 THEN DO:
        {est/resumenxcliente.i}
        ASSIGN
            iContador = 0
            x-CodCli = ''.
    END.
END.
IF iContador > 0 THEN DO:
    {est/resumenxcliente.i}
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resumen-por-climat wWin 
PROCEDURE Resumen-por-climat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN
    iContador = 1       /* Valor por defecto */
    x-CodCli = ''.
FOR EACH tt-cliente NO-LOCK:
    iContador = iContador + 1.
    IF x-CodCli = '' THEN x-CodCli = tt-cliente.tt-codcli.
    ELSE x-CodCli = x-CodCli + ',' + tt-cliente.tt-codcli.
    IF iContador = 1000 THEN DO:
        {est/resumenxclientelinea.i}
        ASSIGN
            iContador = 0
            x-CodCli = ''.
    END.
END.
IF iContador > 0 THEN DO:
    {est/resumenxclientelinea.i}
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resumen-por-division wWin 
PROCEDURE Resumen-por-division :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH VentasxVendedor NO-LOCK WHERE VentasxVendedor.DateKey >= DesdeF
    AND VentasxVendedor.DateKey <= HastaF
    AND (x-CodDiv = '' OR VentasxVendedor.coddiv = x-CodDiv)
    AND VentasxVendedor.codven BEGINS x-CodVen,
    /*FIRST DimVendedor OF VentasxVendedor NO-LOCK,*/
    FIRST DimFecha OF VentasxVendedor NO-LOCK:
    IF x-CuentaReg = 0 OR ( x-CuentaReg MODULO x-MuestraReg ) = 0 THEN
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** TABLA POR DIVISION ' + 
        ' Fecha ' + STRING (DAY(DimFecha.DateKey), '99') +
        ' ' + DimFecha.CalendarMonthLabel + ' ' + DimFecha.CalendarYearLabel +
        ' DIVISION ' + VentasxVendedor.coddiv + ' **'.
    x-CuentaReg = x-CuentaReg + 1.
    /* ARMAMOS LA LLAVE */
    ASSIGN
        x-Llave = ''
        cCampania = ''
        cPeriodo = 0
        cNroMes = 0
        cDia = ?
        cDivision = ''
        cDestino  = ''
        cCanalVenta = ''
        cProducto = ''
        cLinea = ''
        cSublinea = ''
        cMarca = ''
        cUnidad = ''
        cLicencia = ''
        cProveedor = ''
        cCliente = ''
        cCanal = ''
        cTarjeta = ''
        cDepartamento = ''
        cProvincia = ''
        cDistrito = ''
        cZona = ''
        cClasificacion = ''
        cTipo = ''
        cDelivery = ''
        cVendedor = ''
        cListaBase = ''.
    /* LLAVE INICIAL */
    IF RADIO-SET-Tipo = 2 THEN DO:
        IF x-Llave = '' THEN x-Llave = DimFecha.Campania.
        ELSE x-Llave = x-Llave + DimFecha.Campania.
        x-Llave = x-Llave + '|'.
        x-Llave = x-Llave + STRING(YEAR(DimFecha.DateKey), '9999').
        x-Llave = x-Llave + '|'.
        x-Llave = x-Llave + STRING(MONTH(DimFecha.DateKey), '99').      
        x-Llave = x-LLave + '|'.
        ASSIGN
            cCampania = DimFecha.Campania
            cPeriodo  = YEAR(DimFecha.DateKey)
            cNroMes   = MONTH(DimFecha.DateKey).
    END.
    IF RADIO-SET-Tipo = 3 THEN DO:
        IF x-Llave = '' THEN x-Llave = DimFecha.Campania.
        ELSE x-Llave = x-Llave + DimFecha.Campania.
        x-Llave = x-Llave + '|'.
        x-Llave = x-Llave + DimFecha.DateDescription.
        x-Llave = x-LLave + '|'.
        ASSIGN
            cCampania = DimFecha.Campania
            cDia      = DimFecha.DateKey.
    END.
    IF TOGGLE-CodDiv = YES THEN DO:
        FIND FIRST DimDivision OF VentasxVendedor NO-LOCK.
        IF x-Llave = '' THEN x-Llave = VentasxVendedor.coddiv + '|'.
        ELSE x-Llave = x-LLave + VentasxVendedor.coddiv + '|'.
        x-Llave = x-Llave + VentasxVendedor.divdes + '|'.
        x-Llave = x-Llave + DimDivision.CanalVenta + '|'.
        x-Llave = x-Llave + VentasxVendedor.ListaBase + '|'.
        ASSIGN
            cDivision   = VentasxVendedor.coddiv + ' ' + DimDivision.DesDiv
            cCanalVenta = DimDivision.CanalVenta + ' ' + DimDivision.NomCanalVenta
            cListaBase  = VentasxVendedor.ListaBase.
        FIND FIRST DimDivision WHERE DimDivision.coddiv = VentasxVendedor.divdes NO-LOCK.
        ASSIGN
            cDestino = VentasxVendedor.divdes + ' ' + DimDivision.DesDiv
            x-Llave = x-LLave + VentasxVendedor.divdes + '|'.
        FIND FIRST DimDivision WHERE DimDivision.coddiv = VentasxVendedor.ListaBase NO-LOCK NO-ERROR.
        IF AVAILABLE DimDivision THEN cListaBase  = DimDivision.CodDiv + ' ' + DimDivision.DesDiv.
    END.
    IF TOGGLE-CodVen = YES THEN DO:
        FIND FIRST DimVendedor OF VentasxVendedor NO-LOCK NO-ERROR.
        IF x-Llave = '' THEN x-Llave = VentasxVendedor.codven + '|'.
        ELSE x-Llave = x-Llave + VentasxVendedor.codven + '|'.
        ASSIGN
            cVendedor = VentasxVendedor.codven + ' ' + (IF AVAILABLE DimVendedor THEN DimVendedor.NomVen ELSE '').
    END.
    ASSIGN
        x-Llave = x-Llave + VentasxVendedor.Tipo + '|'
        cTipo   = VentasxVendedor.Tipo
        cDelivery = VentasxVendedor.Delivery.
        
    /* ******************************************** */
    FIND Detalle WHERE Detalle.llave = x-Llave NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        CREATE Detalle.
        Detalle.llave = x-Llave.
    END.
    ASSIGN
        Detalle.Campania = cCampania
        Detalle.Periodo = cPeriodo
        Detalle.NroMes = cNroMes
        Detalle.Dia = cDia
        Detalle.Division = cDivision
        Detalle.Destino = cDestino
        Detalle.CanalVenta = cCanalVenta
        Detalle.Producto = cProducto
        Detalle.Linea = cLinea
        Detalle.Sublinea = cSublinea
        Detalle.Marca = cMarca
        Detalle.Unidad = cUnidad
        Detalle.Licencia = cLicencia
        Detalle.Proveedor = cProveedor
        Detalle.Cliente = cCliente
        Detalle.Canal = cCanal
        Detalle.Tarjeta = cTarjeta
        Detalle.Departamento = cDepartamento
        Detalle.Provincia = cProvincia
        Detalle.Distrito = cDistrito
        Detalle.Zona = cZona 
        Detalle.Clasificacion = cClasificacion
        Detalle.Tipo = cTipo
        Detalle.Vendedor = cVendedor
        Detalle.Delivery = cDelivery
        Detalle.ListaBase = cListaBase
        Detalle.VtaxMesMe = Detalle.VtaxMesMe + VentasxVendedor.ImpExtCIGV
        Detalle.VtaxMesMn = Detalle.VtaxMesMn + VentasxVendedor.ImpNacCIGV
        Detalle.CtoxMesMe = Detalle.CtoxMesMe + VentasxVendedor.CostoExtCIGV
        Detalle.CtoxMesMn = Detalle.CtoxMesMn + VentasxVendedor.CostoNacCIGV
        Detalle.ProxMesMe = Detalle.ProxMesMe + VentasxVendedor.PromExtCIGV
        Detalle.ProxMesMn = Detalle.ProxMesMn + VentasxVendedor.PromNacCIGV.
    ASSIGN
        Detalle.ProxMesMe2 = Detalle.ProxMesMe2 + VentasxVendedor.PromExtSIGV
        Detalle.ProxMesMn2 = Detalle.ProxMesMn2 + VentasxVendedor.PromNacSIGV.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resumen-por-familia wWin 
PROCEDURE Resumen-por-familia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Llave AS CHAR NO-UNDO.

EMPTY TEMP-TABLE T-Detalle.
FOR EACH Detalle WHERE Detalle.Linea BEGINS '010':
    FIND FIRST T-Detalle WHERE 
        T-Detalle.Campania = Detalle.Campania AND
        T-Detalle.Periodo = Detalle.Periodo AND
        T-Detalle.NroMes = Detalle.NroMes AND
        T-Detalle.Dia = Detalle.Dia AND
        T-Detalle.Division = Detalle.Division AND
        T-Detalle.Destino = Detalle.Destino AND
        T-Detalle.CanalVenta = Detalle.CanalVenta AND
        T-Detalle.Linea = Detalle.Linea AND
        T-Detalle.SubLinea = Detalle.SubLinea AND
        T-Detalle.Marca = Detalle.Marca AND
        T-Detalle.Licencia = Detalle.Licencia AND
        T-Detalle.Proveedor = Detalle.Proveedor AND
        T-Detalle.Cliente = Detalle.Cliente AND
        T-Detalle.Canal = Detalle.Canal AND
        T-Detalle.Tarjeta = Detalle.Tarjeta AND
        T-Detalle.Departamento = Detalle.Departamento AND
        T-Detalle.Provincia = Detalle.Provincia AND
        T-Detalle.Distrito = Detalle.Distrito AND
        T-Detalle.Zona = Detalle.Zona AND
        T-Detalle.Clasificacion = Detalle.Clasificacion AND
        T-Detalle.Tipo = Detalle.Tipo AND
        T-Detalle.Vendedor = Detalle.Vendedor AND
        T-Detalle.SubTipo = Detalle.SubTipo /*AND
        T-Detalle.CodAsoc = Detalle.CodAsoc*/
        NO-ERROR.
    IF NOT AVAILABLE T-Detalle THEN CREATE T-Detalle.
    BUFFER-COPY Detalle
        EXCEPT Detalle.CodAsoc
        TO T-Detalle
        ASSIGN
            T-Detalle.Producto = "999998 RESUMIDO FAMILIA 010"
            T-Detalle.Unidad   = "UNI"
            T-Detalle.VtaxMesMe = T-Detalle.VtaxMesMe + Detalle.VtaxMesMe
            T-Detalle.VtaxMesMn = T-Detalle.VtaxMesMn + Detalle.VtaxMesMn 
            T-Detalle.CtoxMesMe = T-Detalle.CtoxMesMe + Detalle.CtoxMesMe 
            T-Detalle.CtoxMesMn = T-Detalle.CtoxMesMn + Detalle.CtoxMesMn 
            T-Detalle.ProxMesMe = T-Detalle.ProxMesMe + Detalle.ProxMesMe 
            T-Detalle.proxMesMn = T-Detalle.proxMesMn + Detalle.proxMesMn.
    DELETE Detalle.
END.

FOR EACH T-Detalle NO-LOCK:
    CREATE Detalle.
    BUFFER-COPY T-Detalle TO Detalle.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resumen-por-linea wWin 
PROCEDURE Resumen-por-linea :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH VentasxLinea NO-LOCK WHERE VentasxLinea.DateKey >= DesdeF
    AND VentasxLinea.DateKey <= HastaF
    AND VentasxLinea.coddiv = x-CodDiv,
/*     FIRST DimLinea OF VentasxLinea NO-LOCK,    */
/*     FIRST DimSubLinea OF VentasxLinea NO-LOCK, */
    FIRST DimFecha OF VentasxLinea NO-LOCK:

    IF NOT (x-CodFam = '' OR VentasxLinea.codfam = x-CodFam) THEN NEXT.
    IF NOT (x-SubFam = '' OR VentasxLinea.subfam = x-SubFam) THEN NEXT.
    IF NOT (x-CodPro = '' OR VentasxLinea.codpro = x-Codpro) THEN NEXT.

    IF x-CuentaReg = 0 OR ( x-CuentaReg MODULO x-MuestraReg ) = 0 THEN
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** TABLA RESUMEN POR PRODUCTO ' + 
        ' Fecha ' + STRING (DAY(DimFecha.DateKey), '99') +
        ' ' + DimFecha.CalendarMonthLabel + ' ' + STRING (DimFecha.CalendarYear, '9999') +
        ' DIVISION ' + VentasxLinea.coddiv + ' LINEA ' + VentasxLinea.codfam + ' **'.
    x-CuentaReg = x-CuentaReg + 1.

    /* ARMAMOS LA LLAVE */
    ASSIGN
        x-Llave = ''
        cCampania = ''
        cPeriodo = 0
        cNroMes = 0
        cDia = ?
        cDivision = ''
        cDestino = ''
        cCanalVenta = ''
        cProducto = ''
        cRanking = 0
        cCategoria = ''
        cLinea = ''
        cSublinea = ''
        cMarca = ''
        cUnidad = ''
        cLicencia = ''
        cLicenciatario = ''
        cProveedor = ''
        cCliente = ''
        cCanal = ''
        cTarjeta = ''
        cDepartamento = ''
        cProvincia = ''
        cDistrito = ''
        cZona = ''
        cClasificacion = ''
        cTipo = ''
        cVendedor = ''
        cDelivery = ''
        cListaBase = ''.
    /* LLAVE INICIAL */
    IF RADIO-SET-Tipo = 2 THEN DO:
        IF x-Llave = '' THEN x-Llave = DimFecha.Campania.
        ELSE x-Llave = x-Llave + DimFecha.Campania.
        x-Llave = x-Llave + '|'.
        x-Llave = x-Llave + STRING(YEAR(DimFecha.DateKey), '9999').
        x-Llave = x-Llave + '|'.
        x-Llave = x-Llave + STRING(MONTH(DimFecha.DateKey), '99').      
        x-Llave = x-LLave + '|'.
        ASSIGN
            cCampania = DimFecha.Campania
            cPeriodo  = YEAR(DimFecha.DateKey)
            cNroMes   = MONTH(DimFecha.DateKey).
    END.
    IF RADIO-SET-Tipo = 3 THEN DO:
        IF x-Llave = '' THEN x-Llave = DimFecha.Campania.
        ELSE x-Llave = x-Llave + DimFecha.Campania.
        x-Llave = x-Llave + '|'.
        x-Llave = x-Llave + DimFecha.DateDescription.
        x-Llave = x-LLave + '|'.
        ASSIGN
            cCampania = DimFecha.Campania
            cDia      = DimFecha.DateKey.
    END.
    IF TOGGLE-CodDiv = YES THEN DO:
        FIND FIRST DimDivision OF VentasxLinea NO-LOCK.
        IF x-Llave = '' THEN x-Llave = VentasxLinea.coddiv + '|'.
        ELSE x-Llave = x-LLave + VentasxLinea.coddiv + '|'.
        x-Llave = x-Llave + DimDivision.CanalVenta + '|'.
        ASSIGN
            cDivision = VentasxLinea.coddiv + ' ' + DimDivision.DesDiv
            cCanalVenta = DimDivision.CanalVenta + ' ' + DimDivision.NomCanalVenta.
        FIND FIRST DimDivision WHERE DimDivision.coddiv = VentasxLinea.divdes NO-LOCK.
        ASSIGN
            cDestino = VentasxLinea.divdes + ' ' + DimDivision.DesDiv
            x-Llave = x-LLave + VentasxLinea.divdes + '|'.
        ASSIGN
            cListaBase = VentasxLinea.ListaBase
            x-Llave = x-LLave + VentasxLinea.ListaBase + '|'.
        FIND FIRST DimDivision WHERE DimDivision.coddiv = VentasxLinea.ListaBase NO-LOCK NO-ERROR.
        IF AVAILABLE DimDivision THEN cListaBase  = VentasxLinea.ListaBase + ' ' + DimDivision.DesDiv.

    END.
    IF TOGGLE-Resumen-Linea = YES THEN DO:
        FIND FIRST DimLinea OF VentasxLinea NO-LOCK NO-ERROR.
        FIND FIRST DimSubLinea OF VentasxLinea NO-LOCK NO-ERROR.
        IF x-Llave = '' THEN x-Llave = VentasxLinea.codfam + '|'.
        ELSE x-Llave = x-Llave + VentasxLinea.codfam + '|'.
        x-Llave = x-Llave + VentasxLinea.subfam + '|'.
        ASSIGN
            cLinea = VentasxLinea.codfam + ' ' + (IF AVAILABLE DimLinea THEN DimLinea.NomFam ELSE "")
            cSublinea = VentasxLinea.subfam + ' ' + (IF AVAILABLE DimSubLinea THEN DimSubLinea.NomSubFam ELSE "").
    END.
    IF TOGGLE-Resumen-solo-linea = YES THEN DO:
        FIND FIRST DimLinea OF VentasxLinea NO-LOCK NO-ERROR.
        IF x-Llave = '' THEN x-Llave = VentasxLinea.codfam + '|'.
        ELSE x-Llave = x-Llave + VentasxLinea.codfam + '|'.
        ASSIGN
            cLinea = VentasxLinea.codfam + ' ' + (IF AVAILABLE DimLinea THEN DimLinea.NomFam ELSE "").
    END.
    IF TOGGLE-Resumen-Marca = YES THEN DO:
        IF x-Llave = '' THEN x-Llave = VentasxLinea.desmar + '|'.
        ELSE x-Llave = x-Llave + VentasxLinea.desmar + '|'.
        ASSIGN
            cMarca = VentasxLinea.desmar.
    END.
    x-Llave = x-Llave + VentasxLinea.licencia + '|'.
    x-Llave = x-Llave + VentasxLinea.codpro + '|'.
    FIND DimLicencia OF VentasxLinea NO-LOCK NO-ERROR.
    FIND DimProveedor OF VentasxLinea NO-LOCK NO-ERROR.
    ASSIGN
        cLicencia = VentasxLinea.licencia + (IF AVAILABLE DimLicencia THEN ' ' + DimLicencia.Descripcion ELSE '')
        cProveedor = VentasxLinea.codpro + (IF AVAILABLE DimProveedor THEN ' ' + DimProveedor.NomPro ELSE '').
    IF AVAILABLE DimLicencia THEN DO:
        cLicenciatario = DimLicencia.Licenciatario.
        FIND DimLicenciatario OF DimLicencia NO-LOCK NO-ERROR.
        IF AVAILABLE DimLicenciatario THEN cLicenciatario = DimLicenciatario.Licenciatario + ' ' + DimLicenciatario.NomLicenciatario.
    END.
    /* ******************************************** */
   IF TOGGLE-CodVen = YES THEN DO:
       IF x-Llave = '' THEN x-Llave = VentasxLinea.codven + '|'.
       ELSE x-Llave = x-Llave + VentasxLinea.codven + '|'.
       FIND DimVendedor OF VentasxLinea NO-LOCK NO-ERROR.
       ASSIGN
           cVendedor = VentasxLinea.codven + (IF AVAILABLE DimVendedor THEN ' ' + DimVendedor.NomVen ELSE '').
   END.
   ASSIGN
       x-Llave = x-Llave + VentasxLinea.Tipo + '|'
       cTipo   = VentasxLinea.Tipo
       cDelivery = VentasxLinea.Delivery.
       
   /* ******************************************** */
   FIND Detalle WHERE Detalle.llave = x-Llave NO-ERROR.
   IF NOT AVAILABLE Detalle THEN DO:
       CREATE Detalle.
       Detalle.llave = x-Llave.
   END.
   /* RHC 09/06/2015 */
   IF s-ConCostos = YES THEN RUN rResxLin (OUTPUT x-CostoNacCIGV, OUTPUT x-CostoExtCIGV).
   /* ************** */
   ASSIGN
       Detalle.Campania = cCampania
       Detalle.Periodo = cPeriodo
       Detalle.NroMes = cNroMes
       Detalle.Dia = cDia
       Detalle.Division = cDivision
       Detalle.Destino = cDestino
       Detalle.CanalVenta = cCanalVenta
       Detalle.Producto = cProducto
       Detalle.Linea = cLinea
       Detalle.Sublinea = cSublinea
       Detalle.Marca = cMarca
       Detalle.Unidad = cUnidad
       Detalle.Licencia = cLicencia
       Detalle.Licenciatario = cLicenciatario
       Detalle.Proveedor = cProveedor
       Detalle.Cliente = cCliente
       Detalle.Canal = cCanal
       Detalle.Tarjeta = cTarjeta
       Detalle.Departamento = cDepartamento
       Detalle.Provincia = cProvincia
       Detalle.Distrito = cDistrito
       Detalle.Zona = cZona 
       Detalle.Clasificacion = cClasificacion
       Detalle.Tipo = cTipo
       Detalle.Vendedor = cVendedor
       Detalle.Delivery = cDelivery
       Detalle.ListaBase = cListaBase
       Detalle.VtaxMesMe = Detalle.VtaxMesMe + VentasxLinea.ImpExtCIGV
       Detalle.VtaxMesMn = Detalle.VtaxMesMn + VentasxLinea.ImpNacCIGV
       Detalle.CtoxMesMe = Detalle.CtoxMesMe + x-CostoExtCIGV
       Detalle.CtoxMesMn = Detalle.CtoxMesMn + x-CostoNacCIGV
       Detalle.ProxMesMe = Detalle.ProxMesMe + VentasxLinea.PromExtCIGV
       Detalle.ProxMesMn = Detalle.ProxMesMn + VentasxLinea.PromNacCIGV.
   ASSIGN
       Detalle.ProxMesMe2 = Detalle.ProxMesMe2 + VentasxLinea.PromExtSIGV
       Detalle.ProxMesMn2 = Detalle.ProxMesMn2 + VentasxLinea.PromNacSIGV.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resumen-por-producto wWin 
PROCEDURE Resumen-por-producto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lPos AS INT.           
/* RHC 30/04/2015 Vamos a tomar el último costo de reposicion */
/* DEF VAR x-CostoExtCIGV LIKE VentasxProducto.CostoExtCIGV NO-UNDO. */
/* DEF VAR x-CostoNacCIGV LIKE VentasxProducto.CostoNacCIGV NO-UNDO. */

FOR EACH VentasxProducto NO-LOCK WHERE VentasxProducto.DateKey >= DesdeF
    AND VentasxProducto.DateKey <= HastaF
    AND ( x-CodMat = '' OR LOOKUP (VentasxProducto.codmat, x-CodMat) > 0 )
    AND (x-CodDiv = '' OR VentasxProducto.coddiv = x-CodDiv),
    FIRST DimFecha OF VentasxProducto NO-LOCK,
    FIRST DimProducto NO-LOCK WHERE DimProducto.codmat = VentasxProducto.codmat
        AND (x-CodFam = '' OR DimProducto.codfam = x-CodFam)
        AND (x-CodPro = '' OR DimProducto.CodPro[1] = x-CodPro)
        AND (x-SubFam = '' OR DimProducto.subfam = x-SubFam),
    FIRST DimLinea OF DimProducto NO-LOCK,
    FIRST DimSubLinea OF DimProducto NO-LOCK:
    IF x-CuentaReg = 0 OR ( x-CuentaReg MODULO x-MuestraReg ) = 0 THEN
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** TABLA POR PRODUCTO ' + 
        ' Fecha ' + STRING (DAY(DimFecha.DateKey), '99') +
        ' ' + DimFecha.CalendarMonthLabel + ' ' + STRING (DimFecha.CalendarYear, '9999') +
        ' DIVISION ' + VentasxProducto.coddiv + ' PRODUCTO ' + VentasxProducto.codmat + ' **'.
    x-CuentaReg = x-CuentaReg + 1.
    /* RHC 30/04/2015 */
    ASSIGN
        x-TpoCmbCmp = 1
        x-TpoCmbVta = 1.
    FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= VentasxProducto.DateKey NO-LOCK NO-ERROR.
    IF NOT AVAIL Gn-Tcmb THEN 
        FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= VentasxProducto.DateKey NO-LOCK NO-ERROR.
    IF AVAIL Gn-Tcmb THEN 
        ASSIGN
            x-TpoCmbCmp = Gn-Tcmb.Compra
            x-TpoCmbVta = Gn-Tcmb.Venta.
    IF DimProducto.MonVta = 1 THEN DO:
        x-CostoNacCIGV = VentasxProducto.Cantidad * DimProducto.CtoTot.
        /*x-CostoExtCIGV = VentasxProducto.Cantidad * DimProducto.CtoTot / x-TpoCmbCmp.*/
        x-CostoExtCIGV = VentasxProducto.Cantidad * DimProducto.CtoTot / DimProducto.TpoCmb.
    END.
    ELSE DO:
        x-CostoExtCIGV = VentasxProducto.Cantidad * DimProducto.CtoTot.
        /*x-CostoNacCIGV = VentasxProducto.Cantidad * DimProducto.CtoTot * x-TpoCmbVta.*/
        x-CostoNacCIGV = VentasxProducto.Cantidad * DimProducto.CtoTot * DimProducto.TpoCmb.
    END.
    /* *************** */
    /* ARMAMOS LA LLAVE */
    ASSIGN
        x-Llave = ''
        cCampania = ''
        cPeriodo = 0
        cRanking = 0
        cCategoria = ''
        cRUtilex = 0
        cCUtilex = ''
        cRMayo = 0
        cCMayo = ''
        cNroMes = 0
        cDia = ?
        cDivision = ''
        cDestino = ''
        cCanalVenta = ''
        cProducto = ''
        cLinea = ''
        cSublinea = ''
        cMarca = ''
        cUnidad = ''
        cLicencia = ''
        cLicenciatario = ''
        cProveedor = ''
        cCliente = ''
        cCanal = ''
        cTarjeta = ''
        cDepartamento = ''
        cProvincia = ''
        cDistrito = ''
        cZona = ''
        cClasificacion = ''
        cTipo = ''
        cVendedor = ''
        cSubTipo = ''
        cCodAsoc = ''
        cDelivery = ''
        cListaBase = ''.
    /* LLAVE INICIAL */
    IF RADIO-SET-Tipo = 2 THEN DO:
        IF x-Llave = '' THEN x-Llave = DimFecha.Campania.
        ELSE x-Llave = x-Llave + DimFecha.Campania.
        x-Llave = x-Llave + '|'.
        x-Llave = x-Llave + STRING(YEAR(DimFecha.DateKey), '9999').
        x-Llave = x-Llave + '|'.
        x-Llave = x-Llave + STRING(MONTH(DimFecha.DateKey), '99').      
        x-Llave = x-LLave + '|'.
        ASSIGN
            cCampania = DimFecha.Campania
            cPeriodo  = YEAR(DimFecha.DateKey)
            cNroMes   = MONTH(DimFecha.DateKey).
    END.
    IF RADIO-SET-Tipo = 3 THEN DO:
        IF x-Llave = '' THEN x-Llave = DimFecha.Campania.
        ELSE x-Llave = x-Llave + DimFecha.Campania.
        x-Llave = x-Llave + '|'.
        x-Llave = x-Llave + DimFecha.DateDescription.
        x-Llave = x-LLave + '|'.
        ASSIGN
            cCampania = DimFecha.Campania
            cDia      = DimFecha.DateKey.
    END.
    IF TOGGLE-CodDiv = YES THEN DO:
        FIND FIRST DimDivision OF VentasxProducto NO-LOCK.
         IF x-Llave = '' THEN x-Llave = VentasxProducto.coddiv + '|'.
         ELSE x-Llave = x-LLave + VentasxProducto.coddiv + '|'.
         x-Llave = x-Llave + DimDivision.CanalVenta + '|'.
         ASSIGN
             cDivision = VentasxProducto.coddiv + ' ' + DimDivision.DesDiv
             cCanalVenta = DimDivision.CanalVenta + ' ' + DimDivision.NomCanalVenta.
         FIND FIRST DimDivision WHERE DimDivision.coddiv = VentasxProducto.divdes NO-LOCK.
         ASSIGN
             cDestino = VentasxProducto.divdes + ' ' + DimDivision.DesDiv
             x-Llave = x-LLave + VentasxProducto.divdes + '|'.
         ASSIGN
             cListaBase = VentasxProducto.ListaBase
             x-Llave = x-LLave + VentasxProducto.ListaBase + '|'.
         FIND FIRST DimDivision WHERE DimDivision.coddiv = VentasxProducto.ListaBase NO-LOCK NO-ERROR.
         IF AVAILABLE DimDivision THEN cListaBase  = VentasxProducto.ListaBase + ' ' + DimDivision.DesDiv.

    END.
    ASSIGN
        x-Llave = x-Llave + VentasxProducto.Tipo + '|'
        cTipo   = VentasxProducto.Tipo
        cDelivery = VentasxProducto.Delivery.
        
    
    IF x-Llave = '' THEN x-Llave = VentasxProducto.codmat.
    ELSE x-Llave = x-Llave + VentasxProducto.codmat.
    x-Llave = x-Llave + DimProducto.codfam + '|'.
    x-Llave = x-Llave + DimProducto.subfam + '|'.
    x-Llave = x-Llave + DimProducto.desmar + '|'.
    x-Llave = x-Llave + DimProducto.undstk + '|'.
    x-Llave = x-Llave + DimProducto.SubTipo + '|'.
    x-Llave = x-Llave + DimProducto.CodAsoc + '|'.
    ASSIGN
        cProducto = TRIM(VentasxProducto.codmat) + ' ' + TRIM(DimProducto.DesMat)
        cRanking = DimProducto.Ranking
        cCategoria = DimProducto.Categoria

        cRUtilex = DimProducto.RUtilex
        cCUtilex = DimProducto.CUtilex

        cRMayo = DimProducto.RMayorista
        cCMayo = DimProducto.CMayorista

        cLinea = DimProducto.codfam + ' ' + DimLinea.NomFam 
        cSublinea = DimProducto.subfam + ' ' + DimSubLinea.NomSubFam 
        cMarca = DimProducto.desmar
        cUnidad = DimProducto.undstk
        cSubTipo = DimProducto.SubTipo
        cCodAsoc = DimProducto.CodAsoc.

    /* Ic - 18Dic2014
        Sacar los los rankings de la nueva tabla calculada
    */
    ASSIGN cRanking = 0
            cCategoria = ''

            cRUtilex = 0
            cCUtilex = ''

            cRMayo = 0
            cCMayo = ''.

    lPos = 1.
    IF rRanking = 2 THEN DO:
        lPos = 4.
    END.
    
    FIND FIRST factabla WHERE factabla.codcia = s-codcia AND
            factabla.tabla = 'RANKVTA' AND factabla.codigo = VentasxProducto.codmat NO-LOCK NO-ERROR.

    IF AVAILABLE factabla THEN DO:
        ASSIGN cRanking = factabla.valor[lpos]
                cCategoria = factabla.campo-c[lpos]

                cRUtilex = factabla.valor[lpos + 1]
                cCUtilex = factabla.campo-c[lpos + 1]

                cRMayo = factabla.valor[lpos + 2]
                cCMayo = factabla.campo-c[lpos + 2].
    END.

    /* Ic - 18Dic2014 - FIN */

    FIND B-Producto WHERE B-Producto.CodMat = DimProducto.CodAsoc NO-LOCK NO-ERROR.
    IF AVAILABLE B-Producto THEN cCodAsoc = cCodAsoc + ' ' + B-Producto.DesMat.
     x-Llave = x-Llave + DimProducto.licencia + '|'.
     x-Llave = x-Llave + DimProducto.codpro[1] + '|'.
     FIND DimLicencia OF DimProducto NO-LOCK NO-ERROR.
     FIND DimProveedor WHERE DimProveedor.CodPro = DimProducto.CodPro[1] NO-LOCK NO-ERROR.
     ASSIGN
         cLicencia = DimProducto.licencia + ' ' + (IF AVAILABLE DimLicencia THEN DimLicencia.Descripcion ELSE '')
         cProveedor = DimProducto.codpro[1] + ' ' + (IF AVAILABLE DimProveedor THEN DimProveedor.NomPro ELSE '').
     IF AVAILABLE DimLicencia THEN DO:
         cLicenciatario = DimLicencia.Licenciatario.
         FIND DimLicenciatario OF DimLicencia NO-LOCK NO-ERROR.
         IF AVAILABLE DimLicenciatario THEN cLicenciatario = DimLicenciatario.Licenciatario + ' ' + DimLicenciatario.NomLicenciatario.
     END.
     /* ******************************************** */
     FIND Detalle WHERE Detalle.llave = x-Llave NO-ERROR.
     IF NOT AVAILABLE Detalle THEN DO:
         CREATE Detalle.
         Detalle.llave = x-Llave.
     END.
     ASSIGN
         Detalle.Campania = cCampania
         Detalle.Periodo = cPeriodo
         Detalle.NroMes = cNroMes
         Detalle.Dia = cDia
         Detalle.Division = cDivision
         Detalle.Destino  = cDestino
         Detalle.CanalVenta = cCanalVenta
         Detalle.Producto = cProducto
         Detalle.Ranking = cRanking
         Detalle.Categoria = cCategoria
         Detalle.clsfutlx = cCUtilex
         Detalle.rnkgutlx = cRUtilex
         Detalle.clsfmayo = cCMayo
         Detalle.rnkgmayo = cRMayo
         Detalle.Linea = cLinea
         Detalle.Sublinea = cSublinea
         Detalle.Marca = cMarca
         Detalle.Unidad = cUnidad
         Detalle.Licencia = cLicencia
         Detalle.Licenciatario = cLicenciatario
         Detalle.Proveedor = cProveedor
         Detalle.SubTipo = cSubTipo
         Detalle.CodAsoc = cCodAsoc
         Detalle.Cliente = cCliente
         Detalle.Canal = cCanal
         Detalle.Tarjeta = cTarjeta
         Detalle.Departamento = cDepartamento
         Detalle.Provincia = cProvincia
         Detalle.Distrito = cDistrito
         Detalle.Zona = cZona 
         Detalle.Clasificacion = cClasificacion
         Detalle.Tipo = cTipo
         Detalle.Vendedor = cVendedor
         Detalle.Delivery = cDelivery
         Detalle.ListaBase = cListaBase
         Detalle.CanxMes   = Detalle.CanxMes   + VentasxProducto.Cantidad
         Detalle.VtaxMesMe = Detalle.VtaxMesMe + VentasxProducto.ImpExtCIGV
         Detalle.VtaxMesMn = Detalle.VtaxMesMn + VentasxProducto.ImpNacCIGV
         Detalle.CtoxMesMe = Detalle.CtoxMesMe + x-CostoExtCIGV
         Detalle.CtoxMesMn = Detalle.CtoxMesMn + x-CostoNacCIGV
         Detalle.ProxMesMe = Detalle.ProxMesMe + VentasxProducto.PromExtCIGV
         Detalle.ProxMesMn = Detalle.ProxMesMn + VentasxProducto.PromNacCIGV.
     ASSIGN
         Detalle.ProxMesMe2 = Detalle.ProxMesMe2 + VentasxProducto.PromExtSIGV
         Detalle.ProxMesMn2 = Detalle.ProxMesMn2 + VentasxProducto.PromNacSIGV.
     /* RHC 19/08/2016 Código Padre */
     FIND Almmmatg WHERE Almmmatg.CodCia = s-codcia
         AND Almmmatg.codmat = DimProducto.CodMat
         NO-LOCK NO-ERROR.
     IF AVAILABLE Almmmatg AND NOT (TRUE <> (Almmmatg.CodigoPadre > '')) 
         THEN DO:
         FIND B-Producto WHERE B-Producto.codmat = Almmmatg.CodigoPadre NO-LOCK NO-ERROR.
         IF AVAILABLE B-Producto THEN DO:
             ASSIGN
                 Detalle.CodigoPadre = TRIM(B-Producto.CodMat + ' ' + B-Producto.DesMat)
                 Detalle.FactorPadre = Almmmatg.FactorPadre
                 Detalle.NCantidad = Detalle.CanxMes * Almmmatg.FactorPadre.
         END.
     END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resumen-por-vendcli wWin 
PROCEDURE Resumen-por-vendcli :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN
    iContador = 1       /* Valor por defecto */
    x-CodCli = ''.
FOR EACH tt-cliente NO-LOCK:
    iContador = iContador + 1.
    IF x-CodCli = '' THEN x-CodCli = tt-cliente.tt-codcli.
    ELSE x-CodCli = x-CodCli + ',' + tt-cliente.tt-codcli.
    IF iContador = 1000 THEN DO:
        {est/resumenxvendcliente.i}
        ASSIGN
            iContador = 0
            x-CodCli = ''.
    END.
END.
IF iContador > 0 THEN DO:
    {est/resumenxvendcliente.i}
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rResxClixLin wWin 
PROCEDURE rResxClixLin :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAMETER pCostoNacCIGV AS DEC.
DEF OUTPUT PARAMETER pCostoExtCIGV AS DEC.

ASSIGN
    pCostoNacCIGV = VentasxClienteLinea.CostoNacCIGV
    pCostoExtCIGV = VentasxClienteLinea.CostoExtCIGV.
RETURN.

FOR EACH Ventas_Cabecera NO-LOCK WHERE Ventas_Cabecera.DateKey = VentasxClienteLinea.DateKey
    AND Ventas_Cabecera.CodDiv = VentasxClienteLinea.CodDiv
    AND Ventas_Cabecera.DivDes = VentasxClienteLinea.DivDes
    AND Ventas_Cabecera.CodCli = VentasxClienteLinea.CodCli
    AND Ventas_Cabecera.Tipo = VentasxClienteLinea.Tipo
    AND Ventas_Cabecera.Delivery = VentasxClienteLinea.Delivery
    AND Ventas_Cabecera.ListaBase = VentasxClienteLinea.ListaBase,
    EACH Ventas_Detalle OF Ventas_Cabecera NO-LOCK,
    FIRST DimProducto NO-LOCK WHERE DimProducto.CodMat = Ventas_Detalle.CodMat
    AND DimProducto.CodFam = VentasxClienteLinea.CodFam
    AND DimProducto.SubFam = VentasxClienteLinea.SubFam
    AND DimProducto.DesMar = VentasxClienteLinea.DesMar
    AND DimProducto.Licencia = VentasxClienteLinea.Licencia:
    ASSIGN
        x-TpoCmbCmp = 1
        x-TpoCmbVta = 1.
    FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= VentasxClienteLinea.DateKey NO-LOCK NO-ERROR.
    IF NOT AVAIL Gn-Tcmb THEN 
        FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= VentasxClienteLinea.DateKey NO-LOCK NO-ERROR.
    IF AVAIL Gn-Tcmb THEN 
        ASSIGN
            x-TpoCmbCmp = Gn-Tcmb.Compra
            x-TpoCmbVta = Gn-Tcmb.Venta.
    IF DimProducto.MonVta = 1 THEN DO:
        pCostoNacCIGV = pCostoNacCIGV + Ventas_Detalle.Cantidad * DimProducto.CtoTot.
        /*pCostoExtCIGV = Ventas_Detalle.Cantidad * DimProducto.CtoTot / x-TpoCmbCmp.*/
        pCostoExtCIGV = pCostoExtCIGV + Ventas_Detalle.Cantidad * DimProducto.CtoTot / DimProducto.TpoCmb.
    END.
    ELSE DO:
        pCostoExtCIGV = pCostoExtCIGV + Ventas_Detalle.Cantidad * DimProducto.CtoTot.
        /*pCostoNacCIGV = Ventas_Detalle.Cantidad * DimProducto.CtoTot * x-TpoCmbVta.*/
        pCostoNacCIGV = pCostoNacCIGV + Ventas_Detalle.Cantidad * DimProducto.CtoTot * DimProducto.TpoCmb.
    END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rResxLin wWin 
PROCEDURE rResxLin :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pCostoNacCIGV AS DEC.
DEF OUTPUT PARAMETER pCostoExtCIGV AS DEC.

ASSIGN
    pCostoNacCIGV = VentasxLinea.CostoNacCIGV
    pCostoExtCIGV = VentasxLinea.CostoExtCIGV.
RETURN.

FOR EACH Ventas NO-LOCK WHERE Ventas.DateKey = VentasxLinea.DateKey
    AND Ventas.CodDiv = VentasxLinea.CodDiv
    AND Ventas.DivDes = VentasxLinea.DivDes
    AND Ventas.CodVen = VentasxLinea.CodVen
    AND Ventas.Tipo   = VentasxLinea.Tipo
    AND Ventas.Delivery  = VentasxLinea.Delivery
    AND Ventas.ListaBase = VentasxLinea.ListaBase,
    FIRST DimProducto NO-LOCK WHERE DimProducto.CodMat = Ventas.CodMat:
    IF NOT (DimProducto.CodFam = VentasxLinea.CodFam 
            AND DimProducto.SubFam = VentasxLinea.SubFam
            AND DimProducto.DesMar = VentasxLinea.DesMar
            AND DimProducto.Licencia  = VentasxLinea.Licencia
            AND DimProducto.CodPro[1] = VentasxLinea.CodPro)
        THEN NEXT.
    ASSIGN
        x-TpoCmbCmp = 1
        x-TpoCmbVta = 1.
    FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= VentasxLinea.DateKey NO-LOCK NO-ERROR.
    IF NOT AVAIL Gn-Tcmb THEN 
        FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= VentasxLinea.DateKey NO-LOCK NO-ERROR.
    IF AVAIL Gn-Tcmb THEN 
        ASSIGN
        x-TpoCmbCmp = Gn-Tcmb.Compra
        x-TpoCmbVta = Gn-Tcmb.Venta.
    IF DimProducto.MonVta = 1 THEN DO:
        pCostoNacCIGV = pCostoNacCIGV + Ventas.Cantidad * DimProducto.CtoTot.
        pCostoExtCIGV = pCostoExtCIGV + Ventas.Cantidad * DimProducto.CtoTot / DimProducto.TpoCmb.
    END.
    ELSE DO:
        pCostoExtCIGV = pCostoExtCIGV + Ventas.Cantidad * DimProducto.CtoTot.
        pCostoNacCIGV = pCostoNacCIGV + Ventas.Cantidad * DimProducto.CtoTot * DimProducto.TpoCmb.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

