&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM2 SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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

DEF INPUT PARAMETER pCodCli AS CHAR.

/*
DEF VAR pCodCli AS CHAR.
pcodcli = '00000000196'.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME gDialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Origen-1 FILL-IN-Origen-2 ~
FILL-IN-Origen-3 FILL-IN-Origen-4 FILL-IN-Origen-5 FILL-IN-Origen-6 ~
FILL-IN-Total-1 FILL-IN-Total-2 FILL-IN-Total-3 FILL-IN-Importe-1 ~
FILL-IN-Importe-2 FILL-IN-Importe-3 FILL-IN-Importe-4 FILL-IN-Importe-5 ~
FILL-IN-Importe-6 FILL-IN-Importe-7 FILL-IN-Importe-8 FILL-IN-Importe-9 ~
FILL-IN-Importe-10 FILL-IN-Importe-11 FILL-IN-Importe-12 FILL-IN-Importe-13 ~
FILL-IN-Importe-14 FILL-IN-Importe-15 FILL-IN-Total-4 FILL-IN-Total-5 ~
FILL-IN-Total-6 FILL-IN-Cuadernos-1 FILL-IN-Cuadernos-2 FILL-IN-Cuadernos-3 ~
FILL-IN-Cuadernos-4 FILL-IN-Cuadernos-5 FILL-IN-Cuadernos-6 ~
FILL-IN-Cuadernos-7 FILL-IN-Cuadernos-8 FILL-IN-Cuadernos-9 FILL-IN-Total-7 ~
FILL-IN-Total-8 FILL-IN-Total-9 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "CONTINUAR" 
     SIZE 15 BY 1.15.

DEFINE VARIABLE FILL-IN-Cuadernos-1 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Cuadernos-2 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Cuadernos-3 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Cuadernos-4 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Cuadernos-5 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Cuadernos-6 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Cuadernos-7 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Cuadernos-8 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Cuadernos-9 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Importe-1 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Importe-10 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Importe-11 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Importe-12 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Importe-13 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Importe-14 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Importe-15 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Importe-2 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Importe-3 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Importe-4 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Importe-5 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Importe-6 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Importe-7 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Importe-8 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Importe-9 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Origen-1 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Origen-2 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Origen-3 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Origen-4 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Origen-5 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Origen-6 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Total-1 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-Total-2 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-Total-3 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-Total-4 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-Total-5 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-Total-6 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-Total-7 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-Total-8 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-Total-9 AS DECIMAL FORMAT "-ZZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     FILL-IN-Origen-1 AT ROW 6.19 COL 40 COLON-ALIGNED NO-LABEL WIDGET-ID 74
     FILL-IN-Origen-2 AT ROW 6.19 COL 55 COLON-ALIGNED NO-LABEL WIDGET-ID 78
     FILL-IN-Origen-3 AT ROW 6.19 COL 70 COLON-ALIGNED NO-LABEL WIDGET-ID 80
     FILL-IN-Origen-4 AT ROW 6.96 COL 40 COLON-ALIGNED NO-LABEL WIDGET-ID 82
     FILL-IN-Origen-5 AT ROW 6.96 COL 55 COLON-ALIGNED NO-LABEL WIDGET-ID 84
     FILL-IN-Origen-6 AT ROW 6.96 COL 70 COLON-ALIGNED NO-LABEL WIDGET-ID 86
     FILL-IN-Total-1 AT ROW 7.73 COL 40 COLON-ALIGNED NO-LABEL WIDGET-ID 138
     FILL-IN-Total-2 AT ROW 7.73 COL 55 COLON-ALIGNED NO-LABEL WIDGET-ID 140
     FILL-IN-Total-3 AT ROW 7.73 COL 70 COLON-ALIGNED NO-LABEL WIDGET-ID 142
     FILL-IN-Importe-1 AT ROW 8.88 COL 40 COLON-ALIGNED NO-LABEL WIDGET-ID 88
     FILL-IN-Importe-2 AT ROW 8.88 COL 55 COLON-ALIGNED NO-LABEL WIDGET-ID 90
     FILL-IN-Importe-3 AT ROW 8.88 COL 70 COLON-ALIGNED NO-LABEL WIDGET-ID 92
     FILL-IN-Importe-4 AT ROW 9.65 COL 40 COLON-ALIGNED NO-LABEL WIDGET-ID 94
     FILL-IN-Importe-5 AT ROW 9.65 COL 55 COLON-ALIGNED NO-LABEL WIDGET-ID 96
     FILL-IN-Importe-6 AT ROW 9.65 COL 70 COLON-ALIGNED NO-LABEL WIDGET-ID 98
     FILL-IN-Importe-7 AT ROW 10.42 COL 40 COLON-ALIGNED NO-LABEL WIDGET-ID 100
     FILL-IN-Importe-8 AT ROW 10.42 COL 55 COLON-ALIGNED NO-LABEL WIDGET-ID 102
     FILL-IN-Importe-9 AT ROW 10.42 COL 70 COLON-ALIGNED NO-LABEL WIDGET-ID 104
     FILL-IN-Importe-10 AT ROW 11.19 COL 40 COLON-ALIGNED NO-LABEL WIDGET-ID 106
     FILL-IN-Importe-11 AT ROW 11.19 COL 55 COLON-ALIGNED NO-LABEL WIDGET-ID 108
     FILL-IN-Importe-12 AT ROW 11.19 COL 70 COLON-ALIGNED NO-LABEL WIDGET-ID 110
     FILL-IN-Importe-13 AT ROW 11.96 COL 40 COLON-ALIGNED NO-LABEL WIDGET-ID 112
     FILL-IN-Importe-14 AT ROW 11.96 COL 55 COLON-ALIGNED NO-LABEL WIDGET-ID 114
     FILL-IN-Importe-15 AT ROW 11.96 COL 70 COLON-ALIGNED NO-LABEL WIDGET-ID 116
     FILL-IN-Total-4 AT ROW 12.73 COL 40 COLON-ALIGNED NO-LABEL WIDGET-ID 144
     FILL-IN-Total-5 AT ROW 12.73 COL 55 COLON-ALIGNED NO-LABEL WIDGET-ID 146
     FILL-IN-Total-6 AT ROW 12.73 COL 70 COLON-ALIGNED NO-LABEL WIDGET-ID 148
     FILL-IN-Cuadernos-1 AT ROW 13.88 COL 40 COLON-ALIGNED NO-LABEL WIDGET-ID 118
     FILL-IN-Cuadernos-2 AT ROW 13.88 COL 55 COLON-ALIGNED NO-LABEL WIDGET-ID 120
     FILL-IN-Cuadernos-3 AT ROW 13.88 COL 70 COLON-ALIGNED NO-LABEL WIDGET-ID 122
     FILL-IN-Cuadernos-4 AT ROW 14.65 COL 40 COLON-ALIGNED NO-LABEL WIDGET-ID 124
     FILL-IN-Cuadernos-5 AT ROW 14.65 COL 55 COLON-ALIGNED NO-LABEL WIDGET-ID 126
     FILL-IN-Cuadernos-6 AT ROW 14.65 COL 70 COLON-ALIGNED NO-LABEL WIDGET-ID 128
     FILL-IN-Cuadernos-7 AT ROW 15.42 COL 40 COLON-ALIGNED NO-LABEL WIDGET-ID 130
     FILL-IN-Cuadernos-8 AT ROW 15.42 COL 55 COLON-ALIGNED NO-LABEL WIDGET-ID 132
     FILL-IN-Cuadernos-9 AT ROW 15.42 COL 70 COLON-ALIGNED NO-LABEL WIDGET-ID 134
     FILL-IN-Total-7 AT ROW 16.19 COL 40 COLON-ALIGNED NO-LABEL WIDGET-ID 150
     FILL-IN-Total-8 AT ROW 16.19 COL 55 COLON-ALIGNED NO-LABEL WIDGET-ID 152
     FILL-IN-Total-9 AT ROW 16.19 COL 70 COLON-ALIGNED NO-LABEL WIDGET-ID 154
     Btn_OK AT ROW 17.92 COL 67
     "Total" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 4.46 COL 76 WIDGET-ID 136
          BGCOLOR 12 FGCOLOR 15 
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         DEFAULT-BUTTON Btn_OK WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME gDialog
     "Cuadernos Anillados" VIEW-AS TEXT
          SIZE 30 BY .62 AT ROW 15.62 COL 8 WIDGET-ID 36
     "ESTADISTICAS DE VENTAS 2012" VIEW-AS TEXT
          SIZE 30 BY .62 AT ROW 1.77 COL 31 WIDGET-ID 2
          FONT 6
     "Campaña" VIEW-AS TEXT
          SIZE 9 BY .62 AT ROW 3.69 COL 44 WIDGET-ID 4
          BGCOLOR 12 FGCOLOR 15 
     "No Campaña" VIEW-AS TEXT
          SIZE 13 BY .62 AT ROW 3.69 COL 58 WIDGET-ID 6
          BGCOLOR 12 FGCOLOR 15 
     "Dic - Mar / 2012" VIEW-AS TEXT
          SIZE 13 BY .62 AT ROW 4.46 COL 42 WIDGET-ID 8
          BGCOLOR 12 FGCOLOR 15 
     "Abr - Nov / 2012" VIEW-AS TEXT
          SIZE 14 BY .62 AT ROW 4.46 COL 57 WIDGET-ID 10
          BGCOLOR 12 FGCOLOR 15 
     "Por Origen (Importes)" VIEW-AS TEXT
          SIZE 21 BY .62 AT ROW 5.62 COL 2 WIDGET-ID 12
          BGCOLOR 1 FGCOLOR 15 
     "Productos Propios" VIEW-AS TEXT
          SIZE 30 BY .62 AT ROW 6.38 COL 8 WIDGET-ID 14
     "Productos de Terceros" VIEW-AS TEXT
          SIZE 30 BY .62 AT ROW 7.15 COL 8 WIDGET-ID 16
     "Por Tipo (Importes)" VIEW-AS TEXT
          SIZE 21 BY .62 AT ROW 8.31 COL 2 WIDGET-ID 18
          BGCOLOR 1 FGCOLOR 15 
     "Utiles" VIEW-AS TEXT
          SIZE 30 BY .62 AT ROW 9.08 COL 8 WIDGET-ID 20
     "Cuadernos" VIEW-AS TEXT
          SIZE 30 BY .62 AT ROW 9.85 COL 8 WIDGET-ID 22
     "Papelerias, incluye fotocopia" VIEW-AS TEXT
          SIZE 30 BY .62 AT ROW 10.62 COL 8 WIDGET-ID 24
     "Practiforros" VIEW-AS TEXT
          SIZE 30 BY .62 AT ROW 11.38 COL 8 WIDGET-ID 26
     "Otros" VIEW-AS TEXT
          SIZE 30 BY .62 AT ROW 12.15 COL 8 WIDGET-ID 28
     "Cuadernos (Unidades)" VIEW-AS TEXT
          SIZE 21 BY .62 AT ROW 13.31 COL 2 WIDGET-ID 30
          BGCOLOR 1 FGCOLOR 15 
     "Cuadernos Escolares Colores" VIEW-AS TEXT
          SIZE 30 BY .62 AT ROW 14.08 COL 8 WIDGET-ID 32
     "Cuadernos Escolares con Diseño" VIEW-AS TEXT
          SIZE 30 BY .62 AT ROW 14.85 COL 8 WIDGET-ID 34
     SPACE(55.99) SKIP(4.29)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "ESTADISTICAS"
         DEFAULT-BUTTON Btn_OK WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Cuadernos-1 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Cuadernos-2 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Cuadernos-3 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Cuadernos-4 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Cuadernos-5 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Cuadernos-6 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Cuadernos-7 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Cuadernos-8 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Cuadernos-9 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Importe-1 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Importe-10 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Importe-11 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Importe-12 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Importe-13 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Importe-14 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Importe-15 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Importe-2 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Importe-3 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Importe-4 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Importe-5 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Importe-6 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Importe-7 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Importe-8 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Importe-9 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Origen-1 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Origen-2 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Origen-3 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Origen-4 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Origen-5 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Origen-6 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Total-1 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Total-2 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Total-3 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Total-4 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Total-5 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Total-6 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Total-7 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Total-8 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Total-9 IN FRAME gDialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* ESTADISTICAS */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-Origen-1 FILL-IN-Origen-2 FILL-IN-Origen-3 FILL-IN-Origen-4 
          FILL-IN-Origen-5 FILL-IN-Origen-6 FILL-IN-Total-1 FILL-IN-Total-2 
          FILL-IN-Total-3 FILL-IN-Importe-1 FILL-IN-Importe-2 FILL-IN-Importe-3 
          FILL-IN-Importe-4 FILL-IN-Importe-5 FILL-IN-Importe-6 
          FILL-IN-Importe-7 FILL-IN-Importe-8 FILL-IN-Importe-9 
          FILL-IN-Importe-10 FILL-IN-Importe-11 FILL-IN-Importe-12 
          FILL-IN-Importe-13 FILL-IN-Importe-14 FILL-IN-Importe-15 
          FILL-IN-Total-4 FILL-IN-Total-5 FILL-IN-Total-6 FILL-IN-Cuadernos-1 
          FILL-IN-Cuadernos-2 FILL-IN-Cuadernos-3 FILL-IN-Cuadernos-4 
          FILL-IN-Cuadernos-5 FILL-IN-Cuadernos-6 FILL-IN-Cuadernos-7 
          FILL-IN-Cuadernos-8 FILL-IN-Cuadernos-9 FILL-IN-Total-7 
          FILL-IN-Total-8 FILL-IN-Total-9 
      WITH FRAME gDialog.
  ENABLE Btn_OK 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject gDialog 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FOR EACH w-report NO-LOCK WHERE task-no = 666
      AND Llave-C = pCodCli:
      CASE Llave-I:
          WHEN 10 THEN DO:
              CASE Campo-C[1]:
                  WHEN "Productos Propios" THEN DO:
                      FILL-IN-Origen-1 = Campo-F[1].
                      FILL-IN-Origen-2 = Campo-F[2].
                  END.
                  WHEN "Productos terceros" THEN DO:
                      FILL-IN-Origen-4 = Campo-F[1].
                      FILL-IN-Origen-5 = Campo-F[2].
                  END.
              END CASE.
          END.
          WHEN 20 THEN DO:
              CASE Campo-C[1]:
                  WHEN "Utiles" THEN DO:
                      FILL-IN-Importe-1 = Campo-F[1].
                      FILL-IN-Importe-2 = Campo-F[2].
                  END.
                  WHEN "Cuadernos" THEN DO:
                      FILL-IN-Importe-4 = Campo-F[1].
                      FILL-IN-Importe-5 = Campo-F[2].
                  END.
                  WHEN "Papelerias incluye fotocopia" THEN DO:
                      FILL-IN-Importe-7 = Campo-F[1].
                      FILL-IN-Importe-8 = Campo-F[2].
                  END.
                  WHEN "Practiforros" THEN DO:
                      FILL-IN-Importe-10 = Campo-F[1].
                      FILL-IN-Importe-11 = Campo-F[2].
                  END.
                  WHEN "Otros" THEN DO:
                      FILL-IN-Importe-13 = Campo-F[1].
                      FILL-IN-Importe-14 = Campo-F[2].
                  END.
              END CASE.
          END.
          WHEN 30 THEN DO:
              CASE Campo-C[1]:
                  WHEN "Cuadernos escolares colores" THEN DO:
                      FILL-IN-Cuadernos-1 = Campo-F[3].
                      FILL-IN-Cuadernos-2 = Campo-F[4].
                  END.
                  WHEN "Cuadernos escolares con diseños" THEN DO:
                      FILL-IN-Cuadernos-4 = Campo-F[3].
                      FILL-IN-Cuadernos-5 = Campo-F[4].
                  END.
                  WHEN "Cuadernos anillados" THEN DO:
                      FILL-IN-Cuadernos-7 = Campo-F[3].
                      FILL-IN-Cuadernos-8 = Campo-F[4].
                  END.
              END CASE.
          END.
      END CASE.
  END.
  ASSIGN
      FILL-IN-Origen-3 = FILL-IN-Origen-1 + FILL-IN-Origen-2
      FILL-IN-Origen-6 = FILL-IN-Origen-4 + FILL-IN-Origen-5
      FILL-IN-Importe-3 = FILL-IN-Importe-1 + FILL-IN-Importe-2 
      FILL-IN-Importe-6 = FILL-IN-Importe-4 + FILL-IN-Importe-5 
      FILL-IN-Importe-9 = FILL-IN-Importe-7 + FILL-IN-Importe-8 
      FILL-IN-Importe-12 = FILL-IN-Importe-10 + FILL-IN-Importe-11
      FILL-IN-Importe-15 = FILL-IN-Importe-13 + FILL-IN-Importe-14
      FILL-IN-Cuadernos-3 = FILL-IN-Cuadernos-1 + FILL-IN-Cuadernos-2
      FILL-IN-Cuadernos-6 = FILL-IN-Cuadernos-4 + FILL-IN-Cuadernos-5
      FILL-IN-Cuadernos-9 = FILL-IN-Cuadernos-7 + FILL-IN-Cuadernos-8.
  ASSIGN
      FILL-IN-Total-1 = FILL-IN-Origen-1 + FILL-IN-Origen-4
      FILL-IN-Total-2 = FILL-IN-Origen-2 + FILL-IN-Origen-5
      FILL-IN-Total-3 = FILL-IN-Total-1 + FILL-IN-Total-2
      FILL-IN-Total-4 = FILL-IN-Importe-1 + FILL-IN-Importe-4 + FILL-IN-Importe-7 + FILL-IN-Importe-10 + FILL-IN-Importe-13
      FILL-IN-Total-5 = FILL-IN-Importe-2 + FILL-IN-Importe-5 + FILL-IN-Importe-8 + FILL-IN-Importe-11 + FILL-IN-Importe-14
      FILL-IN-Total-6 = FILL-IN-Total-4 + FILL-IN-Total-5
      FILL-IN-Total-7 = FILL-IN-Cuadernos-1 + FILL-IN-Cuadernos-4 + FILL-IN-Cuadernos-7
      FILL-IN-Total-8 = FILL-IN-Cuadernos-2 + FILL-IN-Cuadernos-5 + FILL-IN-Cuadernos-8
      FILL-IN-Total-9 = FILL-IN-Total-7 + FILL-IN-Total-8.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

