&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE COTIZACION NO-UNDO LIKE FacCPedi.
DEFINE BUFFER DETALLE FOR FacDPedi.
DEFINE BUFFER PEDIDOS FOR FacCPedi.



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
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEF VAR x-Estado AS CHAR NO-UNDO.

DEF VAR x-FlgEst AS CHAR init 'Todos' NO-UNDO.

/* Preprocesadores para cada campo filtro */
DEFINE SHARED VAR s-acceso-total  AS LOG.

DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-NROPED   AS CHAR.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.

DEF VAR pPorcAvance     AS DEC NO-UNDO.
DEF VAR pTotItems       AS INT NO-UNDO.
DEF VAR pTotPeso        AS DEC NO-UNDO.
DEF VAR pImpAtendido    AS DEC NO-UNDO.
DEF VAR pImpxAtender    AS DEC NO-UNDO.
DEF VAR pFlgEst         AS CHAR INIT 'Todos' NO-UNDO.

&SCOPED-DEFINE Condicion FacCPedi.CodDoc = "COT" ~
AND FacCPedi.FchPed >= FILL-IN-FchPed-1 ~
AND FacCPedi.FchPed <= FILL-IN-FchPed-2 ~
AND (TRUE <> (FILL-IN-NroPed > '') OR FacCPedi.NroPed = FILL-IN-NroPed) ~
AND (TRUE <> (FILL-IN-CodCli > '') OR FacCPedi.CodCli = FILL-IN-CodCli) ~
AND (FILL-IN-FchEnt-1 = ? OR FacCPedi.FchEnt >= FILL-IN-FchEnt-1) ~
AND (FILL-IN-FchEnt-2 = ? OR FacCPedi.FchEnt <= FILL-IN-FchEnt-2) 

DEF BUFFER tt-faccpedi FOR faccpedi.

DEFINE TEMP-TABLE T-Detalle
    FIELD CodDiv LIKE Faccpedi.coddiv LABEL "Div. Origen"
    FIELD Libre_c01 LIKE Faccpedi.Libre_c01 LABEL "Lista"
    FIELD NroPed LIKE Faccpedi.nroped LABEL "Numero"
    FIELD FchPed LIKE Faccpedi.fchped LABEL "Emision"
    FIELD FchVen LIKE Faccpedi.fchven LABEL "Vencimiento"
    FIELD FchEnt LIKE Faccpedi.fchent LABEL "Fecha Entrega"
    FIELD CodCli LIKE gn-clie.codcli LABEL 'Cliente'
    FIELD NomCli LIKE Faccpedi.nomcli LABEL "Nombre o Razon Social"
    FIELD LinCre    AS DEC FORMAT '->>>,>>>,>>>,>>9.99' LABEL 'Linea de Credito'
    FIELD SdoAnt    AS DEC FORMAT '->>>,>>>,>>>,>>9.99' LABEL 'Saldo Anticipos'
    FIELD LugEnt    AS CHAR LABEL "Lugar de Entrega"
    FIELD DistEnt   AS CHAR LABEL "Distrito Entrega"
    FIELD CodVen LIKE Faccpedi.codven LABEL "Vendedor"
    FIELD ImpTot LIKE Faccpedi.imptot LABEL "Importe"
    FIELD Estado    AS CHAR FORMAT 'x(30)' LABEL "Estado"
    FIELD Avance    AS DEC LABEL "% Avance"
    FIELD Items     AS INT LABEL "Total de Items"
    FIELD Peso      AS DEC LABEL "Total Peso Kg."
    FIELD Cuota     AS INT LABEL "C.O."
    FIELD Atendido  AS DEC FORMAT '->>>,>>>,>>>,>>9.99' LABEL "Import. Atendido"
    FIELD Pendiente AS DEC FORMAT '->>>,>>>,>>>,>>9.99' LABEL "Import. por Atender"
    FIELD CodAlm    AS CHAR LABEL "PDD"
    FIELD NroItm LIKE Facdpedi.nroitm LABEL "No."
    FIELD CodMat LIKE Facdpedi.codmat LABEL "Articulo"
    FIELD DesMat LIKE Almmmatg.desmat LABEL "Descripcion"
    FIELD DesMar LIKE Almmmatg.desmar LABEL "Marca"
    FIELD UndVta LIKE Facdpedi.undvta LABEL "Unidad"
    FIELD CanPed LIKE Facdpedi.canped LABEL "Cantidad Aprobada"
    FIELD CanAte LIKE Facdpedi.canate LABEL "Cantidad Atendida"
    FIELD PreUni LIKE Facdpedi.preuni LABEL "Precio Unitario"
    FIELD DctoManual AS DEC LABEL "% Dscto Manual"
    FIELD DctoEvento AS DEC LABEL "% Dscto Evento"
    FIELD DctoVolProm AS DEC LABEL "% Dscto Vol/Prom"
    FIELD ImpLin LIKE Facdpedi.implin LABEL "Importe"
    FIELD PesoUnit  AS DEC LABEL "Peso Unit"
    FIELD CubiUnit  AS DEC LABEL "Cubic Unit"
    FIELD PesoLin   AS DEC LABEL "Peso por Item"
    FIELD PesoAte   AS DEC LABEL "Peso Atendido"
    FIELD ImpAte    AS DEC FORMAT '->>>,>>>,>>>,>>9.99' LABEL "Import. Atendido"
    FIELD CantxAte  AS DEC LABEL "Cantidad por Atender"
    FIELD PesoxAte  AS DEC LABEL "Peso por Atender"
    FIELD ImpxAte   AS DEC FORMAT '->>>,>>>,>>>,>>9.99' LABEL "Import. por Atender".

