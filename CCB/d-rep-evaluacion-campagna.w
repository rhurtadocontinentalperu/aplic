&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
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

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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
FIND LAST evalcomparam WHERE evalcomparam.FlgEst = "C" AND evalcomparam.Fecha >= (TODAY - 1) NO-LOCK NO-ERROR.

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

{ccb/i-evaluacion-campagna-table.i}

/* DEF TEMP-TABLE Detalle NO-UNDO                                                     */
/*     FIELD CodCli AS CHAR FORMAT 'x(15)' LABEL 'CODIGO'                             */
/*     FIELD RucCli AS CHAR FORMAT 'x(15)' LABEL 'RUC'                                */
/*     FIELD NomCli AS CHAR FORMAT 'x(100)' LABEL 'CLIENTE'                           */
/*     FIELD Grupo  AS CHAR FORMAT 'x(15)' LABEL 'GRUPO'                              */
/*     FIELD NomGrupo AS CHAR FORMAT 'x(100)' LABEL 'NOMBRE GRUPO'                    */
/*     FIELD Departamento AS CHAR FORMAT 'x(30)' LABEL 'DEPARTAMENTO'                 */
/*     FIELD Desde     AS INTE FORMAT '9999'               LABEL 'CLIENTE DESDE'      */
/*     FIELD Saldo    AS DECI FORMAT '->>>,>>>,>>9.99'     LABEL 'DEUDA ACTUAL'       */
/*     /* Línea 9 */                                                                  */
/*     FIELD LinCred01 AS DECI FORMAT '>>>,>>>,>>9.99'     LABEL 'LC CAMPANA'         */
/*     FIELD LinCred02 AS DECI FORMAT '>>>,>>>,>>9.99'     LABEL 'LC CAMPANA'         */
/*     FIELD LinCred03 AS DECI FORMAT '>>>,>>>,>>9.99'     LABEL 'LC CAMPANA'         */
/*     FIELD LinCred04 AS DECI FORMAT '>>>,>>>,>>9.99'     LABEL 'LC CAMPANA'         */
/*     FIELD LinCred05 AS DECI FORMAT '>>>,>>>,>>9.99'     LABEL 'LC CAMPANA'         */
/*     /* Línea 14 */                                                                 */
/*     FIELD Compras_01 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS'              */
/*     FIELD Compras_02 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS'              */
/*     FIELD Compras_03 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS'              */
/*     FIELD Compras_04 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS'              */
/*     FIELD Compras_05 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS'              */
/*     FIELD Protesto AS DECI FORMAT '>>>,>>>,>>9.99' LABEL 'PROTESTO'                */
/*     FIELD Nros_Protesto AS CHAR FORMAT 'x(40)' LABEL 'LETRAS EN PROTESTO'          */
/*     FIELD Qty_Protesto AS INTE FORMAT '>>9' LABEL '#LETRAS EN PROTESTO'            */
/*     FIELD Refinanciacion AS DECI FORMAT '>>>,>>>,>>9.99' LABEL 'REFINANCIAMIENTO'  */
/*     /* Línea 23 */                                                                 */
/*     FIELD Compras_01_01 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 000' */
/*     FIELD Compras_01_02 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 001' */
/*     FIELD Compras_01_03 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 002' */
/*     FIELD Compras_01_04 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 005' */
/*     FIELD Compras_01_05 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 007' */
/*     FIELD Compras_01_06 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 010' */
/*     FIELD Compras_01_07 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 012' */
/*     FIELD Compras_01_08 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 013' */
/*     FIELD Compras_01_09 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 014' */
/*     FIELD Compras_01_10 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 017' */
/*     FIELD Compras_01_11 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 018' */
/*     /* Línea 34 */                                                                 */
/*     FIELD Compras_02_01 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 000' */
/*     FIELD Compras_02_02 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 001' */
/*     FIELD Compras_02_03 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 002' */
/*     FIELD Compras_02_04 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 005' */
/*     FIELD Compras_02_05 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 007' */
/*     FIELD Compras_02_06 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 010' */
/*     FIELD Compras_02_07 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 012' */
/*     FIELD Compras_02_08 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 013' */
/*     FIELD Compras_02_09 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 014' */
/*     FIELD Compras_02_10 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 017' */
/*     FIELD Compras_02_11 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 018' */
/*     /* Línea 45 */                                                                 */
/*     FIELD Compras_03_01 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 000' */
/*     FIELD Compras_03_02 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 001' */
/*     FIELD Compras_03_03 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 002' */
/*     FIELD Compras_03_04 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 005' */
/*     FIELD Compras_03_05 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 007' */
/*     FIELD Compras_03_06 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 010' */
/*     FIELD Compras_03_07 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 012' */
/*     FIELD Compras_03_08 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 013' */
/*     FIELD Compras_03_09 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 014' */
/*     FIELD Compras_03_10 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 017' */
/*     FIELD Compras_03_11 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 018' */
/*     /* Línea 56 */                                                                 */
/*     FIELD Compras_04_01 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 000' */
/*     FIELD Compras_04_02 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 001' */
/*     FIELD Compras_04_03 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 002' */
/*     FIELD Compras_04_04 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 005' */
/*     FIELD Compras_04_05 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 007' */
/*     FIELD Compras_04_06 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 010' */
/*     FIELD Compras_04_07 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 012' */
/*     FIELD Compras_04_08 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 013' */
/*     FIELD Compras_04_09 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 014' */
/*     FIELD Compras_04_10 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 017' */
/*     FIELD Compras_04_11 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 018' */
/*     /* Línea 67 */                                                                 */
/*     FIELD Compras_05_01 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 000' */
/*     FIELD Compras_05_02 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 001' */
/*     FIELD Compras_05_03 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 002' */
/*     FIELD Compras_05_04 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 005' */
/*     FIELD Compras_05_05 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 007' */
/*     FIELD Compras_05_06 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 010' */
/*     FIELD Compras_05_07 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 012' */
/*     FIELD Compras_05_08 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 013' */
/*     FIELD Compras_05_09 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 014' */
/*     FIELD Compras_05_10 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 017' */
/*     FIELD Compras_05_11 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 018' */
/*     INDEX Llave01 AS PRIMARY codcli                                                */
/*     INDEX Llave02 grupo                                                            */
/*     .                                                                              */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES evalcomparam

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define FIELDS-IN-QUERY-D-Dialog evalcomparam.Periodo ~
evalcomparam.Solo_Cliente_Ruc evalcomparam.Vcto_Linea_Credito ~
evalcomparam.Campana_1 evalcomparam.FchIni_1 evalcomparam.FchFin_1 ~
evalcomparam.FchVto_1 evalcomparam.Campana_2 evalcomparam.FchIni_2 ~
evalcomparam.FchFin_2 evalcomparam.FchVto_2 evalcomparam.Campana_3 ~
evalcomparam.FchIni_3 evalcomparam.FchFin_3 evalcomparam.FchVto_3 ~
evalcomparam.Campana_4 evalcomparam.FchIni_4 evalcomparam.FchFin_4 ~
evalcomparam.FchVto_4 evalcomparam.Campana_5 evalcomparam.FchIni_5 ~
evalcomparam.FchFin_5 evalcomparam.FchVto_5 
&Scoped-define QUERY-STRING-D-Dialog FOR EACH evalcomparam SHARE-LOCK
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH evalcomparam SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog evalcomparam
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog evalcomparam


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-FIELDS evalcomparam.Periodo ~
evalcomparam.Solo_Cliente_Ruc evalcomparam.Vcto_Linea_Credito ~
evalcomparam.Campana_1 evalcomparam.FchIni_1 evalcomparam.FchFin_1 ~
evalcomparam.FchVto_1 evalcomparam.Campana_2 evalcomparam.FchIni_2 ~
evalcomparam.FchFin_2 evalcomparam.FchVto_2 evalcomparam.Campana_3 ~
evalcomparam.FchIni_3 evalcomparam.FchFin_3 evalcomparam.FchVto_3 ~
evalcomparam.Campana_4 evalcomparam.FchIni_4 evalcomparam.FchFin_4 ~
evalcomparam.FchVto_4 evalcomparam.Campana_5 evalcomparam.FchIni_5 ~
evalcomparam.FchFin_5 evalcomparam.FchVto_5 
&Scoped-define DISPLAYED-TABLES evalcomparam
&Scoped-define FIRST-DISPLAYED-TABLE evalcomparam


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Salir" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Exportar" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.08
     BGCOLOR 14 FGCOLOR 0 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.92.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      evalcomparam SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     evalcomparam.Periodo AT ROW 1.27 COL 18 COLON-ALIGNED WIDGET-ID 42
          LABEL "Periodo de corte"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     evalcomparam.Solo_Cliente_Ruc AT ROW 1.27 COL 40 WIDGET-ID 58
          LABEL "Solo clientes con RUC"
          VIEW-AS TOGGLE-BOX
          SIZE 22 BY .77
     evalcomparam.Vcto_Linea_Credito AT ROW 2.5 COL 59 WIDGET-ID 56
          LABEL ""
          VIEW-AS TOGGLE-BOX
          SIZE 3 BY .77
          BGCOLOR 14 FGCOLOR 0 
     evalcomparam.Campana_1 AT ROW 3.69 COL 11 COLON-ALIGNED WIDGET-ID 2
          LABEL "Campaña"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     evalcomparam.FchIni_1 AT ROW 3.69 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     evalcomparam.FchFin_1 AT ROW 3.69 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     evalcomparam.FchVto_1 AT ROW 3.69 COL 60 COLON-ALIGNED NO-LABEL WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     evalcomparam.Campana_2 AT ROW 4.77 COL 11 COLON-ALIGNED WIDGET-ID 4
          LABEL "Campaña"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     evalcomparam.FchIni_2 AT ROW 4.77 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     evalcomparam.FchFin_2 AT ROW 4.77 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     evalcomparam.FchVto_2 AT ROW 4.77 COL 60 COLON-ALIGNED NO-LABEL WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     evalcomparam.Campana_3 AT ROW 5.85 COL 11 COLON-ALIGNED WIDGET-ID 6
          LABEL "Campaña"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     evalcomparam.FchIni_3 AT ROW 5.85 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     evalcomparam.FchFin_3 AT ROW 5.85 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     evalcomparam.FchVto_3 AT ROW 5.85 COL 60 COLON-ALIGNED NO-LABEL WIDGET-ID 36
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     evalcomparam.Campana_4 AT ROW 6.92 COL 11 COLON-ALIGNED WIDGET-ID 8
          LABEL "Campaña"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     evalcomparam.FchIni_4 AT ROW 6.92 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     evalcomparam.FchFin_4 AT ROW 6.92 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     evalcomparam.FchVto_4 AT ROW 6.92 COL 60 COLON-ALIGNED NO-LABEL WIDGET-ID 38
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     evalcomparam.Campana_5 AT ROW 8 COL 11 COLON-ALIGNED WIDGET-ID 10
          LABEL "Campaña"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     evalcomparam.FchIni_5 AT ROW 8 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     evalcomparam.FchFin_5 AT ROW 8 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     evalcomparam.FchVto_5 AT ROW 8 COL 60 COLON-ALIGNED NO-LABEL WIDGET-ID 40
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 5 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME D-Dialog
     Btn_OK AT ROW 9.62 COL 3
     Btn_Cancel AT ROW 9.62 COL 18
     "VENCIMIENTO LINEA DE CREDITO" VIEW-AS TEXT
          SIZE 30 BY .62 AT ROW 2.62 COL 62 WIDGET-ID 54
          BGCOLOR 14 FGCOLOR 0 FONT 6
     "FECHAS" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 2.62 COL 38 WIDGET-ID 52
          BGCOLOR 14 FGCOLOR 0 FONT 6
     "CAMPAÑAS" VIEW-AS TEXT
          SIZE 12 BY .62 AT ROW 2.62 COL 12 WIDGET-ID 50
          BGCOLOR 14 FGCOLOR 0 FONT 6
     RECT-1 AT ROW 2.35 COL 3 WIDGET-ID 48
     RECT-2 AT ROW 3.42 COL 3 WIDGET-ID 46
     SPACE(3.28) SKIP(2.57)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 5
         TITLE "REPORTE DE EVALUACION COMERCIAL - PROCESO NOCTURNO"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN evalcomparam.Campana_1 IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN evalcomparam.Campana_2 IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN evalcomparam.Campana_3 IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN evalcomparam.Campana_4 IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN evalcomparam.Campana_5 IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN evalcomparam.FchFin_1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN evalcomparam.FchFin_2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN evalcomparam.FchFin_3 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN evalcomparam.FchFin_4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN evalcomparam.FchFin_5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN evalcomparam.FchIni_1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN evalcomparam.FchIni_2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN evalcomparam.FchIni_3 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN evalcomparam.FchIni_4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN evalcomparam.FchIni_5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN evalcomparam.FchVto_1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN evalcomparam.FchVto_2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN evalcomparam.FchVto_3 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN evalcomparam.FchVto_4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN evalcomparam.FchVto_5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN evalcomparam.Periodo IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX evalcomparam.Solo_Cliente_Ruc IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX evalcomparam.Vcto_Linea_Credito IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL                                                  */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "INTEGRAL.evalcomparam"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* REPORTE DE EVALUACION COMERCIAL - PROCESO NOCTURNO */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Exportar */
