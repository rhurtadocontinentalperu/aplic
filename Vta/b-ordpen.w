&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.



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
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR CL-CODCIA AS INTEGER.
DEFINE VAR S-CODDOC AS CHAR INIT "O/D".
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE VAR R-COTI AS RECID.
DEFINE VAR F-ESTADO AS CHAR.
DEFINE VAR xFchDesde AS DATE.
DEFINE VAR xFchHasta AS DATE.
DEFINE VAR xAlmSal AS CHAR.
DEFINE VAR x-Items AS INT NO-UNDO.
DEFINE VAR x-Peso  AS DEC NO-UNDO.
DEFINE VAR x-Linea10 AS DEC NO-UNDO.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

xFchDesde = 01/01/2000.
xFchHasta = TODAY.

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
&Scoped-define INTERNAL-TABLES FacCPedi gn-clie gn-ConVt

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacCPedi.NroPed FacCPedi.NroRef ~
FacCPedi.NomCli FacCPedi.ordcmp FacCPedi.CodVen FacCPedi.FchPed ~
FacCPedi.CodAlm FacCPedi.FchEnt X-VTA @ X-VTA FacCPedi.ImpTot X-MON @ X-MON ~
X-STA @ X-STA fItems() @ x-Items 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND FacCPedi.CodCia = S-CODCIA ~
 AND FacCPedi.CodDiv = S-CODDIV ~
 AND FacCPedi.CodDoc = S-CODDOC ~
 AND (TRUE <> (wclient > '') OR FacCpedi.Nomcli BEGINS wclient) ~
 AND (TRUE <> (f-Estado > '') OR FacCPedi.FlgEst = f-estado) ~
and (FacCpedi.fchent >= xFchDesde  ~
 and FacCPedi.fchent <= xFchHasta) ~
 and (TRUE <> (xAlmSal > "") OR FacCPedi.codalm = xAlmSal) NO-LOCK, ~
      FIRST gn-clie WHERE gn-clie.CodCia = cl-codcia ~
  AND gn-clie.CodCli = FacCPedi.CodCli NO-LOCK, ~
      FIRST gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND FacCPedi.CodCia = S-CODCIA ~
 AND FacCPedi.CodDiv = S-CODDIV ~
 AND FacCPedi.CodDoc = S-CODDOC ~
 AND (TRUE <> (wclient > '') OR FacCpedi.Nomcli BEGINS wclient) ~
 AND (TRUE <> (f-Estado > '') OR FacCPedi.FlgEst = f-estado) ~
and (FacCpedi.fchent >= xFchDesde  ~
 and FacCPedi.fchent <= xFchHasta) ~
 and (TRUE <> (xAlmSal > "") OR FacCPedi.codalm = xAlmSal) NO-LOCK, ~
      FIRST gn-clie WHERE gn-clie.CodCia = cl-codcia ~
  AND gn-clie.CodCli = FacCPedi.CodCli NO-LOCK, ~
      FIRST gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table FacCPedi gn-clie gn-ConVt
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacCPedi
&Scoped-define SECOND-TABLE-IN-QUERY-br_table gn-clie
&Scoped-define THIRD-TABLE-IN-QUERY-br_table gn-ConVt


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-3 COMBO-BOX-5 wclient wcotiza ~
txtDesde txtHasta txtAlm br_table btnExcel 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-3 COMBO-BOX-5 wclient wcotiza ~
txtDesde txtHasta txtAlm 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fItems B-table-Win 
FUNCTION fItems RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPeso B-table-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON btnExcel 
     LABEL "Excel" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX-3 AS CHARACTER FORMAT "X(256)":U INITIAL "Cotización" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Despacho","Cliente" 
     DROP-DOWN-LIST
     SIZE 13.43 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-5 AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Condición" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","Pendiente","Atendido","Anulado" 
     DROP-DOWN-LIST
     SIZE 11.57 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE txtAlm AS CHARACTER FORMAT "X(5)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta :" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE wclient AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .77 NO-UNDO.

