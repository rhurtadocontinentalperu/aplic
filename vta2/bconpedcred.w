&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE BUFFER DETALLE FOR FacDPedi.
DEFINE BUFFER ORDENES FOR FacCPedi.
DEFINE SHARED TEMP-TABLE PEDIDO LIKE FacCPedi.



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
DEFINE SHARED VARIABLE S-TIPO     AS CHAR.
/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEF VAR x-Estado AS CHAR NO-UNDO.

/* Preprocesadores para cada campo filtro */

DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-NROPED   AS CHAR.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.

DEF VAR pPorcAvance     AS DEC NO-UNDO.
DEF VAR pTotItems       AS INT NO-UNDO.
DEF VAR pTotPeso        AS DEC NO-UNDO.
DEF VAR pImpAtendido    AS DEC NO-UNDO.
DEF VAR pImpxAtender    AS DEC NO-UNDO.
DEF VAR pFlgEst         AS CHAR INIT 'Todos' NO-UNDO.

&SCOPED-DEFINE Condicion FacCPedi.CodCia = s-codcia ~
 AND FacCPedi.CodDoc = "PED" ~
 AND (x-CodDiv = '' OR LOOKUP(FacCPedi.CodDiv, x-CodDiv) > 0 ) ~
 AND FacCPedi.FchPed >= FILL-IN-FchPed-1 ~
 AND FacCPedi.FchPed <= FILL-IN-FchPed-2 ~
 AND LOOKUP(FacCPedi.FlgEst, 'A,R') = 0 ~
 AND (FILL-IN-CodVen = '' OR FacCPedi.CodVen = FILL-IN-CodVen) ~
 AND (FILL-IN-CodCli = '' OR FacCPedi.CodCli = FILL-IN-CodCli) ~
 AND (FILL-IN-FchEnt-1 = ? OR FacCPedi.FchEnt >= FILL-IN-FchEnt-1) ~
 AND (FILL-IN-FchEnt-2 = ? OR FacCPedi.FchEnt <= FILL-IN-FchEnt-2) ~
 AND (FILL-IN-NomCli = '' OR INDEX(Faccpedi.nomcli, FILL-IN-NomCli) > 0 ) ~
 AND (x-Almacenes = '' OR LOOKUP(Faccpedi.codalm, x-Almacenes) > 0 )
 

/*
&SCOPED-DEFINE Condicion FacCPedi.CodCia = s-codcia ~
 AND FacCPedi.CodDoc = "PED" ~
 AND (x-CodDiv = '' OR LOOKUP(FacCPedi.CodDiv, x-CodDiv) > 0 ) ~
 AND FacCPedi.FchPed >= FILL-IN-FchPed-1 ~
 AND FacCPedi.FchPed <= FILL-IN-FchPed-2 ~
 AND LOOKUP(FacCPedi.FlgEst, 'A,R') = 0 ~
 AND (FILL-IN-NroPed = '' OR FacCPedi.NroPed = FILL-IN-NroPed) ~
 AND (FILL-IN-CodVen = '' OR FacCPedi.CodVen = FILL-IN-CodVen) ~
 AND (FILL-IN-CodCli = '' OR FacCPedi.CodCli = FILL-IN-CodCli) ~
 AND (FILL-IN-FchEnt-1 = ? OR FacCPedi.FchEnt >= FILL-IN-FchEnt-1) ~
 AND (FILL-IN-FchEnt-2 = ? OR FacCPedi.FchEnt <= FILL-IN-FchEnt-2) ~
 AND (FILL-IN-NomCli = '' OR INDEX(Faccpedi.nomcli, FILL-IN-NomCli) > 0 )

*/
DEF BUFFER tt-faccpedi FOR faccpedi.

