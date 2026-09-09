&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE TEMP-TABLE Cabecera-FAC NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE Cabecera-FAI NO-UNDO LIKE CcbCDocu.
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE TEMP-TABLE Detalle NO-UNDO LIKE CcbDDocu
       FIELD CodMon LIKE Ccbcdocu.CodMon
       FIELD TpoCmb LIKE Ccbcdocu.TpoCmb.
DEFINE BUFFER GUIA FOR CcbCDocu.
DEFINE BUFFER PEDIDO FOR FacCPedi.
DEFINE TEMP-TABLE T-DESTINO NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.
DEFINE TEMP-TABLE T-ORIGEN NO-UNDO LIKE CcbCDocu.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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
DEF INPUT PARAMETER pParam AS CHAR.

IF LOOKUP(pParam, 'YES,NO,SI,NO,Sí,SÍ') = 0 THEN DO:
    MESSAGE 'El parámetro debe ser Si, Sí, No, YES, TRUE'
        VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.
/* Parameters Definitions ---                                           */
DEF VAR s-acceso-total AS LOG NO-UNDO.
s-acceso-total = LOGICAL(pParam).

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-CodDoc AS CHAR INIT 'FAC' NO-UNDO.
DEF VAR s-CodMov LIKE Facdocum.codmov NO-UNDO.
DEF VAR x-Moneda AS CHAR NO-UNDO.
DEF VAR iCountGuide AS INTEGER NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.

DEFINE VAR x-faltan-guias AS LOG.

FIND FacDocum WHERE FacDocum.CodCia = s-CodCia 
    AND FacDocum.CodDoc = s-CodDoc 
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacDocum OR FacDocum.CodMov = 0 THEN DO:
    MESSAGE
        "Codigo de Documento" s-CodDoc "no configurado" SKIP
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
s-CodMov = FacDocum.CodMov.

DEF VAR cOk AS LOG NO-UNDO.
cOk = NO.
FOR EACH FacCorre NO-LOCK WHERE 
    FacCorre.CodCia = s-CodCia AND
    FacCorre.CodDiv = s-CodDiv AND 
    FacCorre.CodDoc = s-CodDoc AND
    FacCorre.FlgEst = YES:
    /* SOLO ACEPTA LOS QUE NO ESTEN ASIGNADOS A UNA CAJA COBRANZA */
    FIND CcbDTerm WHERE CcbDTerm.CodCia = s-codcia
        AND CcbDTerm.CodDiv = s-coddiv
        AND CcbDTerm.CodDoc = s-CodDoc
        AND CcbDTerm.NroSer = FacCorre.NroSer
        NO-LOCK NO-ERROR.
    IF AVAILABLE CcbDTerm THEN DO:
        /* Verificamos la cabecera */
        FIND FIRST CcbCTerm OF CcbDTerm NO-LOCK NO-ERROR.
        IF AVAILABLE CcbCTerm THEN NEXT.
    END.
    cOk = YES.
END.
IF cOk = NO THEN DO:
    MESSAGE "Codigo de Documento" s-CodDoc "no configurado"
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

/* Control de InvoiceCustomerGroup */
DEF TEMP-TABLE T-INVOICE
    FIELD InvoiceCustomerGroup LIKE Faccpedi.InvoiceCustomerGroup
    FIELD DeliveryGroup LIKE Faccpedi.DeliveryGroup
    FIELD CodCli LIKE Faccpedi.CodCli.

DEF TEMP-TABLE T-CLIENTE
    FIELD CodCli LIKE Faccpedi.CodCli
    FIELD nomCli LIKE Faccpedi.nomCli.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-FormatoFAC  AS CHAR INIT '999-99999999' NO-UNDO.
DEF VAR x-FormatoGUIA AS CHAR INIT '999-999999' NO-UNDO.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-FormatoFAC).
RUN sunat\p-formato-doc (INPUT "G/R", OUTPUT x-FormatoGUIA).

FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.

DEFINE VAR x-articulo-ICBPER AS CHAR.
x-articulo-ICBPER = "099268".

DEFINE VAR x-Grupo AS CHAR NO-UNDO.
DEFINE VAR x-NroSer AS INT NO-UNDO.

DEF TEMP-TABLE Reporte
    FIELD Puntos AS INTE FORMAT '>>>9' LABEL 'Item'
    FIELD CodDoc AS CHAR FORMAT 'x(3)' LABEL 'Codigo'
    FIELD NroDoc AS CHAR FORMAT 'x(12)' LABEL 'Numero'
    FIELD FchDoc AS DATE FORMAT '99/99/9999' LABEL 'Fecha de Emision' 
    FIELD FchVto AS DATE FORMAT '99/99/9999' LABEL 'Fecha de salida'
    FIELD Moneda AS CHAR FORMAT 'x(10)' LABEL 'Moneda'
    FIELD ImpTot AS DECI FORMAT '>>>,>>>,>>9.99' LABEL 'Importe Total'
    FIELD InvoiceCustomerGroup AS CHAR FORMAT 'x(20)' LABEL 'Grupo de Factura de Cliente'
    FIELD CustomerPurchaseOrder AS CHAR FORMAT 'x(20)' LABEL 'Pedido Compra'
    FIELD CustomerRequest AS CHAR FORMAT 'x(20)' LABEL 'Solicitud Pedido'
    .

DEF TEMP-TABLE T-PECOS 
    FIELD DeliveryGroup LIKE FacCPedi.DeliveryGroup
    FIELD ordcmp LIKE FacCPedi.ordcmp
    FIELD OfficeCustomer LIKE FacCPedi.OfficeCustomer
    FIELD codmat LIKE FacDPedi.codmat
    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-DESTINO

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-DESTINO CcbCDocu PEDIDO COTIZACION ~
T-ORIGEN

/* Definitions for BROWSE BROWSE-DESTINO                                */
&Scoped-define FIELDS-IN-QUERY-BROWSE-DESTINO T-DESTINO.CodDoc ~
T-DESTINO.NroDoc T-DESTINO.FchDoc T-DESTINO.FchVto ~
fCentrar(COTIZACION.DeliveryGroup)  @ x-Grupo ~
COTIZACION.CustomerPurchaseOrder T-DESTINO.NroRef CcbCDocu.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-DESTINO 
&Scoped-define QUERY-STRING-BROWSE-DESTINO FOR EACH T-DESTINO NO-LOCK, ~
      FIRST CcbCDocu OF T-DESTINO NO-LOCK, ~
      FIRST PEDIDO WHERE PEDIDO.CodCia = CcbCDocu.CodCia ~
  AND PEDIDO.CodDoc = CcbCDocu.CodPed ~
  AND PEDIDO.NroPed = CcbCDocu.NroPed NO-LOCK, ~
      FIRST COTIZACION WHERE COTIZACION.CodCia = PEDIDO.CodCia ~
  AND COTIZACION.CodDoc = PEDIDO.CodRef ~
  AND COTIZACION.NroPed = PEDIDO.NroRef NO-LOCK ~
    BY COTIZACION.DeliveryGroup ~
       BY COTIZACION.CustomerPurchaseOrder INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-DESTINO OPEN QUERY BROWSE-DESTINO FOR EACH T-DESTINO NO-LOCK, ~
      FIRST CcbCDocu OF T-DESTINO NO-LOCK, ~
      FIRST PEDIDO WHERE PEDIDO.CodCia = CcbCDocu.CodCia ~
  AND PEDIDO.CodDoc = CcbCDocu.CodPed ~
  AND PEDIDO.NroPed = CcbCDocu.NroPed NO-LOCK, ~
      FIRST COTIZACION WHERE COTIZACION.CodCia = PEDIDO.CodCia ~
  AND COTIZACION.CodDoc = PEDIDO.CodRef ~
  AND COTIZACION.NroPed = PEDIDO.NroRef NO-LOCK ~
    BY COTIZACION.DeliveryGroup ~
       BY COTIZACION.CustomerPurchaseOrder INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-DESTINO T-DESTINO CcbCDocu PEDIDO ~
COTIZACION
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-DESTINO T-DESTINO
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-DESTINO CcbCDocu
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-DESTINO PEDIDO
&Scoped-define FOURTH-TABLE-IN-QUERY-BROWSE-DESTINO COTIZACION


