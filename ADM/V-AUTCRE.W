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

DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR cl-codcia AS INTEGER.

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "aplic\ccb\rbccb.prl".
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
DEFINE VAR wcambio AS DECIMAL.

/* Local Variable Definitions ---                                       */

DEFINE SHARED VARIABLE  S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE  S-USER-ID AS CHAR.
/* DEFINE VARIABLE cl-codcia  AS INTEGER INITIAL 0 NO-UNDO. */
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

FIND Empresas WHERE Empresas.CodCia = S-CODCIA NO-LOCK NO-ERROR.
/*IF NOT Empresas.Campo-CodCli THEN cl-codcia = S-CODCIA.*/

FIND gn-LinUsr WHERE gn-LinUsr.Usuario = S-USER-ID NO-LOCK NO-ERROR.

FIND FIRST FacCfgGn  WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
     wcambio = integral.FacCfgGn.Tpocmb[1].

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
&Scoped-Define ENABLED-FIELDS gn-clie.NomCli gn-clie.Flgsit gn-clie.Ruc ~
gn-clie.DirCli gn-clie.DirEnt gn-clie.E-Mail gn-clie.CodDept ~
gn-clie.Telfnos[1] gn-clie.CodProv gn-clie.Telfnos[2] gn-clie.clfCli ~
gn-clie.CodDist gn-clie.Telfnos[3] gn-clie.FlagAut gn-clie.Codpos ~
gn-clie.FaxCli gn-clie.Contac gn-clie.Referencias gn-clie.GirCli ~
gn-clie.CndVta gn-clie.ObsAut gn-clie.ImpLC gn-clie.FchVLC 
&Scoped-define ENABLED-TABLES gn-clie
&Scoped-define FIRST-ENABLED-TABLE gn-clie
&Scoped-Define ENABLED-OBJECTS RECT-30 RECT-29 RECT-27 RECT-25 
&Scoped-Define DISPLAYED-FIELDS gn-clie.CodCli gn-clie.NomCli ~
gn-clie.Flgsit gn-clie.Ruc gn-clie.DirCli gn-clie.Fching gn-clie.DirEnt ~
gn-clie.FchAct gn-clie.E-Mail gn-clie.FchCes gn-clie.CodDept ~
gn-clie.Telfnos[1] gn-clie.CodProv gn-clie.Telfnos[2] gn-clie.clfCli ~
gn-clie.CodDist gn-clie.Telfnos[3] gn-clie.FlagAut gn-clie.Codpos ~
gn-clie.FaxCli gn-clie.Contac gn-clie.Referencias gn-clie.GirCli ~
gn-clie.TpoCli gn-clie.CndVta gn-clie.CodVen gn-clie.UsrAut gn-clie.UsrLC ~
gn-clie.ObsAut gn-clie.MonLC gn-clie.ImpLC gn-clie.FchVLC 
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
     SIZE 24.29 BY .69 NO-UNDO.

DEFINE VARIABLE f-Giro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24.29 BY .69 NO-UNDO.

DEFINE VARIABLE F-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24.29 BY .69 NO-UNDO.

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

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 6.81.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 4.12.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 3.15.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 12.86 BY 2.23.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 14.72 BY 2.54.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 11.86 BY 2.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     gn-clie.CodCli AT ROW 1.19 COL 10.86 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     gn-clie.NomCli AT ROW 1.19 COL 22.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 36.86 BY .69
     gn-clie.Flgsit AT ROW 1.19 COL 62 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Activo", "A":U,
