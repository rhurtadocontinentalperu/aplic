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
DEFINE SHARED VAR s-acceso-total  AS LOG.   /* Control GRE */

/* Local Variable Definitions ---                                       */

DEFINE SHARED VARIABLE S-NROSER  AS INTEGER.
DEFINE SHARED VARIABLE lh_Handle AS HANDLE.
DEFINE SHARED VARIABLE S-MOVVAL  AS LOGICAL.
DEFINE SHARED VARIABLE C-CODALM  AS CHAR.
DEFINE SHARED VARIABLE ORDTRB    AS CHAR.

DEFINE SHARED VARIABLE S-TPOMOV AS CHAR.    /* Salidas */
DEFINE SHARED VARIABLE C-CODMOV AS CHAR.    /* Mov Válidos */
DEFINE SHARED VARIABLE L-NROSER AS CHAR.    /* Nº Serie Válidos */

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHAR.

DEFINE VAR x-serie AS INT INIT 0.
DEFINE VAR x-numero AS INT INIT 0.
DEFINE VAR x-eliminando AS LOG INIT NO.

DEFINE VAR l-crea AS LOG INIT NO.

DEFINE SHARED TEMP-TABLE ITEM-gre LIKE gre_detail.

DEFINE VAR cDivisionOrigen AS CHAR.
DEFINE VAR cDivisionDestino AS CHAR.
DEFINE VAR cPuntoOrigen AS CHAR.
DEFINE VAR cPuntoDestino AS CHAR.
DEFINE VAR cUbigeoOrigen AS CHAR.
DEFINE VAR cUbigeoDestino AS CHAR.
DEFINE VAR cDireccionOrigen AS CHAR.
DEFINE VAR cDireccionDestino AS CHAR.
DEFINE VAR cRUCcliente AS CHAR.
DEFINE VAR cRUCProveedor AS CHAR.
DEFINE VAR cDNIcliente AS CHAR.
DEFINE VAR cNomRef AS CHAR.
DEFINE VAR cParteDeIngreso AS CHAR.

DEFINE VAR cUbigeoCliente AS CHAR.
DEFINE VAR cPuntoCliente AS CHAR.
DEFINE VAR cDireccionCliente AS CHAR.

DEFINE VAR cUbigeoProveedor AS CHAR.
DEFINE VAR cPuntoProveedor AS CHAR.
DEFINE VAR cDireccionProveedor AS CHAR.

DEFINE BUFFER x-faccpedi FOR faccpedi.
DEFINE BUFFER x-almcmov  FOR Almcmov.
DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.

DEFINE BUFFER b-gre_detail FOR gre_detail.
DEFINE BUFFER b-gre_header FOR gre_header.
DEFINE BUFFER b-faccpedi FOR faccpedi.

DEFINE SHARED VAR s-CodRef  AS CHAR.
DEFINE SHARED VAR s-Reposicion AS LOG.
DEFINE SHARED VAR s-OrdenDespacho AS LOG.
DEFINE VAR x-cotizacion-ok AS LOG.

/* 03 */
DEFINE SHARED VARIABLE s-FlgPicking LIKE GN-DIVI.FlgPicking.
DEFINE SHARED VARIABLE s-FlgBarras  LIKE GN-DIVI.FlgBarras.
DEFINE SHARED VAR s-AlmDes LIKE  Almcmov.AlmDes.    /* Almacen destino */

/**/
DEFINE VAR ctipoDocumentoContinental AS CHAR INIT '6'.
DEFINE VAR cnumeroDocumentoContinental AS CHAR INIT '20100038146'.
DEFINE VAR crazonSocialContinental AS CHAR INIT 'Continental SAC'.

DEFINE VAR cm_libre_c05 AS CHAR.
DEFINE VAR lm_libre_l02 LIKE FacCPedi.VtaPuntual.

DEFINE VAR lMueveStock AS LOG INIT NO.

DEFINE VAR lGRE_ONLINE AS LOG.

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
&Scoped-define EXTERNAL-TABLES gre_header Almtdocm Almtmovm
&Scoped-define FIRST-EXTERNAL-TABLE gre_header


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR gre_header, Almtdocm, Almtmovm.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS gre_header.fechaEmisionGuia ~
gre_header.horaEmisionGuia gre_header.m_codalm gre_header.m_codalmdes ~
gre_header.m_cliente gre_header.m_proveedor gre_header.m_usuario ~
gre_header.m_sede gre_header.m_llevar_traer_mercaderia gre_header.m_nroref1 ~
gre_header.pesoBrutoTotalBienes gre_header.m_nroref2 ~
gre_header.numeroBultos gre_header.m_serie_pi gre_header.m_numero_pi ~
gre_header.m_nroref3 gre_header.m_cco gre_header.observaciones ~
gre_header.m_coddoc gre_header.m_nroser gre_header.m_nrodoc ~
gre_header.m_almacenXD gre_header.m_crossdocking ~
gre_header.codigoPtoPartida 
&Scoped-define ENABLED-TABLES gre_header
&Scoped-define FIRST-ENABLED-TABLE gre_header
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 BUTTON-excel BUTTON-otr 
&Scoped-Define DISPLAYED-FIELDS gre_header.ncorrelatio ~
gre_header.fechaEmisionGuia gre_header.horaEmisionGuia gre_header.serieGuia ~
gre_header.numeroGuia gre_header.m_codalm gre_header.m_codalmdes ~
gre_header.m_cliente gre_header.m_rspta_sunat gre_header.m_proveedor ~
gre_header.m_usuario gre_header.m_sede gre_header.m_llevar_traer_mercaderia ~
gre_header.m_nroref1 gre_header.pesoBrutoTotalBienes gre_header.m_nroref2 ~
gre_header.numeroBultos gre_header.m_serie_pi gre_header.m_numero_pi ~
gre_header.m_nroref3 gre_header.m_cco gre_header.observaciones ~
gre_header.m_coddoc gre_header.m_nroser gre_header.m_nrodoc ~
gre_header.m_almacenXD gre_header.m_crossdocking ~
gre_header.codigoPtoPartida gre_header.direccionPtoPartida ~
gre_header.codigoPtoLlegada gre_header.direccionPtoLlegada 
&Scoped-define DISPLAYED-TABLES gre_header
&Scoped-define FIRST-DISPLAYED-TABLE gre_header
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-almacen-origen ~
FILL-IN-almacen-destino FILL-IN-cliente FILL-IN-proveedor ~
FILL-IN-muevestock FILL-IN-sede FILL-IN-almacen-final FILL-IN-recepcionado ~
FILL-IN-txt-ref1 FILL-IN-txt-ref-2 FILL-IN-txt-ref-3 

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
DEFINE BUTTON BUTTON-excel 
     LABEL "Excel" 
     SIZE 11 BY .96.

DEFINE BUTTON BUTTON-otr 
     LABEL "OTR" 
     SIZE 11 BY .96.

DEFINE VARIABLE FILL-IN-almacen-destino AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 49.14 BY .77 NO-UNDO.

DEFINE VARIABLE FILL-IN-almacen-final AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 56.29 BY .77 NO-UNDO.

DEFINE VARIABLE FILL-IN-almacen-origen AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 37.29 BY .77 NO-UNDO.

DEFINE VARIABLE FILL-IN-cliente AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 52.29 BY .77 NO-UNDO.

DEFINE VARIABLE FILL-IN-muevestock AS CHARACTER FORMAT "X(25)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-proveedor AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 56.29 BY .77 NO-UNDO.

DEFINE VARIABLE FILL-IN-recepcionado AS CHARACTER FORMAT "X(25)":U 
      VIEW-AS TEXT 
     SIZE 19 BY .77
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-sede AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 56.29 BY .77 NO-UNDO.

DEFINE VARIABLE FILL-IN-txt-ref-2 AS CHARACTER FORMAT "X(100)":U 
      VIEW-AS TEXT 
     SIZE 28.86 BY .62 NO-UNDO.

DEFINE VARIABLE FILL-IN-txt-ref-3 AS CHARACTER FORMAT "X(100)":U 
      VIEW-AS TEXT 
     SIZE 28.86 BY .62 NO-UNDO.

DEFINE VARIABLE FILL-IN-txt-ref1 AS CHARACTER FORMAT "X(100)":U 
      VIEW-AS TEXT 
     SIZE 28.86 BY .62 NO-UNDO.

DEFINE VARIABLE FILL-IN-Urgente AS CHARACTER FORMAT "X(15)":U INITIAL "URGENTE" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 0 FGCOLOR 14 FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 142.29 BY 10.15
     BGCOLOR 15 .

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 142.29 BY .1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     gre_header.ncorrelatio AT ROW 1.19 COL 13.29 COLON-ALIGNED NO-LABEL WIDGET-ID 12 FORMAT "9999999999"
          VIEW-AS FILL-IN 
          SIZE 12.72 BY .81
          BGCOLOR 15 FGCOLOR 9 FONT 6
     gre_header.fechaEmisionGuia AT ROW 1.19 COL 52 COLON-ALIGNED WIDGET-ID 22
          LABEL "F. Emision" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .77
          BGCOLOR 15 
     gre_header.horaEmisionGuia AT ROW 1.19 COL 63.72 COLON-ALIGNED NO-LABEL WIDGET-ID 24 FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .77
          BGCOLOR 15 
     gre_header.serieGuia AT ROW 1.19 COL 92 COLON-ALIGNED WIDGET-ID 16
          LABEL "Nro/Serie Guia" FORMAT "999"
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .77
          BGCOLOR 15 FGCOLOR 4 FONT 6
     gre_header.numeroGuia AT ROW 1.19 COL 98 COLON-ALIGNED NO-LABEL WIDGET-ID 14 FORMAT "99999999"
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .77
          BGCOLOR 15 FGCOLOR 9 FONT 6
     FILL-IN-Urgente AT ROW 1.19 COL 110 COLON-ALIGNED NO-LABEL WIDGET-ID 56
     gre_header.m_codalm AT ROW 2.04 COL 13.29 COLON-ALIGNED WIDGET-ID 4
          LABEL "Alm. Origen" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .77
     FILL-IN-almacen-origen AT ROW 2.04 COL 20.29 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     gre_header.m_codalmdes AT ROW 2.04 COL 72 COLON-ALIGNED WIDGET-ID 6
          LABEL "Alm. destino" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .77
     FILL-IN-almacen-destino AT ROW 2.04 COL 77.86 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     FILL-IN-cliente AT ROW 2.8 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     gre_header.m_cliente AT ROW 2.81 COL 13.29 COLON-ALIGNED WIDGET-ID 2
          LABEL "Cliente" FORMAT "x(15)"
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .77
     gre_header.m_rspta_sunat AT ROW 2.81 COL 93.72 COLON-ALIGNED WIDGET-ID 48
          LABEL "Estado Sunat" FORMAT "x(25)"
          VIEW-AS FILL-IN 
          SIZE 25.29 BY .77
          BGCOLOR 15 FGCOLOR 12 FONT 6
     gre_header.m_proveedor AT ROW 3.58 COL 13.29 COLON-ALIGNED WIDGET-ID 8
          LABEL "Proveedor" FORMAT "x(15)"
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .77
     FILL-IN-proveedor AT ROW 3.58 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     gre_header.m_usuario AT ROW 3.58 COL 93.72 COLON-ALIGNED WIDGET-ID 32
          LABEL "Usuario" FORMAT "x(25)"
          VIEW-AS FILL-IN 
          SIZE 16 BY .77
     FILL-IN-muevestock AT ROW 3.58 COL 116 COLON-ALIGNED NO-LABEL WIDGET-ID 82
     gre_header.m_sede AT ROW 4.35 COL 13.29 COLON-ALIGNED WIDGET-ID 10
          LABEL "Sede" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .77
     FILL-IN-sede AT ROW 4.35 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     gre_header.m_llevar_traer_mercaderia AT ROW 4.69 COL 110.57 HELP
          "" NO-LABEL WIDGET-ID 78
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "<Ninguno>", 0,
"Llevar mercaderia", 1,
"Traer mercaderia", 2
          SIZE 20.72 BY 1.88
     gre_header.m_nroref1 AT ROW 5.12 COL 29.29 COLON-ALIGNED WIDGET-ID 26
          LABEL "Referenciaaaaaaaaaaaaaa #1" FORMAT "x(15)"
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .77
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 3 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     gre_header.pesoBrutoTotalBienes AT ROW 5.12 COL 94.57 COLON-ALIGNED WIDGET-ID 72
          LABEL "Peso bruto (KG)" FORMAT "->,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 12 BY .77
          FGCOLOR 4 FONT 6
     gre_header.m_nroref2 AT ROW 5.88 COL 29.29 COLON-ALIGNED WIDGET-ID 28
          LABEL "Referenciaaaaaaaaaaaaaa #2" FORMAT "x(15)"
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .77
     gre_header.numeroBultos AT ROW 5.88 COL 94.57 COLON-ALIGNED WIDGET-ID 70
          LABEL "Bultos" FORMAT ">,>>>,>>9"
          VIEW-AS FILL-IN 
          SIZE 10 BY .77
          FGCOLOR 4 FONT 6
     gre_header.m_serie_pi AT ROW 6.62 COL 124 COLON-ALIGNED WIDGET-ID 46
          LABEL "P.I." FORMAT "9999"
          VIEW-AS FILL-IN 
          SIZE 5 BY .77
     gre_header.m_numero_pi AT ROW 6.62 COL 129.14 COLON-ALIGNED NO-LABEL WIDGET-ID 44
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .77
     gre_header.m_nroref3 AT ROW 6.65 COL 29.29 COLON-ALIGNED WIDGET-ID 30
          LABEL "Referencia #3" FORMAT "x(15)"
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .77
     gre_header.m_cco AT ROW 7.38 COL 135 COLON-ALIGNED WIDGET-ID 42
          LABEL "Centro de Costo" FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 6 BY .77
     gre_header.observaciones AT ROW 7.42 COL 5 WIDGET-ID 34
          LABEL "Observaciones" FORMAT "x(150)"
          VIEW-AS FILL-IN 
          SIZE 60 BY .77
     gre_header.m_coddoc AT ROW 7.42 COL 92 COLON-ALIGNED WIDGET-ID 62
          LABEL "Origen" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 6.43 BY .77
     gre_header.m_nroser AT ROW 7.42 COL 98.72 COLON-ALIGNED NO-LABEL WIDGET-ID 66
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .77
     gre_header.m_nrodoc AT ROW 7.42 COL 104.43 COLON-ALIGNED NO-LABEL WIDGET-ID 64
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .77
     gre_header.m_almacenXD AT ROW 8.19 COL 20.86 COLON-ALIGNED WIDGET-ID 58 AUTO-RETURN 
          LABEL "Destino Final" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 6.43 BY .77
     FILL-IN-almacen-final AT ROW 8.19 COL 27.43 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     BUTTON-excel AT ROW 8.19 COL 94.57 WIDGET-ID 74
     BUTTON-otr AT ROW 8.19 COL 107 WIDGET-ID 50
     gre_header.m_crossdocking AT ROW 8.19 COL 135 COLON-ALIGNED WIDGET-ID 54
          LABEL "CrossDocking"
          VIEW-AS FILL-IN 
          SIZE 4.43 BY .77
     gre_header.codigoPtoPartida AT ROW 9.31 COL 15.43 COLON-ALIGNED WIDGET-ID 94
          LABEL "Pto. Partida" FORMAT "x(4)"
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     gre_header.direccionPtoPartida AT ROW 9.31 COL 22.86 NO-LABEL WIDGET-ID 98
          VIEW-AS FILL-IN 
          SIZE 86 BY .88
     gre_header.codigoPtoLlegada AT ROW 10.19 COL 15.43 COLON-ALIGNED WIDGET-ID 92
          LABEL "Pto. Llegada" FORMAT "x(4)"
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     gre_header.direccionPtoLlegada AT ROW 10.19 COL 22.86 NO-LABEL WIDGET-ID 96
          VIEW-AS FILL-IN 
          SIZE 86.29 BY .88
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 3 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     FILL-IN-recepcionado AT ROW 2.8 COL 121.43 COLON-ALIGNED NO-LABEL WIDGET-ID 90
     FILL-IN-txt-ref1 AT ROW 5.12 COL 46.14 COLON-ALIGNED NO-LABEL WIDGET-ID 84
     FILL-IN-txt-ref-2 AT ROW 5.88 COL 46.14 COLON-ALIGNED NO-LABEL WIDGET-ID 86
     FILL-IN-txt-ref-3 AT ROW 6.65 COL 46.14 COLON-ALIGNED NO-LABEL WIDGET-ID 88
     "Nro. PGRE :" VIEW-AS TEXT
          SIZE 11.72 BY .96 AT ROW 1.19 COL 3.29 WIDGET-ID 76
          FGCOLOR 4 FONT 10
     RECT-2 AT ROW 1.08 COL 1.72 WIDGET-ID 68
     RECT-3 AT ROW 9.15 COL 1.72 WIDGET-ID 100
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 3 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.gre_header,INTEGRAL.Almtdocm,INTEGRAL.Almtmovm
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
         HEIGHT             = 10.38
         WIDTH              = 151.72.
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

/* SETTINGS FOR FILL-IN gre_header.codigoPtoLlegada IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN gre_header.codigoPtoPartida IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gre_header.direccionPtoLlegada IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN gre_header.direccionPtoPartida IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN gre_header.fechaEmisionGuia IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-almacen-destino IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-almacen-final IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-almacen-origen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-cliente IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-muevestock IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-proveedor IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-recepcionado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-sede IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-txt-ref-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-txt-ref-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-txt-ref1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Urgente IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN-Urgente:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN gre_header.horaEmisionGuia IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gre_header.m_almacenXD IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
ASSIGN 
       gre_header.m_almacenXD:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN gre_header.m_cco IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gre_header.m_cliente IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gre_header.m_codalm IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
ASSIGN 
       gre_header.m_codalm:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN gre_header.m_codalmdes IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gre_header.m_coddoc IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
ASSIGN 
       gre_header.m_coddoc:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN gre_header.m_crossdocking IN FRAME F-Main
   EXP-LABEL                                                            */
ASSIGN 
       gre_header.m_crossdocking:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR RADIO-SET gre_header.m_llevar_traer_mercaderia IN FRAME F-Main
   EXP-HELP                                                             */
ASSIGN 
       gre_header.m_nrodoc:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN gre_header.m_nroref1 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gre_header.m_nroref2 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gre_header.m_nroref3 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
