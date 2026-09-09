&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-MATE FOR Almmmate.
DEFINE BUFFER B-MATE2 FOR Almmmate.
DEFINE SHARED TEMP-TABLE T-DREPO LIKE almdrepo
       FIELD SolStkAct AS DEC
       FIELD SolStkCom AS DEC
       FIELD SolStkDis AS DEC
       FIELD SolStkMax AS DEC
       FIELD SolStkTra AS DEC
       FIELD DesStkAct AS DEC
       FIELD DesStkCom AS DEC
       FIELD DesStkDis AS DEC
       FIELD DesStkMax AS DEC
       FIELD PorcReposicion AS DEC
       FIELD FSGrupo AS DEC
       FIELD GrpStkDis AS DEC
       FIELD ControlDespacho AS LOG INITIAL NO
       FIELD VtaGrp30 AS DEC
       FIELD VtaGrp60 AS DEC
       FIELD VtaGrp90 AS DEC
       FIELD VtaGrp30y AS DEC
       FIELD DesCmpTra AS DEC
       FIELD VtaGrp60y AS DEC
       FIELD VtaGrp90y AS DEC
       FIELD DesStkTra AS DEC
       FIELD ClfGral AS CHAR
       FIELD ClfMayo AS CHAR
       FIELD ClfUtil AS CHAR
       FIELD SolCmpTra AS DEC
       .
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
(COMBO-BOX-Almacen = 'Todos' OR T-DREPO.AlmPed = COMBO-BOX-Almacen) )

&SCOPED-DEFINE Condicion2 (COMBO-BOX-Marcas = 'Todas' OR LOOKUP(Almmmatg.DesMar,COMBO-BOX-Marcas) > 0) ~
AND (COMBO-BOX-Lineas = 'Todas' OR LOOKUP(Almmmatg.CodFam,COMBO-BOX-Lineas) > 0) ~
AND (COMBO-BOX-SubLineas = 'Todas' OR LOOKUP(Almmmatg.SubFam,COMBO-BOX-SubLineas) > 0)

&SCOPED-DEFINE CondicionX ( (COMBO-BOX-ClfGral = 'Todas' OR BT-DREPO.ClfGral = COMBO-BOX-ClfGral) AND ~
(COMBO-BOX-ClfMayo = 'Todas' OR BT-DREPO.ClfMayo = COMBO-BOX-ClfMayo) AND ~
(COMBO-BOX-ClfUtil = 'Todas' OR BT-DREPO.ClfUtil = COMBO-BOX-ClfUtil) AND ~
(COMBO-BOX-Almacen = 'Todos' OR BT-DREPO.AlmPed = COMBO-BOX-Almacen) )

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
    INDEX llave01 AS PRIMARY NroItm
    .

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
Almmmatg.DesMat Almmmatg.DesMar Almmmatg.UndBas T-DREPO.AlmPed ~
T-DREPO.CanReq T-DREPO.CanGen T-DREPO.SolStkDis @ x-SolStkDis ~
T-DREPO.SolStkMax @ x-SolStkMax T-DREPO.SolStkTra @ x-SolStkTra ~
T-DREPO.SolCmpTra @ x-SolCmpTra ~
fStkDisponible(T-DREPO.AlmPed,T-DREPO.CodMat) @ x-StkDisponible ~
fFSDespacho(T-DREPO.AlmPed,T-DREPO.CodMat) @ x-SaldoTienda ~
T-DREPO.GrpStkDis @ x-DesStkDis T-DREPO.FSGrupo @ x-SaldoGrupo ~
T-DREPO.DesStkMax @ x-DesStkMax Almmmate.StkMax Almmmatg.CanEmp ~
T-DREPO.CanGen * (IF Almmmatg.MonVta = 2 THEN Almmmatg.CtoTot * Almmmatg.TpoCmb ELSE Almmmatg.CToTot) @ Almmmatg.CtoTot ~
T-DREPO.Origen T-DREPO.ClfGral @ x-ClfGral T-DREPO.ClfMayo @ x-ClfMayo ~
T-DREPO.ClfUtil @ x-ClfUtil (T-DREPO.CanGen * Almmmatg.Pesmat ) @ x-Peso ~
(T-DREPO.CanGen * Almmmatg.Libre_d02 / 1000000) @ x-Volumen Almmmate.StkAct ~
fStockComprometido(T-DREPO.CodAlm,T-DREPO.CodMat) @ x-StockComprometido ~
T-DREPO.PorcReposicion @ x-PorcReposicion Almmmatg.CodFam Almtfami.desfam ~
AlmSFami.subfam AlmSFami.dessub 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table T-DREPO.CodMat ~
T-DREPO.AlmPed T-DREPO.CanReq 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table T-DREPO
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table T-DREPO
&Scoped-define QUERY-STRING-br_table FOR EACH T-DREPO WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST Almmmatg OF T-DREPO ~
      WHERE {&Condicion2} NO-LOCK, ~
      FIRST Almmmate OF Almmmatg ~
      WHERE Almmmate.CodAlm = s-codalm NO-LOCK, ~
      FIRST Almtfami OF Almmmatg NO-LOCK, ~
      FIRST AlmSFami OF Almmmatg NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-DREPO WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST Almmmatg OF T-DREPO ~
      WHERE {&Condicion2} NO-LOCK, ~
      FIRST Almmmate OF Almmmatg ~
      WHERE Almmmate.CodAlm = s-codalm NO-LOCK, ~
      FIRST Almtfami OF Almmmatg NO-LOCK, ~
      FIRST AlmSFami OF Almmmatg NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table T-DREPO Almmmatg Almmmate Almtfami ~
