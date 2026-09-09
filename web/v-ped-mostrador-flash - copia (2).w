&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE SHARED TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE SHARED TEMP-TABLE ITEM-3 LIKE FacDPedi.
DEFINE TEMP-TABLE PEDI-3 NO-UNDO LIKE FacDPedi.



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

&SCOPED-DEFINE ARITMETICA-SUNAT YES

&SCOPED-DEFINE Promocion vta2/promocion-generalv2.p

&SCOPED-DEFINE precio-venta-general web/PrecioFinalContadoMayorista.p

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
DEF SHARED VAR S-FLGSIT AS CHAR.
DEF SHARED VAR s-NroPed AS CHAR.
DEF SHARED VAR s-adm-new-record AS CHAR.
DEF SHARED VAR s-FlgEmpaque LIKE gn-divi.FlgEmpaque.
DEF SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEF SHARED VAR s-FlgMinVenta AS LOG.
DEF SHARED VAR s-FmaPgo AS CHAR.
DEF SHARED VAR s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.
DEF SHARED VAR s-Sunat-Activo AS LOG.
DEF SHARED VAR s-Cmpbnte AS CHAR.

DEF SHARED TEMP-TABLE T-DPEDI LIKE FacDPedi.

DEF VAR s-FlgEnv AS LOG.
DEF VAR s-copia-registro AS LOG.
DEF VAR F-Observa        AS CHAR.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE VAR x-ClientesVarios AS CHAR.
x-ClientesVarios = FacCfgGn.CliVar.     /* 11 digitos */

/* Variables para los mensajes de error */
DEF VAR pMensaje AS CHAR NO-UNDO.

DEF TEMP-TABLE ResumenxLinea
    FIELD codmat LIKE almmmatg.codmat
    FIELD codfam LIKE almmmatg.codfam
    FIELD subfam LIKE almmmatg.subfam
    FIELD canped LIKE facdpedi.canped
    INDEX Llave01 AS PRIMARY /*UNIQUE*/ codmat codfam subfam.

DEF TEMP-TABLE ErroresxLinea LIKE ResumenxLinea.

DEF VAR ImpMinPercep AS DEC INIT 1500 NO-UNDO.
DEF VAR ImpMinDNI    AS DEC INIT 700 NO-UNDO.

DEF TEMP-TABLE T-COMPONENTE LIKE Facdpedi
    FIELD Componente AS CHAR
    FIELD Kits       AS INT.

/* ICBPER */
DEFINE VAR x-articulo-ICBPER AS CHAR.

