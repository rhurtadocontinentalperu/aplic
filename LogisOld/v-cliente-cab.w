&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE b-clie NO-UNDO LIKE gn-clie.



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

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR s-CodDiv AS CHAR.

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "".
GET-KEY-VALUE SECTION "Startup" KEY "Base" VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "ccb\rbccb.prl".

DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Limite credito cliente".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "O".
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

/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
DEFINE SHARED VARIABLE  S-CODCIA AS INTEGER.
DEFINE VARIABLE cl-codcia  AS INTEGER INITIAL 0 NO-UNDO.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

FIND Empresas WHERE Empresas.CodCia = S-CODCIA NO-LOCK NO-ERROR.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = S-CODCIA.

DEF SHARED VAR s-nivel-acceso AS INT NO-UNDO.

DEF SHARED VAR s-seguridad AS CHAR.

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
&Scoped-define EXTERNAL-TABLES gn-clie
&Scoped-define FIRST-EXTERNAL-TABLE gn-clie


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR gn-clie.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS gn-clie.CodCli gn-clie.Libre_C01 ~
gn-clie.Flgsit gn-clie.Rucold gn-clie.Ruc gn-clie.DNI gn-clie.CodUnico ~
gn-clie.CodDiv gn-clie.Libre_L01 gn-clie.ApePat gn-clie.ApeMat ~
gn-clie.Nombre gn-clie.CodIBC gn-clie.Telfnos[1] gn-clie.DirCli ~
gn-clie.Telfnos[2] gn-clie.DirRef gn-clie.FaxCli gn-clie.DirEnt ~
gn-clie.CodDept gn-clie.E-Mail gn-clie.CodProv gn-clie.Transporte[4] ~
gn-clie.CodDist gn-clie.Codpos gn-clie.LocCli gn-clie.NroCard gn-clie.Canal ~
gn-clie.CodVen gn-clie.GirCli gn-clie.CndVta gn-clie.clfCli gn-clie.ClfCli2 ~
gn-clie.Aval1[5] gn-clie.RepLeg[1] gn-clie.RepLeg[2] gn-clie.JfeLog[5] ~
gn-clie.RepLeg[4] gn-clie.FNRepr gn-clie.RepLeg[5] 
&Scoped-define ENABLED-TABLES gn-clie
&Scoped-define FIRST-ENABLED-TABLE gn-clie
&Scoped-Define ENABLED-OBJECTS RECT-28 RECT-30 RECT-29 
&Scoped-Define DISPLAYED-FIELDS gn-clie.CodCli gn-clie.Libre_C01 ~
gn-clie.Flgsit gn-clie.Rucold gn-clie.Ruc gn-clie.DNI gn-clie.CodUnico ~
gn-clie.CodDiv gn-clie.Libre_L01 gn-clie.ApePat gn-clie.ApeMat ~
gn-clie.FchCes gn-clie.Nombre gn-clie.CodIBC gn-clie.NomCli ~
gn-clie.Telfnos[1] gn-clie.DirCli gn-clie.Telfnos[2] gn-clie.DirRef ~
gn-clie.FaxCli gn-clie.DirEnt gn-clie.Libre_L02 gn-clie.CodDept ~
gn-clie.E-Mail gn-clie.Fching gn-clie.CodProv gn-clie.Transporte[4] ~
gn-clie.usuario gn-clie.FchAct gn-clie.CodDist gn-clie.Codpos ~
gn-clie.LocCli gn-clie.NroCard gn-clie.Canal gn-clie.CodVen gn-clie.GirCli ~
gn-clie.CndVta gn-clie.clfCli gn-clie.ClfCli2 gn-clie.Aval1[5] ~
gn-clie.RepLeg[1] gn-clie.RepLeg[2] gn-clie.JfeLog[5] gn-clie.RepLeg[4] ~
gn-clie.FNRepr gn-clie.RepLeg[5] gn-clie.Libre_D01 
&Scoped-define DISPLAYED-TABLES gn-clie
&Scoped-define FIRST-DISPLAYED-TABLE gn-clie
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-DEP FILL-IN-PROV FILL-IN-DIS ~
FILL-IN-POS FILL-IN-NomCli f-Canal F-NomVen f-Giro f-ClfCli f-ConVta ~
f-ClfCli2 

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
DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 4 BY .81 TOOLTIP "Seleccionar condiciones de venta".

DEFINE VARIABLE f-ConVta AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 44 BY 1.73 NO-UNDO.

DEFINE VARIABLE f-Canal AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .81 NO-UNDO.

DEFINE VARIABLE f-ClfCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .81 NO-UNDO.

DEFINE VARIABLE f-ClfCli2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .81 NO-UNDO.

DEFINE VARIABLE f-Giro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .81 NO-UNDO.

DEFINE VARIABLE F-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DEP AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DIS AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-POS AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-PROV AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 131 BY 8.85.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 131 BY 4.62.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 131 BY 2.69.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     gn-clie.CodCli AT ROW 1.38 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 15 FGCOLOR 1 
     gn-clie.Libre_C01 AT ROW 1.38 COL 36 NO-LABEL WIDGET-ID 38
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Jurídica", "J":U,
"Natural", "N":U,
"Extranjera", "E":U
          SIZE 27 BY .81
          BGCOLOR 14 FGCOLOR 0 
     gn-clie.Flgsit AT ROW 1.38 COL 66 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Activo", "A":U,
"Cesado", "C":U
          SIZE 17 BY .77
     gn-clie.Rucold AT ROW 1.38 COL 109 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Si", "Si":U,