ASSIGN 
       gre_header.m_nroser:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN gre_header.m_proveedor IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gre_header.m_rspta_sunat IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN gre_header.m_sede IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gre_header.m_serie_pi IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gre_header.m_usuario IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
ASSIGN 
       gre_header.m_usuario:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN gre_header.ncorrelatio IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN gre_header.numeroBultos IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gre_header.numeroGuia IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN gre_header.observaciones IN FRAME F-Main
   ALIGN-L EXP-LABEL EXP-FORMAT                                         */
/* SETTINGS FOR FILL-IN gre_header.pesoBrutoTotalBienes IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
ASSIGN 
       gre_header.pesoBrutoTotalBienes:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN gre_header.serieGuia IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
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

&Scoped-define SELF-NAME BUTTON-excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-excel V-table-Win
ON CHOOSE OF BUTTON-excel IN FRAME F-Main /* Excel */
DO:

    RUN Procesa-Handle IN lh_Handle ('ImportarDesdeExcel').
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-otr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-otr V-table-Win
ON CHOOSE OF BUTTON-otr IN FRAME F-Main /* OTR */
DO:
    ASSIGN
      s-CodRef = "OTR"
      s-Reposicion = YES
      s-OrdenDespacho = NO
      s-AlmDes = ''.
    
  ASSIGN
      input-var-1 = s-codref        /* coddoc */
      input-var-2 = 'P'             /* flgest */
      input-var-3 = 'C'             /* flgsit Cheque Barras SALIDA OK */
      output-var-1 = ?.
  RUN lkup/c-otr-v2.r ("Ordenes de Transferencia").
  IF output-var-1 = ? THEN RETURN "ADM-ERROR".

  FIND FIRST faccpedi WHERE ROWID(faccpedi) = output-var-1 NO-LOCK NO-ERROR.

  IF NOT AVAILABLE faccpedi THEN RETURN "ADM-ERROR".
  
  FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE ( Facdpedi.CanPed - Facdpedi.CanAte > 0 ):
      /* 28/10/2022: Tiene que estar registrado en los almacenes */
      IF NOT CAN-FIND(FIRST Almmmate WHERE Almmmate.CodCia = s-codcia AND
                      Almmmate.CodAlm = Faccpedi.CodAlm AND 
                      Almmmate.codmat = Facdpedi.CodMat NO-LOCK)
          THEN DO:
          MESSAGE 'Artículo' Facdpedi.CodMat 'NO registrado en el almacén' Faccpedi.CodAlm SKIP
              'Contactar con el Gestor de SKU para completar la configuración de los almacenes' SKIP(2)
              'Proceso Abortado' VIEW-AS ALERT-BOX ERROR.
          /*RETURN 'ADM-ERROR'.*/
          RETURN NO-APPLY.
      END.
      IF NOT CAN-FIND(FIRST Almmmate WHERE Almmmate.CodCia = s-codcia AND
                      Almmmate.CodAlm = Faccpedi.codcli AND 
                      Almmmate.codmat = Facdpedi.CodMat NO-LOCK)
          THEN DO:
          MESSAGE 'Artículo' Facdpedi.CodMat 'NO registrado en el almacén' Faccpedi.codcli SKIP
              'Contactar con el Gestor de SKU para completar la configuración de los almacenes' SKIP(2)
              'Proceso Abortado' VIEW-AS ALERT-BOX ERROR.
          /*RETURN 'ADM-ERROR'.*/
          RETURN NO-APPLY.
      END.
  END.

  /* Ic - 26Set2018 */
  x-cotizacion-ok = YES.

  DEFINE VAR dPeso AS DEC.
  DEFINE VAR iBultos AS INT.
  
  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FIND FIRST Faccpedi WHERE ROWID(Faccpedi) = output-var-1 NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Faccpedi THEN DO:
          MESSAGE "No existe OTR".
          RETURN "ADM-ERROR".
      END.

        s-AlmDes = Faccpedi.codcli.      /* Almacen destino */          

          ASSIGN gre_header.m_CodAlm:SCREEN-VALUE = Faccpedi.codalm
                gre_header.m_codAlmDes:SCREEN-VALUE = Faccpedi.codcli
          gre_header.m_Coddoc:SCREEN-VALUE = Faccpedi.coddoc
          gre_header.m_nroser:SCREEN-VALUE = substring(Faccpedi.nroped,1,3)
          gre_header.m_nrodoc:SCREEN-VALUE = substring(Faccpedi.nroped,4)
          gre_header.Observaciones:SCREEN-VALUE = FacCPedi.Glosa
          gre_header.m_AlmacenXD:SCREEN-VALUE = Faccpedi.AlmacenXD
          gre_header.m_NroRef3:SCREEN-VALUE = Faccpedi.Libre_c03.

      ASSIGN          
          gre_header.m_CrossDocking:SCREEN-VALUE = STRING(Faccpedi.CrossDocking).
      ASSIGN
            cm_libre_c05 = FacCPedi.MotReposicion.

          /*
          s-CodAlm = Faccpedi.CodAlm    /* OJO: Asignamos el almacén de trabajo */
          */
      /* Motivo */
      FIND FIRST FacTabla WHERE FacTabla.CodCia = Faccpedi.codcia
          AND FacTabla.Tabla = 'REPOMOTIVO'
          AND FacTabla.Codigo = FacCPedi.MotReposicion
          NO-LOCK NO-ERROR.
      /*IF AVAILABLE FacTabla THEN DISPLAY FacTabla.Nombre @ FILL-IN-Motivo.  GRE*/
      /* Urgente */
      IF FacCPedi.VtaPuntual = YES THEN DO:
          FILL-IN-Urgente:VISIBLE = YES.
          FILL-IN-Urgente:SCREEN-VALUE = 'URGENTE'.
          /*ASSIGN gre_header.m_libre_l02 = FacCPedi.VtaPuntual.*/
          lm_libre_l02 = FacCPedi.VtaPuntual.
      END.
      ELSE FILL-IN-Urgente:VISIBLE = NO.

      EMPTY TEMP-TABLE ITEM-gre.
      FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE ( Facdpedi.CanPed - Facdpedi.CanAte > 0 ):
          FIND Almmmatg WHERE Almmmatg.CodCia = Facdpedi.CodCia  
              AND Almmmatg.CodMat = Facdpedi.CodMat 
              NO-LOCK NO-ERROR. 

          /* GENERAMOS MOVIMIENTO PARA ALMACEN ORIGEN */
          CREATE ITEM-gre.
          ASSIGN 
              /*ITEM.CodCia = s-CodCia*/
              ITEM-gre.CodAlm = Faccpedi.codalm /*s-CodAlm*/
              ITEM-gre.CodMat = Facdpedi.CodMat
              /*ITEM.CodAjt = ""  gre */
              ITEM-gre.Factor = facdpedi.factor
              ITEM-gre.CodUnd = Almmmatg.UndStk
              /*ITEM-gre.AlmOri = Faccpedi.CodAlm*/
              ITEM-gre.CanDes = (Facdpedi.CanPed - Facdpedi.CanAte)
              ITEM-gre.peso_unitario = Almmmatg.pesmat
              ITEM-gre.peso_total_item = (ITEM-gre.CanDes * facdpedi.factor) * Almmmatg.pesmat
              .
              dPeso = dPeso + ITEM-gre.peso_total_item.
          IF almmmatg.pesmat <= 0 OR almmmatg.libre_d02 <= 0  THEN DO:
              x-cotizacion-ok = NO.
              MESSAGE 'Artículo' Almmmatg.codmat 'no tiene peso y/o volumen' VIEW-AS ALERT-BOX ERROR.
              RETURN NO-APPLY.
          END.

      END.
      /* Peso y Bulto */
      iBultos = 0.
      ASSIGN gre_header.pesoBrutoTotalBienes:SCREEN-VALUE = STRING(dPeso,">>,>>>,>>9.99")
            gre_header.numeroBultos:SCREEN-VALUE = "0".

      FOR EACH ccbcbult WHERE ccbcbult.codcia = s-codcia AND
                                ccbcbult.coddoc = faccpedi.coddoc AND
                                ccbcbult.nrodoc = faccpedi.nroped NO-LOCK :
          iBultos = iBultos + ccbcbult.bultos.
      END.
      ASSIGN gre_header.numeroBultos:SCREEN-VALUE = STRING(iBultos,">>>,>>9").

      APPLY 'LEAVE':U TO gre_header.m_CodAlm.
      APPLY 'LEAVE':U TO gre_header.m_codAlmDes.
      APPLY 'LEAVE':U TO gre_header.m_AlmacenXD.

   END.
   RUN Procesa-Handle IN lh_Handle ('Pagina2').

   gre_header.m_codAlmDes:SENSITIVE = NO.
   gre_header.numeroBultos:SENSITIVE = NO.
   gre_header.observaciones:SENSITIVE = NO.
   button-excel:VISIBLE = NO.

    RUN Procesa-Handle IN lh_Handle ('OcultarBotonesUpd').

   /* Ic - 26Set2018 */
   IF x-cotizacion-ok = NO THEN DO:
       MESSAGE "La transferencia tiene articulos sin pesos y volumenes, no procede la transferencia".
   END.

   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gre_header.m_almacenXD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gre_header.m_almacenXD V-table-Win
ON LEAVE OF gre_header.m_almacenXD IN FRAME F-Main /* Destino Final */
DO:
    DISPLAY "" @ fill-in-almacen-final WITH FRAME {&FRAME-NAME}.
     FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
                   AND  Almacen.CodAlm = gre_header.m_almacenXD:SCREEN-VALUE 
                  NO-LOCK NO-ERROR.
     IF AVAILABLE Almacen THEN DO:
        DISPLAY Almacen.Descripcion @ fill-in-almacen-final WITH FRAME {&FRAME-NAME}.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gre_header.m_cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gre_header.m_cliente V-table-Win
ON LEAVE OF gre_header.m_cliente IN FRAME F-Main /* Cliente */
DO:
    DISPLAY "" @ FILL-IN-Cliente WITH FRAME {&FRAME-NAME}.

  IF gre_header.m_cliente:VISIBLE THEN DO:
        FIND gn-clie WHERE gn-clie.CodCia = 0
                      AND  gn-clie.CodCli = INPUT gre_header.m_cliente
                     NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie THEN DISPLAY gn-clie.NomCli @ FILL-IN-Cliente WITH FRAME {&FRAME-NAME}.
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gre_header.m_cliente V-table-Win
ON MOUSE-SELECT-DBLCLICK OF gre_header.m_cliente IN FRAME F-Main /* Cliente */
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?
        output-var-2 = ''
        output-var-3 = ''.

    RUN vtagn/c-gn-clie-01 ('Clientes').
    IF output-var-1 <> ? THEN gre_header.m_cliente:SCREEN-VALUE = output-var-2.

    /*
    CASE TRUE:
        WHEN s-TpoPed = "M" THEN DO:
            RUN vtagn/c-gn-clie-pub ('Clientes').
        END.
        WHEN s-ClientesVIP = YES THEN DO:
            input-var-1 = pCodDiv.
            RUN vtagn/d-clientes-vip ('Clientes Expolibreria').
        END.
        OTHERWISE DO:
            RUN vtagn/c-gn-clie-01 ('Clientes').
        END.
    END CASE.
/*     IF s-TpoPed = "M" THEN input-var-1 = "006".             */
/*     IF s-ClientesVIP = YES THEN DO:                         */
/*         input-var-1 = pCodDiv.                              */
/*         RUN vtagn/d-clientes-vip ('Clientes Expolibreria'). */
/*     END.                                                    */
/*     ELSE DO:                                                */
/*         RUN vtagn/c-gn-clie-01 ('Clientes').                */
/*     END.                                                    */
    IF output-var-1 <> ? THEN FacCPedi.CodCli:SCREEN-VALUE = output-var-2.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gre_header.m_codalm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gre_header.m_codalm V-table-Win
