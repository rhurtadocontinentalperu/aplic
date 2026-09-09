&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER b-ExpAsist FOR ExpAsist.



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
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
/* DEF SHARED VAR pCodDiv AS CHAR.     /* Lista de Precios */ */
DEF SHARED VAR s-user-id AS CHAR.

DEFINE VARIABLE cDesEst AS CHARACTER NO-UNDO.
DEFINE VARIABLE BuscaNueva AS LOG INIT YES NO-UNDO.

/* &SCOPED-DEFINE CONDICION ( ExpAsist.CodCia = S-CODCIA  AND ~ */
/*              ExpAsist.CodDiv = pCodDiv AND ~                 */
/*              ExpAsist.Estado[1] <> 'A' AND ~                 */
/*              LOOKUP(ExpAsist.Estado[2],'L,N') > 0 )          */

&SCOPED-DEFINE CONDICION ( ExpAsist.CodCia = S-CODCIA  AND ~
             ExpAsist.CodDiv = s-CodDiv AND ~
             ExpAsist.Estado[1] <> 'A' AND ~
             LOOKUP(ExpAsist.Estado[2],'L,N') > 0 )

&SCOPED-DEFINE FECHAASIS ExpAsist.fecha 

{src/bin/_prns.i}

DEF STREAM REPORTE.

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
&Scoped-define INTERNAL-TABLES ExpAsist gn-clie

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table ExpAsist.Libre_c03 ExpAsist.CodCli ~
ExpAsist.NomCli gn-clie.Ruc gn-clie.NroCard ExpAsist.FecPro ~
ExpAsist.HoraPro ExpAsist.FecAsi[1] ExpAsist.HoraAsi[1] ExpAsist.FecAsi[2] ~
ExpAsist.HoraAsi[2] ExpAsist.FecAsi[3] ExpAsist.HoraAsi[3] ~
IF (ExpAsist.Estado[1] = 'C' ) THEN ('Asistio') ELSE ('Ausente') @ cDesEst 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH ExpAsist WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST gn-clie WHERE gn-clie.CodCli = ExpAsist.CodCli ~
  AND gn-clie.CodCia = cl-codcia OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH ExpAsist WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST gn-clie WHERE gn-clie.CodCli = ExpAsist.CodCli ~
  AND gn-clie.CodCia = cl-codcia OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table ExpAsist gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-br_table ExpAsist
&Scoped-define SECOND-TABLE-IN-QUERY-br_table gn-clie


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-Buscar BUTTON-4 BUTTON-5 br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Buscar 

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
CodCli|||INTEGRAL.ExpAsist.CodCia|yes,INTEGRAL.ExpAsist.CodDiv|yes,INTEGRAL.ExpAsist.CodCli|yes
Primero|y||INTEGRAL.ExpAsist.CodCia|yes,INTEGRAL.ExpAsist.CodDiv|yes,INTEGRAL.ExpAsist.Fecha|yes,INTEGRAL.ExpAsist.CodCli|yes
NomCli|||INTEGRAL.ExpAsist.NomCli|yes
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "':U + 'CodCli,Primero,NomCli' + '",
     SortBy-Case = ':U + 'Primero').

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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-4 
     LABEL "Anterior" 
     SIZE 10 BY .81.

DEFINE BUTTON BUTTON-5 
     LABEL "Siguiente" 
     SIZE 10 BY .81.

