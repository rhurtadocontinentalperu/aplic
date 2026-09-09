&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CPEDI FOR VtaCDocu.
DEFINE BUFFER B-DPEDI FOR VtaDDocu.
DEFINE SHARED TEMP-TABLE PEDI2 NO-UNDO LIKE VtaDDocu.



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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-nroser AS INT.
DEF SHARED VAR s-codmon AS INT.
DEF SHARED VAR s-CodCli AS CHAR.
DEF SHARED VAR s-porigv AS DEC.
DEF SHARED VAR s-cndvta AS CHAR.
DEF SHARED VAR s-tpocmb AS DEC.
DEF SHARED VAR s-codven AS CHAR.
DEF SHARED VAR lh_Handle AS HANDLE.
DEF SHARED VAR s-nrodec AS INT.
DEF SHARED VAR s-tpoped AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-flgigv AS LOG.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-adm-new-record AS CHAR.
DEF SHARED VARIABLE S-NROPED AS CHAR.
DEF SHARED VAR pCodDiv  AS CHAR.        /* DIVISION DE LA LISTA DE PRECIOS */
DEFINE SHARED VARIABLE S-CODTER   AS CHAR.
/* Parámetros de la División */
DEF SHARED VAR s-DiasVtoCot LIKE GN-DIVI.DiasVtoCot.
DEF SHARED VAR s-MinimoPesoDia AS DEC.
DEF SHARED VAR s-MaximaVarPeso AS DEC.
DEF SHARED VAR s-MinimoDiasDespacho AS DEC.


DEF VAR s-copia-registro AS LOG.
DEF VAR s-cndvta-validos AS CHAR.
DEF VAR F-Observa        AS CHAR.
DEFINE VARIABLE s-pendiente-ibc AS LOG.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE VAR x-ClientesVarios AS CHAR.
x-ClientesVarios = FacCfgGn.CliVar.     /* 11 digitos */

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
&Scoped-define EXTERNAL-TABLES VtaCDocu
&Scoped-define FIRST-EXTERNAL-TABLE VtaCDocu


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR VtaCDocu.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS VtaCDocu.CodCli VtaCDocu.RucCli ~
VtaCDocu.DniCli VtaCDocu.FchVen VtaCDocu.NomCli VtaCDocu.FchEnt ~
VtaCDocu.DirCli VtaCDocu.Sede VtaCDocu.Cmpbnte VtaCDocu.LugEnt ~
VtaCDocu.CodMon VtaCDocu.Glosa VtaCDocu.TpoCmb VtaCDocu.CodPos ~
VtaCDocu.FlgIgv VtaCDocu.CodVen VtaCDocu.Libre_d01 VtaCDocu.FmaPgo ~
VtaCDocu.NroCard 
&Scoped-define ENABLED-TABLES VtaCDocu
&Scoped-define FIRST-ENABLED-TABLE VtaCDocu
&Scoped-Define DISPLAYED-FIELDS VtaCDocu.NroPed VtaCDocu.Libre_c01 ~
VtaCDocu.FchPed VtaCDocu.CodCli VtaCDocu.RucCli VtaCDocu.DniCli ~
VtaCDocu.FchVen VtaCDocu.NomCli VtaCDocu.FchEnt VtaCDocu.DirCli ~
VtaCDocu.Usuario VtaCDocu.Sede VtaCDocu.Cmpbnte VtaCDocu.LugEnt ~
VtaCDocu.CodMon VtaCDocu.Glosa VtaCDocu.TpoCmb VtaCDocu.CodPos ~
VtaCDocu.FlgIgv VtaCDocu.CodVen VtaCDocu.Libre_d01 VtaCDocu.FmaPgo ~
VtaCDocu.CodRef VtaCDocu.NroRef VtaCDocu.NroCard 
&Scoped-define DISPLAYED-TABLES VtaCDocu
&Scoped-define FIRST-DISPLAYED-TABLE VtaCDocu
&Scoped-Define DISPLAYED-OBJECTS F-Estado FILL-IN-1 FILL-IN-sede ~
FILL-IN-Postal f-NomVen F-CndVta F-Nomtar 

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
DEFINE BUTTON BUTTON-Turno-Avanza 
     IMAGE-UP FILE "adeicon\pvforw":U
     IMAGE-INSENSITIVE FILE "adeicon\pvforwx":U
     LABEL "Button 1" 
     SIZE 5 BY 1.35 TOOLTIP "Siguiente en el turno".

DEFINE BUTTON BUTTON-Turno-Retrocede 
     IMAGE-UP FILE "adeicon\pvback":U
     IMAGE-INSENSITIVE FILE "adeicon\pvbackx":U
     LABEL "Button turno avanza 2" 
     SIZE 5 BY 1.35 TOOLTIP "Siguiente en el turno".

DEFINE VARIABLE F-CndVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "ESTADO" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE F-Nomtar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE f-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81
     FONT 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Postal AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-sede AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     VtaCDocu.NroPed AT ROW 1.19 COL 8 COLON-ALIGNED WIDGET-ID 58
          LABEL "Número" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     F-Estado AT ROW 1.19 COL 26 COLON-ALIGNED WIDGET-ID 114
     VtaCDocu.Libre_c01 AT ROW 1.19 COL 57 COLON-ALIGNED WIDGET-ID 126
          LABEL "Lista Especial" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     VtaCDocu.FchPed AT ROW 1.19 COL 100 COLON-ALIGNED WIDGET-ID 46
          LABEL "Fecha de Emisión" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     BUTTON-Turno-Retrocede AT ROW 1.77 COL 70 WIDGET-ID 130
     BUTTON-Turno-Avanza AT ROW 1.77 COL 75 WIDGET-ID 128
     VtaCDocu.CodCli AT ROW 1.96 COL 8 COLON-ALIGNED WIDGET-ID 38
          LABEL "Cliente"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 0 
     VtaCDocu.RucCli AT ROW 1.96 COL 40 COLON-ALIGNED WIDGET-ID 60
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaCDocu.DniCli AT ROW 1.96 COL 57 COLON-ALIGNED WIDGET-ID 88
          LABEL "DNI" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FILL-IN-1 AT ROW 1.96 COL 78 COLON-ALIGNED NO-LABEL WIDGET-ID 132
     VtaCDocu.FchVen AT ROW 1.96 COL 100 COLON-ALIGNED WIDGET-ID 48 FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaCDocu.NomCli AT ROW 2.73 COL 8 COLON-ALIGNED WIDGET-ID 54 FORMAT "x(256)"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
          BGCOLOR 11 FGCOLOR 0 
     VtaCDocu.FchEnt AT ROW 2.73 COL 100 COLON-ALIGNED WIDGET-ID 138 FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 FGCOLOR 0 
     VtaCDocu.DirCli AT ROW 3.5 COL 8 COLON-ALIGNED WIDGET-ID 44
          LABEL "Dirección" FORMAT "x(256)"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
          BGCOLOR 11 FGCOLOR 0 
     VtaCDocu.Usuario AT ROW 3.5 COL 100 COLON-ALIGNED WIDGET-ID 66
          LABEL "Digitado por"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaCDocu.Sede AT ROW 4.27 COL 8 COLON-ALIGNED WIDGET-ID 62
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FILL-IN-sede AT ROW 4.27 COL 14 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     VtaCDocu.Cmpbnte AT ROW 4.27 COL 102 NO-LABEL WIDGET-ID 102
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Factura", "FAC":U,
"Boleta", "BOL":U
          SIZE 15 BY .81
          BGCOLOR 11 FGCOLOR 0 
     VtaCDocu.LugEnt AT ROW 5.04 COL 8 COLON-ALIGNED WIDGET-ID 112
          LABEL "Entregar en" FORMAT "x(256)"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
          BGCOLOR 11 FGCOLOR 0 
     VtaCDocu.CodMon AT ROW 5.04 COL 102 NO-LABEL WIDGET-ID 78
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dólares", 2
          SIZE 15 BY .81
          BGCOLOR 11 FGCOLOR 0 
     VtaCDocu.Glosa AT ROW 5.81 COL 8 COLON-ALIGNED WIDGET-ID 110
          LABEL "Glosa" FORMAT "X(256)"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
          BGCOLOR 11 FGCOLOR 0 
     VtaCDocu.TpoCmb AT ROW 5.81 COL 100 COLON-ALIGNED WIDGET-ID 64
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     VtaCDocu.CodPos AT ROW 6.58 COL 8 COLON-ALIGNED WIDGET-ID 134
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FILL-IN-Postal AT ROW 6.58 COL 13 COLON-ALIGNED NO-LABEL WIDGET-ID 136
     VtaCDocu.FlgIgv AT ROW 6.58 COL 102 WIDGET-ID 116
          LABEL "Afecto a IGV"
          VIEW-AS TOGGLE-BOX
          SIZE 12 BY .77
          BGCOLOR 11 FGCOLOR 0 
     VtaCDocu.CodVen AT ROW 7.35 COL 8 COLON-ALIGNED WIDGET-ID 42
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
          BGCOLOR 11 FGCOLOR 0 
     f-NomVen AT ROW 7.35 COL 14 COLON-ALIGNED NO-LABEL WIDGET-ID 94
     VtaCDocu.Libre_d01 AT ROW 7.35 COL 102 NO-LABEL WIDGET-ID 96
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "2", 2,
"3", 3,
"4", 4
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 0 
     VtaCDocu.FmaPgo AT ROW 8.12 COL 8 COLON-ALIGNED WIDGET-ID 50
          LABEL "Cond. Vta."
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
          BGCOLOR 11 FGCOLOR 0 
     F-CndVta AT ROW 8.12 COL 14 COLON-ALIGNED NO-LABEL WIDGET-ID 90
     VtaCDocu.CodRef AT ROW 8.12 COL 100 COLON-ALIGNED WIDGET-ID 120
          LABEL "Referencia"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     VtaCDocu.NroRef AT ROW 8.12 COL 105 COLON-ALIGNED NO-LABEL WIDGET-ID 122
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaCDocu.NroCard AT ROW 8.88 COL 8 COLON-ALIGNED WIDGET-ID 56
          LABEL "Tarjeta"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 FGCOLOR 0 
     F-Nomtar AT ROW 8.88 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 92
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 5.23 COL 96 WIDGET-ID 84
     "Redondedo del P.U.:" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 7.54 COL 87 WIDGET-ID 100
     "Comprobante:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 4.46 COL 92 WIDGET-ID 106
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.VtaCDocu
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CPEDI B "?" ? INTEGRAL VtaCDocu
      TABLE: B-DPEDI B "?" ? INTEGRAL VtaDDocu
      TABLE: PEDI2 T "SHARED" NO-UNDO INTEGRAL VtaDDocu
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
         HEIGHT             = 10.12
         WIDTH              = 117.57.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR BUTTON BUTTON-Turno-Avanza IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON BUTTON-Turno-Retrocede IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.CodCli IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.CodRef IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN VtaCDocu.DirCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN VtaCDocu.DniCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Nomtar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.FchEnt IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaCDocu.FchPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN VtaCDocu.FchVen IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Postal IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-sede IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX VtaCDocu.FlgIgv IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.FmaPgo IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.Glosa IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN VtaCDocu.Libre_c01 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN VtaCDocu.LugEnt IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN VtaCDocu.NomCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaCDocu.NroCard IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN VtaCDocu.NroRef IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.Usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
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