DEF VAR pOptions AS CHAR.
DEF VAR pArchivo AS CHAR.
DEF VAR cArchivo AS CHAR.
DEF VAR zArchivo AS CHAR.
DEF VAR cComando AS CHAR.
DEF VAR pDirectorio AS CHAR.
DEF VAR lOptions AS CHAR.

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
&Scoped-define INTERNAL-TABLES COTIZACION FacCPedi

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacCPedi.CodDiv FacCPedi.NroPed ~
FacCPedi.FchPed FacCPedi.fchven FacCPedi.FchEnt FacCPedi.CodCli ~
FacCPedi.NomCli FacCPedi.CodVen FacCPedi.ImpTot COTIZACION.Libre_c02 ~
COTIZACION.Libre_d01 COTIZACION.ImpFle COTIZACION.ImpIsc ~
COTIZACION.Libre_d02 COTIZACION.AcuBon[4] COTIZACION.AcuBon[5] ~
COTIZACION.ImpDto COTIZACION.ImpDto2 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH COTIZACION WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST FacCPedi OF COTIZACION NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH COTIZACION WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST FacCPedi OF COTIZACION NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table COTIZACION FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-br_table COTIZACION
&Scoped-define SECOND-TABLE-IN-QUERY-br_table FacCPedi


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br_table}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-Division SELECT-FlgEst FILL-IN-NroPed ~
FILL-IN-CodCli FILL-IN-NomCli BUTTON-18 FILL-IN-CodVen BUTTON-1 ~
FILL-IN-FchPed-1 FILL-IN-FchPed-2 FILL-IN-FchEnt-1 FILL-IN-FchEnt-2 ~
br_table 
&Scoped-Define DISPLAYED-OBJECTS x-CodDiv SELECT-FlgEst FILL-IN-NroPed ~
FILL-IN-CodCli FILL-IN-NomCli FILL-IN-CodVen FILL-IN-NomVen ~
FILL-IN-FchPed-1 FILL-IN-FchPed-2 FILL-IN-FchEnt-1 FILL-IN-FchEnt-2 ~
FILL-IN-TotCuotas FILL-IN-TotPeso FILL-IN-TotItems FILL-IN-TotCotizaciones ~
FILL-IN-TotImporte FILL-IN-TotAtendido 

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
<FOREIGN-KEYS></FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
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
CodDiv|y||INTEGRAL.FacCPedi.CodDiv|yes,INTEGRAL.FacCPedi.NroPed|no
Libre_c01|||INTEGRAL.FacCPedi.Libre_c01|yes,INTEGRAL.FacCPedi.CodDiv|yes,INTEGRAL.FacCPedi.NroPed|no
ImpDto|||COTIZACION.ImpDto|no
ImpDto2|||COTIZACION.ImpDto2|no
CodVen|||INTEGRAL.FacCPedi.CodVen|yes
Libre_d02|||COTIZACION.Libre_d02|no
ImpIsc|||COTIZACION.ImpIsc|no
FchEnt|||INTEGRAL.FacCPedi.FchEnt|yes
ImpTot|||INTEGRAL.FacCPedi.ImpTot|no
NroPed|||INTEGRAL.FacCPedi.NroPed|no
LugEnt2|||INTEGRAL.FacCPedi.LugEnt2|yes,INTEGRAL.FacCPedi.NroPed|no
FchPed|||INTEGRAL.FacCPedi.FchPed|yes,INTEGRAL.FacCPedi.NroPed|no
fchven|||INTEGRAL.FacCPedi.fchven|yes,INTEGRAL.FacCPedi.NroPed|no
CodCli|||INTEGRAL.FacCPedi.CodCli|yes,INTEGRAL.FacCPedi.NroPed|no
NomCli|||INTEGRAL.FacCPedi.NomCli|yes,INTEGRAL.FacCPedi.NroPed|no
Libre_d01|||COTIZACION.Libre_d01|no
Libre_c02|||COTIZACION.Libre_c02|no
ImpFle|||COTIZACION.ImpFle|no
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "':U + 'CodDiv,Libre_c01,ImpDto,ImpDto2,CodVen,Libre_d02,ImpIsc,FchEnt,ImpTot,NroPed,LugEnt2,FchPed,fchven,CodCli,NomCli,Libre_d01,Libre_c02,ImpFle' + '",
     SortBy-Case = ':U + 'CodDiv').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fAnticipos B-table-Win 
