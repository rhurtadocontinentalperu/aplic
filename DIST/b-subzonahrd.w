&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-DTabla FOR VtaDTabla.
DEFINE TEMP-TABLE T-DTabla LIKE VtaDTabla.



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

DEF VAR x-Descripcion AS CHAR NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES VtaDTabla
&Scoped-define FIRST-EXTERNAL-TABLE VtaDTabla


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR VtaDTabla.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-DTabla TabDepto TabProvi TabDistr

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-DTabla.Libre_c01 ~
TabDepto.NomDepto T-DTabla.Libre_c02 TabProvi.NomProvi T-DTabla.Libre_c03 ~
TabDistr.NomDistr 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table T-DTabla.Libre_c01 ~
T-DTabla.Libre_c02 T-DTabla.Libre_c03 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table T-DTabla
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table T-DTabla
&Scoped-define QUERY-STRING-br_table FOR EACH T-DTabla WHERE TRUE /* Join to VtaDTabla incomplete */ NO-LOCK, ~
      FIRST TabDepto WHERE TabDepto.CodDepto = T-DTabla.Libre_c01 OUTER-JOIN NO-LOCK, ~
      FIRST TabProvi WHERE TabProvi.CodDepto = T-DTabla.Libre_c01 ~
  AND TabProvi.CodProvi = T-DTabla.Libre_c02 OUTER-JOIN NO-LOCK, ~
      FIRST TabDistr WHERE TabDistr.CodDepto = T-DTabla.Libre_c01 ~
  AND TabDistr.CodProvi = T-DTabla.Libre_c02 ~
  AND TabDistr.CodDistr = T-DTabla.Libre_c03 OUTER-JOIN NO-LOCK ~
    BY T-DTabla.Libre_c01 ~
       BY T-DTabla.Libre_c02 ~
        BY T-DTabla.Libre_c03
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-DTabla WHERE TRUE /* Join to VtaDTabla incomplete */ NO-LOCK, ~
      FIRST TabDepto WHERE TabDepto.CodDepto = T-DTabla.Libre_c01 OUTER-JOIN NO-LOCK, ~
      FIRST TabProvi WHERE TabProvi.CodDepto = T-DTabla.Libre_c01 ~
  AND TabProvi.CodProvi = T-DTabla.Libre_c02 OUTER-JOIN NO-LOCK, ~
      FIRST TabDistr WHERE TabDistr.CodDepto = T-DTabla.Libre_c01 ~
  AND TabDistr.CodProvi = T-DTabla.Libre_c02 ~
  AND TabDistr.CodDistr = T-DTabla.Libre_c03 OUTER-JOIN NO-LOCK ~
    BY T-DTabla.Libre_c01 ~
       BY T-DTabla.Libre_c02 ~
        BY T-DTabla.Libre_c03.
