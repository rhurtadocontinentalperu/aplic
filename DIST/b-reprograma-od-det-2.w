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
DEF VAR x-Usuario AS CHAR NO-UNDO.
DEF VAR x-NomUsuario AS CHAR NO-UNDO.
DEF VAR x-FechaHora AS CHAR NO-UNDO.
DEF VAR x-Motivo AS CHAR NO-UNDO.
DEF VAR x-Responsable AS CHAR NO-UNDO.
DEF VAR x-NC AS CHAR NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES FacCPedi
&Scoped-define FIRST-EXTERNAL-TABLE FacCPedi


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR FacCPedi.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCDocu AlmCDocu

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CcbCDocu.CodDoc CcbCDocu.NroDoc ~
CcbCDocu.FchDoc CcbCDocu.CodCli CcbCDocu.NomCli CcbCDocu.ImpTot ~
ENTRY(1,fUsuarioFecha(),'|')  @ x-Usuario ~
ENTRY(2,fUsuarioFecha(),'|')  @ x-NomUsuario ~
ENTRY(3,fUsuarioFecha(),'|') + ' ' + ENTRY(4,fUsuarioFecha(),'|') @ x-FechaHora ~
AlmCDocu.Libre_c01 AlmCDocu.Libre_c02 fMotivoNoEntregado() @ x-Motivo ~
fPrimerResponsable() @ x-Responsable fNC() @ x-NC 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH CcbCDocu WHERE CcbCDocu.CodCia = FacCPedi.CodCia ~
  AND CcbCDocu.CodPed = FacCPedi.CodRef ~
  AND CcbCDocu.NroPed = FacCPedi.NroRef ~
  AND CcbCDocu.Libre_c01 = FacCPedi.CodDoc ~
  AND CcbCDocu.Libre_c02 = FacCPedi.NroPed ~
 ~
      AND (CcbCDocu.CodDoc = "FAC" ~
  OR CcbCDocu.CodDoc = "BOL" ~
  OR CcbCDocu.CodDoc = "G/R") ~
 AND LOOKUP(CcbCDocu.FlgEst, "C,P,F") > 0 NO-LOCK, ~
      FIRST AlmCDocu WHERE AlmCDocu.CodCia = CcbCDocu.CodCia ~
  AND AlmCDocu.CodLlave = CcbCDocu.CodDiv ~
  AND AlmCDocu.CodDoc = CcbCDocu.Libre_c01 ~
  AND AlmCDocu.NroDoc = CcbCDocu.Libre_c02 OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH CcbCDocu WHERE CcbCDocu.CodCia = FacCPedi.CodCia ~
  AND CcbCDocu.CodPed = FacCPedi.CodRef ~
  AND CcbCDocu.NroPed = FacCPedi.NroRef ~
  AND CcbCDocu.Libre_c01 = FacCPedi.CodDoc ~
  AND CcbCDocu.Libre_c02 = FacCPedi.NroPed ~
 ~
      AND (CcbCDocu.CodDoc = "FAC" ~
  OR CcbCDocu.CodDoc = "BOL" ~
  OR CcbCDocu.CodDoc = "G/R") ~
 AND LOOKUP(CcbCDocu.FlgEst, "C,P,F") > 0 NO-LOCK, ~
      FIRST AlmCDocu WHERE AlmCDocu.CodCia = CcbCDocu.CodCia ~
  AND AlmCDocu.CodLlave = CcbCDocu.CodDiv ~
  AND AlmCDocu.CodDoc = CcbCDocu.Libre_c01 ~
  AND AlmCDocu.NroDoc = CcbCDocu.Libre_c02 OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table CcbCDocu AlmCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CcbCDocu
