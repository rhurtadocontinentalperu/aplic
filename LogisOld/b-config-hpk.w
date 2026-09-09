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

DEF VAR s-Tabla AS CHAR INIT 'CFGHPK' NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES GN-DIVI
&Scoped-define FIRST-EXTERNAL-TABLE GN-DIVI


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR GN-DIVI.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES VtaDTabla Almtfami AlmSFami Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table VtaDTabla.Libre_d01 VtaDTabla.Tipo ~
VtaDTabla.Libre_c01 Almtfami.desfam VtaDTabla.Libre_c02 AlmSFami.dessub ~
VtaDTabla.Libre_c03 Almmmatg.DesMat VtaDTabla.Libre_l01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table VtaDTabla.Libre_d01 ~
VtaDTabla.Tipo VtaDTabla.Libre_c01 VtaDTabla.Libre_c02 VtaDTabla.Libre_c03 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table VtaDTabla
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table VtaDTabla
&Scoped-define QUERY-STRING-br_table FOR EACH VtaDTabla WHERE VtaDTabla.CodCia = s-codcia ~
  AND VtaDTabla.Tabla = s-tabla ~
  AND VtaDTabla.Llave = GN-DIVI.CodDiv NO-LOCK, ~
      FIRST Almtfami WHERE Almtfami.CodCia = VtaDTabla.CodCia ~
  AND Almtfami.codfam = VtaDTabla.Libre_c01 OUTER-JOIN NO-LOCK, ~
      FIRST AlmSFami WHERE AlmSFami.CodCia = VtaDTabla.CodCia ~
  AND AlmSFami.codfam = VtaDTabla.Libre_c01 ~
  AND AlmSFami.subfam = VtaDTabla.Libre_c02 OUTER-JOIN NO-LOCK, ~
      FIRST Almmmatg WHERE Almmmatg.CodCia = VtaDTabla.CodCia ~
  AND Almmmatg.codmat = VtaDTabla.Libre_c03 OUTER-JOIN NO-LOCK ~
    BY VtaDTabla.Libre_d01
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH VtaDTabla WHERE VtaDTabla.CodCia = s-codcia ~
  AND VtaDTabla.Tabla = s-tabla ~
  AND VtaDTabla.Llave = GN-DIVI.CodDiv NO-LOCK, ~
      FIRST Almtfami WHERE Almtfami.CodCia = VtaDTabla.CodCia ~
  AND Almtfami.codfam = VtaDTabla.Libre_c01 OUTER-JOIN NO-LOCK, ~
      FIRST AlmSFami WHERE AlmSFami.CodCia = VtaDTabla.CodCia ~
  AND AlmSFami.codfam = VtaDTabla.Libre_c01 ~
  AND AlmSFami.subfam = VtaDTabla.Libre_c02 OUTER-JOIN NO-LOCK, ~
      FIRST Almmmatg WHERE Almmmatg.CodCia = VtaDTabla.CodCia ~
  AND Almmmatg.codmat = VtaDTabla.Libre_c03 OUTER-JOIN NO-LOCK ~
    BY VtaDTabla.Libre_d01.