/*AND (x-Lista = '' OR LOOKUP(Faccpedi.libre_c01, x-Lista) > 0 ) ~*/

    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
    DEF VAR cArchivo AS CHAR.
    DEF VAR zArchivo AS CHAR.
    DEF VAR cComando AS CHAR.
    DEF VAR pDirectorio AS CHAR.
    DEF VAR lOptions AS CHAR.

    DEFINE TEMP-TABLE T-Detalle
        FIELD CodDiv LIKE Faccpedi.coddiv LABEL "Origen"
        FIELD Libre_c01 LIKE Faccpedi.Libre_c01 FORMAT 'x(10)' LABEL "Lista"
        FIELD NroPed LIKE Faccpedi.nroped LABEL "Pedido"
        FIELD FchPed LIKE Faccpedi.fchped LABEL "Emision"
        FIELD FchVen LIKE Faccpedi.fchven LABEL "Vencimiento"
        FIELD FchEnt LIKE Faccpedi.fchent LABEL "Fecha Entrega"
        FIELD NroOrd LIKE Faccpedi.nroped LABEL "O/D"
        FIELD CodCli LIKE gn-clie.codcli LABEL 'Cliente'
        FIELD NomCli LIKE Faccpedi.nomcli LABEL "Nombre o Razon Social"
        FIELD LugEnt AS CHAR FORMAT 'x(60)' LABEL "Destino"
        FIELD DistEnt AS CHAR FORMAT 'x(30)' LABEL "Distrito"
        FIELD ProvEnt AS CHAR FORMAT 'x(30)' LABEL "Provincia"
        FIELD CodVen LIKE Faccpedi.codven LABEL "Vendedor"
        FIELD ImpTot LIKE Faccpedi.imptot LABEL "Importe"
        FIELD Estado AS CHAR FORMAT 'x(20)' LABEL "Estado"
        FIELD Avance AS DEC LABEL "% Avance"
        FIELD Items AS INT LABEL "Total de Items"
        FIELD Peso AS DEC LABEL "Total Peso Kg."
        FIELD Cuota AS INT LABEL "C.O."
        FIELD Atendido AS DEC LABEL "Import. Atendido"
        FIELD Pendiente AS DEC LABEL "Import. por Atender"
        FIELD CodAlm AS CHAR LABEL "PDD"
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
        FIELD PesoUnit AS DEC LABEL "Peso Unit"
        FIELD CubiUnit AS DEC LABEL "Cubic Unit"
        FIELD PesoLin AS DEC LABEL "Peso por Item"
        FIELD PesoAte AS DEC LABEL "Peso Atendido"
        FIELD ImpAte  AS DEC LABEL "Import. Atendido"
        FIELD CantxAte AS DEC LABEL "Cantidad por Atender"
        FIELD PesoxAte AS DEC LABEL "Peso por Atender"
        FIELD ImpxAte  AS DEC LABEL "Import. por Atender".

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
&Scoped-define INTERNAL-TABLES PEDIDO FacCPedi

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacCPedi.CodDiv PEDIDO.Libre_c01 ~
FacCPedi.NroPed FacCPedi.CodAlm FacCPedi.FchPed FacCPedi.fchven ~
FacCPedi.FchEnt PEDIDO.NCmpbnte FacCPedi.CodCli FacCPedi.NomCli ~
FacCPedi.CodVen FacCPedi.ImpTot PEDIDO.Libre_c02 PEDIDO.Libre_d01 ~
PEDIDO.AcuBon[2] PEDIDO.AcuBon[3] PEDIDO.AcuBon[4] PEDIDO.AcuBon[5] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH PEDIDO WHERE ~{&KEY-PHRASE} ~
      AND (SELECT-FlgEst BEGINS "Todos" OR LOOKUP(PEDIDO.FlgEst, SELECT-FlgEst) > 0) NO-LOCK, ~
      FIRST FacCPedi OF PEDIDO NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH PEDIDO WHERE ~{&KEY-PHRASE} ~
      AND (SELECT-FlgEst BEGINS "Todos" OR LOOKUP(PEDIDO.FlgEst, SELECT-FlgEst) > 0) NO-LOCK, ~
      FIRST FacCPedi OF PEDIDO NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table PEDIDO FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-br_table PEDIDO
&Scoped-define SECOND-TABLE-IN-QUERY-br_table FacCPedi


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br_table}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-19 RECT-20 BUTTON-Division BUTTON-Excel ~
BUTTON-18 SELECT-FlgEst BUTTON-Lista FILL-IN-FchPed-1 FILL-IN-FchPed-2 ~
BUTTON-1 RADIO-SET-Excel FILL-IN-FchEnt-1 FILL-IN-FchEnt-2 BUTTON-Almacenes ~
FILL-IN-CodVen FILL-IN-CodCli FILL-IN-NomCli br_table 
&Scoped-Define DISPLAYED-OBJECTS x-CodDiv SELECT-FlgEst x-Lista ~
FILL-IN-FchPed-1 FILL-IN-FchPed-2 RADIO-SET-Excel FILL-IN-FchEnt-1 ~
FILL-IN-FchEnt-2 x-Almacenes FILL-IN-CodVen FILL-IN-NomVen FILL-IN-CodCli ~
FILL-IN-NomCli 

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
ImpTot|||INTEGRAL.FacCPedi.ImpTot|no
NroPed|||INTEGRAL.FacCPedi.NroPed|no
LugEnt2|||INTEGRAL.FacCPedi.CodAlm|yes,INTEGRAL.FacCPedi.NroPed|no
FchPed|||INTEGRAL.FacCPedi.FchPed|yes,INTEGRAL.FacCPedi.NroPed|no
fchven|||INTEGRAL.FacCPedi.fchven|yes,INTEGRAL.FacCPedi.NroPed|no
CodCli|||INTEGRAL.FacCPedi.CodCli|yes,INTEGRAL.FacCPedi.NroPed|no
NomCli|||INTEGRAL.FacCPedi.NomCli|yes,INTEGRAL.FacCPedi.NroPed|no
Libre_d01|||PEDIDO.Libre_d01|no
Libre_c02|||PEDIDO.Libre_c02|no
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "':U + 'CodDiv,Libre_c01,ImpTot,NroPed,LugEnt2,FchPed,fchven,CodCli,NomCli,Libre_d01,Libre_c02' + '",
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

DEFINE BUTTON BUTTON-Almacenes 
     LABEL "..." 
     SIZE 4 BY .77 TOOLTIP "Selecciona Almacenes".

DEFINE BUTTON BUTTON-Division 
     LABEL "..." 
     SIZE 4 BY .77 TOOLTIP "Selecciona Divisiones".

DEFINE BUTTON BUTTON-Excel 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 7" 
     SIZE 6 BY 1.54.

DEFINE BUTTON BUTTON-Lista 
     LABEL "..." 
     SIZE 4 BY .77 TOOLTIP "Selecciona Listas".

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Por Código de Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

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

