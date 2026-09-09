&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-CcbDDocu NO-UNDO LIKE CcbDDocu.



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
DEFINE VAR X-MON AS CHARACTER NO-UNDO.
DEFINE VAR X-VTA AS CHARACTER NO-UNDO.
DEFINE VAR X-STA AS CHARACTER NO-UNDO.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE VAR S-CODDOC AS CHAR INIT "COT".
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE VAR R-COTI AS RECID.
DEFINE VAR F-ESTADO AS CHAR.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE VAR ss-CodDiv LIKE s-CodDiv.     /* ARTIFICIO */

DEFINE VAR x-FlgEst LIKE Ccbcdocu.flgest INIT '' NO-UNDO.
DEFINE VAR x-DiasVto AS INT INIT 0 NO-UNDO.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\Coti.ico" SIZE 12 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(60)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

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
&Scoped-define INTERNAL-TABLES t-CcbDDocu CcbDDocu CcbCDocu

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CcbDDocu.CodDoc CcbDDocu.NroDoc ~
CcbDDocu.FchDoc CcbCDocu.FchVto CcbDDocu.UndVta CcbDDocu.PreUni ~
CcbDDocu.CanDes CcbDDocu.ImpLin X-MON @ X-MON CcbCDocu.NomCli ~
CcbCDocu.FmaPgo CcbCDocu.SdoAct _Estado(CcbCDocu.FlgEst) @ f-Estado 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH t-CcbDDocu WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST CcbDDocu WHERE CcbDDocu.CodCia = t-CcbDDocu.CodCia ~
  AND CcbDDocu.CodDiv = t-CcbDDocu.CodDiv ~
  AND CcbDDocu.CodDoc = t-CcbDDocu.CodDoc ~
  AND CcbDDocu.NroDoc = t-CcbDDocu.NroDoc ~
  AND CcbDDocu.codmat = t-CcbDDocu.codmat NO-LOCK, ~
      FIRST CcbCDocu OF CcbDDocu NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH t-CcbDDocu WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST CcbDDocu WHERE CcbDDocu.CodCia = t-CcbDDocu.CodCia ~
  AND CcbDDocu.CodDiv = t-CcbDDocu.CodDiv ~
  AND CcbDDocu.CodDoc = t-CcbDDocu.CodDoc ~
  AND CcbDDocu.NroDoc = t-CcbDDocu.NroDoc ~
  AND CcbDDocu.codmat = t-CcbDDocu.codmat NO-LOCK, ~
      FIRST CcbCDocu OF CcbDDocu NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table t-CcbDDocu CcbDDocu CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-br_table t-CcbDDocu
&Scoped-define SECOND-TABLE-IN-QUERY-br_table CcbDDocu
&Scoped-define THIRD-TABLE-IN-QUERY-br_table CcbCDocu


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS F-DIVISION DesdeC f-desde f-hasta ~
COMBO-BOX-1 BUTTON-4 BUTTON-5 br_table RECT-1 
&Scoped-Define DISPLAYED-OBJECTS F-DIVISION DesdeC f-desde F-DESDIV ~
F-DESMAT f-hasta x-PreProm x-UndBas x-ImpTotMn x-ImpTotMe COMBO-BOX-1 ~
COMBO-BOX-2 

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
     LABEL "APLICAR FILTRO" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Estado" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","Pendientes","Cancelados" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Vencidas" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","Mas de 15 dias","Mas de 30 dias","Mas de 60 dias" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(15)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .69 NO-UNDO.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-DESDIV AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48.29 BY .69 NO-UNDO.

DEFINE VARIABLE F-DESMAT AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48.29 BY .69 NO-UNDO.

