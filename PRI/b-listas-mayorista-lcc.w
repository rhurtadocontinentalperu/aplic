&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-MATG NO-UNDO LIKE lcc_mayorista.



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
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-Lineas-Validas AS CHAR.

DEF VAR x-MonCmp AS CHAR NO-UNDO.
DEF VAR x-CtoTotMarco LIKE Almmmatg.CtoTotMarco NO-UNDO.

DEF VAR MaxCat AS INTE NO-UNDO.
DEF VAR MaxVta AS INTE NO-UNDO.
DEF VAR fmot   AS DECI NO-UNDO.
DEF VAR MrgMin AS DECI NO-UNDO.
DEF VAR MrgOfi AS DECI NO-UNDO.
DEF VAR F-FACTOR AS DECI NO-UNDO.
DEFINE VARIABLE F-MrgUti-A AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-MrgUti-B AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-MrgUti-C AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PreVta-A AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PreVta-B AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PreVta-C AS DECIMAL NO-UNDO.
DEFINE VARIABLE X-CTOUND AS DECIMAL NO-UNDO.
DEFINE VARIABLE X-CTOTOT AS DECIMAL FORMAT "->>>>>>>>>9.999999" NO-UNDO.

DEFINE VARIABLE pre-ofi LIKE Almmmatg.PreOfi.
DEF VAR pError AS CHAR NO-UNDO.
DEF VAR pAlerta AS CHAR NO-UNDO.

