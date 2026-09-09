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
DEF SHARED VAR pv-codcia AS INT.

DEF SHARED VAR lh_handle AS HANDLE.

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
&Scoped-define INTERNAL-TABLES gn-vehic gn-prov

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table gn-vehic.placa gn-vehic.Marca ~
gn-vehic.CodPro gn-prov.NomPro gn-vehic.Carga gn-vehic.Libre_d01 ~
gn-vehic.Libre_c02 gn-vehic.Volumen gn-vehic.Libre_c05 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table gn-vehic.placa ~
gn-vehic.Marca gn-vehic.CodPro gn-vehic.Carga gn-vehic.Libre_d01 ~
gn-vehic.Libre_c02 gn-vehic.Libre_c05 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table gn-vehic
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table gn-vehic
&Scoped-define QUERY-STRING-br_table FOR EACH gn-vehic WHERE ~{&KEY-PHRASE} ~
      AND gn-vehic.CodCia = s-codcia NO-LOCK, ~
      FIRST gn-prov WHERE gn-prov.CodPro = gn-vehic.CodPro ~
      AND gn-prov.CodCia = pv-codcia OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH gn-vehic WHERE ~{&KEY-PHRASE} ~
      AND gn-vehic.CodCia = s-codcia NO-LOCK, ~
      FIRST gn-prov WHERE gn-prov.CodPro = gn-vehic.CodPro ~
      AND gn-prov.CodCia = pv-codcia OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table gn-vehic gn-prov
&Scoped-define FIRST-TABLE-IN-QUERY-br_table gn-vehic
&Scoped-define SECOND-TABLE-IN-QUERY-br_table gn-prov


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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      gn-vehic, 
      gn-prov SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      gn-vehic.placa FORMAT "x(10)":U
      gn-vehic.Marca FORMAT "x(20)":U
      gn-vehic.CodPro COLUMN-LABEL "Proveedor" FORMAT "x(8)":U
      gn-prov.NomPro FORMAT "x(50)":U WIDTH 42.29
      gn-vehic.Carga COLUMN-LABEL "Capacidad Maxima!kg" FORMAT ">>>,>>9.99":U
      gn-vehic.Libre_d01 COLUMN-LABEL "Capacidad Mínima!kg." FORMAT ">>>,>>9.99":U
      gn-vehic.Libre_c02 COLUMN-LABEL "Tonelaje" FORMAT "x(4)":U
            WIDTH 10.72 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEMS "2TN","5TN","10TN","15TN","20TN","30TN" 
                      DROP-DOWN-LIST 
      gn-vehic.Volumen COLUMN-LABEL "Volumen!en m3" FORMAT ">>>,>>9.99":U
      gn-vehic.Libre_c05 COLUMN-LABEL "Activo" FORMAT "x(3)":U
            VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEMS "SI","NO" 
                      DROP-DOWN-LIST 
  ENABLE
      gn-vehic.placa
      gn-vehic.Marca
      gn-vehic.CodPro
      gn-vehic.Carga
      gn-vehic.Libre_d01
      gn-vehic.Libre_c02
      gn-vehic.Libre_c05
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN NO-COLUMN-SCROLLING SEPARATORS SIZE 138.43 BY 23.42
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.15 COL 1.57
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
         HEIGHT             = 23.96
         WIDTH              = 144.
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
       gn-vehic.Libre_c02:AUTO-RESIZE IN BROWSE br_table = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.gn-vehic,INTEGRAL.gn-prov WHERE INTEGRAL.gn-vehic ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST OUTER"
     _Where[1]         = "gn-vehic.CodCia = s-codcia"
     _JoinCode[2]      = "gn-prov.CodPro = gn-vehic.CodPro"
     _Where[2]         = "gn-prov.CodCia = pv-codcia"
     _FldNameList[1]   > INTEGRAL.gn-vehic.placa
"gn-vehic.placa" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.gn-vehic.Marca
"gn-vehic.Marca" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.gn-vehic.CodPro
"gn-vehic.CodPro" "Proveedor" "x(8)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.gn-prov.NomPro
"gn-prov.NomPro" ? ? "character" ? ? ? ? ? ? no ? no no "42.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.gn-vehic.Carga
"gn-vehic.Carga" "Capacidad Maxima!kg" ">>>,>>9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.gn-vehic.Libre_d01
"gn-vehic.Libre_d01" "Capacidad Mínima!kg." ">>>,>>9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.gn-vehic.Libre_c02
"gn-vehic.Libre_c02" "Tonelaje" "x(4)" "character" ? ? ? ? ? ? yes ? no no "10.72" yes yes no "U" "" "" "DROP-DOWN-LIST" "," "2TN,5TN,10TN,15TN,20TN,30TN" ? 5 no 0 no no
     _FldNameList[8]   > INTEGRAL.gn-vehic.Volumen
"gn-vehic.Volumen" "Volumen!en m3" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.gn-vehic.Libre_c05
"gn-vehic.Libre_c05" "Activo" "x(3)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "DROP-DOWN-LIST" "," "SI,NO" ? 5 no 0 no no
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


