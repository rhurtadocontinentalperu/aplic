&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-Table FOR VtamDctoLogis.



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
DEFINE SHARED VAR s-codcia AS INTE.
DEFINE SHARED VAR s-TipDto AS CHAR INIT "DSCTO_DESPACHO".
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE VAR x-Log AS CHAR FORMAT 'x(50)' NO-UNDO.

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
&Scoped-define INTERNAL-TABLES VtamDctoLogis GN-DIVI

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table VtamDctoLogis.CodDiv GN-DIVI.DesDiv ~
VtamDctoLogis.FlgEst VtamDctoLogis.FchIni VtamDctoLogis.FchFin ~
fLog() @ x-Log 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table VtamDctoLogis.CodDiv ~
VtamDctoLogis.FlgEst VtamDctoLogis.FchIni VtamDctoLogis.FchFin 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table VtamDctoLogis
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table VtamDctoLogis
&Scoped-define QUERY-STRING-br_table FOR EACH VtamDctoLogis WHERE ~{&KEY-PHRASE} ~
      AND VtamDctoLogis.TipDto = s-TipDto ~
 AND (TOGGLE_Activos = NO OR VtamDctoLogis.FlgEst = 'Activo') NO-LOCK, ~
      EACH GN-DIVI WHERE GN-DIVI.CodDiv = VtamDctoLogis.CodDiv ~
      AND GN-DIVI.CodCia = s-codcia NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH VtamDctoLogis WHERE ~{&KEY-PHRASE} ~
      AND VtamDctoLogis.TipDto = s-TipDto ~
 AND (TOGGLE_Activos = NO OR VtamDctoLogis.FlgEst = 'Activo') NO-LOCK, ~
      EACH GN-DIVI WHERE GN-DIVI.CodDiv = VtamDctoLogis.CodDiv ~
      AND GN-DIVI.CodCia = s-codcia NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table VtamDctoLogis GN-DIVI
&Scoped-define FIRST-TABLE-IN-QUERY-br_table VtamDctoLogis
&Scoped-define SECOND-TABLE-IN-QUERY-br_table GN-DIVI


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS TOGGLE_Activos br_table 
&Scoped-Define DISPLAYED-OBJECTS TOGGLE_Activos 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fLog B-table-Win 
FUNCTION fLog RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE TOGGLE_Activos AS LOGICAL INITIAL no 
     LABEL "Mostrar solo activos" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      VtamDctoLogis, 
      GN-DIVI SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      VtamDctoLogis.CodDiv COLUMN-LABEL "División" FORMAT "x(8)":U
      GN-DIVI.DesDiv FORMAT "X(40)":U
      VtamDctoLogis.FlgEst COLUMN-LABEL "Estado" FORMAT "x(8)":U
            WIDTH 10.29 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEMS "Activo","Inactivo" 
                      DROP-DOWN-LIST 
      VtamDctoLogis.FchIni COLUMN-LABEL "Desde" FORMAT "99/99/9999":U
      VtamDctoLogis.FchFin COLUMN-LABEL "Hasta" FORMAT "99/99/9999":U
      fLog() @ x-Log COLUMN-LABEL "LOG" WIDTH 11.29
  ENABLE
      VtamDctoLogis.CodDiv
      VtamDctoLogis.FlgEst
      VtamDctoLogis.FchIni
      VtamDctoLogis.FchFin
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 96 BY 10.23
         FONT 4
         TITLE "VIGENCIA DE DESCUENTO POR DIVISION" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     TOGGLE_Activos AT ROW 1.27 COL 11 WIDGET-ID 2
     br_table AT ROW 2.08 COL 1
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
   Temp-Tables and Buffers:
      TABLE: B-Table B "?" ? INTEGRAL VtamDctoLogis
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
         HEIGHT             = 12.96
         WIDTH              = 121.86.
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
/* BROWSE-TAB br_table TOGGLE_Activos F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.VtamDctoLogis,INTEGRAL.GN-DIVI WHERE INTEGRAL.VtamDctoLogis ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "VtamDctoLogis.TipDto = s-TipDto
 AND (TOGGLE_Activos = NO OR VtamDctoLogis.FlgEst = 'Activo')"
     _JoinCode[2]      = "GN-DIVI.CodDiv = VtamDctoLogis.CodDiv"
     _Where[2]         = "GN-DIVI.CodCia = s-codcia"
     _FldNameList[1]   > INTEGRAL.VtamDctoLogis.CodDiv
"VtamDctoLogis.CodDiv" "División" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.GN-DIVI.DesDiv
     _FldNameList[3]   > INTEGRAL.VtamDctoLogis.FlgEst
"VtamDctoLogis.FlgEst" "Estado" ? "character" ? ? ? ? ? ? yes ? no no "10.29" yes no no "U" "" "" "DROP-DOWN-LIST" "," "Activo,Inactivo" ? 5 no 0 no no
     _FldNameList[4]   > INTEGRAL.VtamDctoLogis.FchIni
"VtamDctoLogis.FchIni" "Desde" ? "date" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.VtamDctoLogis.FchFin
"VtamDctoLogis.FchFin" "Hasta" ? "date" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fLog() @ x-Log" "LOG" ? ? ? ? ? ? ? ? no ? no no "11.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* VIGENCIA DE DESCUENTO POR DIVISION */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* VIGENCIA DE DESCUENTO POR DIVISION */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* VIGENCIA DE DESCUENTO POR DIVISION */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtamDctoLogis.CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtamDctoLogis.CodDiv br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF VtamDctoLogis.CodDiv IN BROWSE br_table /* División */
OR F8 OF VtamDctoLogis.CodDiv DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?.
    RUN lkup/c-divis.w('Divisiones').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE_Activos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE_Activos B-table-Win
