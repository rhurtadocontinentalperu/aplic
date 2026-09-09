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

DEFINE SHARED VARIABLE s-codcia  AS INT.
DEFINE SHARED VARIABLE cl-codcia AS INT.

DEFINE BUFFER od_faccpedi FOR faccpedi.
DEFINE BUFFER gr_ccbcdocu FOR ccbcdocu.

DEFINE TEMP-TABLE tt-seguimiento NO-UNDO
        /* PEDIDO */
        FIELDS tt-codped    LIKE faccpedi.coddoc    LABEL "Cod.Pedido"
        FIELDS tt-nroped    LIKE faccpedi.nroped    LABEL "Nro.Pedido"
        FIELDS tt-fchped    LIKE faccpedi.fchped    LABEL "F.Emision Pedido"
        FIELDS tt-horped    AS CHAR                 LABEL "H.Emision Pedido"        FORMAT 'x(20)'
        FIELDS tt-divped    LIKE faccpedi.coddiv    LABEL "Div.Pedido Pedido"
        FIELDS tt-lprecio   AS CHAR                 LABEL "Lista de Precio"          FORMAT 'x(6)'
        /* Orden */
        FIELDS tt-codord    LIKE faccpedi.coddoc    LABEL "Cod.Orden"
        FIELDS tt-nroord    LIKE faccpedi.nroped    LABEL "Nro.Orden"
        FIELDS tt-fchord    AS DATE                 LABEL "Fecha Emision Orden"
        FIELDS tt-horord    AS CHAR                 LABEL "Hora Emision Orden"         FORMAT 'x(20)'
        FIELDS tt-fchentord AS DATE                 LABEL "Fecha Entrega Orden"
        FIELDS tt-fchaprord AS DATE                 LABEL "Fecha Aprob. orden"
        FIELDS tt-usrasgord AS CHAR                 LABEL "Usuario Asigando Orden"  FORMAT 'x(20)'
        FIELDS tt-fchasgord AS DATE                 LABEL "Fecha Asignacion Orden"
        FIELDS tt-horasgord AS CHAR                 LABEL "Hora Asiganacion Orden"  FORMAT 'x(20)'
        /* PreChequeo */
        FIELDS tt-finiprechq AS DATE                LABEL "Fecha Inicio PreChecking"
        FIELDS tt-Hiniprechq AS CHAR                LABEL "Hora Inicio PreChecking"
        FIELDS tt-ffinprechq AS CHAR                LABEL "Fecha/Hora Fin PreChecking" FORMAT 'x(25)'
        FIELDS tt-Hfinprechq AS CHAR                LABEL "Hora Fin PreChecking"
        FIELDS tt-volumen   AS DEC                  LABEL "Volumen(m3) de la O/D"      FORMAT "->>,>>>,>>9.9999"
        FIELDS tt-qitms     AS INT                  LABEL "Items de la O/D"
        FIELDS tt-peso      AS DEC                  LABEL "Peso de la O/D"
        FIELDS tt-imptot    LIKE faccpedi.imptot    LABEL "S/. Importe Venta Con IGV (O/D)"
        FIELDS tt-imprepo   LIKE faccpedi.imptot    LABEL "S/. Importe Reposicion con IGV (O/D)"
        FIELDS tt-impkard   LIKE faccpedi.imptot    LABEL "S/. Costo Promedio Kardex (O/D)"
        /* Envio a Distribucion */
        FIELDS tt-fhimp     LIKE faccpedi.fchimpod  LABEL "Fecha/Hora Impresion" FORMAT '99/99/9999 HH:MM:SS.SSS'
        FIELDS tt-fdistr    AS DATETIME             LABEL "Fecha/Hora Distribucion" FORMAT '99/99/9999 HH:MM:SS.SSS'
        /* Chequeo */
        FIELDS tt-nrohpk    AS CHAR FORMAT 'x(15)'  LABEL "HPK"
        FIELDS tt-finicheq  LIKE ccbcbult.dte_01    LABEL "Dia inicio Chequeo"
        FIELDS tt-hinicheq  LIKE ccbcbult.CHR_03    LABEL "Hora inicio Chequeo"
        FIELDS tt-ffincheq  LIKE ccbcbult.dte_01    LABEL "Dia fin Chequeo"
        FIELDS tt-hfincheq  LIKE ccbcbult.CHR_03    LABEL "Hora fin de chequeo" FORMAT 'x(6)'
        FIELDS tt-bultos    LIKE ccbcbult.bultos    LABEL "Bultos" FORMAT '>>>>9'
        FIELDS tt-frotula   AS DATE                 LABEL "Fecha Rotulado"
        /* Generacion del Comprobante */
        FIELDS tt-cdoc      LIKE faccpedi.coddoc    LABEL "Doc"
        FIELDS tt-ndoc      LIKE faccpedi.nroped    LABEL "Nro Dcto"                
        FIELDS tt-xfemi     AS DATE                 LABEL "Dcto Fecha Emision"
        FIELDS tt-xhemi     AS CHAR                 LABEL "Dcto Hora Emision"       FORMAT 'x(20)'
        FIELDS tt-origen    LIKE gn-div.desdiv      LABEL "Division Emision"        
        FIELDS tt-codcli    LIKE faccpedi.codcli    LABEL "CodCliente"
        FIELDS tt-nomcli    LIKE faccpedi.nomcli    LABEL "Nombre del Cliente"
        FIELDS tt-docremi   LIKE faccpedi.coddoc    LABEL "Doc.Remision"
        FIELDS tt-nroremi   LIKE faccpedi.nroped    LABEL "Nro Remision"                
        /* Ruta */
        FIELDS tt-hruta         LIKE di-rutac.nrodoc    LABEL "Numero H/R"        
        FIELDS tt-fsalidaHR     AS DATE                 LABEL "Fecha Salida H/R"
        FIELDS tt-hsalidaHR     LIKE di-rutaC.horsal    LABEL "Hora Salida H/R" FORMAT 'x(6)'
        FIELDS tt-hretornoHR    LIKE di-rutac.horret    LABEL "Hora Retorno H/R" FORMAT 'x(6)'        
        /* Transportista */
        FIELDS tt-placa     LIKE di-rutaC.codveh    LABEL "Placa"       FORMAT 'x(25)'
        FIELDS tt-gtranspo  LIKE di-rutaC.guiatransportista LABEL "Guia Transp."
        FIELDS tt-transpo   AS CHAR                 LABEL "Transportista" FORMAT 'x(60)'
        FIELDS tt-tipomov   AS CHAR                 LABEL "Tipo Movim." FORMAT 'x(15)'
        FIELDS tt-divori    AS CHAR FORMAT 'x(6)'   LABEL "Division DESPACHO"
        FIELDS tt-almacen       AS CHAR     FORMAT 'x(6)'   LABEL "Almacen Despacho"
        /* Salida/dev mercaderia segun vigilancia */
        FIELDS tt-fchsalvig AS DATE                 LABEL "Fecha Salida Vigilancia"
        FIELDS tt-horsalvig AS CHAR                 LABEL "Hora Salida Vigilancia" FORMAT 'x(20)'
        FIELDS tt-fchdevvig AS DATE                 LABEL "Fecha Devolucion Vigilancia"
        FIELDS tt-hordevvig AS CHAR                 LABEL "Hora Devolucion Vigilancia" FORMAT 'x(20)'
        /* Entrega al cliente */
        FIELDS tt-hllegada  LIKE di-rutaD.horlle    LABEL "Hora Llegada"    FORMAT 'x(6)'
        FIELDS tt-hpartida  LIKE di-rutaD.horpar    LABEL "Hora Partida"    FORMAT 'x(6)'
        /*  */
        FIELDS tt-dpto      AS CHAR                 LABEL "Dpto"        FORMAT 'x(60)'
        FIELDS tt-prov      AS CHAR                 LABEL "Provincia"   FORMAT 'x(60)'
        FIELDS tt-dist      AS CHAR                 LABEL "Distrito"    FORMAT 'x(60)'
        FIELDS tt-destino   AS CHAR                 LABEL "Destino"     FORMAT 'x(60)'  
        /**/
        FIELDS tt-dircli    AS CHAR                 LABEL "Direccion Cliente"    FORMAT 'x(120)'
        FIELDS tt-lugent    AS CHAR                 LABEL "Lugar de Entrega"     FORMAT 'x(100)'
        FIELDS tt-codpos    AS CHAR                 LABEL "Cod.Postal"   FORMAT 'x(5)'
        FIELDS tt-despos    AS CHAR                 LABEL "Postal"   FORMAT 'x(60)'
        FIELDS tt-glosa     AS CHAR                 LABEL "Observa"     FORMAT 'x(100)'
        FIELDS tt-estado    AS CHAR                 LABEL "Estado" FORMAT 'x(20)'
        FIELDS tt-transportista    AS CHAR                 LABEL "Transportista" FORMAT 'x(60)'
        FIELDS tt-transporte    AS CHAR                 LABEL "Transporte - Tramo 01" FORMAT 'x(60)'
        FIELDS tt-direccTransporte    AS CHAR                 LABEL "Direcc.Transporte" FORMAT 'x(60)'
        FIELDS tt-lugarentrega    AS CHAR                 LABEL "Lugar de entrega - Tramo 02" FORMAT 'x(60)'
        /* */
        FIELDS tt-situacion AS CHAR                 LABEL "Situacion" FORMAT 'x(50)'
        /* Pasa por aprobar Créditos */
        FIELD tt-fchingcre AS DATE LABEL "Fecha Ing. a Créditos"
        FIELD tt-horingcre AS CHAR LABEL "Hora Ing. a Créditos"
    .

DEFINE VAR lqItems AS INT.
DEFINE VAR lqPeso AS DEC.
DEFINE VAR lqVolumen AS DEC.
DEFINE VAR lqCostoVenta AS DEC.
DEFINE VAR lqCostoReposicion AS DEC.
DEFINE VAR lqCostoKardex AS DEC.
DEFINE VAR lCodPro AS CHAR.
DEFINE VAR lDestino AS CHAR.
DEFINE VAR lDpto AS CHAR.
DEFINE VAR lProv AS CHAR.
DEFINE VAR lDist AS CHAR.
DEFINE VAR lDcli AS CHAR.
DEFINE VAR lDespro AS CHAR.
DEFINE VAR lOrigen AS CHAR.

DEFINE TEMP-TABLE tt-control NO-UNDO
    FIELDS  tt-nhojaruta    AS CHAR    FORMAT 'x(10)'
    FIELDS  tt-coddoc       AS CHAR    FORMAT 'x(3)'
    FIELDS  tt-nrodoc       AS CHAR    FORMAT 'x(11)'.


/*    INDEX idx01 IS PRIMARY tt-coddoc tt-nrodoc tt-cdoc tt-ndoc. */

/*
DEFINE TEMP-TABLE tt-rsmen
        FIELDS tt-codref    LIKE faccpedi.coddoc    LABEL "Cod.Ref"
        FIELDS tt-nroref    LIKE faccpedi.nroped    LABEL "Nro.Ref"
        FIELDS tt-faprueba  LIKE faccpedi.fchaprobacion    LABEL "Aprobacion"
        FIELDS tt-coddoc    LIKE faccpedi.coddoc    LABEL "Codigo"
        FIELDS tt-nrodoc    LIKE faccpedi.nroped    LABEL "Numero"        
        FIELDS tt-femi      LIKE faccpedi.fchped    LABEL "Orden Fecha Emision"
        FIELDS tt-hemi      LIKE faccpedi.hora      LABEL "Orden Hora Emision"
        FIELDS tt-finiprechq AS DATE                LABEL "Fecha Inicio Pre-picking"
        FIELDS tt-Hiniprechq AS CHAR                LABEL "Hora Inicio Pre-picking"
        FIELDS tt-ffinprechq AS CHAR                LABEL "Fecha/Hora Fin Pre-picking" FORMAT 'x(25)'
        /*FIELDS tt-Hfinprechq AS CHAR                LABEL "Hora Fin Pre-picking"*/
        FIELDS tt-cdoc      LIKE faccpedi.coddoc    LABEL "Doc"
        FIELDS tt-ndoc      LIKE faccpedi.nroped    LABEL "Nro Guia"                
        FIELDS tt-xfemi     LIKE faccpedi.fchped    LABEL "Dcto Fecha Emision"
        FIELDS tt-xhemi     LIKE faccpedi.hora      LABEL "Dcto Hora Emision"
        FIELDS tt-origen    LIKE gn-div.desdiv      LABEL "Origen"
        FIELDS tt-codcli    LIKE faccpedi.codcli    LABEL "CodCliente"
        FIELDS tt-nomcli    LIKE faccpedi.nomcli    LABEL "Nombre del Cliente"
        FIELDS tt-fhimp     LIKE faccpedi.fchimpod  LABEL "Fecha/Hora Impresion" FORMAT '99/99/9999 HH:MM:SS.SSS'
        FIELDS tt-fdistr    AS DATETIME             LABEL "Fecha/Hora Distribucion" FORMAT '99/99/9999 HH:MM:SS.SSS'
        FIELDS tt-qitms     AS INT                  LABEL "Items"
        FIELDS tt-fent      LIKE faccpedi.fchent    LABEL "Entrega"
        FIELDS tt-peso      AS DEC                  LABEL "Peso"
        FIELDS tt-bultos    LIKE ccbcbult.bultos    LABEL "Bultos" FORMAT '>>>>9'
        FIELDS tt-frotula   LIKE ccbcbult.fchdoc    LABEL "Fecha Rotulado"
        FIELDS tt-finicheq  LIKE ccbcbult.dte_01    LABEL "Dia inicio Chequeo"
        FIELDS tt-hinicheq  LIKE ccbcbult.CHR_03    LABEL "Hora inicio Chequeo"
        FIELDS tt-ffincheq  LIKE ccbcbult.dte_01    LABEL "Dia fin Chequeo"
        FIELDS tt-hfincheq  LIKE ccbcbult.CHR_03    LABEL "Hora fin de chequeo" FORMAT 'x(6)'
        FIELDS tt-hruta     LIKE di-rutac.nrodoc    LABEL "Numero H/R"
        FIELDS tt-hsalida   LIKE di-rutaC.horsal    LABEL "Hora Salida" FORMAT 'x(6)'
        FIELDS tt-hretorno  LIKE di-rutac.horret    LABEL "Hora Retorno" FORMAT 'x(6)'
        FIELDS tt-fsalida   LIKE di-rutaC.fchsal    LABEL "Fecha Salida"
        FIELDS tt-placa     LIKE di-rutaC.codveh    LABEL "Placa"       FORMAT 'x(25)'
        FIELDS tt-gtranspo  LIKE di-rutaC.guiatransportista LABEL "Guia Transp."
        FIELDS tt-transpo   AS CHAR                 LABEL "Transportista" FORMAT 'x(60)'
        FIELDS tt-tipomov   AS CHAR                 LABEL "Tipo Movim." FORMAT 'x(15)'
        FIELDS tt-divori    LIKE di-rutac.coddiv    LABEL "Division"
        FIELDS tt-hllegada  LIKE di-rutaD.horlle    LABEL "Hora Llegada"    FORMAT 'x(6)'
        FIELDS tt-hpartida  LIKE di-rutaD.horpar    LABEL "Hora Partida"    FORMAT 'x(6)'
        FIELDS tt-dpto      AS CHAR                 LABEL "Dpto"        FORMAT 'x(60)'
        FIELDS tt-prov      AS CHAR                 LABEL "Provincia"   FORMAT 'x(60)'
        FIELDS tt-dist      AS CHAR                 LABEL "Distrito"    FORMAT 'x(60)'
        FIELDS tt-destino   AS CHAR                 LABEL "Destino"     FORMAT 'x(60)'
        FIELDS tt-imptot    LIKE faccpedi.imptot    LABEL "S/. Importe Venta Con IGV"
        FIELDS tt-imprepo   LIKE faccpedi.imptot    LABEL "S/. Importe Reposicion con IGV"
        FIELDS tt-impkard   LIKE faccpedi.imptot    LABEL "S/. Costo Promedio Kardex"
        FIELDS tt-estado    AS CHAR                 LABEL "Estado" FORMAT 'x(20)'

    INDEX idx01 IS PRIMARY tt-coddoc tt-nrodoc tt-cdoc tt-ndoc.

*/

define stream REPORT.
DEFINE VARIABLE x-Archivo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-rpta    AS LOGICAL     NO-UNDO.

