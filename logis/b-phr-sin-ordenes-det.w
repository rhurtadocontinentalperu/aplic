&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-RUTAD NO-UNDO LIKE DI-RutaD
       FIELD LugEnt AS CHAR
       FIELD SKU AS INT
       FIELD FchEnt AS DATE
       FIELD Docs AS INT
       FIELD Estado AS CHAR
       FIELD Reprogramado AS LOG INITIAL NO.



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
DEF SHARED VAR S-CODCIA AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR lh_handle AS HANDLE.

DEF VAR x-Distrito AS CHAR NO-UNDO.
DEF VAR x-SKU AS INT NO-UNDO.
DEF VAR x-Docs AS INT NO-UNDO.
DEF VAR x-Estado AS CHAR NO-UNDO.

DEF VAR x-Reprogramado AS LOGICAL FORMAT "SI/NO" NO-UNDO.

DEF TEMP-TABLE TT-RUTAD LIKE T-RUTAD.

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
&Scoped-define EXTERNAL-TABLES DI-RutaC
&Scoped-define FIRST-EXTERNAL-TABLE DI-RutaC


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR DI-RutaC.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-RUTAD FacCPedi GN-DIVI DI-RutaD

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table GN-DIVI.DesDiv ~
T-RUTAD.LugEnt @ x-Distrito T-RUTAD.CodRef T-RUTAD.NroRef FacCPedi.FchEnt ~
FacCPedi.NomCli T-RUTAD.SKU @ x-SKU FacCPedi.ImpTot T-RUTAD.Libre_d01 ~
T-RUTAD.Libre_d02 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH T-RUTAD OF DI-RutaC WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST FacCPedi WHERE FacCPedi.CodCia = T-RUTAD.CodCia ~
  AND FacCPedi.CodDoc = T-RUTAD.CodRef ~
  AND FacCPedi.NroPed = T-RUTAD.NroRef NO-LOCK, ~
      FIRST GN-DIVI OF FacCPedi NO-LOCK, ~
      FIRST DI-RutaD WHERE DI-RutaD.CodCia = T-RUTAD.CodCia ~
  AND DI-RutaD.CodDiv = T-RUTAD.CodDiv ~
  AND DI-RutaD.CodDoc = T-RUTAD.CodDoc ~
  AND DI-RutaD.CodRef = T-RUTAD.CodRef ~
  AND DI-RutaD.NroRef = T-RUTAD.NroRef ~
  AND DI-RutaD.NroDoc = T-RUTAD.NroDoc NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-RUTAD OF DI-RutaC WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST FacCPedi WHERE FacCPedi.CodCia = T-RUTAD.CodCia ~
  AND FacCPedi.CodDoc = T-RUTAD.CodRef ~
  AND FacCPedi.NroPed = T-RUTAD.NroRef NO-LOCK, ~
      FIRST GN-DIVI OF FacCPedi NO-LOCK, ~
      FIRST DI-RutaD WHERE DI-RutaD.CodCia = T-RUTAD.CodCia ~
  AND DI-RutaD.CodDiv = T-RUTAD.CodDiv ~
  AND DI-RutaD.CodDoc = T-RUTAD.CodDoc ~
  AND DI-RutaD.CodRef = T-RUTAD.CodRef ~
  AND DI-RutaD.NroRef = T-RUTAD.NroRef ~
  AND DI-RutaD.NroDoc = T-RUTAD.NroDoc NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table T-RUTAD FacCPedi GN-DIVI DI-RutaD
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-RUTAD
&Scoped-define SECOND-TABLE-IN-QUERY-br_table FacCPedi
&Scoped-define THIRD-TABLE-IN-QUERY-br_table GN-DIVI
&Scoped-define FOURTH-TABLE-IN-QUERY-br_table DI-RutaD


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Importe FILL-IN-Peso ~
FILL-IN-Volumen 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fBultos B-table-Win 
FUNCTION fBultos RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDistrito B-table-Win 
FUNCTION fDistrito RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDocumentos B-table-Win 
FUNCTION fDocumentos RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPeso B-table-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSKU B-table-Win 
FUNCTION fSKU RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fVolumen B-table-Win 
FUNCTION fVolumen RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-Importe AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Importe" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Peso AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Peso (kg)" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Volumen AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Volumen (m3)" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-RUTAD, 
      FacCPedi
    FIELDS(FacCPedi.FchEnt
      FacCPedi.NomCli
      FacCPedi.ImpTot), 
      GN-DIVI
    FIELDS(GN-DIVI.DesDiv), 
      DI-RutaD SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      GN-DIVI.DesDiv COLUMN-LABEL "Canal" FORMAT "X(25)":U
      T-RUTAD.LugEnt @ x-Distrito COLUMN-LABEL "Distrito" FORMAT "x(25)":U
      T-RUTAD.CodRef FORMAT "x(3)":U WIDTH 6 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEMS "O/D","OTR","O/M" 
                      DROP-DOWN-LIST 
      T-RUTAD.NroRef FORMAT "X(9)":U WIDTH 10
      FacCPedi.FchEnt FORMAT "99/99/9999":U COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      FacCPedi.NomCli COLUMN-LABEL "Cliente" FORMAT "x(60)":U WIDTH 40.29
      T-RUTAD.SKU @ x-SKU COLUMN-LABEL "SKU" FORMAT ">>,>>9":U
      FacCPedi.ImpTot COLUMN-LABEL "Importe" FORMAT "->>,>>>,>>9.99":U
      T-RUTAD.Libre_d01 COLUMN-LABEL "Peso" FORMAT ">>>,>>9.99":U
      T-RUTAD.Libre_d02 COLUMN-LABEL "Volumen" FORMAT ">>>,>>9.99":U
            WIDTH 8.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 140 BY 13.19
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     FILL-IN-Importe AT ROW 14.19 COL 84 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-Peso AT ROW 14.19 COL 103 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-Volumen AT ROW 14.19 COL 125 COLON-ALIGNED WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.DI-RutaC
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: T-RUTAD T "?" NO-UNDO INTEGRAL DI-RutaD
      ADDITIONAL-FIELDS:
          FIELD LugEnt AS CHAR
          FIELD SKU AS INT
          FIELD FchEnt AS DATE
          FIELD Docs AS INT
          FIELD Estado AS CHAR
          FIELD Reprogramado AS LOG INITIAL NO
      END-FIELDS.
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
         HEIGHT             = 15
         WIDTH              = 140.86.
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
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 4.

