&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-MATE FOR Almmmate.
DEFINE BUFFER B-MATE2 FOR Almmmate.
DEFINE BUFFER B-MATG FOR Almmmatg.
DEFINE SHARED TEMP-TABLE T-DREPO LIKE RepAutomDetail.
DEFINE TEMP-TABLE T-MATG NO-UNDO LIKE Almmmatg.



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

DEF NEW SHARED VAR s-CodMat AS CHAR.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-nivel-acceso AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR lh_handle AS HANDLE.
DEF SHARED VAR s-user-id AS CHAR.

DEF SHARED VAR pCodDiv AS CHAR.
DEF SHARED VAR s-coddoc AS CHAR INIT 'R/A'.
DEF SHARED VAR s-tipmov AS CHAR INIT 'A'.

DEF BUFFER bt-drepo FOR t-drepo.

DEF VAR x-StockComprometido AS DEC NO-UNDO.
DEF VAR x-StkDisponible AS DEC NO-UNDO.

DEF VAR x-Peso AS DEC NO-UNDO.
DEF VAR x-Volumen AS DEC NO-UNDO.
DEF VAR x-PorcReposicion AS DEC NO-UNDO.
DEF VAR x-StkMaxSeg AS DEC NO-UNDO.

DEF VAR x-SolStkDis AS DEC NO-UNDO.
DEF VAR x-SolStkMax AS DEC NO-UNDO.
DEF VAR x-SolStkTra AS DEC NO-UNDO.
DEF VAR x-SolCmpTra AS DEC NO-UNDO.
DEF VAR x-DesStkDis AS DEC NO-UNDO.
DEF VAR x-DesStkMax AS DEC NO-UNDO.
DEF VAR x-SaldoGrupo AS DEC NO-UNDO.
DEF VAR x-SaldoTienda AS DEC NO-UNDO.
DEF VAR x-TipoCalculo AS CHAR NO-UNDO.
DEF VAR x-Sector AS CHAR NO-UNDO.
DEF VAR x-Ubicacion AS CHAR NO-UNDO.
DEF VAR x-DesMat AS CHAR NO-UNDO.

DEF VAR pOk AS LOG NO-UNDO.
RUN gn/fAlmPrincipal (INPUT s-CodAlm, OUTPUT pOk).
IF pOk = YES THEN x-TipoCalculo = "GRUPO".
ELSE x-TipoCalculo = "TIENDA".

DEF VAR x-ClfGral AS CHAR NO-UNDO.
DEF VAR x-ClfMayo AS CHAR NO-UNDO.
DEF VAR x-ClfUtil AS CHAR NO-UNDO.

&SCOPED-DEFINE Condicion ( (COMBO-BOX-ClfGral = 'Todas' OR T-DREPO.ClfGral = COMBO-BOX-ClfGral) AND ~
(COMBO-BOX-ClfMayo = 'Todas' OR T-DREPO.ClfMayo = COMBO-BOX-ClfMayo) AND ~
(COMBO-BOX-ClfUtil = 'Todas' OR T-DREPO.ClfUtil = COMBO-BOX-ClfUtil) AND ~
(COMBO-BOX-Almacen = 'Todos' OR T-DREPO.AlmPed = COMBO-BOX-Almacen) AND ~
(COMBO-BOX-Sector = 'Todos'  OR T-DREPO.CodZona = COMBO-BOX-Sector) AND ~
(COMBO-BOX-Marcas = 'Todas' OR LOOKUP(T-DREPO.DesMar,COMBO-BOX-Marcas) > 0) AND ~
(TRUE <> (FILL-IN-DesMat > '') OR INDEX(T-DREPO.DesMat, FILL-IN-DesMat) > 0 ) )

&SCOPED-DEFINE Condicion2 (COMBO-BOX-Marcas = 'Todas' OR LOOKUP(Almmmatg.DesMar,COMBO-BOX-Marcas) > 0) ~
AND (COMBO-BOX-Lineas = 'Todas' OR LOOKUP(Almmmatg.CodFam,COMBO-BOX-Lineas) > 0) ~
AND (COMBO-BOX-SubLineas = 'Todas' OR LOOKUP(Almmmatg.SubFam,COMBO-BOX-SubLineas) > 0)

&SCOPED-DEFINE CondicionX ( (COMBO-BOX-ClfGral = 'Todas' OR BT-DREPO.ClfGral = COMBO-BOX-ClfGral) AND ~
(COMBO-BOX-ClfMayo = 'Todas' OR BT-DREPO.ClfMayo = COMBO-BOX-ClfMayo) AND ~
(COMBO-BOX-ClfUtil = 'Todas' OR BT-DREPO.ClfUtil = COMBO-BOX-ClfUtil) AND ~
(COMBO-BOX-Almacen = 'Todos' OR BT-DREPO.AlmPed = COMBO-BOX-Almacen) AND ~
(COMBO-BOX-Sector = 'Todos'  OR BT-DREPO.CodZona = COMBO-BOX-Sector)  AND ~
( TRUE <> (FILL-IN-DesMat > '') OR INDEX(BT-DREPO.DesMat, FILL-IN-DesMat) > 0 ) ~
                            )
&SCOPED-DEFINE CondicionX2 (COMBO-BOX-Marcas = 'Todas' OR LOOKUP(Almmmatg.DesMar,COMBO-BOX-Marcas) > 0) ~
AND (COMBO-BOX-Lineas = 'Todas' OR LOOKUP(Almmmatg.CodFam,COMBO-BOX-Lineas) > 0) ~
AND (COMBO-BOX-SubLineas = 'Todas' OR LOOKUP(Almmmatg.SubFam,COMBO-BOX-SubLineas) > 0)

/* Para calcular el stock en tránsito */
DEFINE TEMP-TABLE tmp-tabla
    FIELD t-CodAlm LIKE Almacen.codalm  FORMAT 'x(3)'
    FIELD t-CodDoc LIKE FacDPedi.CodDoc FORMAT "XXX"
    FIELD t-Nroped LIKE FacDPedi.NroPed FORMAT "XXX-XXXXXXXX"
    FIELD t-CodDiv LIKE FacCPedi.CodDiv FORMAT 'x(5)'
    FIELD t-FchPed LIKE FacDPedi.FchPed
    FIELD t-NomCli LIKE FacCPedi.NomCli COLUMN-LABEL "Cliente" FORMAT "x(35)"
    FIELD t-CodMat LIKE FacDPedi.codmat
    FIELD t-Canped LIKE FacDPedi.CanPed.

DEFINE TEMP-TABLE T-GENER NO-UNDO LIKE TabGener.
DEFINE TEMP-TABLE T-MATE-2 NO-UNDO LIKE Almmmate.
DEFINE TEMP-TABLE T-MATE NO-UNDO LIKE Almmmate.

/* Temporal para el Excel */
DEF TEMP-TABLE Detalle
    FIELD NroItm AS INT                                 COLUMN-LABEL 'Item'
    FIELD CodMat LIKE Almmmatg.codmat                   COLUMN-LABEL 'Codigo'
    FIELD DesMat LIKE Almmmatg.desmat FORMAT 'x(100)'   COLUMN-LABEL 'Descripcion'
    FIELD DesMar LIKE Almmmatg.desmar                   COLUMN-LABEL 'Marca'
    FIELD UndStk LIKE Almmmatg.undstk FORMAT 'x(10)'    COLUMN-LABEL 'Unidad'
    FIELD AlmPed LIKE Almacen.codalm                    COLUMN-LABEL 'Almacen Despacho'
    FIELD CanReq AS DEC                                 COLUMN-LABEL 'Cantidad Requerida'
    FIELD CanGen AS DEC                                 COLUMN-LABEL 'Cantidad Generada'
    FIELD SolStkDis AS DEC                              COLUMN-LABEL 'Disponible Solicitante'
    FIELD SolStkMax AS DEC                              COLUMN-LABEL 'Stock Maximo Solicitante'
    FIELD SolStkTra AS DEC                              COLUMN-LABEL 'Transito Solicitante'
    FIELD SolCmpTra AS DEC                              COLUMN-LABEL 'Compras en Transito'
    FIELD PorcReposicion AS DEC                         COLUMN-LABEL '% de Reposicion'
    FIELD DesStkDis AS DEC                              COLUMN-LABEL 'Disponible Despacho'
    FIELD FSDespacho AS DEC                             COLUMN-LABEL 'Faltante/Sobrante Despacho'
    FIELD GrpStkDis AS DEC                              COLUMN-LABEL 'Disponible Grupo'
    FIELD FSGrupo AS DEC                                COLUMN-LABEL 'Faltante/Sobrante Grupo'
    FIELD DesStkMax AS DEC                              COLUMN-LABEL 'Stock Maximo Despacho'
    FIELD EmpReposicion AS DEC                          COLUMN-LABEL 'Empaque Reposicion'
    FIELD EmpMaster AS DEC                              COLUMN-LABEL 'Empaque Master'
    FIELD CtoTotal AS DEC                               COLUMN-LABEL 'Costo de Reposicion'
    FIELD Origen AS CHAR                                COLUMN-LABEL 'Origen'
    FIELD ClfGral AS CHAR                               COLUMN-LABEL 'Clasificacion General'
    FIELD ClfUtil AS CHAR                               COLUMN-LABEL 'Clasificacion Utilex'
    FIELD ClfMayo AS CHAR                               COLUMN-LABEL 'Clasificacion Mayorista'
    FIELD Peso AS DEC                                   COLUMN-LABEL 'Peso en kg'
    FIELD Volumen AS DEC                                COLUMN-LABEL 'Volumen en m3'
    FIELD SolStkAct AS DEC                              COLUMN-LABEL 'Stock Actual'
    FIELD SolStkCom AS DEC                              COLUMN-LABEL 'Stock Reservado'
    FIELD CodFam LIKE Almtfami.codfam                   COLUMN-LABEL 'Linea'
    FIELD DesFam LIKE almtfami.desfam                   COLUMN-LABEL 'Deascripcion'
    FIELD SubFam LIKE Almsfami.subfam                   COLUMN-LABEL 'SubLinea'
    FIELD DesSub LIKE  AlmSFami.dessub                  COLUMN-LABEL 'Descripcion'
    FIELD CodZona AS CHAR                               COLUMN-LABEL 'Sector'
    FIELD CodUbi  AS CHAR                               COLUMN-LABEL 'Ubicacion'
    INDEX llave01 AS PRIMARY NroItm
    .

DEF TEMP-TABLE T-DREPO-2 LIKE T-DREPO.
DEF TEMP-TABLE T-DREPO-3 LIKE T-DREPO.
DEF TEMP-TABLE T-DREPO-4 LIKE T-DREPO.