FUNCTION fAnticipos RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCuotaOperativa B-table-Win 
FUNCTION fCuotaOperativa RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fImpAtendido B-table-Win 
FUNCTION fImpAtendido RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fImpxAtender B-table-Win 
FUNCTION fImpxAtender RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPorcAvance B-table-Win 
FUNCTION fPorcAvance RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fTotItems B-table-Win 
FUNCTION fTotItems RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fTotPeso B-table-Win 
FUNCTION fTotPeso RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD _FlgEst B-table-Win 
FUNCTION _FlgEst RETURNS CHARACTER
  ( INPUT pFlgEst AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Limpiar Filtros" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-18 
     LABEL "Aplicar Filtro" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Division 
     LABEL "..." 
     SIZE 4 BY .77 TOOLTIP "Selecciona Divisiones".

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Por Código de Cliente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodVen AS CHARACTER FORMAT "X(3)":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchEnt-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Entregar Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchEnt-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Entregar Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchPed-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchPed-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Por Nombre de Cliente" 
     VIEW-AS FILL-IN 
     SIZE 56 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroPed AS CHARACTER FORMAT "X(15)":U 
     LABEL "Nro. Ped. Comercial" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-TotAtendido AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total Atendido" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-TotCotizaciones AS DECIMAL FORMAT "->>>,>>9":U INITIAL 0 
     LABEL "Total de Cotizaciones" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-TotCuotas AS DECIMAL FORMAT "->>>,>>9":U INITIAL 0 
     LABEL "Total C.O." 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-TotImporte AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total Importe" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-TotItems AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Total Items" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-TotPeso AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Total Peso" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "División Origen" 
     VIEW-AS FILL-IN 
     SIZE 63 BY .81 NO-UNDO.

DEFINE VARIABLE SELECT-FlgEst AS CHARACTER INITIAL "Todos" 
     VIEW-AS SELECTION-LIST SINGLE 
     LIST-ITEM-PAIRS "Todos","Todos",
                     "Por Aprobar","PV",
                     "Pendiente Pedido Logistico","P",
                     "Atendida en Proceso","PP",
                     "Atendida Total","C",
                     "Cerrada Manualmente","X",
                     "Saldo Transferido","ST" 
     SIZE 20 BY 3.85 TOOLTIP "Selecciona Estados" NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      COTIZACION, 
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacCPedi.CodDiv FORMAT "x(5)":U
      FacCPedi.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U WIDTH 9.43
      FacCPedi.FchPed COLUMN-LABEL "Emision" FORMAT "99/99/9999":U
      FacCPedi.fchven COLUMN-LABEL "Vencimiento" FORMAT "99/99/9999":U
      FacCPedi.FchEnt COLUMN-LABEL "Fch Entrega" FORMAT "99/99/9999":U
      FacCPedi.CodCli COLUMN-LABEL "Cliente" FORMAT "x(11)":U WIDTH 9.86
      FacCPedi.NomCli COLUMN-LABEL "Nombre o Razon Social" FORMAT "x(100)":U
      FacCPedi.CodVen COLUMN-LABEL "Vend" FORMAT "x(5)":U
      FacCPedi.ImpTot COLUMN-LABEL "Importe" FORMAT "->>,>>>,>>9.99":U
      COTIZACION.Libre_c02 COLUMN-LABEL "Estado" FORMAT "x(30)":U
      COTIZACION.Libre_d01 COLUMN-LABEL "% Avance" FORMAT "->,>>9.99":U
      COTIZACION.ImpFle COLUMN-LABEL "Total de Items" FORMAT ">,>>9":U
      COTIZACION.ImpIsc COLUMN-LABEL "Total Peso Kg." FORMAT ">>>,>>9.99":U
      COTIZACION.Libre_d02 COLUMN-LABEL "C.O." FORMAT ">>9":U
      COTIZACION.AcuBon[4] COLUMN-LABEL "Import. Atendido" FORMAT "->>>>>,>>9.99":U
      COTIZACION.AcuBon[5] COLUMN-LABEL "Import. por Atender" FORMAT "->>>>>,>>9.99":U
      COTIZACION.ImpDto COLUMN-LABEL "Linea de credito" FORMAT "->>,>>>,>>9.99":U
      COTIZACION.ImpDto2 COLUMN-LABEL "Saldo Anticipos" FORMAT "->>>,>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 183 BY 5.96
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-CodDiv AT ROW 1.27 COL 15 COLON-ALIGNED WIDGET-ID 74
     BUTTON-Division AT ROW 1.27 COL 80 WIDGET-ID 76
     SELECT-FlgEst AT ROW 1.27 COL 114 NO-LABEL WIDGET-ID 82
     FILL-IN-NroPed AT ROW 2.08 COL 15 COLON-ALIGNED WIDGET-ID 40
     FILL-IN-CodCli AT ROW 2.88 COL 15 COLON-ALIGNED WIDGET-ID 44
     FILL-IN-NomCli AT ROW 2.88 COL 49 COLON-ALIGNED WIDGET-ID 48
     BUTTON-18 AT ROW 3.15 COL 151 WIDGET-ID 62
     FILL-IN-CodVen AT ROW 3.69 COL 15 COLON-ALIGNED WIDGET-ID 42
     FILL-IN-NomVen AT ROW 3.69 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     BUTTON-1 AT ROW 4.23 COL 151 WIDGET-ID 50
     FILL-IN-FchPed-1 AT ROW 4.5 COL 15 COLON-ALIGNED WIDGET-ID 26
     FILL-IN-FchPed-2 AT ROW 4.5 COL 39 COLON-ALIGNED WIDGET-ID 28
     FILL-IN-FchEnt-1 AT ROW 5.31 COL 15 COLON-ALIGNED WIDGET-ID 58
     FILL-IN-FchEnt-2 AT ROW 5.31 COL 39 COLON-ALIGNED WIDGET-ID 60
     br_table AT ROW 6.38 COL 1
     FILL-IN-TotCuotas AT ROW 12.35 COL 15 COLON-ALIGNED WIDGET-ID 94
     FILL-IN-TotPeso AT ROW 12.35 COL 38 COLON-ALIGNED WIDGET-ID 96
     FILL-IN-TotItems AT ROW 12.35 COL 60 COLON-ALIGNED WIDGET-ID 98
     FILL-IN-TotCotizaciones AT ROW 12.35 COL 89 COLON-ALIGNED WIDGET-ID 100
     FILL-IN-TotImporte AT ROW 12.35 COL 112 COLON-ALIGNED WIDGET-ID 102
     FILL-IN-TotAtendido AT ROW 12.35 COL 139 COLON-ALIGNED WIDGET-ID 106
     "Estado:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 1.27 COL 108 WIDGET-ID 84
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: COTIZACION T "?" NO-UNDO INTEGRAL FacCPedi
      TABLE: DETALLE B "?" ? INTEGRAL FacDPedi
      TABLE: PEDIDOS B "?" ? INTEGRAL FacCPedi
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
         HEIGHT             = 12.62
         WIDTH              = 191.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

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
/* BROWSE-TAB br_table FILL-IN-FchEnt-2 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 6
       br_table:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TotAtendido IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TotCotizaciones IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TotCuotas IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TotImporte IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TotItems IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TotPeso IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-CodDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.COTIZACION,INTEGRAL.FacCPedi OF Temp-Tables.COTIZACION"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _FldNameList[1]   = INTEGRAL.FacCPedi.CodDiv
     _FldNameList[2]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" "Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.fchven
"FacCPedi.fchven" "Vencimiento" "99/99/9999" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacCPedi.FchEnt
"FacCPedi.FchEnt" "Fch Entrega" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacCPedi.CodCli
"FacCPedi.CodCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" "Nombre o Razon Social" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.FacCPedi.CodVen
"FacCPedi.CodVen" "Vend" "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.FacCPedi.ImpTot
"FacCPedi.ImpTot" "Importe" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.COTIZACION.Libre_c02
"COTIZACION.Libre_c02" "Estado" "x(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.COTIZACION.Libre_d01
"COTIZACION.Libre_d01" "% Avance" "->,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.COTIZACION.ImpFle
"COTIZACION.ImpFle" "Total de Items" ">,>>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.COTIZACION.ImpIsc
"COTIZACION.ImpIsc" "Total Peso Kg." ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.COTIZACION.Libre_d02
"COTIZACION.Libre_d02" "C.O." ">>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.COTIZACION.AcuBon[4]
"COTIZACION.AcuBon[4]" "Import. Atendido" "->>>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.COTIZACION.AcuBon[5]
"COTIZACION.AcuBon[5]" "Import. por Atender" "->>>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.COTIZACION.ImpDto
"COTIZACION.ImpDto" "Linea de credito" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.COTIZACION.ImpDto2
"COTIZACION.ImpDto2" "Saldo Anticipos" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
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
ON LEFT-MOUSE-DBLCLICK OF br_table IN FRAME F-Main
DO:
    /*RUN vta/d-conpedcremos (Faccpedi.codcia, Faccpedi.coddiv, Faccpedi.coddoc, Faccpedi.nroped).*/
    /*RUN vta2/dcotizacionesypedidos (Faccpedi.coddoc, Faccpedi.nroped).*/
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
      WHEN "CodDiv" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'CodDiv').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
      WHEN "Libre_c01" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'Libre_c01').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
      WHEN "NroPed" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'NroPed').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
      WHEN "LugEnt2" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'LugEnt2').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
      WHEN "FchPed" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'FchPed').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
      WHEN "FchVen" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'FchVen').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
      WHEN "FchEnt" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'FchEnt').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
      WHEN "CodCli" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'CodCli').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
      WHEN "NomCli" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'NomCli').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
      WHEN "ImpTot" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'ImpTot').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
      WHEN "Libre_d01" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'Libre_d01').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
      WHEN "Libre_c02" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'Libre_c02').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
      WHEN "ImpFle" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'ImpFle').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
      WHEN "ImpIsc" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'ImpIsc').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
      WHEN "Libre_d02" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'Libre_d02').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
      WHEN "CodVen" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'CodVen').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
  END CASE.

  /*
  hQueryHandle = BROWSE {&BROWSE-NAME}:QUERY.
  hQueryHandle:QUERY-CLOSE().
  hQueryHandle:QUERY-PREPARE("FOR EACH CUSTOMER NO-LOCK BY " + hSortColumn:NAME).
  hQueryHandle:QUERY-OPEN().
  */
