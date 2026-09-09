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

DEF SHARED VAR s-CodCia AS INT.
DEF SHARED VAR cb-codcia AS INT.
DEF VAR cTpoRef AS CHARACTER.
DEF VAR cFlgEst AS CHARACTER.
DEF VAR rpta AS LOGICAL NO-UNDO.
DEF VAR moneda AS CHARACTER NO-UNDO.
DEF VAR importe AS DECIMAL NO-UNDO.
DEF VAR TarjCre AS CHARACTER NO-UNDO.
DEF VAR NroTarj AS CHARACTER NO-UNDO.
DEF VAR x-CodDiv AS CHAR INIT 'Todos' NO-UNDO.
DEF VAR x-CodDoc AS CHAR INIT "I/C" NO-UNDO.

DEFINE BUFFER b_DMvtO FOR CcbDMvto.

cTpoRef = "TCR".
cFlgEst = "P".

&SCOPED-DEFINE Condicion ( CcbDMvto.CodCia = S-CodCia ~
AND (x-CodDiv = "Todos" OR CcbDMvto.CodDiv = x-CodDiv) ~
AND CcbDMvto.CodDoc = x-CodDoc ~
AND CcbDMvto.TpoRef = cTpoRef ~
AND ( FILL-IN-Fecha-1 = ? OR CcbDMvto.FchEmi >= FILL-IN-Fecha-1 ) ~
AND ( FILL-IN-Fecha-2 = ? OR CcbDMvto.FchEmi <= FILL-IN-Fecha-2 ) ~
AND CcbDMvto.FlgEst BEGINS cFlgEst ) ~
AND (COMBO-BOX-NroRef = 'Todas' OR  CcbDMvto.NroRef BEGINS COMBO-BOX-NroRef)

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
&Scoped-define INTERNAL-TABLES CcbDMvto CcbCCaja

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CcbDMvto.CodDiv CcbDMvto.CodDoc ~
CcbDMvto.NroDoc CcbDMvto.TpoRef CcbDMvto.FlgEst TarjCre @ TarjCre ~
NroTarj @ NroTarj CcbDMvto.codbco CcbDMvto.CodCta CcbDMvto.NroDep ~
CcbDMvto.FchEmi Moneda @ Moneda Importe @ Importe CcbCCaja.usuario ~
CcbCCaja.FchCie 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH CcbDMvto WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST CcbCCaja OF CcbDMvto OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH CcbDMvto WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST CcbCCaja OF CcbDMvto OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table CcbDMvto CcbCCaja
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CcbDMvto
&Scoped-define SECOND-TABLE-IN-QUERY-br_table CcbCCaja


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-tipo COMBO-BOX-NroRef BUTTON-1 ~
COMBO-Situacion COMBO-BOX-Division FILL-IN-Fecha-1 FILL-IN-Fecha-2 br_table ~
F-Banco F-Cta 
&Scoped-Define DISPLAYED-OBJECTS COMBO-tipo COMBO-BOX-NroRef ~
COMBO-Situacion FILL-IN-Nac FILL-IN-USA COMBO-BOX-Division FILL-IN-Fecha-1 ~
FILL-IN-Fecha-2 F-Banco FILL-IN-16 F-Cta FILL-IN-17 FILL-IN-NroOpe F-Fecha 

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
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 6 BY 1.35.

