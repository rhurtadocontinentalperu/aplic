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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

/* Local Variable Definitions ---                                       */
&SCOPED-DEFINE Condicion ( ~
    Faccpedi.codcia = s-codcia ~
    AND Faccpedi.coddiv = s-coddiv ~
    AND Faccpedi.coddoc = "OTR" ~
    AND Faccpedi.flgest = "P" ~
    AND Faccpedi.codref = "OPEN" ~
    )

DEF VAR x-Tiempo AS CHAR NO-UNDO.
DEF VAR x-peso AS DEC NO-UNDO INIT 0.00.
DEF VAR s-task-no AS INT.
DEF VAR i-nro        AS INTEGER NO-UNDO.

DEF STREAM REPORTE.

DEFINE BUFFER x-faccpedi FOR faccpedi.
DEFINE TEMP-TABLE tmp-w-report LIKE w-report.

DEF TEMP-TABLE Detalle NO-UNDO
    FIELD CodDoc LIKE Faccpedi.coddoc   LABEL 'Codigo'
    FIELD NroPed LIKE Faccpedi.nroped   LABEL 'Numero'
    FIELD NomCli LIKE Faccpedi.nomcli   LABEL 'Cliente'
    FIELD DirCli LIKE Faccpedi.dircli   LABEL 'Direccion'
    FIELD Bultos AS INTE FORMAT '>>>,>>9' LABEL 'Bultos'
    FIELD Items LIKE Faccpedi.items     LABEL 'Items'
    FIELD fchped LIKE Faccpedi.fchped  LABEL 'Fch.Emision'
    FIELD Peso LIKE Faccpedi.peso       LABEL 'Peso en kg'
    .

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
&Scoped-define INTERNAL-TABLES FacCPedi CcbCBult

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacCPedi.CodDoc FacCPedi.NroPed ~
FacCPedi.NomCli FacCPedi.DirCli CcbCBult.Bultos FacCPedi.Items ~
FacCPedi.FchPed FacCPedi.Peso 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST CcbCBult WHERE CcbCBult.CodCia = FacCPedi.CodCia ~
  AND CcbCBult.CodDiv = FacCPedi.CodDiv ~
  AND CcbCBult.CodDoc = FacCPedi.CodDoc ~
  AND CcbCBult.NroDoc = FacCPedi.NroPed NO-LOCK ~
    BY FacCPedi.NroPed DESCENDING
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST CcbCBult WHERE CcbCBult.CodCia = FacCPedi.CodCia ~
  AND CcbCBult.CodDiv = FacCPedi.CodDiv ~
  AND CcbCBult.CodDoc = FacCPedi.CodDoc ~
  AND CcbCBult.NroDoc = FacCPedi.NroPed NO-LOCK ~
    BY FacCPedi.NroPed DESCENDING.
&Scoped-define TABLES-IN-QUERY-br_table FacCPedi CcbCBult
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacCPedi
&Scoped-define SECOND-TABLE-IN-QUERY-br_table CcbCBult


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table BUTTON_Texto BUTTON-3 txtDesde ~
txtHasta BUTTON-Rotulo-2 
&Scoped-Define DISPLAYED-OBJECTS txtDesde txtHasta 

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
FchDoc|y||INTEGRAL.CcbCBult.FchDoc|no
NomCli|||INTEGRAL.CcbCBult.NomCli|yes
Dte_01|||INTEGRAL.CcbCBult.Dte_01|yes,INTEGRAL.CcbCBult.Chr_03|yes
patper|||INTEGRAL.PL-PERS.patper|yes,INTEGRAL.PL-PERS.matper|yes
NroDoc|||INTEGRAL.CcbCBult.NroDoc|yes
Chr_02|||INTEGRAL.CcbCBult.Chr_02|yes
nomper|||INTEGRAL.PL-PERS.nomper|yes,INTEGRAL.PL-PERS.patper|yes
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "':U + 'FchDoc,NomCli,Dte_01,patper,NroDoc,Chr_02,nomper' + '",
     SortBy-Case = ':U + 'FchDoc').

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).

/* This SmartObject is a valid SortBy-Target. */
&IF '{&user-supported-links}':U ne '':U &THEN
  &Scoped-define user-supported-links {&user-supported-links},SortBy-Target
&ELSE
  &Scoped-define user-supported-links SortBy-Target
&ENDIF

/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fGetItems B-table-Win 
FUNCTION fGetItems RETURNS INTEGER
  ( INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPeso B-table-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fTiempo B-table-Win 
FUNCTION fTiempo RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD lugar-entrega B-table-Win 
FUNCTION lugar-entrega RETURNS CHARACTER
  ( INPUT pCodPed AS CHAR, INPUT pNroPed AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-3 
     LABEL "Refrescar" 
     SIZE 13.72 BY 1.04.

DEFINE BUTTON BUTTON-Rotulo-2 
     LABEL "ROTULO en ZEBRA" 
     SIZE 17 BY 1.12.

DEFINE BUTTON BUTTON_Texto 
     LABEL "EXPORTAR A TEXTO" 
     SIZE 21 BY 1.12.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      FacCPedi, 
      CcbCBult SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacCPedi.CodDoc FORMAT "x(3)":U
      FacCPedi.NroPed COLUMN-LABEL "Numero" FORMAT "X(15)":U
      FacCPedi.NomCli COLUMN-LABEL "Cliente" FORMAT "x(100)":U
            WIDTH 60.43
      FacCPedi.DirCli FORMAT "x(100)":U WIDTH 32.43
      CcbCBult.Bultos FORMAT ">>>9":U WIDTH 6.43
      FacCPedi.Items FORMAT ">>>,>>9":U
      FacCPedi.FchPed COLUMN-LABEL "Fch.Emisión" FORMAT "99/99/9999":U
            WIDTH 9.43
      FacCPedi.Peso COLUMN-LABEL "Peso en kg" FORMAT "->>,>>9.9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 146.86 BY 21.85
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 2.62 COL 1.14
     BUTTON_Texto AT ROW 1.27 COL 103 WIDGET-ID 56
     BUTTON-3 AT ROW 1.27 COL 42 WIDGET-ID 54
     txtDesde AT ROW 1.27 COL 9 COLON-ALIGNED WIDGET-ID 34
     txtHasta AT ROW 1.27 COL 27.72 COLON-ALIGNED WIDGET-ID 36
     BUTTON-Rotulo-2 AT ROW 1.27 COL 124 WIDGET-ID 50
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
         HEIGHT             = 24.81
         WIDTH              = 155.57.
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
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.FacCPedi,INTEGRAL.CcbCBult WHERE INTEGRAL.FacCPedi ..."
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST"
     _OrdList          = "INTEGRAL.FacCPedi.NroPed|no"
     _Where[1]         = "{&Condicion}"
     _JoinCode[2]      = "CcbCBult.CodCia = FacCPedi.CodCia
  AND CcbCBult.CodDiv = FacCPedi.CodDiv
  AND CcbCBult.CodDoc = FacCPedi.CodDoc
  AND CcbCBult.NroDoc = FacCPedi.NroPed"
     _FldNameList[1]   = INTEGRAL.FacCPedi.CodDoc
     _FldNameList[2]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Numero" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "60.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.DirCli
"FacCPedi.DirCli" ? ? "character" ? ? ? ? ? ? no ? no no "32.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.CcbCBult.Bultos
"CcbCBult.Bultos" ? ">>>9" "integer" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacCPedi.Items
"FacCPedi.Items" ? ">>>,>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" "Fch.Emisión" ? "date" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.FacCPedi.Peso
"FacCPedi.Peso" "Peso en kg" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON START-SEARCH OF br_table IN FRAME F-Main
DO:
    DEFINE VARIABLE hSortColumn  AS WIDGET-HANDLE.
    DEFINE VARIABLE hQueryHandle AS HANDLE     NO-UNDO.
    hSortColumn = BROWSE {&BROWSE-NAME}:CURRENT-COLUMN.
    CASE hSortColumn:NAME:
        WHEN "Fchdoc" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'Fchdoc').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "nomcli" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'nomcli').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "nrodoc" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'NroDoc').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "Dte_01" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'Dte_01').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "Chr_02" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'Chr_02').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "nomper" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'nomper').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
    END CASE.
  
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


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 B-table-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Refrescar */
DO:
  
    ASSIGN txtDesde txtHasta.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Rotulo-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Rotulo-2 B-table-Win
