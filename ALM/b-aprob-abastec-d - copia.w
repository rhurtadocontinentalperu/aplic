&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
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

DEF VAR x-StkDisponible AS DEC NO-UNDO.
DEF VAR x-StkDisponible-Orig AS DEC NO-UNDO.

/* Para calcular el stock en tránsito */
DEF VAR x-StockTransito AS DEC NO-UNDO.
DEF VAR x-CompraTransito AS DEC NO-UNDO.
DEF VAR x-FaltanteGrupo AS CHAR NO-UNDO.

DEFINE TEMP-TABLE tmp-tabla
    FIELD t-CodAlm LIKE Almacen.codalm  FORMAT 'x(3)'
    FIELD t-CodDoc LIKE FacDPedi.CodDoc FORMAT "XXX"
    FIELD t-Nroped LIKE FacDPedi.NroPed FORMAT "XXX-XXXXXXXX"
    FIELD t-CodDiv LIKE FacCPedi.CodDiv FORMAT 'x(5)'
    FIELD t-FchPed LIKE FacDPedi.FchPed
    FIELD t-NomCli LIKE FacCPedi.NomCli COLUMN-LABEL "Cliente" FORMAT "x(35)"
    FIELD t-CodMat LIKE FacDPedi.codmat
    FIELD t-Canped LIKE FacDPedi.CanPed.

DEF SHARED VAR lh_handle AS HANDLE.
DEF SHARED VAR s-codcia AS INT.

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

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES almcrepo
&Scoped-define FIRST-EXTERNAL-TABLE almcrepo


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR almcrepo.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES almdrepo Almmmatg Almmmate

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table almdrepo.Item almdrepo.CodMat ~
Almmmatg.DesMat Almmmatg.DesMar almdrepo.CanReq almdrepo.CanApro ~
Almmmatg.UndBas fStockDisponible() @ x-StkDisponible Almmmate.StkMin ~
(fStockTransito() -  almdrepo.CanApro) @ x-StockTransito ~
fCompraTransito() @ x-CompraTransito Almmmate.StkMax Almmmatg.CanEmp ~
fStockDisponibleOrig() @ x-StkDisponible-Orig 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table almdrepo.CodMat ~
almdrepo.CanApro 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table almdrepo
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table almdrepo
&Scoped-define QUERY-STRING-br_table FOR EACH almdrepo OF almcrepo WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg OF almdrepo NO-LOCK, ~
      FIRST Almmmate OF almdrepo NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH almdrepo OF almcrepo WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg OF almdrepo NO-LOCK, ~
      FIRST Almmmate OF almdrepo NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table almdrepo Almmmatg Almmmate
&Scoped-define FIRST-TABLE-IN-QUERY-br_table almdrepo
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg
&Scoped-define THIRD-TABLE-IN-QUERY-br_table Almmmate


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
Item|y||INTEGRAL.almdrepo.Item|yes
CodMat|||INTEGRAL.almdrepo.CodMat|yes
DesMat|||INTEGRAL.Almmmatg.DesMat|yes
DesMar|||INTEGRAL.Almmmatg.DesMar|yes
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "':U + 'Item,CodMat,DesMat,DesMar' + '",
     SortBy-Case = ':U + 'Item').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCompraTransito B-table-Win 
