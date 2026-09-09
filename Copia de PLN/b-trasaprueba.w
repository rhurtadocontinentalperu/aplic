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

DEFINE SHARED VAR s-codcia   AS INT.
DEFINE SHARED VAR s-user-id  AS CHAR.
DEFINE SHARED VAR s-periodo  AS INT.
DEFINE SHARED VAR s-nromes   AS INT.


DEFINE VARIABLE cNomPer AS CHAR   NO-UNDO.
DEFINE VARIABLE cAreDes AS CHAR   NO-UNDO.

DEFINE BUFFER b-tabperarea FOR tabperarea.

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
&Scoped-define INTERNAL-TABLES TabPerArea PL-PERS PL-MOV-MES

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table TabPerArea.CodPer ~
PL-PERS.patper + ' ' + PL-PERS.matper + ', ' + PL-PERS.nomper @ cNomPer ~
TabPerArea.FchIng TabPerArea.FlgEst TabPerArea.Usr_Solicita ~
TabPerArea.FchDoc_Solicita TabPerArea.Libre_c01 TabPerArea.Libre_c02 ~
PL-MOV-MES.valcal-mes 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH TabPerArea WHERE ~{&KEY-PHRASE} ~
      AND TabPerArea.CodCia = s-codcia ~
 /*AND TabPerArea.CodArea = substring(cb-areas,1,3)*/ ~
 AND TabPerArea.FlgEst BEGINS rs-FlgEst ~
 AND TabPerArea.FlgEst <> "A" NO-LOCK, ~
      EACH PL-PERS WHERE PL-PERS.CodCia = TabPerArea.CodCia ~
  AND PL-PERS.codper = TabPerArea.CodPer NO-LOCK, ~
      EACH PL-MOV-MES WHERE PL-MOV-MES.CodCia = PL-PERS.CodCia ~
  AND PL-MOV-MES.codper = PL-PERS.codper ~
      AND PL-MOV-MES.codpln = 001 ~
 AND PL-MOV-MES.NroMes = s-nromes ~
 AND PL-MOV-MES.Periodo = s-periodo ~
 AND PL-MOV-MES.codcal = 0 ~
 AND PL-MOV-MES.CodMov = 101 NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH TabPerArea WHERE ~{&KEY-PHRASE} ~
      AND TabPerArea.CodCia = s-codcia ~
 /*AND TabPerArea.CodArea = substring(cb-areas,1,3)*/ ~
 AND TabPerArea.FlgEst BEGINS rs-FlgEst ~
 AND TabPerArea.FlgEst <> "A" NO-LOCK, ~
      EACH PL-PERS WHERE PL-PERS.CodCia = TabPerArea.CodCia ~
  AND PL-PERS.codper = TabPerArea.CodPer NO-LOCK, ~
      EACH PL-MOV-MES WHERE PL-MOV-MES.CodCia = PL-PERS.CodCia ~
  AND PL-MOV-MES.codper = PL-PERS.codper ~
      AND PL-MOV-MES.codpln = 001 ~
 AND PL-MOV-MES.NroMes = s-nromes ~
 AND PL-MOV-MES.Periodo = s-periodo ~
 AND PL-MOV-MES.codcal = 0 ~
 AND PL-MOV-MES.CodMov = 101 NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table TabPerArea PL-PERS PL-MOV-MES
&Scoped-define FIRST-TABLE-IN-QUERY-br_table TabPerArea
&Scoped-define SECOND-TABLE-IN-QUERY-br_table PL-PERS
&Scoped-define THIRD-TABLE-IN-QUERY-br_table PL-MOV-MES


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rs-FlgEst br_table 
&Scoped-Define DISPLAYED-OBJECTS rs-FlgEst 

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
       MENU-ITEM m_Cancelar_Traslado LABEL "Cancelar Transferencia".


