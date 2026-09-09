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
DEFINE TEMP-TABLE ITEM-1 NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE ITEM-2 NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE ITEM-LE LIKE FacDPedi.
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
/*&SCOPED-DEFINE precio-venta-general vtagn/precio-venta-general-v01.p*/
&SCOPED-DEFINE precio-venta-general vta2/PrecioMayorista-Cred-v2

/* Local Variable Definitions ---                                       */
DEF VAR x-articulo-ICBPer AS CHAR INIT '099268'.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-nroser AS INT.
DEF SHARED VAR s-codmon AS INT.
DEF SHARED VAR s-CodCli AS CHAR.
DEF SHARED VAR s-porigv AS DEC.
DEF SHARED VAR s-fmapgo AS CHAR.
DEF SHARED VAR s-tpocmb AS DEC.
DEF SHARED VAR s-codven AS CHAR.
DEF SHARED VAR lh_Handle AS HANDLE.
DEF SHARED VAR s-nrodec AS INT.
DEF SHARED VAR s-tpoped AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-flgigv AS LOG.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-DiasVtoPed     LIKE GN-DIVI.DiasVtoPed.

DEF SHARED VAR s-import-ibc AS LOG.
DEF SHARED VAR s-import-cissac AS LOG.
DEF SHARED VAR s-import-b2b AS LOG.

DEF SHARED VAR s-adm-new-record AS CHAR.
DEF SHARED VARIABLE S-NROPED AS CHAR.
DEF SHARED VAR pCodDiv  AS CHAR.        /* DIVISION DE LA LISTA DE PRECIOS */
DEF SHARED VAR S-CMPBNTE  AS CHAR.
DEF SHARED VAR S-CODTER   AS CHAR.
DEF SHARED VAR S-TPOMARCO AS CHAR.      /* CASO DE CLIENTES EXCEPCIONALES */

/* Parámetros de la División */
DEF SHARED VAR s-DiasVtoCot LIKE GN-DIVI.DiasVtoCot.
DEF SHARED VAR s-MinimoPesoDia AS DEC.
DEF SHARED VAR s-MaximaVarPeso AS DEC.
DEF SHARED VAR s-MinimoDiasDespacho AS DEC.
DEF SHARED VAR s-ClientesVIP AS LOG.

/*DEFINE SHARED VARIABLE s-ListaTerceros AS INT.*/

DEF SHARED TEMP-TABLE T-DPEDI LIKE FacDPedi.

DEF VAR s-copia-registro AS LOG.
DEF VAR s-cndvta-validos AS CHAR.
DEF VAR F-Observa        AS CHAR.
DEFINE VARIABLE s-pendiente-ibc AS LOG.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE VAR x-ClientesVarios AS CHAR.
x-ClientesVarios = FacCfgGn.CliVar.     /* 11 digitos */

/* Variables para los mensajes de error */
DEF VAR pMensaje AS CHAR NO-UNDO.

/* 03Oct2014 - Plaza Vea cambio B2B*/
DEF TEMP-TABLE tt-OrdenesPlazVea
    FIELD tt-nroorden AS CHAR FORMAT 'x(15)'
    FIELD tt-codclie AS CHAR FORMAT 'x(11)'
    FIELD tt-locentrega AS CHAR FORMAT 'x(8)'.

DEFINE VAR lOrdenGrabada AS CHAR.
DEFINE VAR pFechaEntrega AS DATE.

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

DEFINE VAR p-lfilexls AS CHAR INIT "".
DEFINE VAR p-lFileXlsProcesado AS CHAR INIT "".
DEFINE VARIABLE cCOTDesde AS CHAR INIT "".
DEFINE VARIABLE cCOTHasta AS CHAR INIT "".

/* B2Bv2 */
DEFINE TEMP-TABLE OrdenCompra-tienda
    FIELDS nro-oc   AS CHAR
    FIELDS clocal-destino AS CHAR
    FIELDS dlocal-Destino AS CHAR
    FIELDS clocal-entrega AS CHAR
    FIELDS dlocal-entrega AS CHAR
    FIELDS fecha-entrega  AS DATE
    FIELDS CodClie AS CHAR

    INDEX llave01 AS PRIMARY nro-oc clocal-destino.

/* Ic - 10Feb2016, Metodo de Pago - Lista Express */
DEFINE TEMP-TABLE tt-MetodPagoListaExpress
    FIELDS tt-cotizacion AS CHAR
    FIELDS tt-pedidoweb AS CHAR
    FIELDS tt-metodopago AS CHAR
    FIELDS tt-tipopago AS CHAR
    FIELDS tt-nombreclie AS CHAR
    FIELDS tt-preciopagado AS DEC
    FIELDS tt-preciounitario AS DEC
    FIELDS tt-costoenvio AS DEC
    FIELDS tt-descuento AS DEC.

DEFINE SHARED VAR s-nivel-acceso AS INT NO-UNDO.
/* 1: NO ha pasado por ABASTECIMIENTOS => Puede modificar todo (Por Defecto) */
/* 0: YA pasó por abastecimientos => Puede disminuir las cantidades mas no incrementarlas */

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
&Scoped-Define ENABLED-FIELDS FacCPedi.FchEnt FacCPedi.CodCli ~
FacCPedi.FaxCli FacCPedi.RucCli FacCPedi.Atencion FacCPedi.Cmpbnte ~
FacCPedi.NomCli FacCPedi.CodVen FacCPedi.FmaPgo FacCPedi.Glosa ~
FacCPedi.LugEnt 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.Libre_c01 ~
FacCPedi.FchEnt FacCPedi.usuario FacCPedi.CodCli FacCPedi.FaxCli ~
FacCPedi.RucCli FacCPedi.Atencion FacCPedi.Cmpbnte FacCPedi.NomCli ~
FacCPedi.CodVen FacCPedi.FmaPgo FacCPedi.Glosa FacCPedi.LugEnt 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS F-Estado FILL-IN-cmpbnte 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fComision V-table-Win 
FUNCTION fComision RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "ESTADO" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-cmpbnte AS CHARACTER FORMAT "X(15)":U INITIAL "Comprobante" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.NroPed AT ROW 1 COL 9 COLON-ALIGNED WIDGET-ID 58
          LABEL "Número" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     F-Estado AT ROW 1 COL 29 COLON-ALIGNED WIDGET-ID 114
     FacCPedi.Libre_c01 AT ROW 1 COL 60 COLON-ALIGNED WIDGET-ID 126
          LABEL "Lista Precios" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 14 FGCOLOR 0 
     FacCPedi.FchEnt AT ROW 1 COL 106 COLON-ALIGNED WIDGET-ID 130
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.usuario AT ROW 1.77 COL 106 COLON-ALIGNED WIDGET-ID 66
          LABEL "Digitado por"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.CodCli AT ROW 1.81 COL 9 COLON-ALIGNED WIDGET-ID 38
          LABEL "Cliente"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.FaxCli AT ROW 1.81 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 124 FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
          FONT 6
     FacCPedi.RucCli AT ROW 2.62 COL 9 COLON-ALIGNED WIDGET-ID 60
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.Atencion AT ROW 2.62 COL 29 COLON-ALIGNED WIDGET-ID 88
          LABEL "DNI" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FILL-IN-cmpbnte AT ROW 2.62 COL 96 COLON-ALIGNED NO-LABEL WIDGET-ID 156
     FacCPedi.Cmpbnte AT ROW 2.62 COL 108.43 NO-LABEL WIDGET-ID 102
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "FAC", "FAC":U,
"BOL", "BOL":U
          SIZE 15 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.NomCli AT ROW 3.42 COL 9 COLON-ALIGNED WIDGET-ID 54 FORMAT "x(256)"
          VIEW-AS FILL-IN 
          SIZE 69 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.CodVen AT ROW 3.42 COL 106 COLON-ALIGNED WIDGET-ID 42
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.FmaPgo AT ROW 4.19 COL 106 COLON-ALIGNED WIDGET-ID 50
          LABEL "Condición de Venta"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.Glosa AT ROW 4.23 COL 9 COLON-ALIGNED WIDGET-ID 110
          LABEL "Glosa" FORMAT "X(256)"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.LugEnt AT ROW 5.04 COL 9 COLON-ALIGNED WIDGET-ID 112
          LABEL "Entregar en" FORMAT "x(256)"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
          BGCOLOR 11 FGCOLOR 0 
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
      TABLE: ITEM-1 T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: ITEM-2 T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: ITEM-LE T "?" ? INTEGRAL FacDPedi
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
         HEIGHT             = 5.08
         WIDTH              = 125.14.
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
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FaxCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-cmpbnte IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FmaPgo IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.Glosa IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.Libre_c01 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.LugEnt IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.NomCli IN FRAME F-Main
   EXP-FORMAT                                                           */
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
        IF SELF:SCREEN-VALUE = 'FAC' 
            AND FacCPedi.CodCli:SCREEN-VALUE <> '11111111112'
            THEN DO:
            FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                AND gn-clie.CodCli = FacCPedi.CodCli:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
            ASSIGN
                FacCPedi.NomCli:SENSITIVE = NO
                FacCPedi.Atencion:SENSITIVE = NO.
            IF AVAILABLE gn-clie THEN DO:
                ASSIGN
                    FacCPedi.NomCli:SCREEN-VALUE = GN-CLIE.NomCli
                    FacCPedi.RucCli:SCREEN-VALUE = gn-clie.Ruc.
            END.
        END.
        ELSE DO:
            ASSIGN
                FacCPedi.NomCli:SENSITIVE = YES
                FacCPedi.Atencion:SENSITIVE = YES.
            /* RHC 11/03/2019 CLIENTE CON RUC */
            IF FacCPedi.RucCli:SCREEN-VALUE > '' THEN
                ASSIGN
                    FacCPedi.NomCli:SENSITIVE = NO
                    FacCPedi.Atencion:SENSITIVE = NO.
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

  IF s-ClientesVIP = YES THEN DO:
      RUN vtagn/p-clie-expo (SELF:SCREEN-VALUE, s-TpoPed, pCodDiv).
      IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  END.

  RUN vtagn/p-gn-clie-01 (SELF:SCREEN-VALUE, s-CodDoc).
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  s-CodCli = SELF:SCREEN-VALUE.

  /* Cargamos las condiciones de venta válidas */
  FIND gn-clie WHERE gn-clie.codcia  = cl-codcia
      AND gn-clie.codcli = s-codcli
      NO-LOCK.
  RUN vtagn/p-condicion-venta-valido (s-codcli, s-tpoped, OUTPUT s-cndvta-validos).
  IF FacCPedi.FmaPgo:SCREEN-VALUE = "" THEN s-FmaPgo = ENTRY(1, s-cndvta-validos).
  ELSE s-FmaPgo = FacCPedi.FmaPgo:SCREEN-VALUE.
  /* ****************************************** */
  DISPLAY 
      gn-clie.NomCli @ Faccpedi.NomCli
      gn-clie.Ruc    @ Faccpedi.RucCli      
      s-FmaPgo @ FacCPedi.FmaPgo      
      gn-clie.CodVen WHEN Faccpedi.CodVen:SCREEN-VALUE = '' @ Faccpedi.CodVen 
      WITH FRAME {&FRAME-NAME}.


/*   IF FacCPedi.FmaPgo:SCREEN-VALUE = '900'                                              */
/*     AND FacCPedi.Glosa:SCREEN-VALUE = ''                                               */
/*   THEN FacCPedi.Glosa:SCREEN-VALUE = 'BONIFICACION DE CAMPAÑA POR COMPRA POR VOLUMEN'. */

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
        input-var-3 = ''
        output-var-1 = ?
        output-var-2 = ''
        output-var-3 = ''.
    IF s-TpoPed = "M" THEN input-var-1 = "006".
    IF s-ClientesVIP = YES THEN DO:
        input-var-1 = pCodDiv.
        /*RUN lkup/c-clie-expo ('Clientes Expolibreria').*/
        RUN vtagn/d-clientes-vip ('Clientes Expolibreria').
    END.
    ELSE DO:
        RUN vtagn/c-gn-clie-01 ('Clientes').
    END.
    IF output-var-1 <> ? THEN FacCPedi.CodCli:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodVen V-table-Win
ON LEAVE OF FacCPedi.CodVen IN FRAME F-Main /* Vendedor */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
    AND  gn-ven.CodVen = FacCPedi.CodVen:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-ven THEN DO:
      MESSAGE "Vendedor NO válido" VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = "".
      RETURN NO-APPLY.
  END.
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


&Scoped-define SELF-NAME FacCPedi.FchEnt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FchEnt V-table-Win
ON LEAVE OF FacCPedi.FchEnt IN FRAME F-Main /* Fecha Entrega */
DO:
    IF INPUT {&self-name} < ( TODAY + s-MinimoDiasDespacho) THEN DO:
        MESSAGE 'No se puede despachar antes del' ( TODAY + s-MinimoDiasDespacho)
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
            AND B-CPEDI.coddoc = s-coddoc
            AND B-CPEDI.flgest <> 'A'
            AND B-CPEDI.fchped >= TODAY
            AND B-CPEDI.fchent = INPUT {&SELF-NAME}:
            x-Cuentas = x-Cuentas + B-CPEDI.Libre_d02.
        END.            
        IF x-Cuentas > x-Tope THEN DO:
            MESSAGE 'Ya se cubrieron los despachos para ese día' 
                VIEW-AS ALERT-BOX WARNING.
            RETURN NO-APPLY.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FmaPgo V-table-Win
ON LEAVE OF FacCPedi.FmaPgo IN FRAME F-Main /* Condición de Venta */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND gn-convt WHERE gn-convt.Codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-convt THEN DO:
        MESSAGE 'Condición de venta NO válida' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    /* Filtrado de las condiciones de venta */
    IF LOOKUP(SELF:SCREEN-VALUE, s-cndvta-validos) = 0 THEN DO:
        MESSAGE 'Condición de venta NO autorizada para este cliente'
            VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    s-FmaPgo = SELF:SCREEN-VALUE.
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

  FOR EACH FacDPedi OF FacCPedi EXCLUSIVE-LOCK ON ERROR UNDO, RETURN 'ADM-ERROR' 
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
  RUN Procesa-Handle IN lh_handle ("Recalculo").

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
EMPTY TEMP-TABLE ITEM-LE.

FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.Libre_c05 <> "OF" :
    CREATE ITEM.
    BUFFER-COPY Facdpedi TO ITEM.
    IF Facdpedi.Libre_c04 = "DCAMPANA" THEN ITEM.Por_Dsctos[3] = 0.
END.
FOR EACH Facdpedi NO-LOCK WHERE Facdpedi.codcia = Faccpedi.codcia
    AND Facdpedi.coddiv = Faccpedi.coddiv
    AND Facdpedi.coddoc = "CLE"     /* Cot Lista Express */
    AND Facdpedi.nroped = Faccpedi.nroped:
    CREATE ITEM-LE.
    BUFFER-COPY Facdpedi TO ITEM-LE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierre-de-atencion V-table-Win 
PROCEDURE Cierre-de-atencion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Solo para Eventos
------------------------------------------------------------------------------*/

    IF s-TpoPed <> "E" THEN RETURN.

    /* Cierre de atención */
    FIND FIRST ExpTurno WHERE expturno.codcia = s-codcia
        AND expturno.coddiv = s-coddiv
        AND expturno.block = s-codter
        AND expturno.estado = 'P'
        AND expturno.fecha = TODAY
        AND expturno.codcli = faccpedi.codcli
        NO-LOCK NO-ERROR.
    IF AVAILABLE ExpTurno THEN DO:
        MESSAGE 'CERRAMOS la atención?' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO
            UPDATE rpta AS LOG.
        IF rpta = YES 
        THEN DO:
            FIND CURRENT ExpTurno EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            FIND B-CPEDI WHERE ROWID(B-CPEDI) = ROWID(FacCPedi) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
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
            ITEM.CanAte = 0
            ITEM.CanPick = Facdpedi.CanPed
            ITEM.CanSol = 0
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuentos-Finales-03 V-table-Win 
PROCEDURE Descuentos-Finales-03 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/descuentoxlinxsublinxsubtipo.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuentos-Finales-04 V-table-Win 
PROCEDURE Descuentos-Finales-04 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/expodtoxvolxsaldoresumido.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Excel-Trabajo V-table-Win 
PROCEDURE Genera-Excel-Trabajo :
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

F-ImpTot = FacCPedi.ImpTot.

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
x-Plantilla = x-Plantilla + "Cotizacion_de_trabajo.xlt".

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

t-Column = t-Column + 2.
/* Ic 07May2015 */
DEF VAR x-StkDisponible AS DEC NO-UNDO.
DEF VAR x-StockComprometido AS DEC NO-UNDO.

