&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CLIE FOR gn-clie.



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

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

/* DEF SHARED VAR s-nivel-acceso AS INT NO-UNDO. */

DEF VAR pBajaSunat AS LOG NO-UNDO.
DEF VAR pName AS CHAR NO-UNDO.
DEF VAR pAddress AS CHAR NO-UNDO.
DEF VAR pUbigeo AS CHAR NO-UNDO.
DEF VAR pResultado AS CHAR NO-UNDO.
DEF VAR pError AS CHAR NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES gn-clie
&Scoped-define FIRST-EXTERNAL-TABLE gn-clie


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR gn-clie.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS gn-clie.Libre_C01 gn-clie.Ruc gn-clie.DNI ~
gn-clie.ApePat gn-clie.ApeMat gn-clie.Nombre gn-clie.E-Mail ~
gn-clie.Transporte[4] gn-clie.CodVen gn-clie.CodDiv gn-clie.JfeLog[5] ~
gn-clie.RepLeg[1] gn-clie.RepLeg[4] gn-clie.CodCli gn-clie.CodUnico ~
gn-clie.Flgsit gn-clie.Canal gn-clie.GirCli gn-clie.CodIBC ~
gn-clie.RepLeg[2] gn-clie.RepLeg[5] gn-clie.Rucold gn-clie.Libre_L01 ~
gn-clie.Telfnos[1] gn-clie.Telfnos[2] gn-clie.Telfnos[3] gn-clie.FaxCli 
&Scoped-define ENABLED-TABLES gn-clie
&Scoped-define FIRST-ENABLED-TABLE gn-clie
&Scoped-Define ENABLED-OBJECTS RECT-32 RECT-33 
&Scoped-Define DISPLAYED-FIELDS gn-clie.Libre_C01 gn-clie.Ruc gn-clie.DNI ~
gn-clie.ApePat gn-clie.ApeMat gn-clie.Nombre gn-clie.NomCli gn-clie.E-Mail ~
gn-clie.Transporte[4] gn-clie.CodVen gn-clie.CodDiv gn-clie.JfeLog[5] ~
gn-clie.RepLeg[1] gn-clie.RepLeg[4] gn-clie.CodCli gn-clie.CodUnico ~
gn-clie.Flgsit gn-clie.Canal gn-clie.GirCli gn-clie.CodIBC ~
gn-clie.RepLeg[2] gn-clie.RepLeg[5] gn-clie.Rucold gn-clie.Libre_L01 ~
gn-clie.Telfnos[1] gn-clie.Telfnos[2] gn-clie.Telfnos[3] gn-clie.FaxCli ~
gn-clie.Libre_L02 gn-clie.SwBajaSunat 
&Scoped-define DISPLAYED-TABLES gn-clie
&Scoped-define FIRST-DISPLAYED-TABLE gn-clie
&Scoped-Define DISPLAYED-OBJECTS F-NomVen f-Canal f-Giro 

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
DEFINE VARIABLE f-Canal AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .81 NO-UNDO.

DEFINE VARIABLE f-Giro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .81 NO-UNDO.

