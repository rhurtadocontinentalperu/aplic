&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-MATG LIKE Almmmatg.



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
DEFINE SHARED VARIABLE s-acceso-semaforos AS LOG.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE SHARED TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE SHARED TEMP-TABLE ITEM-2 LIKE FacDPedi.

/* Parameters Definitions ---                                           */
DEF SHARED VAR s-TpoPed AS CHAR.

DEF VAR pNroItem AS INT INIT 0 NO-UNDO.
DEF VAR i AS INT INIT 0 NO-UNDO.
FOR EACH ITEM NO-LOCK BY ITEM.NroItm:
    i = i + 1.
    pNroItem = ITEM.NroItm.
END.
pNroItem = MAXIMUM(i,pNroItem) + 1.

/* Local Variable Definitions ---                                       */

DEF VAR x-codalm AS CHAR NO-UNDO.
DEF VAR x-desmat AS CHAR NO-UNDO.
DEF VAR x-desmar AS CHAR NO-UNDO.
DEF VAR x-codfam AS CHAR INIT 'Todos' NO-UNDO.
DEF VAR x-subfam AS CHAR INIT 'Todos' NO-UNDO.

DEFINE SHARED VARIABLE S-CODCIA     AS INTEGER.
DEFINE SHARED VARIABLE S-CODALM     AS CHAR.

DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.       /* División de Ventas */
DEFINE SHARED VARIABLE S-CODCLI  AS CHAR.
DEFINE SHARED VARIABLE s-FlgTipoVenta AS LOG.

DEFINE NEW SHARED VARIABLE S-CODMAT   AS CHAR.

&SCOPED-DEFINE Condicion Almmmatg.CodCia = s-codcia ~
 AND (x-desmat = '' OR INDEX(Almmmatg.DesMat, x-desmat) > 0) ~
 AND (x-desmar = '' OR INDEX(Almmmatg.DesMar, x-desmar) > 0) ~
 AND Almmmatg.TpoArt <> "D" ~
 AND Almmmatg.PreOfi > 0 ~
 AND Almmmatg.TpoMrg <> "2" ~
 AND (x-CodFam = 'Todos' OR Almmmatg.CodFam = x-CodFam) ~
 AND (x-SubFam = 'Todos' OR Almmmatg.SubFam = x-SubFam) ~
 AND (s-TpoPed <> "LU" OR Almmmatg.Sw-Web = "S") ~
 AND (TOGGLE-FlgPre = no or INTEGRAL.Almmmatg.FlgPre = TOGGLE-FlgPre) ~
 AND NOT (s-FlgTipoVenta = YES AND Almmmatg.TpoMrg = '2')

DEF VAR x-Semaforo AS CHAR NO-UNDO.

DEF VAR pForeground AS INT.
DEF VAR pBackground AS INT.

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
&Scoped-define INTERNAL-TABLES Almmmatg Almmmate T-MATG

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table x-Semaforo @ x-Semaforo ~
Almmmatg.DesMat Almmmatg.codmat Almmmatg.DesMar Almmmate.StkAct ~
fComprometido() @ Almmmatg.StkRep Almmmate.StockMax Almmmatg.UndStk ~
T-MATG.Libre_d01 ~
(IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1) * Almmmatg.PreOfi @ Almmmatg.PreOfi 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table T-MATG.Libre_d01 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table T-MATG
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table T-MATG
&Scoped-define QUERY-STRING-br_table FOR EACH Almmmatg WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST Almmmate OF Almmmatg ~
      WHERE Almmmate.CodAlm = x-codalm ~
 AND (TOGGLE-Stock = No OR Almmmate.StkAct > 0) NO-LOCK, ~
      FIRST T-MATG OF Almmmatg OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Almmmatg WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST Almmmate OF Almmmatg ~
      WHERE Almmmate.CodAlm = x-codalm ~
 AND (TOGGLE-Stock = No OR Almmmate.StkAct > 0) NO-LOCK, ~
      FIRST T-MATG OF Almmmatg OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table Almmmatg Almmmate T-MATG
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Almmmatg
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmate
&Scoped-define THIRD-TABLE-IN-QUERY-br_table T-MATG


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-CodAlm TOGGLE-Stock TOGGLE-FlgPre ~
FILL-IN-1 FILL-IN-Marca COMBO-BOX-Linea COMBO-BOX-SubLinea br_table 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodAlm TOGGLE-Stock ~
TOGGLE-FlgPre FILL-IN-1 FILL-IN-Marca COMBO-BOX-Linea COMBO-BOX-SubLinea 

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
DesMat|y||INTEGRAL.Almmmatg.DesMat|yes
PreOfi||y|BY (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1) * Almmmatg.PreOfi
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "':U + 'DesMat,PreOfi' + '",
     SortBy-Case = ':U + 'DesMat').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fComprometido B-table-Win 
