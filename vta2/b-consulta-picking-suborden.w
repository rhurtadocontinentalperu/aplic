&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ORDENES NO-UNDO LIKE FacCPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
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

  Description: from BROWSER.W - Basic SmartBrowser Object Template

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
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE lMsgRetorno AS CHAR.

/*DEF VAR s-coddoc AS CHAR INIT 'O/D,O/M'.*/
DEF SHARED VAR s-coddoc AS CHAR.
DEF VAR x-nroitm AS INT.

DEFINE SHARED VAR ltxtDesde AS DATE.
DEFINE SHARED VAR ltxtHasta AS DATE.
DEFINE SHARED VAR lChequeados AS LOGICAL.
DEFINE SHARED VAR pSoloImpresos AS LOGICAL.
DEFINE SHARED VAR i-tipo-busqueda AS INT.
DEFINE SHARED VAR s-busqueda AS CHAR INIT '< Todos >'.

DEFINE VAR s-task-no AS INT.
DEFINE VAR x-docproc AS CHAR.

&SCOPED-DEFINE CONDICION Faccpedi.codcia = s-codcia ~
AND Faccpedi.divdes = s-coddiv ~
AND faccpedi.coddoc = x-docproc ~
AND Faccpedi.FlgEst <> "A"  ~
AND (Faccpedi.fchped >= ltxtDesde AND Faccpedi.fchped <= ltxtHasta)

/*
&SCOPED-DEFINE CONDICION Faccpedi.codcia = s-codcia ~
AND Faccpedi.divdes = s-coddiv ~
AND ((s-CodDoc = "Todos" AND LOOKUP(Faccpedi.CodDoc, 'O/D,O/M,OTR') > 0 ) ~
    OR Faccpedi.coddoc = s-coddoc ) ~
AND Faccpedi.FlgEst <> "A"  ~
AND (Faccpedi.fchped >= ltxtDesde AND Faccpedi.fchped <= ltxtHasta)
*/

&SCOPED-DEFINE CONDICION2 (s-busqueda = '< Todos >' OR ordenes.libre_c02 = s-busqueda)

DEFINE TEMP-TABLE Reporte
    FIELD CodDoc    LIKE Faccpedi.CodDoc
    FIELDS NroPed   LIKE Faccpedi.NroPed
    FIELD  CodRef    LIKE Faccpedi.CodRef
    FIELDS NroRef   LIKE Faccpedi.NroRef
    FIELDS CodAlm   LIKE Facdpedi.almdes
    FIELDS CodMat   LIKE FacDPedi.CodMat
    FIELDS DesMat   LIKE Almmmatg.DesMat
    FIELDS DesMar   LIKE Almmmatg.DesMar
    FIELDS UndBas   LIKE Almmmatg.UndBas
    FIELDS CanPed   LIKE FacDPedi.CanPed    FORMAT '->>>,>>>,>>9.99'
    FIELDS CodUbi   LIKE Almmmate.CodUbi
    FIELDS CodZona  LIKE Almtubic.CodZona
    FIELDS X-TRANS  LIKE Faccpedi.Libre_c01
    FIELDS X-DIREC  LIKE Faccpedi.Libre_c02
    FIELDS X-LUGAR  LIKE Faccpedi.Libre_c03
    FIELDS X-CONTC  LIKE Faccpedi.Libre_c04
    FIELDS X-HORA   LIKE Faccpedi.Libre_c05
    FIELDS X-FECHA  LIKE Faccpedi.Libre_f01
    FIELDS X-OBSER  LIKE Faccpedi.Observa
    FIELDS X-Glosa  LIKE Faccpedi.Glosa
    FIELDS X-codcli LIKE Faccpedi.CodCli
    FIELDS X-NomCli LIKE Faccpedi.NomCli
    FIELDS X-fchent LIKE Faccpedi.fchent
    FIELDS X-peso   AS DEC INIT 0
    FIELDS x-empaques AS CHAR FORMAT 'x(25)'
    FIELDS x-corrrsector AS INT INIT 0.

/* Guardo las sub-ordenes para la actualizacion */
DEFINE TEMP-TABLE tt-subordenes
    FIELD CodDoc    LIKE Faccpedi.CodDoc
    FIELDS NroPed   LIKE Faccpedi.NroPed.


/*   */
DEFINE TEMP-TABLE Resumen
    FIELD CodMat LIKE Facdpedi.codmat
    FIELD DesMat LIKE Almmmatg.desmat
    FIELD DesMar LIKE Almmmatg.desmar
    FIELD UndBas LIKE Almmmatg.undbas
    FIELD NroPed AS CHAR EXTENT 100
    FIELD CanPed AS DEC  EXTENT 100
    INDEX Idx00 AS PRIMARY CodMat.

DEFINE TEMP-TABLE Resumen2
    FIELDS X-codcli LIKE Faccpedi.CodCli
    FIELDS X-NomCli LIKE Faccpedi.NomCli
    FIELD CodDoc    LIKE Faccpedi.CodDoc
    FIELDS NroPed   LIKE Faccpedi.NroPed
    FIELDS X-FECHA  LIKE Faccpedi.Libre_f01
    FIELDS X-fchent LIKE Faccpedi.fchent
    FIELDS x-qtyitm AS INT INIT 0
    FIELDS x-peso   AS DEC INIT 0

    INDEX Idx00 AS PRIMARY x-codcli coddoc Nroped.


DEF VAR x-Direccion AS CHAR.
DEF VAR x-Comprobante AS CHAR.
DEF VAR x-Ordenes AS CHAR NO-UNDO.
DEF VAR x-peso AS DEC NO-UNDO.

define stream REPORTE.

/* Def REPORTE */
DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "aplic/alm/rbalm.prl".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Hoja Ruta2".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

/* capturamos ruta inicial */
DEF VAR S-REPORT-LIBRARY AS CHAR.
GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE s-report-library.
RB-REPORT-LIBRARY = s-report-library + "alm\rbalm.prl".

DEFINE TEMP-TABLE Detalle
    FIELD Situacion     AS CHAR     FORMAT 'x(30)'  LABEL 'Situación'
    FIELD CodPed        AS CHAR     FORMAT 'x(3)'   LABEL 'Código'
    FIELD NroPed        AS CHAR     FORMAT 'x(15)'  LABEL 'Número'
    FIELD FchPed        AS DATE     FORMAT '99/99/9999' LABEL 'Emisión'
    FIELD Hora          AS CHAR     FORMAT 'x(8)'   LABEL 'Hora'
    FIELD FchSit        AS DATE     FORMAT '99/99/9999' LABEL 'Fecha cambio situación'
    FIELD FchEnt        AS DATE     FORMAT '99/99/9999' LABEL 'Fecha de Entrega'
    FIELD Origen        AS CHAR     FORMAT 'x(5)'   LABEL 'Origen'
    FIELD NomCli        AS CHAR     FORMAT 'x(50)'  LABEL 'Cliente'
    FIELD Peso          AS DEC      FORMAT '>>>,>>9.99' LABEL 'Peso Kg.'
    FIELD Importe_Nac   AS DECI     FORMAT '>>>,>>9.99' LABEL 'Importe S/.'
    FIELD Importe_Ext   AS DECI     FORMAT '>>>,>>9.99' LABEL 'Importe US$'
    FIELD Sectores      AS INT      FORMAT '>>9'    LABEL 'Sectores'
    FIELD Impresos      AS INT      FORMAT '>>9'    LABEL 'Impresos'
    FIELD Asignados     AS INT      FORMAT '>>9'    LABEL 'Asignados'
    FIELD Recepcionados AS INT      FORMAT '>>9'    LABEL 'Recepcionados'
    FIELD PorAsignar    AS INT      FORMAT '>>9'    LABEL 'Por Asignar'
    FIELD UsrImpOD      AS CHAR     FORMAT 'x(8)'   LABEL 'Impreso por'
    FIELD FchImpOD      AS DATETIME FORMAT '99/99/9999 HH:MM' LABEL 'Fecha y hora de impresión'
    FIELD Items         AS INT      FORMAT '>>9'    LABEL 'Items'
    FIELD Glosa         AS CHAR     FORMAT 'x(50)'  LABEL 'Glosa'
    FIELD CodRef        AS CHAR     FORMAT 'x(3)'   LABEL 'Cod. Referencia'
    FIELD NroRef        AS CHAR     FORMAT 'x(15)'  LABEL 'Nro. referencia'
    FIELD ImpRef        AS DEC      FORMAT '->>>,>>>,>>9.99' LABEL 'Importe Ref.'
    FIELD OrdCmp        AS CHAR     FORMAT 'x(15)'  LABEL 'Orden de Compra'
    FIELD CodPos        AS CHAR     FORMAT 'x(5)'  LABEL 'CodPostal'
    FIELD nomPos        AS CHAR     FORMAT 'x(40)'  LABEL 'Distrito'
    FIELD NroCot        AS CHAR     FORMAT 'x(15)'  LABEL 'Cotización'
    .

/* Ic - 31Ene2017, reporte Johan Cabello */
DEFINE TEMP-TABLE tt-subordxls
    FIELDS  tt-coddoc   AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "Codigo"
    FIELDS  tt-nrodoc   AS CHAR     FORMAT 'x(10)'   COLUMN-LABEL "Numero"
    FIELDS  tt-fchemi   AS DATE     FORMAT '99/99/9999'   COLUMN-LABEL "Emision"
    FIELDS  tt-horemi   AS CHAR     FORMAT 'x(10)'   COLUMN-LABEL "Hora"
    FIELDS  tt-fchent   AS DATE     FORMAT '99/99/9999'   COLUMN-LABEL "Entrega"
    FIELDS  tt-origen   AS CHAR     FORMAT 'x(20)'   COLUMN-LABEL "Origen"
    FIELDS  tt-descli   AS CHAR     FORMAT 'x(60)'   COLUMN-LABEL "cliente"
    FIELDS  tt-fhimp    AS CHAR     FORMAT 'x(25)'   COLUMN-LABEL "Fecha/Hora impresion"
    FIELDS  tt-usrimp   AS CHAR     FORMAT 'x(10)'   COLUMN-LABEL "Impreso por"
    FIELDS  tt-peso     AS DEC      FORMAT '999,999.99'   COLUMN-LABEL "Peso"
    FIELDS  tt-cant     AS INT      FORMAT '999,999'   COLUMN-LABEL "Cantidad"
    FIELDS  tt-sector   AS CHAR      FORMAT '999'   COLUMN-LABEL "Sector"
    FIELDS  tt-items    AS INT      FORMAT '9,999'   COLUMN-LABEL "Items"
    FIELDS  tt-superv  AS CHAR     FORMAT 'x(15)'   COLUMN-LABEL "Supervisor"
    FIELDS  tt-sacador  AS CHAR     FORMAT 'x(15)'   COLUMN-LABEL "Sacador"
    FIELDS  tt-hinicio  AS CHAR     FORMAT 'x(25)'   COLUMN-LABEL "Hora Inicio"
    FIELDS  tt-hfinal   AS CHAR     FORMAT 'x(25)'   COLUMN-LABEL "Hora Final"
    FIELDS  tt-tiempo   AS CHAR     FORMAT 'x(25)'   COLUMN-LABEL "Tiempo".


DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
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

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ORDENES FacCPedi PEDIDO

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table ORDENES.Libre_c02 ORDENES.CodDoc ~
ORDENES.NroPed ORDENES.FchPed ORDENES.Hora ORDENES.DeliveryDate ~
ORDENES.FchEnt ORDENES.Libre_c01 ORDENES.NomCli ORDENES.Libre_d01 ~
ORDENES.AcuBon[1] ORDENES.AcuBon[2] ORDENES.AcuBon[3] ORDENES.AcuBon[4] ~
ORDENES.AcuBon[5] FacCPedi.UsrImpOD FacCPedi.FchImpOD ORDENES.Libre_d02 ~
FacCPedi.Glosa FacCPedi.CodRef FacCPedi.NroRef PEDIDO.ImpTot ORDENES.ordcmp ~
PEDIDO.CodRef PEDIDO.NroRef 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH ORDENES WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION2} NO-LOCK, ~
      FIRST FacCPedi OF ORDENES NO-LOCK, ~
      FIRST PEDIDO WHERE PEDIDO.CodCia = FacCPedi.CodCia ~
  AND PEDIDO.CodDoc = FacCPedi.CodRef ~
  AND PEDIDO.NroPed = FacCPedi.NroRef OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH ORDENES WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION2} NO-LOCK, ~
      FIRST FacCPedi OF ORDENES NO-LOCK, ~
      FIRST PEDIDO WHERE PEDIDO.CodCia = FacCPedi.CodCia ~
  AND PEDIDO.CodDoc = FacCPedi.CodRef ~
  AND PEDIDO.NroPed = FacCPedi.NroRef OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table ORDENES FacCPedi PEDIDO
&Scoped-define FIRST-TABLE-IN-QUERY-br_table ORDENES
&Scoped-define SECOND-TABLE-IN-QUERY-br_table FacCPedi
&Scoped-define THIRD-TABLE-IN-QUERY-br_table PEDIDO


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
FchPed|y||INTEGRAL.FacCPedi.FchPed|no,INTEGRAL.FacCPedi.Hora|no
Libre_c01|||ORDENES.Libre_c01|yes,ORDENES.FchPed|yes,ORDENES.Hora|yes
NomCli|||INTEGRAL.FacCPedi.NomCli|yes,INTEGRAL.FacCPedi.FchPed|yes,INTEGRAL.FacCPedi.Hora|yes
FchEnt|||INTEGRAL.FacCPedi.FchEnt|no,INTEGRAL.FacCPedi.NomCli|yes
Libre_d01|||ORDENES.Libre_d01|no
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "':U + 'FchPed,Libre_c01,NomCli,FchEnt,Libre_d01' + '",
     SortBy-Case = ':U + 'FchPed').

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).

/* This SmartObject is a valid SortBy-Target. */
&IF '{&user-supported-links}':U ne '':U &THEN
  &Scoped-define user-supported-links {&user-supported-links},SortBy-Target
&ELSE
  &Scoped-define user-supported-links SortBy-Target
&ENDIF

/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fAlmacen B-table-Win 
FUNCTION fAlmacen RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCantidadSub B-table-Win 
FUNCTION fCantidadSub RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDistribucion B-table-Win 
FUNCTION fDistribucion RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fgen-empaques B-table-Win 
FUNCTION fgen-empaques RETURNS CHARACTER
  ( INPUT pCantidad AS dec )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNroItm B-table-Win 
FUNCTION fNroItm RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNroItmSub B-table-Win 
FUNCTION fNroItmSub RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fOrdenCompra B-table-Win 
FUNCTION fOrdenCompra RETURNS CHARACTER
  ( INPUT pPedido AS CHAR, INPUT pFiltroOrdenCompra AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPersonal B-table-Win 
FUNCTION fPersonal RETURNS CHARACTER
     (INPUT cCodPer AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPeso B-table-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPesoSub B-table-Win 
FUNCTION fPesoSub RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      ORDENES, 
      FacCPedi, 
      PEDIDO
    FIELDS(PEDIDO.ImpTot
      PEDIDO.CodRef
      PEDIDO.NroRef) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      ORDENES.Libre_c02 COLUMN-LABEL "Situacion" FORMAT "x(30)":U
            WIDTH 13.43
      ORDENES.CodDoc FORMAT "x(3)":U
      ORDENES.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U WIDTH 8.57
      ORDENES.FchPed COLUMN-LABEL "Emisión" FORMAT "99/99/9999":U
      ORDENES.Hora FORMAT "X(8)":U WIDTH 4.72
      ORDENES.DeliveryDate COLUMN-LABEL "Fecha cambio!situación" FORMAT "99/99/9999":U
            WIDTH 10.43
      ORDENES.FchEnt FORMAT "99/99/9999":U WIDTH 10.43
      ORDENES.Libre_c01 COLUMN-LABEL "Origen" FORMAT "x(40)":U
            WIDTH 11.14
      ORDENES.NomCli COLUMN-LABEL "Cliente" FORMAT "x(100)":U WIDTH 34.57
      ORDENES.Libre_d01 COLUMN-LABEL "Peso KG" FORMAT ">>>,>>9.99":U
            WIDTH 7.43
      ORDENES.AcuBon[1] COLUMN-LABEL "Sectores" FORMAT "99":U WIDTH 6
      ORDENES.AcuBon[2] COLUMN-LABEL "Impresos" FORMAT "99":U WIDTH 5.86
      ORDENES.AcuBon[3] COLUMN-LABEL "Asignados" FORMAT "99":U
            WIDTH 6.43
      ORDENES.AcuBon[4] COLUMN-LABEL "Recep." FORMAT "99":U WIDTH 5
      ORDENES.AcuBon[5] COLUMN-LABEL "xAsignar" FORMAT "99":U WIDTH 5.86
      FacCPedi.UsrImpOD COLUMN-LABEL "Impreso por" FORMAT "x(8)":U
            WIDTH 8.14
      FacCPedi.FchImpOD COLUMN-LABEL "Fecha y!hora de impresión" FORMAT "99/99/9999 HH:MM":U
            WIDTH 13.43
      ORDENES.Libre_d02 COLUMN-LABEL "Items" FORMAT ">>>9":U
      FacCPedi.Glosa FORMAT "X(50)":U
      FacCPedi.CodRef COLUMN-LABEL "Cod!Ref" FORMAT "x(3)":U WIDTH 4
      FacCPedi.NroRef FORMAT "X(12)":U
      PEDIDO.ImpTot COLUMN-LABEL "Importe Ref." FORMAT "->>,>>>,>>9.99":U
      ORDENES.ordcmp FORMAT "X(12)":U WIDTH 11.29
      PEDIDO.CodRef FORMAT "x(3)":U
      PEDIDO.NroRef COLUMN-LABEL "Numero" FORMAT "X(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 143 BY 13.08
         FONT 4 ROW-HEIGHT-CHARS .5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: ORDENES T "?" NO-UNDO INTEGRAL FacCPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
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
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 14.38
         WIDTH              = 154.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 2
       br_table:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.ORDENES,INTEGRAL.FacCPedi OF Temp-Tables.ORDENES,PEDIDO WHERE INTEGRAL.FacCPedi ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST, FIRST OUTER USED"
     _Where[1]         = "{&CONDICION2}"
     _JoinCode[3]      = "PEDIDO.CodCia = INTEGRAL.FacCPedi.CodCia
  AND PEDIDO.CodDoc = INTEGRAL.FacCPedi.CodRef
  AND PEDIDO.NroPed = INTEGRAL.FacCPedi.NroRef"
     _FldNameList[1]   > Temp-Tables.ORDENES.Libre_c02
"ORDENES.Libre_c02" "Situacion" "x(30)" "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = Temp-Tables.ORDENES.CodDoc
     _FldNameList[3]   > Temp-Tables.ORDENES.NroPed
"ORDENES.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no "8.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ORDENES.FchPed
"ORDENES.FchPed" "Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ORDENES.Hora
"ORDENES.Hora" ? "X(8)" "character" ? ? ? ? ? ? no ? no no "4.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ORDENES.DeliveryDate
"ORDENES.DeliveryDate" "Fecha cambio!situación" ? "date" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ORDENES.FchEnt
"ORDENES.FchEnt" ? ? "date" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ORDENES.Libre_c01
"ORDENES.Libre_c01" "Origen" "x(40)" "character" ? ? ? ? ? ? no ? no no "11.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.ORDENES.NomCli
"ORDENES.NomCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "34.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.ORDENES.Libre_d01
"ORDENES.Libre_d01" "Peso KG" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.ORDENES.AcuBon[1]
"ORDENES.AcuBon[1]" "Sectores" "99" "decimal" ? ? ? ? ? ? no ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.ORDENES.AcuBon[2]
"ORDENES.AcuBon[2]" "Impresos" "99" "decimal" ? ? ? ? ? ? no ? no no "5.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.ORDENES.AcuBon[3]
"ORDENES.AcuBon[3]" "Asignados" "99" "decimal" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.ORDENES.AcuBon[4]
"ORDENES.AcuBon[4]" "Recep." "99" "decimal" ? ? ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.ORDENES.AcuBon[5]
"ORDENES.AcuBon[5]" "xAsignar" "99" "decimal" ? ? ? ? ? ? no ? no no "5.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > INTEGRAL.FacCPedi.UsrImpOD
"FacCPedi.UsrImpOD" "Impreso por" ? "character" ? ? ? ? ? ? no ? no no "8.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > INTEGRAL.FacCPedi.FchImpOD
"FacCPedi.FchImpOD" "Fecha y!hora de impresión" "99/99/9999 HH:MM" "datetime" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.ORDENES.Libre_d02
"ORDENES.Libre_d02" "Items" ">>>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   = INTEGRAL.FacCPedi.Glosa
     _FldNameList[20]   > INTEGRAL.FacCPedi.CodRef
"FacCPedi.CodRef" "Cod!Ref" ? "character" ? ? ? ? ? ? no ? no no "4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   = INTEGRAL.FacCPedi.NroRef
     _FldNameList[22]   > Temp-Tables.PEDIDO.ImpTot
"PEDIDO.ImpTot" "Importe Ref." ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > Temp-Tables.ORDENES.ordcmp
"ORDENES.ordcmp" ? ? "character" ? ? ? ? ? ? no ? no no "11.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[24]   = Temp-Tables.PEDIDO.CodRef
     _FldNameList[25]   > Temp-Tables.PEDIDO.NroRef
"PEDIDO.NroRef" "Numero" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-DISPLAY OF br_table IN FRAME F-Main
DO:
    CASE ordenes.libre_c02:
        WHEN 'SIN EMPEZAR' THEN DO:
            ordenes.libre_c02:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12.
        END.
        WHEN 'COMPLETADO' THEN DO:
            ordenes.libre_c02:BGCOLOR IN BROWSE {&BROWSE-NAME} = 2.
        END.
        WHEN 'PARCIALMENTE IMPRESOS' THEN DO:
            ordenes.libre_c02:BGCOLOR IN BROWSE {&BROWSE-NAME} = 3.
        END.
        WHEN 'SOLO IMPRESOS' THEN DO:
            ordenes.libre_c02:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14.
        END.
        WHEN 'AVANZE PARCIAL' THEN DO:
            ordenes.libre_c02:BGCOLOR IN BROWSE {&BROWSE-NAME} = 10.
        END.
        WHEN 'SOLO ASIGNADOS' THEN DO:
            ordenes.libre_c02:BGCOLOR IN BROWSE {&BROWSE-NAME} = 4.
        END.
        WHEN 'ASIGNADO PARCIAL' THEN DO:
            ordenes.libre_c02:BGCOLOR IN BROWSE {&BROWSE-NAME} = 6.
        END.

    END CASE.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON START-SEARCH OF br_table IN FRAME F-Main
DO:
    DEFINE VARIABLE hSortColumn  AS WIDGET-HANDLE.
    DEFINE VARIABLE hQueryHandle AS HANDLE     NO-UNDO.

    hSortColumn = BROWSE {&BROWSE-NAME}:CURRENT-COLUMN.
    CASE hSortColumn:NAME:
        WHEN "FchPed" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'FchPed').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "Libre_c01" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'Libre_c01').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "NomCli" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'NomCli').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "FchEnt" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'FchEnt').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "Libre_d01" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'Libre_d01').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */

    IF NOT AVAILABLE ordenes THEN RETURN NO-APPLY.
       
    /* SubOrdenes */
    RUN ue-muestra-subordenes IN lh_Handle(INPUT ordenes.coddoc , INPUT ordenes.nroped ).

    /* --------------------------------------- */

  DEFINE VAR lxpeso AS DEC.
  lMsgretorno = ''.

  /*lxPeso = fpeso().*/

  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE A-Distribucion B-table-Win 
