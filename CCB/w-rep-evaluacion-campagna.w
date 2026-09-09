&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER b-gn-clie FOR gn-clie.
DEFINE TEMP-TABLE t-gn-clie NO-UNDO LIKE gn-clie.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.

{ccb/i-evaluacion-campagna-table.i}

/* DEF TEMP-TABLE Detalle NO-UNDO                                                        */
/*     FIELD CodCli AS CHAR FORMAT 'x(15)' LABEL 'CODIGO'                                */
/*     FIELD RucCli AS CHAR FORMAT 'x(15)' LABEL 'RUC'                                   */
/*     FIELD NomCli AS CHAR FORMAT 'x(100)' LABEL 'CLIENTE'                              */
/*     FIELD Grupo  AS CHAR FORMAT 'x(15)' LABEL 'GRUPO'                                 */
/*     FIELD NomGrupo AS CHAR FORMAT 'x(100)' LABEL 'NOMBRE GRUPO'                       */
/*     FIELD Departamento AS CHAR FORMAT 'x(30)' LABEL 'DEPARTAMENTO'                    */
/*     FIELD Desde     AS INTE FORMAT '9999'               LABEL 'CLIENTE DESDE'         */
/*     FIELD Saldo    AS DECI FORMAT '->>>,>>>,>>9.99'     LABEL 'DEUDA ACTUAL'          */
/*     /* Línea 9 */                                                                     */
/*     FIELD LinCred01 AS DECI FORMAT '>>>,>>>,>>9.99'     LABEL 'LC CAMPANA'            */
/*     FIELD LinCred02 AS DECI FORMAT '>>>,>>>,>>9.99'     LABEL 'LC CAMPANA'            */
/*     FIELD LinCred03 AS DECI FORMAT '>>>,>>>,>>9.99'     LABEL 'LC CAMPANA'            */
/*     FIELD LinCred04 AS DECI FORMAT '>>>,>>>,>>9.99'     LABEL 'LC CAMPANA'            */
/*     FIELD LinCred05 AS DECI FORMAT '>>>,>>>,>>9.99'     LABEL 'LC CAMPANA'            */
/*     /* Línea 14 */                                                                    */
/*     FIELD Compras_01 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS'                 */
/*     FIELD Compras_02 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS'                 */
/*     FIELD Compras_03 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS'                 */
/*     FIELD Compras_04 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS'                 */
/*     FIELD Compras_05 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS'                 */
/*     FIELD Protesto AS DECI FORMAT '>>>,>>>,>>9.99' LABEL 'PROTESTO'                   */
/*     FIELD Nros_Protesto AS CHAR FORMAT 'x(40)' LABEL 'LETRAS EN PROTESTO'             */
/*     FIELD Qty_Protesto AS INTE FORMAT '>>9' LABEL '#LETRAS EN PROTESTO'               */
/*     FIELD Refinanciacion AS DECI FORMAT '>>>,>>>,>>9.99' LABEL 'REFINANCIAMIENTO'     */
/*     /* Línea 23 */                                                                    */
/*     FIELD Compras_01_01 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 001'    */
/*     FIELD Compras_01_02 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 010'    */
/*     FIELD Compras_01_03 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 012'    */
/*     FIELD Compras_01_04 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 013'    */
/*     FIELD Compras_01_05 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS OTRAS LINEAS' */
/*     /* Línea 34 */                                                                    */
/*     FIELD Compras_02_01 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 001'    */
/*     FIELD Compras_02_02 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 010'    */
/*     FIELD Compras_02_03 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 012'    */
/*     FIELD Compras_02_04 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 013'    */
/*     FIELD Compras_02_05 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS OTRAS LINEAS' */
/*     /* Línea 45 */                                                                    */
/*     FIELD Compras_03_01 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 001'    */
/*     FIELD Compras_03_02 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 010'    */
/*     FIELD Compras_03_03 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 012'    */
/*     FIELD Compras_03_04 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 013'    */
/*     FIELD Compras_03_05 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS OTRAS LINEAS' */
/*     /* Línea 56 */                                                                    */
/*     FIELD Compras_04_01 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 001'    */
/*     FIELD Compras_04_02 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 010'    */
/*     FIELD Compras_04_03 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 012'    */
/*     FIELD Compras_04_04 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 013'    */
/*     FIELD Compras_04_05 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS OTRAS LINEAS' */
/*     /* Línea 67 */                                                                    */
/*     FIELD Compras_05_01 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 001'    */
/*     FIELD Compras_05_02 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 010'    */
/*     FIELD Compras_05_03 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 012'    */
/*     FIELD Compras_05_04 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 013'    */
/*     FIELD Compras_05_05 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS OTRAS LINEAS' */
/*     INDEX Llave01 AS PRIMARY codcli                                                   */
/*     INDEX Llave02 grupo                                                               */
/*     .                                                                                 */

