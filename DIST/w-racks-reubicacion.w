&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER x-VtaTabla FOR VtaTabla.



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

    DEFINE SHARED VARIABLE pRCID AS INT.

    DEFINE SHARED VAR s-codcia AS INT.
    DEFINE VAR lTabla AS CHAR INIT "RACKS".
    DEFINE VAR lODConteo AS INT.

    DEFINE VAR lCD AS CHAR.
    DEFINE VAR lMsgErr AS CHAR.
    DEFINE VAR lNroOD AS CHAR.
    DEFINE VAR lCodRack AS CHAR.
    DEFINE VAR lNroPaleta AS CHAR.
    DEFINE VAR lLlave AS CHAR.
    DEFINE VAR lTipoOrden AS CHAR.

    lLlave = "**".

    &SCOPED-DEFINE CONDICION ( ~
                INTEGRAL.vtatabla.CodCia = s-codcia AND INTEGRAL.vtatabla.tabla = lTabla AND ~
                INTEGRAL.vtatabla.llave_c1 = lCD )

    &SCOPED-DEFINE CONDICION2 ( ~
                x-vtatabla.CodCia = s-codcia AND x-vtatabla.tabla = lTabla AND ~
                x-vtatabla.llave_c1 = lCD ) 

    &SCOPED-DEFINE CONDICION-HDR ( ~
                INTEGRAL.vtactabla.CodCia = s-codcia AND INTEGRAL.vtactabla.tabla = 'MOV-RACK-HDR' AND ~
                INTEGRAL.vtactabla.llave BEGINS lLlave AND INTEGRAL.vtactabla.libre_f01 >= 03/12/2015 AND ~
                integral.vtactabla.libre_f02 = ?)
                /*INTEGRAL.vtactabla.llave = lCD AND integral.vtactabla.libre_c01 = lCodRack )*/

    &SCOPED-DEFINE CONDICION-DTL ( ~
                INTEGRAL.vtadtabla.CodCia = s-codcia AND INTEGRAL.vtadtabla.tabla = 'MOV-RACK-DTL' AND ~
                INTEGRAL.vtadtabla.llave = lCD AND integral.vtadtabla.tipo = lNroPaleta )

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
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES VtaTabla VtaCTabla VtaDTabla CcbCBult ~
x-VtaTabla

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 VtaTabla.Llave_c2 VtaTabla.Valor[1] ~
VtaTabla.Valor[2] VtaTabla.Libre_c02 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH VtaTabla ~
      WHERE {&CONDICION} NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH VtaTabla ~
      WHERE {&CONDICION} NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 VtaTabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 VtaTabla


/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 VtaCTabla.Libre_c02 ~
VtaCTabla.Libre_d01 VtaCTabla.Libre_d04 VtaCTabla.Libre_f01 ~
VtaCTabla.Libre_c03 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH VtaCTabla ~
      WHERE {&CONDICION-HDR} NO-LOCK ~
    BY VtaCTabla.Libre_f01 DESCENDING ~
       BY VtaCTabla.Libre_c03 DESCENDING
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH VtaCTabla ~
      WHERE {&CONDICION-HDR} NO-LOCK ~
    BY VtaCTabla.Libre_f01 DESCENDING ~
       BY VtaCTabla.Libre_c03 DESCENDING.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 VtaCTabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 VtaCTabla