ON VALUE-CHANGED OF TOGGLE_Activos IN FRAME F-Main /* Mostrar solo activos */
DO:
  ASSIGN {&self-name}.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
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
      VtamDctoLogis.Event = "CREATE"
      VtamDctoLogis.Hour = STRING(TIME, 'HH:MM:SS')
      VtamDctoLogis.Date = TODAY
      VtamDctoLogis.IdUser = s-user-id.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = "NO" THEN VtamDctoLogis.Event = "UPDATE".

  RUN lib/logtabla (INPUT 'VtamDctoLogis',
                    INPUT (STRING(VtamDctoLogis.IdMaster) + "|" +
                           VtamDctoLogis.TipDto + "|" +
                           VtamDctoLogis.CodDiv + "|" +
                           STRING(VtamDctoLogis.FchIni) + "|" +
                           STRING(VtamDctoLogis.FchFin)),
                    INPUT VtamDctoLogis.Event).
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record B-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      VtamDctoLogis.IdMaster = NEXT-VALUE(SEQ_MDCTOLOGISTIC)
      VtamDctoLogis.TipDto = s-TipDto.

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
  RUN lib/logtabla (INPUT 'VtamDctoLogis',
                    INPUT (STRING(VtamDctoLogis.IdMaster) + "|" +
                           VtamDctoLogis.TipDto + "|" +
                           VtamDctoLogis.CodDiv + "|" +
                           STRING(VtamDctoLogis.FchIni) + "|" +
                           STRING(VtamDctoLogis.FchFin)),
                    INPUT "DELETE").

  FOR EACH VtadDctoLogis EXCLUSIVE-LOCK WHERE VtadDctoLogis.IdMaster = VtamDctoLogis.IdMaster:
      RUN lib/logtabla (INPUT 'VtadDctoLogis',
                        INPUT (STRING(VtamDctoLogis.IdMaster) + "|" +
                               VtamDctoLogis.TipDto + "|" +
                               VtamDctoLogis.CodDiv + "|" +
                               VtadDctoLogis.CodFam + "|" +
                               STRING(VtadDctoLogis.PorDto)),
                        INPUT 'DELETE').
      DELETE VtadDctoLogis.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  DO WITH FRAME {&FRAME-NAME}:
      TOGGLE_Activos:SENSITIVE = YES.
  END.

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
  DO WITH FRAME {&FRAME-NAME}:
      TOGGLE_Activos:SENSITIVE = NO.
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'YES' THEN VtamDctoLogis.CodDiv:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO.
      ELSE VtamDctoLogis.CodDiv:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.
  END.

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
  {src/adm/template/snd-list.i "VtamDctoLogis"}
  {src/adm/template/snd-list.i "GN-DIVI"}

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