/* Definitions for BROWSE BROWSE-ORIGEN                                 */
&Scoped-define FIELDS-IN-QUERY-BROWSE-ORIGEN T-ORIGEN.CodDoc ~
T-ORIGEN.NroDoc T-ORIGEN.FchDoc T-ORIGEN.FchVto ~
fCentrar(COTIZACION.DeliveryGroup)  @ x-Grupo ~
COTIZACION.CustomerPurchaseOrder T-ORIGEN.NroRef CcbCDocu.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-ORIGEN 
&Scoped-define QUERY-STRING-BROWSE-ORIGEN FOR EACH T-ORIGEN NO-LOCK, ~
      FIRST CcbCDocu OF T-ORIGEN NO-LOCK, ~
      FIRST PEDIDO WHERE PEDIDO.CodCia = CcbCDocu.CodCia ~
  AND PEDIDO.CodDoc = CcbCDocu.CodPed ~
  AND PEDIDO.NroPed  = CcbCDocu.NroPed NO-LOCK, ~
      FIRST COTIZACION WHERE COTIZACION.CodCia = PEDIDO.CodCia ~
  AND COTIZACION.CodDoc = PEDIDO.CodRef ~
  AND COTIZACION.NroPed = PEDIDO.NroRef NO-LOCK ~
    BY COTIZACION.DeliveryGroup ~
       BY COTIZACION.CustomerPurchaseOrder
&Scoped-define OPEN-QUERY-BROWSE-ORIGEN OPEN QUERY BROWSE-ORIGEN FOR EACH T-ORIGEN NO-LOCK, ~
      FIRST CcbCDocu OF T-ORIGEN NO-LOCK, ~
      FIRST PEDIDO WHERE PEDIDO.CodCia = CcbCDocu.CodCia ~
  AND PEDIDO.CodDoc = CcbCDocu.CodPed ~
  AND PEDIDO.NroPed  = CcbCDocu.NroPed NO-LOCK, ~
      FIRST COTIZACION WHERE COTIZACION.CodCia = PEDIDO.CodCia ~
  AND COTIZACION.CodDoc = PEDIDO.CodRef ~
  AND COTIZACION.NroPed = PEDIDO.NroRef NO-LOCK ~
    BY COTIZACION.DeliveryGroup ~
       BY COTIZACION.CustomerPurchaseOrder.
&Scoped-define TABLES-IN-QUERY-BROWSE-ORIGEN T-ORIGEN CcbCDocu PEDIDO ~
COTIZACION
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-ORIGEN T-ORIGEN
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-ORIGEN CcbCDocu
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-ORIGEN PEDIDO
&Scoped-define FOURTH-TABLE-IN-QUERY-BROWSE-ORIGEN COTIZACION


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-DESTINO}~
    ~{&OPEN-QUERY-BROWSE-ORIGEN}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-ORIGEN BUTTON-1 COMBO-BOX-Clientes ~
