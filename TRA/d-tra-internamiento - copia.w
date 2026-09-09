&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-CodDiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR pNombre AS CHAR.
DEF VAR pOrigen AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-Placa FILL-IN_Brevete FILL-IN-Serie ~
FILL-IN-Correlativo FILL-IN-salida FILL-IN-Responsable FILL-IN-Ayudante-1 ~
Btn_Cancel Btn_OK RECT-1 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Placa FILL-IN_Marca FILL-IN_CodPro ~
FILL-IN-NomPro FILL-IN_Brevete FILL-IN-Chofer FILL-IN-Serie ~
FILL-IN-Correlativo FILL-IN-salida FILL-IN-Responsable FILL-IN-NomResp ~
FILL-IN-Ayudante-1 FILL-IN-NomAyud-1 FILL-IN-Ayudante-2 FILL-IN-NomAyud-2 ~
FILL-IN-Ayudante-3 FILL-IN-NomAyud-3 FILL-IN-Ayudante-4 FILL-IN-NomAyud-4 ~
FILL-IN-NomAyud-8 FILL-IN-Ayudante-5 FILL-IN-NomAyud-5 FILL-IN-Ayudante-6 ~
FILL-IN-NomAyud-6 FILL-IN-Ayudante-7 FILL-IN-NomAyud-7 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

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
     SIZE 15 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-Ayudante-2 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Ayudante 2" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-Ayudante-3 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Ayudante 3" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-Ayudante-4 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Ayudante 4" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-Ayudante-5 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Ayudante 5" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-Ayudante-6 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Ayudante 6" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-Ayudante-7 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Ayudante 7" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-Chofer AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-Correlativo AS INTEGER FORMAT "99999999":U INITIAL 0 
     LABEL "Correlativo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1.38
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

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

