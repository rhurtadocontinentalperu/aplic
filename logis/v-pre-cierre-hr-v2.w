&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-DI-RutaC FOR DI-RutaC.
DEFINE BUFFER B-DI-RutaD FOR DI-RutaD.
DEFINE BUFFER B-Di-RutaDG FOR Di-RutaDG.
DEFINE BUFFER B-Di-RutaG FOR Di-RutaG.
DEFINE BUFFER FACTURA FOR CcbCDocu.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
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
{src/bin/_prns.i}

/* Local Variable Definitions ---                                       */
def var hora1 as char.
def var hora2 as char.
def var x-seg as char.
DEF SHARED VAR s-codcia   AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-nomcia   AS CHAR.
DEF SHARED VAR s-coddoc   AS CHAR.
DEF SHARED VAR s-coddiv   AS CHAR.
DEF SHARED VAR S-DESALM  AS CHARACTER.
DEF SHARED VAR s-user-id  AS CHAR.
DEF SHARED VAR lh_Handle  AS HANDLE.
/* Nos sirve para definir el origen de la H/R */
DEF SHARED VAR s-HR-Manual AS LOG NO-UNDO.
DEF SHARED VAR s-Dias-Limite AS INT NO-UNDO.    /* Dias H/R Pendientes */

DEF VAR x-NroDoc LIKE di-rutac.nrodoc.

DEFINE VAR s-task-no AS INT.
DEF VAR x-Bultos AS INT NO-UNDO.
DEF VAR f-Bultos AS INT NO-UNDO.

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "aplic/alm/rbalm.prl".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Hoja Ruta2".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

/* capturamos ruta inicial */
DEF VAR S-REPORT-LIBRARY AS CHAR.
GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE s-report-library.
RB-REPORT-LIBRARY = s-report-library + "alm\rbalm.prl".

DEFINE TEMP-TABLE tt-qttys
            FIELDS tt-tipo AS CHAR FORMAT "X(3)"
            FIELDS tt-clave1 AS CHAR FORMAT "X(11)"
            INDEX idx01 IS PRIMARY tt-tipo tt-clave1.

DEFINE TEMP-TABLE tt-paletas
    FIELDS tt-division AS CHAR FORMAT "x(10)"
    FIELDS tt-paleta AS CHAR FORMAT "x(20)"
    INDEX idx01 IS PRIMARY tt-paleta.


DEFINE SHARED VARIABLE pRCID AS INT.

/* Control de copia de cabecera */
DEF VAR cNroRef LIKE DI-RutaC.NroDoc NO-UNDO.

/* Para validar H/R pendientes */
DEFINE BUFFER x-di-rutaC FOR di-rutaC.
DEFINE BUFFER x-di-rutaD FOR di-rutaD.
DEFINE BUFFER x-faccpedi FOR faccpedi.

/*  */
DEFINE TEMP-TABLE ttTotales
    FIELDS  tCodDoc     AS  CHAR    FORMAT 'x(5)'
    FIELDS  tnroDoc     AS  CHAR    FORMAT 'x(15)'.

/* Motivo de CONFIRMACION de HOJA DE RUTA */
DEFINE VAR x-GlosaAprobacion LIKE DI-RutaC.GlosaAprobacion NO-UNDO.
DEFINE VAR x-UsrAprobacion LIKE DI-RutaC.UsrAprobacion NO-UNDO.
DEFINE VAR x-FchAprobacion LIKE DI-RutaC.FchAprobacion NO-UNDO.

DEFINE VAR x-GlosaApertura LIKE DI-RutaC.GlosaApertura NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES DI-RutaC
&Scoped-define FIRST-EXTERNAL-TABLE DI-RutaC


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR DI-RutaC.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS DI-RutaC.CodVeh DI-RutaC.FchSal ~
DI-RutaC.FchRet DI-RutaC.ayudante-1 DI-RutaC.ayudante-2 DI-RutaC.Ayudante-3 ~
DI-RutaC.Ayudante-4 DI-RutaC.Ayudante-5 DI-RutaC.Ayudante-6 ~
DI-RutaC.Ayudante-7 
&Scoped-define ENABLED-TABLES DI-RutaC
&Scoped-define FIRST-ENABLED-TABLE DI-RutaC
&Scoped-Define ENABLED-OBJECTS RECT-15 
&Scoped-Define DISPLAYED-FIELDS DI-RutaC.NroDoc DI-RutaC.Libre_l01 ~
DI-RutaC.Libre_c03 DI-RutaC.FchDoc DI-RutaC.CodVeh DI-RutaC.TpoTra ~
DI-RutaC.usuario DI-RutaC.FchSal DI-RutaC.Libre_d05 DI-RutaC.Libre_c05 ~
DI-RutaC.Libre_f05 DI-RutaC.FchRet DI-RutaC.responsable ~
DI-RutaC.TipResponsable DI-RutaC.KmtIni DI-RutaC.ayudante-1 ~
DI-RutaC.TipAyudante-1 DI-RutaC.ayudante-2 DI-RutaC.TipAyudante-2 ~
DI-RutaC.Ayudante-3 DI-RutaC.TipAyudante-3 DI-RutaC.Libre_c01 ~
DI-RutaC.Ayudante-4 DI-RutaC.TipAyudante-4 DI-RutaC.DesRut ~
DI-RutaC.Ayudante-5 DI-RutaC.TipAyudante-5 DI-RutaC.Ayudante-6 ~
DI-RutaC.TipAyudante-6 DI-RutaC.Ayudante-7 DI-RutaC.TipAyudante-7 
&Scoped-define DISPLAYED-TABLES DI-RutaC
&Scoped-define FIRST-DISPLAYED-TABLE DI-RutaC
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Estado FILL-IN-Marca txtHora ~
txtMinuto txtHora-Ret txtMinuto-Ret FILL-IN-Responsable FILL-IN-Ayudante-1 ~
txtCodPro txtDTrans FILL-IN-Ayudante-2 txtSerie txtNro FILL-IN-Ayudante-3 ~
txtConductor FILL-IN-Ayudante-4 FILL-IN-Ayudante-5 FILL-IN-Ayudante-6 ~
FILL-IN-Ayudante-7 txtCargaMaxima txtPeso txtNroClientes txtClieSol ~
txtClieDol txtVolumen txtVol txtPtosAlmacen txtTranSol txtTranDol 

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
DEFINE VARIABLE FILL-IN-Ayudante-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Ayudante-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Ayudante-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Ayudante-4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Ayudante-5 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Ayudante-6 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Ayudante-7 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "Situacion" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-Marca AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 18 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Responsable AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .81 NO-UNDO.

DEFINE VARIABLE txtCargaMaxima AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Carga Max." 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81
     FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE VARIABLE txtClieDol AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "$." 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .81 NO-UNDO.

DEFINE VARIABLE txtClieSol AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "S/." 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .81 NO-UNDO.

DEFINE VARIABLE txtCodPro AS CHARACTER FORMAT "X(10)":U 
     LABEL "Emp.Transp." 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE txtConductor AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42.14 BY .81 NO-UNDO.

DEFINE VARIABLE txtDTrans AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .81 NO-UNDO.

DEFINE VARIABLE txtHora AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "HH" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .81
     BGCOLOR 11 .

DEFINE VARIABLE txtHora-Ret AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "HH" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .81
     BGCOLOR 11 .

DEFINE VARIABLE txtMinuto AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "MM" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .81
     BGCOLOR 11 .

DEFINE VARIABLE txtMinuto-Ret AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "MM" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .81
     BGCOLOR 11 .

DEFINE VARIABLE txtNro AS INTEGER FORMAT ">>>>>>>9":U INITIAL 0 
     LABEL "Nro" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 11 FGCOLOR 0 .

DEFINE VARIABLE txtNroClientes AS INTEGER FORMAT ">,>>9":U INITIAL 0 
     LABEL "Cant. Clientes" 
     VIEW-AS FILL-IN 
     SIZE 4.43 BY .81
     BGCOLOR 15 FGCOLOR 1 FONT 6 NO-UNDO.

DEFINE VARIABLE txtPeso AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Peso" 
     VIEW-AS FILL-IN 
     SIZE 11.57 BY .81
     FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE VARIABLE txtPtosAlmacen AS INTEGER FORMAT ">,>>9":U INITIAL 0 
     LABEL "Cant. Alm" 
     VIEW-AS FILL-IN 
     SIZE 4.43 BY .81
     BGCOLOR 15 FGCOLOR 1 FONT 10 NO-UNDO.

DEFINE VARIABLE txtSerie AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Guia Transp. Serie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81
     BGCOLOR 11 FGCOLOR 0 .

DEFINE VARIABLE txtTranDol AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "$." 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .81 NO-UNDO.

DEFINE VARIABLE txtTranSol AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "S/." 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .81 NO-UNDO.

DEFINE VARIABLE txtVol AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Vol." 
     VIEW-AS FILL-IN 
     SIZE 11.57 BY .81
     FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE VARIABLE txtVolumen AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Volumen (m3)" 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .81
     FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 139 BY 2.15.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     DI-RutaC.NroDoc AT ROW 1 COL 16 COLON-ALIGNED
          LABEL "Nº de Hoja"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     DI-RutaC.Libre_l01 AT ROW 1 COL 31 WIDGET-ID 68
          LABEL "Confirmado"
          VIEW-AS TOGGLE-BOX
          SIZE 11.29 BY .77
          BGCOLOR 14 FGCOLOR 0 
     DI-RutaC.Libre_c03 AT ROW 1 COL 42 COLON-ALIGNED NO-LABEL WIDGET-ID 76 FORMAT "x(15)"
          VIEW-AS FILL-IN 
          SIZE 19 BY .81
     DI-RutaC.FchDoc AT ROW 1 COL 73 COLON-ALIGNED
          LABEL "Fecha Emision"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FILL-IN-Estado AT ROW 1 COL 99 COLON-ALIGNED
     DI-RutaC.CodVeh AT ROW 1.81 COL 16 COLON-ALIGNED
          LABEL "Placa del vehiculo" FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     FILL-IN-Marca AT ROW 1.81 COL 25 COLON-ALIGNED NO-LABEL
     DI-RutaC.TpoTra AT ROW 1.81 COL 51 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Propio", "01":U,