DEFINE VARIABLE F-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 129 BY 7.

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 129 BY 2.96.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     gn-clie.Libre_C01 AT ROW 1.27 COL 19 NO-LABEL WIDGET-ID 38
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Jurídica", "J":U,
"Natural", "N":U,
"Extranjera", "E":U
          SIZE 27 BY .81
          BGCOLOR 14 FGCOLOR 0 
     gn-clie.Ruc AT ROW 2.08 COL 17 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     gn-clie.DNI AT ROW 2.08 COL 32 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     gn-clie.ApePat AT ROW 2.88 COL 17 COLON-ALIGNED WIDGET-ID 4
          LABEL "Ap. Paterno" FORMAT "X(100)"
          VIEW-AS FILL-IN 
          SIZE 35 BY .81
     gn-clie.ApeMat AT ROW 2.88 COL 62 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 35 BY .81
     gn-clie.Nombre AT ROW 3.69 COL 17 COLON-ALIGNED WIDGET-ID 26
          LABEL "Nombre/Razón Social" FORMAT "X(100)"
          VIEW-AS FILL-IN 
          SIZE 80 BY .81
     gn-clie.NomCli AT ROW 4.5 COL 12.86 WIDGET-ID 28
          LABEL "Nombre" FORMAT "x(250)"
          VIEW-AS FILL-IN 
          SIZE 80 BY .81
          BGCOLOR 14 FGCOLOR 0 
     gn-clie.E-Mail AT ROW 5.31 COL 17 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 22 BY .81
     gn-clie.Transporte[4] AT ROW 5.31 COL 62 COLON-ALIGNED WIDGET-ID 60
          LABEL "eMail Facturacion Electronica" FORMAT "X(150)"
          VIEW-AS FILL-IN 
          SIZE 35 BY .81
     gn-clie.CodVen AT ROW 6.12 COL 17 COLON-ALIGNED WIDGET-ID 80
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     gn-clie.CodDiv AT ROW 6.92 COL 17 COLON-ALIGNED WIDGET-ID 116
          LABEL "Division" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     gn-clie.JfeLog[5] AT ROW 8.27 COL 17 COLON-ALIGNED WIDGET-ID 96
          LABEL "Cliente-Accionista" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
          BGCOLOR 13 FGCOLOR 15 
     gn-clie.RepLeg[1] AT ROW 9.08 COL 17 COLON-ALIGNED WIDGET-ID 100
          LABEL "Nombre y Apellido" FORMAT "X(256)"
          VIEW-AS FILL-IN 
          SIZE 54 BY .81
     gn-clie.RepLeg[4] AT ROW 9.88 COL 17 COLON-ALIGNED WIDGET-ID 104
          LABEL "Direccion Domicilio" FORMAT "X(256)"
          VIEW-AS FILL-IN 
          SIZE 54 BY .81
     F-NomVen AT ROW 6.12 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 82
     gn-clie.CodCli AT ROW 1.27 COL 57 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 14 FGCOLOR 0 
     gn-clie.CodUnico AT ROW 2.08 COL 57 COLON-ALIGNED WIDGET-ID 118
          LABEL "Cod. Agrupador" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     gn-clie.Flgsit AT ROW 1.27 COL 73 NO-LABEL WIDGET-ID 120
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Activo", "A":U,
"Cesado", "C":U
          SIZE 17 BY .77
     gn-clie.Canal AT ROW 6.12 COL 73 COLON-ALIGNED WIDGET-ID 72
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     gn-clie.GirCli AT ROW 6.92 COL 73 COLON-ALIGNED WIDGET-ID 78
          LABEL "Giro" FORMAT "X(4)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     gn-clie.CodIBC AT ROW 2.08 COL 79 COLON-ALIGNED WIDGET-ID 62
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     f-Canal AT ROW 6.12 COL 81 COLON-ALIGNED NO-LABEL WIDGET-ID 74
     f-Giro AT ROW 6.92 COL 81 COLON-ALIGNED NO-LABEL WIDGET-ID 76
     gn-clie.RepLeg[2] AT ROW 9.08 COL 81 COLON-ALIGNED WIDGET-ID 102
          LABEL "DNI" FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .81
     gn-clie.RepLeg[5] AT ROW 9.88 COL 81 COLON-ALIGNED WIDGET-ID 106
          LABEL "Telefono"
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .81
     gn-clie.Rucold AT ROW 1.27 COL 111 NO-LABEL WIDGET-ID 88
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Si", "Si":U,
"No", "No":U
          SIZE 10 BY .77
     gn-clie.Libre_L01 AT ROW 2.08 COL 111 NO-LABEL WIDGET-ID 84
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Si", yes,
"No", no
          SIZE 10 BY .77
     gn-clie.Telfnos[1] AT ROW 2.88 COL 109 COLON-ALIGNED WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 16 BY .81
     gn-clie.Telfnos[2] AT ROW 3.69 COL 109 COLON-ALIGNED WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 16 BY .81
     gn-clie.Telfnos[3] AT ROW 4.5 COL 109 COLON-ALIGNED WIDGET-ID 36
          VIEW-AS FILL-IN 
          SIZE 16 BY .81
     gn-clie.FaxCli AT ROW 5.31 COL 109 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 16 BY .81
     gn-clie.Libre_L02 AT ROW 8.27 COL 111 WIDGET-ID 58
          LABEL "Solo OpenOrange"
          VIEW-AS TOGGLE-BOX
          SIZE 15 BY .77
     gn-clie.SwBajaSunat AT ROW 9.08 COL 111 NO-LABEL WIDGET-ID 124
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "De Baja en SUNAT", yes,
"Activo en SUNAT", no
          SIZE 17 BY 1.62
          BGCOLOR 14 FGCOLOR 0 
     "Agente de Percepción:" VIEW-AS TEXT
          SIZE 16 BY .5 AT ROW 2.04 COL 95 WIDGET-ID 94
     "Representante Legal" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 7.73 COL 3 WIDGET-ID 110
          BGCOLOR 9 FGCOLOR 15 
     "Agente Retenedor:" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 1.38 COL 97 WIDGET-ID 92
     "Datos Generales" VIEW-AS TEXT
          SIZE 12 BY .5 AT ROW 1 COL 3 WIDGET-ID 108
          BGCOLOR 9 FGCOLOR 15 
     RECT-32 AT ROW 1 COL 2 WIDGET-ID 112
     RECT-33 AT ROW 8 COL 2 WIDGET-ID 114
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
      TABLE: B-CLIE B "?" ? INTEGRAL gn-clie
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
         HEIGHT             = 10.19
         WIDTH              = 135.43.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN gn-clie.ApePat IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.CodDiv IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.CodUnico IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN f-Canal IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-Giro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.GirCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.JfeLog[5] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR TOGGLE-BOX gn-clie.Libre_L02 IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN gn-clie.Nombre IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.NomCli IN FRAME F-Main
   NO-ENABLE ALIGN-L EXP-LABEL EXP-FORMAT                               */