&Scoped-define TABLES-IN-QUERY-br_table T-DTabla TabDepto TabProvi TabDistr
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-DTabla
&Scoped-define SECOND-TABLE-IN-QUERY-br_table TabDepto
&Scoped-define THIRD-TABLE-IN-QUERY-br_table TabProvi
&Scoped-define FOURTH-TABLE-IN-QUERY-br_table TabDistr


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
      T-DTabla, 
      TabDepto, 
      TabProvi, 
      TabDistr SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-DTabla.Libre_c01 COLUMN-LABEL "Departamento" FORMAT "x(8)":U
      TabDepto.NomDepto FORMAT "X(25)":U
      T-DTabla.Libre_c02 COLUMN-LABEL "Provincia" FORMAT "x(8)":U
      TabProvi.NomProvi FORMAT "X(25)":U
      T-DTabla.Libre_c03 COLUMN-LABEL "Distrito" FORMAT "x(8)":U
      TabDistr.NomDistr FORMAT "X(25)":U
  ENABLE
      T-DTabla.Libre_c01
      T-DTabla.Libre_c02
      T-DTabla.Libre_c03
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 100 BY 14.54
         FONT 4 FIT-LAST-COLUMN.


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
   External Tables: INTEGRAL.VtaDTabla
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-DTabla B "?" ? INTEGRAL VtaDTabla
      TABLE: T-DTabla T "?" ? INTEGRAL VtaDTabla
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
         HEIGHT             = 15.15
         WIDTH              = 102.86.
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

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.T-DTabla WHERE INTEGRAL.VtaDTabla ...,INTEGRAL.TabDepto WHERE Temp-Tables.T-DTabla ...,INTEGRAL.TabProvi WHERE Temp-Tables.T-DTabla ...,INTEGRAL.TabDistr WHERE Temp-Tables.T-DTabla ..."
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST OUTER, FIRST OUTER, FIRST OUTER"
     _OrdList          = "Temp-Tables.T-DTabla.Libre_c01|yes,Temp-Tables.T-DTabla.Libre_c02|yes,Temp-Tables.T-DTabla.Libre_c03|yes"
     _JoinCode[2]      = "INTEGRAL.TabDepto.CodDepto = Temp-Tables.T-DTabla.Libre_c01"
     _JoinCode[3]      = "INTEGRAL.TabProvi.CodDepto = Temp-Tables.T-DTabla.Libre_c01
  AND INTEGRAL.TabProvi.CodProvi = Temp-Tables.T-DTabla.Libre_c02"
     _JoinCode[4]      = "INTEGRAL.TabDistr.CodDepto = Temp-Tables.T-DTabla.Libre_c01
  AND INTEGRAL.TabDistr.CodProvi = Temp-Tables.T-DTabla.Libre_c02
  AND INTEGRAL.TabDistr.CodDistr = Temp-Tables.T-DTabla.Libre_c03"
     _FldNameList[1]   > Temp-Tables.T-DTabla.Libre_c01