DEF VAR FLAG-DesMat AS LOG INIT NO NO-UNDO.
DEF VAR FLAG-DesMar AS LOG INIT NO NO-UNDO.
DEF VAR FLAG-UndBas AS LOG INIT NO NO-UNDO.
DEF VAR FLAG-CanReq AS LOG INIT NO NO-UNDO.
DEF VAR SORTBY-General   AS CHAR INIT "" NO-UNDO.
DEF VAR SORTBY-DesMat    AS CHAR INIT "BY T-DREPO.DesMat" NO-UNDO.
DEF VAR SORTORDER-DesMat AS INT  INIT 0  NO-UNDO.
DEF VAR SORTBY-DesMar    AS CHAR INIT "BY T-DREPO.DesMar" NO-UNDO.
DEF VAR SORTORDER-DesMar AS INT  INIT 0  NO-UNDO.
DEF VAR SORTBY-UndBas    AS CHAR INIT "BY T-DREPO.UndBas" NO-UNDO.
DEF VAR SORTORDER-UndBas AS INT  INIT 0  NO-UNDO.
DEF VAR SORTBY-CanReq    AS CHAR INIT "BY T-DREPO.CanReq" NO-UNDO.
DEF VAR SORTORDER-CanReq AS INT  INIT 0  NO-UNDO.

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
&Scoped-define INTERNAL-TABLES T-DREPO Almmmatg Almmmate Almtfami AlmSFami

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-DREPO.Item T-DREPO.CodMat ~
T-DREPO.DesMat T-DREPO.DesMar T-DREPO.UndBas T-DREPO.AlmPed T-DREPO.CanReq ~
T-DREPO.CanGen T-DREPO.SolStkDis T-DREPO.SolStkMax T-DREPO.SolStkTra ~
T-DREPO.SolCmpTra T-DREPO.DesStkDis T-DREPO.DesSaldo T-DREPO.GrpStkDis ~
T-DREPO.FSGrupo T-DREPO.DesStkMax Almmmate.StkMax Almmmatg.CanEmp ~
T-DREPO.CanGen * (IF Almmmatg.MonVta = 2 THEN Almmmatg.CtoTot * Almmmatg.TpoCmb ELSE Almmmatg.CToTot) @ Almmmatg.CtoTot ~
T-DREPO.Origen T-DREPO.ClfGral T-DREPO.ClfMayo T-DREPO.ClfUtil ~
(T-DREPO.CanGen * Almmmatg.Pesmat ) @ x-Peso ~
(T-DREPO.CanGen * Almmmatg.Libre_d02 / 1000000) @ x-Volumen Almmmate.StkAct ~
T-DREPO.SolStkCom T-DREPO.PorcReposicion Almmmatg.CodFam Almtfami.desfam ~
Almmmatg.SubFam AlmSFami.dessub T-DREPO.CodZona T-DREPO.CodUbi 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table T-DREPO.CodMat ~
T-DREPO.AlmPed T-DREPO.CanReq 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table T-DREPO
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table T-DREPO
&Scoped-define QUERY-STRING-br_table FOR EACH T-DREPO WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST Almmmatg OF T-DREPO NO-LOCK, ~
      FIRST Almmmate OF Almmmatg ~
      WHERE Almmmate.CodAlm = s-CodAlm NO-LOCK, ~
      FIRST Almtfami OF Almmmatg NO-LOCK, ~
      FIRST AlmSFami OF Almmmatg NO-LOCK ~
    BY T-DREPO.Item
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-DREPO WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST Almmmatg OF T-DREPO NO-LOCK, ~
      FIRST Almmmate OF Almmmatg ~
      WHERE Almmmate.CodAlm = s-CodAlm NO-LOCK, ~
      FIRST Almtfami OF Almmmatg NO-LOCK, ~
      FIRST AlmSFami OF Almmmatg NO-LOCK ~
    BY T-DREPO.Item.
&Scoped-define TABLES-IN-QUERY-br_table T-DREPO Almmmatg Almmmate Almtfami ~
AlmSFami
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-DREPO
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg
&Scoped-define THIRD-TABLE-IN-QUERY-br_table Almmmate
&Scoped-define FOURTH-TABLE-IN-QUERY-br_table Almtfami
&Scoped-define FIFTH-TABLE-IN-QUERY-br_table AlmSFami


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Almacen COMBO-BOX-Marcas ~
COMBO-BOX-Lineas COMBO-BOX-SubLineas COMBO-BOX-ClfGral COMBO-BOX-ClfMayo ~
COMBO-BOX-ClfUtil COMBO-BOX-Sector FILL-IN-DesMat br_table 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Almacen FILL-IN-Master ~
FILL-IN-Inner FILL-IN-Reposicion FILL-IN-Estado COMBO-BOX-Marcas ~
COMBO-BOX-Lineas COMBO-BOX-SubLineas COMBO-BOX-ClfGral COMBO-BOX-ClfMayo ~
COMBO-BOX-ClfUtil COMBO-BOX-Sector FILL-IN-DesMat 

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
codmat|y||INTEGRAL.Almmmatg.codmat|yes
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "':U + 'codmat' + '",
     SortBy-Case = ':U + 'codmat').

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).

