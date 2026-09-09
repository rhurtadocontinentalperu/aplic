&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
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

DEFINE SHARED VARIABLE s-codcia  AS INT.
DEFINE SHARED VARIABLE cl-codcia AS INT.
DEFINE SHARED VARIABLE pv-codcia AS INT.

DEFINE BUFFER od_faccpedi FOR faccpedi.
DEFINE BUFFER gr_ccbcdocu FOR ccbcdocu.
DEFINE BUFFER x-gn-divi FOR gn-divi.
DEFINE BUFFER y-gn-divi FOR gn-divi.
DEFINE BUFFER bi-facdpedi FOR facdpedi.
DEFINE BUFFER pcfaccpedi FOR faccpedi.

DEFINE TEMP-TABLE tt-seguimiento NO-UNDO
        FIELDS tt-codpedcom    LIKE faccpedi.coddoc    LABEL "Cod.Pedido Comercial"
        FIELDS tt-nropedcom    AS CHAR     LABEL "Nro.Pedido" FORMAT 'x(20)'
        FIELDS tt-divpedcom    AS CHAR    LABEL "Div.Pedido Pedido Comercial" FORMAT 'x(10)'
        FIELDS tt-fchpedcom    LIKE faccpedi.fchped    LABEL "F.Emision Pedido Comercial"
        FIELDS tt-horpedcom    AS CHAR                 LABEL "H.Emision Pedido Comercial"        FORMAT 'x(20)'
        FIELDS tt-flgpedcom    AS CHAR LABEL "Estado Pedido Comercial" FORMAT 'x(50)'     
 
        /* PEDIDO */
        FIELDS tt-codped    LIKE faccpedi.coddoc    LABEL "Cod.Pedido Logistico"
        FIELDS tt-nroped    AS CHAR     LABEL "Nro.Pedido" FORMAT 'x(20)'
        FIELDS tt-fchped    LIKE faccpedi.fchped    LABEL "F.Emision Pedido Logistico"
        FIELDS tt-horped    AS CHAR                 LABEL "H.Emision Pedido Logistico"        FORMAT 'x(20)'
        /*FIELDS tt-divped    AS CHAR    LABEL "Div.Pedido Pedido" FORMAT 'x(10)'*/
        FIELDS tt-lprecio   AS CHAR                 LABEL "Lista de Precio"          FORMAT 'x(6)'
        FIELDS tt-flgped    AS CHAR LABEL "Estado Pedido Logistico" FORMAT 'x(8)'     

        /* Cyc */
        /* Pasa por aprobar Créditos */
        FIELD tt-fchingcre          AS DATE                 LABEL "Fecha Ing. a Créditos"
        FIELD tt-horingcre          AS CHAR                 LABEL "Hora Ing. a Créditos" FORMAT 'x(20)'
        FIELDS tt-fecha-apro-cyc     AS  DATE                LABEL "Fecha aprobacion a CyC"
        FIELDS tt-hora-apro-cyc      AS  CHAR                LABEL "Hora aprobacion a CyC"  FORMAT 'x(20)'
        /* Orden */
        FIELDS tt-codord    LIKE faccpedi.coddoc    LABEL "Cod.Orden"
        FIELDS tt-nroord    AS CHAR    LABEL "Nro.Orden" FORMAT 'x(20)'
        FIELDS tt-fchord    AS DATE                 LABEL "Fecha Emision Orden"
        FIELDS tt-horord    AS CHAR                 LABEL "Hora Emision Orden"         FORMAT 'x(20)'
        FIELDS tt-fchentord AS DATE                 LABEL "Fecha Entrega Orden"
        FIELDS tt-fchaprord AS DATE                 LABEL "Fecha Aprob. orden"
        FIELDS tt-usrasgord AS CHAR                 LABEL "Usuario Asignado Orden"  FORMAT 'x(20)'
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
        FIELDS tt-imptot    AS DEC    LABEL "S/. Importe Venta Con IGV (O/D)" FORMAT "->>,>>>,>>9.9999"
        /* Envio a Distribucion */
        FIELDS tt-fhimp     LIKE faccpedi.fchimpod  LABEL "Fecha/Hora Impresion" FORMAT '99/99/9999 HH:MM:SS.SSS'
        FIELDS tt-fdistr    AS DATETIME             LABEL "Fecha/Hora Distribucion" FORMAT '99/99/9999 HH:MM:SS.SSS'
        /* Chequeo */
        FIELDS tt-finicheq  LIKE ccbcbult.dte_01    LABEL "Dia inicio Chequeo"
        FIELDS tt-hinicheq  LIKE ccbcbult.CHR_03    LABEL "Hora inicio Chequeo"
        FIELDS tt-ffincheq  LIKE ccbcbult.dte_01    LABEL "Dia fin Chequeo"
        FIELDS tt-hfincheq  LIKE ccbcbult.CHR_03    LABEL "Hora fin de chequeo" FORMAT 'x(6)'
        FIELDS tt-bultos    AS INT    LABEL "Bultos" FORMAT '>,>>>,>>9'
        FIELDS tt-frotula   AS DATE                 LABEL "Fecha Rotulado"
        FIELDS tt-finiemba  LIKE ccbcbult.dte_01    LABEL "Dia inicio Embalado"
        FIELDS tt-hiniemba  LIKE ccbcbult.CHR_03    LABEL "Hora inicio Embalado"
        FIELDS tt-ffinemba  LIKE ccbcbult.dte_01    LABEL "Dia Fin Embalado"
        FIELDS tt-hfinemba  LIKE ccbcbult.CHR_03    LABEL "Hora fin Embalado"
        FIELDS tt-fini_pi  LIKE ccbcbult.dte_01    LABEL "Dia inicio Parte de ingreso"
        FIELDS tt-hini_pi  LIKE ccbcbult.CHR_03    LABEL "Hora inicio Parte de ingreso"

        /* Generacion del Comprobante */
        FIELDS tt-cdoc      LIKE faccpedi.coddoc    LABEL "Doc"
        FIELDS tt-ndoc      AS CHAR                 LABEL "Nro Dcto"                FORMAT 'x(20)'
        FIELDS tt-xfemi     AS DATE                 LABEL "Dcto Fecha Emision"
        FIELDS tt-xhemi     AS CHAR                 LABEL "Dcto Hora Emision"       FORMAT 'x(20)'
        /*FIELDS tt-origen    AS CHAR      LABEL "Division Emision"        FORMAT 'x(10)'*/
        FIELDS tt-codcli    AS CHAR    LABEL "CodCliente" FORMAT 'x(20)'
        FIELDS tt-nomcli    LIKE faccpedi.nomcli    LABEL "Nombre del Cliente"
        FIELDS tt-docremi   LIKE faccpedi.coddoc    LABEL "Doc.Remision"
        FIELDS tt-nroremi   AS CHAR    LABEL "Nro Remision" FORMAT 'x(20)'
        /* Ruta */
        FIELDS tt-hruta         AS CHAR    LABEL "Numero H/R"        FORMAT 'x(20)'
        FIELDS tt-fsalidaHR     AS DATE                 LABEL "Fecha Salida H/R"
        FIELDS tt-hsalidaHR     LIKE di-rutaC.horsal    LABEL "Hora Salida H/R" FORMAT 'x(6)'
        FIELDS tt-hretornoHR    LIKE di-rutac.horret    LABEL "Hora Retorno H/R" FORMAT 'x(6)'        
        /* Transportista */
        FIELDS tt-placa     LIKE di-rutaC.codveh    LABEL "Placa"       FORMAT 'x(25)'
        FIELDS tt-gtranspo  AS CHAR LABEL "Guia Transp." FORMAT 'x(20)'
        FIELDS tt-transpo   AS CHAR                 LABEL "Transportista" FORMAT 'x(60)'
        FIELDS tt-tipomov   AS CHAR                 LABEL "Tipo Movim." FORMAT 'x(15)'
        FIELDS tt-divori    AS CHAR FORMAT 'x(6)'   LABEL "Division DESPACHO"
        FIELDS tt-almacen       AS CHAR     FORMAT 'x(6)'   LABEL "Almacen Despacho"
        /* Salida/dev mercaderia segun vigilancia */
        FIELDS tt-fchsalvig AS DATE                 LABEL "Fecha Salida Vigilancia"
        FIELDS tt-horsalvig AS CHAR                 LABEL "Hora Salida Vigilancia" FORMAT 'x(20)'
        FIELDS tt-fchdevvig AS DATE                 LABEL "Fecha Retorno Vigilancia"
        FIELDS tt-hordevvig AS CHAR                 LABEL "Hora Retorno Vigilancia" FORMAT 'x(20)'
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

DEFINE TEMP-TABLE tt-txtfile NO-UNDO
    FIELDS  tt-orden    AS CHAR    FORMAT 'x(15)'
    FIELDS  tt-pedido    AS CHAR    FORMAT 'x(15)'
    INDEX idx01 tt-orden
    INDEX idx02 tt-pedido.

DEFINE STREAM REPORT.
DEFINE VARIABLE x-Archivo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-rpta    AS LOGICAL     NO-UNDO.

DEFINE VAR lTiempoDesde AS DATETIME.
DEFINE VAR lTiempoHasta AS DATETIME.

DEFINE VAR x-filetxt AS CHAR.

DEFINE VARIABLE FI-MENSAJE AS CHAR FORMAT "X(40)" NO-UNDO.
DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6 SKIP
    Fi-Mensaje NO-LABEL FONT 6 SKIP     
    WITH OVERLAY CENTERED KEEP-TAB-ORDER
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE
        BGCOLOR 15 FGCOLOR 0
        TITLE "Procesando..." FONT 7.