DEFINE VAR lTiempoDesde AS DATETIME.
DEFINE VAR lTiempoHasta AS DATETIME.

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
&Scoped-Define ENABLED-OBJECTS txtCoddivi txtDesde txtHasta txtProcesar ~
ChkbxResumen 
&Scoped-Define DISPLAYED-OBJECTS txtCoddivi txtDesDivi txtDesde txtHasta ~
ChkbxGenTxt ChkbxResumen 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fchDistribucion wWin 
FUNCTION fchDistribucion RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fFlgEst-Detalle wWin 
FUNCTION fFlgEst-Detalle RETURNS CHARACTER
  ( INPUT cFlgEst AS CHAR  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fImportes wWin 
FUNCTION fImportes RETURNS DECIMAL
  ( /**/ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fImpTot wWin 
FUNCTION fImpTot RETURNS DECIMAL
  ( INPUT pDoc AS CHAR, INPUT pTipo AS CHAR  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fItems-Peso wWin 
FUNCTION fItems-Peso RETURNS INTEGER
  ( /**/ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPeso wWin 
FUNCTION fPeso RETURNS DECIMAL
  ( INPUT pTipo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fQitems wWin 
FUNCTION fQitems RETURNS INTEGER
  ( INPUT pTipo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON txtProcesar 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtCoddivi AS CHARACTER FORMAT "X(5)":U 
     LABEL "Alguna division ?" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesDivi AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE ChkbxGenTxt AS LOGICAL INITIAL yes 
     LABEL "Generar file TXT" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .77 NO-UNDO.

DEFINE VARIABLE ChkbxResumen AS LOGICAL INITIAL no 
     LABEL "Solo datos de cabecera" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     txtCoddivi AT ROW 2.23 COL 19.72 COLON-ALIGNED WIDGET-ID 2
     txtDesDivi AT ROW 2.23 COL 28.57 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     txtDesde AT ROW 5.19 COL 13 COLON-ALIGNED WIDGET-ID 4
     txtHasta AT ROW 5.19 COL 35.14 COLON-ALIGNED WIDGET-ID 6
     ChkbxGenTxt AT ROW 6.96 COL 18 WIDGET-ID 22
     txtProcesar AT ROW 7.35 COL 61 WIDGET-ID 8
     ChkbxResumen AT ROW 7.73 COL 18 WIDGET-ID 26
     "(valido solo para PEDIDOS)" VIEW-AS TEXT
          SIZE 27 BY .62 AT ROW 3.27 COL 22 WIDGET-ID 24
     "PED, R/A  y TRA que esten emitidos en este rango de fechas" VIEW-AS TEXT
          SIZE 51.86 BY .62 AT ROW 4.42 COL 14.14 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 83 BY 9.08 WIDGET-ID 100.


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
         TITLE              = "Resumen Seguimiento de PED, R/A y TRA"
         HEIGHT             = 9.08
         WIDTH              = 83
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
/* SETTINGS FOR TOGGLE-BOX ChkbxGenTxt IN FRAME fMain
   NO-ENABLE                                                            */
ASSIGN 
       ChkbxGenTxt:HIDDEN IN FRAME fMain           = TRUE.

/* SETTINGS FOR FILL-IN txtDesDivi IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Resumen Seguimiento de PED, R/A y TRA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Resumen Seguimiento de PED, R/A y TRA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCoddivi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCoddivi wWin
ON LEAVE OF txtCoddivi IN FRAME fMain /* Alguna division ? */
DO:
    txtDesDivi:SCREEN-VALUE IN FRAM {&FRAME-NAME} = "".
  FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
        gn-divi.coddiv = txtCodDivi:SCREEN-VALUE IN FRAM {&FRAME-NAME} NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN txtDesDivi:SCREEN-VALUE IN FRAM {&FRAME-NAME} = gn-divi.desdiv.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtProcesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtProcesar wWin
ON CHOOSE OF txtProcesar IN FRAME fMain /* Procesar */
DO:
  ASSIGN txtCoddivi txtdesde txthasta txtDesDivi ChkBxGenTxt ChkbxResumen.

  IF txtCodDivi <> "" THEN DO:  
      FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
            gn-divi.coddiv = txtCodDivi NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-divi THEN DO:
            MESSAGE 'Division esta Errada' VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
  END.
    IF txtDesde > txtHasta THEN DO:
        MESSAGE 'Fechas Erradas' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.


    DEF VAR pOptions AS CHAR NO-UNDO.
    DEF VAR pArchivo AS CHAR INIT 'SeguimientoPedidos' NO-UNDO.
    DEF VAR OKpressed AS LOG NO-UNDO.

    SYSTEM-DIALOG GET-FILE pArchivo
        FILTERS "Archivo txt" "*.txt"
        ASK-OVERWRITE 
        CREATE-TEST-FILE
        DEFAULT-EXTENSION ".txt"
        SAVE-AS
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = FALSE THEN RETURN NO-APPLY.
    
    ASSIGN
        pOptions = "FileType:TXT" + CHR(1) + ~
              "Grid:ver" + CHR(1) + ~ 
              "ExcelAlert:false" + CHR(1) + ~
              "ExcelVisible:false" + CHR(1) + ~
              "Labels:yes".

    SESSION:SET-WAIT-STATE('GENERAL').
    RUN um-procesar.    
    SESSION:SET-WAIT-STATE('').

    FIND FIRST tt-seguimiento NO-LOCK NO-ERROR.
    IF NOT AVAILABLE tt-seguimiento THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.

    DEF VAR cArchivo AS CHAR NO-UNDO.
    /* El archivo se va a generar en un archivo temporal de trabajo antes 
    de enviarlo a su directorio destino */
    cArchivo = LC(pArchivo).
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN lib/tt-filev2 (TEMP-TABLE tt-seguimiento:HANDLE, cArchivo, pOptions).
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    MESSAGE "Proceso Concluido" SKIP "Desde : " lTiempoDesde SKIP "Hasta : " lTiempoHasta VIEW-AS ALERT-BOX WARNING.
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
  DISPLAY txtCoddivi txtDesDivi txtDesde txtHasta ChkbxGenTxt ChkbxResumen 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE txtCoddivi txtDesde txtHasta txtProcesar ChkbxResumen 
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

  txtDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 15,"99/99/9999").
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-clientes wWin 
PROCEDURE ue-clientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
EMPTY TEMP-TABLE tt-cliente-rsm.
EMPTY TEMP-TABLE tt-cliente-dtl.

DEFINE VAR lImp AS DEC.     
DEFINE VAR lSoles AS DEC.
DEFINE VAR lTcmb AS DEC.
DEFINE VAR lNroOD AS CHAR.
DEFINE VAR lOrdQty AS INT.
DEFINE VAR lOrdImp AS DEC.

FOR EACH di-rutaC WHERE di-rutaC.codcia = s-codcia AND di-rutaC.coddiv = txtCodDivi AND         
        (di-rutaC.fchsal >= txtDesde AND di-rutaC.fchsal <= txtHasta) AND
        di-rutaC.flgest <> "A" NO-LOCK,
    EACH di-rutaD OF di-rutaC NO-LOCK :
        
    /* Busco por division - segun hoja de ruta */
    FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = DI-rutaC.codcia AND 
        DI-RutaD.coddiv = ccbcdocu.coddiv AND DI-RutaD.codref = ccbcdocu.coddoc AND
        DI-RutaD.nroref = ccbcdocu.nrodoc NO-LOCK NO-ERROR.

    /* Si no ubica el documento, lo busco sin la division
        por que hay casos que la hoja de ruta contiene
        documentos emitidos x otra division
     */
    IF NOT AVAILABLE ccbcdocu THEN DO:
        FIND FIRST CcbCDocu WHERE ccbcdocu.codcia = s-codcia
            AND DI-RutaD.codref = ccbcdocu.coddoc
            AND DI-RutaD.nroref = ccbcdocu.nrodoc NO-LOCK NO-ERROR.
    END.

    IF AVAILABLE ccbcdocu AND (txtCodClie = "" OR ccbcdocu.codcli = txtCodClie) THEN DO:        
        lImp = ccbcdocu.imptot.
        lTcmb = ccbcdocu.tpocmb.
        lSoles = IF (ccbcdocu.codmon = 2) THEN lImp * lTcmb ELSE lImp.
        lNroOD = ccbcdocu.libre_c02.
        lOrdQty = 0.
        lOrdImp = 0.

        FIND FIRST tt-cliente-dtl WHERE tt-cliente-dtl.tt-coddiv = di-rutad.coddiv AND
                                    tt-cliente-dtl.tt-codcli = ccbcdocu.codcli AND 
                                    tt-cliente-dtl.tt-orden = lNroOD NO-ERROR.
        IF NOT AVAILABLE tt-cliente-dtl THEN DO:

            FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND 
                                    faccpedi.coddoc = 'O/D' AND 
                                    faccpedi.nroped = lNroOD NO-LOCK NO-ERROR.
            lOrdImp = IF (AVAILABLE faccpedi) THEN faccpedi.imptot ELSE 0.
            CREATE tt-cliente-dtl.
                ASSIGN tt-cliente-dtl.tt-coddiv = di-rutad.coddiv
                        tt-cliente-dtl.tt-codcli = ccbcdocu.codcli
                        tt-cliente-dtl.tt-orden = lNroOD
                        tt-cliente-dtl.tt-imp-total = lOrdImp
                        tt-cliente-dtl.tt-imp-pend = 0
                        tt-cliente-dtl.tt-imp-entre = 0
                        tt-cliente-dtl.tt-imp-devo = 0.
            lOrdQty = 1.
        END.
        CASE di-rutad.flgest:
            WHEN 'P' THEN DO:
                ASSIGN tt-cliente-dtl.tt-imp-pend = tt-cliente-dtl.tt-imp-pend + lSoles.
            END.
            WHEN 'C'  THEN DO:
                ASSIGN tt-cliente-dtl.tt-imp-entre = tt-cliente-dtl.tt-imp-entre + lSoles.
            END.
            WHEN 'D' THEN DO:
                ASSIGN tt-cliente-dtl.tt-imp-entre = tt-cliente-dtl.tt-imp-entre + lSoles.
            END.
            WHEN 'X' THEN DO:
                ASSIGN tt-cliente-dtl.tt-imp-devo = tt-cliente-dtl.tt-imp-devo + lSoles.
            END.
            WHEN 'N' THEN DO:
                ASSIGN tt-cliente-dtl.tt-imp-devo = tt-cliente-dtl.tt-imp-devo + lSoles.
            END.
            WHEN 'NR' THEN DO:
                ASSIGN tt-cliente-dtl.tt-imp-devo = tt-cliente-dtl.tt-imp-devo + lSoles.
            END.
        END CASE.       
        /* ------------- */
        FIND FIRST tt-cliente-rsm WHERE tt-cliente-rsm.tt-coddiv = di-rutad.coddiv AND
                                    tt-cliente-rsm.tt-codcli = ccbcdocu.codcli NO-ERROR.
        IF NOT AVAILABLE tt-cliente-rsm THEN DO:
            CREATE tt-cliente-rsm.
                ASSIGN tt-cliente-rsm.tt-coddiv = di-rutad.coddiv
                        tt-cliente-rsm.tt-codcli = ccbcdocu.codcli
                        tt-cliente-rsm.tt-ordqty = 0
                        tt-cliente-rsm.tt-imp-total = 0
                        tt-cliente-rsm.tt-imp-pend = 0
                        tt-cliente-rsm.tt-imp-entre = 0
                        tt-cliente-rsm.tt-imp-devo = 0.
        END.
        ASSIGN tt-cliente-rsm.tt-ordqty = tt-cliente-rsm.tt-ordqty + lOrdQty
                tt-cliente-rsm.tt-imp-total = tt-cliente-rsm.tt-imp-total + lOrdImp.
        CASE di-rutad.flgest:
            WHEN 'P' THEN DO:
                ASSIGN tt-cliente-rsm.tt-imp-pend = tt-cliente-rsm.tt-imp-pend + lSoles.
            END.
            WHEN 'C'  THEN DO:
                ASSIGN tt-cliente-rsm.tt-imp-entre = tt-cliente-rsm.tt-imp-entre + lSoles.
            END.
            WHEN 'D' THEN DO:
                ASSIGN tt-cliente-rsm.tt-imp-entre = tt-cliente-rsm.tt-imp-entre + lSoles.
            END.
            WHEN 'X' THEN DO:
                ASSIGN tt-cliente-rsm.tt-imp-devo = tt-cliente-rsm.tt-imp-devo + lSoles.
            END.
            WHEN 'N' THEN DO:
                ASSIGN tt-cliente-rsm.tt-imp-devo = tt-cliente-rsm.tt-imp-devo + lSoles.
            END.
            WHEN 'NR' THEN DO:
                ASSIGN tt-cliente-rsm.tt-imp-devo = tt-cliente-rsm.tt-imp-devo + lSoles.
            END.
        END CASE.       

    END.
END.
*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-excel-clientes wWin 
PROCEDURE ue-excel-clientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.

lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = YES.       /* YES : Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

lMensajeAlTerminar = YES. /*  */
lCerrarAlTerminar = NO. /* Si permanece abierto el Excel luego de concluir el proceso */

iColumn = 1.
chWorkSheet:Range("B1"):Font:Bold = TRUE.
chWorkSheet:Range("B1"):Value = "RESUMEN DISTRIBUCION  -  DESDE :" + 
STRING(txtDesde,"99/99/9999") + "   HASTA :" + STRING(txtHasta,"99/99/9999").

chWorkSheet:Range("B2"):Font:Bold = TRUE.
chWorkSheet:Range("B2"):Value = "CENTRO DE DISTRIBUCION :" + 
txtCodDivi + " " + txtDesDivi.

chWorkSheet:Range("A3:AZ3"):Font:Bold = TRUE.
chWorkSheet:Range("A3"):Value = "CodCliente".
chWorkSheet:Range("B3"):Value = "Nombre Cliente".
chWorkSheet:Range("C3"):Value = "O/D".
chWorkSheet:Range("D3"):Value = "Importe de la O/D".
chWorkSheet:Range("E3"):Value = "Pendiente x Entregar".
chWorkSheet:Range("F3"):Value = "Entregados".
chWorkSheet:Range("G3"):Value = "Devueltos".
iColumn = 3.
FOR EACH tt-cliente-dtl NO-LOCK :
    FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND 
                            gn-clie.codcli = tt-cliente-dtl.tt-codcli NO-LOCK NO-ERROR.
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-cliente-dtl.tt-codcli.
    IF AVAILABLE gn-clie THEN DO:
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + gn-clie.nomcli.
    END.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-cliente-dtl.tt-orden.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cliente-dtl.tt-imp-total.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cliente-dtl.tt-imp-pend.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cliente-dtl.tt-imp-entre.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cliente-dtl.tt-imp-devo.
END.

/* Resumen */
iColumn = iColumn + 2.
cColumn = STRING(iColumn).
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Font:Bold = TRUE.
chWorkSheet:Range(cRange):Value = "R E S U M E N" .

FOR EACH tt-cliente-rsm NO-LOCK :
    FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND 
                            gn-clie.codcli = tt-cliente-rsm.tt-codcli NO-LOCK NO-ERROR.
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-cliente-rsm.tt-codcli.
    IF AVAILABLE gn-clie THEN DO:
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + gn-clie.nomcli.
    END.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cliente-rsm.tt-ordqty.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cliente-rsm.tt-imp-total.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cliente-rsm.tt-imp-pend.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cliente-rsm.tt-imp-entre.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cliente-rsm.tt-imp-devo.
END.


{lib\excel-close-file.i}
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-extrae-data wWin 
PROCEDURE ue-extrae-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
EMPTY TEMP-TABLE tt-rsmen-dist.
EMPTY TEMP-TABLE tt-rsmen-dtl.
*/
/*
EMPTY TEMP-TABLE tt-rsmen.

DEFINE VAR lImp AS DEC.     
DEFINE VAR lSoles AS DEC.
DEFINE VAR lTcmb AS DEC.

DEFINE VAR lDcli AS CHAR.
DEFINE VAR lDpto AS CHAR.
DEFINE VAR lprov AS CHAR.
DEFINE VAR lDist AS CHAR.
DEFINE VAR x-tiempo AS CHAR.
DEFINE VAR lCodPro AS CHAR.
DEFINE VAR lDesPro AS CHAR.
DEFINE VAR lDestino AS CHAR.
DEFINE VAR lCodDoc AS CHAR.
DEFINE VAR lNroDoc AS CHAR.
DEFINE VAR lOrigen AS CHAR.

DEFINE VAR lqItems AS INT.
DEFINE VAR lqPeso AS DEC.
DEFINE VAR lqCostoVenta AS DEC.
DEFINE VAR lqCostoReposicion AS DEC.
DEFINE VAR lqCostoKardex AS DEC.

DEFINE VAR lFiler AS CHAR.

/* Despachos */
FOR EACH di-rutaC WHERE di-rutaC.codcia = s-codcia AND di-rutaC.coddiv = txtCodDivi AND 
        (di-rutaC.fchsal >= txtDesde AND di-rutaC.fchsal <= txtHasta) AND 
        di-rutaC.flgest <> "A" NO-LOCK,
    EACH di-rutaD OF di-rutaC NO-LOCK :

    /* Busco la Guia de Remision */
    FIND FIRST CcbCDocu WHERE ccbcdocu.codcia = s-codcia
        AND ccbcdocu.coddoc = DI-RutaD.codref 
        AND ccbcdocu.nrodoc = DI-RutaD.nroref NO-LOCK NO-ERROR.
    IF AVAILABLE CcbCDocu THEN DO:
        /* Busco la O/D */
        FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                faccpedi.coddoc = ccbcdocu.libre_c01 AND 
                faccpedi.nroped = ccbcdocu.libre_c02 NO-LOCK NO-ERROR.
        IF AVAILABLE faccpedi THEN DO:
            lDcli = "".
            lDpto = "".
            lProv = "".
            lDist = "".
            lCodpro = "".
            lDesPro = "".
            lDestino = "".
            x-Tiempo = "".
            FIND FIRST tt-rsmen WHERE tt-coddoc = faccpedi.coddoc AND 
                                        tt-nrodoc = faccpedi.nroped AND 
                                        tt-cdoc = DI-RutaD.codref AND     /* G/R */
                                        tt-ndoc = DI-RutaD.nroref NO-ERROR.
            IF NOT AVAILABLE tt-rsmen THEN DO:
                /**/
                FIND FIRST gn-div WHERE gn-div.codcia = s-codcia AND 
                                        gn-div.coddiv = faccpedi.coddiv NO-LOCK NO-ERROR.
                /**/
                FIND FIRST gn-clie WHERE gn-clie.codcia= 0 AND gn-clie.codcli = ccbcdocu.codcli 
                    NO-LOCK NO-ERROR.
                IF AVAILABLE gn-clie THEN lDCli = gn-clie.nomcli.

                FIND FIRST tabdepto WHERE gn-clie.coddept = tabdepto.coddepto NO-LOCK NO-ERROR.
                IF AVAILABLE tabdepto THEN lDpto = tabdepto.nomdepto.

                FIND FIRST tabprovi WHERE gn-clie.coddept = tabprovi.coddepto AND
                    gn-clie.codprov = tabprovi.codprovi NO-LOCK NO-ERROR.
                IF AVAILABLE tabprovi THEN lProv = tabprovi.nomprovi.

                FIND FIRST tabdistr WHERE gn-clie.coddept = tabdistr.coddepto AND 
                    gn-clie.codprov = tabdistr.codprovi AND 
                    gn-clie.coddist = tabdistr.coddistr NO-LOCK NO-ERROR.
                IF AVAILABLE tabdistr THEN lDist = tabdistr.nomdistr.
                /* Bultos */
                FIND FIRST ccbcbult WHERE ccbcbult.codcia = s-codcia AND 
                                    ccbcbult.coddoc = faccpedi.coddoc AND
                                    ccbcbult.nrodoc = faccpedi.nroped NO-LOCK NO-ERROR.
                IF AVAILABLE ccbcbult THEN DO:
                    RUN lib/_time-passed ( DATETIME(STRING(Ccbcbult.dte_02) + ' ' + STRING(Ccbcbult.CHR_04)),
                                             DATETIME(STRING(Ccbcbult.dte_01) + ' ' + STRING(Ccbcbult.CHR_03)), OUTPUT x-Tiempo).
                END.
                /* Transportista */
                    /* Version antigua */
                FIND FIRST gn-vehic WHERE gn-vehic.codcia = DI-RutaC.codcia AND 
                      gn-vehic.placa = DI-RutaC.codveh NO-LOCK NO-ERROR.
                IF AVAILABLE gn-vehic THEN DO:
                   lCodPro     = gn-vehic.codpro.
                END.
                IF DI-RutaC.codpro = '' OR DI-RutaC.codpro = ? THEN DO: 
                    /* La ruta no tiene codprodveedor por lo tanto agarra la de la tabla Vehiculos */
                END.
                ELSE lCodPro = DI-RutaC.codpro.
            
                FIND FIRST gn-prov WHERE gn-prov.codcia = 0 AND gn-prov.codpro = lCodPro NO-LOCK NO-ERROR.
                IF AVAILABLE gn-prov THEN lDesPro = gn-prov.nompro.
                /* Destino */
                IF lProv <> '' THEN DO:
                    IF lProv = 'LIMA' THEN DO:
                        lDestino = lDist.
                    END.
                    ELSE DO:
                        IF lProv = 'CALLAO' THEN DO:
                            lDestino = "CALLAO".
                        END.
                        ELSE DO:
                            lDestino = "PROVINCIAS".
                        END.
                    END.
                END.
                /**/
                lqItems = 0.
                lqPeso = 0.
                RUN ue-item-peso("G/R", OUTPUT lqItems, OUTPUT lqPeso).

                lqCostoVenta = 0.
                lqCostoReposicion = 0.
                lqCostoKardex = 0.
                RUN ue-Importes('O/D',OUTPUT lqCostoVenta, OUTPUT lqCostoReposicion, OUTPUT lqCostoKardex).

                /**/
                CREATE tt-rsmen.
                    ASSIGN  tt-codref   = faccpedi.codref
                            tt-nroref   = faccpedi.nroref
                            tt-faprueba = faccpedi.fchaprobacion
                            tt-coddoc   = faccpedi.coddoc
                            tt-nrodoc   = faccpedi.nroped
                            tt-cdoc     = DI-RutaD.codref
                            tt-ndoc     = DI-RutaD.nroref
                            tt-finiprechq = Faccpedi.fecsac
                            tt-Hiniprechq = Faccpedi.horsac
                            tt-ffinprechq = IF (NUM-ENTRIES(FacCPedi.Libre_c03,"|") > 1) THEN ENTRY(2,FacCPedi.Libre_c03,"|") ELSE ""
                            tt-femi     = faccpedi.fchped
                            tt-hemi     = faccpedi.hora
                            tt-xfemi    = ccbcdocu.fchdoc
                            tt-xhemi    = ccbcdocu.horcie
                            tt-origen   = IF (AVAILABLE gn-div) THEN gn-div.desdiv ELSE ""
                            tt-codcli   = faccpedi.codcli
                            tt-nomcli   = faccpedi.nomcli
                            tt-fhimp    = faccpedi.fchimpOD
                            tt-fdistr   = datetime(fchDistribucion(faccpedi.coddoc))
                            tt-qitms    = lQitems /*fQItems("G/R")*/
                            tt-fent     = faccpedi.fchent
                            tt-peso     = lqPeso /*fPeso("G/R")*/
                            tt-bultos   = IF(AVAILABLE ccbcbult) THEN ccbcbult.bultos ELSE 0
                            tt-frotula  = IF(AVAILABLE ccbcbult) THEN ccbcbult.fchdoc ELSE tt-frotula
                            tt-finicheq = IF(AVAILABLE ccbcbult) THEN ccbcbult.dte_01 ELSE tt-finicheq
                            tt-hinicheq = IF(AVAILABLE ccbcbult) THEN Ccbcbult.CHR_04 ELSE ""
                            tt-ffincheq = IF(AVAILABLE ccbcbult) THEN Ccbcbult.dte_02 ELSE tt-ffincheq
                            tt-hfincheq = IF(AVAILABLE ccbcbult) THEN ccbcbult.CHR_03 ELSE tt-hinicheq
                            tt-hruta    = di-rutac.nrodoc
                            tt-hsalida  = SUBSTRING(di-rutaC.horsal,1,2) + ":" + SUBSTRING(di-rutaC.horsal,3,2)
                            tt-hretorno = SUBSTRING(di-rutac.horret,1,2) + ":" + SUBSTRING(di-rutac.horret,3,2)
                            tt-fsalida  = di-rutaC.fchsal
                            tt-placa    = di-rutaC.codveh
                            tt-gtranspo = di-rutaC.guiatransportista
                            tt-transpo  = lDespro
                            tt-tipomov  = "VENTAS"
                            tt-divori   = di-rutac.coddiv
                            tt-hllegada = SUBSTRING(di-rutaD.horlle,1,2) + ":" + SUBSTRING(di-rutaD.horlle,3,2)
                            tt-hpartida = SUBSTRING(di-rutaD.horpar,1,2) + ":" + SUBSTRING(di-rutaD.horpar,3,2)
                            tt-dpto     = lDpto
                            tt-prov     = lProv
                            tt-dist     = lDist
                            tt-destino  = lDestino
                            tt-imptot   = lqCostoVenta /*fimpTot('O/D','VNT')  /*ccbcdocu.imptot*/*/
                            tt-imprepo  = lqCostoReposicion /*fimpTot('O/D','CRP')  */
                            tt-impkard  = lqCostoKardex /*fimpTot('O/D','CKR')  */
                            tt-estado   = fFlgEst-detalle(di-rutaD.flgest).
            END.
        END.
    END.                 
END.

/* Transferencias */

FOR EACH di-rutaC WHERE di-rutaC.codcia = s-codcia AND di-rutaC.coddiv = txtCodDivi AND 
        (di-rutaC.fchsal >= txtDesde AND di-rutaC.fchsal <= txtHasta) AND 
        di-rutaC.flgest <> "A" NO-LOCK,
        EACH  di-rutaG OF di-rutaC NO-LOCK,
        FIRST almcmov WHERE almcmov.codcia = DI-RutaC.codcia AND 
                            almcmov.codalm = di-rutaG.codalm AND
                            almcmov.tipmov = di-rutaG.tipmov AND
                            almcmov.codmov = di-rutaG.codmov AND 
                            almcmov.nroser = di-rutaG.serref AND
                            almcmov.nrodoc = di-rutaG.nroref NO-LOCK :

    IF almcmov.codref = 'OTR' THEN DO:
        /* Orden de Transferencia */
        lCodDoc = almcmov.codref.
        lNroDoc = almcmov.nroref.
    END.
    ELSE DO:
        /* Transferencia entre almacenes */
        lCodDoc = 'TRA'.
        lNroDoc = STRING(almcmov.nroser,"999") + STRING(almcmov.nrodoc,"999999").
    END.

    FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND faccpedi.coddoc = lCodDoc AND
            faccpedi.nroped = lNroDoc NO-LOCK NO-ERROR.

    lDcli = "".
    lDpto = "".
    lProv = "".
    lDist = "".
    lCodpro = "".
    lDesPro = "".
    lDestino = "".
    x-Tiempo = "".
    lOrigen = almcmov.codalm.
    /* */
    lDist = almcmov.almdes.
    lDestino = almcmov.almdes.
    /**/
    FIND FIRST almacen WHERE almacen.codcia = DI-RutaG.codcia AND almacen.codalm = lDist
        NO-LOCK NO-ERROR.
    IF AVAILABLE almacen THEN lDestino = almacen.campo-c[8].

    FIND FIRST almacen WHERE almacen.codcia = DI-RutaG.codcia AND almacen.codalm = lOrigen
        NO-LOCK NO-ERROR.
    IF AVAILABLE almacen THEN lorigen = almacen.campo-c[8].

    FIND FIRST almacen WHERE almacen.codcia = DI-RutaG.codcia AND almacen.codalm = lDist
        NO-LOCK NO-ERROR.
    IF AVAILABLE almacen THEN lDcli = almacen.descripcion.

    /* Bultos */
    FIND FIRST ccbcbult WHERE ccbcbult.codcia = s-codcia AND 
                        ccbcbult.coddoc = lCodDoc AND
                        ccbcbult.nrodoc = lNroDoc NO-LOCK NO-ERROR.
    IF AVAILABLE ccbcbult THEN DO:
        RUN lib/_time-passed ( DATETIME(STRING(Ccbcbult.dte_02) + ' ' + STRING(Ccbcbult.CHR_04)),
                                 DATETIME(STRING(Ccbcbult.dte_01) + ' ' + STRING(Ccbcbult.CHR_03)), OUTPUT x-Tiempo).
    END.
    /* */
    lFiler = ''.
    IF(AVAILABLE faccpedi) THEN DO:
        lFiler = IF (NUM-ENTRIES(FacCPedi.Libre_c03,"|") > 1) THEN ENTRY(2,FacCPedi.Libre_c03,"|") ELSE "".
    END.
     /**/
    lqItems = 0.
    lqPeso = 0.
    RUN ue-item-peso("TRN", OUTPUT lqItems, OUTPUT lqPeso).

    lqCostoVenta = 0.
    lqCostoReposicion = 0.
    lqCostoKardex = 0.
    RUN ue-Importes('TRA',OUTPUT lqCostoVenta, OUTPUT lqCostoReposicion, OUTPUT lqCostoKardex).
    /**/
    CREATE tt-rsmen.
        ASSIGN  tt-codref   = IF(AVAILABLE faccpedi) THEN faccpedi.codref ELSE ""
                tt-nroref   = IF(AVAILABLE faccpedi) THEN faccpedi.nroref ELSE ""
                tt-faprueba = IF(AVAILABLE faccpedi) THEN faccpedi.fchaprobacion ELSE tt-faprueba
                tt-coddoc   = lCodDoc
                tt-nrodoc   = lNroDoc
                tt-femi     = IF(AVAILABLE faccpedi) THEN faccpedi.fchped ELSE tt-femi
                tt-hemi     = IF(AVAILABLE faccpedi) THEN faccpedi.hora ELSE ""
                tt-finiprechq = IF(AVAILABLE faccpedi) THEN Faccpedi.fecsac ELSE ?
                tt-Hiniprechq = IF(AVAILABLE faccpedi) THEN Faccpedi.horsac ELSE ""
                tt-ffinprechq = lFiler
                tt-cdoc     = "ALM"
                tt-ndoc     = String(di-rutaG.serref,"999") + String(di-rutaG.nroref,"999999")
                tt-xfemi    = almcmov.fchdoc
                tt-xhemi    = almcmov.horsal
                tt-origen   = lOrigen
                tt-codcli   = almcmov.almdes
                tt-nomcli   = ldcli
                tt-fhimp    = IF (lCodDoc = 'OTR') THEN faccpedi.fchimpOD ELSE IF (NUM-ENTRIES(Almcmov.Libre_c01, '|') > 1) THEN DATETIME(ENTRY(2, Almcmov.Libre_c01, '|')) ELSE datetime("")
                tt-fdistr   = datetime(fchDistribucion(lCodDoc))
                tt-qitms    = lqItems /*fQItems("TRN")*/
                tt-fent     = almcmov.fchdoc
                tt-peso     = lqPeso /*fPeso("TRN")*/
                tt-bultos   = IF(AVAILABLE ccbcbult) THEN ccbcbult.bultos ELSE 0
                tt-frotula  = IF(AVAILABLE ccbcbult) THEN ccbcbult.fchdoc ELSE tt-frotula
                tt-finicheq = IF(AVAILABLE ccbcbult) THEN ccbcbult.dte_01 ELSE tt-finicheq
                tt-hinicheq = IF(AVAILABLE ccbcbult) THEN Ccbcbult.CHR_04 ELSE ""
                tt-ffincheq = IF(AVAILABLE ccbcbult) THEN Ccbcbult.dte_02 ELSE tt-ffincheq
                tt-hfincheq = IF(AVAILABLE ccbcbult) THEN ccbcbult.CHR_03 ELSE tt-hinicheq
                /*tt-hfincheq = X-tiempo*/
                tt-hruta    = di-rutac.nrodoc
                tt-hsalida  = di-rutaC.horsal
                tt-hretorno = di-rutac.horret
                tt-fsalida  = di-rutaC.fchsal
                tt-placa    = di-rutaC.codveh
                tt-gtranspo = di-rutaC.guiatransportista
                tt-transpo  = lDespro
                tt-tipomov  = "TRANSFERENCIAS"
                tt-divori   = di-rutac.coddiv
                tt-hllegada = di-rutag.horlle
                tt-hpartida = di-rutag.horpar
                tt-dpto     = ""
                tt-prov     = ""
                tt-dist     = ldist
                tt-destino  = lDestino
                tt-imptot   = lqCostoVenta /*fimpTot('TRA','VNT')  */
                tt-imprepo  = lqCostoReposicion /*fimpTot('TRA','CRP')  */
                tt-impkard  = lqCostoKardex /*fimpTot('TRA','CKR')  */
                tt-estado   = fFlgEst-detalle(di-rutaG.flgest).
END.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-grabar-mov wWin 
PROCEDURE ue-grabar-mov :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-Fase AS CHAR.

DEFINE VAR lSituacion AS CHAR INIT "".

IF p-Fase = 'PEDIDO' THEN DO:
    ASSIGN /* PEDIDO */
        tt-seguimiento.tt-codped       = faccpedi.coddoc
        tt-seguimiento.tt-nroped       = faccpedi.nroped
        tt-seguimiento.tt-fchped       = faccpedi.fchped
        tt-seguimiento.tt-horped       = faccpedi.hora
        tt-seguimiento.tt-divped       = faccpedi.coddiv
        tt-seguimiento.tt-dircli       = faccpedi.dircli
        /* Generacion del Comprobante */
        tt-seguimiento.tt-origen   = faccpedi.coddiv
        tt-seguimiento.tt-codcli   = faccpedi.codcli
        tt-seguimiento.tt-nomcli   = faccpedi.nomcli
        tt-seguimiento.tt-divori    = faccpedi.divdes
        /*  */
        tt-seguimiento.tt-dpto     = lDpto
        tt-seguimiento.tt-prov     = lProv
        tt-seguimiento.tt-dist     = lDist
        tt-seguimiento.tt-destino  = lDestino
        tt-seguimiento.tt-lugent    = faccpedi.lugent
        tt-seguimiento.tt-glosa     = faccpedi.glosa.

        /* Datos del Transporte - Tramos */
        FIND FIRST ccbadocu WHERE ccbadocu.codcia = s-codcia AND 
                                    ccbadocu.coddiv = faccpedi.coddiv AND 
                                    ccbadocu.coddoc = faccpedi.coddoc AND
                                    ccbadocu.nrodoc = faccpedi.nroped NO-LOCK NO-ERROR.
        IF AVAILABLE ccbadocu THEN DO:
            ASSIGN  tt-seguimiento.tt-transportista = ccbadocu.libre_c[4]
                    tt-seguimiento.tt-transporte = ccbadocu.libre_c[10]
                    tt-seguimiento.tt-direccTransporte = ccbadocu.libre_c[12]
                    tt-seguimiento.tt-lugarentrega = ccbadocu.libre_c[13].
        END.
        /* 17Ene2017 - Postal del Pedido - C.Camus*/
        ASSIGN tt-seguimiento.tt-codpos = faccpedi.codpos.
        FIND FIRST almtabla WHERE almtabla.tabla = 'CP' AND 
                                    almtabla.codigo = faccpedi.codpos 
                                    NO-LOCK NO-ERROR.
        IF AVAILABLE almtabla THEN DO:
            ASSIGN tt-seguimiento.tt-despos = almtabla.nombre.
        END.

        /* 17Ene2017 - Lista de Precio desde la cotizacion - C.Camus*/
        DEFINE BUFFER cot_faccpedi FOR faccpedi.
        FIND FIRST cot_faccpedi WHERE cot_faccpedi.codcia = s-codcia AND 
                                        cot_faccpedi.coddoc = 'COT' AND 
                                        cot_faccpedi.nroped = faccpedi.nroref
                                        NO-LOCK NO-ERROR.
        IF AVAILABLE cot_faccpedi THEN DO:
            ASSIGN tt-seguimiento.tt-lprecio = cot_faccpedi.libre_c01.
        END.
        RELEASE cot_faccpedi.

        lSituacion = "EMISION PEDIDO".

    /* RHC 18/08/18 Ingresó a Créditos para su aprobación */
    FIND LAST vtadtrkped WHERE vtadtrkped.CodCia = Faccpedi.CodCia AND 
        vtadtrkped.CodDoc = Faccpedi.CodDoc AND 
        vtadtrkped.NroPed = Faccpedi.NroPed AND 
        vtadtrkped.FlgSit = "P" AND
        vtadtrkped.CodUbic = "PANPX"   /* Pendiente Aprob. Nota Ped Xreditos */
        NO-LOCK NO-ERROR.
    IF AVAILABLE Vtadtrkped THEN 
        ASSIGN
        tt-fchingcre = DATE(vtadtrkped.FechaI)
        tt-horingcre = SUBSTRING(STRING(vtadtrkped.FechaI),12,8).
END.
IF p-Fase = 'ORDEN' THEN DO:
    /* Orden */       
    lSituacion = "O/D EMITIDA".
    ASSIGN tt-seguimiento.tt-codord       = od_faccpedi.coddoc
        tt-seguimiento.tt-nroord       = od_faccpedi.nroped
        tt-seguimiento.tt-fchord       = od_faccpedi.fchped
        tt-seguimiento.tt-horord       = od_faccpedi.hora
        tt-seguimiento.tt-fchentord    = od_faccpedi.fchent
        tt-seguimiento.tt-fchaprord    = od_faccpedi.fchaprobacion
        tt-seguimiento.tt-dircli       = od_faccpedi.dircli
        tt-seguimiento.tt-divori       = od_faccpedi.divdes
        tt-seguimiento.tt-almacen      = od_faccpedi.codalm
        tt-seguimiento.tt-usrasgord    = ""
        tt-seguimiento.tt-fchasgord    = ?
        tt-seguimiento.tt-horasgord    = ''
        tt-seguimiento.tt-qitms        = lqItems
        tt-seguimiento.tt-peso         = lqPeso
        tt-seguimiento.tt-volumen      = lqVolumen
        tt-seguimiento.tt-imptot       = lqCostoVenta /*fimpTot('O/D','VNT')  /*ccbcdocu.imptot*/*/
        tt-seguimiento.tt-imprepo      = lqCostoReposicion /*fimpTot('O/D','CRP')  */
        tt-seguimiento.tt-impkard      = lqCostoKardex /*fimpTot('O/D','CKR')  */
        /* PreChequeo */
        tt-seguimiento.tt-finiprechq = od_Faccpedi.fecsac
        tt-seguimiento.tt-Hiniprechq = od_Faccpedi.horsac
        tt-seguimiento.tt-ffinprechq = IF (NUM-ENTRIES(od_FacCPedi.Libre_c03,"|") > 1) THEN SUBSTRING(ENTRY(2,od_FacCPedi.Libre_c03,"|"),1,10) ELSE ""
        tt-seguimiento.tt-hfinprechq = IF (NUM-ENTRIES(od_FacCPedi.Libre_c03,"|") > 1) THEN SUBSTRING(ENTRY(2,od_FacCPedi.Libre_c03,"|"),12,8) ELSE ""
        /* Envio a Distribucion */
        tt-seguimiento.tt-fhimp    = od_faccpedi.fchimpOD
        tt-seguimiento.tt-fdistr   = datetime(fchDistribucion(od_faccpedi.coddoc))
        /* Chequeo */
        tt-seguimiento.tt-nrohpk   = IF AVAILABLE VtaCDocu  THEN VtaCDocu.NroPed ELSE ''
        tt-seguimiento.tt-bultos   = IF(AVAILABLE ccbcbult) THEN ccbcbult.bultos ELSE 0
        tt-seguimiento.tt-frotula  = IF(AVAILABLE ccbcbult) THEN ccbcbult.fchdoc ELSE tt-frotula
        tt-seguimiento.tt-finicheq = IF(AVAILABLE ccbcbult) THEN ccbcbult.dte_01 ELSE tt-finicheq
        tt-seguimiento.tt-hinicheq = IF(AVAILABLE ccbcbult) THEN Ccbcbult.CHR_04 ELSE ""
        tt-seguimiento.tt-ffincheq = IF(AVAILABLE ccbcbult) THEN Ccbcbult.dte_02 ELSE tt-ffincheq
        tt-seguimiento.tt-hfincheq = IF(AVAILABLE ccbcbult) THEN ccbcbult.CHR_03 ELSE tt-hinicheq
        tt-seguimiento.tt-lugent    = od_faccpedi.lugent
        tt-seguimiento.tt-glosa     = od_faccpedi.glosa.

        IF tt-seguimiento.tt-usrasgord <> "" THEN lSituacion = "ASIGNADO".
        IF NUM-ENTRIES(od_FacCPedi.Libre_c03,"|") > 1 THEN lSituacion = "PRE-PICKEADO".
        IF tt-seguimiento.tt-fdistr <> ? THEN lSituacion = "IMPRESO".
        IF (od_faccpedi.fchchq <> ?) THEN lSituacion = "PICKEADO".

END.
IF p-Fase = 'DOCUMENTO' THEN DO:
    /* Generacion del Comprobante */
    ASSIGN tt-seguimiento.tt-cdoc  = ccbcdocu.coddoc
        tt-seguimiento.tt-ndoc     = ccbcdocu.nrodoc
        tt-seguimiento.tt-xfemi    = ccbcdocu.fchdoc
        tt-seguimiento.tt-xhemi    = ccbcdocu.horcie
        tt-seguimiento.tt-dircli   = ccbcdocu.dircli
        tt-seguimiento.tt-divori   = ccbcdocu.coddiv.

    ASSIGN  tt-seguimiento.tt-lugent    = IF NOT (TRUE <> (ccbcdocu.lugent > "") ) THEN ccbcdocu.lugent ELSE tt-seguimiento.tt-lugent.
            tt-seguimiento.tt-glosa     = IF NOT (TRUE <> (ccbcdocu.glosa > "") ) THEN ccbcdocu.glosa ELSE tt-seguimiento.tt-glosa.       

        /*
        IF ccbcdocu.codref = 'G/R' THEN DO:
            ASSIGN tt-seguimiento.tt-docremi        = ccbcdocu.codref
                        tt-seguimiento.tt-nroremi   = ccbcdocu.nroref.
        END.
        */
        lSituacion = "EMISION DE COMPROBANTE".
END.
IF p-Fase = 'GUIAREMISION' THEN DO:
    /* Generacion de la G/R */
    ASSIGN tt-seguimiento.tt-docremi   = gr_ccbcdocu.coddoc
           tt-seguimiento.tt-nroremi   = gr_ccbcdocu.nrodoc
           tt-seguimiento.tt-dircli    = gr_ccbcdocu.dircli
           tt-seguimiento.tt-divori    = gr_ccbcdocu.coddiv.

           tt-seguimiento.tt-lugent    = IF NOT (TRUE <> (gr_ccbcdocu.lugent > "") ) THEN gr_ccbcdocu.lugent ELSE tt-seguimiento.tt-lugent.
           tt-seguimiento.tt-glosa     = IF NOT (TRUE <> (gr_ccbcdocu.glosa > "") ) THEN gr_ccbcdocu.glosa ELSE tt-seguimiento.tt-glosa.


       lSituacion = "EMISION DE COMPROBANTE y GUIA REMISION".
END.
IF p-Fase = 'HRUTA' THEN DO:
    /* Ruta */
    lSituacion = "HOJA RUTA EMITIDA".
    ASSIGN tt-seguimiento.tt-hruta    = di-rutac.nrodoc
        tt-seguimiento.tt-fsalidaHR  = di-rutaC.fchsal
        tt-seguimiento.tt-hsalidaHR  = SUBSTRING(di-rutaC.horsal,1,2) + ":" + SUBSTRING(di-rutaC.horsal,3,2)
        tt-seguimiento.tt-hretornoHR = SUBSTRING(di-rutac.horret,1,2) + ":" + SUBSTRING(di-rutac.horret,3,2)       
        /* Transportista */
        tt-seguimiento.tt-placa    = di-rutaC.codveh
        tt-seguimiento.tt-gtranspo = di-rutaC.guiatransportista
        tt-seguimiento.tt-transpo  = lDespro
        tt-seguimiento.tt-tipomov  = "VENTAS"
        tt-seguimiento.tt-divori   = di-rutac.coddiv
        /* Entrega al cliente */
        tt-seguimiento.tt-hllegada = SUBSTRING(di-rutaD.horlle,1,2) + ":" + SUBSTRING(di-rutaD.horlle,3,2)
        tt-seguimiento.tt-hpartida = SUBSTRING(di-rutaD.horpar,1,2) + ":" + SUBSTRING(di-rutaD.horpar,3,2)
        /**/
        tt-seguimiento.tt-estado   = fFlgEst-detalle(di-rutaD.flgest).
        /**/
        /*IF TRIM(tt-seguimiento.tt-hretornoHR) <> "" AND TRIM(tt-seguimiento.tt-hretornoHR)<> ":" THEN lSituacion = "HOJA DE RUTA CERRADA".*/
END.

IF p-Fase = 'VIGISALIDA' THEN DO:
    /* Salida/dev mercaderia segun vigilancia */
    ASSIGN tt-seguimiento.tt-fchsalvig = almdcdoc.fecha
            tt-seguimiento.tt-horsalvig = almdcdoc.hora.
    lSituacion = "HOJA DE RUTA EN RUTA".
    IF TRIM(tt-seguimiento.tt-hretornoHR) <> "" AND TRIM(tt-seguimiento.tt-hretornoHR)<> ":" THEN lSituacion = "HOJA DE RUTA CERRADA".
END.
IF p-Fase = 'VIGIDEVOL' THEN DO:
    /* Salida/dev mercaderia segun vigilancia */
    ASSIGN tt-seguimiento.tt-fchdevvig = almrcdoc.fecha
        tt-seguimiento.tt-hordevvig = almrcdoc.hora.
    lSituacion = "HOJA DE RUTA CERRADA CON DEVOLUCION".
END.

ASSIGN tt-seguimiento.tt-situacion = lSituacion.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-grabar-mov-otr wWin 
PROCEDURE ue-grabar-mov-otr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-Fase AS CHAR.

DEFINE VAR lSituacion AS CHAR INIT "".

DEFINE BUFFER b-almacen FOR almacen.
DEFINE BUFFER z-almacen FOR almacen.

IF p-Fase = 'PEDIDO' THEN DO:    

    FIND FIRST b-almacen WHERE b-almacen.codcia = s-codcia AND 
                                b-almacen.codalm = almcrepo.codalm
                                NO-LOCK NO-ERROR.

    ASSIGN /* PEDIDO */
        tt-seguimiento.tt-codped       = 'R/A'
        tt-seguimiento.tt-nroped       = STRING(almcrepo.nroser,"999") + STRING(almcrepo.nrodoc,"9999999")
        tt-seguimiento.tt-fchped       = almcrepo.fchdoc
        tt-seguimiento.tt-horped       = almcrepo.hora
        tt-seguimiento.tt-divped       = almcrepo.codalm + " ==> " + almcrepo.almped
        /* Generacion del Comprobante */
        tt-seguimiento.tt-origen   = lOrigen
        tt-seguimiento.tt-codcli   = almcrepo.almped
        tt-seguimiento.tt-nomcli   = IF(AVAILABLE b-almacen) THEN b-almacen.descripcion ELSE ""
        /*  */
        tt-seguimiento.tt-dpto     = lDpto
        tt-seguimiento.tt-prov     = lProv
        tt-seguimiento.tt-dist     = lDist
        tt-seguimiento.tt-destino  = lDestino.

        FIND FIRST z-almacen WHERE z-almacen.codcia = s-codcia AND 
                                z-almacen.codalm = almcrepo.almped NO-LOCK NO-ERROR.
        ASSIGN tt-seguimiento.tt-divori = IF(AVAILABLE z-almacen) THEN z-almacen.coddiv ELSE "".

        lSituacion = "EMISION R/A".
END.
IF p-Fase = 'ORDEN' THEN DO:
    /* Orden */       
    lSituacion = "OTR EMITIDA".
    ASSIGN tt-seguimiento.tt-codord       = od_faccpedi.coddoc
        tt-seguimiento.tt-nroord       = od_faccpedi.nroped
        tt-seguimiento.tt-fchord       = od_faccpedi.fchped
        tt-seguimiento.tt-horord       = od_faccpedi.hora
        tt-seguimiento.tt-fchentord    = od_faccpedi.fchent
        tt-seguimiento.tt-fchaprord    = od_faccpedi.fchaprobacion
        tt-seguimiento.tt-dircli       = od_faccpedi.dircli
        tt-seguimiento.tt-divori       = od_faccpedi.divdes
        tt-seguimiento.tt-almacen      = od_faccpedi.codalm
        tt-seguimiento.tt-usrasgord    = ""
        /*tt-seguimiento.tt-fchasgord    = ?*/
        tt-seguimiento.tt-horasgord    = ''
        tt-seguimiento.tt-qitms        = lqItems
        tt-seguimiento.tt-peso         = lqPeso
        tt-seguimiento.tt-volumen      = lqVolumen
        tt-seguimiento.tt-imptot       = lqCostoVenta /*fimpTot('O/D','VNT')  /*ccbcdocu.imptot*/*/
        tt-seguimiento.tt-imprepo      = lqCostoReposicion /*fimpTot('O/D','CRP')  */
        tt-seguimiento.tt-impkard      = lqCostoKardex /*fimpTot('O/D','CKR')  */
        /* PreChequeo */
        tt-seguimiento.tt-finiprechq = od_Faccpedi.fecsac
        tt-seguimiento.tt-Hiniprechq = od_Faccpedi.horsac
        tt-seguimiento.tt-ffinprechq = IF (NUM-ENTRIES(od_FacCPedi.Libre_c03,"|") > 1) THEN SUBSTRING(ENTRY(2,od_FacCPedi.Libre_c03,"|"),1,10) ELSE ""
        tt-seguimiento.tt-hfinprechq = IF (NUM-ENTRIES(od_FacCPedi.Libre_c03,"|") > 1) THEN SUBSTRING(ENTRY(2,od_FacCPedi.Libre_c03,"|"),12,8) ELSE ""
        /* Envio a Distribucion */
        tt-seguimiento.tt-fhimp    = od_faccpedi.fchimpOD
        tt-seguimiento.tt-fdistr   = datetime(fchDistribucion(od_faccpedi.coddoc))
        /* Chequeo */
        tt-seguimiento.tt-bultos   = IF(AVAILABLE ccbcbult) THEN ccbcbult.bultos ELSE 0
        tt-seguimiento.tt-frotula  = IF(AVAILABLE ccbcbult) THEN ccbcbult.fchdoc ELSE tt-frotula
        tt-seguimiento.tt-finicheq = IF(AVAILABLE ccbcbult) THEN ccbcbult.dte_01 ELSE tt-finicheq
        tt-seguimiento.tt-hinicheq = IF(AVAILABLE ccbcbult) THEN Ccbcbult.CHR_04 ELSE ""
        tt-seguimiento.tt-ffincheq = IF(AVAILABLE ccbcbult) THEN Ccbcbult.dte_02 ELSE tt-ffincheq
        tt-seguimiento.tt-hfincheq = IF(AVAILABLE ccbcbult) THEN ccbcbult.CHR_03 ELSE tt-hinicheq.

        IF tt-seguimiento.tt-usrasgord <> "" THEN lSituacion = "ASIGNADO".
        IF NUM-ENTRIES(od_FacCPedi.Libre_c03,"|") > 1 THEN lSituacion = "PRE-PICKEADO".
        IF tt-seguimiento.tt-fdistr <> ? THEN lSituacion = "IMPRESO".
        IF (od_faccpedi.fchchq <> ?) THEN lSituacion = "PICKEADO".

END.
IF p-Fase = 'DOCUMENTO' THEN DO:
    /* Generacion del Comprobante */
    ASSIGN tt-seguimiento.tt-cdoc     = "ALM"
        tt-seguimiento.tt-ndoc     = String(almcmov.nroser,"999") + String(almcmov.nrodoc,"999999")
        tt-seguimiento.tt-xfemi    = almcmov.fchdoc
        tt-seguimiento.tt-xhemi    = almcmov.hradoc.

        FIND FIRST z-almacen WHERE z-almacen.codcia = s-codcia AND 
                                z-almacen.codalm = almcmov.codalm
                                NO-LOCK NO-ERROR.
        ASSIGN tt-seguimiento.tt-divori = IF(AVAILABLE z-almacen) THEN z-almacen.coddiv ELSE tt-seguimiento.tt-divori.

        lSituacion = "GENERA MOVIMIENTO ALMACEN".
END.
IF p-Fase = 'HRUTA' THEN DO:
    /* Ruta */
    lSituacion = "HOJA RUTA EMITIDA".
    ASSIGN tt-seguimiento.tt-hruta    = di-rutac.nrodoc
        tt-seguimiento.tt-fsalidaHR  = di-rutaC.fchsal
        tt-seguimiento.tt-hsalidaHR  = SUBSTRING(di-rutaC.horsal,1,2) + ":" + SUBSTRING(di-rutaC.horsal,3,2)
        tt-seguimiento.tt-hretornoHR = SUBSTRING(di-rutac.horret,1,2) + ":" + SUBSTRING(di-rutac.horret,3,2)       
        /* Transportista */
        tt-seguimiento.tt-placa    = di-rutaC.codveh
        tt-seguimiento.tt-gtranspo = di-rutaC.guiatransportista
        tt-seguimiento.tt-transpo  = lDespro
        tt-seguimiento.tt-tipomov  = "ORDENES TRANSFERENCIAS"
        tt-seguimiento.tt-divori   = di-rutac.coddiv
        /* Entrega al cliente */
        tt-seguimiento.tt-hllegada = SUBSTRING(di-rutaG.horlle,1,2) + ":" + SUBSTRING(di-rutaG.horlle,3,2)
        tt-seguimiento.tt-hpartida = SUBSTRING(di-rutaG.horpar,1,2) + ":" + SUBSTRING(di-rutaG.horpar,3,2)
        /**/
        tt-seguimiento.tt-estado   = fFlgEst-detalle(di-rutaG.flgest).
        /**/
        /*IF TRIM(tt-seguimiento.tt-hretornoHR) <> "" AND TRIM(tt-seguimiento.tt-hretornoHR)<> ":" THEN lSituacion = "HOJA DE RUTA CERRADA".*/
END.

IF p-Fase = 'VIGISALIDA' THEN DO:
    /* Salida/dev mercaderia segun vigilancia */
    ASSIGN tt-seguimiento.tt-fchsalvig = almdcdoc.fecha
            tt-seguimiento.tt-horsalvig = almdcdoc.hora.
    lSituacion = "HOJA DE RUTA EN RUTA".
    IF TRIM(tt-seguimiento.tt-hretornoHR) <> "" AND TRIM(tt-seguimiento.tt-hretornoHR)<> ":" THEN lSituacion = "HOJA DE RUTA CERRADA".
END.
IF p-Fase = 'VIGIDEVOL' THEN DO:
    /* Salida/dev mercaderia segun vigilancia */
    ASSIGN tt-seguimiento.tt-fchdevvig = almrcdoc.fecha
        tt-seguimiento.tt-hordevvig = almrcdoc.hora.
    lSituacion = "HOJA DE RUTA CERRADA CON DEVOLUCION".
END.

ASSIGN tt-seguimiento.tt-situacion = lSituacion.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-grabar-mov-tra wWin 
PROCEDURE ue-grabar-mov-tra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-Fase AS CHAR.

DEFINE VAR lSituacion AS CHAR INIT "".

DEFINE BUFFER z-almacen FOR almacen.

IF p-Fase = 'PEDIDO' THEN DO:

    FIND FIRST z-almacen WHERE z-almacen.codcia = s-codcia AND 
                                z-almacen.codalm = almcmov.codalm
                                NO-LOCK NO-ERROR.

    ASSIGN /* PEDIDO */
        tt-seguimiento.tt-codped       = 'TRA'
        tt-seguimiento.tt-nroped       = STRING(almcmov.nroser,"999") + STRING(almcmov.nrodoc,"9999999")
        tt-seguimiento.tt-fchped       = almcmov.fchdoc
        tt-seguimiento.tt-horped       = almcmov.hradoc
        tt-seguimiento.tt-divped       = almcmov.codalm
        tt-seguimiento.tt-divori       = IF ( AVAILABLE z-almacen) THEN z-almacen.coddiv ELSE ""
        /* Generacion del Comprobante */
        tt-seguimiento.tt-origen   = lOrigen
        tt-seguimiento.tt-codcli   = almcmov.almdes
        tt-seguimiento.tt-nomcli   = ''
        /*  */
        tt-seguimiento.tt-dpto     = lDpto
        tt-seguimiento.tt-prov     = lProv
        tt-seguimiento.tt-dist     = lDist
        tt-seguimiento.tt-destino  = lDestino.

        lSituacion = "EMISION TRANSFERENCIA MANUAL".
END.
IF p-Fase = 'ORDEN' THEN DO:
    /* Orden */       
    FIND FIRST z-almacen WHERE z-almacen.codcia = s-codcia AND 
                                z-almacen.codalm = almcmov.codalm
                                NO-LOCK NO-ERROR.

    lSituacion = "TRANSFERENCIA EMITIDA".
    ASSIGN tt-seguimiento.tt-codord    = "TRA"
        tt-seguimiento.tt-nroord       = STRING(almcmov.nroser,"999") + STRING(almcmov.nrodoc,"9999999")
        tt-seguimiento.tt-fchord       = almcmov.fchdoc
        tt-seguimiento.tt-horord       = almcmov.hradoc
        tt-seguimiento.tt-fchentord    = almcmov.fchdoc
        tt-seguimiento.tt-fchaprord    = almcmov.fchdoc
        tt-seguimiento.tt-divori       = IF ( AVAILABLE z-almacen) THEN z-almacen.coddiv ELSE tt-seguimiento.tt-divori
        tt-seguimiento.tt-almacen      = almcmov.codalm
        tt-seguimiento.tt-usrasgord    = ""
        /*tt-seguimiento.tt-fchasgord    = ?*/ 
        tt-seguimiento.tt-horasgord    = ''
        tt-seguimiento.tt-qitms        = lqItems
        tt-seguimiento.tt-peso         = lqPeso
        tt-seguimiento.tt-volumen      = lqVolumen
        tt-seguimiento.tt-imptot       = lqCostoVenta /*fimpTot('O/D','VNT')  /*ccbcdocu.imptot*/*/
        tt-seguimiento.tt-imprepo      = lqCostoReposicion /*fimpTot('O/D','CRP')  */
        tt-seguimiento.tt-impkard      = lqCostoKardex /*fimpTot('O/D','CKR')  */
        /* PreChequeo */
        tt-seguimiento.tt-finiprechq = IF (NUM-ENTRIES(almcmov.Libre_c04,"|") > 3) THEN DATE(ENTRY(4,almcmov.Libre_c04,"|")) ELSE tt-seguimiento.tt-finiprechq
        tt-seguimiento.tt-hiniprechq = IF (NUM-ENTRIES(almcmov.Libre_c04,"|") > 4) THEN ENTRY(5,almcmov.Libre_c04,"|") ELSE ""
        tt-seguimiento.tt-ffinprechq = IF (NUM-ENTRIES(almcmov.Libre_c04,"|") > 1) THEN ENTRY(2,almcmov.Libre_c04,"|") ELSE ""
        tt-seguimiento.tt-hfinprechq = IF (NUM-ENTRIES(almcmov.Libre_c04,"|") > 2) THEN ENTRY(3,almcmov.Libre_c04,"|") ELSE ""
        /* Envio a Distribucion */
        /*
        tt-seguimiento.tt-fhimp    = 
        tt-seguimiento.tt-fdistr   = 
        */
        /* Chequeo */
        tt-seguimiento.tt-bultos   = IF(AVAILABLE ccbcbult) THEN ccbcbult.bultos ELSE 0
        tt-seguimiento.tt-frotula  = IF(AVAILABLE ccbcbult) THEN ccbcbult.fchdoc ELSE tt-seguimiento.tt-frotula
        tt-seguimiento.tt-finicheq = IF (NUM-ENTRIES(almcmov.Libre_c03,"|") > 3) THEN DATE(ENTRY(4,almcmov.Libre_c03,"|")) ELSE tt-seguimiento.tt-finicheq 
        tt-seguimiento.tt-hinicheq = IF (NUM-ENTRIES(almcmov.Libre_c03,"|") > 4) THEN ENTRY(5,almcmov.Libre_c03,"|") ELSE ""
        tt-seguimiento.tt-ffincheq = IF (NUM-ENTRIES(almcmov.Libre_c03,"|") > 1) THEN DATE(ENTRY(2,almcmov.Libre_c03,"|")) ELSE tt-seguimiento.tt-ffincheq
        tt-seguimiento.tt-hfincheq = IF (NUM-ENTRIES(almcmov.Libre_c03,"|") > 2) THEN ENTRY(3,almcmov.Libre_c03,"|") ELSE "".

        IF tt-seguimiento.tt-usrasgord <> "" THEN lSituacion = "ASIGNADO".
        IF (NUM-ENTRIES(almcmov.Libre_c04,"|") > 1) THEN lSituacion = "PRE-PICKEADO".
        IF tt-seguimiento.tt-fdistr <> ? THEN lSituacion = "IMPRESO".
        IF (NUM-ENTRIES(almcmov.Libre_c03,"|") > 2) THEN lSituacion = "PICKEADO".

END.
IF p-Fase = 'DOCUMENTO' THEN DO:
    /* Generacion del Comprobante */
    ASSIGN tt-seguimiento.tt-cdoc     = "ALM"
        tt-seguimiento.tt-ndoc     = String(almcmov.nroser,"999") + String(almcmov.nrodoc,"999999")
        tt-seguimiento.tt-xfemi    = almcmov.fchdoc
        tt-seguimiento.tt-xhemi    = almcmov.hradoc.

        lSituacion = "GENERA MOVIMIENTO ALMACEN".
END.
IF p-Fase = 'HRUTA' THEN DO:
    /* Ruta */
    lSituacion = "HOJA RUTA EMITIDA".
    ASSIGN tt-seguimiento.tt-hruta    = di-rutac.nrodoc
        tt-seguimiento.tt-fsalidaHR  = di-rutaC.fchsal
        tt-seguimiento.tt-hsalidaHR  = SUBSTRING(di-rutaC.horsal,1,2) + ":" + SUBSTRING(di-rutaC.horsal,3,2)
        tt-seguimiento.tt-hretornoHR = SUBSTRING(di-rutac.horret,1,2) + ":" + SUBSTRING(di-rutac.horret,3,2)       
        /* Transportista */
        tt-seguimiento.tt-placa    = di-rutaC.codveh
        tt-seguimiento.tt-gtranspo = di-rutaC.guiatransportista
        tt-seguimiento.tt-transpo  = lDespro
        tt-seguimiento.tt-tipomov  = "ORDENES TRANSFERENCIAS"
        tt-seguimiento.tt-divori   = di-rutac.coddiv
        /* Entrega al cliente */
        tt-seguimiento.tt-hllegada = SUBSTRING(di-rutaG.horlle,1,2) + ":" + SUBSTRING(di-rutaG.horlle,3,2)
        tt-seguimiento.tt-hpartida = SUBSTRING(di-rutaG.horpar,1,2) + ":" + SUBSTRING(di-rutaG.horpar,3,2)
        /**/
        tt-seguimiento.tt-estado   = fFlgEst-detalle(di-rutaG.flgest).
        /**/
        /*IF TRIM(tt-seguimiento.tt-hretornoHR) <> "" AND TRIM(tt-seguimiento.tt-hretornoHR)<> ":" THEN lSituacion = "HOJA DE RUTA CERRADA".*/
END.

IF p-Fase = 'VIGISALIDA' THEN DO:
    /* Salida/dev mercaderia segun vigilancia */
    ASSIGN tt-seguimiento.tt-fchsalvig = almdcdoc.fecha
            tt-seguimiento.tt-horsalvig = almdcdoc.hora.
    lSituacion = "HOJA DE RUTA EN RUTA".
    IF TRIM(tt-seguimiento.tt-hretornoHR) <> "" AND TRIM(tt-seguimiento.tt-hretornoHR)<> ":" THEN lSituacion = "HOJA DE RUTA CERRADA".
END.
IF p-Fase = 'VIGIDEVOL' THEN DO:
    /* Salida/dev mercaderia segun vigilancia */
    ASSIGN tt-seguimiento.tt-fchdevvig = almrcdoc.fecha
        tt-seguimiento.tt-hordevvig = almrcdoc.hora.
    lSituacion = "HOJA DE RUTA CERRADA CON DEVOLUCION".
END.

ASSIGN tt-seguimiento.tt-situacion = lSituacion.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-importes wWin 
PROCEDURE ue-importes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pDoc AS CHAR.
DEFINE OUTPUT PARAMETER pCostoVenta AS DEC.
DEFINE OUTPUT PARAMETER pCostoReposicion AS DEC.
DEFINE OUTPUT PARAMETER pCostoKardex AS DEC.

DEFINE VAR lCostoVenta AS DEC.
DEFINE VAR lCostoReposicion AS DEC.
DEFINE VAR lCostoKardex AS DEC.
DEFINE VAR lTCambio AS DEC.

lCostoVenta = 0.
lCostoReposicion = 0.
lCostoKardex = 0.

DEFINE BUFFER b-facdpedi FOR facdpedi.

IF pDoc = 'TRA' THEN DO:
    FOR EACH b-facdpedi OF od_faccpedi NO-LOCK, FIRST almmmatg OF b-facdpedi NO-LOCK :
        lTCambio = 1.
        IF almmmatg.monvta = 2 THEN DO:
            /* Dolares */
            lTCambio = Almmmatg.tpocmb.
        END.
        lCostoVenta = lCostoVenta + ((Almmmatg.preofi * lTCambio) * b-facdpedi.canped).
        lCostoReposicion = lCostoReposicion + ((Almmmatg.ctotot * lTCambio) * b-facdpedi.canped).
        FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia
            AND AlmStkGe.codmat = Almmmatg.codmat
            AND AlmStkGe.fecha <= TODAY NO-LOCK NO-ERROR.
        IF AVAILABLE AlmStkGe THEN lCostoKardex = lCostoKardex + ((AlmStkge.CtoUni * lTCambio) * b-facdpedi.canped).
    END.
END.
ELSE DO:
    FOR EACH b-facdpedi OF od_faccpedi NO-LOCK, FIRST almmmatg OF b-facdpedi NO-LOCK :
        lTCambio = 1.
        IF od_faccpedi.codmon = 2 THEN DO:
            /* Dolares */
            lTCambio = od_faccpedi.tpocmb.
        END.
        lCostoVenta = lCostoVenta + ((b-facdpedi.implin * lTCambio)).
        lCostoReposicion = lCostoReposicion + ((Almmmatg.ctotot * lTCambio) * b-facdpedi.canped).
        FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia
            AND AlmStkGe.codmat = Almmmatg.codmat
            AND AlmStkGe.fecha <= TODAY NO-LOCK NO-ERROR.
        IF AVAILABLE AlmStkGe THEN lCostoKardex = lCostoKardex + ((AlmStkge.CtoUni * lTCambio) * b-facdpedi.canped).
    END.
END.
pCostoVenta = lCostoVenta.
pCostoReposicion = lCostoReposicion.
pCostoKardex = lCostoKardex.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-item-peso wWin 
PROCEDURE ue-item-peso :
DEFINE INPUT PARAMETER pTipo AS CHAR.
DEFINE OUTPUT PARAMETER pqItems AS INT.
DEFINE OUTPUT PARAMETER pqPeso AS DEC.
DEFINE OUTPUT PARAMETER pqVolumen AS DEC.

DEFINE VAR i AS INT.
DEFINE VAR lPeso AS DEC.
DEFINE VAR lVol AS DEC.

i = 0.
lVol = 0.

DEFINE BUFFER b-facdpedi FOR facdpedi.

IF pTipo = 'O/D' OR pTipo = 'DOC' THEN DO:
    DEFINE BUFFER b-ccbddocu FOR ccbddocu.
    IF pTipo = 'O/D' THEN DO:
        FOR EACH b-facdpedi OF od_faccpedi NO-LOCK, FIRST almmmatg OF b-facdpedi NO-LOCK :
            i = i + 1.
            IF almmmatg.pesmat <> ? AND almmmatg.pesmat > 0 THEN lPeso = lPeso + ( (b-facdpedi.canped * b-facdpedi.factor ) * almmmatg.pesmat).
            IF almmmatg.libre_d02 <> ? AND almmmatg.libre_d02 > 0 THEN lVol = lVol + ( (b-facdpedi.canped * b-facdpedi.factor ) * almmmatg.libre_d02 / 1000000 ). 
        END.
    END.
    ELSE DO:
        FOR EACH b-ccbddocu OF ccbcdocu NO-LOCK, FIRST almmmatg OF b-ccbddocu NO-LOCK :
            i = i + 1.
            IF almmmatg.pesmat <> ? AND almmmatg.pesmat > 0 THEN lPeso = lPeso + ( (b-ccbddocu.candes * b-ccbddocu.factor ) * almmmatg.pesmat).
            IF almmmatg.libre_d02 <> ? AND almmmatg.libre_d02 > 0 THEN lVol = lVol + ( (b-ccbddocu.candes * b-ccbddocu.factor ) * almmmatg.libre_d02 / 1000000 ). 
        END.
    END.
END.
ELSE DO:
    FOR EACH b-facdpedi OF od_faccpedi NO-LOCK, FIRST almmmatg OF b-facdpedi NO-LOCK :
        i = i + 1.
        IF almmmatg.pesmat <> ? AND almmmatg.pesmat > 0 THEN lPeso = lPeso + ( (b-facdpedi.canped * b-facdpedi.factor ) * almmmatg.pesmat).
        IF almmmatg.libre_d02 <> ? AND almmmatg.libre_d02 > 0 THEN lVol = lVol + ( (b-facdpedi.canped * b-facdpedi.factor ) * almmmatg.libre_d02 / 1000000 ). 
    END.
END.
pqItems = i.
pqPeso = lPeso.
pqVolumen = lVol.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-ordenes-transferencias wWin 
PROCEDURE ue-ordenes-transferencias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR lCodDocRuta AS CHAR.
DEFINE VAR lNroDocRuta AS CHAR.
DEFINE VAR lTieneODs AS LOG.
DEFINE VAR lTieneGRs AS LOG.
DEFINE VAR lTieneHRs AS LOG.

DEFINE VAR lNroRepoAuto AS CHAR.
DEFINE VAR lNroDoctoHR AS CHAR.

lqCostoVenta = 0.
lqCostoReposicion = 0.
lqCostoKardex = 0.
/* */
lqItems = 0.
lqPeso = 0.
lqVolumen = 0.


FOR EACH almcrepo WHERE almcrepo.codcia = s-codcia AND 
                        (almcrepo.fchdoc >= txtDesde AND almcrepo.fchdoc <= txtHasta) AND
                        almcrepo.flgest <> 'A' NO-LOCK:
    lDcli = "".
    lDpto = "".
    lProv = "".
    lDist = "".
    lCodpro = "".
    lDesPro = "".
    lDestino = "".

    lOrigen = almcrepo.codalm.
    /* */
    lDist = almcrepo.codalm.
    lDestino = almcrepo.codalm.


    /* Cliente */
    FIND FIRST almacen WHERE almacen.codcia = s-codcia AND almacen.codalm = lDist
        NO-LOCK NO-ERROR.
    IF AVAILABLE almacen THEN lDestino = almacen.campo-c[8].

    FIND FIRST almacen WHERE almacen.codcia = s-codcia AND almacen.codalm = lOrigen
        NO-LOCK NO-ERROR.
    IF AVAILABLE almacen THEN lorigen = almacen.campo-c[8].

    FIND FIRST almacen WHERE almacen.codcia = s-codcia AND almacen.codalm = lDist
        NO-LOCK NO-ERROR.
    IF AVAILABLE almacen THEN lDcli = almacen.descripcion.


    /* Destino */
    IF lProv <> '' THEN DO:
        IF lProv = 'LIMA' THEN DO:
            lDestino = lDist.
        END.
        ELSE DO:
            IF lProv = 'CALLAO' THEN DO:
                lDestino = "CALLAO".
            END.
            ELSE DO:
                lDestino = "PROVINCIAS".
            END.
        END.
    END.

    lTieneODs = NO.
    lNroRepoAuto = STRING(almcrepo.nroser,"999") + STRING(almcrepo.nrodoc,"999999").
    /* Sus Ordenes (OTR) */
    FOR EACH od_faccpedi USE-INDEX llave07 WHERE od_faccpedi.codcia = almcrepo.codcia AND 
                                                od_faccpedi.codref = 'R/A' AND
                                                od_faccpedi.nroref = lNroRepoAuto AND 
                                                od_faccpedi.coddoc = 'OTR' AND 
                                                od_faccpedi.flgest <> 'A' NO-LOCK :

        /* Bultos de la O/D */
        FIND FIRST ccbcbult WHERE ccbcbult.codcia = s-codcia AND 
                            ccbcbult.coddoc = od_faccpedi.coddoc AND
                            ccbcbult.nrodoc = od_faccpedi.nroped NO-LOCK NO-ERROR.
        IF AVAILABLE ccbcbult THEN DO:
            /*
            RUN lib/_time-passed ( DATETIME(STRING(Ccbcbult.dte_02) + ' ' + STRING(Ccbcbult.CHR_04)),
                                     DATETIME(STRING(Ccbcbult.dte_01) + ' ' + STRING(Ccbcbult.CHR_03)), OUTPUT x-Tiempo).
            */
        END.
        lTieneODs = YES.

        lqCostoVenta = 0.
        lqCostoReposicion = 0.
        lqCostoKardex = 0.
        IF ChkbxResumen = NO THEN DO:
            RUN ue-Importes('TRA',OUTPUT lqCostoVenta, OUTPUT lqCostoReposicion, OUTPUT lqCostoKardex).
        END.
        
        /**/
        lqItems = 0.
        lqPeso = 0.
        lqVolumen = 0.
        IF ChkbxResumen = NO THEN DO:
            RUN ue-item-peso("TRN", OUTPUT lqItems, OUTPUT lqPeso, OUTPUT lqVolumen).
        END.        

        /* Buscar los movimientos de Almacen */
        lTieneGRs = NO.
        FOR EACH almcmov WHERE almcmov.codcia = s-codcia AND 
                                almcmov.codref = od_faccpedi.coddoc AND
                                almcmov.nroref = od_faccpedi.nroped AND 
                                almcmov.codalm = od_faccpedi.codalm AND
                                almcmov.flgest <> 'A' NO-LOCK:

            lTieneGRs = YES.
            lTieneHRs = NO.
            /* Buscar el Documento (G/R) en la HR */
            FOR EACH di-RutaG USE-INDEX llave02 WHERE di-RutaG.codcia = s-codcia AND 
                                    di-RutaG.coddoc = 'H/R' AND 
                                    di-RutaG.codalm = almcmov.codalm AND
                                    di-RutaG.tipmov = 'S' AND
                                    di-RutaG.codmov = 3 AND
                                    di-RutaG.serref = almcmov.nroser AND 
                                    di-RutaG.NroRef = almcmov.nrodoc AND
                                    di-RutaG.flgest <> 'A' NO-LOCK, 
                FIRST di-rutaC OF di-rutaG WHERE di-RutaC.flgest <> 'A' NO-LOCK:

                lCodPro = ''.
                lDesPro = ''.
                /* Transportista */
                    /* Version antigua */
                FIND FIRST gn-vehic WHERE gn-vehic.codcia = DI-RutaC.codcia AND 
                      gn-vehic.placa = DI-RutaC.codveh NO-LOCK NO-ERROR.
                IF AVAILABLE gn-vehic THEN DO:
                   lCodPro     = gn-vehic.codpro.
                END.
                IF DI-RutaC.codpro = '' OR DI-RutaC.codpro = ? THEN DO: 
                    /* La ruta no tiene codprodveedor por lo tanto agarra la de la tabla Vehiculos */
                END.
                ELSE lCodPro = DI-RutaC.codpro.

                FIND FIRST gn-prov WHERE gn-prov.codcia = 0 AND gn-prov.codpro = lCodPro NO-LOCK NO-ERROR.
                IF AVAILABLE gn-prov THEN lDesPro = gn-prov.nompro.

                /* Adiciono registro */
                CREATE tt-seguimiento.
                RUN ue-grabar-mov-otr(INPUT "PEDIDO").
                RUN ue-grabar-mov-otr(INPUT "ORDEN").
                RUN ue-grabar-mov-otr(INPUT "DOCUMENTO").
                RUN ue-grabar-mov-otr(INPUT "HRUTA").

                lNroDoctoHR = STRING(di-RutaG.serref,"999") + STRING(di-RutaG.nroref,"999999").
                /* Buscar la salida de vigilancia */
                FIND FIRST almdcdoc USE-INDEX llave02 WHERE almdcdoc.codcia = s-codcia AND 
                                            almdcdoc.coddoc = 'G/R' AND
                                            almdcdoc.nrodoc = lNroDoctoHR NO-LOCK NO-ERROR.
                IF AVAILABLE almdcdoc  THEN DO:
                    RUN ue-grabar-mov-otr(INPUT "VIGISALIDA").
                END.
                /* Buscar si vigilancia registro devoluciones*/
                FIND FIRST almRCdoc USE-INDEX llave02 WHERE almRCdoc.codcia = s-codcia AND 
                                            almRCdoc.coddoc = 'G/R' AND
                                            almRCdoc.nrodoc = lNroDoctoHR NO-LOCK NO-ERROR.
                IF AVAILABLE almRCdoc  THEN DO:
                    RUN ue-grabar-mov-otr(INPUT "VIGIDEVOL").
                END.

                lTieneHRs = YES.
            END.
            /* No tiene HR */
            IF lTieneHRs = NO THEN DO:
                /* Adiciono registro */
                CREATE tt-seguimiento.
                RUN ue-grabar-mov-otr(INPUT "PEDIDO").
                RUN ue-grabar-mov-otr(INPUT "ORDEN").
                RUN ue-grabar-mov-otr(INPUT "DOCUMENTO").
            END.
        END.
        /* La O/D no comprobantes emitidos */
        IF lTieneGRs = NO THEN DO:            
            /* Adiciono registro */
            CREATE tt-seguimiento.
            RUN ue-grabar-mov-otr(INPUT "PEDIDO").
            RUN ue-grabar-mov-otr(INPUT "ORDEN").

        END.
    END.
    /* El Pedido no tiene O/D */
    IF lTieneODs = NO THEN DO:
        /* Adiciono registro */
        CREATE tt-seguimiento.
        RUN ue-grabar-mov-otr(INPUT "PEDIDO").
    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-transferencias-manuales wWin 
PROCEDURE ue-transferencias-manuales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR lCodDocRuta AS CHAR.
DEFINE VAR lNroDocRuta AS CHAR.
DEFINE VAR lTieneODs AS LOG.
DEFINE VAR lTieneGRs AS LOG.
DEFINE VAR lTieneHRs AS LOG.

DEFINE VAR lNroRepoAuto AS CHAR.
DEFINE VAR lNroDoctoHR AS CHAR.

DEFINE BUFFER b-almacen FOR almacen.

FOR EACH almacen WHERE almacen.codcia = s-codcia NO-LOCK, 
        FIRST gn-divi OF almacen NO-LOCK
                        WHERE gn-divi.campo-log[5] = YES : /* Solo los de CD */

    FOR EACH almcmov WHERE almcmov.codcia = s-codcia AND
                almcmov.codalm = almacen.codalm AND 
                almcmov.tipmov = 'S' AND  
                almcmov.codmov = 3 AND
                almcmov.codref = '' AND 
                (almcmov.fchdoc >= txtDesde AND almcmov.fchdoc <= txtHasta) AND 
                almcmov.flgest <> 'A' NO-LOCK:

        lqCostoVenta = 0.
        lqCostoReposicion = 0.
        lqCostoKardex = 0.
        /* */
        lqItems = 0.
        lqPeso = 0.
        lqVolumen = 0.

        lDcli = "".
        lDpto = "".
        lProv = "".
        lDist = "".
        lCodpro = "".
        lDesPro = "".
        lDestino = "".

        lOrigen = almcmov.codalm.
        /* */
        lDist = almcmov.codalm.
        lDestino = almcmov.almdes.


        /* Cliente */
        FIND FIRST b-almacen WHERE b-almacen.codcia = s-codcia AND b-almacen.codalm = lDist
            NO-LOCK NO-ERROR.
        IF AVAILABLE b-almacen THEN lDestino = b-almacen.campo-c[8].

        FIND FIRST b-almacen WHERE b-almacen.codcia = s-codcia AND b-almacen.codalm = lOrigen
            NO-LOCK NO-ERROR.
        IF AVAILABLE b-almacen THEN lorigen = b-almacen.campo-c[8].

        FIND FIRST b-almacen WHERE b-almacen.codcia = s-codcia AND b-almacen.codalm = lDist
            NO-LOCK NO-ERROR.
        IF AVAILABLE b-almacen THEN lDcli = b-almacen.descripcion.
        /* Destino */
        IF lProv <> '' THEN DO:
            IF lProv = 'LIMA' THEN DO:
                lDestino = lDist.
            END.
            ELSE DO:
                IF lProv = 'CALLAO' THEN DO:
                    lDestino = "CALLAO".
                END.
                ELSE DO:
                    lDestino = "PROVINCIAS".
                END.
            END.
        END.
        lNroRepoAuto = STRING(almcmov.nroser,"999") + STRING(almcmov.nrodoc,"9999999").
        /* Bultos de la O/D */
        FIND FIRST ccbcbult WHERE ccbcbult.codcia = s-codcia AND 
                            ccbcbult.coddoc = 'TRA' AND
                            ccbcbult.nrodoc = od_faccpedi.nroped NO-LOCK NO-ERROR.
        
        lqCostoVenta = 0.
        lqCostoReposicion = 0.
        lqCostoKardex = 0.
        IF ChkbxResumen = NO THEN DO:
            RUN ue-Importes('TRA',OUTPUT lqCostoVenta, OUTPUT lqCostoReposicion, OUTPUT lqCostoKardex).
        END.
        
        /**/
        lqItems = 0.
        lqPeso = 0.
        lqVolumen = 0.
        IF ChkbxResumen = NO THEN DO:
            RUN ue-item-peso("TRN", OUTPUT lqItems, OUTPUT lqPeso, OUTPUT lqVolumen).
        END.        

        lTieneGRs = NO.
        lTieneHRs = NO.
        /* Buscar la el Documento en la HR */
        FOR EACH di-RutaG USE-INDEX llave02 WHERE di-RutaG.codcia = s-codcia AND 
                                di-RutaG.coddoc = 'H/R' AND 
                                di-RutaG.codalm = almcmov.codalm AND
                                di-RutaG.tipmov = 'S' AND
                                di-RutaG.codmov = 3 AND
                                di-RutaG.serref = almcmov.nroser AND 
                                di-RutaG.NroRef = almcmov.nrodoc AND
                                di-RutaG.flgest <> 'A' NO-LOCK, 
            FIRST di-rutaC OF di-rutaG WHERE di-RutaC.flgest <> 'A' NO-LOCK:

            lCodPro = ''.
            lDesPro = ''.
            /* Transportista */
                /* Version antigua */
            FIND FIRST gn-vehic WHERE gn-vehic.codcia = DI-RutaC.codcia AND 
                  gn-vehic.placa = DI-RutaC.codveh NO-LOCK NO-ERROR.
            IF AVAILABLE gn-vehic THEN DO:
               lCodPro     = gn-vehic.codpro.
            END.
            IF DI-RutaC.codpro = '' OR DI-RutaC.codpro = ? THEN DO: 
                /* La ruta no tiene codprodveedor por lo tanto agarra la de la tabla Vehiculos */
            END.
            ELSE lCodPro = DI-RutaC.codpro.

            FIND FIRST gn-prov WHERE gn-prov.codcia = 0 AND gn-prov.codpro = lCodPro NO-LOCK NO-ERROR.
            IF AVAILABLE gn-prov THEN lDesPro = gn-prov.nompro.

            /* Adiciono registro */
            CREATE tt-seguimiento.
            RUN ue-grabar-mov-tra(INPUT "PEDIDO").
            RUN ue-grabar-mov-tra(INPUT "ORDEN").
            RUN ue-grabar-mov-tra(INPUT "DOCUMENTO").
            RUN ue-grabar-mov-tra(INPUT "HRUTA").

            lNroDoctoHR = STRING(di-RutaG.serref,"999") + STRING(di-RutaG.nroref,"999999").
            /* Buscar la salida de vigilancia */
            FIND FIRST almdcdoc USE-INDEX llave02 WHERE almdcdoc.codcia = s-codcia AND 
                                        almdcdoc.coddoc = 'G/R' AND
                                        almdcdoc.nrodoc = lNroDoctoHR NO-LOCK NO-ERROR.
            IF AVAILABLE almdcdoc  THEN DO:
                RUN ue-grabar-mov-tra(INPUT "VIGISALIDA").
            END.
            /* Buscar si vigilancia registro devoluciones*/
            FIND FIRST almRCdoc USE-INDEX llave02 WHERE almRCdoc.codcia = s-codcia AND 
                                        almRCdoc.coddoc = 'G/R' AND
                                        almRCdoc.nrodoc = lNroDoctoHR NO-LOCK NO-ERROR.
            IF AVAILABLE almRCdoc  THEN DO:
                RUN ue-grabar-mov-tra(INPUT "VIGIDEVOL").
            END.

            lTieneHRs = YES.
        END.
        /* No tiene HR */
        IF lTieneHRs = NO THEN DO:
            /* Adiciono registro */
            CREATE tt-seguimiento.
            RUN ue-grabar-mov-tra(INPUT "PEDIDO").
            RUN ue-grabar-mov-tra(INPUT "ORDEN").
            RUN ue-grabar-mov-tra(INPUT "DOCUMENTO").
        END.

    END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-txt wWin 
PROCEDURE ue-txt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*

OUTPUT STREAM REPORT TO VALUE(x-Archivo).

PUT STREAM REPORT
    "Cod.Ref|"
    "Nro.Ref|"
    "Aprobacion|"
    "Codigo|"
    "Numero|"
    "Orden Fecha Emision|"
    "Orden Hora Emision|"
    "Fecha Inicio Pre-picking|"
    "Hora Inicio Pre-picking|"
    "Fecha/Hora Fin Pre-picking|"
    "Doc|"
    "Nro Guia|"
    "Dcto Fecha Emision|"
    "Dcto Hora Emision|"
    "Origen|"
    "CodCliente|"
    "Nombre del Cliente|"
    "Fecha/Hora Impresion|"
    "Fecha/Hora Distribucion|"
    "Items|"
    "Entrega|"
    "Peso|"
    "Bultos|"
    "Fecha Rotulado|"
    "Dia inicio Chequeo|"
    "Hora inicio Chequeo|"
    "Dia fin Chequeo|"
    "Hora fin de chequeo|"
    "Numero H/R|"
    "Hora Salida|"
    "Hora Retorno|"
    "Fecha Salida|"
    "Placa|"
    "Guia Transp.|"
    "Transportista|"
    "Tipo Movim.|"
    "Division|"
    "Hora Llegada|"
    "Hora Partida|"
    "Dpto|"
    "Provincia|"
    "Distrito|"
    "Destino|"
    "S/. Importe Venta Con IGV|"
    "S/. Importe Reposicion con IGV|"
    "S/. Costo Promedio Kardex|"
    "Estado" SKIP.

FOR EACH tt-rsmen:
  PUT STREAM REPORT
      tt-codref "|"
      tt-nroref "|"
      tt-faprueba "|"
      tt-coddoc "|"
      tt-nrodoc "|"
      tt-femi "|"
      tt-hemi "|"
      tt-finiprechq "|"
      tt-Hiniprechq "|"
      tt-ffinprechq "|"
      tt-cdoc "|"
      tt-ndoc "|"
      tt-xfemi "|"
      tt-xhemi "|"
      tt-origen "|"
      tt-codcli "|"
      tt-nomcli "|"
      tt-fhimp "|"
      tt-fdistr "|"
      tt-qitms "|"
      tt-fent "|"
      tt-peso "|"
      tt-bultos "|"
      tt-frotula "|"
      tt-finicheq "|"
      tt-hinicheq "|"
      tt-ffincheq "|"
      tt-hfincheq "|"
      tt-hruta "|"
      tt-hsalida "|"
      tt-hretorno "|"
      tt-fsalida "|"
      tt-placa "|"
      tt-gtranspo "|"
      tt-transpo "|"
      tt-tipomov "|"
      tt-divori "|"
      tt-hllegada "|"
      tt-hpartida "|"
      tt-dpto "|"
      tt-prov "|"
      tt-dist "|"
      tt-destino "|"
      tt-imptot "|"
      tt-imprepo "|"
      tt-impkard "|"
      tt-estado SKIP.
END.

OUTPUT STREAM REPORT CLOSE.
MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.
  */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-ventas wWin 
PROCEDURE ue-ventas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR lCodDocRuta AS CHAR.
DEFINE VAR lNroDocRuta AS CHAR.
DEFINE VAR lTieneODs AS LOG.
DEFINE VAR lTieneGRs AS LOG.
DEFINE VAR lTieneHRs AS LOG.

DEFINE VAR cDoctos AS CHAR.

lqCostoVenta = 0.
lqCostoReposicion = 0.
lqCostoKardex = 0.
/* */
lqItems = 0.
lqPeso = 0.
lqVolumen = 0.

EMPTY TEMP-TABLE tt-control.

FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia AND 
                        faccpedi.coddoc = 'PED' AND 
                        (faccpedi.fchped >= txtDesde AND faccpedi.fchped <= txtHasta) AND
                        (txtCodDivi = '' OR faccpedi.coddiv = txtCodDivi) AND 
                        faccpedi.flgest <> 'A' NO-LOCK :
    /* Solo Centro de Distribucion*/
    FIND FIRST gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND 
                                        gn-divi.coddiv = faccpedi.divdes /*AND
                                        gn-divi.campo-log[5] = YES */ NO-ERROR.  
    IF NOT AVAILABLE gn-divi  THEN NEXT.

    lDcli = "".
    lDpto = "".
    lProv = "".
    lDist = "".
    lCodpro = "".
    lDesPro = "".
    lDestino = "".

    /* Cliente */
    FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = faccpedi.codcli 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN lDCli = gn-clie.nomcli.

    FIND FIRST tabdepto WHERE gn-clie.coddept = tabdepto.coddepto NO-LOCK NO-ERROR.
    IF AVAILABLE tabdepto THEN lDpto = tabdepto.nomdepto.

    FIND FIRST tabprovi WHERE gn-clie.coddept = tabprovi.coddepto AND
        gn-clie.codprov = tabprovi.codprovi NO-LOCK NO-ERROR.
    IF AVAILABLE tabprovi THEN lProv = tabprovi.nomprovi.

    FIND FIRST tabdistr WHERE gn-clie.coddept = tabdistr.coddepto AND 
        gn-clie.codprov = tabdistr.codprovi AND 
        gn-clie.coddist = tabdistr.coddistr NO-LOCK NO-ERROR.
    IF AVAILABLE tabdistr THEN lDist = tabdistr.nomdistr.

    /* Destino */
    IF lProv <> '' THEN DO:
        IF lProv = 'LIMA' THEN DO:
            lDestino = lDist.
        END.
        ELSE DO:
            IF lProv = 'CALLAO' THEN DO:
                lDestino = "CALLAO".
            END.
            ELSE DO:
                lDestino = "PROVINCIAS".
            END.
        END.
    END.

    lTieneODs = NO.
    /* Sus Ordenes de Despacho */
    FOR EACH od_faccpedi WHERE od_faccpedi.codcia = faccpedi.codcia AND 
        od_faccpedi.codref = faccpedi.coddoc AND
        od_faccpedi.nroref = faccpedi.nroped AND 
        od_faccpedi.coddoc = 'O/D' AND 
        od_faccpedi.flgest <> 'A' NO-LOCK,
        EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = od_faccpedi.codcia AND
        VtaCDocu.CodDiv = od_faccpedi.divdes AND
        VtaCDocu.CodPed = "HPK" AND
        VtaCDocu.CodRef = od_faccpedi.coddoc AND
        VtaCDocu.NroRef = od_faccpedi.nroped AND
        VtaCDocu.FlgEst <> "A",
        EACH CcbCBult NO-LOCK WHERE CcbCBult.CodCia = s-CodCia AND
        CcbCBult.CodDoc = od_faccpedi.coddoc AND
        CcbCBult.NroDoc = od_faccpedi.nroped AND
        CcbCBult.Chr_05 = VtaCDocu.CodPed + ',' + VtaCDocu.NroPed:
        /* Bultos de la O/D */
/*         FIND FIRST ccbcbult WHERE ccbcbult.codcia = s-codcia AND                   */
/*                             ccbcbult.coddoc = od_faccpedi.coddoc AND               */
/*                             ccbcbult.nrodoc = od_faccpedi.nroped NO-LOCK NO-ERROR. */
        lTieneODs = YES.
        lqCostoVenta = 0.
        lqCostoReposicion = 0.
        lqCostoKardex = 0.        

        /* Importe de la O/D */
        IF ChkbxResumen = NO THEN DO:
            RUN ue-Importes('O/D',OUTPUT lqCostoVenta, OUTPUT lqCostoReposicion, OUTPUT lqCostoKardex).
        END.        
        ELSE DO:
            lqCostoVenta = od_faccpedi.imptot.
        END.

        lqItems = 0.
        lqPeso = 0.
        lqVolumen = 0.
        IF ChkbxResumen = NO THEN DO:
            RUN ue-item-peso("O/D", OUTPUT lqItems, OUTPUT lqPeso, OUTPUT lqVolumen).
        END.
        
        cDoctos = "FAC,BOL,TCK".
        /* Verificar si la O/D tiene FAIs */
        FIND FIRST ccbcdocu USE-INDEX llave15 WHERE ccbcdocu.codcia = s-codcia AND 
            ccbcdocu.codped = faccpedi.coddoc AND
            ccbcdocu.nroped = faccpedi.nroped AND 
            ccbcdocu.coddoc = 'FAI' AND 
            ccbcdocu.libre_c01 = od_faccpedi.coddoc AND
            ccbcdocu.libre_c02 = od_faccpedi.nroped AND
            ccbcdocu.flgest <> 'A' NO-LOCK NO-ERROR.
        IF AVAILABLE ccbcdocu THEN cDoctos = "FAI,BOL,TCK".

        /* Buscar los documentos (FAC,BOL,TCK) emitidos por la O/D */
        lTieneGRs = NO.
        FOR EACH ccbcdocu USE-INDEX llave15 WHERE ccbcdocu.codcia = s-codcia AND 
                                ccbcdocu.codped = faccpedi.coddoc AND
                                ccbcdocu.nroped = faccpedi.nroped AND 
                                LOOKUP(ccbcdocu.coddoc,cDoctos) > 0 AND 
                                ccbcdocu.libre_c01 = od_faccpedi.coddoc AND
                                ccbcdocu.libre_c02 = od_faccpedi.nroped AND
                                ccbcdocu.flgest <> 'A' NO-LOCK:
            
            /* Buscar las G/R de la FAC/BOL/TCK */
            FOR EACH gr_ccbcdocu USE-INDEX llave07 WHERE gr_ccbcdocu.codcia = s-codcia AND
                                        gr_ccbcdocu.codref = ccbcdocu.coddoc AND
                                        gr_ccbcdocu.nroref = ccbcdocu.nrodoc AND
                                        gr_ccbcdocu.coddoc = 'G/R' 
                                        NO-LOCK :                
                /* */
                lTieneGRs = YES.
                lTieneHRs = NO.

                /* ----- */
                RUN ue-ventas-hoja-de-ruta(INPUT gr_ccbcdocu.coddoc, INPUT gr_ccbcdocu.nrodoc, OUTPUT lTieneHRs).

                /* La G/R No tiene HR */
                IF lTieneHRs = NO THEN DO:
                    /* Adiciono registro */
                    CREATE tt-seguimiento.
                    RUN ue-grabar-mov(INPUT "PEDIDO").
                    RUN ue-grabar-mov(INPUT "ORDEN").
                    RUN ue-grabar-mov(INPUT "DOCUMENTO").
                    RUN ue-grabar-mov(INPUT "GUIAREMISION").
                END.
            END.
            /* El comprobante FAC/BOL/TCK no tienee G/R */
            IF lTieneGRs = NO THEN DO:
                /**/
                lTieneHRs = NO.

                lqItems = 0.
                lqPeso = 0.
                lqVolumen = 0.
                IF ChkbxResumen = NO THEN RUN ue-item-peso("DOC", OUTPUT lqItems, OUTPUT lqPeso, OUTPUT lqVolumen).
                /* ----- */
                RUN ue-ventas-hoja-de-ruta(INPUT ccbcdocu.coddoc, INPUT ccbcdocu.nrodoc, OUTPUT lTieneHRs).
                /* La FAC/BOL/TCK No tiene HR */
                IF lTieneGRs = NO AND lTieneHRs = NO THEN DO:
                    /* Adiciono registro */
                    CREATE tt-seguimiento.
                    RUN ue-grabar-mov(INPUT "PEDIDO").
                    RUN ue-grabar-mov(INPUT "ORDEN").
                    RUN ue-grabar-mov(INPUT "DOCUMENTO").
                    lTieneGRs = YES.
                END.

            END.
        END.
        /* La O/D no comprobantes emitidos */
        IF lTieneGRs = NO THEN DO:            
            /* Adiciono registro */
            CREATE tt-seguimiento.
            RUN ue-grabar-mov(INPUT "PEDIDO").
            RUN ue-grabar-mov(INPUT "ORDEN").

        END.
    END.
    /* El Pedido no tiene O/D */
    IF lTieneODs = NO THEN DO:
        /* Adiciono registro */
        /*MESSAGE "PEDIDOS.".*/
        CREATE tt-seguimiento.
        RUN ue-grabar-mov(INPUT "PEDIDO").
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-ventas-borrar wWin 
PROCEDURE ue-ventas-borrar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR lCodDocRuta AS CHAR.
DEFINE VAR lNroDocRuta AS CHAR.
DEFINE VAR lTieneODs AS LOG.
DEFINE VAR lTieneGRs AS LOG.
DEFINE VAR lTieneHRs AS LOG.

lqCostoVenta = 0.
lqCostoReposicion = 0.
lqCostoKardex = 0.
/* */
lqItems = 0.
lqPeso = 0.
lqVolumen = 0.

FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia AND 
                        faccpedi.coddoc = 'PED' AND 
                        (faccpedi.fchped >= txtDesde AND faccpedi.fchped <= txtHasta) AND
                        (txtCodDivi = '' OR faccpedi.coddiv = txtCodDivi) AND 
                        faccpedi.flgest <> 'A' NO-LOCK :

    /* Solo Centro de Distribucion*/
    FIND FIRST gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND 
                                        gn-divi.coddiv = faccpedi.divdes /*AND
                                        gn-divi.campo-log[5] = YES */ NO-ERROR.  
    IF NOT AVAILABLE gn-divi  THEN NEXT.

    lDcli = "".
    lDpto = "".
    lProv = "".
    lDist = "".
    lCodpro = "".
    lDesPro = "".
    lDestino = "".

    /* Cliente */
    FIND FIRST gn-clie WHERE gn-clie.codcia= 0 AND gn-clie.codcli = faccpedi.codcli 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN lDCli = gn-clie.nomcli.

    FIND FIRST tabdepto WHERE gn-clie.coddept = tabdepto.coddepto NO-LOCK NO-ERROR.
    IF AVAILABLE tabdepto THEN lDpto = tabdepto.nomdepto.

    FIND FIRST tabprovi WHERE gn-clie.coddept = tabprovi.coddepto AND
        gn-clie.codprov = tabprovi.codprovi NO-LOCK NO-ERROR.
    IF AVAILABLE tabprovi THEN lProv = tabprovi.nomprovi.

    FIND FIRST tabdistr WHERE gn-clie.coddept = tabdistr.coddepto AND 
        gn-clie.codprov = tabdistr.codprovi AND 
        gn-clie.coddist = tabdistr.coddistr NO-LOCK NO-ERROR.
    IF AVAILABLE tabdistr THEN lDist = tabdistr.nomdistr.

    /* Destino */
    IF lProv <> '' THEN DO:
        IF lProv = 'LIMA' THEN DO:
            lDestino = lDist.
        END.
        ELSE DO:
            IF lProv = 'CALLAO' THEN DO:
                lDestino = "CALLAO".
            END.
            ELSE DO:
                lDestino = "PROVINCIAS".
            END.
        END.
    END.

    lTieneODs = NO.
    /* Sus Ordenes de Despacho */
    FOR EACH od_faccpedi USE-INDEX llave07 WHERE od_faccpedi.codcia = faccpedi.codcia AND 
                                                od_faccpedi.codref = faccpedi.coddoc AND
                                                od_faccpedi.nroref = faccpedi.nroped AND 
                                                od_faccpedi.coddoc = 'O/D' AND 
                                                od_faccpedi.flgest <> 'A' NO-LOCK :

        /* Bultos de la O/D */
        FIND FIRST ccbcbult WHERE ccbcbult.codcia = s-codcia AND 
                            ccbcbult.coddoc = od_faccpedi.coddoc AND
                            ccbcbult.nrodoc = od_faccpedi.nroped NO-LOCK NO-ERROR.
        IF AVAILABLE ccbcbult THEN DO:
            /*
            RUN lib/_time-passed ( DATETIME(STRING(Ccbcbult.dte_02) + ' ' + STRING(Ccbcbult.CHR_04)),
                                     DATETIME(STRING(Ccbcbult.dte_01) + ' ' + STRING(Ccbcbult.CHR_03)), OUTPUT x-Tiempo).
            */
        END.
        lTieneODs = YES.

        /* Buscar los documentos emitidos por la O/D */
        lTieneGRs = NO.
        FOR EACH ccbcdocu USE-INDEX llave15 WHERE ccbcdocu.codcia = s-codcia AND 
                                ccbcdocu.codped = faccpedi.coddoc AND
                                ccbcdocu.nroped = faccpedi.nroped AND 
                                LOOKUP(ccbcdocu.coddoc,"FAC,BOL,TCK") > 0 AND 
                                ccbcdocu.libre_c01 = od_faccpedi.coddoc AND
                                ccbcdocu.libre_c02 = od_faccpedi.nroped AND
                                ccbcdocu.flgest <> 'A' NO-LOCK:
            lqCostoVenta = 0.
            lqCostoReposicion = 0.
            lqCostoKardex = 0.
            RUN ue-Importes('O/D',OUTPUT lqCostoVenta, OUTPUT lqCostoReposicion, OUTPUT lqCostoKardex).
            /**/
            lqItems = 0.
            lqPeso = 0.
            lqVolumen = 0.
            RUN ue-item-peso("G/R", OUTPUT lqItems, OUTPUT lqPeso, OUTPUT lqVolumen).

            /* Si tiene G/R o FAC/TCK/BOL que tengan hoja de Ruta */
            lNroDocRuta = ccbcdocu.nrodoc.
            lCodDocRuta = ccbcdocu.coddoc.
            IF ccbcdocu.codref = 'G/R' THEN DO:
                lCodDocRuta = ccbcdocu.codref.
                lNroDocRuta = ccbcdocu.nroref.
            END.
            lTieneGRs = YES.
            lTieneHRs = NO.
            /* Buscar la el Documento en la HR */
            FOR EACH di-RutaD USE-INDEX llave02 WHERE di-RutaD.codcia = s-codcia AND 
                                    di-RutaD.coddoc = 'H/R' AND 
                                    di-RutaD.codref = lCodDocRuta AND 
                                    di-RutaD.NroRef = lNroDocRuta AND
                                    di-RutaD.flgest <> 'A' NO-LOCK, 
                FIRST di-rutaC OF di-rutaD WHERE di-RutaC.flgest <> 'A':

                lCodPro = ''.
                lDesPro = ''.
                /* Transportista */
                    /* Version antigua */
                FIND FIRST gn-vehic WHERE gn-vehic.codcia = DI-RutaC.codcia AND 
                      gn-vehic.placa = DI-RutaC.codveh NO-LOCK NO-ERROR.
                IF AVAILABLE gn-vehic THEN DO:
                   lCodPro     = gn-vehic.codpro.
                END.
                IF DI-RutaC.codpro = '' OR DI-RutaC.codpro = ? THEN DO: 
                    /* La ruta no tiene codprodveedor por lo tanto agarra la de la tabla Vehiculos */
                END.
                ELSE lCodPro = DI-RutaC.codpro.

                FIND FIRST gn-prov WHERE gn-prov.codcia = 0 AND gn-prov.codpro = lCodPro NO-LOCK NO-ERROR.
                IF AVAILABLE gn-prov THEN lDesPro = gn-prov.nompro.

                /* Adiciono registro */
                CREATE tt-seguimiento.
                RUN ue-grabar-mov(INPUT "PEDIDO").
                RUN ue-grabar-mov(INPUT "ORDEN").
                RUN ue-grabar-mov(INPUT "DOCUMENTO").
                RUN ue-grabar-mov(INPUT "HRUTA").
                /* Buscar la salida de vigilancia */
                FIND FIRST almdcdoc USE-INDEX llave02 WHERE almdcdoc.codcia = s-codcia AND 
                                            almdcdoc.coddoc = di-RutaD.codref AND
                                            almdcdoc.nrodoc = di-RutaD.nroref NO-LOCK NO-ERROR.
                IF AVAILABLE almdcdoc  THEN DO:
                    RUN ue-grabar-mov(INPUT "VIGISALIDA").
                END.
                /* Buscar si vigilancia registro devoluciones*/
                FIND FIRST almRCdoc USE-INDEX llave02 WHERE almRCdoc.codcia = s-codcia AND 
                                            almRCdoc.coddoc = di-RutaD.codref AND
                                            almRCdoc.nrodoc = di-RutaD.nroref NO-LOCK NO-ERROR.
                IF AVAILABLE almRCdoc  THEN DO:
                    RUN ue-grabar-mov(INPUT "VIGIDEVOL").
                END.

                lTieneHRs = YES.
            END.
            /* No tiene HR */
            IF lTieneHRs = NO THEN DO:
                /* Adiciono registro */
                CREATE tt-seguimiento.
                RUN ue-grabar-mov(INPUT "PEDIDO").
                RUN ue-grabar-mov(INPUT "ORDEN").
                RUN ue-grabar-mov(INPUT "DOCUMENTO").
            END.
        END.
        /* La O/D no comprobantes emitidos */
        IF lTieneGRs = NO THEN DO:            
            /* Adiciono registro */
            CREATE tt-seguimiento.
            RUN ue-grabar-mov(INPUT "PEDIDO").
            RUN ue-grabar-mov(INPUT "ORDEN").

        END.
    END.
    /* El Pedido no tiene O/D */
    IF lTieneODs = NO THEN DO:
        /* Adiciono registro */
        CREATE tt-seguimiento.
        RUN ue-grabar-mov(INPUT "PEDIDO").
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-ventas-hoja-de-ruta wWin 
PROCEDURE ue-ventas-hoja-de-ruta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodDocRuta AS CHAR.
DEFINE INPUT PARAMETER pNroDocRuta AS CHAR.
DEFINE OUTPUT PARAMETER pTieneHR AS LOG.

pTieneHR = NO.

/* Buscar la el Documento en la HR */
FOR EACH di-RutaD USE-INDEX llave02 WHERE di-RutaD.codcia = s-codcia AND 
                        di-RutaD.coddoc = 'H/R' AND 
                        di-RutaD.codref = pCodDocRuta AND 
                        di-RutaD.NroRef = pNroDocRuta,
    FIRST di-rutaC OF di-rutaD WHERE di-RutaC.flgest <> 'A' NO-LOCK:

    lCodPro = ''.
    lDesPro = ''.
    /* Transportista */
        /* Version antigua */
    FIND FIRST gn-vehic WHERE gn-vehic.codcia = DI-RutaC.codcia AND 
          gn-vehic.placa = DI-RutaC.codveh NO-LOCK NO-ERROR.
    IF AVAILABLE gn-vehic THEN DO:
       lCodPro     = gn-vehic.codpro.
    END.
    IF DI-RutaC.codpro = '' OR DI-RutaC.codpro = ? THEN DO: 
        /* La ruta no tiene codprodveedor por lo tanto agarra la de la tabla Vehiculos */
    END.
    ELSE lCodPro = DI-RutaC.codpro.

    FIND FIRST gn-prov WHERE gn-prov.codcia = 0 AND gn-prov.codpro = lCodPro NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN lDesPro = gn-prov.nompro.

    /* Adiciono registro */
    CREATE tt-seguimiento.
    RUN ue-grabar-mov(INPUT "PEDIDO").
    RUN ue-grabar-mov(INPUT "ORDEN").
    RUN ue-grabar-mov(INPUT "DOCUMENTO").
    RUN ue-grabar-mov(INPUT "GUIAREMISION").
    RUN ue-grabar-mov(INPUT "HRUTA").
    /* Buscar la salida de vigilancia */
    FIND FIRST almdcdoc USE-INDEX llave02 WHERE almdcdoc.codcia = s-codcia AND 
                                almdcdoc.coddoc = di-RutaD.codref AND
                                almdcdoc.nrodoc = di-RutaD.nroref NO-LOCK NO-ERROR.
    IF AVAILABLE almdcdoc  THEN DO:
        RUN ue-grabar-mov(INPUT "VIGISALIDA").
    END.
    /* Buscar si vigilancia registro devoluciones*/
    FIND FIRST almRCdoc USE-INDEX llave02 WHERE almRCdoc.codcia = s-codcia AND 
                                almRCdoc.coddoc = di-RutaD.codref AND
                                almRCdoc.nrodoc = di-RutaD.nroref NO-LOCK NO-ERROR.
    IF AVAILABLE almRCdoc  THEN DO:
        RUN ue-grabar-mov(INPUT "VIGIDEVOL").
    END.

    pTieneHR = YES.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um-excel wWin 
PROCEDURE um-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
        DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
        DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
        DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

        DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

        DEFINE VARIABLE iCount                  AS INTEGER init 1.
        DEFINE VARIABLE iIndex                  AS INTEGER.
        DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
        DEFINE VARIABLE cColumn                 AS CHARACTER.
        DEFINE VARIABLE cRange                  AS CHARACTER.
        DEFINE VARIABLE x-signo                 AS DECI.


        /* create a new Excel Application object */
        CREATE "Excel.Application" chExcelApplication.

        /* launch Excel so it is visible to the user */
        chExcelApplication:Visible = TRUE.

        /* Para crear a new Workbook */
        chWorkbook = chExcelApplication:Workbooks:Add().

        /* get the active Worksheet */
        chWorkSheet = chExcelApplication:Sheets:Item(1).

    chExcelApplication:VISIBLE = FALSE.

        /* set the column names for the Worksheet */

        chWorkSheet:Range("B1"):Font:Bold = TRUE.
        chWorkSheet:Range("B1"):Value = "RESUMEN DISTRIBUCION RUTA -  DESDE :" + 
        STRING(txtDesde,"99/99/9999") + "   HASTA :" + STRING(txtHasta,"99/99/9999").

        chWorkSheet:Range("B2"):Font:Bold = TRUE.
        chWorkSheet:Range("B2"):Value = "CENTRO DE DISTRIBUCION :" + 
        txtCodDivi + " " + txtDesDivi.

        chWorkSheet:Range("A3:AZ3"):Font:Bold = TRUE.
        chWorkSheet:Range("A3"):Value = "Origen".
        chWorkSheet:Range("B3"):Value = "Descripcion".
        chWorkSheet:Range("C3"):Value = "Puntos Entregados".
        chWorkSheet:Range("D3"):Value = "Importe Entregados S/.".
        chWorkSheet:Range("E3"):Value = "Puntos Devueltos".
        chWorkSheet:Range("F3"):Value = "Importe Devueltos S/.".
        chWorkSheet:Range("G3"):Value = "Puntos x Entregar".
        chWorkSheet:Range("H3"):Value = "Importe x Entregar S/.".
    

        DEF VAR x-Column AS INT INIT 74 NO-UNDO.
        DEF VAR x-Range  AS CHAR NO-UNDO.
        DEF VAR lPtosEnt AS INT INIT 0.
        DEF VAR lPtosEntImp AS DEC INIT 0.
        DEF VAR lPtosDev AS INT INIT 0.
        DEF VAR lPtosDevImp AS DEC INIT 0.
        DEF VAR lPtosAun AS INT INIT 0.
        DEF VAR lPtosAunImp AS DEC INIT 0.


SESSION:SET-WAIT-STATE('GENERAL').
iColumn = 3.

FOR EACH tt-rsmen-dist NO-LOCK:
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).

        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):VALUE = "'" + tt-coddiv.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):VALUE = "'" + tt-desdiv.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):VALUE = tt-ptos-ent.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):VALUE = tt-imp-ent.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):VALUE = tt-ptos-dev.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):VALUE = tt-imp-dev.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):VALUE = tt-ptos-aun.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):VALUE = tt-imp-aun.

        lPtosEnt = lPtosEnt + tt-ptos-ent.
        lPtosEntImp = lPtosEntImp + tt-imp-ent.
        lPtosDev = lPtosDev + tt-ptos-dev.
        lPtosDevImp = lPtosDevImp + tt-imp-dev.
        lPtosAun = lPtosAun + tt-ptos-aun.
        lPtosAunImp = lPtosAunImp + tt-imp-aun.

