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

/* Parameters Definitions ---                                           */
DEFINE SHARED VAR s-acceso-total  AS LOG NO-UNDO.

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR s-LineasValidas AS CHAR NO-UNDO.

/* &SCOPED-DEFINE Condicion Almmmatg.codcia = s-codcia ~                                          */
/* AND Almmmatg.TpoArt <> "D" ~                                                                   */
/* AND (COMBO-BOX-Linea = 'Todas' OR Almmmatg.codfam = ENTRY(1, COMBO-BOX-Linea, ' - ') ) ~       */
/* AND (COMBO-BOX-SubLinea = 'Todas' OR Almmmatg.subfam = ENTRY(1, COMBO-BOX-SubLinea, ' - ') ) ~ */
/* AND (FILL-IN-CodPro = "" OR Almmmatg.CodPr1 = FILL-IN-CodPro) ~                                */
/* AND (FILL-IN-DesMat = "" OR INDEX(Almmmatg.desmat, FILL-IN-DesMat) > 0)                        */

&SCOPED-DEFINE Condicion Almmmatg.codcia = s-codcia ~
AND Almmmatg.TpoArt <> "D" ~
AND LOOKUP(Almmmatg.codfam, s-LineasValidas) > 0 ~
AND (COMBO-BOX-Linea = 'Todas' OR Almmmatg.codfam = ENTRY(1, COMBO-BOX-Linea, ' - ') ) ~
AND (COMBO-BOX-SubLinea = 'Todas' OR Almmmatg.subfam = ENTRY(1, COMBO-BOX-SubLinea, ' - ') ) ~
AND (FILL-IN-CodPro = "" OR Almmmatg.CodPr1 = FILL-IN-CodPro) ~
AND (FILL-IN-DesMat = "" OR INDEX(Almmmatg.desmat, FILL-IN-DesMat) > 0)

DEFINE VARIABLE fmot LIKE T-MATG.PreOfi.
DEFINE VARIABLE pre-ofi LIKE T-MATG.PreOfi.
DEFINE VARIABLE MrgMin LIKE T-MATG.MrgUti-A.
DEFINE VARIABLE MrgOfi LIKE T-MATG.MrgUti-A.
DEFINE VARIABLE MaxCat LIKE ClfClie.PorDsc.
DEFINE VARIABLE MaxVta LIKE Dsctos.PorDto.
DEFINE VARIABLE F-FACTOR AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PreVta-A AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PreVta-B AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PreVta-C AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-MrgUti-A AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-MrgUti-B AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-MrgUti-C AS DECIMAL NO-UNDO.
DEFINE VARIABLE X-CTOUND AS DECIMAL NO-UNDO.
DEFINE VARIABLE X-CTOTOT AS DECIMAL FORMAT "->>>>>>>>>9.999999" NO-UNDO.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

/* DEFINE VAR x-PreUtilex AS DEC NO-UNDO.    */
/* DEFINE VAR x-MargenUtilex AS DEC NO-UNDO. */

DEF VAR x-MonCmp AS CHAR FORMAT 'x(10)' NO-UNDO.

DEF VAR pError AS CHAR NO-UNDO.
DEF VAR pAlerta AS CHAR NO-UNDO.

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
&Scoped-define INTERNAL-TABLES T-MATG Almmmatg AlmmmatgExt

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-MATG.codmat T-MATG.DesMat ~
T-MATG.UndStk T-MATG.DesMar AlmmmatgExt.CtoTot ~
( IF AlmmmatgExt.MonCmp = 1 THEN  'Soles'  ELSE 'Dolares' ) @ x-MonCmp ~
T-MATG.MonVta T-MATG.TpoCmb T-MATG.CtoTot T-MATG.CtoTotMarco ~
T-MATG.Prevta[1] T-MATG.MrgUti-A T-MATG.Prevta[2] T-MATG.UndA ~
T-MATG.MrgUti-B T-MATG.Prevta[3] T-MATG.UndB T-MATG.MrgUti-C ~
T-MATG.Prevta[4] T-MATG.UndC T-MATG.Dec__01 T-MATG.PreOfi T-MATG.Chr__01 ~
T-MATG.MrgAlt[1] T-MATG.PreAlt[1] T-MATG.UndAlt[1] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table T-MATG.MonVta ~
T-MATG.Prevta[1] T-MATG.MrgUti-A T-MATG.Prevta[2] T-MATG.MrgUti-B ~
T-MATG.Prevta[3] T-MATG.MrgUti-C T-MATG.Prevta[4] T-MATG.MrgAlt[1] ~
T-MATG.PreAlt[1] 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table T-MATG
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table T-MATG
&Scoped-define QUERY-STRING-br_table FOR EACH T-MATG WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg OF T-MATG NO-LOCK, ~
      FIRST AlmmmatgExt OF T-MATG NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-MATG WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg OF T-MATG NO-LOCK, ~
      FIRST AlmmmatgExt OF T-MATG NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table T-MATG Almmmatg AlmmmatgExt
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-MATG
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg
&Scoped-define THIRD-TABLE-IN-QUERY-br_table AlmmmatgExt


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Linea COMBO-BOX-Sublinea ~
FILL-IN-CodPro FILL-IN-CodMat FILL-IN-DesMat BUTTON-8 BUTTON-9 br_table 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Linea COMBO-BOX-Sublinea ~
FILL-IN-CodPro FILL-IN-NomPro FILL-IN-CodMat FILL-IN-DesMat 

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


/* ***********************  Control Definitions  ********************** */


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-br_table 
       MENU-ITEM m_LIMA_-_Descuento_Promociona LABEL "LIMA - Descuento Promocional"
       MENU-ITEM m_LIMA_-_Descuento_por_Volume2 LABEL "LIMA - Descuento por Volumen por Division"
       MENU-ITEM m_LIMA_-_Descuento_por_Volume LABEL "LIMA - Descuento por Volumen"
       MENU-ITEM m_UTILEX_-_Descuento_Promocio LABEL "UTILEX - Descuento Promocional"
       MENU-ITEM m_UTILEX_-_Descuento_por_Volu LABEL "UTILEX - Descuento por Volumen".


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-8 
     LABEL "APLICAR FILTRO" 
     SIZE 18 BY 1.12
     FONT 6.

DEFINE BUTTON BUTTON-9 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 9" 
     SIZE 6 BY 1.54.