ON CHOOSE OF BUTTON-Rotulo-2 IN FRAME F-Main /* ROTULO en ZEBRA */
DO:

    MESSAGE 'Seguro de Imprimir los ROTULOS en la ZEBRA?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.
    
    IF NOT AVAILABLE Faccpedi THEN RETURN.

    DEFINE VARIABLE iInt      AS INTEGER          NO-UNDO.
    DEFINE VARIABLE L-Ubica   AS LOGICAL INIT YES NO-UNDO.        
    /* Code placed here will execute PRIOR to standard behavior. */
    DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
    DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
    DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
    DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
    DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

    REPEAT WHILE L-Ubica:
           s-task-no = RANDOM(900000,999999).
           FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
           IF NOT AVAILABLE w-report THEN L-Ubica = NO.
    END.

    RUN imprime-rotulos.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Texto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Texto B-table-Win
ON CHOOSE OF BUTTON_Texto IN FRAME F-Main /* EXPORTAR A TEXTO */
DO:
  RUN Texto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtDesde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtDesde B-table-Win
ON LEAVE OF txtDesde IN FRAME F-Main /* Desde */
DO:
    ASSIGN {&self-name}.
    /*RUN dispatch IN THIS-PROCEDURE ('open-query':U).*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtHasta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtHasta B-table-Win
ON LEAVE OF txtHasta IN FRAME F-Main /* Hasta */
DO:
    ASSIGN {&self-name}.
    /*RUN dispatch IN THIS-PROCEDURE ('open-query':U).*/
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

  /* No Foreign keys are accepted by this SmartObject. */

  RUN get-attribute ('SortBy-Case':U).
  CASE RETURN-VALUE:
    WHEN 'FchDoc':U THEN DO:
      &Scope SORTBY-PHRASE BY CcbCBult.FchDoc DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'NomCli':U THEN DO:
      &Scope SORTBY-PHRASE BY CcbCBult.NomCli
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Dte_01':U THEN DO:
      &Scope SORTBY-PHRASE BY CcbCBult.Dte_01 BY CcbCBult.Chr_03
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'patper':U THEN DO:
      &Scope SORTBY-PHRASE BY PL-PERS.patper BY PL-PERS.matper
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'NroDoc':U THEN DO:
      &Scope SORTBY-PHRASE BY CcbCBult.NroDoc
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Chr_02':U THEN DO:
      &Scope SORTBY-PHRASE BY CcbCBult.Chr_02
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'nomper':U THEN DO:
      &Scope SORTBY-PHRASE BY PL-PERS.nomper BY PL-PERS.patper
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    OTHERWISE DO:
      &Undefine SORTBY-PHRASE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Datos B-table-Win 
PROCEDURE Carga-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR dPeso        AS INTEGER   NO-UNDO.
    DEFINE VAR cNomChq      AS CHARACTER NO-UNDO.
    DEFINE VAR cDir         AS CHARACTER NO-UNDO.
    DEFINE VAR cSede        AS CHARACTER NO-UNDO.
    DEFINE VAR dFactor      AS DECIMAL   NO-UNDO.

    cNomCHq = "".
    IF CcbCBult.Chr_02 <> "" THEN DO:
        FIND FIRST Pl-pers WHERE pl-pers.codcia = s-codcia
            AND Pl-pers.codper = CcbCBult.Chr_02 NO-LOCK NO-ERROR.
        IF AVAILABLE Pl-pers 
            THEN cNomCHq = Pl-pers.codper + "-" + TRIM(Pl-pers.patper) + ' ' +
                TRIM(Pl-pers.matper) + ',' + TRIM(PL-pers.nomper).                
    END.
    CASE Ccbcbult.coddoc:
        WHEN "O/D" OR WHEN "O/M" OR WHEN "OTR" THEN DO:
            FIND faccpedi WHERE faccpedi.codcia = s-codcia
                AND faccpedi.divdes = s-coddiv
                AND faccpedi.coddoc = Ccbcbult.coddoc
                AND faccpedi.nroped = Ccbcbult.nrodoc NO-LOCK NO-ERROR.
            IF NOT AVAIL faccpedi THEN DO:
                MESSAGE "Documento no registrado:" Ccbcbult.coddoc Ccbcbult.nrodoc
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                RETURN "ADM-ERROR".
            END.
            dPeso = 0.
