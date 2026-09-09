&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE C-Detalle NO-UNDO LIKE Facdpedi.
DEFINE TEMP-TABLE Detalle NO-UNDO LIKE Facdpedi
       INDEX LLave01 AS PRIMARY CodCia CodMat.
DEFINE TEMP-TABLE T-DPEDI NO-UNDO LIKE FacDPedi.



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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR lh_handle AS HANDLE.

/*DEF VAR s-update-codmat AS LOG NO-UNDO.*/

DEF BUFFER b-Detalle FOR Detalle.
DEFINE VARIABLE clave AS CHARACTER FORMAT "x(20)" LABEL "Clave" NO-UNDO.

DEF VAR s-task-no AS INT NO-UNDO.
DEF VAR x-HorIni LIKE faccpedi.horsac NO-UNDO.
DEF VAR x-FchIni LIKE faccpedi.fecsac NO-UNDO.

DEFINE VAR x-timedesde AS INT.
DEFINE VAR x-timehasta AS INT.

DEFINE VARIABLE s-status-record AS CHAR.
DEFINE VARIABLE s-generacion-multiple AS LOG.

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
&Scoped-define INTERNAL-TABLES Detalle Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Detalle.NroItm Detalle.codmat ~
Almmmatg.DesMat Detalle.UndVta Detalle.CanPick Detalle.Factor ~
Detalle.CanPed Detalle.Libre_c01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table Detalle.codmat ~
Detalle.CanPick 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table Detalle
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table Detalle
&Scoped-define QUERY-STRING-br_table FOR EACH Detalle WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF Detalle NO-LOCK ~
    BY Detalle.NroItm
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Detalle WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF Detalle NO-LOCK ~
    BY Detalle.NroItm.
&Scoped-define TABLES-IN-QUERY-br_table Detalle Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Detalle
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-66 RECT-65 br_table x-CodDoc x-NroDoc ~
FILL-IN-NroEtq txtTTrans TOGGLE-1 BUTTON-13 BUTTON-15 
&Scoped-Define DISPLAYED-OBJECTS txtTTxx x-CodDoc x-CodCli x-NroDoc ~
x-NomCli FILL-IN-NroEtq x-FchDoc txtTTrans TOGGLE-1 x-NroItem ~
FILL-IN-Bultos 

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


/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE ocxTimer AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chocxTimer AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-13 
     LABEL "Cerrar Orden" 
     SIZE 13 BY 1.12.

DEFINE BUTTON BUTTON-15 
     LABEL "Nueva Orden" 
     SIZE 13 BY 1.12.

DEFINE VARIABLE x-CodDoc AS CHARACTER FORMAT "X(256)":U INITIAL "G/R" 
     LABEL "Nro." 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "G/R" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Bultos AS INTEGER FORMAT ">,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1.15
     BGCOLOR 0 FGCOLOR 14 FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroEtq AS CHARACTER FORMAT "X(30)":U 
     LABEL "Número de Etiqueta" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .81 NO-UNDO.

DEFINE VARIABLE txtTTrans AS CHARACTER FORMAT "X(60)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 24 BY 1.65
     BGCOLOR 15 FGCOLOR 12 FONT 8 NO-UNDO.

DEFINE VARIABLE txtTTxx AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 48.86 BY 1.65
     BGCOLOR 15 FGCOLOR 12 FONT 8 NO-UNDO.

DEFINE VARIABLE x-CodCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc AS DATE FORMAT "99/99/99":U 
     LABEL "Fecha de emisión" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 53 BY .81 NO-UNDO.

DEFINE VARIABLE x-NroDoc AS CHARACTER FORMAT "x(9)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-NroItem AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Nro Items" 
     VIEW-AS FILL-IN 
     SIZE 4.72 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-65
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 106 BY 2.96.

DEFINE RECTANGLE RECT-66
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 106 BY 2.12.

DEFINE VARIABLE TOGGLE-1 AS LOGICAL INITIAL no 
     LABEL "Ingreso múltiple" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .77
     BGCOLOR 14 FGCOLOR 0 FONT 6 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      Detalle, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Detalle.NroItm FORMAT ">>>9":U
      Detalle.codmat COLUMN-LABEL "Codigo" FORMAT "X(14)":U
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 45.57
      Detalle.UndVta COLUMN-LABEL "Unidad" FORMAT "XXXXXXX":U WIDTH 8.43
      Detalle.CanPick COLUMN-LABEL "Cantidad" FORMAT ">,>>>,>>9.9999":U
      Detalle.Factor FORMAT ">>,>>9.9999":U
      Detalle.CanPed COLUMN-LABEL "Cantidad!Calculada" FORMAT ">,>>>,>>9.9999":U
      Detalle.Libre_c01 COLUMN-LABEL "Número de Etiqueta" FORMAT "x(30)":U
            WIDTH 22.57
  ENABLE
      Detalle.codmat
      Detalle.CanPick
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 129 BY 18.08
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 7.73 COL 1
     txtTTxx AT ROW 4.15 COL 56.29 RIGHT-ALIGNED NO-LABEL WIDGET-ID 20
     x-CodDoc AT ROW 1.54 COL 12 COLON-ALIGNED WIDGET-ID 12
     x-CodCli AT ROW 2.62 COL 12 COLON-ALIGNED
     x-NroDoc AT ROW 1.54 COL 19 COLON-ALIGNED NO-LABEL
     x-NomCli AT ROW 2.62 COL 25 COLON-ALIGNED NO-LABEL
     FILL-IN-NroEtq AT ROW 6.38 COL 25 COLON-ALIGNED WIDGET-ID 24
     x-FchDoc AT ROW 1.54 COL 56 COLON-ALIGNED
     txtTTrans AT ROW 4.15 COL 55 COLON-ALIGNED WIDGET-ID 14
     TOGGLE-1 AT ROW 6.38 COL 58 WIDGET-ID 28
     BUTTON-13 AT ROW 1.27 COL 69 WIDGET-ID 4
     BUTTON-15 AT ROW 1.27 COL 82 WIDGET-ID 8
     x-NroItem AT ROW 2.62 COL 88 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-Bultos AT ROW 4.27 COL 95 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     "BULTOS:" VIEW-AS TEXT
          SIZE 15 BY 1.15 AT ROW 4.27 COL 82 WIDGET-ID 32
          BGCOLOR 0 FGCOLOR 14 FONT 8
     RECT-66 AT ROW 3.88 COL 1 WIDGET-ID 22
     RECT-65 AT ROW 1 COL 1
     SPACE(17.29) SKIP(1.85)
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
   Temp-Tables and Buffers:
      TABLE: C-Detalle T "?" NO-UNDO INTEGRAL Facdpedi
      TABLE: Detalle T "?" NO-UNDO INTEGRAL Facdpedi
      ADDITIONAL-FIELDS:
          INDEX LLave01 AS PRIMARY CodCia CodMat
      END-FIELDS.
      TABLE: T-DPEDI T "?" NO-UNDO INTEGRAL FacDPedi
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
         HEIGHT             = 25.5
         WIDTH              = 129.86.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R,COLUMNS                    */
