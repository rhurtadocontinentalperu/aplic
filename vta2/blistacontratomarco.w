&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-MATG NO-UNDO LIKE Almmmatp.



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
DEF VAR x-CtoTot AS DEC NO-UNDO.    /* Valores para calculo del costo */
DEF VAR x-MonCto AS INT NO-UNDO.

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
&Scoped-define INTERNAL-TABLES T-MATG Almmmatp Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-MATG.codmat Almmmatg.DesMat ~
Almmmatg.UndStk Almmmatg.TpoCmb Almmmatg.DesMar T-MATG.CtoTot ~
T-MATG.Chr__01 T-MATG.Dec__01 T-MATG.PreOfi T-MATG.CanEmp 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table T-MATG.codmat ~
T-MATG.Chr__01 T-MATG.PreOfi T-MATG.CanEmp 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table T-MATG
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table T-MATG
&Scoped-define QUERY-STRING-br_table FOR EACH T-MATG WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatp OF T-MATG NO-LOCK, ~
      FIRST Almmmatg OF T-MATG NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-MATG WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatp OF T-MATG NO-LOCK, ~
      FIRST Almmmatg OF T-MATG NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table T-MATG Almmmatp Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-MATG
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatp
&Scoped-define THIRD-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Linea BUTTON-8 COMBO-BOX-Sublinea ~
FILL-IN-CodMat FILL-IN-CodPro FILL-IN-DesMat br_table 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Linea COMBO-BOX-Sublinea ~
FILL-IN-CodMat FILL-IN-CodPro FILL-IN-NomPro FILL-IN-DesMat 

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
       MENU-ITEM m_Descuento_Promocional LABEL "Descuento Promocional".


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-8 
     LABEL "APLICAR FILTRO" 
     SIZE 18 BY 1.12
     FONT 6.

DEFINE VARIABLE COMBO-BOX-Linea AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Linea" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "TODAS" 
     DROP-DOWN-LIST
     SIZE 55 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Sublinea AS CHARACTER FORMAT "X(256)":U INITIAL "TODAS" 
     LABEL "Sublinea" 
     VIEW-AS COMBO-BOX INNER-LINES 5
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
      Almmmatp, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-MATG.codmat COLUMN-LABEL "Articulo" FORMAT "X(13)":U WIDTH 6.43
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 60
      Almmmatg.UndStk COLUMN-LABEL "Unidad" FORMAT "X(6)":U
      Almmmatg.TpoCmb COLUMN-LABEL "TC" FORMAT "Z9.9999":U
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U
      T-MATG.CtoTot COLUMN-LABEL "Costo MARCO!S/." FORMAT ">>>,>>9.9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      T-MATG.Chr__01 COLUMN-LABEL "UM" FORMAT "X(6)":U COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      T-MATG.Dec__01 COLUMN-LABEL "% Uti" FORMAT "->>,>>9.9999":U
      T-MATG.PreOfi COLUMN-LABEL "Precio MARCO!S/." FORMAT ">>>,>>9.99999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      T-MATG.CanEmp COLUMN-LABEL "Empaque" FORMAT ">,>>9":U COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
  ENABLE
      T-MATG.codmat
      T-MATG.Chr__01
      T-MATG.PreOfi
      T-MATG.CanEmp
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 142 BY 19.62
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Linea AT ROW 1.19 COL 12 COLON-ALIGNED WIDGET-ID 22
     BUTTON-8 AT ROW 1.19 COL 124 WIDGET-ID 20
     COMBO-BOX-Sublinea AT ROW 2.15 COL 12 COLON-ALIGNED WIDGET-ID 24
     FILL-IN-CodMat AT ROW 2.15 COL 79 COLON-ALIGNED WIDGET-ID 18
     FILL-IN-CodPro AT ROW 3.12 COL 12 COLON-ALIGNED WIDGET-ID 26
     FILL-IN-NomPro AT ROW 3.12 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     FILL-IN-DesMat AT ROW 3.12 COL 79 COLON-ALIGNED WIDGET-ID 28
     br_table AT ROW 4.27 COL 1
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
      TABLE: T-MATG T "?" NO-UNDO INTEGRAL Almmmatp
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
         HEIGHT             = 23.04
         WIDTH              = 142.
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
     _TblList          = "Temp-Tables.T-MATG,INTEGRAL.Almmmatp OF Temp-Tables.T-MATG,INTEGRAL.Almmmatg OF Temp-Tables.T-MATG"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST, FIRST"
     _FldNameList[1]   > Temp-Tables.T-MATG.codmat
