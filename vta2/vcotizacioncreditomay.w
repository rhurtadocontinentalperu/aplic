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
DEFINE TEMP-TABLE ITEM-2 NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE PEDI NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE t-lgcocmp LIKE LG-COCmp.
DEFINE TEMP-TABLE t-lgdocmp LIKE LG-DOCmp.



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
DEF SHARED VAR s-DiasVtoCot LIKE GN-DIVI.DiasVtoCot.
DEF SHARED VAR s-codven AS CHAR.
DEF SHARED VAR lh_Handle AS HANDLE.
DEF SHARED VAR s-nrodec AS INT.
DEF SHARED VAR s-tpoped AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-flgigv AS LOG.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-import-ibc AS LOG.
DEF SHARED VAR s-import-cissac AS LOG.
DEF SHARED VAR s-adm-new-record AS CHAR.
DEF SHARED VARIABLE S-NROPED AS CHAR.
DEF SHARED VAR pCodDiv  AS CHAR.        /* DIVISION DE LA LISTA DE PRECIOS */
DEF SHARED VAR S-CMPBNTE  AS CHAR.

DEF SHARED TEMP-TABLE T-DPEDI LIKE FacDPedi.

DEF VAR s-copia-registro AS LOG.
DEF VAR s-cndvta-validos AS CHAR.
DEF VAR F-Observa        AS CHAR.
DEFINE VARIABLE s-pendiente-ibc AS LOG.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE VAR x-ClientesVarios AS CHAR.
x-ClientesVarios = FacCfgGn.CliVar.     /* 11 digitos */

/* 03Oct2014 - Plaza Vea cambio B2B*/
DEF TEMP-TABLE tt-OrdenesPlazVea
    FIELD tt-nroorden AS CHAR FORMAT 'x(15)'
    FIELD tt-codclie AS CHAR FORMAT 'x(11)'
    FIELD tt-locentrega AS CHAR FORMAT 'x(8)'.

DEFINE VAR lOrdenGrabada AS CHAR.

lOrdenGrabada = "".
    
DEF TEMP-TABLE ResumenxLinea
    FIELD codmat LIKE almmmatg.codmat
    FIELD codfam LIKE almmmatg.codfam
    FIELD subfam LIKE almmmatg.subfam
    FIELD canped LIKE facdpedi.canped
    INDEX Llave01 AS PRIMARY /*UNIQUE*/ codmat codfam subfam.

DEF TEMP-TABLE ErroresxLinea LIKE ResumenxLinea.

/* VARIABLES PARA EL EXCEL */
DEFINE VARIABLE chExcelApplication  AS COM-HANDLE.
DEFINE VARIABLE chWorkbook          AS COM-HANDLE.
DEFINE VARIABLE chWorksheet         AS COM-HANDLE.
DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
/*DEFINE VARIABLE t-Column        AS INTEGER INIT 1.*/
DEFINE VARIABLE t-Row           AS INTEGER INIT 1.

DEF VAR ImpMinPercep AS DEC INIT 1500 NO-UNDO.
DEF VAR ImpMinDNI    AS DEC INIT 700 NO-UNDO.

DEF VAR x-articulo-ICBPER AS CHAR NO-UNDO.

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
&Scoped-Define ENABLED-FIELDS FacCPedi.CodCli FacCPedi.FaxCli ~
FacCPedi.RucCli FacCPedi.Atencion FacCPedi.fchven FacCPedi.NomCli ~
FacCPedi.FchEnt FacCPedi.DirCli FacCPedi.Sede FacCPedi.ordcmp ~
FacCPedi.LugEnt FacCPedi.Cmpbnte FacCPedi.Glosa FacCPedi.CodMon ~
FacCPedi.CodVen FacCPedi.TpoCmb FacCPedi.FmaPgo FacCPedi.FlgIgv ~
FacCPedi.NroCard FacCPedi.Libre_d01 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.Libre_c01 ~
FacCPedi.FchPed FacCPedi.CodCli FacCPedi.FaxCli FacCPedi.RucCli ~
FacCPedi.Atencion FacCPedi.fchven FacCPedi.NomCli FacCPedi.FchEnt ~
FacCPedi.DirCli FacCPedi.usuario FacCPedi.Sede FacCPedi.ordcmp ~
FacCPedi.LugEnt FacCPedi.Cmpbnte FacCPedi.Glosa FacCPedi.CodMon ~
FacCPedi.CodVen FacCPedi.TpoCmb FacCPedi.FmaPgo FacCPedi.FlgIgv ~
FacCPedi.NroCard FacCPedi.Libre_d01 FacCPedi.LugEnt2 FacCPedi.CodRef ~
FacCPedi.NroRef 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS F-Estado FILL-IN-sede f-NomVen F-CndVta ~
F-Nomtar PuntoDistribucion 

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

DEFINE VARIABLE FILL-IN-sede AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE PuntoDistribucion AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52.14 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.NroPed AT ROW 1 COL 16 COLON-ALIGNED WIDGET-ID 58
          LABEL "Número" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     F-Estado AT ROW 1 COL 34 COLON-ALIGNED WIDGET-ID 114
     FacCPedi.Libre_c01 AT ROW 1 COL 65 COLON-ALIGNED WIDGET-ID 126
          LABEL "Lista Precios" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 14 FGCOLOR 0 
     FacCPedi.FchPed AT ROW 1 COL 99 COLON-ALIGNED WIDGET-ID 46
          LABEL "Fecha de Emisión"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.CodCli AT ROW 1.77 COL 16 COLON-ALIGNED WIDGET-ID 38
          LABEL "Cliente"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.FaxCli AT ROW 1.77 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 124 FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
          FONT 6
     FacCPedi.RucCli AT ROW 1.77 COL 47 COLON-ALIGNED WIDGET-ID 60
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.Atencion AT ROW 1.77 COL 65 COLON-ALIGNED WIDGET-ID 88
          LABEL "DNI" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.fchven AT ROW 1.77 COL 99 COLON-ALIGNED WIDGET-ID 48 FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.NomCli AT ROW 2.54 COL 16 COLON-ALIGNED WIDGET-ID 54 FORMAT "x(256)"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.FchEnt AT ROW 2.54 COL 99 COLON-ALIGNED WIDGET-ID 130
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.DirCli AT ROW 3.31 COL 16 COLON-ALIGNED WIDGET-ID 44
          LABEL "Dirección" FORMAT "x(256)"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.usuario AT ROW 3.31 COL 99 COLON-ALIGNED WIDGET-ID 66
          LABEL "Digitado por"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.Sede AT ROW 4.08 COL 16 COLON-ALIGNED WIDGET-ID 62
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FILL-IN-sede AT ROW 4.08 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     FacCPedi.ordcmp AT ROW 4.08 COL 99 COLON-ALIGNED WIDGET-ID 118
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.LugEnt AT ROW 4.85 COL 16 COLON-ALIGNED WIDGET-ID 112
          LABEL "Entregar en" FORMAT "x(256)"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.Cmpbnte AT ROW 4.85 COL 101 NO-LABEL WIDGET-ID 102
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Factura", "FAC":U,
"Boleta", "BOL":U
          SIZE 15 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.Glosa AT ROW 5.62 COL 16 COLON-ALIGNED WIDGET-ID 110
          LABEL "Glosa" FORMAT "X(256)"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.CodMon AT ROW 5.62 COL 101 NO-LABEL WIDGET-ID 78
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dólares", 2
          SIZE 15 BY .81
          BGCOLOR 11 FGCOLOR 0 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     FacCPedi.CodVen AT ROW 6.38 COL 16 COLON-ALIGNED WIDGET-ID 42
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
          BGCOLOR 11 FGCOLOR 0 
     f-NomVen AT ROW 6.38 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 94
     FacCPedi.TpoCmb AT ROW 6.38 COL 99 COLON-ALIGNED WIDGET-ID 64
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FacCPedi.FmaPgo AT ROW 7.15 COL 16 COLON-ALIGNED WIDGET-ID 50
          LABEL "Condición de Venta"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
          BGCOLOR 11 FGCOLOR 0 
     F-CndVta AT ROW 7.15 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 90
     FacCPedi.FlgIgv AT ROW 7.15 COL 101 WIDGET-ID 116
          LABEL "Afecto a IGV"
          VIEW-AS TOGGLE-BOX
          SIZE 12 BY .77
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.NroCard AT ROW 7.92 COL 16 COLON-ALIGNED WIDGET-ID 56
          LABEL "Tarjeta"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 FGCOLOR 0 
     F-Nomtar AT ROW 7.92 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 92
     FacCPedi.Libre_d01 AT ROW 7.92 COL 101 NO-LABEL WIDGET-ID 96
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "2", 2,
"3", 3,
"4", 4,
"5", 5
          SIZE 15 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.LugEnt2 AT ROW 8.69 COL 16 COLON-ALIGNED WIDGET-ID 132
          LABEL "Punto de Distribucion" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     PuntoDistribucion AT ROW 8.69 COL 23.86 COLON-ALIGNED NO-LABEL WIDGET-ID 134
     FacCPedi.CodRef AT ROW 8.69 COL 99 COLON-ALIGNED WIDGET-ID 120
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FacCPedi.NroRef AT ROW 8.69 COL 104 COLON-ALIGNED NO-LABEL WIDGET-ID 122
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 5.77 COL 95 WIDGET-ID 84
     "Comprobante:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 5.04 COL 91 WIDGET-ID 106
     "Redondedo del P.U.:" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 8.15 COL 86 WIDGET-ID 100
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
      TABLE: ITEM-2 T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: PEDI T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: t-lgcocmp T "?" ? INTEGRAL LG-COCmp
      TABLE: t-lgdocmp T "?" ? INTEGRAL LG-DOCmp
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
         HEIGHT             = 9.04
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

/* SETTINGS FOR FILL-IN FacCPedi.Atencion IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.CodRef IN FRAME F-Main
   NO-ENABLE                                                            */
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
/* SETTINGS FOR FILL-IN FacCPedi.FaxCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.FchPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.fchven IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-sede IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX FacCPedi.FlgIgv IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FmaPgo IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.Glosa IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.Libre_c01 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.LugEnt IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.LugEnt2 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.NomCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN FacCPedi.NroCard IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.NroRef IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN PuntoDistribucion IN FRAME F-Main
   NO-ENABLE                                                            */
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
        IF SELF:SCREEN-VALUE = 'FAC' 
            AND FacCPedi.CodCli:SCREEN-VALUE <> '11111111112'
            THEN DO:
            FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                AND gn-clie.CodCli = FacCPedi.CodCli:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
            ASSIGN
                FacCPedi.DirCli:SENSITIVE = NO
                FacCPedi.NomCli:SENSITIVE = NO
                FacCPedi.Atencion:SENSITIVE = NO.
            IF AVAILABLE gn-clie THEN DO:
                ASSIGN
                    FacCPedi.DirCli:SCREEN-VALUE = GN-CLIE.DirCli
                    FacCPedi.NomCli:SCREEN-VALUE = GN-CLIE.NomCli
                    FacCPedi.RucCli:SCREEN-VALUE = gn-clie.Ruc.
            END.
        END.
        ELSE DO:
            ASSIGN
                FacCPedi.DirCli:SENSITIVE = YES
                FacCPedi.NomCli:SENSITIVE = YES
                FacCPedi.Atencion:SENSITIVE = YES.
            IF FacCPedi.CodCli:SCREEN-VALUE = '11111111112' THEN FacCPedi.RucCli:SENSITIVE = YES.
        END.
        S-CMPBNTE = SELF:SCREEN-VALUE.
        RUN Procesa-Handle IN lh_Handle ('Recalculo').
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodCli V-table-Win
ON LEAVE OF FacCPedi.CodCli IN FRAME F-Main /* Cliente */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.

  RUN vtagn/p-gn-clie-01 (SELF:SCREEN-VALUE, s-CodDoc).
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  s-CodCli = SELF:SCREEN-VALUE.

  /* Cargamos las condiciones de venta válidas */
  FIND gn-clie WHERE gn-clie.codcia  = cl-codcia
      AND gn-clie.codcli = s-codcli
      NO-LOCK.
  RUN vta2/p-fmapgo (s-codcli, s-tpoped, OUTPUT s-cndvta-validos).
  IF FacCPedi.FmaPgo:SCREEN-VALUE = "" THEN s-CndVta = ENTRY(1, s-cndvta-validos).
  ELSE s-CndVta = FacCPedi.FmaPgo:SCREEN-VALUE.
  /* ****************************************** */
  DISPLAY 
    gn-clie.NomCli @ Faccpedi.NomCli
    gn-clie.Ruc    @ Faccpedi.RucCli
    gn-clie.DirCli @ Faccpedi.DirCli
    s-CndVta @ FacCPedi.FmaPgo
    gn-clie.NroCard @ FacCPedi.NroCard
    gn-clie.CodVen WHEN Faccpedi.CodVen:SCREEN-VALUE = '' @ Faccpedi.CodVen 
    WITH FRAME {&FRAME-NAME}.
/*   ASSIGN                                     */
/*       S-CNDVTA = ENTRY(1, s-cndvta-validos). */

  /* Tarjeta */
  FIND Gn-Card WHERE Gn-Card.NroCard = gn-clie.nrocard NO-LOCK NO-ERROR.
  IF AVAILABLE GN-CARD 
  THEN ASSIGN
            F-NomTar:SCREEN-VALUE = GN-CARD.NomClie[1]
            FacCPedi.NroCard:SENSITIVE = NO.
  ELSE ASSIGN
            F-NomTar:SCREEN-VALUE = ''
            FacCPedi.NroCard:SENSITIVE = YES.
  
  /* Ubica la Condicion Venta */
  FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt 
  THEN DO:
       F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
  END.  
  ELSE F-CndVta:SCREEN-VALUE = "".

  IF FacCPedi.FmaPgo:SCREEN-VALUE = '900' 
    AND FacCPedi.Glosa:SCREEN-VALUE = ''
  THEN FacCPedi.Glosa:SCREEN-VALUE = 'BONIFICACION DE CAMPAÑA POR COMPRA POR VOLUMEN'.

  /* Vendedor */
  F-NomVen:SCREEN-VALUE = "".
  FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
      AND  gn-ven.CodVen = FacCPedi.CodVen:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-ven THEN F-NomVen:SCREEN-VALUE = gn-ven.NomVen.

  /* CLASIFICACIONES DEL CLIENTE */
  Faccpedi.FaxCli:SCREEN-VALUE = SUBSTRING(TRIM(gn-clie.clfcli) + "00",1,2) +
                                SUBSTRING(TRIM(gn-clie.clfcli2) + "00",1,2).

  /* Recalculamos cotizacion */
  RUN Procesa-Handle IN lh_Handle ('Recalculo').

  /* Determina si es boleta o factura */
  IF FacCPedi.RucCli:SCREEN-VALUE = ''
  THEN Faccpedi.Cmpbnte:SCREEN-VALUE = 'BOL'.
  ELSE Faccpedi.Cmpbnte:SCREEN-VALUE = 'FAC'.
  APPLY 'VALUE-CHANGED' TO Faccpedi.Cmpbnte.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodCli V-table-Win
ON LEFT-MOUSE-DBLCLICK OF FacCPedi.CodCli IN FRAME F-Main /* Cliente */
OR f8 OF FacCPedi.CodCli
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
  RUN Procesa-Handle IN lh_Handle ('Recalculo').
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
OR f8 OF FacCPedi.CodVen
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
    RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FmaPgo V-table-Win
ON LEAVE OF FacCPedi.FmaPgo IN FRAME F-Main /* Condición de Venta */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FmaPgo V-table-Win
ON LEFT-MOUSE-DBLCLICK OF FacCPedi.FmaPgo IN FRAME F-Main /* Condición de Venta */
OR f8 OF FacCPedi.FmaPgo
DO:
    ASSIGN
        input-var-1 = s-cndvta-validos
        input-var-2 = ''
        input-var-3 = ''.
    RUN vta/d-cndvta.
    IF output-var-1 <> ? THEN FacCPedi.Fmapgo:SCREEN-VALUE = output-var-2.
    /*APPLY 'ENTRY':U TO FacCPedi.Fmapgo.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.Libre_d01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.Libre_d01 V-table-Win
ON VALUE-CHANGED OF FacCPedi.Libre_d01 IN FRAME F-Main /* Libre_d01 */
DO:
    s-NroDec = INTEGER(SELF:SCREEN-VALUE).
    RUN Procesa-Handle IN lh_Handle ('Recalculo').
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
OR f8 OF FacCPedi.NroCard
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