&Scoped-define SELF-NAME BUTTON-Turno-Avanza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Turno-Avanza V-table-Win
ON CHOOSE OF BUTTON-Turno-Avanza IN FRAME F-Main /* Button 1 */
DO:
  FIND NEXT ExpTurno WHERE expturno.codcia = s-codcia
      AND expturno.coddiv = s-coddiv
      AND expturno.block = s-codter
      AND expturno.fecha = TODAY
      AND expturno.estado = 'P' NO-LOCK NO-ERROR.
  IF AVAILABLE ExpTurno THEN DO:
      FILL-IN-1:SCREEN-VALUE = TRIM(ExpTurno.Tipo) + '-' +
          TRIM(STRING(ExpTurno.Turno)).
      FIND GN-CLIE WHERE gn-clie.codcia = cl-codcia
          AND gn-clie.codcli = expturno.codcli NO-LOCK NO-ERROR.
      IF AVAILABLE GN-CLIE THEN 
          DISPLAY 
            gn-clie.codcli @ VtaCDocu.CodCli            
            gn-clie.nomcli @ VtaCDocu.NomCli
            gn-clie.dircli @ VtaCDocu.DirCli 
            gn-clie.nrocard @ VtaCDocu.NroCard 
            gn-clie.ruc @ VtaCDocu.RucCli
            gn-clie.Codpos @ VtaCDocu.CodPos
            WITH FRAME {&FRAME-NAME}.
  END.
  APPLY 'ENTRY':U TO VtaCDocu.CodCli.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Turno-Retrocede
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Turno-Retrocede V-table-Win
ON CHOOSE OF BUTTON-Turno-Retrocede IN FRAME F-Main /* Button turno avanza 2 */
DO:
  FIND PREV ExpTurno WHERE expturno.codcia = s-codcia
      AND expturno.coddiv = s-coddiv
      AND expturno.block = s-codter
      AND expturno.fecha = TODAY
      AND expturno.estado = 'P' NO-LOCK NO-ERROR.
  IF AVAILABLE ExpTurno THEN DO:
      FILL-IN-1:SCREEN-VALUE = TRIM(ExpTurno.Tipo) + '-' +
          TRIM(STRING(ExpTurno.Turno)).
      FIND GN-CLIE WHERE gn-clie.codcia = cl-codcia
          AND gn-clie.codcli = expturno.codcli NO-LOCK NO-ERROR.
      IF AVAILABLE GN-CLIE THEN 
          DISPLAY 
            gn-clie.codcli @ VtaCDocu.CodCli            
            gn-clie.nomcli @ VtaCDocu.NomCli
            gn-clie.dircli @ VtaCDocu.DirCli 
            gn-clie.nrocard @ VtaCDocu.NroCard 
            gn-clie.ruc @ VtaCDocu.RucCli
            gn-clie.Codpos @ VtaCDocu.CodPos
            WITH FRAME {&FRAME-NAME}.
  END.
  APPLY 'ENTRY':U TO VtaCDocu.CodCli.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.Cmpbnte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.Cmpbnte V-table-Win
ON VALUE-CHANGED OF VtaCDocu.Cmpbnte IN FRAME F-Main /* Comprobante */
DO:
    DO WITH FRAM {&FRAME-NAME}:
        IF SELF:SCREEN-VALUE = 'FAC' 
            AND VtaCDocu.CodCli:SCREEN-VALUE <> '11111111112'
            THEN DO:
            FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                AND gn-clie.CodCli = VtaCDocu.CodCli:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
            ASSIGN
                VtaCDocu.DirCli:SENSITIVE = NO
                VtaCDocu.NomCli:SENSITIVE = NO
                VtaCDocu.DNICli:SENSITIVE = NO.
            IF AVAILABLE gn-clie THEN DO:
                ASSIGN
                    VtaCDocu.DirCli:SCREEN-VALUE = GN-CLIE.DirCli
                    VtaCDocu.NomCli:SCREEN-VALUE = GN-CLIE.NomCli
                    VtaCDocu.RucCli:SCREEN-VALUE = gn-clie.Ruc.
            END.
        END.
        ELSE DO:
            ASSIGN
                VtaCDocu.DirCli:SENSITIVE = YES
                VtaCDocu.NomCli:SENSITIVE = YES
                VtaCDocu.DNICli:SENSITIVE = YES.
            IF VtaCDocu.CodCli:SCREEN-VALUE = '11111111112' THEN VtaCDocu.RucCli:SENSITIVE = YES.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.CodCli V-table-Win
ON LEAVE OF VtaCDocu.CodCli IN FRAME F-Main /* Cliente */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  /*IF SELF:SCREEN-VALUE = S-CODCLI THEN RETURN. */

  RUN vtagn/p-gn-clie-01 (SELF:SCREEN-VALUE, s-CodDoc).
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  s-CodCli = SELF:SCREEN-VALUE.

  /* Cargamos las condiciones de venta válidas */
  FIND gn-clie WHERE gn-clie.codcia  = cl-codcia
      AND gn-clie.codcli = s-codcli
      NO-LOCK.
  RUN vta2/p-fmapgo (s-codcli, s-tpoped, OUTPUT s-cndvta-validos). 
  /* PARCHE EXPOLIBRERIA 28.10.2010 */
/*   s-cndvta-validos = '001'.                              */
/*   IF LOOKUP('400', gn-clie.cndvta) > 0                   */
/*       THEN s-cndvta-validos = s-cndvta-validos + ',400'. */
/*   IF LOOKUP('401', gn-clie.cndvta) > 0                   */
/*       THEN s-cndvta-validos = s-cndvta-validos + ',401'. */
/*   IF LOOKUP('405', gn-clie.cndvta) > 0                   */
/*       THEN s-cndvta-validos = s-cndvta-validos + ',405'. */
/*   IF LOOKUP('002', gn-clie.cndvta) > 0                   */
/*       THEN s-cndvta-validos = s-cndvta-validos + ',002'. */
/*   IF LOOKUP('411', gn-clie.cndvta) > 0                   */
/*       THEN s-cndvta-validos = s-cndvta-validos + ',411'. */
/*   IF LOOKUP('900', gn-clie.cndvta) > 0                   */
/*       THEN s-cndvta-validos = s-cndvta-validos + ',900'. */

  DISPLAY 
    gn-clie.NomCli @ VtaCDocu.NomCli
    gn-clie.Ruc    @ VtaCDocu.RucCli
    gn-clie.DirCli @ VtaCDocu.DirCli
    ENTRY(1, s-cndvta-validos) @ VtaCDocu.FmaPgo  /* La primera del cliente */
    gn-clie.NroCard @ VtaCDocu.NroCard
    gn-clie.CodVen WHEN VtaCDocu.CodVen:SCREEN-VALUE = '' @ VtaCDocu.CodVen 
    WITH FRAME {&FRAME-NAME}.
  ASSIGN
      S-CNDVTA = ENTRY(1, s-cndvta-validos).

  /* Tarjeta */
  FIND Gn-Card WHERE Gn-Card.NroCard = gn-clie.nrocard NO-LOCK NO-ERROR.
  IF AVAILABLE GN-CARD 
  THEN ASSIGN
            F-NomTar:SCREEN-VALUE = GN-CARD.NomClie[1]
            VtaCDocu.NroCard:SENSITIVE = NO.
  ELSE ASSIGN
            F-NomTar:SCREEN-VALUE = ''
            VtaCDocu.NroCard:SENSITIVE = YES.
  
  /* Ubica la Condicion Venta */
  FIND gn-convt WHERE gn-convt.Codig = VtaCDocu.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt 
  THEN DO:
       F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
  END.  
  ELSE F-CndVta:SCREEN-VALUE = "".

  IF VtaCDocu.FmaPgo:SCREEN-VALUE = '900' 
    AND VtaCDocu.Glosa:SCREEN-VALUE = ''
  THEN VtaCDocu.Glosa:SCREEN-VALUE = 'BONIFICACION DE CAMPAÑA POR COMPRA POR VOLUMEN'.

  /* Vendedor */
  F-NomVen:SCREEN-VALUE = "".
  FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
      AND  gn-ven.CodVen = VtaCDocu.CodVen:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-ven THEN F-NomVen:SCREEN-VALUE = gn-ven.NomVen.

  /* Recalculamos cotizacion */
  RUN Procesa-Handle IN lh_Handle ('Recalculo').

  /* Determina si es boleta o factura */
  IF VtaCDocu.RucCli:SCREEN-VALUE = ''
  THEN VtaCDocu.Cmpbnte:SCREEN-VALUE = 'BOL'.
  ELSE VtaCDocu.Cmpbnte:SCREEN-VALUE = 'FAC'.
  APPLY 'VALUE-CHANGED' TO VtaCDocu.Cmpbnte.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.CodCli V-table-Win
ON LEFT-MOUSE-DBLCLICK OF VtaCDocu.CodCli IN FRAME F-Main /* Cliente */
OR f8 OF VtaCDocu.CodCli
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''.
    IF s-TpoPed = "M" THEN input-var-1 = "006".
    RUN vtagn/c-gn-clie-01 ('Clientes').
    IF output-var-1 <> ? THEN VtaCDocu.CodCli:SCREEN-VALUE = output-var-2.
    /*APPLY 'ENTRY':U TO VtaCDocu.CodCli.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.CodMon V-table-Win
ON VALUE-CHANGED OF VtaCDocu.CodMon IN FRAME F-Main /* Cod!mon */
DO:
  S-CODMON = INTEGER(VtaCDocu.CodMon:SCREEN-VALUE).
  RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.CodPos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.CodPos V-table-Win
ON LEAVE OF VtaCDocu.CodPos IN FRAME F-Main /* Postal */
DO:
  FIND almtabla WHERE almtabla.tabla = 'CP'
      AND almtabla.codigo = INPUT {&SELF-NAME} NO-LOCK NO-ERROR.
  IF AVAILABLE almtabla 
      THEN FILL-IN-Postal:SCREEN-VALUE = almtabla.nombre.
  ELSE FILL-IN-Postal:SCREEN-VALUE = ''.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.CodVen V-table-Win
