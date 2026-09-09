&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-MATE FOR Almmmate.
DEFINE SHARED TEMP-TABLE T-DREPO LIKE almdrepo
       FIELD SolStkDis AS DEC
       FIELD SolStkMax AS DEC
       FIELD SolStkTra AS DEC
       FIELD DesStkDis AS DEC
       FIELD DesStkMax AS DEC
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

DEF BUFFER bt-drepo FOR t-drepo.

DEF VAR x-StockComprometido AS DEC NO-UNDO.
DEF VAR x-StkDisponible AS DEC NO-UNDO.
DEF VAR x-Clasificacion AS CHAR NO-UNDO.
DEF VAR x-Peso AS DEC NO-UNDO.
DEF VAR x-Volumen AS DEC NO-UNDO.
DEF VAR x-PorcReposicion AS DEC NO-UNDO.
DEF VAR x-StkMaxSeg AS DEC NO-UNDO.

DEF VAR x-SolStkDis AS DEC NO-UNDO.
DEF VAR x-SolStkMax AS DEC NO-UNDO.
DEF VAR x-SolStkTra AS DEC NO-UNDO.
DEF VAR x-DesStkDis AS DEC NO-UNDO.
DEF VAR x-DesStkMax AS DEC NO-UNDO.

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
&Scoped-define INTERNAL-TABLES T-DREPO Almmmatg Almmmate

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-DREPO.Item T-DREPO.CodMat ~
Almmmatg.DesMat Almmmatg.DesMar Almmmatg.UndBas T-DREPO.AlmPed ~
T-DREPO.CanReq T-DREPO.CanGen T-DREPO.SolStkDis @ x-SolStkDis ~
T-DREPO.SolStkMax @ x-SolStkMax T-DREPO.SolStkTra @ x-SolStkTra ~
(IF T-DREPO.CanReq <> 0 THEN (T-DREPO.CanGen / T-DREPO.CanReq * 100) ELSE 0) @ x-PorcReposicion ~
T-DREPO.DesStkDis @ x-DesStkDis T-DREPO.DesStkMax @ x-DesStkMax ~
Almmmate.StkMax Almmmatg.CanEmp ~
T-DREPO.CanGen * (IF Almmmatg.MonVta = 2 THEN Almmmatg.CtoTot * Almmmatg.TpoCmb ELSE Almmmatg.CToTot) @ Almmmatg.CtoTot ~
T-DREPO.Origen fClasificacion() @ x-Clasificacion ~
(T-DREPO.CanGen * Almmmatg.Pesmat ) @ x-Peso ~
(T-DREPO.CanGen * Almmmatg.Libre_d02 / 1000000) @ x-Volumen Almmmate.StkAct ~
fStockComprometido() @ x-StockComprometido 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table T-DREPO.CodMat ~
T-DREPO.AlmPed T-DREPO.CanReq 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table T-DREPO
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table T-DREPO
&Scoped-define QUERY-STRING-br_table FOR EACH T-DREPO WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg OF T-DREPO NO-LOCK, ~
      FIRST Almmmate OF Almmmatg ~
      WHERE Almmmate.CodAlm = s-codalm NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-DREPO WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg OF T-DREPO NO-LOCK, ~
      FIRST Almmmate OF Almmmatg ~
      WHERE Almmmate.CodAlm = s-codalm NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table T-DREPO Almmmatg Almmmate
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-DREPO
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg
&Scoped-define THIRD-TABLE-IN-QUERY-br_table Almmmate


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-1 br_table 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-1 f-Mensaje FILL-IN-Master ~
FILL-IN-Reposicion FILL-IN-Estado 

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
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "':U + 'Codigo,Descripción,Unidad,Marca,Almacén Despacho,Cantidad Generada (Desc.)' + '",
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fStockComprometido B-table-Win 
FUNCTION fStockComprometido RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U INITIAL "Codigo" 
     LABEL "Ordenado por" 
     VIEW-AS COMBO-BOX INNER-LINES 7
     LIST-ITEMS "Codigo","Descripción","Marca","Almacén Despacho","Unidad","Cantidad Generada (Desc.)" 
     DROP-DOWN-LIST
     SIZE 23 BY 1 NO-UNDO.