DEFINE VARIABLE COMBO-BOX-Division AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "División" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 65 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-NroRef AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     VIEW-AS COMBO-BOX INNER-LINES 7
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 27 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-Situacion AS CHARACTER FORMAT "X(256)":U INITIAL "Pendientes" 
     LABEL "Estado" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","Pendientes","Confirmados" 
     DROP-DOWN-LIST
     SIZE 14.57 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE COMBO-tipo AS CHARACTER FORMAT "X(256)":U INITIAL "Tarjeta Crédito" 
     LABEL "Tipo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Bóveda","Tarjeta Crédito","Vales Sodexo" 
     DROP-DOWN-LIST
     SIZE 14.57 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-Banco AS CHARACTER FORMAT "X(3)":U INITIAL "IB" 
     LABEL "Banco" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-Cta AS CHARACTER FORMAT "X(25)":U INITIAL "10416100" 
     LABEL "Cuenta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-Fecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Depósito" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-16 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-17 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Nac AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total S/." 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .81
     BGCOLOR 9 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-NroOpe AS CHARACTER FORMAT "X(10)":U 
     LABEL "Nº Operación" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-USA AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total US$" 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .81
     BGCOLOR 9 FGCOLOR 15  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      CcbDMvto, 
      CcbCCaja SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      CcbDMvto.CodDiv FORMAT "x(5)":U WIDTH 5.43
      CcbDMvto.CodDoc COLUMN-LABEL "Cod!Doc" FORMAT "x(3)":U
      CcbDMvto.NroDoc FORMAT "XXX-XXXXXXXX":U
      CcbDMvto.TpoRef FORMAT "XXXX":U
      CcbDMvto.FlgEst COLUMN-LABEL "Est" FORMAT "X":U
      TarjCre @ TarjCre COLUMN-LABEL "Tarjeta Crédito" FORMAT "x(24)":U
      NroTarj @ NroTarj COLUMN-LABEL "Nro Tarjeta" FORMAT "x(20)":U
      CcbDMvto.codbco FORMAT "x(5)":U
      CcbDMvto.CodCta FORMAT "X(10)":U
      CcbDMvto.NroDep COLUMN-LABEL "No. de Depósito" FORMAT "X(10)":U
      CcbDMvto.FchEmi COLUMN-LABEL "F. Emisión" FORMAT "99/99/99":U
      Moneda @ Moneda COLUMN-LABEL "Mon" FORMAT "x(3)":U
      Importe @ Importe COLUMN-LABEL "Importe" WIDTH 9
      CcbCCaja.usuario COLUMN-LABEL "Usuario" FORMAT "x(10)":U
      CcbCCaja.FchCie COLUMN-LABEL "Fecha de!Cierre" FORMAT "99/99/9999":U
            WIDTH 9.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 123 BY 11.73
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-tipo AT ROW 1.19 COL 10 COLON-ALIGNED
     COMBO-BOX-NroRef AT ROW 1.19 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     BUTTON-1 AT ROW 1.19 COL 100 WIDGET-ID 8
     COMBO-Situacion AT ROW 2.15 COL 10 COLON-ALIGNED
     FILL-IN-Nac AT ROW 2.15 COL 34 COLON-ALIGNED
     FILL-IN-USA AT ROW 2.15 COL 56 COLON-ALIGNED
     COMBO-BOX-Division AT ROW 3.12 COL 10 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-Fecha-1 AT ROW 4.08 COL 10 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-Fecha-2 AT ROW 4.08 COL 38 COLON-ALIGNED WIDGET-ID 6
     br_table AT ROW 5.23 COL 2
     F-Banco AT ROW 17.15 COL 38 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-16 AT ROW 17.15 COL 43.57 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     F-Cta AT ROW 17.92 COL 38 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-17 AT ROW 17.92 COL 49 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN-NroOpe AT ROW 18.69 COL 38 COLON-ALIGNED WIDGET-ID 22
     F-Fecha AT ROW 19.46 COL 38 COLON-ALIGNED WIDGET-ID 20
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
         HEIGHT             = 20.35
         WIDTH              = 135.86.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table FILL-IN-Fecha-2 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 2.