FUNCTION fComprometido RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE COMBO-BOX-CodAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacén" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     DROP-DOWN-LIST
     SIZE 44 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Linea AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Línea" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 53 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-SubLinea AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Sublínea" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 53 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Descripción" 
     VIEW-AS FILL-IN 
     SIZE 53 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Marca AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 53 BY .81 NO-UNDO.

DEFINE VARIABLE TOGGLE-FlgPre AS LOGICAL INITIAL yes 
     LABEL "Productos VIP" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Stock AS LOGICAL INITIAL yes 
     LABEL "Solo con stock" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      Almmmatg, 
      Almmmate, 
      T-MATG SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      x-Semaforo @ x-Semaforo COLUMN-LABEL "Sem." FORMAT "x(4)":U
            WIDTH 4
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 40
      Almmmatg.codmat COLUMN-LABEL "Codigo" FORMAT "X(6)":U WIDTH 9.43
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U WIDTH 13.43
      Almmmate.StkAct COLUMN-LABEL "Stock" FORMAT "(ZZZ,ZZZ,ZZ9.99)":U
            WIDTH 9.43
      fComprometido() @ Almmmatg.StkRep COLUMN-LABEL "Comprometido" FORMAT "ZZZ,ZZZ,ZZ9.99":U
            WIDTH 10.43
      Almmmate.StockMax COLUMN-LABEL "Stock!Maximo" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 8.86
      Almmmatg.UndStk COLUMN-LABEL "Unidad" FORMAT "X(6)":U
      T-MATG.Libre_d01 COLUMN-LABEL "Cantidad" FORMAT ">>>,>>9.99":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1) * Almmmatg.PreOfi @ Almmmatg.PreOfi COLUMN-LABEL "Precio Unit.!en S/." FORMAT ">>,>>9.9999":U
            WIDTH 8
  ENABLE
      T-MATG.Libre_d01
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 126 BY 13.85
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-CodAlm AT ROW 1 COL 11 COLON-ALIGNED WIDGET-ID 24
     TOGGLE-Stock AT ROW 1 COL 60 WIDGET-ID 36
     TOGGLE-FlgPre AT ROW 1 COL 76 WIDGET-ID 34
     FILL-IN-1 AT ROW 1.96 COL 11 COLON-ALIGNED WIDGET-ID 30
     FILL-IN-Marca AT ROW 2.92 COL 11 COLON-ALIGNED WIDGET-ID 32
     COMBO-BOX-Linea AT ROW 3.88 COL 11 COLON-ALIGNED WIDGET-ID 26
     COMBO-BOX-SubLinea AT ROW 4.85 COL 11 COLON-ALIGNED WIDGET-ID 28
     br_table AT ROW 5.81 COL 1
     "F8: Stocks por Almacén                          F7: Pedidos" VIEW-AS TEXT
          SIZE 37 BY .5 AT ROW 19.65 COL 1 WIDGET-ID 16
          BGCOLOR 9 FGCOLOR 15 
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
      TABLE: T-MATG T "?" ? INTEGRAL Almmmatg
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
         HEIGHT             = 20.35
         WIDTH              = 126.29.
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
/* BROWSE-TAB br_table COMBO-BOX-SubLinea F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.Almmmatg,INTEGRAL.Almmmate OF INTEGRAL.Almmmatg,Temp-Tables.T-MATG OF INTEGRAL.Almmmatg"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST, FIRST OUTER"
     _Where[1]         = "{&Condicion}"
     _Where[2]         = "Almmmate.CodAlm = x-codalm
 AND (TOGGLE-Stock = No OR Almmmate.StkAct > 0)"
     _FldNameList[1]   > "_<CALC>"
"x-Semaforo @ x-Semaforo" "Sem." "x(4)" ? ? ? ? ? ? ? no ? no no "4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.codmat
"Almmmatg.codmat" "Codigo" ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.Almmmate.StkAct
"Almmmate.StkAct" "Stock" ? "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fComprometido() @ Almmmatg.StkRep" "Comprometido" "ZZZ,ZZZ,ZZ9.99" ? ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.Almmmate.StockMax
"Almmmate.StockMax" "Stock!Maximo" ? "decimal" ? ? ? ? ? ? no ? no no "8.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.Almmmatg.UndStk
"Almmmatg.UndStk" "Unidad" "X(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-MATG.Libre_d01
"T-MATG.Libre_d01" "Cantidad" ">>>,>>9.99" "decimal" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"(IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1) * Almmmatg.PreOfi @ Almmmatg.PreOfi" "Precio Unit.!en S/." ">>,>>9.9999" ? ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
    run alm/d-stkalm.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-DISPLAY OF br_table IN FRAME F-Main
DO:
    /* ******************************************************************************* */
    /* RHC SEMAFORO 14/11/2019 */
    /* ******************************************************************************* */
    DEF VAR pError AS CHAR NO-UNDO.
    DEF VAR pLimite AS DEC NO-UNDO.
    DEF VAR pMargen AS DEC NO-UNDO.

    DEFINE VAR hProc AS HANDLE NO-UNDO.
    RUN pri/pri-librerias PERSISTENT SET hProc.
    RUN PRI_Valida-Margen-Utilidad IN hProc (INPUT s-CodDiv,
                                             INPUT Almmmatg.CodMat,
                                             INPUT Almmmatg.CHR__01,
                                             INPUT Almmmatg.PreOfi,
                                             INPUT 1,
                                             OUTPUT pMargen,
                                             OUTPUT pLimite,
                                             OUTPUT pError).
    DELETE PROCEDURE hProc.
    IF RETURN-VALUE <> 'ADM-ERROR' THEN DO:
        RUN vtagn/p-semaforo (INPUT Almmmatg.CodMat,
                              INPUT s-CodDiv,
                              INPUT pMargen,
                              OUTPUT pForeground,
                              OUTPUT pBackground).
        ASSIGN
            x-Semaforo:BGCOLOR IN BROWSE {&BROWSE-NAME} = pBackground
            x-Semaforo:FGCOLOR IN BROWSE {&BROWSE-NAME} = pForeground.
    END.