DEFINE VARIABLE f-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-Estado AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Estado %" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Master AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Master" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Reposicion AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Reposición" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-DREPO, 
      Almmmatg, 
      Almmmate SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-DREPO.Item FORMAT ">,>>9":U
      T-DREPO.CodMat COLUMN-LABEL "<Codigo>" FORMAT "X(14)":U WIDTH 6.57
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 38.29
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(15)":U WIDTH 9.43
      Almmmatg.UndBas COLUMN-LABEL "Unidad" FORMAT "X(7)":U WIDTH 5.72
      T-DREPO.AlmPed COLUMN-LABEL "Almacén!Despacho" FORMAT "x(5)":U
      T-DREPO.CanReq COLUMN-LABEL "Cantidad!Requerida" FORMAT "-ZZZ,ZZ9.9999":U
            WIDTH 8.43
      T-DREPO.CanGen FORMAT "ZZZ,ZZ9.9999":U WIDTH 7.43 COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 11
      T-DREPO.SolStkDis @ x-SolStkDis COLUMN-LABEL "Disponible!Solicitante" FORMAT "(ZZZ,ZZ9.99)":U
      T-DREPO.SolStkMax @ x-SolStkMax COLUMN-LABEL "Stock Máximo!Solicitante" FORMAT "ZZZ,ZZ9.99":U
      T-DREPO.SolStkTra @ x-SolStkTra COLUMN-LABEL "Tránsito!Solicitante" FORMAT "ZZZ,ZZ9.99":U
      (IF T-DREPO.CanReq <> 0 THEN (T-DREPO.CanGen / T-DREPO.CanReq * 100) ELSE 0) @ x-PorcReposicion COLUMN-LABEL "% de!Reposición"
      T-DREPO.DesStkDis @ x-DesStkDis COLUMN-LABEL "Disponible!Despacho" FORMAT "(ZZZ,ZZZ,ZZ9.99)":U
            WIDTH 9.29 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      T-DREPO.DesStkMax @ x-DesStkMax COLUMN-LABEL "Stock Máximo!Despacho" FORMAT "ZZZ,ZZ9.99":U
      Almmmate.StkMax COLUMN-LABEL "Empaque!Reposición" FORMAT "ZZZ,ZZ9.99":U
      Almmmatg.CanEmp COLUMN-LABEL "Empaque!Master" FORMAT "->>,>>9.99":U
      T-DREPO.CanGen * (IF Almmmatg.MonVta = 2 THEN Almmmatg.CtoTot * Almmmatg.TpoCmb ELSE Almmmatg.CToTot) @ Almmmatg.CtoTot COLUMN-LABEL "Costo de!Reposición"
            WIDTH 9.72
      T-DREPO.Origen FORMAT "x(3)":U
      fClasificacion() @ x-Clasificacion COLUMN-LABEL "Clasif." FORMAT "X":U
      (T-DREPO.CanGen * Almmmatg.Pesmat ) @ x-Peso COLUMN-LABEL "Peso en Kg" FORMAT ">>>,>>9.99":U
      (T-DREPO.CanGen * Almmmatg.Libre_d02 / 1000000) @ x-Volumen COLUMN-LABEL "Volumen en m3" FORMAT ">>>,>>9.99":U
      Almmmate.StkAct COLUMN-LABEL "Stock!Actual" FORMAT "(ZZZ,ZZ9.99)":U
            WIDTH 7.14
      fStockComprometido() @ x-StockComprometido COLUMN-LABEL "Stock!Reservado" FORMAT "->>>,>>9.99":U
  ENABLE
      T-DREPO.CodMat
      T-DREPO.AlmPed
      T-DREPO.CanReq
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 141 BY 13.19
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-1 AT ROW 1 COL 10 COLON-ALIGNED WIDGET-ID 6
     f-Mensaje AT ROW 1 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     FILL-IN-Master AT ROW 1.19 COL 83 COLON-ALIGNED WIDGET-ID 62
     FILL-IN-Reposicion AT ROW 1.19 COL 103 COLON-ALIGNED WIDGET-ID 64
     FILL-IN-Estado AT ROW 1.19 COL 122 COLON-ALIGNED WIDGET-ID 66
     br_table AT ROW 2.08 COL 1
     FILL-IN-Mensaje AT ROW 15.27 COL 94 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     "F10: Kardex Almacén Despacho" VIEW-AS TEXT
          SIZE 29 BY .5 AT ROW 15.27 COL 66 WIDGET-ID 68
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
      TABLE: T-DREPO T "SHARED" ? INTEGRAL almdrepo
      ADDITIONAL-FIELDS:
          FIELD SolStkDis AS DEC
          FIELD SolStkMax AS DEC
          FIELD SolStkTra AS DEC
          FIELD DesStkDis AS DEC
          FIELD DesStkMax AS DEC
          
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
/* BROWSE-TAB br_table FILL-IN-Estado F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 7.

/* SETTINGS FOR FILL-IN f-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Master IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN-Mensaje:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Reposicion IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.T-DREPO,INTEGRAL.Almmmatg OF Temp-Tables.T-DREPO,INTEGRAL.Almmmate OF INTEGRAL.Almmmatg"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST, FIRST"
     _Where[3]         = "INTEGRAL.Almmmate.CodAlm = s-codalm"
     _FldNameList[1]   = Temp-Tables.T-DREPO.Item
     _FldNameList[2]   > Temp-Tables.T-DREPO.CodMat
"T-DREPO.CodMat" "<Codigo>" "X(14)" "character" ? ? ? ? ? ? yes ? no no "6.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "38.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(15)" "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.Almmmatg.UndBas
"Almmmatg.UndBas" "Unidad" "X(7)" "character" ? ? ? ? ? ? no ? no no "5.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-DREPO.AlmPed
"T-DREPO.AlmPed" "Almacén!Despacho" "x(5)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-DREPO.CanReq
"T-DREPO.CanReq" "Cantidad!Requerida" "-ZZZ,ZZ9.9999" "decimal" ? ? ? ? ? ? yes ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-DREPO.CanGen
"T-DREPO.CanGen" ? ? "decimal" 11 9 ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"T-DREPO.SolStkDis @ x-SolStkDis" "Disponible!Solicitante" "(ZZZ,ZZ9.99)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"T-DREPO.SolStkMax @ x-SolStkMax" "Stock Máximo!Solicitante" "ZZZ,ZZ9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"T-DREPO.SolStkTra @ x-SolStkTra" "Tránsito!Solicitante" "ZZZ,ZZ9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"(IF T-DREPO.CanReq <> 0 THEN (T-DREPO.CanGen / T-DREPO.CanReq * 100) ELSE 0) @ x-PorcReposicion" "% de!Reposición" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"T-DREPO.DesStkDis @ x-DesStkDis" "Disponible!Despacho" "(ZZZ,ZZZ,ZZ9.99)" ? 14 0 ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"T-DREPO.DesStkMax @ x-DesStkMax" "Stock Máximo!Despacho" "ZZZ,ZZ9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > INTEGRAL.Almmmate.StkMax
"Almmmate.StkMax" "Empaque!Reposición" "ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > INTEGRAL.Almmmatg.CanEmp
"Almmmatg.CanEmp" "Empaque!Master" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > "_<CALC>"
"T-DREPO.CanGen * (IF Almmmatg.MonVta = 2 THEN Almmmatg.CtoTot * Almmmatg.TpoCmb ELSE Almmmatg.CToTot) @ Almmmatg.CtoTot" "Costo de!Reposición" ? ? ? ? ? ? ? ? no ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   = Temp-Tables.T-DREPO.Origen
     _FldNameList[19]   > "_<CALC>"
"fClasificacion() @ x-Clasificacion" "Clasif." "X" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > "_<CALC>"
"(T-DREPO.CanGen * Almmmatg.Pesmat ) @ x-Peso" "Peso en Kg" ">>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > "_<CALC>"
"(T-DREPO.CanGen * Almmmatg.Libre_d02 / 1000000) @ x-Volumen" "Volumen en m3" ">>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > INTEGRAL.Almmmate.StkAct
"Almmmate.StkAct" "Stock!Actual" "(ZZZ,ZZ9.99)" "decimal" ? ? ? ? ? ? no ? no no "7.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > "_<CALC>"
"fStockComprometido() @ x-StockComprometido" "Stock!Reservado" "->>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
DEF INPUT PARAMETER pCodPro AS CHAR.
DEF INPUT PARAMETER pMarca  AS CHAR.
DEF INPUT PARAMETER pCodFam AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.

EMPTY TEMP-TABLE t-drepo.

DEF VAR pRowid AS ROWID.
DEF VAR pDiasUtiles AS INT.
DEF VAR pVentaDiaria AS DEC.
DEF VAR pDiasMinimo AS INT.
DEF VAR pReposicion AS DEC.
DEF VAR pComprometido AS DEC.

DEF VAR x-StockMinimo AS DEC NO-UNDO.
DEF VAR x-StockDisponible AS DEC NO-UNDO.
DEF VAR x-Item AS INT INIT 1 NO-UNDO.
DEF VAR x-CanReq LIKE T-DREPO.CanReq.
DEF VAR x-StkAct LIKE Almmmate.StkAct NO-UNDO.
DEF VAR k AS INT NO-UNDO.
DEF VAR x-TipMat AS CHAR NO-UNDO.

/* Buscamos los valores generales */
FIND FIRST AlmCfgGn WHERE almcfggn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcfggn THEN DO:
    MESSAGE 'Debe configurar los parámetros generales' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

