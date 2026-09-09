&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME    WINDOW-1
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

DEFINE {&NEW} SHARED VARIABLE s-periodo          AS INTEGER   INITIAL 1995.
DEFINE {&NEW} SHARED VARIABLE s-user-id       AS CHARACTER INITIAL "MIGUEL".
DEFINE {&NEW} SHARED VARIABLE cb-niveles AS CHARACTER INITIAL "2,3,4,5".
DEFINE {&NEW} SHARED VARIABLE s-NroMes          AS INTEGER   INITIAL 2.
DEFINE VARIABLE x-maxnivel  AS INTEGER.
DEFINE VARIABLE pto         AS LOGICAL.
DEFINE VARIABLE RegAct      AS RECID.
DEFINE VARIABLE RECID-stack AS RECID.
DEFINE VARIABLE x-saldoMn1  AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99" EXTENT 14.
DEFINE VARIABLE x-saldoMn2  AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99" EXTENT 14.
DEFINE VARIABLE i           AS INTEGER.

pto = SESSION:SET-WAIT-STATE("").
x-maxnivel = INTEGER(ENTRY(NUM-ENTRIES(cb-niveles),cb-niveles)).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* ********************  Preprocessor Definitions  ******************** */

/* Name of first Frame and/or Browse (alphabetically)                   */
&Scoped-define FRAME-NAME  FRAME-A
&Scoped-define BROWSE-NAME BROWSE-2

/* Custom List Definitions                                              */
&Scoped-define LIST-1 
&Scoped-define LIST-2 
&Scoped-define LIST-3 

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 integral.cb-auxi.Codaux ~
integral.cb-auxi.Nomaux 
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH integral.cb-auxi WHERE cb-auxi.CodCia = cb-ctas.CodCia AND ~
cb-auxi.Clfaux = cb-ctas.ClfAux NO-LOCK INDEXED-REPOSITION.
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 integral.cb-auxi
&Scoped-define TABLES-IN-QUERY-BROWSE-2 integral.cb-auxi 

/* Definitions for FRAME FRAME-A                                        */
&Scoped-define FIELDS-IN-QUERY-FRAME-A integral.cb-ctas.Codcta ~
integral.cb-ctas.Nomcta 
&Scoped-define ENABLED-FIELDS-IN-QUERY-FRAME-A integral.cb-ctas.Codcta 
&Scoped-define OPEN-BROWSERS-IN-QUERY-FRAME-A ~
    ~{&OPEN-QUERY-BROWSE-2}
&Scoped-define OPEN-QUERY-FRAME-A OPEN QUERY FRAME-A FOR EACH integral.cb-ctas ~
      WHERE cb-ctas.CodCia = y-CodCia ~
 AND LENGTH(cb-ctas.Codcta) = x-maxnivel ~
 AND cb-ctas.Codcta BEGINS "9" SHARE-LOCK.
&Scoped-define FIRST-TABLE-IN-QUERY-FRAME-A integral.cb-ctas
&Scoped-define TABLES-IN-QUERY-FRAME-A integral.cb-ctas 

/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR WINDOW-1 AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-continuar AUTO-GO 
     LABEL "&Continuar" 
     SIZE 10.29 BY .96.

DEFINE BUTTON B-salir AUTO-END-KEY 
     LABEL "&Salir" 
     SIZE 10.29 BY .96.

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "adeicon/y-combo"
     LABEL "Button 1" 
     SIZE 3 BY 1.08.

DEFINE VARIABLE COMBO-moneda AS CHARACTER FORMAT "X(8)":U INITIAL "S/." 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "S/.","US$" 
     SIZE 6.14 BY 1
     FONT 19 NO-UNDO.

