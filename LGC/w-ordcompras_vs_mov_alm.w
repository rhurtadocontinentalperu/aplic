&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-Almdmov NO-UNDO LIKE INTEGRAL.Almdmov.



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

DEFINE SHARED VAR s-codcia AS INT.

DEFINE VAR lTpoDoc AS CHAR INIT "".
DEFINE VAR lNroDoc AS INT INIT 0.
DEFINE VAR lCodPro AS CHAR INIT "".
DEFINE VAR lFechaDesde AS DATE.
DEFINE VAR lFechaHasta AS DATE.

/* Cabecera */
DEFINE VAR lxCodDiv LIKE lg-cocmp.coddiv.
DEFINE VAR lxTpoDoc LIKE lg-cocmp.tpodoc.
DEFINE VAR lxNroDoc LIKE lg-docmp.nrodoc.
/* Detalle */
DEFINE VAR lCodMat LIKE lg-docmp.codmat.
DEFINE VAR lNroOC AS CHAR INIT "".

DEFINE VAR X-estado AS CHAR.
DEFINE VAR X-moneda AS CHAR.

lFechaDesde = TODAY - 1.
lFechaHasta = TODAY.

/* Ordenes de Compra - Cabecera */
&SCOPED-DEFINE CONDICION ( ~
            ( lg-cocmp.CodCia = s-codcia ) AND ~
            ( lg-cocmp.fchdoc >= lFechaDesde AND lg-cocmp.fchdoc <= lFechaHasta ) AND ~
            ( (lTpoDoc = "" AND lg-cocmp.tpodoc <> 'C') OR (lg-cocmp.tpodoc = lTpoDoc )) AND ~
            ( lCodPro = "" OR lg-cocmp.codpro = lCodPro ) AND ( lNroDoc = 0 OR lg-cocmp.nrodoc = lNroDOc) )

/* Ordenes de Compra - Detalle */
&SCOPED-DEFINE CONDICION-DTL ( ~
            lg-docmp.CodCia = lg-cocmp.CodCia AND lg-docmp.coddiv = lxCodDiv AND ~
            lg-docmp.tpodoc = lxTpoDoc AND lg-docmp.nrodoc = lxNroDoc )

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
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES INTEGRAL.LG-COCmp INTEGRAL.LG-DOCmp ~
INTEGRAL.Almmmatg tt-Almdmov

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 INTEGRAL.LG-COCmp.TpoDoc ~
INTEGRAL.LG-COCmp.NroDoc INTEGRAL.LG-COCmp.Fchdoc ~
uf-estado(LG-COCmp.FlgSit) @ x-Estado INTEGRAL.LG-COCmp.CodPro ~
INTEGRAL.LG-COCmp.NomPro uf-moneda(INTEGRAL.LG-COCmp.Codmon) @ x-moneda ~
INTEGRAL.LG-COCmp.CodAlm INTEGRAL.LG-COCmp.ImpNet INTEGRAL.LG-COCmp.ImpIgv ~
INTEGRAL.LG-COCmp.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH INTEGRAL.LG-COCmp ~
      WHERE {&CONDICION} NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH INTEGRAL.LG-COCmp ~
      WHERE {&CONDICION} NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 INTEGRAL.LG-COCmp
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 INTEGRAL.LG-COCmp


/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 INTEGRAL.LG-DOCmp.Codmat ~
INTEGRAL.Almmmatg.DesMat INTEGRAL.Almmmatg.DesMar INTEGRAL.LG-DOCmp.UndCmp ~
INTEGRAL.LG-DOCmp.CanPedi INTEGRAL.LG-DOCmp.CanAten ~
INTEGRAL.LG-DOCmp.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH INTEGRAL.LG-DOCmp ~
      WHERE {&CONDICION-DTL} NO-LOCK, ~
      FIRST INTEGRAL.Almmmatg OF INTEGRAL.LG-DOCmp NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH INTEGRAL.LG-DOCmp ~
      WHERE {&CONDICION-DTL} NO-LOCK, ~
      FIRST INTEGRAL.Almmmatg OF INTEGRAL.LG-DOCmp NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 INTEGRAL.LG-DOCmp INTEGRAL.Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 INTEGRAL.LG-DOCmp
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-5 INTEGRAL.Almmmatg