"No", "No":U
          SIZE 12 BY .77
     gn-clie.Ruc AT ROW 2.15 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 15 FGCOLOR 4 
     gn-clie.DNI AT ROW 2.15 COL 34 COLON-ALIGNED WIDGET-ID 52 FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     gn-clie.CodUnico AT ROW 2.15 COL 62 COLON-ALIGNED WIDGET-ID 4
          LABEL "Cod. Agrupador"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 15 FGCOLOR 12 
     gn-clie.CodDiv AT ROW 2.15 COL 80 COLON-ALIGNED FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     gn-clie.Libre_L01 AT ROW 2.15 COL 109 NO-LABEL WIDGET-ID 26
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Si", yes,
"No", no
          SIZE 11 BY .77
     gn-clie.ApePat AT ROW 2.92 COL 15 COLON-ALIGNED WIDGET-ID 8
          LABEL "Ap. Paterno"
          VIEW-AS FILL-IN 
          SIZE 27 BY .81
          BGCOLOR 11 FGCOLOR 7 
     gn-clie.ApeMat AT ROW 2.92 COL 64 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 30 BY .81
          BGCOLOR 11 FGCOLOR 7 
     gn-clie.FchCes AT ROW 2.92 COL 107 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     gn-clie.Nombre AT ROW 3.69 COL 15 COLON-ALIGNED WIDGET-ID 10
          LABEL "Razón Social/Nombre" FORMAT "X(120)"
          VIEW-AS FILL-IN 
          SIZE 80 BY .81
          BGCOLOR 11 FGCOLOR 7 
     gn-clie.CodIBC AT ROW 3.69 COL 107 COLON-ALIGNED WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .81
     gn-clie.NomCli AT ROW 4.46 COL 15 COLON-ALIGNED FORMAT "x(256)"
          VIEW-AS FILL-IN 
          SIZE 80 BY .81
     gn-clie.Telfnos[1] AT ROW 4.46 COL 107 COLON-ALIGNED
          LABEL "Telefono 1"
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .81
     gn-clie.DirCli AT ROW 5.23 COL 15 COLON-ALIGNED FORMAT "x(256)"
          VIEW-AS FILL-IN 
          SIZE 80 BY .81
     gn-clie.Telfnos[2] AT ROW 5.23 COL 107 COLON-ALIGNED
          LABEL "Telefono 2"
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .81
     gn-clie.DirRef AT ROW 6 COL 15 COLON-ALIGNED
          LABEL "Referencia" FORMAT "x(256)"
          VIEW-AS FILL-IN 
          SIZE 80 BY .81
     gn-clie.FaxCli AT ROW 6 COL 107 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .81
     gn-clie.DirEnt AT ROW 6.77 COL 15 COLON-ALIGNED
          LABEL "Entregar en" FORMAT "X(256)"
          VIEW-AS FILL-IN 
          SIZE 80 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     gn-clie.Libre_L02 AT ROW 6.96 COL 109 WIDGET-ID 36
          LABEL "Solo OpenOrange"
          VIEW-AS TOGGLE-BOX
          SIZE 15 BY .77
     gn-clie.CodDept AT ROW 7.54 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FILL-IN-DEP AT ROW 7.54 COL 20 COLON-ALIGNED NO-LABEL
     gn-clie.E-Mail AT ROW 7.54 COL 64 COLON-ALIGNED FORMAT "X(50)"
          VIEW-AS FILL-IN 
          SIZE 30 BY .81
     gn-clie.Fching AT ROW 7.73 COL 106 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     gn-clie.CodProv AT ROW 8.31 COL 15 COLON-ALIGNED
          LABEL "Provincia"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FILL-IN-PROV AT ROW 8.31 COL 20 COLON-ALIGNED NO-LABEL
     gn-clie.Transporte[4] AT ROW 8.31 COL 64 COLON-ALIGNED WIDGET-ID 46
          LABEL "eMail Facturacion Electronica" FORMAT "X(150)"
          VIEW-AS FILL-IN 
          SIZE 30 BY .81
     gn-clie.usuario AT ROW 8.46 COL 106 COLON-ALIGNED WIDGET-ID 12
          LABEL "Actualizado por"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     gn-clie.FchAct AT ROW 8.46 COL 117 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     gn-clie.CodDist AT ROW 9.08 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FILL-IN-DIS AT ROW 9.08 COL 20 COLON-ALIGNED NO-LABEL
     gn-clie.Codpos AT ROW 9.08 COL 64 COLON-ALIGNED
          LABEL "Codigo Postal"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FILL-IN-POS AT ROW 9.08 COL 69 COLON-ALIGNED NO-LABEL
     gn-clie.LocCli AT ROW 9.88 COL 91 NO-LABEL WIDGET-ID 48
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "VIP", "VIP":U,
"MESA REDONDA", "MR":U,
"OTROS", ""
          SIZE 40 BY .81
     gn-clie.NroCard AT ROW 10.42 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     FILL-IN-NomCli AT ROW 10.42 COL 24 COLON-ALIGNED NO-LABEL
     gn-clie.Canal AT ROW 10.62 COL 89 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     f-Canal AT ROW 10.62 COL 97 COLON-ALIGNED NO-LABEL
     gn-clie.CodVen AT ROW 11.19 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     F-NomVen AT ROW 11.19 COL 22 COLON-ALIGNED NO-LABEL
     gn-clie.GirCli AT ROW 11.38 COL 89 COLON-ALIGNED
          LABEL "Giro" FORMAT "X(4)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     f-Giro AT ROW 11.38 COL 97 COLON-ALIGNED NO-LABEL
     BUTTON-1 AT ROW 11.92 COL 61 WIDGET-ID 2
     gn-clie.CndVta AT ROW 11.96 COL 15 COLON-ALIGNED FORMAT "X(256)"
          VIEW-AS FILL-IN 
          SIZE 44 BY .81
     gn-clie.clfCli AT ROW 12.15 COL 89 COLON-ALIGNED
          LABEL "Clasif. Productos PROPIOS"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     f-ClfCli AT ROW 12.15 COL 97 COLON-ALIGNED NO-LABEL
     f-ConVta AT ROW 12.73 COL 17 NO-LABEL WIDGET-ID 32
     gn-clie.ClfCli2 AT ROW 12.92 COL 89 COLON-ALIGNED WIDGET-ID 22
          LABEL "Clasif. Productos TERCEROS:"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     f-ClfCli2 AT ROW 12.92 COL 97 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     gn-clie.Aval1[5] AT ROW 13.69 COL 89 COLON-ALIGNED
          LABEL "Características"
          VIEW-AS FILL-IN 
          SIZE 22.86 BY .81
     gn-clie.RepLeg[1] AT ROW 14.85 COL 15 COLON-ALIGNED
          LABEL "Nombre y Apellido" FORMAT "X(256)"
          VIEW-AS FILL-IN 
          SIZE 54 BY .81
     gn-clie.RepLeg[2] AT ROW 14.85 COL 80 COLON-ALIGNED
          LABEL "DNI" FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .81
     gn-clie.JfeLog[5] AT ROW 14.85 COL 106 COLON-ALIGNED WIDGET-ID 54
          LABEL "Cliente-Accionista" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
          BGCOLOR 13 FGCOLOR 15 
     gn-clie.RepLeg[4] AT ROW 15.62 COL 15 COLON-ALIGNED
          LABEL "Direccion Domicilio" FORMAT "X(256)"
          VIEW-AS FILL-IN 
          SIZE 54 BY .81
     gn-clie.FNRepr AT ROW 15.62 COL 80 COLON-ALIGNED
          LABEL "Fch.Nac."
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .81
     gn-clie.RepLeg[5] AT ROW 16.38 COL 15 COLON-ALIGNED
          LABEL "Telefono"
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .81
     gn-clie.Libre_D01 AT ROW 16.38 COL 80 COLON-ALIGNED WIDGET-ID 44
          LABEL "Lista Precios Terceros Activa" FORMAT ">9"
          VIEW-AS FILL-IN 
          SIZE 3 BY .81
          BGCOLOR 0 FGCOLOR 14 
     "Persona:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 1.38 COL 29 WIDGET-ID 42
     "Informacion de Ventas" VIEW-AS TEXT
          SIZE 16 BY .5 AT ROW 9.85 COL 1
          BGCOLOR 1 FGCOLOR 15 
     "Agente de Percepción:" VIEW-AS TEXT
          SIZE 16 BY .5 AT ROW 2.15 COL 93 WIDGET-ID 30
     "Representante Legal" VIEW-AS TEXT
          SIZE 16 BY .5 AT ROW 14.46 COL 1
          BGCOLOR 1 FGCOLOR 15 
     "Agente Retenedor:" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 1.5 COL 95
     "Informacion General" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 1 COL 1
          BGCOLOR 1 FGCOLOR 15 
     RECT-28 AT ROW 1.19 COL 1
     RECT-30 AT ROW 14.65 COL 1
     RECT-29 AT ROW 10.04 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.gn-clie
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: b-clie T "?" NO-UNDO INTEGRAL gn-clie
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
         HEIGHT             = 18.04
         WIDTH              = 132.43.
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

