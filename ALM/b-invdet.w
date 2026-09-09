&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
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

DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR S-CODALM  AS CHAR.
DEFINE SHARED VAR S-DESALM  AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR.
DEFINE        VAR I-CODMAT  AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "APLIC\ALM\rbalm.prl".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Listado de Conteo".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "O".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

FIND LAST InvConfig WHERE InvConfig.CodCia = S-CODCIA 
                     AND  InvConfig.CodAlm = S-CODALM 
                    NO-LOCK NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES InvConDe InvRecDe Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table InvConDe.codmat Almmmatg.DesMat Almmmatg.DesMar Almmmatg.UndStk InvConDe.CanInv InvRecDe.CanInv   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table InvConDe.codmat ~
InvConDe.CanInv /*   InvRecDe.CanInv*/   
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}codmat ~{&FP2}codmat ~{&FP3}~
 ~{&FP1}CanInv ~{&FP2}CanInv ~{&FP3}~
 ~{&FP1}/* ~{&FP2}/* ~{&FP3}~
 ~{&FP1}CanInv*/ ~{&FP2}CanInv*/ ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table InvConDe InvRecDe
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table InvConDe
&Scoped-define SECOND-ENABLED-TABLE-IN-QUERY-br_table InvRecDe
&Scoped-define SELF-NAME br_table
&Scoped-define OPEN-QUERY-br_table IF I-TipIng = 2 THEN DO:     OPEN QUERY {&SELF-NAME} FOR EACH InvConDe WHERE ~{&KEY-PHRASE}           AND InvConDe.CodCia = S-CODCIA      AND InvConDe.CodAlm = S-CODALM      AND InvConDe.FchInv = D-FCHINV NO-LOCK, ~
                 EACH InvRecDe WHERE InvRecDe.CodCia = InvConDe.CodCia       AND InvRecDe.CodAlm = InvConDe.CodAlm       AND InvRecDe.FchInv = InvConDe.FchInv       AND InvRecDe.codmat = InvConDe.codmat NO-LOCK, ~
                 EACH Almmmatg OF InvConDe NO-LOCK         ~{&SORTBY-PHRASE}. END. ELSE DO:     OPEN QUERY {&SELF-NAME} FOR EACH InvConDe WHERE ~{&KEY-PHRASE}           AND InvConDe.CodCia = S-CODCIA      AND InvConDe.CodAlm = S-CODALM      AND InvConDe.FchInv = D-FCHINV      AND InvConDe.Responsable = S-USER-ID NO-LOCK, ~
                 EACH InvRecDe WHERE InvRecDe.CodCia = InvConDe.CodCia       AND InvRecDe.CodAlm = InvConDe.CodAlm       AND InvRecDe.FchInv = InvConDe.FchInv       AND InvRecDe.codmat = InvConDe.codmat NO-LOCK, ~
                 EACH Almmmatg OF InvConDe NO-LOCK         ~{&SORTBY-PHRASE}. END.
&Scoped-define TABLES-IN-QUERY-br_table InvConDe InvRecDe Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table InvConDe


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-6 RECT-7 br_table F-CodMat I-TipIng 
&Scoped-Define DISPLAYED-OBJECTS C-ALMCEN F-CodMat I-TipIng C-DESALM ~
D-FCHINV C-Respon 

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
DEFINE VARIABLE C-ALMCEN AS CHARACTER FORMAT "X(3)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 6.29 BY .69 NO-UNDO.

DEFINE VARIABLE C-DESALM AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.43 BY .69 NO-UNDO.

DEFINE VARIABLE C-Respon AS CHARACTER FORMAT "X(256)":U 
     LABEL "Responsable" 
     VIEW-AS FILL-IN 
     SIZE 14.14 BY .69 NO-UNDO.

DEFINE VARIABLE D-FCHINV AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de Inventario" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .69 NO-UNDO.

DEFINE VARIABLE F-CodMat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Codigo" 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .69 NO-UNDO.