FILL-IN-FchSal-1 FILL-IN-FchSal-2 COMBO-NroSer BUTTON-Filtrar ~
BUTTON-Exportar Btn_OK BtnDone BUTTON-2 COMBO-BOX-grupo BUTTON-12 RECT-2 ~
RECT-3 BROWSE-DESTINO 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Items FILL-IN-Total ~
COMBO-BOX-Clientes FILL-IN-FchSal-1 FILL-IN-FchSal-2 COMBO-NroSer ~
FILL-IN-NroDoc FILL-IN-Division COMBO-BOX-grupo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCentrar W-Win 
FUNCTION fCentrar RETURNS CHARACTER
  ( INPUT pParam AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "&Done" 
     SIZE 12 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     IMAGE-INSENSITIVE FILE "adeicon\unprog.ico":U
     LABEL "&Aceptar" 
     SIZE 12 BY 1.54.

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/right.ico":U
     LABEL ">" 
     SIZE 10 BY 1.62 TOOLTIP "Solo los seleccionados"
     FONT 8.

DEFINE BUTTON BUTTON-12 
     LABEL "Refrescar Clientes" 
     SIZE 14 BY .77.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/left.ico":U
     LABEL "<" 
     SIZE 10 BY 1.62 TOOLTIP "Solo los seleccionados"
     FONT 8.

DEFINE BUTTON BUTTON-Exportar 
     LABEL "EXPORTAR A TEXTO" 
     SIZE 20 BY 1.12.

DEFINE BUTTON BUTTON-Filtrar 
     LABEL "APLICAR FILTROS" 
     SIZE 20 BY 1.12.

DEFINE VARIABLE COMBO-BOX-Clientes AS CHARACTER FORMAT "X(256)":U INITIAL "Seleccione un cliente" 
     LABEL "Cliente" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Seleccione un cliente","Seleccione un cliente"
     DROP-DOWN-LIST
     SIZE 69 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-grupo AS CHARACTER FORMAT "X(25)":U 
     LABEL "Grupo de Reparto" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1
     FONT 10 NO-UNDO.

DEFINE VARIABLE COMBO-NroSer AS CHARACTER FORMAT "X(3)":U 
     LABEL "Serie FAC" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 6.72 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Division AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 69 BY 1
     BGCOLOR 6 FGCOLOR 15 FONT 10 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchSal-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha emision FAIs  - Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchSal-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Items AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "TOTAL POSICIONES" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 2 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "XXX-XXXXXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 13.57 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-Total AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "TOTAL IMPORTE" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 14 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 174 BY 1.92
     BGCOLOR 6 FGCOLOR 15 .

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 174 BY 3.5
     BGCOLOR 15 FGCOLOR 0 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-DESTINO FOR 
      T-DESTINO, 
      CcbCDocu, 
      PEDIDO, 
      COTIZACION SCROLLING.

DEFINE QUERY BROWSE-ORIGEN FOR 
      T-ORIGEN, 
      CcbCDocu, 
      PEDIDO, 
      COTIZACION SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-DESTINO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-DESTINO W-Win _STRUCTURED
  QUERY BROWSE-DESTINO NO-LOCK DISPLAY
      T-DESTINO.CodDoc COLUMN-LABEL "Cod." FORMAT "x(3)":U
      T-DESTINO.NroDoc COLUMN-LABEL "FAI" FORMAT "X(12)":U
      T-DESTINO.FchDoc COLUMN-LABEL "Fch. FAI" FORMAT "99/99/9999":U
      T-DESTINO.FchVto COLUMN-LABEL "Fecha de!Salida" FORMAT "99/99/9999":U
      fCentrar(COTIZACION.DeliveryGroup)  @ x-Grupo COLUMN-LABEL "Grupo de Reparto!de Cliente" FORMAT "x(20)":U
      COTIZACION.CustomerPurchaseOrder FORMAT "x(15)":U
      T-DESTINO.NroRef COLUMN-LABEL "G/R" FORMAT "X(12)":U
      CcbCDocu.ImpTot FORMAT "->>,>>>,>>9.99":U WIDTH 10.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 80 BY 18.31
         FONT 4
         TITLE "FAI's LISTOS PARA FACTURAR" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-ORIGEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-ORIGEN W-Win _STRUCTURED
  QUERY BROWSE-ORIGEN NO-LOCK DISPLAY
      T-ORIGEN.CodDoc COLUMN-LABEL "Cod." FORMAT "x(3)":U
      T-ORIGEN.NroDoc COLUMN-LABEL "FAI" FORMAT "X(12)":U
      T-ORIGEN.FchDoc COLUMN-LABEL "Fch. FAI" FORMAT "99/99/9999":U
            WIDTH 7.29
      T-ORIGEN.FchVto COLUMN-LABEL "Fecha de!Salida" FORMAT "99/99/9999":U
      fCentrar(COTIZACION.DeliveryGroup)  @ x-Grupo COLUMN-LABEL "Grupo de Reparto!de Cliente" FORMAT "x(20)":U
      COTIZACION.CustomerPurchaseOrder FORMAT "x(15)":U
      T-ORIGEN.NroRef COLUMN-LABEL "G/R" FORMAT "X(12)":U
      CcbCDocu.ImpTot FORMAT "->>,>>>,>>9.99":U WIDTH 10.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 79 BY 19.12
         FONT 4
         TITLE "SELECCIONE UNO O MAS FAI's" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-ORIGEN AT ROW 6.38 COL 2 WIDGET-ID 200
     FILL-IN-Items AT ROW 24.96 COL 119 COLON-ALIGNED WIDGET-ID 56
     BUTTON-1 AT ROW 9.62 COL 83 WIDGET-ID 50
     FILL-IN-Total AT ROW 24.96 COL 160 COLON-ALIGNED WIDGET-ID 54
     COMBO-BOX-Clientes AT ROW 3.15 COL 20 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-FchSal-1 AT ROW 4.23 COL 41.57 COLON-ALIGNED WIDGET-ID 42
     FILL-IN-FchSal-2 AT ROW 4.23 COL 60 COLON-ALIGNED WIDGET-ID 44
     COMBO-NroSer AT ROW 5.31 COL 14.43 WIDGET-ID 28
     FILL-IN-NroDoc AT ROW 5.38 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     FILL-IN-Division AT ROW 1.54 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     BUTTON-Filtrar AT ROW 3.88 COL 113 WIDGET-ID 38
     BUTTON-Exportar AT ROW 4.96 COL 113 WIDGET-ID 48
     Btn_OK AT ROW 4.5 COL 151 WIDGET-ID 32
     BtnDone AT ROW 4.5 COL 163 WIDGET-ID 34
     BUTTON-2 AT ROW 11.77 COL 83 WIDGET-ID 52
     COMBO-BOX-grupo AT ROW 5.27 COL 57.86 COLON-ALIGNED WIDGET-ID 58
     BUTTON-12 AT ROW 4.27 COL 77 WIDGET-ID 60
     BROWSE-DESTINO AT ROW 6.38 COL 96 WIDGET-ID 300
     RECT-2 AT ROW 1 COL 2 WIDGET-ID 10
     RECT-3 AT ROW 2.88 COL 2 WIDGET-ID 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 175.43 BY 25.04
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: Cabecera-FAC T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: Cabecera-FAI T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: Detalle T "?" NO-UNDO INTEGRAL CcbDDocu
      ADDITIONAL-FIELDS:
          FIELD CodMon LIKE Ccbcdocu.CodMon
          FIELD TpoCmb LIKE Ccbcdocu.TpoCmb
      END-FIELDS.
      TABLE: GUIA B "?" ? INTEGRAL CcbCDocu
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
      TABLE: T-DESTINO T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
      TABLE: T-ORIGEN T "?" NO-UNDO INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "GENERACION DE COMPROBANTES POR FAI's x GRUPO DE REPARTO"
         HEIGHT             = 25.04
         WIDTH              = 175.43
         MAX-HEIGHT         = 26.15
         MAX-WIDTH          = 191.29
         VIRTUAL-HEIGHT     = 26.15
         VIRTUAL-WIDTH      = 191.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-ORIGEN 1 F-Main */
/* BROWSE-TAB BROWSE-DESTINO RECT-3 F-Main */
/* SETTINGS FOR COMBO-BOX COMBO-NroSer IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-Division IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Items IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Total IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-DESTINO
/* Query rebuild information for BROWSE BROWSE-DESTINO
     _TblList          = "Temp-Tables.T-DESTINO,INTEGRAL.CcbCDocu OF Temp-Tables.T-DESTINO,PEDIDO WHERE INTEGRAL.CcbCDocu ...,COTIZACION WHERE PEDIDO ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST, FIRST, FIRST, FIRST OUTER"
     _OrdList          = "INTEGRAL.COTIZACION.DeliveryGroup|yes,INTEGRAL.COTIZACION.CustomerPurchaseOrder|yes"
     _JoinCode[3]      = "PEDIDO.CodCia = INTEGRAL.CcbCDocu.CodCia
  AND PEDIDO.CodDoc = INTEGRAL.CcbCDocu.CodPed
  AND PEDIDO.NroPed = INTEGRAL.CcbCDocu.NroPed"
     _JoinCode[4]      = "COTIZACION.CodCia = PEDIDO.CodCia
  AND COTIZACION.CodDoc = PEDIDO.CodRef
  AND COTIZACION.NroPed = PEDIDO.NroRef"
     _FldNameList[1]   > Temp-Tables.T-DESTINO.CodDoc
"T-DESTINO.CodDoc" "Cod." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-DESTINO.NroDoc
"T-DESTINO.NroDoc" "FAI" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-DESTINO.FchDoc
"T-DESTINO.FchDoc" "Fch. FAI" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-DESTINO.FchVto
"T-DESTINO.FchVto" "Fecha de!Salida" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fCentrar(COTIZACION.DeliveryGroup)  @ x-Grupo" "Grupo de Reparto!de Cliente" "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.COTIZACION.CustomerPurchaseOrder
"COTIZACION.CustomerPurchaseOrder" ? "x(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-DESTINO.NroRef
"T-DESTINO.NroRef" "G/R" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.CcbCDocu.ImpTot
"CcbCDocu.ImpTot" ? ? "decimal" ? ? ? ? ? ? no ? no no "10.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-DESTINO */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-ORIGEN
/* Query rebuild information for BROWSE BROWSE-ORIGEN
     _TblList          = "Temp-Tables.T-ORIGEN,INTEGRAL.CcbCDocu OF Temp-Tables.T-ORIGEN,PEDIDO WHERE INTEGRAL.CcbCDocu ...,COTIZACION WHERE PEDIDO ..."
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST, FIRST, FIRST, FIRST OUTER"
     _OrdList          = "INTEGRAL.COTIZACION.DeliveryGroup|yes,INTEGRAL.COTIZACION.CustomerPurchaseOrder|yes"
     _JoinCode[3]      = "PEDIDO.CodCia = INTEGRAL.CcbCDocu.CodCia
  AND PEDIDO.CodDoc = INTEGRAL.CcbCDocu.CodPed
  AND PEDIDO.NroPed  = INTEGRAL.CcbCDocu.NroPed"
     _JoinCode[4]      = "COTIZACION.CodCia = PEDIDO.CodCia
  AND COTIZACION.CodDoc = PEDIDO.CodRef
  AND COTIZACION.NroPed = PEDIDO.NroRef"
     _FldNameList[1]   > Temp-Tables.T-ORIGEN.CodDoc
"T-ORIGEN.CodDoc" "Cod." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-ORIGEN.NroDoc
"T-ORIGEN.NroDoc" "FAI" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-ORIGEN.FchDoc
"T-ORIGEN.FchDoc" "Fch. FAI" ? "date" ? ? ? ? ? ? no ? no no "7.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-ORIGEN.FchVto
"T-ORIGEN.FchVto" "Fecha de!Salida" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fCentrar(COTIZACION.DeliveryGroup)  @ x-Grupo" "Grupo de Reparto!de Cliente" "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.COTIZACION.CustomerPurchaseOrder
"COTIZACION.CustomerPurchaseOrder" ? "x(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-ORIGEN.NroRef
"T-ORIGEN.NroRef" "G/R" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.CcbCDocu.ImpTot
"CcbCDocu.ImpTot" ? ? "decimal" ? ? ? ? ? ? no ? no no "10.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-ORIGEN */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* GENERACION DE COMPROBANTES POR FAI's x GRUPO DE REPARTO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* GENERACION DE COMPROBANTES POR FAI's x GRUPO DE REPARTO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
    ASSIGN
         COMBO-NroSer FILL-IN-Division FILL-IN-NroDoc COMBO-BOX-Clientes.
    ASSIGN FILL-IN-Items.

    IF x-faltan-guias = YES THEN DO:
        MESSAGE "Existen FAI(s) sin Guias de Remision" SKIP 
                "Imposible generar FACTURA(s)" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    IF FILL-IN-Items > 1000 THEN DO:
        MESSAGE 'Ha superado los 1000 POSICIONES' SKIP
            'Continuamos con la facturación?'
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.
    END.
    IF FILL-IN-Division BEGINS 'Seleccione' THEN RETURN NO-APPLY.

    MESSAGE "Se va aproceder a facturar" SKIP "¿Todos los datos son correctos?"
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE rpta-2 AS LOGICAL.
    IF rpta-2 <> TRUE THEN RETURN NO-APPLY.

    /* UN SOLO PROCESO */
    pMensaje = "".
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Generacion-de-Factura ( INPUT COMBO-NroSer,
                                OUTPUT pMensaje,
                                OUTPUT iCountGuide).
    SESSION:SET-WAIT-STATE('').
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    ELSE DO:
        MESSAGE "Se ha(n) generado" iCountGuide "Factura(s)"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        COMBO-BOX-Clientes = "Seleccione un cliente".
        DISPLAY COMBO-BOX-Clientes WITH FRAME {&FRAME-NAME}.
        APPLY 'VALUE-CHANGED':U TO COMBO-BOX-Clientes.
        APPLY 'CHOOSE':U TO BUTTON-Filtrar.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* > */
DO:
  DEF VAR k AS INT NO-UNDO.
  DO k = 1 TO BROWSE-ORIGEN:NUM-SELECTED-ROWS:
      IF BROWSE-ORIGEN:FETCH-SELECTED-ROW(k) THEN DO:
          CREATE T-DESTINO.
          BUFFER-COPY T-ORIGEN TO T-DESTINO.
          DELETE T-ORIGEN.
      END.
  END.
  {&OPEN-QUERY-BROWSE-ORIGEN}
  {&OPEN-QUERY-BROWSE-DESTINO}
  RUN Importe-total.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-12 W-Win
ON CHOOSE OF BUTTON-12 IN FRAME F-Main /* Refrescar Clientes */
DO:
    ASSIGN fill-in-FchSal-1 fill-in-FchSal-2.

    IF fill-in-FchSal-1 = ? OR fill-in-FchSal-2 = ? THEN DO:
        MESSAGE "Ingrese rango de fechas correctamente".
        RETURN NO-APPLY.
    END.
    IF fill-in-FchSal-1 > fill-in-FchSal-2 THEN DO:
        MESSAGE "El rango de fechas es incorrecto".
        RETURN NO-APPLY.
    END.

    RUN refresca-parametros.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* < */
DO:
  DEF VAR k AS INT NO-UNDO.
  DO k = 1 TO BROWSE-DESTINO:NUM-SELECTED-ROWS:
      IF BROWSE-DESTINO:FETCH-SELECTED-ROW(k) THEN DO:
          CREATE T-ORIGEN.
          BUFFER-COPY T-DESTINO TO T-ORIGEN.
          DELETE T-DESTINO.
      END.
  END.
  {&OPEN-QUERY-BROWSE-ORIGEN}
  {&OPEN-QUERY-BROWSE-DESTINO}
  RUN Importe-total.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Exportar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Exportar W-Win
ON CHOOSE OF BUTTON-Exportar IN FRAME F-Main /* EXPORTAR A TEXTO */
DO:
  RUN Texto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Filtrar W-Win
ON CHOOSE OF BUTTON-Filtrar IN FRAME F-Main /* APLICAR FILTROS */
DO:
    ASSIGN COMBO-BOX-Clientes COMBO-NroSer
        FILL-IN-FchSal-1 FILL-IN-FchSal-2 combo-box-grupo.

    IF FILL-IN-FchSal-1 = ? OR FILL-IN-FchSal-2 = ? THEN DO:
        MESSAGE 'No ha ingresado todos los rangos de fecha' SKIP
            VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.

    RUN Carga-Temporal ( INPUT COMBO-BOX-Clientes /* CHARACTER */,
      INPUT FILL-IN-FchSal-1 /* DATE */,
      INPUT FILL-IN-FchSal-2 /* DATE */).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Clientes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Clientes W-Win
ON VALUE-CHANGED OF COMBO-BOX-Clientes IN FRAME F-Main /* Cliente */
DO:
    ASSIGN COMBO-BOX-Clientes.

    /* Grupo de Reparto */
    REPEAT WHILE COMBO-BOX-grupo:NUM-ITEMS > 0:
        COMBO-BOX-grupo:DELETE(1).
    END.

    COMBO-BOX-grupo:SCREEN-VALUE = "".
    FOR EACH T-INVOICE NO-LOCK WHERE T-INVOICE.codcli = COMBO-BOX-Clientes : 
        /*
        combo-box-grupo:ADD-LAST(TRIM(T-INVOICE.InvoiceCustomerGroup)).
        IF TRUE <> (COMBO-BOX-grupo:SCREEN-VALUE > "") THEN COMBO-BOX-grupo:SCREEN-VALUE = TRIM(T-INVOICE.InvoiceCustomerGroup).
        */
        combo-box-grupo:ADD-LAST(TRIM(T-INVOICE.DeliveryGroup)).
        IF TRUE <> (COMBO-BOX-grupo:SCREEN-VALUE > "") THEN COMBO-BOX-grupo:SCREEN-VALUE = TRIM(T-INVOICE.DeliveryGroup).

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer W-Win
ON RETURN OF COMBO-NroSer IN FRAME F-Main /* Serie FAC */
DO:
    APPLY 'Tab':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer W-Win
ON VALUE-CHANGED OF COMBO-NroSer IN FRAME F-Main /* Serie FAC */
DO:
    /* Correlativo */
    FIND FacCorre WHERE FacCorre.CodCia = s-CodCia AND
        FacCorre.CodDoc = s-CodDoc AND
        FacCorre.CodDiv = s-CodDiv AND
        FacCorre.NroSer = INTEGER(SELF:SCREEN-VALUE)
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacCorre THEN 
        FILL-IN-NroDoc = STRING(FacCorre.NroSer,ENTRY(1,x-FormatoFAC,'-')) + 
                        STRING(FacCorre.Correlativo,ENTRY(2,x-FormatoFAC,'-')).
    ELSE FILL-IN-NroDoc = "".
    DISPLAY FILL-IN-NroDoc WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-DESTINO
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Cancelacion W-Win 
PROCEDURE Carga-Cancelacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-ImpTot AS DEC NO-UNDO.
FOR EACH Cabecera-FAI:
    Cabecera-FAI.SdoAct = Cabecera-FAI.ImpTot.
END.

FOR EACH Cabecera-FAC NO-LOCK:      /* Realmente solo es una factura */
    x-ImpTot = Cabecera-FAC.ImpTot.
    FOR EACH Cabecera-FAI EXCLUSIVE-LOCK WHERE Cabecera-FAI.SdoAct > 0:
        CREATE Ccbdcaja.
        ASSIGN
            CcbDCaja.CodCia = s-codcia
            CcbDCaja.CodDiv = s-coddiv
            CcbDCaja.CodDoc = Cabecera-FAC.coddoc
            CcbDCaja.NroDoc = Cabecera-FAC.nrodoc
            CcbDCaja.CodRef = Cabecera-FAI.coddoc
            CcbDCaja.NroRef = Cabecera-FAI.nrodoc
            CcbDCaja.CodCli = Cabecera-FAI.CodCli
            CcbDCaja.CodMon = Cabecera-FAI.codmon
            CcbDCaja.FchDoc = Cabecera-FAC.fchdoc
            CcbDCaja.ImpTot = MINIMUM(x-ImpTot, Cabecera-FAI.sdoact)
            CcbDCaja.TpoCmb = Cabecera-FAI.tpocmb.
        ASSIGN
            Cabecera-FAI.sdoact = Cabecera-FAI.sdoact - Ccbdcaja.imptot
            x-ImpTot = x-ImpTot - Ccbdcaja.imptot.
        IF x-ImpTot <= 0 THEN LEAVE.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Comprobantes W-Win 
PROCEDURE Carga-Comprobantes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT-OUTPUT PARAMETER iCountGuide AS INT NO-UNDO.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR lCreaHeader AS LOG NO-UNDO.
DEF VAR lItemOk AS LOG NO-UNDO.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR s-CodDoc AS CHAR INIT 'FAC' NO-UNDO.
DEF VAR x-FormatoFAC  AS CHAR INIT '999-99999999' NO-UNDO.
DEF VAR x-FormatoGUIA AS CHAR INIT '999-999999' NO-UNDO.
DEF VAR iCountItem AS INT NO-UNDO.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-FormatoFAC).
RUN sunat\p-formato-doc (INPUT "G/R", OUTPUT x-FormatoGUIA).

FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.

trloop:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /*iCountGuide = 0.*/
    lCreaHeader = TRUE.
    lItemOk = FALSE.
    iCountItem = 1.
    /* Correlativo */
    {lib/lock-genericov3.i ~
        &Tabla="FacCorre" ~
        &Condicion="FacCorre.CodCia = s-CodCia AND ~
        FacCorre.CodDoc = s-CodDoc AND ~
        FacCorre.CodDiv = s-CodDiv AND ~
        FacCorre.NroSer = x-NroSer" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje= "pMensaje" ~
        &TipoError="UNDO TRLOOP, RETURN 'ADM-ERROR'"}
    FOR EACH Detalle , FIRST Almmmatg OF Detalle NO-LOCK BREAK BY Detalle.CodCia:
        /* Crea Cabecera */
        IF lCreaHeader THEN DO:
            /* Cabecera de Guía */
            FIND FIRST Cabecera-FAI.    /* Se toma el primero como plantilla */
            CREATE CcbCDocu.
            BUFFER-COPY Cabecera-FAI TO Ccbcdocu
                ASSIGN
                CcbCDocu.CodCia = s-codcia
                CcbCDocu.CodDiv = s-coddiv
                CcbCDocu.CodDoc = s-CodDoc
                CcbCDocu.NroDoc =  STRING(FacCorre.NroSer,ENTRY(1,x-FormatoFAC,'-')) + 
                            STRING(FacCorre.Correlativo,ENTRY(2,x-FormatoFAC,'-')) 
                CcbCDocu.FchDoc = TODAY
                CcbCDocu.FchVto = TODAY
                CcbCDocu.FlgEst = "P"
                CcbCDocu.Tipo   = "CREDITO"
                CcbCDocu.usuario = S-USER-ID
                CcbCDocu.HorCie = STRING(TIME,'hh:mm')
                CcbCDocu.CodMon = Detalle.CodMon
                CcbCDocu.TpoCmb = Detalle.TpoCmb
                NO-ERROR.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                {lib/mensaje-de-error.i &MensajeError="pMensaje"}
                UNDO TRLOOP, RETURN 'ADM-ERROR'.
            END.
            ASSIGN
                CcbCDocu.TpoFac = "F"       /* POR FAI */
                Ccbcdocu.CodRef = "FAI"
                Ccbcdocu.NroRef = "".
            /* RHC 18/06/2020 NO va la referencia porque supera la capacidad del campo */
