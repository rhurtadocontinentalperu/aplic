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
DEF SHARED VAR cl-codcia AS INT.

DEF VAR x-Estado AS CHAR.

DEF SHARED VAR lh_handle AS HANDLE.

DEF VAR nItems AS INT NO-UNDO.

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
&Scoped-define INTERNAL-TABLES ExpDigit ExpTarea gn-clie gn-ven

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table ExpDigit.CodDig ExpDigit.NomDig ~
fEstado() @ x-Estado ExpDigit.Libre_c01 fItems() @ nItems ExpTarea.CodCli ~
gn-clie.NomCli gn-ven.NomVen ExpTarea.Block ExpTarea.NroDig ExpTarea.Turno 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH ExpDigit WHERE ~{&KEY-PHRASE} ~
      AND ExpDigit.CodCia = s-codcia ~
 AND ExpDigit.CodDiv = s-coddiv NO-LOCK, ~
      LAST ExpTarea OF ExpDigit ~
      WHERE ExpTarea.Estado = "P" OUTER-JOIN NO-LOCK, ~
      FIRST gn-clie WHERE gn-clie.CodCli = ExpTarea.CodCli ~
      AND gn-clie.CodCia = cl-codcia OUTER-JOIN NO-LOCK, ~
      FIRST gn-ven OF ExpTarea OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH ExpDigit WHERE ~{&KEY-PHRASE} ~
      AND ExpDigit.CodCia = s-codcia ~
 AND ExpDigit.CodDiv = s-coddiv NO-LOCK, ~
      LAST ExpTarea OF ExpDigit ~
      WHERE ExpTarea.Estado = "P" OUTER-JOIN NO-LOCK, ~
      FIRST gn-clie WHERE gn-clie.CodCli = ExpTarea.CodCli ~
      AND gn-clie.CodCia = cl-codcia OUTER-JOIN NO-LOCK, ~
      FIRST gn-ven OF ExpTarea OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table ExpDigit ExpTarea gn-clie gn-ven
&Scoped-define FIRST-TABLE-IN-QUERY-br_table ExpDigit
&Scoped-define SECOND-TABLE-IN-QUERY-br_table ExpTarea
&Scoped-define THIRD-TABLE-IN-QUERY-br_table gn-clie
&Scoped-define FOURTH-TABLE-IN-QUERY-br_table gn-ven


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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fItems B-table-Win 
FUNCTION fItems RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-br_table 
       MENU-ITEM m_Reasignar_tarea LABEL "Reasignar tarea"
       MENU-ITEM m_Anular_tarea_asignada LABEL "Anular tarea asignada".


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      ExpDigit, 
      ExpTarea, 
      gn-clie, 
      gn-ven SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      ExpDigit.CodDig FORMAT "x(5)":U
      ExpDigit.NomDig COLUMN-LABEL "Nombre del Digitador" FORMAT "x(30)":U
            WIDTH 19.57
      fEstado() @ x-Estado COLUMN-LABEL "Estado" FORMAT "x(10)":U
            WIDTH 8.43
      ExpDigit.Libre_c01 COLUMN-LABEL "Ultima Digitación" FORMAT "x(16)":U
            WIDTH 13.43
      fItems() @ nItems COLUMN-LABEL "Items!Acum." FORMAT ">>>,>>9":U
      ExpTarea.CodCli FORMAT "x(11)":U WIDTH 14.86
      gn-clie.NomCli COLUMN-LABEL "Nombre del cliente" FORMAT "x(250)":U
            WIDTH 37.86
      gn-ven.NomVen FORMAT "X(40)":U WIDTH 33.43
      ExpTarea.Block FORMAT "x":U WIDTH 9
      ExpTarea.NroDig COLUMN-LABEL "Secuencia" FORMAT ">,>>>,>>9":U
            WIDTH 11.43
      ExpTarea.Turno FORMAT ">>>9":U WIDTH 7.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 176 BY 14.04
         FONT 4
         TITLE "SITUACIÓN ACTUAL DE LOS DIGITADORES" FIT-LAST-COLUMN.


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
         HEIGHT             = 14.27
         WIDTH              = 183.72.
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
       br_table:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-br_table:HANDLE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.ExpDigit,INTEGRAL.ExpTarea OF INTEGRAL.ExpDigit,INTEGRAL.gn-clie WHERE INTEGRAL.ExpTarea ...,INTEGRAL.gn-ven OF INTEGRAL.ExpTarea"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", LAST OUTER, FIRST OUTER, FIRST OUTER"
     _Where[1]         = "INTEGRAL.ExpDigit.CodCia = s-codcia
 AND INTEGRAL.ExpDigit.CodDiv = s-coddiv"
     _Where[2]         = "INTEGRAL.ExpTarea.Estado = ""P"""
     _JoinCode[3]      = "INTEGRAL.gn-clie.CodCli = INTEGRAL.ExpTarea.CodCli"
     _Where[3]         = "INTEGRAL.gn-clie.CodCia = cl-codcia"
     _FldNameList[1]   = INTEGRAL.ExpDigit.CodDig
     _FldNameList[2]   > INTEGRAL.ExpDigit.NomDig