"Bloqueado", "I":U,
"Cesado", "C":U
          SIZE 25 BY .58
     gn-clie.Ruc AT ROW 1.81 COL 70.14 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
          BGCOLOR 15 FGCOLOR 9 
     gn-clie.DirCli AT ROW 1.88 COL 10.86 COLON-ALIGNED
          LABEL "Direccion Legal"
          VIEW-AS FILL-IN 
          SIZE 48.29 BY .69
     gn-clie.Fching AT ROW 2.5 COL 70.29 COLON-ALIGNED
          LABEL "Ingreso"
          VIEW-AS FILL-IN 
          SIZE 10.86 BY .69
     gn-clie.DirEnt AT ROW 2.58 COL 10.86 COLON-ALIGNED
          LABEL "Dir. Entrega"
          VIEW-AS FILL-IN 
          SIZE 48.29 BY .69
     gn-clie.FchAct AT ROW 3.19 COL 70.29 COLON-ALIGNED
          LABEL "Actualizacion"
          VIEW-AS FILL-IN 
          SIZE 10.86 BY .69
     gn-clie.E-Mail AT ROW 3.31 COL 10.86 COLON-ALIGNED FORMAT "X(50)"
          VIEW-AS FILL-IN 
          SIZE 48.29 BY .69
          BGCOLOR 8 FGCOLOR 9 
     gn-clie.FchCes AT ROW 3.92 COL 70.29 COLON-ALIGNED
          LABEL "Cese"
          VIEW-AS FILL-IN 
          SIZE 10.86 BY .69
     gn-clie.CodDept AT ROW 4.12 COL 10.86 COLON-ALIGNED
          LABEL "Departamento" FORMAT "X(2)"
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .69
     FILL-IN-DEP AT ROW 4.12 COL 17 COLON-ALIGNED NO-LABEL
     gn-clie.Telfnos[1] AT ROW 4.19 COL 45.29 COLON-ALIGNED
          LABEL "Telef1"
          VIEW-AS FILL-IN 
          SIZE 13 BY .69
          FGCOLOR 0 
     gn-clie.CodProv AT ROW 4.81 COL 10.86 COLON-ALIGNED
          LABEL "Provincia" FORMAT "X(2)"
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .69
     FILL-IN-PROV AT ROW 4.81 COL 17 COLON-ALIGNED NO-LABEL
     gn-clie.Telfnos[2] AT ROW 4.88 COL 45.29 COLON-ALIGNED
          LABEL "Telef2"
          VIEW-AS FILL-IN 
          SIZE 13 BY .69
     gn-clie.clfCli AT ROW 5.23 COL 73.43 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "No Calificado", " ":U,
"Bueno        ", "A":U,
"Regular/Bueno", "B":U,
"Regular/Malo ", "C":U,
"Malo         ", "D":U
          SIZE 14 BY 2.38
     gn-clie.CodDist AT ROW 5.54 COL 10.86 COLON-ALIGNED FORMAT "X(2)"
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .69
     FILL-IN-DIS AT ROW 5.54 COL 17 COLON-ALIGNED NO-LABEL
     gn-clie.Telfnos[3] AT ROW 5.54 COL 45.29 COLON-ALIGNED
          LABEL "Telef3"
          VIEW-AS FILL-IN 
          SIZE 13 BY .69
     gn-clie.FlagAut AT ROW 5.58 COL 61.57 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Sin Autorizar", " ":U,
"Autorizado", "A":U,
"Rechazado", "R":U
          SIZE 11 BY 1.54
          BGCOLOR 8 
     gn-clie.Codpos AT ROW 6.23 COL 10.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .69
     FILL-IN-POS AT ROW 6.23 COL 17 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     gn-clie.FaxCli AT ROW 6.23 COL 45.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .69
     gn-clie.Contac AT ROW 6.92 COL 10.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 37.14 BY .69
     gn-clie.Referencias AT ROW 8.58 COL 57.86 NO-LABEL
          VIEW-AS EDITOR LARGE
          SIZE 29.29 BY 2.23
     gn-clie.GirCli AT ROW 8.62 COL 10.86 COLON-ALIGNED
          LABEL "Giro" FORMAT "X(4)"
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .69
     f-Giro AT ROW 8.62 COL 17 COLON-ALIGNED NO-LABEL
     gn-clie.TpoCli AT ROW 8.73 COL 44.86 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Minorista", "1":U,
