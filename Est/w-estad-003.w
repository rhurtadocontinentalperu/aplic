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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-aplic-id AS CHAR.

DEF NEW SHARED VAR input-var-1 AS CHAR.
DEF NEW SHARED VAR input-var-2 AS CHAR.
DEF NEW SHARED VAR input-var-3 AS CHAR.
DEF NEW SHARED VAR output-var-1 AS ROWID.
DEF NEW SHARED VAR output-var-2 AS CHAR.
DEF NEW SHARED VAR output-var-3 AS CHAR.

DEFINE VAR T-Vtamn   AS DECI INIT 0 EXTENT 4.
DEFINE VAR T-Vtame   AS DECI INIT 0 EXTENT 4.
DEFINE VAR T-Ctomn   AS DECI INIT 0 EXTENT 4.
DEFINE VAR T-Ctome   AS DECI INIT 0 EXTENT 4.
DEFINE VAR T-Promn   AS DECI INIT 0 EXTENT 4.
DEFINE VAR T-Prome   AS DECI INIT 0 EXTENT 4.
DEFINE VAR F-Salida  AS DECI INIT 0 EXTENT 4.
DEFINE VAR X-FECHA AS DATE.

DEF VAR cListaDivisiones AS CHAR.

DEF TEMP-TABLE tmp-detalle
    FIELD Llave     AS CHAR
    FIELD CanxMes   AS DEC EXTENT 4
    FIELD VtaxMesMe AS DEC EXTENT 4
    FIELD VtaxMesMn AS DEC EXTENT 4
    FIELD CtoxMesMe AS DEC EXTENT 4
    FIELD CtoxMesMn AS DEC EXTENT 4
    FIELD ProxMesMe AS DEC EXTENT 4
    FIELD ProxMesMn AS DEC EXTENT 4
    INDEX Llave01 AS PRIMARY Llave.
DEF TEMP-TABLE Detalle
    FIELD Campania  AS CHAR FORMAT 'x(20)'
    FIELD Periodo   AS INT  FORMAT 'ZZZ9' LABEL 'Año'
    FIELD NroMes    AS INT  FORMAT 'Z9' LABEL 'Mes'
/*     FIELD Dia       AS DATE FORMAT '99/99/9999' LABEL 'Dia' */
    FIELD Division  AS CHAR  FORMAT 'x(60)'
/*     FIELD Destino   AS CHAR  FORMAT 'x(60)' */
    FIELD CanalVenta AS CHAR    LABEL "Canal Venta" FORMAT 'x(60)'
    FIELD Producto  AS CHAR FORMAT 'x(60)'
/*     FIELD Ranking   AS INT  FORMAT '>>>>>9' */
/*     FIELD Categoria AS CHAR FORMAT 'X'      */
    FIELD Linea     AS CHAR FORMAT 'x(60)'
    FIELD Sublinea  AS CHAR FORMAT 'x(60)'
    FIELD Marca     AS CHAR FORMAT 'x(20)'
    FIELD Unidad    AS CHAR FORMAT 'x(10)'
    FIELD Licencia  AS CHAR FORMAT 'x(60)'
    FIELD Proveedor AS CHAR FORMAT 'x(60)'
    FIELD Cliente   AS CHAR FORMAT 'x(60)'
/*     FIELD CliUnico  AS CHAR FORMAT 'x(60)' */
    FIELD Canal     AS CHAR FORMAT 'x(30)'
    FIELD Tarjeta   AS CHAR FORMAT 'x(60)'
    FIELD Departamento AS CHAR FORMAT 'x(20)'
    FIELD Provincia AS CHAR FORMAT 'x(20)'
    FIELD Distrito  AS CHAR FORMAT 'x(20)'
    FIELD Zona      AS CHAR FORMAT 'x(20)'
    FIELD Clasificacion AS CHAR FORMAT 'x(20)'
/*     FIELD Tipo      AS CHAR FORMAT 'x(20)' */
    FIELD Vendedor  AS CHAR FORMAT 'x(60)'
/*     FIELD SubTipo   AS CHAR LABEL 'SubTipo'     FORMAT 'x(30)'     */
/*     FIELD CodAsoc   AS CHAR LABEL 'Cod Asociado'    FORMAT 'x(60)' */
/*     FIELD Delivery  AS CHAR LABEL 'Delivery'    FORMAT 'x(2)'      */
    FIELD CanActual         AS DEC LABEL "CANTIDAD-ACTUAL"      FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD CanAcumActual     AS DEC LABEL "CANTIDAD-ACUM-ACTUAL" FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD CanAnterior       AS DEC LABEL "CANTIDAD-ANTERIOR"      FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD CanAcumAnterior   AS DEC LABEL "CANTIDAD-ACUM-ANTERIOR" FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD VtaSolesActual    AS DEC LABEL "VENTA-SOLES-ACTUAL"   FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD VtaDolarActual    AS DEC LABEL "VENTA-DOLARES-ACTUAL" FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD CtoSolesActual    AS DEC LABEL "CTO-SOLES-ACTUAL"     FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD CtoDolarActual    AS DEC LABEL "CTO-DOLAR-ACTUAL"     FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD PromSolesActual   AS DEC LABEL "PROM-SOLES-ACTUAL"    FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD PromDolarActual   AS DEC LABEL "PROM-DOLAR-ACTUAL"    FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD VtaSolesAcumActual    AS DEC LABEL "VENTA-SOLES-ACUM-ACTUAL"      FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD VtaDolarAcumActual    AS DEC LABEL "VENTA-DOLARES-ACUM-ACTUAL"    FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD CtoSolesAcumActual    AS DEC LABEL "CTO-SOLES-ACUM-ACTUAL"        FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD CtoDolarAcumActual    AS DEC LABEL "CTO-DOLAR-ACUM-ACTUAL"        FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD PromSolesAcumActual   AS DEC LABEL "PROM-SOLES-ACUM-ACTUAL"       FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD PromDolarAcumActual   AS DEC LABEL "PROM-DOLAR-ACUM-ACTUAL"       FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD VtaSolesAnterior  AS DEC LABEL "VENTA-SOLES-ANTERIOR"   FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD VtaDolarAnterior  AS DEC LABEL "VENTA-DOLARES-ANTERIOR" FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD CtoSolesAnterior  AS DEC LABEL "CTO-SOLES-ANTERIOR"     FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD CtoDolarAnterior  AS DEC LABEL "CTO-DOLAR-ANTERIOR"     FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD PromSolesAnterior AS DEC LABEL "PROM-SOLES-ANTERIOR"    FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD PromDolarAnterior AS DEC LABEL "PROM-DOLAR-ANTERIOR"    FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD VtaSolesAcumAnterior  AS DEC LABEL "VENTA-SOLES-ACUM-ANTERIOR"      FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD VtaDolarAcumAnterior  AS DEC LABEL "VENTA-DOLARES-ACUM-ANTERIOR"    FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD CtoSolesAcumAnterior  AS DEC LABEL "CTO-SOLES-ACUM-ANTERIOR"        FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD CtoDolarAcumAnterior  AS DEC LABEL "CTO-DOLAR-ACUM-ANTERIOR"        FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD PromSolesAcumAnterior AS DEC LABEL "PROM-SOLES-ACUM-ANTERIOR"       FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD PromDolarAcumAnterior AS DEC LABEL "PROM-DOLAR-ACUM-ANTERIOR"       FORMAT '->>>,>>>,>>>,>>9.99'.

DEF TEMP-TABLE T-Detalle LIKE Detalle.

/* VARIABLES PARA EL RESUMEN */
DEF VAR x-CodDiv LIKE DimDivision.coddiv   NO-UNDO.
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

DEF VAR iContador AS INT NO-UNDO.
DEFINE VAR x-NroFchR AS DATE NO-UNDO.
DEFINE VAR x-NroFchE AS DATE NO-UNDO.

DEFINE VAR x-Llave AS CHAR.
DEF STREAM REPORTE.

/*DEF INPUT PARAMETER pParametro AS CHAR.*/
DEF VAR pParametro AS CHAR INIT "+COSTO".
/* Sistaxis de pParamtero
+COSTO    Imprimir el valor del costo
-COSTO    Imprimir sin el valor del costo
************************** */

/*DEF VAR pParametro AS CHAR INIT "+COSTO".*/
/*DEF INPUT PARAMETER pParametro AS CHAR.*/
/* Sistaxis de pParamtero
+COSTO    Imprimir el valor del costo
-COSTO    Imprimir sin el valor del costo
************************** */

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
IF s-ConCostos = YES THEN pParametro = "+COSTO".
IF s-ConCostos = NO  THEN pParametro = "-COSTO".

/*Tabla Clientes*/
DEFINE TEMP-TABLE tt-cliente
    FIELDS tt-codcli LIKE DimCliente.codcli
    FIELDS tt-nomcli LIKE DimCliente.nomcli
    INDEX idx01 IS PRIMARY tt-codcli.

/*Tabla Clientes*/
DEFINE TEMP-TABLE tt-articulo
    FIELDS tt-codmat LIKE DimProducto.codmat
    FIELDS tt-desmat LIKE DimProducto.desmat
    INDEX idx01 IS PRIMARY tt-codmat.

DEFINE TEMP-TABLE tt-datos
    FIELDS tt-codigo AS CHAR.

DEF VAR pOptions AS CHAR.
DEF VAR lOptions AS CHAR.
DEF VAR pArchivo AS CHAR.
DEF VAR cArchivo AS CHAR.
DEF VAR zArchivo AS CHAR.
DEF VAR cComando AS CHAR.
DEF VAR pDirectorio AS CHAR.

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
BtnDone DesdeF HastaF TOGGLE-CodDiv TOGGLE-CodCli TOGGLE-CodMat ~
TOGGLE-CodVen 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Mensaje DesdeF HastaF ~
TOGGLE-CodDiv COMBO-BOX-CodDiv TOGGLE-CodCli FILL-IN-CodCli FILL-IN-NomCli ~
FILL-IN-file TOGGLE-Resumen-Depto TOGGLE-CodMat COMBO-BOX-CodFam ~
TOGGLE-Resumen-Linea COMBO-BOX-SubFam TOGGLE-Resumen-Marca FILL-IN-CodMat ~
FILL-IN-DesMat FILL-IN-file-2 FILL-IN-CodPro FILL-IN-NomPro TOGGLE-CodVen ~
FILL-IN-CodVen FILL-IN-NomVen 

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
     SIZE 6 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 6 BY 1.62.

DEFINE BUTTON BUTTON-5 
     LABEL "..." 
     SIZE 5 BY 1.

DEFINE BUTTON BUTTON-6 
     LABEL "..." 
     SIZE 5 BY 1.

DEFINE VARIABLE COMBO-BOX-CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 70 BY 1 NO-UNDO.

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
     VIEW-AS FILL-IN 
     SIZE 76 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-file-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 76 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 103 BY 1 NO-UNDO.

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

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 116 BY 1.88.

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
     SIZE 116 BY 1.58.

