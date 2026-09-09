&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-MATG FOR Almmmatg.
DEFINE SHARED TEMP-TABLE ITEM LIKE Almdmov.



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
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-fchdoc AS DATE.
DEF VAR f-Factor-1 AS DEC NO-UNDO.
DEF VAR f-Factor-2 AS DEC NO-UNDO.
DEF VAR s-local-new-record AS CHAR.
DEF SHARED VAR lh_handle AS HANDLE.

DEF VAR X-CLAVE  AS CHAR INIT 'adminconti' NO-UNDO.
DEF VAR X-REP AS CHAR NO-UNDO.

DEF BUFFER b-item FOR ITEM.

DEF VAR x-ctomat AS DECIMAL.
DEF VAR x-ctoant AS DECIMAL.
DEF VAR x-pordif AS DECIMAL.

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
&Scoped-define INTERNAL-TABLES ITEM Almmmatg B-MATG

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table ITEM.NroItm ITEM.codmat ~
Almmmatg.DesMat Almmmatg.UndStk ITEM.CanDes ITEM.CodAnt B-MATG.DesMat ~
B-MATG.UndStk 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table ITEM.codmat ITEM.CanDes ~
ITEM.CodAnt 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table ITEM
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table ITEM
&Scoped-define QUERY-STRING-br_table FOR EACH ITEM WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF ITEM NO-LOCK, ~
      EACH B-MATG WHERE B-MATG.CodCia = ITEM.CodCia ~
  AND B-MATG.codmat = ITEM.CodAnt NO-LOCK ~
    BY ITEM.NroItm
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH ITEM WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF ITEM NO-LOCK, ~
      EACH B-MATG WHERE B-MATG.CodCia = ITEM.CodCia ~
  AND B-MATG.codmat = ITEM.CodAnt NO-LOCK ~
    BY ITEM.NroItm.
&Scoped-define TABLES-IN-QUERY-br_table ITEM Almmmatg B-MATG
&Scoped-define FIRST-TABLE-IN-QUERY-br_table ITEM
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg
&Scoped-define THIRD-TABLE-IN-QUERY-br_table B-MATG


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
      ITEM, 
      Almmmatg, 
      B-MATG SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      ITEM.NroItm FORMAT ">>>>9":U
      ITEM.codmat COLUMN-LABEL "Codigo Salida" FORMAT "X(14)":U
      Almmmatg.DesMat FORMAT "X(50)":U
      Almmmatg.UndStk COLUMN-LABEL "Unidad" FORMAT "X(7)":U WIDTH 8.72
      ITEM.CanDes FORMAT "(ZZZ,ZZZ,ZZ9.9999)":U
      ITEM.CodAnt COLUMN-LABEL "Codigo Entrada" FORMAT "X(6)":U
      B-MATG.DesMat FORMAT "X(50)":U
      B-MATG.UndStk COLUMN-LABEL "Unidad" FORMAT "X(8)":U
  ENABLE
      ITEM.codmat
      ITEM.CanDes
      ITEM.CodAnt
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 136 BY 8.08
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
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-MATG B "?" ? INTEGRAL Almmmatg
      TABLE: ITEM T "SHARED" ? INTEGRAL Almdmov
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
         HEIGHT             = 8.27
         WIDTH              = 141.14.
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
     _TblList          = "Temp-Tables.ITEM,INTEGRAL.Almmmatg OF Temp-Tables.ITEM,B-MATG WHERE Temp-Tables.ITEM ..."
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ",,"
     _OrdList          = "Temp-Tables.ITEM.NroItm|yes"
     _JoinCode[3]      = "B-MATG.CodCia = Temp-Tables.ITEM.CodCia
  AND B-MATG.codmat = Temp-Tables.ITEM.CodAnt"
     _FldNameList[1]   = Temp-Tables.ITEM.NroItm
     _FldNameList[2]   > Temp-Tables.ITEM.codmat