&Scoped-define SELF-NAME FacCPedi.Sede
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.Sede V-table-Win
ON LEAVE OF FacCPedi.Sede IN FRAME F-Main /* Sede */
DO:
    FILL-IN-Sede:SCREEN-VALUE = "".
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    FIND gn-clied WHERE gn-clied.codcia = cl-codcia
        AND gn-clied.codcli = Faccpedi.codcli:SCREEN-VALUE
        AND gn-clied.sede = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clied THEN DO:
        MESSAGE "Sede NO válida" VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
    ASSIGN 
        FILL-IN-Sede:SCREEN-VALUE = Gn-ClieD.DirCli
        FacCPedi.LugEnt:SCREEN-VALUE = Gn-ClieD.DirCli
        FacCPedi.Glosa:SCREEN-VALUE = (IF FacCPedi.Glosa:SCREEN-VALUE = '' THEN Gn-ClieD.DirCli ELSE FacCPedi.Glosa:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.Sede V-table-Win
ON LEFT-MOUSE-DBLCLICK OF FacCPedi.Sede IN FRAME F-Main /* Sede */
OR f8 OF FacCPedi.Sede
DO:
    ASSIGN
      input-var-1 = FacCPedi.CodCli:SCREEN-VALUE
      input-var-2 = FacCPedi.NomCli:SCREEN-VALUE
      input-var-3 = ''
      output-var-1 = ?
      output-var-2 = ''
      output-var-3 = ''.
    RUN vta/c-clied.
    IF output-var-1 <> ?
        THEN ASSIGN 
              FILL-IN-Sede:SCREEN-VALUE = output-var-2
              FacCPedi.LugEnt:SCREEN-VALUE = output-var-2
              FacCPedi.Glosa:SCREEN-VALUE = (IF FacCPedi.Glosa:SCREEN-VALUE = '' THEN output-var-2 ELSE FacCPedi.Glosa:SCREEN-VALUE)
              FacCPedi.Sede:SCREEN-VALUE = output-var-3.
    /*APPLY 'ENTRY':U TO FacCPedi.Sede.*/
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
    IF RETURN-VALUE <> "ADM-ERROR"  THEN APPLY "LEAVE":U TO FacCPedi.CodCli IN FRAME {&FRAME-NAME}.
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

  FOR EACH FacDPedi OF FacCPedi TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' 
      ON STOP UNDO, RETURN 'ADM-ERROR':
      DELETE FacDPedi.
  END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Historico-Cotizaciones V-table-Win 
PROCEDURE Captura-Historico-Cotizaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF s-codcli = '' THEN RETURN.
  DEF VAR pError AS CHAR NO-UNDO.
  RUN vta2/d-historicocotcredmay (s-codcli, "COT", OUTPUT pError).
  IF pError = "ADM-ERROR" THEN RETURN.
   RUN Recalcular-Precios.

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

FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.Libre_c05 <> "OF" :
    CREATE ITEM.
    BUFFER-COPY Facdpedi TO ITEM.
    IF Facdpedi.Libre_c04 = "DCAMPANA" THEN ITEM.Por_Dsctos[3] = 0.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Control-IBC V-table-Win 
PROCEDURE Control-IBC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Rpta AS CHAR.
                                  
/* Cargamos el temporal con las diferencias */
s-pendiente-ibc = NO.
RUN Procesa-Handle IN lh_handle ('IBC').
FIND FIRST T-DPEDI NO-LOCK NO-ERROR.
IF NOT AVAILABLE T-DPEDI THEN RETURN 'OK'.

RUN vta/d-ibc-dif (OUTPUT x-Rpta).
IF x-Rpta = "ADM-ERROR" THEN RETURN "ADM-ERROR".

{adm/i-DocPssw.i s-CodCia 'IBC' ""UPD""}

/* Continua la grabacion */
s-pendiente-ibc = YES.

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
    FOR EACH facdPedi OF faccPedi NO-LOCK:
        CREATE ITEM.
        ASSIGN
            ITEM.AftIgv = Facdpedi.AftIgv
            ITEM.AftIsc = Facdpedi.AftIsc
            ITEM.AlmDes = Facdpedi.AlmDes
            ITEM.CanPed = Facdpedi.CanPed
            ITEM.CanPick = Facdpedi.CanPed
            ITEM.CodCia = Facdpedi.CodCia
            ITEM.CodCli = Facdpedi.CodCli
            ITEM.CodDiv = Facdpedi.CodDiv
            ITEM.CodDoc = Facdpedi.CodDoc
            ITEM.codmat = Facdpedi.CodMat
            ITEM.Factor = Facdpedi.Factor
            ITEM.FchPed = TODAY
            ITEM.NroItm = Facdpedi.NroItm
            ITEM.Pesmat = Facdpedi.PesMat
            ITEM.TipVta = Facdpedi.TipVta
            ITEM.UndVta = Facdpedi.UndVta.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuentos-Finales-01 V-table-Win 
PROCEDURE Descuentos-Finales-01 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/descuentoxvolumenxlinearesumida.i}

/*
/* ********************************************************** */
/* RHC 14/10/2013 Descuentos por Volumen de Compra Acumulados */
/* ********************************************************** */
/*IF LOOKUP(s-TpoPed, "E,P") = 0 THEN RETURN.*/

DEF VAR j AS INT NO-UNDO.
DEF VAR x-Canti AS DEC NO-UNDO.
DEF VAR x-Rango AS DEC NO-UNDO.
DEF VAR x-DctoxVolumen AS DECIMAL DECIMALS 4 NO-UNDO.
DEF VAR F-PREBAS AS DEC DECIMALS 4 NO-UNDO.
DEF VAR F-PREVTA AS DEC DECIMALS 4 NO-UNDO.
DEF VAR Y-DSCTOS AS DEC NO-UNDO.                /* Descuento por Volumen y/o Promocional */
DEF VAR X-TIPDTO AS CHAR NO-UNDO.               /* Tipo de descuento aplicado (PROM, VOL) */ 
DEF VAR F-FACTOR AS DECI NO-UNDO.

EMPTY TEMP-TABLE ResumenxLinea.
EMPTY TEMP-TABLE ErroresxLinea.

FOR EACH facdpedi OF Faccpedi NO-LOCK,
    FIRST Almmmatg OF Facdpedi NO-LOCK,
    FIRST Almsfami OF Almmmatg NO-LOCK,
    FIRST FacTabla NO-LOCK WHERE FacTabla.codcia = s-codcia
        AND FacTabla.Tabla = "DVXDSF"
        AND FacTabla.Codigo = TRIM(pCodDiv) + '|' + TRIM(Almsfami.codfam) + '|' + TRIM(Almsfami.subfam)
        AND FacTabla.Nombre <> "":
    /* Transformamos la cantidad en unidad base a cantidad en unidad de dcto x volumen */
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas
        AND Almtconv.Codalter = FacTabla.Nombre
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP
            '        Unidad Base:' Almmmatg.UndBas SKIP
            'Unidad de Sub-Linea:' FacTabla.Nombre SKIP(1)
            'SE CONTINUARÁ CON OTRO ARTÍCULO' SKIP(2)
            '*** Avisar a Sistemas ***'
            VIEW-AS ALERT-BOX WARNING TITLE "DESCUENTO POR VOLUMEN POR LINEA".
        FIND ErroresxLinea OF Almmmatg NO-ERROR.
        IF NOT AVAILABLE ErroresxLinea THEN CREATE ErroresxLinea.
        ASSIGN
            ErroresxLinea.codfam = Almmmatg.codfam
            ErroresxLinea.subfam = Almmmatg.subfam.
        NEXT.
    END.
    ASSIGN
        F-FACTOR = Almtconv.Equival.
    /* ******************************************************************************* */
    FIND ResumenxLinea OF Almmmatg NO-ERROR.
    IF NOT AVAILABLE ResumenxLinea THEN CREATE ResumenxLinea.
    ASSIGN
        ResumenxLinea.codfam = Almmmatg.codfam
        ResumenxLinea.subfam = Almmmatg.subfam
        ResumenxLinea.canped = ResumenxLinea.canped + (facdpedi.canped * facdpedi.factor / f-Factor).
END.
/* Eliminamos las lineas con errores */
FOR EACH ErroresxLinea:
    FIND ResumenxLinea WHERE ResumenxLinea.codfam = ErroresxLinea.codfam
        AND ResumenxLinea.subfam = ErroresxLinea.subfam
        NO-ERROR.
    IF AVAILABLE ResumenxLinea THEN DELETE ResumenxLinea.
END.

FOR EACH ResumenxLinea, 
    FIRST Almsfami NO-LOCK WHERE Almsfami.codcia = s-codcia
        AND Almsfami.codfam = ResumenxLinea.codfam
        AND Almsfami.subfam = ResumenxLinea.subfam,
    FIRST FacTabla NO-LOCK WHERE FacTabla.codcia = s-codcia
        AND FacTabla.Tabla = "DVXDSF"
        AND FacTabla.Codigo = TRIM(pCodDiv) + '|' + TRIM(Almsfami.codfam) + '|' + TRIM(Almsfami.subfam):
    ASSIGN
        x-DctoxVolumen = 0
        x-Rango = 0
        X-CANTI = ResumenxLinea.canped.
    DO J = 1 TO 10:
        IF X-CANTI >= FacTabla.Valor[j] AND FacTabla.Valor[j + 10] > 0  THEN DO:
            IF X-RANGO  = 0 THEN X-RANGO = FacTabla.Valor[j].
            IF X-RANGO <= FacTabla.Valor[j] THEN DO:
                ASSIGN
                    X-RANGO  = FacTabla.Valor[j]
                    x-DctoxVolumen = FacTabla.Valor[j + 10].
            END.   
        END.   
    END.
    IF x-DctoxVolumen > 0 THEN DO:
        FOR EACH Facdpedi OF Faccpedi, 
            FIRST Almmmatg OF Facdpedi NO-LOCK WHERE Almmmatg.codfam = ResumenxLinea.codfam 
                AND Almmmatg.subfam = ResumenxLinea.subfam:
            /* Recalculamos todos los Items */
            ASSIGN
                F-PREBAS = Almmmatg.PreVta[1]       /* OJO => Se cambia Precio Base */
                Y-DSCTOS = x-DctoxVolumen          /* OJO */
                X-TIPDTO = "DVXDSF".
            /* ******************************** */
            /* PRECIO BASE A LA MONEDA DE VENTA */
            /* ******************************** */
            IF S-CODMON = 1 THEN DO:
                IF Almmmatg.MonVta = 1 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
                ELSE ASSIGN F-PREBAS = F-PREBAS * S-TPOCMB /** F-FACTOR*/.
            END.
            IF S-CODMON = 2 THEN DO:
                IF Almmmatg.MonVta = 2 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
                ELSE ASSIGN F-PREBAS = (F-PREBAS / S-TPOCMB) /** F-FACTOR*/.
            END.
            F-PREVTA = F-PREBAS.
            /************************************************/
            RUN BIN/_ROUND1(F-PREVTA,s-NRODEC,OUTPUT F-PREVTA).
            /************************************************/
            ASSIGN 
                Facdpedi.PreUni = F-PREVTA
                Facdpedi.PreBas = F-PreBas 
                Facdpedi.PreVta[1] = F-PreVta   /* CONTROL DE PRECIO DE LISTA */
                Facdpedi.PorDto  = 0
                Facdpedi.PorDto2 = 0            /* el precio unitario */
                Facdpedi.Por_Dsctos[2] = 0
                Facdpedi.Por_Dsctos[3] = Y-DSCTOS 
                Facdpedi.ImpIsc = 0
                Facdpedi.ImpIgv = 0
                Facdpedi.Libre_c04 = x-TipDto.
            ASSIGN
                Facdpedi.ImpLin = ROUND ( Facdpedi.CanPed * Facdpedi.PreUni * 
                            ( 1 - Facdpedi.Por_Dsctos[1] / 100 ) *
                            ( 1 - Facdpedi.Por_Dsctos[2] / 100 ) *
                            ( 1 - Facdpedi.Por_Dsctos[3] / 100 ), 2 ).
            IF Facdpedi.Por_Dsctos[1] = 0 AND Facdpedi.Por_Dsctos[2] = 0 AND Facdpedi.Por_Dsctos[3] = 0 
                THEN Facdpedi.ImpDto = 0.
            ELSE Facdpedi.ImpDto = Facdpedi.CanPed * Facdpedi.PreUni - Facdpedi.ImpLin.
            ASSIGN
                Facdpedi.ImpLin = ROUND(Facdpedi.ImpLin, 2)
                Facdpedi.ImpDto = ROUND(Facdpedi.ImpDto, 2).
            IF Facdpedi.AftIsc THEN 
                Facdpedi.ImpIsc = ROUND(Facdpedi.PreBas * Facdpedi.CanPed * (Almmmatg.PorIsc / 100),4).
            ELSE Facdpedi.ImpIsc = 0.
            IF Facdpedi.AftIgv THEN  
                Facdpedi.ImpIgv = Facdpedi.ImpLin - ROUND(Facdpedi.ImpLin  / (1 + (s-PorIgv / 100)),4).
            ELSE Facdpedi.ImpIgv = 0.
        END.
    END.
END.
*/


/*
DEF VAR j AS INT NO-UNDO.
DEF VAR x-Canti AS DEC NO-UNDO.
DEF VAR x-Rango AS DEC NO-UNDO.
DEF VAR x-DctoxVolumen AS DECIMAL DECIMALS 4 NO-UNDO.
DEF VAR F-PREBAS AS DEC DECIMALS 4 NO-UNDO.
DEF VAR F-PREVTA AS DEC DECIMALS 4 NO-UNDO.
DEF VAR Y-DSCTOS AS DEC NO-UNDO.                /* Descuento por Volumen y/o Promocional */
DEF VAR X-TIPDTO AS CHAR NO-UNDO.               /* Tipo de descuento aplicado (PROM, VOL) */ 
DEF VAR F-FACTOR AS DECI NO-UNDO.

EMPTY TEMP-TABLE ResumenxLinea.
EMPTY TEMP-TABLE ErroresxLinea.

FOR EACH facdpedi OF Faccpedi NO-LOCK,
    FIRST Almmmatg OF Facdpedi NO-LOCK,
    FIRST Almsfami OF Almmmatg NO-LOCK WHERE AlmSFami.Libre_c04 = "SI",
    FIRST FacTabla NO-LOCK WHERE FacTabla.codcia = s-codcia
        AND FacTabla.Tabla = "DVXSF"
        AND FacTabla.Codigo = TRIM(Almsfami.codfam) + TRIM(Almsfami.subfam)
        AND FacTabla.Nombre <> "":
    /* Transformamos la cantidad en unidad base a cantidad en unidad de dcto x volumen */
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas
        AND Almtconv.Codalter = FacTabla.Nombre
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP
            '        Unidad Base:' Almmmatg.UndBas SKIP
            'Unidad de Sub-Linea:' FacTabla.Nombre SKIP(1)
            'SE CONTINUARÁ CON OTRO ARTÍCULO' SKIP(2)
            '*** Avisar a Sistemas ***'
            VIEW-AS ALERT-BOX WARNING TITLE "DESCUENTO POR VOLUMEN POR LINEA".
        FIND ErroresxLinea OF Almmmatg NO-ERROR.
        IF NOT AVAILABLE ErroresxLinea THEN CREATE ErroresxLinea.
        ASSIGN
            ErroresxLinea.codfam = Almmmatg.codfam
            ErroresxLinea.subfam = Almmmatg.subfam.
        NEXT.
    END.
    ASSIGN
        F-FACTOR = Almtconv.Equival.
    /* ******************************************************************************* */
    FIND ResumenxLinea OF Almmmatg NO-ERROR.
    IF NOT AVAILABLE ResumenxLinea THEN CREATE ResumenxLinea.
    ASSIGN
        ResumenxLinea.codfam = Almmmatg.codfam
        ResumenxLinea.subfam = Almmmatg.subfam
        ResumenxLinea.canped = ResumenxLinea.canped + (facdpedi.canped * facdpedi.factor / f-Factor).
END.
/* Eliminamos las lineas con errores */
FOR EACH ErroresxLinea:
    FIND ResumenxLinea WHERE ResumenxLinea.codfam = ErroresxLinea.codfam
        AND ResumenxLinea.subfam = ErroresxLinea.subfam
        NO-ERROR.
    IF AVAILABLE ResumenxLinea THEN DELETE ResumenxLinea.
END.

FOR EACH ResumenxLinea, 
    FIRST Almsfami NO-LOCK WHERE Almsfami.codcia = s-codcia
        AND Almsfami.codfam = ResumenxLinea.codfam
        AND Almsfami.subfam = ResumenxLinea.subfam,
    FIRST FacTabla NO-LOCK WHERE FacTabla.codcia = s-codcia
        AND FacTabla.Tabla = "DVXSF"
        AND FacTabla.Codigo = TRIM(Almsfami.codfam) + TRIM(Almsfami.subfam):
    ASSIGN
        x-DctoxVolumen = 0
        x-Rango = 0
        X-CANTI = ResumenxLinea.canped.
    DO J = 1 TO 10:
        IF X-CANTI >= FacTabla.Valor[j] AND FacTabla.Valor[j + 10] > 0  THEN DO:
            IF X-RANGO  = 0 THEN X-RANGO = FacTabla.Valor[j].
            IF X-RANGO <= FacTabla.Valor[j] THEN DO:
                ASSIGN
                    X-RANGO  = FacTabla.Valor[j]
                    x-DctoxVolumen = FacTabla.Valor[j + 10].
            END.   
        END.   
    END.
    IF x-DctoxVolumen > 0 THEN DO:
        FOR EACH Facdpedi OF Faccpedi, 
            FIRST Almmmatg OF Facdpedi NO-LOCK WHERE Almmmatg.codfam = ResumenxLinea.codfam 
                AND Almmmatg.subfam = ResumenxLinea.subfam:
            /* Recalculamos todos los Items */
            ASSIGN
                F-PREBAS = Almmmatg.PreVta[1]       /* OJO => Se cambia Precio Base */
                Y-DSCTOS = x-DctoxVolumen          /* OJO */
                X-TIPDTO = "DVXSF".
            /* ******************************** */
            /* PRECIO BASE A LA MONEDA DE VENTA */
            /* ******************************** */
            IF S-CODMON = 1 THEN DO:
                IF Almmmatg.MonVta = 1 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
                ELSE ASSIGN F-PREBAS = F-PREBAS * S-TPOCMB /** F-FACTOR*/.
            END.
            IF S-CODMON = 2 THEN DO:
                IF Almmmatg.MonVta = 2 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
                ELSE ASSIGN F-PREBAS = (F-PREBAS / S-TPOCMB) /** F-FACTOR*/.
            END.
            F-PREVTA = F-PREBAS.
            /************************************************/
            RUN BIN/_ROUND1(F-PREVTA,s-NRODEC,OUTPUT F-PREVTA).
            /************************************************/
            ASSIGN 
                Facdpedi.PreUni = F-PREVTA
                Facdpedi.PreBas = F-PreBas 
                Facdpedi.PreVta[1] = F-PreVta   /* CONTROL DE PRECIO DE LISTA */
                Facdpedi.PorDto  = 0
                Facdpedi.PorDto2 = 0            /* el precio unitario */
                Facdpedi.Por_Dsctos[2] = 0
                Facdpedi.Por_Dsctos[3] = Y-DSCTOS 
                Facdpedi.ImpIsc = 0
                Facdpedi.ImpIgv = 0.
            ASSIGN
                Facdpedi.ImpLin = ROUND ( Facdpedi.CanPed * Facdpedi.PreUni * 
                            ( 1 - Facdpedi.Por_Dsctos[1] / 100 ) *
                            ( 1 - Facdpedi.Por_Dsctos[2] / 100 ) *
                            ( 1 - Facdpedi.Por_Dsctos[3] / 100 ), 2 ).
            IF Facdpedi.Por_Dsctos[1] = 0 AND Facdpedi.Por_Dsctos[2] = 0 AND Facdpedi.Por_Dsctos[3] = 0 
                THEN Facdpedi.ImpDto = 0.
            ELSE Facdpedi.ImpDto = Facdpedi.CanPed * Facdpedi.PreUni - Facdpedi.ImpLin.
            ASSIGN
                Facdpedi.ImpLin = ROUND(Facdpedi.ImpLin, 2)
                Facdpedi.ImpDto = ROUND(Facdpedi.ImpDto, 2).
            IF Facdpedi.AftIsc THEN 
                Facdpedi.ImpIsc = ROUND(Facdpedi.PreBas * Facdpedi.CanPed * (Almmmatg.PorIsc / 100),4).
            ELSE Facdpedi.ImpIsc = 0.
            IF Facdpedi.AftIgv THEN  
                Facdpedi.ImpIgv = Facdpedi.ImpLin - ROUND(Facdpedi.ImpLin  / (1 + (s-PorIgv / 100)),4).
            ELSE Facdpedi.ImpIgv = 0.
        END.
    END.
