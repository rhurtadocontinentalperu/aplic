&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER b-traingsal FOR TraIngSal.



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
DEFINE INPUT PARAMETER pRowid AS ROWID.

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-CodDiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR pNombre AS CHAR.
DEF VAR pOrigen AS CHAR.

DEFINE BUFFER b-traingsal-2 FOR traingsal.

FIND FIRST b-traingsal WHERE ROWID(b-traingsal) = pRowid NO-LOCK NO-ERROR.

IF NOT AVAILABLE b-traingsal THEN DO:
    MESSAGE "Problemas al ubicar la placa del vehiculo como internado".
    RETURN "ADM-ERROR".
END.   

/**/
FIND gn-vehic WHERE gn-vehic.CodCia = s-CodCia AND 
    gn-vehic.placa = b-traingsal.placa
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-vehic OR gn-vehic.Libre_c05 = "NO" THEN DO:
    MESSAGE 'Placa NO válida o vehículo NO ACTIVO'.
    RETURN "ADM-ERROR".
END.

/* VARIABLES PARA EL SCANNEO DE CODIGO DE BARRAS */
DEF VAR pInicioCaptura AS DATETIME NO-UNDO.
DEF VAR pContadorCaracteres AS INT NO-UNDO.
DEF VAR pInicioDigitacion AS DATETIME NO-UNDO.
DEF VAR pFinDigitacion AS DATETIME NO-UNDO.
DEF VAR pValorScreenBuffer AS CHAR NO-UNDO.
/*DEF VAR pTiempoLimite AS INT64 INIT 400 NO-UNDO.     /* En milisegundos */*/

DEF VAR pTiempoLimite AS INT64 INIT 10000 NO-UNDO.     /* En milisegundos */

DEF VAR x-Estibadores AS INT NO-UNDO.   /* Máximo Número de Estibadores */

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
&Scoped-define INTERNAL-TABLES TraIngSal

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define QUERY-STRING-D-Dialog FOR EACH TraIngSal SHARE-LOCK
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH TraIngSal SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog TraIngSal
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog TraIngSal


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-25 RECT-26 FILL-IN_Brevete ~
FILL-IN-Correlativo FILL-IN-Serie FILL-IN-Responsable FILL-IN-Ayudante-1 ~
Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Placa FILL-IN_Marca FILL-IN_CodPro ~
FILL-IN-NomPro FILL-IN_Brevete FILL-IN-Chofer FILL-IN-Correlativo ~
FILL-IN-Serie FILL-IN-hora-internamiento FILL-IN-NroDoc ~
FILL-IN-fecha-internamiento FILL-IN-Responsable FILL-IN-NomResp ~
FILL-IN-Ayudante-1 FILL-IN-NomAyud-1 FILL-IN-Ayudante-2 FILL-IN-NomAyud-2 ~
FILL-IN-Ayudante-3 FILL-IN-NomAyud-3 FILL-IN-Ayudante-4 FILL-IN-NomAyud-4 ~
FILL-IN-Ayudante-5 FILL-IN-NomAyud-5 FILL-IN-Ayudante-6 FILL-IN-NomAyud-6 ~
FILL-IN-Ayudante-7 FILL-IN-NomAyud-7 FILL-IN-hoy 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/error.ico":U
     LABEL "Cancel" 
     SIZE 15 BY 1.69
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/ok.ico":U
     LABEL "OK" 
     SIZE 15 BY 1.69
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-Ayudante-1 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Ayudante 1" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-Ayudante-2 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Ayudante 2" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-Ayudante-3 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Ayudante 3" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-Ayudante-4 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Ayudante 4" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-Ayudante-5 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Ayudante 5" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-Ayudante-6 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Ayudante 6" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-Ayudante-7 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Ayudante 7" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-Chofer AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-Correlativo AS INTEGER FORMAT "99999999":U INITIAL 0 
     LABEL "Correlativo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1.38
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-fecha-internamiento AS DATE FORMAT "99/99/9999":U 
     LABEL "INTERNAMIENTO" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-hora-internamiento AS CHARACTER FORMAT "X(12)":U 
     LABEL "Hora" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-hoy AS CHARACTER FORMAT "X(25)":U 
     LABEL "Fecha/Hora actual" 
     VIEW-AS FILL-IN 
     SIZE 45 BY 1.38
     BGCOLOR 15 FGCOLOR 12 FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomAyud-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomAyud-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomAyud-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomAyud-4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomAyud-5 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomAyud-6 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomAyud-7 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomResp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "X(256)":U 
     LABEL "# Hoja de Ruta" 
     VIEW-AS FILL-IN 
     SIZE 23.29 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-Placa AS CHARACTER FORMAT "X(15)":U 
     LABEL "PLACA" 
     VIEW-AS FILL-IN 
     SIZE 24 BY 1.62
     BGCOLOR 2 FGCOLOR 15 FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-Responsable AS CHARACTER FORMAT "X(11)":U 
     LABEL "Responsable" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-Serie AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "GUIA TRANSPORTISTA Nro. Serie" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1.38
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN_Brevete AS CHARACTER FORMAT "x(12)" 
     LABEL "Brevete" 
     VIEW-AS FILL-IN 
     SIZE 23 BY 1.38
     BGCOLOR 11 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_CodPro AS CHARACTER FORMAT "x(11)" 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 23 BY 1.38.