DEF VAR x-Periodo-Final AS INTE INIT 2024 NO-UNDO.
DEF VAR x-Periodo-Inicial AS INTE NO-UNDO.

x-Periodo-Inicial = x-Periodo-Final - 4.


DEFINE IMAGE IMAGE-1 FILENAME "IMG\AUXILIAR" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR NO-UNDO.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
    SKIP
    Fi-Mensaje FORMAT 'x(50)' NO-LABEL FONT 6
    SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
    SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
    BGCOLOR 15 FGCOLOR 0 
    TITLE "Procesando ..." FONT 7.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS TOGGLE-Nocturno TOGGLE-Solo-Ruc ~
TOGGLE-Vcto_Linea_Credito FILL-IN-Periodo FILL-IN-FchIni-1 FILL-IN-FchFin-1 ~
FILL-IN-FchIni-2 FILL-IN-FchFin-2 FILL-IN-FchIni-3 FILL-IN-FchFin-3 ~
FILL-IN-FchIni-4 FILL-IN-FchFin-4 FILL-IN-FchIni-5 FILL-IN-FchFin-5 ~
BUTTON-1 BtnDone RECT-1 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS TOGGLE-Nocturno TOGGLE-Solo-Ruc ~
TOGGLE-Vcto_Linea_Credito FILL-IN-Periodo FILL-IN-Campana-1 ~
FILL-IN-FchIni-1 FILL-IN-FchFin-1 FILL-IN-Campana-2 FILL-IN-FchIni-2 ~
FILL-IN-FchFin-2 FILL-IN-Campana-3 FILL-IN-FchIni-3 FILL-IN-FchFin-3 ~
FILL-IN-Campana-4 FILL-IN-FchIni-4 FILL-IN-FchFin-4 FILL-IN-Campana-5 ~
FILL-IN-FchIni-5 FILL-IN-FchFin-5 FILL-IN-FchVto-1 FILL-IN-FchVto-2 ~
FILL-IN-FchVto-3 FILL-IN-FchVto-4 FILL-IN-FchVto-5 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 10 BY 2.15
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "PROCESAR" 
     SIZE 33 BY 2.69
     FONT 8.

DEFINE BUTTON BUTTON-Nocturno-1  NO-FOCUS FLAT-BUTTON
     LABEL "Se ha detectado un proceso nocturno programado" 
     SIZE 43 BY .69
     BGCOLOR 12 FGCOLOR 15 FONT 6.

DEFINE BUTTON BUTTON-Nocturno-2  NO-FOCUS FLAT-BUTTON
     LABEL "Haz clic aquí para revisarlo" 
     SIZE 24 BY .69
     BGCOLOR 12 FGCOLOR 15 FONT 6.

DEFINE VARIABLE FILL-IN-Campana-1 AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Campaña" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Campana-2 AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Campaña" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Campana-3 AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Campaña" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Campana-4 AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Campaña" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Campana-5 AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Campaña" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchFin-1 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchFin-2 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchFin-3 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchFin-4 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchFin-5 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchIni-1 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchIni-2 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchIni-3 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchIni-4 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchIni-5 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchVto-1 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchVto-2 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchVto-3 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchVto-4 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchVto-5 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Periodo AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Periodo de corte" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.08
     BGCOLOR 14 FGCOLOR 0 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.92.