/* SETTINGS FOR FILL-IN FILL-IN-Importe IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Peso IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Volumen IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.T-RUTAD OF INTEGRAL.DI-RutaC,INTEGRAL.FacCPedi WHERE Temp-Tables.T-RUTAD ...,INTEGRAL.GN-DIVI OF INTEGRAL.FacCPedi,INTEGRAL.DI-RutaD WHERE Temp-Tables.T-RUTAD ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST USED, FIRST USED, FIRST"
     _JoinCode[2]      = "INTEGRAL.FacCPedi.CodCia = Temp-Tables.T-RUTAD.CodCia
  AND INTEGRAL.FacCPedi.CodDoc = Temp-Tables.T-RUTAD.CodRef
  AND INTEGRAL.FacCPedi.NroPed = Temp-Tables.T-RUTAD.NroRef"
     _JoinCode[4]      = "INTEGRAL.DI-RutaD.CodCia = Temp-Tables.T-RUTAD.CodCia
  AND INTEGRAL.DI-RutaD.CodDiv = Temp-Tables.T-RUTAD.CodDiv
  AND INTEGRAL.DI-RutaD.CodDoc = Temp-Tables.T-RUTAD.CodDoc
  AND INTEGRAL.DI-RutaD.CodRef = Temp-Tables.T-RUTAD.CodRef
  AND INTEGRAL.DI-RutaD.NroRef = Temp-Tables.T-RUTAD.NroRef
  AND INTEGRAL.DI-RutaD.NroDoc = Temp-Tables.T-RUTAD.NroDoc"
     _FldNameList[1]   > INTEGRAL.GN-DIVI.DesDiv
"GN-DIVI.DesDiv" "Canal" "X(25)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"T-RUTAD.LugEnt @ x-Distrito" "Distrito" "x(25)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-RUTAD.CodRef
"T-RUTAD.CodRef" ? ? "character" ? ? ? ? ? ? no ? no no "6" yes no no "U" "" "" "DROP-DOWN-LIST" "," "O/D,OTR,O/M" ? 5 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-RUTAD.NroRef
"T-RUTAD.NroRef" ? ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacCPedi.FchEnt
"FacCPedi.FchEnt" ? ? "date" 11 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" "Cliente" "x(60)" "character" ? ? ? ? ? ? no ? no no "40.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"T-RUTAD.SKU @ x-SKU" "SKU" ">>,>>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.FacCPedi.ImpTot
"FacCPedi.ImpTot" "Importe" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-RUTAD.Libre_d01
"T-RUTAD.Libre_d01" "Peso" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.T-RUTAD.Libre_d02
"T-RUTAD.Libre_d02" "Volumen" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-DISPLAY OF br_table IN FRAME F-Main
DO:
  IF AVAILABLE T-RUTAD THEN DO:
      IF T-RUTAD.Libre_d01 = 0 THEN DO: /* No Documentado */
          T-RUTAD.CodRef:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12.
          T-RUTAD.NroRef:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12.
          T-RUTAD.CodRef:FGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
          T-RUTAD.NroRef:FGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
      END.
  END.
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
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-RUTAD.CodRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-RUTAD.CodRef br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF T-RUTAD.CodRef IN BROWSE br_table /* Codigo */
DO:
  IF SELF:SCREEN-VALUE = '' THEN SELF:SCREEN-VALUE = "OTR".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF T-RUTAD.CodRef, T-RUTAD.NroRef
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "DI-RutaC"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "DI-RutaC"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Temporal B-table-Win 
PROCEDURE Captura-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT-OUTPUT PARAMETER TABLE FOR TT-RUTAD.

