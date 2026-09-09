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

DEF SHARED VAR s-codcia AS INTE.

DEF VAR s-coddoc AS CHAR INIT 'G/R' NO-UNDO.

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
&Scoped-define INTERNAL-TABLES FacCorre GN-DIVI Almacen

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacCorre.FlgEst FacCorre.CodDiv ~
GN-DIVI.DesDiv FacCorre.CodAlm Almacen.Descripcion FacCorre.NroSer ~
FacCorre.Correlativo FacCorre.NroIni FacCorre.NroFin FacCorre.ID_Pos ~
FacCorre.NroImp FacCorre.ID_Pos2 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table FacCorre.FlgEst ~
FacCorre.CodDiv FacCorre.CodAlm FacCorre.NroSer FacCorre.Correlativo ~
FacCorre.NroIni FacCorre.NroFin FacCorre.ID_Pos FacCorre.NroImp ~
FacCorre.ID_Pos2 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table FacCorre
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table FacCorre
&Scoped-define QUERY-STRING-br_table FOR EACH FacCorre WHERE ~{&KEY-PHRASE} ~
      AND FacCorre.CodCia = s-codcia ~
 AND FacCorre.CodDoc = s-coddoc ~
 AND (TOGGLE-SoloActivos = NO OR FacCorre.FlgEst = TRUE) ~
 AND (COMBO-BOX-CodDiv = 'Todas' OR FacCorre.CodDiv = COMBO-BOX-CodDiv) NO-LOCK, ~
      FIRST GN-DIVI OF FacCorre NO-LOCK, ~
      FIRST Almacen OF FacCorre OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacCorre WHERE ~{&KEY-PHRASE} ~
      AND FacCorre.CodCia = s-codcia ~
 AND FacCorre.CodDoc = s-coddoc ~
 AND (TOGGLE-SoloActivos = NO OR FacCorre.FlgEst = TRUE) ~
 AND (COMBO-BOX-CodDiv = 'Todas' OR FacCorre.CodDiv = COMBO-BOX-CodDiv) NO-LOCK, ~
      FIRST GN-DIVI OF FacCorre NO-LOCK, ~
      FIRST Almacen OF FacCorre OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table FacCorre GN-DIVI Almacen
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacCorre
&Scoped-define SECOND-TABLE-IN-QUERY-br_table GN-DIVI
&Scoped-define THIRD-TABLE-IN-QUERY-br_table Almacen


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS TOGGLE-SoloActivos COMBO-BOX-CodDiv br_table 
&Scoped-Define DISPLAYED-OBJECTS TOGGLE-SoloActivos COMBO-BOX-CodDiv 

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
DEFINE VARIABLE COMBO-BOX-CodDiv AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Mostrar solo de la división" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Todas","Todas"
     DROP-DOWN-LIST
     SIZE 79 BY 1 NO-UNDO.