DEFINE VARIABLE FILL-IN-NomAyud-8 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomResp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-Placa AS CHARACTER FORMAT "X(256)":U 
     LABEL "PLACA" 
     VIEW-AS FILL-IN 
     SIZE 24 BY 1.62
     BGCOLOR 14 FGCOLOR 0 FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-Responsable AS CHARACTER FORMAT "X(11)":U 
     LABEL "Responsable" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN-salida AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha aproximada de salida" 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1.38 NO-UNDO.

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

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 110 BY 10.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 110 BY 11.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-Placa AT ROW 1.54 COL 24 COLON-ALIGNED WIDGET-ID 2
     FILL-IN_Marca AT ROW 3.42 COL 24 COLON-ALIGNED WIDGET-ID 44
     FILL-IN_CodPro AT ROW 5.04 COL 24 COLON-ALIGNED HELP
          "C¢digo del Proveedor" WIDGET-ID 32
     FILL-IN-NomPro AT ROW 5.04 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     FILL-IN_Brevete AT ROW 6.65 COL 24 COLON-ALIGNED WIDGET-ID 30
     FILL-IN-Chofer AT ROW 6.65 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     FILL-IN-Serie AT ROW 8.27 COL 48 COLON-ALIGNED WIDGET-ID 40
     FILL-IN-Correlativo AT ROW 8.42 COL 72 COLON-ALIGNED WIDGET-ID 42
     FILL-IN-salida AT ROW 10.15 COL 48 COLON-ALIGNED WIDGET-ID 46
     FILL-IN-Responsable AT ROW 12.04 COL 19 COLON-ALIGNED WIDGET-ID 50
     FILL-IN-NomResp AT ROW 12.04 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     FILL-IN-Ayudante-1 AT ROW 13.38 COL 19 COLON-ALIGNED WIDGET-ID 52
     FILL-IN-NomAyud-1 AT ROW 13.38 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 68
     FILL-IN-Ayudante-2 AT ROW 14.73 COL 19 COLON-ALIGNED WIDGET-ID 54
     FILL-IN-NomAyud-2 AT ROW 14.73 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 70
     FILL-IN-Ayudante-3 AT ROW 16.08 COL 19 COLON-ALIGNED WIDGET-ID 56
     FILL-IN-NomAyud-3 AT ROW 16.08 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 72
     FILL-IN-Ayudante-4 AT ROW 17.42 COL 19 COLON-ALIGNED WIDGET-ID 58
     FILL-IN-NomAyud-4 AT ROW 17.42 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 74
     FILL-IN-NomAyud-8 AT ROW 17.42 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 84
     FILL-IN-Ayudante-5 AT ROW 18.77 COL 19 COLON-ALIGNED WIDGET-ID 60
     FILL-IN-NomAyud-5 AT ROW 18.77 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 76
     FILL-IN-Ayudante-6 AT ROW 20.12 COL 19 COLON-ALIGNED WIDGET-ID 62
     FILL-IN-NomAyud-6 AT ROW 20.12 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 78
     FILL-IN-Ayudante-7 AT ROW 21.46 COL 19 COLON-ALIGNED WIDGET-ID 80
     FILL-IN-NomAyud-7 AT ROW 21.46 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 82
     Btn_Cancel AT ROW 1.81 COL 95
     Btn_OK AT ROW 1.81 COL 81
     RECT-1 AT ROW 1.27 COL 2 WIDGET-ID 48
     RECT-2 AT ROW 11.77 COL 2 WIDGET-ID 64
     SPACE(1.13) SKIP(1.03)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 9
         TITLE "INTERNAMIENTO"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


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
   FRAME-NAME Custom                                                    */
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
/* SETTINGS FOR FILL-IN FILL-IN-NomAyud-8 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomResp IN FRAME D-Dialog
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
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* INTERNAMIENTO */
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
      FILL-IN-salida.
  ASSIGN
      FILL-IN-Ayudante-1 
      FILL-IN-Ayudante-2 
      FILL-IN-Ayudante-3 
      FILL-IN-Ayudante-4 
      FILL-IN-Ayudante-5 
      FILL-IN-Ayudante-6 
      FILL-IN-Ayudante-7 
      FILL-IN-Responsable.

  DEFINE VAR x-dias AS INT INIT 0.

  /* Validaciones */
  IF TRUE <> (FILL-IN-Placa > '') THEN DO:
      MESSAGE 'Ingrese un número de placa' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN-Placa.
      RETURN NO-APPLY.
  END.
  IF TRUE <> (FILL-IN_Brevete > '') THEN DO:
      MESSAGE 'Ingrese el brevete' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN_Brevete.
      RETURN NO-APPLY.
  END.
  IF FILL-IN-Serie = 0 OR FILL-IN-Correlativo = 0 THEN DO:
      MESSAGE 'Ingrese la guía de transportista' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN-Serie.
      RETURN NO-APPLY.
  END.
  FIND VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
      VtaTabla.Tabla = "BREVETE" AND
      VtaTabla.Llave_c1 = FILL-IN_Brevete AND
      VtaTabla.Llave_c8 = "SI" 
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE VtaTabla THEN DO:
      MESSAGE 'Brevete no válido' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN_Brevete.
      RETURN NO-APPLY.
  END.
  DEF VAR x-Guia AS CHAR NO-UNDO.
  x-Guia = STRING(FILL-IN-Serie, '999') + STRING(FILL-IN-Correlativo , '99999999').
  FIND FIRST TraIngSal WHERE TraIngSal.CodCia = s-CodCia AND
      TraIngSal.CodPro = FILL-IN_CodPro AND 
      TraIngSal.Guia = x-Guia
      NO-LOCK NO-ERROR.
  IF AVAILABLE TraIngSal THEN DO:
      MESSAGE 'Guia del Transportista YA fue registrada' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN-Serie.
      RETURN NO-APPLY.
  END.
  IF TRUE <> (FILL-IN-Responsable > '') THEN DO:
      MESSAGE 'Ingrese el Responsable' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN-Responsable.
      RETURN NO-APPLY.
  END.

  /* RHC Caso 66292 */
  FIND FIRST di-rutaC WHERE di-rutaC.codcia = s-codcia 
      AND di-rutaC.codpro = FILL-IN_CodPro
      AND DI-RutaC.GuiaTransportista = STRING(FILL-IN-Serie, '999') + "-" + STRING(FILL-IN-Correlativo , '99999999')
      AND DI-RutaC.CodDoc = "H/R"
      AND DI-RutaC.FlgEst <> 'A'
      NO-LOCK NO-ERROR.
  IF AVAILABLE di-rutac THEN DO:
      MESSAGE 'Guia del Transportista YA fue registrada en la H/R Nro.' DI-RutaC.NroDoc
           VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN-Serie.
      RETURN NO-APPLY.
  END.

  FIND FIRST TraIngSal  WHERE TraIngSal.CodCia = s-CodCia AND
      TraIngSal.CodDiv = s-CodDiv AND
      TraIngSal.Placa = FILL-IN-Placa AND
      TraIngSal.FlgEst = "I"
      NO-LOCK NO-ERROR.
  IF AVAILABLE TraIngSal THEN DO:
      MESSAGE 'Vehículo YA Internado' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN-Placa.
      RETURN NO-APPLY.
  END.
  FIND FIRST TraIngSal  WHERE TraIngSal.CodCia = s-CodCia AND
      TraIngSal.CodDiv = s-CodDiv AND
      TraIngSal.Placa = FILL-IN-Placa AND
      TraIngSal.FlgEst = "S"
      NO-LOCK NO-ERROR.
  IF AVAILABLE TraIngSal THEN DO:
      MESSAGE 'Vehículo en Ruta' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN-Placa.
      RETURN NO-APPLY.
  END.

  x-dias = FILL-IN-salida - TODAY.

  IF x-dias < 0 THEN DO:
      MESSAGE 'Fecha de Salida aproximada esta errado' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN-salida.
      RETURN NO-APPLY.
  END.
  IF x-dias > 7 THEN DO:
      MESSAGE 'Fecha de Salida aproximada es demasiado tiempo' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN-salida.
      RETURN NO-APPLY.
  END.

  /* Nuevos campos */
  /* Solos los ayudantes válidos */
  FIND gn-vehic WHERE gn-vehic.CodCia = s-CodCia AND 
      gn-vehic.placa = FILL-IN-Placa
      NO-LOCK NO-ERROR.
  CASE TRUE:
      WHEN gn-vehic.NroEstibadores <= 6 THEN DO:
          FILL-IN-Ayudante-7:SCREEN-VALUE = ''.
      END.
      WHEN gn-vehic.NroEstibadores <= 5 THEN DO:
          FILL-IN-Ayudante-7:SCREEN-VALUE = ''.
          FILL-IN-Ayudante-6:SCREEN-VALUE = ''.
      END.
      WHEN gn-vehic.NroEstibadores <= 4 THEN DO:
          FILL-IN-Ayudante-7:SCREEN-VALUE = ''.
          FILL-IN-Ayudante-6:SCREEN-VALUE = ''.
      END.
      WHEN gn-vehic.NroEstibadores <= 5 THEN DO:
          FILL-IN-Ayudante-7:SCREEN-VALUE = ''.
          FILL-IN-Ayudante-6:SCREEN-VALUE = ''.
      END.
  END CASE.
  /* Verificar Repetidos */
  DEF VAR cCadenaTotal AS CHAR NO-UNDO.
  DEF VAR iIndice AS INTE NO-UNDO.
  cCadenaTotal = FILL-IN-Responsable.
  DO iIndice = 1 TO gn-vehic.NroEstibadores:
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
  

  MESSAGE 'Revisar nuevamente el brevete y la guía de transportista' SKIP(1)
      'Continuamos con el INTERNAMIENTO?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  RUN Graba-Registro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Ayudante-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Ayudante-1 D-Dialog