/* Definitions of the field level widgets                               */
DEFINE VARIABLE rs-FlgEst AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", "",
"Traslado Personal", "T",
"Cambio de Cargo", "P",
"Cese Personal", "C"
     SIZE 92 BY 1.12
     BGCOLOR 8  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      TabPerArea, 
      PL-PERS, 
      PL-MOV-MES SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      TabPerArea.CodPer FORMAT "X(6)":U WIDTH 8
      PL-PERS.patper + ' ' + PL-PERS.matper + ', ' + PL-PERS.nomper @ cNomPer COLUMN-LABEL "Apellidos y Nombres" FORMAT "X(40)":U
            WIDTH 35
      TabPerArea.FchIng COLUMN-LABEL "Fecha Ingreso" FORMAT "99/99/9999":U
      TabPerArea.FlgEst COLUMN-LABEL "Estado" FORMAT "x(3)":U
      TabPerArea.Usr_Solicita FORMAT "x(8)":U WIDTH 11
      TabPerArea.FchDoc_Solicita FORMAT "99/99/9999 HH:MM:SS":U
      TabPerArea.Libre_c01 COLUMN-LABEL "Detalle" FORMAT "x(40)":U
            WIDTH 35
      TabPerArea.Libre_c02 COLUMN-LABEL "Observaciones" FORMAT "x(40)":U
            WIDTH 35
      PL-MOV-MES.valcal-mes COLUMN-LABEL "Sueldo Basico" FORMAT "ZZZZ,ZZ9.99":U
            WIDTH 12
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 161 BY 17.62
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     rs-FlgEst AT ROW 1.54 COL 2.57 NO-LABEL WIDGET-ID 2
     br_table AT ROW 3.04 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1 WIDGET-ID 100.


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
         HEIGHT             = 20
         WIDTH              = 163.14.
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
/* BROWSE-TAB br_table rs-FlgEst F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-br_table:HANDLE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.TabPerArea,INTEGRAL.PL-PERS WHERE INTEGRAL.TabPerArea ...,INTEGRAL.PL-MOV-MES WHERE INTEGRAL.PL-PERS ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "TabPerArea.CodCia = s-codcia
 /*AND TabPerArea.CodArea = substring(cb-areas,1,3)*/
 AND TabPerArea.FlgEst BEGINS rs-FlgEst
 AND TabPerArea.FlgEst <> ""A"""
     _JoinCode[2]      = "PL-PERS.CodCia = TabPerArea.CodCia
  AND PL-PERS.codper = TabPerArea.CodPer"
     _JoinCode[3]      = "PL-MOV-MES.CodCia = PL-PERS.CodCia
  AND PL-MOV-MES.codper = PL-PERS.codper"
     _Where[3]         = "PL-MOV-MES.codpln = 001
 AND PL-MOV-MES.NroMes = s-nromes
 AND PL-MOV-MES.Periodo = s-periodo
 AND PL-MOV-MES.codcal = 0
 AND PL-MOV-MES.CodMov = 101"
     _FldNameList[1]   > INTEGRAL.TabPerArea.CodPer
"TabPerArea.CodPer" ? ? "character" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"PL-PERS.patper + ' ' + PL-PERS.matper + ', ' + PL-PERS.nomper @ cNomPer" "Apellidos y Nombres" "X(40)" ? ? ? ? ? ? ? no ? no no "35" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.TabPerArea.FchIng
"TabPerArea.FchIng" "Fecha Ingreso" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.TabPerArea.FlgEst
"TabPerArea.FlgEst" "Estado" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.TabPerArea.Usr_Solicita
"TabPerArea.Usr_Solicita" ? ? "character" ? ? ? ? ? ? no ? no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = INTEGRAL.TabPerArea.FchDoc_Solicita
     _FldNameList[7]   > INTEGRAL.TabPerArea.Libre_c01
"TabPerArea.Libre_c01" "Detalle" "x(40)" "character" ? ? ? ? ? ? no ? no no "35" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.TabPerArea.Libre_c02
"TabPerArea.Libre_c02" "Observaciones" "x(40)" "character" ? ? ? ? ? ? no ? no no "35" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.PL-MOV-MES.valcal-mes
"PL-MOV-MES.valcal-mes" "Sueldo Basico" ? "decimal" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME rs-FlgEst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-FlgEst B-table-Win
ON VALUE-CHANGED OF rs-FlgEst IN FRAME F-Main
DO:
  
    ASSIGN rs-flgest.
    RUN adm-open-query.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aprueba_Rechaza_Trans B-table-Win 
PROCEDURE Aprueba_Rechaza_Trans :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pTipo AS LOG NO-UNDO.

    FIND FIRST b-tabperarea WHERE ROWID(b-tabperarea) = ROWID(tabperarea)
        NO-ERROR.
    IF AVAIL b-tabperarea THEN DO:
        IF NOT pTipo THEN 
            ASSIGN 
                b-TabPerArea.FlgEst       = 'A' 
                b-TabPerArea.Libre_c02    = b-TabPerArea.Libre_c01 + ' RECHAZADO'
                b-TabPerArea.Libre_c01    = ''                
                b-TabPerArea.Area_Destino = ''
                b-TabPerArea.FchDoc_Solicita = DATETIME(TODAY,MTIME)
                b-TabPerArea.Usr_Solicita    = s-user-id. 
        ELSE DO:

            IF TabPerArea.FlgEst = "C" THEN b-TabPerArea.FlgEst = ''.
            LEAVE.

            /*Busca Tabla Personal*/            
            FIND FIRST pl-flg-mes WHERE pl-flg-mes.codcia = s-codcia
                AND pl-flg-mes.periodo = s-periodo
                AND pl-flg-mes.nromes  = s-nromes
                AND pl-flg-mes.codper  = TabPerArea.CodPer NO-ERROR.
            IF AVAIL pl-flg-mes THEN ASSIGN pl-flg-mes.campo-c[5] = TabPerArea.Area_Destino.
            ELSE DO:
                MESSAGE 'Personal no encontrado para:' SKIP
                        'Periodo = ' + STRING(s-periodo,'9999') SKIP
                        'Mes     = ' + STRING(s-nromes,'99')
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.

            /****Genera Salida****/
            CREATE TabMovTras.
            ASSIGN
                TabMovTras.CodCia          = s-codcia
                TabMovTras.CodArea         = TabPerArea.CodArea
                /*TabMovTras.CodArea       = SUBSTRING(cb-areas,1,3)*/
                TabMovTras.Area_Destino    = TabPerArea.Area_Destino
                TabMovTras.Area_Origen     = TabPerArea.CodArea            
                TabMovTras.CodPer          = TabPerArea.CodPer
                TabMovTras.FchDoc_Aprueba  = DATETIME(TODAY,MTIME)
                TabMovTras.FchDoc_Solicita = TabPerArea.FchDoc_Solicita
                TabMovTras.TipMov          = 'ST'
                TabMovTras.Usr_Aprueba     = s-user-id
                TabMovTras.Usr_Solicita    = TabPerArea.Usr_Solicita.
            /*****************************/
            RELEASE TabMovTras.

            /****Genera Ingreso****/
            CREATE TabMovTras.
            ASSIGN
                TabMovTras.CodCia       = s-codcia
                TabMovTras.CodArea      = TabPerArea.Area_Destino
                TabMovTras.Area_Destino = TabPerArea.Area_Destino
                TabMovTras.Area_Origen  = TabPerArea.CodArea            
                TabMovTras.CodPer       = TabPerArea.CodPer
                TabMovTras.FchDoc_Aprueba  = DATETIME(TODAY,MTIME)
                TabMovTras.FchDoc_Solicita = TabPerArea.FchDoc_Solicita
                TabMovTras.TipMov          = 'IT'
                TabMovTras.Usr_Aprueba     = s-user-id
                TabMovTras.Usr_Solicita    = TabPerArea.Usr_Solicita.
            /*****************************/

            ASSIGN
                b-TabPerArea.CodArea         = SUBSTRING(TabPerArea.Area_Destino,1,3)
                b-TabPerArea.Libre_c01       = ''
                b-TabPerArea.Libre_c02       = ''
                b-TabPerArea.Area_Destino    = ''
                b-TabPerArea.FchDoc_Solicita = ?
                b-TabPerArea.Usr_Solicita    = ''
                b-TabPerArea.FlgEst          = 'A'.
            /*
            IF b-TabPerArea.FlgEst = 'X' THEN b-TabPerArea.FlgEst = ''.
            ELSE b-TabPerArea.FlgEst = 'A'.
            */
        END.
    END.
    RUN adm-open-query.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
/*   DO WITH FRAME {&FRAME-NAME}:                                                      */
/*       FOR EACH TabArea WHERE TabArea.CodCia = s-codcia NO-LOCK:                     */
/*           cb-areas:ADD-LAST(STRING(TabArea.CodArea,'999') + "-" + TabArea.DesArea). */
/*       END.                                                                          */
/*   END.                                                                              */

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
  {src/adm/template/snd-list.i "TabPerArea"}
  {src/adm/template/snd-list.i "PL-PERS"}
  {src/adm/template/snd-list.i "PL-MOV-MES"}

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