DEFINE VARIABLE x-Almacenes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacén(es) PDD" 
     VIEW-AS FILL-IN 
     SIZE 63 BY .81
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE x-CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "División Origen" 
     VIEW-AS FILL-IN 
     SIZE 63 BY .81
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE x-Lista AS CHARACTER FORMAT "X(256)":U 
     LABEL "Lista de Precios" 
     VIEW-AS FILL-IN 
     SIZE 63 BY .81
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RADIO-SET-Excel AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Solo Cabeceras", 1,
"Cabecera + Detalle", 2
     SIZE 16 BY 1.54 NO-UNDO.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 127 BY 5.77.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 17.86 BY 3.65.

DEFINE VARIABLE SELECT-FlgEst AS CHARACTER INITIAL "Todos" 
     VIEW-AS SELECTION-LIST MULTIPLE 
     LIST-ITEM-PAIRS "Todos","Todos",
                     "Pendiente","P",
                     "En Proceso","PP",
                     "Atendida Total","C",
                     "Cerrada Manualmente","X" 
     SIZE 20 BY 2.88 TOOLTIP "Selecciona Estados" NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      PEDIDO, 
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacCPedi.CodDiv COLUMN-LABEL "Origen" FORMAT "x(5)":U
      PEDIDO.Libre_c01 COLUMN-LABEL "Lista**" FORMAT "x(5)":U
      FacCPedi.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U WIDTH 9.43
      FacCPedi.CodAlm COLUMN-LABEL "PDD" FORMAT "x(3)":U
      FacCPedi.FchPed COLUMN-LABEL "Emision" FORMAT "99/99/9999":U
      FacCPedi.fchven COLUMN-LABEL "Vencimiento" FORMAT "99/99/9999":U
      FacCPedi.FchEnt COLUMN-LABEL "Fch Entrega" FORMAT "99/99/9999":U
      PEDIDO.NCmpbnte COLUMN-LABEL "O/D" FORMAT "X(9)":U WIDTH 9.14
      FacCPedi.CodCli COLUMN-LABEL "Cliente" FORMAT "x(11)":U WIDTH 9.86
      FacCPedi.NomCli COLUMN-LABEL "Nombre o Razon Social" FORMAT "x(100)":U
      FacCPedi.CodVen COLUMN-LABEL "Vend" FORMAT "x(5)":U
      FacCPedi.ImpTot COLUMN-LABEL "Importe" FORMAT "->>,>>>,>>9.99":U
      PEDIDO.Libre_c02 COLUMN-LABEL "Estado" FORMAT "x(20)":U
      PEDIDO.Libre_d01 COLUMN-LABEL "% Avance" FORMAT "->,>>9.99":U
      PEDIDO.AcuBon[2] COLUMN-LABEL "Total de Items" FORMAT ">,>>9":U
      PEDIDO.AcuBon[3] COLUMN-LABEL "Total Peso Kg." FORMAT ">>>,>>9.99":U
      PEDIDO.AcuBon[4] COLUMN-LABEL "Import. Atendido" FORMAT "->>>>>,>>9.99":U
      PEDIDO.AcuBon[5] COLUMN-LABEL "Import. por Atender" FORMAT "->>>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 144 BY 6.15
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-CodDiv AT ROW 1.19 COL 15 COLON-ALIGNED WIDGET-ID 74
     BUTTON-Division AT ROW 1.19 COL 80 WIDGET-ID 76
     BUTTON-Excel AT ROW 1.38 COL 134 WIDGET-ID 52
     BUTTON-18 AT ROW 1.65 COL 110 WIDGET-ID 62
     SELECT-FlgEst AT ROW 1.77 COL 86 NO-LABEL WIDGET-ID 82
     x-Lista AT ROW 1.96 COL 15 COLON-ALIGNED WIDGET-ID 78
     BUTTON-Lista AT ROW 1.96 COL 80 WIDGET-ID 80
     FILL-IN-FchPed-1 AT ROW 2.73 COL 15 COLON-ALIGNED WIDGET-ID 26
     FILL-IN-FchPed-2 AT ROW 2.73 COL 39 COLON-ALIGNED WIDGET-ID 28
     BUTTON-1 AT ROW 2.77 COL 110 WIDGET-ID 50
     RADIO-SET-Excel AT ROW 2.92 COL 129 NO-LABEL WIDGET-ID 54
     FILL-IN-FchEnt-1 AT ROW 3.5 COL 15 COLON-ALIGNED WIDGET-ID 58
     FILL-IN-FchEnt-2 AT ROW 3.5 COL 39 COLON-ALIGNED WIDGET-ID 60
     x-Almacenes AT ROW 4.27 COL 15 COLON-ALIGNED WIDGET-ID 86
     BUTTON-Almacenes AT ROW 4.27 COL 80 WIDGET-ID 88
     FILL-IN-CodVen AT ROW 5.04 COL 15 COLON-ALIGNED WIDGET-ID 42
     FILL-IN-NomVen AT ROW 5.04 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     FILL-IN-CodCli AT ROW 5.81 COL 15 COLON-ALIGNED WIDGET-ID 44
     FILL-IN-NomCli AT ROW 5.81 COL 50 COLON-ALIGNED WIDGET-ID 48
     br_table AT ROW 6.77 COL 1
     "Estado:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 1.19 COL 86 WIDGET-ID 84
     RECT-19 AT ROW 1 COL 1 WIDGET-ID 70
     RECT-20 AT ROW 1 COL 128 WIDGET-ID 72
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
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: DETALLE B "?" ? INTEGRAL FacDPedi
      TABLE: ORDENES B "?" ? INTEGRAL FacCPedi
      TABLE: PEDIDO T "SHARED" ? INTEGRAL FacCPedi
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
         HEIGHT             = 12.08
         WIDTH              = 144.86.
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
/* BROWSE-TAB br_table FILL-IN-NomCli F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 3
       br_table:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-Almacenes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-CodDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-Lista IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.PEDIDO,INTEGRAL.FacCPedi OF Temp-Tables.PEDIDO"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _Where[1]         = "(SELECT-FlgEst BEGINS ""Todos"" OR LOOKUP(PEDIDO.FlgEst, SELECT-FlgEst) > 0)"
     _FldNameList[1]   > INTEGRAL.FacCPedi.CodDiv
"FacCPedi.CodDiv" "Origen" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.PEDIDO.Libre_c01
"PEDIDO.Libre_c01" "Lista**" "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.CodAlm
"FacCPedi.CodAlm" "PDD" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" "Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacCPedi.fchven
"FacCPedi.fchven" "Vencimiento" "99/99/9999" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.FacCPedi.FchEnt
"FacCPedi.FchEnt" "Fch Entrega" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.PEDIDO.NCmpbnte
"PEDIDO.NCmpbnte" "O/D" ? "character" ? ? ? ? ? ? no ? no no "9.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.FacCPedi.CodCli
"FacCPedi.CodCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" "Nombre o Razon Social" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.FacCPedi.CodVen
"FacCPedi.CodVen" "Vend" "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.FacCPedi.ImpTot
"FacCPedi.ImpTot" "Importe" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.PEDIDO.Libre_c02
"PEDIDO.Libre_c02" "Estado" "x(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.PEDIDO.Libre_d01
"PEDIDO.Libre_d01" "% Avance" "->,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.PEDIDO.AcuBon[2]
"PEDIDO.AcuBon[2]" "Total de Items" ">,>>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.PEDIDO.AcuBon[3]
"PEDIDO.AcuBon[3]" "Total Peso Kg." ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.PEDIDO.AcuBon[4]
"PEDIDO.AcuBon[4]" "Import. Atendido" "->>>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.PEDIDO.AcuBon[5]
"PEDIDO.AcuBon[5]" "Import. por Atender" "->>>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
      WHEN "CodAlm" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'CodAlm').
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
          x-CodDiv = 'Todas'
          x-Lista  = 'Todas'
          FILL-IN-FchPed-1 = TODAY - DAY(TODAY) + 1
          FILL-IN-FchPed-2 = TODAY
          FILL-IN-FchEnt-1 = ?
          FILL-IN-FchEnt-2 = ?
          SELECT-FlgEst = 'Todos'

          FILL-IN-CodCli = ''
          FILL-IN-CodVen = ''
          FILL-IN-NomCli = ''

          FILL-IN-NomVen = ''
          /*FILL-IN-NroPed = ''*/
          .
      DISPLAY
          x-CodDiv
          x-Lista
          FILL-IN-FchPed-1
          FILL-IN-FchPed-2
          FILL-IN-FchEnt-1
          FILL-IN-FchEnt-2
          SELECT-FlgEst

          FILL-IN-CodCli 
          FILL-IN-CodVen 
          FILL-IN-NomCli 

          FILL-IN-NomVen 
          /*FILL-IN-NroPed */
          
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


      EMPTY TEMP-TABLE PEDIDO.
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
      /*FILL-IN-NroPed*/ RADIO-SET-Excel SELECT-FlgEst x-CodDiv
      x-Lista.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporal.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  RUN Procesa-Handle IN lh_handle ('Open-Query':U).
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Almacenes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Almacenes B-table-Win
ON CHOOSE OF BUTTON-Almacenes IN FRAME F-Main /* ... */
DO:
    ASSIGN x-Almacenes.
    RUN alm/d-almacen (INPUT-OUTPUT x-Almacenes).
    DISPLAY x-Almacenes WITH FRAME {&FRAME-NAME}.
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