EMPTY TEMP-TABLE t-drepo.
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Buscando información, un momento por favor'.

SESSION:SET-WAIT-STATE('GENERAL').
FOR EACH almmmate NO-LOCK WHERE Almmmate.codcia = s-codcia 
    AND Almmmate.codalm = s-codalm,
    FIRST almmmatg OF almmmate NO-LOCK WHERE Almmmatg.TpoArt <> 'D'
    AND Almmmatg.codpr1 BEGINS pCodPro
    AND Almmmatg.desmar BEGINS pMarca:
    /* FILTROS */
    IF pCodFam <> '' THEN DO:
        IF LOOKUP(Almmmatg.codfam, pCodFam) = 0 THEN NEXT.
    END.
    /* ******* */
    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Procesando ' + Almmmate.codmat.

    /* Venta Diaria */
    ASSIGN
        pDiasMinimo = AlmCfgGn.DiasMinimo
        pDiasUtiles = AlmCfgGn.DiasUtiles.
    FIND gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = Almmmatg.codpr1
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov AND gn-prov.StkMin > 0 THEN pDiasMinimo = gn-prov.StkMin.

    /* VA A HABER 2 FORMAS DE CALCULARLO:
        MANUAL: SIEMPRE Y CUANDO EL CAMPO ALMMMATE.STKMIN > 0 
        POR HISTORICOS: CUANDO EL CAMPO ALMMMATE.STKMIN = 0
        */
    /* RHC 21/12/2015 Ahora es el campo VInMn1 */
    IF Almmmate.VInMn1 = 0 THEN DO:     /* DEL HISTORICO */
        ASSIGN                                              
            pRowid = ROWID(Almmmate)
            pVentaDiaria = DECIMAL(Almmmate.Libre_c04).
        /* Stock Minimo */
        ASSIGN
            x-StockMinimo = pDiasMinimo * pVentaDiaria
            x-StkAct = Almmmate.StkAct.
        IF pCodAlm <> '' THEN DO:
            DO k = 1 TO NUM-ENTRIES(pCodAlm):
                IF ENTRY(k, pCodAlm) = s-codalm THEN NEXT.   /* NO del almacen activo */
                FIND B-MATE WHERE B-MATE.codcia = s-codcia
                    AND B-MATE.codalm = ENTRY(k, pCodAlm)
                    AND B-MATE.codmat = Almmmate.codmat
                    NO-LOCK NO-ERROR.
                IF AVAILABLE B-MATE THEN x-StkAct = x-StkAct + B-MATE.StkAct.
            END.
        END.
        IF x-StkAct >= x-StockMinimo THEN NEXT.
        /* Cantidad de Reposicion */
        RUN gn/cantidad-de-reposicion (pRowid, pVentaDiaria, OUTPUT pReposicion).
        IF pReposicion <= 0 THEN NEXT.
        /* RHC 05/12/2012 NO tiene histórico */
        IF Almmmate.Libre_C01 = "SIN HISTORICO" THEN DO:
            CREATE T-DREPO.
            ASSIGN
                T-DREPO.Origen = 'AUT'
                T-DREPO.CodCia = s-codcia 
                T-DREPO.CodAlm = s-codalm
                T-DREPO.Item = x-Item
                T-DREPO.AlmPed = "997"
                T-DREPO.CodMat = Almmmate.codmat
                T-DREPO.CanReq = 0
                T-DREPO.CanGen = pReposicion
                T-DREPO.StkAct = 0
                T-DREPO.CanApr = 0.
            x-Item = x-Item + 1.
            NEXT.
        END.
    END.
    IF Almmmate.VInMn1 > 0 THEN DO:     /* MANUAL */
        /* Stock Minimo */
        ASSIGN
            x-StockMinimo = Almmmate.VInMn1
            x-StkAct = Almmmate.StkAct.
        IF pCodAlm <> '' THEN DO:
            DO k = 1 TO NUM-ENTRIES(pCodAlm):
                IF ENTRY(k, pCodAlm) = s-codalm THEN NEXT.   /* NO del almacen activo */
                FIND B-MATE WHERE B-MATE.codcia = s-codcia
                    AND B-MATE.codalm = ENTRY(k, pCodAlm)
                    AND B-MATE.codmat = Almmmate.codmat
                    NO-LOCK NO-ERROR.
                IF AVAILABLE B-MATE THEN x-StkAct = x-StkAct + B-MATE.StkAct.
            END.
        END.
        IF x-StkAct >= x-StockMinimo THEN NEXT.
        /* Cantidad de Reposicion */
        pReposicion = x-StockMinimo - x-StkAct.
    END.
    /* distribuimos el pedido entre los almacenes de despacho */
    IF Almmmatg.Chr__02 = "P" THEN x-TipMat = "P". ELSE x-TipMat = "T".
    FOR EACH Almrepos NO-LOCK WHERE  almrepos.CodCia = s-codcia
        AND almrepos.CodAlm = Almmmate.codalm 
        AND almrepos.AlmPed <> Almmmate.codalm
        AND almrepos.TipMat = x-TipMat      /* Propios o Terceros */
        AND pReposicion > 0 /* <<< OJO <<< */
        BY almrepos.Orden:
        FIND B-MATE WHERE B-MATE.codcia = s-codcia
            AND B-MATE.codmat = Almmmate.codmat
            AND B-MATE.codalm = Almrepos.almped
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-MATE THEN NEXT.
        RUN vta2/Stock-Comprometido-v2 (Almmmate.CodMat, Almrepos.AlmPed, OUTPUT pComprometido).
        x-StockDisponible = B-MATE.StkAct - x-StockMinimo - pComprometido.
        IF x-StockDisponible <= 0 THEN NEXT.
        /* Se solicitará la reposición de acuerdo al empaque del producto */
        x-CanReq = MINIMUM(x-StockDisponible, pReposicion).
        IF Almmmatg.CanEmp > 0 THEN DO:
            x-CanReq = ROUND(x-CanReq / Almmmatg.CanEmp, 0) * Almmmatg.CanEmp.
        END.
        IF x-CanReq <= 0 THEN NEXT.    /* Menos que la cantidad por empaque */
        /* Redondeamos la cantidad a enteros */
        IF TRUNCATE(x-CanReq,0) <> x-CanReq THEN DO:
            x-CanReq = TRUNCATE(x-CanReq,0) + 1.
        END.
        /* ********************************* */
        CREATE T-DREPO.
        ASSIGN
            T-DREPO.Origen = 'AUT'
            T-DREPO.CodCia = s-codcia 
            T-DREPO.CodAlm = s-codalm 
            T-DREPO.Item = x-Item
            T-DREPO.AlmPed = Almrepos.almped
            T-DREPO.CodMat = Almmmate.codmat
            T-DREPO.CanReq = x-CanReq
            T-DREPO.CanGen = x-CanReq
            T-DREPO.StkAct = x-StockDisponible.
        ASSIGN
            x-Item = x-Item + 1
            pReposicion = pReposicion - T-DREPO.CanReq.
    END.
    /* RHC 15/10/2012 si queda un saldo lo pintamos en el almacén 998 */
    IF pReposicion > 0 THEN DO:
        x-CanReq = pReposicion.
        IF Almmmatg.CanEmp > 0 THEN DO:
            x-CanReq = ROUND(x-CanReq / Almmmatg.CanEmp, 0) * Almmmatg.CanEmp.
        END.
        IF x-CanReq > 0 THEN DO:
            /* Redondeamos la cantidad a enteros */
            IF TRUNCATE(x-CanReq,0) <> x-CanReq THEN DO:
                x-CanReq = TRUNCATE(x-CanReq,0) + 1.
            END.
            /* ********************************* */
            CREATE T-DREPO.
            ASSIGN
                T-DREPO.Origen = 'AUT'
                T-DREPO.CodCia = s-codcia 
                T-DREPO.CodAlm = s-codalm
                T-DREPO.Item = x-Item
                T-DREPO.AlmPed = "998"
                T-DREPO.CodMat = Almmmate.codmat
                T-DREPO.CanReq = 0
                T-DREPO.CanGen = x-CanReq
                T-DREPO.StkAct = 0.
            x-Item = x-Item + 1.
        END.
    END.