PROCEDURE A-Distribucion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF Faccpedi.Libre_c02 = '' OR Faccpedi.Libre_c03 <> '' THEN RETURN.
  /* Ic - 20Mar2015 - Felix Perez debe pedir codigo del trabajador
  MESSAGE 'Enviamos la Orden de Despacho a Distribución?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN.
  */

  DEF VAR x-UsrChq LIKE Faccpedi.usrchq NO-UNDO.
  RUN vtamay/d-chqped (OUTPUT x-UsrChq).
  IF x-UsrChq = '' THEN RETURN 'ADM-ERROR'.

  FIND CURRENT FacCPedi EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccpedi THEN DO:
      MESSAGE 'No se pudo bloquear la Orden' VIEW-AS ALERT-BOX ERROR.
      RETURN.
  END.
  ASSIGN
      FacCPedi.Libre_c03 = s-user-id + '|' + STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM:SS') + '|' + x-UsrChq
      FacCpedi.ubigeo[4] = x-UsrChq.

  FIND CURRENT Faccpedi NO-LOCK NO-ERROR.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

  RUN get-attribute ('SortBy-Case':U).
  CASE RETURN-VALUE:
    WHEN 'FchPed':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.FchPed DESCENDING BY FacCPedi.Hora DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Libre_c01':U THEN DO:
      &Scope SORTBY-PHRASE BY ORDENES.Libre_c01 BY ORDENES.FchPed BY ORDENES.Hora
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'NomCli':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.NomCli BY FacCPedi.FchPed BY FacCPedi.Hora
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'FchEnt':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.FchEnt DESCENDING BY FacCPedi.NomCli
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Libre_d01':U THEN DO:
      &Scope SORTBY-PHRASE BY ORDENES.Libre_d01 DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    OTHERWISE DO:
      &Undefine SORTBY-PHRASE
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* OTHERWISE...*/
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE ORDENES.

DEFINE VAR lOrdenCompra AS CHAR INIT ''.
DEFINE VAR lUserImpresion AS CHAR.

DEFINE VAR lSectores AS INT.
DEFINE VAR lSecImp AS INT.
DEFINE VAR lSecAsig AS INT.
DEFINE VAR lSecDev AS INT.
DEFINE VAR lSecxAsig AS INT.
DEFINE VAR lCodDoc AS CHAR NO-UNDO.
DEFINE VAR k AS INT NO-UNDO.

IF s-CodDoc = "Todos" THEN lCodDoc = 'O/D,O/M,OTR'.
ELSE lCodDoc = s-coddoc.

/* --- */
DEFINE VAR x-items AS INT.
DEFINE VAR x-peso AS DEC.

/* 04/11/2024: Juan Hermosa, fecha de cambio de situación */
DEF VAR fFechaSituacion AS DATE NO-UNDO.

SESSION:SET-WAIT-STATE('GENERAL').
DO k = 1 TO NUM-ENTRIES(lCodDoc):
    x-docproc = ENTRY(k,lCodDoc).
    FOR EACH Faccpedi USE-INDEX llave08 NO-LOCK WHERE {&Condicion},
        FIRST GN-DIVI OF Faccpedi NO-LOCK:
        lUserImpresion = Faccpedi.UsrImpOD.
        lUserImpresion = IF (lUserImpresion = ?) THEN '' ELSE TRIM(lUserImpresion).

        DISPLAY STRING(Faccpedi.FchPed,'99/99/9999') + ' ' + 
            Faccpedi.coddoc + ' ' +
            Faccpedi.nroped  @ Fi-Mensaje LABEL "Carga Temporal"
            WITH FRAME F-Proceso.

        /* ******************************* */
        /* Captura */
        fFechaSituacion = Faccpedi.FchPed.
        /* ******************************* */

        RUN ue-sectores(INPUT Faccpedi.coddoc, 
                        INPUT Faccpedi.nroped,
                        OUTPUT lSectores, 
                        OUTPUT lSecImp, 
                        OUTPUT lSecAsig,
                        OUTPUT lSecDev,
                        OUTPUT fFechaSituacion
                        ).

        /* x Asignar */
        IF i-tipo-busqueda = 2 AND (lSectores = lSecAsig ) THEN NEXT.
        /* x Recepcionar */
        IF i-tipo-busqueda = 3 AND (lSecAsig = 0 OR lSecAsig = lSecDev  ) THEN NEXT.
        /* Todos Asignados */
        IF i-tipo-busqueda = 4 AND (lSectores <> lSecAsig ) THEN NEXT.

        IF (pSoloImpresos = NO OR lUserImpresion <> '') THEN DO:
            x-items = 0.
            X-peso = 0.

            RUN items-pesos(OUTPUT x-items, OUTPUT x-peso).

            CREATE ORDENES.
            BUFFER-COPY Faccpedi TO ORDENES.
            ASSIGN
                ORDENES.Libre_c01 = gn-divi.desdiv
                ORDENES.Libre_d01 = x-peso  /*fPeso()*/
                ORDENES.Libre_c02 = ""
                ORDENES.Libre_d02 = x-items.  /*fNroItm()*/

            ORDENES.UsrImpOD = ENTRY(1, Faccpedi.Libre_c02, '|').
            ORDENES.FchImpOD = (IF NUM-ENTRIES(Faccpedi.Libre_c02, '|') > 1 THEN 
                            DATETIME(ENTRY(2, Faccpedi.Libre_c02, '|')) ELSE ?).
            CASE s-CodDoc:
                WHEN 'O/D' OR WHEN 'O/M' OR WHEN 'ODC' THEN DO:
                    ORDENES.Libre_c01 = gn-divi.desdiv.
                    ORDENES.NomCli:COLUMN-LABEL IN BROWSE {&browse-name} = "Cliente".
                END.
                WHEN 'OTR' THEN DO:
                    ORDENES.Libre_c01 = Faccpedi.codcli.
                    ORDENES.NomCli:COLUMN-LABEL IN BROWSE {&browse-name} = "Solicitante".
                END.
            END CASE.

            RUN ue-sectores(INPUT Ordenes.coddoc, 
                            INPUT Ordenes.nroped,
                            OUTPUT lSectores, 
                            OUTPUT lSecImp, 
                            OUTPUT lSecAsig,
                            OUTPUT lSecDev,
                            OUTPUT fFechaSituacion
                            ).
            ASSIGN  
                Ordenes.acubon[1] = lSectores
                Ordenes.acubon[2] = lSecImp
                Ordenes.acubon[3] = lSecAsig
                Ordenes.acubon[4] = lSecDev
                Ordenes.acubon[5] = lSectores - lSecAsig.
             
                ORDENES.Libre_c02 = "SIN EMPEZAR".

            IF lSectores = lSecDev THEN ORDENES.Libre_c02 = "COMPLETADO".
            IF lSecImp > 0 AND lSecImp < lSectores AND lSecAsig = 0 THEN ORDENES.Libre_c02 = "PARCIALMENTE IMPRESOS".
            IF lSecImp > 0 AND lSecAsig = 0 AND lSectores = lSecImp AND lSecDev = 0 THEN ORDENES.Libre_c02 = "SOLO IMPRESOS".
            IF lSecAsig > 0 AND lSecDev > 0 AND lSecDev <> lSectores THEN ORDENES.Libre_c02 = "AVANCE PARCIAL".
            IF lSecAsig > 0 AND lSecDev = 0 AND lSecAsig = lSectores THEN ORDENES.Libre_c02 = "SOLO ASIGNADOS".
            IF lSecAsig > 0 AND lSecDev = 0 AND lSecAsig <> lSectores THEN ORDENES.Libre_c02 = "ASIGNADO PARCIAL".
            IF faccpedi.flgest = 'C' THEN DO:
                ORDENES.Libre_c02 = "FACTURADO/G.REMISION".
                IF Faccpedi.coddoc = "O/D" THEN DO:
                    FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia AND
                        Ccbcdocu.codcli = Faccpedi.codcli AND
                        Ccbcdocu.flgest <> "A":
                        IF LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL') > 0 AND
                            Ccbcdocu.libre_c01 = Faccpedi.coddoc AND
                            Ccbcdocu.libre_c02 = Faccpedi.nroped
                            THEN fFechaSituacion = Ccbcdocu.fchdoc.
                    END.
                END.
                IF Faccpedi.coddoc = "OTR" THEN DO:
                    FOR EACH Almcmov NO-LOCK WHERE Almcmov.codcia = s-codcia AND
                        Almcmov.codref = Faccpedi.coddoc AND
                        Almcmov.nroref = Faccpedi.nroped AND
                        Almcmov.tipmov = "S" AND
                        Almcmov.flgest <> "A":
                        fFechaSituacion = Almcmov.fchdoc.
                    END.
                END.
            END.
            ASSIGN
                ORDENES.DeliveryDate = fFechaSituacion.
        END.
    END.
END.
HIDE FRAME F-Proceso.

/*
FOR EACH Faccpedi USE-INDEX llave08 WHERE {&Condicion} NO-LOCK, 
    FIRST GN-DIVI OF Faccpedi NO-LOCK:

    lUserImpresion = Faccpedi.UsrImpOD.
    lUserImpresion = IF (lUserImpresion = ?) THEN '' ELSE TRIM(lUserImpresion).

    RUN ue-sectores(INPUT Faccpedi.coddoc, 
                    INPUT Faccpedi.nroped,
                    OUTPUT lSectores, 
                    OUTPUT lSecImp, 
                    OUTPUT lSecAsig,
                    OUTPUT lSecDev).

    /* x Asignar */
    IF i-tipo-busqueda = 2 AND (lSectores = lSecAsig ) THEN NEXT.
    /* x Recepcionar */
    IF i-tipo-busqueda = 3 AND (lSecAsig = 0 OR lSecAsig = lSecDev  ) THEN NEXT.
    /* Todos Asignados */
    IF i-tipo-busqueda = 4 AND (lSectores <> lSecAsig ) THEN NEXT.

    IF (pSoloImpresos = NO OR lUserImpresion <> '') THEN DO:
        CREATE ORDENES.
        BUFFER-COPY Faccpedi TO ORDENES.
        ASSIGN
            ORDENES.Libre_c01 = gn-divi.desdiv
            ORDENES.Libre_d01 = fPeso()
            ORDENES.Libre_c02 = ""
            ORDENES.Libre_d02 = fNroItm()
            ORDENES.UsrImpOD = ENTRY(1, Faccpedi.Libre_c02, '|')
            ORDENES.FchImpOD = (IF NUM-ENTRIES(Faccpedi.Libre_c02, '|') > 1 THEN DATETIME(ENTRY(2, Faccpedi.Libre_c02, '|'))
                ELSE ?).
        CASE s-CodDoc:
            WHEN 'O/D' OR WHEN 'O/M' THEN DO:
                ORDENES.Libre_c01 = gn-divi.desdiv.
                ORDENES.NomCli:COLUMN-LABEL IN BROWSE {&browse-name} = "Cliente".
            END.
            WHEN 'OTR' THEN DO:
                ORDENES.Libre_c01 = Faccpedi.codcli.
                ORDENES.NomCli:COLUMN-LABEL IN BROWSE {&browse-name} = "Solicitante".
            END.
        END CASE.

        RUN ue-sectores(INPUT Ordenes.coddoc, INPUT Ordenes.nroped,
                        OUTPUT lSectores, OUTPUT lSecImp, OUTPUT lSecAsig,
                        OUTPUT lSecDev).
        ASSIGN  
            Ordenes.acubon[1] = lSectores
            Ordenes.acubon[2] = lSecImp
            Ordenes.acubon[3] = lSecAsig
            Ordenes.acubon[4] = lSecDev
            Ordenes.acubon[5] = lSectores - lSecAsig.
        ASSIGN 
            ORDENES.Libre_c02 = "SIN EMPEZAR".
        IF lSectores = lSecDev THEN ORDENES.Libre_c02 = "COMPLETADO".
        IF lSecImp > 0 AND lSecImp < lSectores AND lSecAsig = 0 THEN ORDENES.Libre_c02 = "PARCIALMENTE IMPRESOS".
        IF lSecImp > 0 AND lSecAsig = 0 AND lSectores = lSecImp AND lSecDev = 0 THEN ORDENES.Libre_c02 = "SOLO IMPRESOS".
        IF lSecAsig > 0 AND lSecDev > 0 AND lSecDev <> lSectores THEN ORDENES.Libre_c02 = "AVANCE PARCIAL".
        IF lSecAsig > 0 AND lSecDev = 0 AND lSecAsig = lSectores THEN ORDENES.Libre_c02 = "SOLO ASIGNADOS".
        IF lSecAsig > 0 AND lSecDev = 0 AND lSecAsig <> lSectores THEN ORDENES.Libre_c02 = "ASIGNADO PARCIAL".
    END.
END.
*/
SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Rb B-table-Win 
PROCEDURE Carga-Temporal-Rb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE Reporte.
EMPTY TEMP-TABLE Resumen.
EMPTY TEMP-TABLE Resumen2.
x-Ordenes = "".

DEF VAR k AS INT NO-UNDO.

SESSION:SET-WAIT-STATE('').

DO k = 1 TO {&browse-name}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF NOT {&browse-name}:FETCH-SELECTED-ROW(k) THEN NEXT.
    x-Ordenes = x-Ordenes + (IF x-Ordenes = '' THEN '' ELSE ',') + Faccpedi.NroPed.
    /* NO KITS */
    FOR EACH FacDPedi OF FacCPedi NO-LOCK,
        FIRST Almmmatg NO-LOCK WHERE Almmmatg.CodCia = FacDPedi.CodCia
        AND Almmmatg.CodMat = FacDPedi.CodMat:
        FIND FIRST Almckits OF Facdpedi NO-LOCK NO-ERROR.
        IF AVAILABLE Almckits THEN NEXT.
        FIND Reporte WHERE Reporte.CodMat = Facdpedi.codmat NO-ERROR.
        IF NOT AVAILABLE Reporte THEN CREATE Reporte.
        ASSIGN 
            Reporte.CodDoc = FacCPedi.CodDoc
            Reporte.NroPed = FacCPedi.NroPed
            Reporte.CodRef = FacCPedi.CodRef
            Reporte.NroRef = FacCPedi.NroRef
            Reporte.CodMat = FacDPedi.CodMat
            Reporte.DesMat = Almmmatg.DesMat
            Reporte.DesMar = Almmmatg.DesMar
            Reporte.UndBas = Almmmatg.UndBas
            Reporte.CanPed = Reporte.CanPed + ( FacDPedi.CanPed * FacDPedi.Factor )
            Reporte.CodAlm = FacCPedi.CodAlm
            Reporte.CodUbi = "G-0"
            Reporte.CodZona = "G-0"
            Reporte.x-peso = almmmatg.pesmat.
        FIND FIRST Almmmate WHERE Almmmate.CodCia = FacCPedi.CodCia
            AND Almmmate.CodAlm = FacDPedi.AlmDes
            AND Almmmate.CodMat = FacDPedi.CodMat
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN DO:
            ASSIGN 
                Reporte.CodUbi = Almmmate.CodUbi.
            FIND Almtubic WHERE Almtubic.codcia = s-codcia
                AND Almtubic.codubi = Almmmate.codubi
                AND Almtubic.codalm = Almmmate.codalm
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtubic THEN Reporte.CodZona = Almtubic.CodZona.
        END.
        /* Cargamos Resumen */
        FIND Resumen WHERE Resumen.codmat = Facdpedi.codmat NO-ERROR.
        IF NOT AVAILABLE Resumen THEN CREATE Resumen.
        ASSIGN
            Resumen.codmat = Almmmatg.codmat
            Resumen.desmat = Almmmatg.desmat
            Resumen.undbas = Almmmatg.undbas
            Resumen.desmar = Almmmatg.desmar
            Resumen.nroped[k] = Faccpedi.nroped
            Resumen.canped[k] =  FacDPedi.CanPed * FacDPedi.Factor.

        /* Cargamos Resumen2 */
        FIND Resumen2 WHERE Resumen2.x-codcli = Faccpedi.codcli AND 
                        resumen2.coddoc = FacCPedi.CodDoc AND  
                        resumen2.nroped = FacCPedi.NroPed NO-ERROR.
        IF NOT AVAILABLE Resumen2 THEN DO : 
            CREATE Resumen2.
                ASSIGN
                    Resumen2.x-codcli = FACCPEDI.CodCli
                    Resumen2.X-NomCli = FACCPEDI.NomCli
                    resumen2.CodDoc   = FacCPedi.CodDoc
                    resumen2.NroPed   = FacCPedi.NroPed
                    resumen2.X-FECHA  = FACCPEDI.fchped
                    resumen2.X-fchent = faccpedi.fchent
                    resumen2.x-qtyitm = 0
                    resumen2.x-peso   = 0.
        END.
        ASSIGN resumen2.x-qtyitm = resumen2.x-qtyitm + 1.
               resumen2.x-peso  = resumen2.x-peso + (( FacDPedi.CanPed * FacDPedi.Factor ) * almmmatg.pesmat).

    END.
    /* SOLO KITS */
    FOR EACH FacDPedi OF FacCPedi NO-LOCK,
        FIRST Almckits OF Facdpedi NO-LOCK,
        EACH Almdkits OF Almckits NO-LOCK,
        FIRST Almmmatg NO-LOCK WHERE Almmmatg.CodCia = FacCPedi.CodCia
        AND Almmmatg.CodMat = AlmDKits.codmat2:
        FIND Reporte WHERE Reporte.codmat = Facdpedi.codmat NO-ERROR.
        IF NOT AVAILABLE Reporte THEN CREATE Reporte.
        ASSIGN 
            Reporte.CodDoc = FacCPedi.CodDoc
            Reporte.NroPed = FacCPedi.NroPed
            Reporte.CodRef = FacCPedi.CodRef
            Reporte.NroRef = FacCPedi.NroRef
            Reporte.CodMat = Almmmatg.CodMat
            Reporte.DesMat = TRIM(Almmmatg.DesMat) + ' (KIT ' + TRIM(Facdpedi.codmat) + ')'
            Reporte.DesMar = Almmmatg.DesMar
            Reporte.UndBas = Almmmatg.UndBas
            Reporte.CanPed = Reporte.CanPed + ( FacDPedi.CanPed * FacDPedi.Factor *  AlmDKits.Cantidad )
            Reporte.CodAlm = FacCPedi.CodAlm
            Reporte.CodUbi = "G-0"
            Reporte.CodZona = "G-0"
            Reporte.x-peso = almmmatg.pesmat.
        FIND FIRST Almmmate WHERE Almmmate.CodCia = FacCPedi.CodCia
            AND Almmmate.CodAlm = FacDPedi.AlmDes
            AND Almmmate.CodMat = Almmmatg.CodMat
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN DO:
            ASSIGN 
                Reporte.CodUbi = Almmmate.CodUbi.
            FIND Almtubic WHERE Almtubic.codcia = s-codcia
                AND Almtubic.codubi = Almmmate.codubi
                AND Almtubic.codalm = Almmmate.codalm
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtubic THEN Reporte.CodZona = Almtubic.CodZona.
        END.
        /* Cargamos Resumen */
        FIND Resumen WHERE Resumen.codmat = Facdpedi.codmat NO-ERROR.
        IF NOT AVAILABLE Resumen THEN CREATE Resumen.
        ASSIGN
            Resumen.codmat = Almmmatg.codmat
            Resumen.desmat = TRIM(Almmmatg.DesMat) + ' (KIT ' + TRIM(Facdpedi.codmat) + ')'
            Resumen.undbas = Almmmatg.undbas
            Resumen.desmat = Almmmatg.desmat
            Resumen.nroped[k] = Faccpedi.nroped
            Resumen.canped[k] = ( FacDPedi.CanPed * FacDPedi.Factor *  AlmDKits.Cantidad ).

        /* Cargamos Resumen2 */
        FIND Resumen2 WHERE Resumen2.x-codcli = Faccpedi.codcli AND 
                        resumen2.coddoc = FacCPedi.CodDoc AND  
                        resumen2.nroped = FacCPedi.NroPed NO-ERROR.
        IF NOT AVAILABLE Resumen2 THEN DO : 
            CREATE Resumen2.
                ASSIGN
                    Resumen2.x-codcli = FACCPEDI.CodCli
                    Resumen2.X-NomCli = FACCPEDI.NomCli
                    resumen2.CodDoc   = FacCPedi.CodDoc
                    resumen2.NroPed   = FacCPedi.NroPed
                    resumen2.X-FECHA  = FACCPEDI.Libre_f01
                    resumen2.X-fchent = faccpedi.fchent
                    resumen2.x-qtyitm = 0
                    resumen2.x-peso   = 0.
        END.
        ASSIGN resumen2.x-qtyitm = resumen2.x-qtyitm + 1.
               resumen2.x-peso  = resumen2.x-peso + ((FacDPedi.CanPed * FacDPedi.Factor *  AlmDKits.Cantidad ) * almmmatg.pesmat).

    END.