"Externo", "02":U
          SIZE 16 BY .77
     DI-RutaC.usuario AT ROW 1.81 COL 99 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 15 FGCOLOR 12 
     DI-RutaC.FchSal AT ROW 2.62 COL 16 COLON-ALIGNED
          LABEL "Fec. Salida Vehic."
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 
     txtHora AT ROW 2.62 COL 30 COLON-ALIGNED WIDGET-ID 2
     txtMinuto AT ROW 2.62 COL 37 COLON-ALIGNED WIDGET-ID 4
     DI-RutaC.Libre_d05 AT ROW 2.62 COL 73 COLON-ALIGNED WIDGET-ID 114
          LABEL "Estibadores Adicionales" FORMAT ">9"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "0","1","2","3" 
          DROP-DOWN-LIST
          SIZE 6 BY 1
          BGCOLOR 0 FGCOLOR 14 
     DI-RutaC.Libre_c05 AT ROW 2.62 COL 99 COLON-ALIGNED WIDGET-ID 70
          LABEL "Modificado por" FORMAT "x(10)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     DI-RutaC.Libre_f05 AT ROW 2.62 COL 114 COLON-ALIGNED WIDGET-ID 72
          LABEL "Día"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     DI-RutaC.FchRet AT ROW 3.42 COL 16 COLON-ALIGNED WIDGET-ID 116
          LABEL "Fec. Retorno Vehic." FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 
     txtHora-Ret AT ROW 3.42 COL 30 COLON-ALIGNED WIDGET-ID 118
     txtMinuto-Ret AT ROW 3.42 COL 37 COLON-ALIGNED WIDGET-ID 120
     DI-RutaC.responsable AT ROW 3.69 COL 81 COLON-ALIGNED
          LABEL "Responsable" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     FILL-IN-Responsable AT ROW 3.69 COL 92 COLON-ALIGNED NO-LABEL
     DI-RutaC.TipResponsable AT ROW 3.69 COL 127 COLON-ALIGNED NO-LABEL WIDGET-ID 112
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     DI-RutaC.KmtIni AT ROW 4.23 COL 16 COLON-ALIGNED
          LABEL "Kilometraje de salida" FORMAT ">>>,>>9"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     DI-RutaC.ayudante-1 AT ROW 4.5 COL 81 COLON-ALIGNED
          LABEL "Ayudante 1" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 11 
     FILL-IN-Ayudante-1 AT ROW 4.5 COL 92 COLON-ALIGNED NO-LABEL
     DI-RutaC.TipAyudante-1 AT ROW 4.5 COL 127 COLON-ALIGNED NO-LABEL WIDGET-ID 98
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     txtCodPro AT ROW 5.04 COL 16 COLON-ALIGNED WIDGET-ID 32
     txtDTrans AT ROW 5.04 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     DI-RutaC.ayudante-2 AT ROW 5.31 COL 81 COLON-ALIGNED
          LABEL "Ayudante 2" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 11 
     FILL-IN-Ayudante-2 AT ROW 5.31 COL 92 COLON-ALIGNED NO-LABEL
     DI-RutaC.TipAyudante-2 AT ROW 5.31 COL 127 COLON-ALIGNED NO-LABEL WIDGET-ID 100
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     txtSerie AT ROW 5.85 COL 16 COLON-ALIGNED WIDGET-ID 16
     txtNro AT ROW 5.85 COL 25 COLON-ALIGNED WIDGET-ID 18
     DI-RutaC.Ayudante-3 AT ROW 6.12 COL 81 COLON-ALIGNED WIDGET-ID 78
          LABEL "Ayudante 3" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 11 
     FILL-IN-Ayudante-3 AT ROW 6.12 COL 92 COLON-ALIGNED NO-LABEL WIDGET-ID 88
     DI-RutaC.TipAyudante-3 AT ROW 6.12 COL 127 COLON-ALIGNED NO-LABEL WIDGET-ID 102
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     DI-RutaC.Libre_c01 AT ROW 6.65 COL 16 COLON-ALIGNED WIDGET-ID 64
          LABEL "Conductor (Licencia)" FORMAT "x(10)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     txtConductor AT ROW 6.65 COL 27.86 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     DI-RutaC.Ayudante-4 AT ROW 6.92 COL 81 COLON-ALIGNED WIDGET-ID 80
          LABEL "Ayudante 4" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 11 
     FILL-IN-Ayudante-4 AT ROW 6.92 COL 92 COLON-ALIGNED NO-LABEL WIDGET-ID 90
     DI-RutaC.TipAyudante-4 AT ROW 6.92 COL 127 COLON-ALIGNED NO-LABEL WIDGET-ID 104
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     DI-RutaC.DesRut AT ROW 7.46 COL 18 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 200 SCROLLBAR-VERTICAL
          SIZE 54 BY 2.69
     DI-RutaC.Ayudante-5 AT ROW 7.73 COL 81 COLON-ALIGNED WIDGET-ID 82
          LABEL "Ayudante 5" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 11 
     FILL-IN-Ayudante-5 AT ROW 7.73 COL 92 COLON-ALIGNED NO-LABEL WIDGET-ID 92
     DI-RutaC.TipAyudante-5 AT ROW 7.73 COL 127 COLON-ALIGNED NO-LABEL WIDGET-ID 106
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     DI-RutaC.Ayudante-6 AT ROW 8.54 COL 81 COLON-ALIGNED WIDGET-ID 84
          LABEL "Ayudante 6" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 11 
     FILL-IN-Ayudante-6 AT ROW 8.54 COL 92 COLON-ALIGNED NO-LABEL WIDGET-ID 94
     DI-RutaC.TipAyudante-6 AT ROW 8.54 COL 127 COLON-ALIGNED NO-LABEL WIDGET-ID 108
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     DI-RutaC.Ayudante-7 AT ROW 9.35 COL 81 COLON-ALIGNED WIDGET-ID 86
          LABEL "Ayudante 7" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 11 
     FILL-IN-Ayudante-7 AT ROW 9.35 COL 92 COLON-ALIGNED NO-LABEL WIDGET-ID 96
     DI-RutaC.TipAyudante-7 AT ROW 9.35 COL 127 COLON-ALIGNED NO-LABEL WIDGET-ID 110
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     txtCargaMaxima AT ROW 10.69 COL 16 COLON-ALIGNED WIDGET-ID 40
     txtPeso AT ROW 10.69 COL 30 COLON-ALIGNED WIDGET-ID 56
     txtNroClientes AT ROW 10.69 COL 54 COLON-ALIGNED WIDGET-ID 42
     txtClieSol AT ROW 10.69 COL 64 COLON-ALIGNED WIDGET-ID 48
     txtClieDol AT ROW 10.69 COL 79 COLON-ALIGNED WIDGET-ID 46
     txtVolumen AT ROW 11.5 COL 16 COLON-ALIGNED WIDGET-ID 54
     txtVol AT ROW 11.5 COL 30 COLON-ALIGNED WIDGET-ID 58
     txtPtosAlmacen AT ROW 11.5 COL 54 COLON-ALIGNED WIDGET-ID 44
     txtTranSol AT ROW 11.5 COL 64 COLON-ALIGNED WIDGET-ID 52
     txtTranDol AT ROW 11.5 COL 79 COLON-ALIGNED WIDGET-ID 50
     "Estado:" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 2 COL 46
     "Detalle de la ruta:" VIEW-AS TEXT
          SIZE 12 BY .5 AT ROW 7.65 COL 6
     "(formato de 24 horas)" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 3.69 COL 42 WIDGET-ID 122
     "(formato de 24 horas)" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 2.88 COL 42
     RECT-15 AT ROW 10.42 COL 1 WIDGET-ID 74
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.DI-RutaC
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-DI-RutaC B "?" ? INTEGRAL DI-RutaC
      TABLE: B-DI-RutaD B "?" ? INTEGRAL DI-RutaD
      TABLE: B-Di-RutaDG B "?" ? INTEGRAL Di-RutaDG
      TABLE: B-Di-RutaG B "?" ? INTEGRAL Di-RutaG
      TABLE: FACTURA B "?" ? INTEGRAL CcbCDocu
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
         HEIGHT             = 11.62
         WIDTH              = 141.14.
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

/* SETTINGS FOR FILL-IN DI-RutaC.ayudante-1 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN DI-RutaC.ayudante-2 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN DI-RutaC.Ayudante-3 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN DI-RutaC.Ayudante-4 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN DI-RutaC.Ayudante-5 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN DI-RutaC.Ayudante-6 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN DI-RutaC.Ayudante-7 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN DI-RutaC.CodVeh IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR EDITOR DI-RutaC.DesRut IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN DI-RutaC.FchDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN DI-RutaC.FchRet IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN DI-RutaC.FchSal IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Ayudante-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Ayudante-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Ayudante-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Ayudante-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Ayudante-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Ayudante-6 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Ayudante-7 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Marca IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Responsable IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN DI-RutaC.KmtIni IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN DI-RutaC.Libre_c01 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN DI-RutaC.Libre_c03 IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN DI-RutaC.Libre_c05 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR COMBO-BOX DI-RutaC.Libre_d05 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN DI-RutaC.Libre_f05 IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX DI-RutaC.Libre_l01 IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN DI-RutaC.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN DI-RutaC.responsable IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN DI-RutaC.TipAyudante-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN DI-RutaC.TipAyudante-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN DI-RutaC.TipAyudante-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN DI-RutaC.TipAyudante-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN DI-RutaC.TipAyudante-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN DI-RutaC.TipAyudante-6 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN DI-RutaC.TipAyudante-7 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN DI-RutaC.TipResponsable IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET DI-RutaC.TpoTra IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtCargaMaxima IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtClieDol IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtClieSol IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtCodPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtConductor IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtDTrans IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtHora IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtHora-Ret IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtMinuto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtMinuto-Ret IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtNro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtNroClientes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtPeso IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtPtosAlmacen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtSerie IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtTranDol IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtTranSol IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtVol IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtVolumen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN DI-RutaC.usuario IN FRAME F-Main
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

&Scoped-define SELF-NAME DI-RutaC.ayudante-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DI-RutaC.ayudante-1 V-table-Win
ON LEAVE OF DI-RutaC.ayudante-1 IN FRAME F-Main /* Ayudante 1 */
DO:
  FILL-IN-Ayudante-1:SCREEN-VALUE = ''.
  IF SELF:SCREEN-VALUE = '' THEN RETURN.

  DEF VAR pNombre AS CHAR NO-UNDO.
  DEF VAR pOrigen AS CHAR NO-UNDO.

  RUN logis/p-busca-por-dni ( INPUT SELF:SCREEN-VALUE,
                              OUTPUT pNombre,
                              OUTPUT pOrigen).
  IF pOrigen = "ERROR" THEN DO:
      MESSAGE 'DNI inválido' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  DISPLAY pNombre @  FILL-IN-Ayudante-1 WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DI-RutaC.ayudante-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DI-RutaC.ayudante-2 V-table-Win
ON LEAVE OF DI-RutaC.ayudante-2 IN FRAME F-Main /* Ayudante 2 */
DO:
    FILL-IN-Ayudante-2:SCREEN-VALUE = ''.
    IF SELF:SCREEN-VALUE = '' THEN RETURN.

    DEF VAR pNombre AS CHAR NO-UNDO.
    DEF VAR pOrigen AS CHAR NO-UNDO.

    RUN logis/p-busca-por-dni ( INPUT SELF:SCREEN-VALUE,
                                OUTPUT pNombre,
                                OUTPUT pOrigen).
    IF pOrigen = "ERROR" THEN DO:
        MESSAGE 'DNI inválido' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    DISPLAY pNombre @  FILL-IN-Ayudante-2 WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DI-RutaC.Ayudante-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DI-RutaC.Ayudante-3 V-table-Win
ON LEAVE OF DI-RutaC.Ayudante-3 IN FRAME F-Main /* Ayudante 3 */
DO:
    FILL-IN-Ayudante-3:SCREEN-VALUE = ''.
    IF SELF:SCREEN-VALUE = '' THEN RETURN.

    DEF VAR pNombre AS CHAR NO-UNDO.
    DEF VAR pOrigen AS CHAR NO-UNDO.

    RUN logis/p-busca-por-dni ( INPUT SELF:SCREEN-VALUE,
                                OUTPUT pNombre,
                                OUTPUT pOrigen).
    IF pOrigen = "ERROR" THEN DO:
        MESSAGE 'DNI inválido' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    DISPLAY pNombre @  FILL-IN-Ayudante-3 WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DI-RutaC.Ayudante-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DI-RutaC.Ayudante-4 V-table-Win
ON LEAVE OF DI-RutaC.Ayudante-4 IN FRAME F-Main /* Ayudante 4 */
DO:
    FILL-IN-Ayudante-4:SCREEN-VALUE = ''.
    IF SELF:SCREEN-VALUE = '' THEN RETURN.

    DEF VAR pNombre AS CHAR NO-UNDO.
    DEF VAR pOrigen AS CHAR NO-UNDO.

    RUN logis/p-busca-por-dni ( INPUT SELF:SCREEN-VALUE,
                                OUTPUT pNombre,
                                OUTPUT pOrigen).
    IF pOrigen = "ERROR" THEN DO:
        MESSAGE 'DNI inválido' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    DISPLAY pNombre @  FILL-IN-Ayudante-4 WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DI-RutaC.Ayudante-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DI-RutaC.Ayudante-5 V-table-Win
ON LEAVE OF DI-RutaC.Ayudante-5 IN FRAME F-Main /* Ayudante 5 */
DO:
    FILL-IN-Ayudante-5:SCREEN-VALUE = ''.
    IF SELF:SCREEN-VALUE = '' THEN RETURN.

    DEF VAR pNombre AS CHAR NO-UNDO.
    DEF VAR pOrigen AS CHAR NO-UNDO.

    RUN logis/p-busca-por-dni ( INPUT SELF:SCREEN-VALUE,
                                OUTPUT pNombre,
                                OUTPUT pOrigen).
    IF pOrigen = "ERROR" THEN DO:
        MESSAGE 'DNI inválido' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    DISPLAY pNombre @  FILL-IN-Ayudante-5 WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DI-RutaC.Ayudante-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DI-RutaC.Ayudante-6 V-table-Win
ON LEAVE OF DI-RutaC.Ayudante-6 IN FRAME F-Main /* Ayudante 6 */
DO:
    FILL-IN-Ayudante-6:SCREEN-VALUE = ''.
    IF SELF:SCREEN-VALUE = '' THEN RETURN.

    DEF VAR pNombre AS CHAR NO-UNDO.
    DEF VAR pOrigen AS CHAR NO-UNDO.

    RUN logis/p-busca-por-dni ( INPUT SELF:SCREEN-VALUE,
                                OUTPUT pNombre,
                                OUTPUT pOrigen).
    IF pOrigen = "ERROR" THEN DO:
        MESSAGE 'DNI inválido' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    DISPLAY pNombre @  FILL-IN-Ayudante-6 WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DI-RutaC.Ayudante-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DI-RutaC.Ayudante-7 V-table-Win
ON LEAVE OF DI-RutaC.Ayudante-7 IN FRAME F-Main /* Ayudante 7 */
DO:
    FILL-IN-Ayudante-7:SCREEN-VALUE = ''.
    IF SELF:SCREEN-VALUE = '' THEN RETURN.

    DEF VAR pNombre AS CHAR NO-UNDO.
    DEF VAR pOrigen AS CHAR NO-UNDO.

    RUN logis/p-busca-por-dni ( INPUT SELF:SCREEN-VALUE,
                                OUTPUT pNombre,
                                OUTPUT pOrigen).
    IF pOrigen = "ERROR" THEN DO:
        MESSAGE 'DNI inválido' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    DISPLAY pNombre @  FILL-IN-Ayudante-7 WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DI-RutaC.CodVeh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DI-RutaC.CodVeh V-table-Win
ON LEFT-MOUSE-DBLCLICK OF DI-RutaC.CodVeh IN FRAME F-Main /* Placa del vehiculo */
OR F8 OF DI-RutaC.CodVeh
DO:
  CASE s-HR-Manual:
      WHEN YES THEN DO:
          /* TIENDA: Vehículos ACTIVOS */
          ASSIGN
              input-var-1 = s-coddiv
              input-var-2 = "I"
              input-var-3 = "P"
              output-var-1 = ?.
          RUN lkup/c-vehic-3 ('Maestro de Vehículos').
      END.
      WHEN NO THEN DO:
          /* CD: Busca el Internamiento */
          ASSIGN
              input-var-1 = s-coddiv
              input-var-2 = "I"
              input-var-3 = "P"
              output-var-1 = ?.
          RUN lkup/c-tra-ingsal.w ('Vehículos Internados').
      END.
  END CASE.
  IF output-var-1 <> ? THEN DO:
      SELF:SCREEN-VALUE = output-var-2.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Ayudante-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Ayudante-1 V-table-Win
ON LEAVE OF FILL-IN-Ayudante-1 IN FRAME F-Main
DO:
  FILL-IN-Ayudante-1:SCREEN-VALUE = ''.
  FIND GN-COB WHERE gn-cob.codcia = s-codcia
    AND gn-cob.codcob = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE GN-COB THEN FILL-IN-Ayudante-1:SCREEN-VALUE = gn-cob.nomcob.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Ayudante-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Ayudante-2 V-table-Win
