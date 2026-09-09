&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
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
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-nomcia   AS CHAR.
DEF SHARED VAR s-coddoc   AS CHAR.
DEF SHARED VAR s-coddiv   AS CHAR.
DEF SHARED VAR S-DESALM  AS CHARACTER.
DEF SHARED VAR s-user-id  AS CHAR.
DEF SHARED VAR lh_Handle  AS HANDLE.

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
&Scoped-Define ENABLED-FIELDS DI-RutaC.FchSal DI-RutaC.KmtIni ~
DI-RutaC.CodVeh DI-RutaC.responsable DI-RutaC.ayudante-1 ~
DI-RutaC.ayudante-2 DI-RutaC.DesRut DI-RutaC.Libre_c01 
&Scoped-define ENABLED-TABLES DI-RutaC
&Scoped-define FIRST-ENABLED-TABLE DI-RutaC
&Scoped-Define ENABLED-OBJECTS RECT-14 
&Scoped-Define DISPLAYED-FIELDS DI-RutaC.NroDoc DI-RutaC.FchDoc ~
DI-RutaC.FchSal DI-RutaC.KmtIni DI-RutaC.usuario DI-RutaC.CodVeh ~
DI-RutaC.TpoTra DI-RutaC.responsable DI-RutaC.ayudante-1 ~
DI-RutaC.ayudante-2 DI-RutaC.DesRut DI-RutaC.Libre_c01 
&Scoped-define DISPLAYED-TABLES DI-RutaC
&Scoped-define FIRST-DISPLAYED-TABLE DI-RutaC
&Scoped-Define DISPLAYED-OBJECTS txtClieDol txtNroClientes txtPtosAlmacen ~
txtCargaMaxima txtHora txtMinuto FILL-IN-Marca FILL-IN-Estado txtCodPro ~
txtDTrans FILL-IN-Responsable FILL-IN-Ayudante-1 FILL-IN-Ayudante-2 ~
txtTransp1 txtTransp-2 txtTransp-3 txtTransp-4 txtTransp-5 txtClieSol ~
txtTranDol txtTranSol txtVolumen txtPeso txtVol txtConductor txtSerie ~
txtNro 

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
     SIZE 8.86 BY .81 NO-UNDO.

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
     SIZE 11 BY .81.

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
     SIZE 4 BY .81.

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
     SIZE 40.72 BY 4.85.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txtClieDol AT ROW 2.88 COL 111.72 COLON-ALIGNED WIDGET-ID 46
     txtNroClientes AT ROW 2.96 COL 89.86 COLON-ALIGNED WIDGET-ID 42
     txtPtosAlmacen AT ROW 3.88 COL 89.86 COLON-ALIGNED WIDGET-ID 44
     txtCargaMaxima AT ROW 3.12 COL 51.86 COLON-ALIGNED WIDGET-ID 40
     DI-RutaC.NroDoc AT ROW 1 COL 16 COLON-ALIGNED
          LABEL "Nº de Hoja"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     DI-RutaC.FchDoc AT ROW 1.23 COL 70.57 COLON-ALIGNED
          LABEL "Fecha Emision"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     txtHora AT ROW 1.73 COL 19.14 COLON-ALIGNED WIDGET-ID 2
     txtMinuto AT ROW 1.73 COL 26 COLON-ALIGNED WIDGET-ID 4
     DI-RutaC.FchSal AT ROW 2 COL 70.57 COLON-ALIGNED
          LABEL "Fecha Salida del Vehiculo"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     DI-RutaC.KmtIni AT ROW 2.54 COL 16 COLON-ALIGNED
          LABEL "Kilometraje de salida" FORMAT ">>>,>>9"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     DI-RutaC.usuario AT ROW 2.12 COL 89.72 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 15 FGCOLOR 12 
     DI-RutaC.CodVeh AT ROW 3.31 COL 16 COLON-ALIGNED
          LABEL "Placa del vehiculo" FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
     FILL-IN-Marca AT ROW 3.27 COL 24.29 COLON-ALIGNED NO-LABEL
     FILL-IN-Estado AT ROW 1.23 COL 89.72 COLON-ALIGNED
     DI-RutaC.TpoTra AT ROW 4.08 COL 18 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Propio", "01":U,