AlmSFami
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-DREPO
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg
&Scoped-define THIRD-TABLE-IN-QUERY-br_table Almmmate
&Scoped-define FOURTH-TABLE-IN-QUERY-br_table Almtfami
&Scoped-define FIFTH-TABLE-IN-QUERY-br_table AlmSFami


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-1 COMBO-BOX-Almacen ~
COMBO-BOX-Marcas COMBO-BOX-Lineas COMBO-BOX-SubLineas COMBO-BOX-ClfGral ~
COMBO-BOX-ClfMayo COMBO-BOX-ClfUtil br_table 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-1 COMBO-BOX-Almacen ~
FILL-IN-Master FILL-IN-Inner FILL-IN-Reposicion FILL-IN-Estado ~
COMBO-BOX-Marcas COMBO-BOX-Lineas COMBO-BOX-SubLineas COMBO-BOX-ClfGral ~
COMBO-BOX-ClfMayo COMBO-BOX-ClfUtil 

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
Codigo|y||INTEGRAL.Almmmatg.codmat|yes
Descripción|||INTEGRAL.Almmmatg.DesMat|yes
Unidad|||INTEGRAL.Almmmatg.UndBas|yes
Marca|||INTEGRAL.Almmmatg.DesMar|yes
Almacén Despacho|||T-DREPO.AlmPed|yes
Cantidad Generada (Desc.)|||T-DREPO.CanGen|no
% de Reposición|||T-DREPO.PorcReposicion|no
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "':U + 'Codigo,Descripción,Unidad,Marca,Almacén Despacho,Cantidad Generada (Desc.),% de Reposición' + '",
     SortBy-Case = ':U + 'Codigo').

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
  ( INPUT pCodAlm AS CHAR, INPUT pCodMat AS CHAR )  FORWARD.

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
DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U INITIAL "Codigo" 
     LABEL "Ordenado por" 
     VIEW-AS COMBO-BOX INNER-LINES 7
     LIST-ITEMS "Codigo","Descripción","Marca","Almacén Despacho","Unidad","Cantidad Generada (Desc.)","% de Reposición" 
     DROP-DOWN-LIST
     SIZE 23 BY 1 NO-UNDO.

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