/* La división debe estar activa */
IF NOT CAN-FIND(FIRST GN-DIVI WHERE GN-DIVI.CodCia = s-codcia AND
                GN-DIVI.CodDiv = VtamDctoLogis.CodDiv:SCREEN-VALUE IN BROWSE {&browse-name} AND
                GN-DIVI.Campo-Log[1] = NO NO-LOCK)
    THEN DO:
    MESSAGE 'División errada' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO VtamDctoLogis.CodDiv.
    RETURN 'ADM-ERROR'.
END.
IF DATE(VtamDctoLogis.FchIni:SCREEN-VALUE IN BROWSE {&browse-name}) = ? THEN DO:
    MESSAGE 'Debe ingresar las fechas de vigencia' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO VtamDctoLogis.FchIni.
    RETURN 'ADM-ERROR'.
END.
IF DATE(VtamDctoLogis.FchFin:SCREEN-VALUE IN BROWSE {&browse-name}) = ? THEN DO:
    MESSAGE 'Debe ingresar las fechas de vigencia' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO VtamDctoLogis.FchFin.
    RETURN 'ADM-ERROR'.
END.
IF TRUE <> (VtamDctoLogis.FlgEst:SCREEN-VALUE IN BROWSE {&browse-name} > '') 
    THEN DO:
    MESSAGE 'Debe seleccionar un estado ACTIVO o INACTIVO' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO VtamDctoLogis.FlgEst.
    RETURN 'ADM-ERROR'.
END.

/* NO se puede Activar si exite otra ya activa y que se cruzan las fechas */
&SCOPED-DEFINE Validacion ~
   ( DATE(VtamDctoLogis.FchIni:SCREEN-VALUE IN BROWSE {&browse-name}) >= B-Table.FchIni AND ~
     DATE(VtamDctoLogis.FchIni:SCREEN-VALUE IN BROWSE {&browse-name}) <= B-Table.FchFin ) OR ~
   ( DATE(VtamDctoLogis.FchFin:SCREEN-VALUE IN BROWSE {&browse-name}) >= B-Table.FchIni AND ~
     DATE(VtamDctoLogis.FchFin:SCREEN-VALUE IN BROWSE {&browse-name}) <= B-Table.FchFin ) OR ~
   ( DATE(VtamDctoLogis.FchIni:SCREEN-VALUE IN BROWSE {&browse-name}) <= B-Table.FchIni AND ~
     DATE(VtamDctoLogis.FchFin:SCREEN-VALUE IN BROWSE {&browse-name}) >=  B-Table.FchFin ) 

IF VtamDctoLogis.FlgEst:SCREEN-VALUE IN BROWSE {&browse-name} = "Activo" THEN DO:
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = "YES" THEN DO:
        FOR EACH B-Table NO-LOCK WHERE B-Table.CodDiv = VtamDctoLogis.CodDiv:SCREEN-VALUE IN BROWSE {&browse-name}
            AND B-Table.FlgEst = "Activo":
            IF {&Validacion} THEN DO:
                MESSAGE 'NO se puede activar este descuento porque se está cruzando con' SKIP
                    'el descuento activo cuya vigencia es:' SKIP
                    'Desde el ' B-Table.FchIni SKIP
                    'Hasta el ' B-Table.FchFin
                    VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO VtamDctoLogis.FlgEst.
                RETURN 'ADM-ERROR'.
            END.
        END.
    END.
    ELSE DO:
        /* NO se debe tomar el registro que se está modificando */
        FOR EACH B-Table NO-LOCK WHERE B-Table.CodDiv = VtamDctoLogis.CodDiv:SCREEN-VALUE IN BROWSE {&browse-name}
            AND B-Table.FlgEst = "Activo"
            AND ROWID(B-Table) <> ROWID(VtamDctoLogis):
            IF {&Validacion} THEN DO:
                MESSAGE 'NO se puede activar este descuento porque se está cruzando con' SKIP
                    'el descuento activo cuya vigencia es:' SKIP
                    'Desde el ' B-Table.FchIni SKIP
                    'Hasta el ' B-Table.FchFin
                    VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO VtamDctoLogis.FlgEst.
                RETURN 'ADM-ERROR'.
            END.
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fLog B-table-Win 
FUNCTION fLog RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF AVAILABLE VtamDctoLogis THEN 
      RETURN (VtamDctoLogis.IdUser + " " + 
              STRING(VtamDctoLogis.Date) + " " + 
              VtamDctoLogis.Hour).

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