END.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuentos-Finales-02 V-table-Win 
PROCEDURE Descuentos-Finales-02 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/descuentoxvolumenxsaldosresumidav2.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuentos-solo-campana V-table-Win 
PROCEDURE Descuentos-solo-campana :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/descuento-solo-campana.i}

/* DEF VAR x-Codigos AS CHAR NO-UNDO.                                                                                          */
/* DEF VAR x-ImpLin AS DEC NO-UNDO.                                                                                            */
/* DEF VAR x-Proveedores AS CHAR NO-UNDO.                                                                                      */
/*                                                                                                                             */
/* IF s-TpoPed = "N" AND TODAY <= 04/30/2014 THEN DO:                                                                          */
/*     x-Codigos = '036047,002688,017892,002735,002687,023296,025555,002854,022648,015989,001629,002794,061655,020036,023285'. */
/*     x-Proveedores = '10031028,52243548,42748137,10008522'.                                                                  */
/*     x-ImpLin = 0.                                                                                                           */
/*     /* NO debe tener otros descuentos */                                                                                    */
/*     FOR EACH Facdpedi OF Faccpedi WHERE (FacDPedi.Por_Dsctos[1] = 0                                                         */
/*                                          AND FacDPedi.Por_Dsctos[2] = 0                                                     */
/*                                          AND FacDPedi.Por_Dsctos[3] = 0)                                                    */
/*         AND Facdpedi.Libre_c05 <> "OF",                                                                                     */
/*         FIRST Almmmatg OF Facdpedi NO-LOCK:                                                                                 */
/*         CASE TRUE:                                                                                                          */
/*             WHEN LOOKUP(Facdpedi.codmat, x-Codigos) > 0 THEN x-ImpLin = x-ImpLin + Facdpedi.ImpLin.                         */
/*             WHEN LOOKUP(Almmmatg.codpr1, x-Proveedores) > 0 THEN x-ImpLin = x-ImpLin + Facdpedi.ImpLin.                     */
/*         END CASE.                                                                                                           */
/*     END.                                                                                                                    */
/*     IF Faccpedi.CodMon = 2 THEN x-ImpLin = x-ImpLin * Faccpedi.TpoCmb.                                                      */
/*     IF x-ImpLin < 250 THEN RETURN.  /* MONTO MINIMO */                                                                      */
/*     /* REGRABAMOS NUEVOS PORCENTAJES DE DESCUENTO Y RECALCULAMOS IMPORTES */                                                */
/*     FOR EACH Facdpedi OF Faccpedi WHERE (FacDPedi.Por_Dsctos[1] = 0                                                         */
/*                                          AND FacDPedi.Por_Dsctos[2] = 0                                                     */
/*                                          AND FacDPedi.Por_Dsctos[3] = 0)                                                    */
/*         AND Facdpedi.Libre_c05 <> "OF",     /* NO Promociones */                                                            */
/*         FIRST Almmmatg OF Facdpedi NO-LOCK:                                                                                 */
/*         IF LOOKUP(Facdpedi.codmat, x-Codigos) > 0 OR                                                                        */
/*             LOOKUP(Almmmatg.codpr1, x-Proveedores) > 0 THEN DO:                                                             */
/*             /* GRABAMOS NUEVOS PORCENTAJES PROMOCIONALES */                                                                 */
/*             Facdpedi.Libre_c04 = "DCAMPANA".    /* MARCA DE CONTROL */                                                      */
/*             Facdpedi.Por_Dsctos[3] = 4.5.                                                                                   */
/*             IF x-ImpLin >= 500 THEN Facdpedi.Por_Dsctos[3] = 6.                                                             */
/*             ASSIGN                                                                                                          */
/*                 Facdpedi.ImpLin = ROUND ( Facdpedi.CanPed * Facdpedi.PreUni *                                               */
/*                               ( 1 - Facdpedi.Por_Dsctos[1] / 100 ) *                                                        */
/*                               ( 1 - Facdpedi.Por_Dsctos[2] / 100 ) *                                                        */
/*                               ( 1 - Facdpedi.Por_Dsctos[3] / 100 ), 2 ).                                                    */
/*             IF Facdpedi.Por_Dsctos[1] = 0 AND Facdpedi.Por_Dsctos[2] = 0 AND Facdpedi.Por_Dsctos[3] = 0                     */
/*                 THEN Facdpedi.ImpDto = 0.                                                                                   */
/*                 ELSE Facdpedi.ImpDto = Facdpedi.CanPed * Facdpedi.PreUni - Facdpedi.ImpLin.                                 */
/*             ASSIGN                                                                                                          */
/*                 Facdpedi.ImpLin = ROUND(Facdpedi.ImpLin, 2)                                                                 */
/*                 Facdpedi.ImpDto = ROUND(Facdpedi.ImpDto, 2).                                                                */
/*             IF Facdpedi.AftIsc                                                                                              */
/*             THEN Facdpedi.ImpIsc = ROUND(Facdpedi.PreBas * Facdpedi.CanPed * (Almmmatg.PorIsc / 100),4).                    */
/*             ELSE Facdpedi.ImpIsc = 0.                                                                                       */
/*             IF Facdpedi.AftIgv                                                                                              */
/*             THEN Facdpedi.ImpIgv = Facdpedi.ImpLin - ROUND( Facdpedi.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).               */
/*             ELSE Facdpedi.ImpIgv = 0.                                                                                       */
/*         END.                                                                                                                */
/*     END.                                                                                                                    */
/* END.                                                                                                                        */

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

IF FacCPedi.FlgEst <> "A" THEN RUN vta2\r-impcot-superm (ROWID(FacCPedi)).
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

RUN vta2/d-cot-excel-utilex ( ROWID(Faccpedi), l-IncIgv).

/* **************************
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 6.
DEFINE VARIABLE F-PreUni                LIKE FacDPedi.Preuni.
DEFINE VARIABLE F-ImpLin                LIKE FacDPedi.ImpLin.
DEFINE VARIABLE F-ImpTot                LIKE FacCPedi.ImpTot.
DEFINE VARIABLE f-ImpDto                LIKE FacCPedi.ImpDto.

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

IF NUM-ENTRIES(FacCPedi.Observa,"-") - 1 > 6 THEN DO:
   DO K = 2 TO 7:
      IF ENTRY(K,FacCPedi.Observa,"-") <> "" THEN 
         C-OBS[1] = C-OBS[1] + "- " + ENTRY(K,FacCPedi.Observa,"-").
   END.
   DO K = 8 TO NUM-ENTRIES(FacCPedi.Observa,"-"):
      IF ENTRY(K,FacCPedi.Observa,"-") <> "" THEN 
         C-OBS[2] = C-OBS[2] + "- " + ENTRY(K,FacCPedi.Observa,"-").
   END.
END.
ELSE DO: 
   C-OBS[1] = FacCPedi.Observa.
   C-OBS[2] = "".
   /* 
   C-OBS[1] = SUBSTRING(FacCPedi.Observa,1,INDEX(FacCPedi.Observa,'@') - 1).
   C-OBS[2] = SUBSTRING(FacCPedi.Observa,INDEX(FacCPedi.Observa,'@') + 2).
   */
END.
/*IF FacCpedi.FlgIgv THEN DO:*/
IF l-incigv THEN DO:
   F-ImpTot = FacCPedi.ImpTot.
END.
ELSE DO:
   F-ImpTot = FacCPedi.ImpVta.
END.  

/* ************************ cargamos variables ********************* */
FIND gn-ven WHERE 
     gn-ven.CodCia = FacCPedi.CodCia AND  
     gn-ven.CodVen = FacCPedi.CodVen 
     NO-LOCK NO-ERROR.
C-NomVen = FacCPedi.CodVen.
IF AVAILABLE gn-ven THEN C-NomVen = C-NomVen + " - " + gn-ven.NomVen.
FIND gn-clie WHERE 
     gn-clie.codcia = cl-codcia AND  
     gn-clie.codcli = FacCPedi.codcli NO-LOCK NO-ERROR.
     
C-DESCLI  = Gn-clie.codcli + ' - ' + Gn-clie.Nomcli     .
C-DESCLI  = FaccPedi.codcli + ' - ' + FaccPedi.Nomcli     .

IF FacCPedi.coddoc = "PED" THEN 
    X-ORDCOM = "Orden de Compra : ".
ELSE 
    X-ORDCOM = "Solicitud Cotiz.: ".

FIND gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
C-NomCon = FacCPedi.FmaPgo.
IF AVAILABLE gn-ConVt THEN C-NomCon = gn-ConVt.Nombr.
IF FacCpedi.Codmon = 2 THEN DO: 
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
chWorkSheet:Range(cRange):Value = STRING(faccpedi.nroped,'999-999999'). 
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Señor(es) :" + c-descli. 
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Direccion :" + gn-clie.dircli. 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Emision         : " + STRING(faccpedi.fchped, '99/99/9999').
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Referencia :" . 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Vencimiento     : " + STRING(faccpedi.fchven, '99/99/9999') . 
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
FOR EACH facdpedi OF faccpedi NO-LOCK,
        FIRST almmmatg OF facdpedi NO-LOCK
        BREAK BY FacDPedi.NroPed BY FacDPedi.NroItm DESC:
    /*RDP01 - 
    IF FacCpedi.FlgIgv THEN DO:
       F-PreUni = FacDPedi.PreUni.
       F-ImpLin = FacDPedi.ImpLin. 
    END.
    ELSE DO:
       F-PreUni = ROUND(FacDPedi.PreUni / (1 + FacCPedi.PorIgv / 100),2).
       F-ImpLin = ROUND(FacDPedi.ImpLin / (1 + FacCPedi.PorIgv / 100),2). 
    END.  
    */

    IF l-incigv THEN DO:
       F-PreUni = FacDPedi.PreUni.
       F-ImpLin = FacDPedi.ImpLin. 
    END.
    ELSE DO:
       F-PreUni = ROUND(FacDPedi.PreUni / (1 + FacCPedi.PorIgv / 100),2).
       F-ImpLin = ROUND(FacDPedi.ImpLin / (1 + FacCPedi.PorIgv / 100),2). 
    END.  

    /*Agrega Row*/
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):EntireRow:INSERT.

    /*t-column = t-column + 1.*/
    p = p + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + STRING(facdpedi.nroitm, '>>>9').
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + facdpedi.codmat.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = facdpedi.canped.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = facdpedi.undvta.
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
    chWorkSheet:Range(cRange):Value = facdpedi.impdto.
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

     /* PERCEPCION */
     IF Faccpedi.acubon[5] > 0 THEN DO:
         t-column = t-column + 4.
         cColumn = STRING(t-Column).
         cRange = "A" + cColumn.
         chWorkSheet:Range(cRange):Value = "* Operación sujeta a percepción del IGV: " +
             (IF FacCPedi.codmon = 1 THEN "S/." ELSE "US$") + 
             TRIM(STRING(Faccpedi.acubon[5], '>>>,>>9.99')).
         t-column = t-column + 1.
     END.

/*RD01-Condicion Venta*/
FIND FIRST gn-convt WHERE gn-convt.codig =  facCPedi.fmapgo NO-LOCK NO-ERROR.
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

************************************* */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE genera-excel-vendedores V-table-Win 
PROCEDURE genera-excel-vendedores :
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
DEFINE VARIABLE F-PreUni                LIKE FacDPedi.Preuni.
DEFINE VARIABLE F-ImpLin                LIKE FacDPedi.ImpLin.
DEFINE VARIABLE F-ImpTot                LIKE FacCPedi.ImpTot.

/* Ic - 07May2015  */
DEFINE VAR x-Qty AS CHAR.
DEFINE VAR x-PU AS CHAR.
DEFINE VAR x-suma-Desde AS CHAR.
DEFINE VAR x-suma-Hasta AS CHAR.
DEFINE VAR x-ClasCli AS CHAR.

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

IF NUM-ENTRIES(FacCPedi.Observa,"-") - 1 > 6 THEN DO:
   DO K = 2 TO 7:
      IF ENTRY(K,FacCPedi.Observa,"-") <> "" THEN 
         C-OBS[1] = C-OBS[1] + "- " + ENTRY(K,FacCPedi.Observa,"-").
   END.
   DO K = 8 TO NUM-ENTRIES(FacCPedi.Observa,"-"):
      IF ENTRY(K,FacCPedi.Observa,"-") <> "" THEN 
         C-OBS[2] = C-OBS[2] + "- " + ENTRY(K,FacCPedi.Observa,"-").
   END.
END.
ELSE DO: 
   C-OBS[1] = FacCPedi.Observa.
   C-OBS[2] = "".
END.
/*IF FacCpedi.FlgIgv THEN DO:*/
IF l-incigv THEN DO:
   F-ImpTot = FacCPedi.ImpTot.
END.
ELSE DO:
   F-ImpTot = FacCPedi.ImpVta.
END.  

/* ************************ cargamos variables ********************* */
FIND gn-ven WHERE 
     gn-ven.CodCia = FacCPedi.CodCia AND  
     gn-ven.CodVen = FacCPedi.CodVen 
     NO-LOCK NO-ERROR.
C-NomVen = FacCPedi.CodVen.
IF AVAILABLE gn-ven THEN C-NomVen = C-NomVen + " - " + gn-ven.NomVen.
FIND gn-clie WHERE 
     gn-clie.codcia = cl-codcia AND  
     gn-clie.codcli = FacCPedi.codcli NO-LOCK NO-ERROR.
     
C-DESCLI  = Gn-clie.codcli + ' - ' + Gn-clie.Nomcli     .
C-DESCLI  = FaccPedi.codcli + ' - ' + FaccPedi.Nomcli     .

IF FacCPedi.coddoc = "PED" THEN 
    X-ORDCOM = "Orden de Compra : ".
ELSE 
    X-ORDCOM = "Solicitud Cotiz.: ".

FIND gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
C-NomCon = FacCPedi.FmaPgo.
IF AVAILABLE gn-ConVt THEN C-NomCon = gn-ConVt.Nombr.
IF FacCpedi.Codmon = 2 THEN DO: 
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
x-Plantilla = x-Plantilla + "Cotizacion_vendedores.xlt".

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
/* chWorkSheet:Range(cRange):Value = "COTIZACION Nº " + faccpedi.nroped. */
cRange = "G9".
chWorkSheet:Range(cRange):Value = STRING(faccpedi.nroped, 'XXX-XXXXXX'). 
chWorkSheet:Range(cRange):FONT:Bold = TRUE.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Señor(es) :" + c-descli. 

t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Direccion :" + gn-clie.dircli. 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Emision         : " + STRING(faccpedi.fchped, '99/99/9999').
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Referencia :" . 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Vencimiento     : " + STRING(faccpedi.fchven, '99/99/9999') . 
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
/* Ic 07May2015 */
x-suma-desde = "".
x-suma-hasta = "".

P = t-Column.
FOR EACH facdpedi OF faccpedi NO-LOCK,
        FIRST almmmatg OF facdpedi NO-LOCK
        BREAK BY FacDPedi.NroPed BY FacDPedi.NroItm DESC:
    /*RDP01 - 
    IF FacCpedi.FlgIgv THEN DO:
       F-PreUni = FacDPedi.PreUni.
       F-ImpLin = FacDPedi.ImpLin. 
    END.
    ELSE DO:
       F-PreUni = ROUND(FacDPedi.PreUni / (1 + FacCPedi.PorIgv / 100),2).
       F-ImpLin = ROUND(FacDPedi.ImpLin / (1 + FacCPedi.PorIgv / 100),2). 
    END.  
    */

    IF l-incigv THEN DO:
       /*F-PreUni = FacDPedi.PreUni.*/
       F-ImpLin = FacDPedi.ImpLin. 
       F-PreUni = FacDPedi.ImpLin / FacDPedi.CanPed.
    END.
    ELSE DO:
       /*F-PreUni = ROUND(FacDPedi.PreUni / (1 + FacCPedi.PorIgv / 100),2).*/
       F-ImpLin = ROUND(FacDPedi.ImpLin / (1 + FacCPedi.PorIgv / 100),2). 
       F-PreUni = ROUND(f-ImpLin / FacDPedi.CanPed,2).
    END.  

    IF almmmatg.monvta = 2 THEN DO:
        F-PreUni = almmmatg.preofi * almmmatg.tpocmb.
    END.
    ELSE DO: 
        F-PreUni = almmmatg.preofi.
    END.
    F-PreUni = round(F-PreUni,4).

    /*Agrega Row*/
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):EntireRow:INSERT.
    
    /*t-column = t-column + 1.*/
    p = p + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + STRING(facdpedi.nroitm, '>>>9').
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + facdpedi.codmat.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.
    x-Qty = cRange.
    /*chWorkSheet:Range(cRange):Value = facdpedi.canped.*/
    chWorkSheet:Range(cRange):Value = 0.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = facdpedi.undvta.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
   
    cRange = "Z" + cColumn.
    chWorkSheet:Range(cRange):Value = f-PreUni.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.

    cRange = "G" + cColumn.
    x-PU = cRange.
    x-ClasCli = "Y5".
    /*chWorkSheet:Range(cRange):Value = f-PreUni.*/
    chWorksheet:Range(cRange):NumberFormat = '###,###,##0.0000'.
    ASSIGN chWorkSheet:Range(cRange):VALUE = "= Z" + cColumn + "*((100 - " + x-ClasCli + ") / 100)" NO-ERROR.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.    

    cRange = "H" + cColumn.
    /*chWorkSheet:Range(cRange):Value = f-ImpLin.*/
    chWorksheet:Range(cRange):NumberFormat = '###,###,##0.00' .    
    chWorkSheet:Range(cRange):VALUE = "= " + x-Qty + " * " + x-PU.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.

    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.canemp.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.

    IF x-suma-hasta = "" THEN x-suma-hasta = cRange.
    x-suma-desde = cRange.