END.

/*
RUN set-attribute-list (
    'SortBy-Options = "':U + 'CodDiv,Libre_c01' + '",
     SortBy-Case = ':U + 'Libre_c01').
RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
  
  IF AVAILABLE Faccpedi
  THEN ASSIGN
      s-CodCli = Faccpedi.codcli
      s-CodDoc = Faccpedi.coddoc
      s-NroPed = Faccpedi.nroped.
  ELSE ASSIGN
      s-CodCli = ?
      s-CodDoc = ?
      s-NroPed = ?.
  RUN Procesa-Handle IN lh_handle ('Open-Query-2':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Limpiar Filtros */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      SELECT-FlgEst:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Todos' .
      ASSIGN
          x-CodDiv = ''
          FILL-IN-FchPed-1 = TODAY - DAY(TODAY) + 1
          FILL-IN-FchPed-2 = TODAY
          FILL-IN-FchEnt-1 = ?
          FILL-IN-FchEnt-2 = ?
          SELECT-FlgEst = 'Todos'

          FILL-IN-CodCli = ''
          FILL-IN-CodVen = ''
          FILL-IN-NomCli = ''

          FILL-IN-NomVen = ''
          FILL-IN-NroPed = ''
          .
      DISPLAY
          x-CodDiv
          FILL-IN-FchPed-1
          FILL-IN-FchPed-2
          FILL-IN-FchEnt-1
          FILL-IN-FchEnt-2
          SELECT-FlgEst

          FILL-IN-CodCli 
          FILL-IN-CodVen 
          FILL-IN-NomCli 

          FILL-IN-NomVen 
          FILL-IN-NroPed 
          
          WITH FRAME {&FRAME-NAME}.

      /* Redefinimos SELECT LIST */
      DEF VAR pLista AS CHAR NO-UNDO.
      DEF VAR k AS INT NO-UNDO.

      pLista = SELECT-FlgEst:LIST-ITEM-PAIRS.
      DO k = 1 TO SELECT-FlgEst:NUM-ITEMS:
          SELECT-FlgEst:DELETE(1).
      END.
      SELECT-FlgEst:LIST-ITEM-PAIRS = pLista.
      SELECT-FlgEst = 'Todos'.
      DISPLAY SELECT-FlgEst.


      EMPTY TEMP-TABLE COTIZACION.
      RUN dispatch IN THIS-PROCEDURE ('open-query':U).
      RUN Procesa-Handle IN lh_handle ('Open-Query':U).

      /*APPLY 'VALUE-CHANGED':U TO RADIO-SET-FlgEst.*/
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-18
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-18 B-table-Win
ON CHOOSE OF BUTTON-18 IN FRAME F-Main /* Aplicar Filtro */
DO:
  ASSIGN
      FILL-IN-CodCli FILL-IN-CodVen FILL-IN-NomCli FILL-IN-FchEnt-1 
      FILL-IN-FchEnt-2 FILL-IN-FchPed-1 FILL-IN-FchPed-2 FILL-IN-NomVen 
      FILL-IN-NroPed SELECT-FlgEst x-CodDiv
      
      .
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporal.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  RUN Procesa-Handle IN lh_handle ('Open-Query':U).
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Division B-table-Win
ON CHOOSE OF BUTTON-Division IN FRAME F-Main /* ... */
DO:
    ASSIGN x-CodDiv.
    RUN gn/d-filtro-divisiones (INPUT-OUTPUT x-CodDiv, "SELECCIONE LAS DIVISIONES").
    DISPLAY x-CodDiv WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli B-table-Win