/* Definitions for BROWSE BROWSE-6                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-6 tt-Almdmov.CodAlm tt-Almdmov.NroSer ~
tt-Almdmov.NroDoc tt-Almdmov.FchDoc tt-Almdmov.CodMov tt-Almdmov.CodUnd ~
tt-Almdmov.CanDes tt-Almdmov.PreUni tt-Almdmov.ImpCto tt-Almdmov.HraDoc ~
tt-Almdmov.CodAnt 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-6 
&Scoped-define QUERY-STRING-BROWSE-6 FOR EACH tt-Almdmov NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-6 OPEN QUERY BROWSE-6 FOR EACH tt-Almdmov NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-6 tt-Almdmov
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-6 tt-Almdmov


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-3}~
    ~{&OPEN-QUERY-BROWSE-5}~
    ~{&OPEN-QUERY-BROWSE-6}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rbox_tipo txtDesde txtHasta txtOrdenCompra ~
btnProcesar txtProveedor BROWSE-3 BROWSE-5 BROWSE-6 
&Scoped-Define DISPLAYED-OBJECTS rbox_tipo txtDesde txtHasta txtOrdenCompra ~
txtProveedor txt-nomprov 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD uf-estado wWin 
FUNCTION uf-estado RETURNS CHARACTER
  ( INPUT cFlgSit AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD uf-moneda wWin 
FUNCTION uf-moneda RETURNS CHARACTER
  ( INPUT pMoneda AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnProcesar 
     LABEL "Consultar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txt-nomprov AS CHARACTER FORMAT "X(80)":U 
     VIEW-AS FILL-IN 
     SIZE 70 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtOrdenCompra AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     LABEL "Alguna O/C en especial" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtProveedor AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE rbox_tipo AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Nacionales", 1,
"Importaciones", 2,
"Ambos", 3
     SIZE 18 BY 2.27 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      INTEGRAL.LG-COCmp SCROLLING.

DEFINE QUERY BROWSE-5 FOR 
      INTEGRAL.LG-DOCmp, 
      INTEGRAL.Almmmatg SCROLLING.

DEFINE QUERY BROWSE-6 FOR 
      tt-Almdmov SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 wWin _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      INTEGRAL.LG-COCmp.TpoDoc FORMAT "X":U
      INTEGRAL.LG-COCmp.NroDoc FORMAT "999999":U
      INTEGRAL.LG-COCmp.Fchdoc FORMAT "99/99/9999":U
      uf-estado(LG-COCmp.FlgSit) @ x-Estado COLUMN-LABEL "Estado"
            WIDTH 9.43
      INTEGRAL.LG-COCmp.CodPro FORMAT "x(11)":U
      INTEGRAL.LG-COCmp.NomPro FORMAT "X(40)":U
      uf-moneda(INTEGRAL.LG-COCmp.Codmon) @ x-moneda COLUMN-LABEL "Moneda"
      INTEGRAL.LG-COCmp.CodAlm COLUMN-LABEL "Alm" FORMAT "x(3)":U
            WIDTH 4.72
      INTEGRAL.LG-COCmp.ImpNet FORMAT "ZZ,ZZZ,ZZ9.99":U WIDTH 11.43
      INTEGRAL.LG-COCmp.ImpIgv FORMAT "Z,ZZZ,ZZ9.99":U WIDTH 9.57
      INTEGRAL.LG-COCmp.ImpTot FORMAT "ZZ,ZZZ,ZZ9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 134 BY 7.31 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 wWin _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      INTEGRAL.LG-DOCmp.Codmat FORMAT "x(8)":U
      INTEGRAL.Almmmatg.DesMat FORMAT "X(45)":U
      INTEGRAL.Almmmatg.DesMar FORMAT "X(30)":U
      INTEGRAL.LG-DOCmp.UndCmp COLUMN-LABEL "UND" FORMAT "X(3)":U
            WIDTH 7.72
      INTEGRAL.LG-DOCmp.CanPedi FORMAT "Z,ZZZ,ZZ9.99":U
      INTEGRAL.LG-DOCmp.CanAten FORMAT "Z,ZZZ,ZZ9.99":U WIDTH 13.72
      INTEGRAL.LG-DOCmp.ImpTot FORMAT ">>,>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 134 BY 7.5 ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-6 wWin _STRUCTURED
  QUERY BROWSE-6 NO-LOCK DISPLAY
      tt-Almdmov.CodAlm FORMAT "x(3)":U
      tt-Almdmov.NroSer COLUMN-LABEL "Serie Ingreso" FORMAT "999":U
      tt-Almdmov.NroDoc COLUMN-LABEL "Nro.Ingreso" FORMAT "999999":U
      tt-Almdmov.FchDoc FORMAT "99/99/9999":U
      tt-Almdmov.CodMov FORMAT "99":U
      tt-Almdmov.CodUnd FORMAT "X(10)":U
      tt-Almdmov.CanDes FORMAT "(ZZZ,ZZZ,ZZ9.9999)":U WIDTH 12.14
      tt-Almdmov.PreUni FORMAT "(Z,ZZZ,ZZ9.9999)":U WIDTH 11.43
      tt-Almdmov.ImpCto COLUMN-LABEL "Importe sin IGV" FORMAT "(Z,ZZZ,ZZZ,ZZ9.9999)":U
      tt-Almdmov.HraDoc COLUMN-LABEL "Factura-Prov" FORMAT "x(15)":U
      tt-Almdmov.CodAnt COLUMN-LABEL "Guia Proveedor" FORMAT "X(15)":U
            WIDTH 18.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS NO-TAB-STOP SIZE 134 BY 8.12 ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     rbox_tipo AT ROW 1.35 COL 2.29 NO-LABEL WIDGET-ID 8
     txtDesde AT ROW 1.38 COL 29.14 COLON-ALIGNED WIDGET-ID 2
     txtHasta AT ROW 1.38 COL 52 COLON-ALIGNED WIDGET-ID 4
     txtOrdenCompra AT ROW 1.38 COL 89 COLON-ALIGNED WIDGET-ID 6
     btnProcesar AT ROW 1.58 COL 118 WIDGET-ID 16
     txtProveedor AT ROW 2.88 COL 29.43 COLON-ALIGNED WIDGET-ID 12
     txt-nomprov AT ROW 2.88 COL 46 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     BROWSE-3 AT ROW 4.27 COL 2 WIDGET-ID 200
     BROWSE-5 AT ROW 11.77 COL 2 WIDGET-ID 300
     BROWSE-6 AT ROW 19.42 COL 2 WIDGET-ID 400
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 136 BY 26.81 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: tt-Almdmov T "?" NO-UNDO INTEGRAL Almdmov
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Consulta O/C vs Movimiento Almacen"
         HEIGHT             = 26.81
         WIDTH              = 136
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
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-3 txt-nomprov fMain */
/* BROWSE-TAB BROWSE-5 BROWSE-3 fMain */
/* BROWSE-TAB BROWSE-6 BROWSE-5 fMain */
/* SETTINGS FOR FILL-IN txt-nomprov IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "INTEGRAL.LG-COCmp"
     _Options          = "NO-LOCK"
     _Where[1]         = "{&CONDICION}"
     _FldNameList[1]   = INTEGRAL.LG-COCmp.TpoDoc
     _FldNameList[2]   = INTEGRAL.LG-COCmp.NroDoc
     _FldNameList[3]   = INTEGRAL.LG-COCmp.Fchdoc
     _FldNameList[4]   > "_<CALC>"
"uf-estado(LG-COCmp.FlgSit) @ x-Estado" "Estado" ? ? ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = INTEGRAL.LG-COCmp.CodPro
     _FldNameList[6]   = INTEGRAL.LG-COCmp.NomPro
     _FldNameList[7]   > "_<CALC>"
"uf-moneda(INTEGRAL.LG-COCmp.Codmon) @ x-moneda" "Moneda" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.LG-COCmp.CodAlm
"CodAlm" "Alm" ? "character" ? ? ? ? ? ? no ? no no "4.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.LG-COCmp.ImpNet
"ImpNet" ? ? "decimal" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.LG-COCmp.ImpIgv
"ImpIgv" ? ? "decimal" ? ? ? ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   = INTEGRAL.LG-COCmp.ImpTot
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "INTEGRAL.LG-DOCmp,INTEGRAL.Almmmatg OF INTEGRAL.LG-DOCmp"
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST"
     _Where[1]         = "{&CONDICION-DTL}"
     _FldNameList[1]   = INTEGRAL.LG-DOCmp.Codmat
     _FldNameList[2]   = INTEGRAL.Almmmatg.DesMat
     _FldNameList[3]   = INTEGRAL.Almmmatg.DesMar
     _FldNameList[4]   > INTEGRAL.LG-DOCmp.UndCmp
"LG-DOCmp.UndCmp" "UND" ? "character" ? ? ? ? ? ? no ? no no "7.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = INTEGRAL.LG-DOCmp.CanPedi
     _FldNameList[6]   > INTEGRAL.LG-DOCmp.CanAten
"LG-DOCmp.CanAten" ? ? "decimal" ? ? ? ? ? ? no ? no no "13.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = INTEGRAL.LG-DOCmp.ImpTot
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-6
/* Query rebuild information for BROWSE BROWSE-6
     _TblList          = "Temp-Tables.tt-Almdmov"
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST"
     _FldNameList[1]   = Temp-Tables.tt-Almdmov.CodAlm
     _FldNameList[2]   > Temp-Tables.tt-Almdmov.NroSer
"NroSer" "Serie Ingreso" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-Almdmov.NroDoc
"NroDoc" "Nro.Ingreso" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.tt-Almdmov.FchDoc
     _FldNameList[5]   = Temp-Tables.tt-Almdmov.CodMov
     _FldNameList[6]   = Temp-Tables.tt-Almdmov.CodUnd
     _FldNameList[7]   > Temp-Tables.tt-Almdmov.CanDes
"CanDes" ? ? "decimal" ? ? ? ? ? ? no ? no no "12.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-Almdmov.PreUni
"PreUni" ? ? "decimal" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-Almdmov.ImpCto
"ImpCto" "Importe sin IGV" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-Almdmov.HraDoc
"HraDoc" "Factura-Prov" "x(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tt-Almdmov.CodAnt
"CodAnt" "Guia Proveedor" "X(15)" "character" ? ? ? ? ? ? no ? no no "18.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-6 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Consulta O/C vs Movimiento Almacen */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Consulta O/C vs Movimiento Almacen */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&Scoped-define SELF-NAME BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-3 wWin
ON VALUE-CHANGED OF BROWSE-3 IN FRAME fMain
DO:
    lxCodDiv = lg-cocmp.coddiv.
    lxTpoDoc = lg-cocmp.tpodoc.
    lxNroDoc = lg-cocmp.nrodoc.

    {&OPEN-QUERY-BROWSE-5}  

    RUN ue-carga-articulos. /* Almacenes */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-5
