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
DEFINE SHARED VAR cl-codcia AS INT.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-SerGui  AS INTEGER.
DEFINE SHARED VAR S-SerFac  AS INTEGER.
DEFINE SHARED VAR S-SerBol  AS INTEGER.
DEFINE SHARED VAR S-CODALM  AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR.
DEFINE NEW SHARED VAR S-CODMOV  AS INTEGER.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE VAR S-CODDOC AS CHAR INIT "PED".
DEFINE VAR X-MON  AS CHARACTER NO-UNDO.
DEFINE VAR X-VTA  AS CHARACTER NO-UNDO.
DEFINE VAR X-DIAS AS INTEGER   NO-UNDO.
DEFINE VAR X-STA  AS CHARACTER NO-UNDO.
DEFINE VAR X-CMPB AS CHARACTER NO-UNDO.
DEFINE VAR R-COTI   AS RECID.
DEFINE VAR F-ESTADO AS CHAR NO-UNDO.

F-ESTADO = 'C'.

DEFINE BUFFER B-CPEDI  FOR FacCPedi.
DEFINE TEMP-TABLE DETA LIKE CcbDDocu.
DEFINE BUFFER B-CDOCU  FOR CcbCDocu.

DEFINE VAR C-NROGUI AS CHAR    NO-UNDO.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

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

FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.

DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-ATE AS CHAR    NO-UNDO.  /* Graba el documento que descarga el STOCK */

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
&Scoped-define FIELDS-IN-QUERY-br_table FacCPedi.NroPed FacCPedi.NomCli ~
FacCPedi.CodVen FacCPedi.FchPed X-VTA @ X-VTA FacCPedi.FmaPgo ~
X-DIAS @ X-DIAS X-MON @ X-MON FacCPedi.ImpTot X-CMPB @ X-CMPB X-STA @ X-STA 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND FacCPedi.CodCia = S-CODCIA ~
 AND FacCPedi.CodDiv BEGINS S-CODDIV ~
 AND FacCPedi.CodDoc BEGINS S-CODDOC ~
 AND FacCpedi.Nomcli BEGINS wclient ~
 AND LOOKUP(integral.FacCPedi.FlgEst,'C,P') > 0 NO-LOCK, ~
      FIRST gn-clie WHERE gn-clie.CodCia = cl-codcia ~
  AND gn-clie.CodCli = FacCPedi.CodCli NO-LOCK, ~
      FIRST gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND FacCPedi.CodCia = S-CODCIA ~
 AND FacCPedi.CodDiv BEGINS S-CODDIV ~
 AND FacCPedi.CodDoc BEGINS S-CODDOC ~
 AND FacCpedi.Nomcli BEGINS wclient ~
 AND LOOKUP(integral.FacCPedi.FlgEst,'C,P') > 0 NO-LOCK, ~
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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-3 wclient wcotiza br_table 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-3 wclient wcotiza 

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
DEFINE VARIABLE COMBO-BOX-3 AS CHARACTER FORMAT "X(256)":U INITIAL "Cotización" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Pedido","Cliente" 
     DROP-DOWN-LIST
     SIZE 13.43 BY 1 NO-UNDO.

DEFINE VARIABLE wclient AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .77 NO-UNDO.

DEFINE VARIABLE wcotiza AS CHARACTER FORMAT "XXX-XXXXXX":U 
     LABEL "Pedido #" 
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
      FacCPedi.NroPed COLUMN-LABEL "Pedido" FORMAT "XXX-XXXXXXXX":U
      FacCPedi.NomCli FORMAT "x(35)":U
      FacCPedi.CodVen COLUMN-LABEL "Ven." FORMAT "XXXX":U
      FacCPedi.FchPed COLUMN-LABEL "    Fecha      !   Emisión" FORMAT "99/99/9999":U
      X-VTA @ X-VTA COLUMN-LABEL "Tip. !Vta." FORMAT "xxxx":U
      FacCPedi.FmaPgo COLUMN-LABEL "Cond!Venta" FORMAT "X(4)":U
      X-DIAS @ X-DIAS COLUMN-LABEL "Dias" FORMAT "zzz9":U
      X-MON @ X-MON COLUMN-LABEL "Mon." FORMAT "x(4)":U
      FacCPedi.ImpTot FORMAT "->>,>>>,>>9.99":U
      X-CMPB @ X-CMPB COLUMN-LABEL "Docu" FORMAT "x(4)":U
      X-STA @ X-STA COLUMN-LABEL "Est." FORMAT "X(4)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 85.86 BY 10.42
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-3 AT ROW 1.23 COL 10.14 NO-LABEL
     wclient AT ROW 1.31 COL 32.43 COLON-ALIGNED
     wcotiza AT ROW 1.31 COL 32.43 COLON-ALIGNED
     br_table AT ROW 2.35 COL 1
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
         HEIGHT             = 11.77
         WIDTH              = 86.
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
/* BROWSE-TAB br_table wcotiza F-Main */
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
 AND integral.FacCPedi.CodDiv BEGINS S-CODDIV
 AND integral.FacCPedi.CodDoc BEGINS S-CODDOC
 AND integral.FacCpedi.Nomcli BEGINS wclient
 AND LOOKUP(integral.FacCPedi.FlgEst,'C,P') > 0"
     _JoinCode[2]      = "integral.gn-clie.CodCia = cl-codcia
  AND integral.gn-clie.CodCli = integral.FacCPedi.CodCli"
     _JoinCode[3]      = "integral.gn-ConVt.Codig = integral.FacCPedi.FmaPgo"
     _FldNameList[1]   > integral.FacCPedi.NroPed
