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
DEFINE SHARED VARIABLE s-nomcia AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
DEFINE SHARED VARIABLE  S-CODCIA AS INTEGER.
DEFINE VARIABLE cl-codcia  AS INTEGER INITIAL 0 NO-UNDO.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE TEMP-TABLE ttdoc NO-UNDO
      FIELDS ttdoc_coddoc   LIKE ccbcdocu.coddoc
      FIELDS ttdoc_nrodoc   LIKE ccbcdocu.nrodoc.

FIND Empresas WHERE Empresas.CodCia = S-CODCIA NO-LOCK NO-ERROR.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = S-CODCIA.

DEF BUFFER B-CDOCU FOR ccbcdocu.

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
&Scoped-define INTERNAL-TABLES CcbCDocu FacDocum

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CcbCDocu.CodDoc CcbCDocu.NroDoc ~
CcbCDocu.NomCli CcbCDocu.FchDoc CcbCDocu.FchCbd CcbCDocu.FmaPgo ~
CcbCDocu.FchVto CcbCDocu.Glosa CcbCDocu.CodRef CcbCDocu.NroRef 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH CcbCDocu WHERE ~{&KEY-PHRASE} ~
      AND CcbCDocu.CodCia = s-codcia AND ~
LOOKUP(INTEGRAL.CcbCDocu.coddiv, FILL-IN-division ) > 0 AND ~
(INTEGRAL.CcbCDocu.CodCli BEGINS txt-client ~
 OR txt-client = '' ) ~
 AND (INTEGRAL.CcbCDocu.FchDoc >= txt-desde ~
 AND CcbCDocu.FchDoc <= txt-hasta)  ~
 AND LOOKUP(INTEGRAL.CcbCDocu.coddoc,"FAC,BOL,N/C,N/D,DCO") >0  ~
 AND ( CcbCDocu.NroDoc = txt-nrodoc ~
 OR txt-nrodoc = "") ~
 AND (INTEGRAL.CcbCDocu.FchCbd = ? ~
   or ccbcdocu.fchcbd >= 01/01/2011) ~
 AND CcbCDocu.FlgEst = "P" NO-LOCK, ~
      EACH FacDocum WHERE FacDocum.CodCia =  CcbCDocu.CodCia ~
  AND FacDocum.CodDoc = CcbCDocu.CodDoc ~
      AND (INTEGRAL.FacDocum.TpoDoc = TRUE ~
 OR FacDocum.TpoDoc = FALSE) NO-LOCK ~
    BY CcbCDocu.CodDiv ~
       BY CcbCDocu.NroDoc
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH CcbCDocu WHERE ~{&KEY-PHRASE} ~
      AND CcbCDocu.CodCia = s-codcia AND ~
LOOKUP(INTEGRAL.CcbCDocu.coddiv, FILL-IN-division ) > 0 AND ~
(INTEGRAL.CcbCDocu.CodCli BEGINS txt-client ~
 OR txt-client = '' ) ~
 AND (INTEGRAL.CcbCDocu.FchDoc >= txt-desde ~
 AND CcbCDocu.FchDoc <= txt-hasta)  ~
 AND LOOKUP(INTEGRAL.CcbCDocu.coddoc,"FAC,BOL,N/C,N/D,DCO") >0  ~
 AND ( CcbCDocu.NroDoc = txt-nrodoc ~
 OR txt-nrodoc = "") ~
 AND (INTEGRAL.CcbCDocu.FchCbd = ? ~
   or ccbcdocu.fchcbd >= 01/01/2011) ~
 AND CcbCDocu.FlgEst = "P" NO-LOCK, ~
      EACH FacDocum WHERE FacDocum.CodCia =  CcbCDocu.CodCia ~
  AND FacDocum.CodDoc = CcbCDocu.CodDoc ~
      AND (INTEGRAL.FacDocum.TpoDoc = TRUE ~
 OR FacDocum.TpoDoc = FALSE) NO-LOCK ~
    BY CcbCDocu.CodDiv ~
       BY CcbCDocu.NroDoc.