DEFINE VARIABLE TOGGLE-CodCli AS LOGICAL INITIAL no 
     LABEL "Cliente" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-CodDiv AS LOGICAL INITIAL no 
     LABEL "Division" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-CodMat AS LOGICAL INITIAL no 
     LABEL "Artículo" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-CodVen AS LOGICAL INITIAL no 
     LABEL "Vendedor" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.

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


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     BUTTON-1 AT ROW 1 COL 112 WIDGET-ID 24
     BtnDone AT ROW 1 COL 118 WIDGET-ID 28
     FILL-IN-Mensaje AT ROW 1.27 COL 6 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     DesdeF AT ROW 3.12 COL 29 COLON-ALIGNED WIDGET-ID 10
     HastaF AT ROW 3.12 COL 50 COLON-ALIGNED WIDGET-ID 12
     TOGGLE-CodDiv AT ROW 5 COL 11 WIDGET-ID 2
     COMBO-BOX-CodDiv AT ROW 5 COL 29 COLON-ALIGNED WIDGET-ID 30
     TOGGLE-CodCli AT ROW 6.62 COL 11 WIDGET-ID 6
     FILL-IN-CodCli AT ROW 6.62 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     FILL-IN-NomCli AT ROW 6.62 COL 44 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     BUTTON-5 AT ROW 7.69 COL 108 WIDGET-ID 66
     FILL-IN-file AT ROW 7.73 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 68
     TOGGLE-Resumen-Depto AT ROW 8.77 COL 31 WIDGET-ID 64
     TOGGLE-CodMat AT ROW 10.12 COL 11 WIDGET-ID 14
     COMBO-BOX-CodFam AT ROW 10.12 COL 29 COLON-ALIGNED WIDGET-ID 36
     TOGGLE-Resumen-Linea AT ROW 10.12 COL 81 WIDGET-ID 60
     COMBO-BOX-SubFam AT ROW 11.19 COL 29 COLON-ALIGNED WIDGET-ID 38
     TOGGLE-Resumen-Marca AT ROW 11.19 COL 81 WIDGET-ID 62
     FILL-IN-CodMat AT ROW 12.27 COL 29.14 COLON-ALIGNED WIDGET-ID 70
     FILL-IN-DesMat AT ROW 12.27 COL 44.14 COLON-ALIGNED NO-LABEL WIDGET-ID 72
     BUTTON-6 AT ROW 13.31 COL 108 WIDGET-ID 74
     FILL-IN-file-2 AT ROW 13.35 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 76
     FILL-IN-CodPro AT ROW 14.42 COL 29 COLON-ALIGNED WIDGET-ID 40
     FILL-IN-NomPro AT ROW 14.42 COL 44 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     TOGGLE-CodVen AT ROW 16.04 COL 11 WIDGET-ID 18
     FILL-IN-CodVen AT ROW 16.04 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     FILL-IN-NomVen AT ROW 16.04 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     RECT-1 AT ROW 4.46 COL 8 WIDGET-ID 78
     RECT-2 AT ROW 6.35 COL 8 WIDGET-ID 80
     RECT-3 AT ROW 9.85 COL 8 WIDGET-ID 82
     RECT-4 AT ROW 15.77 COL 8 WIDGET-ID 84
     RECT-5 AT ROW 2.88 COL 8 WIDGET-ID 86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 128.72 BY 17.08 WIDGET-ID 100.


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
         TITLE              = "ESTADISTICAS DE VENTAS COMPARATIVAS"
         HEIGHT             = 17.08
         WIDTH              = 128.72
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
/* SETTINGS FOR COMBO-BOX COMBO-BOX-CodDiv IN FRAME fMain
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
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomVen IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-Resumen-Depto IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-Resumen-Linea IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-Resumen-Marca IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* ESTADISTICAS DE VENTAS COMPARATIVAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* ESTADISTICAS DE VENTAS COMPARATIVAS */
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
        TOGGLE-Resumen-Marca
        TOGGLE-Resumen-Depto.
    ASSIGN
        COMBO-BOX-CodDiv 
        COMBO-BOX-CodFam 
        COMBO-BOX-SubFam 
        /*COMBO-BOX-Tipo*/
        FILL-IN-CodCli 
        FILL-IN-CodPro 
        FILL-IN-CodVen 
        FILL-IN-file 
        FILL-IN-file-2.
    ASSIGN
        /*RADIO-SET-Tipo*/
        DesdeF HastaF.
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
/*    RUN Carga-Temporal.                                           */
/*    FIND FIRST Detalle NO-ERROR.                                  */
/*    IF NOT AVAILABLE Detalle THEN DO:                             */
/*        MESSAGE 'No hay registros' VIEW-AS ALERT-BOX WARNING.     */
/*        RETURN NO-APPLY.                                          */
/*    END.                                                          */
/*    SESSION:SET-WAIT-STATE('GENERAL').                            */
/*    RUN Excel.                                                    */
/*    SESSION:SET-WAIT-STATE('').                                   */
/*    ASSIGN                                                        */
/*        FILL-IN-file = ''                                         */
/*        FILL-IN-file-2 = ''.                                      */
/*    DISPLAY FILL-IN-file FILL-IN-file-2 WITH FRAME {&FRAME-NAME}. */

    RUN lib/tt-file-to-text-7zip (OUTPUT pOptions, OUTPUT pArchivo, OUTPUT pDirectorio).
    IF pOptions = "" THEN RETURN NO-APPLY.

    SESSION:SET-WAIT-STATE('GENERAL').
    SESSION:DATE-FORMAT = "mdy".
    RUN Carga-Temporal.
    RUN Excel-2.
    SESSION:DATE-FORMAT = "dmy".
    SESSION:SET-WAIT-STATE('').

    FIND FIRST Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    /*pOptions = pOptions + CHR(1) + "SkipList:Llave".*/

    /* El archivo se va a generar en un archivo temporal de trabajo antes 
    de enviarlo a su directorio destino */
    pArchivo = REPLACE(pArchivo, '.', STRING(RANDOM(1,9999), '9999') + ".").
    cArchivo = LC(SESSION:TEMP-DIRECTORY + pArchivo).
    SESSION:SET-WAIT-STATE('GENERAL').
    SESSION:DATE-FORMAT = "mdy".
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
ON LEAVE OF FILL-IN-CodCli IN FRAME fMain
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
ON LEFT-MOUSE-DBLCLICK OF FILL-IN-CodCli IN FRAME fMain
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
ON VALUE-CHANGED OF TOGGLE-CodDiv IN FRAME fMain /* Division */
DO:
  COMBO-BOX-CodDiv:SENSITIVE = NOT COMBO-BOX-CodDiv:SENSITIVE.
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
/*     IF SEARCH(FILL-IN-file) <> ? THEN DO: */
/*         INPUT FROM VALUE(FILL-IN-file).   */
/*         REPEAT:                           */
/*             CREATE tt-cliente.            */
/*             IMPORT tt-codcli.             */
/*         END.                              */
/*         INPUT CLOSE.                      */
/*     END.                                  */
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

    /*
    x-CodCli = ''.
    FOR EACH tt-cliente:
        IF x-CodCli = '' THEN x-CodCli = tt-cliente.tt-codcli.
        ELSE x-CodCli = x-CodCli + ',' + tt-cliente.tt-codcli.
    END.
    */


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

SESSION:SET-WAIT-STATE('GENERAL').
/* INFORMACION RESUMIDA */
ASSIGN
    x-CodDiv = ''
    x-CodCli = ''
    x-CodPro = ''
    x-CodVen = ''
    x-CodFam = ''
    x-SubFam = ''
    x-CodMat = ''
    x-CuentaReg = 0
    x-MuestraReg = 1000.    /* cada 1000 registros */

IF TOGGLE-CodDiv AND NOT COMBO-BOX-CodDiv BEGINS 'Todos' THEN x-CodDiv = ENTRY(1, COMBO-BOX-CodDiv, ' - ').
IF TOGGLE-CodCli THEN x-CodCli = FILL-IN-CodCli.
IF TOGGLE-CodMat THEN x-CodMat = FILL-IN-CodMat.
IF TOGGLE-CodMat AND NOT COMBO-BOX-CodFam BEGINS 'Todos' THEN x-CodFam = ENTRY(1, COMBO-BOX-CodFam, ' - ').
IF TOGGLE-CodMat AND NOT COMBO-BOX-SubFam BEGINS 'Todos' THEN x-SubFam = ENTRY(1, COMBO-BOX-SubFam, ' - ').
IF TOGGLE-CodMat THEN x-CodPro = FILL-IN-CodPro.
IF TOGGLE-CodVen THEN x-CodVen = FILL-IN-CodVen.

RUN Carga-Lista-Articulos.
RUN Carga-Lista-Clientes.

/* Barremos por cada división */
DEF VAR k AS INT NO-UNDO.
DEF VAR xListaDivisiones AS CHAR.

IF COMBO-BOX-CodDiv = 'Todos' OR TOGGLE-CodDiv = NO THEN DO:
    DO k = 2 TO NUM-ENTRIES(cListaDivisiones):
        IF xListaDivisiones = '' THEN xListaDivisiones = ENTRY(k, cListaDivisiones).
        ELSE xListaDivisiones = xListaDivisiones + ',' + ENTRY(k, cListaDivisiones).
    END.
END.
ELSE xListaDivisiones = COMBO-BOX-CodDiv.
EMPTY TEMP-TABLE tmp-detalle.

/* PERIODO ACTUAL Y ACUMULADO */
ASSIGN
    x-NroFchR = DATE(01,01,YEAR(DesdeF))
    x-NroFchE = HastaF.
DO k = 1 TO NUM-ENTRIES(xListaDivisiones):
    x-CodDiv = ENTRY(1, ENTRY(k, xListaDivisiones), ' - ').
    /* FILTROS */
    IF TOGGLE-CodDiv = YES
        AND ( TOGGLE-CodCli = NO AND TOGGLE-CodMat = NO AND TOGGLE-CodVen = NO )
        THEN DO:
        RUN Resumen-por-division.
        Control-Resumen = YES.
    END.
    IF TOGGLE-CodCli = YES AND TOGGLE-CodMat = NO AND TOGGLE-CodVen = NO
        THEN DO:
        RUN Resumen-por-cliente.
        Control-Resumen = YES.
    END.
    IF TOGGLE-CodCli = YES AND TOGGLE-CodMat = YES AND TOGGLE-CodVen = NO
        THEN DO:
        IF TOGGLE-Resumen-Linea = YES OR TOGGLE-Resumen-Marca = YES 
        THEN DO:
            RUN Resumen-por-climat.
            Control-Resumen = YES.
        END.
    END.
    IF TOGGLE-CodCli = NO AND TOGGLE-CodMat = YES AND TOGGLE-CodVen = NO
        THEN DO:
        IF TOGGLE-Resumen-Linea = YES OR TOGGLE-Resumen-Marca = YES 
        THEN RUN Resumen-por-resmat.
        ELSE RUN Resumen-por-producto.
        Control-Resumen = YES.
    END.
    IF TOGGLE-CodCli = NO AND TOGGLE-CodMat = YES AND TOGGLE-CodVen = YES
        THEN DO:
        IF TOGGLE-Resumen-Linea = YES OR TOGGLE-Resumen-Marca = YES 
        THEN DO:
            RUN Resumen-por-resmat.
            Control-Resumen = YES.
        END.
    END.
    IF  TOGGLE-CodCli = NO AND TOGGLE-CodMat = NO AND TOGGLE-CodVen = YES
        THEN DO:
        RUN Resumen-por-vendedor.
        Control-Resumen = YES.
    END.
    IF TOGGLE-CodCli = YES AND TOGGLE-CodMat = NO AND TOGGLE-CodVen = YES
        THEN DO:
        RUN Resumen-por-vendcli.
        Control-Resumen = YES.
    END.

    IF Control-Resumen = NO THEN RUN Resumen-General.
END.
/* PERIODO ANTERIOR Y ACUMULADO */
RUN src/bin/_dateif(MONTH(HastaF), YEAR(HastaF) - 1, OUTPUT x-NroFchR, OUTPUT x-NroFchE).
ASSIGN
    x-NroFchR = DATE(01,01,YEAR(DesdeF) - 1).
