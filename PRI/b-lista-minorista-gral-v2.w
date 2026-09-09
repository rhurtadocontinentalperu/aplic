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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR s-LineasValidas AS CHAR NO-UNDO.

FOR EACH Vtatabla NO-LOCK WHERE Vtatabla.codcia = s-codcia
    AND Vtatabla.tabla = "LP"
    AND Vtatabla.llave_c1 = s-user-id,
    FIRST Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia
    AND Almtfami.codfam = Vtatabla.llave_c2:
    s-LineasValidas = s-LineasValidas + (IF TRUE <> (s-LineasValidas > '') THEN '' ELSE ',') +
        Almtfami.codfam.
END.

&SCOPED-DEFINE Condicion ( Almmmatg.codcia = s-codcia ~
AND Almmmatg.TpoArt <> "D" ~
AND ( TRUE <> (FILL-IN-CodMat > '') OR Almmmatg.CodMat = FILL-IN-CodMat ) ~
AND LOOKUP(Almmmatg.codfam, s-LineasValidas) > 0 ~
AND (COMBO-BOX-Linea = 'Todas' OR Almmmatg.codfam = ENTRY(1, COMBO-BOX-Linea, ' - ') ) ~
AND (COMBO-BOX-SubLinea = 'Todas' OR Almmmatg.subfam = ENTRY(1, COMBO-BOX-SubLinea, ' - ') ) ~
AND (FILL-IN-CodPro = "" OR Almmmatg.CodPr1 = FILL-IN-CodPro) ~
AND (FILL-IN-DesMat = "" OR INDEX(Almmmatg.desmat, FILL-IN-DesMat) > 0) )

DEFINE VARIABLE X-CTOUND AS DECIMAL NO-UNDO.
DEFINE VARIABLE X-CTOTOT AS DECIMAL FORMAT "->>>>>>>>>9.999999" NO-UNDO.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEF VAR x-MonCmp AS CHAR FORMAT 'x(8)' NO-UNDO.
DEF VAR x-MonVta AS CHAR FORMAT 'x(8)' NO-UNDO.
DEF VAR pError AS CHAR NO-UNDO.
DEF VAR pAlerta AS CHAR NO-UNDO.
DEF VAR f-Factor AS DECI NO-UNDO.

