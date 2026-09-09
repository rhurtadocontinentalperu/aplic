&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE Detalle LIKE CcbCBult.



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
DEF SHARED VAR s-coddiv AS CHAR.
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
&Scoped-define INTERNAL-TABLES Detalle

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Detalle.CodDoc Detalle.NroDoc ~
Detalle.Bultos Detalle.NomCli 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table Detalle.CodDoc 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table Detalle
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table Detalle
&Scoped-define QUERY-STRING-br_table FOR EACH Detalle WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Detalle WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table Detalle
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Detalle


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS x-NroDoc br_table 
&Scoped-Define DISPLAYED-OBJECTS x-NroDoc 

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
DEFINE VARIABLE x-NroDoc AS CHARACTER FORMAT "X(9)":U 
     LABEL "N° Hoja de Ruta" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      Detalle SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Detalle.CodDoc COLUMN-LABEL "Nro. del Rótulo" FORMAT "x(13)":U
      Detalle.NroDoc FORMAT "X(9)":U WIDTH 10.86
      Detalle.Bultos COLUMN-LABEL "# Bulto" FORMAT "99":U
      Detalle.NomCli FORMAT "x(60)":U
  ENABLE
      Detalle.CodDoc
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 76 BY 14.81
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-NroDoc AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 2
     br_table AT ROW 2.62 COL 2
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
      TABLE: Detalle T "?" ? INTEGRAL CcbCBult
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
         HEIGHT             = 17.27
         WIDTH              = 85.86.
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
/* BROWSE-TAB br_table x-NroDoc F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.Detalle"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > Temp-Tables.Detalle.CodDoc
"CodDoc" "Nro. del Rótulo" "x(13)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.Detalle.NroDoc
"NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "10.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.Detalle.Bultos
"Bultos" "# Bulto" "99" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.Detalle.NomCli
"NomCli" ? "x(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME x-NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-NroDoc B-table-Win
ON LEAVE OF x-NroDoc IN FRAME F-Main /* N° Hoja de Ruta */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  /* verificamos la hoja de ruta */
  FIND Di-RutaC WHERE Di-Rutac.codcia = s-codcia
      AND Di-Rutac.coddiv = s-coddiv
      AND Di-Rutac.coddoc = "H/R"
      AND Di-Rutac.nrodoc = x-NroDoc:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Di-Rutac THEN DO:
      MESSAGE 'Hoja de Ruta NO registrada' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF DI-RutaC.FlgEst <> "E" THEN DO:
      MESSAGE 'Hoja de Ruta YA ha sido chequeada o no está completa aún'
          VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  /* identificación de bultso para las G/R x ventas */
  FOR EACH di-rutad OF di-rutac NO-LOCK,
      FIRST ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
      AND ccbcdocu.coddoc = di-rutad.codref
      AND ccbcdocu.nrodoc = di-rutad.nroref
      BREAK BY ccbcdocu.codped BY ccbcdocu.nroped:
      IF FIRST-OF(ccbcdocu.codped) OR FIRST-OF(ccbcdocu.nroped) THEN DO:
          FIND ccbcbult WHERE ccbcbult.codcia = s-codcia
              AND ccbcbult.coddiv = s-coddiv
              AND ccbcbult.coddoc = ccbcdocu.codped
              AND ccbcbult.nrodoc = ccbcdocu.nroped
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Ccbcbult THEN DO:
              MESSAGE 'NO han sido aún identificados los bultos para el documento:' SKIP
                  ccbcdocu.codped ccbcdocu.nroped
                  VIEW-AS ALERT-BOX WARNING.
              RETURN NO-APPLY.
          END.
      END.
  END.
  /* identificación de bultos para las G/R por transferencia */
  FOR EACH di-rutag OF di-rutac NO-LOCK:
      FIND ccbcbult WHERE ccbcbult.codcia = s-codcia
          AND ccbcbult.coddiv = s-coddiv
          AND ccbcbult.coddoc = "G/R"
          AND ccbcbult.nrodoc = STRING(di-rutag.serref, '999') +
                                  STRING(di-rutag.nroref, '999999')
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Ccbcbult THEN DO:
          MESSAGE 'NO han sido aún identificados los bultos para el documento:' SKIP
              "G/R" STRING(di-rutag.serref, '999') + STRING(di-rutag.nroref, '999999')
              VIEW-AS ALERT-BOX WARNING.
          RETURN NO-APPLY.
      END.
  END.

  {&self-name}:SENSITIVE = NO.
  ASSIGN {&self-name}.
  RUN Procesa-handle IN lh_handle ('enable-updv').
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierre B-table-Win 
PROCEDURE Cierre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-bultos AS INT.