DEFINE VARIABLE I-TipIng AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Por  Responsable", 1,
"Todos en General", 2
     SIZE 17.14 BY 1.19 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.57 BY 3.19.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 35.43 BY 1.62.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      InvConDe, 
      InvRecDe, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      InvConDe.codmat COLUMN-LABEL "Codigo!Articulo"
      Almmmatg.DesMat FORMAT "X(55)"
      Almmmatg.DesMar FORMAT "X(10)"
      Almmmatg.UndStk FORMAT "X(6)"
      InvConDe.CanInv COLUMN-LABEL "Cantidad!Conteo" FORMAT ">>>,>>>,>>9.99"
      InvRecDe.CanInv COLUMN-LABEL "Cantidad!Reconteo" FORMAT ">>>,>>>,>>9.99"
  ENABLE
      InvConDe.codmat
      InvConDe.CanInv
/*      InvRecDe.CanInv*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 86.86 BY 11.77
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 4.35 COL 1
     C-ALMCEN AT ROW 1.27 COL 6.86 COLON-ALIGNED
     F-CodMat AT ROW 2.96 COL 6.57 COLON-ALIGNED
     I-TipIng AT ROW 2.69 COL 20.72 NO-LABEL
     C-DESALM AT ROW 1.27 COL 14.72 COLON-ALIGNED NO-LABEL
     D-FCHINV AT ROW 1.27 COL 72.57 COLON-ALIGNED
     C-Respon AT ROW 2.12 COL 70.57 COLON-ALIGNED
     RECT-6 AT ROW 1 COL 1.29
     RECT-7 AT ROW 2.46 COL 2.72
     "Buscar" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2.35 COL 4.29
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 15.12
         WIDTH              = 87.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Custom                                       */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN C-ALMCEN IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN C-DESALM IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN C-Respon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN D-FCHINV IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
IF I-TipIng = 2 THEN DO:
    OPEN QUERY {&SELF-NAME} FOR EACH InvConDe WHERE ~{&KEY-PHRASE}
          AND InvConDe.CodCia = S-CODCIA
     AND InvConDe.CodAlm = S-CODALM
     AND InvConDe.FchInv = D-FCHINV NO-LOCK,
          EACH InvRecDe WHERE InvRecDe.CodCia = InvConDe.CodCia
      AND InvRecDe.CodAlm = InvConDe.CodAlm
      AND InvRecDe.FchInv = InvConDe.FchInv
      AND InvRecDe.codmat = InvConDe.codmat NO-LOCK,
          EACH Almmmatg OF InvConDe NO-LOCK
        ~{&SORTBY-PHRASE}.
END.
ELSE DO:
    OPEN QUERY {&SELF-NAME} FOR EACH InvConDe WHERE ~{&KEY-PHRASE}
          AND InvConDe.CodCia = S-CODCIA
     AND InvConDe.CodAlm = S-CODALM
     AND InvConDe.FchInv = D-FCHINV
     AND InvConDe.Responsable = S-USER-ID NO-LOCK,
          EACH InvRecDe WHERE InvRecDe.CodCia = InvConDe.CodCia
      AND InvRecDe.CodAlm = InvConDe.CodAlm
      AND InvRecDe.FchInv = InvConDe.FchInv
      AND InvRecDe.codmat = InvConDe.codmat NO-LOCK,
          EACH Almmmatg OF InvConDe NO-LOCK
        ~{&SORTBY-PHRASE}.
END.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "integral.InvConDe.CodCia = S-CODCIA
 AND integral.InvConDe.CodAlm = S-CODALM
 AND integral.InvConDe.FchInv = 10/25/1999"
     _JoinCode[2]      = "integral.InvRecDe.CodCia = integral.InvConDe.CodCia
  AND integral.InvRecDe.CodAlm = integral.InvConDe.CodAlm
  AND integral.InvRecDe.FchInv = integral.InvConDe.FchInv
  AND integral.InvRecDe.codmat = integral.InvConDe.codmat"
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
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