"Externo", "02":U
          SIZE 16 BY .77
     txtCodPro AT ROW 4.85 COL 16 COLON-ALIGNED WIDGET-ID 32
     txtDTrans AT ROW 4.85 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     DI-RutaC.responsable AT ROW 5.62 COL 16 COLON-ALIGNED
          LABEL "Responsable" FORMAT "x(6)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     FILL-IN-Responsable AT ROW 5.62 COL 25 COLON-ALIGNED NO-LABEL
     DI-RutaC.ayudante-1 AT ROW 6.38 COL 16 COLON-ALIGNED
          LABEL "Primer ayudante" FORMAT "x(6)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     FILL-IN-Ayudante-1 AT ROW 6.38 COL 25 COLON-ALIGNED NO-LABEL
     DI-RutaC.ayudante-2 AT ROW 7.15 COL 16 COLON-ALIGNED
          LABEL "Segundo ayudante" FORMAT "x(6)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     FILL-IN-Ayudante-2 AT ROW 7.15 COL 25 COLON-ALIGNED NO-LABEL
     DI-RutaC.DesRut AT ROW 7.92 COL 18 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 200 SCROLLBAR-VERTICAL
          SIZE 54 BY 1.73
     txtTransp1 AT ROW 5.5 COL 70.72 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     txtTransp-2 AT ROW 6.27 COL 70.72 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     txtTransp-3 AT ROW 7.04 COL 70.72 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     txtTransp-4 AT ROW 7.81 COL 70.72 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     txtTransp-5 AT ROW 8.58 COL 70.72 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     txtClieSol AT ROW 2.85 COL 97.72 COLON-ALIGNED WIDGET-ID 48
     txtTranDol AT ROW 3.85 COL 111.72 COLON-ALIGNED WIDGET-ID 50
     txtTranSol AT ROW 3.81 COL 97.72 COLON-ALIGNED WIDGET-ID 52
     txtVolumen AT ROW 3.96 COL 51.72 COLON-ALIGNED WIDGET-ID 54
     txtPeso AT ROW 3.12 COL 66.43 COLON-ALIGNED WIDGET-ID 56
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     txtVol AT ROW 3.96 COL 66.43 COLON-ALIGNED WIDGET-ID 58
     DI-RutaC.Libre_c01 AT ROW 10.08 COL 16 COLON-ALIGNED WIDGET-ID 64
          LABEL "Conductor (Licencia)" FORMAT "x(10)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     txtConductor AT ROW 10.08 COL 27.86 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     txtSerie AT ROW 9.96 COL 99.57 COLON-ALIGNED WIDGET-ID 16
     txtNro AT ROW 9.96 COL 108 COLON-ALIGNED WIDGET-ID 18
     "Empresas de Tranporte a la que Pertenece el Vehiculo" VIEW-AS TEXT
          SIZE 39 BY .5 AT ROW 4.96 COL 73.14 WIDGET-ID 36
          FGCOLOR 1 
     "Salida :" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 1.92 COL 12.72 WIDGET-ID 6
     "Detalle de la ruta:" VIEW-AS TEXT
          SIZE 12 BY .5 AT ROW 8.12 COL 6
     "Estado:" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 4.27 COL 13
     "(formato de 24 horas)" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 1.85 COL 32
     "Guia del Transportista :" VIEW-AS TEXT
          SIZE 16 BY .5 AT ROW 10.12 COL 81 WIDGET-ID 66
     RECT-14 AT ROW 4.77 COL 72.29 WIDGET-ID 38
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
         HEIGHT             = 10.69
         WIDTH              = 125.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
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
/* SETTINGS FOR FILL-IN DI-RutaC.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN DI-RutaC.responsable IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
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
    /*DI-RutaC.Nomtra:SCREEN-VALUE = ''*/
    DI-RutaC.TpoTra:SCREEN-VALUE = ''.

  ASSIGN  txtTransp-2:SCREEN-VALUE = ''
        txtTransp-3:SCREEN-VALUE = ''
      txtTransp-4:SCREEN-VALUE = ''
      txtTransp-5:SCREEN-VALUE = ''
      txtDTrans:SCREEN-VALUE = ''
      txtCodPro:SCREEN-VALUE = ''
      txtCargaMaxima:SCREEN-VALUE = '0'.

  FIND gn-vehic WHERE gn-vehic.codcia = s-codcia
    AND gn-vehic.placa = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-vehic THEN DO:
    FILL-IN-Marca:SCREEN-VALUE = gn-vehic.marca.
    txtCargaMaxima:SCREEN-VALUE = STRING(gn-vehic.carga,">>,>>9.99").
    DI-RutaC.TpoTra:SCREEN-VALUE = gn-vehic.estado.

    lCount = 1.
    FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = 'VEHICULO' AND
        vtatabla.llave_c2 = SELF:SCREEN-VALUE NO-LOCK:

        FIND gn-prov WHERE gn-prov.codcia = pv-codcia
            AND gn-prov.codpro = vtatabla.llave_c1 NO-LOCK NO-ERROR.

        IF AVAILABLE gn-prov THEN DO:        
            CASE lCount :
                WHEN 1 THEN DO:
                    ASSIGN txtCodPro:SCREEN-VALUE = vtatabla.llave_c1
                        txtDTrans:SCREEN-VALUE = gn-prov.nompro
                        txtTransp1:SCREEN-VALUE = vtatabla.llave_c1 + ' ' + gn-prov.nompro.
                        
                END.
                WHEN 2 THEN DO:
                    ASSIGN  txtTransp-2:SCREEN-VALUE = vtatabla.llave_c1 + ' ' + gn-prov.nompro.
                END.
                WHEN 3 THEN DO:
                    ASSIGN  txtTransp-3:SCREEN-VALUE = vtatabla.llave_c1 + ' ' + gn-prov.nompro.
                END.
                WHEN 4 THEN DO:
                    ASSIGN  txtTransp-4:SCREEN-VALUE = vtatabla.llave_c1 + ' ' + gn-prov.nompro.
                END.
                WHEN 5 THEN DO:
                    ASSIGN  txtTransp-5:SCREEN-VALUE = vtatabla.llave_c1 + ' ' + gn-prov.nompro.
                END.
            END CASE.
            lCount = lCount + 1.
        END.
    END.
    
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
/*   FIND GN-COB WHERE gn-cob.codcia = s-codcia                                 */
/*     AND gn-cob.codcob = SELF:SCREEN-VALUE                                    */
/*     NO-LOCK NO-ERROR.                                                        */
/*   IF AVAILABLE GN-COB THEN FILL-IN-Responsable:SCREEN-VALUE = gn-cob.nomcob. */
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

    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = 'VEHICULO' AND
        vtatabla.llave_c2 = DI-RutaC.COdveh:SCREEN-VALUE AND 
        vtatabla.llave_c1 = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE vtatabla THEN DO:
        FIND gn-prov WHERE gn-prov.codcia = pv-codcia
            AND gn-prov.codpro = vtatabla.llave_c1 NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN DO:
            txtDTrans:SCREEN-VALUE = gn-prov.nompro.
        END.

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
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
        AND FacCorre.CodDiv = S-CODDIV 
        AND FacCorre.CodDoc = S-CODDOC 
        EXCLUSIVE-LOCK NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN
        DI-RutaC.CodCia = s-codcia
        DI-RutaC.CodDiv = s-coddiv
        DI-RutaC.CodDoc = s-coddoc
        DI-RutaC.FchDoc = TODAY
        DI-RutaC.NroDoc = STRING(FacCorre.nroser, '999') + 
                            STRING(FacCorre.correlativo, '999999')
        FacCorre.Correlativo = FacCorre.Correlativo + 1
        DI-RutaC.usuario = s-user-id
        /*DI-RutaC.flgest  = "E".     /* Falta chequear bultos */ */
        DI-RutaC.flgest  = "P".     /* Pendiente */
  END.
  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    /*DI-RutaC.Nomtra  = DI-RutaC.Nomtra:SCREEN-VALUE IN FRAME {&FRAME-NAME}*/
    DI-RutaC.Nomtra = txtDtrans:SCREEN-VALUE IN FRAME {&FRAME-NAME}
    DI-RutaC.CodPro = txtCodPro:SCREEN-VALUE IN FRAME {&FRAME-NAME}
    DI-RutaC.Tpotra  = DI-RutaC.Tpotra:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

  /* 08 Julio 2013 - Ic*/
  ASSIGN txtHora txtMinuto.
  ASSIGN DI-RutaC.HorSal = STRING(txtHora,"99") + STRING(txtMinuto,"99")
        DI-RutaC.GuiaTransportista = STRING(txtSerie,"999") + "-" + STRING(txtNro,"99999999").

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .


  /* RHC 17.09.11 Control de G/R por pedidos */
  RUN dist/p-rut001 ( ROWID(Di-RutaC), YES ).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  
  RELEASE FacCorre.
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
  IF DI-RutaC.FlgEst <> 'P' THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  