DEFINE VARIABLE COMBO-BOX-Lineas AS CHARACTER FORMAT "X(256)":U 
     LABEL "Linea" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "Todas","Todas"
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Marcas AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "Todas","Todas"
     DROP-DOWN-LIST
     SIZE 23 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-SubLineas AS CHARACTER FORMAT "X(256)":U 
     LABEL "SubLinea" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "Todas","Todas"
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

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
      T-DREPO.Item FORMAT ">,>>9":U
      T-DREPO.CodMat COLUMN-LABEL "<Codigo>" FORMAT "X(14)":U WIDTH 6.57
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 38.29
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(15)":U WIDTH 8.57
      Almmmatg.UndBas COLUMN-LABEL "Unidad" FORMAT "X(7)":U WIDTH 5.72
      T-DREPO.AlmPed COLUMN-LABEL "Almacén!Despacho" FORMAT "x(5)":U
      T-DREPO.CanReq COLUMN-LABEL "Cantidad!Requerida" FORMAT "-ZZZ,ZZ9.99":U
            WIDTH 8.43
      T-DREPO.CanGen FORMAT "ZZZ,ZZ9.99":U WIDTH 7.43 COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 11
      T-DREPO.SolStkDis @ x-SolStkDis COLUMN-LABEL "Disponible!Solicitante" FORMAT "(ZZZ,ZZ9.99)":U
      T-DREPO.SolStkMax @ x-SolStkMax COLUMN-LABEL "Stock Máximo!Solicitante" FORMAT "ZZZ,ZZ9.99":U
      T-DREPO.SolStkTra @ x-SolStkTra COLUMN-LABEL "Tránsito!Solicitante" FORMAT "ZZZ,ZZ9.99":U
      T-DREPO.SolCmpTra @ x-SolCmpTra COLUMN-LABEL "Compras en!Tránsito" FORMAT "ZZZ,ZZ9.99":U
            WIDTH 8.72
      fStkDisponible(T-DREPO.AlmPed,T-DREPO.CodMat) @ x-StkDisponible COLUMN-LABEL "Disponible!Despacho" FORMAT "(ZZZ,ZZZ,ZZ9.99)":U
            WIDTH 9.29 COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 13
      fFSDespacho(T-DREPO.AlmPed,T-DREPO.CodMat) @ x-SaldoTienda COLUMN-LABEL "Faltante/Sobrante!Despacho" FORMAT "(ZZZ,ZZZ,ZZ9.99)":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      T-DREPO.GrpStkDis @ x-DesStkDis COLUMN-LABEL "Disponible!Grupo" FORMAT "(ZZZ,ZZZ,ZZ9.99)":U
            WIDTH 9.29
      T-DREPO.FSGrupo @ x-SaldoGrupo COLUMN-LABEL "Faltante/Sobrante!Grupo" FORMAT "(ZZZ,ZZZ,ZZ9.99)":U
      T-DREPO.DesStkMax @ x-DesStkMax COLUMN-LABEL "Stock Máximo!Despacho" FORMAT "ZZZ,ZZ9.99":U
      Almmmate.StkMax COLUMN-LABEL "Empaque!Reposición" FORMAT "ZZZ,ZZ9.99":U
      Almmmatg.CanEmp COLUMN-LABEL "Empaque!Master" FORMAT "->>,>>9.99":U
      T-DREPO.CanGen * (IF Almmmatg.MonVta = 2 THEN Almmmatg.CtoTot * Almmmatg.TpoCmb ELSE Almmmatg.CToTot) @ Almmmatg.CtoTot COLUMN-LABEL "Costo de!Reposición"
            WIDTH 9.72
      T-DREPO.Origen FORMAT "x(3)":U
      T-DREPO.ClfGral @ x-ClfGral COLUMN-LABEL "Clasf!Gral" FORMAT "X":U
      T-DREPO.ClfMayo @ x-ClfMayo COLUMN-LABEL "Clasf.!Mayorista" FORMAT "x":U
      T-DREPO.ClfUtil @ x-ClfUtil COLUMN-LABEL "Clasf.!Utilex" FORMAT "x":U
      (T-DREPO.CanGen * Almmmatg.Pesmat ) @ x-Peso COLUMN-LABEL "Peso en Kg" FORMAT ">>>,>>9.99":U
      (T-DREPO.CanGen * Almmmatg.Libre_d02 / 1000000) @ x-Volumen COLUMN-LABEL "Volumen en m3" FORMAT ">>>,>>9.99":U
      Almmmate.StkAct COLUMN-LABEL "Stock!Actual" FORMAT "(ZZZ,ZZ9.99)":U
            WIDTH 7.14
      fStockComprometido(T-DREPO.CodAlm,T-DREPO.CodMat) @ x-StockComprometido COLUMN-LABEL "Stock!Reservado" FORMAT "->>>,>>9.99":U
      T-DREPO.PorcReposicion @ x-PorcReposicion COLUMN-LABEL "% de!Reposición"
      Almmmatg.CodFam COLUMN-LABEL "Linea" FORMAT "X(3)":U
      Almtfami.desfam FORMAT "X(30)":U
      AlmSFami.subfam COLUMN-LABEL "SubLinea" FORMAT "X(3)":U
      AlmSFami.dessub FORMAT "X(30)":U
  ENABLE
      T-DREPO.CodMat
      T-DREPO.AlmPed
      T-DREPO.CanReq
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 141 BY 12.38
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-1 AT ROW 1 COL 10 COLON-ALIGNED WIDGET-ID 6
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
     br_table AT ROW 2.88 COL 1
     "F8 : Stocks x Almacenes F7 : Pedidos F9 : Ingresos en Tránsito" VIEW-AS TEXT
          SIZE 62 BY .5 AT ROW 15.27 COL 2 WIDGET-ID 12
          FONT 0
     "F10: Kardex Almacén Despacho  F11: Faltante/Sobrante" VIEW-AS TEXT
          SIZE 54 BY .5 AT ROW 15.27 COL 66 WIDGET-ID 68
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
      TABLE: T-DREPO T "SHARED" ? INTEGRAL almdrepo
      ADDITIONAL-FIELDS:
          FIELD SolStkAct AS DEC
          FIELD SolStkCom AS DEC
          FIELD SolStkDis AS DEC
          FIELD SolStkMax AS DEC
          FIELD SolStkTra AS DEC
          FIELD DesStkAct AS DEC
          FIELD DesStkCom AS DEC
          FIELD DesStkDis AS DEC
          FIELD DesStkMax AS DEC
          FIELD PorcReposicion AS DEC
          FIELD FSGrupo AS DEC
          FIELD GrpStkDis AS DEC
          FIELD ControlDespacho AS LOG INITIAL NO
          FIELD VtaGrp30 AS DEC
          FIELD VtaGrp60 AS DEC
          FIELD VtaGrp90 AS DEC
          FIELD VtaGrp30y AS DEC
          FIELD DesCmpTra AS DEC
          FIELD VtaGrp60y AS DEC
          FIELD VtaGrp90y AS DEC
          FIELD DesStkTra AS DEC
          FIELD ClfGral AS CHAR
          FIELD ClfMayo AS CHAR
          FIELD ClfUtil AS CHAR
          FIELD SolCmpTra AS DEC
          
      END-FIELDS.
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
         HEIGHT             = 16.42
         WIDTH              = 142.29.
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
/* BROWSE-TAB br_table COMBO-BOX-ClfUtil F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 8.

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
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST, FIRST, FIRST, FIRST"
     _Where[1]         = "{&Condicion}"
     _Where[2]         = "{&Condicion2}"
     _Where[3]         = "INTEGRAL.Almmmate.CodAlm = s-codalm"
     _FldNameList[1]   = Temp-Tables.T-DREPO.Item
     _FldNameList[2]   > Temp-Tables.T-DREPO.CodMat
"T-DREPO.CodMat" "<Codigo>" "X(14)" "character" ? ? ? ? ? ? yes ? no no "6.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "38.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(15)" "character" ? ? ? ? ? ? no ? no no "8.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.Almmmatg.UndBas
"Almmmatg.UndBas" "Unidad" "X(7)" "character" ? ? ? ? ? ? no ? no no "5.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-DREPO.AlmPed
"T-DREPO.AlmPed" "Almacén!Despacho" "x(5)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-DREPO.CanReq
"T-DREPO.CanReq" "Cantidad!Requerida" "-ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? yes ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-DREPO.CanGen
"T-DREPO.CanGen" ? "ZZZ,ZZ9.99" "decimal" 11 9 ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"T-DREPO.SolStkDis @ x-SolStkDis" "Disponible!Solicitante" "(ZZZ,ZZ9.99)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"T-DREPO.SolStkMax @ x-SolStkMax" "Stock Máximo!Solicitante" "ZZZ,ZZ9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"T-DREPO.SolStkTra @ x-SolStkTra" "Tránsito!Solicitante" "ZZZ,ZZ9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"T-DREPO.SolCmpTra @ x-SolCmpTra" "Compras en!Tránsito" "ZZZ,ZZ9.99" ? ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"fStkDisponible(T-DREPO.AlmPed,T-DREPO.CodMat) @ x-StkDisponible" "Disponible!Despacho" "(ZZZ,ZZZ,ZZ9.99)" ? 13 15 ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"fFSDespacho(T-DREPO.AlmPed,T-DREPO.CodMat) @ x-SaldoTienda" "Faltante/Sobrante!Despacho" "(ZZZ,ZZZ,ZZ9.99)" ? 14 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"T-DREPO.GrpStkDis @ x-DesStkDis" "Disponible!Grupo" "(ZZZ,ZZZ,ZZ9.99)" ? ? ? ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > "_<CALC>"
"T-DREPO.FSGrupo @ x-SaldoGrupo" "Faltante/Sobrante!Grupo" "(ZZZ,ZZZ,ZZ9.99)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > "_<CALC>"
"T-DREPO.DesStkMax @ x-DesStkMax" "Stock Máximo!Despacho" "ZZZ,ZZ9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > INTEGRAL.Almmmate.StkMax
"Almmmate.StkMax" "Empaque!Reposición" "ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > INTEGRAL.Almmmatg.CanEmp
"Almmmatg.CanEmp" "Empaque!Master" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > "_<CALC>"
"T-DREPO.CanGen * (IF Almmmatg.MonVta = 2 THEN Almmmatg.CtoTot * Almmmatg.TpoCmb ELSE Almmmatg.CToTot) @ Almmmatg.CtoTot" "Costo de!Reposición" ? ? ? ? ? ? ? ? no ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   = Temp-Tables.T-DREPO.Origen
     _FldNameList[22]   > "_<CALC>"
"T-DREPO.ClfGral @ x-ClfGral" "Clasf!Gral" "X" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > "_<CALC>"
"T-DREPO.ClfMayo @ x-ClfMayo" "Clasf.!Mayorista" "x" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[24]   > "_<CALC>"
"T-DREPO.ClfUtil @ x-ClfUtil" "Clasf.!Utilex" "x" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[25]   > "_<CALC>"
"(T-DREPO.CanGen * Almmmatg.Pesmat ) @ x-Peso" "Peso en Kg" ">>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[26]   > "_<CALC>"
"(T-DREPO.CanGen * Almmmatg.Libre_d02 / 1000000) @ x-Volumen" "Volumen en m3" ">>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[27]   > INTEGRAL.Almmmate.StkAct
"Almmmate.StkAct" "Stock!Actual" "(ZZZ,ZZ9.99)" "decimal" ? ? ? ? ? ? no ? no no "7.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[28]   > "_<CALC>"
"fStockComprometido(T-DREPO.CodAlm,T-DREPO.CodMat) @ x-StockComprometido" "Stock!Reservado" "->>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[29]   > "_<CALC>"
"T-DREPO.PorcReposicion @ x-PorcReposicion" "% de!Reposición" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[30]   > INTEGRAL.Almmmatg.CodFam
"Almmmatg.CodFam" "Linea" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[31]   = INTEGRAL.Almtfami.desfam
     _FldNameList[32]   > INTEGRAL.AlmSFami.subfam
"AlmSFami.subfam" "SubLinea" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[33]   = INTEGRAL.AlmSFami.dessub
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
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' 
      THEN T-DREPO.CanReq:SCREEN-VALUE IN BROWSE {&browse-name} = '0.00'.


/*   IF AVAILABLE T-DREPO AND T-DREPO.Origen = 'AUT'                 */
/*   THEN DO:                                                        */
/*       ASSIGN                                                      */
/*           T-DREPO.CodMat:READ-ONLY = YES                          */
/*           T-DREPO.AlmPed:READ-ONLY = YES.                         */
/*       APPLY 'entry':U TO T-DREPO.CanReq IN BROWSE {&browse-name}. */
/*   END.                                                            */
/*   ELSE DO:                                                        */
/*       ASSIGN                                                      */
/*           T-DREPO.CodMat:READ-ONLY = NO                           */
/*           T-DREPO.AlmPed:READ-ONLY = NO.                          */
/*       APPLY 'entry':U TO T-DREPO.CodMat IN BROWSE {&browse-name}. */
/*   END.                                                            */
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