DEFINE VARIABLE TOGGLE-SoloActivos AS LOGICAL INITIAL no 
     LABEL "Mostrar solo Activos" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      FacCorre, 
      GN-DIVI
    FIELDS(GN-DIVI.DesDiv), 
      Almacen
    FIELDS(Almacen.Descripcion) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacCorre.FlgEst COLUMN-LABEL "Estado" FORMAT "Activo/Inactivo":U
            WIDTH 11.43 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEMS "yes","no" 
                      DROP-DOWN-LIST 
      FacCorre.CodDiv COLUMN-LABEL "División" FORMAT "x(8)":U COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      GN-DIVI.DesDiv FORMAT "X(40)":U
      FacCorre.CodAlm FORMAT "x(8)":U COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      Almacen.Descripcion FORMAT "X(40)":U WIDTH 29.86
      FacCorre.NroSer FORMAT "999":U COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      FacCorre.Correlativo FORMAT ">>>>>>>9":U COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      FacCorre.NroIni COLUMN-LABEL "Desde" FORMAT ">>>>>>>9":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 10
      FacCorre.NroFin COLUMN-LABEL "Hasta" FORMAT ">>>>>>>9":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      FacCorre.ID_Pos COLUMN-LABEL "Tipo de GR" FORMAT "x(15)":U
            WIDTH 16 COLUMN-FGCOLOR 0 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "ELECTRONICA","ELECTRONICA",
                                      "MANUAL","CLASICA"
                      DROP-DOWN-LIST 
      FacCorre.NroImp COLUMN-LABEL "Formato de papel" FORMAT "x(20)":U
            WIDTH 20.29 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "Papel Contínuo 13 línea","C13",
                                      "Papel Contínuo 36 líneas","C36",
                                      "Papel Bond A4","A4"
                      DROP-DOWN-LIST 
      FacCorre.ID_Pos2 COLUMN-LABEL "Tipo de Uso" FORMAT "x(20)":U
            WIDTH 1 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "VARIOS","",
                                      "TRANSFERENCIAS","TRANSFERENCIAS",
                                      "VENTAS","VENTAS",
                                      "ITINERANTES","ITINERANTES"
                      DROP-DOWN-LIST 
  ENABLE
      FacCorre.FlgEst
      FacCorre.CodDiv
      FacCorre.CodAlm
      FacCorre.NroSer
      FacCorre.Correlativo
      FacCorre.NroIni
      FacCorre.NroFin
      FacCorre.ID_Pos
      FacCorre.NroImp
      FacCorre.ID_Pos2
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 176 BY 22.08
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     TOGGLE-SoloActivos AT ROW 1.27 COL 51 WIDGET-ID 2
     COMBO-BOX-CodDiv AT ROW 1.27 COL 96 COLON-ALIGNED WIDGET-ID 4
     br_table AT ROW 2.62 COL 1
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
         HEIGHT             = 23.73
         WIDTH              = 178.86.
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
/* BROWSE-TAB br_table COMBO-BOX-CodDiv F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.FacCorre,INTEGRAL.GN-DIVI OF INTEGRAL.FacCorre,INTEGRAL.Almacen OF INTEGRAL.FacCorre"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST USED, FIRST OUTER USED"
     _Where[1]         = "FacCorre.CodCia = s-codcia
 AND FacCorre.CodDoc = s-coddoc
 AND (TOGGLE-SoloActivos = NO OR FacCorre.FlgEst = TRUE)
 AND (COMBO-BOX-CodDiv = 'Todas' OR FacCorre.CodDiv = COMBO-BOX-CodDiv)"
     _FldNameList[1]   > INTEGRAL.FacCorre.FlgEst
"FacCorre.FlgEst" "Estado" ? "logical" ? ? ? ? ? ? yes ? no no "11.43" yes no no "U" "" "" "DROP-DOWN-LIST" "," "yes,no" ? 5 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacCorre.CodDiv
"FacCorre.CodDiv" "División" "x(8)" "character" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.GN-DIVI.DesDiv
     _FldNameList[4]   > INTEGRAL.FacCorre.CodAlm
"FacCorre.CodAlm" ? "x(8)" "character" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.Almacen.Descripcion
"Almacen.Descripcion" ? ? "character" ? ? ? ? ? ? no ? no no "29.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacCorre.NroSer
"FacCorre.NroSer" ? ? "integer" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.FacCorre.Correlativo
"FacCorre.Correlativo" ? ">>>>>>>9" "integer" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.FacCorre.NroIni
"FacCorre.NroIni" "Desde" ">>>>>>>9" "integer" 10 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.FacCorre.NroFin
"FacCorre.NroFin" "Hasta" ">>>>>>>9" "integer" 14 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.FacCorre.ID_Pos
"FacCorre.ID_Pos" "Tipo de GR" ? "character" ? 0 ? ? ? ? yes ? no no "16" yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "ELECTRONICA,ELECTRONICA,MANUAL,CLASICA" 5 no 0 no no
     _FldNameList[11]   > INTEGRAL.FacCorre.NroImp
"FacCorre.NroImp" "Formato de papel" "x(20)" "character" 14 0 ? ? ? ? yes ? no no "20.29" yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "Papel Contínuo 13 línea,C13,Papel Contínuo 36 líneas,C36,Papel Bond A4,A4" 5 no 0 no no
     _FldNameList[12]   > INTEGRAL.FacCorre.ID_Pos2
"FacCorre.ID_Pos2" "Tipo de Uso" "x(20)" "character" 11 0 ? ? ? ? yes ? no no "1" yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "VARIOS,,TRANSFERENCIAS,TRANSFERENCIAS,VENTAS,VENTAS,ITINERANTES,ITINERANTES" 5 no 0 no no
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


&Scoped-define SELF-NAME COMBO-BOX-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodDiv B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-CodDiv IN FRAME F-Main /* Mostrar solo de la división */
DO:
    ASSIGN {&self-name}.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-SoloActivos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-SoloActivos B-table-Win