ON LEAVE OF FILL-IN-Ayudante-1 IN FRAME D-Dialog /* Ayudante 1 */
DO:
    IF SELF:SCREEN-VALUE ='' THEN DO:
        FILL-IN-NomAyud-1:SCREEN-VALUE = ''.
        RETURN.
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
        gn-vehic.placa = SELF:SCREEN-VALUE AND
        gn-vehic.Libre_c05 <> "NO" AND
        CAN-FIND(FIRST gn-prov WHERE gn-prov.CodCia = pv-CodCia AND
                 gn-prov.CodPro = gn-vehic.CodPro NO-LOCK)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-vehic THEN DO:
        MESSAGE 'Placa NO válida o vehículo NO ACTIVO' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    IF gn-vehic.VtoRevTecnica = ? THEN DO:
        MESSAGE 'Vehículo no tiene registrada la fecha de revisión técnica'
            VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    IF gn-vehic.VtoExtintor = ? THEN DO:
        MESSAGE 'Vehículo no tiene registrada la fecha de vencimiento de extintor'
            VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    IF gn-vehic.VtoSoat = ? THEN DO:
        MESSAGE 'Vehículo no tiene registrada la fecha de vencimiento del SOAT'
            VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    IF gn-vehic.VtoRevTecnica < TODAY OR 
        gn-vehic.VtoExtintor < TODAY OR 
        gn-vehic.VtoSoat < TODAY THEN DO:
        MESSAGE 'Vencimiento de revisión técnica, fecha de vencimiento del extintor, fecha de vencimiento del SOAT vencidas.' SKIP
            'Revisar con el área de transportes'
            VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    IF gn-vehic.VtoRevTecnica <= (TODAY + 2) OR 
        gn-vehic.VtoExtintor <= (TODAY + 2) OR 
        gn-vehic.VtoSoat <= (TODAY + 2) THEN DO:
        MESSAGE 'Vencimiento de revisión técnica, fecha de vencimiento del extintor, fecha de vencimiento del SOAT a punto de vencer.' SKIP
            'Revisar con el área de transportes'
            VIEW-AS ALERT-BOX WARNING.
    END.
    DISPLAY
        gn-vehic.CodPro @ FILL-IN_CodPro 
        gn-vehic.Marca  @ FILL-IN_Marca
        WITH FRAME {&FRAME-NAME}.
    APPLY 'LEAVE':U TO FILL-IN_CodPro .
    APPLY 'ENTRY':U TO FILL-IN_Brevete.
    DISABLE FILL-IN-Ayudante-2 FILL-IN-Ayudante-3 FILL-IN-Ayudante-4 FILL-IN-Ayudante-5 FILL-IN-Ayudante-6.
    /* Estibadores */
    CASE TRUE:
        WHEN gn-vehic.NroEstibadores = 7 THEN DO:
            ENABLE 
                FILL-IN-Ayudante-2
                FILL-IN-Ayudante-3
                FILL-IN-Ayudante-4
                FILL-IN-Ayudante-5
                FILL-IN-Ayudante-6
                FILL-IN-Ayudante-7
                WITH FRAME {&FRAME-NAME}.
        END.
        WHEN gn-vehic.NroEstibadores = 6 THEN DO:
            ENABLE 
                FILL-IN-Ayudante-2
                FILL-IN-Ayudante-3
                FILL-IN-Ayudante-4
                FILL-IN-Ayudante-5
                FILL-IN-Ayudante-6
                WITH FRAME {&FRAME-NAME}.
        END.
        WHEN gn-vehic.NroEstibadores = 5 THEN DO:
            ENABLE 
                FILL-IN-Ayudante-2
                FILL-IN-Ayudante-3
                FILL-IN-Ayudante-4
                FILL-IN-Ayudante-5
                WITH FRAME {&FRAME-NAME}.
        END.
        WHEN gn-vehic.NroEstibadores = 4 THEN DO:
            ENABLE 
                FILL-IN-Ayudante-2
                FILL-IN-Ayudante-3
                FILL-IN-Ayudante-4
                WITH FRAME {&FRAME-NAME}.
        END.
        WHEN gn-vehic.NroEstibadores = 3 THEN DO:
            ENABLE 
                FILL-IN-Ayudante-2
                FILL-IN-Ayudante-3
                WITH FRAME {&FRAME-NAME}.
        END.
        WHEN gn-vehic.NroEstibadores = 2 THEN DO:
            ENABLE 
                FILL-IN-Ayudante-2
                WITH FRAME {&FRAME-NAME}.
        END.
    END CASE.
    DISABLE FILL-IN-PLACA WITH FRAME {&FRAME-NAME}.
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
  IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  
  FIND VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
      VtaTabla.Tabla = "BREVETE" AND
      VtaTabla.Llave_c1 = SELF:SCREEN-VALUE AND
      VtaTabla.Llave_c8 = "SI"
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE VtaTabla THEN DO:
      MESSAGE 'Brevete NO válido' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  DISPLAY 
      VtaTabla.Libre_c01 + ' ' + VtaTabla.Libre_c02  + ', ' + VtaTabla.Libre_c03 @
      FILL-IN-Chofer WITH FRAME {&FRAME-NAME}.
  IF VtaTabla.Rango_fecha[1] = ? OR VtaTabla.Rango_fecha[1] < TODAY THEN DO:
      MESSAGE 'Brevete vencido' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  IF VtaTabla.Rango_fecha[1] <= (TODAY + 2) THEN DO:
      MESSAGE 'Vencimiento de brevete a punto de vencer.' SKIP
          'Revisar con el área de transportes'
          VIEW-AS ALERT-BOX WARNING.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Brevete D-Dialog