/*     ASSIGN                                                              */
/*         SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),'999999') */
/*         NO-ERROR.                                                       */
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
        Almmmatg.DesMar Almmmatg.DesMat Almmmatg.UndBas
        WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-DREPO.AlmPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DREPO.AlmPed br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF T-DREPO.AlmPed IN BROWSE br_table /* Almacén!Despacho */
DO:
/*     FIND Almmmatg WHERE Almmmatg.codcia = s-codcia                                                   */
/*         AND Almmmatg.codmat = T-DREPO.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} NO-LOCK NO-ERROR. */
/*     IF AVAILABLE Almmmatg                                                                            */
/*         THEN DISPLAY Almmmatg.DesMat Almmmatg.DesMar Almmmatg.UndBas                                 */
/*                   WITH BROWSE {&browse-name}.                                                        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


&Scoped-define SELF-NAME COMBO-BOX-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-1 B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-1 IN FRAME F-Main /* Ordenado por */
DO:
    RUN set-attribute-list('SortBy-Case=' + SELF:SCREEN-VALUE).
    RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Almacen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Almacen B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Almacen IN FRAME F-Main /* Almacén Despacho */
DO:
    ASSIGN {&SELF-NAME}.
    /*{&OPEN-QUERY-{&BROWSE-NAME}}*/
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    RUN Totales.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-ClfGral
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-ClfGral B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-ClfGral IN FRAME F-Main /* Clf. Gral. */
DO:
    ASSIGN {&SELF-NAME}.
    /*{&OPEN-QUERY-{&BROWSE-NAME}}*/
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    RUN Totales.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-ClfMayo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-ClfMayo B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-ClfMayo IN FRAME F-Main /* Clf. Mayor. */
DO:
    ASSIGN {&SELF-NAME}.
    /*{&OPEN-QUERY-{&BROWSE-NAME}}*/
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    RUN Totales.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-ClfUtil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-ClfUtil B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-ClfUtil IN FRAME F-Main /* Clf. Util. */
DO:
    ASSIGN {&SELF-NAME}.
    /*{&OPEN-QUERY-{&BROWSE-NAME}}*/
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    RUN Totales.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Lineas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Lineas B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Lineas IN FRAME F-Main /* Linea */
DO:
  ASSIGN {&SELF-NAME}.
  /*{&OPEN-QUERY-{&BROWSE-NAME}}*/
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
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


