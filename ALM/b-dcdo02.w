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

DEFINE SHARED VAR s-codcia  AS INT.
DEFINE SHARED VAR s-codalm  AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.
DEFINE SHARED VAR s-coddiv  AS CHAR.

DEF BUFFER B-DCDOC FOR CntDocum.

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
&Scoped-define INTERNAL-TABLES CntDocum

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CntDocum.CodDoc CntDocum.NroDoc ~
CntDocum.NomCli CntDocum.NroBul CntDocum.Observac CntDocum.FchDoc ~
CntDocum.TipMov 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table CntDocum.CodDoc ~
CntDocum.NroDoc CntDocum.NroBul CntDocum.Observac 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table CntDocum
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table CntDocum
&Scoped-define QUERY-STRING-br_table FOR EACH CntDocum WHERE ~{&KEY-PHRASE} ~
      AND CntDocum.CodCia = s-codcia ~
  AND CntDocum.CodDiv = s-coddiv ~
    AND date(CntDocum.FchDoc) = today ~
      AND CntDocum.TipMov = "S" NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH CntDocum WHERE ~{&KEY-PHRASE} ~
      AND CntDocum.CodCia = s-codcia ~
  AND CntDocum.CodDiv = s-coddiv ~
    AND date(CntDocum.FchDoc) = today ~
      AND CntDocum.TipMov = "S" NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table CntDocum
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CntDocum


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 
&Scoped-Define DISPLAYED-OBJECTS x-coddiv x-desdiv x-fecha x-user 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fOriDoc B-table-Win 
FUNCTION fOriDoc RETURNS CHARACTER
  ( INPUT cCodDoc AS CHAR,
    INPUT cNroDoc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fValSal B-table-Win 
FUNCTION fValSal RETURNS LOGICAL
  ( INPUT cCodDoc AS CHAR,
    INPUT cNroDoc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE x-coddiv AS CHARACTER FORMAT "X(5)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .85 NO-UNDO.

DEFINE VARIABLE x-desdiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51.86 BY .85
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-fecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-user AS CHARACTER FORMAT "X(256)":U 
     LABEL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .85 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      CntDocum SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      CntDocum.CodDoc FORMAT "x(11)":U
      CntDocum.NroDoc FORMAT "X(9)":U WIDTH 10
      CntDocum.NomCli COLUMN-LABEL "Cliente" FORMAT "x(50)":U
      CntDocum.NroBul COLUMN-LABEL "Bultos" FORMAT "->,>>>,>>9":U
      CntDocum.Observac COLUMN-LABEL "Observaciones" FORMAT "x(30)":U
      CntDocum.FchDoc COLUMN-LABEL "Fecha y Hora" FORMAT "99/99/9999 HH:MM:SS.SSS":U
      CntDocum.TipMov FORMAT "x(1)":U
  ENABLE
      CntDocum.CodDoc
      CntDocum.NroDoc
      CntDocum.NroBul
      CntDocum.Observac
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 113.86 BY 17.23
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-coddiv AT ROW 1.27 COL 9 COLON-ALIGNED WIDGET-ID 10
     x-desdiv AT ROW 1.27 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     x-fecha AT ROW 1.31 COL 79 COLON-ALIGNED WIDGET-ID 8
     x-user AT ROW 2.35 COL 9 COLON-ALIGNED WIDGET-ID 2
     br_table AT ROW 3.73 COL 2.14
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
         HEIGHT             = 20.42
         WIDTH              = 118.29.
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
/* BROWSE-TAB br_table x-user F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN x-coddiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-desdiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-fecha IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-user IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.CntDocum"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "CntDocum.CodCia = s-codcia
  AND CntDocum.CodDiv = s-coddiv
    AND date(CntDocum.FchDoc) = today
      AND CntDocum.TipMov = ""S"""
     _FldNameList[1]   > INTEGRAL.CntDocum.CodDoc
"CntDocum.CodDoc" ? "x(11)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.CntDocum.NroDoc
"CntDocum.NroDoc" ? ? "character" ? ? ? ? ? ? yes ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.CntDocum.NomCli
"CntDocum.NomCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.CntDocum.NroBul
"CntDocum.NroBul" "Bultos" ? "integer" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.CntDocum.Observac
"CntDocum.Observac" "Observaciones" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.CntDocum.FchDoc
"CntDocum.FchDoc" "Fecha y Hora" ? "datetime" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = INTEGRAL.CntDocum.TipMov
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


&Scoped-define SELF-NAME CntDocum.CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CntDocum.CodDoc br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF CntDocum.CodDoc IN BROWSE br_table /* Codigo */
DO:

    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    CASE SUBSTRING(SELF:SCREEN-VALUE,1,1):
        WHEN '1' THEN DO:           /* FACTURA */
            ASSIGN
                CntDocum.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = SUBSTRING(SELF:SCREEN-VALUE,2,3) +
                                                                        SUBSTRING(SELF:SCREEN-VALUE,6,6)
                SELF:SCREEN-VALUE = 'FAC'.
        END.
        WHEN '9' THEN DO:           /* G/R */
            ASSIGN
                CntDocum.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = SUBSTRING(SELF:SCREEN-VALUE,2,3) +
                                                                        SUBSTRING(SELF:SCREEN-VALUE,6,6)
                SELF:SCREEN-VALUE = 'G/R'.
        END.
        WHEN '3' THEN DO:           /* BOL */
            ASSIGN
                CntDocum.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = SUBSTRING(SELF:SCREEN-VALUE,2,3) +
                                                                        SUBSTRING(SELF:SCREEN-VALUE,6,6)
                SELF:SCREEN-VALUE = 'BOL'.
        END.
  END CASE.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CntDocum.NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CntDocum.NroDoc br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF CntDocum.NroDoc IN BROWSE br_table /* Numero */
DO:

    DEFINE VARIABLE x-Ok AS LOG INIT NO NO-UNDO.

    IF LOOKUP(CntDocum.coddoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},'FAC,BOL,G/R') > 0 THEN DO:
        FIND CcbCDocu WHERE ccbcdocu.codcia = s-codcia
            AND ccbcdocu.coddoc = CntDocum.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
            AND ccbcdocu.nrodoc = CntDocum.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
            NO-LOCK NO-ERROR.
        IF AVAILABLE ccbcdocu THEN DO:
            DISPLAY ccbcdocu.nomcli @ cntdocum.nomcli WITH BROWSE {&BROWSE-NAME}.                        
            x-Ok = YES.
        END.                    
    END.

    IF NOT x-ok THEN DO:
        RASTREA:
        FOR EACH AlmTMovm WHERE almtmovm.codcia = s-codcia
            AND almtmovm.tipmov = 'S'
            AND almtmovm.reqguia = YES
            AND almtmovm.movtrf  = YES NO-LOCK:
            FOR EACH Almacen WHERE Almacen.codcia = s-codcia NO-LOCK:
                FIND Almcmov WHERE almcmov.codcia = s-codcia
                    AND almcmov.codalm = almacen.codalm
                        AND almcmov.tipmov = almtmovm.tipmov
                        AND almcmov.codmov = almtmovm.codmov
                        AND almcmov.flgest <> 'A'
                        AND almcmov.nroser = INTEGER(SUBSTRING(CntDocum.nrodoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},1,3))
                        AND almcmov.nrodoc = INTEGER(SUBSTRING(CntDocum.nrodoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},4))
                        NO-LOCK NO-ERROR.
                IF AVAILABLE Almcmov THEN DO:
                    DISPLAY almcmov.nomref @ cntdocum.nomcli WITH BROWSE {&BROWSE-NAME}. 
                    IF cntdocum.nomcli:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '' 
                        THEN DISPLAY Almacen.Descripcion @ cntdocum.nomcli WITH BROWSE {&BROWSE-NAME}.                         
                    LEAVE RASTREA.

                END.
            END.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CntDocum.Observac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CntDocum.Observac br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF CntDocum.Observac IN BROWSE br_table /* Observaciones */