/*     DEF VAR pError AS CHAR NO-UNDO.                                        */
/*     DEF VAR pLimite AS DEC NO-UNDO.                                        */
/*     DEF VAR pMargen AS DEC NO-UNDO.                                        */
/*     RUN vtagn/p-margen-utilidad-v2 (INPUT s-CodDiv,                        */
/*                                     INPUT Almmmatg.codmat,                 */
/*                                     INPUT Almmmatg.PreOfi,                 */
/*                                     INPUT Almmmatg.UndStk,                 */
/*                                     INPUT Almmmatg.MonVta,                 */
/*                                     INPUT Almmmatg.TpoCmb,                 */
/*                                     NO,                                    */
/*                                     INPUT x-CodAlm,                        */
/*                                     OUTPUT pMargen,                        */
/*                                     OUTPUT pLimite,                        */
/*                                     OUTPUT pError).                        */
/*     IF RETURN-VALUE = 'OK' THEN DO:                                        */
/*         IF (s-acceso-semaforos = NO AND Almmmatg.CHR__02 = "T") OR         */
/*             s-acceso-semaforos = YES THEN DO:                              */
/*             RUN vtagn/p-semaforo (INPUT Almmmatg.codmat,                   */
/*                                   INPUT s-CodDiv,                          */
/*                                   INPUT pMargen,                           */
/*                                   OUTPUT pForeground,                      */
/*                                   OUTPUT pBackground).                     */
/*             ASSIGN                                                         */
/*                 x-Semaforo:BGCOLOR IN BROWSE {&BROWSE-NAME} = pBackground  */
/*                 x-Semaforo:FGCOLOR IN BROWSE {&BROWSE-NAME} = pForeground. */
/*         END.                                                               */
/*     END.                                                                   */
    /* ******************************************************************************* */
  
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
        WHEN "DesMat" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'DesMat').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "PreOfi" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'PreOfi').
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