END.
t-column = p + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "TOTAL " + c-simmon.
chWorkSheet:Range(cRange):FONT:Bold = TRUE.
cRange = "H" + cColumn.
chWorksheet:Range(cRange):NumberFormat = '###,###,##0.00' .
ASSIGN chWorkSheet:Range(cRange):VALUE = "=SUMA(" + x-suma-desde + ":" + x-suma-hasta + ") " + CHR(13) NO-ERROR.
chWorkSheet:Range(cRange):FONT:Bold = TRUE.

t-column = t-column + 3.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
IF l-incigv THEN chWorkSheet:Range(cRange):Value = "* LOS PRECIOS INCLUYEN IGV.".
ELSE chWorkSheet:Range(cRange):Value = "* LOS PRECIOS NO INCLUYEN IGV.".

/* PERCEPCION */
IF Faccpedi.acubon[5] > 0 THEN DO:
    t-column = t-column + 4.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "* Operación sujeta a percepción del IGV: " +
        (IF FacCPedi.codmon = 1 THEN "S/." ELSE "US$") + 
        TRIM(STRING(Faccpedi.acubon[5], '>>>,>>9.99')).
    t-column = t-column + 1.
END.

/*RD01-Condicion Venta*/
FIND FIRST gn-convt WHERE gn-convt.codig =  facCPedi.fmapgo NO-LOCK NO-ERROR.
IF AVAIL gn-convt THEN DO:
    t-column = t-column + 1.
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
DEFINE VARIABLE F-PreUni                LIKE FacDPedi.Preuni.
DEFINE VARIABLE F-ImpLin                LIKE FacDPedi.ImpLin.
DEFINE VARIABLE F-ImpTot                LIKE FacCPedi.ImpTot.

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

IF NUM-ENTRIES(FacCPedi.Observa,"-") - 1 > 6 THEN DO:
   DO K = 2 TO 7:
      IF ENTRY(K,FacCPedi.Observa,"-") <> "" THEN 
         C-OBS[1] = C-OBS[1] + "- " + ENTRY(K,FacCPedi.Observa,"-").
   END.
   DO K = 8 TO NUM-ENTRIES(FacCPedi.Observa,"-"):
      IF ENTRY(K,FacCPedi.Observa,"-") <> "" THEN 
         C-OBS[2] = C-OBS[2] + "- " + ENTRY(K,FacCPedi.Observa,"-").
   END.
END.
ELSE DO: 
   C-OBS[1] = FacCPedi.Observa.
   C-OBS[2] = "".
END.
/*IF FacCpedi.FlgIgv THEN DO:*/
IF l-incigv THEN DO:
   F-ImpTot = FacCPedi.ImpTot.
END.
ELSE DO:
   F-ImpTot = FacCPedi.ImpVta.
END.  

/* ************************ cargamos variables ********************* */
FIND gn-ven WHERE 
     gn-ven.CodCia = FacCPedi.CodCia AND  
     gn-ven.CodVen = FacCPedi.CodVen 
     NO-LOCK NO-ERROR.
C-NomVen = FacCPedi.CodVen.
IF AVAILABLE gn-ven THEN C-NomVen = C-NomVen + " - " + gn-ven.NomVen.
FIND gn-clie WHERE 
     gn-clie.codcia = cl-codcia AND  
     gn-clie.codcli = FacCPedi.codcli NO-LOCK NO-ERROR.
     
C-DESCLI  = Gn-clie.codcli + ' - ' + Gn-clie.Nomcli     .
C-DESCLI  = FaccPedi.codcli + ' - ' + FaccPedi.Nomcli     .

IF FacCPedi.coddoc = "PED" THEN 
    X-ORDCOM = "Orden de Compra : ".
ELSE 
    X-ORDCOM = "Solicitud Cotiz.: ".

FIND gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
C-NomCon = FacCPedi.FmaPgo.
IF AVAILABLE gn-ConVt THEN C-NomCon = gn-ConVt.Nombr.
IF FacCpedi.Codmon = 2 THEN DO: 
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
/* chWorkSheet:Range(cRange):Value = "COTIZACION Nº " + faccpedi.nroped. */
cRange = "G9".
chWorkSheet:Range(cRange):Value = STRING(faccpedi.nroped, 'XXX-XXXXXX'). 
chWorkSheet:Range(cRange):FONT:Bold = TRUE.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Señor(es) :" + c-descli. 
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Direccion :" + gn-clie.dircli. 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Emision         : " + STRING(faccpedi.fchped, '99/99/9999').
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Referencia :" . 
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Vencimiento     : " + STRING(faccpedi.fchven, '99/99/9999') . 
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
FOR EACH facdpedi OF faccpedi NO-LOCK,
        FIRST almmmatg OF facdpedi NO-LOCK
        BREAK BY FacDPedi.NroPed BY FacDPedi.NroItm DESC:
    /*RDP01 - 
    IF FacCpedi.FlgIgv THEN DO:
       F-PreUni = FacDPedi.PreUni.
       F-ImpLin = FacDPedi.ImpLin. 
    END.
    ELSE DO:
       F-PreUni = ROUND(FacDPedi.PreUni / (1 + FacCPedi.PorIgv / 100),2).
       F-ImpLin = ROUND(FacDPedi.ImpLin / (1 + FacCPedi.PorIgv / 100),2). 
    END.  
    */

    IF l-incigv THEN DO:
       /*F-PreUni = FacDPedi.PreUni.*/
       F-ImpLin = FacDPedi.ImpLin. 
       F-PreUni = FacDPedi.ImpLin / FacDPedi.CanPed.
    END.
    ELSE DO:
       /*F-PreUni = ROUND(FacDPedi.PreUni / (1 + FacCPedi.PorIgv / 100),2).*/
       F-ImpLin = ROUND(FacDPedi.ImpLin / (1 + FacCPedi.PorIgv / 100),2). 
       F-PreUni = ROUND(f-ImpLin / FacDPedi.CanPed,2).
    END.  

    /*Agrega Row*/
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):EntireRow:INSERT.
    
    /*t-column = t-column + 1.*/
    p = p + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + STRING(facdpedi.nroitm, '>>>9').
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + facdpedi.codmat.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.    
    chWorkSheet:Range(cRange):Value = facdpedi.canped.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = facdpedi.undvta.
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

/* PERCEPCION */
IF Faccpedi.acubon[5] > 0 THEN DO:
    t-column = t-column + 4.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "* Operación sujeta a percepción del IGV: " +
        (IF FacCPedi.codmon = 1 THEN "S/." ELSE "US$") + 
        TRIM(STRING(Faccpedi.acubon[5], '>>>,>>9.99')).
    t-column = t-column + 1.
END.

/*RD01-Condicion Venta*/
FIND FIRST gn-convt WHERE gn-convt.codig =  facCPedi.fmapgo NO-LOCK NO-ERROR.
IF AVAIL gn-convt THEN DO:
    t-column = t-column + 1.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-entre-companias V-table-Win 
PROCEDURE Importar-entre-companias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR x-Cab AS CHAR NO-UNDO.
  DEF VAR x-Det AS CHAR NO-UNDO.
  DEF VAR x-Ok AS LOG.
  DEF VAR x-Item AS INT INIT 1 NO-UNDO.
  
  /* CONSISTENCIA PREVIA */
  DO WITH FRAME {&FRAME-NAME}:
    IF FacCPedi.CodCli:SCREEN-VALUE  = '' OR FacCPedi.CodCli:SCREEN-VALUE = FacCfgGn.CliVar THEN DO:
        MESSAGE 'Debe ingresar primero el cliente' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO FacCPedi.CodCli.
        RETURN.
    END.
    IF FacCPedi.FmaPgo:SCREEN-VALUE = ''
    THEN DO:
      MESSAGE 'Debe ingresar primero condicion de venta'
          VIEW-AS ALERT-BOX WARNING.
      APPLY 'ENTRY':U TO FacCPedi.FmaPgo.
      RETURN NO-APPLY.
    END.
  END.

  ASSIGN
    x-Cab = '\\inf251\intercambio\OCC*' + TRIM(FacCPedi.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME}) +
            "*.*".

  SYSTEM-DIALOG GET-FILE x-Cab
  FILTERS 'Ordenes de compra' 'OCC*.*'
  INITIAL-DIR "\\inf251\intercambio"
  RETURN-TO-START-DIR
  TITLE 'Selecciona la Orden de compra'
  MUST-EXIST
  USE-FILENAME
  UPDATE x-Ok.

  IF x-Ok = NO THEN RETURN "ADM-ERROR".

  x-Det = REPLACE(x-Cab, 'OCC', 'OCD').

  /* Datos de Cabecera */
  EMPTY TEMP-TABLE t-lgcocmp.
  EMPTY TEMP-TABLE t-lgdocmp.
  
  INPUT FROM VALUE(x-cab).
  REPEAT:
    CREATE t-lgcocmp.
    IMPORT t-lgcocmp.
  END.
  INPUT CLOSE.
  INPUT FROM VALUE(x-det).
  REPEAT:
    CREATE t-lgdocmp.
    IMPORT t-lgdocmp.
  END.
  INPUT CLOSE.


  FIND FIRST t-lgcocmp WHERE t-lgcocmp.codpro <> ''.
  DO WITH FRAME {&FRAME-NAME}:
      EMPTY TEMP-TABLE ITEM.
      ASSIGN
          FacCPedi.CodMon:SCREEN-VALUE = STRING(t-lgcocmp.codmon, '9')
          FacCPedi.ordcmp:SCREEN-VALUE = STRING(t-lgcocmp.nrodoc, '999999').
    FOR EACH t-lgdocmp WHERE t-lgdocmp.codmat <> '':
        CREATE ITEM.
        ASSIGN 
            ITEM.CodCia = s-codcia
            ITEM.codmat = t-lgdocmp.CodMat
            ITEM.Factor = 1
            ITEM.CanPed = t-lgdocmp.CanPedi
            ITEM.NroItm = x-Item
            ITEM.UndVta = t-lgdocmp.UndCmp
            ITEM.ALMDES = S-CODALM
            ITEM.AftIgv = (IF t-lgdocmp.IgvMat > 0 THEN YES ELSE NO)
            ITEM.ImpIgv = (IF t-lgdocmp.igvmat > 0 THEN t-lgdocmp.ImpTot / (1 + t-lgdocmp.IgvMat / 100) * t-lgdocmp.IgvMat / 100 ELSE 0)
            ITEM.ImpLin = t-lgdocmp.ImpTot
            ITEM.PreUni = ITEM.ImpLin / ITEM.CanPed.
        x-Item = x-Item + 1.
    END.
  END.
  
  /* BLOQUEAMOS CAMPOS */
  ASSIGN
      s-Import-Cissac = YES
      FacCPedi.CodCli:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      FacCPedi.CodMon:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      FacCPedi.Libre_d01:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Excel-Marco V-table-Win 
PROCEDURE Importar-Excel-Marco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE Faccpedi THEN RETURN.
DEFINE VAR RPTA AS CHAR.
DEFINE VAR cTipoPrecio AS CHAR.

RUN valida-update.
RUN Procesa-Handle IN lh_Handle ('Pagina1').
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN.
/* RECALCULAMOS LOS ITEMS ANTES */
EMPTY TEMP-TABLE ITEM-2.
FOR EACH ITEM:
    CREATE ITEM-2.
    BUFFER-COPY ITEM TO ITEM-2.
END.
RUN Recalcular-Precios.

/* IF NOT AVAILABLE FacCPedi THEN RETURN "ADM-ERROR".                 */
/* IF LOOKUP(FacCPedi.FlgEst,"E,P,T") = 0 THEN DO:                    */
/*     MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX ERROR.             */
/*     RETURN "ADM-ERROR".                                            */
/* END.                                                               */
/* IF FacCPedi.FchVen < TODAY THEN DO:                                */
/*     MESSAGE 'Cotización venció el' faccpedi.fchven SKIP            */
/*         'Acceso denegado' VIEW-AS ALERT-BOX ERROR.                 */
/*     RETURN "ADM-ERROR".                                            */
/* END.                                                               */
/* /* Si tiene atenciones parciales tambien se bloquea */             */
/* FIND FIRST facdpedi OF faccpedi WHERE CanAte > 0 NO-LOCK NO-ERROR. */
/* IF AVAILABLE facdpedi                                              */
/* THEN DO:                                                           */
/*     MESSAGE "La Cotización tiene atenciones parciales" SKIP        */
/*         "Acceso denegado"                                          */
/*         VIEW-AS ALERT-BOX ERROR.                                   */
/*     RETURN "ADM-ERROR".                                            */
/* END.                                                               */

DEFINE VARIABLE FILL-IN-Archivo AS CHAR NO-UNDO.
DEFINE VARIABLE OKpressed AS LOG NO-UNDO.
                                          
SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
    FILTERS "Archivos Excel (*.xls,*.xlsx)" "*.xls,*.xlsx"
    TITLE "COTIZACION CONTRATO MARCO"
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.

/* CREAMOS LA HOJA EXCEL */
CREATE "Excel.Application" chExcelApplication.
chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-Archivo).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

SESSION:SET-WAIT-STATE('GENERAL').

EMPTY TEMP-TABLE PEDI.  /* Limpiamos el temporal */
RUN Importar-Detalle-Excel-Marco (OUTPUT cTipoPrecio) NO-ERROR.
IF ERROR-STATUS:ERROR THEN EMPTY TEMP-TABLE PEDI.
SESSION:SET-WAIT-STATE('').

/* CERRAMOS EL EXCEL */
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 

/* Pasamos PEDI a ITEM */
IF NOT CAN-FIND(FIRST PEDI) THEN RETURN.    /* OJO */

/* Consistencia de ida y vuelta */
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
FOR EACH PEDI:
    FIND FIRST ITEM WHERE ITEM.codmat = PEDI.codmat NO-ERROR.
    IF NOT AVAILABLE ITEM THEN DO:
        MESSAGE 'Artículo' PEDI.codmat 'no registrado en la cotización'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    IF PEDI.canped <> ITEM.canped THEN DO:
        MESSAGE 'Artículo' PEDI.codmat 'cantidad diferente en la cotización'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    IF PEDI.undvta <> ITEM.undvta THEN DO:
        MESSAGE 'Artículo' PEDI.codmat 'unidad de venta diferente en la cotización'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
END.
FOR EACH ITEM:
    FIND FIRST PEDI WHERE PEDI.codmat = ITEM.codmat NO-ERROR.
    IF NOT AVAILABLE PEDI THEN DO:
        MESSAGE 'Artículo' ITEM.codmat 'no registrado en el Excel'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
END.
/* LIMITES PERMITIDOS */
FOR EACH PEDI, FIRST ITEM WHERE ITEM.codmat = PEDI.codmat:
    CASE TRUE:
        WHEN gn-divi.libre_c02 = 'Porcentaje' AND gn-divi.libre_d01 > 0 THEN DO:
            IF (ABS(PEDI.ImpLin - ITEM.ImpLin) / ITEM.ImpLin) * 100 > gn-divi.libre_d01 
                THEN DO:
                MESSAGE 'El artículo' ITEM.codmat 'supera el margen permitido' SKIP
                    'Proceso abortado'
                    VIEW-AS ALERT-BOX ERROR.
                RETURN.
            END.
        END.
        WHEN gn-divi.libre_c02 = 'Importe' AND gn-divi.libre_d01 > 0 THEN DO:
            IF ABS(PEDI.ImpLin - ITEM.ImpLin) > gn-divi.libre_d01 
                THEN DO:
                MESSAGE 'El artículo' ITEM.codmat 'supera el margen permitido' SKIP
                    'Proceso abortado'
                    VIEW-AS ALERT-BOX ERROR.
                RETURN.
            END.
        END.
    END CASE.
END.
/* Actualizamos información del ITEM */
FOR EACH PEDI, FIRST ITEM WHERE ITEM.codmat = PEDI.codmat, FIRST Almmmatg OF ITEM NO-LOCK:
    /* Cargamos valores del Excel */
    ASSIGN
        ITEM.PreUni = PEDI.PreUni
        ITEM.ImpLin = PEDI.ImpLin
        ITEM.Por_Dsctos[1] = 0
        ITEM.Por_Dsctos[2] = 0
        ITEM.Por_Dsctos[3] = 0
        ITEM.ImpDto = 0
        ITEM.PreUni = ROUND(ITEM.ImpLin / ITEM.CanPed, 6).  /* Por si acaso */
    /* Recalculamos linea */
    IF ITEM.AftIsc 
    THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
    ELSE ITEM.ImpIsc = 0.
    IF ITEM.AftIgv 
    THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (Faccpedi.PorIgv / 100) ), 4 ).
    ELSE ITEM.ImpIgv = 0.
    /* CALCULO DE PERCEPCION */
    ASSIGN
        ITEM.CanApr = ROUND(ITEM.implin * ITEM.CanSol / 100, 2).