DEFINE VARIABLE F-DIVISION AS CHARACTER FORMAT "X(10)":U 
     LABEL "Division Origen" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .69 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-ImpTotMe AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total US$" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE x-ImpTotMn AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total S/." 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE x-PreProm AS DECIMAL FORMAT "->>>,>>9.9999":U INITIAL 0 
     LABEL "Precio Promedio S/." 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-UndBas AS CHARACTER FORMAT "X(256)":U 
     LABEL "Unidad" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 134 BY 2.96.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      t-CcbDDocu, 
      CcbDDocu, 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      CcbDDocu.CodDoc FORMAT "x(3)":U
      CcbDDocu.NroDoc FORMAT "x(15)":U WIDTH 10.14
      CcbDDocu.FchDoc COLUMN-LABEL "Fecha ! Documento" FORMAT "99/99/99":U
      CcbCDocu.FchVto FORMAT "99/99/99":U
      CcbDDocu.UndVta COLUMN-LABEL "Unidad" FORMAT "XXXXXX":U
      CcbDDocu.PreUni FORMAT "->,>>>,>>9.99999":U
      CcbDDocu.CanDes FORMAT ">,>>>,>>9.99":U
      CcbDDocu.ImpLin FORMAT "->>,>>>,>>9.99":U
      X-MON @ X-MON COLUMN-LABEL "Moneda" FORMAT "XXXXX":U
      CcbCDocu.NomCli FORMAT "x(35)":U
      CcbCDocu.FmaPgo FORMAT "X(10)":U
      CcbCDocu.SdoAct COLUMN-LABEL "Saldo Actual" FORMAT "->>,>>>,>>9.99":U
      _Estado(CcbCDocu.FlgEst) @ f-Estado COLUMN-LABEL "Estado" FORMAT "x(10)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 134 BY 13.58
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-DIVISION AT ROW 1.54 COL 15.14 COLON-ALIGNED
     DesdeC AT ROW 2.35 COL 15.14 COLON-ALIGNED
     f-desde AT ROW 3.15 COL 15 COLON-ALIGNED
     F-DESDIV AT ROW 1.58 COL 23.72 COLON-ALIGNED NO-LABEL
     F-DESMAT AT ROW 2.38 COL 23.72 COLON-ALIGNED NO-LABEL
     f-hasta AT ROW 3.12 COL 31.43 COLON-ALIGNED
     x-PreProm AT ROW 17.88 COL 37 COLON-ALIGNED
     x-UndBas AT ROW 18.85 COL 37 COLON-ALIGNED
     x-ImpTotMn AT ROW 17.88 COL 55 COLON-ALIGNED
     x-ImpTotMe AT ROW 18.65 COL 55 COLON-ALIGNED
     COMBO-BOX-1 AT ROW 1.73 COL 96.57 COLON-ALIGNED
     COMBO-BOX-2 AT ROW 2.69 COL 94.57 COLON-ALIGNED
     BUTTON-4 AT ROW 1.54 COL 118
     BUTTON-5 AT ROW 2.88 COL 118 WIDGET-ID 6
     br_table AT ROW 4.23 COL 2
     "Filtros:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 1 COL 3 WIDGET-ID 4
          BGCOLOR 1 FGCOLOR 15 
     RECT-1 AT ROW 1.27 COL 2 WIDGET-ID 2
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
      TABLE: t-CcbDDocu T "?" NO-UNDO INTEGRAL CcbDDocu
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
         HEIGHT             = 18.81
         WIDTH              = 138.29.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
/* BROWSE-TAB br_table BUTTON-5 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX COMBO-BOX-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DESDIV IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DESMAT IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-ImpTotMe IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-ImpTotMn IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-PreProm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-UndBas IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.t-CcbDDocu,INTEGRAL.CcbDDocu WHERE Temp-Tables.t-CcbDDocu ...,INTEGRAL.CcbCDocu OF INTEGRAL.CcbDDocu"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST, FIRST"
     _JoinCode[2]      = "INTEGRAL.CcbDDocu.CodCia = Temp-Tables.t-CcbDDocu.CodCia
  AND INTEGRAL.CcbDDocu.CodDiv = Temp-Tables.t-CcbDDocu.CodDiv
  AND INTEGRAL.CcbDDocu.CodDoc = Temp-Tables.t-CcbDDocu.CodDoc
  AND INTEGRAL.CcbDDocu.NroDoc = Temp-Tables.t-CcbDDocu.NroDoc
  AND INTEGRAL.CcbDDocu.codmat = Temp-Tables.t-CcbDDocu.codmat"
     _FldNameList[1]   = integral.CcbDDocu.CodDoc
     _FldNameList[2]   > integral.CcbDDocu.NroDoc
"CcbDDocu.NroDoc" ? "x(15)" "character" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.CcbDDocu.FchDoc
"CcbDDocu.FchDoc" "Fecha ! Documento" "99/99/99" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > integral.CcbCDocu.FchVto
"CcbCDocu.FchVto" ? "99/99/99" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > integral.CcbDDocu.UndVta
"CcbDDocu.UndVta" "Unidad" "XXXXXX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > integral.CcbDDocu.PreUni
"CcbDDocu.PreUni" ? "->,>>>,>>9.99999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > integral.CcbDDocu.CanDes
"CcbDDocu.CanDes" ? ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = integral.CcbDDocu.ImpLin
     _FldNameList[9]   > "_<CALC>"
"X-MON @ X-MON" "Moneda" "XXXXX" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > integral.CcbCDocu.NomCli
"CcbCDocu.NomCli" ? "x(35)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > integral.CcbCDocu.FmaPgo
"CcbCDocu.FmaPgo" ? "X(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > integral.CcbCDocu.SdoAct
"CcbCDocu.SdoAct" "Saldo Actual" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"_Estado(CcbCDocu.FlgEst) @ f-Estado" "Estado" "x(10)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON MOUSE-SELECT-DBLCLICK OF br_table IN FRAME F-Main
DO:
/*  RUN vta\d-peddet.r(Faccpedi.nroped,gn-clie.nomcli).
    RUN vta\d-peddet.r(Faccpedi.nroped,Faccpedi.nomcli,"COT").*/
  