DO k = 1 TO NUM-ENTRIES(xListaDivisiones):
    x-CodDiv = ENTRY(1, ENTRY(k, xListaDivisiones), ' - ').
    /* FILTROS */
    IF TOGGLE-CodDiv = YES
        AND ( TOGGLE-CodCli = NO AND TOGGLE-CodMat = NO AND TOGGLE-CodVen = NO )
        THEN DO:
        RUN Resumen-por-division.
        Control-Resumen = YES.
    END.
    IF TOGGLE-CodCli = YES AND TOGGLE-CodMat = NO AND TOGGLE-CodVen = NO
        THEN DO:
        RUN Resumen-por-cliente.
        Control-Resumen = YES.
    END.
    IF TOGGLE-CodCli = YES AND TOGGLE-CodMat = YES AND TOGGLE-CodVen = NO
        THEN DO:
        IF TOGGLE-Resumen-Linea = YES OR TOGGLE-Resumen-Marca = YES 
        THEN DO:
            RUN Resumen-por-climat.
            Control-Resumen = YES.
        END.
    END.
    IF TOGGLE-CodCli = NO AND TOGGLE-CodMat = YES AND TOGGLE-CodVen = NO
        THEN DO:
        IF TOGGLE-Resumen-Linea = YES OR TOGGLE-Resumen-Marca = YES 
        THEN RUN Resumen-por-resmat.
        ELSE RUN Resumen-por-producto.
        Control-Resumen = YES.
    END.
    IF TOGGLE-CodCli = NO AND TOGGLE-CodMat = YES AND TOGGLE-CodVen = YES
        THEN DO:
        IF TOGGLE-Resumen-Linea = YES OR TOGGLE-Resumen-Marca = YES 
        THEN DO:
            RUN Resumen-por-resmat.
            Control-Resumen = YES.
        END.
    END.
    IF  TOGGLE-CodCli = NO AND TOGGLE-CodMat = NO AND TOGGLE-CodVen = YES
        THEN DO:
        RUN Resumen-por-vendedor.
        Control-Resumen = YES.
    END.
    IF TOGGLE-CodCli = YES AND TOGGLE-CodMat = NO AND TOGGLE-CodVen = YES
        THEN DO:
        RUN Resumen-por-vendcli.
        Control-Resumen = YES.
    END.

    IF Control-Resumen = NO THEN RUN Resumen-General.
END.

SESSION:SET-WAIT-STATE('').

/* Revisamos si tiene configurado algunas lineas */
FIND FIRST EstadUserLinea WHERE EstadUserLinea.aplic-id = s-aplic-id
    AND EstadUserLinea.USER-ID = s-user-id
    NO-LOCK NO-ERROR.
IF AVAILABLE EstadUserLinea THEN DO:
    FOR EACH Detalle WHERE Detalle.Linea <> "":
        FIND FIRST EstadUserLinea WHERE EstadUserLinea.aplic-id = s-aplic-id
            AND EstadUserLinea.USER-ID = s-user-id
            AND EstadUserLinea.CodFam = ENTRY(1, Detalle.Linea, ' - ')
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE EstadUserLinea THEN DO:
            ASSIGN
                CtoSolesActual = 0
                CtoDolarActual = 0
                PromSolesActual = 0
                PromDolarActual = 0
                CtoSolesAcumActual = 0
                CtoDolarAcumActual = 0
                PromSolesAcumActual = 0
                PromDolarAcumActual = 0
                CtoSolesAnterior = 0
                CtoDolarAnterior = 0
                PromSolesAnterior = 0
                PromDolarAnterior = 0
                CtoSolesAcumAnterior = 0
                CtoDolarAcumAnterior = 0
                PromSolesAcumAnterior = 0
                PromDolarAcumAnterior = 0.
        END.
    END.
END.
IF s-Familia010 = YES THEN RUN Resumen-por-familia.


/* DEFINIMOS CAMPOS A IMPRIMIR */
/* DEFINIMOS CAMPOS A IMPRIMIR */
ASSIGN
    lOptions = "FieldList:".
/* IF RADIO-SET-Tipo = 2 THEN DO:                           */
/*     ASSIGN                                               */
/*         lOptions = lOptions + 'Campania,Periodo,Nromes'. */
/* END.                                                     */
/* IF RADIO-SET-Tipo = 3 THEN DO:                */
/*     ASSIGN                                    */
/*         lOptions = lOptions + 'Campania,Dia'. */
/* END.                                          */
IF TOGGLE-CodDiv = YES THEN DO:
     ASSIGN
         lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                    'Division,CanalVenta'.
END.
IF TOGGLE-CodCli = YES THEN DO:
    IF TOGGLE-Resumen-Depto = NO THEN DO:
        ASSIGN
            lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                        'Cliente'.
    END.
    ASSIGN
        lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                    'Canal,Departamento,Provincia,Distrito,Zona'.
END.
IF TOGGLE-CodMat = YES THEN DO:
    IF (TOGGLE-Resumen-Linea = NO AND TOGGLE-Resumen-Marca = NO) THEN DO:
         ASSIGN
             lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                        'Producto,Linea,Sublinea,Marca,Unidad'.
    END.
    ELSE DO:
         IF TOGGLE-Resumen-Linea = YES THEN DO:
             ASSIGN
                 lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                            'Linea,Sublinea'.
         END.
         IF TOGGLE-Resumen-Marca = YES THEN DO:
             ASSIGN
                 lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                            'Marca'.
         END.
    END.
    ASSIGN
         lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                    'Licencia,Proveedor'.
END.
IF TOGGLE-CodVen = YES THEN DO:
     ASSIGN
         lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                    'Vendedor'.
END.
ASSIGN
    pOptions = pOptions + CHR(1) + lOptions.
/* CASE COMBO-BOX-Tipo:                                                                     */
/*     WHEN "Cantidades" THEN pOptions = pOptions +                                         */
/*         ',CanActual,CanAcumActual,CanAnterior,CanAcumAnterior'.                          */
/*     WHEN "Ventas" THEN pOptions = pOptions +                                             */
/*         ',VtaSolesActual,VtaDolarActual,VtaSolesAcumActual,VtaDolarAcumActual' +         */
/*         ',VtaSolesAnterior,VtaDolarAnterior,VtaSolesAcumAnterior,VtaDolarAcumAnterior'.  */
/*     WHEN "Ventas vs Costo de Reposicion" THEN pOptions = pOptions +                      */
/*         ',VtaSolesActual,VtaDolarActual,VtaSolesAcumActual,VtaDolarAcumActual' +         */
/*         ',VtaSolesAnterior,VtaDolarAnterior,VtaSolesAcumAnterior,VtaDolarAcumAnterior' + */
/*         ',CtoSolesActual,CtoDolarActual' +                                               */
/*         ',CtoSolesAcumActual,CtoDolarAcumActual' +                                       */
/*         ',CtoSolesAnterior,CtoDolarAnterior' +                                           */
/*         ',CtoSolesAcumAnterior,CtoDolarAcumAnterior'.                                    */
/*     WHEN "Ventas vs Costo Promedio" THEN pOptions = pOptions +                           */
/*         ',VtaSolesActual,VtaDolarActual,VtaSolesAcumActual,VtaDolarAcumActual' +         */
/*         ',VtaSolesAnterior,VtaDolarAnterior,VtaSolesAcumAnterior,VtaDolarAcumAnterior' + */
/*         ',PromSolesActual,PromDolarActual' +                                             */
/*         ',PromSolesAcumActual,PromDolarAcumActual' +                                     */
/*         ',PromSolesAnterior,PromDolarAnterior' +                                         */
/*         ',PromSolesAcumAnterior,PromDolarAcumAnterior'.                                  */
/* END CASE.                                                                                */
IF TOGGLE-CodMat = YES AND (TOGGLE-Resumen-Linea = NO AND TOGGLE-Resumen-Marca = NO) THEN DO:
    ASSIGN
        pOptions = pOptions + ',CanActual,CanAcumActual,CanAnterior,CanAcumAnterior'.
END.
ASSIGN
    pOptions = pOptions + ',VtaSolesActual,VtaSolesAcumActual,VtaSolesAnterior,VtaSolesAcumAnterior'.

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
  DISPLAY FILL-IN-Mensaje DesdeF HastaF TOGGLE-CodDiv COMBO-BOX-CodDiv 
          TOGGLE-CodCli FILL-IN-CodCli FILL-IN-NomCli FILL-IN-file 
          TOGGLE-Resumen-Depto TOGGLE-CodMat COMBO-BOX-CodFam 
          TOGGLE-Resumen-Linea COMBO-BOX-SubFam TOGGLE-Resumen-Marca 
          FILL-IN-CodMat FILL-IN-DesMat FILL-IN-file-2 FILL-IN-CodPro 
          FILL-IN-NomPro TOGGLE-CodVen FILL-IN-CodVen FILL-IN-NomVen 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE RECT-1 RECT-2 RECT-3 RECT-4 RECT-5 BUTTON-1 BtnDone DesdeF HastaF 
         TOGGLE-CodDiv TOGGLE-CodCli TOGGLE-CodMat TOGGLE-CodVen 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-2 wWin 
PROCEDURE Excel-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR i-Campo AS INT INIT 1 NO-UNDO.
DEF VAR x-Campo AS CHAR NO-UNDO.
DEF VAR x-Cuenta-Registros AS INT INIT 0 NO-UNDO.

FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL **".

EMPTY TEMP-TABLE Detalle.
FOR EACH tmp-detalle:
    i-Campo = 1.
    CREATE Detalle.
/*     IF RADIO-SET-Tipo = 2 THEN DO:                        */
/*         x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|'). */
/*         Detalle.Campania = x-Campo.                       */
/*         i-Campo = i-Campo + 1.                            */
/*         x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|'). */
/*         Detalle.Periodo = INTEGER(x-Campo).               */
/*         i-Campo = i-Campo + 1.                            */
/*         x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|'). */
/*         Detalle.NroMes =INTEGER(x-Campo).                 */
/*         i-Campo = i-Campo + 1.                            */
/*     END.                                                  */
    IF TOGGLE-CodDiv = YES THEN DO:
        /* DIVISION */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        Detalle.Division = x-Campo.
        i-Campo = i-Campo + 1.
        /* CANAL VENTA */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        Detalle.CanalVenta = x-Campo.
        i-Campo = i-Campo + 1.
    END.
    IF TOGGLE-CodCli = YES THEN DO:
        /* CLIENTE */
        IF TOGGLE-Resumen-Depto = NO THEN DO:
            x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
            Detalle.Cliente = x-Campo.
            i-Campo = i-Campo + 1.
        END.
        /* CANAL DEL CLIENTE */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        Detalle.Canal = x-Campo.
        i-Campo = i-Campo + 1.
        /* TARJETA CLIENTE EXCLUSIVO */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        Detalle.Tarjeta = x-Campo.
        i-Campo = i-Campo + 1.
        /* DEPARTAMENTO */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        Detalle.Departamento = x-Campo.
        i-Campo = i-Campo + 1.
        /* PROVINCIA */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        Detalle.Provincia = x-Campo.
        i-Campo = i-Campo + 1.
        /* DISTRITO */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        Detalle.Distrito = x-Campo.
        i-Campo = i-Campo + 1.
        /* ZONA */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        Detalle.Zona = x-Campo.
        i-Campo = i-Campo + 1.
        /* CLASIFICACION */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        Detalle.Clasificacion = x-Campo.
        i-Campo = i-Campo + 1.
    END.
    IF TOGGLE-CodMat = YES THEN DO:
        /* ARTICULO */
        IF (TOGGLE-Resumen-Linea = NO AND TOGGLE-Resumen-Marca = NO) THEN DO:
            x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
            Detalle.Producto = x-Campo.
            i-Campo = i-Campo + 1.
            /* LINEA */
            x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
            Detalle.Linea = x-Campo.
            i-Campo = i-Campo + 1.
            /* SUB-LINEA */
            x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
            Detalle.SubLinea = x-Campo.
            i-Campo = i-Campo + 1.
            /* MARCA */
            x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
            Detalle.Marca = x-Campo.
            i-Campo = i-Campo + 1.
            /* UNIDAD */
            x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
            Detalle.Unidad = x-Campo.
            i-Campo = i-Campo + 1.
        END.
        ELSE DO:
            IF TOGGLE-Resumen-Linea = YES THEN DO:
                /* LINEA */
                x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
                Detalle.Linea = x-Campo.
                i-Campo = i-Campo + 1.
                /* SUB-LINEA */
                x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
                Detalle.SubLinea = x-Campo.
                i-Campo = i-Campo + 1.
            END.
            IF TOGGLE-Resumen-Marca = YES THEN DO:
                /* MARCA */
                x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
                Detalle.Marca = x-Campo.
                i-Campo = i-Campo + 1.
            END.
        END.
        /* LICENCIA */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        Detalle.Licencia = x-Campo.
        i-Campo = i-Campo + 1.
        /* PROVEEDOR */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        Detalle.Proveedor = x-Campo.
        i-Campo = i-Campo + 1.
    END.
    IF TOGGLE-CodVen = YES THEN DO:
        /* VENDEDOR */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        Detalle.Vendedor = x-Campo.
        i-Campo = i-Campo + 1.
    END.
    Detalle.CanActual = tmp-detalle.CanxMes[1].
    Detalle.CanAnterior = tmp-detalle.CanxMes[3].
    Detalle.CanAcumActual = tmp-detalle.CanxMes[2].
    Detalle.CanAcumAnterior = tmp-detalle.CanxMes[4].
    Detalle.VtaDolarActual = tmp-detalle.VtaxMesMe[1].
    Detalle.VtaSolesActual = tmp-detalle.VtaxMesMn[1].
    Detalle.VtaDolarAnterior = tmp-detalle.VtaxMesMe[3].
    Detalle.VtaSolesAnterior = tmp-detalle.VtaxMesMn[3].
    Detalle.VtaDolarAcumActual = tmp-detalle.VtaxMesMe[2].
    Detalle.VtaSolesAcumActual = tmp-detalle.VtaxMesMn[2].
    Detalle.VtaDolarAcumAnterior = tmp-detalle.VtaxMesMe[4].
    Detalle.VtaSolesAcumAnterior = tmp-detalle.VtaxMesMn[4].
    Detalle.CtoDolarActual = tmp-detalle.CtoxMesMe[1].
    Detalle.CtoSolesActual = tmp-detalle.CtoxMesMn[1].
    Detalle.CtoDolarAnterior = tmp-detalle.CtoxMesMe[3].
    Detalle.CtoSolesAnterior = tmp-detalle.CtoxMesMn[3].
    Detalle.CtoDolarAcumActual = tmp-detalle.CtoxMesMe[2].
    Detalle.CtoSolesAcumActual = tmp-detalle.CtoxMesMn[2].
    Detalle.CtoDolarAcumAnterior = tmp-detalle.CtoxMesMe[4].
    Detalle.CtoSolesAcumAnterior = tmp-detalle.CtoxMesMn[4].
    Detalle.PromDolarActual = tmp-detalle.ProxMesMe[1].
    Detalle.PromSolesActual = tmp-detalle.ProxMesMn[1].
    Detalle.PromDolarAnterior = tmp-detalle.ProxMesMe[3].
    Detalle.PromSolesAnterior = tmp-detalle.ProxMesMn[3].
    Detalle.PromDolarAcumActual = tmp-detalle.ProxMesMe[2].
    Detalle.PromSolesAcumActual = tmp-detalle.ProxMesMn[2].
    Detalle.PromDolarAcumAnterior = tmp-detalle.ProxMesMe[4].
    Detalle.PromSolesAcumAnterior = tmp-detalle.ProxMesMn[4].
