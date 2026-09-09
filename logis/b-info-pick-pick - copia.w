&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-report-2 NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE t-VtaCDocu NO-UNDO LIKE VtaCDocu.
DEFINE TEMP-TABLE t-VtaCDocu-2 NO-UNDO LIKE VtaCDocu.
DEFINE BUFFER x-VtaCDocu FOR VtaCDocu.



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

DEF SHARED VAR s-codcia AS INTE.

DEF VAR s-coddiv AS CHAR INIT '00000' NO-UNDO.

DEF TEMP-TABLE detalle
    FIELD codref LIKE vtacdocu.codref
    FIELD nroref LIKE vtacdocu.nroref
    FIELD dni AS CHAR.

DEF SHARED VAR lh_handle AS HANDLE.

DEF VAR FILL-IN-Fecha AS DATE NO-UNDO.

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
&Scoped-define INTERNAL-TABLES t-report-2

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table t-report-2.Campo-C[1] ~
t-report-2.Campo-C[2] t-report-2.Campo-F[5] t-report-2.Campo-F[1] ~
t-report-2.Campo-F[2] t-report-2.Campo-F[3] t-report-2.Campo-F[4] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH t-report-2 WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH t-report-2 WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table t-report-2
&Scoped-define FIRST-TABLE-IN-QUERY-br_table t-report-2


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table FILL-IN-Dias BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Dias FILL-IN-Asignados ~
FILL-IN-Producidos FILL-IN-Peso FILL-IN-Volumen FILL-IN-Pedidos 

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


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-br_table 
       MENU-ITEM m_Realizado    LABEL "Realizado"     
       MENU-ITEM m_Pendientes   LABEL "Pendientes"    .


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-3 
     LABEL "PROCESAR" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-Asignados AS INTEGER FORMAT "-ZZZ,ZZZ,ZZ9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Dias AS INTEGER FORMAT ">>9":U INITIAL 3 
     LABEL "Días de muestreo" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Pedidos AS INTEGER FORMAT "-ZZZ,ZZZ,ZZ9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Peso AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Producidos AS INTEGER FORMAT "-ZZZ,ZZZ,ZZ9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Volumen AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      t-report-2 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      t-report-2.Campo-C[1] COLUMN-LABEL "DNI" FORMAT "X(12)":U
      t-report-2.Campo-C[2] COLUMN-LABEL "Nombre Completo" FORMAT "X(60)":U
      t-report-2.Campo-F[5] COLUMN-LABEL "Items!Pendientes" FORMAT "->>>,>>>,>>9":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 8
      t-report-2.Campo-F[1] COLUMN-LABEL "Items!Producidos" FORMAT "->>>,>>>,>>9":U
      t-report-2.Campo-F[2] COLUMN-LABEL "Peso" FORMAT "->>>,>>>,>>9.99":U
      t-report-2.Campo-F[3] COLUMN-LABEL "Volumen" FORMAT "->>>,>>>,>>9.99":U
      t-report-2.Campo-F[4] COLUMN-LABEL "Pedidos" FORMAT "->>>,>>>,>>9":U
            WIDTH 8.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 107 BY 8.35
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     FILL-IN-Dias AT ROW 2.35 COL 120 COLON-ALIGNED WIDGET-ID 22
     BUTTON-3 AT ROW 3.15 COL 112 WIDGET-ID 8
     FILL-IN-Asignados AT ROW 9.62 COL 51 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     FILL-IN-Producidos AT ROW 9.62 COL 62 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN-Peso AT ROW 9.62 COL 73 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     FILL-IN-Volumen AT ROW 9.62 COL 84 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     FILL-IN-Pedidos AT ROW 9.62 COL 95 COLON-ALIGNED NO-LABEL WIDGET-ID 20
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
      TABLE: t-report-2 T "?" NO-UNDO INTEGRAL w-report
      TABLE: t-VtaCDocu T "?" NO-UNDO INTEGRAL VtaCDocu
      TABLE: t-VtaCDocu-2 T "?" NO-UNDO INTEGRAL VtaCDocu
      TABLE: x-VtaCDocu B "?" ? INTEGRAL VtaCDocu
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
         HEIGHT             = 12.58
         WIDTH              = 141.
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

