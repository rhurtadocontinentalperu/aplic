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
DEFINE TEMP-TABLE T-RutaD NO-UNDO LIKE DI-RutaD.



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
DEF SHARED VAR s-acceso-total AS LOG.
DEF SHARED VAR s-Dias-Limite AS INT NO-UNDO.    /* Dias H/R Pendientes */

DEF VAR x-NroDoc LIKE di-rutac.nrodoc.

DEFINE VAR s-task-no AS INT.
DEF VAR x-peso AS DEC NO-UNDO.
DEF VAR x-volumen AS DEC NO-UNDO.
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

DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.
DEFINE TEMP-TABLE t-ccbcdocu LIKE ccbcdocu.

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
&Scoped-Define ENABLED-FIELDS DI-RutaC.Libre_l01 DI-RutaC.CodVeh ~
DI-RutaC.TpoTra DI-RutaC.FchSal DI-RutaC.Libre_d05 DI-RutaC.KmtIni ~
DI-RutaC.responsable DI-RutaC.ayudante-1 DI-RutaC.ayudante-2 ~
DI-RutaC.Libre_c01 DI-RutaC.Ayudante-3 DI-RutaC.DesRut DI-RutaC.Ayudante-4 ~
DI-RutaC.Ayudante-5 DI-RutaC.Ayudante-6 DI-RutaC.Ayudante-7 
&Scoped-define ENABLED-TABLES DI-RutaC
&Scoped-define FIRST-ENABLED-TABLE DI-RutaC
&Scoped-Define ENABLED-OBJECTS RECT-15 
&Scoped-Define DISPLAYED-FIELDS DI-RutaC.NroDoc DI-RutaC.Libre_l01 ~
DI-RutaC.Libre_c03 DI-RutaC.FchDoc DI-RutaC.CodVeh DI-RutaC.TpoTra ~
DI-RutaC.usuario DI-RutaC.FchSal DI-RutaC.Libre_d05 DI-RutaC.Libre_c05 ~
DI-RutaC.Libre_f05 DI-RutaC.KmtIni DI-RutaC.responsable ~
DI-RutaC.TipResponsable DI-RutaC.ayudante-1 DI-RutaC.TipAyudante-1 ~
DI-RutaC.ayudante-2 DI-RutaC.TipAyudante-2 DI-RutaC.Libre_c01 ~
DI-RutaC.Ayudante-3 DI-RutaC.TipAyudante-3 DI-RutaC.DesRut ~
DI-RutaC.Ayudante-4 DI-RutaC.TipAyudante-4 DI-RutaC.Ayudante-5 ~
DI-RutaC.TipAyudante-5 DI-RutaC.Ayudante-6 DI-RutaC.TipAyudante-6 ~
DI-RutaC.Ayudante-7 DI-RutaC.TipAyudante-7 
&Scoped-define DISPLAYED-TABLES DI-RutaC
&Scoped-define FIRST-DISPLAYED-TABLE DI-RutaC
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Estado FILL-IN-Marca txtHora ~
txtMinuto FILL-IN-Responsable txtCodPro txtDTrans FILL-IN-Ayudante-1 ~
txtSerie txtNro FILL-IN-Ayudante-2 txtConductor FILL-IN-Ayudante-3 ~
FILL-IN-Ayudante-4 FILL-IN-Ayudante-5 FILL-IN-Ayudante-6 FILL-IN-Ayudante-7 ~
txtCargaMaxima txtPeso txtNroClientes txtClieSol txtClieDol txtVolumen ~
txtVol txtPtosAlmacen txtTranSol txtTranDol 

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
     SIZE 3 BY .81.

DEFINE VARIABLE txtMinuto AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "MM" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .81.

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
     DI-RutaC.Libre_f05 AT ROW 2.62 COL 113.72 COLON-ALIGNED WIDGET-ID 72
          LABEL "Día"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     DI-RutaC.KmtIni AT ROW 3.42 COL 16 COLON-ALIGNED
          LABEL "Kilometraje de salida" FORMAT ">>>,>>9"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     DI-RutaC.responsable AT ROW 3.69 COL 81 COLON-ALIGNED
          LABEL "Responsable" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     FILL-IN-Responsable AT ROW 3.69 COL 92 COLON-ALIGNED NO-LABEL
     DI-RutaC.TipResponsable AT ROW 3.69 COL 127 COLON-ALIGNED NO-LABEL WIDGET-ID 112
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     txtCodPro AT ROW 4.23 COL 16 COLON-ALIGNED WIDGET-ID 32
     txtDTrans AT ROW 4.23 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     DI-RutaC.ayudante-1 AT ROW 4.5 COL 81 COLON-ALIGNED
          LABEL "Ayudante 1" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     FILL-IN-Ayudante-1 AT ROW 4.5 COL 92 COLON-ALIGNED NO-LABEL
     DI-RutaC.TipAyudante-1 AT ROW 4.5 COL 127 COLON-ALIGNED NO-LABEL WIDGET-ID 98
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     txtSerie AT ROW 5.04 COL 16 COLON-ALIGNED WIDGET-ID 16
     txtNro AT ROW 5.04 COL 25 COLON-ALIGNED WIDGET-ID 18
     DI-RutaC.ayudante-2 AT ROW 5.31 COL 81 COLON-ALIGNED
          LABEL "Ayudante 2" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     FILL-IN-Ayudante-2 AT ROW 5.31 COL 92 COLON-ALIGNED NO-LABEL
     DI-RutaC.TipAyudante-2 AT ROW 5.31 COL 127 COLON-ALIGNED NO-LABEL WIDGET-ID 100
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     DI-RutaC.Libre_c01 AT ROW 5.85 COL 16 COLON-ALIGNED WIDGET-ID 64
          LABEL "Conductor (Licencia)" FORMAT "x(10)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     txtConductor AT ROW 5.85 COL 27.86 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     DI-RutaC.Ayudante-3 AT ROW 6.12 COL 81 COLON-ALIGNED WIDGET-ID 78
          LABEL "Ayudante 3" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     FILL-IN-Ayudante-3 AT ROW 6.12 COL 92 COLON-ALIGNED NO-LABEL WIDGET-ID 88
     DI-RutaC.TipAyudante-3 AT ROW 6.12 COL 127 COLON-ALIGNED NO-LABEL WIDGET-ID 102
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     DI-RutaC.DesRut AT ROW 6.65 COL 18 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 200 SCROLLBAR-VERTICAL
          SIZE 54 BY 3.77
     DI-RutaC.Ayudante-4 AT ROW 6.92 COL 81 COLON-ALIGNED WIDGET-ID 80
          LABEL "Ayudante 4" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     FILL-IN-Ayudante-4 AT ROW 6.92 COL 92 COLON-ALIGNED NO-LABEL WIDGET-ID 90
     DI-RutaC.TipAyudante-4 AT ROW 6.92 COL 127 COLON-ALIGNED NO-LABEL WIDGET-ID 104
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     DI-RutaC.Ayudante-5 AT ROW 7.73 COL 81 COLON-ALIGNED WIDGET-ID 82
          LABEL "Ayudante 5" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     FILL-IN-Ayudante-5 AT ROW 7.73 COL 92 COLON-ALIGNED NO-LABEL WIDGET-ID 92
     DI-RutaC.TipAyudante-5 AT ROW 7.73 COL 127 COLON-ALIGNED NO-LABEL WIDGET-ID 106
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     DI-RutaC.Ayudante-6 AT ROW 8.54 COL 81 COLON-ALIGNED WIDGET-ID 84
          LABEL "Ayudante 6" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     FILL-IN-Ayudante-6 AT ROW 8.54 COL 92 COLON-ALIGNED NO-LABEL WIDGET-ID 94
     DI-RutaC.TipAyudante-6 AT ROW 8.54 COL 127 COLON-ALIGNED NO-LABEL WIDGET-ID 108
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     DI-RutaC.Ayudante-7 AT ROW 9.35 COL 81 COLON-ALIGNED WIDGET-ID 86
          LABEL "Ayudante 7" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     FILL-IN-Ayudante-7 AT ROW 9.35 COL 92 COLON-ALIGNED NO-LABEL WIDGET-ID 96
     DI-RutaC.TipAyudante-7 AT ROW 9.35 COL 127 COLON-ALIGNED NO-LABEL WIDGET-ID 110
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     txtCargaMaxima AT ROW 10.69 COL 16 COLON-ALIGNED WIDGET-ID 40
     txtPeso AT ROW 10.69 COL 30 COLON-ALIGNED WIDGET-ID 56
     txtNroClientes AT ROW 10.69 COL 54 COLON-ALIGNED WIDGET-ID 42
     txtClieSol AT ROW 10.69 COL 64 COLON-ALIGNED WIDGET-ID 48
     txtClieDol AT ROW 10.69 COL 79 COLON-ALIGNED WIDGET-ID 46
     txtVolumen AT ROW 11.5 COL 16 COLON-ALIGNED WIDGET-ID 54
     txtVol AT ROW 11.5 COL 30 COLON-ALIGNED WIDGET-ID 58
     txtPtosAlmacen AT ROW 11.5 COL 54 COLON-ALIGNED WIDGET-ID 44
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     txtTranSol AT ROW 11.5 COL 64 COLON-ALIGNED WIDGET-ID 52
     txtTranDol AT ROW 11.5 COL 79 COLON-ALIGNED WIDGET-ID 50
     "Estado:" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 2 COL 46
     "Detalle de la ruta:" VIEW-AS TEXT
          SIZE 12 BY .5 AT ROW 6.85 COL 6
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
      TABLE: T-RutaD T "?" NO-UNDO INTEGRAL DI-RutaD
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
/* SETTINGS FOR FILL-IN DI-RutaC.FchDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
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
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN DI-RutaC.Libre_c01 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN DI-RutaC.Libre_c03 IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN DI-RutaC.Libre_c05 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR COMBO-BOX DI-RutaC.Libre_d05 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN DI-RutaC.Libre_f05 IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX DI-RutaC.Libre_l01 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN DI-RutaC.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN DI-RutaC.responsable IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
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
/* SETTINGS FOR FILL-IN txtMinuto IN FRAME F-Main
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
ON LEAVE OF DI-RutaC.CodVeh IN FRAME F-Main /* Placa del vehiculo */
DO:

  DEFINE VAR lCount AS INT.

  ASSIGN
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE)
    FILL-IN-Marca:SCREEN-VALUE = ''
    DI-RutaC.TpoTra:SCREEN-VALUE = ''.
  ASSIGN  
      txtCargaMaxima:SCREEN-VALUE = '0'.

  FIND gn-vehic WHERE gn-vehic.codcia = s-codcia AND 
      gn-vehic.placa = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-vehic THEN RETURN.
  /* Dos Casos */
  ASSIGN
      FILL-IN-Marca:SCREEN-VALUE = gn-vehic.marca
      txtCargaMaxima:SCREEN-VALUE = STRING(gn-vehic.carga,">>,>>9.99")
      DI-RutaC.TpoTra:SCREEN-VALUE = gn-vehic.estado.
  FIND gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = gn-vehic.CodPro NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN DO:        
      ASSIGN 
          txtCodPro:SCREEN-VALUE = gn-prov.codpro
          txtDTrans:SCREEN-VALUE = gn-prov.nompro.
  END.
  CASE TRUE:
      WHEN s-HR-Manual = NO THEN DO:    /* CD's */
          /* Datos del Internamiento del vehiculo */
          FIND TraIngSal WHERE TraIngSal.CodCia = s-CodCia AND
              TraIngSal.CodDiv = s-CodDiv AND 
              TraIngSal.Placa = DI-RutaC.CodVeh:SCREEN-VALUE AND 
              TraIngSal.FlgEst = "I" AND
              TraIngSal.FlgSit = "P" NO-LOCK NO-ERROR.
          IF AVAILABLE TraIngSal THEN DO:
              DISPLAY 
                  MAXIMUM(TraIngSal.FechaSalida, TODAY) @ DI-RutaC.FchSal
                  SUBSTRING(TraIngSal.Guia,1,3) @ txtSerie 
                  SUBSTRING(TraIngSal.Guia,4) @ txtNro
                  TraIngSal.Brevete @ DI-RutaC.Libre_c01    /* Licencia */
                  TraIngSal.Ayudante-7 @ DI-RutaC.Ayudante-7 
                  TraIngSal.Ayudante-6 @ DI-RutaC.Ayudante-6  
                  TraIngSal.Ayudante-5 @ DI-RutaC.Ayudante-5 
                  TraIngSal.Ayudante-4 @ DI-RutaC.Ayudante-4 
                  TraIngSal.Ayudante-3 @ DI-RutaC.Ayudante-3 
                  TraIngSal.Ayudante-2 @ DI-RutaC.ayudante-2 
                  TraIngSal.Ayudante-1 @ DI-RutaC.ayudante-1 
                  TraIngSal.Responsable @ DI-RutaC.responsable
                  WITH FRAME {&FRAME-NAME}.
          END.
      END.