DEFINE VARIABLE TOGGLE-Nocturno AS LOGICAL INITIAL no 
     LABEL "Programarlo como proceso nocturno" 
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Solo-Ruc AS LOGICAL INITIAL yes 
     LABEL "Solo clientes con RUC" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Vcto_Linea_Credito AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .54
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-Nocturno-1 AT ROW 12.04 COL 37 WIDGET-ID 70
     BUTTON-Nocturno-2 AT ROW 12.85 COL 37 WIDGET-ID 68
     TOGGLE-Nocturno AT ROW 11.23 COL 37 WIDGET-ID 64
     TOGGLE-Solo-Ruc AT ROW 1.81 COL 41 WIDGET-ID 62
     TOGGLE-Vcto_Linea_Credito AT ROW 3.42 COL 60 WIDGET-ID 50
     FILL-IN-Periodo AT ROW 1.54 COL 19 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-Campana-1 AT ROW 4.5 COL 11 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-FchIni-1 AT ROW 4.5 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     FILL-IN-FchFin-1 AT ROW 4.5 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     FILL-IN-Campana-2 AT ROW 5.58 COL 11 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-FchIni-2 AT ROW 5.58 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     FILL-IN-FchFin-2 AT ROW 5.58 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     FILL-IN-Campana-3 AT ROW 6.65 COL 11 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-FchIni-3 AT ROW 6.65 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     FILL-IN-FchFin-3 AT ROW 6.65 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     FILL-IN-Campana-4 AT ROW 7.73 COL 11 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-FchIni-4 AT ROW 7.73 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     FILL-IN-FchFin-4 AT ROW 7.73 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     FILL-IN-Campana-5 AT ROW 8.81 COL 11 COLON-ALIGNED WIDGET-ID 18
     FILL-IN-FchIni-5 AT ROW 8.81 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     FILL-IN-FchFin-5 AT ROW 8.81 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     BUTTON-1 AT ROW 10.42 COL 3 WIDGET-ID 2
     BtnDone AT ROW 10.42 COL 82 WIDGET-ID 4
     FILL-IN-FchVto-1 AT ROW 4.5 COL 61 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     FILL-IN-FchVto-2 AT ROW 5.58 COL 61 COLON-ALIGNED NO-LABEL WIDGET-ID 54
     FILL-IN-FchVto-3 AT ROW 6.65 COL 61 COLON-ALIGNED NO-LABEL WIDGET-ID 56
     FILL-IN-FchVto-4 AT ROW 7.73 COL 61 COLON-ALIGNED NO-LABEL WIDGET-ID 58
     FILL-IN-FchVto-5 AT ROW 8.81 COL 61 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     "CAMPAÑAS" VIEW-AS TEXT
          SIZE 12 BY .62 AT ROW 3.42 COL 12 WIDGET-ID 40
          BGCOLOR 14 FGCOLOR 0 FONT 6
     "FECHAS" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 3.42 COL 38 WIDGET-ID 42
          BGCOLOR 14 FGCOLOR 0 FONT 6
     "VENCIMIENTO LINEA DE CREDITO" VIEW-AS TEXT
          SIZE 30 BY .62 AT ROW 3.42 COL 62 WIDGET-ID 48
          BGCOLOR 14 FGCOLOR 0 FONT 6
     RECT-1 AT ROW 3.15 COL 3 WIDGET-ID 44
     RECT-2 AT ROW 4.23 COL 3 WIDGET-ID 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 94.72 BY 12.77 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: b-gn-clie B "?" ? INTEGRAL gn-clie
      TABLE: t-gn-clie T "?" NO-UNDO INTEGRAL gn-clie
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "REPORTE DE EVALUACION COMERCIAL"
         HEIGHT             = 12.77
         WIDTH              = 94.72
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 144.29
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 144.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR BUTTON BUTTON-Nocturno-1 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-Nocturno-1:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-Nocturno-2 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-Nocturno-2:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Campana-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Campana-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Campana-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Campana-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Campana-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchVto-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchVto-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchVto-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchVto-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchVto-5 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE EVALUACION COMERCIAL */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE EVALUACION COMERCIAL */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* PROCESAR */
DO:
    ASSIGN
        FILL-IN-Campana-1 FILL-IN-Campana-2 FILL-IN-Campana-3 FILL-IN-Campana-4 FILL-IN-Campana-5 
        FILL-IN-FchFin-1 FILL-IN-FchFin-2 FILL-IN-FchFin-3 FILL-IN-FchFin-4 FILL-IN-FchFin-5 
        FILL-IN-FchIni-1 FILL-IN-FchIni-2 FILL-IN-FchIni-3 FILL-IN-FchIni-4 FILL-IN-FchIni-5
        .
    ASSIGN
        FILL-IN-FchVto-1 FILL-IN-FchVto-2 FILL-IN-FchVto-3 FILL-IN-FchVto-4 FILL-IN-FchVto-5 
        TOGGLE-Vcto_Linea_Credito
        .
    ASSIGN
        TOGGLE-Solo-Ruc.

    ASSIGN TOGGLE-Nocturno.

    IF NOT TOGGLE-Nocturno THEN DO:
        RUN Imprimir.
    END.
    ELSE DO:
        MESSAGE 'Se va a proceder a programar el proceso nocturno' SKIP
            'Continuamos?' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.
        RUN Proceso-Nocturno.
    END.
    TOGGLE-Nocturno:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "NO".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Nocturno-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Nocturno-2 W-Win