"Mayorista", "2":U,
"Distribuidor", "3":U,
"Publico", "4":U
          SIZE 11.43 BY 2.04
     gn-clie.CndVta AT ROW 9.31 COL 10.86 COLON-ALIGNED
          LABEL "Cond. Venta" FORMAT "X(4)"
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .69
     f-ConVta AT ROW 9.31 COL 17 COLON-ALIGNED NO-LABEL
     gn-clie.CodVen AT ROW 10.04 COL 10.86 COLON-ALIGNED
          LABEL "Vendedor"
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .69
     F-NomVen AT ROW 10.04 COL 17 COLON-ALIGNED NO-LABEL
     gn-clie.UsrAut AT ROW 10.96 COL 72.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.72 BY .62
          BGCOLOR 7 
     gn-clie.UsrLC AT ROW 11.19 COL 26.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.72 BY .81
          BGCOLOR 15 FONT 0
     gn-clie.ObsAut AT ROW 11.69 COL 41.86 NO-LABEL
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
          SIZE 45.43 BY 3.12
     gn-clie.MonLC AT ROW 12.38 COL 21.43 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.72 BY .54
          FONT 0
     gn-clie.ImpLC AT ROW 13.08 COL 17.72 COLON-ALIGNED NO-LABEL FORMAT "ZZZZ,ZZ9.99"
          VIEW-AS FILL-IN 
          SIZE 13.43 BY .81
     gn-clie.FchVLC AT ROW 14 COL 21.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.86 BY .81
     "Moneda :" VIEW-AS TEXT
          SIZE 8 BY .81 AT ROW 12.27 COL 11
          FONT 1
     "Observaciones Generales" VIEW-AS TEXT
          SIZE 18.86 BY .5 AT ROW 8.08 COL 58
          BGCOLOR 1 FGCOLOR 15 
     "Tipo Cliente" VIEW-AS TEXT
          SIZE 10 BY .42 AT ROW 8.08 COL 44.29
          BGCOLOR 1 FGCOLOR 15 
     "Autorizacion" VIEW-AS TEXT
          SIZE 11.14 BY .42 AT ROW 4.65 COL 61.29
          BGCOLOR 1 FGCOLOR 15 
     "Comentarios Administrativos" VIEW-AS TEXT
          SIZE 18.86 BY .5 AT ROW 11.12 COL 41.86
          BGCOLOR 1 FGCOLOR 15 
     "Calificacion" VIEW-AS TEXT
          SIZE 11.14 BY .42 AT ROW 4.65 COL 73
          BGCOLOR 1 FGCOLOR 15 
     "Linea de Credito" VIEW-AS TEXT
          SIZE 15.72 BY .81 AT ROW 11.08 COL 1.86
          BGCOLOR 1 FGCOLOR 15 FONT 1
     "Importe:" VIEW-AS TEXT
          SIZE 8 BY .81 AT ROW 13.12 COL 11
          FONT 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "Autoriza Finanzas" VIEW-AS TEXT
          SIZE 12.57 BY .5 AT ROW 11.04 COL 61.72
          BGCOLOR 8 FGCOLOR 0 
     "Vencimiento:" VIEW-AS TEXT
          SIZE 12 BY .81 AT ROW 13.96 COL 11
          FONT 1
     RECT-30 AT ROW 5.12 COL 61
     RECT-29 AT ROW 5.12 COL 72.86
     RECT-27 AT ROW 8.58 COL 44.29
     RECT-26 AT ROW 7.77 COL 1
     RECT-25 AT ROW 10.88 COL 1
     RECT-24 AT ROW 1 COL 1
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
         HEIGHT             = 14.04
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN gn-clie.CndVta IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.CodCli IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.CodDept IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.CodDist IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN gn-clie.CodProv IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.CodVen IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
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
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN gn-clie.FchCes IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN gn-clie.Fching IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN gn-clie.FchVLC IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DEP IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DIS IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-POS IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-PROV IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.GirCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.ImpLC IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR RADIO-SET gn-clie.MonLC IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.NomCli IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR RECTANGLE RECT-24 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-26 IN FRAME F-Main
   NO-ENABLE                                                            */
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
/* SETTINGS FOR FILL-IN gn-clie.UsrAut IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.UsrLC IN FRAME F-Main
   NO-ENABLE                                                            */
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