DEFINE SHARED VAR s-acceso-total  AS LOG NO-UNDO.

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
&Scoped-define INTERNAL-TABLES Almmmatg VtaListaMinGn

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table VtaListaMinGn.codmat ~
Almmmatg.DesMat Almmmatg.DesMar Almmmatg.dsctoprom[2] ~
( IF Almmmatg.DsctoProm[1] = 1 THEN  'Soles'  ELSE 'Dolares' ) @ x-MonCmp ~
( IF Almmmatg.MonVta = 1 THEN  'Soles'  ELSE 'Dolares' ) @ x-MonVta ~
Almmmatg.TpoCmb Almmmatg.CtoTot Almmmatg.Prevta[1] VtaListaMinGn.Dec__01 ~
VtaListaMinGn.PreOfi Almmmatg.Chr__01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table VtaListaMinGn.codmat ~
VtaListaMinGn.Dec__01 VtaListaMinGn.PreOfi 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table VtaListaMinGn
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table VtaListaMinGn
&Scoped-define QUERY-STRING-br_table FOR EACH Almmmatg WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST VtaListaMinGn OF Almmmatg NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Almmmatg WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST VtaListaMinGn OF Almmmatg NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table Almmmatg VtaListaMinGn
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Almmmatg
&Scoped-define SECOND-TABLE-IN-QUERY-br_table VtaListaMinGn


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Linea FILL-IN-DesMat ~
FILL-IN-CodMat BUTTON-8 COMBO-BOX-Sublinea FILL-IN-CodPro br_table 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Linea FILL-IN-DesMat ~
FILL-IN-CodMat COMBO-BOX-Sublinea FILL-IN-CodPro FILL-IN-NomPro 

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
       MENU-ITEM m_UTILEX_-_Descuento_Promocio LABEL "UTILEX - Descuento Promocional"
       MENU-ITEM m_UTILEX_-_Descuento_por_Volu LABEL "UTILEX - Descuento por Volumen".


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-8 
     LABEL "APLICAR FILTRO" 
     SIZE 18 BY 1.12
     FONT 6.

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
      Almmmatg, 
      VtaListaMinGn SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      VtaListaMinGn.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U
            WIDTH 9 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 60.43
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U
      Almmmatg.dsctoprom[2] COLUMN-LABEL "Costo" FORMAT "->>>,>>9.9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 8
      ( IF Almmmatg.DsctoProm[1] = 1 THEN  'Soles'  ELSE 'Dolares' ) @ x-MonCmp COLUMN-LABEL "Moneda!Compra"
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 8
      ( IF Almmmatg.MonVta = 1 THEN  'Soles'  ELSE 'Dolares' ) @ x-MonVta COLUMN-LABEL "Moneda!LP"
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 10
      Almmmatg.TpoCmb COLUMN-LABEL "TC!Venta" FORMAT "Z9.9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 10
      Almmmatg.CtoTot COLUMN-LABEL "Costo Total" FORMAT "->>>,>>9.9999":U
            WIDTH 13.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      Almmmatg.Prevta[1] COLUMN-LABEL "Precio Lista!Mayorista" FORMAT ">>>,>>9.9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      VtaListaMinGn.Dec__01 COLUMN-LABEL "% Uti" FORMAT "-ZZZ,ZZ9.9999":U
            WIDTH 7.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      VtaListaMinGn.PreOfi COLUMN-LABEL "Precio Utilex" FORMAT ">,>>>,>>9.9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      Almmmatg.Chr__01 COLUMN-LABEL "UM Ofic" FORMAT "X(8)":U WIDTH 7
  ENABLE
      VtaListaMinGn.codmat
      VtaListaMinGn.Dec__01
      VtaListaMinGn.PreOfi
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 170 BY 21
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Linea AT ROW 1 COL 12 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-DesMat AT ROW 1 COL 99 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-CodMat AT ROW 1.04 COL 79 COLON-ALIGNED WIDGET-ID 18
     BUTTON-8 AT ROW 1.81 COL 153 WIDGET-ID 10
     COMBO-BOX-Sublinea AT ROW 2.08 COL 12 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-CodPro AT ROW 2.08 COL 79 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-NomPro AT ROW 2.08 COL 91 COLON-ALIGNED NO-LABEL WIDGET-ID 8
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
         HEIGHT             = 24.35
         WIDTH              = 172.72.
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
/* BROWSE-TAB br_table FILL-IN-NomPro F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-br_table:HANDLE.

/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.Almmmatg,INTEGRAL.VtaListaMinGn OF INTEGRAL.Almmmatg"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > INTEGRAL.VtaListaMinGn.codmat
"VtaListaMinGn.codmat" "Articulo" ? "character" 11 0 ? ? ? ? yes ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "60.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.dsctoprom[2]
"Almmmatg.dsctoprom[2]" "Costo" "->>>,>>9.9999" "decimal" 8 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"( IF Almmmatg.DsctoProm[1] = 1 THEN  'Soles'  ELSE 'Dolares' ) @ x-MonCmp" "Moneda!Compra" ? ? 8 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"( IF Almmmatg.MonVta = 1 THEN  'Soles'  ELSE 'Dolares' ) @ x-MonVta" "Moneda!LP" ? ? 10 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.Almmmatg.TpoCmb
"Almmmatg.TpoCmb" "TC!Venta" ? "decimal" 10 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.Almmmatg.CtoTot
"Almmmatg.CtoTot" "Costo Total" ? "decimal" 14 0 ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.Almmmatg.Prevta[1]
"Almmmatg.Prevta[1]" "Precio Lista!Mayorista" ">>>,>>9.9999" "decimal" 14 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.VtaListaMinGn.Dec__01
"VtaListaMinGn.Dec__01" "% Uti" "-ZZZ,ZZ9.9999" "decimal" 11 0 ? ? ? ? yes ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.VtaListaMinGn.PreOfi
"VtaListaMinGn.PreOfi" "Precio Utilex" ? "decimal" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.Almmmatg.Chr__01
"Almmmatg.Chr__01" "UM Ofic" ? "character" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME VtaListaMinGn.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMinGn.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF VtaListaMinGn.codmat IN BROWSE br_table /* Articulo */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    
    DEF VAR pCodMat AS CHAR.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vtagn/p-codbrr-01 (INPUT-OUTPUT pCodMat).
    IF pCodMat = '' THEN RETURN NO-APPLY.
    SELF:SCREEN-VALUE = pCodMat.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = SELF:SCREEN-VALUE NO-LOCK.
    DISPLAY 
        Almmmatg.TpoCmb
        Almmmatg.CHR__01
        Almmmatg.desmar
        Almmmatg.desmat
        WITH BROWSE {&browse-name}.
    DISPLAY 
        Almmmatg.DsctoProm[2] 
        Almmmatg.CtoTot
        ( IF Almmmatg.DsctoProm[1] = 1 THEN  'Soles'  ELSE 'Dolares' ) @ x-MonCmp
        ( IF Almmmatg.MonVta = 1 THEN  'Soles'  ELSE 'Dolares' ) @ x-MonVta
        WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMinGn.Dec__01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMinGn.Dec__01 br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF VtaListaMinGn.Dec__01 IN BROWSE br_table /* % Uti */
