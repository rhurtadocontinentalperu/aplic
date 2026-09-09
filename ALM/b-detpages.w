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

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-codpro AS CHAR.
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE VARIABLE iNroSec AS INT.

DEFINE BUFFER b-almcatvtad FOR almcatvtad.
DEFINE TEMP-TABLE tt-detalle LIKE almcatvtad.

DEFINE VAR x-nrosec AS INT NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES AlmCatVtaC
&Scoped-define FIRST-EXTERNAL-TABLE AlmCatVtaC


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR AlmCatVtaC.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES AlmCatVtaD

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table AlmCatVtaD.NroSec AlmCatVtaD.codmat ~
AlmCatVtaD.DesMat AlmCatVtaD.Libre_c01 AlmCatVtaD.FlgQui 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table AlmCatVtaD.codmat ~
AlmCatVtaD.FlgQui 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table AlmCatVtaD
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table AlmCatVtaD
&Scoped-define QUERY-STRING-br_table FOR EACH AlmCatVtaD WHERE AlmCatVtaD.CodCia = AlmCatVtaC.CodCia ~
  AND AlmCatVtaD.CodDiv = s-CodDiv ~
  AND AlmCatVtaD.CodPro = AlmCatVtaC.CodPro ~
  AND AlmCatVtaD.NroPag = AlmCatVtaC.NroPag NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH AlmCatVtaD WHERE AlmCatVtaD.CodCia = AlmCatVtaC.CodCia ~
  AND AlmCatVtaD.CodDiv = s-CodDiv ~
  AND AlmCatVtaD.CodPro = AlmCatVtaC.CodPro ~
  AND AlmCatVtaD.NroPag = AlmCatVtaC.NroPag NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table AlmCatVtaD
&Scoped-define FIRST-TABLE-IN-QUERY-br_table AlmCatVtaD


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-61 br_table BUTTON-3 

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
       MENU-ITEM m_Asigna_Secuencia LABEL "Asigna Secuencia".


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/aplic.ico":U
     LABEL "Button 3" 
     SIZE 6.43 BY 1.62.

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 10.62.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      AlmCatVtaD SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      AlmCatVtaD.NroSec COLUMN-LABEL "Sec" FORMAT "9999":U WIDTH 6
      AlmCatVtaD.codmat COLUMN-LABEL "Codigo" FORMAT "X(6)":U WIDTH 9
      AlmCatVtaD.DesMat FORMAT "X(55)":U
      AlmCatVtaD.Libre_c01 COLUMN-LABEL "Unid" FORMAT "x(10)":U
      AlmCatVtaD.FlgQui COLUMN-LABEL "Est" FORMAT "x(3)":U
  ENABLE
      AlmCatVtaD.codmat
      AlmCatVtaD.FlgQui
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 73.57 BY 10.15
         FONT 4
         TITLE "Lista de Artículos".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.35 COL 2.43
     BUTTON-3 AT ROW 5.85 COL 79 WIDGET-ID 12
     "Actualiza" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 3.15 COL 78 WIDGET-ID 6
     "Número" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 3.96 COL 78.43 WIDGET-ID 8
     "de Secuencia" VIEW-AS TEXT
          SIZE 12 BY .62 AT ROW 4.77 COL 76 WIDGET-ID 10
     RECT-61 AT ROW 1.08 COL 1.43 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.AlmCatVtaC
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
         HEIGHT             = 10.81
         WIDTH              = 90.
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
/* BROWSE-TAB br_table RECT-61 F-Main */
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
     _TblList          = "INTEGRAL.AlmCatVtaD WHERE INTEGRAL.AlmCatVtaC <external> ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _JoinCode[1]      = "AlmCatVtaD.CodCia = AlmCatVtaC.CodCia
  AND AlmCatVtaD.CodDiv = s-CodDiv
  AND AlmCatVtaD.CodPro = AlmCatVtaC.CodPro
  AND AlmCatVtaD.NroPag = AlmCatVtaC.NroPag"
     _FldNameList[1]   > INTEGRAL.AlmCatVtaD.NroSec