/*     IF COMBO-BOX-Tipo = "Cantidades" THEN DO:                     */
/*         Detalle.CanActual = tmp-detalle.CanxMes[1].               */
/*         Detalle.CanAnterior = tmp-detalle.CanxMes[3].             */
/*         Detalle.CanAcumActual = tmp-detalle.CanxMes[2].           */
/*         Detalle.CanAcumAnterior = tmp-detalle.CanxMes[4].         */
/*     END.                                                          */
/*     IF COMBO-BOX-Tipo BEGINS "Ventas" THEN DO:                    */
/*         Detalle.VtaDolarActual = tmp-detalle.VtaxMesMe[1].        */
/*         Detalle.VtaSolesActual = tmp-detalle.VtaxMesMn[1].        */
/*         Detalle.VtaDolarAnterior = tmp-detalle.VtaxMesMe[3].      */
/*         Detalle.VtaSolesAnterior = tmp-detalle.VtaxMesMn[3].      */
/*         Detalle.VtaDolarAcumActual = tmp-detalle.VtaxMesMe[2].    */
/*         Detalle.VtaSolesAcumActual = tmp-detalle.VtaxMesMn[2].    */
/*         Detalle.VtaDolarAcumAnterior = tmp-detalle.VtaxMesMe[4].  */
/*         Detalle.VtaSolesAcumAnterior = tmp-detalle.VtaxMesMn[4].  */
/*     END.                                                          */
/*     IF COMBO-BOX-Tipo = "Ventas vs Costo de Reposicion" THEN DO:  */
/*         Detalle.CtoDolarActual = tmp-detalle.CtoxMesMe[1].        */
/*         Detalle.CtoSolesActual = tmp-detalle.CtoxMesMn[1].        */
/*         Detalle.CtoDolarAnterior = tmp-detalle.CtoxMesMe[3].      */
/*         Detalle.CtoSolesAnterior = tmp-detalle.CtoxMesMn[3].      */
/*         Detalle.CtoDolarAcumActual = tmp-detalle.CtoxMesMe[2].    */
/*         Detalle.CtoSolesAcumActual = tmp-detalle.CtoxMesMn[2].    */
/*         Detalle.CtoDolarAcumAnterior = tmp-detalle.CtoxMesMe[4].  */
/*         Detalle.CtoSolesAcumAnterior = tmp-detalle.CtoxMesMn[4].  */
/*     END.                                                          */
/*     IF COMBO-BOX-Tipo = "Ventas vs Costo Promedio" THEN DO:       */
/*         Detalle.PromDolarActual = tmp-detalle.ProxMesMe[1].       */
/*         Detalle.PromSolesActual = tmp-detalle.ProxMesMn[1].       */
/*         Detalle.PromDolarAnterior = tmp-detalle.ProxMesMe[3].     */
/*         Detalle.PromSolesAnterior = tmp-detalle.ProxMesMn[3].     */
/*         Detalle.PromDolarAcumActual = tmp-detalle.ProxMesMe[2].   */
/*         Detalle.PromSolesAcumActual = tmp-detalle.ProxMesMn[2].   */
/*         Detalle.PromDolarAcumAnterior = tmp-detalle.ProxMesMe[4]. */
/*         Detalle.PromSolesAcumAnterior = tmp-detalle.ProxMesMn[4]. */
/*     END.                                                          */
END.

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
  ASSIGN
      DesdeF = TODAY - DAY(TODAY) + 1
      HastaF = TODAY
      cListaDivisiones = 'Todos'.
  /* Bucamos si tiene divisiones registradas */
  FIND FIRST estavtas.EstadUserDiv WHERE estavtas.EstadUserDiv.user-id = s-user-id
      AND estavtas.EstadUserDiv.aplic-id = s-aplic-id
      NO-LOCK NO-ERROR.
  IF AVAILABLE EstadUserDiv THEN DO:
      FOR EACH EstadUserDiv NO-LOCK WHERE EstadUserDiv.user-id = s-user-id
          AND EstadUserDiv.aplic-id = s-aplic-id,
          FIRST DimDivision OF EstadUserDiv NO-LOCK:
          cListaDivisiones = cListaDivisiones  + ',' + (DimDivision.coddiv + ' - ' + DimDivision.DesDiv).
      END.
  END.
  ELSE DO:
      FOR EACH DimDivision NO-LOCK:
          cListaDivisiones = cListaDivisiones  + ',' + (DimDivision.coddiv + ' - ' + DimDivision.DesDiv).
      END.
  END.
  COMBO-BOX-CodDiv:ADD-LAST(cListaDivisiones) IN FRAME {&FRAME-NAME}.
  COMBO-BOX-CodDiv = COMBO-BOX-CodDiv:ENTRY(1) IN FRAME {&FRAME-NAME}.

  FOR EACH DimLinea NO-LOCK BREAK BY DimLinea.codfam:
      IF FIRST-OF(DimLinea.codfam) THEN
      COMBO-BOX-CodFam:ADD-LAST(DimLinea.codfam + ' - ' + DimLinea.nomfam) IN FRAME {&FRAME-NAME}.
  END.
/*   CASE pParametro:                                                                                                                 */
/*       WHEN "+COSTO" THEN COMBO-BOX-Tipo:ADD-LAST("Ventas vs Costo de Reposicion,Ventas vs Costo Promedio") IN FRAME {&FRAME-NAME}. */
/*       WHEN "-COSTO" THEN COMBO-BOX-Tipo:ADD-LAST("Ventas") IN FRAME {&FRAME-NAME}.                                                 */
/*   END CASE.                                                                                                                        */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resumen-General wWin 
PROCEDURE Resumen-General :
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
        {est/resumengeneral-com.i}
        ASSIGN
            iContador = 0
            x-CodCli = ''.
    END.
END.
IF iContador > 0 THEN DO:
    {est/resumengeneral-com.i}
END.

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
        {est/resumenxcliente-com.i}
        ASSIGN
            iContador = 0
            x-CodCli = ''.
    END.
END.
IF iContador > 0 THEN DO:
    {est/resumenxcliente-com.i}
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
        {est/resumenxclimat-com.i}
        ASSIGN
            iContador = 0
            x-CodCli = ''.
    END.
END.
IF iContador > 0 THEN DO:
    {est/resumenxclimat-com.i}
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

/* ASSIGN                                         */
/*     x-NroFchR = DATE(01, 01, YEAR(DesdeF) - 1) */
/*     x-NroFchE = HastaF.                        */
FOR EACH VentasxVendedor NO-LOCK WHERE VentasxVendedor.DateKey >= x-NroFchR
    AND VentasxVendedor.DateKey <= x-NroFchE
    AND VentasxVendedor.coddiv BEGINS x-CodDiv,
    FIRST DimDivision OF VentasxVendedor NO-LOCK,
    FIRST DimFecha WHERE DimFecha.DateKey = VentasxVendedor.DateKey NO-LOCK:
    IF x-CuentaReg = 0 OR ( x-CuentaReg MODULO x-MuestraReg ) = 0 THEN
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** TABLA POR DIVISION ' + 
        ' FECHA ' + STRING (DAY(DimFecha.DateKey), '99') +
        ' ' + DimFecha.CalendarMonthLabel + ' ' + DimFecha.CalendarYearLabel +
        ' DIVISION ' + VentasxVendedor.coddiv + ' **'.
    x-CuentaReg = x-CuentaReg + 1.
    /* ARMAMOS LA LLAVE */
    ASSIGN
        T-Vtamn   = 0
        T-Vtame   = 0
        T-Ctomn   = 0
        T-Ctome   = 0
        T-Promn   = 0
        T-Prome   = 0
        F-Salida  = 0.
    x-Llave = ''.
    x-Fecha = VentasxVendedor.DateKey.
    /* PERIODO ACTUAL */
    IF x-Fecha >= DesdeF AND x-Fecha <= HastaF THEN DO:
        ASSIGN
            /*F-Salida[1]  = F-Salida[1]  + VentasxVendedor.Cantidad*/
            T-Vtamn[1]   = T-Vtamn[1]   + VentasxVendedor.ImpNacCIGV
            T-Vtame[1]   = T-Vtame[1]   + VentasxVendedor.ImpExtCIGV
            T-Ctomn[1]   = T-Ctomn[1]   + VentasxVendedor.CostoNacCIGV
            T-Ctome[1]   = T-Ctome[1]   + VentasxVendedor.CostoExtCIGV
            T-Promn[1]   = T-Promn[1]   + VentasxVendedor.PromNacCIGV
            T-Prome[1]   = T-Prome[1]   + VentasxVendedor.PromExtCIGV.
    END.
    /* ACUMULADO PERIODO ACTUAL */
    IF x-Fecha >= DATE(01,01,YEAR(DesdeF)) AND x-Fecha <= HastaF THEN DO:
        ASSIGN
            /*F-Salida[2]  = F-Salida[2]  + VentasxVendedor.Cantidad*/
            T-Vtamn[2]   = T-Vtamn[2]   + VentasxVendedor.ImpNacCIGV
            T-Vtame[2]   = T-Vtame[2]   + VentasxVendedor.ImpExtCIGV
            T-Ctomn[2]   = T-Ctomn[2]   + VentasxVendedor.CostoNacCIGV
            T-Ctome[2]   = T-Ctome[2]   + VentasxVendedor.CostoExtCIGV
            T-Promn[2]   = T-Promn[2]   + VentasxVendedor.PromNacCIGV
            T-Prome[2]   = T-Prome[2]   + VentasxVendedor.PromExtCIGV.
    END.
    /* PERIODO ANTERIOR */
    IF x-Fecha >= DATE(MONTH(DesdeF),DAY(DesdeF),YEAR(DesdeF) - 1) AND x-Fecha <= DATE(MONTH(HastaF),DAY(HastaF),YEAR(HastaF) - 1) THEN DO:
        ASSIGN
            /*F-Salida[3]  = F-Salida[3]  + VentasxVendedor.Cantidad*/
            T-Vtamn[3]   = T-Vtamn[3]   + VentasxVendedor.ImpNacCIGV
            T-Vtame[3]   = T-Vtame[3]   + VentasxVendedor.ImpExtCIGV
            T-Ctomn[3]   = T-Ctomn[3]   + VentasxVendedor.CostoNacCIGV
            T-Ctome[3]   = T-Ctome[3]   + VentasxVendedor.CostoExtCIGV
            T-Promn[3]   = T-Promn[3]   + VentasxVendedor.PromNacCIGV
            T-Prome[3]   = T-Prome[3]   + VentasxVendedor.PromExtCIGV.
    END.
    /* ACUMULADO PERIODO ANTERIOR */
    IF x-Fecha >= DATE(01,01,YEAR(DesdeF) - 1) AND x-Fecha <= DATE(MONTH(HastaF),DAY(HastaF),YEAR(HastaF) - 1) THEN DO:
        ASSIGN
            /*F-Salida[4]  = F-Salida[4]  + VentasxVendedor.Cantidad*/
            T-Vtamn[4]   = T-Vtamn[4]   + VentasxVendedor.ImpNacCIGV
            T-Vtame[4]   = T-Vtame[4]   + VentasxVendedor.ImpExtCIGV
            T-Ctomn[4]   = T-Ctomn[4]   + VentasxVendedor.CostoNacCIGV
            T-Ctome[4]   = T-Ctome[4]   + VentasxVendedor.CostoExtCIGV
            T-Promn[4]   = T-Promn[4]   + VentasxVendedor.PromNacCIGV
            T-Prome[4]   = T-Prome[4]   + VentasxVendedor.PromExtCIGV.
    END.
    /* LLAVE INICIAL */