"FacCPedi.NroPed" "Pedido" "XXX-XXXXXXXX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.FacCPedi.NomCli
"FacCPedi.NomCli" ? "x(35)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.FacCPedi.CodVen
"FacCPedi.CodVen" "Ven." "XXXX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > integral.FacCPedi.FchPed
"FacCPedi.FchPed" "    Fecha      !   Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"X-VTA @ X-VTA" "Tip. !Vta." "xxxx" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > integral.FacCPedi.FmaPgo
"FacCPedi.FmaPgo" "Cond!Venta" "X(4)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"X-DIAS @ X-DIAS" "Dias" "zzz9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"X-MON @ X-MON" "Mon." "x(4)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   = integral.FacCPedi.ImpTot
     _FldNameList[10]   > "_<CALC>"
"X-CMPB @ X-CMPB" "Docu" "x(4)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"X-STA @ X-STA" "Est." "X(4)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
    RUN vta\d-pedcon.r(Faccpedi.nroped,"PED").
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
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
       WHEN "Cotización" THEN
            wclient:visible = not wclient:visible.
  end case.         
  ASSIGN COMBO-BOX-3.
/* RUN abrir-QUERY.*/

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
ON LEAVE OF wcotiza IN FRAME F-Main /* Pedido # */
or "RETURN":U of wcotiza
DO:
  IF INPUT wcotiza = "" THEN RETURN.
  find first FacCpedi where FacCpedi.NroPed = substring(wcotiza:screen-value,1,3) +
             string(integer(substring(wcotiza:screen-value,5,6)),"999999") AND
             integral.FacCPedi.CodDoc = "COT" AND
             integral.FacCPedi.NomCli BEGINS wclient AND
             integral.FacCPedi.FlgEst BEGINS F-ESTADO NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCpedi THEN DO:
     MESSAGE " No.Cotización NO EXISTE "
     VIEW-AS ALERT-BOX ERROR.
     wcotiza:screen-value = "".
     RETURN.
  END.        
  R-coti = RECID(FacCpedi).
  REPOSITION BR_TABLE TO RECID R-coti.  
  RUN dispatch IN THIS-PROCEDURE('ROW-CHANGED':U). 
  IF ERROR-STATUS:ERROR THEN DO:
     MESSAGE " No. Cotización NO EXISTE "
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
    IF FacCPedi.CodMon = 1 THEN X-MON = "S/.".
    ELSE X-MON = "US$" .
            
    IF Faccpedi.FmaPgo = "000" THEN X-VTA = "CT".
    ELSE X-VTA = "CR".  
          
    IF Faccpedi.Flgest = 'P' THEN X-STA = 'PEN'.
    IF Faccpedi.Flgest = 'C' THEN X-STA = 'O/D'.               
    
    FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN X-DIAS = gn-convt.totdias.
    X-CMPB = FacCPedi.Cmpbnte.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Deta B-table-Win 
