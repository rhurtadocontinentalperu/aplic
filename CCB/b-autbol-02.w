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

DEFINE SHARED VARIABLE s-codcia     AS INTEGER.
DEFINE SHARED VARIABLE s-user-id    AS CHARACTER.
DEFINE SHARED VARIABLE s-coddoc     AS CHARACTER.
DEFINE SHARED VARIABLE s-coddiv     AS CHARACTER.
DEFINE SHARED VARIABLE f-coddoc     AS CHARACTER.

/* Definición de variables locales */
DEFINE VARIABLE whpadre AS WIDGET-HANDLE.
DEFINE VARIABLE wh      AS WIDGET-HANDLE.
DEFINE VARIABLE curr-record AS RECID.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEF BUFFER buf-Ccbcdocu FOR Ccbcdocu.
DEF VAR x-CndPgo AS CHAR NO-UNDO.
DEF VAR x-moneda AS CHAR NO-UNDO.

/* Preprocesadores para condiciones */
&SCOPED-DEFINE CONDICION ( Ccbcdocu.CodCia = S-CODCIA ~
AND Ccbcdocu.CodDoc = S-CODDOC ~
AND (Ccbcdocu.FlgEst = "P" OR Ccbcdocu.FlgEst = "E" OR Ccbcdocu.FlgEst = "C") ~
AND Ccbcdocu.FlgSit BEGINS COMBO-Situacion ~
AND Ccbcdocu.nroref BEGINS FILL-IN-nroref ~
AND Ccbcdocu.fchate >= x-fchate-1 AND Ccbcdocu.fchate <= x-fchate-2)

&SCOPED-DEFINE CODIGO Ccbcdocu.NroDoc

/* Preprocesadores para cada campo filtro */
&SCOPED-DEFINE FILTRO1 ( Ccbcdocu.NomCli BEGINS FILL-IN-filtro )
&SCOPED-DEFINE FILTRO2 ( INDEX ( Ccbcdocu.NomCli, FILL-IN-filtro ) <> 0 )
&SCOPED-DEFINE FILTRO3 ( Ccbcdocu.ImpTot = FILL-IN-Importe )
&SCOPED-DEFINE FILTRO4 ( Ccbcdocu.ImpTot > FILL-IN-Importe )
&SCOPED-DEFINE FILTRO5 ( Ccbcdocu.ImpTot < FILL-IN-Importe )

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
&Scoped-define INTERNAL-TABLES CcbCDocu

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CcbCDocu.NroDoc CcbCDocu.NomCli ~
CcbCDocu.CodCli ~
IF CcbCDocu.TpoFac = 'EFE' THEN 'Efectivo' ELSE 'Cheque' @ x-CndPgo ~
CcbCDocu.NroRef CcbCDocu.FchAte ~
IF CcbCDocu.CodMon = 1 THEN 'S/.' ELSE 'US$' @ x-moneda CcbCDocu.ImpTot ~
CcbCDocu.CodCta CcbCDocu.Glosa CcbCDocu.FlgUbi CcbCDocu.FchUbi ~
CcbCDocu.usuario CcbCDocu.FchDoc CcbCDocu.HorCie 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH CcbCDocu WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH CcbCDocu WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CcbCDocu


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 FILL-IN-codigo FILL-IN-Importe ~
FILL-IN-NroRef x-FchAte-1 x-FchAte-2 COMBO-filtro FILL-IN-filtro ~
COMBO-Situacion br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-codigo FILL-IN-Importe ~
FILL-IN-NroRef x-FchAte-1 x-FchAte-2 COMBO-filtro FILL-IN-filtro ~
COMBO-Situacion 

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
Nombres que inicien con|y||INTEGRAL.CcbCDocu.NomCli
Nombres que contengan|y||INTEGRAL.CcbCDocu.NomCli
Importes iguales a|y||INTEGRAL.CcbBolDep.ImpTot
Importes mayores a|y||INTEGRAL.CcbCDocu.ImpTot
Importes menores a|y||INTEGRAL.CcbCDocu.ImpTot
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "Nombres que inicien con,Nombres que contengan,Importes iguales a,Importes mayores a,Importes menores a",
     Keys-Supplied = ':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
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
Codigo|y||INTEGRAL.CcbCDocu.CodCia|yes,INTEGRAL.CcbCDocu.CodDoc|yes,INTEGRAL.CcbCDocu.NroDoc|yes
Nombre de Cliente|||INTEGRAL.CcbCDocu.CodCia|yes,INTEGRAL.CcbCDocu.NomCli|yes
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "Codigo,Nombre de Cliente",
     SortBy-Case = Codigo':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).

