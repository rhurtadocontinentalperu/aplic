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
DEFINE VAR X-MON AS CHARACTER NO-UNDO.
DEFINE VAR X-VTA AS CHARACTER NO-UNDO.
DEFINE VAR X-STA AS CHARACTER NO-UNDO.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR CL-CODCIA AS INTEGER.
DEFINE VAR S-CODDOC AS CHAR INIT "PED".
DEFINE VAR R-PEDI AS RECID.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE VAR F-ESTADO AS CHAR.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE STREAM REPORTE.

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
&Scoped-define FIELDS-IN-QUERY-br_table FacCPedi.NroPed FacCPedi.NomCli FacCPedi.OrdCmp FacCPedi.CodVen FacCPedi.FchPed FacCPedi.fchven X-VTA @ X-VTA X-MON @ X-MON FacCPedi.ImpTot X-STA @ X-STA   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table   
&Scoped-define SELF-NAME br_table
&Scoped-define OPEN-QUERY-br_table IF COMBO-BOX-6:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Fechas" THEN DO :      OPEN QUERY {&SELF-NAME} FOR EACH FacCPedi WHERE {&KEY-PHRASE}          AND FacCPedi.CodCia = S-CODCIA          AND FacCPedi.CodDiv BEGINS S-CODDIV          AND FacCPedi.CodDoc BEGINS S-CODDOC          AND FacCpedi.Nomcli BEGINS wclient          AND FacCPedi.FlgEst BEGINS f-estado          AND FacCPedi.FchPed >= F-DesFch          AND FacCPedi.FchPed <= F-HasFch          AND FacCPedi.Ordcmp BEGINS wcompra          NO-LOCK, ~
                FIRST gn-clie WHERE gn-clie.CodCia = CL-CODCIA          AND gn-clie.CodCli = FacCPedi.CodCli NO-LOCK, ~
                    FIRST gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK             {&SORTBY-PHRASE}. END. ELSE DO :     OPEN QUERY {&SELF-NAME} FOR EACH FacCPedi WHERE {&KEY-PHRASE}          AND FacCPedi.CodCia = S-CODCIA          AND FacCPedi.CodDiv BEGINS S-CODDIV          AND FacCPedi.CodDoc BEGINS S-CODDOC          AND FacCpedi.Nomcli BEGINS wclient          AND FacCPedi.FlgEst BEGINS f-estado          AND FacCPedi.Ordcmp BEGINS wcompra          NO-LOCK, ~
                FIRST gn-clie WHERE gn-clie.CodCia = CL-CODCIA          AND gn-clie.CodCli = FacCPedi.CodCli NO-LOCK, ~
                    FIRST gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK             {&SORTBY-PHRASE}. END.
&Scoped-define TABLES-IN-QUERY-br_table FacCPedi gn-clie gn-ConVt
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacCPedi
&Scoped-define SECOND-TABLE-IN-QUERY-br_table gn-clie
&Scoped-define THIRD-TABLE-IN-QUERY-br_table gn-ConVt


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-21 COMBO-BOX-6 wpedido wcompra wclient ~
F-DesFch F-HasFch COMBO-BOX-7 br_table 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-6 wpedido wcompra wclient ~
F-DesFch F-HasFch COMBO-BOX-7 

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
DEFINE VARIABLE COMBO-BOX-6 AS CHARACTER FORMAT "X(256)":U INITIAL "Pedido" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Pedido","Cliente","Fechas","O/Compra" 
     DROP-DOWN-LIST
     SIZE 11.72 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-7 AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Condición" 
     VIEW-AS COMBO-BOX INNER-LINES 7
     LIST-ITEMS "Todos","Pendiente","Atendido","Anulado","Facturado","No Aprobado","Rechazado" 
     DROP-DOWN-LIST
     SIZE 11.57 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE F-DesFch AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .77 NO-UNDO.

DEFINE VARIABLE F-HasFch AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .77 NO-UNDO.

