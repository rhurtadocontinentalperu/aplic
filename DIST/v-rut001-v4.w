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
DEF SHARED VAR s-acceso-total AS LOG.
DEF SHARED VAR s-Dias-Limite AS INT NO-UNDO.    /* Dias H/R Pendientes */

DEF VAR x-NroDoc LIKE di-rutac.nrodoc.

DEFINE VAR s-task-no AS INT.

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
DI-RutaC.TpoTra DI-RutaC.FchSal DI-RutaC.KmtIni DI-RutaC.responsable ~
DI-RutaC.ayudante-1 DI-RutaC.ayudante-2 DI-RutaC.DesRut DI-RutaC.Libre_c01 
&Scoped-define ENABLED-TABLES DI-RutaC
&Scoped-define FIRST-ENABLED-TABLE DI-RutaC
&Scoped-Define ENABLED-OBJECTS RECT-14 RECT-15 
&Scoped-Define DISPLAYED-FIELDS DI-RutaC.NroDoc DI-RutaC.Libre_l01 ~
DI-RutaC.Libre_c03 DI-RutaC.FchDoc DI-RutaC.CodVeh DI-RutaC.TpoTra ~
DI-RutaC.usuario DI-RutaC.FchSal DI-RutaC.Libre_c05 DI-RutaC.KmtIni ~
DI-RutaC.Libre_f05 DI-RutaC.responsable DI-RutaC.ayudante-1 ~
DI-RutaC.ayudante-2 DI-RutaC.DesRut DI-RutaC.Libre_c01 
&Scoped-define DISPLAYED-TABLES DI-RutaC
&Scoped-define FIRST-DISPLAYED-TABLE DI-RutaC
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Estado FILL-IN-Marca txtHora ~
txtMinuto txtCodPro txtDTrans txtTransp1 FILL-IN-Responsable txtTransp-2 ~
FILL-IN-Ayudante-1 txtTransp-3 FILL-IN-Ayudante-2 txtTransp-4 txtTransp-5 ~
txtConductor txtSerie txtNro txtCargaMaxima txtPeso txtNroClientes ~
txtClieSol txtClieDol txtVolumen txtVol txtPtosAlmacen txtTranSol ~
txtTranDol 

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
     SIZE 45 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Ayudante-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .81 NO-UNDO.

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
     SIZE 45 BY .81 NO-UNDO.

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
     SIZE 49 BY .81 NO-UNDO.

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
     LABEL "Serie" 
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

DEFINE VARIABLE txtTransp-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81
     FONT 3 NO-UNDO.

DEFINE VARIABLE txtTransp-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81
     FONT 3 NO-UNDO.

DEFINE VARIABLE txtTransp-4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81
     FONT 3 NO-UNDO.

DEFINE VARIABLE txtTransp-5 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81
     FONT 3 NO-UNDO.

DEFINE VARIABLE txtTransp1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81
     FONT 3 NO-UNDO.

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

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43 BY 5.12.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 118 BY 2.15.


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
     txtHora AT ROW 2.62 COL 16 COLON-ALIGNED WIDGET-ID 2
     txtMinuto AT ROW 2.62 COL 23 COLON-ALIGNED WIDGET-ID 4
     DI-RutaC.FchSal AT ROW 2.62 COL 73 COLON-ALIGNED
          LABEL "Fecha Salida del Vehiculo"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     DI-RutaC.Libre_c05 AT ROW 2.62 COL 99 COLON-ALIGNED WIDGET-ID 70
          LABEL "Modificado por" FORMAT "x(10)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     DI-RutaC.KmtIni AT ROW 3.42 COL 16 COLON-ALIGNED
          LABEL "Kilometraje de salida" FORMAT ">>>,>>9"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     DI-RutaC.Libre_f05 AT ROW 3.42 COL 99 COLON-ALIGNED WIDGET-ID 72
          LABEL "Día"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     txtCodPro AT ROW 4.23 COL 16 COLON-ALIGNED WIDGET-ID 32
     txtDTrans AT ROW 4.23 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     txtTransp1 AT ROW 4.96 COL 71.43 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     DI-RutaC.responsable AT ROW 5.04 COL 16 COLON-ALIGNED
          LABEL "Responsable" FORMAT "x(6)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     FILL-IN-Responsable AT ROW 5.04 COL 25 COLON-ALIGNED NO-LABEL
     txtTransp-2 AT ROW 5.73 COL 71.43 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     DI-RutaC.ayudante-1 AT ROW 5.85 COL 16 COLON-ALIGNED
          LABEL "Primer ayudante" FORMAT "x(6)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     FILL-IN-Ayudante-1 AT ROW 5.85 COL 25 COLON-ALIGNED NO-LABEL
     txtTransp-3 AT ROW 6.5 COL 71.43 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     DI-RutaC.ayudante-2 AT ROW 6.65 COL 16 COLON-ALIGNED
          LABEL "Segundo ayudante" FORMAT "x(6)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     FILL-IN-Ayudante-2 AT ROW 6.65 COL 25 COLON-ALIGNED NO-LABEL
     txtTransp-4 AT ROW 7.27 COL 71.43 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     DI-RutaC.DesRut AT ROW 7.46 COL 18 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 200 SCROLLBAR-VERTICAL
          SIZE 54 BY 1.88
     txtTransp-5 AT ROW 8.04 COL 71.43 COLON-ALIGNED NO-LABEL WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     DI-RutaC.Libre_c01 AT ROW 9.35 COL 16 COLON-ALIGNED WIDGET-ID 64
          LABEL "Conductor (Licencia)" FORMAT "x(10)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     txtConductor AT ROW 9.35 COL 27.86 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     txtSerie AT ROW 9.35 COL 99 COLON-ALIGNED WIDGET-ID 16
     txtNro AT ROW 9.35 COL 108 COLON-ALIGNED WIDGET-ID 18
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
     "Detalle de la ruta:" VIEW-AS TEXT
          SIZE 12 BY .5 AT ROW 7.65 COL 6
     "Empresas de Tranporte a la que Pertenece el Vehiculo" VIEW-AS TEXT
          SIZE 39 BY .5 AT ROW 4.42 COL 73.86 WIDGET-ID 36
          FGCOLOR 1 
     "(formato de 24 horas)" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 2.73 COL 29.29
     "Estado:" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 2 COL 46
     "Salida :" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 2.88 COL 9 WIDGET-ID 6
     "Guia del Transportista :" VIEW-AS TEXT
          SIZE 16 BY .5 AT ROW 9.5 COL 80 WIDGET-ID 66
     RECT-14 AT ROW 4.23 COL 72 WIDGET-ID 38
     RECT-15 AT ROW 10.42 COL 2 WIDGET-ID 74
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
         HEIGHT             = 11.85
         WIDTH              = 121.14.
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
/* SETTINGS FOR FILL-IN DI-RutaC.Libre_f05 IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX DI-RutaC.Libre_l01 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN DI-RutaC.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN DI-RutaC.responsable IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
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
/* SETTINGS FOR FILL-IN txtTransp-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtTransp-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtTransp-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtTransp-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtTransp1 IN FRAME F-Main
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
ON LEAVE OF DI-RutaC.ayudante-1 IN FRAME F-Main /* Primer ayudante */
DO:
  FILL-IN-Ayudante-1:SCREEN-VALUE = ''.