/* Definitions for BROWSE BROWSE-6                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-6 VtaDTabla.Libre_c03 ~
VtaDTabla.LlaveDetalle VtaDTabla.Libre_d01 VtaDTabla.Libre_d03 ~
CcbCBult.CodCli CcbCBult.NomCli VtaDTabla.Libre_c05 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-6 
&Scoped-define QUERY-STRING-BROWSE-6 FOR EACH VtaDTabla ~
      WHERE {&CONDICION-DTL} NO-LOCK, ~
      FIRST CcbCBult WHERE CcbCBult.CodCia = s-codcia and  ~
INTEGRAL.CcbCBult.CodDoc =  VtaDTabla.Libre_c03 and ~
  CcbCBult.NroDoc =  VtaDTabla.LlaveDetalle NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-6 OPEN QUERY BROWSE-6 FOR EACH VtaDTabla ~
      WHERE {&CONDICION-DTL} NO-LOCK, ~
      FIRST CcbCBult WHERE CcbCBult.CodCia = s-codcia and  ~
INTEGRAL.CcbCBult.CodDoc =  VtaDTabla.Libre_c03 and ~
  CcbCBult.NroDoc =  VtaDTabla.LlaveDetalle NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-6 VtaDTabla CcbCBult
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-6 VtaDTabla
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-6 CcbCBult


/* Definitions for BROWSE BROWSE-7                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-7 x-VtaTabla.Llave_c2 ~
x-VtaTabla.Valor[1] x-VtaTabla.Valor[2] x-VtaTabla.Libre_c02 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-7 
&Scoped-define QUERY-STRING-BROWSE-7 FOR EACH x-VtaTabla ~
      WHERE {&CONDICION2} NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-7 OPEN QUERY BROWSE-7 FOR EACH x-VtaTabla ~
      WHERE {&CONDICION2} NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-7 x-VtaTabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-7 x-VtaTabla


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-4}~
    ~{&OPEN-QUERY-BROWSE-6}~
    ~{&OPEN-QUERY-BROWSE-7}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS txtCD btnAceptar txtCodRack BROWSE-2 ~
BROWSE-4 BROWSE-6 BtnRefrescarRacks BROWSE-7 txtCodRackDestino 
&Scoped-Define DISPLAYED-OBJECTS txtCD txtNomCD txtCodRack ~
txtRacksDisponibles txtDetallePaletaRack txtDetalleOrdenesPaleta ~
txtRacksDisponibles-2 txtCodRackDestino 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnAceptar 
     LABEL "Aceptar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BtnRefrescarRacks 
     LABEL "Refrescar RACKS disponibles" 
     SIZE 29 BY 1.12.

DEFINE VARIABLE txtCD AS CHARACTER FORMAT "X(5)":U 
     LABEL "Centro de Distribucion" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE txtCodRack AS CHARACTER FORMAT "X(10)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 21.43 BY 1.85
     BGCOLOR 15 FGCOLOR 9 FONT 8 NO-UNDO.

DEFINE VARIABLE txtCodRackDestino AS CHARACTER FORMAT "X(10)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 21.43 BY 1.85
     BGCOLOR 2 FGCOLOR 15 FONT 8 NO-UNDO.

DEFINE VARIABLE txtDetalleOrdenesPaleta AS CHARACTER FORMAT "X(80)":U INITIAL "Ordenes de la Paleta" 
     VIEW-AS FILL-IN 
     SIZE 100 BY 1
     BGCOLOR 7 FGCOLOR 15 FONT 13 NO-UNDO.

DEFINE VARIABLE txtDetallePaletaRack AS CHARACTER FORMAT "X(80)":U INITIAL "   PALETAS en el RACK" 
     VIEW-AS FILL-IN 
     SIZE 26.86 BY 1
     BGCOLOR 7 FGCOLOR 15 FONT 13 NO-UNDO.

DEFINE VARIABLE txtNomCD AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY 1 NO-UNDO.

DEFINE VARIABLE txtRacksDisponibles AS CHARACTER FORMAT "X(100)":U INITIAL "             RACKS Disponibles" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1
     BGCOLOR 15 FGCOLOR 9 FONT 14 NO-UNDO.

DEFINE VARIABLE txtRacksDisponibles-2 AS CHARACTER FORMAT "X(100)":U INITIAL "                    RACK DESTINO" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1
     BGCOLOR 2 FGCOLOR 15 FONT 14 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      VtaTabla SCROLLING.

DEFINE QUERY BROWSE-4 FOR 
      VtaCTabla SCROLLING.

DEFINE QUERY BROWSE-6 FOR 
      VtaDTabla, 
      CcbCBult SCROLLING.

DEFINE QUERY BROWSE-7 FOR 
      x-VtaTabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 wWin _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      VtaTabla.Llave_c2 COLUMN-LABEL "Cod.Rack" FORMAT "x(8)":U
      VtaTabla.Valor[1] COLUMN-LABEL "Capacidad!Nro Paletas" FORMAT "->>>,>>>,>>9":U
      VtaTabla.Valor[2] COLUMN-LABEL "Capacidad!Usada" FORMAT "->>>,>>>,>>9":U
            WIDTH 11.29
      VtaTabla.Libre_c02 COLUMN-LABEL "Activo" FORMAT "x(5)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 42 BY 17.58 ROW-HEIGHT-CHARS .58 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 wWin _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      VtaCTabla.Libre_c02 COLUMN-LABEL "#Paleta" FORMAT "x(15)":U
            WIDTH 15.86
      VtaCTabla.Libre_d01 COLUMN-LABEL "Bultos" FORMAT "->>,>>9.99":U
      VtaCTabla.Libre_d04 COLUMN-LABEL "Peso Aprox." FORMAT "->>,>>9.99":U
            WIDTH 11
      VtaCTabla.Libre_f01 COLUMN-LABEL "Fec.Regis" FORMAT "99/99/9999":U
      VtaCTabla.Libre_c03 COLUMN-LABEL "Hor.Reg" FORMAT "x(8)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 56 BY 8.65 ROW-HEIGHT-CHARS .58 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-6 wWin _STRUCTURED
  QUERY BROWSE-6 NO-LOCK DISPLAY
      VtaDTabla.Libre_c03 COLUMN-LABEL "Tipo" FORMAT "x(8)":U WIDTH 4.72
      VtaDTabla.LlaveDetalle COLUMN-LABEL "Orden" FORMAT "x(20)":U
            WIDTH 13.43
      VtaDTabla.Libre_d01 COLUMN-LABEL "Bultos" FORMAT "->>,>>9":U
            WIDTH 6.43
      VtaDTabla.Libre_d03 COLUMN-LABEL "Peso" FORMAT "->>,>>9.99":U
      CcbCBult.CodCli FORMAT "x(11)":U
      CcbCBult.NomCli FORMAT "x(50)":U WIDTH 29.86
      VtaDTabla.Libre_c05 COLUMN-LABEL "H/R" FORMAT "x(8)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 100.29 BY 7.31 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-7 wWin _STRUCTURED
  QUERY BROWSE-7 NO-LOCK DISPLAY
      x-VtaTabla.Llave_c2 COLUMN-LABEL "Cod.Rack" FORMAT "x(8)":U
            WIDTH 9
      x-VtaTabla.Valor[1] COLUMN-LABEL "Capacidad!Nro Paletas" FORMAT ">>>,>>9":U
            WIDTH 10.43
      x-VtaTabla.Valor[2] COLUMN-LABEL "Capacidad!Usada" FORMAT ">,>>>,>>9":U
      x-VtaTabla.Libre_c02 COLUMN-LABEL "Activo" FORMAT "x(8)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 42 BY 8.65 ROW-HEIGHT-CHARS .58 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     txtCD AT ROW 1.38 COL 25 COLON-ALIGNED WIDGET-ID 50
     btnAceptar AT ROW 1.35 COL 75.14 WIDGET-ID 24
     txtNomCD AT ROW 1.38 COL 35.86 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     txtCodRack AT ROW 2.65 COL 71 COLON-ALIGNED WIDGET-ID 28
     txtRacksDisponibles AT ROW 2.96 COL 1.72 NO-LABEL WIDGET-ID 44
     BROWSE-2 AT ROW 4 COL 2 WIDGET-ID 200
     txtDetallePaletaRack AT ROW 3.27 COL 43.14 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     BROWSE-4 AT ROW 4.38 COL 45 WIDGET-ID 300
     BROWSE-6 AT ROW 14.27 COL 44.72 WIDGET-ID 400
     BtnRefrescarRacks AT ROW 21.77 COL 8 WIDGET-ID 30
     txtDetalleOrdenesPaleta AT ROW 13.23 COL 43 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     BROWSE-7 AT ROW 4.42 COL 101.43 WIDGET-ID 500
     txtRacksDisponibles-2 AT ROW 3.38 COL 101.29 NO-LABEL WIDGET-ID 54
     txtCodRackDestino AT ROW 1.38 COL 110 COLON-ALIGNED WIDGET-ID 56
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.29 BY 22.04 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: x-VtaTabla B "?" NO-UNDO INTEGRAL VtaTabla
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Reubicacion de RACKS"
         HEIGHT             = 22.04
         WIDTH              = 144.29
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

{src/adm-vm/method/vmviewer.i}
{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-2 txtRacksDisponibles fMain */
/* BROWSE-TAB BROWSE-4 txtDetallePaletaRack fMain */
/* BROWSE-TAB BROWSE-6 BROWSE-4 fMain */
/* BROWSE-TAB BROWSE-7 txtDetalleOrdenesPaleta fMain */
/* SETTINGS FOR FILL-IN txtDetalleOrdenesPaleta IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtDetallePaletaRack IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtNomCD IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtRacksDisponibles IN FRAME fMain
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN txtRacksDisponibles-2 IN FRAME fMain
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.VtaTabla"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "{&CONDICION}"
     _FldNameList[1]   > INTEGRAL.VtaTabla.Llave_c2
"VtaTabla.Llave_c2" "Cod.Rack" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.VtaTabla.Valor[1]
"VtaTabla.Valor[1]" "Capacidad!Nro Paletas" "->>>,>>>,>>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.VtaTabla.Valor[2]
"VtaTabla.Valor[2]" "Capacidad!Usada" "->>>,>>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "11.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.VtaTabla.Libre_c02
"VtaTabla.Libre_c02" "Activo" "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "INTEGRAL.VtaCTabla"
     _Options          = "NO-LOCK"
     _OrdList          = "INTEGRAL.VtaCTabla.Libre_f01|no,INTEGRAL.VtaCTabla.Libre_c03|no"
     _Where[1]         = "{&CONDICION-HDR}"
     _FldNameList[1]   > INTEGRAL.VtaCTabla.Libre_c02
"VtaCTabla.Libre_c02" "#Paleta" "x(15)" "character" ? ? ? ? ? ? no ? no no "15.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.VtaCTabla.Libre_d01
"VtaCTabla.Libre_d01" "Bultos" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.VtaCTabla.Libre_d04
"VtaCTabla.Libre_d04" "Peso Aprox." ? "decimal" ? ? ? ? ? ? no ? no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.VtaCTabla.Libre_f01
"VtaCTabla.Libre_f01" "Fec.Regis" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.VtaCTabla.Libre_c03
"VtaCTabla.Libre_c03" "Hor.Reg" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-6
/* Query rebuild information for BROWSE BROWSE-6
     _TblList          = "INTEGRAL.VtaDTabla,INTEGRAL.CcbCBult WHERE INTEGRAL.VtaDTabla ..."
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST"
     _Where[1]         = "{&CONDICION-DTL}"
     _JoinCode[2]      = "INTEGRAL.CcbCBult.CodCia = s-codcia and 
INTEGRAL.CcbCBult.CodDoc =  INTEGRAL.VtaDTabla.Libre_c03 and
  INTEGRAL.CcbCBult.NroDoc =  INTEGRAL.VtaDTabla.LlaveDetalle"
     _FldNameList[1]   > INTEGRAL.VtaDTabla.Libre_c03
"VtaDTabla.Libre_c03" "Tipo" ? "character" ? ? ? ? ? ? no ? no no "4.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.VtaDTabla.LlaveDetalle
"VtaDTabla.LlaveDetalle" "Orden" ? "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.VtaDTabla.Libre_d01
"VtaDTabla.Libre_d01" "Bultos" "->>,>>9" "decimal" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.VtaDTabla.Libre_d03
"VtaDTabla.Libre_d03" "Peso" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = INTEGRAL.CcbCBult.CodCli
     _FldNameList[6]   > INTEGRAL.CcbCBult.NomCli
"CcbCBult.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "29.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.VtaDTabla.Libre_c05
"VtaDTabla.Libre_c05" "H/R" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-6 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-7
/* Query rebuild information for BROWSE BROWSE-7
     _TblList          = "Temp-Tables.x-VtaTabla"
     _Options          = "NO-LOCK"
     _Where[1]         = "{&CONDICION2}"
     _FldNameList[1]   > Temp-Tables.x-VtaTabla.Llave_c2
"x-VtaTabla.Llave_c2" "Cod.Rack" ? "character" ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.x-VtaTabla.Valor[1]
"x-VtaTabla.Valor[1]" "Capacidad!Nro Paletas" ">>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.x-VtaTabla.Valor[2]
"x-VtaTabla.Valor[2]" "Capacidad!Usada" ">,>>>,>>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.x-VtaTabla.Libre_c02
"x-VtaTabla.Libre_c02" "Activo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-7 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Reubicacion de RACKS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Reubicacion de RACKS */
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 wWin
ON VALUE-CHANGED OF BROWSE-2 IN FRAME fMain
DO:
    txtCodRack:SCREEN-VALUE = "".
    lCodRack = "**".
    /* Header */
    IF AVAILABLE vtatabla THEN DO:
        txtCodRack:SCREEN-VALUE = vtatabla.llave_c2.
           
        lCodRack = vtatabla.llave_c2.
    END.
    lLlave = txtCD + lCodRack.
    
    /* Refresh */
    {&OPEN-QUERY-BROWSE-4}
    
    lNroPaleta = "".
    /* Detalle */
    IF AVAILABLE vtactabla THEN DO:
        lNroPaleta = vtactabla.libre_c02.
    END.
    {&OPEN-QUERY-BROWSE-6}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