ON CHOOSE OF BUTTON-Nocturno-2 IN FRAME F-Main /* Haz clic aquí para revisarlo */
DO:
  RUN ccb/d-rep-evaluacion-campagna.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Periodo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Periodo W-Win
ON LEAVE OF FILL-IN-Periodo IN FRAME F-Main /* Periodo de corte */
DO:
  RUN Carga-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-Vcto_Linea_Credito
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-Vcto_Linea_Credito W-Win
ON VALUE-CHANGED OF TOGGLE-Vcto_Linea_Credito IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  IF {&self-name} = YES THEN DO:
      ENABLE FILL-IN-FchVto-1 FILL-IN-FchVto-2 FILL-IN-FchVto-3 FILL-IN-FchVto-4 FILL-IN-FchVto-5 WITH FRAME {&FRAME-NAME}.
  END.
  ELSE DO:
      DISABLE FILL-IN-FchVto-1 FILL-IN-FchVto-2 FILL-IN-FchVto-3 FILL-IN-FchVto-4 FILL-IN-FchVto-5 WITH FRAME {&FRAME-NAME}.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}



/* Rutinas Generales */
{ccb/i-rep-evaluacion-campagna.i &TERMINAL-WINDOWS=YES}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE Detalle.

RUN Deuda-Actual.

RUN Compras. 

RUN Letras-Protestadas.

RUN Refinanciamientos. 

RUN Linea-de-credito.

RUN Datos-Finales.

DEF VAR hDetalle AS HANDLE NO-UNDO.
DEF VAR hDetalleField AS HANDLE NO-UNDO.