/*             FOR EACH facdpedi OF faccpedi NO-LOCK,                 */
/*                 FIRST almmmatg OF facdpedi NO-LOCK:                */
/*               dPeso = dPeso + (facdpedi.canped * almmmatg.pesmat). */
/*             END.                                                   */
            dPeso = Faccpedi.Libre_d02.
            /*Datos Sede de Venta*/
            FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
                AND gn-divi.coddiv = faccpedi.coddiv NO-LOCK NO-ERROR.
            IF AVAIL gn-divi THEN 
                ASSIGN 
                    cDir = INTEGRAL.GN-DIVI.DirDiv
                    cSede = INTEGRAL.GN-DIVI.DesDiv.
            FIND Almacen WHERE Almacen.codcia = s-codcia
                AND Almacen.codalm = s-CodAlm
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almacen THEN cDir = Almacen.DirAlm.
            
            CREATE w-report.
            ASSIGN 
                w-report.Task-No  = s-task-no
                w-report.Llave-C  = "01" + faccpedi.nroped
                w-report.Campo-C[1] = faccpedi.ruc
                w-report.Campo-C[2] = faccpedi.nomcli
                w-report.Campo-C[3] = faccpedi.dircli
                w-report.Campo-C[4] = cNomChq
                w-report.Campo-D[1] = faccpedi.fchped
                w-report.Campo-C[5] = STRING(Ccbcbult.bultos)
                w-report.Campo-F[1] = dPeso
                w-report.Campo-C[7] = faccpedi.nroped
                w-report.Campo-I[1] = i-nro
                w-report.Campo-C[8] = cDir
                w-report.Campo-C[9] = cSede
                w-report.Campo-D[2] = faccpedi.fchent
                w-report.campo-c[13] = faccpedi.ordcmp.
        END.
        WHEN "TRA" THEN DO:
            FIND FIRST Almcmov WHERE Almcmov.codcia = s-codcia
                /*AND Almcmov.codalm = Ccbcbult.codcli*/
                AND Almcmov.codalm = s-codalm
                AND almcmov.tipmov = 'S'
                AND almcmov.codmov = 03
                AND almcmov.nroser = INTEGER(SUBSTRING (Ccbcbult.nrodoc, 1, 3) )
                AND almcmov.nrodoc = INTEGER(SUBSTRING (Ccbcbult.nrodoc, 4) )
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE almcmov
            THEN DO:
                MESSAGE 'Guia de transferencia no encontrada'
                    VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
            END.
            dPeso = 0.
            FOR EACH Almdmov OF Almcmov NO-LOCK, FIRST Almmmatg OF Almdmov NO-LOCK:
              dPeso = dPeso + (almdmov.candes * almdmov.factor * almmmatg.pesmat).
            END.
            /*Datos Sede de Venta*/
            FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
                AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.
            IF AVAIL gn-divi THEN 
                ASSIGN 
                    cDir = INTEGRAL.GN-DIVI.DirDiv
                    cSede = INTEGRAL.GN-DIVI.DesDiv.
            FIND Almacen WHERE Almacen.codcia = s-codcia
                AND Almacen.codalm = Almcmov.AlmDes
                NO-LOCK NO-ERROR.
            CREATE w-report.
            ASSIGN 
                w-report.Task-No  = s-task-no
                w-report.Llave-C  = "03" + STRING(Almcmov.nroser, '999') + STRING(Almcmov.nrodoc, '999999')
                w-report.Campo-C[1] = ""
                w-report.Campo-C[2] = Almacen.Descripcion
                w-report.Campo-C[3] = Almacen.DirAlm
                w-report.Campo-C[4] = cNomChq
                w-report.Campo-D[1] = almcmov.fchdoc
                w-report.Campo-C[5] = STRING(Ccbcbult.bultos)
                w-report.Campo-F[1] = dPeso
                w-report.Campo-C[7] = Ccbcbult.nrodoc
                w-report.Campo-I[1] = i-nro
                w-report.Campo-C[8] = cDir
                w-report.Campo-C[9] = cSede
                w-report.Campo-D[2] = almcmov.fchdoc.
        END.
        WHEN "G/R" THEN DO:
            FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia
                AND ccbcdocu.coddiv = s-coddiv
                AND ccbcdocu.coddoc = Ccbcbult.coddoc
                AND ccbcdocu.nrodoc = Ccbcbult.nrodoc NO-LOCK NO-ERROR.
            IF NOT AVAIL ccbcdocu THEN DO:
                MESSAGE "Documento no registrado"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                RETURN "adm-error".
            END.

            dPeso = 0.
            FOR EACH ccbddocu OF ccbcdocu NO-LOCK,
                FIRST almmmatg OF ccbddocu NO-LOCK:
                /*Busca Factor de Venta */
                FIND almtconv WHERE almtconv.codunid = almmmatg.undbas
                    AND almtconv.codalter = ccbddocu.undvta NO-LOCK NO-ERROR.
                IF AVAIL almtconv THEN dfactor = almtconv.equival.
                ELSE dfactor = 1.
                /************************/
              dPeso = dPeso + (CcbDDocu.CanDes * almmmatg.pesmat * dFactor).
            END.
            /*Datos Punto de Partida*/
            FIND FIRST almacen WHERE almacen.codcia = s-codcia
                AND almacen.codalm = ccbcdocu.codalm NO-LOCK NO-ERROR.
            IF AVAIL almacen THEN 
                ASSIGN 
                    cDir = Almacen.DirAlm
                    cSede = Almacen.Descripcion.
            
            CREATE w-report.
            ASSIGN 
                w-report.Task-No  = s-task-no
                w-report.Llave-C  = ccbcdocu.nroped
                w-report.Campo-C[1] = ccbcdocu.ruc
                w-report.Campo-C[2] = ccbcdocu.nomcli
                w-report.Campo-C[3] = ccbcdocu.dircli
                w-report.Campo-C[4] = cNomChq
                w-report.Campo-D[1] = ccbcdocu.libre_f02
                w-report.Campo-C[5] = STRING(Ccbcbult.bultos)
                w-report.Campo-F[1] = dPeso
                w-report.Campo-C[7] = ccbcdocu.nroped
                w-report.Campo-I[1] = i-nro
                w-report.Campo-C[8] = cDir
                w-report.Campo-C[9] = cSede
                w-report.Campo-D[2] = ccbcdocu.libre_f02.
        END.

    END CASE.
    RETURN 'OK'.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Datos-OD B-table-Win 