&Scoped-define SELF-NAME COMBO-BOX-SubLineas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-SubLineas B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-SubLineas IN FRAME F-Main /* SubLinea */
DO:
  ASSIGN {&SELF-NAME}.
  /*{&OPEN-QUERY-{&BROWSE-NAME}}*/
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

ON 'return':U OF T-DREPO.AlmPed, T-DREPO.CodMat, T-DREPO.CanReq
DO:
    APPLY 'tab':U.
    RETURN NO-APPLY.
END.

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
    WHEN 'Codigo':U THEN DO:
      &Scope SORTBY-PHRASE BY Almmmatg.codmat
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Descripción':U THEN DO:
      &Scope SORTBY-PHRASE BY Almmmatg.DesMat
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Unidad':U THEN DO:
      &Scope SORTBY-PHRASE BY Almmmatg.UndBas
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Marca':U THEN DO:
      &Scope SORTBY-PHRASE BY Almmmatg.DesMar
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Almacén Despacho':U THEN DO:
      &Scope SORTBY-PHRASE BY T-DREPO.AlmPed
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Cantidad Generada (Desc.)':U THEN DO:
      &Scope SORTBY-PHRASE BY T-DREPO.CanGen DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN '% de Reposición':U THEN DO:
      &Scope SORTBY-PHRASE BY T-DREPO.PorcReposicion DESCENDING
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
            ASSIGN
                /* Stock Disponible Solicitante */
                T-MATE.StkAct = T-MATE.StkAct + (B-MATE.StkAct - B-MATE.StkComprometido)
                T-MATE.StkComprometido = T-MATE.StkComprometido + B-MATE.StkComprometido
                /* Stock Maximo Solicitante (Stock Maximo + Seguridad) */
                T-MATE.StkMin = T-MATE.StkMin + B-MATE.StkMin
                /* Stock en Tránsito Solicitante */
                T-MATE.StkRep = T-MATE.StkRep + fStockTransito(B-MATE.CodCia,B-MATE.CodAlm,B-MATE.CodMat)
                /* Compras en Tránsito */
                T-MATE.StkActCbd = T-MATE.StkActCbd + fCompraTransito(B-MATE.CodAlm, B-MATE.CodMat)
                .
        END.    /* EACH TabGener */   
    END.
    WHEN NO THEN DO:   /* ES UNA TIENDA */
        CREATE T-MATE.
        BUFFER-COPY B-MATE 
            EXCEPT B-MATE.StkAct B-MATE.StkMin  B-MATE.StkRep B-MATE.StkComprometido B-MATE.StkActCbd
            TO T-MATE
            ASSIGN
            /* Stock Disponible Solicitante */
            T-MATE.StkAct = (B-MATE.StkAct - B-MATE.StkComprometido)
            T-MATE.StkComprometido = B-MATE.StkComprometido
            /* Stock Maximo Solicitante (Stock Maximo + Seguridad) */
            T-MATE.StkMin = B-MATE.StkMin
            /* Stock en Tránsito Solicitante */
            T-MATE.StkRep = fStockTransito(B-MATE.CodCia,B-MATE.CodAlm,B-MATE.CodMat)
            /* Compras en Tránsito */
            T-MATE.StkActCbd = fCompraTransito(B-MATE.CodAlm, B-MATE.CodMat)
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

