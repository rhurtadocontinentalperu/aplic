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
DEF SHARED VAR s-CodCia     AS INTEGER.
DEF SHARED VAR cl-CodCia    AS INTEGER.
DEF SHARED VAR s-CodDoc     AS CHAR INIT 'COT'.
DEF SHARED VAR s-CodDiv     AS CHAR.
DEF SHARED VAR s-user-id    AS CHAR.

DEF NEW SHARED VAR p-monto  AS DECIMAL.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE cNroCot     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLista      AS CHARACTER   NO-UNDO.
DEFINE BUFFER b-faccpedi FOR FacCPedi.

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
&Scoped-define INTERNAL-TABLES FacCPedi gn-clie ClfClie

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table ~
SUBSTRING (NroPed,1,3) + '-' +  SUBSTRING (NroPed,4) @ NroPed ~
_Lista()  @ cLista FacCPedi.NomCli FacCPedi.FchPed gn-clie.clfCli ~
ClfClie.PorDsc FacCPedi.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND FacCPedi.CodCia = s-CodCia ~
 AND FacCPedi.CodDiv = s-CodDiv ~
 AND FacCPedi.CodDoc = s-CodDoc ~
 AND FacCPedi.FlgEst = "E" ~
 AND (FacCPedi.CodVen = txt-codven ~
 OR txt-codven = '') NO-LOCK, ~
      EACH gn-clie WHERE gn-clie.CodCia = cl-codcia ~
  AND gn-clie.CodCli = FacCPedi.CodCli NO-LOCK, ~
      EACH ClfClie WHERE ClfClie.Categoria = gn-clie.clfCli NO-LOCK ~
    BY FacCPedi.FchPed DESCENDING ~
       BY FacCPedi.NroPed
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND FacCPedi.CodCia = s-CodCia ~
 AND FacCPedi.CodDiv = s-CodDiv ~
 AND FacCPedi.CodDoc = s-CodDoc ~
 AND FacCPedi.FlgEst = "E" ~
 AND (FacCPedi.CodVen = txt-codven ~
 OR txt-codven = '') NO-LOCK, ~
      EACH gn-clie WHERE gn-clie.CodCia = cl-codcia ~
  AND gn-clie.CodCli = FacCPedi.CodCli NO-LOCK, ~
      EACH ClfClie WHERE ClfClie.Categoria = gn-clie.clfCli NO-LOCK ~
    BY FacCPedi.FchPed DESCENDING ~
       BY FacCPedi.NroPed.