DEFINE VARIABLE wclient AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 32.86 BY .77 NO-UNDO.

DEFINE VARIABLE wcompra AS CHARACTER FORMAT "X(256)":U 
     LABEL "Compra" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE wpedido AS CHARACTER FORMAT "XXX-XXXXXX":U 
     LABEL "Pedido #" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.72 BY 1.42.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      FacCPedi, 
      gn-clie, 
      gn-ConVt SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      FacCPedi.NroPed COLUMN-LABEL "Pedido" FORMAT "XXX-XXXXXXXX"
      FacCPedi.NomCli FORMAT "x(29)"
      FacCPedi.OrdCmp 
      FacCPedi.CodVen COLUMN-LABEL "Vend." FORMAT "x(4)"
      FacCPedi.FchPed COLUMN-LABEL "    Fecha    !   Emisión "
      FacCPedi.fchven COLUMN-LABEL "    Fecha    !Vencimiento" FORMAT "99/99/9999"
      X-VTA @ X-VTA COLUMN-LABEL "Tpo.!Vta." FORMAT "XXXX"
      X-MON @ X-MON COLUMN-LABEL "Mon." FORMAT "x(4)"
      FacCPedi.ImpTot
      X-STA @ X-STA COLUMN-LABEL "Estado" FORMAT "XXXX"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 88.86 BY 11.77
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-6 AT ROW 1.19 COL 9.72 COLON-ALIGNED NO-LABEL
     wpedido AT ROW 1.31 COL 31.43 COLON-ALIGNED
     wcompra AT ROW 1.31 COL 31.43 COLON-ALIGNED
     wclient AT ROW 1.31 COL 31.43 COLON-ALIGNED
     F-DesFch AT ROW 1.31 COL 31.43 COLON-ALIGNED
     F-HasFch AT ROW 1.31 COL 52.72 COLON-ALIGNED
     COMBO-BOX-7 AT ROW 1.31 COL 73.86 COLON-ALIGNED
     br_table AT ROW 2.46 COL 1
     "Buscar x" VIEW-AS TEXT
          SIZE 8.57 BY .65 AT ROW 1.35 COL 2.43
          FONT 6
     RECT-21 AT ROW 1 COL 1
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
         HEIGHT             = 13.35
         WIDTH              = 89.14.
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
/* BROWSE-TAB br_table COMBO-BOX-7 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
IF COMBO-BOX-6:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Fechas" THEN DO :

    OPEN QUERY {&SELF-NAME} FOR EACH FacCPedi WHERE {&KEY-PHRASE}
         AND FacCPedi.CodCia = S-CODCIA
         AND FacCPedi.CodDiv BEGINS S-CODDIV
         AND FacCPedi.CodDoc BEGINS S-CODDOC
         AND FacCpedi.Nomcli BEGINS wclient
         AND FacCPedi.FlgEst BEGINS f-estado
         AND FacCPedi.FchPed >= F-DesFch
         AND FacCPedi.FchPed <= F-HasFch
         AND FacCPedi.Ordcmp BEGINS wcompra
         NO-LOCK,
         FIRST gn-clie WHERE gn-clie.CodCia = CL-CODCIA
         AND gn-clie.CodCli = FacCPedi.CodCli NO-LOCK,
             FIRST gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK
            {&SORTBY-PHRASE}.
END.
ELSE DO :
    OPEN QUERY {&SELF-NAME} FOR EACH FacCPedi WHERE {&KEY-PHRASE}
         AND FacCPedi.CodCia = S-CODCIA
         AND FacCPedi.CodDiv BEGINS S-CODDIV
         AND FacCPedi.CodDoc BEGINS S-CODDOC
         AND FacCpedi.Nomcli BEGINS wclient
         AND FacCPedi.FlgEst BEGINS f-estado
         AND FacCPedi.Ordcmp BEGINS wcompra
         NO-LOCK,
         FIRST gn-clie WHERE gn-clie.CodCia = CL-CODCIA
         AND gn-clie.CodCli = FacCPedi.CodCli NO-LOCK,
             FIRST gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK
            {&SORTBY-PHRASE}.
END.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
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
  /* RUN vta\d-peddet.r(Faccpedi.nroped,gn-clie.nomcli).*/
  RUN vtamay/d-pedcon.r(Faccpedi.nroped,"PED").

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