/*   FIND GN-COB WHERE gn-cob.codcia = s-codcia                                */
/*     AND gn-cob.codcob = SELF:SCREEN-VALUE                                   */
/*     NO-LOCK NO-ERROR.                                                       */
/*   IF AVAILABLE GN-COB THEN FILL-IN-Ayudante-1:SCREEN-VALUE = gn-cob.nomcob. */
  FIND pl-pers WHERE pl-pers.codper = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE pl-pers THEN FILL-IN-Ayudante-1:SCREEN-VALUE = TRIM(pl-pers.patper) + ' ' +
      TRIM(pl-pers.matper) + ', ' + pl-pers.nomper.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DI-RutaC.ayudante-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DI-RutaC.ayudante-2 V-table-Win
ON LEAVE OF DI-RutaC.ayudante-2 IN FRAME F-Main /* Segundo ayudante */
DO:
  FILL-IN-Ayudante-2:SCREEN-VALUE = ''.
/*   FIND GN-COB WHERE gn-cob.codcia = s-codcia                                */
/*     AND gn-cob.codcob = SELF:SCREEN-VALUE                                   */
/*     NO-LOCK NO-ERROR.                                                       */
/*   IF AVAILABLE GN-COB THEN FILL-IN-Ayudante-2:SCREEN-VALUE = gn-cob.nomcob. */
  FIND pl-pers WHERE pl-pers.codper = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE pl-pers THEN FILL-IN-Ayudante-2:SCREEN-VALUE = TRIM(pl-pers.patper) + ' ' +
      TRIM(pl-pers.matper) + ', ' + pl-pers.nomper.
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
      txtTransp-2:SCREEN-VALUE = ''
      txtTransp-3:SCREEN-VALUE = ''
      txtTransp-4:SCREEN-VALUE = ''
      txtTransp-5:SCREEN-VALUE = ''
      txtDTrans:SCREEN-VALUE = ''
      txtCodPro:SCREEN-VALUE = ''
      txtCargaMaxima:SCREEN-VALUE = '0'.
  FIND gn-vehic WHERE gn-vehic.codcia = s-codcia AND 
      gn-vehic.placa = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-vehic THEN DO:
      FILL-IN-Marca:SCREEN-VALUE = gn-vehic.marca.
      txtCargaMaxima:SCREEN-VALUE = STRING(gn-vehic.carga,">>,>>9.99").
      DI-RutaC.TpoTra:SCREEN-VALUE = gn-vehic.estado.
      FIND gn-prov WHERE gn-prov.codcia = pv-codcia
          AND gn-prov.codpro = gn-vehic.CodPro NO-LOCK NO-ERROR.
      IF AVAILABLE gn-prov THEN DO:        
          ASSIGN 
              txtCodPro:SCREEN-VALUE = gn-prov.codpro
              txtDTrans:SCREEN-VALUE = gn-prov.nompro
              txtTransp1:SCREEN-VALUE = gn-prov.codpro + ' ' + gn-prov.nompro.
          APPLY 'LEAVE':U TO txtCodPro. 
      END.