/*       OTHERWISE DO:     /* TIENDAs */                                                         */
/*           DI-RutaC.responsable:SENSITIVE = YES.                                               */
/*           DI-RutaC.ayudante-1:SENSITIVE = YES.                                                */
/*           DI-RutaC.ayudante-2:SENSITIVE = (IF gn-vehic.NroEstibadores >= 2 THEN YES ELSE NO). */
/*           DI-RutaC.ayudante-3:SENSITIVE = (IF gn-vehic.NroEstibadores >= 3 THEN YES ELSE NO). */
/*           DI-RutaC.ayudante-4:SENSITIVE = (IF gn-vehic.NroEstibadores >= 4 THEN YES ELSE NO). */
/*           DI-RutaC.ayudante-5:SENSITIVE = (IF gn-vehic.NroEstibadores >= 5 THEN YES ELSE NO). */
/*           DI-RutaC.ayudante-6:SENSITIVE = (IF gn-vehic.NroEstibadores >= 6 THEN YES ELSE NO). */
/*           DI-RutaC.ayudante-7:SENSITIVE = (IF gn-vehic.NroEstibadores >= 7 THEN YES ELSE NO). */
/*       END.                                                                                    */
  END CASE.
  IF SELF:SCREEN-VALUE > '' THEN DO:
      DI-RutaC.responsable:SENSITIVE = YES.
      DI-RutaC.ayudante-1:SENSITIVE = YES.
      DI-RutaC.ayudante-2:SENSITIVE = (IF gn-vehic.NroEstibadores >= 2 THEN YES ELSE NO).
      DI-RutaC.ayudante-3:SENSITIVE = (IF gn-vehic.NroEstibadores >= 3 THEN YES ELSE NO).
      DI-RutaC.ayudante-4:SENSITIVE = (IF gn-vehic.NroEstibadores >= 4 THEN YES ELSE NO).
      DI-RutaC.ayudante-5:SENSITIVE = (IF gn-vehic.NroEstibadores >= 5 THEN YES ELSE NO).
      DI-RutaC.ayudante-6:SENSITIVE = (IF gn-vehic.NroEstibadores >= 6 THEN YES ELSE NO).
      DI-RutaC.ayudante-7:SENSITIVE = (IF gn-vehic.NroEstibadores >= 7 THEN YES ELSE NO).
  END.

  APPLY 'LEAVE':U TO DI-RutaC.Libre_c01.
  APPLY 'LEAVE':U TO txtCodPro.
  APPLY 'LEAVE':U TO DI-RutaC.Responsable.
  APPLY 'LEAVE':U TO DI-RutaC.Ayudante-1.
  APPLY 'LEAVE':U TO DI-RutaC.Ayudante-2.
  APPLY 'LEAVE':U TO DI-RutaC.Ayudante-3.
  APPLY 'LEAVE':U TO DI-RutaC.Ayudante-4.
  APPLY 'LEAVE':U TO DI-RutaC.Ayudante-5.
  APPLY 'LEAVE':U TO DI-RutaC.Ayudante-6.
  APPLY 'LEAVE':U TO DI-RutaC.Ayudante-7.
  /* Bloqueamos modificación */
  SELF:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  DEFINE VAR x-DeliveryGroup AS CHAR.
  DEFINE VAR x-InvoiCustomerGroup AS CHAR.

  DEFINE VAR hProc AS HANDLE NO-UNDO.           /* Handle Libreria */

  RUN logis\logis-librerias.p PERSISTENT SET hProc.

  x-Bultos = 0.
  FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
      FIRST Ccbcdocu NO-LOCK WHERE CcbCDocu.CodCia = s-codcia
        AND CcbCDocu.CodDoc = DI-RutaD.CodRef 
        AND CcbCDocu.NroDoc = DI-RutaD.NroRef /*
      FIRST FACTURA NO-LOCK WHERE FACTURA.codcia = Ccbcdocu.codcia
        AND FACTURA.coddoc = Ccbcdocu.codref
        AND FACTURA.nrodoc = Ccbcdocu.nroref,
      FIRST gn-convt NO-LOCK WHERE gn-ConVt.Codig = FACTURA.fmapgo
      */
      BREAK BY Ccbcdocu.NomCli BY Ccbcdocu.nroPed BY Ccbcdocu.Libre_c02:

      /* Bultos */
      IF FIRST-OF(Ccbcdocu.NomCli) OR FIRST-OF(Ccbcdocu.NroPed) OR FIRST-OF(Ccbcdocu.Libre_c02) THEN DO:
          /*
          RUN logis/p-numero-de-bultos (INPUT s-CodDiv,
                                        INPUT Ccbcdocu.Libre_c01,
                                        INPUT Ccbcdocu.Libre_c02,
                                        OUTPUT f-Bultos).
          x-Bultos = x-Bultos + f-Bultos.
          */            
            /* Procedimientos */
            RUN Grupo-reparto IN hProc (INPUT CcbCDocu.libre_c01, INPUT CcbCDocu.libre_c02, /* O/D */
                                        OUTPUT x-DeliveryGroup, OUTPUT x-InvoiCustomerGroup).   

            IF x-DeliveryGroup = "" OR x-InvoiCustomerGroup = "" THEN DO:
                FIND FIRST FACTURA NO-LOCK WHERE FACTURA.codcia = Ccbcdocu.codcia
                  AND FACTURA.coddoc = Ccbcdocu.codref
                  AND FACTURA.nrodoc = Ccbcdocu.nroref NO-ERROR.

                IF NOT AVAILABLE FACTURA THEN DO:
                    NEXT.
                END.
                    
                FIND FIRST gn-convt NO-LOCK WHERE gn-ConVt.Codig = FACTURA.fmapgo NO-ERROR.
                IF NOT AVAILABLE gn-convt THEN DO:
                    NEXT.
                END.
            END.
            ELSE DO:
                /* Caso BCP - grupo de reparto */
                FIND FIRST gn-convt NO-LOCK WHERE gn-ConVt.Codig = ccbcdocu.fmapgo NO-ERROR.
                IF NOT AVAILABLE gn-convt THEN DO:
                    NEXT.
                END.
            END.
          
          /* Procedimientos */
          RUN GR_peso-volumen-bultos IN hProc (INPUT CcbCDocu.CodDiv,
                                      INPUT CcbCDocu.CodDoc,      /* G/R */
                                      INPUT CcbCDocu.nroDoc, 
                                      OUTPUT x-peso,
                                      OUTPUT x-volumen,
                                      OUTPUT f-bultos).           
            x-Bultos = x-Bultos + f-Bultos.
      END.
  END.
  DELETE PROCEDURE hProc.                       /* Release Libreria */

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

