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

DEF BUFFER B-DCDOC FOR AlmRCDoc.

/* VARIABLES A USAR EN EL BROWSE */
DEF VAR x-NomCli AS CHAR FORMAT 'x(45)' NO-UNDO.
DEF VAR x-CodAlm AS CHAR FORMAT 'x(3)'  NO-UNDO.

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
&Scoped-define INTERNAL-TABLES AlmRCDoc

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table AlmRCDoc.CodDoc AlmRCDoc.NroDoc ~
x-NomCli  @ x-NomCli x-CodAlm @ x-CodAlm AlmRCDoc.Bultos AlmRCDoc.Observ ~
AlmRCDoc.Fecha AlmRCDoc.Hora 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table AlmRCDoc.CodDoc ~
AlmRCDoc.NroDoc AlmRCDoc.Bultos AlmRCDoc.Observ 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table AlmRCDoc
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table AlmRCDoc
&Scoped-define QUERY-STRING-br_table FOR EACH AlmRCDoc WHERE ~{&KEY-PHRASE} ~
      AND AlmRCDoc.CodCia = s-codcia ~
 AND AlmRCDoc.CodAlm = fill-in-codalm ~
 AND AlmRCDoc.Fecha = fill-in-fecha ~
 AND AlmRCDoc.usuario = fill-in-usuario NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH AlmRCDoc WHERE ~{&KEY-PHRASE} ~
      AND AlmRCDoc.CodCia = s-codcia ~
 AND AlmRCDoc.CodAlm = fill-in-codalm ~
 AND AlmRCDoc.Fecha = fill-in-fecha ~
 AND AlmRCDoc.usuario = fill-in-usuario NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table AlmRCDoc
&Scoped-define FIRST-TABLE-IN-QUERY-br_table AlmRCDoc


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
      AlmRCDoc SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      AlmRCDoc.CodDoc FORMAT "x(11)":U
      AlmRCDoc.NroDoc COLUMN-LABEL "<<Numero>>" FORMAT "X(9)":U
      x-NomCli  @ x-NomCli COLUMN-LABEL "Nombre" FORMAT "x(45)":U
      x-CodAlm @ x-CodAlm COLUMN-LABEL "Alm." FORMAT "x(3)":U
      AlmRCDoc.Bultos FORMAT "->,>>>,>>9":U
      AlmRCDoc.Observ FORMAT "x(40)":U
      AlmRCDoc.Fecha FORMAT "99/99/99":U
      AlmRCDoc.Hora FORMAT "X(5)":U
  ENABLE
      AlmRCDoc.CodDoc
      AlmRCDoc.NroDoc
      AlmRCDoc.Bultos
      AlmRCDoc.Observ
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 105 BY 12.69
         FONT 4.


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
         WIDTH              = 107.
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
     _TblList          = "INTEGRAL.AlmRCDoc"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST OUTER"
     _Where[1]         = "INTEGRAL.AlmRCDoc.CodCia = s-codcia
 AND INTEGRAL.AlmRCDoc.CodAlm = fill-in-codalm
 AND INTEGRAL.AlmRCDoc.Fecha = fill-in-fecha
 AND INTEGRAL.AlmRCDoc.usuario = fill-in-usuario"
     _FldNameList[1]   > INTEGRAL.AlmRCDoc.CodDoc
