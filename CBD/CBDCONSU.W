&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME WINDOW-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS WINDOW-1 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 07/14/95 -  8:37 am

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE {&NEW} SHARED VARIABLE s-codcia AS INTEGER INITIAL 1.
DEFINE VARIABLE               y-CodCia AS INTEGER INITIAL 0.

FIND Empresas WHERE Empresas.CodCia = s-codcia.
IF NOT Empresas.Campo-CodCbd THEN y-CodCia = s-codcia.

DEFINE {&NEW} SHARED VARIABLE s-periodo          AS INTEGER INITIAL 1995.
DEFINE {&NEW} SHARED VARIABLE s-user-id       AS CHARACTER INITIAL "MASTER".
DEFINE {&NEW} SHARED VARIABLE cb-niveles AS CHARACTER INITIAL "2,3,5".

DEFINE VARIABLE RegAct     AS RECID.
DEFINE VARIABLE x-saldoMn1 AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99" EXTENT 14 NO-UNDO.
DEFINE VARIABLE x-saldoMn2 AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99" EXTENT 14 NO-UNDO.
DEFINE VARIABLE s-NroMes   AS INTEGER.
DEFINE VARIABLE x-maxnivel AS INTEGER.
DEFINE VARIABLE i          AS INTEGER.
DEFINE VARIABLE pto        AS LOGICAL.

pto = SESSION:SET-WAIT-STATE("").
x-maxnivel = INTEGER ( ENTRY ( NUM-ENTRIES ( cb-niveles ), cb-niveles ) ).

DEFINE VAR x-DbeMn1 AS DECIMAL EXTENT 14 NO-UNDO.
DEFINE VAR x-HbeMn1 AS DECIMAL EXTENT 14 NO-UNDO.
DEFINE VAR x-DbeMn2 AS DECIMAL EXTENT 14 NO-UNDO.
DEFINE VAR x-HbeMn2 AS DECIMAL EXTENT 14 NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME FRAME-A
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cb-ctas

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 cb-ctas.Codcta cb-ctas.Nomcta 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH cb-ctas ~
      WHERE cb-ctas.CodCia = y-CodCia AND (cb-ctas.vcodcia = 0 OR ~
cb-ctas.vcodcia = s-codcia ) ~
 ~
 ~
 ~
 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH cb-ctas ~
      WHERE cb-ctas.CodCia = y-CodCia AND (cb-ctas.vcodcia = 0 OR ~
cb-ctas.vcodcia = s-codcia ) ~
 ~
 ~
 ~
 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 cb-ctas
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 cb-ctas


/* Definitions for FRAME FRAME-A                                        */
&Scoped-define OPEN-BROWSERS-IN-QUERY-FRAME-A ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 RECT-1 RECT-6 RECT-5 COMBO-moneda ~
BROWSE-1 RADIO-SET-1 COMBO-nivel B-continuar F-codcta B-salir F-CodDiv 
&Scoped-Define DISPLAYED-OBJECTS COMBO-moneda RADIO-SET-1 c-0 a-0 s-0 c-1 ~
a-1 s-1 c-2 a-2 s-2 c-3 a-3 s-3 c-4 a-4 s-4 c-5 a-5 s-5 c-6 a-6 s-6 c-7 a-7 ~
s-7 c-8 a-8 s-8 c-9 a-9 s-9 c-10 a-10 s-10 c-11 a-11 s-11 COMBO-nivel c-12 ~
a-12 s-12 F-codcta c-13 a-13 s-13 F-CodDiv 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR WINDOW-1 AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-continuar AUTO-GO 
     LABEL "&Continuar" 
     SIZE 10.29 BY .96.

DEFINE BUTTON B-salir AUTO-END-KEY 
     LABEL "&Salir" 
     SIZE 10.29 BY .96.

DEFINE VARIABLE COMBO-moneda AS CHARACTER FORMAT "X(8)":U INITIAL "S/." 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "S/.","US$" 
     DROP-DOWN-LIST
     SIZE 6.86 BY 1
     FONT 0 NO-UNDO.