ON VALUE-CHANGED OF TOGGLE-SoloActivos IN FRAME F-Main /* Mostrar solo Activos */
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
      FacCorre.FlgCic = NO.     /* OJO: no va a ser cíclico */

  DEF VAR pEvento AS CHAR NO-UNDO.

  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN pEvento = "CREATE".
  ELSE pEvento = "UPDATE".
  
  RUN lib/logtabla (INPUT 'FACCORRE',
                    INPUT ('CodCia:' + STRING(FacCorre.CodCia, '999') + '|' +
                           'CodDoc:' + FacCorre.CodDoc + '|' +
                           'CodDiv:' + FacCorre.CodDiv + '|' +
                           'CodAlm:' + FacCorre.CodAlm + '|' +
                           'NroSer:' + STRING(FacCorre.NroSer, '999') + '|' +
                           'Correlativo:' + STRING(FacCorre.Correlativo) + '|' +
                           'FlgEst:' + STRING(FacCorre.FlgEst) + '|' +
                           'ID_Pos:' + FacCorre.ID_Pos + '|' +
                           'ID_Pos2:' + FacCorre.ID_Pos2 + '|' +
                           'NroIni:' + STRING(FacCorre.NroIni) + '|' +
                           'NroFin:' + STRING(FacCorre.NroFin) + '|' +
                           'NroImp:' + FacCorre.NroImp),
                    INPUT pEvento).


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
      FacCorre.CodCia = s-codcia
      FacCorre.CodDoc = s-coddoc.

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
  DEF VAR pEvento AS CHAR INIT 'DELETE' NO-UNDO.

  RUN lib/logtabla (INPUT 'FACCORRE',
                    INPUT ('CodCia:' + STRING(FacCorre.CodCia, '999') + '|' +
                           'CodDoc:' + FacCorre.CodDoc + '|' +
                           'CodDiv:' + FacCorre.CodDiv + '|' +
                           'CodAlm:' + FacCorre.CodAlm + '|' +
                           'NroSer:' + STRING(FacCorre.NroSer, '999') + '|' +
                           'Correlativo:' + STRING(FacCorre.Correlativo) + '|' +
                           'FlgEst:' + STRING(FacCorre.FlgEst) + '|' +
                           'ID_Pos:' + FacCorre.ID_Pos + '|' +
                           'ID_Pos2:' + FacCorre.ID_Pos2 + '|' +
                           'NroIni:' + STRING(FacCorre.NroIni) + '|' +
                           'NroFin:' + STRING(FacCorre.NroFin) + '|' +
                           'NroImp:' + FacCorre.NroImp),
                    INPUT pEvento).

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
  ENABLE TOGGLE-SoloActivos COMBO-BOX-CodDiv WITH FRAME {&FRAME-NAME}.

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
  DISABLE TOGGLE-SoloActivos COMBO-BOX-CodDiv WITH FRAME {&FRAME-NAME}.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' 
      THEN 
      ASSIGN 
            FacCorre.NroSer:READ-ONLY IN BROWSE {&browse-name} = YES
            FacCorre.CodDiv:READ-ONLY IN BROWSE {&browse-name} = YES
      .
  ELSE ASSIGN 
            FacCorre.NroSer:READ-ONLY IN BROWSE {&browse-name} = NO
            FacCorre.CodDiv:READ-ONLY IN BROWSE {&browse-name} = NO
      .
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-CodDiv:DELIMITER = CHR(9).
      FOR EACH gn-divi NO-LOCK WHERE GN-DIVI.CodCia = s-codcia AND
          GN-DIVI.Campo-Log[1] = NO:
          COMBO-BOX-CodDiv:ADD-LAST(GN-DIVI.CodDiv + ' - ' + GN-DIVI.DesDiv, GN-DIVI.CodDiv).
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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
  {src/adm/template/snd-list.i "FacCorre"}
  {src/adm/template/snd-list.i "GN-DIVI"}
  {src/adm/template/snd-list.i "Almacen"}

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
PROCEDURE valida PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF RETURN-VALUE = 'YES' THEN DO:
    IF CAN-FIND(FIRST FacCorre WHERE FacCorre.CodCia = s-codcia AND
                FacCorre.CodDoc = "G/R" AND
                FacCorre.NroSer = INTEGER(FacCorre.NroSer:SCREEN-VALUE IN BROWSE {&browse-name})
                NO-LOCK) THEN DO:
        MESSAGE 'Número de serie ya registrado' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO FacCorre.NroSer.
        RETURN 'ADM-ERROR'.
    END.
END.

FIND gn-divi WHERE gn-divi.codcia = s-codcia AND
    gn-divi.coddiv = FacCorre.CodDiv:SCREEN-VALUE IN BROWSE {&browse-name}
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    MESSAGE 'División no registrada' VIEW-AS ALERT-BOX WARNING.
    APPLY 'ENTRY':U TO FacCorre.CodDiv.
    RETURN 'ADM-ERROR'.
END.

IF TRUE <> (FacCorre.CodAlm:SCREEN-VALUE IN BROWSE {&browse-name} > '') THEN DO:
    MESSAGE 'NO ha registrado el almacén para esta serie' VIEW-AS ALERT-BOX WARNING.
    APPLY 'ENTRY':U TO FacCorre.CodAlm.
    RETURN 'ADM-ERROR'.
END.
ELSE DO:
    FIND FIRST Almacen WHERE Almacen.CodCia = s-codcia AND
        Almacen.CodAlm = FacCorre.CodAlm:SCREEN-VALUE IN BROWSE {&browse-name}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almacen THEN DO:
        MESSAGE 'Almacén NO registrado' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO FacCorre.CodAlm.
        RETURN 'ADM-ERROR'.
    END.
    IF Almacen.CodDiv <> FacCorre.CodDiv:SCREEN-VALUE IN BROWSE {&browse-name} THEN DO:
        MESSAGE 'El almacén no pertenece a la división' FacCorre.CodDiv:SCREEN-VALUE IN BROWSE {&browse-name}
            VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO FacCorre.CodAlm.
        RETURN 'ADM-ERROR'.
    END.
END.
RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF RETURN-VALUE = "YES" THEN DO:
    IF CAN-FIND(FIRST FacCorre WHERE FacCorre.codcia = s-codcia
                AND FacCorre.coddoc = s-coddoc 
                AND FacCorre.nroser = INPUT FacCorre.NroSer 
                NO-LOCK)
        THEN DO:
        MESSAGE 'Correlativo ya registrado' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO FacCorre.NroSer.
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