PROCEDURE Carga-Datos-OD :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR dPeso        AS INTEGER   NO-UNDO.
    DEFINE VAR cNomChq      AS CHARACTER NO-UNDO.
    DEFINE VAR cDir         AS CHARACTER NO-UNDO.
    DEFINE VAR cSede        AS CHARACTER NO-UNDO.
    DEFINE VAR dFactor      AS DECIMAL   NO-UNDO.

    DEFINE VAR lCodRef AS CHAR.
    DEFINE VAR lNroRef AS CHAR.
    DEFINE VAR lCodDoc AS CHAR.
    DEFINE VAR lNroDoc AS CHAR.

    DEFINE VAR lCodRef2 AS CHAR.
    DEFINE VAR lNroRef2 AS CHAR.

    DEFINE VAR x-almfinal AS CHAR.
    DEFINE VAR x-cliente-final AS CHAR.
    DEFINE VAR x-cliente-intermedio AS CHAR.
    DEFINE VAR x-direccion-final AS CHAR.
    DEFINE VAR x-direccion-intermedio AS CHAR.

    DEFINE BUFFER x-almacen FOR almacen.
    DEFINE BUFFER x-pedido FOR faccpedi.
    DEFINE BUFFER x-cotizacion FOR faccpedi.

    DEFINE VAR x-lugar-entrega AS CHAR.
    DEFINE VAR x-referencia AS CHAR.
    DEFINE VAR x-ubigeo AS CHAR.

    i-nro = 0.
    FOR EACH ControlOD NO-LOCK WHERE ControlOD.CodCia = CcbCBult.CodCia 
        AND ControlOD.CodDiv = CcbCBult.CodDiv 
        AND ControlOD.CodDoc = CcbCBult.CodDoc 
        AND ControlOD.NroDoc = CcbCBult.NroDoc:

        cNomCHq = "".
        lCodDoc = "".
        lNroDoc = "".
        IF CcbCBult.Chr_02 <> "" THEN DO:
            FIND FIRST Pl-pers WHERE pl-pers.codcia = s-codcia
                AND Pl-pers.codper = CcbCBult.Chr_02 NO-LOCK NO-ERROR.
            IF AVAILABLE Pl-pers 
                THEN cNomCHq = Pl-pers.codper + "-" + TRIM(Pl-pers.patper) + ' ' +
                    TRIM(Pl-pers.matper) + ',' + TRIM(PL-pers.nomper).                
        END.
        /* O/D, OTR, O/M */
        FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia
            AND faccpedi.divdes = s-coddiv
            AND faccpedi.coddoc = Ccbcbult.coddoc
            AND faccpedi.nroped = Ccbcbult.nrodoc NO-LOCK NO-ERROR.
        IF NOT AVAIL faccpedi THEN DO:
            MESSAGE "Documento no registrado:" Ccbcbult.coddoc Ccbcbult.nrodoc
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN "ADM-ERROR".
        END.
        dPeso = ControlOD.PesArt.
        lCodRef2 = Ccbcbult.coddoc.
        lNroRef2 = Ccbcbult.nrodoc.

        RUN lugar-de-entrega(INPUT faccpedi.codref, INPUT faccpedi.nroref, 
                             OUTPUT x-lugar-entrega, OUTPUT x-ubigeo, OUTPUT x-referencia).

        x-cliente-final = faccpedi.nomcli.
        /*x-direccion-final = faccpedi.dircli.*/
        x-direccion-final = x-lugar-entrega.

        x-cliente-intermedio = "".
        x-direccion-intermedio = "".

        /* CrossDocking almacen FINAL */
        x-almfinal = "".
        IF faccpedi.crossdocking = YES THEN DO:
            lCodRef2 = faccpedi.codref.
            lNroRef2 = faccpedi.nroref.
            lCodDoc = "(" + Ccbcbult.coddoc.
            lNroDoc = Ccbcbult.nrodoc + ")".

            x-cliente-intermedio = faccpedi.codcli + " " + faccpedi.nomcli.
            x-direccion-intermedio = faccpedi.dircli.

            IF faccpedi.codref = 'R/A' THEN DO:
                FIND FIRST x-almacen WHERE x-almacen.codcia = s-codcia AND 
                                            x-almacen.codalm = faccpedi.almacenxD
                                            NO-LOCK NO-ERROR.
                IF AVAILABLE x-almacen THEN x-cliente-final = TRIM(x-almacen.descripcion). /*x-almfinal = TRIM(x-almacen.descripcion).*/
                IF AVAILABLE x-almacen THEN x-direccion-final = TRIM(x-almacen.diralm). /*x-almfinal = TRIM(x-almacen.descripcion).*/
            END.
        END.

        /* Ic - 02Dic2016, si es OTR verificar si no proviene de una PED (pedido) */
        /* Si viene de un PED, los datos del cliente deben salir del PEDIDO */
        /* Crossdocking */
        IF faccpedi.coddoc = 'OTR' AND faccpedi.codref = 'PED' THEN DO:
            lCodDoc = "(" + Ccbcbult.coddoc.
            lNroDoc = Ccbcbult.nrodoc + ")".
            lCodRef = faccpedi.codref.
            lNroRef = faccpedi.nroref.
            RELEASE faccpedi.

            FIND faccpedi WHERE faccpedi.codcia = s-codcia
                AND faccpedi.coddoc = lCodRef
                AND faccpedi.nroped = lNroRef
                NO-LOCK NO-ERROR.
            IF NOT AVAIL faccpedi THEN DO:
                MESSAGE "Pedido de Referencia de la OTR no existe" lCodRef lNroRef
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                RETURN "ADM-ERROR".
            END.
            x-cliente-final = "".
            IF CcbCBult.CodDoc = 'OTR' THEN x-cliente-final = faccpedi.codcli + " ".
            x-cliente-final = x-cliente-final + faccpedi.nomcli.
            x-direccion-final = faccpedi.dircli.
        END.
        /* Ic - 02Dic2016 - FIN */

        /*Datos Sede de Venta*/
        FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
            AND gn-divi.coddiv = faccpedi.coddiv NO-LOCK NO-ERROR.
        IF AVAIL gn-divi THEN 
            ASSIGN 
                cDir = INTEGRAL.GN-DIVI.DirDiv
                cSede = GN-DIVI.CodDiv + " " + INTEGRAL.GN-DIVI.DesDiv.
        FIND Almacen WHERE Almacen.codcia = s-codcia
            AND Almacen.codalm = s-CodAlm
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almacen THEN cDir = Almacen.DirAlm.

        CREATE w-report.
        ASSIGN 
            i-nro             = i-nro + 1
            w-report.Task-No  = s-task-no
            w-report.Llave-C  = "01" + faccpedi.nroped
            w-report.Campo-C[1] = faccpedi.ruc
            w-report.Campo-C[2] = x-cliente-final   /*faccpedi.nomcli*/
            w-report.Campo-C[3] = x-direccion-final   /*faccpedi.dircli*/
            w-report.Campo-C[4] = cNomChq
            w-report.Campo-D[1] = faccpedi.fchped
            w-report.Campo-C[5] = STRING(Ccbcbult.bultos,'9999')
            w-report.Campo-F[1] = dPeso
            w-report.Campo-C[7] = lCodRef2 + "-" + lNroRef2 /*faccpedi.nroped*/
            w-report.Campo-I[1] = i-nro
            w-report.Campo-C[8] = cDir
            w-report.Campo-C[9] = cSede
            w-report.Campo-C[10] = ControlOD.NroEtq
            w-report.Campo-D[2] = faccpedi.fchent
            w-report.campo-c[11] = TRIM(lCodDoc + " " + lNroDoc)
            w-report.campo-c[12] = x-cliente-intermedio   /*x-almfinal.*/
            w-report.campo-c[13] = faccpedi.ordcmp.

            /* Ic - 15Feb2018, jalar la Nro de Orden de Iversa, ListaExpree */
            /*MESSAGE "pedido" faccpedi.nroref.*/
            IF s-coddiv = '00506' THEN DO:
                /* Busco el Pedido */
                FIND FIRST x-pedido WHERE x-pedido.codcia = s-codcia AND 
                                            x-pedido.coddoc = faccpedi.codref AND 
                                            x-pedido.nroped = faccpedi.nroref NO-LOCK NO-ERROR.
                IF AVAILABLE x-pedido THEN DO:
                    /*MESSAGE "cotizacion" x-pedido.nroref.*/
                    /* Busco la Cotizacion */
                    FIND FIRST x-cotizacion WHERE x-cotizacion.codcia = s-codcia AND 
                                                x-cotizacion.coddoc = x-pedido.codref AND 
                                                x-cotizacion.nroped = x-pedido.nroref NO-LOCK NO-ERROR.
                    IF AVAILABLE x-cotizacion THEN DO:
                        /*MESSAGE "Ref " x-cotizacion.nroref.*/
                        ASSIGN w-report.campo-c[12] = "PEDIDO WEB :" + TRIM(x-cotizacion.nroref).
                    END.
                END.
            END.

    END.
    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Packing-OD B-table-Win 