END.

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Control-de-Impresion B-table-Win 
PROCEDURE Control-de-Impresion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR k AS INT NO-UNDO.

  DO k = 1 TO {&browse-name}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
      IF NOT {&browse-name}:FETCH-SELECTED-ROW(k) THEN NEXT.
      IF FacCPedi.FlgImpOD = YES THEN NEXT.
      FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE Faccpedi THEN DO:
          ASSIGN
              FacCPedi.FlgImpOD = YES
              FacCPedi.UsrImpOD = s-user-id
              FacCPedi.FchImpOD = DATETIME(TODAY, MTIME).
              /*FacCPedi.Libre_c02 = s-user-id + '|' + STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM:SS').*/
      END.
      FIND CURRENT Faccpedi NO-LOCK NO-ERROR.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE envia-excel B-table-Win 
PROCEDURE envia-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE x-signo                 AS DECI.

DEFINE VARIABLE lsFechaEmision          AS CHARACTER.
DEFINE VARIABLE lsHoraEmision           AS CHARACTER.

DEFINE VARIABLE ldtFechaEmision         AS DATETIME.
DEFINE VARIABLE ldtFechaDistribucion    AS DATETIME.
DEFINE VARIABLE lsDifTempo_VtaAlm       AS CHARACTER.
DEFINE VARIABLE lsDifTempo_AlmDist      AS CHARACTER.
DEFINE VARIABLE lsDifTempo_VtaDist      AS CHARACTER.

DEFINE VAR lPeso AS DEC.
DEFINE VAR lNomUser AS CHAR.
DEFINE VAR lCodUser AS CHAR.

DEFINE VAR lGuiasHRutas AS CHAR.

SESSION:SET-WAIT-STATE('GENERAL').

        /* create a new Excel Application object */
        CREATE "Excel.Application" chExcelApplication.

        /* launch Excel so it is visible to the user */
        chExcelApplication:Visible = FALSE.

        /* Para crear a new Workbook */
        chWorkbook = chExcelApplication:Workbooks:Add().

        /* get the active Worksheet */
        chWorkSheet = chExcelApplication:Sheets:Item(1).

        /* set the column names for the Worksheet */

        chWorkSheet:Range("A1:R1"):Font:Bold = TRUE.
        chWorkSheet:Range("A1"):Value = "Codigo".
        chWorkSheet:Range("B1"):Value = "Numero".
        chWorkSheet:Range("C1"):Value = "Emision".
        chWorkSheet:Range("D1"):Value = "Hora".
        chWorkSheet:Range("E1"):Value = "Origen".
        chWorkSheet:Range("F1"):Value = "Cliente".
        chWorkSheet:Range("G1"):Value = "Impreso por".
        chWorkSheet:Range("H1"):Value = "Fecha/Hora Impresion".
        chWorkSheet:Range("I1"):Value = "Fecha/Hora Distribucion".      /* Nueva columna */
        chWorkSheet:Range("J1"):Value = "Items".
        chWorkSheet:Range("K1"):Value = "Glosa".
        chWorkSheet:Range("L1"):Value = "De Venta a Almacén".      /* Nueva columna */
        chWorkSheet:Range("M1"):Value = "De Almacén a Distribución".      /* Nueva columna */
        chWorkSheet:Range("N1"):Value = "De Venta a Distribución".      /* Nueva columna */
        chWorkSheet:Range("O1"):Value = "Fech.Entrega".      /* Nueva columna */
        chWorkSheet:Range("P1"):Value = "Peso".      /* Nueva columna */
        chWorkSheet:Range("Q1"):Value = "Usuario envio a distribucion".
        chWorkSheet:Range("R1"):Value = "Nombre Usuario".
        chWorkSheet:Range("S1"):Value = "Guias".
        chWorkSheet:Range("T1"):Value = "Hoja de Rutas".


        iColumn = 1.

    GET FIRST {&BROWSE-NAME}.
    DO  WHILE AVAILABLE faccpedi:
            FIND FIRST gn-div OF faccpedi NO-LOCK.
             iColumn = iColumn + 1.
             cColumn = STRING(iColumn).

             chWorkSheet:Range("A" + cColumn):Value = "'" + faccpedi.coddoc.
             chWorkSheet:Range("B" + cColumn):Value = "'" + faccpedi.nroped.             
             chWorkSheet:Range("C" + cColumn):Value = faccpedi.fchped.             
             chWorkSheet:Range("D" + cColumn):Value = faccpedi.hora.
             cRange = "E" + cColumn.
             chWorkSheet:Range(cRange):Value = IF(AVAILABLE gn-divi) THEN gn-divi.desdiv ELSE "".
             cRange = "F" + cColumn.
             chWorkSheet:Range(cRange):Value = faccpedi.nomcli.
             cRange = "G" + cColumn.
             chWorkSheet:Range(cRange):Value = faccpedi.usrimpod.
             cRange = "H" + cColumn.
             chWorkSheet:Range(cRange):Value = faccpedi.fchimpod.

             cRange = "I" + cColumn.
             chWorkSheet:Range(cRange):Value = IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 1) THEN ENTRY(2,Faccpedi.Libre_c03,'|') ELSE "".

         iCount = 0.
         FOR EACH facdpedi OF faccpedi NO-LOCK:
            iCount = iCount + 1.
         END.
             cRange = "J" + cColumn.
             chWorkSheet:Range(cRange):Value = iCount.
        
             cRange = "K" + cColumn.
             chWorkSheet:Range(cRange):Value = faccpedi.glosa.


         lsFechaEmision = STRING(faccpedi.fchped, '99-99-9999').
         lsHoraEmision  = faccpedi.hora.
         
         ldtFechaEmision      = DATETIME(lsFechaEmision + ' ' + lsHoraEmision).
         ldtFechaDistribucion = DATETIME(IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 1) THEN ENTRY(2,Faccpedi.Libre_c03,'|') ELSE "").

         RUN lib\_time-passed.p (ldtFechaEmision, faccpedi.fchimpod, OUTPUT lsDifTempo_VtaAlm).
         RUN lib\_time-passed.p (faccpedi.fchimpod, ldtFechaDistribucion, OUTPUT lsDifTempo_AlmDist).
         RUN lib\_time-passed.p (ldtFechaEmision, ldtFechaDistribucion, OUTPUT lsDifTempo_VtaDist).
         
         chWorkSheet:Range("L" + cColumn):Value = lsDifTempo_VtaAlm.
         chWorkSheet:Range("M" + cColumn):Value = lsDifTempo_AlmDist.
         chWorkSheet:Range("N" + cColumn):Value = lsDifTempo_VtaDist.
         chWorkSheet:Range("O" + cColumn):Value = faccpedi.fchent.

         lPeso = fPeso().
         chWorkSheet:Range("P" + cColumn):Value = lpeso.
         cRange = "Q" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 2) THEN ENTRY(3,Faccpedi.Libre_c03,'|') ELSE "".

         lCodUser = IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 2) THEN ENTRY(3,Faccpedi.Libre_c03,'|') ELSE "".
         lNomUser = fPersonal(lCodUser).
         cRange = "R" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + lNomUser.

         lGuiasHRutas = "".
         RUN um-get-guias-rutas(INPUT faccpedi.coddoc, INPUT faccpedi.nroped, OUTPUT lGuiasHrutas).

         cRange = "S" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + lGuiasHRutas.
        
         lGuiasHRutas = "".
         RUN um-get-rutas(INPUT faccpedi.coddoc, INPUT faccpedi.nroped, OUTPUT lGuiasHrutas).

         cRange = "T" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + lGuiasHRutas.

         
         GET NEXT {&BROWSE-NAME}.
    END.

    SESSION:SET-WAIT-STATE('').
        
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication NO-ERROR.      
    RELEASE OBJECT chWorkbook NO-ERROR.
    RELEASE OBJECT chWorksheet NO-ERROR.
    RELEASE OBJECT chWorksheetRange NO-ERROR. 

    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE envia-excel-detalle B-table-Win 
PROCEDURE envia-excel-detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE x-signo                 AS DECI.

DEFINE VARIABLE lsFechaEmision          AS CHARACTER.
DEFINE VARIABLE lsHoraEmision           AS CHARACTER.

DEFINE VARIABLE ldtFechaEmision         AS DATETIME.
DEFINE VARIABLE ldtFechaDistribucion    AS DATETIME.
DEFINE VARIABLE lsDifTempo_VtaAlm       AS CHARACTER.
DEFINE VARIABLE lsDifTempo_AlmDist      AS CHARACTER.
DEFINE VARIABLE lsDifTempo_VtaDist      AS CHARACTER.

DEFINE VAR lPeso AS DEC.

SESSION:SET-WAIT-STATE('GENERAL').

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = FALSE.

/* Para crear a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */

chWorkSheet:Range("A1:R1"):Font:Bold = TRUE.
chWorkSheet:Range("A1"):Value = "Codigo".
chWorkSheet:Range("B1"):Value = "Numero".
chWorkSheet:COLUMNS("B"):NumberFormat = "@".
chWorkSheet:Range("C1"):Value = "Emision".
chWorkSheet:COLUMNS("C"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("D1"):Value = "Hora".
chWorkSheet:Range("E1"):Value = "Origen".
chWorkSheet:COLUMNS("E"):NumberFormat = "@".
chWorkSheet:Range("F1"):Value = "Cliente".
chWorkSheet:COLUMNS("F"):NumberFormat = "@".
chWorkSheet:Range("G1"):Value = "Impreso por".
chWorkSheet:Range("H1"):Value = "Fecha/Hora Impresion".
chWorkSheet:Range("I1"):Value = "Fecha/Hora Distribucion".      /* Nueva columna */
chWorkSheet:Range("J1"):Value = "Items".
chWorkSheet:Range("K1"):Value = "Glosa".
chWorkSheet:Range("L1"):Value = "De Venta a Almacén".      /* Nueva columna */
chWorkSheet:Range("M1"):Value = "De Almacén a Distribución".      /* Nueva columna */
chWorkSheet:Range("N1"):Value = "De Venta a Distribución".      /* Nueva columna */
chWorkSheet:Range("O1"):Value = "Fech.Entrega".      /* Nueva columna */
chWorkSheet:COLUMNS("O"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("P1"):Value = "Peso".      /* Nueva columna */
chWorkSheet:Range("Q1"):Value = "Articulo".
chWorkSheet:COLUMNS("Q"):NumberFormat = "@".
chWorkSheet:Range("R1"):Value = "Descripcion".
chWorkSheet:Range("S1"):Value = "Peso Unit".
chWorkSheet:Range("T1"):Value = "Marca".
chWorkSheet:Range("U1"):Value = "Cantidad".
chWorkSheet:Range("V1"):Value = "Unidad".
chWorkSheet:Range("W1"):Value = "Almacen".
chWorkSheet:COLUMNS("W"):NumberFormat = "@".
chWorkSheet:Range("X1"):Value = "Zona".
chWorkSheet:Range("Y1"):Value = "Ubicacion".
chWorkSheet:Range("z1"):Value = "Peso Tot".
chWorkSheet:Range("AA1"):Value = "Usuario envio a Distribucion".
chWorkSheet:Range("AB1"):Value = "Nombre Usuario".

iColumn = 1.

DEFINE VAR lNomUser AS CHAR.
DEFINE VAR lCodUser AS CHAR.

GET FIRST {&BROWSE-NAME}.
DO  WHILE AVAILABLE faccpedi:
    FIND FIRST gn-div OF faccpedi NO-LOCK.
    iCount = 0.
    FOR EACH facdpedi OF faccpedi NO-LOCK:
       iCount = iCount + 1.
    END.
    FOR EACH facdpedi OF faccpedi NO-LOCK :        
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).

        chWorkSheet:Range("A" + cColumn):Value = faccpedi.coddoc.
        chWorkSheet:Range("B" + cColumn):Value = faccpedi.nroped.             
        chWorkSheet:Range("C" + cColumn):Value = faccpedi.fchped.             
        chWorkSheet:Range("D" + cColumn):Value = faccpedi.hora.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = IF(AVAILABLE gn-divi) THEN gn-divi.desdiv ELSE "".        
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = faccpedi.nomcli.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = faccpedi.usrimpod.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = faccpedi.fchimpod.

        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 1) THEN ENTRY(2,Faccpedi.Libre_c03,'|') ELSE "".

        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = iCount.

        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = faccpedi.glosa.


        lsFechaEmision = STRING(faccpedi.fchped, '99-99-9999').
        lsHoraEmision  = faccpedi.hora.

        ldtFechaEmision      = DATETIME(lsFechaEmision + ' ' + lsHoraEmision).
        ldtFechaDistribucion = DATETIME(IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 1) THEN ENTRY(2,Faccpedi.Libre_c03,'|') ELSE "").

        RUN lib\_time-passed.p (ldtFechaEmision, faccpedi.fchimpod, OUTPUT lsDifTempo_VtaAlm).
        RUN lib\_time-passed.p (faccpedi.fchimpod, ldtFechaDistribucion, OUTPUT lsDifTempo_AlmDist).
        RUN lib\_time-passed.p (ldtFechaEmision, ldtFechaDistribucion, OUTPUT lsDifTempo_VtaDist).

        chWorkSheet:Range("L" + cColumn):Value = lsDifTempo_VtaAlm.
        chWorkSheet:Range("M" + cColumn):Value = lsDifTempo_AlmDist.
        chWorkSheet:Range("N" + cColumn):Value = lsDifTempo_VtaDist.
        chWorkSheet:Range("O" + cColumn):Value = faccpedi.fchent.

        lPeso = fPeso().
        chWorkSheet:Range("P" + cColumn):Value = lpeso.

        /* Detalle */
        FIND FIRST almmmatg OF facdpedi NO-LOCK NO-ERROR.
        chWorkSheet:Range("Q" + cColumn):Value = facdpedi.codmat.
        chWorkSheet:Range("R" + cColumn):Value = almmmatg.desmat.
        chWorkSheet:Range("S" + cColumn):Value = almmmatg.pesmat.
        chWorkSheet:Range("T" + cColumn):Value = almmmatg.desmar.
        chWorkSheet:Range("U" + cColumn):Value = facdpedi.canped.
        chWorkSheet:Range("V" + cColumn):Value = facdpedi.undvta.
        chWorkSheet:Range("W" + cColumn):Value = facdpedi.almdes.

        FIND FIRST Almmmate WHERE Almmmate.CodCia = FacDPedi.CodCia
            AND Almmmate.CodAlm = FacDPedi.AlmDes
            AND Almmmate.codmat = FacDPedi.codmat NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN DO:
            FIND FIRST almtubic OF Almmmate NO-LOCK NO-ERROR.
            IF AVAILABLE almtubic THEN chWorkSheet:Range("X" + cColumn):Value = almtubic.CodZona.
            chWorkSheet:Range("Y" + cColumn):Value = Almmmate.CodUbi.
        END.
        chWorkSheet:Range("Z" + cColumn):VALUE = (FacDPedi.CanPed * Almmmatg.Pesmat ).
        chWorkSheet:Range("AA" + cColumn):Value = "'" + IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 2) THEN ENTRY(3,Faccpedi.Libre_c03,'|') ELSE "".

         lCodUser = IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 2) THEN ENTRY(3,Faccpedi.Libre_c03,'|') ELSE "".
         lNomUser = fPersonal(lCodUser).
         cRange = "AB" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + lNomUser.

    END.
    GET NEXT {&BROWSE-NAME}.
END.

SESSION:SET-WAIT-STATE('').
    
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication NO-ERROR.      
RELEASE OBJECT chWorkbook NO-ERROR.
RELEASE OBJECT chWorksheet NO-ERROR.
RELEASE OBJECT chWorksheetRange NO-ERROR. 

MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel B-table-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Archivo de Salida */
DEF VAR c-csv-file AS CHAR NO-UNDO.
DEF VAR c-xls-file AS CHAR INIT 'Archivo_Excel' NO-UNDO.
DEF VAR rpta AS LOG INIT NO NO-UNDO.

SYSTEM-DIALOG GET-FILE c-xls-file
    FILTERS 'Libro de Excel' '*.xlsx'
    INITIAL-FILTER 1
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION ".xlsx"
    SAVE-AS
    TITLE "Guardar como"
    USE-FILENAME
    UPDATE rpta.
IF rpta = NO THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').
/* Variable de memoria */
DEFINE VAR hProc AS HANDLE NO-UNDO.
/* Levantamos la libreria a memoria */
RUN lib\Tools-to-excel PERSISTENT SET hProc.

/* Cargamos la informacion al temporal */
EMPTY TEMP-TABLE Detalle.
DEF BUFFER B-ORDENES FOR ORDENES.
DEF BUFFER B-Faccpedi FOR Faccpedi.
DEF BUFFER x-Faccpedi FOR Faccpedi.
DEF BUFFER x-almtabla FOR almtabla.
DEF BUFFER x-gn-divi FOR gn-divi.
DEF BUFFER x-tabdistr FOR tabdistr.

&SCOPED-DEFINE CONDICION2a (s-busqueda = '< Todos >' OR B-ORDENES.libre_c02 = s-busqueda)

DEFINE VAR x-nro-ra AS INT.
DEFINE VAR x-ser-ra AS INT.