ON LEAVE OF VtaCDocu.CodVen IN FRAME F-Main /* Vendedor */
DO:
  F-NomVen:SCREEN-VALUE = "".
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
    AND  gn-ven.CodVen = VtaCDocu.CodVen:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-ven THEN DO:
      MESSAGE "Vendedor NO válido" VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = "".
      RETURN NO-APPLY.
  END.
  F-NomVen:SCREEN-VALUE = gn-ven.NomVen.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.CodVen V-table-Win
ON LEFT-MOUSE-DBLCLICK OF VtaCDocu.CodVen IN FRAME F-Main /* Vendedor */
OR f8 OF VtaCDocu.CodVen
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''.
    RUN lkup/c-vende ('Vendedor').
    IF output-var-1 <> ? THEN VtaCDocu.CodVen:SCREEN-VALUE = output-var-2.
    /*APPLY 'ENTRY':U TO VtaCDocu.CodVen.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.FchEnt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.FchEnt V-table-Win
ON LEAVE OF VtaCDocu.FchEnt IN FRAME F-Main /* Fecha Entrega */
DO:
    IF INPUT {&self-name} < (TODAY + s-MinimoDiasDespacho) THEN DO:
        MESSAGE 'No se puede despachar antes del' (TODAY + s-MinimoDiasDespacho)
            VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF s-MinimoPesoDia > 0 AND INPUT {&SELF-NAME} <> ? AND RETURN-VALUE = 'YES' 
        THEN DO:
        DEF VAR x-Cuentas AS DEC NO-UNDO.
        DEF VAR x-Tope    AS DEC NO-UNDO.
        x-Tope = s-MinimoPesoDia * (1 + s-MaximaVarPeso / 100).
        FOR EACH B-CPEDI NO-LOCK WHERE B-CPEDI.codcia = s-codcia
            AND B-CPEDI.coddiv = s-coddiv
            AND B-CPEDI.codped = s-coddoc
            AND B-CPEDI.flgest <> 'A'
            AND B-CPEDI.fchped >= INPUT Vtacdocu.FchPed
            AND B-CPEDI.fchent = INPUT {&SELF-NAME}:
            x-Cuentas = x-Cuentas + B-CPEDI.Libre_d02.
        END.            
        IF x-Cuentas > x-Tope THEN DO:
            MESSAGE 'Ya se cubrieron los despachos para ese día' 
                VIEW-AS ALERT-BOX WARNING.
            RETURN NO-APPLY.
        END.
    END.
    /* RHC 22.12.05 MAXIMO 40 DESPACHOS POR DIA */
/*     IF NOT (INPUT {&SELF-NAME} >= DATE(01,14,2014)) THEN DO:               */
/*         MESSAGE 'Los despachos deben programarse a partir del 14 de Enero' */
/*             VIEW-AS ALERT-BOX WARNING.                                     */
/*         RETURN NO-APPLY.                                                   */
/*     END.                                                                   */
/*     RUN GET-ATTRIBUTE('ADM-NEW-RECORD').                                   */
/*     IF INPUT {&SELF-NAME} <> ? AND RETURN-VALUE = 'YES' THEN DO:           */
/*         DEF VAR x-Cuentas AS INT NO-UNDO.                                  */
/*         DEF VAR x-Tope    AS INT INIT 40 NO-UNDO.                          */
/*         FOR EACH B-CPEDI NO-LOCK WHERE B-CPEDI.codcia = s-codcia           */
/*             AND B-CPEDI.coddiv = s-coddiv                                  */
/*             AND B-CPEDI.codped = s-coddoc                                  */
/*             AND B-CPEDI.flgest <> 'A'                                      */
/*             AND B-CPEDI.fchped >= 01/01/2014                               */
/*             AND B-CPEDI.fchent = INPUT {&SELF-NAME}:                       */
/*             x-Cuentas = x-Cuentas + 1.                                     */
/*         END.                                                               */
/*                                                                            */
/*         IF x-Cuentas > x-Tope THEN DO:                                     */
/*             MESSAGE 'Ya se cubrieron los despachos para ese día'           */
/*                 VIEW-AS ALERT-BOX WARNING.                                 */
/*             RETURN NO-APPLY.                                               */
/*         END.                                                               */
/*     END.                                                                   */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.FlgIgv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.FlgIgv V-table-Win
ON VALUE-CHANGED OF VtaCDocu.FlgIgv IN FRAME F-Main /* Afecto a IGV */
DO:
    s-FlgIgv = INPUT {&self-name}.
    IF s-FlgIgv = YES THEN s-PorIgv = FacCfgGn.PorIgv.
    RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.FmaPgo V-table-Win
ON LEAVE OF VtaCDocu.FmaPgo IN FRAME F-Main /* Cond. Vta. */
DO:
    F-CndVta:SCREEN-VALUE = ''.
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND gn-convt WHERE gn-convt.Codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-convt THEN DO:
        MESSAGE 'Condición de venta NO válida' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
    /* Filtrado de las condiciones de venta */
    IF LOOKUP(SELF:SCREEN-VALUE, s-cndvta-validos) = 0 THEN DO:
        MESSAGE 'Condición de venta NO autorizada para este cliente'
            VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    s-CndVta = SELF:SCREEN-VALUE.
    RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.FmaPgo V-table-Win
ON LEFT-MOUSE-DBLCLICK OF VtaCDocu.FmaPgo IN FRAME F-Main /* Cond. Vta. */
OR f8 OF VtaCDocu.FmaPgo
DO:
    ASSIGN
        input-var-1 = s-cndvta-validos
        input-var-2 = ''
        input-var-3 = ''.
    RUN vta/d-cndvta.
    IF output-var-1 <> ? THEN VtaCDocu.Fmapgo:SCREEN-VALUE = output-var-2.
    /*APPLY 'ENTRY':U TO VtaCDocu.Fmapgo.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.Libre_d01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.Libre_d01 V-table-Win
ON VALUE-CHANGED OF VtaCDocu.Libre_d01 IN FRAME F-Main /* Libre_d01 */
DO:
    s-NroDec = INTEGER(SELF:SCREEN-VALUE).
    RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.NroCard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.NroCard V-table-Win