DEFINE VARIABLE FILL-IN-Buscar AS CHARACTER FORMAT "X(256)":U 
     LABEL "Buscar" 
     VIEW-AS FILL-IN 
     SIZE 24 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      ExpAsist, 
      gn-clie
    FIELDS(gn-clie.Ruc
      gn-clie.NroCard) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      ExpAsist.Libre_c03 COLUMN-LABEL "Tipo" FORMAT "x(3)":U
      ExpAsist.CodCli COLUMN-LABEL "Código" FORMAT "X(11)":U WIDTH 10.43
      ExpAsist.NomCli FORMAT "x(40)":U WIDTH 37.43
      gn-clie.Ruc COLUMN-LABEL "RUC" FORMAT "x(11)":U WIDTH 11.43
      gn-clie.NroCard COLUMN-LABEL "Nº Card" FORMAT "x(8)":U
      ExpAsist.FecPro COLUMN-LABEL "Fecha!Programada" FORMAT "99/99/9999":U
      ExpAsist.HoraPro COLUMN-LABEL "Hora!Programada" FORMAT "x(5)":U
      ExpAsist.FecAsi[1] COLUMN-LABEL "1ra.!Asistencia" FORMAT "99/99/9999":U
      ExpAsist.HoraAsi[1] COLUMN-LABEL "Hora" FORMAT "x(5)":U WIDTH 5.29
      ExpAsist.FecAsi[2] COLUMN-LABEL "2da.!Asistencia" FORMAT "99/99/9999":U
      ExpAsist.HoraAsi[2] COLUMN-LABEL "Hora" FORMAT "x(5)":U WIDTH 4.72
      ExpAsist.FecAsi[3] COLUMN-LABEL "3ra.!Asistencia" FORMAT "99/99/9999":U
      ExpAsist.HoraAsi[3] COLUMN-LABEL "Hora" FORMAT "x(5)":U
      IF (ExpAsist.Estado[1] = 'C' ) THEN ('Asistio') ELSE ('Ausente') @ cDesEst COLUMN-LABEL "Situación" FORMAT "X(15)":U
            WIDTH .43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 142 BY 22.35
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Buscar AT ROW 1.27 COL 15 COLON-ALIGNED WIDGET-ID 4
     BUTTON-4 AT ROW 1.27 COL 42 WIDGET-ID 6
     BUTTON-5 AT ROW 1.27 COL 52 WIDGET-ID 8
     br_table AT ROW 2.35 COL 1
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
      TABLE: b-ExpAsist B "?" ? INTEGRAL ExpAsist
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
         HEIGHT             = 24.77
         WIDTH              = 145.57.
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
/* BROWSE-TAB br_table BUTTON-5 F-Main */
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
     _TblList          = "INTEGRAL.ExpAsist,INTEGRAL.gn-clie WHERE INTEGRAL.ExpAsist ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST OUTER USED"
     _Where[1]         = "{&Condicion}"
     _JoinCode[2]      = "INTEGRAL.gn-clie.CodCli = ExpAsist.CodCli
  AND INTEGRAL.gn-clie.CodCia = cl-codcia"
     _FldNameList[1]   > INTEGRAL.ExpAsist.Libre_c03
"ExpAsist.Libre_c03" "Tipo" "x(3)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.ExpAsist.CodCli
"ExpAsist.CodCli" "Código" ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.ExpAsist.NomCli
"ExpAsist.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "37.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.gn-clie.Ruc
"gn-clie.Ruc" "RUC" ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.gn-clie.NroCard
"gn-clie.NroCard" "Nº Card" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.ExpAsist.FecPro
"ExpAsist.FecPro" "Fecha!Programada" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.ExpAsist.HoraPro
"ExpAsist.HoraPro" "Hora!Programada" "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.ExpAsist.FecAsi[1]
"ExpAsist.FecAsi[1]" "1ra.!Asistencia" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.ExpAsist.HoraAsi[1]
"ExpAsist.HoraAsi[1]" "Hora" "x(5)" "character" ? ? ? ? ? ? no ? no no "5.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.ExpAsist.FecAsi[2]
"ExpAsist.FecAsi[2]" "2da.!Asistencia" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.ExpAsist.HoraAsi[2]
"ExpAsist.HoraAsi[2]" "Hora" "x(5)" "character" ? ? ? ? ? ? no ? no no "4.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.ExpAsist.FecAsi[3]
"ExpAsist.FecAsi[3]" "3ra.!Asistencia" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > INTEGRAL.ExpAsist.HoraAsi[3]
"ExpAsist.HoraAsi[3]" "Hora" "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"IF (ExpAsist.Estado[1] = 'C' ) THEN ('Asistio') ELSE ('Ausente') @ cDesEst" "Situación" "X(15)" ? ? ? ? ? ? ? no ? no no ".43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
        WHEN "CodCli" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'CodCli').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "NomCli" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'NomCli').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
    END.
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


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 B-table-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Anterior */
DO:
    ASSIGN FILL-IN-Buscar.
    IF TRUE <> (FILL-IN-Buscar > '')  THEN RETURN NO-APPLY.
    IF BuscaNueva = YES 
        THEN FIND FIRST ExpAsist WHERE INDEX(ExpAsist.NomCli, FILL-IN-Buscar) > 0 AND
        {&Condicion} NO-LOCK NO-ERROR.
    ELSE FIND PREV ExpAsist WHERE INDEX(ExpAsist.NomCli, FILL-IN-Buscar) > 0 AND
        {&Condicion} NO-LOCK NO-ERROR.
    IF AVAILABLE ExpAsist THEN DO:
        REPOSITION {&BROWSE-NAME} TO ROWID ROWID(ExpAsist) NO-ERROR.
        BuscaNueva = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 B-table-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Siguiente */