DEFINE VARIABLE a-0 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE a-1 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE a-10 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE a-11 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE a-12 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE a-13 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE a-2 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE a-3 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE a-4 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE a-5 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE a-6 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE a-7 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE a-8 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE a-9 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE c-0 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE c-1 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE c-10 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE c-11 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE c-12 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE c-13 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE c-2 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE c-3 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE c-4 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE c-5 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE c-6 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE c-7 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE c-8 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE c-9 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE s-0 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE s-1 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE s-10 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE s-11 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE s-12 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE s-13 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE s-2 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE s-3 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE s-4 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE s-5 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE s-6 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE s-7 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE s-8 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE s-9 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FONT 2 NO-UNDO.

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
     SIZE 7 BY 14 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 52.86 BY 15.69
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 38 BY 10
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 38 BY 2.19
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 38 BY 3.5
     BGCOLOR 8 .


/* Query definitions                                                    */
DEFINE QUERY BROWSE-2 FOR integral.cb-auxi SCROLLING.
DEFINE QUERY FRAME-A FOR integral.cb-ctas SCROLLING.

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2 QUERY BROWSE-2 NO-LOCK DISPLAY 
      integral.cb-auxi.Codaux
      integral.cb-auxi.Nomaux
    WITH SEPARATORS SIZE 34 BY 9
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME FRAME-A
     COMBO-moneda AT ROW 1.27 COL 38.72 COLON-ALIGNED HELP
          "Seleccione una moneda" NO-LABEL
     integral.cb-ctas.Codcta AT ROW 1.69 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY 1
     BUTTON-1 AT ROW 1.69 COL 22
     RADIO-SET-1 AT ROW 2.38 COL 40 NO-LABEL
     c-0 AT ROW 2.5 COL 45 COLON-ALIGNED NO-LABEL
     a-0 AT ROW 2.5 COL 59.43 COLON-ALIGNED NO-LABEL
     s-0 AT ROW 2.5 COL 74 COLON-ALIGNED NO-LABEL
     integral.cb-ctas.Nomcta AT ROW 3 COL 1 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 34 BY 1
          BGCOLOR 1 FGCOLOR 15 FONT 2
     c-1 AT ROW 3.5 COL 45 COLON-ALIGNED NO-LABEL
     a-1 AT ROW 3.5 COL 59.43 COLON-ALIGNED NO-LABEL
     s-1 AT ROW 3.5 COL 74 COLON-ALIGNED NO-LABEL
     c-2 AT ROW 4.5 COL 45 COLON-ALIGNED NO-LABEL
     a-2 AT ROW 4.5 COL 59.43 COLON-ALIGNED NO-LABEL
     s-2 AT ROW 4.5 COL 74 COLON-ALIGNED NO-LABEL
     BROWSE-2 AT ROW 5 COL 3
     c-3 AT ROW 5.5 COL 45 COLON-ALIGNED NO-LABEL
     a-3 AT ROW 5.5 COL 59.43 COLON-ALIGNED NO-LABEL
     s-3 AT ROW 5.5 COL 74 COLON-ALIGNED NO-LABEL
     c-4 AT ROW 6.5 COL 45 COLON-ALIGNED NO-LABEL
     a-4 AT ROW 6.5 COL 59.43 COLON-ALIGNED NO-LABEL
     s-4 AT ROW 6.5 COL 74 COLON-ALIGNED NO-LABEL
     c-5 AT ROW 7.5 COL 45 COLON-ALIGNED NO-LABEL
     a-5 AT ROW 7.5 COL 59.43 COLON-ALIGNED NO-LABEL
     s-5 AT ROW 7.5 COL 74 COLON-ALIGNED NO-LABEL
     c-6 AT ROW 8.5 COL 45 COLON-ALIGNED NO-LABEL
     a-6 AT ROW 8.5 COL 59.43 COLON-ALIGNED NO-LABEL
     s-6 AT ROW 8.5 COL 74 COLON-ALIGNED NO-LABEL
     c-7 AT ROW 9.5 COL 45 COLON-ALIGNED NO-LABEL
     a-7 AT ROW 9.5 COL 59.43 COLON-ALIGNED NO-LABEL
     s-7 AT ROW 9.5 COL 74 COLON-ALIGNED NO-LABEL
     c-8 AT ROW 10.5 COL 45 COLON-ALIGNED NO-LABEL
     a-8 AT ROW 10.5 COL 59.43 COLON-ALIGNED NO-LABEL
     s-8 AT ROW 10.5 COL 74 COLON-ALIGNED NO-LABEL
     c-9 AT ROW 11.5 COL 45 COLON-ALIGNED NO-LABEL
     a-9 AT ROW 11.5 COL 59.43 COLON-ALIGNED NO-LABEL
     s-9 AT ROW 11.5 COL 74 COLON-ALIGNED NO-LABEL
     c-10 AT ROW 12.5 COL 45 COLON-ALIGNED NO-LABEL
     a-10 AT ROW 12.5 COL 59.43 COLON-ALIGNED NO-LABEL
     s-10 AT ROW 12.5 COL 74 COLON-ALIGNED NO-LABEL
     c-11 AT ROW 13.5 COL 45 COLON-ALIGNED NO-LABEL
     a-11 AT ROW 13.5 COL 59.43 COLON-ALIGNED NO-LABEL
     s-11 AT ROW 13.5 COL 74 COLON-ALIGNED NO-LABEL
     c-12 AT ROW 14.5 COL 45 COLON-ALIGNED NO-LABEL
     a-12 AT ROW 14.5 COL 59.43 COLON-ALIGNED NO-LABEL
     s-12 AT ROW 14.5 COL 74 COLON-ALIGNED NO-LABEL
     B-continuar AT ROW 15 COL 7
     B-salir AT ROW 15 COL 22
     c-13 AT ROW 15.5 COL 45 COLON-ALIGNED NO-LABEL
     a-13 AT ROW 15.5 COL 59.43 COLON-ALIGNED NO-LABEL
     s-13 AT ROW 15.5 COL 74 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1 COL 1
     RECT-1 AT ROW 1 COL 39
     "Cargo" VIEW-AS TEXT
          SIZE 6 BY .69 AT ROW 1.5 COL 52
          FONT 19
     "Abono" VIEW-AS TEXT
          SIZE 7 BY .69 AT ROW 1.5 COL 65
          FONT 19
     "Saldo" VIEW-AS TEXT
          SIZE 7 BY .69 AT ROW 1.5 COL 80
          FONT 19
     RECT-3 AT ROW 4.5 COL 1
     RECT-6 AT ROW 14.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.86 BY 15.69.

 

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW WINDOW-1 ASSIGN
         HIDDEN             = YES
         TITLE              = "Consulta de Costos"
         COLUMN             = 1
         ROW                = 1
         HEIGHT             = 15.69
         WIDTH              = 90.86
         MAX-HEIGHT         = 15.69
         MAX-WIDTH          = 90.86
         VIRTUAL-HEIGHT     = 15.69
         VIRTUAL-WIDTH      = 90.86
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
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW WINDOW-1
  VISIBLE,,RUN-PERSISTENT                                               */
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
   NO-ENABLE                                                            */
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
   NO-ENABLE                                                            */
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
/* SETTINGS FOR FILL-IN integral.cb-ctas.Nomcta IN FRAME FRAME-A
   NO-ENABLE                                                            */
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

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "integral.cb-auxi WHERE integral.cb-ctas <external> ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = ""
     _JoinCode[1]      = "cb-auxi.CodCia = cb-ctas.CodCia AND