&Scoped-define SELF-NAME T-MATG.Libre_d01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.Libre_d01 br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-MATG.Libre_d01 IN BROWSE br_table /* Cantidad */
DO:
   FIND FIRST T-MATG OF Almmmatg NO-LOCK NO-ERROR.
   IF NOT AVAILABLE T-MATG THEN CREATE T-MATG.
   FIND CURRENT T-MATG EXCLUSIVE-LOCK NO-ERROR.
   ASSIGN
       T-MATG.CodCia = Almmmatg.CodCia
       T-MATG.CodMat = Almmmatg.CodMat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodAlm B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-CodAlm IN FRAME F-Main /* Almacén */
DO:
    ASSIGN {&SELF-NAME}.
  x-CodAlm = ENTRY(1, COMBO-BOX-CodAlm:SCREEN-VALUE, ' - ').  
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Linea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Linea B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Linea IN FRAME F-Main /* Línea */
DO:
  ASSIGN {&SELF-NAME}.
  x-CodFam = INPUT {&SELF-NAME}.
  COMBO-BOX-Sublinea:DELETE(COMBO-BOX-Sublinea:LIST-ITEMS).
  COMBO-BOX-Sublinea:ADD-LAST("Todos").
  COMBO-BOX-Sublinea:SCREEN-VALUE = "Todos".
  FOR EACH Almsfami NO-LOCK WHERE Almsfami.codcia = s-codcia
      AND Almsfami.codfam = ENTRY(1, x-CodFam, ' - ') :
      COMBO-BOX-Sublinea:ADD-LAST(AlmSFami.subfam + " - " + AlmSFami.dessub).
  END.
  APPLY 'VALUE-CHANGED':U TO COMBO-BOX-SubLinea.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-SubLinea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-SubLinea B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-SubLinea IN FRAME F-Main /* Sublínea */
DO:
  ASSIGN {&SELF-NAME}.
  x-SubFam = ENTRY(1, INPUT {&SELF-NAME}, ' - ').
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-1 B-table-Win
ON ANY-PRINTABLE OF FILL-IN-1 IN FRAME F-Main /* Descripción */
DO:
/*   x-desmat = SELF:SCREEN-VALUE + LAST-EVENT:LABEL. */
/*   {&OPEN-QUERY-{&BROWSE-NAME}}                     */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-1 B-table-Win
ON LEAVE OF FILL-IN-1 IN FRAME F-Main /* Descripción */
OR RETURN OF FILL-IN-1
DO:
    IF x-desmat = SELF:SCREEN-VALUE THEN RETURN.
    ASSIGN {&SELF-NAME}.
    x-desmat = SELF:SCREEN-VALUE.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Marca B-table-Win
ON ANY-PRINTABLE OF FILL-IN-Marca IN FRAME F-Main /* Marca */
DO:
/*   x-desmar = SELF:SCREEN-VALUE + LAST-EVENT:LABEL. */
/*   {&OPEN-QUERY-{&BROWSE-NAME}}                     */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Marca B-table-Win
ON LEAVE OF FILL-IN-Marca IN FRAME F-Main /* Marca */
OR RETURN OF FILL-IN-Marca
DO:
    IF x-desmar = SELF:SCREEN-VALUE THEN RETURN.
    ASSIGN {&SELF-NAME}.
    x-desmar = SELF:SCREEN-VALUE.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-FlgPre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-FlgPre B-table-Win
ON VALUE-CHANGED OF TOGGLE-FlgPre IN FRAME F-Main /* Productos VIP */
DO:
    ASSIGN {&SELF-NAME}.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-Stock
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-Stock B-table-Win
ON VALUE-CHANGED OF TOGGLE-Stock IN FRAME F-Main /* Solo con stock */
DO:
  ASSIGN {&SELF-NAME}.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aceptar B-table-Win 