DEFINE VARIABLE COMBO-nivel AS CHARACTER FORMAT "X(256)":U 
     LABEL "D¡gitos" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     DROP-DOWN-LIST
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE a-0 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE a-1 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE a-10 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE a-11 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE a-12 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE a-13 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE a-2 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE a-3 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE a-4 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE a-5 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE a-6 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE a-7 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE a-8 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE a-9 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE c-0 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE c-1 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE c-10 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE c-11 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE c-12 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE c-13 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE c-2 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE c-3 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE c-4 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE c-5 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE c-6 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE c-7 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE c-8 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE c-9 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE F-codcta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cuenta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69 NO-UNDO.

DEFINE VARIABLE F-CodDiv AS CHARACTER FORMAT "X(5)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69 NO-UNDO.

DEFINE VARIABLE s-0 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE s-1 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE s-10 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE s-11 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE s-12 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE s-13 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE s-2 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE s-3 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE s-4 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE s-5 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE s-6 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE s-7 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE s-8 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE s-9 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Ape", 0,
"Ene", 1,
"Feb", 2,
"Mar", 3,
"Abr", 4,
"May", 5,
"Jun", 6,
"Jul", 7,
"Ago", 8,
"Sep", 9,
"Oct", 10,
"Nov", 11,
"Dic", 12,
"Cie", 13
     SIZE 5.57 BY 13.92 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 58 BY 15.69
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 33 BY 12.5
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE    
     SIZE 20.86 BY 3.19
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 4 GRAPHIC-EDGE    
     SIZE 12.86 BY 3.19
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      cb-ctas SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 WINDOW-1 _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      cb-ctas.Codcta COLUMN-LABEL "  Cuenta" FORMAT "x(10)":U COLUMN-FONT 4
      cb-ctas.Nomcta COLUMN-LABEL "Descripción" FORMAT "x(40)":U
            COLUMN-FONT 4
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 31.29 BY 11.73
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME FRAME-A
     COMBO-moneda AT ROW 1.27 COL 33 COLON-ALIGNED HELP
          "Seleccione una moneda" NO-LABEL
     BROWSE-1 AT ROW 1.5 COL 2
     RADIO-SET-1 AT ROW 2.38 COL 35 NO-LABEL
     c-0 AT ROW 2.5 COL 40 COLON-ALIGNED NO-LABEL
     a-0 AT ROW 2.5 COL 56.29 COLON-ALIGNED NO-LABEL
     s-0 AT ROW 2.5 COL 72.57 COLON-ALIGNED NO-LABEL
     c-1 AT ROW 3.5 COL 40 COLON-ALIGNED NO-LABEL
     a-1 AT ROW 3.5 COL 56.29 COLON-ALIGNED NO-LABEL
     s-1 AT ROW 3.5 COL 72.57 COLON-ALIGNED NO-LABEL
     c-2 AT ROW 4.5 COL 42 NO-LABEL
     a-2 AT ROW 4.5 COL 56.29 COLON-ALIGNED NO-LABEL
     s-2 AT ROW 4.5 COL 72.57 COLON-ALIGNED NO-LABEL
     c-3 AT ROW 5.5 COL 40 COLON-ALIGNED NO-LABEL
     a-3 AT ROW 5.5 COL 56.29 COLON-ALIGNED NO-LABEL
     s-3 AT ROW 5.5 COL 72.57 COLON-ALIGNED NO-LABEL
     c-4 AT ROW 6.5 COL 40 COLON-ALIGNED NO-LABEL
     a-4 AT ROW 6.5 COL 56.29 COLON-ALIGNED NO-LABEL
     s-4 AT ROW 6.5 COL 72.57 COLON-ALIGNED NO-LABEL
     c-5 AT ROW 7.5 COL 40 COLON-ALIGNED NO-LABEL
     a-5 AT ROW 7.5 COL 58.29 NO-LABEL
     s-5 AT ROW 7.5 COL 72.57 COLON-ALIGNED NO-LABEL
     c-6 AT ROW 8.5 COL 40 COLON-ALIGNED NO-LABEL
     a-6 AT ROW 8.5 COL 56.29 COLON-ALIGNED NO-LABEL
     s-6 AT ROW 8.5 COL 72.57 COLON-ALIGNED NO-LABEL
     c-7 AT ROW 9.5 COL 40 COLON-ALIGNED NO-LABEL
     a-7 AT ROW 9.5 COL 56.29 COLON-ALIGNED NO-LABEL
     s-7 AT ROW 9.5 COL 72.57 COLON-ALIGNED NO-LABEL
     c-8 AT ROW 10.5 COL 40 COLON-ALIGNED NO-LABEL
     a-8 AT ROW 10.5 COL 56.29 COLON-ALIGNED NO-LABEL
     s-8 AT ROW 10.5 COL 72.57 COLON-ALIGNED NO-LABEL
     c-9 AT ROW 11.5 COL 40 COLON-ALIGNED NO-LABEL
     a-9 AT ROW 11.5 COL 56.29 COLON-ALIGNED NO-LABEL
     s-9 AT ROW 11.5 COL 72.57 COLON-ALIGNED NO-LABEL
     c-10 AT ROW 12.5 COL 40 COLON-ALIGNED NO-LABEL
     a-10 AT ROW 12.5 COL 56.29 COLON-ALIGNED NO-LABEL
     s-10 AT ROW 12.5 COL 72.57 COLON-ALIGNED NO-LABEL
     c-11 AT ROW 13.5 COL 40 COLON-ALIGNED NO-LABEL
     a-11 AT ROW 13.5 COL 56.29 COLON-ALIGNED NO-LABEL
     s-11 AT ROW 13.5 COL 72.57 COLON-ALIGNED NO-LABEL
     COMBO-nivel AT ROW 14 COL 7 COLON-ALIGNED
     B-continuar AT ROW 14 COL 22.57
     c-12 AT ROW 14.54 COL 40 COLON-ALIGNED NO-LABEL
     a-12 AT ROW 14.54 COL 56.29 COLON-ALIGNED NO-LABEL
     s-12 AT ROW 14.54 COL 72.57 COLON-ALIGNED NO-LABEL
     F-codcta AT ROW 14.88 COL 7 COLON-ALIGNED HELP
          "Ingrese primeros caracteres para realizar la b£squeda"
     B-salir AT ROW 15.31 COL 22.57
     c-13 AT ROW 15.5 COL 40 COLON-ALIGNED NO-LABEL
     a-13 AT ROW 15.5 COL 56.29 COLON-ALIGNED NO-LABEL
     s-13 AT ROW 15.5 COL 72.57 COLON-ALIGNED NO-LABEL
     F-CodDiv AT ROW 15.69 COL 7 COLON-ALIGNED
     "Abono" VIEW-AS TEXT
          SIZE 6.29 BY .69 AT ROW 1.73 COL 62.86
          FONT 19
     "Cargo" VIEW-AS TEXT
          SIZE 6 BY .69 AT ROW 1.73 COL 46.86
          FONT 19
     "Saldo" VIEW-AS TEXT
          SIZE 5.43 BY .69 AT ROW 1.73 COL 79.72
          FONT 19
     RECT-3 AT ROW 1 COL 1
     RECT-1 AT ROW 1 COL 33.86
     RECT-6 AT ROW 13.5 COL 21.43
     RECT-5 AT ROW 13.5 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW WINDOW-1 ASSIGN
         HIDDEN             = YES
         TITLE              = "Consulta de Plan de Cuentas"
         COLUMN             = 16.43
         ROW                = 7.31
         HEIGHT             = 16.46
         WIDTH              = 94.29
         MAX-HEIGHT         = 17.42
         MAX-WIDTH          = 97
         VIRTUAL-HEIGHT     = 17.42
         VIRTUAL-WIDTH      = 97
         RESIZE             = yes
         SCROLL-BARS        = yes
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW WINDOW-1
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME FRAME-A
   FRAME-NAME Size-to-Fit                                               */
