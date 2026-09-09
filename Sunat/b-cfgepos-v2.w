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

&SCOPED-DEFINE Condicion FEcfgepos.CodCia = s-codcia

DEF TEMP-TABLE T-TERM LIKE Ccbcterm
    FIELD cRowid AS ROWID.
DEF TEMP-TABLE T-CORRE LIKE Faccorre
    FIELD cRowid AS ROWID.

define var x-sort-direccion as char init "".
define var x-sort-column as char init "".
define var x-sort-command as char init "".

DEFINE SHARED VAR hSocket AS HANDLE NO-UNDO.

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
&Scoped-define INTERNAL-TABLES FEcfgepos GN-DIVI

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FEcfgepos.CodDiv GN-DIVI.DesDiv ~
FEcfgepos.ID_Pos FEcfgepos.Tipo FEcfgepos.IP_ePos FEcfgepos.Port_ePos 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table FEcfgepos.CodDiv ~
FEcfgepos.ID_Pos FEcfgepos.Tipo FEcfgepos.IP_ePos FEcfgepos.Port_ePos 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table FEcfgepos
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table FEcfgepos
&Scoped-define QUERY-STRING-br_table FOR EACH FEcfgepos WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      EACH GN-DIVI OF FEcfgepos NO-LOCK ~
    BY FEcfgepos.CodDiv ~
       BY FEcfgepos.Tipo
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FEcfgepos WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      EACH GN-DIVI OF FEcfgepos NO-LOCK ~
    BY FEcfgepos.CodDiv ~
       BY FEcfgepos.Tipo.
&Scoped-define TABLES-IN-QUERY-br_table FEcfgepos GN-DIVI
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FEcfgepos
&Scoped-define SECOND-TABLE-IN-QUERY-br_table GN-DIVI


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table COMBO-BOX-cajas BUTTON-17 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-cajas 

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
DEFINE BUTTON BUTTON-17 
     LABEL "Probar ePOS" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX-cajas AS CHARACTER FORMAT "X(25)":U 
     LABEL "Cajas" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "<Ninguno>" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      FEcfgepos, 
      GN-DIVI SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FEcfgepos.CodDiv FORMAT "x(5)":U
      GN-DIVI.DesDiv FORMAT "X(40)":U
      FEcfgepos.ID_Pos FORMAT "x(15)":U
      FEcfgepos.Tipo COLUMN-LABEL "Orden" FORMAT "x(10)":U WIDTH 12.86
            VIEW-AS COMBO-BOX INNER-LINES 11
                      LIST-ITEMS "00","01","02","03","04","05","06","07","08","09","10" 
                      DROP-DOWN-LIST 
      FEcfgepos.IP_ePos FORMAT "x(25)":U WIDTH 13
      FEcfgepos.Port_ePos FORMAT "x(15)":U WIDTH 8.43
  ENABLE
      FEcfgepos.CodDiv
      FEcfgepos.ID_Pos
      FEcfgepos.Tipo
      FEcfgepos.IP_ePos
      FEcfgepos.Port_ePos
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 104.57 BY 8.65
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.08 COL 1.43
     COMBO-BOX-cajas AT ROW 3.96 COL 112 COLON-ALIGNED WIDGET-ID 4
     BUTTON-17 AT ROW 2.73 COL 108.29 WIDGET-ID 2
     "Text 2" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 5.42 COL 109 WIDGET-ID 8
     "Cajas = <Ninguno>, trabaja" VIEW-AS TEXT
          SIZE 24 BY .62 AT ROW 5.42 COL 108.86 WIDGET-ID 12
          FGCOLOR 4 
     "el numero Orden mayores a 05" VIEW-AS TEXT
          SIZE 26.86 BY .62 AT ROW 6.08 COL 108.14 WIDGET-ID 14
          FGCOLOR 4 
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
         HEIGHT             = 15.62
         WIDTH              = 137.29.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.FEcfgepos,INTEGRAL.GN-DIVI OF INTEGRAL.FEcfgepos"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ","
     _OrdList          = "INTEGRAL.FEcfgepos.CodDiv|yes,INTEGRAL.FEcfgepos.Tipo|yes"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > INTEGRAL.FEcfgepos.CodDiv
"FEcfgepos.CodDiv" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.GN-DIVI.DesDiv
     _FldNameList[3]   > INTEGRAL.FEcfgepos.ID_Pos
"FEcfgepos.ID_Pos" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FEcfgepos.Tipo
"FEcfgepos.Tipo" "Orden" ? "character" ? ? ? ? ? ? yes ? no no "12.86" yes no no "U" "" "" "DROP-DOWN-LIST" "," "00,01,02,03,04,05,06,07,08,09,10" ? 11 no 0 no no
     _FldNameList[5]   > INTEGRAL.FEcfgepos.IP_ePos