FOR EACH facdpedi OF faccpedi NO-LOCK, FIRST almmmatg OF facdpedi NO-LOCK BREAK BY FacDPedi.NroItm:
    F-ImpLin = FacDPedi.ImpLin. 
    F-PreUni = FacDPedi.ImpLin / FacDPedi.CanPed.
    /*Agrega Row*/
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + STRING(facdpedi.nroitm, '>>>9').
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + facdpedi.codmat.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.
    x-Qty = cRange.
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
    cRange = "Z" + cColumn.
    chWorkSheet:Range(cRange):Value = f-PreUni.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "G" + cColumn.
    chWorksheet:Range(cRange):NumberFormat = '###,###,##0.0000'.
    ASSIGN chWorkSheet:Range(cRange):VALUE = F-PreUni NO-ERROR.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.    
    cRange = "H" + cColumn.
    chWorksheet:Range(cRange):NumberFormat = '###,###,##0.00' .    
    chWorkSheet:Range(cRange):VALUE = F-ImpLin.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.canemp.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    FOR EACH Almmmate NO-LOCK WHERE Almmmate.codcia = facdpedi.codcia
        AND Almmmate.codmat = facdpedi.CodMat
        AND Almmmate.codalm <> '11T'
        AND Almmmate.stkact > 0,
        FIRST Almacen OF Almmmate NO-LOCK WHERE Almacen.Campo-C[9] <> "I":
        /* STOCK comprometido */
/*         RUN vta2/stock-comprometido (almmmate.CodMat, almmmate.CodAlm, OUTPUT x-StockComprometido). */
        RUN vta2/stock-comprometido-v2 (almmmate.CodMat, almmmate.CodAlm, OUTPUT x-StockComprometido).
        X-StkDisponible = almmmate.stkact - x-StockComprometido.
        IF x-StkDisponible <= 0 THEN NEXT.
        cColumn = STRING(t-Column).
        cRange = "J" + cColumn.
        chWorksheet:Range(cRange):NumberFormat = '@' .    
        chWorkSheet:Range(cRange):FONT:Bold = TRUE.
        chWorkSheet:Range(cRange):Value = Almmmate.CodAlm.
        cRange = "K" + cColumn.
        chWorksheet:Range(cRange):NumberFormat = '###,###,##0.00' .    
        chWorkSheet:Range(cRange):FONT:Bold = TRUE.
        chWorkSheet:Range(cRange):VALUE = x-StkDisponible.
        t-column = t-column + 1.
    END.
    t-column = t-column + 1.
END.
t-column = t-column + 3.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "* LOS PRECIOS INCLUYEN IGV.".

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

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
/*DEFINE VARIABLE F-ImpLin                LIKE FacDPedi.ImpLin.*/
DEFINE VARIABLE F-ImpLin                AS DEC DECIMALS 4 NO-UNDO.
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
        F-ImpLin = FacDPedi.ImpLin. 
        F-PreUni = ROUND(FacDPedi.ImpLin / FacDPedi.CanPed, INTEGER(Faccpedi.Libre_d01)).
    END.
    ELSE DO:
        IF Facdpedi.Por_Dsctos[1] = 0
            AND Facdpedi.Por_Dsctos[2] = 0
            AND Facdpedi.Por_Dsctos[3] = 0 THEN DO:
            F-PreUni = ROUND(FacDPedi.PreUni / (1 + FacCPedi.PorIgv / 100), 4).
            F-ImpLin = ROUND(FacDPedi.ImpLin / (1 + FacCPedi.PorIgv / 100), 2).
        END.
        ELSE DO:
            F-ImpLin = ROUND( ( Facdpedi.CanPed * Facdpedi.PreUni * 
                                ( 1 - Facdpedi.Por_Dsctos[1] / 100 ) *
                                ( 1 - Facdpedi.Por_Dsctos[2] / 100 ) *
                                ( 1 - Facdpedi.Por_Dsctos[3] / 100 ) ) / 
                              (1 + FacCPedi.PorIgv / 100), 4).
            F-PreUni = ROUND(F-ImpLin / FacDPedi.CanPed, 4).
            F-ImpLin = ROUND(F-ImpLin,2). 
        END.
    END.  

    /*Agrega Row*/
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):EntireRow:INSERT.
    
    /*t-column = t-column + 1.*/
    p = p + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + STRING(facdpedi.nroitm, '>>>>>>9').
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generar-Pedido V-table-Win 
PROCEDURE Generar-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Consistencia */
IF NOT AVAILABLE Faccpedi THEN RETURN.
IF Faccpedi.FlgEst <> "P" THEN RETURN.
/* chequeamos cotización */
IF Faccpedi.FchVen < TODAY THEN DO:
    FIND FIRST B-DPEDI OF Faccpedi WHERE B-DPEDI.CanAte > 0 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-DPEDI THEN DO:
        MESSAGE 'Cotización vencida al' Faccpedi.FchVen VIEW-AS ALERT-BOX INFORMATION.
        RETURN.
    END.
END.

RUN vta2/dpedidotablet (INPUT Faccpedi.coddoc, INPUT Faccpedi.nroped).
RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importar-excel-2015 V-table-Win 
PROCEDURE importar-excel-2015 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE FILL-IN-Archivo AS CHAR NO-UNDO.
DEFINE VARIABLE OKpressed AS LOG NO-UNDO.
DEFINE VARIABLE pMensaje AS CHAR NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.
DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
DEFINE VARIABLE t-Row           AS INTEGER INIT 1.
DEFINE VARIABLE k               AS INTEGER NO-UNDO.
DEFINE VARIABLE j               AS INTEGER NO-UNDO.
DEFINE VARIABLE I-NroItm        AS INTEGER NO-UNDO.

SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
    FILTERS "Archivos Excel (*.xls,*.xlsx,*.xlsm)" "*.xls,*.xlsx,*.xlsm", "Todos (*.*)" "*.*"
    TITLE "IMPORTAR EXCEL DE PEDIDOS"
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.

DEF VAR x-canped AS DEC NO-UNDO.
DEF VAR x-CodMat AS CHAR NO-UNDO.
DEFINE VARIABLE lFileXlsUsado            AS CHAR.

DEFINE VARIABLE lFileXls                 AS CHAR.
DEFINE VARIABLE lNuevoFile               AS LOG.

lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = NO.        /* YES : Si va crear un nuevo archivo o abrir */

lFileXls = FILL-IN-Archivo.

{lib\excel-open-file.i}
chExcelApplication:Visible = FALSE.

lMensajeAlTerminar = NO. /*  */
lCerrarAlTerminar = YES.        /* Si permanece abierto el Excel luego de concluir el proceso */

/*chWorkSheet = chExcelApplication:Sheets:Item(6).*/
chWorkSheet = chExcelApplication:Sheets("NotaPedido").

SESSION:SET-WAIT-STATE('GENERAL').
pMensaje = ''.

/* NO borramos si hay algo ya digitado */
/*EMPTY TEMP-TABLE ITEM.*/
EMPTY TEMP-TABLE ITEM-1.

I-NroItm = 1.
FOR EACH ITEM NO-LOCK:
    i-NroItm = i-NroItm + 1.
END.
REPEAT iColumn = 9 TO 65000:
    cColumn = STRING(iColumn).
    cRange = "D" + cColumn.
    cValue = chWorkSheet:Range(cRange):Value.
    IF cValue = "" OR cValue = ? THEN LEAVE.
    x-CodMat = cValue.

    cRange = "H" + cColumn.
    cValue = trim(chWorkSheet:Range(cRange):Value).
    x-canped = DEC(cValue).

    IF x-CodMat = "" OR x-CodMat = ? OR x-canped = 0 OR x-canped = ? THEN NEXT.
    
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = x-codmat NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN NEXT.

    CREATE ITEM-1.
    ASSIGN
        ITEM-1.nroitm = I-NroItm
        ITEM-1.codcia = s-codcia
        ITEM-1.codmat = x-codmat
        ITEM-1.canped = x-canped.

    I-NroItm = I-NroItm + 1.
END.
{lib\excel-close-file.i}

FOR EACH ITEM-1 BY ITEM-1.NroItm:
    FIND FIRST ITEM WHERE ITEM.codmat = ITEM-1.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE ITEM THEN NEXT.
    CREATE ITEM.
    BUFFER-COPY ITEM-1 TO ITEM.
END.

IF pMensaje <> "" THEN DO:
    MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
END.

/*RUN Recalcular-Precios.*/
RUN Procesa-Handle IN lh_handle ( "Recalculo" ).

/* Renombramos el Excel usado  */
lFileXlsUsado =  STRING(NOW,'99-99-9999 hh:mm:ss').
lFileXlsUsado = replace(lFileXlsUsado,":","").
lFileXlsUsado = replace(lFileXlsUsado," ","").
lFileXlsUsado = replace(lFileXlsUsado,"-","").

lFileXlsUsado = TRIM(lFileXls) + "." + lFileXlsUsado.

p-lfilexls = lFileXls.
p-lFileXlsProcesado = lFileXlsUsado.

SESSION:SET-WAIT-STATE('').

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

RUN Procesa-Handle IN lh_Handle ('Pagina1').
RUN valida-update.
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN.
/* RECALCULAMOS LOS ITEMS ANTES */
EMPTY TEMP-TABLE ITEM-2.
FOR EACH ITEM:
    CREATE ITEM-2.
    BUFFER-COPY ITEM TO ITEM-2.
END.
RUN Procesa-Handle IN lh_handle ("Recalculo").

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
IF s-TpoPed = "M" THEN DO:
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
s-FmaPgo = cValue.
/* Debe estar permitida para este cliente */
RUN vta2/p-fmapgo (s-codcli, s-tpoped, OUTPUT s-cndvta-validos).
IF LOOKUP(s-FmaPgo, s-cndvta-validos) = 0 THEN DO:
    MESSAGE 'Condición de Venta:' s-FmaPgo 'NO válida para el cliente' gn-clie.codcli gn-clie.nomcli
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Excel-Pedidos V-table-Win 
PROCEDURE Importar-Excel-Pedidos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE FILL-IN-Archivo AS CHAR NO-UNDO.
DEFINE VARIABLE OKpressed AS LOG NO-UNDO.
DEFINE VARIABLE pMensaje AS CHAR NO-UNDO.

DEFINE VARIABLE chExcelApplication  AS COM-HANDLE.
DEFINE VARIABLE chWorkbook          AS COM-HANDLE.
DEFINE VARIABLE chWorksheet         AS COM-HANDLE.
DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.
DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
DEFINE VARIABLE t-Row           AS INTEGER INIT 1.
DEFINE VARIABLE k               AS INTEGER NO-UNDO.
DEFINE VARIABLE j               AS INTEGER NO-UNDO.
DEFINE VARIABLE I-NroItm        AS INTEGER NO-UNDO.

SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
    FILTERS "Archivos Excel (*.xls,*.xlsx)" "*.xls,*.xlsx", "Todos (*.*)" "*.*"
    TITLE "IMPORTAR EXCEL DE PEDIDOS"
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.

/* CREAMOS LA HOJA EXCEL */
CREATE "Excel.Application" chExcelApplication.
chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-Archivo).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).    /* HOJA 1 */

SESSION:SET-WAIT-STATE('GENERAL').
pMensaje = ''.
EMPTY TEMP-TABLE ITEM.
EMPTY TEMP-TABLE ITEM-1.

/* CHEQUEAMOS LA INTEGRIDAD DEL ARCHIVO EXCEL */
ASSIGN
    t-Column = 0
    t-Row = 1.     /* Saltamos 1ra linea */
cValue = chWorkSheet:Cells(1,1):VALUE.
/*     IF cValue = "" OR cValue = ? THEN DO:                                   */
/*         MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR. */
/*         RETURN.                                                             */
/*     END.                                                                    */

/* *************************************************************************** */
/* ************************ PRIMERA HOJA LINEA 010 *************************** */
/* *************************************************************************** */
DEF VAR x-canped AS DEC NO-UNDO.
DEF VAR x-CodMat AS CHAR NO-UNDO.
   

ASSIGN
    I-NroItm = 1
    pMensaje = ""
    t-Column = 0
    t-Row = 4.     /* Saltamos el encabezado de los campos */
DO j = 1 TO 3:      /* HOJAS */
    chWorkSheet = chExcelApplication:Sheets:ITEM(j).    /* HOJA */
    DO t-Row = 8 TO 410:    /* FILAS */
        DO t-column = 5 TO 12:   /* COLUMNAS */
            ASSIGN
                x-canped = DECIMAL(chWorkSheet:Cells(t-Row, t-Column):VALUE)
                x-CodMat = STRING(INTEGER(chWorkSheet:Cells(t-Row, t-Column + 8):VALUE), '999999')
                NO-ERROR.
            IF ERROR-STATUS:ERROR THEN NEXT.
            IF x-CodMat = "" OR x-CodMat = ? OR x-canped = 0 OR x-canped = ? THEN NEXT.
            FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
                AND Almmmatg.codmat = x-codmat NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almmmatg THEN NEXT.
    
            CREATE ITEM-1.
            ASSIGN
                ITEM-1.nroitm = I-NroItm + ( (t-Column - 5) * 100000 )
                ITEM-1.codcia = s-codcia
                ITEM-1.codmat = x-codmat
                ITEM-1.canped = x-canped.
        END.
        I-NroItm = I-NroItm + 1.
    END.
END.
i-NroItm = 1.
FOR EACH ITEM-1 BY ITEM-1.NroItm:
    CREATE ITEM.
    BUFFER-COPY ITEM-1 TO ITEM ASSIGN ITEM.NroItm = i-NroItm.
    i-NroItm = i-NroItm + 1.
END.
/*
DO j = 1 TO 3:      /* HOJAS */
    chWorkSheet = chExcelApplication:Sheets:ITEM(j).    /* HOJA */
    DO t-Row = 8 TO 410:    /* FILAS */
        DO t-column = 5 TO 12:   /* COLUMNAS */
            ASSIGN
                x-canped = DECIMAL(chWorkSheet:Cells(t-Row, t-Column):VALUE)
                x-CodMat = STRING(INTEGER(chWorkSheet:Cells(t-Row, t-Column + 8):VALUE), '999999')
                NO-ERROR.
            IF ERROR-STATUS:ERROR THEN NEXT.
            IF x-CodMat = "" OR x-CodMat = ? OR x-canped = 0 OR x-canped = ? THEN NEXT.
            FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
                AND Almmmatg.codmat = x-codmat NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almmmatg THEN NEXT.
    
            CREATE ITEM.
            ASSIGN
                ITEM.nroitm = I-NroItm
                ITEM.codcia = s-codcia
                ITEM.codmat = x-codmat
                ITEM.canped = x-canped.
            I-NroItm = I-NroItm + 1.
        END.
    END.
END.

*/
/* CERRAMOS EL EXCEL */
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 
SESSION:SET-WAIT-STATE('').

/* EN CASO DE ERROR */
IF pMensaje <> "" THEN DO:
    MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    /*EMPTY TEMP-TABLE ITEM.*/
END.
RUN Procesa-Handle IN lh_handle ('Recalculo').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importar-listaexpress-2016 V-table-Win 
PROCEDURE importar-listaexpress-2016 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE BUFFER b-FacCorre FOR FacCorre.                                
                                
FIND b-FacCorre WHERE b-FacCorre.CodCia = S-CODCIA 
  AND b-FacCorre.CodDoc = S-CODDOC 
  AND b-FacCorre.NroSer = s-NroSer
  NO-LOCK NO-ERROR.
IF b-FacCorre.FlgEst = NO THEN DO:
  RELEASE b-FacCorre.
  MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
  RETURN 'ADM-ERROR'.
END.

RELEASE b-FacCorre.

DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-Linea   AS CHAR FORMAT 'x(200)' NO-UNDO.
DEF VAR x-CodMat LIKE ITEM.codmat NO-UNDO.
DEF VAR x-CanPed LIKE ITEM.canped NO-UNDO.
DEF VAR x-ImpLin LIKE ITEM.implin NO-UNDO.
DEF VAR x-ImpIgv LIKE ITEM.impigv NO-UNDO.
DEF VAR x-Encabezado AS LOG INIT FALSE.
DEF VAR x-Detalle    AS LOG INIT FALSE.
DEF VAR x-NroItm AS INT INIT 0.
DEF VAR lPos AS INT INIT 0.
DEF VAR x-Ok AS LOG.
DEF VAR x-Item AS CHAR NO-UNDO.

DEFINE VAR x-precio AS DEC.
DEFINE VAR x-precio-sin-igv AS DEC.
DEFINE VAR x-Cargo-Orden AS LOG.
DEFINE VAR x-ordenes-x-cargar AS INT.
  
DEFINE VARIABLE cSede   AS CHAR NO-UNDO.
DEFINE VARIABLE cCodCli AS CHAR NO-UNDO.
/* B2Bv2 */
DEFINE VARIABLE cNro-oc AS CHAR .
DEFINE VARIABLE clocal AS CHAR.
DEFINE VARIABLE cMsgFinal AS CHAR.
DEFINE VARIABLE cDesWeb AS CHAR.
DEFINE VARIABLE cDescripcionLarga AS CHAR.
DEFINE VARIABLE cCodArtExtra AS CHAR.

/* Lista Express */
DEFINE VAR lxPedidoWeb AS CHAR.
DEFINE VAR lxCliente AS CHAR.
DEFINE VAR lxDNI AS CHAR.
DEFINE VAR lxRUC AS CHAR.
DEFINE VAR lxCelular AS CHAR.
DEFINE VAR lxPos AS INT.
DEFINE VAR lxDescuento AS DEC.
DEFINE VAR lxCostoEnvio AS DEC.

SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Archivo Excel (.xlsx)' '*.xls,*.xlsx'
    RETURN-TO-START-DIR
    TITLE 'Selecciona al archivo Excel'
    MUST-EXIST
    USE-FILENAME
    UPDATE x-Ok.
IF x-Ok = NO THEN RETURN "ADM-ERROR".

EMPTY TEMP-TABLE tt-OrdenesPlazVea.

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.