/* BROWSE-TAB BROWSE-1 COMBO-moneda FRAME-A */
ASSIGN 
       FRAME FRAME-A:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN a-0 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN a-1 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN a-10 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN a-11 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN a-12 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN a-13 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN a-2 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN a-3 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN a-4 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN a-5 IN FRAME FRAME-A
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN a-6 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN a-7 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN a-8 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN a-9 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-0 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-1 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-10 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-11 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-12 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-13 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-2 IN FRAME FRAME-A
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-3 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-4 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-5 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-6 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-7 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-8 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-9 IN FRAME FRAME-A
   NO-ENABLE                                                            */
ASSIGN 
       COMBO-nivel:MANUAL-HIGHLIGHT IN FRAME FRAME-A = TRUE.

/* SETTINGS FOR FILL-IN s-0 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN s-1 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN s-10 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN s-11 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN s-12 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN s-13 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN s-2 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN s-3 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN s-4 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN s-5 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN s-6 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN s-7 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN s-8 IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN s-9 IN FRAME FRAME-A
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(WINDOW-1)
THEN WINDOW-1:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "integral.cb-ctas"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "cb-ctas.CodCia = y-CodCia AND (cb-ctas.vcodcia = 0 OR
cb-ctas.vcodcia = s-codcia )



"
     _FldNameList[1]   > integral.cb-ctas.Codcta
"cb-ctas.Codcta" "  Cuenta" ? "character" ? ? 4 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.cb-ctas.Nomcta
"cb-ctas.Nomcta" "Descripción" ? "character" ? ? 4 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME           = FRAME FRAME-A:HANDLE
       ROW             = 13.69
       COLUMN          = 16.14
       HEIGHT          = 1.08
       WIDTH           = 4
       HIDDEN          = yes
       SENSITIVE       = yes.
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {F0B88A90-F5DA-11CF-B545-0020AF6ED35A} type: PSTimer */
      CtrlFrame:MOVE-AFTER(s-11:HANDLE IN FRAME FRAME-A).

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-continuar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-continuar WINDOW-1
ON CHOOSE OF B-continuar IN FRAME FRAME-A /* Continuar */
DO:
    find cb-ctas WHERE RECID(cb-ctas) = RegAct NO-LOCK NO-ERROR.
    IF AVAILABLE cb-ctas
    THEN DO:
        F-CodCta:SCREEN-VALUE = cb-ctas.CodCta.
        IF LENGTH(cb-ctas.CodCta) < x-maxnivel
        THEN DO:
            BELL.
            MESSAGE "Cuenta debe ser de £ltimo nivel" SKIP
                "seleccione una cuenta" VIEW-AS ALERT-BOX ERROR.
            COMBO-nivel:SCREEN-VALUE = STRING(x-maxnivel).
            OPEN QUERY BROWSE-1 FOR EACH cb-ctas WHERE cb-ctas.CodCia = y-CodCia
                AND LENGTH(cb-ctas.CodCta) = x-maxnivel
                AND cb-ctas.CodCta BEGINS F-CodCta:SCREEN-VALUE
                NO-LOCK INDEXED-REPOSITION.
        END.
        ELSE DO:
            s-NroMes = INTEGER(RADIO-SET-1:SCREEN-VALUE).
            RUN cbd/cbdcons2.w(cb-ctas.CodCta, s-NroMes,y-codcia,x-maxnivel,F-CodDiv).
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&Scoped-define SELF-NAME BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 WINDOW-1
ON VALUE-CHANGED OF BROWSE-1 IN FRAME FRAME-A
DO:
    ASSIGN F-CodDiv.
    RegAct = RECID(cb-ctas).
    
    DO i = 1 TO 14:
       x-DbeMn1[i] = 0.
       x-DbeMn2[i] = 0.
       x-HbeMn1[i] = 0.
       x-HbeMn2[i] = 0.
       x-saldoMn1[i] = 0.
       x-saldoMn2[i] = 0.
    END.
    FIND FIRST cb-acmd WHERE cb-acmd.CodCia  = s-codcia AND
                       cb-acmd.Periodo = s-periodo AND
                       cb-acmd.CodCta BEGINS cb-ctas.CodCta AND                           
                       cb-acmd.CodDiv BEGINS F-CodDiv NO-LOCK NO-ERROR.
                       
    IF NOT AVAILABLE cb-acmd THEN DO :
       DISPLAY 0 @ c-0
               0 @ c-1
               0 @ c-2
               0 @ c-3
               0 @ c-4
               0 @ c-5
               0 @ c-6
               0 @ c-7
               0 @ c-8
               0 @ c-9
               0 @ c-10
               0 @ c-11
               0 @ c-12
               0 @ c-13
               0 @ a-0
               0 @ a-1
               0 @ a-2
               0 @ a-3
               0 @ a-4
               0 @ a-5
               0 @ a-6
               0 @ a-7
               0 @ a-8
               0 @ a-9
               0 @ a-10
               0 @ a-11
               0 @ a-12
               0 @ a-13
               0 @ s-0
               0 @ s-1
               0 @ s-2
               0 @ s-3
               0 @ s-4
               0 @ s-5
               0 @ s-6
               0 @ s-7
               0 @ s-8
               0 @ s-9
               0 @ s-10
               0 @ s-11
               0 @ s-12
               0 @ s-13 WITH FRAME FRAME-A.
    RETURN.
    END.
    FOR EACH cb-acmd WHERE cb-acmd.CodCia  = s-codcia AND
                           cb-acmd.Periodo = s-periodo AND
                           cb-acmd.CodCta BEGINS cb-ctas.CodCta AND                           
                           cb-acmd.CodDiv BEGINS F-CodDiv NO-LOCK :
        DO i = 1 TO 14:
           x-DbeMn1[i] = x-DbeMn1[i] + DbeMn1[i].
           x-DbeMn2[i] = x-DbeMn2[i] + DbeMn2[i].
           x-HbeMn1[i] = x-HbeMn1[i] + HbeMn1[i].
           x-HbeMn2[i] = x-HbeMn2[i] + HbeMn2[i].
           IF i = 1 THEN x-saldoMn1[i] = x-saldoMn1[i] + ( DbeMn1[i] - HbeMn1[i] ).
              ELSE x-saldoMn1[i] = x-saldoMn1[i - 1] + ( DbeMn1[i] - HbeMn1[i] ).
            
           IF i = 1 THEN x-saldoMn2[i] = x-saldoMn2[i] + ( DbeMn2[i] - HbeMn2[i] ).
              ELSE x-saldoMn2[i] =  x-saldoMn2[i - 1] + ( DbeMn2[i] - HbeMn2[i] ).
        END.                                                                         
    END.                       
        
    IF COMBO-moneda:SCREEN-VALUE = "S/."
        THEN DISPLAY x-DbeMn1[1] @ c-0
                     x-DbeMn1[2] @ c-1
                     x-DbeMn1[3] @ c-2
                     x-DbeMn1[4] @ c-3
                     x-DbeMn1[5] @ c-4
                     x-DbeMn1[6] @ c-5
                     x-DbeMn1[7] @ c-6
                     x-DbeMn1[8] @ c-7
                     x-DbeMn1[9] @ c-8
                     x-DbeMn1[10] @ c-9
                     x-DbeMn1[11] @ c-10
                     x-DbeMn1[12] @ c-11
                     x-DbeMn1[13] @ c-12
                     x-DbeMn1[14] @ c-13
                     x-HbeMn1[1] @ a-0
                     x-HbeMn1[2] @ a-1
                     x-HbeMn1[3] @ a-2
                     x-HbeMn1[4] @ a-3
                     x-HbeMn1[5] @ a-4
                     x-HbeMn1[6] @ a-5
                     x-HbeMn1[7] @ a-6
                     x-HbeMn1[8] @ a-7
                     x-HbeMn1[9] @ a-8
                     x-HbeMn1[10] @ a-9
                     x-HbeMn1[11] @ a-10
                     x-HbeMn1[12] @ a-11
                     x-HbeMn1[13] @ a-12
                     x-HbeMn1[14] @ a-13
                     x-saldoMn1[1] @ s-0
                     x-saldoMn1[2] @ s-1
                     x-saldoMn1[3] @ s-2
                     x-saldoMn1[4] @ s-3
                     x-saldoMn1[5] @ s-4
                     x-saldoMn1[6] @ s-5
                     x-saldoMn1[7] @ s-6
                     x-saldoMn1[8] @ s-7
                     x-saldoMn1[9] @ s-8
                     x-saldoMn1[10] @ s-9
                     x-saldoMn1[11] @ s-10
                     x-saldoMn1[12] @ s-11
                     x-saldoMn1[13] @ s-12
                     x-saldoMn1[14] @ s-13
                     WITH FRAME FRAME-A.
        IF COMBO-moneda:SCREEN-VALUE = "US$"
        THEN DISPLAY x-DbeMn2[1] @ c-0
                     x-DbeMn2[2] @ c-1
                     x-DbeMn2[3] @ c-2
                     x-DbeMn2[4] @ c-3
                     x-DbeMn2[5] @ c-4
                     x-DbeMn2[6] @ c-5
                     x-DbeMn2[7] @ c-6
                     x-DbeMn2[8] @ c-7
                     x-DbeMn2[9] @ c-8
                     x-DbeMn2[10] @ c-9
                     x-DbeMn2[11] @ c-10
                     x-DbeMn2[12] @ c-11
                     x-DbeMn2[13] @ c-12
                     x-DbeMn2[14] @ c-13
                     x-HbeMn2[1] @ a-0
                     x-HbeMn2[2] @ a-1
                     x-HbeMn2[3] @ a-2
                     x-HbeMn2[4] @ a-3
                     x-HbeMn2[5] @ a-4
                     x-HbeMn2[6] @ a-5
                     x-HbeMn2[7] @ a-6
                     x-HbeMn2[8] @ a-7
                     x-HbeMn2[9] @ a-8
                     x-HbeMn2[10] @ a-9
                     x-HbeMn2[11] @ a-10
                     x-HbeMn2[12] @ a-11
                     x-HbeMn2[13] @ a-12
                     x-HbeMn2[14] @ a-13
                     x-saldoMn2[1] @ s-0
                     x-saldoMn2[2] @ s-1
                     x-saldoMn2[3] @ s-2
                     x-saldoMn2[4] @ s-3
                     x-saldoMn2[5] @ s-4
                     x-saldoMn2[6] @ s-5
                     x-saldoMn2[7] @ s-6
                     x-saldoMn2[8] @ s-7
                     x-saldoMn2[9] @ s-8
                     x-saldoMn2[10] @ s-9
                     x-saldoMn2[11] @ s-10
                     x-saldoMn2[12] @ s-11
                     x-saldoMn2[13] @ s-12
                     x-saldoMn2[14] @ s-13
                     WITH FRAME FRAME-A.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-moneda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-moneda WINDOW-1