"ExpDigit.NomDig" "Nombre del Digitador" ? "character" ? ? ? ? ? ? no ? no no "19.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fEstado() @ x-Estado" "Estado" "x(10)" ? ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.ExpDigit.Libre_c01
"ExpDigit.Libre_c01" "Ultima Digitación" "x(16)" "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fItems() @ nItems" "Items!Acum." ">>>,>>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.ExpTarea.CodCli
"ExpTarea.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "14.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.gn-clie.NomCli
"gn-clie.NomCli" "Nombre del cliente" ? "character" ? ? ? ? ? ? no ? no no "37.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.gn-ven.NomVen
"gn-ven.NomVen" ? ? "character" ? ? ? ? ? ? no ? no no "33.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.ExpTarea.Block
"ExpTarea.Block" ? ? "character" ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.ExpTarea.NroDig
"ExpTarea.NroDig" "Secuencia" ? "integer" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.ExpTarea.Turno
"ExpTarea.Turno" ? ? "integer" ? ? ? ? ? ? no ? no no "5.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-DISPLAY OF br_table IN FRAME F-Main /* SITUACIÓN ACTUAL DE LOS DIGITADORES */
DO:
    CASE ExpDigit.flgest:
        WHEN 'O' THEN DO:
            x-estado:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12.
        END.
        WHEN 'L' THEN DO:
            x-estado:BGCOLOR IN BROWSE {&BROWSE-NAME} = 2.
        END.
    END CASE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main /* SITUACIÓN ACTUAL DE LOS DIGITADORES */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* SITUACIÓN ACTUAL DE LOS DIGITADORES */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* SITUACIÓN ACTUAL DE LOS DIGITADORES */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Anular_tarea_asignada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Anular_tarea_asignada B-table-Win
ON CHOOSE OF MENU-ITEM m_Anular_tarea_asignada /* Anular tarea asignada */
DO:
    IF NOT AVAILABLE ExpDigit OR ExpDigit.FlgEst <> "O" THEN RETURN.
    IF NOT AVAILABLE ExpTarea THEN RETURN.
    /* consistencia de digitacion */
    FIND VtaCDocu WHERE Vtacdocu.codcia = ExpDigit.codcia
        AND Vtacdocu.coddiv = ExpDigit.coddiv
        AND Vtacdocu.codped = 'PET'
        AND Vtacdocu.libre_c03 = ExpTarea.Tipo + '-' + TRIM(STRING(ExpTurno.Turno))
        AND Vtacdocu.codven = ExpTarea.CodVen
        AND Vtacdocu.codcli = ExpTarea.CodCli
        AND Vtacdocu.flgest = "P"
        AND Vtacdocu.fchped >= TODAY - 1
        NO-LOCK NO-ERROR.