/* SETTINGS FOR FILL-IN gn-clie.RepLeg[1] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.RepLeg[2] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.RepLeg[4] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.RepLeg[5] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR RADIO-SET gn-clie.SwBajaSunat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.Transporte[4] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
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

&Scoped-define SELF-NAME gn-clie.ApeMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.ApeMat V-table-Win
ON LEAVE OF gn-clie.ApeMat IN FRAME F-Main /* Ap. Materno */
DO:
    IF TRUE <> (SELF:SCREEN-VALUE > "") THEN RETURN.
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
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
ON LEAVE OF gn-clie.ApePat IN FRAME F-Main /* Ap. Paterno */
DO:
    IF TRUE <> (SELF:SCREEN-VALUE > "") THEN RETURN.
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    gn-clie.nomcli:SCREEN-VALUE = TRIM (gn-clie.apepat:SCREEN-VALUE) + " " +
        TRIM (gn-clie.apemat:SCREEN-VALUE) + ", " +
        gn-clie.nombre:SCREEN-VALUE.
    IF gn-clie.apepat:SCREEN-VALUE = '' AND gn-clie.apemat:SCREEN-VALUE = '' 
    THEN gn-clie.nomcli:SCREEN-VALUE = gn-clie.nombre:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.Canal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.Canal V-table-Win
ON LEAVE OF gn-clie.Canal IN FRAME F-Main /* Canal */
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


&Scoped-define SELF-NAME gn-clie.CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.CodVen V-table-Win
ON LEAVE OF gn-clie.CodVen IN FRAME F-Main /* Codigo Vendedor */
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