DEFINE VAR x-codfac AS CHAR.
  DEFINE VAR x-nrofac AS CHAR.
  DEFINE VAR x-DeliveryGroup AS CHAR.
  DEFINE VAR x-InvoiCustomerGroup AS CHAR.

  DEFINE VAR x-filer AS INT.

  DEFINE VAR hProc AS HANDLE NO-UNDO.           /* Handle Libreria */

  RUN logis\logis-librerias.p PERSISTENT SET hProc.

  s-Task-no = 0.
  FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
      FIRST Ccbcdocu NO-LOCK WHERE CcbCDocu.CodCia = s-codcia
        AND CcbCDocu.CodDoc = DI-RutaD.CodRef       /* G/R */
        AND CcbCDocu.NroDoc = DI-RutaD.NroRef
      /* Ic - 02Oct2020 : G/R x grupo de reparto caso BCP
      FIRST FACTURA NO-LOCK WHERE FACTURA.codcia = Ccbcdocu.codcia
        AND FACTURA.coddoc = Ccbcdocu.codref
        AND FACTURA.nrodoc = Ccbcdocu.nroref,
      FIRST gn-convt NO-LOCK WHERE gn-ConVt.Codig = FACTURA.fmapgo
      */
      BREAK BY Ccbcdocu.NomCli BY Ccbcdocu.nroPed BY Ccbcdocu.Libre_c02
      WITH FRAME {&FRAME-NAME}:

      x-codfac = "".
      x-nrofac = "".
    
    EMPTY TEMP-TABLE t-ccbcdocu.

    /* Procedimientos */
    RUN Grupo-reparto IN hProc (INPUT ccbcdocu.libre_c01, INPUT ccbcdocu.libre_c02,     /* O/D */
                                OUTPUT x-DeliveryGroup, OUTPUT x-InvoiCustomerGroup).             

    IF x-DeliveryGroup = "" OR x-InvoiCustomerGroup = "" THEN DO:        
        FIND FIRST FACTURA NO-LOCK WHERE FACTURA.codcia = Ccbcdocu.codcia
          AND FACTURA.coddoc = Ccbcdocu.codref
          AND FACTURA.nrodoc = Ccbcdocu.nroref NO-ERROR.
        
        IF NOT AVAILABLE FACTURA THEN NEXT.
        FIND FIRST gn-convt NO-LOCK WHERE gn-ConVt.Codig = FACTURA.fmapgo NO-ERROR.
        IF NOT AVAILABLE gn-convt THEN NEXT.

        x-codfac = FACTURA.coddoc.
        x-nrofac = FACTURA.nrodoc.
        
        CREATE t-ccbcdocu.
        BUFFER-COPY ccbcdocu TO t-ccbcdocu.

    END.
    ELSE DO:
        /* Ic - 02Oct2020 : G/R x grupo de reparto caso BCP */
        /* No esta facturado las G/R */
        /* Todas las FAIS del grupos de reparto */
        x-filer = 0.
        FOR EACH x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                                    x-ccbcdocu.codref = ccbcdocu.coddoc AND /* G/R */
                                    x-ccbcdocu.nroref = ccbcdocu.nrodoc AND
                                    x-ccbcdocu.coddoc = 'FAI' AND 
                                    x-ccbcdocu.flgest <> 'A' NO-LOCK:

            FIND FIRST gn-convt NO-LOCK WHERE gn-ConVt.Codig = x-ccbcdocu.fmapgo NO-ERROR.
            IF NOT AVAILABLE gn-convt THEN DO:
                NEXT.
            END.
            x-filer = x-filer + 1.
            CREATE t-ccbcdocu.
            BUFFER-COPY x-ccbcdocu TO t-ccbcdocu.
        END.
    END.
      
    FOR EACH t-ccbcdocu NO-LOCK BREAK BY t-Ccbcdocu.NomCli BY t-Ccbcdocu.nroPed BY t-Ccbcdocu.Libre_c02:
    
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
      FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
          AND gn-clie.codcli = t-ccbcdocu.codcli
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
          w-report.Campo-C[3] = t-Ccbcdocu.NomCli
          w-report.Campo-C[25]= t-Ccbcdocu.CodPed
          w-report.Campo-C[4] = t-Ccbcdocu.NroPed         /* PED */
          w-report.Campo-C[26]= t-Ccbcdocu.Libre_c01
          w-report.Campo-C[5] = t-Ccbcdocu.Libre_c02.     /* O/D */
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
      IF FIRST-OF(t-Ccbcdocu.NomCli) OR FIRST-OF(t-Ccbcdocu.NroPed) OR 
          FIRST-OF(t-Ccbcdocu.Libre_c02) THEN DO:

          RUN logis/p-numero-de-bultos (INPUT s-CodDiv,
                                        INPUT t-Ccbcdocu.Libre_c01,
                                        INPUT t-Ccbcdocu.Libre_c02,
                                        OUTPUT f-Bultos).
          w-report.Campo-I[3] = f-Bultos.
      END.
      /* ************************************************************************************** */
      /* DETALLE DI-RUTAD */
      /* ************************************************************************************** */
      IF t-Ccbcdocu.coddoc = 'G/R' THEN DO:
          ASSIGN
              w-report.Campo-C[20] = t-Ccbcdocu.coddoc
              w-report.Campo-C[21] = t-Ccbcdocu.nrodoc
              w-report.Campo-C[22] = x-codfac   /*FACTURA.coddoc*/
              w-report.Campo-C[23] = x-nrofac   /*FACTURA.nrodoc*/
              w-report.Campo-C[24] = gn-ConVt.Nombr.
      END.
      ELSE DO:
          ASSIGN
              w-report.Campo-C[20] = t-Ccbcdocu.coddoc      /* FAI */
              w-report.Campo-C[21] = t-Ccbcdocu.nrodoc
              w-report.Campo-C[22] = t-Ccbcdocu.codref   /*FACTURA.coddoc*/     /* G/R */
              w-report.Campo-C[23] = t-Ccbcdocu.nroref   /*FACTURA.nrodoc*/
              w-report.Campo-C[24] = gn-ConVt.Nombr.
      END.
      FOR EACH Ccbddocu OF t-Ccbcdocu NO-LOCK, FIRST Almmmatg OF Ccbddocu NO-LOCK:
          ASSIGN
              w-report.Campo-F[3] = w-report.Campo-F[3] + (Ccbddocu.candes * Ccbddocu.factor * Almmmatg.pesmat).
      END.
    END.
  END.

  DELETE PROCEDURE hProc.                       /* Release Libreria */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Reporte-Detalle-old V-table-Win 
