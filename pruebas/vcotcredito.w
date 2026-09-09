&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject NO-UNDO
       {"aplic/pruebas/dcotcredito.i"}.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*------------------------------------------------------------------------

  File:

  Description: from viewer.w - Template for SmartDataViewer objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
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
DEF SHARED VAR s-import-ibc AS LOG.
DEF SHARED VAR s-import-cissac AS LOG.
DEF SHARED VAR s-adm-new-record AS CHAR.
DEF SHARED VARIABLE S-NROPED AS CHAR.
DEF SHARED VAR pCodDiv  AS CHAR.        /* DIVISION DE LA LISTA DE PRECIOS */
DEF SHARED VAR S-CMPBNTE  AS CHAR.
DEF SHARED VAR S-CODTER   AS CHAR.
DEF SHARED VAR S-TPOMARCO AS CHAR.      /* CASO DE CLIENTES EXCEPCIONALES */

/* Parámetros de la División */
DEF SHARED VAR s-DiasVtoCot LIKE GN-DIVI.DiasVtoCot.
DEF SHARED VAR s-MinimoPesoDia AS DEC.
DEF SHARED VAR s-MaximaVarPeso AS DEC.
DEF SHARED VAR s-MinimoDiasDespacho AS DEC.

/*DEFINE SHARED VARIABLE s-ListaTerceros AS INT.*/

DEF SHARED TEMP-TABLE T-DPEDI LIKE FacDPedi.

DEF VAR s-copia-registro AS LOG.
DEF VAR s-cndvta-validos AS CHAR.
DEF VAR F-Observa        AS CHAR.
DEFINE VARIABLE s-pendiente-ibc AS LOG.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE VAR x-ClientesVarios AS CHAR.
x-ClientesVarios = FacCfgGn.CliVar.     /* 11 digitos */

/* Variables para los mensajes de error */
DEF VAR pMensaje AS CHAR NO-UNDO.

/* 03Oct2014 - Plaza Vea cambio B2B*/
DEF TEMP-TABLE tt-OrdenesPlazVea
    FIELD tt-nroorden AS CHAR FORMAT 'x(15)'
    FIELD tt-codclie AS CHAR FORMAT 'x(11)'
    FIELD tt-locentrega AS CHAR FORMAT 'x(8)'.

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
/*DEFINE VARIABLE t-Column        AS INTEGER INIT 1.*/
DEFINE VARIABLE t-Row           AS INTEGER INIT 1.

DEF VAR ImpMinPercep AS DEC INIT 1500 NO-UNDO.
DEF VAR ImpMinDNI    AS DEC INIT 700 NO-UNDO.

DEFINE VAR p-lfilexls AS CHAR INIT "".
DEFINE VAR p-lFileXlsProcesado AS CHAR INIT "".
DEFINE VARIABLE cCOTDesde AS CHAR INIT "".
DEFINE VARIABLE cCOTHasta AS CHAR INIT "".

/* B2Bv2 */
DEFINE TEMP-TABLE OrdenCompra-tienda
    FIELDS nro-oc   AS CHAR
    FIELDS clocal-destino AS CHAR
    FIELDS dlocal-Destino AS CHAR
    FIELDS clocal-entrega AS CHAR
    FIELDS dlocal-entrega AS CHAR
    FIELDS CodClie AS CHAR

    INDEX llave01 AS PRIMARY nro-oc clocal-destino.

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

DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE BUFFER B-DIVI FOR GN-DIVI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "aplic/pruebas/dcotcredito.i"

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.CodCia RowObject.Libre_c01 ~
RowObject.FchPed RowObject.CodDiv RowObject.CodCli RowObject.FaxCli ~
RowObject.Libre_c04 RowObject.fchven RowObject.CodDoc RowObject.RucCli ~
RowObject.Atencion RowObject.FchEnt RowObject.NomCli RowObject.FlgEst ~
RowObject.DirCli RowObject.ordcmp RowObject.Sede RowObject.Cmpbnte ~
RowObject.LugEnt RowObject.CodMon RowObject.Glosa RowObject.TpoCmb ~
RowObject.CodPos RowObject.PorIgv RowObject.FlgIgv RowObject.CodVen ~
RowObject.Libre_d01 RowObject.FmaPgo RowObject.CodRef RowObject.NroRef ~
RowObject.NroCard RowObject.LugEnt2 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define DISPLAYED-FIELDS RowObject.CodCia RowObject.NroPed ~
RowObject.Libre_c01 RowObject.FchPed RowObject.CodDiv RowObject.CodCli ~
RowObject.FaxCli RowObject.Libre_c04 RowObject.fchven RowObject.CodDoc ~
RowObject.RucCli RowObject.Atencion RowObject.FchEnt RowObject.NomCli ~
RowObject.usuario RowObject.FlgEst RowObject.DirCli RowObject.ordcmp ~
RowObject.Sede RowObject.Cmpbnte RowObject.LugEnt RowObject.CodMon ~
RowObject.Glosa RowObject.TpoCmb RowObject.CodPos RowObject.PorIgv ~
RowObject.FlgIgv RowObject.CodVen RowObject.Libre_d01 RowObject.FmaPgo ~
RowObject.CodRef RowObject.NroRef RowObject.NroCard RowObject.LugEnt2 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS F-Estado FILL-IN-1 FILL-IN-sede ~
FILL-IN-Postal f-NomVen F-CndVta F-Nomtar PuntodeSalida 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
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
     SIZE 20 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE F-Nomtar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81 NO-UNDO.