ON LEAVE OF FILL-IN-CodCli IN FRAME F-Main /* Por Código de Cliente */
DO:
    FIND gn-clie WHERE gn-clie.CodCia = cl-codcia
        AND gn-clie.CodCli = INPUT {&self-name}
        NO-LOCK NO-ERROR.
    ASSIGN {&self-name}.
/*     IF AVAILABLE gn-clie THEN FILL-IN-DesCli:SCREEN-VALUE = gn-clie.NomCli. */
/*     ASSIGN {&self-name} FILL-IN-DesCli.                                     */
/*     RUN dispatch IN THIS-PROCEDURE ('open-query':U).  */
/*     RUN Procesa-Handle IN lh_handle ('Open-Query':U). */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodVen B-table-Win
ON LEAVE OF FILL-IN-CodVen IN FRAME F-Main /* Vendedor */
DO:
  FIND gn-ven WHERE gn-ven.CodCia = s-codcia
      AND gn-ven.CodVen = INPUT {&self-name}
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-ven THEN FILL-IN-NomVen:SCREEN-VALUE = gn-ven.NomVen.
  ASSIGN {&self-name} FILL-IN-NomVen.
/*   RUN dispatch IN THIS-PROCEDURE ('open-query':U).  */
/*   RUN Procesa-Handle IN lh_handle ('Open-Query':U). */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchEnt-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchEnt-1 B-table-Win
ON LEAVE OF FILL-IN-FchEnt-1 IN FRAME F-Main /* Entregar Desde */
DO:
    ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchEnt-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchEnt-2 B-table-Win
ON LEAVE OF FILL-IN-FchEnt-2 IN FRAME F-Main /* Entregar Hasta */
DO:
    ASSIGN {&self-name}.
/*     RUN dispatch IN THIS-PROCEDURE ('open-query':U).  */
/*     RUN Procesa-Handle IN lh_handle ('Open-Query':U). */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchPed-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchPed-1 B-table-Win
ON LEAVE OF FILL-IN-FchPed-1 IN FRAME F-Main /* Emitidos Desde */
DO:
    ASSIGN {&self-name}.
/*     RUN dispatch IN THIS-PROCEDURE ('open-query':U).  */
/*     RUN Procesa-Handle IN lh_handle ('Open-Query':U). */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchPed-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchPed-2 B-table-Win
ON LEAVE OF FILL-IN-FchPed-2 IN FRAME F-Main /* Emitidos Hasta */
DO:
    ASSIGN {&self-name}.
/*     RUN dispatch IN THIS-PROCEDURE ('open-query':U).  */
/*     RUN Procesa-Handle IN lh_handle ('Open-Query':U). */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroPed B-table-Win
ON LEAVE OF FILL-IN-NroPed IN FRAME F-Main /* Nro. Ped. Comercial */
DO:
  ASSIGN {&self-name}.
/*   RUN dispatch IN THIS-PROCEDURE ('open-query':U).  */
/*   RUN Procesa-Handle IN lh_handle ('Open-Query':U). */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME SELECT-FlgEst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SELECT-FlgEst B-table-Win
ON VALUE-CHANGED OF SELECT-FlgEst IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  x-FlgEst = SELECT-FlgEst.
  CASE SELECT-FlgEst:
      WHEN 'PV' THEN x-FlgEst = 'PV,PA,E'.
  END CASE.
  
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
    WHEN 'CodDiv':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.CodDiv BY FacCPedi.NroPed DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Libre_c01':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.Libre_c01 BY FacCPedi.CodDiv BY FacCPedi.NroPed DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'ImpDto':U THEN DO:
      &Scope SORTBY-PHRASE BY COTIZACION.ImpDto DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'ImpDto2':U THEN DO:
      &Scope SORTBY-PHRASE BY COTIZACION.ImpDto2 DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'CodVen':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.CodVen
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Libre_d02':U THEN DO:
      &Scope SORTBY-PHRASE BY COTIZACION.Libre_d02 DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'ImpIsc':U THEN DO:
      &Scope SORTBY-PHRASE BY COTIZACION.ImpIsc DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'FchEnt':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.FchEnt
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'ImpTot':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.ImpTot DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'NroPed':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.NroPed DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'LugEnt2':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.LugEnt2 BY FacCPedi.NroPed DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'FchPed':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.FchPed BY FacCPedi.NroPed DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'fchven':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.fchven BY FacCPedi.NroPed DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'CodCli':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.CodCli BY FacCPedi.NroPed DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'NomCli':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.NomCli BY FacCPedi.NroPed DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Libre_d01':U THEN DO:
      &Scope SORTBY-PHRASE BY COTIZACION.Libre_d01 DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Libre_c02':U THEN DO:
      &Scope SORTBY-PHRASE BY COTIZACION.Libre_c02 DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'ImpFle':U THEN DO:
      &Scope SORTBY-PHRASE BY COTIZACION.ImpFle DESCENDING
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

EMPTY TEMP-TABLE COTIZACION.

DEF VAR k AS INTE NO-UNDO.