EMPTY TEMP-TABLE TT-RUTAD.
FOR EACH T-RUTAD OF DI-RutaC NO-LOCK,
    FIRST FacCPedi WHERE FacCPedi.CodCia = T-RUTAD.CodCia
    AND FacCPedi.CodDoc = T-RUTAD.CodRef
    AND FacCPedi.NroPed = T-RUTAD.NroRef NO-LOCK,
    FIRST GN-DIVI OF FacCPedi NO-LOCK,
    FIRST DI-RutaD WHERE DI-RutaD.CodCia = T-RUTAD.CodCia
    AND DI-RutaD.CodDiv = T-RUTAD.CodDiv
    AND DI-RutaD.CodDoc = T-RUTAD.CodDoc
    AND DI-RutaD.CodRef = T-RUTAD.CodRef
    AND DI-RutaD.NroRef = T-RUTAD.NroRef
    AND DI-RutaD.NroDoc = T-RUTAD.NroDoc NO-LOCK:
    CREATE TT-RUTAD.
    BUFFER-COPY T-RUTAD TO TT-RUTAD.
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

EMPTY TEMP-TABLE T-RUTAD.

IF NOT AVAILABLE Di-RutaC THEN RETURN.
DEF VAR pUbigeo   AS CHAR NO-UNDO.
DEF VAR pLongitud AS DEC NO-UNDO.
DEF VAR pLatitud  AS DEC NO-UNDO.
DEF VAR pCuadrante AS CHAR NO-UNDO.
FOR EACH Di-RutaD OF Di-RutaC NO-LOCK, FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = Di-RutaD.codcia
    AND Faccpedi.coddoc = Di-RutaD.codref
    AND Faccpedi.nroped = Di-RutaD.nroref:
    CREATE T-RUTAD.
    BUFFER-COPY Di-RutaD TO T-RUTAD ASSIGN T-RUTAD.ImpCob = Faccpedi.ImpTot.
    /* Lugar de entrega */
    
    RUN logis/p-datos-sede-auxiliar (Faccpedi.Ubigeo[2],    /* @CL o @PV o @ALM */
                                     Faccpedi.Ubigeo[3],    /* Cliente */
                                     Faccpedi.Ubigeo[1],    /* Sede o Local */
                                     OUTPUT pUbigeo,        /* Provincia, Depto. Distrito */
                                     OUTPUT pLongitud,
                                     OUTPUT pLatitud).
    
    FIND TabDistr WHERE TabDistr.CodDepto = SUBSTRING(pUbigeo,1,2) AND
        TabDistr.CodProvi = SUBSTRING(pUbigeo,3,2) AND
        TabDistr.CodDistr = SUBSTRING(pUbigeo,5,2) 
        NO-LOCK NO-ERROR.
    IF AVAILABLE TabDistr THEN T-RUTAD.LugEnt = TabDistr.NomDistr.
    ELSE T-RUTAD.LugEnt = ''.
    CASE TRUE:
    END CASE.

    RUN logis/p-cuadrante (pLongitud, pLatitud, OUTPUT pCuadrante).
    
    T-RUTAD.Libre_c01 = pCuadrante.

    /* **************** */
    /*T-RUTAD.LugEnt = fDistrito().*/
    /*T-RUTAD.Docs   = fDocumentos().*/
    /*T-RUTAD.Libre_c01 = STRING(fBultos()).*/
    T-RUTAD.Libre_d01 = 0.
    T-RUTAD.Libre_d02 = 0.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
        T-RUTAD.SKU = T-RUTAD.SKU + 1.
        T-RUTAD.Libre_d01 = T-RUTAD.Libre_d01 + (Facdpedi.canped * Facdpedi.factor * almmmatg.pesmat).
        IF almmmatg.libre_d02 <> ? THEN T-RUTAD.Libre_d02 = T-RUTAD.Libre_d02 + (Facdpedi.canped * Facdpedi.Factor * (Almmmatg.libre_d02 / 1000000)).
    END.
    /*T-RUTAD.Estado = fEstado().*/
    IF CAN-FIND(LAST AlmCDocu WHERE AlmCDocu.CodCia = T-RUTAD.codcia AND
                AlmCDocu.CodLlave = s-CodDiv AND 
                AlmCDocu.CodDoc = T-RUTAD.Codref AND
                AlmCDocu.NroDoc = T-RUTAD.NroRef AND 
                AlmCDocu.FlgEst = "C" NO-LOCK)
        THEN T-RUTAD.Reprogramado = YES.