DO:
    DISPLAY  DATETIME(TODAY,MTIME) @ cntdocum.fchdoc  
        WITH BROWSE {&BROWSE-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON RETURN OF cntdocum.coddoc, cntdocum.nrodoc, CntDocum.NroBul, CntDocum.Observac DO:
    APPLY 'TAB'.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record B-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE cNomCli AS CHARACTER   NO-UNDO.
  cNomCli = CntDocum.nomcli:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
  IF fValSal(CntDocum.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}, CntDocum.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = FALSE THEN DO: 
      MESSAGE '¡¡NO PUEDE REGISTRAR SALIDA PARA ESTE DOCUMENTO¡¡' SKIP  
              '    Documento no registra ingresos o no pertenece  ' SKIP
              '     a la misma division de la cual fue generada.  '                           
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      APPLY 'ENTRY' TO CntDocum.NroDoc.
      RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  ASSIGN 
      CntDocum.CodCia  = s-codcia
      CntDocum.CodDiv  = s-coddiv
      CntDocum.FchDoc  = DATETIME(TODAY,MTIME)
      CntDocum.NomCli  = cNomCli
      CntDocum.TipMov  = 'S'
      CntDocum.usuario = s-user-id.
  
  IF fOriDoc(CntDocum.CodDoc, CntDocum.NroDoc) <> '' THEN CntDocum.OriDoc  = fOriDoc(CntDocum.CodDoc, CntDocum.NroDoc).
  CASE cntdocum.coddoc:
      WHEN 'FAC' OR WHEN 'BOL' OR WHEN 'G/R' THEN DO:
          FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = cntdocum.codcia
              AND ccbcdocu.coddoc = cntdocum.coddoc
              AND ccbcdocu.nrodoc = cntdocum.nrodoc NO-LOCK NO-ERROR.
          IF AVAILABLE ccbcdocu THEN DO: 
              cntdocum.codcli = ccbcdocu.codcli.          
          END.
          ELSE IF cntdocum.codcli = '' THEN DO:          
              RASTREO:
              FOR EACH AlmTMovm WHERE almtmovm.codcia = s-codcia
                  AND almtmovm.tipmov  = 'S'
                  AND almtmovm.reqguia = YES
                  AND almtmovm.movtrf  = YES NO-LOCK:
                  FOR EACH Almacen WHERE Almacen.codcia = s-codcia NO-LOCK:
                      FIND Almcmov WHERE almcmov.codcia = s-codcia
                          AND almcmov.codalm = almacen.codalm
                          AND almcmov.tipmov = almtmovm.tipmov
                          AND almcmov.codmov = almtmovm.codmov
                          AND almcmov.flgest <> 'A'
                          AND almcmov.nroser = INTEGER(SUBSTRING(cntdocum.nrodoc,1,3))
                          AND almcmov.nrodoc = INTEGER(SUBSTRING(cntdocum.nrodoc,4))
                          NO-LOCK NO-ERROR.
                      IF AVAILABLE Almcmov THEN DO:
                          cntdocum.codcli = almcmov.codcli.
                          LEAVE RASTREO.
                      END.
                  END.
              END.
          END.
      END.    
  END CASE.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  DEF VAR RPTA AS CHAR INIT 'ERROR'.
  FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
      AND Almacen.CodAlm = S-CODALM NO-LOCK NO-ERROR.
  RUN ALM/D-CLAVE (Almacen.Clave,OUTPUT RPTA).
  IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".                        
                                              
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  
  FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
      AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.
  ASSIGN
      x-user   = s-user-id 
      x-coddiv = s-coddiv 
      x-desdiv = gn-divi.desdiv 
      x-fecha  = TODAY .


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
  {src/adm/template/snd-list.i "CntDocum"}

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

  /* CONSISTENCIA DEL DOCUMENTO */
  CASE CntDocum.coddoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}:
      WHEN 'FAC' OR WHEN 'BOL' OR WHEN 'G/R' THEN DO:
          FIND FIRST CcbCDocu WHERE ccbcdocu.codcia = s-codcia
              AND ccbcdocu.coddoc = CntDocum.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
              AND ccbcdocu.nrodoc = CntDocum.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE ccbcdocu THEN DO:
              /*BUSCA OTRO CAMINO*/
              DEF VAR x-Ok AS LOG INIT NO NO-UNDO.
              RASTREA:
              FOR EACH AlmTMovm WHERE almtmovm.codcia = s-codcia
                  AND almtmovm.tipmov  = 'S'
                  AND almtmovm.reqguia = YES
                  AND almtmovm.movtrf  = YES NO-LOCK:
                  FOR EACH Almacen WHERE Almacen.codcia = s-codcia NO-LOCK:
                      FIND Almcmov WHERE almcmov.codcia = s-codcia
                          AND almcmov.codalm = almacen.codalm
                          AND almcmov.tipmov = almtmovm.tipmov
                          AND almcmov.codmov = almtmovm.codmov
                          AND almcmov.flgest <> 'A'
                          AND almcmov.nroser = INTEGER(SUBSTRING(CntDocum.nrodoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},1,3))
                          AND almcmov.nrodoc = INTEGER(SUBSTRING(CntDocum.nrodoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},4))
                          NO-LOCK NO-ERROR.
                      IF AVAILABLE Almcmov THEN DO:
                          x-Ok = YES.
                          LEAVE RASTREA.
                      END.
                  END.
              END.
              IF x-Ok = NO THEN DO:
                  MESSAGE 'Documento NO registrado' VIEW-AS ALERT-BOX ERROR.
                  RETURN 'ADM-ERROR'.
              END.
              IF almcmov.flgest = 'A' THEN DO:
                  MESSAGE 'El documento esta ANULADO' VIEW-AS ALERT-BOX ERROR.
                  RETURN 'ADM-ERROR'.
              END.
              LEAVE.
          END. /*if not avail...*/
          IF ccbcdocu.flgest = 'A' THEN DO:
              MESSAGE 'El documento esta ANULADO' VIEW-AS ALERT-BOX ERROR.
              RETURN 'ADM-ERROR'.
          END.
          
      END.
      OTHERWISE DO:
          MESSAGE 'Documento NO valido' VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
  END CASE.

  /*Visualiza ultimo movimiento*/
  FIND LAST cntdocum WHERE cntdocum.codcia = s-codcia
      AND cntdocum.coddiv = s-coddiv
      AND cntdocum.coddoc = cntdocum.coddoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      AND cntdocum.nrodoc = cntdocum.nrodoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  IF AVAIL cntdocum THEN DO:
      IF cntdocum.tipmov = 'S' THEN  DO:
          MESSAGE 'Documento ya registra salida en este almacen' SKIP
                  'el dia ' + STRING(cntdocum.fchdoc) + 'por ' + CntDocum.usuario 
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
          APPLY 'ENTRY' TO cntdocum.nrodoc.
          RETURN 'adm-error'.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fOriDoc B-table-Win 