/*     IF RADIO-SET-Tipo = 2 THEN DO:                                  */
/*         IF x-Llave = '' THEN x-Llave = DimFecha.Campania.           */
/*         ELSE x-Llave = x-Llave + DimFecha.Campania.                 */
/*         x-Llave = x-Llave + '|'.                                    */
/*         x-Llave = x-Llave + STRING(YEAR(DimFecha.DateKey), '9999'). */
/*         x-Llave = x-Llave + '|'.                                    */
/*         x-Llave = x-Llave + STRING(MONTH(DimFecha.DateKey), '99').  */
/*         x-Llave = x-LLave + '|'.                                    */
/*     END.                                                            */
    IF TOGGLE-CodDiv THEN DO:
         IF x-Llave = '' THEN x-Llave = VentasxVendedor.coddiv.
         ELSE x-Llave = x-LLave + VentasxVendedor.coddiv.
         x-Llave = x-Llave + ' - ' + DimDivision.DesDiv + '|'.
         x-Llave = x-Llave + DimDivision.CanalVenta + ' - ' + DimDivision.NomCanalVenta + '|'.
    END.
    /* ******************************************** */
    FIND tmp-detalle WHERE tmp-detalle.llave = x-Llave NO-ERROR.
    IF NOT AVAILABLE tmp-detalle THEN DO:
         CREATE tmp-detalle.
         tmp-detalle.llave = x-Llave.
    END.
    ASSIGN
         tmp-detalle.CanxMes[1]   = tmp-detalle.CanxMes[1]   + f-Salida[1]
         tmp-detalle.VtaxMesMe[1] = tmp-detalle.VtaxMesMe[1] + T-Vtame[1]
         tmp-detalle.VtaxMesMn[1] = tmp-detalle.VtaxMesMn[1] + T-Vtamn[1]
         tmp-detalle.CtoxMesMe[1] = tmp-detalle.CtoxMesMe[1] + T-Ctome[1]
         tmp-detalle.CtoxMesMn[1] = tmp-detalle.CtoxMesMn[1] + T-Ctomn[1]
         tmp-detalle.ProxMesMe[1] = tmp-detalle.ProxMesMe[1] + T-Prome[1]
         tmp-detalle.ProxMesMn[1] = tmp-detalle.ProxMesMn[1] + T-Promn[1]
         tmp-detalle.CanxMes[2]   = tmp-detalle.CanxMes[2]   + f-Salida[2]
         tmp-detalle.VtaxMesMe[2] = tmp-detalle.VtaxMesMe[2] + T-Vtame[2]
         tmp-detalle.VtaxMesMn[2] = tmp-detalle.VtaxMesMn[2] + T-Vtamn[2]
         tmp-detalle.CtoxMesMe[2] = tmp-detalle.CtoxMesMe[2] + T-Ctome[2]
         tmp-detalle.CtoxMesMn[2] = tmp-detalle.CtoxMesMn[2] + T-Ctomn[2]
         tmp-detalle.ProxMesMe[2] = tmp-detalle.ProxMesMe[2] + T-Prome[2]
         tmp-detalle.ProxMesMn[2] = tmp-detalle.ProxMesMn[2] + T-Promn[2]
         tmp-detalle.CanxMes[3]   = tmp-detalle.CanxMes[3]   + f-Salida[3]
         tmp-detalle.VtaxMesMe[3] = tmp-detalle.VtaxMesMe[3] + T-Vtame[3]
         tmp-detalle.VtaxMesMn[3] = tmp-detalle.VtaxMesMn[3] + T-Vtamn[3]
         tmp-detalle.CtoxMesMe[3] = tmp-detalle.CtoxMesMe[3] + T-Ctome[3]
         tmp-detalle.CtoxMesMn[3] = tmp-detalle.CtoxMesMn[3] + T-Ctomn[3]
         tmp-detalle.ProxMesMe[3] = tmp-detalle.ProxMesMe[3] + T-Prome[3]
         tmp-detalle.ProxMesMn[3] = tmp-detalle.ProxMesMn[3] + T-Promn[3]
         tmp-detalle.CanxMes[4]   = tmp-detalle.CanxMes[4]   + f-Salida[4]
         tmp-detalle.VtaxMesMe[4] = tmp-detalle.VtaxMesMe[4] + T-Vtame[4]
         tmp-detalle.VtaxMesMn[4] = tmp-detalle.VtaxMesMn[4] + T-Vtamn[4]
         tmp-detalle.CtoxMesMe[4] = tmp-detalle.CtoxMesMe[4] + T-Ctome[4]
         tmp-detalle.CtoxMesMn[4] = tmp-detalle.CtoxMesMn[4] + T-Ctomn[4]
         tmp-detalle.ProxMesMe[4] = tmp-detalle.ProxMesMe[4] + T-Prome[4]
         tmp-detalle.ProxMesMn[4] = tmp-detalle.ProxMesMn[4] + T-Promn[4].
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
/*         T-Detalle.Dia = Detalle.Dia AND */
        T-Detalle.Division = Detalle.Division AND
/*         T-Detalle.Destino = Detalle.Destino AND */
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
/*         T-Detalle.Tipo = Detalle.Tipo AND */
        T-Detalle.Vendedor = Detalle.Vendedor /*AND*/
/*         T-Detalle.SubTipo = Detalle.SubTipo AND */
/*         T-Detalle.CodAsoc = Detalle.CodAsoc     */
        NO-ERROR.
    IF NOT AVAILABLE T-Detalle THEN CREATE T-Detalle.
    BUFFER-COPY Detalle
/*         EXCEPT Detalle.CodAsoc */
        TO T-Detalle
        ASSIGN
            T-Detalle.Producto = "999998 RESUMIDO FAMILIA 010"
            T-Detalle.Unidad   = "UNI"
            T-Detalle.CanActual = T-Detalle.CanActual + Detalle.CanActual
            T-Detalle.CanAcumActual = T-Detalle.CanAcumActual + Detalle.CanAcumActual
            T-Detalle.CanAnterior = T-Detalle.CanAnterior + Detalle.CanAnterior
            T-Detalle.CanAcumAnterior = T-Detalle.CanAcumAnterior + Detalle.CanAcumAnterior
            T-Detalle.VtaSolesActual = T-Detalle.VtaSolesActual + Detalle.VtaSolesActual
            T-Detalle.VtaDolarActual = T-Detalle.VtaDolarActual + Detalle.VtaDolarActual
            T-Detalle.CtoSolesActual = T-Detalle.CtoSolesActual + Detalle.CtoSolesActual
            T-Detalle.CtoDolarActual = T-Detalle.CtoDolarActual + Detalle.CtoDolarActual
            T-Detalle.PromSolesActual = T-Detalle.PromSolesActual + Detalle.PromSolesActual
            T-Detalle.PromDolarActual = T-Detalle.PromSolesActual + Detalle.PromSolesActual
            T-Detalle.VtaSolesAcumActual = T-Detalle.VtaSolesAcumActual + Detalle.VtaSolesAcumActual
            T-Detalle.VtaDolarAcumActual = T-Detalle.VtaDolarAcumActual + Detalle.VtaDolarAcumActual
            T-Detalle.CtoSolesAcumActual = T-Detalle.CtoSolesAcumActual + Detalle.CtoSolesAcumActual
            T-Detalle.CtoDolarAcumActual = T-Detalle.CtoSolesAcumActual + Detalle.CtoSolesAcumActual
            T-Detalle.PromSolesAcumActual = T-Detalle.CtoSolesAcumActual + Detalle.CtoSolesAcumActual
            T-Detalle.PromDolarAcumActual = T-Detalle.PromDolarAcumActual + Detalle.PromDolarAcumActual
            T-Detalle.VtaSolesAnterior = T-Detalle.VtaSolesAnterior + Detalle.VtaSolesAnterior
            T-Detalle.VtaDolarAnterior = T-Detalle.VtaSolesAnterior + Detalle.VtaSolesAnterior
            T-Detalle.CtoSolesAnterior = T-Detalle.VtaSolesAnterior + Detalle.VtaSolesAnterior
            T-Detalle.CtoDolarAnterior = T-Detalle.CtoDolarAnterior + Detalle.CtoDolarAnterior
            T-Detalle.PromSolesAnterior = T-Detalle.PromSolesAnterior + Detalle.PromSolesAnterior
            T-Detalle.PromDolarAnterior = T-Detalle.PromDolarAnterior + Detalle.PromDolarAnterior
            T-Detalle.VtaSolesAcumAnterior = T-Detalle.VtaSolesAcumAnterior + Detalle.VtaSolesAcumAnterior
            T-Detalle.VtaDolarAcumAnterior = T-Detalle.VtaDolarAcumAnterior + Detalle.VtaDolarAcumAnterior
            T-Detalle.CtoSolesAcumAnterior = T-Detalle.CtoSolesAcumAnterior + Detalle.CtoSolesAcumAnterior
            T-Detalle.CtoDolarAcumAnterior = T-Detalle.CtoDolarAcumAnterior + Detalle.CtoDolarAcumAnterior
            T-Detalle.PromSolesAcumAnterior = T-Detalle.PromSolesAcumAnterior + Detalle.PromSolesAcumAnterior
            T-Detalle.PromDolarAcumAnterior = T-Detalle.PromDolarAcumAnterior + Detalle.PromDolarAcumAnterior.
    DELETE Detalle.
END.

FOR EACH T-Detalle NO-LOCK:
    CREATE Detalle.
    BUFFER-COPY T-Detalle TO Detalle.
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

/* ASSIGN                                         */
/*     x-NroFchR = DATE(01, 01, YEAR(DesdeF) - 1) */
/*     x-NroFchE = HastaF.                        */