DEFINE VARIABLE f-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81
     FONT 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Postal AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-sede AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE PuntodeSalida AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RowObject.CodCia AT ROW 1 COL 3 COLON-ALIGNED WIDGET-ID 192
          VIEW-AS FILL-IN 
          SIZE 3.57 BY .81
     RowObject.NroPed AT ROW 1 COL 16 COLON-ALIGNED WIDGET-ID 90
          LABEL "Número" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     F-Estado AT ROW 1 COL 34 COLON-ALIGNED WIDGET-ID 180
     RowObject.Libre_c01 AT ROW 1 COL 68 COLON-ALIGNED WIDGET-ID 150
          LABEL "Lista de Precios" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 14 FGCOLOR 0 
     RowObject.FchPed AT ROW 1 COL 99 COLON-ALIGNED WIDGET-ID 74
          LABEL "Fecha de Emisión"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     RowObject.CodDiv AT ROW 1.81 COL 5.14 COLON-ALIGNED WIDGET-ID 194
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     RowObject.CodCli AT ROW 1.81 COL 16 COLON-ALIGNED WIDGET-ID 58
          LABEL "Cliente"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
          BGCOLOR 11 FGCOLOR 0 
     RowObject.FaxCli AT ROW 1.81 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 152 FORMAT "x(10)"
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .81
     BUTTON-Turno-Retrocede AT ROW 1.81 COL 49 WIDGET-ID 34
     BUTTON-Turno-Avanza AT ROW 1.81 COL 54 WIDGET-ID 32
     FILL-IN-1 AT ROW 1.81 COL 57 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     RowObject.Libre_c04 AT ROW 1.81 COL 77 NO-LABEL WIDGET-ID 176
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Sí", "SI":U,
"No", ""
          SIZE 10 BY .81
          BGCOLOR 15 FGCOLOR 1 
     RowObject.fchven AT ROW 1.81 COL 99 COLON-ALIGNED WIDGET-ID 76 FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     RowObject.CodDoc AT ROW 2.62 COL 4.57 COLON-ALIGNED WIDGET-ID 196
          VIEW-AS FILL-IN 
          SIZE 3.57 BY .81
     RowObject.RucCli AT ROW 2.62 COL 16 COLON-ALIGNED WIDGET-ID 94
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     RowObject.Atencion AT ROW 2.62 COL 34 COLON-ALIGNED WIDGET-ID 52
          LABEL "DNI" FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
          BGCOLOR 11 FGCOLOR 0 
     RowObject.FchEnt AT ROW 2.62 COL 99 COLON-ALIGNED WIDGET-ID 72
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 FGCOLOR 0 
     RowObject.NomCli AT ROW 3.42 COL 16 COLON-ALIGNED WIDGET-ID 88
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
          BGCOLOR 11 FGCOLOR 0 
     RowObject.usuario AT ROW 3.42 COL 99 COLON-ALIGNED WIDGET-ID 100
          LABEL "Digitado por"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     RowObject.FlgEst AT ROW 4 COL 7 COLON-ALIGNED WIDGET-ID 198
          VIEW-AS FILL-IN 
          SIZE 2.14 BY .81
     RowObject.DirCli AT ROW 4.23 COL 16 COLON-ALIGNED WIDGET-ID 70
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
          BGCOLOR 11 FGCOLOR 0 
     RowObject.ordcmp AT ROW 4.23 COL 99 COLON-ALIGNED WIDGET-ID 92 FORMAT "X(20)"
          VIEW-AS FILL-IN 
          SIZE 19 BY .81
          BGCOLOR 11 FGCOLOR 0 
     RowObject.Sede AT ROW 5.04 COL 16 COLON-ALIGNED WIDGET-ID 96
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FILL-IN-sede AT ROW 5.04 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     RowObject.Cmpbnte AT ROW 5.04 COL 101 NO-LABEL WIDGET-ID 160
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "FAC", "FAC":U,
"BOL", "BOL":U
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 0 
     RowObject.LugEnt AT ROW 5.85 COL 16 COLON-ALIGNED WIDGET-ID 86
          LABEL "Entrtegar en"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
          BGCOLOR 11 FGCOLOR 0 
     RowObject.CodMon AT ROW 5.85 COL 101 NO-LABEL WIDGET-ID 164
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dólares", 2
          SIZE 16 BY .81
          BGCOLOR 11 FGCOLOR 0 
     RowObject.Glosa AT ROW 6.65 COL 16 COLON-ALIGNED WIDGET-ID 104
          LABEL "Glosa" FORMAT "X(50)"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
          BGCOLOR 11 FGCOLOR 0 
     RowObject.TpoCmb AT ROW 6.65 COL 99 COLON-ALIGNED WIDGET-ID 98
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     RowObject.CodPos AT ROW 7.46 COL 16 COLON-ALIGNED WIDGET-ID 66
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FILL-IN-Postal AT ROW 7.46 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     RowObject.PorIgv AT ROW 7.46 COL 89 COLON-ALIGNED WIDGET-ID 200
          VIEW-AS FILL-IN 
          SIZE 6.43 BY .81
     RowObject.FlgIgv AT ROW 7.46 COL 101 WIDGET-ID 168
          LABEL "Afecto a IGV"
          VIEW-AS TOGGLE-BOX
          SIZE 11.29 BY .77
          BGCOLOR 11 FGCOLOR 0 
     RowObject.CodVen AT ROW 8.27 COL 16 COLON-ALIGNED WIDGET-ID 68
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
          BGCOLOR 11 FGCOLOR 0 
     f-NomVen AT ROW 8.27 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 158
     RowObject.Libre_d01 AT ROW 8.27 COL 101 NO-LABEL WIDGET-ID 170
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "2", 2,
"3", 3,
"4", 4,
"5", 5
          SIZE 19 BY .81
          BGCOLOR 11 FGCOLOR 0 
     RowObject.FmaPgo AT ROW 9.08 COL 16 COLON-ALIGNED WIDGET-ID 82
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
          BGCOLOR 11 FGCOLOR 0 
     F-CndVta AT ROW 9.08 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 154
     RowObject.CodRef AT ROW 9.08 COL 99 COLON-ALIGNED WIDGET-ID 130
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     RowObject.NroRef AT ROW 9.08 COL 104 COLON-ALIGNED NO-LABEL WIDGET-ID 132
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     RowObject.NroCard AT ROW 9.88 COL 16 COLON-ALIGNED WIDGET-ID 108
          LABEL "Tarjeta"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 11 FGCOLOR 0 
     F-Nomtar AT ROW 9.88 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 156
     RowObject.LugEnt2 AT ROW 10.69 COL 16 COLON-ALIGNED WIDGET-ID 106
          LABEL "Punto de Distribución" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
     PuntodeSalida AT ROW 10.69 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 140
     "Comprobante:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 5.31 COL 91 WIDGET-ID 114
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "Lista MARCO?" VIEW-AS TEXT
          SIZE 11 BY .5 AT ROW 2.08 COL 66 WIDGET-ID 148
          BGCOLOR 15 FGCOLOR 1 
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 6.12 COL 94 WIDGET-ID 84
     "Redondedo del P.U.:" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 8.54 COL 86 WIDGET-ID 128
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "aplic\pruebas\dcotcredito.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" NO-UNDO INTEGRAL GN-DIVI
      ADDITIONAL-FIELDS:
          {aplic/pruebas/dcotcredito.i}
      END-FIELDS.
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
  CREATE WINDOW vTableWin ASSIGN
         HEIGHT             = 12.35
         WIDTH              = 130.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB vTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW vTableWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR FILL-IN RowObject.Atencion IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR BUTTON BUTTON-Turno-Avanza IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-Turno-Avanza:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-Turno-Retrocede IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-Turno-Retrocede:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR RADIO-SET RowObject.Cmpbnte IN FRAME F-Main
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.CodCia:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.CodCli IN FRAME F-Main
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.CodDiv:HIDDEN IN FRAME F-Main           = TRUE.

ASSIGN 
       RowObject.CodDoc:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR RADIO-SET RowObject.CodMon IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Nomtar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN RowObject.FaxCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN RowObject.FchPed IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.fchven IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN-1:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Postal IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-sede IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.FlgEst:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX RowObject.FlgIgv IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.Glosa IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN RowObject.Libre_c01 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR RADIO-SET RowObject.Libre_c04 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR RADIO-SET RowObject.Libre_d01 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.LugEnt IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.LugEnt2 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN RowObject.NroCard IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN RowObject.ordcmp IN FRAME F-Main
   EXP-FORMAT                                                           */
ASSIGN 
       RowObject.PorIgv:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN PuntodeSalida IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN RowObject.usuario IN FRAME F-Main
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Turno-Avanza vTableWin
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
                gn-clie.codcli @ RowObject.CodCli            
                gn-clie.nomcli @ RowObject.NomCli
                gn-clie.dircli @ RowObject.DirCli 
                gn-clie.nrocard @ RowObject.NroCard 
                gn-clie.ruc @ RowObject.RucCli
                gn-clie.Codpos @ RowObject.CodPos
                WITH FRAME {&FRAME-NAME}.
  END.
  APPLY 'ENTRY':U TO RowObject.CodCli.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Turno-Retrocede
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Turno-Retrocede vTableWin
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
                gn-clie.codcli @ RowObject.CodCli            
                gn-clie.nomcli @ RowObject.NomCli
                gn-clie.dircli @ RowObject.DirCli 
                gn-clie.nrocard @ RowObject.NroCard 
                gn-clie.ruc @ RowObject.RucCli
                gn-clie.Codpos @ RowObject.CodPos
                WITH FRAME {&FRAME-NAME}.
  END.
  APPLY 'ENTRY':U TO RowObject.CodCli.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.Cmpbnte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.Cmpbnte vTableWin
