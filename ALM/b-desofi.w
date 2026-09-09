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
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE SHARED VAR S-NOMALM AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE VAR X-MON AS CHARACTER NO-UNDO.
DEFINE VAR X-VTA AS CHARACTER NO-UNDO.
DEFINE VAR X-STA AS CHARACTER NO-UNDO.
DEFINE VAR X-GUI AS CHARACTER NO-UNDO.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR cl-codcia AS INT.
DEFINE VAR S-CODDOC AS CHAR INIT "O/D".
DEFINE VAR R-PEDI AS RECID.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE VAR F-ESTADO AS CHAR.

DEFINE BUFFER B-Pedi FOR FacCPedi.

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
&Scoped-define FIELDS-IN-QUERY-br_table FacCPedi.NroPed FacCPedi.NomCli FacCPedi.CodVen FacCPedi.FchPed FacCPedi.TpoPed FacCPedi.Cmpbnte FacCPedi.NCmpbnte X-GUI @ X-GUI   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table   
&Scoped-define SELF-NAME br_table
&Scoped-define OPEN-QUERY-br_table IF COMBO-BOX-6:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Fechas" THEN DO :      OPEN QUERY {&SELF-NAME} FOR EACH FacCPedi WHERE {&KEY-PHRASE}          AND FacCPedi.CodCia = S-CODCIA          AND FacCPedi.Codalm = S-CODALM          AND FacCPedi.CodDiv BEGINS S-CODDIV          AND FacCPedi.CodDoc BEGINS S-CODDOC          AND FacCpedi.Nomcli BEGINS wclient          AND FacCPedi.FlgEst = 'F'          AND FacCPedi.FlgSit = ' '          AND FacCPedi.FchPed >= F-DesFch          AND FacCPedi.FchPed <= F-HasFch NO-LOCK, ~
                FIRST gn-clie WHERE gn-clie.CodCia = cl-codcia                AND gn-clie.CodCli = FacCPedi.CodCli NO-LOCK, ~
                FIRST gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK          {&SORTBY-PHRASE}. END. ELSE DO :     OPEN QUERY {&SELF-NAME} FOR EACH FacCPedi WHERE {&KEY-PHRASE}          AND FacCPedi.CodCia = S-CODCIA          AND FacCPedi.Codalm = S-CODALM          AND FacCPedi.CodDiv BEGINS S-CODDIV          AND FacCPedi.CodDoc BEGINS S-CODDOC          AND FacCpedi.Nomcli BEGINS wclient          AND FacCPedi.FlgEst = 'F'          AND FacCPedi.FlgSit = ''    NO-LOCK, ~
                FIRST gn-clie WHERE gn-clie.CodCia = cl-codcia                AND gn-clie.CodCli = FacCPedi.CodCli NO-LOCK, ~
                FIRST gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK          {&SORTBY-PHRASE}. END.
&Scoped-define TABLES-IN-QUERY-br_table FacCPedi gn-clie gn-ConVt
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacCPedi
&Scoped-define SECOND-TABLE-IN-QUERY-br_table gn-clie
&Scoped-define THIRD-TABLE-IN-QUERY-br_table gn-ConVt


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS wclient F-DesFch F-HasFch COMBO-BOX-6 ~
wpedido br_table 
&Scoped-Define DISPLAYED-OBJECTS wclient F-DesFch F-HasFch COMBO-BOX-6 ~
wpedido 

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
     LIST-ITEMS "Orden Despacho","Cliente","Fechas" 
     DROP-DOWN-LIST
     SIZE 16.57 BY 1 NO-UNDO.

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

