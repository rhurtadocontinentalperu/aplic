&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
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
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.

DEF BUFFER B-DCDOC FOR AlmDCDoc.

/* VARIABLES A USAR EN EL BROWSE */
DEF VAR x-NomCli AS CHAR FORMAT 'x(45)' NO-UNDO.
DEF VAR x-CodAlm AS CHAR FORMAT 'x(3)'  NO-UNDO.

DEFINE VARIABLE s-status-record AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES AlmDCdoc

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table AlmDCdoc.CodDoc AlmDCdoc.NroDoc ~
ENTRY(2,AlmDCdoc.CodCli,'|')  @ x-NomCli ~
ENTRY(3,AlmDCdoc.CodCli,'|')  @ x-CodAlm AlmDCdoc.Bultos AlmDCdoc.Observ ~
AlmDCdoc.Fecha AlmDCdoc.Hora 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table AlmDCdoc.CodDoc ~
AlmDCdoc.NroDoc AlmDCdoc.Bultos AlmDCdoc.Observ 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table AlmDCdoc
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table AlmDCdoc
&Scoped-define QUERY-STRING-br_table FOR EACH AlmDCdoc WHERE ~{&KEY-PHRASE} ~
      AND AlmDCdoc.CodCia = s-codcia ~
 AND AlmDCdoc.usuario = FILL-IN-Usuario ~
 AND AlmDCdoc.CodAlm = FILL-IN-CodAlm ~
 AND AlmDCdoc.Fecha = FILL-IN-Fecha ~
 AND (AlmDCdoc.FlgEst = "S" ~
  OR AlmDCdoc.FlgEst = "R") NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH AlmDCdoc WHERE ~{&KEY-PHRASE} ~
      AND AlmDCdoc.CodCia = s-codcia ~
 AND AlmDCdoc.usuario = FILL-IN-Usuario ~
 AND AlmDCdoc.CodAlm = FILL-IN-CodAlm ~
 AND AlmDCdoc.Fecha = FILL-IN-Fecha ~
 AND (AlmDCdoc.FlgEst = "S" ~
  OR AlmDCdoc.FlgEst = "R") NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table AlmDCdoc
&Scoped-define FIRST-TABLE-IN-QUERY-br_table AlmDCdoc


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Usuario FILL-IN-CodAlm ~
FILL-IN-Fecha 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fAlmacen B-table-Win 
FUNCTION fAlmacen RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDescrip B-table-Win 
FUNCTION fDescrip RETURNS CHARACTER FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-CodAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha AS DATE FORMAT "99/99/99":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Usuario AS CHARACTER FORMAT "X(256)":U 
     LABEL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      AlmDCdoc SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      AlmDCdoc.CodDoc FORMAT "x(11)":U
      AlmDCdoc.NroDoc COLUMN-LABEL "<<Numero>>" FORMAT "X(12)":U
            WIDTH 10.57
      ENTRY(2,AlmDCdoc.CodCli,'|')  @ x-NomCli COLUMN-LABEL "Nombre" FORMAT "x(45)":U
      ENTRY(3,AlmDCdoc.CodCli,'|')  @ x-CodAlm COLUMN-LABEL "Alm." FORMAT "x(3)":U
      AlmDCdoc.Bultos FORMAT "->,>>>,>>9":U
      AlmDCdoc.Observ COLUMN-LABEL "Observaciones" FORMAT "x(40)":U
      AlmDCdoc.Fecha FORMAT "99/99/99":U
      AlmDCdoc.Hora FORMAT "X(5)":U WIDTH 5.43
  ENABLE
      AlmDCdoc.CodDoc
      AlmDCdoc.NroDoc
      AlmDCdoc.Bultos
      AlmDCdoc.Observ
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 110 BY 12.69
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Usuario AT ROW 1.19 COL 15 COLON-ALIGNED
     FILL-IN-CodAlm AT ROW 2.15 COL 15 COLON-ALIGNED
     FILL-IN-Fecha AT ROW 3.12 COL 15 COLON-ALIGNED
     br_table AT ROW 4.27 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


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
         HEIGHT             = 18.23
         WIDTH              = 113.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table FILL-IN-Fecha F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-CodAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Fecha IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Usuario IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.AlmDCdoc"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST OUTER"
     _Where[1]         = "INTEGRAL.AlmDCdoc.CodCia = s-codcia
 AND INTEGRAL.AlmDCdoc.usuario = FILL-IN-Usuario
 AND INTEGRAL.AlmDCdoc.CodAlm = FILL-IN-CodAlm
 AND INTEGRAL.AlmDCdoc.Fecha = FILL-IN-Fecha
 AND (AlmDCdoc.FlgEst = ""S""
  OR AlmDCdoc.FlgEst = ""R"")"
     _FldNameList[1]   > INTEGRAL.AlmDCdoc.CodDoc