ON VALUE-CHANGED OF RowObject.Cmpbnte IN FRAME F-Main
DO:
    DO WITH FRAM {&FRAME-NAME}:
        IF SELF:SCREEN-VALUE = 'FAC' AND RowObject.CodCli:SCREEN-VALUE <> '11111111112'
            THEN DO:
            FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                AND gn-clie.CodCli = RowObject.CodCli:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
            ASSIGN
                RowObject.DirCli:SENSITIVE = NO
                RowObject.NomCli:SENSITIVE = NO
                RowObject.Atencion:SENSITIVE = NO.
            IF AVAILABLE gn-clie THEN DO:
                ASSIGN
                    RowObject.DirCli:SCREEN-VALUE = GN-CLIE.DirCli
                    RowObject.NomCli:SCREEN-VALUE = GN-CLIE.NomCli
                    RowObject.RucCli:SCREEN-VALUE = gn-clie.Ruc.
            END.
        END.
        ELSE DO:
            ASSIGN
                RowObject.DirCli:SENSITIVE = YES
                RowObject.NomCli:SENSITIVE = YES
                RowObject.Atencion:SENSITIVE = YES.
            IF RowObject.CodCli:SCREEN-VALUE = '11111111112' THEN RowObject.RucCli:SENSITIVE = YES.
        END.
        S-CMPBNTE = SELF:SCREEN-VALUE.
        RUN Procesa-Handle IN lh_Handle ('Recalculo').
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.CodCli vTableWin
ON LEAVE OF RowObject.CodCli IN FRAME F-Main /* Cliente */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.

  RUN vtagn/p-clie-expo (SELF:SCREEN-VALUE, s-TpoPed, pCodDiv).
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.

  RUN vtagn/p-gn-clie-01 (SELF:SCREEN-VALUE, s-CodDoc).
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  s-CodCli = SELF:SCREEN-VALUE.

  /* Cargamos las condiciones de venta válidas */
  FIND gn-clie WHERE gn-clie.codcia  = cl-codcia
      AND gn-clie.codcli = s-codcli
      NO-LOCK.
  RUN vta2/p-fmapgo (s-codcli, s-tpoped, OUTPUT s-cndvta-validos).
  IF RowObject.FmaPgo:SCREEN-VALUE = "" THEN s-FmaPgo = ENTRY(1, s-cndvta-validos).
  ELSE s-FmaPgo = RowObject.FmaPgo:SCREEN-VALUE.
  /* ****************************************** */
  DISPLAY 
      gn-clie.NomCli @ RowObject.NomCli
      gn-clie.Ruc    @ RowObject.RucCli
      gn-clie.DirCli @ RowObject.DirCli
      s-FmaPgo       @ RowObject.FmaPgo
      gn-clie.NroCard @ RowObject.NroCard
      gn-clie.CodVen WHEN RowObject.CodVen:SCREEN-VALUE = '' @ RowObject.CodVen 
      WITH FRAME {&FRAME-NAME}.
  /* Tarjeta */
  FIND Gn-Card WHERE Gn-Card.NroCard = gn-clie.nrocard NO-LOCK NO-ERROR.
  IF AVAILABLE GN-CARD 
  THEN ASSIGN
            F-NomTar:SCREEN-VALUE = GN-CARD.NomClie[1]
            RowObject.NroCard:SENSITIVE = NO.
  ELSE ASSIGN
            F-NomTar:SCREEN-VALUE = ''
            RowObject.NroCard:SENSITIVE = YES.
  
  /* Ubica la Condicion Venta */
  FIND gn-convt WHERE gn-convt.Codig = RowObject.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt 
  THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
  ELSE F-CndVta:SCREEN-VALUE = "".

  IF RowObject.FmaPgo:SCREEN-VALUE = '900' AND RowObject.Glosa:SCREEN-VALUE = ''
  THEN RowObject.Glosa:SCREEN-VALUE = 'BONIFICACION DE CAMPAÑA POR COMPRA POR VOLUMEN'.

  /* Vendedor */
  F-NomVen:SCREEN-VALUE = "".
  FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
      AND  gn-ven.CodVen = RowObject.CodVen:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-ven THEN F-NomVen:SCREEN-VALUE = gn-ven.NomVen.

  /* CLASIFICACIONES DEL CLIENTE */
  RowObject.FaxCli:SCREEN-VALUE = SUBSTRING(TRIM(gn-clie.clfcli) + "00",1,2) +
                                SUBSTRING(TRIM(gn-clie.clfcli2) + "00",1,2).

  /* Recalculamos cotizacion */
  RUN Procesa-Handle IN lh_Handle ('Recalculo').

  /* Determina si es boleta o factura */
  IF RowObject.RucCli:SCREEN-VALUE = ''
  THEN RowObject.Cmpbnte:SCREEN-VALUE = 'BOL'.
  ELSE RowObject.Cmpbnte:SCREEN-VALUE = 'FAC'.

  /* RHC 07/12/2015 SOLO CLIENTE HABILITADOS CONTRATO MARCO */
  IF LOOKUP(s-TpoPed, "R,M,E") = 0 AND s-adm-new-record = "YES" 
      THEN DO:
      FIND TabGener WHERE TabGener.CodCia = s-codcia
          AND TabGener.Clave = "%MARCO"
          AND TabGener.Codigo = SELF:SCREEN-VALUE
          NO-LOCK NO-ERROR.
      IF AVAILABLE TabGener THEN RowObject.Libre_c04:SENSITIVE = YES.
      ELSE ASSIGN RowObject.Libre_c04:SENSITIVE = NO RowObject.Libre_c04:SCREEN-VALUE = "" S-TPOMARCO = "".
  END.

  APPLY 'VALUE-CHANGED' TO RowObject.Cmpbnte.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.CodMon vTableWin
ON VALUE-CHANGED OF RowObject.CodMon IN FRAME F-Main
DO:
    S-CODMON = INTEGER(SELF:SCREEN-VALUE).
    RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.CodPos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.CodPos vTableWin
ON LEAVE OF RowObject.CodPos IN FRAME F-Main /* Postal */
DO:
  FIND almtabla WHERE almtabla.tabla = 'CP'
    AND almtabla.codigo = INPUT {&SELF-NAME}
    NO-LOCK NO-ERROR.
  IF AVAILABLE almtabla
  THEN FILL-IN-Postal:SCREEN-VALUE = almtabla.nombre.
  ELSE FILL-IN-Postal:SCREEN-VALUE = ''.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.CodVen vTableWin
ON LEAVE OF RowObject.CodVen IN FRAME F-Main /* Vendedor */
DO:
  F-NomVen:SCREEN-VALUE = "".
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
    AND  gn-ven.CodVen = RowObject.CodVen:SCREEN-VALUE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.CodVen vTableWin
ON LEFT-MOUSE-DBLCLICK OF RowObject.CodVen IN FRAME F-Main /* Vendedor */
OR f8 OF RowObject.CodVen
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''.
    RUN lkup/c-vende ('Vendedor').
    IF output-var-1 <> ? THEN RowObject.CodVen:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.FchEnt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.FchEnt vTableWin
ON LEAVE OF RowObject.FchEnt IN FRAME F-Main /* Fecha Entrega */
DO:
    IF INPUT {&self-name} < ( (INPUT RowObject.FchPed) + s-MinimoDiasDespacho) THEN DO:
        MESSAGE 'No se puede despachar antes del' ( (INPUT RowObject.FchPed) + s-MinimoDiasDespacho)
            VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    IF s-MinimoPesoDia > 0 AND INPUT {&SELF-NAME} <> ? AND s-adm-new-record = "YES"
        THEN DO:
        DEF VAR x-Cuentas AS DEC NO-UNDO.
        DEF VAR x-Tope    AS DEC NO-UNDO.
        x-Tope = s-MinimoPesoDia * (1 + s-MaximaVarPeso / 100).
        FOR EACH B-CPEDI NO-LOCK WHERE B-CPEDI.codcia = s-codcia
            AND B-CPEDI.coddiv = s-coddiv
            AND B-CPEDI.coddoc = s-coddoc
            AND B-CPEDI.flgest <> 'A'
            AND B-CPEDI.fchped >= INPUT RowObject.FchPed
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


&Scoped-define SELF-NAME RowObject.FlgIgv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.FlgIgv vTableWin
ON VALUE-CHANGED OF RowObject.FlgIgv IN FRAME F-Main /* Afecto a IGV */
DO:
    s-FlgIgv = INPUT {&self-name}.
    IF s-FlgIgv = YES THEN s-PorIgv = FacCfgGn.PorIgv.
      RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.FmaPgo vTableWin
