&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE b-clie NO-UNDO LIKE gn-clie.



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
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR S-USER-ID AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE VARIABLE cl-codcia  AS INTEGER INITIAL 0 NO-UNDO.
DEF VAR pError AS CHAR NO-UNDO.

/* -- */
DEFINE SHARED VAR s-nivel-acceso AS INT NO-UNDO.

DEFINE TEMP-TABLE ttObjetos
    FIELD   tname   AS  CHAR
    FIELD   ttipo   AS  CHAR
    FIELD   tlabel  AS  CHAR
    FIELD   tfiler  AS  CHAR
    FIELD   tobjetos AS INT
    FIELD   ttabla AS CHAR
    FIELD   ttooltip AS CHAR
    FIELD   tindex AS INT.


DEFINE BUFFER x-factabla FOR factabla.
DEFINE BUFFER x-almtabla FOR almtabla.

DEF VAR pBajaSunat AS LOG NO-UNDO.
DEF VAR pName AS CHAR NO-UNDO.
DEF VAR pAddress AS CHAR NO-UNDO.
DEF VAR pUbigeo AS CHAR NO-UNDO.
DEF VAR pResultado AS CHAR NO-UNDO.
DEF VAR pDateInscription AS DATE NO-UNDO.

IF USERID("DICTDB") = "ADMIN" THEN DO:
    /*MESSAGE "v-mant-clientes-ventas".*/
END.