&Scoped-define SELF-NAME gn-clie.ImpLC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.ImpLC V-table-Win
ON LEAVE OF gn-clie.ImpLC IN FRAME F-Main /* Linea de Credito */
DO:
  IF INTEGER(gn-clie.MonLC:SCREEN-VALUE) = 1 THEN DO:
     IF DECIMAL(gn-clie.ImpLC:SCREEN-VALUE) > ROUND( gn-LinUsr.MaxDol * wcambio,2 )  THEN DO:
        MESSAGE "El Maximo Credito que puede otorgar es S/." ROUND(gn-LinUsr.MaxDol * wcambio,2)
                VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
     END.
  END.
  IF INTEGER(gn-clie.MonLC:SCREEN-VALUE) = 2 THEN DO:
     IF DECIMAL(gn-clie.ImpLC:SCREEN-VALUE) > gn-LinUsr.MaxDol THEN DO:
        MESSAGE "El Maximo Credito que puede otorgar es US$. " gn-LinUsr.MaxDol
                VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
     END.
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
            gn-clie.Fching = TODAY.
  END.

  DO WITH FRAME {&FRAME-NAME}:
     gn-clie.MonLC = 2.
     IF gn-clie.FlagAut = "" AND gn-clie.ImpLC > 0 THEN DO:
        ASSIGN 
           gn-clie.impLC = 0
           gn-clie.fchvLC = ?.
        MESSAGE "Cliente no Tiene Autorizacion Financiera " SKIP
                "      Solicitar su Autorizacion          " VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO gn-clie.impLC. 
     END.
     IF gn-clie.FlagAut = "R" AND gn-clie.ImpLC > 0 THEN DO:
        ASSIGN 
           gn-clie.impLC = 0
           gn-clie.fchvLC = ?.
        MESSAGE "Cliente esta rechazado no se puede " SKIP
                "otorgar Linea Credito.             " SKIP 
                "Consulte con el Area Financiera.   " VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO gn-clie.impLC. 
     END.
     
     IF gn-clie.impLC > 0 THEN DO:
        ASSIGN
           gn-clie.usrLC = S-USER-ID.
     END.
     ELSE DO:       
        ASSIGN
           gn-clie.usrLC = "".
     END.
           
     IF gn-clie.flagAut <> "" THEN DO:
        ASSIGN
           gn-clie.usrAut = S-USER-ID.
     END.
     ELSE DO:
        ASSIGN
           gn-clie.usrAut = "".
     END.      
     DISPLAY gn-clie.usrLC  gn-clie.impLC gn-clie.usrAut.
     
   END. 
   /* RHC 05.10.04 Historico de lineas de credito */
   CREATE LogTabla.
   ASSIGN
    logtabla.codcia = s-codcia
    logtabla.Dia = TODAY
    logtabla.Evento = 'LINEA-CREDITO'
    logtabla.Hora = STRING(TIME, 'HH:MM')
    logtabla.Tabla = 'GN-CLIE'
    logtabla.Usuario = s-user-id
    logtabla.ValorLlave = STRING(gn-clie.codcli, 'x(11)') + '|' +
                            STRING(gn-clie.nomcli, 'x(50)') + '|' +
                            STRING(gn-clie.MonLC, '9') + '|' + 
                            STRING(gn-clie.ImpLC, '->>>>>>>>9.99') + '|' +
                            STRING(gn-clie.CndVta, 'x(4)').
   RELEASE LogTabla. 
    
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
     FIND  TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
     IF AVAILABLE TabDepto THEN DISPLAY TabDepto.NomDepto @ fill-in-dep.
     
     FIND  Tabprovi WHERE Tabprovi.CodDepto = gn-clie.CodDept 
                     AND  Tabprovi.Codprovi = gn-clie.codprov 
                    NO-LOCK NO-ERROR.
     IF AVAILABLE Tabprovi THEN  DISPLAY Tabprovi.Nomprovi @ fill-in-prov.
     
     FIND  Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept 
                     AND  Tabdistr.Codprovi = gn-clie.codprov 
                     AND  Tabdistr.Coddistr = gn-clie.coddist 
                    NO-LOCK NO-ERROR.
     IF AVAILABLE Tabdistr THEN  DISPLAY Tabdistr.Nomdistr @ fill-in-dis.
     
     FIND almtabla WHERE almtabla.Tabla = 'CP' 
                    AND  almtabla.Codigo = gn-clie.CodPos  
                   NO-LOCK NO-ERROR.
     IF AVAILABLE  almtabla THEN  DISPLAY almtabla.nombre @ FILL-IN-POS.
     
     FIND almtabla WHERE almtabla.Tabla = 'GN' 
                    AND  almtabla.Codigo = gn-clie.GirCli 
                   NO-LOCK NO-ERROR.
     IF AVAILABLE  almtabla THEN DISPLAY almtabla.nombre @ f-giro.
           
     FIND gn-ven WHERE gn-ven.CodVen = gn-clie.CodVen NO-LOCK NO-ERROR.
     IF AVAILABLE  gn-ven THEN DISPLAY gn-ven.NomVen @ f-NomVen.
       
     FIND gn-convt WHERE gn-convt.Codig = gn-clie.CndVta NO-LOCK NO-ERROR.
     IF AVAILABLE  gn-convt THEN  DISPLAY gn-ConVt.Nombr @ f-ConVta.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN gn-clie.MonLC:SCREEN-VALUE = "2".
  END.

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
 /*  FIND gn-convt WHERE gn-convt.Codig = gn-clie.CndVta:screen-value NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gn-convt THEN DO:
        MESSAGE "Condicion de venta no existe" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO gn-clie.CndVta.
        RETURN "ADM-ERROR".   
     END.  */
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