/* This SmartObject is a valid SortBy-Target. */
&IF '{&user-supported-links}':U ne '':U &THEN
  &Scoped-define user-supported-links {&user-supported-links},SortBy-Target
&ELSE
  &Scoped-define user-supported-links SortBy-Target
&ENDIF

/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE COMBO-filtro AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 21 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE COMBO-Situacion AS CHARACTER FORMAT "X(256)":U INITIAL "Pendiente" 
     LABEL "Situación" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","Pendiente","Autorizada","Rechazada" 
     DROP-DOWN-LIST
     SIZE 14.57 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-codigo AS CHARACTER FORMAT "X(9)":U 
     LABEL "Número Documento" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-filtro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29.43 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Importe AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Importe" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-NroRef AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nº de Depósito" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchAte-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Depositados desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchAte-2 AS DATE FORMAT "99/99/99":U 
     LABEL "hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 171 BY 13.19.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      CcbCDocu.NroDoc FORMAT "XXX-XXXXXXXXX":U
      CcbCDocu.NomCli FORMAT "x(40)":U
      CcbCDocu.CodCli FORMAT "x(11)":U WIDTH 10.43
      IF CcbCDocu.TpoFac = 'EFE' THEN 'Efectivo' ELSE 'Cheque' @ x-CndPgo COLUMN-LABEL "Condición!Pago"
      CcbCDocu.NroRef COLUMN-LABEL "Número!Depósito" FORMAT "X(12)":U
      CcbCDocu.FchAte COLUMN-LABEL "Fecha de!Depósito" FORMAT "99/99/99":U
      IF CcbCDocu.CodMon = 1 THEN 'S/.' ELSE 'US$' @ x-moneda COLUMN-LABEL "Moneda"
      CcbCDocu.ImpTot FORMAT "->>,>>>,>>9.99":U
      CcbCDocu.CodCta FORMAT "X(10)":U
      CcbCDocu.Glosa COLUMN-LABEL "Descripción" FORMAT "x(40)":U
      CcbCDocu.FlgUbi COLUMN-LABEL "Autorizo" FORMAT "x(10)":U
      CcbCDocu.FchUbi COLUMN-LABEL "Fecha!Autorización" FORMAT "99/99/9999":U
      CcbCDocu.usuario COLUMN-LABEL "Usuario!Registro" FORMAT "x(10)":U
      CcbCDocu.FchDoc COLUMN-LABEL "Fecha!Registro" FORMAT "99/99/99":U
      CcbCDocu.HorCie COLUMN-LABEL "Hora!Registro" FORMAT "x(5)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 169 BY 9.96
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-codigo AT ROW 1.19 COL 21 COLON-ALIGNED
     FILL-IN-Importe AT ROW 1.19 COL 61 COLON-ALIGNED
     FILL-IN-NroRef AT ROW 2.08 COL 21 COLON-ALIGNED WIDGET-ID 2
     x-FchAte-1 AT ROW 2.08 COL 61 COLON-ALIGNED WIDGET-ID 4
     x-FchAte-2 AT ROW 2.08 COL 79 COLON-ALIGNED WIDGET-ID 6
     COMBO-filtro AT ROW 2.88 COL 2 NO-LABEL
     FILL-IN-filtro AT ROW 2.88 COL 23 NO-LABEL
     COMBO-Situacion AT ROW 2.88 COL 61 COLON-ALIGNED
     br_table AT ROW 3.96 COL 2
     RECT-1 AT ROW 1 COL 1
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
         HEIGHT             = 13.5
         WIDTH              = 173.86.
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
/* BROWSE-TAB br_table COMBO-Situacion F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 6.

/* SETTINGS FOR COMBO-BOX COMBO-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.CcbCDocu"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > INTEGRAL.CcbCDocu.NroDoc
"NroDoc" ? "XXX-XXXXXXXXX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.CcbCDocu.NomCli
"NomCli" ? "x(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.CcbCDocu.CodCli
"CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"IF CcbCDocu.TpoFac = 'EFE' THEN 'Efectivo' ELSE 'Cheque' @ x-CndPgo" "Condición!Pago" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.CcbCDocu.NroRef
"NroRef" "Número!Depósito" "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.CcbCDocu.FchAte
"FchAte" "Fecha de!Depósito" "99/99/99" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"IF CcbCDocu.CodMon = 1 THEN 'S/.' ELSE 'US$' @ x-moneda" "Moneda" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = INTEGRAL.CcbCDocu.ImpTot
     _FldNameList[9]   = INTEGRAL.CcbCDocu.CodCta
     _FldNameList[10]   > INTEGRAL.CcbCDocu.Glosa
"Glosa" "Descripción" "x(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.CcbCDocu.FlgUbi
"FlgUbi" "Autorizo" "x(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.CcbCDocu.FchUbi
"FchUbi" "Fecha!Autorización" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > INTEGRAL.CcbCDocu.usuario
"usuario" "Usuario!Registro" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > INTEGRAL.CcbCDocu.FchDoc
"FchDoc" "Fecha!Registro" "99/99/99" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > INTEGRAL.CcbCDocu.HorCie
"HorCie" "Hora!Registro" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME COMBO-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-filtro B-table-Win
ON VALUE-CHANGED OF COMBO-filtro IN FRAME F-Main
DO:
    IF COMBO-filtro = COMBO-filtro:SCREEN-VALUE AND
        FILL-IN-filtro = FILL-IN-filtro:SCREEN-VALUE AND
        FILL-IN-Importe = DECIMAL(FILL-IN-Importe:SCREEN-VALUE) AND 
        FILL-IN-Nroref = FILL-IN-Nroref:SCREEN-VALUE AND
        x-FchAte-1 = INPUT x-FchAte-1 AND
        x-FchAte-2 = INPUT x-FchAte-2
        THEN RETURN.
    ASSIGN
        FILL-IN-filtro
        COMBO-filtro
        FILL-IN-Importe
        FILL-IN-NroRef
        x-FchAte-1
        x-FchAte-2.
    IF COMBO-filtro = "Todos" THEN RUN set-attribute-list('Key-Name=?').
    ELSE RUN set-attribute-list('Key-Name=' + COMBO-filtro).
    RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-Situacion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-Situacion B-table-Win
ON VALUE-CHANGED OF COMBO-Situacion IN FRAME F-Main /* Situación */
DO:
  ASSIGN COMBO-Situacion.
  RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codigo B-table-Win