DEFINE VARIABLE COMBO-BOX-Linea AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Linea" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEMS "TODAS" 
     DROP-DOWN-LIST
     SIZE 55 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Sublinea AS CHARACTER FORMAT "X(256)":U INITIAL "TODAS" 
     LABEL "Sublinea" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEMS "TODAS" 
     DROP-DOWN-LIST
     SIZE 55 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodMat AS CHARACTER FORMAT "X(13)":U 
     LABEL "Artículo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPro AS CHARACTER FORMAT "X(8)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesMat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Descripción" 
     VIEW-AS FILL-IN 
     SIZE 55 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-MATG, 
      Almmmatg, 
      AlmmmatgExt SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-MATG.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U WIDTH 6.43
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      T-MATG.DesMat FORMAT "X(60)":U WIDTH 42
      T-MATG.UndStk COLUMN-LABEL "Unidad" FORMAT "X(6)":U WIDTH 6.57
      T-MATG.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U
      AlmmmatgExt.CtoTot COLUMN-LABEL "Costo" FORMAT "->>>,>>9.9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 8
      ( IF AlmmmatgExt.MonCmp = 1 THEN  'Soles'  ELSE 'Dolares' ) @ x-MonCmp COLUMN-LABEL "Moneda!Compra"
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 8
      T-MATG.MonVta COLUMN-LABEL "Moneda!LP" FORMAT "9":U WIDTH 7.57
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 10 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "Soles",1,
                                      "Dolares",2
                      DROP-DOWN-LIST 
      T-MATG.TpoCmb COLUMN-LABEL "TC!Venta" FORMAT "Z9.9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 10
      T-MATG.CtoTot COLUMN-LABEL "Costo Total" FORMAT ">>>,>>9.9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      T-MATG.CtoTotMarco COLUMN-LABEL "Costo MARCO" FORMAT ">>>,>>9.9999":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 7
      T-MATG.Prevta[1] COLUMN-LABEL "Precio Lista" FORMAT ">>,>>>,>>9.9999":U
            WIDTH 9.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      T-MATG.MrgUti-A COLUMN-LABEL "% Uti A" FORMAT "->>,>>9.99":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      T-MATG.Prevta[2] COLUMN-LABEL "Precio A" FORMAT ">>>,>>9.9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      T-MATG.UndA COLUMN-LABEL "UM A" FORMAT "X(6)":U WIDTH 6.43
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      T-MATG.MrgUti-B COLUMN-LABEL "% Uti B" FORMAT "->>,>>9.99":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 13
      T-MATG.Prevta[3] COLUMN-LABEL "Precio B" FORMAT ">>>,>>9.9999":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 13
      T-MATG.UndB COLUMN-LABEL "UM B" FORMAT "X(6)":U WIDTH 6.43
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 13
      T-MATG.MrgUti-C COLUMN-LABEL "% Uti C" FORMAT "->>,>>9.99":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 1
      T-MATG.Prevta[4] COLUMN-LABEL "Precio C" FORMAT ">>>,>>9.9999":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 1
      T-MATG.UndC COLUMN-LABEL "UM C" FORMAT "X(6)":U WIDTH 6.57
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 1
      T-MATG.Dec__01 COLUMN-LABEL "% Uti Ofi" FORMAT "->>,>>9.99":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 12
      T-MATG.PreOfi FORMAT ">>>,>>9.9999":U COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 12
      T-MATG.Chr__01 COLUMN-LABEL "UM Ofic" FORMAT "X(6)":U COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 12
      T-MATG.MrgAlt[1] COLUMN-LABEL "UTILEX!% Uti" FORMAT "->>,>>9.99":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 2
      T-MATG.PreAlt[1] COLUMN-LABEL "UTILEX!Precio" FORMAT ">>>,>>9.9999":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 2
      T-MATG.UndAlt[1] COLUMN-LABEL "UTILEX!UM" FORMAT "x(6)":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 2
  ENABLE
      T-MATG.MonVta
      T-MATG.Prevta[1]
      T-MATG.MrgUti-A
      T-MATG.Prevta[2]
      T-MATG.MrgUti-B
      T-MATG.Prevta[3]
      T-MATG.MrgUti-C
      T-MATG.Prevta[4]
      T-MATG.MrgAlt[1]
      T-MATG.PreAlt[1]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 189 BY 20.96
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Linea AT ROW 1 COL 12 COLON-ALIGNED WIDGET-ID 2
     COMBO-BOX-Sublinea AT ROW 2.08 COL 12 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-CodPro AT ROW 1 COL 79 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-NomPro AT ROW 1 COL 91 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     FILL-IN-CodMat AT ROW 2.12 COL 79 COLON-ALIGNED WIDGET-ID 18
     FILL-IN-DesMat AT ROW 2.08 COL 99 COLON-ALIGNED WIDGET-ID 12
     BUTTON-8 AT ROW 1 COL 160 WIDGET-ID 10
     BUTTON-9 AT ROW 1 COL 181 WIDGET-ID 20
     br_table AT ROW 3.19 COL 1
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
         HEIGHT             = 24.23
         WIDTH              = 190.72.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
/* BROWSE-TAB br_table BUTTON-9 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-br_table:HANDLE
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 11.

/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.T-MATG,INTEGRAL.Almmmatg OF Temp-Tables.T-MATG,INTEGRAL.AlmmmatgExt OF Temp-Tables.T-MATG"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST, FIRST"
     _FldNameList[1]   > Temp-Tables.T-MATG.codmat
"T-MATG.codmat" "Articulo" ? "character" 14 0 ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-MATG.DesMat
"T-MATG.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "42" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-MATG.UndStk
"T-MATG.UndStk" "Unidad" "X(6)" "character" ? ? ? ? ? ? no ? no no "6.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-MATG.DesMar
"T-MATG.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.AlmmmatgExt.CtoTot
"AlmmmatgExt.CtoTot" "Costo" ? "decimal" 8 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"( IF AlmmmatgExt.MonCmp = 1 THEN  'Soles'  ELSE 'Dolares' ) @ x-MonCmp" "Moneda!Compra" ? ? 8 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-MATG.MonVta
"T-MATG.MonVta" "Moneda!LP" ? "integer" 10 0 ? ? ? ? yes ? no no "7.57" yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "Soles,1,Dolares,2" 5 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-MATG.TpoCmb
"T-MATG.TpoCmb" "TC!Venta" ? "decimal" 10 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-MATG.CtoTot
"T-MATG.CtoTot" "Costo Total" ">>>,>>9.9999" "decimal" 14 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.T-MATG.CtoTotMarco
"T-MATG.CtoTotMarco" "Costo MARCO" ">>>,>>9.9999" "decimal" 7 15 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.T-MATG.Prevta[1]
"T-MATG.Prevta[1]" "Precio Lista" ? "decimal" 14 0 ? ? ? ? yes ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.T-MATG.MrgUti-A
"T-MATG.MrgUti-A" "% Uti A" ? "decimal" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.T-MATG.Prevta[2]
"T-MATG.Prevta[2]" "Precio A" ">>>,>>9.9999" "decimal" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.T-MATG.UndA
"T-MATG.UndA" "UM A" "X(6)" "character" 11 0 ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.T-MATG.MrgUti-B
"T-MATG.MrgUti-B" "% Uti B" ? "decimal" 13 15 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.T-MATG.Prevta[3]
"T-MATG.Prevta[3]" "Precio B" ">>>,>>9.9999" "decimal" 13 15 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.T-MATG.UndB
"T-MATG.UndB" "UM B" "X(6)" "character" 13 15 ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.T-MATG.MrgUti-C
"T-MATG.MrgUti-C" "% Uti C" ? "decimal" 1 15 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > Temp-Tables.T-MATG.Prevta[4]
"T-MATG.Prevta[4]" "Precio C" ">>>,>>9.9999" "decimal" 1 15 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > Temp-Tables.T-MATG.UndC
"T-MATG.UndC" "UM C" "X(6)" "character" 1 15 ? ? ? ? no ? no no "6.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > Temp-Tables.T-MATG.Dec__01
"T-MATG.Dec__01" "% Uti Ofi" "->>,>>9.99" "decimal" 12 15 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > Temp-Tables.T-MATG.PreOfi
"T-MATG.PreOfi" ? ">>>,>>9.9999" "decimal" 12 15 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > Temp-Tables.T-MATG.Chr__01
"T-MATG.Chr__01" "UM Ofic" "X(6)" "character" 12 15 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[24]   > Temp-Tables.T-MATG.MrgAlt[1]
"T-MATG.MrgAlt[1]" "UTILEX!% Uti" ? "decimal" 2 15 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[25]   > Temp-Tables.T-MATG.PreAlt[1]
"T-MATG.PreAlt[1]" "UTILEX!Precio" ">>>,>>9.9999" "decimal" 2 15 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[26]   > Temp-Tables.T-MATG.UndAlt[1]
"T-MATG.UndAlt[1]" "UTILEX!UM" "x(6)" "character" 2 15 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME T-MATG.MonVta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.MonVta br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-MATG.MonVta IN BROWSE br_table /* Moneda!LP */
DO:
  /*APPLY 'LEAVE':U TO AlmmmatgExt.PrecioLista IN BROWSE {&browse-name}.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.Prevta[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.Prevta[1] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-MATG.Prevta[1] IN BROWSE br_table /* Precio Lista */
