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
DEF SHARED VAR s-codcia AS INTE.

/* Local Variable Definitions ---                                       */

DEF VAR x-PreVta AS DECI EXTENT 4 NO-UNDO.
DEF VAR x-PreOfi AS DECI NO-UNDO.
DEF VAR x-PreAlt AS DECI NO-UNDO.

&SCOPED-DEFINE Condicion ( ~
Almmmatg.TpoArt <> "D" AND ~
(COMBO-BOX-Linea = 'Todas' OR Almmmatg.codfam = ENTRY(1, COMBO-BOX-Linea, ' - ') ) AND ~
(COMBO-BOX-SubLinea = 'Todas' OR Almmmatg.subfam = ENTRY(1, COMBO-BOX-SubLinea, ' - ') ) )

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
&Scoped-define FIELDS-IN-QUERY-br_table Almmmatg.codmat Almmmatg.DesMat ~
Almmmatg.UndStk Almmmatg.DesMar ~
fPreVta(Almmmatg.Prevta[1],RADIO-SET_Moneda) @ x-PreVta[1] ~
fPreVta(Almmmatg.Prevta[2],RADIO-SET_Moneda) @ x-PreVta[2] Almmmatg.UndA ~
fPreVta(Almmmatg.Prevta[3],RADIO-SET_Moneda) @ x-PreVta[3] Almmmatg.UndB ~
fPreVta(Almmmatg.Prevta[4],RADIO-SET_Moneda) @ x-PreVta[4] Almmmatg.UndC ~
fPreVta(Almmmatg.PreOfi,RADIO-SET_Moneda) @ x-PreOfi Almmmatg.Chr__01 ~
fPreVta(VtaListaMinGn.PreOfi,RADIO-SET_Moneda) @ x-PreAlt 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH Almmmatg WHERE ~{&KEY-PHRASE} ~
      AND Almmmatg.CodCia = s-codcia ~
 AND {&Condicion} NO-LOCK, ~
      FIRST VtaListaMinGn OF Almmmatg OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Almmmatg WHERE ~{&KEY-PHRASE} ~
      AND Almmmatg.CodCia = s-codcia ~
 AND {&Condicion} NO-LOCK, ~
      FIRST VtaListaMinGn OF Almmmatg OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table Almmmatg VtaListaMinGn
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Almmmatg
&Scoped-define SECOND-TABLE-IN-QUERY-br_table VtaListaMinGn


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Linea BUTTON-8 COMBO-BOX-Sublinea ~
RADIO-SET_Moneda br_table 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Linea COMBO-BOX-Sublinea ~
RADIO-SET_Moneda 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPreVta B-table-Win 
FUNCTION fPreVta RETURNS DECIMAL
  ( INPUT pPreUni AS DECI, INPUT pMoneda AS INTE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-br_table 
       MENU-ITEM m_LIMA_-_Descuento_Promociona LABEL "LIMA - Descuento Promocional"
       MENU-ITEM m_UTILEX_-_Descuento_Promocio LABEL "UTILEX - Descuento Promocional"
       MENU-ITEM m_UTILEX_-_Descuento_por_Volu LABEL "UTILEX - Descuento por Volumen"
       MENU-ITEM m_LIMA_-_Descuento_por_Volume LABEL "LIMA - Descuento por Volumen".


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

DEFINE VARIABLE RADIO-SET_Moneda AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "SOLES", 1,
"DOLARES", 2
     SIZE 27 BY 1.08 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      Almmmatg, 
      VtaListaMinGn
    FIELDS(VtaListaMinGn.PreOfi) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Almmmatg.codmat FORMAT "X(6)":U
      Almmmatg.DesMat FORMAT "X(60)":U
      Almmmatg.UndStk FORMAT "X(8)":U
      Almmmatg.DesMar FORMAT "X(20)":U
      fPreVta(Almmmatg.Prevta[1],RADIO-SET_Moneda) @ x-PreVta[1] COLUMN-LABEL "Precio Lista" FORMAT ">>,>>>,>>9.9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      fPreVta(Almmmatg.Prevta[2],RADIO-SET_Moneda) @ x-PreVta[2] COLUMN-LABEL "Precio A" FORMAT ">>>,>>9.9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      Almmmatg.UndA FORMAT "X(8)":U COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      fPreVta(Almmmatg.Prevta[3],RADIO-SET_Moneda) @ x-PreVta[3] COLUMN-LABEL "Precio B" FORMAT ">>>,>>9.9999":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 13
      Almmmatg.UndB FORMAT "X(8)":U COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 13
      fPreVta(Almmmatg.Prevta[4],RADIO-SET_Moneda) @ x-PreVta[4] COLUMN-LABEL "Precio C" FORMAT ">>>,>>9.9999":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 1
      Almmmatg.UndC FORMAT "X(8)":U COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 1
      fPreVta(Almmmatg.PreOfi,RADIO-SET_Moneda) @ x-PreOfi COLUMN-LABEL "Precio Oficina" FORMAT ">>>,>>9.9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 12
      Almmmatg.Chr__01 COLUMN-LABEL "UM Ofic" FORMAT "X(8)":U COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 12
      fPreVta(VtaListaMinGn.PreOfi,RADIO-SET_Moneda) @ x-PreAlt COLUMN-LABEL "UTILEX Precio"
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 2
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 188 BY 21.54
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Linea AT ROW 1.27 COL 17 COLON-ALIGNED WIDGET-ID 8
     BUTTON-8 AT ROW 1.27 COL 76 WIDGET-ID 12
     COMBO-BOX-Sublinea AT ROW 2.35 COL 17 COLON-ALIGNED WIDGET-ID 10
     RADIO-SET_Moneda AT ROW 3.42 COL 19 NO-LABEL WIDGET-ID 2
     br_table AT ROW 4.5 COL 1
     "Visualizar en:" VIEW-AS TEXT
          SIZE 12 BY .62 AT ROW 3.69 COL 6 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


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
         HEIGHT             = 25.88
         WIDTH              = 188.29.
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
/* BROWSE-TAB br_table RADIO-SET_Moneda F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-br_table:HANDLE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.Almmmatg,INTEGRAL.VtaListaMinGn OF INTEGRAL.Almmmatg"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST OUTER USED"
     _Where[1]         = "Almmmatg.CodCia = s-codcia
 AND {&Condicion}"
     _FldNameList[1]   = INTEGRAL.Almmmatg.codmat
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.Almmmatg.UndStk
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" ? "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fPreVta(Almmmatg.Prevta[1],RADIO-SET_Moneda) @ x-PreVta[1]" "Precio Lista" ">>,>>>,>>9.9999" ? 14 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fPreVta(Almmmatg.Prevta[2],RADIO-SET_Moneda) @ x-PreVta[2]" "Precio A" ">>>,>>9.9999" ? 11 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.Almmmatg.UndA
"Almmmatg.UndA" ? ? "character" 11 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"fPreVta(Almmmatg.Prevta[3],RADIO-SET_Moneda) @ x-PreVta[3]" "Precio B" ">>>,>>9.9999" ? 13 15 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.Almmmatg.UndB
"Almmmatg.UndB" ? ? "character" 13 15 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"fPreVta(Almmmatg.Prevta[4],RADIO-SET_Moneda) @ x-PreVta[4]" "Precio C" ">>>,>>9.9999" ? 1 15 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.Almmmatg.UndC
"Almmmatg.UndC" ? ? "character" 1 15 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"fPreVta(Almmmatg.PreOfi,RADIO-SET_Moneda) @ x-PreOfi" "Precio Oficina" ">>>,>>9.9999" ? 12 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > INTEGRAL.Almmmatg.Chr__01
"Almmmatg.Chr__01" "UM Ofic" ? "character" 12 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"fPreVta(VtaListaMinGn.PreOfi,RADIO-SET_Moneda) @ x-PreAlt" "UTILEX Precio" ? ? 2 15 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 B-table-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* APLICAR FILTRO */
DO:
  ASSIGN COMBO-BOX-Linea COMBO-BOX-Sublinea.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
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


&Scoped-define SELF-NAME m_LIMA_-_Descuento_por_Volume
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_LIMA_-_Descuento_por_Volume B-table-Win
ON CHOOSE OF MENU-ITEM m_LIMA_-_Descuento_por_Volume /* LIMA - Descuento por Volumen */
DO:
    IF AVAILABLE Almmmatg THEN RUN pri/d-consulta-dctovol-may.r (Almmmatg.codmat).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_LIMA_-_Descuento_Promociona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_LIMA_-_Descuento_Promociona B-table-Win
ON CHOOSE OF MENU-ITEM m_LIMA_-_Descuento_Promociona /* LIMA - Descuento Promocional */
DO:
  IF AVAILABLE Almmmatg THEN RUN pri/d-consulta-dctoprom-may (Almmmatg.CodMat).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_UTILEX_-_Descuento_por_Volu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_UTILEX_-_Descuento_por_Volu B-table-Win
ON CHOOSE OF MENU-ITEM m_UTILEX_-_Descuento_por_Volu /* UTILEX - Descuento por Volumen */
DO:
    FIND VtaListaMinGn OF Almmmatg NO-LOCK NO-ERROR.
    IF AVAILABLE VtaListaMinGn THEN RUN pri/d-consulta-dctovol-min.r (Almmmatg.codmat).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_UTILEX_-_Descuento_Promocio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_UTILEX_-_Descuento_Promocio B-table-Win
ON CHOOSE OF MENU-ITEM m_UTILEX_-_Descuento_Promocio /* UTILEX - Descuento Promocional */
DO:
    FIND VtaListaMinGn OF Almmmatg NO-LOCK NO-ERROR.
    IF AVAILABLE VtaListaMinGn THEN RUN Pri/d-consulta-dctoprom-min.r (Almmmatg.codmat).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET_Moneda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET_Moneda B-table-Win
ON VALUE-CHANGED OF RADIO-SET_Moneda IN FRAME F-Main
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH Almtfami NO-LOCK WHERE Almtfami.CodCia = s-codcia AND Almtfami.SwComercial = YES:
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPreVta B-table-Win 
FUNCTION fPreVta RETURNS DECIMAL
  ( INPUT pPreUni AS DECI, INPUT pMoneda AS INTE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF Almmmatg.MonVta = pMoneda THEN RETURN pPreUni.
  ELSE IF Almmmatg.MonVta = 1 THEN RETURN pPreUni / Almmmatg.TpoCmb.
  ELSE RETURN pPreUni * Almmmatg.TpoCmb.

  RETURN 0.00.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