&Scoped-define SELF-NAME BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 wWin
ON ENTRY OF BROWSE-4 IN FRAME fMain
DO:
    /* Detalle */
    lNroPaleta = "".
    IF AVAILABLE vtactabla THEN DO:
        lNroPaleta = vtactabla.libre_c02.
    END.

    txtDetalleOrdenesPaleta:SCREEN-VALUE = "Ordenes de la PALETA " + lNroPaleta.

    {&OPEN-QUERY-BROWSE-6}  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 wWin
ON MOUSE-SELECT-DBLCLICK OF BROWSE-4 IN FRAME fMain
DO:
  
    ASSIGN txtCodRackDestino txtCodRack.

    RUN reubicar-paleta.

    {&OPEN-QUERY-BROWSE-7}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 wWin
ON VALUE-CHANGED OF BROWSE-4 IN FRAME fMain
DO:
    /* Detalle */
    lNroPaleta = "".
    IF AVAILABLE vtactabla THEN DO:
        lNroPaleta = vtactabla.libre_c02.
    END.

    txtDetalleOrdenesPaleta:SCREEN-VALUE = "Ordenes de la PALETA " + lNroPaleta.

    {&OPEN-QUERY-BROWSE-6}  
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-7
&Scoped-define SELF-NAME BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-7 wWin
ON VALUE-CHANGED OF BROWSE-7 IN FRAME fMain
DO:
    
    txtCodRackDestino:SCREEN-VALUE = "".
    IF AVAILABLE vtatabla THEN DO:
        txtCodRackDestino:SCREEN-VALUE = x-vtatabla.llave_c2.
    END.

    /*
    lCodRack = "**".
    /* Header */
    IF AVAILABLE vtatabla THEN DO:
        txtCodRack:SCREEN-VALUE = vtatabla.llave_c2.
           
        lCodRack = vtatabla.llave_c2.
    END.
    lLlave = txtCD + lCodRack.
    
    /* Refresh */
    {&OPEN-QUERY-BROWSE-4}
    
    lNroPaleta = "".
    /* Detalle */
    IF AVAILABLE vtactabla THEN DO:
        lNroPaleta = vtactabla.libre_c02.
    END.
    {&OPEN-QUERY-BROWSE-6}
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnAceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnAceptar wWin
ON CHOOSE OF btnAceptar IN FRAME fMain /* Aceptar */
DO:
    DEFINE VAR lxCD AS CHAR.
    ASSIGN txtCD.

    lxCD = txtCD:SCREEN-VALUE.
    txtNomCD:SCREEN-VALUE = "".

    IF lxCD = "" THEN DO:
        RETURN NO-APPLY.
    END.

    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
          gn-divi.coddiv = lxCD NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-divi THEN DO:
        MESSAGE "Centro de Distribucion ERRADA" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
    END.

    txtNomCD:SCREEN-VALUE = gn-divi.desdiv.
    /*
    */
  BROWSE-2:VISIBLE = TRUE.
  BROWSE-4:VISIBLE = TRUE.
  BROWSE-6:VISIBLE = TRUE.
  BROWSE-7:VISIBLE = TRUE.
  txtCodRack:VISIBLE = TRUE.
  txtDetalleOrdenesPaleta:VISIBLE = TRUE.
  txtDetallePaletaRack:VISIBLE = TRUE.
  btnRefrescarRacks:VISIBLE = TRUE.
  txtRacksDisponibles:VISIBLE = TRUE.
  txtCodRackDestino:VISIBLE = TRUE.
  txtRacksDisponibles-2:VISIBLE = TRUE.
 

    lCD = lxCD.
    {&OPEN-QUERY-BROWSE-2}

    {&OPEN-QUERY-BROWSE-7}


    {&OPEN-QUERY-BROWSE-4}

    /*APPLY 'ENTRY':U TO txtOD.*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnRefrescarRacks
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnRefrescarRacks wWin
ON CHOOSE OF BtnRefrescarRacks IN FRAME fMain /* Refrescar RACKS disponibles */
DO:
   {&OPEN-QUERY-BROWSE-2}

   {&OPEN-QUERY-BROWSE-7}

   txtCodRack:SCREEN-VALUE = "".
   txtCodRack:SCREEN-VALUE = vtatabla.llave_c2.