/* BROWSE-TAB br_table RECT-65 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Bultos IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       txtTTrans:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN txtTTxx IN FRAME F-Main
   NO-ENABLE ALIGN-R                                                    */
ASSIGN 
       txtTTxx:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN x-CodCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NroItem IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.Detalle,INTEGRAL.Almmmatg OF Temp-Tables.Detalle"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ","
     _OrdList          = "Temp-Tables.Detalle.NroItm|yes"
     _FldNameList[1]   > Temp-Tables.Detalle.NroItm
"Detalle.NroItm" ? ">>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.Detalle.codmat
"Detalle.codmat" "Codigo" "X(14)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "45.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.Detalle.UndVta
"Detalle.UndVta" "Unidad" "XXXXXXX" "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.Detalle.CanPick
"Detalle.CanPick" "Cantidad" ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = Temp-Tables.Detalle.Factor
     _FldNameList[7]   > Temp-Tables.Detalle.CanPed
"Detalle.CanPed" "Cantidad!Calculada" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.Detalle.Libre_c01
"Detalle.Libre_c01" "Número de Etiqueta" "x(30)" "character" ? ? ? ? ? ? no ? no no "22.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME ocxTimer ASSIGN
       FRAME           = FRAME F-Main:HANDLE
       ROW             = 1.96
       COLUMN          = 110
       HEIGHT          = 3.85
       WIDTH           = 14.29
       WIDGET-ID       = 16
       HIDDEN          = yes
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      ocxTimer:NAME = "ocxTimer":U .
/* ocxTimer OCXINFO:CREATE-CONTROL from: {F0B88A90-F5DA-11CF-B545-0020AF6ED35A} type: PSTimer */
      ocxTimer:MOVE-AFTER(FILL-IN-Bultos:HANDLE IN FRAME F-Main).

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


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


&Scoped-define SELF-NAME Detalle.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Detalle.codmat br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF Detalle.codmat IN BROWSE br_table /* Codigo */
DO:
/*   IF DECIMAL(Detalle.canped:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 */
/*   THEN Detalle.canped:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '1'.     */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Detalle.codmat br_table _BROWSE-COLUMN B-table-Win
ON F11 OF Detalle.codmat IN BROWSE br_table /* Codigo */
DO:
/*  DEF VAR x-codmat AS CHAR.
 *   DEF VAR x-canped AS DEC.
 *   
 *   RUN vta/d-chqgui (OUTPUT x-codmat, OUTPUT x-canped).
 *   IF X-CODMAT <> ? AND X-CANPED > 0 THEN DO:
 *     DISPLAY 
 *         x-codmat @ Detalle.Codmat 
 *         x-canped @ Detalle.CanPed
 *         WITH BROWSE {&BROWSE-NAME}.
 *     APPLY "RETURN" TO Detalle.CodMat IN BROWSE {&BROWSE-NAME}.   
 *   END.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Detalle.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF Detalle.codmat IN BROWSE br_table /* Codigo */