&Scoped-define SELF-NAME BUTTON-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Excel B-table-Win
ON CHOOSE OF BUTTON-Excel IN FRAME F-Main /* Button 7 */
DO:
  ASSIGN RADIO-SET-Excel.
  SESSION:SET-WAIT-STATE('GENERAL').
  CASE RADIO-SET-Excel:
      WHEN 1 THEN RUN Solo-cabecera.
      WHEN 2 THEN RUN Excel-cabecera-detalle.
  END CASE.
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Lista
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Lista B-table-Win
ON CHOOSE OF BUTTON-Lista IN FRAME F-Main /* ... */
DO:
    ASSIGN x-Lista.
    RUN gn/d-filtro-divisiones (INPUT-OUTPUT x-Lista, "SELECCIONE LAS LISTAS").
    DISPLAY x-Lista WITH FRAME {&FRAME-NAME}.
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
/*     RUN dispatch IN THIS-PROCEDURE ('open-query':U).  */
/*     RUN Procesa-Handle IN lh_handle ('Open-Query':U). */
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


&Scoped-define SELF-NAME SELECT-FlgEst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SELECT-FlgEst B-table-Win
ON VALUE-CHANGED OF SELECT-FlgEst IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
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
    WHEN 'ImpTot':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.ImpTot DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'NroPed':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.NroPed DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'LugEnt2':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.CodAlm BY FacCPedi.NroPed DESCENDING
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
      &Scope SORTBY-PHRASE BY PEDIDO.Libre_d01 DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Libre_c02':U THEN DO:
      &Scope SORTBY-PHRASE BY PEDIDO.Libre_c02 DESCENDING
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