PRINCIPAL:
DO k = 1 TO NUM-ENTRIES(x-CodDiv):
    FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = ENTRY(k, x-CodDiv):
        FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = gn-divi.codcia 
            AND Faccpedi.coddiv = gn-divi.coddiv
            AND {&Condicion}:
            IF NOT (TRUE <> (FILL-IN-CodVen > '') OR FacCPedi.CodVen = FILL-IN-CodVen) THEN NEXT.
            IF NOT (TRUE <> (FILL-IN-NomCli > '') OR INDEX(Faccpedi.nomcli, FILL-IN-NomCli) > 0 ) THEN NEXT.

            /* POR ESTADO */
            CASE TRUE:
                WHEN LOOKUP("Todos", x-FlgEst) > 0 THEN DO:    /* NO Filtrado */
                END.
                WHEN LOOKUP("PP", x-FlgEst) > 0 THEN DO:      /* Atendida en Proceso */
                    IF NOT (Faccpedi.FlgEst = "P" AND 
                            CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE Facdpedi.CanAte > 0 NO-LOCK))
                        THEN NEXT.
                END.
                WHEN LOOKUP(Faccpedi.FlgEst, x-FlgEst) = 0 THEN NEXT.
            END CASE.

            
            CREATE COTIZACION.
            BUFFER-COPY Faccpedi TO COTIZACION.
            ASSIGN
                COTIZACION.Libre_c02 = _FlgEst(COTIZACION.FlgEst)
                COTIZACION.Libre_d01 = fPorcAvance()
                COTIZACION.ImpIsc = fTotPeso()
                COTIZACION.AcuBon[4] = fImpAtendido()
                COTIZACION.AcuBon[5] = fImpxAtender()
                COTIZACION.ImpFle    = fTotItems().
            /* CUOTA OPERATIVA */
            ASSIGN
                COTIZACION.Libre_d02 = fCuotaOperativa().
            /* Linea de Credito */
            DEF VAR dMonLC AS INT NO-UNDO.
            DEF VAR dImpLCred AS DEC NO-UNDO.

            RUN ccb/p-implc (cl-codcia, Faccpedi.coddiv, Faccpedi.codcli, OUTPUT dMonLC, OUTPUT dImpLCred).
            ASSIGN COTIZACION.ImpDto = dImpLCred.
            /* ANTICIPOS */
            ASSIGN COTIZACION.ImpDto2 = fAnticipos().

            /* Controles Finales */
            IF COTIZACION.FlgEst = "P" 
                AND CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE Facdpedi.canate > 0 NO-LOCK) 
                THEN COTIZACION.FlgEst = "PP".
            IF COTIZACION.FlgEst = "C"
                AND COTIZACION.Libre_d01 < 100 
                THEN COTIZACION.FlgEst = "PP".
            ASSIGN COTIZACION.Libre_c02 = _FlgEst(COTIZACION.FlgEst).
        END.
    END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
/*   x-CodDiv:DELETE(1) IN FRAME {&FRAME-NAME}. */
  ASSIGN
      FILL-IN-FchPed-1 = TODAY - DAY(TODAY) + 1
      FILL-IN-FchPed-2 = TODAY
      x-CodDiv = s-CodDiv.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      IF s-acceso-total = NO THEN ASSIGN x-CodDiv:SENSITIVE = NO BUTTON-Division:SENSITIVE = NO.
  END.

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
  RUN Totales.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-changed B-table-Win 
PROCEDURE local-row-changed :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-changed':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  APPLY 'value-changed' TO {&browse-name} IN FRAME {&FRAME-NAME}.
  /*
  IF AVAILABLE Faccpedi THEN s-NroPed = Faccpedi.nroped.
  ELSE s-NroPed = ?.
  RUN Procesa-Handle IN lh_handle ('Open-Query-2':U).
  */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Numero-Cotizacion B-table-Win 
PROCEDURE Numero-Cotizacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAMETER pNroCot AS CHAR.