ON LEAVE OF FILL-IN-Ayudante-2 IN FRAME F-Main
DO:
  FILL-IN-Ayudante-2:SCREEN-VALUE = ''.
  FIND GN-COB WHERE gn-cob.codcia = s-codcia
    AND gn-cob.codcob = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE GN-COB THEN FILL-IN-Ayudante-2:SCREEN-VALUE = gn-cob.nomcob.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Ayudante-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Ayudante-3 V-table-Win
ON LEAVE OF FILL-IN-Ayudante-3 IN FRAME F-Main
DO:
  FILL-IN-Ayudante-2:SCREEN-VALUE = ''.
  FIND GN-COB WHERE gn-cob.codcia = s-codcia
    AND gn-cob.codcob = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE GN-COB THEN FILL-IN-Ayudante-2:SCREEN-VALUE = gn-cob.nomcob.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Ayudante-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Ayudante-4 V-table-Win
ON LEAVE OF FILL-IN-Ayudante-4 IN FRAME F-Main
DO:
  FILL-IN-Ayudante-2:SCREEN-VALUE = ''.
  FIND GN-COB WHERE gn-cob.codcia = s-codcia
    AND gn-cob.codcob = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE GN-COB THEN FILL-IN-Ayudante-2:SCREEN-VALUE = gn-cob.nomcob.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Ayudante-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Ayudante-5 V-table-Win
ON LEAVE OF FILL-IN-Ayudante-5 IN FRAME F-Main
DO:
  FILL-IN-Ayudante-2:SCREEN-VALUE = ''.
  FIND GN-COB WHERE gn-cob.codcia = s-codcia
    AND gn-cob.codcob = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE GN-COB THEN FILL-IN-Ayudante-2:SCREEN-VALUE = gn-cob.nomcob.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Ayudante-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Ayudante-6 V-table-Win
ON LEAVE OF FILL-IN-Ayudante-6 IN FRAME F-Main
DO:
  FILL-IN-Ayudante-2:SCREEN-VALUE = ''.
  FIND GN-COB WHERE gn-cob.codcia = s-codcia
    AND gn-cob.codcob = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE GN-COB THEN FILL-IN-Ayudante-2:SCREEN-VALUE = gn-cob.nomcob.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Ayudante-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Ayudante-7 V-table-Win
ON LEAVE OF FILL-IN-Ayudante-7 IN FRAME F-Main
DO:
  FILL-IN-Ayudante-2:SCREEN-VALUE = ''.
  FIND GN-COB WHERE gn-cob.codcia = s-codcia
    AND gn-cob.codcob = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE GN-COB THEN FILL-IN-Ayudante-2:SCREEN-VALUE = gn-cob.nomcob.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DI-RutaC.Libre_c01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DI-RutaC.Libre_c01 V-table-Win
ON LEAVE OF DI-RutaC.Libre_c01 IN FRAME F-Main /* Conductor (Licencia) */
DO:
    txtConductor:SCREEN-VALUE = "".
    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = 'BREVETE' AND
        vtatabla.llave_c1 = DI-RutaC.libre_c01:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE vtatabla THEN DO:
        txtConductor:SCREEN-VALUE = vtatabla.libre_C01 + " " + vtatabla.libre_C02 + " " + vtatabla.libre_C03.  
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DI-RutaC.Libre_c01 V-table-Win
ON LEFT-MOUSE-DBLCLICK OF DI-RutaC.Libre_c01 IN FRAME F-Main /* Conductor (Licencia) */
OR F8 OF DI-RutaC.Libre_c01
DO:
  ASSIGN
      input-var-1 = ''
      input-var-2 = ''
      input-var-3 = ''
      output-var-1 = ?.
  RUN lkup/c-conductor-02 ('Maestro de Licencias').
  IF output-var-1<> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DI-RutaC.responsable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DI-RutaC.responsable V-table-Win
ON LEAVE OF DI-RutaC.responsable IN FRAME F-Main /* Responsable */
DO:
    FILL-IN-Responsable:SCREEN-VALUE = ''.
    IF SELF:SCREEN-VALUE = '' THEN RETURN.

    DEF VAR pNombre AS CHAR NO-UNDO.
    DEF VAR pOrigen AS CHAR NO-UNDO.

    RUN logis/p-busca-por-dni ( INPUT SELF:SCREEN-VALUE,
                                OUTPUT pNombre,
                                OUTPUT pOrigen).
    IF pOrigen = "ERROR" THEN DO:
        MESSAGE 'DNI inválido' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    DISPLAY pNombre @  FILL-IN-Responsable WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCodPro V-table-Win
ON LEAVE OF txtCodPro IN FRAME F-Main /* Emp.Transp. */
DO:
    txtDTrans:SCREEN-VALUE = "".
    FIND gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = txtCodPro:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN DO:
        txtDTrans:SCREEN-VALUE = gn-prov.nompro.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtHora
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtHora V-table-Win
ON LEAVE OF txtHora IN FRAME F-Main /* HH */
DO:
    /*
  integral.di-rutaC.horsal:SCREEN-VALUE = 
      string(int(txtHora:SCREEN-VALUE),"99") + string(int(txtMinuto:SCREEN-VALUE),"99").
      */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtHora-Ret
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtHora-Ret V-table-Win
ON LEAVE OF txtHora-Ret IN FRAME F-Main /* HH */
DO:
    /*
  integral.di-rutaC.horsal:SCREEN-VALUE = 
      string(int(txtHora:SCREEN-VALUE),"99") + string(int(txtMinuto:SCREEN-VALUE),"99").
      */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtMinuto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtMinuto V-table-Win
ON LEAVE OF txtMinuto IN FRAME F-Main /* MM */
DO:
    /*
    integral.di-rutaC.horsal:SCREEN-VALUE = 
      string(int(txtHora:SCREEN-VALUE),"99") + string(int(txtMinuto:SCREEN-VALUE),"99").
      */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtMinuto-Ret
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtMinuto-Ret V-table-Win
ON LEAVE OF txtMinuto-Ret IN FRAME F-Main /* MM */
DO:
    /*
    integral.di-rutaC.horsal:SCREEN-VALUE = 
      string(int(txtHora:SCREEN-VALUE),"99") + string(int(txtMinuto:SCREEN-VALUE),"99").
      */
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

ON 'LEFT-MOUSE-DBLCLICK':U OF DI-RutaC.ayudante-1,
    DI-RutaC.ayudante-2, 
    DI-RutaC.Ayudante-3, 
    DI-RutaC.Ayudante-4, 
    DI-RutaC.Ayudante-5, 
    DI-RutaC.Ayudante-6, 
    DI-RutaC.Ayudante-7, 
    DI-RutaC.responsable
    DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?.
    RUN aplic/lkup/c-pers-por-dni ('DNI Personal PROPIO').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

ON F8 OF DI-RutaC.ayudante-1,
    DI-RutaC.ayudante-2, 
    DI-RutaC.Ayudante-3, 
    DI-RutaC.Ayudante-4, 
    DI-RutaC.Ayudante-5, 
    DI-RutaC.Ayudante-6, 
    DI-RutaC.Ayudante-7, 
    DI-RutaC.responsable
    DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?.
    RUN aplic/lkup/c-pers-por-dni ('DNI Personal PROPIO').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

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
  {src/adm/template/row-list.i "DI-RutaC"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "DI-RutaC"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Reporte V-table-Win 
PROCEDURE Borra-Reporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FOR EACH w-report EXCLUSIVE-LOCK WHERE w-report.task-no = s-task-no:
      DELETE w-report.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Reporte V-table-Win 
PROCEDURE Carga-Reporte PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* *************************************************************************************** */
  /* RHC 20/02/2019 */
  /* Grabamos el orden de impresion */
  /* *************************************************************************************** */
  x-Bultos = 0.
  FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
      FIRST Ccbcdocu NO-LOCK WHERE CcbCDocu.CodCia = s-codcia
        AND CcbCDocu.CodDoc = DI-RutaD.CodRef 
        AND CcbCDocu.NroDoc = DI-RutaD.NroRef,
      FIRST FACTURA NO-LOCK WHERE FACTURA.codcia = Ccbcdocu.codcia
        AND FACTURA.coddoc = Ccbcdocu.codref
        AND FACTURA.nrodoc = Ccbcdocu.nroref,
      FIRST gn-convt NO-LOCK WHERE gn-ConVt.Codig = FACTURA.fmapgo
      BREAK BY Ccbcdocu.NomCli BY Ccbcdocu.nroPed BY Ccbcdocu.Libre_c02:
      /* Bultos */
      IF FIRST-OF(Ccbcdocu.NomCli) OR FIRST-OF(Ccbcdocu.NroPed) OR FIRST-OF(Ccbcdocu.Libre_c02) 
          THEN DO:
          RUN logis/p-numero-de-bultos (INPUT s-CodDiv,
                                        INPUT Ccbcdocu.Libre_c01,
                                        INPUT Ccbcdocu.Libre_c02,
                                        OUTPUT f-Bultos).
          x-Bultos = x-Bultos + f-Bultos.
      END.
  END.
  FOR EACH Di-RutaG OF Di-RutaC NO-LOCK,
      FIRST Almcmov WHERE Almcmov.CodCia = Di-RutaG.CodCia
        AND Almcmov.CodAlm = Di-RutaG.CodAlm
        AND Almcmov.TipMov = Di-RutaG.Tipmov
        AND Almcmov.CodMov = Di-RutaG.Codmov
        AND Almcmov.NroSer = Di-RutaG.serref
        AND Almcmov.NroDoc = Di-RutaG.nroref,
      FIRST Almacen NO-LOCK WHERE Almacen.CodCia = Almcmov.CodCia
        AND Almacen.CodAlm = Almcmov.AlmDes,
      FIRST gn-divi NO-LOCK WHERE gn-divi.CodCia = Almacen.CodCia 
        AND gn-divi.CodDiv = Almacen.CodDiv
      BREAK BY Almacen.Descripcion BY Almcmov.CodRef BY Almcmov.NroRef
      WITH FRAME {&FRAME-NAME}:
      /* Bultos */
      IF FIRST-OF(Almacen.Descripcion) OR FIRST-OF(Almcmov.NroRef) THEN DO:
          RUN logis/p-numero-de-bultos (INPUT s-CodDiv,
                                        INPUT Almcmov.CodRef ,
                                        INPUT Almcmov.NroRef,
                                        OUTPUT f-Bultos).
          x-Bultos = x-Bultos + f-Bultos.
      END.
  END.
  /* *************************************************************************************** */
  RUN Carga-Reporte-Detalle.
  /* *************************************************************************************** */
  /* ESCALA y DESTINO FINAL */
  /* *************************************************************************************** */
  DEF VAR x-PuntoLlegada AS CHAR NO-UNDO.
  /* Sintaxis: < Nombre >|< Dirección > */
  FOR EACH w-report EXCLUSIVE-LOCK WHERE w-report.task-no = s-task-no:
      FIND Di-RutaGRI WHERE Di-RutaGRI.CodCia = Di-RutaC.CodCia AND
          Di-RutaGRI.CodDiv = Di-RutaC.CodDiv AND
          Di-RutaGRI.CodDoc = Di-RutaC.CodDoc AND
          Di-RutaGRI.NroDoc = Di-RutaC.NroDoc AND 
          Di-RutaGRI.CodRef = w-report.Campo-C[25] AND
          Di-RutaGRI.NroRef = w-report.Campo-C[4]
          NO-LOCK NO-ERROR.
      IF AVAILABLE Di-RutaGRI THEN
          ASSIGN
          w-report.Campo-C[27] = Di-RutaGRI.Escala
          w-report.Campo-C[28] = Di-RutaGRI.Destino_Final
          w-report.Campo-C[29] = Di-RutaGRI.Contacto + " HORA: " + Di-RutaGRI.Hora
          w-report.Campo-C[30] = Di-RutaGRI.Referencia.
  END.
/*   FOR EACH w-report EXCLUSIVE-LOCK WHERE w-report.task-no = s-task-no,                        */
/*       FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia AND                             */
/*         Faccpedi.coddoc = w-report.Campo-C[25] AND      /* PED */                             */
/*         Faccpedi.nroped = w-report.Campo-C[4],                                                */
/*       FIRST Ccbadocu NO-LOCK WHERE CcbADocu.CodCia = Faccpedi.codcia AND                      */
/*         CcbADocu.CodDiv = Faccpedi.coddiv AND                                                 */
/*         CcbADocu.CodDoc = Faccpedi.coddoc AND                                                 */
/*         CcbADocu.NroDoc = Faccpedi.nroped:                                                    */
/*       ASSIGN                                                                                  */
/*           w-report.Campo-C[27] = CcbADocu.Libre_C[12]                                         */
/*           w-report.Campo-C[28] = CcbADocu.Libre_C[13]                                         */
/*           w-report.Campo-C[29] = CcbADocu.Libre_C[14] + " HORA: " + CcbADocu.Libre_C[15]      */
/*           w-report.Campo-C[30] = CcbADocu.Libre_C[16].                                        */
/*       /* RHC 18/09/2019 En caso de DEJADO EN TIENDA */                                        */
/*       /* RHC 16/06/2019 Lugar de entrega (* O/D)*/                                            */
/*       RUN logis/p-lugar-de-entrega (Faccpedi.CodDoc, Faccpedi.NroPed, OUTPUT x-PuntoLlegada). */
/*       IF NUM-ENTRIES(x-PuntoLlegada, '|') >= 2 THEN                                           */
/*           ASSIGN                                                                              */
/*           w-report.Campo-C[27] = ENTRY(2, x-PuntoLlegada, '|').                               */
/*   END.                                                                                        */
  /* Bultos */
  DEF VAR pBultos AS INT NO-UNDO.
  FOR EACH w-report EXCLUSIVE-LOCK WHERE w-report.task-no = s-task-no
      BREAK BY w-report.campo-i[30] 
      BY w-report.llave-f
      BY w-report.campo-c[3] 
      BY w-report.campo-c[4] 
      BY w-report.campo-c[5]:
      RUN logis/p-numero-de-bultos (INPUT s-CodDiv,
                                    INPUT w-report.Campo-C[26],
                                    INPUT w-report.Campo-C[5],
                                    OUTPUT pBultos).
      w-report.Campo-I[5] = pBultos.
      IF FIRST-OF(w-report.campo-i[30]) OR FIRST-OF(w-report.llave-f) OR 
          FIRST-OF(w-report.campo-c[3]) OR FIRST-OF(w-report.campo-c[4]) OR 
          FIRST-OF(w-report.campo-c[5]) THEN DO:
          w-report.Campo-I[4] = pBultos.
      END.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Reporte-Detalle V-table-Win 
PROCEDURE Carga-Reporte-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  s-Task-no = 0.
  FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
      FIRST Ccbcdocu NO-LOCK WHERE CcbCDocu.CodCia = s-codcia
        AND CcbCDocu.CodDoc = DI-RutaD.CodRef       /* G/R */
        AND CcbCDocu.NroDoc = DI-RutaD.NroRef,
      FIRST FACTURA NO-LOCK WHERE FACTURA.codcia = Ccbcdocu.codcia
        AND FACTURA.coddoc = Ccbcdocu.codref
        AND FACTURA.nrodoc = Ccbcdocu.nroref,
      FIRST gn-convt NO-LOCK WHERE gn-ConVt.Codig = FACTURA.fmapgo
      BREAK BY Ccbcdocu.NomCli BY Ccbcdocu.nroPed BY Ccbcdocu.Libre_c02
      WITH FRAME {&FRAME-NAME}:
      IF s-Task-No = 0 THEN REPEAT:
          s-Task-No = RANDOM(1,999999).
          IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-Task-No NO-LOCK) THEN LEAVE.
      END.
      CREATE w-report.
      ASSIGN
          w-report.task-no = s-Task-No
          w-report.Llave-F = 9999
          w-report.Campo-i[30] = 1.     /* O/D */

      /* ************************************************************************************** */
      /* CABECERA: DI-RUTAC */
      /* ************************************************************************************** */
      FIND gn-clie WHERE gn-clie.codcia = cl-codcia
          AND gn-clie.codcli = ccbcdocu.codcli
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-clie THEN DO:
          FIND Vtaubidiv WHERE VtaUbiDiv.CodCia = s-codcia
              AND VtaUbiDiv.CodDiv = s-coddiv
              AND VtaUbiDiv.CodDept = gn-clie.CodDept 
              AND VtaUbiDiv.CodProv = gn-clie.CodProv 
              AND VtaUbiDiv.CodDist = gn-clie.CodDist
              NO-LOCK NO-ERROR.
          IF AVAILABLE VtaUbiDiv THEN w-report.Llave-F = VtaUbiDiv.Libre_d01.
      END.
      ASSIGN
          w-report.Llave-I = Di-RutaC.CodCia
          w-report.Llave-C = Di-RutaC.CodDiv
          w-report.Campo-C[1] = Di-RutaC.CodDoc
          w-report.Campo-C[2] = Di-RutaC.NroDoc.
      ASSIGN
          w-report.Campo-C[3] = Ccbcdocu.NomCli
          w-report.Campo-C[25]= Ccbcdocu.CodPed
          w-report.Campo-C[4] = Ccbcdocu.NroPed         /* PED */
          w-report.Campo-C[26]= Ccbcdocu.Libre_c01
          w-report.Campo-C[5] = Ccbcdocu.Libre_c02.     /* O/D */
      ASSIGN
          w-report.Campo-C[6] = FILL-IN-Responsable:SCREEN-VALUE
          w-report.Campo-C[7] = FILL-IN-Ayudante-1:SCREEN-VALUE
          w-report.Campo-C[8] = FILL-IN-Ayudante-2:SCREEN-VALUE
          w-report.Campo-C[9] = FILL-IN-Ayudante-3:SCREEN-VALUE
          w-report.Campo-C[10] = FILL-IN-Ayudante-4:SCREEN-VALUE
          w-report.Campo-C[11] = FILL-IN-Ayudante-5:SCREEN-VALUE
          w-report.Campo-C[12] = FILL-IN-Ayudante-6:SCREEN-VALUE 
          w-report.Campo-C[13] = FILL-IN-Ayudante-7:SCREEN-VALUE.
      ASSIGN
          w-report.Campo-I[1] = txtNroClientes + txtPtosAlmacen
          w-report.Campo-I[2] = x-Bultos
          w-report.Campo-F[1] = txtPeso
          w-report.Campo-F[2] = txtVol.
      /* Bultos */
      IF FIRST-OF(Ccbcdocu.NomCli) OR FIRST-OF(Ccbcdocu.NroPed) OR 
          FIRST-OF(Ccbcdocu.Libre_c02) THEN DO:
          RUN logis/p-numero-de-bultos (INPUT s-CodDiv,
                                        INPUT Ccbcdocu.Libre_c01,
                                        INPUT Ccbcdocu.Libre_c02,
                                        OUTPUT f-Bultos).
          w-report.Campo-I[3] = f-Bultos.