END.
/* Grabamos Cotizacion */
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccpedi THEN DO:
        MESSAGE 'Cotización en uso por otro usuario' VIEW-AS ALERT-BOX ERROR.
        LEAVE.
    END.
    RUN Borra-Pedido.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        MESSAGE 'Cotización en uso por otro usuario' VIEW-AS ALERT-BOX ERROR.
        UNDO, LEAVE.
    END.
    /* Detalle */
    FOR EACH ITEM WHERE ITEM.ImpLin > 0 BY ITEM.NroItm: 
        CREATE FacDPedi.
        BUFFER-COPY ITEM TO FacDPedi.
    END.

    {vta2/graba-totales-cotizacion-cred.i}

    MESSAGE 'Importación Exitosa' VIEW-AS ALERT-BOX INFORMATION.
END.

FIND CURRENT Faccpedi NO-LOCK.
RUN Procesa-Handle IN lh_handle ('browse').

END PROCEDURE.

/* *********************************** */
PROCEDURE Importar-Detalle-Excel-Marco:
/* *********************************** */
DEF OUTPUT PARAMETER cTipoPrecio AS CHAR.
DEF VAR I-NPEDI AS INT NO-UNDO.

/* CHEQUEAMOS LA INTEGRIDAD DEL ARCHIVO EXCEL */
/* 1ro el Cliente */
cValue = chWorkSheet:Cells(11,1):VALUE.      
ASSIGN
    cValue = SUBSTRING(cValue,12,11)
    NO-ERROR.
IF cValue = "" OR cValue = ? OR ERROR-STATUS:ERROR = YES THEN DO:
    MESSAGE 'No hay datos del cliente:' cValue VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
IF Faccpedi.codcli <> cValue THEN DO:
    MESSAGE 'Cliente errado' SKIP
        'Cliente:' cValue 'errado'
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
/* 2do la Cotización */
cValue = chWorkSheet:Cells(9,7):VALUE.      
ASSIGN
    cValue = REPLACE(cValue,'-','')
    NO-ERROR.
IF cValue = "" OR cValue = ? OR error-status:ERROR = YES THEN DO:
    MESSAGE 'No hay datos del número de cotización:' cValue VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
IF Faccpedi.nroped <> cValue THEN DO:
    MESSAGE 'Formato del archivo Excel errado' SKIP
        'Número de pedido:' cValue 'errado'
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
/* Cargamos detalle */
ASSIGN
    t-Row = 21
    I-NPEDI = 0.
REPEAT:
    ASSIGN
        t-Row  = t-Row + 1
        I-NPEDI = I-NPEDI + 1.

    cValue = chWorkSheet:Cells(t-Row, 2):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 

    /* Artículo */
    ASSIGN
        cValue = STRING(INTEGER(cValue), '999999')
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN NEXT.
    CREATE PEDI.
    ASSIGN
        PEDI.NroItm = I-NPEDI
        PEDI.codcia = s-codcia
        PEDI.codmat = cValue.
    /* Cantidad */
    cValue = chWorkSheet:Cells(t-Row, 3):VALUE.
    ASSIGN
        PEDI.canped = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES OR PEDI.canPed <= 0 THEN DO:
        MESSAGE "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  SKIP
            "Cantidad Pedida" VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
    /* Unidad */
    cValue = chWorkSheet:Cells(t-Row, 4):VALUE.
    ASSIGN
        PEDI.UndVta = cValue
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES OR PEDI.UndVta = "" THEN DO:
        MESSAGE "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  SKIP
            "Unidad de Venta" VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
    /* Unitario */
    cValue = chWorkSheet:Cells(t-Row, 8):VALUE.
    ASSIGN
        PEDI.PreUni = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES OR PEDI.PreUni = 0 THEN DO:
        MESSAGE "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  SKIP
            "Precio Unitario" VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
    /* Total */
    cValue = chWorkSheet:Cells(t-Row, 8):VALUE.
    ASSIGN
        PEDI.ImpLin = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES OR PEDI.ImpLin = 0 THEN DO:
        MESSAGE "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  SKIP
            "Total" VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
END.
/* Buscamos si están o no con igv */
cValue = chWorkSheet:Cells(t-Row + 4, 1):VALUE.
CASE TRUE:
    WHEN INDEX(cValue, 'NO INCLUYEN') > 0   THEN cTipoPrecio = "SIN IGV".
    WHEN INDEX(cValue, 'INCLUYEN') > 0      THEN cTipoPrecio = "CON IGV".
END CASE.
IF cTipoPrecio = "SIN IGV" THEN DO:
    FOR EACH PEDI:
        ASSIGN
            PEDI.PreUni = PEDI.PreUni * (1 + Faccpedi.PorIgv / 100)
            PEDI.ImpLin = ROUND(PEDI.ImpLin * (1 + Faccpedi.PorIgv / 100), 2).
    END.
END.
/* Borramos cantidades en cero */
I-NPEDI = I-NPEDI - 1.
FOR EACH PEDI WHERE PEDI.CanPed <= 0:
    I-NPEDI = I-NPEDI - 1.
    DELETE PEDI.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Excel-OpenOrange V-table-Win 
PROCEDURE Importar-Excel-OpenOrange :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE FILL-IN-Archivo AS CHAR NO-UNDO.
DEFINE VARIABLE OKpressed AS LOG NO-UNDO.
                                          
SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
    FILTERS "Archivos Excel (*.xls)" "*.xls", "Todos (*.*)" "*.*"
    TITLE "Archivo(s) de Carga..."
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.

/* CREAMOS LA HOJA EXCEL */
CREATE "Excel.Application" chExcelApplication.
chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-Archivo).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

SESSION:SET-WAIT-STATE('GENERAL').
RUN Importar-Detalle-Excel-OpenOrange.
SESSION:SET-WAIT-STATE('').

/* CERRAMOS EL EXCEL */
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 

END PROCEDURE.

/* **************************************** */
PROCEDURE Importar-Detalle-Excel-OpenOrange:
/* **************************************** */

DEF VAR I-NITEM AS INT NO-UNDO.

/* CHEQUEAMOS LA INTEGRIDAD DEL ARCHIVO EXCEL */
/* 1ro el Cliente Fila 2 Columna 1 */
cValue = chWorkSheet:Cells(2,1):VALUE.      
ASSIGN
    cValue = STRING(DECIMAL(cValue), '99999999999')
    NO-ERROR.
IF cValue = "" OR cValue = ? OR ERROR-STATUS:ERROR = YES THEN DO:
    MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
FIND gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = cValue
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clie THEN DO:
    MESSAGE 'Formato del archivo Excel errado' SKIP
        'Cliente:' cValue 'NO registrado'
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
s-CodCli = cValue.

/* 2do la Condición de Venta */
cValue = chWorkSheet:Cells(2,5):VALUE.      
ASSIGN
    cValue = STRING(DECIMAL(cValue), '999')
    NO-ERROR.
IF cValue = "" OR cValue = ? OR error-status:ERROR = YES THEN DO:
    MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
FIND gn-convt WHERE gn-ConVt.Codig = cValue
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-convt THEN DO:
    MESSAGE 'Formato del archivo Excel errado' SKIP
        'Condición de Venta:' cValue 'NO registrada'
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
s-CndVta = cValue.
/* Debe estar permitida para este cliente */
RUN vta2/p-fmapgo (s-codcli, s-tpoped, OUTPUT s-cndvta-validos).
IF LOOKUP(s-CndVta, s-cndvta-validos) = 0 THEN DO:
    MESSAGE 'Condición de Venta:' s-CndVta 'NO válida para el cliente' gn-clie.codcli gn-clie.nomcli
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

/* Cargamos detalle */
ASSIGN
    t-Row = 1
    I-NITEM = 0.
EMPTY TEMP-TABLE ITEM.  /* Limpiamos el temporal */
REPEAT:
    ASSIGN
        t-Row  = t-Row + 1
        I-NITEM = I-NITEM + 1.

    cValue = chWorkSheet:Cells(t-Row, 10):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 

    /* Artículo */
    ASSIGN
        cValue = STRING(INTEGER(cValue), '999999')
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN NEXT.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = cValue NO-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  SKIP
            "Artículo" VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    CREATE ITEM.
    ASSIGN
        ITEM.NroItm = I-NITEM
        ITEM.codcia = s-codcia
        ITEM.codmat = cValue.

    /* Cantidad */
    cValue = chWorkSheet:Cells(t-Row, 12):VALUE.
    ASSIGN
        ITEM.canped = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES OR ITEM.canPed <= 0 THEN DO:
        MESSAGE "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  SKIP
            "Cantidad Pedida" VIEW-AS ALERT-BOX ERROR.
        DELETE ITEM.
        RETURN.
    END.

    /* Unidad */
    cValue = chWorkSheet:Cells(t-Row, 13):VALUE.
    ASSIGN
        ITEM.UndVta = cValue
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES OR ITEM.UndVta = "" THEN DO:
        MESSAGE "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  SKIP
            "Unidad de Venta" VIEW-AS ALERT-BOX ERROR.
        DELETE ITEM.
        RETURN.
    END.
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
        AND Almtconv.Codalter = ITEM.UndVta
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        MESSAGE "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  SKIP
            "Unidad de Venta" VIEW-AS ALERT-BOX ERROR.
        DELETE ITEM.
        RETURN.
    END.
    /* Almacén */
    cValue = chWorkSheet:Cells(t-Row, 8):VALUE.
    ASSIGN
        ITEM.AlmDes = cValue
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES OR ITEM.UndVta = "" THEN DO:
        MESSAGE "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  SKIP
            "Sucursal" VIEW-AS ALERT-BOX ERROR.
        DELETE ITEM.
        RETURN.
    END.
END.
/* Borramos cantidades en cero */
I-NITEM = I-NITEM - 1.
FOR EACH ITEM WHERE ITEM.CanPed <= 0:
    I-NITEM = I-NITEM - 1.
    DELETE ITEM.
END.
/* Renumeramos */
FOR EACH ITEM BY ITEM.nroitm DESC:
    ITEM.nroitm = I-NITEM.
    I-NITEM = I-NITEM - 1.
END.

/* Pintamos datos iniciales */
DISPLAY
    s-codcli @ FacCPedi.CodCli 
    gn-clie.nomcli @ FacCPedi.NomCli
    WITH FRAME {&FRAME-NAME}.
RUN Procesa-Handle IN lh_handle ('Browse').
APPLY 'LEAVE':U TO FacCPedi.CodCli IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Excel-Provincias V-table-Win 
PROCEDURE Importar-Excel-Provincias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE FILL-IN-Archivo AS CHAR NO-UNDO.
DEFINE VARIABLE OKpressed AS LOG NO-UNDO.
                                          
SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
    FILTERS "Archivos Excel (*.xls)" "*.xls", "Todos (*.*)" "*.*"
    TITLE "Archivo(s) de Carga..."
    MUST-EXIST
    /*RETURN-TO-START-DIR */
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.

/* CREAMOS LA HOJA EXCEL */
CREATE "Excel.Application" chExcelApplication.
chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-Archivo).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

SESSION:SET-WAIT-STATE('GENERAL').
RUN Importar-Detalle-Excel-Provincias.
SESSION:SET-WAIT-STATE('').

/* CERRAMOS EL EXCEL */
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 

END PROCEDURE.

/* **************************************** */
PROCEDURE Importar-Detalle-Excel-Provincias:
/* **************************************** */

DEF VAR I-NITEM AS INT NO-UNDO.
DEFINE VAR cCodArt AS CHAR.
DEFINE VAR cQty AS CHAR.

/* CHEQUEAMOS LA INTEGRIDAD DEL ARCHIVO EXCEL */
/* 1ro el Cliente */

/* Ic 07May2015
cValue = chWorkSheet:Cells(1,3):VALUE.      
cValue = STRING(DECIMAL(cValue), '99999999999').
IF cValue = "" OR cValue = ? THEN DO:
    MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
FIND gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = cValue
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clie THEN DO:
    MESSAGE 'Formato del archivo Excel errado' SKIP
        'Cliente:' cValue 'NO registrado'
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
s-CodCli = cValue.

/* 2do la Condición de Venta */
cValue = chWorkSheet:Cells(2,3):VALUE.      
IF cValue = "" OR cValue = ? THEN DO:
    MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
FIND gn-convt WHERE gn-ConVt.Codig = cValue
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-convt THEN DO:
    MESSAGE 'Formato del archivo Excel errado' SKIP
        'Condición de Venta:' cValue 'NO registrada'
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
s-CndVta = cValue.

/* 3ro Debe estar permitida para este cliente */
RUN vta2/p-fmapgo (s-codcli, s-tpoped, OUTPUT s-cndvta-validos).
IF LOOKUP(s-CndVta, s-cndvta-validos) = 0 THEN DO:
    MESSAGE 'Condición de Venta:' s-CndVta 'NO válida para el cliente' gn-clie.codcli gn-clie.nomcli
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

Ic 07May2015  */

/* Cargamos detalle */
ASSIGN
    t-Row = 21   /* 8 */
    I-NITEM = 0.
EMPTY TEMP-TABLE ITEM.
REPEAT:
    ASSIGN
        t-Row  = t-Row + 1
        I-NITEM = I-NITEM + 1.

    /*cValue = chWorkSheet:Cells(t-Row, 1):VALUE.*/
    cCodArt = chWorkSheet:Cells(t-Row, 2):VALUE.
    IF cCodArt = "" OR cCodArt = ? THEN LEAVE.    /* FIN DE DATOS */ 

    /*cValue = chWorkSheet:Cells(t-Row, 8):VALUE.*/
    cValue = chWorkSheet:Cells(t-Row, 3):VALUE.
    IF cValue = ? OR cValue = "" THEN cValue = "0" .

    IF cValue <> "0" THEN DO:
        CREATE ITEM.
        ASSIGN
            ITEM.NroItm = I-NITEM
            ITEM.codcia = s-codcia
            ITEM.codmat = cCodArt.


        ASSIGN
            ITEM.canped = DECIMAL(cValue)
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  SKIP
                "Cantidad Pedida" VIEW-AS ALERT-BOX ERROR.
            RETURN.
        END.

        /* Lista */
        /*
        cValue = chWorkSheet:Cells(t-Row, 9):VALUE.
        IF cValue = ? THEN cValue = "".
        ASSIGN
            ITEM.TipVta = cValue.
        */
    END.
END.
/* Borramos cantidades en cero */
I-NITEM = I-NITEM - 1.
FOR EACH ITEM WHERE ITEM.CanPed <= 0:
    I-NITEM = I-NITEM - 1.
    DELETE ITEM.
END.
/* Renumeramos */
FOR EACH ITEM BY ITEM.nroitm DESC:
    ITEM.nroitm = I-NITEM.
    I-NITEM = I-NITEM - 1.
END.