ON LEAVE OF VtaCDocu.NroCard IN FRAME F-Main /* Tarjeta */
DO:
    F-NomTar:SCREEN-VALUE = ''.
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    ASSIGN
      SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999") NO-ERROR.
    FIND Gn-Card WHERE Gn-Card.NroCard = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-Card THEN DO:
        MESSAGE 'Tarjeta de Cliente NO válida' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    F-NomTar:SCREEN-VALUE = GN-CARD.NomClie[1].
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.NroCard V-table-Win
ON LEFT-MOUSE-DBLCLICK OF VtaCDocu.NroCard IN FRAME F-Main /* Tarjeta */
OR f8 OF VtaCDocu.NroCard
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''.
    RUN lkup/c-gncard ('Tarjetas').
    IF output-var-1 <> ? THEN VtaCDocu.NroCard:SCREEN-VALUE = output-var-2.
    /*APPLY 'ENTRY':U TO VtaCDocu.NroCard.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.Sede
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.Sede V-table-Win
ON LEAVE OF VtaCDocu.Sede IN FRAME F-Main /* Sede */
DO:
    FILL-IN-Sede:SCREEN-VALUE = "".
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    FIND gn-clied WHERE gn-clied.codcia = cl-codcia
        AND gn-clied.codcli = VtaCDocu.codcli:SCREEN-VALUE
        AND gn-clied.sede = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clied THEN DO:
        MESSAGE "Sede NO válida" VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
    ASSIGN 
        FILL-IN-Sede:SCREEN-VALUE = Gn-ClieD.DirCli
        VtaCDocu.LugEnt:SCREEN-VALUE = Gn-ClieD.DirCli
        VtaCDocu.Glosa:SCREEN-VALUE = (IF VtaCDocu.Glosa:SCREEN-VALUE = '' THEN Gn-ClieD.DirCli ELSE VtaCDocu.Glosa:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.Sede V-table-Win
ON LEFT-MOUSE-DBLCLICK OF VtaCDocu.Sede IN FRAME F-Main /* Sede */
OR f8 OF VtaCDocu.Sede
DO:
    ASSIGN
      input-var-1 = VtaCDocu.CodCli:SCREEN-VALUE
      input-var-2 = VtaCDocu.NomCli:SCREEN-VALUE
      input-var-3 = ''
      output-var-1 = ?
      output-var-2 = ''
      output-var-3 = ''.
    RUN vta/c-clied.
    IF output-var-1 <> ?
        THEN ASSIGN 
              FILL-IN-Sede:SCREEN-VALUE = output-var-2
              VtaCDocu.LugEnt:SCREEN-VALUE = output-var-2
              VtaCDocu.Glosa:SCREEN-VALUE = (IF VtaCDocu.Glosa:SCREEN-VALUE = '' THEN output-var-2 ELSE VtaCDocu.Glosa:SCREEN-VALUE)
              VtaCDocu.Sede:SCREEN-VALUE = output-var-3.
    /*APPLY 'ENTRY':U TO VtaCDocu.Sede.*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-datos-cliente V-table-Win 
PROCEDURE Actualiza-datos-cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF AVAILABLE gn-clie AND s-codcli <> '' THEN DO:
    IF gn-clie.codcli BEGINS '1111111111' THEN RETURN.
    RUN vtamay/gVtaCli (ROWID(gn-clie)).
    IF RETURN-VALUE <> "ADM-ERROR"  THEN APPLY "LEAVE":U TO VtaCDocu.CodCli IN FRAME {&FRAME-NAME}.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  {src/adm/template/row-list.i "VtaCDocu"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "VtaCDocu"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Cotizacion V-table-Win 
PROCEDURE Asigna-Cotizacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cNroPed AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE F-TOT AS DECIMAL INIT 0 NO-UNDO.    

    /*Pregunta si desea generar cotizacion*/
    MESSAGE 'Esta Seguro de Generar Cotizacion'
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        TITLE '' UPDATE lchoice AS LOG.

    IF lchoice THEN DO:
        FIND FIRST VtaDDocu OF VtaCDocu WHERE VtaDDocu.Libre_d01 <> 0
            NO-LOCK NO-ERROR.
        IF NOT AVAIL VtaDDocu THEN DO: 
            MESSAGE 'No existe detalle para este documento'
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN 'adm-error'.
        END.

        /*Verifica Totales*/
        FOR EACH VtaDDocu OF VtaCDocu NO-LOCK:
            F-Tot = F-Tot + VtaDDocu.ImpLin.
        END.
        IF F-Tot = 0 THEN DO:
            MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.        
            RETURN "ADM-ERROR".   
        END.
        /* RHC 20.09.05 Transferencia gratuita */
        IF VtaCDocu.FmaPgo = '900' AND VtaCDocu.NroCar <> '' THEN DO:
            MESSAGE 'En caso de transferencia gratuita NO es válido el Nº de Tarjeta' 
                VIEW-AS ALERT-BOX WARNING.
            RETURN 'ADM-ERROR'.
        END.
        /* RHC 9.01.08 MINIMO S/.3000.00 */
        IF INTEGER(VtaCDocu.CodMon) = 2
            THEN f-Tot = f-Tot * DECIMAL(VtaCDocu.TpoCmb).
        IF f-Tot < 3000 THEN DO:
            MESSAGE 'El monto mínimo a cotizar es de S/.3000.00' SKIP
                    '           Necesita AUTORIZACION          '
                    VIEW-AS ALERT-BOX WARNING.
            DEF VAR x-Rep AS CHAR.
            RUN lib/_clave ('PCL', OUTPUT x-Rep).
            IF x-Rep = 'ERROR' THEN RETURN 'ADM-ERROR'.
        END.
        /*****************************/
        IF VtaCDocu.FlgSit = 'T' THEN DO: 
            MESSAGE 'Pre-Pedido ya registra cotización ' + VtaCDocu.NroRef
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
        ELSE DO: 
            /*RUN Vta2\genera-cotizacion-expov2 (ROWID(VtaCDocu), pCodDiv, OUTPUT CNroPed).    */
            RUN vta2/genera-cotizacion-expov3 (ROWID(VtaCDocu), pCodDiv, OUTPUT CNroPed).    
            IF cNroPed <> '' THEN
                MESSAGE '!!Cotización Nº ' + cNroPed + ' acaba de generarse!!.'.            
            ELSE MESSAGE '!!No se pudo generar Cotización!!'.
        END.
        RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Pedido V-table-Win 
PROCEDURE Borra-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH VtaDDocu OF VtaCDocu NO-LOCK TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR'
        ON STOP UNDO, RETURN 'ADM-ERROR':
        FIND B-DPEDI WHERE ROWID(B-DPEDI) = ROWID(VtaDDocu) EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE B-DPEDI THEN UNDO, RETURN 'ADM-ERROR'.
        DELETE B-DPedi.
        RELEASE B-DPEDI.
    END.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal V-table-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE PEDI2.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal V-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE PEDI2.

FOR EACH VtaDDocu OF VtaCDocu NO-LOCK:
    CREATE PEDI2.
    BUFFER-COPY VtaDDocu TO PEDI2.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierre-de-atencion V-table-Win 
PROCEDURE Cierre-de-atencion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Cierre de atención */
    FIND FIRST ExpTurno WHERE expturno.codcia = s-codcia
        AND expturno.coddiv = s-coddiv
        AND expturno.block = s-codter
        AND expturno.estado = 'P'
        AND expturno.fecha = TODAY
        AND expturno.codcli = VtaCDocu.codcli
        NO-LOCK NO-ERROR.
    IF AVAILABLE ExpTurno THEN DO:
        MESSAGE 'CERRAMOS la atención?' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO
            UPDATE rpta AS LOG.
        IF rpta = YES 
        THEN DO:
            FIND CURRENT ExpTurno EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            FIND B-CPEDI WHERE ROWID(B-CPEDI) = ROWID(VtaCDocu) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF AVAILABLE ExpTurno AND AVAILABLE B-CPEDI
            THEN ASSIGN
                    Expturno.Estado = 'C'
                    B-CPedi.Libre_c05 = '*'.
            RELEASE ExpTurno.
            RELEASE B-CPEDI.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Copia-Items V-table-Win 
PROCEDURE Copia-Items :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE PEDI2.
    FOR EACH VtaDDocu OF VtaCDocu NO-LOCK:
        CREATE PEDI2.
        ASSIGN
            PEDI2.AftIgv = VtaDDocu.AftIgv
            PEDI2.AftIsc = VtaDDocu.AftIsc
            PEDI2.AlmDes = VtaDDocu.AlmDes
            PEDI2.CanPed = VtaDDocu.CanPed
            PEDI2.CanPick = VtaDDocu.CanPed
            PEDI2.CodCia = VtaDDocu.CodCia
            PEDI2.CodCli = VtaDDocu.CodCli
            PEDI2.CodDiv = VtaDDocu.CodDiv
            PEDI2.CodPed = VtaDDocu.CodPed
            PEDI2.codmat = VtaDDocu.CodMat
            PEDI2.Factor = VtaDDocu.Factor
            PEDI2.FchPed = TODAY
            PEDI2.NroItm = VtaDDocu.NroItm
            PEDI2.Pesmat = VtaDDocu.PesMat
            /*PEDI2.TipVta = VtaDDocu.TipVta*/
            PEDI2.UndVta = VtaDDocu.UndVta.
/*         BUFFER-COPY VtaDDocu    */
/*             EXCEPT              */
/*             VtaDDocu.CanAte     */
/*             VtaDDocu.CanPick    */
/*             VtaDDocu.PorDto     */
/*             VtaDDocu.PorDto2    */
/*             VtaDDocu.Por_Dsctos */
/*             TO PEDI2.            */
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE desde_cotiz_excel V-table-Win 
PROCEDURE desde_cotiz_excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR OKpressed AS LOGICAL.
DEFINE VAR X-archivo AS CHARACTER.
DEFINE VAR X-archivo1 AS CHARACTER.
DEFINE VAR lCLiente AS CHARACTER.

DEFINE VAR xfil1 AS INT.
DEFINE VAR x-item AS INT.

SYSTEM-DIALOG GET-FILE x-Archivo
            FILTERS "Archivo (*.xls)" "*.xls"
            MUST-EXIST
            TITLE "Seleccione archivo..."
            UPDATE OKpressed.   

IF OKpressed = NO THEN RETURN "ADM-ERROR".

/* Descarto el SLASH del directorio */
xfil1 = R-INDEX(X-archivo,"\").
x-archivo1 = SUBSTRING(X-archivo,xfil1 + 1).

/* Descarto el primer _ */
xfil1 = INDEX(X-archivo1,"_").
IF  xfil1 = 0 THEN DO:
    MESSAGE 'El archivo Excel no es el Correcto..' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
x-archivo1 = SUBSTRING(X-archivo1,xfil1 + 1).

/* Descarto el 2do _ */
xfil1 = INDEX(X-archivo1,"_").
IF  xfil1 = 0 THEN DO:
    MESSAGE 'El archivo Excel no es el Correcto..' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
/* El codigo de Cliente */
x-archivo1 = SUBSTRING(X-archivo1,1,xfil1 - 1).

lCliente = TRIM(VtaCDocu.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
/*lCliente = TRIM(VtaCDocu.CodCli).*/

IF x-archivo1 <> lCliente THEN DO:
    MESSAGE 'El archivo Excel NO Pertenece al Cliente..' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

/* Abro el arhivo excel */
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE iRow                  AS INTEGER.
DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE x-signo                 AS DECI.

DEFINE VARIABLE iCantidad       AS INT.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = FALSE.

/* create a new Workbook */
/*chWorkbook = chExcelApplication:Workbooks:Add().*/

/* OPEN XLS */
chWorkbook = chExcelApplication:Workbooks:OPEN(x-archivo).

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

DO WITH FRAME {&FRAME-NAME}:
   EMPTY TEMP-TABLE PEDI2.
    x-Item = 1.
    /* Recorro todo el Excel */
    REPEAT iRow = 9 TO 597:
        cColumn = STRING(iRow).
        cRange = "K" + cColumn.
        iCantidad = chWorkSheet:Range(cRange):Value.
        IF iCantidad > 0 THEN DO:
            CREATE PEDI2.
                ASSIGN 
                    PEDI2.NroItm = x-Item
                    PEDI2.CodCia = s-codcia
                    cRange = "D" + cColumn
                    PEDI2.codmat = chWorkSheet:Range(cRange):Value
                    PEDI2.Factor = 1
                    PEDI2.CanPed = iCantidad
                    cRange = "H" + cColumn
                    PEDI2.UndVta = chWorkSheet:Range(cRange):Value.
                    x-Item = x-Item + 1.
        END.
    END.
END.
chExcelApplication:DisplayAlerts = False.
chExcelApplication:Quit().


/* BLOQUEAMOS CAMPOS */
/* ASSIGN
      s-Import-Cissac = YES
      VtaCDocu.CodCli:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      VtaCDocu.CodMon:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      VtaCDocu.Libre_d01:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
*/


/* release com-handles */
RELEASE OBJECT chExcelApplication NO-ERROR.      
RELEASE OBJECT chWorkbook NO-ERROR.
RELEASE OBJECT chWorksheet NO-ERROR.
RELEASE OBJECT chWorksheetRange NO-ERROR. 


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Edi-Comparativo V-table-Win 
PROCEDURE Edi-Comparativo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF VtaCDocu.FlgEst <> "A" THEN RUN vta2\r-impcot-superm (ROWID(VtaCDocu)).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel_Utilex V-table-Win 
PROCEDURE Excel_Utilex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER l-incigv AS LOGICAL.

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 6.
DEFINE VARIABLE F-PreUni                LIKE VtaDDocu.Preuni.
DEFINE VARIABLE F-ImpLin                LIKE VtaDDocu.ImpLin.
DEFINE VARIABLE F-ImpTot                LIKE VtaCDocu.ImpTot.
DEFINE VARIABLE f-ImpDto                LIKE VtaCDocu.ImpDto.

DEF        VAR C-NomVen  AS CHAR FORMAT "X(30)".
DEF        VAR C-Descli  AS CHAR FORMAT "X(60)".
DEF        VAR C-Moneda  AS CHAR FORMAT "X(7)".
DEF        VAR C-SimMon  AS CHAR FORMAT "X(7)".
DEF        VAR C-NomCon  AS CHAR FORMAT "X(30)".
DEF        VAR X-ORDCOM AS CHARACTER FORMAT "X(18)".
DEF        VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.
DEFINE VARIABLE C-OBS AS CHAR EXTENT 2 NO-UNDO.
DEFINE VARIABLE K AS INTEGER NO-UNDO.
DEFINE VARIABLE P AS INTEGER NO-UNDO.

IF NUM-ENTRIES(VtaCDocu.Observa,"-") - 1 > 6 THEN DO:
   DO K = 2 TO 7:
      IF ENTRY(K,VtaCDocu.Observa,"-") <> "" THEN 
         C-OBS[1] = C-OBS[1] + "- " + ENTRY(K,VtaCDocu.Observa,"-").
   END.
   DO K = 8 TO NUM-ENTRIES(VtaCDocu.Observa,"-"):
      IF ENTRY(K,VtaCDocu.Observa,"-") <> "" THEN 
         C-OBS[2] = C-OBS[2] + "- " + ENTRY(K,VtaCDocu.Observa,"-").
   END.
END.
ELSE DO: 
   C-OBS[1] = VtaCDocu.Observa.
   C-OBS[2] = "".
   /* 
   C-OBS[1] = SUBSTRING(VtaCDocu.Observa,1,INDEX(VtaCDocu.Observa,'@') - 1).
   C-OBS[2] = SUBSTRING(VtaCDocu.Observa,INDEX(VtaCDocu.Observa,'@') + 2).
   */
END.
/*IF VtaCDocu.FlgIgv THEN DO:*/
IF l-incigv THEN DO:
   F-ImpTot = VtaCDocu.ImpTot.
END.
ELSE DO:
   F-ImpTot = VtaCDocu.ImpVta.
END.  

/* ************************ cargamos variables ********************* */
FIND gn-ven WHERE 
     gn-ven.CodCia = VtaCDocu.CodCia AND  
     gn-ven.CodVen = VtaCDocu.CodVen 
     NO-LOCK NO-ERROR.
C-NomVen = VtaCDocu.CodVen.
IF AVAILABLE gn-ven THEN C-NomVen = C-NomVen + " - " + gn-ven.NomVen.
FIND gn-clie WHERE 
     gn-clie.codcia = cl-codcia AND  
     gn-clie.codcli = VtaCDocu.codcli NO-LOCK NO-ERROR.
     
C-DESCLI  = Gn-clie.codcli + ' - ' + Gn-clie.Nomcli     .
C-DESCLI  = VtaCDocu.codcli + ' - ' + VtaCDocu.Nomcli     .

IF VtaCDocu.codped = "PED" THEN 
    X-ORDCOM = "Orden de Compra : ".
ELSE 
    X-ORDCOM = "Solicitud Cotiz.: ".

FIND gn-ConVt WHERE gn-ConVt.Codig = VtaCDocu.FmaPgo NO-LOCK NO-ERROR.
C-NomCon = VtaCDocu.FmaPgo.
IF AVAILABLE gn-ConVt THEN C-NomCon = gn-ConVt.Nombr.
IF VtaCDocu.Codmon = 2 THEN DO: 
    C-Moneda = "DOLARES US$.".
    c-SimMon = "US$".
END.
ELSE DO: 
    C-Moneda = "SOLES   S/. ".
    c-SimMon = "S/.".
END.

/* ******************************************************************** */

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
/*chWorkbook = chExcelApplication:Workbooks:Add("C:\PRG\Templates\q fue\Cotizacion.xlt").*/
DEF var x-Plantilla AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION 'Plantillas' KEY 'Carpeta' VALUE x-Plantilla .
x-Plantilla = x-Plantilla + "Cotizacion_Sur.xlt".

chWorkbook = chExcelApplication:Workbooks:Add(x-Plantilla).

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 4.
chWorkSheet:Columns("B"):ColumnWidth = 7.
chWorkSheet:Columns("C"):ColumnWidth = 10.
chWorkSheet:Columns("D"):ColumnWidth = 4.
chWorkSheet:Columns("E"):ColumnWidth = 45.
chWorkSheet:Columns("F"):ColumnWidth = 11.
chWorkSheet:Columns("G"):ColumnWidth = 15.
chWorkSheet:Columns("H"):ColumnWidth = 10.
chWorkSheet:Columns("I"):ColumnWidth = 15.

/*Datos Cliente*/
t-Column = 17.
cColumn = STRING(t-Column).
cRange = "G" + '15'.
chWorkSheet:Range(cRange):Value = STRING(VtaCDocu.nroped,'999-999999'). 
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Señor(es) :" + c-descli. 
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Direccion :" + gn-clie.dircli. 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Emision         : " + STRING(VtaCDocu.fchped, '99/99/9999').
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Referencia :" . 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Vencimiento     : " + STRING(VtaCDocu.fchven, '99/99/9999') . 
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "VENDEDOR  : " + c-nomven . 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Forma de pago   : " + c-nomcon.
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "ATT.". 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Moneda          : " + c-moneda. 

t-Column = t-Column + 5.
cColumn = STRING(t-Column).
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value =  "(" + c-simmon + ")". 
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value =  "(" + c-simmon + ")". 

t-Column = t-Column + 2.

P = t-Column.
FOR EACH VtaDDocu OF VtaCDocu NO-LOCK,
        FIRST almmmatg OF VtaDDocu NO-LOCK
        BREAK BY VtaDDocu.NroPed BY VtaDDocu.NroItm DESC:
    /*RDP01 - 
    IF VtaCDocu.FlgIgv THEN DO:
       F-PreUni = VtaDDocu.PreUni.
       F-ImpLin = VtaDDocu.ImpLin. 
    END.
    ELSE DO:
       F-PreUni = ROUND(VtaDDocu.PreUni / (1 + VtaCDocu.PorIgv / 100),2).
       F-ImpLin = ROUND(VtaDDocu.ImpLin / (1 + VtaCDocu.PorIgv / 100),2). 
    END.  
    */

    IF l-incigv THEN DO:
       F-PreUni = VtaDDocu.PreUni.
       F-ImpLin = VtaDDocu.ImpLin. 
    END.
    ELSE DO:
       F-PreUni = ROUND(VtaDDocu.PreUni / (1 + VtaCDocu.PorIgv / 100),2).
       F-ImpLin = ROUND(VtaDDocu.ImpLin / (1 + VtaCDocu.PorIgv / 100),2). 
    END.  

    /*Agrega Row*/
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):EntireRow:INSERT.

    /*t-column = t-column + 1.*/
    p = p + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + STRING(VtaDDocu.nroitm, '>>>9').
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + VtaDDocu.codmat.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = VtaDDocu.canped.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = VtaDDocu.undvta.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = f-PreUni.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = VtaDDocu.impdto.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = f-ImpLin.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
END.
t-column = p + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "TOTAL " + c-simmon.
chWorkSheet:Range(cRange):FONT:Bold = TRUE.
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = f-ImpTot.
chWorkSheet:Range(cRange):FONT:Bold = TRUE.

t-column = t-column + 3.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
IF l-incigv THEN chWorkSheet:Range(cRange):Value = "* LOS PRECIOS INCLUYEN IGV.".
ELSE chWorkSheet:Range(cRange):Value = "* LOS PRECIOS NO INCLUYEN IGV.".


/*RD01-Condicion Venta*/
FIND FIRST gn-convt WHERE gn-convt.codig =  VtaCDocu.fmapgo NO-LOCK NO-ERROR.
IF AVAIL gn-convt THEN DO:
    t-column = t-column + 5.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "* FORMA DE PAGO: " +  gn-convt.Nombr.
END.


/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE G-P V-table-Win 
PROCEDURE G-P :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

  FOR EACH PEDI2 NO-LOCK WHERE PEDI2.ImpLin > 0
      BY PEDI2.NroItm:
      I-NITEM = I-NITEM + 1.
      CREATE VtaDDocu.
      BUFFER-COPY PEDI2 TO VtaDDocu
          ASSIGN
              VtaDDocu.CodCia = VtaCDocu.CodCia
              VtaDDocu.CodDiv = VtaCDocu.CodDiv
              VtaDDocu.codped = VtaCDocu.codped
              VtaDDocu.NroPed = VtaCDocu.NroPed
              VtaDDocu.FchPed = VtaCDocu.FchPed
              VtaDDocu.FlgEst = VtaCDocu.FlgEst
              VtaDDocu.NroItm = I-NITEM.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Excel2 V-table-Win 
PROCEDURE Genera-Excel2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER l-incigv AS LOGICAL.

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE F-PreUni                LIKE VtaDDocu.Preuni.
DEFINE VARIABLE F-ImpLin                LIKE VtaDDocu.ImpLin.
DEFINE VARIABLE F-ImpTot                LIKE VtaCDocu.ImpTot.

DEF        VAR C-NomVen  AS CHAR FORMAT "X(30)".
DEF        VAR C-Descli  AS CHAR FORMAT "X(60)".
DEF        VAR C-Moneda  AS CHAR FORMAT "X(7)".
DEF        VAR C-SimMon  AS CHAR FORMAT "X(7)".
DEF        VAR C-NomCon  AS CHAR FORMAT "X(30)".
DEF        VAR X-ORDCOM AS CHARACTER FORMAT "X(18)".
DEF        VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.
DEFINE VARIABLE C-OBS AS CHAR EXTENT 2 NO-UNDO.
DEFINE VARIABLE K AS INTEGER NO-UNDO.
DEFINE VARIABLE P AS INTEGER NO-UNDO.

IF NUM-ENTRIES(VtaCDocu.Observa,"-") - 1 > 6 THEN DO:
   DO K = 2 TO 7:
      IF ENTRY(K,VtaCDocu.Observa,"-") <> "" THEN 
         C-OBS[1] = C-OBS[1] + "- " + ENTRY(K,VtaCDocu.Observa,"-").
   END.
   DO K = 8 TO NUM-ENTRIES(VtaCDocu.Observa,"-"):
      IF ENTRY(K,VtaCDocu.Observa,"-") <> "" THEN 
         C-OBS[2] = C-OBS[2] + "- " + ENTRY(K,VtaCDocu.Observa,"-").
   END.
END.
ELSE DO: 
   C-OBS[1] = VtaCDocu.Observa.
   C-OBS[2] = "".
END.
/*IF VtaCDocu.FlgIgv THEN DO:*/
IF l-incigv THEN DO:
   F-ImpTot = VtaCDocu.ImpTot.
END.
ELSE DO:
   F-ImpTot = VtaCDocu.ImpVta.
END.  

/* ************************ cargamos variables ********************* */
FIND gn-ven WHERE 
     gn-ven.CodCia = VtaCDocu.CodCia AND  
     gn-ven.CodVen = VtaCDocu.CodVen 
     NO-LOCK NO-ERROR.
C-NomVen = VtaCDocu.CodVen.
IF AVAILABLE gn-ven THEN C-NomVen = C-NomVen + " - " + gn-ven.NomVen.
FIND gn-clie WHERE 
     gn-clie.codcia = cl-codcia AND  
     gn-clie.codcli = VtaCDocu.codcli NO-LOCK NO-ERROR.
     
C-DESCLI  = Gn-clie.codcli + ' - ' + Gn-clie.Nomcli     .
C-DESCLI  = VtaCDocu.codcli + ' - ' + VtaCDocu.Nomcli     .

IF VtaCDocu.codped = "PED" THEN 
    X-ORDCOM = "Orden de Compra : ".
ELSE 
    X-ORDCOM = "Solicitud Cotiz.: ".

FIND gn-ConVt WHERE gn-ConVt.Codig = VtaCDocu.FmaPgo NO-LOCK NO-ERROR.
C-NomCon = VtaCDocu.FmaPgo.
IF AVAILABLE gn-ConVt THEN C-NomCon = gn-ConVt.Nombr.
IF VtaCDocu.Codmon = 2 THEN DO: 
    C-Moneda = "DOLARES US$.".
    c-SimMon = "US$".
END.
ELSE DO: 
    C-Moneda = "SOLES   S/. ".
    c-SimMon = "S/.".
END.

/* ******************************************************************** */

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
/*chWorkbook = chExcelApplication:Workbooks:Add("C:\PRG\Templates\q fue\Cotizacion.xlt").*/
DEF var x-Plantilla AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION 'Plantillas' KEY 'Carpeta' VALUE x-Plantilla .
x-Plantilla = x-Plantilla + "Cotizacion.xlt".

chWorkbook = chExcelApplication:Workbooks:Add(x-Plantilla).

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 4.
chWorkSheet:Columns("B"):ColumnWidth = 7.
chWorkSheet:Columns("C"):ColumnWidth = 10.
chWorkSheet:Columns("D"):ColumnWidth = 4.
chWorkSheet:Columns("E"):ColumnWidth = 45.
chWorkSheet:Columns("F"):ColumnWidth = 11.
chWorkSheet:Columns("G"):ColumnWidth = 15.
chWorkSheet:Columns("H"):ColumnWidth = 10.
chWorkSheet:Columns("I"):ColumnWidth = 15.
/*Datos Cliente*/
t-Column = 11.
cColumn = STRING(t-Column).
/* cRange = "F" + cColumn.                                               */
/* chWorkSheet:Range(cRange):Value = "COTIZACION Nº " + VtaCDocu.nroped. */
cRange = "G9".
chWorkSheet:Range(cRange):Value = STRING(VtaCDocu.nroped, 'XXX-XXXXXX'). 
chWorkSheet:Range(cRange):FONT:Bold = TRUE.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Señor(es) :" + c-descli. 
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Direccion :" + gn-clie.dircli. 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Emision         : " + STRING(VtaCDocu.fchped, '99/99/9999').
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Referencia :" . 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Vencimiento     : " + STRING(VtaCDocu.fchven, '99/99/9999') . 
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "VENDEDOR  : " + c-nomven . 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Forma de pago   : " + c-nomcon.
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "ATT.". 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Moneda          : " + c-moneda. 

t-Column = t-Column + 5.
cColumn = STRING(t-Column).
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value =  "(" + c-simmon + ")". 
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value =  "(" + c-simmon + ")". 

/*
chWorkSheet:Range("G20"):Value = "(" + c-simmon + ")". 
chWorkSheet:Range("H20"):Value = "(" + c-simmon + ")". 
*/

t-Column = t-Column + 2.

P = t-Column.
FOR EACH VtaDDocu OF VtaCDocu NO-LOCK,
        FIRST almmmatg OF VtaDDocu NO-LOCK
        BREAK BY VtaDDocu.NroPed BY VtaDDocu.NroItm DESC:
    /*RDP01 - 
    IF VtaCDocu.FlgIgv THEN DO:
       F-PreUni = VtaDDocu.PreUni.
       F-ImpLin = VtaDDocu.ImpLin. 
    END.
    ELSE DO:
       F-PreUni = ROUND(VtaDDocu.PreUni / (1 + VtaCDocu.PorIgv / 100),2).
       F-ImpLin = ROUND(VtaDDocu.ImpLin / (1 + VtaCDocu.PorIgv / 100),2). 
    END.  
    */

    IF l-incigv THEN DO:
       /*F-PreUni = VtaDDocu.PreUni.*/
       F-ImpLin = VtaDDocu.ImpLin. 
       F-PreUni = VtaDDocu.ImpLin / VtaDDocu.CanPed.
    END.
    ELSE DO:
       /*F-PreUni = ROUND(VtaDDocu.PreUni / (1 + VtaCDocu.PorIgv / 100),2).*/
       F-ImpLin = ROUND(VtaDDocu.ImpLin / (1 + VtaCDocu.PorIgv / 100),2). 
       F-PreUni = ROUND(f-ImpLin / VtaDDocu.CanPed,2).
    END.  

    /*Agrega Row*/
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):EntireRow:INSERT.
    
    /*t-column = t-column + 1.*/
    p = p + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + STRING(VtaDDocu.nroitm, '>>>9').
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + VtaDDocu.codmat.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = VtaDDocu.canped.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = VtaDDocu.undvta.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = f-PreUni.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = f-ImpLin.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
END.
t-column = p + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "TOTAL " + c-simmon.
chWorkSheet:Range(cRange):FONT:Bold = TRUE.
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = f-ImpTot.
chWorkSheet:Range(cRange):FONT:Bold = TRUE.

t-column = t-column + 3.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
IF l-incigv THEN chWorkSheet:Range(cRange):Value = "* LOS PRECIOS INCLUYEN IGV.".
ELSE chWorkSheet:Range(cRange):Value = "* LOS PRECIOS NO INCLUYEN IGV.".


/*RD01-Condicion Venta*/
FIND FIRST gn-convt WHERE gn-convt.codig =  VtaCDocu.fmapgo NO-LOCK NO-ERROR.
IF AVAIL gn-convt THEN DO:
    t-column = t-column + 5.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "* FORMA DE PAGO: " +  gn-convt.Nombr.
END.


/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales V-table-Win 
PROCEDURE Graba-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  {vtaexp/graba-totales-exp.i}

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
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDoc = S-CODDOC 
      AND FacCorre.NroSer = s-NroSer
      NO-LOCK NO-ERROR.
  IF FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK.
  ASSIGN
      s-Copia-Registro = NO
      s-PorIgv = FacCfgGn.PorIgv
      s-adm-new-record = "YES"
      s-nroped = ""
      BUTTON-Turno-Avanza:SENSITIVE IN FRAME {&FRAME-NAME} = YES
      BUTTON-Turno-Retrocede:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          s-CodMon = 1
          s-CodCli = ''
          s-CndVta = ''
          s-TpoCmb = 1
          s-NroDec = 4
          s-FlgIgv = YES    /* Venta AFECTA a IGV */
          VtaCDocu.CodMon:SCREEN-VALUE = "Soles"
          VtaCDocu.Cmpbnte:SCREEN-VALUE = "FAC"
          VtaCDocu.Libre_d01:SCREEN-VALUE = STRING(s-NroDec, '9')
          VtaCDocu.FlgIgv:SCREEN-VALUE = "YES".
      FIND TcmbCot WHERE  TcmbCot.Codcia = 0
          AND  (TcmbCot.Rango1 <= TODAY - TODAY + 1
          AND   TcmbCot.Rango2 >= TODAY - TODAY + 1)
          NO-LOCK NO-ERROR.
      IF AVAIL TcmbCot THEN S-TPOCMB = TcmbCot.TpoCmb.  
      DISPLAY 
          STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ VtaCDocu.NroPed
          TODAY @ VtaCDocu.FchPed
          TODAY + 60 @ VtaCDocu.FchEnt
          /*DATE(01,14,2014) @ VtaCDocu.FchEnt*/
          S-TPOCMB @ VtaCDocu.TpoCmb
          (TODAY + s-DiasVtoCot) @ VtaCDocu.FchVen 
          s-CodVen @ VtaCDocu.codven.
      /* ******************************************************** */
      /* ***************** CLIENTE EN TURNO ********************* */
      /* ******************************************************** */
      FIND FIRST ExpTurno WHERE expturno.codcia = s-codcia
          AND expturno.coddiv = s-coddiv
          AND ExpTurno.Block = s-codter
          AND expturno.fecha = TODAY
          AND ExpTurno.Estado = 'P'
          NO-LOCK NO-ERROR.
      IF AVAILABLE ExpTurno THEN DO:
          FILL-IN-1:SCREEN-VALUE = TRIM(ExpTurno.Tipo) + '-' +
              TRIM(STRING(ExpTurno.Turno)).
          FIND GN-CLIE WHERE gn-clie.codcia = cl-codcia
              AND gn-clie.codcli = expturno.codcli NO-LOCK NO-ERROR.
          IF AVAILABLE GN-CLIE THEN 
              DISPLAY  
                gn-clie.codcli @ VtaCDocu.CodCli            
                gn-clie.nomcli @ VtaCDocu.NomCli
                gn-clie.dircli @ VtaCDocu.DirCli 
                gn-clie.nrocard @ VtaCDocu.NroCard 
                gn-clie.ruc @ VtaCDocu.RucCli
                gn-clie.Codpos @ VtaCDocu.CodPos.
      END.
      /* ******************************************************** */
      RUN Borra-Temporal.
      RUN Procesa-Handle IN lh_Handle ('Pagina2').
      APPLY 'ENTRY':U TO VtaCDocu.CodCli.
  END.

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
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
          AND FacCorre.CodDoc = S-CODDOC 
          AND FacCorre.CodDiv = S-CODDIV 
          AND Faccorre.NroSer = S-NroSer
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE FacCorre THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN 
          VtaCDocu.CodCia = S-CODCIA
          VtaCDocu.CodPed = s-coddoc 
          VtaCDocu.FchPed = TODAY 
          VtaCDocu.CodAlm = S-CODALM
          VtaCDocu.PorIgv = FacCfgGn.PorIgv 
          VtaCDocu.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
          /* VtaCDocu.TpoPed = s-TpoPed*/
          VtaCDocu.Libre_c02 = s-TpoPed
          VtaCDocu.CodDiv = S-CODDIV.
      ASSIGN
          FacCorre.Correlativo = FacCorre.Correlativo + 1.
  END.
  ELSE DO:
      RUN Borra-Pedido. 
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.
  
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN 
         VtaCDocu.Hora = STRING(TIME,"HH:MM")
         VtaCDocu.Usuario = S-USER-ID
         VtaCDocu.Observa = F-Observa
         /*VtaCDocu.Libre_c01 = (IF pCodDiv <> s-CodDiv THEN pCodDiv ELSE "")*/
         VtaCDocu.Libre_c01 = pCodDiv.

     RUN G-P.
     IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

     RUN Graba-Totales.
  END.  

  IF AVAILABLE(Faccorre) THEN RELEASE FacCorre.
  IF AVAILABLE(VtaDDocu) THEN RELEASE VtaDDocu.

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse'). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_Handle ('Pagina1').
  RUN Procesa-Handle IN lh_Handle ('Browse').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR pParametro AS CHAR NO-UNDO.

  IF NOT AVAILABLE VtaCDocu THEN RETURN "ADM-ERROR".
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDoc = S-CODDOC 
      AND FacCorre.NroSer = s-NroSer
      NO-LOCK NO-ERROR.
  IF FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  IF s-TpoPed = "S" AND VtaCDocu.Libre_C05 = "1" THEN DO:
      MESSAGE 'Copia NO permitida' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.

  /* CONTROL DE COPIA */
  IF VtaCDocu.flgest = "P" THEN DO:
      IF NOT CAN-FIND(FIRST VtaDDocu OF VtaCDocu WHERE VtaDDocu.canate > 0 NO-LOCK) THEN DO:
          MESSAGE 'Desea dar baja a la Cotización' VtaCDocu.nroped '(S/N)?'
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
              UPDATE rpta AS LOG.
          IF rpta = ? THEN RETURN 'ADM-ERROR'.
          IF rpta = NO THEN DO:
              /* Seguridad */
              RUN vta2/gConfirmaCopia ("CONFIRMAR BAJA DE COTIZACION", OUTPUT pParametro).
              IF pParametro = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
          END.
          ELSE DO:
              FIND CURRENT VtaCDocu EXCLUSIVE-LOCK NO-ERROR.
              IF NOT AVAILABLE VtaCDocu THEN RETURN 'ADM-ERROR'.
              ASSIGN
                  VtaCDocu.flgest = "X".
              FIND CURRENT VtaCDocu NO-LOCK.
              RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
          END.
      END.
  END.

  ASSIGN
      s-CodMon = VtaCDocu.codmon
      s-CodCli = VtaCDocu.codcli
      s-CndVta = VtaCDocu.fmapgo
      s-TpoCmb = 1
      s-FlgIgv = VtaCDocu.FlgIgv
      s-Copia-Registro = YES    /* <<< OJO >>> */
      s-PorIgv = FacCfgGn.PorIgv
      s-NroDec = VtaCDocu.Libre_d01.
  RUN Copia-Items.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FIND TcmbCot WHERE  TcmbCot.Codcia = 0
          AND  (TcmbCot.Rango1 <= TODAY - TODAY + 1
          AND   TcmbCot.Rango2 >= TODAY - TODAY + 1)
          NO-LOCK NO-ERROR.
      IF AVAIL TcmbCot THEN S-TPOCMB = TcmbCot.TpoCmb.  
      DISPLAY 
          "" @ F-Estado
          STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ VtaCDocu.NroPed
          TODAY @ VtaCDocu.FchPed
          S-TPOCMB @ VtaCDocu.TpoCmb
          (TODAY + s-DiasVtoCot) @ VtaCDocu.FchVen.
      APPLY "ENTRY":U TO VtaCDocu.CodCli.
  END.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('Recalculo').
  RUN Procesa-Handle IN lh_Handle ('Browse').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF VtaCDocu.FlgEst = "A" THEN DO:
      MESSAGE "El pedido ya fue anulado" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  IF pCodDiv <> VtaCDocu.Libre_c01 THEN DO:
      MESSAGE 'NO puede modificar una Cotización generada con otra lista de precios'
          VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.

  IF VtaCDocu.FlgSit = 'T' THEN DO:
        MESSAGE 'Este documento tiene asociado' SKIP
                ' la cotización Nº ' VtaCDocu.NroRef 
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN 'ADM-ERROR'.
  END.
  IF VtaCDocu.FlgEst = "C" THEN DO:
      MESSAGE "No puede eliminar una cotizacion TOTALMENTE atendida" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  IF VtaCDocu.FlgEst = "X" THEN DO:
      MESSAGE "No puede eliminar una cotizacion CERRADA" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.

  /* Si tiene atenciones parciales tambien se bloquea */
  FIND FIRST VtaDDocu OF VtaCDocu WHERE CanAte > 0 NO-LOCK NO-ERROR.
  IF AVAILABLE VtaDDocu 
  THEN DO:
      MESSAGE "La Cotización tiene atenciones parciales" SKIP
          "Acceso denegado"
          VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
    
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND CURRENT VtaCDocu EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE VtaCDocu THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN                 
          VtaCDocu.UsrAprobacion = s-user-id
          VtaCDocu.FchAprobacion = TODAY
          VtaCDocu.FlgEst = 'A'
          VtaCDocu.Glosa  = "ANULADO POR: " + TRIM (s-user-id) + " EL DIA: " + STRING(TODAY) + " " + STRING(TIME, 'HH:MM').
      FIND CURRENT VtaCDocu NO-LOCK.
      RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          BUTTON-Turno-Avanza:SENSITIVE IN FRAME {&FRAME-NAME} = NO
          BUTTON-Turno-Retrocede:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  END.

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
  IF AVAILABLE VtaCDocu THEN DO WITH FRAME {&FRAME-NAME}:
      RUN vta2/p-faccpedi-flgest (VtaCDocu.flgest, VtaCDocu.codped, OUTPUT f-Estado).
      IF VtaCDocu.FlgSit = 'T' THEN f-Estado = "COTIZADO".
      DISPLAY f-Estado.
      F-Nomtar:SCREEN-VALUE = ''.
      FIND FIRST Gn-Card WHERE Gn-Card.NroCard = VtaCDocu.NroCar NO-LOCK NO-ERROR.
      IF AVAILABLE Gn-Card THEN F-NomTar:SCREEN-VALUE = GN-CARD.NomClie[1].
      FILL-IN-sede:SCREEN-VALUE = "".
      FIND GN-ClieD WHERE GN-ClieD.CodCia = CL-CODCIA
          AND GN-ClieD.CodCli = VtaCDocu.Codcli
          AND GN-ClieD.sede = VtaCDocu.sede
          NO-LOCK NO-ERROR.
      IF AVAILABLE GN-ClieD THEN FILL-IN-sede:SCREEN-VALUE = GN-ClieD.dircli.
      F-NomVen:SCREEN-VALUE = "".
      FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
          AND  gn-ven.CodVen = VtaCDocu.CodVen 
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
      F-CndVta:SCREEN-VALUE = "".
      FIND gn-convt WHERE gn-convt.Codig = VtaCDocu.FmaPgo NO-LOCK NO-ERROR.
      IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
      FIND almtabla WHERE almtabla.tabla = 'CP'
          AND almtabla.codigo = VtaCDocu.codpos NO-LOCK NO-ERROR.
      IF AVAILABLE almtabla
          THEN FILL-IN-Postal:SCREEN-VALUE = almtabla.nombre.
      ELSE FILL-IN-Postal:SCREEN-VALUE = ''.
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
          VtaCDocu.DirCli:SENSITIVE = NO
          VtaCDocu.NomCli:SENSITIVE = NO
          VtaCDocu.RucCli:SENSITIVE = NO
          VtaCDocu.FchVen:SENSITIVE = NO
          VtaCDocu.FlgIgv:SENSITIVE = NO
          VtaCDocu.Libre_d01:SENSITIVE = NO
          VtaCDocu.CodMon:SENSITIVE = NO
          VtaCDocu.TpoCmb:SENSITIVE = NO.
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'NO' THEN DO:
          ASSIGN
              VtaCDocu.CodCli:SENSITIVE = NO
              VtaCDocu.FmaPgo:SENSITIVE = NO
              VtaCDocu.CodVen:SENSITIVE = NO
              VtaCDocu.FchEnt:SENSITIVE = NO.
      END.
  END.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  MESSAGE '¿Para Imprimir el documento marque'  SKIP
          '   1. Si = Incluye IGV.      ' SKIP
          '   2. No = No incluye IGV.      '
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
        UPDATE lchoice AS LOGICAL.
  IF lchoice = ? THEN RETURN 'adm-error'.
  IF VtaCDocu.FlgEst <> "A" THEN DO:
      RUN VTA\R-ImpCot-1 (ROWID(VtaCDocu),lchoice).
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
  F-Observa = VtaCDocu.Observa.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Cierre-de-atencion.
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse'). 
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Migrar-a-Provincias V-table-Win 
PROCEDURE Migrar-a-Provincias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:        SE SUPONE QUE NO EXISTE OTRO CORRELATIVO IGUAL EN LA DIVISION 00018
------------------------------------------------------------------------------*/

IF NOT AVAILABLE VtaCDocu THEN RETURN.
IF VtaCDocu.flgest <> 'P' THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

FIND CURRENT VtaCDocu EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE VtaCDocu THEN RETURN.
CREATE B-CPEDI.
BUFFER-COPY VtaCDocu TO B-CPEDI
    ASSIGN
        B-CPEDI.CodDiv = '00018'.
FOR EACH VtaDDocu OF VtaCDocu NO-LOCK:
    CREATE B-DPEDI.
    BUFFER-COPY VtaDDocu TO B-DPEDI
        ASSIGN
            B-DPEDI.CodDiv = B-CPEDI.CodDiv.
END.
ASSIGN
    VtaCDocu.FlgEst = "X"       /* CERRADA */
    VtaCDocu.FchAprobacion  = TODAY
    VtaCDocu.UsrAprobacion = s-user-id.

FIND CURRENT VtaCDocu NO-LOCK.
FIND CURRENT B-CPEDI NO-LOCK.
RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

MESSAGE 'Migración exitosa' VIEW-AS ALERT-BOX INFORMATION.

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

    CASE HANDLE-CAMPO:name:
        WHEN "CodPos" THEN 
            ASSIGN
            input-var-1 = 'CP'
            input-var-2 = ''
            input-var-3 = ''.
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
  {src/adm/template/snd-list.i "VtaCDocu"}

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
  DEFINE VARIABLE F-TOT AS DECIMAL INIT 0 NO-UNDO.
  DEFINE VARIABLE F-BOL AS DECIMAL INIT 0 NO-UNDO.

  DO WITH FRAME {&FRAME-NAME} :
      /* VALIDACION DEL CLIENTE */
      IF VtaCDocu.CodCli:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Codigo de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO VtaCDocu.CodCli.
         RETURN "ADM-ERROR".   
      END.
      RUN vtagn/p-gn-clie-01 (VtaCDocu.CodCli:SCREEN-VALUE , s-coddoc).
      IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
      /* CONTRATO MARCO -> CHEQUEO DE CANAL */
      IF s-TpoPed = "M" AND gn-clie.canal <> '006' THEN DO:
          MESSAGE 'Cliente no permitido en este canal de venta de venta'
             VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO VtaCDocu.CodCli.
         RETURN "ADM-ERROR".   
     END.
     IF VtaCDocu.Cmpbnte:SCREEN-VALUE = "FAC" AND VtaCDocu.RucCli:SCREEN-VALUE = '' THEN DO:
        MESSAGE "El Cliente NO tiene R.U.C." VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO VtaCDocu.CodCli.
        RETURN "ADM-ERROR".   
     END.      
     /* RHC 23.06.10 COntrol de sedes por autoservicios
          Los clientes deben estar inscritos en la opcion DESCUENTOS E INCREMENTOS */
     FIND FacTabla WHERE FacTabla.codcia = s-codcia
         AND FacTabla.Tabla = 'AU'
         AND FacTabla.Codigo = VtaCDocu.codcli:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE FacTabla AND VtaCDocu.Sede:SCREEN-VALUE = '' THEN DO:
         MESSAGE 'Debe registrar la sede para este cliente' VIEW-AS ALERT-BOX ERROR.
         APPLY 'ENTRY':U TO VtaCDocu.Sede.
         RETURN 'ADM-ERROR'.
     END.
     IF VtaCDocu.Sede:SCREEN-VALUE <> '' THEN DO:
         FIND Gn-clied OF Gn-clie WHERE Gn-clied.Sede = VtaCDocu.Sede:SCREEN-VALUE NO-LOCK NO-ERROR.
          IF NOT AVAILABLE gn-clied THEN DO:
              MESSAGE 'Sede no registrada para este cliente' VIEW-AS ALERT-BOX ERROR.
              APPLY 'ENTRY':U TO VtaCDocu.Sede.
              RETURN 'ADM-ERROR'.
          END.
     END.
    /* VALIDACION DEL VENDEDOR */
     IF VtaCDocu.CodVen:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Codigo de Vendedor no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO VtaCDocu.CodVen.
        RETURN "ADM-ERROR".   
     END.
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
         AND  gn-ven.CodVen = VtaCDocu.CodVen:SCREEN-VALUE 
         NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gn-ven THEN DO:
        MESSAGE "Codigo de Vendedor no existe" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO VtaCDocu.CodVen.
        RETURN "ADM-ERROR".   
     END.
     ELSE DO:
         IF gn-ven.flgest = "C" THEN DO:
             MESSAGE "Codigo de Vendedor Cesado" VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO VtaCDocu.CodVen.
             RETURN "ADM-ERROR".   
         END.
     END.
    /* VALIDACION DE LA CONDICION DE VENTA */    
     IF VtaCDocu.FmaPgo:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Condicion Venta no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO VtaCDocu.FmaPgo.
        RETURN "ADM-ERROR".   
     END.
     FIND gn-convt WHERE gn-convt.Codig = VtaCDocu.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gn-convt THEN DO:
        MESSAGE "Condicion Venta no existe" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO VtaCDocu.FmaPgo.
        RETURN "ADM-ERROR".   
     END.
     /* VALIDACION DE LA TARJETA */
     IF VtaCDocu.NroCar:SCREEN-VALUE <> "" THEN DO:
         FIND Gn-Card WHERE Gn-Card.NroCard = VtaCDocu.NroCar:SCREEN-VALUE
             NO-LOCK NO-ERROR.
         IF NOT AVAILABLE Gn-Card THEN DO:
             MESSAGE "Numero de Tarjeta Incorrecto, Verifique... " VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO VtaCDocu.NroCar.
             RETURN "ADM-ERROR".   
         END.   
     END.           
     /* VALIDACION DE AFECTO A IGV */
     IF s-flgigv = NO THEN DO:
         MESSAGE 'La cotización NO ESTA AFECTA A IGV' SKIP
             'Es eso correcto?'
             VIEW-AS ALERT-BOX QUESTION
             BUTTONS YES-NO UPDATE rpta AS LOG.
         IF rpta = NO THEN RETURN 'ADM-ERROR'.
     END.
     /* VALIDACION DE PEDI2S */
     FOR EACH PEDI2 NO-LOCK:
         F-Tot = F-Tot + PEDI2.ImpLin.
     END.
     IF F-Tot = 0 THEN DO:
        MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO VtaCDocu.CodCli.
        RETURN "ADM-ERROR".   
     END.
     /* VALIDACION DE MONTO MINIMO POR BOLETA */
     F-BOL = IF INTEGER(VtaCDocu.CodMon:SCREEN-VALUE) = 1 
         THEN F-TOT
         ELSE F-Tot * DECIMAL(VtaCDocu.TpoCmb:SCREEN-VALUE).
     IF VtaCDocu.Cmpbnte:SCREEN-VALUE = 'BOL' AND F-BOL > 700 
         AND (VtaCDocu.DNICli:SCREEN-VALUE = '' OR LENGTH(VtaCDocu.DNICli:SCREEN-VALUE, "CHARACTER") < 8)
     THEN DO:
         MESSAGE "Venta Mayor a 700.00" SKIP
                 "Debe ingresar en DNI"
             VIEW-AS ALERT-BOX ERROR.
         APPLY 'ENTRY':U TO VtaCDocu.DNICli.
         RETURN "ADM-ERROR".   
     END.
     /* VALIDACION DE IMPORTE MINIMO POR COTIZACION */
     DEF VAR pImpMin AS DEC NO-UNDO.
     RUN gn/pMinCotPed (s-CodCia,
                        s-CodDiv,
                        s-CodDoc,
                        OUTPUT pImpMin).
     IF pImpMin > 0 AND f-Bol < pImpMin THEN DO:
         MESSAGE 'El importe mínimo para cotizar es de S/.' pImpMin
             VIEW-AS ALERT-BOX ERROR.
         RETURN "ADM-ERROR".
     END.
    /* OTRAS VALIDACIONES */
     IF VtaCDocu.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '11111111112'
         AND VtaCDocu.FmaPgo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '900' 
         AND VtaCDocu.NroCard:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '' THEN DO:
         MESSAGE "Ingrese el numero de tarjeta" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO VtaCDocu.NroCard.
         RETURN "ADM-ERROR".   
     END.
     IF VtaCDocu.FmaPgo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '900'
         AND VtaCDocu.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> '11111111112'
         AND VtaCDocu.NroCard:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> '' THEN DO:
         MESSAGE "En caso de transferencia gratuita NO es válido el Nº de Tarjeta" 
             VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO VtaCDocu.NroCard.
         RETURN "ADM-ERROR".   
     END.
     IF INPUT VtaCDocu.FchVen < VtaCDocu.fchped THEN DO:
         MESSAGE 'Ingrese correctamente la fecha de vencimiento' VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO VtaCDocu.FchVen.
         RETURN "ADM-ERROR".   
     END.
     /* RHC 17/02/2015 VALIDACION FECHA VENCIMIENTO */
     IF INPUT Vtacdocu.FchVen - INPUT Vtacdocu.fchped > s-DiasVtoCot THEN DO:
         MESSAGE 'La fecha de vencimiento no puede ser mayor a' s-DiasVtoCot 'días' VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO Vtacdocu.FchVen.
         RETURN "ADM-ERROR".
     END.
     IF INPUT Vtacdocu.FchEnt < INPUT Vtacdocu.fchped THEN DO:
         MESSAGE 'Ingrese correctamente la fecha de entrega' VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO Vtacdocu.FchEnt.
         RETURN "ADM-ERROR".   
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

DEFINE VAR RPTA AS CHAR.

IF NOT AVAILABLE VtaCDocu THEN RETURN "ADM-ERROR".
IF LOOKUP(VtaCDocu.FlgEst,"C,A,X") > 0 THEN  RETURN "ADM-ERROR".
IF (VtaCDocu.FlgSit = "S" OR VtaCDocu.FlgSit = "T") THEN RETURN "ADM-ERROR".

IF VtaCDocu.Libre_c05 = '*' THEN DO:
    MESSAGE 'La Atención al Cliente YA FUE CERRADA'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

/* Si tiene atenciones parciales tambien se bloquea */
FIND FIRST VtaDDocu OF VtaCDocu WHERE CanAte > 0 NO-LOCK NO-ERROR.
IF AVAILABLE VtaDDocu 
THEN DO:
    MESSAGE "La Cotización tiene atenciones parciales" SKIP
        "Acceso denegado"
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
/* BLOQUEAR SI SE HA TRABAJADO CON OTRA LISTA DE PRECIOS */
/* IF VtaCDocu.Libre_c01 <> "" AND pCodDiv <> VtaCDocu.Libre_c01 THEN DO:             */
/*     MESSAGE 'NO puede modificar una Cotización generada con otra lista de precios' */
/*         VIEW-AS ALERT-BOX ERROR.                                                   */
/*     RETURN "ADM-ERROR".                                                            */
/* END.                                                                               */
IF pCodDiv <> VtaCDocu.Libre_c01 THEN DO:
    MESSAGE 'NO puede modificar una Cotización generada con otra lista de precios'
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

/* ***************************************************** */

ASSIGN
    S-CODMON = VtaCDocu.CodMon
    S-CODCLI = VtaCDocu.CodCli
    S-TPOCMB = VtaCDocu.TpoCmb
    S-CNDVTA = VtaCDocu.FmaPgo
    s-Copia-Registro = NO
    s-PorIgv = VtaCDocu.porigv
    s-NroDec = (IF VtaCDocu.Libre_d01 <= 0 THEN 4 ELSE VtaCDocu.Libre_d01)
    s-FlgIgv = VtaCDocu.FlgIgv
    s-adm-new-record = "NO"
    s-nroped = VtaCDocu.nroped.

RUN Carga-Temporal.

/* Cargamos las condiciones de venta válidas */
FIND gn-clie WHERE gn-clie.codcia  = cl-codcia
    AND gn-clie.codcli = s-codcli
    NO-LOCK.
RUN vta2/p-fmapgo (s-codcli, s-tpoped, OUTPUT s-cndvta-validos).
/* s-cndvta-validos = '001'.                                                               */
/* IF LOOKUP('400', gn-clie.cndvta) > 0 THEN s-cndvta-validos = s-cndvta-validos + ',400'. */
/* IF LOOKUP('401', gn-clie.cndvta) > 0 THEN s-cndvta-validos = s-cndvta-validos + ',401'. */
/* IF LOOKUP('405', gn-clie.cndvta) > 0 THEN s-cndvta-validos = s-cndvta-validos + ',405'. */
/* IF LOOKUP('002', gn-clie.cndvta) > 0 THEN s-cndvta-validos = s-cndvta-validos + ',002'. */
/* IF LOOKUP('411', gn-clie.cndvta) > 0 THEN s-cndvta-validos = s-cndvta-validos + ',411'. */
/* IF LOOKUP('900', gn-clie.cndvta) > 0 THEN s-cndvta-validos = s-cndvta-validos + ',900'. */

RUN Procesa-Handle IN lh_Handle ('Pagina2').
RUN Procesa-Handle IN lh_Handle ('browse').

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