DO:
  ASSIGN FILL-IN-Buscar.
  IF TRUE <> (FILL-IN-Buscar > '')  THEN RETURN NO-APPLY.
  IF BuscaNueva = YES 
      THEN FIND FIRST ExpAsist WHERE INDEX(ExpAsist.NomCli, FILL-IN-Buscar) > 0 AND
      {&Condicion} NO-LOCK NO-ERROR.
  ELSE FIND NEXT ExpAsist WHERE INDEX(ExpAsist.NomCli, FILL-IN-Buscar) > 0 AND
      {&Condicion} NO-LOCK NO-ERROR.
  IF AVAILABLE ExpAsist THEN DO:
      REPOSITION {&BROWSE-NAME} TO ROWID ROWID(ExpAsist) NO-ERROR.
      BuscaNueva = NO.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Buscar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Buscar B-table-Win
ON LEAVE OF FILL-IN-Buscar IN FRAME F-Main /* Buscar */
DO:
  IF FILL-IN-Buscar:SCREEN-VALUE <> FILL-IN-Buscar THEN BuscaNueva = YES.
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
    WHEN 'CodCli':U THEN DO:
      &Scope SORTBY-PHRASE BY ExpAsist.CodCia BY ExpAsist.CodDiv BY ExpAsist.CodCli
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Primero':U THEN DO:
      &Scope SORTBY-PHRASE BY ExpAsist.CodCia BY ExpAsist.CodDiv BY ExpAsist.Fecha BY ExpAsist.CodCli
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'NomCli':U THEN DO:
      &Scope SORTBY-PHRASE BY ExpAsist.NomCli
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Buscar-Registro B-table-Win 
PROCEDURE Buscar-Registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pNombre AS CHAR.

FIND FIRST ExpAsist WHERE INDEX(ExpAsist.NomCli, pNombre) > 0 AND
    {&Condicion} NO-LOCK NO-ERROR.
IF AVAILABLE ExpAsist THEN DO:
    REPOSITION {&BROWSE-NAME} TO ROWID ROWID(ExpAsist) NO-ERROR.
END.
ELSE DO:
    MESSAGE 'Registro NO encontrado' VIEW-AS ALERT-BOX ERROR.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Barras B-table-Win 
PROCEDURE Imprime-Barras :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cNomCli AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cRucCli AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cCodCli AS CHARACTER   FORMAT "99999999999" NO-UNDO.
  DEFINE VAR lNroCorre AS CHAR.
  DEFINE VAR lClas AS CHAR.
  DEFINE VARIABLE iNumCop AS INTEGER     NO-UNDO.
  DEF VAR rpta AS LOG.  
    
  iNumCop = INT(1).

  FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
      AND gn-clie.codcli = ExpAsist.CodCli NO-LOCK NO-ERROR.
  IF NOT AVAIL gn-clie THEN DO:
      MESSAGE "Cliente no registrado en el sistema"
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN.
  END.
  
  ASSIGN 
      cNomCli = gn-clie.nomcli 
      /* Cliente VIP */
      cRucCli = TRIM(gn-clie.codcli).
      lClas = IF (expasist.libre_c03 <> ?) THEN TRIM(expasist.libre_c03) ELSE 'N9999'.
      IF SUBSTRING(lClas,1,1) = 'V' THEN cRucCli = TRIM(cRucCli) + "*".
      IF SUBSTRING(lClas,1,1) = 'E' THEN cRucCli = TRIM(cRucCli) + "-".
      cCodCli = gn-clie.codcli.
      lNroCorre = SUBSTRING(TRIM(lClas),2).

  RUN lib/_port-name ("Barras", OUTPUT s-port-name).
  IF s-port-name = '' THEN RETURN.
  