&Scoped-define SELF-NAME COMBO-BOX-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-6 B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-6 IN FRAME F-Main
DO:
  wpedido:HIDDEN = yes.
  wclient:HIDDEN = yes.
  F-DesFch:HIDDEN = yes.
  F-HasFch:HIDDEN = yes.
  wcompra:HIDDEN = yes.
  
  ASSIGN COMBO-BOX-6.
  CASE COMBO-BOX-6:
       WHEN "Cliente" THEN
            wclient:HIDDEN = not wclient:HIDDEN.
       WHEN "Pedido" THEN
            wpedido:HIDDEN = not wpedido:HIDDEN.
       WHEN "Fechas" THEN DO :
                   F-DesFch:HIDDEN = not F-DesFch:HIDDEN.
                   F-HasFch:HIDDEN = not F-HasFch:HIDDEN.
       END.
       WHEN "O/Compra" THEN
            wcompra:HIDDEN = not wcompra:HIDDEN.
  END CASE.
  ASSIGN COMBO-BOX-6.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-7 B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-7 IN FRAME F-Main /* Condición */
DO:
  ASSIGN COMBO-BOX-7.
  CASE COMBO-BOX-7:
       WHEN "Pendiente" THEN 
          ASSIGN F-ESTADO = "P".
       WHEN "Atendido " THEN 
          ASSIGN F-ESTADO = "C".          
       WHEN "Anulado" THEN 
          ASSIGN F-ESTADO = "A".
       WHEN "Facturado" THEN 
          ASSIGN F-ESTADO = "F".
       WHEN "No Aprobado" THEN 
          ASSIGN F-ESTADO = "X".
       WHEN "Rechazado" THEN 
          ASSIGN F-ESTADO = "R".
       OTHERWISE
          ASSIGN F-ESTADO = "".        
  END.        
  RUN abrir-query.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-HasFch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-HasFch B-table-Win
ON LEAVE OF F-HasFch IN FRAME F-Main /* Hasta */
or "RETURN":U of F-HasFch
DO:
  ASSIGN F-DesFch F-HasFch.
  RUN ABRIR-QUERY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME wclient
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wclient B-table-Win
ON LEAVE OF wclient IN FRAME F-Main /* Cliente */
or "RETURN":U of wclient
DO:
  ASSIGN WCLIENT.
  RUN ABRIR-QUERY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME wcompra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wcompra B-table-Win
ON LEAVE OF wcompra IN FRAME F-Main /* Compra */
OR "RETURN":U of wcompra
DO:
  ASSIGN wcompra.
  RUN ABRIR-QUERY.
  ASSIGN wcompra = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME wpedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wpedido B-table-Win