&Scoped-define SELF-NAME gn-clie.DNI
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.DNI V-table-Win
ON LEAVE OF gn-clie.DNI IN FRAME F-Main /* DNI */
DO:
    IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
    DEF VAR x-Integer AS INT NO-UNDO.
    /* Dígito Verificador */
    IF LENGTH(gn-clie.DNI:SCREEN-VALUE) <> 8 THEN DO:
        MESSAGE 'Debe tener 8 caracteres numéricos' VIEW-AS ALERT-BOX ERROR.
        gn-clie.DNI:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    ASSIGN x-Integer = INTEGER(gn-clie.DNI:SCREEN-VALUE) NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        MESSAGE 'Debe tener 8 caracteres numéricos' VIEW-AS ALERT-BOX ERROR.
        gn-clie.DNI:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    APPLY 'VALUE-CHANGED':U TO gn-clie.Libre_C01.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.GirCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.GirCli V-table-Win
ON LEAVE OF gn-clie.GirCli IN FRAME F-Main /* Giro */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO:
     FIND almtabla WHERE almtabla.Tabla = 'GN' 
        AND almtabla.Codigo = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE almtabla 
     THEN F-Giro:screen-value = almtabla.nombre.
     ELSE F-Giro:screen-value = "".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.Libre_C01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.Libre_C01 V-table-Win
ON VALUE-CHANGED OF gn-clie.Libre_C01 IN FRAME F-Main /* Libre_C01 */
DO:
    IF gn-clie.Libre_C01:SCREEN-VALUE <> "N" 
        THEN ASSIGN
        gn-clie.ApeMat:SENSITIVE = NO
        gn-clie.ApePat:SENSITIVE = NO
        gn-clie.Nombre:SENSITIVE = NO
        gn-clie.ApeMat:SCREEN-VALUE = ''
        gn-clie.ApePat:SCREEN-VALUE = ''.
    ELSE ASSIGN
        gn-clie.ApeMat:SENSITIVE = YES
        gn-clie.ApePat:SENSITIVE = YES
        gn-clie.Nombre:SENSITIVE = YES.
    APPLY 'LEAVE':U TO gn-clie.ApePat.
    /* Armamos el código del cliente */
    CASE TRUE:
        WHEN gn-clie.Ruc:SCREEN-VALUE > '' THEN gn-clie.CodCli:SCREEN-VALUE = gn-clie.Ruc:SCREEN-VALUE.
        WHEN gn-clie.Dni:SCREEN-VALUE > '' THEN gn-clie.CodCli:SCREEN-VALUE = STRING(INTEGER(gn-clie.Dni:SCREEN-VALUE), '99999999999').
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.Nombre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.Nombre V-table-Win
ON LEAVE OF gn-clie.Nombre IN FRAME F-Main /* Nombre/Razón Social */
DO:
    IF TRUE <> (SELF:SCREEN-VALUE > "") THEN RETURN.
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    gn-clie.nomcli:SCREEN-VALUE = TRIM (gn-clie.apepat:SCREEN-VALUE) + " " +
        TRIM (gn-clie.apemat:SCREEN-VALUE) + ", " +
        gn-clie.nombre:SCREEN-VALUE.
    IF gn-clie.apepat:SCREEN-VALUE = '' AND gn-clie.apemat:SCREEN-VALUE = '' 
    THEN gn-clie.nomcli:SCREEN-VALUE = gn-clie.nombre:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.Ruc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.Ruc V-table-Win
