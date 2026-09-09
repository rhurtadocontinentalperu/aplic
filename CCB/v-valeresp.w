&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

/* Local Variable Definitions ---                                       */
DEF VAR x-ApeNom LIKE CcbValeResp.ApellidosNombres NO-UNDO. 
DEF VAR x-NomApe LIKE CcbValeResp.NombresApellidos NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES CcbValeResp
&Scoped-define FIRST-EXTERNAL-TABLE CcbValeResp


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbValeResp.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbValeResp.NombresApellidos ~
CcbValeResp.CodPer CcbValeResp.Motivo CcbValeResp.Area CcbValeResp.Cargo ~
CcbValeResp.FchIni CcbValeResp.FchFin CcbValeResp.ImpDescontar ~
CcbValeResp.Cuotas CcbValeResp.Periodo[1] CcbValeResp.ImpCuota[1] ~
CcbValeResp.Periodo[2] CcbValeResp.ImpCuota[2] CcbValeResp.Periodo[3] ~
CcbValeResp.ImpCuota[3] CcbValeResp.Periodo[4] CcbValeResp.ImpCuota[4] ~
CcbValeResp.Periodo[5] CcbValeResp.ImpCuota[5] CcbValeResp.Periodo[6] ~
CcbValeResp.ImpCuota[6] CcbValeResp.Periodo[7] CcbValeResp.ImpCuota[7] ~
CcbValeResp.Periodo[8] CcbValeResp.ImpCuota[8] CcbValeResp.Periodo[9] ~
CcbValeResp.ImpCuota[9] CcbValeResp.Periodo[10] CcbValeResp.ImpCuota[10] ~
CcbValeResp.Periodo[11] CcbValeResp.ImpCuota[11] CcbValeResp.Periodo[12] ~
CcbValeResp.ImpCuota[12] 
&Scoped-define ENABLED-TABLES CcbValeResp
&Scoped-define FIRST-ENABLED-TABLE CcbValeResp
&Scoped-Define ENABLED-OBJECTS RECT-3 RECT-4 RECT-5 RECT-7 RECT-8 
&Scoped-Define DISPLAYED-FIELDS CcbValeResp.Correlativo CcbValeResp.Fecha ~
CcbValeResp.NombresApellidos CcbValeResp.CodPer CcbValeResp.FchCie ~
CcbValeResp.CodMon CcbValeResp.Importe CcbValeResp.CodDiv ~
CcbValeResp.Motivo CcbValeResp.Area CcbValeResp.Cargo CcbValeResp.FchIni ~
CcbValeResp.FchFin CcbValeResp.ImpDescontar CcbValeResp.Cuotas ~
CcbValeResp.Periodo[1] CcbValeResp.ImpCuota[1] CcbValeResp.Periodo[2] ~
CcbValeResp.ImpCuota[2] CcbValeResp.Periodo[3] CcbValeResp.ImpCuota[3] ~
CcbValeResp.Periodo[4] CcbValeResp.ImpCuota[4] CcbValeResp.Periodo[5] ~
CcbValeResp.ImpCuota[5] CcbValeResp.Periodo[6] CcbValeResp.ImpCuota[6] ~
CcbValeResp.Periodo[7] CcbValeResp.ImpCuota[7] CcbValeResp.Periodo[8] ~
CcbValeResp.ImpCuota[8] CcbValeResp.Periodo[9] CcbValeResp.ImpCuota[9] ~
CcbValeResp.Periodo[10] CcbValeResp.ImpCuota[10] CcbValeResp.Periodo[11] ~
CcbValeResp.ImpCuota[11] CcbValeResp.Periodo[12] CcbValeResp.ImpCuota[12] 
&Scoped-define DISPLAYED-TABLES CcbValeResp
&Scoped-define FIRST-DISPLAYED-TABLE CcbValeResp
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_DNI FILL-IN_DesDiv FILL-IN-Total ~
FILL-IN-Estado 

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
DEFINE VARIABLE FILL-IN-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 14 FGCOLOR 0 FONT 6 NO-UNDO.

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
     SIZE 101 BY 16.15.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 101 BY 4.85.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbValeResp.Correlativo AT ROW 1.54 COL 85 COLON-ALIGNED WIDGET-ID 146
          LABEL "Vale Nro." FORMAT "99999999"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
          FONT 6
     CcbValeResp.Fecha AT ROW 2.62 COL 85 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          FONT 6
     CcbValeResp.NombresApellidos AT ROW 3.96 COL 9 COLON-ALIGNED WIDGET-ID 46
          LABEL "Nombre"
          VIEW-AS FILL-IN 
          SIZE 58.57 BY .81
     CcbValeResp.CodPer AT ROW 3.96 COL 81 COLON-ALIGNED WIDGET-ID 6
          LABEL "Código"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FILL-IN_DNI AT ROW 5.04 COL 9 COLON-ALIGNED HELP
          "DNI DEL (Cliente)" WIDGET-ID 116
     CcbValeResp.FchCie AT ROW 5.04 COL 51 COLON-ALIGNED WIDGET-ID 8
          LABEL "Fecha de cierre de caja"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbValeResp.CodMon AT ROW 5.04 COL 81 COLON-ALIGNED WIDGET-ID 118
          LABEL "Monto"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Soles",1,
                     "Dólares",2
          DROP-DOWN-LIST
          SIZE 10 BY 1
     CcbValeResp.Importe AT ROW 5.04 COL 91 COLON-ALIGNED NO-LABEL WIDGET-ID 42 FORMAT ">>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbValeResp.CodDiv AT ROW 6.12 COL 9 COLON-ALIGNED WIDGET-ID 138
          LABEL "Tienda" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     FILL-IN_DesDiv AT ROW 6.12 COL 16 COLON-ALIGNED NO-LABEL WIDGET-ID 140
     CcbValeResp.Motivo AT ROW 7.19 COL 9 COLON-ALIGNED WIDGET-ID 44
          VIEW-AS FILL-IN 
          SIZE 72.86 BY .81
     CcbValeResp.Area AT ROW 9.5 COL 8 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 30 BY .81
     CcbValeResp.Cargo AT ROW 9.5 COL 53 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 30 BY .81
     CcbValeResp.FchIni AT ROW 10.46 COL 8 COLON-ALIGNED WIDGET-ID 12
          LABEL "Del"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbValeResp.FchFin AT ROW 10.46 COL 24 COLON-ALIGNED WIDGET-ID 10
          LABEL "Al"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbValeResp.ImpDescontar AT ROW 10.46 COL 49 COLON-ALIGNED WIDGET-ID 40
          LABEL "Monto a descontar"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbValeResp.Cuotas AT ROW 10.46 COL 69 COLON-ALIGNED WIDGET-ID 72
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbValeResp.Periodo[1] AT ROW 13.35 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 54
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     CcbValeResp.ImpCuota[1] AT ROW 13.35 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbValeResp.Periodo[2] AT ROW 14.12 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 56
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     CcbValeResp.ImpCuota[2] AT ROW 14.12 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbValeResp.Periodo[3] AT ROW 14.88 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 58
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     CcbValeResp.ImpCuota[3] AT ROW 14.88 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     CcbValeResp.Periodo[4] AT ROW 15.65 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 60
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     CcbValeResp.ImpCuota[4] AT ROW 15.65 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbValeResp.Periodo[5] AT ROW 16.42 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 62
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     CcbValeResp.ImpCuota[5] AT ROW 16.42 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbValeResp.Periodo[6] AT ROW 17.19 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 64
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     CcbValeResp.ImpCuota[6] AT ROW 17.19 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbValeResp.Periodo[7] AT ROW 17.96 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 66
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     CcbValeResp.ImpCuota[7] AT ROW 17.96 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbValeResp.Periodo[8] AT ROW 18.73 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 68
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     CcbValeResp.ImpCuota[8] AT ROW 18.73 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 36
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbValeResp.Periodo[9] AT ROW 19.5 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 70
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     CcbValeResp.ImpCuota[9] AT ROW 19.5 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 38
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbValeResp.Periodo[10] AT ROW 20.27 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 48
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     CcbValeResp.ImpCuota[10] AT ROW 20.27 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbValeResp.Periodo[11] AT ROW 21.04 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 50
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     CcbValeResp.ImpCuota[11] AT ROW 21.04 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbValeResp.Periodo[12] AT ROW 21.81 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 52
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     CcbValeResp.ImpCuota[12] AT ROW 21.81 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FILL-IN-Total AT ROW 22.96 COL 36 COLON-ALIGNED WIDGET-ID 136
     FILL-IN-Estado AT ROW 23.62 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 148
     "Enero" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 13.54 COL 13 WIDGET-ID 74
     "AUTORIZACION DE DESCUENTO POR PLANILLA DE SUELDOS" VIEW-AS TEXT
          SIZE 54 BY .5 AT ROW 8.73 COL 21 WIDGET-ID 122
          FONT 6
     "Abril" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 15.85 COL 13 WIDGET-ID 80
     "Mayo" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 16.62 COL 13 WIDGET-ID 82
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "MONTO S/." VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 12.58 COL 38 WIDGET-ID 112
          BGCOLOR 15 FGCOLOR 0 FONT 6
     "AÑO" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 12.58 COL 25 WIDGET-ID 110
          BGCOLOR 15 FGCOLOR 0 FONT 6
     "Setiembre" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 19.69 COL 13 WIDGET-ID 96
     "Marzo" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 15.08 COL 13 WIDGET-ID 78
     "Junio" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 17.38 COL 13 WIDGET-ID 86
     "Febrero" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 14.31 COL 13 WIDGET-ID 76
     "Agosto" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 18.92 COL 13 WIDGET-ID 94
     "DETALLE DE CUOTAS A DESCONTAR" VIEW-AS TEXT
          SIZE 32 BY .5 AT ROW 11.62 COL 14 WIDGET-ID 130
          FONT 6
     "VALE DE RESPONSABILIDAD" VIEW-AS TEXT
          SIZE 50 BY .96 AT ROW 1.81 COL 20 WIDGET-ID 104
          FONT 8
     "Julio" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 18.15 COL 13 WIDGET-ID 88
     "Octubre" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 20.46 COL 13 WIDGET-ID 98
     "Noviembre" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 21.23 COL 13 WIDGET-ID 100
     "Diciembre" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 22 COL 13 WIDGET-ID 102
     "MES" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 12.58 COL 13 WIDGET-ID 108
          BGCOLOR 15 FGCOLOR 0 FONT 6
     RECT-3 AT ROW 13.15 COL 10 WIDGET-ID 124
     RECT-4 AT ROW 12.19 COL 10 WIDGET-ID 126
     RECT-5 AT ROW 12.19 COL 21 WIDGET-ID 128
     RECT-7 AT ROW 8.54 COL 2 WIDGET-ID 134
     RECT-8 AT ROW 3.69 COL 2 WIDGET-ID 144
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.CcbValeResp
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
         HEIGHT             = 25.73
         WIDTH              = 107.57.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN CcbValeResp.CodDiv IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR COMBO-BOX CcbValeResp.CodMon IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbValeResp.CodPer IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbValeResp.Correlativo IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbValeResp.FchCie IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbValeResp.FchFin IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbValeResp.FchIni IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbValeResp.Fecha IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Total IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DesDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DNI IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbValeResp.ImpDescontar IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbValeResp.Importe IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbValeResp.NombresApellidos IN FRAME F-Main
   EXP-LABEL                                                            */
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

