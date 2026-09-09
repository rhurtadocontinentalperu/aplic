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
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-user-id AS CHAR.
DEFINE SHARED VAR s-coddiv AS CHAR.

DEFINE SHARED VAR lh_handle AS HANDLE.

/* Local Variable Definitions ---                                       */
DEFINE VAR x-coddoc AS  CHAR    INIT "PNC".
DEFINE VAR x-estados AS  CHAR    INIT "*".

DEFINE VAR x-col-moneda AS CHAR.
DEFINE VAR x-col-estado AS CHAR.
DEFINE VAR x-params AS CHAR.

/*
DEFINE VAR x-division AS CHAR INIT "T".
DEFINE VAR x-usuario AS CHAR INIT "T".
DEFINE VAR x-concepto AS  CHAR INIT "T".
*/

DEFINE SHARED VAR x-Concepto AS CHAR.
DEFINE SHARED VAR x-Division AS CHAR. 
DEFINE SHARED VAR x-Usuario AS CHAR.

/*
IF s-user-id = 'ADMIN' THEN DO:
    &SCOPED-DEFINE CONDICION ( ~
            INTEGRAL.ccbcdocu.CodCia = s-codcia AND ~
            INTEGRAL.ccbcdocu.CodDoc = x-coddoc AND ~
            INTEGRAL.ccbcdocu.tpofac = 'OTROS' AND ~
            (x-division = 'T' OR (x-division = 'D' AND ccbcdocu.Coddiv = s-coddiv) OR ccbcdocu.Coddiv = x-division) AND ~
            (x-usuario = 'T' OR (x-usuario = 'U' AND ccbcdocu.usuario = s-user-id) OR ccbcdocu.usuario = x-usuario) AND ~
            (x-concepto = 'T' OR (ccbcdocu.codcta = x-concepto)) AND ~
            (x-estados = '*' OR LOOKUP(INTEGRAL.ccbcdocu.flgest, x-estados) > 0) )
END.
ELSE DO:
    &SCOPED-DEFINE CONDICION ( ~
            INTEGRAL.ccbcdocu.CodCia = s-codcia AND ~
            INTEGRAL.ccbcdocu.CodDoc = x-coddoc AND ~
            INTEGRAL.ccbcdocu.tpofac = 'OTROS' AND ~
            (x-division = 'T' OR (x-division = 'D' AND ccbcdocu.Coddiv = s-coddiv) OR ccbcdocu.Coddiv = x-division) AND ~
            (x-concepto = 'T' OR (ccbcdocu.codcta = x-concepto)) AND ~
            (x-estados = '*' OR LOOKUP(INTEGRAL.ccbcdocu.flgest, x-estados) > 0) )
END.
*/

IF s-user-id = 'ADMIN' THEN DO:
    x-division = "T".
    x-usuario = "T".
    x-concepto = "T".
END.

x-params = x-concepto + x-division + x-usuario.

/*IF s-user-id = 'ADMIN' THEN DO:*/
IF x-params = 'TTT' THEN DO:
    &SCOPED-DEFINE CONDICION ( ~
            ccbcdocu.CodCia = s-codcia AND ~
            ccbcdocu.CodDoc = x-coddoc AND ~
            ccbcdocu.tpofac = 'OTROS' AND ~
            (x-estados = '*' OR LOOKUP(ccbcdocu.flgest, x-estados) > 0) )
END.
ELSE DO:
    &SCOPED-DEFINE CONDICION ( ~
            ccbcdocu.CodCia = s-codcia AND ~
            ccbcdocu.CodDoc = x-coddoc AND ~
            ccbcdocu.tpofac = 'OTROS' AND ~
            (x-division = 'T' OR (x-division = 'D' AND ccbcdocu.Coddiv = s-coddiv) OR ccbcdocu.Coddiv = x-division) AND ~
            (x-concepto = 'T' OR (ccbcdocu.codcta = x-concepto)) AND ~
            (x-estados = '*' OR LOOKUP(ccbcdocu.flgest, x-estados) > 0) )

    IF x-concepto <> 'T' AND x-division = 'D' AND x-usuario = 'U' THEN DO:

        &SCOPED-DEFINE CONDICION ( ~
                ccbcdocu.CodCia = s-codcia AND ~
                ccbcdocu.Coddiv = s-coddiv AND ~
                ccbcdocu.tpofac = 'OTROS' AND ~
                ccbcdocu.CodDoc = x-coddoc AND ~
                ccbcdocu.codcta = x-concepto AND ~
                (x-estados = '*' OR LOOKUP(ccbcdocu.flgest,x-estados) > 0) ) 
    END.