/*   IF LOOKUP (DI-RutaC.FlgEst, 'P,E,X') = 0 THEN DO:                                                */
/*     MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.                                             */
/*     RETURN 'ADM-ERROR'.                                                                            */
/*   END.                                                                                             */
/*   /* control de salida de documentos */                                                            */
/*   FOR EACH di-rutad OF di-rutac NO-LOCK:                                                           */
/*       FIND LAST CntDocum USE-INDEX Llave02 WHERE CntDocum.codcia = s-codcia                        */
/*           AND CntDocum.coddoc = di-rutad.codref                                                    */
/*           AND CntDocum.nrodoc = di-rutad.nroref                                                    */
/*           NO-LOCK NO-ERROR.                                                                        */
/*       IF AVAILABLE CntDocum THEN DO:                                                               */
/*           MESSAGE 'NO se puede anular una hoja de ruta que ya pasó por vigilancia'                 */
/*               VIEW-AS ALERT-BOX ERROR.                                                             */
/*           RETURN 'ADM-ERROR'.                                                                      */
/*       END.                                                                                         */
/*   END.                                                                                             */
/*   FOR EACH di-rutag OF di-rutac NO-LOCK:                                                           */
/*       FIND LAST CntDocum USE-INDEX Llave02 WHERE CntDocum.codcia = s-codcia                        */
/*           AND CntDocum.coddoc = "G/R"                                                              */
/*           AND CntDocum.nrodoc = STRING(di-rutag.serref, '999') + STRING(di-rutad.nroref, '999999') */
/*           NO-LOCK NO-ERROR.                                                                        */
/*       IF AVAILABLE CntDocum THEN DO:                                                               */
/*           MESSAGE 'NO se puede anular una hoja de ruta que ya pasó por vigilancia'                 */
/*               VIEW-AS ALERT-BOX ERROR.                                                             */
/*           RETURN 'ADM-ERROR'.                                                                      */
/*       END.                                                                                         */
/*   END.                                                                                             */
/*   FOR EACH di-rutadg OF di-rutac NO-LOCK:                                                          */
/*       FIND LAST CntDocum USE-INDEX Llave02 WHERE CntDocum.codcia = s-codcia                        */
/*           AND CntDocum.coddoc = "G/R"                                                              */
/*           AND CntDocum.nrodoc = di-rutadg.nroref                                                   */
/*           NO-LOCK NO-ERROR.                                                                        */
/*       IF AVAILABLE CntDocum THEN DO:                                                               */
/*           MESSAGE 'NO se puede anular una hoja de ruta que ya pasó por vigilancia'                 */
/*               VIEW-AS ALERT-BOX ERROR.                                                             */
/*           RETURN 'ADM-ERROR'.                                                                      */
/*       END.                                                                                         */
/*   END.                                                                                             */

  {adm/i-DocPssw.i s-CodCia s-CodDoc ""DEL""}

  /* Dispatch standard ADM method.                             */
  
  /* SOLO LO MARCAMOS COMO ANULADO 
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
  */

  /* Code placed here will execute AFTER standard behavior.    */
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      /* RHC 21.05.2011 revisar los triggers de borrado */
      FOR EACH di-rutad OF di-rutac ON ERROR UNDO, RETURN 'ADM-ERROR':
          DELETE di-rutad.
      END.
      FOR EACH di-rutag OF di-rutac ON ERROR UNDO, RETURN 'ADM-ERROR':
          DELETE di-rutag.
      END.
      FOR EACH di-rutadg OF di-rutac ON ERROR UNDO, RETURN 'ADM-ERROR':
          DELETE di-rutadg.
      END.

      FIND CURRENT DI-RUTAC EXCLUSIVE-LOCK NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN
        DI-RutaC.flgest = 'A'.
      FIND CURRENT DI-RUTAC NO-LOCK NO-ERROR.
      RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  END.

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

    
/*     CASE DI-RutaC.FlgEst:                                        */
/*         WHEN 'E' THEN FILL-IN-Estado:SCREEN-VALUE = 'Emitida'.   */
/*         WHEN 'P' THEN FILL-IN-Estado:SCREEN-VALUE = 'Pendiente'. */
/*         WHEN 'C' THEN FILL-IN-Estado:SCREEN-VALUE = 'Cerrada'.   */
/*         WHEN 'A' THEN FILL-IN-Estado:SCREEN-VALUE = 'Anulada'.   */
/*     END CASE.                                                    */
    CASE DI-RutaC.FlgEst:
        WHEN 'X' THEN FILL-IN-Estado:SCREEN-VALUE = 'Falta Registar G/R'.
        WHEN 'E' THEN FILL-IN-Estado:SCREEN-VALUE = 'Falta Chequear Bultos'.
        WHEN 'P' THEN FILL-IN-Estado:SCREEN-VALUE = 'Pendiente'.
        WHEN 'C' THEN FILL-IN-Estado:SCREEN-VALUE = 'Cerrada'.
        WHEN 'A' THEN FILL-IN-Estado:SCREEN-VALUE = 'Anulada'.
        WHEN 'L' THEN FILL-IN-Estado:SCREEN-VALUE = 'Liquidado'.
    END CASE.
    
    ASSIGN
        FILL-IN-Ayudante-1:SCREEN-VALUE = '' 
        FILL-IN-Ayudante-2:SCREEN-VALUE = '' 
        FILL-IN-Responsable:SCREEN-VALUE = ''.