DEFINE VAR lOrden AS CHAR.
DEFINE VAR lCodEan AS CHAR.
DEFINE VAR iCodEan AS INT.

lFileXls = x-Archivo.           /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = NO.        /* YES : Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

chExcelApplication:Visible = FALSE.

lMensajeAlTerminar = NO. /*  */
lCerrarAlTerminar = YES.        /* Si permanece abierto el Excel luego de concluir el proceso */

EMPTY TEMP-TABLE tt-OrdenesPlazVea.
EMPTY TEMP-TABLE OrdenCompra-Tienda.
EMPTY TEMP-TABLE ITEM-LE.

/* Datos del Cliente */
chWorkSheet = chExcelApplication:Sheets:Item(2).

cRange = "C2".
lxCliente = TRIM(chWorkSheet:Range(cRange):VALUE).
cRange = "A2".
lxDNI = TRIM(chWorkSheet:Range(cRange):VALUE).
cRange = "B2".
lxRUC = TRIM(chWorkSheet:Range(cRange):VALUE).
cRange = "E2".
lxCelular = TRIM(chWorkSheet:Range(cRange):VALUE).

IF lxCliente = ? THEN lxCliente = "".
IF lxDNI = ? THEN lxDNI = "".
IF lxRUC = ? THEN lxRUC = "".
IF lxCelular = ? THEN lxCelular = "".

/* Valores como estos 12582.00000 */
IF index(lxDNI,".0") > 0 THEN DO:
    lxPos = index(lxDNI,".0").
    lxDNI = SUBSTRING(lxDNI,1,lxPos - 1).
END.
IF index(lxRUC,".0") > 0 THEN DO:
    lxPos = index(lxRUC,".0").
    lxRUC = SUBSTRING(lxRUC,1,lxPos - 1).
END.
IF index(lxCelular,".0") > 0 THEN DO:
    lxPos = index(lxCelular,".0").
    lxCelular = SUBSTRING(lxCelular,1,lxPos - 1).
END.

/* Productos del Pedido */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* Cuantas ORDENES tiene el Excel - Para ListaExpress solo una ordex x Excel */
iColumn = 1.
x-ordenes-x-cargar = 0.
DO iColumn = 2 TO 2:

    cRange = "A" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).

    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */

    /* Nro Pedido */
    cNro-oc = cValue.
    lxPedidoWeb = cNro-Oc.

    /* Ubigeo de entrega */
    cRange = "H" + TRIM(STRING(iColumn)).
    cLocal = TRIM(chWorkSheet:Range(cRange):VALUE).    

    FIND FIRST tt-OrdenesPlazVea WHERE tt-nroorden = cNro-Oc NO-ERROR.
    IF NOT AVAILABLE tt-OrdenesPlazVea THEN DO:
        /* LOS PEDIDOS */
        FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                factabla.tabla = 'PED-LISTAEXPRESS' AND 
                factabla.codigo = cNro-Oc NO-LOCK NO-ERROR.
        IF NOT AVAILABLE factabla THEN DO:            
            CREATE tt-OrdenesPlazVea.
                ASSIGN tt-OrdenesPlazVea.tt-nroorden = cNro-Oc
                        tt-OrdenesPlazVea.tt-CodClie  = '11111111111'
                        cRange = "J" + TRIM(STRING(iColumn))  /* Cliente */
                        tt-OrdenesPlazVea.tt-locentrega = TRIM(chWorkSheet:Range(cRange):VALUE).
        END.
    END.  
    /* PEDIDOS X CLIENTE */
    FIND FIRST OrdenCompra-Tienda WHERE nro-oc = cNro-oc AND
                                        clocal-destino = cLocal NO-ERROR.
    IF NOT AVAILABLE OrdenCompra-Tienda THEN DO:
        
        CREATE OrdenCompra-Tienda.
        ASSIGN  OrdenCompra-Tienda.nro-oc = cNro-oc
                OrdenCompra-Tienda.clocal-destino = cLocal
                cRange = "J" + TRIM(STRING(iColumn))  /* Nombre del Cliente */
                OrdenCompra-Tienda.dlocal-destino = TRIM(chWorkSheet:Range(cRange):VALUE)
                cRange = "H" + TRIM(STRING(iColumn)) /* Ubigeo Entrega */
                OrdenCompra-Tienda.clocal-entrega = TRIM(chWorkSheet:Range(cRange):VALUE)
                cRange = "I" + TRIM(STRING(iColumn))
                OrdenCompra-Tienda.dlocal-entrega = TRIM(chWorkSheet:Range(cRange):VALUE)                
                OrdenCompra-Tienda.CodClie = "11111111111".            
    END.

END.

/* Los Metodos de Pago */
chWorkSheet = chExcelApplication:Sheets:Item(3).

EMPTY TEMP-TABLE tt-MetodPagoListaExpress.
lxCostoEnvio = 0.
lxDescuento = 0.

DO iColumn = 2 TO 65000:

    cRange = "A" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).

    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */

    CREATE tt-MetodPagoListaExpress.
            ASSIGN tt-pedidoweb = lxPedidoWeb
                    tt-metodopago = cValue
                    cRange = "B" + TRIM(STRING(iColumn))    /* Tipo */
                    tt-tipopago = TRIM(chWorkSheet:Range(cRange):VALUE)
                    tt-nombreclie = lxCliente
                    cRange = "C" + TRIM(STRING(iColumn))    /* TOTAL */
                    tt-PrecioPagado = DEC(TRIM(chWorkSheet:Range(cRange):VALUE))
                    cRange = "D" + TRIM(STRING(iColumn))    /* SUBTOTAL */
                    tt-PrecioUnitario = DEC(TRIM(chWorkSheet:Range(cRange):VALUE))
                    cRange = "E" + TRIM(STRING(iColumn))    /* COSTO_ENVIO */
                    tt-costoenvio = DEC(TRIM(chWorkSheet:Range(cRange):VALUE)).
                    cRange = "G" + TRIM(STRING(iColumn)).   /* DESCUENTO */
                    tt-descuento = DEC(TRIM(chWorkSheet:Range(cRange):VALUE)).

    lxCostoEnvio = lxCostoEnvio + tt-MetodPagoListaExpress.tt-costoenvio.

END.


/* Productos del Pedido */
chWorkSheet = chExcelApplication:Sheets:Item(1).

x-ordenes-x-cargar = 0.
cCOTDesde = "".
cCOTHasta = "".

FOR EACH tt-OrdenesPlazVea :
    lOrden = tt-OrdenesPlazVea.tt-nroorden.
    
    FOR EACH OrdenCompra-tienda WHERE lOrden = OrdenCompra-Tienda.nro-oc :
        cCodCli = trim(OrdenCompra-Tienda.CodClie).
        cSede = OrdenCompra-Tienda.clocal-entrega.        
        lOrden = OrdenCompra-Tienda.nro-oc.

        SESSION:SET-WAIT-STATE('GENERAL').

        /* Adiciono Registro en Cabecera */
        RUN ue-add-record.

        ASSIGN FacCPedi.Glosa = TRIM(OrdenCompra-tienda.dlocal-entrega) /* + " " + 
                            TRIM(OrdenCompra-tienda.dlocal-destino)*/
                  FacCPedi.ordcmp = OrdenCompra-Tienda.nro-oc.
        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = cCodCli
            AND gn-clie.flgsit = 'A'
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            ASSIGN
                s-codcli = gn-clie.codcli
                Faccpedi.codcli = gn-clie.codcli
                FacCPedi.LugEnt = OrdenCompra-Tienda.dlocal-entrega.

            /* Del CLIENTE */
            s-CodCli = cCodCli.
            s-FmaPgo = '000'.

            ASSIGN FacCPedi.FmaPgo = s-FmaPgo
                    Faccpedi.NomCli = OrdenCompra-Tienda.dlocal-destino
                    Faccpedi.DirCli = OrdenCompra-Tienda.dlocal-entrega
                    Faccpedi.RucCli = lxRUC
                    Faccpedi.Atencion = lxDNI
                    Faccpedi.Glosa = lxCelular
                    FacCPedi.NroCard = ""
                    Faccpedi.CodVen = "021"
                    Faccpedi.FaxCli = SUBSTRING(TRIM(gn-clie.clfcli) + "00",1,2) +
                                              SUBSTRING(TRIM(gn-clie.clfcli2) + "00",1,2)
                    Faccpedi.Cmpbnte = 'BOL'.    
            DEF VAR pEstado AS LOG NO-UNDO.
            RUN sunat\p-inicio-actividades (INPUT TODAY, OUTPUT pEstado).
            IF pEstado = YES THEN DO:
                ASSIGN Faccpedi.Cmpbnte = "BOL".
                IF Faccpedi.RucCli <> "" THEN Faccpedi.Cmpbnte = "FAC".
            END.

            /* ------------------------------ */
        END.
    
        /* Leer el Detalle */
        x-NroItm = 0.
        x-Cargo-Orden = NO.
        lOrdenGrabada = "".
    
        /* El Detalle de la Orden */
        DO iColumn = 2 TO 65000:
            ASSIGN x-CodMat = ''
                x-CanPed = 0
                x-ImpLin = 0
                x-ImpIgv = 0
                x-precio = 0.
    
            /* Pedido */
            cRange = "A" + TRIM(STRING(iColumn)).
            cValue = TRIM(chWorkSheet:Range(cRange):VALUE).

            /*MESSAGE cValue.*/

            IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */

            /* Pedido */
            cNro-oc = cValue.
            /* Local destino  UIBIGEoO */
            cRange = "H" + TRIM(STRING(iColumn)).
            cLocal = TRIM(chWorkSheet:Range(cRange):VALUE).
            /*
            MESSAGE cNro-oc + "/"+ cLocal.
            MESSAGE OrdenCompra-Tienda.nro-oc + "/"+ OrdenCompra-Tienda.clocal-destino.
            */
            IF cNro-oc = OrdenCompra-Tienda.nro-oc AND
                cLocal = OrdenCompra-Tienda.clocal-destino THEN DO:
                /* Articulo de la misma Orden  */
                cRange = "C" + TRIM(STRING(iColumn)).
                lCodEan = TRIM(chWorkSheet:Range(cRange):VALUE).  

                cDesWeb = "".
                cDescripcionLarga = ''.
                cCodArtExtra = "".

                cRange = "D" + TRIM(STRING(iColumn)).
                /*cDesWeb = TRIM(chWorkSheet:Range(cRange):VALUE).  RHC */
                cDescripcionLarga = TRIM(chWorkSheet:Range(cRange):VALUE).

                lPos = INDEX(lCodEan,"_").

                IF lPos > 0 THEN DO:
                    cDesWeb = CAPS(TRIM(SUBSTRING(lCodEan,lpos + 1))).  /* RHC */
                    cCodArtExtra = TRIM(SUBSTRING(lCodEan,lpos + 1)) + " - ".
                    lCodEan = SUBSTRING(lCodEan,1,lpos - 1).
                END.
                /*cDesWeb = cCodArtExtra + cDesWeb.*/
                /* La descripción completa está en el campo: Almmmatg.Descripcion-Larga */

                iCodEan = INT(lCodEan).
                lCodEan = STRING(iCodEan,"999999").
                /*MESSAGE lCodEan.*/
    
                /* Buscar el codigo como interno */
                x-CodMat = ''.
                FIND FIRST Almmmatg WHERE almmmatg.codcia = s-codcia AND 
                            almmmatg.Codmat = lCodEan NO-LOCK NO-ERROR.
                x-CodMat = IF(AVAILABLE almmmatg) THEN almmmatg.codmat ELSE x-CodMat.

                IF x-CodMat <> ''  THEN DO:

                    /* Se ubico el Codigo Interno  */
                    FIND Almmmatg WHERE almmmatg.codcia = s-codcia
                        AND Almmmatg.codmat = x-codmat
                        AND Almmmatg.tpoart <> 'D'
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE Almmmatg THEN DO:

                        /* Cantidad pedida */
                        cRange = "E" + TRIM(STRING(iColumn)).
                        x-CanPed = chWorkSheet:Range(cRange):VALUE.
                        /* El precio final ?????????????*/
                        cRange = "F" + TRIM(STRING(iColumn)).
                        x-precio =  chWorkSheet:Range(cRange):VALUE * x-CanPed.
                        /*  */
                        x-precio-sin-igv = (x-precio * 100) / 118.
                        /**/
                        /*cRange = "G" + TRIM(STRING(iColumn)).*/
                        x-ImpLin =  x-precio /*chWorkSheet:Range(cRange):VALUE*/.
                        x-Precio = ROUND(x-ImpLin / x-CanPed, 5).
                        x-Precio-Sin-Igv = x-Precio * 100 / (1 + s-PorIgv / 100).

                        /* Verificar el IGV */
                        IF x-precio > x-precio-sin-igv THEN DO:
                            x-ImpIgv = x-ImpLin - (x-CanPed * x-precio-sin-igv).
                        END.                        
    
                        /* Items */
                        FIND FIRST ITEM WHERE ITEM.codmat = x-CodMat NO-LOCK NO-ERROR.
                        /*IF NOT AVAILABLE ITEM THEN DO:*/
    
                            x-Cargo-Orden = YES.
                            x-NroItm = x-NroItm + 1.
                            lOrdenGrabada = lOrden.
    
                            CREATE ITEM.
                            ASSIGN 
                                ITEM.CodCia = s-codcia
                                ITEM.codmat = x-CodMat
                                ITEM.libre_c05 = cDesWeb
                                ITEM.Factor = 1 
                                ITEM.CanPed = x-CanPed
                                ITEM.NroItm = x-NroItm 
                                ITEM.UndVta = (IF AVAILABLE Almmmatg THEN Almmmatg.Chr__01 ELSE '')
                                ITEM.ALMDES = S-CODALM
                                ITEM.AftIgv = Almmmatg.AftIgv   /*(IF x-ImpIgv > 0 THEN YES ELSE NO)*/
                                ITEM.ImpIgv = x-ImpIgv 
                                ITEM.ImpLin = x-ImpLin /*+ x-ImpIgv*/
                                ITEM.PreUni = x-precio. /* (ITEM.ImpLin / ITEM.CanPed) */
                            IF ITEM.AftIgv THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
                            ELSE ITEM.ImpIgv = 0.

                            /* DATOS LISTA EXPRESS */
                            ASSIGN
                                ITEM.CanPedWeb = x-CanPed
                                ITEM.CodMatWeb = x-CodMat
                                ITEM.DesMatWeb = cDescripcionLarga
                                ITEM.ImpLinWeb = x-ImpLin
                                ITEM.PreUniWeb = x-Precio.
                        /*END.*/    /* fin de grabacion del detalle */
    
                    END.
                    ELSE DO:
                        
                        MESSAGE "El Item " x-Item " Articulo (" x-codmat ") no esta registrado en el catalogo"
                                VIEW-AS ALERT-BOX ERROR.
                        
                    END.                    
                END.
                ELSE DO:
                    /*
                    MESSAGE "El Item" x-Item "Cod Ean (" lCodEan ") es inubicable"
                            VIEW-AS ALERT-BOX ERROR.
                    */
                END.
            END.            
        END.        
        /* Ic - 24Feb2016 , Flete (Costo de envio) */
        IF lxCostoEnvio > 0 THEN DO:
            /* Buscar el codigo como interno del FLETE */
            x-CodMat = '044939'.
            IF x-CodMat <> ''  THEN DO:

                /* Se ubico el Codigo Interno  */
                FIND Almmmatg WHERE almmmatg.codcia = s-codcia
                    AND Almmmatg.codmat = x-codmat
                    AND Almmmatg.tpoart <> 'D'
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Almmmatg THEN DO:
                    /* Cantidad pedida */
                    x-CanPed = lxCostoEnvio.
                    /* El precio final ?????????????*/
                    x-precio =  1 * x-CanPed.
                    /**/
                    x-ImpLin =  x-precio .
                    x-Precio = ROUND(x-ImpLin / x-CanPed, 5).
                    x-Precio-Sin-Igv = x-Precio * 100 / (1 + s-PorIgv / 100).

                    /* Verificar el IGV */
                    IF x-precio > x-precio-sin-igv THEN DO:
                        x-ImpIgv = x-ImpLin - (x-CanPed * x-precio-sin-igv).
                    END.                        

                    /* Items */
                    x-Cargo-Orden = YES.
                    x-NroItm = x-NroItm + 1.
                    lOrdenGrabada = lOrden.

                    CREATE ITEM.
                    ASSIGN 
                        ITEM.CodCia = s-codcia
                        ITEM.codmat = x-CodMat
                        ITEM.libre_c05 = "FLETE"
                        ITEM.Factor = 1 
                        ITEM.CanPed = x-CanPed
                        ITEM.NroItm = x-NroItm 
                        ITEM.UndVta = (IF AVAILABLE Almmmatg THEN Almmmatg.Chr__01 ELSE '')
                        ITEM.ALMDES = S-CODALM
                        ITEM.AftIgv = Almmmatg.AftIgv   /*(IF x-ImpIgv > 0 THEN YES ELSE NO)*/
                        ITEM.ImpIgv = x-ImpIgv 
                        ITEM.ImpLin = x-ImpLin /*+ x-ImpIgv*/
                        ITEM.PreUni = x-precio. /* (ITEM.ImpLin / ITEM.CanPed) */
                    IF ITEM.AftIgv THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
                    ELSE ITEM.ImpIgv = 0.

                    /* DATOS LISTA EXPRESS */
                    ASSIGN
                        ITEM.CanPedWeb = x-CanPed
                        ITEM.CodMatWeb = x-CodMat
                        ITEM.DesMatWeb = "FLETE"
                        ITEM.ImpLinWeb = x-ImpLin
                        ITEM.PreUniWeb = x-Precio.
                END.
            END.
        END.

        /* ----------------------------- */
        IF x-Cargo-Orden = YES THEN DO:
            x-ordenes-x-cargar = x-ordenes-x-cargar + 1.
            /* RHC 10/02/2016 Antes de procesar hacemos una copia del pedido */
            FOR EACH ITEM:
                CREATE ITEM-LE.
                BUFFER-COPY ITEM TO ITEM-LE.
            END.
            RUN ue-assign-statement.
        END.
        SESSION:SET-WAIT-STATE('').
    END.
