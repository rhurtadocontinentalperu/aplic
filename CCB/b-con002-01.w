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
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR s-coddoc AS CHAR INIT 'I/C'.
DEF VAR x-CodDiv LIKE s-coddiv NO-UNDO.
DEF VAR x-Estado AS CHAR NO-UNDO.
DEF VAR x-FlgEst AS CHAR NO-UNDO.
DEF VAR x-FlgCie AS CHAR NO-UNDO.

x-CodDiv = s-coddiv.

/* Preprocesadores para cada campo filtro */
&SCOPED-DEFINE FILTRO1 ( Ccbccaja.NomCli BEGINS FILL-IN-filtro )
&SCOPED-DEFINE FILTRO2 ( INDEX ( Ccbccaja.NomCli , FILL-IN-filtro ) <> 0 )

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
&Scoped-define INTERNAL-TABLES CcbCCaja

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CcbCCaja.CodDiv CcbCCaja.FchDoc ~
CcbCCaja.FchCie CcbCCaja.Tipo CcbCCaja.NroDoc _FlgEst() @ x-Estado ~
CcbCCaja.CodCli CcbCCaja.NomCli CcbCCaja.CodCaja CcbCCaja.usuario ~
CcbCCaja.VueNac CcbCCaja.VueUsa 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH CcbCCaja WHERE ~{&KEY-PHRASE} ~
      AND CcbCCaja.CodCia = s-codcia ~
 AND (x-coddiv = 'TODOS' OR CcbCCaja.CodDiv = x-coddiv) ~
 AND CcbCCaja.CodDoc = s-coddoc ~
 AND CcbCCaja.FchDoc >= x-FchDoc-1 ~
 AND CcbCCaja.FchDoc <= x-FchDoc-2 ~
 AND (x-FlgEst = '' OR Ccbccaja.flgest = x-FlgEst) ~
 AND (x-FlgCie = '' OR Ccbccaja.flgcie = x-FlgCie) ~
 NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH CcbCCaja WHERE ~{&KEY-PHRASE} ~
      AND CcbCCaja.CodCia = s-codcia ~
 AND (x-coddiv = 'TODOS' OR CcbCCaja.CodDiv = x-coddiv) ~
 AND CcbCCaja.CodDoc = s-coddoc ~
 AND CcbCCaja.FchDoc >= x-FchDoc-1 ~
 AND CcbCCaja.FchDoc <= x-FchDoc-2 ~
 AND (x-FlgEst = '' OR Ccbccaja.flgest = x-FlgEst) ~
 AND (x-FlgCie = '' OR Ccbccaja.flgcie = x-FlgCie) ~
 NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table CcbCCaja
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CcbCCaja


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-11 COMBO-BOX-Estado x-Divisiones ~
x-FchDoc-1 x-FchDoc-2 CMB-filtro FILL-IN-filtro br_table 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Estado x-Divisiones x-FchDoc-1 ~
x-FchDoc-2 CMB-filtro FILL-IN-filtro 

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
Nombres que inicien con|y||INTEGRAL.CcbCCaja.NomCli
Nombres que contengan|y||INTEGRAL.CcbCCaja.NomCli
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "Nombres que inicien con,Nombres que contengan",
     Keys-Supplied = ':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD _FlgEst B-table-Win 
FUNCTION _FlgEst RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-11 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 11" 
     SIZE 6 BY 1.35.