/*           FOR EACH CcbCBult NO-LOCK WHERE CcbCBult.CodCia = Ccbcdocu.codcia AND */
/*               CcbCBult.CodDoc = Ccbcdocu.Libre_c01 AND                          */
/*               CcbCBult.NroDoc = Ccbcdocu.Libre_c02:                             */
/*               w-report.Campo-I[3] = w-report.Campo-I[3] + CcbCBult.Bultos.      */
/*           END.                                                                  */
      END.
      /* ************************************************************************************** */
      /* DETALLE DI-RUTAD */
      /* ************************************************************************************** */
      ASSIGN
          w-report.Campo-C[20] = Ccbcdocu.coddoc
          w-report.Campo-C[21] = Ccbcdocu.nrodoc
          w-report.Campo-C[22] = FACTURA.coddoc
          w-report.Campo-C[23] = FACTURA.nrodoc
          w-report.Campo-C[24] = gn-ConVt.Nombr.
      FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK, FIRST Almmmatg OF Ccbddocu NO-LOCK:
          ASSIGN
              w-report.Campo-F[3] = w-report.Campo-F[3] + (Ccbddocu.candes * Ccbddocu.factor * Almmmatg.pesmat).
      END.
  END.
  /* *************************************************************************************** */
  /* GIAS DE REMISION POR TRANSFERENCIA */
  /* *************************************************************************************** */
  FOR EACH Di-RutaG OF Di-RutaC NO-LOCK,
      FIRST Almcmov WHERE Almcmov.CodCia = Di-RutaG.CodCia
        AND Almcmov.CodAlm = Di-RutaG.CodAlm
        AND Almcmov.TipMov = Di-RutaG.Tipmov
        AND Almcmov.CodMov = Di-RutaG.Codmov
        AND Almcmov.NroSer = Di-RutaG.serref
        AND Almcmov.NroDoc = Di-RutaG.nroref,
      FIRST Almacen NO-LOCK WHERE Almacen.CodCia = Almcmov.CodCia
        AND Almacen.CodAlm = Almcmov.AlmDes,
      FIRST gn-divi NO-LOCK WHERE gn-divi.CodCia = Almacen.CodCia 
        AND gn-divi.CodDiv = Almacen.CodDiv
      BREAK BY Almacen.Descripcion BY Almcmov.CodRef BY Almcmov.NroRef
      WITH FRAME {&FRAME-NAME}:
      IF s-Task-No = 0 THEN REPEAT:
          s-Task-No = RANDOM(1,999999).
          IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-Task-No NO-LOCK) THEN LEAVE.
      END.
      CREATE w-report.
      ASSIGN
          w-report.task-no = s-Task-No
          w-report.Llave-F = 9999
          w-report.Campo-i[30] = 2.     /* OTR */

      /* ************************************************************************************** */
      /* CABECERA: DI-RUTAC */
      /* ************************************************************************************** */
      FIND Vtaubidiv WHERE VtaUbiDiv.CodCia = s-codcia
          AND VtaUbiDiv.CodDiv = s-coddiv
          AND VtaUbiDiv.CodDept = gn-divi.Campo-Char[3] 
          AND VtaUbiDiv.CodProv = gn-divi.Campo-Char[4] 
          AND VtaUbiDiv.CodDist = gn-divi.Campo-Char[5] 
          NO-LOCK NO-ERROR.
      IF AVAILABLE VtaUbiDiv THEN w-report.Llave-F = VtaUbiDiv.Libre_d01.
      ASSIGN
          w-report.Llave-I = Di-RutaC.CodCia
          w-report.Llave-C = Di-RutaC.CodDiv
          w-report.Campo-C[1] = Di-RutaC.CodDoc
          w-report.Campo-C[2] = Di-RutaC.NroDoc.
      ASSIGN
          w-report.Campo-C[3] = Almacen.Descripcion.
      FIND FIRST Faccpedi WHERE FacCPedi.CodCia = Almcmov.CodCia 
          AND FacCPedi.CodDoc = Almcmov.CodRef
          AND FacCPedi.NroPed = Almcmov.NroRef NO-LOCK NO-ERROR.
      IF AVAILABLE Faccpedi THEN
          ASSIGN
          w-report.Campo-C[25]= Faccpedi.CodRef
          w-report.Campo-C[4] = Faccpedi.NroRef         /* R/A */
          w-report.Campo-C[26]= Faccpedi.CodDoc
          w-report.Campo-C[5] = Faccpedi.NroPed.        /* OTR */
      ASSIGN
          w-report.Campo-C[6] = FILL-IN-Responsable:SCREEN-VALUE
          w-report.Campo-C[7] = FILL-IN-Ayudante-1:SCREEN-VALUE
          w-report.Campo-C[8] = FILL-IN-Ayudante-2:SCREEN-VALUE
          w-report.Campo-C[9] = FILL-IN-Ayudante-3:SCREEN-VALUE
          w-report.Campo-C[10] = FILL-IN-Ayudante-4:SCREEN-VALUE
          w-report.Campo-C[11] = FILL-IN-Ayudante-5:SCREEN-VALUE
          w-report.Campo-C[12] = FILL-IN-Ayudante-6:SCREEN-VALUE 
          w-report.Campo-C[13] = FILL-IN-Ayudante-7:SCREEN-VALUE.
      ASSIGN
          w-report.Campo-I[1] = txtNroClientes + txtPtosAlmacen
          w-report.Campo-I[2] = x-Bultos
          w-report.Campo-F[1] = txtPeso
          w-report.Campo-F[2] = txtVol.
      /* DESTINO FINAL */
      ASSIGN
          w-report.Campo-C[28] = Almacen.DirAlm.
      /* Bultos */
      IF FIRST-OF(Almacen.Descripcion) OR FIRST-OF(Almcmov.NroRef) THEN DO:
          RUN logis/p-numero-de-bultos (INPUT s-CodDiv,
                                        INPUT Almcmov.CodRef ,
                                        INPUT Almcmov.NroRef,
                                        OUTPUT f-Bultos).
          w-report.Campo-I[3] = f-Bultos.
/*           FOR EACH CcbCBult NO-LOCK WHERE CcbCBult.CodCia = Almcmov.codcia AND */
/*               CcbCBult.CodDoc = Almcmov.CodRef AND                             */
/*               CcbCBult.NroDoc = Almcmov.NroRef:                                */
/*               w-report.Campo-I[3] = w-report.Campo-I[3] + CcbCBult.Bultos.     */
/*           END.                                                                 */
      END.
      /* ************************************************************************************** */
      /* DETALLE Di-RutaG */
      /* ************************************************************************************** */
      ASSIGN
          w-report.Campo-C[20] = "G/R"
          w-report.Campo-C[21] = STRING(Almcmov.NroSer, '999') + STRING(Almcmov.NroDoc, '999999999')
          w-report.Campo-C[22] = ''
          w-report.Campo-C[23] = ''
          w-report.Campo-C[24] = ''.
      FOR EACH Almdmov OF Almcmov NO-LOCK, FIRST Almmmatg OF Almdmov NO-LOCK:
          ASSIGN
              w-report.Campo-F[3] = w-report.Campo-F[3] + (Almdmov.candes * Almdmov.factor * Almmmatg.pesmat).
      END.
  END.
  /* ITINIRANTES */
  FOR EACH Di-RutaDG OF Di-RutaC NO-LOCK,
      FIRST Ccbcdocu NO-LOCK WHERE CcbCDocu.CodCia = s-codcia
        AND CcbCDocu.CodDoc = Di-RutaDG.CodRef       /* G/R */
        AND CcbCDocu.NroDoc = Di-RutaDG.NroRef
      BREAK BY Ccbcdocu.NomCli BY Ccbcdocu.nroPed BY Ccbcdocu.Libre_c02
      WITH FRAME {&FRAME-NAME}:
      IF s-Task-No = 0 THEN REPEAT:
          s-Task-No = RANDOM(1,999999).
          IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-Task-No NO-LOCK) THEN LEAVE.
      END.
      CREATE w-report.
      ASSIGN
          w-report.task-no = s-Task-No
          w-report.Llave-F = 9999
          w-report.Campo-i[30] = 3.     /* G/R ITINERANTE */

      /* ************************************************************************************** */
      /* CABECERA: DI-RUTAC */
      /* ************************************************************************************** */
      FIND gn-clie WHERE gn-clie.codcia = cl-codcia
          AND gn-clie.codcli = ccbcdocu.codcli
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-clie THEN DO:
          FIND Vtaubidiv WHERE VtaUbiDiv.CodCia = s-codcia
              AND VtaUbiDiv.CodDiv = s-coddiv
              AND VtaUbiDiv.CodDept = gn-clie.CodDept 
              AND VtaUbiDiv.CodProv = gn-clie.CodProv 
              AND VtaUbiDiv.CodDist = gn-clie.CodDist
              NO-LOCK NO-ERROR.
          IF AVAILABLE VtaUbiDiv THEN w-report.Llave-F = VtaUbiDiv.Libre_d01.
      END.
      ASSIGN
          w-report.Llave-I = Di-RutaC.CodCia
          w-report.Llave-C = Di-RutaC.CodDiv
          w-report.Campo-C[1] = Di-RutaC.CodDoc
          w-report.Campo-C[2] = Di-RutaC.NroDoc.
      ASSIGN
          w-report.Campo-C[3] = Ccbcdocu.NomCli
          w-report.Campo-C[25]= Ccbcdocu.CodPed
          w-report.Campo-C[4] = Ccbcdocu.NroPed         /* PED */
          w-report.Campo-C[26]= Ccbcdocu.Libre_c01
          w-report.Campo-C[5] = Ccbcdocu.Libre_c02.     /* O/D */
      ASSIGN
          w-report.Campo-C[6] = FILL-IN-Responsable:SCREEN-VALUE
          w-report.Campo-C[7] = FILL-IN-Ayudante-1:SCREEN-VALUE
          w-report.Campo-C[8] = FILL-IN-Ayudante-2:SCREEN-VALUE
          w-report.Campo-C[9] = FILL-IN-Ayudante-3:SCREEN-VALUE
          w-report.Campo-C[10] = FILL-IN-Ayudante-4:SCREEN-VALUE
          w-report.Campo-C[11] = FILL-IN-Ayudante-5:SCREEN-VALUE
          w-report.Campo-C[12] = FILL-IN-Ayudante-6:SCREEN-VALUE 
          w-report.Campo-C[13] = FILL-IN-Ayudante-7:SCREEN-VALUE.
      ASSIGN
          w-report.Campo-I[1] = txtNroClientes + txtPtosAlmacen
          w-report.Campo-I[2] = x-Bultos
          w-report.Campo-F[1] = txtPeso
          w-report.Campo-F[2] = txtVol.
      /* Bultos */
      IF FIRST-OF(Ccbcdocu.NomCli) OR FIRST-OF(Ccbcdocu.NroPed) OR 
          FIRST-OF(Ccbcdocu.Libre_c02) THEN DO:
          RUN logis/p-numero-de-bultos (INPUT s-CodDiv,
                                        INPUT Ccbcdocu.Libre_c01,
                                        INPUT Ccbcdocu.Libre_c02,
                                        OUTPUT f-Bultos).
          w-report.Campo-I[3] = f-Bultos.