ON VALUE-CHANGED OF COMBO-moneda IN FRAME FRAME-A
DO:
    IF RECID(cb-ctas) = ? OR RegAct = ?
    THEN FIND FIRST cb-ctas WHERE cb-ctas.CodCia = y-CodCia NO-LOCK NO-ERROR.
    ELSE find cb-ctas WHERE RECID(cb-ctas) = RegAct NO-LOCK NO-ERROR.
    FIND cb-acmd WHERE cb-acmd.CodCia    = s-codcia AND
                       cb-acmd.Periodo   = s-periodo AND
                       cb-acmd.CodCta    = cb-ctas.CodCta AND
                       cb-acmd.CodAux = "" AND
                       cb-acmd.CodDiv = "" NO-LOCK NO-ERROR.
    IF AVAILABLE cb-acmd
    THEN DO:
        IF COMBO-moneda:SCREEN-VALUE = "S/."
        THEN DISPLAY DbeMn1[1] @ c-0
                     DbeMn1[2] @ c-1
                     DbeMn1[3] @ c-2
                     DbeMn1[4] @ c-3
                     DbeMn1[5] @ c-4
                     DbeMn1[6] @ c-5
                     DbeMn1[7] @ c-6
                     DbeMn1[8] @ c-7
                     DbeMn1[9] @ c-8
                     DbeMn1[10] @ c-9
                     DbeMn1[11] @ c-10
                     DbeMn1[12] @ c-11
                     DbeMn1[13] @ c-12
                     DbeMn1[14] @ c-13
                     HbeMn1[1] @ a-0
                     HbeMn1[2] @ a-1
                     HbeMn1[3] @ a-2
                     HbeMn1[4] @ a-3
                     HbeMn1[5] @ a-4
                     HbeMn1[6] @ a-5
                     HbeMn1[7] @ a-6
                     HbeMn1[8] @ a-7
                     HbeMn1[9] @ a-8
                     HbeMn1[10] @ a-9
                     HbeMn1[11] @ a-10
                     HbeMn1[12] @ a-11
                     HbeMn1[13] @ a-12
                     HbeMn1[14] @ a-13
                     x-saldoMn1[1] @ s-0
                     x-saldoMn1[2] @ s-1
                     x-saldoMn1[3] @ s-2
                     x-saldoMn1[4] @ s-3
                     x-saldoMn1[5] @ s-4
                     x-saldoMn1[6] @ s-5
                     x-saldoMn1[7] @ s-6
                     x-saldoMn1[8] @ s-7
                     x-saldoMn1[9] @ s-8
                     x-saldoMn1[10] @ s-9
                     x-saldoMn1[11] @ s-10
                     x-saldoMn1[12] @ s-11
                     x-saldoMn1[13] @ s-12
                     x-saldoMn1[14] @ s-13
                     WITH FRAME FRAME-A.
        IF COMBO-moneda:SCREEN-VALUE = "US$"
        THEN DISPLAY DbeMn2[1] @ c-0
                     DbeMn2[2] @ c-1
                     DbeMn2[3] @ c-2
                     DbeMn2[4] @ c-3
                     DbeMn2[5] @ c-4
                     DbeMn2[6] @ c-5
                     DbeMn2[7] @ c-6
                     DbeMn2[8] @ c-7
                     DbeMn2[9] @ c-8
                     DbeMn2[10] @ c-9
                     DbeMn2[11] @ c-10
                     DbeMn2[12] @ c-11
                     DbeMn2[13] @ c-12
                     DbeMn2[14] @ c-13
                     HbeMn2[1] @ a-0
                     HbeMn2[2] @ a-1
                     HbeMn2[3] @ a-2
                     HbeMn2[4] @ a-3
                     HbeMn2[5] @ a-4
                     HbeMn2[6] @ a-5
                     HbeMn2[7] @ a-6
                     HbeMn2[8] @ a-7
                     HbeMn2[9] @ a-8
                     HbeMn2[10] @ a-9
                     HbeMn2[11] @ a-10
                     HbeMn2[12] @ a-11
                     HbeMn2[13] @ a-12
                     HbeMn2[14] @ a-13
                     x-saldoMn2[1] @ s-0
                     x-saldoMn2[2] @ s-1
                     x-saldoMn2[3] @ s-2
                     x-saldoMn2[4] @ s-3
                     x-saldoMn2[5] @ s-4
                     x-saldoMn2[6] @ s-5
                     x-saldoMn2[7] @ s-6
                     x-saldoMn2[8] @ s-7
                     x-saldoMn2[9] @ s-8
                     x-saldoMn2[10] @ s-9
                     x-saldoMn2[11] @ s-10
                     x-saldoMn2[12] @ s-11
                     x-saldoMn2[13] @ s-12
                     x-saldoMn2[14] @ s-13
                     WITH FRAME FRAME-A.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-nivel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-nivel WINDOW-1