END.
FOR EACH T-DREPO WHERE T-DREPO.canreq <= 0 AND LOOKUP(T-DREPO.AlmPed, '997,998') = 0:
    DELETE T-DREPO.
END.
/* RHC 02/08/2016 Datos adicionales */
DEF VAR x-Total AS DEC NO-UNDO.
FOR EACH T-DREPO:
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
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '*** PROCESO TERMINADO ***'.

RUN dispatch IN THIS-PROCEDURE ('adm-open-query').

SESSION:SET-WAIT-STATE('').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel B-table-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE('GENERAL').

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
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

/* Titulos */
chWorkSheet:Range("A2"):VALUE = "Código".
chWorkSheet:Range("B2"):VALUE = "Descripcion".
chWorkSheet:Range("C2"):VALUE = "Marca".
chWorkSheet:Range("D2"):VALUE = "Unidad".
chWorkSheet:Range("E2"):VALUE = "Almacén Despacho".
chWorkSheet:Range("F2"):VALUE = "Cantidad Requerida".
chWorkSheet:Range("G2"):VALUE = "Cantidad Generada".
chWorkSheet:Range("H2"):VALUE = "Stock Actual".
chWorkSheet:Range("I2"):VALUE = "Stock Reservado".
chWorkSheet:Range("J2"):VALUE = "Stock Disponible".
chWorkSheet:Range("K2"):VALUE = "Stock Máximo + Seguridad".
chWorkSheet:Range("L2"):VALUE = "Stock en Tránsito".
chWorkSheet:Range("M2"):VALUE = "Empaque Reposición".
chWorkSheet:Range("N2"):VALUE = "Empaque Mastes".
chWorkSheet:Range("O2"):VALUE = "Clasificacion".
chWorkSheet:Range("P2"):VALUE = "Origen".
chWorkSheet:Range("Q2"):VALUE = "Zona".
chWorkSheet:Range("R2"):VALUE = "Costo de Reposicion".