END.

/* Cerrar el Excel  */
{lib\excel-close-file.i}

MESSAGE "Se generaron " + STRING(x-ordenes-x-cargar,">>>9") + " COTIZACION(ES)" SKIP(1)
            "Desde " + cCOTDesde + " Hasta " + cCOTHasta.

RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importar-listaexpress-iversa V-table-Win 
PROCEDURE importar-listaexpress-iversa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pEstado AS CHAR NO-UNDO.               
RUN gn/p-ecommerce ("aplic/gn/p-ecommerce-import-ped.p","", OUTPUT pEstado).
IF pEstado > '' THEN MESSAGE pEstado VIEW-AS ALERT-BOX ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importar-supermercados-B2Bv2 V-table-Win 
PROCEDURE importar-supermercados-B2Bv2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE BUFFER b-FacCorre FOR FacCorre.                                
                                
FIND b-FacCorre WHERE b-FacCorre.CodCia = S-CODCIA 
    AND b-FacCorre.CodDoc = S-CODDOC 
    AND b-FacCorre.NroSer = s-NroSer
    NO-LOCK NO-ERROR.
IF b-FacCorre.FlgEst = NO THEN DO:
    MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.

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
/* B2Bv2 */
DEFINE VARIABLE cNro-oc AS CHAR .
DEFINE VARIABLE clocal AS CHAR.
DEFINE VARIABLE cMsgFinal AS CHAR.

SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Archivo Excel (.xls)' '*.xls' , 'Archivo Excel (.xlsx)' '*.xlsx'
    RETURN-TO-START-DIR
    TITLE 'Selecciona al archivo Excel'
    MUST-EXIST
    USE-FILENAME
    UPDATE x-Ok.
IF x-Ok = NO THEN RETURN "ADM-ERROR".

EMPTY TEMP-TABLE tt-OrdenesPlazVea.

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.

DEFINE VAR lOrden AS CHAR.
DEFINE VAR lCodEan AS CHAR.

lFileXls = x-Archivo.           /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = NO.        /* YES : Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

chExcelApplication:Visible = FALSE.

lMensajeAlTerminar = NO. /*  */
lCerrarAlTerminar = YES.        /* Si permanece abierto el Excel luego de concluir el proceso */

EMPTY TEMP-TABLE tt-OrdenesPlazVea.
EMPTY TEMP-TABLE OrdenCompra-Tienda.

/* Cuantas ORDENES tiene el Excel */
iColumn = 1.
x-ordenes-x-cargar = 0.
DO iColumn = 2 TO 65000:
    cRange = "B" + TRIM(STRING(iColumn)).
    cValue = TRIM(STRING(chWorkSheet:Range(cRange):VALUE,">>>>>>>>>>>9")).

    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */

    /* O/C */
    cNro-oc = cValue.
    /* Local destino */
    cRange = "U" + TRIM(STRING(iColumn)).
    cLocal = TRIM(chWorkSheet:Range(cRange):VALUE).

    FIND FIRST tt-OrdenesPlazVea WHERE tt-nroorden = cNro-Oc NO-ERROR.
    IF NOT AVAILABLE tt-OrdenesPlazVea THEN DO:
        /* LAS ORDENES DE COMPRA */
        FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                factabla.tabla = 'OC PLAZA VEA' AND 
                factabla.codigo = cNro-Oc NO-LOCK NO-ERROR.
        IF NOT AVAILABLE factabla THEN DO:
            CREATE tt-OrdenesPlazVea.
                ASSIGN tt-OrdenesPlazVea.tt-nroorden = cNro-Oc
                        cRange = "A" + TRIM(STRING(iColumn))
                        tt-OrdenesPlazVea.tt-CodClie = TRIM(chWorkSheet:Range(cRange):VALUE)                    
                        cRange = "D" + TRIM(STRING(iColumn))
                        tt-OrdenesPlazVea.tt-locentrega = TRIM(chWorkSheet:Range(cRange):VALUE).
        END.
    END.  
    /* ORDENES DE COMPRA X LOCAL */
    FIND FIRST OrdenCompra-Tienda WHERE nro-oc = cNro-oc AND
                                        clocal-destino = cLocal NO-ERROR.
    IF NOT AVAILABLE OrdenCompra-Tienda THEN DO:
        CREATE OrdenCompra-Tienda.
        ASSIGN  OrdenCompra-Tienda.nro-oc = cNro-oc
                OrdenCompra-Tienda.clocal-destino = cLocal
                cRange = "V" + TRIM(STRING(iColumn))
                OrdenCompra-Tienda.dlocal-destino = TRIM(chWorkSheet:Range(cRange):VALUE)
                cRange = "D" + TRIM(STRING(iColumn))
                OrdenCompra-Tienda.clocal-entrega = TRIM(chWorkSheet:Range(cRange):VALUE)
                cRange = "E" + TRIM(STRING(iColumn))
                OrdenCompra-Tienda.dlocal-entrega = TRIM(chWorkSheet:Range(cRange):VALUE)
                cRange = "A" + TRIM(STRING(iColumn))
                OrdenCompra-Tienda.CodClie = TRIM(chWorkSheet:Range(cRange):VALUE).

        /* Fecha de Entrega - En el excel debe estar asi : 24-02-2017  (dd-mm-aaaa)*/
        cRange = "H" + TRIM(STRING(iColumn)).
        ASSIGN  OrdenCompra-tienda.fecha-entrega = DATE(TRIM(chWorkSheet:Range(cRange):TEXT)) NO-ERROR.
    END.

END.
/* ******************************************* */
/* RHC 15/08/2017 Control de errores del excel */
/* ******************************************* */
DO iColumn = 2 TO 65000:
    ASSIGN 
        x-CodMat = ''.
    /* Orden */
    cRange = "B" + TRIM(STRING(iColumn)).
    cValue = TRIM(STRING(chWorkSheet:Range(cRange):VALUE,">>>>>>>>>>>9")).
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */
    /* Articulo de la misma Orden  */
    cRange = "J" + TRIM(STRING(iColumn)).
    lCodEan = TRIM(chWorkSheet:Range(cRange):VALUE).                
    /* Buscar el codigo como interno */
    FIND FIRST Almmmatg WHERE almmmatg.codcia = s-codcia 
        AND almmmatg.Codmat = lCodEan NO-LOCK NO-ERROR.
    x-CodMat = IF(AVAILABLE almmmatg) THEN almmmatg.codmat ELSE x-CodMat.
    IF X-CodMat = '' THEN DO:
        /* Buscar el codigo interno primero con EAN13 */
        FIND FIRST Almmmatg WHERE almmmatg.codcia = s-codcia 
            AND almmmatg.CodBrr = lCodEan NO-LOCK NO-ERROR.
        x-CodMat = IF(AVAILABLE almmmatg) THEN almmmatg.codmat ELSE x-CodMat.
    END.
    /* si no existe com EAN13 lo busco como EAN14  */
    IF X-CodMat = '' THEN DO:
        FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia 
            AND almmmat1.barras[1] = lCodEan NO-LOCK NO-ERROR.
        x-CodMat = IF(AVAILABLE almmmat1) THEN almmmat1.barras[1] ELSE x-CodMat.
    END.
    IF X-CodMat = '' THEN DO:
        FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia 
            AND almmmat1.barras[2] = lCodEan NO-LOCK NO-ERROR.
        x-CodMat = IF(AVAILABLE almmmat1) THEN almmmat1.barras[2] ELSE x-CodMat.
    END.
    IF X-CodMat = '' THEN DO:
        FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia 
            AND almmmat1.barras[3] = lCodEan NO-LOCK NO-ERROR.
        x-CodMat = IF(AVAILABLE almmmat1) THEN almmmat1.barras[3] ELSE x-CodMat.
    END.
    IF X-CodMat = '' THEN DO:
        FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia 
            AND almmmat1.barras[4] = lCodEan NO-LOCK NO-ERROR.
        x-CodMat = IF(AVAILABLE almmmat1) THEN almmmat1.barras[4] ELSE x-CodMat.
    END.
    IF X-CodMat = '' THEN DO:
        FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND 
                            almmmat1.barras[5] = lCodEan NO-LOCK NO-ERROR.
        x-CodMat = IF(AVAILABLE almmmat1) THEN almmmat1.barras[5] ELSE x-CodMat.
    END.
    IF x-CodMat = '' THEN DO:
        MESSAGE 'ERROR línea' iColumn SKIP 'EAN' lCodEan 'NO REGISTTRADO' VIEW-AS ALERT-BOX ERROR.
        /* Cerrar el Excel  */
        {lib\excel-close-file.i}
        RETURN 'ADM-ERROR'.
    END.
    /* Se ubico el Codigo Interno  */
    FIND Almmmatg WHERE almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = x-codmat
        AND Almmmatg.tpoart <> 'D'
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        MESSAGE 'ERROR línea' iColumn SKIP 'EAN' lCodEan 'DESACTIVADO' VIEW-AS ALERT-BOX ERROR.
        /* Cerrar el Excel  */
        {lib\excel-close-file.i}
        RETURN 'ADM-ERROR'.
    END.
END.
/* ******************************************* */

x-ordenes-x-cargar = 0.
cCOTDesde = "".
cCOTHasta = "".

PRINCIPAL:
FOR EACH tt-OrdenesPlazVea :
    lOrden = tt-OrdenesPlazVea.tt-nroorden.
    FOR EACH OrdenCompra-tienda WHERE lOrden = OrdenCompra-Tienda.nro-oc :
        ASSIGN
            cCodCli = TRIM(OrdenCompra-Tienda.CodClie)
            cSede = OrdenCompra-Tienda.clocal-entrega
            lOrden = OrdenCompra-Tienda.nro-oc.
        SESSION:SET-WAIT-STATE('GENERAL').
        /* Adiciono Registro en Cabecera */
        RUN ue-add-record.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, LEAVE PRINCIPAL.

        ASSIGN s-Import-B2B = YES.  /* OJO */
    
        ASSIGN 
            FacCPedi.Glosa = TRIM(OrdenCompra-tienda.clocal-destino) + " " + 
                                TRIM(OrdenCompra-tienda.dlocal-destino)
            FacCPedi.ordcmp = OrdenCompra-Tienda.nro-oc
            FacCPedi.ubigeo[1] = TRIM(OrdenCompra-tienda.clocal-destino) + " " + 
                                TRIM(OrdenCompra-tienda.dlocal-destino).        

        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = cCodCli
            AND gn-clie.flgsit = 'A'
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            ASSIGN
                s-codcli = gn-clie.codcli.
                Faccpedi.codcli = gn-clie.codcli.
    
            FIND FIRST gn-clied OF gn-clie WHERE Gn-ClieD.sede = cSede NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clied THEN DO WITH FRAME {&FRAME-NAME}:
                ASSIGN
                    Faccpedi.sede = Gn-ClieD.Sede.
                FIND gn-clied WHERE gn-clied.codcia = cl-codcia
                    AND gn-clied.codcli = cCodCli 
                    AND gn-clied.sede = csede
                    NO-LOCK NO-ERROR.
                IF AVAILABLE gn-clied THEN 
                    ASSIGN 
                        FacCPedi.LugEnt = Gn-ClieD.DirCli.
            END.

            /* Del CLIENTE */

            s-CodCli = cCodCli.

            /* Cargamos las condiciones de venta válidas */
            FIND gn-clie WHERE gn-clie.codcia  = cl-codcia
                AND gn-clie.codcli = s-codcli
                NO-LOCK.
            RUN vta2/p-fmapgo (s-codcli, s-tpoped, OUTPUT s-cndvta-validos).            
            s-FmaPgo = ENTRY(1, s-cndvta-validos).

            ASSIGN 
                FacCPedi.FmaPgo = s-FmaPgo
                Faccpedi.NomCli = gn-clie.NomCli
                Faccpedi.DirCli = gn-clie.DirCli
                Faccpedi.RucCli = gn-clie.Ruc
                FacCPedi.NroCard = gn-clie.NroCard
                Faccpedi.CodVen = gn-clie.CodVen
                Faccpedi.FaxCli = SUBSTRING(TRIM(gn-clie.clfcli) + "00",1,2) +
                                    SUBSTRING(TRIM(gn-clie.clfcli2) + "00",1,2)
                Faccpedi.Cmpbnte = 'FAC'.
            /* ------------------------------ */
        END.
        /* Leer el Detalle */
        x-NroItm = 0.
        x-Cargo-Orden = NO.
        lOrdenGrabada = "".
        /* El Detalle de la Orden */
        DO iColumn = 2 TO 65000:
            ASSIGN 
                x-CodMat = ''
                x-CanPed = 0
                x-ImpLin = 0
                x-ImpIgv = 0
                x-precio = 0.
            /* Orden */
            cRange = "B" + TRIM(STRING(iColumn)).
            cValue = TRIM(STRING(chWorkSheet:Range(cRange):VALUE,">>>>>>>>>>>9")).
    
            IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */
    
            /* O/C */
            cNro-oc = cValue.
            /* Local destino */
            cRange = "U" + TRIM(STRING(iColumn)).
            cLocal = TRIM(chWorkSheet:Range(cRange):VALUE).
    
            IF cNro-oc = OrdenCompra-Tienda.nro-oc AND cLocal = OrdenCompra-Tienda.clocal-destino THEN DO:
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
                IF X-CodMat = '' THEN DO:
                    FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND 
                                        almmmat1.barras[4] = lCodEan NO-LOCK NO-ERROR.
                    x-CodMat = IF(AVAILABLE almmmat1) THEN almmmat1.barras[4] ELSE x-CodMat.
                END.
                IF X-CodMat = '' THEN DO:
                    FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND 
                                        almmmat1.barras[5] = lCodEan NO-LOCK NO-ERROR.
                    x-CodMat = IF(AVAILABLE almmmat1) THEN almmmat1.barras[5] ELSE x-CodMat.
                END.
                /* 4,5 Ean14s */
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
                        /*
                        MESSAGE "El Item " x-Item " Articulo (" x-codmat ") no esta registrado en el catalogo"
                                VIEW-AS ALERT-BOX ERROR.
                        */
                    END.                    
                END.
                ELSE DO:
                    /*
                    MESSAGE "El Item" x-Item "Cod Ean (" lCodEan ") es inubicable"
                            VIEW-AS ALERT-BOX ERROR.
                    */
                END.
            END.            
        END.        
        /* ----------------------------- */
        IF x-Cargo-Orden = YES THEN DO:
            x-ordenes-x-cargar = x-ordenes-x-cargar + 1.
            ASSIGN
                s-Import-B2B = YES
                FacCPedi.Libre_c05 = "3".   /* OJO */
            RUN ue-assign-statement.
        END.
        SESSION:SET-WAIT-STATE('').
    END.
END.
/* Cerrar el Excel  */
{lib\excel-close-file.i}

MESSAGE "Se generaron " + STRING(x-ordenes-x-cargar,">>>9") + " COTIZACION(ES)" SKIP(1)
            "Desde " + cCOTDesde + " Hasta " + cCOTHasta.

RUN Procesa-Handle IN lh_handle ('Open-Query-Master':U).

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Tiendas-B2B V-table-Win 
PROCEDURE Importar-Tiendas-B2B :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pTienda AS INT NO-UNDO.

RUN vta2\d-selecciona-tienda-b2b (OUTPUT pTienda).
IF pTienda = 0 THEN RETURN.

IF pTienda = 1 THEN DO:
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN importar-supermercados-B2Bv2.
    SESSION:SET-WAIT-STATE('').
END.
    
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importar-tottus-b2b V-table-Win 
PROCEDURE importar-tottus-b2b :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE BUFFER b-FacCorre FOR FacCorre.                                
                                
FIND b-FacCorre WHERE b-FacCorre.CodCia = S-CODCIA 
  AND b-FacCorre.CodDoc = S-CODDOC 
  AND b-FacCorre.NroSer = s-NroSer
  NO-LOCK NO-ERROR.
IF b-FacCorre.FlgEst = NO THEN DO:
  RELEASE b-FacCorre.
  MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
  RETURN 'ADM-ERROR'.
END.

RELEASE b-FacCorre.

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
/* B2Bv2 */
DEFINE VARIABLE cNro-oc AS CHAR .
DEFINE VARIABLE clocal AS CHAR.
DEFINE VARIABLE cMsgFinal AS CHAR.

SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Archivo Excel (.xls)' '*.xls'
    RETURN-TO-START-DIR
    TITLE 'Selecciona al archivo Excel'
    MUST-EXIST
    USE-FILENAME
    UPDATE x-Ok.
IF x-Ok = NO THEN RETURN "ADM-ERROR".

