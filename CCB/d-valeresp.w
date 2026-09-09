&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-CCbPenDep NO-UNDO LIKE CcbPenDep
       FIELD CodMon AS INT
       FIELD SdoAct AS DEC.
DEFINE TEMP-TABLE t-CcbValeResp NO-UNDO LIKE CcbValeResp.



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
DEF INPUT PARAMETER TABLE FOR t-CCbPenDep.
DEF INPUT PARAMETER pCodMon AS INTE.
DEF OUTPUT PARAMETER pOk AS LOGICAL NO-UNDO.

pOk = NO.

/* Parameters Definitions ---                                           */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

/* Local Variable Definitions ---                                       */
DEF VAR x-ApeNom LIKE CcbValeResp.ApellidosNombres NO-UNDO. 
DEF VAR x-NomApe LIKE CcbValeResp.NombresApellidos NO-UNDO.

FIND FIRST t-CcbPenDep NO-LOCK NO-ERROR.
IF NOT AVAILABLE t-CcbPenDep THEN RETURN.

DEF VAR pImporte AS DEC NO-UNDO.
IF pCodMon = 1 THEN DO:
    pImporte = (t-CcbPenDep.SdoNac - t-CcbPenDep.ImpNac).
    IF (t-CcbPenDep.SdoNac - t-CcbPenDep.ImpNac) >= 0 THEN RETURN.
END.
IF pCodMon = 2 THEN DO:
    pImporte = (t-CcbPenDep.SdoUsa - t-CcbPenDep.ImpUsa).
    IF (t-CcbPenDep.SdoUsa - t-CcbPenDep.ImpUsa) >= 0 THEN RETURN.
END.
pImporte = ABS(pImporte).

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
&Scoped-define INTERNAL-TABLES t-CcbValeResp

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define QUERY-STRING-D-Dialog FOR EACH t-CcbValeResp SHARE-LOCK
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH t-CcbValeResp SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog t-CcbValeResp
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog t-CcbValeResp


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS t-CcbValeResp.CodPer t-CcbValeResp.Motivo ~
t-CcbValeResp.FchIni t-CcbValeResp.FchFin t-CcbValeResp.ImpDescontar ~
t-CcbValeResp.Periodo[1] t-CcbValeResp.ImpCuota[1] t-CcbValeResp.Periodo[2] ~
t-CcbValeResp.ImpCuota[2] t-CcbValeResp.Periodo[3] ~
t-CcbValeResp.ImpCuota[3] t-CcbValeResp.Periodo[4] ~
t-CcbValeResp.ImpCuota[4] t-CcbValeResp.Periodo[5] ~
t-CcbValeResp.ImpCuota[5] t-CcbValeResp.Periodo[6] ~
t-CcbValeResp.ImpCuota[6] t-CcbValeResp.Periodo[7] ~
t-CcbValeResp.ImpCuota[7] t-CcbValeResp.Periodo[8] ~
t-CcbValeResp.ImpCuota[8] t-CcbValeResp.Periodo[9] ~
t-CcbValeResp.ImpCuota[9] t-CcbValeResp.Periodo[10] ~
t-CcbValeResp.ImpCuota[10] t-CcbValeResp.Periodo[11] ~
t-CcbValeResp.ImpCuota[11] t-CcbValeResp.Periodo[12] ~
t-CcbValeResp.ImpCuota[12] 
&Scoped-define ENABLED-TABLES t-CcbValeResp
&Scoped-define FIRST-ENABLED-TABLE t-CcbValeResp
&Scoped-Define ENABLED-OBJECTS RECT-3 RECT-4 RECT-5 RECT-7 RECT-8 Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-FIELDS t-CcbValeResp.NombresApellidos ~
t-CcbValeResp.CodPer t-CcbValeResp.FchCie t-CcbValeResp.CodMon ~
t-CcbValeResp.Importe t-CcbValeResp.CodDiv t-CcbValeResp.Motivo ~
t-CcbValeResp.Area t-CcbValeResp.Cargo t-CcbValeResp.FchIni ~
t-CcbValeResp.FchFin t-CcbValeResp.ImpDescontar t-CcbValeResp.Cuotas ~
t-CcbValeResp.Periodo[1] t-CcbValeResp.ImpCuota[1] t-CcbValeResp.Periodo[2] ~
t-CcbValeResp.ImpCuota[2] t-CcbValeResp.Periodo[3] ~
t-CcbValeResp.ImpCuota[3] t-CcbValeResp.Periodo[4] ~
t-CcbValeResp.ImpCuota[4] t-CcbValeResp.Periodo[5] ~
t-CcbValeResp.ImpCuota[5] t-CcbValeResp.Periodo[6] ~
t-CcbValeResp.ImpCuota[6] t-CcbValeResp.Periodo[7] ~
t-CcbValeResp.ImpCuota[7] t-CcbValeResp.Periodo[8] ~
t-CcbValeResp.ImpCuota[8] t-CcbValeResp.Periodo[9] ~
t-CcbValeResp.ImpCuota[9] t-CcbValeResp.Periodo[10] ~
t-CcbValeResp.ImpCuota[10] t-CcbValeResp.Periodo[11] ~
t-CcbValeResp.ImpCuota[11] t-CcbValeResp.Periodo[12] ~
t-CcbValeResp.ImpCuota[12] 
&Scoped-define DISPLAYED-TABLES t-CcbValeResp
&Scoped-define FIRST-DISPLAYED-TABLE t-CcbValeResp
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_DNI FILL-IN_DesDiv FILL-IN-Total 

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