/* Pintamos datos iniciales */
/*
DISPLAY
    s-codcli @ FacCPedi.CodCli 
    s-cndvta @ FacCPedi.FmaPgo 
    gn-clie.nomcli @ FacCPedi.NomCli
    WITH FRAME {&FRAME-NAME}.
*/    
RUN Procesa-Handle IN lh_handle ('Browse').
/*
APPLY 'LEAVE':U TO FacCPedi.CodCli IN FRAME {&FRAME-NAME}.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Supermercados V-table-Win 
PROCEDURE Importar-Supermercados :
/*------------------------------------------------------------------------------
  Purpose:     Importar información de IBC en formato EDI
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-Linea   AS CHAR FORMAT 'x(200)' NO-UNDO.
DEF VAR x-CodMat LIKE ITEM.codmat NO-UNDO.
DEF VAR x-CanPed LIKE ITEM.canped NO-UNDO.
DEF VAR x-ImpLin LIKE ITEM.implin NO-UNDO.
DEF VAR x-ImpIgv LIKE ITEM.impigv NO-UNDO.
DEF VAR x-Encabezado AS LOG INIT FALSE.
DEF VAR x-Detalle    AS LOG INIT FALSE.
DEF VAR x-NroItm AS INT INIT 0.
DEF VAR x-Ok AS LOG.
DEF VAR x-Item AS CHAR NO-UNDO.
  
DEFINE VARIABLE cSede   AS CHAR NO-UNDO.
DEFINE VARIABLE cCodCli AS CHAR NO-UNDO.

SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Archivo texto (.txt)' '*.txt'
    RETURN-TO-START-DIR
    TITLE 'Selecciona al archivo texto'
    MUST-EXIST
    USE-FILENAME
    UPDATE x-Ok.
IF x-Ok = NO THEN RETURN "ADM-ERROR".

EMPTY TEMP-TABLE ITEM.
    
INPUT FROM VALUE(x-Archivo).
TEXTO:
REPEAT:
    IMPORT UNFORMATTED x-Linea.
    IF x-Linea BEGINS 'ENC' THEN DO:
        ASSIGN
            x-Encabezado = YES
            x-Detalle    = NO
            x-CodMat = ''
            x-CanPed = 0
            x-ImpLin = 0
            x-ImpIgv = 0.
        x-Item = ENTRY(6,x-Linea).
        FacCPedi.ordcmp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(x-Item,11,10).
    END.
/*     IF x-Linea BEGINS 'DTM' THEN DO:                                                                            */
/*         x-Item = ENTRY(5,x-Linea).                                                                              */
/*         ASSIGN                                                                                                  */
/*             FacCPedi.fchven:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(DATE(SUBSTRING(x-Item,7,2) + '/' +     */
/*                                                                                   SUBSTRING(x-Item,5,2) + '/' + */
/*                                                                                  SUBSTRING(x-Item,1,4)) )       */
/*             NO-ERROR.                                                                                           */
/*     END.                                                                                                        */
    /* Sede y Lugar de Entrega */
    IF x-Linea BEGINS 'DPGR' AND NUM-ENTRIES(x-Linea) > 1 THEN DO:
        cSede = TRIM(ENTRY(2,x-Linea)).
    END.
    /* Cliente */
    IF x-Linea BEGINS 'IVAD' AND NUM-ENTRIES(x-Linea) > 1 THEN DO:
        cCodCli = TRIM(ENTRY(2,x-Linea)).
        /* PINTAMOS INFORMACION */
        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codibc = cCodCli
            AND gn-clie.flgsit = 'A'
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            ASSIGN
                s-codcli = gn-clie.codcli.
                Faccpedi.codcli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gn-clie.codcli.
            FIND FIRST gn-clied OF gn-clie WHERE Gn-ClieD.Libre_c01 = cSede NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clied THEN DO WITH FRAME {&FRAME-NAME}:
                ASSIGN
                    Faccpedi.sede:SCREEN-VALUE = Gn-ClieD.Sede.
                FIND gn-clied WHERE gn-clied.codcia = cl-codcia
                    AND gn-clied.codcli = Faccpedi.codcli:SCREEN-VALUE 
                    AND gn-clied.sede = Faccpedi.sede:SCREEN-VALUE 
                    NO-LOCK NO-ERROR.
                IF AVAILABLE gn-clied
                THEN ASSIGN 
                      FILL-IN-Sede:SCREEN-VALUE = Gn-ClieD.DirCli
                      FacCPedi.LugEnt:SCREEN-VALUE = Gn-ClieD.DirCli
                      FacCPedi.Glosa:SCREEN-VALUE = (IF FacCPedi.Glosa:SCREEN-VALUE = '' THEN Gn-ClieD.DirCli ELSE FacCPedi.Glosa:SCREEN-VALUE).
            END.
        END.
    END.

    /* DETALLE */
    IF x-Linea BEGINS 'LIN' 
    THEN ASSIGN
            x-Encabezado = FALSE
            x-Detalle = YES.
    IF x-Detalle = YES THEN DO:
        IF x-Linea BEGINS 'LIN' 
        THEN DO:
            x-Item = ENTRY(2,x-Linea).
            IF NUM-ENTRIES(x-Linea) = 6
            THEN ASSIGN x-CodMat = STRING(INTEGER(ENTRY(6,x-Linea)), '999999') NO-ERROR.
            ELSE ASSIGN x-CodMat = ENTRY(3,x-Linea) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN x-CodMat = ENTRY(3,x-Linea).
        END.
        FIND Almmmatg WHERE almmmatg.codcia = s-codcia
            AND Almmmatg.codmat = x-codmat
            AND Almmmatg.tpoart <> 'D'
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatg
        THEN DO:
            FIND Almmmatg WHERE almmmatg.codcia = s-codcia
                AND almmmatg.codbrr = x-codmat
                AND Almmmatg.tpoart <> 'D'
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almmmatg THEN x-codmat = almmmatg.codmat.
        END.
        IF NOT AVAILABLE Almmmatg
        THEN DO:
            MESSAGE "El Item" x-Item x-codmat "no esta registrado en el catalogo"
                    VIEW-AS ALERT-BOX ERROR.
            NEXT TEXTO.
        END.

        IF x-Linea BEGINS 'QTY' THEN x-CanPed = DECIMAL(ENTRY(2,x-Linea)).
        IF x-Linea BEGINS 'MOA' THEN x-ImpLin = DECIMAL(ENTRY(2,x-Linea)).
        IF x-Linea BEGINS 'TAX' 
        THEN DO:
            ASSIGN
                x-ImpIgv = DECIMAL(ENTRY(3,x-Linea))
                x-NroItm = x-NroItm + 1.
            /* consistencia de duplicidad */
            FIND FIRST ITEM WHERE ITEM.codmat = x-CodMat NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ITEM THEN DO:
                CREATE ITEM.
                ASSIGN 
                    ITEM.CodCia = s-codcia
                    ITEM.codmat = x-CodMat
                    ITEM.Factor = 1 
                    ITEM.CanPed = x-CanPed
                    ITEM.NroItm = x-NroItm 
                    ITEM.UndVta = (IF AVAILABLE Almmmatg THEN Almmmatg.Chr__01 ELSE '')
                    ITEM.ALMDES = S-CODALM
                    ITEM.AftIgv = (IF x-ImpIgv > 0 THEN YES ELSE NO).
                /* RHC 09.08.06 IGV de acuerdo al cliente */
                IF LOOKUP(TRIM(s-CodCli), '20100070970,20109072177,20100106915,20504912851') > 0
                THEN ASSIGN
                        ITEM.ImpIgv = x-ImpIgv 
                        ITEM.ImpLin = x-ImpLin
                        ITEM.PreUni = (ITEM.ImpLin / ITEM.CanPed).
                ELSE ASSIGN
                        ITEM.ImpIgv = x-ImpIgv 
                        ITEM.ImpLin = x-ImpLin + x-ImpIgv
                        ITEM.PreUni = (ITEM.ImpLin / ITEM.CanPed).
            END.    /* fin de grabacion del detalle */
        END.
    END.
  END.
  INPUT CLOSE.
  /* BLOQUEAMOS CAMPOS */
  ASSIGN
      FacCPedi.CodCli:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      FacCPedi.CodMon:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      FacCPedi.Libre_d01:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

  /* Variable de control */
  s-import-ibc = YES.
  RUN Procesa-Handle IN lh_handle ("Disable-Button-IBC").
  RUN Procesa-Handle IN lh_handle ("Disable-Button-IBC-B2B").
  /* PINTAMOS INFORMACION */
  IF FacCPedi.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN DO:
      ASSIGN
          FacCPedi.CodCli:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
      APPLY 'ENTRY':U TO Faccpedi.codcli IN FRAME {&FRAME-NAME}.
  END.
  ELSE APPLY 'LEAVE':U TO Faccpedi.codcli IN FRAME {&FRAME-NAME}.

  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Supermercados-B2B V-table-Win 
PROCEDURE Importar-Supermercados-B2B :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-Linea   AS CHAR FORMAT 'x(200)' NO-UNDO.
DEF VAR x-CodMat LIKE ITEM.codmat NO-UNDO.
DEF VAR x-CanPed LIKE ITEM.canped NO-UNDO.
DEF VAR x-ImpLin LIKE ITEM.implin NO-UNDO.
DEF VAR x-ImpIgv LIKE ITEM.impigv NO-UNDO.
DEF VAR x-Encabezado AS LOG INIT FALSE.
DEF VAR x-Detalle    AS LOG INIT FALSE.
DEF VAR x-NroItm AS INT INIT 0.
DEF VAR x-Ok AS LOG.
DEF VAR x-Item AS CHAR NO-UNDO.

DEFINE VAR x-precio AS DEC.
DEFINE VAR x-precio-sin-igv AS DEC.
DEFINE VAR x-Cargo-Orden AS LOG.
DEFINE VAR x-ordenes-x-cargar AS INT.
  
DEFINE VARIABLE cSede   AS CHAR NO-UNDO.
DEFINE VARIABLE cCodCli AS CHAR NO-UNDO.

SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Archivo Excel (.xls)' '*.xls'
    RETURN-TO-START-DIR
    TITLE 'Selecciona al archivo Excel'
    MUST-EXIST
    USE-FILENAME
    UPDATE x-Ok.
IF x-Ok = NO THEN RETURN "ADM-ERROR".

/*
DEF TEMP-TABLE tt-OrdenesPlazVea
    FIELD tt-nroorden AS CHAR FORMAT 'x(15)'.
*/

EMPTY TEMP-TABLE tt-OrdenesPlazVea.

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.

DEFINE VAR lOrden AS CHAR.
DEFINE VAR lCodEan AS CHAR.

lFileXls = x-Archivo.           /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = NO.        /* YES : Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

chExcelApplication:Visible = FALSE.

/* Cuantas ORDENES tiene el Excel */
iColumn = 1.
x-ordenes-x-cargar = 0.
DO iColumn = 2 TO 65000:
    cRange = "B" + TRIM(STRING(iColumn)).
    cValue = TRIM(STRING(chWorkSheet:Range(cRange):VALUE,">>>>>>>>>>>9")).

    /*MESSAGE cValue.*/

    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */

    FIND FIRST tt-OrdenesPlazVea WHERE tt-nroorden = cValue NO-ERROR.
    IF NOT AVAILABLE tt-OrdenesPlazVea THEN DO:
        /**/
        FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                factabla.tabla = 'OC PLAZA VEA' AND 
                factabla.codigo = cValue NO-LOCK NO-ERROR.
        IF NOT AVAILABLE factabla THEN DO:
            x-ordenes-x-cargar = x-ordenes-x-cargar + 1.
            CREATE tt-OrdenesPlazVea.
                ASSIGN tt-OrdenesPlazVea.tt-nroorden = cValue
                        cRange = "A" + TRIM(STRING(iColumn))
                        tt-OrdenesPlazVea.tt-CodClie = TRIM(chWorkSheet:Range(cRange):VALUE)                    
                        cRange = "D" + TRIM(STRING(iColumn))
                        tt-OrdenesPlazVea.tt-locentrega = TRIM(chWorkSheet:Range(cRange):VALUE).
        END.
    END.  
END.

FIND FIRST tt-OrdenesPlazVea NO-LOCK NO-ERROR.
IF NOT AVAILABLE tt-OrdenesPlazVea THEN DO:
    MESSAGE "No existen Ordenes Pendientes a Cargar" VIEW-AS ALERT-BOX.
    RETURN NO-APPLY.
END.

x-Cargo-Orden = NO.

/* Carga la primera orden que no este cargada */
FOR EACH tt-OrdenesPlazVea NO-LOCK:
    lOrden = tt-OrdenesPlazVea.tt-nroorden.
    FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
            factabla.tabla = 'OC PLAZA VEA' AND 
            factabla.codigo = lOrden NO-LOCK NO-ERROR.
    IF NOT AVAILABLE factabla THEN DO:
        /* Adicionar esta orden */
        cCodCli = tt-OrdenesPlazVea.tt-CodClie.
        cSede = tt-OrdenesPlazVea.tt-locentrega.
        /* PINTAMOS INFORMACION */
        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            /*AND gn-clie.codibc = cCodCli*/
            AND gn-clie.codcli = cCodCli
            AND gn-clie.flgsit = 'A'
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            ASSIGN
                s-codcli = gn-clie.codcli.
                Faccpedi.codcli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gn-clie.codcli.
            /*FIND FIRST gn-clied OF gn-clie WHERE Gn-ClieD.Libre_c01 = cSede NO-LOCK NO-ERROR.*/
            FIND FIRST gn-clied OF gn-clie WHERE Gn-ClieD.sede = cSede NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clied THEN DO WITH FRAME {&FRAME-NAME}:
                ASSIGN
                    Faccpedi.sede:SCREEN-VALUE = Gn-ClieD.Sede.
                FIND gn-clied WHERE gn-clied.codcia = cl-codcia
                    AND gn-clied.codcli = Faccpedi.codcli:SCREEN-VALUE 
                    AND gn-clied.sede = Faccpedi.sede:SCREEN-VALUE 
                    NO-LOCK NO-ERROR.
                IF AVAILABLE gn-clied
                THEN ASSIGN 
                      FILL-IN-Sede:SCREEN-VALUE = Gn-ClieD.DirCli
                      FacCPedi.LugEnt:SCREEN-VALUE = Gn-ClieD.DirCli
                      FacCPedi.Glosa:SCREEN-VALUE = (IF FacCPedi.Glosa:SCREEN-VALUE = '' THEN Gn-ClieD.DirCli ELSE FacCPedi.Glosa:SCREEN-VALUE).
            END.
        END.
        ELSE DO:
            MESSAGE "Cia " + String(cl-codcia) + "Cliente (" + cCodCli + ") no existe" VIEW-AS ALERT-BOX.
        END.
        /* */
        FacCPedi.ordcmp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = lOrden.
        x-NroItm = 0.

        /* El Detalle de la Orden */
        DO iColumn = 2 TO 65000:
            ASSIGN x-CodMat = ''
                x-CanPed = 0
                x-ImpLin = 0
                x-ImpIgv = 0
                x-precio = 0.

            /* Orden */
            cRange = "B" + TRIM(STRING(iColumn)).
            /*cValue = STRING(chWorkSheet:Range(cRange):VALUE).*/
            cValue = TRIM(STRING(chWorkSheet:Range(cRange):VALUE,">>>>>>>>>>>9")).

            IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */

            /*MESSAGE cValue tt-OrdenesPlazVea.tt-nroorden.*/
            IF cValue = tt-OrdenesPlazVea.tt-nroorden THEN DO:
                /* Articulo de la misma Orden  */
                cRange = "J" + TRIM(STRING(iColumn)).
                lCodEan = TRIM(chWorkSheet:Range(cRange):VALUE).                

                /* Buscar el codigo como interno */
                FIND FIRST Almmmatg WHERE almmmatg.codcia = s-codcia AND 
                            almmmatg.Codmat = lCodEan NO-LOCK NO-ERROR.
                x-CodMat = IF(AVAILABLE almmmatg) THEN almmmatg.codmat ELSE x-CodMat.
                IF X-CodMat = '' THEN DO:
                    /* Buscar el codigo interno primero con EAN13 */
                    FIND FIRST Almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                almmmatg.CodBrr = lCodEan NO-LOCK NO-ERROR.
                    x-CodMat = IF(AVAILABLE almmmatg) THEN almmmatg.codmat ELSE x-CodMat.
                END.
                /* si no existe com EAN13 lo busco como EAN14  */
                IF X-CodMat = '' THEN DO:
                    FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND 
                                        almmmat1.barras[1] = lCodEan NO-LOCK NO-ERROR.
                    x-CodMat = IF(AVAILABLE almmmat1) THEN almmmat1.barras[1] ELSE x-CodMat.
                END.
                IF X-CodMat = '' THEN DO:
                    FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND 
                                        almmmat1.barras[2] = lCodEan NO-LOCK NO-ERROR.
                    x-CodMat = IF(AVAILABLE almmmat1) THEN almmmat1.barras[2] ELSE x-CodMat.
                END.
                IF X-CodMat = '' THEN DO:
                    FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND 
                                        almmmat1.barras[3] = lCodEan NO-LOCK NO-ERROR.
                    x-CodMat = IF(AVAILABLE almmmat1) THEN almmmat1.barras[3] ELSE x-CodMat.
                END.
                IF x-CodMat <> ''  THEN DO:
                    /* Se ubico el Codigo Interno  */
                    FIND Almmmatg WHERE almmmatg.codcia = s-codcia
                        AND Almmmatg.codmat = x-codmat
                        AND Almmmatg.tpoart <> 'D'
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE Almmmatg THEN DO:

                        /* Cantidad pedida */
                        cRange = "W" + TRIM(STRING(iColumn)).
                        x-CanPed = chWorkSheet:Range(cRange):VALUE.
                        /* El precio final */
                        cRange = "T" + TRIM(STRING(iColumn)).
                        x-precio =  chWorkSheet:Range(cRange):VALUE.
                        /* Precio sin IGV */
                        cRange = "S" + TRIM(STRING(iColumn)).
                        x-precio-sin-igv = chWorkSheet:Range(cRange):VALUE.
                        /**/
                        x-ImpLin = x-CanPed * x-precio.
                        /* Verificar el IGV */
                        IF x-precio > x-precio-sin-igv THEN DO:
                            x-ImpIgv = x-ImpLin - (x-CanPed * x-precio-sin-igv).
                        END.                        

                        /* Items */
                        FIND FIRST ITEM WHERE ITEM.codmat = x-CodMat NO-LOCK NO-ERROR.
                        IF NOT AVAILABLE ITEM THEN DO:

                            x-Cargo-Orden = YES.
                            x-NroItm = x-NroItm + 1.
                            lOrdenGrabada = lOrden.

                            CREATE ITEM.
                            ASSIGN 
                                ITEM.CodCia = s-codcia
                                ITEM.codmat = x-CodMat
                                ITEM.Factor = 1 
                                ITEM.CanPed = x-CanPed
                                ITEM.NroItm = x-NroItm 
                                ITEM.UndVta = (IF AVAILABLE Almmmatg THEN Almmmatg.Chr__01 ELSE '')
                                ITEM.ALMDES = S-CODALM
                                ITEM.AftIgv = (IF x-ImpIgv > 0 THEN YES ELSE NO).
                            /* RHC 09.08.06 IGV de acuerdo al cliente */
                            IF LOOKUP(TRIM(s-CodCli), '20100070970,20109072177,20100106915,20504912851') > 0
                            THEN ASSIGN
                                    ITEM.ImpIgv = x-ImpIgv 
                                    ITEM.ImpLin = x-ImpLin
                                    ITEM.PreUni = x-precio.  /* (ITEM.ImpLin / ITEM.CanPed).*/
                            ELSE ASSIGN
                                    ITEM.ImpIgv = x-ImpIgv 
                                    ITEM.ImpLin = x-ImpLin /*+ x-ImpIgv*/
                                    ITEM.PreUni = x-precio. /* (ITEM.ImpLin / ITEM.CanPed) */
                        END.    /* fin de grabacion del detalle */

                    END.
                    ELSE DO:
                        MESSAGE "El Item " x-Item " Articulo (" x-codmat ") no esta registrado en el catalogo"
                                VIEW-AS ALERT-BOX ERROR.
                    END.                    
                END.
                ELSE DO:
                    MESSAGE "El Item" x-Item "Cod Ean (" lCodEan ") es inubicable"
                            VIEW-AS ALERT-BOX ERROR.
                END.
            END.            
        END.        
    END.
    /* Si Cargo orden Salir  */
    IF x-Cargo-Orden = YES THEN DO:
        LEAVE.
    END.
END.