&Scoped-define SELF-NAME BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-5 wWin
ON VALUE-CHANGED OF BROWSE-5 IN FRAME fMain
DO:
    /*
    lCodMat = lg-docmp.codmat.
    lNroOC = STRING(lg-cocmp.nrodoc).

    {&OPEN-QUERY-BROWSE-6}
  */
    /*
    FOR EACH almacen WHERE almacen.codcia = 1 NO-LOCK:
        FOR EACH almcmov OF almacen WHERE almcmov.codcia = 1 AND almcmov.codalm = almacen.codalm AND almcmov.tipmov = 'I' AND 
            (almcmov.codmov = 2 OR almcmov.codmov = 6)   AND almcmov.nrorf1 = '95834' NO-LOCK:
            DISPLAY almcmov.codalm almcmov.nrodoc.
        END.
    END.
    */

    RUN ue-carga-articulos. /* Movimientos de Almacen */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnProcesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnProcesar wWin
ON CHOOSE OF btnProcesar IN FRAME fMain /* Consultar */
DO:
    ASSIGN txtDesde txtHasta txtProveedor txtOrdenCompra rbox_tipo.

    DEFINE VAR lTpoDoc AS CHAR INIT "".
    DEFINE VAR lNroDoc AS INT INIT 0.
    DEFINE VAR lCodPro AS CHAR INIT "".
    DEFINE VAR lFechaDesde AS DATE.
    DEFINE VAR lFechaHasta AS DATE.

    lTpoDoc = "".
    IF rbox_tipo = 1 THEN lTpoDoc = 'N'.
    IF rbox_tipo = 2 THEN lTpoDoc = 'I'.        

    lNroDoc = txtOrdenCompra.
    lCodPro = txtProveedor.
    lFechaDesde = txtDesde.
    lFechaHasta = txtHasta.
    {&OPEN-QUERY-BROWSE-3}

    /**/
    IF AVAILABLE LG-COCMP THEN DO:
        lxCodDiv = lg-cocmp.coddiv.
        lxTpoDoc = lg-cocmp.tpodoc.
        lxNroDoc = lg-cocmp.nrodoc.
    END.
    ELSE DO: 
        lxCodDiv = "***".
        lxTpoDoc = "X".
        lxNroDoc = 0.
    END.

    {&OPEN-QUERY-BROWSE-5}  
    RUN ue-carga-articulos. /* Movimientos del almacen */


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