/* SETTINGS FOR FILL-IN gn-clie.ApePat IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.Aval1[5] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR BUTTON BUTTON-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.clfCli IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.ClfCli2 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.CndVta IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN gn-clie.CodDiv IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN gn-clie.Codpos IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.CodProv IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.CodUnico IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.DirCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN gn-clie.DirEnt IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.DirRef IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.DNI IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN gn-clie.E-Mail IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN f-Canal IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-ClfCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-ClfCli2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR f-ConVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-Giro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.FchAct IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.FchCes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.Fching IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DEP IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DIS IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-POS IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-PROV IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.FNRepr IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.GirCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.JfeLog[5] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.Libre_D01 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR TOGGLE-BOX gn-clie.Libre_L02 IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN gn-clie.Nombre IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.NomCli IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.RepLeg[1] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.RepLeg[2] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.RepLeg[4] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.RepLeg[5] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.Telfnos[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.Telfnos[2] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.Transporte[4] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.usuario IN FRAME F-Main
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

&Scoped-define SELF-NAME gn-clie.ApeMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.ApeMat V-table-Win
ON LEAVE OF gn-clie.ApeMat IN FRAME F-Main /* Ap. Materno */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    gn-clie.nomcli:SCREEN-VALUE = TRIM (gn-clie.apepat:SCREEN-VALUE) + " " +
        TRIM (gn-clie.apemat:SCREEN-VALUE) + ", " +
        gn-clie.nombre:SCREEN-VALUE.
    IF gn-clie.apepat:SCREEN-VALUE = '' AND gn-clie.apemat:SCREEN-VALUE = '' 
    THEN gn-clie.nomcli:SCREEN-VALUE = gn-clie.nombre:SCREEN-VALUE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.ApePat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.ApePat V-table-Win
