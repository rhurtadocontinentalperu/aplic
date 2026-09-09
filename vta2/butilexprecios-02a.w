&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE T-MATG LIKE Almmmatg.



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

DEF VAR x-Mon AS CHAR NO-UNDO.

DEFINE VARIABLE MaxCat LIKE ClfClie.PorDsc.
DEFINE VARIABLE MaxVta LIKE Dsctos.PorDto.
DEFINE VARIABLE F-FACTOR     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE F-MrgUti-A AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-MrgUti-B AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-MrgUti-C AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PreVta-A AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PreVta-B AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PreVta-C AS DECIMAL NO-UNDO.
DEFINE VARIABLE X-CTOUND AS DECIMAL NO-UNDO.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

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
&Scoped-define INTERNAL-TABLES T-MATG

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-MATG.codmat T-MATG.DesMat ~
T-MATG.UndBas IF (T-MATG.MonVta = 1) THEN ('S/.') ELSE ('US$') @ x-Mon ~
T-MATG.TpoCmb T-MATG.DesMar T-MATG.CtoTot T-MATG.Prevta[1] T-MATG.MrgUti-A ~
T-MATG.Prevta[2] T-MATG.UndA T-MATG.MrgUti-B T-MATG.Prevta[3] T-MATG.UndB ~
T-MATG.MrgUti-C T-MATG.Prevta[4] T-MATG.UndC T-MATG.Dec__01 T-MATG.PreOfi ~
T-MATG.Chr__01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table T-MATG.Prevta[1] ~
T-MATG.MrgUti-A T-MATG.Prevta[2] T-MATG.MrgUti-B T-MATG.Prevta[3] ~
T-MATG.MrgUti-C T-MATG.Prevta[4] 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table T-MATG
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table T-MATG
&Scoped-define QUERY-STRING-br_table FOR EACH T-MATG WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-MATG WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table T-MATG
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-MATG


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


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-MATG SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-MATG.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U WIDTH 5.43
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      T-MATG.DesMat FORMAT "X(60)":U WIDTH 56.43
      T-MATG.UndBas COLUMN-LABEL "Unidad" FORMAT "X(6)":U WIDTH 8.43
      IF (T-MATG.MonVta = 1) THEN ('S/.') ELSE ('US$') @ x-Mon COLUMN-LABEL "Moneda" FORMAT "x(3)":U
      T-MATG.TpoCmb COLUMN-LABEL "TC" FORMAT "Z9.9999":U
      T-MATG.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U
      T-MATG.CtoTot COLUMN-LABEL "Costo Total!S/." FORMAT ">>>>,>>9.9999":U
            WIDTH 13.86 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      T-MATG.Prevta[1] COLUMN-LABEL "Precio Lista!S/." FORMAT ">>,>>>,>>9.9999":U
            WIDTH 8.72 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      T-MATG.MrgUti-A COLUMN-LABEL "% Uti A" FORMAT "->>,>>9.99":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      T-MATG.Prevta[2] COLUMN-LABEL "Precio A!S/." FORMAT ">>>,>>9.9999":U
            WIDTH 8.72 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      T-MATG.UndA COLUMN-LABEL "UM A" FORMAT "X(6)":U WIDTH 4 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      T-MATG.MrgUti-B COLUMN-LABEL "% Uti B" FORMAT "->>,>>9.99":U
            WIDTH 5.43 COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 13
      T-MATG.Prevta[3] COLUMN-LABEL "Precio B!S/." FORMAT ">>>,>>9.9999":U
            WIDTH 8.43 COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 13
      T-MATG.UndB COLUMN-LABEL "UM B" FORMAT "X(6)":U WIDTH 4.43
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 13
      T-MATG.MrgUti-C COLUMN-LABEL "% Uti C" FORMAT "->>,>>9.99":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 1
      T-MATG.Prevta[4] COLUMN-LABEL "Precio C!S/." FORMAT ">>>,>>9.9999":U
            WIDTH 8.57 COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 1
      T-MATG.UndC COLUMN-LABEL "UM C" FORMAT "X(6)":U WIDTH 4.29
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 1
      T-MATG.Dec__01 COLUMN-LABEL "% Uti Ofi" FORMAT "->>,>>9.99":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 12
      T-MATG.PreOfi COLUMN-LABEL "Precio Oficina!S/." FORMAT ">>>,>>9.9999":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 12
      T-MATG.Chr__01 COLUMN-LABEL "UM Ofic" FORMAT "X(6)":U COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 12
  ENABLE
      T-MATG.Prevta[1]
      T-MATG.MrgUti-A
      T-MATG.Prevta[2]
      T-MATG.MrgUti-B
      T-MATG.Prevta[3]
      T-MATG.MrgUti-C
      T-MATG.Prevta[4]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 140 BY 16.35
         FONT 4
         TITLE "LISTA MAYORISTA - CONTINENTAL".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
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
      TABLE: T-MATG T "SHARED" ? INTEGRAL Almmmatg
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
         HEIGHT             = 17.27
         WIDTH              = 140.72.
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
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 6.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.T-MATG"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > Temp-Tables.T-MATG.codmat
"T-MATG.codmat" "Articulo" ? "character" 14 0 ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-MATG.DesMat
"T-MATG.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "56.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-MATG.UndBas
"T-MATG.UndBas" "Unidad" "X(6)" "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"IF (T-MATG.MonVta = 1) THEN ('S/.') ELSE ('US$') @ x-Mon" "Moneda" "x(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-MATG.TpoCmb
"T-MATG.TpoCmb" "TC" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-MATG.DesMar
"T-MATG.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-MATG.CtoTot
"T-MATG.CtoTot" "Costo Total!S/." ">>>>,>>9.9999" "decimal" 14 0 ? ? ? ? no ? no no "13.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-MATG.Prevta[1]
"T-MATG.Prevta[1]" "Precio Lista!S/." ? "decimal" 14 0 ? ? ? ? yes ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-MATG.MrgUti-A
"T-MATG.MrgUti-A" "% Uti A" ? "decimal" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.T-MATG.Prevta[2]
"T-MATG.Prevta[2]" "Precio A!S/." ">>>,>>9.9999" "decimal" 11 0 ? ? ? ? yes ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.T-MATG.UndA
"T-MATG.UndA" "UM A" "X(6)" "character" 11 0 ? ? ? ? no ? no no "4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.T-MATG.MrgUti-B
"T-MATG.MrgUti-B" "% Uti B" ? "decimal" 13 15 ? ? ? ? yes ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.T-MATG.Prevta[3]
"T-MATG.Prevta[3]" "Precio B!S/." ">>>,>>9.9999" "decimal" 13 15 ? ? ? ? yes ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.T-MATG.UndB
"T-MATG.UndB" "UM B" "X(6)" "character" 13 15 ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.T-MATG.MrgUti-C
"T-MATG.MrgUti-C" "% Uti C" ? "decimal" 1 15 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.T-MATG.Prevta[4]
"T-MATG.Prevta[4]" "Precio C!S/." ">>>,>>9.9999" "decimal" 1 15 ? ? ? ? yes ? no no "8.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.T-MATG.UndC
"T-MATG.UndC" "UM C" "X(6)" "character" 1 15 ? ? ? ? no ? no no "4.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.T-MATG.Dec__01
"T-MATG.Dec__01" "% Uti Ofi" "->>,>>9.99" "decimal" 12 15 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > Temp-Tables.T-MATG.PreOfi
"T-MATG.PreOfi" "Precio Oficina!S/." ">>>,>>9.9999" "decimal" 12 15 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > Temp-Tables.T-MATG.Chr__01
"T-MATG.Chr__01" "UM Ofic" "X(6)" "character" 12 15 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* LISTA MAYORISTA - CONTINENTAL */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* LISTA MAYORISTA - CONTINENTAL */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* LISTA MAYORISTA - CONTINENTAL */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.Prevta[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.Prevta[1] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-MATG.Prevta[1] IN BROWSE br_table /* Precio Lista!S/. */
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
            MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
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
ON LEAVE OF T-MATG.Prevta[2] IN BROWSE br_table /* Precio A!S/. */
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
            MESSAGE "Codigo de unidad no exixte" VIEW-AS ALERT-BOX ERROR.
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
     F-PreVta-B = 0.
     /****   Busca el Factor de conversion   ****/
     IF T-MATG.UndB <> "" THEN DO:
         FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas
                        AND  Almtconv.Codalter = T-MATG.UndB
                       NO-LOCK NO-ERROR.
         IF NOT AVAILABLE Almtconv THEN DO:
            MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
         END.
         F-FACTOR = Almtconv.Equival.
         F-PreVta-B = ROUND(( X-CTOUND * (1 + F-MrgUti-B / 100) ), 6) * F-FACTOR.
     END.

    DISPLAY F-PreVta-B @ Prevta[3] WITH BROWSE {&BROWSE-NAME}.
    RUN Precio-de-Oficina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.Prevta[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.Prevta[3] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-MATG.Prevta[3] IN BROWSE br_table /* Precio B!S/. */
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
            MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
         END.
         F-FACTOR = Almtconv.Equival.
         F-MrgUti-B = ROUND(((((F-PreVta-B / F-FACTOR) / X-CTOUND) - 1) * 100), 6).
     END.
     /*******************************************/
     DISPLAY F-MrgUti-B @ T-MATG.MrgUti-B WITH BROWSE {&BROWSE-NAME}.
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
            MESSAGE "Codigo de unidad no exixte" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
         END.
         F-FACTOR = Almtconv.Equival.
         F-PreVta-C = ROUND(( X-CTOUND * (1 + F-MrgUti-C / 100) ), 6) * F-FACTOR.
     END.

    DISPLAY F-PreVta-C @ Prevta[4] WITH BROWSE {&BROWSE-NAME}.
    RUN Precio-de-Oficina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.Prevta[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.Prevta[4] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-MATG.Prevta[4] IN BROWSE br_table /* Precio C!S/. */
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
            MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
         END.
         F-FACTOR = Almtconv.Equival.
         F-MrgUti-C = ROUND(((((F-PreVta-C / F-FACTOR) / X-CTOUND) - 1) * 100), 6).
     END.
     /*******************************************/
     DISPLAY F-MrgUti-C @ T-MATG.MrgUti-C WITH BROWSE {&BROWSE-NAME}.
     RUN Precio-de-Oficina.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE F-PreAnt LIKE T-MATG.PreBas  NO-UNDO.
  IF AVAILABLE T-MATG THEN F-PreAnt = T-MATG.PreBas.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      T-MATG.PreVta[1] = DEC(T-MATG.PreVta[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) 
      T-MATG.MrgUti-A  = DECIMAL(T-MATG.MrgUti-A:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      T-MATG.Prevta[2] = DECIMAL(T-MATG.Prevta[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      T-MATG.MrgUti-B  = DECIMAL(T-MATG.MrgUti-B:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      T-MATG.PreVta[3] = DECIMAL(T-MATG.Prevta[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      T-MATG.MrgUti-C  = DECIMAL(T-MATG.MrgUti-C:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      T-MATG.PreVta[4] = DECIMAL(T-MATG.Prevta[4]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      T-MATG.Dec__01 = DEC(T-MATG.Dec__01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      T-MATG.PreOfi = DEC(T-MATG.PreOfi:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).

/*   IF F-PreAnt <> T-MATG.PreBas THEN T-MATG.FchmPre[3] = TODAY. */
/*   T-MATG.FchmPre[1] = TODAY.                                   */
/*   T-MATG.Usuario = S-USER-ID.                                  */
/*   T-MATG.FchAct  = TODAY.                                      */
  
  /* **************************************************************** */
  {vta2/iutilexprecios-02.i}
  /* **************************************************************** */

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

DEFINE VARIABLE fmot LIKE T-MATG.PreOfi.
DEFINE VARIABLE pre-ofi LIKE T-MATG.PreOfi.
DEFINE VARIABLE MrgMin LIKE T-MATG.MrgUti-A.
DEFINE VARIABLE MrgOfi LIKE T-MATG.MrgUti-A.

{vta2/precio-de-oficina-tiendas.i}

/* MaxCat = 0.                                                                                                 */
/* MaxVta = 0.                                                                                                 */
/* fmot   = 0.                                                                                                 */
/*                                                                                                             */
/* MrgMin = 5000.                                                                                              */
/* MrgOfi = 0.                                                                                                 */
/* F-FACTOR = 1.                                                                                               */
/* MaxCat = 4.                                                                                                 */
/* MaxVta = 3.                                                                                                 */
/*                                                                                                             */
/* ASSIGN                                                                                                      */
/*     F-MrgUti-A = DECIMAL(T-MATG.MrgUti-A:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})                             */
/*     F-PreVta-A = DECIMAL(T-MATG.Prevta[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})                            */
/*     F-MrgUti-B = DECIMAL(T-MATG.MrgUti-B:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})                             */
/*     F-PreVta-B = DECIMAL(T-MATG.Prevta[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})                            */
/*     F-MrgUti-C = DECIMAL(T-MATG.MrgUti-C:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})                             */
/*     F-PreVta-C = DECIMAL(T-MATG.Prevta[4]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).                           */
/*                                                                                                             */
/* X-CTOUND = DECIMAL(T-MATG.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).                                    */
/* /****   Busca el Factor de conversion   ****/                                                               */
/* IF T-MATG.Chr__01 <> "" THEN DO:                                                                            */
/*     FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas                                                    */
/*                    AND  Almtconv.Codalter = T-MATG.Chr__01                                                  */
/*                   NO-LOCK NO-ERROR.                                                                         */
/*     IF NOT AVAILABLE Almtconv THEN DO:                                                                      */
/*        MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.                                        */
/*        RETURN NO-APPLY.                                                                                     */
/*     END.                                                                                                    */
/*     F-FACTOR = Almtconv.Equival.                                                                            */
/* END.                                                                                                        */
/* /*******************************************/                                                               */
/* /* **********************************************************************                                   */
/*     NOTA IMPORTANTE: Cualquier cambio debe hacerse también                                                  */
/*                     en LOGISTICA -> LIsta de precios por proveedor                                          */
/* ************************************************************************* */                                */
/* CASE T-MATG.Chr__02 :                                                                                       */
/*     WHEN "T" THEN DO:                                                                                       */
/*         /*  TERCEROS  */                                                                                    */
/*         IF F-MrgUti-A < MrgMin AND F-MrgUti-A <> 0 THEN MrgMin = F-MrgUti-A.                                */
/*         IF F-MrgUti-B < MrgMin AND F-MrgUti-B <> 0 THEN MrgMin = F-MrgUti-B.                                */
/*         IF F-MrgUti-C < MrgMin AND F-MrgUti-C <> 0 THEN MrgMin = F-MrgUti-C.                                */
/*         fmot = (1 + MrgMin / 100) / ((1 - MaxCat / 100) * (1 - MaxVta / 100)).                              */
/*         pre-ofi = X-CTOUND * fmot * F-FACTOR .                                                              */
/*         MrgOfi = ROUND((fmot - 1) * 100, 6).                                                                */
/*     END.                                                                                                    */
/*     WHEN "P" THEN DO:                                                                                       */
/*         /* PROPIOS */                                                                                       */
/*        pre-ofi = DECIMAL(T-MATG.Prevta[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) * F-FACTOR.                */
/*        MrgOfi = ((DECIMAL(T-MATG.Prevta[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) / x-CtoUnd ) - 1 ) * 100. */
/*     END.                                                                                                    */
/* END.                                                                                                        */
/* DO WITH FRAME {&FRAME-NAME}:                                                                                */
/*     DISPLAY                                                                                                 */
/*         MrgOfi @ T-MATG.Dec__01                                                                             */
/*         pre-ofi @ T-MATG.PreOfi                                                                             */
/*         WITH BROWSE {&BROWSE-NAME}.                                                                         */
/* END.                                                                                                        */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular B-table-Win 
PROCEDURE Recalcular :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE fmot LIKE T-MATG.PreOfi.
DEFINE VARIABLE pre-ofi LIKE T-MATG.PreOfi.
DEFINE VARIABLE MrgMin LIKE T-MATG.MrgUti-A.
DEFINE VARIABLE MrgOfi LIKE T-MATG.MrgUti-A.

MaxCat = 0.
MaxVta = 0.
fmot   = 0.

MrgMin = 5000.
MrgOfi = 0.
F-FACTOR = 1.
MaxCat = 4.
MaxVta = 3.

FOR EACH T-MATG:
    /* **************************************************************** */
    {vta2/iutilexprecios-02.i}
    /* **************************************************************** */

    ASSIGN
        fmot   = 0
        MrgMin = 5000
        MrgOfi = 0
        F-FACTOR = 1
        MaxCat = 4
        MaxVta = 3.

    ASSIGN
        F-MrgUti-A = T-MATG.MrgUti-A
        F-PreVta-A = T-MATG.Prevta[2]
        F-MrgUti-B = T-MATG.MrgUti-B
        F-PreVta-B = T-MATG.Prevta[3]
        F-MrgUti-C = T-MATG.MrgUti-C
        F-PreVta-C = T-MATG.Prevta[4].

    ASSIGN
        X-CTOUND = T-MATG.CtoTot
        F-FACTOR = 1
        F-MrgUti-A = 0.    
    IF T-MATG.UndA <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas
            AND  Almtconv.Codalter = T-MATG.UndA
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN DO:
            MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
            RETURN.
        END.
        F-FACTOR = Almtconv.Equival.
        F-MrgUti-A = ROUND(((((F-PreVta-A / F-FACTOR) / X-CTOUND) - 1) * 100), 6).
    END.
    ASSIGN
        T-MATG.MrgUti-A = F-MrgUti-A.

    ASSIGN
        F-FACTOR = 1
        F-MrgUti-B = 0.    
    IF T-MATG.UndB <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas
            AND  Almtconv.Codalter = T-MATG.UndB
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN DO:
            MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
            RETURN.
        END.
        F-FACTOR = Almtconv.Equival.
        F-MrgUti-B = ROUND(((((F-PreVta-B / F-FACTOR) / X-CTOUND) - 1) * 100), 6).
    END.
    ASSIGN
        T-MATG.MrgUti-B = F-MrgUti-B.

    ASSIGN
        F-FACTOR = 1
        F-MrgUti-C = 0.    
    /****   Busca el Factor de conversion   ****/
    IF T-MATG.UndC <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas
            AND  Almtconv.Codalter = T-MATG.UndC
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN DO:
            MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
            RETURN.
        END.
        F-FACTOR = Almtconv.Equival.
        F-MrgUti-C = ROUND(((((F-PreVta-C / F-FACTOR) / X-CTOUND) - 1) * 100), 6).
    END.
    ASSIGN
        T-MATG.MrgUti-C = F-MrgUti-C.

    /****   Busca el Factor de conversion   ****/
    IF T-MATG.Chr__01 <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas
            AND  Almtconv.Codalter = T-MATG.Chr__01
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN DO:
           MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
           RETURN.
        END.
        F-FACTOR = Almtconv.Equival.
    END.
    /*******************************************/
    CASE T-MATG.Chr__02 :
        WHEN "T" THEN DO:        
            /*  TERCEROS  */
            IF F-MrgUti-A < MrgMin AND F-MrgUti-A <> 0 THEN MrgMin = F-MrgUti-A.
            IF F-MrgUti-B < MrgMin AND F-MrgUti-B <> 0 THEN MrgMin = F-MrgUti-B.
            IF F-MrgUti-C < MrgMin AND F-MrgUti-C <> 0 THEN MrgMin = F-MrgUti-C.
            fmot = (1 + MrgMin / 100) / ((1 - MaxCat / 100) * (1 - MaxVta / 100)).
            pre-ofi = X-CTOUND * fmot * F-FACTOR .        
            MrgOfi = ROUND((fmot - 1) * 100, 6).
        END.
        WHEN "P" THEN DO:
            /* PROPIOS */
           pre-ofi = T-MATG.Prevta[1] * F-FACTOR.
           MrgOfi = ((T-MATG.Prevta[1] / T-MATG.Ctotot) - 1 ) * 100. 
        END. 
    END.    
    ASSIGN
        T-MATG.DEC__01 = MrgOfi
        T-MATG.PreOfi = pre-ofi.
END.

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