DEFINE VARIABLE FILL-IN_Marca AS CHARACTER FORMAT "X(20)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 23.29 BY 1.38 NO-UNDO.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 116 BY 11.31.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 116 BY 8.08.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      TraIngSal SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-Placa AT ROW 2.35 COL 23 COLON-ALIGNED WIDGET-ID 2
     FILL-IN_Marca AT ROW 2.35 COL 59 COLON-ALIGNED WIDGET-ID 44
     FILL-IN_CodPro AT ROW 3.96 COL 23 COLON-ALIGNED HELP
          "C¢digo del Proveedor" WIDGET-ID 32
     FILL-IN-NomPro AT ROW 3.96 COL 47 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     FILL-IN_Brevete AT ROW 5.31 COL 23 COLON-ALIGNED WIDGET-ID 30
     FILL-IN-Chofer AT ROW 5.31 COL 47 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     FILL-IN-Correlativo AT ROW 6.92 COL 71 COLON-ALIGNED WIDGET-ID 42
     FILL-IN-Serie AT ROW 6.96 COL 48 COLON-ALIGNED WIDGET-ID 40
     FILL-IN-hora-internamiento AT ROW 8 COL 99 COLON-ALIGNED WIDGET-ID 50
     FILL-IN-NroDoc AT ROW 8.54 COL 23 COLON-ALIGNED WIDGET-ID 58
     FILL-IN-fecha-internamiento AT ROW 8.54 COL 75 COLON-ALIGNED WIDGET-ID 48
     FILL-IN-Responsable AT ROW 10.42 COL 19 COLON-ALIGNED WIDGET-ID 94
     FILL-IN-NomResp AT ROW 10.42 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     FILL-IN-Ayudante-1 AT ROW 11.77 COL 19 COLON-ALIGNED WIDGET-ID 52
     FILL-IN-NomAyud-1 AT ROW 11.77 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 68
     FILL-IN-Ayudante-2 AT ROW 13.12 COL 19 COLON-ALIGNED WIDGET-ID 84
     FILL-IN-NomAyud-2 AT ROW 13.12 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 70
     FILL-IN-Ayudante-3 AT ROW 14.46 COL 19 COLON-ALIGNED WIDGET-ID 86
     FILL-IN-NomAyud-3 AT ROW 14.46 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 72
     FILL-IN-Ayudante-4 AT ROW 15.81 COL 19 COLON-ALIGNED WIDGET-ID 88
     FILL-IN-NomAyud-4 AT ROW 15.81 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 74
     FILL-IN-Ayudante-5 AT ROW 17.15 COL 19 COLON-ALIGNED WIDGET-ID 90
     FILL-IN-NomAyud-5 AT ROW 17.15 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 76
     FILL-IN-Ayudante-6 AT ROW 18.5 COL 19 COLON-ALIGNED WIDGET-ID 92
     FILL-IN-NomAyud-6 AT ROW 18.5 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 78
     FILL-IN-Ayudante-7 AT ROW 19.85 COL 19 COLON-ALIGNED WIDGET-ID 80
     FILL-IN-NomAyud-7 AT ROW 19.85 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 82
     Btn_OK AT ROW 21.46 COL 2
     Btn_Cancel AT ROW 21.46 COL 18
     FILL-IN-hoy AT ROW 21.73 COL 64 COLON-ALIGNED WIDGET-ID 56
     " DATOS DE LA SALIDA DEL VEHICULO" VIEW-AS TEXT
          SIZE 66 BY .88 AT ROW 1.19 COL 23 WIDGET-ID 46
          BGCOLOR 15 FGCOLOR 2 FONT 8
     RECT-25 AT ROW 10.15 COL 2 WIDGET-ID 96
     RECT-26 AT ROW 2.08 COL 2 WIDGET-ID 98
     SPACE(1.42) SKIP(13.21)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 9
         TITLE " Salida del Vehiculo"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: b-traingsal B "?" ? INTEGRAL TraIngSal
   END-TABLES.
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
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Ayudante-2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Ayudante-3 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Ayudante-4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Ayudante-5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Ayudante-6 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Ayudante-7 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Chofer IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-fecha-internamiento IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-hora-internamiento IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-hoy IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomAyud-1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomAyud-2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomAyud-3 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomAyud-4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomAyud-5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomAyud-6 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomAyud-7 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomResp IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDoc IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Placa IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodPro IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Marca IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "INTEGRAL.TraIngSal"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME           = FRAME D-Dialog:HANDLE
       ROW             = 1
       COLUMN          = 101
       HEIGHT          = 3.85
       WIDTH           = 14.29
       WIDGET-ID       = 54
       HIDDEN          = yes
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {F0B88A90-F5DA-11CF-B545-0020AF6ED35A} type: PSTimer */

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /*  Salida del Vehiculo */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
  ASSIGN 
      FILL-IN_Brevete 
      FILL-IN_CodPro 
      FILL-IN_Marca 
      FILL-IN-Correlativo 
      FILL-IN-Placa 
      FILL-IN-Serie
      .
  ASSIGN
      FILL-IN-Ayudante-1 
      FILL-IN-Ayudante-2 
      FILL-IN-Ayudante-3 
      FILL-IN-Ayudante-4 
      FILL-IN-Ayudante-5 
      FILL-IN-Ayudante-6 
      FILL-IN-Ayudante-7 
      FILL-IN-Responsable.

  /* Validaciones */
  IF FILL-IN-Placa = '' THEN DO:
      MESSAGE 'Ingrese un número de placa' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN-Placa.
      RETURN NO-APPLY.
  END.
  FIND VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
    VtaTabla.Tabla = "BREVETE" AND
    VtaTabla.Llave_c1 = FILL-IN_Brevete 
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE VtaTabla OR VtaTabla.Llave_c8 <> "SI" THEN DO:
      MESSAGE 'Brevete no válido' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN_Brevete.
      RETURN NO-APPLY.
  END.
  IF FILL-in-correlativo <= 0 THEN DO:
      MESSAGE 'Numero de guia esta errado' VIEW-AS ALERT-BOX ERROR.      
      RETURN NO-APPLY.
  END.

  IF TRUE <> (FILL-IN-Responsable > '') THEN DO:
      MESSAGE 'Ingrese el Responsable' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN-Responsable.
      RETURN NO-APPLY.
  END.
  /* Nuevos campos */
  /* Solos los ayudantes válidos */
  FIND gn-vehic WHERE gn-vehic.CodCia = s-CodCia AND 
      gn-vehic.placa = FILL-IN-Placa
      NO-LOCK NO-ERROR.
  CASE TRUE:
      WHEN x-Estibadores <= 6 THEN DO:
          FILL-IN-Ayudante-7:SCREEN-VALUE = ''.
      END.
      WHEN x-Estibadores <= 5 THEN DO:
          FILL-IN-Ayudante-7:SCREEN-VALUE = ''.
          FILL-IN-Ayudante-6:SCREEN-VALUE = ''.
      END.
      WHEN x-Estibadores <= 4 THEN DO:
          FILL-IN-Ayudante-7:SCREEN-VALUE = ''.
          FILL-IN-Ayudante-6:SCREEN-VALUE = ''.
      END.
      WHEN x-Estibadores <= 5 THEN DO:
          FILL-IN-Ayudante-7:SCREEN-VALUE = ''.
          FILL-IN-Ayudante-6:SCREEN-VALUE = ''.
      END.
  END CASE.
  /* Verificar Repetidos */
  DEF VAR cCadenaTotal AS CHAR NO-UNDO.
  DEF VAR iIndice AS INTE NO-UNDO.
  cCadenaTotal = FILL-IN-Responsable.
  DO iIndice = 1 TO x-Estibadores:
      CASE iIndice:
          WHEN 1 THEN DO:
              IF FILL-IN-Ayudante-1 > '' THEN cCadenaTotal = cCadenaTotal + ',' + TRIM(FILL-IN-Ayudante-1).
          END.
          WHEN 2 THEN DO:
              IF FILL-IN-Ayudante-2 > '' THEN cCadenaTotal = cCadenaTotal + ',' + TRIM(FILL-IN-Ayudante-2).
          END.
          WHEN 3 THEN DO:
              IF FILL-IN-Ayudante-3 > '' THEN cCadenaTotal = cCadenaTotal + ',' + TRIM(FILL-IN-Ayudante-3).
          END.
          WHEN 4 THEN DO:
              IF FILL-IN-Ayudante-4 > '' THEN cCadenaTotal = cCadenaTotal + ',' + TRIM(FILL-IN-Ayudante-4).
          END.
          WHEN 5 THEN DO:
              IF FILL-IN-Ayudante-5 > '' THEN cCadenaTotal = cCadenaTotal + ',' + TRIM(FILL-IN-Ayudante-5).
          END.
          WHEN 6 THEN DO:
              IF FILL-IN-Ayudante-6 > '' THEN cCadenaTotal = cCadenaTotal + ',' + TRIM(FILL-IN-Ayudante-6).
          END.
          WHEN 7 THEN DO:
              IF FILL-IN-Ayudante-7 > '' THEN cCadenaTotal = cCadenaTotal + ',' + TRIM(FILL-IN-Ayudante-7).
          END.
      END CASE.
  END.
  DO iIndice = 1 TO NUM-ENTRIES(cCadenaTotal):
      IF INDEX(cCadenaTotal, ENTRY(iIndice,cCadenaTotal)) <> R-INDEX(cCadenaTotal, ENTRY(iIndice,cCadenaTotal))
           THEN DO:
          MESSAGE 'Repetido el responsable o ayudante' ENTRY(iIndice,cCadenaTotal)
              VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.
  END.
  /* CONTROL DE ESTIBADORES */
  RUN Valida-Estibadores.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* RHC Cambio en la Guia del Transportista */
  DEF VAR x-Guia AS CHAR NO-UNDO.
  x-Guia = STRING(FILL-IN-Serie, '999') + STRING(FILL-IN-Correlativo , '99999999').
  IF FILL-IN-serie <> INTEGER(SUBSTRING(b-TraIngSal.Guia,1,3)) OR 
      FILL-IN-correlativo <> INTEGER(SUBSTRING(b-TraIngSal.Guia,4)) THEN DO:
      MESSAGE 'Usted ha cambiado la Guia de Remisión del Transportista' SKIP
          'Continuamos con la grabación?'
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
          UPDATE rpta2 AS LOG.
      IF rpta2 = NO THEN DO:
          APPLY 'ENTRY':U TO FILL-IN-Serie.
          RETURN NO-APPLY.
      END.
      /* CONSISTENCIA */
      FIND FIRST b-TraIngSal-2 WHERE b-TraIngSal-2.CodCia = s-CodCia AND
          b-TraIngSal-2.CodPro = FILL-IN_CodPro AND 
          b-TraIngSal-2.Guia = x-Guia AND
          ROWID(b-TraIngSal-2) <> ROWID(b-TraIngSal) AND
          b-TraIngSal-2.FlgEst <> "A"     /* NO Anulado */
          NO-LOCK NO-ERROR.
      IF AVAILABLE b-TraIngSal-2 THEN DO:
          MESSAGE 'Guia del Transportista YA fue registrada' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO FILL-IN-Serie.
          RETURN NO-APPLY.
      END.
      FIND FIRST di-rutaC WHERE di-rutaC.codcia = s-codcia 
          AND di-rutaC.codpro = FILL-IN_CodPro
          AND DI-RutaC.GuiaTransportista = STRING(FILL-IN-Serie, '999') + "-" + STRING(FILL-IN-Correlativo , '99999999')
          AND DI-RutaC.CodDoc = "H/R"
          AND DI-RutaC.NroDoc <> b-TraIngSal.NroDoc
          AND DI-RutaC.FlgEst <> 'A'
          NO-LOCK NO-ERROR.
      IF AVAILABLE di-rutac THEN DO:
          MESSAGE 'Guia del Transportista YA fue registrada en la H/R Nro.' DI-RutaC.NroDoc
              VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO FILL-IN-Serie.
          RETURN NO-APPLY.
      END.
  END.
  /* ****************************************************************************** */
  /* 17/08/2022: Control de Responsable solo si la HR fue aprobada por un digitador */
  /* ****************************************************************************** */
  FIND DI-RutaC WHERE DI-RutaC.CodCia = b-TraIngSal.CodCia AND
      DI-RutaC.CodDiv = b-TraIngSal.CodDiv AND
      DI-RutaC.CodDoc = "H/R" AND
      DI-RutaC.NroDoc = b-TraIngSal.NroDoc
      NO-LOCK NO-ERROR.
  IF FILL-IN-Responsable <> DI-RutaC.Responsable AND DI-RutaC.Libre_l05 = NO THEN DO:
      /* Vigilante cambió de responsable */
      /* Buscamos si tiene algún contado-contraentrega */
      DEF BUFFER FACTURA FOR Ccbcdocu.
      FOR EACH di-rutaD WHERE di-rutad.codcia = di-rutac.codcia AND
          di-rutad.coddiv = di-rutac.coddiv AND 
          di-rutad.coddoc = di-rutac.coddoc AND
          di-rutad.nrodoc = di-rutac.nrodoc NO-LOCK,
          FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-CodCia
          AND Ccbcdocu.coddoc = Di-RutaD.CodRef
          AND Ccbcdocu.nrodoc = Di-RutaD.NroRef,
          FIRST FACTURA NO-LOCK WHERE FACTURA.codcia = s-codcia AND
          FACTURA.coddoc = Ccbcdocu.codref AND
          FACTURA.nrodoc = Ccbcdocu.nroref AND
          FACTURA.fmapgo = "001":       /* Contra-Entrega */
          /* Veamos si el responsable es válido */
          FOR EACH PL-PERS NO-LOCK WHERE PL-PERS.NroDocId = FILL-IN-Responsable AND 
              PL-PERS.CodCia = s-CodCia:
              FIND LAST PL-FLG-MES WHERE PL-FLG-MES.CodCia = s-codcia AND
                  PL-FLG-MES.codper = pl-pers.codper NO-LOCK NO-ERROR.
              IF NOT AVAILABLE PL-FLG-MES OR INDEX(PL-FLG-MES.cargos, 'COBRADOR') = 0 OR PL-FLG-MES.vcontr <> ? THEN DO:
                  MESSAGE 'H/R tiene pedidos contraentrega' SKIP
                      'Asignar un cobrador válido' VIEW-AS ALERT-BOX ERROR.
                  APPLY 'ENTRY':U TO FILL-IN-Responsable.
                  RETURN NO-APPLY.
              END.
              LEAVE.
          END.
          LEAVE.
      END.
  END.
  /* ****************************************************************************** */
  MESSAGE "Seguro de grabar la salida del vehiculo?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = YES THEN DO:
      pMensaje = ''.
      RUN Graba-Registro.
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.
  END.  
  ELSE RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CtrlFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame D-Dialog OCX.Tick