/* revisamos que no falte nada */
FOR EACH di-rutad OF di-rutac NO-LOCK,
    FIRST ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
    AND ccbcdocu.coddoc = di-rutad.codref
    AND ccbcdocu.nrodoc = di-rutad.nroref
    BREAK BY ccbcdocu.codped BY ccbcdocu.nroped:
    IF FIRST-OF(ccbcdocu.codped) OR FIRST-OF(ccbcdocu.nroped) THEN DO:
        /* control de bultos */
        x-bultos = 0.
        FOR EACH detalle WHERE detalle.coddoc = ccbcdocu.codped
            AND detalle.nrodoc = ccbcdocu.nroped:
            x-bultos = x-bultos + 1.
        END.
        FIND ccbcbult WHERE ccbcbult.codcia = s-codcia
            AND ccbcbult.coddiv = s-coddiv
            AND ccbcbult.coddoc = ccbcdocu.codped
            AND ccbcbult.nrodoc = ccbcdocu.nroped
            NO-LOCK.
        IF ccbcbult.bultos <> x-bultos THEN DO:
            MESSAGE 'Faltan/Sobran bultos para el documento:' ccbcdocu.codped ccbcdocu.nroped
                VIEW-AS ALERT-BOX WARNING.
            RETURN.
        END.
    END.
END.
FOR EACH di-rutag OF di-rutac NO-LOCK:
    /* control de bultos */
    x-bultos = 0.
    FOR EACH detalle WHERE detalle.coddoc = "G/R"
        AND detalle.nrodoc = STRING(di-rutag.serref, '999') +
                                STRING(di-rutag.nroref, '999999'):
        x-bultos = x-bultos + 1.
    END.
    FIND ccbcbult WHERE ccbcbult.codcia = s-codcia
        AND ccbcbult.coddiv = s-coddiv
        AND ccbcbult.coddoc = "G/R"
        AND ccbcbult.nrodoc = STRING(di-rutag.serref, '999') +
                                STRING(di-rutag.nroref, '999999')
        NO-LOCK.
    IF ccbcbult.bultos <> x-bultos THEN DO:
        MESSAGE 'Faltan/Sobran bultos para el documento:' "G/R" STRING(di-rutag.serref, '999') +
                                STRING(di-rutag.nroref, '999999')
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
END.
DO TRANSACTION ON ERROR UNDO, RETURN ON STOP UNDO, RETURN:
    FIND CURRENT Di-RutaC EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Di-RutaC THEN UNDO, RETURN.
    ASSIGN
        Di-RutaC.FlgEst = "P".
    FOR EACH di-rutad OF di-rutac NO-LOCK,
        FIRST ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
        AND ccbcdocu.coddoc = di-rutad.codref
        AND ccbcdocu.nrodoc = di-rutad.nroref
        BREAK BY ccbcdocu.codped BY ccbcdocu.nroped:
        IF FIRST-OF(ccbcdocu.codped) OR FIRST-OF(ccbcdocu.nroped) THEN DO:
            FIND ccbcbult WHERE ccbcbult.codcia = s-codcia
                AND ccbcbult.coddiv = s-coddiv
                AND ccbcbult.coddoc = ccbcdocu.codped
                AND ccbcbult.nrodoc = ccbcdocu.nroped
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Ccbcbult THEN DO:
                MESSAGE 'Error el el documento:' SKIP
                    ccbcdocu.codped ccbcdocu.nroped
                    VIEW-AS ALERT-BOX ERROR.
                UNDO, RETURN.
            END.
            ASSIGN
                Ccbcbult.CHR_01 = "C".
        END.
    END.
    FOR EACH di-rutag OF di-rutac NO-LOCK:
        FIND ccbcbult WHERE ccbcbult.codcia = s-codcia
            AND ccbcbult.coddiv = s-coddiv
            AND ccbcbult.coddoc = "G/R"
            AND ccbcbult.nrodoc = STRING(di-rutag.serref, '999') +
                                    STRING(di-rutag.nroref, '999999')
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Ccbcbult THEN DO:
            MESSAGE 'Error en el documento:' SKIP
                "G/R" STRING(di-rutag.serref, '999') + STRING(di-rutag.nroref, '999999')
                VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN.
        END.
        ASSIGN
            Ccbcbult.CHR_01 = "C".
    END.
    RELEASE Ccbcbult.
    RELEASE Di-RutaC.