DEFINE VARIABLE wcotiza AS CHARACTER FORMAT "XXX-XXXXXX":U 
     LABEL "Orden #" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      FacCPedi, 
      gn-clie, 
      gn-ConVt SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacCPedi.NroPed COLUMN-LABEL "Despacho" FORMAT "XXX-XXXXXXXX":U
      FacCPedi.NroRef COLUMN-LABEL "Pedido" FORMAT "XXX-XXXXXXXX":U
      FacCPedi.NomCli FORMAT "x(40)":U
      FacCPedi.ordcmp FORMAT "X(12)":U WIDTH 11.14
      FacCPedi.CodVen COLUMN-LABEL "Vend." FORMAT "XXXX":U
      FacCPedi.FchPed COLUMN-LABEL "    Fecha    !   Emisión" FORMAT "99/99/9999":U
      FacCPedi.CodAlm FORMAT "x(3)":U
      FacCPedi.FchEnt FORMAT "99/99/9999":U
      X-VTA @ X-VTA COLUMN-LABEL "Tip. !Vta." FORMAT "XXXX":U
      FacCPedi.ImpTot FORMAT "->>,>>>,>>9.99":U
      X-MON @ X-MON COLUMN-LABEL "Mon." FORMAT "x(4)":U
      X-STA @ X-STA COLUMN-LABEL "Estado" FORMAT "XXXX":U
      fItems() @ x-Items COLUMN-LABEL "# de Items" FORMAT ">>>9":U
            WIDTH 8.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 125.14 BY 17.85
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-3 AT ROW 1.23 COL 10.14 NO-LABEL
     COMBO-BOX-5 AT ROW 1.27 COL 72.43 COLON-ALIGNED
     wclient AT ROW 1.31 COL 32.43 COLON-ALIGNED
     wcotiza AT ROW 1.31 COL 32.43 COLON-ALIGNED
     txtDesde AT ROW 2.27 COL 30.29 COLON-ALIGNED WIDGET-ID 8
     txtHasta AT ROW 2.31 COL 48.14 COLON-ALIGNED WIDGET-ID 6
     txtAlm AT ROW 2.31 COL 67 COLON-ALIGNED WIDGET-ID 12
     br_table AT ROW 3.31 COL 1.86
     btnExcel AT ROW 21.62 COL 53 WIDGET-ID 4
     "Fecha de ENTREGA" VIEW-AS TEXT
          SIZE 16 BY .5 AT ROW 2.5 COL 8.43 WIDGET-ID 10
          FGCOLOR 9 
     "(*) Doble Click - Visualiza Detalle" VIEW-AS TEXT
          SIZE 27 BY .5 AT ROW 22.04 COL 4 WIDGET-ID 2
          FONT 6
     "Buscar x" VIEW-AS TEXT
          SIZE 7.86 BY .5 AT ROW 1.46 COL 1.86
          FONT 6
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
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
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
         HEIGHT             = 21.96
         WIDTH              = 135.
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
/* BROWSE-TAB br_table txtAlm F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX COMBO-BOX-3 IN FRAME F-Main
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.FacCPedi,INTEGRAL.gn-clie WHERE INTEGRAL.FacCPedi ...,INTEGRAL.gn-ConVt WHERE INTEGRAL.FacCPedi ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST, FIRST"
     _Where[1]         = "integral.FacCPedi.CodCia = S-CODCIA
 AND integral.FacCPedi.CodDiv = S-CODDIV
 AND integral.FacCPedi.CodDoc = S-CODDOC
 AND (TRUE <> (wclient > '') OR FacCpedi.Nomcli BEGINS wclient)
 AND (TRUE <> (f-Estado > '') OR FacCPedi.FlgEst = f-estado)
and (FacCpedi.fchent >= xFchDesde 
 and FacCPedi.fchent <= xFchHasta)
 and (TRUE <> (xAlmSal > """") OR FacCPedi.codalm = xAlmSal)"
     _JoinCode[2]      = "integral.gn-clie.CodCia = cl-codcia
  AND integral.gn-clie.CodCli = integral.FacCPedi.CodCli"
     _JoinCode[3]      = "integral.gn-ConVt.Codig = integral.FacCPedi.FmaPgo"
     _FldNameList[1]   > integral.FacCPedi.NroPed
"FacCPedi.NroPed" "Despacho" "XXX-XXXXXXXX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.FacCPedi.NroRef
"FacCPedi.NroRef" "Pedido" "XXX-XXXXXXXX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.FacCPedi.NomCli
"FacCPedi.NomCli" ? "x(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.ordcmp
"FacCPedi.ordcmp" ? ? "character" ? ? ? ? ? ? no ? no no "11.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > integral.FacCPedi.CodVen
"FacCPedi.CodVen" "Vend." "XXXX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > integral.FacCPedi.FchPed
"FacCPedi.FchPed" "    Fecha    !   Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = INTEGRAL.FacCPedi.CodAlm
     _FldNameList[8]   = INTEGRAL.FacCPedi.FchEnt
     _FldNameList[9]   > "_<CALC>"
"X-VTA @ X-VTA" "Tip. !Vta." "XXXX" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   = integral.FacCPedi.ImpTot
     _FldNameList[11]   > "_<CALC>"
"X-MON @ X-MON" "Mon." "x(4)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"X-STA @ X-STA" "Estado" "XXXX" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"fItems() @ x-Items" "# de Items" ">>>9" ? ? ? ? ? ? ? no ? no no "8.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
  
    RUN vta\D-ordpen.r(Faccpedi.nroped,"O/D").

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


&Scoped-define SELF-NAME btnExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnExcel B-table-Win
ON CHOOSE OF btnExcel IN FRAME F-Main /* Excel */
DO:
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN ToExcel.
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-3 B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-3 IN FRAME F-Main
DO:
  wcotiza:visible = yes.
  wclient:visible = yes.
  ASSIGN COMBO-BOX-3.
  CASE COMBO-BOX-3:
       WHEN "Cliente" THEN
            wcotiza:visible = not wcotiza:visible.
       WHEN "Despacho" THEN
            wclient:visible = not wclient:visible.
  end case.         
  ASSIGN COMBO-BOX-3.