PROCEDURE CtrlFrame.PSTimer.Tick .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/

FILL-IN-hoy:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "  " + STRING(TODAY,"99/99/9999") + " " + STRING(TIME, 'HH:MM:SS').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Ayudante-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Ayudante-1 D-Dialog
ON LEAVE OF FILL-IN-Ayudante-1 IN FRAME D-Dialog /* Ayudante 1 */
DO:
    IF SELF:SCREEN-VALUE = '' THEN DO:
        FILL-IN-NomAyud-1:SCREEN-VALUE = ''.
        RETURN.
    END.
    pFinDigitacion = NOW.
    /* Límite de 400 milisegundos */
    IF INTERVAL(pFinDigitacion, pInicioDigitacion, 'milliseconds') > pTiempoLimite 
        THEN DO:
        /* Retomamos el valor del buffer */
        SELF:SCREEN-VALUE = pValorScreenBuffer.
    END.
    
    RUN Valida-Personal (INPUT SELF:SCREEN-VALUE, OUTPUT pNombre, OUTPUT pOrigen).
    IF pOrigen = "ERROR" THEN DO:
        MESSAGE 'DNI inválido' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    DISPLAY pNombre @  FILL-IN-NomAyud-1 WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Ayudante-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Ayudante-2 D-Dialog