PROCEDURE Carga-Packing-OD :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR cCodEAN AS CHARACTER.
DEF VAR iInt AS INT NO-UNDO.

IF s-task-no = 0 THEN DO:
    CORRELATIVO:
    REPEAT:
        s-task-no = RANDOM(1,999999).
        FIND FIRST w-report WHERE task-no = s-task-no NO-LOCK NO-ERROR.
        IF NOT AVAILABLE w-report THEN LEAVE CORRELATIVO.
    END.
END.

FOR EACH Vtaddocu NO-LOCK WHERE VtaDDocu.CodCia =  CcbCBult.CodCia
    AND VtaDDocu.CodDiv = s-CodDiv
    AND VtaDDocu.CodPed = CcbCBult.CodDoc
    AND VtaDDocu.NroPed = CcbCBult.NroDoc,
    FIRST Almmmatg OF Vtaddocu NO-LOCK
    BREAK BY VtaDDocu.Libre_c01 BY VtaDDocu.NroItm:
    IF FIRST-OF(VtaDDocu.Libre_c01) THEN iInt = iInt + 1.     
    RUN Vta\R-CalCodEAN.p (INPUT Almmmatg.CodBrr, OUTPUT cCodEan).
    CREATE w-report.
    ASSIGN
        w-report.Task-No    = s-task-no 
        w-report.Llave-I    = iInt
        w-report.Campo-C[1] = CcbCBult.OrdCmp
        w-report.Campo-C[5] = CcbCBult.CodDoc
        w-report.Campo-C[6] = CcbCBult.NroDoc
        w-report.Campo-C[7] = Vtaddocu.CodMat
        w-report.Campo-C[8] = Almmmatg.DesMat
        w-report.Campo-C[9] = cCodEan        
        w-report.Campo-C[10] = Almmmatg.CodBrr 
        w-report.Campo-C[11] = VtaDDocu.Libre_c01
        /* Ic - 22Set2015 */
        w-report.Campo-C[25] = trim(CcbCBult.codcli) + " " + CcbCBult.nomcli
        /* Ic - 22Set2015 */
        w-report.Campo-I[1] = iInt
        w-report.Campo-I[2] = CcbCBult.Bultos
        w-report.Campo-F[2] = VtaDDocu.CanPed
        w-report.Campo-F[3] = VtaDDocu.PesMat
        w-report.Campo-I[3] = VtaDDocu.CanPed
        w-report.Campo-I[4] = s-codcia.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gen-Excel B-table-Win 
PROCEDURE gen-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE BUFFER x-faccpedi FOR faccpedi.

        DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
        DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
        DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

        DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

        DEFINE VARIABLE iCount                  AS INTEGER init 1.
        DEFINE VARIABLE iIndex                  AS INTEGER.
        DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
        DEFINE VARIABLE cColumn                 AS CHARACTER.
        DEFINE VARIABLE cRange                  AS CHARACTER.
        DEFINE VARIABLE x-signo                 AS DECI.

        DEFINE VAR lItems AS INT.

        /* create a new Excel Application object */
        CREATE "Excel.Application" chExcelApplication.

        /* launch Excel so it is visible to the user */
        chExcelApplication:Visible = FALSE.

        /* Para crear a new Workbook */
        chWorkbook = chExcelApplication:Workbooks:Add().

        /* get the active Worksheet */
        chWorkSheet = chExcelApplication:Sheets:Item(1).

        chWorkSheet:Range("A1:R1"):Font:Bold = TRUE.
        chWorkSheet:Range("A1"):Value = "CODIGO".
        chWorkSheet:Range("B1"):Value = "Numero".
        chWorkSheet:Range("C1"):Value = "Nombre".
        chWorkSheet:Range("D1"):Value = "Direccion entrega".
        chWorkSheet:Range("E1"):Value = "Bultos".
        chWorkSheet:Range("F1"):Value = "Fecha Rotulado".
        chWorkSheet:Range("G1"):Value = "Chequedor".
        chWorkSheet:Range("H1"):Value = "AP. Paterno".
        chWorkSheet:Range("I1"):Value = "Ap. Materno".
        chWorkSheet:Range("J1"):Value = "Nombres".
        chWorkSheet:Range("K1"):Value = "Dia Chequeo".
        chWorkSheet:Range("L1"):Value = "Hora".
        chWorkSheet:Range("M1"):Value = "Tiempo".
        chWorkSheet:Range("N1"):Value = "Peso".
        chWorkSheet:Range("O1"):Value = "Items".


        chExcelApplication:DisplayAlerts = False.