hDetalle = TEMP-TABLE Detalle:HANDLE.
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("LinCred01"):LABEL  = "LC CAMPANA " + STRING(FILL-IN-Campana-1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("LinCred02"):LABEL = "LC CAMPANA " + STRING(FILL-IN-Campana-2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("LinCred03"):LABEL = "LC CAMPANA " + STRING(FILL-IN-Campana-3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("LinCred04"):LABEL = "LC CAMPANA " + STRING(FILL-IN-Campana-4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("LinCred05"):LABEL = "LC CAMPANA " + STRING(FILL-IN-Campana-5,'>>>9').

hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_01"):LABEL = "COMPRAS " + STRING(FILL-IN-Campana-1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_02"):LABEL = "COMPRAS " + STRING(FILL-IN-Campana-2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_03"):LABEL = "COMPRAS " + STRING(FILL-IN-Campana-3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_04"):LABEL = "COMPRAS " + STRING(FILL-IN-Campana-4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_05"):LABEL = "COMPRAS " + STRING(FILL-IN-Campana-5,'>>>9').

hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_01_01"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_01_01"):LABEL + " " + STRING(FILL-IN-Campana-1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_01_02"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_01_02"):LABEL + " " + STRING(FILL-IN-Campana-1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_01_06"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_01_06"):LABEL + " " + STRING(FILL-IN-Campana-1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_01_03"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_01_03"):LABEL + " " + STRING(FILL-IN-Campana-1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_01_04"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_01_04"):LABEL + " " + STRING(FILL-IN-Campana-1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_01_05"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_01_05"):LABEL + " " + STRING(FILL-IN-Campana-1,'>>>9').

hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_02_01"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_02_01"):LABEL + " " + STRING(FILL-IN-Campana-2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_02_02"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_02_02"):LABEL + " " + STRING(FILL-IN-Campana-2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_02_06"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_02_06"):LABEL + " " + STRING(FILL-IN-Campana-2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_02_03"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_02_03"):LABEL + " " + STRING(FILL-IN-Campana-2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_02_04"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_02_04"):LABEL + " " + STRING(FILL-IN-Campana-2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_02_05"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_02_05"):LABEL + " " + STRING(FILL-IN-Campana-2,'>>>9').

hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_03_01"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_03_01"):LABEL + " " + STRING(FILL-IN-Campana-3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_03_02"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_03_02"):LABEL + " " + STRING(FILL-IN-Campana-3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_03_06"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_03_06"):LABEL + " " + STRING(FILL-IN-Campana-3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_03_03"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_03_03"):LABEL + " " + STRING(FILL-IN-Campana-3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_03_04"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_03_04"):LABEL + " " + STRING(FILL-IN-Campana-3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_03_05"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_03_05"):LABEL + " " + STRING(FILL-IN-Campana-3,'>>>9').

hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_04_01"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_04_01"):LABEL + " " + STRING(FILL-IN-Campana-4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_04_02"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_04_02"):LABEL + " " + STRING(FILL-IN-Campana-4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_04_06"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_04_06"):LABEL + " " + STRING(FILL-IN-Campana-4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_04_03"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_04_03"):LABEL + " " + STRING(FILL-IN-Campana-4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_04_04"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_04_04"):LABEL + " " + STRING(FILL-IN-Campana-4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_04_05"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_04_05"):LABEL + " " + STRING(FILL-IN-Campana-4,'>>>9').

hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_05_01"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_05_01"):LABEL + " " + STRING(FILL-IN-Campana-5,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_05_02"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_05_02"):LABEL + " " + STRING(FILL-IN-Campana-5,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_05_06"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_05_06"):LABEL + " " + STRING(FILL-IN-Campana-5,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_05_03"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_05_03"):LABEL + " " + STRING(FILL-IN-Campana-5,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_05_04"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_05_04"):LABEL + " " + STRING(FILL-IN-Campana-5,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_05_05"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_05_05"):LABEL + " " + STRING(FILL-IN-Campana-5,'>>>9').

END PROCEDURE.