&Scoped-define SECOND-TABLE-IN-QUERY-br_table AlmCDocu


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fMotivoNoEntregado B-table-Win 
FUNCTION fMotivoNoEntregado RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNC B-table-Win 
FUNCTION fNC RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPrimerResponsable B-table-Win 
FUNCTION fPrimerResponsable RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fUsuarioFecha B-table-Win 
FUNCTION fUsuarioFecha RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      CcbCDocu, 
      AlmCDocu
    FIELDS(AlmCDocu.Libre_c01
      AlmCDocu.Libre_c02) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      CcbCDocu.CodDoc FORMAT "x(3)":U
      CcbCDocu.NroDoc FORMAT "X(12)":U WIDTH 10.57
      CcbCDocu.FchDoc FORMAT "99/99/9999":U
      CcbCDocu.CodCli FORMAT "x(11)":U WIDTH 12.72
      CcbCDocu.NomCli FORMAT "x(60)":U WIDTH 41.43
      CcbCDocu.ImpTot FORMAT "->>,>>>,>>9.99":U
      ENTRY(1,fUsuarioFecha(),'|')  @ x-Usuario COLUMN-LABEL "Usu. Reprog." FORMAT "x(10)":U
            COLUMN-FGCOLOR 1 COLUMN-BGCOLOR 8
      ENTRY(2,fUsuarioFecha(),'|')  @ x-NomUsuario COLUMN-LABEL "Nombre" FORMAT "x(20)":U
            WIDTH 19 COLUMN-FGCOLOR 1 COLUMN-BGCOLOR 8
      ENTRY(3,fUsuarioFecha(),'|') + ' ' + ENTRY(4,fUsuarioFecha(),'|') @ x-FechaHora COLUMN-LABEL "Fecha Hora" FORMAT "x(20)":U
            COLUMN-FGCOLOR 1 COLUMN-BGCOLOR 8
      AlmCDocu.Libre_c01 COLUMN-LABEL "Doc." FORMAT "x(3)":U COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      AlmCDocu.Libre_c02 COLUMN-LABEL "Nro. H/R" FORMAT "x(12)":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      fMotivoNoEntregado() @ x-Motivo COLUMN-LABEL "Motivo no Entregado" FORMAT "x(30)":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 13
      fPrimerResponsable() @ x-Responsable COLUMN-LABEL "Primer Responsable" FORMAT "x(40)":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 13
      fNC() @ x-NC COLUMN-LABEL "Nota de Crédito" FORMAT "x(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 95 BY 6.69
         FONT 4
         TITLE "COMPROBANTES RELACIONADOS" FIT-LAST-COLUMN.


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
   External Tables: INTEGRAL.FacCPedi
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
         HEIGHT             = 6.85
         WIDTH              = 96.72.
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
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 2.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.CcbCDocu WHERE INTEGRAL.FacCPedi ...,INTEGRAL.AlmCDocu WHERE INTEGRAL.CcbCDocu ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST OUTER USED"
     _JoinCode[1]      = "CcbCDocu.CodCia = FacCPedi.CodCia
  AND CcbCDocu.CodPed = FacCPedi.CodRef
  AND CcbCDocu.NroPed = FacCPedi.NroRef
  AND CcbCDocu.Libre_c01 = FacCPedi.CodDoc
  AND CcbCDocu.Libre_c02 = FacCPedi.NroPed
"
     _Where[1]         = "(CcbCDocu.CodDoc = ""FAC""
  OR CcbCDocu.CodDoc = ""BOL""
  OR CcbCDocu.CodDoc = ""G/R"")
 AND LOOKUP(CcbCDocu.FlgEst, ""C,P,F"") > 0"
     _JoinCode[2]      = "AlmCDocu.CodCia = CcbCDocu.CodCia
  AND AlmCDocu.CodLlave = CcbCDocu.CodDiv
  AND AlmCDocu.CodDoc = CcbCDocu.Libre_c01
  AND AlmCDocu.NroDoc = CcbCDocu.Libre_c02"
     _FldNameList[1]   = INTEGRAL.CcbCDocu.CodDoc
     _FldNameList[2]   > INTEGRAL.CcbCDocu.NroDoc
"CcbCDocu.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "10.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.CcbCDocu.FchDoc
     _FldNameList[4]   > INTEGRAL.CcbCDocu.CodCli
"CcbCDocu.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "12.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.CcbCDocu.NomCli
"CcbCDocu.NomCli" ? "x(60)" "character" ? ? ? ? ? ? no ? no no "41.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = INTEGRAL.CcbCDocu.ImpTot
     _FldNameList[7]   > "_<CALC>"