DEFINE VARIABLE wpedido AS CHARACTER FORMAT "XXX-XXXXXX":U 
     LABEL "Numero" 
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      FacCPedi.NroPed COLUMN-LABEL "Orden!Despacho" FORMAT "XXX-XXXXXXXX"
      FacCPedi.NomCli FORMAT "x(43)"
      FacCPedi.CodVen COLUMN-LABEL "Vend." FORMAT "x(4)"
      FacCPedi.FchPed COLUMN-LABEL "     Fecha    !   Emisión"
      FacCPedi.TpoPed COLUMN-LABEL "     T I P O      ." FORMAT "X(9)"
      FacCPedi.Cmpbnte  COLUMN-LABEL "Cod."
      FacCPedi.NCmpbnte COLUMN-LABEL "Numero       ." FORMAT "XXX-XXXXXX"
      X-GUI @ X-GUI   COLUMN-LABEL "G/R" FORMAT "X(4)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 85 BY 8.58
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     wclient AT ROW 1.31 COL 36.29 COLON-ALIGNED
     F-DesFch AT ROW 1.31 COL 37.29 COLON-ALIGNED
     F-HasFch AT ROW 1.31 COL 57.57 COLON-ALIGNED
     COMBO-BOX-6 AT ROW 1.35 COL 10.43 COLON-ALIGNED NO-LABEL
     wpedido AT ROW 1.35 COL 36.29 COLON-ALIGNED
     br_table AT ROW 2.46 COL 1
     "Buscar x" VIEW-AS TEXT
          SIZE 8.57 BY .65 AT ROW 1.35 COL 2.43
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
         HEIGHT             = 10.23
         WIDTH              = 85.14.
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
/* BROWSE-TAB br_table wpedido F-Main */
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
         AND FacCPedi.Codalm = S-CODALM
         AND FacCPedi.CodDiv BEGINS S-CODDIV
         AND FacCPedi.CodDoc BEGINS S-CODDOC
         AND FacCpedi.Nomcli BEGINS wclient
         AND FacCPedi.FlgEst = 'F'
         AND FacCPedi.FlgSit = ' '
         AND FacCPedi.FchPed >= F-DesFch
         AND FacCPedi.FchPed <= F-HasFch NO-LOCK,
         FIRST gn-clie WHERE gn-clie.CodCia = cl-codcia
               AND gn-clie.CodCli = FacCPedi.CodCli NO-LOCK,
         FIRST gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK
         {&SORTBY-PHRASE}.
END.
ELSE DO :
    OPEN QUERY {&SELF-NAME} FOR EACH FacCPedi WHERE {&KEY-PHRASE}
         AND FacCPedi.CodCia = S-CODCIA
         AND FacCPedi.Codalm = S-CODALM
         AND FacCPedi.CodDiv BEGINS S-CODDIV
         AND FacCPedi.CodDoc BEGINS S-CODDOC
         AND FacCpedi.Nomcli BEGINS wclient
         AND FacCPedi.FlgEst = 'F'
         AND FacCPedi.FlgSit = ''    NO-LOCK,
         FIRST gn-clie WHERE gn-clie.CodCia = cl-codcia
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
  RUN vta\d-pedcon.r(Faccpedi.nroped,"O/D").
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
  ASSIGN COMBO-BOX-6.
  CASE COMBO-BOX-6:
       WHEN "Cliente" THEN
            wclient:HIDDEN = not wclient:HIDDEN.
       WHEN "Orden de Despacho" THEN            
            wpedido:HIDDEN = not wpedido:HIDDEN.
       WHEN "Fechas" THEN DO :
                   F-DesFch:HIDDEN = not F-DesFch:HIDDEN.
                   F-HasFch:HIDDEN = not F-HasFch:HIDDEN.
       END.            
  END CASE.         
  ASSIGN COMBO-BOX-6.
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


&Scoped-define SELF-NAME wpedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wpedido B-table-Win
ON LEAVE OF wpedido IN FRAME F-Main /* Numero */
or "RETURN":U of wpedido
DO:
  IF INPUT wpedido = "" THEN RETURN.
  find first FacCpedi where FacCpedi.NroPed = substring(wpedido:screen-value,1,3) +
             string(integer(substring(wpedido:screen-value,5,6)),"999999") AND
             integral.FacCPedi.CodDoc = "PED" AND
             integral.FacCPedi.NomCli BEGINS wclient AND
             integral.FacCPedi.FlgEst BEGINS F-ESTADO NO-LOCK NO-ERROR.
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
            
    IF FacCPedi.TpoPed = 'MOSTRADOR' THEN DO:
       FIND FacCPedm WHERE FacCPedm.codcia = s-codcia AND
            FacCPedm.coddoc = 'P/M' AND FacCPedm.nroped = FacCPedi.Nroref NO-LOCK NO-ERROR.
       IF AVAILABLE FacCPedm THEN DO:
          IF FacCPedm.DocDesp = 'GUIA' THEN X-GUI = 'OK'.
          ELSE X-GUI = ''.
          END.
       ELSE X-GUI = ''.
       END.
    ELSE X-GUI = 'OK'.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Despacho-Mostrador B-table-Win 