ON LEFT-MOUSE-DBLCLICK OF FILL-IN_Brevete IN FRAME D-Dialog /* Brevete */
OR F8 OF FILL-IN_Brevete DO:
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
          FILL-IN_Brevete FILL-IN-Chofer FILL-IN-Serie FILL-IN-Correlativo 
          FILL-IN-salida FILL-IN-Responsable FILL-IN-NomResp FILL-IN-Ayudante-1 
          FILL-IN-NomAyud-1 FILL-IN-Ayudante-2 FILL-IN-NomAyud-2 
          FILL-IN-Ayudante-3 FILL-IN-NomAyud-3 FILL-IN-Ayudante-4 
          FILL-IN-NomAyud-4 FILL-IN-NomAyud-8 FILL-IN-Ayudante-5 
          FILL-IN-NomAyud-5 FILL-IN-Ayudante-6 FILL-IN-NomAyud-6 
          FILL-IN-Ayudante-7 FILL-IN-NomAyud-7 
      WITH FRAME D-Dialog.
  ENABLE FILL-IN-Placa FILL-IN_Brevete FILL-IN-Serie FILL-IN-Correlativo 
         FILL-IN-salida FILL-IN-Responsable FILL-IN-Ayudante-1 Btn_Cancel 
         Btn_OK RECT-1 RECT-2 
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

    CREATE TraIngSal.
    ASSIGN
        TraIngSal.CodCia = s-CodCia
        TraIngSal.CodDiv = s-CodDiv
        TraIngSal.FlgEst = "I"
        TraIngSal.Brevete = FILL-IN_Brevete 
        TraIngSal.CodPro = FILL-IN_CodPro 
        TraIngSal.FchCreacion = TODAY
        TraIngSal.FechaIngreso = TODAY
        TraIngSal.Guia = STRING(FILL-IN-Serie, '999') + STRING(FILL-IN-Correlativo, '99999999')
        TraIngSal.HoraIngreso = STRING(TIME, 'HH:MM:SS')
        TraIngSal.Placa = FILL-IN-Placa 
        TraIngSal.UsrCreacion = s-User-Id
        TraIngSal.fechasalida = FILL-IN-salida.
    ASSIGN
        TraIngSal.Ayudante-7 = FILL-IN-Ayudante-7 
        TraIngSal.Ayudante-6 = FILL-IN-Ayudante-6 
        TraIngSal.Ayudante-5 = FILL-IN-Ayudante-5 
        TraIngSal.Ayudante-4 = FILL-IN-Ayudante-4 
        TraIngSal.Ayudante-3 = FILL-IN-Ayudante-3 
        TraIngSal.Ayudante-2 = FILL-IN-Ayudante-2 
        TraIngSal.Ayudante-1 = FILL-IN-Ayudante-1 
        TraIngSal.Responsable = FILL-IN-Responsable.
    RELEASE TraIngSal.


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
  FILL-IN-salida:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").
  APPLY 'ENTRY':U TO FILL-IN-Placa.

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

RUN logis/p-busca-por-dni ( INPUT pDNI,
                            OUTPUT pNombre,
                            OUTPUT pOrigen).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