ON LEAVE OF gre_header.m_codalm IN FRAME F-Main /* Alm. Origen */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.

  IF gre_header.m_codalm:VISIBLE THEN DO:
     FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
                   AND  Almacen.CodAlm = gre_header.m_codAlm:SCREEN-VALUE 
                  NO-LOCK NO-ERROR.
     IF NOT AVAILABLE Almacen THEN DO:
        MESSAGE "Almacen no existe" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
     END.
     DISPLAY Almacen.Descripcion @ fill-in-almacen-origen WITH FRAME {&FRAME-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gre_header.m_codalmdes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gre_header.m_codalmdes V-table-Win
ON LEAVE OF gre_header.m_codalmdes IN FRAME F-Main /* Alm. destino */
DO:
    s-AlmDes = ''.
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  IF gre_header.m_codalmdes:VISIBLE THEN DO:

     IF gre_header.m_codalmdes:SCREEN-VALUE = S-CODALM THEN DO:
        MESSAGE "Almacen " S-CODALM " No puede transferir a si mismo" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
     END.
      DEFINE VAR cDivOrg AS CHAR.
      DEFINE VAR cDivDes AS CHAR.

      FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
                    AND  Almacen.CodAlm = gre_header.m_codAlm:SCREEN-VALUE 
                   NO-LOCK NO-ERROR.
      IF AVAILABLE Almacen THEN DO:
          cDivOrg = almacen.coddiv.
      END.

     FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
                   AND  Almacen.CodAlm = gre_header.m_codAlmDes:SCREEN-VALUE 
                  NO-LOCK NO-ERROR.
     IF NOT AVAILABLE Almacen THEN DO:
        MESSAGE "Almacen no existe" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
     END.
     DISPLAY Almacen.Descripcion @ fill-in-almacen-destino WITH FRAME {&FRAME-NAME}.

     cDivDes = Almacen.coddiv.

     IF cDivDes = cDivOrg THEN DO:
         MESSAGE "El almacen origen y destino deben pertenecer a diferente division" VIEW-AS ALERT-BOX ERROR.
         RETURN NO-APPLY.
     END.

     s-AlmDes = gre_header.m_codalmdes:SCREEN-VALUE.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gre_header.m_nroref1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gre_header.m_nroref1 V-table-Win
ON LEAVE OF gre_header.m_nroref1 IN FRAME F-Main /* Referenciaaaaaaaaaaaaaa #1 */
DO:
  RUN mostrar-data-ref1(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gre_header.m_nroref1 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF gre_header.m_nroref1 IN FRAME F-Main /* Referenciaaaaaaaaaaaaaa #1 */
DO:
    DEFINE VAR cMotivoTraslado AS CHAR.

    FIND FIRST gre_movalm_mottraslado WHERE gre_movalm_mottraslado.codmov = almtdocm.codmov NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gre_movalm_mottraslado THEN DO:      
      RETURN.
    END.
    cMotivoTraslado = gre_movalm_mottraslado.codmotivotraslado.

    IF (cMotivoTraslado = "13" AND almtdocm.codmov = 82) OR
        (cMotivoTraslado = "18" AND almtdocm.codmov = 81)  THEN DO:
        ASSIGN
          input-var-1 = ''
          input-var-2 = ''
          input-var-3 = ''
          output-var-1 = ?              /* Rowid */
          output-var-2 = ''
          output-var-3 = ''.


        RUN lkup/c-pl-pers-v2 ('Seleccione el SOLICITANTE').
        IF output-var-1 = ? THEN RETURN 'ADM-ERROR'.

        self:screen-value = output-var-2.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gre_header.m_nroref2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gre_header.m_nroref2 V-table-Win
ON LEAVE OF gre_header.m_nroref2 IN FRAME F-Main /* Referenciaaaaaaaaaaaaaa #2 */
DO:
  RUN mostrar-data-ref2(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gre_header.m_nroref2 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF gre_header.m_nroref2 IN FRAME F-Main /* Referenciaaaaaaaaaaaaaa #2 */
DO:

    DEFINE VAR cMotivoTraslado AS CHAR.

    FIND FIRST gre_movalm_mottraslado WHERE gre_movalm_mottraslado.codmov = almtdocm.codmov NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gre_movalm_mottraslado THEN DO:      
      RETURN.
    END.
    cMotivoTraslado = gre_movalm_mottraslado.codmotivotraslado.

    IF (cMotivoTraslado = "13" AND LOOKUP(STRING(almtdocm.codmov),"29,82,83") > 0) OR
        (cMotivoTraslado = "18" AND LOOKUP(STRING(almtdocm.codmov),"81") > 0)   THEN DO:
        ASSIGN
          input-var-1 = ''
          input-var-2 = ''
          input-var-3 = ''
          output-var-1 = ?              /* Rowid */
          output-var-2 = ''
          output-var-3 = ''.


        RUN lkup/c-pl-pers-v2 ('Seleccione quien AUTORIZA').
        IF output-var-1 = ? THEN RETURN 'ADM-ERROR'.

        self:screen-value = output-var-2.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gre_header.m_nroref3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gre_header.m_nroref3 V-table-Win
ON LEAVE OF gre_header.m_nroref3 IN FRAME F-Main /* Referencia #3 */
DO:
    RUN mostrar-data-ref3(SELF:SCREEN-VALUE).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gre_header.m_numero_pi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gre_header.m_numero_pi V-table-Win
ON LEAVE OF gre_header.m_numero_pi IN FRAME F-Main /* m_numero_pi */
DO:
    DEFINE VAR y-numero AS INT.

    y-numero = INTEGER(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF x-numero <> y-numero THEN DO:
        EMPTY TEMP-TABLE ITEM-gre.
        RUN Procesa-Handle IN lh_Handle ('RefrescarItems').      
    END.

    x-numero = y-numero.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gre_header.m_proveedor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gre_header.m_proveedor V-table-Win
ON LEAVE OF gre_header.m_proveedor IN FRAME F-Main /* Proveedor */
DO:
    DISPLAY "" @ FILL-IN-Proveedor WITH FRAME {&FRAME-NAME}.
  IF gre_header.m_proveedor:VISIBLE THEN DO:
          FIND gn-prov WHERE gn-prov.CodCia = 0
                        AND  gn-prov.CodPro = INPUT gre_header.m_proveedor
                       NO-LOCK NO-ERROR.
          IF AVAILABLE gn-prov THEN DISPLAY gn-prov.NomPro @ FILL-IN-Proveedor WITH FRAME {&FRAME-NAME}.
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gre_header.m_sede
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gre_header.m_sede V-table-Win
ON LEAVE OF gre_header.m_sede IN FRAME F-Main /* Sede */
DO:
 FILL-IN-Sede:SCREEN-VALUE = ''.
  IF Almtmovm.PidCli = YES THEN DO:
      FIND Gn-ClieD WHERE Gn-ClieD.CodCia = 0
          AND Gn-ClieD.CodCli = gre_header.m_cliente:SCREEN-VALUE
          AND Gn-ClieD.Sede = gre_header.m_sede:SCREEN-VALUE
          NO-LOCK NO-ERROR.
      IF AVAILABLE Gn-ClieD THEN FILL-IN-Sede:SCREEN-VALUE = Gn-ClieD.DirCli.
  END.
  IF Almtmovm.PidPro THEN DO:
      FIND Gn-ProvD WHERE Gn-ProvD.CodCia = 0
          AND Gn-ProvD.CodPro = gre_header.m_proveedor:SCREEN-VALUE
          AND Gn-ProvD.Sede = gre_header.m_sede:SCREEN-VALUE
          NO-LOCK NO-ERROR.
      IF AVAILABLE Gn-ProvD THEN FILL-IN-Sede:SCREEN-VALUE = Gn-ProvD.DirPro.
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gre_header.m_sede V-table-Win
ON MOUSE-SELECT-DBLCLICK OF gre_header.m_sede IN FRAME F-Main /* Sede */
OR F8 OF gre_header.m_sede DO:
    CASE TRUE:
        WHEN Almtmovm.PidCli = YES THEN DO:
            input-var-1 = gre_header.m_cliente:SCREEN-VALUE.
            RUN lkup/c-gn-clied-todo ('Sedes').
            IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
        END.
        WHEN Almtmovm.PidPro = YES THEN DO:
            input-var-1 = gre_header.m_proveedor:SCREEN-VALUE.
            RUN lkup/c-gn-provd-todo ('Sedes').
            IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
        END.
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gre_header.m_serie_pi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gre_header.m_serie_pi V-table-Win
ON LEAVE OF gre_header.m_serie_pi IN FRAME F-Main /* P.I. */
DO:
  DEFINE VAR y-serie AS INT.

  y-serie = INTEGER(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

  IF x-serie <> y-serie THEN DO:
      EMPTY TEMP-TABLE ITEM-gre.
      RUN Procesa-Handle IN lh_Handle ('RefrescarItems').      
  END.

  x-serie = y-serie.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE actualiza-item V-table-Win 
PROCEDURE actualiza-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH ITEM-gre:
    DELETE ITEM-gre.
END.
IF NOT L-CREA THEN DO:
   FOR EACH gre_detail WHERE gre_detail.ncorrelativo = gre_header.ncorrelatio NO-LOCK :
       CREATE ITEM-gre.
       RAW-TRANSFER gre_detail TO ITEM-gre.
   END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE actualiza-peso V-table-Win 
PROCEDURE actualiza-peso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR dPeso AS DEC.
                             
  dPeso = 0.
  FOR EACH ITEM-gre WHERE ITEM-gre.codmat <> "" NO-LOCK:
        dPeso = dPeso + item-gre.peso_total_item.
  END.

  gre_header.pesoBrutoTotalBienes:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(dPeso,">>,>>>,>>9.9999").

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
  {src/adm/template/row-list.i "gre_header"}
  {src/adm/template/row-list.i "Almtdocm"}
  {src/adm/template/row-list.i "Almtmovm"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "gre_header"}
  {src/adm/template/row-find.i "Almtdocm"}
  {src/adm/template/row-find.i "Almtmovm"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-detalle V-table-Win 
PROCEDURE Borra-detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle V-table-Win 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE N-Itm AS INTEGER NO-UNDO.
  DEF VAR pComprometido AS DEC.
  DEF VAR dPeso AS DEC.

DEFINE VAR cAlmOrg AS CHAR.
  DEFINE VAR cCodDoc AS CHAR.
  DEFINE VAR dCantOtr AS DEC.

  cAlmOrg = gre_header.m_codalm:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  cCodDoc = gre_header.m_coddoc:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

  RUN mueve-stock(OUTPUT lMueveStock).

  dCantOtr = 0.
  dPeso = 0.
  FOR EACH ITEM-gre WHERE ITEM-gre.codmat <> "" ON ERROR UNDO, RETURN "ADM-ERROR":
      /* Consistencia final: Verificamos que aún exista stock disponible */
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = cAlmOrg /*s-codalm*/
          AND Almmmate.codmat = ITEM-gre.codmat
          NO-LOCK.
      /*RUN gn/stock-comprometido-v2 (ITEM-gre.codmat, s-codalm, TRUE, OUTPUT pComprometido).*/
      dCantOtr = 0.
      IF cCodDoc = 'OTR' THEN DO:
          dCantOtr = ITEM-gre.CanDes.

          /* 
            Ic - 18Ago2023 : Coordinacion Max, Susana, Ruben, Fernan Oblitas, Cesar Iman 
            Se retira validacion de Stock si y solo si sea OTR
          */
          lMueveStock = NO.
      END.

      IF lMueveStock THEN DO:
          RUN gn/stock-comprometido-v2 (ITEM-gre.codmat, cAlmOrg, TRUE, OUTPUT pComprometido).

          IF ITEM-gre.CanDes > (Almmmate.stkact - pComprometido + dCantOtr) THEN DO:    /* dCantOtr:si es OTR  */
              MESSAGE 'NO hay stock para el código' ITEM-gre.codmat SKIP
                  'para el almacen ' calmOrg SKIP
                  'Stock actual:' Almmmate.stkact SKIP
                  'Stock comprometido:' pComprometido
                  VIEW-AS ALERT-BOX ERROR.
              RETURN 'ADM-ERROR'.
          END.
      END.

       N-Itm = N-Itm + 1.
       CREATE b-gre_detail.
       ASSIGN b-gre_detail.ncorrelativo = gre_header.ncorrelatio
           b-gre_detail.nroitm = n-itm
           b-gre_detail.codmat = item-gre.codmat
           b-gre_detail.candes = item-gre.candes
           b-gre_detail.codund = item-gre.codund
           b-gre_detail.factor = item-gre.factor
           b-gre_detail.peso_unitario = item-gre.peso_unitario
           b-gre_detail.peso_total_item = item-gre.peso_total_item
           .
           dPeso = dPeso + item-gre.peso_total_item.
/*           
           Almdmov.CodCia = Almcmov.CodCia 
              Almdmov.CodAlm = Almcmov.CodAlm 
              Almdmov.TipMov = Almcmov.TipMov 
              Almdmov.CodMov = Almcmov.CodMov 
              Almdmov.NroSer = Almcmov.NroSer 
              Almdmov.NroDoc = Almcmov.NroDoc 
              Almdmov.CodMon = Almcmov.CodMon 
              Almdmov.FchDoc = Almcmov.FchDoc 
              Almdmov.TpoCmb = Almcmov.TpoCmb
              Almdmov.codmat = ITEM.codmat
              Almdmov.CanDes = ITEM.CanDes
              Almdmov.CodUnd = ITEM.CodUnd
              Almdmov.Factor = ITEM.Factor
              Almdmov.ImpCto = ITEM.ImpCto
              Almdmov.PreUni = ITEM.PreUni
              Almdmov.NroItm = N-Itm
              Almdmov.CodAjt = ''
              Almdmov.HraDoc = almcmov.HorSal
                     R-ROWID = ROWID(Almdmov).
       /* RUN ALM\ALMDGSTK (R-ROWID). */
       RUN alm/almdcstk (R-ROWID).
       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
       
       RUN ALM\ALMACPR1 (R-ROWID,"U").
       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
       
       /* RHC 03.04.04 BLOQUEADO, SE ACTUALIZA EN LA NOCHE
       RUN ALM\ALMACPR2 (R-ROWID,"U").
       *************************************************** */
       */
  END.

  ASSIGN gre_header.pesoBrutoTotalBienes = dPeso.

  gre_header.pesoBrutoTotalBienes:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(dPeso,">>,>>>,>>9.9999").

  RUN Procesa-Handle IN lh_Handle ('browse').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-otros V-table-Win 
PROCEDURE grabar-otros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:

  /* Otros */
  IF gre_header.m_llevar_traer_mercaderia <> 0 THEN DO:
    IF gre_header.m_llevar_traer_mercaderia = 1 THEN DO:
        /* Llevar mercaderia */                            
        IF gre_header.m_cliente:VISIBLE = YES THEN DO:
            /* Al cliente - NO VENTAS */
            /* Remitente */
            ASSIGN gre_header.tipoDocumentoRemitente = ctipoDocumentoContinental
                  gre_header.numeroDocumentoRemitente = cnumeroDocumentoContinental
                  gre_header.razonSocialRemitente = crazonSocialContinental
                  gre_header.tipoDocumentoEstablecimiento = ctipoDocumentoContinental
                  gre_header.numeroDocumentoEstablecimiento = cnumeroDocumentoContinental
                  gre_header.razonSocialEstablecimiento = crazonSocialContinental
                  gre_header.codigoPtopartida = cPuntoOrigen    
                  gre_header.ubigeoPtoPartida = cUbigeoOrigen       /* Continental */
                  gre_header.direccionPtoPartida = cDireccionOrigen
             .
            /* Destinatario */
            ASSIGN    gre_header.tipoDocumentoDestinatario = if(cRUCcliente > "") THEN '6' ELSE "1"
                      gre_header.numeroDocumentoDestinatario = if(cRUCcliente > "") THEN cRUCcliente ELSE cDNIcliente
                      gre_header.razonSocialDestinatario = fill-in-cliente
                      gre_header.ubigeoPtoLlegada = cUbigeoCliente
                      gre_header.codigoPtoLlegada = cPuntoCliente
                      gre_header.direccionPtoLlegada = cDireccionCliente
              .
        END.
        ELSE DO:
            IF gre_header.m_proveedor:VISIBLE = YES THEN DO:
                /* Llevar mercaderia al proveedor - NO DEVOLUCIONES */
                /* Remitente */
                ASSIGN gre_header.tipoDocumentoRemitente = ctipoDocumentoContinental 
                      gre_header.numeroDocumentoRemitente = cnumeroDocumentoContinental 
                      gre_header.razonSocialRemitente = crazonSocialContinental 
                      gre_header.tipoDocumentoEstablecimiento = "6"
                      gre_header.numeroDocumentoEstablecimiento = cRucProveedor
                      gre_header.razonSocialEstablecimiento = fill-in-proveedor
                      gre_header.codigoPtopartida = cPuntoOrigen
                      gre_header.ubigeoPtoPartida = cUbigeoOrigen /* Continental */
                      gre_header.direccionPtoPartida = cDireccionOrigen
                 .
                /* Destinatario */
                ASSIGN    gre_header.tipoDocumentoDestinatario = "6"
                          gre_header.numeroDocumentoDestinatario = cRucProveedor
                          gre_header.razonSocialDestinatario = fill-in-proveedor
                          gre_header.codigoPtoLlegada = cPuntoProveedor
                          gre_header.ubigeoPtoLlegada = cUbigeoProveedor                        
                          gre_header.direccionPtoLlegada = cDireccionProveedor
                  .
            END.
        END.
    END.
    ELSE DO:
        /* Traer mercaderia */
        IF gre_header.m_cliente:VISIBLE = YES THEN DO:
            /* cliente - NO DEVOLUCIONES */

            /* Remitente */
            ASSIGN gre_header.tipoDocumentoRemitente = if(cRUCcliente > "") THEN '6' ELSE "1"
                  gre_header.numeroDocumentoRemitente = if(cRUCcliente > "") THEN cRUCcliente ELSE cDNIcliente
                  gre_header.razonSocialRemitente = fill-in-cliente
                  gre_header.tipoDocumentoEstablecimiento = if(cRUCcliente > "") THEN '6' ELSE "1"
                  gre_header.numeroDocumentoEstablecimiento = if(cRUCcliente > "") THEN cRUCcliente ELSE cDNIcliente
                  gre_header.razonSocialEstablecimiento = fill-in-cliente
                  gre_header.codigoPtopartida = cPuntoCliente
                  gre_header.ubigeoPtoPartida = cUbigeoCliente
                  gre_header.direccionPtoPartida = cDireccionCliente
             .
            /* Destinatario */
            ASSIGN    gre_header.tipoDocumentoDestinatario = ctipoDocumentoContinental
                      gre_header.numeroDocumentoDestinatario = cnumeroDocumentoContinental
                      gre_header.razonSocialDestinatario = crazonSocialContinental
                      gre_header.ubigeoPtoLlegada = cUbigeoOrigen /* Continental */
                      gre_header.codigoPtoLlegada = cPuntoOrigen
                      gre_header.direccionPtoLlegada = cDireccionOrigen
              .
        END.
        ELSE DO:
            IF gre_header.m_proveedor:VISIBLE = YES THEN DO:
                /* Del Proveedor - COMPRAS  */
                /* Remitente */
                ASSIGN gre_header.tipoDocumentoRemitente = "6"
                      gre_header.numeroDocumentoRemitente = cRucProveedor
                      gre_header.razonSocialRemitente = fill-in-proveedor
                      gre_header.tipoDocumentoEstablecimiento = "6"
                      gre_header.numeroDocumentoEstablecimiento = cRucProveedor
                      gre_header.razonSocialEstablecimiento = fill-in-proveedor
                      gre_header.codigoPtopartida = cPuntoOrigen
                      gre_header.ubigeoPtoPartida = cUbigeoOrigen /* Continental */
                      gre_header.direccionPtoPartida = cDireccionOrigen
                 .
                /* Destinatario */
                ASSIGN    gre_header.tipoDocumentoDestinatario = ctipoDocumentoContinental
                          gre_header.numeroDocumentoDestinatario = cnumeroDocumentoContinental
                          gre_header.razonSocialDestinatario = crazonSocialContinental
                          gre_header.codigoPtoLlegada = cPuntoProveedor
                          gre_header.ubigeoPtoLlegada = cUbigeoProveedor                        
                          gre_header.direccionPtoLlegada = cDireccionProveedor
                  .
            END.
        END.
    END.
  END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-otros-old V-table-Win 
PROCEDURE grabar-otros-old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:

  /* Otros */
  IF gre_header.m_llevar_traer_mercaderia <> 0 THEN DO:
    IF gre_header.m_llevar_traer_mercaderia = 1 THEN DO:
        /* Llevar mercaderia */                            
        IF gre_header.m_cliente:VISIBLE = YES THEN DO:
            /* Al cliente - NO VENTAS */
            /* Remitente */
            ASSIGN gre_header.tipoDocumentoRemitente = ctipoDocumentoContinental
                  gre_header.numeroDocumentoRemitente = cnumeroDocumentoContinental
                  gre_header.razonSocialRemitente = crazonSocialContinental
                  gre_header.tipoDocumentoEstablecimiento = ctipoDocumentoContinental
                  gre_header.numeroDocumentoEstablecimiento = cnumeroDocumentoContinental
                  gre_header.razonSocialEstablecimiento = crazonSocialContinental
                  gre_header.codigoPtopartida = cPuntoOrigen    
                  gre_header.ubigeoPtoPartida = cUbigeoOrigen       /* Continental */
                  gre_header.direccionPtoPartida = cDireccionOrigen
             .
            /* Destinatario */
            ASSIGN    gre_header.tipoDocumentoDestinatario = if(cRUCcliente > "") THEN '6' ELSE "1"
                      gre_header.numeroDocumentoDestinatario = if(cRUCcliente > "") THEN cRUCcliente ELSE cDNIcliente
                      gre_header.razonSocialDestinatario = fill-in-cliente
                      gre_header.ubigeoPtoLlegada = cUbigeoCliente
                      gre_header.codigoPtoLlegada = cPuntoCliente
                      gre_header.direccionPtoLlegada = cDireccionCliente
              .
        END.
        ELSE DO:
            IF gre_header.m_proveedor:VISIBLE = YES THEN DO:
                /* Llevar mercaderia al proveedor - NO DEVOLUCIONES */
                /* Remitente */
                ASSIGN gre_header.tipoDocumentoRemitente = ctipoDocumentoContinental 
                      gre_header.numeroDocumentoRemitente = cnumeroDocumentoContinental 
                      gre_header.razonSocialRemitente = crazonSocialContinental 
                      gre_header.tipoDocumentoEstablecimiento = "6"
                      gre_header.numeroDocumentoEstablecimiento = cRucProveedor
                      gre_header.razonSocialEstablecimiento = fill-in-proveedor
                      gre_header.codigoPtopartida = cPuntoOrigen
                      gre_header.ubigeoPtoPartida = cUbigeoOrigen /* Continental */
                      gre_header.direccionPtoPartida = cDireccionOrigen
                 .
                /* Destinatario */
                ASSIGN    gre_header.tipoDocumentoDestinatario = "6"
                          gre_header.numeroDocumentoDestinatario = cRucProveedor
                          gre_header.razonSocialDestinatario = fill-in-proveedor
                          gre_header.codigoPtoLlegada = cPuntoProveedor
                          gre_header.ubigeoPtoLlegada = cUbigeoProveedor                        
                          gre_header.direccionPtoLlegada = cDireccionProveedor
                  .
            END.
        END.
    END.
    ELSE DO:
        /* Traer mercaderia */
        IF gre_header.m_cliente:VISIBLE = YES THEN DO:
            /* cliente - NO DEVOLUCIONES */

            /* Remitente */
            ASSIGN gre_header.tipoDocumentoRemitente = if(cRUCcliente > "") THEN '6' ELSE "1"
                  gre_header.numeroDocumentoRemitente = if(cRUCcliente > "") THEN cRUCcliente ELSE cDNIcliente
                  gre_header.razonSocialRemitente = fill-in-cliente
                  gre_header.tipoDocumentoEstablecimiento = if(cRUCcliente > "") THEN '6' ELSE "1"
                  gre_header.numeroDocumentoEstablecimiento = if(cRUCcliente > "") THEN cRUCcliente ELSE cDNIcliente
                  gre_header.razonSocialEstablecimiento = fill-in-cliente
                  gre_header.codigoPtopartida = cPuntoCliente
                  gre_header.ubigeoPtoPartida = cUbigeoCliente
                  gre_header.direccionPtoPartida = cDireccionCliente
             .
            /* Destinatario */
            ASSIGN    gre_header.tipoDocumentoDestinatario = ctipoDocumentoContinental
                      gre_header.numeroDocumentoDestinatario = cnumeroDocumentoContinental
                      gre_header.razonSocialDestinatario = crazonSocialContinental
                      gre_header.ubigeoPtoLlegada = cUbigeoOrigen /* Continental */
                      gre_header.codigoPtoLlegada = cPuntoOrigen
                      gre_header.direccionPtoLlegada = cDireccionOrigen
              .
        END.
        ELSE DO:
            IF gre_header.m_proveedor:VISIBLE = YES THEN DO:
                /* Del Proveedor - COMPRAS  */
                /* Remitente */
                ASSIGN gre_header.tipoDocumentoRemitente = "6"
                      gre_header.numeroDocumentoRemitente = cRucProveedor
                      gre_header.razonSocialRemitente = fill-in-proveedor
                      gre_header.tipoDocumentoEstablecimiento = "6"
                      gre_header.numeroDocumentoEstablecimiento = cRucProveedor
                      gre_header.razonSocialEstablecimiento = fill-in-proveedor
                      gre_header.codigoPtopartida = cPuntoOrigen
                      gre_header.ubigeoPtoPartida = cUbigeoOrigen /* Continental */
                      gre_header.direccionPtoPartida = cDireccionOrigen
                 .
                /* Destinatario */
                ASSIGN    gre_header.tipoDocumentoDestinatario = ctipoDocumentoContinental
                          gre_header.numeroDocumentoDestinatario = cnumeroDocumentoContinental
                          gre_header.razonSocialDestinatario = crazonSocialContinental
                          gre_header.codigoPtoLlegada = cPuntoProveedor
                          gre_header.ubigeoPtoLlegada = cUbigeoProveedor                        
                          gre_header.direccionPtoLlegada = cDireccionProveedor
                  .
            END.
        END.
    END.
  END.

END.

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
/*    RUN gn/gre-online.r(OUTPUT lGRE_ONLINE).                                       */
/*                                                                                   */
/*   IF lGRE_ONLINE = NO THEN DO:                                                    */
/*         MESSAGE 'El proceso de GRE no esta activo' VIEW-AS ALERT-BOX INFORMATION. */
/*         RETURN 'ADM-ERROR'.                                                       */
/*   END.                                                                            */
    
  IF NOT AVAILABLE almtdocm THEN DO:
      MESSAGE "No existe ningun codigo movimiento de salida del almacen" SKIP
            "asignado a un motivo traslado de la guia de remision " SKIP            
            "eletronica de Sunat!!!!" SKIP 
            " " SKIP
            "coordinar con su inmediato superior"
           VIEW-AS ALERT-BOX INFORMATION.
      RETURN "ADM-ERROR".
  END.
  
  FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
                AND  Almacen.CodAlm = s-codalm NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almacen THEN DO:
     MESSAGE "Almacen destino no existe" VIEW-AS ALERT-BOX INFORMATION.
     RETURN "ADM-ERROR".
  END.    
  IF almacen.campo-c[9] = "I" THEN DO:
      MESSAGE "Almacen destino NO ESTA ACTIVO" VIEW-AS ALERT-BOX INFORMATION.
       RETURN "ADM-ERROR".
  END.
  /* ******************************************** */
  /* 23/11/2023 */
  /* ******************************************** */
  IF s-acceso-total = NO THEN DO:
      RUN gre/d-error-gre-noactiva.w.
      RETURN 'ADM-ERROR'.
  END.
  /* ******************************************** */
  /* ******************************************** */
  /* gre
  s-CodRef = ''.
  s-Reposicion = NO.
  s-OrdenDespacho = NO.
  */
  s-AlmDes = ''.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Valore Defaults */
  DO WITH FRAME {&FRAME-NAME}:
      gre_header.m_codalm:SCREEN-VALUE = s-codalm.
      fill-in-almacen-origen:SCREEN-VALUE = almacen.descripcion.
      gre_header.fechaEmisionGuia:SCREEN-VALUE = STRING(TODAY,"99/99/9999").
      gre_header.horaEmisionGuia:SCREEN-VALUE = STRING(TIME,"hh:mm:ss").
      gre_header.m_usuario:SCREEN-VALUE = USERID("DICTDB").
      gre_header.serieGuia:SCREEN-VALUE = '000'.    /*STRING(s-nroser,"999").*/
      gre_header.m_llevar_traer_mercaderia:SCREEN-VALUE = "0".

      FIND FIRST almtmovm WHERE almtmovm.codcia = 1 AND almtmovm.tipmov = 'S' AND almtmovm.codmov = Almtdocm.CodMov NO-LOCK NO-ERROR.
          
          fill-in-muevestock:SCREEN-VALUE = "NO MUEVE STOCK".                  
          IF AVAILABLE almtmovm THEN DO:
              IF almtmovm.movVal =YES THEN DO:
                    fill-in-muevestock:SCREEN-VALUE = "SI MUEVE STOCK".                  
              END.
          END.
          fill-in-muevestock:SENSITIVE = NO.

  END.
          
  l-crea = YES.    
    cm_libre_c05 = "".
    lm_libre_l02 = NO.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Actualiza-ITEM.
  RUN Procesa-Handle IN lh_Handle ('Pagina2'). 


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

  SESSION:SET-WAIT-STATE("GENERAL").

  /* Correlativo */
  DEFINE VAR iCorrelativo AS INT.

  RUN gre/correlativo-gre(OUTPUT iCorrelativo).

    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        MESSAGE "PROBLEMAS AL CREAR EL CORRELATIVO DE PRE-GRE"
            VIEW-AS ALERT-BOX INFORMATION.
        RETURN "ADM-ERROR".
    END.

  DEFINE VAR cMotivoTraslado AS CHAR.
  DEFINE VAR cDescripcioMotivoTraslado AS CHAR.
  DEFINE VAR cNroOTR AS CHAR.

  FIND FIRST gre_movalm_mottraslado WHERE gre_movalm_mottraslado.codmov = almtdocm.codmov NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gre_movalm_mottraslado THEN DO:
      MESSAGE "Movimiento de almacen (" + STRING(almtdocm.codmov) + ") no tiene asociado aun motivo de traslado"
          VIEW-AS ALERT-BOX INFORMATION.
      RETURN "ADM-ERROR".
  END.
  cMotivoTraslado = gre_movalm_mottraslado.codmotivotraslado.

  FIND FIRST sunat_fact_electr_detail WHERE sunat_fact_electr_detail.catalogue = 20 AND
                                        sunat_fact_electr_detail.CODE = cMotivoTraslado NO-LOCK NO-ERROR.
    IF NOT AVAILABLE sunat_fact_electr_detail THEN DO:
        MESSAGE "Motivo de traslado (" + cMotivoTraslado + ") no esta registrado en tablas de la Sunat"
            VIEW-AS ALERT-BOX INFORMATION.
        RETURN "ADM-ERROR".
    END.
    cDescripcioMotivoTraslado = sunat_fact_electr_detail.DESCRIPTION.

    IF cMotivoTraslado = "13" THEN DO:
        cDescripcioMotivoTraslado = almtmovm.desmov.
    END.

DO WITH FRAME {&FRAME-NAME}:

  /**/
  ASSIGN gre_header.ncorrelatio = iCorrelativo
        gre_header.m_tipmov = almtdocm.tipmov
        gre_header.m_codmov = almtdocm.codmov
        gre_header.fechaEmisionGuia = TODAY                     /* Se actualiza cuando se envia a la SUNAT */
        gre_header.horaEmisionGuia = STRING(TIME,"hh:mm:ss")    /* Se actualiza cuando se envia a la SUNAT */
        gre_header.correoRemitente = "-"
        gre_header.correoDestinatario = "-"
        gre_header.tipoDocumentoGuia = "09"
        gre_header.m_tpomov = 'GRTRA'      
        gre_header.motivoTraslado = cMotivoTraslado
        gre_header.descripcionMotivoTraslado = cDescripcioMotivoTraslado
        gre_header.unidadMedidaPesoBruto = "KGM"
        gre_header.indTransbordoProgramado = 1
        gre_header.m_divorigen = cDivisionOrigen
        gre_header.m_divdestino = cDivisionDestino.

        RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
        IF RETURN-VALUE = "YES" THEN DO:
        ASSIGN gre_header.m_libre_c05 = cm_libre_c05
                gre_header.m_libre_l02 = lm_libre_l02.
    END.

  IF cParteDeIngreso = "SI" THEN DO:
      ASSIGN gre_header.m_nroref1 = STRING(gre_header.m_serie_pi,"999") + "-" + STRING(gre_header.m_numero_pi,"999999999").
  END.


  CASE cMotivoTraslado:
      WHEN "01" THEN DO:
            /* Ventas */

            /* Remitente */
          ASSIGN gre_header.tipoDocumentoRemitente = ctipoDocumentoContinental
                gre_header.numeroDocumentoRemitente = cnumeroDocumentoContinental
                gre_header.razonSocialRemitente = crazonSocialContinental
                gre_header.tipoDocumentoEstablecimiento = gre_header.tipoDocumentoRemitente
                gre_header.numeroDocumentoEstablecimiento = gre_header.numeroDocumentoRemitente        
                gre_header.razonSocialEstablecimiento = gre_header.razonSocialRemitente
                gre_header.codigoPtopartida = cPuntoOrigen
                gre_header.ubigeoPtoPartida = cUbigeoOrigen
                gre_header.direccionPtoPartida = cDireccionOrigen
           .

            /* Destinatario */
          ASSIGN    gre_header.tipoDocumentoDestinatario = if(cRUCcliente > "") THEN '6' ELSE "1"
                    gre_header.numeroDocumentoDestinatario = if(cRUCcliente > "") THEN cRUCcliente ELSE cDNIcliente
                    gre_header.razonSocialDestinatario = fill-in-cliente
                    gre_header.ubigeoPtoLlegada = cUbigeoDestino
                    gre_header.codigoPtoLlegada = cPuntoDestino        
                    gre_header.direccionPtoLlegada = cDireccionDestino
           .
      END.
      WHEN "02" THEN DO:
          /* Compras */ 

          /* Remitente */
          ASSIGN gre_header.tipoDocumentoRemitente = ctipoDocumentoContinental  
                gre_header.numeroDocumentoRemitente = cnumeroDocumentoContinental   
                gre_header.razonSocialRemitente = crazonSocialContinental   
                gre_header.tipoDocumentoEstablecimiento = ""
                gre_header.numeroDocumentoEstablecimiento = ""
                gre_header.razonSocialEstablecimiento = ""
                gre_header.codigoPtopartida = cPuntoProveedor
                gre_header.ubigeoPtoPartida = cUbigeoProveedor
                gre_header.direccionPtoPartida = cDireccionProveedor
           .
          /* Destinatario */
          ASSIGN    gre_header.tipoDocumentoDestinatario = ctipoDocumentoContinental
                    gre_header.numeroDocumentoDestinatario = cnumeroDocumentoContinental
                    gre_header.razonSocialDestinatario = crazonSocialContinental
                    gre_header.ubigeoPtoLlegada = cUbigeoOrigen /* Continental */
                    gre_header.codigoPtoLlegada = cPuntoOrigen
                    gre_header.direccionPtoLlegada = cDireccionOrigen
            .
      END.
      WHEN "03" THEN DO:
          /* Compras con despacho a terceros */

          /* Remitente */
          ASSIGN gre_header.tipoDocumentoRemitente = ctipoDocumentoContinental
                gre_header.numeroDocumentoRemitente = cnumeroDocumentoContinental
                gre_header.razonSocialRemitente = crazonSocialContinental
                gre_header.tipoDocumentoEstablecimiento = gre_header.tipoDocumentoRemitente
                gre_header.numeroDocumentoEstablecimiento = gre_header.numeroDocumentoRemitente        
                gre_header.razonSocialEstablecimiento = gre_header.razonSocialRemitente
                gre_header.codigoPtopartida = cUbigeoOrigen /* Continental */
                gre_header.ubigeoPtoPartida = cPuntoOrigen
                gre_header.direccionPtoPartida = cDireccionOrigen
           .
          /* Destinatario */
          ASSIGN    gre_header.tipoDocumentoDestinatario = "Del tercero"
                    gre_header.numeroDocumentoDestinatario = "Del tecero"
                    gre_header.razonSocialDestinatario = "Del Tercero"
                    gre_header.ubigeoPtoLlegada = "Del tercero"
                    gre_header.codigoPtoLlegada = "Del tercero"
                    gre_header.direccionPtoLlegada = "Del tercero"
            .
      END.

      WHEN "04" THEN DO:
          /* Entre establecimientos */

          /* Remitente */
          ASSIGN gre_header.tipoDocumentoRemitente = ctipoDocumentoContinental
                gre_header.numeroDocumentoRemitente = cnumeroDocumentoContinental
                gre_header.razonSocialRemitente = crazonSocialContinental
                gre_header.tipoDocumentoEstablecimiento = gre_header.tipoDocumentoRemitente
                gre_header.numeroDocumentoEstablecimiento = gre_header.numeroDocumentoRemitente        
                gre_header.razonSocialEstablecimiento = gre_header.razonSocialRemitente
                gre_header.codigoPtopartida = cPuntoOrigen
                gre_header.numeroDocumentoPtoPartida = cnumeroDocumentoContinental
                gre_header.ubigeoPtoPartida = cUbigeoOrigen /* Continental */
                gre_header.direccionPtoPartida = cDireccionOrigen
           .
          /* Destinatario */
          ASSIGN    gre_header.tipoDocumentoDestinatario = ctipoDocumentoContinental
                    gre_header.numeroDocumentoDestinatario = cnumeroDocumentoContinental
                    gre_header.razonSocialDestinatario = crazonSocialContinental
                    gre_header.ubigeoPtoLlegada = cUbigeoDestino
                    gre_header.codigoPtoLlegada = cPuntoDestino
                    gre_header.direccionPtoLlegada = cDireccionDestino
                    gre_header.numeroDocumentoPtoLlegada = cnumeroDocumentoContinental
            .

      END.
    
      WHEN "05" THEN DO:
          /* Consignacion */
      END.
      WHEN "06" THEN DO:
          /* Devoluciones al proveedor */
          IF gre_header.m_codmov = 91 THEN DO:
              /* Remitente */
              ASSIGN gre_header.tipoDocumentoRemitente = ctipoDocumentoContinental 
                    gre_header.numeroDocumentoRemitente = cnumeroDocumentoContinental 
                    gre_header.razonSocialRemitente = crazonSocialContinental 
                    gre_header.tipoDocumentoEstablecimiento = "6"
                    gre_header.numeroDocumentoEstablecimiento = cRucProveedor
                    gre_header.razonSocialEstablecimiento = fill-in-proveedor
                    gre_header.codigoPtopartida = cPuntoOrigen
                    gre_header.ubigeoPtoPartida = cUbigeoOrigen /* Continental */
                    gre_header.direccionPtoPartida = cDireccionOrigen
               .
              /* Destinatario */
              ASSIGN    gre_header.tipoDocumentoDestinatario = "6"
                        gre_header.numeroDocumentoDestinatario = cRucProveedor
                        gre_header.razonSocialDestinatario = fill-in-proveedor
                        gre_header.codigoPtoLlegada = cPuntoProveedor
                        gre_header.ubigeoPtoLlegada = cUbigeoProveedor                        
                        gre_header.direccionPtoLlegada = cDireccionProveedor
                .
          END.              
      END.        
      WHEN "07" THEN DO:
          /* Recojo de bienes transformados */
          /* Remitente */
          ASSIGN gre_header.tipoDocumentoRemitente = ctipoDocumentoContinental      
                gre_header.numeroDocumentoRemitente = cnumeroDocumentoContinental   
                gre_header.razonSocialRemitente = crazonSocialContinental       
                gre_header.tipoDocumentoEstablecimiento = ""
                gre_header.numeroDocumentoEstablecimiento = ""
                gre_header.razonSocialEstablecimiento = ""
                gre_header.codigoPtopartida = cPuntoProveedor
                gre_header.ubigeoPtoPartida = cUbigeoProveedor                        
                gre_header.direccionPtoPartida = cDireccionProveedor
           .
          /* Destinatario */
          ASSIGN    gre_header.tipoDocumentoDestinatario = ctipoDocumentoContinental
                    gre_header.numeroDocumentoDestinatario = cnumeroDocumentoContinental
                    gre_header.razonSocialDestinatario = crazonSocialContinental
                    gre_header.ubigeoPtoLlegada = cUbigeoOrigen /* Continental */
                    gre_header.codigoPtoLlegada = cPuntoOrigen
                    gre_header.direccionPtoLlegada = cDireccionOrigen
            .
      END.
      WHEN "08" THEN DO:
          /* Importaciones */
      END.
      WHEN "09" THEN DO:
          /* Exportaciones */
      END.

      WHEN "13" THEN DO:
          /* Otros */
          IF gre_header.m_codmov = 29 THEN DO:
             /* Devoluciones de cliente */ 

              /* Remitente */
              ASSIGN gre_header.tipoDocumentoRemitente = ctipoDocumentoContinental      
                    gre_header.numeroDocumentoRemitente = cnumeroDocumentoContinental   
                    gre_header.razonSocialRemitente = crazonSocialContinental           
                    gre_header.tipoDocumentoEstablecimiento = if(cRUCcliente > "") THEN '6' ELSE "1"
                    gre_header.numeroDocumentoEstablecimiento = if(cRUCcliente > "") THEN cRUCcliente ELSE cDNIcliente
                    gre_header.razonSocialEstablecimiento = fill-in-cliente
                    gre_header.codigoPtopartida = cPuntoCliente
                    gre_header.ubigeoPtoPartida = cUbigeoCliente
                    gre_header.direccionPtoPartida = cDireccionCliente
               .
              /* Destinatario */
              ASSIGN    gre_header.tipoDocumentoDestinatario = if(cRUCcliente > "") THEN '6' ELSE "1"
                        gre_header.numeroDocumentoDestinatario = if(cRUCcliente > "") THEN cRUCcliente ELSE cDNIcliente
                        gre_header.razonSocialDestinatario = fill-in-cliente
                        gre_header.ubigeoPtoLlegada = cUbigeoOrigen /* Continental */
                        gre_header.codigoPtoLlegada = cPuntoOrigen
                        gre_header.direccionPtoLlegada = cDireccionOrigen
                .
          END.
          ELSE DO:
              /**/
              RUN grabar-otros.
          END.
      END.        
      WHEN "14" THEN DO:
          /* Venta sujeta a confirmacion del comprador */
      END.
      WHEN "17" THEN DO:
          /* Traslado de bienes para transformacion */

          /* Remitente */
          ASSIGN gre_header.tipoDocumentoRemitente = ctipoDocumentoContinental
                gre_header.numeroDocumentoRemitente = cnumeroDocumentoContinental
                gre_header.razonSocialRemitente = crazonSocialContinental
                gre_header.tipoDocumentoEstablecimiento = ""
                gre_header.numeroDocumentoEstablecimiento = ""
                gre_header.razonSocialEstablecimiento = ""
                gre_header.codigoPtopartida = cPuntoOrigen
                gre_header.ubigeoPtoPartida = cUbigeoOrigen /* Continental */
                gre_header.direccionPtoPartida = cDireccionOrigen
           .
          /* Destinatario */
          ASSIGN    gre_header.tipoDocumentoDestinatario = "6"
                    gre_header.numeroDocumentoDestinatario = cRucProveedor
                    gre_header.razonSocialDestinatario = fill-in-proveedor
                    gre_header.ubigeoPtoLlegada = cUbigeoProveedor
                    gre_header.codigoPtoLlegada = cPuntoProveedor
                    gre_header.direccionPtoLlegada = cDireccionProveedor
            .
      END.
      WHEN "18" THEN DO:
          /* Traslado emisor itinerante */
          /* Remitente */
          ASSIGN gre_header.tipoDocumentoRemitente = ctipoDocumentoContinental
                gre_header.numeroDocumentoRemitente = cnumeroDocumentoContinental
                gre_header.razonSocialRemitente = crazonSocialContinental
                gre_header.tipoDocumentoEstablecimiento = ""
                gre_header.numeroDocumentoEstablecimiento = ""
                gre_header.razonSocialEstablecimiento = ""
                gre_header.codigoPtopartida = cPuntoOrigen
                gre_header.ubigeoPtoPartida = cUbigeoOrigen /* Continental */
                gre_header.direccionPtoPartida = cDireccionOrigen
           .
          /* Destinatario */
          ASSIGN    gre_header.tipoDocumentoDestinatario = ctipoDocumentoContinental
                    gre_header.numeroDocumentoDestinatario = cnumeroDocumentoContinental
                    gre_header.razonSocialDestinatario = crazonSocialContinental
                    gre_header.ubigeoPtoLlegada = cUbigeoOrigen /* Continental */
                    gre_header.codigoPtoLlegada = cPuntoOrigen
                    gre_header.direccionPtoLlegada = cDireccionOrigen
            .
      END.
      OTHERWISE DO:
      END.
  END.
END.

  /* ELIMINAMOS EL DETALLE ANTERIOR */
  IF NOT L-CREA THEN DO:
    RUN Borra-Detalle.
    SESSION:SET-WAIT-STATE("").
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.

  RUN Genera-Detalle.
  
  SESSION:SET-WAIT-STATE("").
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* Actualizo el FlgSit de la OTR */
  IF gre_header.m_coddoc:SCREEN-VALUE = "OTR" THEN DO:
        cNroOTR = STRING(INTEGER(gre_header.m_nroser:SCREEN-VALUE),"999") + STRING(INTEGER(gre_header.m_nrodoc:SCREEN-VALUE),"999999").
        FIND FIRST faccpedi WHERE faccpedi.codcia = 1 AND faccpedi.coddoc = gre_header.m_coddoc AND
                            faccpedi.nroped = cNroOTR EXCLUSIVE-LOCK NO-ERROR.
        IF LOCKED faccpedi THEN DO:
            MESSAGE "La tabla FACCPEDI esta bloqueada...no se pudo actualizar a PGRE" VIEW-AS ALERT-BOX INFORMATION.
            RETURN "ADM-ERROR".
        END.

        IF NOT (faccpedi.flgest = 'P' AND faccpedi.flgsit = 'C') THEN DO:
            RELEASE faccpedi NO-ERROR.
            MESSAGE "La tabla FACCPEDI ya NO tiene el flgest = 'P' y flgsit = 'C'" VIEW-AS ALERT-BOX INFORMATION.
            RETURN "ADM-ERROR".
        END.

        IF AVAILABLE faccpedi THEN ASSIGN faccpedi.flgsit = 'PGRE'.        

        RELEASE faccpedi NO-ERROR.
  END.

  /**/
  l-crea = NO.

  RUN Procesa-Handle IN lh_Handle ('Pagina1').
  
END PROCEDURE.

/*
      input-var-2 = 'P'             /* flgest */
      input-var-3 = 'C'             /* flgsit Cheque Barras SALIDA OK */

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement-old V-table-Win 
PROCEDURE local-assign-statement-old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  SESSION:SET-WAIT-STATE("GENERAL").

  /* Correlativo */
  DEFINE VAR iCorrelativo AS INT.

  RUN gre/correlativo-gre(OUTPUT iCorrelativo).

    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        MESSAGE "PROBLEMAS AL CREAR EL CORRELATIVO DE PRE-GRE"
            VIEW-AS ALERT-BOX INFORMATION.
        RETURN "ADM-ERROR".
    END.
 
  DEFINE VAR cMotivoTraslado AS CHAR.
  DEFINE VAR cDescripcioMotivoTraslado AS CHAR.
  DEFINE VAR cNroOTR AS CHAR.

  FIND FIRST gre_movalm_mottraslado WHERE gre_movalm_mottraslado.codmov = almtdocm.codmov NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gre_movalm_mottraslado THEN DO:
      MESSAGE "Movimiento de almacen (" + STRING(almtdocm.codmov) + ") no tiene asociado aun motivo de traslado"
          VIEW-AS ALERT-BOX INFORMATION.
      RETURN "ADM-ERROR".
  END.
  cMotivoTraslado = gre_movalm_mottraslado.codmotivotraslado.
 
  FIND FIRST sunat_fact_electr_detail WHERE sunat_fact_electr_detail.catalogue = 20 AND
                                        sunat_fact_electr_detail.CODE = cMotivoTraslado NO-LOCK NO-ERROR.
    IF NOT AVAILABLE sunat_fact_electr_detail THEN DO:
        MESSAGE "Motivo de traslado (" + cMotivoTraslado + ") no esta registrado en tablas de la Sunat"
            VIEW-AS ALERT-BOX INFORMATION.
        RETURN "ADM-ERROR".
    END.
    cDescripcioMotivoTraslado = sunat_fact_electr_detail.DESCRIPTION.

    IF cMotivoTraslado = "13" THEN DO:
        cDescripcioMotivoTraslado = almtmovm.desmov.
    END.

DO WITH FRAME {&FRAME-NAME}:

  /**/
  ASSIGN gre_header.ncorrelatio = iCorrelativo
        gre_header.m_tipmov = almtdocm.tipmov
        gre_header.m_codmov = almtdocm.codmov
        gre_header.fechaEmisionGuia = TODAY                     /* Se actualiza cuando se envia a la SUNAT */
        gre_header.horaEmisionGuia = STRING(TIME,"hh:mm:ss")    /* Se actualiza cuando se envia a la SUNAT */
        gre_header.correoRemitente = "-"
        gre_header.correoDestinatario = "-"
        gre_header.tipoDocumentoGuia = "09"
        gre_header.m_tpomov = 'GRTRA'      
        gre_header.motivoTraslado = cMotivoTraslado
        gre_header.descripcionMotivoTraslado = cDescripcioMotivoTraslado
        gre_header.unidadMedidaPesoBruto = "KGM"
        gre_header.indTransbordoProgramado = 1
        gre_header.m_divorigen = cDivisionOrigen
        gre_header.m_divdestino = cDivisionDestino.

        RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
        IF RETURN-VALUE = "YES" THEN DO:
        ASSIGN gre_header.m_libre_c05 = cm_libre_c05
                gre_header.m_libre_l02 = lm_libre_l02.
    END.

  IF cParteDeIngreso = "SI" THEN DO:
      ASSIGN gre_header.m_nroref1 = STRING(gre_header.m_serie_pi,"999") + "-" + STRING(gre_header.m_numero_pi,"999999999").
  END.

  CASE cMotivoTraslado:
      WHEN "01" THEN DO:
            /* Ventas */

            /* Remitente */
          ASSIGN gre_header.tipoDocumentoRemitente = ctipoDocumentoContinental
                gre_header.numeroDocumentoRemitente = cnumeroDocumentoContinental
                gre_header.razonSocialRemitente = crazonSocialContinental
                gre_header.tipoDocumentoEstablecimiento = gre_header.tipoDocumentoRemitente
                gre_header.numeroDocumentoEstablecimiento = gre_header.numeroDocumentoRemitente        
                gre_header.razonSocialEstablecimiento = gre_header.razonSocialRemitente
                gre_header.codigoPtopartida = cPuntoOrigen
                gre_header.ubigeoPtoPartida = cUbigeoOrigen
                gre_header.direccionPtoPartida = cDireccionOrigen
           .

            /* Destinatario */
          ASSIGN    gre_header.tipoDocumentoDestinatario = if(cRUCcliente > "") THEN '6' ELSE "1"
                    gre_header.numeroDocumentoDestinatario = if(cRUCcliente > "") THEN cRUCcliente ELSE cDNIcliente
                    gre_header.razonSocialDestinatario = fill-in-cliente
                    gre_header.ubigeoPtoLlegada = cUbigeoDestino
                    gre_header.codigoPtoLlegada = cPuntoDestino        
                    gre_header.direccionPtoLlegada = cDireccionDestino
           .
      END.
      WHEN "02" THEN DO:
          /* Compras */ 

          /* Remitente */
          ASSIGN gre_header.tipoDocumentoRemitente = '6'
                gre_header.numeroDocumentoRemitente = cRUCproveedor
                gre_header.razonSocialRemitente = fill-in-proveedor
                gre_header.tipoDocumentoEstablecimiento = ""
                gre_header.numeroDocumentoEstablecimiento = ""
                gre_header.razonSocialEstablecimiento = ""
                gre_header.codigoPtopartida = cPuntoProveedor
                gre_header.ubigeoPtoPartida = cUbigeoProveedor
                gre_header.direccionPtoPartida = cDireccionProveedor
           .
          /* Destinatario */
          ASSIGN    gre_header.tipoDocumentoDestinatario = ctipoDocumentoContinental
                    gre_header.numeroDocumentoDestinatario = cnumeroDocumentoContinental
                    gre_header.razonSocialDestinatario = crazonSocialContinental
                    gre_header.ubigeoPtoLlegada = cUbigeoOrigen /* Continental */
                    gre_header.codigoPtoLlegada = cPuntoOrigen
                    gre_header.direccionPtoLlegada = cDireccionOrigen
            .
      END.
      WHEN "03" THEN DO:
          /* Compras con despacho a terceros */

          /* Remitente */
          ASSIGN gre_header.tipoDocumentoRemitente = ctipoDocumentoContinental
                gre_header.numeroDocumentoRemitente = cnumeroDocumentoContinental
                gre_header.razonSocialRemitente = crazonSocialContinental
                gre_header.tipoDocumentoEstablecimiento = gre_header.tipoDocumentoRemitente
                gre_header.numeroDocumentoEstablecimiento = gre_header.numeroDocumentoRemitente        
                gre_header.razonSocialEstablecimiento = gre_header.razonSocialRemitente
                gre_header.codigoPtopartida = cUbigeoOrigen /* Continental */
                gre_header.ubigeoPtoPartida = cPuntoOrigen
                gre_header.direccionPtoPartida = cDireccionOrigen
           .
          /* Destinatario */
          ASSIGN    gre_header.tipoDocumentoDestinatario = "Del tercero"
                    gre_header.numeroDocumentoDestinatario = "Del tecero"
                    gre_header.razonSocialDestinatario = "Del Tercero"
                    gre_header.ubigeoPtoLlegada = "Del tercero"
                    gre_header.codigoPtoLlegada = "Del tercero"
                    gre_header.direccionPtoLlegada = "Del tercero"
            .
      END.

      WHEN "04" THEN DO:
          /* Entre establecimientos */

          /* Remitente */
          ASSIGN gre_header.tipoDocumentoRemitente = ctipoDocumentoContinental
                gre_header.numeroDocumentoRemitente = cnumeroDocumentoContinental
                gre_header.razonSocialRemitente = crazonSocialContinental
                gre_header.tipoDocumentoEstablecimiento = gre_header.tipoDocumentoRemitente
                gre_header.numeroDocumentoEstablecimiento = gre_header.numeroDocumentoRemitente        
                gre_header.razonSocialEstablecimiento = gre_header.razonSocialRemitente
                gre_header.codigoPtopartida = cPuntoOrigen
                gre_header.numeroDocumentoPtoPartida = cnumeroDocumentoContinental
                gre_header.ubigeoPtoPartida = cUbigeoOrigen /* Continental */
                gre_header.direccionPtoPartida = cDireccionOrigen
           .
          /* Destinatario */
          ASSIGN    gre_header.tipoDocumentoDestinatario = ctipoDocumentoContinental
                    gre_header.numeroDocumentoDestinatario = cnumeroDocumentoContinental
                    gre_header.razonSocialDestinatario = crazonSocialContinental
                    gre_header.ubigeoPtoLlegada = cUbigeoDestino
                    gre_header.codigoPtoLlegada = cPuntoDestino
                    gre_header.direccionPtoLlegada = cDireccionDestino
                    gre_header.numeroDocumentoPtoLlegada = cnumeroDocumentoContinental
            .
          
      END.
    
      WHEN "05" THEN DO:
          /* Consignacion */
      END.
      WHEN "06" THEN DO:
          /* Devoluciones al proveedor */
          IF gre_header.m_codmov = 91 THEN DO:
              /* Remitente */
              ASSIGN gre_header.tipoDocumentoRemitente = ctipoDocumentoContinental 
                    gre_header.numeroDocumentoRemitente = cnumeroDocumentoContinental 
                    gre_header.razonSocialRemitente = crazonSocialContinental 
                    gre_header.tipoDocumentoEstablecimiento = "6"
                    gre_header.numeroDocumentoEstablecimiento = cRucProveedor
                    gre_header.razonSocialEstablecimiento = fill-in-proveedor
                    gre_header.codigoPtopartida = cPuntoOrigen
                    gre_header.ubigeoPtoPartida = cUbigeoOrigen /* Continental */
                    gre_header.direccionPtoPartida = cDireccionOrigen
               .
              /* Destinatario */
              ASSIGN    gre_header.tipoDocumentoDestinatario = "6"
                        gre_header.numeroDocumentoDestinatario = cRucProveedor
                        gre_header.razonSocialDestinatario = fill-in-proveedor
                        gre_header.codigoPtoLlegada = cPuntoProveedor
                        gre_header.ubigeoPtoLlegada = cUbigeoProveedor                        
                        gre_header.direccionPtoLlegada = cDireccionProveedor
                .
          END.              
      END.        
      WHEN "07" THEN DO:
          /* Recojo de bienes transformados */
          /* Remitente */
          ASSIGN gre_header.tipoDocumentoRemitente = "6"
                gre_header.numeroDocumentoRemitente = cRucProveedor
                gre_header.razonSocialRemitente = fill-in-proveedor
                gre_header.tipoDocumentoEstablecimiento = ""
                gre_header.numeroDocumentoEstablecimiento = ""
                gre_header.razonSocialEstablecimiento = ""
                gre_header.codigoPtopartida = cPuntoProveedor
                gre_header.ubigeoPtoPartida = cUbigeoProveedor                        
                gre_header.direccionPtoPartida = cDireccionProveedor
           .
          /* Destinatario */
          ASSIGN    gre_header.tipoDocumentoDestinatario = ctipoDocumentoContinental
                    gre_header.numeroDocumentoDestinatario = cnumeroDocumentoContinental
                    gre_header.razonSocialDestinatario = crazonSocialContinental
                    gre_header.ubigeoPtoLlegada = cUbigeoOrigen /* Continental */
                    gre_header.codigoPtoLlegada = cPuntoOrigen
                    gre_header.direccionPtoLlegada = cDireccionOrigen
            .
      END.
      WHEN "08" THEN DO:
          /* Importaciones */
      END.
      WHEN "09" THEN DO:
          /* Exportaciones */
      END.

      WHEN "13" THEN DO:
          /* Otros */
          IF gre_header.m_codmov = 29 THEN DO:
             /* Devoluciones de cliente */ 

              /* Remitente */
              ASSIGN gre_header.tipoDocumentoRemitente = if(cRUCcliente > "") THEN '6' ELSE "1"
                    gre_header.numeroDocumentoRemitente = if(cRUCcliente > "") THEN cRUCcliente ELSE cDNIcliente
                    gre_header.razonSocialRemitente = fill-in-cliente
                    gre_header.tipoDocumentoEstablecimiento = if(cRUCcliente > "") THEN '6' ELSE "1"
                    gre_header.numeroDocumentoEstablecimiento = if(cRUCcliente > "") THEN cRUCcliente ELSE cDNIcliente
                    gre_header.razonSocialEstablecimiento = fill-in-cliente
                    gre_header.codigoPtopartida = cPuntoCliente
                    gre_header.ubigeoPtoPartida = cUbigeoCliente
                    gre_header.direccionPtoPartida = cDireccionCliente
               .
              /* Destinatario */
              ASSIGN    gre_header.tipoDocumentoDestinatario = ctipoDocumentoContinental
                        gre_header.numeroDocumentoDestinatario = cnumeroDocumentoContinental
                        gre_header.razonSocialDestinatario = crazonSocialContinental
                        gre_header.ubigeoPtoLlegada = cUbigeoOrigen /* Continental */
                        gre_header.codigoPtoLlegada = cPuntoOrigen
                        gre_header.direccionPtoLlegada = cDireccionOrigen
                .
          END.
          ELSE DO:
              /**/
              RUN grabar-otros.
          END.
      END.        
      WHEN "14" THEN DO:
          /* Venta sujeta a confirmacion del comprador */
      END.
      WHEN "17" THEN DO:
          /* Traslado de bienes para transformacion */

          /* Remitente */
          ASSIGN gre_header.tipoDocumentoRemitente = ctipoDocumentoContinental
                gre_header.numeroDocumentoRemitente = cnumeroDocumentoContinental
                gre_header.razonSocialRemitente = crazonSocialContinental
                gre_header.tipoDocumentoEstablecimiento = ""
                gre_header.numeroDocumentoEstablecimiento = ""
                gre_header.razonSocialEstablecimiento = ""
                gre_header.codigoPtopartida = cPuntoOrigen
                gre_header.ubigeoPtoPartida = cUbigeoOrigen /* Continental */
                gre_header.direccionPtoPartida = cDireccionOrigen
           .
          /* Destinatario */
          ASSIGN    gre_header.tipoDocumentoDestinatario = "6"
                    gre_header.numeroDocumentoDestinatario = cRucProveedor
                    gre_header.razonSocialDestinatario = fill-in-proveedor
                    gre_header.ubigeoPtoLlegada = cUbigeoProveedor
                    gre_header.codigoPtoLlegada = cPuntoProveedor
                    gre_header.direccionPtoLlegada = cDireccionProveedor
            .
      END.
      WHEN "18" THEN DO:
          /* Traslado emisor itinerante */
          /* Remitente */
          ASSIGN gre_header.tipoDocumentoRemitente = ctipoDocumentoContinental
                gre_header.numeroDocumentoRemitente = cnumeroDocumentoContinental
                gre_header.razonSocialRemitente = crazonSocialContinental
                gre_header.tipoDocumentoEstablecimiento = ""
                gre_header.numeroDocumentoEstablecimiento = ""
                gre_header.razonSocialEstablecimiento = ""
                gre_header.codigoPtopartida = cPuntoOrigen
                gre_header.ubigeoPtoPartida = cUbigeoOrigen /* Continental */
                gre_header.direccionPtoPartida = cDireccionOrigen
           .
          /* Destinatario */
          ASSIGN    gre_header.tipoDocumentoDestinatario = ctipoDocumentoContinental
                    gre_header.numeroDocumentoDestinatario = cnumeroDocumentoContinental
                    gre_header.razonSocialDestinatario = crazonSocialContinental
                    gre_header.ubigeoPtoLlegada = cUbigeoOrigen /* Continental */
                    gre_header.codigoPtoLlegada = cPuntoOrigen
                    gre_header.direccionPtoLlegada = cDireccionOrigen
            .
      END.
      OTHERWISE DO:
      END.
  END.
END.

  /* ELIMINAMOS EL DETALLE ANTERIOR */
  IF NOT L-CREA THEN DO:
    RUN Borra-Detalle.
    SESSION:SET-WAIT-STATE("").
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.

  RUN Genera-Detalle.
  SESSION:SET-WAIT-STATE("").
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* Actualizo el FlgSit de la OTR */
  IF gre_header.m_coddoc:SCREEN-VALUE = "OTR" THEN DO:
        cNroOTR = STRING(INTEGER(gre_header.m_nroser:SCREEN-VALUE),"999") + STRING(INTEGER(gre_header.m_nrodoc:SCREEN-VALUE),"999999").
        FIND FIRST faccpedi WHERE faccpedi.codcia = 1 AND faccpedi.coddoc = gre_header.m_coddoc AND
                            faccpedi.nroped = cNroOTR EXCLUSIVE-LOCK NO-ERROR.
        IF LOCKED faccpedi THEN DO:
            MESSAGE "La tabla FACCPEDI esta bloqueada...no se pudo actualizar" VIEW-AS ALERT-BOX INFORMATION.
            RETURN "ADM-ERROR".
        END.
        IF AVAILABLE faccpedi THEN ASSIGN faccpedi.flgsit = 'PGRE'.

        RELEASE faccpedi NO-ERROR.
  END.

  /**/
  l-crea = NO.

  RUN Procesa-Handle IN lh_Handle ('Pagina1').


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
  /* ******************************************** */
  /* 23/11/2023 */
  /* ******************************************** */
  IF s-acceso-total = NO THEN DO:
      RUN gre/d-error-gre-noactiva.w.
      RETURN 'ADM-ERROR'.
  END.
  /* ******************************************** */
  /* ******************************************** */

  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) . */
  /*
  RUN gn/gre-online.r(OUTPUT lGRE_ONLINE).

 IF lGRE_ONLINE = NO THEN DO:
       MESSAGE 'El proceso de GRE no esta activo' VIEW-AS ALERT-BOX ERROR.
       RETURN 'ADM-ERROR'.    
 END. 
  */
  DEFINE VAR cNroDoc AS CHAR.

  /* Code placed here will execute AFTER standard behavior.    */
  IF NOT AVAILABLE gre_header THEN DO:
      MESSAGE "No existe informacion" VIEW-AS ALERT-BOX INFORMATION.
      RETURN "ADM-ERROR".
  END.
  IF gre_header.m_rspta_sunat <> 'SIN ENVIAR' THEN DO:
      MESSAGE "Imposible ANULAR la PRE-GUIA" VIEW-AS ALERT-BOX INFORMATION.
      RETURN "ADM-ERROR".
  END.

    MESSAGE 'Esta seguro de ANULAR la Pre-Guia?' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.

    
  FIND FIRST b-gre_header WHERE ROWID(b-gre_header) = ROWID(gre_header) EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE b-gre_header THEN DO:
      MESSAGE "Imposible ANULAR la PRE-GUIA" SKIP
            ERROR-STATUS:GET-MESSAGE(1)
          VIEW-AS ALERT-BOX INFORMATION.
      RETURN "ADM-ERROR".
  END.

  ASSIGN b-gre_header.m_rspta_sunat = "ANULADO"
        b-gre_header.m_fecha_anulacion = NOW
        b-gre_header.m_usuario_anulacion = USERID("DICTDB").

  IF b-gre_header.m_coddoc = 'OTR' THEN DO:
      cNroDoc = STRING(b-gre_header.m_nroser,"999") + 
              STRING(b-gre_header.m_nrodoc,"999999").
      FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = 1 AND b-faccpedi.coddoc = b-gre_header.m_CodDoc AND b-faccpedi.nroped = cNroDoc NO-LOCK NO-ERROR.
      IF AVAILABLE b-faccpedi THEN DO:
          IF b-faccpedi.flgsit = 'PGRE' THEN DO:
              FIND CURRENT b-faccpedi EXCLUSIVE-LOCK NO-ERROR.
              IF LOCKED b-faccpedi THEN DO:
                  RELEASE b-faccpedi NO-ERROR.
                  MESSAGE "La tabla FACCPEDI esta bloqueada...imposible actualizar flag situacion de la OTR" VIEW-AS ALERT-BOX INFORMATION.                  
                  RETURN "ADM-ERROR".
              END.
              ELSE DO:
                  IF AVAILABLE b-faccpedi THEN DO:
                      ASSIGN b-faccpedi.flgsit = 'C'.
                      RELEASE b-faccpedi NO-ERROR.
                  END.
              END.                            
          END.
      END.
  END.

  RELEASE b-gre_header.
  
  /* refrescamos los datos del viewer */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  /* refrescamos los datos del browse */
  RUN Procesa-Handle IN lh_Handle ('Pagina1').

  RETURN "OK".


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

  DEFINE VAR cMotivoTraslado AS CHAR.
  DEFINE VAR iCodMov AS INT.

  iCodMov = 0.
  FIND FIRST gre_movalm_mottraslado WHERE gre_movalm_mottraslado.codmov = Almtdocm.CodMov NO-LOCK NO-ERROR.
  IF AVAILABLE gre_movalm_mottraslado THEN DO:
      cMotivoTraslado = gre_movalm_mottraslado.codmotivotraslado.
      iCodMov = gre_movalm_mottraslado.codmov.
  END.

  FIND FIRST almtmovm WHERE almtmovm.codcia = 1 AND almtmovm.tipmov = 'S' AND 
      almtmovm.codmov = Almtdocm.CodMov NO-LOCK NO-ERROR.
  
  DO WITH FRAME {&FRAME-NAME}:

      fill-in-muevestock:VISIBLE = YES.
      fill-in-muevestock:SCREEN-VALUE = "NO MUEVE STOCK".                  
      IF AVAILABLE almtmovm THEN DO:
          IF almtmovm.movVal =YES THEN DO:
                fill-in-muevestock:SCREEN-VALUE = "SI MUEVE STOCK".                  
          END.
      END.

      RUN ocultar-todos.

      fill-in-almacen-origen:SCREEN-VALUE = "".
      fill-in-almacen-destino:SCREEN-VALUE = "".
      fill-in-cliente:SCREEN-VALUE = "".
      fill-in-proveedor:SCREEN-VALUE = "".
      fill-in-sede:SCREEN-VALUE = "".      
      fill-in-recepcionado:SCREEN-VALUE = "".      

      IF AVAILABLE almtmovm THEN DO:
          ASSIGN  gre_header.m_cliente:VISIBLE = almtmovm.pidcli
                gre_header.m_proveedor:VISIBLE = almtmovm.pidpro
                gre_header.m_sede:VISIBLE = (almtmovm.pidcli = YES OR almtmovm.pidpro = YES)
                gre_header.m_nroref1:VISIBLE = almtmovm.pidref1
                gre_header.m_nroref2:VISIBLE = almtmovm.pidref2
                gre_header.m_nroref3:VISIBLE = FALSE
                gre_header.m_codalmdes:VISIBLE = almtmovm.movtrf
                fill-in-almacen-destino:VISIBLE = almtmovm.movtrf
                gre_header.m_almacenXD:VISIBLE = almtmovm.movtrf
                fill-in-almacen-final:VISIBLE = almtmovm.movtrf
                gre_header.m_cco:VISIBLE = almtmovm.pidcct
              .
            /*IF almtmovm.codmov = 50 OR almtmovm.codmov = 51 THEN gre_header.m_nroref3:VISIBLE = TRUE.*/
            IF Almtmovm.PidRef1 THEN ASSIGN gre_header.m_NroRef1:LABEL = Almtmovm.GloRf1.
            IF Almtmovm.PidRef2 THEN ASSIGN gre_header.m_NroRef2:LABEL = Almtmovm.GloRf2.
            
            IF almtmovm.codmov = 03 THEN DO:
                /*ASSIGN gre_header.m_codalmdes:VISIBLE = TRUE
                        fill-in-almacen-destino:VISIBLE = TRUE
                        gre_header.m_almacenXD:VISIBLE = YES
                        fill-in-almacen-final:VISIBLE = YES*/.
            END.                
            
      END.

      IF AVAILABLE gre_header THEN DO:      
              
          IF gre_header.motivoTraslado = '13' AND gre_header.m_codmov <> 29 THEN DO:
              /* Otros, NO devolucion de cliente */
              ASSIGN gre_header.m_llevar_traer_mercaderia:VISIBLE = YES.
          END.
                                                                                                                                           
          IF gre_header.m_coddoc = 'OTR' THEN DO:
              ASSIGN gre_header.m_crossdocking:VISIBLE = YES
                  gre_header.m_almacenXD:VISIBLE = YES
                  fill-in-almacen-final:VISIBLE = YES.              
              FIND FIRST almcmov WHERE almcmov.codcia = 1 AND almcmov.codalm = gre_header.m_codalm AND
                                        almcmov.tipmov = 'S' AND almcmov.codmov = iCodMov AND 
                                        almcmov.nroser = gre_header.serieGuia AND 
                                        almcmov.nrodoc = gre_header.numeroGuia NO-LOCK NO-ERROR.
              IF AVAILABLE almcmov THEN DO:
                  IF almcmov.flgsit = 'T' THEN fill-in-recepcionado:SCREEN-VALUE = "TRANSFERIDO".
                  IF almcmov.flgsit = 'R' THEN fill-in-recepcionado:SCREEN-VALUE = "RECEPCIONADO".
              END.

          END.



          IF NOT ( TRUE <> (gre_header.m_codalm > "")) THEN DO:
              FIND FIRST almacen WHERE almacen.codcia = s-codcia AND 
                                        almacen.codalm = gre_header.m_codalm NO-LOCK NO-ERROR.
              IF AVAILABLE almacen THEN fill-in-almacen-origen:SCREEN-VALUE = almacen.descripcion.
          END.
          IF NOT ( TRUE <> (gre_header.m_codalmdes > "")) THEN DO:
              FIND FIRST almacen WHERE almacen.codcia = s-codcia AND 
                                        almacen.codalm = gre_header.m_codalmdes NO-LOCK NO-ERROR.
              IF AVAILABLE almacen THEN fill-in-almacen-destino:SCREEN-VALUE = almacen.descripcion.
          END.
          IF NOT ( TRUE <> (gre_header.m_almacenXD > "")) THEN DO:
              FIND FIRST almacen WHERE almacen.codcia = s-codcia AND 
                                        almacen.codalm = gre_header.m_almacenXD NO-LOCK NO-ERROR.
              IF AVAILABLE almacen THEN fill-in-almacen-final:SCREEN-VALUE = almacen.descripcion.
          END.

          IF NOT ( TRUE <> (gre_header.m_cliente > "")) THEN DO:
              FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND 
                                        gn-clie.codcli = gre_header.m_cliente NO-LOCK NO-ERROR.
              IF AVAILABLE gn-clie THEN DO:
                  /*fill-in-cliente:SCREEN-VALUE = gn-clie.nomcli.*/
                  DISPLAY gn-clie.nomcli @ fill-in-cliente.
                 IF AVAILABLE gn-clie AND gre_header.m_cliente <> "11111111" THEN DO:
                     DISPLAY gn-clie.NomCli @ FILL-IN-cliente.
                 END.
                 ELSE DO:
                     DISPLAY gre_header.m_NomRef @ FILL-IN-cliente.
                 END.
                 FIND Gn-ClieD WHERE Gn-ClieD.CodCia = 0
                     AND Gn-ClieD.CodCli = gre_header.m_cliente
                     AND Gn-ClieD.Sede = gre_header.m_sede
                     NO-LOCK NO-ERROR.
                 IF AVAILABLE Gn-ClieD THEN DISPLAY Gn-ClieD.DirCli @ FILL-IN-sede.
              END.              
          END.
          IF NOT ( TRUE <> (gre_header.m_proveedor > "")) THEN DO:
              FIND FIRST gn-prov WHERE gn-prov.codcia = 0 AND 
                                        gn-prov.codpro = gre_header.m_proveedor NO-LOCK NO-ERROR.
              IF AVAILABLE gn-prov THEN DO:  
                  /*fill-in-proveedor:SCREEN-VALUE = gn-prov.nompro.*/
                  DISPLAY gn-prov.nompro @ fill-in-proveedor.
                  FIND Gn-ProvD WHERE Gn-ProvD.CodCia = 0
                      AND Gn-ProvD.CodPro = gre_header.m_proveedor
                      AND Gn-ProvD.Sede = gre_header.m_sede
                      NO-LOCK NO-ERROR.
                  IF AVAILABLE Gn-ProvD THEN DISPLAY Gn-ProvD.DirPro @ FILL-IN-Sede.
              END.
          END.

          /* Referencias */
          RUN mostrar-data-ref1(gre_header.m_nroref1).
          RUN mostrar-data-ref2(gre_header.m_nroref2).
          RUN mostrar-data-ref3(gre_header.m_nroref3).

      END.
      /*
      gre_header.m_serie_pi:VISIBLE = NO.
      gre_header.m_numero_pi:VISIBLE = NO.
      */
      IF AVAILABLE almtdocm THEN DO:
          IF almtdocm.codmov = 30 AND almtdocm.tipmov = 'S' THEN DO:
              ASSIGN gre_header.m_serie_pi:VISIBLE = YES
                gre_header.m_numero_pi:VISIBLE = YES.
          END.
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

  DEFINE VAR cMotivoTraslado AS CHAR.

  FIND FIRST gre_movalm_mottraslado WHERE gre_movalm_mottraslado.codmov = Almtdocm.CodMov NO-LOCK NO-ERROR.
  IF AVAILABLE gre_movalm_mottraslado THEN DO:
      cMotivoTraslado = gre_movalm_mottraslado.codmotivotraslado.
  END.

  DO WITH FRAME {&FRAME-NAME}:

      FIND FIRST almtmovm WHERE almtmovm.codcia = 1 AND almtmovm.tipmov = 'S' AND almtmovm.codmov = Almtdocm.CodMov NO-LOCK NO-ERROR.
          
          fill-in-muevestock:SCREEN-VALUE = "NO MUEVE STOCK".                  
          IF AVAILABLE almtmovm THEN DO:
              IF almtmovm.movVal =YES THEN DO:
                    fill-in-muevestock:SCREEN-VALUE = "SI MUEVE STOCK".                  
              END.
          END.
          fill-in-muevestock:SENSITIVE = NO.

      RUN no-editable-todos.

    gre_header.m_nroref1:SENSITIVE = almtmovm.pidref1.
    gre_header.m_nroref2:SENSITIVE = almtmovm.pidref2.
    gre_header.serieGuia:SENSITIVE = NO.
    gre_header.numeroGuia:SENSITIVE = NO.
    gre_header.m_almacenXD:SENSITIVE = NO.
    gre_header.observaciones:SENSITIVE = YES.
    fill-in-almacen-final:SENSITIVE = NO.

      CASE cMotivoTraslado:
          WHEN "01" THEN DO:
              /* Venta */
          END.
          WHEN "02" THEN DO:
              /* Compra */
                gre_header.m_codalmdes:SENSITIVE = gre_header.m_codalmdes:VISIBLE.
                gre_header.m_proveedor:SENSITIVE = gre_header.m_proveedor:VISIBLE.
                gre_header.m_sede:SENSITIVE = gre_header.m_sede:VISIBLE.
          END.
          WHEN "03" THEN DO:
              /* Venta con entrega a terceros */
              gre_header.m_cliente:SENSITIVE = gre_header.m_cliente:VISIBLE.
              gre_header.m_sede:SENSITIVE = gre_header.m_sede:VISIBLE.
          END.
          WHEN "04" THEN DO:
              /* Traslado entre establecimientos */
              gre_header.m_codalmdes:SENSITIVE = gre_header.m_codalmdes:VISIBLE.
              gre_header.m_sede:SENSITIVE = gre_header.m_sede:VISIBLE.
          END.
          WHEN "05" THEN DO:
              /* Consignacion */
              gre_header.m_cliente:SENSITIVE = gre_header.m_cliente:VISIBLE.
              gre_header.m_sede:SENSITIVE = gre_header.m_sede:VISIBLE.
          END.
          WHEN "06" THEN DO:
              /* Devolucion (mercaderia al proveedor) */
              gre_header.m_codalmdes:SENSITIVE = gre_header.m_codalmdes:VISIBLE.
              gre_header.m_proveedor:SENSITIVE = gre_header.m_proveedor:VISIBLE.
              gre_header.m_sede:SENSITIVE = gre_header.m_sede:VISIBLE.
          END.
          WHEN "07" THEN DO:
              /* Recojo bienes transformados */
              gre_header.m_codalmdes:SENSITIVE = gre_header.m_codalmdes:VISIBLE.
              gre_header.m_proveedor:SENSITIVE = gre_header.m_proveedor:VISIBLE.
              gre_header.m_sede:SENSITIVE = gre_header.m_sede:VISIBLE.
          END.
          WHEN "08" THEN DO:
              /* Importacion */
              gre_header.m_codalmdes:SENSITIVE = gre_header.m_codalmdes:VISIBLE.
              gre_header.m_cliente:SENSITIVE = gre_header.m_cliente:VISIBLE.
              gre_header.m_sede:SENSITIVE = gre_header.m_sede:VISIBLE.
          END.
          WHEN "09" THEN DO:
              /* Exportacion */
              gre_header.m_codalmdes:SENSITIVE = gre_header.m_codalmdes:VISIBLE.
              gre_header.m_proveedor:SENSITIVE = gre_header.m_proveedor:VISIBLE.
              gre_header.m_sede:SENSITIVE = gre_header.m_sede:VISIBLE.
          END.
          WHEN "13" THEN DO:
              /* Otros ()*/
              IF Almtdocm.CodMov = 29 THEN DO:
                  gre_header.m_codalmdes:SENSITIVE = gre_header.m_codalmdes:VISIBLE.
                  gre_header.m_cliente:SENSITIVE = gre_header.m_cliente:VISIBLE.
                  gre_header.m_sede:SENSITIVE = gre_header.m_sede:VISIBLE.
              END.
              ELSE DO:
                  /* Otros, NO devolucion de cliente */
                  ASSIGN  gre_header.m_cliente:SENSITIVE = almtmovm.pidcli
                        gre_header.m_proveedor:SENSITIVE = almtmovm.pidpro
                        gre_header.m_sede:SENSITIVE = (almtmovm.pidcli = YES OR almtmovm.pidpro = YES).
                        /*gre_header.m_nroref3:VISIBLE = FALSE*/

                  ASSIGN gre_header.m_llevar_traer_mercaderia:SENSITIVE = gre_header.m_llevar_traer_mercaderia:VISIBLE.                     
              END.

          END.
          WHEN "14" THEN DO:
              /* Venta sujeta a confirmacion del comprador */
              /* Faltaria datos del tercero comprometido, quiza pase como cliente noseeee sabe */
          END.
          WHEN "17" THEN DO:
              /* Traslado de bienes para transformacion */
              gre_header.m_codalmdes:SENSITIVE = gre_header.m_codalmdes:VISIBLE.
              gre_header.m_proveedor:SENSITIVE = gre_header.m_proveedor:VISIBLE.
              gre_header.m_sede:SENSITIVE = gre_header.m_sede:VISIBLE.
          END.
          WHEN "18" THEN DO:
              /* Traslado emisor remitente */
          END.
      END CASE.

      /*
      gre_header.numeroGuia:SENSITIVE = NO.
      gre_header.m_codalm:SENSITIVE = NO.
      gre_header.serieGuia:SENSITIVE = NO.
      gre_header.fechaEmisionGuia:SENSITIVE = NO.
      gre_header.horaEmisionGuia:SENSITIVE = NO.
      gre_header.m_usuario:SENSITIVE = NO.
      gre_header.m_coddoc:SENSITIVE = NO.
      gre_header.m_nroser:SENSITIVE = NO.
      gre_header.m_nrodoc:SENSITIVE = NO.
      gre_header.pesoBrutoTotalBienes:SENSITIVE = NO.
      gre_header.numeroBultos:SENSITIVE = YES.
      */
      IF almtdocm.codmov = 30 AND almtdocm.tipmov = 'S' THEN DO:
          ASSIGN gre_header.m_serie_pi:VISIBLE = YES
          gre_header.m_numero_pi:VISIBLE = YES.
      END.
      
      IF almtdocm.codmov = 03 THEN DO:
          RUN GET-ATTRIBUTE ("ADM-NEW-RECORD").
          IF RETURN-VALUE = "YES" 
          THEN gre_header.m_codAlmDes:SENSITIVE = YES.
          ELSE gre_header.m_codAlmDes:SENSITIVE = NO.
          /*
           gre_header.m_almacenXD:VISIBLE = YES.
           fill-in-almacen-final:VISIBLE = YES.
           gre_header.m_almacenXD:SENSITIVE = NO.
           fill-in-almacen-final:SENSITIVE = NO.
          */
          button-otr:VISIBLE = YES.          
      END.
      button-excel:VISIBLE = YES.
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

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      gre_header.m_serie_pi:VISIBLE = NO.
      gre_header.m_numero_pi:VISIBLE = NO.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mostrar-data-ref1 V-table-Win 
PROCEDURE mostrar-data-ref1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pData AS CHAR.

DEFINE VAR cMotivoTraslado AS CHAR.
DEFINE VAR cNomPersonal AS CHAR.

DO WITH FRAME {&FRAME-NAME} :

    fill-in-txt-ref1:SCREEN-VALUE = "".

    FIND FIRST gre_movalm_mottraslado WHERE gre_movalm_mottraslado.codmov = almtdocm.codmov NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gre_movalm_mottraslado THEN DO:
      /*pMsgRet = "Movimiento de almacen (" + STRING(almtdocm.codmov) + ") no tiene asociado aun motivo de traslado".*/
      RETURN "ADM-ERROR".
    END.
    cMotivoTraslado = gre_movalm_mottraslado.codmotivotraslado.
    
    IF LOOKUP(cMotivoTraslado,'13,18') = 0 THEN RETURN "OK".
    IF LOOKUP(STRING(almtdocm.codmov),"29,81,82,83") = 0 THEN RETURN "OK".

    IF almtdocm.codmov = 81 OR almtdocm.codmov = 82 THEN DO:
        RUN gn/nombre-personal(s-codcia, pData, OUTPUT cNomPersonal).
    END.

    fill-in-txt-ref1:SCREEN-VALUE = cNomPersonal.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mostrar-data-ref2 V-table-Win 
PROCEDURE mostrar-data-ref2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pData AS CHAR.

DEFINE VAR cMotivoTraslado AS CHAR.
DEFINE VAR cNomPersonal AS CHAR.

DO WITH FRAME {&FRAME-NAME} :

    fill-in-txt-ref-2:SCREEN-VALUE = "".

    FIND FIRST gre_movalm_mottraslado WHERE gre_movalm_mottraslado.codmov = almtdocm.codmov NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gre_movalm_mottraslado THEN DO:
      RETURN "ADM-ERROR".
    END.
    cMotivoTraslado = gre_movalm_mottraslado.codmotivotraslado.
    
    IF LOOKUP(cMotivoTraslado,'13,18') = 0 THEN RETURN "OK".
    IF LOOKUP(STRING(almtdocm.codmov),"29,81,82,83") = 0 THEN RETURN "OK".

    RUN gn/nombre-personal(s-codcia, pData, OUTPUT cNomPersonal).

    fill-in-txt-ref-2:SCREEN-VALUE = cNomPersonal.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mostrar-data-ref3 V-table-Win 
PROCEDURE mostrar-data-ref3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pData AS CHAR.

DEFINE VAR cMotivoTraslado AS CHAR.

DO WITH FRAME {&FRAME-NAME} :

    fill-in-txt-ref-3:SCREEN-VALUE = "".
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE muestra-todos V-table-Win 
PROCEDURE muestra-todos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
      
        ASSIGN /*gre_header.m_codalm:VISIBLE = NO
        fill-in-almacen-origen:VISIBLE = NO*/
        gre_header.m_codalmdes:VISIBLE = YES
        fill-in-almacen-destino:VISIBLE = YES
        gre_header.m_cliente:VISIBLE = YES
        fill-in-cliente:VISIBLE = YES
        gre_header.m_proveedor:VISIBLE = YES
        fill-in-proveedor:VISIBLE = YES
        gre_header.m_sede:VISIBLE = YES
        fill-in-sede:VISIBLE = YES
        gre_header.m_nroref1:VISIBLE = YES
        gre_header.m_serie_pi:VISIBLE = YES
        gre_header.m_numero_pi:VISIBLE = YES
        gre_header.m_nroref2:VISIBLE = YES
        gre_header.m_nroref3:VISIBLE = YES
        gre_header.m_cco:VISIBLE = YES
        gre_header.m_crossdocking:VISIBLE = YES
        /*gre_header.observaciones:VISIBLE = NO*/
        gre_header.m_almacenXD:VISIBLE = YES
        gre_header.m_llevar_traer_mercaderia:VISIBLE = YES
        fill-in-almacen-final:VISIBLE = YES
        button-excel:VISIBLE = NO
        BUTTON-otr:VISIBLE = NO.

  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mueve-stock V-table-Win 
PROCEDURE mueve-stock :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pMueveStock AS LOG.

FIND FIRST almtmovm WHERE almtmovm.codcia = 1 AND almtmovm.tipmov = 'S' AND almtmovm.codmov = Almtdocm.CodMov NO-LOCK NO-ERROR.
  
pMueveStock = NO.

IF AVAILABLE almtmovm THEN DO:
  pMueveStock = almtmovm.movVal.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE no-editable-todos V-table-Win 
PROCEDURE no-editable-todos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
        ASSIGN /*gre_header.m_codalm:SENSITIVE = NO*/
        gre_header.fechaEmisionGuia:SENSITIVE = NO
        gre_header.horaEmisionGuia:SENSITIVE = NO
        gre_header.m_codalmdes:SENSITIVE = NO
        gre_header.m_cliente:SENSITIVE = NO
        gre_header.m_proveedor:SENSITIVE = NO
        gre_header.m_sede:SENSITIVE = NO
        gre_header.m_nroref1:SENSITIVE = NO
        gre_header.m_serie_pi:SENSITIVE = NO
        gre_header.m_numero_pi:SENSITIVE = NO
        gre_header.m_nroref2:SENSITIVE = NO
        gre_header.m_nroref3:SENSITIVE = NO
        gre_header.m_cco:SENSITIVE = NO
        gre_header.m_crossdocking:SENSITIVE = NO
        gre_header.m_llevar_traer_mercaderia:SENSITIVE = NO
        /*gre_header.observaciones:SENSITIVE = NO*/
        gre_header.m_almacenXD:SENSITIVE = NO.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ocultar-todos V-table-Win 
PROCEDURE ocultar-todos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
      
        ASSIGN /*gre_header.m_codalm:VISIBLE = NO
        fill-in-almacen-origen:VISIBLE = NO*/
        gre_header.m_codalmdes:VISIBLE = NO
        fill-in-almacen-destino:VISIBLE = NO
        gre_header.m_cliente:VISIBLE = NO
        fill-in-cliente:VISIBLE = NO
        gre_header.m_proveedor:VISIBLE = NO
        fill-in-proveedor:VISIBLE = NO
        gre_header.m_sede:VISIBLE = NO
        fill-in-sede:VISIBLE = NO
        gre_header.m_nroref1:VISIBLE = NO
        gre_header.m_serie_pi:VISIBLE = NO
        gre_header.m_numero_pi:VISIBLE = NO
        gre_header.m_nroref2:VISIBLE = NO
        gre_header.m_nroref3:VISIBLE = NO
        gre_header.m_cco:VISIBLE = NO
        gre_header.m_crossdocking:VISIBLE = NO
        /*gre_header.observaciones:VISIBLE = NO*/
        gre_header.m_almacenXD:VISIBLE = NO
        gre_header.m_llevar_traer_mercaderia:VISIBLE = NO
        fill-in-almacen-final:VISIBLE = NO
        button-excel:VISIBLE = NO
        BUTTON-otr:VISIBLE = NO.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE otras-validaciones V-table-Win 
PROCEDURE otras-validaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pMsgRet AS CHAR NO-UNDO.

DEFINE VAR cRef1 AS CHAR.
DEFINE VAR cRef2 AS CHAR.
DEFINE VAR cRef3 AS CHAR.
DEFINE VAR cCodClie AS CHAR.
DEFINE VAR cCodDoc AS CHAR.
DEFINE VAR cNroDoc AS CHAR.

DEFINE VAR lPersonalActivo AS LOG.

DO WITH FRAME {&FRAME-NAME} :
    cRef1 = TRIM(gre_header.m_nroref1:SCREEN-VALUE).
    cRef2 = TRIM(gre_header.m_nroref2:SCREEN-VALUE).
    cRef3 = TRIM(gre_header.m_nroref3:SCREEN-VALUE).
    cCodClie = TRIM(gre_header.m_cliente:SCREEN-VALUE).
END.

pMsgRet = "".

DEFINE VAR cMotivoTraslado AS CHAR.

FIND FIRST gre_movalm_mottraslado WHERE gre_movalm_mottraslado.codmov = almtdocm.codmov NO-LOCK NO-ERROR.
IF NOT AVAILABLE gre_movalm_mottraslado THEN DO:
  pMsgRet = "Movimiento de almacen (" + STRING(almtdocm.codmov) + ") no tiene asociado aun motivo de traslado".
  RETURN "ADM-ERROR".
END.
cMotivoTraslado = gre_movalm_mottraslado.codmotivotraslado.

IF (cMotivoTraslado = "13" AND LOOKUP(STRING(almtdocm.codmov),"29,82,83") > 0 ) OR
    (cMotivoTraslado = "18" AND LOOKUP(STRING(almtdocm.codmov),"81") > 0 ) THEN DO:

    IF TRUE <> (cRef1 > "") THEN DO:
        pMsgRet = "Debe ingresar " + gre_header.m_NroRef1:LABEL.
        RETURN "ADM-ERROR".
    END.
    IF TRUE <> (cRef2 > "") THEN DO:
        pMsgRet = "Debe ingresar " + gre_header.m_NroRef2:LABEL.
        RETURN "ADM-ERROR".
    END.
    IF TRUE <> (cRef3 > "") THEN DO:
        /*
        pMsgRet = "Debe ingresar " + gre_header.m_NroRef2:LABEL.
        RETURN "ADM-ERROR".
        */
    END.

    IF almtdocm.codmov = 29 OR almtdocm.codmov = 83 THEN DO:
        cCodDoc = ENTRY(1,cRef1,"-").
        cNroDoc = ENTRY(2,cRef1,"-").

        /* Valida Cliente */
        FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND x-ccbcdocu.coddoc = cCodDoc AND x-ccbcdocu.nrodoc = cNroDoc NO-LOCK NO-ERROR.
        IF NOT AVAILABLE x-ccbcdocu THEN DO:
            pMsgRet = "El comprobante " + cCodDoc + "-" + cNroDoc + " ingresado no existe".
            RETURN "ADM-ERROR".
        END.
        IF x-ccbcdocu.flgest = "A" THEN DO:
            pMsgRet = "El comprobante " + cCodDoc + "-" + cNroDoc + " esta anulado".
            RETURN "ADM-ERROR".
        END.
        IF x-ccbcdocu.codcli <> cCodCLie THEN DO:
            pMsgRet = "El comprobante ingresado no pertenece al cliente " + gre_header.m_cliente:SCREEN-VALUE.
            RETURN "ADM-ERROR".
        END.
    END.
    /* Valida autorizado y solicitado */
    IF almtdocm.codmov = 82 OR almtdocm.codmov = 81 THEN DO:
        FIND FIRST pl-pers WHERE pl-pers.codper = cRef1 NO-LOCK NO-ERROR.
        IF NOT AVAILABLE pl-pers THEN DO:
            pMsgRet = "El solicitante " + cRef1 + " No existe".
            RETURN "ADM-ERROR".
        END.
        lPersonalActivo = NO.
        RUN gn/personal-activo(s-codcia, cRef1, OUTPUT lPersonalActivo).
        IF lPersonalActivo = NO THEN DO:
            pMsgRet = "El solicitante " + cRef1 + " NO esta activo".
            RETURN "ADM-ERROR".
        END.
    END.    
    FIND FIRST pl-pers WHERE pl-pers.codper = cRef2 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pl-pers THEN DO:
        pMsgRet = "El usuario que autoriza " + cRef2 + " No existe".
        RETURN "ADM-ERROR".
    END.
    /* - */
    lPersonalActivo = NO.
    RUN gn/personal-activo(s-codcia, cRef2, OUTPUT lPersonalActivo).
    IF lPersonalActivo = NO THEN DO:
        pMsgRet = "El usuario que autoriza " + cRef2 + " NO esta activo".
        RETURN "ADM-ERROR".
    END.
END.

RETURN "OK".

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Refrescar-items V-table-Win 
PROCEDURE Refrescar-items :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:

    /*
    SESSION:SET-WAIT-STATE("GENERAL").

    EMPTY TEMP-TABLE ITEM-gre.

    FIND FIRST x-almcmov WHERE x-almcmov.codcia = s-codcia AND
                            x-almcmov.codalm = s-codalm AND
                            x-almcmov.tipmov = 'I' AND
                            x-almcmov.codmov = 09 AND
                            x-almcmov.nroser = fill-in-serie AND
                            x-almcmov.nrodoc = fill-in-nro NO-LOCK NO-ERROR.
    IF AVAILABLE x-almcmov THEN DO:
        
        FOR EACH Almdmov OF x-Almcmov NO-LOCK :
            CREATE ITEM-gre.
            RAW-TRANSFER Almdmov TO ITEM-gre.
        END.
    END.

    RUN Procesa-Handle IN lh_Handle ('RefrescarItems').

    SESSION:SET-WAIT-STATE("").
    */
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
  {src/adm/template/snd-list.i "gre_header"}
  {src/adm/template/snd-list.i "Almtdocm"}
  {src/adm/template/snd-list.i "Almtmovm"}

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
DEFINE VARIABLE N-ITEM AS DECIMAL NO-UNDO INIT 0.
DEFINE VAR cMsgRet AS CHAR.

/* GRE - validacion de puntos de entrega */
cDivisionOrigen = "".
cDivisionDestino = "".
cPuntoOrigen = "".

cPuntoDestino = "".
cUbigeoOrigen = "".
cUbigeoDestino = "".

cDireccionOrigen = "".
cDireccionDestino = "".
cRUCcliente = "".
cRUCproveedor = "".
cDNIcliente = "".
cNomRef = "".

cPuntoCliente = "".
cUbigeoCliente = "".
cDireccionCliente = "".
cPuntoProveedor = "".
cUbigeoProveedor = "".
cDireccionProveedor = "".

DEFINE VAR cSerieOtr AS CHAR.
DEFINE VAR cNumeroOtr AS CHAR.

DO WITH FRAME {&FRAME-NAME} :

    ASSIGN fill-in-cliente fill-in-proveedor fill-in-sede.

   IF gre_header.m_proveedor:VISIBLE THEN DO:
         FIND gn-prov WHERE gn-prov.CodCia = 0
                       AND  gn-prov.CodPro = gre_header.m_proveedor:SCREEN-VALUE 
                      NO-LOCK NO-ERROR.
         IF NOT AVAILABLE gn-prov THEN DO:
            MESSAGE "Codigo de Proveedor no Existe" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO gre_header.m_proveedor.
            RETURN "ADM-ERROR".   
         END.
         FIND FIRST Gn-ProvD WHERE Gn-ProvD.CodCia = 0
             AND Gn-ProvD.CodPro = gre_header.m_proveedor:SCREEN-VALUE
             AND Gn-ProvD.Sede = gre_header.m_sede:SCREEN-VALUE
             NO-LOCK NO-ERROR.
         IF NOT AVAILABLE Gn-ProvD THEN DO:
             MESSAGE "Codigo de Sede de Proveedor no Existe" VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO gre_header.m_sede.
             RETURN "ADM-ERROR".   
         END.
         cRUCproveedor = Gn-Prov.ruc.
         cPuntoProveedor = gre_header.m_sede:SCREEN-VALUE.
         cUbigeoProveedor = Gn-provD.coddept + Gn-provD.codprov + Gn-provD.coddist.
         cDireccionProveedor = Gn-provD.dirpro.
         cNomRef = gn-prov.nompro.
   END.
   IF gre_header.m_cliente:VISIBLE THEN DO:
         FIND gn-clie WHERE gn-clie.CodCia = 0 
                       AND  gn-clie.CodCli = gre_header.m_cliente:SCREEN-VALUE 
                      NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-clie THEN DO:
         MESSAGE "Codigo de Cliente no Existe" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO gre_header.m_cliente.
         RETURN "ADM-ERROR".   
      END.
      FIND FIRST Gn-ClieD WHERE Gn-ClieD.CodCia = 0
          AND Gn-ClieD.CodCli = gre_header.m_cliente:SCREEN-VALUE
          AND Gn-ClieD.Sede = gre_header.m_sede:SCREEN-VALUE
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Gn-ClieD THEN DO:
          MESSAGE "Codigo de Sede del Cliente no Existe" VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO gre_header.m_sede.
          RETURN "ADM-ERROR".   
      END.
      cRUCcliente = Gn-Clie.ruc.
      IF TRUE <> (cRUCcliente > "") THEN DO:
          cRUCcliente = "".
          cDNIcliente = Gn-Clie.dni.
      END.
      cPuntoCliente = gre_header.m_sede:SCREEN-VALUE.
      cUbigeoCliente = Gn-ClieD.coddept + Gn-ClieD.codprov + Gn-ClieD.coddist.
      cDireccionCliente = Gn-ClieD.dircli.
      cNomRef = gn-clie.nomcli.
   END. 
   IF gre_header.m_llevar_traer_mercaderia:VISIBLE THEN DO:
       IF TRIM(gre_header.m_llevar_traer_mercaderia:SCREEN-VALUE) = "0" THEN DO:
           MESSAGE "Por favor elija si es LLEVAR o TRAER mercaderia" VIEW-AS ALERT-BOX INFORMATION.
           APPLY "ENTRY" TO gre_header.m_llevar_traer_mercaderia.
           RETURN "ADM-ERROR".
       END.
   END.
   /* ---- */
   FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
                 AND  Almacen.CodAlm = gre_header.m_codalm:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Almacen THEN DO:
      MESSAGE "Almacen destino de origen" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO gre_header.m_codalm.
      RETURN "ADM-ERROR".
   END.
 /* 11Jun2022, pedido de Susana Leon */
   IF almacen.campo-c[9] = "I" THEN DO:
       MESSAGE "Almacen de origen NO ESTA ACTIVO" VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
   END.
   cDivisionOrigen = almacen.coddiv.

   IF gre_header.m_codalmdes:VISIBLE THEN DO:
      FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
                    AND  Almacen.CodAlm = gre_header.m_codalmdes:SCREEN-VALUE 
                   NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almacen THEN DO:
         MESSAGE "Almacen destino no existe" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO gre_header.m_codalmdes.
         RETURN "ADM-ERROR".
      END.
    /* 11Jun2022, pedido de Susana Leon */
      IF almacen.campo-c[9] = "I" THEN DO:
          MESSAGE "Almacen destino NO ESTA ACTIVO" VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO gre_header.m_codalmdes.
           RETURN "ADM-ERROR".
      END.

      cDivisionDestino = almacen.coddiv.
      IF cNomRef = "" THEN cNomRef = almacen.descripcion.

      IF gre_header.m_codalmdes:SCREEN-VALUE = gre_header.m_codalm:SCREEN-VALUE THEN DO:
         MESSAGE "Almacen no puede transferirse a si mismo" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO gre_header.m_codalmdes.
         RETURN "ADM-ERROR".   
      END.

      IF Almtdocm.codmov = 03 THEN DO:
           IF Almacen.Campo-C[1] = "XD" THEN DO:
              MESSAGE "Almacén Destino NO puede ser de Cross Docking" VIEW-AS ALERT-BOX ERROR.
              APPLY "ENTRY" TO gre_header.m_codalmdes.
              RETURN "ADM-ERROR".   
           END.
      END.
      /* - */
      IF cDivisionOrigen = cDivisionDestino THEN DO:
          MESSAGE "Imposible realizar traslados a la misma division de despacho/venta" VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO gre_header.m_codalmdes.
          RETURN "ADM-ERROR".   
      END.
   END.

   FOR EACH ITEM-gre WHERE ITEM-gre.Candes <> 0 NO-LOCK:
       N-ITEM = N-ITEM + 1 . /*ITEM.CanDes.*/
   END.
   IF N-ITEM = 0 THEN DO:
      MESSAGE "No existen ITEMS a generar" VIEW-AS ALERT-BOX INFORMATION.
      APPLY "ENTRY" TO gre_header.observaciones.
      RETURN "ADM-ERROR".
   END.
    /* Verifico  */
   IF Almtdocm.codmov = 03 THEN DO:
       IF gre_header.m_coddoc:SCREEN-VALUE <> 'OTR' THEN DO:
           MESSAGE "Se necesita OTR obligado" VIEW-AS ALERT-BOX INFORMATION.
           APPLY "ENTRY" TO gre_header.observaciones.
           RETURN "ADM-ERROR".
       END.
   END.
   /* Valido la OTR */
   IF gre_header.m_coddoc:SCREEN-VALUE = 'OTR' THEN DO:
        IF TRUE <> (gre_header.m_nrodoc:SCREEN-VALUE > "") THEN DO:
            MESSAGE "Se necesita numero de OTR obligado" VIEW-AS ALERT-BOX INFORMATION.
            APPLY "ENTRY" TO gre_header.observaciones.
            RETURN "ADM-ERROR".
        END.
        cSerieOtr = STRING(INTEGER(TRIM(gre_header.m_nroser:SCREEN-VALUE)),"999").
        cnumeroOtr = cSerieOtr + STRING(INTEGER(TRIM(gre_header.m_nrodoc:SCREEN-VALUE)),"999999").
        FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND x-faccpedi.coddiv = s-coddiv AND
                                    x-faccpedi.coddoc = gre_header.m_coddoc:SCREEN-VALUE AND
                                    x-faccpedi.nroped = cnumeroOtr NO-LOCK NO-ERROR.
        IF NOT AVAILABLE x-faccpedi THEN DO:
            MESSAGE "El numero de OTR no existe" VIEW-AS ALERT-BOX INFORMATION.
            APPLY "ENTRY" TO gre_header.observaciones.
            RETURN "ADM-ERROR".
        END.
        IF x-faccpedi.flgest = 'A' THEN DO:
            MESSAGE "La OTR esta anulada" VIEW-AS ALERT-BOX INFORMATION.
            APPLY "ENTRY" TO gre_header.observaciones.
            RETURN "ADM-ERROR".
        END.
        IF NOT (x-faccpedi.flgest = 'P' AND x-faccpedi.flgsit = 'C') THEN DO:
            MESSAGE "La OTR ya no esta pendiente" VIEW-AS ALERT-BOX INFORMATION.
            APPLY "ENTRY" TO gre_header.observaciones.
            RETURN "ADM-ERROR".
        END.
   END.

  /* CONTROL DE ITEMS SOLO SI S-NROSER <> 000 */  
  IF s-NroSer <> 000 THEN DO:
    FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
    IF N-ITEM >  FacCfgGn.Items_Guias THEN DO:
        MESSAGE "Numero de Items Mayor al Configurado para el Tipo de Documento " 
            SKIP "Items Por Guia : " +  STRING(FacCfgGn.Items_Guias,"999") 
            VIEW-AS ALERT-BOX INFORMATION.
        RETURN "ADM-ERROR".
    END. 
  END.
  
   IF gre_header.m_cco:VISIBLE THEN DO:      /* CENTRO DE COSTO */
        FIND CB-AUXI WHERE cb-auxi.codcia = 0
            AND cb-auxi.clfaux = 'CCO'
            AND cb-auxi.codaux = gre_header.m_cco:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE CB-AUXI
        THEN DO:
            MESSAGE 'Centro de costo no registrado' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gre_header.m_cco.
            RETURN 'ADM-ERROR'.
        END.
   END.
   /* RHC 15.06.06 */
   IF Almtdocm.codmov = 13 AND gre_header.m_nroref2:SCREEN-VALUE = '' THEN DO:
        MESSAGE 'Ingrese la referencia' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO gre_header.m_nroref2.
        RETURN 'ADM-ERROR'.
   END.

   /* Extorno devolucion de mercaderia de clientes (I09) */
   /*IF S-TPOMOV = 'S' AND INTEGER(C-CODMOV) = 30 THEN DO:*/
   IF Almtdocm.CodMov = 30 AND Almtdocm.TipMov = "S" THEN DO:
       DEFIN VAR x-nro-nd AS CHAR.
       
       x-nro-nd = gre_header.m_nroref2:SCREEN-VALUE.

       FIND FIRST x-almcmov WHERE x-almcmov.codcia = s-codcia AND
                               x-almcmov.codalm = s-codalm AND
                               x-almcmov.tipmov = 'I' AND
                               x-almcmov.codmov = 09 AND
                               x-almcmov.nroser = gre_header.m_serie_pi AND
                               x-almcmov.nrodoc = gre_header.m_numero_pi AND
                               x-almcmov.flgest <> 'A' NO-LOCK NO-ERROR.
       IF NOT AVAILABLE x-almcmov THEN DO:
           MESSAGE 'No existe el parte de ingreso como devolucion de mercaderia del cliente' VIEW-AS ALERT-BOX ERROR.
           APPLY 'ENTRY':U TO gre_header.m_numero_pi.
           RETURN 'ADM-ERROR'.
       END.
        
       FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                                    x-ccbcdocu.coddoc = 'N/D' AND
                                    x-ccbcdocu.nrodoc = x-nro-nd AND
                                    x-ccbcdocu.flgest <> 'A' NO-LOCK NO-ERROR.
       IF NOT AVAILABLE x-ccbcdocu THEN DO:
           MESSAGE 'La N/D no existe' VIEW-AS ALERT-BOX ERROR.
           /*  Max Ramos */           
           APPLY 'ENTRY':U TO gre_header.m_nroref2.
           RETURN 'ADM-ERROR'.           
       END.
       IF x-almcmov.codref <> x-ccbcdocu.codref THEN DO:
           MESSAGE 'El tipo documento de referencia' SKIP
                'no es igual en el Parte de Ingreso y la Nota de debito' VIEW-AS ALERT-BOX ERROR.
           APPLY 'ENTRY':U TO gre_header.m_serie_pi.
           RETURN 'ADM-ERROR'.
       END.
       IF x-almcmov.nroref <> x-ccbcdocu.nroref THEN DO:
           MESSAGE 'El numero documento de referencia' SKIP
                'no es igual en el Parte de Ingreso y la Nota de debito'
                VIEW-AS ALERT-BOX ERROR.
           APPLY 'ENTRY':U TO gre_header.m_numero_pi.
           RETURN 'ADM-ERROR'.
       END.        

       /* Parte de Ingreso (PI) */
       cParteDeIngreso = "SI".
   END.

   DEFINE VAR x-es-trans-interna AS LOG INIT NO.
   DEFINE VAR x-es-diferente-division AS LOG INIT NO.
   DEFINE VAR I-NRO AS INT.

   IF Almtdocm.CodMov = 03 THEN DO:    
       IF Almacen.CodDiv <> s-CodDiv THEN DO:
           x-es-diferente-division = YES.
    
           FIND TabGener WHERE TabGener.CodCia = s-CodCia AND 
               TabGener.Clave = 'CFGINC' AND 
               TabGener.Codigo = s-CodDiv
               NO-LOCK NO-ERROR.
           IF AVAILABLE TabGener AND TabGener.Libre_l02 = YES THEN DO:
               /* Salidas por transferencias esta bloqueada */
                x-es-trans-interna = YES.
           END.
       END.
   END.

   I-NRO = 0.
   IF gre_header.m_codalmdes:VISIBLE THEN DO:
       FOR EACH ITEM-gre WHERE ITEM-gre.CanDes > 0:
           FIND FIRST Almmmate WHERE Almmmate.codcia = s-codcia
               AND Almmmate.codalm = gre_header.m_codalmdes:SCREEN-VALUE
               AND Almmmate.codmat = ITEM-gre.CodMat
               NO-LOCK NO-ERROR.
           IF NOT AVAILABLE Almmmate THEN DO:
               MESSAGE "Artículo" ITEM-gre.codmat "no asignado en el almacén destino"
                   VIEW-AS ALERT-BOX ERROR.
               APPLY "ENTRY" TO gre_header.m_codalmdes.
               RETURN "ADM-ERROR".   
           END.
           FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia
               AND Almmmatg.codmat = ITEM-gre.CodMat NO-LOCK NO-ERROR.
           IF AVAILABLE almmmatg THEN DO:
                IF (x-es-diferente-division = YES) AND (x-es-trans-interna = YES) THEN DO:
                    IF LOOKUP(almmmatg.catconta[1], "MC,MI") > 0 THEN DO:
                        MESSAGE "Artículo" ITEM-gre.codmat " ES MERCADERIA" SKIP 
                                "la division " + s-CodDiv + " esta configurada" SKIP
                                "para que no pueda realizar transferencias"
                            VIEW-AS ALERT-BOX ERROR.
                        APPLY "ENTRY" TO gre_header.m_codalmdes.
                        RETURN "ADM-ERROR".   
                    END.
                END.
           END.
           I-NRO = I-NRO + 1.
       END.
   END.
   ELSE DO:
       /**/
       I-NRO = -1.
   END.

   IF I-NRO = 0 THEN DO:
      MESSAGE "No existen articulos a transferir" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO gre_header.observaciones.
      RETURN "ADM-ERROR".
   END.
   /* 
        GRE - validacion de establecimientos cuando se realizen transferencias
            entre almacenes de conti
    */
   FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = cDivisionOrigen NO-LOCK NO-ERROR.   
   IF NOT AVAILABLE gn-divi THEN DO:
       MESSAGE "La division (" + cDivisionOrigen + ") a la que pertenece el almacen origen "  SKIP 
            "no esta registrado" VIEW-AS ALERT-BOX INFORMATION.
       APPLY "ENTRY" TO gre_header.observaciones.
       RETURN "ADM-ERROR".
   END.
   cPuntoOrigen = gn-divi.campo-char[10].
   cUbigeoOrigen = gn-divi.campo-char[3] + gn-divi.campo-char[4] + gn-divi.campo-char[5].
   cDireccionOrigen = gn-divi.dirdiv.   

   FIND FIRST gre_movalm_mottraslado WHERE gre_movalm_mottraslado.codmov = Almtdocm.CodMov NO-LOCK NO-ERROR.
   IF AVAILABLE gre_movalm_mottraslado THEN DO:
       IF gre_movalm_mottraslado.codmotivotraslado = '04' THEN DO:
           FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = cDivisionDestino NO-LOCK NO-ERROR.
           IF AVAILABLE gn-divi THEN cPuntoDestino = gn-divi.campo-char[10].
           cUbigeoDestino = gn-divi.campo-char[3] + gn-divi.campo-char[4] + gn-divi.campo-char[5].
           cDireccionDestino = gn-divi.dirdiv.

           IF TRUE <> (cPuntoOrigen > "") THEN DO:
               MESSAGE "El almacen de Origen cuya division es " + cDivisionOrigen SKIP 
                    "no tiene configurado el codigo de establecimiento" VIEW-AS ALERT-BOX INFORMATION.
               APPLY "ENTRY" TO gre_header.observaciones.
               RETURN "ADM-ERROR".
           END.
           IF TRUE <> (cPuntoDestino > "") THEN DO:
               MESSAGE "El almacen de Destino cuya division es " + cDivisionDestino 
                    "no tiene configurado el codigo de establecimiento" VIEW-AS ALERT-BOX INFORMATION.
               APPLY "ENTRY" TO gre_header.observaciones.
               RETURN "ADM-ERROR".
           END.               
           /* Divisiones */
       END.
   END.

   IF DEC(gre_header.numeroBultos:SCREEN-VALUE) <= 0 THEN DO:
       MESSAGE "Cantidad de BULTOS errado" VIEW-AS ALERT-BOX INFORMATION.
       APPLY "ENTRY" TO gre_header.numeroBultos.
       RETURN "ADM-ERROR".
   END.

   /* Validaciones personalizados */
   RUN otras-validaciones(OUTPUT cMsgRet).
   IF RETURN-VALUE = "ADM-ERROR" THEN DO:
       MESSAGE cMsgRet VIEW-AS ALERT-BOX INFORMATION.
       APPLY "ENTRY" TO gre_header.numeroBultos.
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

MESSAGE 'Imposible modificar la Pre-Guia' VIEW-AS ALERT-BOX ERROR.
RETURN 'ADM-ERROR'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