PROCEDURE Carga-Reporte-Detalle-old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR x-codfac AS CHAR.
  DEFINE VAR x-nrofac AS CHAR.
  DEFINE VAR x-DeliveryGroup AS CHAR.
  DEFINE VAR x-InvoiCustomerGroup AS CHAR.

  DEFINE VAR hProc AS HANDLE NO-UNDO.           /* Handle Libreria */

  RUN logis\logis-librerias.p PERSISTENT SET hProc.

  s-Task-no = 0.
  FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
      FIRST Ccbcdocu NO-LOCK WHERE CcbCDocu.CodCia = s-codcia
        AND CcbCDocu.CodDoc = DI-RutaD.CodRef       /* G/R */
        AND CcbCDocu.NroDoc = DI-RutaD.NroRef
      /* Ic - 02Oct2020 : G/R x grupo de reparto caso BCP
      FIRST FACTURA NO-LOCK WHERE FACTURA.codcia = Ccbcdocu.codcia
        AND FACTURA.coddoc = Ccbcdocu.codref
        AND FACTURA.nrodoc = Ccbcdocu.nroref,
      FIRST gn-convt NO-LOCK WHERE gn-ConVt.Codig = FACTURA.fmapgo
      */
      BREAK BY Ccbcdocu.NomCli BY Ccbcdocu.nroPed BY Ccbcdocu.Libre_c02
      WITH FRAME {&FRAME-NAME}:

      x-codfac = "".
      x-nrofac = "".
    
    /* Procedimientos */
    RUN Grupo-reparto IN hProc (INPUT ccbcdocu.libre_c01, INPUT ccbcdocu.libre_c02,     /* O/D */
                                OUTPUT x-DeliveryGroup, OUTPUT x-InvoiCustomerGroup).             

    IF x-DeliveryGroup = "" OR x-InvoiCustomerGroup = "" THEN DO:        
        FIND FIRST FACTURA NO-LOCK WHERE FACTURA.codcia = Ccbcdocu.codcia
          AND FACTURA.coddoc = Ccbcdocu.codref
          AND FACTURA.nrodoc = Ccbcdocu.nroref NO-ERROR.
        
        IF NOT AVAILABLE FACTURA THEN NEXT.
        FIND FIRST gn-convt NO-LOCK WHERE gn-ConVt.Codig = FACTURA.fmapgo NO-ERROR.
        IF NOT AVAILABLE gn-convt THEN NEXT.

        x-codfac = FACTURA.coddoc.
        x-nrofac = FACTURA.nrodoc.
    END.
    ELSE DO:
        /* Ic - 02Oct2020 : G/R x grupo de reparto caso BCP */
        /* No esta facturado las G/R */
        FIND FIRST gn-convt NO-LOCK WHERE gn-ConVt.Codig = ccbcdocu.fmapgo NO-ERROR.
        IF NOT AVAILABLE gn-convt THEN DO:
            NEXT.
        END.
    END.
      

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
      FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
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

            /* Procedimientos */
          RUN GR_peso-volumen-bultos IN hProc (INPUT Ccbcdocu.coddiv,
                                                INPUT Ccbcdocu.coddoc,  /* G/R */ 
                                                INPUT Ccbcdocu.nrodoc,
                                                OUTPUT x-peso,
                                                OUTPUT x-volumen,
                                                OUTPUT f-bultos).


          /*
          RUN logis/p-numero-de-bultos (INPUT s-CodDiv,
                                        INPUT Ccbcdocu.Libre_c01,
                                        INPUT Ccbcdocu.Libre_c02,
                                        OUTPUT f-Bultos).
          */
          w-report.Campo-I[3] = f-Bultos.
      END.
      /* ************************************************************************************** */
      /* DETALLE DI-RUTAD */
      /* ************************************************************************************** */
      ASSIGN
          w-report.Campo-C[20] = Ccbcdocu.coddoc
          w-report.Campo-C[21] = Ccbcdocu.nrodoc
          w-report.Campo-C[22] = x-codfac   /*FACTURA.coddoc*/
          w-report.Campo-C[23] = x-nrofac   /*FACTURA.nrodoc*/
          w-report.Campo-C[24] = gn-ConVt.Nombr.
      FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK, FIRST Almmmatg OF Ccbddocu NO-LOCK:
          ASSIGN
              w-report.Campo-F[3] = w-report.Campo-F[3] + (Ccbddocu.candes * Ccbddocu.factor * Almmmatg.pesmat).
      END.
  END.

  DELETE PROCEDURE hProc.                       /* Release Libreria */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF s-HR-Manual = NO THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  
  ASSIGN
      x-GlosaAprobacion = ''
      x-UsrAprobacion = ''
      x-FchAprobacion = ?.
  
  /* Ic - 04Oct2017, H/R pendientes NO ADICIONAR, Fernan Oblitas/Harold Segura */
  /* Levantamos la libreria a memoria */
  DEFINE VAR hProc AS HANDLE NO-UNDO.
  RUN dist/dist-librerias PERSISTENT SET hProc.
  RUN HR-Pendiente IN hProc (INPUT s-CodDiv,
                             INPUT s-Dias-Limite,
                             INPUT YES).
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN 'ADM-ERROR'.
  DELETE PROCEDURE hProc.
  /* Control de Correlativos */
  FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDiv = S-CODDIV 
      AND FacCorre.CodDoc = S-CODDOC 
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCorre THEN DO:
      MESSAGE 'No hay un correlativo para la division' s-coddiv
          VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  x-NroDoc = STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('pagina0').
  RUN Procesa-Handle IN lh_handle ('disable-detail').
  DISPLAY 
      TODAY @ DI-RutaC.FchDoc
      x-NroDoc @ DI-RutaC.NroDoc 
      s-user-id @ DI-RutaC.usuario 
      WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       di-rutac.flgest = "P" por defecto en el dicccionario de datos
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      {lib/lock-genericov3.i ~
          &Tabla="FacCorre" ~
          &Condicion="FacCorre.CodCia = S-CODCIA AND ~
          FacCorre.CodDiv = S-CODDIV AND ~
          FacCorre.CodDoc = S-CODDOC" ~
          &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
          &Accion="RETRY" ~
          &Mensaje="YES" ~
          &TipoError="UNDO, RETURN 'ADM-ERROR'" }
      ASSIGN
        DI-RutaC.CodCia = s-codcia
        DI-RutaC.CodDiv = s-coddiv
        DI-RutaC.CodDoc = s-coddoc
        DI-RutaC.FchDoc = TODAY
        DI-RutaC.NroDoc = STRING(FacCorre.nroser, '999') + STRING(FacCorre.correlativo, '999999')
        DI-RutaC.usuario = s-user-id
        DI-RutaC.flgest  = "P".     /* Pendiente */
      ASSIGN
          DI-RutaC.Libre_l02 = s-HR-Manual.     /* Origen de la H/R */
      ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
      RELEASE FacCorre.
  END.
  ELSE ASSIGN
            DI-RutaC.Libre_c05 = s-user-id
            DI-RutaC.Libre_f05 = TODAY.
  ASSIGN
    DI-RutaC.Nomtra = txtDtrans:SCREEN-VALUE IN FRAME {&FRAME-NAME}
    DI-RutaC.CodPro = txtCodPro:SCREEN-VALUE IN FRAME {&FRAME-NAME}
    DI-RutaC.Tpotra  = DI-RutaC.Tpotra:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

  /* Control de Aprobación de HR */
  ASSIGN
      DI-RutaC.GlosaAprobacion = x-GlosaAprobacion
      DI-RutaC.UsrAprobacion = x-UsrAprobacion 
      DI-RutaC.FchAprobacion = x-FchAprobacion.

  IF s-HR-Manual = NO THEN DO:
      /* Actualiza Control de Ingresos de Transportitas */
      /* Levantamos la libreria a memoria */
      DEFINE VAR hProc AS HANDLE NO-UNDO.
      RUN tra/tra-librerias PERSISTENT SET hProc.
      RUN Actualiza-Ingreso IN hProc (DI-RutaC.CodDiv,DI-RutaC.CodVeh,DI-RutaC.NroDoc,DI-RutaC.Libre_l01).
      DELETE PROCEDURE hProc.
      IF RETURN-VALUE = "ADM-ERROR" THEN DO:
          MESSAGE 'NO se pudo actualizar al control de Transportes' VIEW-AS ALERT-BOX ERROR.
          UNDO, RETURN 'ADM-ERROR'.
      END.
  END.

  /* 08 Julio 2013 - Ic*/
  ASSIGN txtHora txtMinuto.
  ASSIGN 
      DI-RutaC.HorSal = STRING(txtHora,"99") + STRING(txtMinuto,"99")
      DI-RutaC.GuiaTransportista = STRING(txtSerie,"999") + "-" + STRING(txtNro,"99999999").

  /* RHC 17.09.11 Control de G/R por pedidos */
  /*
  RUN dist/p-rut001 ( ROWID(Di-RutaC), YES ).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  */
  DEFINE VAR x-msg AS CHAR.

  RUN dist/p-rut001-v2.r ( ROWID(Di-RutaC), NO, OUTPUT x-msg ).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE "IMPOSIBLE GRABAR " SKIP
          x-msg.
      UNDO, RETURN 'ADM-ERROR'.
  END.
      
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

  /* RHC 14/11/2019 Escala y Destino Final */
  RUN logis/p-escala-destino-final ( ROWID(Di-RutaC)).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF NOT (DI-RutaC.FlgEst = "P" AND DI-RutaC.Libre_l01 = NO) THEN DO:
      IF s-acceso-total = NO THEN DO:
          MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
  END.
  DEF VAR pTitulo AS CHAR NO-UNDO.
  DEF VAR pGlosa  AS CHAR NO-UNDO.
  DEF VAR pError  AS LOG  NO-UNDO.
  DEFINE VAR hProc AS HANDLE NO-UNDO.
  DEF VAR pMensaje AS CHAR NO-UNDO.

  RUN dist/d-mot-anu-hr ('MOTIVO DE ANULACION DE LA HOJA DE RUTA',
                         OUTPUT pGlosa,
                         OUTPUT pError).
  IF pError = YES THEN RETURN 'ADM-ERROR'.
  
  /* Dispatch standard ADM method.                             */
  
  /* SOLO LO MARCAMOS COMO ANULADO 
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
  */

  /* Code placed here will execute AFTER standard behavior.    */
  DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
      FIND CURRENT DI-RUTAC EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
      IF ERROR-STATUS:ERROR = YES THEN DO:
          {lib/mensaje-de-error.i &MensajeError="pMensaje"}
          UNDO, LEAVE.
      END.
      ASSIGN
          DI-RutaC.flgest = 'A'
          DI-RutaC.Libre_f05 = TODAY
          DI-RutaC.Libre_c05 = s-user-id
          DI-RutaC.Libre_c04 = pGlosa.
      /* ********************************************************************************** */
      /* RHC 21.05.2011 revisar los triggers de borrado */
      /* ********************************************************************************** */
      FOR EACH di-rutad OF di-rutac ON ERROR UNDO, RETURN 'ADM-ERROR':
          DELETE di-rutad.
      END.
      FOR EACH di-rutag OF di-rutac ON ERROR UNDO, RETURN 'ADM-ERROR':
          DELETE di-rutag.
      END.
      FOR EACH di-rutadg OF di-rutac ON ERROR UNDO, RETURN 'ADM-ERROR':
          DELETE di-rutadg.
      END.
      /* ********************************************************************************** */
      /* RHC Extorna Control de Transportes */
      /* Levantamos la libreria a memoria */
      /* ********************************************************************************** */
      RUN tra/tra-librerias PERSISTENT SET hProc.
      RUN Extorna-Ingreso IN hProc (DI-RutaC.CodDiv,DI-RutaC.CodVeh,DI-RutaC.NroDoc).
      DELETE PROCEDURE hProc.
      IF RETURN-VALUE = "ADM-ERROR" THEN DO:
          pMensaje = 'NO se pudo actualizar el control de Transportes'.
          UNDO, LEAVE.
      END.
      /* ********************************************************************************** */
      /* Levantamos la libreria a memoria */
      /* ********************************************************************************** */
      RUN dist/dist-librerias PERSISTENT SET hProc.
      RUN Extorna-PHR-Multiple IN hProc (INPUT ROWID(Di-RutaC), INPUT pGlosa, OUTPUT pMensaje).
      DELETE PROCEDURE hProc.
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          pMensaje = 'NO se pudo extornar las PHR relacionadas'.
          UNDO, LEAVE.
      END.
  END.
  /* ********************************************************************************** */
  FIND CURRENT DI-RUTAC NO-LOCK NO-ERROR.
  IF pMensaje > '' THEN DO:
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
  END.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
  DO WITH FRAME {&FRAME-NAME}:
      txtHora:SENSITIVE = NO.
      txtMinuto:SENSITIVE = NO.
      txtCodPro:SENSITIVE = NO.
      txtSerie:SENSITIVE = NO.
      txtNro:SENSITIVE = NO.
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
    FIND FIRST gn-vehic WHERE gn-vehic.codcia = s-codcia
        AND gn-vehic.placa = DI-RutaC.CodVeh NO-LOCK NO-ERROR.
    IF AVAILABLE gn-vehic THEN DO:    
        FILL-IN-Marca:SCREEN-VALUE = gn-vehic.marca.
        txtCargaMaxima:SCREEN-VALUE = STRING(gn-vehic.carga,">>,>>9.99").
        txtVolumen:SCREEN-VALUE = STRING(gn-vehic.Volumen,">>,>>9.99").
    END.
    txtCodPro:SCREEN-VALUE = DI-RutaC.codPro.

    FIND FIRST gn-prov WHERE gn-prov.codcia = pv-codcia
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
        /*lImpTranSol = lImpTranSol + di-rutaG.libre_d02.*/
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
                ASSIGN 
                    lImpTranSol = lImpTranSol + 
                                        (Almdmov.candes * Almdmov.Factor * Almmmatg.CtoTot) * 
                                        (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1).
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
        txtTranSol txtPeso txtVol txtVolumen WITH FRAME {&FRAME-NAME}.
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
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          DI-RutaC.Libre_l01:SENSITIVE = NO     /* Confirmado */
          DI-RutaC.TpoTra:SENSITIVE = NO.       /* Propio o Externo */
      ENABLE txtHora txtMinuto txtSerie txtNro.
      /* Estibadores adicionales */
      IF s-acceso-total = YES THEN ENABLE DI-RutaC.Libre_d05.
      ELSE DISABLE DI-RutaC.Libre_d05.
      CASE s-HR-Manual:
          WHEN NO THEN DO:     /* CD, viene de un Internamiento de Vehículo */
              /* RHC 04/09/19 Solo debe permitir ingresar PERSONAL PROPIO */
              DISABLE 
                  DI-RutaC.FchSal
                  DI-RutaC.Libre_c01    /* Licencia */
                  txtCodPro
                  txtHora 
                  txtMinuto 
                  txtSerie 
                  txtNro.
                  .
          END.
          WHEN YES THEN DO:
          END.
      END CASE.
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      CASE RETURN-VALUE:
          WHEN 'YES' THEN DO:   /* CREATE */
              DISABLE DI-RutaC.ayudante-1 DI-RutaC.ayudante-2 DI-RutaC.Ayudante-3 
                  DI-RutaC.Ayudante-4 DI-RutaC.Ayudante-5 DI-RutaC.Ayudante-6 
                  DI-RutaC.Ayudante-7 DI-RutaC.responsable.
          END.
          WHEN 'NO' THEN DO:    /* UPDATE */
              DI-RutaC.CodVeh:SENSITIVE = NO.
              IF s-HR-Manual = YES THEN DI-RutaC.CodVeh:SENSITIVE = YES.
              IF TRUE <> (DI-RutaC.CodVeh > '') THEN DO:
                  DI-RutaC.CodVeh:SENSITIVE = YES.
                  DISABLE DI-RutaC.ayudante-1 DI-RutaC.ayudante-2 DI-RutaC.Ayudante-3 
                      DI-RutaC.Ayudante-4 DI-RutaC.Ayudante-5 DI-RutaC.Ayudante-6 
                      DI-RutaC.Ayudante-7 DI-RutaC.responsable.
              END.
              IF DI-RutaC.FlgEst = 'P' THEN DI-RutaC.Libre_l01:SENSITIVE = YES.
              IF DI-RutaC.Libre_l01 = YES THEN DO:
                  DISABLE ALL EXCEPT txtHora txtMinuto DI-RutaC.Kmtini.
              END.
          END.
      END CASE.
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
       IF USERID("DICTDB") = "MASTER" THEN DO:
           /* Solo prueba */
       END.
       ELSE DO:
           RETURN.
       END.
       
   END.

   /* Prefijo para el codigo de Barras  */
   RUN gn/prefijo-codigo-barras-doc(INPUT di-rutaC.coddoc, OUTPUT x-prefijo-docto).
   IF x-prefijo-docto = 'ERROR' THEN DO:
       MESSAGE "ERROR al ubicar el prefijo del codigo de barra para (" di-rutaC.coddoc + ")".
       RETURN.
   END.

   RUN logis/p-imprime-hr (ROWID(Di-RutaC)).

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
  RUN Valida-Estibadores.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

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

  /* VALIDACIONES COMUNES */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN 
          txtHora txtMinuto txtCodPro txtDTrans txtSerie txtNro.
      /* PLACA */
      FIND FIRST gn-vehic WHERE gn-vehic.codcia = s-codcia AND 
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
      IF INPUT DI-RutaC.FchSal < lFechaIng /*TODAY*/ THEN DO:
          MESSAGE 'Fecha de salida errada' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO di-rutac.FchSal.
          RETURN 'ADM-ERROR'.
      END.
      /* 
      10Jul2017, correo de Carlos Lalangui/Felix Perez
      restricción solicitada es por 48 horas útiles, 
      considerando el día sábado como útil.
      03Oct2017, Fernan Oblitas/Harold Segura 3 dias
      */
      IF lFechaSal > (lFechaIng + 3) THEN DO:
          MESSAGE 'Fecha de salida no debe sobre pasar las 48 Horas' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO di-rutac.FchSal.
          RETURN 'ADM-ERROR'.
      END.
      /* LICENCIA */
      IF TRUE <> (DI-RutaC.libre_c01:SCREEN-VALUE > '') THEN DO:
          MESSAGE 'Debe ingresar la LICENCIA de conducir' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO di-rutac.libre_c01.
          RETURN 'ADM-ERROR'.
      END.
      FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = 'BREVETE' AND
          vtatabla.llave_c1 = DI-RutaC.libre_c01:SCREEN-VALUE AND
          vtatabla.llave_c8 = "SI" NO-LOCK NO-ERROR.
      IF NOT AVAILABLE vtatabla THEN DO:
          MESSAGE 'Nro de Licencia NO existe o no está activa' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO di-rutac.libre_c01.
          RETURN 'ADM-ERROR'.
      END.
      /* CONTROL DE RESPONSABLE Y AYUDANTES */
      IF TRUE <> (DI-RutaC.responsable:SCREEN-VALUE > '') THEN DO:
          MESSAGE 'Debe ingresar el responsable' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO di-rutac.responsable.
          RETURN 'ADM-ERROR'.
      END.
      /* GUIA  DEL TRANSPORTISTA */
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
      /* VALIDACION DEL PESO MINIMO AL CERRAR LA HR */
      IF LOGICAL(DI-RutaC.Libre_l01:SCREEN-VALUE) = YES THEN DO:
          IF DECIMAL(DI-RutaC.KmtIni:SCREEN-VALUE) <= 0 THEN DO:
              MESSAGE 'Debe ingresar el kilometraje de salida' VIEW-AS ALERT-BOX ERROR.
              APPLY 'ENTRY' TO di-rutac.kmtini.
              RETURN 'ADM-ERROR'.
          END.
          IF s-acceso-total = NO THEN DO:
              RUN valida-no-autorizados.
              IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
          END.
          ELSE DO:
              RUN Valida-Autorizados.
              IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
              /* Solicita Glosa de CONFIRMADO */