/*     FIND GN-COB WHERE gn-cob.codcia = s-codcia                                 */
/*         AND gn-cob.codcob = DI-RutaC.responsable                               */
/*         NO-LOCK NO-ERROR.                                                      */
/*     IF AVAILABLE GN-COB THEN FILL-IN-Responsable:SCREEN-VALUE = gn-cob.nomcob. */
    FIND pl-pers WHERE pl-pers.codper = DI-RutaC.responsable
      NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers THEN FILL-IN-Responsable:SCREEN-VALUE = TRIM(pl-pers.patper) + ' ' +
        TRIM(pl-pers.matper) + ', ' + pl-pers.nomper.
/*     FIND GN-COB WHERE gn-cob.codcia = s-codcia                                */
/*         AND gn-cob.codcob = DI-RutaC.ayudante-1                               */
/*         NO-LOCK NO-ERROR.                                                     */
/*     IF AVAILABLE GN-COB THEN FILL-IN-Ayudante-1:SCREEN-VALUE = gn-cob.nomcob. */
    FIND pl-pers WHERE pl-pers.codper = DI-RutaC.ayudante-1
      NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers THEN FILL-IN-Ayudante-1:SCREEN-VALUE = TRIM(pl-pers.patper) + ' ' +
        TRIM(pl-pers.matper) + ', ' + pl-pers.nomper.