/*
    FIND FIRST {&FIRST-TABLE-IN-QUERY-BROWSE-2} NO-LOCK NO-ERROR.

   IF AVAILABLE vtatabla THEN DO:
       /*txtCodRack:SCREEN-VALUE = vtatabla.llave_c2.*/
   END.
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCD wWin
ON ENTRY OF txtCD IN FRAME fMain /* Centro de Distribucion */
DO:
  
    BROWSE-2:VISIBLE = FALSE.
    BROWSE-4:VISIBLE = FALSE.
    BROWSE-6:VISIBLE = FALSE.
    BROWSE-7:VISIBLE = FALSE.
    txtCodRack:VISIBLE = FALSE.
    txtDetallePaletaRack:VISIBLE = FALSE.
    txtDetalleOrdenesPaleta:VISIBLE = FALSE.
    txtCodRackDestino:VISIBLE = FALSE.
    txtRacksDisponibles-2:VISIBLE = FALSE.
    btnRefrescarRacks:VISIBLE = FALSE.
    
    txtRacksDisponibles:VISIBLE = FALSE.
    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCD wWin
ON LEAVE OF txtCD IN FRAME fMain /* Centro de Distribucion */
DO:
  DEFINE VAR lxCD AS CHAR.

  lxCD = txtCD:SCREEN-VALUE.
  txtNomCD:SCREEN-VALUE = "".

  IF lxCD <> "" THEN DO:
    
      FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
            gn-divi.coddiv = lxCD NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-divi THEN DO:
          RETURN NO-APPLY.
      END.
    
      txtNomCD:SCREEN-VALUE = gn-divi.desdiv.
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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
  DISPLAY txtCD txtNomCD txtCodRack txtRacksDisponibles txtDetallePaletaRack 
          txtDetalleOrdenesPaleta txtRacksDisponibles-2 txtCodRackDestino 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE txtCD btnAceptar txtCodRack BROWSE-2 BROWSE-4 BROWSE-6 
         BtnRefrescarRacks BROWSE-7 txtCodRackDestino 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros wWin 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros wWin 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reubicar-paleta wWin 