END.

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
    hColumn:READ-ONLY = TRUE.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF LOOKUP(DI-RutaC.FlgEst, 'C,A,L') > 0 THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Carga-Temporal.

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
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-handle IN lh_handle ('Pinta-Cabecera').
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
  {src/adm/template/snd-list.i "DI-RutaC"}
  {src/adm/template/snd-list.i "T-RUTAD"}
  {src/adm/template/snd-list.i "FacCPedi"}
  {src/adm/template/snd-list.i "GN-DIVI"}
  {src/adm/template/snd-list.i "DI-RutaD"}

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

    DEF BUFFER BT-RUTAD FOR T-RUTAD.

    FILL-IN-Importe = 0.
    FILL-IN-Peso = 0.
    FILL-IN-Volumen = 0.

    FOR EACH BT-RUTAD NO-LOCK:
        FILL-IN-Peso = FILL-IN-Peso + BT-RUTAD.Libre_d01.
        FILL-IN-Volumen = FILL-IN-Volumen + BT-RUTAD.Libre_d02.
        FILL-IN-Importe = FILL-IN-Importe + BT-RUTAD.ImpCob.
    END.
    DISPLAY
        FILL-IN-Importe FILL-IN-Peso FILL-IN-Volumen WITH FRAME {&FRAME-NAME}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fBultos B-table-Win 
FUNCTION fBultos RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-Bultos AS INT NO-UNDO.

  FIND FIRST CcbCBult WHERE CcbCBult.CodCia = Faccpedi.codcia
      AND CcbCBult.CodDoc = Faccpedi.CodDoc
      AND CcbCBult.NroDoc = Faccpedi.NroPed
      AND CcbCBult.CHR_01 = "P"                     /* H/R Aún NO cerrada */
      NO-LOCK NO-ERROR.
  IF AVAILABLE CcbCBult THEN x-Bultos = CcbCBult.Bultos.
  RETURN x-Bultos.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDistrito B-table-Win 