/*     FIND GN-COB WHERE gn-cob.codcia = s-codcia                                */
/*         AND gn-cob.codcob = DI-RutaC.ayudante-2                               */
/*         NO-LOCK NO-ERROR.                                                     */
/*     IF AVAILABLE GN-COB THEN FILL-IN-Ayudante-2:SCREEN-VALUE = gn-cob.nomcob. */
    FIND pl-pers WHERE pl-pers.codper = DI-RutaC.ayudante-2
      NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers THEN FILL-IN-Ayudante-2:SCREEN-VALUE = TRIM(pl-pers.patper) + ' ' +
        TRIM(pl-pers.matper) + ', ' + pl-pers.nomper.
    
    txtSerie:SCREEN-VALUE = '0'.
    txtNro:SCREEN-VALUE = '0'.

    txtHora:SCREEN-VALUE = SUBSTRING(DI-RutaC.HorSal, 1, 2).
    txtMinuto:SCREEN-VALUE = SUBSTRING(DI-RutaC.HorSal, 3, 2).

    txtSerie:SCREEN-VALUE = SUBSTRING(di-rutac.GuiaTransportista,1,3).
    txtNro:SCREEN-VALUE = SUBSTRING(di-rutac.GuiaTransportista,5,8).

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
            /* Precios  */
            /*
            FOR EACH almdmov WHERE almdmov.codcia = di-rutaG.codcia
                    AND almdmov.codalm = di-rutag.codalm
                    AND almdmov.tipmov = di-rutag.tipmov 
                    AND almdmov.codmov = di-rutag.codmov
                    AND almdmov.nroser = INTEGER(di-rutag.serref)
                    AND almdmov.nrodoc = INTEGER(di-rutag.nroref) NO-LOCK:

                FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia AND AlmStkGe.codmat = almdmov.codmat AND
                    AlmStkGe.fecha <= DI-RutaC.Fchdoc NO-LOCK NO-ERROR.

                IF AVAILABLE AlmStkGe THEN DO:
                    lImpTranSol = tlImpTranSol + (AlmStkGe.CtoUni * AlmDmov.candes).
                END.


            END.
            */
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
  txtHora:SENSITIVE = YES.
  txtMinuto:SENSITIVE = YES.
      txtCodPro:SENSITIVE=YES.
    txtSerie:SENSITIVE = YES.
    txtNro:SENSITIVE = YES.
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

   IF LOOKUP(Di-Rutac.FlgEst, "P,C") = 0 THEN RETURN.
   x-nrodoc = DI-Rutac.Nrodoc.
   
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
          WHEN "INS" THEN ASSIGN x-INSDocs = x-INSDocs + 1 x-INSImporte = x-INSImporte + FACTURA.ImpTot.
          WHEN "TDA" THEN ASSIGN x-TDADocs = x-TDADocs + 1 x-TDAImporte = x-TDAImporte + FACTURA.ImpTot.
          WHEN "FER" THEN ASSIGN x-FERDocs = x-FERDocs + 1 x-FERImporte = x-FERImporte + FACTURA.ImpTot.
          WHEN "MOD" THEN ASSIGN x-MODDocs = x-MODDocs + 1 x-MODImporte = x-MODImporte + FACTURA.ImpTot.
          WHEN "PRO" THEN ASSIGN x-PRODocs = x-PRODocs + 1 x-PROImporte = x-PROImporte + FACTURA.ImpTot.
          WHEN "MIN" THEN ASSIGN x-MINDocs = x-MINDocs + 1 x-MINImporte = x-MINImporte + FACTURA.ImpTot.
          OTHERWISE ASSIGN x-OTROSDocs = x-OTROSDocs + 1 x-OTROSImporte = x-OTROSImporte + FACTURA.ImpTot.
      END CASE.
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
  END.
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
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

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