/*    RUN vta\D-pedcon.r(Faccpedi.nroped,"COT").*/


   ss-CodDiv = s-CodDiv.
   s-CodDiv = F-DIVISION.
   RUN VTA\D-cmpbte(Ccbddocu.NroDoc,CcbdDocu.CodDoc).
   s-CodDiv = ss-CodDiv.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 B-table-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* APLICAR FILTRO */
DO:
  IF TRUE <> (F-DIVISION > '') THEN DO:
      MESSAGE 'Debe ingresar una división válida' VIEW-AS ALERT-BOX WARNING.
      APPLY 'ENTRY':U TO F-DIVISION.
      RETURN NO-APPLY.
  END.
  IF TRUE <> (DesdeC > '') THEN DO:
      MESSAGE 'Debe ingresar un artículo válido' VIEW-AS ALERT-BOX WARNING.
      APPLY 'ENTRY':U TO DesdeC.
      RETURN NO-APPLY.
  END.
  IF f-desde = ? OR f-hasta = ? THEN DO:
      MESSAGE 'Debe ingresar fechas válidas' VIEW-AS ALERT-BOX WARNING.
      APPLY 'ENTRY':U TO F-DESDE.
      RETURN NO-APPLY.
  END.
  RUN Carga-Temporal.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-1 B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-1 IN FRAME F-Main /* Estado */
DO:
  ASSIGN {&SELF-NAME}.
  CASE {&SELF-NAME}:
    WHEN 'Todos' THEN DO:
        ASSIGN
            x-FlgEst = ''
            COMBO-BOX-2:SENSITIVE = NO
            COMBO-BOX-2:SCREEN-VALUE = 'Todos'.
    END.        
    WHEN 'Pendientes' THEN DO:
        ASSIGN
            x-FlgEst = 'P'
            COMBO-BOX-2:SENSITIVE = YES.
    END.
    WHEN 'Cancelados' THEN DO:
        ASSIGN
            x-FlgEst = 'C'
            COMBO-BOX-2:SENSITIVE = NO
            COMBO-BOX-2:SCREEN-VALUE = 'Todos'.
    END.
  END CASE.
  ASSIGN COMBO-BOX-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-2 B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-2 IN FRAME F-Main /* Vencidas */
DO:
  ASSIGN {&SELF-NAME}.
  CASE {&SELF-NAME}:
    WHEN 'Todos' THEN x-DiasVto = 0.
    WHEN 'Mas de 15 dias' THEN x-DiasVto = 15.
    WHEN 'Mas de 30 dias' THEN x-DiasVto = 30.
    WHEN 'Mas de 60 dias' THEN x-DiasVto = 60.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC B-table-Win
ON LEAVE OF DesdeC IN FRAME F-Main /* Articulo */
DO:
  F-DESMAT:SCREEN-VALUE = ''.
  x-UndBas:SCREEN-VALUE = ''.
  IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.

  DEF VAR pCodMat AS CHAR NO-UNDO.
  pCodMat = SELF:SCREEN-VALUE.
  RUN vta2/p-codigo-producto.r (INPUT-OUTPUT pCodMat, YES).
  IF TRUE <> (pCodMat > '') THEN RETURN.
  SELF:SCREEN-VALUE = pCodMat.

  ASSIGN {&self-name}.
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
      AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almmmatg THEN DO:
      F-DESMAT = Almmmatg.DesMat.
      x-UndBas = Almmmatg.UndBas.
  END.
  DISPLAY F-DESMAT  x-UndBas WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-desde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-desde B-table-Win
