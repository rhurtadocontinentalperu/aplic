&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
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

DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR CL-CODCIA AS INTEGER.

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

/*variables locales */
define var s-almacen as character.

/* Local Variable Definitions ---                                       */

DEFINE SHARED VARIABLE  S-CODCIA AS INTEGER.
/* DEFINE VARIABLE cl-codcia  AS INTEGER INITIAL 0 NO-UNDO.  */
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

FIND Empresas WHERE Empresas.CodCia = S-CODCIA NO-LOCK NO-ERROR.
/* IF NOT Empresas.Campo-CodCli THEN cl-codcia = S-CODCIA. */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES gn-clie
&Scoped-define FIRST-EXTERNAL-TABLE gn-clie


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR gn-clie.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS gn-clie.CodCli gn-clie.Ruc gn-clie.NomCli ~
gn-clie.DirCli gn-clie.DirEnt gn-clie.E-Mail gn-clie.CodDept ~
gn-clie.CodProv gn-clie.CodDist gn-clie.Codpos gn-clie.Contac ~
gn-clie.Telfnos[1] gn-clie.Telfnos[2] gn-clie.Telfnos[3] gn-clie.FaxCli ~
gn-clie.FchAct gn-clie.FchCes gn-clie.clfCli gn-clie.GirCli gn-clie.CndVta ~
gn-clie.CodVen gn-clie.Referencias gn-clie.RepLeg[1] gn-clie.RepLeg[2] ~
gn-clie.RepLeg[3] gn-clie.RepLeg[4] gn-clie.RepLeg[5] gn-clie.RepLeg[6] ~
gn-clie.FNRepr gn-clie.Transporte[2] gn-clie.Transporte[3] 
&Scoped-define ENABLED-TABLES gn-clie
&Scoped-define FIRST-ENABLED-TABLE gn-clie
&Scoped-Define ENABLED-OBJECTS RECT-22 RECT-23 RECT-24 RECT-26 RECT-27 
&Scoped-Define DISPLAYED-FIELDS gn-clie.CodCli gn-clie.CodDiv gn-clie.Ruc ~
gn-clie.NomCli gn-clie.DirCli gn-clie.DirEnt gn-clie.E-Mail gn-clie.CodDept ~
gn-clie.CodProv gn-clie.CodDist gn-clie.Codpos gn-clie.Contac ~
gn-clie.Telfnos[1] gn-clie.Telfnos[2] gn-clie.Telfnos[3] gn-clie.FaxCli ~
gn-clie.Fching gn-clie.FchAct gn-clie.FchCes gn-clie.clfCli gn-clie.Flgsit ~
gn-clie.GirCli gn-clie.CndVta gn-clie.CodVen gn-clie.TpoCli ~
gn-clie.Referencias gn-clie.RepLeg[1] gn-clie.RepLeg[2] gn-clie.RepLeg[3] ~
gn-clie.RepLeg[4] gn-clie.RepLeg[5] gn-clie.RepLeg[6] gn-clie.FNRepr ~
gn-clie.Transporte[2] gn-clie.Transporte[3] 
&Scoped-define DISPLAYED-TABLES gn-clie
&Scoped-define FIRST-DISPLAYED-TABLE gn-clie
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-DEP FILL-IN-PROV FILL-IN-DIS ~
FILL-IN-POS f-Giro f-ConVta F-NomVen 

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
DEFINE VARIABLE f-ConVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 21.57 BY .69 NO-UNDO.

DEFINE VARIABLE f-Giro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 21.57 BY .69 NO-UNDO.

