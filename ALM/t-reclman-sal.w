&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-MATG FOR Almmmatg.
DEFINE SHARED TEMP-TABLE ITEM-1 LIKE Almdmov.



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
DEF VAR s-local-new-record AS CHAR.
DEF SHARED VAR lh_handle AS HANDLE.

DEF VAR X-CLAVE  AS CHAR INIT 'adminconti' NO-UNDO.
DEF VAR X-REP AS CHAR NO-UNDO.

DEF BUFFER b-item FOR ITEM-1.

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
&Scoped-define INTERNAL-TABLES ITEM-1 Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table ITEM-1.NroItm ITEM-1.codmat ~
Almmmatg.DesMat Almmmatg.DesMar Almmmatg.UndStk ITEM-1.CanDes ITEM-1.PreUni ~
ITEM-1.ImpCto 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table ITEM-1.codmat ITEM-1.CanDes 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table ITEM-1
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table ITEM-1
&Scoped-define QUERY-STRING-br_table FOR EACH ITEM-1 WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF ITEM-1 NO-LOCK ~
    BY ITEM-1.NroItm
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH ITEM-1 WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF ITEM-1 NO-LOCK ~
    BY ITEM-1.NroItm.
&Scoped-define TABLES-IN-QUERY-br_table ITEM-1 Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table ITEM-1
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table BUTTON_Import_Excel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-ImpTot FILL-IN-CanTot 

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
DEFINE BUTTON BUTTON_Import_Excel 
     IMAGE-UP FILE "img/import-excel.bmp":U
     LABEL "Button 2" 
     SIZE 19 BY 1.62.

DEFINE VARIABLE FILL-IN-CanTot AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     LABEL "TOTAL CANTIDAD" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpTot AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     LABEL "TOTAL IMPORTE" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      ITEM-1, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      ITEM-1.NroItm FORMAT ">>>>9":U
      ITEM-1.codmat COLUMN-LABEL "Codigo" FORMAT "X(14)":U
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 50.29
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U
      Almmmatg.UndStk COLUMN-LABEL "Unidad" FORMAT "X(6)":U WIDTH 6.72
      ITEM-1.CanDes FORMAT "(ZZZ,ZZZ,ZZ9.9999)":U WIDTH 8.43
      ITEM-1.PreUni FORMAT "Z,ZZZ,ZZ9.9999":U
      ITEM-1.ImpCto FORMAT "Z,ZZZ,ZZ9.9999":U
  ENABLE
      ITEM-1.codmat
      ITEM-1.CanDes
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 126 BY 5.38
         FONT 4
         TITLE "SALIDA" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     BUTTON_Import_Excel AT ROW 6.38 COL 44 WIDGET-ID 6
     FILL-IN-ImpTot AT ROW 6.58 COL 111 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-CanTot AT ROW 6.65 COL 80 COLON-ALIGNED WIDGET-ID 4
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
      TABLE: ITEM-1 T "SHARED" ? INTEGRAL Almdmov
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
         HEIGHT             = 8
         WIDTH              = 127.14.
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

/* SETTINGS FOR FILL-IN FILL-IN-CanTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.ITEM-1,INTEGRAL.Almmmatg OF Temp-Tables.ITEM-1"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ",,"
     _OrdList          = "Temp-Tables.ITEM-1.NroItm|yes"
     _FldNameList[1]   = Temp-Tables.ITEM-1.NroItm
     _FldNameList[2]   > Temp-Tables.ITEM-1.codmat
"ITEM-1.codmat" "Codigo" "X(14)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "50.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.Almmmatg.UndStk
"Almmmatg.UndStk" "Unidad" "X(6)" "character" ? ? ? ? ? ? no ? no no "6.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ITEM-1.CanDes
"ITEM-1.CanDes" ? ? "decimal" ? ? ? ? ? ? yes ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ITEM-1.PreUni
"ITEM-1.PreUni" ? "Z,ZZZ,ZZ9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ITEM-1.ImpCto
"ITEM-1.ImpCto" ? "Z,ZZZ,ZZ9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* SALIDA */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* SALIDA */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* SALIDA */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ITEM-1.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM-1.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ITEM-1.codmat IN BROWSE br_table /* Codigo */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  IF s-local-new-record = 'NO' AND SELF:SCREEN-VALUE = ITEM-1.codmat THEN RETURN.

  DEF VAR pCodMat AS CHAR NO-UNDO.
  pCodMat = CAPS(SELF:SCREEN-VALUE).
  RUN vtagn/p-codbrr-01 (INPUT-OUTPUT pCodMat).
  IF pCodMat = '' THEN RETURN NO-APPLY.
  SELF:SCREEN-VALUE = pCodMat.
  /* CONSISTENCIA */
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
      AND  Almmmatg.CodMat = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
      MESSAGE "Producto NO registrado en el catálogo" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO ITEM-1.CodMat IN BROWSE {&Browse-name}.
      RETURN NO-APPLY.
  END.
  FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
      AND  Almmmate.CodAlm = S-CODALM 
      AND  Almmmate.CodMat = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmate THEN DO:
     MESSAGE "Producto NO asignado a este Almacén" VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY" TO ITEM-1.CodMat.
     RETURN NO-APPLY.   
  END.
  DISPLAY 
      Almmmatg.DesMat @ Almmmatg.DesMat 
      Almmmatg.UndStk @ Almmmatg.UndStk
      Almmmatg.DesMar @ Almmmatg.DesMar
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