&Scoped-define TABLES-IN-QUERY-br_table FacCPedi gn-clie ClfClie
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacCPedi
&Scoped-define SECOND-TABLE-IN-QUERY-br_table gn-clie
&Scoped-define THIRD-TABLE-IN-QUERY-br_table ClfClie


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br_table}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS txt-codven br_table 
&Scoped-Define DISPLAYED-OBJECTS txt-codven txt-nomven 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD _Lista B-table-Win 
FUNCTION _Lista RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE txt-codven AS CHARACTER FORMAT "X(3)":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE txt-nomven AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      FacCPedi, 
      gn-clie, 
      ClfClie SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      SUBSTRING (NroPed,1,3) + '-' +  SUBSTRING (NroPed,4) @ NroPed COLUMN-LABEL "Nº Cotizacion" FORMAT "X(10)":U
            WIDTH 10
      _Lista()  @ cLista COLUMN-LABEL "Lista" FORMAT "X(3)":U
      FacCPedi.NomCli FORMAT "x(50)":U
      FacCPedi.FchPed FORMAT "99/99/9999":U
      gn-clie.clfCli COLUMN-LABEL "Clf" FORMAT "X(2)":U
      ClfClie.PorDsc COLUMN-LABEL "% Dscto." FORMAT "->>9.999999":U
      FacCPedi.ImpTot FORMAT "->>,>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 85 BY 8.08
         FONT 4
         TITLE "Cotizaciones Pendientes".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txt-codven AT ROW 1.27 COL 9 COLON-ALIGNED WIDGET-ID 2
     txt-nomven AT ROW 1.27 COL 16 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     br_table AT ROW 2.35 COL 1
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
         HEIGHT             = 9.92
         WIDTH              = 95.29.
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
/* BROWSE-TAB br_table txt-nomven F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN txt-nomven IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.FacCPedi,INTEGRAL.gn-clie WHERE INTEGRAL.FacCPedi ...,INTEGRAL.ClfClie WHERE INTEGRAL.gn-clie ..."
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ",,"
     _OrdList          = "INTEGRAL.FacCPedi.FchPed|no,INTEGRAL.FacCPedi.NroPed|yes"
     _Where[1]         = "FacCPedi.CodCia = s-CodCia
 AND FacCPedi.CodDiv = s-CodDiv
 AND FacCPedi.CodDoc = s-CodDoc
 AND FacCPedi.FlgEst = ""E""
 AND (FacCPedi.CodVen = txt-codven
 OR txt-codven = '')"
     _JoinCode[2]      = "gn-clie.CodCia = cl-codcia
  AND gn-clie.CodCli = FacCPedi.CodCli"
     _JoinCode[3]      = "ClfClie.Categoria = gn-clie.clfCli"
     _FldNameList[1]   > "_<CALC>"
"SUBSTRING (NroPed,1,3) + '-' +  SUBSTRING (NroPed,4) @ NroPed" "Nº Cotizacion" "X(10)" ? ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"_Lista()  @ cLista" "Lista" "X(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.FacCPedi.NomCli
     _FldNameList[4]   = INTEGRAL.FacCPedi.FchPed
     _FldNameList[5]   > INTEGRAL.gn-clie.clfCli
"gn-clie.clfCli" "Clf" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.ClfClie.PorDsc
"ClfClie.PorDsc" "% Dscto." ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = INTEGRAL.FacCPedi.ImpTot
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* Cotizaciones Pendientes */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* Cotizaciones Pendientes */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* Cotizaciones Pendientes */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}  
      p-monto = 0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt-codven
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-codven B-table-Win
ON LEAVE OF txt-codven IN FRAME F-Main /* Vendedor */
DO:
    ASSIGN txt-codven.
    RUN adm-open-query.
    FIND FIRST gn-ven WHERE gn-ven.CodCia = s-CodCia
        AND gn-ven.CodVen = txt-codven NO-LOCK NO-ERROR. 
    IF AVAIL gn-ven THEN DISPLAY gn-ven.NomVen @ txt-nomven WITH FRAME {&FRAME-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aprobar-Cotizaciones B-table-Win 
PROCEDURE Aprobar-Cotizaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR i AS INT NO-UNDO.
    DO WITH FRAME {&FRAME-NAME}:
        DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
            IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN DO:
                IF i = 1 THEN cNroCot = TRIM(FacCPedi.NroPed).
                ELSE cNroCot = cNroCot + ',' + TRIM(FacCPedi.NroPed).
            END.
        END.
    END. 

    DO i = 1 TO NUM-ENTRIES(cNroCot):
        FIND FIRST b-FacCPedi WHERE b-FacCPedi.CodCia = s-CodCia
            AND b-FacCPedi.CodDoc = s-CodDoc
            AND b-FacCPedi.NroPed = ENTRY(i,cNroCot,',') EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL b-FacCPedi THEN
            ASSIGN 
                b-FacCPedi.FlgEst        = 'P'
                /*b-FacCPedi.FlgSit        = 'P'*/
                b-FacCPedi.FchAprobacion = TODAY
                b-FacCPedi.UsrAprobacion = s-user-id.        
    END.

    RUN adm-open-query.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rechaza-Cotizacion B-table-Win 
PROCEDURE Rechaza-Cotizacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR i AS INT NO-UNDO.
    DO WITH FRAME {&FRAME-NAME}:
        DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
            IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN DO:
                IF i = 1 THEN cNroCot = TRIM(FacCPedi.NroPed).
                ELSE cNroCot = cNroCot + ',' + TRIM(FacCPedi.NroPed).
            END.
        END.
    END.    

    DO i = 1 TO NUM-ENTRIES(cNroCot):
        FIND FIRST b-FacCPedi WHERE b-FacCPedi.CodCia = s-CodCia
            AND b-FacCPedi.CodDoc = s-CodDoc
            AND b-FacCPedi.NroPed = ENTRY(i,cNroCot,',') EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL b-FacCPedi THEN
            ASSIGN 
                b-FacCPedi.FlgEst = 'R'.
/*             ASSIGN                       */
/*                 b-FacCPedi.FlgEst = 'P'  */
/*                 b-FacCPedi.FlgSit = 'R'. */
    END.

    RUN dispatch IN THIS-PROCEDURE ('open-query').

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
  {src/adm/template/snd-list.i "gn-clie"}
  {src/adm/template/snd-list.i "ClfClie"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION _Lista B-table-Win 
FUNCTION _Lista RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
FIND FIRST vtaclicam WHERE vtaclicam.codcia = cl-codcia
    AND vtaclicam.codcli = faccpedi.codcli NO-LOCK NO-ERROR.
IF AVAILABLE vtaclicam 
THEN RETURN '***'.
ELSE RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

