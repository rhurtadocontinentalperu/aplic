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
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR cb-codcia AS INT.

DEF VAR TarjCre AS CHARACTER NO-UNDO.
DEF VAR NroTarj AS CHARACTER NO-UNDO.
DEF VAR Moneda AS CHARACTER NO-UNDO.
DEF VAR Importe AS DECIMAL NO-UNDO.
DEF VAR Saldo AS DECIMAL NO-UNDO.
DEF VAR s-codpro AS CHAR NO-UNDO.

&Scoped-define Condicion ( ~
    CcbPenDep.codcia = s-codcia AND ~
    CcbPenDep.coddoc = s-coddoc AND ~
    CcbPenDep.coddiv = COMBO-BOX-CodDiv AND ~
    CcbPenDep.FlgEst = 'P' AND  ~
    CcbPenDep.fchcie >= 01/01/2016)

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
&Scoped-define INTERNAL-TABLES CcbPenDep VtaDTickets

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CcbPenDep.CodRef CcbPenDep.NroRef ~
CcbPenDep.CodDiv CcbPenDep.usuario CcbPenDep.FchCie CcbPenDep.HorCie ~
Moneda @ Moneda Importe @ Importe Saldo @ Saldo VtaDTickets.Producto 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH CcbPenDep WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST VtaDTickets WHERE VtaDTickets.CodCia = CcbPenDep.CodCia ~
  AND VtaDTickets.CodRef = CcbPenDep.CodRef ~
  AND VtaDTickets.NroRef = CcbPenDep.NroRef ~
  AND VtaDTickets.CodDiv = CcbPenDep.CodDiv ~
      AND VtaDTickets.CodPro = s-codpro NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH CcbPenDep WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST VtaDTickets WHERE VtaDTickets.CodCia = CcbPenDep.CodCia ~
  AND VtaDTickets.CodRef = CcbPenDep.CodRef ~
  AND VtaDTickets.NroRef = CcbPenDep.NroRef ~
  AND VtaDTickets.CodDiv = CcbPenDep.CodDiv ~
      AND VtaDTickets.CodPro = s-codpro NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table CcbPenDep VtaDTickets
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CcbPenDep
&Scoped-define SECOND-TABLE-IN-QUERY-br_table VtaDTickets


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table COMBO-BOX-CodDiv FILL-IN-NroOpe ~
F-Fecha BUTTON-5 COMBO-BOX-Proveedor 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodDiv F-Banco F-Cta ~
FILL-IN-NroOpe F-Fecha FILL-IN-16 FILL-IN-17 COMBO-BOX-Proveedor 

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
DEFINE BUTTON BUTTON-5 
     LABEL "Aceptar Depósito" 
     SIZE 19.86 BY .85
     FONT 6.

DEFINE VARIABLE COMBO-BOX-CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "División" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 57 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Proveedor AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor Vales" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 57 BY 1 NO-UNDO.

DEFINE VARIABLE F-Banco AS CHARACTER FORMAT "X(3)":U INITIAL "CO" 
     LABEL "Banco" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-Cta AS CHARACTER FORMAT "X(256)":U INITIAL "10413100" 
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
     SIZE 35 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-17 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-NroOpe AS CHARACTER FORMAT "X(10)":U 
     LABEL "Nº Solapa" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      CcbPenDep, 
      VtaDTickets SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      CcbPenDep.CodRef COLUMN-LABEL "Doc" FORMAT "x(3)":U
      CcbPenDep.NroRef FORMAT "XXX-XXXXXXXX":U
      CcbPenDep.CodDiv COLUMN-LABEL "División" FORMAT "x(5)":U
            WIDTH 7.86
      CcbPenDep.usuario COLUMN-LABEL "Usuario" FORMAT "x(10)":U
      CcbPenDep.FchCie COLUMN-LABEL "Fecha Cierre" FORMAT "99/99/9999":U
            WIDTH 10.72
      CcbPenDep.HorCie COLUMN-LABEL "Hora!Cierre" FORMAT "x(5)":U
            WIDTH 4.57
      Moneda @ Moneda COLUMN-LABEL "Mon" FORMAT "XXX":U WIDTH 3.43
      Importe @ Importe COLUMN-LABEL "Importe" FORMAT "->,>>>,>>9.99":U
      Saldo @ Saldo COLUMN-LABEL "Saldo" FORMAT "->,>>>,>>9.99":U
            WIDTH 9.72
      VtaDTickets.Producto FORMAT "x(8)":U WIDTH 10.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 83 BY 9.12
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 3.12 COL 2
     COMBO-BOX-CodDiv AT ROW 1.19 COL 15 COLON-ALIGNED WIDGET-ID 50
     F-Banco AT ROW 12.54 COL 29 COLON-ALIGNED
     F-Cta AT ROW 13.5 COL 29 COLON-ALIGNED
     FILL-IN-NroOpe AT ROW 14.46 COL 29 COLON-ALIGNED
     F-Fecha AT ROW 15.42 COL 29 COLON-ALIGNED
     FILL-IN-16 AT ROW 12.54 COL 35 COLON-ALIGNED NO-LABEL
     FILL-IN-17 AT ROW 13.5 COL 40 COLON-ALIGNED NO-LABEL
     BUTTON-5 AT ROW 15.23 COL 52
     COMBO-BOX-Proveedor AT ROW 2.15 COL 15 COLON-ALIGNED WIDGET-ID 48
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
         HEIGHT             = 15.73
         WIDTH              = 86.72.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 2.