/*             FOR EACH Cabecera-FAI:                                                                                                */
/*                 Ccbcdocu.NroRef = Ccbcdocu.NroRef + (IF (TRUE <> (Ccbcdocu.NroRef > '')) THEN '' ELSE '|') + Cabecera-FAI.NroDoc. */
/*             END.                                                                                                                  */
            /* SOLO UNA GUIA */
            ASSIGN
                FacCorre.Correlativo = FacCorre.Correlativo + 1.
            /*RDP*/    
            FIND gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
            IF AVAILABLE gn-convt THEN DO:
                CcbCDocu.TipVta = IF gn-ConVt.TotDias = 0 THEN "1" ELSE "2".
                CcbCDocu.FchVto = CcbCDocu.FchDoc + INTEGER(ENTRY(NUM-ENTRIES(gn-ConVt.Vencmtos),gn-ConVt.Vencmtos)).
            END.
            /* **************** */
            ASSIGN
                iCountGuide = iCountGuide + 1
                lCreaHeader = FALSE.
            
            DEFINE BUFFER b-controlOD FOR controlOD.
            DEFINE VAR lRowId AS ROWID.

            /* Ic - 16Set2016, Actualizar el ControlOD del LPN de Plaza Vea */
            FOR EACH controlOD WHERE controlOD.codcia = s-codcia AND 
                controlOD.codcli = ccbcdocu.codcli AND 
                controlOD.OrdCmp = ccbcdocu.nroord NO-LOCK :
                lRowId = ROWID(controlOD).
                FIND FIRST b-controlOD WHERE ROWID(b-controlOD) = lRowId EXCLUSIVE NO-ERROR.
                IF AVAILABLE b-controlOD THEN DO:
                    ASSIGN
                        b-controlOD.nrofac = ccbcdocu.nrodoc
                        b-controlOD.fchfac = CcbCDocu.FchDoc
                        b-controlOD.usrfac = CcbCDocu.usuario.
                END.
            END.
            RELEASE b-controlOD.
        END.
        /* Crea Detalle */
        CREATE CcbDDocu.
        BUFFER-COPY Detalle 
            TO CcbDDocu
            ASSIGN
            CcbDDocu.NroItm = iCountItem
            CcbDDocu.CodCia = CcbCDocu.CodCia
            CcbDDocu.CodDiv = CcbcDocu.CodDiv
            CcbDDocu.Coddoc = CcbCDocu.Coddoc
            CcbDDocu.NroDoc = CcbCDocu.NroDoc 
            CcbDDocu.FchDoc = CcbCDocu.FchDoc.
        /* CORREGIMOS IMPORTES */
        ASSIGN
            Ccbddocu.ImpLin = ROUND ( Ccbddocu.CanDes * Ccbddocu.PreUni * 
                                      ( 1 - Ccbddocu.Por_Dsctos[1] / 100 ) *
                                      ( 1 - Ccbddocu.Por_Dsctos[2] / 100 ) *
                                      ( 1 - Ccbddocu.Por_Dsctos[3] / 100 ), 2 ).
        IF Ccbddocu.Por_Dsctos[1] = 0 AND Ccbddocu.Por_Dsctos[2] = 0 AND Ccbddocu.Por_Dsctos[3] = 0 
            THEN Ccbddocu.ImpDto = 0.
        ELSE Ccbddocu.ImpDto = Ccbddocu.CanDes * Ccbddocu.PreUni - Ccbddocu.ImpLin.
        ASSIGN
            Ccbddocu.ImpLin = ROUND(Ccbddocu.ImpLin, 2)
            Ccbddocu.ImpDto = ROUND(Ccbddocu.ImpDto, 2).
        IF Ccbddocu.AftIsc 
            THEN Ccbddocu.ImpIsc = ROUND(Ccbddocu.PreBas * Ccbddocu.CanDes * (Almmmatg.PorIsc / 100),4).
        ELSE Ccbddocu.ImpIsc = 0.
        IF Ccbddocu.AftIgv 
            THEN Ccbddocu.ImpIgv = Ccbddocu.ImpLin - ROUND( Ccbddocu.ImpLin  / ( 1 + (Ccbcdocu.PorIgv / 100) ), 4 ).
        ELSE Ccbddocu.ImpIgv = 0.
        lItemOk = TRUE.
        iCountItem = iCountItem + 1.
        IF LAST-OF(Detalle.CodCia) THEN DO:
            RUN proc_GrabaTotales.
            /* GENERACION DE CONTROL DE PERCEPCIONES */
            RUN vta2/control-percepcion-cargos (ROWID(Ccbcdocu)) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN UNDO trloop, RETURN 'ADM-ERROR'.
            /* ************************************* */
            /* RHC 30-11-2006 Transferencia Gratuita */
            IF Ccbcdocu.FmaPgo = '900' THEN Ccbcdocu.sdoact = 0.
            IF Ccbcdocu.sdoact <= 0 
            THEN ASSIGN
                    Ccbcdocu.fchcan = TODAY
                    Ccbcdocu.flgest = 'C'.
            /* *********************** */
            /* OJO: NO DESCARGA ALMACENES, YA LO HIZO EL FAI */
            /* *********************** */
            /* REGISTRO DE CONTROL */
            CREATE Cabecera-FAC.
            BUFFER-COPY Ccbcdocu TO Cabecera-FAC.
        END.
    END. /* FOR EACH Detalle */
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-FAI-ResumidoCM W-Win 
PROCEDURE Carga-FAI-ResumidoCM :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR x-Item AS INT NO-UNDO.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR'
    WITH FRAME {&FRAME-NAME}:
    GET FIRST BROWSE-DESTINO.
    DO WHILE NOT QUERY-OFF-END('BROWSE-DESTINO'):
        FIND FIRST B-CDOCU OF T-DESTINO NO-LOCK.
        /* BLOQUEAMOS REGISTRO */
        {lib/lock-genericov3.i ~
            &Tabla="Ccbcdocu" ~
            &Condicion="ROWID(Ccbcdocu) = ROWID(B-CDOCU)" ~
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &txtMensaje="pMensaje" ~
            &TipoError="UNDO PRINCIPAL, RETURN 'ADM-ERROR'"}
        /* REGISTRO DE CONTROL */
        CREATE Cabecera-FAI.
        BUFFER-COPY Ccbcdocu TO Cabecera-FAI.
        /* ********************************************************************* */
        /* Marcamos los FAI como cancelados */
        /* ********************************************************************* */
        ASSIGN
            Ccbcdocu.FlgEst = "C"       /* <<<<<<<<< OJO <<<<<<<<< */
            Ccbcdocu.SdoAct = 0
            CcbCDocu.FchCan = TODAY
            CcbCDocu.UsrCobranza = s-user-id.
        /* ******************* */
        FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK, FIRST Almmmatg OF Ccbddocu NO-LOCK:
            FIND Detalle WHERE Detalle.codmat = Ccbddocu.codmat NO-ERROR.
            IF NOT AVAILABLE Detalle THEN CREATE Detalle.
            ASSIGN
                Detalle.CodCia = Ccbcdocu.codcia
                Detalle.CodDiv = Ccbcdocu.coddiv
                Detalle.CodCli = Ccbcdocu.codcli
                Detalle.codmat = Ccbddocu.codmat
                Detalle.UndVta = Ccbddocu.undvta
                Detalle.AlmDes = Ccbddocu.almdes
                Detalle.AftIgv = Ccbddocu.aftigv
                Detalle.AftIsc = Ccbddocu.aftisc
                Detalle.CanDes = Detalle.CanDes + Ccbddocu.candes   /* OJO */
                Detalle.Factor = Ccbddocu.factor
                Detalle.ImpLin = Detalle.implin + Ccbddocu.implin   /* OJO */
                Detalle.PesMat = Detalle.PesMat + Ccbddocu.PesMat   /* OJO */
                Detalle.CodMon = Ccbcdocu.CodMon
                Detalle.TpoCmb = Ccbcdocu.TpoCmb.
            /* Recalculamos */
            ASSIGN
                Detalle.PreUni = Detalle.ImpLin / Detalle.CanDes
                Detalle.PreBas = Detalle.ImpLin / Detalle.CanDes.
            IF Detalle.AftIsc 
            THEN Detalle.ImpIsc = ROUND(Detalle.PreBas * Detalle.CanDes * (Almmmatg.PorIsc / 100),4).
            ELSE Detalle.ImpIsc = 0.
            IF Detalle.AftIgv 
            THEN Detalle.ImpIgv = Detalle.ImpLin - ROUND( Detalle.ImpLin  / ( 1 + (Ccbcdocu.PorIgv / 100) ), 4 ).
            ELSE Detalle.ImpIgv = 0.
        END.
        GET NEXT BROWSE-DESTINO.
    END.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pFchSal-1 AS DATE.