/*   IF s-OpSys = 'WinVista' OR s-OpSys = 'WinXP'                                                      */
/*       THEN OUTPUT STREAM REPORTE TO PRINTER VALUE(s-port-name).                                     */
/*   ELSE OUTPUT STREAM REPORTE TO VALUE(s-port-name).                                                 */
/*       PUT STREAM REPORTE '^XA^LH50,012'               SKIP.   /* Inicia formato */                  */
/*       {vtaexp/ean-clientes.i}                                                                       */
/*       PUT STREAM REPORTE '^PQ' + TRIM(STRING(iNumCop))      SKIP.  /* Cantidad a imprimir */        */
/*       PUT STREAM REPORTE '^PR' + '4'                  SKIP.   /* Velocidad de impresion Pulg/seg */ */
/*       PUT STREAM REPORTE '^XZ'                        SKIP.                                         */
/*                                                                                                     */
/*   OUTPUT STREAM REPORTE CLOSE.                                                                      */

  DEFINE VAR x-status AS LOG.
  SYSTEM-DIALOG PRINTER-SETUP  UPDATE x-status.
  IF x-status = NO THEN RETURN.
  OUTPUT STREAM REPORTE TO PRINTER.  
  PUT STREAM REPORTE '^XA^LH50,012'               SKIP.   /* Inicia formato */
    {vtaexp/ean-clientes.i}
    PUT STREAM REPORTE '^PQ' + TRIM(STRING(iNumCop))      SKIP.  /* Cantidad a imprimir */
    PUT STREAM REPORTE '^PR' + '4'                  SKIP.   /* Velocidad de impresion Pulg/seg */
    PUT STREAM REPORTE '^XZ'                        SKIP.

OUTPUT STREAM REPORTE CLOSE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Posiciona-Registro B-table-Win 
PROCEDURE Posiciona-Registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.

IF pRowid = ? THEN RETURN.

REPOSITION {&BROWSE-NAME} TO ROWID pRowid NO-ERROR.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Registra-Asistencia B-table-Win 
PROCEDURE Registra-Asistencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodCli AS CHAR.

IF TRUE <> (pCodCli > '') THEN RETURN.
IF NOT CAN-FIND(FIRST ExpAsist WHERE {&Condicion} AND ExpAsist.CodCli = pCodCli NO-LOCK)
    THEN DO:
    MESSAGE "Registro no encontrado" VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
FIND ExpAsist WHERE {&Condicion} AND ExpAsist.CodCli = pCodCli NO-LOCK.
REPOSITION br_table TO ROWID ROWID(ExpAsist) NO-ERROR.
IF {&FECHAASIS} = TODAY THEN DO:
    MESSAGE 'Cliente ya ha sido registrado el dia de hoy ' 
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    RETURN 'ADM-ERROR'.
END.
FIND FIRST b-ExpAsist WHERE ROWID(b-ExpAsist) = ROWID(ExpAsist) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
IF ERROR-STATUS:ERROR THEN DO:
    RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
    RETURN 'ADM-ERROR'.
END.
ASSIGN
    b-ExpAsist.Estado[1]     = 'C'
    b-ExpAsist.Fecha         = TODAY     /*Campo Referencial*/
    b-ExpAsist.Hora          = STRING(TIME,"HH:MM")
    b-ExpAsist.usuario       = s-user-id.
IF b-ExpAsist.FecAsi[1] = ? THEN 
    ASSIGN 
        b-ExpAsist.FecAsi[1]  = TODAY
        b-ExpAsist.HoraAsi[1] = STRING(TIME,"HH:MM").