DO:
    ASSIGN
        X-CTOUND   = Almmmatg.CtoTot
        F-FACTOR = 1.
     /****   Busca el Factor de conversion   ****/
     FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
         AND  Almtconv.Codalter = Almmmatg.CHR__01
         NO-LOCK NO-ERROR.
     IF NOT AVAILABLE Almtconv THEN RETURN.
     F-FACTOR = Almtconv.Equival.
     DISPLAY
         ROUND(( X-CTOUND * (1 + DECIMAL(SELF:SCREEN-VALUE) / 100) ), 6) * F-FACTOR @ VtaListaMinGn.PreOfi 
         WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMinGn.PreOfi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMinGn.PreOfi br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF VtaListaMinGn.PreOfi IN BROWSE br_table /* Precio Utilex */
DO:
    ASSIGN
        X-CTOUND = Almmmatg.CtoTot
        F-FACTOR = 1.
    /****   Busca el Factor de conversion   ****/
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
        AND  Almtconv.Codalter = Almmmatg.CHR__01
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN RETURN.
    F-FACTOR = Almtconv.Equival.
    DISPLAY
        ROUND(((((DECIMAL(SELF:SCREEN-VALUE) / F-FACTOR) / X-CTOUND) - 1) * 100), 6) @ VtaListaMinGn.Dec__01
        WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 B-table-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* APLICAR FILTRO */
DO:
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Actualiza-TC.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    SESSION:SET-WAIT-STATE('').
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


&Scoped-define SELF-NAME m_UTILEX_-_Descuento_por_Volu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_UTILEX_-_Descuento_por_Volu B-table-Win
ON CHOOSE OF MENU-ITEM m_UTILEX_-_Descuento_por_Volu /* UTILEX - Descuento por Volumen */
DO:
    IF AVAILABLE VtaListaMinGn THEN RUN pri/D-Utilex-DtoVol-v2.r (VtaListaMinGn.codmat).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_UTILEX_-_Descuento_Promocio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_UTILEX_-_Descuento_Promocio B-table-Win
ON CHOOSE OF MENU-ITEM m_UTILEX_-_Descuento_Promocio /* UTILEX - Descuento Promocional */
DO:
    IF AVAILABLE VtaListaMinGn THEN RUN Pri/D-Utilex-DctoProm-v2.r (VtaListaMinGn.codmat).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-TC B-table-Win 
PROCEDURE Actualiza-TC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF COMBO-BOX-Linea = 'Todas' AND  
    TRUE <> (FILL-IN-CodMat > '') AND
    TRUE <> (FILL-IN-CodPro > '') AND
    TRUE <> (FILL-IN-DesMat > '') 
    THEN RETURN.

/* Actualizar el TC para productos que migran del OO */
DEF VAR LocalCuenta AS INTE NO-UNDO.
DEF BUFFER B-MATG FOR Almmmatg.

FOR EACH Almmmatg WHERE {&Condicion} NO-LOCK,
    FIRST VtaListaMinGn OF Almmmatg NO-LOCK,
    FIRST Almtfami OF Almmmatg NO-LOCK:
    IF Almtfami.tpocmb = Almmmatg.tpocmb THEN NEXT.
    LocalCuenta = 1.
    REPEAT WHILE LocalCuenta <= 100:
        FIND B-MATG WHERE ROWID(B-MATG) = ROWID(Almmmatg) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF AVAILABLE B-MATG THEN DO:
            ASSIGN
                B-MATG.TpoCmb = Almtfami.tpocmb.
            RELEASE B-MATG.
            LEAVE.
        END.
        LocalCuenta = LocalCuenta + 1.
    END.