chWorkSheet:COLUMNS("A"):NumberFormat = "@".
chWorkSheet:COLUMNS("E"):NumberFormat = "@".


/* Encabezado de Control */
chWorkSheet:Range("A1"):VALUE = "PEDIDO DE REPOSICION - " + TRIM(s-CodAlm).
t-Row = 2.
chWorkSheet = chExcelApplication:Sheets:Item(1).
FOR EACH bt-drepo NO-LOCK, FIRST Almmmate NO-LOCK WHERE Almmmate.codcia = s-codcia
    AND Almmmate.codalm = s-codalm AND Almmmate.codmat = bt-drepo.codmat:
    t-Row = t-Row + 1.
    t-Column = 1.
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND almmmatg.codmat = BT-DREPO.CodMat NO-LOCK NO-ERROR.
    chWorkSheet:Cells(t-Row, t-Column) = BT-DREPO.CodMat.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.DesMat.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.DesMar.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.UndBas.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = BT-DREPO.AlmPed.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = BT-DREPO.CanReq.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = BT-DREPO.CanGen.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Almmmate.StkAct.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = BT-DREPO.CanApro.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = (Almmmate.StkAct - BT-DREPO.CanApro).
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Almmmate.StkMin.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = BT-DREPO.CanTran.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Almmmate.StkMax.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.CanEmp.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = fClasificacion().
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = BT-DREPO.Origen.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Almmmate.codubi.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = BT-DREPO.CanGen * (IF Almmmatg.MonVta = 2 THEN Almmmatg.CtoTot * Almmmatg.TpoCmb ELSE Almmmatg.CToTot).

                                         /*T-DREPO.CanGen * (IF Almmmatg.MonVta = 2 THEN Almmmatg.CtoTot * Almmmatg.TpoCmb ELSE Almmmatg.CToTot)*/