&Scoped-define TABLES-IN-QUERY-br_table VtaDTabla Almtfami AlmSFami ~
Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table VtaDTabla
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almtfami
&Scoped-define THIRD-TABLE-IN-QUERY-br_table AlmSFami
&Scoped-define FOURTH-TABLE-IN-QUERY-br_table Almmmatg


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
      VtaDTabla, 
      Almtfami
    FIELDS(Almtfami.desfam), 
      AlmSFami
    FIELDS(AlmSFami.dessub), 
      Almmmatg
    FIELDS(Almmmatg.DesMat) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      VtaDTabla.Libre_d01 COLUMN-LABEL "Orden" FORMAT ">>9":U
      VtaDTabla.Tipo FORMAT "x(15)":U WIDTH 14.57 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEMS "ACUMULATIVO","RACK" 
                      DROP-DOWN-LIST 
      VtaDTabla.Libre_c01 COLUMN-LABEL "Linea" FORMAT "x(8)":U
      Almtfami.desfam FORMAT "X(30)":U
      VtaDTabla.Libre_c02 COLUMN-LABEL "Sub-Línea" FORMAT "x(8)":U
      AlmSFami.dessub FORMAT "X(30)":U
      VtaDTabla.Libre_c03 COLUMN-LABEL "Artículo" FORMAT "x(13)":U
      Almmmatg.DesMat FORMAT "X(45)":U
      VtaDTabla.Libre_l01 COLUMN-LABEL "Empaq. Master?" FORMAT "yes/no":U
            VIEW-AS TOGGLE-BOX
  ENABLE
      VtaDTabla.Libre_d01
      VtaDTabla.Tipo
      VtaDTabla.Libre_c01
      VtaDTabla.Libre_c02
      VtaDTabla.Libre_c03
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 138 BY 15.35
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
   External Tables: INTEGRAL.GN-DIVI
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
         HEIGHT             = 15.69
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

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.VtaDTabla WHERE INTEGRAL.GN-DIVI <external> ...,INTEGRAL.Almtfami WHERE INTEGRAL.VtaDTabla ...,INTEGRAL.AlmSFami WHERE INTEGRAL.VtaDTabla ...,INTEGRAL.Almmmatg WHERE INTEGRAL.VtaDTabla ..."
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST OUTER USED, FIRST OUTER USED, FIRST OUTER USED"
     _OrdList          = "INTEGRAL.VtaDTabla.Libre_d01|yes"
     _JoinCode[1]      = "VtaDTabla.CodCia = s-codcia
  AND VtaDTabla.Tabla = s-tabla
  AND VtaDTabla.Llave = GN-DIVI.CodDiv"
     _JoinCode[2]      = "Almtfami.CodCia = VtaDTabla.CodCia
  AND Almtfami.codfam = VtaDTabla.Libre_c01"
     _JoinCode[3]      = "AlmSFami.CodCia = VtaDTabla.CodCia
  AND AlmSFami.codfam = VtaDTabla.Libre_c01
  AND AlmSFami.subfam = VtaDTabla.Libre_c02"
     _JoinCode[4]      = "Almmmatg.CodCia = VtaDTabla.CodCia
  AND Almmmatg.codmat = VtaDTabla.Libre_c03"
     _FldNameList[1]   > INTEGRAL.VtaDTabla.Libre_d01
"VtaDTabla.Libre_d01" "Orden" ">>9" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.VtaDTabla.Tipo
"VtaDTabla.Tipo" ? "x(15)" "character" ? ? ? ? ? ? yes ? no no "14.57" yes no no "U" "" "" "DROP-DOWN-LIST" "," "ACUMULATIVO,RACK" ? 5 no 0 no no
     _FldNameList[3]   > INTEGRAL.VtaDTabla.Libre_c01
"VtaDTabla.Libre_c01" "Linea" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "FILL-IN" "," ? ? 0 no 0 no no
     _FldNameList[4]   = INTEGRAL.Almtfami.desfam
     _FldNameList[5]   > INTEGRAL.VtaDTabla.Libre_c02
"VtaDTabla.Libre_c02" "Sub-Línea" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = INTEGRAL.AlmSFami.dessub
     _FldNameList[7]   > INTEGRAL.VtaDTabla.Libre_c03
"VtaDTabla.Libre_c03" "Artículo" "x(13)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = INTEGRAL.Almmmatg.DesMat
     _FldNameList[9]   > INTEGRAL.VtaDTabla.Libre_l01
"VtaDTabla.Libre_l01" "Empaq. Master?" ? "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
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