/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fClasificacion B-table-Win 
FUNCTION fClasificacion RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCompraTransito B-table-Win 
FUNCTION fCompraTransito RETURNS DECIMAL
  ( INPUT pCodAlm AS CHAR, INPUT pCodMat AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fFSDespacho B-table-Win 
FUNCTION fFSDespacho RETURNS DECIMAL
  ( INPUT pAlmPed AS CHAR, INPUT pCodMat AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fStkDisponible B-table-Win 
FUNCTION fStkDisponible RETURNS DECIMAL
  ( INPUT pCodAlm AS CHAR,
    INPUT pCodMat AS CHAR ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fStockComprometido B-table-Win 
FUNCTION fStockComprometido RETURNS DECIMAL
  ( INPUT pCodMat AS CHAR, INPUT pCodAlm AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fStockTransito B-table-Win 
FUNCTION fStockTransito RETURNS DECIMAL
  ( INPUT pCodCia AS INT,
    INPUT pCodAlm AS CHAR,
    INPUT pCodMat AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE COMBO-BOX-Almacen AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Almacén Despacho" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-ClfGral AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Clf. Gral." 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "Todas","Todas",
                     "Sin Clasificacion","",
                     "A","A",
                     "B","B",
                     "C","C",
                     "D","D",
                     "E","E",
                     "F","F"
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-ClfMayo AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Clf. Mayor." 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "Todas","Todas",
                     "Sin Clasificacion","",
                     "A","A",
                     "B","B",
                     "C","C",
                     "D","D",
                     "E","E",
                     "F","F"
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-ClfUtil AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Clf. Util." 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "Todas","Todas",
                     "Sin Clasificacion","",
                     "A","A",
                     "B","B",
                     "C","C",
                     "D","D",
                     "E","E",
                     "F","F"
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Lineas AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Linea" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "Todas","Todas"
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Marcas AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Marca" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "Todas","Todas"
     DROP-DOWN-LIST
     SIZE 23 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Sector AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Sector" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 23 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-SubLineas AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "SubLinea" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "Todas","Todas"
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesMat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Descripción" 
     VIEW-AS FILL-IN 
     SIZE 32 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Estado AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Estado %" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Inner AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Inner" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Master AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Master" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Reposicion AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Reposición" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-DREPO, 
      Almmmatg, 
      Almmmate, 
      Almtfami, 
      AlmSFami SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-DREPO.Item FORMAT ">>>,>>9":U WIDTH 4
      T-DREPO.CodMat COLUMN-LABEL "<Codigo>" FORMAT "X(14)":U WIDTH 6.57
      T-DREPO.DesMat FORMAT "X(60)":U WIDTH 38.29
      T-DREPO.DesMar COLUMN-LABEL "Marca" FORMAT "x(15)":U WIDTH 8.43
      T-DREPO.UndBas COLUMN-LABEL "Unidad" FORMAT "x(8)":U
      T-DREPO.AlmPed COLUMN-LABEL "Almacén!Despacho" FORMAT "x(5)":U
      T-DREPO.CanReq COLUMN-LABEL "Cantidad!Requerida" FORMAT "-ZZZ,ZZ9.99":U
            WIDTH 8.43
      T-DREPO.CanGen COLUMN-LABEL "Cantidad!Generada" FORMAT "ZZZ,ZZ9.99":U
            WIDTH 7.43 COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 11
      T-DREPO.SolStkDis COLUMN-LABEL "Disponible!Solicitante" FORMAT "(ZZZ,ZZ9.99)":U
      T-DREPO.SolStkMax COLUMN-LABEL "Stock Máximo!Solicitante" FORMAT "ZZZ,ZZ9.99":U
      T-DREPO.SolStkTra COLUMN-LABEL "Tránsito!Solicitante" FORMAT "ZZZ,ZZ9.99":U
      T-DREPO.SolCmpTra COLUMN-LABEL "Compras en!Tránsito" FORMAT "ZZZ,ZZ9.99":U
      T-DREPO.DesStkDis COLUMN-LABEL "Disponible!Despacho" FORMAT "(ZZZ,ZZZ,ZZ9.99)":U
            WIDTH 8.57 COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 13
      T-DREPO.DesSaldo COLUMN-LABEL "Faltante/Sobrante!Despacho" FORMAT "(ZZZ,ZZZ,ZZ9.99)":U
            WIDTH 11.29 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      T-DREPO.GrpStkDis COLUMN-LABEL "Disponible!Grupo" FORMAT "(ZZZ,ZZZ,ZZ9.99)":U
            WIDTH 11.43
      T-DREPO.FSGrupo COLUMN-LABEL "Faltante/Sobrante!Grupo" FORMAT "(ZZZ,ZZZ,ZZ9.99)":U
      T-DREPO.DesStkMax COLUMN-LABEL "Stock Máximo!Despacho" FORMAT "->>>,>>9.99":U
      Almmmate.StkMax COLUMN-LABEL "Empaque!Reposición" FORMAT "ZZZ,ZZ9.99":U
      Almmmatg.CanEmp COLUMN-LABEL "Empaque!Master" FORMAT "->>,>>9.99":U
      T-DREPO.CanGen * (IF Almmmatg.MonVta = 2 THEN Almmmatg.CtoTot * Almmmatg.TpoCmb ELSE Almmmatg.CToTot) @ Almmmatg.CtoTot COLUMN-LABEL "Costo de!Reposición"
      T-DREPO.Origen FORMAT "x(8)":U WIDTH 4.57
      T-DREPO.ClfGral COLUMN-LABEL "Clasf!Gral" FORMAT "x":U
      T-DREPO.ClfMayo FORMAT "x(8)":U
      T-DREPO.ClfUtil FORMAT "x(8)":U
      (T-DREPO.CanGen * Almmmatg.Pesmat ) @ x-Peso COLUMN-LABEL "Peso en Kg" FORMAT ">>>,>>9.99":U
      (T-DREPO.CanGen * Almmmatg.Libre_d02 / 1000000) @ x-Volumen COLUMN-LABEL "Volumen en m3" FORMAT ">>>,>>9.99":U
      Almmmate.StkAct COLUMN-LABEL "Stock!Actual" FORMAT "(ZZZ,ZZ9.99)":U
      T-DREPO.SolStkCom COLUMN-LABEL "Stock!Reservado" FORMAT "->>>,>>9.99":U
      T-DREPO.PorcReposicion COLUMN-LABEL "% de!Reposición" FORMAT "->>>,>>9.99":U
      Almmmatg.CodFam COLUMN-LABEL "Linea" FORMAT "X(3)":U
      Almtfami.desfam FORMAT "X(30)":U
      Almmmatg.SubFam COLUMN-LABEL "SubLinea" FORMAT "X(3)":U
      AlmSFami.dessub FORMAT "X(30)":U
      T-DREPO.CodZona COLUMN-LABEL "Sector" FORMAT "x(5)":U
      T-DREPO.CodUbi COLUMN-LABEL "Ubicacion" FORMAT "x(10)":U
  ENABLE
      T-DREPO.CodMat
      T-DREPO.AlmPed
      T-DREPO.CanReq
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 141 BY 11.85
         FONT 4 ROW-HEIGHT-CHARS .42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Almacen AT ROW 1 COL 59 COLON-ALIGNED WIDGET-ID 80
     FILL-IN-Master AT ROW 1 COL 80 COLON-ALIGNED WIDGET-ID 62
     FILL-IN-Inner AT ROW 1 COL 95 COLON-ALIGNED WIDGET-ID 70
     FILL-IN-Reposicion AT ROW 1 COL 113 COLON-ALIGNED WIDGET-ID 64
     FILL-IN-Estado AT ROW 1 COL 130 COLON-ALIGNED WIDGET-ID 66
     COMBO-BOX-Marcas AT ROW 1.81 COL 10 COLON-ALIGNED WIDGET-ID 72
     COMBO-BOX-Lineas AT ROW 1.81 COL 41 COLON-ALIGNED WIDGET-ID 74
     COMBO-BOX-SubLineas AT ROW 1.81 COL 59 COLON-ALIGNED WIDGET-ID 76
     COMBO-BOX-ClfGral AT ROW 1.81 COL 77 COLON-ALIGNED WIDGET-ID 84
     COMBO-BOX-ClfMayo AT ROW 1.81 COL 100 COLON-ALIGNED WIDGET-ID 86
     COMBO-BOX-ClfUtil AT ROW 1.81 COL 123 COLON-ALIGNED WIDGET-ID 82
     COMBO-BOX-Sector AT ROW 2.62 COL 10 COLON-ALIGNED WIDGET-ID 88
     FILL-IN-DesMat AT ROW 2.62 COL 59 COLON-ALIGNED WIDGET-ID 90
     br_table AT ROW 3.42 COL 1
     "F10: Kardex Almacén Despacho  F11: Faltante/Sobrante" VIEW-AS TEXT
          SIZE 54 BY .5 AT ROW 15.27 COL 66 WIDGET-ID 68
          FONT 0
     "F8 : Stocks x Almacenes F7 : Pedidos F9 : Ingresos en Tránsito" VIEW-AS TEXT
          SIZE 62 BY .5 AT ROW 15.27 COL 2 WIDGET-ID 12
          FONT 0
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
      TABLE: B-MATE B "?" ? INTEGRAL Almmmate
      TABLE: B-MATE2 B "?" ? INTEGRAL Almmmate
      TABLE: B-MATG B "?" ? INTEGRAL Almmmatg
      TABLE: T-DREPO T "SHARED" ? INTEGRAL RepAutomDetail
      TABLE: T-MATG T "?" NO-UNDO INTEGRAL Almmmatg
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
         HEIGHT             = 16.54
         WIDTH              = 142.
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
/* BROWSE-TAB br_table FILL-IN-DesMat F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Inner IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Master IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Reposicion IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.T-DREPO,INTEGRAL.Almmmatg OF Temp-Tables.T-DREPO,INTEGRAL.Almmmate OF INTEGRAL.Almmmatg,INTEGRAL.Almtfami OF INTEGRAL.Almmmatg,INTEGRAL.AlmSFami OF INTEGRAL.Almmmatg"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST, FIRST, FIRST, FIRST"
     _OrdList          = "Temp-Tables.T-DREPO.Item|yes"
     _Where[1]         = "{&Condicion}"
     _Where[3]         = "INTEGRAL.Almmmate.CodAlm = s-CodAlm"
     _FldNameList[1]   > Temp-Tables.T-DREPO.Item
"T-DREPO.Item" ? ? "integer" ? ? ? ? ? ? no ? no no "4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-DREPO.CodMat
"T-DREPO.CodMat" "<Codigo>" "X(14)" "character" ? ? ? ? ? ? yes ? no no "6.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-DREPO.DesMat
"T-DREPO.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "38.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-DREPO.DesMar
"T-DREPO.DesMar" "Marca" "x(15)" "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-DREPO.UndBas
"T-DREPO.UndBas" "Unidad" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-DREPO.AlmPed
"T-DREPO.AlmPed" "Almacén!Despacho" "x(5)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-DREPO.CanReq
"T-DREPO.CanReq" "Cantidad!Requerida" "-ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? yes ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-DREPO.CanGen
"T-DREPO.CanGen" "Cantidad!Generada" "ZZZ,ZZ9.99" "decimal" 11 9 ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-DREPO.SolStkDis
"T-DREPO.SolStkDis" "Disponible!Solicitante" "(ZZZ,ZZ9.99)" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.T-DREPO.SolStkMax
"T-DREPO.SolStkMax" "Stock Máximo!Solicitante" "ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.T-DREPO.SolStkTra
"T-DREPO.SolStkTra" "Tránsito!Solicitante" "ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.T-DREPO.SolCmpTra
"T-DREPO.SolCmpTra" "Compras en!Tránsito" "ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.T-DREPO.DesStkDis
"T-DREPO.DesStkDis" "Disponible!Despacho" "(ZZZ,ZZZ,ZZ9.99)" "decimal" 13 15 ? ? ? ? no ? no no "8.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.T-DREPO.DesSaldo
"T-DREPO.DesSaldo" "Faltante/Sobrante!Despacho" "(ZZZ,ZZZ,ZZ9.99)" "decimal" 14 0 ? ? ? ? no ? no no "11.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.T-DREPO.GrpStkDis
"T-DREPO.GrpStkDis" "Disponible!Grupo" "(ZZZ,ZZZ,ZZ9.99)" "decimal" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.T-DREPO.FSGrupo
"T-DREPO.FSGrupo" "Faltante/Sobrante!Grupo" "(ZZZ,ZZZ,ZZ9.99)" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.T-DREPO.DesStkMax
"T-DREPO.DesStkMax" "Stock Máximo!Despacho" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > INTEGRAL.Almmmate.StkMax
"Almmmate.StkMax" "Empaque!Reposición" "ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > INTEGRAL.Almmmatg.CanEmp
"Almmmatg.CanEmp" "Empaque!Master" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > "_<CALC>"
"T-DREPO.CanGen * (IF Almmmatg.MonVta = 2 THEN Almmmatg.CtoTot * Almmmatg.TpoCmb ELSE Almmmatg.CToTot) @ Almmmatg.CtoTot" "Costo de!Reposición" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > Temp-Tables.T-DREPO.Origen
"T-DREPO.Origen" ? ? "character" ? ? ? ? ? ? no ? no no "4.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > Temp-Tables.T-DREPO.ClfGral
"T-DREPO.ClfGral" "Clasf!Gral" "x" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   = Temp-Tables.T-DREPO.ClfMayo
     _FldNameList[24]   = Temp-Tables.T-DREPO.ClfUtil
     _FldNameList[25]   > "_<CALC>"
"(T-DREPO.CanGen * Almmmatg.Pesmat ) @ x-Peso" "Peso en Kg" ">>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[26]   > "_<CALC>"
"(T-DREPO.CanGen * Almmmatg.Libre_d02 / 1000000) @ x-Volumen" "Volumen en m3" ">>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[27]   > INTEGRAL.Almmmate.StkAct
"Almmmate.StkAct" "Stock!Actual" "(ZZZ,ZZ9.99)" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[28]   > Temp-Tables.T-DREPO.SolStkCom
"T-DREPO.SolStkCom" "Stock!Reservado" "->>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[29]   > Temp-Tables.T-DREPO.PorcReposicion
"T-DREPO.PorcReposicion" "% de!Reposición" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[30]   > INTEGRAL.Almmmatg.CodFam
"Almmmatg.CodFam" "Linea" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[31]   = INTEGRAL.Almtfami.desfam
     _FldNameList[32]   > INTEGRAL.Almmmatg.SubFam
"Almmmatg.SubFam" "SubLinea" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[33]   = INTEGRAL.AlmSFami.dessub
     _FldNameList[34]   > Temp-Tables.T-DREPO.CodZona
"T-DREPO.CodZona" "Sector" "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[35]   > Temp-Tables.T-DREPO.CodUbi
"T-DREPO.CodUbi" "Ubicacion" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON F10 OF br_table IN FRAME F-Main
DO:
    RUN ALM/D-DETMOV.R (T-DREPO.AlmPed, almmmatg.codmat, almmmatg.desmat).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON F11 OF br_table IN FRAME F-Main
DO:
    IF AVAILABLE T-DREPO THEN RUN alm/d-asigna-res-zg (INPUT T-DREPO.CodMat).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON F7 OF br_table IN FRAME F-Main
DO:
    S-CODMAT = Almmmatg.CodMat.
    run vtamay/c-conped.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON F8 OF br_table IN FRAME F-Main
DO:
    S-CODMAT = Almmmatg.CodMat.
      RUN vta/d-stkalm.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON F9 OF br_table IN FRAME F-Main
DO:
    S-CODMAT = Almmmatg.CodMat.
    run alm/c-ingentransito (INPUT s-codalm, INPUT s-codmat).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON LEFT-MOUSE-DBLCLICK OF br_table IN FRAME F-Main
DO: 
    RUN ALM/D-DETMOV.R (s-codalm, almmmatg.codmat, almmmatg.desmat).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-DISPLAY OF br_table IN FRAME F-Main
DO:
    IF NOT AVAILABLE T-DREPO THEN RETURN.
    IF T-DREPO.CONTROLDespacho = YES THEN DO:
      ASSIGN
          T-DREPO.AlmPed:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8 
          T-DREPO.CanGen:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8 
          T-DREPO.CanReq:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8 
          T-DREPO.CodMat:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8 
          T-DREPO.ITEM:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8 
          T-DREPO.Origen:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8 .
      ASSIGN
          T-DREPO.AlmPed:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0
          T-DREPO.CanGen:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0 
          T-DREPO.CanReq:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0 
          T-DREPO.CodMat:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0 
          T-DREPO.ITEM:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0 
          T-DREPO.Origen:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0 .
  END.

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
    DEFINE VAR hSortColumn   AS WIDGET-HANDLE.
    DEFINE VAR lColumName    AS CHAR.
    DEFINE VAR lColumLabel   AS CHAR.
    DEFINE VAR hQueryHandle  AS HANDLE NO-UNDO.
    DEFINE VAR lQueryPrepare AS CHAR NO-UNDO.

    hSortColumn = BROWSE {&BROWSE-NAME}:CURRENT-COLUMN.
    lColumName  = hSortColumn:NAME.
    lColumLabel = hSortColumn:LABEL.

    hQueryHandle = BROWSE {&BROWSE-NAME}:QUERY.
    hQueryHandle:QUERY-CLOSE().

    /* CONTROL DE COLUMNA ACTIVA */
    DEF VAR FLAG-DesMat AS LOG INIT NO NO-UNDO.
    DEF VAR FLAG-DesMar AS LOG INIT NO NO-UNDO.
    DEF VAR FLAG-UndBas AS LOG INIT NO NO-UNDO.
    DEF VAR FLAG-CanReq AS LOG INIT NO NO-UNDO.
    CASE lColumName:
        WHEN "DesMat" THEN ASSIGN FLAG-DesMat = YES T-DREPO.DesMat:COLUMN-FGCOLOR = 0 T-DREPO.DesMat:COLUMN-BGCOLOR = 8.
        WHEN "DesMar" THEN ASSIGN FLAG-DesMar = YES T-DREPO.DesMar:COLUMN-FGCOLOR = 0 T-DREPO.DesMar:COLUMN-BGCOLOR = 8.
        WHEN "UndBas" THEN ASSIGN FLAG-UndBas = YES T-DREPO.UndBas:COLUMN-FGCOLOR = 0 T-DREPO.UndBas:COLUMN-BGCOLOR = 8.
        WHEN "CanReq" THEN ASSIGN FLAG-CanReq = YES T-DREPO.CanReq:COLUMN-FGCOLOR = 0 T-DREPO.CanReq:COLUMN-BGCOLOR = 8.
    END CASE.
    IF FLAG-DesMat = YES AND INDEX(SORTBY-General,SORTBY-DesMat) = 0
        THEN SORTBY-General = SORTBY-General + (IF TRUE <> (SORTBY-General > '') THEN '' ELSE ' ') + SORTBY-DesMat.
    IF FLAG-DesMar = YES AND INDEX(SORTBY-General,SORTBY-DesMar) = 0
        THEN SORTBY-General = SORTBY-General + (IF TRUE <> (SORTBY-General > '') THEN '' ELSE ' ') + SORTBY-DesMar.
    IF FLAG-UndBas = YES AND INDEX(SORTBY-General,SORTBY-UndBas) = 0
        THEN SORTBY-General = SORTBY-General + (IF TRUE <> (SORTBY-General > '') THEN '' ELSE ' ') + SORTBY-UndBas.
    IF FLAG-CanReq = YES AND INDEX(SORTBY-General,SORTBY-CanReq) = 0
        THEN SORTBY-General = SORTBY-General + (IF TRUE <> (SORTBY-General > '') THEN '' ELSE ' ') + SORTBY-CanReq.
    CASE lColumName:
        WHEN "DesMat" THEN DO:
            IF SORTORDER-DesMat = 0 THEN SORTORDER-DesMat = 1.
            CASE SORTORDER-DesMat:
                WHEN 1 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-DesMat + ' DESC', SORTBY-DesMat).
                    SORTORDER-DesMat = 2.
                END.
                WHEN 2 THEN DO:
                    SORTBY-DesMat = REPLACE(SORTBY-General, SORTBY-DesMat, SORTBY-DesMat  + ' DESC').
                    SORTORDER-DesMat = 1.
                END.
            END CASE.
        END.
        WHEN "DesMar" THEN DO:
            IF SORTORDER-DesMar = 0 THEN SORTORDER-DesMar = 1.
             CASE SORTORDER-DesMar:
                WHEN 1 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-DesMar + ' DESC', SORTBY-DesMar).
                    SORTORDER-DesMar = 2.
                END.
                WHEN 2 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-DesMar, SORTBY-DesMar  + ' DESC').
                    SORTORDER-DesMar = 1.
                END.
            END CASE.
        END.
        WHEN "UndBas" THEN DO:
            IF SORTORDER-UndBas = 0 THEN SORTORDER-UndBas = 1.
            CASE SORTORDER-UndBas:
                WHEN 1 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-UndBas + ' DESC', SORTBY-UndBas).
                    SORTORDER-UndBas = 2.
                END.
                WHEN 2 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-UndBas, SORTBY-UndBas  + ' DESC').
                    SORTORDER-UndBas = 1.
                END.
            END CASE.
        END.
        WHEN "CanReq" THEN DO:
            IF SORTORDER-CanReq = 0 THEN SORTORDER-CanReq = 1.
            CASE SORTORDER-CanReq:
                WHEN 1 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-CanReq + ' DESC', SORTBY-CanReq).
                    SORTORDER-CanReq = 2.
                END.
                WHEN 2 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-CanReq, SORTBY-CanReq  + ' DESC').
                    SORTORDER-CanReq = 1.
                END.
            END CASE.
        END.
    END CASE.
    lQueryPrepare = "FOR EACH T-DREPO NO-LOCK".
    CASE COMBO-BOX-ClfGral:
        WHEN 'Todas' THEN .
        OTHERWISE lQueryPrepare = lQueryPrepare + (IF INDEX(lQueryPrepare,'WHERE') = 0 THEN ' WHERE ' ELSE '') +
            "T-DREPO.ClfGral = '" + COMBO-BOX-ClfGral + "'".
    END CASE.
    CASE COMBO-BOX-ClfMayo:
        WHEN 'Todas' THEN .
        OTHERWISE lQueryPrepare = lQueryPrepare + (IF INDEX(lQueryPrepare,'WHERE') = 0 THEN ' WHERE ' ELSE '') +
            "T-DREPO.ClfMayo = '" + COMBO-BOX-ClfMayo + "'".
    END CASE.
    CASE COMBO-BOX-ClfUtil:
        WHEN 'Todas' THEN .
        OTHERWISE lQueryPrepare = lQueryPrepare + (IF INDEX(lQueryPrepare,'WHERE') = 0 THEN ' WHERE ' ELSE '') +
            "T-DREPO.ClfUtil = '" + COMBO-BOX-ClfUtil + "'".
    END CASE.
    CASE COMBO-BOX-Almacen:
        WHEN 'Todos' THEN .
        OTHERWISE lQueryPrepare = lQueryPrepare + (IF INDEX(lQueryPrepare,'WHERE') = 0 THEN ' WHERE ' ELSE '') +
            "T-DREPO.AlmPed = '" + COMBO-BOX-Almacen + "'".
    END CASE.
    CASE COMBO-BOX-Sector:
        WHEN 'Todos' THEN .
        OTHERWISE lQueryPrepare = lQueryPrepare + (IF INDEX(lQueryPrepare,'WHERE') = 0 THEN ' WHERE ' ELSE '') +
            "T-DREPO.CodZona = '" + COMBO-BOX-Sector + "'".
    END CASE.
    CASE TRUE:
        WHEN TRUE <> (FILL-IN-DesMat > '') THEN .
        OTHERWISE lQueryPrepare = lQueryPrepare + (IF INDEX(lQueryPrepare,'WHERE') = 0 THEN ' WHERE ' ELSE '') +
            "INDEX(T-DREPO.DesMat, '" + FILL-IN-DesMat + "') > 0".
    END CASE.
    CASE COMBO-BOX-Marcas:
        WHEN 'Todas' THEN .
        OTHERWISE lQueryPrepare = lQueryPrepare + (IF INDEX(lQueryPrepare,'WHERE') = 0 THEN ' WHERE ' ELSE '') +
            "LOOKUP(T-DREPO.DesMar, '" + COMBO-BOX-Marcas + "') > 0".
    END CASE.
    CASE COMBO-BOX-Lineas:
        WHEN 'Todas' THEN .
        OTHERWISE lQueryPrepare = lQueryPrepare + (IF INDEX(lQueryPrepare,'WHERE') = 0 THEN ' WHERE ' ELSE '') +
            "T-DREPO.CodFam = '" + COMBO-BOX-Lineas + "'".
    END CASE.
    CASE COMBO-BOX-SubLineas:
        WHEN 'Todas' THEN .
        OTHERWISE lQueryPrepare = lQueryPrepare + (IF INDEX(lQueryPrepare,'WHERE') = 0 THEN ' WHERE ' ELSE '') +
            "T-DREPO.SubFam = '" + COMBO-BOX-SubLineas + "'".
    END CASE.
    lQueryPrepare = lQueryPrepare + ", FIRST Almmmatg OF T-DREPO NO-LOCK" +
        ", FIRST Almmmate OF Almmmatg NO-LOCK WHERE Almmmate.CodAlm = '" + s-CodAlm + "'" +
        ", FIRST Almtfami OF Almmmatg NO-LOCK" +
        ", FIRST Almsfami OF Almmmatg NO-LOCK".

    hQueryHandle:QUERY-PREPARE(lQueryPrepare + " " + SORTBY-General).
    hQueryHandle:QUERY-OPEN().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
  IF AVAILABLE T-DREPO THEN
      DISPLAY
      Almmmatg.CanEmp @ FILL-IN-Master
      Almmmatg.StkRep @ FILL-IN-Inner
      Almmmate.StkMax @ FILL-IN-Reposicion
      (Almmmate.StkAct - T-DREPO.CanApro) / Almmmate.StkMin * 100 @ FILL-IN-Estado
      WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-DREPO.CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DREPO.CodMat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-DREPO.CodMat IN BROWSE br_table /* <Codigo> */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    
    DEF VAR pCodMat AS CHAR NO-UNDO.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, YES).
    IF pCodMat = '' THEN RETURN NO-APPLY.
    SELF:SCREEN-VALUE = pCodMat.

    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'NO' AND T-DREPO.Origen = 'AUT' AND SELF:SCREEN-VALUE <>  T-DREPO.CodMat THEN DO:
        MESSAGE 'NO está permitido cambiar el producto' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = T-DREPO.CodMat .
        RETURN NO-APPLY.
    END.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        MESSAGE 'Producto NO registrado' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    DISPLAY
        Almmmatg.DesMar @ T-DREPO.DesMar
        Almmmatg.DesMat @ T-DREPO.DesMat
        Almmmatg.UndBas @ T-DREPO.UndBas
        WITH BROWSE {&browse-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-DREPO.AlmPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DREPO.AlmPed br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF T-DREPO.AlmPed IN BROWSE br_table /* Almacén!Despacho */
OR f8 OF t-drepo.almped
DO:
  FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
      AND Almmmatg.codmat = T-DREPO.CodMat:SCREEN-VALUE IN BROWSE {&browse-name}
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN RETURN NO-APPLY.
  ASSIGN
      input-var-1 = s-codalm
      input-var-2 = almmmatg.CHR__02
      input-var-3 = ''.
  RUN lkup/c-almrep ('Almacenes de Reposicion').
  IF output-var-1 <> ? THEN DO:
      SELF:SCREEN-VALUE = output-var-2.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Almacen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Almacen B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Almacen IN FRAME F-Main /* Almacén Despacho */
DO:
    ASSIGN {&SELF-NAME}.
    RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
    RUN Totales.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-ClfGral
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-ClfGral B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-ClfGral IN FRAME F-Main /* Clf. Gral. */
DO:
    ASSIGN {&SELF-NAME}.
    RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
    RUN Totales.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-ClfMayo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-ClfMayo B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-ClfMayo IN FRAME F-Main /* Clf. Mayor. */
DO:
    ASSIGN {&SELF-NAME}.
    RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
    RUN Totales.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-ClfUtil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-ClfUtil B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-ClfUtil IN FRAME F-Main /* Clf. Util. */
DO:
    ASSIGN {&SELF-NAME}.
    RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
    RUN Totales.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Lineas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Lineas B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Lineas IN FRAME F-Main /* Linea */
DO:
  ASSIGN {&SELF-NAME}.
  RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
  RUN Totales.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Marcas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Marcas B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Marcas IN FRAME F-Main /* Marca */
DO:
  ASSIGN {&SELF-NAME}.
  /*{&OPEN-QUERY-{&BROWSE-NAME}}*/
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  RUN Totales.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Sector
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Sector B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Sector IN FRAME F-Main /* Sector */
DO:
    ASSIGN {&SELF-NAME}.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    RUN Totales.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-SubLineas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-SubLineas B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-SubLineas IN FRAME F-Main /* SubLinea */
DO:
  ASSIGN {&SELF-NAME}.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  RUN Totales.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-DesMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-DesMat B-table-Win
ON LEAVE OF FILL-IN-DesMat IN FRAME F-Main /* Descripción */
DO:
    ASSIGN {&SELF-NAME}.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    RUN Totales.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* ON 'return':U OF T-DREPO.AlmPed, T-DREPO.CodMat, T-DREPO.CanReq */
/* DO:                                                             */
/*     APPLY 'tab':U.                                              */
/*     RETURN NO-APPLY.                                            */
/* END.                                                            */

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
    WHEN 'codmat':U THEN DO:
      &Scope SORTBY-PHRASE BY Almmmatg.codmat
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ARTICULOS-A-SOLICITAR B-table-Win 
PROCEDURE ARTICULOS-A-SOLICITAR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodMat AS CHAR.

EMPTY TEMP-TABLE T-MATE.

DEF BUFFER B-MATE FOR Almmmate.

FIND B-MATE WHERE B-MATE.codcia = s-codcia
    AND B-MATE.codalm = s-codalm
    AND B-MATE.codmat = pCodMat
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-MATE THEN RETURN.

DEF VAR pOk AS LOG NO-UNDO.
DEF VAR pCodigo AS CHAR NO-UNDO.

DEF VAR pStkComprometido AS DEC NO-UNDO.
DEF VAR pStockTransito AS DEC NO-UNDO.
DEF VAR pCompraTransito AS DEC NO-UNDO.

RUN gn/fAlmPrincipal (INPUT s-CodAlm, OUTPUT pOk).
CASE pOk:
    WHEN YES THEN DO:   /* ES UN CD */
        FIND FIRST TabGener WHERE TabGener.CodCia = s-codcia
            AND TabGener.Clave = "ZG"
            AND TabGener.Libre_c01 = s-CodAlm
            AND TabGener.Libre_l01 = YES
            NO-LOCK.
        pCodigo = TabGener.Codigo.  /* Zona Geografica que nos interesa Ej. ATE */
        /* Barremos producto por producto */
        FOR EACH TabGener NO-LOCK WHERE TabGener.CodCia = s-CodCia
            AND TabGener.Clave = "ZG"
            AND TabGener.Codigo = pCodigo,
            FIRST Almtabla NO-LOCK WHERE Almtabla.tabla = Tabgener.clave
            AND Almtabla.codigo = Tabgener.codigo:
            FIND FIRST B-MATE WHERE B-MATE.CodCia = s-CodCia
                AND B-MATE.CodAlm = TabGener.Libre_c01
                AND B-MATE.codmat = pCodMat
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE B-MATE THEN NEXT.
            FIND FIRST T-MATE WHERE T-MATE.CodMat = pCodMat EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE T-MATE THEN DO:
                CREATE T-MATE.
                BUFFER-COPY B-MATE
                    EXCEPT B-MATE.StkAct B-MATE.StkMin B-MATE.StkRep B-MATE.StkComprometido B-MATE.StkActCbd
                    TO T-MATE
                    ASSIGN T-MATE.CodAlm = s-CodAlm.    /* OJO */
            END.
            pStkComprometido = fStockComprometido(B-MATE.CodMat, B-MATE.CodAlm).
            /*pStkComprometido = B-MATE.StkComprometido.*/
            pStockTransito = fStockTransito(B-MATE.CodCia,B-MATE.CodAlm,B-MATE.CodMat).
            pCompraTransito = fCompraTransito(B-MATE.CodAlm, B-MATE.CodMat).
            ASSIGN
                /* Stock Disponible Solicitante */
                T-MATE.StkAct = T-MATE.StkAct + (B-MATE.StkAct - pStkComprometido)
                T-MATE.StkComprometido = T-MATE.StkComprometido + pStkComprometido
                /* Stock Maximo Solicitante (Stock Maximo + Seguridad) */
                T-MATE.StkMin = T-MATE.StkMin + B-MATE.StkMin
                /* Stock en Tránsito Solicitante */
                T-MATE.StkRep = T-MATE.StkRep + pStockTransito
                /* Compras en Tránsito */
                T-MATE.StkActCbd = T-MATE.StkActCbd + pCompraTransito
                .
        END.    /* EACH TabGener */   
    END.
    WHEN NO THEN DO:   /* ES UNA TIENDA */
        CREATE T-MATE.
        BUFFER-COPY B-MATE 
            EXCEPT B-MATE.StkAct B-MATE.StkMin  B-MATE.StkRep B-MATE.StkComprometido B-MATE.StkActCbd
            TO T-MATE.
        pStkComprometido = fStockComprometido(B-MATE.CodMat, B-MATE.CodAlm).
        /*pStkComprometido = B-MATE.StkComprometido.*/
        pStockTransito = fStockTransito(B-MATE.CodCia,B-MATE.CodAlm,B-MATE.CodMat).
        pCompraTransito = fCompraTransito(B-MATE.CodAlm, B-MATE.CodMat).
        ASSIGN
            /* Stock Disponible Solicitante */
            T-MATE.StkAct = (B-MATE.StkAct - pStkComprometido)
            T-MATE.StkComprometido = pStkComprometido
            /* Stock Maximo Solicitante (Stock Maximo + Seguridad) */
            T-MATE.StkMin = B-MATE.StkMin
            /* Stock en Tránsito Solicitante */
            T-MATE.StkRep = pStockTransito
            /* Compras en Tránsito */
            T-MATE.StkActCbd = pCompraTransito
            .
    END.
END CASE.
FOR EACH T-MATE:
    IF T-MATE.StkMax <= 0 THEN T-MATE.StkMax = 1.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Filtros B-table-Win 
PROCEDURE Carga-Filtros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-ListaMarcas AS CHAR INIT 'Todas,Todas' NO-UNDO.
DEF VAR x-ListaLineas AS CHAR INIT 'Todas,Todas' NO-UNDO.
DEF VAR x-ListaSubLineas AS CHAR INIT 'Todas,Todas' NO-UNDO.
DEF VAR x-ListaAlmacenes AS CHAR INIT 'Todos,Todos' NO-UNDO.
DEF VAR x-ListaSectores AS CHAR INIT 'Todos' NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    FOR EACH T-DREPO NO-LOCK,
        FIRST Almmmatg OF T-DREPO NO-LOCK, FIRST Almtfami OF Almmmatg NO-LOCK, FIRST Almsfami OF Almmmatg NO-LOCK,
        FIRST Almmmate OF Almmmatg WHERE Almmmate.codalm = s-codalm NO-LOCK:
        IF LOOKUP(Almmmatg.desmar, x-ListaMarcas) = 0 THEN DO:
            x-ListaMarcas = x-ListaMarcas + ',' + TRIM(Almmmatg.desmar) + ',' + TRIM(Almmmatg.desmar).
        END.
        IF LOOKUP(Almmmatg.codfam, x-ListaLineas) = 0 THEN DO:
            x-ListaLineas = x-ListaLineas + ',' + TRIM(Almmmatg.codfam) + ',' + TRIM(Almmmatg.codfam).
        END.
        IF LOOKUP(Almmmatg.subfam, x-ListaSubLineas) = 0 THEN DO:
            x-ListaSubLineas = x-ListaSubLineas + ',' + TRIM(Almmmatg.subfam) + ',' + TRIM(Almmmatg.subfam).
        END.
        IF LOOKUP(T-DREPO.AlmPed, x-ListaAlmacenes) = 0 THEN DO:
            x-ListaAlmacenes = x-ListaAlmacenes + ',' + TRIM(T-DREPO.AlmPed) + ',' + TRIM(T-DREPO.AlmPed).
        END.
        IF LOOKUP(T-DREPO.codzona, x-ListaSectores) = 0 THEN DO:
            x-ListaSectores = x-ListaSectores + ',' + TRIM(T-DREPO.codzona).
        END.
    END.
    COMBO-BOX-Marcas = 'Todas'.
    COMBO-BOX-Lineas = 'Todas'.
    COMBO-BOX-SubLineas = 'Todas'.
    COMBO-BOX-Almacen = 'Todos'.
    COMBO-BOX-Sector = 'Todos'.
    COMBO-BOX-Marcas:LIST-ITEM-PAIRS = x-ListaMarcas.
    COMBO-BOX-Lineas:LIST-ITEM-PAIRS = x-ListaLineas.
    COMBO-BOX-SubLineas:LIST-ITEM-PAIRS = x-ListaSubLineas.
    COMBO-BOX-Almacen:LIST-ITEM-PAIRS = x-ListaAlmacenes.
    COMBO-BOX-Sector:LIST-ITEMS = x-ListaSectores.
END.

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

DEF VAR x-NroItm AS INT NO-UNDO INIT 0.
EMPTY TEMP-TABLE Detalle.

FOR EACH BT-DREPO NO-LOCK, 
    FIRST B-MATG OF BT-DREPO NO-LOCK,
    FIRST B-MATE OF B-MATG WHERE B-MATE.codalm = s-codalm NO-LOCK,
    FIRST Almtfami OF B-MATG NO-LOCK,
    FIRST Almsfami OF B-MATG NO-LOCK
    BY B-MATG.desmar BY B-MATG.desmat:
    x-NroItm = x-NroItm + 1.
    CREATE Detalle.
    BUFFER-COPY BT-DREPO TO Detalle
        ASSIGN
        Detalle.nroitm = x-NroItm
        Detalle.desmat = B-MATG.desmat
        Detalle.desmar = B-MATG.desmar
        Detalle.undstk = B-MATG.undstk
        Detalle.DesStkDis = fStkDisponible(BT-DREPO.AlmPed,BT-DREPO.CodMat) 
        Detalle.FSDespacho = fFSDespacho(BT-DREPO.AlmPed,BT-DREPO.CodMat) 
        Detalle.empreposicion = B-MATE.stkmax
        Detalle.empmaster = B-MATG.canemp
        Detalle.ctototal = BT-DREPO.CanGen * (IF B-MATG.MonVta = 2 THEN B-MATG.CtoTot * B-MATG.TpoCmb ELSE B-MATG.CtoTot)
        Detalle.peso = (BT-DREPO.CanGen * B-MATG.Pesmat ) 
        Detalle.volumen = (BT-DREPO.CanGen * B-MATG.Libre_d02 / 1000000)
        Detalle.SolStkAct = B-MATE.stkact
        Detalle.SolStkCom = fStockComprometido(BT-DREPO.CodMat,BT-DREPO.CodAlm)
        Detalle.CodFam = B-MATG.codfam
        Detalle.DesFam = Almtfami.desfam
        Detalle.SubFam = B-MATG.subfam
        Detalle.DesSub = Almsfami.dessub
        .
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Datos-Adicionales B-table-Win 
PROCEDURE Datos-Adicionales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* RHC 02/08/2016 Datos adicionales */
DEF VAR x-Total AS DEC NO-UNDO.
DEF VAR pComprometido AS DEC NO-UNDO.
/* Comprometido */
RUN gn/stock-comprometido-v2 (T-DREPO.CodMat, T-DREPO.CodAlm, NO, OUTPUT pComprometido).
/*RUN vta2/stock-comprometido-v2 (T-DREPO.CodMat, T-DREPO.CodAlm, OUTPUT pComprometido).*/
T-DREPO.CanApro = pComprometido.
/* En Tránsito */
RUN alm\p-articulo-en-transito (
  s-codcia,
  s-codalm,
  T-DREPO.codmat,
  INPUT-OUTPUT TABLE tmp-tabla,
  OUTPUT x-Total).
T-DREPO.CanTran = x-Total.
/* RHC 27/02/17 */
FIND B-MATE WHERE B-MATE.codcia = s-codcia
    AND B-MATE.codalm = T-DREPO.almped
    AND B-MATE.codmat = T-DREPO.codmat
    NO-LOCK NO-ERROR.
IF AVAILABLE B-MATE THEN DO:
    RUN gn/Stock-Comprometido-v2 (B-MATE.CodMat, T-DREPO.AlmPed, NO, OUTPUT pComprometido).
    /*RUN vta2/Stock-Comprometido-v2 (B-MATE.CodMat, T-DREPO.AlmPed, OUTPUT pComprometido).*/
    T-DREPO.StkAct = B-MATE.StkAct - pComprometido.
    FIND FIRST Almtubic OF B-MATE NO-LOCK NO-ERROR.
    IF AVAILABLE Almtubic THEN
        ASSIGN
            T-DREPO.CodUbi = Almtubic.CodUbi
            T-DREPO.CodZona = Almtubic.CodZona.
END.
/* RHC 16/06/2017 */
RUN ARTICULOS-A-SOLICITAR (INPUT T-DREPO.CodMat).
RUN RESUMEN-POR-DESPACHO (INPUT T-DREPO.AlmPed, INPUT T-DREPO.CodMat).
FIND FIRST T-MATE-2 WHERE T-MATE-2.codcia = s-codcia
  AND T-MATE-2.codalm = T-DREPO.AlmPed
  AND T-MATE-2.codmat = T-DREPO.CodMat NO-LOCK NO-ERROR.
IF AVAILABLE T-MATE-2 
  THEN ASSIGN
  T-DREPO.DesStkDis = T-MATE-2.StkAct
  T-DREPO.DesStkMax = T-MATE-2.StkMin.
FIND T-MATE WHERE T-MATE.codalm = s-codalm
  AND T-MATE.codmat = T-DREPO.codmat
  NO-LOCK NO-ERROR.
IF AVAILABLE T-MATE
  THEN ASSIGN
  T-DREPO.SolStkAct = T-MATE.StkAct + T-MATE.StkComprometido
  T-DREPO.SolStkCom = T-MATE.StkComprometido
  T-DREPO.SolStkDis = T-MATE.StkAct
  T-DREPO.SolStkMax = T-MATE.StkMin
  T-DREPO.SolStkTra = fStockTransito(s-CodCia,s-CodAlm,T-DREPO.CodMat)
  T-DREPO.SolCmpTra = T-MATE.StkActCbd
  .
ASSIGN
  T-DREPO.PorcReposicion = (IF T-DREPO.CanReq <> 0 THEN (T-DREPO.CanGen / T-DREPO.CanReq * 100) ELSE 0).    
FIND B-MATG OF T-DREPO NO-LOCK.
ASSIGN
    T-DREPO.DesMat = B-MATG.DesMat.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Eliminar B-table-Win 
PROCEDURE Eliminar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FOR EACH BT-DREPO WHERE {&CondicionX} NO-LOCK,
      FIRST Almmmatg OF BT-DREPO WHERE {&CondicionX2} NO-LOCK,
      FIRST Almmmate OF Almmmatg WHERE Almmmate.CodAlm = s-codalm NO-LOCK:
      DELETE BT-DREPO.
  END.
  DEF VAR x-NroItm AS INT INIT 0 NO-UNDO.
  FOR EACH BT-DREPO BY BT-DREPO.ITEM:
      x-NroItm = x-NroItm + 1.
      BT-DREPO.ITEM = x-NroItm.
  END.
  RUN Totales.
  RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).

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
DEF VAR c-xls-file AS CHAR NO-UNDO.
DEF VAR rpta AS LOG INIT NO NO-UNDO.