END.

DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER x-ccbddocu FOR ccbddocu.

/* En definitions */
define var x-sort-column-current as char.

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
&Scoped-define INTERNAL-TABLES CcbCDocu

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CcbCDocu.CodDoc CcbCDocu.NroDoc ~
if ( CcbCDocu.CodMon = 2 ) then 'US$' else 'S/' @ x-col-moneda ~
CcbCDocu.FchDoc CcbCDocu.CodRef CcbCDocu.NroRef CcbCDocu.CodCli ~
CcbCDocu.NomCli CcbCDocu.ImpTot fEstado(CcbCDocu.FlgEst) @ x-col-estado ~
CcbCDocu.usuario CcbCDocu.Libre_c01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH CcbCDocu WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} NO-LOCK ~
    BY CcbCDocu.FchDoc DESCENDING ~
       BY CcbCDocu.NroDoc DESCENDING
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH CcbCDocu WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} NO-LOCK ~
    BY CcbCDocu.FchDoc DESCENDING ~
       BY CcbCDocu.NroDoc DESCENDING.
&Scoped-define TABLES-IN-QUERY-br_table CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CcbCDocu


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table RADIO-SET-estado 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-estado 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT pEstado AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE RADIO-SET-estado AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", "*",
"Generada", "T",
"En Proceso", "D",
"Aprobado", "P",
"Aceptacion parcial", "AP",
"Rechazado total", "R",
"N/C Generada", "G",
"Anulada", "A"
     SIZE 111.14 BY 1.12 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      CcbCDocu.CodDoc COLUMN-LABEL "T.Doc" FORMAT "x(3)":U
      CcbCDocu.NroDoc FORMAT "X(12)":U WIDTH 10.43
      if ( CcbCDocu.CodMon = 2 ) then 'US$' else 'S/' @ x-col-moneda COLUMN-LABEL "Moneda" FORMAT "x(5)":U
      CcbCDocu.FchDoc COLUMN-LABEL "Emision" FORMAT "99/99/9999":U
            WIDTH 8.43
      CcbCDocu.CodRef COLUMN-LABEL "Cod!Ref." FORMAT "x(3)":U WIDTH 5.43
      CcbCDocu.NroRef COLUMN-LABEL "Nro.Ref" FORMAT "X(12)":U WIDTH 10.57
      CcbCDocu.CodCli FORMAT "x(11)":U WIDTH 11.29
      CcbCDocu.NomCli FORMAT "x(50)":U WIDTH 36.86
      CcbCDocu.ImpTot FORMAT "->>,>>>,>>9.99":U WIDTH 9.43
      fEstado(CcbCDocu.FlgEst) @ x-col-estado COLUMN-LABEL "Estado" FORMAT "x(25)":U
            WIDTH 22.29
      CcbCDocu.usuario COLUMN-LABEL "Usuario" FORMAT "x(10)":U
      CcbCDocu.Libre_c01 COLUMN-LABEL "Lineas" FORMAT "x(25)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 122.57 BY 7.08
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 2.19 COL 1.43
     RADIO-SET-estado AT ROW 9.38 COL 3.72 NO-LABEL WIDGET-ID 2
     "Double Click en NUMERO para generar la N/C" VIEW-AS TEXT
          SIZE 62.57 BY .96 AT ROW 1.19 COL 1.43 WIDGET-ID 10
          BGCOLOR 15 FGCOLOR 9 FONT 11
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
         HEIGHT             = 10.08
         WIDTH              = 126.57.
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
     _TblList          = "INTEGRAL.CcbCDocu"
     _Options          = "NO-LOCK KEY-PHRASE"
     _OrdList          = "INTEGRAL.CcbCDocu.FchDoc|no,INTEGRAL.CcbCDocu.NroDoc|no"
     _Where[1]         = "{&CONDICION}"
     _FldNameList[1]   > INTEGRAL.CcbCDocu.CodDoc