ON LEAVE OF FILL-IN-codigo IN FRAME F-Main /* Número Documento */
DO:
    IF INPUT FILL-IN-codigo = "" THEN RETURN.
    &IF "{&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}" &THEN
        FIND FIRST {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
            {&CONDICION} AND
            ( {&CODIGO} = INPUT FILL-IN-codigo )
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            BELL.
            MESSAGE "Registro no encontrado" VIEW-AS ALERT-BOX ERROR.
            SELF:SCREEN-VALUE = "".
            RETURN.
        END.
        REPOSITION {&BROWSE-NAME} TO ROWID ROWID( {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} ) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE
                "Registro no se encuentra en el filtro actual" SKIP
                "       Deshacer la actual selección ?       "
                VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO TITLE "Pregunta"
                UPDATE answ AS LOGICAL.
            IF answ THEN DO:
                ASSIGN
                    FILL-IN-filtro:SCREEN-VALUE = ""
                    COMBO-filtro:SCREEN-VALUE = COMBO-filtro:ENTRY(1).
                APPLY "VALUE-CHANGED" TO COMBO-filtro.
                RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
                REPOSITION {&BROWSE-NAME} TO ROWID ROWID( {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} ) NO-ERROR.
            END.
        END.
        ASSIGN SELF:SCREEN-VALUE = "".
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-filtro B-table-Win
ON LEAVE OF FILL-IN-filtro IN FRAME F-Main
DO:
    APPLY "VALUE-CHANGED" TO COMBO-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Importe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Importe B-table-Win
ON LEAVE OF FILL-IN-Importe IN FRAME F-Main /* Importe */
DO:
    APPLY "VALUE-CHANGED" TO COMBO-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroRef B-table-Win
ON LEAVE OF FILL-IN-NroRef IN FRAME F-Main /* Nº de Depósito */
DO:
    APPLY "VALUE-CHANGED" TO COMBO-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-FchAte-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-FchAte-1 B-table-Win
ON LEAVE OF x-FchAte-1 IN FRAME F-Main /* Depositados desde */
DO:
    APPLY "VALUE-CHANGED" TO COMBO-filtro.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-FchAte-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-FchAte-2 B-table-Win
ON LEAVE OF x-FchAte-2 IN FRAME F-Main /* hasta */
DO:
    APPLY "VALUE-CHANGED" TO COMBO-filtro.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEF VAR key-value AS CHAR NO-UNDO.

  /* Look up the current key-value. */
  RUN get-attribute ('Key-Value':U).
  key-value = RETURN-VALUE.

  /* Find the current record using the current Key-Name. */
  RUN get-attribute ('Key-Name':U).
  CASE RETURN-VALUE:
    WHEN 'Nombres que inicien con':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro1} )
       RUN get-attribute ('SortBy-Case':U).
       CASE RETURN-VALUE:
         WHEN 'Codigo':U THEN DO:
           &Scope SORTBY-PHRASE BY CcbCDocu.CodCia BY CcbCDocu.CodDoc BY CcbCDocu.NroDoc
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Nombre de Cliente':U THEN DO:
           &Scope SORTBY-PHRASE BY CcbCDocu.CodCia BY CcbCDocu.NomCli
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         OTHERWISE DO:
           &Undefine SORTBY-PHRASE
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END. /* OTHERWISE...*/
       END CASE.
    END. /* Nombres que inicien con */
    WHEN 'Nombres que contengan':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro2} )
       RUN get-attribute ('SortBy-Case':U).
       CASE RETURN-VALUE:
         WHEN 'Codigo':U THEN DO:
           &Scope SORTBY-PHRASE BY CcbCDocu.CodCia BY CcbCDocu.CodDoc BY CcbCDocu.NroDoc
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Nombre de Cliente':U THEN DO:
           &Scope SORTBY-PHRASE BY CcbCDocu.CodCia BY CcbCDocu.NomCli
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         OTHERWISE DO:
           &Undefine SORTBY-PHRASE
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END. /* OTHERWISE...*/
       END CASE.
    END. /* Nombres que contengan */
    WHEN 'Importes iguales a':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro3} )
       RUN get-attribute ('SortBy-Case':U).
       CASE RETURN-VALUE:
         WHEN 'Codigo':U THEN DO:
           &Scope SORTBY-PHRASE BY CcbCDocu.CodCia BY CcbCDocu.CodDoc BY CcbCDocu.NroDoc
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Nombre de Cliente':U THEN DO:
           &Scope SORTBY-PHRASE BY CcbCDocu.CodCia BY CcbCDocu.NomCli
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         OTHERWISE DO:
           &Undefine SORTBY-PHRASE
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END. /* OTHERWISE...*/
       END CASE.
    END. /* Importes iguales a */
    WHEN 'Importes mayores a':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro4} )
       RUN get-attribute ('SortBy-Case':U).
       CASE RETURN-VALUE:
         WHEN 'Codigo':U THEN DO:
           &Scope SORTBY-PHRASE BY CcbCDocu.CodCia BY CcbCDocu.CodDoc BY CcbCDocu.NroDoc
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Nombre de Cliente':U THEN DO:
           &Scope SORTBY-PHRASE BY CcbCDocu.CodCia BY CcbCDocu.NomCli
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         OTHERWISE DO:
           &Undefine SORTBY-PHRASE
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END. /* OTHERWISE...*/
       END CASE.
    END. /* Importes mayores a */
    WHEN 'Importes menores a':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro5} )
       RUN get-attribute ('SortBy-Case':U).
       CASE RETURN-VALUE:
         WHEN 'Codigo':U THEN DO:
           &Scope SORTBY-PHRASE BY CcbCDocu.CodCia BY CcbCDocu.CodDoc BY CcbCDocu.NroDoc
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Nombre de Cliente':U THEN DO:
           &Scope SORTBY-PHRASE BY CcbCDocu.CodCia BY CcbCDocu.NomCli
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         OTHERWISE DO:
           &Undefine SORTBY-PHRASE
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END. /* OTHERWISE...*/
       END CASE.
    END. /* Importes menores a */
    OTHERWISE DO:
       &Scope KEY-PHRASE TRUE
       RUN get-attribute ('SortBy-Case':U).
       CASE RETURN-VALUE:
         WHEN 'Codigo':U THEN DO:
           &Scope SORTBY-PHRASE BY CcbCDocu.CodCia BY CcbCDocu.CodDoc BY CcbCDocu.NroDoc
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Nombre de Cliente':U THEN DO:
           &Scope SORTBY-PHRASE BY CcbCDocu.CodCia BY CcbCDocu.NomCli
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         OTHERWISE DO:
           &Undefine SORTBY-PHRASE
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END. /* OTHERWISE...*/
       END CASE.
    END. /* OTHERWISE...*/
  END CASE.

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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anula B-table-Win 
PROCEDURE Anula :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i AS INTEGER NO-UNDO.
  
    MESSAGE '¿Continua con la ANULACION de los depósitos?'
        VIEW-AS ALERT-BOX QUESTION BUTTONS
        YES-NO UPDATE rpta AS LOGICAL.
    IF rpta = NO THEN RETURN.
    DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN DO:
            FIND buf-Ccbcdocu WHERE
                ROWID(buf-Ccbcdocu) = ROWID(Ccbcdocu)
                EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE buf-Ccbcdocu AND
                (buf-Ccbcdocu.FlgEst = "E" OR buf-Ccbcdocu.FlgEst = "P") AND
                buf-Ccbcdocu.imptot = buf-Ccbcdocu.sdoact THEN DO:
                ASSIGN 
                    buf-Ccbcdocu.UsuAnu = s-user-id
                    buf-Ccbcdocu.FchAnu = TODAY
                    buf-Ccbcdocu.FlgEst = "A"
                    buf-Ccbcdocu.SdoAct = 0.
            END.
            RELEASE buf-Ccbcdocu.
        END.
    END.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna B-table-Win 