/*           FOR EACH CcbCBult NO-LOCK WHERE CcbCBult.CodCia = Ccbcdocu.codcia AND */
/*               CcbCBult.CodDoc = Ccbcdocu.Libre_c01 AND                          */
/*               CcbCBult.NroDoc = Ccbcdocu.Libre_c02:                             */
/*               w-report.Campo-I[3] = w-report.Campo-I[3] + CcbCBult.Bultos.      */
/*           END.                                                                  */
      END.
      /* ************************************************************************************** */
      /* DETALLE Di-RutaDG */
      /* ************************************************************************************** */
      ASSIGN
          w-report.Campo-C[20] = Ccbcdocu.coddoc
          w-report.Campo-C[21] = Ccbcdocu.nrodoc.
      FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK, FIRST Almmmatg OF Ccbddocu NO-LOCK:
          ASSIGN
              w-report.Campo-F[3] = w-report.Campo-F[3] + (Ccbddocu.candes * Ccbddocu.factor * Almmmatg.pesmat).
      END.
  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       di-rutac.flgest = "P" por defecto en el diccionario de datos
                Solo es modificacion
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      DI-RutaC.Libre_c05 = s-user-id
      DI-RutaC.Libre_f05 = TODAY.

  /* 08 Julio 2013 - Ic*/
  ASSIGN FRAME {&frame-name} txtHora txtMinuto txtHora-Ret txtMinuto-Ret.
  ASSIGN 
      DI-RutaC.HorSal = STRING(txtHora,"99") + STRING(txtMinuto,"99")
      DI-RutaC.HorRet = STRING(txtHora-Ret,"99") + STRING(txtMinuto-Ret,"99")
      DI-RutaC.GuiaTransportista = STRING(txtSerie,"999") + "-" + STRING(txtNro,"99999999").

  /* RHC 11/01/18 Control de la guia del transportista */
  IF DI-RutaC.CodPro <> '10003814' THEN DO:
      DEFINE BUFFER b-di-rutac FOR di-rutac.
      FIND FIRST b-di-rutaC WHERE b-di-rutaC.codcia = s-codcia 
          AND b-di-rutaC.codpro = DI-RutaC.CodPro
          AND b-DI-RutaC.GuiaTransportista = DI-RutaC.GuiaTransportista
          AND b-DI-RutaC.CodDoc = "H/R"
          AND ROWID(b-DI-RutaC) <> ROWID(DI-RutaC)
          AND b-DI-RutaC.FlgEst <> 'A'
          NO-LOCK NO-ERROR.
      IF AVAILABLE b-di-rutac THEN DO:
          MESSAGE 'Guia de transportista ya tiene hoja de ruta:' b-DI-RutaC.CodDoc b-DI-RutaC.NroDoc
              VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO txtNro IN FRAME {&FRAME-NAME}.
          UNDO, RETURN 'ADM-ERROR'.
      END.
  END.

  DEF VAR pNombre AS CHAR NO-UNDO.
  DEF VAR pOrigen AS CHAR NO-UNDO.

  RUN Valida-Personal (INPUT DI-RutaC.responsable, OUTPUT pNombre, OUTPUT pOrigen).
  IF pOrigen <> "ERROR" THEN DI-RutaC.tipresponsable = pOrigen.
  RUN Valida-Personal (INPUT DI-RutaC.ayudante-1, OUTPUT pNombre, OUTPUT pOrigen).
  IF pOrigen <> "ERROR" THEN DI-RutaC.TipAyudante-1 = pOrigen.
  RUN Valida-Personal (INPUT DI-RutaC.ayudante-2, OUTPUT pNombre, OUTPUT pOrigen).
  IF pOrigen <> "ERROR" THEN DI-RutaC.TipAyudante-2 = pOrigen.
  RUN Valida-Personal (INPUT DI-RutaC.ayudante-3, OUTPUT pNombre, OUTPUT pOrigen).
  IF pOrigen <> "ERROR" THEN DI-RutaC.TipAyudante-3 = pOrigen.
  RUN Valida-Personal (INPUT DI-RutaC.ayudante-4, OUTPUT pNombre, OUTPUT pOrigen).
  IF pOrigen <> "ERROR" THEN DI-RutaC.TipAyudante-4 = pOrigen.
  RUN Valida-Personal (INPUT DI-RutaC.ayudante-5, OUTPUT pNombre, OUTPUT pOrigen).
  IF pOrigen <> "ERROR" THEN DI-RutaC.TipAyudante-5 = pOrigen.
  RUN Valida-Personal (INPUT DI-RutaC.ayudante-6, OUTPUT pNombre, OUTPUT pOrigen).
  IF pOrigen <> "ERROR" THEN DI-RutaC.TipAyudante-6 = pOrigen.
  RUN Valida-Personal (INPUT DI-RutaC.ayudante-7, OUTPUT pNombre, OUTPUT pOrigen).
  IF pOrigen <> "ERROR" THEN DI-RutaC.TipAyudante-7 = pOrigen.
  /* Control de modificación */
  ASSIGN
      DI-RutaC.FechaApertura = TODAY
      DI-RutaC.GlosaApertura = x-GlosaApertura
      DI-RutaC.HoraApertura = STRING(TIME, 'HH:MM:SS').

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
  RUN Procesa-Handle IN lh_handle ('pagina1').
  RUN Procesa-Handle IN lh_handle ('enable-detail').

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DISABLE txtHora txtMinuto txtHora-Ret txtMinuto-Ret txtSerie txtNro WITH FRAME {&FRAME-NAME}.

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
  
  DEFINE VAR lQtyClie AS INT.
  DEFINE VAR lQtyAlm AS INT.
  DEFINE VAR lImpClieDol AS DEC.   
  DEFINE VAR lImpClieSol AS DEC.   
  DEFINE VAR lImpTranDol AS DEC.   
  DEFINE VAR lImpTranSol AS DEC.   
  DEFINE VAR lPeso AS DEC.
  DEFINE VAR lVol AS DEC.
  DEFINE VAR lImpVtaSol AS DEC.   
  DEFINE VAR lImpCtoSol AS DEC.   

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  SESSION:SET-WAIT-STATE('GENERAL').
  lQtyClie = 0.
  lQtyAlm = 0.
  lImpClieDol = 0.
  lImpClieSol = 0.
  lImpTranDol = 0.
  lImpTranSol = 0.
  lPeso = 0.
  lVol = 0.
  EMPTY TEMP-TABLE tt-qttys.

  txtPeso = 0.
  txtVolumen = 0.
  DO WITH FRAME {&FRAME-NAME} :
      txtCargaMaxima:SCREEN-VALUE = "0.00".
      txtVolumen:SCREEN-VALUE = "0.00".
      txtClieDol:SCREEN-VALUE = "0.00".
      txtClieSol:SCREEN-VALUE = "0.00".
      txtTranDol:SCREEN-VALUE = "0.00".
      txtTranSol:SCREEN-VALUE = "0.00".
      txtPeso:SCREEN-VALUE = "0.00".
      txtVol:SCREEN-VALUE = "0.00".
  END.

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE DI-RUTAC THEN DO WITH FRAME {&FRAME-NAME}:
    FILL-IN-Marca:SCREEN-VALUE = ''.
    FIND gn-vehic WHERE gn-vehic.codcia = s-codcia
        AND gn-vehic.placa = DI-RutaC.CodVeh NO-LOCK NO-ERROR.
    IF AVAILABLE gn-vehic THEN DO:    
        FILL-IN-Marca:SCREEN-VALUE = gn-vehic.marca.
        txtCargaMaxima:SCREEN-VALUE = STRING(gn-vehic.carga,">>,>>9.99").
        txtVolumen:SCREEN-VALUE = STRING(gn-vehic.Volumen,">>,>>9.99").
    END.
    txtCodPro:SCREEN-VALUE = DI-RutaC.codPro.

    FIND gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = DI-RutaC.codPro NO-LOCK NO-ERROR.

    IF AVAILABLE gn-prov THEN DO:        
        txtDTrans:SCREEN-VALUE = gn-prov.nompro.
    END.

    /* Levantamos la libreria a memoria */
    DEFINE VAR hProc AS HANDLE NO-UNDO.
    DEFINE VAR pEstado AS CHAR NO-UNDO.
    RUN tra/tra-librerias PERSISTENT SET hProc.
    RUN Flag-Estado IN hProc (DI-RutaC.FlgEst, OUTPUT pEstado).
    DELETE PROCEDURE hProc.
    FILL-IN-Estado:SCREEN-VALUE = pEstado.
    
    txtSerie:SCREEN-VALUE = '0'.
    txtNro:SCREEN-VALUE = '0'.

    txtHora:SCREEN-VALUE = SUBSTRING(DI-RutaC.HorSal, 1, 2).
    txtMinuto:SCREEN-VALUE = SUBSTRING(DI-RutaC.HorSal, 3, 2).

    txtHora-Ret:SCREEN-VALUE = SUBSTRING(DI-RutaC.HorRet, 1, 2).
    txtMinuto-Ret:SCREEN-VALUE = SUBSTRING(DI-RutaC.HorRet, 3, 2).
    
    txtSerie:SCREEN-VALUE IN FRAM {&FRAME-NAME} = SUBSTRING(di-rutac.GuiaTransportista,1,3).
    txtNro:SCREEN-VALUE IN FRAM {&FRAME-NAME} = SUBSTRING(di-rutac.GuiaTransportista,5,8) .

    /* Qttys Clientes */
    FOR EACH di-rutaD WHERE di-rutac.codcia = di-rutad.codcia
        AND di-rutac.coddiv = di-rutad.coddiv AND 
        di-rutac.coddoc = di-rutad.coddoc AND
        di-rutac.nrodoc = di-rutad.nrodoc NO-LOCK:
        FIND ccbcdocu WHERE ccbcdocu.codcia = di-rutad.codcia
          AND ccbcdocu.coddoc = DI-RutaD.CodRef
          AND ccbcdocu.nrodoc = DI-RutaD.NroRef
          NO-LOCK NO-ERROR.
        IF AVAILABLE ccbcdocu THEN DO:
            FIND tt-qttys WHERE tt-qttys.tt-tipo = 'VTA' AND 
                tt-qttys.tt-clave1 = ccbcdocu.codcli EXCLUSIVE NO-ERROR.
            IF NOT AVAILABLE tt-qttys THEN DO:
                CREATE tt-qttys.
                    ASSIGN tt-tipo = 'VTA'
                            tt-clave1 = ccbcdocu.codcli.
                lQtyClie = lQtyClie + 1.
            END.
            IF ccbcdocu.codmon = 1 THEN DO:
                lImpClieSol = lImpClieSol + ccbcdocu.imptot.
            END.
            ELSE lImpClieDol = lImpClieDol + ccbcdocu.imptot.            
        END.
        RUN gn/p-peso-volumen (DI-RutaD.CodRef, DI-RutaD.NroRef, 
                               OUTPUT lPeso, OUTPUT lVol, OUTPUT lImpVtaSol, OUTPUT lImpCtoSol).
        ASSIGN
            txtPeso = txtPeso + lPeso
            txtVol = txtVol + lVol
            NO-ERROR.
    END.
    /* Qttys Almacenes - Transferencias */
    FOR EACH di-rutaG WHERE di-rutaG.codcia = di-rutac.codcia AND 
        di-rutaG.coddiv = di-rutac.coddiv AND 
        di-rutaG.coddoc = di-rutac.coddoc AND
        di-rutaG.nrodoc = di-rutac.nrodoc NO-LOCK:
        lImpTranSol = lImpTranSol + di-rutaG.libre_d02.
        FIND FIRST almcmov WHERE almcmov.codcia = di-rutaG.codcia
            AND almcmov.codalm = di-rutag.codalm
            AND almcmov.tipmov = di-rutag.tipmov 
            AND almcmov.codmov = di-rutag.codmov
            AND almcmov.nroser = INTEGER(di-rutag.serref)
            AND almcmov.nrodoc = INTEGER(di-rutag.nroref)
            NO-LOCK NO-ERROR.
        IF AVAILABLE almcmov THEN DO:
            FOR EACH Almdmov OF Almcmov NO-LOCK, FIRST Almmmatg OF Almdmov NO-LOCK:
                ASSIGN
                    txtPeso = txtPeso + (Almdmov.candes * Almdmov.factor * Almmmatg.pesmat)
                    txtVol  = txtVol  + (Almdmov.candes * Almdmov.factor * Almmmatg.libre_d02 / 1000000)
                    NO-ERROR.
            END.
            FIND tt-qttys WHERE tt-qttys.tt-tipo = 'TRN' AND 
                tt-qttys.tt-clave1 = almcmov.AlmDes EXCLUSIVE NO-ERROR.
            IF NOT AVAILABLE tt-qttys THEN DO:
                CREATE tt-qttys.
                    ASSIGN 
                        tt-tipo = 'TRN'
                        tt-clave1 = almcmov.AlmDes.
                lQtyAlm = lQtyAlm + 1.
            END.
        END.
    END.
 
    ASSIGN
         txtNroClientes = lQtyClie
         txtPtosAlmacen = lQtyAlm
         txtClieDol = lImpClieDol
         txtClieSol = lImpClieSol
         txtTranDol = lImpTranDol
         txtTranSol = lImpTranSol
        .
    DISPLAY txtNroClientes txtPtosAlmacen txtClieDol txtClieSol txtTranDol
        txtTranSol txtPeso WITH FRAME {&FRAME-NAME}.
    DO WITH FRAME {&FRAME-NAME}:
        txtConductor:SCREEN-VALUE = "".
        FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = 'BREVETE' AND
            vtatabla.llave_c1 = DI-RutaC.libre_c01:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAILABLE vtatabla THEN DO:
            txtConductor:SCREEN-VALUE = vtatabla.libre_C01 + " " + vtatabla.libre_C02 + " " + vtatabla.libre_C03.
        END.
    END.
    DEF VAR pNombre AS CHAR NO-UNDO.
    DEF VAR pOrigen AS CHAR NO-UNDO.

    pNombre = ''.
    FILL-IN-Responsable:SCREEN-VALUE = ''.
    RUN logis/p-busca-por-dni ( INPUT DI-RutaC.responsable,
                                OUTPUT pNombre,
                                OUTPUT pOrigen).
    IF pOrigen <> 'ERROR' THEN
    DISPLAY pNombre @ FILL-IN-Responsable WITH FRAME {&FRAME-NAME}.

    pNombre = ''.
    FILL-IN-Ayudante-1:SCREEN-VALUE = ''.
    RUN logis/p-busca-por-dni ( INPUT DI-RutaC.ayudante-1,
                                OUTPUT pNombre,
                                OUTPUT pOrigen).
    IF pOrigen <> 'ERROR' THEN
    DISPLAY pNombre @ FILL-IN-Ayudante-1 WITH FRAME {&FRAME-NAME}.

    pNombre = ''.
    FILL-IN-Ayudante-2:SCREEN-VALUE = ''.
    RUN logis/p-busca-por-dni ( INPUT DI-RutaC.ayudante-2,
                                OUTPUT pNombre,
                                OUTPUT pOrigen).
    IF pOrigen <> 'ERROR' THEN
    DISPLAY pNombre @ FILL-IN-Ayudante-2 WITH FRAME {&FRAME-NAME}.
    
    pNombre = ''.
    FILL-IN-Ayudante-3:SCREEN-VALUE = ''.
    RUN logis/p-busca-por-dni ( INPUT DI-RutaC.ayudante-3,
                                OUTPUT pNombre,
                                OUTPUT pOrigen).
    IF pOrigen <> 'ERROR' THEN
    DISPLAY pNombre @ FILL-IN-Ayudante-3 WITH FRAME {&FRAME-NAME}.
    
    pNombre = ''.
    FILL-IN-Ayudante-4:SCREEN-VALUE = ''.
    RUN logis/p-busca-por-dni ( INPUT DI-RutaC.ayudante-4,
                                OUTPUT pNombre,
                                OUTPUT pOrigen).
    IF pOrigen <> 'ERROR' THEN
    DISPLAY pNombre @ FILL-IN-Ayudante-4 WITH FRAME {&FRAME-NAME}.
    
    pNombre = ''.
    FILL-IN-Ayudante-5:SCREEN-VALUE = ''.
    RUN logis/p-busca-por-dni ( INPUT DI-RutaC.ayudante-5,
                                OUTPUT pNombre,
                                OUTPUT pOrigen).
    IF pOrigen <> 'ERROR' THEN
    DISPLAY pNombre @ FILL-IN-Ayudante-5 WITH FRAME {&FRAME-NAME}.
    
    pNombre = ''.
    FILL-IN-Ayudante-6:SCREEN-VALUE = ''.
    RUN logis/p-busca-por-dni ( INPUT DI-RutaC.ayudante-6,
                                OUTPUT pNombre,
                                OUTPUT pOrigen).
    IF pOrigen <> 'ERROR' THEN
    DISPLAY pNombre @ FILL-IN-Ayudante-6 WITH FRAME {&FRAME-NAME}.
    
    pNombre = ''.
    FILL-IN-Ayudante-7:SCREEN-VALUE = ''.
    RUN logis/p-busca-por-dni ( INPUT DI-RutaC.ayudante-7,
                                OUTPUT pNombre,
                                OUTPUT pOrigen).
    IF pOrigen <> 'ERROR' THEN
    DISPLAY pNombre @ FILL-IN-Ayudante-7 WITH FRAME {&FRAME-NAME}.
  END.
  SESSION:SET-WAIT-STATE('').

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
  ENABLE txtHora txtMinuto txtHora-Ret txtMinuto-Ret txtNro txtSerie WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

   DEFINE VAR x-nrodoc AS CHAR.
   DEFINE VAR lxPRCID AS CHAR.

   DEFINE VAR x-prefijo-docto AS CHAR.
   DEFINE VAR x-codigo-barra-docto AS CHAR.
   DEFINE VAR x-pedido-anterior AS CHAR.
   DEFINE VAR x-nro-cotizacion AS CHAR.
   DEFINE VAR x-rowid AS ROWID.

   IF LOOKUP(Di-Rutac.FlgEst, "A") > 0 THEN RETURN.

   IF DI-RutaC.Libre_l01 = NO THEN DO:
       MESSAGE "Hoja de Ruta aún NO está confirmada".
       RETURN.
   END.

   /* Prefijo para el codigo de Barras  */
   RUN gn/prefijo-codigo-barras-doc(INPUT di-rutaC.coddoc, OUTPUT x-prefijo-docto).
   IF x-prefijo-docto = 'ERROR' THEN DO:
       MESSAGE "ERROR al ubicar el prefijo del codigo de barra para (" di-rutaC.coddoc + ")".
       RETURN.
   END.

   SESSION:SET-WAIT-STATE('GENERAL').
   RUN Carga-Reporte.
   SESSION:SET-WAIT-STATE('').

   DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
   DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
   DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
   DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
   DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

   GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE RB-REPORT-LIBRARY.
   RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "logis/rblogis.prl".
   RB-REPORT-NAME = "Hoja de Ruta".
   RB-INCLUDE-RECORDS = "O".
   RB-FILTER = "w-report.task-no = " + STRING(s-task-no).

   /* Datos de Impresión */
   DEF VAR cGen AS CHAR NO-UNDO.
   DEF VAR cCerr AS CHAR NO-UNDO.
   DEF VAR cImp AS CHAR NO-UNDO.

   FIND FIRST LogTabla WHERE logtabla.codcia = s-codcia AND
       logtabla.Evento = "WRITE" AND
       logtabla.Tabla = "DI-RUTAC" AND
       logtabla.ValorLlave = di-rutac.coddiv + '|' + di-rutac.coddoc + '|' + di-rutac.nrodoc
       NO-LOCK NO-ERROR.
   IF AVAILABLE LogTabla THEN cGen = logtabla.Usuario.
   cCerr = DI-RutaC.UsrCierre.
   cImp = s-User-Id.
   /* Pies de página */
   DEF VAR cResponsable AS CHAR NO-UNDO.
   DEF VAR cAyudante AS CHAR NO-UNDO.
   DEF VAR cChofer AS CHAR NO-UNDO.
   DEF VAR cDNIChofer AS CHAR NO-UNDO.
   DEF VAR cContactoDF AS CHAR NO-UNDO.
   DEF VAR cHoraDF AS CHAR NO-UNDO.
   
   cResponsable = FILL-IN-Responsable:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
   cAyudante = FILL-IN-Ayudante-1:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
   cChofer = txtConductor:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