&Scoped-define SELF-NAME VtaDTabla.Libre_c03
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDTabla.Libre_c03 br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF VtaDTabla.Libre_c03 IN BROWSE br_table /* Artículo */
DO:
    IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
    DEF VAR pCodMat AS CHAR NO-UNDO.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, YES).
    SELF:SCREEN-VALUE = pCodMat.
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
  {src/adm/template/row-list.i "GN-DIVI"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "GN-DIVI"}

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
      VtaDTabla.CodCia = s-codcia
      VtaDTabla.Tabla = s-tabla
      VtaDTabla.Llave = gn-divi.coddiv.
  IF VtaDTabla.Tipo = 'RACK' THEN DO:
      VtaDTabla.Libre_c01 = ''.
      VtaDTabla.Libre_c02 = ''.
      VtaDTabla.Libre_c03 = ''.
  END.
  ASSIGN
      VtaDTabla.Libre_l01 = YES.    /* Siempre x MASTER */

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
      VtaDTabla.Libre_c01:READ-ONLY IN BROWSE {&browse-name} = YES.
      VtaDTabla.Tipo:READ-ONLY IN BROWSE {&browse-name} = YES.
      IF VtaDTabla.Tipo = 'RACK' THEN VtaDTabla.Libre_c02:READ-ONLY IN BROWSE {&browse-name} = YES.
  END.
  ELSE DO:
      VtaDTabla.Libre_c01:READ-ONLY IN BROWSE {&browse-name} = NO.
      VtaDTabla.Libre_c02:READ-ONLY IN BROWSE {&browse-name} = NO.

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
        WHEN "Libre_c02" THEN DO:
            ASSIGN
                input-var-1 = VtaDTabla.Libre_c01:SCREEN-VALUE IN BROWSE {&browse-name}
                input-var-2 = ''
                input-var-3 = ''.
        END.
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
  {src/adm/template/snd-list.i "GN-DIVI"}
  {src/adm/template/snd-list.i "VtaDTabla"}
  {src/adm/template/snd-list.i "Almtfami"}
  {src/adm/template/snd-list.i "AlmSFami"}
  {src/adm/template/snd-list.i "Almmmatg"}

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

IF TRUE <> (VtaDTabla.Tipo:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} > '') THEN DO:
    MESSAGE 'Seleccione el TIPO' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO VtaDTabla.Tipo.
    RETURN 'ADM-ERROR'.
END.
CASE VtaDTabla.Tipo:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}:
    WHEN "ACUMULATIVO" THEN DO:       /* Acumulativos */
        IF TRUE <> (VtaDTabla.Libre_c01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} > '')
            THEN DO:
            MESSAGE 'Ingrese el código de la línea' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO VtaDTabla.Libre_c01.
            RETURN 'ADM-ERROR'.
        END.
        IF NOT CAN-FIND(FIRST Almtfami WHERE Almtfami.CodCia = s-CodCia AND
                        Almtfami.codfam = VtaDTabla.Libre_c01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                        NO-LOCK)
            THEN DO:
            MESSAGE 'Ingrese el código de la línea' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO VtaDTabla.Libre_c01.
            RETURN 'ADM-ERROR'.
        END.
        IF VtaDTabla.Libre_c02:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} > '' THEN DO:
            IF NOT CAN-FIND(FIRST Almsfami WHERE Almsfami.CodCia = s-CodCia AND
                            Almsfami.codfam = VtaDTabla.Libre_c01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} AND
                            Almsfami.subfam = VtaDTabla.Libre_c02:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                            NO-LOCK)
                THEN DO:
                MESSAGE 'Código de la sub-línea errado' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO VtaDTabla.Libre_c02.
                RETURN 'ADM-ERROR'.
            END.
        END.
    END.
END CASE.
IF VtaDTabla.Libre_c03:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} > '' THEN DO:
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND
        Almmmatg.codmat = VtaDTabla.Libre_c03:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        MESSAGE 'Código de artículo NO registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO VtaDTabla.Libre_c03.
        RETURN 'ADM-ERROR'.
    END.
    IF Almmmatg.CodFam <> VtaDTabla.Libre_c01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} OR
        Almmmatg.SubFam <> VtaDTabla.Libre_c02:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        THEN DO:
        MESSAGE 'La línea y sublínea NO conciden con la del artículo'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO VtaDTabla.Libre_c03.
        RETURN 'ADM-ERROR'.
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