PROCEDURE reubicar-paleta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF txtCodRackDestino = ? OR txtCodRackDestino = "" THEN DO:
    MESSAGE "RACK DESTINO es desconocido".
    RETURN.
END.
IF txtCodRack = ? OR txtCodRack = "" THEN DO:
    MESSAGE "RACK de la PALETA es desconocido".
    RETURN.
END.

IF NOT AVAILABLE vtactabla THEN DO:
  RETURN.
END.

IF txtCodRack = txtCodRackDestino THEN DO:
    MESSAGE "RACK destino tiene que ser diferente al RACK ORIGEN".
    RETURN.
END.

MESSAGE 'Seguro de REUBICAR la paleta (' + vtactabla.libre_c02 + ')' SKIP
        "Desde " + txtCodRack + " hacia " + txtCodRackDestino
     VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.

IF rpta = NO THEN RETURN.

DEFINE VAR lRowId AS ROWID.
DEFINE VAR lRackAntiguo AS CHAR.
DEFINE VAR lRackNuevo AS CHAR.
DEFINE VAR lLlave AS CHAR.
DEFINE VAR lNuevoNroPaleta AS CHAR.

/* La cabecera - PALETAS*/
DISABLE TRIGGERS FOR LOAD OF vtactabla.
DISABLE TRIGGERS FOR LOAD OF vtatabla.

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR" :
    /* REUBICAR el RACK */
    DEF BUFFER x-vtactabla FOR vtactabla.
    DEF BUFFER z-vtatabla FOR vtatabla.
    DEF BUFFER x-vtadtabla FOR vtadtabla.

    lRackAntiguo = vtactabla.libre_c01.
    lRackNuevo = txtCodrackDestino.

    /* Regenerar el Nro de Paleta */    
    lNuevoNroPaleta = STRING(NOW,"99/99/9999 HH:MM:SS").
    lNuevoNroPaleta = SUBSTRING(lNuevoNroPaleta,7,4) +      /* Año */
                        SUBSTRING(lNuevoNroPaleta,4,2) +    /* Mes */
                        SUBSTRING(lNuevoNroPaleta,1,2) +    /* Dia */
                        SUBSTRING(lNuevoNroPaleta,12,8).    /* HH:MM:SS */
    lNuevoNroPaleta = REPLACE(lNuevoNroPaleta,":","").

    /* Division + Rack + Nro de Paleta (AAAAMMDDHHMMSS */
    lLlave = SUBSTRING(vtactabla.llave,1,5) + lRackNuevo +  lNuevoNroPaleta.

    /* Header */
    CREATE x-vtactabla.
    BUFFER-COPY vtactabla EXCEPT llave libre_c01 libre_c02 TO x-vtactabla.
    ASSIGN x-vtactabla.llave = lLlave
            x-vtactabla.libre_c01 = lRackNuevo
            x-vtactabla.libre_c02 = lNuevoNroPaleta.

    /* Detalle */
    /*GET FIRST {&BROWSE-NAME}.*/
    GET FIRST BROWSE-6.
    DO  WHILE AVAILABLE vtadtabla:
        CREATE x-vtadtabla.
        BUFFER-COPY vtadtabla EXCEPT libre_c01 tipo TO x-vtadtabla.
        ASSIGN x-vtadtabla.libre_c01 = lLlave
                x-vtadtabla.tipo = lNuevoNroPaleta.
        GET NEXT BROWSE-6.
    END.        

    /* Los RACKS incremento */
    lRowId = ROWID(x-vtatabla).
    FIND FIRST z-vtatabla WHERE rowid(z-vtatabla) = lROwId EXCLUSIVE NO-ERROR.
    IF AVAILABLE z-vtatabla THEN DO:
        ASSIGN z-vtatabla.valor[2] =  z-vtatabla.valor[2] + 1.
    END.
    RELEASE x-vtatabla.

    /* ---------------------------------------------------------------------------------- */
    /* Dar por SACADO del RACK a la PALETA */
    lRowId = ROWID(vtactabla).
    DEF BUFFER B-vtactabla FOR vtactabla.
    DEF BUFFER B-vtatabla FOR vtatabla.
    
    FIND B-vtactabla WHERE rowid(B-vtactabla) = lROwId EXCLUSIVE NO-ERROR.
    IF AVAILABLE B-vtactabla THEN DO:
        ASSIGN B-vtactabla.libre_d03 =  pRCID
                B-vtactabla.libre_f02 = TODAY
                B-vtactabla.libre_c04 = STRING(TIME,"HH:MM:SS")
                b-vtactabla.libre_c05 = "REUBICADO|" + lRackNuevo + "|" + lNuevoNroPaleta .
    END.
    RELEASE B-vtactabla.
    
    /* Los RACKS */
    lRowId = ROWID(vtatabla).
    FIND B-vtatabla WHERE rowid(B-vtatabla) = lROwId EXCLUSIVE NO-ERROR.
    IF AVAILABLE B-vtatabla THEN DO:
        ASSIGN B-vtatabla.valor[2] =  B-vtatabla.valor[2] - 1.
        IF B-vtatabla.valor[2] < 0 THEN DO:
            ASSIGN B-vtatabla.valor[2] =  0.
        END.
    END.
    RELEASE B-vtatabla.
END.

/* Refreesh los browses*/

/* Racks */
{&OPEN-QUERY-BROWSE-2} 
REPOSITION BROWSE-2 TO ROWID lRowID.

/* Paletas */
{&OPEN-QUERY-BROWSE-4}  

/* Detalle */
lNroPaleta = "".
IF AVAILABLE vtactabla THEN DO:
    lNroPaleta = vtactabla.libre_c02.
END.

{&OPEN-QUERY-BROWSE-6}  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