ON LEAVE OF gn-clie.Ruc IN FRAME F-Main /* Ruc */
DO:
  IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
  /* Dígito Verificador */
  RUN lib/_ValRuc (gn-clie.Ruc:SCREEN-VALUE, OUTPUT pResultado).
  IF pResultado = 'ERROR' THEN DO:
      MESSAGE 'Código MAL registrado' VIEW-AS ALERT-BOX WARNING.
      gn-clie.RUC:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  /* Verificamos Información SUNAT */
  RUN gn/datos-sunat-clientes (
      INPUT gn-clie.Ruc:SCREEN-VALUE,
      OUTPUT pBajaSunat,
      OUTPUT pName,
      OUTPUT pAddress,
      OUTPUT pUbigeo,
      OUTPUT pError ).
  IF pBajaSunat = YES THEN DO:
      MESSAGE 'El RUC está de baja en SUNAT' VIEW-AS ALERT-BOX ERROR.
      gn-clie.RUC:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  IF pError > '' THEN DO:
      MESSAGE 'Se ha detectado el siguiente error:' SKIP
          pError SKIP
          'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION
          BUTTONS YES-NO UPDATE rpta AS LOG.
      IF rpta = NO THEN DO:
          gn-clie.RUC:SCREEN-VALUE = ''.
          RETURN NO-APPLY.
      END.
  END.
  IF gn-clie.Libre_C01:SCREEN-VALUE = "J" THEN
      DISPLAY 
      gn-clie.Ruc:SCREEN-VALUE @ gn-clie.CodCli
      pName @ gn-clie.Nombre
      pName @ gn-clie.NomCli 
      WITH FRAME {&FRAME-NAME}.
  DISPLAY pName @ gn-clie.NomCli WITH FRAME {&FRAME-NAME}.
  APPLY 'VALUE-CHANGED':U TO gn-clie.Libre_C01.
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
  DEF VAR cEvento AS CHAR INIT "CREATE" NO-UNDO.
  DEF VAR x-Mensaje AS CHAR NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN get-attribute("ADM-NEW-RECORD").
  IF RETURN-VALUE = "YES" THEN DO:
     /* Buscamos RUC repetidos */
     IF gn-clie.Ruc > '' THEN DO:
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
     RUN gn/datos-sunat-clientes (
         INPUT gn-clie.Ruc,
         OUTPUT pBajaSunat,
         OUTPUT pName,
         OUTPUT pAddress,
         OUTPUT pUbigeo,
         OUTPUT pError ).
     IF TRUE <> (pError > "") THEN DO:
         ASSIGN
         gn-clie.SwCargaSunat = "S"     /* SUNAT */
         gn-clie.DirCli = pAddress
         gn-clie.CodDept = SUBSTRING(pUbigeo,1,2)
         gn-clie.CodProv = SUBSTRING(pUbigeo,3,2)
         gn-clie.CodDist = SUBSTRING(pUbigeo,5,2).
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
  ASSIGN 
      gn-clie.CodCia = CL-CODCIA
      gn-clie.clfcli = "C"       /* por defecto */
      gn-clie.clfcli2 = "C"       /* por defecto */
      gn-clie.Fching = TODAY.

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
  DEF VAR k AS INT NO-UNDO.
  DEF VAR i AS INT INIT 1 NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Gn-clie THEN DO WITH FRAME {&FRAME-NAME}:
      FIND almtabla WHERE almtabla.Tabla = 'GN' 
                     AND  almtabla.Codigo = gn-clie.GirCli 
                    NO-LOCK NO-ERROR.
      IF AVAILABLE  almtabla THEN DISPLAY almtabla.nombre @ f-giro.
      FIND gn-ven WHERE gn-ven.codcia = s-codcia
          AND gn-ven.CodVen = gn-clie.CodVen NO-LOCK NO-ERROR.
      IF AVAILABLE  gn-ven THEN DISPLAY gn-ven.NomVen @ f-NomVen.
      FIND almtabla WHERE almtabla.Tabla = 'CN' 
                     AND  almtabla.Codigo = gn-clie.Canal 
                    NO-LOCK NO-ERROR.
      IF AVAILABLE  almtabla THEN DISPLAY almtabla.nombre @ f-canal.
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
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      CASE RETURN-VALUE:
          WHEN 'YES' THEN DO:
              DISABLE gn-clie.CodCli.
              /* Solo si es un cliente NUEVO Institucionales */
              IF s-CodDiv = '00024' THEN DO:
                  ASSIGN gn-clie.CodDiv:SENSITIVE = NO.
              END.
          END.
          WHEN 'NO' THEN DO:
              DISABLE gn-clie.CodCli /*gn-clie.DNI*/ gn-clie.Ruc gn-clie.Libre_C01.
              /* control de acceso */
              gn-clie.NomCli:SENSITIVE = NO.
              IF gn-clie.Libre_C01 <> "N" 
                  THEN ASSIGN
                  gn-clie.ApeMat:SENSITIVE = NO
                  gn-clie.ApePat:SENSITIVE = NO
                  gn-clie.Nombre:SENSITIVE = YES.
              ELSE ASSIGN
                  gn-clie.ApeMat:SENSITIVE = YES
                  gn-clie.ApePat:SENSITIVE = YES
                  gn-clie.Nombre:SENSITIVE = YES.
              IF gn-clie.SwCargaSunat = "S" THEN
                  ASSIGN
                  gn-clie.ApeMat:SENSITIVE = NO
                  gn-clie.ApePat:SENSITIVE = NO
                  gn-clie.Nombre:SENSITIVE = NO.