DEFINE VAR x-FlgEst AS CHAR INIT 'P' NO-UNDO.       /* Valor por defecto */

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
&Scoped-define INTERNAL-TABLES lcc_mayorista Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table lcc_mayorista.codmat ~
Almmmatg.DesMat Almmmatg.UndStk Almmmatg.DesMar Almmmatg.dsctoprom[2] ~
( IF Almmmatg.DsctoProm[1] = 1 THEN  'Soles'  ELSE 'Dolares' ) @ x-MonCmp ~
lcc_mayorista.MonVta Almmmatg.TpoCmb ~
fCtoTot(lcc_mayorista.MonVta,lcc_mayorista.CodMat) @ lcc_mayorista.CtoTot ~
fCtoTotMarco(lcc_mayorista.MonVta,lcc_mayorista.CodMat) @ lcc_mayorista.CtoTotMarco ~
lcc_mayorista.Prevta[1] lcc_mayorista.MrgUti-A lcc_mayorista.Prevta[2] ~
Almmmatg.UndA lcc_mayorista.MrgUti-B lcc_mayorista.Prevta[3] Almmmatg.UndB ~
lcc_mayorista.MrgUti-C lcc_mayorista.Prevta[4] Almmmatg.UndC ~
lcc_mayorista.Dec__01 lcc_mayorista.PreOfi Almmmatg.Chr__01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table lcc_mayorista.codmat ~
lcc_mayorista.MonVta lcc_mayorista.Prevta[1] lcc_mayorista.MrgUti-A ~
lcc_mayorista.Prevta[2] lcc_mayorista.MrgUti-B lcc_mayorista.Prevta[3] ~
lcc_mayorista.MrgUti-C lcc_mayorista.Prevta[4] lcc_mayorista.Dec__01 ~
lcc_mayorista.PreOfi 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table lcc_mayorista
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table lcc_mayorista
&Scoped-define QUERY-STRING-br_table FOR EACH lcc_mayorista WHERE ~{&KEY-PHRASE} ~
      AND lcc_mayorista.CodCia = s-codcia ~
 AND lcc_mayorista.FlgEst = x-FlgEst NO-LOCK, ~
      FIRST Almmmatg OF lcc_mayorista ~
      WHERE almmmatg.codfam = COMBO-BOX-Linea ~
 AND (COMBO-BOX-Sublinea = 'Todas' OR Almmmatg.subfam = COMBO-BOX-Sublinea) NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH lcc_mayorista WHERE ~{&KEY-PHRASE} ~
      AND lcc_mayorista.CodCia = s-codcia ~
 AND lcc_mayorista.FlgEst = x-FlgEst NO-LOCK, ~
      FIRST Almmmatg OF lcc_mayorista ~
      WHERE almmmatg.codfam = COMBO-BOX-Linea ~
 AND (COMBO-BOX-Sublinea = 'Todas' OR Almmmatg.subfam = COMBO-BOX-Sublinea) NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table lcc_mayorista Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table lcc_mayorista
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Linea BUTTON-ENVIAR ~
COMBO-BOX-Sublinea br_table 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Linea COMBO-BOX-Sublinea 

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
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCtoTot B-table-Win 
FUNCTION fCtoTot RETURNS DECIMAL
  ( INPUT pMonVta AS INTE, INPUT pCodMat AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCtoTotMarco B-table-Win 
FUNCTION fCtoTotMarco RETURNS DECIMAL
  ( INPUT pMonVta AS INTE, INPUT pCodMat AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-ENVIAR 
     LABEL "ENVIAR AL SUPERVISOR" 
     SIZE 30 BY 1.12.

DEFINE VARIABLE COMBO-BOX-Linea AS CHARACTER FORMAT "X(256)":U 
     LABEL "Linea" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Todas","Todas"
     DROP-DOWN-LIST
     SIZE 77 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Sublinea AS CHARACTER FORMAT "X(256)":U INITIAL "TODAS" 
     LABEL "Sublinea" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Todas","Todas"
     DROP-DOWN-LIST
     SIZE 77 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      lcc_mayorista, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      lcc_mayorista.codmat COLUMN-LABEL "Articulo" FORMAT "X(15)":U
            WIDTH 6 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      Almmmatg.DesMat FORMAT "X(60)":U
      Almmmatg.UndStk COLUMN-LABEL "Unidad" FORMAT "X(6)":U WIDTH 7.43
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U WIDTH 13.43
      Almmmatg.dsctoprom[2] COLUMN-LABEL "Costo" FORMAT "->>>,>>9.9999":U
            WIDTH 9.43
      ( IF Almmmatg.DsctoProm[1] = 1 THEN  'Soles'  ELSE 'Dolares' ) @ x-MonCmp COLUMN-LABEL "Moneda!Compra"
            WIDTH 6.43
      lcc_mayorista.MonVta COLUMN-LABEL "Moneda!LP" FORMAT "9":U
            WIDTH 8.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "Soles",1,
                                      "Dolares",2
                      DROP-DOWN-LIST 
      Almmmatg.TpoCmb COLUMN-LABEL "TC!Venta" FORMAT "Z9.9999":U
      fCtoTot(lcc_mayorista.MonVta,lcc_mayorista.CodMat) @ lcc_mayorista.CtoTot COLUMN-LABEL "Costo Total" FORMAT ">>>,>>9.9999":U
      fCtoTotMarco(lcc_mayorista.MonVta,lcc_mayorista.CodMat) @ lcc_mayorista.CtoTotMarco COLUMN-LABEL "Costo MARCO" FORMAT ">>>,>>9.9999":U
      lcc_mayorista.Prevta[1] COLUMN-LABEL "Precio Lista" FORMAT ">>>,>>9.9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      lcc_mayorista.MrgUti-A COLUMN-LABEL "% Uti A" FORMAT "->>,>>9.99":U
            WIDTH 6.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      lcc_mayorista.Prevta[2] COLUMN-LABEL "Precio A" FORMAT ">>>,>>9.9999":U
            WIDTH 9 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      Almmmatg.UndA COLUMN-LABEL "UM A" FORMAT "X(8)":U WIDTH 5.43
      lcc_mayorista.MrgUti-B COLUMN-LABEL "% Uti B" FORMAT "->>,>>9.99":U
            WIDTH 7.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      lcc_mayorista.Prevta[3] COLUMN-LABEL "Precio B" FORMAT ">>>,>>9.9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      Almmmatg.UndB COLUMN-LABEL "UM B" FORMAT "X(8)":U
      lcc_mayorista.MrgUti-C COLUMN-LABEL "% Uti C" FORMAT "->>,>>9.99":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      lcc_mayorista.Prevta[4] COLUMN-LABEL "Precio C" FORMAT ">>>,>>9.9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      Almmmatg.UndC COLUMN-LABEL "UM C" FORMAT "X(8)":U
      lcc_mayorista.Dec__01 COLUMN-LABEL "% Uti Ofi" FORMAT "->>,>>9.99":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      lcc_mayorista.PreOfi FORMAT ">>>,>>9.9999":U COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      Almmmatg.Chr__01 COLUMN-LABEL "UM Ofic" FORMAT "X(6)":U
  ENABLE
      lcc_mayorista.codmat
      lcc_mayorista.MonVta
      lcc_mayorista.Prevta[1]
      lcc_mayorista.MrgUti-A
      lcc_mayorista.Prevta[2]
      lcc_mayorista.MrgUti-B
      lcc_mayorista.Prevta[3]
      lcc_mayorista.MrgUti-C
      lcc_mayorista.Prevta[4]
      lcc_mayorista.Dec__01
      lcc_mayorista.PreOfi
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 189 BY 21.27
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Linea AT ROW 1.27 COL 12 COLON-ALIGNED WIDGET-ID 2
     BUTTON-ENVIAR AT ROW 1.54 COL 151 WIDGET-ID 6
     COMBO-BOX-Sublinea AT ROW 2.08 COL 12 COLON-ALIGNED WIDGET-ID 4
     br_table AT ROW 3.15 COL 1
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
      TABLE: T-MATG T "?" NO-UNDO INTEGRAL lcc_mayorista
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
         HEIGHT             = 24.27
         WIDTH              = 190.43.
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
/* BROWSE-TAB br_table COMBO-BOX-Sublinea F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 11.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.lcc_mayorista,INTEGRAL.Almmmatg OF INTEGRAL.lcc_mayorista"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _Where[1]         = "lcc_mayorista.CodCia = s-codcia
 AND lcc_mayorista.FlgEst = x-FlgEst"
     _Where[2]         = "almmmatg.codfam = COMBO-BOX-Linea
 AND (COMBO-BOX-Sublinea = 'Todas' OR Almmmatg.subfam = COMBO-BOX-Sublinea)"
     _FldNameList[1]   > INTEGRAL.lcc_mayorista.codmat
"lcc_mayorista.codmat" "Articulo" "X(15)" "character" 11 0 ? ? ? ? yes ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.UndStk
"Almmmatg.UndStk" "Unidad" "X(6)" "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.Almmmatg.dsctoprom[2]
"Almmmatg.dsctoprom[2]" "Costo" "->>>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"( IF Almmmatg.DsctoProm[1] = 1 THEN  'Soles'  ELSE 'Dolares' ) @ x-MonCmp" "Moneda!Compra" ? ? ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.lcc_mayorista.MonVta
"lcc_mayorista.MonVta" "Moneda!LP" ? "integer" 11 0 ? ? ? ? yes ? no no "8.43" yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "Soles,1,Dolares,2" 5 no 0 no no
     _FldNameList[8]   > INTEGRAL.Almmmatg.TpoCmb
"Almmmatg.TpoCmb" "TC!Venta" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"fCtoTot(lcc_mayorista.MonVta,lcc_mayorista.CodMat) @ lcc_mayorista.CtoTot" "Costo Total" ">>>,>>9.9999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"fCtoTotMarco(lcc_mayorista.MonVta,lcc_mayorista.CodMat) @ lcc_mayorista.CtoTotMarco" "Costo MARCO" ">>>,>>9.9999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.lcc_mayorista.Prevta[1]
"lcc_mayorista.Prevta[1]" "Precio Lista" ">>>,>>9.9999" "decimal" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.lcc_mayorista.MrgUti-A
"lcc_mayorista.MrgUti-A" "% Uti A" ? "decimal" 11 0 ? ? ? ? yes ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > INTEGRAL.lcc_mayorista.Prevta[2]
"lcc_mayorista.Prevta[2]" "Precio A" ">>>,>>9.9999" "decimal" 11 0 ? ? ? ? yes ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > INTEGRAL.Almmmatg.UndA
"Almmmatg.UndA" "UM A" ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > INTEGRAL.lcc_mayorista.MrgUti-B
"lcc_mayorista.MrgUti-B" "% Uti B" ? "decimal" 11 0 ? ? ? ? yes ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > INTEGRAL.lcc_mayorista.Prevta[3]
"lcc_mayorista.Prevta[3]" "Precio B" ">>>,>>9.9999" "decimal" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > INTEGRAL.Almmmatg.UndB
"Almmmatg.UndB" "UM B" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > INTEGRAL.lcc_mayorista.MrgUti-C
"lcc_mayorista.MrgUti-C" "% Uti C" ? "decimal" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > INTEGRAL.lcc_mayorista.Prevta[4]
"lcc_mayorista.Prevta[4]" "Precio C" ">>>,>>9.9999" "decimal" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > INTEGRAL.Almmmatg.UndC
"Almmmatg.UndC" "UM C" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > INTEGRAL.lcc_mayorista.Dec__01
"lcc_mayorista.Dec__01" "% Uti Ofi" "->>,>>9.99" "decimal" 14 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > INTEGRAL.lcc_mayorista.PreOfi
"lcc_mayorista.PreOfi" ? ">>>,>>9.9999" "decimal" 14 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > INTEGRAL.Almmmatg.Chr__01
"Almmmatg.Chr__01" "UM Ofic" "X(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lcc_mayorista.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lcc_mayorista.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF lcc_mayorista.codmat IN BROWSE br_table /* Articulo */
DO:
    IF TRUE <> ( SELF:SCREEN-VALUE > '' ) THEN RETURN.

    DEF VAR pCodMat AS CHAR NO-UNDO.

    pCodMat = SELF:SCREEN-VALUE.
    RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, YES).
    IF pCodMat = '' THEN DO:
        ASSIGN SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.        

    SELF:SCREEN-VALUE = pCodMat.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = pCodMat NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        MESSAGE 'Artículo NO registrado' VIEW-AS ALERT-BOX ERROR.
        ASSIGN SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.

    IF Almmmatg.CodFam <> COMBO-BOX-Linea THEN DO:
        MESSAGE 'Artículo NO pertenece a la línea válida para este usuario' SKIP
            COMBO-BOX-Linea
            VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.

    IF CAN-FIND(FIRST lcc_mayorista WHERE lcc_mayorista.CodCia = s-CodCia
                AND lcc_mayorista.codmat = SELF:SCREEN-VALUE
                AND lcc_mayorista.FlgEst = "P" NO-LOCK)
        THEN DO:
        MESSAGE 'Artículo YA registrado' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.

    IF Almmmatg.CHR__02 = "T" THEN 
        ASSIGN lcc_mayorista.Prevta[1]:READ-ONLY IN BROWSE {&browse-name} = YES.
    ELSE
        ASSIGN lcc_mayorista.Prevta[1]:READ-ONLY IN BROWSE {&browse-name} = NO.

    DISPLAY
        Almmmatg.Chr__01 
        Almmmatg.DesMar 
        Almmmatg.DesMat 
        Almmmatg.TpoCmb 
        Almmmatg.UndA 
        Almmmatg.UndB 
        Almmmatg.UndC 
        Almmmatg.UndStk 
        ( IF Almmmatg.DsctoProm[1] = 1 THEN  'Soles'  ELSE 'Dolares' ) @ x-MonCmp
        Almmmatg.dsctoprom[2] 
        Almmmatg.MonVta @ lcc_mayorista.MonVta
        Almmmatg.MrgUti-A @ lcc_mayorista.MrgUti-A 
        Almmmatg.MrgUti-B @ lcc_mayorista.MrgUti-B 
        Almmmatg.MrgUti-C @ lcc_mayorista.MrgUti-C 
        Almmmatg.PreOfi @ lcc_mayorista.PreOfi 
        Almmmatg.Prevta[1] @ lcc_mayorista.Prevta[1] 
        Almmmatg.Prevta[2] @ lcc_mayorista.Prevta[2] 
        Almmmatg.Prevta[3] @ lcc_mayorista.Prevta[3] 
        Almmmatg.Prevta[4] @ lcc_mayorista.Prevta[4]
        WITH BROWSE {&browse-name}.
   DISPLAY
       fCtoTot(Almmmatg.MonVta,Almmmatg.CodMat) @ lcc_mayorista.CtoTot
       fCtoTotMarco(Almmmatg.MonVta,Almmmatg.CodMat) @ lcc_mayorista.CtoTotMarco
       WITH BROWSE {&browse-name}.
   SELF:READ-ONLY = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lcc_mayorista.MonVta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lcc_mayorista.MonVta br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF lcc_mayorista.MonVta IN BROWSE br_table /* Moneda!LP */
DO:
  /* Al cambiar la moneda de venta cambian los siguientes valores */
  DISPLAY 
      fCToTot(INTEGER(SELF:SCREEN-VALUE),lcc_mayorista.codmat:SCREEN-VALUE IN BROWSE {&browse-name}) @ lcc_mayorista.CtoTot
      fCtoTotMarco(INTEGER(SELF:SCREEN-VALUE),lcc_mayorista.codmat:SCREEN-VALUE IN BROWSE {&browse-name}) @ lcc_mayorista.CtoTotMarco
      WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lcc_mayorista.Prevta[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lcc_mayorista.Prevta[1] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF lcc_mayorista.Prevta[1] IN BROWSE br_table /* Precio Lista */
DO:
    RUN Precio-de-Oficina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lcc_mayorista.MrgUti-A
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lcc_mayorista.MrgUti-A br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF lcc_mayorista.MrgUti-A IN BROWSE br_table /* % Uti A */
DO:
    ASSIGN
        F-MrgUti-A = DECIMAL(lcc_mayorista.MrgUti-A:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
        X-CTOUND   = DECIMAL(lcc_mayorista.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).

     F-FACTOR = 1.
     F-PreVta-A = 0.
     /****   Busca el Factor de conversion   ****/
     IF Almmmatg.UndA <> "" THEN DO:
         FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
             AND  Almtconv.Codalter = Almmmatg.UndA
             NO-LOCK NO-ERROR.
         IF NOT AVAILABLE Almtconv THEN DO:
             MESSAGE "Codigo de unidad de CONVERSION no existe" VIEW-AS ALERT-BOX ERROR.
             RETURN NO-APPLY.
         END.
         F-FACTOR = Almtconv.Equival.
         F-PreVta-A = ROUND(( X-CTOUND * (1 + F-MrgUti-A / 100) ), 6) * F-FACTOR.
         /*MESSAGE almmmatg.codmat x-ctound f-mrguti-a f-factor.*/
     END.

    DISPLAY F-PreVta-A @ lcc_mayorista.Prevta[2] WITH BROWSE {&BROWSE-NAME}.

    RUN Precio-de-Oficina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lcc_mayorista.Prevta[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lcc_mayorista.Prevta[2] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF lcc_mayorista.Prevta[2] IN BROWSE br_table /* Precio A */
DO:
    ASSIGN
        F-PreVta-A = DECIMAL(lcc_mayorista.Prevta[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
        X-CTOUND = DECIMAL(lcc_mayorista.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).

    F-FACTOR = 1.
    F-MrgUti-A = 0.    
    /****   Busca el Factor de conversion   ****/
    IF Almmmatg.UndA <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
            AND  Almtconv.Codalter = Almmmatg.UndA
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN DO:
            MESSAGE "Codigo de unidad de CONVERSION no existe" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        F-FACTOR = Almtconv.Equival.
        F-MrgUti-A = ROUND(((((F-PreVta-A / F-FACTOR) / X-CTOUND) - 1) * 100), 6).
    END.
    /*******************************************/
    DISPLAY F-MrgUti-A @ lcc_mayorista.MrgUti-A WITH BROWSE {&BROWSE-NAME}.
    RUN Precio-de-Oficina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lcc_mayorista.MrgUti-B
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lcc_mayorista.MrgUti-B br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF lcc_mayorista.MrgUti-B IN BROWSE br_table /* % Uti B */
DO:
    ASSIGN
        F-MrgUti-B = DECIMAL(lcc_mayorista.MrgUti-B:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
        X-CTOUND   = DECIMAL(lcc_mayorista.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).

     F-FACTOR = 1.
     F-Prevta-B = 0.
     /****   Busca el Factor de conversion   ****/
     IF Almmmatg.UndB <> "" THEN DO:
         FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
                        AND  Almtconv.Codalter = Almmmatg.UndB
                       NO-LOCK NO-ERROR.
         IF NOT AVAILABLE Almtconv THEN DO:
            MESSAGE "Codigo de unidad de CONVERSION no exixte" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
         END.
         F-FACTOR = Almtconv.Equival.
         F-PreVta-B = ROUND(( X-CTOUND * (1 + F-MrgUti-B / 100) ), 6) * F-FACTOR.
     END.
    DISPLAY F-PreVta-B @ lcc_mayorista.Prevta[3]
            WITH BROWSE {&BROWSE-NAME}.

    RUN Precio-de-Oficina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lcc_mayorista.Prevta[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lcc_mayorista.Prevta[3] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF lcc_mayorista.Prevta[3] IN BROWSE br_table /* Precio B */
DO:
    ASSIGN
        F-PreVta-B = DECIMAL(lcc_mayorista.Prevta[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
        X-CTOUND = DECIMAL(lcc_mayorista.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).


     F-FACTOR = 1.
     F-MrgUti-B = 0.   
     /****   Busca el Factor de conversion   ****/
     IF Almmmatg.UndB <> "" THEN DO:
         FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
                        AND  Almtconv.Codalter = Almmmatg.UndB
                       NO-LOCK NO-ERROR.
         IF NOT AVAILABLE Almtconv THEN DO:
            MESSAGE "Codigo de unidad de CONVERSION no existe" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
         END.
         F-FACTOR = Almtconv.Equival.
         F-MrgUti-B = ROUND(((((F-PreVta-B / F-FACTOR) / X-CTOUND) - 1) * 100), 6).
     END.
     /*******************************************/


     DISPLAY F-MrgUti-B @ lcc_mayorista.MrgUti-B
             WITH BROWSE {&BROWSE-NAME}.

     RUN Precio-de-Oficina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lcc_mayorista.MrgUti-C
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lcc_mayorista.MrgUti-C br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF lcc_mayorista.MrgUti-C IN BROWSE br_table /* % Uti C */
DO:
    ASSIGN
        F-MrgUti-C = DECIMAL(lcc_mayorista.MrgUti-C:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
        X-CTOUND   = DECIMAL(lcc_mayorista.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).

     F-FACTOR = 1.
     F-Prevta-C = 0.
     /****   Busca el Factor de conversion   ****/
     IF Almmmatg.UndC <> "" THEN DO:
         FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
                        AND  Almtconv.Codalter = Almmmatg.UndC
                       NO-LOCK NO-ERROR.
         IF NOT AVAILABLE Almtconv THEN DO:
            MESSAGE "Codigo de unidad de CONVERSION no exixte" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
         END.
         F-FACTOR = Almtconv.Equival.
         F-PreVta-C = ROUND(( X-CTOUND * (1 + F-MrgUti-C / 100) ), 6) * F-FACTOR.
     END.
    DISPLAY F-PreVta-C @ lcc_mayorista.Prevta[4]
            WITH BROWSE {&BROWSE-NAME}.

    RUN Precio-de-Oficina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lcc_mayorista.Prevta[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lcc_mayorista.Prevta[4] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF lcc_mayorista.Prevta[4] IN BROWSE br_table /* Precio C */
DO:
    ASSIGN
        F-PreVta-C = DECIMAL(lcc_mayorista.Prevta[4]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
        X-CTOUND = DECIMAL(lcc_mayorista.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).

     F-FACTOR = 1.
     F-MrgUti-C = 0.
     /****   Busca el Factor de conversion   ****/
     IF Almmmatg.UndC <> "" THEN DO:
         FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
                        AND  Almtconv.Codalter = Almmmatg.UndC
                       NO-LOCK NO-ERROR.
         IF NOT AVAILABLE Almtconv THEN DO:
            MESSAGE "Codigo de unidad de CONVERSION no exixte" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
         END.
         F-FACTOR = Almtconv.Equival.
         F-MrgUti-C = ROUND(((((F-PreVta-C / F-FACTOR) / X-CTOUND) - 1) * 100), 6).
     END.
     /*******************************************/
     DISPLAY F-MrgUti-C @ lcc_mayorista.MrgUti-C
             WITH BROWSE {&BROWSE-NAME}.

     RUN Precio-de-Oficina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-ENVIAR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-ENVIAR B-table-Win
ON CHOOSE OF BUTTON-ENVIAR IN FRAME F-Main /* ENVIAR AL SUPERVISOR */
DO:
  MESSAGE 'Enviamos la lista de precios al Supervisor para su Aprobación?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  RUN Enviar-Supervisor.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Linea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Linea B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Linea IN FRAME F-Main /* Linea */
DO:
  ASSIGN {&self-name}.
  COMBO-BOX-Sublinea:DELETE(COMBO-BOX-Sublinea:LIST-ITEM-PAIRS).
  COMBO-BOX-Sublinea:ADD-LAST("Todas","Todas").
  COMBO-BOX-Sublinea = "Todas".
  FOR EACH Almsfami NO-LOCK WHERE Almsfami.codcia = s-codcia
      AND Almsfami.codfam = COMBO-BOX-Linea:
      COMBO-BOX-Sublinea:ADD-LAST(AlmSFami.subfam + " - " + AlmSFami.dessub, AlmSFami.subfam).
  END.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Sublinea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Sublinea B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Sublinea IN FRAME F-Main /* Sublinea */
DO:
  ASSIGN {&self-name}.
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

ON 'RETURN':U OF lcc_mayorista.codmat,
    lcc_mayorista.MrgUti-A,
    lcc_mayorista.MrgUti-B, 
    lcc_mayorista.MrgUti-C, 
    lcc_mayorista.Prevta[1], 
    lcc_mayorista.Prevta[2], 
    lcc_mayorista.Prevta[3], 
    lcc_mayorista.Prevta[4]
    DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

ON 'ENTRY':U OF lcc_mayorista.MrgUti-A,
    lcc_mayorista.MrgUti-B, 
    lcc_mayorista.MrgUti-C, 
    lcc_mayorista.Prevta[1], 
    lcc_mayorista.Prevta[2], 
    lcc_mayorista.Prevta[3], 
    lcc_mayorista.Prevta[4]
    DO:
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia 
        AND Almmmatg.codmat = lcc_mayorista.codmat:SCREEN-VALUE IN BROWSE {&browse-name}
        NO-LOCK NO-ERROR.
    RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aprobar B-table-Win 
PROCEDURE Aprobar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Cmabia el FlgEst = "A" (aprobado) y migra los precios a la tabla ALMMMATG
------------------------------------------------------------------------------*/

DEFINE IMAGE IMAGE-1 FILENAME "IMG\tbldat.ico" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
    SKIP
    Fi-Mensaje NO-LABEL FONT 6
    SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
    SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
    BGCOLOR 15 FGCOLOR 0 
    TITLE "Procesando ..." FONT 7.

DEF VAR pMensaje AS CHAR NO-UNDO.

EMPTY TEMP-TABLE T-MATG.

GET FIRST {&browse-name}.
REPEAT WHILE AVAILABLE lcc_mayorista:
    CREATE T-MATG.
    BUFFER-COPY lcc_mayorista TO T-MATG.
    GET NEXT {&browse-name}.
END.

FOR EACH T-MATG:
    FIND lcc_mayorista WHERE lcc_mayorista.CodCia = T-MATG.codcia
        AND lcc_mayorista.codmat = T-MATG.codmat
        AND lcc_mayorista.FlgEst = "X" NO-LOCK NO-ERROR.
    IF NOT AVAILABLE lcc_mayorista THEN NEXT.
    DISPLAY "ARTICULO: " + T-MATG.CodMat @ Fi-Mensaje WITH FRAME F-Proceso.
    RUN Aprobar-Detalle (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    END.
END.
HIDE FRAME F-Proceso.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* *************************** */
PROCEDURE Aprobar-Detalle:
/* *************************** */

    DEF VAR F-PreAnt LIKE Almmmatg.PreBas NO-UNDO.
    DEF VAR f-PorIgv AS DECI NO-UNDO.

    DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    {lib/lock-genericov3.i &Tabla="lcc_mayorista" ~
        &Condicion="lcc_mayorista.CodCia = T-MATG.codcia ~
        AND lcc_mayorista.codmat = T-MATG.codmat ~
        AND lcc_mayorista.FlgEst = 'X'" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR NO-WAIT" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
    ASSIGN
        lcc_mayorista.DateUpdate = TODAY
        lcc_mayorista.HourUpdate = STRING(TIME,'HH:MM:SS')
        lcc_mayorista.UserUpdate = s-user-id
        lcc_mayorista.FlgEst = "A".
    FIND Almmmatg OF lcc_mayorista NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN NEXT.
    FIND CURRENT Almmmatg EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        Almmmatg.Dec__01 = lcc_mayorista.Dec__01 
        Almmmatg.MonVta = lcc_mayorista.MonVta 
        Almmmatg.MrgUti-A = lcc_mayorista.MrgUti-A 
        Almmmatg.MrgUti-B = lcc_mayorista.MrgUti-B 
        Almmmatg.MrgUti-C = lcc_mayorista.MrgUti-C 
        Almmmatg.PreOfi = lcc_mayorista.PreOfi 
        Almmmatg.Prevta[1] = lcc_mayorista.Prevta[1] 
        Almmmatg.Prevta[2] = lcc_mayorista.Prevta[2] 
        Almmmatg.Prevta[3] = lcc_mayorista.Prevta[3] 
        Almmmatg.Prevta[4] = lcc_mayorista.Prevta[4].
    /* ********************************************************************************* */
    /* REGRABAMOS LOS COSTOS */
    /* ********************************************************************************* */
    F-PreAnt = Almmmatg.PreBas.
    f-PorIgv = 0.
    FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
    IF AVAILABLE FacCfgGn THEN f-PorIgv = FacCfgGn.PorIgv.
    FIND FIRST Sunat_Fact_Electr_Taxs  WHERE Sunat_Fact_Electr_Taxs.TaxTypeCode = "IGV"
        AND Sunat_Fact_Electr_Taxs.Disabled = NO
        AND TODAY >= Sunat_Fact_Electr_Taxs.Start_Date 
        AND TODAY <= Sunat_Fact_Electr_Taxs.End_Date 
        AND Sunat_Fact_Electr_Taxs.Tax > 0
        NO-LOCK NO-ERROR.
    IF AVAILABLE Sunat_Fact_Electr_Taxs THEN f-PorIgv = Sunat_Fact_Electr_Taxs.Tax.
    IF Almmmatg.MonVta = Almmmatg.DsctoPro[1] THEN    /* Moneda LP vs Moneda Compra */
        ASSIGN Almmmatg.CtoTot = Almmmatg.DsctoPro[2].
    ELSE IF Almmmatg.MonVta = 1 THEN
        ASSIGN Almmmatg.CtoTot = Almmmatg.DsctoPro[2] * Almmmatg.TpoCmb.
    ELSE ASSIGN Almmmatg.CtoTot = Almmmatg.DsctoPro[2] / Almmmatg.TpoCmb.
    IF Almmmatg.AftIgv = YES 
        THEN ASSIGN Almmmatg.CtoLis = Almmmatg.CtoTot / ( 1 + ( f-PorIgv / 100) ).
    ELSE ASSIGN Almmmatg.CtoLis = Almmmatg.CtoTot.
    
    /* ************************** */
    /* Actualizamos Margen */
    /* ************************** */
    IF Almmmatg.AftIgv THEN Almmmatg.PreBas = ROUND(Almmmatg.PreVta[1] / ( 1 + f-PorIgv / 100), 6).
    Almmmatg.MrgUti = ((Almmmatg.Prevta[1] / Almmmatg.Ctotot) - 1 ) * 100. 
    F-FACTOR = 1.
    IF Almmmatg.UndA > "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
            AND  Almtconv.Codalter = Almmmatg.UndA
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
        Almmmatg.Dsctos[1] =  (((Almmmatg.Prevta[2] / F-FACTOR)/ Almmmatg.Prevta[1]) - 1 ) * 100. 
    END.
    F-FACTOR = 1.
    IF Almmmatg.UndB > "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
            AND  Almtconv.Codalter = Almmmatg.UndB
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
        Almmmatg.Dsctos[2] =  (((Almmmatg.Prevta[3] / F-FACTOR)/ Almmmatg.Prevta[1]) - 1 ) * 100. 
    END.
    F-FACTOR = 1.
    IF Almmmatg.UndC > "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
            AND  Almtconv.Codalter = Almmmatg.UndC
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
        Almmmatg.Dsctos[3] =  (((Almmmatg.Prevta[4] / F-FACTOR)/ Almmmatg.Prevta[1]) - 1 ) * 100. 
    END.
    IF F-PreAnt <> Almmmatg.PreBas THEN Almmmatg.FchmPre[3] = TODAY.
    ASSIGN
        Almmmatg.FchmPre[1] = TODAY
        Almmmatg.Usuario = T-MATG.Usuario
        Almmmatg.FchAct  = TODAY.

    RELEASE Almmmatg.
    RELEASE lcc_mayorista.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Disable-Columns B-table-Win 
PROCEDURE Disable-Columns :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR hBrowse AS HANDLE NO-UNDO.
DEF VAR hColumn AS HANDLE NO-UNDO.
DEF VAR iCounter AS INT NO-UNDO.

ASSIGN hBrowse = BROWSE {&BROWSE-NAME}:HANDLE.

DO iCounter = 1 TO hBrowse:NUM-COLUMNS:
    hColumn = hBrowse:GET-BROWSE-COLUMN(iCounter).
    IF hColumn:NAME = "x-MonCmp" THEN NEXT.
    IF hColumn:NAME = "x-MonCmp" THEN NEXT.
    ASSIGN hColumn:READ-ONLY = TRUE NO-ERROR.
END.
BUTTON-ENVIAR:HIDDEN IN FRAME {&FRAME-NAME} = YES.
BUTTON-ENVIAR:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

x-FlgEst = "X".

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Enviar-Supervisor B-table-Win 
PROCEDURE Enviar-Supervisor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Cambiamos el FlgEst de P a X
------------------------------------------------------------------------------*/

DEF VAR k AS INTE NO-UNDO.

GET FIRST {&browse-name}.
REPEAT WHILE AVAILABLE lcc_mayorista:
    FIND CURRENT lcc_mayorista EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF AVAILABLE lcc_mayorista THEN DO:
        ASSIGN
            lcc_mayorista.FlgEst = "X".
    END.
    GET NEXT {&browse-name}.
END.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

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
  FIND CURRENT Almmmatg NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN UNDO, RETURN 'ADM-ERROR'.
  
  DEFINE VARIABLE F-FACTOR     AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE F-PreAnt LIKE Almmmatg.PreBas  NO-UNDO.

  F-PreAnt = Almmmatg.PreBas.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      lcc_mayorista.CodCia = s-codcia
      lcc_mayorista.Dec__01 = DECIMAL(lcc_mayorista.DEC__01:SCREEN-VALUE IN BROWSE {&browse-name})
      lcc_mayorista.PreOfi = DECIMAL(lcc_mayorista.PreOfi:SCREEN-VALUE IN BROWSE {&browse-name}).
  /* ********************************************************************************* */
  /*  PRIMERA PARTE: Actualiza la lista de Precios A, B y C */
  /* ********************************************************************************* */
  F-Factor = 1.
  IF Almmmatg.UndA > "" THEN DO:
      FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
          AND  Almtconv.Codalter = Almmmatg.UndA
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
  END.
  /* ************************** */
  /* REGRABAMOS Precio de Lista */
  /* ************************** */
  ASSIGN
      lcc_mayorista.PreVta[1] = IF Almmmatg.Chr__02 = "T" THEN lcc_mayorista.PreVta[2] / F-FACTOR ELSE lcc_mayorista.PreVta[1].
  ASSIGN
      lcc_mayorista.Usuario = S-USER-ID.
  /* ************************** */
  /* RHC Limpiamos información en exceso */
  /* ************************** */
  IF TRUE <> (Almmmatg.UndC > '') THEN ASSIGN lcc_mayorista.MrgUti-C = 0 lcc_mayorista.Prevta[4] = 0.
  IF TRUE <> (Almmmatg.UndB > '') THEN ASSIGN lcc_mayorista.MrgUti-B = 0 lcc_mayorista.Prevta[3] = 0.
  IF TRUE <> (Almmmatg.UndA > '') THEN ASSIGN lcc_mayorista.MrgUti-A = 0 lcc_mayorista.Prevta[2] = 0.
  /* ****************************************************************************************************** */
  /* Control Margen de Utilidad */
  /* ****************************************************************************************************** */
  DEF VAR x-PreUni AS DECI NO-UNDO.
  IF lcc_mayorista.Prevta[2] > 0 THEN DO:
      x-PreUni = lcc_mayorista.PreVta[2].
      RUN Verifica-Margen (INPUT Almmmatg.CodMat, INPUT Almmmatg.UndA, INPUT x-PreUni, INPUT lcc_mayorista.MonVta, OUTPUT pError).
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          pError = 'Precio A:' + CHR(10) + pError + CHR(10) + 'No admitido'.
          UNDO, RETURN "ADM-ERROR".
      END.
      IF pError > '' THEN DO:
          pAlerta = 'Precio A:' + CHR(10) + pError.
          pError = ''.
      END.
  END.
  IF lcc_mayorista.Prevta[3] > 0 THEN DO:
      x-PreUni = lcc_mayorista.PreVta[3].
      RUN Verifica-Margen (INPUT Almmmatg.CodMat, INPUT Almmmatg.UndB, INPUT x-PreUni, INPUT lcc_mayorista.MonVta, OUTPUT pError).
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          pError = 'Precio B:' + CHR(10) + pError + CHR(10) + 'No admitido'.
          UNDO, RETURN "ADM-ERROR".
      END.
      IF pError > '' THEN DO:
          pAlerta = pAlerta + (IF TRUE <> (pAlerta > '') THEN '' ELSE CHR(10)) +
              'Precio B:' + CHR(10) + pError.
          pError = ''.
      END.
  END.
  IF lcc_mayorista.Prevta[4] > 0 THEN DO:
      x-PreUni = lcc_mayorista.PreVta[4].
      RUN Verifica-Margen (INPUT Almmmatg.CodMat, INPUT Almmmatg.UndC, INPUT x-PreUni, INPUT lcc_mayorista.MonVta, OUTPUT pError).
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          pAlerta = pAlerta + (IF TRUE <> (pAlerta > '') THEN '' ELSE CHR(10)) +
              'Precio C:' + CHR(10) + pError + CHR(10) + 'No admitido'.
          UNDO, RETURN "ADM-ERROR".
      END.
      IF pError > '' THEN DO:
          pAlerta = 'Precio C:' + CHR(10) + pError.
          pError = ''.
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
  DO WITH FRAME {&FRAME-NAME}:
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'YES' THEN lcc_mayorista.codmat:READ-ONLY IN BROWSE {&browse-name} = NO.
      ELSE lcc_mayorista.codmat:READ-ONLY IN BROWSE {&browse-name} = YES.
      ASSIGN
          lcc_mayorista.MonVta:READ-ONLY IN  BROWSE {&browse-name} = NO
          lcc_mayorista.Dec__01:READ-ONLY IN  BROWSE {&browse-name} = YES
          lcc_mayorista.PreOfi:READ-ONLY IN  BROWSE {&browse-name} = YES.
/*       IF Almmmatg.CHR__02 = "T" THEN                                               */
/*           ASSIGN lcc_mayorista.Prevta[1]:READ-ONLY IN BROWSE {&browse-name} = YES. */
/*       ELSE                                                                         */
/*           ASSIGN lcc_mayorista.Prevta[1]:READ-ONLY IN BROWSE {&browse-name} = NO.  */
      /*APPLY 'ENTRY':U TO lcc_mayorista.PreVta[2] IN BROWSE {&BROWSE-NAME}.*/
  END.

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
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-Linea:DELETE(1).
      COMBO-BOX-Linea:DELIMITER = '|'.
      COMBO-BOX-SubLinea:DELIMITER = '|'.
      COMBO-BOX-Linea = ''.
      FOR EACH Almtfami NO-LOCK WHERE Almtfami.CodCia = s-codcia
          AND LOOKUP(TRIM(Almtfami.codfam), s-Lineas-Validas) > 0:
          COMBO-BOX-Linea:ADD-LAST(Almtfami.codfam + ' - ' + Almtfami.desfam, Almtfami.codfam).
          IF TRUE <> (COMBO-BOX-Linea > '') THEN COMBO-BOX-Linea = Almtfami.codfam.
      END.
      FOR EACH Almsfami NO-LOCK WHERE Almsfami.codcia = s-codcia
          AND Almsfami.codfam = COMBO-BOX-Linea:
          COMBO-BOX-Sublinea:ADD-LAST(AlmSFami.subfam + " - " + AlmSFami.dessub, AlmSFami.subfam).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-de-Oficina B-table-Win 
PROCEDURE Precio-de-Oficina :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{pri/precio-de-oficina-tiendas.i &ListaMayorista="lcc_mayorista"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rechazar B-table-Win 
PROCEDURE Rechazar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE IMAGE IMAGE-1 FILENAME "IMG\tbldat.ico" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
    SKIP
    Fi-Mensaje NO-LABEL FONT 6
    SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
    SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
    BGCOLOR 15 FGCOLOR 0 
    TITLE "Procesando ..." FONT 7.

DEF VAR pMensaje AS CHAR NO-UNDO.

EMPTY TEMP-TABLE T-MATG.

GET FIRST {&browse-name}.
REPEAT WHILE AVAILABLE lcc_mayorista:
    CREATE T-MATG.
    BUFFER-COPY lcc_mayorista TO T-MATG.
    GET NEXT {&browse-name}.
END.

FOR EACH T-MATG:
    FIND lcc_mayorista WHERE lcc_mayorista.CodCia = T-MATG.codcia
        AND lcc_mayorista.codmat = T-MATG.codmat
        AND lcc_mayorista.FlgEst = "X" NO-LOCK NO-ERROR.
    IF NOT AVAILABLE lcc_mayorista THEN NEXT.
    DISPLAY "ARTICULO: " + T-MATG.CodMat @ Fi-Mensaje WITH FRAME F-Proceso.
    RUN Rechazar-Detalle (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    END.
END.
HIDE FRAME F-Proceso.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* *************************** */
PROCEDURE Rechazar-Detalle:
/* *************************** */

    DEF VAR F-PreAnt LIKE Almmmatg.PreBas NO-UNDO.
    DEF VAR f-PorIgv AS DECI NO-UNDO.

    DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    {lib/lock-genericov3.i &Tabla="lcc_mayorista" ~
        &Condicion="lcc_mayorista.CodCia = T-MATG.codcia ~
        AND lcc_mayorista.codmat = T-MATG.codmat ~
        AND lcc_mayorista.FlgEst = 'X'" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR NO-WAIT" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
    ASSIGN
        lcc_mayorista.DateUpdate = TODAY
        lcc_mayorista.HourUpdate = STRING(TIME,'HH:MM:SS')
        lcc_mayorista.UserUpdate = s-user-id
        lcc_mayorista.FlgEst = "P".     /* Regresar al Jefe de Línea */
    RELEASE lcc_mayorista.

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
  {src/adm/template/snd-list.i "lcc_mayorista"}
  {src/adm/template/snd-list.i "Almmmatg"}

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

    IF TRUE <> (lcc_mayorista.codmat:SCREEN-VALUE IN BROWSE {&browse-name} > '') THEN DO:
        MESSAGE 'NO puede dejar en blanco el código' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO lcc_mayorista.codmat.
        RETURN 'ADM-ERROR'.
    END.
    FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = lcc_mayorista.codmat:SCREEN-VALUE IN BROWSE {&browse-name} NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        MESSAGE 'Artículo NO registrado en el catálogo' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO lcc_mayorista.codmat.
        RETURN 'ADM-ERROR'.
    END.

    /* VALIDACION LISTA MAYORISTA LIMA */ 
    F-Factor = 1.                    
    IF Almmmatg.UndA <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
                       AND  Almtconv.Codalter = Almmmatg.UndA
                      NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
    END.
   CASE Almmmatg.Chr__02 :
        WHEN "T" THEN DO:        
            
        END.
        WHEN "P" THEN DO:
           IF (DECIMAL(lcc_mayorista.Prevta[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) * F-FACTOR ) < 
              (DECIMAL(lcc_mayorista.Prevta[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})) THEN DO:
              MESSAGE "Precio de lista Menor al Precio Venta A......" VIEW-AS ALERT-BOX ERROR.
              APPLY "ENTRY" TO lcc_mayorista.Prevta[1].
              RETURN "ADM-ERROR".      
           END.                         
        END. 
    END.    
    /* Ic - 12Dic2016, Validar el MARGEN DE UTILIDAD */
    FIND FIRST VtaTabla WHERE VtaTabla.codcia = s-codcia AND
        VtaTabla.tabla = 'MMLX' AND
        VtaTabla.llave_c1 = lcc_mayorista.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE vtatabla THEN DO:
        /* El Articulo no esta en la tabla de Excepcion de Margen de Utilidad */
        IF DECIMAL(lcc_mayorista.MrgUti-C:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) < 0 THEN DO:
           MESSAGE "Margen Utilidad C Negativo......" VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO lcc_mayorista.MrgUti-C.
           RETURN "ADM-ERROR".
        END.
        IF DECIMAL(lcc_mayorista.MrgUti-B:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) < 0 THEN DO:
           MESSAGE "Margen Utilidad B Negativo......" VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO lcc_mayorista.MrgUti-B.
           RETURN "ADM-ERROR".
        END.
        IF DECIMAL(lcc_mayorista.MrgUti-A:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) < 0 THEN DO:
           MESSAGE "Margen Utilidad A Negativo......" VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO lcc_mayorista.MrgUti-A.
           RETURN "ADM-ERROR".
        END.
        IF DECIMAL(lcc_mayorista.MrgUti-C:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > DECIMAL(lcc_mayorista.MrgUti-B:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) THEN DO:
           MESSAGE "Margen de util. C as mayor que el margen de util. B" SKIP
                 "Margen Utilidad Incorrecto......" VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO lcc_mayorista.MrgUti-C.
           RETURN "ADM-ERROR".
        END.
        IF DECIMAL(lcc_mayorista.MrgUti-B:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > DECIMAL(lcc_mayorista.MrgUti-A:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) THEN DO:
           MESSAGE "Margen de util. B as mayor que el margen de util. A" SKIP
                 "Margen Utilidad Incorrecto......" VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO lcc_mayorista.MrgUti-B.
           RETURN "ADM-ERROR".
        END.
    END.
    IF DECIMAL(lcc_mayorista.Monvta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
        MESSAGE "Codigo de Moneda Incorrecto......" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO lcc_mayorista.MonVta.
        RETURN "ADM-ERROR".      
    END.
    RETURN 'OK'.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Verifica-Margen B-table-Win 
PROCEDURE Verifica-Margen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER pCodMat AS CHAR.                                         
    DEF INPUT PARAMETER pUndVta AS CHAR.
    DEF INPUT PARAMETER pPreUni AS DECI.
    DEF INPUT PARAMETER pMonVta AS INTE.
    DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

    DEFINE VAR x-Margen AS DECI NO-UNDO.
    DEFINE VAR x-Limite AS DECI NO-UNDO.

    DEFINE VAR hProc AS HANDLE NO-UNDO.

    /* 1ro. Calculamos el margen de utilidad */
    RUN pri/pri-librerias PERSISTENT SET hProc.
    RUN PRI_Margen-Utilidad IN hProc (INPUT "",                                                     /* OJO */
                                      INPUT pCodMat,
                                      INPUT pUndVta,
                                      INPUT pPreUni,
                                      INPUT pMonVta,
                                      OUTPUT x-Margen,
                                      OUTPUT x-Limite,
                                      OUTPUT pError).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    /* Controlamos si el margen de utilidad está bajo a través de la variable pError */
    IF pError > '' THEN DO:
        /* Error por margen de utilidad */
        /* 2do. Verificamos si solo es una ALERTA, definido por GG */
        DEF VAR pAlerta AS LOG NO-UNDO.
        RUN PRI_Alerta-de-Margen IN hProc (INPUT lcc_mayorista.codmat:SCREEN-VALUE IN BROWSE {&browse-name}, OUTPUT pAlerta).
        IF pAlerta = NO THEN RETURN 'ADM-ERROR'.
    END.
    DELETE PROCEDURE hProc.
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCtoTot B-table-Win 
FUNCTION fCtoTot RETURNS DECIMAL
  ( INPUT pMonVta AS INTE, INPUT pCodMat AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF BUFFER B-MATG FOR Almmmatg.

  FIND B-MATG WHERE B-MATG.codcia = s-codcia AND B-MATG.codmat = pCodMat NO-LOCK NO-ERROR.
  IF NOT AVAILABLE B-MATG THEN RETURN 0.00.

  DEF VAR x-Importe AS DECI NO-UNDO.

  IF pMonVta = 1 THEN DO:
      IF B-MATG.MonVta = 1 THEN x-Importe = B-MATG.CtoTot.
      ELSE x-Importe = B-MATG.CtoTot * B-MATG.TpoCmb.
  END.
  ELSE DO:
      IF B-MATG.MonVta = 2 THEN x-Importe = B-MATG.CtoTot.
      ELSE x-Importe = B-MATG.CtoTot / B-MATG.TpoCmb.
  END.
  RETURN x-Importe.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCtoTotMarco B-table-Win 
FUNCTION fCtoTotMarco RETURNS DECIMAL
  ( INPUT pMonVta AS INTE, INPUT pCodMat AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF BUFFER B-MATG FOR Almmmatg.

  FIND B-MATG WHERE B-MATG.codcia = s-codcia AND B-MATG.codmat = pCodMat NO-LOCK NO-ERROR.
  IF NOT AVAILABLE B-MATG THEN RETURN 0.00.

  DEF VAR x-Importe AS DECI NO-UNDO.

  IF pMonVta = 1 THEN DO:
      IF B-MATG.MonVta = 1 THEN x-Importe = B-MATG.CtoTotMarco.
      ELSE x-Importe = B-MATG.CtoTotMarco * B-MATG.TpoCmb.
  END.
  ELSE DO:
      IF B-MATG.MonVta = 2 THEN x-Importe = B-MATG.CtoTotMarco.
      ELSE x-Importe = B-MATG.CtoTotMarco / B-MATG.TpoCmb.
  END.
  RETURN x-Importe.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