c-xls-file = 'Reposicion_Alm_' + s-CodAlm.

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
RUN Carga-Temporal.

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
MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generar-Pedidos B-table-Win 
PROCEDURE Generar-Pedidos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pFchEnt AS DATE.
DEF INPUT PARAMETER pGlosa AS CHAR.
DEF INPUT PARAMETER pVtaPuntual AS LOG.
DEF INPUT PARAMETER pMotivo AS CHAR.

/* RHC 30.07.2014 Se va a limitar a 52 itesm por pedido */
DEF VAR n-Items AS INT NO-UNDO.
DEF BUFFER B-MATG FOR Almmmatg.

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FIND FIRST Faccorre WHERE Faccorre.codcia = s-codcia
        AND Faccorre.coddoc = s-coddoc
        AND Faccorre.flgest = YES
        AND Faccorre.coddiv = pCodDiv
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccorre THEN DO:
        MESSAGE 'No se encuentra el correlativo para la división' s-coddoc pCodDiv
            VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN "ADM-ERROR".
    END.
    /* Depuramos el temporal */
    FOR EACH BT-DREPO WHERE BT-DREPO.AlmPed = '998':
        DELETE BT-DREPO.
    END.
    n-Items = 0.
    FOR EACH BT-DREPO WHERE {&CondicionX} NO-LOCK,
        FIRST Almmmatg OF BT-DREPO WHERE {&CondicionX2} NO-LOCK,
        FIRST Almmmate OF Almmmatg WHERE Almmmate.CodAlm = s-CodAlm NO-LOCK,
        FIRST Almtfami OF Almmmatg NO-LOCK,
        FIRST AlmSFami OF INTEGRAL.Almmmatg NO-LOCK 
        BREAK BY BT-DREPO.AlmPed BY Almmmatg.DesMar BY Almmmatg.DesMat:
        IF FIRST-OF(BT-DREPO.AlmPed) OR n-Items >= 52 THEN DO:
            s-TipMov = "A".
            IF BT-DREPO.Origen = "MAN" THEN s-TipMov = "M".
            CREATE Almcrepo.
            ASSIGN
                almcrepo.AlmPed = BT-DREPO.Almped
                almcrepo.CodAlm = s-codalm
                almcrepo.CodCia = s-codcia
                almcrepo.FchDoc = TODAY
                almcrepo.FchVto = TODAY + 7
                almcrepo.Fecha = pFchEnt    /* Ic 13May2015*/
                almcrepo.Hora = STRING(TIME, 'HH:MM')
                almcrepo.NroDoc = Faccorre.correlativo
                almcrepo.NroSer = Faccorre.nroser
                almcrepo.TipMov = s-TipMov          /* OJO: Manual Automático */
                almcrepo.Usuario = s-user-id
                almcrepo.Glosa = pGlosa.
            ASSIGN
                almcrepo.VtaPuntual     = pVtaPuntual
                almcrepo.MotReposicion  = pMotivo.
            ASSIGN
                Faccorre.correlativo = Faccorre.correlativo + 1
                n-Items = 0.
            /* RHC 21/04/2016 Almacén de despacho CD? */
            IF CAN-FIND(FIRST TabGener WHERE TabGener.CodCia = s-codcia
                        AND TabGener.Clave = "ZG"
                        AND TabGener.Libre_c01 = Almcrepo.AlmPed    /* Almacén de Despacho */
                        AND TabGener.Libre_l01 = YES                /* CD */
                        NO-LOCK)
                THEN Almcrepo.FlgSit = "G".   /* Por Autorizar por Abastecimientos */
            /* ************************************** */
        END.
        CREATE Almdrepo.
        BUFFER-COPY BT-DREPO TO Almdrepo
            ASSIGN
            almdrepo.ITEM   = n-Items + 1
            almdrepo.CodCia = almcrepo.codcia
            almdrepo.CodAlm = almcrepo.codalm
            almdrepo.TipMov = almcrepo.tipmov
            almdrepo.NroSer = almcrepo.nroser
            almdrepo.NroDoc = almcrepo.nrodoc
            almdrepo.CanReq = almdrepo.cangen
            almdrepo.CanApro = almdrepo.cangen.
        DELETE BT-DREPO.
        n-Items = n-Items + 1.
    END.