/*       lCount = 1.                                                                              */
/*       FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = 'VEHICULO' AND   */
/*           vtatabla.llave_c2 = SELF:SCREEN-VALUE NO-LOCK:                                       */
/*           FIND gn-prov WHERE gn-prov.codcia = pv-codcia                                        */
/*               AND gn-prov.codpro = vtatabla.llave_c1 NO-LOCK NO-ERROR.                         */
/*           IF AVAILABLE gn-prov THEN DO:                                                        */
/*               CASE lCount :                                                                    */
/*                   WHEN 1 THEN DO:                                                              */
/*                       ASSIGN                                                                   */
/*                           txtCodPro:SCREEN-VALUE = vtatabla.llave_c1                           */
/*                           txtDTrans:SCREEN-VALUE = gn-prov.nompro                              */
/*                           txtTransp1:SCREEN-VALUE = vtatabla.llave_c1 + ' ' + gn-prov.nompro.  */
/*                   END.                                                                         */
/*                   WHEN 2 THEN DO:                                                              */
/*                       ASSIGN                                                                   */
/*                           txtTransp-2:SCREEN-VALUE = vtatabla.llave_c1 + ' ' + gn-prov.nompro. */
/*                   END.                                                                         */
/*                   WHEN 3 THEN DO:                                                              */
/*                       ASSIGN                                                                   */
/*                           txtTransp-3:SCREEN-VALUE = vtatabla.llave_c1 + ' ' + gn-prov.nompro. */
/*                   END.                                                                         */
/*                   WHEN 4 THEN DO:                                                              */
/*                       ASSIGN                                                                   */
/*                           txtTransp-4:SCREEN-VALUE = vtatabla.llave_c1 + ' ' + gn-prov.nompro. */
/*                   END.                                                                         */
/*                   WHEN 5 THEN DO:                                                              */
/*                       ASSIGN                                                                   */
/*                           txtTransp-5:SCREEN-VALUE = vtatabla.llave_c1 + ' ' + gn-prov.nompro. */
/*                   END.                                                                         */
/*               END CASE.                                                                        */
/*               lCount = lCount + 1.                                                             */
/*           END.                                                                                 */
/*       END.                                                                                     */
      /* Datos del Internamiento del vehiculo */
      FIND TraIngSal WHERE TraIngSal.CodCia = s-CodCia AND
          TraIngSal.CodDiv = s-CodDiv AND 
          TraIngSal.Placa = DI-RutaC.CodVeh:SCREEN-VALUE AND 
          TraIngSal.FlgEst = "I" AND
          TraIngSal.FlgSit = "P" NO-LOCK NO-ERROR.
      IF AVAILABLE TraIngSal THEN DO:
          DISPLAY MAXIMUM(TraIngSal.FechaSalida, TODAY) @ DI-RutaC.FchSal
              SUBSTRING(TraIngSal.Guia,1,3) @ txtSerie 
              SUBSTRING(TraIngSal.Guia,4) @ txtNro
              TraIngSal.Brevete @ DI-RutaC.Libre_c01
              WITH FRAME {&FRAME-NAME}.
      END.
      APPLY 'LEAVE':U TO DI-RutaC.Libre_c01.
      APPLY 'LEAVE':U TO txtCodPro.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DI-RutaC.CodVeh V-table-Win
ON LEFT-MOUSE-DBLCLICK OF DI-RutaC.CodVeh IN FRAME F-Main /* Placa del vehiculo */
OR F8 OF DI-RutaC.CodVeh
DO:
  ASSIGN
      input-var-1 = s-coddiv
      input-var-2 = "I"
      input-var-3 = "P"
      output-var-1 = ?.
  RUN lkup/c-tra-ingsal.w ('Vehículos Internados').
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


&Scoped-define SELF-NAME DI-RutaC.Libre_c01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DI-RutaC.Libre_c01 V-table-Win
ON LEAVE OF DI-RutaC.Libre_c01 IN FRAME F-Main /* Conductor (Licencia) */
DO:
    txtConductor:SCREEN-VALUE = "".
    /*
    IF INTEGRAL.DI-RutaC.libre_c01:SCREEN-VALUE = '' THEN DO:
        MESSAGE 'Debe ingresar la LICENCIA de conducir' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY' TO di-rutac.libre_c01.
        RETURN 'ADM-ERROR'.
    END.
    */
    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = 'BREVETE' AND
        vtatabla.llave_c1 = DI-RutaC.libre_c01:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE vtatabla THEN DO:
        txtConductor:SCREEN-VALUE = vtatabla.libre_C01 + " " + vtatabla.libre_C02 + " " + vtatabla.libre_C03.  
        /*
        MESSAGE 'Nro de Licencia NO existe' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY' TO di-rutac.libre_c01.
        RETURN 'ADM-ERROR'.
        */
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DI-RutaC.responsable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DI-RutaC.responsable V-table-Win
ON LEAVE OF DI-RutaC.responsable IN FRAME F-Main /* Responsable */
DO:
  FILL-IN-Responsable:SCREEN-VALUE = ''.
  FIND pl-pers WHERE pl-pers.codper = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE pl-pers THEN FILL-IN-Responsable:SCREEN-VALUE = TRIM(pl-pers.patper) + ' ' +
      TRIM(pl-pers.matper) + ', ' + pl-pers.nomper.
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