"AlmDCdoc.CodDoc" ? "x(11)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.AlmDCdoc.NroDoc
"AlmDCdoc.NroDoc" "<<Numero>>" "X(12)" "character" ? ? ? ? ? ? yes ? no no "10.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"ENTRY(2,AlmDCdoc.CodCli,'|')  @ x-NomCli" "Nombre" "x(45)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"ENTRY(3,AlmDCdoc.CodCli,'|')  @ x-CodAlm" "Alm." "x(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.AlmDCdoc.Bultos
"AlmDCdoc.Bultos" ? ? "integer" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.AlmDCdoc.Observ
"AlmDCdoc.Observ" "Observaciones" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = INTEGRAL.AlmDCdoc.Fecha
     _FldNameList[8]   > INTEGRAL.AlmDCdoc.Hora
"AlmDCdoc.Hora" ? ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES'
  THEN APPLY 'ENTRY':U TO AlmDCdoc.CodDoc.
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


&Scoped-define SELF-NAME AlmDCdoc.CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL AlmDCdoc.CodDoc br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF AlmDCdoc.CodDoc IN BROWSE br_table /* Codigo */
DO:
  IF s-status-record = 'cancel-record' THEN RETURN.
  IF SELF:SCREEN-VALUE <> "" THEN DO:
      /* RUTINA CON EL SCANNER */
      CASE SUBSTRING(SELF:SCREEN-VALUE,1,1):
        WHEN '1' THEN DO:           /* FACTURA */
            ASSIGN
                AlmDCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = SUBSTRING(SELF:SCREEN-VALUE,2,3) +
                                                                        SUBSTRING(SELF:SCREEN-VALUE,6,6)
                SELF:SCREEN-VALUE = 'FAC'.
        END.
        WHEN '9' THEN DO:           /* G/R */
            ASSIGN
                AlmDCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = SUBSTRING(SELF:SCREEN-VALUE,2,3) +
                                                                        SUBSTRING(SELF:SCREEN-VALUE,6,6)
                SELF:SCREEN-VALUE = 'G/R'.
        END.
        WHEN '3' THEN DO:           /* BOL */
            ASSIGN
                AlmDCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = SUBSTRING(SELF:SCREEN-VALUE,2,3) +
                                                                        SUBSTRING(SELF:SCREEN-VALUE,6,6)
                SELF:SCREEN-VALUE = 'BOL'.
        END.
      END CASE.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME AlmDCdoc.NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL AlmDCdoc.NroDoc br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF AlmDCdoc.NroDoc IN BROWSE br_table /* <<Numero>> */
DO:

    x-NomCli:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
    x-CodAlm:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.

    IF LOOKUP(Almdcdoc.coddoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},'FAC,BOL,G/R') > 0 THEN DO:
        FIND CcbCDocu WHERE ccbcdocu.codcia = s-codcia
            AND ccbcdocu.coddoc = AlmDCdoc.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
            AND ccbcdocu.nrodoc = AlmDCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
            NO-LOCK NO-ERROR.
        IF AVAILABLE ccbcdocu THEN 
            ASSIGN
                x-NomCli:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ccbcdocu.nomcli
                x-CodAlm:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ccbcdocu.codalm.      

    END.
    IF x-NomCli:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '' THEN DO:
        DEF VAR x-Ok AS LOG INIT NO NO-UNDO.
        RASTREA:
        FOR EACH AlmTMovm WHERE almtmovm.codcia = s-codcia
            AND almtmovm.tipmov = 'S'
            AND almtmovm.reqguia = YES NO-LOCK:
            FOR EACH Almacen WHERE Almacen.codcia = s-codcia NO-LOCK:
                FIND Almcmov WHERE almcmov.codcia = s-codcia
                    AND almcmov.codalm = almacen.codalm
                    AND almcmov.tipmov = almtmovm.tipmov
                    AND almcmov.codmov = almtmovm.codmov
                    AND almcmov.flgest <> 'A'
                    AND almcmov.nroser = INTEGER(SUBSTRING(almdcdoc.nrodoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},1,3))
                    AND almcmov.nrodoc = INTEGER(SUBSTRING(almdcdoc.nrodoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},4))
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Almcmov THEN DO:
                    x-NomCli:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = almcmov.nomref.
                    x-CodAlm:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = almcmov.codalm.

                    /* 07.09.09 */
                    IF x-nomcli:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '' 
                        THEN x-nomcli:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = Almacen.Descripcion.
                    LEAVE RASTREA.
                END.
            END.
        END.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Fecha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Fecha B-table-Win