x-articulo-ICBPER = '099268'.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\Coti.ico" SIZE 12 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

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
&Scoped-define EXTERNAL-TABLES FacCPedi
&Scoped-define FIRST-EXTERNAL-TABLE FacCPedi


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR FacCPedi.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS FacCPedi.FlgSit FacCPedi.fchven ~
FacCPedi.CodCli FacCPedi.RucCli FacCPedi.Atencion FacCPedi.NomCli ~
FacCPedi.ordcmp FacCPedi.DirCli FacCPedi.Cmpbnte FacCPedi.LugEnt ~
FacCPedi.CodMon FacCPedi.NroCard FacCPedi.TpoCmb FacCPedi.CodVen ~
FacCPedi.FlgIgv FacCPedi.FmaPgo FacCPedi.Libre_d01 FacCPedi.Glosa ~
FacCPedi.CodRef FacCPedi.NroRef 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.FchPed ~
FacCPedi.FlgSit FacCPedi.fchven FacCPedi.CodCli FacCPedi.RucCli ~
FacCPedi.Atencion FacCPedi.usuario FacCPedi.NomCli FacCPedi.ordcmp ~
FacCPedi.DirCli FacCPedi.Cmpbnte FacCPedi.LugEnt FacCPedi.CodMon ~
FacCPedi.NroCard FacCPedi.TpoCmb FacCPedi.CodVen FacCPedi.FlgIgv ~
FacCPedi.FmaPgo FacCPedi.Libre_d01 FacCPedi.Glosa FacCPedi.CodRef ~
FacCPedi.NroRef 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS F-Estado F-Nomtar f-NomVen F-CndVta 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSoloLetras V-table-Win 
FUNCTION getSoloLetras RETURNS LOGICAL
  ( INPUT pTexto AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE F-CndVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 70 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "ESTADO" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE F-Nomtar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 66 BY .81 NO-UNDO.

DEFINE VARIABLE f-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 70 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.NroPed AT ROW 1.27 COL 16 COLON-ALIGNED WIDGET-ID 58
          LABEL "Número" FORMAT "XXX-XXXXXXXX"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     F-Estado AT ROW 1.27 COL 39 COLON-ALIGNED WIDGET-ID 114
     FacCPedi.FchPed AT ROW 1.27 COL 109 COLON-ALIGNED WIDGET-ID 46
          LABEL "Fecha de Emisión"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.FlgSit AT ROW 2.08 COL 18 NO-LABEL WIDGET-ID 120
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Efectivo", "",
"Tarjeta de Crédito", "T":U
          SIZE 25 BY .81
          BGCOLOR 8 FGCOLOR 0 
     FacCPedi.fchven AT ROW 2.08 COL 109 COLON-ALIGNED WIDGET-ID 48 FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.CodCli AT ROW 2.88 COL 16 COLON-ALIGNED WIDGET-ID 38
          LABEL "Cliente"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.RucCli AT ROW 2.88 COL 39 COLON-ALIGNED WIDGET-ID 60
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.Atencion AT ROW 2.88 COL 59 COLON-ALIGNED WIDGET-ID 88
          LABEL "DNI" FORMAT "X(11)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.usuario AT ROW 2.88 COL 109 COLON-ALIGNED WIDGET-ID 66
          LABEL "Digitado por"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.NomCli AT ROW 3.69 COL 16 COLON-ALIGNED WIDGET-ID 54 FORMAT "x(256)"
          VIEW-AS FILL-IN 
          SIZE 76 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.ordcmp AT ROW 3.69 COL 109 COLON-ALIGNED WIDGET-ID 118
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
          FGCOLOR 0 
     FacCPedi.DirCli AT ROW 4.5 COL 16 COLON-ALIGNED WIDGET-ID 44
          LABEL "Dirección" FORMAT "x(256)"
          VIEW-AS FILL-IN 
          SIZE 76 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.Cmpbnte AT ROW 4.5 COL 111 NO-LABEL WIDGET-ID 102
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Factura", "FAC":U,
"Boleta", "BOL":U
          SIZE 17 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.LugEnt AT ROW 5.31 COL 16 COLON-ALIGNED WIDGET-ID 112
          LABEL "Lugar de entrega" FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 76 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.CodMon AT ROW 5.31 COL 111 NO-LABEL WIDGET-ID 78
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dólares", 2
          SIZE 15 BY .81
     FacCPedi.NroCard AT ROW 6.12 COL 16 COLON-ALIGNED WIDGET-ID 56
          LABEL "Tarjeta"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 FGCOLOR 0 
     F-Nomtar AT ROW 6.12 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 92
     FacCPedi.TpoCmb AT ROW 6.12 COL 109 COLON-ALIGNED WIDGET-ID 64
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FacCPedi.CodVen AT ROW 6.92 COL 16 COLON-ALIGNED WIDGET-ID 42
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
          BGCOLOR 11 FGCOLOR 0 
     f-NomVen AT ROW 6.92 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 94
     FacCPedi.FlgIgv AT ROW 6.92 COL 111 WIDGET-ID 116
          LABEL "Afecto a IGV"
          VIEW-AS TOGGLE-BOX
          SIZE 12 BY .77
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     FacCPedi.FmaPgo AT ROW 7.73 COL 16 COLON-ALIGNED WIDGET-ID 50
          LABEL "Condición de Venta"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     F-CndVta AT ROW 7.73 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 90
     FacCPedi.Libre_d01 AT ROW 7.73 COL 111 NO-LABEL WIDGET-ID 96
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "2", 2,
"3", 3,
"4", 4
          SIZE 12 BY .81
     FacCPedi.Glosa AT ROW 8.54 COL 16 COLON-ALIGNED WIDGET-ID 110
          LABEL "Glosa" FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 76 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.CodRef AT ROW 8.54 COL 109 COLON-ALIGNED WIDGET-ID 126
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FacCPedi.NroRef AT ROW 8.54 COL 115 COLON-ALIGNED NO-LABEL WIDGET-ID 128
          VIEW-AS FILL-IN 
          SIZE 11 BY .81 TOOLTIP "XXX-XXXXXX"
     "Comprobante:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 4.77 COL 101 WIDGET-ID 106
     "Redondedo del P.U.:" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 8 COL 96 WIDGET-ID 100
     "Cancela con:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 2.35 COL 8 WIDGET-ID 124
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 5.58 COL 105 WIDGET-ID 84
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.FacCPedi
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
      TABLE: B-DPEDI B "?" ? INTEGRAL FacDPedi
      TABLE: ITEM T "SHARED" ? INTEGRAL FacDPedi
      TABLE: ITEM-3 T "SHARED" ? INTEGRAL FacDPedi
      TABLE: PEDI-3 T "?" NO-UNDO INTEGRAL FacDPedi
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
         HEIGHT             = 9.46
         WIDTH              = 136.
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

/* SETTINGS FOR FILL-IN FacCPedi.Atencion IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.DirCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Nomtar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FchPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.fchven IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR TOGGLE-BOX FacCPedi.FlgIgv IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FmaPgo IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.Glosa IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.LugEnt IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.NomCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN FacCPedi.NroCard IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.usuario IN FRAME F-Main
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

&Scoped-define SELF-NAME FacCPedi.Cmpbnte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.Cmpbnte V-table-Win
ON VALUE-CHANGED OF FacCPedi.Cmpbnte IN FRAME F-Main /* Tipo Comprobante */
DO:
    DO WITH FRAM {&FRAME-NAME}:
/*         IF SELF:SCREEN-VALUE = 'FAC' THEN DO:                     */
/*             FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA         */
/*                 AND gn-clie.CodCli = FacCPedi.CodCli:SCREEN-VALUE */
/*                 NO-LOCK NO-ERROR.                                 */
/*             ASSIGN                                                */
/*                 FacCPedi.DirCli:SENSITIVE = NO                    */
/*                 FacCPedi.NomCli:SENSITIVE = NO                    */
/*                 FacCPedi.Atencion:SENSITIVE = NO.                 */
/*             IF AVAILABLE gn-clie THEN DO:                         */
/*                 ASSIGN                                            */
/*                     FacCPedi.DirCli:SCREEN-VALUE = GN-CLIE.DirCli */
/*                     FacCPedi.NomCli:SCREEN-VALUE = GN-CLIE.NomCli */
/*                     FacCPedi.RucCli:SCREEN-VALUE = gn-clie.Ruc.   */
/*             END.                                                  */
/*         END.                                                      */
/*         ELSE DO:                                                  */
/*             ASSIGN                                                */
/*                 FacCPedi.DirCli:SENSITIVE = YES                   */
/*                 FacCPedi.NomCli:SENSITIVE = YES                   */
/*                 FacCPedi.Atencion:SENSITIVE = YES.                */
/*             /* RHC 11/03/2019 CLIENTE CON RUC */                  */
/*             IF FacCPedi.RucCli:SCREEN-VALUE > '' THEN             */
/*                 ASSIGN                                            */
/*                     FacCPedi.DirCli:SENSITIVE = NO                */
/*                     FacCPedi.NomCli:SENSITIVE = NO                */
/*                     FacCPedi.Atencion:SENSITIVE = NO.             */
/*         END.                                                      */
        s-Cmpbnte = SELF:SCREEN-VALUE.
    END.

 /* Ic - 13Ago2020 */
  IF TRIM(Faccpedi.CodCli:SCREEN-VALUE) = x-ClientesVarios  THEN DO:
      Faccpedi.nomcli:SENSITIVE = YES.
      Faccpedi.dircli:SENSITIVE = YES.
      /*Faccpedi.atencion:SENSITIVE = NO.*/
  END.
  ELSE DO:
      Faccpedi.nomcli:SENSITIVE = NO.
      Faccpedi.dircli:SENSITIVE = NO.
      /*Faccpedi.atencion:SENSITIVE = NO.*/
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodCli V-table-Win
ON LEAVE OF FacCPedi.CodCli IN FRAME F-Main /* Cliente */
DO:
  Faccpedi.CodCli:SCREEN-VALUE = REPLACE(Faccpedi.CodCli:SCREEN-VALUE,".","").
  Faccpedi.CodCli:SCREEN-VALUE = REPLACE(Faccpedi.CodCli:SCREEN-VALUE,",","").

  IF Faccpedi.CodCli:SCREEN-VALUE = "" THEN RETURN.

  /* Verificar la Longuitud */
  DEFINE VAR x-data AS CHAR.
  x-data = TRIM(Faccpedi.CodCli:SCREEN-VALUE).
  IF LENGTH(x-data) < 11 THEN DO:
      x-data = FILL("0", 11 - LENGTH(x-data)) + x-data.
  END.

  Faccpedi.CodCli:SCREEN-VALUE = x-data.
  /**/

  S-CODCLI = SELF:SCREEN-VALUE.

  FIND FIRST gn-clie WHERE gn-clie.CodCia = CL-CODCIA
      AND  gn-clie.CodCli = SELF:SCREEN-VALUE 
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN DO:      /* CREA EL CLIENTE NUEVO */
      S-CODCLI = SELF:SCREEN-VALUE.
      RUN vtamay/d-regcli (INPUT-OUTPUT S-CODCLI).
      IF TRUE <> (S-CODCLI > "") THEN DO:
          APPLY "ENTRY" TO Faccpedi.CodCli.
          RETURN NO-APPLY.
      END.
      FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
          AND  gn-clie.CodCli = S-CODCLI 
          NO-LOCK NO-ERROR.
      SELF:SCREEN-VALUE = s-codcli.
  END.
  /* **************************************** */
  /* RHC 22/07/2020 Nuevo bloqueo de clientes */
  /* **************************************** */
  RUN pri/p-verifica-cliente (INPUT gn-clie.codcli,
                              INPUT s-CodDoc,
                              INPUT s-CodDiv).
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  /* **************************************** */
  /* 13/05/2022: Verificar configuración del cliente */
  FIND VtaTabla WHERE VtaTabla.CodCia = s-CodCia
      AND VtaTabla.Tabla = 'CN-GN'
      AND VtaTabla.Llave_c1 =  Gn-Clie.Canal
      AND VtaTabla.Llave_c2 =  Gn-Clie.GirCli
      NO-LOCK NO-ERROR.
  IF AVAILABLE VtaTabla AND VtaTabla.Libre_c01 = "SI" THEN DO:
      MESSAGE 'El cliente pertenece a una institucion PUBLICA' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FacCPedi.CodCli.
      RETURN NO-APPLY.
  END.
  s-CodCli = SELF:SCREEN-VALUE.
  /* *********************************************** */
  DISPLAY 
      gn-clie.NomCli  WHEN s-codcli <> x-ClientesVarios @ Faccpedi.NomCli
      gn-clie.Ruc     WHEN s-codcli <> x-ClientesVarios @ Faccpedi.RucCli
      gn-clie.Dni     WHEN s-codcli <> x-ClientesVarios @ Faccpedi.Atencion
      gn-clie.DirCli  WHEN s-codcli <> x-ClientesVarios @ Faccpedi.DirCli
      s-CndVta                                          @ FacCPedi.FmaPgo
      gn-clie.NroCard WHEN s-codcli <> x-ClientesVarios @ FacCPedi.NroCard
      WITH FRAME {&FRAME-NAME}.
  /* Tarjeta */
  FIND FIRST Gn-Card WHERE Gn-Card.NroCard = gn-clie.nrocard NO-LOCK NO-ERROR.
  IF AVAILABLE GN-CARD 
  THEN ASSIGN
            F-NomTar:SCREEN-VALUE = GN-CARD.NomClie[1]
            FacCPedi.NroCard:SENSITIVE = NO.
  ELSE ASSIGN
            F-NomTar:SCREEN-VALUE = ''
            FacCPedi.NroCard:SENSITIVE = YES.

  IF x-ClientesVarios = SELF:SCREEN-VALUE THEN DO:
      Faccpedi.NomCli:SCREEN-VALUE = gn-clie.NomCli.
  END.
      
  /* Ubica la Condicion Venta */
  FIND FIRST gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
  ELSE F-CndVta:SCREEN-VALUE = "".

  /* Vendedor */
  F-NomVen:SCREEN-VALUE = "".
  FIND FIRST gn-ven WHERE gn-ven.CodCia = S-CODCIA 
      AND  gn-ven.CodVen = FacCPedi.CodVen:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-ven THEN F-NomVen:SCREEN-VALUE = gn-ven.NomVen.

  /* Si tiene RUC o Cliente Varios, Blanquear el DNI */
  DO WITH FRAME {&FRAME-NAME} :
      IF TRIM(Faccpedi.CodCli:SCREEN-VALUE) = x-ClientesVarios  OR 
          Faccpedi.ruccli:SCREEN-VALUE IN FRAME {&FRAME-NAME} > "" THEN DO:
          Faccpedi.atencion:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
      END.

      IF TRIM(Faccpedi.CodCli:SCREEN-VALUE) = x-ClientesVarios  THEN DO:
          Faccpedi.nomcli:SENSITIVE = YES.
          Faccpedi.dircli:SENSITIVE = YES.
          /*Faccpedi.atencion:SENSITIVE = NO.*/
      END.
      ELSE DO:
          Faccpedi.nomcli:SENSITIVE = NO.
          Faccpedi.dircli:SENSITIVE = NO.
          /*Faccpedi.atencion:SENSITIVE = NO.*/
      END.
  END.

  /* Determina si es boleta o factura */
  IF TRUE <> (FacCPedi.RucCli:SCREEN-VALUE > '') THEN Faccpedi.Cmpbnte:SCREEN-VALUE = 'BOL'.
  ELSE Faccpedi.Cmpbnte:SCREEN-VALUE = 'FAC'.

  APPLY 'VALUE-CHANGED' TO Faccpedi.Cmpbnte.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodCli V-table-Win
ON LEFT-MOUSE-DBLCLICK OF FacCPedi.CodCli IN FRAME F-Main /* Cliente */
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''.
    IF s-TpoPed = "M" THEN input-var-1 = "006".
    RUN vtagn/c-gn-clie-01 ('Clientes').
    IF output-var-1 <> ? THEN FacCPedi.CodCli:SCREEN-VALUE = output-var-2.
    /*APPLY 'ENTRY':U TO FacCPedi.CodCli.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodMon V-table-Win
ON VALUE-CHANGED OF FacCPedi.CodMon IN FRAME F-Main /* Cod!mon */
DO:
  S-CODMON = INTEGER(Faccpedi.CodMon:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodVen V-table-Win
ON LEAVE OF FacCPedi.CodVen IN FRAME F-Main /* Vendedor */
DO:
  F-NomVen:SCREEN-VALUE = "".
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
    AND  gn-ven.CodVen = FacCPedi.CodVen:SCREEN-VALUE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodVen V-table-Win
ON LEFT-MOUSE-DBLCLICK OF FacCPedi.CodVen IN FRAME F-Main /* Vendedor */
OR F8 OF Faccpedi.CodVen
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''.
    RUN lkup/c-vende ('Vendedor').
    IF output-var-1 <> ? THEN FacCPedi.CodVen:SCREEN-VALUE = output-var-2.
    /*APPLY 'ENTRY':U TO FacCPedi.CodVen.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.FlgIgv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FlgIgv V-table-Win
ON VALUE-CHANGED OF FacCPedi.FlgIgv IN FRAME F-Main /* Afecto a IGV */
DO:
    s-FlgIgv = INPUT {&self-name}.
    IF s-FlgIgv = YES THEN s-PorIgv = FacCfgGn.PorIgv.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.FlgSit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FlgSit V-table-Win
ON VALUE-CHANGED OF FacCPedi.FlgSit IN FRAME F-Main /* Situaci¾n */
DO:
  IF s-FlgSit <> SELF:SCREEN-VALUE THEN DO:
      s-FlgSit = SELF:SCREEN-VALUE.
      RUN Procesa-Handle IN lh_Handle ('Recalculo').
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.Libre_d01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.Libre_d01 V-table-Win
ON VALUE-CHANGED OF FacCPedi.Libre_d01 IN FRAME F-Main /* Libre_d01 */
DO:
    s-NroDec = INTEGER(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.NroCard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.NroCard V-table-Win
ON LEAVE OF FacCPedi.NroCard IN FRAME F-Main /* Tarjeta */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.NroCard V-table-Win
ON LEFT-MOUSE-DBLCLICK OF FacCPedi.NroCard IN FRAME F-Main /* Tarjeta */
OR F8 OF Faccpedi.NroCard
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''.
    RUN lkup/c-gncard ('Tarjetas').
    IF output-var-1 <> ? THEN FacCPedi.NroCard:SCREEN-VALUE = output-var-2.
    /*APPLY 'ENTRY':U TO FacCPedi.NroCard.*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE actualiza-prepedido V-table-Win 
PROCEDURE actualiza-prepedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ACTUALIZA LA COTIZACION EN BASE AL PEDIDO AL CREDITO */

  DEFINE INPUT PARAMETER pRowid AS ROWID.
  DEFINE INPUT PARAMETER pFactor AS INT.    /* +1 actualiza    -1 desactualiza */
  DEFINE OUTPUT PARAMETER pError AS CHAR NO-UNDO.

  DEFINE VARIABLE I-NRO AS INTEGER INIT 0 NO-UNDO.

  DEFINE BUFFER B-DPEDI FOR FacDPedi.
  DEFINE BUFFER B-CPEDI FOR FacCPedi.

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND B-CPedi WHERE B-CPedi.CodCia = FacCPedi.CodCia
          AND  B-CPedi.CodDiv = FacCPedi.CodDiv
          AND  B-CPedi.CodDoc = FacCPedi.CodRef
          AND  B-CPedi.NroPed = FacCPedi.NroRef
          EXCLUSIVE-LOCK NO-ERROR.
      IF pFactor = +1 THEN ASSIGN B-CPedi.FlgEst = "C".
      ELSE B-CPedi.FlgEst = "P".
  END.
  RETURN 'OK'.

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
  {src/adm/template/row-list.i "FacCPedi"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "FacCPedi"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

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

  DEF INPUT PARAMETER p-Ok AS LOG.
  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  DEFINE BUFFER DETALLE FOR FacDPedi.
  DEF VAR pCuenta AS INTE NO-UNDO.
  
  RLOOP:
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      /* Borramos detalle */
      FOR EACH Facdpedi OF Faccpedi NO-LOCK:
          FIND DETALLE WHERE ROWID(DETALLE) = ROWID(Facdpedi) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
          IF ERROR-STATUS:ERROR = YES THEN DO:
              {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
              UNDO RLOOP, RETURN 'ADM-ERROR'.
          END.
          /* EXTORNAMOS SALDO EN LAS COTIZACIONES */
          IF Faccpedi.CodRef = "C/M" THEN DO:
              FIND B-DPEDI WHERE B-DPEDI.CodCia = Faccpedi.CodCia 
                  AND  B-DPEDI.CodDiv = Faccpedi.CodDiv
                  AND  B-DPEDI.CodDoc = Faccpedi.CodRef 
                  AND  B-DPEDI.NroPed = Faccpedi.NroRef
                  AND  B-DPEDI.CodMat = Facdpedi.CodMat 
                  EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
              IF AVAILABLE B-DPEDI 
              THEN ASSIGN
                    B-DPEDI.FlgEst = 'P'
                    B-DPEDI.CanAte = B-DPEDI.CanAte - Facdpedi.CanPed.  /* <<<< OJO <<<< */
          END.
          /* */
          IF p-Ok = YES THEN DELETE DETALLE.
          ELSE DETALLE.FlgEst = 'A'.   /* <<< OJO <<< */
      END.
      IF Faccpedi.CodRef > '' AND Faccpedi.NroRef > '' THEN DO:
          FIND B-CPedi WHERE 
               B-CPedi.CodCia = S-CODCIA AND  
               B-CPedi.CodDiv = S-CODDIV AND  
               B-CPedi.CodDoc = Faccpedi.CodRef AND  
               B-CPedi.NroPed = Faccpedi.NroRef
               EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
          IF AVAILABLE B-CPedi THEN B-CPedi.FlgEst = "P".
      END.
  END.
  IF AVAILABLE(DETALLE) THEN RELEASE DETALLE.
  IF AVAILABLE(B-DPEDI) THEN RELEASE B-DPEDI.
  IF AVAILABLE(B-CPEDI) THEN RELEASE B-CPEDI.

  RETURN "OK".

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

    EMPTY TEMP-TABLE ITEM.

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

EMPTY TEMP-TABLE ITEM.

DEF VAR LogRecalcular AS LOG INIT NO NO-UNDO.

/* ARTIFICIO */
Fi-Mensaje = "RECALCULANDO PRECIOS".
DISPLAY Fi-Mensaje WITH FRAME F-Proceso.

FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.Libre_c05 <> 'OF':
    CREATE ITEM.
    BUFFER-COPY Facdpedi TO ITEM.

    LogRecalcular = NO.
    /* 01/08/2022: Limpiamos descuentos finales */
    IF Facdpedi.Libre_c04 > '' THEN DO:
        LogRecalcular = YES.
        ASSIGN
            ITEM.Por_Dsctos[1] = 0
            ITEM.Por_Dsctos[2] = 0
            ITEM.Por_Dsctos[3] = 0
            ITEM.Libre_c04 = "".
    END.
    IF ITEM.Libre_d03 > 0 THEN DO:
        LogRecalcular = YES.
        ASSIGN
            ITEM.Por_Dsctos[1] = 0
            ITEM.Por_Dsctos[2] = 0
            ITEM.Por_Dsctos[3] = 0
            ITEM.CanPed = ITEM.CanPed - ITEM.Libre_d03
            ITEM.Libre_d03 = 0.
    END.
    IF LogRecalcular = YES THEN DO:
        /* ***************************************************************** */
        RUN Recalcular-Item.
        /* ***************************************************************** */
    END.
    IF ITEM.CanPed <= 0 THEN DELETE ITEM.
END.
HIDE FRAME f-Proceso.

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

    EMPTY TEMP-TABLE ITEM.
    FOR EACH FacdPedi OF FaccPedi NO-LOCK WHERE Facdpedi.Libre_c05 <> 'OF':
        CREATE ITEM.
        BUFFER-COPY FacDPedi EXCEPT FacDPedi.Libre_c01 TO ITEM ASSIGN ITEM.CanAte = 0.
        IF ITEM.Libre_d03 > 0 THEN DO:
            ASSIGN
                ITEM.Por_Dsctos[1] = 0
                ITEM.Por_Dsctos[2] = 0
                ITEM.Por_Dsctos[3] = 0
                ITEM.CanPed = ITEM.CanPed - ITEM.Libre_d03
                ITEM.Libre_d03 = 0
                .
        END.
        IF ITEM.CanPed <= 0 THEN DELETE ITEM.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CREATE-TRANSACION V-table-Win 
PROCEDURE CREATE-TRANSACION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR i-Cuenta AS INTE NO-UNDO.

PRINCIPAL:                                                                                  
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {vta2/icorrelativosecuencial.i &Codigo = s-coddoc &Serie = s-nroser}
    ASSIGN 
        FacCPedi.CodCia = S-CODCIA
        FacCPedi.CodDiv = S-CODDIV
        FacCPedi.CodDoc = s-coddoc 
        FacCPedi.CodAlm = s-CodAlm    /* Lista de Almacenes Válidos de Venta */
        FacCPedi.FchPed = TODAY 
        FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        FacCPedi.TpoPed = s-TpoPed
        FacCPedi.FlgEst = (IF Faccpedi.CodCli BEGINS "SYS" THEN "I" ELSE "P")     /* PENDIENTE */
        FacCPedi.Libre_c01        = s-CodDiv      /* OJO */
        FacCPedi.Lista_de_Precios = s-CodDiv      /* OJO */
        NO-ERROR
        .
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="i-Cuenta"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    RELEASE FacCorre.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DESCUENTOS-FINALES V-table-Win 
PROCEDURE DESCUENTOS-FINALES :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  /* ************************************************************************************** */
  /* DESCUENTOS APLICADOS A TODA LA COTIZACION */
  /* ************************************************************************************** */
  DEF VAR hProc AS HANDLE NO-UNDO.
  RUN vtagn/ventas-library PERSISTENT SET hProc.
  RUN DCTO_VOL_LINEA IN hProc (INPUT ROWID(Faccpedi),
                               INPUT s-TpoPed,
                               INPUT s-CodDiv,
                               OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN DCTO_VOL_SALDO IN hProc (INPUT ROWID(Faccpedi),
                               INPUT s-TpoPed,
                               INPUT s-CodDiv,
                               OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN DCTO_IMP_ACUM IN hProc (INPUT ROWID(Faccpedi),
                              INPUT s-CodDiv,
                              OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  DELETE PROCEDURE hProc.

  RETURN 'OK'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Excel V-table-Win 
PROCEDURE Genera-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&IF {&ARITMETICA-SUNAT} &THEN
RUN Genera-Excel-Sunat.
&ELSE
RUN Genera-Excel-Normal.
&ENDIF


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Excel-Normal V-table-Win 
PROCEDURE Genera-Excel-Normal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 10.
DEFINE VARIABLE x-item                  AS INTEGER .
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.

DEFINE VARIABLE x-desmon                AS CHARACTER.
DEFINE VARIABLE x-enletras              AS CHARACTER.

RUN bin/_numero(FacCPedi.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF FacCPedi.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").
X-desmon = (IF FacCPedi.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 4.
chWorkSheet:Columns("B"):ColumnWidth = 6.
chWorkSheet:Columns("C"):ColumnWidth = 45.
chWorkSheet:Columns("D"):ColumnWidth = 15.
chWorkSheet:Columns("E"):ColumnWidth = 8.
chWorkSheet:Columns("F"):ColumnWidth = 20.
chWorkSheet:Columns("G"):ColumnWidth = 20.
chWorkSheet:Columns("H"):ColumnWidth = 20.

chWorkSheet:Columns("A:A"):NumberFormat = "0".
chWorkSheet:Columns("B:B"):NumberFormat = "@".
chWorkSheet:Columns("C:C"):NumberFormat = "@".
chWorkSheet:Columns("D:D"):NumberFormat = "@".
chWorkSheet:Columns("E:E"):NumberFormat = "@".
chWorkSheet:Columns("F:F"):NumberFormat = "0.0000".
chWorkSheet:Columns("G:G"):NumberFormat = "0.00".
chWorkSheet:Columns("H:H"):NumberFormat = "0.00".

chWorkSheet:Range("A10:H10"):Font:Bold = TRUE.
chWorkSheet:Range("A10"):Value = "Item".
chWorkSheet:Range("B10"):Value = "Codigo".
chWorkSheet:Range("C10"):Value = "Descripcion".
chWorkSheet:Range("D10"):Value = "Marca".
chWorkSheet:Range("E10"):Value = "Unidad".
chWorkSheet:Range("F10"):Value = "Precio".
chWorkSheet:Range("G10"):Value = "Cantidad".
chWorkSheet:Range("H10"):Value = "Importe".

chWorkSheet:Range("A2"):Value = "Pedido No : " + FacCPedi.NroPed.
chWorkSheet:Range("A3"):Value = "Fecha     : " + STRING(FacCPedi.FchPed,"99/99/9999").
chWorkSheet:Range("A4"):Value = "Cliente   : " + FacCPedi.Codcli + " " + FacCPedi.Nomcli.
chWorkSheet:Range("A5"):Value = "Vendedor  : " + FacCPedi.CodVen + " " + F-Nomven:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
chWorkSheet:Range("A6"):Value = "Moneda    : " + x-desmon.

FOR EACH FacDPedi OF FacCPedi :
    x-item  = x-item + 1.
    FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                        Almmmatg.CodMat = FacDPedi.CodMat
                        NO-LOCK NO-ERROR.
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = x-item.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = FacDPedi.codmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = FacDPedi.undvta.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = FacDPedi.preuni.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = FacDPedi.canped.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = FacDPedi.implin.

END.

iColumn = iColumn + 2.                           
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "SON : " + x-enletras.

iColumn = iColumn + 2.                           
cColumn = STRING(iColumn).
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = FacCPedi.imptot.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Excel-Sunat V-table-Win 
PROCEDURE Genera-Excel-Sunat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 10.
DEFINE VARIABLE x-item                  AS INTEGER .
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.

DEFINE VARIABLE x-desmon                AS CHARACTER.
DEFINE VARIABLE x-enletras              AS CHARACTER.

RUN bin/_numero(FacCPedi.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF FacCPedi.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").
X-desmon = (IF FacCPedi.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 4.
chWorkSheet:Columns("B"):ColumnWidth = 6.
chWorkSheet:Columns("C"):ColumnWidth = 45.
chWorkSheet:Columns("D"):ColumnWidth = 15.
chWorkSheet:Columns("E"):ColumnWidth = 8.
chWorkSheet:Columns("F"):ColumnWidth = 20.
chWorkSheet:Columns("G"):ColumnWidth = 20.
chWorkSheet:Columns("H"):ColumnWidth = 20.
chWorkSheet:Columns("I"):ColumnWidth = 20.

chWorkSheet:Columns("A:A"):NumberFormat = "0".
chWorkSheet:Columns("B:B"):NumberFormat = "@".
chWorkSheet:Columns("C:C"):NumberFormat = "@".
chWorkSheet:Columns("D:D"):NumberFormat = "@".
chWorkSheet:Columns("E:E"):NumberFormat = "@".
chWorkSheet:Columns("F:F"):NumberFormat = "0.0000".
chWorkSheet:Columns("G:G"):NumberFormat = "0.00".
chWorkSheet:Columns("H:H"):NumberFormat = "0.00".
chWorkSheet:Columns("I:I"):NumberFormat = "0.00".

chWorkSheet:Range("A10:H10"):Font:Bold = TRUE.
chWorkSheet:Range("A10"):Value = "Item".
chWorkSheet:Range("B10"):Value = "Codigo".
chWorkSheet:Range("C10"):Value = "Descripcion".
chWorkSheet:Range("D10"):Value = "Marca".
chWorkSheet:Range("E10"):Value = "Unidad".
chWorkSheet:Range("F10"):Value = "Precio".
chWorkSheet:Range("G10"):Value = "Cantidad".
chWorkSheet:Range("H10"):Value = "% Descuento".
chWorkSheet:Range("I10"):Value = "Importe".

chWorkSheet:Range("A2"):Value = "Pedido No : " + FacCPedi.NroPed.
chWorkSheet:Range("A3"):Value = "Fecha     : " + STRING(FacCPedi.FchPed,"99/99/9999").
chWorkSheet:Range("A4"):Value = "Cliente   : " + FacCPedi.Codcli + " " + FacCPedi.Nomcli.
chWorkSheet:Range("A5"):Value = "Vendedor  : " + FacCPedi.CodVen + " " + F-Nomven:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
chWorkSheet:Range("A6"):Value = "Moneda    : " + x-desmon.

FOR EACH FacDPedi OF FacCPedi :
    x-item  = x-item + 1.
    FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                        Almmmatg.CodMat = FacDPedi.CodMat
                        NO-LOCK NO-ERROR.
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = x-item.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = FacDPedi.codmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = FacDPedi.undvta.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = FacDPedi.ImporteUnitarioConImpuesto.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = FacDPedi.canped.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = FacDPedi.FactorDescuento * 100.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = FacDPedi.implin.

END.

iColumn = iColumn + 2.                           
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "SON : " + x-enletras.

iColumn = iColumn + 2.                           
cColumn = STRING(iColumn).
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = FacCPedi.imptot.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Pedido V-table-Win 
PROCEDURE Genera-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.
  DEFINE VARIABLE f-Factor AS DEC NO-UNDO.
  DEFINE VARIABLE x-CanPed AS DEC NO-UNDO.
  DEFINE VARIABLE s-StkComprometido AS DEC.
  DEFINE VARIABLE s-StkDis AS DEC NO-UNDO.

  DEF VAR f-PreBas AS DEC NO-UNDO.
  DEF VAR f-PreVta AS DEC NO-UNDO.
  DEF VAR f-Dsctos AS DEC NO-UNDO.
  DEF VAR y-Dsctos AS DEC NO-UNDO.
  DEF VAR SW-LOG1  AS LOGI NO-UNDO.
  DEF VAR x-StkAct AS DEC NO-UNDO.

  /* POR CADA ITEM VOLVEMOS A VERIFICAR EL STOCK DISPONIBLE
    SI NO HAY STOCK RECALCULAMOS EL PRECIO DE VENTA */
  /* Borramos data sobrante */
  FOR EACH ITEM EXCLUSIVE-LOCK WHERE ITEM.CanPed <= 0:
      DELETE ITEM.
  END.

  /* RHC 05/05/2014 nueva rutina de promociones */
  RUN {&Promocion} (Faccpedi.CodDiv, Faccpedi.CodCli, INPUT-OUTPUT TABLE ITEM, OUTPUT pMensaje).
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* ********************* */
  EMPTY TEMP-TABLE ITEM-3.

  DETALLE:
  FOR EACH ITEM EXCLUSIVE-LOCK WHERE ITEM.codmat <> x-articulo-ICBPER, 
      FIRST Almmmatg OF ITEM NO-LOCK  
      BY ITEM.NroItm : 
      ASSIGN
          ITEM.Libre_d01 = ITEM.CanPed.
      /* RUTINA QUE VERIFICA NUEVAMENTE EL STOCK DISPONIBLE Y AJUSTA LA CANTIDAD EN CASO NECESARIO */
      f-Factor = ITEM.Factor.
      RUN gn/Stock-Comprometido-v2 (ITEM.CodMat, ITEM.AlmDes, YES, OUTPUT s-StkComprometido).

      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = ITEM.AlmDes
          AND Almmmate.codmat = ITEM.CodMat
          NO-LOCK NO-ERROR .
      IF NOT AVAILABLE Almmmate THEN DO:
          pMensaje = "Código " + ITEM.CodMat + " No registrado en el almacén " + ITEM.almdes  + CHR(10) + ~
              "Proceso abortado".
          RETURN "ADM-ERROR".
      END.
      x-StkAct = Almmmate.StkAct.
      s-StkDis = x-StkAct - s-StkComprometido.

      IF s-StkDis < 0 THEN s-StkDis = 0.    /* *** OJO *** */
      x-CanPed = ITEM.CanPed * f-Factor.

      IF s-coddiv = '00506' THEN DO:
          IF s-StkDis < x-CanPed THEN DO:
              RETURN "ADM-ERROR".
          END.
      END.
      
      IF s-StkDis < x-CanPed THEN DO:
          /* RHC 15.08.2014 SOLO PARA PROMOCIONES */
          IF ITEM.Libre_C05 = "OF" THEN DO:
              pMensaje = 'NO hay stock disponible para la promoción: ' + ITEM.codmat + ' '  + Almmmatg.desmat + CHR(10) +
                          'Promoción: ' + STRING(ITEM.CanPed * ITEM.factor, '>,>>9.99') + ' ' + ITEM.UndVta.
              DELETE ITEM.
              NEXT DETALLE.
          END.
          /* CONTROL DE AJUTES */
          CREATE ITEM-3.
          BUFFER-COPY ITEM TO ITEM-3
              ASSIGN ITEM-3.CanAte = 0.     /* Valor por defecto */    
          /* AJUSTAMOS Y RECALCULAMOS IMPORTES */
          ASSIGN
              ITEM.CanPed = s-StkDis / f-Factor
              ITEM.Libre_c01 = '*'.
          FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
              AND Almtconv.Codalter = ITEM.UndVta
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almtconv AND Almtconv.Multiplos <> 0 THEN DO:
              IF (ITEM.CanPed / Almtconv.Multiplos) <> INTEGER(ITEM.CanPed / Almtconv.Multiplos) THEN DO:
                  ITEM.CanPed = TRUNCATE(ITEM.CanPed / Almtconv.Multiplos, 0) * Almtconv.Multiplos.
              END.
          END.
          IF s-FlgEmpaque = YES AND Almmmatg.CanEmp > 0 THEN DO:
              ITEM.CanPed = (TRUNCATE((ITEM.CanPed * ITEM.Factor / Almmmatg.CanEmp),0) * Almmmatg.CanEmp) / ITEM.Factor.
          END.
          ASSIGN ITEM-3.CanAte = ITEM.CanPed.       /* CANTIDAD AJUSTADA */

          RUN Recalcular-Item.
      END.
  END.

  /* Ic - 03Oct2019, bolsas plasticas, adicionar el registro de IMPUESTO (ICBPER) */
  &IF {&ARITMETICA-SUNAT} &THEN
  &ELSE
  RUN impuesto-icbper.
  &ENDIF

  /* GRABAMOS INFORMACION FINAL */
  FOR EACH ITEM WHERE ITEM.CanPed > 0 BY ITEM.NroItm:
      I-NITEM = I-NITEM + 1.
      CREATE Facdpedi.
      BUFFER-COPY ITEM TO Facdpedi
          ASSIGN
            Facdpedi.CodCia = Faccpedi.CodCia
            Facdpedi.CodDiv = Faccpedi.CodDiv
            Facdpedi.coddoc = Faccpedi.coddoc
            Facdpedi.NroPed = Faccpedi.NroPed
            Facdpedi.FchPed = Faccpedi.FchPed
            Facdpedi.Hora   = Faccpedi.Hora 
            Facdpedi.FlgEst = Faccpedi.FlgEst
            Facdpedi.NroItm = I-NITEM
            Facdpedi.CanPick = Facdpedi.CanPed.   /* OJO */
  END.

  /* verificamos que al menos exista 1 item grabado */
  FIND FIRST Facdpedi OF Faccpedi NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Facdpedi 
  THEN RETURN 'ADM-ERROR'.
  ELSE RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Excel-2015 V-table-Win 
PROCEDURE Importar-Excel-2015 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN vtagn/ventas-library PERSISTENT SET hProc.

RUN COT_Importar-Excel IN hProc (INPUT-OUTPUT TABLE ITEM).
DELETE PROCEDURE hProc.

FOR EACH ITEM WHERE TRUE <> (ITEM.AlmDes > ''):
    ITEM.AlmDes = ENTRY(1,s-CodAlm).
END.
RUN Procesa-Handle IN lh_handle ( "Recalculo" ).
RUN Procesa-Handle IN lh_handle ( "Browse" ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE impuesto-icbper V-table-Win 
PROCEDURE impuesto-icbper :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Ic - 03Oct2019, bolsas plasticas, adicionar el registro de IMPUESTO (ICBPER) */
  DEFINE VAR x-ultimo-item AS INT.
  DEFINE VAR x-cant-bolsas AS INT.
  DEFINE VAR x-precio-ICBPER AS DEC.
  DEFINE VAR x-alm-des AS CHAR INIT "".

  x-ultimo-item = -1.
  x-cant-bolsas = 0.
  x-precio-ICBPER = 0.0.

  /* Sacar el importe de bolsas plasticas */
    DEFINE VAR z-hProc AS HANDLE NO-UNDO.               /* Handle Libreria */
    
    RUN ccb\libreria-ccb.p PERSISTENT SET z-hProc.
    
    /* Procedimientos */
    RUN precio-impsto-bolsas-plastica IN z-hProc (INPUT TODAY, OUTPUT x-precio-ICBPER).
    
    
    DELETE PROCEDURE z-hProc.                   /* Release Libreria */


  FOR EACH ITEM, FIRST Almmmatg OF ITEM NO-LOCK BY ITEM.NroItm DESC:

      IF Almmmatg.CodFam = '086' AND Almmmatg.SubFam = '001' THEN DO:
          x-cant-bolsas = x-cant-bolsas + (ITEM.canped * ITEM.factor).
          x-alm-des = ITEM.almdes.
      END.

  END.

  x-ultimo-item = 0.
  FOR EACH ITEM WHERE item.codmat = x-articulo-ICBPER :
      DELETE ITEM.
  END.

  FOR EACH ITEM BY ITEM.NroItm:
      x-ultimo-item = x-ultimo-item + 1.
      ASSIGN ITEM.implinweb = x-ultimo-item.
  END.
  FOR EACH ITEM :
      x-ultimo-item = x-ultimo-item + 1.
      ASSIGN ITEM.NroItm = ITEM.implinweb
            ITEM.implinweb = 0.
  END.

  IF x-cant-bolsas > 0 THEN DO:

      FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                almmmatg.codmat = x-articulo-ICBPER NO-LOCK NO-ERROR.

        x-ultimo-item = x-ultimo-item + 1.

        CREATE ITEM.
        ASSIGN
          ITEM.CodCia = Faccpedi.CodCia
          ITEM.CodDiv = Faccpedi.CodDiv
          ITEM.coddoc = Faccpedi.coddoc
          ITEM.NroPed = Faccpedi.NroPed
          ITEM.FchPed = Faccpedi.FchPed
          ITEM.Hora   = Faccpedi.Hora 
          ITEM.FlgEst = Faccpedi.FlgEst
          ITEM.NroItm = x-ultimo-item
          ITEM.CanPick = 0.   /* OJO */

      ASSIGN 
          ITEM.codmat = x-articulo-ICBPER
          ITEM.UndVta = IF (AVAILABLE almmmatg) THEN Almmmatg.UndA ELSE 'UNI'
          ITEM.almdes = x-alm-des
          ITEM.Factor = 1
          ITEM.PorDto = 0
          ITEM.PreBas = x-precio-ICBPER
          ITEM.AftIgv = IF (AVAILABLE almmmatg) THEN Almmmatg.AftIgv ELSE NO
          ITEM.AftIsc = NO
          ITEM.Libre_c04 = "".
      ASSIGN 
          ITEM.CanPed = x-cant-bolsas
          ITEM.PreUni = x-precio-ICBPER
          ITEM.Por_Dsctos[1] = 0.00
          ITEM.Por_Dsctos[2] = 0.00
          ITEM.Por_Dsctos[3] = 0.00
          ITEM.Libre_d02     = 0.
      ASSIGN
          ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                        ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                        ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                        ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
      IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
          THEN ITEM.ImpDto = 0.
          ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
      /* ***************************************************************** */
    
      ASSIGN
          ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
          ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
      IF ITEM.AftIsc 
        THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
      ELSE ITEM.ImpIsc = 0.
        IF ITEM.AftIgv 
      THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
        ELSE ITEM.ImpIgv = 0.
  END.

  /* Ic - 03Oct2019, bolsas plasticas */


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
      s-Copia-Registro  = NO
      s-PorIgv          = FacCfgGn.PorIgv
      x-ClientesVarios  = FacCfgGn.CliVar.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          s-CodMon = 1
          s-CodCli = x-ClientesVarios
          s-CndVta = '000'      /* SOLO CONTADO */
          s-TpoCmb = FacCfgGn.TpoCmb[1] 
          s-NroDec = 4
          s-FlgIgv = YES    /* Venta AFECTA a IGV */
          s-FlgSit = ""
          FacCPedi.CodMon:SCREEN-VALUE = "Soles"
          FacCPedi.Cmpbnte:SCREEN-VALUE = "FAC"
          FacCPedi.Libre_d01:SCREEN-VALUE = STRING(s-NroDec, '9')
          FacCPedi.FlgIgv:SCREEN-VALUE = "YES"
          Faccpedi.FlgSit:SCREEN-VALUE = s-FlgSit
          s-NroPed = ""
          s-adm-new-record = "YES".
      /* RHC 11.08.2014 TC Caja Compra */
      FIND LAST gn-tccja WHERE gn-tccja.fecha <= TODAY AND gn-tccja.fecha <> ? NO-LOCK NO-ERROR.
      IF AVAILABLE gn-tccja THEN s-TpoCmb = Gn-TCCja.Compra.
      DISPLAY 
          STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ FacCPedi.NroPed
          TODAY @ FacCPedi.FchPed
          S-TPOCMB @ FacCPedi.TpoCmb
          TODAY @ FacCPedi.FchVen 
          s-CodCli @ FacCPedi.CodCli
          s-CndVta @ FacCPedi.FmaPgo.
          /*s-CodVen @ Faccpedi.codven*/
      RUN Borra-Temporal.
      RUN Procesa-Handle IN lh_Handle ('Pagina2').
      APPLY 'ENTRY':U TO FacCPedi.CodCli.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       El problema es cuando varios usuarios crean y modifican sus pedidos
  a la vez, entonces vamos a bloquear el correlativo como tabla de control
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.
  DEFINE VARIABLE i-Cuenta AS INTEGER NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      /* NUEVO PEDIDO */
      RUN CREATE-TRANSACION.
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar los pedidos'.
          UNDO, RETURN 'ADM-ERROR'.
      END.
  END.
  ELSE DO:
      /* MODIFICAR PEDIDO */
      RUN UPDATE-TRANSACION.
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar los pedidos'.
          UNDO, RETURN 'ADM-ERROR'.
      END.
  END.
  ASSIGN 
      FacCPedi.PorIgv = s-PorIgv
      FacCPedi.Hora = STRING(TIME,"HH:MM")
      FacCPedi.Usuario = S-USER-ID
      FacCPedi.FlgEnv = s-FlgEnv.
  /* ********************************************************************************************** */
  /* Grabamos en Detalle del Pedido */
  /* ********************************************************************************************** */
  RUN WRITE-DETAIL.       /* Detalle del pedido */
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar el pedido' + CHR(10) + 'NO hay stock suficiente en los almacenes'.
      UNDO, RETURN 'ADM-ERROR'.
  END.

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
  DEF VAR x-CodRef AS CHAR.
  DEF VAR x-NroRef AS CHAR.

  IF NOT AVAILABLE FaccPedi THEN RETURN "ADM-ERROR".
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDoc = S-CODDOC 
      AND FacCorre.NroSer = s-NroSer
      NO-LOCK NO-ERROR.
  IF FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  IF LOOKUP(FacCPedi.CodRef, "C/M") > 0 THEN DO:
      MESSAGE 'NO se puede copiar un pedido basado en una cotización'
          VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  MESSAGE 'Se va a proceder a con la copia' SKIP
      'El pedido ORIGINAL puede que sea ANULADO' SKIP
      'Continuamos (S-N)?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN 'ADM-ERROR'.
  FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCPedi THEN RETURN "ADM-ERROR".
  IF Faccpedi.FlgEst = 'P' THEN Faccpedi.FlgEst = 'A'.
  FIND CURRENT Faccpedi NO-LOCK NO-ERROR.

  ASSIGN
      s-CodMon = Faccpedi.codmon
      s-CodCli = Faccpedi.codcli
      s-CndVta = Faccpedi.fmapgo
      s-TpoCmb = FacCfgGn.TpoCmb[1]
      s-FlgIgv = Faccpedi.FlgIgv
      s-Copia-Registro = YES    /* <<< OJO >>> */
      s-PorIgv = FacCfgGn.PorIgv
      s-NroDec = Faccpedi.Libre_d01
      x-CodRef = FacCPedi.CodDoc
      x-NroRef = FacCPedi.NroPed.
  RUN Copia-Items.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      DISPLAY 
          "" @ F-Estado
          "" @ FacCPedi.Glosa
          STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ FacCPedi.NroPed
          TODAY @ FacCPedi.FchPed
          S-TPOCMB @ FacCPedi.TpoCmb
          TODAY @ FacCPedi.FchVen.
          /*x-CodRef @ FacCPedi.CodRef
          x-NroRef @ FacCPedi.NroRef.*/
      APPLY "ENTRY":U TO FacCPedi.CodCli.
  END.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('Recalculo').
  RUN Procesa-Handle IN lh_Handle ('Browse').
  RUN Procesa-Handle IN lh_Handle ("Disable-btn-cotiza").
  RUN Procesa-Handle IN lh_Handle ("Disable-btn-prepedido").
  SESSION:SET-WAIT-STATE('').

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
  IF FacCPedi.FlgEst = "A" THEN DO:
     MESSAGE "El pedido ya fue anulado" VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.
  IF FacCPedi.FlgEst = "C" THEN DO:
     MESSAGE "No puede eliminar un pedido TOTALMENTE atendido" VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND CURRENT FacCPedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
      IF ERROR-STATUS:ERROR = YES THEN DO:
          {lib/mensaje-de-error.i &MensajeError="pMensaje"}
          UNDO, RETURN 'ADM-ERROR'.
      END.
      ASSIGN                 
          FacCPedi.UsrAprobacion = s-user-id
          FacCPedi.FchAprobacion = TODAY
          FacCPedi.FlgEst = 'A'
          FacCPedi.Glosa  = "ANULADO POR: " + TRIM (s-user-id) + " EL DIA: " + STRING(TODAY) + " " + STRING(TIME, 'HH:MM').

      /* BORRAMOS DETALLE */
      RUN Borra-Pedido (FALSE, OUTPUT pMensaje).
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
          UNDO, RETURN 'ADM-ERROR'.
      END.

      FIND CURRENT FacCPedi NO-LOCK.
      RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
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
  IF AVAILABLE FacCPedi THEN DO WITH FRAME {&FRAME-NAME}:
      RUN vta2/p-faccpedi-flgest (Faccpedi.flgest, Faccpedi.coddoc, OUTPUT f-Estado).
      DISPLAY f-Estado.
      F-Nomtar:SCREEN-VALUE = ''.
      FIND FIRST Gn-Card WHERE Gn-Card.NroCard = FacCPedi.NroCar NO-LOCK NO-ERROR.
      IF AVAILABLE Gn-Card THEN F-NomTar:SCREEN-VALUE = GN-CARD.NomClie[1].
      F-NomVen:SCREEN-VALUE = "".
      FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
          AND  gn-ven.CodVen = FacCPedi.CodVen 
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
      F-CndVta:SCREEN-VALUE = "".
      FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
      IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
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
          FacCPedi.NomCli:SENSITIVE = NO
          FacCPedi.DirCli:SENSITIVE = NO
          FacCPedi.RucCli:SENSITIVE = NO
          FacCPedi.fchven:SENSITIVE = NO
          FacCPedi.TpoCmb:SENSITIVE = NO
          FacCPedi.FmaPgo:SENSITIVE = NO
          FacCPedi.FlgIgv:SENSITIVE = NO
          FacCPedi.Libre_d01:SENSITIVE = NO
          FacCPedi.CodMon:SENSITIVE = NO
          FacCPedi.CodRef:SENSITIVE = NO
          FacCPedi.NroRef:SENSITIVE = NO.
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'NO' THEN DO:
          FacCPedi.CodCli:SENSITIVE = NO.
          IF Faccpedi.CodCli = x-ClientesVarios THEN DO:
              ASSIGN
                  FacCPedi.NomCli:SENSITIVE = YES
                  FacCPedi.DirCli:SENSITIVE = YES
                  .
          END.
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
  IF Faccpedi.FlgEst <> "A" THEN RUN vta2/r-impped-cont (ROWID(Faccpedi)).

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

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      IF s-Sunat-Activo = YES THEN FacCPedi.Cmpbnte:RADIO-BUTTONS = "Factura,FAC," +
                                            "Boleta,BOL".
      ELSE FacCPedi.Cmpbnte:RADIO-BUTTONS = "Factura,FAC," +
                                            "Boleta,BOL".
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
  s-FlgEnv = YES.
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".


  /* ********************************************************* */
  /* Dispatch standard ADM method.                             */
  /* ********************************************************* */
  DEF VAR LocalAdmNewRecord AS CHAR NO-UNDO.

  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  LocalAdmNewRecord = RETURN-VALUE.
  pMensaje = ''.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .      /* Rutina estandar del Progress */

  IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      RUN Procesa-handle IN lh_handle ('browse').
      RETURN 'ADM-ERROR'.
  END.

  /* ********************************************************* */
  /* GRABACIONES DATOS ADICIONALES A LA COTIZACION */
  /* ********************************************************* */
  RUN WRITE-HEADER (LocalAdmNewRecord).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF pMensaje > '' THEN MESSAGE pMensaje SKIP(2) 'REPITA EL PROCESO DE GRABACION'
          VIEW-AS ALERT-BOX ERROR.
      RUN Procesa-handle IN lh_handle ('browse').
      RETURN 'ADM-ERROR'.
  END.
  FIND CURRENT FacCPedi NO-LOCK NO-ERROR.
  /* ********************************************************* */

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Venta-Corregida.

  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse'). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PrecioUnitarioContadoMayorista V-table-Win 
PROCEDURE PrecioUnitarioContadoMayorista :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER S-CODCIA AS INT.
DEF INPUT PARAMETER S-CODDIV AS CHAR.
DEF INPUT PARAMETER S-CODCLI AS CHAR.
DEF INPUT PARAMETER S-CODMON AS INT.
DEF INPUT PARAMETER S-TPOCMB AS DEC.
DEF OUTPUT PARAMETER F-FACTOR AS DEC.
DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT PARAMETER S-FLGSIT AS CHAR.
DEF INPUT PARAMETER S-UNDVTA AS CHAR.
DEF INPUT PARAMETER X-CANPED AS DEC.
DEF INPUT PARAMETER x-NroDec AS INT.
DEF INPUT PARAMETER pCodAlm AS CHAR.       /* PARA CONTROL DE ALMACENES DE REMATES */
DEF OUTPUT PARAMETER F-PREBAS AS DEC.
DEF OUTPUT PARAMETER F-PREVTA AS DEC.
DEF OUTPUT PARAMETER F-DSCTOS AS DEC.
DEF OUTPUT PARAMETER Y-DSCTOS AS DEC.
DEF OUTPUT PARAMETER X-TIPDTO AS CHAR.

DEF VAR SW-LOG1 AS LOGI NO-UNDO.

DEFINE VARIABLE X-PREVTA1 AS DECI NO-UNDO.
DEFINE VARIABLE X-PREVTA2 AS DECI NO-UNDO.
DEFINE VARIABLE X-FACTOR  AS DECI NO-UNDO.

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = s-codmat NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN 'ADM-ERROR'.

FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = pCodAlm NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almacen THEN RETURN 'ADM-ERROR'.

/* variables sacadas del include */
DEFINE VAR J AS INTEGER.
DEFINE VAR X-RANGO AS INTEGER INIT 0.   
DEFINE VAR X-CANTI AS DECI    INIT 0.   

/* FACTOR DE EQUIVALENCIA */
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = s-undvta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN RETURN "ADM-ERROR".
F-FACTOR = Almtconv.Equival.

ASSIGN
    X-FACTOR = 1
    X-PREVTA1 = 0
    X-PREVTA2 = 0
    SW-LOG1 = FALSE.

/* RHC 04.04.2011 ALMACENES DE REMATE */
IF Almacen.Campo-C[3] = 'Si' THEN DO:
    FIND VtaTabla WHERE Vtatabla.codcia = s-codcia
        AND Vtatabla.tabla = 'REMATES'
        AND Vtatabla.llave_c1 = s-codmat
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaTabla THEN DO:
        IF s-CodMon = Almmmatg.MonVta 
        THEN F-PREBAS = VtaTabla.Valor[1] * f-Factor.
        ELSE IF s-CodMon = 1 
            THEN F-PREBAS = ROUND ( VtaTabla.Valor[1] * f-Factor * Almmmatg.TpoCmb, 6 ).
            ELSE F-PREBAS = ROUND ( VtaTabla.Valor[1] * f-Factor / Almmmatg.TpoCmb, 6 ).
        ASSIGN
            F-PREVTA = F-PREBAS.
        RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).
        RETURN 'OK'.
    END.
END.
/* ********************************* */

/*RDP 17.08.10 Reduce a 4 decimales*/
RUN BIN/_ROUND1(F-PREbas,4,OUTPUT F-PreBas).
/**************************/

/* PRECIOS PRODUCTOS DE TERCEROS */
DEF VAR x-ClfCli2 LIKE gn-clie.clfcli2 INIT 'C' NO-UNDO.
DEF VAR x-Cols AS CHAR INIT 'A++,A+,A-' NO-UNDO.

FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = s-codcli
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-clie AND gn-clie.clfcli2 <> '' THEN x-ClfCli2 = gn-clie.clfcli2.

/****   PRECIO C    ****/
IF Almmmatg.UndC <> "" AND NOT SW-LOG1 THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
        AND  Almtconv.Codalter = Almmmatg.UndC 
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN X-FACTOR = Almtconv.Equival.
    IF (x-CanPed * F-FACTOR) >= (0.25 * X-FACTOR) THEN DO:
        SW-LOG1 = TRUE.
        F-DSCTOS = Almmmatg.dsctos[3].
        IF Almmmatg.MonVta = 1 THEN
          ASSIGN X-PREVTA1 = Almmmatg.Prevta[4]
                 X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
        ELSE
          ASSIGN X-PREVTA2 = Almmmatg.Prevta[4]
                 X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
        X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
        X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
    END.
END.
/****   PRECIO B    ****/
IF Almmmatg.UndB <> "" AND NOT SW-LOG1 THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
        AND  Almtconv.Codalter = Almmmatg.UndB 
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN X-FACTOR = Almtconv.Equival.
    IF (x-CanPed * F-FACTOR) >= (0.25 * X-FACTOR) THEN DO:
        SW-LOG1 = TRUE.
        F-DSCTOS = Almmmatg.dsctos[2].
        IF Almmmatg.MonVta = 1 THEN 
          ASSIGN X-PREVTA1 = Almmmatg.Prevta[3]
                 X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
        ELSE
          ASSIGN X-PREVTA2 = Almmmatg.Prevta[3]
                 X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
        X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
        X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
    END.
END.
/****   PRECIO A    ****/
IF Almmmatg.UndA <> "" AND NOT SW-LOG1 THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
        AND  Almtconv.Codalter = Almmmatg.UndA 
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN X-FACTOR = Almtconv.Equival.
    IF (x-CanPed * F-FACTOR) >= (0.25 * X-FACTOR) THEN DO:
        SW-LOG1 = TRUE.
        F-PREBAS = Almmmatg.PreVta[1].
        F-DSCTOS = Almmmatg.dsctos[1].
        IF Almmmatg.MonVta = 1 THEN 
          ASSIGN X-PREVTA1 = Almmmatg.Prevta[2]
                 X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
        ELSE
          ASSIGN X-PREVTA2 = Almmmatg.Prevta[2]
                 X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
        X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
        X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
    END.
    ELSE DO:
        SW-LOG1 = TRUE.
        F-DSCTOS = Almmmatg.dsctos[1].
        IF Almmmatg.MonVta = 1 THEN 
          ASSIGN X-PREVTA1 = Almmmatg.Prevta[2]
                 X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
        ELSE
          ASSIGN X-PREVTA2 = Almmmatg.Prevta[2]
                 X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
        X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
        X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
    END.
END.       
IF s-CodMon = Almmmatg.MonVta THEN F-PREBAS = Almmmatg.PreVta[1].
ELSE IF s-CodMon = 1 THEN F-PREBAS = ROUND ( Almmmatg.PreVta[1] * Almmmatg.TpoCmb, 6 ).
                    ELSE F-PREBAS = ROUND ( Almmmatg.PreVta[1] / Almmmatg.TpoCmb, 6 ).
F-PREBAS = F-PREBAS * F-FACTOR.
IF X-PREVTA1 + X-PREVTA2 > 0 THEN DO:
    IF S-CODMON = 1 
    THEN F-PREVTA = X-PREVTA1.
    ELSE F-PREVTA = X-PREVTA2.     
END.      


/* DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA */
Y-DSCTOS = 0.        
  
/* RHC INCREMENTO AL PRECIO UNITARIO POR PAGAR CON TARJETA DE CREDITO */
/* Calculamos el margen de utilidad */
DEF VAR x-MargenUtilidad AS DEC NO-UNDO.
DEF VAR x-ImporteCosto AS DEC NO-UNDO.

x-ImporteCosto = Almmmatg.Ctotot.
IF s-CODMON <> Almmmatg.Monvta THEN DO:
    x-ImporteCosto = IF s-CODMON = 1 
                THEN Almmmatg.Ctotot * Almmmatg.Tpocmb
                ELSE Almmmatg.Ctotot / Almmmatg.Tpocmb.
END.
IF x-ImporteCosto > 0
THEN x-MargenUtilidad = ( (f-PreVta / f-Factor) - x-ImporteCosto ) / x-ImporteCosto * 100.
IF x-MargenUtilidad < 0 THEN x-MargenUtilidad = 0.

/*************************************************/
CASE s-FlgSit:
    WHEN 'T' THEN DO:       /* PAGO CON TARJETA DE CREDITO */
        /* BUSCAMOS EL RANGO ADECUADO */
        FOR EACH FacTabla NO-LOCK WHERE FacTabla.codcia = s-codcia
                AND FacTabla.Tabla = 'TC'
                AND FacTabla.Codigo BEGINS '00':
            IF x-MargenUtilidad >= FacTabla.Valor[1]
                    AND x-MargenUtilidad < FacTabla.Valor[2] THEN DO:
                f-PreVta = f-Prevta * (1 + FacTabla.Valor[3] / 100).
                f-PreBas = f-PreBas * (1 + FacTabla.Valor[3] / 100).
                LEAVE.
            END.
        END.                
    END.
END CASE.
/* RHC 19/11/2013 INCREMENTO POR DIVISION Y FAMILIA */
/* RHC 07/05/2020 No va */
/* FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia           */
/*     AND VtaTabla.Llave_c1 = s-coddiv                     */
/*     AND VtaTabla.Llave_c2 = Almmmatg.codfam              */
/*     AND VtaTabla.Tabla = "DIVFACXLIN"                    */
/*     NO-LOCK NO-ERROR.                                    */
/* IF AVAILABLE VtaTabla THEN DO:                           */
/*     f-PreVta = f-Prevta * (1 + VtaTabla.Valor[1] / 100). */
/*     f-PreBas = f-PreBas * (1 + VtaTabla.Valor[1] / 100). */
/* END.                                                     */

/************************************************/
RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).
ASSIGN
    F-DSCTOS = ABSOLUTE(F-DSCTOS)
    Y-DSCTOS = ABSOLUTE(Y-DSCTOS).

RETURN 'OK'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Item V-table-Win 
PROCEDURE Recalcular-Item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

        DEF VAR f-factor AS DECI NO-UNDO.
        DEF VAR f-PreBas AS DECI NO-UNDO.
        DEF VAR f-PreVta AS DECI NO-UNDO.
        DEF VAR z-Dsctos AS DECI NO-UNDO.
        DEF VAR y-Dsctos AS DECI NO-UNDO.
        DEF VAR x-TipDto AS CHAR NO-UNDO.
        DEF VAR f-Dsctos AS DECI NO-UNDO.
        DEF VAR f-FleteUnitario AS DECI NO-UNDO.



        RUN {&precio-venta-general} (s-CodCia,
                                     s-CodDiv,
                                     s-CodCli,
                                     s-CodMon,
                                     s-TpoCmb,
                                     OUTPUT f-Factor,
                                     ITEM.codmat,
                                     s-FlgSit,
                                     ITEM.undvta,
                                     ITEM.CanPed,
                                     s-NroDec,
                                     ITEM.almdes,
                                     OUTPUT f-PreBas,
                                     OUTPUT f-PreVta,
                                     OUTPUT f-Dsctos,
                                     OUTPUT y-Dsctos,
                                     OUTPUT x-TipDto,
                                     OUTPUT f-FleteUnitario,
                                     OUTPUT pMensaje
                                     ).
        IF RETURN-VALUE <> 'ADM-ERROR' 
            THEN ASSIGN
                ITEM.PreUni = F-PREVTA
                ITEM.PorDto = f-Dsctos
                ITEM.PreBas = F-PreBas 
                ITEM.PreVta[1] = F-PreVta
                ITEM.Por_Dsctos[2] = z-Dsctos
                ITEM.Por_Dsctos[3] = y-Dsctos
                ITEM.Libre_c04 = x-TipDto
                ITEM.Libre_d02 = f-FleteUnitario
                .
        /* ***************************************************************** */
        ASSIGN
            ITEM.PreUni = ROUND(ITEM.PreBas + ITEM.Libre_d02, s-NroDec)
            ITEM.ImpLin = ITEM.CanPed * ITEM.PreUni * 
                            ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                            ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                            ( 1 - ITEM.Por_Dsctos[3] / 100 ).
        IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
            THEN ITEM.ImpDto = 0.
        ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
        ASSIGN
            ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
            ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
        IF ITEM.AftIgv 
            THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).



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
  {src/adm/template/snd-list.i "FacCPedi"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE UPDATE-TRANSACION V-table-Win 
PROCEDURE UPDATE-TRANSACION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

PRINCIPAL:                                                                                  
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    RUN Borra-Pedido (YES, OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo actualizar el pedido".
        UNDO, RETURN 'ADM-ERROR'.
    END.
END.
RETURN 'OK'.

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
      IF FacCPedi.CodCli:SCREEN-VALUE = "" THEN DO:
          MESSAGE "Codigo de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO FacCPedi.CodCli.
          RETURN "ADM-ERROR".   
      END.
      /* **************************************** */
      /* RHC 22/07/2020 Nuevo bloqueo de clientes */
      /* **************************************** */
      RUN pri/p-verifica-cliente (INPUT Faccpedi.CodCli:SCREEN-VALUE,
                                  INPUT s-CodDoc,
                                  INPUT s-CodDiv).
      IF RETURN-VALUE = "ADM-ERROR" THEN DO:
          APPLY "ENTRY" TO FacCPedi.CodCli.
          RETURN "ADM-ERROR".   
      END.
      /* **************************************** */
      FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
          AND  gn-clie.CodCli = FacCPedi.CodCli:SCREEN-VALUE
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-clie THEN DO:
         MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO FacCPedi.CodCli.
         RETURN "ADM-ERROR".
      END.
      IF gn-clie.canal = '006' THEN DO:
          MESSAGE 'Cliente no permitido en este canal de venta de venta'
              VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO FacCPedi.CodCli.
          RETURN "ADM-ERROR".   
      END.
      IF Faccpedi.Cmpbnte:SCREEN-VALUE = "FAC" AND FacCpedi.RucCli:SCREEN-VALUE = '' THEN DO:
          MESSAGE "El Cliente NO tiene R.U.C." VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO FacCPedi.CodCli.
          RETURN "ADM-ERROR".   
      END.
      IF Faccpedi.Cmpbnte:SCREEN-VALUE = "FAC" THEN DO:
         IF LENGTH(FacCPedi.RucCli:SCREEN-VALUE) < 11 THEN DO:
             MESSAGE 'El RUC debe tener 11 dígitos' VIEW-AS ALERT-BOX ERROR.
             APPLY 'ENTRY':U TO FacCPedi.CodCli.
             RETURN 'ADM-ERROR'.
         END.
         IF LOOKUP(SUBSTRING(FacCPedi.RucCli:SCREEN-VALUE,1,2), '20,15,17,10') = 0 THEN DO:
             MESSAGE 'El RUC debe comenzar con 10,15,17 ó 20' VIEW-AS ALERT-BOX ERROR.
             APPLY 'ENTRY':U TO FacCPedi.CodCli.
             RETURN 'ADM-ERROR'.
         END.
          /* dígito verificador */
          DEF VAR pResultado AS CHAR NO-UNDO.
          RUN lib/_ValRuc (FacCPedi.RucCli:SCREEN-VALUE, OUTPUT pResultado).
          IF pResultado = 'ERROR' THEN DO:
              MESSAGE 'Código RUC MAL registrado' VIEW-AS ALERT-BOX WARNING.
              APPLY 'ENTRY':U TO FacCPedi.CodCli.
              RETURN 'ADM-ERROR'.
          END.
      END.
    /* VALIDACION DEL VENDEDOR */
     IF FacCPedi.CodVen:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Codigo de Vendedor no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FacCPedi.CodVen.
        RETURN "ADM-ERROR".   
     END.
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
         AND  gn-ven.CodVen = FacCPedi.CodVen:SCREEN-VALUE 
         NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gn-ven THEN DO:
        MESSAGE "Codigo de Vendedor no existe" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FacCPedi.CodVen.
        RETURN "ADM-ERROR".   
     END.
     ELSE DO:
         IF gn-ven.flgest = "C" THEN DO:
             MESSAGE "Codigo de Vendedor Cesado" VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO FacCPedi.CodVen.
             RETURN "ADM-ERROR".   
         END.
     END.
    /* VALIDACION DE LA CONDICION DE VENTA */    
     IF FacCPedi.FmaPgo:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Condicion Venta no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FacCPedi.FmaPgo.
        RETURN "ADM-ERROR".   
     END.
     FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gn-convt THEN DO:
        MESSAGE "Condicion Venta no existe" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FacCPedi.FmaPgo.
        RETURN "ADM-ERROR".   
     END.
     IF FacCPedi.FmaPgo:SCREEN-VALUE <> "000" THEN DO:
        MESSAGE "Condicion Venta debe ser contado" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FacCPedi.FmaPgo.
        RETURN "ADM-ERROR".   
     END.
    /* VALIDACION DE LA TARJETA */
     IF Faccpedi.NroCar:SCREEN-VALUE <> "" THEN DO:
         FIND Gn-Card WHERE Gn-Card.NroCard = Faccpedi.NroCar:SCREEN-VALUE
             NO-LOCK NO-ERROR.
         IF NOT AVAILABLE Gn-Card THEN DO:
             MESSAGE "Numero de Tarjeta Incorrecto, Verifique... " VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO FacCPedi.NroCar.
             RETURN "ADM-ERROR".   
         END.   
     END.           
     /**/
     IF Faccpedi.Cmpbnte:SCREEN-VALUE = "BOL" AND 
         NOT (TRUE <> (FacCPedi.RucCli:SCREEN-VALUE > "")) THEN DO:
            MESSAGE 'Se va a generar una BOLETA DE VENTA con R.U.C.' SKIP 
                '¿ Esta seguro de Genar el Comprobante ?' VIEW-AS ALERT-BOX QUESTION
                    BUTTONS YES-NO UPDATE rpta AS LOG.
                IF rpta = NO THEN RETURN "ADM-ERROR".
     END.
     /* VALIDACION DE ITEMS */
     FOR EACH ITEM NO-LOCK:
         F-Tot = F-Tot + ITEM.ImpLin.
     END.
     IF F-Tot = 0 THEN DO:
        MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FacCPedi.CodCli.
        RETURN "ADM-ERROR".   
     END.
    /* *********************************************************** */
    /* VALIDACION DE MONTO MINIMO POR BOLETA */
    /* Si es es BOL y no llega al monto mínimo blanqueamos el DNI */
    /* *********************************************************** */
    F-BOL = IF INTEGER(FacCPedi.CodMon:SCREEN-VALUE) = 1 
        THEN F-TOT
        ELSE F-Tot * DECIMAL(FacCPedi.TpoCmb:SCREEN-VALUE).
    /*
    
    Ic - 16Mar2022, Se detecto que cuando se grababa el registro blanqueaba el DNI, se coordino
            com Daniel Llican y Mayra padilla y se quito dicha validacion
    
    IF ( Faccpedi.Cmpbnte:SCREEN-VALUE = 'BOL' OR Faccpedi.Cmpbnte:SCREEN-VALUE = 'TCK' )
        AND F-BOL <= ImpMinDNI THEN FacCPedi.Atencion:SCREEN-VALUE = ''.
    */

    DEF VAR cNroDni AS CHAR NO-UNDO.
    DEF VAR iLargo  AS INT NO-UNDO.
    DEF VAR cError  AS CHAR NO-UNDO.
    cNroDni = FacCPedi.Atencion:SCREEN-VALUE.
    IF Faccpedi.Cmpbnte:SCREEN-VALUE = 'BOL' AND F-BOL > ImpMinDNI THEN DO:
        RUN lib/_valid_number (INPUT-OUTPUT cNroDni, OUTPUT iLargo, OUTPUT cError).
        IF cError > '' OR iLargo <> 8 THEN DO:
            cError = cError + (IF cError > '' THEN CHR(10) ELSE '') +
                       "El DNI debe tener 8 números".
            MESSAGE cError VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FacCPedi.Atencion.
            RETURN "ADM-ERROR".   
        END.
        IF TRUE <> (FacCPedi.NomCli:SCREEN-VALUE > '') THEN DO:
            MESSAGE "Venta Mayor a" ImpMinDNI SKIP
                "Debe ingresar el Nombre del Cliente"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FacCPedi.NomCli.
            RETURN "ADM-ERROR".   
        END.
        IF TRUE <> (FacCPedi.DirCli:SCREEN-VALUE > '') THEN DO:
            MESSAGE "Venta Mayor a" ImpMinDNI SKIP
                "Debe ingresar la Dirección del Cliente"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FacCPedi.DirCli.
            RETURN "ADM-ERROR".   
        END.
    END.
    /* VALIDACION DE IMPORTE MINIMO POR COTIZACION */
    IF s-FlgEnv = YES THEN DO:
        DEF VAR pImpMin AS DEC NO-UNDO.
        RUN gn/pMinCotPed (s-CodCia,
                           s-CodDiv,
                           s-CodDoc,
                           OUTPUT pImpMin).
        IF pImpMin > 0 AND f-Bol < pImpMin THEN DO:
            MESSAGE 'El importe mínimo para el envío es de S/.' pImpMin
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.
    END.
    /* VALIDAMOS CLIENTES VARIOS */
    IF Faccpedi.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-ClientesVarios THEN DO:
        IF NOT getSoloLetras(SUBSTRING(Faccpedi.Nomcli:SCREEN-VALUE,1,2)) THEN DO:
            MESSAGE 'Nombre no pasa la validacion para SUNAT' VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.                                   
        END.
    END.
  END.
/* *************************************************************************************** */
/* 19/01/2023 Nuevos Controles */
/* *************************************************************************************** */
DO WITH FRAME {&FRAME-NAME}:
    /* *************************************************************************************** */
    /* Verificamos PEDI y lo actualizamos con el stock disponible */
    /* *************************************************************************************** */
    EMPTY TEMP-TABLE PEDI-3.
    FOR EACH ITEM:
        CREATE PEDI-3.
        BUFFER-COPY ITEM TO PEDI-3.
    END.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN VALIDATE-DETAIL (INPUT RETURN-VALUE, OUTPUT pMensaje).
    SESSION:SET-WAIT-STATE('').
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        /* Regresamos todo como si no hubiera pasado nada */
        EMPTY TEMP-TABLE ITEM.
        FOR EACH PEDI-3:
            CREATE ITEM.
            BUFFER-COPY PEDI-3 TO ITEM.
        END.
        RUN Procesa-Handle IN lh_handle ("Browse").
        RETURN 'ADM-ERROR'.
    END.
    /* Pintamos nuevos datos */
    RUN Procesa-Handle IN lh_handle ("Browse").
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

IF NOT AVAILABLE FacCPedi THEN RETURN "ADM-ERROR".
IF LOOKUP(FacCPedi.FlgEst, "P,I") = 0 THEN DO:
    MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
IF FacCPedi.FchPed < TODAY THEN DO:
    MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
ASSIGN
    S-CODMON = FacCPedi.CodMon
    S-CODCLI = FacCPedi.CodCli
    S-TPOCMB = FacCPedi.TpoCmb
    S-CNDVTA = FacCPedi.FmaPgo
    s-Copia-Registro = NO
    s-PorIgv = Faccpedi.porigv
    s-NroDec = Faccpedi.Libre_d01
    s-FlgIgv = Faccpedi.FlgIgv
    s-FlgSit = Faccpedi.FlgSit
    s-NroPed = Faccpedi.NroPed
    s-adm-new-record = "NO"
    s-Cmpbnte = Faccpedi.Cmpbnte
    .

RUN Carga-Temporal.

RUN Procesa-Handle IN lh_Handle ('Pagina2').

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VALIDATE-DETAIL V-table-Win 
PROCEDURE VALIDATE-DETAIL :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAMETER pEvento AS CHAR.
  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  /* ********************* */
  DEF VAR f-Factor AS DECI NO-UNDO.
  DEF VAR s-StkComprometido AS DECI NO-UNDO.
  DEF VAR x-StkAct AS DECI NO-UNDO.
  DEF VAR s-StkDis AS DECI NO-UNDO.
  DEF VAR x-CanPed AS DECI NO-UNDO.

  /* Borramos data sobrante */
  FOR EACH ITEM EXCLUSIVE-LOCK WHERE ITEM.CanPed <= 0:
      DELETE ITEM.
  END.
  
  EMPTY TEMP-TABLE ITEM-3.

  DETALLE:
  FOR EACH ITEM EXCLUSIVE-LOCK WHERE ITEM.codmat <> x-articulo-ICBPER, 
      FIRST Almmmatg OF ITEM NO-LOCK  
      BY ITEM.NroItm : 
      ASSIGN
          ITEM.Libre_d01 = ITEM.CanPed.
      /* RUTINA QUE VERIFICA NUEVAMENTE EL STOCK DISPONIBLE Y AJUSTA LA CANTIDAD EN CASO NECESARIO */
      x-StkAct = 0.
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = ITEM.AlmDes
          AND Almmmate.codmat = ITEM.CodMat
          NO-LOCK NO-ERROR .
      IF NOT AVAILABLE Almmmate THEN DO:
          pMensaje = "Código " + ITEM.CodMat + " No registrado en el almacén " + ITEM.almdes  + CHR(10) + ~
              "Proceso abortado".
          UNDO, RETURN "ADM-ERROR".
      END.
      x-StkAct = Almmmate.StkAct.
      f-Factor = ITEM.Factor.
      /* **************************************************************** */
      /* Solo verifica comprometido si hay stock */
      /* **************************************************************** */
      IF x-StkAct > 0 THEN DO:
          RUN gn/Stock-Comprometido-v2 (ITEM.CodMat, ITEM.AlmDes, YES, OUTPUT s-StkComprometido).
          /* **************************************************************** */
          /* OJO: Cuando se modifica hay que actualizar el STOCK COMPROMETIDO */
          /* **************************************************************** */
          IF pEvento = "NO" THEN DO:
              FIND Facdpedi OF Faccpedi WHERE Facdpedi.codmat = ITEM.codmat NO-LOCK NO-ERROR.
              IF AVAILABLE Facdpedi THEN s-StkComprometido = s-StkComprometido - (Facdpedi.CanPed * Facdpedi.Factor).
          END.
      END.
      /* **************************************************************** */
      s-StkDis = x-StkAct - s-StkComprometido.

      IF s-StkDis < 0 THEN s-StkDis = 0.    /* *** OJO *** */
      x-CanPed = ITEM.CanPed * f-Factor.

      IF s-coddiv = '00506' THEN DO:
          IF s-StkDis < x-CanPed THEN DO:
              pMensaje = "Código " + ITEM.CodMat + " No hay stock disponible en el almacén " + ITEM.almdes  + CHR(10) + ~
                  "Proceso abortado".
              UNDO, RETURN "ADM-ERROR".
          END.
      END.
      IF s-StkDis < x-CanPed THEN DO:
          /* CONTROL DE AJUTES */
          CREATE ITEM-3.
          BUFFER-COPY ITEM TO ITEM-3
              ASSIGN ITEM-3.CanAte = 0.     /* Valor por defecto */    
          /* AJUSTAMOS Y RECALCULAMOS IMPORTES */
          ASSIGN
              ITEM.CanPed = s-StkDis / f-Factor
              ITEM.Libre_c01 = '*'.
          FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
              AND Almtconv.Codalter = ITEM.UndVta
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almtconv AND Almtconv.Multiplos <> 0 THEN DO:
              IF (ITEM.CanPed / Almtconv.Multiplos) <> INTEGER(ITEM.CanPed / Almtconv.Multiplos) THEN DO:
                  ITEM.CanPed = TRUNCATE(ITEM.CanPed / Almtconv.Multiplos, 0) * Almtconv.Multiplos.
              END.
          END.
          IF s-FlgEmpaque = YES AND Almmmatg.CanEmp > 0 THEN DO:
              ITEM.CanPed = (TRUNCATE((ITEM.CanPed * ITEM.Factor / Almmmatg.CanEmp),0) * Almmmatg.CanEmp) / ITEM.Factor.
          END.
          ASSIGN ITEM-3.CanAte = ITEM.CanPed.       /* CANTIDAD AJUSTADA */

          RUN Recalcular-Item.
      END.
  END.

  /* POR CADA ITEM VOLVEMOS A VERIFICAR EL STOCK DISPONIBLE
    SI NO HAY STOCK RECALCULAMOS EL PRECIO DE VENTA */
  /* Borramos data sobrante */
  FOR EACH ITEM EXCLUSIVE-LOCK WHERE ITEM.CanPed <= 0:
      DELETE ITEM.
  END.
  /* ********************************************************************************************** */
  /* RECALCULAMOS */
  /* ********************************************************************************************** */
/*   FOR EACH ITEM EXCLUSIVE-LOCK:             */
/*       RUN Recalcular-Item.                  */
/*       IF ITEM.CanPed <= 0 THEN DELETE ITEM. */
/*   END.                                      */
  /* ********************************************************************************************** */
  /* RHC 05/05/2014 nueva rutina de promociones */
  /* ********************************************************************************************** */
  RUN {&Promocion} (s-CodDiv, s-CodCli, INPUT-OUTPUT TABLE ITEM, OUTPUT pMensaje).
  IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".

  FOR EACH ITEM NO-LOCK WHERE ITEM.Libre_c05 = "OF", 
      FIRST Almmmatg OF ITEM NO-LOCK, FIRST Almtfami OF Almmmatg NO-LOCK:
      /* **************************************************************************************** */
      /* VERIFICAMOS STOCK DISPONIBLE DE ALMACEN */
      /* **************************************************************************************** */
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = ITEM.AlmDes
          AND Almmmate.codmat = ITEM.CodMat
          NO-LOCK NO-ERROR.
      x-StkAct = 0.
      IF AVAILABLE Almmmate THEN x-StkAct = Almmmate.StkAct.
      RUN gn/stock-comprometido-v2.p (ITEM.CodMat, ITEM.AlmDes, YES, OUTPUT s-StkComprometido).
      /* **************************************************************** */
      /* OJO: Cuando se modifica hay que actualizar el STOCK COMPROMETIDO */
      /* **************************************************************** */
      IF pEvento = "NO" THEN DO:
          FIND Facdpedi OF Faccpedi WHERE Facdpedi.codmat = ITEM.codmat NO-LOCK NO-ERROR.
          IF AVAILABLE Facdpedi THEN s-StkComprometido = s-StkComprometido - (Facdpedi.CanPed * Facdpedi.Factor).
      END.
      /* **************************************************************** */
      s-StkDis = x-StkAct - s-StkComprometido.
      IF s-StkDis <= 0 THEN DO:
          pMensaje = 'El STOCK DISPONIBLE está en CERO para el producto ' + ITEM.codmat + 
              'en el almacén ' + ITEM.AlmDes + CHR(10).
          RETURN "ADM-ERROR".
      END.
      f-Factor = ITEM.Factor.
      x-CanPed = ITEM.CanPed * f-Factor.
      IF s-StkDis < x-CanPed THEN DO:
          pMensaje = 'Producto ' + ITEM.codmat + ' NO tiene Stock Disponible suficiente en el almacén ' + ITEM.AlmDes + CHR(10) +
              'Se va a abortar la generación del Pedido'.
          RETURN "ADM-ERROR".
      END.
  END.
  /* ********************************************************************************************** */
  /* ********************************************************************************************** */
  /* 16/11/2022: NINGUN producto (así sea promocional) debe estar con PRECIO CERO */
  /* ********************************************************************************************** */
  FOR EACH ITEM NO-LOCK:
      IF ITEM.PreUni <= 0 THEN DO:
          pMensaje = 'Producto ' + ITEM.codmat + ' NO tiene Precio Unitario ' + CHR(10) +
              'Se va a abortar la generación del Pedido'.
          RETURN "ADM-ERROR".
      END.
  END.
  IF NOT CAN-FIND(FIRST ITEM NO-LOCK) THEN DO:
      pMensaje = "NO hay stock suficiente para cubrir el pedido".
      RETURN 'ADM-ERROR'.
  END.

  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Venta-Corregida V-table-Win 
PROCEDURE Venta-Corregida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST ITEM-3 NO-LOCK NO-ERROR.
IF NOT AVAILABLE ITEM-3 THEN RETURN 'OK'.
RUN vta2/d-vtacorr-cont.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE WRITE-DETAIL V-table-Win 
PROCEDURE WRITE-DETAIL :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       ITEM ya viene pulida desde la rutina "valida"
------------------------------------------------------------------------------*/

  /* ********************* */
  DEF VAR I-NITEM AS INTE NO-UNDO.

  DETALLE:
  FOR EACH ITEM EXCLUSIVE-LOCK WHERE ITEM.codmat <> x-articulo-ICBPER:
      ASSIGN ITEM.Libre_d01 = ITEM.CanPed.
  END.

  /* GRABAMOS INFORMACION FINAL */
  FOR EACH ITEM WHERE ITEM.CanPed > 0 BY ITEM.NroItm:
      I-NITEM = I-NITEM + 1.
      CREATE Facdpedi.
      BUFFER-COPY ITEM TO Facdpedi
          ASSIGN
            Facdpedi.CodCia = Faccpedi.CodCia
            Facdpedi.CodDiv = Faccpedi.CodDiv
            Facdpedi.coddoc = Faccpedi.coddoc
            Facdpedi.NroPed = Faccpedi.NroPed
            Facdpedi.FchPed = Faccpedi.FchPed
            Facdpedi.Hora   = Faccpedi.Hora 
            Facdpedi.FlgEst = Faccpedi.FlgEst
            Facdpedi.NroItm = I-NITEM
            Facdpedi.CanPick = Facdpedi.CanPed.   /* OJO */
  END.

  /* verificamos que al menos exista 1 item grabado */
  FIND FIRST Facdpedi OF Faccpedi NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Facdpedi 
  THEN RETURN 'ADM-ERROR'.
  ELSE RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE WRITE-HEADER V-table-Win 
PROCEDURE WRITE-HEADER :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pAdmNewRecord AS CHAR.

DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* BLOQUEAMOS CABECERA NUEVAMENTE: Se supone que solo un vendedor está manipulando la cotización */
    FIND CURRENT FacCPedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR = YES  THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.

    /* ************************************************************************** */
    /* NOTA: Descuento por Encarte y Descuento por Vol. x Linea SON EXCLUYENTES,
            es decir, NO pueden darse a la vez, o es uno o es el otro */
    /* ************************************************************************** */
    RUN DESCUENTOS-FINALES (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'ERROR al aplicar los descuentos totales a la cotización'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* ****************************************************************************************** */
    /* Grabamos Totales */
    /* ****************************************************************************************** */
    DEF VAR hProc AS HANDLE NO-UNDO.
    &IF {&ARITMETICA-SUNAT} &THEN
        {vtagn/totales-cotizacion-sunat.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
        /* ****************************************************************************************** */
        /* Importes SUNAT */
        /* ****************************************************************************************** */
        RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
        RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                                     INPUT Faccpedi.CodDoc,
                                     INPUT Faccpedi.NroPed,
                                     OUTPUT pMensaje).
        IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
        DELETE PROCEDURE hProc.
    &ELSE
        {vta2/graba-totales-cotizacion-cred.i}
        /* ****************************************************************************************** */
        /* Importes SUNAT */
        /* NO actualiza valores Progress */
        /* ****************************************************************************************** */
        RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
        RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                                     INPUT Faccpedi.CodDoc,
                                     INPUT Faccpedi.NroPed,
                                     OUTPUT pMensaje).
        IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
        DELETE PROCEDURE hProc.
    &ENDIF
    /* ****************************************************************************************** */
    /* Actualizamos la cotizacion */
    IF Faccpedi.CodRef = "C/M" THEN DO:
        RUN vta2/actualiza-cotizacion-01 ( ROWID(Faccpedi), +1, OUTPUT pMensaje ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.
    IF Faccpedi.CodRef = "PPV" THEN DO:
        RUN actualiza-prepedido ( ROWID(Faccpedi), +1, OUTPUT pMensaje ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.
END.

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

    x-alfabetico = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZabcdefghijklmnñopqrstuvwxyz".
    IF INDEX(x-alfabetico,pCaracter) > 0 THEN x-retval = YES.

  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSoloLetras V-table-Win 
FUNCTION getSoloLetras RETURNS LOGICAL
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