PROCEDURE Asigna :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i AS INTEGER NO-UNDO.

    MESSAGE
        '¿Continua con la AUTORIZACION de los depósitos?'
        VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOGICAL.
    IF rpta = NO THEN RETURN.
    DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN DO:
            FIND buf-ccbcdocu WHERE
                ROWID(buf-Ccbcdocu) = ROWID(Ccbcdocu)
                EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE buf-Ccbcdocu AND
                buf-Ccbcdocu.FlgSit = "Pendiente" AND
                buf-Ccbcdocu.FlgEst = "E" THEN DO:
                ASSIGN 
                    buf-Ccbcdocu.FlgSit = "Autorizada"
                    buf-Ccbcdocu.FlgUbi = s-user-id
                    buf-Ccbcdocu.FchUbi = TODAY
                    buf-Ccbcdocu.FlgEst = "P".
                RELEASE buf-Ccbcdocu.
            END.
        END.
    END.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
DEFINE VARIABLE t-Column                AS INTEGER.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A2"):Value = "Numero".
chWorkSheet:Range("B2"):Value = "Nombre".
chWorkSheet:Range("C2"):Value = "Condicion Pago".
chWorkSheet:Range("D2"):Value = "Nro. Deposito".
chWorkSheet:Range("E2"):Value = "Fecha Deposito".
chWorkSheet:Range("F2"):Value = "Importe Total".
chWorkSheet:Range("G2"):Value = "Cuenta".
chWorkSheet:Range("H2"):Value = "Descripcion".
chWorkSheet:Range("I2"):Value = "Moneda".
chWorkSheet:Range("J2"):Value = "Autorizo".
chWorkSheet:Range("K2"):Value = "Fecha Autorizacion".
chWorkSheet:Range("L2"):Value = "Usuario Registro".
chWorkSheet:Range("M2"):Value = "Fecha Registro".
chWorkSheet:Range("N2"):Value = "Hora Registro".