IF AVAILABLE Faccpedi THEN pNroCot = Faccpedi.nroped.
ELSE pNroCot = ?.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key B-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

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
  {src/adm/template/snd-list.i "COTIZACION"}
  {src/adm/template/snd-list.i "FacCPedi"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Solo-Cabecera B-table-Win 
PROCEDURE Solo-Cabecera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN
        pOptions = "".
    RUN lib/tt-file-to-text-01 (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    SESSION:SET-WAIT-STATE('GENERAL').
    EMPTY TEMP-TABLE T-Detalle.
    GET FIRST {&browse-name}.
    REPEAT WHILE AVAILABLE COTIZACION:
        CREATE T-Detalle.
        BUFFER-COPY Faccpedi
            TO T-Detalle
            ASSIGN
            T-Detalle.Estado = COTIZACION.Libre_C02
            T-Detalle.Avance = COTIZACION.Libre_D01
            T-Detalle.Cuota = COTIZACION.Libre_D02
            T-Detalle.Items = COTIZACION.AcuBon[2]
            T-Detalle.Items = COTIZACION.ImpFle
            T-Detalle.Peso = COTIZACION.ImpIsc
            T-Detalle.Atendido = COTIZACION.AcuBon[4]
            T-Detalle.Pendiente = COTIZACION.AcuBon[5]
            T-Detalle.CodAlm = faccpedi.lugent2
            T-Detalle.LinCre = COTIZACION.AcuBon[6]
            T-Detalle.SdoAnt = COTIZACION.AcuBon[7].
        GET NEXT {&browse-name}.
    END.
    SESSION:SET-WAIT-STATE('').

    FIND FIRST T-Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE T-Detalle THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    /* Definimos los campos a mostrar */
    ASSIGN lOptions = "FieldList:".
    lOptions = lOptions + "coddiv,libre_c01,nroped,fchped,fchven,fchent,nomcli," +
        "lincre,sdoant,codven,imptot,estado,avance,items,peso,cuota,atendido,pendiente,codalm".
    pOptions = pOptions + CHR(1) + lOptions.

    /* El archivo se va a generar en un archivo temporal de trabajo antes 
    de enviarlo a su directorio destino */
    cArchivo = LC(pArchivo).
    SESSION:SET-WAIT-STATE('GENERAL').
    /*SESSION:DATE-FORMAT = "mdy".*/
    RUN lib/tt-filev2 (TEMP-TABLE T-Detalle:HANDLE, cArchivo, pOptions).
    /*SESSION:DATE-FORMAT = "dmy".*/
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    RUN Procesa-Handle IN lh_handle ('Open-Query':U).
    MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Solo-Cabecera-Detalle B-table-Win 
PROCEDURE Solo-Cabecera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    ASSIGN
        pOptions = "".
    RUN lib/tt-file-to-text-01 (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    SESSION:SET-WAIT-STATE('GENERAL').
    EMPTY TEMP-TABLE T-Detalle.
    GET FIRST {&browse-name}.
    REPEAT WHILE AVAILABLE COTIZACION:
        FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = COTIZACIOn.codcli
            NO-LOCK NO-ERROR.
        FOR EACH DETALLE OF Faccpedi NO-LOCK,FIRST Almmmatg OF DETALLE NO-LOCK :
            CREATE T-Detalle.
            BUFFER-COPY Faccpedi
                TO T-Detalle
                ASSIGN
                T-Detalle.Estado = COTIZACION.Libre_C02
                T-Detalle.Avance = COTIZACION.Libre_D01
                T-Detalle.Items = COTIZACION.AcuBon[2]
                T-Detalle.Items = COTIZACION.ImpFle
                T-Detalle.Peso = COTIZACION.ImpIsc
                T-Detalle.Atendido = COTIZACION.AcuBon[4]
                T-Detalle.Pendiente = COTIZACION.AcuBon[5]
                T-Detalle.CodAlm = faccpedi.lugent2
                T-Detalle.NroItm = DETALLE.nroitm
                T-Detalle.CodMat = DETALLE.codmat
                T-Detalle.DesMat = Almmmatg.desmat
                T-Detalle.DesMar = Almmmatg.desmar
                T-Detalle.UndVta = DETALLE.undvta
                T-Detalle.CanPed = DETALLE.canped
                T-Detalle.CanAte = DETALLE.canate
                T-Detalle.PreUni = DETALLE.preuni
                T-Detalle.DctoManual = DETALLE.por_dscto[1]
                T-Detalle.DctoEvento = DETALLE.por_dscto[2]
                T-Detalle.DctoVolProm = DETALLE.por_dscto[3]
                T-Detalle.ImpLin = DETALLE.ImpLin
                T-Detalle.PesoUnit = Almmmatg.PesMat
                T-Detalle.CubiUnit = Almmmatg.Libre_d02
                T-Detalle.PesoLin = DETALLE.CanPed * Almmmatg.PesMat
                T-Detalle.PesoAte = DETALLE.CanAte * Almmmatg.PesMat
                T-Detalle.ImpAte  = DETALLE.CanAte * (DETALLE.ImpLin / DETALLE.CanPed)
                T-Detalle.CantxAte = DETALLE.CanPed - DETALLE.CanAte
                T-Detalle.PesoxAte = T-Detalle.CantxAt * Almmmatg.PesMat
                T-Detalle.ImpxAte = T-Detalle.ImpLin - T-Detalle.ImpAte
                T-Detalle.LinCre = COTIZACION.ImpDto
                T-Detalle.SdoAnt = COTIZACION.ImpDto2.

            IF AVAILABLE gn-clie THEN DO:
                FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept
                    AND Tabdistr.Codprovi = gn-clie.codprov
                    AND Tabdistr.Coddistr = gn-clie.coddist
                    NO-LOCK NO-ERROR.
                IF T-Detalle.LugEnt = '' THEN T-Detalle.LugEnt = gn-clie.dirent.
                IF AVAILABLE Tabdistr THEN T-Detalle.DistEnt = TabDistr.NomDistr.

            END.

        END.
        GET NEXT {&browse-name}.
    END.
    SESSION:SET-WAIT-STATE('').

    FIND FIRST T-Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE T-Detalle THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    /* Definimos los campos a mostrar */
    ASSIGN lOptions = "FieldList:".
/*     lOptions = lOptions + "coddiv,libre_c01,nroped,fchped,fchven,fchent,nomcli," + */
/*         "codven,imptot,estado,avance,items,peso,atendido,pendiente,codalm," +      */
/*         "nroitm,codmat,desmat,desmar,undvta,canped,canate,preuni,dctomanual," +    */
/*         "dctoevento,dctovolprom,implin".                                           */
    lOptions = lOptions + "coddiv,libre_c01,nroped,fchped,fchven,fchent,codcli,nomcli," +
        "lincre,sdoant,lugent,distent,codven,estado,peso,atendido,pendiente,codalm," +
        "nroitm,codmat,desmat,desmar,undvta,pesounit,cubiunit,canped,pesolin,preuni,dctomanual," +
        "dctoevento,dctovolprom,implin,canate,pesoate,impate,cantxate,pesoxate,impxate".
    pOptions = pOptions + CHR(1) + lOptions.
    /* El archivo se va a generar en un archivo temporal de trabajo antes 
    de enviarlo a su directorio destino */
    cArchivo = LC(pArchivo).
    SESSION:SET-WAIT-STATE('GENERAL').
    /*SESSION:DATE-FORMAT = "mdy".*/
    RUN lib/tt-filev2 (TEMP-TABLE T-Detalle:HANDLE, cArchivo, pOptions).
    /*SESSION:DATE-FORMAT = "dmy".*/
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    RUN Procesa-Handle IN lh_handle ('Open-Query':U).
    MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Totales B-table-Win 
PROCEDURE Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN
    FILL-IN-TotCotizaciones = 0
    FILL-IN-TotCuotas = 0
    FILL-IN-TotImporte = 0
    FILL-IN-TotItems = 0
    FILL-IN-TotPeso = 0
    FILL-IN-TotAtendido = 0.
FOR EACH COTIZACION NO-LOCK /*WHERE (SELECT-FlgEst BEGINS "Todos" 
                           OR LOOKUP(COTIZACION.FlgEst, SELECT-FlgEst) > 0) NO-LOCK*/,
    FIRST INTEGRAL.FacCPedi OF COTIZACION NO-LOCK:
    ASSIGN
        FILL-IN-TotCotizaciones = FILL-IN-TotCotizaciones + 1
        FILL-IN-TotCuotas = FILL-IN-TotCuotas + COTIZACION.Libre_d02
        FILL-IN-TotImporte = FILL-IN-TotImporte + COTIZACION.ImpTot
        FILL-IN-TotItems = FILL-IN-TotItems + COTIZACION.ImpFle
        FILL-IN-TotPeso = FILL-IN-TotPeso + COTIZACION.ImpIsc
        FILL-IN-TotAtendido = FILL-IN-TotAtendido + COTIZACION.AcuBon[4].

END.
DISPLAY
    FILL-IN-TotCotizaciones FILL-IN-TotCuotas FILL-IN-TotImporte FILL-IN-TotItems FILL-IN-TotPeso
    FILL-IN-TotAtendido
    WITH FRAME {&FRAME-NAME}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fAnticipos B-table-Win 
FUNCTION fAnticipos RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR pAnticipo AS DEC NO-UNDO.
FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
    AND ccbcdocu.coddoc = 'A/R'
    AND ccbcdocu.flgest = 'P'
    AND ccbcdocu.codcli = faccpedi.codcli
    AND ccbcdocu.coddiv = faccpedi.coddiv:
    IF ccbcdocu.codmon = 1 THEN pAnticipo = pAnticipo + ccbcdocu.sdoact.
    ELSE pAnticipo = pAnticipo + (ccbcdocu.sdoact * ccbcdocu.tpocmb).
END.
RETURN pAnticipo.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCuotaOperativa B-table-Win 
FUNCTION fCuotaOperativa RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR x-TotPeso AS DEC NO-UNDO.
DEF VAR x-TotItems AS INT NO-UNDO.
DEF VAR x-CocientePeso AS DEC NO-UNDO.
DEF VAR x-CocienteItems AS DEC NO-UNDO.
DEF VAR x-FactorPeso AS DEC NO-UNDO.
DEF VAR x-FactorItems AS DEC NO-UNDO.
DEF VAR x-Final AS INT NO-UNDO.

ASSIGN
    x-TotPeso  = COTIZACION.ImpIsc
    x-TotItems = COTIZACION.ImpFle.
ASSIGN
    x-FactorPeso = INTEGER(x-CocientePeso)
    x-FactorItems = INTEGER(x-CocienteItems).
IF x-FactorPeso < x-CocientePeso THEN x-FactorPeso = x-FactorPeso + 1.
IF x-FactorItems < x-CocienteItems THEN x-FactorItems = x-FactorItems + 1.
x-Final = MAXIMUM(x-FactorPeso, x-FactorItems).
RETURN x-Final.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fImpAtendido B-table-Win 
FUNCTION fImpAtendido RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR xImpAte AS DEC NO-UNDO.

  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
      ASSIGN
          xImpAte = xImpAte + (Facdpedi.ImpLin / facdpedi.CanPed) * Facdpedi.CanAte.
  END.

  RETURN xImpAte.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fImpxAtender B-table-Win 
FUNCTION fImpxAtender RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEF VAR xImpAte AS DEC NO-UNDO.
    DEF VAR xImpTot AS DEC NO-UNDO.

  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
      ASSIGN
          xImpTot = xImpTot + Facdpedi.ImpLin.
          xImpAte = xImpAte + (Facdpedi.ImpLin / facdpedi.CanPed) * Facdpedi.CanAte.
  END.

  RETURN xImpTot - xImpAte.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPorcAvance B-table-Win 
FUNCTION fPorcAvance RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  Deo facturado
------------------------------------------------------------------------------*/

  DEF VAR xPorcAvance AS DEC NO-UNDO.
  DEF VAR xImpPed AS DEC NO-UNDO.
  DEF VAR xImpAte AS DEC NO-UNDO.

  DEF BUFFER PEDIDOS  FOR Faccpedi.
  DEF BUFFER FACTURAS FOR Ccbcdocu.
  DEF BUFFER CREDITOS FOR Ccbcdocu.

  /* 17/12/2014 Probemos por cantidades */
  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
      xImpPed = xImpPed + Facdpedi.canped.
  END.
  FOR EACH PEDIDOS NO-LOCK WHERE PEDIDOS.codcia = Faccpedi.codcia
      AND PEDIDOS.coddoc = 'PED'
      AND PEDIDOS.codref = Faccpedi.coddoc
      AND PEDIDOS.nroref = Faccpedi.nroped
      AND PEDIDOS.fchped >= Faccpedi.fchped
      AND PEDIDOS.flgest <> "A",
      EACH FACTURAS NO-LOCK WHERE FACTURAS.codcia = Faccpedi.codcia
      AND LOOKUP(FACTURAS.coddoc, 'FAC,BOL') > 0
      AND FACTURAS.flgest <> "A"
      AND FACTURAS.codped = PEDIDOS.coddoc
      AND FACTURAS.nroped = PEDIDOS.nroped
      AND FACTURAS.fchdoc >= PEDIDOS.fchped:
      FOR EACH Ccbddocu OF FACTURAS NO-LOCK:
          ASSIGN xImpAte = xImpAte + Ccbddocu.CanDes.
      END.
      FOR EACH CREDITOS NO-LOCK WHERE CREDITOS.codcia = FACTURAS.codcia
          AND CREDITOS.coddoc = "N/C"
          AND CREDITOS.codref = FACTURAS.coddoc
          AND CREDITOS.nroref = FACTURAS.nrodoc
          AND CREDITOS.cndcre = "D"
          AND CREDITOS.flgest <> "A",
          EACH Ccbddocu OF CREDITOS NO-LOCK:
          ASSIGN xImpAte = xImpAte - Ccbddocu.CanDes.
      END.
  END.
  xPorcAvance = xImpAte / xImpPed * 100.
  IF xPorcAvance < 0 THEN xPorcAvance = 0.
  IF xPorcAvance > 100 THEN xPorcAvance = 100.


  RETURN ROUND(xPorcAvance, 2).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fTotItems B-table-Win 
FUNCTION fTotItems RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR xTotItems AS INTE NO-UNDO.

  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
      ASSIGN
          xTotItems = xTotItems + 1.
  END.

  RETURN xTotItems.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fTotPeso B-table-Win 
FUNCTION fTotPeso RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

        
  DEF VAR xTotPeso AS DEC.
  FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
      ASSIGN
          xTotPeso = xTotPeso + Facdpedi.canPed * Facdpedi.factor * Almmmatg.PesMat.
  END.
  RETURN xTotPeso.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION _FlgEst B-table-Win 
FUNCTION _FlgEst RETURNS CHARACTER
  ( INPUT pFlgEst AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR pEstado AS CHAR NO-UNDO.

RUN vta2/p-faccpedi-flgest (Faccpedi.FlgEst, Faccpedi.CodDoc, OUTPUT pEstado).

RETURN pEstado.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