PROCEDURE Carga-Deta :
/*------------------------------------------------------------------------------
  Purpose:     Caso solo de Factura sin guia de remisión
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER X-CODDOC AS CHAR.
  DEFINE INPUT PARAMETER X-NROPED AS CHAR.
  
  FOR EACH FacDPedi WHERE FacDPedi.codcia = s-codcia AND
      FacDPedi.Coddoc = X-CODDOC AND FacDPedi.Nroped = X-NROPED NO-LOCK :
      FIND DETA WHERE DETA.CodCia = CcbDDocu.CodCia AND
           DETA.codmat = CcbDDocu.codmat NO-ERROR.
      IF NOT AVAILABLE DETA THEN CREATE DETA.
      ASSIGN DETA.CodCia = FacDPedi.CodCia
              DETA.codmat = FacDPedi.codmat 
              DETA.PreUni = FacDPedi.PreUni 
              DETA.Factor = FacDPedi.Factor 
              DETA.PorDto = FacDPedi.PorDto 
              DETA.PorDto2 = FacDPedi.PorDto2 
              DETA.PreBas = FacDPedi.PreBas 
              DETA.AftIgv = FacDPedi.AftIgv
              DETA.AftIsc = FacDPedi.AftIsc
              DETA.UndVta = FacDPedi.UndVta.
              DETA.CanDes = DETA.CanDes + (FacDPedi.CanPed - FacDPedi.CanAte).
      FIND Almmmatg WHERE Almmmatg.codcia = 1 AND Almmmatg.codmat = DETA.Codmat NO-LOCK NO-ERROR.
      IF AVAILABLE Almmmatg THEN DO:
          ASSIGN DETA.Implin = ROUND( DETA.PreUni * DETA.CanDes * (1 - DETA.Pordto / 100) * (1 - DETA.Pordto2 / 100), 2)
                 DETA.ImpDto = ROUND( DETA.PreUni * DETA.CanDes, 2) - DETA.Implin.
          IF DETA.AftIsc THEN 
             DETA.ImpIsc = ROUND(DETA.PreBas * DETA.CanDes * (Almmmatg.PorIsc / 100),4).
          IF DETA.AftIgv AND FacCPedi.Tipvta = 'CON IGV' THEN 
             DETA.ImpIgv = DETA.ImpLin - ROUND(DETA.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
      END.
  END.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Facturacion-Automatica B-table-Win 
PROCEDURE Facturacion-Automatica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-ruccli AS CHAR NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
  FIND FacDocum WHERE FacDocum.CodCia = S-CODCIA AND
       FacDocum.CodDoc = 'G/R' NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacDocum OR FacDocum.CodMov = 0 THEN DO:
     MESSAGE "Codigo de Documento no configurado" VIEW-AS ALERT-BOX ERROR.
     RETURN ERROR.
  END.
  S-CODMOV = FacDocum.CodMov.

  /* Verifica si tiene numero de RUC */
  FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND
       gn-clie.codcli = Faccpedi.codcli NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie THEN x-ruccli = gn-clie.ruc.
  IF FacCPedi.Cmpbnte = 'FAC' AND x-ruccli = ' ' THEN DO:
     MESSAGE 'No se encuentra registrado el numero de RUC' VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.
  
  F-ATE = "P".
  /* Graba Documentos */
  IF FacCPedi.Flgest = 'P' THEN DO:
     FIND FIRST B-CPedi WHERE B-CPedi.codcia = 1 AND B-CPedi.Coddoc = 'O/D' AND
          B-CPedi.Nroref = FacCPedi.Nroped AND B-CPedi.FlgEst <> 'A' NO-LOCK NO-ERROR.
     IF AVAILABLE B-CPedi THEN DO:
        MESSAGE 'Pedido registra Ordenes de Despacho Parciales' VIEW-AS ALERT-BOX.
        RETURN "ADM-ERROR".
     END.
     RUN Carga-DETA(FacCPedi.Coddoc, FacCPedi.Nroped).
     END.
  ELSE DO:
     FOR EACH B-CPedi WHERE B-CPedi.codcia = 1 AND B-CPedi.Coddoc = 'O/D' AND
         B-CPedi.Nroref = FacCPedi.Nroped AND B-CPedi.FlgEst = 'P' :
         IF B-CPedi.Flgsit = "P" THEN DO:
            MESSAGE "Orden de Despacho Pendiente por Confirmat" SKIP
                    B-CPedi.Coddoc + "  " + B-CPedi.Nroped VIEW-AS ALERT-BOX.
            RETURN "ADM-ERROR".
         END.
         RUN Genera-Guia (B-CPedi.Coddoc, B-CPedi.Nroped).
     END.
     F-ATE = " ".
  END.
  FIND FIRST DETA NO-LOCK NO-ERROR.
  IF NOT AVAILABLE DETA THEN DO:
     MESSAGE 'Pedido de Venta sin Ordenes de Despacho por Atender' VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.
  
  RUN Genera-Factura (FacCPedi.Cmpbnte).

  HIDE FRAME F-Proceso.

  /* Impresion de las Guias de Remision */
  DEFINE VAR I        AS INTEGER NO-UNDO.
  DEFINE VAR C-NRODOC AS CHAR NO-UNDO.
  IF C-NROGUI <> "" THEN DO ON ERROR UNDO, RETURN "ADM-ERROR":
     DO I = 1 TO NUM-ENTRIES(C-NROGUI):
        C-NRODOC = ENTRY(I,C-NROGUI).
        FIND B-CDocu WHERE B-CDocu.CodCia = S-CODCIA
             AND B-CDocu.CodDoc = "G/R" 
             AND B-CDocu.NroDoc = C-NroDoc NO-LOCK NO-ERROR.
        IF AVAILABLE B-CDocu AND B-CDocu.flgest <> 'A' THEN 
           RUN VTA\R-ImpGui.R(ROWID(B-CDocu)).
     END.
  END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Factura B-table-Win 