EMPTY TEMP-TABLE tt-OrdenesPlazVea.

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.

DEFINE VAR lOrden AS CHAR.
DEFINE VAR lCodEan AS CHAR.

lFileXls = x-Archivo.           /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = NO.        /* YES : Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

chExcelApplication:Visible = FALSE.

lMensajeAlTerminar = NO. /*  */
lCerrarAlTerminar = YES.        /* Si permanece abierto el Excel luego de concluir el proceso */

EMPTY TEMP-TABLE tt-OrdenesPlazVea.
EMPTY TEMP-TABLE OrdenCompra-Tienda.

/* Cuantas ORDENES tiene el Excel */
iColumn = 1.
x-ordenes-x-cargar = 0.
DO iColumn = 2 TO 65000:
    cRange = "A" + TRIM(STRING(iColumn)).
    cValue = TRIM(STRING(chWorkSheet:Range(cRange):VALUE,">>>>>>>>>>>9")).

    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */

    /* O/C */
    cNro-oc = cValue.
    /* Local destino */
    cRange = "K" + TRIM(STRING(iColumn)).
    cLocal = TRIM(chWorkSheet:Range(cRange):VALUE).

    FIND FIRST tt-OrdenesPlazVea WHERE tt-nroorden = cNro-Oc NO-ERROR.
    IF NOT AVAILABLE tt-OrdenesPlazVea THEN DO:
        /* LAS ORDENES DE COMPRA */
        FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                factabla.tabla = 'OC TOTTUS B2B' AND 
                factabla.codigo = cNro-Oc NO-LOCK NO-ERROR.
        IF NOT AVAILABLE factabla THEN DO:
            CREATE tt-OrdenesPlazVea.
                ASSIGN tt-OrdenesPlazVea.tt-nroorden = cNro-Oc
                        cRange = "A" + TRIM(STRING(iColumn))
                        tt-OrdenesPlazVea.tt-CodClie = "RUC DEL CLIENTE"
                        cRange = "K" + TRIM(STRING(iColumn))
                        tt-OrdenesPlazVea.tt-locentrega = TRIM(chWorkSheet:Range(cRange):VALUE).
        END.
    END.  
    /* ORDENES DE COMPRA X LOCAL */
    FIND FIRST OrdenCompra-Tienda WHERE nro-oc = cNro-oc AND
                                        clocal-destino = cLocal NO-ERROR.
    IF NOT AVAILABLE OrdenCompra-Tienda THEN DO:
        CREATE OrdenCompra-Tienda.
        ASSIGN  OrdenCompra-Tienda.nro-oc = cNro-oc
                OrdenCompra-Tienda.clocal-destino = cLocal
                cRange = "L" + TRIM(STRING(iColumn))
                OrdenCompra-Tienda.dlocal-destino = TRIM(chWorkSheet:Range(cRange):VALUE)
                cRange = "K" + TRIM(STRING(iColumn))
                OrdenCompra-Tienda.clocal-entrega = TRIM(chWorkSheet:Range(cRange):VALUE)
                cRange = "L" + TRIM(STRING(iColumn))
                OrdenCompra-Tienda.dlocal-entrega = TRIM(chWorkSheet:Range(cRange):VALUE)
                cRange = "A" + TRIM(STRING(iColumn))
                OrdenCompra-Tienda.CodClie = "RUC DEL CLIENTE".
    END.

END.

x-ordenes-x-cargar = 0.
cCOTDesde = "".
cCOTHasta = "".

FOR EACH tt-OrdenesPlazVea :
    lOrden = tt-OrdenesPlazVea.tt-nroorden.
    FOR EACH OrdenCompra-tienda WHERE lOrden = OrdenCompra-Tienda.nro-oc :
        cCodCli = trim(OrdenCompra-Tienda.CodClie).
        cSede = OrdenCompra-Tienda.clocal-entrega.
        lOrden = OrdenCompra-Tienda.nro-oc.

        SESSION:SET-WAIT-STATE('GENERAL').

        /* Adiciono Registro en Cabecera */
        RUN ue-add-record.
    
        ASSIGN FacCPedi.Glosa = TRIM(OrdenCompra-tienda.clocal-destino) + " " + 
                            TRIM(OrdenCompra-tienda.dlocal-destino)
                  FacCPedi.ordcmp = OrdenCompra-Tienda.nro-oc
                  FacCPedi.ubigeo[1] = TRIM(OrdenCompra-tienda.clocal-destino) + " " + 
                            TRIM(OrdenCompra-tienda.dlocal-destino).
    
        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = cCodCli
            AND gn-clie.flgsit = 'A'
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            ASSIGN
                s-codcli = gn-clie.codcli.
                Faccpedi.codcli = gn-clie.codcli.
    
            FIND FIRST gn-clied OF gn-clie WHERE Gn-ClieD.sede = cSede NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clied THEN DO WITH FRAME {&FRAME-NAME}:
                ASSIGN
                    Faccpedi.sede = Gn-ClieD.Sede.
                FIND gn-clied WHERE gn-clied.codcia = cl-codcia
                    AND gn-clied.codcli = cCodCli 
                    AND gn-clied.sede = csede
                    NO-LOCK NO-ERROR.
                IF AVAILABLE gn-clied THEN 
                    ASSIGN 
                        FacCPedi.LugEnt = Gn-ClieD.DirCli.
            END.

            /* Del CLIENTE */

            s-CodCli = cCodCli.

            /* Cargamos las condiciones de venta válidas */
            FIND gn-clie WHERE gn-clie.codcia  = cl-codcia
                AND gn-clie.codcli = s-codcli
                NO-LOCK.
            RUN vta2/p-fmapgo (s-codcli, s-tpoped, OUTPUT s-cndvta-validos).            
            s-FmaPgo = ENTRY(1, s-cndvta-validos).

            ASSIGN FacCPedi.FmaPgo = s-FmaPgo
                    Faccpedi.NomCli = gn-clie.NomCli
                    Faccpedi.DirCli = gn-clie.DirCli
                    Faccpedi.RucCli = gn-clie.Ruc
                    FacCPedi.NroCard = gn-clie.NroCard
                    Faccpedi.CodVen = gn-clie.CodVen
                    Faccpedi.FaxCli = SUBSTRING(TRIM(gn-clie.clfcli) + "00",1,2) +
                                              SUBSTRING(TRIM(gn-clie.clfcli2) + "00",1,2)
                    Faccpedi.Cmpbnte = 'FAC'.
            
            /* ------------------------------ */

        END.
    
        /* Leer el Detalle */
        x-NroItm = 0.
        x-Cargo-Orden = NO.
        lOrdenGrabada = "".
    
        /* El Detalle de la Orden */
        DO iColumn = 2 TO 65000:
            ASSIGN x-CodMat = ''
                x-CanPed = 0
                x-ImpLin = 0
                x-ImpIgv = 0
                x-precio = 0.
    
            /* Orden */
            cRange = "A" + TRIM(STRING(iColumn)).
            cValue = TRIM(STRING(chWorkSheet:Range(cRange):VALUE,">>>>>>>>>>>9")).
    
            IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */
    
            /* O/C */
            cNro-oc = cValue.
            /* Local destino */
            cRange = "K" + TRIM(STRING(iColumn)).
            cLocal = TRIM(chWorkSheet:Range(cRange):VALUE).
    
            IF cNro-oc = OrdenCompra-Tienda.nro-oc AND
                cLocal = OrdenCompra-Tienda.clocal-destino THEN DO:
                /* Articulo de la misma Orden  */
                cRange = "E" + TRIM(STRING(iColumn)).
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
                        /*
                        MESSAGE "El Item " x-Item " Articulo (" x-codmat ") no esta registrado en el catalogo"
                                VIEW-AS ALERT-BOX ERROR.
                        */
                    END.                    
                END.
                ELSE DO:
                    /*
                    MESSAGE "El Item" x-Item "Cod Ean (" lCodEan ") es inubicable"
                            VIEW-AS ALERT-BOX ERROR.
                    */
                END.
            END.            
        END.        
        /* ----------------------------- */
        IF x-Cargo-Orden = YES THEN DO:
            x-ordenes-x-cargar = x-ordenes-x-cargar + 1.
            RUN ue-assign-statement.
        END.
        SESSION:SET-WAIT-STATE('').
    END.
END.

/* Cerrar el Excel  */
{lib\excel-close-file.i}

MESSAGE "Se generaron " + STRING(x-ordenes-x-cargar,">>>9") + " COTIZACION(ES)" SKIP(1)
            "Desde " + cCOTDesde + " Hasta " + cCOTHasta.

RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Lista-Terceros V-table-Win 
PROCEDURE Lista-Terceros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE f-FleteUnitario AS DEC DECIMALS 6 NO-UNDO.
DEFINE VARIABLE S-UNDVTA AS CHAR NO-UNDO.
DEFINE VARIABLE F-FACTOR AS DECI NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE Z-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE x-TipDto AS CHAR NO-UNDO.

/* 1er Filtro: La lista de precios NO debe ser precios de FERIA */
DEF BUFFER b-divi FOR gn-divi.
FIND b-divi WHERE b-divi.codcia = s-codcia AND b-divi.coddiv = pCodDiv NO-LOCK.
IF b-divi.CanalVenta = 'FER' THEN RETURN.
/* 2do Filtro: La venta debe ser una venta Normal o Provincias */
IF LOOKUP(s-TpoPed, 'P,N') = 0 THEN RETURN.
/* Verificamos el cliente de acuerdo a la división de origen */
/*IF LOOKUP(s-CodDiv, '00018,00019') = 0 THEN DO:     /* NI PROVINCIAS NI MESA REDONDA */*/
/* RHC 29/02/2016 Quitamos */
IF LOOKUP(s-CodDiv, '00018') = 0 THEN DO:     /* NO PROVINCIAS  */
    /* Buscamos clientes VIP */
    FIND FacTabla WHERE FacTabla.CodCia = s-codcia
        AND FacTabla.Tabla = "VIP3ROS"
        AND FacTabla.Codigo = Faccpedi.CodCli
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacTabla THEN RETURN.
END.
/* ************************************************************* */
/* SE VA A DAR HASTA DOS VUELTAS PARA DETERMINAR LA LISTA A USAR */
/* ************************************************************* */
/* Actualizamos datos del temporal */
EMPTY TEMP-TABLE ITEM.
FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.Libre_c05 <> "OF":
    CREATE ITEM.
    BUFFER-COPY Facdpedi TO ITEM.
END.
/* ******************************* */
DEF VAR x-Ciclos AS INT NO-UNDO.
DEF VAR x-ImpTot AS DEC NO-UNDO.
DEF VAR x-ListaTerceros AS INT INIT 0 NO-UNDO.  /* Lista por defecto */
DEF VAR x-ListaAnterior AS INT NO-UNDO.
DEF VAR F-PREBAS AS DEC NO-UNDO.
DEF VAR S-TPOCMB AS DEC NO-UNDO.
FIND gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = Faccpedi.codcli
    NO-LOCK.
x-ListaAnterior = gn-clie.Libre_d01.
/* *********** */
IF x-ListaAnterior > 3 THEN x-ListaAnterior = 3.    /* Valor Máximo */
/* RHC 14/12/2015 Tomamos el valor por defecto en el cliente, puede ser de 0 a 3 */
x-ListaTerceros = x-ListaAnterior.
/* ***************************************************************************** */
FIND FIRST FacTabla WHERE FacTabla.CodCia = s-codcia
    AND FacTabla.Tabla = 'RLP3ROS' NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacTabla THEN RETURN.