IF x-Cargo-Orden = YES THEN DO:
    /* BLOQUEAMOS CAMPOS */
    ASSIGN
        FacCPedi.CodCli:SENSITIVE IN FRAME {&FRAME-NAME} = NO
        FacCPedi.CodMon:SENSITIVE IN FRAME {&FRAME-NAME} = NO
        FacCPedi.Libre_d01:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

    /* Variable de control */
    s-import-ibc = YES.
    RUN Procesa-Handle IN lh_handle ("Disable-Button-IBC").
    RUN Procesa-Handle IN lh_handle ("Disable-Button-IBC-B2B").
    /* PINTAMOS INFORMACION */
    IF FacCPedi.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN DO:
        ASSIGN
            FacCPedi.CodCli:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
        APPLY 'ENTRY':U TO Faccpedi.codcli IN FRAME {&FRAME-NAME}.
    END.
    ELSE APPLY 'LEAVE':U TO Faccpedi.codcli IN FRAME {&FRAME-NAME}.

    x-ordenes-x-cargar = x-ordenes-x-cargar - 1.
    IF x-ordenes-x-cargar > 0 THEN DO:
        MESSAGE "Aun le faltan cargar (" x-ordenes-x-cargar ") Orden(es)" VIEW-AS ALERT-BOX.
    END.
END.

/* Cerrar el Excel  */
{lib\excel-close-file.i}


RETURN "OK".

/*

/* *********************************************** */
EMPTY TEMP-TABLE ITEM.
    
INPUT FROM VALUE(x-Archivo).
TEXTO:
REPEAT:
    IMPORT UNFORMATTED x-Linea.
    IF x-Linea BEGINS 'ENC' THEN DO:
        ASSIGN
            x-Encabezado = YES
            x-Detalle    = NO
            x-CodMat = ''
            x-CanPed = 0
            x-ImpLin = 0
            x-ImpIgv = 0.
        x-Item = ENTRY(6,x-Linea).
        FacCPedi.ordcmp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(x-Item,11,10).
    END.
/*     IF x-Linea BEGINS 'DTM' THEN DO:                                                                            */
/*         x-Item = ENTRY(5,x-Linea).                                                                              */
/*         ASSIGN                                                                                                  */
/*             FacCPedi.fchven:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(DATE(SUBSTRING(x-Item,7,2) + '/' +     */
/*                                                                                   SUBSTRING(x-Item,5,2) + '/' + */
/*                                                                                  SUBSTRING(x-Item,1,4)) )       */
/*             NO-ERROR.                                                                                           */
/*     END.                                                                                                        */
    /* Sede y Lugar de Entrega */
    IF x-Linea BEGINS 'DPGR' AND NUM-ENTRIES(x-Linea) > 1 THEN DO:
        cSede = TRIM(ENTRY(2,x-Linea)).
    END.
    /* Cliente */
    IF x-Linea BEGINS 'IVAD' AND NUM-ENTRIES(x-Linea) > 1 THEN DO:
        cCodCli = TRIM(ENTRY(2,x-Linea)).
        /* PINTAMOS INFORMACION */
        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codibc = cCodCli
            AND gn-clie.flgsit = 'A'
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            ASSIGN
                s-codcli = gn-clie.codcli.
                Faccpedi.codcli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gn-clie.codcli.
            FIND FIRST gn-clied OF gn-clie WHERE Gn-ClieD.Libre_c01 = cSede NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clied THEN DO WITH FRAME {&FRAME-NAME}:
                ASSIGN
                    Faccpedi.sede:SCREEN-VALUE = Gn-ClieD.Sede.
                FIND gn-clied WHERE gn-clied.codcia = cl-codcia
                    AND gn-clied.codcli = Faccpedi.codcli:SCREEN-VALUE 
                    AND gn-clied.sede = Faccpedi.sede:SCREEN-VALUE 
                    NO-LOCK NO-ERROR.
                IF AVAILABLE gn-clied
                THEN ASSIGN 
                      FILL-IN-Sede:SCREEN-VALUE = Gn-ClieD.DirCli
                      FacCPedi.LugEnt:SCREEN-VALUE = Gn-ClieD.DirCli
                      FacCPedi.Glosa:SCREEN-VALUE = (IF FacCPedi.Glosa:SCREEN-VALUE = '' THEN Gn-ClieD.DirCli ELSE FacCPedi.Glosa:SCREEN-VALUE).
            END.
        END.
    END.

    /* DETALLE */
    IF x-Linea BEGINS 'LIN' 
    THEN ASSIGN
            x-Encabezado = FALSE
            x-Detalle = YES.
    IF x-Detalle = YES THEN DO:
        IF x-Linea BEGINS 'LIN' 
        THEN DO:
            x-Item = ENTRY(2,x-Linea).
            IF NUM-ENTRIES(x-Linea) = 6
            THEN ASSIGN x-CodMat = STRING(INTEGER(ENTRY(6,x-Linea)), '999999') NO-ERROR.
            ELSE ASSIGN x-CodMat = ENTRY(3,x-Linea) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN x-CodMat = ENTRY(3,x-Linea).
        END.
        FIND Almmmatg WHERE almmmatg.codcia = s-codcia
            AND Almmmatg.codmat = x-codmat
            AND Almmmatg.tpoart <> 'D'
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatg
        THEN DO:
            FIND Almmmatg WHERE almmmatg.codcia = s-codcia
                AND almmmatg.codbrr = x-codmat
                AND Almmmatg.tpoart <> 'D'
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almmmatg THEN x-codmat = almmmatg.codmat.
        END.
        IF NOT AVAILABLE Almmmatg
        THEN DO:
            MESSAGE "El Item" x-Item x-codmat "no esta registrado en el catalogo"
                    VIEW-AS ALERT-BOX ERROR.
            NEXT TEXTO.
        END.

        IF x-Linea BEGINS 'QTY' THEN x-CanPed = DECIMAL(ENTRY(2,x-Linea)).
        IF x-Linea BEGINS 'MOA' THEN x-ImpLin = DECIMAL(ENTRY(2,x-Linea)).
        IF x-Linea BEGINS 'TAX' 
        THEN DO:
            ASSIGN
                x-ImpIgv = DECIMAL(ENTRY(3,x-Linea))
                x-NroItm = x-NroItm + 1.
            /* consistencia de duplicidad */
            FIND FIRST ITEM WHERE ITEM.codmat = x-CodMat NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ITEM THEN DO:
                CREATE ITEM.
                ASSIGN 
                    ITEM.CodCia = s-codcia
                    ITEM.codmat = x-CodMat
                    ITEM.Factor = 1 
                    ITEM.CanPed = x-CanPed
                    ITEM.NroItm = x-NroItm 
                    ITEM.UndVta = (IF AVAILABLE Almmmatg THEN Almmmatg.Chr__01 ELSE '')
                    ITEM.ALMDES = S-CODALM
                    ITEM.AftIgv = (IF x-ImpIgv > 0 THEN YES ELSE NO).
                /* RHC 09.08.06 IGV de acuerdo al cliente */
                IF LOOKUP(TRIM(s-CodCli), '20100070970,20109072177,20100106915,20504912851') > 0
                THEN ASSIGN
                        ITEM.ImpIgv = x-ImpIgv 
                        ITEM.ImpLin = x-ImpLin
                        ITEM.PreUni = (ITEM.ImpLin / ITEM.CanPed).
                ELSE ASSIGN
                        ITEM.ImpIgv = x-ImpIgv 
                        ITEM.ImpLin = x-ImpLin + x-ImpIgv
                        ITEM.PreUni = (ITEM.ImpLin / ITEM.CanPed).
            END.    /* fin de grabacion del detalle */
        END.
    END.
  END.
  INPUT CLOSE.
  /* BLOQUEAMOS CAMPOS */
  ASSIGN
      FacCPedi.CodCli:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      FacCPedi.CodMon:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      FacCPedi.Libre_d01:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

  /* Variable de control */
  s-import-ibc = YES.
  RUN Procesa-Handle IN lh_handle ("Disable-Button-IBC").
  /* PINTAMOS INFORMACION */
  IF FacCPedi.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN DO:
      ASSIGN
          FacCPedi.CodCli:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
      APPLY 'ENTRY':U TO Faccpedi.codcli IN FRAME {&FRAME-NAME}.
  END.
  ELSE APPLY 'LEAVE':U TO Faccpedi.codcli IN FRAME {&FRAME-NAME}.

  RETURN "OK".
*/

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
      s-Import-IBC = NO
      s-Import-Cissac = NO
      s-adm-new-record = "YES"
      s-nroped = ""
      lOrdenGrabada = "".

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
          FacCPedi.CodMon:SCREEN-VALUE = "Soles"
          FacCPedi.Cmpbnte:SCREEN-VALUE = "FAC"
          FacCPedi.Libre_d01:SCREEN-VALUE = STRING(s-NroDec, '9')
          FacCPedi.FlgIgv:SCREEN-VALUE = "YES".
      FIND TcmbCot WHERE  TcmbCot.Codcia = 0
          AND  (TcmbCot.Rango1 <= TODAY - TODAY + 1
          AND   TcmbCot.Rango2 >= TODAY - TODAY + 1)
          NO-LOCK NO-ERROR.
      IF AVAIL TcmbCot THEN S-TPOCMB = TcmbCot.TpoCmb.  
      /* RHC 11.08.2014 TC Caja Compra */
      FOR EACH gn-tccja NO-LOCK BY Fecha:
          IF TODAY >= Fecha THEN s-TpoCmb = Gn-TCCja.Compra.
      END.

      DISPLAY 
          STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ FacCPedi.NroPed
          TODAY @ FacCPedi.FchPed
          TODAY @ FacCPedi.FchEnt
          S-TPOCMB @ FacCPedi.TpoCmb
          (TODAY + s-DiasVtoCot) @ FacCPedi.FchVen 
          s-CodVen @ Faccpedi.codven.
      RUN Borra-Temporal.
      RUN Procesa-Handle IN lh_Handle ('Pagina2').
      /* RHC 14/10/2013 ***************************************************************** */
      CASE TRUE:
          WHEN s-TpoPed = "P" THEN DO:     /* PROVINCIAS */
              FIND gn-divi WHERE gn-divi.codcia = s-codcia
                  AND gn-divi.coddiv = pCodDiv
                  NO-LOCK NO-ERROR.
              IF AVAILABLE gn-divi AND gn-divi.VentaMayorista = 1 THEN DO:  /* LISTA GENERAL */
                  RUN Procesa-Handle IN lh_Handle ('Pagina3').
                  RUN Procesa-Handle IN lh_Handle ("Enable-Button-Imp-Prov").
              END.
          END.
          WHEN s-CodDiv = '00024' THEN DO:  /* INSTITUCIONALES */
              RUN Procesa-Handle IN lh_Handle ("Enable-Button-Imp-OpenOrange").
          END.
      END CASE.
      /* ******************************************************************************** */
      APPLY 'ENTRY':U TO FacCPedi.CodCli.
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
  DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      /*{vtagn/i-faccorre-01.i &Codigo = s-coddoc &Serie = s-nroser}*/
      {vta2/icorrelativosecuencial.i &Codigo = s-coddoc &Serie = s-nroser}
      ASSIGN 
          FacCPedi.CodCia = S-CODCIA
          FacCPedi.CodDiv = S-CODDIV
          FacCPedi.CodDoc = s-coddoc 
          FacCPedi.CodAlm = s-CodAlm    /* Lista de Almacenes Válidos de Venta */
          FacCPedi.FchPed = TODAY 
          FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
          FacCPedi.TpoPed = s-TpoPed
          FacCPedi.FlgEst = "P".    /* APROBADO */
      IF s-import-ibc = YES AND s-pendiente-ibc = YES THEN Faccpedi.flgest = 'E'.
      IF s-Import-Ibc = YES THEN FacCPedi.Libre_C05 = "1".
      IF s-Import-Cissac = YES THEN FacCPedi.Libre_C05 = "2".
      ASSIGN
          FacCorre.Correlativo = FacCorre.Correlativo + 1.

      /*  */
      IF lOrdenGrabada <> '' THEN DO:

          DISABLE TRIGGERS FOR LOAD OF factabla.

          FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                  factabla.tabla = 'OC PLAZA VEA' AND 
                  factabla.codigo = lOrdenGrabada EXCLUSIVE NO-ERROR.
          IF NOT AVAILABLE factabla THEN DO:
              CREATE factabla.
                ASSIGN factabla.codcia = s-codcia
                        factabla.tabla = 'OC PLAZA VEA'
                        factabla.codigo = lOrdenGrabada
                        factabla.campo-c[2] = STRING(NOW,"99/99/9999 HH:MM:SS").
          END.
      END.

  END.
  ELSE DO:
      RUN Borra-Pedido.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.

  ASSIGN 
      FacCPedi.PorIgv = s-PorIgv
      FacCPedi.Hora = STRING(TIME,"HH:MM")
      FacCPedi.Usuario = S-USER-ID
      FacCPedi.Observa = F-Observa
      FacCPedi.Libre_c01 = pCodDiv.

  /* RHC 11/12/2013 PROBLEMA DETECTADO: CUANDO SE MODIFICA UNA COTIZACION CON DVXDSF */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = "NO" THEN DO:
      /* Copiamos items a PEDI y dejamos en ITEMS los afectados por DVXDSF */
      EMPTY TEMP-TABLE PEDI.
      FOR EACH ITEM WHERE ITEM.Libre_c04 <> "DVXDSF":
          CREATE PEDI.
          BUFFER-COPY ITEM TO PEDI.
          DELETE ITEM.
      END.
      /* Recalculamos */
      RUN Procesa-Handle IN lh_Handle ('Recalculo').
      /* Reconstruimos */
      FOR EACH PEDI:
          CREATE ITEM.
          BUFFER-COPY PEDI TO ITEM.
      END.
  END.
  FOR EACH ITEM WHERE ITEM.ImpLin > 0 BY ITEM.NroItm: 
      I-NITEM = I-NITEM + 1.
      CREATE FacDPedi.
      BUFFER-COPY ITEM 
          TO FacDPedi
          ASSIGN
              FacDPedi.CodCia = FacCPedi.CodCia
              FacDPedi.CodDiv = FacCPedi.CodDiv
              FacDPedi.coddoc = FacCPedi.coddoc
              FacDPedi.NroPed = FacCPedi.NroPed
              FacDPedi.FchPed = FacCPedi.FchPed
              FacDPedi.Hora   = FacCPedi.Hora 
              FacDPedi.FlgEst = FacCPedi.FlgEst
              FacDPedi.NroItm = I-NITEM.
  END.
  RUN Descuentos-Finales-01.
  RUN Descuentos-Finales-02.

  /* RHC DESCUENTOS ESPECIALES SOLO CAMPAÑA */
  RUN Descuentos-solo-campana.

  {vta2/graba-totales-cotizacion-cred.i}

  /* **************** RHC 24.07.2014 MARGEN MINIMO POR DIVISION ****************** */
  DEF VAR pError AS CHAR.

  RUN vtagn/p-margen-utilidad-por-cotizacion ( ROWID(Faccpedi) , YES, OUTPUT pError ).
  IF pError = "ADM-ERROR" THEN ASSIGN Faccpedi.FlgEst = "T".
  IF Faccpedi.FlgEst = "T" AND pError = "OK" THEN ASSIGN Faccpedi.FlgEst = "P".    /* APROBADO */

  IF AVAILABLE(Faccorre) THEN RELEASE FacCorre.
  IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.

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

  IF NOT AVAILABLE FaccPedi THEN RETURN "ADM-ERROR".
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDoc = S-CODDOC 
      AND FacCorre.NroSer = s-NroSer
      NO-LOCK NO-ERROR.
  IF FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  IF s-TpoPed = "S" AND FacCPedi.Libre_C05 = "1" THEN DO:
      MESSAGE 'Copia NO permitida' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.

  /* CONTROL DE COPIA */
  IF Faccpedi.flgest = "P" THEN DO:
      IF NOT CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE Facdpedi.canate > 0 NO-LOCK) THEN DO:
          MESSAGE 'Desea dar de baja a la Cotización' Faccpedi.nroped '(S/N)?' SKIP(2)
              "NOTA: si no tiene atenciones parciales entonces se ANULA la cotización"
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
              UPDATE rpta AS LOG.
          IF rpta = ? THEN RETURN 'ADM-ERROR'.
          IF rpta = NO THEN DO:
              /* Seguridad */
              RUN vta2/gConfirmaCopia ("CONFIRMAR NO BAJA DE COTIZACION", OUTPUT pParametro).
              IF pParametro = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
          END.
          ELSE DO:
              FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
              IF NOT AVAILABLE Faccpedi THEN RETURN 'ADM-ERROR'.
              ASSIGN
                  Faccpedi.flgest = "X".    /* CERRADO MANUALMENTE */
              /* RHC 15/10/2013 Si NO tienen atenciones entonces la anulamos */
              IF NOT CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE Facdpedi.canate > 0 NO-LOCK)
                  THEN Faccpedi.flgest = "A".       /* ANULADO */
              FIND CURRENT Faccpedi NO-LOCK.
              RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
          END.
      END.
  END.

  ASSIGN
      s-CodMon = Faccpedi.codmon
      s-CodCli = Faccpedi.codcli
      /*s-CndVta = Faccpedi.fmapgo*/
      s-CndVta = ""     /* La condición de venta depende del cliente */
      s-TpoCmb = 1
      s-FlgIgv = Faccpedi.FlgIgv
      s-Copia-Registro = YES    /* <<< OJO >>> */
      s-PorIgv = FacCfgGn.PorIgv
      s-NroDec = Faccpedi.Libre_d01
      s-Import-IBC = NO
      s-Import-Cissac = NO.
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
          STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ FacCPedi.NroPed
          TODAY @ FacCPedi.FchPed
          S-TPOCMB @ FacCPedi.TpoCmb
          (TODAY + s-DiasVtoCot) @ FacCPedi.FchVen
          s-CndVta @ FacCPedi.FmaPgo.
      APPLY "ENTRY":U TO FacCPedi.CodCli.       /* Obligamos a cambiar de cliente */
  END.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