PROCEDURE Despacho-Mostrador :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  X-GUI = ''.
  FIND FacCPedm WHERE FacCPedm.codcia = s-codcia AND
       FacCPedm.coddoc = 'P/M' AND FacCPedm.nroped = FacCPedi.Nroref NO-LOCK NO-ERROR.
  IF AVAILABLE FacCPedm THEN X-GUI = FacCPedm.DocDesp.

  IF X-GUI = 'GUIA' THEN RUN Generar-Guia-Remision.
  
  /* Descarga la mercaderia de almacen haciendo referencia al documento FAC/BOL */
  DEFINE VAR s-codmov AS INTEGER NO-UNDO.
  DEFINE VAR s-ptovta AS INTEGER NO-UNDO.
  
  FIND FacDocum WHERE FacDocum.CodCia = s-codcia AND 
       FacDocum.CodDoc = FacCPedi.Cmpbnte NO-LOCK NO-ERROR.
  IF AVAILABLE FacDocum THEN s-codmov = FacDocum.CodMov.
  FIND CcbCDocu WHERE CcbCDocu.codcia = s-codcia AND
       CcbCDocu.coddoc = FacCPedi.Cmpbnte AND
       CcbCDocu.nrodoc = FacCPedi.NCmpbnte NO-ERROR.
       
  s-ptovta = INTEGER(SUBSTRING(FacCPedi.NCmpbnte,1,3)).
  
  /* Correlativo de Salida */
  FIND Almacen WHERE Almacen.CodCia = s-codcia AND
       Almacen.CodAlm = s-codalm EXCLUSIVE-LOCK NO-ERROR.
  
  CREATE almcmov.
  ASSIGN
    Almcmov.CodCia  = s-codcia
    Almcmov.CodAlm  = s-codalm
    Almcmov.TipMov  = "S"
    Almcmov.CodMov  = s-codmov
    Almcmov.NroSer  = s-ptovta
    Almcmov.NroDoc  = Almacen.CorrSal
    Almacen.CorrSal = Almacen.CorrSal + 1
    Almcmov.CodRef  = s-coddoc
    Almcmov.NroRef  = CcbCDocu.nrodoc
    Almcmov.NroRf1  = "F" + CcbCDocu.nrodoc
    Almcmov.Nomref  = ccbcdocu.nomcli
    Almcmov.FchDoc  = TODAY
    Almcmov.HorSal  = STRING(TIME, "HH:MM:SS")
    Almcmov.CodVen  = ccbcdocu.CodVen
    Almcmov.CodCli  = ccbcdocu.CodCli
    Almcmov.usuario = s-user-id
    CcbcDocu.NroSal = STRING(Almcmov.NroDoc,"999999").
  RELEASE Almacen.
    
  DEF VAR i AS INTEGER INITIAL 1 NO-UNDO.
  FOR EACH ccbddocu OF CcbCDocu NO-LOCK:
    CREATE Almdmov.
    ASSIGN
        Almdmov.CodCia = s-codcia
        Almdmov.CodAlm = s-codalm
        Almdmov.TipMov = "S"
        Almdmov.CodMov = s-codmov
        Almdmov.NroSer = almcmov.nroser
        Almdmov.NroDoc = almcmov.nrodoc
        Almdmov.NroItm = i
        Almdmov.codmat = ccbddocu.codmat
        Almdmov.CanDes = ccbddocu.candes
        Almdmov.AftIgv = ccbddocu.aftigv
        Almdmov.AftIsc = ccbddocu.aftisc
        Almdmov.CodMon = ccbcdocu.codmon
        Almdmov.CodUnd = ccbddocu.undvta
        Almdmov.Factor = ccbddocu.factor
        Almdmov.FchDoc = TODAY
        Almdmov.ImpDto = ccbddocu.impdto
        Almdmov.ImpIgv = ccbddocu.impigv
        Almdmov.ImpIsc = ccbddocu.impisc
        Almdmov.ImpLin = ccbddocu.implin
        Almdmov.PorDto = ccbddocu.pordto
        Almdmov.PreBas = ccbddocu.prebas
        Almdmov.PreUni = ccbddocu.preuni
        Almdmov.TpoCmb = ccbcdocu.tpocmb
        Almcmov.TotItm = i
        i = i + 1.
        RUN alm/almdgstk (ROWID(almdmov)).
        RUN alm/almacpr1 (ROWID(almdmov), "U").
        RUN alm/almacpr2 (ROWID(almdmov), "U"). 
  END.  
  RELEASE almcmov.
  RELEASE almdmov.
  RELEASE CcbCDocu.
  
  FIND B-Pedi WHERE ROWID(B-Pedi) = ROWID(FacCPedi) NO-ERROR.
  IF AVAILABLE B-Pedi THEN ASSIGN B-Pedi.Flgsit = 'D'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generar-Despacho B-table-Win 
PROCEDURE Generar-Despacho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF FacCPedi.Tpoped = 'MOSTRADOR' THEN RUN Despacho-Mostrador.
  ELSE RUN Despacho-Oficina.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  F-DesFch:SCREEN-VALUE IN FRAME F-MAIN = STRING(TODAY).
  F-HasFch:SCREEN-VALUE IN FRAME F-MAIN = STRING(TODAY).
  
  wclient:HIDDEN IN FRAME F-MAIN  = not wclient:HIDDEN.
  F-DesFch:HIDDEN IN FRAME F-MAIN = not F-DesFch:HIDDEN.
  F-HasFch:HIDDEN IN FRAME F-MAIN = not F-HasFch:HIDDEN.
  
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