/* RUN abrir-QUERY.*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-5 B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-5 IN FRAME F-Main /* Condición */
DO:
  ASSIGN COMBO-BOX-5.
  CASE COMBO-BOX-5:
       WHEN "Pendiente" THEN 
          ASSIGN F-ESTADO = "P".
       WHEN "Atendido" THEN 
          ASSIGN F-ESTADO = "C".          
       WHEN "Anulado" THEN 
          ASSIGN F-ESTADO = "A".
       OTHERWISE
          ASSIGN F-ESTADO = "".        
  END.        
  RUN abrir-query.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtAlm B-table-Win
ON LEAVE OF txtAlm IN FRAME F-Main /* Almacen */
DO:
  
    ASSIGN txtAlm.
    xAlmSal = txtAlm.

    {&OPEN-QUERY-br_table}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtDesde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtDesde B-table-Win
ON LEAVE OF txtDesde IN FRAME F-Main /* Desde */
DO:
  
  ASSIGN txtDesde.
  xFchDesde = txtDesde.

  {&OPEN-QUERY-br_table}
  /*RUN abrir-query.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtHasta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtHasta B-table-Win
ON LEAVE OF txtHasta IN FRAME F-Main /* Hasta : */
DO:
    ASSIGN txtHasta.
    xFchHasta = txtHasta.

    {&OPEN-QUERY-br_table}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME wclient
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wclient B-table-Win
ON LEAVE OF wclient IN FRAME F-Main /* Cliente */
or "RETURN":U of WCLIENT
DO:
    ASSIGN WCLIENT.
    run abrir-query.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME wcotiza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wcotiza B-table-Win