ON VALUE-CHANGED OF COMBO-nivel IN FRAME FRAME-A /* D¡gitos */
DO:
    IF Combo-nivel:SCREEN-VALUE = ?
    THEN DO:
        OPEN QUERY BROWSE-1 FOR EACH cb-ctas WHERE cb-ctas.CodCia = y-CodCia AND
            cb-ctas.CodCta BEGINS F-CodCta:SCREEN-VALUE
            NO-LOCK INDEXED-REPOSITION.
    END.
    ELSE DO:
        OPEN QUERY BROWSE-1 FOR EACH cb-ctas WHERE cb-ctas.CodCia = y-CodCia AND
            LENGTH(cb-ctas.CodCta) = INTEGER(Combo-nivel:SCREEN-VALUE) AND
            cb-ctas.CodCta BEGINS F-CodCta:SCREEN-VALUE
            NO-LOCK INDEXED-REPOSITION.
    END.
    APPLY "VALUE-CHANGED" TO BROWSE-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CtrlFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame WINDOW-1 OCX.Tick
PROCEDURE CtrlFrame.PSTimer.Tick .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/

APPLY "VALUE-CHANGED" TO BROWSE-1 IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-codcta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-codcta WINDOW-1
ON LEAVE OF F-codcta IN FRAME FRAME-A /* Cuenta */
DO:
    IF Combo-nivel:SCREEN-VALUE = "" OR Combo-nivel:SCREEN-VALUE = ?
    THEN DO:
        OPEN QUERY BROWSE-1 FOR EACH cb-ctas WHERE cb-ctas.CodCia = y-CodCia AND
            cb-ctas.CodCta BEGINS F-CodCta:SCREEN-VALUE
            NO-LOCK INDEXED-REPOSITION.
    END.
    ELSE DO:
        OPEN QUERY BROWSE-1 FOR EACH cb-ctas WHERE cb-ctas.CodCia = y-CodCia AND
            LENGTH(cb-ctas.CodCta) = INTEGER(Combo-nivel:SCREEN-VALUE) AND
            cb-ctas.CodCta BEGINS F-CodCta:SCREEN-VALUE
            NO-LOCK INDEXED-REPOSITION.
    END.
    APPLY "VALUE-CHANGED" TO BROWSE-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK WINDOW-1 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* These events will close the window and terminate the procedure.      */