END.

        iColumn = iColumn + 2.
        cColumn = STRING(iColumn).

        chWorkSheet:Range("A" + cColumn + ":AZ" + cColumn):Font:Bold = TRUE.
        
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):VALUE = "** TOTALES **".
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):VALUE = lPtosEnt.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):VALUE = lPtosEntImp.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):VALUE = lPtosDev.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):VALUE = lPtosDevImp.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):VALUE = lPtosAun.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):VALUE = lPtosAunImp.


    chExcelApplication:DisplayAlerts = False.
    chExcelApplication:VISIBLE = TRUE .
        /*chExcelApplication:Quit().*/


        /* release com-handles */
        RELEASE OBJECT chExcelApplication NO-ERROR.      
        RELEASE OBJECT chWorkbook NO-ERROR.
        RELEASE OBJECT chWorksheet NO-ERROR.
        RELEASE OBJECT chWorksheetRange NO-ERROR. 

SESSION:SET-WAIT-STATE('').

    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um-procesar wWin 
PROCEDURE um-procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


lTiempoDesde = NOW.

EMPTY TEMP-TABLE tt-seguimiento.

RUN ue-ventas.
RUN ue-ordenes-transferencias.
RUN ue-transferencias-manuales.

lTiempoHasta = NOW.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fchDistribucion wWin 
FUNCTION fchDistribucion RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR lRet AS CHAR.