DEFINE VARIABLE CMB-filtro AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Clientes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 29 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Estado AS CHARACTER FORMAT "X(256)":U INITIAL "TODOS" 
     LABEL "Estado" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEMS "TODOS","CERRADO","PENDIENTE","ANULADO" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE x-Divisiones AS CHARACTER FORMAT "X(256)":U 
     LABEL "División" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "TODOS" 
     DROP-DOWN-LIST
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-filtro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.29 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE x-FchDoc-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-FchDoc-2 AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      CcbCCaja SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      CcbCCaja.CodDiv FORMAT "x(5)":U
      CcbCCaja.FchDoc FORMAT "99/99/9999":U
      CcbCCaja.FchCie FORMAT "99/99/9999":U
      CcbCCaja.Tipo COLUMN-LABEL "Tipo" FORMAT "x(12)":U WIDTH 11.72
      CcbCCaja.NroDoc FORMAT "X(9)":U WIDTH 9.43
      _FlgEst() @ x-Estado COLUMN-LABEL "Estado" FORMAT "x(10)":U
            WIDTH 8.72
      CcbCCaja.CodCli FORMAT "x(11)":U WIDTH 10.43
      CcbCCaja.NomCli COLUMN-LABEL "Nombre del Cliente" FORMAT "X(60)":U
            WIDTH 38
      CcbCCaja.CodCaja COLUMN-LABEL "Terminal" FORMAT "X(10)":U
      CcbCCaja.usuario COLUMN-LABEL "Cajero" FORMAT "x(10)":U
      CcbCCaja.VueNac COLUMN-LABEL "Vuelto S/." FORMAT "->>,>>9.99":U
      CcbCCaja.VueUsa COLUMN-LABEL "Vuelto US$" FORMAT "->>,>>9.99":U
            WIDTH 4.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 140 BY 6.69
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-11 AT ROW 1 COL 124 WIDGET-ID 14
     COMBO-BOX-Estado AT ROW 1.19 COL 84 COLON-ALIGNED WIDGET-ID 12
     x-Divisiones AT ROW 1.27 COL 9 COLON-ALIGNED WIDGET-ID 2
     x-FchDoc-1 AT ROW 2.35 COL 9 COLON-ALIGNED WIDGET-ID 4
     x-FchDoc-2 AT ROW 2.35 COL 34 COLON-ALIGNED WIDGET-ID 6
     CMB-filtro AT ROW 2.35 COL 53.28 WIDGET-ID 8
     FILL-IN-filtro AT ROW 2.35 COL 91 NO-LABEL WIDGET-ID 10
     br_table AT ROW 3.42 COL 1
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
         HEIGHT             = 9.54
         WIDTH              = 150.43.
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
/* BROWSE-TAB br_table FILL-IN-filtro F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX CMB-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.CcbCCaja"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "CcbCCaja.CodCia = s-codcia
 AND (x-coddiv = 'TODOS' OR CcbCCaja.CodDiv = x-coddiv)
 AND CcbCCaja.CodDoc = s-coddoc
 AND CcbCCaja.FchDoc >= x-FchDoc-1
 AND CcbCCaja.FchDoc <= x-FchDoc-2
 AND (x-FlgEst = '' OR Ccbccaja.flgest = x-FlgEst)
 AND (x-FlgCie = '' OR Ccbccaja.flgcie = x-FlgCie)
"
     _FldNameList[1]   = INTEGRAL.CcbCCaja.CodDiv
     _FldNameList[2]   = INTEGRAL.CcbCCaja.FchDoc
     _FldNameList[3]   = INTEGRAL.CcbCCaja.FchCie
     _FldNameList[4]   > INTEGRAL.CcbCCaja.Tipo
"CcbCCaja.Tipo" "Tipo" "x(12)" "character" ? ? ? ? ? ? no ? no no "11.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.CcbCCaja.NroDoc
"CcbCCaja.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"_FlgEst() @ x-Estado" "Estado" "x(10)" ? ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.CcbCCaja.CodCli
"CcbCCaja.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.CcbCCaja.NomCli
"CcbCCaja.NomCli" "Nombre del Cliente" "X(60)" "character" ? ? ? ? ? ? no ? no no "38" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.CcbCCaja.CodCaja
"CcbCCaja.CodCaja" "Terminal" "X(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.CcbCCaja.usuario
"CcbCCaja.usuario" "Cajero" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.CcbCCaja.VueNac
"CcbCCaja.VueNac" "Vuelto S/." ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.CcbCCaja.VueUsa
"CcbCCaja.VueUsa" "Vuelto US$" ? "decimal" ? ? ? ? ? ? no ? no no "4.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME BUTTON-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-11 B-table-Win
ON CHOOSE OF BUTTON-11 IN FRAME F-Main /* Button 11 */
DO:
    SESSION:SET-WAIT-STATE('GENERAL').
   RUN Excel.
   SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CMB-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CMB-filtro B-table-Win
ON VALUE-CHANGED OF CMB-filtro IN FRAME F-Main /* Clientes */
DO:
    IF CMB-filtro = CMB-filtro:SCREEN-VALUE AND
        FILL-IN-filtro = FILL-IN-filtro:SCREEN-VALUE THEN RETURN.
    ASSIGN
        FILL-IN-filtro
        CMB-filtro.
    IF CMB-filtro = "Todos" THEN RUN set-attribute-list('Key-Name=?').
    ELSE RUN set-attribute-list('Key-Name=' + CMB-filtro).
    RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Estado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Estado B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Estado IN FRAME F-Main /* Estado */
DO:
    ASSIGN {&self-name}.
    IF SELF:SCREEN-VALUE = "TODOS"     THEN ASSIGN x-FlgEst = "" x-FlgCie = "".
    IF SELF:SCREEN-VALUE = "CERRADO"   THEN ASSIGN x-FlgEst = "C" x-FlgCie = "C".
    IF SELF:SCREEN-VALUE = "PENDIENTE" THEN ASSIGN x-FlgEst = "C" x-FlgCie = "P".
    IF SELF:SCREEN-VALUE = "ANULADO"   THEN ASSIGN x-FlgEst = "A" x-FlgCie = "".
    RUN dispatch IN THIS-PROCEDURE ('open-query').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-filtro B-table-Win
ON LEAVE OF FILL-IN-filtro IN FRAME F-Main
DO:
    APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Divisiones
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Divisiones B-table-Win
ON VALUE-CHANGED OF x-Divisiones IN FRAME F-Main /* División */
DO:
  x-CodDiv = ENTRY(1, SELF:SCREEN-VALUE, " - ").
  RUN dispatch IN THIS-PROCEDURE ('open-query').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-FchDoc-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-FchDoc-1 B-table-Win