FOR EACH B-ORDENES WHERE {&CONDICION2a} NO-LOCK, FIRST B-Faccpedi OF B-ORDENES NO-LOCK
    BY B-Faccpedi.FchPed DESC BY B-Faccpedi.Hora DESC:
    CREATE Detalle.
    ASSIGN
        Detalle.Situacion = B-ORDENES.Libre_c02
        Detalle.CodPed    = B-ORDENES.CodDoc
        Detalle.NroPed    = B-ORDENES.NroPed
        Detalle.FchPed    = B-ORDENES.FchPed
        Detalle.Hora      = B-ORDENES.Hora
        Detalle.FchEnt    = B-ORDENES.FchEnt
        Detalle.FchSit    = B-ORDENES.DeliveryDate
        Detalle.Origen    = B-ORDENES.Libre_c01
        Detalle.NomCli    = B-ORDENES.NomCli
        Detalle.Peso      = B-ORDENES.Libre_d01
        Detalle.Importe_Nac = (IF B-ORDENES.CodMon = 1 THEN B-ORDENES.ImpTot ELSE 0)
        Detalle.Importe_Ext = (IF B-ORDENES.CodMon = 2 THEN B-ORDENES.ImpTot ELSE 0)
        Detalle.Sectores  = B-ORDENES.AcuBon[1]
        Detalle.Impresos  = B-ORDENES.AcuBon[2]
        Detalle.Asignados = B-ORDENES.AcuBon[3]
        Detalle.Recepcionados = B-ORDENES.AcuBon[4]
        Detalle.PorAsignar = B-ORDENES.AcuBon[5]
        Detalle.UsrImpOD   = B-Faccpedi.UsrImpOD
        Detalle.FchImpOD   = B-Faccpedi.FchImpOD
        Detalle.Items      = B-ORDENES.Libre_d02
        Detalle.Glosa      = B-Faccpedi.Glosa
        Detalle.CodRef     = B-Faccpedi.CodRef
        Detalle.NroRef     = B-Faccpedi.NroRef
        Detalle.OrdCmp     = B-ORDENES.ordcmp
        detalle.codpos      = b-faccpedi.codpos.

    /* Postal  - PEDIDO*/
    FIND FIRST x-Faccpedi WHERE x-Faccpedi.codcia = s-codcia AND
                                x-Faccpedi.coddoc = B-Faccpedi.CodRef AND 
                                x-Faccpedi.nroped = B-Faccpedi.NroRef NO-LOCK NO-ERROR.
    IF AVAILABLE x-faccpedi THEN DO:
        FIND FIRST x-almtabla WHERE x-almtabla.tabla = 'CP' AND 
                                    x-almtabla.codigo = b-faccpedi.codpos NO-LOCK NO-ERROR.
        IF AVAILABLE x-almtabla THEN ASSIGN detalle.nompos = x-almtabla.nombre.
        IF x-Faccpedi.CodRef = "COT" THEN ASSIGN Detalle.NroCot = x-Faccpedi.NroRef.
        IF x-Faccpedi.CodDoc = "PED" THEN ASSIGN Detalle.ImpRef = x-Faccpedi.ImpTot.
    END.
    ELSE DO:
        IF B-Faccpedi.CodRef = 'R/A' THEN DO:

            FIND FIRST almacen WHERE almacen.codcia = s-codcia AND 
                                        almacen.codalm = B-Faccpedi.codcli
                                        NO-LOCK NO-ERROR.
            IF AVAILABLE almacen THEN DO:
                FIND FIRST x-gn-divi WHERE x-gn-divi.codcia = s-codcia AND 
                                            x-gn-divi.coddiv = almacen.coddiv
                                            NO-LOCK NO-ERROR.
                IF AVAILABLE x-gn-divi THEN DO:
                    FIND FIRST x-tabdistr WHERE x-tabdistr.coddepto = x-gn-divi.campo-char[3] AND 
                                                x-tabdistr.codprovi = x-gn-divi.campo-char[4] AND 
                                                x-tabdistr.coddistr = x-gn-divi.campo-char[5] 
                                                NO-LOCK NO-ERROR.
                    IF AVAILABLE x-tabdistr THEN DO:
                        ASSIGN detalle.codpos      = x-tabdistr.codpos
                                detalle.nompos      = x-tabdistr.nomdistr.
                    END.
                END.
            END.
        END.
    END.

END.

/* Programas que generan el Excel */
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER Detalle:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .

RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER Detalle:handle,
                                  INPUT  c-csv-file,
                                  OUTPUT c-xls-file) .

/* Borramos librerias de la memoria */
DELETE PROCEDURE hProc.
SESSION:SET-WAIT-STATE('').
MESSAGE 'Proceso Concluido' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE excel-subordenes B-table-Win 
PROCEDURE excel-subordenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-Archivo AS CHAR.                                    
DEFINE VAR rpta AS LOG.
                                    
SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Excel (*.xlsx)' '*.xlsx'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.xlsx'
    RETURN-TO-START-DIR
    SAVE-AS
    TITLE 'Exportar a Excel'
    UPDATE rpta.
IF rpta = NO OR x-Archivo = '' THEN RETURN.

DEFINE VAR x-tiempo AS CHAR INIT "".

EMPTY TEMP-TABLE tt-subordxls.

SESSION:SET-WAIT-STATE('GENERAL').

DEFINE VAR lPeso AS DEC.
DEFINE VAR lCant AS DEC.
DEFINE VAR lItems AS INT.

GET FIRST {&BROWSE-NAME}.
DO WHILE AVAILABLE ordenes :
    FIND FIRST gn-div OF faccpedi NO-LOCK.
    FOR EACH vtacdocu WHERE vtacdocu.codcia = s-codcia AND
                            vtacdocu.codped = ordenes.coddoc AND
                            vtacdocu.nroped BEGINS ordenes.nroped NO-LOCK:
          IF VtaCDocu.fecsac <> ? THEN DO:
              IF NUM-ENTRIES(VtaCDocu.libre_c03,"|") > 1  THEN DO:
                    RUN lib/_time-passed (DATETIME(STRING(VtaCDocu.fecsac,"99/99/9999") + " " + VtaCDocu.horsac), DATETIME(ENTRY(2,VtaCDocu.libre_c03,"|")), OUTPUT x-Tiempo).
              END.
              ELSE DO:
                    RUN lib/_time-passed (DATETIME(STRING(VtaCDocu.fecsac,"99/99/9999") + " " + VtaCDocu.horsac), DATETIME(TODAY, MTIME), OUTPUT x-Tiempo).                
              END.
          END.

        lPeso = 0.
        lCant = 0.
        lItems = 0.
        RUN peso-cant-subordenes(OUTPUT lPeso, OUTPUT lCant, OUTPUT lItems).

        CREATE tt-subordxls.
            ASSIGN tt-coddoc = vtacdocu.codped
                    tt-nrodoc = ordenes.nroped
                    tt-fchemi = ordenes.fchped
                    tt-horemi = ordenes.hora
                    tt-descli = ordenes.nomcli
                    tt-fchent = ordenes.fchent
                    tt-usrimp = vtacdocu.usrimpod
                    tt-superv = VtaCDocu.UsrSacAsign
                    tt-sacador = VtaCDocu.UsrSac
                    tt-tiempo  = x-tiempo.

                    tt-origen = IF(AVAILABLE gn-divi) THEN gn-divi.desdiv ELSE "".
                    tt-fhimp  = STRING(vtacdocu.fchimpod,"99/99/9999 hh:mm:ss").
                    tt-sector = ENTRY(2,vtacdocu.nroped,"-").
                    tt-hinicio = STRING(VtaCDocu.fecsac,"99/99/9999") + " " + VtaCDocu.horsac.
                    tt-hfinal  = IF(NUM-ENTRIES(VtaCDocu.libre_c03,"|")>1) THEN ENTRY(2,VtaCDocu.libre_c03,"|") ELSE "".
                    
                    tt-peso   = lPeso.   /*fPesoSub()*/
                    tt-cant   = lCant.   /*fCantidadSub()*/
                    tt-items  = lItems.  /*fNroItmSub()*/


    END.
    GET NEXT {&BROWSE-NAME}.
END.

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

c-xls-file = x-Archivo.

run pi-crea-archivo-csv IN hProc (input  buffer tt-subordxls:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-subordxls:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.

SESSION:SET-WAIT-STATE('').
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

/*

/* ----------------------------------------------------------------------------- */
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE x-signo                 AS DECI.

DEFINE VARIABLE lsFechaEmision          AS CHARACTER.
DEFINE VARIABLE lsHoraEmision           AS CHARACTER.

DEFINE VARIABLE ldtFechaEmision         AS DATETIME.
DEFINE VARIABLE ldtFechaDistribucion    AS DATETIME.
DEFINE VARIABLE lsDifTempo_VtaAlm       AS CHARACTER.
DEFINE VARIABLE lsDifTempo_AlmDist      AS CHARACTER.
DEFINE VARIABLE lsDifTempo_VtaDist      AS CHARACTER.

DEFINE VAR lPeso AS DEC.
DEFINE VAR lNomUser AS CHAR.
DEFINE VAR lCodUser AS CHAR.

DEFINE VAR lGuiasHRutas AS CHAR.

SESSION:SET-WAIT-STATE('GENERAL').

        /* create a new Excel Application object */
        CREATE "Excel.Application" chExcelApplication.

        /* launch Excel so it is visible to the user */
        chExcelApplication:Visible = FALSE.

        /* Para crear a new Workbook */
        chWorkbook = chExcelApplication:Workbooks:Add().

        /* get the active Worksheet */
        chWorkSheet = chExcelApplication:Sheets:Item(1).

        /* set the column names for the Worksheet */

        chWorkSheet:Range("A1:R1"):Font:Bold = TRUE.
        chWorkSheet:Range("A1"):Value = "Codigo".
        chWorkSheet:Range("B1"):Value = "Numero".
        chWorkSheet:Range("C1"):Value = "Emision".
        chWorkSheet:Range("D1"):Value = "Hora".
        chWorkSheet:Range("E1"):Value = "Origen".
        chWorkSheet:Range("F1"):Value = "Cliente".
        chWorkSheet:Range("G1"):Value = "Impreso por".
        chWorkSheet:Range("H1"):Value = "Fecha/Hora Impresion".
        chWorkSheet:Range("I1"):Value = "Fecha/Hora Distribucion".      /* Nueva columna */
        chWorkSheet:Range("J1"):Value = "Items".
        chWorkSheet:Range("K1"):Value = "Glosa".
        chWorkSheet:Range("L1"):Value = "De Venta a Almacén".      /* Nueva columna */
        chWorkSheet:Range("M1"):Value = "De Almacén a Distribución".      /* Nueva columna */
        chWorkSheet:Range("N1"):Value = "De Venta a Distribución".      /* Nueva columna */
        chWorkSheet:Range("O1"):Value = "Fech.Entrega".      /* Nueva columna */
        chWorkSheet:Range("P1"):Value = "Peso".      /* Nueva columna */
        chWorkSheet:Range("Q1"):Value = "Usuario envio a distribucion".
        chWorkSheet:Range("R1"):Value = "Nombre Usuario".
        chWorkSheet:Range("S1"):Value = "Guias".
        chWorkSheet:Range("T1"):Value = "Hoja de Rutas".


        iColumn = 1.

    GET FIRST {&BROWSE-NAME}.
    DO  WHILE AVAILABLE faccpedi:
            FIND FIRST gn-div OF faccpedi NO-LOCK.
             iColumn = iColumn + 1.
             cColumn = STRING(iColumn).

             chWorkSheet:Range("A" + cColumn):Value = "'" + faccpedi.coddoc.
             chWorkSheet:Range("B" + cColumn):Value = "'" + faccpedi.nroped.             
             chWorkSheet:Range("C" + cColumn):Value = faccpedi.fchped.             
             chWorkSheet:Range("D" + cColumn):Value = faccpedi.hora.
             cRange = "E" + cColumn.
             chWorkSheet:Range(cRange):Value = IF(AVAILABLE gn-divi) THEN gn-divi.desdiv ELSE "".
             cRange = "F" + cColumn.
             chWorkSheet:Range(cRange):Value = faccpedi.nomcli.
             cRange = "G" + cColumn.
             chWorkSheet:Range(cRange):Value = faccpedi.usrimpod.
             cRange = "H" + cColumn.
             chWorkSheet:Range(cRange):Value = faccpedi.fchimpod.

             cRange = "I" + cColumn.
             chWorkSheet:Range(cRange):Value = IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 1) THEN ENTRY(2,Faccpedi.Libre_c03,'|') ELSE "".

         iCount = 0.
         FOR EACH facdpedi OF faccpedi NO-LOCK:
            iCount = iCount + 1.
         END.
             cRange = "J" + cColumn.
             chWorkSheet:Range(cRange):Value = iCount.
        
             cRange = "K" + cColumn.
             chWorkSheet:Range(cRange):Value = faccpedi.glosa.


         lsFechaEmision = STRING(faccpedi.fchped, '99-99-9999').
         lsHoraEmision  = faccpedi.hora.
         
         ldtFechaEmision      = DATETIME(lsFechaEmision + ' ' + lsHoraEmision).
         ldtFechaDistribucion = DATETIME(IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 1) THEN ENTRY(2,Faccpedi.Libre_c03,'|') ELSE "").

         RUN lib\_time-passed.p (ldtFechaEmision, faccpedi.fchimpod, OUTPUT lsDifTempo_VtaAlm).
         RUN lib\_time-passed.p (faccpedi.fchimpod, ldtFechaDistribucion, OUTPUT lsDifTempo_AlmDist).
         RUN lib\_time-passed.p (ldtFechaEmision, ldtFechaDistribucion, OUTPUT lsDifTempo_VtaDist).
         
         chWorkSheet:Range("L" + cColumn):Value = lsDifTempo_VtaAlm.
         chWorkSheet:Range("M" + cColumn):Value = lsDifTempo_AlmDist.
         chWorkSheet:Range("N" + cColumn):Value = lsDifTempo_VtaDist.
         chWorkSheet:Range("O" + cColumn):Value = faccpedi.fchent.

         lPeso = fPeso().
         chWorkSheet:Range("P" + cColumn):Value = lpeso.
         cRange = "Q" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 2) THEN ENTRY(3,Faccpedi.Libre_c03,'|') ELSE "".

         lCodUser = IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 2) THEN ENTRY(3,Faccpedi.Libre_c03,'|') ELSE "".
         lNomUser = fPersonal(lCodUser).
         cRange = "R" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + lNomUser.

         lGuiasHRutas = "".
         RUN um-get-guias-rutas(INPUT faccpedi.coddoc, INPUT faccpedi.nroped, OUTPUT lGuiasHrutas).

         cRange = "S" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + lGuiasHRutas.
        
         lGuiasHRutas = "".
         RUN um-get-rutas(INPUT faccpedi.coddoc, INPUT faccpedi.nroped, OUTPUT lGuiasHrutas).

         cRange = "T" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + lGuiasHRutas.

         
         GET NEXT {&BROWSE-NAME}.
    END.

    SESSION:SET-WAIT-STATE('').
        
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication NO-ERROR.      
    RELEASE OBJECT chWorkbook NO-ERROR.
    RELEASE OBJECT chWorksheet NO-ERROR.
    RELEASE OBJECT chWorksheetRange NO-ERROR. 

    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Rb-500 B-table-Win 
PROCEDURE Formato-Rb-500 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE conta   AS INTEGER NO-UNDO INIT 1.    
DEFINE VARIABLE c-items        AS INTEGER  NO-UNDO.
DEFINE VARIABLE npage          AS INTEGER  NO-UNDO.
DEFINE VAR lpeso AS DEC.

lpeso = fPeso().

c-items = 13.       /* por pagina */
npage = 0.          /* # de paginas */
conta = 1.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    conta = conta + 1.
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        npage = npage + 1.
        conta = 1.
    END.
END.

x-Direccion = gn-clie.dircli.
FIND TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
IF AVAILABLE TabDepto THEN DO:
    x-Direccion = TRIM(x-Direccion) + " - " + TRIM(TabDepto.NomDepto).
    FIND TabProvi WHERE TabProvi.CodDepto = gn-clie.CodDept 
        AND TabProvi.CodProvi = gn-clie.CodProv
        NO-LOCK NO-ERROR.
    IF AVAILABLE TabProvi THEN DO:
        x-Direccion = x-Direccion + ' - '+ TRIM(TabProvi.NomProvi).
        FIND TabDistr WHERE TabDistr.CodDepto = gn-clie.CodDept
            AND TabDistr.CodProvi = gn-clie.CodProv
            AND TabDistr.CodDistr = gn-clie.CodDist
            NO-LOCK NO-ERROR.
        IF AVAILABLE TabDistr THEN x-Direccion = x-Direccion + ' - ' + TabDistr.NomDistr.
    END.
END.
x-Comprobante = ''.
FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.codped = Faccpedi.codref
    AND Ccbcdocu.nroped = Faccpedi.nroref
    AND Ccbcdocu.flgest <> 'A'
    NO-LOCK NO-ERROR.
IF AVAILABLE Ccbcdocu THEN x-Comprobante = Ccbcdocu.coddoc + ' ' + Ccbcdocu.nrodoc.
    

DEFINE FRAME f-cab
        Reporte.CodUbi FORMAT "x(10)"
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + s-NomCia + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN4} + {&PRN7A} + {&PRN6B} + "        Pagina: " + STRING(PAGE-NUMBER(REPORT), "ZZ9") + "/" + STRING(npage, "ZZ9") + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(40)" AT 80 SKIP
        {&PRN4} + {&PRN6A} + "      Fecha: " + STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(27)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "      N° ORDEN: " + Reporte.CodDoc + ' ' + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "     Origen: " + GN-DIVI.DesDiv + {&PRN6B} + {&PRN3} FORMAT "X(50)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "     N° PEDIDO: " + Reporte.CodRef + ' ' + Reporte.NroRef + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "   Vendedor: " + gn-ven.NomVen + {&PRN6B} + {&PRN3} FORMAT "X(50)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "N° COMPROBANTE: " + x-Comprobante + {&PRN6B} + {&PRN7B} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "    Cliente: " + Faccpedi.nomcli + {&PRN6B} FORMAT "X(50)"        
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Fec. Despacho : " + STRING(faccpedi.fchent,"99/99/9999") + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "       Hora: " + STRING(TIME,"HH:MM") + {&PRN6B} FORMAT "X(22)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "         Peso : " + STRING(lPeso,">>>,>>9.99") + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "  Dirección: " + x-Direccion + {&PRN6B} FORMAT "X(120)" SKIP
        "Ubicación  Código  Descripción                                                    Marca                  Unidad      Cantidad Observaciones            " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     1234567890 9999999 123456789012345678901234567890123456789012345678901234567890 123456789012345678901234 1234 >>,>>>,>>9.9999 ________________________ */
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

conta = 1.
FOR EACH Reporte BREAK BY Reporte.CodZon BY SUBSTRING(Reporte.CodUbi,1,2) BY Reporte.CodUbi BY Reporte.CodMat:
    DISPLAY STREAM Report 
        Reporte.CodUbi
        Reporte.CodMat 
        Reporte.DesMat
        Reporte.DesMar
        Reporte.UndBas
        Reporte.CanPed
        "________________________"
        WITH FRAME f-cab.
    conta = conta + 1.
    IF LAST-OF(SUBSTRING(Reporte.CodUbi,1,2)) THEN DO:
        DOWN STREAM Report 1 WITH FRAME f-cab.
    END.
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        PAGE STREAM Report.
        conta = 1.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Rb-Multi B-table-Win 
PROCEDURE Formato-Rb-Multi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE conta   AS INTEGER NO-UNDO INIT 1.    
DEFINE VARIABLE c-items AS INTEGER NO-UNDO.
DEFINE VARIABLE npage   AS INTEGER NO-UNDO.
DEFINE VARIABLE n-Item  AS INTEGER NO-UNDO.
DEFINE VARIABLE t-Items AS INTEGER NO-UNDO.

DEFINE VAR lPeso AS DEC.
lPeso = fPeso().

c-items = 13.       /* por pagina */
npage = 0.          /* # de paginas */
conta = 1.
t-Items = 0.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    conta = conta + 1.
    t-Items = t-Items + 1.
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        npage = npage + 1.
        conta = 1.
    END.
END.

DEFINE FRAME f-cab
        n-Item         FORMAT '>9'
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
        HEADER
        {&PRN2} + {&PRN7A} + s-NOMCIA + {&PRN7B} + {&PRN2} FORMAT "X(45)" SKIP
        {&PRN3} + {&PRN7A} + "Pagina: " + STRING(PAGE-NUMBER(REPORT), "Z9") + "/" + STRING(npage, "Z9") + {&PRN7B} + {&PRN3} FORMAT 'x(20)' AT 70 SKIP
        {&PRN4} + "      Fecha: " + STRING(TODAY,"99/99/9999") AT 1 FORMAT "X(30)"
        {&PRN3} + "   N° DE ITEMS: " + STRING(t-Items, '>>>9') AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + "       Hora: " + STRING(TIME,"HH:MM") FORMAT "X(20)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Fec. Despacho : " + STRING(faccpedi.fchent,"99/99/9999") + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + "    Ordenes: " + x-Ordenes  FORMAT "X(120)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "         Peso : " + STRING(lPeso,">>>,>>9.99") + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP        
        {&PRN4} + {&PRN6B} + "It Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     12 999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

conta = 1.
n-Item = 1.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    DISPLAY STREAM Report 
        n-Item
        Reporte.CodMat 
        Reporte.DesMat
        Reporte.DesMar
        Reporte.UndBas
        Reporte.CanPed
        Reporte.CodUbi
        "________________________"
        WITH FRAME f-cab.
    conta = conta + 1.
    n-Item = n-Item + 1.
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        PAGE STREAM Report.
        conta = 1.
        n-Item = 1.
    END.