PROCEDURE Genera-Factura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER X-CODDOC AS CHAR.
  F-IGV = 0.
  F-ISC = 0.

  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
       FacCorre.CodDoc = X-CODDOC AND
       FacCorre.CodDiv = S-CODDIV AND
       FacCorre.NroSer = S-SERFAC NO-ERROR.
  IF AVAILABLE FacCorre THEN DO:
     CREATE CcbCDocu.
     ASSIGN 
        CcbCDocu.NroDoc      = STRING(S-SERFAC,'999') + STRING(FacCorre.Correlativo,'999999')
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
     S-CODALM = FacCorre.CodAlm.
  END.
  RELEASE FacCorre.

  DISPLAY CcbCDocu.Coddoc + CcbCDocu.Nrodoc @ Fi-Mensaje LABEL "Documento "
          FORMAT "X(11)" WITH FRAME F-Proceso.

  ASSIGN CcbCDocu.CodCia = S-CODCIA
         CcbCDocu.CodAlm = S-CODALM
         CcbCDocu.FchDoc = TODAY 
         CcbCDocu.FlgEst = "P"
         CcbCDocu.FlgAte = F-ATE
         CcbCDocu.CodDoc = X-CODDOC
         CcbCDocu.Codcli = FacCPedi.Codcli
         CcbCDocu.Nomcli = FacCPedi.NomCli
         CcbCDocu.Dircli = FacCPedi.DirCli
         CcbCDocu.CodMov = S-CODMOV 
         CcbCDocu.CodDiv = S-CODDIV
         CcbCDocu.CodPed = "PED"
         CcbCDocu.NroPed = FacCPedi.NROPED
         CcbCDocu.CodRef = "G/R"
         CcbCDocu.NroRef = C-NROGUI
         CcbCDocu.Tipo   = "OFICINA"
         CcbCDocu.TipVta = "2"
         CcbCDocu.TpoFac = "R"
         CcbCDocu.Fmapgo = FacCPedi.Fmapgo
         CcbCDocu.Glosa  = FacCPedi.Glosa
         CcbCDocu.Fchvto = TODAY
         CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
         CcbCDocu.PorIgv = FacCfgGn.PorIgv
         CcbCDocu.CodMon = FacCPedi.codmon
         CcbCDocu.CodVen = FacCPedi.CodVen
         Ccbcdocu.Impfle = FacCPedi.Impfle
         CcbCDocu.usuario = S-USER-ID.

  FIND gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt THEN 
     CcbCDocu.TipVta = IF gn-ConVt.TotDias = 0 THEN "1" ELSE "2".
     CcbCDocu.FchVto = CcbCDocu.FchDoc + INTEGER(ENTRY(NUM-ENTRIES(gn-ConVt.Vencmtos),gn-ConVt.Vencmtos)).

  FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
       gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie  THEN DO:
     ASSIGN CcbCDocu.CodDpto = gn-clie.CodDept 
            CcbCDocu.CodProv = gn-clie.CodProv 
            CcbCDocu.CodDist = gn-clie.CodDist
            CcbCDocu.Ruccli  = gn-clie.ruc.
  END.

  /* Genera Detalle */
  FOR EACH DETA NO-LOCK ON ERROR UNDO, RETURN "ADM-ERROR":
      IF DETA.CanDes > 0 THEN DO:
         CREATE CcbDDocu.
         ASSIGN CcbDDocu.CodCia = CcbCDocu.CodCia 
                CcbDDocu.CodDoc = CcbCDocu.CodDoc 
                CcbDDocu.NroDoc = CcbCDocu.NroDoc
                CcbDDocu.codmat = DETA.codmat 
                CcbDDocu.PreUni = DETA.PreUni 
                CcbDDocu.CanDes = DETA.CanDes 
                CcbDDocu.Factor = DETA.Factor 
                CcbDDocu.ImpIsc = DETA.ImpIsc
                CcbDDocu.ImpIgv = DETA.ImpIgv 
                CcbDDocu.ImpLin = DETA.ImpLin
                CcbDDocu.PorDto = DETA.PorDto 
                CcbDDocu.PorDto2 = DETA.PorDto2
                CcbDDocu.PreBas = DETA.PreBas 
                CcbDDocu.ImpDto = DETA.ImpDto
                CcbDDocu.AftIgv = DETA.AftIgv
                CcbDDocu.AftIsc = DETA.AftIsc
                CcbDDocu.UndVta = DETA.UndVta.
      END.
  END.
  
  /* Graba Totales */
  FOR EACH DETA NO-LOCK: 
      CcbCDocu.ImpDto = CcbCDocu.ImpDto + DETA.ImpDto.
      F-Igv = F-Igv + DETA.ImpIgv.
      F-Isc = F-Isc + DETA.ImpIsc.
      CcbCDocu.ImpTot = CcbCDocu.ImpTot + DETA.ImpLin.
      IF NOT DETA.AftIgv THEN CcbCDocu.ImpExo = CcbCDocu.ImpExo + DETA.ImpLin.
  END.
  CcbCDocu.ImpIgv = ROUND(F-IGV,2).
  CcbCDocu.ImpIsc = ROUND(F-ISC,2).
  CcbCDocu.ImpBrt = CcbCDocu.ImpTot - CcbCDocu.ImpIgv - CcbCDocu.ImpIsc + 
                    CcbCDocu.ImpDto - CcbCDocu.ImpExo.
  CcbCDocu.ImpVta = CcbCDocu.ImpBrt - CcbCDocu.ImpDto.
  IF FacCPedi.Tipvta = 'SIN IGV' THEN DO:
      CcbCDocu.ImpIgv = ROUND((CcbCDocu.ImpVta + CcbCDocu.ImpFle ) * (FacCfgGn.PorIgv / 100),2).
      CcbCDocu.Imptot = CcbCDocu.ImpVta + CcbCDocu.Impfle + CcbCDocu.Impigv. 
   END.
   IF CcbCDocu.ImpFle > 0 AND FacCPedi.Tipvta = 'CON IGV' THEN DO:
      CcbCDocu.ImpIgv = CcbCDocu.Impigv + ROUND(CcbCDocu.ImpFle * (FacCfgGn.PorIgv / 100),2).
      CcbCDocu.Imptot = CcbCDocu.Imptot + CcbCDocu.Impfle + ROUND(CcbCDocu.ImpFle * (FacCfgGn.PorIgv / 100),2).
   END.

  CcbCDocu.SdoAct = CcbCDocu.ImpTot.

  /* Cierra Pedidos */
  DO ON ERROR UNDO, RETURN "ADM-ERROR":
     FIND B-CPedi WHERE
          B-CPedi.CodCia = CcbCDocu.CodCia AND
          B-CPedi.CodDoc = CcbCDocu.Codped AND
          B-CPedi.NroPed = CcbCDocu.NroPed EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE B-CPedi THEN ASSIGN B-CPedi.FlgEst = "F".
     RELEASE B-CPedi.
  END.

  /* Actualiza Guias */
  DEFINE VAR I        AS INTEGER NO-UNDO.
  DEFINE VAR C-NRODOC AS CHAR NO-UNDO.
  IF C-NROGUI <> "" THEN DO ON ERROR UNDO, RETURN "ADM-ERROR":
     DO I = 1 TO NUM-ENTRIES(C-NROGUI):
        C-NRODOC = ENTRY(I,C-NROGUI).
        FIND B-CDocu WHERE B-CDocu.CodCia = S-CODCIA
             AND B-CDocu.CodDoc = "G/R" 
             AND B-CDocu.NroDoc = C-NroDoc EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE B-CDocu THEN DO :
           ASSIGN B-CDocu.FlgEst = "F"
                  B-CDocu.CodRef = CcbCDocu.CodDoc
                  B-CDocu.NroRef = CcbCDocu.NroDoc
                  B-CDocu.FchCan = CcbCDocu.FchDoc
                  B-CDocu.SdoAct = 0.
        END.
        RELEASE B-CDocu.
     END.
  END.

  /* Impresion de la Factura */
  DO ON ERROR UNDO, RETURN "ADM-ERROR":
     IF CcbCDocu.coddoc = "FAC" THEN DO:
        RUN VTA\R-IMPFAC.R(ROWID(CcbCDocu)).
     END.    
     IF CcbCDocu.coddoc = "BOL" THEN DO:
        RUN VTA\R-IMPBOL.R(ROWID(CcbCDocu)).
     END.
  END.
  RELEASE CcbCDocu.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Guia B-table-Win 