"ENTRY(1,fUsuarioFecha(),'|')  @ x-Usuario" "Usu. Reprog." "x(10)" ? 8 1 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"ENTRY(2,fUsuarioFecha(),'|')  @ x-NomUsuario" "Nombre" "x(20)" ? 8 1 ? ? ? ? no ? no no "19" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"ENTRY(3,fUsuarioFecha(),'|') + ' ' + ENTRY(4,fUsuarioFecha(),'|') @ x-FechaHora" "Fecha Hora" "x(20)" ? 8 1 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.AlmCDocu.Libre_c01
"AlmCDocu.Libre_c01" "Doc." "x(3)" "character" 14 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.AlmCDocu.Libre_c02
"AlmCDocu.Libre_c02" "Nro. H/R" "x(12)" "character" 14 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"fMotivoNoEntregado() @ x-Motivo" "Motivo no Entregado" "x(30)" ? 13 15 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"fPrimerResponsable() @ x-Responsable" "Primer Responsable" "x(40)" ? 13 15 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"fNC() @ x-NC" "Nota de Crédito" "x(40)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* COMPROBANTES RELACIONADOS */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* COMPROBANTES RELACIONADOS */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* COMPROBANTES RELACIONADOS */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
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
  {src/adm/template/row-list.i "FacCPedi"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "FacCPedi"}

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
  {src/adm/template/snd-list.i "FacCPedi"}
  {src/adm/template/snd-list.i "CcbCDocu"}
  {src/adm/template/snd-list.i "AlmCDocu"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fMotivoNoEntregado B-table-Win 
FUNCTION fMotivoNoEntregado RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pMotivo AS CHAR NO-UNDO.


/*   FIND AlmCDocu WHERE AlmCDocu.CodCia = CcbCDocu.CodCia */
/*       AND AlmCDocu.CodLlave = CcbCDocu.CodDiv           */
/*       AND AlmCDocu.CodDoc = CcbCDocu.Libre_c01          */
/*       AND AlmCDocu.NroDoc = CcbCDocu.Libre_c02          */
/*       NO-LOCK NO-ERROR.                                 */
  IF AVAILABLE AlmCDocu THEN DO:
      FIND DI-RutaD WHERE DI-RutaD.CodCia = Ccbcdocu.codcia AND
          DI-RutaD.CodDiv = Ccbcdocu.coddiv AND
          DI-RutaD.CodDoc = "H/R" AND 
          DI-RutaD.CodRef = Ccbcdocu.coddoc AND
          DI-RutaD.NroRef = Ccbcdocu.nrodoc
          NO-LOCK NO-ERROR.
      IF AVAILABLE DI-RutaD THEN DO:
          FIND almtabla WHERE almtabla.Tabla = "HR" AND 
              almtabla.NomAnt = "N" AND 
              almtabla.CodCta1 <> "I" AND 
              almtabla.Codigo = DI-RutaD.FlgEstDet
              NO-LOCK NO-ERROR.
          IF AVAILABLE almtabla THEN RETURN almtabla.Nombre.
      END.
  END.
  RETURN pMotivo.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNC B-table-Win 
FUNCTION fNC RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pNC AS CHAR NO-UNDO.
  DEF BUFFER B-CDOCU FOR Ccbcdocu.

      FOR EACH B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = s-codcia
          AND B-CDOCU.coddoc = "N/C"
          AND B-CDOCU.codref = Ccbcdocu.coddoc
          AND B-CDOCU.nroref = Ccbcdocu.nrodoc
          AND B-CDOCU.flgest <> 'A':
          pNC = pNC + (IF TRUE <> (pNC > '') THEN '' ELSE ',') + B-CDOCU.nrodoc.
      END.

  RETURN pNC.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPrimerResponsable B-table-Win 
FUNCTION fPrimerResponsable RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pNombre AS CHAR NO-UNDO.

  IF AVAILABLE AlmCDocu THEN DO:
      FIND DI-RutaD WHERE DI-RutaD.CodCia = Ccbcdocu.codcia AND
          DI-RutaD.CodDiv = Ccbcdocu.coddiv AND
          DI-RutaD.CodDoc = "H/R" AND 
          DI-RutaD.CodRef = Ccbcdocu.coddoc AND
          DI-RutaD.NroRef = Ccbcdocu.nrodoc
          NO-LOCK NO-ERROR.
      IF AVAILABLE DI-RutaD THEN DO:
          FIND DI-RutaC OF DI-RutaD NO-LOCK NO-ERROR.
          IF AVAILABLE DI-RutaC THEN RUN gn/nombre-personal (s-CodCia, DI-RutaC.responsable, OUTPUT pNombre).
      END.
  END.
  RETURN pNombre.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fUsuarioFecha B-table-Win 
FUNCTION fUsuarioFecha RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF BUFFER B-Almcdocu FOR Almcdocu.

  DEF VAR pNombre AS CHAR NO-UNDO.

  FOR EACH Di-RutaD NO-LOCK WHERE DI-RutaD.CodCia = s-codcia 
      AND DI-RutaD.CodDiv = s-coddiv
      AND DI-RutaD.CodDoc = "H/R"
      AND DI-RutaD.CodRef = Ccbcdocu.coddoc
      AND DI-RutaD.NroRef = Ccbcdocu.nrodoc,
      FIRST Di-RutaC OF Di-RutaD NO-LOCK WHERE Di-RutaC.FlgEst = "C":
      /* Buscamos por la O/D reprogramada */
      FIND LogTabla WHERE logtabla.codcia = s-codcia
          AND logtabla.Evento = "REPROGRAMACION"
          AND logtabla.Tabla = 'ALMCDOCU'
          AND logtabla.ValorLlave = (s-CodDiv + '|' + Faccpedi.CodDoc + '|' + Faccpedi.NroPed + '|' +
          DI-RutaC.CodDoc + '|' + DI-RutaC.NroDoc)
          NO-LOCK NO-ERROR.
      IF AVAILABLE LogTabla THEN DO:
          RUN gn/nombre-usuario (logtabla.Usuario, OUTPUT pNombre).
          RETURN logtabla.Usuario + '|' + pNombre + '|' + 
              STRING(logtabla.Dia, '99/99/9999') + '|' +
              logtabla.Hora.
      END.
  END.
  RETURN "|||".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