/*   RUN Procesa-Handle IN lh_Handle ('Recalculo'). */
/*   RUN Procesa-Handle IN lh_Handle ('Browse').    */

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
  IF NOT AVAILABLE FacCPedi THEN RETURN "ADM-ERROR".
  FIND CURRENT FacCPedi NO-LOCK NO-ERROR.
  IF LOOKUP(FacCPedi.FlgEst,"P,E,V") = 0 THEN DO:
      MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.

  /* BLOQUEAR SI SE HA TRABAJADO CON OTRA LISTA DE PRECIOS */
  IF pCodDiv <> Faccpedi.Libre_c01 THEN DO:
      MESSAGE 'NO puede anular una Cotización generada con otra lista de precios'
          VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  /* ***************************************************** */
  
  /* Si tiene atenciones parciales tambien se bloquea */
  FIND FIRST facdpedi OF faccpedi WHERE CanAte > 0 NO-LOCK NO-ERROR.
  IF AVAILABLE facdpedi 
  THEN DO:
      MESSAGE "La Cotización tiene atenciones parciales" SKIP
          "Acceso denegado"
          VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.


    
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND CURRENT FacCPedi EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE FacCPedi THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN                 
          FacCPedi.UsrAprobacion = s-user-id
          FacCPedi.FchAprobacion = TODAY
          FacCPedi.FlgEst = 'A'
          FacCPedi.Glosa  = "ANULADO POR: " + TRIM (s-user-id) + " EL DIA: " + STRING(TODAY) + " " + STRING(TIME, 'HH:MM').
      FIND CURRENT FacCPedi NO-LOCK.
      /* Si es Compra Plaza Vea */
      IF FacCPedi.codcli = '20100070970' THEN DO:
          DISABLE TRIGGERS FOR LOAD OF factabla.

          FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                  factabla.tabla = 'OC PLAZA VEA' AND 
                  factabla.codigo = FacCPedi.ordcmp EXCLUSIVE NO-ERROR.
          IF AVAILABLE factabla THEN DO:
              ASSIGN factabla.codigo = TRIM(factabla.codigo) + " - Anulado el " + STRING(NOW,"99/99/9999 HH:MM:SS").
          END.
      END.
      /*  */
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
      FILL-IN-sede:SCREEN-VALUE = "".
      FIND GN-ClieD WHERE GN-ClieD.CodCia = CL-CODCIA
          AND GN-ClieD.CodCli = FacCPedi.Codcli
          AND GN-ClieD.sede = FacCPedi.sede
          NO-LOCK NO-ERROR.
      IF AVAILABLE GN-ClieD THEN FILL-IN-sede:SCREEN-VALUE = GN-ClieD.dircli.
      F-NomVen:SCREEN-VALUE = "".
      FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
          AND  gn-ven.CodVen = FacCPedi.CodVen 
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
      F-CndVta:SCREEN-VALUE = "".
      FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
      IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.

      /*  */
      PuntoDistribucion:SCREEN-VALUE = "".
      FIND FIRST almacen WHERE almacen.codcia = s-codcia AND
                    almacen.codalm = faccpedi.lugent2 NO-LOCK NO-ERROR.
      IF AVAILABLE almacen THEN DO:
        PuntoDistribucion:SCREEN-VALUE = almacen.descripcion.
      END.
      
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
          FacCPedi.DirCli:SENSITIVE = NO
          FacCPedi.NomCli:SENSITIVE = NO
          FacCPedi.RucCli:SENSITIVE = NO
          FacCPedi.FaxCli:SENSITIVE = NO
          FacCPedi.TpoCmb:SENSITIVE = NO.
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'NO' THEN DO:
          FacCPedi.CodCli:SENSITIVE = NO.
          IF s-tpoped = "M" THEN DO:    /* SOLO PARA CONTRATO MARCO */
              ASSIGN
                  FacCPedi.DirCli:SENSITIVE = YES
                  FacCPedi.NomCli:SENSITIVE = YES.
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
  MESSAGE '¿Para Imprimir el documento marque'  SKIP
          '   1. Si = Incluye IGV.      ' SKIP
          '   2. No = No incluye IGV.      '
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
        UPDATE lchoice AS LOGICAL.
  IF lchoice = ? THEN RETURN 'adm-error'.
  IF FacCPedi.FlgEst <> "A" THEN DO:
      RUN VTA\R-ImpCot-1 (ROWID(FacCPedi),lchoice).
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
  F-Observa = FacCPedi.Observa.
  RUN vtamay/d-cotiza (INPUT-OUTPUT F-Observa,  
                        F-CndVta:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                        YES,
                        (DATE(FacCPedi.FchVen:SCREEN-VALUE IN FRAME {&FRAME-NAME}) - DATE(FacCPedi.FchPed:SCREEN-VALUE IN FRAME {&FRAME-NAME})) + 1
                        ).
  IF F-Observa = '***' THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* Code placed here will execute AFTER standard behavior.    */
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

IF NOT AVAILABLE Faccpedi THEN RETURN.
IF Faccpedi.flgest <> 'P' THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

FIND CURRENT FacCPedi EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE FacCPedi THEN RETURN.
CREATE B-CPEDI.
BUFFER-COPY FacCPedi TO B-CPEDI
    ASSIGN
        B-CPEDI.CodDiv = '00018'.
FOR EACH FacDPedi OF FacCPedi NO-LOCK:
    CREATE B-DPEDI.
    BUFFER-COPY FacDPedi TO B-DPEDI
        ASSIGN
            B-DPEDI.CodDiv = B-CPEDI.CodDiv.
END.
ASSIGN
    FacCPedi.FlgEst = "X"       /* CERRADA */
    FacCPedi.FchAprobacion  = TODAY
    FacCPedi.UsrAprobacion = s-user-id.

FIND CURRENT FacCPedi NO-LOCK.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Precios V-table-Win 
PROCEDURE Recalcular-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/recalcularprecioscreditomay.i}

RUN Procesa-Handle IN lh_handle ('Browse').

/*
DEFINE VARIABLE S-UNDVTA AS CHAR NO-UNDO.
DEFINE VARIABLE F-FACTOR AS DECI NO-UNDO.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE X-CANPED AS DECI NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE Z-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE x-TipDto AS CHAR NO-UNDO.

SESSION:SET-WAIT-STATE('GENERAL').
FOR EACH ITEM, FIRST Almmmatg OF ITEM NO-LOCK:
    ASSIGN
        F-FACTOR = ITEM.Factor
        x-CanPed = ITEM.CanPed
        s-UndVta = ITEM.UndVta
        f-PreVta = ITEM.PreUni
        f-PreBas = ITEM.PreBas
        f-Dsctos = ITEM.PorDto
        z-Dsctos = ITEM.Por_Dsctos[2]
        y-Dsctos = ITEM.Por_Dsctos[3].
    IF NOT (s-Import-IBC = YES OR s-Import-Cissac = YES)
        THEN RUN vta2/PrecioListaxMayorCredito (
            s-TpoPed,
            pCodDiv,
            s-CodCli,
            s-CodMon,
            INPUT-OUTPUT s-UndVta,
            OUTPUT f-Factor,
            Almmmatg.CodMat,
            s-CndVta,
            x-CanPed,
            s-NroDec,
            OUTPUT f-PreBas,
            OUTPUT f-PreVta,
            OUTPUT f-Dsctos,
            OUTPUT y-Dsctos,
            OUTPUT z-Dsctos,
            OUTPUT x-TipDto,
            ITEM.TipVta,
            TRUE
            ).
    ASSIGN 
        ITEM.Factor = f-Factor
        ITEM.UndVta = s-UndVta
        ITEM.PreUni = F-PREVTA
        ITEM.PreBas = F-PreBas 
        ITEM.PreVta[1] = F-PreVta   /* CONTROL DE PRECIO DE LISTA */
        ITEM.PorDto = F-DSCTOS      /* Ambos descuentos afectan */
        ITEM.PorDto2 = 0            /* el precio unitario */
        ITEM.Por_Dsctos[2] = z-Dsctos
        ITEM.Por_Dsctos[3] = Y-DSCTOS 
        ITEM.AftIgv = Almmmatg.AftIgv
        ITEM.AftIsc = Almmmatg.AftIsc
        ITEM.ImpIsc = 0
        ITEM.ImpIgv = 0.
    ASSIGN
        ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                    ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
    IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
        THEN ITEM.ImpDto = 0.
    ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
    ASSIGN
        ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
        ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
    IF ITEM.AftIsc THEN 
        ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
    ELSE ITEM.ImpIsc = 0.
    IF ITEM.AftIgv THEN  
        ITEM.ImpIgv = ITEM.ImpLin - ROUND(ITEM.ImpLin  / (1 + (s-PorIgv / 100)),4).
    ELSE ITEM.ImpIgv = 0.
END.
SESSION:SET-WAIT-STATE('').

RUN Procesa-Handle IN lh_handle ('Browse').
*/

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
      RUN vtagn/p-gn-clie-01 (Faccpedi.CodCli:SCREEN-VALUE , s-coddoc).
      IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

      FIND gn-clie WHERE gn-clie.codcia = cl-codcia
          AND gn-clie.codcli = Faccpedi.codcli:SCREEN-VALUE
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-clie THEN DO:
          MESSAGE 'Cliente No registrado' VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO FacCPedi.Glosa.
          RETURN 'ADM-ERROR'.
      END.

      /* CONTRATO MARCO -> CHEQUEO DE CANAL */
      IF s-TpoPed = "M" AND gn-clie.canal <> '006' THEN DO:
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
     /* rhc 22.06.09 Control de Precios IBC */
     IF s-Import-IBC = YES THEN DO:
         RUN CONTROL-IBC.
         IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
     END.
     /* RHC 23.06.10 COntrol de sedes por autoservicios
          Los clientes deben estar inscritos en la opcion DESCUENTOS E INCREMENTOS */
     FIND FacTabla WHERE FacTabla.codcia = s-codcia
         AND FacTabla.Tabla = 'AU'
         AND FacTabla.Codigo = Faccpedi.codcli:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE FacTabla AND Faccpedi.Sede:SCREEN-VALUE = '' THEN DO:
         MESSAGE 'Debe registrar la sede para este cliente' VIEW-AS ALERT-BOX ERROR.
         APPLY 'ENTRY':U TO FacCPedi.Sede.
         RETURN 'ADM-ERROR'.
     END.
     IF Faccpedi.Sede:SCREEN-VALUE <> '' THEN DO:
         FIND Gn-clied OF Gn-clie WHERE Gn-clied.Sede = Faccpedi.Sede:SCREEN-VALUE NO-LOCK NO-ERROR.
          IF NOT AVAILABLE gn-clied THEN DO:
              MESSAGE 'Sede no registrada para este cliente' VIEW-AS ALERT-BOX ERROR.
              APPLY 'ENTRY':U TO FacCPedi.Sede.
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
     /* RHC 09/05/2014 SOLO condiciones de ventas válidas */
     IF gn-convt.Estado <> "A" THEN DO:
         MESSAGE "Condición Venta Inactiva" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO FacCPedi.FmaPgo.
         RETURN "ADM-ERROR".   
     END.
     /* RHC 21.08.2014 Control de FAI */
     FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK.
     IF gn-convt.Libre_L01 = YES AND gn-divi.FlgRep = NO THEN DO:
         MESSAGE 'Condición de venta NO válida para esta división' VIEW-AS ALERT-BOX ERROR.
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
     /* VALIDACION DE AFECTO A IGV */
     IF s-flgigv = NO THEN DO:
         MESSAGE 'La cotización NO ESTA AFECTA A IGV' SKIP
             'Es eso correcto?'
             VIEW-AS ALERT-BOX QUESTION
             BUTTONS YES-NO UPDATE rpta AS LOG.
         IF rpta = NO THEN RETURN 'ADM-ERROR'.
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
     /* VALIDACION DE MONTO MINIMO POR BOLETA */
     F-BOL = IF INTEGER(FacCPedi.CodMon:SCREEN-VALUE) = 1 
         THEN F-TOT
         ELSE F-Tot * DECIMAL(FacCPedi.TpoCmb:SCREEN-VALUE).
     IF Faccpedi.Cmpbnte:SCREEN-VALUE = 'BOL' AND F-BOL > ImpMinDNI 
         AND (FacCPedi.Atencion:SCREEN-VALUE = '' OR LENGTH(FacCPedi.Atencion:SCREEN-VALUE, "CHARACTER") < 8)
     THEN DO:
         MESSAGE "Venta Mayor a" ImpMinDNI SKIP
                 "Debe ingresar en DNI"
             VIEW-AS ALERT-BOX ERROR.
         APPLY 'ENTRY':U TO FacCPedi.Atencion.
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
     IF FacCPedi.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '11111111112'
         AND FacCPedi.FmaPgo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '900' 
         AND FacCPedi.NroCard:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '' THEN DO:
         MESSAGE "Ingrese el numero de tarjeta" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO FacCPedi.NroCard.
         RETURN "ADM-ERROR".   
     END.
     IF FacCPedi.FmaPgo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '900'
         AND FacCPedi.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> '11111111112'
         AND FacCPedi.NroCard:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> '' THEN DO:
         MESSAGE "En caso de transferencia gratuita NO es válido el Nº de Tarjeta" 
             VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO FacCPedi.NroCard.
         RETURN "ADM-ERROR".   
     END.
     IF INPUT FacCPedi.FchVen < INPUT FacCPedi.fchped THEN DO:
         MESSAGE 'Ingrese correctamente la fecha de vencimiento' VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO FacCPedi.FchVen.
         RETURN "ADM-ERROR".   
     END.
     IF INPUT FacCPedi.FchEnt < INPUT FacCPedi.fchped THEN DO:
         MESSAGE 'Ingrese correctamente la fecha de entrega' VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO FacCPedi.FchEnt.
         RETURN "ADM-ERROR".   
     END.
     /* RHC 14/02/2015 VALIDA FOTOCOPIAS */
     FOR EACH ITEM, FIRST Almmmatg OF ITEM NO-LOCK WHERE Almmmatg.codfam = '011':
         IF GN-DIVI.CanalVenta = 'TDA' AND INPUT Faccpedi.codmon = 1
             AND Almmmatg.codfam = '011' AND gn-ConVt.TotDias > 45 THEN DO:
             MESSAGE 'NO se puede vender papel fotocopia a mas de 45 dias en SOLES' SKIP
                 'Cambiar la moneda de venta a DOLARES'
                 VIEW-AS ALERT-BOX ERROR.
             APPLY 'ENTRY':U TO Faccpedi.codmon.
             RETURN "ADM-ERROR". 
         END.
     END.
     /* RHC 17/02/2015 VALIDACION FECHA VENCIMIENTO */
     IF INPUT FacCPedi.FchVen - INPUT FacCPedi.fchped > s-DiasVtoCot THEN DO:
         MESSAGE 'La fecha de vencimiento no puede ser mayor a' s-DiasVtoCot 'días' VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO FacCPedi.FchVen.
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

IF NOT AVAILABLE FacCPedi THEN RETURN "ADM-ERROR".
IF LOOKUP(FacCPedi.FlgEst,"E,P,T") = 0 THEN DO:
    MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
IF FacCPedi.FchVen < TODAY THEN DO:
    MESSAGE 'Cotización venció el' faccpedi.fchven SKIP
        'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
/* Si tiene atenciones parciales tambien se bloquea */
FIND FIRST facdpedi OF faccpedi WHERE CanAte > 0 NO-LOCK NO-ERROR.
IF AVAILABLE facdpedi 
THEN DO:
    MESSAGE "La Cotización tiene atenciones parciales" SKIP
        "Acceso denegado"
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
/* BLOQUEAR SI SE HA TRABAJADO CON OTRA LISTA DE PRECIOS */
IF pCodDiv <> Faccpedi.Libre_c01 THEN DO:
    MESSAGE 'NO puede modificar una Cotización generada con otra lista de precios'
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
/* ***************************************************** */
ASSIGN
    S-CODMON = FacCPedi.CodMon
    S-CODCLI = FacCPedi.CodCli
    S-TPOCMB = FacCPedi.TpoCmb
    S-CNDVTA = FacCPedi.FmaPgo
    s-Copia-Registro = NO
    s-PorIgv = Faccpedi.porigv
    s-NroDec = (IF Faccpedi.Libre_d01 <= 0 THEN 4 ELSE Faccpedi.Libre_d01)
    s-FlgIgv = Faccpedi.FlgIgv
    s-Import-IBC = NO
    s-Import-Cissac = NO
    s-adm-new-record = "NO"
    s-nroped = Faccpedi.nroped
    S-CMPBNTE = Faccpedi.Cmpbnte.
IF FacCPedi.Libre_C05 = "1" THEN s-Import-Ibc = YES.
IF FacCPedi.Libre_C05 = "2" THEN s-Import-Cissac = YES.

RUN Carga-Temporal.
/* Cargamos las condiciones de venta válidas */
FIND gn-clie WHERE gn-clie.codcia  = cl-codcia
    AND gn-clie.codcli = s-codcli
    NO-LOCK.
/*RUN vtagn/p-fmapgo-01 (s-codcli, OUTPUT s-cndvta-validos).*/
RUN vta2/p-fmapgo (s-codcli, s-tpoped, OUTPUT s-cndvta-validos).

RUN Procesa-Handle IN lh_Handle ('Pagina2').
RUN Procesa-Handle IN lh_Handle ('browse').
RUN Procesa-Handle IN lh_handle ("Disable-Button-CISSAC").
/* RHC 14/10/2013 ***************************************************************** */
/* SOLO PARA PROVINCIAS VENTA LISTA GENERAL (LIMA)                                  */
IF s-TpoPed = "P" THEN DO:
  FIND gn-divi WHERE gn-divi.codcia = s-codcia
      AND gn-divi.coddiv = pCodDiv
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-divi AND gn-divi.VentaMayorista = 1 THEN DO:  /* LISTA GENERAL */
      RUN Procesa-Handle IN lh_Handle ('Pagina3').
  END.
END.
/* ******************************************************************************** */

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