END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Rb-Multi-Resumen B-table-Win 
PROCEDURE Formato-Rb-Multi-Resumen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE npage   AS INTEGER NO-UNDO.
DEFINE VARIABLE n-Item  AS INTEGER NO-UNDO.
DEFINE VARIABLE k AS INT NO-UNDO.
DEFINE VARIABLE j AS INT NO-UNDO.
DEFINE VARIABLE z AS INT NO-UNDO.
DEFINE VARIABLE x-Cabecera   AS CHAR NO-UNDO.
DEFINE VARIABLE x-Linea      AS CHAR NO-UNDO.
DEFINE VARIABLE x-CanPed     AS DEC  NO-UNDO.

/* Imprimimos por cada 7 ordenes de despacho */
j = 0.
x-Cabecera = "Codigo Descripcion                                  Marca           Unidad ".
            /*123456 123456789012345678901234567890123456789012345678901234567890 123456 */
DO k = 1 TO NUM-ENTRIES(x-Ordenes):
    j = j + 1.
    x-Cabecera = x-Cabecera + ' ' + STRING(ENTRY(k, x-Ordenes), 'x(9)') .
    DEFINE FRAME f-cab
        x-Linea FORMAT 'x(160)'
        HEADER
        {&PRN2} + {&PRN7A} + s-NOMCIA + {&PRN7B} + {&PRN2} FORMAT "X(45)" SKIP
        {&PRN3} + {&PRN7A} + "Pagina: " + STRING(PAGE-NUMBER(REPORT), "Z9") + {&PRN7B} + {&PRN3} FORMAT 'x(20)' AT 70 SKIP
        {&PRN4} + "      Fecha: " + STRING(TODAY,"99/99/9999") AT 1 FORMAT "X(30)"
        {&PRN4} + "       Hora: " + STRING(TIME,"HH:MM") FORMAT "X(20)" SKIP
        {&PRN4} + "    Ordenes: " + x-Ordenes  FORMAT "X(120)" SKIP
        x-Cabecera FORMAT 'x(160)'
        WITH WIDTH 160 NO-BOX NO-LABELS STREAM-IO DOWN.
    IF j = 8 THEN DO:
        FOR EACH Resumen:
            /* Veamos si tienen cantidades */
            x-CanPed = 0.
            DO z = k - 7 TO k:
                x-CanPed = x-CanPed + Resumen.CanPed[z].
            END.
            IF x-CanPed > 0 THEN DO:
                /* Impresion de linea */
                x-Linea = Resumen.codmat + ' ' + STRING(Resumen.desmat, 'x(44)') + ' ' + 
                    STRING(Resumen.desmar, 'x(15)') + ' ' +
                    STRING(Resumen.UndBas, 'x(6)').
                DO z = k - 7 TO k:
                    x-Linea = x-Linea + ' ' + STRING(Resumen.CanPed[z], '>>,>>9.99').
                END.
                DISPLAY STREAM Report 
                    x-Linea 
                    WITH FRAME f-Cab.
            END.
        END.
        x-Cabecera = "Codigo Descripcion                                  Marca           Unidad ".
        j = 0.
    END.
END.

k = k - 1.
IF j > 0  THEN DO:
    PAGE STREAM REPORT.
    DEFINE FRAME f-cab-2
        x-Linea FORMAT 'x(160)'
        HEADER
        {&PRN2} + {&PRN7A} + s-NOMCIA + {&PRN7B} + {&PRN2} FORMAT "X(45)" SKIP
        {&PRN3} + {&PRN7A} + "Pagina: " + STRING(PAGE-NUMBER(REPORT), "Z9") + {&PRN7B} + {&PRN3} FORMAT 'x(20)' AT 70 SKIP
        {&PRN4} + "      Fecha: " + STRING(TODAY,"99/99/9999") AT 1 FORMAT "X(30)"
        {&PRN4} + "       Hora: " + STRING(TIME,"HH:MM") FORMAT "X(20)" SKIP
        {&PRN4} + "    Ordenes: " + x-Ordenes  FORMAT "X(120)" SKIP
        x-Cabecera FORMAT 'x(160)'
        WITH WIDTH 160 NO-BOX NO-LABELS STREAM-IO DOWN.
    FOR EACH Resumen:
        /* Veamos si tienen cantidades */
        x-CanPed = 0.
        DO z = k - j + 1 TO k:
            x-CanPed = x-CanPed + Resumen.CanPed[z].
        END.
        IF x-CanPed > 0 THEN DO:
            /* Impresion de linea */
            x-Linea = Resumen.codmat + ' ' + STRING(Resumen.desmat, 'x(44)') + ' ' + 
                STRING(Resumen.desmar, 'x(15)') + ' ' +
                STRING(Resumen.UndBas, 'x(6)').
            DO z = k - j + 1 TO k:
                x-Linea = x-Linea + ' ' + STRING(Resumen.CanPed[z], '>>,>>9.99').
            END.
            DISPLAY STREAM Report 
                x-Linea
                WITH FRAME f-Cab-2.
        END.
    END.
END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formato-rb-multi-resumen2 B-table-Win 
PROCEDURE formato-rb-multi-resumen2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE conta   AS INTEGER NO-UNDO INIT 1.    
DEFINE VARIABLE c-items AS INTEGER NO-UNDO.
DEFINE VARIABLE n-item AS INTEGER NO-UNDO.

c-items = 13.       /* por pagina */

DEFINE FRAME f-cab         
        resumen2.X-codcli   FORMAT 'X(11)'
        resumen2.X-NomCli   FORMAT 'x(60)'
        resumen2.CodDoc     FORMAT 'x(4)'
        resumen2.NroPed     FORMAT 'x(10)'
        resumen2.X-FECHA     
        resumen2.X-fchent     
        resumen2.x-qtyitm FORMAT ">>>>9"
        resumen2.x-peso FORMAT ">>>,>>>,>>9.99"
        HEADER
        {&PRN2} + {&PRN7A} + s-NOMCIA + {&PRN7B} + {&PRN2} FORMAT "X(45)" SKIP
        {&PRN3} + {&PRN7A} + "Pagina: " + STRING(PAGE-NUMBER(REPORT), "Z9") + {&PRN7B} + {&PRN3} FORMAT 'x(20)' AT 70 SKIP
        {&PRN4} + "      Fecha: " + STRING(TODAY,"99/99/9999") AT 1 FORMAT "X(30)"
        {&PRN4} + "       Hora: " + STRING(TIME,"HH:MM") FORMAT "X(30)" SKIP
        {&PRN4} + {&PRN6B} + "Codigo      Nombre del Cliente                                           Nro de Orden   Emision    Entrega    Itms  Peso         " FORMAT 'x(160)' SKIP
        "---------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.        
/**     "99999999999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx X/X xxxxxxxxxx xx/xx/xxxx xx/xx/xxxx 99999 999,999,999.99 */

conta = 1.
n-Item = 1.
FOR EACH resumen2:
    DISPLAY STREAM Report 
        resumen2.X-codcli
        resumen2.X-NomCli
        resumen2.CodDoc
        resumen2.NroPed
        resumen2.X-FECHA     
        resumen2.X-fchent     
        resumen2.x-qtyitm
        resumen2.x-peso
        WITH FRAME f-cab.
    conta = conta + 1.
    n-Item = n-Item + 1.
    IF conta > c-items  THEN DO:
        PAGE STREAM Report.
        conta = 1.
        n-Item = 1.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Rb-OD B-table-Win 
PROCEDURE Formato-Rb-OD :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE conta   AS INTEGER NO-UNDO INIT 1.    
DEFINE VARIABLE c-items AS INTEGER NO-UNDO.
DEFINE VARIABLE npage   AS INTEGER NO-UNDO.
DEFINE VARIABLE n-Item  AS INTEGER NO-UNDO.
DEFINE VARIABLE t-Items AS INTEGER NO-UNDO.

DEFINE VAR lpeso AS DEC.

lPeso = 0.
lpeso = fpeso().

c-items = 13.       /* por pagina */
npage = 0.          /* # de paginas */
conta = 1.
t-Items = 0.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    conta = conta + 1.
    t-Items = t-Items + 1.
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        npage = npage + 1.
        conta = 1.
    END.
END.

FIND gn-divi OF Faccpedi NO-LOCK NO-ERROR.
FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = Faccpedi.codcli NO-LOCK NO-ERROR.
FIND gn-ven OF Faccpedi NO-LOCK NO-ERROR.
x-Direccion = gn-clie.dircli.
FIND TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
IF AVAILABLE TabDepto THEN DO:
    x-Direccion = TRIM(x-Direccion) + " - " + TRIM(TabDepto.NomDepto).
    FIND TabProvi WHERE TabProvi.CodDepto = gn-clie.CodDept 
        AND TabProvi.CodProvi = gn-clie.CodProv
        NO-LOCK NO-ERROR.
    IF AVAILABLE TabProvi THEN DO:
        x-Direccion = x-Direccion + ' - '+ TRIM(TabProvi.NomProvi).
        FIND TabDistr WHERE TabDistr.CodDepto = gn-clie.CodDept
            AND TabDistr.CodProvi = gn-clie.CodProv
            AND TabDistr.CodDistr = gn-clie.CodDist
            NO-LOCK NO-ERROR.
        IF AVAILABLE TabDistr THEN x-Direccion = x-Direccion + ' - ' + TabDistr.NomDistr.
    END.
END.
x-Comprobante = ''.
FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.codped = Faccpedi.codref
    AND Ccbcdocu.nroped = Faccpedi.nroref
    AND Ccbcdocu.flgest <> 'A'
    NO-LOCK NO-ERROR.
IF AVAILABLE Ccbcdocu THEN x-Comprobante = Ccbcdocu.coddoc + ' ' + Ccbcdocu.nrodoc.
    
DEF VAR x-NomCli AS CHAR NO-UNDO.

x-NomCli = Faccpedi.nomcli.
RUN lib/limpiar-texto ( x-NomCli, '', OUTPUT x-NomCli).
DEFINE FRAME f-cab
        n-Item         FORMAT '>9'
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + s-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " + STRING(PAGE-NUMBER(REPORT), "Z9") + "/" + STRING(npage, "Z9") FORMAT 'x(20)' AT 75 SKIP
        {&PRN4} + {&PRN6A} + "      Fecha: " AT 1 FORMAT "X(17)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "      N° ORDEN: " + Reporte.CodDoc + ' ' + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "     N° PEDIDO: " + Reporte.CodRef + ' ' + Reporte.NroRef + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "N° COMPROBANTE: " + x-Comprobante + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "   N° DE ITEMS: " + STRING(t-Items, '>>>9') + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "     Origen: " + GN-DIVI.DesDiv + {&PRN6B} + {&PRN3} FORMAT "X(50)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Fec. Despacho : " + STRING(faccpedi.fchent,"99/99/9999") + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "   Vendedor: " + gn-ven.NomVen + {&PRN6B} + {&PRN3} FORMAT "X(50)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "         Peso : " + STRING(lPeso,">>>,>>9.99") + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "    Cliente: " + x-NomCli + {&PRN6B} + {&PRN3} FORMAT "X(50)" SKIP
        {&PRN4} + {&PRN6B} + "       Hora: " STRING(TIME,"HH:MM") FORMAT "X(12)" SKIP
        {&PRN4} + {&PRN6B} + "  Dirección: " + x-Direccion FORMAT "X(120)" SKIP
        {&PRN4} + {&PRN6B} + "Observación: " + Faccpedi.glosa  FORMAT "X(80)" SKIP
        "It Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     12 999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

conta = 1.
n-Item = 1.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    DISPLAY STREAM Report 
        n-Item
        Reporte.CodMat 
        Reporte.DesMat
        Reporte.DesMar
        Reporte.UndBas
        Reporte.CanPed
        Reporte.CodUbi
        "________________________"
        WITH FRAME f-cab.
    conta = conta + 1.
    n-Item = n-Item + 1.
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        PAGE STREAM Report.
        conta = 1.
        n-Item = 1.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Rb-OTR B-table-Win 
PROCEDURE Formato-Rb-OTR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE conta   AS INTEGER NO-UNDO INIT 1.    
DEFINE VARIABLE c-items AS INTEGER NO-UNDO.
DEFINE VARIABLE npage   AS INTEGER NO-UNDO.
DEFINE VARIABLE n-Item  AS INTEGER NO-UNDO.
DEFINE VARIABLE t-Items AS INTEGER NO-UNDO.

DEFINE VAR x-pesotot AS DEC.

c-items = 13.       /* por pagina */
npage = 0.          /* # de paginas */
conta = 1.
t-Items = 0.
x-pesotot = 0.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    conta = conta + 1.
    t-Items = t-Items + 1.
    x-pesotot = x-pesotot + (Reporte.canped * reporte.X-peso).
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        npage = npage + 1.
        conta = 1.
    END.
END.

/* Glosa desde las SOLICTUDES DE R/A  */
DEFINE VAR lxSer AS INT.
DEFINE VAR lxNroDcto AS INT.
DEFINE VAR lxGlosa AS CHAR INIT ''.

lxGlosa = Faccpedi.glosa.

IF Faccpedi.glosa = ? OR Faccpedi.glosa = '' THEN DO:
    IF faccpedi.codref = 'R/A' THEN DO:
        lxSer = INT(SUBSTRING(faccpedi.nroref,1,3)).
        lxNroDcto = INT(SUBSTRING(faccpedi.nroref,4)).

        FIND FIRST almcrepo WHERE almcrepo.codcia = s-codcia AND 
                                    almcrepo.codalm = faccpedi.codcli AND 
                                    almcrepo.nroser = lxSer AND 
                                    almcrepo.nrodoc = lxNroDcto NO-LOCK NO-ERROR.
        IF AVAILABLE almcrepo THEN DO:
            lxGlosa = almcrepo.glosa.
        END.
    END.
END.

DEFINE FRAME f-cab
        n-Item         FORMAT '>9'
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + s-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " + STRING(PAGE-NUMBER(REPORT), "Z9") + "/" + STRING(npage, "Z9") FORMAT 'x(20)' AT 75 SKIP
        {&PRN4} + {&PRN6A} + "      Fecha: " AT 1 FORMAT "X(17)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "      N° ORDEN: " + Reporte.CodDoc + ' ' + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "  N° SOLICITUD: " + Reporte.CodRef + ' ' + Reporte.NroRef + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "   N° DE ITEMS: " + STRING(t-Items, '>>>9') + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "          PESO: " + STRING(x-pesotot, '>>>,>>9.99') + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        /*{&PRN4} + {&PRN6A} + "    Destino: " + Faccpedi.codcli + ' ' + Faccpedi.nomcli + {&PRN6B} + {&PRN3} FORMAT "X(50)" SKIP*/       
        {&PRN3} + {&PRN7A} + {&PRN6B} + " F. Entrega: " + STRING(faccpedi.fchent,"99/99/9999") + {&PRN6B} + {&PRN7B} + {&PRN3} AT 90 FORMAT "X(40)" SKIP        
        {&PRN4} + {&PRN6A} + "    Destino: " + Faccpedi.codcli + ' ' + trim(Faccpedi.nomcli) + {&PRN6B} + {&PRN3} FORMAT "X(60)" SKIP    
        {&PRN4} + {&PRN6B} + "       Hora: " STRING(TIME,"HH:MM") FORMAT "X(12)" SKIP
        {&PRN4} + {&PRN6B} + "Observación: " + lxGlosa  FORMAT "X(80)" SKIP
        "It Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     12 999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

conta = 1.
n-Item = 1.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    DISPLAY STREAM Report 
        n-Item
        Reporte.CodMat 
        Reporte.DesMat
        Reporte.DesMar
        Reporte.UndBas
        Reporte.CanPed
        Reporte.CodUbi
        "________________________"
        WITH FRAME f-cab.
    conta = conta + 1.
    n-Item = n-Item + 1.
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        PAGE STREAM Report.
        conta = 1.
        n-Item = 1.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Rb2-OD B-table-Win 
PROCEDURE Formato-Rb2-OD :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE conta   AS INTEGER NO-UNDO INIT 1.    
DEFINE VARIABLE c-items        AS INTEGER  NO-UNDO.
DEFINE VARIABLE npage          AS INTEGER  NO-UNDO.
DEFINE VARIABLE t-Items AS INTEGER NO-UNDO.

DEFINE VAR lPeso AS DEC.

lPeso = fpeso().

c-items = 13.       /* por pagina */
npage = 0.          /* # de paginas */
conta = 1.
t-Items = 0.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    conta = conta + 1.
    t-Items = t-Items + 1.
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        npage = npage + 1.
        conta = 1.
    END.
END.
FIND gn-divi OF Faccpedi NO-LOCK NO-ERROR.
FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = Faccpedi.codcli NO-LOCK NO-ERROR.
FIND gn-ven OF Faccpedi NO-LOCK NO-ERROR.
x-Direccion = gn-clie.dircli.
FIND TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
IF AVAILABLE TabDepto THEN DO:
    x-Direccion = TRIM(x-Direccion) + " - " + TRIM(TabDepto.NomDepto).
    FIND TabProvi WHERE TabProvi.CodDepto = gn-clie.CodDept 
        AND TabProvi.CodProvi = gn-clie.CodProv
        NO-LOCK NO-ERROR.
    IF AVAILABLE TabProvi THEN DO:
        x-Direccion = x-Direccion + ' - '+ TRIM(TabProvi.NomProvi).
        FIND TabDistr WHERE TabDistr.CodDepto = gn-clie.CodDept
            AND TabDistr.CodProvi = gn-clie.CodProv
            AND TabDistr.CodDistr = gn-clie.CodDist
            NO-LOCK NO-ERROR.
        IF AVAILABLE TabDistr THEN x-Direccion = x-Direccion + ' - ' + TabDistr.NomDistr.
    END.
END.
x-Comprobante = ''.
FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.codped = Faccpedi.codref
    AND Ccbcdocu.nroped = Faccpedi.nroref
    AND Ccbcdocu.flgest <> 'A'
    NO-LOCK NO-ERROR.
IF AVAILABLE Ccbcdocu THEN x-Comprobante = Ccbcdocu.coddoc + ' ' + Ccbcdocu.nrodoc.
FIND gn-divi OF Faccpedi NO-LOCK NO-ERROR.    

DEFINE FRAME f-cab
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + s-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " AT 80 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9"
        {&PRN4} + {&PRN7A} + {&PRN6B} + "/" + STRING(npage) AT 104 FORMAT "X(15)" SKIP(1)
        {&PRN4} + {&PRN6A} + "      Fecha: " AT 1 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "      N° ORDEN: " + Reporte.CodDoc + ' ' + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "     N° PEDIDO: " + Reporte.CodRef + ' ' + Reporte.NroRef + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "N° COMPROBANTE: " + x-Comprobante + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "     Origen: " + GN-DIVI.DesDiv + {&PRN6B} + {&PRN3} FORMAT "X(50)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Fec. Despacho : " + STRING(faccpedi.fchent,"99/99/9999") + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "   Vendedor: " + SUBSTRING(gn-ven.NomVen,1,30) + {&PRN6B} + {&PRN3} FORMAT "X(50)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "         Peso : " + STRING(lPeso,">>>,>>9.99") + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "    Cliente: " + Faccpedi.nomcli + {&PRN6B} + {&PRN3} FORMAT "X(50)" SKIP
        {&PRN4} + {&PRN6B} + "       Hora: " + STRING(TIME,"HH:MM") FORMAT "X(25)"  
        {&PRN4} + {&PRN6B} + " Nro Items : " + STRING(t-Items, '>>>9') AT 80 FORMAT "X(30)" SKIP
        {&PRN4} + {&PRN6B} + "  Dirección: " + x-Direccion FORMAT "X(120)" SKIP
        {&PRN4} + {&PRN6B} + "Observación: " + Faccpedi.glosa  FORMAT "X(80)" SKIP  
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

/* DEFINE FRAME f-cab                                                                                                                                                     */
/*         Reporte.CodMat FORMAT 'X(7)'                                                                                                                                   */
/*         Reporte.DesMat FORMAT 'x(60)'                                                                                                                                  */
/*         Reporte.DesMar FORMAT 'X(24)'                                                                                                                                  */
/*         Reporte.UndBas                                                                                                                                                 */
/*         Reporte.CanPed FORMAT ">>,>>>,>>9.9999"                                                                                                                        */
/*         Reporte.CodUbi FORMAT "x(10)"                                                                                                                                  */
/*         HEADER                                                                                                                                                         */
/*         {&PRN2} + {&PRN7A} + {&PRN6A} + s-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)"                                                                        */
/*         {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " AT 85 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9"                                                               */
/*         {&PRN4} + {&PRN7A} + {&PRN6B} + "/" + string(npage) AT 104 FORMAT "X(15)" SKIP(1)                                                                              */
/*         {&PRN4} + {&PRN6A} + " Fecha : " AT 1 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"                                                                 */
/*         {&PRN3} + {&PRN7A} + {&PRN6B} + "N° ORDEN: " + Reporte.CodDoc + ' ' + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 90 FORMAT "X(30)" SKIP                 */
/*         {&PRN4} + {&PRN6A} + "Cliente: " + Faccpedi.nomcli + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(50)" SKIP                                                               */
/*         {&PRN4} + {&PRN6B} + "Hora  : " AT 1 FORMAT "X(15)" STRING(TIME,"HH:MM") FORMAT "X(12)" SKIP                                                                   */
/*         "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP */
/*         "Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP */
/*         "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP */
/* /***     999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/            */
/*          WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.                                                                                                  */