&Scoped-define SELF-NAME F-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodMat B-table-Win
ON LEAVE OF F-CodMat IN FRAME F-Main /* Codigo */
DO:
  IF INTEGER(SELF:SCREEN-VALUE) = 0 THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
  ASSIGN F-CodMat.

  FIND InvConDe WHERE InvConDe.CodCia = S-CODCIA AND
                       InvConDe.CodAlm = S-CODALM AND
                       InvConDe.FchInv = D-FCHINV AND
                       InvConDe.CodMat = F-CodMat 
                       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE InvConDe THEN DO:
     MESSAGE "Articulo no registrado ...."
     VIEW-AS ALERT-BOX.
     APPLY "ENTRY" TO F-Codmat.
     RETURN NO-APPLY.
  END.
  IF AVAILABLE InvConDe THEN OUTPUT-VAR-1 = ROWID(InvConDe).
  IF OUTPUT-VAR-1 <> ? THEN DO:
     FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
          ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
          NO-LOCK NO-ERROR.
     IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
        REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
     END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME I-TipIng
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-TipIng B-table-Win
ON VALUE-CHANGED OF I-TipIng IN FRAME F-Main
DO:
  ASSIGN I-TipIng.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */
/* DEFINICION DE TRIGGERS */
ON "RETURN":U OF InvConDe.CodMat,InvConDe.CanInv DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.

ON "F8":U OF InvConDe.Codmat DO:
    input-var-1 = S-CODALM.
    input-var-2 = InvConDe.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
    FIND Almtfami WHERE Almtfami.codcia = S-CODCIA 
                   AND  Almtfami.codfam = input-var-2  
                  NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtfami THEN input-var-2 = ''.
    RUN lkup\c-catart.r ('Articulos por Almacen').
    IF output-var-1 <> ? THEN
       InvConDe.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = output-var-2.
END.

ON "MOUSE-SELECT-DBLCLICK":U OF InvConDe.Codmat
DO:
    input-var-1 = S-CODALM.
    input-var-2 = InvConDe.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
    FIND Almtfami WHERE Almtfami.codcia = S-CODCIA 
                   AND  Almtfami.codfam = input-var-2  
                  NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtfami THEN input-var-2 = ''.
    RUN lkup\c-catart.r ('Articulos por Almacen').
    IF output-var-1 <> ? THEN
       InvConDe.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = output-var-2.
END.

ON "LEAVE":U OF InvConDe.CodMat DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
   FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                  AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Almmmatg THEN DO:
      MESSAGE "Codigo de material no existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO InvConDe.CodMat IN BROWSE {&BROWSE-NAME}.
      RETURN NO-APPLY.
   END.
   IF Almmmatg.TpoArt <> "A" THEN DO:
      MESSAGE "Codigo de material Desactivado" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO InvConDe.CodMat IN BROWSE {&BROWSE-NAME}.
      RETURN NO-APPLY.
   END.
   
   DISPLAY Almmmatg.DesMat 
           Almmmatg.DesMar
           Almmmatg.UndStk WITH BROWSE {&BROWSE-NAME}.
END.