/* SETTINGS FOR FILL-IN F-Banco IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Cta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-16 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-17 IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.CcbPenDep,INTEGRAL.VtaDTickets WHERE INTEGRAL.CcbPenDep ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _Where[1]         = "{&Condicion}"
     _JoinCode[2]      = "VtaDTickets.CodCia = CcbPenDep.CodCia
  AND VtaDTickets.CodRef = CcbPenDep.CodRef
  AND VtaDTickets.NroRef = CcbPenDep.NroRef
  AND VtaDTickets.CodDiv = CcbPenDep.CodDiv"
     _Where[2]         = "VtaDTickets.CodPro = s-codpro"
     _FldNameList[1]   > INTEGRAL.CcbPenDep.CodRef
"CcbPenDep.CodRef" "Doc" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.CcbPenDep.NroRef
"CcbPenDep.NroRef" ? "XXX-XXXXXXXX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.CcbPenDep.CodDiv
"CcbPenDep.CodDiv" "División" ? "character" ? ? ? ? ? ? no ? no no "7.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.CcbPenDep.usuario
"CcbPenDep.usuario" "Usuario" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.CcbPenDep.FchCie
"CcbPenDep.FchCie" "Fecha Cierre" ? "date" ? ? ? ? ? ? no ? no no "10.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.CcbPenDep.HorCie
"CcbPenDep.HorCie" "Hora!Cierre" ? "character" ? ? ? ? ? ? no ? no no "4.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"Moneda @ Moneda" "Mon" "XXX" ? ? ? ? ? ? ? no ? no no "3.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"Importe @ Importe" "Importe" "->,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"Saldo @ Saldo" "Saldo" "->,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.VtaDTickets.Producto
"VtaDTickets.Producto" ? ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 B-table-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Aceptar Depósito */
DO:

    IF {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0 THEN DO:
        MESSAGE
            "Debe seleccionar al menos un registro"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO br_table.
        RETURN NO-APPLY.
    END.

    MESSAGE
        '¿Está seguro de realizar Operación?' SKIP
        VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO
        UPDATE X-OK AS LOGICAL.

    CASE X-OK:
        WHEN FALSE THEN DO:
            MESSAGE
                "Operacion Cancelada "
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
            RETURN NO-APPLY.
        END.
    END CASE.

    IF F-BANCO:SCREEN-VALUE = "" THEN DO:
        MESSAGE
            "Ingrese el Código de Banco"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO F-BANCO.
        RETURN NO-APPLY.
    END.
    IF F-CTA:SCREEN-VALUE = "" THEN DO:
        MESSAGE
            "Ingrese el Número de Cuenta Bancaria"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO F-CTA.
        RETURN NO-APPLY.     
    END.
    FIND cb-ctas WHERE
        cb-ctas.CodCia = cb-codcia AND
        LENGTH(cb-ctas.Codcta) >= 6 AND
        cb-ctas.codcta BEGINS F-Cta:SCREEN-VALUE AND
        cb-ctas.codbco BEGINS F-Banco:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE
            "Cuenta de Banco no Registrado"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY. 
    END.
    IF F-FECHA = ?  THEN DO:
        MESSAGE
            "Ingrese la Fecha de Depósito"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO F-CTA.
        RETURN NO-APPLY.
    END.
    RUN proc_Genera-Deposito.
    RUN dispatch IN THIS-PROCEDURE('open-query':U).
    DO WITH FRAME {&FRAME-NAME}:
        F-FECHA = ?.
        DISPLAY
/*             "" @ F-BANCO */
/*             "" @ F-CTA   */
            F-FECHA
            "" @ FILL-IN-NroOpe
            "" @ FILL-IN-16
            "" @ FILL-IN-17.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodDiv B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-CodDiv IN FRAME F-Main /* División */
DO:
    ASSIGN {&SELF-NAME}.

    s-codpro = ENTRY(1, COMBO-BOX-proveedor:SCREEN-VALUE, ' - ').

    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Proveedor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Proveedor B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Proveedor IN FRAME F-Main /* Proveedor Vales */
DO:
    s-codpro = ENTRY(1, SELF:SCREEN-VALUE, ' - ').
    ASSIGN COMBO-BOX-coddiv.

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
        F-Fecha.

 END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Banco B-table-Win
ON LEAVE OF F-Banco IN FRAME F-Main /* Banco */
DO:

    ASSIGN
        F-Banco 
        F-Cta
        F-Fecha.

    IF SELF:SCREEN-VALUE = "" THEN DO:
        DISPLAY 
            "" @ F-Banco 
            "" @ FILL-IN-16 
            WITH FRAME {&FRAME-NAME}.
        RETURN.
    END.
    FIND cb-tabl WHERE
        cb-tabl.Tabla  = "04" AND
        cb-tabl.Codigo = SELF:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-tabl THEN DO:
        MESSAGE
            "Banco no registrado"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    DISPLAY 
        cb-tabl.Codigo @ F-Banco 
        cb-tabl.Nombre @ FILL-IN-16 
        WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Banco B-table-Win
ON MOUSE-SELECT-DBLCLICK OF F-Banco IN FRAME F-Main /* Banco */
DO:

    DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
    ASSIGN
        input-var-1 = "04"
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
        F-Banco 
        F-Cta
        F-Fecha.
 
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
        cb-ctas.codcta BEGINS SELF:SCREEN-VALUE AND
        cb-ctas.codbco BEGINS F-Banco:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE
            "Cuenta de Banco no Registrado"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY. 
    END.
    DISPLAY 
        cb-ctas.Codcta @ F-Cta 
        cb-ctas.Nomcta @ FILL-IN-17  
        WITH FRAME {&FRAME-NAME}.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Cta B-table-Win
ON MOUSE-SELECT-DBLCLICK OF F-Cta IN FRAME F-Main /* Cuenta */
DO:

    DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.

    ASSIGN
        input-var-1 = "10"
        input-var-2 = F-Banco:SCREEN-VALUE
        input-var-3 = ""
        output-var-1 = ?
        OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

    DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
        RUN LKUP/C-Cuenta.r("Cuentas").
        IF OUTPUT-VAR-1 <> ? THEN DO:
            FIND cb-ctas WHERE ROWID(cb-ctas) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
            DISPLAY
                cb-ctas.Codcta @ F-Cta
                cb-ctas.Nomcta @ FILL-IN-17
                WITH FRAME {&FRAME-NAME}.
        END.
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

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


&Scoped-define SELF-NAME FILL-IN-NroOpe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroOpe B-table-Win
ON LEAVE OF FILL-IN-NroOpe IN FRAME F-Main /* Nº Solapa */
DO:
    ASSIGN {&SELF-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

ON FIND OF CcbPenDep DO:
    IF NUM-ENTRIES(CcbPenDep.NroDoc,"|") > 1 THEN DO:
        TarjCre = ENTRY(1,CcbPenDep.NroDoc,"|").
        NroTarj = ENTRY(2,CcbPenDep.NroDoc,"|").
    END.
    ELSE DO:
        TarjCre = CcbPenDep.NroDoc.
        NroTarj = "".
    END.
    IF CcbPenDep.ImpNac = 0 THEN DO:
        Moneda = "US$".
        Importe = CcbPenDep.ImpUSA.
        Saldo = CcbPenDep.SdoUSA.
    END.
    ELSE DO:
        Moneda = "S/.".
        Importe = CcbPenDep.ImpNac.
        Saldo = CcbPenDep.SdoNac.
    END.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH Vtactickets NO-LOCK WHERE Vtactickets.codcia = s-codcia,
          FIRST gn-prov NO-LOCK WHERE gn-prov.codcia = pv-codcia
          AND gn-prov.codpro = Vtactickets.codpro
          BREAK BY Vtactickets.codpro:
          IF FIRST-OF(Vtactickets.codpro) THEN DO:
              COMBO-BOX-Proveedor:ADD-LAST(gn-prov.codpro + ' - ' + gn-prov.nompro).
              s-codpro = gn-prov.codpro.
              COMBO-BOX-Proveedor:SCREEN-VALUE = (gn-prov.codpro + ' - ' + gn-prov.nompro).
          END.
      END.
      COMBO-BOX-CodDiv:DELIMITER = '|'.
      COMBO-BOX-CodDiv:DELETE(1).
      FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia
          AND gn-divi.campo-log[1] = NO:
          COMBO-BOX-CodDiv:ADD-LAST(GN-DIVI.CodDiv + ' ' + GN-DIVI.DesDiv,GN-DIVI.CodDiv).
      END.
  END.
  APPLY 'LEAVE':U TO  COMBO-BOX-CodDiv IN FRAME {&FRAME-NAME}.
  APPLY 'LEAVE':U TO  F-Banco IN FRAME {&FRAME-NAME}.
  APPLY 'LEAVE':U TO  F-Cta IN FRAME {&FRAME-NAME}.
   RUN dispatch IN THIS-PROCEDURE ('open-query':U).


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Genera-Deposito B-table-Win 
PROCEDURE proc_Genera-Deposito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUFFER b_pen FOR CcbPenDep.

    DEF VAR n AS INTEGER NO-UNDO.

    DO n = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(n) THEN DO:
            CREATE CcbDMvto.
            ASSIGN
                CcbDMvto.CodCia = CcbPenDep.CodCia
                CcbDMvto.CodDoc = CcbPenDep.CodRef
                CcbDMvto.NroDoc = CcbPenDep.NroRef
                CcbDMvto.TpoRef = CcbPenDep.CodDoc
                CcbDMvto.CodRef = CcbPenDep.CodDoc
                CcbDMvto.NroRef = CcbPenDep.NroDoc
                CcbDMvto.CodDiv = CcbPenDep.CodDiv
                CcbDMvto.codbco = F-Banco
                CcbDMvto.CodCta = F-Cta
                CcbDMvto.NroDep = FILL-IN-NroOpe
                CcbDMvto.FchEmi = F-Fecha
                CcbDMvto.DepNac[1] = CcbPenDep.SdoNac
                CcbDMvto.DepUsa[1] = CcbPenDep.SdoUSA
                CcbDMvto.FchCie = CcbPenDep.FchCie
                CcbDMvto.HorCie = CcbPenDep.HorCie
                CcbDMvto.FlgEst = "P"
                CcbDMvto.usuario = s-user-id.
            /* Busca I/C o E/C */
            FIND CcbCCaja WHERE
                CcbCCaja.CodCia = CcbDMvto.CodCia AND
                CcbCCaja.CodDoc = CcbDMvto.CodDoc AND
                CcbCCaja.NroDoc = CcbDMvto.NroDoc
                NO-LOCK NO-ERROR.
            IF AVAILABLE CcbCCaja THEN
                CcbDMvto.CodCli = CcbCCaja.CodCli.
            /* Actualiza Flag CcbPenDep */
            FIND b_pen OF CcbPenDep EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE b_pen THEN DO:
                ASSIGN
                    b_pen.FlgEst = "C"
                    b_pen.SdoNac = 0
                    b_pen.SdoUSA = 0.
                RELEASE b_pen.
            END.
        END.
    END.

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
  {src/adm/template/snd-list.i "CcbPenDep"}
  {src/adm/template/snd-list.i "VtaDTickets"}

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