DO WITH FRAME {&FRAME-NAME}:
    FOR EACH T-DREPO NO-LOCK,
        FIRST Almmmatg OF T-DREPO NO-LOCK, FIRST Almtfami OF Almmmatg NO-LOCK, FIRST Almsfami OF Almmmatg NO-LOCK:
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
    END.
    COMBO-BOX-Marcas = 'Todas'.
    COMBO-BOX-Lineas = 'Todas'.
    COMBO-BOX-SubLineas = 'Todas'.
    COMBO-BOX-Almacen = 'Todos'.
    COMBO-BOX-Marcas:LIST-ITEM-PAIRS = x-ListaMarcas.
    COMBO-BOX-Lineas:LIST-ITEM-PAIRS = x-ListaLineas.
    COMBO-BOX-SubLineas:LIST-ITEM-PAIRS = x-ListaSubLineas.
    COMBO-BOX-Almacen:LIST-ITEM-PAIRS = x-ListaAlmacenes.
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
DEF BUFFER B-MATG FOR Almmmatg.
DEF BUFFER B-MATE FOR Almmmate.

FOR EACH bt-drepo NO-LOCK, 
    FIRST B-MATG OF bt-drepo NO-LOCK,
    FIRST B-MATE NO-LOCK WHERE B-MATE.codcia = s-codcia
    AND B-MATE.codalm = s-codalm AND B-MATE.codmat = bt-drepo.codmat,
    FIRST Almtfami OF B-MATG NO-LOCK,
    FIRST Almsfami OF B-MATG NO-LOCK
    BY B-MATG.desmar BY B-MATG.desmat:
    x-NroItm = x-NroItm + 1.
    CREATE Detalle.
    BUFFER-COPY bt-drepo TO Detalle
        ASSIGN
        Detalle.nroitm = x-NroItm
        Detalle.desmat = B-MATG.desmat
        Detalle.desmar = B-MATG.desmar
        Detalle.undstk = B-MATG.undstk
        Detalle.DesStkDis = fStkDisponible(BT-DREPO.AlmPed,BT-DREPO.CodMat) 
        Detalle.FSDespacho = fFSDespacho(BT-DREPO.AlmPed,BT-DREPO.CodMat) 
        Detalle.empreposicion = B-MATE.stkmax
        Detalle.empmaster = B-MATG.canemp
        Detalle.ctototal = bt-drepo.CanGen * (IF B-MATG.MonVta = 2 THEN B-MATG.CtoTot * B-MATG.TpoCmb ELSE B-MATG.CtoTot)
        Detalle.peso = (bt-drepo.CanGen * B-MATG.Pesmat ) 
        Detalle.volumen = (bt-drepo.CanGen * B-MATG.Libre_d02 / 1000000)
        Detalle.SolStkAct = B-MATE.stkact
        Detalle.SolStkCom = fStockComprometido(BT-DREPO.CodAlm,BT-DREPO.CodMat)
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
      RUN vta2/stock-comprometido-v2 (T-DREPO.CodMat, T-DREPO.CodAlm, OUTPUT pComprometido).
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
          RUN vta2/Stock-Comprometido-v2 (B-MATE.CodMat, T-DREPO.AlmPed, OUTPUT pComprometido).
          T-DREPO.StkAct = B-MATE.StkAct - pComprometido.
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