/* (NOTE: this will override any user-defined triggers previously       */
/*  defined on the window.)                                             */
ON WINDOW-CLOSE OF {&WINDOW-NAME} DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.
ON ENDKEY, END-ERROR OF {&WINDOW-NAME} ANYWHERE DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    FIND FIRST cb-ctas WHERE cb-ctas.CodCia = y-CodCia NO-LOCK NO-ERROR.
    FIND cb-acmd WHERE cb-acmd.CodCia  = s-codcia AND
                       cb-acmd.Periodo = s-periodo AND
                       cb-acmd.CodCta  = cb-ctas.CodCta NO-LOCK NO-ERROR.
    IF AVAILABLE cb-acmd
    THEN DISPLAY {&FIELDS-IN-QUERY-{&FRAME-NAME}} WITH FRAME FRAME-A.

    COMBO-nivel:LIST-ITEMS = cb-niveles.
    COMBO-nivel:SCREEN-VALUE = "".

    RUN enable_UI.
    APPLY "VALUE-CHANGED" TO BROWSE-1 IN FRAME FRAME-A.
    IF NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load WINDOW-1  _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "CBDCONSU.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chCtrlFrame = CtrlFrame:COM-HANDLE
    UIB_S = chCtrlFrame:LoadControls( OCXFile, "CtrlFrame":U)
    CtrlFrame:NAME = "CtrlFrame":U
  .
  RUN initialize-controls IN THIS-PROCEDURE NO-ERROR.
END.
ELSE MESSAGE "CBDCONSU.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI WINDOW-1  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(WINDOW-1)
  THEN DELETE WIDGET WINDOW-1.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI WINDOW-1  _DEFAULT-ENABLE
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
  RUN control_load.
  DISPLAY COMBO-moneda RADIO-SET-1 c-0 a-0 s-0 c-1 a-1 s-1 c-2 a-2 s-2 c-3 a-3 
          s-3 c-4 a-4 s-4 c-5 a-5 s-5 c-6 a-6 s-6 c-7 a-7 s-7 c-8 a-8 s-8 c-9 
          a-9 s-9 c-10 a-10 s-10 c-11 a-11 s-11 COMBO-nivel c-12 a-12 s-12 
          F-codcta c-13 a-13 s-13 F-CodDiv 
      WITH FRAME FRAME-A IN WINDOW WINDOW-1.
  ENABLE RECT-3 RECT-1 RECT-6 RECT-5 COMBO-moneda BROWSE-1 RADIO-SET-1 
         COMBO-nivel B-continuar F-codcta B-salir F-CodDiv 
      WITH FRAME FRAME-A IN WINDOW WINDOW-1.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-A}
  VIEW WINDOW-1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