&Scoped-define TABLES-IN-QUERY-br_table CcbCDocu FacDocum
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CcbCDocu
&Scoped-define SECOND-TABLE-IN-QUERY-br_table FacDocum


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br_table}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS txt-client txt-desde txt-hasta btn-refresh ~
txt-nrodoc BUTTON-1 br_table btn-grabar BUTTON-3 btn-print btn-salir ~
txt-fchent 
&Scoped-Define DISPLAYED-OBJECTS txt-client txt-desde txt-hasta txt-nrodoc ~
FILL-IN-Division txt-fchent 

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
DEFINE BUTTON btn-grabar 
     IMAGE-UP FILE "IMG/b-ok.bmp":U
     LABEL "Grabar" 
     SIZE 13 BY 1.88.

DEFINE BUTTON btn-print 
     IMAGE-UP FILE "IMG/b-print.bmp":U
     LABEL "Imprimir" 
     SIZE 9 BY 1.88.

DEFINE BUTTON btn-refresh 
     IMAGE-UP FILE "IMG/pvbrowd.bmp":U
     LABEL "Actualizar" 
     SIZE 9 BY 1.88.

DEFINE BUTTON btn-salir 
     IMAGE-UP FILE "IMG/exit.ico":U
     LABEL "Button 9" 
     SIZE 9 BY 1.88.

DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 3" 
     SIZE 8 BY 1.88.

DEFINE VARIABLE FILL-IN-Division AS CHARACTER FORMAT "X(60)":U INITIAL "00000" 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE txt-client AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     FONT 1 NO-UNDO.

DEFINE VARIABLE txt-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     FONT 1 NO-UNDO.

DEFINE VARIABLE txt-fchent AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Entrega" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE txt-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     FONT 1 NO-UNDO.