DEF BUFFER BT-DREPO FOR T-DREPO.


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

  /*{&OPEN-QUERY-{&BROWSE-NAME}}*/
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).

  RUN Totales.

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
        RUN vta2/Stock-Comprometido-v2 (Almmmate.CodMat, Almmmate.codalm, OUTPUT pComprometido).
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
    FOR EACH T-DREPO USE-INDEX Llave03:
        /*FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Comprometido y tránsito " + T-DREPO.codmat.*/
        /* Comprometido */
        RUN vta2/stock-comprometido-v2 (T-DREPO.CodMat, T-DREPO.CodAlm, OUTPUT pComprometido).
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

/*     FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "". */
/*     FILL-IN-Mensaje:VISIBLE IN FRAME {&FRAME-NAME} = NO.      */

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
  COMBO-BOX-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  
  /* Code placed here will execute PRIOR to standard behavior. */
  MESSAGE 'dentro del assign statemnmet'.
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
  MESSAGE t-drepo.codcia SKIP t-drepo.codalm SKIP t-drepo.codmat SKIP t-drepo.almped SKIP t-drepo.origen.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record B-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  COMBO-BOX-1:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

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
/*   IF AVAILABLE T-DREPO AND T-DREPO.Origen = 'AUT' THEN DO: */
/*       MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.   */
/*       RETURN 'ADM-ERROR'.                                  */
/*   END.                                                     */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  ENABLE 
      COMBO-BOX-1 
      COMBO-BOX-Almacen 
      COMBO-BOX-ClfGral 
      COMBO-BOX-ClfMayo 
      COMBO-BOX-ClfUtil 
      COMBO-BOX-Lineas 
      COMBO-BOX-Marcas 
      COMBO-BOX-SubLineas 
      WITH FRAME {&FRAME-NAME}.

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
  DISABLE 
      COMBO-BOX-1 
      COMBO-BOX-Almacen 
      COMBO-BOX-ClfGral 
      COMBO-BOX-ClfMayo 
      COMBO-BOX-ClfUtil 
      COMBO-BOX-Lineas 
      COMBO-BOX-Marcas 
      COMBO-BOX-SubLineas 
      FILL-IN-Estado 
      FILL-IN-Inner 
      FILL-IN-Master 
      FILL-IN-Reposicion 
      WITH FRAME {&FRAME-NAME}.

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
  /*RUN Carga-Filtros.*/

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
  MESSAGE 'antes del update'.
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  COMBO-BOX-1:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
        WHEN "AlmPed" THEN 
            ASSIGN
                input-var-1 = s-codalm
                input-var-2 = ""
                input-var-3 = "".
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
            ASSIGN
                /* Stock Disponible Despachante */
                T-MATE-2.StkAct = T-MATE-2.StkAct + (B-MATE2.StkAct - B-MATE2.StkComprometido)
                /* Stock Maximo Despachante CD: (Stock Maximo + Seguridad) Tienda: Stock Maximo */
                T-MATE-2.StkMin = T-MATE-2.StkMin + (IF pOkSolicitante = YES THEN B-MATE2.StkMin ELSE B-MATE2.StockMax)
                /* Stock en Tránsito Solicitante */
                /*T-MATE-2.StkRep = T-MATE-2.StkRep + fStockTransito()*/
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
                /* RHC 16/06/2017 La CD o el Almacén? */
                IF (T-MATE-2.StkAct - T-MATE-2.StkMin) > (B-MATE2.StkAct - B-MATE2.StkComprometido)
                    THEN DO:
                    ASSIGN
                        /* Stock Disponible Despachante */
                        T-MATE-2.StkAct = (B-MATE2.StkAct - B-MATE2.StkComprometido)
                        /* Stock Maximo Despachante CD: (Stock Maximo + Seguridad) Tienda: Stock Maximo */
                        T-MATE-2.StkMin = B-MATE2.StkMin       /*B-MATE2.StockMax*/

                        /* Stock en Tránsito Solicitante */
                        /*T-MATE-2.StkRep = fStockTransito()*/
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
            EXCEPT B-MATE2.StkAct B-MATE2.StkMin B-MATE2.StkRep B-MATE.StkComprometido B-MATE.StkActCbd
            TO T-MATE-2
            ASSIGN
            T-MATE-2.StkAct = B-MATE2.StkAct - B-MATE2.StkComprometido
            T-MATE-2.StkMin = B-MATE2.StockMax         /* Solo el Stock Maximo */
            /*T-MATE-2.StkRep = fStockTransito()*/
            .
    END.
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
GET FIRST {&BROWSE-NAME}.
REPEAT WHILE AVAILABLE T-DREPO:
    ASSIGN
        x-CtoRep = (IF Almmmatg.MonVta = 2 THEN Almmmatg.CtoTot * Almmmatg.TpoCmb ELSE Almmmatg.CToTot)
        x-Items = x-Items + 1
        .
    ASSIGN
        x-Total = x-Total + (T-DREPO.CanGen * x-CtoRep)
        x-Peso = x-Peso + (T-DREPO.CanGen * Almmmatg.Pesmat)
        x-Volumen = x-Volumen + (T-DREPO.CanGen * Almmmatg.Libre_d02 / 1000000)
        x-Stock = x-Stock + (T-DREPO.SolStkDis * x-CtoRep)
        x-Transferencias = x-Transferencias + (T-DREPO.SolStkTra *  x-CtoRep)
        x-Compras = x-Compras + (T-DREPO.SolCmpTra * x-CtoRep)
        .
    GET NEXT {&BROWSE-NAME}.
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
IF NOT AVAILABLE Almacen OR Almacen.Campo-C[6] = "No" THEN DO:
    MESSAGE 'Almacén NO válido' VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry':U TO T-DREPO.AlmPed IN BROWSE {&browse-name}.
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
RUN vta2/Stock-Comprometido-v2 (Almmmate.CodMat, Almmmate.CodAlm, OUTPUT pComprometido).
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