/* SETTINGS FOR FILL-IN FILL-IN-Asignados IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Pedidos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Peso IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Producidos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Volumen IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.t-report-2"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > Temp-Tables.t-report-2.Campo-C[1]
"t-report-2.Campo-C[1]" "DNI" "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.t-report-2.Campo-C[2]
"t-report-2.Campo-C[2]" "Nombre Completo" "X(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.t-report-2.Campo-F[5]
"t-report-2.Campo-F[5]" "Items!Pendientes" "->>>,>>>,>>9" "decimal" 8 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.t-report-2.Campo-F[1]
"t-report-2.Campo-F[1]" "Items!Producidos" "->>>,>>>,>>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.t-report-2.Campo-F[2]
"t-report-2.Campo-F[2]" "Peso" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.t-report-2.Campo-F[3]
"t-report-2.Campo-F[3]" "Volumen" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.t-report-2.Campo-F[4]
"t-report-2.Campo-F[4]" "Pedidos" "->>>,>>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "8.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 B-table-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* PROCESAR */
DO:
    ASSIGN FILL-IN-Dias.
    RUN Captura-Fecha IN lh_handle (OUTPUT FILL-IN-Fecha).
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Third-Process-New.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Pendientes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Pendientes B-table-Win
ON CHOOSE OF MENU-ITEM m_Pendientes /* Pendientes */
DO:
    IF NOT AVAILABLE t-report-2 THEN RETURN.

    RUN logis/d-info-pick-pick (INPUT TABLE t-Vtacdocu-2, INPUT t-report-2.Campo-C[1]).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Realizado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Realizado B-table-Win