/*    FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR. */
/*    IF AVAILABLE w-report THEN DO:                                           */
/*        MESSAGE 'hoy: ' w-report.Campo-C[29].                                */
/*        ASSIGN                                                               */
/*        cContactoDF = ENTRY(1, w-report.Campo-C[29], '|')                    */
/*        cHoraDF = ENTRY(2, w-report.Campo-C[29], '|').                       */
/*    END.                                                                     */
   RB-OTHER-PARAMETERS = "cGen=" + cGen + 
       "~ncCerr=" + cCerr +
       "~ncImp=" + cImp + 
       "~ns-nomcia=" + s-nomcia +
       "~ncResponsable=" + cResponsable + 
       "~ncAyudante=" + cAyudante + 
       "~ncChofer=" + cChofer.

   RUN lib/_imprime2 (INPUT RB-REPORT-LIBRARY,
                      INPUT RB-REPORT-NAME,
                      INPUT RB-INCLUDE-RECORDS,
                      INPUT RB-FILTER,
                      INPUT RB-OTHER-PARAMETERS).
    
   RUN Borra-Reporte.

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
/*   RUN Valida-Estibadores.                                */
/*   IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('pagina1').
  RUN Procesa-Handle IN lh_handle ('enable-detail').

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
  {src/adm/template/snd-list.i "DI-RutaC"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-racks V-table-Win 
PROCEDURE ue-racks :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  
  Notes:  Actualiza el RACK asignandole el Nro de Hoja de Ruta
------------------------------------------------------------------------------*/
DEFINE VAR lComa AS CHAR.
DEFINE VAR lCodDoc AS CHAR.
DEFINE VAR lNroDoc AS CHAR.
DEFINE VAR lPaletadespachada AS LOG.

EMPTY TEMP-TABLE tt-paletas.

DISABLE TRIGGERS FOR LOAD OF vtadtabla.
DISABLE TRIGGERS FOR LOAD OF vtatabla.

DEFINE BUFFER b-vtadtabla FOR vtadtabla.

/* Guias de Ventas */
FOR EACH Di-RutaD OF Di-RutaC NO-LOCK, 
  FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = DI-RutaC.codcia
  AND Ccbcdocu.coddoc = DI-RutaD.CodRef
  AND Ccbcdocu.nrodoc = DI-RutaD.NroRef:    

  /* Chequeo si la O/D esta en el detalle del RACK */
  FIND FIRST b-vtadtabla WHERE b-vtadtabla.codcia = DI-RutaC.codcia AND
        b-vtadtabla.tabla = 'MOV-RACK-DTL' AND 
        b-vtadtabla.libre_c03 = ccbcdocu.libre_c01 AND 
        b-vtadtabla.llavedetalle = ccbcdocu.libre_c02 EXCLUSIVE NO-ERROR.
  IF AVAILABLE b-vtadtabla THEN DO:
      lComa = "".
      IF (b-vtadtabla.libre_c05 = ? OR TRIM(b-vtadtabla.libre_c05) = "") THEN 
          lComa = "".
      ELSE lComa = TRIM(b-vtadtabla.libre_c05).
      /* Grabo la Hoja de Ruta */
      ASSIGN b-vtadtabla.libre_c05 = (lComa + 
            IF(lComa="") THEN "" ELSE ", " + trim(Di-RutaC.coddoc)).

      /*  */
      FIND FIRST tt-paletas WHERE tt-paletas.tt-division = b-vtadtabla.llave AND 
                tt-paletas.tt-paleta = b-vtadtabla.tipo EXCLUSIVE NO-ERROR.
      IF NOT AVAILABLE tt-paletas THEN DO:
          CREATE tt-paletas.
          ASSIGN tt-paletas.tt-paleta = b-vtadtabla.tipo
                tt-paletas.tt-division = b-vtadtabla.llave.
      END.
  END.
  RELEASE b-vtadtabla.

END.
/* OTR ¢ TRA */
FOR EACH Di-RutaG OF Di-RutaC NO-LOCK, 
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

    DEFINE BUFFER bb-vtadtabla FOR vtadtabla.

    /* Chequeo si la O/D esta en el detalle del RACK */
    FIND FIRST bb-vtadtabla WHERE bb-vtadtabla.codcia = DI-RutaC.codcia AND
          bb-vtadtabla.tabla = 'MOV-RACK-DTL' AND 
          bb-vtadtabla.libre_c03 = ccbcdocu.libre_c01 AND 
          bb-vtadtabla.llavedetalle = ccbcdocu.libre_c02 EXCLUSIVE NO-ERROR.
    IF AVAILABLE bb-vtadtabla THEN DO:
        lComa = "".
        IF (bb-vtadtabla.libre_c05 = ? OR TRIM(bb-vtadtabla.libre_c05) = "") THEN 
            lComa = "".
        ELSE lComa = TRIM(bb-vtadtabla.libre_c05).
        /* Grabo la Hoja de Ruta */
        ASSIGN bb-vtadtabla.libre_c05 = (lComa + 
              IF(lComa="") THEN "" ELSE ", " + trim(Di-RutaC.coddoc)).

        /*  */
        FIND FIRST tt-paletas WHERE tt-paletas.tt-division = bb-vtadtabla.llave AND
            tt-paletas.tt-paleta = bb-vtadtabla.tipo EXCLUSIVE NO-ERROR.
        IF NOT AVAILABLE tt-paletas THEN DO:
            CREATE tt-paletas.
            ASSIGN tt-paletas.tt-paleta = bb-vtadtabla.tipo
                    tt-paletas.tt-division = bb-vtadtabla.llave.
        END.
    END.
    RELEASE bb-vtadtabla.