ON LEAVE OF wcotiza IN FRAME F-Main /* Orden # */
or "RETURN":U of wcotiza
DO:
  IF INPUT wcotiza = "" THEN RETURN.
  find first FacCpedi where FacCpedi.NroPed = substring(wcotiza:screen-value,1,3) +
             string(integer(substring(wcotiza:screen-value,5,6)),"999999") AND
             integral.FacCPedi.CodDoc = "O/D" AND
             integral.FacCPedi.NomCli BEGINS wclient AND
             integral.FacCPedi.FlgEst BEGINS F-ESTADO NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCpedi THEN DO:
     MESSAGE " No.Orden de Despacho NO EXISTE "
     VIEW-AS ALERT-BOX ERROR.
     wcotiza:screen-value = "".
     RETURN.
  END.        
  R-coti = RECID(FacCpedi).
  REPOSITION BR_TABLE TO RECID R-coti.  
  RUN dispatch IN THIS-PROCEDURE('ROW-CHANGED':U). 
  IF ERROR-STATUS:ERROR THEN DO:
     MESSAGE " No.Orden de Despacho NO EXISTE "
     VIEW-AS ALERT-BOX ERROR.
     wcotiza:screen-value = "".
     RETURN.
  END.
  wcotiza:SCREEN-VALUE = "".    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */
ON FIND OF FACCPEDI  
DO:
    IF FacCPedi.CodMon = 1 THEN
        ASSIGN
            X-MON = "S/." .
    ELSE
        ASSIGN
            X-MON = "US$" .
            
/*  IF Faccpedi.tipvta = "1" THEN
        ASSIGN
            X-VTA = "Factura".
    ELSE
        ASSIGN
            X-VTA = "Letra".   */

    IF Faccpedi.FmaPgo = "000" THEN
        ASSIGN
            X-VTA = "CT".
    ELSE
        ASSIGN
            X-VTA = "CR".  
                         
    IF FacCPedi.FlgEst = "P" THEN
        ASSIGN
            X-STA = "PEN".
    ELSE
        IF FacCpedi.FlgEst = "C" THEN
           ASSIGN 
              X-STA = "ATE".
        ELSE        
           ASSIGN
              X-STA = "ANU".                           

END.


&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE abrir-query B-table-Win 
PROCEDURE abrir-query :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

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
  ASSIGN 
      txtDesde = ADD-INTERVAL(TODAY, -1, "year")
      txtHasta = ADD-INTERVAL(TODAY, +3, "months").


  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  wclient:visible IN FRAME F-MAIN = not wclient:visible .