/*     FIND VtaCDocu WHERE Vtacdocu.codcia = ExpDigit.codcia */
/*         AND Vtacdocu.coddiv = ExpDigit.coddiv             */
/*         AND Vtacdocu.codped = 'PET'                       */
/*         AND Vtacdocu.usuario = ExpDigit.coddig            */
/*         AND Vtacdocu.flgest = "P"                         */
/*         AND Vtacdocu.fchped >= TODAY - 1                  */
/*         AND Vtacdocu.Libre_c01 = STRING(ROWID(ExpTarea))  */
/*         NO-LOCK NO-ERROR.                                 */
    IF AVAILABLE Vtacdocu THEN DO:
        MESSAGE 'Hay un pre-pedido digitado' SKIP
            'Pre-pedido Nro.' Vtacdocu.nroped SKIP
            'Anulación cancelada'
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
    MESSAGE 'Está completamente seguro de anular esta tarea asignada?'
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN.
    DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        FIND CURRENT ExpDigit EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE ExpDigit THEN LEAVE.
        FIND CURRENT Exptarea EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE ExpTarea THEN LEAVE.
        FIND ExpTurno WHERE ROWID(ExpTurno) = TO-ROWID(Exptarea.Libre_c01) EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE ExpTurno THEN LEAVE.
        ASSIGN
            /*Expturno.Estado = 'G'*/
            Expturno.Estado = 'P'
            ExpTurno.Libre_c02 = ''.
        DELETE ExpTarea.
        ASSIGN
            ExpDigit.FlgEst = 'L'.
        /* 30/10/2025: Control de atención del asistente */
        DEF VAR pMensaje AS CHAR NO-UNDO.
        RUN vtaexp/p-even_control_estado (INPUT "DELETE",
                                          INPUT s-coddiv,
                                          INPUT ExpTurno.Block,
                                          INPUT ExpTurno.codcli,
                                          INPUT 20,       /* Anular Digitador Asignado */
                                          OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
            UNDO, RETURN NO-APPLY.
        END.

    END.
    FIND CURRENT ExpDigit NO-LOCK.
    IF AVAILABLE(ExpTurno) THEN RELEASE ExpTurno.
    IF AVAILABLE(ExpTarea) THEN RELEASE ExpTarea.
    RUN Procesa-Handle IN lh_handle ('Refrescar-Browses').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Reasignar_tarea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Reasignar_tarea B-table-Win
ON CHOOSE OF MENU-ITEM m_Reasignar_tarea /* Reasignar tarea */
DO:
    IF NOT AVAILABLE ExpDigit OR ExpDigit.FlgEst <> "O" THEN RETURN.
    DEF VAR pOk AS CHAR.
    RUN vtaexp/d-digita-01c (ROWID(ExpDigit), OUTPUT pOk).
    IF pOk = 'OK' THEN RUN Procesa-Handle IN lh_handle ('Refrescar-Browses').
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
  {src/adm/template/snd-list.i "ExpDigit"}
  {src/adm/template/snd-list.i "ExpTarea"}
  {src/adm/template/snd-list.i "gn-clie"}
  {src/adm/template/snd-list.i "gn-ven"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

CASE ExpDigit.FlgEst:
    WHEN 'L' THEN RETURN 'LIBRE'.
    WHEN 'O' THEN RETURN 'OCUPADO'.
    OTHERWISE RETURN '¿¿¿???'.
END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fItems B-table-Win 
FUNCTION fItems RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  Items digitados hasta el momento
------------------------------------------------------------------------------*/

  DEF BUFFER B-TAREA FOR ExpTarea.
  DEF VAR nItems AS INT INIT 0 NO-UNDO.
  FOR EACH B-Tarea NO-LOCK WHERE B-Tarea.CodCia =  ExpDigit.CodCia
      AND B-Tarea.CodDig = ExpDigit.CodDig 
      AND B-Tarea.CodDiv =  ExpDigit.CodDiv
      AND B-Tarea.Fecha >= TODAY - 3 :
      nItems = nItems +  B-Tarea.Libre_d01.
  END.
  RETURN nItems.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

