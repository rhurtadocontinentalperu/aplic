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

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR cl-codcia AS INT.

DEFINE VARIABLE cNomDig     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cTerminal   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cEstado     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cHoraIni    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cHoraFin    AS CHARACTER   NO-UNDO.

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
&Scoped-define INTERNAL-TABLES ExpTurno ExpTarea gn-clie ExpDigit

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table ExpTurno.NroDig ExpTurno.CodCli ~
gn-clie.NomCli ExpTurno.Block + ' - ' + ExpTurno.CodVen @ cTerminal ~
IF (ExpTurno.Estado = 'G') THEN ('GENERADO') ELSE ( IF (ExpTurno.Estado = 'D') THEN ('DIGITACION') ELSE ( IF (ExpTurno.Estado = 'P') THEN ('VENDEDOR') ELSE ('CERRADO'))) @ cEstado ~
ExpTurno.Fecha ExpTurno.Hora ~
IF (ExpTarea.CodDig <> ?) THEN (ExpTarea.CodDig + ' - ' + ExpDigit.NomDig) ELSE ('') @ cNomDig ~
IF (ExpTarea.Libre_c02 <> ? ) THEN (ExpTarea.Libre_c02) ELSE ('') @ cHoraIni ~
IF (ExpTarea.Libre_c03 <> ? ) THEN (ExpTarea.Libre_c03) ELSE ('') @ cHoraFin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH ExpTurno WHERE ~{&KEY-PHRASE} ~
      AND ExpTurno.CodCia = s-codcia ~
 AND ExpTurno.CodDiv = s-coddiv ~
 AND ExpTurno.Fecha >= today - 10 ~
 AND ExpTurno.Estado BEGINS cb-estado ~
 AND ExpTurno.CodCli BEGINS txt-codcli ~
 AND (ExpTurno.NroDig = txt-nrodig ~
 OR txt-nrodig = 0) NO-LOCK, ~
      FIRST ExpTarea WHERE ExpTarea.CodCia = ExpTurno.CodCia ~
  AND ExpTarea.CodDiv = ExpTurno.CodDiv ~
  AND  ExpTarea.CodCli = ExpTurno.CodCli ~
  AND ExpTarea.NroDig = ExpTurno.NroDig OUTER-JOIN NO-LOCK, ~
      EACH gn-clie WHERE gn-clie.CodCli = ExpTurno.CodCli ~
      AND gn-clie.CodCia = cl-codcia NO-LOCK, ~
      EACH ExpDigit WHERE ExpDigit.CodCia = ExpTarea.CodCia ~
  AND ExpDigit.CodDiv = ExpTarea.CodDiv ~
  AND ExpDigit.CodDig = ExpTarea.CodDig OUTER-JOIN NO-LOCK ~
    BY ExpTurno.NroDig
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH ExpTurno WHERE ~{&KEY-PHRASE} ~
      AND ExpTurno.CodCia = s-codcia ~
 AND ExpTurno.CodDiv = s-coddiv ~
 AND ExpTurno.Fecha >= today - 10 ~
 AND ExpTurno.Estado BEGINS cb-estado ~
 AND ExpTurno.CodCli BEGINS txt-codcli ~
 AND (ExpTurno.NroDig = txt-nrodig ~
 OR txt-nrodig = 0) NO-LOCK, ~
      FIRST ExpTarea WHERE ExpTarea.CodCia = ExpTurno.CodCia ~
  AND ExpTarea.CodDiv = ExpTurno.CodDiv ~
  AND  ExpTarea.CodCli = ExpTurno.CodCli ~
  AND ExpTarea.NroDig = ExpTurno.NroDig OUTER-JOIN NO-LOCK, ~
      EACH gn-clie WHERE gn-clie.CodCli = ExpTurno.CodCli ~
      AND gn-clie.CodCia = cl-codcia NO-LOCK, ~
      EACH ExpDigit WHERE ExpDigit.CodCia = ExpTarea.CodCia ~
  AND ExpDigit.CodDiv = ExpTarea.CodDiv ~
  AND ExpDigit.CodDig = ExpTarea.CodDig OUTER-JOIN NO-LOCK ~
    BY ExpTurno.NroDig.