END.
/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

SESSION:SET-WAIT-STATE('').

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
        FILTERS "Archivos Excel (*.xls)" "*.xls", "Todos (*.*)" "*.*"
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
    IF NOT cValue = "PEDIDO DE REPOSICION - " + TRIM(s-CodAlm) THEN DO:
        MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    /* ******************* */
    /* CARGAMOS TEMPORALES */
    EMPTY TEMP-TABLE T-DREPO.
    EMPTY TEMP-TABLE T-MATG.
    ASSIGN
        pMensaje = ""
        t-Row = 2.     /* Saltamos el encabezado de los campos */
    REPEAT:
        ASSIGN
            t-Row    = t-Row + 1.
        t-column = 1.
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
        t-Column = 5.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN
            T-DREPO.almped = cValue.
        /* CANTIDAD */        
        t-Column = 7.
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
    
    FILL-IN-Mensaje:VISIBLE IN FRAME {&FRAME-NAME} = YES.
    FOR EACH T-DREPO:
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Cantidad requerida " + T-DREPO.codmat.
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
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Comprometido y tránsito " + T-DREPO.codmat.
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
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    FILL-IN-Mensaje:VISIBLE IN FRAME {&FRAME-NAME} = NO.
/*     RUN dispatch IN THIS-PROCEDURE ('open-query':U). */


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
          ELSE ASSIGN
                T-DREPO.CodMat:READ-ONLY IN BROWSE {&browse-name} = NO
                T-DREPO.AlmPed:READ-ONLY IN BROWSE {&browse-name} = NO.

  END.
  ELSE DO:
      T-DREPO.CodMat:READ-ONLY IN BROWSE {&browse-name} = NO.
      T-DREPO.AlmPed:READ-ONLY IN BROWSE {&browse-name} = NO.
  END.

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
/*     IF DECIMAL(T-DREPO.CanReq:SCREEN-VALUE IN BROWSE {&browse-name}) > (Almmmate.StkAct - T-DREPO.CanApro) */
/*         THEN DO:                                                                                           */
/*         MESSAGE 'La cantidad no puede ser mayor al stock disponible' VIEW-AS ALERT-BOX ERROR.              */
/*         APPLY 'ENTRY':U TO T-DREPO.CanReq IN BROWSE {&browse-name}.                                        */
/*         RETURN 'ADM-ERROR'.                                                                                */
/*     END.                                                                                                   */
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
RUN GET-ATTRIBUTE('adm-new-record').
CASE TRUE:
    WHEN RETURN-VALUE = 'YES' OR T-DREPO.Origen:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "MAN" 
        THEN DO:
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
    END.
    OTHERWISE DO:
        FIND Almrepos WHERE almrepos.CodCia = s-codcia
            AND almrepos.TipMat = Almmmatg.Chr__02
            AND almrepos.CodAlm = s-codalm
            AND almrepos.AlmPed = T-DREPO.AlmPed:SCREEN-VALUE IN BROWSE {&browse-name}
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almrepos THEN DO:
            MESSAGE 'Almacén' T-DREPO.AlmPed:SCREEN-VALUE IN BROWSE {&browse-name}
                'no es válido' VIEW-AS ALERT-BOX ERROR.
            APPLY 'entry':U TO T-DREPO.AlmPed IN BROWSE {&browse-name}.
            RETURN 'ADM-ERROR'.
        END.
    END.
END CASE.


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
IF LOOKUP(T-DREPO.AlmPed, '997,998') > 0 THEN DO:
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fStockComprometido B-table-Win 
FUNCTION fStockComprometido RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-StockComprometido AS DEC NO-UNDO.

  /*RUN vta2/stock-comprometido (T-DREPO.CodMat, T-DREPO.AlmPed, OUTPUT x-StockComprometido).*/
  RUN vta2/stock-comprometido-v2 (T-DREPO.CodMat, T-DREPO.CodAlm, OUTPUT x-StockComprometido).
  RETURN x-StockComprometido.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