ON LEAVE OF FILL-IN-Fecha IN FRAME F-Main /* Fecha */
OR RETURN OF FILL-IN-Fecha
DO:
  ASSIGN {&SELF-NAME}.
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

ON RETURN OF AlmDCdoc.Bultos, AlmDCdoc.CodDoc, AlmDCdoc.NroDoc, AlmDCdoc.Observ
DO:
  APPLY 'TAB':U.
  RETURN NO-APPLY.
END.

/*
ON FIND OF AlmDCDoc 
DO:
    ASSIGN
        x-NomCli = fDescrip()
        x-CodAlm = fAlmacen().
END.
*/

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
  s-status-record = 'add-record'.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* NO SE PUEDE REPETIR EL DOCUMENTO */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES'THEN DO:
      ASSIGN
        AlmDCDoc.codcia  = s-codcia
        AlmDCDoc.coddoc  = CAPS(Almdcdoc.coddoc)
        AlmDCDoc.usuario = FILL-IN-Usuario
        AlmDCDoc.codalm  = FILL-IN-CodAlm
        AlmDCDoc.fecha   = TODAY
        AlmDCDoc.hora    = STRING(TIME, 'HH:MM')
        FILL-IN-Fecha    = TODAY.

      CASE almdcdoc.coddoc:
        WHEN 'FAC' OR WHEN 'BOL' OR WHEN 'G/R' THEN DO:
            FIND ccbcdocu WHERE ccbcdocu.codcia = almdcdoc.codcia
                AND ccbcdocu.coddoc = almdcdoc.coddoc
                AND ccbcdocu.nrodoc = almdcdoc.nrodoc
                NO-LOCK NO-ERROR.
            IF AVAILABLE ccbcdocu THEN almdcdoc.codcli = ccbcdocu.codcli + '|' + ccbcdocu.nomcli +
                '|' + ccbcdocu.codalm.
            ELSE DO:
                RASTREO:
                FOR EACH AlmTMovm WHERE almtmovm.codcia = s-codcia
                        AND almtmovm.tipmov = 'S'
                        AND almtmovm.reqguia = YES NO-LOCK:
                    FOR EACH Almacen WHERE Almacen.codcia = s-codcia NO-LOCK:
                        FIND Almcmov WHERE almcmov.codcia = s-codcia
                            AND almcmov.codalm = almacen.codalm
                            AND almcmov.tipmov = almtmovm.tipmov
                            AND almcmov.codmov = almtmovm.codmov
                            AND almcmov.flgest <> 'A'
                            AND almcmov.nroser = INTEGER(SUBSTRING(almdcdoc.nrodoc,1,3))
                            AND almcmov.nrodoc = INTEGER(SUBSTRING(almdcdoc.nrodoc,4))
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE Almcmov THEN DO:
                            almdcdoc.codcli = almcmov.codcli +  '|' + almcmov.nomref + 
                                '|' + almcmov.codalm.
                            LEAVE RASTREO.
                        END.
                    END.
                END.
            END.
        END.
      END CASE.
  END.
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
  s-status-record = 'cancel-record'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