ON LEAVE OF RowObject.FmaPgo IN FRAME F-Main /* Condicion de ventas */
DO:
    F-CndVta:SCREEN-VALUE = ''.
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND gn-convt WHERE gn-convt.Codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
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
    s-FmaPgo = SELF:SCREEN-VALUE.
    RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.FmaPgo vTableWin
ON LEFT-MOUSE-DBLCLICK OF RowObject.FmaPgo IN FRAME F-Main /* Condicion de ventas */
OR f8 OF RowObject.FmaPgo
DO:
    ASSIGN
        input-var-1 = s-cndvta-validos
        input-var-2 = ''
        input-var-3 = ''.
    RUN vta/d-cndvta.
    IF output-var-1 <> ? THEN RowObject.Fmapgo:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.Libre_c04
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.Libre_c04 vTableWin
ON VALUE-CHANGED OF RowObject.Libre_c04 IN FRAME F-Main
DO:
    S-TPOMARCO = SELF:SCREEN-VALUE.
    RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.Libre_d01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.Libre_d01 vTableWin
ON VALUE-CHANGED OF RowObject.Libre_d01 IN FRAME F-Main
DO:
    s-NroDec = INTEGER(SELF:SCREEN-VALUE).
    RUN Procesa-Handle IN lh_Handle ('Recalculo').

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.NroCard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.NroCard vTableWin
ON LEAVE OF RowObject.NroCard IN FRAME F-Main /* Tarjeta */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.NroCard vTableWin
ON LEFT-MOUSE-DBLCLICK OF RowObject.NroCard IN FRAME F-Main /* Tarjeta */
OR f8 OF RowObject.NroCard
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''.
    RUN lkup/c-gncard ('Tarjetas').
    IF output-var-1 <> ? THEN RowObject.NroCard:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.Sede
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.Sede vTableWin
ON LEAVE OF RowObject.Sede IN FRAME F-Main /* Sede */
DO:
    FILL-IN-Sede:SCREEN-VALUE = "".
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    FIND gn-clied WHERE gn-clied.codcia = cl-codcia
        AND gn-clied.codcli = RowObject.codcli:SCREEN-VALUE
        AND gn-clied.sede = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clied THEN DO:
        MESSAGE "Sede NO válida" VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
    ASSIGN 
        FILL-IN-Sede:SCREEN-VALUE = Gn-ClieD.DirCli
        RowObject.LugEnt:SCREEN-VALUE = Gn-ClieD.DirCli
        RowObject.Glosa:SCREEN-VALUE = (IF RowObject.Glosa:SCREEN-VALUE = '' THEN Gn-ClieD.DirCli ELSE RowObject.Glosa:SCREEN-VALUE).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.Sede vTableWin
ON LEFT-MOUSE-DBLCLICK OF RowObject.Sede IN FRAME F-Main /* Sede */
OR f8 OF RowObject.Sede
DO:
    ASSIGN
      input-var-1 = RowObject.CodCli:SCREEN-VALUE
      input-var-2 = RowObject.NomCli:SCREEN-VALUE
      input-var-3 = ''
      output-var-1 = ?
      output-var-2 = ''
      output-var-3 = ''.
    RUN vta/c-clied.
    IF output-var-1 <> ?
        THEN ASSIGN 
              FILL-IN-Sede:SCREEN-VALUE = output-var-2
              RowObject.LugEnt:SCREEN-VALUE = output-var-2
              RowObject.Glosa:SCREEN-VALUE = (IF RowObject.Glosa:SCREEN-VALUE = '' THEN output-var-2 ELSE RowObject.Glosa:SCREEN-VALUE)
              RowObject.Sede:SCREEN-VALUE = output-var-3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord vTableWin 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
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
      s-Import-IBC = NO
      s-Import-Cissac = NO
      s-adm-new-record = "YES"
      lOrdenGrabada = "".
  ASSIGN
      s-CodMon = 1
      s-CodCli = FacCfgGn.CliVar
      s-FmaPgo = ''
      s-TpoCmb = 1
      s-nroped = ""
      s-NroDec = 4
      s-FlgIgv = YES    /* Venta AFECTA a IGV */
      S-CMPBNTE = "FAC"
      S-TPOMARCO = "".
  
  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      /* Valores de la llave */
      ASSIGN
          RowObject.CodCia:SCREEN-VALUE = STRING(s-codcia,'999')
          RowObject.CodDiv:SCREEN-VALUE = s-coddiv
          RowObject.CodDoc:SCREEN-VALUE = s-coddoc.
      /* Valores por defecto */
      ASSIGN
          RowObject.CodMon:SCREEN-VALUE = STRING(S-CODMON)
          RowObject.Cmpbnte:SCREEN-VALUE = S-CMPBNTE
          RowObject.Libre_d01:SCREEN-VALUE = STRING(s-NroDec, '9')
          RowObject.FlgIgv:SCREEN-VALUE = "YES"
          NO-ERROR.
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
          pCodDiv                        @ RowObject.Libre_c01
          STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ RowObject.NroPed
          TODAY                          @ RowObject.FchPed
          S-TPOCMB                       @ RowObject.TpoCmb
          (TODAY + s-DiasVtoCot)         @ RowObject.FchVen 
          (TODAY + s-MinimoDiasDespacho) @ RowObject.FchEnt
          s-CodCli @ RowObject.codcli
          s-CodVen @ RowObject.codven.
      RUN Borra-Temporal.                                                                    
      RUN Procesa-Handle IN lh_Handle ('Pagina2').                                           
      /* RHC 14/10/2013 ***************************************************************** */
      RUN rutina-add-extra.
      /* ******************************************************************************** */
      RUN Procesa-Handle IN lh_Handle ('Pagina2').
      APPLY 'ENTRY':U TO RowObject.CodCli.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal vTableWin 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal vTableWin 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CONTROL-IBC vTableWin 
PROCEDURE CONTROL-IBC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Rpta AS CHAR.
                                  
/* Cargamos el temporal con las diferencias */
s-pendiente-ibc = NO.
RUN Procesa-Handle IN lh_handle ('IBC').
FIND FIRST T-DPEDI NO-LOCK NO-ERROR.
IF NOT AVAILABLE T-DPEDI THEN RETURN 'OK'.

RUN vta/d-ibc-dif (OUTPUT x-Rpta).
IF x-Rpta = "ADM-ERROR" THEN RETURN "ADM-ERROR".

{adm/i-DocPssw.i s-CodCia 'IBC' ""UPD""}

/* Continua la grabacion */
s-pendiente-ibc = YES.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI vTableWin  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFieldList vTableWin 
PROCEDURE displayFieldList :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcFieldList  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pcFromSource AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER phDataSource AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER pcColValues  AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR cNewRecord AS CHAR NO-UNDO.
  DEF VAR iFieldList AS INT NO-UNDO.
  DEF VAR iItems AS INT NO-UNDO.
  DEF VAR xcColValues AS CHAR NO-UNDO.

  cNewRecord = DYNAMIC-FUNCTION('getNewRecord').
  IF LOOKUP(cNewRecord, 'Add,Copy') > 0 THEN DO:
      /* Problemas con el campo Libre_d01 */
      iFieldList = LOOKUP('Libre_d01',pcFieldList).
      xcColValues = "".
      DO iItems = 1 TO NUM-ENTRIES(pcColValues,CHR(1)):
          IF iItems = iFieldList THEN DO:
              xcColValues = xcColValues + (IF TRUE <> (xcColValues > '') THEN '' ELSE CHR(1)) +
                  STRING(s-NroDec).
          END.
          ELSE xcColValues = xcColValues + (IF TRUE <> (xcColValues > '') THEN '' ELSE CHR(1)) +
                  ENTRY(iItems,pcColValues,CHR(1)).
      END.
      pcColValues = xcColValues.
  END.

  RUN SUPER( INPUT pcFieldList, INPUT pcFromSource, INPUT phDataSource, INPUT pcColValues).

  /* Code placed here will execute AFTER standard behavior.    */
  /* Pasa por esta rutina tanto si es un registro existente o nuevo */
  DO WITH FRAME {&FRAME-NAME}:
/*       RUN vta2/p-faccpedi-flgest (RowObject.flgest:SCREEN-VALUE, s-CodDoc, OUTPUT f-Estado). */
/*       DISPLAY f-Estado.                                                                      */
      F-Nomtar:SCREEN-VALUE = ''.
      FIND FIRST Gn-Card WHERE Gn-Card.NroCard = rowObject.NroCar:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF AVAILABLE Gn-Card THEN F-NomTar:SCREEN-VALUE = GN-CARD.NomClie[1].
      FILL-IN-sede:SCREEN-VALUE = "".
      FIND GN-ClieD WHERE GN-ClieD.CodCia = CL-CODCIA
          AND GN-ClieD.CodCli = rowObject.Codcli:SCREEN-VALUE
          AND GN-ClieD.sede = rowObject.sede:SCREEN-VALUE
          NO-LOCK NO-ERROR.
      IF AVAILABLE GN-ClieD THEN FILL-IN-sede:SCREEN-VALUE = GN-ClieD.dircli.
      F-NomVen:SCREEN-VALUE = "".
      FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
          AND  gn-ven.CodVen = rowObject.CodVen:SCREEN-VALUE
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-ven THEN F-NomVen:SCREEN-VALUE = gn-ven.NomVen.
      F-CndVta:SCREEN-VALUE = "".
      FIND gn-convt WHERE gn-convt.Codig = rowObject.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.

      /*  */
      PuntodeSalida:SCREEN-VALUE = "".
      FIND FIRST almacen WHERE almacen.codcia = s-codcia AND
                    almacen.codalm = rowObject.lugent2:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF AVAILABLE almacen THEN DO:
        PuntodeSalida:SCREEN-VALUE = almacen.descripcion.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields vTableWin 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  DEFINE VARIABLE cNewRecord AS CHARACTER NO-UNDO.
  cNewRecord = DYNAMIC-FUNCTION('getNewRecord').
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          RowObject.FchPed:SENSITIVE = NO
          RowObject.DirCli:SENSITIVE = NO
          RowObject.NomCli:SENSITIVE = NO
          RowObject.RucCli:SENSITIVE = NO
          RowObject.FaxCli:SENSITIVE = NO
          RowObject.TpoCmb:SENSITIVE = NO
          RowObject.LugEnt2:SENSITIVE = NO
          RowObject.CodPos:SENSITIVE = NO
          RowObject.FlgIgv:SENSITIVE = NO
          RowObject.Libre_c01:SENSITIVE = NO
          RowObject.Libre_c04:SENSITIVE = NO
          RowObject.CodRef:SENSITIVE = NO
          RowObject.NroRef:SENSITIVE = NO.
      IF s-user-id = 'ADMIN' THEN RowObject.FlgIgv:SENSITIVE = YES.
      IF s-TpoPed = "E"      THEN RowObject.CodPos:SENSITIVE = YES.
      IF LOOKUP(s-TpoPed, "R,M,E") = 0 THEN DO:
          FIND TabGener WHERE TabGener.CodCia = s-codcia
              AND TabGener.Clave = "%MARCO"
              AND TabGener.Codigo = RowObject.CodCli
              NO-LOCK NO-ERROR.
          IF AVAILABLE TabGener THEN RowObject.Libre_c04:SENSITIVE = YES.
      END.
      IF cNewRecord = "No" THEN DO:
          RowObject.CodCli:SENSITIVE = NO.
          /*   Ic - 13Oct2015 - Si canal de venta de la  division es FER, permite modificar fecha entrega  
                    26Oct2015 - Se debe validar con la lista de precios no con la division.
          */
          IF RowObject.libre_c01:SCREEN-VALUE <> ? THEN DO:
              FIND FIRST b-divi WHERE b-divi.codcia = s-codcia
                  AND b-divi.coddiv = RowObject.libre_c01:SCREEN-VALUE NO-LOCK NO-ERROR.
              IF AVAILABLE b-divi THEN DO:
                  /* Si es FERIA */
                  IF NOT b-divi.canalventa = 'FER' THEN DO:
                      /*RowObject.FchEnt:SENSITIVE = NO.*/
                  END.
              END.
              ELSE RowObject.FchEnt:SENSITIVE = NO.
          END.
          ELSE RowObject.FchEnt:SENSITIVE = NO. 
          IF s-tpoped = "M" THEN DO:    /* SOLO PARA CONTRATO MARCO */
              ASSIGN
                  RowObject.DirCli:SENSITIVE = YES
                  RowObject.NomCli:SENSITIVE = YES.
          END.
          IF s-TpoPed = "LF" THEN DO:   /* Lista Express */
              ASSIGN
                  RowObject.Cmpbnte:SENSITIVE = NO
                  RowObject.CodMon:SENSITIVE = NO
                  RowObject.FlgIgv:SENSITIVE = NO
                  RowObject.Libre_d01:SENSITIVE = NO
                  RowObject.FmaPgo:SENSITIVE = NO.

          END.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rutina-add-extra vTableWin 
PROCEDURE rutina-add-extra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    CASE TRUE:
        WHEN s-TpoPed = "P" THEN DO:     /* PROVINCIAS */
            FIND b-divi WHERE b-divi.codcia = s-codcia
                AND b-divi.coddiv = pCodDiv
                NO-LOCK NO-ERROR.
            IF AVAILABLE b-divi AND b-divi.VentaMayorista = 1 THEN DO:  /* LISTA GENERAL */
                RUN Procesa-Handle IN lh_Handle ('Pagina3').
                RUN Procesa-Handle IN lh_Handle ("Enable-Button-Imp-Prov").
            END.
        END.
        WHEN s-CodDiv = '00024' THEN DO:  /* INSTITUCIONALES */
            IF s-TpoPed <> "M" THEN RUN Procesa-Handle IN lh_Handle ("Enable-Button-Imp-OpenOrange").
        END.
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
                    gn-clie.codcli @ RowObject.CodCli
                    gn-clie.nomcli @ RowObject.NomCli
                    gn-clie.dircli @ RowObject.DirCli
                    gn-clie.nrocard @ RowObject.NroCard
                    gn-clie.ruc    @ RowObject.RucCli
                    gn-clie.Codpos @ RowObject.CodPos.
            END.
        END.
    END CASE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateMode vTableWin 
PROCEDURE updateMode :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcMode AS CHARACTER NO-UNDO.

  IF pcMode = 'updateBegin' THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN ERROR.
  END.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcMode).

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update vTableWin 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE BUFFER b-divi FOR gn-divi.
DEFINE VAR RPTA AS CHAR.