FUNCTION fOriDoc RETURNS CHARACTER
  ( INPUT cCodDoc AS CHAR,
    INPUT cNroDoc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VAR cOriDoc AS CHAR NO-UNDO. 

  /*Busca Documento Venta*/  
  FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia
      AND ccbcdocu.coddoc = cCodDoc 
      AND ccbcdocu.nrodoc = cNroDoc NO-LOCK NO-ERROR.
  IF AVAIL ccbcdocu THEN cOriDoc = 'V'.
  ELSE DO:
      RASTREO:
      FOR EACH AlmTMovm WHERE almtmovm.codcia = s-codcia
          AND almtmovm.tipmov = 'S'
          AND almtmovm.reqguia = YES
          AND almtmovm.movtrf  = YES NO-LOCK:
          FOR EACH Almacen WHERE Almacen.codcia = s-codcia NO-LOCK:
              FIND Almcmov WHERE almcmov.codcia = s-codcia
                  AND almcmov.codalm = almacen.codalm
                  AND almcmov.tipmov = almtmovm.tipmov
                  AND almcmov.codmov = almtmovm.codmov
                  AND almcmov.flgest <> 'A'
                  AND almcmov.nroser = INTEGER(SUBSTRING(cNroDoc,1,3))
                  AND almcmov.nrodoc = INTEGER(SUBSTRING(cNroDoc,4))
                  NO-LOCK NO-ERROR.
              IF AVAILABLE Almcmov THEN DO:
                  cOriDoc = 'T'.
                  LEAVE RASTREO.
              END.
          END.
      END.
  END.
  RETURN cOriDoc.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fValSal B-table-Win 
FUNCTION fValSal RETURNS LOGICAL
  ( INPUT cCodDoc AS CHAR,
    INPUT cNroDoc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  /*Busca Si Documento pertenece a Division*/
  MESSAGE s-coddiv.
  FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia
      AND ccbcdocu.coddoc = cCodDoc
      AND ccbcdocu.nrodoc = cNroDoc
      AND ccbcdocu.coddiv = s-coddiv NO-LOCK NO-ERROR.
  IF AVAIL ccbcdocu THEN RETURN TRUE.
  ELSE DO:
      /*Busca el último movimiento que tuvo ese documento*/
      FIND LAST cntdocum WHERE cntdocum.codcia = s-codcia
          AND cntdocum.coddoc = cCodDoc
          AND cntdocum.nrodoc = cNroDoc
          /*AND cntdocum.tipmov = 'I'*/
          AND cntdocum.coddiv = s-coddiv NO-LOCK NO-ERROR.
      IF AVAIL cntdocum AND cntdocum.tipmov = 'I' THEN RETURN TRUE.
      ELSE RETURN FALSE.
  END.

  /*RETURN FALSE.   /* Function return value. */*/

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