/*  DO WITH FRAME {&FRAME-NAME}:
 *     ASSIGN
 *         FILL-IN-Fecha:SENSITIVE = YES.
 *   END.
 * */
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
/*  MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
 *   RETURN 'ADM-ERROR'.*/

  IF AlmDCDoc.flgest <> 'S'
  THEN DO:
    MESSAGE 'Acceso Denegado' SKIP 'Este documento ha sido devuelto'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.

  DEF VAR RPTA AS CHAR INIT 'ERROR'.
  FIND Almacen WHERE 
    Almacen.CodCia = S-CODCIA AND
    Almacen.CodAlm = S-CODALM NO-LOCK NO-ERROR.
  RUN ALM/D-CLAVE01 (Almacen.Clave,OUTPUT RPTA).
  IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
  

  /* Dispatch standard ADM method.                             */
  /*
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
  */

  /* Code placed here will execute AFTER standard behavior.    */
  FIND CURRENT Almdcdoc EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE Almdcdoc 
      THEN ASSIGN
                AlmDCdoc.FlgEst = 'A'
                AlmDCdoc.ObsRet = 'ANULADO EL ' + STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM') +
                                'POR EL USUARIO ' + s-user-id.
  FIND CURRENT Almdcdoc NO-LOCK NO-ERROR.
  RUN dispatch IN THIS-PROCEDURE ('open-query').

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
    ASSIGN
        FILL-IN-Fecha:SENSITIVE = NO.

    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' THEN DO:
        AlmDCdoc.CodDoc:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO.
        AlmDCdoc.NroDoc:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO.
        AlmDCdoc.Bultos:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO.
        AlmDCdoc.Observ:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO.
        APPLY 'ENTRY':U TO AlmDCdoc.CodDoc.
    END.
    ELSE DO:
        AlmDCdoc.CodDoc:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.
        AlmDCdoc.NroDoc:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.
        AlmDCdoc.Bultos:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.
        APPLY 'ENTRY':U TO AlmDCdoc.Observ.
    END.
  END.

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
  ASSIGN
    FILL-IN-CodAlm = s-codalm
    FILL-IN-Fecha  = TODAY
    FILL-IN-Usuario = s-user-id.

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
/*  DO WITH FRAME {&FRAME-NAME}:
 *     ASSIGN
 *         FILL-IN-Fecha:SENSITIVE = YES.
 *   END.*/
  
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
  {src/adm/template/snd-list.i "AlmDCdoc"}

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
  Notes:  EN CASO DE ERROR RETORNAR : RETURN "ADM-ERROR"
------------------------------------------------------------------------------*/

DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-msg AS CHAR.