END.
RELEASE Faccorre.
RELEASE almcrepo.
RELEASE almdrepo.

RUN Limpiar-Filtros.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Excel B-table-Win 
PROCEDURE Importar-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE FILL-IN-Archivo AS CHAR         NO-UNDO.
    DEFINE VARIABLE OKpressed       AS LOG          NO-UNDO.
    DEFINE VARIABLE chExcelApplication          AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook                  AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet                 AS COM-HANDLE.
    DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
    DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
    DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
    DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
    DEFINE VARIABLE t-Row           AS INTEGER INIT 1.
    DEFINE VARIABLE pMensaje        AS CHAR         NO-UNDO.

    DEF VAR pComprometido AS DEC NO-UNDO.
    DEF VAR x-StkMax LIKE Almmmate.StkMax NO-UNDO.

    /* RUTINA GENERAL */
    SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
        FILTERS "Archivos Excel (*.xls,*.xlsx)" "*.xls,*.xlsx", "Todos (*.*)" "*.*"
        TITLE "Archivo(s) de Carga..."
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = FALSE THEN RETURN NO-APPLY.

    /* CREAMOS LA HOJA EXCEL */
    CREATE "Excel.Application" chExcelApplication.
    chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-Archivo).
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    SESSION:SET-WAIT-STATE('GENERAL').

    ASSIGN
        t-Column = 0
        t-Row = 1.    
    /* CHEQUEAMOS LA INTEGRIDAD DEL ARCHIVO EXCEL */
    cValue = chWorkSheet:Cells(1,1):VALUE.
    IF cValue = "" OR cValue = ? THEN DO:
        MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    /* ******************* */
    /* CARGAMOS TEMPORALES */
    EMPTY TEMP-TABLE T-DREPO.
    EMPTY TEMP-TABLE T-MATG.
    ASSIGN
        pMensaje = ""
        t-Row = 1.     /* Saltamos el encabezado de los campos */
    REPEAT:
        ASSIGN
            t-Row    = t-Row + 1.
        t-column = 2.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
        /* CODIGO */
        CREATE T-DREPO.
        ASSIGN
            T-DREPO.Origen = 'MAN'
            T-DREPO.codcia = s-codcia
            T-DREPO.CodAlm = s-codalm 
            T-DREPO.codmat = STRING(INTEGER(cValue),'999999').
        /* ALMACEN */
        t-Column = 6.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN
            T-DREPO.almped = cValue.
        /* CANTIDAD */        
        t-Column = 8.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN
            T-DREPO.CanReq = DECIMAL(cValue)
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
                + "Cantidad Requerida".
            LEAVE.
        END.
        ASSIGN
            T-DREPO.CanGen = T-DREPO.CanReq.
    END.
    IF pMensaje <> "" THEN DO:
        EMPTY TEMP-TABLE T-DREPO.
        chExcelApplication:QUIT().
        RELEASE OBJECT chExcelApplication.      
        RELEASE OBJECT chWorkbook.
        RELEASE OBJECT chWorksheet. 
        RETURN.
    END.
    SESSION:SET-WAIT-STATE('').

    /* CERRAMOS EL EXCEL */
    chExcelApplication:QUIT().
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet. 

    /* Mensaje de error de carga */
    IF pMensaje <> "" THEN DO:
        MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        EMPTY TEMP-TABLE T-DREPO.
    END.
    /* RHC 02/08/2016 Datos adicionales */
    /* DEPURAMOS */
    
    FOR EACH T-DREPO:
        IF T-DREPO.CanReq = 0 THEN DO:
            DELETE T-DREPO.
            NEXT.
        END.
        FIND Almmmatg OF T-DREPO NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatg THEN DO:
            DELETE T-DREPO.
            NEXT.
        END.
        FIND Almacen WHERE Almacen.codcia = s-codcia
            AND Almacen.codalm = T-DREPO.AlmPed
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almacen THEN DO:
            DELETE T-DREPO.
            NEXT.
        END.
        FIND Almmmate WHERE Almmmate.codcia = s-codcia
            AND Almmmate.codalm = T-DREPO.AlmPed
            AND Almmmate.codmat = T-DREPO.CodMat
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmate THEN DO:
            DELETE T-DREPO.
            NEXT.
        END.
        FIND Almmmate WHERE Almmmate.codcia = s-codcia
            AND Almmmate.codalm = s-codalm
            AND Almmmate.codmat = T-DREPO.codmat
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmate THEN DO:
            DELETE T-DREPO.
            NEXT.
        END.
    END.
    
    /* Revisamos cantidades */
    DEF VAR x-StockDisponible AS DEC NO-UNDO.
    DEF VAR x-CanReq AS DEC NO-UNDO.
    DEF VAR x-StockMaximo AS DEC NO-UNDO.
    
    /*FILL-IN-Mensaje:VISIBLE IN FRAME {&FRAME-NAME} = YES.*/
    FOR EACH T-DREPO:
        /*FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Cantidad requerida " + T-DREPO.codmat.*/
        FIND Almmmate WHERE Almmmate.codcia = s-codcia
            AND Almmmate.codalm = T-DREPO.almped
            AND Almmmate.codmat = T-DREPO.codmat
            NO-LOCK.
        x-CanReq = T-DREPO.CanReq.
        RUN gn/Stock-Comprometido-v2 (Almmmate.CodMat, Almmmate.codalm, NO, OUTPUT pComprometido).
        /*RUN vta2/Stock-Comprometido-v2 (Almmmate.CodMat, Almmmate.codalm, OUTPUT pComprometido).*/
        x-StockDisponible = Almmmate.StkAct - pComprometido.    /* OJO Max dice NO DE SEGURIDAD */
        IF x-StockDisponible <= 0 OR x-CanReq > x-StockDisponible THEN DO: 
            pMensaje = pMensaje + (IF pMensaje > '' THEN CHR(10) ELSE '') + 
                'NO hay stock disponible ' + T-DREPO.codmat.
            CREATE T-MATG.
            ASSIGN
                T-MATG.codcia = s-codcia
                T-MATG.codmat = T-DREPO.codmat
                T-MATG.Libre_c01 = T-DREPO.almped
                T-MATG.Libre_d01 = T-DREPO.canreq
                T-MATG.Libre_d02 = x-StockDisponible.
            DELETE T-DREPO.
            NEXT.
        END.
        ASSIGN
            T-DREPO.StkAct = x-StockDisponible.
    END.
    IF pMensaje <> "" THEN DO:
        RUN alm/d-no-transferidos ( TABLE T-MATG ).
    END.
    
    /* Renumeramos */
    DEF VAR x-Total AS DEC NO-UNDO.
    FOR EACH T-DREPO BY T-DREPO.CodMat:
        /*FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Comprometido y tránsito " + T-DREPO.codmat.*/
        /* Comprometido */
        RUN gn/stock-comprometido-v2 (T-DREPO.CodMat, T-DREPO.CodAlm, NO, OUTPUT pComprometido).
        /*RUN vta2/stock-comprometido-v2 (T-DREPO.CodMat, T-DREPO.CodAlm, OUTPUT pComprometido).*/
        T-DREPO.CanApro = pComprometido.
        /* En Tránsito */
        RUN alm\p-articulo-en-transito (
            s-codcia,
            s-codalm,
            T-DREPO.codmat,
            INPUT-OUTPUT TABLE tmp-tabla,
            OUTPUT x-Total).
        T-DREPO.CanTran = x-Total.
    END.

    /* RHC 02/08/2016 Datos adicionales */
    FOR EACH T-DREPO:
        RUN Datos-Adicionales.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Limpiar-Filtros B-table-Win 