ON LEAVE OF FILL-IN-Ayudante-2 IN FRAME D-Dialog /* Ayudante 2 */
DO:
    IF SELF:SCREEN-VALUE ='' THEN DO:
        FILL-IN-NomAyud-2:SCREEN-VALUE = ''.
        RETURN.
    END.
    pFinDigitacion = NOW.
    /* Límite de 400 milisegundos */
    IF INTERVAL(pFinDigitacion, pInicioDigitacion, 'milliseconds') > pTiempoLimite THEN DO:
        /* Retomamos el valor del buffer */
        SELF:SCREEN-VALUE = pValorScreenBuffer.
    END.
    
    RUN Valida-Personal (INPUT SELF:SCREEN-VALUE, OUTPUT pNombre, OUTPUT pOrigen).
    IF pOrigen = "ERROR" THEN DO:
        MESSAGE 'DNI inválido' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    DISPLAY pNombre @  FILL-IN-NomAyud-2 WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Ayudante-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Ayudante-3 D-Dialog
ON LEAVE OF FILL-IN-Ayudante-3 IN FRAME D-Dialog /* Ayudante 3 */
DO:
    IF SELF:SCREEN-VALUE ='' THEN DO:
        FILL-IN-NomAyud-3:SCREEN-VALUE = ''.
        RETURN.
    END.
    pFinDigitacion = NOW.
    /* Límite de 400 milisegundos */
    IF TODAY <> DATE(09,30,2019) AND INTERVAL(pFinDigitacion, pInicioDigitacion, 'milliseconds') > pTiempoLimite THEN DO:
        /* Retomamos el valor del buffer */
        SELF:SCREEN-VALUE = pValorScreenBuffer.
    END.
    
    RUN Valida-Personal (INPUT SELF:SCREEN-VALUE, OUTPUT pNombre, OUTPUT pOrigen).
    IF pOrigen = "ERROR" THEN DO:
        MESSAGE 'DNI inválido' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    DISPLAY pNombre @  FILL-IN-NomAyud-3 WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Ayudante-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Ayudante-4 D-Dialog
ON LEAVE OF FILL-IN-Ayudante-4 IN FRAME D-Dialog /* Ayudante 4 */
DO:
    IF SELF:SCREEN-VALUE ='' THEN DO:
        FILL-IN-NomAyud-4:SCREEN-VALUE = ''.
        RETURN.
    END.
    pFinDigitacion = NOW.
    /* Límite de 400 milisegundos */
    IF INTERVAL(pFinDigitacion, pInicioDigitacion, 'milliseconds') > pTiempoLimite THEN DO:
        /* Retomamos el valor del buffer */
        SELF:SCREEN-VALUE = pValorScreenBuffer.
    END.
    
    RUN Valida-Personal (INPUT SELF:SCREEN-VALUE, OUTPUT pNombre, OUTPUT pOrigen).
    IF pOrigen = "ERROR" THEN DO:
        MESSAGE 'DNI inválido' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    DISPLAY pNombre @  FILL-IN-NomAyud-4 WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Ayudante-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Ayudante-5 D-Dialog
ON LEAVE OF FILL-IN-Ayudante-5 IN FRAME D-Dialog /* Ayudante 5 */
DO:
    IF SELF:SCREEN-VALUE ='' THEN DO:
        FILL-IN-NomAyud-5:SCREEN-VALUE = ''.
        RETURN.
    END.
    pFinDigitacion = NOW.
    /* Límite de 400 milisegundos */
    IF INTERVAL(pFinDigitacion, pInicioDigitacion, 'milliseconds') > pTiempoLimite THEN DO:
        /* Retomamos el valor del buffer */
        SELF:SCREEN-VALUE = pValorScreenBuffer.
    END.
    
    RUN Valida-Personal (INPUT SELF:SCREEN-VALUE, OUTPUT pNombre, OUTPUT pOrigen).
    IF pOrigen = "ERROR" THEN DO:
        MESSAGE 'DNI inválido' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    DISPLAY pNombre @  FILL-IN-NomAyud-5 WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Ayudante-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Ayudante-6 D-Dialog
ON LEAVE OF FILL-IN-Ayudante-6 IN FRAME D-Dialog /* Ayudante 6 */
DO:
    IF SELF:SCREEN-VALUE ='' THEN DO:
        FILL-IN-NomAyud-6:SCREEN-VALUE = ''.
        RETURN.
    END.
    pFinDigitacion = NOW.
    /* Límite de 400 milisegundos */
    IF INTERVAL(pFinDigitacion, pInicioDigitacion, 'milliseconds') > pTiempoLimite THEN DO:
        /* Retomamos el valor del buffer */
        SELF:SCREEN-VALUE = pValorScreenBuffer.
    END.
    
    RUN Valida-Personal (INPUT SELF:SCREEN-VALUE, OUTPUT pNombre, OUTPUT pOrigen).
    IF pOrigen = "ERROR" THEN DO:
        MESSAGE 'DNI inválido' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    DISPLAY pNombre @  FILL-IN-NomAyud-6 WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Ayudante-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Ayudante-7 D-Dialog
ON LEAVE OF FILL-IN-Ayudante-7 IN FRAME D-Dialog /* Ayudante 7 */
DO:
    IF SELF:SCREEN-VALUE ='' THEN DO:
        FILL-IN-NomAyud-7:SCREEN-VALUE = ''.
        RETURN.
    END.
    pFinDigitacion = NOW.
    /* Límite de 400 milisegundos */
    IF INTERVAL(pFinDigitacion, pInicioDigitacion, 'milliseconds') > pTiempoLimite THEN DO:
        /* Retomamos el valor del buffer */
        SELF:SCREEN-VALUE = pValorScreenBuffer.
    END.
    
    RUN Valida-Personal (INPUT SELF:SCREEN-VALUE, OUTPUT pNombre, OUTPUT pOrigen).
    IF pOrigen = "ERROR" THEN DO:
        MESSAGE 'DNI inválido' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    DISPLAY pNombre @  FILL-IN-NomAyud-7 WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Placa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Placa D-Dialog