DO x-Ciclos = 1 TO 2:
    /* Tomamos el importe final */
    x-ImpTot = 0.
    FOR EACH ITEM:
        x-ImpTot = x-ImpTot + ITEM.ImpLin.
    END.
    IF Faccpedi.codmon = 2 THEN x-ImpTot = x-ImpTot * Faccpedi.TpoCmb.
    /* Decidimos cual lista tomar */
    DEF VAR k AS INT NO-UNDO.
    DO k = 1 TO 3:
        IF k < 3 AND x-ImpTot >= FacTabla.Valor[k] AND x-ImpTot < FacTabla.Valor[k + 1] THEN DO:
            x-ListaTerceros = k.
            LEAVE.
        END.
        IF k = 3 AND x-ImpTot >= FacTabla.Valor[k] THEN x-ListaTerceros = k.
    END.
    /* Tomamos el mejor */
    x-ListaTerceros = MAXIMUM(x-ListaAnterior,x-ListaTerceros).
    IF x-ListaTerceros = 0 THEN RETURN. /* El importe de venta NO llega al mínimo necesario */
    IF x-ListaTerceros > 3 THEN x-ListaTerceros = 3.    /* Valor Máximo */
    /* Actualizamos Precios de Venta */
    FOR EACH ITEM WHERE ITEM.Libre_c05 <> "OF", 
        FIRST Almmmatg OF ITEM NO-LOCK,
        FIRST ListaTerceros OF ITEM NO-LOCK:
        IF ListaTerceros.PreOfi[x-ListaTerceros] = 0 THEN NEXT.
        F-PREBAS = ListaTerceros.PreOfi[x-ListaTerceros].
        S-TPOCMB = Almmmatg.TpoCmb.
        IF Faccpedi.CodMon = 1 THEN DO:
            IF Almmmatg.MonVta = 1 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
            ELSE ASSIGN F-PREBAS = F-PREBAS * S-TPOCMB /** F-FACTOR*/.
        END.
        IF Faccpedi.CodMon = 2 THEN DO:
            IF Almmmatg.MonVta = 2 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
            ELSE ASSIGN F-PREBAS = (F-PREBAS / S-TPOCMB) /** F-FACTOR*/.
        END.
        ASSIGN
            ITEM.Por_Dsctos[1] = 0
            ITEM.Por_Dsctos[2] = 0
            ITEM.Por_Dsctos[3] = 0
            ITEM.PreBas = F-PREBAS
            ITEM.PreUni = F-PREBAS
            ITEM.Libre_c04 = "LP3ROS"
            ITEM.Libre_d01 = x-ListaTerceros.
        /* Recalculamos registro */
        /*MESSAGE 'la cagada' f-prebas.*/
        ASSIGN
            ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                          ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                          ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                          ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
        /* ****************************************** */
        /* RHC 15/12/2015 AGREGAMOS EL FLETE UNITARIO */
        /* ****************************************** */
        ASSIGN
            ITEM.ImpDto = 0
            ITEM.Libre_d02 = 0
            f-FleteUnitario = 0.
        RUN vta2/PrecioMayorista-Cred-v2 (
            Faccpedi.TpoPed,
            pCodDiv,
            Faccpedi.CodCli,
            Faccpedi.CodMon,
            INPUT-OUTPUT s-UndVta,
            OUTPUT f-Factor,
            ITEM.CodMat,
            Faccpedi.FmaPgo,
            ITEM.CanPed,
            Faccpedi.Libre_d01,
            OUTPUT f-PreBas,
            OUTPUT f-PreVta,
            OUTPUT f-Dsctos,
            OUTPUT y-Dsctos,
            OUTPUT z-Dsctos,
            OUTPUT x-TipDto,
            OUTPUT f-FleteUnitario,
            ITEM.TipVta,
            NO
            ).
        IF RETURN-VALUE <> 'ADM-ERROR' AND f-FleteUnitario > 0 THEN DO:
            ASSIGN
                ITEM.Libre_d02 = f-FleteUnitario.
            /* El flete afecta el monto final */
            IF ITEM.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
                ASSIGN
                    ITEM.PreUni = ROUND(ITEM.PreUni + ITEM.Libre_d02, s-NroDec)  /* Incrementamos el PreUni */
                    ITEM.ImpLin = ITEM.CanPed * ITEM.PreUni.
            END.
            ELSE DO:      /* CON descuento promocional o volumen */
                ASSIGN
                    ITEM.ImpLin = ITEM.ImpLin + (ITEM.CanPed * f-FleteUnitario)
                    ITEM.PreUni = ROUND( (ITEM.ImpLin + ITEM.ImpDto) / ITEM.CanPed, s-NroDec).
            END.
        END.
        /* ****************************************** */
        /* ****************************************** */
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
END.
IF x-ListaTerceros = 0 THEN RETURN.
/* Ahora sí grabamos la información */
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FOR EACH ITEM WHERE ITEM.Libre_c04 = "LP3ROS", FIRST Almmmatg OF ITEM NO-LOCK,
        FIRST Almsfami OF Almmmatg NO-LOCK:
        FIND Facdpedi OF Faccpedi WHERE Facdpedi.codmat = ITEM.codmat
            AND Facdpedi.Libre_c05 <> "OF" EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Facdpedi THEN DO:
            MESSAGE 'NO se pudo bloquear el registro del código:' ITEM.codmat
                VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN ERROR.
        END.
        BUFFER-COPY ITEM TO Facdpedi.
        /* RHC 07/11/2013 CALCULO DE PERCEPCION */
        DEF VAR s-PorPercepcion AS DEC INIT 0 NO-UNDO.
        ASSIGN
            Facdpedi.CanSol = 0
            Facdpedi.CanApr = 0.
        FIND FIRST Vtatabla WHERE Vtatabla.codcia = s-codcia
            AND Vtatabla.tabla = 'CLNOPER'
            AND VtaTabla.Llave_c1 = s-CodCli
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Vtatabla THEN DO:
            IF gn-clie.Libre_L01 = YES AND gn-clie.RucOld <> "SI" THEN s-Porpercepcion = 0.5.
            IF gn-clie.Libre_L01 = NO AND gn-clie.RucOld <> "SI" THEN s-Porpercepcion = 2.
            /* Ic 04 Julio 2013 
                gn-clie.Libre_L01   : PERCEPCTOR
                gn-clie.RucOld      : RETENEDOR
            */
            IF s-Cmpbnte = "BOL" THEN s-Porpercepcion = 2.
            IF Almsfami.Libre_c05 = "SI" THEN
                ASSIGN
                Facdpedi.CanSol = s-PorPercepcion
                Facdpedi.CanApr = ROUND(Facdpedi.implin * s-PorPercepcion / 100, 2).
        END.
    END.
    ASSIGN
        FacCPedi.TipBon[10] = x-ListaTerceros.      /* Control de Lista de Terceros */
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
      s-Import-IBC      = NO
      s-Import-Cissac   = NO
      s-Import-B2B      = NO
      s-adm-new-record = "YES"
      s-nroped = ""
      lOrdenGrabada = ""
      S-TPOMARCO = ""
      s-nivel-acceso = 1.   /* Permitido */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          s-CodMon = 1
          s-CodCli = FacCfgGn.CliVar
          s-FmaPgo = ''
          s-TpoCmb = 1
          s-NroDec = 4
          s-FlgIgv = YES    /* Venta AFECTA a IGV */
          FacCPedi.Cmpbnte:SCREEN-VALUE = "FAC".
      FIND TcmbCot WHERE  TcmbCot.Codcia = 0
          AND  (TcmbCot.Rango1 <= TODAY - TODAY + 1
          AND   TcmbCot.Rango2 >= TODAY - TODAY + 1)
          NO-LOCK NO-ERROR.
      IF AVAIL TcmbCot THEN S-TPOCMB = TcmbCot.TpoCmb.  
      /* RHC 11.08.2014 TC Caja Compra */
      FOR EACH gn-tccja NO-LOCK BY Fecha:
          IF TODAY >= Fecha THEN s-TpoCmb = Gn-TCCja.Compra.
      END.
    ASSIGN 
        FacCPedi.NroPed:SCREEN-VALUE = STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999')
        FacCPedi.FchEnt:SCREEN-VALUE = STRING(TODAY + s-MinimoDiasDespacho,"99/99/9999")
        Faccpedi.codcli:SCREEN-VALUE = s-CodCli
        Faccpedi.codven:SCREEN-VALUE = s-CodVen
        .

      RUN Borra-Temporal.
      RUN Procesa-Handle IN lh_Handle ('Pagina2').
      /* RHC 14/10/2013 ***************************************************************** */
      RUN rutina-add-extra.
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
      {lib/lock-genericov3.i
          &Tabla="FacCorre"
          &Alcance="FIRST"
          &Condicion="FacCorre.CodCia = s-CodCia 
          AND FacCorre.CodDoc = s-CodDoc 
          AND FacCorre.CodDiv = s-CodDiv
          AND FacCorre.NroSer = s-NroSer"
          &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
          &Accion="RETRY"
          &Mensaje="YES"
          &TipoError="UNDO, RETURN 'ADM-ERROR'"
          }
      REPEAT:
          IF NOT CAN-FIND(FIRST FacCPedi WHERE FacCPedi.codcia = s-codcia
                          AND FacCPedi.coddiv = FacCorre.coddiv
                          AND FacCPedi.coddoc = FacCorre.coddoc
                          AND FacCPedi.nroped = STRING(FacCorre.nroser, '999') + 
                          STRING(FacCorre.correlativo, '999999')
                          NO-LOCK)
              THEN LEAVE.
          ASSIGN
              FacCorre.Correlativo = FacCorre.Correlativo + 1.
      END.
      ASSIGN 
          FacCPedi.CodCia = S-CODCIA
          FacCPedi.CodDiv = S-CODDIV
          FacCPedi.CodDoc = s-coddoc 
          FacCPedi.CodAlm = s-CodAlm    /* Lista de Almacenes Válidos de Venta */
          FacCPedi.FchPed = TODAY 
          FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
          FacCPedi.TpoPed = s-TpoPed
          FacCPedi.FlgEst = (IF FacCPedi.CodCli BEGINS "SYS" THEN "I" ELSE "P").    /* APROBADO */
      /* ************************************************************************************** */
      /* DATOS QUE FALTAN */
      /* ************************************************************************************** */
      FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = FacCPedi.codcli NO-LOCK.
      ASSIGN
          FacCPedi.FchPed = TODAY
          FacCPedi.FchVen = TODAY + s-DiasVtoCot
          FacCPedi.DirCli = gn-clie.dircli 
          FacCPedi.NroCard = gn-clie.nrocard 
          FacCPedi.CodMon = s-CodMon
          FacCPedi.TpoCmb = s-TpoCmb
          FacCPedi.FlgIgv = s-FlgIgv
          FacCPedi.Libre_d01 = s-NroDec
          .
      /* ************************************************************************************** */
      IF s-Import-Ibc = YES     THEN FacCPedi.Libre_C05 = "1".
      IF s-Import-Cissac = YES  THEN FacCPedi.Libre_C05 = "2".
      IF s-Import-B2B = YES     THEN FacCPedi.Libre_C05 = "3".  /* OJO*/
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
      /* RHC 05/10/17 En caso de COPIAR una cotizacion hay que "limpiar" estos campos */
      ASSIGN
          Faccpedi.Libre_c02 = ""       /* "PROCESADO" por Abastecimientos */
          Faccpedi.LugEnt2   = ""
          .
  END.
  ELSE DO:
      RUN Borra-Pedido.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      /* Ic - 05Nov2016 - Cualquier Modfiicacion */
      ASSIGN 
          Faccpedi.UsrAct = s-user-id
          Faccpedi.FecAct = TODAY
          Faccpedi.HorAct = STRING(TIME,"HH:MM:SS").
      /* Ic - 05Nov2016 - Cualquier Modfiicacion - FIN */
  END.
  /* ************************************************************************ */
  /* *************************** POR APROBAR ******************************** */
  /* ************************************************************************ */
  IF s-import-ibc = YES AND s-pendiente-ibc = YES THEN Faccpedi.flgest = 'E'.
  IF FacCPedi.Libre_c04 = "SI" THEN Faccpedi.flgest = 'E'.
  /* ************************************************************************ */
  /* ************************************************************************ */
  ASSIGN 
      FacCPedi.PorIgv       = s-PorIgv
      FacCPedi.Hora         = STRING(TIME,"HH:MM")
      FacCPedi.Usuario      = S-USER-ID
      FacCPedi.Observa      = F-Observa
      FacCPedi.Libre_c01    = pCodDiv.
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
      IF CAN-FIND(FIRST ITEM NO-LOCK) THEN DO:
          RUN Procesa-Handle IN lh_Handle ('Recalculo').
      END.
      /* Reconstruimos */
      FOR EACH PEDI:
          CREATE ITEM.
          BUFFER-COPY PEDI TO ITEM.
      END.
  END.
  FOR EACH ITEM WHERE ITEM.ImpLin > 0,
      FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = ITEM.codmat
      BY ITEM.NroItm:
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
      /* Si la división dice "Verificar Stock en COTIZACION" */
      IF GN-DIVI.Campo-Log[9] = YES THEN DO:
          /* Veamos el stock disponible */
          DEFINE VARIABLE s-StkComprometido AS DECIMAL NO-UNDO.
          FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
              AND  Almmmate.CodAlm = ENTRY(1, s-CodAlm)
              AND  Almmmate.codmat = ITEM.CodMat
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almmmate THEN DO:
              RUN gn/Stock-Comprometido-v2 (ITEM.CodMat, ENTRY(1, s-CodAlm), YES, OUTPUT s-StkComprometido).
              IF ITEM.CanPed > (Almmmate.StkAct - s-StkComprometido) THEN ASSIGN FacCPedi.FlgEst = "E".     /* Por Aprobar */
          END.
      END.
  END.
  RUN Descuentos-Finales-01.    /* Por Volumen x Linea x SubLinea Resumido */
  RUN Descuentos-Finales-02.

  /* RHC DESCUENTOS ESPECIALES SOLO CAMPAÑA */
  /*RUN Descuentos-solo-campana.*/

  /*RUN Descuentos-Finales-03.*/

  /* RHC 06/07/17 Descuentos por saldo resumido solo para Expolibreria */
  /*RUN Descuentos-Finales-04.*/

  /* **************************************************************** */
  /* RHC 18/11/2015 RUTINA ESPECIAL PARA LISTA DE PRECIOS DE TERCEROS */
  /* **************************************************************** */
  RUN Lista-Terceros NO-ERROR.
  IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
  /* **************************************************************** */
  
  {vta2/graba-totales-cotizacion-cred.i}

  /* **************** RHC 24.07.2014 MARGEN MINIMO POR DIVISION ****************** */
  DEF VAR pError AS CHAR.
  
  RUN vtagn/p-margen-utilidad-por-cotizacion ( ROWID(Faccpedi) , YES, OUTPUT pError ).
  IF pError = "ADM-ERROR" THEN ASSIGN Faccpedi.FlgEst = "T".
  IF Faccpedi.FlgEst = "T" AND pError = "OK" THEN ASSIGN Faccpedi.FlgEst = "P".    /* APROBADO */
  /* RHC 10/02/2016 Cualquier variaci´n en la Lista Express requiere aprobación */
  IF s-TpoPed = "LF" THEN DO:
      ASSIGN
          Faccpedi.flgest = "E".    /* Por Aprobar */
  END.

  IF Faccpedi.CodRef = "PPV" THEN DO:
      RUN actualiza-prepedido ( ROWID(Faccpedi), +1, OUTPUT pMensaje ).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.

  /* RHC 20/07/2017 Comisiones */
  FOR EACH Facdpedi OF Faccpedi EXCLUSIVE-LOCK:
      /* Grabamos la Comisión del Vendedor */
      FacDPedi.Libre_d04 = fComision().
  END.

  IF AVAILABLE(Faccorre) THEN RELEASE FacCorre.
  IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
  IF AVAILABLE(gn-clie)  THEN RELEASE Gn-Clie.

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
  IF LOOKUP(Faccpedi.flgest, "E,P") > 0 THEN DO:
      IF NOT CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE Facdpedi.canate > 0 NO-LOCK) THEN DO:
          /* RHC 29/03/2016 Institucionales NO pregunta */
          IF s-TpoPed <> "I" THEN DO:
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
  END.

  ASSIGN
      s-CodMon = Faccpedi.codmon
      s-CodCli = Faccpedi.codcli
      /*s-CndVta = Faccpedi.fmapgo*/
      s-FmaPgo = ""     /* La condición de venta depende del cliente */
      s-TpoCmb = 1
      /*s-FlgIgv = Faccpedi.FlgIgv*/
      s-FlgIgv = YES    /* Venta AFECTA a IGV */
      s-Copia-Registro = YES    /* <<< OJO >>> */
      s-PorIgv = FacCfgGn.PorIgv
      s-NroDec = Faccpedi.Libre_d01
      s-Import-IBC = NO
      s-Import-Cissac = NO
      s-adm-new-record = "YES"
      s-nroped = ""
      S-TPOMARCO = Faccpedi.Libre_c04.
      
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
          (TODAY + s-MinimoDiasDespacho) @ FacCPedi.FchEnt
          s-FmaPgo @ FacCPedi.FmaPgo
          s-CodVen @ Faccpedi.codven.
  END.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  /* RHC 14/10/2013 ***************************************************************** */
  RUN rutina-add-extra.
  /* ******************************************************************************** */
  APPLY 'ENTRY':U TO FacCPedi.CodCli.

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
  IF LOOKUP(FacCPedi.FlgEst,"P,E,T,V") = 0 THEN DO:
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
      /* RHC 04/01/2016 Pre-Pedido Expolibreria */
      IF Faccpedi.codref = 'PET' 
          AND CAN-FIND(FIRST Vtacdocu WHERE VtaCDocu.CodCia = Faccpedi.codcia 
                       AND VtaCDocu.CodDiv = Faccpedi.coddiv
                       AND VtaCDocu.CodPed = Faccpedi.codref
                       AND VtaCDocu.NroPed = Faccpedi.nroref
                       NO-LOCK)
          THEN DO:
          FIND Vtacdocu WHERE VtaCDocu.CodCia = Faccpedi.codcia 
              AND VtaCDocu.CodDiv = Faccpedi.coddiv
              AND VtaCDocu.CodPed = Faccpedi.codref
              AND VtaCDocu.NroPed = Faccpedi.nroref
              EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE Vtacdocu THEN DO:
              MESSAGE 'NO se pudo bloquear el' Faccpedi.codref Faccpedi.nroref
                  VIEW-AS ALERT-BOX ERROR.
              UNDO, RETURN 'ADM-ERROR'.
          END.
          ASSIGN
              Vtacdocu.Libre_c05 = ''
              Vtacdocu.FlgSit = "X".
          RELEASE Vtacdocu.
      END.
      /* ************************************** */
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
      FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
          AND  gn-ven.CodVen = FacCPedi.CodVen 
          NO-LOCK NO-ERROR.
      FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
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
  DEF BUFFER b-divi FOR gn-divi.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          FacCPedi.NomCli:SENSITIVE = NO
          FacCPedi.RucCli:SENSITIVE = NO
          FacCPedi.FaxCli:SENSITIVE = NO
          .
      
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'NO' THEN DO:
          FacCPedi.CodCli:SENSITIVE = NO.
          /*   Ic - 13Oct2015 - Si canal de venta de la  division es FER, permite modificar fecha entrega  
                    26Oct2015 - Se debe validar con la lista de precios no con la division.
          */
          IF faccpedi.libre_c01 <> ? THEN DO:
              FIND FIRST b-divi WHERE b-divi.codcia = s-codcia
                  AND b-divi.coddiv = faccpedi.libre_c01 NO-LOCK NO-ERROR.
              IF AVAILABLE b-divi THEN DO:
                  /* Si es FERIA */
                  IF NOT b-divi.canalventa = 'FER' THEN DO:
                      /*FacCPedi.FchEnt:SENSITIVE = NO.*/
                  END.
              END.
              ELSE FacCPedi.FchEnt:SENSITIVE = NO.
          END.
          ELSE FacCPedi.FchEnt:SENSITIVE = NO. 
          IF s-tpoped = "M" THEN DO:    /* SOLO PARA CONTRATO MARCO */
              ASSIGN
                  FacCPedi.NomCli:SENSITIVE = YES.
          END.
          /* Control de Programacion de Abastecimientos */
          IF s-nivel-acceso = 0 THEN FacCPedi.FchEnt:SENSITIVE = NO.
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
  IF FacCPedi.FlgEst = "A" THEN RETURN.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  CASE s-TpoPed:
      WHEN "E" THEN DO:     /* Evento */
          ASSIGN
              s-codalm = Faccpedi.codalm
              s-fmapgo = Faccpedi.fmapgo
              s-codmon = Faccpedi.codmon
              s-codcli = Faccpedi.codcli
              s-nrodec = Faccpedi.libre_d01
              s-PorIgv = Faccpedi.porigv.
          RUN Carga-Temporal.
          
          RUN vtaexp/R-CotExpLib-1-2 (ROWID(FacCPedi)).
      END.
      OTHERWISE DO:
          MESSAGE '¿Para Imprimir el documento marque'  SKIP
              '   1. Si = Incluye IGV.      ' SKIP
              '   2. No = No incluye IGV.      '
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
              UPDATE lchoice AS LOGICAL.
          IF lchoice = ? THEN RETURN.
          RUN VTA\R-ImpCot-1 (ROWID(FacCPedi),lchoice).
      END.
  END CASE.

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
      DEF VAR pEstado AS LOG NO-UNDO.
      RUN sunat\p-inicio-actividades (INPUT TODAY, OUTPUT pEstado).
      IF pEstado = YES THEN FacCPedi.Cmpbnte:RADIO-BUTTONS = "FAC,FAC," +
                                            "BOL,BOL".
      ELSE FacCPedi.Cmpbnte:RADIO-BUTTONS = "FAC,FAC," +
                                            "BOL,BOL," +
                                            "TCK,TCK".
      fill-in-cmpbnte:SCREEN-VALUE = "Comprobante".
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
                        s-FmaPgo,
                        YES,
                        1
                        ).
  IF F-Observa = '***' THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  pMensaje = ''.
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF pMensaje <> '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      UNDO, RETURN 'ADM-ERROR'.
  END.

  /* Code placed here will execute AFTER standard behavior.    */
  /*RUN Cierre-de-atencion.*/
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse'). 
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

  /*OS-RENAME VALUE(p-lfilexls) VALUE(p-lFileXlsProcesado).*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ocultar-campos V-table-Win 
PROCEDURE ocultar-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pHandle AS HANDLE.

DEFINE VAR hLabel AS HANDLE.

pHandle:VISIBLE = NO.
pHandle:X = 0.
pHandle:Y = 0.

ASSIGN hLabel = pHandle:SIDE-LABEL-HANDLE.
IF VALID-HANDLE(hLabel) THEN DO:
    ASSIGN pHandle:SENSITIVE = NO.
    ASSIGN hLabel:VISIBLE = NO.

END.


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

/* ******************************************************* */
/* RHC 06/11/2017 NO recalcular precios para CANAL MODERNO */
/* ******************************************************* */
IF s-Import-IBC = YES OR 
    s-Import-Cissac = YES OR    /* IMPORTAR SUPERMERCADOS */
    s-Import-B2B = YES OR       /* IMPORTAR TIENDAS B2B */
    s-TpoPed = "LF"             /* Lista Express */
    THEN RETURN.