PROCEDURE Limpiar-Filtros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN
    COMBO-BOX-ClfGral = 'Todas'
    COMBO-BOX-ClfMayo = 'Todas'
    COMBO-BOX-ClfUtil = 'Todas'
    COMBO-BOX-Almacen = 'Todos'
    COMBO-BOX-Marcas = 'Todas'
    COMBO-BOX-Lineas = 'Todas'
    COMBO-BOX-SubLineas = 'Todas'
    COMBO-BOX-Sector = 'Todos'
    FILL-IN-DesMat = ''
    .
DISPLAY 
    COMBO-BOX-ClfGral
    COMBO-BOX-ClfMayo
    COMBO-BOX-ClfUtil
    COMBO-BOX-Almacen 
    COMBO-BOX-Marcas
    COMBO-BOX-Lineas
    COMBO-BOX-SubLineas
    COMBO-BOX-Sector 
    FILL-IN-DesMat
    WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF s-nivel-acceso <> 1 THEN RETURN 'ADM-ERROR'.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  DEF VAR x-Item AS INT NO-UNDO INIT 1.
  
  FOR EACH BT-DREPO BY BT-DREPO.Item:
      x-Item = BT-DREPO.ITEM + 1.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      T-DREPO.CodCia = s-codcia
      T-DREPO.CodAlm = s-codalm.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' 
      THEN ASSIGN
            T-DREPO.Origen = 'MAN'
            T-DREPO.ITEM   = x-Item.

  ASSIGN T-DREPO.CanGen = T-DREPO.CanReq.

  IF T-DREPO.Origen = 'MAN' THEN DO:
      RUN Datos-Adicionales.
  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Totales.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields B-table-Win 
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
      COMBO-BOX-Almacen:SENSITIVE = YES.
      COMBO-BOX-ClfGral:SENSITIVE = YES.
      COMBO-BOX-ClfMayo:SENSITIVE = YES.
      COMBO-BOX-ClfUtil:SENSITIVE = YES.
      COMBO-BOX-Lineas:SENSITIVE = YES.
      COMBO-BOX-Marcas:SENSITIVE = YES.
      COMBO-BOX-SubLineas:SENSITIVE = YES.
      COMBO-BOX-Sector:SENSITIVE = YES.
      FILL-IN-DesMat:SENSITIVE = YES.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields B-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE T-DREPO THEN
      DISPLAY
      Almmmatg.CanEmp @ FILL-IN-Master
      Almmmate.StkMax @ FILL-IN-Reposicion
      (Almmmate.StkAct - T-DREPO.CanApro) / Almmmate.StkMin * 100 @ FILL-IN-Estado
      WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields B-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN DO:
      IF T-DREPO.Origen = 'AUT'
          THEN ASSIGN
                T-DREPO.CodMat:READ-ONLY IN BROWSE {&browse-name} = YES
                T-DREPO.AlmPed:READ-ONLY IN BROWSE {&browse-name} = YES.
      IF T-DREPO.Origen = 'AUT' AND T-DREPO.ControlDespacho = YES 
          THEN ASSIGN 
                T-DREPO.AlmPed:READ-ONLY IN BROWSE {&browse-name} = NO.
      IF T-DREPO.Origen = 'MAT'
          THEN ASSIGN
                T-DREPO.CodMat:READ-ONLY IN BROWSE {&browse-name} = NO
                T-DREPO.AlmPed:READ-ONLY IN BROWSE {&browse-name} = NO.
  END.
  ELSE DO:
      T-DREPO.CodMat:READ-ONLY IN BROWSE {&browse-name} = NO.
      T-DREPO.AlmPed:READ-ONLY IN BROWSE {&browse-name} = NO.
  END.
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-Almacen:SENSITIVE = NO.
      COMBO-BOX-ClfGral:SENSITIVE = NO.
      COMBO-BOX-ClfMayo:SENSITIVE = NO.
      COMBO-BOX-ClfUtil:SENSITIVE = NO.
      COMBO-BOX-Lineas:SENSITIVE = NO.
      COMBO-BOX-Marcas:SENSITIVE = NO.
      COMBO-BOX-SubLineas:SENSITIVE = NO.
      COMBO-BOX-Sector:SENSITIVE = NO.
      FILL-IN-DesMat:SENSITIVE = NO.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Totales.

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
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Totales.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RESUMEN-POR-DESPACHO B-table-Win 
PROCEDURE RESUMEN-POR-DESPACHO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pAlmPed AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.