cb-auxi.Clfaux = cb-ctas.ClfAux"
     _Where[1]         = ?
     _FldNameList[1]   = integral.cb-auxi.Codaux
     _FldNameList[2]   = integral.cb-auxi.Nomaux
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME FRAME-A
/* Query rebuild information for FRAME FRAME-A
     _TblList          = "integral.cb-ctas"
     _Options          = "SHARE-LOCK"
     _OrdList          = ""
     _JoinCode[1]      = ?
     _Where[1]         = "cb-ctas.CodCia = y-CodCia
 AND LENGTH(cb-ctas.Codcta) = x-maxnivel
 AND cb-ctas.Codcta BEGINS ""9"""
     _Query            is OPENED
*/  /* FRAME FRAME-A */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-continuar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-continuar WINDOW-1
ON CHOOSE OF B-continuar IN FRAME FRAME-A /* Continuar */
DO:
    s-NroMes = INTEGER(RADIO-SET-1:SCREEN-VALUE).
    RUN cbd/cbdcost2.w
        (cb-ctas.CodCta, cb-auxi.ClfAux, cb-auxi.CodAux, s-NroMes, y-codcia).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 WINDOW-1
ON VALUE-CHANGED OF BROWSE-2 IN FRAME FRAME-A
DO:
    RegAct = RECID(cb-auxi).
    FIND cb-acmd WHERE cb-acmd.CodCia    = s-codcia         AND
                       cb-acmd.Periodo   = s-periodo            AND
                       cb-acmd.CodCta    = cb-ctas.CodCta    AND
                       cb-acmd.CodAux    = cb-auxi.CodAux  AND
                       cb-acmd.CodDiv    = "" NO-LOCK NO-ERROR.
    IF AVAILABLE cb-acmd
    THEN DO:
        DO i = 1 TO 14:
            IF i = 1
            THEN x-saldoMn1[i] = DbeMn1[i] - HbeMn1[i].
            ELSE x-saldoMn1[i] =  x-saldoMn1[i - 1] + DbeMn1[i] - HbeMn1[i].
            IF i = 1
            THEN x-saldoMn2[i] = DbeMn2[i] - HbeMn2[i].
            ELSE x-saldoMn2[i] =  x-saldoMn2[i - 1] + DbeMn2[i] - HbeMn2[i].
        END.
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
    ELSE DO:
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
                     0 @ s-13
                     WITH FRAME FRAME-A.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 WINDOW-1