&Scoped-define SELF-NAME BUTTON_Import_Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Import_Excel B-table-Win
ON CHOOSE OF BUTTON_Import_Excel IN FRAME F-Main /* Button 2 */
DO:
  DEF VAR pArchivo AS CHAR NO-UNDO.
  DEF VAR pMensaje AS LONGCHAR NO-UNDO.
  RUN alm/d-reclman-import-excel ( OUTPUT pArchivo).
  IF pArchivo > '' THEN RUN Import_Excel (INPUT pArchivo, OUTPUT pMensaje).
  IF pMensaje > '' THEN MESSAGE STRING(pMensaje) VIEW-AS ALERT-BOX WARNING.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF ITEM-1.CanDes, ITEM-1.codmat
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Import_Excel B-table-Win 
PROCEDURE Import_Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{alm/i-reclman-import-excel.i &Tabla=ITEM-1}

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
  ELSE x-Item = ITEM-1.NroItm.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      ITEM-1.NroItm = x-Item
      ITEM-1.Factor = f-Factor-1
      ITEM-1.CodCia = s-codcia
      ITEM-1.CodUnd = Almmmatg.UndStk.

  /* buscamos el precio promedio */
  FIND LAST Almstkge WHERE AlmStkge.CodCia = s-codcia
      AND AlmStkge.codmat = ITEM-1.codmat
      AND AlmStkge.Fecha <= TODAY
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almstkge THEN 
      ASSIGN
      ITEM-1.PreUni = AlmStkge.CtoUni
      ITEM-1.ImpCto = AlmStkge.CtoUni * ITEM-1.CanDes.
  ELSE ASSIGN
      ITEM-1.PreUni = 0
      ITEM-1.ImpCto = 0.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Carga-Componentes.
  RUN Totales.
  RUN Procesa-Handle IN lh_handle ('browse-2').

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Totales.

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
  RUN Totales.
  RUN Procesa-Handle IN lh_handle ('browse-2').

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
  {src/adm/template/snd-list.i "ITEM-1"}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Totales B-table-Win 
PROCEDURE Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FILL-IN-CanTot = 0.
FILL-IN-ImpTot = 0.
FOR EACH B-ITEM:
    FILL-IN-CanTot = FILL-IN-CanTot + B-ITEM.CanDes.
    FILL-IN-ImpTot = FILL-IN-ImpTot + B-ITEM.ImpCto.
END.
DISPLAY FILL-IN-CanTot FILL-IN-ImpTot WITH FRAME {&FRAME-NAME}.

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

    IF ITEM-1.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
       MESSAGE "Codigo de articulo en blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO ITEM-1.CodMat.
       RETURN "ADM-ERROR".   
    END.
    
    IF DECIMAL(ITEM-1.CanDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <= 0 THEN DO:
       MESSAGE "Cantidad debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO ITEM-1.CanDes.
       RETURN "ADM-ERROR".   
    END.
    
    FIND Almmmatg WHERE Almmmatg.CodCia = S-CodCia AND
         Almmmatg.CodMat = ITEM-1.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        MESSAGE "Articulo" ITEM-1.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
            "NO registrado" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO ITEM-1.CodMat.
        RETURN "ADM-ERROR".   
    END. 
    FIND Almmmate WHERE Almmmate.CodCia = S-CodCia AND
         Almmmate.CodAlm = S-CodAlm AND
         Almmmate.CodMat = ITEM-1.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN DO:
        MESSAGE "Articulo no está asignado al almacén " S-CodAlm VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO ITEM-1.CodMat.
        RETURN "ADM-ERROR".   
    END.
    
    FIND FIRST b-item WHERE b-item.codmat = ITEM-1.codmat:SCREEN-VALUE IN BROWSE {&browse-name}
        AND ROWID(b-item) <> ROWID(ITEM-1)
        NO-LOCK NO-ERROR.
    IF AVAIL b-item THEN DO:
        MESSAGE "Artículo ya registrado"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        APPLY "ENTRY" TO ITEM-1.CodMat.
        RETURN "ADM-ERROR".
    END.


    /* RHC 11.01.10 nueva rutina */
    DEF VAR pComprometido AS DEC.

    /*
    RUN vtagn/stock-comprometido (Almmmate.codmat, Almmmate.codalm, OUTPUT pComprometido).
    */
    RUN gn/stock-comprometido-v2.p(Almmmate.CodMat,
                                   Almmmate.CodAlm,
                                   YES,
                                   OUTPUT pComprometido).
    /* CONSISTENCIA NORMAL */
    IF DECIMAL(ITEM-1.CanDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})  > (Almmmate.stkact - pComprometido)
        THEN DO:
        MESSAGE 'NO se puede sacar mas de' (Almmmate.stkact - pComprometido)
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO ITEM-1.CanDes.
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
ASSIGN
    f-Factor-1 = ITEM-1.Factor
    s-local-new-record = 'NO'.
RUN Procesa-Handle IN lh_handle ('Disable').
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