/*     FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = 'VEHICULO' AND */
/*         vtatabla.llave_c2 = DI-RutaC.COdveh:SCREEN-VALUE AND                                 */
/*         vtatabla.llave_c1 = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.                              */
/*     IF AVAILABLE vtatabla THEN DO:                                                           */
/*         FIND gn-prov WHERE gn-prov.codcia = pv-codcia                                        */
/*             AND gn-prov.codpro = vtatabla.llave_c1 NO-LOCK NO-ERROR.                         */
/*         IF AVAILABLE gn-prov THEN DO:                                                        */
/*             txtDTrans:SCREEN-VALUE = gn-prov.nompro.                                         */
/*         END.                                                                                 */
/*                                                                                              */
/*     END.                                                                                     */


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
  DELETE PROCEDURE hProc.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN 'ADM-ERROR'.

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
      s-user-id @ DI-RutaC.usuario 
      x-NroDoc @ DI-RutaC.NroDoc
      WITH FRAME {&FRAME-NAME}.
  s-HR-Manual = YES.        /* Ingreso MANUAL */

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

  /* 08 Julio 2013 - Ic*/
  ASSIGN txtHora txtMinuto.
  ASSIGN 
      DI-RutaC.HorSal = STRING(txtHora,"99") + STRING(txtMinuto,"99")
      DI-RutaC.GuiaTransportista = STRING(txtSerie,"999") + "-" + STRING(txtNro,"99999999").

  /* RHC 17.09.11 Control de G/R por pedidos */
  RUN dist/p-rut001 ( ROWID(Di-RutaC), YES ).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  
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
/*   IF LOOKUP(DI-RutaC.FlgEst, 'C,A,L,PS,PR') > 0 THEN DO: */
/*       MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR. */
/*       RETURN 'ADM-ERROR'.                                */
/*   END.                                                   */

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
      RUN dist/dist-librerias-old PERSISTENT SET hProc.   /* Por ahora hasta pasar Picking x Rutas */
      /*RUN dist/dist-librerias PERSISTENT SET hProc.*/
      RUN Extorna-PHR IN hProc (INPUT ROWID(Di-RutaC), INPUT pGlosa, OUTPUT pMensaje).
      DELETE PROCEDURE hProc.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, LEAVE.
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
      DI-RutaC.Kmtini:SENSITIVE = NO.
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
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  lQtyClie = 0.
  lQtyAlm = 0.
  lImpClieDol = 0.
  lImpClieSol = 0.
  lImpTranDol = 0.
  lImpTranSol = 0.
  lPeso = 0.
  lVol = 0.
  EMPTY TEMP-TABLE tt-qttys.

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

    ASSIGN
        FILL-IN-Ayudante-1:SCREEN-VALUE = '' 
        FILL-IN-Ayudante-2:SCREEN-VALUE = '' 
        FILL-IN-Responsable:SCREEN-VALUE = ''.
    FIND pl-pers WHERE pl-pers.codper = DI-RutaC.responsable
      NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers THEN FILL-IN-Responsable:SCREEN-VALUE = TRIM(pl-pers.patper) + ' ' +
        TRIM(pl-pers.matper) + ', ' + pl-pers.nomper.
    FIND pl-pers WHERE pl-pers.codper = DI-RutaC.ayudante-1
      NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers THEN FILL-IN-Ayudante-1:SCREEN-VALUE = TRIM(pl-pers.patper) + ' ' +
        TRIM(pl-pers.matper) + ', ' + pl-pers.nomper.
    FIND pl-pers WHERE pl-pers.codper = DI-RutaC.ayudante-2
      NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers THEN FILL-IN-Ayudante-2:SCREEN-VALUE = TRIM(pl-pers.patper) + ' ' +
        TRIM(pl-pers.matper) + ', ' + pl-pers.nomper.
    
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
        ASSIGN
            lPeso = lPeso + DECIMAL(ENTRY(4,di-rutaD.libre_c01,","))
            lVol = lVol + DECIMAL(ENTRY(5,di-rutaD.libre_c01,","))
            NO-ERROR.
    END.
    /* Qttys Almacenes - Transferencias */
    FOR EACH di-rutaG WHERE di-rutac.codcia = di-rutaG.codcia
        AND di-rutac.coddiv = di-rutaG.coddiv AND 
        di-rutac.coddoc = di-rutaG.coddoc AND
        di-rutac.nrodoc = di-rutaG.nrodoc NO-LOCK:

        lImpTranSol = lImpTranSol + di-rutaG.libre_d02.
        lPeso = lPeso + di-rutaG.libre_d01.
        lVol = lVol + di-rutaG.libre_d03.

        FIND FIRST almcmov WHERE almcmov.codcia = di-rutaG.codcia
            AND almcmov.codalm = di-rutag.codalm
            AND almcmov.tipmov = di-rutag.tipmov 
            AND almcmov.codmov = di-rutag.codmov
            AND almcmov.nroser = INTEGER(di-rutag.serref)
            AND almcmov.nrodoc = INTEGER(di-rutag.nroref)
            NO-LOCK NO-ERROR.
        IF AVAILABLE almcmov THEN DO:
            FIND tt-qttys WHERE tt-qttys.tt-tipo = 'TRN' AND 
                tt-qttys.tt-clave1 = almcmov.AlmDes EXCLUSIVE NO-ERROR.
            IF NOT AVAILABLE tt-qttys THEN DO:
                CREATE tt-qttys.
                    ASSIGN tt-tipo = 'TRN'
                            tt-clave1 = almcmov.AlmDes.
                lQtyAlm = lQtyAlm + 1.
            END.
        END.
    END.
 
  DO WITH FRAME {&FRAME-NAME}:
    txtNroClientes:SCREEN-VALUE = string(lQtyClie,">,>>9").
    txtPtosAlmacen:SCREEN-VALUE = string(lQtyAlm,">,>>9").
    txtClieDol:SCREEN-VALUE = string(lImpClieDol,">>,>>>,>>9.99").
    txtClieSol:SCREEN-VALUE = string(lImpClieSol,">>,>>>,>>9.99").
    txtTranDol:SCREEN-VALUE = string(lImpTranDol,">>,>>>,>>9.99").
    txtTranSol:SCREEN-VALUE = string(lImpTranSol,">>,>>>,>>9.99").
    txtPeso:SCREEN-VALUE = string(lPeso,">>,>>>,>>9.99").
    txtVol:SCREEN-VALUE = string(lVol,">>,>>>,>>9.99").

    txtConductor:SCREEN-VALUE = "".
    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = 'BREVETE' AND
        vtatabla.llave_c1 = DI-RutaC.libre_c01:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE vtatabla THEN DO:
        txtConductor:SCREEN-VALUE = vtatabla.libre_C01 + " " + vtatabla.libre_C02 + " " + vtatabla.libre_C03.
    END.
  END.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