DEFINE VARIABLE FILL-IN-Total AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Total" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_DesDiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_DNI AS CHARACTER FORMAT "x(10)" 
     LABEL "DNI" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40 BY 9.62.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 40 BY .96
     BGCOLOR 15 FGCOLOR 0 .

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 16 BY 10.58.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 101 BY 15.62.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 101 BY 4.85.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      t-CcbValeResp SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     t-CcbValeResp.NombresApellidos AT ROW 2.88 COL 10 COLON-ALIGNED WIDGET-ID 206
          LABEL "Nombre"
          VIEW-AS FILL-IN 
          SIZE 58.57 BY .81
     t-CcbValeResp.CodPer AT ROW 2.88 COL 82 COLON-ALIGNED WIDGET-ID 156
          LABEL "Código"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FILL-IN_DNI AT ROW 3.96 COL 10 COLON-ALIGNED HELP
          "DNI DEL (Cliente)" WIDGET-ID 174
     t-CcbValeResp.FchCie AT ROW 3.96 COL 52 COLON-ALIGNED WIDGET-ID 162
          LABEL "Fecha de cierre de caja"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     t-CcbValeResp.CodMon AT ROW 3.96 COL 82 COLON-ALIGNED WIDGET-ID 154
          LABEL "Monto"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Soles",1,
                     "Dólares",2
          DROP-DOWN-LIST
          SIZE 10 BY 1
     t-CcbValeResp.Importe AT ROW 3.96 COL 92 COLON-ALIGNED NO-LABEL WIDGET-ID 202 FORMAT ">>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     t-CcbValeResp.CodDiv AT ROW 5.04 COL 10 COLON-ALIGNED WIDGET-ID 152
          LABEL "Tienda" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     FILL-IN_DesDiv AT ROW 5.04 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 172
     t-CcbValeResp.Motivo AT ROW 6.12 COL 10 COLON-ALIGNED WIDGET-ID 204
          VIEW-AS FILL-IN 
          SIZE 72.86 BY .81
     t-CcbValeResp.Area AT ROW 8.42 COL 9 COLON-ALIGNED WIDGET-ID 148
          VIEW-AS FILL-IN 
          SIZE 30 BY .81
     t-CcbValeResp.Cargo AT ROW 8.42 COL 54 COLON-ALIGNED WIDGET-ID 150
          VIEW-AS FILL-IN 
          SIZE 30 BY .81
     t-CcbValeResp.FchIni AT ROW 9.38 COL 9 COLON-ALIGNED WIDGET-ID 166
          LABEL "Del"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     t-CcbValeResp.FchFin AT ROW 9.38 COL 25 COLON-ALIGNED WIDGET-ID 164
          LABEL "Al"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     t-CcbValeResp.ImpDescontar AT ROW 9.38 COL 50 COLON-ALIGNED WIDGET-ID 200
          LABEL "Monto a descontar"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     t-CcbValeResp.Cuotas AT ROW 9.38 COL 70 COLON-ALIGNED WIDGET-ID 160
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     t-CcbValeResp.Periodo[1] AT ROW 12.27 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 214
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     t-CcbValeResp.ImpCuota[1] AT ROW 12.27 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 182
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     t-CcbValeResp.Periodo[2] AT ROW 13.04 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 216
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     t-CcbValeResp.ImpCuota[2] AT ROW 13.04 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 184
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     t-CcbValeResp.Periodo[3] AT ROW 13.81 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 218
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     t-CcbValeResp.ImpCuota[3] AT ROW 13.81 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 186
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     t-CcbValeResp.Periodo[4] AT ROW 14.58 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 220
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     t-CcbValeResp.ImpCuota[4] AT ROW 14.58 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 188
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME D-Dialog
     t-CcbValeResp.Periodo[5] AT ROW 15.35 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 222
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     t-CcbValeResp.ImpCuota[5] AT ROW 15.35 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 190
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     t-CcbValeResp.Periodo[6] AT ROW 16.12 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 224
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     t-CcbValeResp.ImpCuota[6] AT ROW 16.12 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 192
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     t-CcbValeResp.Periodo[7] AT ROW 16.88 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 226
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     t-CcbValeResp.ImpCuota[7] AT ROW 16.88 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 194
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     t-CcbValeResp.Periodo[8] AT ROW 17.65 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 228
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     t-CcbValeResp.ImpCuota[8] AT ROW 17.65 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 196
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     t-CcbValeResp.Periodo[9] AT ROW 18.42 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 230
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     t-CcbValeResp.ImpCuota[9] AT ROW 18.42 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 198
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     t-CcbValeResp.Periodo[10] AT ROW 19.19 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 208
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     t-CcbValeResp.ImpCuota[10] AT ROW 19.19 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 176
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     t-CcbValeResp.Periodo[11] AT ROW 19.96 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 210
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     t-CcbValeResp.ImpCuota[11] AT ROW 19.96 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 178
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     t-CcbValeResp.Periodo[12] AT ROW 20.73 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 212
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     t-CcbValeResp.ImpCuota[12] AT ROW 20.73 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 180
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FILL-IN-Total AT ROW 21.88 COL 37 COLON-ALIGNED WIDGET-ID 170
     Btn_OK AT ROW 23.35 COL 3
     Btn_Cancel AT ROW 23.35 COL 18
     "Enero" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 12.46 COL 14 WIDGET-ID 242
     "Octubre" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 19.38 COL 14 WIDGET-ID 246
     "Julio" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 17.08 COL 14 WIDGET-ID 248
     "VALE DE RESPONSABILIDAD" VIEW-AS TEXT
          SIZE 50 BY .96 AT ROW 1.27 COL 26 WIDGET-ID 250
          FONT 8
     "Diciembre" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 20.92 COL 14 WIDGET-ID 276
     "DETALLE DE CUOTAS A DESCONTAR" VIEW-AS TEXT
          SIZE 32 BY .5 AT ROW 10.54 COL 15 WIDGET-ID 252
          FONT 6
     "Agosto" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 17.85 COL 14 WIDGET-ID 254
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME D-Dialog
     "Febrero" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 13.23 COL 14 WIDGET-ID 256
     "Junio" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 16.31 COL 14 WIDGET-ID 258
     "Mayo" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 15.54 COL 14 WIDGET-ID 260
     "Setiembre" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 18.62 COL 14 WIDGET-ID 262
     "Marzo" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 14 COL 14 WIDGET-ID 264
     "MONTO" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 11.5 COL 39 WIDGET-ID 266
          BGCOLOR 15 FGCOLOR 0 FONT 6
     "AUTORIZACION DE DESCUENTO POR PLANILLA DE SUELDOS" VIEW-AS TEXT
          SIZE 54 BY .5 AT ROW 7.65 COL 22 WIDGET-ID 268
          FONT 6
     "Abril" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 14.77 COL 14 WIDGET-ID 270
     "AÑO" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 11.5 COL 26 WIDGET-ID 272
          BGCOLOR 15 FGCOLOR 0 FONT 6
     "MES" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 11.5 COL 14 WIDGET-ID 274
          BGCOLOR 15 FGCOLOR 0 FONT 6
     "Noviembre" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 20.15 COL 14 WIDGET-ID 244
     RECT-3 AT ROW 12.08 COL 11 WIDGET-ID 232
     RECT-4 AT ROW 11.12 COL 11 WIDGET-ID 234
     RECT-5 AT ROW 11.12 COL 22 WIDGET-ID 236
     RECT-7 AT ROW 7.46 COL 3 WIDGET-ID 238
     RECT-8 AT ROW 2.62 COL 3 WIDGET-ID 240
     SPACE(2.13) SKIP(17.98)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE ""
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: t-CCbPenDep T "?" NO-UNDO INTEGRAL CcbPenDep
      ADDITIONAL-FIELDS:
          FIELD CodMon AS INT
          FIELD SdoAct AS DEC
      END-FIELDS.
      TABLE: t-CcbValeResp T "?" NO-UNDO INTEGRAL CcbValeResp
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
   FRAME-NAME                                                           */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN t-CcbValeResp.Area IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN t-CcbValeResp.Cargo IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN t-CcbValeResp.CodDiv IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR COMBO-BOX t-CcbValeResp.CodMon IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN t-CcbValeResp.CodPer IN FRAME D-Dialog
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN t-CcbValeResp.Cuotas IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN t-CcbValeResp.FchCie IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN t-CcbValeResp.FchFin IN FRAME D-Dialog
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN t-CcbValeResp.FchIni IN FRAME D-Dialog
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Total IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DesDiv IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DNI IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN t-CcbValeResp.ImpDescontar IN FRAME D-Dialog
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN t-CcbValeResp.Importe IN FRAME D-Dialog
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN t-CcbValeResp.NombresApellidos IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL                                                  */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "INTEGRAL.t-CcbValeResp"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Cancel */
DO:
  pOk = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN NO-APPLY.

  ASSIGN 
      t-CcbValeResp.CodPer        = t-CcbValeResp.CodPer:SCREEN-VALUE
      t-CcbValeResp.NombresApellidos = t-CcbValeResp.NombresApellidos:SCREEN-VALUE
      t-CcbValeResp.Cuotas        = DECIMAL(t-CcbValeResp.Cuotas:SCREEN-VALUE)
      t-CcbValeResp.FchFin        = DATE(t-CcbValeResp.FchFin:SCREEN-VALUE)
      t-CcbValeResp.FchIni        = DATE(t-CcbValeResp.FchIni:SCREEN-VALUE)
      t-CcbValeResp.ImpCuota[1]   = DECIMAL(t-CcbValeResp.ImpCuota[1]:SCREEN-VALUE )
      t-CcbValeResp.ImpCuota[10]  = DECIMAL(t-CcbValeResp.ImpCuota[10]:SCREEN-VALUE)
      t-CcbValeResp.ImpCuota[11]  = DECIMAL(t-CcbValeResp.ImpCuota[11]:SCREEN-VALUE)
      t-CcbValeResp.ImpCuota[12]  = DECIMAL(t-CcbValeResp.ImpCuota[12]:SCREEN-VALUE)
      t-CcbValeResp.ImpCuota[2]   = DECIMAL(t-CcbValeResp.ImpCuota[2]:SCREEN-VALUE )
      t-CcbValeResp.ImpCuota[3]   = DECIMAL(t-CcbValeResp.ImpCuota[3]:SCREEN-VALUE )
      t-CcbValeResp.ImpCuota[4]   = DECIMAL(t-CcbValeResp.ImpCuota[4]:SCREEN-VALUE )
      t-CcbValeResp.ImpCuota[5]   = DECIMAL(t-CcbValeResp.ImpCuota[5]:SCREEN-VALUE )
      t-CcbValeResp.ImpCuota[6]   = DECIMAL(t-CcbValeResp.ImpCuota[6]:SCREEN-VALUE )
      t-CcbValeResp.ImpCuota[7]   = DECIMAL(t-CcbValeResp.ImpCuota[7]:SCREEN-VALUE )
      t-CcbValeResp.ImpCuota[8]   = DECIMAL(t-CcbValeResp.ImpCuota[8]:SCREEN-VALUE )
      t-CcbValeResp.ImpCuota[9]   = DECIMAL(t-CcbValeResp.ImpCuota[9]:SCREEN-VALUE )
      t-CcbValeResp.ImpDescontar  = DECIMAL(t-CcbValeResp.ImpDescontar:SCREEN-VALUE)
      t-CcbValeResp.Motivo        = t-CcbValeResp.Motivo:SCREEN-VALUE
      t-CcbValeResp.Periodo[1]    = DECIMAL(t-CcbValeResp.Periodo[1]:SCREEN-VALUE )
      t-CcbValeResp.Periodo[10]   = DECIMAL(t-CcbValeResp.Periodo[10]:SCREEN-VALUE)
      t-CcbValeResp.Periodo[11]   = DECIMAL(t-CcbValeResp.Periodo[11]:SCREEN-VALUE)
      t-CcbValeResp.Periodo[12]   = DECIMAL(t-CcbValeResp.Periodo[12]:SCREEN-VALUE)
      t-CcbValeResp.Periodo[2]    = DECIMAL(t-CcbValeResp.Periodo[2]:SCREEN-VALUE )
      t-CcbValeResp.Periodo[3]    = DECIMAL(t-CcbValeResp.Periodo[3]:SCREEN-VALUE )
      t-CcbValeResp.Periodo[4]    = DECIMAL(t-CcbValeResp.Periodo[4]:SCREEN-VALUE )
      t-CcbValeResp.Periodo[5]    = DECIMAL(t-CcbValeResp.Periodo[5]:SCREEN-VALUE )
      t-CcbValeResp.Periodo[6]    = DECIMAL(t-CcbValeResp.Periodo[6]:SCREEN-VALUE )
      t-CcbValeResp.Periodo[7]    = DECIMAL(t-CcbValeResp.Periodo[7]:SCREEN-VALUE )
      t-CcbValeResp.Periodo[8]    = DECIMAL(t-CcbValeResp.Periodo[8]:SCREEN-VALUE )
      t-CcbValeResp.Periodo[9]    = DECIMAL(t-CcbValeResp.Periodo[9]:SCREEN-VALUE )
      .

  DEF VAR x-Correlativo LIKE CcbValeResp.Correlativo NO-UNDO.
  DEF VAR x-Periodo AS INTE NO-UNDO.

  x-Periodo = YEAR(TODAY).
  x-Correlativo = x-Periodo * 10000.    /* Ej. 20210000 */

  DEF BUFFER b-CcbValeResp FOR CcbValeResp.

  FIND LAST b-CcbValeResp WHERE b-CcbValeResp.codcia = s-codcia NO-LOCK NO-ERROR.
  IF AVAILABLE b-CcbValeResp THEN IF x-Periodo = YEAR(b-CcbValeResp.Fecha) THEN x-Correlativo = b-CcbValeResp.Correlativo.

  REPEAT:
      x-Correlativo = x-Correlativo + 1.
      IF CAN-FIND(FIRST CcbValeResp WHERE CcbValeResp.CodCia = s-CodCia
                  AND CcbValeResp.Correlativo = x-Correlativo NO-LOCK)
          THEN NEXT.
      CREATE CcbValeResp.
      BUFFER-COPY t-CcbValeResp TO CcbValeResp
          ASSIGN
            CcbValeResp.CodCia = s-CodCia
            CcbValeResp.Correlativo = x-Correlativo
            CcbValeResp.Fecha = TODAY.
      ASSIGN
          CcbValeResp.FchCreacion = TODAY
          CcbValeResp.UsrCreacion = s-user-id.
      LEAVE.
  END.
  ASSIGN
      CcbValeResp.NroDocId = PL-PERS.NroDocId
      CcbValeResp.TpoDocId = PL-PERS.TpoDocId .
  /* Contamos las cuotas */
  ASSIGN
      CcbValeResp.Cuotas = 0.
  DEF VAR k AS INTE NO-UNDO.
  DO k = 1 TO 12:
      IF CcbValeResp.ImpCuota[k] > 0 THEN CcbValeResp.Cuotas = CcbValeResp.Cuotas + 1.
  END.
  RELEASE CcbValeResp.
  pOk = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME t-CcbValeResp.CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL t-CcbValeResp.CodDiv D-Dialog