DEFINE VAR dtDesde AS DATETIME.
DEFINE VAR dtHasta AS DATETIME.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS txtCoddivi BUTTON-1 BUTTON-2 txtDesde ~
txtHasta txtProcesar RADIO-SET-tipofile ChkbxResumen 
&Scoped-Define DISPLAYED-OBJECTS txtCoddivi txtDesDivi txtFile txtDesde ~
txtHasta ChkbxGenTxt RADIO-SET-tipofile ChkbxResumen FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fchDistribucion W-Win 
FUNCTION fchDistribucion RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fFlgEst-Detalle W-Win 
FUNCTION fFlgEst-Detalle RETURNS CHARACTER
  ( INPUT cFlgEst AS CHAR  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fImpTot W-Win 
FUNCTION fImpTot RETURNS DECIMAL
  ( INPUT pDoc AS CHAR, INPUT pTipo AS CHAR  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPeso W-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( INPUT pTipo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fQitems W-Win 
FUNCTION fQitems RETURNS INTEGER
  ( INPUT pTipo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 4 BY .88.

DEFINE BUTTON BUTTON-2 
     LABEL "Limpiar nombre de file TXT" 
     SIZE 27 BY .96.

DEFINE BUTTON txtProcesar 
     LABEL "Procesar" 
     SIZE 18 BY 1.62
     FONT 8.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 70 BY .81 NO-UNDO.

DEFINE VARIABLE txtCoddivi AS CHARACTER FORMAT "X(5)":U 
     LABEL "Alguna division de venta ?" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesDivi AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY 1.04 NO-UNDO.

DEFINE VARIABLE txtFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "File TXT (O/D)" 
     VIEW-AS FILL-IN 
     SIZE 61 BY .88
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE RADIO-SET-tipofile AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Texto", 1,
"Excel", 2
     SIZE 19 BY .96 NO-UNDO.

DEFINE VARIABLE ChkbxGenTxt AS LOGICAL INITIAL no 
     LABEL "Generar file TXT" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .77 NO-UNDO.

DEFINE VARIABLE ChkbxResumen AS LOGICAL INITIAL no 
     LABEL "Solo datos de cabecera" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txtCoddivi AT ROW 1.12 COL 19.72 COLON-ALIGNED WIDGET-ID 2
     txtDesDivi AT ROW 1.12 COL 27.86 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     txtFile AT ROW 2.92 COL 11.14 COLON-ALIGNED WIDGET-ID 28
     BUTTON-1 AT ROW 2.92 COL 75 WIDGET-ID 30
     BUTTON-2 AT ROW 4.65 COL 30 WIDGET-ID 32
     txtDesde AT ROW 6.58 COL 21 COLON-ALIGNED WIDGET-ID 4
     txtHasta AT ROW 6.58 COL 43.14 COLON-ALIGNED WIDGET-ID 6
     ChkbxGenTxt AT ROW 7.73 COL 11 WIDGET-ID 22
     txtProcesar AT ROW 7.73 COL 61 WIDGET-ID 8
     RADIO-SET-tipofile AT ROW 8.12 COL 39 NO-LABEL WIDGET-ID 40
     ChkbxResumen AT ROW 8.5 COL 11 WIDGET-ID 26
     FILL-IN-Mensaje AT ROW 9.62 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     "(solo es valido para PEDIDOS de ventas)" VIEW-AS TEXT
          SIZE 30.57 BY .62 AT ROW 2.15 COL 30 WIDGET-ID 24
     "PEDIDO COMERCIALES que esten emitidos en este rango de fechas" VIEW-AS TEXT
          SIZE 43.86 BY .62 AT ROW 5.81 COL 23.43 WIDGET-ID 20
     "Solo se procesaran O/D inscritas en el TXT" VIEW-AS TEXT
          SIZE 35 BY .5 AT ROW 3.85 COL 25 WIDGET-ID 34
          FGCOLOR 4 
     "v3" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 4.77 COL 73 WIDGET-ID 36
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 82.72 BY 10.65
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "RESUMEN SEGUIMIENTO DE PEDCOM"
         HEIGHT             = 10.65
         WIDTH              = 83.72
         MAX-HEIGHT         = 38.81
         MAX-WIDTH          = 274.29
         VIRTUAL-HEIGHT     = 38.81
         VIRTUAL-WIDTH      = 274.29
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
/* SETTINGS FOR TOGGLE-BOX ChkbxGenTxt IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       ChkbxGenTxt:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtDesDivi IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtFile IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* RESUMEN SEGUIMIENTO DE PEDCOM */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* RESUMEN SEGUIMIENTO DE PEDCOM */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:

    DEFINE VAR OKpressed AS LOG.

          SYSTEM-DIALOG GET-FILE x-Archivo
            FILTERS "Archivo (*.txt)" "*.txt"
            MUST-EXIST
            TITLE "Seleccione archivo..."
            UPDATE OKpressed.   
          IF OKpressed = NO THEN DO:          
          RETURN NO-APPLY.
      END.
          
    ASSIGN txtFile:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-archivo.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Limpiar nombre de file TXT */
DO:
  ASSIGN txtFile:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCoddivi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCoddivi W-Win
ON LEAVE OF txtCoddivi IN FRAME F-Main /* Alguna division de venta ? */
DO:
    txtDesDivi:SCREEN-VALUE IN FRAM {&FRAME-NAME} = "".
  FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
        gn-divi.coddiv = txtCodDivi:SCREEN-VALUE IN FRAM {&FRAME-NAME} NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN txtDesDivi:SCREEN-VALUE IN FRAM {&FRAME-NAME} = gn-divi.desdiv.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtProcesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtProcesar W-Win
ON CHOOSE OF txtProcesar IN FRAME F-Main /* Procesar */
DO:
  ASSIGN txtCoddivi txtdesde txthasta txtDesDivi ChkBxGenTxt ChkbxResumen txtfile radio-set-tipofile.

  IF txtCodDivi > "" THEN DO:  
      FIND gn-divi WHERE gn-divi.codcia = s-codcia AND 
          gn-divi.coddiv = txtCodDivi NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-divi THEN DO:
          MESSAGE 'División está Errada' VIEW-AS ALERT-BOX WARNING.
          RETURN NO-APPLY.
      END.
  END.
  IF txtDesde > txtHasta THEN DO:
      MESSAGE 'Fechas Erradas' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.

  DEFINE VAR iDias AS INT.

  iDias = txtHasta - txtDesde.

  IF iDias > 31 THEN DO:
      MESSAGE 'Maximo de rango de fechas en 31 días' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.

  RUN Texto.

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
  DISPLAY txtCoddivi txtDesDivi txtFile txtDesde txtHasta ChkbxGenTxt 
          RADIO-SET-tipofile ChkbxResumen FILL-IN-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE txtCoddivi BUTTON-1 BUTTON-2 txtDesde txtHasta txtProcesar 
         RADIO-SET-tipofile ChkbxResumen 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Limpiar-Texto W-Win 
PROCEDURE Limpiar-Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "LIMPIANDO TEXTO!!!".

FOR EACH tt-Seguimiento EXCLUSIVE-LOCK:
    RUN lib/limpiar-texto-abc (tt-seguimiento.tt-nomcli, ' ', OUTPUT tt-seguimiento.tt-nomcli).
    RUN lib/limpiar-texto-abc (tt-seguimiento.tt-dircli, ' ', OUTPUT tt-seguimiento.tt-dircli).
    RUN lib/limpiar-texto-abc (tt-seguimiento.tt-lugent, ' ', OUTPUT tt-seguimiento.tt-lugent).
END.

FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

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
  txtDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 15,"99/99/9999").
  txtHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto W-Win 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Pantalla de Impresión */
    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
    DEF VAR cArchivo AS CHAR.
    DEFINE VAR cFechaHora AS CHAR.

    IF radio-set-tipofile = 1 THEN DO:
        RUN lib/tt-file-to-onlytext (OUTPUT pOptions, OUTPUT pArchivo).
        IF pOptions = "" THEN RETURN NO-APPLY.
    END.
    ELSE DO:
        SYSTEM-DIALOG GET-DIR cArchivo
            RETURN-TO-START-DIR 
            TITLE 'Directorio Files'.
    END.

    SESSION:SET-WAIT-STATE('GENERAL').
    dtDesde = NOW.

    RUN um-procesar.

    dtHasta = NOW.

   FIND FIRST tt-seguimiento NO-LOCK NO-ERROR.
    IF NOT AVAILABLE tt-seguimiento THEN DO:
        MESSAGE 'No hay datos que imprimir' SKIP
                dtDesde SKIP
                dtHasta
            VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.

    SESSION:SET-WAIT-STATE('').
    /**/

    IF radio-set-tipofile = 2 THEN DO:

        cFechaHora = STRING(NOW,"99/99/9999 hh:mm:ss").
        cFechaHora = REPLACE(cFechaHora,"/","-").
        cFechaHora = REPLACE(cFechaHora,":","-").
        cFechaHora = REPLACE(cFechaHora," ","_").

        cArchivo = cArchivo + "\seguimiento-pedidos_" + cFechaHora + ".xlsx".

        DEFINE VAR hProc AS HANDLE NO-UNDO.

        RUN lib\Tools-to-excel PERSISTENT SET hProc.

        def var c-csv-file as char no-undo.
        def var c-xls-file as char no-undo. /* will contain the XLS file path created */

        c-xls-file = cArchivo.

        run pi-crea-archivo-csv IN hProc (input  buffer tt-seguimiento:handle,
                                /*input  session:temp-directory + "file"*/ c-xls-file,
                                output c-csv-file) .

        run pi-crea-archivo-xls  IN hProc (input  buffer tt-seguimiento:handle,
                                input  c-csv-file,
                                output c-xls-file) .

        DELETE PROCEDURE hProc.

    END.
    ELSE DO:
        cArchivo = LC(pArchivo).
        SESSION:SET-WAIT-STATE('GENERAL').
    
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Generando el archivo TEXTO".
                    
        RUN lib/tt-filev2 (TEMP-TABLE tt-Seguimiento:HANDLE, cArchivo, pOptions).
        SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    END.
   
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "TERMINADOOOO!!!!".
    MESSAGE 'Proceso Terminado' SKIP
        dtDesde SKIP
        dtHasta
        VIEW-AS ALERT-BOX INFORMATION.
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-grabar-mov W-Win 
PROCEDURE ue-grabar-mov :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-Fase AS CHAR.

DEFINE VAR lSituacion AS CHAR INIT "".
DEFINE VAR lFiler AS CHAR INIT "".
DEFINE VAR x-bultos AS INT.
DEFINE VAR x-fecha-inicio AS DATE.
DEFINE VAR x-hora-inicio AS CHAR.
DEFINE VAR x-fecha-fin AS DATE.
DEFINE VAR x-hora-fin AS CHAR.
DEFINE VAR x-fecha-asg AS DATE.
DEFINE VAR x-hora-asg AS CHAR.
DEFINE VAR x-usr-asg AS CHAR.
DEFINE VAR f-Estado AS CHAR.

CASE p-Fase:
    WHEN "PEDIDOCOMERCIAL" THEN DO:
        ASSIGN /* PEDIDO COMERCIAL */
            tt-seguimiento.tt-codpedcom       = pcfaccpedi.coddoc
            tt-seguimiento.tt-nropedcom       = pcfaccpedi.nroped
            tt-seguimiento.tt-fchpedcom       = pcfaccpedi.fchped
            tt-seguimiento.tt-horpedcom       = pcfaccpedi.hora
            tt-seguimiento.tt-divpedcom       = pcfaccpedi.coddiv
            tt-seguimiento.tt-flgpedcom       = pcfaccpedi.flgest
            tt-seguimiento.tt-codcli          = pcfaccpedi.codcli
            tt-seguimiento.tt-nomcli          = replace(pcfaccpedi.nomcli,";"," ").

            RUN vta2/p-faccpedi-flgest.r(pcFaccpedi.flgest, pcFaccpedi.coddoc, OUTPUT f-Estado).

            ASSIGN tt-seguimiento.tt-flgpedcom       = f-Estado + "(" + pcfaccpedi.flgest +  ")".

            lSituacion = "EMISION PEDIDO COMERCIAL".
    END.

    WHEN "PEDIDO" THEN DO:
        ASSIGN /* PEDIDO */
            tt-seguimiento.tt-codped       = faccpedi.coddoc
            tt-seguimiento.tt-nroped       = faccpedi.nroped
            tt-seguimiento.tt-fchped       = faccpedi.fchped
            tt-seguimiento.tt-horped       = faccpedi.hora
            /*tt-seguimiento.tt-divped       = faccpedi.coddiv*/
            tt-seguimiento.tt-dircli       = replace(faccpedi.dircli,";"," ")
            /* Generacion del Comprobante */
            /*tt-seguimiento.tt-origen   = faccpedi.coddiv*/
            tt-seguimiento.tt-codcli   = faccpedi.codcli
            tt-seguimiento.tt-nomcli   = replace(faccpedi.nomcli,";"," ")
            tt-seguimiento.tt-divori    = faccpedi.divdes
            /*  */
            tt-seguimiento.tt-dpto     = lDpto
            tt-seguimiento.tt-prov     = lProv
            tt-seguimiento.tt-dist     = lDist
            tt-seguimiento.tt-destino  = lDestino
            tt-seguimiento.tt-lugent    = replace(faccpedi.lugent,";"," ")
            tt-seguimiento.tt-glosa     = replace(faccpedi.glosa,";"," ").

            /* Datos del Transporte - Tramos */
            FIND FIRST ccbadocu WHERE ccbadocu.codcia = s-codcia AND 
                ccbadocu.coddiv = faccpedi.coddiv AND 
                ccbadocu.coddoc = faccpedi.coddoc AND
                ccbadocu.nrodoc = faccpedi.nroped NO-LOCK NO-ERROR.
            IF AVAILABLE ccbadocu THEN DO:
                ASSIGN  tt-seguimiento.tt-transportista = replace(ccbadocu.libre_c[4],";"," ")
                        tt-seguimiento.tt-transporte = replace(ccbadocu.libre_c[10],";"," ")
                        tt-seguimiento.tt-direccTransporte = replace(ccbadocu.libre_c[12],";"," ")
                        tt-seguimiento.tt-lugarentrega = replace(ccbadocu.libre_c[13],";"," ").
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

            lSituacion = "EMISION PEDIDO LOGISTICO".

        /* RHC 18/08/18 Ingresó a Créditos para su aprobación */
        FIND LAST vtadtrkped USE-INDEX Indice02 WHERE vtadtrkped.CodCia = Faccpedi.CodCia AND 
            vtadtrkped.CodDoc = Faccpedi.CodDoc AND 
            vtadtrkped.NroPed = Faccpedi.NroPed AND 
            vtadtrkped.CodUbic = "PANPX"   /* Pendiente Aprob. Nota Ped Xreditos */
            NO-LOCK NO-ERROR.
        IF AVAILABLE Vtadtrkped THEN DO:
            ASSIGN
            tt-fchingcre = DATE(vtadtrkped.FechaI)
            tt-horingcre = SUBSTRING(STRING(vtadtrkped.FechaI),12,8).

            /* Ic - 17Ago2021 - Aprobacion Cyc */
            FIND LAST vtadtrkped USE-INDEX Indice02 WHERE vtadtrkped.CodCia = Faccpedi.CodCia AND 
                vtadtrkped.CodDoc = Faccpedi.CodDoc AND 
                vtadtrkped.NroPed = Faccpedi.NroPed AND 
                vtadtrkped.CodUbic = "ANPX"   /* Aprobacion de Ped X Creditos */
                NO-LOCK NO-ERROR.
            IF AVAILABLE Vtadtrkped THEN DO:
                ASSIGN
                    tt-fecha-apro-cyc = DATE(vtadtrkped.FechaI)
                    tt-hora-apro-cyc = SUBSTRING(STRING(vtadtrkped.FechaI),12,8).
            END.
        END.
    END.
    WHEN "ORDEN" THEN DO:
        x-bultos = 0.
        x-fecha-inicio = ?.
        x-fecha-fin = ?.
        x-hora-inicio = "".
        x-hora-fin = "".

        x-fecha-inicio = od_Faccpedi.fecsac.
        x-hora-inicio = od_Faccpedi.horsac.
        x-fecha-fin = od_Faccpedi.fchchq. 
        x-hora-fin = od_Faccpedi.horchq.

        FOR EACH ccbcbult NO-LOCK WHERE ccbcbult.codcia = s-codcia AND
                ccbcbult.coddoc = od_faccpedi.coddoc AND 
                ccbcbult.nrodoc = od_faccpedi.nroped:
            x-bultos = x-bultos + ccbcbult.bultos.
        END.
        /* CASO PICKING X RUTA */
        /* Inicio de chequeo */
        INICIOCHEQUEO:
        FOR EACH vtacdocu NO-LOCK WHERE vtacdocu.codcia = s-codcia AND 
                vtacdocu.codref = od_faccpedi.coddoc AND
                vtacdocu.nroref = od_faccpedi.nroped
                BY vtacdocu.fecsac BY vtacdocu.horsac :

                IF vtacdocu.codped <> 'HPK' THEN NEXT.
                IF vtacdocu.flgest = 'A'  THEN NEXT.
                
            x-fecha-asg = DATE(Vtacdocu.fchinicio).
            x-hora-asg = ENTRY(2,STRING(Vtacdocu.fchinicio,"99/99/9999 hh:mm:ss")," ").
            x-usr-asg = Vtacdocu.usrsacasign.

            x-fecha-inicio = vtacdocu.fecsac.
            x-hora-inicio = vtacdocu.horsac.
            
            LEAVE INICIOCHEQUEO.
        END.
        /*
        FOR EACH vtacdocu NO-LOCK WHERE vtacdocu.codcia = s-codcia AND 
                vtacdocu.codref = od_faccpedi.coddoc AND
                vtacdocu.nroref = od_faccpedi.nroped AND
                vtacdocu.codped = 'HPK' AND
                vtacdocu.flgest <> 'A'  
                BY vtacdocu.fecsac BY vtacdocu.horsac :
            x-fecha-inicio = vtacdocu.fecsac.
            x-hora-inicio = vtacdocu.horsac.
            LEAVE INICIOCHEQUEO.
        END.
        */
        /* Fin de chequeo */
        FINCHEQUEO:
        FOR EACH controlOD NO-LOCK WHERE controlOD.codcia = s-codcia AND 
                controlOD.coddoc = od_faccpedi.coddoc AND 
                controlOD.nrodoc = od_faccpedi.nroped 
                BY controlOD.fchchq DESC BY controlOD.horchq DESC :
            x-fecha-fin = controlOD.fchchq.
            x-hora-fin = controlOD.horchq.
            LEAVE FINCHEQUEO.
        END.
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
            tt-seguimiento.tt-usrasgord    = x-usr-asg
            tt-seguimiento.tt-fchasgord    = x-fecha-asg
            tt-seguimiento.tt-horasgord    = x-hora-asg
            tt-seguimiento.tt-qitms        = lqItems
            tt-seguimiento.tt-peso         = lqPeso
            tt-seguimiento.tt-volumen      = lqVolumen
            tt-seguimiento.tt-imptot       = lqCostoVenta /*fimpTot('O/D','VNT')  /*ccbcdocu.imptot*/*/
            /*  02Feb2023, Se retiro a pedido de Susana, Orden de GG 
            tt-seguimiento.tt-imprepo      = lqCostoReposicion /*fimpTot('O/D','CRP')  */
            tt-seguimiento.tt-impkard      = lqCostoKardex /*fimpTot('O/D','CKR')  */
            */
            /* PreChequeo */
            tt-seguimiento.tt-finiprechq = od_Faccpedi.fecsac
            tt-seguimiento.tt-Hiniprechq = od_Faccpedi.horsac
            tt-seguimiento.tt-ffinprechq = IF (NUM-ENTRIES(od_FacCPedi.Libre_c03,"|") > 1) THEN SUBSTRING(ENTRY(2,od_FacCPedi.Libre_c03,"|"),1,10) ELSE ""
            tt-seguimiento.tt-hfinprechq = IF (NUM-ENTRIES(od_FacCPedi.Libre_c03,"|") > 1) THEN SUBSTRING(ENTRY(2,od_FacCPedi.Libre_c03,"|"),12,8) ELSE ""
            /* Envio a Distribucion */
            tt-seguimiento.tt-fhimp    = od_faccpedi.fchimpOD
            tt-seguimiento.tt-fdistr   = DATETIME(fchDistribucion(od_faccpedi.coddoc))
            /* Chequeo */
            tt-seguimiento.tt-bultos   = x-bultos   /*IF(AVAILABLE ccbcbult) THEN ccbcbult.bultos ELSE 0*/
            tt-seguimiento.tt-frotula  = IF(AVAILABLE ccbcbult) THEN ccbcbult.fchdoc ELSE tt-frotula
            tt-seguimiento.tt-finicheq = x-fecha-inicio /*IF(AVAILABLE ccbcbult) THEN ccbcbult.dte_01 ELSE tt-finicheq*/
            tt-seguimiento.tt-hinicheq = x-hora-inicio /*IF(AVAILABLE ccbcbult) THEN Ccbcbult.CHR_04 ELSE ""*/
            tt-seguimiento.tt-ffincheq = x-fecha-fin /*IF(AVAILABLE ccbcbult) THEN Ccbcbult.dte_02 ELSE tt-ffincheq*/
            tt-seguimiento.tt-hfincheq = x-hora-fin /*IF(AVAILABLE ccbcbult) THEN ccbcbult.CHR_03 ELSE tt-hinicheq*/
            tt-seguimiento.tt-lugent    = od_faccpedi.lugent
            tt-seguimiento.tt-glosa     = replace(od_faccpedi.glosa,";"," ").

            IF tt-seguimiento.tt-usrasgord <> "" THEN lSituacion = "ASIGNADO".
            IF NUM-ENTRIES(od_FacCPedi.Libre_c03,"|") > 1 THEN lSituacion = "PRE-PICKEADO".
            IF tt-seguimiento.tt-fdistr <> ? THEN lSituacion = "IMPRESO".
            IF (od_faccpedi.fchchq <> ?) THEN lSituacion = "PICKEADO".

            IF od_faccpedi.EmpaqEsp = YES THEN DO:
                /* INICIO DE EMBALAJE */
                x-fecha-fin = 12/31/2100.
                x-hora-fin = "".
                FOR EACH vtacdocu NO-LOCK WHERE vtacdocu.codcia = s-codcia AND 
                        vtacdocu.codref = od_faccpedi.coddoc AND
                        vtacdocu.nroref = od_faccpedi.nroped :
                        IF vtacdocu.codped <> 'HPK' THEN NEXT.
                        IF vtacdocu.flgest = 'A' THEN NEXT.
                    FIND FIRST logtrkDocs WHERE logtrkDocs.codcia = s-codcia AND 
                        logtrkDocs.coddoc = vtacdocu.codped AND
                        logtrkDocs.nrodoc = vtacdocu.nroped AND 
                        logtrkDocs.clave = 'TRCKHPK' AND
                        logtrkDocs.codigo = 'CK_EM' NO-LOCK NO-ERROR.
                    IF AVAILABLE logtrkDocs THEN DO:
                        IF DATE(logtrkDocs.fecha) < x-fecha-fin THEN DO:
                            x-fecha-fin = DATE(logtrkDocs.fecha).
                            x-hora-fin = SUBSTRING(STRING(logtrkdocs.fecha,"99/99/9999 HH:MM:SS"),12,10).
                        END.
                    END.
                END.
                IF x-fecha-fin <> 12/31/2100 THEN DO:
                    ASSIGN tt-seguimiento.tt-finiemba = x-fecha-fin
                            tt-seguimiento.tt-hiniemba = x-hora-fin.
                END.
                /* Ic FIN DE EMBALAJE- 10Dic2021 - Embalado, busco el HPKs de la O/D */
                x-fecha-fin = 01/01/1900.
                x-hora-fin = "".
                FOR EACH vtacdocu NO-LOCK WHERE vtacdocu.codcia = s-codcia AND 
                        vtacdocu.codref = od_faccpedi.coddoc AND
                        vtacdocu.nroref = od_faccpedi.nroped :
                        IF vtacdocu.codped <> 'HPK' THEN NEXT.
                        IF vtacdocu.flgest = 'A' THEN NEXT.
                    FIND FIRST ChkTareas WHERE ChkTareas.codcia = s-codcia AND 
                        ChkTareas.coddiv = od_faccpedi.divdes AND
                        ChkTareas.coddoc = vtacdocu.codped AND 
                        chkTareas.nroped = vtacdocu.nroped NO-LOCK NO-ERROR.
                    IF AVAILABLE ChkTareas AND ChkTareas.fechafin <> ? THEN DO:
                        IF ChkTareas.fechafin > x-fecha-fin THEN DO:
                            x-fecha-fin = ChkTareas.fechafin.
                            x-hora-fin = ChkTareas.horafin.
                        END.
                    END.
                END.
                IF x-fecha-fin <> 01/01/1900 THEN DO:
                    ASSIGN tt-seguimiento.tt-ffinemba = x-fecha-fin
                            tt-seguimiento.tt-hfinemba = x-hora-fin.
                END.
            END.
    END.
    WHEN "DOCUMENTO" THEN DO:
        /* Generacion del Comprobante */
        ASSIGN tt-seguimiento.tt-cdoc  = ccbcdocu.coddoc
            tt-seguimiento.tt-ndoc     = ccbcdocu.nrodoc
            tt-seguimiento.tt-xfemi    = ccbcdocu.fchdoc
            tt-seguimiento.tt-xhemi    = ccbcdocu.horcie
            tt-seguimiento.tt-dircli   = ccbcdocu.dircli
            tt-seguimiento.tt-divori   = ccbcdocu.coddiv.

        ASSIGN  tt-seguimiento.tt-lugent    = IF NOT (TRUE <> (ccbcdocu.lugent > "") ) THEN ccbcdocu.lugent ELSE tt-seguimiento.tt-lugent
                tt-seguimiento.tt-glosa     = IF NOT (TRUE <> (ccbcdocu.glosa > "") ) THEN ccbcdocu.glosa ELSE tt-seguimiento.tt-glosa
                tt-seguimiento.tt-glosa     = REPLACE(tt-seguimiento.tt-glosa,";"," ").       

        /* Ic - 09Dic2021  */
        FOR EACH Almcmov NO-LOCK WHERE Almcmov.codcia = s-codcia AND
            Almcmov.codref = Ccbcdocu.coddoc AND
            Almcmov.nroref = Ccbcdocu.nrodoc:
            IF almcmov.tipmov = 'I' AND almcmov.codmov = 09 AND almcmov.flgest <> "A" THEN DO:
                ASSIGN 
                    tt-seguimiento.tt-fini_pi = almcmov.fchdoc
                    tt-seguimiento.tt-hini_pi = almcmov.horrcp.
                LEAVE.
            END.
        END.
        lSituacion = "EMISION DE COMPROBANTE".
    END.
    WHEN "GUIAREMISION" THEN DO:
        /* Generacion de la G/R */
        ASSIGN tt-seguimiento.tt-docremi   = gr_ccbcdocu.coddoc
               tt-seguimiento.tt-nroremi   = gr_ccbcdocu.nrodoc
               tt-seguimiento.tt-dircli    = gr_ccbcdocu.dircli
               tt-seguimiento.tt-divori    = gr_ccbcdocu.coddiv.

        ASSIGN tt-seguimiento.tt-lugent    = IF NOT (TRUE <> (gr_ccbcdocu.lugent > "") ) THEN gr_ccbcdocu.lugent ELSE tt-seguimiento.tt-lugent
               tt-seguimiento.tt-glosa     = IF NOT (TRUE <> (gr_ccbcdocu.glosa > "") ) THEN gr_ccbcdocu.glosa ELSE tt-seguimiento.tt-glosa
               tt-seguimiento.tt-glosa = REPLACE(tt-seguimiento.tt-glosa,";"," ").

           lSituacion = "EMISION DE COMPROBANTE y GUIA REMISION".
    END.
    WHEN "HRUTA" THEN DO:
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
    END.
    WHEN "VIGISALIDA" THEN DO:
        /* Salida/dev mercaderia segun vigilancia */
        /*
        ASSIGN tt-seguimiento.tt-fchsalvig = almdcdoc.fecha
                tt-seguimiento.tt-horsalvig = almdcdoc.hora.
        */
        lSituacion = "HOJA DE RUTA EN RUTA".        

        FIND FIRST TraIngSal WHERE TraIngSal.codcia = 1 AND TraIngSal.coddiv = tt-seguimiento.tt-divori AND
                                    TraIngSal.placa = tt-seguimiento.tt-placa AND TraIngSal.nrodoc = tt-seguimiento.tt-hruta NO-LOCK NO-ERROR.
        IF AVAILABLE TraIngSal THEN DO:
            ASSIGN tt-seguimiento.tt-fchsalvig = TraIngSal.fechasalida
                    tt-seguimiento.tt-horsalvig = TraIngSal.horasalida.
        END.
    END.
    WHEN "VIGIDEVOL" THEN DO:
        /* Salida/dev mercaderia segun vigilancia */
        /*
        ASSIGN tt-seguimiento.tt-fchdevvig = almrcdoc.fecha
            tt-seguimiento.tt-hordevvig = almrcdoc.hora.
        */
        lSituacion = "HOJA DE RUTA RETORNADA".
        IF TRIM(tt-seguimiento.tt-hretornoHR) <> "" AND TRIM(tt-seguimiento.tt-hretornoHR)<> ":" THEN lSituacion = "HOJA DE RUTA CERRADA".

        FIND FIRST TraIngSal WHERE TraIngSal.codcia = 1 AND TraIngSal.coddiv = tt-seguimiento.tt-divori AND
                                    TraIngSal.placa = tt-seguimiento.tt-placa AND TraIngSal.nrodoc = tt-seguimiento.tt-hruta NO-LOCK NO-ERROR.
        IF AVAILABLE TraIngSal THEN DO:
            ASSIGN tt-seguimiento.tt-fchdevvig = TraIngSal.fecharetorno
                    tt-seguimiento.tt-hordevvig = TraIngSal.horaretorno.
        END.

    END.
END CASE.

lFiler = "".
RUN lib/limpiar-texto(tt-seguimiento.tt-glosa," ", OUTPUT lFiler).

ASSIGN tt-seguimiento.tt-situacion = lSituacion
        tt-seguimiento.tt-glosa = lFiler.

lFiler = "".
RUN lib/limpiar-texto(tt-seguimiento.tt-dircli," ", OUTPUT lFiler).
ASSIGN tt-seguimiento.tt-dircli = lFiler.
lFiler = "".
RUN lib/limpiar-texto(tt-seguimiento.tt-lugent," ", OUTPUT lFiler).
ASSIGN tt-seguimiento.tt-lugent = lFiler.
lFiler = "".
RUN lib/limpiar-texto(tt-seguimiento.tt-direccTransporte," ", OUTPUT lFiler).
ASSIGN tt-seguimiento.tt-direccTransporte = lFiler.
lFiler = "".
RUN lib/limpiar-texto(tt-seguimiento.tt-lugarentrega," ", OUTPUT lFiler).
ASSIGN tt-seguimiento.tt-lugarentrega = lFiler.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-grabar-mov-otr W-Win 
PROCEDURE ue-grabar-mov-otr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
DEFINE INPUT PARAMETER p-Fase AS CHAR.

DEFINE VAR lSituacion AS CHAR INIT "".

DEFINE VAR x-bultos AS INT.
DEFINE VAR x-fecha-inicio AS DATE.
DEFINE VAR x-hora-inicio AS CHAR.
DEFINE VAR x-fecha-fin AS DATE.
DEFINE VAR x-hora-fin AS CHAR.
DEFINE VAR x-fecha-asg AS DATE.
DEFINE VAR x-hora-asg AS CHAR.
DEFINE VAR x-usr-asg AS CHAR.

DEFINE BUFFER b-almacen FOR almacen.
DEFINE BUFFER z-almacen FOR almacen.
/*
DEFINE VAR x-fecha-fin AS DATE.
DEFINE VAR x-hora-fin AS CHAR.
*/

IF p-Fase = 'PEDIDO' THEN DO:    

    FIND FIRST b-almacen WHERE b-almacen.codcia = s-codcia AND 
                                b-almacen.codalm = almcrepo.codalm
                                NO-LOCK NO-ERROR.

    ASSIGN /* PEDIDO */
        tt-seguimiento.tt-codped       = 'R/A'
        tt-seguimiento.tt-nroped       = STRING(almcrepo.nroser,"999") + STRING(almcrepo.nrodoc,"999999999")
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

        x-bultos = 0.
        x-fecha-inicio = ?.
        x-fecha-fin = ?.
        x-hora-inicio = "".
        x-hora-fin = "".

        x-fecha-inicio = od_Faccpedi.fecsac.
        x-hora-inicio = od_Faccpedi.horsac.
        x-fecha-fin = od_Faccpedi.fchchq. 
        x-hora-fin = od_Faccpedi.horchq.

        FOR EACH ccbcbult NO-LOCK WHERE ccbcbult.codcia = s-codcia AND
                ccbcbult.coddoc = od_faccpedi.coddoc AND 
                ccbcbult.nrodoc = od_faccpedi.nroped:
            x-bultos = x-bultos + ccbcbult.bultos.
        END.
        /* CASO PICKING X RUTA */
        /* Inicio de chequeo */
        INICIOCHEQUEO:
        FOR EACH vtacdocu NO-LOCK WHERE vtacdocu.codcia = s-codcia AND 
                vtacdocu.codref = od_faccpedi.coddoc AND
                vtacdocu.nroref = od_faccpedi.nroped
                BY vtacdocu.fecsac BY vtacdocu.horsac :

                IF vtacdocu.codped <> 'HPK' THEN NEXT.
                IF vtacdocu.flgest = 'A'  THEN NEXT.
                
            x-fecha-asg = DATE(Vtacdocu.fchinicio).
            x-hora-asg = ENTRY(2,STRING(Vtacdocu.fchinicio,"99/99/9999 hh:mm:ss")," ").
            x-usr-asg = Vtacdocu.usrsacasign.

            x-fecha-inicio = vtacdocu.fecsac.
            x-hora-inicio = vtacdocu.horsac.
            
            LEAVE INICIOCHEQUEO.
        END.

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
        tt-seguimiento.tt-usrasgord    = x-usr-asg
        tt-seguimiento.tt-fchasgord    = x-fecha-asg
        tt-seguimiento.tt-horasgord    = x-hora-asg
        tt-seguimiento.tt-qitms        = lqItems
        tt-seguimiento.tt-peso         = lqPeso
        tt-seguimiento.tt-volumen      = lqVolumen
        tt-seguimiento.tt-imptot       = lqCostoVenta /*fimpTot('O/D','VNT')  /*ccbcdocu.imptot*/*/
        /*  02Feb2023, Se retiro a pedido de Susana, Orden de GG 
        tt-seguimiento.tt-imprepo      = lqCostoReposicion /*fimpTot('O/D','CRP')  */
        tt-seguimiento.tt-impkard      = lqCostoKardex /*fimpTot('O/D','CKR')  */
        */
        /* PreChequeo */
        tt-seguimiento.tt-finiprechq = od_Faccpedi.fecsac
        tt-seguimiento.tt-Hiniprechq = od_Faccpedi.horsac
        tt-seguimiento.tt-ffinprechq = IF (NUM-ENTRIES(od_FacCPedi.Libre_c03,"|") > 1) THEN SUBSTRING(ENTRY(2,od_FacCPedi.Libre_c03,"|"),1,10) ELSE ""
        tt-seguimiento.tt-hfinprechq = IF (NUM-ENTRIES(od_FacCPedi.Libre_c03,"|") > 1) THEN SUBSTRING(ENTRY(2,od_FacCPedi.Libre_c03,"|"),12,8) ELSE ""
        /* Envio a Distribucion */
        tt-seguimiento.tt-fhimp    = od_faccpedi.fchimpOD
        tt-seguimiento.tt-fdistr   = datetime(fchDistribucion(od_faccpedi.coddoc))
        /* Chequeo */
        tt-seguimiento.tt-bultos   = x-bultos  /*IF(AVAILABLE ccbcbult) THEN ccbcbult.bultos ELSE 0*/
        tt-seguimiento.tt-frotula  = IF(AVAILABLE ccbcbult) THEN ccbcbult.fchdoc ELSE tt-frotula
        tt-seguimiento.tt-finicheq = IF(AVAILABLE ccbcbult) THEN ccbcbult.dte_01 ELSE tt-finicheq
        tt-seguimiento.tt-hinicheq = IF(AVAILABLE ccbcbult) THEN Ccbcbult.CHR_04 ELSE ""
        tt-seguimiento.tt-ffincheq = IF(AVAILABLE ccbcbult) THEN Ccbcbult.dte_02 ELSE tt-ffincheq
        tt-seguimiento.tt-hfincheq = IF(AVAILABLE ccbcbult) THEN ccbcbult.CHR_03 ELSE tt-hinicheq.

        IF tt-seguimiento.tt-usrasgord <> "" THEN lSituacion = "ASIGNADO".
        IF NUM-ENTRIES(od_FacCPedi.Libre_c03,"|") > 1 THEN lSituacion = "PRE-PICKEADO".
        IF tt-seguimiento.tt-fdistr <> ? THEN lSituacion = "IMPRESO".
        IF (od_faccpedi.fchchq <> ?) THEN lSituacion = "PICKEADO".

        /* Ic - 10Dic2021 - Embalado, busco el HPK */
        /*   Segun Max no hay EMBALADO ESPECIAL en OTR
        x-fecha-fin = 01/01/1900.
        x-hora-fin = "".

        FOR EACH vtacdocu WHERE vtacdocu.codcia = s-codcia AND vtacdocu.codref = od_faccpedi.coddoc AND
                                    vtacdocu.nroref = od_faccpedi.nroped AND 
                                    vtacdocu.codped = 'HPK' AND vtacdocu.flgest <> 'A'  NO-LOCK:
            FIND FIRST logtrkDocs WHERE logtrkDocs.codcia = s-codcia AND logtrkDocs.coddoc = vtacdocu.codped AND
                                        logtrkDocs.nrodoc = vtacdocu.nroped AND logtrkDocs.clave = 'TRCKHPK' AND
                                        logtrkDocs.codigo = 'CK_EM' NO-LOCK NO-ERROR.
            IF AVAILABLE logtrkDocs THEN DO:
                IF DATE(logtrkDocs.fecha) > x-fecha-fin THEN DO:
                    x-fecha-fin = DATE(logtrkDocs.fecha).
                    x-hora-fin = SUBSTRING(STRING(logtrkdocs.fecha,"99/99/9999 HH:MM:SS"),12,10).
                END.
            END.
        END.
        IF x-fecha-fin <> 01/01/1900 THEN DO:
            ASSIGN tt-seguimiento.tt-ffinemba = x-fecha-fin
                    tt-seguimiento.tt-hfinemba = x-hora-fin.
        END.
        */
END.
IF p-Fase = 'DOCUMENTO' THEN DO:
    /* Generacion del Comprobante */
    ASSIGN tt-seguimiento.tt-cdoc     = "ALM"
        tt-seguimiento.tt-ndoc     = String(almcmov.nroser,"999") + String(almcmov.nrodoc,"99999999")
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
    /*
    ASSIGN tt-seguimiento.tt-fchsalvig = almdcdoc.fecha
            tt-seguimiento.tt-horsalvig = almdcdoc.hora.
    */
    lSituacion = "HOJA DE RUTA EN RUTA".
    IF TRIM(tt-seguimiento.tt-hretornoHR) <> "" AND TRIM(tt-seguimiento.tt-hretornoHR)<> ":" THEN lSituacion = "HOJA DE RUTA CERRADA".
    FIND FIRST TraIngSal WHERE TraIngSal.codcia = 1 AND TraIngSal.coddiv = tt-seguimiento.tt-divori AND
                                TraIngSal.placa = tt-seguimiento.tt-placa AND TraIngSal.nrodoc = tt-seguimiento.tt-hruta NO-LOCK NO-ERROR.
    IF AVAILABLE TraIngSal THEN DO:
        ASSIGN tt-seguimiento.tt-fchsalvig = TraIngSal.fechasalida
                tt-seguimiento.tt-horsalvig = TraIngSal.horasalida.
    END.
END.
IF p-Fase = 'VIGIDEVOL' THEN DO:
    /* Salida/dev mercaderia segun vigilancia */
    /*
    ASSIGN tt-seguimiento.tt-fchdevvig = almrcdoc.fecha
        tt-seguimiento.tt-hordevvig = almrcdoc.hora.
    */
    lSituacion = "HOJA DE RUTA RETORNADA".
    FIND FIRST TraIngSal WHERE TraIngSal.codcia = 1 AND TraIngSal.coddiv = tt-seguimiento.tt-divori AND
                                TraIngSal.placa = tt-seguimiento.tt-placa AND TraIngSal.nrodoc = tt-seguimiento.tt-hruta NO-LOCK NO-ERROR.
    IF AVAILABLE TraIngSal THEN DO:
        ASSIGN tt-seguimiento.tt-fchdevvig = TraIngSal.fecharetorno
                tt-seguimiento.tt-hordevvig = TraIngSal.horaretorno.
    END.

END.

ASSIGN tt-seguimiento.tt-situacion = lSituacion.

*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-grabar-mov-tra W-Win 
PROCEDURE ue-grabar-mov-tra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
DEFINE INPUT PARAMETER p-Fase AS CHAR.

DEFINE VAR lSituacion AS CHAR INIT "".

DEFINE BUFFER z-almacen FOR almacen.

IF p-Fase = 'PEDIDO' THEN DO:

    FIND FIRST z-almacen WHERE z-almacen.codcia = s-codcia AND 
                                z-almacen.codalm = almcmov.codalm
                                NO-LOCK NO-ERROR.

    ASSIGN /* PEDIDO */
        tt-seguimiento.tt-codped       = 'TRA'
        tt-seguimiento.tt-nroped       = STRING(almcmov.nroser,"999") + STRING(almcmov.nrodoc,"99999999")
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
        tt-seguimiento.tt-nroord       = STRING(almcmov.nroser,"999") + STRING(almcmov.nrodoc,"99999999")
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
        /*  02Feb2023, Se retiro a pedido de Susana, Orden de GG 
        tt-seguimiento.tt-imprepo      = lqCostoReposicion /*fimpTot('O/D','CRP')  */
        tt-seguimiento.tt-impkard      = lqCostoKardex /*fimpTot('O/D','CKR')  */
        */
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
        tt-seguimiento.tt-ndoc     = String(almcmov.nroser,"999") + String(almcmov.nrodoc,"99999999")
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
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-importes W-Win 
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

IF pDoc = 'TRA' THEN DO:
    FOR EACH bi-facdpedi OF od_faccpedi NO-LOCK, FIRST almmmatg OF bi-facdpedi NO-LOCK :
        lTCambio = 1.
        IF almmmatg.monvta = 2 THEN DO:
            /* Dolares */
            lTCambio = Almmmatg.tpocmb.
        END.
        lCostoVenta = lCostoVenta + ((Almmmatg.preofi * lTCambio) * bi-facdpedi.canped).
        /*  02Feb2023, Se retiro a pedido de Susana, Orden de GG 
        lCostoReposicion = lCostoReposicion + ((Almmmatg.ctotot * lTCambio) * b-facdpedi.canped).
        FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia
            AND AlmStkGe.codmat = Almmmatg.codmat
            AND AlmStkGe.fecha <= TODAY NO-LOCK NO-ERROR.
        IF AVAILABLE AlmStkGe THEN lCostoKardex = lCostoKardex + ((AlmStkge.CtoUni * lTCambio) * b-facdpedi.canped).
        */
    END.
END.
ELSE DO:
    FOR EACH bi-facdpedi OF od_faccpedi NO-LOCK, FIRST almmmatg OF bi-facdpedi NO-LOCK :
        lTCambio = 1.
        IF od_faccpedi.codmon = 2 THEN DO:
            /* Dolares */
            lTCambio = od_faccpedi.tpocmb.
        END.
        lCostoVenta = lCostoVenta + ((bi-facdpedi.implin * lTCambio)).
        /*  02Feb2023, Se retiro a pedido de Susana, Orden de GG 
        lCostoReposicion = lCostoReposicion + ((Almmmatg.ctotot * lTCambio) * b-facdpedi.canped).
        FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia
            AND AlmStkGe.codmat = Almmmatg.codmat
            AND AlmStkGe.fecha <= TODAY NO-LOCK NO-ERROR.
        IF AVAILABLE AlmStkGe THEN lCostoKardex = lCostoKardex + ((AlmStkge.CtoUni * lTCambio) * b-facdpedi.canped).
        */
    END.
END.
pCostoVenta = lCostoVenta.
pCostoReposicion = lCostoReposicion.
pCostoKardex = lCostoKardex.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-item-peso W-Win 
PROCEDURE ue-item-peso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pTipo AS CHAR.
DEFINE OUTPUT PARAMETER pqItems AS INT.
DEFINE OUTPUT PARAMETER pqPeso AS DEC.
DEFINE OUTPUT PARAMETER pqVolumen AS DEC.

DEFINE VAR i AS INT.
DEFINE VAR lPeso AS DEC.
DEFINE VAR lVol AS DEC.

i = 0.
lVol = 0.

/*DEFINE BUFFER b-facdpedi FOR facdpedi.*/

IF pTipo = 'O/D' OR pTipo = 'DOC' THEN DO:
    DEFINE BUFFER bi-ccbddocu FOR ccbddocu.
    IF pTipo = 'O/D' THEN DO:
        FOR EACH bi-facdpedi OF od_faccpedi NO-LOCK, FIRST almmmatg OF bi-facdpedi NO-LOCK :
            i = i + 1.
            IF almmmatg.pesmat <> ? AND almmmatg.pesmat > 0 THEN lPeso = lPeso + ( (bi-facdpedi.canped * bi-facdpedi.factor ) * almmmatg.pesmat).
            IF almmmatg.libre_d02 <> ? AND almmmatg.libre_d02 > 0 THEN lVol = lVol + ( (bi-facdpedi.canped * bi-facdpedi.factor ) * almmmatg.libre_d02 / 1000000 ). 
        END.
    END.
    ELSE DO:
        FOR EACH bi-ccbddocu OF ccbcdocu NO-LOCK, FIRST almmmatg OF bi-ccbddocu NO-LOCK :
            i = i + 1.
            IF almmmatg.pesmat <> ? AND almmmatg.pesmat > 0 THEN lPeso = lPeso + ( (bi-ccbddocu.candes * bi-ccbddocu.factor ) * almmmatg.pesmat).
            IF almmmatg.libre_d02 <> ? AND almmmatg.libre_d02 > 0 THEN lVol = lVol + ( (bi-ccbddocu.candes * bi-ccbddocu.factor ) * almmmatg.libre_d02 / 1000000 ). 
        END.
    END.
END.
ELSE DO:
    FOR EACH bi-facdpedi OF od_faccpedi NO-LOCK, FIRST almmmatg OF bi-facdpedi NO-LOCK :
        i = i + 1.
        IF almmmatg.pesmat <> ? AND almmmatg.pesmat > 0 THEN lPeso = lPeso + ( (bi-facdpedi.canped * bi-facdpedi.factor ) * almmmatg.pesmat).
        IF almmmatg.libre_d02 <> ? AND almmmatg.libre_d02 > 0 THEN lVol = lVol + ( (bi-facdpedi.canped * bi-facdpedi.factor ) * almmmatg.libre_d02 / 1000000 ). 
    END.
END.
pqItems = i.
pqPeso = lPeso.
pqVolumen = lVol.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-ordenes-transferencias W-Win 
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

FOR EACH almcrepo NO-LOCK WHERE almcrepo.codcia = s-codcia AND 
        almcrepo.fchdoc >= txtDesde AND 
        almcrepo.fchdoc <= txtHasta:
    IF Almcrepo.flgest = "A" THEN NEXT.

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
    FIND FIRST almacen WHERE almacen.codcia = s-codcia AND almacen.codalm = lDist NO-LOCK NO-ERROR.
    IF AVAILABLE almacen THEN lDestino = almacen.campo-c[8].

    FIND FIRST almacen WHERE almacen.codcia = s-codcia AND almacen.codalm = lOrigen NO-LOCK NO-ERROR.
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

    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
        "REPOSICIONES: Tipo " + Almcrepo.tipmov + " " + STRING(almcrepo.nroser,"999") + " " +  STRING(almcrepo.nrodoc,"999999").
    /*
    DISPLAY "REPOSICIONES: Tipo " + Almcrepo.tipmov + " " + STRING(almcrepo.nroser,"999") + " " +  STRING(almcrepo.nrodoc,"999999")
        @ Fi-Mensaje WITH FRAME F-Proceso.*/

    /* Sus Ordenes (OTR) */
    FOR EACH od_faccpedi NO-LOCK WHERE od_faccpedi.codcia = almcrepo.codcia AND 
            od_faccpedi.codref = 'R/A' AND
            od_faccpedi.nroref = lNroRepoAuto AND 
            od_faccpedi.coddoc = 'OTR' AND 
            od_faccpedi.flgest <> 'A':
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
            "REPOSICIONES: Tipo " + Almcrepo.tipmov + " " + STRING(almcrepo.nroser,"999") + " " +  STRING(almcrepo.nrodoc,"999999") + " " +
            od_faccpedi.coddoc + " - " + od_faccpedi.nroped.
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
            RUN ue-Importes ('TRA',OUTPUT lqCostoVenta, OUTPUT lqCostoReposicion, OUTPUT lqCostoKardex).
        END.
        
        /**/
        lqItems = 0.
        lqPeso = 0.
        lqVolumen = 0.
        IF ChkbxResumen = NO THEN DO:
            lqItems = od_faccpedi.items.
            lqPeso = od_faccpedi.peso.
            lqVolumen = od_faccpedi.volumen.
            /*RUN ue-item-peso("TRN", OUTPUT lqItems, OUTPUT lqPeso, OUTPUT lqVolumen).*/
        END.        

        /* Buscar los movimientos de Almacen */
        lTieneGRs = NO.
        FOR EACH almcmov NO-LOCK WHERE almcmov.codcia = s-codcia AND 
                almcmov.codref = od_faccpedi.coddoc AND
                almcmov.nroref = od_faccpedi.nroped :

                IF almcmov.flgest = 'A' THEN NEXT.

                IF NOT (almcmov.codalm = od_faccpedi.codalm AND almcmov.tipmov = "S" AND almcmov.codmov = 03) THEN NEXT.

        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
            "REPOSICIONES: Tipo " + Almcrepo.tipmov + " " + STRING(almcrepo.nroser,"999") + " " +  STRING(almcrepo.nrodoc,"999999") + " " +
            od_faccpedi.coddoc + " - " + od_faccpedi.nroped + " / MOV.ALM" .
            
            lTieneGRs = YES.
            lTieneHRs = NO.
            /* Buscar el Documento (G/R) en la HR */
            FOR EACH di-RutaG NO-LOCK WHERE di-RutaG.codcia = s-codcia AND 
                        di-RutaG.coddoc = 'H/R' AND 
                        di-RutaG.codalm = almcmov.codalm AND
                        di-RutaG.tipmov = 'S' AND
                        di-RutaG.codmov = 03 AND
                        di-RutaG.serref = almcmov.nroser AND 
                        di-RutaG.NroRef = almcmov.nrodoc, 
                FIRST di-rutaC OF di-rutaG NO-LOCK WHERE di-RutaC.flgest <> 'A':
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
                /*
                FIND FIRST almdcdoc WHERE almdcdoc.codcia = s-codcia AND 
                    almdcdoc.coddoc = 'G/R' AND
                    almdcdoc.nrodoc = lNroDoctoHR NO-LOCK NO-ERROR.
                IF AVAILABLE almdcdoc  THEN DO:
                    RUN ue-grabar-mov-otr(INPUT "VIGISALIDA").
                END.
                */
                RUN ue-grabar-mov-otr(INPUT "VIGISALIDA").

                /* Buscar si vigilancia registro devoluciones*/
                /*
                FIND FIRST almRCdoc WHERE almRCdoc.codcia = s-codcia AND 
                    almRCdoc.coddoc = 'G/R' AND
                    almRCdoc.nrodoc = lNroDoctoHR NO-LOCK NO-ERROR.
                IF AVAILABLE almRCdoc  THEN DO:
                    RUN ue-grabar-mov-otr(INPUT "VIGIDEVOL").
                END.                
                */

                RUN ue-grabar-mov-otr(INPUT "VIGIDEVOL").
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
HIDE FRAME F-Proceso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-transferencias-manuales W-Win 
PROCEDURE ue-transferencias-manuales :
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
                (almcmov.fchdoc >= txtDesde AND almcmov.fchdoc <= txtHasta) AND 
                almcmov.codref = '' AND                 
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
        /* Bultos de la O/D ???? */
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
            lqItems = 0.
            lqPeso = 0.
            lqVolumen = 0.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-ventas W-Win 
PROCEDURE ue-ventas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lValidaEnTxt AS LOG.

lqCostoVenta = 0.
lqCostoReposicion = 0.
lqCostoKardex = 0.
/* */
lqItems = 0.
lqPeso = 0.
lqVolumen = 0.

EMPTY TEMP-TABLE tt-txtfile.
IF NOT TRUE <> (txtfile > "") THEN DO:
    DEFINE VAR x-texto AS CHAR.

    INPUT FROM VALUE(txtfile).

    REPEAT:
        IMPORT x-texto.
        FIND FIRST tt-txtfile WHERE tt-txtfile.tt-orden = x-texto NO-LOCK NO-ERROR.
        IF NOT AVAILABLE tt-txtfile THEN DO:
            CREATE tt-txtfile.
            ASSIGN tt-txtfile.tt-orden = x-texto.
    
            FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                                        faccpedi.coddoc = 'O/D' AND 
                                        faccpedi.nroped = x-texto NO-LOCK NO-ERROR.
            IF AVAILABLE faccpedi THEN DO:
                ASSIGN tt-txtfile.tt-pedido = faccpedi.nroped.
            END.
        END.
    END.
    INPUT CLOSE.
END.

DEFINE VAR cFlags AS CHAR.
DEFINE VAR cFlag AS CHAR.
DEFINE VAR iSec AS INT.

DEFINE VAR cTabla AS CHAR.
DEFINE VAR cLlave_c1 AS CHAR.
DEFINE VAR cLlave_c2 AS CHAR.
DEFINE VAR cLlave_c3 AS CHAR INIT "".

cTabla = "CONFIG-VTAS".
cLlave_c1 = "PEDIDO.COMERCIAL".
cLlave_c2 = "FLGEST".
cLlave_c3 = "".

cFlags = "PV,P,C,V,X,PA".

FIND FIRST vtatabla WHERE vtatabla.codcia = 1 AND vtatabla.tabla = cTabla AND
                            vtatabla.Llave_C1 = cLlave_c1 AND vtatabla.Llave_c2 = cLlave_c2 AND
                            vtatabla.Llave_c3 = cLlave_c3 NO-LOCK NO-ERROR.

IF AVAILABLE vtatabla THEN DO:
    IF NOT (TRUE <> (vtatabla.Llave_C4 > "")) THEN cFlags = TRIM(vtatabla.Llave_C4).
END.

EMPTY TEMP-TABLE tt-control.
/*
REPEAT iSec = 1 TO NUM-ENTRIES(cFlags,","):
    cFlag = ENTRY(iSec,cFlags,",").

    IF cFlag = 'A' THEN NEXT.   /* No anulados */

    RUN ue_ventas_proceso(cFlag).

END.
*/
REPEAT iSec = 1 TO NUM-ENTRIES(cFlags,","):
    cFlag = ENTRY(iSec,cFlags,",").
    
    IF cFlag = 'A' THEN NEXT.   /* No anulados */   
    
    FOR EACH y-gn-divi WHERE y-gn-divi.codcia = s-codcia AND (txtCodDivi = "" OR y-gn-divi.coddiv = txtCodDivi) NO-LOCK,
        EACH pcfaccpedi NO-LOCK WHERE pcfaccpedi.codcia = s-codcia AND 
                pcfaccpedi.divdes = y-gn-divi.coddiv AND
                pcfaccpedi.coddoc = 'COT' AND 
                pcFaccpedi.flgest = cFlag AND 
                pcfaccpedi.fchped >= txtDesde /*AND 
                faccpedi.fchped <= txtHasta*/ ,
                FIRST gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = pcfaccpedi.codcli NO-LOCK :

        IF pcfaccpedi.fchped > txtHasta THEN NEXT.

        /* Adiciono registro */
        CREATE tt-seguimiento.
        RUN ue-grabar-mov(INPUT "PEDIDOCOMERCIAL").

        RUN ue_ventas_proceso(pcfaccpedi.coddoc, pcfaccpedi.nroped).

    END.
END.

HIDE FRAME F-Proceso.

END PROCEDURE.

/*
    FOR EACH x-gn-divi NO-LOCK WHERE x-gn-divi.codcia = s-codcia AND 
            x-gn-divi.campo-log[1] = NO AND
            x-gn-divi.campo-log[5] = YES,  /* Solo CDs */    
        EACH faccpedi NO-LOCK WHERE faccpedi.codcia = s-codcia AND 
                faccpedi.divdes = x-gn-divi.coddiv AND
                faccpedi.coddoc = 'PED' AND 
                Faccpedi.flgest = pFlag AND 
                faccpedi.fchped >= txtDesde /*AND 
                faccpedi.fchped <= txtHasta*/ ,
            FIRST gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = faccpedi.codcli NO-LOCK :
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-ventas-borrar W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-ventas-hoja-de-ruta W-Win 
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

/* Buscar el Documento en la HR */
FOR EACH di-RutaD NO-LOCK WHERE di-RutaD.codcia = s-codcia AND 
            di-RutaD.coddoc = 'H/R' AND 
            di-RutaD.codref = pCodDocRuta AND 
            di-RutaD.NroRef = pNroDocRuta,
    FIRST di-rutaC OF di-rutaD NO-LOCK WHERE di-RutaC.flgest <> 'A':
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

    FIND FIRST gn-prov WHERE gn-prov.codcia = pv-codcia AND gn-prov.codpro = lCodPro NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN lDesPro = gn-prov.nompro.

    /* Adiciono registro */
    /*CREATE tt-seguimiento.*/
    RUN ue-grabar-mov(INPUT "PEDIDO").
    RUN ue-grabar-mov(INPUT "ORDEN").
    RUN ue-grabar-mov(INPUT "DOCUMENTO").
    RUN ue-grabar-mov(INPUT "GUIAREMISION").
    RUN ue-grabar-mov(INPUT "HRUTA").

    /*
    /* Buscar la salida de vigilancia */
    FIND FIRST almdcdoc WHERE almdcdoc.codcia = s-codcia AND 
                                almdcdoc.coddoc = di-RutaD.codref AND
                                almdcdoc.nrodoc = di-RutaD.nroref NO-LOCK NO-ERROR.
    IF AVAILABLE almdcdoc  THEN DO:
        RUN ue-grabar-mov(INPUT "VIGISALIDA").
    END.
    */
    RUN ue-grabar-mov(INPUT "VIGISALIDA").

    /* Buscar si vigilancia registro devoluciones*/
    /*
    FIND FIRST almRCdoc WHERE almRCdoc.codcia = s-codcia AND 
                                almRCdoc.coddoc = di-RutaD.codref AND
                                almRCdoc.nrodoc = di-RutaD.nroref NO-LOCK NO-ERROR.
    IF AVAILABLE almRCdoc  THEN DO:
        RUN ue-grabar-mov(INPUT "VIGIDEVOL").
    END.
    */
    RUN ue-grabar-mov(INPUT "VIGIDEVOL").

    pTieneHR = YES.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-ventas-old W-Win 
PROCEDURE ue-ventas-old :
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

EMPTY TEMP-TABLE tt-txtfile.
IF NOT TRUE <> (txtfile > "") THEN DO:
    DEFINE VAR x-texto AS CHAR.

    INPUT FROM VALUE(txtfile).

    REPEAT:
        IMPORT x-texto.
        FIND FIRST tt-txtfile WHERE tt-txtfile.tt-orden = x-texto NO-LOCK NO-ERROR.
        IF NOT AVAILABLE tt-txtfile THEN DO:
            CREATE tt-txtfile.
            ASSIGN tt-txtfile.tt-orden = x-texto.
    
            FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                                        faccpedi.coddoc = 'O/D' AND 
                                        faccpedi.nroped = x-texto NO-LOCK NO-ERROR.
            IF AVAILABLE faccpedi THEN DO:
                ASSIGN tt-txtfile.tt-pedido = faccpedi.nroped.
            END.
        END.
    END.
    INPUT CLOSE.
END.

EMPTY TEMP-TABLE tt-control.
FOR EACH x-gn-divi NO-LOCK WHERE x-gn-divi.codcia = s-codcia AND 
        x-gn-divi.campo-log[1] = NO AND
        x-gn-divi.campo-log[5] = YES:  /* Solo CDs */
    
    FOR EACH faccpedi NO-LOCK WHERE faccpedi.codcia = s-codcia AND 
            faccpedi.divdes = x-gn-divi.coddiv AND
            faccpedi.coddoc = 'PED' AND 
            faccpedi.fchped >= txtDesde AND 
            faccpedi.fchped <= txtHasta:
        IF Faccpedi.flgest = "A" THEN NEXT.
        IF txtCodDivi > "" AND Faccpedi.coddiv <> txtCodDivi THEN NEXT.
        IF NOT TRUE <> (txtfile > "") THEN DO:
            FIND FIRST tt-txtfile WHERE tt-txtfile.tt-orden = faccpedi.nroped NO-LOCK NO-ERROR.
            IF NOT AVAILABLE tt-txtfile THEN NEXT.
        END.    
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
            "[VENTAS] DIVISION: " + Faccpedi.divdes + " " + Faccpedi.coddoc + " " + Faccpedi.nroped .
        DISPLAY "DIVISION: " + Faccpedi.divdes + " " + Faccpedi.coddoc + " " + Faccpedi.nroped
            @ Fi-Mensaje WITH FRAME F-Proceso.

        /* */
        lDcli = "".
        lDpto = "".
        lProv = "".
        lDist = "".
        lCodpro = "".
        lDesPro = "".
        lDestino = "".

        /* Cliente */
        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = faccpedi.codcli NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            lDCli = gn-clie.nomcli.
            FIND FIRST tabdepto WHERE tabdepto.coddepto = gn-clie.coddept NO-LOCK NO-ERROR.
            IF AVAILABLE tabdepto THEN lDpto = tabdepto.nomdepto.

            FIND FIRST tabprovi WHERE tabprovi.coddepto = gn-clie.coddept AND 
                tabprovi.codprovi = gn-clie.codprov NO-LOCK NO-ERROR.
            IF AVAILABLE tabprovi THEN lProv = tabprovi.nomprovi.

            FIND FIRST tabdistr WHERE tabdistr.coddepto = gn-clie.coddept AND 
                tabdistr.codprovi = gn-clie.codprov AND 
                tabdistr.coddistr = gn-clie.coddist NO-LOCK NO-ERROR.
            IF AVAILABLE tabdistr THEN lDist = tabdistr.nomdistr.
        END.

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
        FOR EACH od_faccpedi NO-LOCK WHERE od_faccpedi.codcia = faccpedi.codcia AND 
            od_faccpedi.codref = faccpedi.coddoc AND
            od_faccpedi.nroref = faccpedi.nroped AND 
            od_faccpedi.coddoc = 'O/D' AND 
            od_faccpedi.flgest <> 'A':
            FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
                "[VENTAS] DIVISION: " + Faccpedi.divdes + " " + Faccpedi.coddoc + " " + Faccpedi.nroped + " " +
                od_faccpedi.coddoc + " " + od_faccpedi.nroped.

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

            /* Importe de la O/D */
            IF ChkbxResumen = NO THEN DO:
                /*RUN ue-Importes('O/D',OUTPUT lqCostoVenta, OUTPUT lqCostoReposicion, OUTPUT lqCostoKardex).*/
                lqCostoVenta = od_faccpedi.imptot.
            END.        
            ELSE DO:
                lqCostoVenta = od_faccpedi.imptot.
            END.

            lqItems = 0.
            lqPeso = 0.
            lqVolumen = 0.
            IF ChkbxResumen = NO THEN DO:
                lqItems = od_faccpedi.items.
                lqPeso = od_faccpedi.peso.
                lqVolumen = od_faccpedi.volumen.
                IF lqItems = 0 OR lqPeso = 0 /*OR lqVolumen = 0*/ THEN DO:
                    RUN ue-item-peso("O/D", OUTPUT lqItems, OUTPUT lqPeso, OUTPUT lqVolumen).
                END.                
            END.

            cDoctos = "FAC,BOL,TCK".
            /* Verificar si la O/D tiene FAIs */
            FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
                ccbcdocu.codped = faccpedi.coddoc AND
                ccbcdocu.nroped = faccpedi.nroped AND 
                ccbcdocu.coddoc = 'FAI' AND 
                ccbcdocu.libre_c01 = od_faccpedi.coddoc AND
                ccbcdocu.libre_c02 = od_faccpedi.nroped AND
                ccbcdocu.flgest <> 'A' NO-LOCK NO-ERROR.
            IF AVAILABLE ccbcdocu THEN cDoctos = "FAI,BOL,TCK".

            /* Buscar los documentos (FAC,BOL,TCK) emitidos por la O/D */
            lTieneGRs = NO.
            FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia AND 
                                    ccbcdocu.codped = faccpedi.coddoc AND
                                    ccbcdocu.nroped = faccpedi.nroped:
                IF NOT ( 
                    LOOKUP(ccbcdocu.coddoc,cDoctos) > 0 AND 
                    ccbcdocu.libre_c01 = od_faccpedi.coddoc AND
                    ccbcdocu.libre_c02 = od_faccpedi.nroped AND
                    ccbcdocu.flgest <> 'A'
                    )
                    THEN NEXT.

                /* Buscar las G/R de la FAC/BOL/TCK */
                FOR EACH gr_ccbcdocu NO-LOCK WHERE gr_ccbcdocu.codcia = s-codcia AND
                                            gr_ccbcdocu.codref = ccbcdocu.coddoc AND
                                            gr_ccbcdocu.nroref = ccbcdocu.nrodoc AND
                                            gr_ccbcdocu.coddoc = 'G/R' :
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
            CREATE tt-seguimiento.
            RUN ue-grabar-mov(INPUT "PEDIDO").
        END.
    END.
END.
HIDE FRAME F-Proceso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-ventas-old2 W-Win 
PROCEDURE ue-ventas-old2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lValidaEnTxt AS LOG.

lqCostoVenta = 0.
lqCostoReposicion = 0.
lqCostoKardex = 0.
/* */
lqItems = 0.
lqPeso = 0.
lqVolumen = 0.

EMPTY TEMP-TABLE tt-txtfile.
IF NOT TRUE <> (txtfile > "") THEN DO:
    DEFINE VAR x-texto AS CHAR.

    INPUT FROM VALUE(txtfile).

    REPEAT:
        IMPORT x-texto.
        FIND FIRST tt-txtfile WHERE tt-txtfile.tt-orden = x-texto NO-LOCK NO-ERROR.
        IF NOT AVAILABLE tt-txtfile THEN DO:
            CREATE tt-txtfile.
            ASSIGN tt-txtfile.tt-orden = x-texto.
    
            FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                                        faccpedi.coddoc = 'O/D' AND 
                                        faccpedi.nroped = x-texto NO-LOCK NO-ERROR.
            IF AVAILABLE faccpedi THEN DO:
                ASSIGN tt-txtfile.tt-pedido = faccpedi.nroped.
            END.
        END.
    END.
    INPUT CLOSE.
END.

DEFINE VAR cFlags AS CHAR.
DEFINE VAR cFlag AS CHAR.
DEFINE VAR iSec AS INT.

DEFINE VAR cTabla AS CHAR.
DEFINE VAR cLlave_c1 AS CHAR.
DEFINE VAR cLlave_c2 AS CHAR.
DEFINE VAR cLlave_c3 AS CHAR INIT "".

cTabla = "CONFIG-VTAS".
cLlave_c1 = "PEDIDOLOGISTICO".
cLlave_c2 = "FLGEST".
cLlave_c3 = "".

cFlags = "G,X,T,W,WX,WL,WC,P,V,F,R,S,C,E,O".

FIND FIRST vtatabla WHERE vtatabla.codcia = 1 AND vtatabla.tabla = cTabla AND
                            vtatabla.Llave_C1 = cLlave_c1 AND vtatabla.Llave_c2 = cLlave_c2 AND
                            vtatabla.Llave_c3 = cLlave_c3 NO-LOCK NO-ERROR.

IF AVAILABLE vtatabla THEN DO:
    IF NOT (TRUE <> (vtatabla.Llave_C4 > "")) THEN cFlags = TRIM(vtatabla.Llave_C4).
END.

EMPTY TEMP-TABLE tt-control.

REPEAT iSec = 1 TO NUM-ENTRIES(cFlags,","):
    cFlag = ENTRY(iSec,cFlags,",").

    IF cFlag = 'A' THEN NEXT.   /* No anulados */

    RUN ue_ventas_proceso(cFlag).

END.

HIDE FRAME F-Proceso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue_ventas_proceso W-Win 
PROCEDURE ue_ventas_proceso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodPedidoComercial AS CHAR NO-UNDO.                                                             
DEFINE INPUT PARAMETER pNroPedidoComercial AS CHAR NO-UNDO.   

/*DEFINE INPUT PARAMETER pFlag AS CHAR NO-UNDO.*/

DEFINE VAR cFlags AS CHAR.
DEFINE VAR cFlag AS CHAR.
DEFINE VAR iSec AS INT.

DEFINE VAR cTabla AS CHAR.
DEFINE VAR cLlave_c1 AS CHAR.
DEFINE VAR cLlave_c2 AS CHAR.
DEFINE VAR cLlave_c3 AS CHAR INIT "".

cTabla = "CONFIG-VTAS".
cLlave_c1 = "PEDIDOLOGISTICO".
cLlave_c2 = "FLGEST".
cLlave_c3 = "".

cFlags = "G,X,T,W,WX,WL,WC,P,V,F,R,S,C,E,O".

FIND FIRST vtatabla WHERE vtatabla.codcia = 1 AND vtatabla.tabla = cTabla AND
                            vtatabla.Llave_C1 = cLlave_c1 AND vtatabla.Llave_c2 = cLlave_c2 AND
                            vtatabla.Llave_c3 = cLlave_c3 NO-LOCK NO-ERROR.

IF AVAILABLE vtatabla THEN DO:
    IF NOT (TRUE <> (vtatabla.Llave_C4 > "")) THEN cFlags = TRIM(vtatabla.Llave_C4).
END.

DEFINE VAR lCodDocRuta AS CHAR.
DEFINE VAR lNroDocRuta AS CHAR.
DEFINE VAR lTieneODs AS LOG.
DEFINE VAR lTieneGRs AS LOG.
DEFINE VAR lTieneHRs AS LOG.

DEFINE VAR cDoctos AS CHAR.

    FOR EACH x-gn-divi NO-LOCK WHERE x-gn-divi.codcia = s-codcia AND 
            x-gn-divi.campo-log[1] = NO AND
            x-gn-divi.campo-log[5] = YES,  /* Solo CDs */    
        EACH faccpedi NO-LOCK WHERE faccpedi.codcia = s-codcia AND 
                faccpedi.codref = pCodPedidoComercial AND
                faccpedi.nroref = pNroPedidoComercial AND
                faccpedi.coddoc = 'PED' AND
                faccpedi.divdes = x-gn-divi.coddiv /*AND
                Faccpedi.flgest = pFlag AND 
                faccpedi.fchped >= txtDesde AND 
                faccpedi.fchped <= txtHasta
            FIRST gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = faccpedi.codcli NO-LOCK */ :

            /*IF faccpedi.fchped > txtHasta THEN NEXT.*/
    
            /*IF Faccpedi.flgest = "A" THEN NEXT.*/
            /*
            IF txtCodDivi > "" AND Faccpedi.coddiv <> txtCodDivi THEN NEXT.
            IF NOT TRUE <> (txtfile > "") THEN DO:
                FIND FIRST tt-txtfile WHERE tt-txtfile.tt-orden = faccpedi.nroped NO-LOCK NO-ERROR.
                IF NOT AVAILABLE tt-txtfile THEN NEXT.
            END.    
            */
            FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
                "[VENTAS] DIVISION: " + Faccpedi.divdes + " " + Faccpedi.coddoc + " " + Faccpedi.nroped .
            /*
            DISPLAY "DIVISION: " + Faccpedi.divdes + " " + Faccpedi.coddoc + " " + Faccpedi.nroped
                @ Fi-Mensaje WITH FRAME F-Proceso.
            */

            /* */
            lDcli = "".
            lDpto = "".
            lProv = "".
            lDist = "".
            lCodpro = "".
            lDesPro = "".
            lDestino = "".
    
            /* Cliente */

            lDCli = gn-clie.nomcli.
            FIND FIRST tabdepto WHERE tabdepto.coddepto = gn-clie.coddept NO-LOCK NO-ERROR.
            IF AVAILABLE tabdepto THEN lDpto = tabdepto.nomdepto.

            FIND FIRST tabprovi WHERE tabprovi.coddepto = gn-clie.coddept AND 
                tabprovi.codprovi = gn-clie.codprov NO-LOCK NO-ERROR.
            IF AVAILABLE tabprovi THEN lProv = tabprovi.nomprovi.

            FIND FIRST tabdistr WHERE tabdistr.coddepto = gn-clie.coddept AND 
                tabdistr.codprovi = gn-clie.codprov AND 
                tabdistr.coddistr = gn-clie.coddist NO-LOCK NO-ERROR.
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
            FOR EACH od_faccpedi NO-LOCK WHERE od_faccpedi.codcia = faccpedi.codcia AND 
                od_faccpedi.codref = faccpedi.coddoc AND
                od_faccpedi.nroref = faccpedi.nroped:

                IF od_faccpedi.coddoc <> 'O/D' THEN NEXT.
                IF od_faccpedi.flgest = 'A' THEN NEXT.

                FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
                    "[VENTAS] DIVISION: " + Faccpedi.divdes + " " + Faccpedi.coddoc + " " + Faccpedi.nroped + " " +
                    od_faccpedi.coddoc + " " + od_faccpedi.nroped.
    
                /* Bultos de la O/D */
                /*
                FIND FIRST ccbcbult WHERE ccbcbult.codcia = s-codcia AND 
                    ccbcbult.coddoc = od_faccpedi.coddoc AND
                    ccbcbult.nrodoc = od_faccpedi.nroped NO-LOCK NO-ERROR.
                IF AVAILABLE ccbcbult THEN DO:
                    /*
                    RUN lib/_time-passed ( DATETIME(STRING(Ccbcbult.dte_02) + ' ' + STRING(Ccbcbult.CHR_04)),
                                             DATETIME(STRING(Ccbcbult.dte_01) + ' ' + STRING(Ccbcbult.CHR_03)), OUTPUT x-Tiempo).
                    */
                END.
                */
                lTieneODs = YES.
    
                lqCostoVenta = 0.
                lqCostoReposicion = 0.
                lqCostoKardex = 0.        
    
                /* Importe de la O/D */
                IF ChkbxResumen = NO THEN DO:
                    /*RUN ue-Importes('O/D',OUTPUT lqCostoVenta, OUTPUT lqCostoReposicion, OUTPUT lqCostoKardex).*/
                    lqCostoVenta = od_faccpedi.imptot.
                END.        
                ELSE DO:
                    lqCostoVenta = od_faccpedi.imptot.
                END.
    
                lqItems = 0.
                lqPeso = 0.
                lqVolumen = 0.
                IF ChkbxResumen = NO THEN DO:
                    lqItems = od_faccpedi.items.
                    lqPeso = od_faccpedi.peso.
                    lqVolumen = od_faccpedi.volumen.
                    IF lqItems = 0 OR lqPeso = 0 /*OR lqVolumen = 0*/ THEN DO:
                        RUN ue-item-peso("O/D", OUTPUT lqItems, OUTPUT lqPeso, OUTPUT lqVolumen).
                    END.                
                END.
    
                cDoctos = "FAC,BOL,TCK".
                /* Verificar si la O/D tiene FAIs */
                FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
                    ccbcdocu.codped = faccpedi.coddoc AND
                    ccbcdocu.nroped = faccpedi.nroped NO-LOCK:

                    IF ccbcdocu.coddoc = 'FAI' AND ccbcdocu.libre_c01 = od_faccpedi.coddoc AND
                                                ccbcdocu.libre_c02 = od_faccpedi.nroped AND
                                            ccbcdocu.flgest <> 'A' THEN DO:
                        cDoctos = "FAI,BOL,TCK".
                        LEAVE.
                    END.
                END.
                /*
                FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
                    ccbcdocu.codped = faccpedi.coddoc AND
                    ccbcdocu.nroped = faccpedi.nroped AND 
                    ccbcdocu.coddoc = 'FAI' AND
                    ccbcdocu.libre_c01 = od_faccpedi.coddoc AND
                    ccbcdocu.libre_c02 = od_faccpedi.nroped AND
                    ccbcdocu.flgest <> 'A' NO-LOCK NO-ERROR.
                IF AVAILABLE ccbcdocu THEN cDoctos = "FAI,BOL,TCK".
                */
                /* Buscar los documentos (FAC,BOL,TCK) emitidos por la O/D */
                lTieneGRs = NO.
                FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia AND 
                                        ccbcdocu.codped = faccpedi.coddoc AND
                                        ccbcdocu.nroped = faccpedi.nroped:
                    IF NOT ( 
                        LOOKUP(ccbcdocu.coddoc,cDoctos) > 0 AND 
                        ccbcdocu.libre_c01 = od_faccpedi.coddoc AND
                        ccbcdocu.libre_c02 = od_faccpedi.nroped AND
                        ccbcdocu.flgest <> 'A'
                        )
                        THEN NEXT.
    
                    /* Buscar las G/R de la FAC/BOL/TCK */
                    FOR EACH gr_ccbcdocu NO-LOCK WHERE gr_ccbcdocu.codcia = s-codcia AND
                                                gr_ccbcdocu.codref = ccbcdocu.coddoc AND
                                                gr_ccbcdocu.nroref = ccbcdocu.nrodoc AND
                                                gr_ccbcdocu.coddoc = 'G/R' :
                        /* */
                        lTieneGRs = YES.
                        lTieneHRs = NO.
    
                        /* ----- */
                        RUN ue-ventas-hoja-de-ruta(INPUT gr_ccbcdocu.coddoc, INPUT gr_ccbcdocu.nrodoc, OUTPUT lTieneHRs).
    
                        /* La G/R No tiene HR */
                        IF lTieneHRs = NO THEN DO:
                            /* Adiciono registro */
                            /*CREATE tt-seguimiento.*/
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
                            /*CREATE tt-seguimiento.*/
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
                    /*CREATE tt-seguimiento.*/
                    RUN ue-grabar-mov(INPUT "PEDIDO").
                    RUN ue-grabar-mov(INPUT "ORDEN").
    
                END.
            END.
            /* El Pedido no tiene O/D */
            IF lTieneODs = NO THEN DO:
                /* Adiciono registro */
                /*CREATE tt-seguimiento.*/
                RUN ue-grabar-mov(INPUT "PEDIDO").
            END.
        /*END.*/
    END.

RELEASE x-gn-divi NO-ERROR.
RELEASE faccpedi NO-ERROR.
RELEASE ccbcdocu NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue_ventas_proceso-old2 W-Win 
PROCEDURE ue_ventas_proceso-old2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pFlag AS CHAR NO-UNDO.

DEFINE VAR lCodDocRuta AS CHAR.
DEFINE VAR lNroDocRuta AS CHAR.
DEFINE VAR lTieneODs AS LOG.
DEFINE VAR lTieneGRs AS LOG.
DEFINE VAR lTieneHRs AS LOG.

DEFINE VAR cDoctos AS CHAR.

    FOR EACH x-gn-divi NO-LOCK WHERE x-gn-divi.codcia = s-codcia AND 
            x-gn-divi.campo-log[1] = NO AND
            x-gn-divi.campo-log[5] = YES,  /* Solo CDs */    
        EACH faccpedi NO-LOCK WHERE faccpedi.codcia = s-codcia AND 
                faccpedi.divdes = x-gn-divi.coddiv AND
                faccpedi.coddoc = 'PED' AND 
                Faccpedi.flgest = pFlag AND 
                faccpedi.fchped >= txtDesde /*AND 
                faccpedi.fchped <= txtHasta*/ ,
            FIRST gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = faccpedi.codcli NO-LOCK :

            IF faccpedi.fchped > txtHasta THEN NEXT.
    
            /*IF Faccpedi.flgest = "A" THEN NEXT.*/
            IF txtCodDivi > "" AND Faccpedi.coddiv <> txtCodDivi THEN NEXT.
            IF NOT TRUE <> (txtfile > "") THEN DO:
                FIND FIRST tt-txtfile WHERE tt-txtfile.tt-orden = faccpedi.nroped NO-LOCK NO-ERROR.
                IF NOT AVAILABLE tt-txtfile THEN NEXT.
            END.    
            FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
                "[VENTAS] DIVISION: " + Faccpedi.divdes + " " + Faccpedi.coddoc + " " + Faccpedi.nroped .
            /*
            DISPLAY "DIVISION: " + Faccpedi.divdes + " " + Faccpedi.coddoc + " " + Faccpedi.nroped
                @ Fi-Mensaje WITH FRAME F-Proceso.
            */

            /* */
            lDcli = "".
            lDpto = "".
            lProv = "".
            lDist = "".
            lCodpro = "".
            lDesPro = "".
            lDestino = "".
    
            /* Cliente */

            lDCli = gn-clie.nomcli.
            FIND FIRST tabdepto WHERE tabdepto.coddepto = gn-clie.coddept NO-LOCK NO-ERROR.
            IF AVAILABLE tabdepto THEN lDpto = tabdepto.nomdepto.

            FIND FIRST tabprovi WHERE tabprovi.coddepto = gn-clie.coddept AND 
                tabprovi.codprovi = gn-clie.codprov NO-LOCK NO-ERROR.
            IF AVAILABLE tabprovi THEN lProv = tabprovi.nomprovi.

            FIND FIRST tabdistr WHERE tabdistr.coddepto = gn-clie.coddept AND 
                tabdistr.codprovi = gn-clie.codprov AND 
                tabdistr.coddistr = gn-clie.coddist NO-LOCK NO-ERROR.
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
            FOR EACH od_faccpedi NO-LOCK WHERE od_faccpedi.codcia = faccpedi.codcia AND 
                od_faccpedi.codref = faccpedi.coddoc AND
                od_faccpedi.nroref = faccpedi.nroped:

                IF od_faccpedi.coddoc <> 'O/D' THEN NEXT.
                IF od_faccpedi.flgest = 'A' THEN NEXT.

                FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
                    "[VENTAS] DIVISION: " + Faccpedi.divdes + " " + Faccpedi.coddoc + " " + Faccpedi.nroped + " " +
                    od_faccpedi.coddoc + " " + od_faccpedi.nroped.
    
                /* Bultos de la O/D */
                /*
                FIND FIRST ccbcbult WHERE ccbcbult.codcia = s-codcia AND 
                    ccbcbult.coddoc = od_faccpedi.coddoc AND
                    ccbcbult.nrodoc = od_faccpedi.nroped NO-LOCK NO-ERROR.
                IF AVAILABLE ccbcbult THEN DO:
                    /*
                    RUN lib/_time-passed ( DATETIME(STRING(Ccbcbult.dte_02) + ' ' + STRING(Ccbcbult.CHR_04)),
                                             DATETIME(STRING(Ccbcbult.dte_01) + ' ' + STRING(Ccbcbult.CHR_03)), OUTPUT x-Tiempo).
                    */
                END.
                */
                lTieneODs = YES.
    
                lqCostoVenta = 0.
                lqCostoReposicion = 0.
                lqCostoKardex = 0.        
    
                /* Importe de la O/D */
                IF ChkbxResumen = NO THEN DO:
                    /*RUN ue-Importes('O/D',OUTPUT lqCostoVenta, OUTPUT lqCostoReposicion, OUTPUT lqCostoKardex).*/
                    lqCostoVenta = od_faccpedi.imptot.
                END.        
                ELSE DO:
                    lqCostoVenta = od_faccpedi.imptot.
                END.
    
                lqItems = 0.
                lqPeso = 0.
                lqVolumen = 0.
                IF ChkbxResumen = NO THEN DO:
                    lqItems = od_faccpedi.items.
                    lqPeso = od_faccpedi.peso.
                    lqVolumen = od_faccpedi.volumen.
                    IF lqItems = 0 OR lqPeso = 0 /*OR lqVolumen = 0*/ THEN DO:
                        RUN ue-item-peso("O/D", OUTPUT lqItems, OUTPUT lqPeso, OUTPUT lqVolumen).
                    END.                
                END.
    
                cDoctos = "FAC,BOL,TCK".
                /* Verificar si la O/D tiene FAIs */
                FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
                    ccbcdocu.codped = faccpedi.coddoc AND
                    ccbcdocu.nroped = faccpedi.nroped NO-LOCK:

                    IF ccbcdocu.coddoc = 'FAI' AND ccbcdocu.libre_c01 = od_faccpedi.coddoc AND
                                                ccbcdocu.libre_c02 = od_faccpedi.nroped AND
                                            ccbcdocu.flgest <> 'A' THEN DO:
                        cDoctos = "FAI,BOL,TCK".
                        LEAVE.
                    END.
                END.
                /*
                FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
                    ccbcdocu.codped = faccpedi.coddoc AND
                    ccbcdocu.nroped = faccpedi.nroped AND 
                    ccbcdocu.coddoc = 'FAI' AND
                    ccbcdocu.libre_c01 = od_faccpedi.coddoc AND
                    ccbcdocu.libre_c02 = od_faccpedi.nroped AND
                    ccbcdocu.flgest <> 'A' NO-LOCK NO-ERROR.
                IF AVAILABLE ccbcdocu THEN cDoctos = "FAI,BOL,TCK".
                */
                /* Buscar los documentos (FAC,BOL,TCK) emitidos por la O/D */
                lTieneGRs = NO.
                FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia AND 
                                        ccbcdocu.codped = faccpedi.coddoc AND
                                        ccbcdocu.nroped = faccpedi.nroped:
                    IF NOT ( 
                        LOOKUP(ccbcdocu.coddoc,cDoctos) > 0 AND 
                        ccbcdocu.libre_c01 = od_faccpedi.coddoc AND
                        ccbcdocu.libre_c02 = od_faccpedi.nroped AND
                        ccbcdocu.flgest <> 'A'
                        )
                        THEN NEXT.
    
                    /* Buscar las G/R de la FAC/BOL/TCK */
                    FOR EACH gr_ccbcdocu NO-LOCK WHERE gr_ccbcdocu.codcia = s-codcia AND
                                                gr_ccbcdocu.codref = ccbcdocu.coddoc AND
                                                gr_ccbcdocu.nroref = ccbcdocu.nrodoc AND
                                                gr_ccbcdocu.coddoc = 'G/R' :
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
                CREATE tt-seguimiento.
                RUN ue-grabar-mov(INPUT "PEDIDO").
            END.
        /*END.*/
    END.

RELEASE x-gn-divi NO-ERROR.
RELEASE faccpedi NO-ERROR.
RELEASE ccbcdocu NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um-procesar W-Win 
PROCEDURE um-procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

lTiempoDesde = NOW.

EMPTY TEMP-TABLE tt-seguimiento.

RUN ue-ventas.
IF TRUE <> (txtFile > "") THEN DO:
    /*RUN ue-ordenes-transferencias.*/
    /* Ic - 17Ene2024, las manuales se retira x q no se tiene valores de importes en el faccpedi */
    /*RUN ue-transferencias-manuales.*/
END.

RUN Limpiar-Texto.

lTiempoHasta = NOW.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fchDistribucion W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fFlgEst-Detalle W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fImpTot W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPeso W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fQitems W-Win 
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