/*               DEF VAR pError AS LOG NO-UNDO.                       */
/*               x-GlosaAprobacion = ''.                              */
/*               x-UsrAprobacion = ''.                                */
/*               x-FchAprobacion = ?.                                 */
/*               RUN dist/d-mot-anu-hr ("OBSERVACION DE AUTORIZACON", */
/*                                      OUTPUT x-GlosaAprobacion,     */
/*                                      OUTPUT pError).               */
/*               IF pError = YES THEN RETURN 'ADM-ERROR'.             */
          END.
          ASSIGN
              x-UsrAprobacion = s-User-Id
              x-FchAprobacion = TODAY.
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
      DEF VAR pNombre AS CHAR NO-UNDO.
      DEF VAR pOrigen AS CHAR NO-UNDO.
      CASE s-HR-Manual:
          WHEN NO THEN DO:  /* CD's */
              RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
              IF RETURN-VALUE = "YES" THEN DO:
                  FIND TraIngSal WHERE TraIngSal.CodCia = s-CodCia AND
                      TraIngSal.CodDiv = s-CodDiv AND 
                      TraIngSal.Placa = DI-RutaC.CodVeh:SCREEN-VALUE AND 
                      TraIngSal.FlgEst = "I" AND
                      TraIngSal.FlgSit = "P"
                      NO-LOCK NO-ERROR.
                  IF NOT AVAILABLE TraIngSal THEN DO:
                      MESSAGE 'Error en la placa del vehículo' VIEW-AS ALERT-BOX ERROR.
                      APPLY 'ENTRY':U TO DI-RutaC.CodVeh.
                      RETURN 'ADM-ERROR'.
                  END.
              END.
              /* RHC 07/09/2019 SOlo aceptar personal propio */
              IF DI-RutaC.Responsable:SCREEN-VALUE > '' THEN DO:
                  RUN Valida-Personal (INPUT DI-RutaC.Responsable:SCREEN-VALUE,
                                       OUTPUT pNombre,
                                       OUTPUT pOrigen).
                  IF pOrigen BEGINS 'TERCERO' THEN DO:
                      MESSAGE 'Solo se acepta personal propio' VIEW-AS ALERT-BOX ERROR.
                      APPLY 'ENTRY':U TO DI-RutaC.Responsable.
                      RETURN 'ADM-ERROR'.
                  END.
              END.
              DO iIndice = 1 TO gn-vehic.NroEstibadores:
                  CASE iIndice:
                      WHEN 1 THEN DO:
                          IF DI-RutaC.ayudante-1:SCREEN-VALUE > '' THEN DO:
                              RUN Valida-Personal (INPUT DI-RutaC.ayudante-1:SCREEN-VALUE,
                                                   OUTPUT pNombre,
                                                   OUTPUT pOrigen).
                              IF pOrigen BEGINS 'TERCERO' THEN DO:
                                  MESSAGE 'Solo se acepta personal propio' VIEW-AS ALERT-BOX ERROR.
                                  APPLY 'ENTRY':U TO DI-RutaC.ayudante-1.
                                  RETURN 'ADM-ERROR'.
                              END.
                          END.
                      END.
                      WHEN 2 THEN DO:
                          IF DI-RutaC.ayudante-2:SCREEN-VALUE > '' THEN DO:
                              RUN Valida-Personal (INPUT DI-RutaC.ayudante-2:SCREEN-VALUE,
                                                   OUTPUT pNombre,
                                                   OUTPUT pOrigen).
                              IF pOrigen BEGINS 'TERCERO' THEN DO:
                                  MESSAGE 'Solo se acepta personal propio' VIEW-AS ALERT-BOX ERROR.
                                  APPLY 'ENTRY':U TO DI-RutaC.ayudante-2.
                                  RETURN 'ADM-ERROR'.
                              END.
                          END.
                      END.
                      WHEN 3 THEN DO:
                          IF DI-RutaC.ayudante-3:SCREEN-VALUE > '' THEN DO:
                              RUN Valida-Personal (INPUT DI-RutaC.ayudante-3:SCREEN-VALUE,
                                                   OUTPUT pNombre,
                                                   OUTPUT pOrigen).
                              IF pOrigen BEGINS 'TERCERO' THEN DO:
                                  MESSAGE 'Solo se acepta personal propio' VIEW-AS ALERT-BOX ERROR.
                                  APPLY 'ENTRY':U TO DI-RutaC.ayudante-3.
                                  RETURN 'ADM-ERROR'.
                              END.
                          END.
                      END.
                      WHEN 4 THEN DO:
                          IF DI-RutaC.ayudante-4:SCREEN-VALUE > '' THEN DO:
                              RUN Valida-Personal (INPUT DI-RutaC.ayudante-4:SCREEN-VALUE,
                                                   OUTPUT pNombre,
                                                   OUTPUT pOrigen).
                              IF pOrigen BEGINS 'TERCERO' THEN DO:
                                  MESSAGE 'Solo se acepta personal propio' VIEW-AS ALERT-BOX ERROR.
                                  APPLY 'ENTRY':U TO DI-RutaC.ayudante-4.
                                  RETURN 'ADM-ERROR'.
                              END.
                          END.
                      END.
                      WHEN 5 THEN DO:
                          IF DI-RutaC.ayudante-5:SCREEN-VALUE > '' THEN DO:
                              RUN Valida-Personal (INPUT DI-RutaC.ayudante-5:SCREEN-VALUE,
                                                   OUTPUT pNombre,
                                                   OUTPUT pOrigen).
                              IF pOrigen BEGINS 'TERCERO' THEN DO:
                                  MESSAGE 'Solo se acepta personal propio' VIEW-AS ALERT-BOX ERROR.
                                  APPLY 'ENTRY':U TO DI-RutaC.ayudante-5.
                                  RETURN 'ADM-ERROR'.
                              END.
                          END.
                      END.
                      WHEN 6 THEN DO:
                          IF DI-RutaC.ayudante-6:SCREEN-VALUE > '' THEN DO:
                              RUN Valida-Personal (INPUT DI-RutaC.ayudante-6:SCREEN-VALUE,
                                                   OUTPUT pNombre,
                                                   OUTPUT pOrigen).
                              IF pOrigen BEGINS 'TERCERO' THEN DO:
                                  MESSAGE 'Solo se acepta personal propio' VIEW-AS ALERT-BOX ERROR.
                                  APPLY 'ENTRY':U TO DI-RutaC.ayudante-6.
                                  RETURN 'ADM-ERROR'.
                              END.
                          END.
                      END.
                      WHEN 7 THEN DO:
                          IF DI-RutaC.ayudante-7:SCREEN-VALUE > '' THEN DO:
                              RUN Valida-Personal (INPUT DI-RutaC.ayudante-7:SCREEN-VALUE,
                                                   OUTPUT pNombre,
                                                   OUTPUT pOrigen).
                              IF pOrigen BEGINS 'TERCERO' THEN DO:
                                  MESSAGE 'Solo se acepta personal propio' VIEW-AS ALERT-BOX ERROR.
                                  APPLY 'ENTRY':U TO DI-RutaC.ayudante-7.
                                  RETURN 'ADM-ERROR'.
                              END.
                          END.
                      END.
                  END CASE.
              END.
          END.
          OTHERWISE DO:     /* TIENDAS */
              /* GUIA DEL TRANSPORTISTA */
              DEF BUFFER B-RutaC FOR DI-RutaC.
              RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
              IF RETURN-VALUE = 'NO' THEN DO:
                  FIND FIRST B-RutaC WHERE B-RutaC.codcia = s-codcia 
                      AND B-RutaC.codpro = txtCodPro
                      AND B-RutaC.GuiaTransportista = STRING(txtSerie, '999') + "-" + STRING(txtNro , '99999999')
                      AND B-RutaC.CodDoc = "H/R"
                      AND B-RutaC.NroDoc <> Di-RutaC.NroDoc
                      AND B-RutaC.FlgEst <> 'A'
                      NO-LOCK NO-ERROR.
              END.
              ELSE DO:
                  FIND FIRST B-RutaC WHERE B-RutaC.codcia = s-codcia 
                      AND B-RutaC.codpro = txtCodPro
                      AND B-RutaC.GuiaTransportista = STRING(txtSerie, '999') + "-" + STRING(txtNro , '99999999')
                      AND B-RutaC.CodDoc = "H/R"
                      AND B-RutaC.FlgEst <> 'A'
                      NO-LOCK NO-ERROR.
              END.
              IF AVAILABLE B-RutaC THEN DO:
                  MESSAGE 'Guia del Transportista YA fue registrada en la H/R Nro.' B-RutaC.NroDoc
                      VIEW-AS ALERT-BOX ERROR.
                  APPLY 'ENTRY':U TO txtSerie.
                  RETURN 'ADM-ERROR'.
              END.
              /* CONTROL DE CIERRE */
              IF INPUT di-rutaC.libre_l01 = YES THEN DO:
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
              END.
          END.
      END CASE.
      /* ************************************************ */
      /* RHC Cambiamos el orden de la glosa de aprobación */
      /* ************************************************ */
      IF LOGICAL(DI-RutaC.Libre_l01:SCREEN-VALUE) = YES THEN DO:
          IF s-acceso-total = YES THEN DO:
              /* Solicita Glosa de CONFIRMADO */
              DEF VAR pError AS LOG NO-UNDO.
              x-GlosaAprobacion = ''.
              RUN dist/d-mot-anu-hr ("OBSERVACION DE AUTORIZACION", 
                                     OUTPUT x-GlosaAprobacion, 
                                     OUTPUT pError).
              IF pError = YES THEN RETURN 'ADM-ERROR'.
          END.
      END.
      /* ************************************************ */
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida-Autorizados V-table-Win 
PROCEDURE Valida-Autorizados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ******************************************** */
/* RHC 19/10/2020 F.O. Control Fecha de Entrega */
/* ******************************************** */
DEF VAR x-FchCierre AS DATE NO-UNDO.

RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF RETURN-VALUE = 'YES' THEN x-FchCierre = TODAY.
ELSE x-FchCierre = Di-RutaC.FchDoc.

FIND TabGener WHERE TabGener.CodCia = s-CodCia
    AND TabGener.Clave = 'CFGINC'
    AND TabGener.Codigo = s-CodDiv
    NO-LOCK NO-ERROR.
IF AVAILABLE TabGener AND TabGener.Libre_l04 = YES THEN DO:
    /* RHC Cargamos en un temporal y preguntamos */
    EMPTY TEMP-TABLE T-RUTAD.
    /* Buscamos si una O/D u OTR tiene fecha de entrega menor a la de la H/R */
    FOR EACH di-rutaD WHERE di-rutad.codcia = di-rutac.codcia AND
        di-rutad.coddiv = di-rutac.coddiv AND 
        di-rutad.coddoc = di-rutac.coddoc AND
        di-rutad.nrodoc = di-rutac.nrodoc NO-LOCK,
        FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-CodCia
        AND Ccbcdocu.coddoc = Di-RutaD.CodRef
        AND Ccbcdocu.nrodoc = Di-RutaD.NroRef:
        FIND Faccpedi WHERE Faccpedi.codcia = s-CodCia
            AND Faccpedi.coddoc = Ccbcdocu.Libre_c01    /* O/D */
            AND Faccpedi.nroped = Ccbcdocu.Libre_c02
            NO-LOCK NO-ERROR.
        IF AVAILABLE Faccpedi AND Faccpedi.FchEnt < x-FchCierre THEN DO:
            CREATE T-RUTAD.
            ASSIGN
                T-RutaD.CodCia = s-codcia
                T-RutaD.CodDoc = Faccpedi.coddoc
                T-RutaD.NroDoc = Faccpedi.nroped
                T-RutaD.CodRef = di-rutad.codref
                T-RutaD.NroRef = di-rutad.nroref
                T-RutaD.Libre_c01 = STRING(Faccpedi.fchent).
        END.
    END.
    FOR EACH di-rutaG WHERE di-rutag.codcia = di-rutac.codcia AND
        di-rutag.coddiv = di-rutac.coddiv AND 
        di-rutag.coddoc = di-rutac.coddoc AND
        di-rutag.nrodoc = di-rutac.nrodoc NO-LOCK,
        FIRST almcmov NO-LOCK WHERE almcmov.codcia = s-CodCia
        AND almcmov.codalm = di-rutag.CodAlm
        AND almcmov.tipmov = di-rutag.TipMov
        AND almcmov.codmov = di-rutag.CodMov
        AND almcmov.nroser = di-rutag.SerRef
        AND almcmov.nrodoc = di-rutag.NroRef:
        FIND Faccpedi WHERE Faccpedi.codcia = s-CodCia
            AND Faccpedi.coddoc = almcmov.codref        /* OTR */
            AND Faccpedi.nroped = almcmov.nroref
            NO-LOCK NO-ERROR.
        IF AVAILABLE Faccpedi AND Faccpedi.FchEnt < x-FchCierre THEN DO:
            CREATE T-RUTAD.
            ASSIGN
                T-RutaD.CodCia = s-codcia
                T-RutaD.CodDoc = Faccpedi.coddoc
                T-RutaD.NroDoc = Faccpedi.nroped
                T-RutaD.CodRef = "G/R"
                T-RutaD.NroRef = STRING(di-rutag.serref,'999') + STRING(di-rutag.nroref,'99999999')
                T-RutaD.Libre_c01 = STRING(Faccpedi.fchent).
        END.
    END.
    /* Buscamos si una O/D u OTR tiene fecha de entrega menor a la de la H/R */