/*      chExcelApplication:Quit().*/

    SESSION:SET-WAIT-STATE('GENERAL').
    iColumn = 1.        
    GET FIRST {&BROWSE-NAME}.
    DO  WHILE AVAILABLE CcbCBult:

        FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = ccbcbult.codcia AND
                                x-faccpedi.coddoc = ccbcbult.coddoc AND
                                x-faccpedi.nroped = ccbcbult.nrodoc
                                NO-LOCK NO-ERROR.
    
             iColumn = iColumn + 1.
             cColumn = STRING(iColumn).

             cRange = "A" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + CcbCBult.CodDoc.
         cRange = "B" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + CcbCBult.NroDoc.
         cRange = "C" + cColumn.
         chWorkSheet:Range(cRange):Value = CcbCBult.NomCli.
         cRange = "D" + cColumn.
         chWorkSheet:Range(cRange):Value = IF(AVAILABLE x-faccpedi) THEN x-faccpedi.dircli ELSE "".
         cRange = "E" + cColumn.
         chWorkSheet:Range(cRange):Value = CcbCBult.Bultos.
         cRange = "F" + cColumn.
         chWorkSheet:Range(cRange):Value = CcbCBult.FchDoc.
         cRange = "G" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + CcbCBult.Chr_02.
         cRange = "H" + cColumn.
         chWorkSheet:Range(cRange):Value = pl-pers.patper.
         cRange = "I" + cColumn.
         chWorkSheet:Range(cRange):Value = pl-pers.matper.
         cRange = "J" + cColumn.
         chWorkSheet:Range(cRange):Value = pl-pers.nomper.
         cRange = "K" + cColumn.
         chWorkSheet:Range(cRange):Value = CcbCBult.Dte_01.
         cRange = "L" + cColumn.
         chWorkSheet:Range(cRange):Value = CcbCBult.Chr_03.

         x-Tiempo = ''.
         RUN lib/_time-passed ( DATETIME(STRING(Ccbcbult.dte_02) + ' ' + STRING(Ccbcbult.CHR_04)),
                                     DATETIME(STRING(Ccbcbult.dte_01) + ' ' + STRING(Ccbcbult.CHR_03)), OUTPUT x-Tiempo).

         x-Tiempo = CAPS(x-Tiempo).
         x-Tiempo = REPLACE(x-Tiempo,"M",":").
         x-Tiempo = REPLACE(x-Tiempo,"S","").
         x-Tiempo = REPLACE(x-Tiempo," ","").
         IF LENGTH(x-Tiempo) <= 2 AND  INDEX(x-tiempo,":") = 0 THEN x-Tiempo = "00:" + x-Tiempo.


         IF LENGTH(SUBSTRING(x-Tiempo,1,INDEX(x-tiempo,":") - 1)) < 2  THEN DO:
             x-tiempo = "0" + x-tiempo.
         END.
         IF LENGTH(SUBSTRING(x-Tiempo,INDEX(x-tiempo,":") + 1)) < 2  THEN DO:
             x-tiempo = SUBSTRING(x-Tiempo,1,INDEX(x-tiempo,":")) + "0" + 
                        SUBSTRING(x-Tiempo,INDEX(x-tiempo,":") + 1).             
         END.
         IF LENGTH(SUBSTRING(x-Tiempo,INDEX(x-tiempo,":") + 1)) < 2  THEN DO:
             x-tiempo = SUBSTRING(x-Tiempo,1,INDEX(x-tiempo,":")) + "0" + 
                        SUBSTRING(x-Tiempo,INDEX(x-tiempo,":") + 1).             
         END.

         x-peso = fPeso().
         cRange = "M" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + x-Tiempo.
         cRange = "N" + cColumn.
         chWorkSheet:Range(cRange):Value = x-peso.       

         lItems = fGetItems(CcbCBult.CodDoc, CcbCBult.NroDoc).
         cRange = "O" + cColumn.
         chWorkSheet:Range(cRange):Value = lItems.       


        GET NEXT {&BROWSE-NAME}.
    END.  
          
    chExcelApplication:Visible = TRUE.

        /* release com-handles */
        RELEASE OBJECT chExcelApplication NO-ERROR.      
        RELEASE OBJECT chWorkbook NO-ERROR.
        RELEASE OBJECT chWorksheet NO-ERROR.
        RELEASE OBJECT chWorksheetRange NO-ERROR. 

    SESSION:SET-WAIT-STATE('').

        MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime-rotulos B-table-Win 
PROCEDURE imprime-rotulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR hProc AS HANDLE.

    RUN logis/logis-library.r PERSISTENT SET hProc.

    /* Imprimir el Rotulos de la orden */
    RUN imprimir-rotulos-por-otr IN hProc (INPUT Faccpedi.coddiv, 
                                           INPUT Faccpedi.Coddoc, 
                                           INPUT Faccpedi.NroPed,
                                           INPUT TABLE tmp-w-report).
    DELETE OBJECT hProc.

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
  ASSIGN
      txtDesde = TODAY - DAY(TODAY) + 1
      txtHasta = TODAY.

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

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lugar-de-entrega B-table-Win 
PROCEDURE lugar-de-entrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodPed AS CHAR. /* PED,O/D, OTR */
DEFINE INPUT PARAMETER pNroPed AS CHAR.
DEFINE OUTPUT PARAMETER pLugEnt AS CHAR.
DEFINE OUTPUT PARAMETER pUbigeo AS CHAR.
DEFINE OUTPUT PARAMETER pRefer AS CHAR.