&Scoped-define SELF-NAME CcbValeResp.CodPer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbValeResp.CodPer V-table-Win
ON LEAVE OF CcbValeResp.CodPer IN FRAME F-Main /* Código */
DO:
  FIND PL-PERS WHERE PL-PERS.codper = CcbValeResp.CodPer:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE PL-PERS THEN DO:
      ASSIGN
          x-ApeNom = PL-PERS.patper + ' ' + PL-PERS.matper + ', ' + PL-PERS.nomper
          x-NomApe = PL-PERS.nomper + ' ' + PL-PERS.patper + ' ' + PL-PERS.matper.
      DISPLAY 
          PL-PERS.NroDocId @ FILL-IN_DNI
          x-NomApe @ CcbValeResp.NombresApellidos
          WITH FRAME {&FRAME-NAME}.
      FIND LAST PL-FLG-MES USE-INDEX IDX02 WHERE PL-FLG-MES.CodCia = s-codcia
          AND PL-FLG-MES.codper = CcbValeResp.CodPer:SCREEN-VALUE
          NO-LOCK NO-ERROR.
      IF AVAILABLE PL-FLG-MES THEN
          DISPLAY
          PL-FLG-MES.cargos @ CcbValeResp.Cargo
          PL-FLG-MES.seccion @ CcbValeResp.Area
          WITH FRAME {&FRAME-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbValeResp.Importe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbValeResp.Importe V-table-Win
ON LEAVE OF CcbValeResp.Importe IN FRAME F-Main /* Importe */
DO:
  ASSIGN CcbValeResp.ImpDescontar:SCREEN-VALUE = SELF:SCREEN-VALUE.
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

ON 'leave':U OF CcbValeResp.ImpCuota[1], CcbValeResp.ImpCuota[10], CcbValeResp.ImpCuota[11],
    CcbValeResp.ImpCuota[12], CcbValeResp.ImpCuota[2], CcbValeResp.ImpCuota[3],
    CcbValeResp.ImpCuota[4], CcbValeResp.ImpCuota[5], CcbValeResp.ImpCuota[6],
    CcbValeResp.ImpCuota[7], CcbValeResp.ImpCuota[8], CcbValeResp.ImpCuota[9]
    DO:
  RUN Totales. 
END.

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
  {src/adm/template/row-list.i "CcbValeResp"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbValeResp"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aprobar V-table-Win 
PROCEDURE Aprobar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE CcbValeResp OR CcbValeResp.FlgEst <> "P" THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.
DEF BUFFER b-Vales FOR CcbValeResp.
{lib/lock-genericov3.i ~
    &Tabla="b-Vales" ~
    &Condicion="b-Vales.CodCia = CcbValeResp.CodCia ~
    AND b-Vales.CodDiv = CcbValeResp.CodDiv ~
    AND b-Vales.Correlativo = CcbValeResp.Correlativo" ~
    &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
    &Accion="RETRY" ~
    &Mensaje="YES" ~
    &TipoError="UNDO, RETURN ERROR" }
IF b-Vales.FlgEst = 'P' THEN b-Vales.FlgEst = 'C'.
RELEASE b-Vales.
RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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

  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN DO:
      ASSIGN
          CcbValeResp.FchModificacion = TODAY
          CcbValeResp.UsrModificacion = s-user-id.
  END.

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* Correlativo: Es por año (autonumerado) aaaannnn*/

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
      ASSIGN
          CcbValeResp.CodCia = s-CodCia
          CcbValeResp.Correlativo = x-Correlativo
          CcbValeResp.Fecha = TODAY.
      ASSIGN
          CcbValeResp.FchCreacion = TODAY
          CcbValeResp.UsrCreacion = s-user-id.
      LEAVE.
  END.


END PROCEDURE.

/*
  DEF VAR x-Correlativo LIKE CcbValeResp.Correlativo NO-UNDO.

  x-Correlativo = 0.
  DEF BUFFER b-CcbValeResp FOR CcbValeResp.
  FOR EACH b-CcbValeResp NO-LOCK WHERE b-CcbValeResp.codcia = s-codcia:
      x-Correlativo = b-CcbValeResp.Correlativo.
  END.
  REPEAT:
      x-Correlativo = x-Correlativo + 1.
      IF CAN-FIND(FIRST CcbValeResp WHERE CcbValeResp.CodCia = s-CodCia
                  AND CcbValeResp.Correlativo = x-Correlativo NO-LOCK)
          THEN NEXT.
      ASSIGN
          CcbValeResp.CodCia = s-CodCia
          CcbValeResp.Correlativo = x-Correlativo
          CcbValeResp.Fecha = TODAY.
      LEAVE.
  END.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF NOT AVAILABLE CcbValeResp THEN RETURN 'ADM-ERROR'.
  FIND CURRENT CcbValeResp EXCLUSIVE-LOCK NO-WAIT.

  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      CcbValeResp.FlgEst = 'A'
      CcbValeResp.FchAnulacion = TODAY 
      CcbValeResp.UsrAnulacion = s-user-id.
  FIND CURRENT CcbValeResp NO-LOCK.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
  IF NOT AVAILABLE CcbValeResp THEN RETURN.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          FILL-IN_DesDiv = ''
          FILL-IN_DNI = ''
          FILL-IN-Total = 0.
      FIND gn-divi WHERE GN-DIVI.CodCia = s-codcia
          AND GN-DIVI.CodDiv = CcbValeResp.CodDiv
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-divi THEN FILL-IN_DesDiv = GN-DIVI.DesDiv.
      FIND pl-pers WHERE PL-PERS.codper = CcbValeResp.CodPer NO-LOCK NO-ERROR.
      IF AVAILABLE pl-pers THEN FILL-IN_DNI = PL-PERS.NroDocId.
      DISPLAY FILL-IN_DesDiv FILL-IN_DNI FILL-IN-Total.
      RUN Totales.
      CASE CcbValeResp.FlgEst:
          WHEN "P" THEN FILL-IN-Estado:SCREEN-VALUE = 'POR APROBAR'.
          WHEN "C" THEN FILL-IN-Estado:SCREEN-VALUE = 'APROBADO'.
          WHEN "A" THEN FILL-IN-Estado:SCREEN-VALUE = 'RECHAZADO'.
      END CASE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          CcbValeResp.NombresApellidos:SENSITIVE = NO
          CcbValeResp.Area:SENSITIVE = NO
          CcbValeResp.Cargo:SENSITIVE = NO
          CcbValeResp.Cuotas:SENSITIVE = NO.
  END.
/*   DO WITH FRAME {&FRAME-NAME}:                        */
/*       ASSIGN                                          */
/*           CcbValeResp.NombresApellidos:SENSITIVE = NO */
/*           CcbValeResp.Area:SENSITIVE = NO             */
/*           CcbValeResp.Cargo:SENSITIVE = NO.           */
/*       ASSIGN                                          */
/*           CcbValeResp.ImpDescontar:SENSITIVE = NO     */
/*           CcbValeResp.Cuotas:SENSITIVE = NO.          */
/*   END.                                                */

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
  IF NOT AVAILABLE CcbValeResp OR CcbValeResp.FlgEst <> 'C' THEN DO:
      MESSAGE 'Solo se puede imprimir vales APROBADOS' VIEW-AS ALERT-BOX INFORMATION.
      RETURN.
  END.

  DEF VAR RB-REPORT-LIBRARY AS CHAR NO-UNDO.
  DEF VAR RB-REPORT-NAME AS CHAR NO-UNDO.
  DEF VAR RB-INCLUDE-RECORDS AS CHAR NO-UNDO.
  DEF VAR RB-FILTER AS CHAR NO-UNDO.
  DEF VAR RB-OTHER-PARAMETERS AS CHAR NO-UNDO.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  DEF VAR EnLetras AS CHAR NO-UNDO.
  DEFINE VAR x-texto AS CHAR.

  RUN src/bin/_numero (CcbValeResp.ImpDescontar, 2, 1, OUTPUT EnLetras).

  EnLetras = EnLetras + ' ' + (IF CcbValeResp.codmon = 2 THEN 'DOLARES' ELSE 'SOLES').

  GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
  ASSIGN
      RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "ccb/rbccb.prl"
      RB-REPORT-NAME = "Vale de Responsabilidad"
      RB-INCLUDE-RECORDS = "O"
      RB-FILTER = "CcbValeResp.CodCia = " + STRING(CcbValeResp.CodCia) + " " + ~
                    " AND CcbValeResp.Correlativo = " + STRING(CcbValeResp.Correlativo)
      RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia +
                            "~ns-enletras = " + EnLetras.

  RUN lib/_Imprime2(
      RB-REPORT-LIBRARY,
      RB-REPORT-NAME,
      RB-INCLUDE-RECORDS,
      RB-FILTER,
      RB-OTHER-PARAMETERS).


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
  RUN valida.
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
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rechazar V-table-Win 
PROCEDURE Rechazar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE CcbValeResp OR CcbValeResp.FlgEst <> "P" THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.
DEF BUFFER b-Vales FOR CcbValeResp.
{lib/lock-genericov3.i ~
    &Tabla="b-Vales" ~
    &Condicion="b-Vales.CodCia = CcbValeResp.CodCia ~
    AND b-Vales.CodDiv = CcbValeResp.CodDiv ~
    AND b-Vales.Correlativo = CcbValeResp.Correlativo" ~
    &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
    &Accion="RETRY" ~
    &Mensaje="YES" ~
    &TipoError="UNDO, RETURN ERROR" }
IF b-Vales.FlgEst = 'P' THEN b-Vales.FlgEst = 'A'.
RELEASE b-Vales.
RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
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
  {src/adm/template/snd-list.i "CcbValeResp"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Totales V-table-Win 
PROCEDURE Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

         
DO WITH FRAME {&FRAME-NAME}:
    FILL-IN-Total = 
        DEC(CcbValeResp.ImpCuota[1]:SCREEN-VALUE)  +
        DEC(CcbValeResp.ImpCuota[2]:SCREEN-VALUE)  +
        DEC(CcbValeResp.ImpCuota[3]:SCREEN-VALUE)  +
        DEC(CcbValeResp.ImpCuota[4]:SCREEN-VALUE)  +
        DEC(CcbValeResp.ImpCuota[5]:SCREEN-VALUE)  +
        DEC(CcbValeResp.ImpCuota[6]:SCREEN-VALUE)  +
        DEC(CcbValeResp.ImpCuota[7]:SCREEN-VALUE)  +
        DEC(CcbValeResp.ImpCuota[8]:SCREEN-VALUE)  +
        DEC(CcbValeResp.ImpCuota[9]:SCREEN-VALUE)  +
        DEC(CcbValeResp.ImpCuota[10]:SCREEN-VALUE) +
        DEC(CcbValeResp.ImpCuota[11]:SCREEN-VALUE) +
        DEC(CcbValeResp.ImpCuota[12]:SCREEN-VALUE). 
    DISPLAY FILL-IN-Total.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME} :
    FIND PL-PERS WHERE PL-PERS.codper = CcbValeResp.CodPer:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PL-PERS THEN DO:
        MESSAGE 'Código del personal NO registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO CcbValeResp.CodPer.
        RETURN 'ADM-ERROR'.
    END.
    IF INPUT CcbValeResp.FchCie = ? THEN DO:
        MESSAGE 'Ingrese la fecha de cierre' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO CcbValeResp.FchCie.
        RETURN 'ADM-ERROR'.
    END.

    IF DECIMAL(CcbValeResp.Importe:SCREEN-VALUE) <= 0 THEN DO:
        MESSAGE 'Debe ingresar el Monto' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO CcbValeResp.Importe.
        RETURN 'ADM-ERROR'.
    END.
    IF DECIMAL(CcbValeResp.ImpDescontar:SCREEN-VALUE) <= 0 
        OR DECIMAL(CcbValeResp.ImpDescontar:SCREEN-VALUE) > DECIMAL(CcbValeResp.Importe:SCREEN-VALUE)
        THEN DO:
        MESSAGE 'Error el el Monto a descontar' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO CcbValeResp.ImpDescontar.
        RETURN 'ADM-ERROR'.
    END.
    IF DECIMAL(CcbValeResp.ImpDescontar:SCREEN-VALUE) <> DECIMAL(FILL-IN-Total:SCREEN-VALUE)
        THEN DO:
        MESSAGE 'El total de cuotas no coincide con el monto a descontar'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO CcbValeResp.ImpCuota[1].
        RETURN 'ADM-ERROR'.
    END.


    IF INPUT CcbValeResp.FchIni = ? THEN DO:
        MESSAGE 'Ingrese la fecha de inicial' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO CcbValeResp.FchIni.
        RETURN 'ADM-ERROR'.
    END.
    IF INPUT CcbValeResp.FchFin = ? THEN DO:
        MESSAGE 'Ingrese la fecha final' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO CcbValeResp.FchFin.
        RETURN 'ADM-ERROR'.
    END.

END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE CcbValeResp OR CcbValeResp.FlgEst <> 'P' THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