DEFINE VAR x-paso-x-sunat AS LOG.
DEFINE VAR x-requiere-validacion-sunat AS LOG.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main2

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES gn-clie
&Scoped-define FIRST-EXTERNAL-TABLE gn-clie


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR gn-clie.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS gn-clie.Libre_C01 gn-clie.Flgsit ~
gn-clie.CodCli gn-clie.Rucold gn-clie.Libre_L01 gn-clie.NomCli gn-clie.Ruc ~
gn-clie.CodIBC gn-clie.DNI gn-clie.Libre_F01 gn-clie.ApePat gn-clie.ApeMat ~
gn-clie.Nombre gn-clie.E-Mail gn-clie.Telfnos[1] gn-clie.Transporte[4] ~
gn-clie.Telfnos[2] gn-clie.NroCard gn-clie.Canal gn-clie.CodVen ~
gn-clie.GirCli gn-clie.CndVta gn-clie.ClfCom gn-clie.CodDiv gn-clie.LocCli ~
gn-clie.clfCli gn-clie.CM_ClfCli_P gn-clie.ClfCli2 gn-clie.CM_ClfCli_T ~
gn-clie.RepLeg[1] gn-clie.RepLeg[2] gn-clie.RepLeg[5] gn-clie.RepLeg[4] ~
gn-clie.FNRepr 
&Scoped-define ENABLED-TABLES gn-clie
&Scoped-define FIRST-ENABLED-TABLE gn-clie
&Scoped-Define ENABLED-OBJECTS RECT-31 RECT-33 RECT-34 RECT-35 RECT-36 
&Scoped-Define DISPLAYED-FIELDS gn-clie.Libre_C01 gn-clie.Flgsit ~
gn-clie.CodCli gn-clie.Rucold gn-clie.Libre_L01 gn-clie.NomCli gn-clie.Ruc ~
gn-clie.CodUnico gn-clie.CodIBC gn-clie.DNI gn-clie.Libre_F01 ~
gn-clie.ApePat gn-clie.ApeMat gn-clie.FchCes gn-clie.Nombre gn-clie.E-Mail ~
gn-clie.Telfnos[1] gn-clie.Fching gn-clie.Transporte[4] gn-clie.usuario ~
gn-clie.FchAct gn-clie.Telfnos[2] gn-clie.NroCard gn-clie.Canal ~
gn-clie.CodVen gn-clie.GirCli gn-clie.CndVta gn-clie.ClfCom gn-clie.CodDiv ~
gn-clie.LocCli gn-clie.clfCli gn-clie.CM_ClfCli_P gn-clie.ClfCli2 ~
gn-clie.CM_ClfCli_T gn-clie.RepLeg[1] gn-clie.RepLeg[2] gn-clie.RepLeg[5] ~
gn-clie.RepLeg[4] gn-clie.FNRepr 
&Scoped-define DISPLAYED-TABLES gn-clie
&Scoped-define FIRST-DISPLAYED-TABLE gn-clie
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NomCli f-Canal F-NomVen f-Giro ~
f-Sector f-ConVta f-ClfCli f-ClfCli-cm f-ClfCli2 f-ClfCli2-cm 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEsAlfabetico V-table-Win 
FUNCTION getEsAlfabetico RETURNS LOGICAL
  ( INPUT pCaracter AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetSoloLetras V-table-Win 
FUNCTION GetSoloLetras RETURNS LOGICAL
  ( INPUT pTexto AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWidgetByName V-table-Win 
FUNCTION getWidgetByName returns widget-handle
    ( INPUT phParent as widget-handle, INPUT pcWidgetName as character )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWidgetList V-table-Win 
FUNCTION getWidgetList RETURNS CHARACTER
  ( pwhContainer as widget, pcType as char, pcName as char, pcLabel as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWidgetListRecurr V-table-Win 
FUNCTION getWidgetListRecurr RETURNS CHARACTER
  ( pwhContainer as widget, pcType as char, pcName as char, pcLabel as char  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 4 BY .81 TOOLTIP "Seleccionar condiciones de venta".

DEFINE VARIABLE f-ConVta AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 44 BY 1.73 NO-UNDO.

DEFINE VARIABLE f-Canal AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .81 NO-UNDO.

DEFINE VARIABLE f-ClfCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .81 NO-UNDO.

DEFINE VARIABLE f-ClfCli-cm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .81 NO-UNDO.

DEFINE VARIABLE f-ClfCli2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .81 NO-UNDO.

DEFINE VARIABLE f-ClfCli2-cm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .81 NO-UNDO.

DEFINE VARIABLE f-Giro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .81 NO-UNDO.

DEFINE VARIABLE F-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .81 NO-UNDO.

DEFINE VARIABLE f-Sector AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 132.14 BY 3.85.

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 132.14 BY 4.54.

DEFINE RECTANGLE RECT-34
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 132 BY 6.23.

DEFINE RECTANGLE RECT-35
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 132 BY .23.

DEFINE RECTANGLE RECT-36
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 1 BY 1.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main2
     gn-clie.Libre_C01 AT ROW 1.42 COL 28 NO-LABEL WIDGET-ID 38
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Jurídica", "J":U,
"Natural", "N":U,
"Extranjera", "E":U
          SIZE 27 BY .81
          BGCOLOR 15 FGCOLOR 0 
     gn-clie.Flgsit AT ROW 1.42 COL 57 NO-LABEL WIDGET-ID 54
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Activo", "A":U,
"Cesado", "C":U
          SIZE 17 BY .77
     gn-clie.CodCli AT ROW 1.5 COL 12.14 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
          FONT 4
     gn-clie.Rucold AT ROW 1.54 COL 90 NO-LABEL WIDGET-ID 64
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Si", "Si":U,
"No", "No":U
          SIZE 11.29 BY .77
     gn-clie.Libre_L01 AT ROW 1.54 COL 121 NO-LABEL WIDGET-ID 26
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Si", yes,
"No", no
          SIZE 9.72 BY .77
     gn-clie.NomCli AT ROW 2.35 COL 38.14 COLON-ALIGNED WIDGET-ID 62
          LABEL "Razon social" FORMAT "x(120)"
          VIEW-AS FILL-IN 
          SIZE 80 BY .81
     gn-clie.Ruc AT ROW 2.42 COL 12 COLON-ALIGNED WIDGET-ID 42
          VIEW-AS FILL-IN 
          SIZE 13.86 BY .81
          BGCOLOR 15 FGCOLOR 4 
     gn-clie.CodUnico AT ROW 3.15 COL 50 COLON-ALIGNED WIDGET-ID 4
          LABEL "Cod. Agrupador"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 15 FGCOLOR 12 
     gn-clie.CodIBC AT ROW 3.15 COL 110 COLON-ALIGNED WIDGET-ID 170
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     gn-clie.DNI AT ROW 3.27 COL 12 COLON-ALIGNED WIDGET-ID 52 FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 11 
     gn-clie.Libre_F01 AT ROW 3.96 COL 110 COLON-ALIGNED WIDGET-ID 164
          LABEL "Fecha Inscripción SUNAT"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 14 FGCOLOR 0 
     gn-clie.ApePat AT ROW 4.04 COL 12 COLON-ALIGNED WIDGET-ID 8
          LABEL "Ap. Paterno"
          VIEW-AS FILL-IN 
          SIZE 27 BY .81
          BGCOLOR 11 FGCOLOR 7 
     gn-clie.ApeMat AT ROW 4.04 COL 49.86 COLON-ALIGNED WIDGET-ID 58
          VIEW-AS FILL-IN 
          SIZE 30 BY .81
          BGCOLOR 11 FGCOLOR 7 
     gn-clie.FchCes AT ROW 4.77 COL 110 COLON-ALIGNED WIDGET-ID 86
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     gn-clie.Nombre AT ROW 4.85 COL 12 COLON-ALIGNED WIDGET-ID 10
          LABEL "Nombre" FORMAT "X(120)"
          VIEW-AS FILL-IN 
          SIZE 80 BY .81
          BGCOLOR 11 FGCOLOR 7 
     gn-clie.E-Mail AT ROW 5.58 COL 13 COLON-ALIGNED WIDGET-ID 116
          LABEL "eMail Contacto" FORMAT "X(100)"
          VIEW-AS FILL-IN 
          SIZE 62.57 BY .81
     gn-clie.Telfnos[1] AT ROW 5.58 COL 87 COLON-ALIGNED WIDGET-ID 88
          LABEL "Telefono 1"
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .81
     gn-clie.Fching AT ROW 5.58 COL 110 COLON-ALIGNED WIDGET-ID 92
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     gn-clie.Transporte[4] AT ROW 6.38 COL 13 COLON-ALIGNED WIDGET-ID 46
          LABEL "eMail Fac. Electr." FORMAT "X(150)"
          VIEW-AS FILL-IN 
          SIZE 62.57 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main2
     gn-clie.usuario AT ROW 6.38 COL 110 COLON-ALIGNED WIDGET-ID 12
          LABEL "Actualizado por"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     gn-clie.FchAct AT ROW 6.38 COL 120.72 COLON-ALIGNED NO-LABEL WIDGET-ID 124
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     gn-clie.Telfnos[2] AT ROW 6.42 COL 87 COLON-ALIGNED WIDGET-ID 90
          LABEL "Telefono 2"
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .81
     gn-clie.NroCard AT ROW 7.73 COL 17 COLON-ALIGNED WIDGET-ID 114
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     FILL-IN-NomCli AT ROW 7.73 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 110
     gn-clie.Canal AT ROW 7.73 COL 82 COLON-ALIGNED WIDGET-ID 94
          LABEL "Grupo de cliente[Canal]" FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     f-Canal AT ROW 7.73 COL 90 COLON-ALIGNED NO-LABEL WIDGET-ID 102
     gn-clie.CodVen AT ROW 8.54 COL 17 COLON-ALIGNED WIDGET-ID 100
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     F-NomVen AT ROW 8.54 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 108
     gn-clie.GirCli AT ROW 8.54 COL 82 COLON-ALIGNED WIDGET-ID 112
          LABEL "Giro" FORMAT "X(4)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     f-Giro AT ROW 8.54 COL 90 COLON-ALIGNED NO-LABEL WIDGET-ID 106
     gn-clie.CndVta AT ROW 9.35 COL 17 COLON-ALIGNED WIDGET-ID 98 FORMAT "X(256)"
          VIEW-AS FILL-IN 
          SIZE 44 BY .81
     BUTTON-1 AT ROW 9.35 COL 63 WIDGET-ID 118
     gn-clie.ClfCom AT ROW 9.35 COL 82 COLON-ALIGNED WIDGET-ID 166
          LABEL "Sector Económico" FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     f-Sector AT ROW 9.35 COL 90 COLON-ALIGNED NO-LABEL WIDGET-ID 168
     f-ConVta AT ROW 10.15 COL 19 NO-LABEL WIDGET-ID 32
     gn-clie.CodDiv AT ROW 10.15 COL 82 COLON-ALIGNED WIDGET-ID 120
          LABEL "Division de atención" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     gn-clie.LocCli AT ROW 10.96 COL 80 NO-LABEL WIDGET-ID 48
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "VIP", "VIP":U,
"MESA REDONDA", "MR":U,
"OTROS", "",
"BODEGUERO", "BODEGUERO":U,
"LIBRERO", "LIBRERO":U
          SIZE 53 BY .81
     gn-clie.clfCli AT ROW 12.08 COL 22.86 COLON-ALIGNED WIDGET-ID 96
          LABEL "Clasif. Productos PROPIOS"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     f-ClfCli AT ROW 12.08 COL 28.86 COLON-ALIGNED NO-LABEL WIDGET-ID 104
     gn-clie.CM_ClfCli_P AT ROW 12.08 COL 82.86 COLON-ALIGNED WIDGET-ID 126
          LABEL "Clasif. Productos PROPIOS" FORMAT "x(2)"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     f-ClfCli-cm AT ROW 12.08 COL 88.57 COLON-ALIGNED NO-LABEL WIDGET-ID 130
     gn-clie.ClfCli2 AT ROW 12.85 COL 22.86 COLON-ALIGNED WIDGET-ID 22
          LABEL "Clasif. Productos TERCEROS:"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     f-ClfCli2 AT ROW 12.85 COL 28.86 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     gn-clie.CM_ClfCli_T AT ROW 12.85 COL 82.86 COLON-ALIGNED WIDGET-ID 128
          LABEL "Clasif. Productos TERCEROS" FORMAT "x(2)"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main2
     f-ClfCli2-cm AT ROW 12.85 COL 88.57 COLON-ALIGNED NO-LABEL WIDGET-ID 132
     gn-clie.RepLeg[1] AT ROW 14.12 COL 14.86 COLON-ALIGNED WIDGET-ID 150
          LABEL "Nombre y Apellido" FORMAT "X(256)"
          VIEW-AS FILL-IN 
          SIZE 54 BY .81
     gn-clie.RepLeg[2] AT ROW 14.12 COL 79.86 COLON-ALIGNED WIDGET-ID 152
          LABEL "DNI" FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .81
     gn-clie.RepLeg[5] AT ROW 14.19 COL 99.86 COLON-ALIGNED WIDGET-ID 156
          LABEL "Telefono" FORMAT "X(30)"
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .81
     gn-clie.RepLeg[4] AT ROW 14.88 COL 14.86 COLON-ALIGNED WIDGET-ID 154
          LABEL "Direccion Domicilio" FORMAT "X(256)"
          VIEW-AS FILL-IN 
          SIZE 54 BY .81
     gn-clie.FNRepr AT ROW 14.88 COL 79.86 COLON-ALIGNED WIDGET-ID 148
          LABEL "Fch.Nac."
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .81
     "  Representante legal" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 13.65 COL 3.57 WIDGET-ID 160
          FGCOLOR 9 
     "Agente de Percepción:" VIEW-AS TEXT
          SIZE 16 BY .5 AT ROW 1.54 COL 104 WIDGET-ID 30
     "  Contrato Marco" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 11.73 COL 65.14 WIDGET-ID 138
          FGCOLOR 9 FONT 4
     "  Datos para la venta" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 7.35 COL 3.57 WIDGET-ID 142
          FGCOLOR 9 
     "  Datos del cliente" VIEW-AS TEXT
          SIZE 13.86 BY .5 TOOLTIP "Pruebassssssssssssssssssss" AT ROW 1 COL 3.14 WIDGET-ID 146
          FGCOLOR 9 
     "Agente Retenedor:" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 1.54 COL 76 WIDGET-ID 68
     RECT-31 AT ROW 11.96 COL 1.86 WIDGET-ID 134
     RECT-33 AT ROW 7.46 COL 1.86 WIDGET-ID 140
     RECT-34 AT ROW 1.23 COL 2 WIDGET-ID 144
     RECT-35 AT ROW 13.77 COL 2 WIDGET-ID 158
     RECT-36 AT ROW 11.96 COL 62 WIDGET-ID 162
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.gn-clie
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: b-clie T "?" NO-UNDO INTEGRAL gn-clie
   END-TABLES.
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
         HEIGHT             = 16.73
         WIDTH              = 150.72.
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
/* SETTINGS FOR FRAME F-Main2
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME F-Main2:SCROLLABLE       = FALSE
       FRAME F-Main2:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN gn-clie.ApePat IN FRAME F-Main2
   EXP-LABEL                                                            */
/* SETTINGS FOR BUTTON BUTTON-1 IN FRAME F-Main2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.Canal IN FRAME F-Main2
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.clfCli IN FRAME F-Main2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.ClfCli2 IN FRAME F-Main2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.ClfCom IN FRAME F-Main2
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.CM_ClfCli_P IN FRAME F-Main2
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.CM_ClfCli_T IN FRAME F-Main2
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.CndVta IN FRAME F-Main2
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN gn-clie.CodDiv IN FRAME F-Main2
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.CodUnico IN FRAME F-Main2
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN gn-clie.DNI IN FRAME F-Main2
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN gn-clie.E-Mail IN FRAME F-Main2
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN f-Canal IN FRAME F-Main2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-ClfCli IN FRAME F-Main2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-ClfCli-cm IN FRAME F-Main2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-ClfCli2 IN FRAME F-Main2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-ClfCli2-cm IN FRAME F-Main2
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR f-ConVta IN FRAME F-Main2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-Giro IN FRAME F-Main2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomVen IN FRAME F-Main2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-Sector IN FRAME F-Main2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.FchAct IN FRAME F-Main2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.FchCes IN FRAME F-Main2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.Fching IN FRAME F-Main2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.FNRepr IN FRAME F-Main2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.GirCli IN FRAME F-Main2
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.Libre_F01 IN FRAME F-Main2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.Nombre IN FRAME F-Main2
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.NomCli IN FRAME F-Main2
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.RepLeg[1] IN FRAME F-Main2
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.RepLeg[2] IN FRAME F-Main2
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.RepLeg[4] IN FRAME F-Main2
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.RepLeg[5] IN FRAME F-Main2
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.Telfnos[1] IN FRAME F-Main2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.Telfnos[2] IN FRAME F-Main2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.Transporte[4] IN FRAME F-Main2
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.usuario IN FRAME F-Main2
   NO-ENABLE EXP-LABEL                                                  */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main2
/* Query rebuild information for FRAME F-Main2
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gn-clie.ApeMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.ApeMat V-table-Win
ON LEAVE OF gn-clie.ApeMat IN FRAME F-Main2 /* Ap. Materno */
DO:
    SELF:SCREEN-VALUE = CAPS(TRIM(SELF:SCREEN-VALUE)).

    gn-clie.nomcli:SCREEN-VALUE = TRIM (gn-clie.apepat:SCREEN-VALUE) + " " +
        TRIM (gn-clie.apemat:SCREEN-VALUE) + ", " +
        gn-clie.nombre:SCREEN-VALUE.
    IF gn-clie.apepat:SCREEN-VALUE = '' AND gn-clie.apemat:SCREEN-VALUE = '' 
    THEN gn-clie.nomcli:SCREEN-VALUE = gn-clie.nombre:SCREEN-VALUE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.ApePat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.ApePat V-table-Win
ON LEAVE OF gn-clie.ApePat IN FRAME F-Main2 /* Ap. Paterno */
DO:
    SELF:SCREEN-VALUE = CAPS(TRIM(SELF:SCREEN-VALUE)).

    gn-clie.nomcli:SCREEN-VALUE = TRIM (gn-clie.apepat:SCREEN-VALUE) + " " +
        TRIM (gn-clie.apemat:SCREEN-VALUE) + ", " +
        gn-clie.nombre:SCREEN-VALUE.
    IF gn-clie.apepat:SCREEN-VALUE = '' AND gn-clie.apemat:SCREEN-VALUE = '' 
    THEN gn-clie.nomcli:SCREEN-VALUE = gn-clie.nombre:SCREEN-VALUE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 V-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main2 /* ... */
DO:
    DEF VAR x-Condiciones AS CHAR.
    DEF VAR x-Descripcion AS CHAR.
    x-Condiciones = gn-clie.CndVta:SCREEN-VALUE.
    x-Descripcion = f-ConVta:SCREEN-VALUE.
    RUN vta/d-repo10 (INPUT-OUTPUT x-Condiciones, INPUT-OUTPUT x-Descripcion).
    gn-clie.CndVta:SCREEN-VALUE = x-Condiciones.
    f-convta:SCREEN-VALUE = x-Descripcion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.Canal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.Canal V-table-Win
ON LEAVE OF gn-clie.Canal IN FRAME F-Main2 /* Grupo de cliente[Canal] */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO:
     FIND almtabla WHERE almtabla.Tabla = 'CN' 
        AND almtabla.Codigo = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE almtabla 
     THEN F-Canal:screen-value = almtabla.nombre.
     ELSE F-Canal:screen-value = "".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.Canal V-table-Win
ON MOUSE-SELECT-DBLCLICK OF gn-clie.Canal IN FRAME F-Main2 /* Grupo de cliente[Canal] */
DO:
  ASSIGN
    input-var-1 = 'CN'
    input-var-2 = ''
    input-var-3 = ''
    output-var-1 = ?            /* Rowid */
    output-var-2 = ''
    output-var-3 = ''.

  RUN lkup/C-ALMTAB ('Grupos de Cliente').
  IF output-var-1 = ? THEN RETURN 'ADM-ERROR'.
  SELF:SCREEN-VALUE  = output-var-2 .
  f-canal:SCREEN-VALUE = output-var-3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.clfCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.clfCli V-table-Win
ON LEAVE OF gn-clie.clfCli IN FRAME F-Main2 /* Clasif. Productos PROPIOS */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  f-ClfCli:SCREEN-VALUE = 'SIN CLASIFICACION'.
  FIND ClfClie WHERE ClfClie.Categoria = gn-clie.clfCli NO-LOCK NO-ERROR.
  IF AVAILABLE ClfClie THEN f-ClfCli:SCREEN-VALUE = ClfClie.DesCat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.ClfCli2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.ClfCli2 V-table-Win
ON LEAVE OF gn-clie.ClfCli2 IN FRAME F-Main2 /* Clasif. Productos TERCEROS: */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    f-ClfCli2:SCREEN-VALUE = 'SIN CLASIFICACION'.
    FIND ClfClie WHERE ClfClie.Categoria = gn-clie.clfCli NO-LOCK NO-ERROR.
    IF AVAILABLE ClfClie THEN f-ClfCli2:SCREEN-VALUE = ClfClie.DesCat.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.ClfCom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.ClfCom V-table-Win
ON LEAVE OF gn-clie.ClfCom IN FRAME F-Main2 /* Sector Económico */
DO:
    F-Sector:screen-value = "".
    IF SELF:SCREEN-VALUE <> "" THEN DO:
        FIND almtabla WHERE almtabla.Tabla = 'SE' 
            AND almtabla.Codigo = SELF:SCREEN-VALUE 
            NO-LOCK NO-ERROR.
        IF AVAILABLE almtabla THEN DO:
            F-Sector:screen-value = almtabla.nombre.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.ClfCom V-table-Win
ON LEFT-MOUSE-DBLCLICK OF gn-clie.ClfCom IN FRAME F-Main2 /* Sector Económico */
DO:
    ASSIGN
      input-var-1 = 'SE'
      input-var-2 = ''
      input-var-3 = ''
      output-var-1 = ?            /* Rowid */
      output-var-2 = ''
      output-var-3 = ''.

    RUN lkup/C-ALMTAB ('Sector Económico').
    IF output-var-1 = ? THEN RETURN 'ADM-ERROR'.
    SELF:SCREEN-VALUE  = output-var-2 .
    f-Sector:SCREEN-VALUE = output-var-3.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.CM_ClfCli_P
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.CM_ClfCli_P V-table-Win
ON LEAVE OF gn-clie.CM_ClfCli_P IN FRAME F-Main2 /* Clasif. Productos PROPIOS */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    f-ClfCli-cm:SCREEN-VALUE = 'SIN CLASIFICACION'.
    FIND ClfClie WHERE ClfClie.Categoria = gn-clie.clfCli NO-LOCK NO-ERROR.
    IF AVAILABLE ClfClie THEN f-ClfCli-cm:SCREEN-VALUE = ClfClie.DesCat.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.CM_ClfCli_T
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.CM_ClfCli_T V-table-Win
ON LEAVE OF gn-clie.CM_ClfCli_T IN FRAME F-Main2 /* Clasif. Productos TERCEROS */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    f-ClfCli2-cm:SCREEN-VALUE = 'SIN CLASIFICACION'.
    FIND ClfClie WHERE ClfClie.Categoria = gn-clie.clfCli NO-LOCK NO-ERROR.
    IF AVAILABLE ClfClie THEN f-ClfCli2-cm:SCREEN-VALUE = ClfClie.DesCat.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.CndVta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.CndVta V-table-Win
ON LEAVE OF gn-clie.CndVta IN FRAME F-Main2 /* Condicion de Venta */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO:
     FIND gn-convt WHERE gn-convt.Codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt 
     THEN F-ConVta:screen-value = gn-convt.Nombr.
     ELSE F-Convta:screen-value = "".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.CodCli V-table-Win
ON LEAVE OF gn-clie.CodCli IN FRAME F-Main2 /* Codigo */
DO:
  SELF:SCREEN-VALUE = REPLACE(SELF:SCREEN-VALUE,",","").
  SELF:SCREEN-VALUE = REPLACE(SELF:SCREEN-VALUE,".","").

  SELF:SCREEN-VALUE = CAPS(TRIM(SELF:SCREEN-VALUE)).

    DEF VAR x-codigo AS INT64 NO-UNDO.
    ASSIGN x-codigo = INT64(SELF:SCREEN-VALUE) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'DNI debe contener solo números' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    SELF:SCREEN-VALUE = STRING(x-codigo,"99999999999").
  
    IF x-codigo <= 99999999 OR SUBSTRING(SELF:SCREEN-VALUE,1,2) = "10" THEN DO:
        gn-clie.libre_c01:SCREEN-VALUE = "N".
        IF x-codigo <= 99999999 THEN DO:
            gn-clie.dni:SCREEN-VALUE = STRING(x-codigo,"99999999").
        END.
        ELSE DO:
            gn-clie.dni:SCREEN-VALUE = SUBSTRING(SELF:SCREEN-VALUE,3,8).
        END.
    END.
    ELSE DO:
        IF SUBSTRING(SELF:SCREEN-VALUE,1,2) = "20" THEN gn-clie.libre_c01:SCREEN-VALUE = "J".
        IF SUBSTRING(SELF:SCREEN-VALUE,1,2) <> "20" THEN gn-clie.libre_c01:SCREEN-VALUE = "E".
    END.
        
    gn-clie.ruc:SCREEN-VALUE = "".
    IF SUBSTRING(SELF:SCREEN-VALUE,1,2) = "10" OR 
        SUBSTRING(SELF:SCREEN-VALUE,1,2) = "20" THEN DO:
        gn-clie.ruc:SCREEN-VALUE = SELF:SCREEN-VALUE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.CodVen V-table-Win
ON LEAVE OF gn-clie.CodVen IN FRAME F-Main2 /* Codigo Vendedor */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO:
     FIND gn-ven WHERE gn-ven.codcia = s-codcia
        AND gn-ven.CodVen = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven 
     THEN F-NomVen:screen-value = gn-ven.NomVen.
     ELSE F-NomVen:screen-value = "".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.GirCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.GirCli V-table-Win
ON LEAVE OF gn-clie.GirCli IN FRAME F-Main2 /* Giro */
DO:
  F-Giro:screen-value = "".
  IF SELF:SCREEN-VALUE <> "" THEN DO:
      FIND almtabla WHERE almtabla.Tabla = 'GN' 
          AND almtabla.Codigo = SELF:SCREEN-VALUE 
          NO-LOCK NO-ERROR.
      IF AVAILABLE almtabla THEN DO:
          F-Giro:screen-value = almtabla.nombre.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.GirCli V-table-Win
ON MOUSE-SELECT-DBLCLICK OF gn-clie.GirCli IN FRAME F-Main2 /* Giro */
DO:
  DEFINE VAR x-grupo AS CHAR.

  ASSIGN
    input-var-1 = 'CN-GN'
    input-var-2 = gn-clie.canal:SCREEN-VALUE
    input-var-3 = 'GN'
    output-var-1 = ?            /* Rowid */
    output-var-2 = ''
    output-var-3 = ''.

  RUN lkup/c-grupo-giro-clientes ("TABLA DE CONTROL GRUPO GIRO").
  IF output-var-1 = ? THEN RETURN "ADM-ERROR".
  SELF:SCREEN-VALUE   = output-var-2 .
  f-giro:SCREEN-VALUE = output-var-3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.Libre_C01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.Libre_C01 V-table-Win
ON VALUE-CHANGED OF gn-clie.Libre_C01 IN FRAME F-Main2 /* Libre_C01 */
DO:
  
    IF gn-clie.Libre_C01:SCREEN-VALUE <> "N" THEN DO:
        ASSIGN
        gn-clie.ApeMat:SENSITIVE = NO
        gn-clie.ApePat:SENSITIVE = NO
        gn-clie.Nombre:SENSITIVE = NO
        gn-clie.dni:SENSITIVE = NO
        gn-clie.Nomcli:SENSITIVE = YES
        gn-clie.ruc:SENSITIVE = YES
        gn-clie.ApeMat:SCREEN-VALUE = ''
        gn-clie.ApePat:SCREEN-VALUE = ''
        gn-clie.nombre:SCREEN-VALUE = ''.
    END.
    ELSE DO:
        ASSIGN gn-clie.ApeMat:SENSITIVE = YES
        gn-clie.ApePat:SENSITIVE = YES
        gn-clie.Nombre:SENSITIVE = YES
        gn-clie.dni:SENSITIVE = YES
        gn-clie.nomcli:SENSITIVE = NO
        gn-clie.ruc:SENSITIVE = NO.

        APPLY 'LEAVE':U TO gn-clie.ApePat.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.Nombre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.Nombre V-table-Win
ON LEAVE OF gn-clie.Nombre IN FRAME F-Main2 /* Nombre */
DO:
    SELF:SCREEN-VALUE = CAPS(TRIM(SELF:SCREEN-VALUE)).

    gn-clie.nomcli:SCREEN-VALUE = TRIM (gn-clie.apepat:SCREEN-VALUE) + " " +
        TRIM (gn-clie.apemat:SCREEN-VALUE) + ", " + gn-clie.nombre:SCREEN-VALUE.

    IF gn-clie.apepat:SCREEN-VALUE = '' AND gn-clie.apemat:SCREEN-VALUE = '' 
    THEN gn-clie.nomcli:SCREEN-VALUE = gn-clie.nombre:SCREEN-VALUE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.NomCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.NomCli V-table-Win
ON LEAVE OF gn-clie.NomCli IN FRAME F-Main2 /* Razon social */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.NroCard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.NroCard V-table-Win
ON LEAVE OF gn-clie.NroCard IN FRAME F-Main2 /* NroCard */
DO:
  FILL-IN-NomCli:SCREEN-VALUE = ''.
  IF SELF:SCREEN-VALUE <> ''
  THEN DO:
    FIND GN-CARD WHERE gn-card.nrocard = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-card THEN FILL-IN-NomCli:SCREEN-VALUE = gn-card.nomcard.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.Ruc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.Ruc V-table-Win
ON LEAVE OF gn-clie.Ruc IN FRAME F-Main2 /* Ruc */
DO:

    x-paso-x-sunat = NO .
    x-requiere-validacion-sunat = NO.

    IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
    /* Dígito Verificador */
    IF gn-clie.Libre_C01:SCREEN-VALUE <> "E" THEN DO:
        RUN lib/_ValRuc (gn-clie.Ruc:SCREEN-VALUE, OUTPUT pResultado).
        IF pResultado = 'ERROR' THEN DO:
            MESSAGE 'Código MAL registrado' VIEW-AS ALERT-BOX WARNING.
            gn-clie.RUC:SCREEN-VALUE = ''.
            RETURN NO-APPLY.
        END.
    END.
    /* Verificamos Información SUNAT */    
    /*
    IF gn-clie.Libre_C01:SCREEN-VALUE <> "E" AND NOT (TRUE <> (gn-clie.ruc:SCREEN-VALUE > "")) THEN DO:
        IF TODAY <> DATE(01,08,2020) THEN DO:
            SESSION:SET-WAIT-STATE("GENERAL"). 

            x-paso-x-sunat = YES.

            RUN requiere-validar-con-sunat(INPUT 'RUC', OUTPUT x-requiere-validacion-sunat).

            x-requiere-validacion-sunat = NO.

            MESSAGE "Validacion" SKIP
                        x-requiere-validacion-sunat.

            IF x-requiere-validacion-sunat = YES THEN DO:
                /*
                RUN gn/datos-sunat-clientes.r ( 
                    INPUT gn-clie.Ruc:SCREEN-VALUE,
                    OUTPUT pBajaSunat,
                    OUTPUT pName,
                    OUTPUT pAddress,
                    OUTPUT pUbigeo,
                    OUTPUT pDateInscription,
                    OUTPUT pError ).
                SESSION:SET-WAIT-STATE("").                                
                */
                pError = "ERORR EN SUNAT".

                IF pError > '' THEN DO:
                    MESSAGE 'Se ha detectado el siguiente error:' SKIP
                        pError SKIP
                        'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION
                        BUTTONS YES-NO UPDATE rpta AS LOG.
                    IF rpta = NO THEN DO:
                        gn-clie.RUC:SCREEN-VALUE = ''.
                        RETURN NO-APPLY.
                    END.
                    x-paso-x-sunat = NO.
                END.
            END.
            ELSE DO:
                x-paso-x-sunat = NO.
            END.

            IF x-paso-x-sunat = YES AND pBajaSunat = YES THEN DO:
                MESSAGE 'El RUC está de baja en SUNAT' VIEW-AS ALERT-BOX ERROR.
                gn-clie.RUC:SCREEN-VALUE = ''.
                RETURN NO-APPLY.
            END.

            /*  */
            IF gn-clie.Ruc:SCREEN-VALUE <> gn-clie.codcli:SCREEN-VALUE THEN DO:
                gn-clie.codcli:SCREEN-VALUE = gn-clie.Ruc:SCREEN-VALUE.
            END.
            gn-clie.Libre_C01:SCREEN-VALUE = "J".
            IF SUBSTRING(gn-clie.ruc:SCREEN-VALUE,1,2) = '10' THEN DO:
                gn-clie.Libre_C01:SCREEN-VALUE = "N".
            END.
            ELSE DO:
                gn-clie.Libre_C01:SCREEN-VALUE = "E ".
            END.

        END.
    END.
    */
    IF gn-clie.Libre_C01:SCREEN-VALUE = "J" THEN
        DISPLAY 
        gn-clie.Ruc:SCREEN-VALUE @ gn-clie.CodCli
        pName @ gn-clie.Nombre
        pName @ gn-clie.NomCli 
        pDateInscription @ gn-clie.Libre_F01
        WITH FRAME {&FRAME-NAME}.
    DISPLAY pName @ gn-clie.NomCli WITH FRAME {&FRAME-NAME}.
    APPLY 'VALUE-CHANGED':U TO gn-clie.Libre_C01.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.Telfnos[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.Telfnos[1] V-table-Win
ON ENTRY OF gn-clie.Telfnos[1] IN FRAME F-Main2 /* Telefono 1 */
DO:
    
  /*
  x-handle = SELF:HANDLE.

  MESSAGE "Name " x-handle:NAME SKIP
        "Type " x-handle:TYPE SKIP
        "Label " x-handle:LABEL SKIP
        "Frame-Name " x-handle:FRAME-NAME SKIP
        "Window " x-handle:WINDOW SKIP
        "Tab-position " x-handle:TAB-POSITION.
    */        
        

        /*
    {slib/slibwidget.i}
    
    define var cWidgetList  as char no-undo.
    
    define var wdgh         as widget no-undo.
    define var i            as int no-undo.
    
    
    cWidgetList = widget_getWidgetList( 
    
        input current-window,   /* parent to search in. the search will drill down all the levels. */
    
            /* you can also try the session handle */
    
        input ?,                /* type e.g. window, frame, fill-in */
        input ?,                /* name where applicable */
        input ? ).              /* label where applicable */
    
    
    
    repeat i = 1 to num-entries( cWidgetList ):
    
        wdgh = widget-handle( entry( i, cWidgetList ) ).
    
        display
            wdgh:type
            wdgh:name.
    
    end. /* repeat */
    */
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

{slib/slibwidget.i}

/*
*/

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
  HIDE FRAME F-Main2.
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

  IF NOT (s-nivel-acceso = 1 OR s-nivel-acceso = 2) THEN DO:
      MESSAGE "No tiene el perfil para adicionar Clientes" VIEW-AS ALERT-BOX INFORMATION.
      RETURN "ADM-ERROR".
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME} :
      IF gn-clie.Libre_C01:SCREEN-VALUE <> "N" THEN DO:
          ASSIGN
          gn-clie.ApeMat:SENSITIVE = NO
          gn-clie.ApePat:SENSITIVE = NO
          gn-clie.Nombre:SENSITIVE = NO
          gn-clie.dni:SENSITIVE = NO
          gn-clie.Nomcli:SENSITIVE = YES
          gn-clie.ruc:SENSITIVE = YES
          gn-clie.ApeMat:SCREEN-VALUE = ''
          gn-clie.ApePat:SCREEN-VALUE = ''
          gn-clie.nombre:SCREEN-VALUE = ''.
      END.
      ELSE DO:
          ASSIGN gn-clie.ApeMat:SENSITIVE = YES
          gn-clie.ApePat:SENSITIVE = YES
          gn-clie.Nombre:SENSITIVE = YES
          gn-clie.dni:SENSITIVE = YES
          gn-clie.nomcli:SENSITIVE = NO
          gn-clie.ruc:SENSITIVE = NO.

          APPLY 'LEAVE':U TO gn-clie.ApePat.
      END.
  END.

  ASSIGN
      gn-clie.Rucold:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'No'
      gn-clie.Libre_L01:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'No'
      gn-clie.clfCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'C'
      gn-clie.clfCli2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'C'
      gn-clie.Flgsit:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'A'
      gn-clie.Libre_C01:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'N'.

  IF s-CodDiv = '00024' THEN gn-clie.CodDiv:SCREEN-VALUE IN FRAME {&FRAME-NAME} = s-CodDiv.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-apply-layout V-table-Win 
PROCEDURE local-apply-layout :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'apply-layout':U ) .

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
  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR cEvento AS CHAR INIT "CREATE" NO-UNDO.
  DEF VAR x-Mensaje AS CHAR NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN get-attribute("ADM-NEW-RECORD").
  IF RETURN-VALUE = "YES" THEN DO:
     ASSIGN 
         gn-clie.clfcli = "C"       /* por defecto */
         gn-clie.clfcli2 = "C"       /* por defecto */
         gn-clie.CodCia = CL-CODCIA
         gn-clie.Fching = TODAY.
     /* Buscamos RUC repetidos */
     IF gn-clie.Ruc <> '' THEN DO:
         x-Mensaje = ''.
         FOR EACH b-clie NO-LOCK WHERE b-clie.codcia = cl-codcia AND
             b-clie.ruc = gn-clie.Ruc AND
             ROWID(b-clie) <> ROWID(gn-clie):
             x-Mensaje = x-Mensaje + (IF x-Mensaje <> '' THEN CHR(10) ELSE '') +
                 b-clie.codcli + ' ' + b-clie.nomcli.
         END.
         IF x-Mensaje <> '' THEN DO:
             MESSAGE 'Los siguientes clientes tienen el mismo RUC:' SKIP
                 x-Mensaje SKIP(1)
                 'Continuamos con la grabación?'
                 VIEW-AS ALERT-BOX WARNING
                 BUTTONS YES-NO UPDATE rpta AS LOG.
             IF rpta = NO THEN UNDO, RETURN "ADM-ERROR".
             cEvento = "CREATE*".
         END.
     END.
     /* Solo para cliente NUEVO INSTITUCIONALES */
     IF s-CodDiv = "00024" THEN DO:
         ASSIGN
             GN-CLIE.FlagAut = 'A'          /* POR DEFECTO */
             Gn-clie.FchAut[1] = TODAY
             gn-clie.usrAut = S-USER-ID.
         /* RHC 05.10.04 Historico de lineas de credito */
         CREATE LogTabla.
         ASSIGN
             logtabla.codcia = s-codcia
             logtabla.Dia = TODAY
             logtabla.Evento = 'LINEA-CREDITO-A'
             logtabla.Hora = STRING(TIME, 'HH:MM')
             logtabla.Tabla = 'GN-CLIE'
             logtabla.Usuario = s-user-id
             logtabla.ValorLlave = STRING(gn-clie.codcli, 'x(11)') + '|' +
             STRING(gn-clie.nomcli, 'x(50)') + '|' +
             STRING(gn-clie.FlagAut, 'X').
         RELEASE LogTabla.
     END.
     /* Información de SUNAT */
     /* Verificamos Información SUNAT */
    
     /*  */
     IF TODAY <> DATE(01,08,2020) THEN DO:
         IF NOT (TRUE <> (gn-clie.Ruc > "")) THEN DO:
             RUN gn/datos-sunat-clientes (
                 INPUT gn-clie.Ruc,
                 OUTPUT pBajaSunat,
                 OUTPUT pName,
                 OUTPUT pAddress,
                 OUTPUT pUbigeo,
                 OUTPUT pDateInscription,
                 OUTPUT pError ).
             IF TRUE <> (pError > "") THEN DO:
                 ASSIGN
                 gn-clie.SwCargaSunat = "S"     /* SUNAT */
                 gn-clie.DirCli = pAddress
                 gn-clie.CodDept = SUBSTRING(pUbigeo,1,2)
                 gn-clie.CodProv = SUBSTRING(pUbigeo,3,2)
                 gn-clie.CodDist = SUBSTRING(pUbigeo,5,2)
                 gn-clie.Libre_F01 = pDateInscription.
             END.
         END.
     END.    
     
  END.
  ELSE cEvento = "WRITE".
  ASSIGN
      gn-clie.nomcli  = gn-clie.nomcli:SCREEN-VALUE IN FRAME {&FRAME-NAME}
      gn-clie.usuario = s-user-id
      gn-clie.fchact = TODAY.
  IF gn-clie.Flgsit = 'C'
  THEN gn-clie.fchces = TODAY.
  ELSE gn-clie.fchces = ?.

  /* RHC 25.10.04 Historico */
  RUN lib/logtabla ("gn-clie", STRING(gn-clie.codcia, '999') + '|' +
                    STRING(gn-clie.codcli, 'x(11)'), cEvento).

/*   CREATE LogTabla.                                              */
/*   ASSIGN                                                        */
/*     logtabla.codcia = s-codcia                                  */
/*     logtabla.Dia = TODAY                                        */
/*     logtabla.Evento = 'WRITE'                                   */
/*     logtabla.Hora = STRING(TIME, 'HH:MM')                       */
/*     logtabla.Tabla = 'GN-CLIE'                                  */
/*     logtabla.Usuario = s-user-id                                */
/*     logtabla.ValorLlave = STRING(gn-clie.codcia, '999') + '|' + */
/*                             STRING(gn-clie.codcli, 'x(11)').    */
/*   RELEASE LogTabla.                                             */
   
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    DO WITH FRAME {&FRAME-NAME} :
        IF AVAILABLE Gn-clie THEN DO WITH frame {&FRAME-NAME}:
          /*
          FIND  TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
          IF AVAILABLE TabDepto THEN DISPLAY TabDepto.NomDepto @ fill-in-dep.

          FIND  Tabprovi WHERE Tabprovi.CodDepto = gn-clie.CodDept 
                          AND  Tabprovi.Codprovi = gn-clie.codprov 
                         NO-LOCK NO-ERROR.
          IF AVAILABLE Tabprovi THEN DISPLAY Tabprovi.Nomprovi @ fill-in-prov.

          FIND  Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept 
                          AND  Tabdistr.Codprovi = gn-clie.codprov 
                          AND  Tabdistr.Coddistr = gn-clie.coddist 
                         NO-LOCK NO-ERROR.
          IF AVAILABLE Tabdistr THEN DISPLAY Tabdistr.Nomdistr @ fill-in-dis.

          FIND almtabla WHERE almtabla.Tabla = 'CP' 
                         AND  almtabla.Codigo = gn-clie.CodPos  
                        NO-LOCK NO-ERROR.
          IF AVAILABLE  almtabla THEN DISPLAY almtabla.nombre @ FILL-IN-POS.
          */
          FIND almtabla WHERE almtabla.Tabla = 'GN' 
                       AND  almtabla.Codigo = gn-clie.GirCli
                      NO-LOCK NO-ERROR.
          IF AVAILABLE  almtabla THEN DISPLAY almtabla.nombre @ f-giro.
          FIND almtabla WHERE almtabla.Tabla = 'SE' 
                       AND  almtabla.Codigo = gn-clie.ClfCom
                      NO-LOCK NO-ERROR.
          IF AVAILABLE  almtabla THEN DISPLAY almtabla.nombre @ f-sector.
           
          FIND gn-ven WHERE gn-ven.codcia = s-codcia
            AND gn-ven.CodVen = gn-clie.CodVen NO-LOCK NO-ERROR.
          IF AVAILABLE  gn-ven THEN DISPLAY gn-ven.NomVen @ f-NomVen.

          DEFINE VAR k AS INT.
          DEFINE VAR i AS INT.

          DO k = 1 TO NUM-ENTRIES(gn-clie.cndvta):
              FIND gn-convt WHERE gn-convt.codig = ENTRY(k, gn-clie.cndvta) NO-LOCK NO-ERROR.
              IF AVAILABLE gn-convt THEN DO:
                  IF i = 1 
                  THEN ASSIGN
                          f-convta:SCREEN-VALUE = TRIM(gn-convt.nombr).
                  ELSE ASSIGN
                          f-convta:SCREEN-VALUE = f-convta:SCREEN-VALUE + ',' + TRIM(gn-convt.nombr).
                  i = i + 1.
              END.
          END.

        FIND almtabla WHERE almtabla.Tabla = 'CN' 
                       AND  almtabla.Codigo = gn-clie.Canal 
                      NO-LOCK NO-ERROR.
        IF AVAILABLE  almtabla THEN DISPLAY almtabla.nombre @ f-canal.
    
        /*FILL-IN-NomCli:SCREEN-VALUE = ''.*/

        IF gn-clie.nrocard <> '' THEN DO:
            FIND gn-card WHERE gn-card.nrocard = gn-clie.nrocard
                NO-LOCK NO-ERROR.
            IF AVAILABLE gn-card THEN FILL-IN-NomCli:SCREEN-VALUE = gn-card.nomcard.
        END.
    
        ASSIGN
            f-ClfCli = 'SIN CLASIFICACION'
            f-ClfCli2 = 'SIN CLASIFICACION'.
            FIND ClfClie WHERE ClfClie.Categoria = gn-clie.clfCli NO-LOCK NO-ERROR.
            IF AVAILABLE ClfClie THEN f-ClfCli:SCREEN-VALUE = ClfClie.DesCat.
            FIND ClfClie WHERE ClfClie.Categoria = gn-clie.clfCli2 NO-LOCK NO-ERROR.
            IF AVAILABLE ClfClie THEN f-ClfCli2:SCREEN-VALUE = ClfClie.DesCat.

       ASSIGN
            f-ClfCli-cm = 'SIN CLASIFICACION'
            f-ClfCli2-cm = 'SIN CLASIFICACION'.
            FIND ClfClie WHERE ClfClie.Categoria = gn-clie.clfCli NO-LOCK NO-ERROR.
            IF AVAILABLE ClfClie THEN f-ClfCli-cm:SCREEN-VALUE = ClfClie.DesCat.
            FIND ClfClie WHERE ClfClie.Categoria = gn-clie.clfCli2 NO-LOCK NO-ERROR.
            IF AVAILABLE ClfClie THEN f-ClfCli2-cm:SCREEN-VALUE = ClfClie.DesCat.

        END.
    END.

    /* Accesos */
    /*RUN restricciones.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-edit-attribute-list V-table-Win 
PROCEDURE local-edit-attribute-list :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'edit-attribute-list':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      DISABLE gn-clie.Libre_F01.
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      CASE RETURN-VALUE:
          WHEN 'YES' THEN DO:
              /* Nuevo Registro */
              BUTTON-1:SENSITIVE = YES.
          END.
          WHEN 'NO' THEN DO:
              BUTTON-1:SENSITIVE = YES.
              /* Modificacion */
              gn-clie.CodCli:SENSITIVE = NO.
              /* control de acceso */
              /*
              gn-clie.CndVta:SENSITIVE = NO.
              gn-clie.NomCli:SENSITIVE = NO.
              gn-clie.LocCli:SENSITIVE = NO.
              */
              /*
              IF gn-clie.Libre_C01 <> "N" THEN DO:
                  ASSIGN    gn-clie.ApeMat:SENSITIVE = NO
                        gn-clie.ApePat:SENSITIVE = NO
                        gn-clie.nombre:SENSITIVE = NO
                        gn-clie.nomcli:SENSITIVE = YES.
              END.
              ELSE DO:
                  ASSIGN 
                    gn-clie.ApeMat:SENSITIVE = YES
                    gn-clie.ApePat:SENSITIVE = YES
                    gn-clie.nombre:SENSITIVE = YES.
              END.
              */
                /*
              MESSAGE gn-clie.Libre_C01:SCREEN-VALUE SKIP
                    "SSS".

              IF gn-clie.Libre_C01:SCREEN-VALUE <> "N" THEN DO:
                  ASSIGN
                  gn-clie.ApeMat:SENSITIVE = NO
                  gn-clie.ApePat:SENSITIVE = NO
                  gn-clie.Nombre:SENSITIVE = NO
                  gn-clie.dni:SENSITIVE = NO
                  gn-clie.Nomcli:SENSITIVE = YES
                  gn-clie.ruc:SENSITIVE = YES
                  gn-clie.ApeMat:SCREEN-VALUE = ''
                  gn-clie.ApePat:SCREEN-VALUE = ''
                  gn-clie.nombre:SCREEN-VALUE = ''.
              END.
              ELSE DO:
                  ASSIGN gn-clie.ApeMat:SENSITIVE = YES
                  gn-clie.ApePat:SENSITIVE = YES
                  gn-clie.Nombre:SENSITIVE = YES
                  gn-clie.dni:SENSITIVE = YES
                  gn-clie.nomcli:SENSITIVE = NO
                  gn-clie.ruc:SENSITIVE = NO.

                  APPLY 'LEAVE':U TO gn-clie.ApePat.
              END.
              */
          END.

      END.
  END.

  /* Restriciones */
  RUN restricciones(INPUT NO).

  IF gn-clie.Libre_C01:SCREEN-VALUE <> "N" THEN DO:
      ASSIGN
      gn-clie.ApeMat:SENSITIVE = NO
      gn-clie.ApePat:SENSITIVE = NO
      gn-clie.Nombre:SENSITIVE = NO
      gn-clie.dni:SENSITIVE = NO
      gn-clie.Nomcli:SENSITIVE = YES
      gn-clie.ruc:SENSITIVE = YES
      gn-clie.ApeMat:SCREEN-VALUE = ''
      gn-clie.ApePat:SCREEN-VALUE = ''
      gn-clie.nombre:SCREEN-VALUE = ''.
  END.
  ELSE DO:
      ASSIGN gn-clie.ApeMat:SENSITIVE = YES
      gn-clie.ApePat:SENSITIVE = YES
      gn-clie.Nombre:SENSITIVE = YES
      gn-clie.dni:SENSITIVE = YES
      gn-clie.nomcli:SENSITIVE = NO
      gn-clie.ruc:SENSITIVE = NO.

      APPLY 'LEAVE':U TO gn-clie.ApePat.
  END.

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

  DEFINE VAR x-lista AS CHAR.

  /*
  DYNAMIC-FUNCTION('fEnviar-Documento':U IN hProc, INPUT "BOL", INPUT "760000340", INPUT "00067") . 
  function getWidget returns widget private ( pwhContainer as widget, pcType as char, pcName as char, pcLabel as char ):
  */

  IF S-USER-ID = 'ADMIN' THEN DO:
      EMPTY TEMP-TABLE ttObjetos.
      /*
      x-lista = getWidgetList(FRAME F-Main2:HANDLE,"","","").

      DEFINE VAR hProc AS HANDLE NO-UNDO.

      RUN lib\Tools-to-excel PERSISTENT SET hProc.

      def var c-csv-file as char no-undo.
      def var c-xls-file as char no-undo. /* will contain the XLS file path created */

      c-xls-file = 'd:\objetos-progress.xlsx'.

      run pi-crea-archivo-csv IN hProc (input  buffer ttObjetos:handle,
                              /*input  session:temp-directory + "file"*/ c-xls-file,
                              output c-csv-file) .

      run pi-crea-archivo-xls  IN hProc (input  buffer ttObjetos:handle,
                              input  c-csv-file,
                              output c-xls-file) .

      DELETE PROCEDURE hProc.    
      */
  END.

/* Code placed here will execute AFTER standard behavior.    */
  RUN restricciones(INPUT YES).
  
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
        /*WHEN "CodPos" THEN ASSIGN input-var-1 = "CP".*/
        /*WHEN "CodProv" THEN ASSIGN input-var-1 = gn-clie.CodDept:screen-value.*/
        WHEN "TpoCli" THEN ASSIGN input-var-1 = "TC".
        WHEN "Canal" THEN ASSIGN input-var-1 = "CN".
        WHEN "Clfcom" THEN ASSIGN input-var-1 = "CM".
        WHEN "CndVta" THEN ASSIGN input-var-1 = "".
        /*
        WHEN "CodDist" THEN DO:
               input-var-1 = gn-clie.CodDept:screen-value.
               input-var-2 = GN-clie.CodProv:screen-value.
          END.
        */
     END CASE.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE requiere-validar-con-sunat V-table-Win 
PROCEDURE requiere-validar-con-sunat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCampo AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pRetVal AS LOG NO-UNDO.

pRetVal = YES.

FIND FIRST factabla WHERE factabla.codcia = s-codcia AND
                            factabla.tabla = 'VALIDAR_SUNAT' AND
                            factabla.codigo = pCampo NO-LOCK NO-ERROR.
IF AVAILABLE factabla THEN pRetVal = factabla.campo-l[1].


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE restricciones V-table-Win 
PROCEDURE restricciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pInitialize AS LOG NO-UNDO.

    DO WITH FRAME {&FRAME-NAME} :

        IF pInitialize = NO AND s-nivel-acceso <> 0 THEN DO:
            RUN restricciones_objeto(INPUT gn-clie.libre_c01:HANDLE, INPUT "gn-clie.libre_c01").
            RUN restricciones_objeto(INPUT gn-clie.flgsit:HANDLE, INPUT "gn-clie.flgsit").
            RUN restricciones_objeto(INPUT gn-clie.rucold:HANDLE, INPUT "gn-clie.rucold").
            RUN restricciones_objeto(INPUT gn-clie.libre_l01:HANDLE, INPUT "gn-clie.libre_l01").
            RUN restricciones_objeto(INPUT gn-clie.ruc:HANDLE, INPUT "gn-clie.ruc").
            RUN restricciones_objeto(INPUT gn-clie.nomcli:HANDLE, INPUT "gn-clie.nomcli").
            RUN restricciones_objeto(INPUT gn-clie.dni:HANDLE, INPUT "gn-clie.dni").
            RUN restricciones_objeto(INPUT gn-clie.codunico:HANDLE, INPUT "gn-clie.codunico").
            RUN restricciones_objeto(INPUT gn-clie.fchces:HANDLE, INPUT "gn-clie.fchces").
            RUN restricciones_objeto(INPUT gn-clie.apepat:HANDLE, INPUT "gn-clie.apepat").
            RUN restricciones_objeto(INPUT gn-clie.apemat:HANDLE, INPUT "gn-clie.apemat").
            RUN restricciones_objeto(INPUT gn-clie.fching:HANDLE, INPUT "gn-clie.fching").
            RUN restricciones_objeto(INPUT gn-clie.nombre:HANDLE, INPUT "gn-clie.nombre").
            RUN restricciones_objeto(INPUT gn-clie.usuario:HANDLE, INPUT "gn-clie.usuario").         
            /*RUN restricciones_objeto(INPUT gn-clie.dircli:HANDLE, INPUT "gn-clie.dircli").*/
            RUN restricciones_objeto(INPUT gn-clie.fchact:HANDLE, INPUT "gn-clie.fchact").
            /*RUN restricciones_objeto(INPUT gn-clie.dirref:HANDLE, INPUT "gn-clie.dirref").*/
            /*RUN restricciones_objeto(INPUT gn-clie.coddept:HANDLE, INPUT "gn-clie.coddept").*/
            /*RUN restricciones_objeto(INPUT gn-clie.codpos:HANDLE, INPUT "gn-clie.codpos").*/
            RUN restricciones_objeto(INPUT gn-clie.telfnos[1]:HANDLE, INPUT "gn-clie.telfnos[1]").
            RUN restricciones_objeto(INPUT gn-clie.telfnos[2]:HANDLE, INPUT "gn-clie.telfnos[2]").
            /*RUN restricciones_objeto(INPUT gn-clie.codprov:HANDLE, INPUT "gn-clie.codprov").*/
            RUN restricciones_objeto(INPUT gn-clie.e-mail:HANDLE, INPUT "gn-clie.e-mail").
            /*RUN restricciones_objeto(INPUT gn-clie.coddist:HANDLE, INPUT "gn-clie.coddist").*/
            RUN restricciones_objeto(INPUT gn-clie.transporte[4]:HANDLE, INPUT "gn-clie.transporte[4]").
            RUN restricciones_objeto(INPUT gn-clie.nrocard:HANDLE, INPUT "gn-clie.nrocard").
            RUN restricciones_objeto(INPUT gn-clie.canal:HANDLE, INPUT "gn-clie.canal").
            RUN restricciones_objeto(INPUT gn-clie.codven:HANDLE, INPUT "gn-clie.codven").
            RUN restricciones_objeto(INPUT gn-clie.gircli:HANDLE, INPUT "gn-clie.gircli").
            RUN restricciones_objeto(INPUT gn-clie.cndvta:HANDLE, INPUT "gn-clie.cndvta").
            RUN restricciones_objeto(INPUT BUTTON-1:HANDLE, INPUT "BUTTON-1").
            RUN restricciones_objeto(INPUT f-convta:HANDLE, INPUT "f-convta").
            RUN restricciones_objeto(INPUT gn-clie.coddiv:HANDLE, INPUT "gn-clie.coddiv").
            RUN restricciones_objeto(INPUT gn-clie.loccli:HANDLE, INPUT "gn-clie.loccli").
            RUN restricciones_objeto(INPUT gn-clie.clfcli:HANDLE, INPUT "gn-clie.clfcli").
            RUN restricciones_objeto(INPUT gn-clie.cm_clfcli_p:HANDLE, INPUT "gn-clie.cm_clfcli_p").
            RUN restricciones_objeto(INPUT gn-clie.clfcli2:HANDLE, INPUT "gn-clie.clfcli2").
            RUN restricciones_objeto(INPUT gn-clie.cm_clfcli_t:HANDLE, INPUT "gn-clie.cm_clfcli_t").
            RUN restricciones_objeto(INPUT gn-clie.repleg[1]:HANDLE, INPUT "gn-clie.repleg[1]").
            RUN restricciones_objeto(INPUT gn-clie.repleg[2]:HANDLE, INPUT "gn-clie.repleg[2]").
            RUN restricciones_objeto(INPUT gn-clie.repleg[5]:HANDLE, INPUT "gn-clie.repleg[5]").
            RUN restricciones_objeto(INPUT gn-clie.repleg[4]:HANDLE, INPUT "gn-clie.repleg[4]").
            RUN restricciones_objeto(INPUT gn-clie.fnrepr:HANDLE, INPUT "gn-clie.fnrepr").

        END.
        
        /*
        RUN restricciones_objeto(INPUT gn-clie.ruc:HANDLE, INPUT "gn-clie.ruc").
        RUN restricciones_objeto(INPUT gn-clie.nomcli:HANDLE, INPUT "gn-clie.nomcli").
        */
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE restricciones_objeto V-table-Win 
PROCEDURE restricciones_objeto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER hwObjeto AS handle NO-UNDO.
DEFINE INPUT PARAMETER sFieldName AS CHAR NO-UNDO.

DEFINE VAR x-pos AS INT.

FIND FIRST x-factabla WHERE x-factabla.codcia = s-codcia AND
                            x-factabla.tabla = 'MANTENIMIENTO-CLIENTE' AND
                            x-factabla.codigo = sFieldName NO-LOCK NO-ERROR.

IF AVAILABLE x-factabla THEN DO:
    IF s-nivel-acceso <> 0 THEN DO:

        x-pos = (s-nivel-acceso * 2) - 1.

        IF x-factabla.campo-l[x-pos] = NO THEN DO:
            /* NO VISIBLE */
            hwObjeto:VISIBLE = NO NO-ERROR.
        END.
        ELSE DO:
            IF x-factabla.campo-l[x-pos + 1] = YES THEN DO:
                /* EDITABLE */
                hwObjeto:SENSITIVE = YES NO-ERROR.
            END.
            ELSE hwObjeto:SENSITIVE = NO NO-ERROR. 
        END.
        
    END.
    
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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* 15/05/2023 Campos que no pueden estar en blanco */
DO WITH FRAME {&FRAME-NAME}:
    IF TRUE <> (gn-clie.E-Mail:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'NO puede dejar el e-mail del contacto en blanco' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO gn-clie.E-Mail.
        RETURN 'ADM-ERROR'.
    END.
    IF TRUE <> (gn-clie.Transporte[4]:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'NO puede dejar el e-mail fac. Electr. en blanco' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO gn-clie.Transporte[4].
        RETURN 'ADM-ERROR'.
    END.
    IF TRUE <> (gn-clie.Telfnos[1]:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'NO puede dejar el Teléfono #1 en blanco' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO gn-clie.Telfnos[1].
        RETURN 'ADM-ERROR'.
    END.
    IF TRUE <> (gn-clie.Canal:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'NO puede dejar el Grupo de cliente (Canal) en blanco' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO gn-clie.Canal.
        RETURN 'ADM-ERROR'.
    END.
    IF TRUE <> (gn-clie.GirCli:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'NO puede dejar el Giro en blanco' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO gn-clie.GirCli.
        RETURN 'ADM-ERROR'.
    END.
    IF TRUE <> (gn-clie.ClfCom:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'NO puede dejar el Sector Económico en blanco' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO gn-clie.ClfCom.
        RETURN 'ADM-ERROR'.
    END.
END.

  DO WITH FRAME {&FRAME-NAME} :
    IF gn-clie.CodCli:SCREEN-VALUE = "" THEN DO:
       MESSAGE "Codigo no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO gn-clie.CodCli.
       RETURN "ADM-ERROR".   
    END.

    IF gn-clie.codcli:SCREEN-VALUE > '' THEN DO:
        IF LENGTH(gn-clie.codcli:SCREEN-VALUE) < 11  THEN DO:
            MESSAGE 'El codigo de cliente debe tener 11 dígitos' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-clie.Ruc.
            RETURN 'ADM-ERROR'.
        END.
    END.

    FIND FIRST GN-DIVI WHERE GN-DIVI.codcia = s-codcia
        AND GN-DIVI.coddiv = gn-clie.CodDiv:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE GN-DIVI
    THEN DO:
        MESSAGE 'Division no registrada' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO gn-clie.coddiv.
        RETURN 'ADM-ERROR'.
    END.        
    /*
    IF gn-clie.CodDept:SCREEN-VALUE <> "" THEN DO:
        FIND  TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF NOT AVAILABLE TabDepto 
        THEN DO:
            MESSAGE 'Departamento no registrado' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-clie.CodDept.
            RETURN 'ADM-ERROR'.
        END.
    END.
    IF gn-clie.CodProv:SCREEN-VALUE <> "" THEN DO:
        FIND  Tabprovi WHERE Tabprovi.CodDepto = gn-clie.CodDept:screen-value 
            AND Tabprovi.Codprovi = gn-clie.CodProv:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Tabprovi 
        THEN DO:
            MESSAGE 'Provincia no registrada' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-clie.CodProv.
            RETURN 'ADM-ERROR'.
        END.
    END.
    IF gn-clie.CodDist:SCREEN-VALUE <> "" THEN DO:
        FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept:screen-value 
            AND Tabdistr.Codprovi = gn-clie.codprov:screen-value 
            AND Tabdistr.Coddistr = gn-clie.CodDist:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Tabdistr 
        THEN DO:
            MESSAGE 'Distrito no registrado' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-clie.CodDist.
            RETURN 'ADM-ERROR'.
        END.
    END.  
    */

    /* PARCHE TEMPORAL 07/06/2014 */
    /*IF s-nivel-acceso = 3 THEN RETURN 'OK'.*/

    IF gn-clie.Canal:SCREEN-VALUE = '' THEN DO:
         MESSAGE 'Ingrese el grupo de cliente[Canal]' VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY":U TO gn-clie.canal.
         RETURN "ADM-ERROR".
    END.

    FIND FIRST almtabla WHERE almtabla.Tabla = 'CN' 
        AND almtabla.Codigo = gn-clie.canal:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almtabla
    THEN DO:
        MESSAGE 'Grupo de cliente[canal] no existe' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO gn-clie.Canal.
        RETURN 'ADM-ERROR'.
    END.

    IF gn-clie.NroCard:SCREEN-VALUE <> ''
    THEN DO:
        FIND FIRST GN-CARD WHERE gn-card.nrocard = gn-clie.NroCard:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-card THEN DO:
            MESSAGE 'Numero de Tarjeta no registrado'
                VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-clie.nrocard.
            RETURN 'ADM-ERROR'.
        END.
    END.
    IF gn-clie.CodVen:SCREEN-VALUE <> "" THEN DO:
        FIND FIRST gn-ven WHERE gn-ven.codcia = s-codcia
            AND gn-ven.CodVen = gn-clie.CodVen:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-ven 
        THEN DO:
            MESSAGE 'Vendedor no registrado' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-clie.CodVen.
            RETURN 'ADM-ERROR'.
        END.
    END.
    IF gn-clie.clfCli:SCREEN-VALUE <> ''
    THEN DO:
        FIND FIRST ClfClie WHERE ClfClie.Categoria = gn-clie.clfCli:SCREEN-VALUE 
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ClfClie
        THEN DO:
            MESSAGE 'La clasificacion del cliente esta errada'
                VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-clie.ClfCli.
            RETURN 'ADM-ERROR'.
        END.
    END.
    IF gn-clie.GirCli:SCREEN-VALUE = '' THEN DO:
        MESSAGE 'Ingrese el giro del cliente' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO gn-clie.GirCli.
        RETURN 'ADM-ERROR'.
    END.
    FIND FIRST almtabla WHERE almtabla.Tabla = 'GN' 
        AND almtabla.Codigo = gn-clie.GirCli:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almtabla
    THEN DO:
        MESSAGE 'El giro del cliente no registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO gn-clie.GirCli.
        RETURN 'ADM-ERROR'.
    END.
    FIND VtaTabla WHERE VtaTabla.codcia = s-codcia
        AND VtaTabla.tabla = 'CN-GN'
        AND VtaTabla.llave_c1 = gn-clie.Canal:SCREEN-VALUE
        AND VtaTabla.llave_c2 = gn-clie.GirCli:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE VtaTabla THEN DO:
        MESSAGE 'El Giro NO relacionado con el Grupo del Cliente' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO gn-clie.GirCli.
        RETURN 'ADM-ERROR'.
    END.
    FIND FIRST almtabla WHERE almtabla.Tabla = 'SE' 
        AND almtabla.Codigo = gn-clie.ClfCom:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almtabla THEN DO:
        MESSAGE 'El sector económico no está registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO gn-clie.ClfCom.
        RETURN 'ADM-ERROR'.
    END.

    IF gn-clie.codunico:SCREEN-VALUE <> '' 
            AND gn-clie.codunico:SCREEN-VALUE <> gn-clie.codcli:SCREEN-VALUE  THEN DO:
        IF NOT CAN-FIND(FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
                        AND gn-clie.codunico = gn-clie.codunico:SCREEN-VALUE NO-LOCK)
        THEN DO:
            MESSAGE 'Error en el código agrupador' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-clie.CodUnico.
            RETURN 'ADM-ERROR'.
        END.
    END.
    
    DEF VAR pResultado AS CHAR.
    CASE TRUE:
        WHEN gn-clie.Libre_C01:SCREEN-VALUE = "J" THEN DO:
            IF LENGTH(gn-clie.Ruc:SCREEN-VALUE) < 11 
                OR LOOKUP(SUBSTRING(gn-clie.Ruc:SCREEN-VALUE,1,2), '20') = 0 THEN DO:
                MESSAGE 'Debe tener 11 dígitos y comenzar con 20' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO gn-clie.Ruc.
                RETURN 'ADM-ERROR'.
            END.
            /* dígito verificador */
            RUN lib/_ValRuc (gn-clie.Ruc:SCREEN-VALUE, OUTPUT pResultado).
            IF pResultado = 'ERROR' THEN DO:
                MESSAGE 'Código MAL registrado' VIEW-AS ALERT-BOX WARNING.
                APPLY 'ENTRY':U TO gn-clie.Ruc.
                RETURN 'ADM-ERROR'.
            END.
            /* el e-mail es obligatorio */
            IF TRUE <> (gn-clie.Transporte[4]:SCREEN-VALUE > '') THEN DO:
                MESSAGE 'El e-mail para la facturación electrónica es obligatorio'
                    VIEW-AS ALERT-BOX WARNING.
                APPLY 'ENTRY':U TO gn-clie.Transporte[4].
                RETURN 'ADM-ERROR'.
            END.
        END.
        WHEN gn-clie.Libre_C01:SCREEN-VALUE = "E" THEN DO:
            IF LENGTH(gn-clie.Ruc:SCREEN-VALUE) < 11 THEN DO:
                MESSAGE 'Debe tener 11 dígitos' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO gn-clie.Ruc.
                RETURN 'ADM-ERROR'.
            END.
            /*
                04Dic2019, a pedido de Mayra Padilla y con autorizacion de
                           Daniel Llican
                        
            IF LENGTH(gn-clie.Ruc:SCREEN-VALUE) < 11 
                OR LOOKUP(SUBSTRING(gn-clie.Ruc:SCREEN-VALUE,1,2), '15,17') = 0 THEN DO:
                MESSAGE 'Debe tener 11 dígitos y comenzar con 15 ó 17' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO gn-clie.Ruc.
                RETURN 'ADM-ERROR'.
            END.
            /* dígito verificador */
            RUN lib/_ValRuc (gn-clie.Ruc:SCREEN-VALUE, OUTPUT pResultado).
            IF pResultado = 'ERROR' THEN DO:
                MESSAGE 'Código MAL registrado' VIEW-AS ALERT-BOX WARNING.
                APPLY 'ENTRY':U TO gn-clie.Ruc.
                RETURN 'ADM-ERROR'.
            END.
            */
        END.
        WHEN gn-clie.Libre_C01:SCREEN-VALUE = "N" THEN DO:
            IF gn-clie.Ruc:SCREEN-VALUE > '' THEN DO:
                IF LENGTH(gn-clie.Ruc:SCREEN-VALUE) < 11 OR LOOKUP(SUBSTRING(gn-clie.Ruc:SCREEN-VALUE,1,2), '10') = 0 THEN DO:
                    MESSAGE 'Debe tener 11 dígitos y comenzar con 10' VIEW-AS ALERT-BOX ERROR.
                    APPLY 'ENTRY':U TO gn-clie.Ruc.
                    RETURN 'ADM-ERROR'.
                END.
                /* dígito verificador */
                RUN lib/_ValRuc (gn-clie.Ruc:SCREEN-VALUE, OUTPUT pResultado).
                IF pResultado = 'ERROR' THEN DO:
                    MESSAGE 'Código MAL registrado' VIEW-AS ALERT-BOX WARNING.
                    APPLY 'ENTRY':U TO gn-clie.Ruc.
                    RETURN 'ADM-ERROR'.
                END.
            END.
            IF TRUE <> (gn-clie.Dni:SCREEN-VALUE > '') OR LENGTH(gn-clie.Dni:SCREEN-VALUE) <> 8
                THEN DO:
                MESSAGE 'Ingrese un DNI válido de 8 caracteres' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO gn-clie.Dni.
                RETURN 'ADM-ERROR'.
            END.
        END.
    END CASE.
    IF gn-clie.Libre_C01:SCREEN-VALUE = "N" THEN DO:
        IF (gn-clie.ApeMat:SCREEN-VALUE = ''
            OR gn-clie.ApePat:SCREEN-VALUE = ''
            OR gn-clie.Nombre:SCREEN-VALUE = '')
            THEN DO:
            MESSAGE 'Ingrese Apellidos y Nombres completos' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-clie.ApePat.
            RETURN 'ADM-ERROR'.
        END.
    END.
    ELSE DO:
        IF gn-clie.Nomcli:SCREEN-VALUE = '' THEN DO:
            MESSAGE 'Ingrese la Razón Social' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-clie.Nombre.
            RETURN 'ADM-ERROR'.
        END.
    END.
    /* E-MAIL Fact Elect */
    DEF VAR x-Nro-EMails AS INT NO-UNDO.
    DEF VAR x-Item AS INT NO-UNDO.
    IF gn-clie.e-mail:SCREEN-VALUE > '' THEN DO:
        x-Nro-EMails = NUM-ENTRIES(gn-clie.e-mail:SCREEN-VALUE,';').
        DO x-Item = 1 TO x-Nro-EMails:
            RUN gn/valida-email (ENTRY(x-Item,gn-clie.e-mail:SCREEN-VALUE,';'), 
                                 OUTPUT pError).
            IF pError > '' THEN DO:
                MESSAGE 'e-mail del contacto mal registrado' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO gn-clie.e-mail.
                RETURN 'ADM-ERROR'.
            END.
        END.
    END.
    IF gn-clie.Transporte[4]:SCREEN-VALUE > '' THEN DO:
        x-Nro-EMails = NUM-ENTRIES(gn-clie.Transporte[4]:SCREEN-VALUE,';').
        DO x-Item = 1 TO x-Nro-EMails:
            RUN gn/valida-email (ENTRY(x-Item,gn-clie.Transporte[4]:SCREEN-VALUE,';'), 
                                 OUTPUT pError).
            IF pError > '' THEN DO:
                MESSAGE 'e-mail facturacion electronica mal registrado' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO gn-clie.Transporte[4].
                RETURN 'ADM-ERROR'.
            END.
        END.
    END.
  END.

  /* Ic - 18Ago2020 - Verificacion adicionales */
  DEFINE VAR x-codigo1 AS CHAR.
  DEF VAR x-codigo AS INT64 NO-UNDO.

  x-codigo1 = gn-clie.codcli:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

  ASSIGN x-codigo = INT64(x-codigo1) NO-ERROR.

  IF ERROR-STATUS:ERROR THEN DO:
      MESSAGE 'Debe ingresar solo NUMEROS' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.

  /**/
  DEFINE VAR hProc AS HANDLE NO-UNDO.           /* Handle Libreria */
  DEFINE VAR x-retval AS CHAR.

  RUN gn\master-library.r PERSISTENT SET hProc.

  IF gn-clie.Libre_C01:SCREEN-VALUE = "N"  /*x-codigo <= 99999999*/ THEN DO:
      /* DNI */
      IF TRUE <> (gn-clie.ApePat:SCREEN-VALUE IN FRAME {&FRAME-NAME} > "") THEN DO:
          MESSAGE 'Ingrese Apellido Paterno' VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
      IF TRUE <> (gn-clie.Nombre:SCREEN-VALUE IN FRAME {&FRAME-NAME} > "") THEN DO:
          MESSAGE 'Ingrese nombre del cliente' VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
      IF LENGTH(TRIM(gn-clie.ApePat:SCREEN-VALUE IN FRAME {&FRAME-NAME})) < 2 THEN DO:
          MESSAGE 'Apellido Paterno Invalido' VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
      IF LENGTH(TRIM(gn-clie.nombre:SCREEN-VALUE IN FRAME {&FRAME-NAME})) < 3 THEN DO:
          MESSAGE 'Nombre es Invalido' VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.

      x-retval = "".
      RUN VALIDA_AP_PATERNO IN hProc (INPUT gn-clie.apepat:SCREEN-VALUE, OUTPUT x-RetVal).
      IF x-RetVal <> "OK" THEN DO:

          DELETE PROCEDURE hProc.

          MESSAGE x-retval VIEW-AS ALERT-BOX ERROR.
              APPLY 'ENTRY':U TO gn-clie.apepat.
              RETURN "ADM-ERROR".
      END.

      x-retval = "".
      RUN VALIDA_NOMBRE IN hProc (INPUT gn-clie.nombre:SCREEN-VALUE, OUTPUT x-RetVal).
      IF x-RetVal <> "OK" THEN DO:

          DELETE PROCEDURE hProc.

          MESSAGE x-retval VIEW-AS ALERT-BOX ERROR.
              APPLY 'ENTRY':U TO gn-clie.nombre.
              RETURN "ADM-ERROR".
      END.

  END.
  ELSE DO:
      /* Razon social */

      x-retval = "".
      RUN VALIDA_RAZON_SOCIAL IN hProc (INPUT gn-clie.nomcli:SCREEN-VALUE, OUTPUT x-RetVal).
      IF x-RetVal <> "OK" THEN DO:

          DELETE PROCEDURE hProc.

          MESSAGE x-retval VIEW-AS ALERT-BOX ERROR.
              APPLY 'ENTRY':U TO gn-clie.nombre.
              RETURN "ADM-ERROR".
      END.

  END.

  DELETE PROCEDURE hProc.

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
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEsAlfabetico V-table-Win 
FUNCTION getEsAlfabetico RETURNS LOGICAL
  ( INPUT pCaracter AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR x-alfabetico AS CHAR.
    DEFINE VAR x-retval AS LOG INIT NO.

    x-alfabetico = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZabcdefghijklmnñopqrstuvwxyz ".
    IF INDEX(x-alfabetico,pCaracter) > 0 THEN x-retval = YES.

  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetSoloLetras V-table-Win 
FUNCTION GetSoloLetras RETURNS LOGICAL
  ( INPUT pTexto AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR x-caracter AS CHAR.
    DEFINE VAR x-retval AS LOG INIT YES.
    DEFINE VAR x-sec AS INT.

    VALIDACION:
    REPEAT x-sec = 1 TO LENGTH(pTexto):
        x-caracter = SUBSTRING(pTexto,x-sec,1).
        x-retval = getEsAlfabetico(x-caracter).
        IF x-retval = NO THEN DO:
            LEAVE VALIDACION.
        END.
    END.

  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWidgetByName V-table-Win 
FUNCTION getWidgetByName returns widget-handle
    ( INPUT phParent as widget-handle, INPUT pcWidgetName as character ) :

define variable lhScanWidget as widget-handle no-undo.
define variable lhTmpWidget as widget-handle no-undo.
define variable llFound as logical no-undo init no.

if valid-handle(phParent) then assign
    lhScanWidget = phParent:first-child.

do while valid-handle(lhScanWidget) and (not llFound):

    IF lhScanWidget:TYPE <> "ZZZLITERAL" THEN DO:
        CREATE ttObjetos.
        ASSIGN tname = lhScanWidget:name
                ttipo = lhScanWidget:type
                tlabel = lhScanWidget:label
                ttabla = lhScanWidget:TABLE
                tindex = lhScanWidget:INDEX
                ttooltip = lhScanWidget:TOOLTIP
                tfiler = string( lhScanWidget )
                tobjetos = lhScanWidget:TAB-POSITION 
                NO-ERROR.        
    END.

    if lhScanWidget:type = "FIELD-GROUP" then do:
        /* Scan children */
        lhTmpWidget = getWidgetByName(lhScanWidget,pcWidgetName).

    if valid-handle(lhTmpWidget) then assign
            llFound = NO /*yes*/
            lhScanWidget = lhTmpWidget.
    end. 
    else do:
        /* Check item */
        llFound = (lhScanWidget:name = pcWidgetName).
    end.
    if not llFound then lhScanWidget = lhScanWidget:next-sibling.
end.

return (lhScanWidget).

end function.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWidgetList V-table-Win 
FUNCTION getWidgetList RETURNS CHARACTER
  ( pwhContainer as widget, pcType as char, pcName as char, pcLabel as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    if pwhContainer = ? then
       pwhContainer = current-window.

    if pcType = "" then
       pcType = ?.

    if pcName = "" then
       pcName = ?.

    if pcLabel = "" then
       pcLabel = ?.

    /*
    return getWidgetListRecurr(
        input pwhContainer,
        input pcType,
        input pcName,
        input pcLabel ).

   */
    DEFINE VAR xxxx AS HANDLE.
    xxxx = getWidgetByName(pwhContainer, "").

END FUNCTION.


/*
DEFINE VARIABLE myControl AS WIDGET-HANDLE.

FOR EACH ...
myControl = getWidgetByName(frame :handle, controlName).
myControl:SCREEN-VALUE = controlValue.
END.

...

FUNCTION getWidgetByName returns widget-handle
( phParent as widget-handle,
pcWidgetName as character ) :

define variable lhScanWidget as widget-handle no-undo.
define variable lhTmpWidget as widget-handle no-undo.
define variable llFound as logical no-undo init no.

if valid-handle(phParent) then assign
lhScanWidget = phParent:first-child.

do while valid-handle(lhScanWidget) and (not llFound):
if lhScanWidget:type = "FIELD-GROUP" then do:
/* Scan children */
lhTmpWidget = getWidgetByName(lhScanWidget,pcWidgetName).
if valid-handle(lhTmpWidget) then assign
llFound = yes
lhScanWidget = lhTmpWidget.
end. else do:
/* Check item */
llFound = (lhScanWidget:name = pcWidgetName).
end.
if not llFound then lhScanWidget = lhScanWidget:next-sibling.
end.

return (lhScanWidget).
end function.
*/
/*
The function above scans all widgets in the specified frame and returns one with the specified name (or ? - if the widget is not found).
This should work, however if you want to update many widgets and you have many widgets in your frame then it would be better (for performance reasons) to build list of all widgets in temp table or set of arrays and use them to speed up the function.

Regards,
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWidgetListRecurr V-table-Win 
FUNCTION getWidgetListRecurr RETURNS CHARACTER
  ( pwhContainer as widget, pcType as char, pcName as char, pcLabel as char  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
/*
hfg = hFrame:FIRST-CHILD. /* first field group */
hw  = hfg:FIRST-CHILD.
*/

    define var whChild  as widget no-undo.

    define var RetVal   as char no-undo.
    define var str      as char no-undo.

    RetVal = "".

    whChild = pwhContainer:first-child.

    repeat while valid-handle( whChild ):

        CREATE ttObjetos.
        ASSIGN tname = whChild:name
                ttipo = whChild:type
                tlabel = whChild:label
                tfiler = string( whChild )
                tobjetos = whChild:TAB-POSITION
                .

        if  ( pcType = ? or can-query( whChild, "type" ) and can-do( pcType, whChild:type ) ) 
                and ( pcName = ? or can-query( whChild, "name" ) and can-do( pcName, whChild:name ) )
                and ( pcLabel = ? or can-query( whChild, "label" ) and can-do( pcLabel, whChild:label ) ) then

            RetVal = RetVal
                + ( if RetVal <> "" then "," else "" )
                + string( whChild ).

        if whChild:type = "window" or whChild:type = "frame" or whChild:type = "field-group" then do:

            str = getWidgetListRecurr( whChild, pcType, pcName, pcLabel ).

            if str <> "" then

                RetVal = RetVal
                    + ( if RetVal <> "" then "," else "" )
                    + str.

        end. /* type = "window" */

        whChild = whChild:next-sibling.

    end. /* repeat */

    return RetVal.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