"AlmRCDoc.CodDoc" ? "x(11)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.AlmRCDoc.NroDoc
"AlmRCDoc.NroDoc" "<<Numero>>" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"x-NomCli  @ x-NomCli" "Nombre" "x(45)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"x-CodAlm @ x-CodAlm" "Alm." "x(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.AlmRCDoc.Bultos
"AlmRCDoc.Bultos" ? ? "integer" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.AlmRCDoc.Observ
"AlmRCDoc.Observ" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = INTEGRAL.AlmRCDoc.Fecha
     _FldNameList[8]   = INTEGRAL.AlmRCDoc.Hora
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
  THEN APPLY 'ENTRY':U TO AlmRCdoc.CodDoc.
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


&Scoped-define SELF-NAME AlmRCDoc.CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL AlmRCDoc.CodDoc br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF AlmRCDoc.CodDoc IN BROWSE br_table /* Codigo */
DO:
/*   SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).                                                         */
/*   /* RUTINA CON EL SCANNER */                                                                          */
/*   CASE SUBSTRING(SELF:SCREEN-VALUE,1,1):                                                               */
/*     WHEN '1' THEN DO:           /* FACTURA */                                                          */
/*         ASSIGN                                                                                         */
/*             AlmRCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = SUBSTRING(SELF:SCREEN-VALUE,2,3) + */
/*                                                                     SUBSTRING(SELF:SCREEN-VALUE,6,6)   */
/*             SELF:SCREEN-VALUE = 'FAC'.                                                                 */
/*     END.                                                                                               */
/*   END CASE.                                                                                            */

    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    /* RUTINA CON EL SCANNER */
    CASE SUBSTRING(SELF:SCREEN-VALUE,1,1):
      WHEN '1' THEN DO:           /* FACTURA */
          ASSIGN
              AlmRCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = SUBSTRING(SELF:SCREEN-VALUE,2,3) +
                                                                      SUBSTRING(SELF:SCREEN-VALUE,6,6)
              SELF:SCREEN-VALUE = 'FAC'.
      END.
      WHEN '9' THEN DO:           /* G/R */
          ASSIGN
              AlmRCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = SUBSTRING(SELF:SCREEN-VALUE,2,3) +
                                                                      SUBSTRING(SELF:SCREEN-VALUE,6,6)
              SELF:SCREEN-VALUE = 'G/R'.
      END.
      WHEN '3' THEN DO:           /* BOL */
          ASSIGN
              AlmRCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = SUBSTRING(SELF:SCREEN-VALUE,2,3) +
                                                                      SUBSTRING(SELF:SCREEN-VALUE,6,6)
              SELF:SCREEN-VALUE = 'BOL'.
      END.
    END CASE.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME AlmRCDoc.NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL AlmRCDoc.NroDoc br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF AlmRCDoc.NroDoc IN BROWSE br_table /* <<Numero>> */
DO:
/*  FIND CcbCDocu WHERE ccbcdocu.codcia = s-codcia
 *     AND ccbcdocu.coddoc = almrcdoc.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
 *     AND ccbcdocu.nrodoc = SELF:SCREEN-VALUE
 *     NO-LOCK NO-ERROR.
 *   IF AVAILABLE ccbcdocu
 *   THEN DISPLAY ccbcdocu.nomcli WITH BROWSE {&BROWSE-NAME}.
 *   ELSE DISPLAY '' @ ccbcdocu.nomcli WITH BROWSE {&BROWSE-NAME}.*/
  x-NomCli:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
  x-CodAlm:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.

    IF LOOKUP(Almrcdoc.coddoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},'FAC,BOL,G/R') > 0 THEN DO:
      FIND CcbCDocu WHERE ccbcdocu.codcia = s-codcia
          AND ccbcdocu.coddoc = AlmRCdoc.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
          AND ccbcdocu.nrodoc = AlmRCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
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
                  AND almcmov.nroser = INTEGER(SUBSTRING(almrcdoc.nrodoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},1,3))
                  AND almcmov.nrodoc = INTEGER(SUBSTRING(almrcdoc.nrodoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},4))
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

/*
  CASE almrcdoc.coddoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}:
  WHEN 'FAC' OR WHEN 'BOL' THEN DO:
    FIND CcbCDocu WHERE ccbcdocu.codcia = s-codcia
      AND ccbcdocu.coddoc = almrcdoc.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      AND ccbcdocu.nrodoc = almrcdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
    IF AVAILABLE ccbcdocu 
    THEN ASSIGN
            x-NomCli:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ccbcdocu.nomcli
            x-CodAlm:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ccbcdocu.codalm.
  END.
  WHEN 'G/R' THEN DO:
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
                AND almcmov.nroser = INTEGER(SUBSTRING(almrcdoc.nrodoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},1,3))
                AND almcmov.nrodoc = INTEGER(SUBSTRING(almrcdoc.nrodoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},4))
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almcmov 
            THEN DO:
                x-NomCli:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = almcmov.nomref.
                x-CodAlm:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = almcmov.codalm.
                LEAVE RASTREA.
            END.
        END.
    END.
  END.
  END CASE.
*/  
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