/*               CASE s-nivel-acceso:                                         */
/*                   WHEN 1 THEN DO:                                          */
/*                   END.                                                     */
/*                   WHEN 2 THEN DO:                                          */
/*                       ASSIGN                                               */
/*                           gn-clie.flgsit:SENSITIVE = NO                    */
/*                           gn-clie.CodUnico:SENSITIVE = NO                  */
/*                           gn-clie.codven:SENSITIVE = NO                    */
/*                           gn-clie.coddiv:SENSITIVE = NO.                   */
/*                   END.                                                     */
/*                   WHEN 3 THEN DO:                                          */
/*                       ASSIGN                                               */
/*                           gn-clie.flgsit:SENSITIVE = NO                    */
/*                           gn-clie.CodUnico:SENSITIVE = NO                  */
/*                           gn-clie.codven:SENSITIVE = NO                    */
/*                           gn-clie.coddiv:SENSITIVE = NO                    */
/*                           gn-clie.canal:SENSITIVE = NO                     */
/*                           gn-clie.gircli:SENSITIVE = NO.                   */
/*                   END.                                                     */
/*                   WHEN 4 THEN DO:                                          */
/*                       RUN dispatch IN THIS-PROCEDURE ('disable-fields':U). */
/*                       ASSIGN                                               */
/*                           gn-clie.CodDiv:SENSITIVE = YES                   */
/*                           gn-clie.CodVen:SENSITIVE = YES                   */
/*                           gn-clie.Nombre:SENSITIVE = NO                    */
/*                           gn-clie.Canal:SENSITIVE = YES                    */
/*                           .                                                */
/*                   END.                                                     */
/*               END CASE.                                                    */
              /* RHC 14-09-2012 BLOQUEAMOS CLIENTES GENÉRICOS */
              IF s-user-id <> "ADMIN" AND gn-clie.codcli BEGINS "1111111111"
                  THEN ASSIGN
                  gn-clie.ApeMat:SENSITIVE = NO
                  gn-clie.ApePat:SENSITIVE = NO
                  gn-clie.Nombre:SENSITIVE = NO
                  gn-clie.NomCli:SENSITIVE = NO.
          END.
      END CASE.
  END.

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
        WHEN "GirCli" THEN ASSIGN input-var-1 = "GN".
        WHEN "TpoCli" THEN ASSIGN input-var-1 = "TC".
        WHEN "Canal" THEN ASSIGN input-var-1 = "CN".
        WHEN "Clfcom" THEN ASSIGN input-var-1 = "CM".
        WHEN "CndVta" THEN ASSIGN input-var-1 = "".
     END CASE.
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