ON LEAVE OF FILL-IN-Placa IN FRAME D-Dialog /* PLACA */
DO:
    IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).

    FIND gn-vehic WHERE gn-vehic.CodCia = s-CodCia AND 
        gn-vehic.placa = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-vehic OR gn-vehic.Libre_c05 = "NO" THEN DO:
        MESSAGE 'Placa NO válida o vehículo NO ACTIVO' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    DISPLAY
        gn-vehic.CodPro @ FILL-IN_CodPro 
        gn-vehic.Marca  @ FILL-IN_Marca
        WITH FRAME {&FRAME-NAME}.
    APPLY 'LEAVE':U TO FILL-IN_CodPro .
    APPLY 'ENTRY':U TO FILL-IN_Brevete.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Responsable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Responsable D-Dialog
ON LEAVE OF FILL-IN-Responsable IN FRAME D-Dialog /* Responsable */
DO:
  IF SELF:SCREEN-VALUE ='' THEN DO:
      FILL-IN-NomResp:SCREEN-VALUE = ''.
      RETURN.
  END.
  pFinDigitacion = NOW.
  /* Límite de 400 milisegundos */
  IF TODAY <> DATE(09,30,2019) AND INTERVAL(pFinDigitacion, pInicioDigitacion, 'milliseconds') > pTiempoLimite 
      THEN DO:
      /* Retomamos el valor del buffer */
      SELF:SCREEN-VALUE = pValorScreenBuffer.
  END.
  RUN Valida-Personal (INPUT SELF:SCREEN-VALUE, OUTPUT pNombre, OUTPUT pOrigen).
  IF pOrigen = "ERROR" THEN DO:
      MESSAGE 'DNI inválido' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  DISPLAY pNombre @  FILL-IN-NomResp WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Brevete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Brevete D-Dialog
ON LEAVE OF FILL-IN_Brevete IN FRAME D-Dialog /* Brevete */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  pFinDigitacion = NOW.
  /* Límite de 400 milisegundos */
  IF INTERVAL(pFinDigitacion, pInicioDigitacion, 'milliseconds') > pTiempoLimite THEN DO:
      /* Retomamos el valor del buffer */
      SELF:SCREEN-VALUE = pValorScreenBuffer.
  END.
  
  FIND VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
      VtaTabla.Tabla = "BREVETE" AND
      VtaTabla.Llave_c1 = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE VtaTabla 
      THEN DISPLAY VtaTabla.Libre_c01 + ' ' + VtaTabla.Libre_c02  + ', ' + VtaTabla.Libre_c03 @
      FILL-IN-Chofer WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Brevete D-Dialog
ON LEFT-MOUSE-DBLCLICK OF FILL-IN_Brevete IN FRAME D-Dialog /* Brevete */
OR F8 OF FILL-IN_Brevete DO:
  ASSIGN
      output-var-1 = ?.
  RUN lkup/c-conductor-02 ('Brevetes').
  IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodPro D-Dialog
ON LEAVE OF FILL-IN_CodPro IN FRAME D-Dialog /* Proveedor */
DO:
  FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND
      gn-prov.CodPro = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN DISPLAY gn-prov.NomPro @ FILL-IN-NomPro WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