ON LEAVE OF f-desde IN FRAME F-Main /* Desde */
DO:
  ASSIGN f-desde.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-DIVISION
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DIVISION B-table-Win
ON LEAVE OF F-DIVISION IN FRAME F-Main /* Division Origen */
DO:
 DO WITH FRAME {&FRAME-NAME}:
     F-DESDIV:SCREEN-VALUE = "".
     ASSIGN F-DIVISION.
     IF F-DIVISION <> "" THEN DO:        
         FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
             Gn-Divi.Coddiv = F-DIVISION NO-LOCK NO-ERROR.
         IF NOT AVAILABLE Gn-Divi THEN DO:
             MESSAGE "Division " + F-DIVISION + " No Existe " SKIP
                 "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO F-DIVISION IN FRAME {&FRAME-NAME}.
             RETURN NO-APPLY.
         END.
         F-DESDIV =  Gn-Divi.Desdiv .           
     END.
     DISPLAY F-DESDIV @ F-DESDIV .
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-hasta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-hasta B-table-Win
ON LEAVE OF f-hasta IN FRAME F-Main /* Hasta */
DO:
  ASSIGN f-hasta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */
ON FIND OF CCBCDOCU 

DO:

    IF CcbCDocu.CodMon = 1 THEN
        ASSIGN
            X-MON = "S/." .
    ELSE
        ASSIGN
            X-MON = "US$" .
END.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-Totales B-table-Win 
PROCEDURE Calcula-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Signo AS INT.
  DEF VAR x-CanDes AS DEC.
  DEF VAR x-ImpTot AS DEC.
  
  ASSIGN
    x-ImpTotMe = 0
    x-ImpTotMn = 0
    x-PreProm = 0.
  
  SESSION:SET-WAIT-STATE('GENERAL').
  Fi-Mensaje = "CALCULANDO TOTALES, un momento por favor...".
  DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
  GET FIRST {&BROWSE-NAME}.
  DO WHILE AVAILABLE(CcbDDocu):
    x-Signo = IF CcbCDocu.coddoc = 'N/C' THEN -1 ELSE 1.
    IF LOOKUP(TRIM(ccbcdocu.coddoc), 'FAC,BOL,N/C,TCK') > 0 THEN DO:
        IF CcbCDocu.codmon = 1
        THEN x-ImpTotMn = x-ImpTotMn + ccbddocu.implin * x-signo.
        ELSE x-ImpTotMe = x-ImpTotMe + ccbddocu.implin * x-signo.   
        IF LOOKUP(TRIM(ccbcdocu.coddoc), 'FAC,BOL,TCK') > 0 THEN DO:
            x-CanDes = x-CanDes + ccbddocu.candes * ccbddocu.factor.
            IF ccbcdocu.codmon = 1 
            THEN x-ImpTot = x-ImpTot + ccbddocu.implin.
            ELSE x-ImpTot = x-ImpTot + ccbddocu.implin * ccbcdocu.tpocmb.
        END.
    END.
    GET NEXT {&BROWSE-NAME}.
  END.
  IF x-CanDes > 0
  THEN x-PreProm = x-ImpTot / x-CanDes.
  DISPLAY x-ImpTotMn x-ImpTotMe x-PreProm WITH FRAME {&FRAME-NAME}.
  HIDE FRAME F-Proceso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-CodDoc AS CHAR INIT 'FAC,BOL' NO-UNDO.

EMPTY TEMP-TABLE t-Ccbddocu.

DEF VAR k AS INTE NO-UNDO.
SESSION:SET-WAIT-STATE('GENERAL').
Fi-Mensaje = "PROCESANDO INFORMACION, un momento por favor...".
DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
DO k = 1 TO NUM-ENTRIES(x-CodDoc):
    FOR EACH Ccbcdocu 
        FIELDS (codcia coddiv coddoc nrodoc divori fchdoc fchvto flgest codmon) 
        NO-LOCK 
        WHERE Ccbcdocu.codcia = s-codcia AND
        Ccbcdocu.divori = F-DIVISION AND
        Ccbcdocu.fchdoc >= F-DESDE AND
        Ccbcdocu.fchdoc <= F-HASTA AND
        Ccbcdocu.coddoc = ENTRY(k, x-CodDoc):
        IF x-FlgEst > '' AND NOT (Ccbcdocu.flgest = x-FlgEst) THEN NEXT.

        IF NOT ( COMBO-BOX-2 = 'Todos' OR (TODAY - Ccbcdocu.FchVto) > x-DiasVto ) THEN NEXT.

        IF NOT CAN-FIND(FIRST Ccbddocu OF Ccbcdocu WHERE Ccbddocu.codmat = DESDEC NO-LOCK)
            THEN NEXT.

        Fi-Mensaje = "DOCUMENTO: " + Ccbcdocu.CodDoc + " " + Ccbcdocu.NroDoc + " " + STRING(Ccbcdocu.fchdoc).
        DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
        /* OJO: No se repiten los códigos de artículos */
        FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK WHERE Ccbddocu.codmat = DESDEC:
            CREATE t-Ccbddocu.
            BUFFER-COPY Ccbddocu TO t-Ccbddocu.
        END.
    END.
