&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-TAB FOR TabGener.



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
DEF SHARED VAR s-tabla AS CHAR.
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
&Scoped-define EXTERNAL-TABLES Almtfami
&Scoped-define FIRST-EXTERNAL-TABLE Almtfami


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almtfami.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES TabGener AlmSFami GN-DIVI

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Almtfami.codfam Almtfami.desfam ~
AlmSFami.subfam AlmSFami.dessub GN-DIVI.CodDiv GN-DIVI.DesDiv ~
TabGener.Parametro[1] TabGener.Parametro[2] TabGener.Parametro[3] ~
TabGener.Parametro[4] TabGener.Parametro[5] TabGener.Parametro[6] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table TabGener.Parametro[1] ~
TabGener.Parametro[2] TabGener.Parametro[3] TabGener.Parametro[4] ~
TabGener.Parametro[5] TabGener.Parametro[6] 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table TabGener
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table TabGener
&Scoped-define QUERY-STRING-br_table FOR EACH TabGener WHERE TabGener.Clave = s-Tabla ~
  AND ENTRY(1,TabGener.Codigo,'|') = Almtfami.codfam ~
      AND TabGener.Clave = s-Tabla ~
 AND ENTRY(2,TabGener.Codigo,'|') = COMBO-BOX-SubFam NO-LOCK, ~
      FIRST AlmSFami WHERE AlmSFami.CodCia = TabGener.CodCia ~
  AND AlmSFami.codfam = ENTRY(1, TabGener.Codigo, '|') ~
  AND AlmSFami.subfam = ENTRY(2, TabGener.Codigo, '|') NO-LOCK, ~
      FIRST GN-DIVI WHERE GN-DIVI.CodCia = TabGener.CodCia ~
  AND GN-DIVI.CodDiv = ENTRY(3, TabGener.Codigo, '|') NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH TabGener WHERE TabGener.Clave = s-Tabla ~
  AND ENTRY(1,TabGener.Codigo,'|') = Almtfami.codfam ~
      AND TabGener.Clave = s-Tabla ~
 AND ENTRY(2,TabGener.Codigo,'|') = COMBO-BOX-SubFam NO-LOCK, ~
      FIRST AlmSFami WHERE AlmSFami.CodCia = TabGener.CodCia ~
  AND AlmSFami.codfam = ENTRY(1, TabGener.Codigo, '|') ~
  AND AlmSFami.subfam = ENTRY(2, TabGener.Codigo, '|') NO-LOCK, ~
      FIRST GN-DIVI WHERE GN-DIVI.CodCia = TabGener.CodCia ~
  AND GN-DIVI.CodDiv = ENTRY(3, TabGener.Codigo, '|') NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table TabGener AlmSFami GN-DIVI
&Scoped-define FIRST-TABLE-IN-QUERY-br_table TabGener
&Scoped-define SECOND-TABLE-IN-QUERY-br_table AlmSFami
&Scoped-define THIRD-TABLE-IN-QUERY-br_table GN-DIVI


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-9 RECT-10 RECT-26 COMBO-BOX-SubFam ~
br_table 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-SubFam FILL-IN-Campana-1 ~
FILL-IN-Campana-2 FILL-IN-Campana-3 FILL-IN-NoCampana-1 FILL-IN-NoCampana-2 ~
FILL-IN-NoCampana-3 

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
DEFINE VARIABLE COMBO-BOX-SubFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Sub-Linea" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 20
     LIST-ITEM-PAIRS "uno","uno"
     DROP-DOWN-LIST
     SIZE 69 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Campana-1 AS DECIMAL FORMAT "ZZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1
     BGCOLOR 10 FGCOLOR 0 FONT 4 NO-UNDO.

DEFINE VARIABLE FILL-IN-Campana-2 AS DECIMAL FORMAT "ZZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1
     BGCOLOR 10 FGCOLOR 0 FONT 4 NO-UNDO.

DEFINE VARIABLE FILL-IN-Campana-3 AS DECIMAL FORMAT "ZZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1
     BGCOLOR 10 FGCOLOR 0 FONT 4 NO-UNDO.

DEFINE VARIABLE FILL-IN-NoCampana-1 AS DECIMAL FORMAT "ZZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1
     BGCOLOR 14 FGCOLOR 0 FONT 4 NO-UNDO.