x-coddoc = Almdcdoc.coddoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
                                      
  /* CONSISTENCIA DEL DOCUMENTO */
  DEF VAR x-Ok AS LOG INIT NO NO-UNDO.
  CASE Almdcdoc.coddoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}:
      WHEN 'FAC' OR WHEN 'BOL' OR WHEN 'G/R' THEN DO:
          FIND CcbCDocu WHERE ccbcdocu.codcia = s-codcia
              AND ccbcdocu.coddoc = AlmDCdoc.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
              AND ccbcdocu.nrodoc = AlmDCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE ccbcdocu THEN DO:
              /*BUSCA OTRO CAMINO*/
              RASTREA:
              FOR EACH AlmTMovm WHERE almtmovm.codcia = s-codcia
                  AND almtmovm.tipmov = 'S'
                  AND almtmovm.reqguia = YES NO-LOCK:
                  FOR EACH Almacen WHERE Almacen.codcia = s-codcia NO-LOCK:
                      FIND Almcmov WHERE almcmov.codcia = s-codcia
                          AND almcmov.codalm = almacen.codalm
                          AND almcmov.tipmov = almtmovm.tipmov
                          AND almcmov.codmov = almtmovm.codmov
                          AND almcmov.flgest <> 'A'
                          AND almcmov.nroser = INTEGER(SUBSTRING(almdcdoc.nrodoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},1,3))
                          AND almcmov.nrodoc = INTEGER(SUBSTRING(almdcdoc.nrodoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},4))
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
          END. /*if not avail...*/
          ELSE DO:
              IF ccbcdocu.flgest = 'A' THEN DO:
                  MESSAGE 'El documento esta ANULADO' VIEW-AS ALERT-BOX ERROR.
                  RETURN 'ADM-ERROR'.
              END.
          END.
      END.
      OTHERWISE DO:
          MESSAGE 'Documento NO valido' VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
  END CASE.
  
  /* NO SE PUEDE REPETIR EL DOCUMENTO */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES'
  THEN DO:
    FIND B-DCDOC WHERE b-dcdoc.codcia = s-codcia
        AND b-dcdoc.coddoc = AlmDCdoc.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        AND b-dcdoc.nrodoc = AlmDCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        AND b-dcdoc.codalm = fill-in-codalm:SCREEN-VALUE IN FRAME {&FRAME-NAME}
        AND b-dcdoc.flgest = 'S'
        NO-LOCK NO-ERROR.
    IF AVAILABLE B-DCDOC
    THEN DO:
        MESSAGE 'El documento ya fue registrado con el usuario' b-dcdoc.usuario SKIP
            'el dia' b-dcdoc.fecha 'y hora' b-dcdoc.hora 'almacen' b-dcdoc.codalm
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.

    /* 
        Correo(20Feb2018) Fernan Oblitas y aprobacion Harold Segura 
        Validar con H/R
    */

    x-msg = "G/R no existe y/o la H/R no esta activa para salir HOY".
    
    /* Transferencias */
    FOR EACH di-rutag WHERE di-rutag.codcia = s-codcia
        AND di-rutag.coddoc = 'H/R'
        AND di-rutag.coddiv = s-coddiv
        AND di-rutag.serref = INTEGER( SUBSTRING(AlmDCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},1,3) )
        AND di-rutag.nroref = INTEGER( SUBSTRING(AlmDCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},4) )
        NO-LOCK,
        FIRST di-rutaC OF di-rutaG WHERE di-rutaC.libre_l01 = YES AND
                                                        di-rutaC.flgest BEGINS 'P' AND 
                                                        di-rutaC.fchsal = TODAY
                                                        NO-LOCK :
        x-msg = "".
    END.

    IF x-msg <> "" THEN DO:
        /* Ventas */
        FOR EACH di-rutaD WHERE di-rutad.codcia = s-codcia AND 
                                    di-rutad.coddoc = 'H/R' AND
                                    di-rutad.coddiv = s-coddiv AND 
                                    di-rutad.codref = AlmDCdoc.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} AND
                                    di-rutad.nroref = AlmDCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                                    NO-LOCK,
                FIRST di-rutaC OF di-rutaD WHERE di-rutaC.libre_l01 = YES AND
                                                    di-rutaC.flgest BEGINS 'P' AND 
                                                    di-rutaC.fchsal = TODAY
                                                    NO-LOCK:
            x-msg = "".
        END.

    END.
    IF x-msg <> "" THEN DO:
        /* Guias Itinerantes */
        FOR FIRST di-rutadg WHERE di-rutadg.codcia = s-codcia
            AND di-rutadg.coddoc = 'H/R'
            AND di-rutadg.coddiv = s-coddiv
            AND di-rutadg.codref = AlmDCdoc.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
            AND di-rutadg.nroref = AlmDCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
            NO-LOCK, 
            FIRST di-rutaC OF di-rutaDG WHERE di-rutaC.libre_l01 = YES AND
                                                di-rutaC.flgest BEGINS 'P' AND 
                                                di-rutaC.fchsal = TODAY
                                                NO-LOCK:
            x-msg = "".

        END.            
    END.

    IF x-msg <> "" THEN DO:
        MESSAGE x-msg
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    

    /* RHC 20.05.2011 debe estar registrado en una hoja de ruta */
    /* 02.06.2011 POR AHORA 
    x-Ok = NO.
    FOR FIRST di-rutad NO-LOCK WHERE di-rutad.codcia = s-codcia
        AND di-rutad.coddoc = 'H/R'
        AND di-rutad.coddiv = s-coddiv
        AND di-rutad.codref = AlmDCdoc.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        AND di-rutad.nroref = AlmDCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
        FIRST di-rutac OF di-rutad NO-LOCK WHERE di-rutac.flgest = 'P':
        x-Ok = YES.
    END.
    IF x-Ok = NO THEN DO:
        FOR FIRST di-rutag NO-LOCK WHERE di-rutag.codcia = s-codcia
            AND di-rutag.coddoc = 'H/R'
            AND di-rutag.coddiv = s-coddiv
            AND di-rutag.serref = INTEGER( SUBSTRING(AlmDCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},1,3) )
            AND di-rutag.nroref = INTEGER( SUBSTRING(AlmDCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},4) ),
            FIRST di-rutac OF di-rutad NO-LOCK WHERE di-rutag.flgest = 'P':
            x-Ok = YES.
        END.
    END.
    IF x-Ok = NO THEN DO:
        FOR FIRST di-rutadg NO-LOCK WHERE di-rutadg.codcia = s-codcia
            AND di-rutadg.coddoc = 'H/R'
            AND di-rutadg.coddiv = s-coddiv
            AND di-rutadg.codref = AlmDCdoc.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
            AND di-rutadg.nroref = AlmDCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
            FIRST di-rutac OF di-rutadg NO-LOCK WHERE di-rutac.flgest = 'P':
            x-Ok = YES.
        END.
    END.
    IF x-Ok = NO THEN DO:
        MESSAGE 'El documento NO está registrado en ninguna Hoja de Ruta'
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    ********************** */
  END.

  /*DOCUMENTO DIFERENTE A BLANCO*/
  IF AlmDCdoc.NroDoc:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Ingrese Número de Documento"
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      APPLY "ENTRY" TO AlmDCdoc.NroDoc.
      RETURN "adm-error".
  END.


  /*CODIGO DOCUMENTO DIFERENTE A BLANCO*/
  IF AlmDCdoc.CodDoc:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Ingrese Código de Documento"
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      APPLY "ENTRY" TO AlmDCdoc.CodDoc.
      RETURN "adm-error".
  END.

  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     Consistenciar la modificacion de la fila
  Parameters:  Retornar "ADM-ERROR" en caso de bloquear la modificacion
  Notes:       