PROCEDURE Aceptar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEF BUFFER B-MATG FOR Almmmatg.
    DEF BUFFER B-TMATG FOR T-MATG.


  DEF VAR k AS INT NO-UNDO.
  DEF VAR j AS INT NO-UNDO.

  j = 1.
  FOR EACH ITEM:
      j = j + 1.
  END.
  EMPTY TEMP-TABLE ITEM-2.
  FOR EACH B-TMATG WHERE B-TMATG.Libre_d01 > 0, FIRST B-MATG OF B-TMATG BY B-TMATG.Orden:
      FIND ITEM WHERE ITEM.codmat = B-TMATG.codmat NO-ERROR.
      IF AVAILABLE ITEM THEN DO:
          ASSIGN
              ITEM.AlmDes = x-CodAlm
              ITEM.CanPed = B-TMATG.Libre_d01.
      END.
      ELSE DO:
          CREATE ITEM.
          ASSIGN
              ITEM.CodCia = s-codcia
              ITEM.CodDiv = s-coddiv
              ITEM.CodCli = s-codcli
              ITEM.AlmDes = x-CodAlm
              ITEM.codmat = B-MATG.codmat
              ITEM.CanPed = B-TMATG.Libre_d01
              ITEM.Factor = 1
              ITEM.NroItm = j.
          j = j + 1.
      END.
      CREATE ITEM-2.
      BUFFER-COPY ITEM TO ITEM-2.
  END.
  

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
    WHEN 'DesMat':U THEN DO:
      &Scope SORTBY-PHRASE BY Almmmatg.DesMat
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'PreOfi':U THEN DO:
      &Scope SORTBY-PHRASE BY (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1) * Almmmatg.PreOfi
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
  ASSIGN
      T-MATG.CodCia = Almmmatg.CodCia
      T-MATG.CodMat = Almmmatg.CodMat
      T-MATG.Libre_d01 = DECIMAL(T-MATG.Libre_d01:SCREEN-VALUE IN BROWSE {&browse-name}).
  IF T-MATG.Libre_d01 > 0 THEN DO:
      ASSIGN
      T-MATG.Orden = pNroItem
      pNroItem = pNroItem + 1.
      /* CONSISTENCIA DE STOCK */
      DEFINE VARIABLE s-StkComprometido AS DECIMAL NO-UNDO.
      FIND Almmmate WHERE Almmmate.CodCia = T-MATG.codcia 
          AND  Almmmate.CodAlm = ENTRY(1, s-CodAlm)
          AND  Almmmate.codmat = T-MATG.codmat
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almmmate THEN DO:
          RUN vta2/Stock-Comprometido-v2 (T-MATG.codmat,
                                       ENTRY(1, s-CodAlm),
                                       OUTPUT s-StkComprometido).
          IF T-MATG.Libre_d01 > (Almmmate.StkAct - s-StkComprometido) THEN DO:
              MESSAGE "No hay STOCK disponible en el almacen" ENTRY(1, s-CodAlm) SKIP(1)
                  "     STOCK ACTUAL : " almmmate.StkAct SKIP
                  "     COMPROMETIDO : " s-StkComprometido  SKIP(1)
                  VIEW-AS ALERT-BOX WARNING.
          END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR i AS INT NO-UNDO.
  DEF VAR k AS INT NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
      DO i = 1 TO NUM-ENTRIES(s-CodAlm):
          FIND Almacen WHERE Almacen.codcia = s-codcia
              AND Almacen.codalm = ENTRY(i, s-CodAlm)
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almacen THEN DO:
              COMBO-BOX-CodAlm:ADD-LAST(almacen.codalm + ' - ' + almacen.descrip).
          END.
          IF i = 1 THEN COMBO-BOX-CodAlm:SCREEN-VALUE =  almacen.codalm + ' - ' + almacen.descrip.
      END.
      /*x-CodAlm = ENTRY(k, s-CodAlm).*/
      x-CodAlm = ENTRY(1, s-CodAlm).
      COMBO-BOX-Linea:DELIMITER = CHR(9).
      COMBO-BOX-SubLinea:DELIMITER = CHR(9).
      FOR EACH almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia:
          COMBO-BOX-Linea:ADD-LAST(Almtfami.codfam + ' - ' + Almtfami.desfam, Almtfami.codfam).

      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "Almmmate"}
  {src/adm/template/snd-list.i "T-MATG"}

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

DEFINE VARIABLE F-FACTOR AS DECI NO-UNDO.
f-Factor = 1.

/* *********************************************************************************** */
/* UNIDAD */
/* *********************************************************************************** */
DEFINE VAR pCanPed AS DEC NO-UNDO.
DEFINE VAR pMensaje AS CHAR NO-UNDO.
DEFINE VAR hProc AS HANDLE NO-UNDO.