FOR EACH VentasxProducto NO-LOCK WHERE VentasxProducto.DateKey >= x-NroFchR
    AND VentasxProducto.DateKey <= x-NroFchE
    AND VentasxProducto.coddiv BEGINS x-CodDiv
    AND ( x-CodMat = '' OR LOOKUP (VentasxProducto.codmat, x-CodMat) > 0 ),
    FIRST DimDivision OF VentasxProducto NO-LOCK,
    FIRST DimProducto OF VentasxProducto NO-LOCK WHERE DimProducto.codfam BEGINS x-CodFam
    AND (x-CodPro = '' OR DimProducto.CodPro[1] = x-CodPro)
    AND (x-SubFam = '' OR DimProducto.subfam BEGINS x-SubFam),
    FIRST DimLinea OF DimProducto NO-LOCK,
    FIRST DimSubLinea OF DimProducto NO-LOCK,
    FIRST DimFecha WHERE DimFecha.DateKey = VentasxProducto.DateKey NO-LOCK:
    IF x-CuentaReg = 0 OR ( x-CuentaReg MODULO x-MuestraReg ) = 0 THEN
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** TABLA POR PRODUCTO ' + 
        ' FECHA ' + STRING (DAY(DimFecha.DateKey), '99') +
        ' ' + DimFecha.CalendarMonthLabel + ' ' + STRING (YEAR(DimFecha.DateKey), '9999') +
        ' DIVISION ' + VentasxProducto.coddiv + ' PRODUCTO ' + VentasxProducto.codmat + ' **'.
    x-CuentaReg = x-CuentaReg + 1.
    /* ARMAMOS LA LLAVE */
    ASSIGN
        T-Vtamn   = 0
        T-Vtame   = 0
        T-Ctomn   = 0
        T-Ctome   = 0
        T-Promn   = 0
        T-Prome   = 0
        F-Salida  = 0.
    x-Llave = ''.
    x-Fecha = VentasxProducto.DateKey.
    /* PERIODO ACTUAL */
    IF x-Fecha >= DesdeF AND x-Fecha <= HastaF THEN DO:
        ASSIGN
            F-Salida[1]  = F-Salida[1]  + VentasxProducto.Cantidad
            T-Vtamn[1]   = T-Vtamn[1]   + VentasxProducto.ImpNacCIGV
            T-Vtame[1]   = T-Vtame[1]   + VentasxProducto.ImpExtCIGV
            T-Ctomn[1]   = T-Ctomn[1]   + VentasxProducto.CostoNacCIGV
            T-Ctome[1]   = T-Ctome[1]   + VentasxProducto.CostoExtCIGV
            T-Promn[1]   = T-Promn[1]   + VentasxProducto.PromNacCIGV
            T-Prome[1]   = T-Prome[1]   + VentasxProducto.PromExtCIGV.
    END.
    /* ACUMULADO PERIODO ACTUAL */
    IF x-Fecha >= DATE(01,01,YEAR(DesdeF)) AND x-Fecha <= HastaF THEN DO:
        ASSIGN
            F-Salida[2]  = F-Salida[2]  + VentasxProducto.Cantidad
            T-Vtamn[2]   = T-Vtamn[2]   + VentasxProducto.ImpNacCIGV
            T-Vtame[2]   = T-Vtame[2]   + VentasxProducto.ImpExtCIGV
            T-Ctomn[2]   = T-Ctomn[2]   + VentasxProducto.CostoNacCIGV
            T-Ctome[2]   = T-Ctome[2]   + VentasxProducto.CostoExtCIGV
            T-Promn[2]   = T-Promn[2]   + VentasxProducto.PromNacCIGV
            T-Prome[2]   = T-Prome[2]   + VentasxProducto.PromExtCIGV.
    END.
    /* PERIODO ANTERIOR */
    IF x-Fecha >= DATE(MONTH(DesdeF),DAY(DesdeF),YEAR(DesdeF) - 1) AND x-Fecha <= DATE(MONTH(HastaF),DAY(HastaF),YEAR(HastaF) - 1) THEN DO:
        ASSIGN
            F-Salida[3]  = F-Salida[3]  + VentasxProducto.Cantidad
            T-Vtamn[3]   = T-Vtamn[3]   + VentasxProducto.ImpNacCIGV
            T-Vtame[3]   = T-Vtame[3]   + VentasxProducto.ImpExtCIGV
            T-Ctomn[3]   = T-Ctomn[3]   + VentasxProducto.CostoNacCIGV
            T-Ctome[3]   = T-Ctome[3]   + VentasxProducto.CostoExtCIGV
            T-Promn[3]   = T-Promn[3]   + VentasxProducto.PromNacCIGV
            T-Prome[3]   = T-Prome[3]   + VentasxProducto.PromExtCIGV.
    END.
    /* ACUMULADO PERIODO ANTERIOR */
    IF x-Fecha >= DATE(01,01,YEAR(DesdeF) - 1) AND x-Fecha <= DATE(MONTH(HastaF),DAY(HastaF),YEAR(HastaF) - 1) THEN DO:
        ASSIGN
            F-Salida[4]  = F-Salida[4]  + VentasxProducto.Cantidad
            T-Vtamn[4]   = T-Vtamn[4]   + VentasxProducto.ImpNacCIGV
            T-Vtame[4]   = T-Vtame[4]   + VentasxProducto.ImpExtCIGV
            T-Ctomn[4]   = T-Ctomn[4]   + VentasxProducto.CostoNacCIGV
            T-Ctome[4]   = T-Ctome[4]   + VentasxProducto.CostoExtCIGV
            T-Promn[4]   = T-Promn[4]   + VentasxProducto.PromNacCIGV
            T-Prome[4]   = T-Prome[4]   + VentasxProducto.PromExtCIGV.
    END.
    /* LLAVE INICIAL */
/*     IF RADIO-SET-Tipo = 2 THEN DO:                                                              */
/*         IF x-Llave = '' THEN x-Llave = DimFecha.Campania.                                       */
/*         ELSE x-Llave = x-Llave + DimFecha.Campania.                                             */
/*         x-Llave = x-Llave + '|'.                                                                */
/*         x-Llave = x-Llave + STRING(YEAR(DimFecha.DateKey), '9999').                             */
/*         x-Llave = x-Llave + '|'.                                                                */
/*         x-Llave = x-Llave + STRING(MONTH(DimFecha.DateKey), '99').      /*DimFecha.NombreMes.*/ */
/*         x-Llave = x-LLave + '|'.                                                                */
/*     END.                                                                                        */
    IF TOGGLE-CodDiv THEN DO:
         IF x-Llave = '' THEN x-Llave = VentasxProducto.coddiv + ' - ' + DimDivision.DesDiv + '|'.
         ELSE x-Llave = x-LLave + VentasxProducto.coddiv + ' - ' + DimDivision.DesDiv + '|'.
         x-Llave = x-Llave + DimDivision.CanalVenta + ' - ' + DimDivision.NomCanalVenta + '|'.
    END.
    IF TOGGLE-CodMat = YES THEN DO:
        IF (TOGGLE-Resumen-Linea = NO AND TOGGLE-Resumen-Marca = NO) THEN DO:
            IF x-Llave = '' THEN x-Llave = VentasxProducto.codmat + ' - ' + DimProducto.DesMat + '|'.
            ELSE x-Llave = x-Llave + VentasxProducto.codmat + ' - ' + DimProducto.DesMat + '|'.
            x-Llave = x-Llave + DimProducto.codfam + ' - ' + DimLinea.NomFam + '|'.
            x-Llave = x-Llave + DimProducto.subfam + ' - ' + DimSubLinea.NomSubFam + '|'.
            x-Llave = x-Llave + DimProducto.desmar + '|'.
            x-Llave = x-Llave + DimProducto.UndStk + '|'.
         END.
         ELSE DO:
             IF TOGGLE-Resumen-Linea = YES THEN DO:
                 IF x-Llave = '' THEN x-Llave = DimProducto.codfam + ' - ' + DimLinea.NomFam + '|'.
                 ELSE x-Llave = x-Llave + DimProducto.codfam + ' - ' + DimLinea.NomFam + '|'.
                 x-Llave = x-Llave + DimProducto.subfam + ' - ' + DimSubLinea.NomSubFam + '|'.
             END.
             IF TOGGLE-Resumen-Marca = YES THEN DO:
                 IF x-Llave = '' THEN x-Llave = DimProducto.desmar + '|'.
                 ELSE x-Llave = x-Llave + DimProducto.desmar + '|'.
             END.
         END.
         FIND DimLicencia OF DimProducto NO-LOCK NO-ERROR.
         IF AVAILABLE DimLicencia THEN x-Llave = x-Llave + DimProducto.licencia + ' - ' + DimLicencia.Descripcion + '|'.
         ELSE x-Llave = x-Llave + DimProducto.licencia + '|'.
         FIND DimProveedor WHERE DimProveedor.CodPro = DimProducto.CodPro[1] NO-LOCK NO-ERROR.
         IF AVAILABLE DimProveedor THEN x-Llave = x-Llave + DimProducto.codpro[1] + ' - ' + DimProveedor.NomPro + '|'.
         ELSE x-Llave = x-Llave + DimProducto.codpro[1] + '|'.
     END.
     /* ******************************************** */
     FIND tmp-detalle WHERE tmp-detalle.llave = x-Llave NO-ERROR.
     IF NOT AVAILABLE tmp-detalle THEN DO:
         CREATE tmp-detalle.
         tmp-detalle.llave = x-Llave.
     END.
     ASSIGN
         tmp-detalle.CanxMes[1]   = tmp-detalle.CanxMes[1]   + f-Salida[1]
         tmp-detalle.VtaxMesMe[1] = tmp-detalle.VtaxMesMe[1] + T-Vtame[1]
         tmp-detalle.VtaxMesMn[1] = tmp-detalle.VtaxMesMn[1] + T-Vtamn[1]
         tmp-detalle.CtoxMesMe[1] = tmp-detalle.CtoxMesMe[1] + T-Ctome[1]
         tmp-detalle.CtoxMesMn[1] = tmp-detalle.CtoxMesMn[1] + T-Ctomn[1]
         tmp-detalle.ProxMesMe[1] = tmp-detalle.ProxMesMe[1] + T-Prome[1]
         tmp-detalle.ProxMesMn[1] = tmp-detalle.ProxMesMn[1] + T-Promn[1]
         tmp-detalle.CanxMes[2]   = tmp-detalle.CanxMes[2]   + f-Salida[2]
         tmp-detalle.VtaxMesMe[2] = tmp-detalle.VtaxMesMe[2] + T-Vtame[2]
         tmp-detalle.VtaxMesMn[2] = tmp-detalle.VtaxMesMn[2] + T-Vtamn[2]
         tmp-detalle.CtoxMesMe[2] = tmp-detalle.CtoxMesMe[2] + T-Ctome[2]
         tmp-detalle.CtoxMesMn[2] = tmp-detalle.CtoxMesMn[2] + T-Ctomn[2]
         tmp-detalle.ProxMesMe[2] = tmp-detalle.ProxMesMe[2] + T-Prome[2]
         tmp-detalle.ProxMesMn[2] = tmp-detalle.ProxMesMn[2] + T-Promn[2]
         tmp-detalle.CanxMes[3]   = tmp-detalle.CanxMes[3]   + f-Salida[3]
         tmp-detalle.VtaxMesMe[3] = tmp-detalle.VtaxMesMe[3] + T-Vtame[3]
         tmp-detalle.VtaxMesMn[3] = tmp-detalle.VtaxMesMn[3] + T-Vtamn[3]
         tmp-detalle.CtoxMesMe[3] = tmp-detalle.CtoxMesMe[3] + T-Ctome[3]
         tmp-detalle.CtoxMesMn[3] = tmp-detalle.CtoxMesMn[3] + T-Ctomn[3]
         tmp-detalle.ProxMesMe[3] = tmp-detalle.ProxMesMe[3] + T-Prome[3]
         tmp-detalle.ProxMesMn[3] = tmp-detalle.ProxMesMn[3] + T-Promn[3]
         tmp-detalle.CanxMes[4]   = tmp-detalle.CanxMes[4]   + f-Salida[4]
         tmp-detalle.VtaxMesMe[4] = tmp-detalle.VtaxMesMe[4] + T-Vtame[4]
         tmp-detalle.VtaxMesMn[4] = tmp-detalle.VtaxMesMn[4] + T-Vtamn[4]
         tmp-detalle.CtoxMesMe[4] = tmp-detalle.CtoxMesMe[4] + T-Ctome[4]
         tmp-detalle.CtoxMesMn[4] = tmp-detalle.CtoxMesMn[4] + T-Ctomn[4]
         tmp-detalle.ProxMesMe[4] = tmp-detalle.ProxMesMe[4] + T-Prome[4]
         tmp-detalle.ProxMesMn[4] = tmp-detalle.ProxMesMn[4] + T-Promn[4].
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resumen-por-resmat wWin 
PROCEDURE Resumen-por-resmat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ASSIGN                                         */
/*     x-NroFchR = DATE(01, 01, YEAR(DesdeF) - 1) */
/*     x-NroFchE = HastaF.                        */

