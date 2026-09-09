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
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.

/* Local Variable Definitions ---                                       */
DEF VAR x-Situacion AS CHAR FORMAT 'x(20)' NO-UNDO.

DEF VAR x-Picador AS CHAR FORMAT 'x(50)' NO-UNDO.
DEF VAR x-Mesa AS CHAR FORMAT 'x(8)' COLUMN-LABEL 'Mesa'.

DEF VAR x-Bultos AS INTE NO-UNDO.

DEFINE TEMP-TABLE ttOrdenes
    FIELDS  tcoddoc     AS  CHAR    FORMAT  'x(5)'
    FIELDS  tnrodoc     AS  CHAR    FORMAT  'x(15)'
    FIELDS  tcoddiv     AS  CHAR    FORMAT  'x(10)'
    .

DEF VAR cNroPHR AS CHAR FORMAT 'x(15)' NO-UNDO.

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
&Scoped-define INTERNAL-TABLES VtaCDocu

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table VtaCDocu.CodPed VtaCDocu.NroPed ~
VtaCDocu.FchPed fNroPHR() @ cNroPHR VtaCDocu.Items VtaCDocu.Peso ~
VtaCDocu.Volumen fBultos() @ x-Bultos VtaCDocu.ZonaPickeo ~
fSituacion() @ x-Situacion VtaCDocu.FlgSit VtaCDocu.Glosa ~
fPicador(Vtacdocu.UsrSac) @ x-Picador fChequeador() @ x-Mesa 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH VtaCDocu WHERE VtaCDocu.CodCia = FacCPedi.CodCia ~
  AND VtaCDocu.CodDiv = FacCPedi.DivDes ~
  AND VtaCDocu.CodRef = FacCPedi.CodDoc ~
  AND VtaCDocu.NroRef = FacCPedi.NroPed ~
      AND VtaCDocu.CodPed = "HPK" ~
 /*AND VtaCDocu.FlgEst <> "A"*/ NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH VtaCDocu WHERE VtaCDocu.CodCia = FacCPedi.CodCia ~
  AND VtaCDocu.CodDiv = FacCPedi.DivDes ~
  AND VtaCDocu.CodRef = FacCPedi.CodDoc ~
  AND VtaCDocu.NroRef = FacCPedi.NroPed ~
      AND VtaCDocu.CodPed = "HPK" ~
 /*AND VtaCDocu.FlgEst <> "A"*/ NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table VtaCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-br_table VtaCDocu


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fBultos B-table-Win 
FUNCTION fBultos RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fChequeador B-table-Win 
FUNCTION fChequeador RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fMesa B-table-Win 
FUNCTION fMesa RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNroPHR B-table-Win 
FUNCTION fNroPHR RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPicador B-table-Win 
FUNCTION fPicador RETURNS CHARACTER
  ( INPUT pDNI AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSituacion B-table-Win 
FUNCTION fSituacion RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-br_table 
       MENU-ITEM m_Detalle_HPK  LABEL "Detalle HPK"   
       MENU-ITEM m_Log_de_Checking LABEL "Log de Checking".


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      VtaCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      VtaCDocu.CodPed FORMAT "x(3)":U
      VtaCDocu.NroPed FORMAT "X(12)":U WIDTH 11.57
      VtaCDocu.FchPed FORMAT "99/99/99":U
      fNroPHR() @ cNroPHR COLUMN-LABEL "Referencia" WIDTH 13
      VtaCDocu.Items FORMAT ">>>,>>9":U
      VtaCDocu.Peso FORMAT "->>>,>>9.99":U
      VtaCDocu.Volumen FORMAT "->>>,>>9.99":U
      fBultos() @ x-Bultos COLUMN-LABEL "Bultos"
      VtaCDocu.ZonaPickeo FORMAT "x(10)":U
      fSituacion() @ x-Situacion COLUMN-LABEL "Situación"
      VtaCDocu.FlgSit COLUMN-LABEL "Sit" FORMAT "x(2)":U WIDTH 3.29
      VtaCDocu.Glosa FORMAT "X(60)":U WIDTH 34.72
      fPicador(Vtacdocu.UsrSac) @ x-Picador COLUMN-LABEL "Picador" FORMAT "x(50)":U
      fChequeador() @ x-Mesa COLUMN-LABEL "Chequeador" FORMAT "x(80)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 176 BY 12.92
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.08 COL 1.43
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
         HEIGHT             = 13.73
         WIDTH              = 178.57.
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
       br_table:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-br_table:HANDLE
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 2.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.VtaCDocu WHERE INTEGRAL.FacCPedi <external> ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _JoinCode[1]      = "VtaCDocu.CodCia = FacCPedi.CodCia
  AND VtaCDocu.CodDiv = FacCPedi.DivDes
  AND VtaCDocu.CodRef = FacCPedi.CodDoc
  AND VtaCDocu.NroRef = FacCPedi.NroPed"
     _Where[1]         = "VtaCDocu.CodPed = ""HPK""
 /*AND VtaCDocu.FlgEst <> ""A""*/"
     _FldNameList[1]   = INTEGRAL.VtaCDocu.CodPed
     _FldNameList[2]   > INTEGRAL.VtaCDocu.NroPed
"VtaCDocu.NroPed" ? ? "character" ? ? ? ? ? ? no ? no no "11.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.VtaCDocu.FchPed
     _FldNameList[4]   > "_<CALC>"
"fNroPHR() @ cNroPHR" "Referencia" ? ? ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = INTEGRAL.VtaCDocu.Items
     _FldNameList[6]   = INTEGRAL.VtaCDocu.Peso
     _FldNameList[7]   = INTEGRAL.VtaCDocu.Volumen
     _FldNameList[8]   > "_<CALC>"
"fBultos() @ x-Bultos" "Bultos" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   = INTEGRAL.VtaCDocu.ZonaPickeo
     _FldNameList[10]   > "_<CALC>"
"fSituacion() @ x-Situacion" "Situación" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.VtaCDocu.FlgSit
"VtaCDocu.FlgSit" "Sit" "x(2)" "character" ? ? ? ? ? ? no ? no no "3.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.VtaCDocu.Glosa
"VtaCDocu.Glosa" ? ? "character" ? ? ? ? ? ? no ? no no "34.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"fPicador(Vtacdocu.UsrSac) @ x-Picador" "Picador" "x(50)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"fChequeador() @ x-Mesa" "Chequeador" "x(80)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME m_Detalle_HPK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Detalle_HPK B-table-Win
ON CHOOSE OF MENU-ITEM m_Detalle_HPK /* Detalle HPK */
DO:
    IF NOT AVAILABLE Vtacdocu THEN RETURN.
    RUN logis/d-revisar-hpk.r (Vtacdocu.codped, Vtacdocu.nroped).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Log_de_Checking
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Log_de_Checking B-table-Win
ON CHOOSE OF MENU-ITEM m_Log_de_Checking /* Log de Checking */
DO:
  IF AVAILABLE Vtacdocu THEN RUN logis/d-consulta-de-ordenes (VtaCDocu.CodPed, VtaCDocu.NroPed).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ordenes-involucrados B-table-Win 
PROCEDURE ordenes-involucrados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pCodDoc AS CHAR.
    DEFINE INPUT PARAMETER pNroDoc AS CHAR.

    DEFINE VAR x-llave AS CHAR.
    DEFINE BUFFER x-almddocu FOR almddocu.

    EMPTY TEMP-TABLE ttOrdenes.

    IF Vtacdocu.codter = 'ACUMULATIVO' THEN DO:
        x-llave = pCodDoc + "," + pNroDOc.
        FOR EACH x-almddocu WHERE x-almddocu.codcia = s-codcia AND 
            x-almddocu.codllave = x-llave NO-LOCK
            BREAK BY coddoc BY nrodoc.
            IF FIRST-OF(x-almddocu.coddoc) OR FIRST-OF(x-almddocu.nrodoc) THEN DO:
                CREATE ttOrdenes.
                    ASSIGN 
                        tcoddoc = x-almddocu.coddoc
                        tnrodoc = x-almddocu.nrodoc.
            END.
        END.
    END.
    ELSE DO:
        CREATE ttOrdenes.
            ASSIGN 
                tcoddoc = Vtacdocu.codref
                tnrodoc = Vtacdocu.nroref.
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
  {src/adm/template/snd-list.i "VtaCDocu"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fBultos B-table-Win 
FUNCTION fBultos RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF NOT AVAILABLE Vtacdocu THEN RETURN 0.   /* Function return value. */

  DEFINE BUFFER x-ControlOD FOR ControlOD.
  DEFINE BUFFER x-almddocu FOR almddocu.

  RUN ordenes-involucrados(INPUT VtaCDocu.CodPed, INPUT VtaCDocu.NroPed).   /* HPK */

  DEF VAR x-coddoc-nrodoc AS CHAR.
  DEF VAR x-col-bultos AS INTE.

  x-coddoc-nrodoc = VtaCDocu.CodPed + "-" + VtaCDocu.NroPed.
  x-col-bultos = 0.
  FOR EACH ttOrdenes :
      FOR EACH x-ControlOD WHERE x-ControlOD.codcia = s-codcia AND 
          x-ControlOD.coddoc = ttOrdenes.tCodDoc AND
          x-ControlOD.nrodoc = ttOrdenes.tnroDoc AND
          x-controlOD.nroetq BEGINS x-coddoc-nrodoc NO-LOCK:
          x-col-bultos =  x-col-bultos + 1.
      END.
  END.
  RETURN x-col-bultos.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fChequeador B-table-Win 
FUNCTION fChequeador RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-dni AS CHAR NO-UNDO.
  DEF VAR x-retval AS CHAR NO-UNDO.
  DEF VAR x-origen AS CHAR NO-UNDO.

  IF vtacdocu.libre_c04 > "" THEN DO:
      x-dni = ENTRY(1,vtacdocu.libre_c04,"|").
      RUN logis/p-busca-por-dni.r(INPUT x-dni, OUTPUT x-retval, OUTPUT x-origen).
  END.
  IF TRUE <> (x-retval > '') THEN DO:
      FIND FIRST pl-pers WHERE  pl-pers.codper = x-dni NO-LOCK NO-ERROR.
      IF  AVAILABLE pl-pers THEN DO:
          x-retval = pl-pers.patper + " " + pl-pers.matper + " " + pl-pers.nomper.
      END.
  END.
  RETURN x-retval.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fMesa B-table-Win 
FUNCTION fMesa RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-Mesa AS CHAR NO-UNDO.

  FOR EACH LogTrkDocs WHERE LogTrkDocs.CodCia = VtaCDocu.CodCia
      AND LogTrkDocs.CodDoc = VtaCDocu.CodPed
      AND LogTrkDocs.NroDoc = VtaCDocu.NroPed
      AND LogTrkDocs.Clave = "TRCKHPK" NO-LOCK,
      EACH TabTrkDocs WHERE TabTrkDocs.CodCia = LogTrkDocs.CodCia
      AND TabTrkDocs.Clave = LogTrkDocs.Clave
      AND TabTrkDocs.Codigo = LogTrkDocs.Codigo NO-LOCK,
      FIRST ChkTareas WHERE ChkTareas.CodCia = VtaCDocu.CodCia
      AND ChkTareas.CodDiv = VtaCDocu.CodDiv
      AND ChkTareas.CodDoc = VtaCDocu.CodPed
      AND ChkTareas.NroPed = VtaCDocu.NroPed NO-LOCK
      BY INTEGRAL.LogTrkDocs.Fecha:
      x-Mesa = ChkTareas.Mesa.
  END.

  RETURN x-Mesa.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNroPHR B-table-Win 
FUNCTION fNroPHR RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FOR EACH Di-RutaD NO-LOCK WHERE Di-RutaD.codcia = s-codcia
      AND Di-RutaD.coddoc = "PHR"
      AND Di-RutaD.codref = Faccpedi.coddoc
      AND Di-RutaD.nroref = Faccpedi.nroped
      AND Di-RutaD.coddiv = s-coddiv
      BREAK BY Di-RutaD.coddoc BY Di-RutaD.nrodoc:
      IF LAST-OF(Di-RutaD.coddoc) THEN RETURN (Di-RutaD.coddoc + " " + Di-RutaD.nrodoc).
  END.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPicador B-table-Win 
FUNCTION fPicador RETURNS CHARACTER
  ( INPUT pDNI AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pNombre AS CHAR NO-UNDO.
  DEF VAR pOrigen AS CHAR NO-UNDO.

  RUN logis/p-busca-por-dni.p (pDNI, OUTPUT pNombre, OUTPUT pOrigen).
  RETURN pNombre.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSituacion B-table-Win 
FUNCTION fSituacion RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pRetorno AS CHAR NO-UNDO.
  DEF VAR hProc AS HANDLE NO-UNDO.
  RUN logis/logis-library PERSISTENT SET hProc.
  RUN Estado-Logistico IN hProc (Vtacdocu.CodPed,
                                 Vtacdocu.FlgEst,
                                 Vtacdocu.FlgSit,
                                 "S",
                                 OUTPUT pRetorno).
  DELETE PROCEDURE hProc.
  RETURN pRetorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