END.

/* Libero RACKS */
FOR EACH tt-paletas :
    /* Ubico la Paleta */
    FIND FIRST vtactabla WHERE vtactabla.codcia = s-codcia AND 
                vtactabla.tabla = "MOV-RACK-HDR" AND 
                vtactabla.llave BEGINS tt-paletas.tt-division AND 
                vtactabla.libre_c02 = tt-paletas.tt-paleta NO-LOCK NO-ERROR.

    IF AVAILABLE vtactabla THEN DO:
        /* Chequeo si todo el detalle de la paleta tiene HR (hoja de ruta) */
        lPaletadespachada = YES.
        FOR EACH vtadtabla WHERE vtadtabla.codcia = s-codcia AND 
                vtadtabla.tabla = "MOV-RACK-DTL" AND 
                vtadtabla.llave = tt-paletas.tt-paleta AND 
                vtadtabla.tipo = tt-paletas.tt-paleta NO-LOCK :
            IF (vtadtabla.libre_c05 = ? OR vtadtabla.libre_c05 = "") THEN lPaletadespachada = NO.
        END.
        IF lPaletadespachada = YES THEN DO:
            /* Todos los O/D, OTR, TRA de la paleta tienen HR (Hoja de Ruta) */            

            FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                        vtatabla.tabla = 'RACKS' AND 
                        vtatabla.llave_c1 = tt-paletas.tt-division AND
                        vtatabla.llave_c2 = vtactabla.libre_c01 EXCLUSIVE NO-ERROR.
            IF AVAILABLE vtatabla THEN DO:
                ASSIGN vtatabla.valor[2] = vtatabla.valor[2] - 1.
                ASSIGN vtatabla.valor[2] = IF (vtatabla.valor[2] < 0) THEN 0 ELSE vtatabla.valor[2].
            END.
            
        END.
    END.
END.

IF AVAILABLE Vtadtabla THEN RELEASE vtadtabla.
IF AVAILABLE Vtatabla THEN RELEASE Vtatabla.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um-imprimir-hoja-de-atencion V-table-Win 
PROCEDURE um-imprimir-hoja-de-atencion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-nrodoc AS CHAR.

x-nrodoc = DI-Rutac.Nrodoc.

/* LOGICA PRINCIPAL */
/* Pantalla general de parametros de impresion */
RUN bin/_prnctr.p.
IF s-salida-impresion = 0 THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').
/* creo el temporal */ 
REPEAT:
    s-task-no = RANDOM(1, 999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no
                    AND w-report.llave-c = s-user-id NO-LOCK)
        THEN DO:
        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no.
        LEAVE.
    END.
END.

/* Busco los Clientes de las guias de ventas */
/*FOR EACH di-rutad WHERE di-rutad.codcia = s-codcia AND 
                    di-rutad.coddoc = 'H/R' AND di-rutad.nrodoc = X-nrodoc NO-LOCK:*/
FOR EACH di-rutaD OF di-rutaC NO-LOCK:
    FIND ccbcdocu WHERE ccbcdocu.codcia = di-rutad.codcia
      AND ccbcdocu.coddoc = DI-RutaD.CodRef
      AND ccbcdocu.nrodoc = DI-RutaD.NroRef
      NO-LOCK NO-ERROR.
    IF AVAILABLE ccbcdocu THEN DO:
        FIND FIRST w-report WHERE w-report.task-no = s-task-no AND
                                    w-report.llave-c = x-nrodoc AND
                                    w-report.campo-c[1] = ccbcdocu.codcli 
                                    EXCLUSIVE NO-ERROR.
        IF NOT AVAILABLE w-report THEN DO:
            CREATE w-report.
            ASSIGN
                w-report.task-no = s-task-no
                w-report.llave-c = x-nrodoc
                w-report.campo-c[1] = ccbcdocu.codcli
                w-report.campo-c[2] = ccbcdocu.nomcli 
                w-report.campo-c[3] = ccbcdocu.dircli 
                w-report.campo-c[4] = ccbcdocu.ruccli
                w-report.campo-d[1] = di-rutaC.fchdoc .
        END.
    END.
END.
/* Los Clientes de las Guias de Transferencias  */
FOR EACH di-rutaG OF di-rutaC NO-LOCK:
    FIND FIRST almcmov WHERE almcmov.codcia = s-codcia AND 
                            almcmov.codalm = di-rutaG.codalm AND
                            almcmov.tipmov = di-rutaG.tipmov AND
                            almcmov.codmov = di-rutaG.codmov AND 
                            almcmov.nroser = di-rutaG.serref AND
                            almcmov.nrodoc = di-rutaG.nroref NO-LOCK NO-ERROR.
    IF AVAILABLE almcmov THEN DO:
        FIND FIRST w-report WHERE w-report.task-no = s-task-no AND
                                    w-report.llave-c = x-nrodoc AND
                                    w-report.campo-c[1] = almcmov.almdes
                                    EXCLUSIVE NO-ERROR.
        IF NOT AVAILABLE w-report THEN DO:
            /* Busco datos del Almacen */
            FIND FIRST almacen WHERE almacen.codcia = s-codcia AND
                                    almacen.codalm = almcmov.almdes NO-LOCK NO-ERROR.
            CREATE w-report.
            ASSIGN
                w-report.task-no = s-task-no
                w-report.llave-c = x-nrodoc
                w-report.campo-c[1] = almcmov.almdes
                w-report.campo-c[2] = IF(AVAILABLE almacen) THEN almacen.descripcion ELSE ""
                w-report.campo-c[3] = IF(AVAILABLE almacen) THEN almacen.diralm ELSE "" 
                w-report.campo-c[4] = IF(AVAILABLE almacen) THEN almacen.codcli ELSE "" /* RUC almcen */
                w-report.campo-d[1] = di-rutaC.fchdoc.  
        END.

    END.
END.

/* Guias itinerantes */
FOR EACH di-rutaDG OF di-rutaC NO-LOCK:
    FIND ccbcdocu WHERE ccbcdocu.codcia = di-rutaDG.codcia
      AND ccbcdocu.coddoc = DI-RutaDG.CodRef
      AND ccbcdocu.nrodoc = DI-RutaDG.NroRef
      NO-LOCK NO-ERROR.
    IF AVAILABLE ccbcdocu THEN DO:
        FIND FIRST w-report WHERE w-report.task-no = s-task-no AND
                                    w-report.llave-c = x-nrodoc AND
                                    w-report.campo-c[1] = ccbcdocu.codcli 
                                    EXCLUSIVE NO-ERROR.
        IF NOT AVAILABLE w-report THEN DO:
            CREATE w-report.
            ASSIGN
                w-report.task-no = s-task-no
                w-report.llave-c = x-nrodoc
                w-report.campo-c[1] = ccbcdocu.codcli
                w-report.campo-c[2] = ccbcdocu.nomcli 
                w-report.campo-c[3] = ccbcdocu.dircli 
                w-report.campo-c[4] = ccbcdocu.ruccli
                w-report.campo-d[1] = di-rutaC.fchdoc.
        END.
    END.
END.
SESSION:SET-WAIT-STATE('').
 
/* Ahora a IMPRIMIR */
FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND
                gn-divi.coddiv = di-rutaC.coddiv NO-LOCK NO-ERROR.
RB-INCLUDE-RECORDS = "O".
 RB-FILTER = " w-report.task-no = " + STRING(s-task-no) +  
              " AND w-report.llave-c = '" + x-nrodoc + "'".
  RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia +
                        "~ns-division = " + IF(AVAILABLE gn-divi) THEN gn-divi.desdiv ELSE "".

DEFINE VARIABLE cDatabaseName    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cHostName        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNetworkProto    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPortNumber      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cOtherParams     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNewConnString   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDelimeter       AS CHARACTER NO-UNDO.

GET-KEY-VALUE SECTION "RBParametros" KEY "cDatabaseName" VALUE cDatabaseName.
GET-KEY-VALUE SECTION "RBParametros" KEY "cHostName" VALUE cHostName.
GET-KEY-VALUE SECTION "RBParametros" KEY "cNetworkProto" VALUE cNetworkProto.
GET-KEY-VALUE SECTION "RBParametros" KEY "cPortNumber" VALUE cPortNumber.
GET-KEY-VALUE SECTION "RBParametros" KEY "cOtherParams" VALUE cOtherParams.

ASSIGN cDelimeter = CHR(32).
IF NOT (cDatabaseName = ? OR
   cHostName = ? OR
   cNetworkProto = ? OR
   cPortNumber = ?) THEN DO:
   ASSIGN
       cNewConnString =
       "-db" + cDelimeter + cDatabaseName + cDelimeter +
       "-H" + cDelimeter + cHostName + cDelimeter +
       "-N" + cDelimeter + cNetworkProto + cDelimeter +
       "-S" + cDelimeter + cPortNumber + cDelimeter.
   RB-DB-CONNECTION = cNewConnString.
END.


  ASSIGN
      /*RB-REPORT-NAME = "Hoja Ruta2"*/
      /*B-REPORT-NAME = "Hoja Ruta2a"*/ 
      RB-REPORT-NAME = "Hoja Atencion al cliente"
      RB-BEGIN-PAGE = s-pagina-inicial
      RB-END-PAGE = s-pagina-final
      RB-PRINTER-NAME = s-printer-name
      RB-OUTPUT-FILE = s-print-file
      RB-NUMBER-COPIES = s-nro-copias.
  CASE s-salida-impresion:
      WHEN 1 THEN RB-PRINT-DESTINATION = "D".     /* Pantalla */
      WHEN 2 THEN RB-PRINT-DESTINATION = "".      /* Impresora */
      WHEN 3 THEN RB-PRINT-DESTINATION = "A".     /* Archivo */
  END CASE.
  /*
  FIND FIRST DI-RutaD OF DI-RutaC NO-LOCK NO-ERROR.
  IF AVAILABLE DI-RutaD THEN
  */
  RUN aderb/_prntrb2 (RB-REPORT-LIBRARY,
                      RB-REPORT-NAME,
                      RB-DB-CONNECTION,
                      RB-INCLUDE-RECORDS,
                      RB-FILTER,
                      RB-MEMO-FILE,
                      RB-PRINT-DESTINATION,
                      RB-PRINTER-NAME,
                      RB-PRINTER-PORT,
                      RB-OUTPUT-FILE,
                      RB-NUMBER-COPIES,
                      RB-BEGIN-PAGE,
                      RB-END-PAGE,
                      RB-TEST-PATTERN,
                      RB-WINDOW-TITLE,
                      RB-DISPLAY-ERRORS,
                      RB-DISPLAY-STATUS,
                      RB-NO-WAIT,
                      RB-OTHER-PARAMETERS,
                      "").