/*
  txtDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '01/01/2000'.
  txtHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").
  */

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
  {src/adm/template/snd-list.i "FacCPedi"}
  {src/adm/template/snd-list.i "gn-clie"}
  {src/adm/template/snd-list.i "gn-ConVt"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ToExcel B-table-Win 
PROCEDURE ToExcel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

        DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
        DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
        DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

        DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

        DEFINE VARIABLE iCount                  AS INTEGER init 1.
        DEFINE VARIABLE iIndex                  AS INTEGER.
        DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
        DEFINE VARIABLE cColumn                 AS CHARACTER.
        DEFINE VARIABLE cRange                  AS CHARACTER.
        DEFINE VARIABLE x-signo                 AS DECI.

        /* create a new Excel Application object */
        CREATE "Excel.Application" chExcelApplication.

        /* launch Excel so it is visible to the user */
        chExcelApplication:Visible = FALSE.

        /* Para crear a new Workbook */
        chWorkbook = chExcelApplication:Workbooks:Add().

        /* get the active Worksheet */
        chWorkSheet = chExcelApplication:Sheets:Item(1).

        /* set the column names for the Worksheet */

        chWorkSheet:Range("A1:Z1"):Font:Bold = TRUE.
        chWorkSheet:Range("A1"):Value = "Despacho".
        chWorkSheet:Range("B1"):Value = "Pedido".
        chWorkSheet:Range("C1"):Value = "Nombre".
        chWorkSheet:Range("D1"):Value = "Vendedor".
        chWorkSheet:Range("E1"):Value = "F.Emision".
        chWorkSheet:Range("F1"):Value = "Tipo Vta".
        chWorkSheet:Range("G1"):Value = "Importe Total".
        chWorkSheet:Range("H1"):Value = "Moneda".
        chWorkSheet:Range("I1"):Value = "Estado".
        chWorkSheet:Range("J1"):Value = "Dias".
        chWorkSheet:Range("K1"):Value = "Almacen".
        chWorkSheet:Range("L1"):Value = "F.Entrega".
        chWorkSheet:Range("M1"):Value = "Orden Compra".
        chWorkSheet:Range("N1"):Value = "Dirección de entrega (B2B)".

    /* */
    iColumn = 1.
    GET FIRST {&BROWSE-NAME}.
    DO  WHILE AVAILABLE faccpedi:

             iColumn = iColumn + 1.
             cColumn = STRING(iColumn).

             cRange = "A" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + faccpedi.nroped.
             cRange = "B" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + faccpedi.nroref.
             cRange = "C" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + faccpedi.nomcli.
             cRange = "D" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + faccpedi.codven.
             cRange = "E" + cColumn.
             chWorkSheet:Range(cRange):Value = faccpedi.fchped.
             cRange = "F" + cColumn.
             chWorkSheet:Range(cRange):Value = IF Faccpedi.FmaPgo = "000" THEN 'CT' ELSE 'CR'.
             cRange = "G" + cColumn.
             chWorkSheet:Range(cRange):Value = faccpedi.imptot.
             cRange = "H" + cColumn.
             chWorkSheet:Range(cRange):Value = IF FacCPedi.CodMon = 1 THEN 'S/.' ELSE "US$".
             cRange = "I" + cColumn.
             chWorkSheet:Range(cRange):Value = IF FacCPedi.FlgEst = "P" THEN ' PE' ELSE IF FacCpedi.FlgEst = "C" THEN 'ATE' ELSE 'ANU'.
             cRange = "J" + cColumn.
             chWorkSheet:Range(cRange):Value = TODAY - faccpedi.fchped.
             cRange = "K" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + faccpedi.codalm.
             cRange = "L" + cColumn.
             chWorkSheet:Range(cRange):Value = faccpedi.fchent.
             cRange = "M" + cColumn.
             chWorkSheet:Range(cRange):Value = faccpedi.ordcmp.
             /* 26/09/2025: Buscamos la COT */
             FIND FIRST PEDIDO WHERE PEDIDO.codcia = s-codcia 
                 AND PEDIDO.coddoc = Faccpedi.codref
                 AND PEDIDO.nroped = Faccpedi.nroref
                 NO-LOCK NO-ERROR.
             IF AVAILABLE PEDIDO THEN DO:
                 FIND FIRST COTIZACION WHERE COTIZACION.codcia = s-codcia
                     AND COTIZACION.coddoc = PEDIDO.codref
                     AND COTIZACION.nroped = PEDIDO.nroref
                     NO-LOCK NO-ERROR.
                 IF AVAILABLE COTIZACION THEN DO:
                     cRange = "N" + cColumn.
                     chWorkSheet:Range(cRange):Value = COTIZACION.DeliveryAddress.
                 END.
             END.


        GET NEXT {&BROWSE-NAME}.
    END.

        /* release com-handles */
    chExcelApplication:Visible = TRUE.

        RELEASE OBJECT chExcelApplication NO-ERROR.      
        RELEASE OBJECT chWorkbook NO-ERROR.
        RELEASE OBJECT chWorksheet NO-ERROR.
        RELEASE OBJECT chWorksheetRange NO-ERROR. 

        MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.



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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fItems B-table-Win 
FUNCTION fItems RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-Items AS INT NO-UNDO INIT 0.

  FOR EACH facdpedi OF faccpedi NO-LOCK:
      x-Items = x-Items + 1.
  END.
  RETURN x-Items.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPeso B-table-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-Peso AS DEC NO-UNDO.


  FOR EACH Facdpedi OF faccpedi NO-LOCK, 
      FIRST Almmmatg OF Facdpedi NO-LOCK:
  END.

  RETURN 0.00.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