t-column = 2.

loopREP:
FOR EACH Ccbcdocu NO-LOCK WHERE {&CONDICION}:
    CASE COMBO-filtro:
        WHEN "Nombres que inicien con" THEN DO:
            IF NOT {&Filtro1} THEN NEXT.
        END.
        WHEN "Nombres que contengan" THEN DO:
            IF NOT {&Filtro2} THEN NEXT.
        END.
        WHEN "Importes iguales a" THEN DO:
            IF NOT {&Filtro3} THEN NEXT.
        END.
        WHEN "Importes mayores a" THEN DO:
            IF NOT {&Filtro4} THEN NEXT.
        END.
        WHEN "Importes menores a" THEN DO:
            IF NOT {&Filtro5} THEN NEXT.
        END.
    END CASE.
    t-column = t-column + 1.
    /* DATOS DEL PRODUCTO */    
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Ccbcdocu.nrodoc.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = Ccbcdocu.nomcli.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = (IF Ccbcdocu.tpofac = 'EFE' THEN 'Efectivo' ELSE 'Cheque').
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Ccbcdocu.nroref.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = Ccbcdocu.fchate.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = Ccbcdocu.imptot.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Ccbcdocu.codcta.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = Ccbcdocu.glosa.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = (IF Ccbcdocu.codmon = 1 THEN 'S/.' ELSE 'US$').
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING (Ccbcdocu.flgubi, 'x(9)').
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = Ccbcdocu.fchubi.
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = Ccbcdocu.usuario.
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = Ccbcdocu.fchdoc.
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = Ccbcdocu.horcie.
    