EMPTY TEMP-TABLE PEDIDO.

PRINCIPAL:
FOR EACH Faccpedi NO-LOCK WHERE {&Condicion}, 
    FIRST COTIZACION NO-LOCK WHERE COTIZACION.codcia = Faccpedi.codcia
    AND COTIZACION.coddoc = Faccpedi.codref
    AND COTIZACION.nroped = Faccpedi.nroref
    AND (x-Lista = '' OR LOOKUP(COTIZACION.libre_c01, x-Lista) > 0 ) :
    CREATE PEDIDO.
    BUFFER-COPY Faccpedi TO PEDIDO.
    ASSIGN
        PEDIDO.Libre_c01 = COTIZACION.Libre_c01
        PEDIDO.Libre_d01 = fPorcAvance()
        PEDIDO.AcuBon[2] = fTotItems()
        PEDIDO.AcuBon[3] = fTotPeso()
        PEDIDO.AcuBon[4] = fImpAtendido()
        PEDIDO.AcuBon[5] = fImpxAtender().
    /* Controles Finales */
    IF LOOKUP(PEDIDO.FlgEst, "G,X,W,WX,WL") > 0 THEN PEDIDO.FlgEst = "P".
    IF LOOKUP(PEDIDO.FlgEst, "E,S") > 0 THEN PEDIDO.FlgEst = "X".
    IF PEDIDO.FlgEst = "P" 
        AND CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE Facdpedi.canate > 0 NO-LOCK) 
        THEN PEDIDO.FlgEst = "PP".
    IF PEDIDO.FlgEst = "C"
        AND PEDIDO.Libre_d01 < 100 
        THEN PEDIDO.FlgEst = "PP".
    ASSIGN PEDIDO.Libre_c02 = _FlgEst(PEDIDO.FlgEst).
    FIND FIRST ORDENES WHERE ORDENES.codcia = Faccpedi.codcia
        AND ORDENES.coddoc = 'O/D'
        AND ORDENES.codref = Faccpedi.coddoc
        AND ORDENES.nroref = Faccpedi.nroped
        AND ORDENES.flgest <> 'A'
        NO-LOCK NO-ERROR.
    IF AVAILABLE ORDENES THEN PEDIDO.NCmpbnte = ORDENES.nroped.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-cabecera-detalle B-table-Win 
PROCEDURE Excel-cabecera-detalle :
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
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.

DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 1.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).
chWorkSheet:Range("A1"):VALUE = "Div. Origen".
chWorkSheet:COLUMNS("A"):NumberFormat = "@".
chWorkSheet:Range("B1"):VALUE = "Lista".
chWorkSheet:COLUMNS("B"):NumberFormat = "@".
chWorkSheet:Range("C1"):VALUE = "Pedido".
chWorkSheet:COLUMNS("C"):NumberFormat = "@".
chWorkSheet:Range("D1"):VALUE = "Cotizacion".
chWorkSheet:COLUMNS("D"):NumberFormat = "@".
chWorkSheet:Range("E1"):VALUE = "Emisión".
chWorkSheet:COLUMNS("E"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("F1"):VALUE = "Vencimiento".
chWorkSheet:COLUMNS("F"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("G1"):VALUE = "Fecha Entrega".
chWorkSheet:COLUMNS("G"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("H1"):VALUE = "Cliente".
chWorkSheet:COLUMNS("H"):NumberFormat = "@".
chWorkSheet:Range("I1"):VALUE = "Nombre o Razón Social".
chWorkSheet:Range("J1"):VALUE = "Vendedor".
chWorkSheet:COLUMNS("J"):NumberFormat = "@".
chWorkSheet:Range("K1"):VALUE = "Nombre".
chWorkSheet:Range("L1"):VALUE = "Forma de Pago".
chWorkSheet:COLUMNS("L"):NumberFormat = "@".
chWorkSheet:Range("M1"):VALUE = "Descripcion".
chWorkSheet:Range("N1"):VALUE = "Importe".
chWorkSheet:Range("O1"):VALUE = "Estado".
chWorkSheet:Range("P1"):VALUE = "% Avance".
chWorkSheet:Range("Q1"):VALUE = "PDD".
chWorkSheet:COLUMNS("Q"):NumberFormat = "@".
chWorkSheet:Range("R1"):VALUE = "Articulo".
chWorkSheet:COLUMNS("R"):NumberFormat = "@".
chWorkSheet:Range("S1"):VALUE = "Descripción".
chWorkSheet:Range("T1"):VALUE = "Marca".
chWorkSheet:Range("U1"):VALUE = "Unidad".
chWorkSheet:Range("V1"):VALUE = "Cantidad Aprobada".
chWorkSheet:Range("W1"):VALUE = "Cantidad Atendida".
chWorkSheet:Range("X1"):VALUE = "Importe".

DEF VAR x-FmaPgo AS CHAR.
DEF VAR x-CodVen AS CHAR.
GET FIRST {&browse-name}.
REPEAT WHILE AVAILABLE PEDIDO:
    FOR EACH DETALLE OF Faccpedi NO-LOCK,FIRST Almmmatg OF DETALLE NO-LOCK :
        x-FmaPgo = ''.
        FIND gn-ConVt WHERE gn-ConVt.Codig = Faccpedi.fmapgo NO-LOCK NO-ERROR.
        IF AVAILABLE gn-ConVt THEN x-FmaPgo = gn-ConVt.Nombr.
        x-CodVen = ''.
        FIND gn-ven WHERE gn-ven.CodCia = Faccpedi.codcia
            AND gn-ven.CodVen = Faccpedi.codven NO-LOCK NO-ERROR. 
        IF AVAILABLE gn-ven THEN x-CodVen = gn-ven.NomVen.
        t-Row = t-Row + 1.
        t-Column = 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.coddiv.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = PEDIDO.libre_c01.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.nroped.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.nroref.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.fchped.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.fchven.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = PEDIDO.fchent  /*Faccpedi.fchent*/.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.codcli.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.nomcli.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.codven.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = x-CodVen.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.fmapgo.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = x-FmaPgo.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.imptot.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = PEDIDO.Libre_C02.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = PEDIDO.Libre_D01.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.CodAlm.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.CodMat.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.DesMat.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.DesMar.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.UndVta.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.CanPed.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.CanAte.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.ImpLin.
    END.
    GET NEXT {&browse-name}.
END.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).
RUN Procesa-Handle IN lh_handle ('Open-Query':U).

/*
IF NOT AVAILABLE Faccpedi THEN RETURN.

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.

DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 1.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).
chWorkSheet:Range("A1"):VALUE = "Div. Origen".
chWorkSheet:COLUMNS("A"):NumberFormat = "@".
chWorkSheet:Range("B1"):VALUE = "Lista".
chWorkSheet:COLUMNS("B"):NumberFormat = "@".

chWorkSheet:Range("C1"):VALUE = "Número".
chWorkSheet:COLUMNS("C"):NumberFormat = "@".
chWorkSheet:Range("D1"):VALUE = "Emisión".
chWorkSheet:COLUMNS("D"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("E1"):VALUE = "Vencimiento".
chWorkSheet:COLUMNS("E"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("F1"):VALUE = "Fecha Entrega".
chWorkSheet:COLUMNS("F"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("G1"):VALUE = "Nombre o Razón Social".
chWorkSheet:Range("H1"):VALUE = "Vendedor".
chWorkSheet:Range("I1"):VALUE = "Importe".
chWorkSheet:Range("J1"):VALUE = "Estado".
chWorkSheet:Range("K1"):VALUE = "% Avance".
chWorkSheet:Range("L1"):VALUE = "Total de Items".
chWorkSheet:Range("M1"):VALUE = "Total Peso Kg.".
chWorkSheet:Range("N1"):VALUE = "Import. Atendido".
chWorkSheet:Range("O1"):VALUE = "Import. por Atender".
chWorkSheet:Range("P1"):VALUE = "No".
chWorkSheet:Range("Q1"):VALUE = "Articulo".
chWorkSheet:COLUMNS("Q"):NumberFormat = "@".
chWorkSheet:Range("R1"):VALUE = "Descripción".
chWorkSheet:Range("S1"):VALUE = "Marca".
chWorkSheet:Range("T1"):VALUE = "Unidad".
chWorkSheet:Range("U1"):VALUE = "Cantidad Aprobada".
chWorkSheet:Range("V1"):VALUE = "Cantidad Atendida".
chWorkSheet:Range("W1"):VALUE = "Precio Unitario".
chWorkSheet:Range("X1"):VALUE = "% Dscto Manual".
chWorkSheet:Range("Y1"):VALUE = "% Dscto Evento".
chWorkSheet:Range("Z1"):VALUE = "% Dscto Vol/Prom".
chWorkSheet:Range("AA1"):VALUE = "Importe".
chWorkSheet:Range("AB1"):VALUE = "PDD".

GET FIRST {&browse-name}.
REPEAT WHILE AVAILABLE PEDIDO:
    FOR EACH DETALLE OF Faccpedi NO-LOCK,FIRST Almmmatg OF DETALLE NO-LOCK :
        t-Column = 1.
        t-Row = t-Row + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.coddiv.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.libre_c01.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.nroped.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.fchped.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.fchven.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.fchent.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.nomcli.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.codven.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.imptot.
        t-column = t-column + 1.
        /*chWorkSheet:Cells(t-Row, t-Column) = _FlgEst().*/
        chWorkSheet:Cells(t-Row, t-Column) = PEDIDO.Libre_C02.
        t-column = t-column + 1.
        /*chWorkSheet:Cells(t-Row, t-Column) = fPorcAvance().*/
        chWorkSheet:Cells(t-Row, t-Column) = PEDIDO.Libre_D01.
        t-column = t-column + 1.
        /*chWorkSheet:Cells(t-Row, t-Column) = fTotItems().*/
        chWorkSheet:Cells(t-Row, t-Column) = PEDIDO.AcuBon[2].
        t-column = t-column + 1.
        /*chWorkSheet:Cells(t-Row, t-Column) = fTotPeso().*/
        chWorkSheet:Cells(t-Row, t-Column) = PEDIDO.AcuBon[3].
        t-column = t-column + 1.
        /*chWorkSheet:Cells(t-Row, t-Column) = fImpAtendido().*/
        chWorkSheet:Cells(t-Row, t-Column) = PEDIDO.AcuBon[4].
        t-column = t-column + 1.
        /*chWorkSheet:Cells(t-Row, t-Column) = fImpxAtender().*/
        chWorkSheet:Cells(t-Row, t-Column) = PEDIDO.AcuBon[5].
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.nroitm.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.codmat.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.desmat.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.desmar.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.undvta.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.canped.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.canate.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.preuni.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.por_dscto[1].
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.por_dscto[2].
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.por_dscto[3].
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.implin.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = faccpedi.lugent2.
    END.
    GET NEXT {&browse-name}.
END.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).
RUN Procesa-Handle IN lh_handle ('Open-Query':U).
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-solo-cabecera B-table-Win 
PROCEDURE Excel-solo-cabecera :
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
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.

DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 1.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).
chWorkSheet:Range("A1"):VALUE = "Div. Origen".
chWorkSheet:COLUMNS("A"):NumberFormat = "@".
chWorkSheet:Range("B1"):VALUE = "Lista".
chWorkSheet:COLUMNS("B"):NumberFormat = "@".