"T-DTabla.Libre_c01" "Departamento" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.TabDepto.NomDepto
"TabDepto.NomDepto" ? "X(25)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-DTabla.Libre_c02
"T-DTabla.Libre_c02" "Provincia" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.TabProvi.NomProvi
"TabProvi.NomProvi" ? "X(25)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-DTabla.Libre_c03
"T-DTabla.Libre_c03" "Distrito" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.TabDistr.NomDistr
"TabDistr.NomDistr" ? "X(25)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
  {src/adm/template/row-list.i "VtaDTabla"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "VtaDTabla"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-DTabla.
FOR EACH B-DTabla WHERE B-DTabla.CodCia = VtaDTabla.CodCia
    AND B-DTabla.Tabla = VtaDTabla.Tabla
    AND B-DTabla.Llave = VtaDTabla.Llave
    AND B-DTabla.Tipo = VtaDTabla.Tipo
    AND B-DTabla.LlaveDetalle = "D" NO-LOCK:
    CREATE T-DTabla.
    BUFFER-COPY B-DTabla TO T-DTabla.
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
      T-DTabla.CodCia = VtaDTabla.CodCia 
      T-DTabla.Tabla  = VtaDTabla.Tabla 
      T-DTabla.Llave  = VtaDTabla.Llave
      T-DTabla.Tipo   = VtaDTabla.Tipo
      T-DTabla.LlaveDetalle = "D".
  /* Actualizamos base real */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      CREATE B-DTabla.
  END.
  ELSE DO:
      FIND B-DTabla WHERE B-DTabla.CodCia = T-DTabla.CodCia
          AND B-DTabla.Tabla = T-DTabla.Tabla
          AND B-DTabla.Llave = T-DTabla.Llave
          AND B-DTabla.Tipo = T-DTabla.Tipo
          AND B-DTabla.LlaveDetalle = T-DTabla.LlaveDetalle
          EXCLUSIVE-LOCK NO-ERROR.
      IF ERROR-STATUS:ERROR THEN DO:
          RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
          UNDO, RETURN 'ADM-ERROR'.
      END.
  END.
  BUFFER-COPY T-DTabla TO B-DTabla.
  RELEASE B-DTabla.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND B-DTABLA WHERE B-DTabla.CodCia = T-DTabla.CodCia
      AND B-DTabla.Tabla = T-DTabla.Tabla
      AND B-DTabla.Llave = T-DTabla.Llave
      AND B-DTabla.Tipo = T-DTabla.Tipo
      AND B-DTabla.LlaveDetalle = "D"
      AND B-DTabla.Libre_c01 = T-DTabla.Libre_c01 
      AND B-DTabla.Libre_c02 = T-DTabla.Libre_c02 
      AND B-DTabla.Libre_c03 = T-DTabla.Libre_c03
      EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE B-DTABLA THEN DO:
      RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
      RETURN 'ADM-ERROR'.
  END.
  DELETE B-DTABLA.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Carga-Temporal.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

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
        WHEN "Libre_c02" THEN
            ASSIGN
            input-var-1 = T-DTabla.Libre_c01:SCREEN-VALUE IN BROWSE {&browse-name}
            input-var-2 = ""
            input-var-3 = "".
        WHEN "Libre_c03" THEN
            ASSIGN
            input-var-1 = T-DTabla.Libre_c01:SCREEN-VALUE IN BROWSE {&browse-name}
            input-var-2 = T-DTabla.Libre_c02:SCREEN-VALUE IN BROWSE {&browse-name}
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
  {src/adm/template/snd-list.i "VtaDTabla"}
  {src/adm/template/snd-list.i "T-DTabla"}
  {src/adm/template/snd-list.i "TabDepto"}
  {src/adm/template/snd-list.i "TabProvi"}
  {src/adm/template/snd-list.i "TabDistr"}

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

/* Departamento y Provincia no se pueden repetir */
RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF RETURN-VALUE = 'YES' THEN DO:
    IF CAN-FIND(FIRST B-DTabla WHERE B-DTabla.CodCia =  VtaDTabla.CodCia 
                AND B-DTabla.Tabla = VtaDTabla.Tabla 
                AND B-DTabla.Llave = VtaDTabla.Llave
                AND B-DTabla.Tipo = VtaDTabla.Tipo
                AND B-DTabla.LlaveDetalle = "D"
                AND B-DTabla.Libre_c01 = T-DTabla.Libre_c01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                AND B-DTabla.Libre_c02 = T-DTabla.Libre_c02:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                AND B-DTabla.Libre_c03 = T-DTabla.Libre_c03:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                NO-LOCK)
        THEN DO:
        MESSAGE 'Registro duplicado' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
                
END.
IF NOT CAN-FIND(FIRST TabDepto WHERE TabDepto.CodDepto = T-DTabla.Libre_c01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                NO-LOCK)
    THEN DO:
    MESSAGE 'Departamento NO registrado' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO T-DTabla.Libre_c01.
    RETURN 'ADM-ERROR'.
END.
IF NOT CAN-FIND(FIRST TabProvi WHERE TabProvi.CodDepto = T-DTabla.Libre_c01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                AND TabProvi.CodProvi = T-DTabla.Libre_c02:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                NO-LOCK)
    THEN DO:
    MESSAGE 'Departamento NO registrada' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO T-DTabla.Libre_c02.
    RETURN 'ADM-ERROR'.
END.
IF NOT CAN-FIND(FIRST TabDistr WHERE TabDistr.CodDepto  = T-DTabla.Libre_c01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                AND TabDistr.CodProvi  = T-DTabla.Libre_c02:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                AND TabDistr.CodDistr  = T-DTabla.Libre_c03:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                NO-LOCK)
    THEN DO:
    MESSAGE 'Distrito NO registrado' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO T-DTabla.Libre_c03.
    RETURN 'ADM-ERROR'.
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

MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

