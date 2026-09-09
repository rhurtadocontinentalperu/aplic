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

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR pv-codcia AS INT.
/*DEF SHARED VAR s-coddiv AS CHAR.*/

DEFINE SHARED VAR s-acceso-total  AS LOG INIT YES NO-UNDO.

DEFINE SHARED VAR s-CanalVenta AS CHAR.

/* AND Almmmatg.TpoArt <> "D" ~ */
&SCOPED-DEFINE Condicion Almmmatg.codcia = s-codcia ~
AND (COMBO-BOX-Linea = 'Todas' OR Almmmatg.codfam = ENTRY(1, COMBO-BOX-Linea, ' - ') ) ~
AND (COMBO-BOX-SubLinea = 'Todas' OR Almmmatg.subfam = ENTRY(1, COMBO-BOX-SubLinea, ' - ') ) ~
AND (FILL-IN-CodPro = "" OR Almmmatg.CodPr1 = FILL-IN-CodPro) ~
AND (FILL-IN-DesMat = "" OR INDEX(Almmmatg.desmat, FILL-IN-DesMat) > 0)

DEF VAR s-local-adm-record AS LOG NO-UNDO.
/* DEF VAR x-Margen AS DEC NO-UNDO.  */
DEF VAR x-MonCmp AS CHAR NO-UNDO.
/* DEF VAR x-MonVta AS CHAR NO-UNDO. */