ON CHOOSE OF BUTTON-1 IN FRAME FRAME-A /* Button 1 */
DO:
    RUN cbd/q-ctas9.w(y-CodCia, OUTPUT RECID-stack).
    IF RECID-stack <> 0
    THEN DO:
        find cb-ctas WHERE RECID(cb-ctas) = RECID-stack
            NO-LOCK NO-ERROR.
        IF avail cb-ctas
        THEN DO:
            cb-ctas.CodCta:SCREEN-VALUE = cb-ctas.CodCta.
            cb-ctas.NomCta:SCREEN-VALUE = cb-ctas.NomCta.
            {&OPEN-QUERY-{&BROWSE-NAME}}
            APPLY "VALUE-CHANGED" TO BROWSE-2.
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME integral.cb-ctas.Codcta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.cb-ctas.Codcta WINDOW-1
ON F8 OF integral.cb-ctas.Codcta IN FRAME FRAME-A /* Cuenta */
DO:
    APPLY "CHOOSE" TO BUTTON-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.cb-ctas.Codcta WINDOW-1
ON LEAVE OF integral.cb-ctas.Codcta IN FRAME FRAME-A /* Cuenta */
DO:
    find cb-ctas WHERE cb-ctas.CodCia = y-CodCia             AND
                       cb-ctas.CodCta = INPUT cb-ctas.CodCta AND
                       cb-ctas.CodCta BEGINS "9"             AND
                       LENGTH(cb-ctas.CodCta) = x-maxnivel
                       NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas
    THEN APPLY "CHOOSE" TO BUTTON-1.
    ELSE DO:
        DISPLAY cb-ctas.NomCta WITH FRAME FRAME-A.
        {&OPEN-QUERY-{&BROWSE-NAME}}
        APPLY "VALUE-CHANGED" TO BROWSE-2.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-moneda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-moneda WINDOW-1