"AlmCatVtaD.NroSec" "Sec" ? "integer" ? ? ? ? ? ? no ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.AlmCatVtaD.codmat
"AlmCatVtaD.codmat" "Codigo" ? "character" ? ? ? ? ? ? yes ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.AlmCatVtaD.DesMat
"AlmCatVtaD.DesMat" ? "X(55)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.AlmCatVtaD.Libre_c01
"AlmCatVtaD.Libre_c01" "Unid" "x(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.AlmCatVtaD.FlgQui
"AlmCatVtaD.FlgQui" "Est" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* Lista de Artículos */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* Lista de Artículos */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* Lista de Artículos */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME AlmCatVtaD.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL AlmCatVtaD.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF AlmCatVtaD.codmat IN BROWSE br_table /* Codigo */
DO:
    DO WITH FRAME {&FRAME-NAME}:
        IF SELF:SCREEN-VALUE = "" THEN RETURN.
        IF LENGTH(SELF:SCREEN-VALUE) <= 6 THEN DO: 
            ASSIGN
                SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999")
                NO-ERROR.
        END.
        FIND almmmatg WHERE almmmatg.codcia = s-codcia
            AND almmmatg.codmat = almcatvtad.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-name}
            NO-LOCK NO-ERROR.
        IF AVAIL almmmatg THEN DO: 
            DISPLAY almmmatg.desmat @ almcatvtad.desmat
                WITH BROWSE {&BROWSE-NAME}.
        END.
        ELSE DO:
            MESSAGE 'Articulo no registrado'
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            APPLY 'ENTRY' TO AlmCatVtaD.CodMat.
            RETURN NO-APPLY.
        END.            
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 B-table-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
     RUN Actualiza-Secuencia.
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Asigna_Secuencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Asigna_Secuencia B-table-Win
ON CHOOSE OF MENU-ITEM m_Asigna_Secuencia /* Asigna Secuencia */
DO:
    RUN vtaexp\i-nrosec(OUTPUT x-nrosec).    
    FIND FIRST b-almcatvtad 
        WHERE ROWID(b-almcatvtad) = ROWID(almcatvtad) NO-ERROR.
    IF AVAIL b-almcatvtad THEN DO:
        
        IF /*b-almcatvtad.nrosec = (x-nrosec - 1) 
            OR*/ b-almcatvtad.nrosec < x-nrosec THEN
            ASSIGN b-almcatvtad.libre_d04 = (x-nrosec * 10) + 5.
        ELSE ASSIGN b-almcatvtad.libre_d04 = (x-nrosec - 1) * 10 + 5.        
        
    END.     
    RUN Actualiza-Secuencia.    
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON RETURN OF almcatvtad.codmat, almcatvtad.desmat, almcatvtad.flgqui DO:
    APPLY 'TAB'.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Secuencia B-table-Win 