DO WITH FRAME {&FRAME-NAME} :
    CASE TRUE:
        WHEN gn-clie.Libre_C01:SCREEN-VALUE = "J" THEN DO:
            IF LENGTH(gn-clie.Ruc:SCREEN-VALUE) <> 11 
                OR LOOKUP(SUBSTRING(gn-clie.Ruc:SCREEN-VALUE,1,2), '20') = 0 THEN DO:
                MESSAGE 'Debe tener 11 dígitos y comenzar con 20' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO gn-clie.Ruc.
                RETURN 'ADM-ERROR'.
            END.
            /* dígito verificador */
            RUN lib/_ValRuc (gn-clie.Ruc:SCREEN-VALUE, OUTPUT pResultado).
            IF pResultado = 'ERROR' THEN DO:
                MESSAGE 'RUC MAL registrado' VIEW-AS ALERT-BOX WARNING.
                APPLY 'ENTRY':U TO gn-clie.Ruc.
                RETURN 'ADM-ERROR'.
            END.
        END.
        WHEN gn-clie.Libre_C01:SCREEN-VALUE = "E" THEN DO:
            IF LENGTH(gn-clie.Ruc:SCREEN-VALUE) < 11 
                OR LOOKUP(SUBSTRING(gn-clie.Ruc:SCREEN-VALUE,1,2), '15,17') = 0 THEN DO:
                MESSAGE 'Debe tener 11 dígitos y comenzar con 15 ó 17' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO gn-clie.Ruc.
                RETURN 'ADM-ERROR'.
            END.
            /* dígito verificador */
            RUN lib/_ValRuc (gn-clie.Ruc:SCREEN-VALUE, OUTPUT pResultado).
            IF pResultado = 'ERROR' THEN DO:
                MESSAGE 'RUC MAL registrado' VIEW-AS ALERT-BOX WARNING.
                APPLY 'ENTRY':U TO gn-clie.Ruc.
                RETURN 'ADM-ERROR'.
            END.
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
                    MESSAGE 'RUC MAL registrado' VIEW-AS ALERT-BOX WARNING.
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
    IF TRUE <> (gn-clie.CodCli:SCREEN-VALUE > "") THEN DO:
       MESSAGE "CLIENTE no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO gn-clie.CodCli.
       RETURN "ADM-ERROR".   
    END.
    FIND GN-DIVI WHERE GN-DIVI.codcia = s-codcia
        AND GN-DIVI.coddiv = gn-clie.CodDiv:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE GN-DIVI
    THEN DO:
        MESSAGE 'Division no registrada' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO gn-clie.coddiv.
        RETURN 'ADM-ERROR'.
    END.        
    /* PARCHE TEMPORAL 07/06/2014 */
    IF gn-clie.Canal:SCREEN-VALUE = '' THEN DO:
         MESSAGE 'Debe ingresar el Canal' VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY":U TO gn-clie.canal.
         RETURN "ADM-ERROR".
    END.
    IF gn-clie.CodVen:SCREEN-VALUE <> "" THEN DO:
        FIND gn-ven WHERE gn-ven.codcia = s-codcia
            AND gn-ven.CodVen = gn-clie.CodVen:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-ven 
        THEN DO:
            MESSAGE 'Vendedor no registrado' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-clie.CodVen.
            RETURN 'ADM-ERROR'.
        END.
    END.
    IF gn-clie.GirCli:SCREEN-VALUE <> '' THEN DO:
        FIND almtabla WHERE almtabla.Tabla = 'GN' 
            AND almtabla.Codigo = gn-clie.GirCli:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almtabla
        THEN DO:
            MESSAGE 'El giro del cliente no registrado' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-clie.GirCli.
            RETURN 'ADM-ERROR'.
        END.
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
        IF gn-clie.Nombre:SCREEN-VALUE = '' THEN DO:
            MESSAGE 'Ingrese la Razón Social' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-clie.Nombre.
            RETURN 'ADM-ERROR'.
        END.
    END.
    /* CON BAJA SUNAT */
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'NO' THEN DO:
        IF gn-clie.Flgsit:SCREEN-VALUE = "A" AND  gn-clie.SwBajaSunat = YES
            THEN DO:
            MESSAGE 'NO se puede activar un cliente con baja en SUNAT'
                VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-clie.Flgsit.
            RETURN 'ADM-ERROR'.
        END.
    END.
    ELSE DO:
        IF CAN-FIND(FIRST gn-clie WHERE gn-clie.codcia = cl-codcia AND
                    gn-clie.codcli = gn-clie.codcli:SCREEN-VALUE NO-LOCK)
            THEN DO:
            MESSAGE 'Cliente repetido' VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.

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
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