DEFINE VARIABLE FILL-IN-NoCampana-2 AS DECIMAL FORMAT "ZZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1
     BGCOLOR 14 FGCOLOR 0 FONT 4 NO-UNDO.

DEFINE VARIABLE FILL-IN-NoCampana-3 AS DECIMAL FORMAT "ZZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1
     BGCOLOR 14 FGCOLOR 0 FONT 4 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 20 BY .96
     BGCOLOR 14 FGCOLOR 0 .

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 138 BY 1.54.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 20 BY .96
     BGCOLOR 10 FGCOLOR 0 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      TabGener, 
      AlmSFami, 
      GN-DIVI SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Almtfami.codfam COLUMN-LABEL "Línea" FORMAT "X(3)":U
      Almtfami.desfam FORMAT "X(30)":U
      AlmSFami.subfam COLUMN-LABEL "SubLínea" FORMAT "X(3)":U
      AlmSFami.dessub FORMAT "X(30)":U
      GN-DIVI.CodDiv COLUMN-LABEL "División" FORMAT "x(5)":U
      GN-DIVI.DesDiv FORMAT "X(45)":U
      TabGener.Parametro[1] COLUMN-LABEL "Ambos" FORMAT ">>9.99":U
            WIDTH 6 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 10
      TabGener.Parametro[2] COLUMN-LABEL "May." FORMAT ">>9.99":U
            WIDTH 6 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 10
      TabGener.Parametro[3] COLUMN-LABEL "Min." FORMAT ">>9.99":U
            WIDTH 6 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 10
      TabGener.Parametro[4] COLUMN-LABEL "Ambos" FORMAT ">>9.99":U
            WIDTH 6 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      TabGener.Parametro[5] COLUMN-LABEL "May." FORMAT ">>9.99":U
            WIDTH 6 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      TabGener.Parametro[6] COLUMN-LABEL "Min." FORMAT ">>9.99":U
            WIDTH 6 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
  ENABLE
      TabGener.Parametro[1]
      TabGener.Parametro[2]
      TabGener.Parametro[3]
      TabGener.Parametro[4]
      TabGener.Parametro[5]
      TabGener.Parametro[6]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 138 BY 15.77
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-SubFam AT ROW 1.38 COL 10 COLON-ALIGNED WIDGET-ID 12
     br_table AT ROW 2.54 COL 1
     FILL-IN-Campana-1 AT ROW 18.31 COL 95 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN-Campana-2 AT ROW 18.31 COL 101 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     FILL-IN-Campana-3 AT ROW 18.31 COL 108 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     FILL-IN-NoCampana-1 AT ROW 18.31 COL 115 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     FILL-IN-NoCampana-2 AT ROW 18.31 COL 121 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     FILL-IN-NoCampana-3 AT ROW 18.31 COL 128 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     "CAMPAÑA" VIEW-AS TEXT
          SIZE 10 BY .62 AT ROW 1.77 COL 101 WIDGET-ID 2
          BGCOLOR 10 FGCOLOR 0 
     "NO CAMPAÑA" VIEW-AS TEXT
          SIZE 13 BY .62 AT ROW 1.77 COL 121 WIDGET-ID 4
          BGCOLOR 14 FGCOLOR 0 
     RECT-9 AT ROW 1.58 COL 97 WIDGET-ID 6
     RECT-10 AT ROW 1.58 COL 117 WIDGET-ID 8
     RECT-26 AT ROW 1 COL 1 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.Almtfami
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-TAB B "?" ? INTEGRAL TabGener
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
         HEIGHT             = 19.62
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
/* BROWSE-TAB br_table COMBO-BOX-SubFam F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Campana-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Campana-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Campana-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NoCampana-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NoCampana-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NoCampana-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.TabGener WHERE INTEGRAL.Almtfami <external> ... ...,INTEGRAL.AlmSFami WHERE INTEGRAL.TabGener ...,INTEGRAL.GN-DIVI WHERE INTEGRAL.TabGener ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST, FIRST"
     _JoinCode[1]      = "TabGener.Clave = s-Tabla
  AND ENTRY(1,TabGener.Codigo,'|') = Almtfami.codfam"
     _Where[1]         = "TabGener.Clave = s-Tabla
 AND ENTRY(2,TabGener.Codigo,'|') = COMBO-BOX-SubFam"
     _JoinCode[2]      = "AlmSFami.CodCia = TabGener.CodCia
  AND AlmSFami.codfam = ENTRY(1, TabGener.Codigo, '|')
  AND AlmSFami.subfam = ENTRY(2, TabGener.Codigo, '|')"
     _JoinCode[3]      = "GN-DIVI.CodCia = TabGener.CodCia
  AND GN-DIVI.CodDiv = ENTRY(3, TabGener.Codigo, '|')"
     _FldNameList[1]   > INTEGRAL.Almtfami.codfam
"Almtfami.codfam" "Línea" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.Almtfami.desfam
     _FldNameList[3]   > INTEGRAL.AlmSFami.subfam
"AlmSFami.subfam" "SubLínea" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = INTEGRAL.AlmSFami.dessub
     _FldNameList[5]   > INTEGRAL.GN-DIVI.CodDiv
"GN-DIVI.CodDiv" "División" "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.GN-DIVI.DesDiv
"GN-DIVI.DesDiv" ? "X(45)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.TabGener.Parametro[1]
"TabGener.Parametro[1]" "Ambos" ">>9.99" "decimal" 10 0 ? ? ? ? yes ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.TabGener.Parametro[2]
"TabGener.Parametro[2]" "May." ">>9.99" "decimal" 10 0 ? ? ? ? yes ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.TabGener.Parametro[3]
"TabGener.Parametro[3]" "Min." ">>9.99" "decimal" 10 0 ? ? ? ? yes ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.TabGener.Parametro[4]
"TabGener.Parametro[4]" "Ambos" ">>9.99" "decimal" 14 0 ? ? ? ? yes ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.TabGener.Parametro[5]
"TabGener.Parametro[5]" "May." ">>9.99" "decimal" 14 0 ? ? ? ? yes ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.TabGener.Parametro[6]
"TabGener.Parametro[6]" "Min." ">>9.99" "decimal" 14 0 ? ? ? ? yes ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME COMBO-BOX-SubFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-SubFam B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-SubFam IN FRAME F-Main /* Sub-Linea */
DO:
  ASSIGN {&self-name}.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  RUN Totales.
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "Almtfami"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almtfami"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Sublineas B-table-Win 
PROCEDURE Carga-Sublineas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-dessub AS CHAR NO-UNDO.
DEF VAR x-num-items AS INT NO-UNDO.
DEF VAR i AS INT NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    COMBO-BOX-SubFam:DELIMITER = '|'.
    x-num-items = COMBO-BOX-SubFam:NUM-ITEMS.
    DO I = 1 TO x-num-items:
        COMBO-BOX-SubFam:DELETE(1).
    END.
    FOR EACH Almsfami OF Almtfami NO-LOCK BY almsfami.subfam DESC:
        RUN lib/limpiar-texto (almsfami.dessub, ' ', OUTPUT x-dessub).

         COMBO-BOX-SubFam:ADD-LAST(almsfami.subfam + ' ' + x-dessub, almsfami.subfam).
         COMBO-BOX-SubFam = Almsfami.subfam.
    END.
    DISPLAY COMBO-BOX-SubFam.