/* SETTINGS FOR FILL-IN F-Fecha IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-16 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-17 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Nac IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroOpe IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-USA IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.CcbDMvto,INTEGRAL.CcbCCaja OF INTEGRAL.CcbDMvto"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST OUTER"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > INTEGRAL.CcbDMvto.CodDiv
"CcbDMvto.CodDiv" ? ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.CcbDMvto.CodDoc
"CcbDMvto.CodDoc" "Cod!Doc" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.CcbDMvto.NroDoc
"CcbDMvto.NroDoc" ? "XXX-XXXXXXXX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.CcbDMvto.TpoRef
"CcbDMvto.TpoRef" ? "XXXX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.CcbDMvto.FlgEst
"CcbDMvto.FlgEst" "Est" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"TarjCre @ TarjCre" "Tarjeta Crédito" "x(24)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"NroTarj @ NroTarj" "Nro Tarjeta" "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = INTEGRAL.CcbDMvto.codbco
     _FldNameList[9]   = INTEGRAL.CcbDMvto.CodCta
     _FldNameList[10]   > INTEGRAL.CcbDMvto.NroDep
"CcbDMvto.NroDep" "No. de Depósito" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.CcbDMvto.FchEmi
"CcbDMvto.FchEmi" "F. Emisión" "99/99/99" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"Moneda @ Moneda" "Mon" "x(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"Importe @ Importe" "Importe" ? ? ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > INTEGRAL.CcbCCaja.usuario
"CcbCCaja.usuario" "Usuario" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > INTEGRAL.CcbCCaja.FchCie
"CcbCCaja.FchCie" "Fecha de!Cierre" ? "date" ? ? ? ? ? ? no ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON MOUSE-SELECT-CLICK OF br_table IN FRAME F-Main
DO:

    DEFINE VARIABLE i AS INTEGER NO-UNDO.

    FILL-IN-Nac = 0.
    FILL-IN-USA = 0.

    DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
        IF NOT {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN NEXT.
        /*IF CcbDMvto.FlgEst = "C" THEN NEXT.*/
        FILL-IN-Nac = FILL-IN-Nac + CcbDMvto.DepNac[1].
        FILL-IN-Usa = FILL-IN-Usa + CcbDMvto.DepUSA[1].
    END.

    DISPLAY FILL-IN-Nac FILL-IN-USA WITH FRAME {&FRAME-NAME}.

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
      DEFINE VARIABLE i AS INTEGER NO-UNDO.

      FILL-IN-Nac = 0.
      FILL-IN-USA = 0.

      DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
          IF NOT {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN NEXT.
          /*IF CcbDMvto.FlgEst = "C" THEN NEXT.*/
          FILL-IN-Nac = FILL-IN-Nac + CcbDMvto.DepNac[1].
          FILL-IN-Usa = FILL-IN-Usa + CcbDMvto.DepUSA[1].
      END.

      DISPLAY FILL-IN-Nac FILL-IN-USA WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Division B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Division IN FRAME F-Main /* División */
DO:
  ASSIGN {&self-name}.
  x-CodDiv = ENTRY(1, SELF:SCREEN-VALUE, ' - ').
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-NroRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-NroRef B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-NroRef IN FRAME F-Main
DO:
    ASSIGN {&self-name}.
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-Situacion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-Situacion B-table-Win
ON VALUE-CHANGED OF COMBO-Situacion IN FRAME F-Main /* Estado */
DO:
    ASSIGN COMBO-Situacion.
    CASE COMBO-Situacion:
        WHEN "Todos" OR WHEN ? THEN cFlgEst = "".
        WHEN "Pendientes" THEN cFlgEst = "P".
        WHEN "Confirmados" THEN cFlgEst = "C".
    END CASE.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-tipo B-table-Win
ON VALUE-CHANGED OF COMBO-tipo IN FRAME F-Main /* Tipo */
DO:
    ASSIGN COMBO-Tipo.
    CASE COMBO-Tipo:
        WHEN "Bóveda" THEN ASSIGN cTpoRef = "BOV" x-CodDoc = "E/C".
        WHEN "Tarjeta Crédito" THEN ASSIGN cTpoRef = "TCR" x-CodDoc = "I/C".
        WHEN "Vales Sodexo" THEN ASSIGN cTpoRef = "VAL" x-CodDoc = "I/C".
    END CASE.
    CASE COMBO-Tipo:
        WHEN "Tarjeta Crédito" THEN DO:
            ASSIGN 
                COMBO-BOX-NroRef:SENSITIVE = YES      
                F-Banco:SENSITIVE = YES
                F-Cta:SENSITIVE = YES
                F-Fecha :SENSITIVE = NO
                FILL-IN-NroOpe:SENSITIVE = NO.
        END.
        WHEN "Bóveda" THEN DO:
            ASSIGN 
                COMBO-BOX-NroRef = 'Todas'
                COMBO-BOX-NroRef:SENSITIVE = NO  
                F-Banco:SENSITIVE = YES
                F-Cta:SENSITIVE = YES
                F-Fecha :SENSITIVE = YES
                FILL-IN-NroOpe:SENSITIVE = YES.
        END.
        OTHERWISE DO:
            ASSIGN
                COMBO-BOX-NroRef = 'Todas'
                COMBO-BOX-NroRef:SENSITIVE = NO
                F-Banco:SENSITIVE = NO
                F-Cta:SENSITIVE = NO
                F-Fecha :SENSITIVE = NO
                FILL-IN-NroOpe:SENSITIVE = NO.
        END.
    END CASE.
    DISPLAY COMBO-BOX-NroRef WITH FRAME {&FRAME-NAME}.
/*     IF COMBO-Tipo <> "Tarjeta Crédito" THEN DO:            */
/*         COMBO-BOX-NroRef = 'Todas'.                        */
/*         COMBO-BOX-NroRef:SENSITIVE = NO.                   */
/*         F-Banco:SENSITIVE = NO.                            */
/*         F-Cta:SENSITIVE = NO.                              */
/*         DISPLAY COMBO-BOX-NroRef WITH FRAME {&FRAME-NAME}. */
/*     END.                                                   */
/*     ELSE ASSIGN                                            */
/*         COMBO-BOX-NroRef:SENSITIVE = YES                   */
/*         F-Banco:SENSITIVE = YES                            */
/*         F-Cta:SENSITIVE = YES.                             */
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Banco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Banco B-table-Win
ON ENTRY OF F-Banco IN FRAME F-Main /* Banco */
DO:
  ASSIGN
    F-Banco 
    F-Cta
    .
 END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Banco B-table-Win
ON LEAVE OF F-Banco IN FRAME F-Main /* Banco */
DO:

  ASSIGN
    F-Banco 
    F-Cta
    .
  
  IF SELF:SCREEN-VALUE = "" THEN DO:
     DISPLAY 
        "" @ F-Banco 
        "" @ FILL-IN-16 
        WITH FRAME {&FRAME-NAME}.
     RETURN.
  END.
  FIND cb-tabl WHERE cb-tabl.Tabla  = "04"
                AND  cb-tabl.Codigo = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE cb-tabl THEN DO:
    MESSAGE "Banco no registrado" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  /* Buscamos cuenta */
  FIND FIRST cb-ctas WHERE cb-ctas.CodCia = cb-codcia
      AND cb-ctas.codbco = SELF:SCREEN-VALUE
      AND cb-ctas.activo = YES
      NO-LOCK NO-ERROR.
  DISPLAY 
    cb-tabl.Codigo @ F-Banco 
    cb-tabl.Nombre @ FILL-IN-16 
    cb-ctas.codcta WHEN AVAILABLE cb-ctas @ F-Cta 
    WITH FRAME {&FRAME-NAME}.   
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Banco B-table-Win
ON MOUSE-SELECT-DBLCLICK OF F-Banco IN FRAME F-Main /* Banco */
DO:
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = "04"
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    RUN LKUP/C-Tablas.r("").
    IF OUTPUT-VAR-1 <> ? THEN DO:
        FIND cb-tabl WHERE ROWID(cb-tabl) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
        DISPLAY 
          cb-tabl.Codigo @ F-Banco 
          cb-tabl.Nombre @ FILL-IN-16 
          WITH FRAME {&FRAME-NAME}.  
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Cta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Cta B-table-Win
ON LEAVE OF F-Cta IN FRAME F-Main /* Cuenta */
DO:
    ASSIGN
        F-Cta.
 
    IF SELF:SCREEN-VALUE = "" THEN DO:
        DISPLAY 
            "" @ F-Cta 
            "" @ FILL-IN-17  
            WITH FRAME {&FRAME-NAME}.
        RETURN.
    END.

    FIND cb-ctas WHERE
        cb-ctas.CodCia = cb-codcia AND
        LENGTH(cb-ctas.Codcta) >= 6 AND
        cb-ctas.codcta = SELF:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE
            "Cuenta de Banco no Registrado"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY. 
    END.
    ASSIGN {&self-name}.
    DISPLAY 
        cb-ctas.Codcta @ F-Cta 
        cb-ctas.Nomcta @ FILL-IN-17  
        WITH FRAME {&FRAME-NAME}.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Fecha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Fecha B-table-Win
ON ENTRY OF F-Fecha IN FRAME F-Main /* Fecha Depósito */
DO:

    ASSIGN
        F-Banco 
        F-Cta
        F-Fecha.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Fecha B-table-Win
ON LEAVE OF F-Fecha IN FRAME F-Main /* Fecha Depósito */
DO:

    ASSIGN
        F-Banco 
        F-Cta
        F-Fecha.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Fecha-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Fecha-1 B-table-Win
ON LEAVE OF FILL-IN-Fecha-1 IN FRAME F-Main /* Desde */
DO:
  ASSIGN {&self-name}.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Fecha-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Fecha-2 B-table-Win
ON LEAVE OF FILL-IN-Fecha-2 IN FRAME F-Main /* Hasta */
DO:
    ASSIGN {&self-name}.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroOpe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroOpe B-table-Win
ON LEAVE OF FILL-IN-NroOpe IN FRAME F-Main /* Nº Operación */
DO:
    ASSIGN {&SELF-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

ON FIND OF CcbDMvto DO:
    IF NUM-ENTRIES(CcbDMvto.NroRef,"|") > 1 THEN DO:
        TarjCre = ENTRY(1,CcbDMvto.NroRef,"|").
        NroTarj = ENTRY(2,CcbDMvto.NroRef,"|").
    END.
    ELSE DO:
        TarjCre = CcbDMvto.NroRef.
        NroTarj = "".
    END.
    IF CcbDMvto.DepUsa[1] > 0 THEN DO:
        Moneda = "US$".
        Importe = CcbDMvto.DepUsa[1].
    END.
    ELSE DO:
        Moneda = "S/.".
        Importe = CcbDMvto.DepNac[1].
    END.
END.

/*
ON MOUSE-EXTEND-CLICK OF {&BROWSE-NAME} IN FRAME {&FRAME-NAME}
DO:
MESSAGE "User is selecting multiple rows"
VIEW-AS ALERT-BOX INFO BUTTONS OK.
END.
*/

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
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 1.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
ASSIGN
    chWorkSheet:Range("A1"):Value = "CONFIRMACION DE DEPOSITOS"
    chWorkSheet:Range("A2"):Value = "DIVISION"
    chWorkSheet:Columns("A"):NumberFormat = "@"
    chWorkSheet:Range("B2"):Value = "COD DOC"
    chWorkSheet:Range("C2"):Value = "NUMERO"
    chWorkSheet:Columns("C"):NumberFormat = "@"
    chWorkSheet:Range("D2"):Value = "TIPO"
    chWorkSheet:Range("E2"):Value = "EST"
    chWorkSheet:Range("F2"):Value = "TARJETA DE CREDITO"
    chWorkSheet:Columns("F"):NumberFormat = "@"
    chWorkSheet:Range("G2"):Value = "NRO TARJETA"
    chWorkSheet:Columns("G"):NumberFormat = "@"
    chWorkSheet:Range("H2"):Value = "BANCO"
    chWorkSheet:Columns("H"):NumberFormat = "@"
    chWorkSheet:Range("I2"):Value = "CUENTA"
    chWorkSheet:Columns("I"):NumberFormat = "@"
    chWorkSheet:Range("J2"):Value = "NRO DE DEPOSITO"
    chWorkSheet:Columns("J"):NumberFormat = "@"
    chWorkSheet:Range("K2"):Value = "F. EMISION"
    chWorkSheet:Columns("K"):NumberFormat = "dd/mm/yyyy"
    chWorkSheet:Range("L2"):Value = "MON"
    chWorkSheet:Range("M2"):Value = "IMPORTE"
    chWorkSheet:Range("N2"):Value = "F. CIERRE"
    chWorkSheet:Columns("N"):NumberFormat = "dd/mm/yyyy".

ASSIGN
    t-Row = 2.
GET FIRST {&BROWSE-NAME}.
REPEAT WHILE AVAILABLE Ccbdmvto:
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Ccbdmvto.coddiv.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Ccbdmvto.coddoc.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Ccbdmvto.nrodoc.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Ccbdmvto.tporef.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Ccbdmvto.flgest.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Tarjcre.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Nrotarj.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Ccbdmvto.codbco.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Ccbdmvto.codcta.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Ccbdmvto.nrodep.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Ccbdmvto.fchemi.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Moneda.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Importe.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Ccbccaja.FchCie.
    GET NEXT {&BROWSE-NAME}.
END.
chExcelApplication:VISIBLE = TRUE.
/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

 RUN dispatch IN THIS-PROCEDURE ('open-query':U).

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
  FOR EACH gn-divi NO-LOCK WHERE codcia = s-codcia WITH FRAME {&FRAME-NAME}:
       COMBO-BOX-Division:ADD-LAST(gn-divi.coddiv + ' - ' + GN-DIVI.DesDiv).
  END.
  FOR EACH FacTabla WHERE FacTabla.CodCia = s-CodCia
      AND FacTabla.Tabla = "TC"
      AND LENGTH(FacTabla.Codigo) <= 2 NO-LOCK:
      COMBO-BOX-NroRef:ADD-LAST(TRIM(FacTabla.Codigo) + ' ' + TRIM(FacTabla.Nombre)).
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  APPLY 'LEAVE':U TO F-Banco.
  APPLY 'LEAVE':U TO F-Cta.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_AnulaDeposito B-table-Win 
PROCEDURE proc_AnulaDeposito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE i AS INTEGER NO-UNDO.

    IF {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 OR
        {&BROWSE-NAME}:NUM-SELECTED-ROWS = ? THEN RETURN.

    rpta = FALSE.
    MESSAGE
        '¿Esta seguro de extornar depósito(s) seleccionado(s)?'
        VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta.
    IF rpta <> TRUE THEN RETURN.

    DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN DO:
            FIND b_DMvtO WHERE ROWID(b_DMvtO) = ROWID(CcbDMvto)
                EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE b_DMvto THEN DO:
                IF b_DMvto.FlgEst = "C" THEN DO:
                    MESSAGE
                        "Banco:" b_DMvto.codbco SKIP
                        "Cuenta:" b_DMvto.codcta SKIP
                        "Operación:" b_DMvto.nrodep SKIP
                        "Fecha:" b_DMvto.fchemi SKIP
                        "Monto:" IF b_DMvto.depnac[1] > 0 THEN b_DMvtO.depnac[1]
                            ELSE b_DMvto.depusa[1] SKIP
                        '¿Desea extornar este depósito confirmado?'
                        VIEW-AS ALERT-BOX QUESTION
                        BUTTONS YES-NO UPDATE rpta.
                    IF rpta <> TRUE THEN NEXT.
                END.
                /* Busca Pendientes por Depositar */
                FIND CcbPenDep WHERE
                    CcbPenDep.CodCia = CcbDMvto.CodCia AND
                    CcbPenDep.CodDoc = CcbDMvto.TpoRef AND
                    CcbPenDep.CodDiv = CcbDMvto.CodDiv AND
                    CcbPenDep.CodRef = CcbDMvto.CodDoc AND
                    CcbPenDep.NroRef = CcbDMvto.NroDoc AND
                    CcbPenDep.FchCie = CcbDMvto.FchCie
                    EXCLUSIVE-LOCK NO-ERROR.
                IF AVAILABLE CcbPenDep THEN DO:
                    ASSIGN
                        CcbPenDep.SdoNac = CcbPenDep.SdoNac + CcbDMvto.DepNac[1]
                        CcbPenDep.SdoUSA = CcbPenDep.SdoUSA + CcbDMvto.DepUsa[1]
                        CcbPenDep.FlgEst = "P".
                    DELETE b_DMvto.
                    RELEASE CcbPenDep.
                END.
            END.
        END.
    END.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_ConfirmaDeposito B-table-Win 
PROCEDURE proc_ConfirmaDeposito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF COMBO-SITUACION <> "Pendientes" THEN RETURN.
    IF {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 OR
        {&BROWSE-NAME}:NUM-SELECTED-ROWS = ? THEN RETURN.

    DEFINE VARIABLE i AS INTEGER NO-UNDO.

    rpta = FALSE.
    MESSAGE
        '¿Confirmar depósito(s) seleccionado(s)?'
        VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta.
    IF rpta <> TRUE THEN RETURN.

    ASSIGN
        F-Banco F-Cta F-Fecha FILL-IN-NroOpe.
/*     IF COMBO-Tipo = "Bóveda" AND F-FECHA = ?  THEN DO:                   */
/*         MESSAGE                                                          */
/*             "Ingrese la Fecha de Depósito"                               */
/*             VIEW-AS ALERT-BOX ERROR.                                     */
/*         APPLY "ENTRY" TO F-CTA.                                          */
/*         RETURN.                                                          */
/*     END.                                                                 */
/*     IF COMBO-Tipo = "Bóveda" AND TRUE <> (FILL-IN-NroOpe > "")  THEN DO: */
/*         MESSAGE                                                          */
/*             "Ingrese el N° de Operación"                                 */
/*             VIEW-AS ALERT-BOX ERROR.                                     */
/*         APPLY "ENTRY" TO FILL-IN-NroOpe.                                 */
/*         RETURN.                                                          */
/*     END.                                                                 */

    DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN DO:
            IF CcbDMvto.FlgEst = "C" THEN NEXT.
            FIND b_DMvtO WHERE ROWID(b_DMvtO) = ROWID(CcbDMvto) EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE b_DMvto THEN DO:
                ASSIGN 
                    b_DMvto.FlgEst = "C".
                IF TRUE <> (b_DMvtO.CodBco > "") THEN b_DMvtO.CodBco =  F-Banco.
                IF TRUE <> (b_DMvtO.CodCta > "") THEN b_DMvtO.CodCta =  F-Cta.
                IF TRUE <> (b_DMvtO.NroDep > "") THEN b_DMvtO.NroDep = FILL-IN-NroOpe.
                IF b_DMvtO.FchEmi = ? THEN b_DMvtO.FchEmi = F-Fecha.
                IF b_DMvtO.FchEmi = ? THEN b_DMvtO.FchEmi = b_DMvtO.FchCie.
            END.
        END.
    END.
    ASSIGN
        f-Fecha = ?
        FILL-IN-NroOpe = ''
        f-Banco = 'CO'
        f-Cta = '10413100'.
    DISPLAY
        F-BANCO
        F-CTA
        F-FECHA
        FILL-IN-NroOpe
        "" @ FILL-IN-16
        "" @ FILL-IN-17
        WITH FRAME {&FRAME-NAME}.
    APPLY 'LEAVE':U TO FILL-IN-16.
    APPLY 'LEAVE':U TO FILL-IN-17.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
        WHEN "F-Cta" THEN DO:
            ASSIGN
                input-var-1 = "104"
                input-var-2 = F-Banco:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                input-var-3 = ''.
        END.
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
  {src/adm/template/snd-list.i "CcbDMvto"}
  {src/adm/template/snd-list.i "CcbCCaja"}

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