DEF VAR pOk AS LOG NO-UNDO.
DEF VAR pOkSolicitante AS LOG NO-UNDO.
DEF VAR pCodigo AS CHAR NO-UNDO.

DEF VAR pStkComprometido AS DEC NO-UNDO.

EMPTY TEMP-TABLE T-GENER.
EMPTY TEMP-TABLE T-MATE-2.

FIND B-MATE WHERE B-MATE.codcia = s-codcia
    AND B-MATE.codalm = pAlmPed
    AND B-MATE.codmat = pCodMat
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-MATE THEN RETURN.

RUN gn/fAlmPrincipal (INPUT pAlmPed, OUTPUT pOk).
RUN gn/fAlmPrincipal (INPUT s-CodAlm, OUTPUT pOkSolicitante).

CASE TRUE:
    WHEN pOkSolicitante = YES AND pOk = YES THEN DO:   /* ES UN CD */
        FIND FIRST TabGener WHERE TabGener.CodCia = s-codcia
            AND TabGener.Clave = "ZG"
            AND TabGener.Libre_c01 = pAlmPed
            AND TabGener.Libre_l01 = YES
            NO-LOCK.
        pCodigo = TabGener.Codigo.  /* Zona Geografica que nos interesa */
        FOR EACH TabGener NO-LOCK WHERE TabGener.CodCia = s-CodCia
            AND TabGener.Clave = "ZG"
            AND TabGener.Codigo = pCodigo,
            FIRST Almtabla NO-LOCK WHERE Almtabla.tabla = Tabgener.clave
            AND Almtabla.codigo = Tabgener.codigo:
            FIND B-MATE2 WHERE B-MATE2.codcia = s-codcia
                AND B-MATE2.codalm = TabGener.Libre_c01
                AND B-MATE2.codmat = B-MATE.codmat
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE B-MATE2 THEN NEXT.
            FIND FIRST T-MATE-2 OF B-MATE EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE T-MATE-2 THEN DO:
                CREATE T-MATE-2.
                BUFFER-COPY B-MATE
                    EXCEPT B-MATE.StkAct B-MATE.StkMin B-MATE.StkRep B-MATE.StkComprometido B-MATE.StkActCbd
                    TO T-MATE-2.
            END.
            pStkComprometido = fStockComprometido(B-MATE2.CodMat, B-MATE2.CodAlm).
            /*pStkComprometido = B-MATE2.StkComprometido.*/
            ASSIGN
                /* Stock Disponible Despachante */
                T-MATE-2.StkAct = T-MATE-2.StkAct + (B-MATE2.StkAct - pStkComprometido)
                /* Stock Maximo Despachante CD: (Stock Maximo + Seguridad) Tienda: Stock Maximo */
                T-MATE-2.StkMin = T-MATE-2.StkMin + (IF pOkSolicitante = YES THEN B-MATE2.StkMin ELSE B-MATE2.StockMax)
                .
        END.
        /* Definimos si el GRUPO cubre el despacho */
        FIND FIRST T-MATE-2 OF B-MATE EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE T-MATE-2 THEN DO:
            IF (T-MATE-2.StkAct - T-MATE-2.StkMin) <= 0 THEN DO:
                DELETE T-MATE-2.
            END.
            ELSE DO:
                /* Cargamos los datos del ALMACEN */
                FIND B-MATE2 OF T-MATE-2 NO-LOCK NO-ERROR.
                pStkComprometido = fStockComprometido(B-MATE2.CodMat, B-MATE2.CodAlm).
                /*pStkComprometido = B-MATE2.StkComprometido.*/
                /* RHC 16/06/2017 La CD o el Almacén? */
                IF (T-MATE-2.StkAct - T-MATE-2.StkMin) > (B-MATE2.StkAct - pStkComprometido)
                    THEN DO:
                    ASSIGN
                        /* Stock Disponible Despachante */
                        T-MATE-2.StkAct = (B-MATE2.StkAct - pStkComprometido)
                        /* Stock Maximo Despachante CD: (Stock Maximo + Seguridad) Tienda: Stock Maximo */
                        T-MATE-2.StkMin = B-MATE2.StkMin       /*B-MATE2.StockMax*/
                        .
                END.
                ELSE DO:
                END.
            END.
        END.
    END.
    OTHERWISE DO:    /* ES UNA TIENDA */
        /* Almacén NO PRINCIPAL */
        FIND B-MATE2 OF B-MATE NO-LOCK NO-ERROR.
        CREATE T-MATE-2.
        BUFFER-COPY B-MATE2
            EXCEPT B-MATE2.StkAct B-MATE2.StkMin B-MATE2.StkRep B-MATE2.StkComprometido B-MATE2.StkActCbd
            TO T-MATE-2.
        pStkComprometido = fStockComprometido(B-MATE2.CodMat, B-MATE2.CodAlm).
        /*pStkComprometido = B-MATE2.StkComprometido.*/
        ASSIGN
            T-MATE-2.StkAct = B-MATE2.StkAct - pStkComprometido
            T-MATE-2.StkMin = B-MATE2.StockMax         /* Solo el Stock Maximo */
            .
    END.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resumimos-por-Marca B-table-Win 
PROCEDURE Resumimos-por-Marca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER s-acceso-total AS LOG.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR T-DREPO-2.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR T-DREPO-3.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR T-DREPO-4.
    
DEF VAR n-Items AS INT NO-UNDO.

FOR EACH T-DREPO WHERE {&Condicion} NO-LOCK,
    FIRST Almmmatg OF T-DREPO WHERE {&Condicion2} NO-LOCK,
    FIRST Almmmate OF INTEGRAL.Almmmatg
    WHERE Almmmate.CodAlm = s-CodAlm NO-LOCK,
    FIRST Almtfami OF INTEGRAL.Almmmatg NO-LOCK,
    FIRST AlmSFami OF INTEGRAL.Almmmatg NO-LOCK
    BREAK BY T-DREPO.AlmPed BY Almmmatg.DesMar:
    IF FIRST-OF(T-DREPO.AlmPed) OR FIRST-OF(Almmmatg.DesMar) THEN DO:
        /* Inicializamos */
        EMPTY TEMP-TABLE T-DREPO-2.
    END.
    CREATE T-DREPO-2.
    BUFFER-COPY T-DREPO TO T-DREPO-2.
    IF LAST-OF(T-DREPO.AlmPed) OR LAST-OF(Almmmatg.DesMar) THEN DO:
        IF s-acceso-total = YES THEN DO:    /* ABASTECIMIENTOS: SI CUENTA */
            /* Contamos */
            n-Items = 0.
            FOR EACH T-DREPO-2:
                n-Items = n-Items + 1.
            END.
            /* Grabamos en tablas diferentes */
            IF n-Items >= 10 THEN DO:
                FOR EACH T-DREPO-2 NO-LOCK:
                    CREATE T-DREPO-3.
                    BUFFER-COPY T-DREPO-2 TO T-DREPO-3.
                END.
            END.
            ELSE DO:
                FOR EACH T-DREPO-2 NO-LOCK:
                    CREATE T-DREPO-4.
                    BUFFER-COPY T-DREPO-2 TO T-DREPO-4.
                END.
            END.
        END.
        ELSE DO:                            /* ALMACENES: NO CUENTA */
            FOR EACH T-DREPO-2 NO-LOCK:
                CREATE T-DREPO-4.
                BUFFER-COPY T-DREPO-2 TO T-DREPO-4.
            END.
        END.
    END.
    DELETE T-DREPO. /* OJO */