DO WITH FRAME {&FRAME-NAME}:
    IF LOOKUP(RowObject.FlgEst:SCREEN-VALUE,"E,P,T,I") = 0 THEN DO:
        MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    IF DATE(RowObject.FchVen:SCREEN-VALUE) < TODAY THEN DO:
        MESSAGE 'Cotización venció el' RowObject.fchven:SCREEN-VALUE SKIP
            'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.

    /* Ic - 04Feb2016, las cotizaciones de ListaExpress son INMODIFICABLES */
    IF s-tpoped = 'LF' AND RowObject.FlgEst:SCREEN-VALUE = "P" THEN DO:
        MESSAGE 'Cotización de ListaExpress APROBADA' SKIP
            'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.

    /* Si tiene atenciones parciales tambien se bloquea */
    /* FIND FIRST facdpedi OF RowObject WHERE CanAte <> 0 NO-LOCK NO-ERROR. */
    /* IF AVAILABLE facdpedi                                                */
    /* THEN DO:                                                             */
    /*     MESSAGE "La Cotización tiene atenciones parciales" SKIP          */
    /*         "Acceso denegado"                                            */
    /*         VIEW-AS ALERT-BOX ERROR.                                     */
    /*     RETURN "ADM-ERROR".                                              */
    /* END.                                                                 */

    /* BLOQUEAR SI SE HA TRABAJADO CON OTRA LISTA DE PRECIOS */
    IF pCodDiv <> RowObject.Libre_c01:SCREEN-VALUE THEN DO:
        MESSAGE 'NO puede modificar una Cotización generada con otra lista de precios'
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    /* ***************************************************** */
    ASSIGN
        S-CODMON = INTEGER(RowObject.CodMon:SCREEN-VALUE)
        S-CODCLI = RowObject.CodCli:SCREEN-VALUE
        S-TPOCMB = DECIMAL(RowObject.TpoCmb:SCREEN-VALUE)
        S-FmaPgo = RowObject.FmaPgo:SCREEN-VALUE
        s-Copia-Registro = NO
        s-PorIgv = DECIMAL(RowObject.porigv:SCREEN-VALUE)
        s-NroDec = (IF INTEGER(RowObject.Libre_d01:SCREEN-VALUE) <= 0 THEN 4 ELSE INTEGER(RowObject.Libre_d01:SCREEN-VALUE))
        s-FlgIgv = LOGICAL(RowObject.FlgIgv:SCREEN-VALUE)
        s-Import-IBC = NO
        s-Import-Cissac = NO
        s-adm-new-record = "NO"
        s-nroped = RowObject.nroped:SCREEN-VALUE
        S-CMPBNTE = RowObject.Cmpbnte:SCREEN-VALUE
        pFechaEntrega = DATE(RowObject.fchent:SCREEN-VALUE)
        S-TPOMARCO = RowObject.Libre_C04:SCREEN-VALUE.    /* CASO DE CLIENTES EXCEPCIONALES */

    IF RowObject.Libre_C05 = "1" THEN s-Import-Ibc = YES.
    IF RowObject.Libre_C05 = "2" THEN s-Import-Cissac = YES.
    /* RHC 07/12/2015 SEGUNDO CHEQUEO */
    IF s-import-ibc = YES AND s-pendiente-ibc = YES AND RowObject.flgest = 'P'
        THEN DO:
        MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    IF RowObject.Libre_c04 = "SI" AND RowObject.flgest = 'P' THEN DO:
        MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    /* ****************************** */
    RUN Carga-Temporal.
    /* Cargamos las condiciones de venta válidas */
    FIND gn-clie WHERE gn-clie.codcia  = cl-codcia
        AND gn-clie.codcli = s-codcli
        NO-LOCK.
    RUN vta2/p-fmapgo (s-codcli, s-tpoped, OUTPUT s-cndvta-validos).

    RUN Procesa-Handle IN lh_Handle ('Pagina2').
    RUN Procesa-Handle IN lh_Handle ('browse').
    RUN Procesa-Handle IN lh_handle ("Disable-Button-CISSAC").
    /* RHC 14/10/2013 ***************************************************************** */
    /* SOLO PARA PROVINCIAS VENTA LISTA GENERAL (LIMA)                                  */
    IF s-TpoPed = "P" THEN DO:
      FIND b-divi WHERE b-divi.codcia = s-codcia
          AND b-divi.coddiv = pCodDiv
          NO-LOCK NO-ERROR.
      IF AVAILABLE b-divi AND b-divi.VentaMayorista = 1 THEN DO:  /* LISTA GENERAL */
          RUN Procesa-Handle IN lh_Handle ('Pagina3').
      END.
    END.
    /* ******************************************************************************** */
    IF s-TpoPed = "LF" THEN RUN Procesa-Handle IN lh_Handle ('Pagina4').
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFields vTableWin 
PROCEDURE validateFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER pcNotValidFields AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cNewRecord AS CHARACTER NO-UNDO.
  DEFINE BUFFER b-gn-divi FOR gn-divi.     
  DEFINE BUFFER b-factabla FOR factabla.
  DEFINE BUFFER c-gn-divi FOR gn-divi.     

  cNewRecord = DYNAMIC-FUNCTION('getNewRecord':U).
  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE F-TOT AS DECIMAL INIT 0 NO-UNDO.
  DEFINE VARIABLE F-BOL AS DECIMAL INIT 0 NO-UNDO.
  DEFINE VAR ls-DiasVtoCot AS INT.
  DEFINE VAR lValidacionFeria AS LOG.
  DEFINE VAR lFechaDesde AS DATE.
  DEFINE VAR lFechaHasta AS DATE.
  DEFINE VAR lFechaControl AS DATE.
  DEFINE VAR lDias AS INT.
  DEFINE VAR lCotProcesada AS LOG.
  DEFINE VAR lUsrFchEnt AS CHAR.
  DEFINE VAR lValFecEntrega AS CHAR.
  DEFINE VAR lListaPrecio AS CHAR.
  DO WITH FRAME {&FRAME-NAME}:
      /* ************************************************************************* */
      /* VALIDACION DEL CLIENTE ************************************************** */
      /* ************************************************************************* */
      IF RowObject.CodCli:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Codigo de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO RowObject.CodCli.
         RETURN ERROR.   
      END.
      RUN vtagn/p-clie-expo (RowObject.CodCli:SCREEN-VALUE , s-tpoped, pCodDiv).
      IF RETURN-VALUE = "ADM-ERROR" THEN RETURN ERROR.
      RUN vtagn/p-gn-clie-01 (RowObject.CodCli:SCREEN-VALUE , s-coddoc).
      IF RETURN-VALUE = "ADM-ERROR" THEN RETURN ERROR.
      FIND gn-clie WHERE gn-clie.codcia = cl-codcia
          AND gn-clie.codcli = RowObject.codcli:SCREEN-VALUE
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-clie THEN DO:
          MESSAGE 'Cliente No registrado' VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO RowObject.Glosa.
          RETURN ERROR.
      END.
      IF RowObject.CodCli:SCREEN-VALUE  = '11111111112'
          AND RowObject.FmaPgo:SCREEN-VALUE = '900' 
          AND RowObject.NroCard:SCREEN-VALUE = '' THEN DO:
          MESSAGE "Ingrese el numero de tarjeta" VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO RowObject.NroCard.
          RETURN ERROR.   
      END.
      /* CONTRATO MARCO -> CHEQUEO DE CANAL */
      IF s-TpoPed = "M" AND gn-clie.canal <> '006' THEN DO:
          MESSAGE 'Cliente no permitido en este canal de venta de venta'
             VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO RowObject.CodCli.
         RETURN ERROR.   
     END.
     IF RowObject.Cmpbnte:SCREEN-VALUE = "FAC" AND RowObject.RucCli:SCREEN-VALUE = '' THEN DO:
        MESSAGE "El Cliente NO tiene R.U.C." VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO RowObject.CodCli.
        RETURN ERROR.   
     END.      
     IF RowObject.Cmpbnte:SCREEN-VALUE = "FAC" THEN DO:
         IF LENGTH(RowObject.RucCli:SCREEN-VALUE) < 11 THEN DO:
             MESSAGE 'El RUC debe tener 11 dígitos' VIEW-AS ALERT-BOX ERROR.
             APPLY 'ENTRY':U TO RowObject.CodCli.
             RETURN ERROR.
         END.
         IF LOOKUP(SUBSTRING(RowObject.RucCli:SCREEN-VALUE,1,2), '20,15,17,10') = 0 THEN DO:
             MESSAGE 'El RUC debe comenzar con 10,15,17 ó 20' VIEW-AS ALERT-BOX ERROR.
             APPLY 'ENTRY':U TO RowObject.CodCli.
             RETURN ERROR.
         END.
         /* dígito verificador */
         DEF VAR pResultado AS CHAR NO-UNDO.
         RUN lib/_ValRuc (RowObject.RucCli:SCREEN-VALUE, OUTPUT pResultado).
         IF pResultado = 'ERROR' THEN DO:
             MESSAGE 'Código RUC MAL registrado' VIEW-AS ALERT-BOX WARNING.
             APPLY 'ENTRY':U TO RowObject.CodCli.
             RETURN ERROR.
         END.
     END.
     /* ************************************************************************* */
     /* rhc 22.06.09 Control de Precios IBC ************************************* */
     /* ************************************************************************* */
     IF s-Import-IBC = YES THEN DO:
         RUN CONTROL-IBC.
         IF RETURN-VALUE = "ADM-ERROR" THEN RETURN ERROR.
     END.
      /* ************************************************************************* */
     /* RHC 23.06.10 Control de sedes por autoservicios
          Los clientes deben estar inscritos en la opcion DESCUENTOS E INCREMENTOS */
      /* ************************************************************************* */
     FIND FacTabla WHERE FacTabla.codcia = s-codcia
         AND FacTabla.Tabla = 'AU'
         AND FacTabla.Codigo = RowObject.codcli:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE FacTabla AND RowObject.Sede:SCREEN-VALUE = '' THEN DO:
         MESSAGE 'Debe registrar la sede para este cliente' VIEW-AS ALERT-BOX ERROR.
         APPLY 'ENTRY':U TO RowObject.Sede.
         RETURN ERROR.
     END.
     IF RowObject.Sede:SCREEN-VALUE <> '' THEN DO:
         FIND Gn-clied OF Gn-clie WHERE Gn-clied.Sede = RowObject.Sede:SCREEN-VALUE NO-LOCK NO-ERROR.
          IF NOT AVAILABLE gn-clied THEN DO:
              MESSAGE 'Sede no registrada para este cliente' VIEW-AS ALERT-BOX ERROR.
              APPLY 'ENTRY':U TO RowObject.Sede.
              RETURN ERROR.
          END.
     END.
     /* ************************************************************************* */
     /* VALIDACION DEL VENDEDOR ************************************************* */
     /* ************************************************************************* */
     IF RowObject.CodVen:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Codigo de Vendedor no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO RowObject.CodVen.
        RETURN ERROR.   
     END.
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
         AND  gn-ven.CodVen = RowObject.CodVen:SCREEN-VALUE 
         NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gn-ven THEN DO:
        MESSAGE "Codigo de Vendedor no existe" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO RowObject.CodVen.
        RETURN ERROR.   
     END.
     ELSE DO:
         IF gn-ven.flgest = "C" THEN DO:
             MESSAGE "Codigo de Vendedor Cesado" VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO RowObject.CodVen.
             RETURN ERROR.   
         END.
     END.
     /* ************************************************************************* */
     /* VALIDACION DE LA CONDICION DE VENTA ************************************* */    
     /* ************************************************************************* */
     IF RowObject.FmaPgo:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Condicion Venta no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO RowObject.FmaPgo.
        RETURN ERROR.   
     END.
     FIND gn-convt WHERE gn-convt.Codig = RowObject.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gn-convt THEN DO:
        MESSAGE "Condicion Venta no existe" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO RowObject.FmaPgo.
        RETURN ERROR.   
     END.
     IF RowObject.FmaPgo:SCREEN-VALUE  = '900'
         AND RowObject.CodCli:SCREEN-VALUE  <> '11111111112'
         AND RowObject.NroCard:SCREEN-VALUE <> '' THEN DO:
         MESSAGE "En caso de transferencia gratuita NO es válido el Nº de Tarjeta" 
             VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO RowObject.NroCard.
         RETURN ERROR.   
     END.
     /* Ic - 28Ene2016, Para la VU (Vales Utilex, condicion de venta debe ser FAI */
     IF s-tpoped = 'VU' THEN DO:
         IF gn-convt.libre_l01 <> YES THEN DO:
             MESSAGE "Condicion Venta debe aceptar FAI" VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO RowObject.FmaPgo.
             RETURN ERROR.   
         END.
     END.
     /* RHC 09/05/2014 SOLO condiciones de ventas válidas */
     IF gn-convt.Estado <> "A" THEN DO:
         MESSAGE "Condición Venta Inactiva" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO RowObject.FmaPgo.
         RETURN ERROR.   
     END.
     /* RHC 12/11/2015 Correo de Susana León */
     IF INPUT RowObject.CodCli = x-ClientesVarios AND INPUT RowObject.FmaPgo <> '000'
         THEN DO:
         MESSAGE 'Solo se permite la Condición de Venta 000' VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO RowObject.CodCli.
         RETURN ERROR.   
     END.
     /* RHC 21.08.2014 Control de FAI */
     FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.
     IF gn-convt.Libre_L01 = YES AND gn-divi.FlgRep = NO THEN DO:
         MESSAGE 'Condición de venta NO válida para esta división' VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO RowObject.FmaPgo.
         RETURN ERROR.   
     END.
     /* Ic - 28Ene2016, Para la VU (Vales Utilex, la division debe aceptar FAI */
     IF s-tpoped = 'VU' THEN DO:
         IF gn-divi.FlgRep <> YES THEN DO:
             MESSAGE "La division debe aceptar FAI" VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO RowObject.FmaPgo.
             RETURN ERROR.   
         END.
     END.
     /* ************************************************************************* */
     /* VALIDACION DE FECHAS **************************************************** */
     /* Ic 26Oct2015 */
     /* ************************************************************************* */
     IF LOOKUP(cNewRecord,'Add,Copy') > 0 THEN DO:
         IF INPUT RowObject.FchEnt < TODAY THEN DO:
             MESSAGE 'La fecha de entrega debe ser mayor al de HOY' VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO RowObject.FchEnt.
             RETURN ERROR.   
         END.
     END.
     IF INPUT RowObject.FchVen < INPUT RowObject.fchped THEN DO:
         MESSAGE 'Ingrese correctamente la fecha de vencimiento' VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO RowObject.FchVen.
         RETURN ERROR.   
     END.
     IF INPUT RowObject.FchEnt < INPUT RowObject.fchped THEN DO:
         MESSAGE 'Ingrese correctamente la fecha de entrega' VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO RowObject.FchEnt.
         RETURN ERROR.   
     END.
     /* Ic - 26Oct2015 - Validar para FERIAS contra la Lista de Precios */ 
     ls-DiasVtoCot = s-DiasVtoCot.
     IF RowObject.libre_c01:SCREEN-VALUE <> ? THEN DO:
         FIND FIRST b-gn-divi WHERE b-gn-divi.codcia = s-codcia
             AND b-gn-divi.coddiv = RowObject.libre_c01:SCREEN-VALUE NO-LOCK NO-ERROR.
         IF AVAILABLE b-gn-divi THEN ls-DiasVtoCot = b-GN-DIVI.DiasVtoCot.
     END.
     /* RHC 17/02/2015 VALIDACION FECHA VENCIMIENTO */
     IF INPUT RowObject.FchVen - INPUT RowObject.fchped > ls-DiasVtoCot THEN DO:
         MESSAGE 'La fecha de vencimiento no puede ser mayor a' s-DiasVtoCot 'días' VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO RowObject.FchVen.
         RETURN ERROR.
     END.
     /* ************************************************************************* */
     /* VALIDACION DE LA TARJETA ************************************************ */
     /* ************************************************************************* */
     IF RowObject.NroCar:SCREEN-VALUE <> "" THEN DO:
         FIND Gn-Card WHERE Gn-Card.NroCard = RowObject.NroCar:SCREEN-VALUE
             NO-LOCK NO-ERROR.
         IF NOT AVAILABLE Gn-Card THEN DO:
             MESSAGE "Numero de Tarjeta Incorrecto, Verifique... " VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO RowObject.NroCar.
             RETURN ERROR.   
         END.   
     END.           
     /* ************************************************************************* */
     /* VALIDACION DE AFECTO A IGV ********************************************** */
     /* ************************************************************************* */
     IF s-flgigv = NO THEN DO:
         MESSAGE 'La cotización NO ESTA AFECTA A IGV' SKIP
             'Es eso correcto?'
             VIEW-AS ALERT-BOX QUESTION
             BUTTONS YES-NO UPDATE rpta AS LOG.
         IF rpta = NO THEN RETURN ERROR.
     END.
     /* ************************************************************************* */
     /* VALIDACION DEL CODIGO POSTAL ******************************************** */
     /* ************************************************************************* */
     IF s-TpoPed = "E" THEN DO:
         IF RowObject.CodPos:SCREEN-VALUE = '' THEN DO:
             MESSAGE 'Ingrese el código postal' VIEW-AS ALERT-BOX ERROR.
             APPLY 'ENTRY':U TO RowObject.CodPos.
             RETURN ERROR.
         END.
         FIND almtabla WHERE almtabla.tabla = 'CP' 
             AND almtabla.codigo = RowObject.CodPos:SCREEN-VALUE
             NO-LOCK NO-ERROR.
         IF NOT AVAILABLE almtabla THEN DO:
             MESSAGE 'Código Postal no Registrado' VIEW-AS ALERT-BOX ERROR.
             APPLY 'ENTRY':U TO RowObject.CodPos.
             RETURN ERROR.
         END.
     END.
     /* ************************************************************************* */
     /* VALIDACION DE ITEMS ***************************************************** */
     /* ************************************************************************* */