"CcbCDocu.CodDoc" "T.Doc" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.CcbCDocu.NroDoc
"CcbCDocu.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"if ( CcbCDocu.CodMon = 2 ) then 'US$' else 'S/' @ x-col-moneda" "Moneda" "x(5)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.CcbCDocu.FchDoc
"CcbCDocu.FchDoc" "Emision" ? "date" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.CcbCDocu.CodRef
"CcbCDocu.CodRef" "Cod!Ref." ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.CcbCDocu.NroRef
"CcbCDocu.NroRef" "Nro.Ref" ? "character" ? ? ? ? ? ? no ? no no "10.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.CcbCDocu.CodCli
"CcbCDocu.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "11.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.CcbCDocu.NomCli
"CcbCDocu.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "36.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.CcbCDocu.ImpTot
"CcbCDocu.ImpTot" ? ? "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"fEstado(CcbCDocu.FlgEst) @ x-col-estado" "Estado" "x(25)" ? ? ? ? ? ? ? no ? no no "22.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.CcbCDocu.usuario
"CcbCDocu.usuario" "Usuario" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.CcbCDocu.Libre_c01
"CcbCDocu.Libre_c01" "Lineas" "x(25)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ENTRY OF br_table IN FRAME F-Main
DO:
  /* SetFocus */
  
    RUN refrescar-dtl IN lh_handle.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON MOUSE-SELECT-DBLCLICK OF br_table IN FRAME F-Main
DO:
  IF AVAILABLE ccbcdocu THEN DO:
      /**/
      IF ccbcdocu.flgest = 'P' OR ccbcdocu.flgest = 'AP' THEN DO:

          DEFINE VAR x-msg AS CHAR INIT "".

          RUN ccb/d-genera-nc-desde-pnc.r(INPUT ccbcdocu.coddiv, INPUT ccbcdocu.coddoc, INPUT ccbcdocu.nrodoc, OUTPUT x-msg).

          IF x-msg = 'OK' THEN DO:

              SESSION:SET-WAIT-STATE("GENERAL").
              {&OPEN-QUERY-br_table}
              RUN adm-row-changed.
              SESSION:SET-WAIT-STATE("").                
          END.
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
ON START-SEARCH OF br_table IN FRAME F-Main
DO:
    /* ----------------- En el trigger START-SEARCH del BROWSE si la funcionalidad esta en un INI ---------------*/
    DEFINE VAR x-sql AS CHAR.

/*    x-sql = "FOR EACH TORDENES WHERE TORDENES.campo-c[30] = '' NO-LOCK ".*/
    x-sql = "FOR EACH CcbCDocu WHERE " + "{& " + "CONDICION" + "} NO-LOCK".
    x-sql = "FOR EACH CcbCDocu WHERE " + "{&CONDICION} NO-LOCK".

    /*{gn/sort-browse.i &ThisBrowse="br_table" &ThisSQL = x-SQL}*/



END.

    /*
EACH INTEGRAL.CcbCDocu WHERE ~{&KEY-PHRASE}
      AND {&CONDICION} NO-LOCK
    ~{&SORTBY-PHRASE}    
    */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}

    RUN refrescar-dtl IN lh_handle.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-estado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-estado B-table-Win
ON VALUE-CHANGED OF RADIO-SET-estado IN FRAME F-Main
DO:
    SESSION:SET-WAIT-STATE("GENERAL").

    x-estados = SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    {&OPEN-QUERY-br_table}

    RUN adm-row-changed.

    SESSION:SET-WAIT-STATE("").
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