ON RETURN OF AlmRCdoc.Bultos, AlmRCdoc.CodDoc, AlmRCdoc.NroDoc, AlmRCdoc.Observ
DO:
  APPLY 'TAB':U.
  RETURN NO-APPLY.
END.

ON FIND OF AlmRCDoc 
DO:
    ASSIGN
        x-NomCli = fDescrip()
        x-CodAlm = fAlmacen().
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND AlmDCDoc WHERE almdcdoc.codcia = s-codcia
    AND almdcdoc.coddoc = AlmRCdoc.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    AND almdcdoc.nrodoc = AlmRCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
    AND almdcdoc.flgest = 'S'   /* Salida */ 
    EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Almdcdoc THEN UNDO, RETURN 'ADM-ERROR'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    AlmRCDoc.codcia = s-codcia
    AlmRCDoc.usuario = FILL-IN-Usuario
    AlmRCDoc.codalm = FILL-IN-CodAlm
    AlmRCDoc.fecha   = TODAY
    AlmRCDoc.hora    = STRING(TIME, 'HH:MM').
  ASSIGN
    AlmDCdoc.FchRet = AlmRCDoc.Fecha
    AlmDCdoc.HorRet = AlmRCDoc.Hora
    AlmDCdoc.ObsRet = AlmRCDoc.Observ
    AlmDCdoc.FlgEst = 'R'.
  RELEASE AlmDCDoc.
  
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
/*  DEF VAR RPTA AS CHAR INIT 'ERROR'.
 *   FIND Almacen WHERE 
 *     Almacen.CodCia = S-CODCIA AND
 *     Almacen.CodAlm = S-CODALM NO-LOCK NO-ERROR.
 *   RUN ALM/D-CLAVE (Almacen.Clave, OUTPUT RPTA).
 *   IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
 * */
  FIND AlmDCDoc WHERE almdcdoc.codcia = AlmRCdoc.codcia
    AND almdcdoc.coddoc = AlmRCdoc.CodDoc
    AND almdcdoc.nrodoc = AlmRCdoc.NroDoc
    AND almdcdoc.flgest = 'R' 
    AND almdcdoc.fchret = almrcdoc.fecha
    AND almdcdoc.horret = almrcdoc.hora
    EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Almdcdoc 
  THEN DO:
    MESSAGE 'No se encontro la salida del documento'
        VIEW-AS ALERT-BOX ERROR.
    UNDO, RETURN 'ADM-ERROR'.
  END.

  DEF VAR RPTA AS CHAR INIT 'ERROR'.
  FIND Almacen WHERE 
    Almacen.CodCia = S-CODCIA AND
    Almacen.CodAlm = S-CODALM NO-LOCK NO-ERROR.
  /*RUN lib/_CLAVE01 (Almacen.Clave,OUTPUT RPTA).*/
  RUN lib/_CLAVE3 (Almacen.Clave,OUTPUT RPTA).
  IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    almdcdoc.fchret = ?
    almdcdoc.horret = ''
    almdcdoc.flgest = 'S'.
  RELEASE almdcdoc.
  
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
        AlmRCdoc.CodDoc:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO. 
        AlmRCdoc.NroDoc:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO. 
        AlmRCdoc.Bultos:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO. 
        AlmRCdoc.Observ:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO.
        APPLY 'ENTRY':U TO AlmRCdoc.CodDoc.
    END.
    ELSE DO:
        AlmRCdoc.CodDoc:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES. 
        AlmRCdoc.NroDoc:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES. 
        AlmRCdoc.Bultos:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES. 
        APPLY 'ENTRY':U TO AlmRCdoc.Observ.
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
  {src/adm/template/snd-list.i "AlmRCDoc"}

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
/*
  /* CONSISTENCIA DEL DOCUMENTO */
  CASE Almrcdoc.coddoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}:
  WHEN 'FAC' OR WHEN 'BOL' THEN DO:
    FIND CcbCDocu WHERE ccbcdocu.codcia = s-codcia
      AND ccbcdocu.coddoc = AlmRCdoc.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      AND ccbcdocu.nrodoc = AlmRCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ccbcdocu
    THEN DO:
      MESSAGE 'Documento NO registrado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
    END.
    IF ccbcdocu.flgest = 'A'
    THEN DO:
      MESSAGE 'El documento esta ANULADO' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
    END.
  END.
  WHEN 'G/R' THEN DO:
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
                AND almcmov.nroser = INTEGER(SUBSTRING(almrcdoc.nrodoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},1,3))
                AND almcmov.nrodoc = INTEGER(SUBSTRING(almrcdoc.nrodoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},4))
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almcmov 
            THEN DO:
                x-Ok = YES.
                LEAVE RASTREA.
            END.
        END.
    END.
    IF x-Ok = NO
    THEN DO:
      MESSAGE 'Documento NO registrado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
    END.
    IF almcmov.flgest = 'A'
    THEN DO:
      MESSAGE 'El documento esta ANULADO' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
    END.
  END.
  OTHERWISE DO:
    MESSAGE 'Documento NO valido' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  END CASE.