/*     FOR EACH di-rutaD WHERE di-rutad.codcia = di-rutac.codcia AND        */
/*         di-rutad.coddiv = di-rutac.coddiv AND                            */
/*         di-rutad.coddoc = di-rutac.coddoc AND                            */
/*         di-rutad.nrodoc = di-rutac.nrodoc NO-LOCK,                       */
/*         FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-CodCia          */
/*         AND Ccbcdocu.coddoc = Di-RutaD.CodRef                            */
/*         AND Ccbcdocu.nrodoc = Di-RutaD.NroRef:                           */
/*         FIND Faccpedi WHERE Faccpedi.codcia = s-CodCia                   */
/*             AND Faccpedi.coddoc = Ccbcdocu.Libre_c01    /* O/D */        */
/*             AND Faccpedi.nroped = Ccbcdocu.Libre_c02                     */
/*             NO-LOCK NO-ERROR.                                            */
/*         IF AVAILABLE Faccpedi AND Faccpedi.FchEnt < x-FchCierre THEN DO: */
/*             MESSAGE ' El documento' Faccpedi.coddoc Faccpedi.nroped SKIP */
/*                 'tiene una fecha de entrega antigua:' Faccpedi.FchEnt    */
/*                 'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION */
/*                 BUTTONS YES-NO UPDATE rpta1 AS LOG.                      */
/*             IF rpta1 = NO THEN RETURN 'ADM-ERROR'.                       */
/*         END.                                                             */
/*     END.                                                                 */
/*     FOR EACH di-rutaG WHERE di-rutag.codcia = di-rutac.codcia AND        */
/*         di-rutag.coddiv = di-rutac.coddiv AND                            */
/*         di-rutag.coddoc = di-rutac.coddoc AND                            */
/*         di-rutag.nrodoc = di-rutac.nrodoc NO-LOCK,                       */
/*         FIRST almcmov NO-LOCK WHERE almcmov.codcia = s-CodCia            */
/*         AND almcmov.codalm = di-rutag.CodAlm                             */
/*         AND almcmov.tipmov = di-rutag.TipMov                             */
/*         AND almcmov.codmov = di-rutag.CodMov                             */
/*         AND almcmov.nroser = di-rutag.SerRef                             */
/*         AND almcmov.nrodoc = di-rutag.NroRef:                            */
/*         FIND Faccpedi WHERE Faccpedi.codcia = s-CodCia                   */
/*             AND Faccpedi.coddoc = almcmov.codref        /* OTR */        */
/*             AND Faccpedi.nroped = almcmov.nroref                         */
/*             NO-LOCK NO-ERROR.                                            */
/*         IF AVAILABLE Faccpedi AND Faccpedi.FchEnt < x-FchCierre THEN DO: */
/*             MESSAGE ' El documento' Faccpedi.coddoc Faccpedi.nroped SKIP */
/*                 'tiene una fecha de entrega antigua:' Faccpedi.FchEnt    */
/*                 'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION */
/*                 BUTTONS YES-NO UPDATE rpta2 AS LOG.                      */
/*             IF rpta2 = NO THEN RETURN 'ADM-ERROR'.                       */
/*         END.                                                             */
/*     END.                                                                 */
END.
DEF VAR pOk AS LOG NO-UNDO.
FIND FIRST T-RUTAD NO-LOCK NO-ERROR.
IF AVAILABLE T-RUTAD THEN DO:
    RUN logis/d-hr-fch-entrega (INPUT TABLE T-RUTAD, OUTPUT pOk).
    IF pOk = NO THEN RETURN 'ADM-ERROR'.