"ITEM.codmat" "Codigo Salida" "X(14)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(50)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.UndStk
"Almmmatg.UndStk" "Unidad" "X(7)" "character" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ITEM.CanDes
"ITEM.CanDes" ? ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ITEM.CodAnt
"ITEM.CodAnt" "Codigo Entrada" "X(6)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.B-MATG.DesMat
"B-MATG.DesMat" ? "X(50)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.B-MATG.UndStk
"B-MATG.UndStk" "Unidad" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME ITEM.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ITEM.codmat IN BROWSE br_table /* Codigo Salida */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  IF s-local-new-record = 'NO' AND SELF:SCREEN-VALUE = ITEM.codmat THEN RETURN.

  DEF VAR pCodMat AS CHAR NO-UNDO.
  pCodMat = SELF:SCREEN-VALUE.
  /*RUN vtagn/p-codbrr-01 (INPUT-OUTPUT pCodMat).*/
  RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, INPUT YES ).
  IF pCodMat = '' THEN RETURN NO-APPLY.
  SELF:SCREEN-VALUE = pCodMat.
  /* CONSISTENCIA */
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
      AND  Almmmatg.CodMat = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
      MESSAGE "Producto NO registrado en el catálogo" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO ITEM.CodMat IN BROWSE {&Browse-name}.
      RETURN NO-APPLY.
  END.
  FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
      AND  Almmmate.CodAlm = S-CODALM 
      AND  Almmmate.CodMat = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmate THEN DO:
     MESSAGE "Producto NO asignado a este Almacén" VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY" TO ITEM.CodMat.
     RETURN NO-APPLY.   
  END.
  DISPLAY 
      Almmmatg.DesMat @ Almmmatg.DesMat 
      Almmmatg.UndStk @ Almmmatg.UndStk
      WITH BROWSE {&BROWSE-NAME}.
  FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
      AND  Almtconv.Codalter = Almmmatg.UndStk
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almtconv THEN DO:
     MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  F-Factor-1 = Almtconv.Equival.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ITEM.CodAnt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.CodAnt br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ITEM.CodAnt IN BROWSE br_table /* Codigo Entrada */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    IF s-local-new-record = 'NO' AND SELF:SCREEN-VALUE = ITEM.codant THEN RETURN.

    DEF VAR pCodMat AS CHAR NO-UNDO.
    pCodMat = SELF:SCREEN-VALUE.
    /*RUN vtagn/p-codbrr-01 (INPUT-OUTPUT pCodMat).*/
    RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, INPUT YES ).
    IF pCodMat = '' THEN RETURN NO-APPLY.
    SELF:SCREEN-VALUE = pCodMat.
    /* CONSISTENCIA */
    FIND B-MATG WHERE B-MATG.CodCia = S-CODCIA 
        AND  B-MATG.CodMat = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-MATG THEN DO:
        MESSAGE "Producto NO registrado en el catálogo" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO ITEM.CodAnt IN BROWSE {&Browse-name}.
        RETURN NO-APPLY.
    END.
    FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
        AND  Almmmate.CodAlm = S-CODALM 
        AND  Almmmate.CodMat = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN DO:
       MESSAGE "Producto NO asignado a este Almacén" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO ITEM.CodAnt.
       RETURN NO-APPLY.   
    END.
    DISPLAY 
        B-MATG.DesMat @ B-MATG.DesMat 
        B-MATG.UndStk @ B-MATG.UndStk
        WITH BROWSE {&BROWSE-NAME}.
    FIND Almtconv WHERE Almtconv.CodUnid = B-MATG.UndBas 
        AND  Almtconv.Codalter = B-MATG.UndStk
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
       MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    F-Factor-2 = Almtconv.Equival.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF ITEM.CanDes, ITEM.CodAnt, ITEM.codmat
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  s-local-new-record = 'YES'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('Disable').

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
  DEF VAR x-Item AS INT INIT 1 NO-UNDO.
  IF s-local-new-record = 'YES' THEN DO:
      FOR EACH B-ITEM BY B-ITEM.NroItm:
          x-Item = B-ITEM.NroItm + 1.
      END.
  END.
  ELSE x-Item = ITEM.NroItm.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      ITEM.NroItm = x-Item
      ITEM.Factor = f-Factor-1
      ITEM.PreBas = f-Factor-2
      ITEM.CodCia = s-codcia.
  /* VALORIZACION DEL INGRESO */
  FIND LAST Almstkge WHERE Almstkge.codcia = s-codcia
      AND Almstkge.codmat = ITEM.CodMat
      AND Almstkge.fecha <= s-FchDoc
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almstkge 
  THEN ASSIGN
      ITEM.PreUni = AlmStkge.CtoUni * f-Factor-1
      ITEM.ImpCto = ITEM.CanDes * ITEM.PreUni
      ITEM.CodMon = 1.
  s-local-new-record = 'NO'.
  RUN Procesa-Handle IN lh_handle ('Enable').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record B-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  s-local-new-record = 'NO'.
  RUN Procesa-Handle IN lh_handle ('Enable').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

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
  {src/adm/template/snd-list.i "ITEM"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "B-MATG"}

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

    DEF VAR s-Ok AS LOG.
    DEF VAR s-StkDis AS DEC.
    DEF VAR x-CodFam-1 AS CHAR.
    DEF VAR x-CodFam-2 AS CHAR.
    DEF VAR x-CtoLis LIKE Almmmatg.CtoLis.      /* COSTO LISTA DE PRECIOS */

    IF ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
       MESSAGE "Codigo de articulo en blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO ITEM.CodMat.
       RETURN "ADM-ERROR".   
    END.
    IF DECIMAL(ITEM.CanDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <= 0 THEN DO:
       MESSAGE "Cantidad debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO ITEM.CanDes.
       RETURN "ADM-ERROR".   
    END.
    FIND Almmmatg WHERE Almmmatg.CodCia = S-CodCia AND
         Almmmatg.CodMat = ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        MESSAGE "Articulo" ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
            "NO registrado" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO ITEM.CodMat.
        RETURN "ADM-ERROR".   
    END. 
    x-CodFam-1 = Almmmatg.codfam + ALmmmatg.subfam.
    FIND Almmmate WHERE Almmmate.CodCia = S-CodCia AND
         Almmmate.CodAlm = S-CodAlm AND
         Almmmate.CodMat = ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate OR 
       (Almmmate.StkAct - DECIMAL(ITEM.CanDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) ) < 0 THEN DO:
       IF NOT AVAILABLE Almmmate THEN 
          MESSAGE "Articulo no esta asignado al almacén " S-CodAlm VIEW-AS ALERT-BOX ERROR.
       ELSE MESSAGE "No hay Stock en almacén " S-CodAlm VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO ITEM.CanDes.
       RETURN "ADM-ERROR".   
    END. 
    /* RHC 11.01.10 nueva rutina */
    DEF VAR pComprometido AS DEC.
    /*RUN vta2/stock-comprometido (Almmmate.codmat, Almmmate.codalm, OUTPUT pComprometido).*/
    RUN gn/stock-comprometido-v2 (Almmmate.codmat, Almmmate.codalm, YES, OUTPUT pComprometido).

    /* CONSISTENCIA NORMAL */
    IF DECIMAL(ITEM.CanDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) *  f-Factor-1 > (Almmmate.stkact - pComprometido)
        THEN DO:
        MESSAGE 'NO se puede sacar más de' (Almmmate.stkact - pComprometido) SKIP(1)
            'Stock actual:' Almmmate.StkAct SKIP
            'Stock comprometido:' pComprometido SKIP
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO ITEM.CanDes.
        RETURN "ADM-ERROR".
    END.

    /* VERIFICAMOS CODIGO ENTRANTE */
   IF ITEM.CodAnt:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
       MESSAGE "Codigo de articulo en blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO ITEM.CodAnt.
       RETURN "ADM-ERROR".   
    END.
    FIND B-MATG WHERE B-MATG.CodCia = S-CodCia AND
         B-MATG.CodMat = ITEM.CodAnt:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-MATG THEN DO:
        MESSAGE "Articulo" ITEM.CodAnt:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
            "NO registrado" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO ITEM.CodAnt.
        RETURN "ADM-ERROR".   
    END. 
    x-CodFam-2 = B-MATG.codfam + B-MATG.subfam.
    FIND Almmmate WHERE Almmmate.CodCia = S-CodCia AND
         Almmmate.CodAlm = S-CodAlm AND
         Almmmate.CodMat = ITEM.CodAnt:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN DO:
        MESSAGE "Articulo"  ITEM.CodAnt:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
            "no esta asignado al almacen " S-CodAlm VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO ITEM.CodAnt.
       RETURN "ADM-ERROR".   
    END. 
    /* ******************************************** */
    /* RHC 23/03/2015 CONSISTENCIA DE EQUIVALENCIAS */
    /* ******************************************** */
    IF Almmmatg.UndStk <> B-MATG.UndStk THEN DO:
        FIND Almdrecl WHERE Almdrecl.codcia = s-codcia
            AND Almdrecl.codmatr = ITEM.codant:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
            AND Almdrecl.codmat  = ITEM.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almdrecl THEN DO:
            MESSAGE 'Las unidades de medida SON diferentes entre los dos códigos' SKIP
                'En tal caso configurar la reclasificación automática' SKIP
                'Continuamos con la grabación SI o NO?' SKIP(2)
                "Si selecciona SI la cantidad va a ser igual para ambos códigos"
                VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE rpta AS LOG.
            IF rpta = NO THEN DO:
                APPLY "ENTRY" TO ITEM.CodMat.
                RETURN "ADM-ERROR".   
            END.
        END.
    END.
    /* ******************************************** */
    /* VALORIZACION DEL INGRESO */
    FIND LAST Almstkge WHERE Almstkge.codcia = s-codcia
        AND Almstkge.codmat = ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        AND Almstkge.fecha <= s-FchDoc
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almstkge OR AlmStkge.CtoUni <= 0 THEN DO:
        MESSAGE 'Error en el costo unitario' VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO ITEM.CodMat.
        RETURN "ADM-ERROR".   
    END.
    /* ******************************************** */
    /* CONSISTENCIA DE FAMILIAS Y SUBFAMILIAS */
    IF x-CodFam-1 <> x-CodFam-2 THEN DO:
        MESSAGE 'Las familias y subfamilias deben ser iguales en ambos productos'
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO ITEM.CodMat.
        RETURN "ADM-ERROR".   
    END.

    /* DIFERENCIA DE COSTOS */
    /* RHC 28.01.11 Verificamos en las tablas de reclasificaciones */
    FIND Almdrecl WHERE Almdrecl.codcia = s-codcia
        AND Almdrecl.codmatr = ITEM.codant:SCREEN-VALUE IN BROWSE {&browse-name}
        AND Almdrecl.codmat  = ITEM.codmat:SCREEN-VALUE IN BROWSE {&browse-name}
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almdrecl 
    THEN DO:
        FIND Almmmatg WHERE Almmmatg.CodCia = S-CodCia AND
             Almmmatg.CodMat = ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
             NO-LOCK NO-ERROR.
        IF Almmmatg.MonVta = 1 THEN x-CtoLis = Almmmatg.CtoLis.
        ELSE x-CtoLis = Almmmatg.CtoLis * Almmmatg.TpoCmb.
        x-CtoMat = x-CtoLis * Almdrecl.Factor.

        FIND B-MATG WHERE B-MATG.codcia = s-codcia
            AND B-MATG.codmat = ITEM.CodAnt:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
            NO-LOCK NO-ERROR.
        IF B-MATG.MonVta = 1 THEN x-CtoLis = B-MATG.CtoLis.
        ELSE x-CtoLis = B-MATG.CtoLis * B-MATG.TpoCmb.
        x-CtoAnt = x-CtoLis.
    END.
    ELSE DO:
        FIND Almmmatg WHERE Almmmatg.CodCia = S-CodCia AND
             Almmmatg.CodMat = ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
             NO-LOCK NO-ERROR.
        IF Almmmatg.MonVta = 1 THEN x-CtoLis = Almmmatg.CtoLis.
        ELSE x-CtoLis = Almmmatg.CtoLis * Almmmatg.TpoCmb.
        x-CtoMat = x-CtoLis * f-Factor-1.

        FIND B-MATG WHERE B-MATG.codcia = s-codcia
            AND B-MATG.codmat = ITEM.CodAnt:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
            NO-LOCK NO-ERROR.
        IF B-MATG.MonVta = 1 THEN x-CtoLis = B-MATG.CtoLis.
        ELSE x-CtoLis = B-MATG.CtoLis * B-MATG.TpoCmb.
        x-CtoAnt = x-CtoLis * f-Factor-1.
    END.
    /* RHC 02/06/2015 */
    x-PorDif = 0.
    IF x-CtoAnt <> 0 THEN x-PorDif = ((x-ctoant - x-ctomat) / x-ctoant ) * 100.
    ELSE IF x-CtoMat <> 0 THEN x-pordif = ((x-ctoant - x-ctomat) / x-ctomat ) * 100.
    /* ************** */

    IF x-pordif <= - 10 OR x-pordif >= 10 THEN DO:
        MESSAGE 'La Diferencia de Costos Supera a la Permitida'
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO ITEM.CodMat.
        RETURN 'ADM-ERROR'.
    END.
    /* fin de diferencia de costos */
    FIND FIRST b-item WHERE b-item.codmat = ITEM.codmat:SCREEN-VALUE 
        AND ROWID(b-item) <> ROWID(ITEM)
        NO-LOCK NO-ERROR.
    IF AVAIL b-item THEN DO:
        MESSAGE "Ya existe una Salida para este Artículo"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        APPLY "ENTRY" TO ITEM.CodMat.
        RETURN "ADM-ERROR".
    END.
    
    FIND FIRST b-item WHERE b-item.codant = ITEM.codant:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAIL b-item THEN DO:
        MESSAGE "Ya existe un Ingreso para este Artículo"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        APPLY "ENTRY" TO ITEM.CodAnt.
        RETURN "ADM-ERROR".
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
f-Factor-1 = ITEM.Factor.
f-Factor-2 = ITEM.PreBas.
s-local-new-record = 'NO'.
RUN Procesa-Handle IN lh_handle ('Disable').
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