END.    
iCount = iCount + 2.

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
    RUN get-attribute ('Keys-Accepted').

    IF RETURN-VALUE <> "" AND RETURN-VALUE <> ? THEN
        ASSIGN
            COMBO-filtro:LIST-ITEMS IN FRAME {&FRAME-NAME} =
            COMBO-filtro:LIST-ITEMS + "," + RETURN-VALUE.

  ASSIGN
      x-FchAte-1 = DATE(01,01,YEAR(TODAY))
      x-FchAte-2 = TODAY.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rechazar B-table-Win 
PROCEDURE Rechazar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE i AS INTEGER NO-UNDO.

    MESSAGE
        '¿Continua con el RECHAZO de los depósitos?'
        VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOGICAL.
    IF rpta = NO THEN RETURN.
    DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN DO:
            FIND buf-ccbcdocu WHERE
                ROWID(buf-Ccbcdocu) = ROWID(Ccbcdocu)
                EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE buf-Ccbcdocu AND
                buf-Ccbcdocu.FlgSit = "Pendiente" AND
                buf-Ccbcdocu.FlgEst = "E" THEN DO:
                ASSIGN 
                    buf-Ccbcdocu.FlgSit = "Rechazada"
                    buf-Ccbcdocu.FlgUbi = s-user-id
                    buf-Ccbcdocu.FchUbi = TODAY.
                    /*buf-Ccbcdocu.FlgEst = "R".*/
                RELEASE buf-Ccbcdocu.
            END.
        END.
    END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key B-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

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