pLugEnt = lugar-entrega(pCodPed, pNroped).
pUbigeo = "||".
pRefer = "".

FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                    x-faccpedi.coddoc = pCodPed AND
                    x-faccpedi.nroped = pNroped NO-LOCK NO-ERROR.
IF AVAILABLE x-faccpedi THEN DO:
    FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND
        gn-clie.codcli = x-Faccpedi.codcli NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN DO:       
        FIND FIRST gn-clied OF gn-clie WHERE Gn-ClieD.Sede = x-Faccpedi.Ubigeo[1]
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clied THEN DO:
            pRefer = TRIM(gn-clieD.referencias).
            pUbigeo = TRIM(gn-clied.coddept) + "|" + TRIM(gn-clied.codprov) + "|" + TRIM(gn-clied.coddist).
        END.            
    END.

END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rotulo-zebra B-table-Win 
PROCEDURE rotulo-zebra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER ptask-no AS INT NO-UNDO.

FIND FIRST w-report WHERE w-report.task-no = ptask-no NO-LOCK NO-ERROR.
IF NOT AVAILABLE w-report THEN DO:
    RETURN.
END.

DEFINE VAR lDireccion1 AS CHAR.
DEFINE VAR lDireccion2 AS CHAR.
DEFINE VAR lDirPart1 AS CHAR.
DEFINE VAR lDirPart2 AS CHAR.
DEFINE VAR lbarra AS CHAR.
DEFINE VAR lSede AS CHAR.
DEFINE VAR lRuc AS CHAR.
DEFINE VAR lpedido AS CHAR.
DEFINE VAR lCliente AS CHAR.
DEFINE VAR lChequeador AS CHAR.
DEFINE VAR lFecha AS DATE.
DEFINE VAR lFechaEnt AS DATE.
DEFINE VAR lEtiqueta AS CHAR.
DEFINE VAR lpeso AS DEC.
DEFINE VAR lBultos AS CHAR.
DEFINE VAR lFiler AS CHAR.
DEFINE VAR lRefOtr AS CHAR.
DEFINE VAR x-almfinal AS CHAR.

DEFINE VAR lOrdenCompra AS CHAR.

DEFINE VAR rpta AS LOG.

DEFINE VAR x-impresora AS LOG.

x-impresora = YES.

IF USERID("DICTDB") = "CIRH" OR USERID("DICTDB") = "MASTER" OR USERID("DICTDB") = "ADMIN" THEN DO:

    /* ---------------------------------------- */
    DEFINE VAR x-file-zpl AS CHAR.
    
    x-file-zpl = SESSION:TEMP-DIRECTORY + REPLACE("HPK","/","") + "-" + "PRUEBA" + ".txt".
    
    OUTPUT STREAM REPORTE TO VALUE(x-file-zpl).

END.
ELSE DO:
    IF x-impresora = YES THEN DO:
        SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
        IF rpta = NO THEN RETURN.
    
        OUTPUT STREAM REPORTE TO PRINTER.
    END.
    ELSE DO:
    
        DEFINE VAR x-archivo AS CHAR.
    
        x-archivo = SESSION:TEMP-DIRECTORY.
        x-archivo = x-archivo + "rotulo.txt".
    
        OUTPUT STREAM REPORTE TO VALUE(x-Archivo).
    END.
END.

FOR EACH w-report WHERE w-report.task-no = ptask-no NO-LOCK:

    /* Los valores */
    lDireccion1 = w-report.campo-c[8].
    lSede = w-report.campo-c[9].
    lRuc = w-report.campo-c[1].
    lPedido = w-report.campo-c[7].
    lCliente = w-report.campo-c[2].
    lDireccion2 = w-report.campo-c[3].
    lChequeador = w-report.campo-c[4].
    lFecha = w-report.campo-d[1].
    lFechaEnt = w-report.campo-d[2].
    lEtiqueta = w-report.campo-c[10].
    lPeso = w-report.campo-f[1].
    lBultos = STRING(w-report.campo-i[1],"9999") + " / " + w-report.campo-c[5].
    lBarra = STRING(w-report.llave-c,"99999999999") + STRING(w-report.campo-i[1],"9999").
    lFiler = "F-OPE-01-01".
    lRefOtr = TRIM(w-report.campo-c[11]).
    lOrdenCompra = TRIM(w-report.campo-c[13]).

    IF NOT (TRUE <> (lOrdenCompra > "")) THEN lOrdenCompra = "O/C.:" + lOrdenCompra.

    /* Ic - 10Set2018, realmente es el destino Intermedio */
    x-almfinal = TRIM(w-report.campo-c[12]).
    IF s-coddiv <> '00506' THEN DO:
        IF x-almfinal <> "" THEN x-almfinal = "D.INTERMEDIO:" + x-almfinal.
    END.    

    lDireccion2 = TRIM(lDireccion2) + FILL(" ",90).
    lDirPart1 = SUBSTRING(lDireccion2,1,45).
    lDirPart2 = SUBSTRING(lDireccion2,46).

    PUT STREAM REPORTE "^XA^LH010,010" SKIP.

    PUT STREAM REPORTE "^FO025,20" SKIP.
    PUT STREAM REPORTE "^ADN,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "CONTINENTAL S.A.C." SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,080" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Direccion:" + lDireccion1 FORMAT 'x(67)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,110" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Sede :" + lSede FORMAT 'x(60)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO690,030^BY2" SKIP.
    PUT STREAM REPORTE "^B3R,N,80,N" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lBarra FORMAT 'x(15)' SKIP.
    PUT STREAM REPORTE "^FS".

    PUT STREAM REPORTE "^FO035,150" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Nro. " + lPedido FORMAT 'x(40)' SKIP.
    PUT STREAM REPORTE "^FS".

    PUT STREAM REPORTE "^FO400,150" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "RUC:" + lRuc FORMAT 'x(16)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,200" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "DESTINO" FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO400,200" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lOrdenCompra FORMAT 'x(30)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,230" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lCliente FORMAT 'x(50)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,270" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.  
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lDirPart1 FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,300" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lDirPart2 FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,350" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Chequeador :" + lChequeador FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,400" SKIP.
    PUT STREAM REPORTE "^A0N,35,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Fecha :" + STRING(lFecha,"99/99/9999") FORMAT 'x(18)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO350,400" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Etiqueta :" + lEtiqueta FORMAT 'x(28)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,450" SKIP.
    PUT STREAM REPORTE "^A0N,35,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "BULTOS :" + lbultos FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO350,450" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "PESO :" + STRING(lPeso,"ZZ,ZZZ,ZZ9.99") FORMAT 'x(19)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,500" SKIP.
    PUT STREAM REPORTE "^A0N,35,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Entrega :" + STRING(lFechaEnt,"99/99/9999") FORMAT 'x(20)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /*
    PUT STREAM REPORTE "^FO400,500" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lFiler FORMAT 'x(15)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    */
    PUT STREAM REPORTE "^FO350,500" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lRefOtr FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.


    PUT STREAM REPORTE "^FO035,550" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE x-almfinal FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    /*
    PUT STREAM REPORTE "^FO035,550" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lRefOtr FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    */
    /*
    PUT STREAM REPORTE "^FO400,550" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lFiler FORMAT 'x(15)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    */
    PUT STREAM REPORTE "^XZ" SKIP.