DO:
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
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal D-Dialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE Detalle.

FOR EACH evalcomdetail OF evalcomparam NO-LOCK:
    CREATE Detalle.
    BUFFER-COPY evalcomdetail TO Detalle.
END.

DEF VAR hDetalle AS HANDLE NO-UNDO.
DEF VAR hDetalleField AS HANDLE NO-UNDO.

hDetalle = TEMP-TABLE Detalle:HANDLE.
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("LinCred01"):LABEL  = "LC CAMPANA " + STRING(evalcomparam.Campana_1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("LinCred02"):LABEL = "LC CAMPANA " + STRING(evalcomparam.Campana_2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("LinCred03"):LABEL = "LC CAMPANA " + STRING(evalcomparam.Campana_3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("LinCred04"):LABEL = "LC CAMPANA " + STRING(evalcomparam.Campana_4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("LinCred05"):LABEL = "LC CAMPANA " + STRING(evalcomparam.Campana_5,'>>>9').

hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_01"):LABEL = "COMPRAS " + STRING(evalcomparam.Campana_1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_02"):LABEL = "COMPRAS " + STRING(evalcomparam.Campana_2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_03"):LABEL = "COMPRAS " + STRING(evalcomparam.Campana_3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_04"):LABEL = "COMPRAS " + STRING(evalcomparam.Campana_4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_05"):LABEL = "COMPRAS " + STRING(evalcomparam.Campana_5,'>>>9').

hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_01_01"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_01_01"):LABEL + " " + STRING(evalcomparam.Campana_1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_01_02"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_01_02"):LABEL + " " + STRING(evalcomparam.Campana_1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_01_06"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_01_06"):LABEL + " " + STRING(evalcomparam.Campana_1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_01_03"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_01_03"):LABEL + " " + STRING(evalcomparam.Campana_1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_01_04"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_01_04"):LABEL + " " + STRING(evalcomparam.Campana_1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_01_05"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_01_05"):LABEL + " " + STRING(evalcomparam.Campana_1,'>>>9').

hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_02_01"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_02_01"):LABEL + " " + STRING(evalcomparam.Campana_2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_02_02"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_02_02"):LABEL + " " + STRING(evalcomparam.Campana_2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_02_06"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_02_06"):LABEL + " " + STRING(evalcomparam.Campana_2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_02_03"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_02_03"):LABEL + " " + STRING(evalcomparam.Campana_2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_02_04"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_02_04"):LABEL + " " + STRING(evalcomparam.Campana_2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_02_05"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_02_05"):LABEL + " " + STRING(evalcomparam.Campana_2,'>>>9').

hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_03_01"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_03_01"):LABEL + " " + STRING(evalcomparam.Campana_3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_03_02"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_03_02"):LABEL + " " + STRING(evalcomparam.Campana_3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_03_06"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_03_06"):LABEL + " " + STRING(evalcomparam.Campana_3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_03_03"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_03_03"):LABEL + " " + STRING(evalcomparam.Campana_3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_03_04"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_03_04"):LABEL + " " + STRING(evalcomparam.Campana_3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_03_05"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_03_05"):LABEL + " " + STRING(evalcomparam.Campana_3,'>>>9').

hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_04_01"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_04_01"):LABEL + " " + STRING(evalcomparam.Campana_4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_04_02"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_04_02"):LABEL + " " + STRING(evalcomparam.Campana_4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_04_06"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_04_06"):LABEL + " " + STRING(evalcomparam.Campana_4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_04_03"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_04_03"):LABEL + " " + STRING(evalcomparam.Campana_4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_04_04"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_04_04"):LABEL + " " + STRING(evalcomparam.Campana_4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_04_05"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_04_05"):LABEL + " " + STRING(evalcomparam.Campana_4,'>>>9').

hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_05_01"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_05_01"):LABEL + " " + STRING(evalcomparam.Campana_5,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_05_02"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_05_02"):LABEL + " " + STRING(evalcomparam.Campana_5,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_05_06"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_05_06"):LABEL + " " + STRING(evalcomparam.Campana_5,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_05_03"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_05_03"):LABEL + " " + STRING(evalcomparam.Campana_5,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_05_04"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_05_04"):LABEL + " " + STRING(evalcomparam.Campana_5,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_05_05"):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("Compras_05_05"):LABEL + " " + STRING(evalcomparam.Campana_5,'>>>9').

END PROCEDURE.


/*
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(15):LABEL  = "LC CAMPANA " + STRING(evalcomparam.Campana_1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(16):LABEL  = "LC CAMPANA " + STRING(evalcomparam.Campana_2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(17):LABEL = "LC CAMPANA " + STRING(evalcomparam.Campana_3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(18):LABEL = "LC CAMPANA " + STRING(evalcomparam.Campana_4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(19):LABEL = "LC CAMPANA " + STRING(evalcomparam.Campana_5,'>>>9').

hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(20):LABEL = "COMPRAS " + STRING(evalcomparam.Campana_1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(21):LABEL = "COMPRAS " + STRING(evalcomparam.Campana_2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(22):LABEL = "COMPRAS " + STRING(evalcomparam.Campana_3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(23):LABEL = "COMPRAS " + STRING(evalcomparam.Campana_4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(24):LABEL = "COMPRAS " + STRING(evalcomparam.Campana_5,'>>>9').

hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(29):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(29):LABEL + " " + STRING(evalcomparam.Campana_1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(30):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(30):LABEL + " " + STRING(evalcomparam.Campana_1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(31):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(31):LABEL + " " + STRING(evalcomparam.Campana_1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(32):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(32):LABEL + " " + STRING(evalcomparam.Campana_1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(33):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(33):LABEL + " " + STRING(evalcomparam.Campana_1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(34):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(34):LABEL + " " + STRING(evalcomparam.Campana_1,'>>>9').

hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(35):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(35):LABEL + " " + STRING(evalcomparam.Campana_2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(36):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(36):LABEL + " " + STRING(evalcomparam.Campana_2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(37):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(37):LABEL + " " + STRING(evalcomparam.Campana_2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(38):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(38):LABEL + " " + STRING(evalcomparam.Campana_2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(39):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(39):LABEL + " " + STRING(evalcomparam.Campana_2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(40):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(40):LABEL + " " + STRING(evalcomparam.Campana_2,'>>>9').

hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(41):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(41):LABEL + " " + STRING(evalcomparam.Campana_3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(42):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(42):LABEL + " " + STRING(evalcomparam.Campana_3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(43):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(43):LABEL + " " + STRING(evalcomparam.Campana_3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(44):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(44):LABEL + " " + STRING(evalcomparam.Campana_3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(45):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(45):LABEL + " " + STRING(evalcomparam.Campana_3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(46):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(46):LABEL + " " + STRING(evalcomparam.Campana_3,'>>>9').

hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(47):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(47):LABEL + " " + STRING(evalcomparam.Campana_4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(48):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(48):LABEL + " " + STRING(evalcomparam.Campana_4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(49):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(49):LABEL + " " + STRING(evalcomparam.Campana_4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(50):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(50):LABEL + " " + STRING(evalcomparam.Campana_4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(51):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(51):LABEL + " " + STRING(evalcomparam.Campana_4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(52):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(52):LABEL + " " + STRING(evalcomparam.Campana_4,'>>>9').

hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(53):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(53):LABEL + " " + STRING(evalcomparam.Campana_4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(54):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(54):LABEL + " " + STRING(evalcomparam.Campana_5,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(55):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(55):LABEL + " " + STRING(evalcomparam.Campana_5,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(56):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(56):LABEL + " " + STRING(evalcomparam.Campana_5,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(57):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(57):LABEL + " " + STRING(evalcomparam.Campana_5,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(58):LABEL = hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(58):LABEL + " " + STRING(evalcomparam.Campana_5,'>>>9').
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  IF AVAILABLE evalcomparam THEN 
    DISPLAY evalcomparam.Periodo evalcomparam.Solo_Cliente_Ruc 
          evalcomparam.Vcto_Linea_Credito evalcomparam.Campana_1 
          evalcomparam.FchIni_1 evalcomparam.FchFin_1 evalcomparam.FchVto_1 
          evalcomparam.Campana_2 evalcomparam.FchIni_2 evalcomparam.FchFin_2 
          evalcomparam.FchVto_2 evalcomparam.Campana_3 evalcomparam.FchIni_3 
          evalcomparam.FchFin_3 evalcomparam.FchVto_3 evalcomparam.Campana_4 
          evalcomparam.FchIni_4 evalcomparam.FchFin_4 evalcomparam.FchVto_4 
          evalcomparam.Campana_5 evalcomparam.FchIni_5 evalcomparam.FchFin_5 
          evalcomparam.FchVto_5 
      WITH FRAME D-Dialog.
  ENABLE RECT-1 RECT-2 Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros D-Dialog 
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
        WHEN "" THEN ASSIGN input-var-1 = "".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "evalcomparam"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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