"FEcfgepos.IP_ePos" ? ? "character" ? ? ? ? ? ? yes ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FEcfgepos.Port_ePos
"FEcfgepos.Port_ePos" ? ? "character" ? ? ? ? ? ? yes ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ENTRY OF br_table IN FRAME F-Main
DO:
    IF AVAILABLE FEcfgepos THEN DO:
        RUN carga-cajas(FEcfgepos.coddiv).  
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
ON START-SEARCH OF br_table IN FRAME F-Main
DO:
    DEFINE VARIABLE hSortColumn AS WIDGET-HANDLE.
    DEFINE VAR lColumName AS CHAR.
    DEFINE VAR hQueryHandle AS HANDLE NO-UNDO.

    hSortColumn = BROWSE br_table:CURRENT-COLUMN.
    lColumName = hSortColumn:NAME.
    lColumName = TRIM(REPLACE(lColumName," no","")).

    /* Caso COLUMNAS temporales */
    IF lColumName = 'x-subzona' THEN lColumName = 'csubzona'.
    IF lColumName = 'x-zona' THEN lColumName = 'czona'.

    IF CAPS(lColumName) <> CAPS(x-sort-column) THEN DO:
        x-sort-direccion = "".
    END.
    ELSE DO:
        IF x-sort-direccion = "" THEN DO:
            x-sort-direccion = "DESC".
        END.
        ELSE DO:            
            x-sort-direccion = "".
        END.
    END.
    x-sort-column = lColumName.
    x-sort-command = "BY " + lColumName + " " + x-sort-direccion.

    hQueryHandle = BROWSE br_table:QUERY.
    hQueryHandle:QUERY-CLOSE().
    /* *--- Este valor debe ser el QUERY que esta definido en el BROWSE. */
    /*hQueryHandle:QUERY-PREPARE("FOR EACH Detalle NO-LOCK, EACH INTEGRAL.PL-PERS OF Detalle NO-LOCK " + x-sort-command).*/
    hQueryHandle:QUERY-PREPARE("FOR EACH FEcfgepos WHERE FEcfgepos.CodCia = 1 NO-LOCK, EACH GN-DIVI OF FEcfgepos NO-LOCK " + x-sort-command).
    hQueryHandle:QUERY-OPEN().  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}

  IF AVAILABLE FEcfgepos THEN DO:
      RUN carga-cajas(FEcfgepos.coddiv).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-17
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-17 B-table-Win
ON CHOOSE OF BUTTON-17 IN FRAME F-Main /* Probar ePOS */
DO:
  ASSIGN COMBO-BOX-cajas.

  RUN probar-espos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF FEcfgepos.CodDiv, 
    FEcfgepos.ID_Pos, 
    FEcfgepos.IP_ePos, 
    FEcfgepos.Port_ePos, 
    FEcfgepos.Tipo
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-cajas B-table-Win 
PROCEDURE carga-cajas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDiv AS CHAR.

DO WITH FRAME {&FRAME-NAME}:

    DEF VAR k AS INT.
    REPEAT WHILE COMBO-BOX-cajas:NUM-ITEMS > 0:
      COMBO-BOX-cajas:DELETE(1).
    END.

    COMBO-BOX-cajas:ADD-LAST('<Ninguno>').
    FOR EACH CcbCterm WHERE CcbCterm.codcia = s-codcia AND
                                CcbCterm.coddiv = pCodDiv NO-LOCK:
        COMBO-BOX-cajas:ADD-LAST(CcbCterm.codter).
    END.
    COMBO-BOX-cajas:SCREEN-VALUE = '<Ninguno>'.

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
  EMPTY TEMP-TABLE T-TERM.
  EMPTY TEMP-TABLE T-CORRE.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = "NO" THEN DO:
      FOR EACH CcbCTerm WHERE CcbCTerm.CodCia = FEcfgepos.CodCia
              AND CcbCTerm.CodDiv = FEcfgepos.CodDiv 
              AND CcbCTerm.ID_Pos = FEcfgepos.ID_Pos:
          CREATE T-TERM.
          BUFFER-COPY CcbCterm TO T-TERM ASSIGN T-TERM.cRowid = ROWID(CcbCTerm).
          ASSIGN CcbCTerm.ID_Pos = "".
      END.
      FOR EACH FacCorre WHERE FacCorre.CodCia = FEcfgepos.CodCia
                  AND FacCorre.CodDiv = FEcfgepos.CodDiv
                  AND FacCorre.ID_Pos = FEcfgepos.ID_Pos:
          CREATE T-CORRE.
          BUFFER-COPY FacCorre TO T-CORRE ASSIGN T-CORRE.cRowid = ROWID(FacCorre).
          ASSIGN FacCorre.ID_Pos = "".
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
       FEcfgepos.CodCia = s-codcia.
  FOR EACH T-TERM, FIRST CcbCTerm WHERE ROWID(CcbCTerm) = T-TERM.cRowid:
      ASSIGN CcbCTerm.Id_Pos =  FEcfgepos.ID_Pos.
  END.
  FOR EACH T-CORRE, FIRST FacCorre WHERE ROWID(FacCorre) = T-CORRE.cRowid:
      ASSIGN FacCorre.Id_Pos =  FEcfgepos.ID_Pos.
  END.
  IF AVAILABLE CcbCTerm THEN RELEASE CcbCTerm.
  IF AVAILABLE FacCorre THEN RELEASE FacCorre.

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
  IF CAN-FIND(FIRST CcbCTerm WHERE CcbCTerm.CodCia = FEcfgepos.CodCia
              AND CcbCTerm.CodDiv = FEcfgepos.CodDiv 
              AND CcbCTerm.ID_Pos = FEcfgepos.ID_Pos
              NO-LOCK)
      OR CAN-FIND(FIRST FacCorre WHERE FacCorre.CodCia = FEcfgepos.CodCia
                  AND FacCorre.CodDiv = FEcfgepos.CodDiv
                  AND FacCorre.ID_Pos = FEcfgepos.ID_Pos
                  NO-LOCK)
      THEN DO:
      MESSAGE 'Se ha encontrado Terminales y/o Correlativos con este ID' SKIP
          'Continuamos con la anulación del registro?'
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
          UPDATE rpta AS LOG.
      IF rpta = NO THEN RETURN 'ADM-ERROR'.
  END.
  /* Borramos los relacionados */
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FOR EACH CcbCTerm WHERE CcbCTerm.CodCia = FEcfgepos.CodCia
              AND CcbCTerm.CodDiv = FEcfgepos.CodDiv 
              AND CcbCTerm.ID_Pos = FEcfgepos.ID_Pos:
          ASSIGN CcbCTerm.ID_Pos = "".
      END.
      FOR EACH FacCorre WHERE FacCorre.CodCia = FEcfgepos.CodCia
                  AND FacCorre.CodDiv = FEcfgepos.CodDiv
                  AND FacCorre.ID_Pos = FEcfgepos.ID_Pos:
          ASSIGN FacCorre.ID_Pos = "".
      END.
      /* Dispatch standard ADM method.                             */
      RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
  END.


  /* Code placed here will execute AFTER standard behavior.    */

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
/*   RUN GET-ATTRIBUTE('ADM-NEW-RECORD').                           */
/*   IF RETURN-VALUE = 'NO' THEN                                    */
/*       ASSIGN                                                     */
/*       FEcfgepos.CodDiv:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES  */
/*       FEcfgepos.ID_Pos:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES. */
/*   ELSE ASSIGN                                                    */
/*       FEcfgepos.CodDiv:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO   */
/*       FEcfgepos.ID_Pos:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO.  */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE probar-espos B-table-Win 
PROCEDURE probar-espos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE FECfgePos THEN DO:
    MESSAGE "No hay divisiones cargadas".
    RETURN.