/* Borar el temporal */
FOR EACH w-report WHERE w-report.task-no = s-task-no :
    DELETE w-report.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     Validacion de datos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  x-GlosaApertura = ''.
  RUN gn/d-glosa (OUTPUT x-GlosaApertura).
  IF TRUE <> (x-GlosaApertura > '') THEN RETURN 'ADM-ERROR'.

  /* VALIDACIONES COMUNES */
  DO WITH FRAME {&FRAME-NAME}:
      /* PLACA */
      FIND gn-vehic WHERE gn-vehic.codcia = s-codcia AND 
          gn-vehic.placa = DI-RutaC.CodVeh:SCREEN-VALUE AND
          gn-vehic.Libre_c05 = "SI" AND
          CAN-FIND(FIRST gn-prov WHERE gn-prov.CodCia = pv-CodCia AND
                   gn-prov.CodPro = gn-vehic.CodPro NO-LOCK)
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-vehic THEN DO:
          MESSAGE 'Placa NO válida o vehículo NO ACTIVO' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO DI-RutaC.CodVeh.
          RETURN 'ADM-ERROR'.
      END.
      IF gn-vehic.VtoRevTecnica = ? THEN DO:
          MESSAGE 'Vehículo no tiene registrada la fecha de revisión técnica'
              VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO DI-RutaC.CodVeh.
          RETURN 'ADM-ERROR'.
      END.
      IF gn-vehic.VtoExtintor = ? THEN DO:
          MESSAGE 'Vehículo no tiene registrada la fecha de vencimiento de extintor'
              VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO DI-RutaC.CodVeh.
          RETURN 'ADM-ERROR'.
      END.
      IF gn-vehic.VtoSoat = ? THEN DO:
          MESSAGE 'Vehículo no tiene registrada la fecha de vencimiento del SOAT'
              VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO DI-RutaC.CodVeh.
          RETURN 'ADM-ERROR'.
      END.
      IF gn-vehic.VtoRevTecnica < TODAY OR 
          gn-vehic.VtoExtintor < TODAY OR 
          gn-vehic.VtoSoat < TODAY THEN DO:
          MESSAGE 'Vencimiento de revisión técnica, fecha de vencimiento del extintor, fecha de vencimiento del SOAT vencidas.' SKIP
              'Revisar con el área de transportes'
              VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO DI-RutaC.CodVeh.
          RETURN 'ADM-ERROR'.
      END.
      IF gn-vehic.VtoRevTecnica <= (TODAY + 2) OR 
          gn-vehic.VtoExtintor <= (TODAY + 2) OR 
          gn-vehic.VtoSoat <= (TODAY + 2) THEN DO:
          MESSAGE 'Vencimiento de revisión técnica, fecha de vencimiento del extintor, fecha de vencimiento del SOAT a punto de vencer.' SKIP
              'Revisar con el área de transportes'
              VIEW-AS ALERT-BOX WARNING.
      END.


      ASSIGN 
          txtHora txtMinuto txtCodPro txtDTrans txtSerie txtNro.
      IF txtHora < 0 OR txtHora > 23 THEN DO:
          MESSAGE 'Hora Incorrecta..(00..23)' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO txtHora.
          RETURN 'ADM-ERROR'.
      END.
      IF txtMinuto < 0 OR txtMinuto > 59 THEN DO:
          MESSAGE 'Minutos Incorrecto..(00..59)' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO txtMinuto.
          RETURN 'ADM-ERROR'.
      END.
      IF txtHora = 0 OR txtHora = 0 THEN DO: 
          MESSAGE 'Hora/Minuto Incorrecto..' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO txtHora.
          RETURN 'ADM-ERROR'.
      END.
      ASSIGN
          txtHora-Ret txtMinuto-Ret.
      IF txtHora-Ret < 0 OR txtHora-Ret > 23 THEN DO:
          MESSAGE 'Hora Incorrecta..(00..23)' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO txtHora-Ret.
          RETURN 'ADM-ERROR'.
      END.
      IF txtMinuto-Ret < 0 OR txtMinuto-Ret > 59 THEN DO:
          MESSAGE 'Minutos Incorrecto..(00..59)' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO txtMinuto-Ret.
          RETURN 'ADM-ERROR'.
      END.
      IF txtHora-Ret = 0 OR txtHora-Ret = 0 THEN DO: 
          MESSAGE 'Hora/Minuto Incorrecto..' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO txtHora-Ret.
          RETURN 'ADM-ERROR'.
      END.
      /* FECHA DE SALIDA */
      DEFINE VAR lFechaIng AS DATE.
      DEFINE VAR lFechaSal AS DATE.

      lFechaIng = DATE(DI-RutaC.FchDoc:SCREEN-VALUE).
      lFechaSal = DATE(DI-RutaC.FchSal:SCREEN-VALUE).

      IF INPUT DI-RutaC.FchSal = ? THEN DO:
          MESSAGE 'Fecha de salida esta Vacia' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO di-rutac.FchSal.
          RETURN 'ADM-ERROR'.
      END.

      /* ***************************************************************************** */
      /* 24/11/2020 F.O. Fecha de salida y retorno +- 48 horas */
      /* ***************************************************************************** */
      IF ABSOLUTE(lFechaSal - lFechaIng) > 3 THEN DO:
          MESSAGE 'Fecha de salida debe estar en un rango no mayor a 48 horas' 
              VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO di-rutac.FchSal.
          RETURN 'ADM-ERROR'.
      END.
/*       IF INPUT DI-RutaC.FchSal < lFechaIng THEN DO:                                           */
/*           MESSAGE 'Fecha de salida errada' VIEW-AS ALERT-BOX ERROR.                           */
/*           APPLY 'ENTRY':U TO di-rutac.FchSal.                                                 */
/*           RETURN 'ADM-ERROR'.                                                                 */
/*       END.                                                                                    */
/*       /*                                                                                      */
/*       10Jul2017, correo de Carlos Lalangui/Felix Perez                                        */
/*       restricción solicitada es por 48 horas útiles,                                          */
/*       considerando el día sábado como útil.                                                   */
/*       03Oct2017, Fernan Oblitas/Harold Segura 3 dias                                          */
/*       */                                                                                      */
/*       IF lFechaSal > (lFechaIng + 3) THEN DO:                                                 */
/*           MESSAGE 'Fecha de salida no debe sobre pasar las 48 Horas' VIEW-AS ALERT-BOX ERROR. */
/*           APPLY 'ENTRY':U TO di-rutac.FchSal.                                                 */
/*           RETURN 'ADM-ERROR'.                                                                 */
/*       END.                                                                                    */
      /* ***************************************************************************** */
      /* FECHA DE RETORNO */
      /* ***************************************************************************** */
      DEFINE VAR lFechaRet AS DATE.

      lFechaRet = DATE(DI-RutaC.FchRet:SCREEN-VALUE).

      IF INPUT DI-RutaC.FchRet = ? THEN DO:
          MESSAGE 'Fecha de retorno esta Vacia' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO di-rutac.FchRet.
          RETURN 'ADM-ERROR'.
      END.

      IF ABSOLUTE(lFechaRet - lFechaIng) > 3 THEN DO:
          MESSAGE 'Fecha de retorno debe estar en un rango no mayor a 48 horas' 
              VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO di-rutac.FchSal.
          RETURN 'ADM-ERROR'.
      END.
      IF INPUT DI-RutaC.FchRet < lFechaSal THEN DO:
          MESSAGE 'Fecha de retorno errada' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO di-rutac.FchRet.
          RETURN 'ADM-ERROR'.
      END.
      /* ***************************************************************************** */
      /* CONTROL DE RESPONSABLE Y AYUDANTES */
      /* ***************************************************************************** */
      IF TRUE <> (DI-RutaC.responsable:SCREEN-VALUE > '') THEN DO:
          MESSAGE 'Debe ingresar el responsable' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO di-rutac.responsable.
          RETURN 'ADM-ERROR'.
      END.
      /* ***************************************************************************** */
      /* GUIA  DEL TRANSPORTISTA */
      /* ***************************************************************************** */
      IF txtSerie <= 0 THEN DO:
          MESSAGE 'Ingrese la serie de Guia del Transportista..' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO txtSerie.
          RETURN 'ADM-ERROR'.
      END.
      IF txtNro <= 0 THEN DO:
          MESSAGE 'Ingrese el nro de Guia del Transportista..' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO txtNro.
          RETURN 'ADM-ERROR'.
      END.
      DEF BUFFER B-RutaC FOR DI-RutaC.
      FIND FIRST B-RutaC WHERE B-RutaC.codcia = s-codcia 
          AND B-RutaC.codpro = txtCodPro
          AND B-RutaC.GuiaTransportista = STRING(txtSerie, '999') + "-" + STRING(txtNro , '99999999')
          AND B-RutaC.CodDoc = "H/R"
          AND B-RutaC.NroDoc <> Di-RutaC.NroDoc
          AND B-RutaC.FlgEst <> 'A'
          NO-LOCK NO-ERROR.
      IF AVAILABLE B-RutaC THEN DO:
          MESSAGE 'Guia del Transportista YA fue registrada en la H/R Nro.' B-RutaC.NroDoc
              VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO txtSerie.
          RETURN 'ADM-ERROR'.
      END.
      /* VALIDACIONES POR CD o TIENDA */
      /* Verificar Repetidos */
      DEF VAR cCadenaTotal AS CHAR NO-UNDO.
      DEF VAR iIndice AS INTE NO-UNDO.
      cCadenaTotal = DI-RutaC.responsable:SCREEN-VALUE.
      DO iIndice = 1 TO gn-vehic.NroEstibadores:
          CASE iIndice:
              WHEN 1 THEN DO:
                  IF DI-RutaC.ayudante-1:SCREEN-VALUE > '' THEN cCadenaTotal = cCadenaTotal + ',' + TRIM(DI-RutaC.ayudante-1:SCREEN-VALUE).
              END.
              WHEN 2 THEN DO:
                  IF DI-RutaC.ayudante-2:SCREEN-VALUE > '' THEN cCadenaTotal = cCadenaTotal + ',' + TRIM(DI-RutaC.ayudante-2:SCREEN-VALUE).
              END.
              WHEN 3 THEN DO:
                  IF DI-RutaC.ayudante-3:SCREEN-VALUE > '' THEN cCadenaTotal = cCadenaTotal + ',' + TRIM(DI-RutaC.ayudante-3:SCREEN-VALUE).
              END.
              WHEN 4 THEN DO:
                  IF DI-RutaC.ayudante-4:SCREEN-VALUE > '' THEN cCadenaTotal = cCadenaTotal + ',' + TRIM(DI-RutaC.ayudante-4:SCREEN-VALUE).
              END.
              WHEN 5 THEN DO:
                  IF DI-RutaC.ayudante-5:SCREEN-VALUE > '' THEN cCadenaTotal = cCadenaTotal + ',' + TRIM(DI-RutaC.ayudante-5:SCREEN-VALUE).
              END.
              WHEN 6 THEN DO:
                  IF DI-RutaC.ayudante-6:SCREEN-VALUE > '' THEN cCadenaTotal = cCadenaTotal + ',' + TRIM(DI-RutaC.ayudante-6:SCREEN-VALUE).
              END.
              WHEN 7 THEN DO:
                  IF DI-RutaC.ayudante-7:SCREEN-VALUE > '' THEN cCadenaTotal = cCadenaTotal + ',' + TRIM(DI-RutaC.ayudante-7:SCREEN-VALUE).
              END.
          END CASE.
      END.
      DO iIndice = 1 TO NUM-ENTRIES(cCadenaTotal):
          IF INDEX(cCadenaTotal, ENTRY(iIndice,cCadenaTotal)) <> R-INDEX(cCadenaTotal, ENTRY(iIndice,cCadenaTotal))
              THEN DO:
              MESSAGE 'Repetido el responsable o ayudante' ENTRY(iIndice,cCadenaTotal)
                  VIEW-AS ALERT-BOX ERROR.
              RETURN 'ADM-ERROR'.
          END.
      END.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida-Estibadores V-table-Win 
PROCEDURE Valida-Estibadores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Levantamos la libreria a memoria */
  DEFINE VAR x-Estibadores AS CHAR NO-UNDO.
  DEFINE VAR hProc AS HANDLE NO-UNDO.
  DEFINE VAR pMensaje AS CHAR NO-UNDO.
  DEFINE VAR k AS INT NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
      IF DI-RutaC.ayudante-1:SCREEN-VALUE > '' THEN
          x-Estibadores = x-Estibadores + (IF TRUE <> (x-Estibadores > '') THEN '' ELSE ',') + DI-RutaC.ayudante-1:SCREEN-VALUE.
      IF DI-RutaC.ayudante-2:SCREEN-VALUE > '' THEN
          x-Estibadores = x-Estibadores + (IF TRUE <> (x-Estibadores > '') THEN '' ELSE ',') + DI-RutaC.ayudante-2:SCREEN-VALUE.
      IF DI-RutaC.ayudante-3:SCREEN-VALUE > '' THEN
          x-Estibadores = x-Estibadores + (IF TRUE <> (x-Estibadores > '') THEN '' ELSE ',') + DI-RutaC.ayudante-3:SCREEN-VALUE.
      IF DI-RutaC.ayudante-4:SCREEN-VALUE > '' THEN
          x-Estibadores = x-Estibadores + (IF TRUE <> (x-Estibadores > '') THEN '' ELSE ',') + DI-RutaC.ayudante-4:SCREEN-VALUE.
      IF DI-RutaC.ayudante-5:SCREEN-VALUE > '' THEN
          x-Estibadores = x-Estibadores + (IF TRUE <> (x-Estibadores > '') THEN '' ELSE ',') + DI-RutaC.ayudante-5:SCREEN-VALUE.
      IF DI-RutaC.ayudante-6:SCREEN-VALUE > '' THEN
          x-Estibadores = x-Estibadores + (IF TRUE <> (x-Estibadores > '') THEN '' ELSE ',') + DI-RutaC.ayudante-6:SCREEN-VALUE.
      IF DI-RutaC.ayudante-7:SCREEN-VALUE > '' THEN
          x-Estibadores = x-Estibadores + (IF TRUE <> (x-Estibadores > '') THEN '' ELSE ',') + DI-RutaC.ayudante-7:SCREEN-VALUE.

      RUN dist/dist-librerias PERSISTENT SET hProc.
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'NO' THEN DO:
          RUN HR_Verifica-Estibadores IN hProc (INPUT "NO",                  /* Nuevo Registro? */
                                                INPUT DI-RutaC.CodDiv,
                                                INPUT DI-RutaC.CodDoc,
                                                INPUT DI-RutaC.NroDoc,
                                                INPUT DI-RutaC.responsable:SCREEN-VALUE,
                                                INPUT x-Estibadores,
                                                OUTPUT pMensaje).
      END.
      ELSE DO:
          RUN HR_Verifica-Estibadores IN hProc (INPUT "YES",                  /* Nuevo Registro? */
                                                s-CodDiv,
                                                s-CodDoc,
                                                '',
                                                INPUT DI-RutaC.responsable:SCREEN-VALUE,
                                                INPUT x-Estibadores,
                                                OUTPUT pMensaje).
      END.
  END.
  DELETE PROCEDURE hProc.
  IF pMensaje > '' THEN DO:
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida-Personal V-table-Win 
PROCEDURE Valida-Personal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pDNI AS CHAR.
DEF OUTPUT PARAMETER pNombre AS CHAR.
DEF OUTPUT PARAMETER pOrigen AS CHAR.

RUN logis/p-busca-por-dni ( INPUT pDNI,
                            OUTPUT pNombre,
                            OUTPUT pOrigen).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     Rutina de validacion en caso de modificacion
  Parameters:  Regresar "ADM-ERROR" si no se quiere modificar
  Notes:       
------------------------------------------------------------------------------*/

IF LOOKUP(DI-RutaC.FlgEst, "P,PR") = 0 THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  ASSIGN
      x-GlosaAprobacion = DI-RutaC.GlosaAprobacion 
      x-UsrAprobacion = DI-RutaC.UsrAprobacion
      x-FchAprobacion = DI-RutaC.FchAprobacion.

  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

