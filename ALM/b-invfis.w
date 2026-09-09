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

DEFINE FRAME F-Mensajes
     /*IMAGE-1 AT ROW 1.5 COL 5*/
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16
          FONT 8
     "por favor..." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19
          FONT 8
     "F10 = Cancela Reporte" VIEW-AS TEXT
          SIZE 21 BY 1 AT ROW 3.5 COL 12
          FONT 8          
    SPACE(10.28) SKIP(0.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
        BGCOLOR 15 FGCOLOR 0 TITLE "Cargando...".

DEF TEMP-TABLE t-conteo LIKE InvConteo.
DEF TEMP-TABLE t-recont LIKE InvRecont.
DEF TEMP-TABLE t-captura 
    FIELD codmat LIKE invconteo.codmat
    FIELD canbien LIKE invconteo.canbien
    FIELD canmal  LIKE invconteo.canmal.

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
&Scoped-define INTERNAL-TABLES InvConteo InvRecont Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table InvConteo.codmat Almmmatg.DesMat Almmmatg.DesMar Almmmatg.UndStk InvRecont.CanBien InvRecont.CanMal InvConteo.CanInv InvRecont.CanInv   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table InvConteo.codmat ~
InvRecont.CanBien ~
InvRecont.CanMal  /*   InvConteo.CanInv ~
InvRecont.CanInv*/   
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table InvConteo InvRecont
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table InvConteo
&Scoped-define SECOND-ENABLED-TABLE-IN-QUERY-br_table InvRecont
&Scoped-define SELF-NAME br_table
&Scoped-define OPEN-QUERY-br_table IF I-TipIng = 2 THEN DO:     OPEN QUERY {&SELF-NAME} FOR EACH InvConteo WHERE ~{&KEY-PHRASE}           AND InvConteo.CodCia = S-CODCIA      AND InvConteo.CodAlm = S-CODALM      AND InvConteo.FchInv = D-FCHINV NO-LOCK, ~
                 EACH InvRecont WHERE InvRecont.CodCia = InvConteo.CodCia       AND InvRecont.CodAlm = InvConteo.CodAlm       AND InvRecont.FchInv = InvConteo.FchInv       AND InvRecont.codmat = InvConteo.codmat NO-LOCK, ~
                 EACH Almmmatg OF InvConteo NO-LOCK         ~{&SORTBY-PHRASE}. END. ELSE DO:     OPEN QUERY {&SELF-NAME} FOR EACH InvConteo WHERE ~{&KEY-PHRASE}           AND InvConteo.CodCia = S-CODCIA      AND InvConteo.CodAlm = S-CODALM      AND InvConteo.FchInv = D-FCHINV      AND InvConteo.Responsable = S-USER-ID NO-LOCK, ~
                 EACH InvRecont WHERE InvRecont.CodCia = InvConteo.CodCia       AND InvRecont.CodAlm = InvConteo.CodAlm       AND InvRecont.FchInv = InvConteo.FchInv       AND InvRecont.codmat = InvConteo.codmat NO-LOCK, ~
                 EACH Almmmatg OF InvConteo NO-LOCK         ~{&SORTBY-PHRASE}. END.
&Scoped-define TABLES-IN-QUERY-br_table InvConteo InvRecont Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table InvConteo
&Scoped-define SECOND-TABLE-IN-QUERY-br_table InvRecont
&Scoped-define THIRD-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-6 RECT-7 BUTTON-5 I-TipIng BUTTON-4 ~
F-CodMat br_table 
&Scoped-Define DISPLAYED-OBJECTS C-ALMCEN C-DESALM D-FCHINV C-Respon ~
I-TipIng F-CodMat 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD _Estado B-table-Win 
FUNCTION _Estado RETURNS CHARACTER
   ( INPUT pFlgEst AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img\excel":U
     LABEL "Button 4" 
     SIZE 5 BY 1.35 TOOLTIP "Migrar a Excel".

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img/tbldef.ico":U
     LABEL "Button 5" 
     SIZE 6 BY 1.62 TOOLTIP "Capturar Texto".

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
     SIZE 87 BY 3.46.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 35.43 BY 1.62.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      InvConteo, 
      InvRecont, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      InvConteo.codmat  COLUMN-LABEL "Codigo!Articulo"
      Almmmatg.DesMat   FORMAT "X(55)"
      Almmmatg.DesMar   FORMAT "X(10)"
      Almmmatg.UndStk   FORMAT "X(6)"
      InvRecont.CanBien COLUMN-LABEL "Cantidad!Buena" FORMAT ">>>,>>>,>>9.99" COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 7 
      InvRecont.CanMal  COLUMN-LABEL "Cantidad!Mala" FORMAT ">>>,>>>,>>9.99"  COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 4
      InvConteo.CanInv  COLUMN-LABEL "Cantidad!Conteo" FORMAT ">>>,>>>,>>9.99"
      InvRecont.CanInv  COLUMN-LABEL "Cantidad!Reconteo" FORMAT ">>>,>>>,>>9.99"
      
  ENABLE
      InvConteo.codmat
      InvRecont.CanBien 
      InvRecont.CanMal  
/*      InvConteo.CanInv
      InvRecont.CanInv*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 107 BY 11.77
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-5 AT ROW 1.54 COL 91 WIDGET-ID 2
     C-ALMCEN AT ROW 1.58 COL 8 COLON-ALIGNED
     C-DESALM AT ROW 1.58 COL 15 COLON-ALIGNED NO-LABEL
     D-FCHINV AT ROW 1.58 COL 73 COLON-ALIGNED
     C-Respon AT ROW 2.54 COL 71 COLON-ALIGNED
     I-TipIng AT ROW 2.92 COL 21 NO-LABEL
     BUTTON-4 AT ROW 3.15 COL 91
     F-CodMat AT ROW 3.31 COL 9 COLON-ALIGNED
     br_table AT ROW 4.85 COL 2
     "Buscar" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2.54 COL 6
     RECT-6 AT ROW 1.19 COL 2
     RECT-7 AT ROW 2.73 COL 4
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
         HEIGHT             = 16.35
         WIDTH              = 110.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table F-CodMat F-Main */
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
    OPEN QUERY {&SELF-NAME} FOR EACH InvConteo WHERE ~{&KEY-PHRASE}
          AND InvConteo.CodCia = S-CODCIA
     AND InvConteo.CodAlm = S-CODALM
     AND InvConteo.FchInv = D-FCHINV NO-LOCK,
          EACH InvRecont WHERE InvRecont.CodCia = InvConteo.CodCia
      AND InvRecont.CodAlm = InvConteo.CodAlm
      AND InvRecont.FchInv = InvConteo.FchInv
      AND InvRecont.codmat = InvConteo.codmat NO-LOCK,
          EACH Almmmatg OF InvConteo NO-LOCK
        ~{&SORTBY-PHRASE}.
END.
ELSE DO:
    OPEN QUERY {&SELF-NAME} FOR EACH InvConteo WHERE ~{&KEY-PHRASE}
          AND InvConteo.CodCia = S-CODCIA
     AND InvConteo.CodAlm = S-CODALM
     AND InvConteo.FchInv = D-FCHINV
     AND InvConteo.Responsable = S-USER-ID NO-LOCK,
          EACH InvRecont WHERE InvRecont.CodCia = InvConteo.CodCia
      AND InvRecont.CodAlm = InvConteo.CodAlm
      AND InvRecont.FchInv = InvConteo.FchInv
      AND InvRecont.codmat = InvConteo.codmat NO-LOCK,
          EACH Almmmatg OF InvConteo NO-LOCK
        ~{&SORTBY-PHRASE}.
END.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "integral.InvConteo.CodCia = S-CODCIA
 AND integral.InvConteo.CodAlm = S-CODALM
 AND integral.InvConteo.FchInv = 10/25/1999"
     _JoinCode[2]      = "integral.InvRecont.CodCia = integral.InvConteo.CodCia
  AND integral.InvRecont.CodAlm = integral.InvConteo.CodAlm
  AND integral.InvRecont.FchInv = integral.InvConteo.FchInv
  AND integral.InvRecont.codmat = integral.InvConteo.codmat"
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


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 B-table-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
    SESSION:SET-WAIT-STATE("GENERAL").
    RUN Excel.
    SESSION:SET-WAIT-STATE("").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 B-table-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 5 */
DO:
  RUN Capturar-Texto.
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

  FIND InvConteo WHERE InvConteo.CodCia = S-CODCIA AND
                       InvConteo.CodAlm = S-CODALM AND
                       InvConteo.FchInv = D-FCHINV AND
                       InvConteo.CodMat = F-CodMat 
                       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE InvConteo THEN DO:
     MESSAGE "Articulo no registrado ...."
     VIEW-AS ALERT-BOX.
     APPLY "ENTRY" TO F-Codmat.
     RETURN NO-APPLY.
  END.
  IF AVAILABLE InvConteo THEN OUTPUT-VAR-1 = ROWID(InvConteo).
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
ON "RETURN":U OF InvConteo.CodMat, InvRecont.CanBien, InvRecont.CanMal /*InvConteo.CanInv*/ DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.

ON "F8":U OF InvConteo.Codmat DO:
    input-var-1 = S-CODALM.
    input-var-2 = InvConteo.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
    FIND Almtfami WHERE Almtfami.codcia = S-CODCIA 
                   AND  Almtfami.codfam = input-var-2  
                  NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtfami THEN input-var-2 = ''.
    RUN lkup\c-catart.r ('Articulos por Almacen').
    IF output-var-1 <> ? THEN
       InvConteo.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = output-var-2.
END.

ON "MOUSE-SELECT-DBLCLICK":U OF InvConteo.Codmat
DO:
    input-var-1 = S-CODALM.
    input-var-2 = InvConteo.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
    FIND Almtfami WHERE Almtfami.codcia = S-CODCIA 
                   AND  Almtfami.codfam = input-var-2  
                  NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtfami THEN input-var-2 = ''.
    RUN lkup\c-catart.r ('Articulos por Almacen').
    IF output-var-1 <> ? THEN
       InvConteo.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = output-var-2.
END.

ON "LEAVE":U OF InvConteo.CodMat DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
   FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                  AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Almmmatg THEN DO:
      MESSAGE "Codigo de material no existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO InvConteo.CodMat IN BROWSE {&BROWSE-NAME}.
      RETURN NO-APPLY.
   END.
   IF Almmmatg.TpoArt <> "A" THEN DO:
      MESSAGE "Codigo de material Desactivado" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO InvConteo.CodMat IN BROWSE {&BROWSE-NAME}.
      RETURN NO-APPLY.
   END.
   
   DISPLAY Almmmatg.DesMat 
           Almmmatg.DesMar
           Almmmatg.UndStk WITH BROWSE {&BROWSE-NAME}.
END.

ON "LEAVE":U OF InvConteo.CanInv DO:

   FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
                       Almmmatg.codmat = InvConteo.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                       NO-LOCK NO-ERROR.
        FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas AND
                           Almtconv.Codalter = Almmmatg.UndStk:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                           NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN DO:
           MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
        END.
        IF (Almtconv.CodUnid = "Und" OR Almtconv.CodUnid = "UNI" ) AND Almtconv.Equival = 1 THEN DO:
           IF DECIMAL(InvConteo.CanInv:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <> INT(InvConteo.CanInv:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) THEN DO:
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Capturar-Texto B-table-Win 
PROCEDURE Capturar-Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR pOpcion AS INT NO-UNDO.

MESSAGE 'El archivo texto debe tener solo dos columnas' SKIP
    'La primera columna debe ser el artículo' SKIP
    'La segunda columna debe ser la cantidad en bun estado' SKIP
    'La tercera columna debe ser la cantidad en mal estado' SKIP
    'Por ejemplo:' skip(1)
    '000150     12.00   35.00' SKIP
    '004443    125.50    0.00' SKIP(1)
    'Continuamos?' VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
    UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.
RUN alm/d-invfis (OUTPUT pOpcion).
IF pOPcion = 0 THEN RETURN.

DEF VAR x-Archivo AS CHAR NO-UNDO.

SYSTEM-DIALOG GET-FILE x-archivo FILTERS '*.txt *.prn' '*.txt,*.prn'
    INITIAL-FILTER 1 RETURN-TO-START-DIR TITLE 'Seleccione el archivo a importar'
    UPDATE rpta.

IF rpta = NO THEN RETURN.

FOR EACH t-conteo:
    DELETE t-conteo.                   
END.

FOR EACH t-recont:
    DELETE t-recont.
END.

FOR EACH t-captura:
    DELETE t-captura.                   
END.

INPUT FROM VALUE(x-archivo).
REPEAT:
    CREATE t-captura.
    IMPORT t-captura NO-ERROR.
END.
INPUT CLOSE.

FOR EACH t-captura WHERE t-captura.codmat <> '':
    CREATE t-conteo.
    ASSIGN
        t-conteo.CanBien = t-captura.canbien
        t-conteo.CanInv  = t-captura.canbien + t-captura.canmal
        t-conteo.CanMal  = t-captura.canmal
        t-conteo.CodAlm  = s-codalm
        t-conteo.CodCia  = s-codcia
        t-conteo.codmat  = t-captura.codmat
        t-conteo.FchInv  = d-fchinv
        /*t-conteo.NroTal */
        t-conteo.Responsable = s-user-id
        NO-ERROR.
    CREATE t-recont.
    BUFFER-COPY t-conteo TO t-recont.
END.

/* cargamos información */
CASE pOpcion:
    WHEN 1 THEN DO:     /* SOLO nuevos */
        FOR EACH t-conteo:                                        
            FIND invconteo OF t-conteo NO-LOCK NO-ERROR.
            IF NOT AVAILABLE invconteo THEN DO:
                CREATE invconteo.
                BUFFER-COPY t-conteo TO invconteo.
            END.
        END.
        FOR EACH t-recont:
            FIND invrecont OF t-recont NO-LOCK NO-ERROR.
            IF NOT AVAILABLE invrecont THEN DO:
                CREATE invrecont.
                BUFFER-COPY t-recont TO invrecont.
            END.
        END.
    END.
    WHEN 2 THEN DO:     /* NUEVOS y ACTUALIZAR existentes */
        FOR EACH t-conteo:                                        
            FIND invconteo OF t-conteo EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE invconteo THEN DO:
                CREATE invconteo.
                BUFFER-COPY t-conteo TO invconteo.
            END.
            ELSE DO:
                BUFFER-COPY t-conteo TO invconteo.
            END.
        END.
        FOR EACH t-recont:
            FIND invrecont OF t-recont EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE invrecont THEN DO:
                CREATE invrecont.
                BUFFER-COPY t-recont TO invrecont.
            END.
            ELSE DO:
                BUFFER-COPY t-recont TO invrecont.
            END.
        END.
    END.
    WHEN 3 THEN DO:
        FOR EACH t-conteo:                                        
            FIND invconteo OF t-conteo EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE invconteo THEN DO:
                CREATE invconteo.
                BUFFER-COPY t-conteo TO invconteo.
            END.
            ELSE DO:
                ASSIGN
                    t-conteo.CanBien = t-conteo.CanBien + t-captura.canbien
                    t-conteo.CanInv  = t-conteo.CanInv + (t-captura.canbien + t-captura.canmal)
                    t-conteo.CanMal  = t-conteo.CanMal + t-captura.canmal
                    t-conteo.Responsable = s-user-id.
            END.
        END.
        FOR EACH t-recont:
            FIND invrecont OF t-recont EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE invrecont THEN DO:
                CREATE invrecont.
                BUFFER-COPY t-recont TO invrecont.
            END.
            ELSE DO:
                ASSIGN
                    t-recont.CanBien = t-recont.CanBien + t-captura.canbien
                    t-recont.CanInv  = t-recont.CanInv + (t-captura.canbien + t-captura.canmal)
                    t-recont.CanMal  = t-recont.CanMal + t-captura.canmal
                    t-recont.Responsable = s-user-id.
            END.
        END.
    END.
END CASE.
/* ******************** */
RUN adm-open-query.
MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel B-table-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Columns("A"):ColumnWidth = 11.
chWorkSheet:Columns("B"):ColumnWidth = 6.
chWorkSheet:Columns("C"):ColumnWidth = 48.
chWorkSheet:Columns("D"):ColumnWidth = 15.
chWorkSheet:Columns("E"):ColumnWidth = 6.
chWorkSheet:Columns("F"):ColumnWidth = 11.
chWorkSheet:Columns("G"):ColumnWidth = 10.
chWorkSheet:Columns("H"):ColumnWidth = 12.
chWorkSheet:Columns("I"):ColumnWidth = 14.

chWorkSheet:Range("A2: I2"):Font:Bold = TRUE.
chWorkSheet:Range("A2"):Value = "Responsable".
chWorkSheet:Range("B2"):Value = "Codigo".
chWorkSheet:Range("C2"):Value = "Descripción".
chWorkSheet:Range("D2"):Value = "Marca".
chWorkSheet:Range("E2"):Value = "Unidad".
chWorkSheet:Range("F2"):Value = "Cant. Buena".
chWorkSheet:Range("G2"):Value = "Cant. Mala".
chWorkSheet:Range("H2"):Value = "Cant. Conteo".
chWorkSheet:Range("I2"):Value = "Cant. Reconteo".

chWorkSheet = chExcelApplication:Sheets:Item(1).

/*GET FIRST {&BROWSE-NAME}.*/
loopREP:
FOR EACH InvConteo WHERE 
    InvConteo.CodCia = S-CODCIA AND 
    InvConteo.CodAlm = S-CODALM AND 
    InvConteo.FchInv = D-FCHINV NO-LOCK,
    EACH InvRecont WHERE 
        InvRecont.CodCia = InvConteo.CodCia AND 
        InvRecont.CodAlm = InvConteo.CodAlm AND 
        InvRecont.FchInv = InvConteo.FchInv AND 
        InvRecont.codmat = InvConteo.codmat NO-LOCK,
        EACH Almmmatg OF InvConteo NO-LOCK:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = InvConteo.Responsable.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = InvConteo.CodMat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.DesMat.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.DesMar.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.UndStk.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = InvRecont.CanBien.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = InvRecont.CanMal.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = InvConteo.CanInv.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = InvRecont.CanInv.
 /*   GET NEXT {&BROWSE-NAME}.*/
    
    DISPLAY
        InvConteo.Responsable + " " + InvConteo.CodMat
        FORMAT "X(15)" LABEL "   Procesando documento"
        WITH FRAME f-mensajes.
    READKEY PAUSE 0.
    IF LASTKEY = KEYCODE("F10") THEN LEAVE loopREP.

END.

HIDE FRAME f-mensajes NO-PAUSE.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

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
  DEFINE VARIABLE TotCan AS DECIMAL.
   TotCan = decimal(InvRecont.CanBien:screen-value in browse {&Browse-Name}) + decimal(InvRecont.CanMal:screen-value in browse {&Browse-Name}).
  ASSIGN InvConteo.CodCia      = S-CODCIA
         InvConteo.CodAlm      = S-CODALM
         InvConteo.FchInv      = D-FCHINV
         InvConteo.CanInv      = TotCan
         InvConteo.Responsable = S-USER-ID
         
         InvRecont.CodCia      = S-CODCIA
         InvRecont.CodAlm      = S-CODALM
         InvRecont.FchInv      = D-FCHINV
         InvRecont.codmat      = InvConteo.codmat
         InvRecont.CanBien     = InvRecont.CanBien
         InvRecont.CanMal      = InvRecont.CanMal
         InvRecont.CanInv      = InvConteo.CanInv
         InvRecont.Responsable = S-USER-ID         
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
    RB-FILTER = "InvConteo.CodCia = " + STRING(S-CODCIA) +
                " AND InvConteo.CodAlm = '" + S-CODALM + "'".
    IF I-TipIng = 2 THEN
       RB-FILTER = RB-FILTER + " AND InvConteo.Responsable = '" + S-USER-ID + "'".

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
  {src/adm/template/snd-list.i "InvConteo"}
  {src/adm/template/snd-list.i "InvRecont"}
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
ASSIGN I-CODMAT = InvConteo.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
               AND  Almmmatg.CodMat = I-CODMAT 
              NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
   MESSAGE "Codigo de material no existe" VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY" TO InvConteo.CodMat.
   RETURN "ADM-ERROR".   
END.
FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
               AND  Almmmate.CodAlm = S-CODALM 
               AND  Almmmate.CodMat = I-CODMAT 
              NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmate THEN DO:
   MESSAGE "Material no asignado a este Almacen" VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY" TO InvConteo.CodMat.
   RETURN "ADM-ERROR".   
END.
IF (DECIMAL(InvRecont.CanBien:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) < 0) 
   THEN DO:
   MESSAGE "Las Cantidades deben ser mayor o igual a cero" VIEW-AS ALERT-BOX ERROR.
   IF DECIMAL(InvRecont.CanBien:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN
       APPLY "ENTRY" TO InvConteo.CanInv.
   ELSE 
       APPLY "ENTRY" TO InvRecont.CanInv.
   RETURN "ADM-ERROR".   
END.
IF (DECIMAL(InvRecont.CanMal:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) < 0) 
   THEN DO:
   MESSAGE "Las Cantidades deben ser mayor o igual a cero" VIEW-AS ALERT-BOX ERROR.
   IF DECIMAL(InvRecont.CanMal:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN
       APPLY "ENTRY" TO InvConteo.CanInv.
   ELSE 
       APPLY "ENTRY" TO InvRecont.CanInv.
   RETURN "ADM-ERROR".   
END.
/*IF (DECIMAL(InvConteo.CanInv:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) < 0) 
 *    THEN DO:
 *    MESSAGE "Las Cantidades deben ser mayor o igual a cero" VIEW-AS ALERT-BOX ERROR.
 *    IF DECIMAL(InvConteo.CanInv:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN
 *        APPLY "ENTRY" TO InvConteo.CanInv.
 *    ELSE 
 *        APPLY "ENTRY" TO InvRecont.CanInv.
 *    RETURN "ADM-ERROR".   
 * END.*/
/*IF DECIMAL(InvConteo.CanInv:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) /*<> 
 *    DECIMAL(InvRecont.CanInv:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})*/
 *    THEN DO:
 *    MESSAGE "La Cantidad de Conteo y Reconteo" SKIP
 *            "deben de ser iguales" SKIP
 *             VIEW-AS ALERT-BOX ERROR.
 *    APPLY "ENTRY" TO InvConteo.CanInv.
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION _Estado B-table-Win 
FUNCTION _Estado RETURNS CHARACTER
   ( INPUT pFlgEst AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   CASE pFlgEst:
    WHEN 'P' THEN RETURN 'Pendiente'.
    WHEN 'C' THEN RETURN 'Cancelada'.
    WHEN 'A' THEN RETURN 'Anulada'.
  END CASE.

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