FUNCTION fCompraTransito RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fFaltanteGrupo B-table-Win 
FUNCTION fFaltanteGrupo RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fStockComprometido B-table-Win 
FUNCTION fStockComprometido RETURNS DECIMAL
  ( INPUT pCodMat AS CHAR, INPUT pCodAlm AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fStockDisponible B-table-Win 
FUNCTION fStockDisponible RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fStockDisponibleOrig B-table-Win 
FUNCTION fStockDisponibleOrig RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fStockTransito B-table-Win 
FUNCTION fStockTransito RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      almdrepo, 
      Almmmatg
    FIELDS(Almmmatg.DesMat
      Almmmatg.DesMar
      Almmmatg.UndBas
      Almmmatg.CanEmp), 
      Almmmate SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      almdrepo.Item FORMAT ">,>>9":U WIDTH 3
      almdrepo.CodMat COLUMN-LABEL "<Codigo>" FORMAT "X(6)":U COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 34.43
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U WIDTH 9.43
      almdrepo.CanReq COLUMN-LABEL "Cantidad!Requerida" FORMAT "ZZZ,ZZ9.99":U
            WIDTH 7.43
      almdrepo.CanApro FORMAT "ZZZ,ZZ9.99":U WIDTH 7.57 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      Almmmatg.UndBas COLUMN-LABEL "Unidad" FORMAT "X(7)":U WIDTH 5.29
      fStockDisponible() @ x-StkDisponible COLUMN-LABEL "Stk Destino!Disponible" FORMAT "(ZZZ,ZZ9.99)":U
            WIDTH 8
      Almmmate.StkMin COLUMN-LABEL "Stock Máximo!+ Seguridad" FORMAT "ZZZ,ZZ9.99":U
      (fStockTransito() -  almdrepo.CanApro) @ x-StockTransito COLUMN-LABEL "Stock en!Tránsito" FORMAT "-ZZZ,ZZ9.99":U
            WIDTH 7.43
      fCompraTransito() @ x-CompraTransito COLUMN-LABEL "Compra en!Tránsito" FORMAT "ZZZ,ZZ9.99":U
            WIDTH 7.72
      Almmmate.StkMax COLUMN-LABEL "Empaque!Reposición" FORMAT "ZZZ,ZZ9.99":U
      Almmmatg.CanEmp COLUMN-LABEL "Empaque!Master" FORMAT "->>,>>9.99":U
            WIDTH 7.14
      fStockDisponibleOrig() @ x-StkDisponible-Orig COLUMN-LABEL "Stk Origen!Disponible" FORMAT "(ZZZ,ZZ9.99)":U
            WIDTH 7.72 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
  ENABLE
      almdrepo.CodMat
      almdrepo.CanApro
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 141 BY 22.88
         FONT 4 ROW-HEIGHT-CHARS .5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     "F8: Consulta de stocks  F7: Pedidos F9: Ingresos en Tránsito" VIEW-AS TEXT
          SIZE 41 BY .5 AT ROW 23.88 COL 76 WIDGET-ID 10
     "F10: Kardex Almacén Despacho" VIEW-AS TEXT
          SIZE 23 BY .5 AT ROW 23.88 COL 118 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.almcrepo
   Allow: Basic,Browse
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
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 23.77
         WIDTH              = 145.43.
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
     _TblList          = "INTEGRAL.almdrepo OF INTEGRAL.almcrepo,INTEGRAL.Almmmatg OF INTEGRAL.almdrepo,INTEGRAL.Almmmate OF INTEGRAL.almdrepo"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST USED, FIRST"
     _FldNameList[1]   > INTEGRAL.almdrepo.Item
"almdrepo.Item" ? ? "integer" ? ? ? ? ? ? no ? no no "3" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.almdrepo.CodMat
"almdrepo.CodMat" "<Codigo>" ? "character" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "34.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.almdrepo.CanReq
"almdrepo.CanReq" "Cantidad!Requerida" "ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.almdrepo.CanApro
"almdrepo.CanApro" ? "ZZZ,ZZ9.99" "decimal" 11 0 ? ? ? ? yes ? no no "7.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.Almmmatg.UndBas
"Almmmatg.UndBas" "Unidad" "X(7)" "character" ? ? ? ? ? ? no ? no no "5.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"fStockDisponible() @ x-StkDisponible" "Stk Destino!Disponible" "(ZZZ,ZZ9.99)" ? ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.Almmmate.StkMin
"Almmmate.StkMin" "Stock Máximo!+ Seguridad" "ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"(fStockTransito() -  almdrepo.CanApro) @ x-StockTransito" "Stock en!Tránsito" "-ZZZ,ZZ9.99" ? ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"fCompraTransito() @ x-CompraTransito" "Compra en!Tránsito" "ZZZ,ZZ9.99" ? ? ? ? ? ? ? no ? no no "7.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.Almmmate.StkMax
"Almmmate.StkMax" "Empaque!Reposición" "ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > INTEGRAL.Almmmatg.CanEmp
"Almmmatg.CanEmp" "Empaque!Master" ? "decimal" ? ? ? ? ? ? no ? no no "7.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"fStockDisponibleOrig() @ x-StkDisponible-Orig" "Stk Origen!Disponible" "(ZZZ,ZZ9.99)" ? 14 0 ? ? ? ? no ? no no "7.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
    RUN ALM/D-DETMOV.R (almcrepo.almped, almmmatg.codmat, almmmatg.desmat).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON F11 OF br_table IN FRAME F-Main
DO:
  IF AVAILABLE Almdrepo THEN RUN alm/d-asigna-res-zg (INPUT Almdrepo.CodMat).
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
    /*RUN vta/d-stkalm.*/
    RUN alm/d-stkalm.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON F9 OF br_table IN FRAME F-Main
DO:
  S-CODMAT = Almmmatg.CodMat.
  run alm/c-ingentransito (INPUT Almdrepo.codalm, INPUT Almdrepo.codmat).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON LEFT-MOUSE-DBLCLICK OF br_table IN FRAME F-Main
DO:
    RUN ALM/D-DETMOV.R (almcrepo.codalm, almmmatg.codmat, almmmatg.desmat).
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
        WHEN "Item" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'Item').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "CodMat" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'CodMat').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "DesMat" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'DesMat').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "DesMar" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'DesMar').
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
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almdrepo.CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almdrepo.CodMat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF almdrepo.CodMat IN BROWSE br_table /* <Codigo> */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  ASSIGN
      SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),'999999')
      NO-ERROR.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' AND SELF:SCREEN-VALUE <>  Almdrepo.CodMat THEN DO:
      MESSAGE 'NO está permitido cambiar el producto' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = Almdrepo.CodMat.
      RETURN NO-APPLY.
  END.