DEFINE VARIABLE F-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 21.57 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-DEP AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-DIS AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-POS AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-PROV AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 1.88.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 2.62.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 6.77.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 2.92.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 15.57 BY 2.23.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     gn-clie.CodCli AT ROW 1.19 COL 10.72 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     gn-clie.CodDiv AT ROW 6.88 COL 10.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.29 BY .69
     gn-clie.Ruc AT ROW 1.88 COL 70.14 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
          FGCOLOR 12 
     gn-clie.NomCli AT ROW 1.19 COL 22 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 38.14 BY .69
     gn-clie.DirCli AT ROW 1.88 COL 10.72 COLON-ALIGNED
          LABEL "Direccion Legal"
          VIEW-AS FILL-IN 
          SIZE 49.57 BY .69
     gn-clie.DirEnt AT ROW 14.23 COL 16.14 COLON-ALIGNED
          LABEL "Direccion  Entrega"
          VIEW-AS FILL-IN 
          SIZE 48.86 BY .65
     gn-clie.E-Mail AT ROW 2.69 COL 10.72 COLON-ALIGNED FORMAT "X(50)"
          VIEW-AS FILL-IN 
          SIZE 49.43 BY .69
          BGCOLOR 8 FGCOLOR 9 
     FILL-IN-DEP AT ROW 3.38 COL 17 COLON-ALIGNED NO-LABEL
     gn-clie.CodDept AT ROW 3.38 COL 10.72 COLON-ALIGNED
          LABEL "Departamento" FORMAT "X(2)"
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .69
     gn-clie.CodProv AT ROW 4.08 COL 10.72 COLON-ALIGNED
          LABEL "Provincia" FORMAT "X(2)"
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .69
     gn-clie.CodDist AT ROW 4.77 COL 10.72 COLON-ALIGNED FORMAT "X(2)"
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .69
     gn-clie.Codpos AT ROW 5.5 COL 10.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .69
     gn-clie.Contac AT ROW 6.19 COL 10.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 36.72 BY .69
     FILL-IN-PROV AT ROW 4.08 COL 17 COLON-ALIGNED NO-LABEL
     gn-clie.Telfnos[1] AT ROW 3.38 COL 47.14 COLON-ALIGNED
          LABEL "Telef1"
          VIEW-AS FILL-IN 
          SIZE 13 BY .69
          FGCOLOR 0 
     gn-clie.Telfnos[2] AT ROW 4.08 COL 47.14 COLON-ALIGNED
          LABEL "Telef2"
          VIEW-AS FILL-IN 
          SIZE 13 BY .69
     gn-clie.Telfnos[3] AT ROW 4.77 COL 47.14 COLON-ALIGNED
          LABEL "Telef3"
          VIEW-AS FILL-IN 
          SIZE 13 BY .69
     gn-clie.FaxCli AT ROW 5.5 COL 47.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .69
     gn-clie.Fching AT ROW 2.69 COL 70.14 COLON-ALIGNED
          LABEL "Ingreso"
          VIEW-AS FILL-IN 
          SIZE 10.86 BY .69
     gn-clie.FchAct AT ROW 3.38 COL 70.14 COLON-ALIGNED
          LABEL "Actualizacion"
          VIEW-AS FILL-IN 
          SIZE 10.86 BY .69
     gn-clie.FchCes AT ROW 4.08 COL 70.14 COLON-ALIGNED
          LABEL "Cese"
          VIEW-AS FILL-IN 
          SIZE 10.86 BY .69
     gn-clie.clfCli AT ROW 6.19 COL 61
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "","A","B","C","D" 
          DROP-DOWN-LIST
          SIZE 4.86 BY 1
          FGCOLOR 12 
     gn-clie.Flgsit AT ROW 1.19 COL 66.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Activo", "A":U,
"Cesado", "C":U
          SIZE 20.43 BY .58
     FILL-IN-DIS AT ROW 4.77 COL 17 COLON-ALIGNED NO-LABEL
     FILL-IN-POS AT ROW 5.5 COL 17 COLON-ALIGNED NO-LABEL
     f-Giro AT ROW 8.27 COL 17 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     gn-clie.GirCli AT ROW 8.27 COL 10 COLON-ALIGNED
          LABEL "Giro" FORMAT "X(4)"
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .69
     gn-clie.CndVta AT ROW 8.96 COL 10 COLON-ALIGNED
          LABEL "Cond. Venta" FORMAT "X(4)"
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .69
     gn-clie.CodVen AT ROW 9.69 COL 10 COLON-ALIGNED
          LABEL "Vendedor"
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .69
     gn-clie.TpoCli AT ROW 8.42 COL 44.14 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Minorista", "1":U,