DEF INPUT PARAMETER pFchSal-2 AS DATE.

DEF VAR x-Orden AS INT NO-UNDO.

EMPTY TEMP-TABLE T-ORIGEN.
EMPTY TEMP-TABLE T-DESTINO.

/* Barremos todas las H/R cerradas y ese rango de fecha de salida */
SESSION:SET-WAIT-STATE('GENERAL').
x-Orden = 0.
/*
FOR EACH DI-RutaC NO-LOCK WHERE DI-RutaC.CodCia = s-CodCia AND 
    DI-RutaC.CodDoc = "H/R" AND 
    DI-RutaC.FchSal >= pFchSal-1 AND
    DI-RutaC.FchSal <= pFchSal-2 AND
    DI-RutaC.FlgEst = "C",      /* Solo Cerradas */
    EACH DI-RutaD OF DI-RutaC NO-LOCK WHERE Di-RutaD.flgest = 'C',  /* Entregado */
    FIRST B-CDOCU NO-LOCK WHERE B-CDOCU.CodCia = s-CodCia AND    
    B-CDOCU.CodDoc = DI-RutaD.CodRef AND                        /* G/R */ 
    B-CDOCU.NroDoc = DI-RutaD.NroRef AND
    B-CDOCU.CodRef = "FAI":                                     /* Solo G/R por FAI */
    /* Buscamos las FAIs */
    FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-CodCia AND
        Ccbcdocu.CodDoc = B-CDOCU.CodRef AND                    /* FAIs */
        Ccbcdocu.NroDoc = B-CDOCU.NroRef AND
        Ccbcdocu.CodCli = pCodCli AND                           /* Cliente  */
        LOOKUP(Ccbcdocu.FlgEst, "C,A") = 0:                     /* ni CANCELADOS ni ANULADOS */
        CREATE T-ORIGEN.
        BUFFER-COPY Ccbcdocu TO T-ORIGEN
            ASSIGN
            T-ORIGEN.FchVto = DI-RutaC.FchSal
            NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DELETE T-ORIGEN.
        x-Orden = x-Orden + 1.
        ASSIGN
            T-ORIGEN.Puntos = x-Orden.
    END.
END.
*/

x-faltan-guias = NO.

DEFINE VAR x-Agrupador AS CHAR INIT "".
/*  */
FIND FIRST T-INVOICE WHERE T-INVOICE.DeliveryGroup = combo-box-grupo NO-LOCK NO-ERROR.
IF AVAILABLE T-INVOICE THEN x-Agrupador = T-INVOICE.InvoiceCustomerGroup.

FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.CodCli = pCodCli
    AND ccbcdocu.flgest = "P"
    AND ccbcdocu.coddoc = "FAI",
    FIRST PEDIDO WHERE PEDIDO.CodCia = CcbCDocu.CodCia
    AND PEDIDO.CodDoc = CcbCDocu.CodPed
    AND PEDIDO.NroPed = CcbCDocu.NroPed NO-LOCK,
    FIRST COTIZACION WHERE COTIZACION.CodCia = PEDIDO.CodCia
    AND COTIZACION.CodDoc = PEDIDO.CodRef
    AND COTIZACION.NroPed = PEDIDO.NroRef 
    AND COTIZACION.InvoiceCustomerGroup = x-Agrupador NO-LOCK
    BREAK BY COTIZACION.codcli BY COTIZACION.InvoiceCustomerGroup:

    IF NOT (ccbcdocu.fchdoc >= fill-in-FchSal-1 AND ccbcdocu.fchdoc <= fill-in-FchSal-2) THEN NEXT.
    /* Que las FAI tengan G/R */
    /*IF TRUE <> (ccbcdocu.codref > "") THEN NEXT.*/        /* Que muestre todo, en la generacion se validara */
    
    /*Que las FAI no esten FACTURADAS */
    IF NOT (TRUE <> (ccbcdocu.libre_c03 > "")) THEN NEXT.

    /* Del mismo grupo de reparto */
    /*IF COTIZACION.InvoiceCustomerGroup <> combo-box-grupo THEN NEXT.*/
    IF COTIZACION.DeliveryGroup <> combo-box-grupo THEN NEXT.

    IF TRUE <> (ccbcdocu.codref > "") THEN x-faltan-guias = YES.

    /**/
    CREATE T-ORIGEN.
    BUFFER-COPY Ccbcdocu TO T-ORIGEN NO-ERROR.

    /* ASSIGN T-ORIGEN.FchVto = DI-RutaC.FchSal NO-ERROR.*/
    IF ERROR-STATUS:ERROR = YES THEN DELETE T-ORIGEN.
    x-Orden = x-Orden + 1.
    ASSIGN
        T-ORIGEN.Puntos = x-Orden.

END.

SESSION:SET-WAIT-STATE('').

{&OPEN-QUERY-BROWSE-ORIGEN}
{&OPEN-QUERY-BROWSE-DESTINO}

END PROCEDURE.