END.


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
      VtaListaMinGn.CodCia   = Almmmatg.CodCia 
      VtaListaMinGn.DesMat   = Almmmatg.DesMat 
      VtaListaMinGn.DesMar   = Almmmatg.DesMar
      VtaListaMinGn.codfam   = Almmmatg.codfam 
      VtaListaMinGn.subfam   = Almmmatg.subfam 
      VtaListaMinGn.MonVta   = Almmmatg.MonVta 
      VtaListaMinGn.TpoCmb   = Almmmatg.TpoCmb 
      VtaListaMinGn.Chr__01  = Almmmatg.Chr__01.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN
      ASSIGN
      VtaListaMinGn.FchIng  = TODAY
      VtaListaMinGn.usuario = s-user-id.
  ELSE ASSIGN
      VtaListaMinGn.FchAct = TODAY
      VtaListaMinGn.UserUpdate = s-user-id.

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
          FILL-IN-CodMat:SENSITIVE = YES.
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
          FILL-IN-CodMat:SENSITIVE = NO.
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'YES' THEN VtaListaMinGn.codmat:READ-ONLY IN BROWSE {&browse-name} = NO.
      ELSE VtaListaMinGn.codmat:READ-ONLY IN BROWSE {&browse-name} = YES.
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
      FOR EACH Vtatabla NO-LOCK WHERE Vtatabla.codcia = s-codcia
          AND Vtatabla.tabla = "LP"
          AND Vtatabla.llave_c1 = s-user-id,
          FIRST Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia
          AND Almtfami.codfam = Vtatabla.llave_c2:
          COMBO-BOX-Linea:ADD-LAST( Almtfami.codfam + ' - ' + Almtfami.desfam).
      END.
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
  {src/adm/template/snd-list.i "VtaListaMinGn"}

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
    AND Almmmatg.codmat = VtaListaMinGn.codmat:SCREEN-VALUE IN BROWSE {&browse-name} 
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
    MESSAGE 'Código del producto NO registrado'
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO VtaListaMinGn.codmat IN BROWSE {&browse-name}.
    RETURN "ADM-ERROR".
END.
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = Almmmatg.Chr__01
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    MESSAGE "Equivalencia NO definida" SKIP
        "Unidad base :" Almmmatg.undbas SKIP
        "Unidad venta:" VtaListaMinGn.Chr__01
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO VtaListaMinGn.codmat IN BROWSE {&browse-name}.
    RETURN "ADM-ERROR".
END.
IF DECIMAL (VtaListaMinGn.PreOfi:SCREEN-VALUE IN BROWSE {&Browse-name}) = 0 THEN DO:
    MESSAGE 'Debe ingresar el precio de venta'
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO VtaListaMinGn.PreOfi IN BROWSE {&browse-name}.
    RETURN "ADM-ERROR".
END.

RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
IF RETURN-VALUE = "YES" THEN DO:
    IF CAN-FIND(VtaListaMinGn WHERE VtaListaMinGn.codcia = s-codcia
                AND VtaListaMinGn.codmat = VtaListaMinGn.codmat:SCREEN-VALUE IN BROWSE {&browse-name}
                NO-LOCK)
        THEN DO:
        MESSAGE 'Código ya registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO VtaListaMinGn.CodMat.
        RETURN 'ADM-ERROR'.
    END.
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
RUN PRI_Margen-Utilidad IN hProc ("",
                                  INPUT VtaListaMinGn.CodMat:SCREEN-VALUE IN BROWSE {&browse-name},
                                  INPUT Almmmatg.CHR__01,
                                  INPUT DECIMAL (VtaListaMinGn.PreOfi:SCREEN-VALUE IN BROWSE {&Browse-name}),
                                  INPUT Almmmatg.MonVta,
                                  OUTPUT x-Margen,
                                  OUTPUT x-Limite,
                                  OUTPUT pError).
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    /* Error crítico */
    MESSAGE pError SKIP 'No admitido' VIEW-AS ALERT-BOX ERROR TITLE 'CONTROL DE MARGEN'.
    APPLY 'ENTRY':U TO VtaListaMinGn.Dec__01 IN BROWSE {&browse-name}.
    RETURN 'ADM-ERROR'.
END.
/* Controlamos si el margen de utilidad está bajo a través de la variable pError */
IF pError > '' THEN DO:
    /* Error por margen de utilidad */
    /* 2do. Verificamos si solo es una ALERTA, definido por GG */
    DEF VAR pAlerta AS LOG NO-UNDO.
    RUN PRI_Alerta-de-Margen IN hProc (INPUT VtaListaMinGn.CodMat:SCREEN-VALUE IN BROWSE {&browse-name},
                                       OUTPUT pAlerta).
    IF pAlerta = YES THEN MESSAGE pError VIEW-AS ALERT-BOX WARNING TITLE 'CONTROL DE MARGEN'.
    ELSE DO:
        MESSAGE pError SKIP 'NO admitido' VIEW-AS ALERT-BOX ERROR TITLE 'CONTROL DE MARGEN'.
        APPLY 'ENTRY':U TO VtaListaMinGn.Dec__01 IN BROWSE {&browse-name}.
        RETURN 'ADM-ERROR'.
    END.
END.
DELETE PROCEDURE hProc.


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