DEFINE VARIABLE txt-nrodoc AS CHARACTER FORMAT "X(9)":U 
     LABEL "Nº Documento" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      CcbCDocu, 
      FacDocum SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      CcbCDocu.CodDoc COLUMN-LABEL "Cod!Doc" FORMAT "x(3)":U WIDTH 4.43
      CcbCDocu.NroDoc COLUMN-LABEL "Documento" FORMAT "X(12)":U
            WIDTH 10
      CcbCDocu.NomCli COLUMN-LABEL "Nombre de Cliente" FORMAT "x(50)":U
      CcbCDocu.FchDoc COLUMN-LABEL "Fecha!Emisión" FORMAT "99/99/9999":U
      CcbCDocu.FchCbd COLUMN-LABEL "Fecha!Recepción" FORMAT "99/99/9999":U
            COLUMN-BGCOLOR 14
      CcbCDocu.FmaPgo COLUMN-LABEL "Condicion!de venta" FORMAT "X(8)":U
      CcbCDocu.FchVto COLUMN-LABEL "Fecha !Vencimiento" FORMAT "99/99/9999":U
            COLUMN-BGCOLOR 11
      CcbCDocu.Glosa FORMAT "x(60)":U
      CcbCDocu.CodRef COLUMN-LABEL "Ref." FORMAT "x(4)":U
      CcbCDocu.NroRef FORMAT "X(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 107 BY 11.04
         FONT 4 ROW-HEIGHT-CHARS .54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txt-client AT ROW 1.27 COL 12 COLON-ALIGNED WIDGET-ID 2
     txt-desde AT ROW 1.27 COL 37 COLON-ALIGNED WIDGET-ID 4
     txt-hasta AT ROW 1.27 COL 62 COLON-ALIGNED WIDGET-ID 6
     btn-refresh AT ROW 1.27 COL 97 WIDGET-ID 10
     txt-nrodoc AT ROW 2.35 COL 12 COLON-ALIGNED WIDGET-ID 8
     BUTTON-1 AT ROW 2.35 COL 83 WIDGET-ID 24
     FILL-IN-Division AT ROW 2.42 COL 37 COLON-ALIGNED WIDGET-ID 26
     br_table AT ROW 3.69 COL 2
     btn-grabar AT ROW 15 COL 63 WIDGET-ID 14
     BUTTON-3 AT ROW 15 COL 78 WIDGET-ID 28
     btn-print AT ROW 15 COL 87 WIDGET-ID 16
     btn-salir AT ROW 15 COL 99 WIDGET-ID 22
     txt-fchent AT ROW 15.81 COL 12 COLON-ALIGNED WIDGET-ID 12
     "* Puede seleccionar de uno a más documentos." VIEW-AS TEXT
          SIZE 44 BY .5 AT ROW 15 COL 3 WIDGET-ID 18
          FGCOLOR 9 FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1 WIDGET-ID 100.


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
         HEIGHT             = 16.15
         WIDTH              = 109.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
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
/* BROWSE-TAB br_table FILL-IN-Division F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 3.

/* SETTINGS FOR FILL-IN FILL-IN-Division IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.CcbCDocu,INTEGRAL.FacDocum WHERE INTEGRAL.CcbCDocu ..."
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ","
     _OrdList          = "INTEGRAL.CcbCDocu.CodDiv|yes,INTEGRAL.CcbCDocu.NroDoc|yes"
     _Where[1]         = "INTEGRAL.CcbCDocu.CodCia = s-codcia AND
LOOKUP(INTEGRAL.CcbCDocu.coddiv, FILL-IN-division ) > 0 AND
(INTEGRAL.CcbCDocu.CodCli BEGINS txt-client
 OR txt-client = '' )
 AND (INTEGRAL.CcbCDocu.FchDoc >= txt-desde
 AND INTEGRAL.CcbCDocu.FchDoc <= txt-hasta) 
 AND LOOKUP(INTEGRAL.CcbCDocu.coddoc,""FAC,BOL,N/C,N/D,DCO"") >0 
 AND ( INTEGRAL.CcbCDocu.NroDoc = txt-nrodoc
 OR txt-nrodoc = """")
 AND (INTEGRAL.CcbCDocu.FchCbd = ?
   or integral.ccbcdocu.fchcbd >= 01/01/2011)
 AND INTEGRAL.CcbCDocu.FlgEst = ""P"""
     _JoinCode[2]      = "INTEGRAL.FacDocum.CodCia =  INTEGRAL.CcbCDocu.CodCia
  AND INTEGRAL.FacDocum.CodDoc = INTEGRAL.CcbCDocu.CodDoc"
     _Where[2]         = "(INTEGRAL.FacDocum.TpoDoc = TRUE
 OR INTEGRAL.FacDocum.TpoDoc = FALSE)"
     _FldNameList[1]   > INTEGRAL.CcbCDocu.CodDoc
"CcbCDocu.CodDoc" "Cod!Doc" ? "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.CcbCDocu.NroDoc
"CcbCDocu.NroDoc" "Documento" ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.CcbCDocu.NomCli
"CcbCDocu.NomCli" "Nombre de Cliente" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.CcbCDocu.FchDoc
"CcbCDocu.FchDoc" "Fecha!Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.CcbCDocu.FchCbd
"CcbCDocu.FchCbd" "Fecha!Recepción" ? "date" 14 ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.CcbCDocu.FmaPgo
"CcbCDocu.FmaPgo" "Condicion!de venta" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.CcbCDocu.FchVto
"CcbCDocu.FchVto" "Fecha !Vencimiento" ? "date" 11 ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = INTEGRAL.CcbCDocu.Glosa
     _FldNameList[9]   > INTEGRAL.CcbCDocu.CodRef
"CcbCDocu.CodRef" "Ref." "x(4)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   = INTEGRAL.CcbCDocu.NroRef
     _Query            is OPENED
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


&Scoped-define SELF-NAME btn-grabar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-grabar B-table-Win
ON CHOOSE OF btn-grabar IN FRAME F-Main /* Grabar */
DO:
    ASSIGN txt-fchent.
    IF {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0
    THEN DO:
      MESSAGE 'Debe seleccionar al menos un documento' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO {&BROWSE-NAME}.
      RETURN NO-APPLY.
    END.
    IF txt-fchent = ? THEN DO:
        MESSAGE 'Debe ingresar fecha de Recepción' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO txt-fchent.
        RETURN NO-APPLY.
    END.
    RUN Actualiza_Fecha.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-print B-table-Win
ON CHOOSE OF btn-print IN FRAME F-Main /* Imprimir */
DO:
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-refresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-refresh B-table-Win
ON CHOOSE OF btn-refresh IN FRAME F-Main /* Actualizar */
DO:
    ASSIGN 
        txt-client
        txt-desde
        txt-hasta
        txt-nrodoc
        txt-fchent = ?
        FILL-IN-division.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-salir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-salir B-table-Win
ON CHOOSE OF btn-salir IN FRAME F-Main /* Button 9 */
DO:
    RUN adm-exit.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:

    DEF VAR x-Divisiones AS CHAR.
    x-Divisiones = FILL-IN-Division:SCREEN-VALUE.
    RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
    FILL-IN-Division:SCREEN-VALUE = x-Divisiones.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 B-table-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  RUN Excel.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Division B-table-Win
ON LEAVE OF FILL-IN-Division IN FRAME F-Main /* División */
DO:
    ASSIGN FILL-IN-Division.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza_Fecha B-table-Win 
PROCEDURE Actualiza_Fecha :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i AS INTE.
  DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.  

  FOR EACH ttdoc:
      DELETE ttdoc.
  END.

  DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(i)
    THEN DO:        
        CREATE ttdoc.
        ASSIGN
            ttdoc_coddoc = ccbcdoc.coddoc
            ttdoc_nrodoc = ccbcdoc.nrodoc.
    END.
  END.
  
  MESSAGE "La informacion es correcta?" 
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      TITLE "" UPDATE lchoice AS LOGICAL.  

  DEF VAR x-TotDias AS INT NO-UNDO.
  DEF VAR x-DiasManuales AS INT NO-UNDO.
  IF lchoice THEN DO:     
      FOR EACH ttdoc NO-LOCK,
          FIRST b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia          
          AND b-ccbcdocu.coddoc = ttdoc_coddoc 
          AND b-ccbcdocu.nrodoc = ttdoc_nrodoc EXCLUSIVE-LOCK 
          BREAK BY ttdoc_nrodoc:
          IF txt-fchent >= b-ccbcdocu.fchdoc THEN DO:
              /* RHC 15/05/2018
              Los días van a depender de la condición de venta y del vencimiento manual 
              registrado el el comprobante 
              */
              x-DiasManuales = B-Ccbcdocu.FchVto - B-Ccbcdocu.FchDoc.
              IF B-Ccbcdocu.FchCbd <> ? THEN x-DiasManuales = B-Ccbcdocu.FchVto - B-Ccbcdocu.FchCbd.
              FIND FIRST gn-convt WHERE gn-convt.codig = b-ccbcdocu.fmapgo NO-LOCK NO-ERROR.
              x-TotDias = 0.
              IF AVAILABLE gn-convt THEN DO:
                  ASSIGN
                      /*x-TotDias = INTEGER(ENTRY(1,gn-ConVt.Vencmtos))*/
                      x-TotDias = gn-ConVt.TotDias
                      NO-ERROR.
              END.
              /*x-TotDias = MAXIMUM(x-TotDias,x-DiasManuales).*/
              ASSIGN 
                  b-ccbcdocu.fchcbd = txt-fchent
                  b-ccbcdocu.fchvto = txt-fchent + x-TotDias.
              IF b-ccbcdocu.coddoc = 'N/C' 
                  THEN ASSIGN b-ccbcdocu.fchvto = ADD-INTERVAL(b-ccbcdocu.fchcbd,1,'years').
          END.             
          ELSE DO:
              MESSAGE '!!!Fecha Incorrecta!!!.' SKIP
                  '    Doc:' ttdoc_nrodoc SKIP
                  'La fecha de entrega no debe ser menor' SKIP 
                  'a la fecha de emisión del documento'
                  VIEW-AS ALERT-BOX ERROR.   
          END.
      END.
      RUN adm-open-query.
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
    DEFINE VARIABLE t-Column                AS INTEGER INIT 1.

    DEFINE VARIABLE x-Divi   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-Moneda AS CHARACTER.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "Cliente".
    cRange = "B" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "Nombre".
    cRange = "C" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "Doc".
    cRange = "D" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "Numero".
    cRange = "E" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "Emision".
    cRange = "F" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "Recepcion".
    cRange = "G" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "Vendedor".
    cRange = "H" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "MON".
    cRange = "I" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "IMPORTE".
    cRange = "J" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "SALDO".
    cRange = "K" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "OBSERVACIONES".
    cRange = "L" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "REF".
    cRange = "M" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "NUMERO".

    x-Divi = FILL-IN-Division:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
    FOR EACH B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = s-codcia    
        AND LOOKUP(B-CDOCU.coddiv,x-Divi) > 0
        AND (B-CDOCU.CodCli BEGINS txt-client OR txt-client = '' )
        AND B-CDOCU.fchdoc >= txt-Desde
        AND B-CDOCU.fchdoc <= txt-Hasta
        AND LOOKUP(B-CDOCU.coddoc,"FAC,BOL,N/C,N/D") > 0 
        AND ( B-CDOCU.NroDoc = txt-nrodoc OR txt-nrodoc = "")
        AND B-CDOCU.fchcbd = ?
        AND B-CDOCU.FlgEst = "P"
        BY B-CDOCU.coddiv BY B-CDOCU.nrodoc:

        IF B-CDOCU.codmon = 1 THEN ASSIGN x-Moneda = 'S/'.                        
        ELSE ASSIGN x-Moneda = 'US$'.

        t-column = t-column + 1.                                                                                                                               
        cColumn = STRING(t-Column).                                                                                        
        cRange = "A" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = "'" + B-CDOCU.codcli.
        cRange = "B" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = B-CDOCU.nomcli.
        cRange = "C" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = B-CDOCU.coddoc.
        cRange = "D" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = "'" + B-CDOCU.nrodoc.
        cRange = "E" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = B-CDOCU.fchdoc.
        cRange = "F" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = B-CDOCU.fchcbd.
        cRange = "G" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = "'" + B-CDOCU.codven.
        cRange = "H" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = x-moneda.
        cRange = "I" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = B-CDOCU.imptot.
        cRange = "J" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = B-CDOCU.sdoact.
        cRange = "K" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = B-CDOCU.glosa.
        cRange = "L" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = B-CDOCU.codref.
        cRange = "M" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = "'" + B-CDOCU.nroref.
    END.
    /* launch Excel so it is visible to the user */
    chExcelApplication:VISIBLE = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato B-table-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose: Impresión de Estado de Documentos    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE x-CodDiv AS CHARACTER.
  DEFINE VARIABLE x-CodDoc AS CHARACTER.
  DEFINE VARIABLE i AS INTEGER.
  DEFINE VARIABLE x-Moneda AS CHARACTER.
  DEFINE VARIABLE x-Divi   AS CHARACTER   NO-UNDO.

  DEFINE FRAME F-Reporte
    ccbcdocu.codcli COLUMN-LABEL 'Cliente'
    ccbcdocu.nomcli COLUMN-LABEL 'Nombre o Razon Social'
    ccbcdocu.coddoc COLUMN-LABEL 'Doc'
    ccbcdocu.nrodoc COLUMN-LABEL 'Numero'
    ccbcdocu.fchdoc COLUMN-LABEL 'Emisión'
    ccbcdocu.fchcbd COLUMN-LABEL 'Recepción'
    ccbcdocu.codven COLUMN-LABEL 'Vend'
    x-Moneda        COLUMN-LABEL 'Mon'
    ccbcdocu.imptot COLUMN-LABEL 'Total'
    ccbcdocu.sdoact COLUMN-LABEL 'Saldo'
    HEADER
        S-NOMCIA FORMAT "X(50)" SKIP
        "ESTADO DE DOCUMENTOS" AT 30
        "Pag.  : " AT 120 PAGE-NUMBER(REPORT) FORMAT "ZZZZ9" SKIP
        "Fecha : " AT 120 STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        "Hora  : " AT 120 STRING(TIME,"HH:MM:SS") SKIP
        "EMITIDOS DESDE EL" txt-Desde "HASTA EL" txt-Hasta SKIP
        "DOCUMENTO(s):" x-CodDoc SKIP
    WITH WIDTH 165 NO-BOX STREAM-IO DOWN.         

  x-Divi = FILL-IN-Division:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  
  FOR EACH CcbCDocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia    
      AND LOOKUP(ccbcdocu.coddiv,x-Divi) > 0
      AND (INTEGRAL.CcbCDocu.CodCli BEGINS txt-client
        OR txt-client = '' )
      AND ccbcdocu.fchdoc >= txt-Desde
      AND ccbcdocu.fchdoc <= txt-Hasta
      AND LOOKUP(CcbCDocu.coddoc,"FAC,BOL,N/C,N/D") > 0 
      AND ( INTEGRAL.CcbCDocu.NroDoc = txt-nrodoc
        OR txt-nrodoc = "")
      AND ccbcdocu.fchcbd = ?
      AND CcbCDocu.FlgEst = "P"
      BREAK BY ccbcdocu.codcia
      BY ccbcdocu.coddiv
        BY ccbcdocu.nrodoc:

      IF ccbcdocu.codmon = 1 THEN ASSIGN x-Moneda = 'S/'.                        
      ELSE ASSIGN x-Moneda = 'US$'.
      ACCUMULATE ccbcdocu.imptot (TOTAL BY ccbcdocu.codcia).
      ACCUMULATE ccbcdocu.sdoact (TOTAL BY ccbcdocu.codcia).

      DISPLAY STREAM REPORT
          ccbcdocu.codcli 
          ccbcdocu.nomcli 
          ccbcdocu.coddoc 
          ccbcdocu.nrodoc 
          ccbcdocu.fchdoc 
          ccbcdocu.fchcbd
          ccbcdocu.codven 
          x-Moneda   
          ccbcdocu.imptot
          ccbcdocu.sdoact
          WITH FRAME F-Reporte.        
      IF LAST-OF (ccbcdocu.codcia) THEN DO:
          UNDERLINE STREAM report
              ccbcdocu.imptot ccbcdocu.sdoact
              WITH FRAME F-Reporte.
          DISPLAY STREAM report
              ACCUM TOTAL BY ccbcdocu.codcia ccbcdocu.imptot @ ccbcdocu.imptot
              ACCUM TOTAL BY ccbcdocu.codcia ccbcdocu.sdoact @ ccbcdocu.imptot
              WITH FRAME F-Reporte.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir B-table-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".
    DO c-Copias = 1 TO s-nro-copias:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file).
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
    END CASE.
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
  
  DO WITH FRAME {&FRAME-NAME}:
      RUN bin/_dateif (MONTH(TODAY), YEAR(TODAY), OUTPUT txt-desde, OUTPUT txt-hasta).
  END.

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
  {src/adm/template/snd-list.i "FacDocum"}

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