/*   IF RETURN-VALUE = 'NO' AND Almdrepo.Origen = 'AUT' AND SELF:SCREEN-VALUE <>  Almdrepo.CodMat THEN DO: */
/*       MESSAGE 'NO está permitido cambiar el producto' VIEW-AS ALERT-BOX ERROR.                          */
/*       SELF:SCREEN-VALUE = Almdrepo.CodMat.                                                              */
/*       RETURN NO-APPLY.                                                                                  */
/*   END.                                                                                                  */

  FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
      AND Almmmatg.codmat = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
      MESSAGE 'Producto NO registrado' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

ON FIND OF Almdrepo DO:
    ASSIGN
        x-StkDisponible = 0
        x-StockTransito = 0
        x-CompraTransito = 0
        x-StkDisponible-Orig = 0.
    x-StkDisponible = fStockDisponible().
    x-StockTransito = fStockTransito() -  almdrepo.CanApro.
    x-CompraTransito = fCompraTransito().
    x-StkDisponible-Orig = fStockDisponibleOrig().
END.

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF almdrepo.CanApro, almdrepo.CodMat
DO:
    APPLY 'TAB':U.
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
    WHEN 'Item':U THEN DO:
      &Scope SORTBY-PHRASE BY almdrepo.Item
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'CodMat':U THEN DO:
      &Scope SORTBY-PHRASE BY almdrepo.CodMat
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'DesMat':U THEN DO:
      &Scope SORTBY-PHRASE BY Almmmatg.DesMat
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'DesMar':U THEN DO:
      &Scope SORTBY-PHRASE BY Almmmatg.DesMar
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "almcrepo"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "almcrepo"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* RHC 23/08/17 nueva rutina Max Ramos*/
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:      /* Nuevo Registro */
      ASSIGN
          almdrepo.CodCia = almcrepo.codcia
          almdrepo.CodAlm = almcrepo.codalm
          almdrepo.TipMov = almcrepo.tipmov
          almdrepo.NroSer = almcrepo.nroser
          almdrepo.NroDoc = almcrepo.nrodoc.
      ASSIGN
          Almdrepo.AlmPed  = almcrepo.almped
          Almdrepo.Origen  = 'MAN'.
      ASSIGN
          Almdrepo.CanGen = Almdrepo.CanApro
          Almdrepo.CanReq = Almdrepo.CanApro.
  END.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
  RUN Procesa-Handle IN lh_handle ('enable-header').

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
  RUN Renumera.

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
  SESSION:SET-WAIT-STATE('GENERAL').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  SESSION:SET-WAIT-STATE('').

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
  RUN Renumera.
  RUN Procesa-Handle IN lh_handle ('enable-header').
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Renumera B-table-Win 
PROCEDURE Renumera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF BUFFER B-DREPO FOR Almdrepo.
  DEF BUFFER B-MATG  FOR Almmmatg.

  DEF VAR x-Item AS INT NO-UNDO.

  FOR EACH B-DREPO OF Almcrepo, FIRST B-MATG OF B-DREPO BY B-MATG.desmar BY B-MATG.desmat:
      x-Item = x-Item + 1.
      B-DREPO.ITEM = x-Item.
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
  {src/adm/template/snd-list.i "almcrepo"}
  {src/adm/template/snd-list.i "almdrepo"}
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