END.
HIDE FRAME F-Proceso.
SESSION:SET-WAIT-STATE("").

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

DEF VAR x-Estado AS CHAR.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
    /*chWorkSheet:Columns("A"):ColumnWidth = 10.
     * chWorkSheet:Columns("B"):ColumnWidth = 10.
     * chWorkSheet:Columns("C"):ColumnWidth = 10.
     * chWorkSheet:Columns("D"):ColumnWidth = 10.
     * chWorkSheet:Columns("E"):ColumnWidth = 20.
     * chWorkSheet:Columns("F"):ColumnWidth = 20.
     * chWorkSheet:Columns("G"):ColumnWidth = 20.
     * chWorkSheet:Columns("H"):ColumnWidth = 10.
     * chWorkSheet:Columns("I"):ColumnWidth = 50.
     * chWorkSheet:Columns("J"):ColumnWidth = 10.*/

chWorkSheet:Range("A2"):Value = "Codigo".
chWorkSheet:Range("B2"):Value = "Numero".
chWorkSheet:Range("C2"):Value = "Fecha".
chWorkSheet:Range("D2"):Value = "Vencimiento".
chWorkSheet:Range("E2"):Value = "Unidad".
chWorkSheet:Range("F2"):Value = "Precio".
chWorkSheet:Range("G2"):Value = "Cantidad".
chWorkSheet:Range("H2"):Value = "Importe".
chWorkSheet:Range("I2"):Value = "Moneda".
chWorkSheet:Range("J2"):Value = "Cliente".
chWorkSheet:Range("K2"):Value = "Cond. de Venta".
chWorkSheet:Range("L2"):Value = "Saldo".
chWorkSheet:Range("M2"):Value = "Estado".
chWorkSheet:Range("N2"):Value = "Vendedor".

GET FIRST {&BROWSE-NAME}.
REPEAT WHILE AVAILABLE CcbDDocu:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = ccbddocu.coddoc.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + STRING(ccbddocu.nrodoc, 'x(15)').
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = ccbddocu.fchdoc.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = ccbcdocu.fchvto.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = ccbddocu.undvta.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = ccbddocu.preuni.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = ccbddocu.candes.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = ccbddocu.implin.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = IF ccbcdocu.codmon = 1 THEN 'S/.' ELSE 'US$'.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = ccbcdocu.nomcli.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + ccbcdocu.fmapgo.
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = ccbcdocu.sdoact.
    cRange = "M" + cColumn.
    x-Estado = _Estado(ccbcdocu.flgest).
    chWorkSheet:Range(cRange):Value = "'" + x-Estado.
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbCDocu.CodVen.
    GET NEXT {&BROWSE-NAME}.
END.
t-column = t-column + 2.
cColumn = STRING(t-Column).
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = 'Precio Promedio S/.'.
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = x-PreProm.
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = 'Total S/.'.
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = x-ImpTotMn.
t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = 'Unidad'.
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = x-UndBas.
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = 'Total US$'.
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = x-ImpTotMe.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  F-DIVISION = S-CODDIV.
  DESDEC     = "".
  F-DESDE    = TODAY.
  F-HASTA    = TODAY.
  F-DESMAT = "".
  F-DESDIV = ""  .
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                 AND  Almmmatg.CodMat = DESDEC NO-LOCK NO-ERROR.
  IF AVAILABLE Almmmatg THEN F-DESMAT = Almmmatg.DesMat .
  FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA 
      AND Gn-Divi.CodDiv = S-CODDIV NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-Divi THEN F-DESDIV = Gn-Divi.DesDiv .

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  RUN Calcula-Totales.
  
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
  {src/adm/template/snd-list.i "t-CcbDDocu"}
  {src/adm/template/snd-list.i "CcbDDocu"}
  {src/adm/template/snd-list.i "CcbCDocu"}

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