&Scoped-define TABLES-IN-QUERY-br_table ExpTurno ExpTarea gn-clie ExpDigit
&Scoped-define FIRST-TABLE-IN-QUERY-br_table ExpTurno
&Scoped-define SECOND-TABLE-IN-QUERY-br_table ExpTarea
&Scoped-define THIRD-TABLE-IN-QUERY-br_table gn-clie
&Scoped-define FOURTH-TABLE-IN-QUERY-br_table ExpDigit


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS txt-codcli txt-nrodig cb-estado br_table 
&Scoped-Define DISPLAYED-OBJECTS txt-codcli txt-nrodig cb-estado 

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
DEFINE VARIABLE cb-estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado Pedido" 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEM-PAIRS "Todos"," ",
                     "Generado","G",
                     "Digitado","D",
                     "Vendedor","P",
                     "Cerrado","C"
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE txt-codcli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-nrodig AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Nº Digitacion" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      ExpTurno, 
      ExpTarea, 
      gn-clie, 
      ExpDigit SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      ExpTurno.NroDig COLUMN-LABEL "Nº Digita" FORMAT ">>>>>9":U
            WIDTH 6.57 COLUMN-BGCOLOR 6
      ExpTurno.CodCli FORMAT "x(11)":U WIDTH 12
      gn-clie.NomCli FORMAT "x(50)":U WIDTH 40
      ExpTurno.Block + ' - ' + ExpTurno.CodVen @ cTerminal COLUMN-LABEL "Block" FORMAT "X(8)":U
            WIDTH 9
      IF (ExpTurno.Estado = 'G') THEN ('GENERADO') ELSE ( IF (ExpTurno.Estado = 'D') THEN ('DIGITACION') ELSE ( IF (ExpTurno.Estado = 'P') THEN ('VENDEDOR') ELSE ('CERRADO'))) @ cEstado COLUMN-LABEL "Situación" FORMAT "X(15)":U
            WIDTH 16
      ExpTurno.Fecha FORMAT "99/99/9999":U
      ExpTurno.Hora FORMAT "x(10)":U
      IF (ExpTarea.CodDig <> ?) THEN (ExpTarea.CodDig + ' - ' + ExpDigit.NomDig) ELSE ('') @ cNomDig COLUMN-LABEL "Digitador Asignado" FORMAT "X(50)":U
            WIDTH 35
      IF (ExpTarea.Libre_c02 <> ? ) THEN (ExpTarea.Libre_c02) ELSE ('') @ cHoraIni COLUMN-LABEL "Hora Inicio" FORMAT "X(20)":U
            WIDTH 15
      IF (ExpTarea.Libre_c03 <> ? ) THEN (ExpTarea.Libre_c03) ELSE ('') @ cHoraFin COLUMN-LABEL "Hora Fin" FORMAT "X(20)":U
            WIDTH 15
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 168 BY 16.69
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txt-codcli AT ROW 1.27 COL 15 COLON-ALIGNED WIDGET-ID 4
     txt-nrodig AT ROW 1.27 COL 49 COLON-ALIGNED WIDGET-ID 6
     cb-estado AT ROW 2.35 COL 15 COLON-ALIGNED WIDGET-ID 2
     br_table AT ROW 3.69 COL 2
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
         HEIGHT             = 21
         WIDTH              = 169.
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
/* BROWSE-TAB br_table cb-estado F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.ExpTurno,INTEGRAL.ExpTarea WHERE INTEGRAL.ExpTurno ...,INTEGRAL.gn-clie WHERE INTEGRAL.ExpTurno ...,INTEGRAL.ExpDigit WHERE INTEGRAL.ExpTarea ..."
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST OUTER,, OUTER"
     _OrdList          = "INTEGRAL.ExpTurno.NroDig|yes"
     _Where[1]         = "ExpTurno.CodCia = s-codcia
 AND ExpTurno.CodDiv = s-coddiv
 AND ExpTurno.Fecha >= today - 10
 AND ExpTurno.Estado BEGINS cb-estado
 AND ExpTurno.CodCli BEGINS txt-codcli
 AND (ExpTurno.NroDig = txt-nrodig
 OR txt-nrodig = 0)"
     _JoinCode[2]      = "ExpTarea.CodCia = ExpTurno.CodCia
  AND ExpTarea.CodDiv = ExpTurno.CodDiv
  AND  ExpTarea.CodCli = ExpTurno.CodCli
  AND ExpTarea.NroDig = ExpTurno.NroDig"
     _JoinCode[3]      = "gn-clie.CodCli = ExpTurno.CodCli"
     _Where[3]         = "gn-clie.CodCia = cl-codcia"
     _JoinCode[4]      = "ExpDigit.CodCia = ExpTarea.CodCia
  AND ExpDigit.CodDiv = ExpTarea.CodDiv
  AND ExpDigit.CodDig = ExpTarea.CodDig"
     _FldNameList[1]   > INTEGRAL.ExpTurno.NroDig
"ExpTurno.NroDig" "Nº Digita" ? "integer" 6 ? ? ? ? ? no ? no no "6.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.ExpTurno.CodCli
"ExpTurno.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.gn-clie.NomCli
"gn-clie.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"ExpTurno.Block + ' - ' + ExpTurno.CodVen @ cTerminal" "Block" "X(8)" ? ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"IF (ExpTurno.Estado = 'G') THEN ('GENERADO') ELSE ( IF (ExpTurno.Estado = 'D') THEN ('DIGITACION') ELSE ( IF (ExpTurno.Estado = 'P') THEN ('VENDEDOR') ELSE ('CERRADO'))) @ cEstado" "Situación" "X(15)" ? ? ? ? ? ? ? no ? no no "16" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = INTEGRAL.ExpTurno.Fecha
     _FldNameList[7]   = INTEGRAL.ExpTurno.Hora
     _FldNameList[8]   > "_<CALC>"
"IF (ExpTarea.CodDig <> ?) THEN (ExpTarea.CodDig + ' - ' + ExpDigit.NomDig) ELSE ('') @ cNomDig" "Digitador Asignado" "X(50)" ? ? ? ? ? ? ? no ? no no "35" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"IF (ExpTarea.Libre_c02 <> ? ) THEN (ExpTarea.Libre_c02) ELSE ('') @ cHoraIni" "Hora Inicio" "X(20)" ? ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"IF (ExpTarea.Libre_c03 <> ? ) THEN (ExpTarea.Libre_c03) ELSE ('') @ cHoraFin" "Hora Fin" "X(20)" ? ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME cb-estado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-estado B-table-Win
ON VALUE-CHANGED OF cb-estado IN FRAME F-Main /* Estado Pedido */
DO:
    ASSIGN cb-estado.
    RUN adm-open-query.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt-codcli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-codcli B-table-Win
ON LEAVE OF txt-codcli IN FRAME F-Main /* Cliente */
DO:
    ASSIGN txt-codcli.
    RUN adm-open-query.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt-nrodig
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-nrodig B-table-Win
ON LEAVE OF txt-nrodig IN FRAME F-Main /* Nº Digitacion */
DO:
    ASSIGN txt-nrodig.
    RUN adm-open-query. 
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
  {src/adm/template/snd-list.i "ExpTurno"}
  {src/adm/template/snd-list.i "ExpTarea"}
  {src/adm/template/snd-list.i "gn-clie"}
  {src/adm/template/snd-list.i "ExpDigit"}

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