ON VALUE-CHANGED OF COMBO-moneda IN FRAME FRAME-A
DO:
    IF RECID(cb-auxi) = ? OR RegAct = ?
    THEN FIND FIRST cb-auxi WHERE cb-auxi.CodCia = y-CodCia       AND
                                   cb-auxi.ClfAux = cb-ctas.ClfAux
                                   NO-LOCK NO-ERROR.
    ELSE FIND cb-auxi WHERE RECID(cb-auxi) = RegAct
                                   NO-LOCK NO-ERROR.
    FIND cb-acmd WHERE cb-acmd.CodCia    = s-codcia AND
                       cb-acmd.Periodo   = s-periodo AND
                       cb-acmd.CodCta    = cb-ctas.CodCta AND
                       cb-acmd.CodAux    = cb-auxi.CodAux AND
                       cb-acmd.CodDiv    = "" NO-LOCK NO-ERROR.
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK WINDOW-1 


/* ***************************  Main Block  *************************** */

ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

ON WINDOW-CLOSE OF {&WINDOW-NAME} DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

ON ENDKEY, END-ERROR OF {&WINDOW-NAME} ANYWHERE DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

PAUSE 0 BEFORE-HIDE.

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    RUN enable_UI.
    FIND FIRST cb-auxi WHERE cb-auxi.CodCia = y-Codcia AND
                              cb-auxi.ClfAux = cb-ctas.ClfAux
                              NO-LOCK NO-ERROR.
    FIND cb-acmd WHERE cb-acmd.CodCia  = s-codcia        AND
                       cb-acmd.Periodo = s-periodo           AND
                       cb-acmd.CodCta  = cb-ctas.CodCta  AND
                       cb-acmd.CodAux  = cb-auxi.CodAux
                       NO-LOCK NO-ERROR.
    IF AVAILABLE cb-acmd THEN DO:
        DISPLAY {&FIELDS-IN-QUERY-{&FRAME-NAME}} WITH FRAME FRAME-A.
        APPLY "VALUE-CHANGED" TO BROWSE-2 IN FRAME FRAME-A.
    END.
    IF NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI WINDOW-1 _DEFAULT-DISABLE
PROCEDURE disable_UI :
/* --------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
   -------------------------------------------------------------------- */
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U THEN DELETE WIDGET WINDOW-1.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI WINDOW-1 _DEFAULT-ENABLE
PROCEDURE enable_UI :
/* --------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
   -------------------------------------------------------------------- */

  {&OPEN-QUERY-FRAME-A}
  GET FIRST FRAME-A.
  DISPLAY COMBO-moneda RADIO-SET-1 c-0 a-0 s-0 c-1 a-1 s-1 c-2 a-2 s-2 c-3 a-3 
          s-3 c-4 a-4 s-4 c-5 a-5 s-5 c-6 a-6 s-6 c-7 a-7 s-7 c-8 a-8 s-8 c-9 
          a-9 s-9 c-10 a-10 s-10 c-11 a-11 s-11 c-12 a-12 s-12 c-13 a-13 s-13 
      WITH FRAME FRAME-A IN WINDOW WINDOW-1.
  IF AVAILABLE integral.cb-ctas THEN 
    DISPLAY integral.cb-ctas.Codcta integral.cb-ctas.Nomcta 
      WITH FRAME FRAME-A IN WINDOW WINDOW-1.
  ENABLE RECT-7 RECT-1 COMBO-moneda integral.cb-ctas.Codcta BUTTON-1 
         RADIO-SET-1 RECT-3 BROWSE-2 RECT-6 B-continuar B-salir 
      WITH FRAME FRAME-A IN WINDOW WINDOW-1.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-A}
  VIEW WINDOW-1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE BROWSE-NAME
&UNDEFINE FRAME-NAME
&UNDEFINE WINDOW-NAME