PROCEDURE Actualiza-Secuencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE iint AS INTEGER INIT 0 NO-UNDO.
    
    FOR EACH tt-detalle :
        DELETE tt-detalle.
    END.

    FOR EACH almcatvtad NO-LOCK WHERE almcatvtad.codcia = s-codcia
        AND almcatvtad.coddiv = s-coddiv
        AND almcatvtad.codpro = s-codpro
        AND almcatvtad.nropag = almcatvtac.nropag
        BREAK BY almcatvtad.libre_d04 :
        iint = iint + 1.
        FIND FIRST tt-detalle WHERE tt-detalle.codcia = almcatvtad.codcia
            AND tt-detalle.coddiv = almcatvtad.coddiv
            AND tt-detalle.codpro = almcatvtad.codpro
            AND tt-detalle.nropag = almcatvtad.nropag 
            AND tt-detalle.codmat = almcatvtad.codmat NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-detalle THEN DO:
            CREATE tt-detalle.
            BUFFER-COPY almcatvtad TO tt-detalle.
            ASSIGN 
                tt-detalle.nrosec = iint.
        END.
    END.

    FOR EACH almcatvtad WHERE almcatvtad.codcia = s-codcia
        AND almcatvtad.coddiv = s-coddiv
        AND almcatvtad.codpro = s-codpro
        AND almcatvtad.nropag = almcatvtac.nropag EXCLUSIVE-LOCK:
        DELETE almcatvtad.
    END.

    FOR EACH tt-detalle.
        CREATE almcatvtad.
        BUFFER-COPY tt-detalle TO almcatvtad
            ASSIGN almcatvtad.libre_d04 = almcatvtad.nrosec * 10.
    END. 

    RUN adm-open-query.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  {src/adm/template/row-list.i "AlmCatVtaC"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "AlmCatVtaC"}

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
 

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record B-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  DEFINE VARIABLE cDesMat AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cUndVta AS CHARACTER   NO-UNDO.
  DO WITH FRAME {&FRAME-NAME}:
      FIND LAST almcatvtad WHERE almcatvtad.codcia = s-codcia
          AND almcatvtad.codpro = almcatvtac.codpro
          AND almcatvtad.coddiv = s-coddiv
          AND almcatvtad.nropag = almcatvtac.nropag NO-ERROR.
      IF AVAIL almcatvtad THEN iNroSec = almcatvtad.nrosec + 1.
      ELSE iNroSec = 1.  

      FIND almmmatg WHERE almmmatg.codcia = s-codcia
          AND almmmatg.codmat = almcatvtad.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
          NO-LOCK NO-ERROR.
      IF AVAIL almmmatg THEN 
          ASSIGN 
            cDesMat = almmmatg.desmat
            cUndVta = almmmatg.undbas.
      ELSE 
          ASSIGN 
              cDesMat = ""
              cUndVta = ''.
  END.  

  /* Code placed here will execute AFTER standard behavior.    */

  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  
  IF RETURN-VALUE = 'YES' THEN DO:
      /* Dispatch standard ADM method.                             */
      RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
      ASSIGN 
          almcatvtad.codcia = almcatvtac.codcia
          almcatvtad.codpro = almcatvtac.codpro
          almcatvtad.nropag = almcatvtac.nropag
          almcatvtad.nrosec = iNroSec
          almcatvtad.coddiv = almcatvtac.coddiv
          almcatvtad.desmat = cDesMat
          almcatvtad.libre_c01 = cUndVta
    /**/  almcatvtad.libre_d04 = iNroSec * 10.
      IF almcatvtad.codmat = '' THEN almcatvtad.codmat = almcatvtad.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-name}.
  END.
  ELSE DO:
      FIND FIRST b-almcatvtad WHERE b-almcatvtad.codcia = s-codcia
          AND b-almcatvtad.coddiv = almcatvtad.coddiv
          AND b-almcatvtad.codpro = almcatvtad.codpro
          AND b-almcatvtad.codmat = almcatvtad.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-name} NO-ERROR.
      IF AVAIL b-almcatvtad THEN ASSIGN b-almcatvtad.flgqui = almcatvtad.flgqui:SCREEN-VALUE IN BROWSE {&BROWSE-name}.              
  END.

  RUN adm-open-query.
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
   /***
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      AlmCatVtaD.NroSec:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO.
      AlmCatVtaD.CodMat:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO.
      APPLY 'ENTRY':U TO AlmCatVtaD.CodMat.
  END.
  ELSE DO:
      AlmCatVtaD.NroSec:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.
      AlmCatVtaD.CodMat:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.
      APPLY 'ENTRY':U TO AlmCatVtaD.CodMat.
  END.
***/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-changed B-table-Win 
PROCEDURE local-row-changed :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-changed':U ) .
  APPLY 'value-changed' TO {&browse-name} IN FRAME {&FRAME-NAME}.

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
  {src/adm/template/snd-list.i "AlmCatVtaC"}
  {src/adm/template/snd-list.i "AlmCatVtaD"}

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
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' THEN DO WITH FRAME {&FRAME-NAME}:
        FIND FIRST b-almcatvtad WHERE b-almcatvtad.codcia = almcatvtac.codcia
            /*AND b-almcatvtad.codpro = almcatvtac.codpro*/
            AND b-almcatvtad.coddiv = almcatvtac.coddiv
            /*AND b-almcatvtad.nropag = almcatvtac.nropag*/
            AND b-almcatvtad.codmat = almcatvtad.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
            NO-LOCK NO-ERROR.
        IF AVAIL b-almcatvtad THEN DO:
            MESSAGE "Artículo Repetido con el proveedor " + almcatvtac.codpro SKIP
                    "         en la página " + STRING(b-almcatvtad.nropag,"9999")
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            APPLY 'ENTRY' TO almcatvtad.codmat.
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