/* PARCHE WRX */
&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "d-tra-salida-de-vehiculo.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).
IF OCXFile = ? THEN DO:
    OCXFile = ENTRY(1,PROPATH).
    IF R-INDEX(OCXFile, '\') <> LENGTH(OCXFile) AND R-INDEX(OCXFile, '/') <> LENGTH(OCXFile)
        THEN OCXFile = OCXFile + '/'.
    PROPATH = PROPATH + "," + OCXFile + "aplic/tra".
END.

&ENDIF

/* CONTROL DE BARRAS POR SCANNER */
{lib/i-captura-scan-barras.i ~
    &pCampo="FILL-IN_Brevete" ~
    &pContadorCaracteres="pContadorCaracteres" ~
    &pInicioDigitacion="pInicioDigitacion" ~
    &pValorScreenBuffer="pValorScreenBuffer" ~
    &pFinDigitacion="pFinDigitacion" ~
    &pTiempoLimite="pTiempoLimite"}
{lib/i-captura-scan-barras.i ~
    &pCampo="FILL-IN-Responsable" ~
    &pContadorCaracteres="pContadorCaracteres" ~
    &pInicioDigitacion="pInicioDigitacion" ~
    &pValorScreenBuffer="pValorScreenBuffer" ~
    &pFinDigitacion="pFinDigitacion" ~
    &pTiempoLimite="pTiempoLimite"}
{lib/i-captura-scan-barras.i ~
    &pCampo="FILL-IN-Ayudante-1" ~
    &pContadorCaracteres="pContadorCaracteres" ~
    &pInicioDigitacion="pInicioDigitacion" ~
    &pValorScreenBuffer="pValorScreenBuffer" ~
    &pFinDigitacion="pFinDigitacion" ~
    &pTiempoLimite="pTiempoLimite"}
{lib/i-captura-scan-barras.i ~
    &pCampo="FILL-IN-Ayudante-2" ~
    &pContadorCaracteres="pContadorCaracteres" ~
    &pInicioDigitacion="pInicioDigitacion" ~
    &pValorScreenBuffer="pValorScreenBuffer" ~
    &pFinDigitacion="pFinDigitacion" ~
    &pTiempoLimite="pTiempoLimite"}
{lib/i-captura-scan-barras.i ~
    &pCampo="FILL-IN-Ayudante-3" ~
    &pContadorCaracteres="pContadorCaracteres" ~
    &pInicioDigitacion="pInicioDigitacion" ~
    &pValorScreenBuffer="pValorScreenBuffer" ~
    &pFinDigitacion="pFinDigitacion" ~
    &pTiempoLimite="pTiempoLimite"}
{lib/i-captura-scan-barras.i ~
    &pCampo="FILL-IN-Ayudante-4" ~
    &pContadorCaracteres="pContadorCaracteres" ~
    &pInicioDigitacion="pInicioDigitacion" ~
    &pValorScreenBuffer="pValorScreenBuffer" ~
    &pFinDigitacion="pFinDigitacion" ~
    &pTiempoLimite="pTiempoLimite"}
{lib/i-captura-scan-barras.i ~
    &pCampo="FILL-IN-Ayudante-5" ~
    &pContadorCaracteres="pContadorCaracteres" ~
    &pInicioDigitacion="pInicioDigitacion" ~
    &pValorScreenBuffer="pValorScreenBuffer" ~
    &pFinDigitacion="pFinDigitacion" ~
    &pTiempoLimite="pTiempoLimite"}
{lib/i-captura-scan-barras.i ~
    &pCampo="FILL-IN-Ayudante-6" ~
    &pContadorCaracteres="pContadorCaracteres" ~
    &pInicioDigitacion="pInicioDigitacion" ~
    &pValorScreenBuffer="pValorScreenBuffer" ~
    &pFinDigitacion="pFinDigitacion" ~
    &pTiempoLimite="pTiempoLimite"}
{lib/i-captura-scan-barras.i ~
    &pCampo="FILL-IN-Ayudante-7" ~
    &pContadorCaracteres="pContadorCaracteres" ~
    &pInicioDigitacion="pInicioDigitacion" ~
    &pValorScreenBuffer="pValorScreenBuffer" ~
    &pFinDigitacion="pFinDigitacion" ~
    &pTiempoLimite="pTiempoLimite"}


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load D-Dialog  _CONTROL-LOAD
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

OCXFile = SEARCH( "d-tra-salida-de-vehiculo-v2.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chCtrlFrame = CtrlFrame:COM-HANDLE
    UIB_S = chCtrlFrame:LoadControls( OCXFile, "CtrlFrame":U)
  .
  RUN DISPATCH IN THIS-PROCEDURE("initialize-controls":U) NO-ERROR.
END.
ELSE MESSAGE "d-tra-salida-de-vehiculo-v2.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

END PROCEDURE.

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
  DISPLAY FILL-IN-Placa FILL-IN_Marca FILL-IN_CodPro FILL-IN-NomPro 
          FILL-IN_Brevete FILL-IN-Chofer FILL-IN-Correlativo FILL-IN-Serie 
          FILL-IN-hora-internamiento FILL-IN-NroDoc FILL-IN-fecha-internamiento 
          FILL-IN-Responsable FILL-IN-NomResp FILL-IN-Ayudante-1 
          FILL-IN-NomAyud-1 FILL-IN-Ayudante-2 FILL-IN-NomAyud-2 
          FILL-IN-Ayudante-3 FILL-IN-NomAyud-3 FILL-IN-Ayudante-4 
          FILL-IN-NomAyud-4 FILL-IN-Ayudante-5 FILL-IN-NomAyud-5 
          FILL-IN-Ayudante-6 FILL-IN-NomAyud-6 FILL-IN-Ayudante-7 
          FILL-IN-NomAyud-7 FILL-IN-hoy 
      WITH FRAME D-Dialog.
  ENABLE RECT-25 RECT-26 FILL-IN_Brevete FILL-IN-Correlativo FILL-IN-Serie 
         FILL-IN-Responsable FILL-IN-Ayudante-1 Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Registro D-Dialog 
PROCEDURE Graba-Registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="b-traingsal" ~
        &Condicion="ROWID(b-traingsal) = pRowid" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
    IF NOT (b-traingsal.flgest = 'I' AND b-traingsal.flgsit = 'C') THEN DO:
        pMensaje = "El vehiculo ya no está INTERNADO".
        RELEASE b-TraIngSal.
        RETURN "ADM-ERROR".
    END.
    ASSIGN
        b-TraIngSal.FlgEst = "S"
        b-TraIngSal.Brevete = FILL-IN_Brevete 
        b-TraIngSal.FchModificacion = TODAY
        b-TraIngSal.FechaSalida = TODAY
        b-TraIngSal.HoraSalida = STRING(TIME, 'HH:MM:SS')
        b-TraIngSal.UsrModificacion = s-User-Id
        .
    ASSIGN
        b-TraIngSal.Ayudante-7 = FILL-IN-Ayudante-7 
        b-TraIngSal.Ayudante-6 = FILL-IN-Ayudante-6 
        b-TraIngSal.Ayudante-5 = FILL-IN-Ayudante-5 
        b-TraIngSal.Ayudante-4 = FILL-IN-Ayudante-4 
        b-TraIngSal.Ayudante-3 = FILL-IN-Ayudante-3 
        b-TraIngSal.Ayudante-2 = FILL-IN-Ayudante-2 
        b-TraIngSal.Ayudante-1 = FILL-IN-Ayudante-1 
        b-TraIngSal.Responsable = FILL-IN-Responsable.

    /* ****************************************************************************************** */
    /* RHC 26/02/2019 Regrabamos Guia del Transportista */
    /* ****************************************************************************************** */
    ASSIGN
        b-TraIngSal.Guia = STRING(FILL-IN-Serie, '999') + STRING(FILL-IN-Correlativo, '99999999').
    /* ****************************************************************************************** */
    /* Actualizamos el estado de la hoja de ruta */
    FIND DI-RutaC WHERE DI-RutaC.CodCia = b-TraIngSal.CodCia AND
        DI-RutaC.CodDiv = b-TraIngSal.CodDiv AND
        DI-RutaC.CodDoc = "H/R" AND
        DI-RutaC.NroDoc = b-TraIngSal.NroDoc
        EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE DI-RutaC THEN
        ASSIGN
        DI-RutaC.FlgEst = "PS"      /* En Ruta */
        DI-RutaC.FchSal = b-TraIngSal.FechaSalida
        DI-RutaC.HorSal = REPLACE(b-TraIngSal.HoraSalida,":","")
        DI-RutaC.Libre_c01 = b-TraIngSal.Brevete.
    /* ****************************************************************************************** */
    /* RHC 26/02/2019 Regrabamos Guia del Transportista */
    /* ****************************************************************************************** */
    ASSIGN
        DI-RutaC.GuiaTransportista = STRING(FILL-IN-Serie,"999") + "-" + 
                                        STRING(FILL-IN-Correlativo,"99999999").
    /* ****************************************************************************************** */
    /* RHC Responsable y Ayudantes */
    /* ****************************************************************************************** */
    ASSIGN
        DI-RutaC.responsable = FILL-IN-Responsable
        DI-RutaC.ayudante-1 = FILL-IN-Ayudante-1 
        DI-RutaC.ayudante-2 = FILL-IN-Ayudante-2 
        DI-RutaC.ayudante-3 = FILL-IN-Ayudante-3
        DI-RutaC.ayudante-4 = FILL-IN-Ayudante-4
        DI-RutaC.ayudante-5 = FILL-IN-Ayudante-5
        DI-RutaC.ayudante-6 = FILL-IN-Ayudante-6
        DI-RutaC.ayudante-7 = FILL-IN-Ayudante-7
        .
    RUN Valida-Personal (INPUT FILL-IN-Responsable, OUTPUT pNombre, OUTPUT pOrigen).
    IF pOrigen <> "ERROR" THEN DI-RutaC.TipResponsable = pOrigen.
    RUN Valida-Personal (INPUT FILL-IN-Ayudante-1, OUTPUT pNombre, OUTPUT pOrigen).
    IF pOrigen <> "ERROR" THEN DI-RutaC.TipAyudante-1 = pOrigen.
    RUN Valida-Personal (INPUT FILL-IN-Ayudante-2, OUTPUT pNombre, OUTPUT pOrigen).
    IF pOrigen <> "ERROR" THEN DI-RutaC.TipAyudante-2 = pOrigen.
    RUN Valida-Personal (INPUT FILL-IN-Ayudante-3, OUTPUT pNombre, OUTPUT pOrigen).
    IF pOrigen <> "ERROR" THEN DI-RutaC.TipAyudante-3 = pOrigen.
    RUN Valida-Personal (INPUT FILL-IN-Ayudante-4, OUTPUT pNombre, OUTPUT pOrigen).
    IF pOrigen <> "ERROR" THEN DI-RutaC.TipAyudante-4 = pOrigen.
    RUN Valida-Personal (INPUT FILL-IN-Ayudante-5, OUTPUT pNombre, OUTPUT pOrigen).
    IF pOrigen <> "ERROR" THEN DI-RutaC.TipAyudante-5 = pOrigen.
    RUN Valida-Personal (INPUT FILL-IN-Ayudante-6, OUTPUT pNombre, OUTPUT pOrigen).
    IF pOrigen <> "ERROR" THEN DI-RutaC.TipAyudante-6 = pOrigen.
    RUN Valida-Personal (INPUT FILL-IN-Ayudante-7, OUTPUT pNombre, OUTPUT pOrigen).
    IF pOrigen <> "ERROR" THEN DI-RutaC.TipAyudante-7 = pOrigen.
END.
IF AVAILABLE b-TraIngSal THEN RELEASE b-TraIngSal.
IF AVAILABLE DI-RutaC THEN RELEASE DI-RutaC.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
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
    FILL-IN-placa:SCREEN-VALUE = b-traingsal.placa.
    FILL-IN_codpro:SCREEN-VALUE = b-traingsal.codpro.
    FILL-IN_brevete:SCREEN-VALUE = b-traingsal.brevete.
    FILL-IN-serie:SCREEN-VALUE = SUBSTRING(b-TraIngSal.Guia,1,3).
    FILL-IN-correlativo:SCREEN-VALUE = SUBSTRING(b-TraIngSal.Guia,4).    
    FILL-IN-fecha-internamiento:SCREEN-VALUE = STRING(b-traingsal.fechaingreso,"99/99/9999").
    FILL-IN-hora-internamiento:SCREEN-VALUE = b-traingsal.horaingreso.
    FILL-IN-NroDoc:SCREEN-VALUE = b-TraIngSal.NroDoc.

    /* Vehiculo */
    FIND gn-vehic WHERE gn-vehic.CodCia = s-CodCia AND 
        gn-vehic.placa = b-traingsal.placa
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-vehic OR gn-vehic.Libre_c05 = "NO" THEN DO:
        MESSAGE 'Placa NO válida o vehículo NO ACTIVO' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
    END.
    ELSE FILL-IN_marca:SCREEN-VALUE = gn-vehic.Marca.
    x-Estibadores = gn-vehic.NroEstibadores.    /* OJO */

   /* Proveedor */
     FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND
         gn-prov.CodPro = b-traingsal.codpro
         NO-LOCK NO-ERROR.

     IF AVAILABLE gn-prov THEN FILL-IN-NomPro:SCREEN-VALUE = gn-prov.NomPro.

    /* Brevete */
     FIND VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
         VtaTabla.Tabla = "BREVETE" AND
         VtaTabla.Llave_c1 = b-traingsal.brevete
         NO-LOCK NO-ERROR.
     IF AVAILABLE VtaTabla 
         THEN FILL-IN-Chofer:SCREEN-VALUE = VtaTabla.Libre_c01 + ' ' + VtaTabla.Libre_c02  + ', ' + VtaTabla.Libre_c03 .

     /* ESTIBADORES */
     ASSIGN
         FILL-IN-Ayudante-1 = b-traingsal.Ayudante-1 
         FILL-IN-Ayudante-2 = b-traingsal.Ayudante-2 
         FILL-IN-Ayudante-3 = b-traingsal.Ayudante-3 
         FILL-IN-Ayudante-4 = b-traingsal.Ayudante-4 
         FILL-IN-Ayudante-5 = b-traingsal.Ayudante-5 
         FILL-IN-Ayudante-6 = b-traingsal.Ayudante-6 
         FILL-IN-Ayudante-7 = b-traingsal.Ayudante-7 
         FILL-IN-Responsable = b-traingsal.Responsable.
     /* ***************************************************************************** */
     /* RHC 14/09/2019 Datos de la Hoja de Ruta */
     /* ***************************************************************************** */
     FIND DI-RutaC WHERE DI-RutaC.CodCia = s-CodCia AND
         DI-RutaC.CodDiv = s-CodDiv AND
         DI-RutaC.CodDoc = "H/R" AND 
         DI-RutaC.NroDoc = b-traingsal.NroDoc
         NO-LOCK NO-ERROR.
     IF AVAILABLE DI-RutaC THEN
         ASSIGN
         FILL-IN-Ayudante-1 = DI-RutaC.Ayudante-1 
         FILL-IN-Ayudante-2 = DI-RutaC.Ayudante-2 
         FILL-IN-Ayudante-3 = DI-RutaC.Ayudante-3 
         FILL-IN-Ayudante-4 = DI-RutaC.Ayudante-4 
         FILL-IN-Ayudante-5 = DI-RutaC.Ayudante-5 
         FILL-IN-Ayudante-6 = DI-RutaC.Ayudante-6 
         FILL-IN-Ayudante-7 = DI-RutaC.Ayudante-7 
         FILL-IN-Responsable = DI-RutaC.Responsable
         x-Estibadores = x-Estibadores + DI-RutaC.Libre_d05.    /* Estibadores Adicionales */
     /* ***************************************************************************** */
     /* ***************************************************************************** */
     DISPLAY 
         FILL-IN-Ayudante-1 FILL-IN-Ayudante-2 FILL-IN-Ayudante-3 FILL-IN-Ayudante-4 
         FILL-IN-Ayudante-5 FILL-IN-Ayudante-6 FILL-IN-Ayudante-7 
         FILL-IN-Responsable.
    /* Estibadores */
    x-Estibadores = MINIMUM(x-Estibadores, 7).  /* No más de 7 */
    CASE TRUE:
        WHEN x-Estibadores = 7 THEN DO:
            ENABLE 
                FILL-IN-Ayudante-2
                FILL-IN-Ayudante-3
                FILL-IN-Ayudante-4
                FILL-IN-Ayudante-5
                FILL-IN-Ayudante-6
                FILL-IN-Ayudante-7
                WITH FRAME {&FRAME-NAME}.
        END.
        WHEN x-Estibadores = 6 THEN DO:
            ENABLE 
                FILL-IN-Ayudante-2
                FILL-IN-Ayudante-3
                FILL-IN-Ayudante-4
                FILL-IN-Ayudante-5
                FILL-IN-Ayudante-6
                WITH FRAME {&FRAME-NAME}.
        END.
        WHEN x-Estibadores = 5 THEN DO:
            ENABLE 
                FILL-IN-Ayudante-2
                FILL-IN-Ayudante-3
                FILL-IN-Ayudante-4
                FILL-IN-Ayudante-5
                WITH FRAME {&FRAME-NAME}.
        END.
        WHEN x-Estibadores = 4 THEN DO:
            ENABLE 
                FILL-IN-Ayudante-2
                FILL-IN-Ayudante-3
                FILL-IN-Ayudante-4
                WITH FRAME {&FRAME-NAME}.
        END.
        WHEN x-Estibadores = 3 THEN DO:
            ENABLE 
                FILL-IN-Ayudante-2
                FILL-IN-Ayudante-3
                WITH FRAME {&FRAME-NAME}.
        END.
        WHEN x-Estibadores = 2 THEN DO:
            ENABLE 
                FILL-IN-Ayudante-2
                WITH FRAME {&FRAME-NAME}.
        END.
    END CASE.
    IF FILL-IN-Ayudante-1 > '' THEN DO:
        RUN Valida-Personal (FILL-IN-Ayudante-1, OUTPUT pNombre, OUTPUT pOrigen).
        IF pOrigen <> "ERROR" THEN DISPLAY pNombre @ FILL-IN-NomAyud-1 WITH FRAME {&FRAME-NAME}.
    END.
    IF FILL-IN-Ayudante-2 > '' THEN DO:
        RUN Valida-Personal (FILL-IN-Ayudante-2, OUTPUT pNombre, OUTPUT pOrigen).
        IF pOrigen <> "ERROR" THEN DISPLAY pNombre @ FILL-IN-NomAyud-2 WITH FRAME {&FRAME-NAME}.
    END.
    IF FILL-IN-Ayudante-3 > '' THEN DO:
        RUN Valida-Personal (FILL-IN-Ayudante-3, OUTPUT pNombre, OUTPUT pOrigen).
        IF pOrigen <> "ERROR" THEN DISPLAY pNombre @ FILL-IN-NomAyud-3 WITH FRAME {&FRAME-NAME}.
    END.
    IF FILL-IN-Ayudante-4 > '' THEN DO:
        RUN Valida-Personal (FILL-IN-Ayudante-4, OUTPUT pNombre, OUTPUT pOrigen).
        IF pOrigen <> "ERROR" THEN DISPLAY pNombre @ FILL-IN-NomAyud-4 WITH FRAME {&FRAME-NAME}.
    END.
    IF FILL-IN-Ayudante-5 > '' THEN DO:
        RUN Valida-Personal (FILL-IN-Ayudante-5, OUTPUT pNombre, OUTPUT pOrigen).
        IF pOrigen <> "ERROR" THEN DISPLAY pNombre @ FILL-IN-NomAyud-5 WITH FRAME {&FRAME-NAME}.
    END.
    IF FILL-IN-Ayudante-6 > '' THEN DO:
        RUN Valida-Personal (FILL-IN-Ayudante-6, OUTPUT pNombre, OUTPUT pOrigen).
        IF pOrigen <> "ERROR" THEN DISPLAY pNombre @ FILL-IN-NomAyud-6 WITH FRAME {&FRAME-NAME}.
    END.
    IF FILL-IN-Ayudante-7 > '' THEN DO:
        RUN Valida-Personal (FILL-IN-Ayudante-7, OUTPUT pNombre, OUTPUT pOrigen).
        IF pOrigen <> "ERROR" THEN DISPLAY pNombre @ FILL-IN-NomAyud-7 WITH FRAME {&FRAME-NAME}.
    END.
    IF FILL-IN-Responsable > '' THEN DO:
        RUN Valida-Personal (FILL-IN-Responsable, OUTPUT pNombre, OUTPUT pOrigen).
        IF pOrigen <> "ERROR" THEN DISPLAY pNombre @  FILL-IN-NomResp WITH FRAME {&FRAME-NAME}.
    END.
END.


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
  {src/adm/template/snd-list.i "TraIngSal"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida-Estibadores D-Dialog 
PROCEDURE Valida-Estibadores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Levantamos la libreria a memoria */
  DEFINE VAR x-Estibadores AS CHAR NO-UNDO.
  DEFINE VAR hProc AS HANDLE NO-UNDO.
  DEFINE VAR pMensaje AS CHAR NO-UNDO.
  DEFINE VAR k AS INT NO-UNDO.

  FIND DI-RutaC WHERE DI-RutaC.CodCia = b-TraIngSal.CodCia AND
      DI-RutaC.CodDiv = b-TraIngSal.CodDiv AND
      DI-RutaC.CodDoc = "H/R" AND
      DI-RutaC.NroDoc = b-TraIngSal.NroDoc
      EXCLUSIVE-LOCK NO-ERROR.

  DO WITH FRAME {&FRAME-NAME}:
      IF FILL-IN-Ayudante-1:SCREEN-VALUE > '' THEN
          x-Estibadores = x-Estibadores + (IF TRUE <> (x-Estibadores > '') THEN '' ELSE ',') + FILL-IN-Ayudante-1:SCREEN-VALUE.
      IF FILL-IN-Ayudante-2:SCREEN-VALUE > '' THEN
          x-Estibadores = x-Estibadores + (IF TRUE <> (x-Estibadores > '') THEN '' ELSE ',') + FILL-IN-Ayudante-2:SCREEN-VALUE.
      IF FILL-IN-Ayudante-3:SCREEN-VALUE > '' THEN
          x-Estibadores = x-Estibadores + (IF TRUE <> (x-Estibadores > '') THEN '' ELSE ',') + FILL-IN-Ayudante-3:SCREEN-VALUE.
      IF FILL-IN-Ayudante-4:SCREEN-VALUE > '' THEN
          x-Estibadores = x-Estibadores + (IF TRUE <> (x-Estibadores > '') THEN '' ELSE ',') + FILL-IN-Ayudante-4:SCREEN-VALUE.
      IF FILL-IN-Ayudante-5:SCREEN-VALUE > '' THEN
          x-Estibadores = x-Estibadores + (IF TRUE <> (x-Estibadores > '') THEN '' ELSE ',') + FILL-IN-Ayudante-5:SCREEN-VALUE.
      IF FILL-IN-Ayudante-6:SCREEN-VALUE > '' THEN
          x-Estibadores = x-Estibadores + (IF TRUE <> (x-Estibadores > '') THEN '' ELSE ',') + FILL-IN-Ayudante-6:SCREEN-VALUE.
      IF FILL-IN-Ayudante-7:SCREEN-VALUE > '' THEN
          x-Estibadores = x-Estibadores + (IF TRUE <> (x-Estibadores > '') THEN '' ELSE ',') + FILL-IN-Ayudante-7:SCREEN-VALUE.

      RUN dist/dist-librerias PERSISTENT SET hProc.
      RUN HR_Verifica-Estibadores IN hProc (INPUT "NO",                  /* Nuevo Registro? */
                                            INPUT DI-RutaC.CodDiv,
                                            INPUT DI-RutaC.CodDoc,
                                            INPUT DI-RutaC.NroDoc,
                                            INPUT FILL-IN-Responsable:SCREEN-VALUE,
                                            INPUT x-Estibadores,
                                            OUTPUT pMensaje).
  END.
  DELETE PROCEDURE hProc.
  IF pMensaje > '' THEN DO:
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida-Personal D-Dialog 
PROCEDURE Valida-Personal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pDNI AS CHAR.
DEF OUTPUT PARAMETER pNombre AS CHAR.
DEF OUTPUT PARAMETER pOrigen AS CHAR.

RUN logis/p-busca-por-dni.r ( INPUT pDNI,
                            OUTPUT pNombre,
                            OUTPUT pOrigen).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