/*
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(15):LABEL  = "LC CAMPANA " + STRING(FILL-IN-Campana-1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(16):LABEL = "LC CAMPANA " + STRING(FILL-IN-Campana-2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(17):LABEL = "LC CAMPANA " + STRING(FILL-IN-Campana-3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(18):LABEL = "LC CAMPANA " + STRING(FILL-IN-Campana-4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(19):LABEL = "LC CAMPANA " + STRING(FILL-IN-Campana-5,'>>>9').

hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(20):LABEL = "COMPRAS " + STRING(FILL-IN-Campana-1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(21):LABEL = "COMPRAS " + STRING(FILL-IN-Campana-2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(22):LABEL = "COMPRAS " + STRING(FILL-IN-Campana-3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(23):LABEL = "COMPRAS " + STRING(FILL-IN-Campana-4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(24):LABEL = "COMPRAS " + STRING(FILL-IN-Campana-5,'>>>9').

hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(29):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(29):LABEL + " " + STRING(FILL-IN-Campana-1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(30):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(30):LABEL + " " + STRING(FILL-IN-Campana-1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(31):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(31):LABEL + " " + STRING(FILL-IN-Campana-1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(32):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(32):LABEL + " " + STRING(FILL-IN-Campana-1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(33):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(33):LABEL + " " + STRING(FILL-IN-Campana-1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(34):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(34):LABEL + " " + STRING(FILL-IN-Campana-1,'>>>9').

hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(35):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(35):LABEL + " " + STRING(FILL-IN-Campana-2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(36):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(36):LABEL + " " + STRING(FILL-IN-Campana-2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(37):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(37):LABEL + " " + STRING(FILL-IN-Campana-2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(38):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(38):LABEL + " " + STRING(FILL-IN-Campana-2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(39):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(39):LABEL + " " + STRING(FILL-IN-Campana-2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(40):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(40):LABEL + " " + STRING(FILL-IN-Campana-2,'>>>9').

hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(41):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(41):LABEL + " " + STRING(FILL-IN-Campana-3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(42):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(42):LABEL + " " + STRING(FILL-IN-Campana-3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(43):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(43):LABEL + " " + STRING(FILL-IN-Campana-3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(44):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(44):LABEL + " " + STRING(FILL-IN-Campana-3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(45):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(45):LABEL + " " + STRING(FILL-IN-Campana-3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(46):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(46):LABEL + " " + STRING(FILL-IN-Campana-3,'>>>9').

hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(47):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(47):LABEL + " " + STRING(FILL-IN-Campana-4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(48):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(48):LABEL + " " + STRING(FILL-IN-Campana-4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(49):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(49):LABEL + " " + STRING(FILL-IN-Campana-4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(50):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(50):LABEL + " " + STRING(FILL-IN-Campana-4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(51):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(51):LABEL + " " + STRING(FILL-IN-Campana-4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(52):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(52):LABEL + " " + STRING(FILL-IN-Campana-4,'>>>9').

hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(53):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(53):LABEL + " " + STRING(FILL-IN-Campana-5,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(54):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(54):LABEL + " " + STRING(FILL-IN-Campana-5,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(55):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(55):LABEL + " " + STRING(FILL-IN-Campana-5,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(56):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(56):LABEL + " " + STRING(FILL-IN-Campana-5,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(57):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(57):LABEL + " " + STRING(FILL-IN-Campana-5,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(58):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(58):LABEL + " " + STRING(FILL-IN-Campana-5,'>>>9').
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Variables W-Win 
PROCEDURE Carga-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR i AS INTE NO-UNDO.

DEF VAR x-Inicio AS INTE NO-UNDO.
DEF VAR x-FchIni AS DATE NO-UNDO.
DEF VAR x-FchFin AS DATE NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN FILL-IN-Periodo.
    x-Inicio = FILL-IN-Periodo.
    DO i = 1 TO 5:
        IF i = 1 THEN FILL-IN-Campana-5 = FILL-IN-Periodo.
        IF i = 2 THEN FILL-IN-Campana-4 = FILL-IN-Periodo - (i - 1).
        IF i = 3 THEN FILL-IN-Campana-3 = FILL-IN-Periodo - (i - 1).
        IF i = 4 THEN FILL-IN-Campana-2 = FILL-IN-Periodo - (i - 1).
        IF i = 5 THEN FILL-IN-Campana-1 = FILL-IN-Periodo - (i - 1).
    END.
    DISPLAY 
        FILL-IN-Campana-1
        FILL-IN-Campana-2
        FILL-IN-Campana-3
        FILL-IN-Campana-4
        FILL-IN-Campana-5.
    FILL-IN-FchIni-1 = DATE(10,01,FILL-IN-Campana-1 - 1).
    FILL-IN-FchFin-1 = DATE(04,30,FILL-IN-Campana-1).
    FILL-IN-FchVto-1 = DATE(03,31,FILL-IN-Campana-1).
    FILL-IN-FchIni-2 = DATE(10,01,FILL-IN-Campana-2 - 1).
    FILL-IN-FchFin-2 = DATE(04,30,FILL-IN-Campana-2).
    FILL-IN-FchVto-2 = DATE(03,31,FILL-IN-Campana-2).
    FILL-IN-FchIni-3 = DATE(10,01,FILL-IN-Campana-3 - 1).
    FILL-IN-FchFin-3 = DATE(04,30,FILL-IN-Campana-3).
    FILL-IN-FchVto-3 = DATE(03,31,FILL-IN-Campana-3).
    FILL-IN-FchIni-4 = DATE(10,01,FILL-IN-Campana-4 - 1).
    FILL-IN-FchFin-4 = DATE(04,30,FILL-IN-Campana-4).
    FILL-IN-FchVto-4 = DATE(03,31,FILL-IN-Campana-4).
    FILL-IN-FchIni-5 = DATE(10,01,FILL-IN-Campana-5 - 1).
    FILL-IN-FchFin-5 = DATE(04,30,FILL-IN-Campana-5).
    FILL-IN-FchVto-5 = DATE(03,31,FILL-IN-Campana-5).
    DISPLAY
        FILL-IN-FchFin-1 
        FILL-IN-FchFin-2 
        FILL-IN-FchFin-3 
        FILL-IN-FchFin-4 
        FILL-IN-FchFin-5 
        FILL-IN-FchIni-1 
        FILL-IN-FchIni-2 
        FILL-IN-FchIni-3 
        FILL-IN-FchIni-4 
        FILL-IN-FchIni-5
        FILL-IN-FchVto-1
        FILL-IN-FchVto-2
        FILL-IN-FchVto-3
        FILL-IN-FchVto-4
        FILL-IN-FchVto-5
        .
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  DISPLAY TOGGLE-Nocturno TOGGLE-Solo-Ruc TOGGLE-Vcto_Linea_Credito 
          FILL-IN-Periodo FILL-IN-Campana-1 FILL-IN-FchIni-1 FILL-IN-FchFin-1 
          FILL-IN-Campana-2 FILL-IN-FchIni-2 FILL-IN-FchFin-2 FILL-IN-Campana-3 
          FILL-IN-FchIni-3 FILL-IN-FchFin-3 FILL-IN-Campana-4 FILL-IN-FchIni-4 
          FILL-IN-FchFin-4 FILL-IN-Campana-5 FILL-IN-FchIni-5 FILL-IN-FchFin-5 
          FILL-IN-FchVto-1 FILL-IN-FchVto-2 FILL-IN-FchVto-3 FILL-IN-FchVto-4 
          FILL-IN-FchVto-5 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE TOGGLE-Nocturno TOGGLE-Solo-Ruc TOGGLE-Vcto_Linea_Credito 
         FILL-IN-Periodo FILL-IN-FchIni-1 FILL-IN-FchFin-1 FILL-IN-FchIni-2 
         FILL-IN-FchFin-2 FILL-IN-FchIni-3 FILL-IN-FchFin-3 FILL-IN-FchIni-4 
         FILL-IN-FchFin-4 FILL-IN-FchIni-5 FILL-IN-FchFin-5 BUTTON-1 BtnDone 
         RECT-1 RECT-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Pantalla de Impresión */
    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
    DEF VAR cArchivo AS CHAR.

    RUN lib/tt-file-to-onlytext (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    /* Cargamos la informacion al temporal */
    SESSION:SET-WAIT-STATE('GENERAL').

    RUN Carga-Temporal.

    /* Programas que generan el Excel */
    DISPLAY "GENERANDO TEXTO" @ fi-Mensaje WITH FRAME f-Proceso.

    cArchivo = LC(pArchivo).
    IF INDEX(pOptions, 'FileType:XLS') > 0 THEN SESSION:DATE-FORMAT = "mdy".
    RUN lib/tt-filev2 (TEMP-TABLE Detalle:HANDLE, cArchivo, pOptions).
    SESSION:DATE-FORMAT = "dmy".
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    SESSION:SET-WAIT-STATE('').
    HIDE FRAME f-Proceso.
    MESSAGE 'Proceso Concluido' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
      IF CAN-FIND(LAST evalcomparam WHERE evalcomparam.FlgEst = "C" AND evalcomparam.Fecha >= (TODAY - 1) NO-LOCK)
          THEN DO:
          BUTTON-Nocturno-1:VISIBLE = YES.
          BUTTON-Nocturno-2:VISIBLE = YES.
          BUTTON-Nocturno-1:SENSITIVE = YES.
          BUTTON-Nocturno-2:SENSITIVE = YES.
      END.
  END.
  FILL-IN-Periodo = YEAR(TODAY).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Carga-Variables.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Proceso-Nocturno W-Win 
PROCEDURE Proceso-Nocturno :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pMensaje AS CHAR NO-UNDO.

FIND FIRST evalcomparam WHERE evalcomparam.FlgEst = "P" EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
IF ERROR-STATUS:ERROR AND LOCKED(evalcomparam) THEN DO:
    {lib/mensaje-de-error.i &MensajeError="pMensaje"}
    MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.
IF NOT AVAILABLE evalcomparam THEN DO:
    CREATE evalcomparam.
    ASSIGN
        evalcomparam.Id_Parametros = NEXT-VALUE(seq_evalcomparam)
        .
END.
ASSIGN
    evalcomparam.Fecha = TODAY
    evalcomparam.FlgEst = "P"
    evalcomparam.Hora = STRING(TIME,"HH:MM:SS")
    evalcomparam.Usuario = s-user-id
    .
ASSIGN
    evalcomparam.Campana_1        = FILL-IN-Campana-1 
    evalcomparam.Campana_2        = FILL-IN-Campana-2
    evalcomparam.Campana_3        = FILL-IN-Campana-3 
    evalcomparam.Campana_4        = FILL-IN-Campana-4 
    evalcomparam.Campana_5        = FILL-IN-Campana-5 
    evalcomparam.FchFin_1         = FILL-IN-FchFin-1 
    evalcomparam.FchFin_2         = FILL-IN-FchFin-2
    evalcomparam.FchFin_3         = FILL-IN-FchFin-3
    evalcomparam.FchFin_4         = FILL-IN-FchFin-4
    evalcomparam.FchFin_5         = FILL-IN-FchFin-5
    evalcomparam.FchIni_1         = FILL-IN-FchIni-1 
    evalcomparam.FchIni_2         = FILL-IN-FchIni-2
    evalcomparam.FchIni_3         = FILL-IN-FchIni-3
    evalcomparam.FchIni_4         = FILL-IN-FchIni-4
    evalcomparam.FchIni_5         = FILL-IN-FchIni-5
    evalcomparam.FchVto_1         = FILL-IN-FchVto-1 
    evalcomparam.FchVto_2         = FILL-IN-FchVto-2
    evalcomparam.FchVto_3         = FILL-IN-FchVto-3
    evalcomparam.FchVto_4         = FILL-IN-FchVto-4
    evalcomparam.FchVto_5         = FILL-IN-FchVto-5
    evalcomparam.Periodo          = FILL-IN-Periodo 
    evalcomparam.Solo_Cliente_Ruc = TOGGLE-Solo-Ruc
    evalcomparam.Vcto_Linea_Credito = TOGGLE-Vcto_Linea_Credito
    .
RELEASE evalcomparam.
MESSAGE 'Programación nocturna realizada con éxito' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