END.
                                 
DEFINE VAR hProc AS HANDLE NO-UNDO.                                   

DEFINE VAR lDivision AS CHAR.
DEFINE VAR lTerminalCaja AS CHAR.
DEFINE VAR cRetVal AS CHAR.
DEFINE VAR xRetVal AS CHAR.

IF VALID-HANDLE(hSocket) THEN DELETE OBJECT hSocket.
CREATE SOCKET hSocket.

RUN sunat\facturacion-electronicav2.p PERSISTENT SET hProc.

lTerminalCaja = combo-box-cajas.       
IF combo-box-cajas = 'Ninguno' THEN DO:
    lTerminalCaja = "".
END.
lDivision = FECfgePos.coddiv.

/**/
/*
lDivision = "00000".
lTerminalCaja = "".       
*/
/*
    lTerminalCaja :
        Terminal de Caja - Ejem CAJA01, TERM03 ó 
        vacio para que agarre los ID_POS de la division
        cuyo secuencia (fecfgepos.tipo > '05' )
        caso ventas credito, facturado por distribucion
*/

SESSION:SET-WAIT-STATE("GENERAL").

RUN pconecto-epos IN hProc (INPUT lDivision, INPUT lTerminalCaja, OUTPUT cRetVal).

xRetVal = DYNAMIC-FUNCTION('fdesconectar-epos':U IN  hProc).

SESSION:SET-WAIT-STATE("").

DEFINE VAR x-msg AS CHAR.

x-msg = cRetVal.
IF cRetVal BEGINS "000|OK" THEN DO:
    x-msg = "El ePOS " + FECfgePos.IP_ePOS + " con ID " + FECfgePos.ID_POS + " funciona CORRECTAMENTE".
END.

MESSAGE x-msg VIEW-AS ALERT-BOX WARNING.


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
  {src/adm/template/snd-list.i "FEcfgepos"}
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

IF NOT CAN-FIND(FIRST gn-divi WHERE gn-divi.codcia = s-codcia
                AND gn-divi.coddiv = FEcfgepos.CodDiv:SCREEN-VALUE IN BROWSE {&browse-name}
                NO-LOCK)
    THEN DO:
    MESSAGE 'NO registrada la división' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO FEcfgepos.CodDiv IN BROWSE {&browse-name}.
    RETURN 'ADM-ERROR'.
END.
RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF RETURN-VALUE = "NO" AND FEcfgepos.ID_Pos <> FEcfgepos.ID_Pos:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    THEN DO:
    MESSAGE 'Usted ha modificado el ID del e-Pos' SKIP
        'Continuamos con la grabación?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN DO:
        APPLY 'ENTRY':U TO FEcfgepos.ID_Pos IN BROWSE {&BROWSE-NAME}.
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