conta = 1.
FOR EACH Reporte BY Reporte.DesMat:
    DISPLAY STREAM Report 
        Reporte.CodMat 
        Reporte.DesMat
        Reporte.DesMar
        Reporte.UndBas
        Reporte.CanPed
        Reporte.CodUbi
        "________________________"
        WITH FRAME f-cab.
    conta = conta + 1.
    IF conta > c-items THEN DO:
        PAGE STREAM Report.
        conta = 1.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Rb2-OTR B-table-Win 
PROCEDURE Formato-Rb2-OTR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE conta   AS INTEGER NO-UNDO INIT 1.    
DEFINE VARIABLE c-items        AS INTEGER  NO-UNDO.
DEFINE VARIABLE npage          AS INTEGER  NO-UNDO.

DEFINE VAR x-pesotot AS DEC.

c-items = 13.       /* por pagina */
npage = 0.          /* # de paginas */
x-pesotot = 0.
conta = 1.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    conta = conta + 1.
    x-pesotot = x-pesotot + (Reporte.canped * reporte.X-peso).
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        npage = npage + 1.
        conta = 1.
    END.
END.
/* Glosa desde las SOLICTUDES DE R/A  */
DEFINE VAR lxSer AS INT.
DEFINE VAR lxNroDcto AS INT.
DEFINE VAR lxGlosa AS CHAR INIT ''.

lxGlosa = Faccpedi.glosa.

IF Faccpedi.glosa = ? OR Faccpedi.glosa = '' THEN DO:
    IF faccpedi.codref = 'R/A' THEN DO:
        lxSer = INT(SUBSTRING(faccpedi.nroref,1,3)).
        lxNroDcto = INT(SUBSTRING(faccpedi.nroref,4)).

        FIND FIRST almcrepo WHERE almcrepo.codcia = s-codcia AND 
                                    almcrepo.codalm = faccpedi.codcli AND 
                                    almcrepo.nroser = lxSer AND 
                                    almcrepo.nrodoc = lxNroDcto NO-LOCK NO-ERROR.
        IF AVAILABLE almcrepo THEN DO:
            lxGlosa = almcrepo.glosa.
        END.
    END.
END.

DEFINE FRAME f-cab
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + s-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " + STRING(PAGE-NUMBER(REPORT), "Z9") + "/" + STRING(npage, "Z9") FORMAT 'x(20)' AT 75 SKIP
        /*
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " AT 80 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9"
         {&PRN3} + {&PRN7A} + {&PRN6B} + "/" + STRING(npage) {&PRN6B} + {&PRN7B} + {&PRN3} AT 104 FORMAT "X(15)" SKIP /*(1)*/
         */
        /*
        {&PRN4} + {&PRN7A} + {&PRN6B} + "/" + STRING(npage) AT 104 FORMAT "X(15)" SKIP(1)
        */
        {&PRN4} + {&PRN6A} + "      Fecha: " AT 1 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "      N° ORDEN: " + Reporte.CodDoc + ' ' + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "  N° SOLICITUD: " + Reporte.CodRef + ' ' + Reporte.NroRef + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "          PESO: " + STRING(x-pesotot,">>>,>>9.99")  + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + " F. Entrega: " + STRING(faccpedi.fchent,"99/99/9999") + {&PRN6B} + {&PRN7B} + {&PRN3} AT 90 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "    Destino: " + Faccpedi.codcli + ' ' + trim(Faccpedi.nomcli) + {&PRN6B} + {&PRN3} FORMAT "X(60)" SKIP        
        {&PRN4} + {&PRN6B} + "       Hora: " STRING(TIME,"HH:MM") FORMAT "X(12)" SKIP
        {&PRN4} + {&PRN6B} + "Observación: " + lxGlosa  FORMAT "X(80)" SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

conta = 1.
FOR EACH Reporte BY Reporte.DesMat:
    DISPLAY STREAM Report 
        Reporte.CodMat 
        Reporte.DesMat
        Reporte.DesMar
        Reporte.UndBas
        Reporte.CanPed
        Reporte.CodUbi
        "________________________"
        WITH FRAME f-cab.
    conta = conta + 1.
    IF conta > c-items THEN DO:
        PAGE STREAM Report.
        conta = 1.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir-Formato-OD B-table-Win 
PROCEDURE Imprimir-Formato-OD :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pOrden AS CHAR.
/*
ZONA: por zona
ALFABETICO: por descripción
*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Impresión por Zonas y Ubicaciones */
  DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

  RUN lib/Imprimir2.
  IF s-salida-impresion = 0 THEN RETURN.

  RUN Carga-Temporal-Rb.

  IF s-salida-impresion = 1 THEN 
      s-print-file = SESSION:TEMP-DIRECTORY +
      STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

  DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
      CASE s-salida-impresion:
          WHEN 1 OR WHEN 3 THEN
              OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 30.
          WHEN 2 THEN
              OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 30. /* Impresora */
      END CASE.
      PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(33) + {&Prn4} .
      CASE TRUE:
          WHEN s-CodDiv = '00500' AND pOrden = "ZONA" THEN RUN Formato-Rb-500.
          WHEN pOrden = "ZONA" AND {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 1
              THEN RUN Formato-Rb-OD.
          WHEN pOrden = "ZONA" AND {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} > 1
              THEN DO: 
              RUN Formato-Rb-Multi.
              RUN Formato-Rb-Multi-Resumen.
              RUN Formato-Rb-Multi-Resumen2.
              RUN dispatch IN THIS-PROCEDURE ('open-query':U).
          END.
          WHEN pOrden = "ALFABETICO" THEN RUN Formato-Rb2-OD.
      END CASE.
      PAGE STREAM REPORT.
      OUTPUT STREAM REPORT CLOSE.
  END.
  OUTPUT CLOSE.
  CASE s-salida-impresion:
      WHEN 1 OR WHEN 3 THEN DO:
          RUN LIB/W-README.R(s-print-file).
          IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
      END.
  END CASE.
  /* SE ENVIA AL ALMACEN */
  RUN Control-de-Impresion.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir-Formato-OTR B-table-Win 
PROCEDURE Imprimir-Formato-OTR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pOrden AS CHAR.
/*
ZONA: por zona
ALFABETICO: por descripción
*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Impresión por Zonas y Ubicaciones */
  DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

  RUN lib/Imprimir2.
  IF s-salida-impresion = 0 THEN RETURN.

  RUN Carga-Temporal-Rb.

  IF s-salida-impresion = 1 THEN 
      s-print-file = SESSION:TEMP-DIRECTORY +
      STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

  DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
      CASE s-salida-impresion:
          WHEN 1 OR WHEN 3 THEN
              OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 30.
          WHEN 2 THEN
              OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 30. /* Impresora */
      END CASE.
      PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(33) + {&Prn4} .
      CASE TRUE:
          WHEN s-CodDiv = '00500' AND pOrden = "ZONA" THEN RUN Formato-Rb-500.
          WHEN pOrden = "ZONA" AND {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 1
              THEN RUN Formato-Rb-OTR.
          WHEN pOrden = "ZONA" AND {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} > 1
              THEN DO: 
              RUN Formato-Rb-Multi.
              RUN Formato-Rb-Multi-Resumen2.
              RUN dispatch IN THIS-PROCEDURE ('open-query':U).
          END.
          WHEN pOrden = "ALFABETICO" THEN RUN Formato-Rb2-OTR.
      END CASE.
      PAGE STREAM REPORT.
      OUTPUT STREAM REPORT CLOSE.
  END.
  OUTPUT CLOSE.
   

  CASE s-salida-impresion:
      WHEN 1 OR WHEN 3 THEN DO:
          RUN LIB/W-README.R(s-print-file).
          IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
      END.
  END CASE.

  

  /* SE ENVIA AL ALMACEN */
  RUN Control-de-Impresion.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE items-pesos B-table-Win 
PROCEDURE items-pesos :
DEFINE OUTPUT PARAMETER pItems AS INT.
DEFINE OUTPUT PARAMETER pPeso AS DEC.

    
DEFINE VAR lPeso AS DEC.
DEFINE VAR lItems AS INT.

DEFINE BUFFER b-facdpedi FOR facdpedi.

lPeso = 0.
lItems = 0.
lMsgRetorno = ''.

FOR EACH b-facdpedi OF faccpedi NO-LOCK,
    FIRST almmmatg OF b-facdpedi NO-LOCK :

    lItems = lItems + 1.

    IF almmmatg.pesmat <> ? AND almmmatg.pesmat > 0 THEN DO:
        lPeso = lPeso + (b-facdpedi.canped * almmmatg.pesmat).
    END.       

END.
RELEASE b-facdpedi.

pItems = lItems.
pPeso = lPeso.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca B-table-Win 
PROCEDURE local-busca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'busca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /*RUN PL/C-XXX.W("").*/
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
         END.
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime B-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF Faccpedi.FlgImpOD = NO THEN DO:
      FIND CURRENT FacCPedi EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Faccpedi THEN DO:
          RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
          RETURN.
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* Impresión por Zonas y Ubicaciones */
  DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

  RUN lib/Imprimir2.
  IF s-salida-impresion = 0 THEN RETURN.

  RUN Carga-Temporal-Rb.

  FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccpedi THEN RETURN.

  IF s-salida-impresion = 1 THEN 
      s-print-file = SESSION:TEMP-DIRECTORY +
      STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

  DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
      CASE s-salida-impresion:
          WHEN 1 OR WHEN 3 THEN
              OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 30.
          WHEN 2 THEN
              OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 30. /* Impresora */
      END CASE.
      PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(33) + {&Prn4} .
      RUN Formato-Rb.
      PAGE STREAM REPORT.
      OUTPUT STREAM REPORT CLOSE.
  END.
  OUTPUT CLOSE.

  CASE s-salida-impresion:
      WHEN 1 OR WHEN 3 THEN DO:
          RUN LIB/W-README.R(s-print-file).
          IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
      END.
  END CASE.


  IF FacCPedi.FlgImpOD = NO 
      THEN ASSIGN
            FacCPedi.FlgImpOD = YES
            FacCPedi.UsrImpOD = s-user-id
            FacCPedi.FchImpOD = DATETIME(TODAY, MTIME).
  FIND CURRENT Faccpedi NO-LOCK NO-ERROR.

  RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* SubOrdenes */
  IF AVAILABLE ORDENES THEN RUN ue-muestra-subordenes IN lh_Handle(INPUT ordenes.coddoc , INPUT ordenes.nroped ).
  /* --------------------------------------- */

  DEFINE VAR lxpeso AS DEC.

  lMsgretorno = ''.
  lxPeso = fpeso().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE peso-cant-subordenes B-table-Win 
PROCEDURE peso-cant-subordenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pPeso AS DEC.
DEFINE OUTPUT PARAMETER pCant AS DEC.
DEFINE OUTPUT PARAMETER pItems AS INT.

pPeso = 0.
pCant = 0.
pItems = 0.

DEFINE BUFFER b-vtaddocu FOR vtaddocu.

FOR EACH b-vtaddocu WHERE b-vtaddocu.codcia = vtacdocu.codcia AND
                        b-vtaddocu.coddiv = vtacdocu.coddiv AND
                        b-vtaddocu.codped = vtacdocu.codped AND
                        b-vtaddocu.nroped = vtacdocu.nroped NO-LOCK:
    FIND FIRST almmmatg WHERE b-vtaddocu.codcia = almmmatg.codcia AND
                b-vtaddocu.codmat = almmmatg.codmat NO-LOCK.

    pCant = pCant + b-vtaddocu.canped.
    IF almmmatg.pesmat <> ? AND almmmatg.pesmat > 0 THEN DO:
        pPeso = pPeso + (b-vtaddocu.canped * almmmatg.pesmat).
    END.       
    pItems= pItems + 1.
END.
RELEASE b-vtaddocu.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pget-peso-items B-table-Win 
PROCEDURE pget-peso-items :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pPeso AS DEC.
DEFINE OUTPUT PARAMETER pItems AS INT.

DEFINE VAR lPeso AS DEC.
DEFINE VAR lItems AS INT.

DEFINE BUFFER b-vtaddocu FOR vtaddocu.

lPeso = 0.
lItems = 0.

FOR EACH b-vtaddocu OF vtacdocu NO-LOCK,
    FIRST almmmatg OF b-vtaddocu NO-LOCK :
    lItems = lItems + 1.
    IF almmmatg.pesmat <> ? AND almmmatg.pesmat > 0 THEN DO:
        lPeso = lPeso + (b-vtaddocu.canped * almmmatg.pesmat).
    END.       
END.
RELEASE b-vtaddocu.

pPeso = lpeso.
pItems = lItems.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros B-table-Win 
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
        WHEN "" THEN.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros B-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "ORDENES"}
  {src/adm/template/snd-list.i "FacCPedi"}
  {src/adm/template/snd-list.i "PEDIDO"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
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
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-cargar-data-a-imprimir B-table-Win 
PROCEDURE ue-cargar-data-a-imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pListaSectoresImprimir AS CHAR.

EMPTY TEMP-TABLE Reporte.
EMPTY TEMP-TABLE tt-subordenes.

SESSION:SET-WAIT-STATE('GENERAL').

FOR EACH VtaCDocu WHERE VtaCDocu.codcia = s-codcia AND 
                        VtaCDocu.codped = faccpedi.coddoc AND 
                        ENTRY(1,VtaCDocu.nroped,"-") = faccpedi.nroped AND
                        LOOKUP(ENTRY(2,VtaCDocu.nroped,"-"),pListaSectoresImprimir) > 0
                        NO-LOCK:

    FOR EACH VtaDDocu OF VtaCDocu NO-LOCK,
        FIRST Almmmatg NO-LOCK WHERE Almmmatg.CodCia = VtaDDocu.CodCia
        AND Almmmatg.CodMat = VtaDDocu.CodMat:
        FIND FIRST Almckits OF VtaDDocu NO-LOCK NO-ERROR.
        IF AVAILABLE Almckits THEN NEXT.
        FIND Reporte WHERE Reporte.CodMat = VtaDDocu.codmat NO-ERROR.
        IF NOT AVAILABLE Reporte THEN CREATE Reporte.
        ASSIGN 
            Reporte.CodDoc = VtaCDocu.CodPed
            Reporte.NroPed = VtaCDocu.NroPed
            Reporte.CodRef = VtaCDocu.CodRef
            Reporte.NroRef = VtaCDocu.NroRef
            Reporte.CodMat = VtaDDocu.CodMat
            Reporte.DesMat = Almmmatg.DesMat
            Reporte.DesMar = Almmmatg.DesMar
            Reporte.UndBas = Almmmatg.UndBas
            Reporte.CanPed = Reporte.CanPed + ( VtaDDocu.CanPed * VtaDDocu.Factor )
            Reporte.CodAlm = VtaCDocu.CodAlm
            Reporte.CodUbi = "G-0"
            Reporte.CodZona = "G-0"
            Reporte.x-peso = almmmatg.pesmat
            Reporte.x-empaque = fGen-Empaques(Reporte.CanPed).
        FIND FIRST Almmmate WHERE Almmmate.CodCia = VtaCDocu.CodCia
            AND Almmmate.CodAlm = VtaDDocu.AlmDes
            AND Almmmate.CodMat = VtaDDocu.CodMat
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN DO:
            ASSIGN 
                Reporte.CodUbi = Almmmate.CodUbi.
            FIND Almtubic WHERE Almtubic.codcia = s-codcia
                AND Almtubic.codubi = Almmmate.codubi
                AND Almtubic.codalm = Almmmate.codalm
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtubic THEN Reporte.CodZona = Almtubic.CodZona.
        END.
    
        /* para la actualizacion */
        FIND FIRST tt-subordenes WHERE tt-subordenes.coddoc = vtacdocu.codped AND 
                                        tt-subordenes.nroped = vtacdocu.nroped NO-ERROR.
        IF NOT AVAILABLE tt-subordenes THEN DO:
            CREATE tt-subordenes.
                ASSIGN  tt-subordenes.coddoc = vtacdocu.codped
                        tt-subordenes.nroped = vtacdocu.nroped.
        END.
    END.
    /* SOLO KITS */
    FOR EACH VtaDDocu OF VtaCDocu NO-LOCK,
        FIRST Almckits OF VtaDDocu NO-LOCK,
        EACH Almdkits OF Almckits NO-LOCK,
        FIRST Almmmatg NO-LOCK WHERE Almmmatg.CodCia = VtaCDocu.CodCia
        AND Almmmatg.CodMat = AlmDKits.codmat2:
        FIND Reporte WHERE Reporte.codmat = VtaDDocu.codmat NO-ERROR.
        IF NOT AVAILABLE Reporte THEN CREATE Reporte.
        ASSIGN 
            Reporte.CodDoc = VtaCDocu.CodPed
            Reporte.NroPed = VtaCDocu.NroPed
            Reporte.CodRef = VtaCDocu.CodRef
            Reporte.NroRef = VtaCDocu.NroRef
            Reporte.CodMat = Almmmatg.CodMat
            Reporte.DesMat = TRIM(Almmmatg.DesMat) + ' (KIT ' + TRIM(Facdpedi.codmat) + ')'
            Reporte.DesMar = Almmmatg.DesMar
            Reporte.UndBas = Almmmatg.UndBas
            Reporte.CanPed = Reporte.CanPed + ( VtaDDocu.CanPed * VtaDDocu.Factor *  AlmDKits.Cantidad )
            Reporte.CodAlm = VtaCDocu.CodAlm
            Reporte.CodUbi = "G-0"
            Reporte.CodZona = "G-0"
            Reporte.x-peso = almmmatg.pesmat
            Reporte.x-empaque = fGen-Empaques(Reporte.CanPed).
        FIND FIRST Almmmate WHERE Almmmate.CodCia = VtaCDocu.CodCia
            AND Almmmate.CodAlm = VtaDDocu.AlmDes
            AND Almmmate.CodMat = Almmmatg.CodMat
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN DO:
            ASSIGN 
                Reporte.CodUbi = Almmmate.CodUbi.
            FIND Almtubic WHERE Almtubic.codcia = s-codcia
                AND Almtubic.codubi = Almmmate.codubi
                AND Almtubic.codalm = Almmmate.codalm
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtubic THEN Reporte.CodZona = Almtubic.CodZona.
        END.

        /* para la actualizacion */
        FIND FIRST tt-subordenes WHERE tt-subordenes.coddoc = vtacdocu.codped AND 
                                        tt-subordenes.nroped = vtacdocu.nroped NO-ERROR.
        IF NOT AVAILABLE tt-subordenes THEN DO:
            CREATE tt-subordenes.
                ASSIGN  tt-subordenes.coddoc = vtacdocu.codped
                        tt-subordenes.nroped = vtacdocu.nroped.
        END.
    END.
END.

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-cargar-w-report B-table-Win 
PROCEDURE ue-cargar-w-report :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pTotalSectores AS CHAR.

REPEAT:
    s-task-no = RANDOM(1, 999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no
                    /*AND w-report.llave-c = x-nrodoc*/ NO-LOCK)
        THEN DO:
        /*
        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no
            w-report.llave-c = x-nrodoc.
        */
        LEAVE.
    END.
END.

DEFINE VAR lPeso AS DEC.
DEFINE VAR lItems AS INT.
DEFINE VAR lNoItm AS INT.
DEFINE VAR x-direccion AS CHAR INIT "".
DEFINE VAR lxGlosa AS CHAR INIT "".
DEFINE VAR lSeqSector AS INT.

DEFINE VAR lTipoDocBarra AS CHAR.

FIND FIRST facdocum WHERE facdocum.codcia = s-codcia AND
                        facdocum.coddoc = reporte.coddoc
                        NO-LOCK NO-ERROR.
IF NOT AVAILABLE facdocum THEN DO:
    MESSAGE "Tipo Documento para el Codigo de Barra no existe".
    RETURN.
END.
lTipoDocbarra = TRIM(facdocum.codcta[8]).

lSeqSector = 0.
FOR EACH Reporte BREAK BY reporte.nroped BY Reporte.codubi:

    IF FIRST-OF(reporte.nroped) THEN DO:
        lPeso = 0.
        lNoItm = 0.
        lItems = 0.
        lSeqSector = lSeqSector + 1.

        FIND FIRST VtaCDocu WHERE VtaCDocu.codcia = s-codcia AND 
                                    VtaCDocu.codped = reporte.coddoc AND 
                                    VtaCDocu.nroped = reporte.nroped NO-LOCK.

        RUN pget-peso-items(OUTPUT lPeso, OUTPUT lItems).

        FIND gn-divi OF VtaCDocu NO-LOCK NO-ERROR.
        FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = VtaCDocu.codcli NO-LOCK NO-ERROR.
        FIND gn-ven OF VtaCDocu NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            x-Direccion = if( AVAILABLE gn-clie) THEN gn-clie.dircli ELSE "". 
            FIND TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
            IF AVAILABLE TabDepto THEN DO:
                x-Direccion = TRIM(x-Direccion) + " - " + TRIM(TabDepto.NomDepto).
                FIND TabProvi WHERE TabProvi.CodDepto = gn-clie.CodDept 
                    AND TabProvi.CodProvi = gn-clie.CodProv
                    NO-LOCK NO-ERROR.
                IF AVAILABLE TabProvi THEN DO:
                    x-Direccion = x-Direccion + ' - '+ TRIM(TabProvi.NomProvi).
                    FIND TabDistr WHERE TabDistr.CodDepto = gn-clie.CodDept
                        AND TabDistr.CodProvi = gn-clie.CodProv
                        AND TabDistr.CodDistr = gn-clie.CodDist
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE TabDistr THEN x-Direccion = x-Direccion + ' - ' + TabDistr.NomDistr.
                END.
            END.
        END.
        lxGlosa = VtaCDocu.glosa.

        IF VtaCDocu.codped = 'OTR' THEN DO:
            x-direccion = VtaCDocu.dircli.

            /* Glosa desde las SOLICTUDES DE R/A  */
            DEFINE VAR lxSer AS INT.
            DEFINE VAR lxNroDcto AS INT.

            IF VtaCDocu.glosa = ? OR VtaCDocu.glosa = '' THEN DO:
                IF VtaCDocu.codref = 'R/A' THEN DO:
                    lxSer = INT(SUBSTRING(VtaCDocu.nroref,1,3)).
                    lxNroDcto = INT(SUBSTRING(VtaCDocu.nroref,4)).

                    FIND FIRST almcrepo WHERE almcrepo.codcia = s-codcia AND 
                                                almcrepo.codalm = VtaCDocu.codcli AND 
                                                almcrepo.nroser = lxSer AND 
                                                almcrepo.nrodoc = lxNroDcto NO-LOCK NO-ERROR.
                    IF AVAILABLE almcrepo THEN DO:
                        lxGlosa = almcrepo.glosa.
                    END.
                END.
            END.
        END.
    END.
    
    /* -------------------------------------------------------------*/
    lNoItm = lNoItm + 1.
    CREATE w-report.
    ASSIGN
        w-report.task-no = s-task-no
        w-report.llave-c = reporte.nroped
        w-report.campo-c[20] = "*" + lTipoDocbarra + TRIM(reporte.Nroped) + "*". /* BARRA */
        w-report.campo-c[21] = "Sector " + ENTRY(2,VtaCDocu.Nroped,"-") + 
                                " de " + pTotalSectores.
        w-report.campo-c[21] = "Sector " + STRING(lSeqSector) + " de " + 
                                STRING (NUM-ENTRIES(pTotalSectores)).        

        /* Cabecera */
        ASSIGN  w-report.campo-c[6] = reporte.Coddoc + " " + reporte.Nroped
                w-report.campo-c[7] = "Nro. " + VtaCDocu.CodRef + " " + VtaCDocu.NroRef
                w-report.campo-c[8] = "ORIGEN   : " + if(AVAILABLE gn-divi) THEN gn-divi.desdiv ELSE ""
                w-report.campo-c[9] = "Nro. DE ITEMS : " + string(lItems,">>>,>>9")
                w-report.campo-c[10] = "F." + IF(VtaCDocu.codped='OTR') THEN "DESPACHO :" ELSE "ENTREGA :"
                w-report.campo-c[10] = w-report.campo-c[10] + STRING(VtaCDocu.Fchent,"99/99/9999")
                w-report.campo-c[11] = IF (AVAILABLE gn-ven) THEN ("VENDEDOR : " + gn-ven.nomven) ELSE ""
                w-report.campo-c[12] = "PESO :" + STRING(lPeso,"-ZZ,ZZZ,ZZ9.99")
                w-report.campo-c[13] = IF(VtaCDocu.Codped = 'OTR') THEN "DESTINO  : " ELSE "CLIENTE   : "
                w-report.campo-c[13] = w-report.campo-c[13] + IF(VtaCDocu.Codped = 'OTR') THEN VtaCDocu.Codcli + " " ELSE ""
                w-report.campo-c[13] = w-report.campo-c[13] + VtaCDocu.nomcli
                w-report.campo-c[14] = "Direccion   : " + x-direccion
                w-report.campo-c[15] = "Observacion : " + lxGlosa.
        /* Detalle */
        ASSIGN  w-report.campo-i[1] = lNoItm
                w-report.campo-c[1] = Reporte.CodMat
                w-report.campo-c[2] = Reporte.DesMat
                w-report.campo-c[3] = Reporte.DesMar
                w-report.campo-c[4] = Reporte.UndBas
                w-report.campo-f[1] = Reporte.CanPed
                w-report.campo-c[5] = Reporte.CodUbi
                w-report.campo-c[22] = Reporte.x-empaques.

        /*MESSAGE Reporte.CodMat Reporte.CodUbi Reporte.CodZona.*/

END.

IF AVAILABLE VtacDocu THEN DO:
    lNoItm = lNoItm + 1.
    CREATE w-report.
    ASSIGN
        w-report.task-no = s-task-no
        w-report.llave-c = VtaCDocu.nroped + "XXX"
        w-report.campo-c[6] = VtaCDocu.Codped + " " + VtaCDocu.Nroped
        w-report.campo-i[1] = lNoItm.

    DELETE w-report.

END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-envia-txt-detalle B-table-Win 
PROCEDURE ue-envia-txt-detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-Archivo AS CHAR.
DEFINE VAR x-rpta AS LOG.

x-Archivo = 'PagSinIngreso.txt'.
SYSTEM-DIALOG GET-FILE x-Archivo
FILTERS 'Texto' '*.txt'
ASK-OVERWRITE
CREATE-TEST-FILE
DEFAULT-EXTENSION '.txt'
INITIAL-DIR 'c:\tmp'
RETURN-TO-START-DIR 
USE-FILENAME
SAVE-AS
UPDATE x-rpta.
IF x-rpta = NO THEN RETURN.

OUTPUT STREAM REPORTE TO VALUE(x-Archivo).

PUT STREAM REPORTE
    "Codigo|"
    "Numero|"
    "Emision|"
    "Hora|"
    "Origen|"
    "Cliente|"
    "Impreso por|"
    "Fecha/Hora Impresion|"
    "Fecha/Hora Distribucion|"
    "Items|"
    "Glosa|"
    "De Venta a Almacén|"
    "De Almacén a Distribución|"
    "De Venta a Distribución|"
    "Fech.Entrega|"
    "Peso|"
    "Articulo|"
    "Descripcion|"
    "Peso Unit|"
    "Marca|"
    "Cantidad|"
    "Unidad|"
    "Almacen|"
    "Zona|"
    "Ubicacion|"
    "Peso Tot|"
    "Usuario envio a Distribucion|"
    "Nombre Usuario" SKIP.

DEFINE VAR lNomUser AS CHAR.
DEFINE VAR lCodUser AS CHAR.
DEFINE VAR iCount1 AS INT.

DEFINE VARIABLE lsFechaEmision          AS CHARACTER.
DEFINE VARIABLE lsHoraEmision           AS CHARACTER.

DEFINE VARIABLE ldtFechaEmision         AS DATETIME.
DEFINE VARIABLE ldtFechaDistribucion    AS DATETIME.
DEFINE VARIABLE lsDifTempo_VtaAlm       AS CHARACTER.
DEFINE VARIABLE lsDifTempo_AlmDist      AS CHARACTER.
DEFINE VARIABLE lsDifTempo_VtaDist      AS CHARACTER.

DEFINE VAR lPeso AS DEC.

GET FIRST {&BROWSE-NAME}.
DO  WHILE AVAILABLE faccpedi:
    iCount1 = 0.
    FOR EACH facdpedi OF faccpedi NO-LOCK:
       iCount1 = iCount1 + 1.
    END.
    FOR EACH facdpedi OF faccpedi NO-LOCK :        
        lsFechaEmision = STRING(faccpedi.fchped, '99-99-9999').
        lsHoraEmision  = faccpedi.hora.

        ldtFechaEmision      = DATETIME(lsFechaEmision + ' ' + lsHoraEmision).
        ldtFechaDistribucion = DATETIME(IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 1) THEN ENTRY(2,Faccpedi.Libre_c03,'|') ELSE "").

        RUN lib\_time-passed.p (ldtFechaEmision, faccpedi.fchimpod, OUTPUT lsDifTempo_VtaAlm).
        RUN lib\_time-passed.p (faccpedi.fchimpod, ldtFechaDistribucion, OUTPUT lsDifTempo_AlmDist).
        RUN lib\_time-passed.p (ldtFechaEmision, ldtFechaDistribucion, OUTPUT lsDifTempo_VtaDist).

        lPeso = fPeso().

        /* Detalle */
        FIND FIRST almmmatg OF facdpedi NO-LOCK NO-ERROR.

        DEFINE VAR lUbicacion AS CHAR.
        DEFINE VAR lZona AS CHAR.
        lUbicacion = ''.
        lZona = ''.
        FIND FIRST Almmmate WHERE Almmmate.CodCia = FacDPedi.CodCia
            AND Almmmate.CodAlm = FacDPedi.AlmDes
            AND Almmmate.codmat = FacDPedi.codmat NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN DO:
            FIND FIRST almtubic OF Almmmate NO-LOCK NO-ERROR.
            IF AVAILABLE almtubic THEN lZona = almtubic.CodZona.
            lUbicacion = Almmmate.CodUbi.
        END.

        lCodUser = IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 2) THEN ENTRY(3,Faccpedi.Libre_c03,'|') ELSE "".
        lNomUser = fPersonal(lCodUser).

        PUT STREAM REPORT
                faccpedi.coddoc "|"
                faccpedi.nroped "|"
                faccpedi.fchped "|"
                faccpedi.hora "|"
                gn-divi.desdiv "|"
                faccpedi.nomcli "|"
                faccpedi.usrimpod  "|"
                faccpedi.fchimpod "|"
                IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 1) THEN ENTRY(2,Faccpedi.Libre_c03,'|') ELSE ""  "|"
                iCount1 "|"
                faccpedi.glosa "|"
                lsDifTempo_VtaAlm "|"
                lsDifTempo_AlmDist "|"
                lsDifTempo_VtaDist "|"
                faccpedi.fchent "|"
                lpeso "|"
                facdpedi.codmat "|"
                almmmatg.desmat "|"
                almmmatg.pesmat "|"
                almmmatg.desmar "|"
                facdpedi.canped "|"
                facdpedi.undvta "|"
                facdpedi.almdes "|"
                lzona "|"
                lUbicacion "|"
                (FacDPedi.CanPed * Almmmatg.Pesmat ) "|"
                IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 2) THEN ENTRY(3,Faccpedi.Libre_c03,'|') ELSE ""  "|"
                lNomUser SKIP.

    END.