ON LEAVE OF x-FchDoc-1 IN FRAME F-Main /* Desde */
DO:
  ASSIGN {&self-name}.
  RUN dispatch IN THIS-PROCEDURE ('open-query').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-FchDoc-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-FchDoc-2 B-table-Win
ON LEAVE OF x-FchDoc-2 IN FRAME F-Main /* Hasta */
DO:
    ASSIGN {&self-name}.
    RUN dispatch IN THIS-PROCEDURE ('open-query').
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEF VAR key-value AS CHAR NO-UNDO.

  /* Look up the current key-value. */
  RUN get-attribute ('Key-Value':U).
  key-value = RETURN-VALUE.

  /* Find the current record using the current Key-Name. */
  RUN get-attribute ('Key-Name':U).
  CASE RETURN-VALUE:
    WHEN 'Nombres que inicien con':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro1} )
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* Nombres que inicien con */
    WHEN 'Nombres que contengan':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro2} )
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* Nombres que contengan */
    OTHERWISE DO:
       &Scope KEY-PHRASE TRUE
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* OTHERWISE...*/
  END CASE.

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

chWorkSheet:Range("A1"):VALUE = "CONSULTA GENERAL DE INGRESOS DE CAJA" +
    " DEL " + STRING(x-FchDoc-1) + " AL " + STRING(x-FchDoc-2).
chWorkSheet:Range("A2"):VALUE = "Division".
chWorkSheet:Range("B2"):VALUE = "Fecha ".
chWorkSheet:Range("C2"):VALUE = "Cierre".
chWorkSheet:Range("D2"):VALUE = "Tipo".
chWorkSheet:Range("E2"):VALUE = "Numero".
chWorkSheet:Range("F2"):VALUE = "Estado".
chWorkSheet:Range("G2"):VALUE = "Cliente".
chWorkSheet:Range("H2"):VALUE = "Nombre".
chWorkSheet:Range("I2"):VALUE = "Terminal".
chWorkSheet:Range("J2"):VALUE = "Cajero".
chWorkSheet:COLUMNS("A"):NumberFormat = "@".
chWorkSheet:COLUMNS("B"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:COLUMNS("C"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:COLUMNS("E"):NumberFormat = "@".
chWorkSheet:COLUMNS("G"):NumberFormat = "@".

chWorkSheet = chExcelApplication:Sheets:Item(1).

ASSIGN
    t-Column = 0
    t-Row    = 2.
GET FIRST {&browse-name}.
REPEAT WHILE AVAILABLE CcbCCaja:
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1.
    /* DIVISION */
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCCaja.CodDiv.
    /* FECHA */
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCCaja.FchDoc.
    /* CIERRE */
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCCaja.FchCie.
    /* TIPO */
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCCaja.Tipo.
    /* NUMERO */
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCCaja.NroDoc.
    /* ESTADO */
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column):VALUE = _FlgEst().
    /* CLIENTE */
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCCaja.CodCli.
    /* CLIENTE */
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCCaja.NomCli.
    /* TERMINAL */
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCCaja.CodCaja.
    /* CAJERO */
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCCaja.Usuario.

    GET NEXT {&browse-name}.
END.
/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Liquidacion B-table-Win 
PROCEDURE Imprime-Liquidacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF AVAILABLE Ccbccaja AND Ccbccaja.Tipo = 'CANCELACION' 
    THEN RUN CCB\r-recibo3 (ROWID(CcbcCaja)).

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
  RUN get-attribute ('Keys-Accepted').
  IF RETURN-VALUE <> "" AND RETURN-VALUE <> ? THEN
      ASSIGN
          CMB-filtro:LIST-ITEMS IN FRAME {&FRAME-NAME} =
          CMB-filtro:LIST-ITEMS + "," + RETURN-VALUE.

  ASSIGN
      x-FchDoc-1 = TODAY - DAY(TODAY) + 1
      x-FchDoc-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia:
          x-Divisiones:ADD-LAST(gn-divi.coddiv + " " + GN-DIVI.DesDiv).
          IF gn-divi.coddiv = s-coddiv 
          THEN x-Divisiones:SCREEN-VALUE = gn-divi.coddiv + " " + GN-DIVI.DesDiv.
      END.
  END.

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
  SESSION:SET-WAIT-STATE('GENERAL').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  SESSION:SET-WAIT-STATE('').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key B-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

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
  {src/adm/template/snd-list.i "CcbCCaja"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION _FlgEst B-table-Win 
FUNCTION _FlgEst RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

IF Ccbccaja.FlgEst = 'A' THEN RETURN 'ANULADO'.
IF Ccbccaja.FlgCie = 'C' THEN RETURN 'CERRADO'.
RETURN "PENDIENTE".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