END.

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

DEF VAR x-Codigo AS CHAR NO-UNDO.

/* 1ro. Completamos las lineas, sublineas y divisiones */
MESSAGE 'primera parte'.
FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
    AND Almacen.Campo-C[6] = "Si"       /* Comercial */
    AND Almacen.Campo-C[3] <> "Si"      /* No Remates */
    AND Almacen.Campo-C[9] <> "I"       /* No Inactivo */
    AND Almacen.AlmCsg = NO:            /* No de Consignación */
    FIND FIRST VtaAlmDiv WHERE VtaAlmDiv.CodCia = Almacen.codcia
        AND VtaAlmDiv.CodDiv = Almacen.coddiv
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE VtaAlmDiv THEN NEXT.
    IF VtaAlmDiv.codalm <> Almacen.codalm THEN NEXT.
    /* Ya tenemos el almacén y una división válida */
    FOR EACH Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia AND Almtfami.SwComercial = YES,
        EACH Almsfami OF Almtfami NO-LOCK:
        x-Codigo = TRIM(Almtfami.codfam) + '|' + TRIM(Almsfami.subfam) + '|' + TRIM(Almacen.coddiv).
        FIND FIRST TabGener WHERE TabGener.CodCia = s-codcia
            AND TabGener.Clave = s-Tabla
            AND TabGener.Codigo = x-Codigo
            NO-ERROR.
        IF NOT AVAILABLE TabGener THEN DO:
            CREATE TabGener.
            ASSIGN
                TabGener.CodCia = s-codcia
                TabGener.Clave  = s-Tabla
                TabGener.Codigo = x-Codigo
                TabGener.LlaveIni = Almacen.codalm.
        END.
    END.