/*      FOR EACH ITEM NO-LOCK:                                                    */
/*          F-Tot = F-Tot + ITEM.ImpLin.                                          */
/*      END.                                                                      */
/*      IF F-Tot = 0 THEN DO:                                                     */
/*         MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR. */
/*         APPLY "ENTRY" TO RowObject.CodCli.                                     */
/*         RETURN ERROR.                                                          */
/*      END.                                                                      */
/*                                                                                */
/*     /* RHC 02/03/2016 Restricciones hasta el 31/03/2016 */                     */
/*     {vta2/i-temporal-mayorista.i ITEM}                                         */
    /* ************************************************ */

     /* VALIDACION DE MONTO MINIMO POR BOLETA */
     F-BOL = IF INTEGER(RowObject.CodMon:SCREEN-VALUE) = 1 
         THEN F-TOT
         ELSE F-Tot * DECIMAL(RowObject.TpoCmb:SCREEN-VALUE).
     IF RowObject.Cmpbnte:SCREEN-VALUE = 'BOL' AND F-BOL > ImpMinDNI 
         AND (RowObject.Atencion:SCREEN-VALUE = '' OR LENGTH(RowObject.Atencion:SCREEN-VALUE, "CHARACTER") < 8)
     THEN DO:
         MESSAGE "Venta Mayor a" ImpMinDNI SKIP
                 "Debe ingresar en DNI"
             VIEW-AS ALERT-BOX ERROR.
         APPLY 'ENTRY':U TO RowObject.Atencion.
         RETURN ERROR.   
     END.
     /* VALIDACION DE IMPORTE MINIMO POR COTIZACION */
     DEF VAR pImpMin AS DEC NO-UNDO.
     RUN gn/pMinCotPed (s-CodCia,
                        s-CodDiv,
                        s-CodDoc,
                        OUTPUT pImpMin).
     IF pImpMin > 0 AND f-Bol < pImpMin THEN DO:
         MESSAGE 'El importe mínimo para cotizar es de S/.' pImpMin
             VIEW-AS ALERT-BOX ERROR.
         RETURN ERROR.
     END.
     /* ************************************************************************* */
     /* OTRAS VALIDACIONES *****/
     /* ************************************************************************* */
     /* Ic - 06Nov2015 - Validar fecha de entrega no interfiera con la programacion de LUCY MESIA */
     /* Ic - Que usuarios no validar fecha de entrega */
     RLOOP:
     DO:
         lUsrFchEnt = "".
         lValFecEntrega = ''.
         FIND FIRST b-factabla WHERE b-factabla.codcia = s-codcia 
             AND b-factabla.tabla = 'VALIDA' 
             AND b-factabla.codigo = 'FCHENT' NO-LOCK NO-ERROR.
         IF AVAILABLE b-factabla THEN DO:
             lUsrFchEnt      = b-factabla.campo-c[1].  /* Usuarios Exceptuados de la Validacion */
             lValFecEntrega  = b-factabla.campo-c[2].  /* Valida Si o NO */
         END.
         IF lValFecEntrega = 'NO' OR LOOKUP(s-user-id,lusrFchEnt) > 0 THEN DO:
             /* No requiere validacion o El usuario esta inscrito para no validar la fecha de entrega */
            LEAVE RLOOP.    /* OJO -> Sale del DO */
         END.
         lValidacionFeria = NO.
         lListaPrecio = IF(RowObject.libre_c01:SCREEN-VALUE = ? OR RowObject.libre_c01:SCREEN-VALUE = "") 
             THEN pCodDiv ELSE RowObject.libre_c01:SCREEN-VALUE.
         IF lListaPrecio <> ? THEN DO:
             FIND FIRST c-gn-divi WHERE c-gn-divi.coddiv = lListaPrecio NO-LOCK NO-ERROR.
             IF AVAILABLE c-gn-divi THEN DO:
                 /* Si es FERIA */
                 IF c-gn-divi.canalventa = 'FER' THEN DO:
                     lValidacionFeria = YES.
                 END.
             END.
         END.
         IF lValidacionFeria = YES THEN DO:
            /* Las fecha del PROCESO de Lucy mesia */
             lValidacionFeria = NO.
             FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                                        vtatabla.tabla = 'DSTRB' AND 
                                        vtatabla.llave_c1 = '2016' NO-LOCK NO-ERROR.
             IF AVAILABLE vtatabla THEN DO:
                lValidacionFeria = YES.
                lDias = vtatabla.valor[1].
                IF lDias = 0 THEN lDias = 1000. /* Sin Limite */
                lFechaDesde = vtatabla.rango_fecha[1].
                lFechaHasta = vtatabla.rango_fecha[2].
             END.
         END.

         DEFINE VAR lDiviExononeradas AS CHAR.
         /* Ic - 11Ene2017, solo para ferias de LIMA, segun E.Macchiu  */
         lDiviExononeradas = "10015,20015,00015,50015".
         IF LOOKUP(lListaPrecio,lDiviExononeradas) = 0 THEN lValidacionFeria = NO.
         IF lValidacionFeria = YES THEN DO:
             lCotProcesada = NO.        
             IF LOOKUP(cNewRecord, 'Add,Copy') > 0 THEN DO:
                 lFechaControl = lFechaHasta.
                 IF INPUT RowObject.FchEnt < lFechaControl THEN DO:
                     MESSAGE 'La fecha de entrega no debe estar dentro de la PROGRAMACION DE ABASTECIMIENTO(1) ' VIEW-AS ALERT-BOX ERROR.
                     APPLY "ENTRY" TO RowObject.FchEnt.
                     RETURN ERROR.   
                 END.    
                 pFechaEntrega = INPUT RowObject.Fchent.
             END.
             ELSE DO:                
                 /* Pregunta x el campo de RUBEN */
                 IF RowObject.libre_c02 = 'PROCESADA' THEN DO:
                    lCotProcesada = YES.
                 END.
                 IF TODAY < 11/15/2015 THEN lCotProcesada = YES.
             END.
             lFechaControl = lFechaHasta.
             IF lCotProcesada = NO AND INPUT RowObject.FchEnt <> pFechaEntrega  THEN DO:
                 IF INPUT RowObject.FchEnt <= lFechaControl THEN DO:
                     MESSAGE 'La fecha de entrega no debe estar dentro de la PROGRAMACION DE ABASTECIMIENTO(2) ' VIEW-AS ALERT-BOX ERROR.
                     RETURN ERROR.   
                 END.
             END.
         END.
     END.
  END.

  RUN SUPER( INPUT-OUTPUT pcNotValidFields).

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