ON LEAVE OF gn-clie.ApePat IN FRAME F-Main /* Ap. Paterno */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    gn-clie.nomcli:SCREEN-VALUE = TRIM (gn-clie.apepat:SCREEN-VALUE) + " " +
        TRIM (gn-clie.apemat:SCREEN-VALUE) + ", " +
        gn-clie.nombre:SCREEN-VALUE.
    IF gn-clie.apepat:SCREEN-VALUE = '' AND gn-clie.apemat:SCREEN-VALUE = '' 
    THEN gn-clie.nomcli:SCREEN-VALUE = gn-clie.nombre:SCREEN-VALUE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.Aval1[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.Aval1[5] V-table-Win
ON LEAVE OF gn-clie.Aval1[5] IN FRAME F-Main /* Características */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 V-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:
    DEF VAR x-Condiciones AS CHAR.
    DEF VAR x-Descripcion AS CHAR.
    x-Condiciones = gn-clie.CndVta:SCREEN-VALUE.
    x-Descripcion = f-ConVta:SCREEN-VALUE.
    RUN vta/d-repo10 (INPUT-OUTPUT x-Condiciones, INPUT-OUTPUT x-Descripcion).
    gn-clie.CndVta:SCREEN-VALUE = x-Condiciones.
    f-convta:SCREEN-VALUE = x-Descripcion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.Canal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.Canal V-table-Win
ON LEAVE OF gn-clie.Canal IN FRAME F-Main /* Canal */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO:
     FIND almtabla WHERE almtabla.Tabla = 'CN' 
        AND almtabla.Codigo = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE almtabla 
     THEN F-Canal:screen-value = almtabla.nombre.
     ELSE F-Canal:screen-value = "".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.clfCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.clfCli V-table-Win
ON LEAVE OF gn-clie.clfCli IN FRAME F-Main /* Clasif. Productos PROPIOS */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  f-ClfCli:SCREEN-VALUE = 'SIN CLASIFICACION'.
  FIND ClfClie WHERE ClfClie.Categoria = gn-clie.clfCli NO-LOCK NO-ERROR.
  IF AVAILABLE ClfClie THEN f-ClfCli:SCREEN-VALUE = ClfClie.DesCat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.CndVta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.CndVta V-table-Win
ON LEAVE OF gn-clie.CndVta IN FRAME F-Main /* Condicion de Venta */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO:
     FIND gn-convt WHERE gn-convt.Codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt 
     THEN F-ConVta:screen-value = gn-convt.Nombr.
     ELSE F-Convta:screen-value = "".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.CodCli V-table-Win
ON LEAVE OF gn-clie.CodCli IN FRAME F-Main /* Codigo */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    ASSIGN
        SELF:SCREEN-VALUE = STRING(DECIMAL(SELF:SCREEN-VALUE), '99999999999') NO-ERROR.
    IF ERROR-STATUS:ERROR THEN RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
    /* dígito verificador en caso de que se un número de ruc */
    DEF VAR pResultado AS CHAR.
    IF LOOKUP(SUBSTRING(SELF:SCREEN-VALUE,1,2), '10,20,15,17') > 0 THEN DO:
        RUN lib/_ValRuc (SELF:SCREEN-VALUE, OUTPUT pResultado).
        IF pResultado = 'ERROR' THEN DO:
            MESSAGE 'Código MAL registrado' VIEW-AS ALERT-BOX WARNING.
            RETURN NO-APPLY.
        END.
        IF gn-clie.Ruc:SCREEN-VALUE = '' THEN gn-clie.Ruc:SCREEN-VALUE = SELF:SCREEN-VALUE.
/*         IF SUBSTRING(SELF:SCREEN-VALUE,1,2) = "20" */
/*             THEN ASSIGN                            */
/*             gn-clie.ApeMat:SENSITIVE = NO          */
/*             gn-clie.ApePat:SENSITIVE = NO          */
/*             gn-clie.Nombre:SENSITIVE = YES         */
/*             gn-clie.ApeMat:SCREEN-VALUE = ''       */
/*             gn-clie.ApePat:SCREEN-VALUE = ''.      */
/*         ELSE ASSIGN                                */
/*             gn-clie.ApeMat:SENSITIVE = YES         */
/*             gn-clie.ApePat:SENSITIVE = YES         */
/*             gn-clie.Nombre:SENSITIVE = YES.        */
/*         APPLY 'LEAVE':U TO gn-clie.ApePat.         */
    END.
    APPLY "VALUE-CHANGED":U TO gn-clie.Libre_C01.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.CodDept
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.CodDept V-table-Win
ON LEAVE OF gn-clie.CodDept IN FRAME F-Main /* Departamento */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO:
    FIND  TabDepto WHERE TabDepto.CodDepto = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE TabDepto 
    THEN Fill-in-dep:screen-value = TabDepto.NomDepto.
    ELSE Fill-in-dep:screen-value = "".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.CodDist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.CodDist V-table-Win
ON LEAVE OF gn-clie.CodDist IN FRAME F-Main /* Distrito */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO:
    FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept:screen-value 
        AND Tabdistr.Codprovi = gn-clie.codprov:screen-value 
        AND Tabdistr.Coddistr = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE Tabdistr 
    THEN Fill-in-dis:screen-value = Tabdistr.Nomdistr .
    ELSE Fill-in-dis:screen-value = "".
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.Codpos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.Codpos V-table-Win
ON LEAVE OF gn-clie.Codpos IN FRAME F-Main /* Codigo Postal */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO:
    FIND almtabla WHERE almtabla.Tabla = 'CP' 
        AND almtabla.Codigo = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE almtabla 
    THEN FILL-IN-POS:screen-value = almtabla.nombre.
    ELSE FILL-IN-POS:screen-value = "".
  END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.CodProv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.CodProv V-table-Win
ON LEAVE OF gn-clie.CodProv IN FRAME F-Main /* Provincia */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO:
    FIND  Tabprovi WHERE Tabprovi.CodDepto = gn-clie.CodDept:screen-value 
        AND Tabprovi.Codprovi = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE Tabprovi 
    THEN fill-in-prov:screen-value = Tabprovi.Nomprovi.
    ELSE fill-in-prov:screen-value = "".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.CodVen V-table-Win
ON LEAVE OF gn-clie.CodVen IN FRAME F-Main /* Codigo Vendedor */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO:
     FIND gn-ven WHERE gn-ven.codcia = s-codcia
        AND gn-ven.CodVen = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven 
     THEN F-NomVen:screen-value = gn-ven.NomVen.
     ELSE F-NomVen:screen-value = "".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.GirCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.GirCli V-table-Win
ON LEAVE OF gn-clie.GirCli IN FRAME F-Main /* Giro */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO:
     FIND almtabla WHERE almtabla.Tabla = 'GN' 
        AND almtabla.Codigo = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE almtabla 
     THEN F-Giro:screen-value = almtabla.nombre.
     ELSE F-Giro:screen-value = "".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.Libre_C01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.Libre_C01 V-table-Win
ON VALUE-CHANGED OF gn-clie.Libre_C01 IN FRAME F-Main /* Libre_C01 */
DO:
    IF gn-clie.Libre_C01:SCREEN-VALUE <> "N" 
        THEN ASSIGN
        gn-clie.ApeMat:SENSITIVE = NO
        gn-clie.ApePat:SENSITIVE = NO
        gn-clie.Nombre:SENSITIVE = YES
        gn-clie.ApeMat:SCREEN-VALUE = ''
        gn-clie.ApePat:SCREEN-VALUE = ''.
    ELSE ASSIGN
        gn-clie.ApeMat:SENSITIVE = YES
        gn-clie.ApePat:SENSITIVE = YES
        gn-clie.Nombre:SENSITIVE = YES.
    APPLY 'LEAVE':U TO gn-clie.ApePat.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.Nombre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.Nombre V-table-Win
ON LEAVE OF gn-clie.Nombre IN FRAME F-Main /* Razón Social/Nombre */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    gn-clie.nomcli:SCREEN-VALUE = TRIM (gn-clie.apepat:SCREEN-VALUE) + " " +
        TRIM (gn-clie.apemat:SCREEN-VALUE) + ", " +
        gn-clie.nombre:SCREEN-VALUE.
    IF gn-clie.apepat:SCREEN-VALUE = '' AND gn-clie.apemat:SCREEN-VALUE = '' 
    THEN gn-clie.nomcli:SCREEN-VALUE = gn-clie.nombre:SCREEN-VALUE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.NomCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.NomCli V-table-Win
ON LEAVE OF gn-clie.NomCli IN FRAME F-Main /* Nombre */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.NroCard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.NroCard V-table-Win
ON LEAVE OF gn-clie.NroCard IN FRAME F-Main /* NroCard */
DO:
  FILL-IN-NomCli:SCREEN-VALUE = ''.
  IF SELF:SCREEN-VALUE <> ''
  THEN DO:
    FIND GN-CARD WHERE gn-card.nrocard = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-card THEN FILL-IN-NomCli:SCREEN-VALUE = gn-card.nomcard.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.Ruc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.Ruc V-table-Win
ON LEAVE OF gn-clie.Ruc IN FRAME F-Main /* Ruc */
DO:
/*     IF SUBSTRING(SELF:SCREEN-VALUE,1,2) = "20" */
/*         THEN ASSIGN                            */
/*         gn-clie.ApeMat:SENSITIVE = NO          */
/*         gn-clie.ApePat:SENSITIVE = NO          */
/*         gn-clie.Nombre:SENSITIVE = YES         */
/*         gn-clie.ApeMat:SCREEN-VALUE = ''       */
/*         gn-clie.ApePat:SCREEN-VALUE = ''.      */
/*     ELSE ASSIGN                                */
/*         gn-clie.ApeMat:SENSITIVE = YES         */
/*         gn-clie.ApePat:SENSITIVE = YES         */
/*         gn-clie.Nombre:SENSITIVE = YES.        */
/*     APPLY 'LEAVE':U TO gn-clie.ApePat.         */
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
  {src/adm/template/row-list.i "gn-clie"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "gn-clie"}

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('0').
  ASSIGN
      gn-clie.Rucold:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'No'
      gn-clie.Libre_L01:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'No'
      gn-clie.clfCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'C'
      gn-clie.clfCli2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'C'
      gn-clie.Flgsit:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'A'
      gn-clie.Libre_C01:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'N'.

  IF s-CodDiv = '00024' THEN gn-clie.CodDiv:SCREEN-VALUE IN FRAME {&FRAME-NAME} = s-CodDiv.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR cEvento AS CHAR INIT "CREATE" NO-UNDO.
  DEF VAR x-Mensaje AS CHAR NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN get-attribute("ADM-NEW-RECORD").
  IF RETURN-VALUE = "YES" THEN DO:
     ASSIGN 
         gn-clie.clfcli = "C"       /* por defecto */
         gn-clie.clfcli2 = "C"       /* por defecto */
         gn-clie.CodCia = CL-CODCIA
         gn-clie.Fching = TODAY.
     /* Buscamos RUC repetidos */
     IF gn-clie.Ruc <> '' THEN DO:
         x-Mensaje = ''.
         FOR EACH b-clie NO-LOCK WHERE b-clie.codcia = cl-codcia AND
             b-clie.ruc = gn-clie.Ruc AND
             ROWID(b-clie) <> ROWID(gn-clie):
             x-Mensaje = x-Mensaje + (IF x-Mensaje <> '' THEN CHR(10) ELSE '') +
                 b-clie.codcli + ' ' + b-clie.nomcli.
         END.
         IF x-Mensaje <> '' THEN DO:
             MESSAGE 'Los siguientes clientes tienen el mismo RUC:' SKIP
                 x-Mensaje SKIP(1)
                 'Continuamos con la grabación?'
                 VIEW-AS ALERT-BOX WARNING
                 BUTTONS YES-NO UPDATE rpta AS LOG.
             IF rpta = NO THEN UNDO, RETURN "ADM-ERROR".
             cEvento = "CREATE*".
         END.
     END.
     /* Solo para cliente NUEVO INSTITUCIONALES */
     IF s-CodDiv = "00024" THEN DO:
         ASSIGN
             GN-CLIE.FlagAut = 'A'          /* POR DEFECTO */
             Gn-clie.FchAut[1] = TODAY
             gn-clie.usrAut = S-USER-ID.
         /* RHC 05.10.04 Historico de lineas de credito */
         CREATE LogTabla.
         ASSIGN
             logtabla.codcia = s-codcia
             logtabla.Dia = TODAY
             logtabla.Evento = 'LINEA-CREDITO-A'
             logtabla.Hora = STRING(TIME, 'HH:MM')
             logtabla.Tabla = 'GN-CLIE'
             logtabla.Usuario = s-user-id
             logtabla.ValorLlave = STRING(gn-clie.codcli, 'x(11)') + '|' +
             STRING(gn-clie.nomcli, 'x(50)') + '|' +
             STRING(gn-clie.FlagAut, 'X').
         RELEASE LogTabla.
     END.
  END.
  ELSE cEvento = "WRITE".
  ASSIGN
      gn-clie.nomcli  = gn-clie.nomcli:SCREEN-VALUE IN FRAME {&FRAME-NAME}
      gn-clie.usuario = s-user-id
      gn-clie.fchact = TODAY.
  IF gn-clie.Flgsit = 'C'
  THEN gn-clie.fchces = TODAY.
  ELSE gn-clie.fchces = ?.

  /* RHC 25.10.04 Historico */
  RUN lib/logtabla ("gn-clie", STRING(gn-clie.codcia, '999') + '|' +
                    STRING(gn-clie.codcli, 'x(11)'), cEvento).

/*   CREATE LogTabla.                                              */
/*   ASSIGN                                                        */
/*     logtabla.codcia = s-codcia                                  */
/*     logtabla.Dia = TODAY                                        */
/*     logtabla.Evento = 'WRITE'                                   */
/*     logtabla.Hora = STRING(TIME, 'HH:MM')                       */
/*     logtabla.Tabla = 'GN-CLIE'                                  */
/*     logtabla.Usuario = s-user-id                                */
/*     logtabla.ValorLlave = STRING(gn-clie.codcia, '999') + '|' + */
/*                             STRING(gn-clie.codcli, 'x(11)').    */
/*   RELEASE LogTabla.                                             */
   
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
  RUN Procesa-Handle IN lh_handle ('1').

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
  /* RHC 02.09.09 Rutina en el Trigger */
/*   FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia                     */
/*     AND Ccbcdocu.codcli = gn-clie.codcli NO-LOCK NO-ERROR.                 */
/*   IF AVAILABLE Ccbcdocu THEN DO:                                           */
/*     MESSAGE 'Este cliente tiene historial de créditos, no se puede anular' */
/*         VIEW-AS ALERT-BOX ERROR.                                           */
/*     RETURN 'ADM-ERROR'.                                                    */
/*   END.                                                                     */
/*   FOR EACH Gn-CLieB OF Gn-Clie:                                            */
/*     DELETE Gn-ClieB.                                                       */
/*   END.                                                                     */
/*   FOR EACH Gn-CLieD OF Gn-Clie:                                            */
/*     DELETE Gn-ClieD.                                                       */
/*   END.                                                                     */
/*   FOR EACH Gn-CLieL OF Gn-Clie:                                            */
/*     DELETE Gn-ClieL.                                                       */
/*   END.                                                                     */


/*RDP 27.05.10 No se puede eliminar registro 
  /* RHC 25.10.04 Historico */
  CREATE LogTabla.
  ASSIGN
    logtabla.codcia = s-codcia
    logtabla.Dia = TODAY
    logtabla.Evento = 'DELETE'
    logtabla.Hora = STRING(TIME, 'HH:MM')
    logtabla.Tabla = 'GN-CLIE'
    logtabla.Usuario = s-user-id
    logtabla.ValorLlave = STRING(gn-clie.codcia, '999') + '|' +
                            STRING(gn-clie.codcli, 'x(11)').
  RELEASE LogTabla. 
*/
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */


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
      BUTTON-1:SENSITIVE = NO.
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
  DEF VAR k AS INT NO-UNDO.
  DEF VAR i AS INT INIT 1 NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Gn-clie THEN DO WITH frame {&FRAME-NAME}:
    FIND  TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
    IF AVAILABLE TabDepto THEN DISPLAY TabDepto.NomDepto @ fill-in-dep.
   
    FIND  Tabprovi WHERE Tabprovi.CodDepto = gn-clie.CodDept 
                    AND  Tabprovi.Codprovi = gn-clie.codprov 
                   NO-LOCK NO-ERROR.
    IF AVAILABLE Tabprovi THEN DISPLAY Tabprovi.Nomprovi @ fill-in-prov.
   
    FIND  Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept 
                    AND  Tabdistr.Codprovi = gn-clie.codprov 
                    AND  Tabdistr.Coddistr = gn-clie.coddist 
                   NO-LOCK NO-ERROR.
    IF AVAILABLE Tabdistr THEN DISPLAY Tabdistr.Nomdistr @ fill-in-dis.

    FIND almtabla WHERE almtabla.Tabla = 'CP' 
                   AND  almtabla.Codigo = gn-clie.CodPos  
                  NO-LOCK NO-ERROR.
    IF AVAILABLE  almtabla THEN DISPLAY almtabla.nombre @ FILL-IN-POS.
        
    FIND almtabla WHERE almtabla.Tabla = 'GN' 
                   AND  almtabla.Codigo = gn-clie.GirCli 
                  NO-LOCK NO-ERROR.
    IF AVAILABLE  almtabla THEN DISPLAY almtabla.nombre @ f-giro.
       
    FIND gn-ven WHERE gn-ven.codcia = s-codcia
        AND gn-ven.CodVen = gn-clie.CodVen NO-LOCK NO-ERROR.
    IF AVAILABLE  gn-ven THEN DISPLAY gn-ven.NomVen @ f-NomVen.
       
/*     FIND gn-convt WHERE gn-convt.Codig = gn-clie.CndVta NO-LOCK NO-ERROR. */
/*     IF AVAILABLE  gn-convt THEN DISPLAY gn-ConVt.Nombr @ f-ConVta.        */
  DO k = 1 TO NUM-ENTRIES(gn-clie.cndvta):
      FIND gn-convt WHERE gn-convt.codig = ENTRY(k, gn-clie.cndvta) NO-LOCK NO-ERROR.
      IF AVAILABLE gn-convt THEN DO:
          IF i = 1 
          THEN ASSIGN
                  f-convta:SCREEN-VALUE = TRIM(gn-convt.nombr).
          ELSE ASSIGN
                  f-convta:SCREEN-VALUE = f-convta:SCREEN-VALUE + ',' + TRIM(gn-convt.nombr).
          i = i + 1.
      END.
  END.
    FIND almtabla WHERE almtabla.Tabla = 'CN' 
                   AND  almtabla.Codigo = gn-clie.Canal 
                  NO-LOCK NO-ERROR.
    IF AVAILABLE  almtabla THEN DISPLAY almtabla.nombre @ f-canal.

    FILL-IN-NomCli:SCREEN-VALUE = ''.
    IF gn-clie.nrocard <> ''
    THEN DO:
        FIND gn-card WHERE gn-card.nrocard = gn-clie.nrocard
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-card THEN FILL-IN-NomCli:SCREEN-VALUE = gn-card.nomcard.
    END.

    ASSIGN
        f-ClfCli = 'SIN CLASIFICACION'
        f-ClfCli2 = 'SIN CLASIFICACION'.
    FIND ClfClie WHERE ClfClie.Categoria = gn-clie.clfCli NO-LOCK NO-ERROR.
    IF AVAILABLE ClfClie THEN f-ClfCli:SCREEN-VALUE = ClfClie.DesCat.
    FIND ClfClie WHERE ClfClie.Categoria = gn-clie.clfCli2 NO-LOCK NO-ERROR.
    IF AVAILABLE ClfClie THEN f-ClfCli2:SCREEN-VALUE = ClfClie.DesCat.
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
          /* Niveles de acceso (s-nivel-acceso):
          0: sin acceso
          1: acceso total
          2: acceso administrador Lima
          3: acceso administrador Utilex
          4: acceso solo direccion y vendedor
          */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          gn-clie.clfCli:SENSITIVE = NO
          gn-clie.ClfCli2:SENSITIVE = NO.
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      CASE RETURN-VALUE:
          WHEN 'YES' THEN DO:
              /* Solo si es un cliente NUEVO Institucionales */
              IF s-CodDiv = '00024' THEN DO:
                  ASSIGN gn-clie.CodDiv:SENSITIVE = NO.
              END.
          END.
          WHEN 'NO' THEN DO:
              gn-clie.CodCli:SENSITIVE = NO.
              /* control de acceso */
              gn-clie.CndVta:SENSITIVE = NO.
              gn-clie.NomCli:SENSITIVE = NO.
              gn-clie.LocCli:SENSITIVE = NO.
              IF gn-clie.Libre_C01 <> "N" 
                  THEN ASSIGN
                  gn-clie.ApeMat:SENSITIVE = NO
                  gn-clie.ApePat:SENSITIVE = NO
                  gn-clie.Nombre:SENSITIVE = YES.
              ELSE ASSIGN
                  gn-clie.ApeMat:SENSITIVE = YES
                  gn-clie.ApePat:SENSITIVE = YES
                  gn-clie.Nombre:SENSITIVE = YES.
              CASE s-nivel-acceso:
                  WHEN 1 THEN DO:
                      BUTTON-1:SENSITIVE = YES.
                      gn-clie.LocCli:SENSITIVE = YES.
                  END.
                  WHEN 2 THEN DO:
                      ASSIGN
                          gn-clie.clfCli:SENSITIVE = NO
                          gn-clie.ClfCli2:SENSITIVE = NO
                          gn-clie.flgsit:SENSITIVE = NO
                          gn-clie.CodUnico:SENSITIVE = NO
                          gn-clie.codven:SENSITIVE = NO
                          gn-clie.coddiv:SENSITIVE = NO
                          /*gn-clie.gircli:SENSITIVE = NO*/
                          BUTTON-1:SENSITIVE = YES.
                  END.
                  WHEN 3 THEN DO:
                      ASSIGN
                          gn-clie.clfCli:SENSITIVE = NO
                          gn-clie.ClfCli2:SENSITIVE = NO
                          gn-clie.flgsit:SENSITIVE = NO
                          gn-clie.clfcli:SENSITIVE = NO
                          gn-clie.CodUnico:SENSITIVE = NO
                          gn-clie.codven:SENSITIVE = NO
                          gn-clie.coddiv:SENSITIVE = NO
                          gn-clie.canal:SENSITIVE = NO
                          gn-clie.gircli:SENSITIVE = NO.
                  END.
                  WHEN 4 THEN DO:
                      RUN dispatch IN THIS-PROCEDURE ('disable-fields':U).
                      ASSIGN
                          gn-clie.CodDiv:SENSITIVE = YES
                          gn-clie.CodVen:SENSITIVE = YES
                          gn-clie.DirCli:SENSITIVE = YES
                          gn-clie.Nombre:SENSITIVE = NO
                          gn-clie.CodDept:SENSITIVE = YES
                          gn-clie.CodProv:SENSITIVE = YES
                          gn-clie.CodDist:SENSITIVE = YES
                          gn-clie.Canal:SENSITIVE = YES
                          .
                  END.
              END CASE.
              /* RHC 14-09-2012 BLOQUEAMOS CLIENTES GENÉRICOS */
              IF s-user-id <> "ADMIN" AND gn-clie.codcli BEGINS "1111111111"
                  THEN ASSIGN
                  gn-clie.ApeMat:SENSITIVE = NO
                  gn-clie.ApePat:SENSITIVE = NO
                  gn-clie.Nombre:SENSITIVE = NO
                  gn-clie.NomCli:SENSITIVE = NO.
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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RB-FILTER = "Gn-clie.CodCia = " + STRING(CL-CODCIA) +
                " AND Gn-clie.codcli = '" + Gn-clie.codcli + "'". 

  RB-OTHER-PARAMETERS = "GsNomCia = " + S-NOMCIA.
                            
  RUN lib\_imprime (RB-REPORT-LIBRARY, RB-REPORT-NAME,
        RB-INCLUDE-RECORDS, RB-FILTER, RB-OTHER-PARAMETERS).                            

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

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('1').

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

    DO with frame {&FRAME-NAME} :    
     CASE HANDLE-CAMPO:name:
        WHEN "CodPais" THEN ASSIGN input-var-1 = "PA".
        WHEN "GirCli" THEN ASSIGN input-var-1 = "GN".
        WHEN "CodPos" THEN ASSIGN input-var-1 = "CP".
        WHEN "CodProv" THEN ASSIGN input-var-1 = gn-clie.CodDept:screen-value.
        WHEN "TpoCli" THEN ASSIGN input-var-1 = "TC".
        WHEN "Canal" THEN ASSIGN input-var-1 = "CN".
        WHEN "Clfcom" THEN ASSIGN input-var-1 = "CM".
        WHEN "CndVta" THEN ASSIGN input-var-1 = "".
        WHEN "CodDist" THEN DO:
               input-var-1 = gn-clie.CodDept:screen-value.
               input-var-2 = GN-clie.CodProv:screen-value.
          END.
     END CASE.
    END.

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
  {src/adm/template/snd-list.i "gn-clie"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     Validacion de datos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME} :
    IF gn-clie.CodCli:SCREEN-VALUE = "" THEN DO:
       MESSAGE "Codigo no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO gn-clie.CodCli.
       RETURN "ADM-ERROR".   
    END.
    FIND GN-DIVI WHERE GN-DIVI.codcia = s-codcia
        AND GN-DIVI.coddiv = gn-clie.CodDiv:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE GN-DIVI
    THEN DO:
        MESSAGE 'Division no registrada' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO gn-clie.coddiv.
        RETURN 'ADM-ERROR'.
    END.        
    IF gn-clie.CodDept:SCREEN-VALUE <> "" THEN DO:
        FIND  TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF NOT AVAILABLE TabDepto 
        THEN DO:
            MESSAGE 'Departamento no registrado' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-clie.CodDept.
            RETURN 'ADM-ERROR'.
        END.
    END.
    IF gn-clie.CodProv:SCREEN-VALUE <> "" THEN DO:
        FIND  Tabprovi WHERE Tabprovi.CodDepto = gn-clie.CodDept:screen-value 
            AND Tabprovi.Codprovi = gn-clie.CodProv:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Tabprovi 
        THEN DO:
            MESSAGE 'Provincia no registrada' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-clie.CodProv.
            RETURN 'ADM-ERROR'.
        END.
    END.
    IF gn-clie.CodDist:SCREEN-VALUE <> "" THEN DO:
        FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept:screen-value 
            AND Tabdistr.Codprovi = gn-clie.codprov:screen-value 
            AND Tabdistr.Coddistr = gn-clie.CodDist:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Tabdistr 
        THEN DO:
            MESSAGE 'Distrito no registrado' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-clie.CodDist.
            RETURN 'ADM-ERROR'.
        END.
    END.  

    /* PARCHE TEMPORAL 07/06/2014 */
    /*IF s-nivel-acceso = 3 THEN RETURN 'OK'.*/



    IF gn-clie.Canal:SCREEN-VALUE = '' THEN DO:
         MESSAGE 'Debe ingresar el Canal' VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY":U TO gn-clie.canal.
         RETURN "ADM-ERROR".
    END.
    IF gn-clie.NroCard:SCREEN-VALUE <> ''
    THEN DO:
        FIND GN-CARD WHERE gn-card.nrocard = gn-clie.NroCard:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-card 
        THEN DO:
            MESSAGE 'Numero de Tarjeta no registrado'
                VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-clie.nrocard.
            RETURN 'ADM-ERROR'.
        END.
    END.
    IF gn-clie.CodVen:SCREEN-VALUE <> "" THEN DO:
        FIND gn-ven WHERE gn-ven.codcia = s-codcia
            AND gn-ven.CodVen = gn-clie.CodVen:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-ven 
        THEN DO:
            MESSAGE 'Vendedor no registrado' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-clie.CodVen.
            RETURN 'ADM-ERROR'.
        END.
    END.
    IF gn-clie.clfCli:SCREEN-VALUE <> ''
    THEN DO:
        FIND ClfClie WHERE ClfClie.Categoria = gn-clie.clfCli:SCREEN-VALUE 
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ClfClie
        THEN DO:
            MESSAGE 'La clasificacion del cliente esta errada'
                VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-clie.ClfCli.
            RETURN 'ADM-ERROR'.
        END.
    END.
    IF gn-clie.GirCli:SCREEN-VALUE <> '' THEN DO:
        FIND almtabla WHERE almtabla.Tabla = 'GN' 
            AND almtabla.Codigo = gn-clie.GirCli:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almtabla
        THEN DO:
            MESSAGE 'El giro del cliente no registrado' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-clie.GirCli.
            RETURN 'ADM-ERROR'.
        END.
    END.

    IF gn-clie.codunico:SCREEN-VALUE <> '' 
            AND gn-clie.codunico:SCREEN-VALUE <> gn-clie.codcli:SCREEN-VALUE  THEN DO:
        IF NOT CAN-FIND(FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
                        AND gn-clie.codunico = gn-clie.codunico:SCREEN-VALUE NO-LOCK)
        THEN DO:
            MESSAGE 'Error en el código agrupador' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-clie.CodUnico.
            RETURN 'ADM-ERROR'.
        END.
    END.
    
    DEF VAR pResultado AS CHAR.
    CASE TRUE:
        WHEN gn-clie.Libre_C01:SCREEN-VALUE = "J" THEN DO:
            IF LENGTH(gn-clie.Ruc:SCREEN-VALUE) < 11 
                OR LOOKUP(SUBSTRING(gn-clie.Ruc:SCREEN-VALUE,1,2), '20') = 0 THEN DO:
                MESSAGE 'Debe tener 11 dígitos y comenzar con 20' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO gn-clie.Ruc.
                RETURN 'ADM-ERROR'.
            END.
            /* dígito verificador */
            RUN lib/_ValRuc (gn-clie.Ruc:SCREEN-VALUE, OUTPUT pResultado).
            IF pResultado = 'ERROR' THEN DO:
                MESSAGE 'Código MAL registrado' VIEW-AS ALERT-BOX WARNING.
                APPLY 'ENTRY':U TO gn-clie.Ruc.
                RETURN 'ADM-ERROR'.
            END.
        END.
        WHEN gn-clie.Libre_C01:SCREEN-VALUE = "E" THEN DO:
            IF LENGTH(gn-clie.Ruc:SCREEN-VALUE) < 11 
                OR LOOKUP(SUBSTRING(gn-clie.Ruc:SCREEN-VALUE,1,2), '15,17') = 0 THEN DO:
                MESSAGE 'Debe tener 11 dígitos y comenzar con 15 ó 17' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO gn-clie.Ruc.
                RETURN 'ADM-ERROR'.
            END.
            /* dígito verificador */
            RUN lib/_ValRuc (gn-clie.Ruc:SCREEN-VALUE, OUTPUT pResultado).
            IF pResultado = 'ERROR' THEN DO:
                MESSAGE 'Código MAL registrado' VIEW-AS ALERT-BOX WARNING.
                APPLY 'ENTRY':U TO gn-clie.Ruc.
                RETURN 'ADM-ERROR'.
            END.
        END.
        WHEN gn-clie.Libre_C01:SCREEN-VALUE = "N" THEN DO:
            IF gn-clie.Ruc:SCREEN-VALUE > '' THEN DO:
                IF LENGTH(gn-clie.Ruc:SCREEN-VALUE) < 11 OR LOOKUP(SUBSTRING(gn-clie.Ruc:SCREEN-VALUE,1,2), '10') = 0 THEN DO:
                    MESSAGE 'Debe tener 11 dígitos y comenzar con 10' VIEW-AS ALERT-BOX ERROR.
                    APPLY 'ENTRY':U TO gn-clie.Ruc.
                    RETURN 'ADM-ERROR'.
                END.
                /* dígito verificador */
                RUN lib/_ValRuc (gn-clie.Ruc:SCREEN-VALUE, OUTPUT pResultado).
                IF pResultado = 'ERROR' THEN DO:
                    MESSAGE 'Código MAL registrado' VIEW-AS ALERT-BOX WARNING.
                    APPLY 'ENTRY':U TO gn-clie.Ruc.
                    RETURN 'ADM-ERROR'.
                END.
            END.
            IF TRUE <> (gn-clie.Dni:SCREEN-VALUE > '') OR LENGTH(gn-clie.Dni:SCREEN-VALUE) <> 8
                THEN DO:
                MESSAGE 'Ingrese un DNI válido de 8 caracteres' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO gn-clie.Dni.
                RETURN 'ADM-ERROR'.
            END.
        END.
    END CASE.
    IF gn-clie.Libre_C01:SCREEN-VALUE = "N" THEN DO:
        IF (gn-clie.ApeMat:SCREEN-VALUE = ''
            OR gn-clie.ApePat:SCREEN-VALUE = ''
            OR gn-clie.Nombre:SCREEN-VALUE = '')
            THEN DO:
            MESSAGE 'Ingrese Apellidos y Nombres completos' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-clie.ApePat.
            RETURN 'ADM-ERROR'.
        END.
    END.
    ELSE DO:
        IF gn-clie.Nombre:SCREEN-VALUE = '' THEN DO:
            MESSAGE 'Ingrese la Razón Social' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-clie.Nombre.
            RETURN 'ADM-ERROR'.
        END.
    END.
  END.

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

  RUN Procesa-Handle IN lh_handle ('0').

  IF s-nivel-acceso = 0 THEN DO:
      MESSAGE "Usted no tiene acceso para MODIFICAR" SKIP
              "     Consulte a Administrador       "
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN "ADM-ERROR".
  END.
  RETURN "OK".

/*   DEF VAR k AS INT NO-UNDO.                                                                              */
/*   DEF VAR x-Grupos AS CHAR INIT 'Gerente General,Gerente Comercial,Asistente de Gerencia 2,S00' NO-UNDO. */
/*                                                                                                          */
/*   DO k = 1 TO NUM-ENTRIES(x-Grupos):                                                                     */
/*       IF LOOKUP(ENTRY(k,x-Grupos),s-Seguridad) > 0 THEN RETURN 'OK'.                                     */
/*   END.                                                                                                   */
/*   MESSAGE "Usted no tiene acceso para MODIFICAR" VIEW-AS ALERT-BOX INFO BUTTONS OK.                      */
/*   RETURN "ADM-ERROR".                                                                                    */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