pCanPed = DECIMAL(T-MATG.Libre_d01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
IF pCanPed = 0 THEN RETURN 'OK'.

RUN vtagn/ventas-library PERSISTENT SET hProc.

  RUN VTA_Valida-Cantidad IN hProc (INPUT Almmmatg.CodMat,
                                  INPUT Almmmatg.undstk,
                                  INPUT-OUTPUT pCanPed,
                                  OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      T-MATG.Libre_d01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(pCanPed).
      APPLY 'ENTRY':U TO T-MATG.Libre_d01.
      RETURN "ADM-ERROR".
  END.
/* RUN VTA_Valida-Unidad IN hProc (INPUT Almmmatg.CodMat,                        */
/*                                 INPUT Almmmatg.undstk,                        */
/*                                 INPUT-OUTPUT pCanPed,                         */
/*                                 OUTPUT pMensaje).                             */
/* IF RETURN-VALUE = 'ADM-ERROR' THEN DO:                                        */
/*     MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.                                 */
/*     T-MATG.Libre_d01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(pCanPed). */
/*     APPLY 'ENTRY':U TO T-MATG.Libre_d01.                                      */
/*     RETURN "ADM-ERROR".                                                       */
/* END.                                                                          */
/* *********************************************************************************** */
/* EMPAQUE */
/* *********************************************************************************** */
  DEF VAR pSugerido AS DEC NO-UNDO.
  DEF VAR pEmpaque AS DEC NO-UNDO.
  pCanPed = DECIMAL(T-MATG.Libre_d01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
  RUN vtagn/p-cantidad-sugerida-v2 (INPUT s-CodDiv,
                                    INPUT s-CodDiv,
                                    INPUT Almmmatg.codmat,
                                    INPUT pCanPed,
                                    INPUT Almmmatg.UndStk,
                                    INPUT s-CodCli,
                                    OUTPUT pSugerido,
                                    OUTPUT pEmpaque,
                                    OUTPUT pMensaje).
  IF pMensaje > '' THEN DO:
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      T-MATG.Libre_d01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(pSugerido).
      APPLY 'ENTRY':U TO T-MATG.Libre_d01.
      RETURN "ADM-ERROR".
  END.
/* RUN VTA_Valida-Empaque IN hProc (INPUT s-CodCli,                                          */
/*                                  INPUT Almmmatg.codmat,                                   */
/*                                  INPUT-OUTPUT pCanPed,                                    */
/*                                  INPUT f-Factor,                                          */
/*                                  INPUT s-TpoPed,                                          */
/*                                  OUTPUT pMensaje).                                        */
/* IF RETURN-VALUE = 'ADM-ERROR' THEN DO:                                                    */
/*     MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.                                             */
/*     T-MATG.Libre_d01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(pCanPed).             */
/*     APPLY 'ENTRY':U TO T-MATG.Libre_d01.                                                  */
/*     RETURN "ADM-ERROR".                                                                   */
/* END.                                                                                      */
/* /* *********************************************************************************** */ */
/* /* MINIMO DE VENTA */                                                                     */
/* /* *********************************************************************************** */ */
/* RUN VTA_Valida-Minimo IN hProc (INPUT Almmmatg.codmat,                                    */
/*                                 INPUT-OUTPUT pCanPed,                                     */
/*                                 INPUT f-Factor,                                           */
/*                                 OUTPUT pMensaje).                                         */
/* IF RETURN-VALUE = 'ADM-ERROR' THEN DO:                                                    */
/*     MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.                                             */
/*     T-MATG.Libre_d01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(pCanPed).             */
/*     APPLY 'ENTRY':U TO T-MATG.Libre_d01.                                                  */
/*     RETURN "ADM-ERROR".                                                                   */
/* END.                                                                                      */

DELETE PROCEDURE hProc.
/* *********************************************************************************** */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fComprometido B-table-Win 
FUNCTION fComprometido RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR x-StockComprometido AS DEC NO-UNDO.

RUN vta2/stock-comprometido-v2 (Almmmatg.CodMat, x-CodAlm, OUTPUT x-StockComprometido).
RETURN x-StockComprometido.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