END.

RETURN 'OK'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-no-autorizados V-table-Win 
PROCEDURE valida-no-autorizados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ******************************************** */
/* Usuarios NO autorizados para aprobar HR debajo del peso mínimo */
/* ******************************************** */
DEF VAR lPeso AS DEC NO-UNDO.
IF gn-vehic.Libre_d01 > 0 AND s-HR-Manual = NO    /* Solo CD */
    THEN DO:
    /* Qttys Clientes */
    FOR EACH di-rutaD WHERE di-rutad.codcia = di-rutac.codcia AND
        di-rutad.coddiv = di-rutac.coddiv AND 
        di-rutad.coddoc = di-rutac.coddoc AND
        di-rutad.nrodoc = di-rutac.nrodoc NO-LOCK:
        ASSIGN
            lPeso = lPeso + DECIMAL(ENTRY(4,di-rutaD.libre_c01,","))
            NO-ERROR.
    END.
    /* Qttys Almacenes - Transferencias */
    FOR EACH di-rutaG WHERE di-rutag.codcia = di-rutac.codcia AND
        di-rutag.coddiv = di-rutac.coddiv AND 
        di-rutag.coddoc = di-rutac.coddoc AND
        di-rutag.nrodoc = di-rutac.nrodoc NO-LOCK:
        lPeso = lPeso + di-rutaG.libre_d01.
    END.
    IF lPeso < gn-vehic.Libre_d01 THEN DO:
        MESSAGE 'NO se puede CONFIRMAR la Hoja de Ruta' SKIP
            'El peso está muy bajo' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
END.
/* ******************************************** */
/* RHC 19/10/2020 F.O. Control Fecha de Entrega */
/* ******************************************** */
DEF VAR x-FchCierre AS DATE NO-UNDO.

RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF RETURN-VALUE = 'YES' THEN x-FchCierre = TODAY.
ELSE x-FchCierre = Di-RutaC.FchDoc.

FIND TabGener WHERE TabGener.CodCia = s-CodCia
    AND TabGener.Clave = 'CFGINC'
    AND TabGener.Codigo = s-CodDiv
    NO-LOCK NO-ERROR.
IF AVAILABLE TabGener AND TabGener.Libre_l04 = YES THEN DO:
    /* Buscamos si una O/D u OTR tiene fecha de entrega menor a la de la H/R */
    FOR EACH di-rutaD WHERE di-rutad.codcia = di-rutac.codcia AND
        di-rutad.coddiv = di-rutac.coddiv AND 
        di-rutad.coddoc = di-rutac.coddoc AND
        di-rutad.nrodoc = di-rutac.nrodoc NO-LOCK,
        FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-CodCia
        AND Ccbcdocu.coddoc = Di-RutaD.CodRef
        AND Ccbcdocu.nrodoc = Di-RutaD.NroRef:
        FIND Faccpedi WHERE Faccpedi.codcia = s-CodCia
            AND Faccpedi.coddoc = Ccbcdocu.Libre_c01    /* O/D */
            AND Faccpedi.nroped = Ccbcdocu.Libre_c02
            NO-LOCK NO-ERROR.
        IF AVAILABLE Faccpedi AND Faccpedi.FchEnt < x-FchCierre THEN DO:
            MESSAGE ' El documento' Faccpedi.coddoc Faccpedi.nroped SKIP
                'tiene una fecha de entrega antigua:' Faccpedi.FchEnt
                VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
    END.
    FOR EACH di-rutaG WHERE di-rutag.codcia = di-rutac.codcia AND
        di-rutag.coddiv = di-rutac.coddiv AND 
        di-rutag.coddoc = di-rutac.coddoc AND
        di-rutag.nrodoc = di-rutac.nrodoc NO-LOCK,
        FIRST almcmov NO-LOCK WHERE almcmov.codcia = s-CodCia
        AND almcmov.codalm = di-rutag.CodAlm
        AND almcmov.tipmov = di-rutag.TipMov
        AND almcmov.codmov = di-rutag.CodMov
        AND almcmov.nroser = di-rutag.SerRef
        AND almcmov.nrodoc = di-rutag.NroRef:
        FIND Faccpedi WHERE Faccpedi.codcia = s-CodCia
            AND Faccpedi.coddoc = almcmov.codref        /* OTR */
            AND Faccpedi.nroped = almcmov.nroref
            NO-LOCK NO-ERROR.
        IF AVAILABLE Faccpedi AND Faccpedi.FchEnt < x-FchCierre THEN DO:
            MESSAGE ' El documento' Faccpedi.coddoc Faccpedi.nroped SKIP
                'tiene una fecha de entrega antigua:' Faccpedi.FchEnt
                VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
    END.
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
                         
  IF NOT (DI-RutaC.FlgEst = "P" AND DI-RutaC.Libre_l01 = NO) THEN DO:
      MESSAGE 'El estado de la H/R debe estar PENDIENTE y NO estar confirmada' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  ASSIGN
      x-GlosaAprobacion = DI-RutaC.GlosaAprobacion 
      x-UsrAprobacion = DI-RutaC.UsrAprobacion
      x-FchAprobacion = DI-RutaC.FchAprobacion.

  APPLY 'LEAVE':U TO DI-RutaC.CodVeh IN FRAME {&FRAME-NAME}.

  RUN Procesa-Handle IN lh_handle ('disable-detail').

  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