------------------------------------------------------------------------------*/
  MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.

  RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fAlmacen B-table-Win 
FUNCTION fAlmacen RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF NOT AVAILABLE AlmDCDoc THEN RETURN ''.
  CASE AlmDCDoc.coddoc:
    WHEN 'FAC' OR WHEN 'BOL' OR WHEN 'G/R' THEN DO:
        FIND CcbCDocu WHERE ccbcdocu.codcia = almdcdoc.codcia
            AND ccbcdocu.coddoc = almdcdoc.coddoc
            AND ccbcdocu.nrodoc = almdcdoc.nrodoc
            NO-LOCK NO-ERROR.
        IF AVAILABLE Ccbcdocu THEN RETURN ccbcdocu.codalm.        
        ELSE DO:
            FOR EACH AlmTMovm WHERE almtmovm.codcia = s-codcia
                    AND almtmovm.tipmov = 'S'
                    AND almtmovm.reqguia = YES NO-LOCK:
                FOR EACH Almacen WHERE Almacen.codcia = s-codcia NO-LOCK:
                    FIND Almcmov WHERE almcmov.codcia = s-codcia
                        AND almcmov.codalm = almacen.codalm
                        AND almcmov.tipmov = almtmovm.tipmov
                        AND almcmov.codmov = almtmovm.codmov
                        AND almcmov.flgest <> 'A'
                        AND almcmov.nroser = INTEGER(SUBSTRING(almdcdoc.nrodoc,1,3))
                        AND almcmov.nrodoc = INTEGER(SUBSTRING(almdcdoc.nrodoc,4))
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE Almcmov THEN RETURN almcmov.codalm.
                END.
            END.
        END.
    END.
  END CASE.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDescrip B-table-Win 
FUNCTION fDescrip RETURNS CHARACTER:
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF NOT AVAILABLE AlmDCDoc THEN RETURN ''.
  CASE AlmDCDoc.coddoc:
    WHEN 'FAC' OR WHEN 'BOL' OR WHEN 'G/R'THEN DO:
        FIND CcbCDocu WHERE ccbcdocu.codcia = almdcdoc.codcia
            AND ccbcdocu.coddoc = almdcdoc.coddoc
            AND ccbcdocu.nrodoc = almdcdoc.nrodoc
            NO-LOCK NO-ERROR.
        IF AVAILABLE Ccbcdocu THEN RETURN ccbcdocu.nomcli.        
        ELSE DO:
            FOR EACH AlmTMovm WHERE almtmovm.codcia = s-codcia
                AND almtmovm.tipmov = 'S'
                AND almtmovm.reqguia = YES NO-LOCK:
                FOR EACH Almacen WHERE Almacen.codcia = s-codcia NO-LOCK:
                    FIND Almcmov WHERE almcmov.codcia = s-codcia
                        AND almcmov.codalm = almacen.codalm
                        AND almcmov.tipmov = almtmovm.tipmov
                        AND almcmov.codmov = almtmovm.codmov
                        AND almcmov.flgest <> 'A'
                        AND almcmov.nroser = INTEGER(SUBSTRING(almdcdoc.nrodoc,1,3))
                        AND almcmov.nrodoc = INTEGER(SUBSTRING(almdcdoc.nrodoc,4))
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE Almcmov THEN RETURN almcmov.NomRef.
                END.
            END.
        END.
    END.
  END CASE.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