END.

OUTPUT STREAM REPORTE CLOSE.

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
  {src/adm/template/snd-list.i "FacCPedi"}
  {src/adm/template/snd-list.i "CcbCBult"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto B-table-Win 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Pantalla de Impresión */
    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
    DEF VAR cArchivo AS CHAR.

    RUN lib/tt-file-to-onlytext (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    SESSION:SET-WAIT-STATE('GENERAL').
    EMPTY TEMP-TABLE Detalle.
    GET FIRST {&browse-name}.
    DO WHILE NOT QUERY-OFF-END("{&browse-name}"):
        CREATE Detalle.
        ASSIGN
            Detalle.coddoc = Faccpedi.coddoc
            Detalle.nroped = Faccpedi.nroped
            Detalle.nomcli = Faccpedi.nomcli
            Detalle.dircli = Faccpedi.dircli
            Detalle.bultos = Ccbcbult.bultos
            Detalle.items = Faccpedi.items
            Detalle.fchped = Faccpedi.fchped
            Detalle.peso = Faccpedi.peso.
        GET NEXT {&browse-name}.
    END.
    SESSION:SET-WAIT-STATE('').

    FIND FIRST Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    cArchivo = LC(pArchivo).
    SESSION:SET-WAIT-STATE('GENERAL').
    IF INDEX(pOptions, 'FileType:XLS') > 0 THEN SESSION:DATE-FORMAT = "mdy".
    RUN lib/tt-filev2 (TEMP-TABLE Detalle:HANDLE, cArchivo, pOptions).
    SESSION:DATE-FORMAT = "dmy".
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    MESSAGE 'Fin de la exportación' VIEW-AS ALERT-BOX INFORMATION.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fGetItems B-table-Win 
FUNCTION fGetItems RETURNS INTEGER
  ( INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR lRetval AS INT.

    lRetVal = 0.
    FOR EACH facdpedi WHERE facdpedi.codcia = s-codcia AND 
                            facdpedi.coddoc = pCodDoc AND
                            facdpedi.nroped = pNroDoc
                            NO-LOCK:
        lRetVal = lRetVal + 1.
    END.

  RETURN lRetVal.   /* Function return value. */

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
DEFINE VAR lRetVal AS DEC INIT 0.00.

IF CcbCBult.CodDoc = 'O/D' OR CcbCBult.CodDoc = 'O/M' OR
    CcbCBult.CodDoc = 'OTR' THEN DO:
    /*
    FOR EACH ControlOD NO-LOCK WHERE ControlOD.CodCia = CcbCBult.CodCia 
        AND ControlOD.CodDiv = CcbCBult.CodDiv 
        AND ControlOD.CodDoc = CcbCBult.CodDoc 
        AND ControlOD.NroDoc = CcbCBult.NroDoc :

        lRetVal = lRetVal + ControlOD.PesArt.

    END.
    */
    FOR EACH facdpedi WHERE facdpedi.codcia = s-codcia AND 
                            facdpedi.coddoc = CcbCBult.CodDoc AND
                            facdpedi.nroped = CcbCBult.NroDoc
                            NO-LOCK, FIRST Almmmatg OF facdpedi NO-LOCK:
        lRetVal = lRetVal + (facdpedi.canped * facdpedi.factor * almmmatg.pesmat).
    END.

END.
ELSE DO:
    FIND FIRST Almcmov WHERE Almcmov.codcia = s-codcia
        AND Almcmov.codalm = s-codalm
        AND almcmov.tipmov = 'S'
        AND almcmov.codmov = 03
        AND almcmov.nroser = INTEGER(SUBSTRING (Ccbcbult.nrodoc, 1, 3) )
        AND almcmov.nrodoc = INTEGER(SUBSTRING (Ccbcbult.nrodoc, 4) )
        NO-LOCK NO-ERROR.
    IF AVAILABLE almcmov THEN DO:
        FOR EACH Almdmov OF Almcmov NO-LOCK, FIRST Almmmatg OF Almdmov NO-LOCK:
          lRetVal = lRetVal + (almdmov.candes * almdmov.factor * almmmatg.pesmat).
        END.
    END.
END.

  RETURN lRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fTiempo B-table-Win 
FUNCTION fTiempo RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RUN lib/_time-passed ( DATETIME(STRING(Ccbcbult.dte_02) + ' ' + STRING(Ccbcbult.CHR_04)),
                              DATETIME(STRING(Ccbcbult.dte_01) + ' ' + STRING(Ccbcbult.CHR_03)), OUTPUT x-Tiempo).
  RETURN x-Tiempo.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION lugar-entrega B-table-Win 
FUNCTION lugar-entrega RETURNS CHARACTER
  ( INPUT pCodPed AS CHAR, INPUT pNroPed AS CHAR ) :

    DEFINE VAR x-retval AS CHAR INIT "".

    FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                            x-faccpedi.coddoc = pCodPed AND
                            x-faccpedi.nroped = pNroped NO-LOCK NO-ERROR.

    IF AVAILABLE x-faccpedi THEN DO:
    
        FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND
            gn-clie.codcli = x-Faccpedi.codcli
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            x-retval = "".  /*gn-clie.dircli.*/
            FIND FIRST gn-clied OF gn-clie WHERE Gn-ClieD.Sede = x-Faccpedi.Ubigeo[1]
                NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clied THEN x-retval = Gn-ClieD.DirCli.
        END.
    END.

  RETURN x-retval.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