DEFINE VAR x-retval AS CHAR.
DEFINE VAR x-rowid AS ROWID.    
DEFINE VAR x-aprobado AS CHAR.

ON FIND OF ccbcdocu DO:
    /*
    IF ccbcdocu.flgest = 'D' THEN DO:

        x-retval = "NO REVISADO".
        x-rowid = ROWID(ccbcdocu).

        DETALLE_DOC:
        FOR EACH x-ccbddocu OF ccbcdocu NO-LOCK:
            IF NOT (TRUE <> (x-ccbddocu.flg_factor > "")) THEN DO:
                IF NUM-ENTRIES(x-ccbddocu.flg_factor,"|") > 1 THEN DO:
                    x-retval = ENTRY(1,x-ccbddocu.flg_factor,"|").
                END.

                IF x-retval <> 'APROBADO' THEN DO:
                    x-aprobado = "NO".
                    LEAVE DETALLE_DOC.
                END.
                ELSE DO:
                    x-aprobado = "SI".
                END.
            END.
            ELSE DO:
                x-aprobado = "NO".
                LEAVE DETALLE_DOC.
            END.
        END.
        IF x-aprobado = "SI" THEN DO:
            FIND FIRST b-ccbcdocu WHERE ROWID(b-ccbcdocu) = x-rowid EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE b-ccbcdocu THEN DO:
                ASSIGN b-ccbcdocu.flgest = 'P'.     /* REVISADO TOTAL */
            END.
            RELEASE b-ccbcdocu NO-ERROR.
        END.
    END.
    */

    RETURN.
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
  
  /*RUN refrescar.*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refrescar B-table-Win 
PROCEDURE refrescar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pConcepto AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pDivision AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pUsuario AS CHAR NO-UNDO.
/* 
    CCCCC,X,Y
    
    CCCCC    = Concepto de la nota de credito
    X       =   T : Todas las divisiones
                D : Division del usuario
                XXXXX : Alguna division puntual
    Y       =   T : Todos los usuarios
                U : Usuario segun login
                XXX-XX : Un usuario puntual
                
Desde cuentas x cobrar : 00003,D,U                               
*/   

DEFINE VAR x-params AS CHAR.

x-concepto = pConcepto.
x-division = pDivision.
x-usuario = pUsuario.
    
SESSION:SET-WAIT-STATE("GENERAL").                     

{&OPEN-QUERY-br_table}

RUN adm-row-changed.

SESSION:SET-WAIT-STATE("").

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
  {src/adm/template/snd-list.i "CcbCDocu"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-parametros B-table-Win 
PROCEDURE set-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pConcepto AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pDivision AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pUsuario AS CHAR NO-UNDO.
/* 
    CCCCC,X,Y
    
    CCCCC    = Concepto de la nota de credito
    X       =   T : Todas las divisiones
                D : Division del usuario
                XXXXX : Alguna division puntual
    Y       =   T : Todos los usuarios
                U : Usuario segun login
                XXX-XX : Un usuario puntual
                
Desde cuentas x cobrar : 00003,D,U                               
*/   

x-concepto = pConcepto.
x-division = pDivision.
x-usuario = pUsuario.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT pEstado AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VAR x-retval AS CHAR.

    DEFINE VAR x-codigo-estados AS CHAR.
    DEFINE VAR x-descripcion-estados AS CHAR.

    x-codigo-estados = "T,D,P,R,G,A,AP".
    x-descripcion-estados = "GENERADA,EN PROCESO,APROBADO,RECHAZADO TOTAL,N/C EMITIDA,ANULADA,APROBACION PARCIAL".    
                                      
    x-retval = "DESCONOCIDO(" + STRING(pEstado) + ")" NO-ERROR.

    IF LOOKUP(pEstado,x-codigo-estados) > 0 THEN DO:
        x-retval = ENTRY(LOOKUP(pEstado,x-codigo-estados),x-descripcion-estados).
    END.



    RETURN x-retval.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