END.
/* 2do Borramos lo NO válido */
MESSAGE 'segunda parte'.
FOR EACH TabGener WHERE TabGener.CodCia = s-codcia AND TabGener.Clave = s-Tabla:
    FIND Almtfami WHERE Almtfami.codcia = s-codcia
        AND Almtfami.codfam = ENTRY(1, TabGener.Codigo, '|')
        AND Almtfami.SwComercial = YES
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtfami THEN DO:
        DELETE TabGener.
        NEXT.
    END.
    FIND FIRST Almsfami WHERE Almsfami.codcia = s-codcia
        AND Almsfami.codfam = ENTRY(1, TabGener.Codigo, '|')
        AND Almsfami.subfam = ENTRY(2, TabGener.Codigo, '|')
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almsfami THEN DO:
        DELETE TabGener.
        NEXT.
    END.
    FIND FIRST VtaAlmDiv WHERE VtaAlmDiv.CodCia = s-codcia
        AND VtaAlmDiv.CodDiv = ENTRY(3, TabGener.Codigo, '|')
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE VtaAlmDiv THEN DO:
        DELETE TabGener.
        NEXT.
    END.
    IF NOT CAN-FIND(FIRST Almacen WHERE Almacen.codcia = s-codcia
                    AND Almacen.Campo-C[6] = "Si"       /* Comercial */
                    AND Almacen.Campo-C[3] <> "Si"      /* No Remates */
                    AND Almacen.Campo-C[9] <> "I"       /* No Inactivo */
                    AND Almacen.AlmCsg = NO
                    AND Almacen.CodDiv = VtaAlmDiv.CodDiv
                    NO-LOCK)
        THEN DO:
        DELETE TabGener.
        NEXT.
    END.
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
  COMBO-BOX-SubFam:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

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
  COMBO-BOX-SubFam:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

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
   RUN Carga-Sublineas.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Totales.

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
  RUN Totales.

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
  {src/adm/template/snd-list.i "Almtfami"}
  {src/adm/template/snd-list.i "TabGener"}
  {src/adm/template/snd-list.i "AlmSFami"}
  {src/adm/template/snd-list.i "GN-DIVI"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Totales B-table-Win 
PROCEDURE Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN
    FILL-IN-Campana-1 = 0
    FILL-IN-Campana-2 = 0
    FILL-IN-Campana-3 = 0
    FILL-IN-NoCampana-1 = 0
    FILL-IN-NoCampana-2 = 0
    FILL-IN-NoCampana-3 = 0.

FOR EACH B-TAB WHERE B-TAB.CodCia = Almtfami.CodCia
    AND ENTRY(1, B-TAB.Codigo, '|') = Almtfami.codfam
    AND ENTRY(2, B-TAB.Codigo, '|') = COMBO-BOX-SubFam
    AND B-TAB.Clave = s-Tabla NO-LOCK:
    ASSIGN
        FILL-IN-Campana-1 = FILL-IN-Campana-1 + B-TAB.Parametro[1]
        FILL-IN-Campana-2 = FILL-IN-Campana-2 + B-TAB.Parametro[2]
        FILL-IN-Campana-3 = FILL-IN-Campana-3 + B-TAB.Parametro[3]
        FILL-IN-NoCampana-1 = FILL-IN-NoCampana-1 + B-TAB.Parametro[4]
        FILL-IN-NoCampana-2 = FILL-IN-NoCampana-2 + B-TAB.Parametro[5]
        FILL-IN-NoCampana-3 = FILL-IN-NoCampana-3 + B-TAB.Parametro[6].
END.
DISPLAY
    FILL-IN-Campana-1
    FILL-IN-Campana-2
    FILL-IN-Campana-3
    FILL-IN-NoCampana-1
    FILL-IN-NoCampana-2
    FILL-IN-NoCampana-3
    WITH FRAME {&FRAME-NAME}.

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