DO:
  IF s-status-record <> 'add-record' THEN RETURN.
  IF SELF:SCREEN-VALUE = "" THEN RETURN.

  /* Vamos a buscar primero el codigo de barras, luego el codigo interno */
  DEF VAR pCodMat LIKE Detalle.codmat.
  DEF VAR pCanPed LIKE Detalle.canped.
  DEF VAR pFactor LIKE Detalle.factor.
  DEF VAR X-item AS INT.

  pCodMat = CAPS(SELF:SCREEN-VALUE).
  pCanPed = 1.
  pFactor = 1.

  /* 02Ago2013 - Ean13 duplicados */
  DEF VAR pCodMatEan LIKE Detalle.codmat.
  FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = 'EAN13DUPLICADOS' AND 
      vtatabla.llave_c1 = pCodMat NO-LOCK NO-ERROR.
  IF AVAILABLE vtatabla THEN DO:
      pCodMatEan = ''.
      FOR EACH almmmatg WHERE almmmatg.codcia = s-codcia AND 
          almmmatg.codbrr = pCodMat AND pCodMatEan = '' NO-LOCK:
            FIND T-DPEDI WHERE T-DPEDI.codmat = almmmatg.codmat NO-LOCK NO-ERROR.
            IF AVAILABLE T-DPEDI THEN pCodMatEan = T-DPEDI.codmat.
      END.
      /*pCodMat = pCodMatEan.*/
      IF pCodMatEan = '' THEN DO:
          /* Lo busco x EAN14 */
        DO x-Item = 1 TO 3:
            FOR EACH Almmmat1 WHERE Almmmat1.codcia = s-codcia AND 
                   Almmmat1.Barra[x-Item] = pCodMat AND pCodMatEan = '' NO-LOCK:
                   FIND T-DPEDI WHERE T-DPEDI.codmat = almmmat1.codmat NO-LOCK NO-ERROR.
                   IF NOT AVAILABLE T-DPEDI THEN NEXT.
                   pCodMatEan = T-DPEDI.codmat.
                   pFactor = Almmmat1.Equival[x-Item].
            END.
        END.
      END.
      pCodMat = pCodMatEan.
  END.
  ELSE DO:  
    RUN alm/p-codbrr (INPUT-OUTPUT pCodMat, INPUT-OUTPUT pFactor, s-codcia).
  END.

  /* Control de generación múltiple */
  IF s-generacion-multiple = YES AND pCodMat <> '' THEN DO:
      /* Obligado debe ser un código EAN 14 */
      IF pFactor < 1 THEN DO:
          BELL.
          MESSAGE 'Solo se aceptan códigos EAN-14' VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = ''.
          RETURN NO-APPLY.
      END.
  END.

  ASSIGN
    SELF:SCREEN-VALUE = pCodMat
    NO-ERROR.
  IF pcodmat = '' THEN DO:
    Detalle.canped:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '1'.
    RETURN NO-APPLY.
  END.
  FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = SELF:SCREEN-VALUE
    NO-LOCK.

  FIND T-DPEDI WHERE T-DPEDI.codmat = SELF:SCREEN-VALUE 
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE T-DPEDI THEN DO:
    MESSAGE 'Artículo NO registrado en la Guia'
        VIEW-AS ALERT-BOX ERROR.
    SELF:SCREEN-VALUE = ''.
    Detalle.canped:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '1'.
    RETURN NO-APPLY.
  END.
  DISPLAY
    Almmmatg.desmat 
    T-DPEDI.undvta @ Detalle.undvta
    pCanPed @ Detalle.CanPick
    pFactor @ Detalle.Factor
    WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Detalle.CanPick
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Detalle.CanPick br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF Detalle.CanPick IN BROWSE br_table /* Cantidad */
DO:
    IF Detalle.codmat:SCREEN-VALUE IN BROWSE {&browse-name} = '' THEN RETURN.
    IF s-status-record = 'cancel-record' THEN RETURN.
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN SELF:SCREEN-VALUE = '1'.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Detalle.CanPick br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF Detalle.CanPick IN BROWSE br_table /* Cantidad */
DO:
   Detalle.CanPed:SCREEN-VALUE IN BROWSE {&browse-name} = 
       STRING( DECIMAL(Detalle.CanPick:SCREEN-VALUE IN BROWSE {&browse-name}) *
               DECIMAL(Detalle.Factor:SCREEN-VALUE IN BROWSE {&browse-name}) ).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-13 B-table-Win