ON "LEAVE":U OF InvConDe.CanInv DO:

   FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
                       Almmmatg.codmat = InvConDe.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                       NO-LOCK NO-ERROR.
        FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas AND
                           Almtconv.Codalter = Almmmatg.UndStk:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                           NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN DO:
           MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
        END.
        IF (Almtconv.CodUnid = "Und" OR Almtconv.CodUnid = "UNI" ) AND Almtconv.Equival = 1 THEN DO:
           IF DECIMAL(InvConDe.CanInv:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <> INT(InvConDe.CanInv:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) THEN DO:
              MESSAGE " Cantidad No Debe Tener Decimales " SKIP
                     VIEW-AS ALERT-BOX ERROR.
              RETURN NO-APPLY.
           END.   
        END. 
END.



&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

DO WITH FRAME {&FRAME-NAME}:
   FIND LAST InvConfig WHERE InvConfig.CodCia = S-CODCIA 
                        AND  InvConfig.CodAlm = S-CODALM 
                       NO-LOCK NO-ERROR.
   IF AVAILABLE InvConfig THEN ASSIGN D-FCHINV = InvConfig.FchInv.
   ASSIGN  C-ALMCEN = S-CODALM
           C-DESALM = S-DESALM
           C-Respon = S-USER-ID.
   DISPLAY C-ALMCEN 
           C-DESALM 
           C-Respon 
           D-FCHINV. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win _DEFAULT-DISABLE
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
  ASSIGN InvConDe.CodCia      = S-CODCIA
         InvConDe.CodAlm      = S-CODALM
         InvConDe.FchInv      = D-FCHINV
         InvConDe.Responsable = S-USER-ID
         
         InvRecDe.CodCia      = S-CODCIA
         InvRecDe.CodAlm      = S-CODALM
         InvRecDe.FchInv      = D-FCHINV
         InvRecDe.codmat      = InvConDe.codmat
         InvRecDe.CanInv      = InvConDe.CanInv
         InvRecDe.Responsable = S-USER-ID         
         .

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime B-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

/*ML3* 08/11/07 ***
    RB-FILTER = "InvConDe.CodCia = " + STRING(S-CODCIA) +
                " AND InvConDe.CodAlm = '" + S-CODALM + "'".
    IF I-TipIng = 2 THEN
       RB-FILTER = RB-FILTER + " AND InvConDe.Responsable = '" + S-USER-ID + "'".

    DO WITH FRAME {&FRAME-NAME}:
       RB-OTHER-PARAMETERS = "GsNomCia = " + S-NOMCIA + 
                           "~nGsTitulo = " + S-CODALM + "-" + S-DESALM + 
                           "~nGsInventario = " + D-FCHINV:SCREEN-VALUE.
    END.
                            
    RUN lib\_imprime.r(RB-REPORT-LIBRARY, RB-REPORT-NAME,
        RB-INCLUDE-RECORDS, RB-FILTER, RB-OTHER-PARAMETERS).                            
* ***/

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
        WHEN "CodMat" THEN ASSIGN input-var-1 = S-CODALM.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "InvConDe"}
  {src/adm/template/snd-list.i "InvRecDe"}
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  EN CASO DE ERROR RETORNAR : RETURN "ADM-ERROR"
------------------------------------------------------------------------------*/
ASSIGN I-CODMAT = InvConDe.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
               AND  Almmmatg.CodMat = I-CODMAT 
              NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
   MESSAGE "Codigo de material no existe" VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY" TO InvConDe.CodMat.
   RETURN "ADM-ERROR".   
END.
FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
               AND  Almmmate.CodAlm = S-CODALM 
               AND  Almmmate.CodMat = I-CODMAT 
              NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmate THEN DO:
   MESSAGE "Material no asignado a este Almacen" VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY" TO InvConDe.CodMat.
   RETURN "ADM-ERROR".   
END.
IF (DECIMAL(InvConDe.CanInv:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) < 0) 
   THEN DO:
   MESSAGE "Las Cantidades deben ser mayor o igual a cero" VIEW-AS ALERT-BOX ERROR.
   IF DECIMAL(InvConDe.CanInv:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN
       APPLY "ENTRY" TO InvConDe.CanInv.
   ELSE 
       APPLY "ENTRY" TO InvRecDe.CanInv.
   RETURN "ADM-ERROR".   
END.
/*IF DECIMAL(InvConDe.CanInv:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) /*<> 
 *    DECIMAL(InvRecDe.CanInv:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})*/
 *    THEN DO:
 *    MESSAGE "La Cantidad de Conteo y Reconteo" SKIP
 *            "deben de ser iguales" SKIP
 *             VIEW-AS ALERT-BOX ERROR.
 *    APPLY "ENTRY" TO InvConDe.CanInv.
 *    RETURN "ADM-ERROR".   
 * END.
 * */
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
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