END.
/*
FOR EACH tmp-datos:
  PUT STREAM REPORT
      tmp-datos.codalm "|"
      tmp-datos.desalm "|"
      tmp-datos.nropag "|"
      tmp-datos.codres SKIP.
END.
*/
OUTPUT STREAM REPORTE CLOSE.
MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.


/* -------------------------------------------------------------------------- */
/*
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE x-signo                 AS DECI.

DEFINE VARIABLE lsFechaEmision          AS CHARACTER.
DEFINE VARIABLE lsHoraEmision           AS CHARACTER.

DEFINE VARIABLE ldtFechaEmision         AS DATETIME.
DEFINE VARIABLE ldtFechaDistribucion    AS DATETIME.
DEFINE VARIABLE lsDifTempo_VtaAlm       AS CHARACTER.
DEFINE VARIABLE lsDifTempo_AlmDist      AS CHARACTER.
DEFINE VARIABLE lsDifTempo_VtaDist      AS CHARACTER.

DEFINE VAR lPeso AS DEC.

SESSION:SET-WAIT-STATE('GENERAL').

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = FALSE.

/* Para crear a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */

chWorkSheet:Range("A1:R1"):Font:Bold = TRUE.
chWorkSheet:Range("A1"):Value = "Codigo".
chWorkSheet:Range("B1"):Value = "Numero".
chWorkSheet:COLUMNS("B"):NumberFormat = "@".
chWorkSheet:Range("C1"):Value = "Emision".
chWorkSheet:COLUMNS("C"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("D1"):Value = "Hora".
chWorkSheet:Range("E1"):Value = "Origen".
chWorkSheet:COLUMNS("E"):NumberFormat = "@".
chWorkSheet:Range("F1"):Value = "Cliente".
chWorkSheet:COLUMNS("F"):NumberFormat = "@".
chWorkSheet:Range("G1"):Value = "Impreso por".
chWorkSheet:Range("H1"):Value = "Fecha/Hora Impresion".
chWorkSheet:Range("I1"):Value = "Fecha/Hora Distribucion".      /* Nueva columna */
chWorkSheet:Range("J1"):Value = "Items".
chWorkSheet:Range("K1"):Value = "Glosa".
chWorkSheet:Range("L1"):Value = "De Venta a Almacén".      /* Nueva columna */
chWorkSheet:Range("M1"):Value = "De Almacén a Distribución".      /* Nueva columna */
chWorkSheet:Range("N1"):Value = "De Venta a Distribución".      /* Nueva columna */
chWorkSheet:Range("O1"):Value = "Fech.Entrega".      /* Nueva columna */
chWorkSheet:COLUMNS("O"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("P1"):Value = "Peso".      /* Nueva columna */
chWorkSheet:Range("Q1"):Value = "Articulo".
chWorkSheet:COLUMNS("Q"):NumberFormat = "@".
chWorkSheet:Range("R1"):Value = "Descripcion".
chWorkSheet:Range("S1"):Value = "Peso Unit".
chWorkSheet:Range("T1"):Value = "Marca".
chWorkSheet:Range("U1"):Value = "Cantidad".
chWorkSheet:Range("V1"):Value = "Unidad".
chWorkSheet:Range("W1"):Value = "Almacen".
chWorkSheet:COLUMNS("W"):NumberFormat = "@".
chWorkSheet:Range("X1"):Value = "Zona".
chWorkSheet:Range("Y1"):Value = "Ubicacion".
chWorkSheet:Range("z1"):Value = "Peso Tot".
chWorkSheet:Range("AA1"):Value = "Usuario envio a Distribucion".
chWorkSheet:Range("AB1"):Value = "Nombre Usuario".

iColumn = 1.

DEFINE VAR lNomUser AS CHAR.
DEFINE VAR lCodUser AS CHAR.

GET FIRST {&BROWSE-NAME}.
DO  WHILE AVAILABLE faccpedi:
    iCount = 0.
    FOR EACH facdpedi OF faccpedi NO-LOCK:
       iCount = iCount + 1.
    END.
    FOR EACH facdpedi OF faccpedi NO-LOCK :        
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).

        chWorkSheet:Range("A" + cColumn):Value = faccpedi.coddoc.
        chWorkSheet:Range("B" + cColumn):Value = faccpedi.nroped.             
        chWorkSheet:Range("C" + cColumn):Value = faccpedi.fchped.             
        chWorkSheet:Range("D" + cColumn):Value = faccpedi.hora.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = gn-divi.desdiv.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = faccpedi.nomcli.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = faccpedi.usrimpod.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = faccpedi.fchimpod.

        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 1) THEN ENTRY(2,Faccpedi.Libre_c03,'|') ELSE "".

        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = iCount.

        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = faccpedi.glosa.


        lsFechaEmision = STRING(faccpedi.fchped, '99-99-9999').
        lsHoraEmision  = faccpedi.hora.

        ldtFechaEmision      = DATETIME(lsFechaEmision + ' ' + lsHoraEmision).
        ldtFechaDistribucion = DATETIME(IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 1) THEN ENTRY(2,Faccpedi.Libre_c03,'|') ELSE "").

        RUN lib\_time-passed.p (ldtFechaEmision, faccpedi.fchimpod, OUTPUT lsDifTempo_VtaAlm).
        RUN lib\_time-passed.p (faccpedi.fchimpod, ldtFechaDistribucion, OUTPUT lsDifTempo_AlmDist).
        RUN lib\_time-passed.p (ldtFechaEmision, ldtFechaDistribucion, OUTPUT lsDifTempo_VtaDist).

        chWorkSheet:Range("L" + cColumn):Value = lsDifTempo_VtaAlm.
        chWorkSheet:Range("M" + cColumn):Value = lsDifTempo_AlmDist.
        chWorkSheet:Range("N" + cColumn):Value = lsDifTempo_VtaDist.
        chWorkSheet:Range("O" + cColumn):Value = faccpedi.fchent.

        lPeso = fPeso().
        chWorkSheet:Range("P" + cColumn):Value = lpeso.

        /* Detalle */
        FIND FIRST almmmatg OF facdpedi NO-LOCK NO-ERROR.
        chWorkSheet:Range("Q" + cColumn):Value = facdpedi.codmat.
        chWorkSheet:Range("R" + cColumn):Value = almmmatg.desmat.
        chWorkSheet:Range("S" + cColumn):Value = almmmatg.pesmat.
        chWorkSheet:Range("T" + cColumn):Value = almmmatg.desmar.
        chWorkSheet:Range("U" + cColumn):Value = facdpedi.canped.
        chWorkSheet:Range("V" + cColumn):Value = facdpedi.undvta.
        chWorkSheet:Range("W" + cColumn):Value = facdpedi.almdes.

        FIND FIRST Almmmate WHERE Almmmate.CodCia = FacDPedi.CodCia
            AND Almmmate.CodAlm = FacDPedi.AlmDes
            AND Almmmate.codmat = FacDPedi.codmat NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN DO:
            FIND FIRST almtubic OF Almmmate NO-LOCK NO-ERROR.
            IF AVAILABLE almtubic THEN chWorkSheet:Range("X" + cColumn):Value = almtubic.CodZona.
            chWorkSheet:Range("Y" + cColumn):Value = Almmmate.CodUbi.
        END.
        chWorkSheet:Range("Z" + cColumn):VALUE = (FacDPedi.CanPed * Almmmatg.Pesmat ).
        chWorkSheet:Range("AA" + cColumn):Value = "'" + IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 2) THEN ENTRY(3,Faccpedi.Libre_c03,'|') ELSE "".

         lCodUser = IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 2) THEN ENTRY(3,Faccpedi.Libre_c03,'|') ELSE "".
         lNomUser = fPersonal(lCodUser).
         cRange = "AB" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + lNomUser.

    END.
    GET NEXT {&BROWSE-NAME}.
END.

SESSION:SET-WAIT-STATE('').
    
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication NO-ERROR.      
RELEASE OBJECT chWorkbook NO-ERROR.
RELEASE OBJECT chWorksheet NO-ERROR.
RELEASE OBJECT chWorksheetRange NO-ERROR. 

MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-enviar-a-impresora B-table-Win 
PROCEDURE ue-enviar-a-impresora :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RB-INCLUDE-RECORDS = "O".

RB-FILTER = " w-report.task-no = " + STRING(s-task-no).
/*
RB-FILTER = " w-report.task-no = " + STRING(s-task-no) +  
              " AND w-report.llave-c = '" + x-nrodoc + "'".

RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia +
                        "~ns-division = " + IF(AVAILABLE gn-divi) THEN gn-divi.desdiv ELSE "".
*/

DEFINE VARIABLE cDatabaseName    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cHostName        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNetworkProto    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPortNumber      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cOtherParams     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNewConnString   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDelimeter       AS CHARACTER NO-UNDO.

GET-KEY-VALUE SECTION "RBParametros" KEY "cDatabaseName" VALUE cDatabaseName.
GET-KEY-VALUE SECTION "RBParametros" KEY "cHostName" VALUE cHostName.
GET-KEY-VALUE SECTION "RBParametros" KEY "cNetworkProto" VALUE cNetworkProto.
GET-KEY-VALUE SECTION "RBParametros" KEY "cPortNumber" VALUE cPortNumber.
GET-KEY-VALUE SECTION "RBParametros" KEY "cOtherParams" VALUE cOtherParams.