IF AVAILABLE lg-cocmp THEN DO:
    lxCodDiv = lg-cocmp.coddiv.
    lxTpoDoc = lg-cocmp.tpodoc.
    lxNroDoc = lg-cocmp.nrodoc.

    {&OPEN-QUERY-BROWSE-5}

    RUN ue-carga-articulos.  /* Movimientos de Almacen */

END.

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
  DISPLAY rbox_tipo txtDesde txtHasta txtOrdenCompra txtProveedor txt-nomprov 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE rbox_tipo txtDesde txtHasta txtOrdenCompra btnProcesar txtProveedor 
         BROWSE-3 BROWSE-5 BROWSE-6 
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

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  txtDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 1,"99/99/9999").
  txtHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-carga-articulos wWin 
PROCEDURE ue-carga-articulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE('GENERAL').

EMPTY TEMP-TABLE tt-almdmov.
{&OPEN-QUERY-BROWSE-6}

IF AVAILABLE lg-docmp THEN DO:
    lCodMat = lg-docmp.codmat.
    lNroOC = STRING(lg-cocmp.nrodoc).

    FOR EACH almacen WHERE almacen.codcia = s-codcia NO-LOCK:
        FOR EACH almcmov OF almacen WHERE almcmov.codcia = s-codcia AND almcmov.codalm = almacen.codalm AND almcmov.tipmov = 'I' AND 
            almcmov.codmov = 2   AND almcmov.nrorf1 = lNroOC NO-LOCK,
            EACH almdmov OF almcmov NO-LOCK WHERE almdmov.codcia = s-codcia AND almdmov.codmat = lCodMat :

            CREATE tt-almdmov.
                BUFFER-COPY almdmov TO tt-almdmov.
                /* Factura - Guia Remision */
                ASSIGN tt-almdmov.hradoc = almcmov.nrorf2
                        tt-almdmov.codant = almcmov.nrorf3.

        END.
    END.
    lNroOC = STRING(lg-cocmp.nrodoc,"999999").
    FOR EACH almacen WHERE almacen.codcia = s-codcia NO-LOCK:
        FOR EACH almcmov OF almacen WHERE almcmov.codcia = s-codcia AND almcmov.codalm = almacen.codalm AND almcmov.tipmov = 'I' AND 
            almcmov.codmov = 6   AND almcmov.nrorf1 = lNroOC NO-LOCK,
            EACH almdmov OF almcmov NO-LOCK WHERE almdmov.codcia = s-codcia AND almdmov.codmat = lCodMat :

            CREATE tt-almdmov.
                BUFFER-COPY almdmov TO tt-almdmov.
                /* Factura - Guia Remision */
                ASSIGN tt-almdmov.hradoc = almcmov.nrorf2
                        tt-almdmov.codant = almcmov.nrorf3.


        END.
    END.
END.

{&OPEN-QUERY-BROWSE-6}

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-condicion wWin 
PROCEDURE ue-condicion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION uf-estado wWin 
FUNCTION uf-estado RETURNS CHARACTER
  ( INPUT cFlgSit AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR lRetVal AS CHAR.

lRetVal = "".

IF LOOKUP(cFlgSit,"X,G,P,A,T,V,R,C") > 0 THEN
        lRetVal = ENTRY(LOOKUP(cFlgSit,"X,G,P,A,T,V,R,C"),"Rechazado,Emitido,Aprobado,Anulado,Aten.Total,Vencida,En Revision,Cerrada").


  RETURN lRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION uf-moneda wWin 
FUNCTION uf-moneda RETURNS CHARACTER
  ( INPUT pMoneda AS INT) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR lMoneda AS CHAR.

IF pMoneda = 2 THEN DO:
    lMoneda = '($.)'.
END.
ELSE DO:
    lMoneda = '(S/.)'.
END.

  RETURN lMoneda.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