ELSE IF b-ExpAsist.FecAsi[1] = TODAY THEN b-ExpAsist.HoraAsi[1] = STRING(TIME,"HH:MM").
ELSE IF b-ExpAsist.FecAsi[2] = ? THEN 
    ASSIGN 
        b-ExpAsist.FecAsi[2]  = TODAY
        b-ExpAsist.HoraAsi[2] = STRING(TIME,"HH:MM").
ELSE IF b-ExpAsist.FecAsi[2] = TODAY THEN b-ExpAsist.HoraAsi[2] = STRING(TIME,"HH:MM").
ELSE 
    ASSIGN 
        b-ExpAsist.FecAsi[3]  = TODAY
        b-ExpAsist.HoraAsi[3] = STRING(TIME,"HH:MM").
IF b-ExpAsist.FecAsi[2] = ? AND b-ExpAsist.FecAsi[3] = ? THEN RUN Imprime-Barras. 
IF AVAILABLE (b-ExpAsist) THEN RELEASE b-ExpAsist.
RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Reporte-Excel B-table-Win 
PROCEDURE Reporte-Excel :
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.

DEFINE VARIABLE cEstado AS CHARACTER   NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = NO.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 10.
chWorkSheet:Columns("B"):ColumnWidth = 10.
chWorkSheet:Columns("C"):ColumnWidth = 15.
chWorkSheet:Columns("D"):ColumnWidth = 40.
chWorkSheet:Columns("E"):ColumnWidth = 15.
chWorkSheet:Columns("F"):ColumnWidth = 30.
chWorkSheet:Columns("G"):ColumnWidth = 20.
chWorkSheet:Columns("H"):ColumnWidth = 20.
cColumn = STRING(t-Column).

cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Cliente".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Nombre o Razon Social".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Estado".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Departamento".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Provincia".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Distrito".

cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "  Fecha Programada  ".

cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "  Hora Programada  ".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "  1º Asistencia  ".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "  Hora  ".
cRange = "K" + cColumn.
chWorkSheet:Range(cRange):Value = "  2º Asistencia ".
cRange = "L" + cColumn.
chWorkSheet:Range(cRange):Value = "  Hora  ".
cRange = "M" + cColumn.
chWorkSheet:Range(cRange):Value = "  3º Asistencia  ".
cRange = "N" + cColumn.
chWorkSheet:Range(cRange):Value = "  Hora  ".
FOR EACH ExpAsist WHERE {&CONDICION} NO-LOCK,
    FIRST GN-CLIE WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = ExpAsist.codcli NO-LOCK:
    cEstado = "".
    IF expasist.Estado[1] = 'P' THEN cEstado = 'Ausente'.
    IF expasist.Estado[1] = 'C' THEN cEstado = 'Asistio'.

    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + gn-clie.codcli.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = gn-clie.nomcli.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = cEstado.
    FIND  TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
    IF AVAILABLE TabDepto THEN DO:
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = TabDepto.NomDepto.
    END.
    FIND  Tabprovi WHERE Tabprovi.CodDepto = gn-clie.CodDept
        AND Tabprovi.Codprovi = gn-clie.CodProv NO-LOCK NO-ERROR.
    IF AVAILABLE Tabprovi THEN DO:
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = TabProvi.NomProvi.
    END.
    FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept
        AND Tabdistr.Codprovi = gn-clie.codprov
        AND Tabdistr.Coddistr = gn-clie.CodDist NO-LOCK NO-ERROR.
    IF AVAILABLE Tabdistr THEN DO:
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = TabDistr.NomDistr.
    END.

    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(ExpAsist.FecPro).
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(ExpAsist.HoraPro).

    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(ExpAsist.FecAsi[1]).
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(ExpAsist.HoraAsi[1]).
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(ExpAsist.FecAsi[2]).
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(ExpAsist.HoraAsi[2]).
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(ExpAsist.FecAsi[3]).
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(ExpAsist.HoraAsi[3]).
END.
chExcelApplication:Visible = TRUE.
/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.
 RUN dispatch IN THIS-PROCEDURE ('open-query':U).

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
  {src/adm/template/snd-list.i "ExpAsist"}
  {src/adm/template/snd-list.i "gn-clie"}

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

