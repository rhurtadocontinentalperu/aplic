&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER MATG FOR Almmmatg.



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
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-local-adm-record AS LOG NO-UNDO.

DEF VAR x-CtoUni AS DEC DECIMALS 4 NO-UNDO.
DEF VAR x-MonVta AS CHAR NO-UNDO.
DEF VAR x-MonCmp AS CHAR NO-UNDO.

DEF VAR x-CodFam LIKE Almmmatg.codfam.
DEF VAR x-SubFam LIKE Almmmatg.subfam.
DEF VAR x-CodPro LIKE gn-prov.codpro.
DEF VAR x-ImpCto AS DEC NO-UNDO.

DEF SHARED VAR s-acceso-total AS LOG NO-UNDO.
DEF VAR s-LineasValidas AS CHAR NO-UNDO.

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
&Scoped-define INTERNAL-TABLES Almmmatp Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Almmmatp.codmat Almmmatg.DesMat ~
Almmmatg.UndBas Almmmatg.DesMar almmmatp.CtoTot ~
fMonVta(Almmmatg.MonVta) @ x-MonVta Almmmatg.TpoCmb Almmmatp.Dec__01 ~
Almmmatp.PreOfi Almmmatg.Chr__01 Almmmatp.CanEmp 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table Almmmatp.codmat ~
almmmatp.CtoTot Almmmatp.PreOfi Almmmatp.CanEmp 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table Almmmatp
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table Almmmatp
&Scoped-define QUERY-STRING-br_table FOR EACH Almmmatp WHERE ~{&KEY-PHRASE} ~
      AND Almmmatp.CodCia = s-codcia ~
 NO-LOCK, ~
      FIRST Almmmatg OF Almmmatp ~
      WHERE (x-CodFam = 'Todos' or Almmmatg.codfam BEGINS x-CodFam) ~
 AND (x-subFam = 'Todos' or Almmmatg.subfam BEGINS x-SubFam) ~
 AND LOOKUP(Almmmatg.codfam, s-LineasValidas) > 0 ~
 AND Almmmatg.CodPr1 BEGINS x-codpro NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Almmmatp WHERE ~{&KEY-PHRASE} ~
      AND Almmmatp.CodCia = s-codcia ~
 NO-LOCK, ~
      FIRST Almmmatg OF Almmmatp ~
      WHERE (x-CodFam = 'Todos' or Almmmatg.codfam BEGINS x-CodFam) ~
 AND (x-subFam = 'Todos' or Almmmatg.subfam BEGINS x-SubFam) ~
 AND LOOKUP(Almmmatg.codfam, s-LineasValidas) > 0 ~
 AND Almmmatg.CodPr1 BEGINS x-codpro NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table Almmmatp Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Almmmatp
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-CodMat BUTTON-5 BUTTON-7 ~
COMBO-BOX-Linea COMBO-BOX-Sublinea txt-codprov br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodMat COMBO-BOX-Linea ~
COMBO-BOX-Sublinea txt-codprov txt-desprov 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCtoUni B-table-Win 
FUNCTION fCtoUni RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fImpCto B-table-Win 
FUNCTION fImpCto RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fMonVta B-table-Win 
FUNCTION fMonVta RETURNS CHARACTER
  ( INPUT pMonVta AS INTE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-br_table 
       MENU-ITEM m_Descuento_Promocional LABEL "Descuento Promocional"
       MENU-ITEM m_Descuento_por_Volumen LABEL "Descuento por Volumen".


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img/b-buscar.ico":U
     LABEL "Button 5" 
     SIZE 5 BY 1.12.

DEFINE BUTTON BUTTON-7 
     IMAGE-UP FILE "img/search.ico":U
     LABEL "Button 7" 
     SIZE 8 BY 1.88 TOOLTIP "Filtrar".

DEFINE VARIABLE COMBO-BOX-Linea AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Linea" 
     VIEW-AS COMBO-BOX INNER-LINES 30
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 51 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Sublinea AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Sublinea" 
     VIEW-AS COMBO-BOX INNER-LINES 30
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 51 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodMat AS CHARACTER FORMAT "X(6)":U 
     LABEL "Buscar código" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-codprov AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-desprov AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 65 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      Almmmatp, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Almmmatp.codmat COLUMN-LABEL "Codigo" FORMAT "X(6)":U WIDTH 7.43
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 60.43
      Almmmatg.UndBas FORMAT "X(6)":U
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U
      almmmatp.CtoTot COLUMN-LABEL "Costo MARCO" FORMAT ">>>,>>9.9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 8
      fMonVta(Almmmatg.MonVta) @ x-MonVta COLUMN-LABEL "Moneda !LP" FORMAT "x(5)":U
            WIDTH 7.72 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 10
      Almmmatg.TpoCmb COLUMN-LABEL "T.C.!Venta" FORMAT ">>>9.9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 10
      Almmmatp.Dec__01 COLUMN-LABEL "Margen!%" FORMAT "(ZZZ,ZZ9.9999)":U
            WIDTH 8.72
      Almmmatp.PreOfi COLUMN-LABEL "Precio Venta" FORMAT ">,>>>,>>9.99999":U
            WIDTH 10.43 COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 11
      Almmmatg.Chr__01 COLUMN-LABEL "Unidad!Venta" FORMAT "X(8)":U
      Almmmatp.CanEmp COLUMN-LABEL "Empaque" FORMAT "->>,>>9.99":U
            WIDTH 1.43 COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 11
  ENABLE
      Almmmatp.codmat
      almmmatp.CtoTot
      Almmmatp.PreOfi
      Almmmatp.CanEmp
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 160 BY 19.65
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodMat AT ROW 1 COL 19 COLON-ALIGNED WIDGET-ID 10
     BUTTON-5 AT ROW 1 COL 35 WIDGET-ID 18
     BUTTON-7 AT ROW 1 COL 114 WIDGET-ID 16
     COMBO-BOX-Linea AT ROW 1.08 COL 59 COLON-ALIGNED WIDGET-ID 12
     COMBO-BOX-Sublinea AT ROW 2.12 COL 59 COLON-ALIGNED WIDGET-ID 14
     txt-codprov AT ROW 3.15 COL 59 COLON-ALIGNED WIDGET-ID 20
     txt-desprov AT ROW 3.15 COL 74 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     br_table AT ROW 4.23 COL 1
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
   Temp-Tables and Buffers:
      TABLE: MATG B "?" ? INTEGRAL Almmmatg
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
         HEIGHT             = 23.35
         WIDTH              = 171.
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
/* BROWSE-TAB br_table txt-desprov F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-br_table:HANDLE.

/* SETTINGS FOR FILL-IN txt-desprov IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.Almmmatp,INTEGRAL.Almmmatg OF INTEGRAL.Almmmatp"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST, FIRST OUTER"
     _Where[1]         = "INTEGRAL.Almmmatp.CodCia = s-codcia
"
     _Where[2]         = "(x-CodFam = 'Todos' or INTEGRAL.Almmmatg.codfam BEGINS x-CodFam)
 AND (x-subFam = 'Todos' or INTEGRAL.Almmmatg.subfam BEGINS x-SubFam)
 AND LOOKUP(Almmmatg.codfam, s-LineasValidas) > 0
 AND Almmmatg.CodPr1 BEGINS x-codpro"
     _FldNameList[1]   > INTEGRAL.Almmmatp.codmat
"Almmmatp.codmat" "Codigo" ? "character" 14 0 ? ? ? ? yes ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "60.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.UndBas
"Almmmatg.UndBas" ? "X(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.almmmatp.CtoTot
"almmmatp.CtoTot" "Costo MARCO" ">>>,>>9.9999" "decimal" 8 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fMonVta(Almmmatg.MonVta) @ x-MonVta" "Moneda !LP" "x(5)" ? 10 0 ? ? ? ? no ? no no "7.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.Almmmatg.TpoCmb
"Almmmatg.TpoCmb" "T.C.!Venta" ">>>9.9999" "decimal" 10 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.Almmmatp.Dec__01
"Almmmatp.Dec__01" "Margen!%" "(ZZZ,ZZ9.9999)" "decimal" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.Almmmatp.PreOfi
"Almmmatp.PreOfi" "Precio Venta" ? "decimal" 11 9 ? ? ? ? yes ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.Almmmatg.Chr__01
"Almmmatg.Chr__01" "Unidad!Venta" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.Almmmatp.CanEmp
"Almmmatp.CanEmp" "Empaque" ? "decimal" 11 9 ? ? ? ? yes ? no no "1.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME Almmmatp.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatp.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF Almmmatp.codmat IN BROWSE br_table /* Codigo */
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
        Almmmatg.TpoCmb
        Almmmatg.UndBas
        Almmmatg.CHR__01
        Almmmatg.desmar
        Almmmatg.desmat
        fMonVta(Almmmatg.MonVta) @ x-MonVta
        almmmatg.canemp @ Almmmatp.canemp
        Almmmatg.CtoTotMarco @ Almmmatp.CtoTot
        WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 B-table-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 5 */
DO:
  RUN Buscar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 B-table-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* Button 7 */
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
  DEF VAR k AS INT.
  REPEAT WHILE COMBO-BOX-Sublinea:NUM-ITEMS > 0:
    COMBO-BOX-Sublinea:DELETE(1).
  END.
  IF SELF:SCREEN-VALUE = 'Todos' THEN x-CodFam = ''.
  ELSE x-CodFam = ENTRY(1, SELF:SCREEN-VALUE, ' - ').
  x-SubFam = ''.
  COMBO-BOX-Sublinea:ADD-LAST('Todos').
  FOR EACH almsfami WHERE almsfami.codfam = x-codfam:
    COMBO-BOX-Sublinea:ADD-LAST(almsfami.subfam + ' - ' + AlmSFami.dessub).
  END.
  COMBO-BOX-Sublinea:SCREEN-VALUE = 'Todos'.

  SESSION:SET-WAIT-STATE("GENERAL").
  {&open-query-br_table}
  SESSION:SET-WAIT-STATE("").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Sublinea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Sublinea B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Sublinea IN FRAME F-Main /* Sublinea */
DO:
    ASSIGN {&self-name}.
    IF SELF:SCREEN-VALUE = 'Todos' THEN x-SubFam = ''.
    ELSE x-SubFam = ENTRY(1, SELF:SCREEN-VALUE , ' - ').

    SESSION:SET-WAIT-STATE("GENERAL").
    {&open-query-br_table}
    SESSION:SET-WAIT-STATE("").

    /*RUN dispatch IN THIS-PROCEDURE ('open-query':U).*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodMat B-table-Win
ON LEAVE OF FILL-IN-CodMat IN FRAME F-Main /* Buscar código */
DO:
    DEF VAR pCodMat AS CHAR NO-UNDO.
    pCodMat = SELF:SCREEN-VALUE.

    IF SELF:SCREEN-VALUE <> '' THEN DO:

        RUN vtagn/p-codbrr-01 (INPUT-OUTPUT pCodMat).
    END.
         
    SELF:SCREEN-VALUE = pCodMat.
    SELF:SENSITIVE = NO.
    IF pCodMat = '' THEN RETURN NO-APPLY.
    
    RUN local-busca.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Descuento_por_Volumen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Descuento_por_Volumen B-table-Win
ON CHOOSE OF MENU-ITEM m_Descuento_por_Volumen /* Descuento por Volumen */
DO:
IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN
      RUN pri/D-Marco-DtoVol ({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codmat).
      RUN dispatch IN THIS-PROCEDURE ('display-fields':U).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Descuento_Promocional
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Descuento_Promocional B-table-Win
ON CHOOSE OF MENU-ITEM m_Descuento_Promocional /* Descuento Promocional */
DO:
     IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN
      RUN VtaGn/D-DtoProm-Insti ({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codmat).
      RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt-codprov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-codprov B-table-Win
ON LEAVE OF txt-codprov IN FRAME F-Main /* Proveedor */
DO:
    ASSIGN 
        txt-codprov
        x-codpro = txt-codprov.
    FIND FIRST gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = txt-codprov NO-LOCK NO-ERROR.
    IF AVAIL gn-prov THEN DISPLAY gn-prov.nompro @ txt-desprov 
        WITH FRAME {&FRAME-NAME}.
    ELSE DISPLAY "" @ txt-desprov WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF Almmmatp.codmat, Almmmatp.PreOfi, Almmmatp.CanEmp
DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

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

IF COMBO-BOX-Linea = 'Todos' AND  
    TRUE <> (txt-CodProv > '') 
    THEN RETURN.

/* Actualizar el TC para productos que migran del OO */
DEF VAR LocalCuenta AS INTE NO-UNDO.
DEF BUFFER B-MATG FOR Almmmatg.

FOR EACH Almmmatp WHERE INTEGRAL.Almmmatp.CodCia = s-codcia NO-LOCK,
    FIRST Almmmatg OF Almmmatp WHERE Almmmatg.codfam BEGINS x-CodFam
        AND INTEGRAL.Almmmatg.subfam BEGINS x-SubFam
        AND LOOKUP(Almmmatg.codfam, s-LineasValidas) > 0
        AND Almmmatg.CodPr1 BEGINS x-codpro NO-LOCK,
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Buscar B-table-Win 
PROCEDURE Buscar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    FILL-IN-CodMat:SENSITIVE = YES.
    APPLY 'entry' TO FILL-IN-CodMat.

END.
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
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 4.
DEFINE VARIABLE t-Letra                 AS INTEGER.
DEFINE VARIABLE iInt                    AS INTEGER     NO-UNDO.

DEFINE VARIABLE cLetra  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLetra2 AS CHARACTER NO-UNDO.
DEFINE VARIABLE t-col   AS INTEGER     NO-UNDO.


/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A3"):Value = "Codigo".
chWorkSheet:Range("B3"):Value = "Descripcion".
chWorkSheet:Range("C3"):Value = "Marca".
chWorkSheet:Range("D3"):Value = "Familia".

chWorkSheet:Range("E3"):Value = "Moneda Costo".
chWorkSheet:Range("F3"):Value = "Costo Marco".
chWorkSheet:Range("G3"):Value = "Tpo Cambio Costo".
chWorkSheet:Range("H3"):Value = "Costo Total".

chWorkSheet:Range("I3"):Value = "Moneda".
chWorkSheet:Range("J3"):Value = "Tpo Cambio".
chWorkSheet:Range("K3"):Value = "Unidad".
chWorkSheet:Range("L3"):Value = "Precio Venta".
chWorkSheet:Range("M3"):Value = "Margen".
chWorkSheet:Range("N3"):Value = "Empaque".
chWorkSheet:Range("O3"):Value = "Unidad Bas".
chWorkSheet:Range("P3"):Value = "Dispon. Alm. 11".
chWorkSheet:Range("Q3"):Value = "Dispon. Alm. 11m".

/*Formato*/
chWorkSheet:Columns("A"):NumberFormat = "@".
chWorkSheet:Columns("D"):NumberFormat = "@".

DEF VAR s-StkComprometido AS DEC NO-UNDO.
t-column = 3.
GET FIRST {&BROWSE-NAME}.
REPEAT WHILE AVAILABLE Almmmatp:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatp.CodMat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatp.DesMat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatp.DesMar.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatp.CodFam.

    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.MonVta.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatp.CtoTot.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.TpoCmb.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.CtoTot.

    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatp.MonVta.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatp.TpoCmb.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatp.CHR__01.
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatp.PreOfi.
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatp.Dec__01.
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatp.CanEmp.
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.UndBas.
    FIND Almmmate WHERE Almmmate.codcia = Almmmatg.codcia
        AND Almmmate.codmat = Almmmatg.codmat
        AND Almmmate.codalm = '11'
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmate THEN DO:
        RUN vta2/Stock-Comprometido-v2 (Almmmate.codmat,
                                        Almmmate.codalm,
                                        OUTPUT s-StkComprometido).
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = Almmmate.stkact - s-StkComprometido.
    END.
    ELSE DO:
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = 0.
    END.
    FIND Almmmate WHERE Almmmate.codcia = Almmmatg.codcia
        AND Almmmate.codmat = Almmmatg.codmat
        AND Almmmate.codalm = '11m'
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmate THEN DO:
        RUN vta2/Stock-Comprometido-v2 (Almmmate.codmat,
                                        Almmmate.codalm,
                                        OUTPUT s-StkComprometido).
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = Almmmate.stkact - s-StkComprometido.
    END.
    ELSE DO:
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = 0.
    END.

    GET NEXT {&BROWSE-NAME}.
END.
/*
FOR EACH Almmmatp WHERE Almmmatp.codcia = s-codcia NO-LOCK,
    FIRST almmmatg WHERE almmmatg.codcia = Almmmatp.codcia
        AND almmmatg.codmat = Almmmatp.codmat NO-LOCK:

    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatp.CodMat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatp.DesMat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatp.DesMar.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatp.CodFam.

    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.MonVta.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatp.CtoTot.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.TpoCmb.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.CtoTot.

    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatp.MonVta.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatp.TpoCmb.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatp.CHR__01.
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatp.PreOfi.
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatp.Dec__01.
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatp.CanEmp.
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.UndBas.
    FIND Almmmate WHERE Almmmate.codcia = Almmmatg.codcia
        AND Almmmate.codmat = Almmmatg.codmat
        AND Almmmate.codalm = '11'
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmate THEN DO:
        RUN vta2/Stock-Comprometido-v2 (Almmmate.codmat,
                                        Almmmate.codalm,
                                        OUTPUT s-StkComprometido).
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = Almmmate.stkact - s-StkComprometido.
    END.
    ELSE DO:
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = 0.
    END.
    FIND Almmmate WHERE Almmmate.codcia = Almmmatg.codcia
        AND Almmmate.codmat = Almmmatg.codmat
        AND Almmmate.codalm = '11m'
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmate THEN DO:
        RUN vta2/Stock-Comprometido-v2 (Almmmate.codmat,
                                        Almmmate.codalm,
                                        OUTPUT s-StkComprometido).
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = Almmmate.stkact - s-StkComprometido.
    END.
    ELSE DO:
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = 0.
    END.
END.
*/

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.


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
  /*F-CodMat:SENSITIVE IN FRAME {&FRAME-NAME} = NO.*/
  IF s-acceso-total = NO THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.

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
  DEF VAR pMensaje AS CHAR NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
  IF RETURN-VALUE = "YES" 
      THEN ASSIGN
            Almmmatp.CodCia = s-codcia
            Almmmatp.FchIng = TODAY.
  ASSIGN
      Almmmatp.codfam = Almmmatg.codfam
      Almmmatp.DesMat = Almmmatg.desmat
      Almmmatp.DesMar = Almmmatg.desmar
      Almmmatp.subfam = Almmmatg.subfam
      Almmmatp.FchAct  = TODAY
      Almmmatp.usuario = s-user-id
      Almmmatp.monvta = Almmmatg.MonVta
      Almmmatp.tpocmb = Almmmatg.TpoCmb
      almmmatp.Chr__01 = Almmmatg.Chr__01
      .
  IF Almmmatp.CtoTot <> Almmmatg.CtoTotMarco THEN DO:
      FIND MATG OF Almmmatg EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
      IF ERROR-STATUS:ERROR = YES THEN DO:
          {lib/mensaje-de-error.i &MensajeError="pMensaje"}
          MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      ASSIGN
          MATG.CtoLisMarco = Almmmatg.CtoLisMarco / Almmmatg.CtoTotMarco * Almmmatp.CtoTot
          MATG.CtoTotMarco = Almmmatp.CtoTot.
      RELEASE MATG.
  END.

  DEF VAR f-Factor AS DEC INIT 1 NO-UNDO.
  
  FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
      AND Almtconv.Codalter = Almmmatp.Chr__01
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almtconv THEN DO:
      F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
  END.  
  ASSIGN
      Almmmatp.Dec__01 = ( (Almmmatp.PreOfi / (Almmmatp.Ctotot * f-Factor) ) - 1 ) * 100. 
  RUN dispatch IN THIS-PROCEDURE ('display-fields').
  s-local-adm-record = NO.

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
      FIND FIRST Almmmatp WHERE Almmmatp.codcia = s-codcia
          AND Almmmatp.codmat = FILL-IN-CodMat:SCREEN-VALUE IN FRAME {&FRAME-NAME}
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almmmatp THEN DO:
          output-var-1 = ROWID(Almmmatp).
      END.      
      
      IF OUTPUT-VAR-1 <> ? THEN DO:
           FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
                ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
                NO-LOCK NO-ERROR.
           IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
              REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1 NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN DO:
                    MESSAGE "El codigo de articulo " fill-in-codmat:SCREEN-VALUE " no se ubica en la lista de los productos en la pantalla" SKIP                
                            "Verifique si tiene asignado el perfil de jefe de linea y que lineas de productos tiene asignado"                            .
                END.
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

  /* Code placed here will execute PRIOR to standard behavior. */
  IF s-acceso-total = NO THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.

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
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          BUTTON-5:SENSITIVE = YES
          BUTTON-7:SENSITIVE = YES
          COMBO-BOX-Linea:SENSITIVE = YES
          COMBO-BOX-Sublinea:SENSITIVE = YES
          FILL-IN-CodMat:SENSITIVE = YES
          txt-codprov:SENSITIVE = YES.
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
          BUTTON-5:SENSITIVE = NO
          BUTTON-7:SENSITIVE = NO
          COMBO-BOX-Linea:SENSITIVE = NO
          COMBO-BOX-Sublinea:SENSITIVE = NO
          FILL-IN-CodMat:SENSITIVE = NO
          txt-codprov:SENSITIVE = NO.
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'YES' THEN Almmmatp.codmat:READ-ONLY IN BROWSE {&browse-name} = NO.
      ELSE Almmmatp.codmat:READ-ONLY IN BROWSE {&browse-name} = YES.
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
          AND (s-user-id = "ADMIN" OR Vtatabla.llave_c1 = s-user-id),
          FIRST Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia
          AND Almtfami.codfam = Vtatabla.llave_c2:
          COMBO-BOX-Linea:ADD-LAST( Almtfami.codfam + ' - ' + Almtfami.desfam).

          s-LineasValidas = s-LineasValidas + (IF TRUE <> (s-LineasValidas > '') THEN '' ELSE ',') +
              Almtfami.codfam.

      END.
/*       FOR EACH almtfami NO-LOCK:                                               */
/*           COMBO-BOX-Linea:ADD-LAST(almtfami.codfam + ' - ' + Almtfami.desfam). */
/*       END.                                                                     */
  END.

  SESSION:SET-WAIT-STATE("GENERAL").
  {&open-query-br_table}
  SESSION:SET-WAIT-STATE("").

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
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

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
  {src/adm/template/snd-list.i "Almmmatp"}
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
     APPLY 'entry' TO Almmmatp.PreOfi IN BROWSE {&browse-name}.
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
    AND Almmmatg.codmat = Almmmatp.codmat:SCREEN-VALUE IN BROWSE {&browse-name} 
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
    MESSAGE 'Código del producto NO registrado'
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO Almmmatp.codmat IN BROWSE {&browse-name}.
    RETURN "ADM-ERROR".
END.
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = Almmmatg.Chr__01
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    MESSAGE "Equivalencia NO definida" SKIP
        "Unidad base :" Almmmatg.undbas SKIP
        "Unidad venta:" Almmmatp.Chr__01
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO Almmmatp.codmat IN BROWSE {&browse-name}.
    RETURN "ADM-ERROR".
END.
IF DECIMAL (Almmmatp.PreOfi:SCREEN-VALUE IN BROWSE {&Browse-name}) = 0 THEN DO:
    MESSAGE 'Debe ingresar el precio de venta'
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO Almmmatp.PreOfi IN BROWSE {&browse-name}.
    RETURN "ADM-ERROR".
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

  IF s-acceso-total = NO THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.

s-local-adm-record = YES.
/*F-CodMat:SENSITIVE IN FRAME {&FRAME-NAME} = NO.*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCtoUni B-table-Win 
FUNCTION fCtoUni RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

IF NOT AVAILABLE Almmmatg THEN RETURN 0.

  IF Almmmatg.MonVta = 1 THEN RETURN Almmmatg.CtoTot.
  IF Almmmatg.MonVta = 2 THEN RETURN Almmmatg.CtoTot * Almmmatg.tpocmb.
  RETURN 0.00.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fImpCto B-table-Win 
FUNCTION fImpCto RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

IF NOT AVAILABLE Almmmatg THEN RETURN 0.
  IF Almmmatg.MonVta = 1 THEN RETURN Almmmatg.CtoTot.
  IF Almmmatg.MonVta = 2 THEN RETURN Almmmatg.CtoTot * Almmmatg.TpoCmb.
  RETURN 0.00.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fMonVta B-table-Win 
FUNCTION fMonVta RETURNS CHARACTER
  ( INPUT pMonVta AS INTE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF pMonVta = 1 THEN RETURN "S/.".
  IF pMonVta = 2 THEN RETURN "US$".
  RETURN "???".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