"Mayorista", "2":U,
"Distribuidor", "3":U,
"Publico", "4":U
          SIZE 12 BY 2.08
     gn-clie.Referencias AT ROW 8.31 COL 58 NO-LABEL
          VIEW-AS EDITOR LARGE
          SIZE 29.29 BY 2.27
     f-ConVta AT ROW 8.96 COL 17 COLON-ALIGNED NO-LABEL
     F-NomVen AT ROW 9.69 COL 17 COLON-ALIGNED NO-LABEL
     gn-clie.RepLeg[1] AT ROW 10.96 COL 16 COLON-ALIGNED
          LABEL "Nombre y Apellido"
          VIEW-AS FILL-IN 
          SIZE 43 BY .69
     gn-clie.RepLeg[2] AT ROW 10.96 COL 71 COLON-ALIGNED
          LABEL "L.E."
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .69
     gn-clie.RepLeg[3] AT ROW 11.65 COL 71 COLON-ALIGNED
          LABEL "Ruc" FORMAT "X(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     gn-clie.RepLeg[4] AT ROW 11.65 COL 16 COLON-ALIGNED
          LABEL "Direccion Domicilio"
          VIEW-AS FILL-IN 
          SIZE 43 BY .69
     gn-clie.RepLeg[5] AT ROW 12.35 COL 16 COLON-ALIGNED
          LABEL "Telefono"
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .69
     gn-clie.RepLeg[6] AT ROW 12.35 COL 38.14 COLON-ALIGNED
          LABEL "Telefono"
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .69
     gn-clie.FNRepr AT ROW 12.35 COL 71 COLON-ALIGNED
          LABEL "Fch.Nac."
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .69
     gn-clie.Transporte[2] AT ROW 13.5 COL 16 COLON-ALIGNED
          LABEL "RUC" FORMAT "X(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     gn-clie.Transporte[3] AT ROW 13.5 COL 41 COLON-ALIGNED
          LABEL "Razon Social" FORMAT "X(50)"
          VIEW-AS FILL-IN 
          SIZE 43 BY .69
     "Tipo Cliente" VIEW-AS TEXT
          SIZE 10 BY .42 AT ROW 7.85 COL 41.72
          BGCOLOR 1 FGCOLOR 15 
     "Observaciones" VIEW-AS TEXT
          SIZE 12.14 BY .5 AT ROW 7.88 COL 58.14
          BGCOLOR 1 FGCOLOR 15 
     "Representante Legal" VIEW-AS TEXT
          SIZE 15.14 BY .5 AT ROW 10.58 COL 1
          BGCOLOR 1 FGCOLOR 15 
     "Empresa  de Transporte" VIEW-AS TEXT
          SIZE 16.57 BY .5 AT ROW 13.23 COL 1
          BGCOLOR 1 FGCOLOR 15 
     "A-BUENO" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 5.5 COL 75.57
     "B-REG/BUENO" VIEW-AS TEXT
          SIZE 11.14 BY .5 AT ROW 6.04 COL 75.57
     "C-REG/MALO" VIEW-AS TEXT
          SIZE 9.72 BY .5 AT ROW 6.62 COL 75.57
     "D-MALO" VIEW-AS TEXT
          SIZE 9.72 BY .5 AT ROW 7.15 COL 75.57
     RECT-22 AT ROW 13.23 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     RECT-23 AT ROW 10.62 COL 1
     RECT-24 AT ROW 1 COL 1
     RECT-26 AT ROW 7.77 COL 1
     RECT-27 AT ROW 8.35 COL 41.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.gn-clie
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 14.15
         WIDTH              = 87.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX gn-clie.clfCli IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN gn-clie.CndVta IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.CodCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN gn-clie.CodDept IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.CodDist IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN gn-clie.CodDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.CodProv IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.CodVen IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.DirCli IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.DirEnt IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.E-Mail IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN f-ConVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-Giro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.FchAct IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.FchCes IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.Fching IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FILL-IN-DEP IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DIS IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-POS IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-PROV IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET gn-clie.Flgsit IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.FNRepr IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.GirCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.NomCli IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.RepLeg[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.RepLeg[2] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.RepLeg[3] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.RepLeg[4] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.RepLeg[5] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.RepLeg[6] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.Ruc IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN gn-clie.Telfnos[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.Telfnos[2] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.Telfnos[3] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR RADIO-SET gn-clie.TpoCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.Transporte[2] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.Transporte[3] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
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

&Scoped-define SELF-NAME gn-clie.CndVta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.CndVta V-table-Win
ON LEAVE OF gn-clie.CndVta IN FRAME F-Main /* Cond. Venta */
DO:
   IF gn-clie.CndVta:screen-value <> "" THEN DO:
     FIND gn-convt WHERE gn-convt.Codig = gn-clie.CndVta:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt THEN 
        F-ConVta:screen-value = gn-convt.Nombr.
     ELSE 
        F-Convta:screen-value = "".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.CodCli V-table-Win
ON LEAVE OF gn-clie.CodCli IN FRAME F-Main /* Codigo */
DO:
   FIND gn-Clie WHERE Gn-Clie.Codcli = gn-Clie.Codcli:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF AVAILABLE GN-CLIE THEN DO:
      message "Código de Cliente YA EXISTE" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.CodDept
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.CodDept V-table-Win
ON LEAVE OF gn-clie.CodDept IN FRAME F-Main /* Departamento */
DO:
  IF gn-clie.coddept:screen-value <> "" THEN DO:
    FIND  TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept:screen-value NO-LOCK NO-ERROR.
    IF AVAILABLE TabDepto THEN
        Fill-in-dep:screen-value = TabDepto.NomDepto.
    ELSE 
        Fill-in-dep:screen-value = "".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.CodDist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.CodDist V-table-Win
ON LEAVE OF gn-clie.CodDist IN FRAME F-Main /* Distrito */
DO:
  IF gn-clie.coddist:screen-value <> "" THEN DO:
  FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept:screen-value AND
                       Tabdistr.Codprovi = gn-clie.codprov:screen-value AND
                       Tabdistr.Coddistr = gn-clie.coddist:screen-value NO-LOCK NO-ERROR.
    IF AVAILABLE Tabdistr THEN 
        Fill-in-dis:screen-value = Tabdistr.Nomdistr .
    ELSE
        Fill-in-dis:screen-value = "".
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.Codpos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.Codpos V-table-Win
ON LEAVE OF gn-clie.Codpos IN FRAME F-Main /* Postal */
DO:
  IF gn-clie.CodPos:screen-value <> "" THEN DO:
      FIND almtabla WHERE almtabla.Tabla = 'CP' AND almtabla.Codigo = integral.gn-clie.CodPos:screen-value NO-LOCK NO-ERROR.
      IF AVAILABLE almtabla THEN 
         FILL-IN-POS:screen-value = almtabla.nombre.
      ELSE 
         FILL-IN-POS:screen-value = "".
  END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.CodProv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.CodProv V-table-Win
ON LEAVE OF gn-clie.CodProv IN FRAME F-Main /* Provincia */
DO:
   IF gn-clie.codprov:screen-value <> "" THEN DO:
    FIND  Tabprovi WHERE Tabprovi.CodDepto = gn-clie.CodDept:screen-value AND
    Tabprovi.Codprovi = gn-clie.codprov:screen-value NO-LOCK NO-ERROR.
    IF AVAILABLE Tabprovi THEN 
        fill-in-prov:screen-value = Tabprovi.Nomprovi.
    ELSE
        fill-in-prov:screen-value = "".
   
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.CodVen V-table-Win
ON LEAVE OF gn-clie.CodVen IN FRAME F-Main /* Vendedor */
DO:
   IF gn-clie.CodVen:screen-value <> "" THEN DO:
     FIND gn-ven WHERE gn-ven.CodVen = gn-clie.CodVen:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN 
        F-NomVen:screen-value = gn-ven.NomVen.
     ELSE 
        F-NomVen:screen-value = "".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.GirCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.GirCli V-table-Win
ON LEAVE OF gn-clie.GirCli IN FRAME F-Main /* Giro */
DO:
  IF gn-clie.GirCli:screen-value <> "" THEN DO:
     FIND almtabla WHERE almtabla.Tabla = 'GN' AND almtabla.Codigo = integral.gn-clie.GirCli:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE almtabla THEN 
        F-Giro:screen-value = almtabla.nombre.
     ELSE 
        F-Giro:screen-value = "".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.Transporte[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.Transporte[2] V-table-Win
ON LEAVE OF gn-clie.Transporte[2] IN FRAME F-Main /* RUC */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND AdmRutas WHERE AdmRutas.CodPro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE AdmRutas THEN DO: 
     MESSAGE "RUC no registrado" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  FIND gn-prov WHERE gn-Prov.CodCia = pv-codcia AND
       gn-prov.CodPro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN DO WITH FRAME {&FRAME-NAME}:
     DISPLAY  gn-prov.Nompro @ integral.gn-clie.Transporte[3] .
              
  END.
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
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY @ gn-clie.Fching.
  END.
  /* Code placed here will execute AFTER standard behavior.    */

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  RUN get-attribute("ADM-NEW-RECORD").
  IF RETURN-VALUE = "YES" THEN DO:
     ASSIGN gn-clie.CodCia = CL-CODCIA
            gn-clie.CodDiv = S-CODDIV
            integral.gn-clie.Fching = TODAY.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
   
  IF AVAILABLE Gn-clie THEN DO WITH frame {&FRAME-NAME}:
           
/*  FIND almtabla WHERE almtabla.Tabla = 'PA' AND almtabla.Codigo = integral.gn-clie.CodPais  NO-LOCK NO-ERROR.
    IF AVAILABLE  almtabla THEN 
       DISPLAY almtabla.nombre @ FILL-IN-PAIS.
*/       
    FIND  TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
    IF AVAILABLE TabDepto THEN 
     DISPLAY TabDepto.NomDepto @ fill-in-dep.
   
    FIND  Tabprovi WHERE Tabprovi.CodDepto = gn-clie.CodDept AND
    Tabprovi.Codprovi = gn-clie.codprov NO-LOCK NO-ERROR.
    IF AVAILABLE Tabprovi THEN 
     DISPLAY Tabprovi.Nomprovi @ fill-in-prov.
   
    FIND  Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept AND
    Tabdistr.Codprovi = gn-clie.codprov AND Tabdistr.Coddistr = gn-clie.coddist NO-LOCK NO-ERROR.
    IF AVAILABLE Tabdistr THEN 
     DISPLAY Tabdistr.Nomdistr @ fill-in-dis.

    FIND almtabla WHERE almtabla.Tabla = 'CP' AND almtabla.Codigo = integral.gn-clie.CodPos  NO-LOCK NO-ERROR.
    IF AVAILABLE  almtabla THEN 
       DISPLAY almtabla.nombre @ FILL-IN-POS.
        
    FIND almtabla WHERE almtabla.Tabla = 'GN' AND almtabla.Codigo = integral.gn-clie.GirCli NO-LOCK NO-ERROR.
    IF AVAILABLE  almtabla THEN 
       DISPLAY almtabla.nombre @ f-giro.
       
    FIND gn-ven WHERE gn-ven.CodVen = gn-clie.CodVen NO-LOCK NO-ERROR.
    IF AVAILABLE  gn-ven THEN 
       DISPLAY gn-ven.NomVen @ f-NomVen.
       
    FIND gn-convt WHERE gn-convt.Codig = gn-clie.CndVta NO-LOCK NO-ERROR.
    IF AVAILABLE  gn-convt THEN 
       DISPLAY gn-ConVt.Nombr @ f-ConVta.
       
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

    RB-FILTER = "Gn-clie.CodCia = cl-codcia " + 
                " AND Gn-clie.codcli = '" + Gn-clie.codcli + "'". 

    RB-OTHER-PARAMETERS = "GsNomCia = " + S-NOMCIA.
                            
    RUN lib\_imprime.r(RB-REPORT-LIBRARY, RB-REPORT-NAME,
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
     RUN VALIDA.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
        WHEN "" THEN.
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
  
  GN-CLIE.CODCLI:SENSITIVE IN FRAME {&FRAME-NAME} = NO.  
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
/* FIND gn-convt WHERE gn-convt.Codig = gn-clie.CndVta:screen-value NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-convt THEN DO:
      MESSAGE "Condicion de Venta No Existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO gn-clie.CndVta.
      RETURN "ADM-ERROR".   
   END.
*/   
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

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