IF pCodDoc = 'TRA' THEN DO:
    lRet =  IF (NUM-ENTRIES(Almcmov.Libre_c04,'|') > 1) THEN ENTRY(2,Almcmov.Libre_c04,'|') ELSE "".
END.
ELSE DO:
    IF AVAILABLE od_faccpedi THEN DO:
        IF NUM-ENTRIES(od_Faccpedi.Libre_c03,'|') > 1 
              THEN RETURN ENTRY(2,od_Faccpedi.Libre_c03,'|').
          ELSE RETURN "".
    END.
    ELSE DO:
        RETURN "".
    END.
   
END.
  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fFlgEst-Detalle wWin 
FUNCTION fFlgEst-Detalle RETURNS CHARACTER
  ( INPUT cFlgEst AS CHAR  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR cEstado AS CHAR.

CASE cFlgEst:
    WHEN 'P' OR WHEN 'E' THEN cEstado = 'Por Entregar'.
    WHEN 'C' THEN cEstado = 'Entregado'.
    WHEN 'D' THEN cEstado = 'Devolucion Parcial'.
    WHEN 'X' THEN cEstado = 'Devolucion Total'.
    WHEN 'N' THEN cEstado = 'No Entregado'.
    WHEN 'R' THEN cEstado = 'Error de Documento'.
    WHEN 'NR' THEN cEstado = 'No Recibido'.
    OTHERWISE cEstado = '?'.
END CASE.

RETURN cEstado.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fImportes wWin 
FUNCTION fImportes RETURNS DECIMAL
  ( /**/ ) :

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fImpTot wWin 
FUNCTION fImpTot RETURNS DECIMAL
  ( INPUT pDoc AS CHAR, INPUT pTipo AS CHAR  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
            pDoc    = O/D  -   Ventas
                      TRA  -   OTR y TRANS
            pTipo   = VNT   - Ventas
                    = CRP   - Costo Reposicion
                    = CKR   - Costo Promedio Kardex
------------------------------------------------------------------------------*/
DEFINE VAR lCosto AS DEC.
DEFINE VAR lTCambio AS DEC.

lCosto = 0.

IF pDoc = 'TRA' THEN DO:
    DEFINE BUFFER b-almdmov FOR almdmov.

    FOR EACH b-almdmov OF almcmov NO-LOCK,
       FIRST almmmatg OF b-almdmov NO-LOCK :
        lTCambio = 1.
        IF almmmatg.monvta = 2 THEN DO:
            /* Dolares */
            lTCambio = Almmmatg.tpocmb.
        END.
        CASE pTIpo:
            WHEN 'VNT' THEN DO:
                lCosto = lCosto + ((Almmmatg.preofi * lTCambio) * b-AlmDmov.candes).
            END.
            WHEN 'CRP' THEN DO:
                lCosto = lCosto + ((Almmmatg.ctotot * lTCambio) * b-AlmDmov.candes).
            END.
            WHEN 'CKR' THEN DO:
                FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia
                    AND AlmStkGe.codmat = Almmmatg.codmat
                    AND AlmStkGe.fecha <= TODAY NO-LOCK NO-ERROR.
                IF AVAILABLE AlmStkGe THEN DO:
                    lCosto = lCosto + ((AlmStkge.CtoUni * lTCambio) * b-AlmDmov.candes).
                END.
            END.
        END CASE.
    END.
    RELEASE b-almdmov.
    RELEASE AlmStkGe.
END.
ELSE DO:
    DEFINE BUFFER b-ccbddocu FOR ccbddocu.
    FOR EACH b-ccbddocu OF ccbcdocu NO-LOCK,
       FIRST almmmatg OF b-ccbddocu NO-LOCK :
        lTCambio = 1.
        IF almmmatg.monvta = 2 THEN DO:
            /* Dolares */
            lTCambio = Almmmatg.tpocmb.
        END.
        CASE pTIpo:
            WHEN 'VNT' THEN DO:
                lCosto = lCosto + ((Almmmatg.preofi * lTCambio) * b-ccbddocu.candes).
            END.
            WHEN 'CRP' THEN DO:
                lCosto = lCosto + ((Almmmatg.ctotot * lTCambio) * b-ccbddocu.candes).
            END.
            WHEN 'CKR' THEN DO:
                FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia
                    AND AlmStkGe.codmat = Almmmatg.codmat
                    AND AlmStkGe.fecha <= TODAY NO-LOCK NO-ERROR.
                IF AVAILABLE AlmStkGe THEN DO:
                    lCosto = lCosto + ((AlmStkge.CtoUni * lTCambio) * b-ccbddocu.candes).
                END.
            END.
        END CASE.
    END.
    RELEASE b-ccbddocu.
    RELEASE AlmStkGe.
END.

RETURN lCosto.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fItems-Peso wWin 
FUNCTION fItems-Peso RETURNS INTEGER
  ( /**/ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

RETURN 0.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPeso wWin 
FUNCTION fPeso RETURNS DECIMAL
  ( INPUT pTipo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VAR lPeso AS DEC.

   lPeso = 0.
   IF pTipo = 'G/R' THEN DO:
       DEFINE BUFFER b-ccbddocu FOR ccbddocu.
       FOR EACH b-ccbddocu OF ccbcdocu NO-LOCK,
           FIRST almmmatg OF b-ccbddocu NO-LOCK :
           IF almmmatg.pesmat <> ? AND almmmatg.pesmat > 0 THEN DO:
               lPeso = lPeso + (b-ccbddocu.candes * almmmatg.pesmat).
           END.       
       END.
       RELEASE b-ccbddocu.

   END.
   ELSE DO:
       DEFINE BUFFER b-almdmov FOR almdmov.

       FOR EACH b-almdmov OF almcmov NO-LOCK,
           FIRST almmmatg OF b-almdmov NO-LOCK :
           IF almmmatg.pesmat <> ? AND almmmatg.pesmat > 0 THEN DO:
               lPeso = lPeso + (b-almdmov.candes * almmmatg.pesmat).
           END.       
       END.
       RELEASE b-almdmov.
   END.


  RETURN lPeso.   /* Function return value. */

  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fQitems wWin 
FUNCTION fQitems RETURNS INTEGER
  ( INPUT pTipo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR i AS INT.

i = 0.
IF pTipo = 'G/R' THEN DO:
    FOR EACH ccbddocu OF ccbcdocu NO-LOCK:
        i = i + 1.
    END.
END.
ELSE DO:
    FOR EACH almdmov OF almcmov NO-LOCK:
        i = i + 1.
    END.
END.

  RETURN i.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