&Scoped-define SELF-NAME gn-vehic.placa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-vehic.placa br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF gn-vehic.placa IN BROWSE br_table /* No de Placa */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-vehic.Marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-vehic.Marca br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF gn-vehic.Marca IN BROWSE br_table /* Marca */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-vehic.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-vehic.CodPro br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF gn-vehic.CodPro IN BROWSE br_table /* Proveedor */
DO:
  FIND gn-prov WHERE gn-prov.codcia = pv-codcia AND
      gn-prov.codpro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN DISPLAY gn-prov.NomPro WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF gn-vehic.Carga,
    gn-vehic.CodPro, 
    gn-vehic.Libre_c02, 
    gn-vehic.Libre_d01, 
    gn-vehic.Marca, 
    gn-vehic.placa
DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE busca-placa B-table-Win 
PROCEDURE busca-placa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pPlaca AS CHAR.

DEF BUFFER b-gn-vehic FOR gn-vehic.

FIND b-gn-vehic WHERE b-gn-vehic.CodCia = s-codcia AND
    b-gn-vehic.placa = pPlaca /*AND
    CAN-FIND(FIRST gn-prov WHERE gn-prov.CodPro = b-gn-vehic.CodPro AND
             gn-prov.CodCia = pv-codcia NO-LOCK)*/
    NO-LOCK NO-ERROR.
IF AVAILABLE b-gn-vehic THEN DO:
    REPOSITION {&BROWSE-NAME} TO ROWID ROWID(b-gn-vehic) NO-ERROR.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      gn-vehic.codcia = s-codcia
      NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
      RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
      UNDO, RETURN 'ADM-ERROR'.
  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields B-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('enable-campos').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields B-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN DO:
      gn-vehic.placa:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.
  END.
  ELSE DO:
      gn-vehic.placa:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO.
  END.
  RUN Procesa-Handle IN lh_handle ('disable-campos').

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
        WHEN "Marca" THEN 
            ASSIGN
                input-var-1 = "MV"      /* Marca Vehiculo */
                input-var-2 = ""
                input-var-3 = "".
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
  {src/adm/template/snd-list.i "gn-vehic"}
  {src/adm/template/snd-list.i "gn-prov"}

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

IF TRUE <> (gn-vehic.placa:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} > '') THEN DO:
    MESSAGE 'Ingrese el número de placa' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO gn-vehic.placa.
    RETURN 'ADM-ERROR'.
END.
IF NOT CAN-FIND(almtabla WHERE almtabla.Tabla = 'MV' AND
                almtabla.Codigo = gn-vehic.Marca:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                NO-LOCK) THEN DO:
    MESSAGE 'Marca no registrada' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO gn-vehic.marca.
    RETURN 'ADM-ERROR'.
END.
IF NOT CAN-FIND(gn-prov WHERE gn-prov.CodCia = pv-codcia AND
                gn-prov.CodPro = gn-vehic.CodPro:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                NO-LOCK) THEN DO:
    MESSAGE 'Proveedor no registrado' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO gn-vehic.codpro.
    RETURN 'ADM-ERROR'.
END.
IF TRUE <> (gn-vehic.Libre_c02:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} > '') THEN DO:
    MESSAGE 'Seleccione el tonelaje' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO gn-vehic.Libre_c02.
    RETURN 'ADM-ERROR'.
END.

DEFINE VAR x-carga-max AS DEC.
DEFINE VAR x-carga-min AS DEC.

x-carga-max = INTEGER(gn-vehic.carga:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
IF x-carga-max <= 0 THEN DO:
    MESSAGE 'Ingrese carga MAXIMA' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO gn-vehic.carga.
    RETURN 'ADM-ERROR'.
END.
/* x-carga-min = INTEGER(gn-vehic.libre_d01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}). */
/* IF x-carga-min <= 0 THEN DO:                                                     */
/*     MESSAGE 'Ingrese carga MINIMA' VIEW-AS ALERT-BOX ERROR.                      */
/*     APPLY 'ENTRY':U TO gn-vehic.libre_d01.                                       */
/*     RETURN 'ADM-ERROR'.                                                          */
/* END.                                                                             */
IF x-carga-min >= x-carga-max THEN DO:
    MESSAGE 'La carga MINIMA debe ser menor a la carga MAXIMA' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO gn-vehic.libre_d01.
    RETURN 'ADM-ERROR'.
END.

/* Validar si la placa ya existe */
DEFINE BUFFER y-gn-vehic FOR gn-vehic.
DEFINE VAR x-rowid AS ROWID.

RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF NOT (RETURN-VALUE = 'NO') THEN DO:
    x-rowid = ROWID(gn-vehic).
    FIND FIRST y-gn-vehic WHERE y-gn-vehic.codcia = s-codcia AND 
                                    y-gn-vehic.placa = gn-vehic.placa:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                                    NO-LOCK NO-ERROR.
    IF AVAILABLE y-gn-vehic THEN DO:
        IF ROWID(y-gn-vehic) <> x-rowid THEN DO:
            MESSAGE 'Numero de Placa ya esta registrado' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-vehic.placa.
            RETURN 'ADM-ERROR'.
        END.
    END.
END.
    

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