DEFINE VAR lFechaIng AS DATE.
DEFINE VAR lFechaSal AS DATE.

  DO WITH FRAME {&FRAME-NAME}:
      /*validacion de campo c.y*/
      /*  08 Jul 2013 - Ic
      hora1 = SUBSTRING(DI-RutaC.HorSal:SCREEN-VALUE, 1, 2).
      IF INT(hora1) >= 24 THEN DO:
          MESSAGE 'ingresar menor a 24 horas'.
          APPLY 'ENTRY' TO di-rutac.horsal.
          RETURN 'ADM-ERROR'.
      END.
  
      hora2 = SUBSTRING(DI-RutaC.HorSal:SCREEN-VALUE, 3, 2).
      IF INT(hora2) >= 60 THEN DO:
        MESSAGE 'ingresar menor a 60 minutos'.
        APPLY 'ENTRY' TO di-rutac.horsal.
            RETURN 'ADM-ERROR'.
      END.
      IF DI-RutaC.HorSal:SCREEN-VALUE = '' THEN DO:
          MESSAGE 'Debe ingresar la hora de salida' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO di-rutac.horsal.
          RETURN 'ADM-ERROR'.
      END.
      
      */
      /* 08 Jul 2013 - Ic */
      ASSIGN txtHora txtMinuto.
    ASSIGN txtCodPro txtDTrans txtSerie txtNro.

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

      IF txtNro <= 0 THEN DO:
          MESSAGE 'Ingrese el nro de Guia del Transportista..' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO txtNro.
          RETURN 'ADM-ERROR'.
      END.
      
      lFechaIng = DATE(DI-RutaC.FchDoc:SCREEN-VALUE).
      lFechaSal = DATE(DI-RutaC.FchSal:SCREEN-VALUE).

      IF INPUT DI-RutaC.FchSal < lFechaIng /*TODAY*/ THEN DO:
          MESSAGE 'Fecha de salida errada' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO FchSal.
          RETURN 'ADM-ERROR'.
      END.
      /* 
        10Jul2017, correo de Carlos Lalangui/Felix Perez
            restricción solicitada es por 48 horas útiles, 
            considerando el día sábado como útil.
       */
      IF lFechaSal > (lFechaIng + 2) THEN DO:
          MESSAGE 'Fecha de salida no debe sobre pasar las 48 Horas' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO FchSal.
          RETURN 'ADM-ERROR'.
      END.

      IF DECIMAL(DI-RutaC.KmtIni:SCREEN-VALUE) <= 0 THEN DO:
          MESSAGE 'Debe ingresar el kilometraje de salida' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO di-rutac.kmtini.
          RETURN 'ADM-ERROR'.
      END.

      FIND gn-vehic WHERE gn-vehic.codcia = s-codcia
          AND gn-vehic.placa = DI-RutaC.CodVeh:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-vehic THEN DO:
          MESSAGE 'Debe ingresar la placa del vehiculo' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO di-rutac.codveh.
          RETURN 'ADM-ERROR'.
      END.
      IF INTEGRAL.DI-RutaC.responsable:SCREEN-VALUE = '' THEN DO:
          MESSAGE 'Debe ingresar el responsable' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO di-rutac.responsable.
          RETURN 'ADM-ERROR'.
      END.
      
      IF INTEGRAL.DI-RutaC.ayudante-1:SCREEN-VALUE = '' THEN DO:
          MESSAGE 'Debe ingresar el primer ayudante' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO di-rutac.ayudante-1.
          RETURN 'ADM-ERROR'.
      END.

      FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = 'VEHICULO' AND
          vtatabla.llave_c2 = DI-RutaC.COdveh:SCREEN-VALUE AND 
          vtatabla.llave_c1 = txtCodPro:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF NOT AVAILABLE vtatabla THEN DO:
          MESSAGE 'Placa/Transportista NO existe' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO di-rutac.codveh.
          RETURN 'ADM-ERROR'.
      END.


      IF DI-RutaC.responsable:SCREEN-VALUE <> '' THEN DO:
/*           FIND GN-COB WHERE gn-cob.codcia = s-codcia                */
/*               AND gn-cob.codcob = DI-RutaC.responsable:SCREEN-VALUE */
/*               NO-LOCK NO-ERROR.                                     */
/*           IF NOT AVAILABLE GN-COB THEN DO:                          */
/*               MESSAGE "Codigo del Responsable no registrado"        */
/*                   VIEW-AS ALERT-BOX ERROR.                          */
/*               APPLY "ENTRY" TO DI-RutaC.responsable.                */
/*               RETURN 'ADM-ERROR'.                                   */
/*           END.                                                      */
          FIND pl-pers WHERE pl-pers.codper = DI-RutaC.responsable:SCREEN-VALUE
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE pl-pers THEN DO:
              MESSAGE "Codigo del Responsable no registrado"
                  VIEW-AS ALERT-BOX ERROR.
              APPLY "ENTRY" TO DI-RutaC.responsable.
              RETURN 'ADM-ERROR'.
          END.
      END.
      IF DI-RutaC.ayudante-1:SCREEN-VALUE <> '' THEN DO:
/*           FIND GN-COB WHERE gn-cob.codcia = s-codcia               */
/*               AND gn-cob.codcob = DI-RutaC.ayudante-1:SCREEN-VALUE */
/*               NO-LOCK NO-ERROR.                                    */
/*           IF NOT AVAILABLE GN-COB THEN DO:                         */
/*               MESSAGE "Codigo del Primer Ayudante no registrado"   */
/*                   VIEW-AS ALERT-BOX ERROR.                         */
/*               APPLY "ENTRY" TO DI-RutaC.ayudante-1.                */
/*               RETURN 'ADM-ERROR'.                                  */
/*           END.                                                     */
          FIND pl-pers WHERE pl-pers.codper = DI-RutaC.ayudante-1:SCREEN-VALUE
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE pl-pers THEN DO:
              MESSAGE "Codigo del Primer Ayudante no registrado"
                  VIEW-AS ALERT-BOX ERROR.
              APPLY "ENTRY" TO DI-RutaC.ayudante-1.
              RETURN 'ADM-ERROR'.
          END.
      END.
      IF DI-RutaC.ayudante-2:SCREEN-VALUE <> '' THEN DO:
/*           FIND GN-COB WHERE gn-cob.codcia = s-codcia               */
/*               AND gn-cob.codcob = DI-RutaC.ayudante-2:SCREEN-VALUE */
/*               NO-LOCK NO-ERROR.                                    */
/*           IF NOT AVAILABLE GN-COB THEN DO:                         */
/*               MESSAGE "Codigo del Segundo Ayudante no registrado"  */
/*                   VIEW-AS ALERT-BOX ERROR.                         */
/*               APPLY "ENTRY" TO DI-RutaC.ayudante-2.                */
/*               RETURN 'ADM-ERROR'.                                  */
/*           END.                                                     */
          FIND pl-pers WHERE pl-pers.codper = DI-RutaC.ayudante-2:SCREEN-VALUE
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE pl-pers THEN DO:
              MESSAGE "Codigo del Segundo Ayudante no registrado"
                  VIEW-AS ALERT-BOX ERROR.
              APPLY "ENTRY" TO DI-RutaC.ayudante-2.
              RETURN 'ADM-ERROR'.
          END.
      END.
  END.

  txtConductor:SCREEN-VALUE = "".
  IF INTEGRAL.DI-RutaC.libre_c01:SCREEN-VALUE = '' THEN DO:
      MESSAGE 'Debe ingresar la LICENCIA de conducir' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY' TO di-rutac.libre_c01.
      RETURN 'ADM-ERROR'.
  END.

  FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = 'BREVETE' AND
      vtatabla.llave_c1 = DI-RutaC.libre_c01:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE vtatabla THEN DO:
      MESSAGE 'Nro de Licencia NO existe' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY' TO di-rutac.libre_c01.
      RETURN 'ADM-ERROR'.
  END.
  
  txtConductor:SCREEN-VALUE = vtatabla.libre_C01 + " " + vtatabla.libre_C02 + " " + vtatabla.libre_C03.


  /*
  INTEGRAL.DI-RutaC.HorSal:SCREEN-VALUE = STRING(txtHora,"99") + STRING(txtMinuto,"99").
*/

RETURN "OK".
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

/*   IF DI-RutaC.FlgEst <> 'P' THEN DO:                   */
/*     MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR. */
/*     RETURN 'ADM-ERROR'.                                */
/*   END.                                                 */

  IF LOOKUP (DI-RutaC.FlgEst, 'P,E,X') = 0 THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
/*   {adm/i-DocPssw.i s-CodCia s-CodDoc ""UPD""} */
  RUN Procesa-Handle IN lh_handle ('disable-detail').

  RETURN "OK".

END PROCEDURE.


/*
        WHEN 'X' THEN FILL-IN-Estado:SCREEN-VALUE = 'Falta Registar G/R'.
        WHEN 'E' THEN FILL-IN-Estado:SCREEN-VALUE = 'Falta Chequear Bultos'.
        WHEN 'P' THEN FILL-IN-Estado:SCREEN-VALUE = 'Pendiente'.
        WHEN 'C' THEN FILL-IN-Estado:SCREEN-VALUE = 'Cerrada'.
        WHEN 'A' THEN FILL-IN-Estado:SCREEN-VALUE = 'Anulada'.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