"Temp-Tables.T-MATG.codmat" "Articulo" "X(13)" "character" 14 0 ? ? ? ? yes ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"INTEGRAL.Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "60" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.UndStk
"INTEGRAL.Almmmatg.UndStk" "Unidad" "X(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.TpoCmb
"INTEGRAL.Almmmatg.TpoCmb" "TC" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.Almmmatg.DesMar
"INTEGRAL.Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-MATG.CtoTot
"Temp-Tables.T-MATG.CtoTot" "Costo MARCO!S/." ">>>,>>9.9999" "decimal" 14 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-MATG.Chr__01
"Temp-Tables.T-MATG.Chr__01" "UM" "X(6)" "character" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-MATG.Dec__01
"Temp-Tables.T-MATG.Dec__01" "% Uti" "->>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-MATG.PreOfi
"Temp-Tables.T-MATG.PreOfi" "Precio MARCO!S/." ">>>,>>9.99999" "decimal" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.T-MATG.CanEmp
"Temp-Tables.T-MATG.CanEmp" "Empaque" ">,>>9" "decimal" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
    x-CtoTot = Almmmatg.CtoTotMarco.
    IF Almmmatg.DEC__02 = 2 THEN x-CtoTot = Almmmatg.CtoTotMarco * Almmmatg.TpoCmb.
    DISPLAY
        Almmmatg.tpocmb
        Almmmatg.desmat
        Almmmatg.desmar
        Almmmatg.undstk
        x-CtoTot @  T-MATG.CtoTot
        WITH BROWSE {&browse-name}.

    /* VALORES POR DEFECTO */
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' THEN DO:
        DISPLAY
            Almmmatg.CHR__01 @ T-MATG.Chr__01
            WITH BROWSE {&browse-name}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.Chr__01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.Chr__01 br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-MATG.Chr__01 IN BROWSE br_table /* UM */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.Dec__01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.Dec__01 br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-MATG.Dec__01 IN BROWSE br_table /* % Uti */