DO:
    RUN Precio-de-Oficina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.MrgUti-A
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.MrgUti-A br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-MATG.MrgUti-A IN BROWSE br_table /* % Uti A */
DO:
    ASSIGN
        F-MrgUti-A = DECIMAL(T-MATG.MrgUti-A:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
        X-CTOUND   = DECIMAL(T-MATG.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).

     F-FACTOR = 1.
     F-PreVta-A = 0.
     /****   Busca el Factor de conversion   ****/
     IF T-MATG.UndA <> "" THEN DO:
         FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas
             AND  Almtconv.Codalter = T-MATG.UndA
             NO-LOCK NO-ERROR.
         IF NOT AVAILABLE Almtconv THEN DO:
             MESSAGE "Codigo de unidad de CONVERSION no existe" VIEW-AS ALERT-BOX ERROR.
             RETURN NO-APPLY.
         END.
         F-FACTOR = Almtconv.Equival.
         F-PreVta-A = ROUND(( X-CTOUND * (1 + F-MrgUti-A / 100) ), 6) * F-FACTOR.
     END.

    DISPLAY F-PreVta-A @ Prevta[2] WITH BROWSE {&BROWSE-NAME}.

    RUN Precio-de-Oficina.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.Prevta[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.Prevta[2] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-MATG.Prevta[2] IN BROWSE br_table /* Precio A */
DO:
    ASSIGN
        F-PreVta-A = DECIMAL(T-MATG.Prevta[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
        X-CTOUND = DECIMAL(T-MATG.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).

    F-FACTOR = 1.
    F-MrgUti-A = 0.    
    /****   Busca el Factor de conversion   ****/
    IF T-MATG.UndA <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas
            AND  Almtconv.Codalter = T-MATG.UndA
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN DO:
            MESSAGE "Codigo de unidad de CONVERSION no existe" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        F-FACTOR = Almtconv.Equival.
        F-MrgUti-A = ROUND(((((F-PreVta-A / F-FACTOR) / X-CTOUND) - 1) * 100), 6).
    END.
    /*******************************************/
    DISPLAY F-MrgUti-A @ T-MATG.MrgUti-A WITH BROWSE {&BROWSE-NAME}.
    RUN Precio-de-Oficina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.MrgUti-B
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.MrgUti-B br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-MATG.MrgUti-B IN BROWSE br_table /* % Uti B */
DO:
    ASSIGN
        F-MrgUti-B = DECIMAL(T-MATG.MrgUti-B:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
        X-CTOUND   = DECIMAL(T-MATG.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).

     F-FACTOR = 1.
     F-Prevta-B = 0.
     /****   Busca el Factor de conversion   ****/
     IF T-MATG.UndB <> "" THEN DO:
         FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas
                        AND  Almtconv.Codalter = T-MATG.UndB
                       NO-LOCK NO-ERROR.
         IF NOT AVAILABLE Almtconv THEN DO:
            MESSAGE "Codigo de unidad de CONVERSION no exixte" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
         END.
         F-FACTOR = Almtconv.Equival.
         F-PreVta-B = ROUND(( X-CTOUND * (1 + F-MrgUti-B / 100) ), 6) * F-FACTOR.
     END.
    DISPLAY F-PreVta-B @ Prevta[3]
            WITH BROWSE {&BROWSE-NAME}.

    RUN Precio-de-Oficina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.Prevta[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.Prevta[3] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-MATG.Prevta[3] IN BROWSE br_table /* Precio B */
DO:
    ASSIGN
        F-PreVta-B = DECIMAL(T-MATG.Prevta[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
        X-CTOUND = DECIMAL(T-MATG.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).


     F-FACTOR = 1.
     F-MrgUti-B = 0.   
     /****   Busca el Factor de conversion   ****/
     IF T-MATG.UndB <> "" THEN DO:
         FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas
                        AND  Almtconv.Codalter = T-MATG.UndB
                       NO-LOCK NO-ERROR.
         IF NOT AVAILABLE Almtconv THEN DO:
            MESSAGE "Codigo de unidad de CONVERSION no existe" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
         END.
         F-FACTOR = Almtconv.Equival.
         F-MrgUti-B = ROUND(((((F-PreVta-B / F-FACTOR) / X-CTOUND) - 1) * 100), 6).
     END.
     /*******************************************/


     DISPLAY F-MrgUti-B @ T-MATG.MrgUti-B
             WITH BROWSE {&BROWSE-NAME}.

     RUN Precio-de-Oficina.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.MrgUti-C
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.MrgUti-C br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-MATG.MrgUti-C IN BROWSE br_table /* % Uti C */
DO:
    ASSIGN
        F-MrgUti-C = DECIMAL(T-MATG.MrgUti-C:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
        X-CTOUND   = DECIMAL(T-MATG.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).

     F-FACTOR = 1.
     F-Prevta-C = 0.
     /****   Busca el Factor de conversion   ****/
     IF T-MATG.UndC <> "" THEN DO:
         FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas
                        AND  Almtconv.Codalter = T-MATG.UndC
                       NO-LOCK NO-ERROR.
         IF NOT AVAILABLE Almtconv THEN DO:
            MESSAGE "Codigo de unidad de CONVERSION no exixte" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
         END.
         F-FACTOR = Almtconv.Equival.
         F-PreVta-C = ROUND(( X-CTOUND * (1 + F-MrgUti-C / 100) ), 6) * F-FACTOR.
     END.




    DISPLAY F-PreVta-C @ Prevta[4]
            WITH BROWSE {&BROWSE-NAME}.

    RUN Precio-de-Oficina.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.Prevta[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.Prevta[4] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-MATG.Prevta[4] IN BROWSE br_table /* Precio C */
DO:
    ASSIGN
        F-PreVta-C = DECIMAL(T-MATG.Prevta[4]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
        X-CTOUND = DECIMAL(T-MATG.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).

     F-FACTOR = 1.
     F-MrgUti-C = 0.
     /****   Busca el Factor de conversion   ****/
     IF T-MATG.UndC <> "" THEN DO:
         FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas
                        AND  Almtconv.Codalter = T-MATG.UndC
                       NO-LOCK NO-ERROR.
         IF NOT AVAILABLE Almtconv THEN DO:
            MESSAGE "Codigo de unidad de CONVERSION no exixte" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
         END.
         F-FACTOR = Almtconv.Equival.
         F-MrgUti-C = ROUND(((((F-PreVta-C / F-FACTOR) / X-CTOUND) - 1) * 100), 6).
     END.
     /*******************************************/


     DISPLAY F-MrgUti-C @ T-MATG.MrgUti-C
             WITH BROWSE {&BROWSE-NAME}.

     RUN Precio-de-Oficina.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.MrgAlt[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.MrgAlt[1] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-MATG.MrgAlt[1] IN BROWSE br_table /* UTILEX!% Uti */
DO:
    ASSIGN
        X-CTOUND   = DECIMAL(T-MATG.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
     F-FACTOR = 1.
     /****   Busca el Factor de conversion   ****/
     FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas
         AND  Almtconv.Codalter = T-MATG.CHR__01
         NO-LOCK NO-ERROR.
     IF NOT AVAILABLE Almtconv THEN RETURN.
     F-FACTOR = Almtconv.Equival.
     DISPLAY
         ROUND(( X-CTOUND * (1 + DECIMAL(SELF:SCREEN-VALUE) / 100) ), 6) * F-FACTOR @ T-MATG.PreAlt[1] 
         T-MATG.CHR__01 @ T-MATG.UndAlt[1]
         WITH BROWSE {&browse-name}.
/*      IF T-MATG.UndAlt[1]:SCREEN-VALUE IN BROWSE {&browse-name} <> "" THEN DO:                */
/*          FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas                                */
/*              AND  Almtconv.Codalter = T-MATG.UndAlt[1]:SCREEN-VALUE IN BROWSE {&browse-name} */
/*              NO-LOCK NO-ERROR.                                                               */
/*          IF NOT AVAILABLE Almtconv THEN RETURN.                                              */
/*          F-FACTOR = Almtconv.Equival.                                                        */
/*          DISPLAY                                                                             */
/*              ROUND(( X-CTOUND * (1 + DECIMAL(SELF:SCREEN-VALUE) / 100) ), 6) * F-FACTOR @    */
/*               T-MATG.PreAlt[1] WITH BROWSE {&browse-name}.                                   */
/*      END.                                                                                    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.PreAlt[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.PreAlt[1] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-MATG.PreAlt[1] IN BROWSE br_table /* UTILEX!Precio */
DO:
    ASSIGN
        X-CTOUND = DECIMAL(T-MATG.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
    F-FACTOR = 1.
    /****   Busca el Factor de conversion   ****/
    FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas
        AND  Almtconv.Codalter = T-MATG.CHR__01
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN RETURN.
    F-FACTOR = Almtconv.Equival.
    DISPLAY
        ROUND(((((DECIMAL(SELF:SCREEN-VALUE) / F-FACTOR) / X-CTOUND) - 1) * 100), 6) @ T-MATG.MrgAlt[1] 
        T-MATG.CHR__01 @ T-MATG.UndAlt[1]
        WITH BROWSE {&browse-name}.

/*     IF T-MATG.UndAlt[1]:SCREEN-VALUE IN BROWSE {&browse-name} <> "" THEN DO:                */
/*         FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas                                */
/*             AND  Almtconv.Codalter = T-MATG.UndAlt[1]:SCREEN-VALUE IN BROWSE {&browse-name} */
/*             NO-LOCK NO-ERROR.                                                               */
/*         IF NOT AVAILABLE Almtconv THEN RETURN.                                              */
/*         F-FACTOR = Almtconv.Equival.                                                        */
/*         DISPLAY                                                                             */
/*             ROUND(((((DECIMAL(SELF:SCREEN-VALUE) / F-FACTOR) / X-CTOUND) - 1) * 100), 6) @  */
/*             T-MATG.MrgAlt[1] WITH BROWSE {&BROWSE-NAME}.                                    */
/*     END.                                                                                    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.UndAlt[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.UndAlt[1] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-MATG.UndAlt[1] IN BROWSE br_table /* UTILEX!UM */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 B-table-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* APLICAR FILTRO */
DO:
   RUN Carga-Temporal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-9 B-table-Win
ON CHOOSE OF BUTTON-9 IN FRAME F-Main /* Button 9 */
DO:
   RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Linea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Linea B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Linea IN FRAME F-Main /* Linea */
DO:
  ASSIGN {&self-name}.
  COMBO-BOX-Sublinea:DELETE(COMBO-BOX-Sublinea:LIST-ITEMS).
  COMBO-BOX-Sublinea:ADD-LAST("TODAS").
  COMBO-BOX-Sublinea:SCREEN-VALUE = "TODAS".
  FOR EACH Almsfami NO-LOCK WHERE Almsfami.codcia = s-codcia
      AND Almsfami.codfam = ENTRY(1, COMBO-BOX-Linea, ' - ') :
      COMBO-BOX-Sublinea:ADD-LAST(AlmSFami.subfam + " - " + AlmSFami.dessub).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Sublinea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Sublinea B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Sublinea IN FRAME F-Main /* Sublinea */
DO:
  ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodMat B-table-Win
ON LEAVE OF FILL-IN-CodMat IN FRAME F-Main /* Artículo */
DO:
    ASSIGN {&self-name}.
    DEF VAR pCodMat AS CHAR.
    pCodMat = SELF:SCREEN-VALUE.
    IF pCodMat = '' THEN RETURN.
    ASSIGN
        pCodMat = STRING(INTEGER(pCodMat), '999999')
        NO-ERROR.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = pCodMat
        AND Almmmatg.tpoart <> 'D'
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        MESSAGE 'Artículo NO registrado o desactivado'
            VIEW-AS ALERT-BOX WARNING.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    SELF:SCREEN-VALUE = pCodMat.
    ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodPro B-table-Win
ON LEAVE OF FILL-IN-CodPro IN FRAME F-Main /* Proveedor */
DO:
  ASSIGN {&self-name}.
  FIND gn-prov WHERE gn-prov.codcia = pv-codcia
      AND gn-prov.codpro = {&self-name}
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN FILL-IN-NomPro = gn-prov.NomPro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-DesMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-DesMat B-table-Win
ON LEAVE OF FILL-IN-DesMat IN FRAME F-Main /* Descripción */
DO:
  ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_LIMA_-_Descuento_por_Volume
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_LIMA_-_Descuento_por_Volume B-table-Win
ON CHOOSE OF MENU-ITEM m_LIMA_-_Descuento_por_Volume /* LIMA - Descuento por Volumen */
DO:
    IF AVAILABLE Almmmatg THEN RUN pri/D-Lima-DtoVol-v2.r (Almmmatg.codmat).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_LIMA_-_Descuento_por_Volume2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_LIMA_-_Descuento_por_Volume2 B-table-Win
ON CHOOSE OF MENU-ITEM m_LIMA_-_Descuento_por_Volume2 /* LIMA - Descuento por Volumen por Division */
DO:
    IF AVAILABLE Almmmatg THEN RUN PRI/D-Lima-DctoVoldiv-v2.r (Almmmatg.codmat).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_LIMA_-_Descuento_Promociona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_LIMA_-_Descuento_Promociona B-table-Win
ON CHOOSE OF MENU-ITEM m_LIMA_-_Descuento_Promociona /* LIMA - Descuento Promocional */
DO:
  /*IF AVAILABLE Almmmatg THEN RUN Vta2/D-Lima-Dtopromv2 (Almmmatg.codmat).*/
  IF AVAILABLE Almmmatg THEN RUN pri/D-Lima-DctoProm-v2.r (Almmmatg.codmat).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_UTILEX_-_Descuento_por_Volu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_UTILEX_-_Descuento_por_Volu B-table-Win
ON CHOOSE OF MENU-ITEM m_UTILEX_-_Descuento_por_Volu /* UTILEX - Descuento por Volumen */
DO:
    FIND VtaListaMinGn OF T-MATG NO-LOCK NO-ERROR.
    IF AVAILABLE VtaListaMinGn THEN RUN pri/D-Utilex-DtoVol-v2.r (T-MATG.codmat).
    ELSE DO:
        MESSAGE 'Primero debe asignarle un PRECIO DE OFICINA UTILEX'
            VIEW-AS ALERT-BOX WARNING.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_UTILEX_-_Descuento_Promocio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_UTILEX_-_Descuento_Promocio B-table-Win
ON CHOOSE OF MENU-ITEM m_UTILEX_-_Descuento_Promocio /* UTILEX - Descuento Promocional */
DO:
    FIND VtaListaMinGn OF T-MATG NO-LOCK NO-ERROR.
    IF AVAILABLE VtaListaMinGn THEN RUN Pri/D-Utilex-DctoProm-v2.r (T-MATG.codmat).
    ELSE DO:
        MESSAGE 'Primero debe asignarle un PRECIO DE OFICINA UTILEX'
            VIEW-AS ALERT-BOX WARNING.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF T-MATG.MonVta, 
    T-MATG.MrgAlt[1], T-MATG.UndAlt[1], T-MATG.PreAlt[1], 
    T-MATG.MrgUti-A, T-MATG.MrgUti-B, T-MATG.MrgUti-C, 
    T-MATG.Prevta[1], T-MATG.Prevta[2], T-MATG.Prevta[3], T-MATG.Prevta[4],
    T-MATG.UndA,  T-MATG.UndB, T-MATG.UndC
DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-UTILEX B-table-Win 
PROCEDURE Actualiza-UTILEX :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-CtoTot AS DEC NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Primer Caso: Registrar información en Lista Minorista General */
    IF T-MATG.MrgAlt[1] = ? THEN T-MATG.MrgAlt[1] = 0.
    IF T-MATG.MrgAlt[1] > 0 OR T-MATG.PreAlt[1] > 0 THEN DO:
        FIND VtaListaMinGn OF T-MATG EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR THEN DO:
            IF LOCKED(VtaListaMinGn) THEN DO:
                RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
                UNDO, RETURN 'ADM-ERROR'.
            END.
            CREATE VtaListaMinGn.
            ASSIGN
                VtaListaMinGn.CodCia = T-MATG.codcia
                VtaListaMinGn.codmat = T-MATG.codmat
                VtaListaMinGn.FchIng = TODAY.
        END.
        ASSIGN
            VtaListaMinGn.Chr__01 = T-MATG.UndAlt[1]
            VtaListaMinGn.Dec__01 = T-MATG.MrgAlt[1]
            VtaListaMinGn.PreOfi  = T-MATG.PreAlt[1]
            VtaListaMinGn.FchAct  = TODAY
            VtaListaMinGn.usuario = s-user-id.
        /* Un solo tipo de cambio, una sola moneda */
        ASSIGN
            VtaListaMinGn.MonVta  = Almmmatg.MonVta
            VtaListaMinGn.TpoCmb  = Almmmatg.TpoCmb.
        /* REGRABAMOS EN LA MONEDA DE VENTA */
/*         IF Almmmatg.MonVta = 2 THEN                                         */
/*             ASSIGN                                                          */
/*             VtaListaMinGn.PreOfi  = VtaListaMinGn.PreOfi / Almmmatg.TpoCmb. */
        /* ****************************************************************************************************** */
        /* Control Margen de Utilidad */
        /* ****************************************************************************************************** */
        DEFINE VAR x-Margen AS DECI NO-UNDO.
        DEFINE VAR x-Limite AS DECI NO-UNDO.
        DEFINE VAR pError AS CHAR NO-UNDO.
        DEFINE VAR hProc AS HANDLE NO-UNDO.

        /* 1ro. Calculamos el margen de utilidad */
        RUN pri/pri-librerias PERSISTENT SET hProc.
        RUN PRI_Margen-Utilidad IN hProc (INPUT "",
                                          INPUT Almmmatg.CodMat,
                                          INPUT VtaListaMinGn.Chr__01,
                                          INPUT VtaListaMinGn.PreOfi,
                                          INPUT Almmmatg.MonVta,
                                          OUTPUT x-Margen,
                                          OUTPUT x-Limite,
                                          OUTPUT pError).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            MESSAGE 'Precio UTILEX' SKIP pError VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN 'ADM-ERROR'.
        END.
/*         /* RHC 05/01/2019 Margen de Utilidad Utilex */                         */
/*         DEF VAR x-Margen AS DEC NO-UNDO.                                       */
/*         DEF VAR x-Limite AS DEC NO-UNDO.                                       */
/*         DEF VAR pError AS CHAR NO-UNDO.                                        */
/*         RUN vtagn/p-margen-utilidad (                                          */
/*             Almmmatg.CodMat,                                                   */
/*             VtaListaMinGn.PreOfi,                                              */
/*             VtaListaMinGn.Chr__01,                                             */
/*             Almmmatg.MonVta,                      /* Moneda */                 */
/*             Almmmatg.TpoCmb,                                                   */
/*             YES,                     /* Muestra error? */                      */
/*             "",                     /* Almacén */                              */
/*             OUTPUT x-Margen,        /* Margen de utilidad */                   */
/*             OUTPUT x-Limite,        /* Margen mínimo de utilidad */            */
/*             OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */ */
/*             ).                                                                 */
/*         IF pError = 'ADM-ERROR' THEN DO:                                       */
/*             UNDO, RETURN 'ADM-ERROR'.                                          */
/*         END.                                                                   */
        ASSIGN                                          
            VtaListaMinGn.Dec__01 = x-Margen
            T-MATG.MrgAlt[1] = VtaListaMinGn.Dec__01.
        FIND CURRENT VtaListaMinGn NO-LOCK NO-ERROR.
    END.
    ELSE DO:
        FIND VtaListaMinGn OF T-MATG EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE VtaListaMinGn THEN DO:
            DELETE VtaListaMinGn.
        END.
        ASSIGN
            T-MATG.MrgAlt[1] = 0
            T-MATG.PreAlt[1] = 0
            T-MATG.UndAlt[1] = "".
    END.
    
END.
RETURN 'OK'.

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
PROCEDURE Carga-Temporal PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-MATG.

/* CASO DE SOLICITAR UN CODIGO ESPECÍFICO */
FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.TpoArt <> "D"
    AND Almmmatg.codMat = FILL-IN-CodMat
    NO-LOCK NO-ERROR.
IF AVAILABLE Almmmatg AND FILL-IN-CodMat > '' THEN DO:
    /* RHC 05/06/18 Restricciones de Lineas Autorizadas */
    IF LOOKUP(TRIM(Almmmatg.CodFam), s-LineasValidas) = 0 THEN DO:
        MESSAGE 'Producto NO pertenece a las líneas autorizadas para su usuario'
            VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO FILL-IN-CodMat IN FRAME {&FRAME-NAME}.
        RETURN.
    END.
    /* Limpiamos otros filtros */
    ASSIGN
        COMBO-BOX-Linea = 'TODAS'
        COMBO-BOX-Sublinea = 'TODAS'
        FILL-IN-CodPro = ''
        FILL-IN-DesMat = ''
        FILL-IN-NomPro = ''.
    DISPLAY
        COMBO-BOX-Linea COMBO-BOX-Sublinea FILL-IN-CodPro FILL-IN-DesMat FILL-IN-NomPro
        WITH FRAME {&FRAME-NAME}.
    EMPTY TEMP-TABLE T-MATG.
    CREATE T-MATG.
    BUFFER-COPY Almmmatg 
        EXCEPT Almmmatg.PreAlt Almmmatg.UndAlt Almmmatg.MrgAlt
        TO T-MATG.
END.
ELSE DO:
    FOR EACH Almmmatg NO-LOCK WHERE {&Condicion}:
        CREATE T-MATG.
        BUFFER-COPY Almmmatg 
            EXCEPT Almmmatg.PreAlt Almmmatg.UndAlt Almmmatg.MrgAlt
            TO T-MATG.
        FIND VtaListaMinGn OF Almmmatg NO-LOCK NO-ERROR.
        IF AVAILABLE VtaListaMinGn THEN
            ASSIGN
            T-MATG.UndAlt[1] = VtaListaMinGn.Chr__01 
            T-MATG.MrgAlt[1] = VtaListaMinGn.Dec__01
            T-MATG.PreAlt[1] = VtaListaMinGn.PreOfi.
    END.
END.
/* ************************************** */
FOR EACH T-MATG, FIRST Almmmatgext OF T-MATG NO-LOCK:
    FIND VtaListaMinGn OF T-MATG NO-LOCK NO-ERROR.
    IF AVAILABLE VtaListaMinGn THEN
        ASSIGN
        T-MATG.UndAlt[1] = VtaListaMinGn.Chr__01 
        T-MATG.MrgAlt[1] = VtaListaMinGn.Dec__01
        T-MATG.PreAlt[1] = VtaListaMinGn.PreOfi.
    FIND Almmmatp OF T-MATG NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatp THEN T-MATG.CtoTotMarco = almmmatp.CtoTot.
END.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

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

/* set the column names for the Worksheet */
DEF VAR x-CtoTot LIKE T-MATG.ctotot NO-UNDO.
DEF VAR x-PreVta LIKE T-MATG.prevta NO-UNDO.
DEF VAR x-PreOfi LIKE T-MATG.preofi NO-UNDO.

ASSIGN
    chWorkSheet:Range("A1"):Value = "CONTINENTAL - LISTA DE PRECIOS LIMA Y UTILEX"
    chWorkSheet:Range("A2"):Value = "ARTICULO"
    chWorkSheet:Columns("A"):NumberFormat = "@"
    chWorkSheet:Range("B2"):Value = "DESCRIPCION"
    chWorkSheet:Range("C2"):Value = "UNIDAD"
    chWorkSheet:Range("D2"):Value = "MONEDA"
    chWorkSheet:Range("E2"):Value = "TC"
    chWorkSheet:Range("F2"):Value = "MARCA"
    chWorkSheet:Range("G2"):Value = "COSTO TOTAL S/."
    chWorkSheet:Range("H2"):Value = "COSTO MARCO S/."
    chWorkSheet:Range("I2"):Value = "PRECIO LISTA S/."
    chWorkSheet:Range("J2"):Value = "%UTI A"
    chWorkSheet:Range("K2"):Value = "PRECIO A S/."
    chWorkSheet:Range("L2"):Value = "UM A"
    chWorkSheet:Range("M2"):Value = "%UTI B"
    chWorkSheet:Range("N2"):Value = "PRECIO B S/."
    chWorkSheet:Range("O2"):Value = "UM B"
    chWorkSheet:Range("P2"):Value = "%UTI C"
    chWorkSheet:Range("Q2"):Value = "PRECIO C S/."
    chWorkSheet:Range("R2"):Value = "UM C"
    chWorkSheet:Range("S2"):Value = "% UTI OFI"
    chWorkSheet:Range("T2"):Value = "PRECIO OFICINA S/."
    chWorkSheet:Range("U2"):Value = "UM OFIC"
    chWorkSheet:Range("V2"):Value = "UTILEX % UTI"
    chWorkSheet:Range("W2"):Value = "UTILEX PRECIO S/."
    chWorkSheet:Range("X2"):Value = "UTILEX UM"
    chWorkSheet:Range("Y2"):Value = "CLASIFICACION".

ASSIGN
    t-Row = 2.
GET FIRST {&browse-name}.
REPEAT WHILE AVAILABLE T-MATG:
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-MATG.codmat.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-MATG.desmat.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-MATG.undstk.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF T-MATG.monvta = 1 THEN 'S/.' ELSE 'US$').
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-MATG.tpocmb.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-MATG.desmar.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-MATG.ctotot.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-MATG.CtoTotMarco.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-MATG.Prevta[1].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-MATG.mrguti-a.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-MATG.Prevta[2].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-MATG.unda.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-MATG.mrguti-b.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-MATG.Prevta[3].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-MATG.undb.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-MATG.mrguti-c.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-MATG.Prevta[4].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-MATG.undc.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-MATG.Dec__01.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-MATG.PreOfi.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-MATG.CHR__01.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-MATG.MrgAlt[1].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-MATG.PreAlt[1].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-MATG.UndAlt[1].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-MATG.TipRot[1].
    GET NEXT {&browse-name}.
END.
chExcelApplication:VISIBLE = TRUE.
/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

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
  FIND CURRENT Almmmatg EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN UNDO, RETURN 'ADM-ERROR'.
    
  DEFINE VARIABLE F-FACTOR     AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE F-PreAnt LIKE Almmmatg.PreBas  NO-UNDO.

  F-PreAnt = Almmmatg.PreBas.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      T-MATG.Dec__01 = DECIMAL(T-MATG.DEC__01:SCREEN-VALUE IN BROWSE {&browse-name})
      T-MATG.PreOfi = DECIMAL(T-MATG.PreOfi:SCREEN-VALUE IN BROWSE {&browse-name}).
  IF T-MATG.MrgAlt[1] > 0 OR T-MATG.PreAlt[1] > 0 
      THEN T-MATG.UndAlt[1] = T-MATG.Chr__01.    /* <<< OJO <<< */
  ELSE T-MATG.UndAlt[1] = "".

  ASSIGN
      Almmmatg.PreVta[1] = T-MATG.PreVta[1]
      Almmmatg.PreVta[2] = T-MATG.Prevta[2]
      Almmmatg.PreVta[3] = T-MATG.Prevta[3]
      Almmmatg.PreVta[4] = T-MATG.Prevta[4]
      Almmmatg.MrgUti-A  = T-MATG.MrgUti-A
      Almmmatg.MrgUti-B  = T-MATG.MrgUti-B
      Almmmatg.MrgUti-C  = T-MATG.MrgUti-C
      Almmmatg.MonVta = T-MATG.MonVta
      Almmmatg.CtoUnd = T-MATG.CtoLis
      Almmmatg.Dec__01 = T-MATG.Dec__01
      Almmmatg.PreOfi = T-MATG.PreOfi.
  /* ********************************************************************************* */
  /* REGRABAMOS LOS COSTOS */
  /* ********************************************************************************* */
  IF Almmmatg.MonVta = AlmmmatgExt.MonCmp THEN
      ASSIGN
            Almmmatg.CtoLis = AlmmmatgExt.CtoLis
            Almmmatg.CtoTot = AlmmmatgExt.CtoTot.
  ELSE IF Almmmatg.MonVta = 1 THEN
      ASSIGN
            Almmmatg.CtoLis = AlmmmatgExt.CtoLis * Almmmatg.TpoCmb
            Almmmatg.CtoTot = AlmmmatgExt.CtoTot * Almmmatg.TpoCmb.
  ELSE ASSIGN
            Almmmatg.CtoLis = AlmmmatgExt.CtoLis / Almmmatg.TpoCmb
            Almmmatg.CtoTot = AlmmmatgExt.CtoTot / Almmmatg.TpoCmb.
  
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
      Almmmatg.PreVta[1] = IF Almmmatg.Chr__02 = "T" THEN Almmmatg.PreVta[2] / F-FACTOR ELSE Almmmatg.PreVta[1].
  /* ************************** */
  IF Almmmatg.AftIgv THEN Almmmatg.PreBas = ROUND(Almmmatg.PreVta[1] / ( 1 + FacCfgGn.PorIgv / 100), 6).
  Almmmatg.MrgUti = ((Almmmatg.Prevta[1] / Almmmatg.Ctotot) - 1 ) * 100. 
  /* ************************** */
  /* Actualizamos Margen */
  /* ************************** */
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
      Almmmatg.Usuario = S-USER-ID
      Almmmatg.FchAct  = TODAY.
  /* ************************** */
  /* RHC Limpiamos información en exceso */
  /* ************************** */
  IF TRUE <> (Almmmatg.UndC > '') THEN ASSIGN Almmmatg.MrgUti-C = 0 Almmmatg.Prevta[4] = 0.
  IF TRUE <> (Almmmatg.UndB > '') THEN ASSIGN Almmmatg.MrgUti-B = 0 Almmmatg.Prevta[3] = 0.
  IF TRUE <> (Almmmatg.UndA > '') THEN ASSIGN Almmmatg.MrgUti-A = 0 Almmmatg.Prevta[2] = 0.
  /* ************************** */
  /* REFLEJAMOS INFORMACION EN LA LISTA MINORISTA GENERAL UTILEX */
  /* ************************** */
  RUN Actualiza-UTILEX.
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      UNDO, RETURN 'ADM-ERROR'.
  END.
  /* Aqui se cuelga 03Nov2014 ??????  */
/*   FIND CURRENT Almmmatg NO-LOCK NO-ERROR.                                 */
/*   IF T-MATG.MonVta = 1 THEN ASSIGN T-MATG.Prevta[1] = Almmmatg.PreVta[1]. */
/*   ELSE ASSIGN T-MATG.Prevta[1] = Almmmatg.PreVta[1] * T-MATG.TpoCmb.      */

  /* ****************************************************************************************************** */
  /* Control Margen de Utilidad */
  /* ****************************************************************************************************** */
  DEF VAR x-PreUni AS DECI NO-UNDO.
  IF T-MATG.Prevta[2] > 0 THEN DO:
      x-PreUni = T-MATG.PreVta[2].
      RUN Verifica-Margen (INPUT T-MATG.CodMat, INPUT T-MATG.UndA, INPUT x-PreUni, INPUT T-MATG.MonVta, OUTPUT pError).
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          pError = 'Precio A:' + CHR(10) + pError + CHR(10) + 'No admitido'.
          UNDO, RETURN "ADM-ERROR".
      END.
      IF pError > '' THEN DO:
          pAlerta = 'Precio A:' + CHR(10) + pError.
          pError = ''.
      END.
  END.
  IF T-MATG.Prevta[3] > 0 THEN DO:
      x-PreUni = T-MATG.PreVta[3].
      RUN Verifica-Margen (INPUT T-MATG.CodMat, INPUT T-MATG.UndB, INPUT x-PreUni, INPUT T-MATG.MonVta, OUTPUT pError).
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
  IF T-MATG.Prevta[4] > 0 THEN DO:
      x-PreUni = T-MATG.PreVta[4].
      RUN Verifica-Margen (INPUT T-MATG.CodMat, INPUT T-MATG.UndC, INPUT x-PreUni, INPUT T-MATG.MonVta, OUTPUT pError).
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
  IF T-MATG.PreAlt[1] > 0 THEN DO:
      x-PreUni = T-MATG.PreAlt[1].
      RUN Verifica-Margen (INPUT T-MATG.CodMat, INPUT T-MATG.UndAlt[1], INPUT x-PreUni, INPUT T-MATG.MonVta, OUTPUT pError).
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          pError = 'Precio UTILEX:' + CHR(10) + pError + CHR(10) + 'No admitido'.
          UNDO, RETURN "ADM-ERROR".
      END.
      IF pError > '' THEN DO:
          pAlerta = pAlerta + (IF TRUE <> (pAlerta > '') THEN '' ELSE CHR(10)) +
              'Precio UTILEX:' + CHR(10) + pError.
          pError = ''.
      END.
  END.
  /* ****************************************************************************************************** */

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
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
      ASSIGN
          COMBO-BOX-Linea:SENSITIVE = YES
          COMBO-BOX-Sublinea:SENSITIVE = YES
          FILL-IN-CodPro:SENSITIVE = YES
          FILL-IN-DesMat:SENSITIVE = YES
          FILL-IN-CodMat:SENSITIVE = YES
          BUTTON-8:SENSITIVE = YES.
  END.

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
      ASSIGN
          COMBO-BOX-Linea:SENSITIVE = NO
          COMBO-BOX-Sublinea:SENSITIVE = NO
          FILL-IN-CodPro:SENSITIVE = NO
          FILL-IN-DesMat:SENSITIVE = NO
          FILL-IN-CodMat:SENSITIVE = NO
          BUTTON-8:SENSITIVE = NO.
      IF Almmmatg.CHR__02 = "T" 
          THEN 
          ASSIGN
          T-MATG.Prevta[1]:READ-ONLY IN BROWSE {&browse-name} = YES
          .
      ELSE
          ASSIGN
              T-MATG.Prevta[1]:READ-ONLY IN BROWSE {&browse-name} = NO
              .
    APPLY 'ENTRY':U TO T-MATG.PreVta[2] IN BROWSE {&BROWSE-NAME}.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      CASE TRUE:
      /* RHC 18/06/18 Si es solo consulta => solo lineas comerciales */
          WHEN s-Acceso-Total = NO THEN DO:
              FOR EACH Almtfami NO-LOCK WHERE Almtfami.CodCia = s-codcia AND Almtfami.SwComercial = YES:
                  COMBO-BOX-Linea:ADD-LAST( Almtfami.codfam + ' - ' + Almtfami.desfam).
                  s-LineasValidas = s-LineasValidas + (IF TRUE <> (s-LineasValidas > '') THEN '' ELSE ',') +
                      Almtfami.codfam.
              END.
          END.
          OTHERWISE DO:
              FOR EACH Vtatabla NO-LOCK WHERE Vtatabla.codcia = s-codcia
                  AND Vtatabla.tabla = "LP"
                  AND Vtatabla.llave_c1 = s-user-id,
                  FIRST Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia
                  AND Almtfami.codfam = Vtatabla.llave_c2:
                  COMBO-BOX-Linea:ADD-LAST( Almtfami.codfam + ' - ' + Almtfami.desfam).
                  s-LineasValidas = s-LineasValidas + (IF TRUE <> (s-LineasValidas > '') THEN '' ELSE ',') +
                      Almtfami.codfam.
              END.
          END.
      END CASE.
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
  DEF VAR x-Rowid AS ROWID NO-UNDO.
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  RUN Precio-de-Oficina.

  /* Dispatch standard ADM method.                             */
  pError = ''.
  pAlerta = ''.
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE pError VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN 'ADM-ERROR'.
  END.
  IF pAlerta > '' THEN MESSAGE pAlerta VIEW-AS ALERT-BOX WARNING.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Margen-de-Utilidad B-table-Win 
PROCEDURE Margen-de-Utilidad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pPreUni AS DEC.
DEF INPUT PARAMETER pUndVta AS CHAR.
DEF INPUT PARAMETER pTpoCmb AS DEC.
DEF OUTPUT PARAMETER x-Limite AS DEC.
DEF OUTPUT PARAMETER pError AS CHAR.


DEF VAR x-Margen AS DEC NO-UNDO.    /* Margen de utilidad */

pError = ''.

RUN vtagn/p-margen-utilidad-v2 (pCodDiv,
                                pCodMat,
                                pPreUni,
                                pUndVta,
                                1,                      /* Moneda */
                                pTpoCmb,
                                NO,                     /* Muestra error? */
                                "",                     /* Almacén */
                                OUTPUT x-Margen,        /* Margen de utilidad */
                                OUTPUT x-Limite,        /* Margen mínimo de utilidad */
                                OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
                                ).
IF RETURN-VALUE = 'ADM-ERROR' THEN pError = 'ADM-ERROR'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-de-oficina B-table-Win 
PROCEDURE Precio-de-oficina :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/precio-de-oficina-tiendas.i}

/* MaxCat = 0.                                                                                                                                                     */
/* MaxVta = 0.                                                                                                                                                     */
/* fmot   = 0.                                                                                                                                                     */
/* MrgMin = 5000.                                                                                                                                                  */
/* MrgOfi = 0.                                                                                                                                                     */
/* F-FACTOR = 1.                                                                                                                                                   */
/* MaxCat = 4.                                                                                                                                                     */
/* MaxVta = 3.                                                                                                                                                     */
/*                                                                                                                                                                 */
/* ASSIGN                                                                                                                                                          */
/*     F-MrgUti-A = DECIMAL(T-MATG.MrgUti-A:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})                                                                                 */
/*     F-PreVta-A = DECIMAL(T-MATG.Prevta[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})                                                                                */
/*     F-MrgUti-B = DECIMAL(T-MATG.MrgUti-B:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})                                                                                 */
/*     F-PreVta-B = DECIMAL(T-MATG.Prevta[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})                                                                                */
/*     F-MrgUti-C = DECIMAL(T-MATG.MrgUti-C:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})                                                                                 */
/*     F-PreVta-C = DECIMAL(T-MATG.Prevta[4]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).                                                                               */
/*                                                                                                                                                                 */
/* X-CTOUND = DECIMAL(T-MATG.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).                                                                                        */
/*                                                                                                                                                                 */
/* /****   Busca el Factor de conversion   ****/                                                                                                                   */
/* IF T-MATG.Chr__01 <> "" THEN DO:                                                                                                                                */
/*     FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas                                                                                                        */
/*         AND  Almtconv.Codalter = T-MATG.Chr__01                                                                                                                 */
/*         NO-LOCK NO-ERROR.                                                                                                                                       */
/*     IF NOT AVAILABLE Almtconv THEN DO:                                                                                                                          */
/*        MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.                                                                                            */
/*        RETURN.                                                                                                                                                  */
/*     END.                                                                                                                                                        */
/*     F-FACTOR = Almtconv.Equival.                                                                                                                                */
/* END.                                                                                                                                                            */
/* /*******************************************/                                                                                                                   */
/*                                                                                                                                                                 */
/* /* **********************************************************************                                                                                       */
/*     NOTA IMPORTANTE: Cualquier cambio debe hacerse también                                                                                                      */
/*                     en LOGISTICA -> LIsta de precios por proveedor                                                                                              */
/* ************************************************************************* */                                                                                    */
/*                                                                                                                                                                 */
/* CASE T-MATG.Chr__02 :                                                                                                                                           */
/*     WHEN "T" THEN DO:                                                                                                                                           */
/*         /*  TERCEROS  */                                                                                                                                        */
/*         IF F-MrgUti-A < MrgMin AND F-MrgUti-A <> 0 THEN MrgMin = F-MrgUti-A.                                                                                    */
/*         IF F-MrgUti-B < MrgMin AND F-MrgUti-B <> 0 THEN MrgMin = F-MrgUti-B.                                                                                    */
/*         IF F-MrgUti-C < MrgMin AND F-MrgUti-C <> 0 THEN MrgMin = F-MrgUti-C.                                                                                    */
/*                                                                                                                                                                 */
/*         fmot = (1 + MrgMin / 100) / ((1 - MaxCat / 100) * (1 - MaxVta / 100)).                                                                                  */
/*                                                                                                                                                                 */
/*         pre-ofi = X-CTOUND * fmot * F-FACTOR .                                                                                                                  */
/*                                                                                                                                                                 */
/*         MrgOfi = ROUND((fmot - 1) * 100, 6).                                                                                                                    */
/*                                                                                                                                                                 */
/*     END.                                                                                                                                                        */
/*     WHEN "P" THEN DO:                                                                                                                                           */
/*         /* PROPIOS */                                                                                                                                           */
/*        pre-ofi = DECIMAL(T-MATG.Prevta[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) * F-FACTOR.                                                                    */
/*        MrgOfi = ((DECIMAL(T-MATG.Prevta[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) / DECIMAL(T-MATG.Ctotot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} )) - 1 ) * 100. */
/*                                                                                                                                                                 */
/*     END.                                                                                                                                                        */
/* END.                                                                                                                                                            */
/*                                                                                                                                                                 */
/*                                                                                                                                                                 */
/* DO WITH FRAME {&FRAME-NAME}:                                                                                                                                    */
/*    DISPLAY                                                                                                                                                      */
/*        MrgOfi @ T-MATG.Dec__01                                                                                                                                  */
/*        pre-ofi @ T-MATG.PreOfi                                                                                                                                  */
/*        WITH BROWSE {&BROWSE-NAME}.                                                                                                                              */
/* END.                                                                                                                                                            */

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
  {src/adm/template/snd-list.i "T-MATG"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "AlmmmatgExt"}

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

  IF CAN-FIND(FIRST AlmmmatgExt WHERE AlmmmatgExt.CodCia = s-codcia
              AND AlmmmatgExt.FlagActualizacion = 1 NO-LOCK)
      THEN DO:
      MESSAGE 'Está pendiente el CALCULO MONEDA COSTO para este producto' SKIP
          'Realiza el cálculo y regrese a actualizar sus precios'
          VIEW-AS ALERT-BOX INFORMATION.
      APPLY "ENTRY" TO T-MATG.Prevta[2] IN BROWSE {&browse-name}.
      RETURN 'ADM-ERROR'.
  END.
                      
    /* VALIDACION LISTA MAYORISTA LIMA */ 
    F-Factor = 1.                    
    IF T-MATG.UndA <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas
                       AND  Almtconv.Codalter = T-MATG.UndA
                      NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
    END.

   CASE T-MATG.Chr__02 :
        WHEN "T" THEN DO:        
            
        END.
        WHEN "P" THEN DO:
           IF (DECIMAL(T-MATG.Prevta[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) * F-FACTOR ) < 
              (DECIMAL(T-MATG.Prevta[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})) THEN DO:
              MESSAGE "Precio de lista Menor al Precio Venta A......" VIEW-AS ALERT-BOX ERROR.
              APPLY "ENTRY" TO T-MATG.Prevta[1].
              RETURN "ADM-ERROR".      
           END.                         
        END. 
    END.    

    /* Ic - 12Dic2016, Validar el MARGEN DE UTILIDAD */
    FIND FIRST VtaTabla WHERE VtaTabla.codcia = s-codcia AND
        VtaTabla.tabla = 'MMLX' AND
        VtaTabla.llave_c1 = t-matg.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE vtatabla THEN DO:
        /* El Articulo no esta en la tabla de Excepcion de Margen de Utilidad */
        IF DECIMAL(T-MATG.MrgUti-C:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) < 0 THEN DO:
           MESSAGE "Margen Utilidad C Negativo......" VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO T-MATG.MrgUti-C.
           RETURN "ADM-ERROR".
        END.
        IF DECIMAL(T-MATG.MrgUti-B:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) < 0 THEN DO:
           MESSAGE "Margen Utilidad B Negativo......" VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO T-MATG.MrgUti-B.
           RETURN "ADM-ERROR".
        END.
        IF DECIMAL(T-MATG.MrgUti-A:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) < 0 THEN DO:
           MESSAGE "Margen Utilidad A Negativo......" VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO T-MATG.MrgUti-A.
           RETURN "ADM-ERROR".
        END.
        IF DECIMAL(T-MATG.MrgUti-C:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > DECIMAL(T-MATG.MrgUti-B:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) THEN DO:
           MESSAGE "Margen de util. C as mayor que el margen de util. B" SKIP
                 "Margen Utilidad Incorrecto......" VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO T-MATG.MrgUti-C.
           RETURN "ADM-ERROR".
        END.
        IF DECIMAL(T-MATG.MrgUti-B:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > DECIMAL(T-MATG.MrgUti-A:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) THEN DO:
           MESSAGE "Margen de util. B as mayor que el margen de util. A" SKIP
                 "Margen Utilidad Incorrecto......" VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO T-MATG.MrgUti-B.
           RETURN "ADM-ERROR".
        END.
    END.
    IF DECIMAL(T-MATG.Monvta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
        MESSAGE "Codigo de Moneda Incorrecto......" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO T-MATG.MonVta.
        RETURN "ADM-ERROR".      
    END.
    /* VALIDACION LISTA MINORISTA UTILEX */
    DEF VAR x-Limite AS DEC NO-UNDO.
    DEF VAR pError AS CHAR NO-UNDO.
    IF DECIMAL(T-MATG.MrgAlt[1]:SCREEN-VALUE IN BROWSE {&browse-name}) > 0
        OR DECIMAL(T-MATG.PreAlt[1]:SCREEN-VALUE IN BROWSE {&browse-name}) > 0
        THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid  = T-MATG.UndBas 
            AND Almtconv.Codalter = T-MATG.UndAlt[1]:SCREEN-VALUE IN BROWSE {&browse-name}
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN DO:
           MESSAGE "Equivalencia UTILEX NO definida" SKIP
               "Unidad base :" T-MATG.undbas SKIP
               "Unidad venta:" T-MATG.UndAlt[1]:SCREEN-VALUE IN BROWSE {&browse-name}
               VIEW-AS ALERT-BOX ERROR.
           APPLY 'entry' TO T-MATG.UndAlt[1] IN BROWSE {&browse-name}.
           RETURN "ADM-ERROR".
        END.
        IF DECIMAL(T-MATG.PreAlt[1]:SCREEN-VALUE IN BROWSE {&Browse-name}) = 0 THEN DO:
           MESSAGE 'Debe ingresar el precio de venta UTILEX'
               VIEW-AS ALERT-BOX ERROR.
           APPLY 'entry' TO T-MATG.PreAlt[1] IN BROWSE {&browse-name}.
           RETURN "ADM-ERROR".
        END.
    END.
/*     /* ****************************************************************************************************** */          */
/*     /* Control Margen de Utilidad */                                                                                      */
/*     /* ****************************************************************************************************** */          */
/*     DEF VAR x-PreUni AS DECI NO-UNDO.                                                                                     */
/*     IF DECIMAL(T-MATG.Prevta[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > 0 THEN DO:                                       */
/*         F-Factor = 1.                                                                                                     */
/*         FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas AND Almtconv.Codalter = T-MATG.UndA NO-LOCK NO-ERROR.        */
/*         IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.                                                           */
/*         x-PreUni = DECIMAL(T-MATG.PreVta[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) / f-Factor.                            */
/*         RUN Verifica-Margen (INPUT x-PreUni, OUTPUT pError).                                                              */
/*         IF RETURN-VALUE = 'ADM-ERROR' THEN DO:                                                                            */
/*             MESSAGE 'Precio A:' SKIP(1) pError SKIP 'No admitido' VIEW-AS ALERT-BOX ERROR TITLE 'CONTROL DE MARGEN'.      */
/*             APPLY 'ENTRY':U TO T-MATG.PreVta[2] IN BROWSE {&browse-name}.                                                 */
/*             RETURN "ADM-ERROR".                                                                                           */
/*         END.                                                                                                              */
/*         IF pError > '' THEN MESSAGE 'Precio A:' SKIP(1) pError VIEW-AS ALERT-BOX WARNING TITLE 'CONTROL DE MARGEN'.       */
/*     END.                                                                                                                  */
/*     IF DECIMAL(T-MATG.Prevta[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > 0 THEN DO:                                       */
/*         F-Factor = 1.                                                                                                     */
/*         FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas AND Almtconv.Codalter = T-MATG.UndB NO-LOCK NO-ERROR.        */
/*         IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.                                                           */
/*         x-PreUni = DECIMAL(T-MATG.PreVta[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) / f-Factor.                            */
/*         RUN Verifica-Margen (INPUT x-PreUni, OUTPUT pError).                                                              */
/*         IF RETURN-VALUE = 'ADM-ERROR' THEN DO:                                                                            */
/*             MESSAGE 'Precio B:' SKIP(1) pError SKIP 'No admitido' VIEW-AS ALERT-BOX ERROR TITLE 'CONTROL DE MARGEN'.      */
/*             APPLY 'ENTRY':U TO T-MATG.PreVta[3] IN BROWSE {&browse-name}.                                                 */
/*             RETURN "ADM-ERROR".                                                                                           */
/*         END.                                                                                                              */
/*         IF pError > '' THEN MESSAGE 'Precio B:' SKIP(1) pError VIEW-AS ALERT-BOX WARNING TITLE 'CONTROL DE MARGEN'.       */
/*     END.                                                                                                                  */
/*     IF DECIMAL(T-MATG.Prevta[4]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > 0 THEN DO:                                       */
/*         F-Factor = 1.                                                                                                     */
/*         FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas AND Almtconv.Codalter = T-MATG.UndC NO-LOCK NO-ERROR.        */
/*         IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.                                                           */
/*         x-PreUni = DECIMAL(T-MATG.PreVta[4]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) / f-Factor.                            */
/*         RUN Verifica-Margen (INPUT x-PreUni, OUTPUT pError).                                                              */
/*         IF RETURN-VALUE = 'ADM-ERROR' THEN DO:                                                                            */
/*             MESSAGE 'Precio C:' SKIP(1) pError SKIP 'No admitido' VIEW-AS ALERT-BOX ERROR TITLE 'CONTROL DE MARGEN'.      */
/*             APPLY 'ENTRY':U TO T-MATG.PreVta[4] IN BROWSE {&browse-name}.                                                 */
/*             RETURN "ADM-ERROR".                                                                                           */
/*         END.                                                                                                              */
/*         IF pError > '' THEN MESSAGE 'Precio C:' SKIP(1) pError VIEW-AS ALERT-BOX WARNING TITLE 'CONTROL DE MARGEN'.       */
/*     END.                                                                                                                  */
/*     IF DECIMAL(T-MATG.PreAlt[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > 0 THEN DO:                                       */
/*         F-Factor = 1.                                                                                                     */
/*         FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas AND Almtconv.Codalter = T-MATG.UndAlt[1] NO-LOCK NO-ERROR.   */
/*         IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.                                                           */
/*         x-PreUni = DECIMAL(T-MATG.PreAlt[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) / f-Factor.                            */
/*         RUN Verifica-Margen (INPUT x-PreUni, OUTPUT pError).                                                              */
/*         IF RETURN-VALUE = 'ADM-ERROR' THEN DO:                                                                            */
/*             MESSAGE 'Precio UTILEX:' SKIP(1) pError SKIP 'No admitido' VIEW-AS ALERT-BOX ERROR TITLE 'CONTROL DE MARGEN'. */
/*             APPLY 'ENTRY':U TO T-MATG.PreAlt[1] IN BROWSE {&browse-name}.                                                 */
/*             RETURN "ADM-ERROR".                                                                                           */
/*         END.                                                                                                              */
/*         IF pError > '' THEN MESSAGE 'Precio UTILEX:' SKIP(1) pError VIEW-AS ALERT-BOX WARNING TITLE 'CONTROL DE MARGEN'.  */
/*     END.                                                                                                                  */
/*     /* ****************************************************************************************************** */          */
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
IF s-acceso-total = NO THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
IF AVAILABLE Almmmatg AND Almmmatg.MonVta = 0 THEN DO:
    MESSAGE 'OJO: No está definida la moneda de venta' SKIP
        'Proceso Abortado' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.
/* x-PreUtilex = T-MATG.PreAlt[1].    */
/* x-MargenUtilex = T-MATG.MrgAlt[1]. */

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
        RUN PRI_Alerta-de-Margen IN hProc (INPUT T-MATG.codmat:SCREEN-VALUE IN BROWSE {&browse-name}, OUTPUT pAlerta).
        IF pAlerta = NO THEN RETURN 'ADM-ERROR'.
    END.
    DELETE PROCEDURE hProc.
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