END.
EMPTY TEMP-TABLE Detalle.
ASSIGN
    x-NroDoc = ''
    x-NroDoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''
    x-NroDoc:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).
RUN Procesa-handle IN lh_handle ('disable-updv').
APPLY 'entry' TO x-NroDoc IN FRAME {&FRAME-NAME}.

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
  RUN Procesa-handle IN lh_handle ('disable-botones').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  DEF VAR x-Rowid AS ROWID.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      Detalle.Bultos = INTEGER (Detalle.Bultos:SCREEN-VALUE IN BROWSE {&browse-name})
      Detalle.CodCia = s-codcia
      Detalle.CodDiv = s-coddiv
      Detalle.CodDoc = Detalle.CodDoc:SCREEN-VALUE IN BROWSE {&browse-name}
      Detalle.NroDoc = Detalle.NroDoc:SCREEN-VALUE IN BROWSE {&browse-name}.

  /* veamos si está repetido */
  x-Rowid = ROWID(Detalle).
  IF CAN-FIND( Detalle WHERE Detalle.coddoc = Detalle.CodDoc:SCREEN-VALUE IN BROWSE {&browse-name}
               AND Detalle.nrodoc = Detalle.NroDoc:SCREEN-VALUE IN BROWSE {&browse-name}
               AND Detalle.bultos = INTEGER (Detalle.Bultos:SCREEN-VALUE IN BROWSE {&browse-name})
               AND ROWID(Detalle) <> x-Rowid NO-LOCK)
               THEN DO:
      MESSAGE 'Bulto YA registrado' VIEW-AS ALERT-BOX ERROR.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record B-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Procesa-handle IN lh_handle ('enable-botones').

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
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-handle IN lh_handle ('enable-botones').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Nuevo B-table-Win 
PROCEDURE Nuevo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE Detalle.
ASSIGN
    x-NroDoc = ''
    x-NroDoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''
    x-NroDoc:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).
RUN Procesa-handle IN lh_handle ('disable-updv').
APPLY 'entry' TO x-NroDoc IN FRAME {&FRAME-NAME}.

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
  {src/adm/template/snd-list.i "Detalle"}

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

    DEF VAR x-nrodoc AS CHAR.
    DEF VAR x-coddoc AS CHAR.
    DEF VAR x-Ok AS LOG.
    
    IF detalle.coddoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '' 
        OR LENGTH(detalle.coddoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <> 13 THEN DO:
        MESSAGE 'Dato en blanco o mal registrado' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.

    x-nrodoc = detalle.coddoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
    CASE SUBSTRING(x-nrodoc,1,2):
        WHEN '01' THEN x-coddoc = 'PED'.
        WHEN '02' THEN x-coddoc = 'P/M'.
        WHEN '03' THEN x-coddoc = 'G/R'.
    END CASE.
    DISPLAY
        x-coddoc @ detalle.coddoc
        SUBSTRING(x-nrodoc,3,9) @ detalle.nrodoc
        SUBSTRING(x-nrodoc,12,2) @ detalle.bultos
        WITH BROWSE {&browse-name}.
    FIND ccbcbult WHERE ccbcbult.codcia = s-codcia
        AND ccbcbult.coddiv = s-coddiv
        AND ccbcbult.coddoc = x-coddoc
        AND ccbcbult.nrodoc = SUBSTRING(x-nrodoc,3,9)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ccbcbult THEN DO:
        MESSAGE 'Bulto NO registrado' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    /* cruzamos contra la H/R */
    CASE x-coddoc:
        WHEN 'G/R' THEN DO:
            FIND Di-RutaG OF Di-RutaC WHERE Di-RutaG.serref = INTEGER(SUBSTRING(x-nrodoc,3,3))
                AND Di-RutaG.nroref = INTEGER(SUBSTRING(x-nrodoc,6,6))
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Di-RutaG THEN DO:
                MESSAGE 'NO registrado el la Hoja de Ruta'
                    VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
            END.
        END.
        OTHERWISE DO:
            x-Ok = NO.
            FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
                FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
                AND Ccbcdocu.coddoc = Di-RutaD.codref
                AND Ccbcdocu.nrodoc = Di-RutaD.nroref:
                IF Ccbcdocu.codped = x-coddoc AND Ccbcdocu.nroped = SUBSTRING(x-nrodoc,3,9) 
                    THEN DO:
                    x-Ok = YES.
                    LEAVE.
                END.
            END.
            IF x-Ok = NO THEN DO:
                MESSAGE 'Pedido NO registrado en la Hoja de Ruta'
                    VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
            END.
        END.
    END CASE.

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
RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