ASSIGN cDelimeter = CHR(32).
IF NOT (cDatabaseName = ? OR
   cHostName = ? OR
   cNetworkProto = ? OR
   cPortNumber = ?) THEN DO:
   ASSIGN
       cNewConnString =
       "-db" + cDelimeter + cDatabaseName + cDelimeter +
       "-H" + cDelimeter + cHostName + cDelimeter +
       "-N" + cDelimeter + cNetworkProto + cDelimeter +
       "-S" + cDelimeter + cPortNumber + cDelimeter.
   RB-DB-CONNECTION = cNewConnString.
END.

ASSIGN
      RB-REPORT-NAME = "impresion-subordenes"
      RB-BEGIN-PAGE = s-pagina-inicial
      RB-END-PAGE = s-pagina-final
      RB-PRINTER-NAME = s-printer-name
      RB-OUTPUT-FILE = s-print-file
      RB-NUMBER-COPIES = s-nro-copias.
  CASE s-salida-impresion:
      WHEN 1 THEN RB-PRINT-DESTINATION = "D".     /* Pantalla */
      WHEN 2 THEN RB-PRINT-DESTINATION = "".      /* Impresora */
      WHEN 3 THEN RB-PRINT-DESTINATION = "A".     /* Archivo */
  END CASE.
  RUN aderb/_prntrb2 (RB-REPORT-LIBRARY,
                      RB-REPORT-NAME,
                      RB-DB-CONNECTION,
                      RB-INCLUDE-RECORDS,
                      RB-FILTER,
                      RB-MEMO-FILE,
                      RB-PRINT-DESTINATION,
                      RB-PRINTER-NAME,
                      RB-PRINTER-PORT,
                      RB-OUTPUT-FILE,
                      RB-NUMBER-COPIES,
                      RB-BEGIN-PAGE,
                      RB-END-PAGE,
                      RB-TEST-PATTERN,
                      RB-WINDOW-TITLE,
                      RB-DISPLAY-ERRORS,
                      RB-DISPLAY-STATUS,
                      RB-NO-WAIT,
                      RB-OTHER-PARAMETERS,
                      "").

/* Borar el temporal */
DEF BUFFER B-w-report FOR w-report.
DEFINE VAR lRowId AS ROWID.

FOR EACH w-report WHERE w-report.task-no = s-task-no NO-LOCK:
    lRowId = ROWID(w-report).
    FIND FIRST b-w-report WHERE ROWID(b-w-report) = lRowid EXCLUSIVE NO-ERROR.
    IF AVAILABLE b-w-report THEN DO:
        DELETE b-w-report.            
    END.    
END.
RELEASE B-w-report.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-imprimir-subordenes B-table-Win 
PROCEDURE ue-imprimir-subordenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pListaDeSectores-a-imprimir AS CHAR.
DEFINE INPUT PARAMETER pTotalSectores AS CHAR.

RUN ue-cargar-data-a-imprimir(INPUT pListaDeSectores-a-imprimir).

FIND FIRST reporte NO-ERROR.

IF NOT AVAILABLE reporte THEN DO:
    /* No existe data a imprimir */
    MESSAGE "No existe data a imprimir".
    RETURN .
END.
RUN ue-cargar-w-report(INPUT pTotalSectores).

RUN bin/_prnctr.p.
IF s-salida-impresion = 0 THEN RETURN.

RUN ue-enviar-a-impresora.

/* Actualizo el usuario que imprimio las subordenes */
DEFINE BUFFER b-vtacdocu FOR vtacdocu.
FOR EACH tt-subordenes :
    FIND FIRST b-vtacdocu WHERE b-vtacdocu.codped = tt-subordenes.coddoc AND 
                                b-vtacdocu.nroped = tt-subordenes.nroped NO-ERROR.
    IF AVAILABLE b-vtacdocu AND (TRUE <> (b-vtacdocu.UsrImpOD > '')) THEN DO:
        ASSIGN b-vtacdocu.FlgImpOD = YES
            b-vtacdocu.UsrImpOD = s-user-id
            b-vtacdocu.FchImpOD = DATETIME(TODAY, MTIME).
    END.
END.
RELEASE b-vtacdocu.

/*IF FacCPedi.FlgImpOD = YES THEN NEXT.*/

/* La O/D completa */
IF NOT (TRUE <> (Faccpedi.UsrImpOD > '')) THEN NEXT.
FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
IF AVAILABLE Faccpedi THEN DO:
  ASSIGN
      FacCPedi.FlgImpOD = YES
      FacCPedi.UsrImpOD = s-user-id
      FacCPedi.FchImpOD = DATETIME(TODAY, MTIME).
END.
FIND CURRENT Faccpedi NO-LOCK NO-ERROR.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-sectores B-table-Win 
PROCEDURE ue-sectores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE OUTPUT PARAMETER pSectores AS INT.
DEFINE OUTPUT PARAMETER pSecImp AS INT.
DEFINE OUTPUT PARAMETER pSecAsig AS INT.
DEFINE OUTPUT PARAMETER pSecDev AS INT.
DEFINE OUTPUT PARAMETER dFechaSituacion AS DATE.

DEFINE VAR nSectores AS INT INIT 0.
DEFINE VAR nSectoresImp AS INT  INIT 0.
DEFINE VAR nSectoresAsig AS INT  INIT 0.
DEFINE VAR nSectoresReto AS INT  INIT 0.
DEFINE VAR nSectoresSinAsig AS INT  INIT 0.

FOR EACH VtaCDocu WHERE VtaCDocu.codcia = s-codcia 
    AND VtaCDocu.codped = pCodDoc 
    AND VtaCDocu.nroped BEGINS pNroDoc NO-LOCK:
    nSectores = nSectores + 1.
    IF NOT (TRUE <> (VtaCDocu.UsrImpOD > ""))   THEN DO:
        nSectoresImp = nSectoresImp + 1.
        dFechaSituacion = DATE(VtaCDocu.FchImpOD).
    END.
    IF NOT (TRUE <> (VtaCDocu.UsrSac > ""))   THEN DO:
        nSectoresAsig = nSectoresAsig + 1.
        dFechaSituacion = VtaCDocu.FecSac.
    END.
    IF NOT (TRUE <> (VtaCDocu.UsrSacRecep > ""))   THEN DO:
        nSectoresReto = nSectoresReto + 1.
        dFechaSituacion = DATE(VtaCDocu.FchFin).
    END.
END.

pSectores = nSectores.
pSecImp = nSectoresImp.
pSecAsig = nSectoresAsig.
pSecDev = nSectoresReto.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um-get-guias-rutas B-table-Win 
PROCEDURE um-get-guias-rutas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-CodDoc AS CHAR    NO-UNDO.
DEFINE INPUT PARAMETER p-NroDoc AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER p-RetVal AS CHAR.

DEFINE BUFFER i-faccpedi FOR faccpedi.
DEFINE BUFFER i-ccbcdocu FOR ccbcdocu.

DEFINE VAR lRetVal AS CHAR INIT ''.

/*FIND FIRST i-faccpedi WHERE ROWID(i-faccpedi) = p-RowId NO-LOCK NO-ERROR.*/
FIND FIRST i-faccpedi WHERE i-faccpedi.codcia = s-codcia AND 
                            i-faccpedi.coddoc = p-CodDoc AND
                             i-faccpedi.nroped = p-NroDoc NO-LOCK NO-ERROR.
IF AVAILABLE i-faccpedi THEN DO:
    /* Guias de la orden de despacho */
    IF i-faccpedi.coddoc = 'O/D' THEN DO:
        FOR EACH i-ccbcdocu USE-INDEX llave15 WHERE i-ccbcdocu.codcia = s-codcia AND 
                                i-ccbcdocu.codped = i-faccpedi.codref AND 
                                i-ccbcdocu.nroped = i-faccpedi.nroref AND 
                                i-ccbcdocu.flgest <> 'A' NO-LOCK :
            IF i-ccbcdocu.coddoc = 'G/R' AND 
                i-ccbcdocu.libre_c01 = i-faccpedi.coddoc AND 
                i-ccbcdocu.libre_c02 = i-faccpedi.nroped THEN DO:

                IF lRetVal <> '' THEN lRetVal = lRetVal + ", ".
                lRetVal = lRetVal + i-ccbcdocu.coddoc + "-" +  i-ccbcdocu.nrodoc.
                /* Hoja de Ruta */
                /*
                FIND FIRST di-rutaD USE-INDEX llave02 WHERE di-rutaD.codcia = s-codcia AND 
                                            di-rutaD.coddoc = 'H/R' AND 
                                            di-rutaD.codref = i-ccbcdocu.coddoc AND 
                                            di-rutaD.nroref = i-ccbcdocu.nrodoc NO-LOCK NO-ERROR.
                IF AVAILABLE di-rutaD THEN DO:
                    lRetVal = lRetVal + "  H/R-" + di-rutaD.nrodoc.
                END.
                */
            END.
        END.
    END.

    /* Guias de Transferencias */
    IF i-faccpedi.coddoc = 'OTR' THEN DO:
        FOR EACH almcmov WHERE almcmov.codcia = s-codcia AND 
                                almcmov.codref = 'OTR' AND 
                                almcmov.nroref = i-faccpedi.nroped AND
                                almcmov.flgest <> 'A' NO-LOCK :
            IF lRetVal <> '' THEN lRetVal = lRetVal + ", ".
            lRetVal = lRetVal + "G/R" + "-" + STRING(almcmov.nroser,"999") + STRING(almcmov.nrodoc,"999999").
            /*
            FIND FIRST di-rutaG WHERE DI-RutaG.codcia  = almcmov.codcia  AND                 
                                di-rutaG.codalm = almcmov.codalm  AND
                                di-rutaG.tipmov = almcmov.tipmov AND
                                di-rutaG.codmov = almcmov.codmov AND                                
                                di-rutaG.serref = almcmov.nroser AND
                                di-rutaG.nroref = almcmov.nrodoc NO-LOCK NO-ERROR.
            IF AVAILABLE di-rutaG THEN DO:
                lRetVal = lRetVal + "  H/R-" + di-rutaG.nrodoc.
            END.
            */
        END.
    END.
END.

p-RetVal = lRetVal.

RELEASE i-faccpedi.
RELEASE i-ccbcdocu.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um-get-rutas B-table-Win 
PROCEDURE um-get-rutas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-CodDoc AS CHAR    NO-UNDO.
DEFINE INPUT PARAMETER p-NroDoc AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER p-RetVal AS CHAR.

DEFINE BUFFER i-faccpedi FOR faccpedi.
DEFINE BUFFER i-ccbcdocu FOR ccbcdocu.

DEFINE VAR lRetVal AS CHAR INIT ''.

/*FIND FIRST i-faccpedi WHERE ROWID(i-faccpedi) = p-RowId NO-LOCK NO-ERROR.*/
FIND FIRST i-faccpedi WHERE i-faccpedi.codcia = s-codcia AND 
                            i-faccpedi.coddoc = p-CodDoc AND
                             i-faccpedi.nroped = p-NroDoc NO-LOCK NO-ERROR.
IF AVAILABLE i-faccpedi THEN DO:
    /* Guias de la orden de despacho */
    IF i-faccpedi.coddoc = 'O/D' THEN DO:
        FOR EACH i-ccbcdocu USE-INDEX llave15 WHERE i-ccbcdocu.codcia = s-codcia AND 
                                i-ccbcdocu.codped = i-faccpedi.codref AND 
                                i-ccbcdocu.nroped = i-faccpedi.nroref AND 
                                i-ccbcdocu.flgest <> 'A' NO-LOCK :
            IF i-ccbcdocu.coddoc = 'G/R' AND 
                i-ccbcdocu.libre_c01 = i-faccpedi.coddoc AND 
                i-ccbcdocu.libre_c02 = i-faccpedi.nroped THEN DO:

                /*IF lRetVal <> '' THEN lRetVal = lRetVal + ", ".*/
                /*lRetVal = lRetVal + i-ccbcdocu.coddoc + "-" +  i-ccbcdocu.nrodoc.*/
                /* Hoja de Ruta */
                FIND FIRST di-rutaD USE-INDEX llave02 WHERE di-rutaD.codcia = s-codcia AND 
                                            di-rutaD.coddoc = 'H/R' AND 
                                            di-rutaD.codref = i-ccbcdocu.coddoc AND 
                                            di-rutaD.nroref = i-ccbcdocu.nrodoc NO-LOCK NO-ERROR.
                IF AVAILABLE di-rutaD THEN DO:
                    IF lRetVal <> '' THEN lRetVal = lRetVal + ", ".
                    lRetVal = lRetVal + di-rutaD.nrodoc.
                END.
            END.
        END.
    END.

    /* Guias de Transferencias */
    IF i-faccpedi.coddoc = 'OTR' THEN DO:
        FOR EACH almcmov WHERE almcmov.codcia = s-codcia AND 
                                almcmov.codref = 'OTR' AND 
                                almcmov.nroref = i-faccpedi.nroped AND
                                almcmov.flgest <> 'A' NO-LOCK :
            /*
            IF lRetVal <> '' THEN lRetVal = lRetVal + ", ".
            lRetVal = lRetVal + "G/R" + "-" + STRING(almcmov.nroser,"999") + STRING(almcmov.nrodoc,"999999").
            */

            FIND FIRST di-rutaG WHERE DI-RutaG.codcia  = almcmov.codcia  AND                 
                                di-rutaG.codalm = almcmov.codalm  AND
                                di-rutaG.tipmov = almcmov.tipmov AND
                                di-rutaG.codmov = almcmov.codmov AND                                
                                di-rutaG.serref = almcmov.nroser AND
                                di-rutaG.nroref = almcmov.nrodoc NO-LOCK NO-ERROR.
            IF AVAILABLE di-rutaG THEN DO:
                IF lRetVal <> '' THEN lRetVal = lRetVal + ", ".
                lRetVal = lRetVal + di-rutaG.nrodoc.
            END.

        END.
    END.
END.

p-RetVal = lRetVal.

RELEASE i-faccpedi.
RELEASE i-ccbcdocu.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fAlmacen B-table-Win 
FUNCTION fAlmacen RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF NUM-ENTRIES(Faccpedi.Libre_c02,'|') > 1 
      THEN RETURN ENTRY(2,Faccpedi.Libre_c02,'|').
  ELSE RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCantidadSub B-table-Win 
FUNCTION fCantidadSub RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR lQty AS INT.

    DEFINE BUFFER b-vtaddocu FOR vtaddocu.

    lQty = 0.

    FOR EACH b-vtaddocu WHERE b-vtaddocu.codcia = vtacdocu.codcia AND
                            b-vtaddocu.coddiv = vtacdocu.coddiv AND
                            b-vtaddocu.codped = vtacdocu.codped AND
                            b-vtaddocu.nroped = vtacdocu.nroped NO-LOCK:

        lQty = lQty + b-vtaddocu.canped.
    END.
    RELEASE b-vtaddocu.


  RETURN lQty.   /* Function return value. */

    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDistribucion B-table-Win 
FUNCTION fDistribucion RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 1 
      THEN RETURN ENTRY(2,Faccpedi.Libre_c03,'|').
  ELSE RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fgen-empaques B-table-Win 
FUNCTION fgen-empaques RETURNS CHARACTER
  ( INPUT pCantidad AS dec ) :

    DEFINE VAR lRetVal AS CHAR INIT "".
    DEFINE VAR lSaldo AS DEC.
    DEFINE VAR lValor AS INT.

    lSaldo = pCantidad.
    IF lSaldo > 0 AND almmmatg.canemp > 0 THEN DO:
        lValor = TRUNCATE(lSaldo / almmmatg.canemp,0).
        IF lValor > 0 THEN DO:
            lRetVal = "M(" + STRING(lValor) + "/" + STRING(almmmatg.canemp) + " )".
        END.
        lSaldo = lSaldo - (lValor * almmmatg.canemp).
    END.
    IF lSaldo > 0 AND almmmatg.StkRep > 0 THEN DO:
        lValor = TRUNCATE(lSaldo / almmmatg.StkRep,0).
        IF lValor > 0 THEN DO:
            lRetVal = lRetVal + IF(lRetVal = "") THEN "" ELSE " ".
            lRetVal = lRetVal + "I(" + STRING(lValor) + "/" + STRING(almmmatg.StkRep) + ")".
        END.
        lSaldo = lSaldo - (lValor * almmmatg.StkRep).
    END.
    IF lSaldo > 0 THEN DO:
        lRetVal = lRetVal + IF(lRetVal = "") THEN "" ELSE " ".
        lRetVal = lRetVal + "U(" + STRING(lSaldo) + ")".
    END.


  RETURN lRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNroItm B-table-Win 
FUNCTION fNroItm RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR i AS INT.
FOR EACH facdpedi OF faccpedi NO-LOCK:
    i = i + 1.
END.
RETURN i.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNroItmSub B-table-Win 
FUNCTION fNroItmSub RETURNS INTEGER
  ( /* parameter-definitions */ ) :

DEF VAR i AS INT.
FOR EACH vtaddocu OF vtacdocu NO-LOCK:
    i = i + 1.
END.

RETURN i.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fOrdenCompra B-table-Win 
FUNCTION fOrdenCompra RETURNS CHARACTER
  ( INPUT pPedido AS CHAR, INPUT pFiltroOrdenCompra AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR lOrdenCompra AS CHAR INIT ''.
    DEFINE VAR lCotizacion AS CHAR INIT ''.
    
    DEFINE BUFFER b-faccpedi FOR faccpedi.
    DEFINE BUFFER c-faccpedi FOR faccpedi.
    
    /* Busco el PED */
    FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND 
                                b-faccpedi.coddoc = 'PED' AND
                                b-faccpedi.nroped = pPedido NO-LOCK NO-ERROR.
    IF AVAILABLE b-faccpedi THEN DO:
        lCotizacion = b-faccpedi.nroref.
        /* Busco la COT */
        FIND FIRST c-faccpedi WHERE c-faccpedi.codcia = s-codcia AND 
                                    c-faccpedi.coddoc = 'COT' AND
                                    c-faccpedi.nroped = lCotizacion NO-LOCK NO-ERROR.
        IF AVAILABLE c-faccpedi THEN DO:
            IF (c-faccpedi.ordcmp BEGINS pFiltroOrdenCompra) THEN DO:
                lOrdenCompra = TRIM(c-faccpedi.ordcmp).
            END.
        END.
    END.
    
    RELEASE b-faccpedi.
    RELEASE c-faccpedi.

RETURN lOrdenCompra.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPersonal B-table-Win 
FUNCTION fPersonal RETURNS CHARACTER
     (INPUT cCodPer AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR lPersonal AS CHAR.

    lPersonal = "".
    FIND FIRST pl-pers WHERE pl-pers.codper = cCodPer NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers THEN DO:
        lPersonal = pl-pers.patper + ' ' + pl-pers.matper + ' ' + pl-pers.nomper.
    END.

  RETURN lPersonal.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPeso B-table-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR lPeso AS DEC.

    DEFINE BUFFER b-facdpedi FOR facdpedi.

    lPeso = 0.
    lMsgRetorno = ''.

    FOR EACH b-facdpedi OF faccpedi NO-LOCK,
        FIRST almmmatg OF b-facdpedi NO-LOCK :
        IF almmmatg.pesmat <> ? AND almmmatg.pesmat > 0 THEN DO:
            lPeso = lPeso + (b-facdpedi.canped * almmmatg.pesmat).
        END.       
        ELSE DO:
            IF lMsgRetorno = '' THEN DO:
                lMsgRetorno = almmmatg.codmat.
            END.
            ELSE DO:
                lMsgRetorno = lMsgRetorno + ", " + almmmatg.codmat.
            END.
        END.
    END.
    RELEASE b-facdpedi.


  RETURN lPeso.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPesoSub B-table-Win 
FUNCTION fPesoSub RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR lPeso AS DEC.

    DEFINE BUFFER b-vtaddocu FOR vtaddocu.

    lPeso = 0.
    lMsgRetorno = ''.

    FOR EACH b-vtaddocu WHERE b-vtaddocu.codcia = vtacdocu.codcia AND
                            b-vtaddocu.coddiv = vtacdocu.coddiv AND
                            b-vtaddocu.codped = vtacdocu.codped AND
                            b-vtaddocu.nroped = vtacdocu.nroped NO-LOCK:
        FIND FIRST almmmatg WHERE b-vtaddocu.codcia = almmmatg.codcia AND
                    b-vtaddocu.codmat = almmmatg.codmat NO-LOCK.
        IF almmmatg.pesmat <> ? AND almmmatg.pesmat > 0 THEN DO:
            lPeso = lPeso + (b-vtaddocu.canped * almmmatg.pesmat).
        END.       
        ELSE DO:
            IF lMsgRetorno = '' THEN DO:
                lMsgRetorno = almmmatg.codmat.
            END.
            ELSE DO:
                lMsgRetorno = lMsgRetorno + ", " + almmmatg.codmat.
            END.
        END.
    END.
    RELEASE b-vtaddocu.


  RETURN lPeso.   /* Function return value. */

    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