/* IF T-DREPO.Origen = 'AUT' THEN DO:                     */
/*     MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR. */
/*     RETURN 'ADM-ERROR'.                                */
/* END.                                                   */

IF LOOKUP(T-DREPO.AlmPed, '997,998') > 0 AND T-DREPO.ControlDespacho = NO
    THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
COMBO-BOX-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
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

  FIND B-MATE WHERE B-MATE.codcia = s-codcia
      AND B-MATE.codalm = pAlmPed
      AND B-MATE.codmat = pCodMat
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE B-MATE THEN RETURN 0.00.
  CASE x-TipoCalculo:
      WHEN "GRUPO" THEN DO:
          RETURN (B-MATE.StkAct + fStockTransito(B-MATE.codcia,B-MATE.codalm,B-MATE.codmat)
                  - B-MATE.StkComprometido - B-MATE.StkMin).
      END.
      WHEN "TIENDA" THEN DO:
          RETURN (B-MATE.StkAct - B-MATE.StkComprometido - B-MATE.StockMax).
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
  FIND FIRST B-MATE WHERE B-MATE.codcia = s-codcia
      AND B-MATE.codalm = pCodAlm
      AND B-MATE.codmat = pCodMat
      NO-LOCK NO-ERROR.
  IF AVAILABLE B-MATE THEN RETURN (B-MATE.StkAct - B-MATE.StkComprometido).
  ELSE RETURN 0.00.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fStockComprometido B-table-Win 
FUNCTION fStockComprometido RETURNS DECIMAL
  ( INPUT pCodAlm AS CHAR, INPUT pCodMat AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-StockComprometido AS DEC NO-UNDO.

  RUN vta2/stock-comprometido-v2 (pCodMat, pCodAlm, OUTPUT x-StockComprometido).
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