chWorkSheet:Range("C1"):VALUE = "Número".
chWorkSheet:COLUMNS("C"):NumberFormat = "@".
chWorkSheet:Range("D1"):VALUE = "Emisión".
chWorkSheet:COLUMNS("D"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("E1"):VALUE = "Vencimiento".
chWorkSheet:COLUMNS("E"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("F1"):VALUE = "Fecha Entrega".
chWorkSheet:COLUMNS("F"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("G1"):VALUE = "Nombre o Razón Social".
chWorkSheet:Range("H1"):VALUE = "Vendedor".
chWorkSheet:Range("I1"):VALUE = "Importe".
chWorkSheet:Range("J1"):VALUE = "Estado".
chWorkSheet:Range("K1"):VALUE = "% Avance".
chWorkSheet:Range("L1"):VALUE = "Total de Items".
chWorkSheet:Range("M1"):VALUE = "Total Peso Kg.".
chWorkSheet:Range("N1"):VALUE = "Import. Atendido".
chWorkSheet:Range("O1"):VALUE = "Import. por Atender".
chWorkSheet:Range("P1"):VALUE = "PDD".

GET FIRST {&browse-name}.
REPEAT WHILE AVAILABLE PEDIDO:
    t-Row = t-Row + 1.
    t-Column = 1.
    chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.coddiv.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = PEDIDO.libre_c01.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.nroped.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.fchped.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.fchven.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.fchent.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.nomcli.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.codven.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.imptot.
    t-column = t-column + 1.
    /*chWorkSheet:Cells(t-Row, t-Column) = _FlgEst().*/
    chWorkSheet:Cells(t-Row, t-Column) = PEDIDO.Libre_C02.
    t-column = t-column + 1.
    /*chWorkSheet:Cells(t-Row, t-Column) = fPorcAvance().*/
    chWorkSheet:Cells(t-Row, t-Column) = PEDIDO.Libre_D01.
    t-column = t-column + 1.
    /*chWorkSheet:Cells(t-Row, t-Column) = fTotItems().*/
    chWorkSheet:Cells(t-Row, t-Column) = PEDIDO.AcuBon[2].
    t-column = t-column + 1.
    /*chWorkSheet:Cells(t-Row, t-Column) = fTotPeso().*/
    chWorkSheet:Cells(t-Row, t-Column) = PEDIDO.AcuBon[3].
    t-column = t-column + 1.
    /*chWorkSheet:Cells(t-Row, t-Column) = fImpAtendido().*/
    chWorkSheet:Cells(t-Row, t-Column) = PEDIDO.AcuBon[4].
    t-column = t-column + 1.
    /*chWorkSheet:Cells(t-Row, t-Column) = fImpxAtender().*/
    chWorkSheet:Cells(t-Row, t-Column) = PEDIDO.AcuBon[5].
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.CodAlm.

    GET NEXT {&browse-name}.
END.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).
RUN Procesa-Handle IN lh_handle ('Open-Query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR pRowid AS ROWID.
  pRowid = ROWID(PEDIDO).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
/*   ASSIGN                                                                             */
/*       cotizacion.lugent2 = cotizacion.lugent2:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}. */
/*   FIND FIRST tt-faccpedi OF cotizacion EXCLUSIVE NO-ERROR.                           */
/*   IF AVAILABLE tt-faccpedi THEN ASSIGN tt-faccpedi.lugent2 = cotizacion.lugent2.     */
/*   RELEASE tt-faccpedi.                                                               */
/*   RUN dispatch IN THIS-PROCEDURE ('display-fields':U).                               */
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  REPOSITION {&browse-name} TO ROWID pRowid.
  
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
  ASSIGN
      FILL-IN-FchPed-1 = TODAY - DAY(TODAY) + 1
      FILL-IN-FchPed-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      IF s-Tipo = 'NO' THEN DO:
          x-CodDiv = s-CodDiv.
          x-CodDiv:SCREEN-VALUE = s-CodDiv.
          BUTTON-Division:SENSITIVE = NO.
      END.
  END.

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
  {src/adm/template/snd-list.i "PEDIDO"}
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
    REPEAT WHILE AVAILABLE PEDIDO:
        FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = PEDIDO.codcli
            NO-LOCK NO-ERROR.
        CREATE T-Detalle.
        BUFFER-COPY Faccpedi
            TO T-Detalle
            ASSIGN
            T-Detalle.Libre_C01 = PEDIDO.Libre_C01
            T-Detalle.Estado = PEDIDO.Libre_C02
            T-Detalle.Avance = PEDIDO.Libre_D01
            T-Detalle.Cuota = PEDIDO.Libre_D02
            T-Detalle.Items = PEDIDO.AcuBon[2]
            T-Detalle.Items = PEDIDO.ImpFle
            T-Detalle.Peso = PEDIDO.ImpIsc
            T-Detalle.Atendido = PEDIDO.AcuBon[4]
            T-Detalle.Pendiente = PEDIDO.AcuBon[5]
            T-DEtalle.NroOrd = PEDIDO.NCmpbnte.
        IF AVAILABLE gn-clie THEN DO:
            FIND TabProvi WHERE TabProvi.CodDepto = gn-clie.CodDept
                AND TabProvi.CodProvi = gn-clie.codprov
                NO-LOCK NO-ERROR.
            FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept
                AND Tabdistr.Codprovi = gn-clie.codprov
                AND Tabdistr.Coddistr = gn-clie.coddist
                NO-LOCK NO-ERROR.
            IF T-Detalle.LugEnt = '' THEN T-Detalle.LugEnt = gn-clie.dirent.
            IF AVAILABLE Tabdistr THEN T-Detalle.DistEnt = TabDistr.NomDistr.
            IF AVAILABLE Tabprovi THEN T-Detalle.ProvEnt = TabProvi.NomProvi.
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
    lOptions = lOptions + "coddiv,libre_c01,nroped,fchped,fchven,fchent,nroord,nomcli," +
        "codven,imptot,estado,avance,items,peso,atendido,pendiente,codalm" +
        ",lugent,distent,provent".
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

  DEF BUFFER ORDENES  FOR Faccpedi.
  DEF BUFFER FACTURAS FOR Ccbcdocu.
  DEF BUFFER CREDITOS FOR Ccbcdocu.

  /* 17/12/2014 Probemos por cantidades */
  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
      xImpPed = xImpPed + Facdpedi.canped.
  END.
  FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
      AND ccbcdocu.fchdoc >= Faccpedi.fchped
      AND ccbcdocu.codped = Faccpedi.coddoc
      AND ccbcdocu.nroped = Faccpedi.nroped
      AND LOOKUP(ccbcdocu.coddoc, 'FAC,BOL') > 0
      AND ccbcdocu.flgest <> 'A',
      EACH ccbddocu OF ccbcdocu NO-LOCK:
      ASSIGN xImpAte = xImpAte + ccbddocu.candes.
  END.
/*   FOR EACH ORDENES NO-LOCK WHERE ORDENES.codcia = s-codcia        */
/*       AND ORDENES.coddoc = 'O/D'                                  */
/*       AND ORDENES.codref = Faccpedi.coddoc                        */
/*       AND ORDENES.nroref = Faccpedi.nroped                        */
/*       AND ORDENES.fchped >= Faccpedi.fchped                       */
/*       AND ORDENES.flgest = 'P',                                   */
/*       EACH Facdpedi OF ORDENES NO-LOCK WHERE Facdpedi.canate = 0: */
/*       ASSIGN xImpAte = xImpAte + facdpedi.canped.                 */
/*   END.                                                            */

  xPorcAvance = xImpAte / xImpPed * 100.
  IF xPorcAvance < 0 THEN xPorcAvance = 0.
  IF xPorcAvance > 100 THEN xPorcAvance = 100.

  /* 17/12/2014 Bloqueado por importes 
  FOR EACH ORDENES NO-LOCK WHERE ORDENES.codcia = Faccpedi.codcia
      AND ORDENES.coddoc = 'PED'
      AND ORDENES.codref = Faccpedi.coddoc
      AND ORDENES.nroref = Faccpedi.nroped
      AND ORDENES.fchped >= Faccpedi.fchped
      AND ORDENES.flgest <> "A",
      EACH FACTURAS NO-LOCK WHERE FACTURAS.codcia = Faccpedi.codcia
      AND LOOKUP(FACTURAS.coddoc, 'FAC,BOL') > 0
      AND FACTURAS.flgest <> "A"
      AND FACTURAS.codped = ORDENES.coddoc
      AND FACTURAS.nroped = ORDENES.nroped
      AND FACTURAS.fchdoc >= ORDENES.fchped:
      ASSIGN xImpAte = xImpAte + FACTURAS.ImpTot.
      FOR EACH CREDITOS NO-LOCK WHERE CREDITOS.codcia = FACTURAS.codcia
          AND CREDITOS.coddoc = "N/C"
          AND CREDITOS.codref = FACTURAS.coddoc
          AND CREDITOS.nroref = FACTURAS.nrodoc
          AND CREDITOS.cndcre = "D"
          AND CREDITOS.flgest <> "A":
          ASSIGN xImpAte = xImpAte - CREDITOS.ImpTot.
      END.
  END.
  xPorcAvance = xImpAte / Faccpedi.ImpTot * 100.
  IF xPorcAvance < 0 THEN xPorcAvance = 0.
  IF xPorcAvance > 100 THEN xPorcAvance = 100.
  */

  /*
  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
      ASSIGN
          xImpPed = xImpPed + Facdpedi.ImpLin
          xImpAte = xImpAte + (Facdpedi.ImpLin / facdpedi.CanPed) * Facdpedi.CanAte
          xPorcAvance = xImpAte / xImpPed * 100.
  END.
  */

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

CASE pFlgEst:
    WHEN 'P' THEN pEstado = "PENDIENTE".
    WHEN 'PP' THEN pEstado = "EN PROCESO".
    WHEN 'V' THEN pEstado = "VENCIDA".
    WHEN 'C' THEN pEstado = "ATENDIDA TOTAL".
    WHEN 'X' THEN pEstado = "CERRADA MANUALMENTE".
    OTHERWISE pEstado = pFlgEst.
END CASE.

RETURN pEstado.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