FOR EACH VentasxLinea NO-LOCK WHERE VentasxLinea.DateKey >= x-NroFchR
    AND VentasxLinea.DateKey <= x-NroFchE
    AND VentasxLinea.coddiv BEGINS x-CodDiv
    AND VentasxLinea.codfam BEGINS x-CodFam
    AND VentasxLinea.subfam BEGINS x-SubFam
    AND VentasxLinea.codpro BEGINS x-Codpro,
    FIRST DimDivision OF VentasxLinea NO-LOCK,
    FIRST DimLinea OF VentasxLinea NO-LOCK,
    FIRST DimSubLinea OF VentasxLinea NO-LOCK,
    FIRST DimFecha WHERE DimFecha.DateKey = VentasxLinea.DateKey NO-LOCK:
    IF x-CuentaReg = 0 OR ( x-CuentaReg MODULO x-MuestraReg ) = 0 THEN
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** TABLA RESUMEN POR PRODUCTO ' + 
        ' FECHA ' + STRING (DAY(DimFecha.DateKey), '99') +
        ' ' + DimFecha.CalendarMonthLabel + ' ' + STRING (YEAR(DimFecha.DateKey), '9999') +
        ' DIVISION ' + VentasxLinea.coddiv + ' LINEA ' + VentasxLinea.codfam + ' **'.
    x-CuentaReg = x-CuentaReg + 1.
    /* ARMAMOS LA LLAVE */
    ASSIGN
        T-Vtamn   = 0
        T-Vtame   = 0
        T-Ctomn   = 0
        T-Ctome   = 0
        T-Promn   = 0
        T-Prome   = 0
        F-Salida  = 0.
    x-Llave = ''.
    x-Fecha = VentasxLinea.DateKey.
    /* PERIODO ACTUAL */
    IF x-Fecha >= DesdeF AND x-Fecha <= HastaF THEN DO:
        ASSIGN
            /*F-Salida[1]  = F-Salida[1]  + VentasxLinea.Cantidad*/
            T-Vtamn[1]   = T-Vtamn[1]   + VentasxLinea.ImpNacCIGV
            T-Vtame[1]   = T-Vtame[1]   + VentasxLinea.ImpExtCIGV
            T-Ctomn[1]   = T-Ctomn[1]   + VentasxLinea.CostoNacCIGV
            T-Ctome[1]   = T-Ctome[1]   + VentasxLinea.CostoExtCIGV
            T-Promn[1]   = T-Promn[1]   + VentasxLinea.PromNacCIGV
            T-Prome[1]   = T-Prome[1]   + VentasxLinea.PromExtCIGV.
    END.
    /* ACUMULADO PERIODO ACTUAL */
    IF x-Fecha >= DATE(01,01,YEAR(DesdeF)) AND x-Fecha <= HastaF THEN DO:
        ASSIGN
            /*F-Salida[2]  = F-Salida[2]  + VentasxLinea.Cantidad*/
            T-Vtamn[2]   = T-Vtamn[2]   + VentasxLinea.ImpNacCIGV
            T-Vtame[2]   = T-Vtame[2]   + VentasxLinea.ImpExtCIGV
            T-Ctomn[2]   = T-Ctomn[2]   + VentasxLinea.CostoNacCIGV
            T-Ctome[2]   = T-Ctome[2]   + VentasxLinea.CostoExtCIGV
            T-Promn[2]   = T-Promn[2]   + VentasxLinea.PromNacCIGV
            T-Prome[2]   = T-Prome[2]   + VentasxLinea.PromExtCIGV.
    END.
    /* PERIODO ANTERIOR */
    IF x-Fecha >= DATE(MONTH(DesdeF),DAY(DesdeF),YEAR(DesdeF) - 1) AND x-Fecha <= DATE(MONTH(HastaF),DAY(HastaF),YEAR(HastaF) - 1) THEN DO:
        ASSIGN
            /*F-Salida[3]  = F-Salida[3]  + VentasxLinea.Cantidad*/
            T-Vtamn[3]   = T-Vtamn[3]   + VentasxLinea.ImpNacCIGV
            T-Vtame[3]   = T-Vtame[3]   + VentasxLinea.ImpExtCIGV
            T-Ctomn[3]   = T-Ctomn[3]   + VentasxLinea.CostoNacCIGV
            T-Ctome[3]   = T-Ctome[3]   + VentasxLinea.CostoExtCIGV
            T-Promn[3]   = T-Promn[3]   + VentasxLinea.PromNacCIGV
            T-Prome[3]   = T-Prome[3]   + VentasxLinea.PromExtCIGV.
    END.
    /* ACUMULADO PERIODO ANTERIOR */
    IF x-Fecha >= DATE(01,01,YEAR(DesdeF) - 1) AND x-Fecha <= DATE(MONTH(HastaF),DAY(HastaF),YEAR(HastaF) - 1) THEN DO:
        ASSIGN
            /*F-Salida[4]  = F-Salida[4]  + VentasxLinea.Cantidad*/
            T-Vtamn[4]   = T-Vtamn[4]   + VentasxLinea.ImpNacCIGV
            T-Vtame[4]   = T-Vtame[4]   + VentasxLinea.ImpExtCIGV
            T-Ctomn[4]   = T-Ctomn[4]   + VentasxLinea.CostoNacCIGV
            T-Ctome[4]   = T-Ctome[4]   + VentasxLinea.CostoExtCIGV
            T-Promn[4]   = T-Promn[4]   + VentasxLinea.PromNacCIGV
            T-Prome[4]   = T-Prome[4]   + VentasxLinea.PromExtCIGV.
    END.
    /* LLAVE INICIAL */
/*     IF RADIO-SET-Tipo = 2 THEN DO:                                                              */
/*         IF x-Llave = '' THEN x-Llave = DimFecha.Campania.                                       */
/*         ELSE x-Llave = x-Llave + DimFecha.Campania.                                             */
/*         x-Llave = x-Llave + '|'.                                                                */
/*         x-Llave = x-Llave + STRING(YEAR(DimFecha.DateKey), '9999').                             */
/*         x-Llave = x-Llave + '|'.                                                                */
/*         x-Llave = x-Llave + STRING(MONTH(DimFecha.DateKey), '99').      /*DimFecha.NombreMes.*/ */
/*         x-Llave = x-LLave + '|'.                                                                */
/*     END.                                                                                        */
    IF TOGGLE-CodDiv THEN DO:
         IF x-Llave = '' THEN x-Llave = VentasxLinea.coddiv + ' - ' + DimDivision.DesDiv + '|'.
         ELSE x-Llave = x-LLave + VentasxLinea.coddiv + ' - ' + DimDivision.DesDiv + '|'.
         x-Llave = x-Llave + DimDivision.CanalVenta + ' - ' + DimDivision.NomCanalVenta + '|'.
    END.
    IF TOGGLE-CodMat = YES THEN DO:
        IF TOGGLE-Resumen-Linea = YES THEN DO:
            IF x-Llave = '' THEN x-Llave = VentasxLinea.codfam + ' - ' + DimLinea.NomFam + '|'.
            ELSE x-Llave = x-Llave + VentasxLinea.codfam + ' - ' + DimLinea.NomFam + '|'.
            x-Llave = x-Llave + VentasxLinea.subfam + ' - ' + DimSubLinea.NomSubFam + '|'.
        END.
        IF TOGGLE-Resumen-Marca = YES THEN DO:
            IF x-Llave = '' THEN x-Llave = VentasxLinea.desmar + '|'.
            ELSE x-Llave = x-Llave + VentasxLinea.desmar + '|'.
        END.
        FIND DimLicencia OF VentasxLinea NO-LOCK NO-ERROR.
        IF NOT AVAILABLE DimLicencia 
            THEN x-Llave = x-Llave + VentasxLinea.licencia + '|'.
            ELSE x-Llave = x-Llave + VentasxLinea.licencia + ' - ' + DimLicencia.Descripcion + '|'.
         FIND DimProveedor WHERE DimProveedor.CodPro = VentasxLinea.codpro NO-LOCK NO-ERROR.
         IF AVAILABLE DimProveedor 
            THEN x-Llave = x-Llave + VentasxLinea.codpro + ' - '  + DimProveedor.NomPro + '|'.
            ELSE x-Llave = x-Llave + VentasxLinea.codpro + '|'.
     END.
     IF TOGGLE-CodVen = YES THEN DO:
         IF x-Llave = '' THEN x-Llave = VentasxLinea.codven.
         ELSE x-Llave = x-Llave + VentasxLinea.codven.
         FIND DimVendedor OF VentasxLinea NO-LOCK NO-ERROR.
         IF AVAILABLE DimVendedor 
            THEN x-Llave = x-Llave + ' - ' + DimVendedor.NomVen + '|'.
            ELSE x-Llave = x-Llave + '|'.
     END.
     /* ******************************************** */
     FIND tmp-detalle WHERE tmp-detalle.llave = x-Llave NO-ERROR.
     IF NOT AVAILABLE tmp-detalle THEN DO:
         CREATE tmp-detalle.
         tmp-detalle.llave = x-Llave.
     END.
     ASSIGN
         tmp-detalle.CanxMes[1]   = tmp-detalle.CanxMes[1]   + f-Salida[1]
         tmp-detalle.VtaxMesMe[1] = tmp-detalle.VtaxMesMe[1] + T-Vtame[1]
         tmp-detalle.VtaxMesMn[1] = tmp-detalle.VtaxMesMn[1] + T-Vtamn[1]
         tmp-detalle.CtoxMesMe[1] = tmp-detalle.CtoxMesMe[1] + T-Ctome[1]
         tmp-detalle.CtoxMesMn[1] = tmp-detalle.CtoxMesMn[1] + T-Ctomn[1]
         tmp-detalle.ProxMesMe[1] = tmp-detalle.ProxMesMe[1] + T-Prome[1]
         tmp-detalle.ProxMesMn[1] = tmp-detalle.ProxMesMn[1] + T-Promn[1]
         tmp-detalle.CanxMes[2]   = tmp-detalle.CanxMes[2]   + f-Salida[2]
         tmp-detalle.VtaxMesMe[2] = tmp-detalle.VtaxMesMe[2] + T-Vtame[2]
         tmp-detalle.VtaxMesMn[2] = tmp-detalle.VtaxMesMn[2] + T-Vtamn[2]
         tmp-detalle.CtoxMesMe[2] = tmp-detalle.CtoxMesMe[2] + T-Ctome[2]
         tmp-detalle.CtoxMesMn[2] = tmp-detalle.CtoxMesMn[2] + T-Ctomn[2]
         tmp-detalle.ProxMesMe[2] = tmp-detalle.ProxMesMe[2] + T-Prome[2]
         tmp-detalle.ProxMesMn[2] = tmp-detalle.ProxMesMn[2] + T-Promn[2]
         tmp-detalle.CanxMes[3]   = tmp-detalle.CanxMes[3]   + f-Salida[3]
         tmp-detalle.VtaxMesMe[3] = tmp-detalle.VtaxMesMe[3] + T-Vtame[3]
         tmp-detalle.VtaxMesMn[3] = tmp-detalle.VtaxMesMn[3] + T-Vtamn[3]
         tmp-detalle.CtoxMesMe[3] = tmp-detalle.CtoxMesMe[3] + T-Ctome[3]
         tmp-detalle.CtoxMesMn[3] = tmp-detalle.CtoxMesMn[3] + T-Ctomn[3]
         tmp-detalle.ProxMesMe[3] = tmp-detalle.ProxMesMe[3] + T-Prome[3]
         tmp-detalle.ProxMesMn[3] = tmp-detalle.ProxMesMn[3] + T-Promn[3]
         tmp-detalle.CanxMes[4]   = tmp-detalle.CanxMes[4]   + f-Salida[4]
         tmp-detalle.VtaxMesMe[4] = tmp-detalle.VtaxMesMe[4] + T-Vtame[4]
         tmp-detalle.VtaxMesMn[4] = tmp-detalle.VtaxMesMn[4] + T-Vtamn[4]
         tmp-detalle.CtoxMesMe[4] = tmp-detalle.CtoxMesMe[4] + T-Ctome[4]
         tmp-detalle.CtoxMesMn[4] = tmp-detalle.CtoxMesMn[4] + T-Ctomn[4]
         tmp-detalle.ProxMesMe[4] = tmp-detalle.ProxMesMe[4] + T-Prome[4]
         tmp-detalle.ProxMesMn[4] = tmp-detalle.ProxMesMn[4] + T-Promn[4].
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
        {est/resumenxvendcli-com.i}
        ASSIGN
            iContador = 0
            x-CodCli = ''.
    END.