ON CHOOSE OF MENU-ITEM m_Realizado /* Realizado */
DO:
  IF NOT AVAILABLE t-report-2 THEN RETURN.
  
  RUN logis/d-info-pick-pick (INPUT TABLE t-Vtacdocu, INPUT t-report-2.Campo-C[1]).

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
  {src/adm/template/snd-list.i "t-report-2"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Third-Process B-table-Win 
PROCEDURE Third-Process :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  EMPTY TEMP-TABLE t-report-2.
  EMPTY TEMP-TABLE detalle.

  /* Cargamos Picadores */
  EMPTY TEMP-TABLE t-Vtacdocu.
  EMPTY TEMP-TABLE t-Vtacdocu-2.

  DEF VAR x-UsrSac AS CHAR NO-UNDO.

  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P':

      IF ( VtaCDocu.Libre_c03 > '' 
           AND NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 3
           AND DATE(ENTRY(2,VtaCDocu.Libre_c03,'|')) = FILL-IN-Fecha ) 
          OR ( VtaCDocu.UsrSac > '' AND VtaCDocu.FecSac = FILL-IN-Fecha )
          THEN DO:
          IF NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 3 THEN x-UsrSac = ENTRY(3,VtaCDocu.Libre_c03,'|').
          ELSE x-UsrSac = VtaCDocu.UsrSac.
          FIND t-report-2 WHERE t-report-2.campo-c[1] = x-UsrSac
              EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE t-report-2 THEN DO:
              CREATE t-report-2.
              ASSIGN 
                  t-report-2.campo-c[1] = x-UsrSac.
          END.
          ASSIGN
              t-report-2.Campo-F[1] = t-report-2.Campo-F[1] + VtaCDocu.Items
              t-report-2.Campo-F[2] = t-report-2.Campo-F[2] + VtaCDocu.Peso
              t-report-2.Campo-F[3] = t-report-2.Campo-F[3] + VtaCDocu.Volumen
              .
          ASSIGN
              t-report-2.Campo-F[4] =  t-report-2.Campo-F[4] + 1.

          FIND FIRST detalle WHERE detalle.dni = t-report-2.campo-c[1]
              AND detalle.codref = vtacdocu.codref
              AND detalle.nroref = vtacdocu.nroref
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE detalle THEN DO:
              CREATE detalle.
              ASSIGN
                  detalle.dni = t-report-2.campo-c[1]
                  detalle.codref = vtacdocu.codref
                  detalle.nroref = vtacdocu.nroref.
          END.
          /* DETALLE PENDIENTES */
          CREATE t-Vtacdocu.
          BUFFER-COPY Vtacdocu TO t-Vtacdocu.
      END.
  END.
  /* Cargamos los NO considerados */
  FOR EACH rut-pers-turno NO-LOCK WHERE rut-pers-turno.codcia = s-codcia 
      AND rut-pers-turno.coddiv = s-coddiv 
      AND rut-pers-turno.fchasignada = FILL-IN-Fecha
      AND rut-pers-turno.rol = 'PICADOR':
      FIND t-report-2 WHERE t-report-2.campo-c[1] = rut-pers-turno.dni NO-LOCK NO-ERROR.
      IF NOT AVAILABLE t-report-2 THEN DO:
          CREATE t-report-2.
          ASSIGN t-report-2.campo-c[1] = rut-pers-turno.dni.
      END.
  END.
  /* DETALLE ASIGNADOS */
  DEF VAR x-FlgSit AS CHAR INIT 'TI,TP' NO-UNDO.
  DEF VAR k AS INT NO-UNDO.

  FOR EACH t-report-2:
      DO k = 1 TO NUM-ENTRIES(x-FlgSit):
          FOR EACH x-vtacdocu NO-LOCK WHERE x-vtacdocu.codcia = s-codcia AND
              x-vtacdocu.divdes = s-coddiv AND
              x-vtacdocu.usrsac = t-report-2.campo-c[1] AND
              DATE(x-vtacdocu.fchinicio) >= ADD-INTERVAL(TODAY, -3, 'days'):
              IF NOT ( x-vtacdocu.flgest = 'P' AND
                       x-vtacdocu.codped = 'HPK' AND         
                       x-Vtacdocu.FlgSit = ENTRY(k, x-FlgSit) )
                  THEN NEXT.
              ASSIGN
                  t-report-2.Campo-F[5] = t-report-2.Campo-F[5] + x-vtacdocu.items.
              CREATE t-Vtacdocu-2.
              BUFFER-COPY x-Vtacdocu TO t-Vtacdocu-2.
              /* Artificio */
              t-Vtacdocu-2.Libre_c03 = '||' + t-report-2.campo-c[1].
          END.
      END.
  END.
  /* Buscamos su nombre */
  DEF VAR pNombre AS CHAR NO-UNDO.
  DEF VAR pOrigen AS CHAR NO-UNDO.

  FOR EACH t-report-2:
      RUN logis/p-busca-por-dni ( INPUT t-report-2.campo-c[1],
                                  OUTPUT pNombre,
                                  OUTPUT pOrigen).
      IF pOrigen <> 'ERROR' THEN t-report-2.campo-c[2] = pNombre.
/*       FOR EACH detalle NO-LOCK WHERE detalle.dni = t-report-2.campo-c[1]: */
/*            t-report-2.Campo-F[4] =  t-report-2.Campo-F[4] + 1.            */
/*       END.                                                                */
  END.

  /* Totales */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          FILL-IN-Asignados = 0
          FILL-IN-Pedidos = 0
          FILL-IN-Peso = 0
          FILL-IN-Producidos = 0
          FILL-IN-Volumen = 0.
      FOR EACH t-report-2 NO-LOCK:
          ASSIGN
              FILL-IN-Asignados = FILL-IN-Asignados + Campo-F[5]
              FILL-IN-Producidos = FILL-IN-Producidos + Campo-F[1]
              FILL-IN-Peso = FILL-IN-Peso + Campo-F[2]
              FILL-IN-Volumen = FILL-IN-Volumen + Campo-F[3]
              FILL-IN-Pedidos = FILL-IN-Pedidos + Campo-F[4]
              .
      END.
      DISPLAY FILL-IN-Asignados FILL-IN-Pedidos FILL-IN-Peso FILL-IN-Producidos FILL-IN-Volumen.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Third-Process-New B-table-Win 
PROCEDURE Third-Process-New :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  EMPTY TEMP-TABLE t-report-2.
  EMPTY TEMP-TABLE detalle.

  /* Cargamos Picadores */
  EMPTY TEMP-TABLE t-Vtacdocu.
  EMPTY TEMP-TABLE t-Vtacdocu-2.

  DEF VAR x-UsrSac AS CHAR NO-UNDO.

  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P'
      AND DATE(VtaCDocu.fchinicio) >= ADD-INTERVAL(TODAY, (-1 * FILL-IN-Dias), 'days'):

      IF ( VtaCDocu.Libre_c03 > '' AND NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 3 )
          OR ( VtaCDocu.UsrSac > '' ) THEN DO:
          IF NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 3 THEN x-UsrSac = ENTRY(3,VtaCDocu.Libre_c03,'|').
          ELSE x-UsrSac = VtaCDocu.UsrSac.
          FIND t-report-2 WHERE t-report-2.campo-c[1] = x-UsrSac
              EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE t-report-2 THEN DO:
              CREATE t-report-2.
              ASSIGN 
                  t-report-2.campo-c[1] = x-UsrSac.
          END.
          IF ( VtaCDocu.Libre_c03 > ''  
               AND NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 3
               AND DATE(ENTRY(2,VtaCDocu.Libre_c03,'|')) = FILL-IN-Fecha ) 
              OR ( VtaCDocu.UsrSac > '' AND VtaCDocu.FecSac = FILL-IN-Fecha )
              THEN DO:
              ASSIGN
                  t-report-2.Campo-F[1] = t-report-2.Campo-F[1] + VtaCDocu.Items
                  t-report-2.Campo-F[2] = t-report-2.Campo-F[2] + VtaCDocu.Peso
                  t-report-2.Campo-F[3] = t-report-2.Campo-F[3] + VtaCDocu.Volumen
                  .
              ASSIGN
                  t-report-2.Campo-F[4] =  t-report-2.Campo-F[4] + 1.
          END.
          FIND FIRST detalle WHERE detalle.dni = t-report-2.campo-c[1]
              AND detalle.codref = vtacdocu.codref
              AND detalle.nroref = vtacdocu.nroref
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE detalle THEN DO:
              CREATE detalle.
              ASSIGN
                  detalle.dni = t-report-2.campo-c[1]
                  detalle.codref = vtacdocu.codref
                  detalle.nroref = vtacdocu.nroref.
          END.
          /* DETALLE PENDIENTES */
          CREATE t-Vtacdocu.
          BUFFER-COPY Vtacdocu TO t-Vtacdocu.
      END.
  END.
  /* Cargamos los NO considerados */
  FOR EACH rut-pers-turno NO-LOCK WHERE rut-pers-turno.codcia = s-codcia 
      AND rut-pers-turno.coddiv = s-coddiv 
      AND rut-pers-turno.fchasignada = FILL-IN-Fecha
      AND rut-pers-turno.rol = 'PICADOR':
      FIND t-report-2 WHERE t-report-2.campo-c[1] = rut-pers-turno.dni NO-LOCK NO-ERROR.
      IF NOT AVAILABLE t-report-2 THEN DO:
          CREATE t-report-2.
          ASSIGN t-report-2.campo-c[1] = rut-pers-turno.dni.
      END.
  END.
  
  /* DETALLE ASIGNADOS */
  DEF VAR x-FlgSit AS CHAR INIT 'TI,TP' NO-UNDO.
  DEF VAR k AS INT NO-UNDO.

  FOR EACH t-report-2:
      DO k = 1 TO NUM-ENTRIES(x-FlgSit):
          FOR EACH x-vtacdocu NO-LOCK WHERE x-vtacdocu.codcia = s-codcia AND
              x-vtacdocu.divdes = s-coddiv AND
              x-vtacdocu.codped = 'HPK' AND
              x-vtacdocu.flgest = 'P' AND
              x-vtacdocu.usrsac = t-report-2.campo-c[1] AND
              DATE(x-vtacdocu.fchinicio) >= ADD-INTERVAL(TODAY, (-1 * FILL-IN-Dias), 'days') AND
              x-Vtacdocu.FlgSit = ENTRY(k, x-FlgSit):
              ASSIGN
                  t-report-2.Campo-F[5] = t-report-2.Campo-F[5] + x-vtacdocu.items.
              CREATE t-Vtacdocu-2.
              BUFFER-COPY x-Vtacdocu TO t-Vtacdocu-2.
              /* Artificio */
              t-Vtacdocu-2.Libre_c03 = '||' + t-report-2.campo-c[1].
          END.
      END.
  END.



  /* Buscamos su nombre */
  DEF VAR pNombre AS CHAR NO-UNDO.
  DEF VAR pOrigen AS CHAR NO-UNDO.

  FOR EACH t-report-2:
      RUN logis/p-busca-por-dni ( INPUT t-report-2.campo-c[1],
                                  OUTPUT pNombre,
                                  OUTPUT pOrigen).
      IF pOrigen <> 'ERROR' THEN t-report-2.campo-c[2] = pNombre.
  END.

  /* Totales */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          FILL-IN-Asignados = 0
          FILL-IN-Pedidos = 0
          FILL-IN-Peso = 0
          FILL-IN-Producidos = 0
          FILL-IN-Volumen = 0.
      FOR EACH t-report-2 NO-LOCK:
          ASSIGN
              FILL-IN-Asignados = FILL-IN-Asignados + Campo-F[5]
              FILL-IN-Producidos = FILL-IN-Producidos + Campo-F[1]
              FILL-IN-Peso = FILL-IN-Peso + Campo-F[2]
              FILL-IN-Volumen = FILL-IN-Volumen + Campo-F[3]
              FILL-IN-Pedidos = FILL-IN-Pedidos + Campo-F[4]
              .
      END.
      DISPLAY FILL-IN-Asignados FILL-IN-Pedidos FILL-IN-Peso FILL-IN-Producidos FILL-IN-Volumen.
  END.

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