IF almdrepo.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '' THEN DO:
    MESSAGE 'Ingrese el código del artículo' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO almdrepo.CodMat.
    RETURN 'ADM-ERROR'.
END.
RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF RETURN-VALUE = 'YES' THEN DO:
    IF CAN-FIND(FIRST Almdrepo OF Almcrepo WHERE Almdrepo.codmat = almdrepo.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                NO-LOCK) THEN DO:
        MESSAGE 'Artículo YA registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO almdrepo.CodMat.
        RETURN 'ADM-ERROR'.
    END.
END.
IF DECIMAL(almdrepo.CanApro:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <= 0 THEN DO:
    MESSAGE 'Ingrese un valor mayor a cero' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO almdrepo.CanApro.
    RETURN 'ADM-ERROR'.
END.
FIND Almmmate WHERE Almmmate.codcia = s-codcia
    AND Almmmate.codalm = almcrepo.almped
    AND Almmmate.codmat = almdrepo.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmate THEN DO:
    MESSAGE 'Artículo NO asignado al almacén de despacho' almcrepo.almped 
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO almdrepo.CanApro.
    RETURN 'ADM-ERROR'.
END.
/* Comprometido */
DEF VAR pComprometido AS DEC NO-UNDO.
RUN gn/stock-comprometido-v2 (almdrepo.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                              almcrepo.almped,
                              NO,
                              OUTPUT pComprometido).
/* RUN vta2/stock-comprometido-v2 (almdrepo.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}, */
/*                                 almcrepo.almped,                                       */
/*                                 OUTPUT pComprometido).                                 */
RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF RETURN-VALUE = 'NO' 
    AND Almdrepo.codmat = almdrepo.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    THEN pComprometido = pComprometido - Almdrepo.CanApro.
IF DECIMAL(almdrepo.CanApro:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > Almmmate.stkact - pComprometido
    THEN DO:
    MESSAGE 'No hay stock disponible suficiente en el almacén de despacho' almcrepo.almped SKIP
        'Stock Disponible =' Almmmate.stkact - pComprometido
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO almdrepo.CanApro.
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


IF NOT AVAILABLE Almcrepo THEN RETURN 'ADM-ERROR'.
RUN Procesa-Handle IN lh_handle ('disable-header').
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCompraTransito B-table-Win 
FUNCTION fCompraTransito RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF NOT AVAILABLE Almcrepo THEN RETURN 0.00.
  
  FIND OOComPend WHERE OOComPend.CodMat = Almdrepo.codmat
      AND OOComPend.CodAlm = Almdrepo.codalm
      NO-LOCK NO-ERROR.
  IF AVAILABLE OOComPend THEN RETURN (OOComPend.CanPed - OOComPend.CanAte).
  ELSE RETURN 0.00.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fFaltanteGrupo B-table-Win 
FUNCTION fFaltanteGrupo RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  /* Buscamos a qué grupo pertenece */
  DEF VAR x-Grupo AS CHAR NO-UNDO.
  DEF VAR x-Acumulado AS DEC NO-UNDO.
  DEF VAR x-libre_d01 AS DEC NO-UNDO.
  DEF VAR x-libre_d02 AS DEC NO-UNDO.
  DEF VAR x-libre_d03 AS DEC NO-UNDO.
  DEF VAR x-libre_d04 AS DEC NO-UNDO.
  DEF VAR pStkComprometido AS DEC NO-UNDO.

  DEF BUFFER B-MATE FOR Almmmate.

  FIND FIRST TabGener WHERE TabGener.Clave = "ZG"
      AND TabGener.CodCia = s-codcia 
      AND TabGener.Libre_c01 = Almcrepo.CodAlm
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE TabGener THEN RETURN "".

  x-Grupo = TabGener.Codigo.
  FOR EACH TabGener NO-LOCK WHERE TabGener.CodCia = s-codcia 
      AND TabGener.Clave = "ZG"
      AND TabGener.Codigo = x-Grupo,
      FIRST B-MATE NO-LOCK WHERE B-MATE.codcia = s-codcia
      AND B-MATE.CodMat = Almdrepo.CodMat
      AND B-MATE.CodAlm = TabGener.Libre_c01:
      pStkComprometido = fStockComprometido(B-MATE.CodMat, B-MATE.CodAlm).
      x-libre_d01 = B-MATE.StkAct - pStkComprometido.
      /* En Tránsito */
      RUN alm\p-articulo-en-transito (
          B-MATE.CodCia,
          B-MATE.CodAlm,
          B-MATE.CodMat,
          INPUT-OUTPUT TABLE tmp-tabla,
          OUTPUT x-libre_d02).
      /* Compras en tránsito */
      x-Libre_d04 = 0.
      FOR EACH OOComPend WHERE OOComPend.CodAlm = Almmmate.codalm AND 
          OOComPend.CodMat = Almmmate.codmat NO-LOCK:
          x-Libre_d04 = x-Libre_d04 + (OOComPend.CanPed - OOComPend.CanAte).
      END.
      x-libre_d03 = (x-libre_d01 + x-libre_d02 + x-Libre_d04) - B-MATE.StkMin.
      x-Acumulado = x-Acumulado + x-libre_d03.
  END.
  RETURN (IF x-Acumulado >= 0 THEN "NO" ELSE "SI").

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fStockComprometido B-table-Win 
FUNCTION fStockComprometido RETURNS DECIMAL
  ( INPUT pCodMat AS CHAR, INPUT pCodAlm AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pStkComprometido AS DEC.

  RUN gn/stock-comprometido-v2.p (pCodMat, pCodAlm, NO, OUTPUT pStkComprometido).

  RETURN pStkComprometido.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fStockDisponible B-table-Win 
FUNCTION fStockDisponible RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pComprometido AS DEC NO-UNDO.

  IF NOT AVAILABLE Almcrepo THEN RETURN 0.00.
  /* Comprometido */
  /*RUN vta2/stock-comprometido-v2 (almdrepo.CodMat, almdrepo.CodAlm, OUTPUT pComprometido).*/
  RUN gn/stock-comprometido-v2.p (almdrepo.CodMat, almdrepo.CodAlm, NO, OUTPUT pComprometido).
  IF AVAILABLE Almmmate THEN RETURN (Almmmate.StkAct - pComprometido).
  ELSE RETURN 0.00.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fStockDisponibleOrig B-table-Win 
FUNCTION fStockDisponibleOrig RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pComprometido AS DEC NO-UNDO.

  IF NOT AVAILABLE Almcrepo THEN RETURN 0.00.

  DEF BUFFER B-MATE FOR Almmmate.

  /* Comprometido */
  RUN gn/stock-comprometido-v2 (almdrepo.CodMat, almcrepo.AlmPed, NO, OUTPUT pComprometido).

  FIND B-MATE WHERE B-MATE.codcia = s-codcia
      AND B-MATE.codalm = almcrepo.AlmPed
      AND B-MATE.codmat = almdrepo.CodMat
      NO-LOCK NO-ERROR.
  IF AVAILABLE B-MATE THEN RETURN (B-MATE.StkAct - pComprometido).
  RETURN 0.00.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fStockTransito B-table-Win 
FUNCTION fStockTransito RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF NOT AVAILABLE Almcrepo THEN RETURN 0.00.
  
  /* En Tránsito */
  DEF VAR x-Total AS DEC NO-UNDO.

  RUN alm\p-articulo-en-transito (
      Almdrepo.codcia,
      Almdrepo.codalm,
      Almdrepo.codmat,
      INPUT-OUTPUT TABLE tmp-tabla,
      OUTPUT x-Total).

  RETURN x-Total.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