END.
IF iContador > 0 THEN DO:
    {est/resumenxvendcli-com.i}
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resumen-por-vendedor wWin 
PROCEDURE Resumen-por-vendedor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ASSIGN                                         */
/*     x-NroFchR = DATE(01, 01, YEAR(DesdeF) - 1) */
/*     x-NroFchE = HastaF.                        */

FOR EACH VentasxVendedor NO-LOCK WHERE VentasxVendedor.DateKey >= x-NroFchR
    AND VentasxVendedor.DateKey <= x-NroFchE
    AND VentasxVendedor.coddiv BEGINS x-CodDiv
    AND VentasxVendedor.codven BEGINS x-CodVen,
    FIRST DimDivision OF VentasxVendedor NO-LOCK,
    FIRST DimVendedor OF VentasxVendedor NO-LOCK,
    FIRST DimFecha WHERE DimFecha.DateKey = VentasxVendedor.DateKey NO-LOCK:
    IF x-CuentaReg = 0 OR ( x-CuentaReg MODULO x-MuestraReg ) = 0 THEN
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** TABLA POR VENDEDOR ' + 
        ' FECHA ' + STRING (DAY(DimFecha.DateKey), '99') +
        ' ' + DimFecha.CalendarMonthLabel + ' ' + STRING (YEAR(DimFecha.DateKey), '9999') +
        ' DIVISION ' + VentasxVendedor.coddiv + ' VENDEDOR ' + VentasxVendedor.codven + ' **'.
    x-CuentaReg = x-CuentaReg + 1.
    /* ARMAMOS LA LLAVE */
    ASSIGN
        T-Vtamn   = 0
        T-Vtame   = 0
        T-Ctomn   = 0
        T-Ctome   = 0
        T-Promn   = 0
        T-Prome   = 0
        F-Salida  = 0.
    x-Llave = ''.
    x-Fecha = VentasxVendedor.DateKey.
    /* PERIODO ACTUAL */
    IF x-Fecha >= DesdeF AND x-Fecha <= HastaF THEN DO:
        ASSIGN
            /*F-Salida[1]  = F-Salida[1]  + VentasxVendedor.Cantidad*/
            T-Vtamn[1]   = T-Vtamn[1]   + VentasxVendedor.ImpNacCIGV
            T-Vtame[1]   = T-Vtame[1]   + VentasxVendedor.ImpExtCIGV
            T-Ctomn[1]   = T-Ctomn[1]   + VentasxVendedor.CostoNacCIGV
            T-Ctome[1]   = T-Ctome[1]   + VentasxVendedor.CostoExtCIGV
            T-Promn[1]   = T-Promn[1]   + VentasxVendedor.PromNacCIGV
            T-Prome[1]   = T-Prome[1]   + VentasxVendedor.PromExtCIGV.
    END.
    /* ACUMULADO PERIODO ACTUAL */
    IF x-Fecha >= DATE(01,01,YEAR(DesdeF)) AND x-Fecha <= HastaF THEN DO:
        ASSIGN
            /*F-Salida[2]  = F-Salida[2]  + VentasxVendedor.Cantidad*/
            T-Vtamn[2]   = T-Vtamn[2]   + VentasxVendedor.ImpNacCIGV
            T-Vtame[2]   = T-Vtame[2]   + VentasxVendedor.ImpExtCIGV
            T-Ctomn[2]   = T-Ctomn[2]   + VentasxVendedor.CostoNacCIGV
            T-Ctome[2]   = T-Ctome[2]   + VentasxVendedor.CostoExtCIGV
            T-Promn[2]   = T-Promn[2]   + VentasxVendedor.PromNacCIGV
            T-Prome[2]   = T-Prome[2]   + VentasxVendedor.PromExtCIGV.
    END.
    /* PERIODO ANTERIOR */
    IF x-Fecha >= DATE(MONTH(DesdeF),DAY(DesdeF),YEAR(DesdeF) - 1) AND x-Fecha <= DATE(MONTH(HastaF),DAY(HastaF),YEAR(HastaF) - 1) THEN DO:
        ASSIGN
            /*F-Salida[3]  = F-Salida[3]  + VentasxVendedor.Cantidad*/
            T-Vtamn[3]   = T-Vtamn[3]   + VentasxVendedor.ImpNacCIGV
            T-Vtame[3]   = T-Vtame[3]   + VentasxVendedor.ImpExtCIGV
            T-Ctomn[3]   = T-Ctomn[3]   + VentasxVendedor.CostoNacCIGV
            T-Ctome[3]   = T-Ctome[3]   + VentasxVendedor.CostoExtCIGV
            T-Promn[3]   = T-Promn[3]   + VentasxVendedor.PromNacCIGV
            T-Prome[3]   = T-Prome[3]   + VentasxVendedor.PromExtCIGV.
    END.
    /* ACUMULADO PERIODO ANTERIOR */
    IF x-Fecha >= DATE(01,01,YEAR(DesdeF) - 1) AND x-Fecha <= DATE(MONTH(HastaF),DAY(HastaF),YEAR(HastaF) - 1) THEN DO:
        ASSIGN
            /*F-Salida[4]  = F-Salida[4]  + VentasxVendedor.Cantidad*/
            T-Vtamn[4]   = T-Vtamn[4]   + VentasxVendedor.ImpNacCIGV
            T-Vtame[4]   = T-Vtame[4]   + VentasxVendedor.ImpExtCIGV
            T-Ctomn[4]   = T-Ctomn[4]   + VentasxVendedor.CostoNacCIGV
            T-Ctome[4]   = T-Ctome[4]   + VentasxVendedor.CostoExtCIGV
            T-Promn[4]   = T-Promn[4]   + VentasxVendedor.PromNacCIGV
            T-Prome[4]   = T-Prome[4]   + VentasxVendedor.PromExtCIGV.
    END.
    /* LLAVE INICIAL */
/*     IF RADIO-SET-Tipo = 2 THEN DO:                                                              */
/*         IF x-Llave = '' THEN x-Llave = DimFecha.Campania.                                       */
/*         ELSE x-Llave = x-Llave + DimFecha.Campania.                                             */
/*         x-Llave = x-Llave + '|'.                                                                */
/*         x-Llave = x-Llave + STRING(YEAR(DimFecha.DateKey), '9999').                             */
/*         x-Llave = x-Llave + '|'.                                                                */
/*         x-Llave = x-Llave + STRING(MONTH(DimFecha.DateKey), '99').      /*DimFecha.NombreMes.*/ */
/*         x-Llave = x-LLave + '|'.                                                                */
/*     END.                                                                                        */
    IF TOGGLE-CodDiv THEN DO:
         IF x-Llave = '' THEN x-Llave = VentasxVendedor.coddiv + ' - ' + DimDivision.DesDiv + '|'.
         ELSE x-Llave = x-LLave + VentasxVendedor.coddiv + ' - ' + DimDivision.DesDiv + '|'.
         x-Llave = x-Llave + DimDivision.CanalVenta + ' - ' + DimDivision.NomCanalVenta + '|'.
    END.
     IF TOGGLE-CodVen = YES THEN DO:
         IF x-Llave = '' THEN x-Llave = VentasxVendedor.codven.
         ELSE x-Llave = x-Llave + VentasxVendedor.codven.
         x-Llave = x-Llave + ' - ' + DimVendedor.NomVen + '|'.
     END.
     /* ******************************************** */
     FIND tmp-detalle WHERE tmp-detalle.llave = x-Llave NO-ERROR.
     IF NOT AVAILABLE tmp-detalle THEN DO:
         CREATE tmp-detalle.
         tmp-detalle.llave = x-Llave.
     END.
     ASSIGN
         tmp-detalle.CanxMes[1]   = tmp-detalle.CanxMes[1]   + f-Salida[1]
         tmp-detalle.VtaxMesMe[1] = tmp-detalle.VtaxMesMe[1] + T-Vtame[1]
         tmp-detalle.VtaxMesMn[1] = tmp-detalle.VtaxMesMn[1] + T-Vtamn[1]
         tmp-detalle.CtoxMesMe[1] = tmp-detalle.CtoxMesMe[1] + T-Ctome[1]
         tmp-detalle.CtoxMesMn[1] = tmp-detalle.CtoxMesMn[1] + T-Ctomn[1]
         tmp-detalle.ProxMesMe[1] = tmp-detalle.ProxMesMe[1] + T-Prome[1]
         tmp-detalle.ProxMesMn[1] = tmp-detalle.ProxMesMn[1] + T-Promn[1]
         tmp-detalle.CanxMes[2]   = tmp-detalle.CanxMes[2]   + f-Salida[2]
         tmp-detalle.VtaxMesMe[2] = tmp-detalle.VtaxMesMe[2] + T-Vtame[2]
         tmp-detalle.VtaxMesMn[2] = tmp-detalle.VtaxMesMn[2] + T-Vtamn[2]
         tmp-detalle.CtoxMesMe[2] = tmp-detalle.CtoxMesMe[2] + T-Ctome[2]
         tmp-detalle.CtoxMesMn[2] = tmp-detalle.CtoxMesMn[2] + T-Ctomn[2]
         tmp-detalle.ProxMesMe[2] = tmp-detalle.ProxMesMe[2] + T-Prome[2]
         tmp-detalle.ProxMesMn[2] = tmp-detalle.ProxMesMn[2] + T-Promn[2]
         tmp-detalle.CanxMes[3]   = tmp-detalle.CanxMes[3]   + f-Salida[3]
         tmp-detalle.VtaxMesMe[3] = tmp-detalle.VtaxMesMe[3] + T-Vtame[3]
         tmp-detalle.VtaxMesMn[3] = tmp-detalle.VtaxMesMn[3] + T-Vtamn[3]
         tmp-detalle.CtoxMesMe[3] = tmp-detalle.CtoxMesMe[3] + T-Ctome[3]
         tmp-detalle.CtoxMesMn[3] = tmp-detalle.CtoxMesMn[3] + T-Ctomn[3]
         tmp-detalle.ProxMesMe[3] = tmp-detalle.ProxMesMe[3] + T-Prome[3]
         tmp-detalle.ProxMesMn[3] = tmp-detalle.ProxMesMn[3] + T-Promn[3]
         tmp-detalle.CanxMes[4]   = tmp-detalle.CanxMes[4]   + f-Salida[4]
         tmp-detalle.VtaxMesMe[4] = tmp-detalle.VtaxMesMe[4] + T-Vtame[4]
         tmp-detalle.VtaxMesMn[4] = tmp-detalle.VtaxMesMn[4] + T-Vtamn[4]
         tmp-detalle.CtoxMesMe[4] = tmp-detalle.CtoxMesMe[4] + T-Ctome[4]
         tmp-detalle.CtoxMesMn[4] = tmp-detalle.CtoxMesMn[4] + T-Ctomn[4]
         tmp-detalle.ProxMesMe[4] = tmp-detalle.ProxMesMe[4] + T-Prome[4]
         tmp-detalle.ProxMesMn[4] = tmp-detalle.ProxMesMn[4] + T-Promn[4].
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