/*       txtHora:SENSITIVE   = YES. */
/*       txtMinuto:SENSITIVE = YES. */
      DI-RutaC.Libre_l01:SENSITIVE = NO.
      DI-RutaC.TpoTra:SENSITIVE = NO.
      DI-RutaC.Libre_c01:SENSITIVE = NO.
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'YES' THEN DO:
      END.
      ELSE DO:
          DI-RutaC.CodVeh:SENSITIVE = NO.
          IF TRUE <> (DI-RutaC.CodVeh > '')  THEN DI-RutaC.CodVeh:SENSITIVE = YES.
          /*APPLY 'LEAVE':U TO DI-RutaC.CodVeh.*/
          IF DI-RutaC.FlgEst = 'P' THEN DI-RutaC.Libre_l01:SENSITIVE = YES.
          IF DI-RutaC.Libre_l01 = YES THEN DO:
              DISABLE ALL EXCEPT txtHora txtMinuto DI-RutaC.Kmtini.
          END.
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

   DEFINE VAR x-nrodoc AS CHAR.
   DEFINE VAR lxPRCID AS CHAR.

   DEFINE VAR x-prefijo-docto AS CHAR.
   DEFINE VAR x-codigo-barra-docto AS CHAR.
   DEFINE VAR x-pedido-anterior AS CHAR.
   DEFINE VAR x-nro-cotizacion AS CHAR.
   DEFINE VAR x-rowid AS ROWID.

   /*IF LOOKUP(Di-Rutac.FlgEst, "P,C") = 0 THEN RETURN.*/
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

   x-nrodoc = DI-Rutac.Nrodoc.
   x-codigo-barra-docto = "*" + x-prefijo-docto + x-nrodoc + "*".
   
  /* LOGICA PRINCIPAL */
  /* Pantalla general de parametros de impresion */
  RUN bin/_prnctr.p.
  IF s-salida-impresion = 0 THEN RETURN.

  DEFINE VAR lNroCLientes AS CHAR.
  DEFINE VAR lNroPtosAlm AS CHAR.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN txtCargaMaxima.
  END.

  DO WITH FRAME {&FRAME-NAME}:
      lNroClientes = txtNroClientes:SCREEN-VALUE.
      lNroPtosAlm = txtPtosAlmacen:SCREEN-VALUE.
  END.  

  lxPRCID = STRING(PRCID,"999999999999").

  /* *************************************************************************************** */
  /* RHC 20/02/2019 */
  /* Grabamos el orden de impresion */
  /* *************************************************************************************** */
  DEF BUFFER B-RutaD FOR Di-RutaD.
  FOR EACH B-RutaD OF Di-RutaC NO-LOCK:
      FIND Di-RutaD WHERE ROWID(Di-RutaD) = ROWID(B-RutaD) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
      IF AVAILABLE Di-RutaD THEN DO:
          ASSIGN
              DI-RutaD.Libre_d01 = 9999.
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
              IF AVAILABLE VtaUbiDiv THEN DI-RutaD.Libre_d01 = VtaUbiDiv.Libre_d01.
          END.
          RELEASE Di-RutaD.
      END.
  END.
  /* *************************************************************************************** */
  /* *************************************************************************************** */

  /* test de impresion */
  RB-INCLUDE-RECORDS = "O".
  RB-FILTER = "DI-Rutad.Codcia = " + STRING(DI-Rutac.codcia) +  
              " AND Di-Rutad.Coddiv = '" + DI-Rutac.coddiv + "'" +
              " AND DI-Rutad.Coddoc = '" + DI-Rutac.coddoc + "'" + 
              " AND Di-Rutad.Nrodoc = '" + DI-Rutac.nrodoc + "'".
  RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia +
                        "~ns-desalm = " + s-desalm + 
                        "~ns-usuario = " + s-user-id +
                        "~ns-prcid = " + lxPRCID + 
                        "~ns-nroclientes = " +  lNroClientes + 
                        "~ns-codbarra = " + x-codigo-barra-docto + 
                        "~ns-cargamaxima = " + STRING(txtCargaMaxima,">>>,>>>.99") + " Kgrs" +
                        "~ns-licencia = " + DI-Rutac.libre_c01 + " " + txtConductor:SCREEN-VALUE.
  /* gran parche rosita */
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
  /* Captura parametros de impresion */
  ASSIGN
      RB-REPORT-NAME = "Hoja Ruta5"
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
  
  /* Acumulamos Información */
  DEF VAR x-INSDocs AS INT NO-UNDO.
  DEF VAR x-TDADocs AS INT NO-UNDO.
  DEF VAR x-FERDocs AS INT NO-UNDO.
  DEF VAR x-MODDocs AS INT NO-UNDO.
  DEF VAR x-PRODocs AS INT NO-UNDO.
  DEF VAR x-MINDocs AS INT NO-UNDO.
  DEF VAR x-OTROSDocs AS INT NO-UNDO.
  DEF VAR x-INSImporte AS DEC NO-UNDO.
  DEF VAR x-TDAImporte AS DEC NO-UNDO.
  DEF VAR x-FERImporte AS DEC NO-UNDO.
  DEF VAR x-MODImporte AS DEC NO-UNDO.
  DEF VAR x-PROImporte AS DEC NO-UNDO.
  DEF VAR x-MINImporte AS DEC NO-UNDO.
  DEF VAR x-OTROSImporte AS DEC NO-UNDO.
  DEF VAR x-INSPeso AS DEC NO-UNDO.
  DEF VAR x-TDAPeso AS DEC NO-UNDO.
  DEF VAR x-FERPeso AS DEC NO-UNDO.
  DEF VAR x-MODPeso AS DEC NO-UNDO.
  DEF VAR x-PROPeso AS DEC NO-UNDO.
  DEF VAR x-MINPeso AS DEC NO-UNDO.
  DEF VAR x-OTROSPeso AS DEC NO-UNDO.

  SESSION:SET-WAIT-STATE('GENERAL').

  EMPTY TEMP-TABLE ttTotales.

  FOR EACH DI-RutaD OF DI-RutaC NO-LOCK,
      FIRST Ccbcdocu NO-LOCK WHERE CcbCDocu.CodCia = s-codcia
      AND CcbCDocu.CodDoc = DI-RutaD.CodRef 
      AND CcbCDocu.NroDoc = DI-RutaD.NroRef,
      FIRST FACTURA NO-LOCK WHERE FACTURA.codcia = Ccbcdocu.codcia
      AND FACTURA.coddoc = Ccbcdocu.codref
      AND FACTURA.nrodoc = Ccbcdocu.nroref,
      FIRST GN-DIVI NO-LOCK WHERE GN-DIVI.CodCia = s-codcia
      AND GN-DIVI.CodDiv = CcbCDocu.DivOri:

      /* Cantidad de Documentos e Importes */
      CASE GN-DIVI.CanalVenta:
          WHEN "INS" THEN ASSIGN x-INSDocs = x-INSDocs + 1 x-INSImporte = x-INSImporte + CcbCDocu.ImpTot /*FACTURA.ImpTot*/.
          WHEN "TDA" THEN ASSIGN x-TDADocs = x-TDADocs + 1 x-TDAImporte = x-TDAImporte + CcbCDocu.ImpTot /*FACTURA.ImpTot*/.
          WHEN "FER" THEN ASSIGN x-FERDocs = x-FERDocs + 1 x-FERImporte = x-FERImporte + CcbCDocu.ImpTot /*FACTURA.ImpTot*/.
          WHEN "MOD" THEN ASSIGN x-MODDocs = x-MODDocs + 1 x-MODImporte = x-MODImporte + CcbCDocu.ImpTot /*FACTURA.ImpTot*/.
          WHEN "PRO" THEN ASSIGN x-PRODocs = x-PRODocs + 1 x-PROImporte = x-PROImporte + CcbCDocu.ImpTot /*FACTURA.ImpTot*/.
          WHEN "MIN" THEN ASSIGN x-MINDocs = x-MINDocs + 1 x-MINImporte = x-MINImporte + CcbCDocu.ImpTot /*FACTURA.ImpTot*/.
          OTHERWISE ASSIGN x-OTROSDocs = x-OTROSDocs + 1 x-OTROSImporte = x-OTROSImporte + CcbCDocu.ImpTot /*FACTURA.ImpTot*/.
      END CASE.
      /*
      FIND FIRST ttTotales WHERE tCodDoc = FACTURA.coddoc AND
                                    tNroDoc = FACTURA.nrodoc EXCLUSIVE NO-ERROR.

      IF NOT AVAILABLE ttTotales THEN DO:
          CREATE ttTotales.
            ASSIGN tCodDoc = FACTURA.coddoc
                    tNroDoc = FACTURA.nrodoc.

          CASE GN-DIVI.CanalVenta:
              WHEN "INS" THEN ASSIGN x-INSDocs = x-INSDocs + 1 x-INSImporte = x-INSImporte + CcbCDocu.ImpTot /*FACTURA.ImpTot*/.
              WHEN "TDA" THEN ASSIGN x-TDADocs = x-TDADocs + 1 x-TDAImporte = x-TDAImporte + CcbCDocu.ImpTot /*FACTURA.ImpTot*/.
              WHEN "FER" THEN ASSIGN x-FERDocs = x-FERDocs + 1 x-FERImporte = x-FERImporte + CcbCDocu.ImpTot /*FACTURA.ImpTot*/.
              WHEN "MOD" THEN ASSIGN x-MODDocs = x-MODDocs + 1 x-MODImporte = x-MODImporte + CcbCDocu.ImpTot /*FACTURA.ImpTot*/.
              WHEN "PRO" THEN ASSIGN x-PRODocs = x-PRODocs + 1 x-PROImporte = x-PROImporte + CcbCDocu.ImpTot /*FACTURA.ImpTot*/.
              WHEN "MIN" THEN ASSIGN x-MINDocs = x-MINDocs + 1 x-MINImporte = x-MINImporte + CcbCDocu.ImpTot /*FACTURA.ImpTot*/.
              OTHERWISE ASSIGN x-OTROSDocs = x-OTROSDocs + 1 x-OTROSImporte = x-OTROSImporte + CcbCDocu.ImpTot /*FACTURA.ImpTot*/.
          END CASE.
      END.
      */
      /* Peso */
      CASE GN-DIVI.CanalVenta:
          WHEN "INS" THEN ASSIGN x-INSPeso = x-INSPeso + DECIMAL(ENTRY(4,DI-RutaD.Libre_c01,",")).
          WHEN "TDA" THEN ASSIGN x-TDAPeso = x-TDAPeso + DECIMAL(ENTRY(4,DI-RutaD.Libre_c01,",")).
          WHEN "FER" THEN ASSIGN x-FERPeso = x-FERPeso + DECIMAL(ENTRY(4,DI-RutaD.Libre_c01,",")).
          WHEN "MOD" THEN ASSIGN x-MODPeso = x-MODPeso + DECIMAL(ENTRY(4,DI-RutaD.Libre_c01,",")).
          WHEN "PRO" THEN ASSIGN x-PROPeso = x-PROPeso + DECIMAL(ENTRY(4,DI-RutaD.Libre_c01,",")).
          WHEN "MIN" THEN ASSIGN x-MINPeso = x-MINPeso + DECIMAL(ENTRY(4,DI-RutaD.Libre_c01,",")).
          OTHERWISE ASSIGN x-OTROSPeso = x-OTROSPeso + DECIMAL(ENTRY(4,DI-RutaD.Libre_c01,",")).
      END CASE.

      /*
      
      Este proceso se llevo al programa dist/p-rut001.p
      
      /* Pedido Anterior */
      x-nro-cotizacion = "".
      x-pedido-anterior = "".
      /* Ubicar Cotizacion */
      FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                    x-faccpedi.coddoc = 'PED' AND 
                                    x-faccpedi.nroped = ccbcdocu.nroped NO-LOCK NO-ERROR.
      IF AVAILABLE x-faccpedi THEN x-nro-cotizacion = x-faccpedi.nroref.

      FIND LAST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND 
                                    x-faccpedi.codcli = ccbcdocu.codcli AND 
                                    x-faccpedi.coddoc = 'PED' AND 
                                    x-faccpedi.nroped < ccbcdocu.nroped AND 
                                    x-faccpedi.codref = 'COT' AND
                                    x-faccpedi.nroref = x-nro-cotizacion NO-LOCK NO-ERROR.
      IF AVAILABLE x-faccpedi THEN x-pedido-anterior = x-faccpedi.nroped.

      /* Grabo en DI-RUTAD */
      x-rowid = ROWID(di-rutaD).
      FIND FIRST x-di-rutaD WHERE ROWID(x-di-rutad) = x-rowid NO-ERROR.
      IF AVAILABLE x-di-rutaD THEN ASSIGN x-di-rutaD.libre_c04 = x-pedido-anterior.
      */

  END.
  SESSION:SET-WAIT-STATE('').

  RB-OTHER-PARAMETERS = RB-OTHER-PARAMETERS +
      "~ns-ins = " + STRING(x-INSDocs) + ',' + STRING(x-INSImporte) + ',' + STRING(x-INSPeso) +
      "~ns-tda = " + STRING(x-TDADocs) + ',' + STRING(x-TDAImporte) + ',' + STRING(x-TDAPeso) +
      "~ns-fer = " + STRING(x-FERDocs) + ',' + STRING(x-FERImporte) + ',' + STRING(x-FERPeso) +
      "~ns-mod = " + STRING(x-MODDocs) + ',' + STRING(x-MODImporte) + ',' + STRING(x-MODPeso) +
      "~ns-pro = " + STRING(x-PRODocs) + ',' + STRING(x-PROImporte) + ',' + STRING(x-PROPeso) +
      "~ns-min = " + STRING(x-MINDocs) + ',' + STRING(x-MINImporte) + ',' + STRING(x-MINPeso) +
      "~ns-otros = " + STRING(x-OTROSDocs) + ',' + STRING(x-OTROSImporte) + ',' + STRING(x-OTROSPeso).

  FIND FIRST DI-RutaD OF DI-RutaC NO-LOCK NO-ERROR.
  IF AVAILABLE DI-RutaD THEN
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

  /* Impresion de las G/Remision */
  
  RB-FILTER = "DI-RutaG.Codcia = " + STRING(DI-RutaC.codcia) +  
              " AND Di-RutaG.Coddiv = '" + Di-RutaC.coddiv + "'" +
              " AND DI-RutaG.Coddoc = '" + Di-RutaC.coddoc + "'" + 
              " AND Di-RutaG.Nrodoc = '" + Di-RutaC.nrodoc + "'".
  /*
  RB-FILTER = "DI-RutaG.Codcia = " + STRING(DI-RutaC.codcia) +  
              " AND Di-RutaG.Coddiv = '" + Di-RutaC.coddiv + "'" +
              " AND DI-RutaG.Coddoc = '" + Di-RutaC.coddoc + "'" + 
              " AND Di-RutaG.Nrodoc = '" + Di-RutaC.nrodoc + "'" + 
                " and (almcmov.codcia = DI-RutaG.Codcia " + 
                " and almcmov.codalm = DI-RutaG.codalm " + 
                " and almcmov.tipmov = di-rutaG.tipmov " + 
                " and almcmov.codmov = di-rutaG.codmov " + 
                " and almcmov.nroser = di-rutaG.serref " +
                " and almcmov.nrodoc = di-rutaG.nroref) ".
 */

  RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia +
                        "~ns-desalm = " + s-desalm + 
                        "~ns-usuario = " + s-user-id +
                        "~ns-prcid = " + lxPRCID + 
                        "~ns-nroclientes = " +  lNroClientes + 
                        "~ns-codbarra = " + x-codigo-barra-docto + 
                        "~ns-nroptosalm = " + lNroPtosAlm +
                        "~ns-cargamaxima = " + STRING(txtCargaMaxima,">>>,>>>.99")  + " Kgrs" + 
                        "~ns-licencia = " + DI-Rutac.libre_c01 + " " + txtConductor:SCREEN-VALUE .
     