DO:
    ASSIGN
        F-MrgUti = DECIMAL(T-MATG.DEC__01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
        X-CTOUND = DECIMAL(T-MATG.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
    F-FACTOR = 1.
    F-PreVta = 0.
    /****   Busca el Factor de conversion   ****/
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
        AND  Almtconv.Codalter = T-MATG.CHR__01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    F-FACTOR = Almtconv.Equival.
    F-PreVta = ROUND(( X-CTOUND * (1 + F-MrgUti / 100) ), 6) * F-FACTOR.
    DISPLAY F-PreVta @ T-MATG.PreOfi WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.PreOfi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.PreOfi br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-MATG.PreOfi IN BROWSE br_table /* Precio MARCO!S/. */
DO:
    ASSIGN
        F-PreVta = DECIMAL(T-MATG.PreOfi:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
        X-CTOUND = DECIMAL(T-MATG.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
    F-FACTOR = 1.
    F-MrgUti = 0.    
    /****   Busca el Factor de conversion   ****/
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
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
   RUN Carga-Temporal.
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
    FIND Almmmatp WHERE Almmmatp.codcia = s-codcia
        AND Almmmatp.codmat = pCodMat
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatp THEN DO:
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


&Scoped-define SELF-NAME m_Descuento_Promocional
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Descuento_Promocional B-table-Win
ON CHOOSE OF MENU-ITEM m_Descuento_Promocional /* Descuento Promocional */
DO:
    IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN
     RUN vta2/d-contratomarco-dtoprom ({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codmat).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF T-MATG.CodMat, T-MATG.Chr__01, T-MATG.PreOfi, T-MATG.CtoTot, T-MATG.DEC__01
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
    AND Almmmatg.codMat = FILL-IN-CodMat
    NO-LOCK NO-ERROR.
FIND FIRST Almmmatp WHERE Almmmatp.codcia = s-codcia
    AND Almmmatp.codmat = FILL-IN-CodMat
    NO-LOCK NO-ERROR.
IF FILL-IN-CodMat <> '' AND AVAILABLE Almmmatg AND AVAILABLE Almmmatp THEN DO:
    ASSIGN
        x-MonCto = (IF Almmmatg.CtoTotMarco > 0 THEN Almmmatg.DEC__02 ELSE Almmmatg.MonVta)
        x-CtoTot = (IF Almmmatg.CtoTotMarco > 0 THEN Almmmatg.CtoTotMarco ELSE Almmmatg.CtoTot).
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
        T-MATG.MonVta = Almmmatp.MonVta
        T-MATG.CtoTot = x-CtoTot
        T-MATG.PreOfi = Almmmatp.PreOfi
        T-MATG.CHR__01 = Almmmatp.CHR__01
        T-MATG.DEC__01 = Almmmatp.DEC__01
        T-MATG.CanEmp = Almmmatp.CanEmp.
    IF Almmmatp.MonVta <> x-MonCto THEN
        IF Almmmatp.MonVta = 1 THEN T-MATG.CtoTot = x-CtoTot * Almmmatg.TpoCmb.
        ELSE T-MATG.CtoTot = x-CtoTot / Almmmatg.TpoCmb.
END.
ELSE DO:
    FOR EACH Almmmatp NO-LOCK WHERE Almmmatp.codcia = s-codcia,
        FIRST Almmmatg OF Almmmatp NO-LOCK WHERE {&Condicion}:
        ASSIGN
            x-MonCto = (IF Almmmatg.CtoTotMarco > 0 THEN Almmmatg.DEC__02 ELSE Almmmatg.MonVta)
            x-CtoTot = (IF Almmmatg.CtoTotMarco > 0 THEN Almmmatg.CtoTotMarco ELSE Almmmatg.CtoTot).
        CREATE T-MATG.
        BUFFER-COPY Almmmatg
            TO T-MATG
            ASSIGN
            T-MATG.MonVta = Almmmatp.MonVta
            T-MATG.CtoTot = x-CtoTot
            T-MATG.PreOfi = Almmmatp.PreOfi
            T-MATG.CHR__01 = Almmmatp.CHR__01
            T-MATG.DEC__01 = Almmmatp.DEC__01
            T-MATG.CanEmp = Almmmatp.CanEmp.
        IF Almmmatp.MonVta <> x-MonCto THEN
            IF Almmmatp.MonVta = 1 THEN T-MATG.CtoTot = x-CtoTot * Almmmatg.TpoCmb.
            ELSE T-MATG.CtoTot = x-CtoTot / Almmmatg.TpoCmb.
    END.
END.

/* TODOS LOS PRECIOS EN SOLES */
FOR EACH T-MATG, FIRST Almmmatg OF T-MATG NO-LOCK:
    IF T-MATG.MonVta = 2 THEN
        ASSIGN
        T-MATG.MonVta = 1   /* Siempre en Soles */
        T-MATG.CtoTot = T-MATG.CtoTot * T-MATG.TpoCmb
        T-MATG.PreOfi = T-MATG.PreOfi * T-MATG.TpoCmb.
    /* Calculamos el margen */
    f-Factor = 1.
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
        AND Almtconv.Codalter = T-MATG.Chr__01
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN DO:
        F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
    END.  
    ASSIGN
        T-MATG.Dec__01 = ( (T-MATG.PreOfi / (T-MATG.CtoTot * f-Factor) ) - 1 ) * 100. 
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
  DEF VAR f-Factor AS DEC NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
  IF RETURN-VALUE = "YES" THEN DO:
      ASSIGN
          T-MATG.CodCia = s-codcia.
      CREATE Almmmatp.
      ASSIGN
          Almmmatp.CodCia = s-codcia
          Almmmatp.codmat = T-MATG.codmat.
  END.
  ELSE DO:
      FIND CURRENT Almmmatp EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
      IF ERROR-STATUS:ERROR THEN DO:
           RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
           UNDO, RETURN 'ADM-ERROR'.
      END.
  END.
  ASSIGN
      Almmmatp.TpoCmb = Almmmatg.TpoCmb
      Almmmatp.MonVta = 1   /* Simepre en Soles */
      Almmmatp.FchAct = TODAY
      Almmmatp.PreOfi  = T-MATG.PreOfi
      Almmmatp.CHR__01 = T-MATG.CHR__01
      Almmmatp.CanEmp = T-MATG.CanEmp
      Almmmatp.usuario = s-user-id.
  /* MARGEN */
  IF Almmmatg.DEC__02 = Almmmatp.MonVta THEN x-CtoTot = Almmmatg.CtoTotMarco.
  ELSE IF Almmmatg.DEC__02 = 2 THEN x-CtoTot = Almmmatg.CtoTotMarco *  Almmmatg.tpocmb.
  ELSE x-CtoTot = Almmmatg.CtoTotMarco /  Almmmatg.tpocmb.
  FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
      AND Almtconv.Codalter = Almmmatp.Chr__01
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
  ASSIGN
      T-MATG.CtoTot = x-CtoTot
      Almmmatp.Dec__01 = ( (Almmmatp.PreOfi / (x-Ctotot * f-Factor) ) - 1 ) * 100
      T-MATG.Dec__01 = Almmmatp.Dec__01.

  FIND CURRENT Almmmatp NO-LOCK NO-ERROR.

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
    FIND CURRENT Almmmatp EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR THEN DO:
         RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
         RETURN 'ADM-ERROR'.
    END.
    DELETE Almmmatp.

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
/*       FOR EACH Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia:              */
/*           COMBO-BOX-Linea:ADD-LAST(Almtfami.codfam + " - " + Almtfami.desfam). */
/*       END.                                                                     */
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
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

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
  {src/adm/template/snd-list.i "T-MATG"}
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

FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = T-MATG.Chr__01:SCREEN-VALUE IN BROWSE {&browse-name}
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    MESSAGE "Equivalencia NO definida" SKIP
        "Unidad base :" Almmmatg.undbas SKIP
        "Unidad venta:" T-MATG.Chr__01:SCREEN-VALUE IN BROWSE {&browse-name}
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO T-MATG.CHR__01 IN BROWSE {&browse-name}.
    RETURN "ADM-ERROR".
END.
IF DECIMAL (T-MATG.PreOfi:SCREEN-VALUE IN BROWSE {&Browse-name}) = 0 THEN DO:
    MESSAGE 'Debe ingresar el precio de venta'
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO T-MATG.PreOfi IN BROWSE {&browse-name}.
    RETURN "ADM-ERROR".
END.

DEF VAR pMargen AS DEC NO-UNDO.
DEF VAR pLimite AS DEC NO-UNDO.
DEF VAR pError AS CHAR NO-UNDO.

RUN vtagn\p-margen-utilidad-marco (
     T-MATG.codmat:SCREEN-VALUE IN BROWSE {&browse-name},
     DECIMAL (T-MATG.PreOfi:SCREEN-VALUE IN BROWSE {&Browse-name}),
     T-MATG.Chr__01:SCREEN-VALUE IN BROWSE {&browse-name},
     1,         /* Siempre en soles */
     Almmmatg.TpoCmb,
     TRUE,      /* Mostrar el error */
     "",        /* Almacen */
     OUTPUT pMargen,
     OUTPUT pLimite,
     OUTPUT pError
     ).
IF pError = "ADM-ERROR" THEN DO:
    APPLY 'entry' TO T-MATG.PreOfi IN BROWSE {&browse-name}.
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