ON LEAVE OF t-CcbValeResp.CodDiv IN FRAME D-Dialog /* Tienda */
DO:
  FILL-IN_DesDiv:SCREEN-VALUE = ''.
  FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-divi THEN FILL-IN_DesDiv:SCREEN-VALUE = gn-divi.desdiv.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME t-CcbValeResp.CodPer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL t-CcbValeResp.CodPer D-Dialog
ON LEAVE OF t-CcbValeResp.CodPer IN FRAME D-Dialog /* Código */
DO:
  FIND PL-PERS WHERE PL-PERS.CodCia = s-CodCia
      AND PL-PERS.codper = t-CcbValeResp.CodPer:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE PL-PERS THEN DO:
      ASSIGN
          x-ApeNom = PL-PERS.patper + ' ' + PL-PERS.matper + ', ' + PL-PERS.nomper
          x-NomApe = PL-PERS.nomper + ' ' + PL-PERS.patper + ' ' + PL-PERS.matper.
      DISPLAY 
          PL-PERS.NroDocId @ FILL-IN_DNI
          x-NomApe @ t-CcbValeResp.NombresApellidos
          WITH FRAME {&FRAME-NAME}.
      FIND LAST PL-FLG-MES USE-INDEX IDX02 WHERE PL-FLG-MES.CodCia = s-codcia
          AND PL-FLG-MES.codper = t-CcbValeResp.CodPer:SCREEN-VALUE
          NO-LOCK NO-ERROR.
      IF AVAILABLE PL-FLG-MES THEN
          DISPLAY
          PL-FLG-MES.cargos @ t-CcbValeResp.Cargo
          PL-FLG-MES.seccion @ t-CcbValeResp.Area
          WITH FRAME {&FRAME-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME t-CcbValeResp.Importe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL t-CcbValeResp.Importe D-Dialog
ON LEAVE OF t-CcbValeResp.Importe IN FRAME D-Dialog /* Importe */
DO:
  ASSIGN t-CcbValeResp.ImpDescontar:SCREEN-VALUE = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

ON 'leave':U OF t-CcbValeResp.ImpCuota[1], t-CcbValeResp.ImpCuota[10], t-CcbValeResp.ImpCuota[11],
    t-CcbValeResp.ImpCuota[12], t-CcbValeResp.ImpCuota[2], t-CcbValeResp.ImpCuota[3],
    t-CcbValeResp.ImpCuota[4], t-CcbValeResp.ImpCuota[5], t-CcbValeResp.ImpCuota[6],
    t-CcbValeResp.ImpCuota[7], t-CcbValeResp.ImpCuota[8], t-CcbValeResp.ImpCuota[9]
    DO:
  RUN Totales. 
END.

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
  DISPLAY FILL-IN_DNI FILL-IN_DesDiv FILL-IN-Total 
      WITH FRAME D-Dialog.
  IF AVAILABLE t-CcbValeResp THEN 
    DISPLAY t-CcbValeResp.NombresApellidos t-CcbValeResp.CodPer 
          t-CcbValeResp.FchCie t-CcbValeResp.CodMon t-CcbValeResp.Importe 
          t-CcbValeResp.CodDiv t-CcbValeResp.Motivo t-CcbValeResp.Area 
          t-CcbValeResp.Cargo t-CcbValeResp.FchIni t-CcbValeResp.FchFin 
          t-CcbValeResp.ImpDescontar t-CcbValeResp.Cuotas 
          t-CcbValeResp.Periodo[1] t-CcbValeResp.ImpCuota[1] 
          t-CcbValeResp.Periodo[2] t-CcbValeResp.ImpCuota[2] 
          t-CcbValeResp.Periodo[3] t-CcbValeResp.ImpCuota[3] 
          t-CcbValeResp.Periodo[4] t-CcbValeResp.ImpCuota[4] 
          t-CcbValeResp.Periodo[5] t-CcbValeResp.ImpCuota[5] 
          t-CcbValeResp.Periodo[6] t-CcbValeResp.ImpCuota[6] 
          t-CcbValeResp.Periodo[7] t-CcbValeResp.ImpCuota[7] 
          t-CcbValeResp.Periodo[8] t-CcbValeResp.ImpCuota[8] 
          t-CcbValeResp.Periodo[9] t-CcbValeResp.ImpCuota[9] 
          t-CcbValeResp.Periodo[10] t-CcbValeResp.ImpCuota[10] 
          t-CcbValeResp.Periodo[11] t-CcbValeResp.ImpCuota[11] 
          t-CcbValeResp.Periodo[12] t-CcbValeResp.ImpCuota[12] 
      WITH FRAME D-Dialog.
  ENABLE RECT-3 RECT-4 RECT-5 RECT-7 RECT-8 t-CcbValeResp.CodPer 
         t-CcbValeResp.Motivo t-CcbValeResp.FchIni t-CcbValeResp.FchFin 
         t-CcbValeResp.ImpDescontar t-CcbValeResp.Periodo[1] 
         t-CcbValeResp.ImpCuota[1] t-CcbValeResp.Periodo[2] 
         t-CcbValeResp.ImpCuota[2] t-CcbValeResp.Periodo[3] 
         t-CcbValeResp.ImpCuota[3] t-CcbValeResp.Periodo[4] 
         t-CcbValeResp.ImpCuota[4] t-CcbValeResp.Periodo[5] 
         t-CcbValeResp.ImpCuota[5] t-CcbValeResp.Periodo[6] 
         t-CcbValeResp.ImpCuota[6] t-CcbValeResp.Periodo[7] 
         t-CcbValeResp.ImpCuota[7] t-CcbValeResp.Periodo[8] 
         t-CcbValeResp.ImpCuota[8] t-CcbValeResp.Periodo[9] 
         t-CcbValeResp.ImpCuota[9] t-CcbValeResp.Periodo[10] 
         t-CcbValeResp.ImpCuota[10] t-CcbValeResp.Periodo[11] 
         t-CcbValeResp.ImpCuota[11] t-CcbValeResp.Periodo[12] 
         t-CcbValeResp.ImpCuota[12] Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
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
  CREATE t-CcbValeResp.
  FIND FIRST t-CcbValeResp EXCLUSIVE-LOCK.
  ASSIGN
      t-CcbValeResp.Cajero = ENTRY(1,t-CcbPenDep.NroDoc,'|')
      t-CcbValeResp.CodCia = s-CodCia
      t-CcbValeResp.CodDiv = t-CcbPenDep.CodDiv
      t-CcbValeResp.CodDoc = t-CcbPenDep.CodDoc
      t-CcbValeResp.CodMon = pCodMon
      t-CcbValeResp.FchCie = DATE(ENTRY(2,t-CcbPenDep.NroDoc,'|'))
      t-CcbValeResp.HorCie = ENTRY(3,t-CcbPenDep.NroDoc,'|')
      t-CcbValeResp.ImpDescontar = pImporte
      t-CcbValeResp.Importe = pImporte
      /*t-CcbValeResp.Motivo = t-CcbPenDep.Libre_c01*/
      t-CcbValeResp.NroDoc = t-CcbPenDep.NroDoc
      .
  FIND Ccbtabla WHERE Ccbtabla.codcia = s-codcia
      AND Ccbtabla.tabla = 'DCC'
      AND Ccbtabla.codigo = t-CcbValeResp.Motivo
      NO-LOCK NO-ERROR.
  IF AVAILABLE Ccbtabla THEN t-CcbValeResp.Motivo = Ccbtabla.nombre.
  /* Buscamos código del personal */
  FIND gn-user WHERE gn-user.codcia = s-codcia
      AND gn-user.USER-ID = ENTRY(1,t-CcbPenDep.NroDoc,'|')
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-user THEN t-CcbValeResp.CodPer = gn-user.codper.
  FIND pl-pers WHERE pl-pers.codcia = s-codcia
      AND pl-pers.codper = t-CcbValeResp.CodPer NO-LOCK NO-ERROR.
  IF AVAILABLE pl-pers THEN DO:
      FILL-IN_DNI = PL-PERS.NroDocId.
      ASSIGN
          x-ApeNom = PL-PERS.patper + ' ' + PL-PERS.matper + ', ' + PL-PERS.nomper
          x-NomApe = PL-PERS.nomper + ' ' + PL-PERS.patper + ' ' + PL-PERS.matper.
      ASSIGN
          t-CcbValeResp.NombresApellidos = x-NomApe
          t-CcbValeResp.TpoDocId = PL-PERS.TpoDocId
          t-CcbValeResp.NroDocId = PL-PERS.NroDocId.
      FIND LAST PL-FLG-MES USE-INDEX IDX02 WHERE PL-FLG-MES.CodCia = s-codcia
          AND PL-FLG-MES.codper = t-CcbValeResp.CodPer
          NO-LOCK NO-ERROR.
      IF AVAILABLE PL-FLG-MES THEN
          ASSIGN
              t-CcbValeResp.Cargo = PL-FLG-MES.cargos
              t-CcbValeResp.Area = PL-FLG-MES.seccion.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  APPLY 'LEAVE':U  TO t-CcbValeResp.CodDiv  IN FRAME {&frame-name}.

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
  {src/adm/template/snd-list.i "t-CcbValeResp"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Totales D-Dialog 
PROCEDURE Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    FILL-IN-Total = 
        DEC(t-CcbValeResp.ImpCuota[1]:SCREEN-VALUE)  +
        DEC(t-CcbValeResp.ImpCuota[2]:SCREEN-VALUE)  +
        DEC(t-CcbValeResp.ImpCuota[3]:SCREEN-VALUE)  +
        DEC(t-CcbValeResp.ImpCuota[4]:SCREEN-VALUE)  +
        DEC(t-CcbValeResp.ImpCuota[5]:SCREEN-VALUE)  +
        DEC(t-CcbValeResp.ImpCuota[6]:SCREEN-VALUE)  +
        DEC(t-CcbValeResp.ImpCuota[7]:SCREEN-VALUE)  +
        DEC(t-CcbValeResp.ImpCuota[8]:SCREEN-VALUE)  +
        DEC(t-CcbValeResp.ImpCuota[9]:SCREEN-VALUE)  +
        DEC(t-CcbValeResp.ImpCuota[10]:SCREEN-VALUE) +
        DEC(t-CcbValeResp.ImpCuota[11]:SCREEN-VALUE) +
        DEC(t-CcbValeResp.ImpCuota[12]:SCREEN-VALUE). 
    DISPLAY FILL-IN-Total.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida D-Dialog 
PROCEDURE Valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME} :
    FIND PL-PERS WHERE PL-PERS.codper = t-CcbValeResp.CodPer:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PL-PERS THEN DO:
        MESSAGE 'Código del personal NO registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO t-CcbValeResp.CodPer.
        RETURN 'ADM-ERROR'.
    END.
    IF INPUT t-CcbValeResp.FchCie = ? THEN DO:
        MESSAGE 'Ingrese la fecha de cierre' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO t-CcbValeResp.FchCie.
        RETURN 'ADM-ERROR'.
    END.

    IF DECIMAL(t-CcbValeResp.Importe:SCREEN-VALUE) <= 0 THEN DO:
        MESSAGE 'Debe ingresar el Monto' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO t-CcbValeResp.Importe.
        RETURN 'ADM-ERROR'.
    END.
    IF DECIMAL(t-CcbValeResp.ImpDescontar:SCREEN-VALUE) <= 0 
        OR DECIMAL(t-CcbValeResp.ImpDescontar:SCREEN-VALUE) > DECIMAL(t-CcbValeResp.Importe:SCREEN-VALUE)
        THEN DO:
        MESSAGE 'Error el el Monto a descontar' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO t-CcbValeResp.ImpDescontar.
        RETURN 'ADM-ERROR'.
    END.
    IF DECIMAL(t-CcbValeResp.ImpDescontar:SCREEN-VALUE) <> DECIMAL(FILL-IN-Total:SCREEN-VALUE)
        THEN DO:
        MESSAGE 'El total de cuotas no coincide con el monto a descontar'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO t-CcbValeResp.ImpCuota[1].
        RETURN 'ADM-ERROR'.
    END.

    IF INPUT t-CcbValeResp.FchIni = ? THEN DO:
        MESSAGE 'Ingrese la fecha de inicial' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO t-CcbValeResp.FchIni.
        RETURN 'ADM-ERROR'.
    END.
    IF INPUT t-CcbValeResp.FchFin = ? THEN DO:
        MESSAGE 'Ingrese la fecha final' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO t-CcbValeResp.FchFin.
        RETURN 'ADM-ERROR'.
    END.

    IF TRUE <> (t-CcbValeResp.Motivo:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'Ingrese el Motivo' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO t-CcbValeResp.Motivo.
        RETURN 'ADM-ERROR'.
    END.

    IF (INPUT t-CcbValeResp.Periodo[1]  +
        INPUT t-CcbValeResp.Periodo[10] +
        INPUT t-CcbValeResp.Periodo[11] +
        INPUT t-CcbValeResp.Periodo[12] +
        INPUT t-CcbValeResp.Periodo[2]  +
        INPUT t-CcbValeResp.Periodo[3]  +
        INPUT t-CcbValeResp.Periodo[4]  +
        INPUT t-CcbValeResp.Periodo[5]  +
        INPUT t-CcbValeResp.Periodo[6]  +
        INPUT t-CcbValeResp.Periodo[7]  +
        INPUT t-CcbValeResp.Periodo[8]  +
        INPUT t-CcbValeResp.Periodo[9]) = 0 THEN DO:
        MESSAGE 'Ingrese el AÑO' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO t-CcbValeResp.Periodo[1].
        RETURN 'ADM-ERROR'.
    END.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