END.

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
  {src/adm/template/snd-list.i "T-DREPO"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "Almmmate"}
  {src/adm/template/snd-list.i "Almtfami"}
  {src/adm/template/snd-list.i "AlmSFami"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Totales B-table-Win 
PROCEDURE Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Total AS DEC NO-UNDO.
DEF VAR x-Peso AS DEC NO-UNDO.
DEF VAR x-Volumen AS DEC NO-UNDO.
DEF VAR x-Stock AS DEC NO-UNDO.
DEF VAR x-Transferencias AS DEC NO-UNDO.
DEF VAR x-Compras AS DEC NO-UNDO.
DEF VAR x-CtoRep AS DEC NO-UNDO.
DEF VAR x-Items AS INT NO-UNDO.

x-Items = 0.

FOR EACH BT-DREPO WHERE {&CondicionX} NO-LOCK,
    FIRST Almmmatg OF BT-DREPO WHERE {&CondicionX2} NO-LOCK,
    FIRST Almmmate OF Almmmatg
    WHERE Almmmate.CodAlm = s-CodAlm NO-LOCK,
    FIRST Almtfami OF Almmmatg NO-LOCK,
    FIRST AlmSFami OF Almmmatg NO-LOCK:
    ASSIGN
        x-CtoRep = (IF Almmmatg.MonVta = 2 THEN Almmmatg.CtoTot * Almmmatg.TpoCmb ELSE Almmmatg.CToTot)
        x-Items = x-Items + 1
        .
    ASSIGN
        x-Total = x-Total + (BT-DREPO.CanGen * x-CtoRep)
        x-Peso = x-Peso + (BT-DREPO.CanGen * Almmmatg.Pesmat)
        x-Volumen = x-Volumen + (BT-DREPO.CanGen * Almmmatg.Libre_d02 / 1000000)
        x-Stock = x-Stock + (BT-DREPO.SolStkDis * x-CtoRep)
        x-Transferencias = x-Transferencias + (BT-DREPO.SolStkTra *  x-CtoRep)
        x-Compras = x-Compras + (BT-DREPO.SolCmpTra * x-CtoRep)
    .
END.
RUN Procesa-Handle IN lh_handle ('Totales|' + STRING(x-Total) + '|' +
                                 STRING(x-Peso) + '|' +
                                 STRING(x-Volumen) + '|' +
                                 STRING(x-Stock) + '|' +
                                 STRING(x-Transferencias) + '|' +
                                 STRING(x-Compras) + '|' +
                                 STRING(x-Items)
                                 ).

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

DEF VAR pComprometido AS DEC NO-UNDO.
DEF VAR x-StkAct AS DEC NO-UNDO.

RUN GET-ATTRIBUTE('adm-new-record').
IF RETURN-VALUE = 'YES' THEN DO:
    FIND FIRST bt-drepo WHERE bt-drepo.codmat = T-DREPO.CodMat:SCREEN-VALUE IN BROWSE {&browse-name}
        AND BT-DREPO.AlmPed = T-DREPO.AlmPed:SCREEN-VALUE IN BROWSE {&browse-name}
        AND ROWID(BT-DREPO) <> ROWID(T-DREPO)
        NO-LOCK NO-ERROR.
    IF AVAILABLE bt-drepo THEN DO:
        MESSAGE 'Material ya registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':U TO T-DREPO.AlmPed IN BROWSE {&browse-name}.
        RETURN 'ADM-ERROR'.
    END.
END.
ELSE DO:

END.
IF DECIMAL(T-DREPO.CanReq:SCREEN-VALUE IN BROWSE {&browse-name}) < 0 THEN DO:
    MESSAGE 'La cantidad debe ser mayor o igual a cero' VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry':U TO T-DREPO.CanReq IN BROWSE {&browse-name}.
    RETURN 'ADM-ERROR'.
END.
/* Dos casos:
Automático: debe ser un almacén de reposición
Manual: debe ser un almacén de venta
*/
/* ************************************************* */
/* RHC 03/07/2017 Siempre debe hacer la consistencia */
/* ************************************************* */
FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = T-DREPO.AlmPed:SCREEN-VALUE IN BROWSE {&browse-name}
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almacen /*OR Almacen.Campo-C[6] = "No"*/ THEN DO:
    MESSAGE 'Almacén NO válido' VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry':U TO T-DREPO.AlmPed IN BROWSE {&browse-name}.
    RETURN 'ADM-ERROR'.
END.
FIND Almmmate WHERE Almmmate.codcia = s-codcia
    AND Almmmate.codalm = s-CodAlm
    AND Almmmate.codmat = T-DREPO.CodMat:SCREEN-VALUE IN BROWSE {&browse-name}
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmate THEN DO:
    MESSAGE 'Código NO asignado en el almacén' s-CodAlm
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry':U TO T-DREPO.CodMat IN BROWSE {&browse-name}.
    RETURN 'ADM-ERROR'.
END.
FIND Almmmate WHERE Almmmate.codcia = s-codcia
    AND Almmmate.codalm = T-DREPO.AlmPed:SCREEN-VALUE IN BROWSE {&browse-name}
    AND Almmmate.codmat = T-DREPO.CodMat:SCREEN-VALUE IN BROWSE {&browse-name}
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmate THEN DO:
    MESSAGE 'Código NO asignado en el almacén' T-DREPO.AlmPed:SCREEN-VALUE IN BROWSE {&browse-name}
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry':U TO T-DREPO.CodMat IN BROWSE {&browse-name}.
    RETURN 'ADM-ERROR'.
END.
/* Control de stock */
ASSIGN
    x-StkAct = Almmmate.StkAct.
/* DESCONTAMOS LO COMPROMETIDO */
RUN gn/Stock-Comprometido-v2 (Almmmate.CodMat, Almmmate.CodAlm, NO, OUTPUT pComprometido).
/*RUN vta2/Stock-Comprometido-v2 (Almmmate.CodMat, Almmmate.CodAlm, OUTPUT pComprometido).*/
x-StkAct = x-StkAct - pComprometido.
IF x-StkAct < INPUT T-DREPO.CanReq THEN DO:
    MESSAGE 'NO hay stock suficiente' SKIP
        '      Stock actual:' Almmmate.StkACt SKIP
        'Stock comprometido:' pComprometido
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry':U TO T-DREPO.CanReq IN BROWSE {&browse-name}.
    RETURN 'ADM-ERROR'.
END.

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

IF LOOKUP(T-DREPO.AlmPed, '997,998') > 0 AND T-DREPO.ControlDespacho = NO
    THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fClasificacion B-table-Win 
FUNCTION fClasificacion RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND Almcfggn WHERE Almcfggn.codcia = s-codcia NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almcfggn THEN RETURN Almmmatg.TipRot[1].
  FIND FacTabla WHERE FacTabla.CodCia = s-codcia 
      AND FacTabla.Tabla = 'RANKVTA'
      AND FacTabla.Codigo = Almmmatg.codmat
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacTabla THEN RETURN Almmmatg.TipRot[1].
  FIND gn-divi WHERE gn-divi.codcia = s-codcia
      AND gn-divi.coddiv = s-coddiv
      NO-LOCK NO-ERROR.
  CASE TRUE:
      WHEN Almcfggn.Temporada = "C" THEN DO:
          IF GN-DIVI.CanalVenta = "MIN" THEN RETURN FacTabla.Campo-C[2].
          ELSE RETURN FacTabla.Campo-C[3].
      END.
      WHEN Almcfggn.Temporada = "NC" THEN DO:
          IF GN-DIVI.CanalVenta = "MIN" THEN RETURN FacTabla.Campo-C[5].
          ELSE RETURN FacTabla.Campo-C[6].
      END.
  END CASE.


  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCompraTransito B-table-Win 
FUNCTION fCompraTransito RETURNS DECIMAL
  ( INPUT pCodAlm AS CHAR, INPUT pCodMat AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND OOComPend WHERE OOComPend.CodAlm = pCodAlm
        AND OOComPend.CodMat = pCodMat
        NO-LOCK NO-ERROR.
    IF AVAILABLE OOComPend THEN RETURN (OOComPend.CanPed - OOComPend.CanAte).
    ELSE RETURN 0.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fFSDespacho B-table-Win 
FUNCTION fFSDespacho RETURNS DECIMAL
  ( INPUT pAlmPed AS CHAR, INPUT pCodMat AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF BUFFER B-MATE FOR Almmmate.
  FIND B-MATE WHERE B-MATE.codcia = s-codcia
      AND B-MATE.codalm = pAlmPed
      AND B-MATE.codmat = pCodMat
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE B-MATE THEN RETURN 0.00.

  DEF VAR pStkComprometido AS DEC NO-UNDO.
  DEF VAR pStockTransito AS DEC NO-UNDO.

  pStkComprometido = fStockComprometido(B-MATE.CodMat, B-MATE.CodAlm).
  /*pStkComprometido = B-MATE.StkComprometido.*/
  pStockTransito =  fStockTransito(B-MATE.codcia,B-MATE.codalm,B-MATE.codmat).
  CASE x-TipoCalculo:
      WHEN "GRUPO" THEN DO:
          RETURN (B-MATE.StkAct + pStockTransito - pStkComprometido - B-MATE.StkMin).
      END.
      WHEN "TIENDA" THEN DO:
          RETURN (B-MATE.StkAct - pStkComprometido - B-MATE.StockMax).
      END.
      OTHERWISE RETURN 0.00.
  END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fStkDisponible B-table-Win 
FUNCTION fStkDisponible RETURNS DECIMAL
  ( INPUT pCodAlm AS CHAR,
    INPUT pCodMat AS CHAR ):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF BUFFER B-MATE FOR Almmmate.
  DEF VAR pStkComprometido AS DEC NO-UNDO.

  FIND FIRST B-MATE WHERE B-MATE.codcia = s-codcia
      AND B-MATE.codalm = pCodAlm
      AND B-MATE.codmat = pCodMat
      NO-LOCK NO-ERROR.
  IF AVAILABLE B-MATE THEN DO:
      pStkComprometido = fStockComprometido(B-MATE.CodMat, B-MATE.CodAlm).
      RETURN (B-MATE.StkAct - pStkComprometido).
  END.
  ELSE RETURN 0.00.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fStockComprometido B-table-Win 
FUNCTION fStockComprometido RETURNS DECIMAL
  ( INPUT pCodMat AS CHAR, INPUT pCodAlm AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-StockComprometido AS DEC NO-UNDO.

  /*RUN vta2/stock-comprometido-v2 (pCodMat, pCodAlm, OUTPUT x-StockComprometido).*/
  RUN gn/stock-comprometido-v2 (pCodMat, pCodAlm, NO, OUTPUT x-StockComprometido).
  RETURN x-StockComprometido.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fStockTransito B-table-Win 
FUNCTION fStockTransito RETURNS DECIMAL
  ( INPUT pCodCia AS INT,
    INPUT pCodAlm AS CHAR,
    INPUT pCodMat AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    /* En Tránsito */
    DEF VAR x-Total AS DEC NO-UNDO.
    RUN alm\p-articulo-en-transito (
        pCodCia,
        pCodAlm,
        pCodMat,
        INPUT-OUTPUT TABLE tmp-tabla,
        OUTPUT x-Total).

    RETURN x-Total.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