PROCEDURE Genera-Guia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER X-CODDOC AS CHAR.
  DEFINE INPUT PARAMETER X-NROPED AS CHAR.
  DEFINE VARIABLE R-ROWID AS ROWID.
  DEFINE VARIABLE I-NRO AS INTEGER INIT 0 NO-UNDO.
  F-IGV = 0.
  F-ISC = 0.
  
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
       FacCorre.CodDoc = 'G/R' AND
       FacCorre.CodDiv = S-CODDIV AND
       FacCorre.NroSer = S-SERGUI NO-ERROR.
     
  IF AVAILABLE FacCorre THEN DO:
     CREATE CcbCDocu.
     ASSIGN 
        CcbCDocu.NroDoc      = STRING(S-SERGUI,'999') + STRING(FacCorre.Correlativo,'999999')
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
     S-CODALM = FacCorre.CodAlm.
  END.
  RELEASE FacCorre.

  DISPLAY CcbCDocu.Nrodoc @ Fi-Mensaje LABEL "Guia de Remision "
          FORMAT "X(11)" WITH FRAME F-Proceso.
  
  C-NROGUI = C-NROGUI + (IF C-NROGUI = '' THEN CcbCDocu.Nrodoc ELSE ',' + CcbCDocu.Nrodoc).
  
  ASSIGN CcbCDocu.CodCia = S-CODCIA
         CcbCDocu.CodAlm = S-CODALM
         CcbCDocu.CodDiv = S-CODDIV
         CcbCDocu.CodDoc = 'G/R'
         CcbCDocu.Nomcli = B-CPEDI.NomCli
         CcbCDocu.Dircli = B-CPEDI.DirCli
         CcbCDocu.Ruccli = B-CPEDI.RucCli
         CcbCDocu.FchDoc = TODAY 
         CcbCDocu.Codmov = S-CODMOV
         CcbCDocu.CodAge = B-CPedi.CodTrans 
         CcbCDocu.LugEnt = B-CPedi.LugEnt 
         CcbCDocu.Glosa  = B-CPedi.Glosa
         CcbCDocu.CodPed = B-CPEDI.Coddoc
         CcbCDocu.NroPed = B-CPEDI.nroped
         CcbCDocu.Tipo   = "OFICINA"
         CcbCDocu.FchVto = TODAY 
         CcbCDocu.CodCli = B-CPEDI.CodCli
         CcbCDocu.CodVen = B-CPEDI.CodVen
         CcbCDocu.TipVta = "2"
         CcbCDocu.TpoFac = "R"
         CcbCDocu.FmaPgo = B-CPEDI.FmaPgo
         CcbCDocu.CodMon = B-CPEDI.CodMon
         CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
         CcbCDocu.PorIgv = FacCfgGn.PorIgv
         CcbCDocu.NroOrd = B-CPEDI.Nroref   /*B-CPEDI.ordcmp*/
         CcbCDocu.FlgEst = "P"
         CcbCDocu.FlgAte = F-ATE
         CcbCDocu.usuario = S-USER-ID.
  FIND gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt THEN 
     CcbCDocu.TipVta = IF gn-ConVt.TotDias = 0 THEN "1" ELSE "2".
     CcbCDocu.FchVto = CcbCDocu.FchDoc + INTEGER(ENTRY(NUM-ENTRIES(gn-ConVt.Vencmtos),gn-ConVt.Vencmtos)).

  FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
       gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie  THEN DO:
     ASSIGN CcbCDocu.CodDpto = gn-clie.CodDept 
            CcbCDocu.CodProv = gn-clie.CodProv 
            CcbCDocu.CodDist = gn-clie.CodDist.
  END.

  FOR EACH FacDPedi WHERE FacDPedi.codcia = s-codcia AND
      FacDPedi.Coddoc = X-CODDOC AND FacDPedi.Nroped = X-NROPED NO-LOCK :
       CREATE CcbDDocu. 
       ASSIGN CcbDDocu.CodCia = CcbCDocu.CodCia 
              CcbDDocu.CodDoc = CcbCDocu.CodDoc
              CcbDDocu.NroDoc = CcbCDocu.NroDoc
              CcbDDocu.codmat = FacDPedi.codmat 
              CcbDDocu.CanDes = (FacDPedi.CanPed - FacDPedi.CanAte)
              CcbDDocu.UndVta = FacDPedi.UndVta
              CcbDDocu.Factor = FacDPedi.Factor
              CcbDDocu.PreUni = FacDPedi.PreUni 
              CcbDDocu.PreBas = FacDPedi.PreBas
              CcbDDocu.PorDto = FacDPedi.PorDto 
              CcbDDocu.PorDto2 = FacDPedi.PorDto2
              CcbDDocu.Pesmat = FacDPedi.Pesmat
              CcbDDocu.ImpLin = FacDPedi.ImpLin 
              CcbDDocu.ImpIsc = FacDPedi.ImpIsc
              CcbDDocu.ImpIgv = FacDPedi.ImpIgv
              CcbDDocu.ImpDto = FacDPedi.ImpDto
              CcbDDocu.AftIsc = FacDPedi.AftIsc
              CcbDDocu.AftIgv = FacDPedi.AftIgv.

       CcbCDocu.ImpTot = CcbCDocu.ImpTot + CcbDDocu.ImpLin.
       CcbCDocu.ImpDto = CcbCDocu.ImpDto + CcbDDocu.ImpDto.
       IF NOT CcbDDocu.AftIgv THEN CcbCDocu.ImpExo = CcbCDocu.ImpExo + CcbDDocu.ImpLin.
       F-Igv = F-Igv + CcbDDocu.ImpIgv.
       F-Isc = F-Isc + CcbDDocu.ImpIsc.

       /* Carga Datos para generar la factura */
       FIND DETA WHERE DETA.CodCia = CcbDDocu.CodCia AND
            DETA.codmat = CcbDDocu.codmat NO-ERROR.
       IF NOT AVAILABLE DETA THEN CREATE DETA.
       ASSIGN DETA.CodCia = CcbDDocu.CodCia
              DETA.codmat = CcbDDocu.codmat 
              DETA.PreUni = CcbDDocu.PreUni 
              DETA.Factor = CcbDDocu.Factor 
              DETA.PorDto = CcbDDocu.PorDto 
              DETA.PorDto2 = CcbDDocu.PorDto2
              DETA.PreBas = CcbDDocu.PreBas
              DETA.Pesmat = CcbDDocu.Pesmat 
              DETA.AftIgv = CcbDDocu.AftIgv
              DETA.AftIsc = CcbDDocu.AftIsc
              DETA.UndVta = CcbDDocu.UndVta.
              DETA.CanDes = DETA.CanDes + CcbDDocu.CanDes.
       FIND Almmmatg WHERE Almmmatg.codcia = 1 AND Almmmatg.codmat = DETA.Codmat NO-LOCK NO-ERROR.
       IF AVAILABLE Almmmatg THEN DO:
          ASSIGN DETA.Implin = ROUND( DETA.PreUni * DETA.Candes * (1 - DETA.Pordto / 100) * (1 - DETA.Pordto2 / 100), 2)
                 DETA.ImpDto = ROUND( DETA.PreUni * DETA.Candes, 2) - DETA.Implin.
                 
          IF DETA.AftIsc THEN 
             DETA.ImpIsc = ROUND(DETA.PreBas * DETA.CanDes * (Almmmatg.PorIsc / 100),4).
          IF DETA.AftIgv AND FacCPedi.Tipvta = 'CON IGV' THEN 
             DETA.ImpIgv = DETA.ImpLin - ROUND(DETA.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
       END.
  END.

  CcbCDocu.ImpIgv = ROUND(F-IGV,2).
  CcbCDocu.ImpIsc = ROUND(F-ISC,2).
  CcbCDocu.ImpBrt = CcbCDocu.ImpTot - CcbCDocu.ImpIgv - CcbCDocu.ImpIsc + 
                     CcbCDocu.ImpDto - CcbCDocu.ImpExo.
  CcbCDocu.ImpVta = CcbCDocu.ImpBrt - CcbCDocu.ImpDto.
  IF FacCPedi.Tipvta = 'SIN IGV' THEN DO:
     CcbCDocu.ImpIgv = ROUND((CcbCDocu.ImpVta + CcbCDocu.ImpFle ) * (FacCfgGn.PorIgv / 100),2).
     CcbCDocu.Imptot = CcbCDocu.ImpVta + CcbCDocu.Impfle + CcbCDocu.Impigv. 
  END.
  CcbCDocu.SdoAct = CcbCDocu.ImpTot.
  
  RELEASE CcbCDocu.
  
  /* Actualiza Orden de Despacho */
  FOR EACH CcbDDocu OF CcbCDocu NO-LOCK
       ON ERROR UNDO, RETURN "ADM-ERROR":
      FIND FacDPedi WHERE 
           FacDPedi.CodCia = CcbCDocu.CodCia AND
           FacDPedi.CodDoc = X-CODDOC AND
           FacDPedi.NroPed = CcbCDocu.NroPed AND
           FacDPedi.CodMat = CcbDDocu.CodMat EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE FacDPedi THEN DO:
         ASSIGN FacDPedi.CanAte = FacDPedi.CanAte + CcbDDocu.CanDes.
         IF FacDPedi.CanAte > FacDPedi.CanPed THEN FacDPedi.CanAte = FacDPedi.CanPed.
         IF FacDPedi.CanAte < 0 THEN FacDPedi.CanAte = 0.
         IF FacDPedi.CanPed - FacDPedi.CanAte > 0 THEN I-NRO = 1.
/*         IF (FacDPedi.CanPed - FacDPedi.CanAte) = 0 THEN FacDPedi.FlgEst = "C".
         ELSE FacDPedi.FlgEst = "P".*/
      END.
      RELEASE FacDPedi.
  END.

  /* Cierra Orden de Despacho */
/*  DEFINE VARIABLE I-NRO AS INTEGER INIT 0 NO-UNDO.
  FOR EACH FacDPedi NO-LOCK WHERE 
         FacDPedi.CodCia = S-CODCIA AND
         FacDPedi.CodDoc = "O/D" AND
         FacDPedi.NroPed = CcbCDocu.NroPed:
      IF (FacDPedi.CanPed - FacDPedi.CanAte) > 0 THEN DO:
         I-NRO = 1.
         LEAVE.
      END.
  END.*/
  IF I-NRO = 0 THEN DO ON ERROR UNDO, RETURN "ADM-ERROR": 
     IF AVAILABLE B-CPedi THEN ASSIGN B-CPedi.FlgEst = "C".
  END.
  
END PROCEDURE.


/*
  FOR EACH FacDPedi WHERE FacDPedi.codcia = s-codcia AND
      FacDPedi.Coddoc = X-CODDOC AND FacDPedi.Nroped = X-NROPED NO-LOCK,
      EACH Almmmatg OF FacDPedi:
       CREATE CcbDDocu. 
       ASSIGN CcbDDocu.CodCia = CcbCDocu.CodCia 
              CcbDDocu.CodAlm = CcbCDocu.CodAlm 
              CcbDDocu.TipMov = "S" 
              CcbDDocu.Codmov = CcbCDocu.Codmov
              CcbDDocu.NroDoc = INTEGER(SUBSTRING(CcbCDocu.NroDoc,4,6))
              CcbDDocu.NroSer = INTEGER(SUBSTRING(CcbCDocu.NroDoc,1,3))
              CcbDDocu.CodMon = CcbCDocu.CodMon 
              CcbDDocu.FchDoc = CcbCDocu.FchDoc 
              CcbDDocu.TpoCmb = CcbCDocu.TpoCmb 
              CcbDDocu.codmat = FacDPedi.codmat 
              CcbDDocu.CanDes = (FacDPedi.CanPed - FacDPedi.CanAte)
              CcbDDocu.CodUnd = FacDPedi.UndVta
              CcbDDocu.Factor = FacDPedi.Factor
              CcbDDocu.Pesmat = (CcbDDocu.CanDes * Almmmatg.pesmat)
              CcbDDocu.PreUni = FacDPedi.PreUni 
              CcbDDocu.CodAjt = '' 
              CcbDDocu.PreBas = FacDPedi.PreBas
              CcbDDocu.PorDto = FacDPedi.PorDto 
              CcbDDocu.ImpLin = FacDPedi.ImpLin 
              CcbDDocu.ImpIsc = FacDPedi.ImpIsc
              CcbDDocu.ImpIgv = FacDPedi.ImpIgv
              CcbDDocu.ImpDto = FacDPedi.ImpDto
              CcbDDocu.AftIsc = FacDPedi.AftIsc
              CcbDDocu.AftIgv = FacDPedi.AftIgv
                     R-ROWID = ROWID(CcbDDocu).
              
       RUN ALM\ALMDGSTK (R-ROWID). 
       RUN ALM\ALMACPR1 (R-ROWID,"U"). 
       RUN ALM\ALMACPR2 (R-ROWID,"U"). 

       CcbCDocu.ImpTot = CcbCDocu.ImpTot + CcbDDocu.ImpLin.
       CcbCDocu.ImpDto = CcbCDocu.ImpDto + CcbDDocu.ImpDto.
       IF NOT CcbDDocu.AftIgv THEN CcbCDocu.ImpExo = CcbCDocu.ImpExo + CcbDDocu.ImpLin.
       F-Igv = F-Igv + CcbDDocu.ImpIgv.
       F-Isc = F-Isc + CcbDDocu.ImpIsc.

       /* Carga Datos para generar la factura */
       FIND DETA WHERE DETA.CodCia = CcbDDocu.CodCia AND
            DETA.codmat = CcbDDocu.codmat NO-ERROR.
       IF NOT AVAILABLE DETA THEN CREATE DETA.
       ASSIGN DETA.CodCia = CcbDDocu.CodCia
              DETA.codmat = CcbDDocu.codmat 
              DETA.PreUni = CcbDDocu.PreUni 
              DETA.Factor = CcbDDocu.Factor 
              DETA.PorDto = CcbDDocu.PorDto 
              DETA.PreBas = CcbDDocu.PreBas 
              DETA.AftIgv = CcbDDocu.AftIgv
              DETA.AftIsc = CcbDDocu.AftIsc
              DETA.UndVta = CcbDDocu.CodUnd.
              DETA.CanDes = DETA.CanDes + CcbDDocu.CanDes.
       IF AVAILABLE Almmmatg THEN DO:
          ASSIGN DETA.ImpDto = ROUND( DETA.PreUni * (DETA.PorDto / 100) * DETA.CanDes , 2 )
                 DETA.ImpLin = ROUND( DETA.PreUni * DETA.CanDes , 2 ) - DETA.ImpDto.
          IF DETA.AftIsc THEN 
             DETA.ImpIsc = ROUND(DETA.PreBas * DETA.CanDes * (Almmmatg.PorIsc / 100),4).
          IF DETA.AftIgv THEN 
             DETA.ImpIgv = DETA.ImpLin - ROUND(DETA.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
       END.
  END.
*/

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

  wclient:visible IN FRAME F-MAIN = not wclient:visible .

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