ON CHOOSE OF BUTTON-13 IN FRAME F-Main /* Cerrar Orden */
DO:
  MESSAGE 'Cerramos la Orden?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.

  DEF VAR pMensaje AS CHAR NO-UNDO.

  RUN Cierre-de-guia (OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF pMensaje > '' THEN DO:
          MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      END.
      ELSE DO:
          MESSAGE 'NO se pudo cerrar la Guía' SKIP
              'Volver a repetir el chequeo'
              VIEW-AS ALERT-BOX ERROR.
      END.
      RETURN NO-APPLY.
  END.
  
  RUN Borra-Temporal.

  RUN Elimina-Items-Backup.

  ASSIGN
      x-CodCli = ''
      x-FchDoc = ?
      x-NomCli = ''
      x-NroDoc = ''
      x-NroDoc:SENSITIVE = YES
      x-CodDoc:SENSITIVE = YES.
  IF AVAILABLE(LogVtaTabla) THEN RELEASE LogVtaTabla.

  DISPLAY x-CodCli x-FchDoc x-NomCli x-NroDoc WITH FRAME {&FRAME-NAME}.
  APPLY 'ENTRY':U TO x-NroDoc IN FRAME {&FRAME-NAME}.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-15
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-15 B-table-Win
ON CHOOSE OF BUTTON-15 IN FRAME F-Main /* Nueva Orden */
DO:
    MESSAGE 'Nuevo Pedido?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.
    RUN Borra-Temporal.
    RUN Elimina-Items-Backup.
    ASSIGN
        x-NroDoc = '' x-NroDoc:SENSITIVE = YES
        x-CodCli = '' x-NomCli = '' x-FchDoc = ?
        x-NroItem = 0.
    DISPLAY 
        x-NroDoc
        x-CodCli
        x-NomCli
        x-FchDoc
        WITH FRAME {&FRAME-NAME}.
    RUN adm-open-query.
    APPLY 'ENTRY':U TO x-NroDoc IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroEtq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroEtq B-table-Win
ON ENTRY OF FILL-IN-NroEtq IN FRAME F-Main /* Número de Etiqueta */
DO:
  SELF:SCREEN-VALUE = ''.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroEtq B-table-Win
ON LEAVE OF FILL-IN-NroEtq IN FRAME F-Main /* Número de Etiqueta */
DO:
  IF SELF:SCREEN-VALUE <> '' AND NOT SELF:SCREEN-VALUE BEGINS 'CO' THEN DO:
      BELL.
      MESSAGE 'Inválido número de etiqueta' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  ASSIGN {&self-name}.
/*   IF {&self-name} = '' THEN SELF:SENSITIVE = YES. */
/*   ELSE SELF:SENSITIVE = NO.                       */
/*   IF SELF:SENSITIVE = NO THEN ASSIGN BUTTON-16:SENSITIVE = YES TOGGLE-1:SENSITIVE = YES. */
/*   ELSE ASSIGN BUTTON-16:SENSITIVE = NO TOGGLE-1:SENSITIVE = NO.                          */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ocxTimer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ocxTimer B-table-Win OCX.Tick
PROCEDURE ocxTimer.PSTimer.Tick .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR ztime AS INT.

x-timehasta = TIME.

zTime = x-timehasta - x-timedesde.
DO WITH FRAME {&FRAME-NAME}:
    txtTTrans:SCREEN-VALUE = STRING(ztime,"HH:MM:SS").
    txtTTxx:SCREEN-VALUE = "Tiempo transcurrido ".
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-1 B-table-Win
ON VALUE-CHANGED OF TOGGLE-1 IN FRAME F-Main /* Ingreso múltiple */
DO:
  ASSIGN {&self-name}.
  s-generacion-multiple = {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodDoc B-table-Win
ON ENTRY OF x-CodDoc IN FRAME F-Main /* Nro. */
DO:
   DO WITH FRAME {&FRAME-NAME}:
        txtTTrans:VISIBLE = FALSE.
        txtTTxx:VISIBLE = FALSE.
        /*ocxTimer:ENABLED = FALSE.*/
    END.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-NroDoc B-table-Win
ON ENTRY OF x-NroDoc IN FRAME F-Main
DO:
   DO WITH FRAME {&FRAME-NAME}:
        txtTTrans:VISIBLE = FALSE.
        txtTTxx:VISIBLE = FALSE.
        /*ocxTimer:ENABLED = FALSE.*/
    END.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-NroDoc B-table-Win
ON LEAVE OF x-NroDoc IN FRAME F-Main
OR RETURN OF {&SELF-NAME}
    DO:
        IF SELF:SCREEN-VALUE = '' THEN RETURN.
        /* buscamos en los almacenes de la división actual */
        DEF VAR x-Ok AS LOG NO-UNDO.

        x-Ok = NO.
        FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
            AND Almacen.coddiv = s-coddiv:
            FIND Almcmov WHERE Almcmov.codcia = s-codcia 
                AND Almcmov.codalm = Almacen.codalm
                AND Almcmov.tipmov = "S"
                AND Almcmov.codmov = 03 
                AND Almcmov.nroser = INTEGER(SUBSTRING(x-nrodoc:SCREEN-VALUE, 1, 3))
                AND Almcmov.nrodoc = INTEGER(SUBSTRING(x-nrodoc:SCREEN-VALUE, 4))
                AND Almcmov.flgest <> "A"
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almcmov THEN DO:
                x-Ok = YES.
                LEAVE.
            END.
        END.
        IF x-Ok = NO THEN DO:
            MESSAGE 'Guia por Transferencia NO registrada o anulada' VIEW-AS ALERT-BOX ERROR.
            SELF:SCREEN-VALUE = ''.
            RETURN NO-APPLY.
        END.
        /*RD01- Verifica si la orden ya ha sido chequeado*/
        IF Almcmov.FlgSit = 'R' THEN DO:
            MESSAGE 'Guia de Transferencia RECEPCIONADA' VIEW-AS ALERT-BOX ERROR.
            DISPLAY x-NroDoc WITH FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.
        END.
        IF NOT (Almcmov.Libre_c02 = 'P' AND Almcmov.FlgSit = 'T') THEN DO:
            MESSAGE 'Guia de Transferencia YA fue chequeada' VIEW-AS ALERT-BOX ERROR.
            DISPLAY x-NroDoc WITH FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.
        END.
        IF x-NroDoc <> SELF:SCREEN-VALUE THEN DO:
            /* Arranca el ciclo */
            x-timedesde = TIME.
            txtTTrans:VISIBLE = TRUE.            
            txtTTxx:VISIBLE = TRUE.

            ASSIGN
                x-FchIni = TODAY
                x-HorIni = STRING(TIME, 'HH:MM:SS').
            ASSIGN {&SELF-NAME} x-coddoc.
            RUN Calcula-NroItems.
            RUN Borra-Temporal.
            RUN Carga-con-kits.
            RUN Recarga-Items-Backup.
            ASSIGN
                x-fchdoc = Almcmov.fchdoc
                x-codcli = Almcmov.codcli
                x-nomcli = Almcmov.nomref.
            DISPLAY
                x-fchdoc
                x-codcli
                x-nomcli
                WITH FRAME {&FRAME-NAME}.
            x-CodDoc:SENSITIVE = NO.
            x-NroDoc:SENSITIVE = NO.
            RUN dispatch IN THIS-PROCEDURE ('open-query':U).
        END.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF


ON 'RETURN':U OF Detalle.CodMat, Detalle.CanPick IN BROWSE {&BROWSE-NAME} DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.


txtTTrans:VISIBLE = FALSE.
txtTTxx:SCREEN-VALUE = "Tiempo transcurrido :".
txtTTxx:VISIBLE = FALSE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Backup-Items B-table-Win 
PROCEDURE Borra-Backup-Items :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF s-task-no = 0 THEN RETURN.
FIND w-report WHERE w-report.task-no = s-task-no
    AND w-report.Llave-C = x-coddoc + x-nrodoc
    AND w-report.Campo-C[1] = STRING(ROWID(Detalle))
    EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE w-report THEN RETURN.
DELETE w-report.
RELEASE w-report.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal B-table-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  EMPTY TEMP-TABLE Detalle.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-NroItems B-table-Win 
PROCEDURE Calcula-NroItems :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iNroItems AS INTEGER     NO-UNDO.
    
    x-NroItem = 0.
    FOR EACH Almdmov OF Almcmov NO-LOCK:
        iNroItems = iNroItems + 1.
    END.
    ASSIGN x-NroItem = iNroItems.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-con-kits B-table-Win 
PROCEDURE Carga-con-kits :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-DPEDI.

/* RHC 13.07.2012 CARGAMOS TODO EN UNIDADES DE STOCK 
    NO LE AFECTA A LAS VENTAS AL CREDITO 
*/
FOR EACH Almdmov OF Almcmov NO-LOCK,
    FIRST Almmmatg OF Almdmov NO-LOCK:
    FIND T-DPEDI WHERE T-DPEDI.codmat = Almdmov.codmat NO-ERROR.
    IF NOT AVAILABLE T-DPEDI THEN DO:
        CREATE T-DPEDI.
        ASSIGN
            T-DPEDI.CodMat = Almdmov.codmat
            T-DPEDI.UndVta = Almmmatg.UndStk
            T-DPEDI.CanPed = Almdmov.candes * Almdmov.factor.
    END.
    ELSE T-DPEDI.canped = T-DPEDI.canped + Almdmov.candes * Almdmov.factor.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierre-de-guia B-table-Win 
PROCEDURE Cierre-de-guia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  DEF VAR x-UsrChq AS CHAR NO-UNDO.
  DEF VAR x-NroItm AS INT NO-UNDO.
  DEF VAR pBultos AS INT NO-UNDO.
  DEF VAR x-CodPed AS CHAR INIT "TRA" NO-UNDO.
  DEF VAR x-NroPed AS CHAR NO-UNDO.
  DEF VAR x-CodAlm AS CHAR NO-UNDO.
  
  /* Primero veamos si es consistente */
  EMPTY TEMP-TABLE c-Detalle.
  
  /* Acumulamos por producto */
  FOR EACH Detalle:
    FIND C-Detalle WHERE C-Detalle.codmat = Detalle.codmat
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE C-Detalle THEN CREATE C-Detalle.
    BUFFER-COPY Detalle TO C-Detalle
        ASSIGN
            C-Detalle.canped = C-Detalle.canped + Detalle.canped.
  END.
  
  FOR EACH T-DPEDI:
    FIND C-Detalle WHERE C-Detalle.codmat = T-DPEDI.codmat
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE C-Detalle THEN DO:
        pMensaje = 'No se ha registrado el artículo'.
        RETURN 'ADM-ERROR'.
    END.
    IF C-Detalle.CanPed <> T-DPEDI.CanPed THEN DO:
        pMensaje = 'Diferencia de cantidades en el artículo' + CHR(10) +
            T-DPEDI.codmat + " " + Almmmatg.desmat.
        FIND FIRST detalle WHERE detalle.codmat = c-detalle.codmat.
        REPOSITION {&BROWSE-NAME} TO ROWID ROWID(Detalle).
        RETURN 'ADM-ERROR'.
    END.
  END.        
  RUN vtamay/d-chqped (OUTPUT x-UsrChq).
  IF x-UsrChq = '' THEN RETURN 'ADM-ERROR'.
  ASSIGN
      x-CodAlm = Almcmov.CodAlm.

  /* ************************************************************** */
  /* ************************************************************** */
  DEF VAR pCuenta AS INTE NO-UNDO.
  PRINCIPAL:
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      {lib/lock-genericov3.i &Tabla="Almcmov" ~
          &Condicion="Almcmov.codcia = s-codcia ~
          AND Almcmov.codalm = x-CodAlm ~
          AND Almcmov.tipmov = 'S' ~
          AND Almcmov.codmov = 03 ~
          AND Almcmov.nroser = INTEGER(SUBSTRING(x-nrodoc, 1, 3)) ~
          AND Almcmov.nrodoc = INTEGER(SUBSTRING(x-nrodoc, 4))" ~
          &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
          &Accion="RETRY" ~
          &Mensaje="NO" ~
          &txtMensaje="pMensaje" ~
          &TipoError="UNDO, RETURN 'ADM-ERROR'"}
      IF NOT (Almcmov.Libre_c02 = 'P' AND Almcmov.FlgSit = 'T') THEN DO:
          pMensaje = 'ERROR en la Guia de Transferencia' + CHR(10) +
              'Ya NO está pendiente de chequeo'.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      ASSIGN 
          Almcmov.Libre_c02 = 'C'
          Almcmov.Libre_c03 = x-usrchq + '|' + 
          STRING(TODAY, '99/99/9999') + '|' +
          STRING(TIME,'HH:MM:SS') + '|' +
          STRING(x-fchini, '99/99/9999') + '|' + x-horini.
      /* ******************************************************************** */
      /* ***************** RHC 08/07/2015 Tablas auxiliares ***************** */
      /* ******************************************************************** */
      ASSIGN
          x-NroPed = STRING(Almcmov.nroser,'999') + STRING(Almcmov.nrodoc, '9999999').
      FOR EACH Detalle WHERE Detalle.codmat <> '' BREAK BY Detalle.Libre_c01 BY Detalle.NroItm:
          IF FIRST-OF(Detalle.Libre_c01) THEN x-NroItm = 0.
          FIND Vtaddocu WHERE VtaDDocu.CodCia = s-CodCia
              AND VtaDDocu.CodDiv = s-CodDiv        /*Faccpedi.coddiv*/
              AND VtaDDocu.CodPed = x-CodPed
              AND VtaDDocu.NroPed = x-NroPed
              AND VtaDDocu.CodMat = Detalle.codmat
              AND VtaDDocu.Libre_c01 = Detalle.libre_c01
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Vtaddocu THEN DO:
              CREATE Vtaddocu. 
              x-NroItm = x-nroItm + 1.
          END.
          ELSE DO:
              FIND CURRENT Vtaddocu EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
              IF NOT AVAILABLE Vtaddocu THEN DO:
                  {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
                  UNDO PRINCIPAL, RETURN "ADM-ERROR".
              END.
          END.
          ASSIGN
              VtaDDocu.CodCia = s-CodCia
              VtaDDocu.CodDiv = s-CodDiv        /*Faccpedi.coddiv*/
              VtaDDocu.CodPed = x-CodPed
              VtaDDocu.NroPed = x-NroPed
              VtaDDocu.FchPed = Almcmov.fchdoc
              VtaDDocu.CodCli = Almcmov.almdes
              VtaDDocu.NroItm = x-NroItm
              VtaDDocu.CodMat = Detalle.codmat
              VtaDDocu.CanPed = VtaDDocu.CanPed + Detalle.canped
              VtaDDocu.Factor = 1       /* Ojo */
              VtaDDocu.UndVta = Detalle.undvta
              VtaDDocu.Libre_c01 = Detalle.libre_c01.
      END.
      
      FOR EACH Vtaddocu EXCLUSIVE-LOCK WHERE Vtaddocu.codcia = s-CodCia
          AND VtaDDocu.CodDiv = s-CodDiv        /*Faccpedi.coddiv*/
          AND VtaDDocu.CodPed = x-CodPed
          AND VtaDDocu.NroPed = x-NroPed,
          FIRST Almmmatg OF Vtaddocu NO-LOCK ON ERROR UNDO, THROW:
          ASSIGN
              Vtaddocu.pesmat = Vtaddocu.canped * Almmmatg.pesmat.
          FIND ControlOD WHERE ControlOD.CodCia = Vtaddocu.codcia
              AND ControlOD.CodDiv = Vtaddocu.coddiv
              AND ControlOD.CodDoc = Vtaddocu.codped
              AND ControlOD.NroDoc = Vtaddocu.nroped
              AND ControlOD.NroEtq = Vtaddocu.libre_c01
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE ControlOD THEN DO:
              CREATE ControlOD.
              pBultos = pBultos + 1.
          END.
          ELSE DO:
              FIND CURRENT ControlOD EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
              IF NOT AVAILABLE ControlOD THEN DO:
                  {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
                  UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
              END.
          END.
          ASSIGN
              ControlOD.CodCia = Vtaddocu.codcia
              ControlOD.CodDiv = Vtaddocu.coddiv
              ControlOD.CodDoc = Vtaddocu.codped
              ControlOD.NroDoc = Vtaddocu.nroped
              ControlOD.NroEtq = Vtaddocu.libre_c01
              ControlOD.CodCli = Almcmov.almdes
              ControlOD.CodAlm = Almcmov.codalm
              ControlOD.FchDoc = Almcmov.fchdoc
              ControlOD.FchChq = DATE(ENTRY(2,Almcmov.Libre_c03,'|'))
              ControlOD.HorChq = ENTRY(3,Almcmov.Libre_c03,'|')
              ControlOD.NomCli = Almcmov.nomref
              ControlOD.Usuario = Almcmov.usuario
              ControlOD.CantArt = ControlOD.CantArt + Vtaddocu.canped
              /*ControlOD.ImpArt */
              ControlOD.PesArt = ControlOD.PesArt + Vtaddocu.pesmat.
          RELEASE ControlOD.
      END.
      
      FIND Ccbcbult WHERE CcbCBult.CodCia = s-CodCia
          AND CcbCBult.CodDiv = s-CodDiv
          AND CcbCBult.CodDoc = x-CodPed
          AND CcbCBult.NroDoc = x-NroPed
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Ccbcbult THEN CREATE Ccbcbult.
      ELSE DO:
          FIND CURRENT Ccbcbult EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
          IF NOT AVAILABLE Ccbcbult THEN DO:
              {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
              UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
          END.
      END.
      ASSIGN
          CcbCBult.CodCia = s-CodCia
          CcbCBult.CodDiv = s-CodDiv
          CcbCBult.CodDoc = x-CodPed
          CcbCBult.NroDoc = x-NroPed
          CcbCBult.Bultos = pBultos
          CcbCBult.CodCli = Almcmov.almdes
          CcbCBult.FchDoc = TODAY
          CcbCBult.NomCli = Almcmov.nomref
          CcbCBult.CHR_01 = "P"       /* Emitido */
          CcbCBult.usuario = s-user-id
          CcbCBult.Chr_02 = ENTRY(1,Almcmov.Libre_c03,'|')
          CcbCBult.Chr_03 = ENTRY(3,Almcmov.Libre_c03,'|')
          CcbCBult.Dte_01 = DATE(ENTRY(2,Almcmov.Libre_c03,'|')).
      IF NUM-ENTRIES(Almcmov.Libre_c04,'|') >= 3 THEN
          ASSIGN
          CcbCBult.Chr_04 = ENTRY(3,Almcmov.Libre_c04,'|')
          CcbCBult.Dte_02 = DATE(ENTRY(2,Almcmov.Libre_c04,'|')).
      RELEASE CcbCBult.
      /* ******************************************************************** */
      /* RHC 23/07/2015 Guardamos detalle del pre-picking para consultarlo despues */
      FOR EACH b-Detalle NO-LOCK WHERE b-Detalle.codmat <> '':
          CREATE Almddocu.
          ASSIGN
              AlmDDocu.CodCia = s-CodCia
              AlmDDocu.CodLlave = "PICKING"
              AlmDDocu.CodDoc = x-CodPed
              AlmDDocu.NroDoc = x-NroPed
              AlmDDocu.Tipo = "M"       /* ¿? REVISAR */
              AlmDDocu.Codigo = b-Detalle.codmat
              AlmDDocu.NroItm = b-Detalle.NroItm
              AlmDDocu.Libre_c01 = b-Detalle.UndVta
              AlmDDocu.Libre_c02 = x-UsrChq
              AlmDDocu.Libre_c03 = b-Detalle.Libre_c01
              AlmDDocu.Libre_d01 = b-Detalle.canped
              AlmDDocu.Libre_d02 = b-Detalle.canpick
              AlmDDocu.Libre_d03 = b-Detalle.factor
              AlmDDocu.UsrCreacion = s-user-id
              AlmDDocu.FchCreacion = TODAY.
          RELEASE AlmDDocu.
      END.
      /* ************************************************************************* */
      IF AVAILABLE Vtaddocu THEN RELEASE Vtaddocu.
      IF AVAILABLE Almcmov  THEN RELEASE Almcmov.
  END.
  RETURN "OK".
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load B-table-Win  _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "b-picking-transf.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chocxTimer = ocxTimer:COM-HANDLE
    UIB_S = chocxTimer:LoadControls( OCXFile, "ocxTimer":U)
  .
  RUN DISPATCH IN THIS-PROCEDURE("initialize-controls":U) NO-ERROR.
END.
ELSE MESSAGE "b-picking-transf.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cuenta-Bultos B-table-Win 
PROCEDURE Cuenta-Bultos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    FILL-IN-Bultos = 0.
    FOR EACH B-Detalle BREAK BY B-Detalle.Libre_C01:
        IF FIRST-OF(B-Detalle.Libre_C01) THEN FILL-IN-Bultos = FILL-IN-Bultos + 1.
    END.
    DISPLAY FILL-IN-Bultos.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable-campos B-table-Win 
PROCEDURE disable-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN
    BUTTON-13:SENSITIVE IN FRAME {&FRAME-NAME} = NO
    BUTTON-15:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
                                     
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Elimina-Items-Backup B-table-Win 
PROCEDURE Elimina-Items-Backup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF s-task-no = 0 THEN RETURN.
FOR EACH w-report WHERE w-report.task-no = s-task-no
    AND w-report.Llave-C = x-coddoc + x-nrodoc:
    DELETE w-report.
END.
s-task-no = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable-campos B-table-Win 
PROCEDURE enable-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN
    BUTTON-13:SENSITIVE IN FRAME {&FRAME-NAME} = YES
    BUTTON-15:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Backup-Items B-table-Win 
PROCEDURE Graba-Backup-Items :
/*------------------------------------------------------------------------------
  Purpose:     Guarda a inormacion en el temporal para recuperarla despues
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF s-task-no = 0 THEN DO:
    NUMERO:
    REPEAT:
        s-task-no = RANDOM(1,999999).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK) THEN LEAVE NUMERO.
    END.
END.

RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF RETURN-VALUE = 'YES' THEN DO:
    CREATE w-report.
END.
ELSE DO:
    FIND w-report WHERE w-report.task-no = s-task-no
        AND w-report.Llave-C = x-coddoc + x-nrodoc
        AND w-report.Campo-C[1] = STRING(ROWID(Detalle))
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN RETURN.
END.
ASSIGN
    w-report.Task-No = s-task-no
    w-report.Llave-C = x-coddoc + x-nrodoc
    w-report.Campo-C[1] = STRING(ROWID(Detalle))
    w-report.LLave-I    = Detalle.NroItm
    w-report.Campo-C[2] = Detalle.codmat 
    w-report.Campo-C[3] = Detalle.UndVta
    w-report.Campo-F[1] = Detalle.CanPed
    w-report.Campo-F[2] = Detalle.CanPick
    w-report.Campo-F[3] = Detalle.Factor
    w-report.Campo-C[4] = Detalle.Libre_C01.

RELEASE w-report.

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
  IF x-NroDoc = '' THEN DO:
    MESSAGE 'Debe ingresar primero el Pedido'
        VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
  END.
  IF FILL-IN-NroEtq = '' THEN DO:
      MESSAGE 'Debe ingresar primero la Etiqueta'
          VIEW-AS ALERT-BOX WARNING.
      APPLY 'ENTRY':U TO FILL-IN-NroEtq IN FRAME {&FRAME-NAME}.
      RETURN 'ADM-ERROR'.
  END.
  s-status-record = 'add-record'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /*s-update-codmat = YES.*/
  RUN Procesa-Handle IN lh_handle ('disable-campos').

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
  DEF VAR k AS INT NO-UNDO.
  DEF VAR x-Factor   AS DEC NO-UNDO.
  DEF VAR x-Cantidad AS DEC NO-UNDO.
  
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
    DEF BUFFER B-DETA FOR Detalle.
    FOR EACH B-DETA NO-LOCK BY B-DETA.NroItm:
        x-Item = x-Item + 1.
    END.
  END.
  ELSE x-Item = Detalle.NroItm.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* RHC 14/07/2015 Ingreso múltiple */
  x-Factor = DECIMAL(Detalle.factor:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
  x-Cantidad = INTEGER(Detalle.CanPick).
  IF x-Factor <= 0 THEN x-Factor = 1.
  IF s-generacion-multiple = YES AND x-Factor >= 1 THEN DO:
      /* Generamos varias líneas */
      EMPTY TEMP-TABLE c-Detalle.
      CREATE c-Detalle.
      BUFFER-COPY Detalle TO c-Detalle.
      DO k = 1 TO x-Cantidad:
          IF k > 1 THEN DO:
              CREATE Detalle.
              BUFFER-COPY c-Detalle TO Detalle.
          END.
          ASSIGN
              Detalle.codcia = s-codcia
              Detalle.coddoc = x-coddoc
              Detalle.nroped = x-nrodoc
              Detalle.nroitm = x-item
              Detalle.undvta = T-DPEDI.undvta
              Detalle.factor = x-Factor
              Detalle.canpick = 1
              Detalle.Libre_c01 = FILL-IN-NroEtq + '-' + STRING(k, '9999')
              Detalle.canped = Detalle.CanPick * Detalle.Factor.
          RUN Graba-Backup-Items.
          x-Item = x-Item + 1.
      END.
  END.
  ELSE DO:
      /* Rutina Normal */
      ASSIGN
          Detalle.codcia = s-codcia
          Detalle.coddoc = x-coddoc
          Detalle.nroped = x-nrodoc
          Detalle.nroitm = x-item
          Detalle.undvta = T-DPEDI.undvta
          Detalle.factor = x-Factor
          Detalle.Libre_c01 = FILL-IN-NroEtq
          Detalle.canped = Detalle.CanPick * Detalle.Factor.
      RUN Graba-Backup-Items.
  END.
  /* ******************************* */

  /*
  ASSIGN
    Detalle.codcia = s-codcia
    Detalle.coddoc = x-coddoc
    Detalle.nroped = x-nrodoc
    Detalle.nroitm = x-item
    Detalle.undvta = T-DPEDI.undvta
    Detalle.canped = DECIMAL(Detalle.canped:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).

  RUN Graba-Backup-Items.
  */

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
  /*s-update-codmat = NO.*/
  RUN Procesa-Handle IN lh_handle ('enable-campos').

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
  RUN Borra-Backup-Items.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Renumera-Item.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields B-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
       FILL-IN-NroEtq:SENSITIVE = YES.
       TOGGLE-1:SENSITIVE = YES.
  END.

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
      /*Detalle.Factor:READ-ONLY IN BROWSE {&browse-name} = YES.*/
      FILL-IN-NroEtq:SENSITIVE = NO.
      TOGGLE-1:SENSITIVE = NO.
  END.
  
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
  s-status-record = ''.
  RUN Procesa-Handle IN lh_handle ('enable-campos').
  IF s-generacion-multiple = YES THEN DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          FILL-IN-NroEtq = ''
          TOGGLE-1 = NO
          TOGGLE-1:SCREEN-VALUE = 'NO'
          FILL-IN-NroEtq:SENSITIVE = YES
          FILL-IN-NroEtq:SCREEN-VALUE = ''.
      RUN dispatch IN THIS-PROCEDURE ('open-query':U).
      APPLY 'ENTRY':U TO FILL-IN-NroEtq.
  END.
  ELSE DO:
      RUN Procesa-Handle IN lh_handle ('Add-Record').
  END.
  s-generacion-multiple = NO.
  RUN Cuenta-Bultos.
  /*
  RUN Procesa-Handle IN lh_handle ('enable-campos').
  s-update-codmat = NO.
  */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recarga-Items-Backup B-table-Win 
PROCEDURE Recarga-Items-Backup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST w-report WHERE w-report.Llave-C = x-coddoc + x-nrodoc
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE w-report THEN RETURN.
s-task-no = w-report.task-no.
FOR EACH w-report WHERE w-report.task-no = s-task-no
    AND w-report.Llave-C = x-coddoc + x-nrodoc:
    CREATE Detalle.
    ASSIGN
        Detalle.CodCia = s-codcia
        w-report.Campo-C[1] = STRING(ROWID(Detalle))
        Detalle.NroItm = w-report.LLave-I
        Detalle.codmat = w-report.Campo-C[2]
        Detalle.UndVta = w-report.Campo-C[3]
        Detalle.CanPed = w-report.Campo-F[1].
END.
RUN Cuenta-Bultos.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Renumera-item B-table-Win 
PROCEDURE Renumera-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Item AS INT INIT 1 NO-UNDO.
  DEF BUFFER B-Detalle FOR Detalle.
  
  FOR EACH B-Detalle BY NroItm:
    B-Detalle.nroitm = x-item.
    RUN Graba-Backup-Items.
    x-item = x-item + 1.
  END.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  
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

  DO WITH FRAME {&FRAME-NAME}:
      x-NroDoc:SENSITIVE IN FRAME {&FRAME-NAME} = NO .
      ASSIGN FILL-IN-NroEtq TOGGLE-1.
  END.
  /* CHequeamos acumulado */
  DEF VAR x-CanPed AS DEC NO-UNDO.

  IF AVAILABLE Detalle THEN DO:
      FOR EACH b-Detalle NO-LOCK WHERE b-Detalle.codmat = Detalle.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}:
          x-CanPed = x-CanPed + b-Detalle.canped.
      END.
      x-CanPed = x-CanPed - Detalle.CanPed + DECIMAL(Detalle.canped:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
  END.
  ELSE DO:
      FOR EACH b-Detalle NO-LOCK WHERE b-Detalle.codmat = Detalle.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}:
          x-CanPed = x-CanPed + b-Detalle.canped.
      END.
      x-CanPed = x-CanPed + DECIMAL(Detalle.canped:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
  END.
  FIND T-DPEDI WHERE T-DPEDI.codmat = Detalle.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    NO-LOCK NO-ERROR.
  IF AVAILABLE T-DPEDI AND x-CanPed > T-DPEDI.canped THEN DO:
    MESSAGE 'CANTIDAD ingresada SUPERA la del pedido'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  IF AVAILABLE T-DPEDI AND x-CanPed < T-DPEDI.canped THEN DO:
    MESSAGE 'CANTIDAD ingresada ES MENOR a la del pedido'
        VIEW-AS ALERT-BOX WARNING.
  END.

  /* Buscamos si está repitiendo la secuencia */
  FIND FIRST b-Detalle WHERE INDEX(b-Detalle.Libre_c01, '-') > 0
      AND ENTRY(1,b-Detalle.Libre_c01,'-') = FILL-IN-NroEtq 
      NO-LOCK NO-ERROR.
  IF AVAILABLE b-Detalle THEN DO:
      MESSAGE 'NO puede repetir el Número de Etiqueta' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  IF s-Generacion-Multiple = YES
      AND CAN-FIND(FIRST b-Detalle WHERE b-Detalle.Libre_c01 = FILL-IN-NroEtq
                   NO-LOCK)
      THEN DO:
      MESSAGE 'NO puede repetir el Número de Etiqueta' VIEW-AS ALERT-BOX ERROR.
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
  RETURN "ADM-ERROR".
  /*s-update-codmat = NO.*/
  s-status-record = 'update-record'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