*/

  /* CONSISTENCIA DEL DOCUMENTO */
  CASE Almrcdoc.coddoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}:
      WHEN 'FAC' OR WHEN 'BOL' OR WHEN 'G/R' THEN DO:
          FIND CcbCDocu WHERE ccbcdocu.codcia = s-codcia
              AND ccbcdocu.coddoc = Almrcdoc.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
              AND ccbcdocu.nrodoc = Almrcdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE ccbcdocu THEN DO:
              /*BUSCA OTRO CAMINO*/
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
                          AND almcmov.nroser = INTEGER(SUBSTRING(Almrcdoc.nrodoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},1,3))
                          AND almcmov.nrodoc = INTEGER(SUBSTRING(Almrcdoc.nrodoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},4))
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

  
  
/*  /* NO SE PUEDE REPETIR EL DOCUMENTO */
 *   RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
 *   IF RETURN-VALUE = 'YES'
 *   THEN DO:
 *     FIND LAST B-DCDOC WHERE b-dcdoc.codcia = s-codcia
 *         AND b-dcdoc.coddoc = AlmRCdoc.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
 *         AND b-dcdoc.nrodoc = AlmRCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
 *         NO-LOCK NO-ERROR.
 *     IF AVAILABLE B-DCDOC
 *     THEN DO:
 *         MESSAGE 'El documento ya fue registrado con el usuario' b-dcdoc.usuario SKIP
 *             'el dia' b-dcdoc.fecha 'y hora' b-dcdoc.hora 'almacen' b-dcdoc.codalm
 *             VIEW-AS ALERT-BOX ERROR.
 *         RETURN 'ADM-ERROR'.
 *     END.
 *   END.*/
  /* DOCUMENTO DEBE HABER SALIDO DE LA EMPRESA */
  FIND AlmDCDoc WHERE almdcdoc.codcia = s-codcia
    AND almdcdoc.coddoc = AlmRCdoc.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    AND almdcdoc.nrodoc = AlmRCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
    AND almdcdoc.flgest = 'S' NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almdcdoc
  THEN DO:
    MESSAGE 'El documento aún no ha salido de la empresa'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
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
/*MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.*/
  RETURN "OK".

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
/*   IF NOT AVAILABLE AlmRCDoc THEN RETURN ''.                                      */
/*   CASE almrcdoc.coddoc:                                                          */
/*     WHEN 'FAC' OR WHEN 'BOL' THEN DO:                                            */
/*         FIND CcbCDocu WHERE ccbcdocu.codcia = almrcdoc.codcia                    */
/*             AND ccbcdocu.coddoc = almrcdoc.coddoc                                */
/*             AND ccbcdocu.nrodoc = almrcdoc.nrodoc                                */
/*             NO-LOCK NO-ERROR.                                                    */
/*         IF AVAILABLE Ccbcdocu THEN RETURN ccbcdocu.codalm.                       */
/*     END.                                                                         */
/*     WHEN 'G/R' THEN DO:                                                          */
/*         FOR EACH AlmTMovm WHERE almtmovm.codcia = s-codcia                       */
/*                 AND almtmovm.tipmov = 'S'                                        */
/*                 AND almtmovm.reqguia = YES NO-LOCK:                              */
/*             FOR EACH Almacen WHERE Almacen.codcia = s-codcia NO-LOCK:            */
/*                 FIND Almcmov WHERE almcmov.codcia = s-codcia                     */
/*                     AND almcmov.codalm = almacen.codalm                          */
/*                     AND almcmov.tipmov = almtmovm.tipmov                         */
/*                     AND almcmov.codmov = almtmovm.codmov                         */
/*                     AND almcmov.flgest <> 'A'                                    */
/*                     AND almcmov.nroser = INTEGER(SUBSTRING(almrcdoc.nrodoc,1,3)) */
/*                     AND almcmov.nrodoc = INTEGER(SUBSTRING(almrcdoc.nrodoc,4))   */
/*                     NO-LOCK NO-ERROR.                                            */
/*                 IF AVAILABLE Almcmov THEN RETURN almcmov.codalm.                 */
/*             END.                                                                 */
/*         END.                                                                     */
/*     END.                                                                         */
/*   END CASE.                                                                      */
/*   RETURN "".   /* Function return value. */                                      */


  IF NOT AVAILABLE AlmRCdoc THEN RETURN ''.
  CASE AlmRCdoc.coddoc:
    WHEN 'FAC' OR WHEN 'BOL' OR WHEN 'G/R' THEN DO:
        FIND CcbCDocu WHERE ccbcdocu.codcia = AlmRCdoc.codcia
            AND ccbcdocu.coddoc = AlmRCdoc.coddoc
            AND ccbcdocu.nrodoc = AlmRCdoc.nrodoc
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
                        AND almcmov.nroser = INTEGER(SUBSTRING(AlmRCdoc.nrodoc,1,3))
                        AND almcmov.nrodoc = INTEGER(SUBSTRING(AlmRCdoc.nrodoc,4))
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
/*   IF NOT AVAILABLE AlmRCDoc THEN RETURN ''.                                      */
/*   CASE almrcdoc.coddoc:                                                          */
/*     WHEN 'FAC' OR WHEN 'BOL' THEN DO:                                            */
/*         FIND CcbCDocu WHERE ccbcdocu.codcia = almrcdoc.codcia                    */
/*             AND ccbcdocu.coddoc = almrcdoc.coddoc                                */
/*             AND ccbcdocu.nrodoc = almrcdoc.nrodoc                                */
/*             NO-LOCK NO-ERROR.                                                    */
/*         IF AVAILABLE Ccbcdocu THEN RETURN ccbcdocu.nomcli.                       */
/*     END.                                                                         */
/*     WHEN 'G/R' THEN DO:                                                          */
/*         FOR EACH AlmTMovm WHERE almtmovm.codcia = s-codcia                       */
/*             AND almtmovm.tipmov = 'S'                                            */
/*             AND almtmovm.reqguia = YES NO-LOCK:                                  */
/*             FOR EACH Almacen WHERE Almacen.codcia = s-codcia NO-LOCK:            */
/*                 FIND Almcmov WHERE almcmov.codcia = s-codcia                     */
/*                     AND almcmov.codalm = almacen.codalm                          */
/*                     AND almcmov.tipmov = almtmovm.tipmov                         */
/*                     AND almcmov.codmov = almtmovm.codmov                         */
/*                     AND almcmov.flgest <> 'A'                                    */
/*                     AND almcmov.nroser = INTEGER(SUBSTRING(almrcdoc.nrodoc,1,3)) */
/*                     AND almcmov.nrodoc = INTEGER(SUBSTRING(almrcdoc.nrodoc,4))   */
/*                     NO-LOCK NO-ERROR.                                            */
/*                 IF AVAILABLE Almcmov THEN RETURN almcmov.NomRef.                 */
/*             END.                                                                 */
/*         END.                                                                     */
/*     END.                                                                         */
/*   END CASE.                                                                      */
/*   RETURN "".   /* Function return value. */                                      */


  IF NOT AVAILABLE AlmRCdoc THEN RETURN ''.
  CASE AlmRCdoc.coddoc:
    WHEN 'FAC' OR WHEN 'BOL' OR WHEN 'G/R'THEN DO:
        FIND CcbCDocu WHERE ccbcdocu.codcia = AlmRCdoc.codcia
            AND ccbcdocu.coddoc = AlmRCdoc.coddoc
            AND ccbcdocu.nrodoc = AlmRCdoc.nrodoc
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
                        AND almcmov.nroser = INTEGER(SUBSTRING(AlmRCdoc.nrodoc,1,3))
                        AND almcmov.nrodoc = INTEGER(SUBSTRING(AlmRCdoc.nrodoc,4))
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