ON LEAVE OF wpedido IN FRAME F-Main /* Pedido # */
or "RETURN":U of wpedido
DO:
  IF INPUT wpedido = "" THEN RETURN.
  FIND FIRST FacCpedi WHERE FacCpedi.NroPed = SUBSTRING(wpedido:SCREEN-VALUE,1,3) +
             STRING(INTEGER(SUBSTRING(wpedido:SCREEN-VALUE,5,6)),"999999") AND
             FacCPedi.CodDoc = "PED" AND
             FacCPedi.NomCli BEGINS wclient AND
             FacCPedi.FlgEst BEGINS F-ESTADO
             NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCpedi THEN DO:
     MESSAGE " No.Pedido NO EXISTE "
     VIEW-AS ALERT-BOX ERROR.
     wpedido:screen-value = "".
     RETURN.
  END.        
  R-pedi = RECID(FacCpedi).
  REPOSITION BR_TABLE TO RECID R-pedi.  
  RUN dispatch IN THIS-PROCEDURE('ROW-CHANGED':U). 
  IF ERROR-STATUS:ERROR THEN DO:
     MESSAGE " No. Pedido NO EXISTE "
     VIEW-AS ALERT-BOX ERROR.
     wpedido:screen-value = "".
     RETURN.
  END.
  wpedido:SCREEN-VALUE = "".    
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
            
    IF FacCPedi.FmaPgo = "000" THEN
        ASSIGN
            X-VTA = "CT".
    ELSE
        ASSIGN
            X-VTA = "CR".            
    
    CASE FacCPedi.FlgEst :
       WHEN "P" THEN ASSIGN X-STA = "PEND".
       WHEN "C" THEN ASSIGN X-STA = "ATEN".
       WHEN "A" THEN ASSIGN X-STA = "ANUL".
       WHEN "R" THEN ASSIGN X-STA = "RECH".
       WHEN "X" THEN ASSIGN X-STA = "NAPR".
       WHEN "F" THEN ASSIGN X-STA = "FACT".
    END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel B-table-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Llave AS CHAR FORMAT 'x(1000)' NO-UNDO.
DEF VAR x-Titulo AS CHAR FORMAT 'x(1000)' NO-UNDO.
DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-NomPro LIKE gn-prov.nompro NO-UNDO.

x-Archivo = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".

OUTPUT STREAM REPORTE TO VALUE (x-Archivo).
x-Titulo = 'Numero|Cliente|Ord.Compra|Vendedor|Emision|Vencimiento|Tpo.Vta.|Mon|' +
    'Importe|Estado|'.
x-Titulo = REPLACE(x-Titulo, '|', CHR(9) ).
PUT STREAM REPORTE x-Titulo SKIP.

GET FIRST {&Browse-name}.
REPEAT WHILE AVAILABLE faccpedi:
    x-Llave = Faccpedi.NroPed + "|".
    x-Llave = x-llave + Faccpedi.NomCli + "|".
    x-Llave = x-llave + Faccpedi.OrdCmp + "|".
    x-Llave = x-llave + Faccpedi.CodVen + "|".
    x-Llave = x-llave + STRING (Faccpedi.FchPed, "99/99/9999") + "|".
    x-Llave = x-llave + STRING (Faccpedi.FchVen, "99/99/9999") + "|".
    x-Llave = x-llave + x-Vta + "|".
    x-Llave = x-llave + x-Mon + "|".
    x-Llave = x-llave + STRING (Faccpedi.ImpTo, "->>>,>>>,>>9.99") + "|".
    x-Llave = x-llave + x-Sta + "|".
    x-Llave = REPLACE ( x-Llave, '|', CHR(9) ).
    PUT STREAM REPORTE x-LLave SKIP.
    GET NEXT {&browse-name}.
END.
OUTPUT STREAM REPORTE CLOSE.

/* CARGAMOS EL EXCEL */
RUN lib/filetext-to-excel(x-Archivo, 'Anexo 1', YES).

  RUN ABRIR-QUERY.


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
  
  F-DesFch:SCREEN-VALUE IN FRAME F-MAIN = STRING(TODAY).
  F-HasFch:SCREEN-VALUE IN FRAME F-MAIN = STRING(TODAY).
  
  wclient:HIDDEN IN FRAME F-MAIN  = not wclient:HIDDEN.
  F-DesFch:HIDDEN IN FRAME F-MAIN = not F-DesFch:HIDDEN.
  F-HasFch:HIDDEN IN FRAME F-MAIN = not F-HasFch:HIDDEN.
  wcompra:HIDDEN IN FRAME F-MAIN  = not wcompra:HIDDEN.
  
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