/* ******************************************************* */
/* ******************************************************* */
/* ARTIFICIO */
IF S-TPOMARCO = "SI" THEN RUN Recalcular-Precio-TpoPed ("M").
ELSE RUN Recalcular-Precio-TpoPed (s-TpoPed).

RUN Procesa-Handle IN lh_handle ('Browse').

END PROCEDURE.

PROCEDURE Recalcular-Precio-TpoPed:
/* ***************************** */

    DEF INPUT PARAMETER pTpoPed AS CHAR.

    /*{vtagn/recalcular-cot-gral-v01.i &pTpoPed=pTpoPed}*/
    {vta2/recalcularcreditomay-v2.i &pTpoPed=pTpoPed}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Precios-Evento V-table-Win 
PROCEDURE Recalcular-Precios-Evento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE S-UNDVTA AS CHAR NO-UNDO.
DEFINE VARIABLE F-FACTOR AS DECI NO-UNDO.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE X-CANPED AS DECI NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE Z-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE x-TipDto AS CHAR NO-UNDO.
DEFINE VARIABLE f-FleteUnitario AS DEC DECIMALS 6 NO-UNDO.

SESSION:SET-WAIT-STATE('GENERAL').
ACTUALIZACION:
FOR EACH ITEM WHERE ITEM.Libre_c05 <> "OF", FIRST Almmmatg OF ITEM NO-LOCK, FIRST Almsfami OF Almmmatg NO-LOCK:
    ASSIGN
        F-FACTOR = ITEM.Factor
        x-CanPed = ITEM.CanPed
        s-UndVta = ITEM.UndVta
        f-PreVta = ITEM.PreUni
        f-PreBas = ITEM.PreBas
        f-Dsctos = ITEM.PorDto
        z-Dsctos = ITEM.Por_Dsctos[2]
        y-Dsctos = ITEM.Por_Dsctos[3]
        f-FleteUnitario = 0.
    
    RUN vta2/precio-de-venta-eventos (
        s-TpoPed,
        pCodDiv,
        s-CodCli,
        s-CodMon,
        INPUT-OUTPUT s-UndVta,
        OUTPUT f-Factor,
        Almmmatg.CodMat,
        s-FmaPgo,
        x-CanPed,
        s-NroDec,
        OUTPUT f-PreBas,
        OUTPUT f-PreVta,
        OUTPUT f-Dsctos,
        OUTPUT y-Dsctos,
        OUTPUT x-TipDto,
        "",
        OUTPUT f-FleteUnitario,
        TRUE
        ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        DELETE ITEM.
        NEXT ACTUALIZACION.
    END.

    ASSIGN 
        ITEM.Factor = f-Factor
        ITEM.UndVta = s-UndVta
        ITEM.PreUni = F-PREVTA
        ITEM.Libre_d02 = f-FleteUnitario    /* Flete Unitario */
        ITEM.PreBas = F-PreBas 
        ITEM.PreVta[1] = F-PreVta   /* CONTROL DE PRECIO DE LISTA */
        ITEM.PorDto = F-DSCTOS      /* Ambos descuentos afectan */
        ITEM.PorDto2 = 0            /* el precio unitario */
        ITEM.Por_Dsctos[2] = z-Dsctos
        ITEM.Por_Dsctos[3] = Y-DSCTOS 
        /*ITEM.AftIgv = (IF s-FmaPgo = '900' THEN NO ELSE Almmmatg.AftIgv)*/
        ITEM.AftIgv = Almmmatg.AftIgv
        ITEM.AftIsc = Almmmatg.AftIsc
        ITEM.ImpIsc = 0
        ITEM.ImpIgv = 0
        ITEM.Libre_c04 = x-TipDto.
    ASSIGN
        ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                    ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
    IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
        THEN ITEM.ImpDto = 0.
    ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
    /* RHC 04/08/2015 Si existe f-FleteUnitario se recalcula el Descuento */
    IF f-FleteUnitario > 0 THEN DO:
      /* El flete afecta el monto final */
      IF ITEM.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
          ASSIGN
              ITEM.PreUni = ROUND(f-PreVta + f-FleteUnitario, s-NroDec)  /* Incrementamos el PreUni */
              ITEM.ImpLin = ITEM.CanPed * ITEM.PreUni.
      END.
      ELSE DO:      /* CON descuento promocional o volumen */
          ASSIGN
              ITEM.ImpLin = ITEM.ImpLin + (ITEM.CanPed * f-FleteUnitario)
              ITEM.PreUni = ROUND( (ITEM.ImpLin + ITEM.ImpDto) / ITEM.CanPed, s-NroDec).
      END.
    END.
    /* ***************************************************************** */
    ASSIGN
        ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
        ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
    IF ITEM.AftIsc THEN 
        ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
    ELSE ITEM.ImpIsc = 0.
    IF ITEM.AftIgv THEN  
        ITEM.ImpIgv = ITEM.ImpLin - ROUND(ITEM.ImpLin  / (1 + (s-PorIgv / 100)),4).
    ELSE ITEM.ImpIgv = 0.

    /* RHC 07/11/2013 CALCULO DE PERCEPCION */
    DEF VAR s-PorPercepcion AS DEC INIT 0 NO-UNDO.
    ASSIGN
        ITEM.CanSol = 0
        ITEM.CanApr = 0.
    FIND FIRST Vtatabla WHERE Vtatabla.codcia = s-codcia
        AND Vtatabla.tabla = 'CLNOPER'
        AND VtaTabla.Llave_c1 = s-CodCli
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtatabla THEN DO:
        FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = s-codcli NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            IF gn-clie.Libre_L01 = YES AND gn-clie.RucOld <> "SI" THEN s-Porpercepcion = 0.5.
            IF gn-clie.Libre_L01 = NO AND gn-clie.RucOld <> "SI" THEN s-Porpercepcion = 2.
        END.
        /* Ic 04 Julio 2013 
            gn-clie.Libre_L01   : PERCEPCTOR
            gn-clie.RucOld      : RETENEDOR
        */
        IF s-Cmpbnte = "BOL" THEN s-Porpercepcion = 2.
        IF Almsfami.Libre_c05 = "SI" THEN
            ASSIGN
            ITEM.CanSol = s-PorPercepcion
            ITEM.CanApr = ROUND(ITEM.implin * s-PorPercepcion / 100, 2).
    END.
    /* ************************************ */
END.
SESSION:SET-WAIT-STATE('').
RUN Procesa-Handle IN lh_handle ('Browse').

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
                input-var-1 = "CP"
                input-var-2 = ""
                input-var-3 = "".
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reposicionar-campos V-table-Win 
PROCEDURE reposicionar-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pHandle AS HANDLE.
DEFINE INPUT PARAMETER pX AS DEC.
DEFINE INPUT PARAMETER pY AS DEC.

DEFINE VAR hLabel AS HANDLE.

DO WITH FRAME {&FRAME-NAME}:
    pHandle:X = pX.
    pHandle:Y = pY.

    ASSIGN hLabel = pHandle:SIDE-LABEL-HANDLE.
    IF VALID-HANDLE(hLabel) THEN DO:
        ASSIGN /*pHandle:SENSITIVE = pSensitive*/
               hLabel:WIDTH-PIXELS = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(hLabel:SCREEN-VALUE,hLabel:FONT)
               hLabel:Y = pHandle:Y
               hLabel:X = pHandle:X - hLabel:WIDTH-PIXELS - 8.

    END.

END.

END PROCEDURE.

/*
ASSIGN hLabel     = MyFillIn:SIDE-LABEL-HANDLE
       MyFillIn:X = 150
       MyFillIn:Y = 150.

IF VALID-HANDLE(hLabel) THEN 
  ASSIGN hLabel:SCREEN-VALUE = "Testing:"
         hLabel:WIDTH-PIXELS = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(hLabel:SCREEN-VALUE,hLabel:FONT)
         hLabel:Y = MyFillIn:Y
         hLabel:X = MyFillIn:X - hLabel:WIDTH-PIXELS - 4.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rutina-add-extra V-table-Win 
PROCEDURE rutina-add-extra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF BUFFER b-divi FOR gn-divi.

DO WITH FRAME {&FRAME-NAME}:
    /* RHC 14/10/2013 ***************************************************************** */
    CASE TRUE:
        WHEN s-TpoPed = "P" THEN DO:     /* PROVINCIAS */
            FIND b-divi WHERE b-divi.codcia = s-codcia
                AND b-divi.coddiv = pCodDiv
                NO-LOCK NO-ERROR.
            IF AVAILABLE b-divi AND b-divi.VentaMayorista = 1 THEN DO:  /* LISTA GENERAL */
                RUN Procesa-Handle IN lh_Handle ('Pagina3').
                RUN Procesa-Handle IN lh_Handle ("Enable-Button-Imp-Prov").
            END.
        END.
        WHEN s-CodDiv = '00024' THEN DO:  /* INSTITUCIONALES */
            IF s-TpoPed <> "M" THEN RUN Procesa-Handle IN lh_Handle ("Enable-Button-Imp-OpenOrange").
        END.
    END CASE.
    /* ******************************************************************************** */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Transferencia-de-Saldos V-table-Win 
PROCEDURE Transferencia-de-Saldos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pRowidS AS ROWID.

IF NOT AVAILABLE Faccpedi THEN RETURN.

ASSIGN
    S-CODMON = FacCPedi.CodMon
    S-CODCLI = FacCPedi.CodCli
    S-TPOCMB = FacCPedi.TpoCmb
    S-fmapgo = FacCPedi.FmaPgo
    s-Copia-Registro = NO
    s-PorIgv = Faccpedi.porigv
    s-NroDec = (IF Faccpedi.Libre_d01 <= 0 THEN 2 ELSE Faccpedi.Libre_d01)
    s-FlgIgv = Faccpedi.FlgIgv
    s-adm-new-record = "NO"
    s-nroped = Faccpedi.nroped
    S-CMPBNTE = Faccpedi.Cmpbnte.

RUN vta2/transferencia-saldo-cotizacion (
    INPUT ROWID(Faccpedi),
    INPUT pCodDiv,
    INPUT s-user-id,
    OUTPUT pRowidS
    ).
IF pRowidS = ? THEN RETURN.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-add-record V-table-Win 
PROCEDURE ue-add-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
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
      s-Import-IBC      = NO
      s-Import-Cissac   = NO
      s-Import-B2B      = NO
      s-adm-new-record = "YES"
      s-nroped = ""
      lOrdenGrabada = "".

  /* Adiciono el NUEVO REGISTRO */
  CREATE FacCPedi.

  ASSIGN
      s-CodMon = 1
      s-CodCli = ''
      s-FmaPgo = ''
      s-TpoCmb = 1
      s-NroDec = 4
      s-FlgIgv = YES    /* Venta AFECTA a IGV */.

      ASSIGN FacCPedi.CodMon = s-CodMon
             FacCPedi.Cmpbnte = "FAC"
             FacCPedi.Libre_d01  = s-NroDec
             FacCPedi.FlgIgv = YES.

      FIND TcmbCot WHERE  TcmbCot.Codcia = 0
          AND  (TcmbCot.Rango1 <= TODAY - TODAY + 1
          AND   TcmbCot.Rango2 >= TODAY - TODAY + 1)
          NO-LOCK NO-ERROR.
      IF AVAIL TcmbCot THEN S-TPOCMB = TcmbCot.TpoCmb.  
      /* RHC 11.08.2014 TC Caja Compra */
      FOR EACH gn-tccja NO-LOCK BY Fecha:
          IF TODAY >= Fecha THEN s-TpoCmb = Gn-TCCja.Compra.
      END.

      ASSIGN FacCPedi.NroPed = STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999')
             FacCPedi.FchPed = TODAY
             FacCPedi.TpoCmb = s-tpocmb
             FacCPedi.FchVen = TODAY + s-DiasVtoCot
             FacCPedi.FchEnt = OrdenCompra-tienda.fecha-entrega
             Faccpedi.codven = s-CodVen
             Faccpedi.ImpDto2 = 0 NO-ERROR.

        IF OrdenCompra-tienda.fecha-entrega = ? THEN DO:
            ASSIGN FacCPedi.FchVen = TODAY + s-MinimoDiasDespacho.
        END.

      RUN Borra-Temporal.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-assign-statement V-table-Win 
PROCEDURE ue-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

  DEFINE VAR lCodCli AS CHAR.

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
  IF s-TpoPed = "LF" THEN FacCPedi.FlgEst = "E".    /* Por Aprobar */

  lCodCli = FacCPedi.CodCli.
  IF cCOTDesde = "" THEN cCOTDesde = FacCPedi.NroPed.
  cCOTHasta = FacCPedi.NroPed.

  ASSIGN
      FacCorre.Correlativo = FacCorre.Correlativo + 1.

  ASSIGN 
      FacCPedi.PorIgv = s-PorIgv
      FacCPedi.Hora = STRING(TIME,"HH:MM")
      FacCPedi.Usuario = S-USER-ID
      FacCPedi.Observa = F-Observa
      FacCPedi.Libre_c01 = pCodDiv.

  FOR EACH ITEM WHERE ITEM.ImpLin > 0,
      FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = ITEM.codmat
      BY ITEM.NroItm:
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

  /* Guardar la ORDEN DE COMPRA DE PLAZA VEA  */
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
  /* CONTROL PARA EL LPN */
  FIND FIRST SupControlOC WHERE SupControlOC.codcia = s-codcia AND 
                                SupControlOC.CodDiv = s-CodDiv AND
                                SupControlOC.CodCli = lCodCli  AND 
                                SupControlOC.OrdCmp = lOrdenGrabada NO-ERROR.
  IF NOT AVAILABLE SupControlOC THEN DO:
      CREATE SupControlOC.
        ASSIGN SupControlOC.Codcia = s-codcia
                SupControlOC.CodCli = lCodCli 
                SupControlOC.Ordcmp = lOrdenGrabada
                SupControlOC.FchPed = TODAY
                SupControlOC.coddiv = S-CODDIV
                SupControlOC.usuario = S-USER-ID
                SupControlOC.correlativo = 0
                SupControlOC.hora = string(TIME,"HH:MM:SS").
  END.

  /* Ic 10Feb2016 - Metodo de Pago Lista Express */
  IF s-TpoPed = "LF" THEN DO:
      DISABLE TRIGGERS FOR LOAD OF vtatabla.
      DEFINE BUFFER i-vtatabla FOR vtatabla.

      DEFINE VAR lxDescuentos AS DEC.    
      DEFINE VAR lxdsctosinigv AS DEC.

      /* Ic - 17Ene2018, ListaExpress desde IVERSA */
/*       IF TODAY > 01/01/2018 THEN DO:                                                                                     */
/*           IF AVAILABLE OpenCPedidos THEN DO:                                                                             */
/*               CREATE i-vtatabla.                                                                                         */
/*                   ASSIGN i-vtatabla.codcia = s-codcia                                                                    */
/*                           i-vtatabla.tabla = 'MTPGLSTEXPRS'                                                              */
/*                           i-vtatabla.llave_c1 = FacCPedi.NroPed                                                          */
/*                           i-vtatabla.llave_c2 = OpenCPedidos.nroped /*tt-MetodPagoListaExpress.tt-pedidoweb*/            */
/*                           i-vtatabla.llave_c3 = OpenCPedidos.nroref /*tt-MetodPagoListaExpress.tt-metodopago*/           */
/*                           i-vtatabla.llave_c5 = ""  /*tt-MetodPagoListaExpress.tt-tipopago                        */     */
/*                           i-vtatabla.llave_c4 = ""  /*tt-MetodPagoListaExpress.tt-nombreclie*/                           */
/*                           i-vtatabla.valor[1] = 0   /*tt-MetodPagoListaExpress.tt-preciopagado*/                         */
/*                           i-vtatabla.valor[2] = 0   /*tt-MetodPagoListaExpress.tt-preciounitario*/                       */
/*                           i-vtatabla.valor[3] = 0   /*tt-MetodPagoListaExpress.tt-costoenvio                          */ */
/*                           i-vtatabla.valor[4] = 0.   /*tt-MetodPagoListaExpress.tt-descuento.*/                          */
/*                                                                                                                          */
/*           END.                                                                                                           */
/*       END.                                                                                                               */

      lxDescuentos = 0.
      FOR EACH tt-MetodPagoListaExpress :        
          CREATE i-vtatabla.
              ASSIGN i-vtatabla.codcia = s-codcia
                      i-vtatabla.tabla = 'MTPGLSTEXPRS'
                      i-vtatabla.llave_c1 = FacCPedi.NroPed
                      i-vtatabla.llave_c2 = tt-MetodPagoListaExpress.tt-pedidoweb
                      i-vtatabla.llave_c3 = tt-MetodPagoListaExpress.tt-metodopago
                      i-vtatabla.llave_c5 = tt-MetodPagoListaExpress.tt-tipopago                        
                      i-vtatabla.llave_c4 = tt-MetodPagoListaExpress.tt-nombreclie
                      i-vtatabla.valor[1] = tt-MetodPagoListaExpress.tt-preciopagado
                      i-vtatabla.valor[2] = tt-MetodPagoListaExpress.tt-preciounitario
                      i-vtatabla.valor[3] = tt-MetodPagoListaExpress.tt-costoenvio
                      i-vtatabla.valor[4] = tt-MetodPagoListaExpress.tt-descuento.

                      lxDescuentos = lxDescuentos + i-vtatabla.valor[4].
      END.

      lxdsctosinigv = 0.
      IF lxDescuentos > 0  THEN DO:
            lxdsctosinigv = (lxDescuentos * 100) / 118.
      END.
      ASSIGN faccpedi.impdto2 = lxDescuentos
            faccpedi.importe[3] = lxdsctosinigv.

      RELEASE i-vtatabla.
      EMPTY TEMP-TABLE tt-MetodPagoListaExpress.
      /* *************************************************** */
      /* Creamos una copia del pedido completo sin modificar */
      /* *************************************************** */
      CREATE B-CPEDI.
      BUFFER-COPY Faccpedi
          TO B-CPEDI
          ASSIGN B-CPEDI.CodDoc = "CLE".    /* Cotizacion Lista Express */
      I-NITEM = 0.
      FOR EACH ITEM-LE BY ITEM-LE.NroItm:
          I-NITEM = I-NITEM + 1.
          CREATE FacDPedi.
          BUFFER-COPY ITEM-LE
              TO FacDPedi
              ASSIGN
                  FacDPedi.CodCia = B-CPEDI.CodCia
                  FacDPedi.CodDiv = B-CPEDI.CodDiv
                  FacDPedi.coddoc = B-CPEDI.coddoc
                  FacDPedi.NroPed = B-CPEDI.NroPed
                  FacDPedi.FchPed = B-CPEDI.FchPed
                  FacDPedi.Hora   = B-CPEDI.Hora 
                  FacDPedi.FlgEst = B-CPEDI.FlgEst
                  FacDPedi.NroItm = I-NITEM.
      END.
  END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE F-TOT AS DECIMAL INIT 0 NO-UNDO.
  DEFINE VARIABLE F-BOL AS DECIMAL INIT 0 NO-UNDO.

  DEFINE VAR ls-DiasVtoCot AS INT.
  DEFINE VAR lValidacionFeria AS LOG.
  DEFINE VAR lFechaDesde AS DATE.
  DEFINE VAR lFechaHasta AS DATE.
  DEFINE VAR lFechaControl AS DATE.
  DEFINE VAR lDias AS INT.
  DEFINE VAR lCotProcesada AS LOG.

  DEFINE VAR lUsrFchEnt AS CHAR.
  DEFINE VAR lValFecEntrega AS CHAR.

  DEFINE VAR lListaPrecio AS CHAR.
  
  DO WITH FRAME {&FRAME-NAME} :
      /* VALIDACION DEL CLIENTE */
      IF FacCPedi.CodCli:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Codigo de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO FacCPedi.CodCli.
         RETURN "ADM-ERROR".   
      END.
      IF s-ClientesVIP = YES THEN DO:
          RUN vtagn/p-clie-expo (Faccpedi.CodCli:SCREEN-VALUE , s-tpoped, pCodDiv).
          IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
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
     /* rhc 22.06.09 Control de Precios IBC */
     IF s-Import-IBC = YES THEN DO:
         RUN CONTROL-IBC.
         IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
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

     /* Ic - 28Ene2016, Para la VU (Vales Utilex, condicion de venta debe ser FAI */
     IF s-tpoped = 'VU' THEN DO:
         IF gn-convt.libre_l01 <> YES THEN DO:
             MESSAGE "Condicion Venta debe aceptar FAI" VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO FacCPedi.FmaPgo.
             RETURN "ADM-ERROR".   
         END.
     END.

     /* RHC 09/05/2014 SOLO condiciones de ventas válidas */
     IF gn-convt.Estado <> "A" THEN DO:
         MESSAGE "Condición Venta Inactiva" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO FacCPedi.FmaPgo.
         RETURN "ADM-ERROR".   
     END.
     /* RHC 12/11/2015 Correo de Susana León */
     IF INPUT FacCPedi.CodCli = x-ClientesVarios
         AND INPUT FacCPedi.FmaPgo <> '000'
         THEN DO:
         MESSAGE 'Solo se permite la Condición de Venta 000' VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO FacCPedi.CodCli.
         RETURN "ADM-ERROR".   
     END.
     /* ********************************************************** */
     /* RHC 13/11/2017 Limitación de la condición de venta Campaña */
     /* ********************************************************** */
     FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = pCodDiv
         NO-LOCK NO-ERROR.
     IF AVAILABLE gn-divi THEN DO:
         IF gn-ConVt.Libre_l02 = YES AND GN-DIVI.CanalVenta <> "FER" THEN DO:
             MESSAGE 'Condición de venta válida solo para EXPOLIBRERIAS' VIEW-AS ALERT-BOX ERROR.
             APPLY 'ENTRY':U TO FacCPedi.FmaPgo.
             RETURN 'ADM-ERROR'.
         END.
     END.
     /* ********************************************************** */
     /* RHC 21.08.2014 Control de FAI */
     FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.
     IF gn-convt.Libre_L01 = YES AND gn-divi.FlgRep = NO THEN DO:
         MESSAGE 'Condición de venta NO válida para esta división' VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO FacCPedi.FmaPgo.
         RETURN "ADM-ERROR".   
     END.
     /* Ic - 28Ene2016, Para la VU (Vales Utilex, la division debe aceptar FAI */
     IF s-tpoped = 'VU' THEN DO:
         IF gn-divi.FlgRep <> YES THEN DO:
             MESSAGE "La division debe aceptar FAI" VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO FacCPedi.FmaPgo.
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

    /* RHC 02/03/2016 Restricciones hasta el 31/03/2016 */
    {vta2/i-temporal-mayorista.i ITEM}
    /* ************************************************ */
    /* *********************************************************** */
    /* VALIDACION DE MONTO MINIMO POR BOLETA */
    /* Si es es BOL y no llega al monto mínimo blanqueamos el DNI */
    /* *********************************************************** */
    F-BOL = F-TOT.
    IF Faccpedi.Cmpbnte:SCREEN-VALUE = 'BOL' 
        AND F-BOL <= ImpMinDNI THEN FacCPedi.Atencion:SCREEN-VALUE = ''.
    DEF VAR cNroDni AS CHAR NO-UNDO.
    DEF VAR iLargo  AS INT NO-UNDO.
    DEF VAR cError  AS CHAR NO-UNDO.
    cNroDni = FacCPedi.Atencion:SCREEN-VALUE.
    IF Faccpedi.Cmpbnte:SCREEN-VALUE = 'BOL'AND F-BOL > ImpMinDNI THEN DO:
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
    END.
    /* *********************************************************** */
    /* *********************************************************** */
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
     /* Ic 26Oct2015 */
     RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
     IF RETURN-VALUE = 'YES' THEN DO:
         IF INPUT FacCPedi.FchEnt < TODAY THEN DO:
             MESSAGE 'La fecha de entrega debe ser mayor al de HOY' VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO FacCPedi.FchEnt.
             RETURN "ADM-ERROR".   
         END.
     END.
     /* RHC 14/02/2015 VALIDA FOTOCOPIAS */
     FOR EACH ITEM, FIRST Almmmatg OF ITEM NO-LOCK WHERE Almmmatg.codfam = '011':
         IF GN-DIVI.CanalVenta = 'TDA' AND Almmmatg.codfam = '011' AND gn-ConVt.TotDias > 45 THEN DO:
             MESSAGE 'NO se puede vender papel fotocopia a mas de 45 dias en SOLES' SKIP
                 VIEW-AS ALERT-BOX ERROR.
             RETURN "ADM-ERROR". 
         END.
     END.

     /* Ic - 26Oct2015 - Validar para FERIAS contra la Lista de Precios */ 
     ls-DiasVtoCot = s-DiasVtoCot.

     DEFINE BUFFER b-gn-divi FOR gn-divi.     
     IF faccpedi.libre_c01 <> ? THEN DO:
         FIND FIRST b-gn-divi WHERE b-gn-divi.coddiv = faccpedi.libre_c01 NO-LOCK NO-ERROR.
         IF AVAILABLE b-gn-divi THEN DO:
             ls-DiasVtoCot = b-GN-DIVI.DiasVtoCot.
         END.    
     END.
     RELEASE b-gn-divi.
     
     /* Ic - 06Nov2015 - Validar fecha de entrega no interfiera con
        la programacion de LUCY MESIA
     */

     DEFINE BUFFER b-factabla FOR factabla.
    /* Ic - Que usuarios no validar fecha de entrega */
     lUsrFchEnt = "".
     lValFecEntrega = ''.
     FIND FIRST b-factabla WHERE b-factabla.codcia = s-codcia AND 
                                b-factabla.tabla = 'VALIDA' AND 
                                b-factabla.codigo = 'FCHENT' NO-LOCK NO-ERROR.
    IF AVAILABLE b-factabla THEN DO:
        lUsrFchEnt      = b-factabla.campo-c[1].  /* Usuarios Exceptuados de la Validacion */
        lValFecEntrega  = b-factabla.campo-c[2].  /* Valida Si o NO */
    END.

    RELEASE b-factabla.

    IF lValFecEntrega = 'NO' OR LOOKUP(s-user-id,lusrFchEnt) > 0 THEN DO:
        RETURN "OK".
    END.

     lValidacionFeria = NO.
     lListaPrecio = IF(faccpedi.libre_c01 = ? OR faccpedi.libre_c01 = "") THEN pCodDiv ELSE faccpedi.libre_c01.
     IF lListaPrecio <> ? THEN DO:
         DEFINE BUFFER c-gn-divi FOR gn-divi.     
         FIND FIRST c-gn-divi WHERE c-gn-divi.coddiv = lListaPrecio NO-LOCK NO-ERROR.
         IF AVAILABLE c-gn-divi THEN DO:
             /* Si es FERIA */
             IF c-gn-divi.canalventa = 'FER' THEN DO:
                 lValidacionFeria = YES.
             END.
         END.
         RELEASE c-gn-divi.
     END.
     IF lValidacionFeria = YES THEN DO:
        /* Las fecha del PROCESO de Lucy mesia */
         lValidacionFeria = NO.
         FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                                    vtatabla.tabla = 'DSTRB' AND 
                                    vtatabla.llave_c1 = '2016' NO-LOCK NO-ERROR.
         IF AVAILABLE vtatabla THEN DO:
            lValidacionFeria = YES.
            lDias = vtatabla.valor[1].
            IF lDias = 0 THEN lDias = 1000. /* Sin Limite */
            lFechaDesde = vtatabla.rango_fecha[1].
            lFechaHasta = vtatabla.rango_fecha[2].
         END.
     END.

     DEFINE VAR lDiviExononeradas AS CHAR.

    /* Ic - 11Ene2017, solo para ferias de LIMA, segun E.Macchiu  */
    lDiviExononeradas = "10015,20015,00015,50015".
    IF LOOKUP(lListaPrecio,lDiviExononeradas) = 0 THEN lValidacionFeria = NO.

     IF lValidacionFeria = YES THEN DO:
         lCotProcesada = NO.        
         RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
         IF RETURN-VALUE = 'YES' THEN DO:
             /*lFechaControl = TODAY + lDias.*/
             lFechaControl = lFechaHasta.
             IF INPUT FacCPedi.FchEnt < lFechaControl THEN DO:
                 MESSAGE 'La fecha de entrega no debe estar dentro de la PROGRAMACION DE ABASTECIMIENTO(1) ' VIEW-AS ALERT-BOX ERROR.
                 APPLY "ENTRY" TO FacCPedi.FchEnt.
                 RETURN "ADM-ERROR".   
             END.    
             pFechaEntrega = INPUT FacCPedi.Fchent.
         END.
         ELSE DO:                
             /* Pregunta x el campo de RUBEN */
             IF faccpedi.libre_c02 = 'PROCESADA' THEN DO:
                lCotProcesada = YES.
             END.
             IF TODAY < 11/15/2015 THEN lCotProcesada = YES.
         END.
         lFechaControl = lFechaHasta.
         IF lCotProcesada = NO AND INPUT FacCPedi.FchEnt <> pFechaEntrega  THEN DO:
             IF INPUT FacCPedi.FchEnt <= lFechaControl THEN DO:
                 MESSAGE 'La fecha de entrega no debe estar dentro de la PROGRAMACION DE ABASTECIMIENTO(2) ' VIEW-AS ALERT-BOX ERROR.
                 RETURN "ADM-ERROR".   
             END.
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

DEFINE BUFFER b-divi FOR gn-divi.
DEFINE VAR RPTA AS CHAR.

IF NOT AVAILABLE FacCPedi THEN RETURN "ADM-ERROR".
IF LOOKUP(FacCPedi.FlgEst,"E,P,T,I") = 0 THEN DO:
    MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
IF FacCPedi.FchVen < TODAY THEN DO:
    MESSAGE 'Cotización venció el' faccpedi.fchven SKIP
        'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

/* RHC 05/10/2017 */
/* RHC Cesar Camus 13/10/17 Menos para ls divisiones 10060 y 10067 */
s-nivel-acceso = 1.     /* Permitido */
IF Faccpedi.Libre_c02 = "PROCESADO" AND LOOKUP(FacCPedi.CodDiv, '10060,10067') = 0 THEN DO:
    MESSAGE 'Cotización ya ha sido programada por ABASTECIMIENTOS' VIEW-AS ALERT-BOX WARNING.
    /*RETURN 'ADM-ERROR'.*/
    s-nivel-acceso = 0.     /* Bloqueado */
END.

/* Ic - 04Feb2016, las cotizaciones de ListaExpress son INMODIFICABLES */
IF s-tpoped = 'LF' AND Faccpedi.FlgEst = "P" THEN DO:
    MESSAGE 'Cotización de ListaExpress APROBADA' SKIP
        'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

/* Si tiene atenciones parciales tambien se bloquea */
FIND FIRST facdpedi OF faccpedi WHERE CanAte <> 0 NO-LOCK NO-ERROR.
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
    S-FmaPgo = FacCPedi.FmaPgo
    s-Copia-Registro = NO
    s-PorIgv = Faccpedi.porigv
    s-NroDec = (IF Faccpedi.Libre_d01 <= 0 THEN 4 ELSE Faccpedi.Libre_d01)
    s-FlgIgv = Faccpedi.FlgIgv
    s-Import-IBC    = NO
    s-Import-Cissac = NO
    s-Import-B2B    = NO
    s-adm-new-record = "NO"
    s-nroped = Faccpedi.nroped
    S-CMPBNTE = Faccpedi.Cmpbnte
    pFechaEntrega = Faccpedi.fchent
    S-TPOMARCO = Faccpedi.Libre_C04.    /* CASO DE CLIENTES EXCEPCIONALES */

IF FacCPedi.Libre_C05 = "1" THEN s-Import-Ibc       = YES.
IF FacCPedi.Libre_C05 = "2" THEN s-Import-Cissac    = YES.
IF FacCPedi.Libre_C05 = "3" THEN s-Import-B2B       = YES.

/* RHC 07/12/2015 SEGUNDO CHEQUEO */
IF (s-import-ibc = YES AND s-pendiente-ibc = YES) AND Faccpedi.flgest = 'P'
    THEN DO:
    MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
IF s-Import-B2B = YES AND Faccpedi.flgest = 'P' THEN DO:
    MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
IF FacCPedi.Libre_c04 = "SI" AND Faccpedi.flgest = 'P' THEN DO:
    MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
/* ****************************** */

RUN Carga-Temporal.
/* Cargamos las condiciones de venta válidas */
FIND gn-clie WHERE gn-clie.codcia  = cl-codcia
    AND gn-clie.codcli = s-codcli
    NO-LOCK.
RUN vta2/p-fmapgo (s-codcli, s-tpoped, OUTPUT s-cndvta-validos).

RUN Procesa-Handle IN lh_Handle ('Pagina2').
RUN Procesa-Handle IN lh_Handle ('browse').
RUN Procesa-Handle IN lh_handle ("Disable-Button-CISSAC").

/* RHC 14/10/2013 ***************************************************************** */
/* SOLO PARA PROVINCIAS VENTA LISTA GENERAL (LIMA)                                  */
IF s-TpoPed = "P" THEN DO:
  FIND b-divi WHERE b-divi.codcia = s-codcia
      AND b-divi.coddiv = pCodDiv
      NO-LOCK NO-ERROR.
  IF AVAILABLE b-divi AND b-divi.VentaMayorista = 1 THEN DO:  /* LISTA GENERAL */
      RUN Procesa-Handle IN lh_Handle ('Pagina3').
  END.
END.
/* ********************************************************************************/
IF s-TpoPed = "LF" THEN RUN Procesa-Handle IN lh_Handle ('Pagina4').

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fComision V-table-Win 
FUNCTION fComision RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  DEF VAR x-ImpComision AS DEC INIT 0 NO-UNDO.

  RUN vtagn/p-comision-por-producto (
      INPUT FacCPedi.FchPed,
      INPUT FacCPedi.CodDiv,
      INPUT FacCPedi.CodVen,
      INPUT FacCPedi.FmaPgo,
      INPUT FacDPedi.CodMat,
      INPUT FacDPedi.CanPed,
      INPUT (FacDPedi.ImpLin - FacDPedi.ImpIgv),
      INPUT FacCPedi.CodMon,
      OUTPUT x-ImpComision)
      .
  RETURN x-ImpComision.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