/*

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-Items FILL-IN-Total COMBO-BOX-Clientes FILL-IN-FchSal-1 
          FILL-IN-FchSal-2 COMBO-NroSer FILL-IN-NroDoc FILL-IN-Division 
          COMBO-BOX-grupo 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-ORIGEN BUTTON-1 COMBO-BOX-Clientes FILL-IN-FchSal-1 
         FILL-IN-FchSal-2 COMBO-NroSer BUTTON-Filtrar BUTTON-Exportar Btn_OK 
         BtnDone BUTTON-2 COMBO-BOX-grupo BUTTON-12 RECT-2 RECT-3 
         BROWSE-DESTINO 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FIRST-TRANSACTION W-Win 
PROCEDURE FIRST-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR.
DEF INPUT-OUTPUT PARAMETER iCountGuide AS INT NO-UNDO.

TRLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    EMPTY TEMP-TABLE Cabecera-FAI.
    EMPTY TEMP-TABLE Cabecera-FAC.
    EMPTY TEMP-TABLE Detalle.
    /* ****************** 1ro. RESUMIMOS LOS FAI ******************* */
    /* Carga tabla Detalle */
    /* También CANCELA las FAIs */
    /* ************************************************************* */
    RUN Carga-FAI-ResumidoCM (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO TRLOOP, RETURN 'ADM-ERROR'.
    /* ************************************************************* */
    /* *********** 2do. GENERAMOS LOS COMPROBANTES ***************** */
    RUN Carga-Comprobantes (INPUT-OUTPUT iCountGuide, OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'.
    /* ************************************************************* */
    /* ************** 3ro. REFERENCIA CRUZADA ********************** */
    RUN Referencia-Cruzada (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'.
    /* ************************************************************* */
    /* ************** 4to. CANCELAMOS LOS FAI ********************** */
    RUN Carga-Cancelacion.
    /* ************************************************************* */
/*     MESSAGE 'pause de revisión' VIEW-AS ALERT-BOX WARNING. */
/*     UNDO, RETURN 'ADM-ERROR'.                              */
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generacion-de-Factura W-Win 
PROCEDURE Generacion-de-Factura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pNroSer AS INT.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER iCountGuide AS INT NO-UNDO.

ASSIGN
    x-NroSer = pNroSer
    iCountGuide = 0.
/* LOOP Principal */
LOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR'
    WITH FRAME {&FRAME-NAME}:
    IF NOT CAN-FIND(FIRST T-DESTINO NO-LOCK) THEN DO:
        pMensaje = "Fin de Archivo".
        UNDO LOOP, RETURN 'ADM-ERROR'.
    END.
    /* *************************************************************************** */
    /* Archivo de control */
    /* *************************************************************************** */
    FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
    /* ************************************************************************************** */
    /* Generación de los comprobantes y del ingreso a caja con sus anexos */
    /* ************************************************************************************** */
    RUN FIRST-TRANSACTION (OUTPUT pMensaje, INPUT-OUTPUT iCountGuide).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR: No se pudo generar el comprobante" .
        UNDO LOOP, LEAVE LOOP.
    END.
    /* ************************************************************************************** */
    RUN SECOND-TRANSACTION (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR: No se pudo actualizar los datos en SUNAT" .
        UNDO LOOP, LEAVE LOOP.
    END.
    IF RETURN-VALUE = 'ERROR-EPOS' THEN DO:
        /* NO se detiene la grabación */
        pMensaje = ''.
    END.
END.
RUN Graba-Temp-FeLogErrores.    /* Control de Errores (si es que hay) */
IF pMensaje > '' THEN RETURN 'ADM-ERROR'.
ELSE RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Temp-FeLogErrores W-Win 
PROCEDURE Graba-Temp-FeLogErrores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH T-FeLogErrores:
    CREATE FeLogErrores.
    BUFFER-COPY T-FeLogErrores TO FeLogErrores NO-ERROR.
    DELETE T-FeLogErrores.
END.
IF AVAILABLE(FeLogErrores) THEN RELEASE FeLogErrores.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importe-total W-Win 
PROCEDURE Importe-total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FILL-IN-Total = 0.
FILL-IN-Items = 0.
SESSION:SET-WAIT-STATE('GENERAL').
EMPTY TEMP-TABLE T-PECOS.
FOR EACH T-DESTINO NO-LOCK,
    FIRST PEDIDO WHERE PEDIDO.CodCia = T-DESTINO.CodCia
    AND PEDIDO.CodDoc = T-DESTINO.CodPed
    AND PEDIDO.NroPed  = T-DESTINO.NroPed NO-LOCK,
    FIRST COTIZACION WHERE COTIZACION.CodCia = PEDIDO.CodCia
    AND COTIZACION.CodDoc = PEDIDO.CodRef
    AND COTIZACION.NroPed = PEDIDO.NroRef NO-LOCK:
    FILL-IN-Total = FILL-IN-Total + T-DESTINO.ImpTot.
    FOR EACH Ccbddocu OF T-DESTINO NO-LOCK:
        FIND FIRST T-PECOS WHERE T-PECOS.DeliveryGroup = COTIZACION.DeliveryGroup
            AND T-PECOS.ordcmp = COTIZACION.ordcmp
            AND T-PECOS.OfficeCustomer = COTIZACION.OfficeCustomer
            AND T-PECOS.codmat = Ccbddocu.codmat
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE T-PECOS THEN DO:
            CREATE T-PECOS.
            ASSIGN 
                T-PECOS.DeliveryGroup = COTIZACION.DeliveryGroup
                T-PECOS.ordcmp = COTIZACION.ordcmp
                T-PECOS.OfficeCustomer = COTIZACION.OfficeCustomer
                T-PECOS.codmat = Ccbddocu.codmat.
            FILL-IN-Items = FILL-IN-Items + 1.
        END.
    END.
END.
DISPLAY FILL-IN-Total FILL-IN-Items WITH FRAME {&FRAME-NAME}.
CASE TRUE:
    WHEN FILL-IN-Items <= 500 THEN DO:
        FILL-IN-Items:BGCOLOR IN FRAME {&frame-name} = 2.
        FILL-IN-Items:FGCOLOR IN FRAME {&frame-name} = 15 .
    END.
    WHEN FILL-IN-Items <= 1000 THEN DO:
        FILL-IN-Items:BGCOLOR IN FRAME {&frame-name} = 14.
        FILL-IN-Items:FGCOLOR IN FRAME {&frame-name} = 0 .
    END.
    OTHERWISE DO:
        FILL-IN-Items:BGCOLOR IN FRAME {&frame-name} = 12.
        FILL-IN-Items:FGCOLOR IN FRAME {&frame-name} = 0 .
    END.
END CASE.
SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE cListItems AS CHARACTER NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
      RUN src/bin/_dateif(INPUT MONTH(TODAY),
                          INPUT YEAR(TODAY),
                          OUTPUT FILL-IN-FchSal-1,
                          OUTPUT FILL-IN-FchSal-2).
      ASSIGN
          COMBO-NroSer:FORMAT = TRIM(ENTRY(1,x-FormatoFAC,'-'))
          FILL-IN-NroDoc:FORMAT = x-FormatoFAC.
      /* CORRELATIVO DE FAC */
      cListItems = "".
      FOR EACH FacCorre NO-LOCK WHERE 
          FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDiv = s-CodDiv AND 
          FacCorre.CodDoc = s-CodDoc AND
          FacCorre.FlgEst = YES:
          IF cListItems = "" THEN cListItems = STRING(FacCorre.NroSer,"999").
          ELSE cListItems = cListItems + "," + STRING(FacCorre.NroSer,"999").
      END.
      ASSIGN
          COMBO-NroSer:LIST-ITEMS = cListItems
          COMBO-NroSer = ENTRY(1,COMBO-NroSer:LIST-ITEMS).
      FIND FacCorre WHERE FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDoc = s-CodDoc AND
          FacCorre.CodDiv = s-CodDiv AND
          FacCorre.NroSer = INTEGER(COMBO-NroSer)
          NO-LOCK NO-ERROR.
      IF AVAILABLE FacCorre THEN
          FILL-IN-NroDoc = STRING(FacCorre.NroSer,"999") +
          STRING(FacCorre.Correlativo,"999999").
      FIND gn-divi WHERE gn-divi.codcia = s-codcia
          AND gn-divi.coddiv = s-coddiv
          NO-LOCK.
      FILL-IN-Division = "DIVISIÓN: " + gn-divi.coddiv + " " + GN-DIVI.DesDiv.
      COMBO-BOX-Clientes:DELIMITER = '|'.

      RUN refresca-parametros.

      /*
      EMPTY TEMP-TABLE T-INVOICE.

      FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
          AND ccbcdocu.coddoc = "FAI"
          AND ccbcdocu.flgest = "P",
          FIRST PEDIDO WHERE PEDIDO.CodCia = CcbCDocu.CodCia
          AND PEDIDO.CodDoc = CcbCDocu.CodPed
          AND PEDIDO.NroPed = CcbCDocu.NroPed NO-LOCK,
          FIRST COTIZACION WHERE COTIZACION.CodCia = PEDIDO.CodCia
          AND COTIZACION.CodDoc = PEDIDO.CodRef
          AND COTIZACION.NroPed = PEDIDO.NroRef 
          AND COTIZACION.InvoiceCustomerGroup > '' NO-LOCK
          BREAK BY COTIZACION.codcli BY COTIZACION.InvoiceCustomerGroup:

          /*Que las FAI Tengan G/R */
          IF (TRUE <> (ccbcdocu.codref > "")) THEN NEXT.
          /*Que las FAI no esten FACTURADAS */
          IF NOT (TRUE <> (ccbcdocu.libre_c03 > "")) THEN NEXT.

          IF FIRST-OF(COTIZACION.codcli) THEN DO:
              COMBO-BOX-Clientes:ADD-LAST( ccbcdocu.codcli + ' ' + ccbcdocu.nomcli , ccbcdocu.codcli ).
          END.
          IF FIRST-OF(COTIZACION.codcli) OR FIRST-OF(COTIZACION.InvoiceCustomerGroup)
              THEN DO:
              CREATE T-INVOICE.
              ASSIGN
                  T-INVOICE.InvoiceCustomerGroup = COTIZACION.InvoiceCustomerGroup
                  T-INVOICE.CodCli = COTIZACION.CodCli.
          END.
      END.
      */
  END.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF s-acceso-total = NO THEN Btn_OK:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  APPLY 'VALUE-CHANGED':U TO COMBO-NroSer IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_GrabaTotales W-Win 
PROCEDURE proc_GrabaTotales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* RHC 01/08/2019 Rutina General */
  {vtagn/i-total-factura.i &Cabecera="Ccbcdocu" &Detalle="Ccbddocu"}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Referencia-Cruzada W-Win 
PROCEDURE Referencia-Cruzada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

TRLOOP:
FOR EACH Cabecera-FAC NO-LOCK:      /* Realmente solo es una factura */
    FOR EACH Cabecera-FAI NO-LOCK:
        {lib/lock-genericov3.i ~
            &Tabla="Ccbcdocu" ~
            &Condicion="Ccbcdocu.codcia = Cabecera-FAI.codcia AND ~
            Ccbcdocu.coddiv = Cabecera-FAI.coddiv AND ~
            Ccbcdocu.coddoc = Cabecera-FAI.coddoc AND ~
            Ccbcdocu.nrodoc = Cabecera-FAI.nrodoc" ~
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &txtMensaje= "pMensaje" ~
            &TipoError="UNDO TRLOOP, RETURN 'ADM-ERROR'"}
         ASSIGN
            CcbCDocu.Libre_c03 = Cabecera-FAC.CodDoc
            CcbCDocu.Libre_c04 = Cabecera-FAC.NroDoc.

        /* TRACKING FACTURA */
        RUN vtagn/pTracking-04 (s-CodCia,
                                s-CodDiv,
                                Ccbcdocu.CodPed,
                                Ccbcdocu.NroPed,
                                s-User-Id,
                                'EFAC',
                                'P',
                                DATETIME(TODAY, MTIME),
                                DATETIME(TODAY, MTIME),
                                Cabecera-FAC.CodDoc,
                                Cabecera-FAC.nroDoc,
                                Ccbcdocu.Libre_c01,
                                Ccbcdocu.Libre_c02).

        RELEASE CcbCDocu.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refresca-parametros W-Win 
PROCEDURE refresca-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    SESSION:SET-WAIT-STATE("GENERAL").

    /* Los Clientes, Ordenado por Cliente y Grupo de Reparto Cliente BCP */
    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN fill-in-FchSal-1 fill-in-FchSal-2.

        /* Grupo de Reparto */
        REPEAT WHILE COMBO-BOX-grupo:NUM-ITEMS > 0:
            COMBO-BOX-grupo:DELETE(1).
        END.
        COMBO-BOX-grupo:SCREEN-VALUE = "".

        /* Clientes */
        REPEAT WHILE COMBO-BOX-clientes:NUM-ITEMS > 0:
            COMBO-BOX-clientes:DELETE(1).
        END.
        COMBO-BOX-Clientes:ADD-LAST("Seleccione un cliente","Seleccione un cliente").
        COMBO-BOX-clientes:SCREEN-VALUE = "Seleccione un cliente".

        EMPTY TEMP-TABLE T-INVOICE.

        FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
            AND ccbcdocu.flgest = "P"
            AND ccbcdocu.coddoc = "FAI",
            FIRST PEDIDO WHERE PEDIDO.CodCia = CcbCDocu.CodCia
            AND PEDIDO.CodDoc = CcbCDocu.CodPed
            AND PEDIDO.NroPed = CcbCDocu.NroPed NO-LOCK,
            FIRST COTIZACION WHERE COTIZACION.CodCia = PEDIDO.CodCia
            AND COTIZACION.CodDoc = PEDIDO.CodRef
            AND COTIZACION.NroPed = PEDIDO.NroRef 
            AND COTIZACION.InvoiceCustomerGroup > '' NO-LOCK
            BREAK BY COTIZACION.codcli BY COTIZACION.InvoiceCustomerGroup:

            IF NOT (ccbcdocu.fchdoc >= fill-in-FchSal-1 AND ccbcdocu.fchdoc <= fill-in-FchSal-2) THEN NEXT.

            /*Que las FAI Tengan G/R */
            /*IF (TRUE <> (ccbcdocu.codref > "")) THEN NEXT.*/

            /*Que las FAI no esten FACTURADAS */
            IF NOT (TRUE <> (ccbcdocu.libre_c03 > "")) THEN NEXT.

            FIND FIRST T-INVOICE WHERE T-INVOICE.codcli = COTIZACION.codcli AND
                                        T-INVOICE.InvoiceCustomerGroup = COTIZACION.InvoiceCustomerGroup EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE T-INVOICE THEN DO:
                CREATE T-INVOICE.
                ASSIGN T-INVOICE.codcli = ccbcdocu.codcli
                    T-INVOICE.InvoiceCustomerGroup = COTIZACION.InvoiceCustomerGroup.
                    T-INVOICE.DeliveryGroup = COTIZACION.DeliveryGroup.                
            END.                                                       
            /* Me recontra aseguro x si el DeliveryGroup sea NULO o VACIO */
            IF TRUE <> (T-INVOICE.DeliveryGroup > "") THEN DO:
                IF NOT (TRUE <> (COTIZACION.DeliveryGroup > "")) THEN DO:
                    ASSIGN T-INVOICE.DeliveryGroup = COTIZACION.DeliveryGroup.
                END.
            END.

            FIND FIRST T-CLIENTE WHERE T-CLIENTE.codcli = COTIZACION.codcli EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE T-CLIENTE THEN DO:
                CREATE T-CLIENTE.
                    ASSIGN T-CLIENTE.codcli = COTIZACION.codcli
                            T-CLIENTE.nomcli = ccbcdocu.nomcli.

            END.

        END.

    END.
    SESSION:SET-WAIT-STATE("").

    /**/
    FOR EACH T-CLIENTE NO-LOCK:
        COMBO-BOX-Clientes:ADD-LAST( T-CLIENTE.codcli + ' ' + T-CLIENTE.nomcli , T-CLIENTE.codcli ).
    END.

    FOR EACH T-INVOICE :
        /* Si es que no tiene GRUPO DE REPARTO lo elimino */
        IF TRUE <> (T-INVOICE.DeliveryGroup > "") THEN DO:
            DELETE T-INVOICE.
        END.
    END.


    EMPTY TEMP-TABLE T-ORIGEN.
    EMPTY TEMP-TABLE T-DESTINO.

    {&OPEN-QUERY-BROWSE-ORIGEN}
    {&OPEN-QUERY-BROWSE-DESTINO}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SECOND-TRANSACTION W-Win 
PROCEDURE SECOND-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* Segundo Generamos los comprobantes que faltan */
DEFINE VAR x-retval AS CHAR.

pMensaje = "".
EMPTY TEMP-TABLE T-FELogErrores.    /* CONTROL DE ERRORES DE FACTURACION ELECTRONICA */
FOR EACH Cabecera-FAC NO-LOCK, FIRST Ccbcdocu OF Cabecera-FAC NO-LOCK:
    /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
    RUN sunat\progress-to-ppll-v3 ( INPUT Ccbcdocu.CodDiv,
                                    INPUT Ccbcdocu.CodDoc,
                                    INPUT Ccbcdocu.NroDoc,
                                    INPUT-OUTPUT TABLE T-FELogErrores,
                                    OUTPUT pMensaje ).
    /* 2 tipos de errores:
        ADM-ERROR: Rechazo de BizzLinks
        ERROR-EPOS: No se pudo grabar en control de comprobante FELOgComprobantes */
    IF RETURN-VALUE <> "OK" THEN DO:
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR de ePos".
            RETURN "ADM-ERROR".
        END.
        IF RETURN-VALUE = 'ERROR-EPOS' THEN DO:
            IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR log de comprobantes".
            RETURN "ERROR-EPOS".
        END.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "T-ORIGEN"}
  {src/adm/template/snd-list.i "CcbCDocu"}
  {src/adm/template/snd-list.i "PEDIDO"}
  {src/adm/template/snd-list.i "COTIZACION"}
  {src/adm/template/snd-list.i "T-DESTINO"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto W-Win 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR pOptions AS CHAR NO-UNDO.
    DEF VAR pArchivo AS CHAR NO-UNDO.

    DEF VAR OKpressed AS LOG.

    SYSTEM-DIALOG GET-FILE pArchivo
        FILTERS "Archivo txt" "*.txt"
        ASK-OVERWRITE
        CREATE-TEST-FILE
        DEFAULT-EXTENSION ".txt"
        SAVE-AS
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = FALSE THEN RETURN NO-APPLY.

    ASSIGN
        pOptions = "FileType:TXT" + CHR(1) + ~
              "Grid:ver" + CHR(1) + ~
              "ExcelAlert:false" + CHR(1) + ~
              "ExcelVisible:false" + CHR(1) + ~
              "Labels:yes".


    /* Capturamos información de la cabecera y el detalle */
    EMPTY TEMP-TABLE Reporte.
    SESSION:SET-WAIT-STATE('').
    GET FIRST BROWSE-ORIGEN.
    DO WHILE NOT QUERY-OFF-END('BROWSE-ORIGEN'):
        CREATE Reporte.
        ASSIGN
            Reporte.Puntos = T-ORIGEN.Puntos
            Reporte.CodDoc = Ccbcdocu.CodDoc
            Reporte.NroDoc = Ccbcdocu.NroDoc
            Reporte.FchDoc = Ccbcdocu.FchDoc
            Reporte.FchVto = T-ORIGEN.FchVto
            Reporte.Moneda = (IF CcbCDocu.CodMon = 1 THEN 'S/' ELSE 'US$')
            Reporte.ImpTot = Ccbcdocu.ImpTot
            Reporte.InvoiceCustomerGroup = COTIZACION.InvoiceCustomerGroup
            Reporte.CustomerPurchaseOrder = COTIZACION.CustomerPurchaseOrder
            Reporte.CustomerRequest = COTIZACION.CustomerRequest
            .
        GET NEXT BROWSE-ORIGEN.
    END.
    SESSION:SET-WAIT-STATE('').

    FIND FIRST Reporte NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Reporte THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.

    DEF VAR cArchivo AS CHAR NO-UNDO.
    /* El archivo se va a generar en un archivo temporal de trabajo antes
    de enviarlo a su directorio destino */
    cArchivo = LC(pArchivo).
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN lib/tt-filev2 (TEMP-TABLE Reporte:HANDLE, cArchivo, pOptions).
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCentrar W-Win 
FUNCTION fCentrar RETURNS CHARACTER
  ( INPUT pParam AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR x-Var AS CHAR NO-UNDO.
RUN src/bin/_centrar (pParam, 20, OUTPUT x-Var).

  RETURN x-Var.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