DEF VAR F-MrgUti AS DEC NO-UNDO.
DEF VAR X-CTOUND AS DEC NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.
DEF VAR F-PreVta AS DEC NO-UNDO.

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
&Scoped-define INTERNAL-TABLES T-MATG Almmmatg VtaListaMay

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-MATG.codmat Almmmatg.DesMat ~
Almmmatg.UndStk fMonVta(Almmmatg.MonVta) @ x-MonCmp Almmmatg.TpoCmb ~
Almmmatg.DesMar T-MATG.CtoTot T-MATG.Chr__01 T-MATG.Dec__01 T-MATG.PreOfi ~
T-MATG.PreBas T-MATG.Orden 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table T-MATG.codmat ~
T-MATG.Dec__01 T-MATG.PreOfi T-MATG.Orden 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table T-MATG
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table T-MATG
&Scoped-define QUERY-STRING-br_table FOR EACH T-MATG WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg OF T-MATG NO-LOCK, ~
      FIRST VtaListaMay OF T-MATG ~
      WHERE VtaListaMay.CodDiv = COMBO-BOX-Division NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-MATG WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg OF T-MATG NO-LOCK, ~
      FIRST VtaListaMay OF T-MATG ~
      WHERE VtaListaMay.CodDiv = COMBO-BOX-Division NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table T-MATG Almmmatg VtaListaMay
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-MATG
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg
&Scoped-define THIRD-TABLE-IN-QUERY-br_table VtaListaMay


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Division BUTTON-9 BUTTON-8 ~
COMBO-BOX-Linea COMBO-BOX-Sublinea FILL-IN-CodMat FILL-IN-CodPro ~
FILL-IN-DesMat br_table 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Division COMBO-BOX-Linea ~
COMBO-BOX-Sublinea FILL-IN-CodMat FILL-IN-CodPro FILL-IN-NomPro ~
FILL-IN-DesMat 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fMonVta B-table-Win 
FUNCTION fMonVta RETURNS CHARACTER
  ( INPUT pMonVta AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-br_table 
       MENU-ITEM m_Descuento_Promocional LABEL "Descuento Promocional"
       MENU-ITEM m_Descuento_por_Volumen LABEL "Descuento por Volumen".


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-8 
     LABEL "APLICAR FILTRO" 
     SIZE 18 BY 1.12
     FONT 6.

DEFINE BUTTON BUTTON-9 
     LABEL "CAMBIAR DIVISION" 
     SIZE 15 BY .77.

DEFINE VARIABLE COMBO-BOX-Division AS CHARACTER FORMAT "X(256)":U 
     LABEL "División" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 55 BY 1 NO-UNDO.

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
      VtaListaMay SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-MATG.codmat COLUMN-LABEL "Articulo" FORMAT "X(13)":U WIDTH 6.43
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 46
      Almmmatg.UndStk COLUMN-LABEL "Unidad" FORMAT "X(6)":U WIDTH 6.43
      fMonVta(Almmmatg.MonVta) @ x-MonCmp COLUMN-LABEL "Moneda" FORMAT "x(3)":U
      Almmmatg.TpoCmb COLUMN-LABEL "TC" FORMAT "Z9.9999":U
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U
      T-MATG.CtoTot COLUMN-LABEL "Costo Total!S/." FORMAT ">>>,>>9.9999":U
      T-MATG.Chr__01 COLUMN-LABEL "UM Ofic" FORMAT "X(6)":U COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 12
      T-MATG.Dec__01 COLUMN-LABEL "% Uti Ofi" FORMAT "->>>,>>9.9999":U
            WIDTH 6.86 COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 12
      T-MATG.PreOfi COLUMN-LABEL "Precio Oficina!S/." FORMAT ">>>,>>9.9999":U
            WIDTH 11.29 COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 12
      T-MATG.PreBas COLUMN-LABEL "Precio Oficina!US$" FORMAT ">>>,>>9.9999":U
      T-MATG.Orden COLUMN-LABEL "Config. de Desctos." FORMAT "9":U
            WIDTH 13.72 COLUMN-FONT 4 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "Normal",0,
                                      "Sin Descuentos",1
                      DROP-DOWN-LIST 
  ENABLE
      T-MATG.codmat
      T-MATG.Dec__01
      T-MATG.PreOfi
      T-MATG.Orden
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 152 BY 19.62
         FONT 4 ROW-HEIGHT-CHARS .42 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Division AT ROW 1.19 COL 12 COLON-ALIGNED WIDGET-ID 32
     BUTTON-9 AT ROW 1.19 COL 69 WIDGET-ID 34
     BUTTON-8 AT ROW 1.19 COL 124 WIDGET-ID 20
     COMBO-BOX-Linea AT ROW 2.15 COL 12 COLON-ALIGNED WIDGET-ID 22
     COMBO-BOX-Sublinea AT ROW 3.12 COL 12 COLON-ALIGNED WIDGET-ID 24
     FILL-IN-CodMat AT ROW 3.12 COL 79 COLON-ALIGNED WIDGET-ID 18
     FILL-IN-CodPro AT ROW 4.08 COL 12 COLON-ALIGNED WIDGET-ID 26
     FILL-IN-NomPro AT ROW 4.08 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     FILL-IN-DesMat AT ROW 4.08 COL 79 COLON-ALIGNED WIDGET-ID 28
     br_table AT ROW 5.23 COL 1
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
         HEIGHT             = 25.31
         WIDTH              = 169.43.
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
       br_table:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-br_table:HANDLE
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 5.

/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.T-MATG,INTEGRAL.Almmmatg OF Temp-Tables.T-MATG,INTEGRAL.VtaListaMay OF Temp-Tables.T-MATG"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST, FIRST"
     _Where[3]         = "INTEGRAL.VtaListaMay.CodDiv = COMBO-BOX-Division"
     _FldNameList[1]   > Temp-Tables.T-MATG.codmat
"Temp-Tables.T-MATG.codmat" "Articulo" "X(13)" "character" 14 0 ? ? ? ? yes ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"INTEGRAL.Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "46" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.UndStk
"INTEGRAL.Almmmatg.UndStk" "Unidad" "X(6)" "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fMonVta(Almmmatg.MonVta) @ x-MonCmp" "Moneda" "x(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.Almmmatg.TpoCmb
"INTEGRAL.Almmmatg.TpoCmb" "TC" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.Almmmatg.DesMar
"INTEGRAL.Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-MATG.CtoTot
"Temp-Tables.T-MATG.CtoTot" "Costo Total!S/." ">>>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-MATG.Chr__01
"Temp-Tables.T-MATG.Chr__01" "UM Ofic" "X(6)" "character" 12 15 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-MATG.Dec__01
"Temp-Tables.T-MATG.Dec__01" "% Uti Ofi" "->>>,>>9.9999" "decimal" 12 15 ? ? ? ? yes ? no no "6.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.T-MATG.PreOfi
"Temp-Tables.T-MATG.PreOfi" "Precio Oficina!S/." ">>>,>>9.9999" "decimal" 12 15 ? ? ? ? yes ? no no "11.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.T-MATG.PreBas
"Temp-Tables.T-MATG.PreBas" "Precio Oficina!US$" ">>>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.T-MATG.Orden
"Temp-Tables.T-MATG.Orden" "Config. de Desctos." "9" "integer" ? ? 4 ? ? ? yes ? no no "11.72" yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "Normal,0,Sin Descuentos,1" 5 no 0 no no
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


&Scoped-define SELF-NAME T-MATG.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-MATG.codmat IN BROWSE br_table /* Articulo */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    IF s-local-adm-record = NO THEN RETURN.
    DEF VAR pCodMat AS CHAR.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vtagn/p-codbrr-01 (INPUT-OUTPUT pCodMat).
    IF pCodMat = '' THEN RETURN NO-APPLY.
    SELF:SCREEN-VALUE = pCodMat.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = SELF:SCREEN-VALUE NO-LOCK.
    DISPLAY
        fMonVta(Almmmatg.monvta) @ x-MonCmp
        almmmatg.tpocmb
        almmmatg.ctotot @ T-MATG.ctotot
        almmmatg.desmat
        almmmatg.desmar
        almmmatg.undstk
        WITH BROWSE {&browse-name}.
    IF Almmmatg.monvta = 2 THEN
        DISPLAY 
        Almmmatg.CtoTot * Almmmatg.TpoCmb @ T-MATG.CtoTot 
        WITH BROWSE {&browse-name}.

    /* VALORES POR DEFECTO */
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' THEN DO:
        DISPLAY
            almmmatg.UndBas @ T-MATG.Chr__01
            WITH BROWSE {&browse-name}.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.Dec__01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.Dec__01 br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-MATG.Dec__01 IN BROWSE br_table /* % Uti Ofi */
DO:
    ASSIGN
        F-MrgUti = DECIMAL(T-MATG.DEC__01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
        X-CTOUND = DECIMAL(T-MATG.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
    IF F-MrgUti <= 0 THEN RETURN.
    F-FACTOR = 1.
    F-PreVta = 0.
    /****   Busca el Factor de conversion   ****/
    FIND FIRST Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
        AND  Almtconv.Codalter = T-MATG.CHR__01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv OR Almtconv.Equival <= 0 THEN DO:
        MESSAGE "Error en el factor de equivalencia " VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    F-FACTOR = Almtconv.Equival.
    F-PreVta = ROUND(( X-CTOUND * (1 + F-MrgUti / 100) ), 6) * F-FACTOR.
    RUN lib/RedondearMas ( F-PreVta, 4, OUTPUT F-PreVta).
    DISPLAY F-PreVta @ T-MATG.PreOfi WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.PreOfi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.PreOfi br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-MATG.PreOfi IN BROWSE br_table /* Precio Oficina!S/. */
DO:
    ASSIGN
        F-PreVta = DECIMAL(T-MATG.PreOfi:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
        X-CTOUND = DECIMAL(T-MATG.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
    F-FACTOR = 1.
    F-MrgUti = 0.    
    /****   Busca el Factor de conversion   ****/
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = T-MATG.codmat:SCREEN-VALUE NO-LOCK.
    FIND FIRST Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
        AND  Almtconv.Codalter = T-MATG.CHR__01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    F-FACTOR = Almtconv.Equival.
    F-MrgUti = ROUND(((((F-PreVta / F-FACTOR) / X-CTOUND) - 1) * 100), 6).
    /*******************************************/
    DISPLAY F-MrgUti @ T-MATG.Dec__01 WITH BROWSE {&BROWSE-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 B-table-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* APLICAR FILTRO */
DO:
    COMBO-BOX-Division:SENSITIVE = NO.
   RUN Carga-Temporal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-9 B-table-Win
ON CHOOSE OF BUTTON-9 IN FRAME F-Main /* CAMBIAR DIVISION */
DO:
  COMBO-BOX-Division:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Division B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Division IN FRAME F-Main /* División */
DO:
  ASSIGN {&self-name}.
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
/*         AND Almmmatg.tpoart <> 'D' */
        NO-LOCK NO-ERROR.
    FIND FIRST VtaListaMay WHERE VtaListaMay.codcia = s-codcia
        AND VtaListaMay.codmat = pCodMat
        AND VtaListaMay.CodDiv = COMBO-BOX-Division
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg OR NOT AVAILABLE VtaListaMay THEN DO:
        MESSAGE 'Artículo NO registrado en la lista'
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


&Scoped-define SELF-NAME m_Descuento_por_Volumen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Descuento_por_Volumen B-table-Win
ON CHOOSE OF MENU-ITEM m_Descuento_por_Volumen /* Descuento por Volumen */
DO:
    IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN
        RUN vta2/d-xdivision-dtovol ({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codmat, COMBO-BOX-Division).
/*     IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN                                          */
/*         RUN pri/d-xlista-dctovol ({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codmat, COMBO-BOX-Division). */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Descuento_Promocional
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Descuento_Promocional B-table-Win
ON CHOOSE OF MENU-ITEM m_Descuento_Promocional /* Descuento Promocional */
DO:
/*     IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN                                             */
/*         RUN vta2/dlistaexpodctoprom ({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codmat, COMBO-BOX-Division). */
    IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN
        RUN pri/d-eventos-dctoprom ({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codmat, COMBO-BOX-Division).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF T-MATG.CodMat, T-MATG.Chr__01, T-MATG.PreOfi, T-MATG.dec__01
DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-MATG.

/* CASO DE SOLICITAR UN CODIGO ESPECÍFICO */
FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
/*     AND Almmmatg.TpoArt <> "D" */
    AND Almmmatg.codMat = FILL-IN-CodMat
    NO-LOCK NO-ERROR.
FIND FIRST VtaListaMay WHERE VtaListaMay.codcia = s-codcia
    AND VtaListaMay.codmat = FILL-IN-CodMat
    AND VtaListaMay.CodDiv = COMBO-BOX-Division
    NO-LOCK NO-ERROR.
IF FILL-IN-CodMat <> '' AND AVAILABLE Almmmatg AND AVAILABLE VtaListaMay THEN DO:
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
    CREATE T-MATG.
    BUFFER-COPY Almmmatg 
        TO T-MATG
        ASSIGN
        T-MATG.PreOfi = VtaListaMay.PreOfi
        T-MATG.PreBas = VtaListaMay.PreOfi
        T-MATG.CHR__01 = VtaListaMay.CHR__01
        T-MATG.DEC__01 = VtaListaMay.DEC__01
        T-MATG.Orden   = VtaListaMay.FlagDesctos.
END.
ELSE DO:
    FOR EACH VtaListaMay NO-LOCK WHERE VtaListaMay.codcia = s-codcia
        AND VtaListaMay.coddiv = COMBO-BOX-Division,
        FIRST Almmmatg OF VtaListaMay NO-LOCK WHERE {&Condicion}:
        CREATE T-MATG.
        BUFFER-COPY Almmmatg 
            TO T-MATG
            ASSIGN
            T-MATG.PreOfi = VtaListaMay.PreOfi
            T-MATG.PreBas = VtaListaMay.PreOfi
            T-MATG.CHR__01 = VtaListaMay.CHR__01
            T-MATG.DEC__01 = VtaListaMay.DEC__01
            T-MATG.Orden   = VtaListaMay.FlagDesctos.
    END.
END.

/* TODOS LOS PRECIOS EN SOLES */
FOR EACH T-MATG WHERE T-MATG.MonVta = 2:
    ASSIGN
        T-MATG.CtoLis = T-MATG.CtoLis * T-MATG.TpoCmb
        T-MATG.CtoTot = T-MATG.CtoTot * T-MATG.TpoCmb
        .
        /*T-MATG.PreOfi = ROUND(T-MATG.PreOfi * T-MATG.TpoCmb, 4).*/
    RUN lib/RedondearMas (T-MATG.PreOfi * T-MATG.TpoCmb, 4, OUTPUT T-MATG.PreOfi).
END.
/* TODOS LOS PRECIOS EN DOLARES */
FOR EACH T-MATG WHERE T-MATG.MonVta = 1:
    RUN lib/RedondearMas (T-MATG.PreBas / T-MATG.TpoCmb, 4, OUTPUT T-MATG.PreBas).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  s-local-adm-record = YES.

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
  DEF VAR x-CtoTot AS DEC NO-UNDO.
  DEF VAR f-Factor AS DEC NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
  IF RETURN-VALUE = "YES" THEN DO:
      IF CAN-FIND(VtaListaMay WHERE VtaListaMay.codcia = s-codcia
                  AND VtaListaMay.coddiv = COMBO-BOX-Division
                  AND VtaListaMay.codmat = T-MATG.codmat
                  NO-LOCK)
          THEN DO:
          MESSAGE 'Código ya registrado' VIEW-AS ALERT-BOX ERROR.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      ASSIGN
          T-MATG.CodCia = s-codcia.
      CREATE VtaListaMay.
      ASSIGN
          VtaListaMay.CodCia = s-codcia
          VtaListaMay.CodDiv = COMBO-BOX-Division
          VtaListaMay.codmat = T-MATG.codmat.
  END.
  ELSE DO:
      FIND CURRENT VtaListaMay EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
      IF ERROR-STATUS:ERROR THEN DO:
           RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
           UNDO, RETURN 'ADM-ERROR'.
      END.
  END.
  ASSIGN
      VtaListaMay.TpoCmb = Almmmatg.TpoCmb
      VtaListaMay.MonVta = Almmmatg.monvta
      VtaListaMay.FchAct = TODAY
      VtaListaMay.CHR__01 = Almmmatg.CHR__01
      VtaListaMay.PreOfi  = T-MATG.PreOfi
      VtaListaMay.usuario = s-user-id
      VtaListaMay.FlagDesctos = T-MATG.Orden.
  /* REGRABAMOS EN LA MONEDA DE VENTA */
  IF Almmmatg.MonVta = 2 THEN VtaListaMay.PreOfi = ROUND(VtaListaMay.PreOfi / Almmmatg.TpoCmb, 4).
  /* MARGEN */
  IF Almmmatg.monvta = Vtalistamay.monvta THEN x-CtoTot = Almmmatg.CtoTot.
  ELSE IF Vtalistamay.monvta = 1 THEN x-CtoTot = Almmmatg.ctotot *  Almmmatg.tpocmb.
  ELSE x-CtoTot = Almmmatg.ctotot /  Almmmatg.tpocmb.
  FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
      AND Almtconv.Codalter = VtaListaMay.Chr__01
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
  ASSIGN
      VtaListaMay.Dec__01 = ROUND( ( (VtaListaMay.PreOfi / (x-Ctotot * f-Factor) ) - 1 ) * 100, 4)
      T-MATG.Dec__01 = VtaListaMay.Dec__01
      T-MATG.CHR__01 = VtaListaMay.CHR__01.
  ASSIGN
      T-MATG.PreBas = (IF Almmmatg.MonVta = 1 THEN VtaListaMay.PreOfi / Almmmatg.TpoCmb ELSE VtaListaMay.PreOfi).

  FIND CURRENT VtaListaMay NO-LOCK NO-ERROR.

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
  s-local-adm-record = NO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR':
    /* Code placed here will execute PRIOR to standard behavior. */
    FIND CURRENT VtaListaMay EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR THEN DO:
         RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
         RETURN 'ADM-ERROR'.
    END.
    DELETE VtaListaMay.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    /* Code placed here will execute AFTER standard behavior.    */

END.
  
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
          BUTTON-9:SENSITIVE = YES
          /*COMBO-BOX-Division:SENSITIVE = YES*/
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
          BUTTON-9:SENSITIVE = NO
          COMBO-BOX-Division:SENSITIVE = NO
          COMBO-BOX-Linea:SENSITIVE = NO
          COMBO-BOX-Sublinea:SENSITIVE = NO
          FILL-IN-CodPro:SENSITIVE = NO
          FILL-IN-DesMat:SENSITIVE = NO
          FILL-IN-CodMat:SENSITIVE = NO
          BUTTON-8:SENSITIVE = NO.
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'YES' THEN DO:
          T-MATG.codmat:READ-ONLY IN BROWSE {&browse-name} = NO.
          /*APPLY 'ENTRY':U TO T-MATG.codmat IN BROWSE {&browse-name}.*/
      END.
      ELSE DO:
          T-MATG.codmat:READ-ONLY IN BROWSE {&browse-name} = YES.
          APPLY 'ENTRY':U TO T-MATG.Dec__01 IN BROWSE {&browse-name}.
      END.
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
      COMBO-BOX-Division:DELETE(1).
      FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND 
          LOOKUP(GN-DIVI.CanalVenta, s-CanalVenta) > 0 AND
          GN-DIVI.VentaMayorista = 2    /* Lista x División */
          BREAK BY gn-divi.codcia BY gn-divi.coddiv:
          COMBO-BOX-Division:ADD-LAST( GN-DIVI.CodDiv + ' - ' + GN-DIVI.DesDiv, GN-DIVI.CodDiv ).
          IF FIRST-OF(gn-divi.codcia) THEN COMBO-BOX-Division = gn-divi.coddiv.
      END.
      FOR EACH Vtatabla NO-LOCK WHERE Vtatabla.codcia = s-codcia
          AND Vtatabla.tabla = "LP"
          AND Vtatabla.llave_c1 = s-user-id,
          FIRST Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia
          AND Almtfami.codfam = Vtatabla.llave_c2:
          COMBO-BOX-Linea:ADD-LAST( Almtfami.codfam + ' - ' + Almtfami.desfam).
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
  /*IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.*/

  /* Code placed here will execute AFTER standard behavior.    */

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
DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

DEF VAR x-Margen AS DEC NO-UNDO.    /* Margen de utilidad */

pError = ''.

RUN vtagn/p-margen-utilidad-v11 (pCodDiv,
                                 pCodMat,
                                 pPreUni,
                                 pUndVta,
                                 1,
                                 pTpoCmb,       /* Tipo de cambio */
                                 YES,            /* Muestra el error */
                                 "",
                                 OUTPUT x-Margen,        /* Margen de utilidad */
                                 OUTPUT x-Limite,        /* Margen mínimo de utilidad */
                                 OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
                                 ).
/*
RUN vtagn/p-margen-utilidad-v2 (pCodDiv,
                                pCodMat,
                                pPreUni,
                                pUndVta,
                                1,                      /* Moneda */
                                pTpoCmb,
                                YES,                     /* Muestra error? */
                                "",                     /* Almacén */
                                OUTPUT x-Margen,        /* Margen de utilidad */
                                OUTPUT x-Limite,        /* Margen mínimo de utilidad */
                                OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
                                ).
*/

IF RETURN-VALUE = 'ADM-ERROR' THEN pError = 'ADM-ERROR'.

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
  {src/adm/template/snd-list.i "VtaListaMay"}

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

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = T-MATG.codmat:SCREEN-VALUE IN BROWSE {&browse-name}
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
    MESSAGE 'Artículo NO registrado en el catálogo'
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO T-MATG.codmat IN BROWSE {&browse-name}.
    RETURN "ADM-ERROR".
END.

FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = T-MATG.Chr__01:SCREEN-VALUE IN BROWSE {&browse-name}
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    MESSAGE "Equivalencia NO definida" SKIP
        "Unidad base :" Almmmatg.undbas SKIP
        "Unidad venta:" T-MATG.Chr__01:SCREEN-VALUE IN BROWSE {&browse-name}
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO T-MATG.codmat IN BROWSE {&browse-name}.
    RETURN "ADM-ERROR".
END.
IF DECIMAL (T-MATG.PreOfi:SCREEN-VALUE IN BROWSE {&Browse-name}) = 0 THEN DO:
    MESSAGE 'Debe ingresar el precio de venta'
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO T-MATG.PreOfi IN BROWSE {&browse-name}.
    RETURN "ADM-ERROR".
END.
/* ****************************************************************************************************** */
/* Control Margen de Utilidad */
/* ****************************************************************************************************** */
DEFINE VAR x-Margen AS DECI NO-UNDO.
DEFINE VAR x-Limite AS DECI NO-UNDO.
DEFINE VAR pError AS CHAR NO-UNDO.

DEFINE VAR hProc AS HANDLE NO-UNDO.

/* 1ro. Calculamos el margen de utilidad */
RUN pri/pri-librerias PERSISTENT SET hProc.
RUN PRI_Margen-Utilidad IN hProc (INPUT COMBO-BOX-Division,
                                  INPUT T-MATG.CodMat:SCREEN-VALUE IN BROWSE {&browse-name},
                                  INPUT T-MATG.CHR__01:SCREEN-VALUE IN BROWSE {&Browse-name},
                                  INPUT DECIMAL (T-MATG.PreOfi:SCREEN-VALUE IN BROWSE {&Browse-name}),
                                  INPUT 1,
                                  OUTPUT x-Margen,
                                  OUTPUT x-Limite,
                                  OUTPUT pError).

IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    /* Error crítico */
    MESSAGE pError SKIP 'No admitido' VIEW-AS ALERT-BOX ERROR TITLE 'CONTROL DE MARGEN'.
    APPLY 'ENTRY':U TO T-MATG.Dec__01 IN BROWSE {&browse-name}.
    RETURN 'ADM-ERROR'.
END.
/* Controlamos si el margen de utilidad está bajo a través de la variable pError */
IF pError > '' THEN DO:
    /* Error por margen de utilidad */
    /* 2do. Verificamos si solo es una ALERTA, definido por GG */
    DEF VAR pAlerta AS LOG NO-UNDO.
    RUN PRI_Alerta-de-Margen IN hProc (INPUT T-MATG.CodMat:SCREEN-VALUE IN BROWSE {&browse-name},
                                       OUTPUT pAlerta).
    IF pAlerta = YES THEN MESSAGE pError VIEW-AS ALERT-BOX WARNING TITLE 'CONTROL DE MARGEN'.
    ELSE DO:
        MESSAGE pError SKIP 'NO admitido' VIEW-AS ALERT-BOX ERROR TITLE 'CONTROL DE MARGEN'.
        APPLY 'ENTRY':U TO T-MATG.Dec__01 IN BROWSE {&browse-name}.
        RETURN 'ADM-ERROR'.
    END.
END.
DELETE PROCEDURE hProc.
/* ****************************************************************************************************** */
/* DEF VAR x-Limite AS DEC NO-UNDO.                                                           */
/* DEF VAR pError AS CHAR NO-UNDO.                                                            */
/* RUN Margen-de-Utilidad (COMBO-BOX-Division,                                                */
/*                         T-MATG.CodMat:SCREEN-VALUE IN BROWSE {&browse-name},               */
/*                         DECIMAL (T-MATG.PreOfi:SCREEN-VALUE IN BROWSE {&Browse-name}),     */
/*                         T-MATG.CHR__01:SCREEN-VALUE IN BROWSE {&Browse-name},              */
/*                         Almmmatg.TpoCmb,                                                   */
/*                         OUTPUT x-Limite,        /* Margen mínimo de utilidad */            */
/*                         OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */ */
/*                         ).                                                                 */
/* IF pError = "ADM-ERROR" THEN DO:                                                           */
/*     APPLY 'ENTRY' TO T-MATG.Dec__01 IN BROWSE {&browse-name}.                              */
/*     RETURN "ADM-ERROR".                                                                    */
/* END.                                                                                       */

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
s-local-adm-record = YES.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fMonVta B-table-Win 
FUNCTION fMonVta RETURNS CHARACTER
  ( INPUT pMonVta AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

IF pMonVta = 1 THEN RETURN "S/.".
IF pMonVta = 2 THEN RETURN "US$".
RETURN "S/.".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