FUNCTION fDistrito RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pCodDpto AS CHAR NO-UNDO.
  DEF VAR pCodProv AS CHAR NO-UNDO.
  DEF VAR pCodDist AS CHAR NO-UNDO.
  DEF VAR pCodPos  AS CHAR NO-UNDO.
  DEF VAR pZona    AS CHAR NO-UNDO.
  DEF VAR pSubZona AS CHAR NO-UNDO.

  RUN gn/fUbigeo (
      Faccpedi.CodDiv, 
      Faccpedi.CodDoc,
      Faccpedi.NroPed,
      OUTPUT pCodDpto,
      OUTPUT pCodProv,
      OUTPUT pCodDist,
      OUTPUT pCodPos,
      OUTPUT pZona,
      OUTPUT pSubZona
      ).
  FIND TabDistr WHERE TabDistr.CodDepto = pCodDpto
      AND TabDistr.CodProvi = pCodProv
      AND TabDistr.CodDistr = pCodDist
      NO-LOCK NO-ERROR.
    IF AVAILABLE TabDistr THEN RETURN TabDistr.NomDistr.
    ELSE RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDocumentos B-table-Win 
FUNCTION fDocumentos RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-NroDocs AS INT NO-UNDO.
  DEF BUFFER PEDIDO FOR Faccpedi.

  CASE FacCPedi.CodDoc:
      WHEN "O/M" OR WHEN "O/D" THEN DO:
          /* Buscamos del PEDido: Puede ser del cliente o del 1er. tramo */
          FIND PEDIDO WHERE PEDIDO.codcia = FacCPedi.codcia
              AND PEDIDO.coddoc = FacCPedi.codref
              AND PEDIDO.nroped = FacCPedi.nroref
              AND PEDIDO.codpos > ''
              NO-LOCK NO-ERROR.
          IF AVAILABLE PEDIDO THEN DO:
              /* Contamos cuantas guias de remisión están relacionadas */
              FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = Faccpedi.codcia
                  AND Ccbcdocu.codped = PEDIDO.coddoc
                  AND Ccbcdocu.nroped = PEDIDO.nroped:
                  IF Ccbcdocu.coddiv = s-coddiv
                      AND Ccbcdocu.coddoc = 'G/R'
                      AND Ccbcdocu.flgest <> 'A'
                      THEN x-NroDocs = x-NroDocs + 1.
              END.
          END.
      END.
      WHEN "OTR" THEN DO:
          /* Contamos cuantas guias de remisión están relacionadas */
          FOR EACH Almcmov NO-LOCK WHERE Almcmov.codcia = 1 
              AND Almcmov.codref = FacCPedi.coddoc
              AND Almcmov.nroref = FacCPedi.nroped:
              IF Almcmov.tipmov = 'S' 
                  AND Almcmov.codmov = 03
                  AND Almcmov.flgest <> 'A'
                  THEN x-NroDocs = x-NroDocs + 1.
          END.
      END.
  END CASE.
  RETURN x-NroDocs.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR cEstado AS CHAR NO-UNDO.

  cEstado = 'Aprobado'.
  CASE Faccpedi.CodDoc:
      WHEN "O/D" OR WHEN "O/M" OR WHEN "OTR" THEN DO:
          IF Faccpedi.usrImpOD > '' THEN cEstado = 'Impreso'.
          IF Faccpedi.FlgSit = "P" THEN cEstado = "Picking Terminado".
          IF Faccpedi.FlgSit = "C" THEN cEstado = "Checking Terminado".
          IF Faccpedi.FlgEst = "C" THEN cEstado = "Documentado".
      END.
  END CASE.
  RETURN cEstado.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPeso B-table-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-Pesos AS DEC NO-UNDO.

  FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
      x-Pesos = x-Pesos + (Facdpedi.canped * Facdpedi.factor * almmmatg.pesmat).
  END.
  RETURN x-Pesos.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSKU B-table-Win 
FUNCTION fSKU RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-SKU AS INT NO-UNDO.

  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
      x-SKU = x-SKU + 1.
  END.
  RETURN x-SKU.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fVolumen B-table-Win 
FUNCTION fVolumen RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-Volumen AS DEC NO-UNDO.

  FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
      IF almmmatg.libre_d02 <> ? THEN x-Volumen = x-Volumen + (Facdpedi.canped * Facdpedi.Factor * (Almmmatg.libre_d02 / 1000000)).
  END.
  RETURN x-Volumen.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