ASSIGN
      RB-REPORT-NAME = "Hoja Ruta3"
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
  
  FIND FIRST DI-RutaG OF DI-RutaC NO-LOCK NO-ERROR.
  IF AVAILABLE DI-RutaG THEN
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
                      ""
                      ).

  /* Impresion de las G/R Itinerante */
  RB-FILTER = "DI-RutaDG.Codcia = " + STRING(Di-RutaC.codcia) +  
              " AND Di-RutaDG.Coddiv = '" + Di-RutaC.coddiv + "'" +
              " AND DI-RutaDG.Coddoc = '" + Di-RutaC.coddoc + "'" + 
              " AND Di-RutaDG.Nrodoc = '" + Di-RutaC.nrodoc + "'".
  ASSIGN
      RB-REPORT-NAME = "Hoja Ruta4"
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
  
  FIND FIRST DI-RutaDG OF DI-RutaC NO-LOCK NO-ERROR.
  IF AVAILABLE DI-RutaDG THEN
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
                      ""
                      ).    
    

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
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      s-HR-Manual = DI-RutaC.Libre_l02.     /* Origen H/R */

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

  /* Control de Ingreso del Transporte */
  DO WITH FRAME {&FRAME-NAME}:
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
      /* VALIDACION DEL PESO MINIMO AL CERRAR LA HR */
      IF LOGICAL(DI-RutaC.Libre_l01:SCREEN-VALUE) = YES THEN DO:
          IF s-acceso-total = NO THEN DO:
              /* Usuarios NO autorizados para aprobar HR debajo del peso mínimo */
              FIND gn-vehic WHERE gn-vehic.CodCia = s-codcia AND 
                  gn-vehic.placa = DI-RutaC.CodVeh:SCREEN-VALUE AND
                  gn-vehic.Libre_d01 > 0
                  NO-LOCK NO-ERROR.
              IF AVAILABLE gn-vehic THEN DO:
                  DEF VAR lPeso AS DEC NO-UNDO.
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
          END.
          ELSE DO:
              /* Solicita Glosa de CONFIRMADO */
              DEF VAR pError AS LOG NO-UNDO.
              x-GlosaAprobacion = ''.
              x-UsrAprobacion = ''.
              x-FchAprobacion = ?.
              RUN dist/d-mot-anu-hr ("OBSERVACION DE AUTORIZACON", 
                                     OUTPUT x-GlosaAprobacion, 
                                     OUTPUT pError).
              IF pError = YES THEN RETURN 'ADM-ERROR'.
          END.
          ASSIGN
              x-UsrAprobacion = s-User-Id
              x-FchAprobacion = TODAY.
      END.
  END.
  {dist/i-rut001-v32-valida.i}


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
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  ASSIGN
      x-GlosaAprobacion = DI-RutaC.GlosaAprobacion 
      x-UsrAprobacion = DI-RutaC.UsrAprobacion
      x-FchAprobacion = DI-RutaC.FchAprobacion.

  RUN Procesa-Handle IN lh_handle ('disable-detail').

  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

